(*******************************************************************************************
*
*   raylib [core] example - 2d camera
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2016-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit core_2d_camera_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

uses
  raylib;

procedure Main();

implementation

const
  MAX_BUILDINGS = 100;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Player: TRectangle;
  Camera: TCamera2D;
  Buildings: array [0..MAX_BUILDINGS - 1] of TRectangle;
  BuildColors: array [0..MAX_BUILDINGS - 1] of TColor;
  Spacing: Integer;
  I: Integer;

begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - 2d camera'));

  Player := TRectangle.Create(400, 280, 40, 40);

  Spacing := 0;

  SetRandomSeed(9);
  for I := 0 to MAX_BUILDINGS - 1 do
  begin
    Buildings[I].Width := GetRandomValue(50, 200);
    Buildings[I].Height := GetRandomValue(100, 800);
    Buildings[I].Y := ScreenHeight - 130.0 - Buildings[I].Height;
    Buildings[I].X := -6000.0 + Spacing;

    Spacing := Spacing + Trunc(Buildings[I].Width);

    BuildColors[I] := TColor.Create(GetRandomValue(200, 240), GetRandomValue(200, 240), GetRandomValue(200, 250), 255);
  end;

  Camera := Default(TCamera2D);
  Camera.Target := TVector2.Create(Player.X + 20.0, Player.Y + 20.0);
  Camera.Offset := TVector2.Create(ScreenWidth / 2.0, ScreenHeight / 2.0);
  Camera.Rotation := 0.0;
  Camera.Zoom := 1.0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    // Player movement
    if IsKeyDown(KEY_RIGHT) then
      Player.X := Player.X + 2
    else if IsKeyDown(KEY_LEFT) then
      Player.X := Player.X - 2;

    // Camera target follows player
    Camera.Target := TVector2.Create(Player.X + 20, Player.Y + 20);

    // Camera rotation controls
    if IsKeyDown(KEY_A) then
      Camera.Rotation := Camera.Rotation - 1
    else if IsKeyDown(KEY_S) then
      Camera.Rotation := Camera.Rotation + 1;

    // Limit camera rotation to 80 degrees (-40 to 40)
    if Camera.Rotation > 40 then
      Camera.Rotation := 40
    else if Camera.Rotation < -40 then
      Camera.Rotation := -40;

    // Camera zoom controls
    Camera.Zoom := Camera.Zoom + (GetMouseWheelMove() * 0.05);

    if Camera.Zoom > 3.0 then
      Camera.Zoom := 3.0
    else if Camera.Zoom < 0.05 then
      Camera.Zoom := 0.05;

    // Camera reset (zoom and rotation)
    if IsKeyPressed(KEY_R) then
    begin
      Camera.Zoom := 1.0;
      Camera.Rotation := 0.0;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode2D(Camera);

        DrawRectangle(-6000, 320, 13000, 8000, DARKGRAY);

        for I := 0 to MAX_BUILDINGS - 1 do
          DrawRectangleRec(Buildings[I], BuildColors[I]);

        DrawRectangleRec(Player, RED);

        DrawLine(Trunc(Camera.Target.X), -ScreenHeight * 10, Trunc(Camera.Target.X), ScreenHeight * 10, GREEN);
        DrawLine(-ScreenWidth * 10, Trunc(Camera.Target.Y), ScreenWidth * 10, Trunc(Camera.Target.Y), GREEN);

      EndMode2D();

      DrawText(UTF8String('SCREEN AREA'), 640, 10, 20, RED);

      DrawRectangle(0, 0, ScreenWidth, 5, RED);
      DrawRectangle(0, 5, 5, ScreenHeight - 10, RED);
      DrawRectangle(ScreenWidth - 5, 5, 5, ScreenHeight - 10, RED);
      DrawRectangle(0, ScreenHeight - 5, ScreenWidth, 5, RED);

      DrawRectangle(10, 10, 250, 113, Fade(SKYBLUE, 0.5));
      DrawRectangleLines(10, 10, 250, 113, BLUE);

      DrawText(UTF8String('Free 2d camera controls:'), 20, 20, 10, BLACK);
      DrawText(UTF8String('- Right/Left to move Offset'), 40, 40, 10, DARKGRAY);
      DrawText(UTF8String('- Mouse Wheel to Zoom in-out'), 40, 60, 10, DARKGRAY);
      DrawText(UTF8String('- A / S to Rotate'), 40, 80, 10, DARKGRAY);
      DrawText(UTF8String('- R to reset Zoom and Rotation'), 40, 100, 10, DARKGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

