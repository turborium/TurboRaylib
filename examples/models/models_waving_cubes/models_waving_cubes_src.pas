(*******************************************************************************************
*
*   raylib [models] example - Waving cubes
*
*   Example contributed by Codecat (@codecat) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2023 Codecat (@codecat) and Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit models_waving_cubes_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  rlgl,
  raylib,
  raymath;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
  numBlocks = 15;
var
  Camera: TCamera;
  Time, CameraTime: Double;
  Scale: Single;
  X, Y, Z: Integer;
  BlockScale, Scatter, CubeSize: Single;
  CubePos: TVector3;
  CubeColor: TColor;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - waving cubes'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(20.0, 30.0, 20.0); // Camera position
  Camera.Target := TVector3.Create(0.0, 0.0, 0.0);     // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);         // Camera up vector (rotation towards target)
  Camera.Fovy := 70.0;                                 // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;             // Camera mode type

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    Time := GetTime();

    // Calculate time scale for cube position and size
    Scale := (2.0 + Sin(Time)) * 0.7;

    // Move camera around the scene
    CameraTime := Time * 0.3;
    Camera.Position.X := Cos(CameraTime) * 40.0;
    Camera.Position.Z := Sin(CameraTime) * 40.0;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(camera);

        DrawGrid(10, 5.0);

        for X := 0 to NumBlocks - 1 do
        begin
          for Y := 0 to NumBlocks - 1 do
          begin
            for Z := 0 to NumBlocks - 1 do
            begin
              // Scale of the blocks depends on x/y/z positions
              BlockScale := (X + Y + Z) / 30.0;

              // Scatter makes the waving effect by adding blockScale over time
              Scatter := Sin(BlockScale * 20.0 + Time * 4.0);

              // Calculate the cube position
              CubePos := TVector3.Create(
                (X - NumBlocks / 2) * (Scale * 3.0) + Scatter,
                (Y - NumBlocks / 2) * (Scale * 2.0) + Scatter,
                (Z - NumBlocks / 2) * (Scale * 3.0) + Scatter
              );

              // Pick a color with a hue depending on cube position for the rainbow color effect
              CubeColor := ColorFromHSV((((X + Y + Z) * 18) mod 360), 0.75, 0.9);

              // Calculate cube size
              CubeSize := (2.4 - Scale) * BlockScale;

              // And finally, draw the cube!
              DrawCube(CubePos, CubeSize, CubeSize, CubeSize, CubeColor);
            end;
          end;
        end;

      EndMode3D();

      DrawFPS(10, 10);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

