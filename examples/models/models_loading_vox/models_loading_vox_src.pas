(*******************************************************************************************
*
*   raylib [models] example - Load models vox (MagicaVoxel)
*
*   Example contributed by Johann Nadalutti (@procfxgen) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2021-2023 Johann Nadalutti (@procfxgen) and Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit models_loading_vox_src;

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
  MAX_VOX_FILES = 3;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
  VoxFileNames: array [0..MAX_VOX_FILES-1] of string = (
    'resources/models/models/vox/chr_knight.vox',
    'resources/models/models/vox/chr_sword.vox',
    'resources/models/models/vox/monu9.vox'
  );
var
  Camera: TCamera;
  Models: array [0..MAX_VOX_FILES-1] of TModel;
  I: Integer;
  T0, T1: Double;
  Bb: TBoundingBox;
  Center: TVector3;
  MatTranslate: TMatrix;
  CurrentModel: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - magicavoxel loading'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(10.0, 10.0, 10.0); // Camera position
  Camera.Target := TVector3.Create(0.0, 0.0, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  for I := 0 to MAX_VOX_FILES - 1 do
  begin
    T0 := GetTime() * 1000;
    Models[I] := LoadModel(PAnsiChar(UTF8String(VoxFileNames[I])));
    T1 := GetTime() * 1000;

    TraceLog(LOG_WARNING, TextFormat(UTF8String('[%s] File loaded in %.3f ms'), PAnsiChar(UTF8String(VoxFileNames[I])), t1 - t0));

    // Compute model translation matrix to center model on draw position (0, 0 , 0)
    Bb := GetModelBoundingBox(Models[I]);
    Center := Default(TVector3);
    Center.X := Bb.Min.X + ((Bb.Max.X - Bb.Min.X) / 2);
    Center.Z := Bb.Min.Z + ((Bb.Max.Z - Bb.Min.Z) / 2);

    MatTranslate := MatrixTranslate(-Center.X, 0, -Center.Z);
    Models[i].Transform := MatTranslate;
  end;

  CurrentModel := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera, CAMERA_ORBITAL);

    // Cycle between models on mouse click
    if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) then
      CurrentModel := (CurrentModel + 1) mod MAX_VOX_FILES;

    // Cycle between models on key pressed
    if IsKeyPressed(KEY_RIGHT) then
    begin
      Inc(CurrentModel);
      if CurrentModel >= MAX_VOX_FILES then
        CurrentModel := 0;
    end
    else if IsKeyPressed(KEY_LEFT) then
    begin
      Dec(CurrentModel);
      if CurrentModel < 0 then
        CurrentModel := MAX_VOX_FILES - 1;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      // Draw 3D model
      BeginMode3D(Camera);

        DrawModel(Models[CurrentModel], TVector3.Create(0, 0, 0), 1.0, WHITE);
        DrawGrid(10, 1.0);

      EndMode3D();

      // Display info
      DrawRectangle(10, 400, 310, 30, Fade(SKYBLUE, 0.5));
      DrawRectangleLines(10, 400, 310, 30, Fade(DARKBLUE, 0.5));
      DrawText(UTF8String('MOUSE LEFT BUTTON to CYCLE VOX MODELS'), 40, 410, 10, BLUE);
      DrawText(TextFormat(UTF8String('File: %s'), GetFileName(PAnsiChar(UTF8String(voxFileNames[currentModel])))), 10, 10, 20, GRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  // Unload models data (GPU VRAM)
  for I := 0 to MAX_VOX_FILES - 1 do
    UnloadModel(Models[I]);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

