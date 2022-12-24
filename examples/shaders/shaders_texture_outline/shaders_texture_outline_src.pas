(*******************************************************************************************
*
*   raylib [shaders] example - Apply an shdrOutline to a texture
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   Example originally created with raylib 4.0, last time updated with raylib 4.0
*
*   Example contributed by Samuel Skiff (@GoldenThumbs) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2021-2022 Samuel SKiff (@GoldenThumbs) and Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit shaders_texture_outline_src;

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
  ShdrOutline: TShader;
  Texture: TTexture2D;
  OutlineSize: Single;
  OutlineColor: array of Single;
  TextureSize: array of Single;
  OutlineSizeLoc, OutlineColorLoc, TextureSizeLoc: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags({FLAG_MSAA_4X_HINT or} FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - Apply an outline to a texture'));

  Texture := LoadTexture(UTF8String('resources/shaders/fudesumi.png'));

  ShdrOutline := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/outline.fs'), Integer(GLSL_VERSION)));

  OutlineSize := 2.0;
  OutlineColor := [1.0, 0.0, 0.0, 1.0];     // Normalized RED color
  TextureSize := [Texture.Width, Texture.Height];

  // Get shader locations
  OutlineSizeLoc := GetShaderLocation(ShdrOutline, UTF8String('outlineSize'));
  OutlineColorLoc := GetShaderLocation(ShdrOutline, UTF8String('outlineColor'));
  TextureSizeLoc := GetShaderLocation(ShdrOutline, UTF8String('textureSize'));

  // Set shader values (they can be changed later)
  SetShaderValue(ShdrOutline, OutlineSizeLoc, @OutlineSize, SHADER_UNIFORM_FLOAT);
  SetShaderValue(ShdrOutline, OutlineColorLoc, @OutlineColor[0], SHADER_UNIFORM_VEC4);
  SetShaderValue(ShdrOutline, TextureSizeLoc, @TextureSize[0], SHADER_UNIFORM_VEC2);

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    OutlineSize := OutlineSize + GetMouseWheelMove();
    if OutlineSize < 1.0 then
      OutlineSize := 1.0;

    SetShaderValue(ShdrOutline, OutlineSizeLoc, @OutlineSize, SHADER_UNIFORM_FLOAT);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginShaderMode(ShdrOutline);

        DrawTexture(Texture, GetScreenWidth() div 2 - Texture.Width div 2, -30, WHITE);

      EndShaderMode();

      DrawText(UTF8String('Shader-based'#10'texture\noutline'), 10, 10, 20, GRAY);

      DrawText(TextFormat(UTF8String('Outline size: %i px'), Trunc(OutlineSize)), 10, 120, 20, MAROON);

      DrawFPS(710, 10);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Texture);
  UnloadShader(ShdrOutline);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

