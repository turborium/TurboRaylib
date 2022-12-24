(*******************************************************************************************
*
*   raylib [shapes] example - easings box anim
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit shapes_easings_box_anim_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  Math,
  raylib,
  reasings;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  State: Integer;
  FramesCounter: Integer;
  Rec: TRectangle;
  Alpha, Rotation: Single;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shapes] example - easings box anim'));

  // Box variables to be animated with easings
  Rec := TRectangle.Create(GetScreenWidth() / 2.0, -100, 100, 100);
  Rotation := 0.0;
  Alpha := 1.0;

  State := 0;
  FramesCounter := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    case State of
      0: // Move box down to center of screen
      begin
        Inc(FramesCounter);
        // NOTE: Remember that 3rd parameter of easing function refers to
        // desired value variation, do not confuse it with expected final value!
        Rec.Y := EaseElasticOut(FramesCounter, -100, GetScreenHeight() / 2.0 + 100, 120);

        if FramesCounter >= 120 then
        begin
          FramesCounter := 0;
          State := 1;
        end;
      end;
      1: // Scale box to an horizontal bar
      begin
        Inc(FramesCounter);
        Rec.Height := EaseBounceOut(FramesCounter, 100, -90, 120);
        Rec.Width := EaseBounceOut(FramesCounter, 100, GetScreenWidth(), 120);

        if FramesCounter >= 120 then
        begin
          FramesCounter := 0;
          State := 2;
        end;
      end;
      2: // Rotate horizontal bar rectangle
      begin
        Inc(FramesCounter);
        Rotation := EaseQuadOut(FramesCounter, 0.0, 270.0, 240);

        if FramesCounter >= 240 then
        begin
          FramesCounter := 0;
          State := 3;
        end;
      end;
      3: // Increase bar size to fill all screen
      begin
        Inc(FramesCounter);
        Rec.Height := EaseCircOut(FramesCounter, 10, GetScreenWidth(), 120);

        if FramesCounter >= 120 then
        begin
          FramesCounter := 0;
          State := 4;
        end;
      end;
      4: // Fade out animation
      begin
        Inc(FramesCounter);
        Alpha := EaseSineOut(FramesCounter, 1.0, -1.0, 160);

        if FramesCounter >= 160 then
        begin
          FramesCounter := 0;
          State := 5;
        end;
      end;
    end;

    // Reset animation at any moment
    if IsKeyPressed(KEY_SPACE) then
    begin
      Rec := TRectangle.Create(GetScreenWidth() / 2.0, -100, 100, 100);
      Rotation := 0.0;
      Alpha := 1.0;
      State := 0;
      FramesCounter := 0;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawRectanglePro(Rec, TVector2.Create(Rec.Width / 2, Rec.Height / 2), Rotation, Fade(BLACK, Alpha));

      DrawText(UTF8String('PRESS [SPACE] TO RESET BOX ANIMATION!'), 10, GetScreenHeight() - 25, 20, LIGHTGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

