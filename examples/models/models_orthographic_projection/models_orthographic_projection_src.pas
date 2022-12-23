(*******************************************************************************************
*
*   raylib [models] example - Show the difference between perspective and orthographic projection
*
*   Example originally created with raylib 2.0, last time updated with raylib 3.7
*
*   Example contributed by Max Danielsson (@autious) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2018-2022 Max Danielsson (@autious) and Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit models_orthographic_projection_src;

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
  FOVY_PERSPECTIVE   = 45.0;
  WIDTH_ORTHOGRAPHIC = 10.0;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Camera: TCamera;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - geometric shapes'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(0.0, 10.0, 10.0);  // Camera position
  Camera.Target := TVector3.Create(0.0, 0.0, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := FOVY_PERSPECTIVE;                      // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyPressed(KEY_SPACE) then
    begin
      if Camera.Projection = CAMERA_PERSPECTIVE then
      begin
        Camera.Fovy := WIDTH_ORTHOGRAPHIC;
        Camera.Projection := CAMERA_ORTHOGRAPHIC;
      end else
      begin
        Camera.Fovy := FOVY_PERSPECTIVE;
        Camera.Projection := CAMERA_PERSPECTIVE;
      end;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(camera);

        DrawCube(TVector3.Create(-4.0, 0.0, 2.0), 2.0, 5.0, 2.0, RED);
        DrawCubeWires(TVector3.Create(-4.0, 0.0, 2.0), 2.0, 5.0, 2.0, GOLD);
        DrawCubeWires(TVector3.Create(-4.0, 0.0, -2.0), 3.0, 6.0, 2.0, MAROON);

        DrawSphere(TVector3.Create(-1.0, 0.0, -2.0), 1.0, GREEN);
        DrawSphereWires(TVector3.Create(1.0, 0.0, 2.0), 2.0, 16, 16, LIME);

        DrawCylinder(TVector3.Create(4.0, 0.0, -2.0), 1.0, 2.0, 3.0, 4, SKYBLUE);
        DrawCylinderWires(TVector3.Create(4.0, 0.0, -2.0), 1.0, 2.0, 3.0, 4, DARKBLUE);
        DrawCylinderWires(TVector3.Create(4.5, -1.0, 2.0), 1.0, 1.0, 2.0, 6, BROWN);

        DrawCylinder(TVector3.Create(1.0, 0.0, -4.0), 0.0, 1.5, 3.0, 8, GOLD);
        DrawCylinderWires(TVector3.Create(1.0, 0.0, -4.0), 0.0, 1.5, 3.0, 8, PINK);

        DrawGrid(10, 1.0);        // Draw a grid

      EndMode3D();

      DrawText(UTF8String('Press Spacebar to switch camera type'), 10, GetScreenHeight() - 30, 20, DARKGRAY);

      if Camera.Projection = CAMERA_ORTHOGRAPHIC then
        DrawText(UTF8String('ORTHOGRAPHIC'), 10, 40, 20, BLACK)
      else if Camera.Projection = CAMERA_PERSPECTIVE then
        DrawText(UTF8String('PERSPECTIVE'), 10, 40, 20, BLACK);

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

