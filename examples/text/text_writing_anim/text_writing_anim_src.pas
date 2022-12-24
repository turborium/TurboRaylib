(*******************************************************************************************
*
*   raylib [text] example - Text Writing Animation
*
*   Example originally created with raylib 1.4, last time updated with raylib 1.4
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2016-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit text_writing_anim_src;

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
  Message: string;
  FramesCounter: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [text] example - text writing anim'));

  Message := 'This sample illustrates a text writing'#10'animation effect! Check it out! ;)';

  FramesCounter := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyDown(KEY_SPACE) then
      FramesCounter := FramesCounter + 8
    else
      FramesCounter := FramesCounter + 1;

    if IsKeyPressed(KEY_ENTER) then
      FramesCounter := 0;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(TextSubtext(PAnsiChar(UTF8String(Message)), 0, FramesCounter div 10), 210, 160, 20, MAROON);

      DrawText(UTF8String('PRESS [ENTER] to RESTART!'), 240, 260, 20, LIGHTGRAY);
      DrawText(UTF8String('PRESS [SPACE] to SPEED UP!'), 239, 300, 20, LIGHTGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

