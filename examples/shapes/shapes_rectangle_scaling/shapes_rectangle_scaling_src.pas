(*******************************************************************************************
*
*   raylib [shapes] example - rectangle scaling by mouse
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
unit shapes_rectangle_scaling_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  MOUSE_SCALE_MARK_SIZE = 12;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Rec: TRectangle;
  MousePosition: TVector2;
  MouseScaleReady, MouseScaleMode: Boolean;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shapes] example - rectangle scaling mouse'));

  Rec := TRectangle.Create(100, 100, 200, 80);

  MousePosition := TVector2.Create(0, 0);

  MouseScaleMode := False;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    MousePosition := GetMousePosition();

    if CheckCollisionPointRec(MousePosition, TRectangle.Create(Rec.X + Rec.Width - MOUSE_SCALE_MARK_SIZE, Rec.Y + Rec.Height - MOUSE_SCALE_MARK_SIZE, MOUSE_SCALE_MARK_SIZE, MOUSE_SCALE_MARK_SIZE )) then
    begin
      MouseScaleReady := True;
      if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) then
        MouseScaleMode := True;
    end else
      MouseScaleReady := False;

    if MouseScaleMode then
    begin
      MouseScaleReady := True;

      Rec.Width := (MousePosition.X - Rec.X);
      Rec.Height := (MousePosition.Y - Rec.Y);

      // Check minimum rec size
      if Rec.Width < MOUSE_SCALE_MARK_SIZE then
        Rec.Width := MOUSE_SCALE_MARK_SIZE;
      if Rec.Height < MOUSE_SCALE_MARK_SIZE then
        Rec.Height := MOUSE_SCALE_MARK_SIZE;

      // Check maximum rec size
      if Rec.Width > (GetScreenWidth() - Rec.X) then
        Rec.Width := GetScreenWidth() - Rec.X;
      if Rec.Height > (GetScreenHeight() - Rec.Y) then
        Rec.Height := GetScreenHeight() - Rec.Y;

      if IsMouseButtonReleased(MOUSE_BUTTON_LEFT) then
        MouseScaleMode := False;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(UTF8String('Scale rectangle dragging from bottom-right corner!'), 10, 10, 20, GRAY);

      DrawRectangleRec(Rec, Fade(GREEN, 0.5));

      if MouseScaleReady then
      begin
        DrawRectangleLinesEx(Rec, 1, RED);
        DrawTriangle(
          TVector2.Create(Rec.X + Rec.Width - MOUSE_SCALE_MARK_SIZE, Rec.Y + Rec.Height),
          TVector2.Create(Rec.x + Rec.Width, Rec.Y + Rec.Height),
          TVector2.Create(Rec.x + Rec.Width, Rec.Y + Rec.Height - MOUSE_SCALE_MARK_SIZE),
          RED
        );
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

