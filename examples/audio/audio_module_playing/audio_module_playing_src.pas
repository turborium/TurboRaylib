(*******************************************************************************************
*
*   raylib [audio] example - Module playing (streaming)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2016-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit audio_module_playing_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  MAX_CIRCLES = 64;

type TCircleWave = record
  Position: TVector2;
  Radius: Single;
  Alpha: Single;
  Speed: Single;
  Color: TColor;
end;


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Colors: array of TColor;
  Circles: array [0..MAX_CIRCLES-1] of TCircleWave;
  I: Integer;

  Music: TMusic;
  Pitch, TimePlayed: Single;
  Pause: Boolean;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [audio] example - module playing (streaming)'));

  InitAudioDevice();                  // Initialize audio device

  Colors := [ORANGE, RED, GOLD, LIME, BLUE, VIOLET, BROWN, LIGHTGRAY, PINK,
                       YELLOW, GREEN, SKYBLUE, PURPLE, BEIGE];

  // Creates some circles for visual effect
  for I := High(Circles) downto 0 do
  begin
    Circles[I].Alpha := 0.0;
    Circles[I].Radius := GetRandomValue(10, 40);
    Circles[I].Position.X := GetRandomValue(Trunc(Circles[I].Radius), Trunc(ScreenWidth - Circles[I].Radius));
    Circles[I].Position.Y := GetRandomValue(Trunc(Circles[I].Radius), Trunc(ScreenHeight - Circles[I].Radius));
    Circles[I].Speed := GetRandomValue(1, 100) / 2000.0;
    Circles[I].Color := colors[GetRandomValue(0, 13)];
  end;

  Music := LoadMusicStream(UTF8String('resources/audio/mini1111.xm'));
  Music.Looping := False;
  Pitch := 1.0;

  PlayMusicStream(Music);

  Pause := False;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateMusicStream(Music);      // Update music buffer with new stream data

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

    if IsKeyDown(KEY_DOWN) then
      Pitch := Pitch - 0.01
    else if IsKeyDown(KEY_UP) then
      Pitch := Pitch + 0.01;

    SetMusicPitch(Music, Pitch);

    // Get timePlayed scaled to bar dimensions
    TimePlayed := GetMusicTimePlayed(Music) / GetMusicTimeLength(Music) * (ScreenWidth - 40);

    // Color circles animation
    if not Pause then
    begin
      for I := High(Circles) downto 0 do
      begin
        Circles[I].Alpha := Circles[I].Alpha + Circles[I].Speed * Pitch;
        Circles[I].Radius := Circles[I].Radius + Circles[I].Speed * 10.0;

        if Circles[I].Alpha > 1.0 then
          Circles[I].Speed := -Circles[I].Speed;

        if Circles[I].Alpha <= 0.0 then
        begin
          Circles[I].Alpha := 0.0;
          Circles[I].Radius := GetRandomValue(10, 40);
          Circles[I].Position.X := GetRandomValue(Trunc(Circles[I].Radius), Trunc(ScreenWidth - Circles[I].Radius));
          Circles[I].Position.Y := GetRandomValue(Trunc(Circles[I].Radius), Trunc(ScreenHeight - Circles[I].Radius));
          Circles[I].Color := Colors[GetRandomValue(0, 13)];
          Circles[I].Speed := GetRandomValue(1, 100) / 2000.0;
        end;
      end;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      for I := High(Circles) downto 0 do
        DrawCircleV(Circles[I].Position, Circles[I].Radius, Fade(Circles[I].Color, Circles[I].Alpha));

      // Draw time bar
      DrawRectangle(20, ScreenHeight - 20 - 12, ScreenWidth - 40, 12, LIGHTGRAY);
      DrawRectangle(20, ScreenHeight - 20 - 12, Trunc(TimePlayed), 12, MAROON);
      DrawRectangleLines(20, ScreenHeight - 20 - 12, ScreenWidth - 40, 12, GRAY);

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

