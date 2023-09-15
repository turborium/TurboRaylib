(*******************************************************************************************
*
*   raylib [shapes] example - collision area
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2013-2022 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit shapes_collision_area_src;

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
  BoxA: TRectangle;
  BoxASpeedX: Integer;
  BoxB: TRectangle;
  BoxCollision: TRectangle;
  ScreenUpperLimit: Integer;
  Pause, Collision: Boolean;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shapes] example - collision area'));

  // Box A: Moving box
  BoxA := TRectangle.Create(10, GetScreenHeight() / 2.0 - 50, 200, 100);
  BoxASpeedX := 4;

  // Box B: Mouse moved box
  BoxB := TRectangle.Create(GetScreenWidth() / 2.0 - 30, GetScreenHeight() / 2.0 - 30, 60, 60);

  BoxCollision := Default(TRectangle); // Collision rectangle

  ScreenUpperLimit := 40; // Top menu limits

  Pause := False; // Movement pause

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    // Move box if not paused
    if not Pause then
      BoxA.X := BoxA.X + BoxASpeedX;

    // Bounce box on x screen limits
    if (((BoxA.X + BoxA.Width) >= GetScreenWidth()) or (BoxA.X <= 0)) then
      BoxASpeedX := -BoxASpeedX;

    // Update player-controlled-box (box02)
    BoxB.X := GetMouseX() - BoxB.Width / 2;
    BoxB.Y := GetMouseY() - BoxB.Height / 2;

    // Make sure Box B does not go out of move area limits
    if ((BoxB.X + BoxB.Width) >= GetScreenWidth()) then
      BoxB.X := GetScreenWidth() - BoxB.width
    else if BoxB.X <= 0 then
      BoxB.X := 0;

    if (BoxB.Y + BoxB.Height) >= GetScreenHeight() then
      BoxB.Y := GetScreenHeight() - BoxB.Height
    else if BoxB.Y <= ScreenUpperLimit then
      BoxB.Y := ScreenUpperLimit;

    // Check boxes collision
    Collision := CheckCollisionRecs(BoxA, BoxB);

    // Get collision rectangle (only on collision)
    if Collision then
      BoxCollision := GetCollisionRec(BoxA, BoxB);

    // Pause Box A movement
    if IsKeyPressed(KEY_SPACE) then
      Pause := not Pause;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      if Collision then
        DrawRectangle(0, 0, ScreenWidth, ScreenUpperLimit, RED)
      else
        DrawRectangle(0, 0, ScreenWidth, ScreenUpperLimit, BLACK);

      DrawRectangleRec(BoxA, GOLD);
      DrawRectangleRec(BoxB, BLUE);

      if Collision then
      begin
        // Draw collision area
        DrawRectangleRec(BoxCollision, LIME);

        // Draw collision message
        DrawText(UTF8String('COLLISION!'), GetScreenWidth() div 2 - MeasureText(UTF8String('COLLISION!'), 20) div 2, ScreenUpperLimit div 2 - 10, 20, BLACK);

        // Draw collision area
        DrawText(TextFormat(UTF8String('Collision Area: %i'), Integer(Trunc(BoxCollision.Width * BoxCollision.Height))), GetScreenWidth() div 2 - 100, ScreenUpperLimit + 10, 20, BLACK);
      end;

      DrawFPS(10, 10);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

