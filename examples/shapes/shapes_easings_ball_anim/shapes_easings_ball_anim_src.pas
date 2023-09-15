(*******************************************************************************************
*
*   raylib [shapes] example - easings ball anim
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit shapes_easings_ball_anim_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  Math,
  raylib,
  reasings;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  BallPositionX: Integer;
  BallRadius: Integer;
  BallAlpha: Single;
  State: Integer;
  FramesCounter: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shapes] example - easings ball anim'));

  // Ball variable value to be animated with easings
  BallPositionX := -100;
  BallRadius := 20;
  BallAlpha := 0.0;

  State := 0;
  FramesCounter := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if State = 0 then // Move ball position X with easing
    begin
      Inc(FramesCounter);
      BallPositionX := Trunc(EaseElasticOut(FramesCounter, -100, ScreenWidth / 2.0 + 100, 120));

      if framesCounter >= 120 then
      begin
        FramesCounter := 0;
        State := 1;
      end;
    end
    else if State = 1 then // Increase ball radius with easing
    begin
      Inc(FramesCounter);
      BallRadius := Trunc(EaseElasticIn(FramesCounter, 20, 500, 200));

      if FramesCounter >= 200 then
      begin
        FramesCounter := 0;
        State := 2;
      end;
    end
    else if State = 2 then // Change ball alpha with easing (background color blending)
    begin
      Inc(FramesCounter);
      BallAlpha := EaseCubicOut(FramesCounter, 0.0, 1.0, 200);

      if FramesCounter >= 200 then
      begin
        FramesCounter := 0;
        State := 3;
      end;
    end
    else if State = 3 then // Reset state to play again
    begin
      if IsKeyPressed(KEY_ENTER) then
      begin
        // Reset required variables to play again
        BallPositionX := -100;
        BallRadius := 20;
        BallAlpha := 0.0;
        State := 0;
      end;
    end;

    if IsKeyPressed(KEY_R) then
      FramesCounter := 0;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      if State >= 2 then
        DrawRectangle(0, 0, ScreenWidth, ScreenHeight, GREEN);

      DrawCircle(BallPositionX, 200, BallRadius, Fade(RED, 1.0 - BallAlpha));

      if State = 3 then
        DrawText(UTF8String('PRESS [ENTER] TO PLAY AGAIN!'), 240, 200, 20, BLACK);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

