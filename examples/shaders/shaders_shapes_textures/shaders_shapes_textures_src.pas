(*******************************************************************************************
*
*   raylib [shaders] example - Apply a shader to some shape or texture
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit shaders_shapes_textures_src;

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
  Fudesumi: TTexture2D;
  Shader: TShader;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - shapes and texture shaders'));

  Fudesumi := LoadTexture(UTF8String('resources/shaders/fudesumi.png'));

  // Load shader to be used on some parts drawing
  // NOTE 1: Using GLSL 330 shader version, on OpenGL ES 2.0 use GLSL 100 shader version
  // NOTE 2: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
  Shader := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/grayscale.fs'), Integer(GLSL_VERSION)));

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
    BeginDrawing();

      ClearBackground(RAYWHITE);

      // Start drawing with default shader

      DrawText(UTF8String('USING DEFAULT SHADER'), 20, 40, 10, RED);

      DrawCircle(80, 120, 35, DARKBLUE);
      DrawCircleGradient(80, 220, 60, GREEN, SKYBLUE);
      DrawCircleLines(80, 340, 80, DARKBLUE);


      // Activate our custom shader to be applied on next shapes/textures drawings
      BeginShaderMode(Shader);

        DrawText(UTF8String('USING CUSTOM SHADER'), 190, 40, 10, RED);

        DrawRectangle(250 - 60, 90, 120, 60, RED);
        DrawRectangleGradientH(250 - 90, 170, 180, 130, MAROON, GOLD);
        DrawRectangleLines(250 - 40, 320, 80, 60, ORANGE);

      // Activate our default shader for next drawings
      EndShaderMode();

      DrawText(UTF8String('USING DEFAULT SHADER'), 370, 40, 10, RED);

      DrawTriangle(TVector2.Create(430, 80),
                   TVector2.Create(430 - 60, 150),
                   TVector2.Create(430 + 60, 150), VIOLET);

      DrawTriangleLines(TVector2.Create(430, 160),
                        TVector2.Create(430 - 20, 230),
                        TVector2.Create(430 + 20, 230), DARKBLUE);

      DrawPoly(TVector2.Create(430, 320), 6, 80, 0, BROWN);

      // Activate our custom shader to be applied on next shapes/textures drawings
      BeginShaderMode(Shader);

        DrawTexture(Fudesumi, 500, -30, WHITE);    // Using custom shader

      // Activate our default shader for next drawings
      EndShaderMode();

      DrawText(UTF8String('(c) Fudesumi sprite by Eiden Marsal'), 380, ScreenHeight - 20, 10, GRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadShader(Shader);       // Unload shader
  UnloadTexture(Fudesumi);    // Unload texture

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

