(*******************************************************************************************
*
*   raylib [core] example - Custom logging
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example contributed by Pablo Marcos Oltra (@pamarcos) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2018-2022 Pablo Marcos Oltra (@pamarcos) and Ramon Santamaria (@raysan5)
*
********************************************************************************************)
program core_custom_logging;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}
{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  raylib in '..\..\..\raylib\raylib.pas';

function vprintf(Fmt: PAnsiChar; Args: Pointer): Integer; cdecl; varargs; external 'MSVCRT.DLL';

// Custom logging function
procedure CustomLog(MsgType: TTraceLogLevel; const Text: PAnsiChar; Args: Pointer); cdecl;
const
  StackSlotSize = SizeOf(Pointer);
begin
  writeln('[', DateTimetoStr(Now, TFormatSettings.Create('en-gb')), ']');

  case MsgType of
   LOG_INFO: write('[INFO] : ');
   LOG_ERROR: write('[ERROR] : ');
   LOG_WARNING: write('[WARN] : ');
   LOG_DEBUG: write('[DEBUG] : ');
  end;

  vprintf(text, args);
  writeln;
end;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------

  // Set custom logger
  SetTraceLogCallback(CustomLog);

  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - custom logging'));

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

    ClearBackground(RAYWHITE);

    DrawText(UTF8String('Check out the console output to see the custom logger in action!'), 60, 200, 20, LIGHTGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

