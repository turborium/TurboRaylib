(*******************************************************************************************
*
*   raylib [audio] example - Music playing (streaming)
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit audio_music_stream_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

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
  Music: TMusic;
  TimePlayed: Single;
  Pause: Boolean;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [audio] example - music playing (streaming)'));

  InitAudioDevice();                  // Initialize audio device

  Music := LoadMusicStream(UTF8String('resources/audio/country.mp3'));

  PlayMusicStream(Music);

  Pause := False;             // Music playing paused

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateMusicStream(Music);   // Update music buffer with new stream data

    // Restart music playing (stop and play)
    if IsKeyPressed(KEY_SPACE) then
    begin
      StopMusicStream(Music);
      PlayMusicStream(Music);
    end;

    // Pause/Resume music playing
    if IsKeyPressed(KEY_P) then
    begin
      Pause := not Pause;

      if Pause then
        PauseMusicStream(Music)
      else
        ResumeMusicStream(Music);
    end;

    // Get normalized time played for current music stream
    TimePlayed := GetMusicTimePlayed(Music) / GetMusicTimeLength(Music);

    if TimePlayed > 1.0 then
      TimePlayed := 1.0;   // Make sure time played is no longer than music
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(UTF8String('MUSIC SHOULD BE PLAYING!'), 255, 150, 20, LIGHTGRAY);

      DrawRectangle(200, 200, 400, 12, LIGHTGRAY);
      DrawRectangle(200, 200, Trunc(TimePlayed * 400.0), 12, MAROON);
      DrawRectangleLines(200, 200, 400, 12, GRAY);

      DrawText(UTF8String('PRESS SPACE TO RESTART MUSIC'), 215, 250, 20, LIGHTGRAY);
      DrawText(UTF8String('PRESS P TO PAUSE/RESUME MUSIC'), 208, 280, 20, LIGHTGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadMusicStream(Music);          // Unload music stream buffers from RAM

  CloseAudioDevice();     // Close audio device (music streaming is automatically stopped)

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

