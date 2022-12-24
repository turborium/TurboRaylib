(*******************************************************************************************
*
*   raylib [texture] example - Image text drawing using TTF generated font
*
*   Example originally created with raylib 1.8, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit textures_image_text_src;

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
  Texture: TTexture2D;
  Parrots: TImage;
  Font: TFont;
  Position: TVector2;
  ShowFont: Boolean;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [texture] example - image text drawing'));

  Parrots := LoadImage(UTF8String('resources/textures/parrots.png')); // Load image in CPU memory (RAM)

  // TTF Font loading with custom generation parameters
  Font := LoadFontEx(UTF8String('resources/textures/KAISG.ttf'), 64, nil, 0);

  // Draw over image using custom font
  ImageDrawTextEx(@Parrots, font, UTF8String('[Parrots font drawing]'), TVector2.Create(20.0, 20.0), Font.BaseSize, 0.0, RED);

  Texture := LoadTextureFromImage(Parrots);  // Image converted to texture, uploaded to GPU memory (VRAM)
  UnloadImage(Parrots);   // Once image has been converted to texture and uploaded to VRAM, it can be unloaded from RAM

  Position := TVector2.Create(ScreenWidth / 2 - Texture.Width / 2, ScreenHeight / 2 - Texture.Height / 2 - 20);

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyDown(KEY_SPACE) then
      ShowFont := True
    else
      ShowFont := False;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      if not ShowFont then
      begin
        // Draw texture with text already drawn inside
        DrawTextureV(Texture, Position, WHITE);

        // Draw text directly using sprite font
        DrawTextEx(Font, UTF8String('[Parrots font drawing]'),
          TVector2.Create(Position.X + 20, Position.Y + 20 + 280), Font.BaseSize, 0.0, WHITE);
      end else
        DrawTexture(Font.Texture, ScreenWidth div 2 - Font.Texture.Width div 2, 50, BLACK);

      DrawText(UTF8String('PRESS SPACE to SHOW FONT ATLAS USED'), 290, 420, 10, DARKGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Texture); // Texture unloading

  UnloadFont(Font); // Unload custom font

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

