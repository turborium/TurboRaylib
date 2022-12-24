(*******************************************************************************************
*
*   raylib [shaders] example - Apply a postprocessing shader to a scene
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit shaders_postprocessing_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib,
  raymath;

const
  GLSL_VERSION = 330;

  MAX_POSTPRO_SHADERS = 12;

type PostproShader = (
    FX_GRAYSCALE,
    FX_POSTERIZATION,
    FX_DREAM_VISION,
    FX_PIXELIZER,
    FX_CROSS_HATCHING,
    FX_CROSS_STITCHING,
    FX_PREDATOR_VIEW,
    FX_SCANLINES,
    FX_FISHEYE,
    FX_SOBEL,
    FX_BLOOM,
    FX_BLUR
);

const
  PostproShaderText: array [PostproShader] of string = (
    'GRAYSCALE',
    'POSTERIZATION',
    'DREAM_VISION',
    'PIXELIZER',
    'CROSS_HATCHING',
    'CROSS_STITCHING',
    'PREDATOR_VIEW',
    'SCANLINES',
    'FISHEYE',
    'SOBEL',
    'BLOOM',
    'BLUR'
);

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Texture: TTexture2D;
  Camera: TCamera;
  Model: TModel;
  Position: TVector3;
  Shaders: array [PostproShader] of TShader;
  CurrentShader: PostproShader;
  Target: TRenderTexture2D;
  I: PostproShader;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - postprocessing shader'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(2.0, 3.0, 2.0);  // Camera position
  Camera.Target := TVector3.Create(0.0, 1.0, 0.0);    // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);        // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;            // Camera mode type

  Model := LoadModel(UTF8String('resources/shaders/models/church.obj'));               // Load OBJ model
  Texture := LoadTexture(UTF8String('resources/shaders/models/church_diffuse.png'));   // Load model texture (diffuse map)
  Model.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture;                     // Set model diffuse texture

  Position := TVector3.Create(0.0, 0.0, 0.0);                                    // Set model position

  // NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
  shaders[FX_GRAYSCALE] := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/grayscale.fs'), Integer(GLSL_VERSION)));
  shaders[FX_POSTERIZATION] := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/posterization.fs'), Integer(GLSL_VERSION)));
  shaders[FX_DREAM_VISION] := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/dream_vision.fs'), Integer(GLSL_VERSION)));
  shaders[FX_PIXELIZER] := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/pixelizer.fs'), Integer(GLSL_VERSION)));
  shaders[FX_CROSS_HATCHING] := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/cross_hatching.fs'), Integer(GLSL_VERSION)));
  shaders[FX_CROSS_STITCHING] := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/cross_stitching.fs'), Integer(GLSL_VERSION)));
  shaders[FX_PREDATOR_VIEW] := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/predator.fs'), Integer(GLSL_VERSION)));
  shaders[FX_SCANLINES] := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/scanlines.fs'), Integer(GLSL_VERSION)));
  shaders[FX_FISHEYE] := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/fisheye.fs'), Integer(GLSL_VERSION)));
  shaders[FX_SOBEL] := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/sobel.fs'), Integer(GLSL_VERSION)));
  shaders[FX_BLOOM] := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/bloom.fs'), Integer(GLSL_VERSION)));
  shaders[FX_BLUR] := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/blur.fs'), Integer(GLSL_VERSION)));

  CurrentShader := FX_GRAYSCALE;

  // Create a RenderTexture2D to be used for render to texture
  Target := LoadRenderTexture(ScreenWidth, ScreenHeight);

  // Setup orbital camera
  SetCameraMode(camera, CAMERA_ORBITAL);  // Set an orbital camera mode

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera);

    if IsKeyPressed(KEY_RIGHT) then
      if CurrentShader < High(PostproShader) then
        Inc(CurrentShader)
      else
        CurrentShader := Low(PostproShader)
    else if IsKeyPressed(KEY_LEFT) then
      if CurrentShader > Low(PostproShader) then
        Dec(CurrentShader)
      else
        CurrentShader := High(PostproShader);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginTextureMode(Target);       // Enable drawing to texture
      ClearBackground(RAYWHITE);  // Clear texture background

      BeginMode3D(Camera);        // Begin 3d mode drawing
        DrawModel(Model, Position, 0.1, WHITE);   // Draw 3d model with texture
        DrawGrid(10, 1.0);     // Draw a grid
      EndMode3D();                // End 3d mode drawing, returns to orthographic 2d mode
    EndTextureMode();               // End drawing to texture (now we have a texture available for next passes)

    BeginDrawing();
      ClearBackground(RAYWHITE);  // Clear screen background

      // Render generated texture using selected postprocessing shader
      BeginShaderMode(Shaders[CurrentShader]);
        // NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
        DrawTextureRec(Target.Texture, TRectangle.Create(0, 0, Target.Texture.Width, -Target.Texture.Height), TVector2.Create(0, 0), WHITE);
      EndShaderMode();

      // Draw 2d shapes and text over drawn texture
      DrawRectangle(0, 9, 580, 30, Fade(LIGHTGRAY, 0.7));

      DrawText(UTF8String('(c) Church 3D model by Alberto Cano'), ScreenWidth - 200, ScreenHeight - 20, 10, GRAY);
      DrawText(UTF8String('CURRENT POSTPRO SHADER:'), 10, 15, 20, BLACK);
      DrawText(PAnsiChar(UTF8String(PostproShaderText[CurrentShader])), 330, 15, 20, RED);
      DrawText(UTF8String('< >'), 540, 10, 30, DARKBLUE);
      DrawFPS(700, 15);
    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  // Unload all postpro shaders
  for I := Low(PostproShader) to High(PostproShader) do
     UnloadShader(Shaders[I]);

  UnloadTexture(texture);         // Unload texture
  UnloadModel(model);             // Unload model
  UnloadRenderTexture(target);    // Unload render texture


  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

