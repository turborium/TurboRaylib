(*******************************************************************************************
*
*   raylib [core] example - 3d camera first person
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.3
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit core_3d_camera_first_person_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  MAX_COLUMNS = 20;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Camera: TCamera3D;
  Heights: array [0..MAX_COLUMNS-1] of Single;
  Positions: array [0..MAX_COLUMNS-1] of TVector3;
  Colors: array [0..MAX_COLUMNS-1] of TColor;
  I: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - 3d camera first person'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera3D);
  Camera.Position := TVector3.Create(4.0, 2.0, 4.0);    // Camera position
  Camera.Target := TVector3.Create(0.0, 1.8, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 60.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  // Generates some random columns
  for I := 0 to MAX_COLUMNS - 1 do
  begin
    Heights[i] := GetRandomValue(1, 12);
    Positions[i] := TVector3.Create(GetRandomValue(-15, 15), Heights[i] / 2.0, GetRandomValue(-15, 15));
    Colors[i] := TColor.Create(GetRandomValue(20, 255), GetRandomValue(10, 55), 30, 255);
  end;

  SetCameraMode(Camera, CAMERA_FIRST_PERSON); // Set a first person camera mode

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
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        DrawPlane(TVector3.Create(0.0, 0.0, 0.0), TVector2.Create(32.0, 32.0), LIGHTGRAY); // Draw ground
        DrawCube(TVector3.Create(-16.0, 2.5, 0.0), 1.0, 5.0, 32.0, BLUE);                  // Draw a blue wall
        DrawCube(TVector3.Create(16.0, 2.5, 0.0), 1.0, 5.0, 32.0, LIME);                   // Draw a green wall
        DrawCube(TVector3.Create(0.0, 2.5, 16.0), 32.0, 5.0, 1.0, GOLD);                   // Draw a yellow wall

        // Draw some cubes around
        for I := 0 to MAX_COLUMNS - 1 do
        begin
          DrawCube(Positions[i], 2.0, Heights[i], 2.0, Colors[i]);
          DrawCubeWires(Positions[i], 2.0, Heights[i], 2.0, MAROON);
        end;

      EndMode3D();

      DrawRectangle(10, 10, 220, 70, Fade(SKYBLUE, 0.5));
      DrawRectangleLines( 10, 10, 220, 70, BLUE);

      DrawText(UTF8String('First person camera default controls:'), 20, 20, 10, BLACK);
      DrawText(UTF8String('- Move with keys: W, A, S, D'), 40, 40, 10, DARKGRAY);
      DrawText(UTF8String('- Mouse move to look around'), 40, 60, 10, DARKGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

