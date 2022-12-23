(*******************************************************************************************
*
*   raylib [core] example - custom frame control
*
*   NOTE: WARNING: This is an example for advance users willing to have full control over
*   the frame processes. By default, EndDrawing() calls the following processes:
*       1. Draw remaining batch data: rlDrawRenderBatchActive()
*       2. SwapScreenBuffer()
*       3. Frame time control: WaitTime()
*       4. PollInputEvents()
*
*   To avoid steps 2, 3 and 4, flag SUPPORT_CUSTOM_FRAME_CONTROL can be enabled in
*   config.h (it requires recompiling raylib). This way those steps are up to the user.
*
*   Note that enabling this flag invalidates some functions:
*       - GetFrameTime()
*       - SetTargetFPS()
*       - GetFPS()
*
*   Example originally created with raylib 4.0, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2021-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit core_custom_frame_control_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

// WARNING!!! YOU SHOULD RECOMPILE RAYLIB WITH SUPPORT_CUSTOM_FRAME_CONTROL FOR THIS EX.

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  PreviousTime: Double;
  CurrentTime: Double;
  UpdateDrawTime: Double;
  WaitTime: Double;
  DeltaTime: Single;
  TimeCounter: Single;
  Position: Single;
  Pause: Boolean;
  TargetFPS: Integer;
  I: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - frame control (see comment)'));

  // Custom timming variables
  PreviousTime := GetTime();    // Previous time measure
  // CurrentTime := 0.0;           // Current time measure
  // UpdateDrawTime := 0.0;        // Update + Draw time
  // WaitTime := 0.0;              // Wait time (if target fps required)
  DeltaTime := 0.0;             // Frame time (Update + Draw + Wait time)

  TimeCounter := 0.0;           // Accumulative time counter (seconds)
  Position := 0.0;              // Circle position
  Pause := False;               // Pause control flag

  TargetFPS := 60;              // Our initial target fps
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    PollInputEvents(); // Poll input events (SUPPORT_CUSTOM_FRAME_CONTROL)

    if IsKeyPressed(KEY_SPACE) then
      Pause := not Pause;

    if IsKeyPressed(KEY_UP) then
      TargetFPS := TargetFPS + 20
    else if IsKeyPressed(KEY_DOWN) then
      TargetFPS := TargetFPS - 20;

    if TargetFPS < 0 then
      TargetFPS := 0;

    if not Pause then
    begin
      Position := Position + 200 * DeltaTime; // We move at 200 pixels per second
      if Position >= GetScreenWidth() then
        Position := 0;
      TimeCounter := TimeCounter + DeltaTime; // We count time (seconds)
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      for I := 0 to Trunc(GetScreenWidth() / 200) - 1 do
        DrawRectangle(200*i, 0, 1, GetScreenHeight(), SKYBLUE);

      DrawCircle(Trunc(Position), Trunc(GetScreenHeight() / 2 - 25), 50, RED);

      DrawText(TextFormat(UTF8String('%03.0f ms'), Single(TimeCounter * 1000.0)), Trunc(Position - 40), Trunc(GetScreenHeight() / 2 - 100), 20, MAROON);
      DrawText(TextFormat(UTF8String('PosX: %03.0f'), Single(Position)), Trunc(Position - 50), Trunc(GetScreenHeight() / 2 + 40), 20, BLACK);

      DrawText(UTF8String('Circle is moving at a constant 200 pixels/sec,'#10'independently of the frame rate.'), 10, 10, 20, DARKGRAY);
      DrawText(UTF8String('PRESS SPACE to PAUSE MOVEMENT'), 10, GetScreenHeight() - 60, 20, GRAY);
      DrawText(UTF8String('PRESS UP | DOWN to CHANGE TARGET FPS'), 10, GetScreenHeight() - 30, 20, GRAY);
      DrawText(TextFormat(UTF8String('TARGET FPS: %i'), TargetFPS), GetScreenWidth() - 220, 10, 20, LIME);
      DrawText(TextFormat(UTF8String('CURRENT FPS: %i'), Trunc(1.0 / DeltaTime)), GetScreenWidth() - 220, 40, 20, GREEN);

    EndDrawing();

    // NOTE: In case raylib is configured to SUPPORT_CUSTOM_FRAME_CONTROL,
    // Events polling, screen buffer swap and frame time control must be managed by the user

    SwapScreenBuffer(); // Flip the back buffer to screen (front buffer)

    CurrentTime := GetTime();
    UpdateDrawTime := CurrentTime - PreviousTime;

    if TargetFPS > 0 then // We want a fixed frame rate
    begin
      WaitTime := (1.0 / TargetFPS) - UpdateDrawTime;
      if WaitTime > 0.0 then
      begin
        raylib.WaitTime(WaitTime);
        CurrentTime := GetTime();
        DeltaTime := (CurrentTime - PreviousTime);
      end;
    end else
      DeltaTime := UpdateDrawTime; // Framerate could be variable

    PreviousTime := CurrentTime;
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

