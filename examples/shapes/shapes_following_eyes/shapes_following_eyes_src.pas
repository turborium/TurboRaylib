(*******************************************************************************************
*
*   raylib [shapes] example - following eyes
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2013-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit shapes_following_eyes_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  Math,
  raylib;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  ScleraLeftPosition, ScleraRightPosition: TVector2;
  ScleraRadius: Single;
  IrisLeftPosition, IrisRightPosition: TVector2;
  IrisRadius: Single;
  Angle: Single;
  Dx, Dy, Dxx, Dyy: Single;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shapes] example - following eyes'));

  ScleraLeftPosition := TVector2.Create(GetScreenWidth() / 2.0 - 100.0, GetScreenHeight() / 2.0);
  ScleraRightPosition := TVector2.Create(GetScreenWidth() / 2.0 + 100.0, GetScreenHeight() / 2.0);
  ScleraRadius := 80;

  IrisLeftPosition := TVector2.Create(GetScreenWidth() / 2.0 - 100.0, GetScreenHeight() / 2.0);
  IrisRightPosition := TVector2.Create(GetScreenWidth() / 2.0 + 100.0, GetScreenHeight() / 2.0);
  IrisRadius := 24;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    IrisLeftPosition := GetMousePosition();
    IrisRightPosition := GetMousePosition();

    // Check not inside the left eye sclera
    if not CheckCollisionPointCircle(IrisLeftPosition, ScleraLeftPosition, ScleraRadius - 20) then
    begin
      Dx := IrisLeftPosition.X - ScleraLeftPosition.X;
      Dy := IrisLeftPosition.Y - ScleraLeftPosition.Y;

      Angle := ArcTan2(Dy, Dx);

      Dxx := (ScleraRadius - IrisRadius) * Cos(Angle);
      Dyy := (ScleraRadius - IrisRadius) * Sin(Angle);

      IrisLeftPosition.X := ScleraLeftPosition.X + Dxx;
      IrisLeftPosition.Y := ScleraLeftPosition.Y + Dyy;
    end;

    // Check not inside the right eye sclera
    if not CheckCollisionPointCircle(IrisRightPosition, ScleraRightPosition, ScleraRadius - 20) then
    begin
      Dx := IrisRightPosition.X - ScleraRightPosition.X;
      Dy := IrisRightPosition.Y - ScleraRightPosition.Y;

      Angle := ArcTan2(Dy, Dx);

      Dxx := (ScleraRadius - IrisRadius) * Cos(Angle);
      Dyy := (ScleraRadius - IrisRadius) * Sin(Angle);

      IrisRightPosition.X := ScleraRightPosition.X + Dxx;
      IrisRightPosition.Y := ScleraRightPosition.Y + Dyy;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawCircleV(ScleraLeftPosition, ScleraRadius, LIGHTGRAY);
      DrawCircleV(IrisLeftPosition, IrisRadius, BROWN);
      DrawCircleV(IrisLeftPosition, 10, BLACK);

      DrawCircleV(ScleraRightPosition, ScleraRadius, LIGHTGRAY);
      DrawCircleV(IrisRightPosition, IrisRadius, DARKGREEN);
      DrawCircleV(IrisRightPosition, 10, BLACK);

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

