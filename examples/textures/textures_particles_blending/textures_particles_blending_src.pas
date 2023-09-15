(*******************************************************************************************
*
*   raylib example - particles blending
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit textures_particles_blending_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  MAX_PARTICLES = 200;

// Particle structure with basic data
type
  TParticle = record
    Position: TVector2;
    Color: TColor;
    Alpha: Single;
    Size: Single;
    Rotation: Single;
    Active: Boolean; // NOTE: Use it to activate/deactive particle
  end;


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  MouseTail: array [0..MAX_PARTICLES-1] of TParticle;
  I: Integer;
  Gravity: Single;
  Smoke: TTexture2D;
  Blending: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] example - particles blending'));

  // Particles pool, reuse them!
  FillChar(MouseTail, SizeOf(MouseTail), 0);

  // Initialize particles
  for I := 0 to MAX_PARTICLES - 1 do
  begin
    MouseTail[I].Position := TVector2.Create(0, 0);
    MouseTail[I].Color := TColor.Create(GetRandomValue(0, 255), GetRandomValue(0, 255), GetRandomValue(0, 255), 255);
    MouseTail[I].Alpha := 1.0;
    MouseTail[I].Size := GetRandomValue(1, 30) / 20.0;
    MouseTail[I].Rotation := GetRandomValue(0, 360);
    MouseTail[I].Active := False;
  end;

  Gravity := 3.0;

  Smoke := LoadTexture(UTF8String('resources/textures/spark_flame.png'));

  Blending := BLEND_ALPHA;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------

    // Activate one particle every frame and Update active particles
    // NOTE: Particles initial position should be mouse position when activated
    // NOTE: Particles fall down with gravity and rotation... and disappear after 2 seconds (alpha = 0)
    // NOTE: When a particle disappears, active = false and it can be reused.
    for I := 0 to MAX_PARTICLES - 1 do
    begin
      if not MouseTail[I].Active then
      begin
        MouseTail[I].Active := True;
        MouseTail[I].Alpha := 1.0;
        MouseTail[I].Position := GetMousePosition();
        break;
      end;
    end;

    for I := 0 to MAX_PARTICLES - 1 do
    begin
      if MouseTail[I].Active then
      begin
        MouseTail[I].Position.Y := MouseTail[I].Position.Y + Gravity / 2;
        MouseTail[I].Alpha := MouseTail[I].Alpha - 0.005;

        if MouseTail[I].Alpha <= 0.0 then
          MouseTail[I].Active := False;

        MouseTail[I].Rotation := MouseTail[I].Rotation + 2.0;
      end;
    end;

    if IsKeyPressed(KEY_SPACE) then
    begin
        if Blending = BLEND_ALPHA then
          Blending := BLEND_ADDITIVE
        else
          Blending := BLEND_ALPHA;
    end;

    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(DARKGRAY);

      BeginBlendMode(Blending);

        // Draw active particles
        for i := 0 to MAX_PARTICLES - 1 do
        begin
            if MouseTail[I].Active then
              DrawTexturePro(
                Smoke,
                TRectangle.Create(0.0, 0.0, Smoke.Width, Smoke.Height),
                TRectangle.Create(MouseTail[I].Position.X, MouseTail[I].Position.Y, Smoke.Width * MouseTail[I].Size, Smoke.Height * MouseTail[I].Size),
                TVector2.Create(Smoke.Width * MouseTail[I].Size / 2.0, Smoke.Height * MouseTail[I].Size / 2.0),
                MouseTail[I].Rotation,
                Fade(MouseTail[I].Color, MouseTail[I].Alpha)
              );
        end;

      EndBlendMode();

      DrawText(UTF8String('PRESS SPACE to CHANGE BLENDING MODE'), 180, 20, 20, BLACK);

      if Blending = BLEND_ALPHA then
        DrawText(UTF8String('ALPHA BLENDING'), 290, ScreenHeight - 40, 20, BLACK)
      else
        DrawText(UTF8String('ADDITIVE BLENDING'), 280, ScreenHeight - 40, 20, RAYWHITE);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Smoke);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

