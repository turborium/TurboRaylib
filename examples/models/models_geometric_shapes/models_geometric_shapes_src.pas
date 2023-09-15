(*******************************************************************************************
*
*   raylib [models] example - Draw some basic geometric shapes (cube, sphere, cylinder...)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2022 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit models_geometric_shapes_src;

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
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - geometric shapes'));

  // Define the camera to look into our 3d world
  Camera := TCamera.Create(
    TVector3.Create(0.0, 10.0, 10.0),
    TVector3.Create(0.0, 0.0, 0.0),
    TVector3.Create(0.0, 1.0, 0.0),
    45.0,
    CAMERA_PERSPECTIVE);

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

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

        // DrawCapsule     (TVector3.Create(-3.0, 1.5, -4.0), TVector3.Create(-4.0, -1.0, -4.0), 1.2, 8, 8, VIOLET);
        //DrawCapsuleWires(TVector3.Create(-3.0, 1.5, -4.0), TVector3.Create(-4.0, -1.0, -4.0), 1.2, 8, 8, PURPLE);

        DrawGrid(10, 1.0);        // Draw a grid

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

