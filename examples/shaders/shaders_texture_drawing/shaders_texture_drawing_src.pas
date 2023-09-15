(*******************************************************************************************
*
*   raylib [textures] example - Texture drawing
*
*   NOTE: This example illustrates how to draw into a blank texture using a shader
*
*   Example contributed by Michał Ciesielski and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2023 Michał Ciesielski and Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit shaders_texture_drawing_src;

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
  Shader: TShader;
  Texture: TTexture2D;
  ImBlank: TImage;
  Time: Single;
  TimeLoc: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags({FLAG_MSAA_4X_HINT or} FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - texture drawing'));

  ImBlank := GenImageColor(1024, 1024, BLANK);
  Texture := LoadTextureFromImage(ImBlank);  // Load blank texture to fill on shader
  UnloadImage(ImBlank);

  // Load raymarching shader
  // NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
  Shader := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/cubes_panning.fs'), Integer(GLSL_VERSION)));

  Time := 0.0;
  TimeLoc := GetShaderLocation(Shader, UTF8String('uTime'));
  SetShaderValue(Shader, TimeLoc, @Time, SHADER_UNIFORM_FLOAT);

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    Time := GetTime();
    SetShaderValue(Shader, TimeLoc, @Time, SHADER_UNIFORM_FLOAT);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginShaderMode(Shader);    // Enable our custom shader for next shapes/textures drawings
          DrawTexture(Texture, 0, 0, WHITE);  // Drawing BLANK texture, all magic happens on shader
      EndShaderMode();            // Disable our custom shader, return to default shader

      DrawText(UTF8String('BACKGROUND is PAINTED and ANIMATED on SHADER!'), 10, 10, 20, MAROON);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadShader(Shader);           // Unload shader

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

