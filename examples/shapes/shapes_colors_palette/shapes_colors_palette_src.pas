(*******************************************************************************************
*
*   raylib [shapes] example - Colors palette
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2022 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit shapes_colors_palette_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  Math,
  raylib;

const
  MAX_COLORS_COUNT = 21; // Number of colors available

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Colors: array of TColor;
  ColorNames: array of string;
  ColorsRecs: array [0..MAX_COLORS_COUNT-1] of TRectangle;
  ColorState: array [0..MAX_COLORS_COUNT-1] of Boolean;
  I: Integer;
  MousePoint: TVector2;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shapes] example - colors palette'));

  Colors := [
    DARKGRAY, MAROON, ORANGE, DARKGREEN, DARKBLUE, DARKPURPLE, DARKBROWN,
    GRAY, RED, GOLD, LIME, BLUE, VIOLET, BROWN, LIGHTGRAY, PINK, YELLOW,
    GREEN, SKYBLUE, PURPLE, BEIGE];

  ColorNames := [
    'DARKGRAY', 'MAROON', 'ORANGE', 'DARKGREEN', 'DARKBLUE', 'ARKPURPLE', 'DARKBROWN',
    'GRAY', 'RED', 'GOLD', 'LIME', 'BLUE', 'VIOLET', 'BROWN', 'LIGHTGRAY', 'PINK', 'YELLOW',
    'GREEN', 'SKYBLUE', 'PURPLE', 'BEIGE'];

  for I := 0 to High(Colors) do
  begin
    ColorsRecs[I].X := 20 + 100 * (I mod 7) + 10 * (I mod 7);
    ColorsRecs[I].Y := 80 + 100 * (I div 7) + 10 * (I div 7);
    ColorsRecs[I].Width := 100;
    ColorsRecs[I].Height := 100;
  end;

  FillChar(ColorState, SizeOf(ColorState), False);

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    MousePoint := GetMousePosition();

    for I := 0 to High(Colors) do
      ColorState[I] := CheckCollisionPointRec(MousePoint, ColorsRecs[I]);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(UTF8String('raylib colors palette'), 28, 42, 20, BLACK);
      DrawText(UTF8String('press SPACE to see all colors'), GetScreenWidth() - 180, GetScreenHeight() - 40, 10, GRAY);

      for I := 0 to High(Colors) do // Draw all rectangles
      begin
        DrawRectangleRec(ColorsRecs[I], Fade(Colors[I], IfThen(ColorState[i], 0.6, 1.0)));

        if IsKeyDown(KEY_SPACE) or ColorState[I] then
        begin
          DrawRectangle(Trunc(ColorsRecs[I].X), Trunc(ColorsRecs[I].Y + ColorsRecs[I].Height - 26), Trunc(ColorsRecs[I].Width), 20, BLACK);
          DrawRectangleLinesEx(ColorsRecs[I], 6, Fade(BLACK, 0.3));
          DrawText(PAnsiChar(UTF8String(ColorNames[I])), Trunc(ColorsRecs[I].X + ColorsRecs[I].Width - MeasureText(PAnsiChar(UTF8String(colorNames[i])), 10) - 12),
            Trunc(ColorsRecs[I].Y + ColorsRecs[I].Height - 20), 10, Colors[I]);
        end;
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

