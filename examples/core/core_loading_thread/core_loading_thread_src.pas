(*******************************************************************************************
*
*   raylib [core] example - loading thread
*
*   NOTE: This example requires linking with pthreads library on MinGW,
*   it can be accomplished passing -static parameter to compiler
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*
*   Copyright (c) 2014-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit core_loading_thread_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  Classes,
  raylib in '..\..\..\raylib\raylib.pas';

var
  DataLoaded: Boolean = False;
  DataProgress: Integer = 0;

// Loading data thread function definition
procedure LoadDataThread();
var
  TimeCounter: Integer;
  PrevTime: UInt64;
begin
  TimeCounter := 0; // Time counted in ms
  PrevTime := TThread.GetTickCount64(); // Previous time

  // We simulate data loading with a time counter for 5 seconds
  while TimeCounter < 5000 do
  begin
    TimeCounter := TThread.GetTickCount64() - PrevTime;

    // We accumulate time over a global variable to be used in
    // main thread as a progress bar
    DataProgress := TimeCounter div 10;
  end;

  // When data has finished loading, we set global variable
  DataLoaded := True;
end;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  FramesCounter: Integer;
  State: (STATE_WAITING, STATE_LOADING, STATE_FINISHED);
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);

  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - loading thread'));

  State := STATE_WAITING;
  FramesCounter := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    case State of
      STATE_WAITING:
      begin
        if IsKeyPressed(KEY_ENTER) then
        begin
          TThread.CreateAnonymousThread(LoadDataThread).Start();
          State := STATE_LOADING;
        end;
      end;
      STATE_LOADING:
      begin
        Inc(FramesCounter);
        if DataLoaded then
        begin
          FramesCounter := 0;
          State := STATE_FINISHED;
        end;
      end;
      STATE_FINISHED:
      begin
        if IsKeyPressed(KEY_ENTER) then
        begin
          // Reset everything to launch again
          DataLoaded := False;
          DataProgress := 0;
          State := STATE_WAITING;
        end;
      end;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      case State of
        STATE_WAITING:
        begin
          DrawText(UTF8String('PRESS ENTER to START LOADING DATA'), 150, 170, 20, DARKGRAY);
        end;
        STATE_LOADING:
        begin
          DrawRectangle(150, 200, DataProgress, 60, SKYBLUE);
          if ((FramesCounter div 15) mod 2) <> 0 then
            DrawText(UTF8String('LOADING DATA...'), 240, 210, 40, DARKBLUE);
        end;
        STATE_FINISHED:
        begin
          DrawRectangle(150, 200, 500, 60, LIME);
          DrawText(UTF8String('DATA LOADED!'), 250, 210, 40, GREEN);
        end;
      end;

      DrawRectangleLines(150, 200, 500, 60, DARKGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

