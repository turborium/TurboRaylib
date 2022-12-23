(*******************************************************************************************
*
*   raylib [core] example - Keyboard input
*
*   Example originally created with raylib 1.0, last time updated with raylib 1.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit core_input_keys_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  BallPosition: TVector2;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - keyboard input'));

  BallPosition := TVector2.Create(ScreenWidth / 2, ScreenHeight / 2);

  SetTargetFPS(60);                 // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do  // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyDown(KEY_RIGHT) then
      BallPosition.X := BallPosition.X + 2.0;
    if IsKeyDown(KEY_LEFT) then
      BallPosition.X := BallPosition.X - 2.0;
    if IsKeyDown(KEY_UP) then
      BallPosition.Y := BallPosition.Y - 2.0;
    if IsKeyDown(KEY_DOWN) then
      BallPosition.Y := BallPosition.Y + 2.0;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(UTF8String('move the ball with arrow keys'), 10, 10, 20, DARKGRAY);

      DrawCircleV(BallPosition, 50, MAROON);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow();        // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.
