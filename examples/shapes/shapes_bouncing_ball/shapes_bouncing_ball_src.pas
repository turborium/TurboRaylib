(*******************************************************************************************
*
*   raylib [shapes] example - bouncing ball
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2013-2022 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit shapes_bouncing_ball_src;

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
  BallPosition, BallSpeed: TVector2;
  BallRadius: Integer;
  Pause: Boolean;
  FramesCounter: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shapes] example - bouncing ball'));

  BallPosition := TVector2.Create(GetScreenWidth() / 2.0, GetScreenHeight() / 2.0);
  BallSpeed := TVector2.Create(5.0, 4.0);
  BallRadius := 20;

  Pause := False;
  FramesCounter := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyPressed(KEY_SPACE) then
      Pause := not Pause;

    if not Pause then
    begin
        BallPosition.X := BallPosition.X + BallSpeed.X;
        BallPosition.Y := BallPosition.Y + BallSpeed.Y;

        // Check walls collision for bouncing
        if ((BallPosition.X >= (GetScreenWidth() - BallRadius)) or (BallPosition.X <= BallRadius)) then
          BallSpeed.X := -BallSpeed.X;
        if ((BallPosition.Y >= (GetScreenHeight() - BallRadius)) or (BallPosition.Y <= BallRadius)) then
          BallSpeed.Y := -BallSpeed.Y;
    end else
      Inc(FramesCounter);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawCircleV(BallPosition, BallRadius, MAROON);
      DrawText(UTF8String('PRESS SPACE to PAUSE BALL MOVEMENT'), 10, GetScreenHeight() - 25, 20, LIGHTGRAY);

      // On pause, we draw a blinking message
      if Pause and (((FramesCounter div 30) mod 2) <> 0) then
        DrawText(UTF8String('PAUSED'), 350, 200, 30, GRAY);

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

