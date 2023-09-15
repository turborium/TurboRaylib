(*******************************************************************************************
*
*   raylib [core] example - Initialize 3d camera free
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit core_3d_camera_free_src;

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
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - 3d camera free'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera3D);
  Camera.Position := TVector3.Create(10.0, 10.0, 10.0); // Camera position
  Camera.Target := TVector3.Create(0.0, 0.0, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera projection type

  CubePosition := TVector3.Create(0.0, 0.0, 0.0);

  DisableCursor(); // Limit cursor to relative movement inside the window

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    // TODO: Update your variables here
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera, CAMERA_FREE);

    if IsKeyDown(KEY_Z) then
      Camera.Target := TVector3.Create(0.0, 0.0, 0.0);
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

      DrawRectangle(10, 10, 320, 133, Fade(SKYBLUE, 0.5));
      DrawRectangleLines(10, 10, 320, 133, BLUE);

      DrawText(UTF8String('Free camera default controls:'), 20, 20, 10, BLACK);
      DrawText(UTF8String('- Mouse Wheel to Zoom in-out'), 40, 40, 10, DARKGRAY);
      DrawText(UTF8String('- Mouse Wheel Pressed to Pan'), 40, 60, 10, DARKGRAY);
      DrawText(UTF8String('- Alt + Mouse Wheel Pressed to Rotate'), 40, 80, 10, DARKGRAY);
      DrawText(UTF8String('- Alt + Ctrl + Mouse Wheel Pressed for Smooth Zoom'), 40, 100, 10, DARKGRAY);
      DrawText(UTF8String('- Z to zoom to (0, 0, 0)'), 40, 120, 10, DARKGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

