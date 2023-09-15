(*******************************************************************************************
*
*   raylib [core] examples - Mouse wheel input
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit core_input_mouse_wheel_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

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
  BoxPositionY: Integer;
  ScrollSpeed: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - input mouse wheel'));

  BoxPositionY := ScreenHeight div 2 - 40;
  ScrollSpeed := 4; // Scrolling speed in pixels

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    BoxPositionY := BoxPositionY - Trunc(GetMouseWheelMove() * ScrollSpeed);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawRectangle(ScreenWidth div 2 - 40, BoxPositionY, 80, 80, MAROON);

      DrawText(UTF8String('Use mouse wheel to move the cube up and down!'), 10, 10, 20, GRAY);
      DrawText(TextFormat(UTF8String('Box position Y: %03i'), BoxPositionY), 10, 40, 20, LIGHTGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow();        // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

