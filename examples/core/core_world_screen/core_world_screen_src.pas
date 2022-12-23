(*******************************************************************************************
*
*   raylib [core] example - World to screen
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.4
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit core_world_screen_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Camera: TCamera3D;
  CubePosition: TVector3;
  CubeScreenPosition : TVector2;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - core world screen'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera3D);
  Camera.Position := TVector3.Create(10.0, 10.0, 10.0); // Camera position
  Camera.Target := TVector3.Create(0.0, 0.0, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  CubePosition := TVector3.Create(0.0, 0.0, 0.0);
  CubeScreenPosition := TVector2.Create(0.0, 0.0);

  SetCameraMode(Camera, CAMERA_FREE); // Set a free camera mode

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    // TODO: Update your variables here
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera);

    // Calculate cube screen space position (with a little offset to be in top)
    CubeScreenPosition := GetWorldToScreen(TVector3.Create(CubePosition.X, CubePosition.Y + 2.5, CubePosition.Z), Camera);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        DrawCube(CubePosition, 2.0, 2.0, 2.0, RED);
        DrawCubeWires(CubePosition, 2.0, 2.0, 2.0, MAROON);

        DrawGrid(10, 1.0);

      EndMode3D();

      DrawText(
        UTF8String('Enemy: 100 / 100'),
        Trunc(CubeScreenPosition.X - MeasureText(UTF8String('Enemy: 100/100'), 20) / 2),
        Trunc(CubeScreenPosition.Y),
        20,
        BLACK
      );

      DrawText(
        UTF8String('Text is always on top of the cube'),
        Trunc((screenWidth - MeasureText(UTF8String('Text is always on top of the cube'), 20)) / 2),
        25,
        20,
        GRAY
      );

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

