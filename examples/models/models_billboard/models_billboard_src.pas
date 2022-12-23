(*******************************************************************************************
*
*   raylib [models] example - Drawing billboards
*
*   Example originally created with raylib 1.3, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit models_billboard_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

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
  Bill: TTexture2D;
  BillPositionStatic, BillPositionRotating, BillUp: TVector3;
  RotateOrigin: TVector2;
  Source: TRectangle;
  DistanceStatic, DistanceRotating, Rotation: Single;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - drawing billboards'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(5.0, 4.0, 5.0);    // Camera position
  Camera.Target := TVector3.Create(0.0, 2.0, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  Bill := LoadTexture(UTF8String('resources/models/billboard.png')); // Our billboard texture
  BillPositionStatic := TVector3.Create(0, 2, 0); // Position of billboard
  BillPositionRotating := TVector3.Create(1, 2, 1);

  // Entire billboard texture, source is used to take a segment from a larger texture.
  Source := TRectangle.Create(0.0, 0.0, Bill.Width, Bill.Height);

  // NOTE: Billboard locked on axis-Y
  BillUp := TVector3.Create(0.0, 1.0, 0.0);

  // Rotate around origin
  // Here we choose to rotate around the image center
  // NOTE: (-1, 1) is the range where origin.x, origin.y is inside the texture
  RotateOrigin := TVector2.Create(0.0, 0.0);
  SetCameraMode(Camera, CAMERA_ORBITAL); // Set an orbital camera mode

  // Distance is needed for the correct billboard draw order
  // Larger distance (further away from the camera) should be drawn prior to smaller distance.
  Rotation := 0.0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera);
    Rotation := Rotation + 0.4;
    DistanceStatic := Vector3Distance(Camera.Position, BillPositionStatic);
    DistanceRotating := Vector3Distance(Camera.Position, BillPositionRotating);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        DrawGrid(10, 1.0); // Draw a grid

        // Draw order matters!
        if DistanceStatic > DistanceRotating then
        begin
          DrawBillboard(Camera, Bill, BillPositionStatic, 2.0, WHITE);
          DrawBillboardPro(Camera, Bill, Source, BillPositionRotating, BillUp, TVector2.Create(1.0, 1.0), RotateOrigin, Rotation, WHITE);
        end else
        begin
          DrawBillboardPro(Camera, Bill, Source, BillPositionRotating, BillUp, TVector2.Create(1.0, 1.0), RotateOrigin, Rotation, WHITE);
          DrawBillboard(Camera, Bill, BillPositionStatic, 2.0, WHITE);
        end;

      EndMode3D();

      DrawFPS(10, 10);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Bill); // Unload texture

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

