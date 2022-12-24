(*******************************************************************************************
*
*   raylib [shapes] example - draw ring (with gui options)
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2018-2022 Vlad Adrian (@demizdor) and Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit shapes_draw_ring_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  Math,
  raylib;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  InnerRadius, OuterRadius: Single;
  StartAngle, EndAngle: Single;
  Segments: Integer;
  Center: TVector2;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shapes] example - draw ring'));

  Center := TVector2.Create((GetScreenWidth() - 300) / 2.0, GetScreenHeight() / 2.0);

  InnerRadius := 80.0;
  OuterRadius := 190.0;

  StartAngle := 0.0;
  EndAngle := 300.0;

  Segments := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyPressed(KEY_UP) then
      Segments := Segments + 4;
    if IsKeyPressed(KEY_DOWN) then
      Segments := Segments - 4;

    Segments := Min(1000, Max(0, Segments));
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      DrawText(PAnsiChar(UTF8String('Segments: ' + IntToStr(Segments) + ', Press UP/DOWN for change')), 3, 3, 10, RED);

      ClearBackground(RAYWHITE);

      DrawRing(Center, InnerRadius, OuterRadius, StartAngle, EndAngle, Segments, Fade(MAROON, 0.3));
      DrawRingLines(Center, InnerRadius, OuterRadius, StartAngle, EndAngle, Segments, Fade(BLACK, 0.4));
      DrawCircleSectorLines(Center, OuterRadius, StartAngle, EndAngle, Segments, Fade(BLACK, 0.4));
      DrawRectangleRounded(TRectangle.Create(480, 35, 260, 370), 0.7, Segments, Fade(MAROON, 0.2));
      DrawRectangleRoundedLines(TRectangle.Create(480, 35, 260, 370), 0.7, Segments, 8, Fade(MAROON, 0.4));

      DrawFPS(10, 30);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

