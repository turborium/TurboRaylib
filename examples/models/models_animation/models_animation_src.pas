(*******************************************************************************************
*
*   raylib [models] example - Load 3d model with animations and play them
*
*   Example contributed by Culacant (@culacant) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2023 Culacant (@culacant) and Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************
*
*   NOTE: To export a model from blender, make sure it is not posed, the vertices need to be
*         in the same position as they would be in edit mode and the scale of your models is
*         set to 0. Scaling can be done from the export menu.
*
********************************************************************************************)
unit models_animation_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

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
  Camera: TCamera;
  Model: TModel;
  Texture: TTexture2D;
  Position: TVector3;
  AnimsCount: Cardinal;
  Anims: PModelAnimation;
  AnimFrameCounter: Integer;
  I: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - model animation'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(10.0, 10.0, 10.0); // Camera position
  Camera.Target := TVector3.Create(0.0, 0.0, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  Model := LoadModel(UTF8String('resources/models/models/iqm/guy.iqm'));        // Load the animated model mesh and basic data
  Texture := LoadTexture(UTF8String('resources/models/models/iqm/guytex.png')); // Load model texture and set material
  SetMaterialTexture(@Model.Materials[0], MATERIAL_MAP_DIFFUSE, Texture);       // Set model material map texture

  Position := TVector3.Create(0.0, 0.0, 0.0); // Set model position

  // Load animation data
  AnimsCount := 0;
  Anims := LoadModelAnimations(UTF8String('resources/models/models/iqm/guyanim.iqm'), @AnimsCount);
  AnimFrameCounter := 0;

  DisableCursor(); // Catch cursor

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera, CAMERA_FIRST_PERSON);

    // Play animation when spacebar is held down
    if IsKeyDown(KEY_SPACE) then
    begin
      Inc(AnimFrameCounter);
      UpdateModelAnimation(Model, Anims[0], AnimFrameCounter);
      if AnimFrameCounter >= Anims[0].FrameCount then
        AnimFrameCounter := 0;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        DrawModelEx(Model, Position, TVector3.Create(1.0, 0.0, 0.0), -90.0, TVector3.Create(1.0, 1.0, 1.0), WHITE);

        for I := 0 to Model.BoneCount - 1 do
        begin
          DrawCube(Anims[0].FramePoses[AnimFrameCounter][I].Translation, 0.2, 0.2, 0.2, RED);
        end;

        DrawGrid(10, 1.0); // Draw a grid

      EndMode3D();

      DrawText(UTF8String('PRESS SPACE to PLAY MODEL ANIMATION'), 10, 10, 20, MAROON);
      DrawText(UTF8String('(c) Guy IQM 3D model by @culacant'), ScreenWidth - 200, ScreenHeight - 20, 10, GRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Texture); // Unload texture

  // Unload model animations data
  UnloadModelAnimations(Anims, AnimsCount);

  UnloadModel(Model);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

