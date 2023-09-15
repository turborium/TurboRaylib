(*******************************************************************************************
*
*   raylib [audio] example - Sound loading and playing
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit audio_sound_loading_src;

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
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [audio] example - sound loading and playing'));

  InitAudioDevice();      // Initialize audio device

  FxWav := LoadSound(UTF8String('resources/audio/sound.wav'));         // Load WAV audio file
  FxOgg := LoadSound(UTF8String('resources/audio/target.ogg'));        // Load OGG audio file

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyPressed(KEY_SPACE) then PlaySound(FxWav);      // Play WAV sound
    if IsKeyPressed(KEY_ENTER) then PlaySound(FxOgg);      // Play OGG sound
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(UTF8String('Press SPACE to PLAY the WAV sound!'), 200, 180, 20, LIGHTGRAY);
      DrawText(UTF8String('Press ENTER to PLAY the OGG sound!'), 200, 220, 20, LIGHTGRAY);

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

