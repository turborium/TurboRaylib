(*******************************************************************************************
*
*   raylib [audio] example - Music stream processing effects
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2022-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit audio_stream_effects_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}
{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib,
  StrUtils;

var
  // Required delay effect variables
  DelayBuffer: PSingle = nil;
  DelayBufferSize: Cardinal = 0;
  DelayReadIndex: Cardinal = 2;
  DelayWriteIndex: Cardinal = 0;

//------------------------------------------------------------------------------------
// Module Functions Declaration
//------------------------------------------------------------------------------------
procedure AudioProcessEffectLPF(Buffer: Pointer; Frames: Cardinal); cdecl; forward;  // Audio effect: lowpass filter
procedure AudioProcessEffectDelay(Buffer: Pointer; Frames: Cardinal); cdecl; forward; // Audio effect: delay

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
  EnableEffectLPF, EnableEffectDelay: Boolean;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [audio] example - sound loading and playing'));

  InitAudioDevice();      // Initialize audio device

  Music := LoadMusicStream('resources/audio/country.mp3');

  // Allocate buffer for the delay effect
  DelayBufferSize := 48000 * 2;      // 1 second delay (device sampleRate*channels)
  DelayBuffer := AllocMem(DelayBufferSize * SizeOf(Single));
  PlayMusicStream(Music);
  Pause := False;             // Music playing paused
  EnableEffectLPF := false;   // Enable effect low-pass-filter
  EnableEffectDelay := false; // Enable effect delay (1 second)

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //----------------------------------------------------------------------------------
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
    // Add/Remove effect: lowpass filter
    if IsKeyPressed(KEY_F) then
    begin
      EnableEffectLPF := not EnableEffectLPF;
      if EnableEffectLPF then
        AttachAudioStreamProcessor(Music.Stream, AudioProcessEffectLPF)
      else
        DetachAudioStreamProcessor(music.stream, AudioProcessEffectLPF);
    end;
    // Add/Remove effect: delay
    if IsKeyPressed(KEY_D) then
    begin
      EnableEffectDelay := not EnableEffectDelay;
      if EnableEffectDelay then
        AttachAudioStreamProcessor(Music.Stream, AudioProcessEffectDelay)
      else
        DetachAudioStreamProcessor(Music.Stream, AudioProcessEffectDelay);
    end;
    // Get normalized time played for current music stream
    TimePlayed := GetMusicTimePlayed(Music) / GetMusicTimeLength(Music);
    if TimePlayed > 1.0 then TimePlayed := 1.0;   // Make sure time played is no longer than music
    //----------------------------------------------------------------------------------
    // Draw
    //----------------------------------------------------------------------------------
    BeginDrawing();
      ClearBackground(RAYWHITE);
      DrawText(UTF8String('MUSIC SHOULD BE PLAYING!'), 245, 150, 20, LIGHTGRAY);
      DrawRectangle(200, 180, 400, 12, LIGHTGRAY);
      DrawRectangle(200, 180, Trunc(TimePlayed * 400.0), 12, MAROON);
      DrawRectangleLines(200, 180, 400, 12, GRAY);
      DrawText(UTF8String('PRESS SPACE TO RESTART MUSIC'), 215, 230, 20, LIGHTGRAY);
      DrawText(UTF8String('PRESS P TO PAUSE/RESUME MUSIC'), 208, 260, 20, LIGHTGRAY);
      DrawText(TextFormat(UTF8String('PRESS F TO TOGGLE LPF EFFECT: %s'), UTF8String(IfThen(EnableEffectLPF, UTF8String('ON'), UTF8String('OFF')))), 200, 320, 20, GRAY);
      DrawText(TextFormat(UTF8String('PRESS D TO TOGGLE DELAY EFFECT: %s'), UTF8String(IfThen(EnableEffectDelay, UTF8String('ON'), UTF8String('OFF')))), 180, 350, 20, GRAY);
    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadMusicStream(Music);   // Unload music stream buffers from RAM

  CloseAudioDevice();         // Close audio device (music streaming is automatically stopped)
  FreeMem(DelayBuffer);       // Free delay buffer

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

//------------------------------------------------------------------------------------
// Module Functions Definition
//------------------------------------------------------------------------------------
var
  Low: array [0..1] of Single = (0.0, 0.0);
const
  Cutoff = 70.0 / 44100.0; // 70 Hz lowpass filter
  K = Cutoff / (Cutoff + 0.1591549431); // RC filter formula
// Audio effect: lowpass filter
procedure AudioProcessEffectLPF(Buffer: Pointer; Frames: Cardinal);
var
  I: Cardinal;
  L, R: Single;
begin
  I := 0;
  while I < frames*2 do
  begin
    L := PSingle(Buffer)[I];
    R := PSingle(Buffer)[I + 1];
    Low[0] := Low[0] + K * (L - Low[0]);
    Low[1] := Low[1] + K * (R - Low[1]);
    PSingle(Buffer)[I] := Low[0];
    PSingle(Buffer)[I + 1] := Low[1];
    I := I + 2;
  end;
end;
// Audio effect: delay
procedure AudioProcessEffectDelay(Buffer: Pointer; Frames: Cardinal);
var
  I: Cardinal;
  LeftDelay, RightDelay: Single;
begin
  I := 0;
  while I < Frames * 2 do
  begin
    LeftDelay := DelayBuffer[DelayReadIndex];    // ERROR: Reading buffer -> WHY??? Maybe thread related???
    Inc(DelayReadIndex);
    RightDelay := DelayBuffer[DelayReadIndex];
    Inc(DelayReadIndex);
    if DelayReadIndex = DelayBufferSize then
      DelayReadIndex := 0;
    PSingle(Buffer)[I] := 0.5 * PSingle(Buffer)[I] + 0.5 * LeftDelay;
    PSingle(Buffer)[I + 1] := 0.5 * PSingle(Buffer)[I + 1] + 0.5 * RightDelay;
    DelayBuffer[DelayWriteIndex] := PSingle(Buffer)[I];
    Inc(DelayWriteIndex);
    DelayBuffer[DelayWriteIndex] := PSingle(Buffer)[I + 1];
    Inc(DelayWriteIndex);
    if DelayWriteIndex = DelayBufferSize then
      DelayWriteIndex := 0;
    I := I + 2;
  end;
end;

end.

