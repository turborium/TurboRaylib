(*******************************************************************************************
*
*   raylib [models] example - loading gltf
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2020-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit models_loading_gltf_src;

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
  animsCount, animIndex, animCurrentFrame: Cardinal;
  ModelAnimations: PModelAnimation;
  Anim: TModelAnimation;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - loading gltf'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(5.0, 5.0, 5.0); // Camera position
  Camera.Target := TVector3.Create(0.0, 2.0, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  // Loaf gltf model
  Model := LoadModel(UTF8String('resources/models/models/gltf/robot.glb'));

  // Load gltf model animations
  AnimsCount := 0;
  AnimIndex := 0;
  AnimCurrentFrame := 0;
  ModelAnimations := LoadModelAnimations(UTF8String('resources/models/models/gltf/robot.glb'), @AnimsCount);

  Position := TVector3.Create(0.0, 0.0, 0.0);    // Set model position

  DisableCursor(); // Limit cursor to relative movement inside the window

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera, CAMERA_THIRD_PERSON);
    // Select current animation
    if IsKeyPressed(KEY_UP) then AnimIndex := (AnimIndex + 1) mod AnimsCount
    else if IsKeyPressed(KEY_DOWN) then AnimIndex := (AnimIndex + AnimsCount - 1) mod AnimsCount;
    // Update model animation
    Anim := ModelAnimations[AnimIndex];
    AnimCurrentFrame := (AnimCurrentFrame + 1) mod Cardinal(Anim.FrameCount);
    UpdateModelAnimation(Model, Anim, AnimCurrentFrame);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        DrawModel(Model, Position, 1.0, WHITE);    // Draw animated model
        DrawGrid(10, 1.0);         // Draw a grid

      EndMode3D();

      DrawText(UTF8String('Use the UP/DOWN arrow keys to switch animation'), 10, 10, 20, GRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadModel(Model);         // Unload model

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

