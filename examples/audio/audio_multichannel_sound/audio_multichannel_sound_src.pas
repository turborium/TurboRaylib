(*******************************************************************************************
*
*   raylib [audio] example - Multichannel sound playing
*
*   Example originally created with raylib 3.0, last time updated with raylib 3.5
*
*   Example contributed by Chris Camacho (@chriscamacho) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2022 Chris Camacho (@chriscamacho) and Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit audio_multichannel_sound_src;

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
  FxWav, FxOgg: TSound;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [audio] example - Multichannel sound playing'));

  InitAudioDevice();      // Initialize audio device

  FxWav := LoadSound(UTF8String('resources/audio/sound.wav'));         // Load WAV audio file
  FxOgg := LoadSound(UTF8String('resources/audio/target.ogg'));        // Load OGG audio file

  SetSoundVolume(fxWav, 0.2);

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyPressed(KEY_SPACE) then PlaySoundMulti(FxWav);      // Play a new wav sound instance
    if IsKeyPressed(KEY_ENTER) then PlaySoundMulti(FxOgg);      // Play a new ogg sound instance
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(UTF8String('MULTICHANNEL SOUND PLAYING'), 20, 20, 20, GRAY);
      DrawText(UTF8String('Press SPACE to play new ogg instance!'), 200, 120, 20, LIGHTGRAY);
      DrawText(UTF8String('Press ENTER to play new wav instance!'), 200, 180, 20, LIGHTGRAY);

      DrawText(TextFormat(UTF8String('CONCURRENT SOUNDS PLAYING: %02i'), GetSoundsPlaying()), 220, 280, 20, RED);


    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadSound(FxWav);     // Unload sound data
  UnloadSound(FxOgg);     // Unload sound data

  CloseAudioDevice();     // Close audio device

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

