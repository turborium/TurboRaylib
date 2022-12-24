(*******************************************************************************************
*
*   raylib [shaders] example - fog
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.7
*
*   Example contributed by Chris Camacho (@chriscamacho) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2022 Chris Camacho (@chriscamacho) and Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit shaders_fog_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib,
  raymath,
  rlights;

const
  GLSL_VERSION = 330;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Shader: TShader;
  Target: TRenderTexture2D;
  Camera: TCamera;
  ModelA, ModelB, ModelC: TModel;
  Texture: TTexture;
  AmbientLoc, FogDensityLoc: Integer;
  ShaderVal: array of Single;
  FogDensity: Single;
  I: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags({FLAG_MSAA_4X_HINT or} FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - fog'));

  // Define the camera to look into our 3d world
  Camera := TCamera.Create(
    TVector3.Create(2.0, 2.0, 6.0),      // position
    TVector3.Create(0.0, 0.5, 0.0),      // target
    TVector3.Create(0.0, 1.0, 0.0),      // up
    45.0, CAMERA_PERSPECTIVE             // fov, type
  );

  // Load models and texture
  ModelA := LoadModelFromMesh(GenMeshTorus(0.4, 1.0, 16, 32));
  ModelB := LoadModelFromMesh(GenMeshCube(1.0, 1.0, 1.0));
  ModelC := LoadModelFromMesh(GenMeshSphere(0.5, 32, 32));
  Texture := LoadTexture(UTF8String('resources/shaders/texel_checker.png'));

  // Assign texture to default model material
  ModelA.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture;
  ModelB.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture;
  ModelC.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture;

  // Load shader and set up some uniforms
  Shader := LoadShader(TextFormat(UTF8String('resources/shaders/shaders/glsl%i/lighting.vs'), Integer(GLSL_VERSION)),
                             TextFormat(UTF8String('resources/shaders/shaders/glsl%i/fog.fs'), Integer(GLSL_VERSION)));
  Shader.Locs[SHADER_LOC_MATRIX_MODEL] := GetShaderLocation(Shader, UTF8String('matModel'));
  Shader.Locs[SHADER_LOC_VECTOR_VIEW] := GetShaderLocation(Shader, UTF8String('viewPos'));

  Target := LoadRenderTexture(ScreenWidth, ScreenHeight);

  // Ambient light level
  AmbientLoc := GetShaderLocation(Shader, UTF8String('ambient'));
  ShaderVal := [0.2, 0.2, 0.2, 1.0];
  SetShaderValue(Shader, AmbientLoc, @ShaderVal[0], SHADER_UNIFORM_VEC4);

  FogDensity := 0.15;
  FogDensityLoc := GetShaderLocation(Shader, UTF8String('fogDensity'));
  SetShaderValue(Shader, FogDensityLoc, @FogDensity, SHADER_UNIFORM_FLOAT);

  // NOTE: All models share the same shader
  ModelA.Materials[0].Shader := Shader;
  ModelB.Materials[0].Shader := Shader;
  ModelC.Materials[0].Shader := Shader;

  // Using just 1 point lights
  CreateLight(LIGHT_POINT, TVector3.Create(0, 2, 6), Vector3Zero(), WHITE, Shader);

  SetCameraMode(Camera, CAMERA_ORBITAL);  // Set an orbital camera mode

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera);

    if IsKeyDown(KEY_UP) then
    begin
      FogDensity := FogDensity + 0.001;
      if FogDensity > 1.0 then
        FogDensity := 1.0;
    end;

    if IsKeyDown(KEY_DOWN) then
    begin
      FogDensity := FogDensity - 0.001;
      if FogDensity < 0.0 then
        FogDensity := 0.0;
    end;

    SetShaderValue(Shader, FogDensityLoc, @FogDensity, SHADER_UNIFORM_FLOAT);

    // Rotate the torus
    ModelA.Transform := MatrixMultiply(ModelA.Transform, MatrixRotateX(-0.025));
    ModelA.Transform := MatrixMultiply(ModelA.Transform, MatrixRotateZ(0.012));

    // Update the light shader with the camera view position
    SetShaderValue(Shader, Shader.Locs[SHADER_LOC_VECTOR_VIEW], @Camera.Position.X, SHADER_UNIFORM_VEC3);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
      BeginDrawing();

        ClearBackground(GRAY);

        BeginMode3D(Camera);

          // Draw the three models
          DrawModel(ModelA, Vector3Zero(), 1.0, WHITE);
          DrawModel(ModelB, TVector3.Create(-2.6, 0, 0), 1.0, WHITE);
          DrawModel(ModelC, TVector3.Create(2.6, 0, 0), 1.0, WHITE);

          for I := -10 to 10 - 1 do
            DrawModel(ModelA,TVector3.Create(I * 2, 0, 2), 1.0, WHITE);

        EndMode3D();

        DrawText(TextFormat(UTF8String('Use KEY_UP/KEY_DOWN to change fog density [%.2f]'), FogDensity), 10, 10, 20, RAYWHITE);

      EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadModel(ModelA);        // Unload the model A
  UnloadModel(ModelB);        // Unload the model B
  UnloadModel(ModelC);        // Unload the model C
  UnloadTexture(Texture);     // Unload the texture
  UnloadShader(Shader);       // Unload shader

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

