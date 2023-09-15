(*******************************************************************************************
*
*   raylib [core] example - Scissor test
*
*   Example contributed by Chris Dill (@MysteriousSpace) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2023 Chris Dill (@MysteriousSpace)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit core_scissor_test_src;

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
  ScissorArea: TRectangle;
  ScissorMode: Boolean;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);

  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - scissor test'));

  ScissorArea := TRectangle.Create(0, 0, 300, 300);
  ScissorMode := True;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyPressed(KEY_S) then
      ScissorMode := not ScissorMode;

    // Centre the scissor area around the mouse position
    ScissorArea.X := GetMouseX() - ScissorArea.Width / 2;
    ScissorArea.Y := GetMouseY() - ScissorArea.Height / 2;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      if ScissorMode then
        BeginScissorMode(Trunc(ScissorArea.X), Trunc(ScissorArea.Y), Trunc(ScissorArea.Width), Trunc(ScissorArea.Height));

      // Draw full screen rectangle and some text
      // NOTE: Only part defined by scissor area will be rendered
      DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), RED);
      DrawText(UTF8String('Move the mouse around to reveal this text!'), 190, 200, 20, LIGHTGRAY);

      if ScissorMode then
        EndScissorMode();

      DrawRectangleLinesEx(ScissorArea, 1, BLACK);
      DrawText(UTF8String('Press S to toggle scissor test'), 10, 10, 20, BLACK);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

