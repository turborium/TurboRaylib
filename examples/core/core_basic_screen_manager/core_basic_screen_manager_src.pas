(*******************************************************************************************
*
*   raylib [core] examples - basic screen manager
*
*   NOTE: This example illustrates a very simple screen manager based on a states machines
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2021-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit core_basic_screen_manager_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

type
  TGameScreen = (gsLogo, gsTitle, gsGameplay, gsEnding);

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  FramesCounter: Integer;
  CurrentScreen: TGameScreen;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - basic screen manager'));

  CurrentScreen := gsLogo;

  // TODO: Initialize all required variables and load all required data here!

  FramesCounter := 0; // Useful to count frames

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    case CurrentScreen of
      gsLogo:
      begin
        // TODO: Update LOGO screen variables here!

        Inc(FramesCounter); // Count frames

        // Wait for 2 seconds (120 frames) before jumping to TITLE screen
        if FramesCounter > 120 then
          CurrentScreen := gsTitle;
      end;
      gsTitle:
      begin
        // TODO: Update TITLE screen variables here!

        // Press enter to change to GAMEPLAY screen
        if IsKeyPressed(KEY_ENTER) or IsGestureDetected(GESTURE_TAP) then
          CurrentScreen := gsGamePlay;
      end;
      gsGameplay:
      begin
        // TODO: Update GAMEPLAY screen variables here!

        // Press enter to change to ENDING screen
        if IsKeyPressed(KEY_ENTER) or IsGestureDetected(GESTURE_TAP) then
          CurrentScreen := gsEnding;
      end;
      gsEnding:
      begin
        // TODO: Update ENDING screen variables here!

        // Press enter to return to TITLE screen
        if IsKeyPressed(KEY_ENTER) or IsGestureDetected(GESTURE_TAP) then
          CurrentScreen := gsTitle;
      end;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      case CurrentScreen of
        gsLogo:
        begin
          // TODO: Draw LOGO screen here!
          DrawText(UTF8String('LOGO SCREEN'), 20, 20, 40, LIGHTGRAY);
          DrawText(UTF8String('WAIT for 2 SECONDS...'), 290, 220, 20, GRAY);
        end;
        gsTitle:
        begin
          // TODO: Draw TITLE screen here!
          DrawRectangle(0, 0, ScreenWidth, ScreenHeight, GREEN);
          DrawText(UTF8String('TITLE SCREEN'), 20, 20, 40, DARKGREEN);
          DrawText(UTF8String('PRESS ENTER or TAP to JUMP to GAMEPLAY SCREEN'), 120, 220, 20, DARKGREEN);
        end;
        gsGameplay:
        begin
          // TODO: Draw GAMEPLAY screen here!
          DrawRectangle(0, 0, ScreenWidth, ScreenHeight, PURPLE);
          DrawText(UTF8String('GAMEPLAY SCREEN'), 20, 20, 40, MAROON);
          DrawText(UTF8String('PRESS ENTER or TAP to JUMP to ENDING SCREEN'), 130, 220, 20, MAROON);
        end;
        gsEnding:
        begin
          // TODO: Draw ENDING screen here!
          DrawRectangle(0, 0, ScreenWidth, ScreenHeight, BLUE);
          DrawText(UTF8String('ENDING SCREEN'), 20, 20, 40, DARKBLUE);
          DrawText(UTF8String('PRESS ENTER or TAP to RETURN to TITLE SCREEN'), 120, 220, 20, DARKBLUE);
        end;
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

