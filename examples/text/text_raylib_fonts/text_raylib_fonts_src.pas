(*******************************************************************************************
*
*   raylib [text] example - raylib fonts loading
*
*   NOTE: raylib is distributed with some free to use fonts (even for commercial pourposes!)
*         To view details and credits for those fonts, check raylib license file
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit text_raylib_fonts_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  MAX_FONTS = 8;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
  Messages: array [0..MAX_FONTS-1] of string = (
    'ALAGARD FONT designed by Hewett Tsoi',
    'PIXELPLAY FONT designed by Aleksander Shevchuk',
    'MECHA FONT designed by Captain Falcon',
    'SETBACK FONT designed by Brian Kent (AEnigma)',
    'ROMULUS FONT designed by Hewett Tsoi',
    'PIXANTIQUA FONT designed by Gerhard Grossmann',
    'ALPHA_BETA FONT designed by Brian Kent (AEnigma)',
    'JUPITER_CRASH FONT designed by Brian Kent (AEnigma)'
  );
  Spacings: array [0..MAX_FONTS-1] of Integer = (2, 4, 8, 4, 3, 4, 4, 1);
var
  Fonts: array [0..MAX_FONTS-1] of TFont;
  Positions: array [0..MAX_FONTS-1] of TVector2;
  Colors: array of TColor;
  I: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [text] example - raylib fonts'));

  // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
  Fonts[0] := LoadFont(UTF8String('resources/text/fonts/alagard.png'));
  Fonts[1] := LoadFont(UTF8String('resources/text/fonts/pixelplay.png'));
  Fonts[2] := LoadFont(UTF8String('resources/text/fonts/mecha.png'));
  Fonts[3] := LoadFont(UTF8String('resources/text/fonts/setback.png'));
  Fonts[4] := LoadFont(UTF8String('resources/text/fonts/romulus.png'));
  Fonts[5] := LoadFont(UTF8String('resources/text/fonts/pixantiqua.png'));
  Fonts[6] := LoadFont(UTF8String('resources/text/fonts/alpha_beta.png'));
  Fonts[7] := LoadFont(UTF8String('resources/text/fonts/jupiter_crash.png'));

  for I := 0 to MAX_FONTS - 1 do
  begin
    Positions[I].X := ScreenWidth / 2.0 - MeasureTextEx(Fonts[I], PAnsiChar(UTF8String(Messages[I])), Fonts[I].BaseSize * 2.0, Spacings[I]).X / 2.0;
    Positions[I].Y := 60.0 + Fonts[I].BaseSize + 45.0 * I;
  end;

  // Small Y position corrections
  Positions[3].Y := Positions[3].Y + 8;
  Positions[4].Y := Positions[4].Y + 2;
  Positions[7].Y := Positions[7].Y - 8;

  Colors := [MAROON, ORANGE, DARKGREEN, DARKBLUE, DARKPURPLE, LIME, GOLD, RED];

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(UTF8String('free fonts included with raylib'), 250, 20, 20, DARKGRAY);
      DrawLine(220, 50, 590, 50, DARKGRAY);

      for I := 0 to MAX_FONTS - 1 do
        DrawTextEx(Fonts[I], PAnsiChar(UTF8String(Messages[I])), Positions[I], fonts[I].BaseSize * 2.0, Spacings[I], colors[I]);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  // Fonts unloading
  for I := 0 to MAX_FONTS - 1 do
    UnloadFont(Fonts[I]);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

