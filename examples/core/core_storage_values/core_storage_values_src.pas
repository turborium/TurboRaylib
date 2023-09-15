(*******************************************************************************************
*
*   raylib [core] example - Storage save/load values
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit core_storage_values_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

{$POINTERMATH ON} // This example includes raw pointer arithmetic because activate it

uses
  SysUtils,
  raylib,
  raymath,
  rlgl;

const
  STORAGE_DATA_FILE = 'storage.data'; // Storage file

  // NOTE: Storage positions must start with 0, directly related to file memory layout
  STORAGE_POSITION_SCORE      = 0;
  STORAGE_POSITION_HISCORE    = 1;

// Persistent storage functions
function SaveStorageValue(Position: Cardinal; Value: Integer): Boolean; forward;
function LoadStorageValue(Position: Cardinal): Integer; forward;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Score, HiScore: Integer;
  FramesCounter: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);

  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - storage save/load values'));

  Score := 0;
  HiScore := 0;
  FramesCounter := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyPressed(KEY_R) then
    begin
      Score := GetRandomValue(1000, 2000);
      HiScore := GetRandomValue(2000, 4000);
    end;

    if IsKeyPressed(KEY_ENTER) then
    begin
      SaveStorageValue(STORAGE_POSITION_SCORE, Score);
      SaveStorageValue(STORAGE_POSITION_HISCORE, HiScore);
    end
    else if IsKeyPressed(KEY_SPACE) then
    begin
      // NOTE: If requested position could not be found, value 0 is returned
      Score := LoadStorageValue(STORAGE_POSITION_SCORE);
      HiScore := LoadStorageValue(STORAGE_POSITION_HISCORE);
    end;

    Inc(FramesCounter);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(TextFormat(UTF8String('SCORE: %i'), Score), 280, 130, 40, MAROON);
      DrawText(TextFormat(UTF8String('HI-SCORE: %i'), HiScore), 210, 200, 50, BLACK);

      DrawText(TextFormat(UTF8String('frames: %i'), FramesCounter), 10, 10, 20, LIME);

      DrawText(UTF8String('Press R to generate random numbers'), 220, 40, 20, LIGHTGRAY);
      DrawText(UTF8String('Press ENTER to SAVE values'), 250, 310, 20, LIGHTGRAY);
      DrawText(UTF8String('Press SPACE to LOAD values'), 252, 350, 20, LIGHTGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

// Save integer value to storage file (to defined position)
// NOTE: Storage positions is directly related to file memory layout (4 bytes each integer)
function SaveStorageValue(Position: Cardinal; Value: Integer): Boolean;
var
  DataSize, NewDataSize: Cardinal;
  FileData, NewFileData: PByte;
begin
  //Result := False;
  DataSize := 0;
  //NewDataSize := 0;
  FileData := LoadFileData(STORAGE_DATA_FILE, @DataSize);
  //NewFileData := nil;

  if FileData <> nil then
  begin
    if DataSize <= (Position * SizeOf(Integer)) then
    begin
      // Increase data size up to position and store value
      NewDataSize := (Position + 1) * SizeOf(Integer);
      NewFileData := MemRealloc(FileData, NewDataSize);

      if NewFileData <> nil then
      begin
        // RL_REALLOC succeded
        PInteger(NewFileData)[Position] := Value;
      end else
      begin
        // RL_REALLOC failed
        TraceLog(LOG_WARNING, UTF8String('FILEIO: [%s] Failed to realloc data (%u), position in bytes (%u) bigger than actual file size'), STORAGE_DATA_FILE, DataSize, Position * SizeOf(Integer));

        // We store the old size of the file
        NewFileData := FileData;
        NewDataSize := DataSize;
      end;
    end else
    begin
      // Store the old size of the file
      NewFileData := FileData;
      NewDataSize := DataSize;

      // Replace value on selected position
      PInteger(NewFileData)[Position] := Value;
    end;

    Result := SaveFileData(STORAGE_DATA_FILE, NewFileData, NewDataSize);
    MemFree(NewFileData);

    TraceLog(LOG_INFO, UTF8String('FILEIO: [%s] Saved storage value: %i'), STORAGE_DATA_FILE, value);
  end else
  begin
    TraceLog(LOG_INFO, UTF8String('FILEIO: [%s] File created successfully'), STORAGE_DATA_FILE);

    DataSize := (Position + 1) * SizeOf(Integer);
    FileData := MemAlloc(DataSize);
    PInteger(FileData)[Position] := Value;

    Result := SaveFileData(STORAGE_DATA_FILE, FileData, DataSize);
    UnloadFileData(FileData);

    TraceLog(LOG_INFO, UTF8String('FILEIO: [%s] Saved storage value: %i'), STORAGE_DATA_FILE, Value);
  end;
end;

// Load integer value from storage file (from defined position)
// NOTE: If requested position could not be found, value 0 is returned
function LoadStorageValue(Position: Cardinal): Integer;
var
  DataSize: Cardinal;
  FileData: PByte;
begin
  Result := 0;
  DataSize := 0;
  FileData := LoadFileData(STORAGE_DATA_FILE, @DataSize);

  if FileData <> nil then
  begin
    if DataSize < (Position * 4) then
      TraceLog(LOG_WARNING, UTF8String('FILEIO: [%s] Failed to find storage position: %i'), STORAGE_DATA_FILE, Position)
    else
    begin
      Result := PInteger(FileData)[position];
    end;

    UnloadFileData(FileData);

    TraceLog(LOG_INFO, UTF8String('FILEIO: [%s] Loaded storage value: %i'), STORAGE_DATA_FILE, Result);
  end;
end;
 
end.

