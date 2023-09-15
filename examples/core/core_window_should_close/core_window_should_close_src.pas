(*******************************************************************************************
*
*   raylib [core] example - Window should close
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2013-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit core_window_should_close_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  Math,
  raylib,
  raymath;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  ExitWindowRequested: Boolean;
  ExitWindow: Boolean;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------

  SetConfigFlags(FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - window should close'));

  SetExitKey(KEY_NULL); // Disable KEY_ESCAPE to close window, X-button still works

  ExitWindowRequested := False;
  ExitWindow := False;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not ExitWindow do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    // Detect if X-button or KEY_ESCAPE have been pressed to close window
    if WindowShouldClose() or IsKeyPressed(KEY_ESCAPE) then
      ExitWindowRequested := True;

    if exitWindowRequested then
    begin
      // A request for close window has been issued, we can save data before closing
      // or just show a message asking for confirmation

      if IsKeyPressed(KEY_Y) then
        ExitWindow := True
      else if IsKeyPressed(KEY_N) then
        ExitWindowRequested := False;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      if exitWindowRequested then
      begin
        DrawRectangle(0, 100, ScreenWidth, 200, BLACK);
        DrawText(UTF8String('Are you sure you want to exit program? [Y/N]'), 40, 180, 30, WHITE);
      end else
        DrawText(UTF8String('Try to close the window to get confirmation message!'), 120, 200, 20, LIGHTGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

