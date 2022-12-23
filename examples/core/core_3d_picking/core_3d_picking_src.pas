(*******************************************************************************************
*
*   raylib [core] example - Picking in 3d mode
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit core_3d_picking_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib in '..\..\..\raylib\raylib.pas';

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
  CubeSize: TVector3;
  Ray: TRay;
  Collision: TRayCollision;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - 3d picking'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera3D);
  Camera.Position := TVector3.Create(10.0, 10.0, 10.0); // Camera position
  Camera.Target := TVector3.Create(0.0, 0.0, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  CubePosition := TVector3.Create(0.0, 1.0, 0.0);
  CubeSize := TVector3.Create(2.0, 2.0, 2.0);

  Ray := Default(TRay); // Picking line ray

  Collision := Default(TRayCollision);

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

    if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) then
    begin
      if not Collision.Hit then
      begin
        Ray := GetMouseRay(GetMousePosition(), Camera);

        // Check collision between ray and box
        Collision := GetRayCollisionBox(
          Ray,
          TBoundingBox.Create(
            TVector3.Create(CubePosition.X - CubeSize.X / 2, CubePosition.Y - CubeSize.Y / 2, CubePosition.Z - CubeSize.Z / 2),
            TVector3.Create(CubePosition.X + CubeSize.X / 2, CubePosition.Y + CubeSize.Y / 2, CubePosition.Z + CubeSize.Z / 2)
          )
        );
      end else
        Collision.Hit := False;
    end;

    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        if Collision.Hit then
        begin
          DrawCube(CubePosition, CubeSize.X, CubeSize.Y, CubeSize.Z, RED);
          DrawCubeWires(CubePosition, CubeSize.X, CubeSize.Y, CubeSize.Z, MAROON);

          DrawCubeWires(CubePosition, CubeSize.X + 0.2, CubeSize.Y + 0.2, CubeSize.Z + 0.2, GREEN);
        end else
        begin
          DrawCube(CubePosition, CubeSize.X, CubeSize.Y, CubeSize.Z, GRAY);
          DrawCubeWires(CubePosition, CubeSize.X, CubeSize.Y, CubeSize.Z, DARKGRAY);
        end;

        DrawRay(Ray, MAROON);
        DrawGrid(10, 1.0);

      EndMode3D();

      DrawText(UTF8String('Try selecting the box with mouse!'), 240, 10, 20, DARKGRAY);

      if Collision.Hit then
        DrawText(UTF8String('BOX SELECTED'), (ScreenWidth - MeasureText(UTF8String('BOX SELECTED'), 30)) div 2, Trunc(ScreenHeight * 0.1), 30, GREEN);

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

