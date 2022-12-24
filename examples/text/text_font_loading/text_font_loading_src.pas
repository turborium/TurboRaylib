(*******************************************************************************************
*
*   raylib [text] example - Font loading
*
*   NOTE: raylib can load fonts from multiple input file formats:
*
*     - TTF/OTF > Sprite font atlas is generated on loading, user can configure
*                 some of the generation parameters (size, characters to include)
*     - BMFonts > Angel code font fileformat, sprite font image must be provided
*                 together with the .fnt file, font generation cna not be configured
*     - XNA Spritefont > Sprite font image, following XNA Spritefont conventions,
*                 Characters in image must follow some spacing and order rules
*
*   Example originally created with raylib 1.4, last time updated with raylib 3.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2016-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit text_font_loading_src;

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
  Msg: string;
  FontBm, FontTtf: TFont;
  UseTtf: Boolean;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [text] example - font loading'));

  // Define characters to draw
  // NOTE: raylib supports UTF-8 encoding, following list is actually codified as UTF8 internally
  Msg := '!\"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHI'#10'JKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmn'#10'opqrstuvwxyz{|}~¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓ'#10'ÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷'#10'øùúûüýþÿ';

  // NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

  // BMFont (AngelCode) : Font data and image atlas have been generated using external program
  FontBm := LoadFont(UTF8String('resources/text/pixantiqua.fnt'));

  // TTF font : Font data and atlas are generated directly from TTF
  // NOTE: We define a font base size of 32 pixels tall and up-to 250 characters
  FontTtf := LoadFontEx(UTF8String('resources/text/pixantiqua.ttf'), 32, nil, 250);

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyDown(KEY_SPACE) then
      UseTtf := True
    else
      UseTtf := False;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(UTF8String('Hold SPACE to use TTF generated font'), 20, 20, 20, LIGHTGRAY);

      if not UseTtf then
      begin
        DrawTextEx(FontBm, PAnsiChar(UTF8String(Msg)), TVector2.Create(20.0, 100.0), FontBm.BaseSize, 2, MAROON);
        DrawText(UTF8String('Using BMFont (Angelcode) imported'), 20, GetScreenHeight() - 30, 20, GRAY);
      end else
      begin
        DrawTextEx(fontTtf, PAnsiChar(UTF8String(Msg)),TVector2.Create(20.0, 100.0), FontBm.BaseSize, 2, LIME);
        DrawText(UTF8String('Using TTF font generated'), 20, GetScreenHeight() - 30, 20, GRAY);
      end;

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadFont(FontBm);     // AngelCode Font unloading
  UnloadFont(FontTtf);    // TTF Font unloading

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

