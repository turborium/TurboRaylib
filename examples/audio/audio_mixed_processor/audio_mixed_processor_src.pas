(*******************************************************************************************
*
*   raylib [audio] example - Mixed audio processing
*
*   Example contributed by hkc (@hatkidchan) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2023-2023 hkc (@hatkidchan)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit audio_mixed_processor_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}
{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib,
  Math;

var
  Exponent: Single = 1.0;                    // Audio exponentiation value
  AverageVolume: array [0..400-1] of Single; // Average volume history

//------------------------------------------------------------------------------------
// Audio processing function
//------------------------------------------------------------------------------------
procedure ProcessAudio(Buffer: Pointer; Frames: Cardinal); cdecl;
var
  Samples: PSingle;
  Average: Single;
  Frame: Cardinal;
  Left, Right: PSingle;
  I: Integer;
begin
  Samples := Buffer; // Samples internally stored as <float>s
  Average := 0.0;    // Temporary average volume
  for Frame := 0 to Frames - 1 do
  begin
    Left := @Samples[Frame * 2 + 0];
    Right := @Samples[Frame * 2 + 1];
    Left^ := Power(Abs(Left^), Exponent) * IfThen(left^ < 0.0, -1.0, 1.0);
    Right^ := Power(Abs(Right^), Exponent) * IfThen(Right^ < 0.0, -1.0, 1.0);
    Average := Average + Abs(Left^) / Frames; // accumulating average volume
    Average := Average + Abs(Right^) / Frames;
  end;
  // Moving history to the left
  for I := 0 to 399 - 1 do AverageVolume[I] := AverageVolume[I + 1];
  AverageVolume[399] := Average; // Adding last average value
end;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Sound: TSound;
  Music: TMusic;
  I: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [audio] example - processing mixed output'));

  InitAudioDevice();      // Initialize audio device

  AttachAudioMixedProcessor(ProcessAudio);

  Music := LoadMusicStream('resources/audio/country.mp3');
  Sound := LoadSound('resources/audio/coin.wav');
  PlayMusicStream(music);

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateMusicStream(Music); // Update music buffer with new stream data

    // Modify processing variables
    //----------------------------------------------------------------------------------
    if IsKeyPressed(KEY_LEFT) then Exponent := Exponent - 0.05;
    if IsKeyPressed(KEY_RIGHT) then Exponent := Exponent + 0.05;
    if Exponent <= 0.5 then Exponent := 0.5;
    if Exponent >= 3.0 then Exponent := 3.0;
    if IsKeyPressed(KEY_SPACE) then PlaySound(sound);

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(UTF8String('MUSIC SHOULD BE PLAYING!'), 255, 150, 20, LIGHTGRAY);

      DrawText(TextFormat(UTF8String('EXPONENT = %.2f'), Exponent), 215, 180, 20, LIGHTGRAY);
      DrawRectangle(199, 199, 402, 34, LIGHTGRAY);
      for I := 0 to 400 - 1 do
      begin
        DrawLine(201 + I, Trunc(232 - AverageVolume[I] * 32), 201 + I, 232, MAROON);
      end;
      DrawRectangleLines(199, 199, 402, 34, GRAY);
      DrawText(UTF8String('PRESS SPACE TO PLAY OTHER SOUND'), 200, 250, 20, LIGHTGRAY);
      DrawText(UTF8String('USE LEFT AND RIGHT ARROWS TO ALTER DISTORTION'), 140, 280, 20, LIGHTGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadMusicStream(Music);   // Unload music stream buffers from RAM

  DetachAudioMixedProcessor(ProcessAudio);  // Disconnect audio processor

  CloseAudioDevice();     // Close audio device

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

