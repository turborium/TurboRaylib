(*******************************************************************************************
*
*   raylib [shaders] example - Sieve of Eratosthenes
*
*   NOTE: Sieve of Eratosthenes, the earliest known (ancient Greek) prime number sieve.
*
*       "Sift the twos and sift the threes,
*        The Sieve of Eratosthenes.
*        When the multiples sublime,
*        the numbers that are left are prime."
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
*
*   Example originally created with raylib 2.5, last time updated with raylib 4.0
*
*   Example contributed by ProfJski and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2022 ProfJski and Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit shaders_eratosthenes_src;

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
  Target: TRenderTexture2D;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags({FLAG_MSAA_4X_HINT or} FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - Sieve of Eratosthenes'));

  Target := LoadRenderTexture(ScreenWidth, ScreenHeight);

  // Load Eratosthenes shader
  // NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
  Shader := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/eratosthenes.fs'), Integer(GLSL_VERSION)));

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------

    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginTextureMode(Target);       // Enable drawing to texture
      ClearBackground(BLACK);     // Clear the render texture

      // Draw a rectangle in shader mode to be used as shader canvas
      // NOTE: Rectangle uses font white character texture coordinates,
      // so shader can not be applied here directly because input vertexTexCoord
      // do not represent full screen coordinates (space where want to apply shader)
      DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), BLACK);
    EndTextureMode();               // End drawing to texture (now we have a blank texture available for the shader)

    BeginDrawing();
      ClearBackground(RAYWHITE);  // Clear screen background

      BeginShaderMode(Shader);
        // NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
        DrawTextureRec(Target.Texture, TRectangle.Create(0, 0, Target.Texture.Width, -Target.Texture.Height), TVector2.Create(0.0, 0.0), WHITE);
      EndShaderMode();
    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadShader(Shader);               // Unload shader
  UnloadRenderTexture(Target);        // Unload render texture

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

