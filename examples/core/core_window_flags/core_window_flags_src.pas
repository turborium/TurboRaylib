(*******************************************************************************************
*
*   raylib [core] example - window flags
*
*   Example originally created with raylib 3.5, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2020-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit core_window_flags_src;

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
  BallPosition, BallSpeed: TVector2;
  BallRadius: Single;
  FramesCounter: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------

  // Possible window flags
  (*
    FLAG_VSYNC_HINT
    FLAG_FULLSCREEN_MODE    -> not working properly -> wrong scaling!
    FLAG_WINDOW_RESIZABLE
    FLAG_WINDOW_UNDECORATED
    FLAG_WINDOW_TRANSPARENT
    FLAG_WINDOW_HIDDEN
    FLAG_WINDOW_MINIMIZED   -> Not supported on window creation
    FLAG_WINDOW_MAXIMIZED   -> Not supported on window creation
    FLAG_WINDOW_UNFOCUSED
    FLAG_WINDOW_TOPMOST
    FLAG_WINDOW_HIGHDPI     -> errors after minimize-resize, fb size is recalculated
    FLAG_WINDOW_ALWAYS_RUN
    FLAG_MSAA_4X_HINT
  *)

  // SetConfigFlags(FLAG_WINDOW_TRANSPARENT or FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - window flags'));

  BallPosition := TVector2.Create(GetScreenWidth() / 2.0, GetScreenHeight() / 2.0);
  BallSpeed := TVector2.Create(5.0, 4.0);
  BallRadius := 20;

  FramesCounter := 0;

  // SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyPressed(KEY_F) then
      ToggleFullscreen();  // modifies window size when scaling!

    if IsKeyPressed(KEY_R) then
    begin
      if IsWindowState(FLAG_WINDOW_RESIZABLE) then
        ClearWindowState(FLAG_WINDOW_RESIZABLE)
      else
        SetWindowState(FLAG_WINDOW_RESIZABLE);
    end;

    if IsKeyPressed(KEY_D) then
    begin
      if IsWindowState(FLAG_WINDOW_UNDECORATED) then
        ClearWindowState(FLAG_WINDOW_UNDECORATED)
      else
        SetWindowState(FLAG_WINDOW_UNDECORATED);
    end;

    if IsKeyPressed(KEY_H) then
    begin
      if not IsWindowState(FLAG_WINDOW_HIDDEN) then
        SetWindowState(FLAG_WINDOW_HIDDEN);
      FramesCounter := 0;
    end;

    if IsWindowState(FLAG_WINDOW_HIDDEN) then
    begin
      FramesCounter := FramesCounter + 1;
      if FramesCounter >= 240 then
        ClearWindowState(FLAG_WINDOW_HIDDEN); // Show window after 3 seconds
    end;

    if IsKeyPressed(KEY_N) then
    begin
      if not IsWindowState(FLAG_WINDOW_MINIMIZED) then
        MinimizeWindow();
      FramesCounter := 0;
    end;

    if IsWindowState(FLAG_WINDOW_MINIMIZED) then
    begin
      FramesCounter := FramesCounter + 1;
      if FramesCounter >= 240 then
        RestoreWindow(); // Restore window after 3 seconds
    end;

    if IsKeyPressed(KEY_M) then
    begin
      // NOTE: Requires FLAG_WINDOW_RESIZABLE enabled!
      if IsWindowState(FLAG_WINDOW_MAXIMIZED) then
        RestoreWindow()
      else
        MaximizeWindow();
    end;

    if IsKeyPressed(KEY_U) then
    begin
      if IsWindowState(FLAG_WINDOW_UNFOCUSED) then
        ClearWindowState(FLAG_WINDOW_UNFOCUSED)
      else
        SetWindowState(FLAG_WINDOW_UNFOCUSED);
    end;

    if IsKeyPressed(KEY_T) then
    begin
      if IsWindowState(FLAG_WINDOW_TOPMOST) then
        ClearWindowState(FLAG_WINDOW_TOPMOST)
      else
        SetWindowState(FLAG_WINDOW_TOPMOST);
    end;

    if IsKeyPressed(KEY_A) then
    begin
      if IsWindowState(FLAG_WINDOW_ALWAYS_RUN) then
        ClearWindowState(FLAG_WINDOW_ALWAYS_RUN)
      else
        SetWindowState(FLAG_WINDOW_ALWAYS_RUN);
    end;

    if IsKeyPressed(KEY_V) then
    begin
      if IsWindowState(FLAG_VSYNC_HINT) then
        ClearWindowState(FLAG_VSYNC_HINT)
      else
        SetWindowState(FLAG_VSYNC_HINT);
    end;

    // Bouncing ball logic
    BallPosition.X := BallPosition.X + BallSpeed.X;
    BallPosition.Y := BallPosition.Y + ballSpeed.Y;
    if (BallPosition.X >= (GetScreenWidth() - BallRadius)) or (BallPosition.X <= BallRadius) then
      BallSpeed.X := BallSpeed.X * -1.0;
    if (BallPosition.Y >= (GetScreenHeight() - BallRadius)) or (BallPosition.Y <= BallRadius) then
      BallSpeed.Y := BallSpeed.Y * -1.0;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

    if IsWindowState(FLAG_WINDOW_TRANSPARENT) then
      ClearBackground(BLANK)
    else
      ClearBackground(RAYWHITE);

    DrawCircleV(BallPosition, BallRadius, MAROON);
    DrawRectangleLinesEx(TRectangle.Create(0, 0, GetScreenWidth(), GetScreenHeight()), 4, RAYWHITE);

    DrawCircleV(GetMousePosition(), 10, DARKBLUE);

    DrawFPS(10, 10);

    DrawText(TextFormat(UTF8String('Screen Size: [%i, %i]'), GetScreenWidth(), GetScreenHeight()), 10, 40, 10, GREEN);

    // Draw window state info
    DrawText(UTF8String('Following flags can be set after window creation:'), 10, 60, 10, GRAY);
    if IsWindowState(FLAG_FULLSCREEN_MODE) then
      DrawText(UTF8String('[F] FLAG_FULLSCREEN_MODE: on'), 10, 80, 10, LIME)
    else
      DrawText(UTF8String('[F] FLAG_FULLSCREEN_MODE: off'), 10, 80, 10, MAROON);
    if IsWindowState(FLAG_WINDOW_RESIZABLE) then
      DrawText(UTF8String('[R] FLAG_WINDOW_RESIZABLE: on'), 10, 100, 10, LIME)
    else
      DrawText(UTF8String('[R] FLAG_WINDOW_RESIZABLE: off'), 10, 100, 10, MAROON);
    if IsWindowState(FLAG_WINDOW_UNDECORATED) then
      DrawText(UTF8String('[D] FLAG_WINDOW_UNDECORATED: on'), 10, 120, 10, LIME)
    else
      DrawText(UTF8String('[D] FLAG_WINDOW_UNDECORATED: off'), 10, 120, 10, MAROON);
    if IsWindowState(FLAG_WINDOW_HIDDEN) then
      DrawText(UTF8String('[H] FLAG_WINDOW_HIDDEN: on'), 10, 140, 10, LIME)
    else
      DrawText(UTF8String('[H] FLAG_WINDOW_HIDDEN: off'), 10, 140, 10, MAROON);
    if IsWindowState(FLAG_WINDOW_MINIMIZED) then
      DrawText(UTF8String('[N] FLAG_WINDOW_MINIMIZED: on'), 10, 160, 10, LIME)
    else
      DrawText(UTF8String('[N] FLAG_WINDOW_MINIMIZED: off'), 10, 160, 10, MAROON);
    if IsWindowState(FLAG_WINDOW_MAXIMIZED) then
      DrawText(UTF8String('[M] FLAG_WINDOW_MAXIMIZED: on'), 10, 180, 10, LIME)
    else
      DrawText(UTF8String('[M] FLAG_WINDOW_MAXIMIZED: off'), 10, 180, 10, MAROON);
    if IsWindowState(FLAG_WINDOW_UNFOCUSED) then
      DrawText(UTF8String('[G] FLAG_WINDOW_UNFOCUSED: on'), 10, 200, 10, LIME)
    else
      DrawText(UTF8String('[U] FLAG_WINDOW_UNFOCUSED: off'), 10, 200, 10, MAROON);
    if IsWindowState(FLAG_WINDOW_TOPMOST) then
      DrawText(UTF8String('[T] FLAG_WINDOW_TOPMOST: on'), 10, 220, 10, LIME)
    else
      DrawText(UTF8String('[T] FLAG_WINDOW_TOPMOST: off'), 10, 220, 10, MAROON);
    if IsWindowState(FLAG_WINDOW_ALWAYS_RUN) then
      DrawText(UTF8String('[A] FLAG_WINDOW_ALWAYS_RUN: on'), 10, 240, 10, LIME)
    else
      DrawText(UTF8String('[A] FLAG_WINDOW_ALWAYS_RUN: off'), 10, 240, 10, MAROON);
    if IsWindowState(FLAG_VSYNC_HINT) then
      DrawText(UTF8String('[V] FLAG_VSYNC_HINT: on'), 10, 260, 10, LIME)
    else
      DrawText(UTF8String('[V] FLAG_VSYNC_HINT: off'), 10, 260, 10, MAROON);

    DrawText(UTF8String('Following flags can only be set before window creation:'), 10, 300, 10, GRAY);
    if IsWindowState(FLAG_WINDOW_HIGHDPI) then
      DrawText(UTF8String('FLAG_WINDOW_HIGHDPI: on'), 10, 320, 10, LIME)
    else
      DrawText(UTF8String('FLAG_WINDOW_HIGHDPI: off'), 10, 320, 10, MAROON);
    if IsWindowState(FLAG_WINDOW_TRANSPARENT) then
      DrawText(UTF8String('FLAG_WINDOW_TRANSPARENT: on'), 10, 340, 10, LIME)
    else
      DrawText(UTF8String('FLAG_WINDOW_TRANSPARENT: off'), 10, 340, 10, MAROON);
    if IsWindowState(FLAG_MSAA_4X_HINT) then
      DrawText(UTF8String('FLAG_MSAA_4X_HINT: on'), 10, 360, 10, LIME)
    else
      DrawText(UTF8String('FLAG_MSAA_4X_HINT: off'), 10, 360, 10, MAROON);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

