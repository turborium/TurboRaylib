(*******************************************************************************************
*
*   raylib [textures] example - Procedural images generation
*
*   Example originally created with raylib 1.8, last time updated with raylib 1.8
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2O17-2022 Wilhem Barbier (@nounoursheureux) and Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit textures_image_generation_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  NUM_TEXTURES = 6; // Currently we have 7 generation algorithms

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  VerticalGradient, HorizontalGradient, RadialGradient,
    Checked, WhiteNoise, Cellular: TImage;
  Textures: array [0..NUM_TEXTURES-1] of TTexture2D;
  CurrentTexture, I: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] example - procedural images generation'));

  VerticalGradient := GenImageGradientV(ScreenWidth, ScreenHeight, RED, BLUE);
  HorizontalGradient := GenImageGradientH(ScreenWidth, ScreenHeight, RED, BLUE);
  RadialGradient := GenImageGradientRadial(ScreenWidth, ScreenHeight, 0.0, WHITE, BLACK);
  Checked := GenImageChecked(ScreenWidth, ScreenHeight, 32, 32, RED, BLUE);
  WhiteNoise := GenImageWhiteNoise(ScreenWidth, ScreenHeight, 0.5);
  Cellular := GenImageCellular(ScreenWidth, ScreenHeight, 32);

  Textures[0] := LoadTextureFromImage(VerticalGradient);
  Textures[1] := LoadTextureFromImage(HorizontalGradient);
  Textures[2] := LoadTextureFromImage(RadialGradient);
  Textures[3] := LoadTextureFromImage(Checked);
  Textures[4] := LoadTextureFromImage(WhiteNoise);
  Textures[5] := LoadTextureFromImage(Cellular);

  // Unload image data (CPU RAM)
  UnloadImage(VerticalGradient);
  UnloadImage(HorizontalGradient);
  UnloadImage(RadialGradient);
  UnloadImage(Checked);
  UnloadImage(WhiteNoise);
  UnloadImage(Cellular);

  CurrentTexture := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) or IsKeyPressed(KEY_RIGHT) then
      CurrentTexture := (CurrentTexture + 1) mod  NUM_TEXTURES; // Cycle between the textures
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawTexture(Textures[CurrentTexture], 0, 0, WHITE);

      DrawRectangle(30, 400, 325, 30, Fade(SKYBLUE, 0.5));
      DrawRectangleLines(30, 400, 325, 30, Fade(WHITE, 0.5));
      DrawText(UTF8String('MOUSE LEFT BUTTON to CYCLE PROCEDURAL TEXTURES'), 40, 410, 10, WHITE);

      case CurrentTexture of
        0: DrawText(UTF8String('VERTICAL GRADIENT'), 560, 10, 20, RAYWHITE);
        1: DrawText(UTF8String('HORIZONTAL GRADIENT'), 540, 10, 20, RAYWHITE);
        2: DrawText(UTF8String('RADIAL GRADIENT'), 580, 10, 20, LIGHTGRAY);
        3: DrawText(UTF8String('CHECKED'), 680, 10, 20, RAYWHITE);
        4: DrawText(UTF8String('WHITE NOISE'), 640, 10, 20, RED);
        5: DrawText(UTF8String('CELLULAR'), 670, 10, 20, RAYWHITE);
      end;

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------

  // Unload textures data (GPU VRAM)
  for I := 0 to NUM_TEXTURES - 1 do
    UnloadTexture(Textures[I]);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

