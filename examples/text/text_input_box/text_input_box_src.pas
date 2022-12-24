(*******************************************************************************************
*
*   raylib [text] example - Input Box
*
*   Example originally created with raylib 1.7, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit text_input_box_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  MAX_INPUT_CHARS = 9;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Name: string;
  TextBox: TRectangle;
  MouseOnText: Boolean;
  FramesCounter: Integer;
  Key: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [text] example - input box'));

  Name := '';

  TextBox := TRectangle.Create(ScreenWidth / 2.0 - 100, 180, 225, 50);

  FramesCounter := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if CheckCollisionPointRec(GetMousePosition(), TextBox) then
      MouseOnText := True
    else
      MouseOnText := False;

    if MouseOnText then
    begin
      // Set the window's cursor to the I-Beam
      SetMouseCursor(MOUSE_CURSOR_IBEAM);

      // Get char pressed (unicode character) on the queue
      Key := GetCharPressed();

      // Check if more characters have been pressed on the same frame
      while Key > 0 do
      begin
        // NOTE: Only allow keys in range [32..125]
        if (Key >= 32) and (Key <= 125) and (Length(Name) < MAX_INPUT_CHARS) then
          Name := Name + Char(Key);

          Key := GetCharPressed();  // Check next character in the queue
      end;

      if IsKeyPressed(KEY_BACKSPACE) and (Length(Name) > 0) then
        Delete(Name, Length(Name), 1);
    end else
      SetMouseCursor(MOUSE_CURSOR_DEFAULT);

    if MouseOnText then
      Inc(FramesCounter)
    else
      FramesCounter := 0;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(UTF8String('PLACE MOUSE OVER INPUT BOX!'), 240, 140, 20, GRAY);

      DrawRectangleRec(TextBox, LIGHTGRAY);
      if MouseOnText then
        DrawRectangleLines(Trunc(TextBox.X), Trunc(TextBox.Y), Trunc(TextBox.Width), Trunc(TextBox.Height), RED)
      else
        DrawRectangleLines(Trunc(TextBox.X), Trunc(TextBox.Y), Trunc(TextBox.Width), Trunc(TextBox.Height), DARKGRAY);

      DrawText(PAnsiChar(UTF8String(Name)), Trunc(TextBox.X) + 5, Trunc(TextBox.Y) + 8, 40, MAROON);

      DrawText(TextFormat(UTF8String('INPUT CHARS: %i/%i'), Length(Name), MAX_INPUT_CHARS), 315, 250, 20, DARKGRAY);

      if MouseOnText then
      begin
        if Length(Name) < MAX_INPUT_CHARS then
        begin
          // Draw blinking underscore char
          if ((FramesCounter div 20) mod 2) = 0 then
            DrawText(UTF8String('_'), Trunc(TextBox.X) + 8 + MeasureText(PAnsiChar(UTF8String(Name)), 40), Trunc(TextBox.Y) + 12, 40, MAROON);
        end else
          DrawText(UTF8String('Press BACKSPACE to delete chars...'), 230, 300, 20, GRAY);
      end;

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

