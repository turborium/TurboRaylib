(*******************************************************************************************
*
*   raylib [textures] example - Sprite animation
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit textures_sprite_anim_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  MAX_FRAME_SPEED = 15;
  MIN_FRAME_SPEED =  1;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Scarfy: TTexture2D;
  Position: TVector2;
  FrameRec: TRectangle;
  CurrentFrame, FramesCounter, FramesSpeed: Integer;
  I: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] example - background scrolling'));

  // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
  Scarfy := LoadTexture(UTF8String('resources/textures/scarfy.png'));        // Texture loading

  Position := TVector2.Create(350.0, 280.0);
  FrameRec := TRectangle.Create(0.0, 0.0, Scarfy.Width / 6, Scarfy.Height);
  CurrentFrame := 0;

  FramesCounter := 0;
  FramesSpeed := 8;            // Number of spritesheet frames shown by second

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    Inc(FramesCounter);

    if FramesCounter >= (60 div FramesSpeed) then
    begin
      FramesCounter := 0;
      Inc(CurrentFrame);

      if CurrentFrame > 5 then
        CurrentFrame := 0;

      FrameRec.X := CurrentFrame * Scarfy.Width / 6;
    end;

    // Control frames speed
    if IsKeyPressed(KEY_RIGHT) then
      Inc(FramesSpeed)
    else if IsKeyPressed(KEY_LEFT) then
      Dec(FramesSpeed);

    if FramesSpeed > MAX_FRAME_SPEED then
      FramesSpeed := MAX_FRAME_SPEED
    else if FramesSpeed < MIN_FRAME_SPEED then
      FramesSpeed := MIN_FRAME_SPEED;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawTexture(Scarfy, 15, 40, WHITE);
      DrawRectangleLines(15, 40, Scarfy.Width, Scarfy.Height, LIME);
      DrawRectangleLines(15 + Trunc(FrameRec.X), 40 + Trunc(FrameRec.Y), Trunc(FrameRec.Width), Trunc(FrameRec.Height), RED);

      DrawText(UTF8String('FRAME SPEED: '), 165, 210, 10, DARKGRAY);
      DrawText(TextFormat(UTF8String('%02i FPS'), FramesSpeed), 575, 210, 10, DARKGRAY);
      DrawText(UTF8String('PRESS RIGHT/LEFT KEYS to CHANGE SPEED!'), 290, 240, 10, DARKGRAY);

      for I := 0 to MAX_FRAME_SPEED - 1 do
      begin
          if I < FramesSpeed then
            DrawRectangle(250 + 21 * I, 205, 20, 20, RED);
          DrawRectangleLines(250 + 21 * I, 205, 20, 20, MAROON);
      end;

      DrawTextureRec(Scarfy, FrameRec, Position, WHITE);  // Draw part of the texture

      DrawText(UTF8String('(c) Scarfy sprite by Eiden Marsal'), ScreenWidth - 200, ScreenHeight - 20, 10, GRAY);
    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Scarfy);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

