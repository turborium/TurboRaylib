(*******************************************************************************************
*
*   raylib [shaders] example - basic lighting
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
*
*   Example originally created with raylib 3.0, last time updated with raylib 4.2
*
*   Example contributed by Chris Camacho (@codifies) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2022 Chris Camacho (@codifies) and Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit shaders_basic_lighting_src;

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
  Camera: TCamera;
  Model, Cube: TModel;
  Shader: TShader;
  AmbientLoc: Integer;
  ShaderValue, CameraPos: array of Single;
  Lights: array [0..MAX_LIGHTS - 1] of TLight;
  I: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - basic lighting'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(2.0, 4.0, 6.0);  // Camera position
  Camera.Target := TVector3.Create(0.0, 0.5, 0.0);    // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);        // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;            // Camera mode type

  // Load plane model from a generated mesh
  Model := LoadModelFromMesh(GenMeshPlane(10.0, 10.0, 3, 3));
  Cube := LoadModelFromMesh(GenMeshCube(2.0, 4.0, 2.0));

  // Load basic lighting shader
  Shader := LoadShader(
    TextFormat(UTF8String('resources/shaders/shaders/glsl%i/lighting.vs'), GLSL_VERSION),
    TextFormat(UTF8String('resources/shaders/shaders/glsl%i/lighting.fs'), GLSL_VERSION));

  // Get some required shader locations
  Shader.Locs[SHADER_LOC_VECTOR_VIEW] := GetShaderLocation(Shader, 'viewPos');
  // NOTE: "matModel" location name is automatically assigned on shader loading,
  // no need to get the location again if using that uniform name
  //shader.locs[SHADER_LOC_MATRIX_MODEL] = GetShaderLocation(shader, "matModel");

  // Ambient light level (some basic lighting)
  AmbientLoc := GetShaderLocation(Shader, 'ambient');
  ShaderValue := [0.1, 0.1, 0.1, 1.0];
  SetShaderValue(Shader, AmbientLoc, @ShaderValue[0], SHADER_UNIFORM_VEC4);

  // Assign out lighting shader to model
  Model.Materials[0].Shader := Shader;
  Cube.Materials[0].Shader := Shader;

  // Create lights
  Lights[0] := CreateLight(LIGHT_POINT, TVector3.Create(-2, 1, -2), Vector3Zero(), YELLOW, Shader);
  Lights[1] := CreateLight(LIGHT_POINT, TVector3.Create(2, 1, 2), Vector3Zero(), RED, Shader);
  Lights[2] := CreateLight(LIGHT_POINT, TVector3.Create(-2, 1, 2), Vector3Zero(), GREEN, Shader);
  Lights[3] := CreateLight(LIGHT_POINT, TVector3.Create(2, 1, -2), Vector3Zero(), BLUE, Shader);

  SetCameraMode(Camera, CAMERA_ORBITAL);  // Set an orbital camera mode

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera);

    // Update the shader with the camera view vector (points towards { 0.0f, 0.0f, 0.0f })
    CameraPos := [Camera.Position.X, Camera.Position.Y, Camera.Position.Z];
    SetShaderValue(Shader, Shader.Locs[SHADER_LOC_VECTOR_VIEW], CameraPos, SHADER_UNIFORM_VEC3);

    // Check key inputs to enable/disable lights
    if IsKeyPressed(KEY_Y) then
      Lights[0].Enabled := not Lights[0].enabled;
    if IsKeyPressed(KEY_R) then
      Lights[1].Enabled := not Lights[1].enabled;
    if IsKeyPressed(KEY_G) then
      Lights[2].Enabled := not Lights[2].enabled;
    if IsKeyPressed(KEY_B) then
      Lights[3].Enabled := not Lights[3].enabled;

    // Update light values (actually, only enable/disable them)
    for I := 0 to MAX_LIGHTS - 1 do
      UpdateLightValues(Shader, Lights[I]);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        DrawModel(Model, Vector3Zero(), 1.0, WHITE);
        DrawModel(Cube, Vector3Zero(), 1.0, WHITE);

        // Draw spheres to show where the lights are
        for I := 0 to MAX_LIGHTS - 1 do
        begin
          if Lights[I].Enabled then
            DrawSphereEx(Lights[I].Position, 0.2, 8, 8, Lights[I].Color)
          else
            DrawSphereWires(Lights[I].Position, 0.2, 8, 8, ColorAlpha(Lights[I].Color, 0.3));
        end;

        DrawGrid(10, 1.0);

      EndMode3D();

      DrawFPS(10, 10);

      DrawText(UTF8String('Use keys [Y][R][G][B] to toggle lights'), 10, 40, 20, DARKGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

