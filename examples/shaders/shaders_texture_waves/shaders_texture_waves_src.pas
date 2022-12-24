(*******************************************************************************************
*
*   raylib [shaders] example - Texture Waves
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.7
*
*   Example contributed by Anata (@anatagawa) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2022 Anata (@anatagawa) and Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit shaders_texture_waves_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib,
  raymath;

const
  GLSL_VERSION = 330;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Texture: TTexture2D;
  Shader: TShader;
  SecondsLoc, FreqXLoc, FreqYLoc, AmpXLoc, AmpYLoc, SpeedXLoc, SpeedYLoc: Integer;
  FreqX, FreqY, AmpX, AmpY, SpeedX, SpeedY: Single;
  ScreenSize: array [0..1] of Single;
  Seconds: Single;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags({FLAG_MSAA_4X_HINT or} FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - texture waves'));

  // Load texture texture to apply shaders
  Texture := LoadTexture(UTF8String('resources/shaders/space.png'));

  // Load shader and setup location points and values
  Shader := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/wave.fs'), Integer(GLSL_VERSION)));

  SecondsLoc := GetShaderLocation(Shader, UTF8String('secondes'));
  FreqXLoc := GetShaderLocation(Shader, UTF8String('freqX'));
  FreqYLoc := GetShaderLocation(Shader, UTF8String('freqY'));
  AmpXLoc := GetShaderLocation(Shader, UTF8String('ampX'));
  AmpYLoc := GetShaderLocation(Shader, UTF8String('ampY'));
  SpeedXLoc := GetShaderLocation(Shader, UTF8String('speedX'));
  SpeedYLoc := GetShaderLocation(Shader, UTF8String('speedY'));

  // Shader uniform values that can be updated at any time
  FreqX := 25.0;
  FreqY := 25.0;
  AmpX := 5.0;
  AmpY := 5.0;
  SpeedX := 8.0;
  SpeedY := 8.0;

  ScreenSize[0] := GetScreenWidth(); ScreenSize[1] := GetScreenHeight();
  SetShaderValue(Shader, GetShaderLocation(Shader, UTF8String('size')), @ScreenSize, SHADER_UNIFORM_VEC2);
  SetShaderValue(Shader, FreqXLoc, @FreqX, SHADER_UNIFORM_FLOAT);
  SetShaderValue(Shader, FreqYLoc, @FreqY, SHADER_UNIFORM_FLOAT);
  SetShaderValue(Shader, AmpXLoc, @AmpX, SHADER_UNIFORM_FLOAT);
  SetShaderValue(Shader, AmpYLoc, @AmpY, SHADER_UNIFORM_FLOAT);
  SetShaderValue(Shader, SpeedXLoc, @SpeedX, SHADER_UNIFORM_FLOAT);
  SetShaderValue(Shader, SpeedYLoc, @SpeedY, SHADER_UNIFORM_FLOAT);

  Seconds := 0.0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    Seconds := Seconds + GetFrameTime();

    SetShaderValue(Shader, SecondsLoc, @Seconds, SHADER_UNIFORM_FLOAT);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginShaderMode(Shader);

        DrawTexture(Texture, 0, 0, WHITE);
        DrawTexture(Texture, Texture.Width, 0, WHITE);

      EndShaderMode();

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Texture);
  UnloadShader(Shader);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

