(*******************************************************************************************
*
*   raylib [models] example - loading gltf
*
*   Example originally created with raylib 3.7, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2020-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit models_loading_gltf_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib,
  raymath;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Camera: TCamera;
  Model: TModel;
  Position: TVector3;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - loading gltf'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(10.0, 10.0, 10.0); // Camera position
  Camera.Target := TVector3.Create(0.0, 0.0, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  // Loaf gltf model
  Model := LoadModel(UTF8String('resources/models/models/gltf/robot.glb'));

  Position := TVector3.Create(0.0, 0.0, 0.0);    // Set model position

  SetCameraMode(Camera, CAMERA_FREE); // Set free camera mode

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(SKYBLUE);

      BeginMode3D(Camera);

        DrawModel(Model, Position, 1.0, WHITE);
        DrawGrid(10, 1.0);         // Draw a grid

      EndMode3D();

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadModel(Model);         // Unload model

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

