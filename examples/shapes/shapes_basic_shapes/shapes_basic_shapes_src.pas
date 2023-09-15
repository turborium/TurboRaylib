(*******************************************************************************************
*
*   raylib [shapes] example - Draw basic shapes 2d (rectangle, circle, line...)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit shapes_basic_shapes_src;

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
  Rotation: Single;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shapes] example - basic shapes drawing'));

  Rotation := 0.0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    Rotation := Rotation + 0.2;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(UTF8String('some basic shapes available on raylib'), 20, 20, 20, DARKGRAY);

      // Circle shapes and lines
      DrawCircle(ScreenWidth div 5, 120, 35, DARKBLUE);
      DrawCircleGradient(ScreenWidth div 5, 220, 60, GREEN, SKYBLUE);
      DrawCircleLines(ScreenWidth div 5, 340, 80, DARKBLUE);

      // Rectangle shapes and lines
      DrawRectangle(ScreenWidth div 4 * 2 - 60, 100, 120, 60, RED);
      DrawRectangleGradientH(ScreenWidth div 4 * 2 - 90, 170, 180, 130, MAROON, GOLD);
      DrawRectangleLines(ScreenWidth div 4 * 2 - 40, 320, 80, 60, ORANGE); // NOTE: Uses QUADS internally, not lines

      // Triangle shapes and lines
      DrawTriangle(
        TVector2.Create(ScreenWidth / 4.0 * 3.0, 80.0),
        TVector2.Create(ScreenWidth / 4.0 * 3.0 - 60.0, 150.0),
        TVector2.Create(ScreenWidth / 4.0 * 3.0 + 60.0, 150.0),
        VIOLET
      );

      DrawTriangleLines(
        TVector2.Create(ScreenWidth / 4.0 * 3.0, 160.0),
        TVector2.Create(ScreenWidth / 4.0 * 3.0 - 20.0, 230.0),
        TVector2.Create(ScreenWidth / 4.0 * 3.0 + 20.0, 230.0),
        DARKBLUE
      );

      // Polygon shapes and lines
      DrawPoly(TVector2.Create(ScreenWidth / 4.0 * 3, 330), 6, 80, Rotation, BROWN);
      DrawPolyLines(TVector2.Create(ScreenWidth / 4.0 * 3, 330), 6, 90, Rotation, BROWN);
      DrawPolyLinesEx(TVector2.Create(ScreenWidth / 4.0 * 3, 330), 6, 85, Rotation, 6, BEIGE);

      // NOTE: We draw all LINES based shapes together to optimize internal drawing,
      // this way, all LINES are rendered in a single draw pass
      DrawLine(18, 42, screenWidth - 18, 42, BLACK);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

