(*******************************************************************************************
*
*   raylib [textures] example - blend modes
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   Example contributed by Karlo Licudine (@accidentalrebel) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2020-2023 Karlo Licudine (@accidentalrebel)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit textures_blend_modes_src;

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
  BlendCountMax = 4;
var
  BgImage: TImage;
  BgTexture: TTexture;
  FgImage: TImage;
  FgTexture: TTexture;
  BlendMode: TBlendMode;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] example - blend modess'));

  // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
  BgImage := LoadImage(UTF8String('resources/textures/cyberpunk_street_background.png')); // Loaded in CPU memory (RAM)
  BgTexture := LoadTextureFromImage(BgImage); // Image converted to texture, GPU memory (VRAM)

  FgImage := LoadImage(UTF8String('resources/textures/cyberpunk_street_foreground.png')); // Loaded in CPU memory (RAM)
  FgTexture := LoadTextureFromImage(FgImage); // Image converted to texture, GPU memory (VRAM)

  // Once image has been converted to texture and uploaded to VRAM, it can be unloaded from RAM
  UnloadImage(BgImage);
  UnloadImage(FgImage);

  BlendMode := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyPressed(KEY_SPACE) then
    begin
      if BlendMode >= (BlendCountMax - 1) then
        BlendMode := 0
      else
        Inc(BlendMode);
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawTexture(BgTexture, ScreenWidth div 2 - BgTexture.Width div 2, ScreenHeight div 2 - BgTexture.Height div 2, WHITE);

      // Apply the blend mode and then draw the foreground texture
      BeginBlendMode(BlendMode);
        DrawTexture(FgTexture, ScreenWidth div 2 - FgTexture.Width div 2, ScreenHeight div 2 - FgTexture.Height div 2, WHITE);
      EndBlendMode();

      // Draw the texts
      DrawText(UTF8String('Press SPACE to change blend modes.'), 310, 350, 10, GRAY);

      case BlendMode of
        BLEND_ALPHA: DrawText(UTF8String('Current: BLEND_ALPHA'), (ScreenWidth div 2) - 60, 370, 10, GRAY);
        BLEND_ADDITIVE: DrawText(UTF8String('Current: BLEND_ADDITIVE'), (ScreenWidth div 2) - 60, 370, 10, GRAY);
        BLEND_MULTIPLIED: DrawText(UTF8String('Current: BLEND_MULTIPLIED'), (ScreenWidth div 2) - 60, 370, 10, GRAY);
        BLEND_ADD_COLORS: DrawText(UTF8String('Current: BLEND_ADD_COLORS'), (ScreenWidth div 2) - 60, 370, 10, GRAY);
      end;

      DrawText(UTF8String('(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)'), ScreenWidth - 330, ScreenHeight - 20, 10, GRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(FgTexture); // Unload foreground texture
  UnloadTexture(BgTexture); // Unload background texture

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

