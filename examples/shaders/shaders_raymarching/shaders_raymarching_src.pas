(*******************************************************************************************
*
*   raylib [shaders] example - Raymarching shapes generation
*
*   NOTE: This example requires raylib OpenGL 3.3 for shaders support and only #version 330
*         is currently supported. OpenGL ES 2.0 platforms are not supported at the moment.
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2018-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit shaders_raymarching_src;

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
  Shader: TShader;
  ViewEyeLoc, ViewCenterLoc, RunTimeLoc, ResolutionLoc: Integer;
  Resolution: array [0..1] of Single;
  RunTime, DeltaTime: Single;
  cameraPos, cameraTarget: array [0..2] of Single;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags({FLAG_MSAA_4X_HINT or} FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - raymarching shapes'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(2.5, 2.5, 3.0);  // Camera position
  Camera.Target := TVector3.Create(0.0, 0.0, 0.7);    // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);        // Camera up vector (rotation towards target)
  Camera.Fovy := 65.0;                                // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;            // Camera mode type

  Model := LoadModel(UTF8String('resources/shaders/models/church.obj'));               // Load OBJ model
  Texture := LoadTexture(UTF8String('resources/shaders/models/church_diffuse.png'));   // Load model texture (diffuse map)
  Model.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture;                     // Set model diffuse texture

  Position := TVector3.Create(0.0, 0.0, 0.0);                                    // Set model position

  // Load raymarching shader
  // NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
  Shader := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/raymarching.fs'), Integer(GLSL_VERSION)));

  // Get shader locations for required uniforms
  ViewEyeLoc := GetShaderLocation(Shader, UTF8String('viewEye'));
  ViewCenterLoc := GetShaderLocation(Shader, UTF8String('viewCenter'));
  RunTimeLoc := GetShaderLocation(Shader, UTF8String('runTime'));
  ResolutionLoc := GetShaderLocation(Shader, UTF8String('resolution'));

  Resolution[0] := ScreenWidth;
  Resolution[1] := ScreenHeight;
  SetShaderValue(Shader, ResolutionLoc, @Resolution, SHADER_UNIFORM_VEC2);

  RunTime := 0.0;

  DisableCursor();                    // Limit cursor to relative movement inside the window

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera, CAMERA_FIRST_PERSON);

    CameraPos[0] := Camera.Position.X; CameraPos[1] := Camera.Position.Y; CameraPos[2] := Camera.Position.Z;
    CameraTarget[0] := Camera.Target.X; CameraTarget[1] := Camera.Target.Y; CameraTarget[2] := Camera.Target.Z;

    DeltaTime := GetFrameTime();
    RunTime := RunTime + DeltaTime;

    // Set shader required uniform values
    SetShaderValue(Shader, ViewEyeLoc, @CameraPos, SHADER_UNIFORM_VEC3);
    SetShaderValue(Shader, ViewCenterLoc, @CameraTarget, SHADER_UNIFORM_VEC3);
    SetShaderValue(Shader, RunTimeLoc, @RunTime, SHADER_UNIFORM_FLOAT);

    // Check if screen is resized
    if IsWindowResized() then
    begin
      Resolution[0] := ScreenWidth;
      Resolution[1] := ScreenHeight;
      SetShaderValue(Shader, ResolutionLoc, @Resolution, SHADER_UNIFORM_VEC2);
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      // We only draw a white full-screen rectangle,
      // frame is generated in shader using raymarching
      BeginShaderMode(Shader);
        DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), WHITE);
      EndShaderMode();

      DrawText(UTF8String('(c) Raymarching shader by Iñigo Quilez. MIT License.'), GetScreenWidth() - 280, GetScreenHeight() - 20, 10, BLACK);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadShader(Shader);           // Unload shader

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

