(*******************************************************************************************
*
*   raylib [core] example - Windows drop files
*
*   NOTE: This example only works on platforms that support drag & drop (Windows, Linux, OSX, Html5?)
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit core_drop_files_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  Math,
  raylib in '..\..\..\raylib\raylib.pas',
  raymath in '..\..\..\raylib\raymath.pas';

// fixed bugs in original example

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  DroppedFiles: TFilePathList;
  I: Integer;
  FileList: array of UTF8String;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------

  SetConfigFlags(FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - drop files'));

  DroppedFiles := Default(TFilePathList);

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsFileDropped() then
    begin
      FileList := [];

      DroppedFiles := LoadDroppedFiles();

      {$POINTERMATH ON}
      for I := 0 to DroppedFiles.Count - 1 do
        FileList := FileList + [UTF8String(DroppedFiles.Paths[I])];
      {$POINTERMATH OFF}

      UnloadDroppedFiles(DroppedFiles);
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      if DroppedFiles.Count = 0 then
        DrawText(UTF8String('Drop your files to this window!'), 100, 40, 20, DARKGRAY)
      else
      begin
        DrawText(UTF8String('Dropped files:'), 100, 40, 20, DARKGRAY);

        for I := 0 to High(FileList) do
        begin
          if I mod 2 = 0 then
            DrawRectangle(0, 85 + 40 * I, ScreenWidth, 40, Fade(LIGHTGRAY, 0.5))
          else
            DrawRectangle(0, 85 + 40 * I, ScreenWidth, 40, Fade(LIGHTGRAY, 0.3));
          DrawText(PUTF8Char(FileList[I]), 120, 100 + 40 * I, 10, GRAY);
        end;

        DrawText(UTF8String('Drop new files...'), 100, 110 + 40 * DroppedFiles.Count, 20, DARKGRAY);
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

