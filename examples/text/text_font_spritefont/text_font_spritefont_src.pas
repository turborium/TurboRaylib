(*******************************************************************************************
*
*   raylib [text] example - Sprite font loading
*
*   NOTE: Sprite fonts should be generated following this conventions:
*
*     - Characters must be ordered starting with character 32 (Space)
*     - Every character must be contained within the same Rectangle height
*     - Every character and every line must be separated by the same distance (margin/padding)
*     - Rectangles must be defined by a MAGENTA color background
*
*   Following those constraints, a font can be provided just by an image,
*   this is quite handy to avoid additional font descriptor files (like BMFonts use).
*
*   Example originally created with raylib 1.0, last time updated with raylib 1.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit text_font_spritefont_src;

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
  msg1: string = 'THIS IS A custom SPRITE FONT...';
  msg2: string = '...and this is ANOTHER CUSTOM font...';
  msg3: string = '...and a THIRD one! GREAT! :D';
var
  Font1, Font2, Font3: TFont;
  FontPosition1, FontPosition2, FontPosition3: TVector2;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [text] example - sprite font loading'));

  // NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)
  Font1 := LoadFont(UTF8String('resources/text/custom_mecha.png'));          // Font loading
  Font2 := LoadFont(UTF8String('resources/text/custom_alagard.png'));        // Font loading
  Font3 := LoadFont(UTF8String('resources/text/custom_jupiter_crash.png'));  // Font loading

  FontPosition1 := TVector2.Create(ScreenWidth / 2.0 - MeasureTextEx(Font1, PAnsiChar(UTF8String(Msg1)), Font1.BaseSize, -3).X / 2,
                                   ScreenHeight / 2.0 - Font1.BaseSize / 2.0 - 80.0);

  FontPosition2 := TVector2.Create(ScreenWidth / 2.0 - MeasureTextEx(Font2, PAnsiChar(UTF8String(Msg2)), Font2.BaseSize, -2.0).X / 2,
                                   ScreenHeight / 2.0 - Font2.BaseSize / 2.0 - 10.0);

  FontPosition3 := TVector2.Create(ScreenWidth / 2.0 - MeasureTextEx(Font3, PAnsiChar(UTF8String(Msg3)), Font3.BaseSize, 2).X / 2,
                                   ScreenHeight / 2.0 - Font1.BaseSize / 2.0 + 50.0);

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

      DrawTextEx(Font1, PAnsiChar(UTF8String(Msg1)), FontPosition1, Font1.BaseSize, -3, WHITE);
      DrawTextEx(Font2, PAnsiChar(UTF8String(Msg2)), FontPosition2, Font2.BaseSize, -2, WHITE);
      DrawTextEx(Font3, PAnsiChar(UTF8String(Msg3)), FontPosition3, Font3.BaseSize, 2, WHITE);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadFont(Font1);      // Font unloading
  UnloadFont(Font2);      // Font unloading
  UnloadFont(Font3);      // Font unloading

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

