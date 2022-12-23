(*******************************************************************************************
*
*   raylib [models] example - Load models M3D
*
*   Example originally created with raylib 4.5-dev, last time updated with raylib 4.5-dev
*
*   Example contributed by bzt (@bztsrc) and reviewed by Ramon Santamaria (@raysan5)
*
*   NOTES:
*     - Model3D (M3D) fileformat specs: https://gitlab.com/bztsrc/model3d
*     - Bender M3D exported: https://gitlab.com/bztsrc/model3d/-/tree/master/blender
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2022 bzt (@bztsrc)
*
********************************************************************************************)
unit models_loading_m3d_src;

// THIS EXAMPLE IS NOT WORKING, I THINK THIS IS RAYLIB BUG

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
  Model: TModel;
  Position: TVector3;
  I: Integer;
  ModelFileName: string;
  IsDrawMesh, IsDrawSkeleton, IsAnimPlaying: Boolean;
  AnimsCount: Cardinal;
  AnimFrameCounter, AnimId: Integer;
  Anims: PModelAnimation;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - M3D model loading'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(1.5, 1.5, 1.5);    // Camera position
  Camera.Target := TVector3.Create(0.0, 0.4, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  Position := TVector3.Create(0, 0, 0);

  ModelFileName := 'resources/models/models/m3d/CesiumMan.m3d';
  IsDrawMesh := True;
  IsDrawSkeleton := True;
  IsAnimPlaying := False;   // Store anim state, what to draw

  // Load model
  Model := LoadModel(PAnsiChar(UTF8String(ModelFileName))); // Load the bind-pose model mesh and basic data

  // Load animations
  AnimsCount := 0;
  AnimFrameCounter := 0;
  AnimId := 0;
  Anims := LoadModelAnimations(PAnsiChar(UTF8String(ModelFileName)), @AnimsCount); // Load skeletal animation data

  SetCameraMode(camera, CAMERA_FREE);     // Set free camera mode

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera);

    if AnimsCount <> 0 then
    begin
      // Play animation when spacebar is held down (or step one frame with N)
      if IsKeyDown(KEY_SPACE) or IsKeyPressed(KEY_N) then
      begin
        Inc(AnimFrameCounter);

        if AnimFrameCounter >= Anims[AnimId].FrameCount then
          AnimFrameCounter := 0;

        UpdateModelAnimation(Model, Anims[AnimId], AnimFrameCounter);
        IsAnimPlaying := True;
      end;

      // Select animation by pressing A
      if IsKeyPressed(KEY_A) then
      begin
        AnimFrameCounter := 0;
        Inc(AnimId);

        if AnimId >= Integer(AnimsCount) then
          AnimId := 0;
        UpdateModelAnimation(Model, Anims[AnimId], 0);
        IsAnimPlaying := true;
      end;
    end;

    // Toggle skeleton drawing
    if IsKeyPressed(KEY_S) then
      IsDrawSkeleton := not IsDrawSkeleton;

    // Toggle mesh drawing
    if IsKeyPressed(KEY_M) then
      IsDrawMesh := not IsDrawMesh;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        // Draw 3d model with texture
        if IsDrawMesh then
          DrawModel(Model, Position, 1.0, WHITE);

        // Draw the animated skeleton
        if IsDrawSkeleton then
        begin
          // Loop to (boneCount - 1) because the last one is a special "no bone" bone,
          // needed to workaround buggy models
          // without a -1, we would always draw a cube at the origin
          for I := 0 to Model.BoneCount - 2 do
          begin
            // By default the model is loaded in bind-pose by LoadModel().
            // But if UpdateModelAnimation() has been called at least once
            // then the model is already in animation pose, so we need the animated skeleton
            if not IsAnimPlaying or (AnimsCount = 0) then
            begin
              // Display the bind-pose skeleton
              DrawCube(Model.BindPose[I].Translation, 0.04, 0.04, 0.04, RED);

              if Model.Bones[I].Parent >= 0 then
              begin
                DrawLine3D(Model.BindPose[I].Translation,
                  Model.BindPose[Model.Bones[I].Parent].Translation, RED);
              end;
            end else
            begin
              // Display the frame-pose skeleton
              DrawCube(Anims[AnimId].FramePoses[AnimFrameCounter][I].Translation, 0.05, 0.05, 0.05, RED);

              if Anims[AnimId].Bones[I].Parent >= 0 then
              begin
                DrawLine3D(Anims[AnimId].FramePoses[AnimFrameCounter][I].Translation,
                  Anims[AnimId].FramePoses[AnimFrameCounter][Anims[AnimId].Bones[I].Parent].Translation, RED);
              end;
            end;
          end;
        end;

        DrawGrid(10, 1.0);         // Draw a grid

      EndMode3D();

      DrawText(UTF8String('PRESS SPACE to PLAY MODEL ANIMATION'), 10, GetScreenHeight() - 60, 10, MAROON);
      DrawText(UTF8String('PRESS A to CYCLE THROUGH ANIMATIONS'), 10, GetScreenHeight() - 40, 10, DARKGRAY);
      DrawText(UTF8String('PRESS M to toggle MESH, S to toggle SKELETON DRAWING'), 10, GetScreenHeight() - 20, 10, DARKGRAY);
      DrawText(UTF8String('(c) CesiumMan model by KhronosGroup'), GetScreenWidth() - 210, GetScreenHeight() - 20, 10, GRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  // Unload model animations data
  UnloadModelAnimations(Anims, AnimsCount);

  UnloadModel(Model);         // Unload model


  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

