(*******************************************************************************************
*
*   raylib [shapes] example - Cubic-bezier lines
*
*   Example originally created with raylib 1.7, last time updated with raylib 1.7
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit shapes_lines_bezier_src;

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
  Start, &End: TVector2;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shapes] example - cubic-bezier lines'));

  Start := TVector2.Create(0, 0);
  &End := TVector2.Create(ScreenWidth, ScreenHeight);

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsMouseButtonDown(MOUSE_BUTTON_LEFT) then
      Start := GetMousePosition()
    else if IsMouseButtonDown(MOUSE_BUTTON_RIGHT) then
      &End := GetMousePosition();
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(UTF8String('USE MOUSE LEFT-RIGHT CLICK to DEFINE LINE START and END POINTS'), 15, 20, 20, GRAY);

      DrawLineBezier(Start, &End, 2.0, RED);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

