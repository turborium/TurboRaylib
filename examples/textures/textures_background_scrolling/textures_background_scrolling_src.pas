(*******************************************************************************************
*
*   raylib [textures] example - Background scrolling
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit textures_background_scrolling_src;

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
  Background, Midground, Foreground: TTexture2D;
  ScrollingBack, ScrollingMid, ScrollingFore: Single;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] example - background scrolling'));

  // NOTE: Be careful, background width must be equal or bigger than screen width
  // if not, texture should be draw more than two times for scrolling effect
  Background := LoadTexture(UTF8String('resources/textures/cyberpunk_street_background.png'));
  Midground := LoadTexture(UTF8String('resources/textures/cyberpunk_street_midground.png'));
  Foreground := LoadTexture(UTF8String('resources/textures/cyberpunk_street_foreground.png'));

  ScrollingBack := 0.0;
  ScrollingMid := 0.0;
  ScrollingFore := 0.0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    ScrollingBack := ScrollingBack - 0.1;
    ScrollingMid := ScrollingMid - 0.5;
    ScrollingFore := ScrollingFore - 1.0;

    // NOTE: Texture is scaled twice its size, so it sould be considered on scrolling
    if ScrollingBack <= -Background.Width * 2 then
      ScrollingBack := 0;
    if ScrollingMid <= -Midground.Width * 2 then
      ScrollingMid := 0;
    if ScrollingFore <= -Foreground.Width * 2 then
      ScrollingFore := 0;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(GetColor($052c46ff));

      // Draw background image twice
      // NOTE: Texture is scaled twice its size
      DrawTextureEx(Background, TVector2.Create(ScrollingBack, 20), 0.0, 2.0, WHITE);
      DrawTextureEx(Background, TVector2.Create(Background.Width * 2 + ScrollingBack, 20), 0.0, 2.0, WHITE);

      // Draw midground image twice
      DrawTextureEx(Midground, TVector2.Create(ScrollingMid, 20), 0.0, 2.0, WHITE);
      DrawTextureEx(Midground, TVector2.Create(Midground.Width * 2 + ScrollingMid, 20), 0.0, 2.0, WHITE);

      // Draw foreground image twice
      DrawTextureEx(Foreground, TVector2.Create(ScrollingFore, 70), 0.0, 2.0, WHITE);
      DrawTextureEx(Foreground, TVector2.Create(Foreground.Width * 2 + ScrollingFore, 70), 0.0, 2.0, WHITE);

      DrawText(UTF8String('BACKGROUND SCROLLING & PARALLAX'), 10, 10, 20, RED);
      DrawText(UTF8String('(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)'), ScreenWidth - 330, ScreenHeight - 20, 10, RAYWHITE);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Background);  // Unload background texture
  UnloadTexture(Midground);   // Unload midground texture
  UnloadTexture(Foreground);  // Unload foreground texture

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

