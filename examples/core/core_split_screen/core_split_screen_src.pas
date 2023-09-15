(*******************************************************************************************
*
*   raylib [core] example - split screen
*
*   Example contributed by Jeffery Myers (@JeffM2501) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2021-2022 Jeffery Myers (@JeffM2501)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit core_split_screen_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

var
  CameraPlayer1: TCamera;
  CameraPlayer2: TCamera;

// Scene drawing
procedure DrawScene();
var
  Count: Integer;
  Spacing: Single;
  X, Z: Single;
begin
  Count := 5;
  Spacing := 4;

  // Grid of cube trees on a plane to make a "world"
  DrawPlane(TVector3.Create(0, 0, 0), TVector2.Create(50, 50), BEIGE); // Simple world plane

  X := -Count * Spacing;
  while X <= Count * Spacing do
  begin
    Z := -Count * Spacing;
    while Z <= Count * Spacing do
    begin
      DrawCube(TVector3.Create(X, 1.5, Z), 1, 1, 1, LIME);
      DrawCube(TVector3.Create(X, 0.5, Z), 0.25, 1, 0.25, BROWN);
      Z := Z + Spacing;
    end;
    X := X + Spacing;
  end;

  // Draw a cube at each player's position
  DrawCube(CameraPlayer1.Position, 1, 1, 1, RED);
  DrawCube(CameraPlayer2.Position, 1, 1, 1, BLUE);
end;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  ScreenPlayer1, ScreenPlayer2: TRenderTexture;
  SplitScreenRect: TRectangle;
  OffsetThisFrame: Single;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - split screen'));

  // Setup player 1 camera and screen
  CameraPlayer1.Fovy := 45.0;
  CameraPlayer1.Up.Y := 1.0;
  CameraPlayer1.Target.Y := 1.0;
  CameraPlayer1.Position.Z := -3.0;
  CameraPlayer1.Position.Y := 1.0;

  ScreenPlayer1 := LoadRenderTexture(ScreenWidth div 2, ScreenHeight);

  // Setup player 2 camera and screen
  CameraPlayer2.Fovy := 45.0;
  CameraPlayer2.Up.Y := 1.0;
  CameraPlayer2.Target.Y := 3.0;
  CameraPlayer2.Position.X := -3.0;
  CameraPlayer2.Position.Y := 3.0;

  ScreenPlayer2 := LoadRenderTexture(ScreenWidth div 2, ScreenHeight);

  // Build a flipped rectangle the size of the split view to use for drawing later
  SplitScreenRect := TRectangle.Create(0.0, 0.0, ScreenPlayer1.Texture.Width, -ScreenPlayer1.Texture.Height);

  SetTargetFPS(60);
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    // If anyone moves this frame, how far will they move based on the time since the last frame
    // this moves thigns at 10 world units per second, regardless of the actual FPS
    OffsetThisFrame := 10.0 * GetFrameTime();

    // Move Player1 forward and backwards (no turning)
    if IsKeyDown(KEY_W) then
    begin
      CameraPlayer1.Position.Z := CameraPlayer1.Position.Z + OffsetThisFrame;
      CameraPlayer1.Target.Z := CameraPlayer1.Target.Z + OffsetThisFrame;
    end
    else if IsKeyDown(KEY_S) then
    begin
      CameraPlayer1.Position.Z := CameraPlayer1.Position.Z - OffsetThisFrame;
      CameraPlayer1.Target.Z := CameraPlayer1.Target.Z - OffsetThisFrame;
    end;

    // Move Player2 forward and backwards (no turning)
    if IsKeyDown(KEY_UP) then
    begin
      CameraPlayer2.Position.X := CameraPlayer2.Position.X + OffsetThisFrame;
      CameraPlayer2.Target.X := CameraPlayer2.Target.X + OffsetThisFrame;
    end
    else if IsKeyDown(KEY_DOWN) then
    begin
      CameraPlayer2.Position.X := CameraPlayer2.Position.X - OffsetThisFrame;
      CameraPlayer2.Target.X := CameraPlayer2.Target.X - OffsetThisFrame;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    // Draw Player1 view to the render texture
    BeginTextureMode(ScreenPlayer1);
      ClearBackground(SKYBLUE);
      BeginMode3D(CameraPlayer1);
        DrawScene();
      EndMode3D();
      DrawText(UTF8String('PLAYER1 W/S to move'), 10, 10, 20, RED);
    EndTextureMode();

    // Draw Player2 view to the render texture
    BeginTextureMode(screenPlayer2);
      ClearBackground(SKYBLUE);
      BeginMode3D(cameraPlayer2);
        DrawScene();
      EndMode3D();
      DrawText(UTF8String('PLAYER2 UP/DOWN to move'), 10, 10, 20, BLUE);
    EndTextureMode();

    // Draw both views render textures to the screen side by side
    BeginDrawing();
      ClearBackground(BLACK);
      DrawTextureRec(ScreenPlayer1.Texture, SplitScreenRect, TVector2.Create(0, 0), WHITE);
      DrawTextureRec(ScreenPlayer2.Texture, SplitScreenRect, TVector2.Create(ScreenWidth / 2.0, 0), WHITE);
    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadRenderTexture(ScreenPlayer1); // Unload render texture
  UnloadRenderTexture(ScreenPlayer2); // Unload render texture

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

