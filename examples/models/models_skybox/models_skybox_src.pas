(*******************************************************************************************
*
*   raylib [models] example - Skybox loading and drawing
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit models_skybox_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib,
  raymath,
  rlgl;

const
  GLSL_VERSION = 330;

// Generate cubemap texture from HDR texture
function GenTextureCubemap(Shader: TShader; Panorama: TTexture2D; Size: Integer; Format: Integer): TTextureCubemap;
var
  Rbo, Fbo: Cardinal;
  MatFboProjection: TMatrix;
  FboViews: array [0..5] of TMatrix;
  I: Integer;
begin
  Result := Default(TTextureCubemap);

  rlDisableBackfaceCulling();     // Disable backface culling to render inside the cube

  // STEP 1: Setup framebuffer
  //------------------------------------------------------------------------------------------
  Rbo := rlLoadTextureDepth(Size, Size, True);
  Result.Id := rlLoadTextureCubemap(nil, Size, Format);

  Fbo := rlLoadFramebuffer(Size, Size);
  rlFramebufferAttach(Fbo, Rbo, RL_ATTACHMENT_DEPTH, RL_ATTACHMENT_RENDERBUFFER, 0);
  rlFramebufferAttach(Fbo, Result.Id, RL_ATTACHMENT_COLOR_CHANNEL0, RL_ATTACHMENT_CUBEMAP_POSITIVE_X, 0);

  // Check if framebuffer is complete with attachments (valid)
  if rlFramebufferComplete(Fbo) then
    TraceLog(LOG_INFO, UTF8String('FBO: [ID %i] Framebuffer object created successfully'), Fbo);
  //------------------------------------------------------------------------------------------

  // STEP 2: Draw to framebuffer
  //------------------------------------------------------------------------------------------
  // NOTE: Shader is used to convert HDR equirectangular environment map to cubemap equivalent (6 faces)
  rlEnableShader(Shader.Id);

  // Define projection matrix and send it to shader
  MatFboProjection := MatrixPerspective(90.0 * DEG2RAD, 1.0, RL_CULL_DISTANCE_NEAR, RL_CULL_DISTANCE_FAR);
  rlSetUniformMatrix(Shader.Locs[SHADER_LOC_MATRIX_PROJECTION], MatFboProjection);

  // Define view matrix for every side of the cubemap
  FboViews[0] := MatrixLookAt(TVector3.Create(0.0, 0.0, 0.0), TVector3.Create( 1.0,  0.0,  0.0), TVector3.Create(0.0, -1.0,   0.0));
  FboViews[1] := MatrixLookAt(TVector3.Create(0.0, 0.0, 0.0), TVector3.Create(-1.0,  0.0,  0.0), TVector3.Create(0.0, -1.0,   0.0));
  FboViews[2] := MatrixLookAt(TVector3.Create(0.0, 0.0, 0.0), TVector3.Create( 0.0,  1.0,  0.0), TVector3.Create(0.0,  0.0,   1.0));
  FboViews[3] := MatrixLookAt(TVector3.Create(0.0, 0.0, 0.0), TVector3.Create( 0.0, -1.0,  0.0), TVector3.Create(0.0,  0.0,  -1.0));
  FboViews[4] := MatrixLookAt(TVector3.Create(0.0, 0.0, 0.0), TVector3.Create( 0.0,  0.0,  1.0), TVector3.Create(0.0, -1.0,   0.0));
  FboViews[5] := MatrixLookAt(TVector3.Create(0.0, 0.0, 0.0), TVector3.Create( 0.0,  0.0, -1.0), TVector3.Create(0.0, -1.0,   0.0));

  rlViewport(0, 0, Size, Size);   // Set viewport to current fbo dimensions

  // Activate and enable texture for drawing to cubemap faces
  rlActiveTextureSlot(0);
  rlEnableTexture(Panorama.Id);

  for I := 0 to 5 do
  begin
    // Set the view matrix for the current cube face
    rlSetUniformMatrix(Shader.Locs[SHADER_LOC_MATRIX_VIEW], FboViews[I]);

    // Select the current cubemap face attachment for the fbo
    // WARNING: This function by default enables->attach->disables fbo!!!
    rlFramebufferAttach(Fbo, Result.Id, RL_ATTACHMENT_COLOR_CHANNEL0, RL_ATTACHMENT_CUBEMAP_POSITIVE_X + I, 0);
    rlEnableFramebuffer(Fbo);

    // Load and draw a cube, it uses the current enabled texture
    rlClearScreenBuffers();
    rlLoadDrawCube();

    // ALTERNATIVE: Try to use internal batch system to draw the cube instead of rlLoadDrawCube
    // for some reason this method does not work, maybe due to cube triangles definition? normals pointing out?
    // TODO: Investigate this issue...
    //rlSetTexture(panorama.id); // WARNING: It must be called after enabling current framebuffer if using internal batch system!
    //rlClearScreenBuffers();
    //DrawCubeV(Vector3Zero(), Vector3One(), WHITE);
    //rlDrawRenderBatchActive();
  end;
  //------------------------------------------------------------------------------------------

  // STEP 3: Unload framebuffer and reset state
  //------------------------------------------------------------------------------------------
  rlDisableShader();          // Unbind shader
  rlDisableTexture();         // Unbind texture
  rlDisableFramebuffer();     // Unbind framebuffer
  rlUnloadFramebuffer(Fbo);   // Unload framebuffer (and automatically attached depth texture/renderbuffer)

  // Reset viewport dimensions to default
  rlViewport(0, 0, rlGetFramebufferWidth(), rlGetFramebufferHeight());
  rlEnableBackfaceCulling();
  //------------------------------------------------------------------------------------------

  Result.Width := Size;
  Result.Height := Size;
  Result.Mipmaps := 1;
  Result.Format := Format;
end;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Camera: TCamera;
  Cube: TMesh;
  Skybox: TModel;
  UseHDR: Boolean;
  MaterialVal: Integer;
  UseHDRVal: Integer;
  MapVal: Integer;
  ShdrCubemap: TShader;
  SkyboxFileName: string;
  Panorama: TTexture2D;
  Img: TImage;
  DroppedFiles: TFilePathList;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - skybox loading and drawing'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(1.0, 1.0, 1.0);    // Camera position
  Camera.Target := TVector3.Create(4.0, 1.0, 4.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  // Load skybox model
  Cube := GenMeshCube(1.0, 1.0, 1.0);
  Skybox := LoadModelFromMesh(Cube);

  UseHDR := True;

  // Load skybox shader and set required locations
  // NOTE: Some locations are automatically set at shader loading
  Skybox.Materials[0].Shader := LoadShader(
    TextFormat(UTF8String('resources/models/shaders/glsl%i/skybox.vs'), Integer(GLSL_VERSION)),
    TextFormat(UTF8String('resources/models/shaders/glsl%i/skybox.fs'), Integer(GLSL_VERSION))
  );

  MaterialVal := MATERIAL_MAP_CUBEMAP;
  if UseHDR then
    UseHDRVal := 1
  else
    UseHDRVal := 0;
  SetShaderValue(Skybox.Materials[0].Shader, GetShaderLocation(Skybox.Materials[0].Shader, UTF8String('environmentMap')), @MaterialVal, SHADER_UNIFORM_INT);
  SetShaderValue(Skybox.Materials[0].Shader, GetShaderLocation(Skybox.Materials[0].Shader, UTF8String('doGamma')), @UseHDRVal, SHADER_UNIFORM_INT);
  SetShaderValue(Skybox.Materials[0].Shader, GetShaderLocation(Skybox.Materials[0].Shader, UTF8String('vflipped')), @UseHDRVal, SHADER_UNIFORM_INT);

  // Load cubemap shader and setup required shader locations
  ShdrCubemap := LoadShader(
    TextFormat(UTF8String('resources/models/shaders/glsl%i/cubemap.vs'), Integer(GLSL_VERSION)),
    TextFormat(UTF8String('resources/models/shaders/glsl%i/cubemap.fs'), Integer(GLSL_VERSION))
  );

  MapVal := 0;
  SetShaderValue(ShdrCubemap, GetShaderLocation(ShdrCubemap, UTF8String('equirectangularMap')), @MapVal, SHADER_UNIFORM_INT);

  SkyboxFileName := '';

  if UseHDR then
  begin
    SkyboxFileName := 'resources/models/dresden_square_2k.hdr';

    // Load HDR panorama (sphere) texture
    Panorama := LoadTexture(PAnsiChar(UTF8String(SkyboxFileName)));

    // Generate cubemap (texture with 6 quads-cube-mapping) from panorama HDR texture
    // NOTE 1: New texture is generated rendering to texture, shader calculates the sphere->cube coordinates mapping
    // NOTE 2: It seems on some Android devices WebGL, fbo does not properly support a FLOAT-based attachment,
    // despite texture can be successfully created.. so using PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 instead of PIXELFORMAT_UNCOMPRESSED_R32G32B32A32
    Skybox.Materials[0].Maps[MATERIAL_MAP_CUBEMAP].Texture := GenTextureCubemap(ShdrCubemap, Panorama, 1024, PIXELFORMAT_UNCOMPRESSED_R8G8B8A8);

    //UnloadTexture(panorama);    // Texture not required anymore, cubemap already generated
  end else
  begin
    Img := LoadImage(UTF8String('resources/models/skybox.png'));
    Skybox.Materials[0].Maps[MATERIAL_MAP_CUBEMAP].Texture := LoadTextureCubemap(Img, CUBEMAP_LAYOUT_AUTO_DETECT);    // CUBEMAP_LAYOUT_PANORAMA
    UnloadImage(Img);
  end;

  DisableCursor();                    // Limit cursor to relative movement inside the window

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera, CAMERA_FIRST_PERSON);

    // Load new cubemap texture on drag&drop
    if IsFileDropped() then
    begin
      DroppedFiles := LoadDroppedFiles();

      if DroppedFiles.Count = 1 then         // Only support one file dropped
      begin
        if IsFileExtension(DroppedFiles.Paths[0], UTF8String('.png;.jpg;.hdr;.bmp;.tga')) then
        begin
          // Unload current cubemap texture and load new one
          UnloadTexture(Skybox.Materials[0].Maps[MATERIAL_MAP_CUBEMAP].Texture);
          if UseHDR then
          begin
            Panorama := LoadTexture(DroppedFiles.Paths[0]);

            // Generate cubemap from panorama texture
            Skybox.Materials[0].Maps[MATERIAL_MAP_CUBEMAP].Texture := GenTextureCubemap(ShdrCubemap, Panorama, 1024, PIXELFORMAT_UNCOMPRESSED_R8G8B8A8);
            UnloadTexture(Panorama);
          end else
          begin
            Img := LoadImage(DroppedFiles.Paths[0]);
            Skybox.Materials[0].Maps[MATERIAL_MAP_CUBEMAP].Texture := LoadTextureCubemap(Img, CUBEMAP_LAYOUT_AUTO_DETECT);
            UnloadImage(Img);
          end;

          SkyboxFileName := string(UTF8String(DroppedFiles.Paths[0]));
        end;
      end;

      UnloadDroppedFiles(DroppedFiles);    // Unload filepaths from memory
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        // We are inside the cube, we need to disable backface culling!
        rlDisableBackfaceCulling();
        rlDisableDepthMask();
          DrawModel(Skybox, TVector3.Create(0, 0, 0), 1.0, WHITE);
        rlEnableBackfaceCulling();
        rlEnableDepthMask();

        DrawGrid(10, 1.0);

      EndMode3D();

      //DrawTextureEx(panorama, (Vector2){ 0, 0 }, 0.0f, 0.5f, WHITE);

      if UseHDR then
        DrawText(TextFormat(UTF8String('Panorama image from hdrihaven.com: %s'), GetFileName(PAnsiChar(UTF8String(SkyboxFileName)))), 10, GetScreenHeight() - 20, 10, BLACK)
      else
        DrawText(TextFormat(UTF8String(': %s'), PAnsiChar(UTF8String(SkyboxFileName))), 10, GetScreenHeight() - 20, 10, BLACK);

      DrawFPS(10, 10);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadShader(Skybox.Materials[0].Shader);
  UnloadTexture(Skybox.Materials[0].Maps[MATERIAL_MAP_CUBEMAP].Texture);

  UnloadModel(skybox);        // Unload skybox model

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.
