(*******************************************************************************************
*
*   raylib [models] example - Plane rotations (yaw, pitch, roll)
*
*   Example originally created with raylib 1.8, last time updated with raylib 4.0
*
*   Example contributed by Berni (@Berni8k) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2022 Berni (@Berni8k) and Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit models_yaw_pitch_roll_src;

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
var
  Camera: TCamera;
  Model: TModel;
  Texture: TTexture;
  Pitch, Roll, Yaw: Single;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - plane rotations (yaw, pitch, roll)'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(0.0, 50.0, -120.0); // Camera position
  Camera.Target := TVector3.Create(0.0, 0.0, 0.0);       // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);           // Camera up vector (rotation towards target)
  Camera.Fovy := 30.0;                                   // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;               // Camera mode type

  Model := LoadModel(UTF8String('resources/models/models/obj/plane.obj'));                  // Load model
  Texture := LoadTexture(UTF8String('resources/models/models/obj/plane_diffuse.png'));      // Load model texture
  Model.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture;                         // Set map diffuse texture

  Pitch := 0.0;
  Roll := 0.0;
  Yaw := 0.0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    // Plane pitch (x-axis) controls
    if IsKeyDown(KEY_DOWN) then
      Pitch := Pitch + 0.6
    else if IsKeyDown(KEY_UP) then
      Pitch := Pitch - 0.6
    else
    begin
      if Pitch > 0.3 then
        Pitch := Pitch - 0.3
      else if Pitch < -0.3 then
        Pitch := Pitch + 0.3;
    end;

    // Plane yaw (y-axis) controls
    if IsKeyDown(KEY_S) then
      Yaw := Yaw - 1.0
    else if IsKeyDown(KEY_A) then
      Yaw := Yaw + 1.0
    else
    begin
      if Yaw > 0.0 then
        Yaw := Yaw - 0.5
      else if Yaw < 0.0 then
        Yaw := Yaw + 0.5;
    end;

    // Plane roll (z-axis) controls
    if IsKeyDown(KEY_LEFT) then
      Roll := Roll - 1.0
    else if IsKeyDown(KEY_RIGHT) then
      Roll := Roll + 1.0
    else
    begin
      if Roll > 0.0 then
        Roll := Roll -  0.5
      else if Roll < 0.0 then
        Roll := Roll + 0.5;
    end;

    // Tranformation matrix for rotations
    Model.Transform := MatrixRotateXYZ(TVector3.Create(DEG2RAD * Pitch, DEG2RAD * Yaw, DEG2RAD * Roll));
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      // Draw 3D model (recomended to draw 3D always before 2D)
      BeginMode3D(Camera);

        DrawModel(Model, TVector3.Create(0.0, -8.0, 0.0), 1.0, WHITE);   // Draw 3d model with texture
        DrawGrid(10, 10.0);

      EndMode3D();

      // Draw controls info
      DrawRectangle(30, 370, 260, 70, Fade(GREEN, 0.5));
      DrawRectangleLines(30, 370, 260, 70, Fade(DARKGREEN, 0.5));
      DrawText(UTF8String('Pitch controlled with: KEY_UP / KEY_DOWN'), 40, 380, 10, DARKGRAY);
      DrawText(UTF8String('Roll controlled with: KEY_LEFT / KEY_RIGHT'), 40, 400, 10, DARKGRAY);
      DrawText(UTF8String('Yaw controlled with: KEY_A / KEY_S'), 40, 420, 10, DARKGRAY);

      DrawText(UTF8String('(c) WWI Plane Model created by GiaHanLam'), ScreenWidth - 240, ScreenHeight - 20, 10, DARKGRAY);


    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadModel(Model);     // Unload model data

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

