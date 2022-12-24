(*******************************************************************************************
*
*   raylib [shaders] example - Color palette switch
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
*   Example contributed by Marco Lizza (@MarcoLizza) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2022 Marco Lizza (@MarcoLizza) and Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit shaders_palette_switch_src;

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

  MAX_PALETTES = 3;
  COLORS_PER_PALETTE = 8;
  VALUES_PER_COLOR = 3;

const
  Palettes: array [0..MAX_PALETTES-1] of array [0..VALUES_PER_COLOR*COLORS_PER_PALETTE-1] of Integer = (
    ( // 3-BIT RGB
      0, 0, 0,
      255, 0, 0,
      0, 255, 0,
      0, 0, 255,
      0, 255, 255,
      255, 0, 255,
      255, 255, 0,
      255, 255, 255
    ),
    ( // AMMO-8 (GameBoy-like)
      4, 12, 6,
      17, 35, 24,
      30, 58, 41,
      48, 93, 66,
      77, 128, 97,
      137, 162, 87,
      190, 220, 127,
      238, 255, 204
    ),
    (  // RKBV (2-strip film)
      21, 25, 26,
      138, 76, 88,
      217, 98, 117,
      230, 184, 193,
      69, 107, 115,
      75, 151, 166,
      165, 189, 194,
      255, 245, 247
    )
  );

  PaletteText: array [0..MAX_PALETTES-1] of string = (
    '3-BIT RGB',
    'AMMO-8 (GameBoy-like)',
    'RKBV (2-strip film)'
  );

type PostproShader = (
    FX_GRAYSCALE,
    FX_POSTERIZATION,
    FX_DREAM_VISION,
    FX_PIXELIZER,
    FX_CROSS_HATCHING,
    FX_CROSS_STITCHING,
    FX_PREDATOR_VIEW,
    FX_SCANLINES,
    FX_FISHEYE,
    FX_SOBEL,
    FX_BLOOM,
    FX_BLUR
);

const
  PostproShaderText: array [PostproShader] of string = (
    'GRAYSCALE',
    'POSTERIZATION',
    'DREAM_VISION',
    'PIXELIZER',
    'CROSS_HATCHING',
    'CROSS_STITCHING',
    'PREDATOR_VIEW',
    'SCANLINES',
    'FISHEYE',
    'SOBEL',
    'BLOOM',
    'BLUR'
);

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Shader: TShader;
  I: Integer;
  PaletteLoc, CurrentPalette, LineHeight: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - color palette switch'));

  // Load shader to be used on some parts drawing
  // NOTE 1: Using GLSL 330 shader version, on OpenGL ES 2.0 use GLSL 100 shader version
  // NOTE 2: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
  Shader := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/palette_switch.fs'), Integer(GLSL_VERSION)));

  // Get variable (uniform) location on the shader to connect with the program
  // NOTE: If uniform variable could not be found in the shader, function returns -1
  PaletteLoc := GetShaderLocation(Shader, UTF8String('palette'));

  CurrentPalette := 0;
  LineHeight := ScreenHeight div COLORS_PER_PALETTE;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyPressed(KEY_RIGHT) then
      Inc(CurrentPalette)
    else if IsKeyPressed(KEY_LEFT) then
      Dec(CurrentPalette);

    if CurrentPalette >= MAX_PALETTES then
      CurrentPalette := 0
    else if CurrentPalette < 0 then
      CurrentPalette := MAX_PALETTES - 1;

    // Send new value to the shader to be used on drawing.
    // NOTE: We are sending RGB triplets w/o the alpha channel
    SetShaderValueV(Shader, PaletteLoc, @Palettes[CurrentPalette], SHADER_UNIFORM_IVEC3, COLORS_PER_PALETTE);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();
      ClearBackground(RAYWHITE);

      BeginShaderMode(Shader);

        for I := 0 to COLORS_PER_PALETTE - 1 do
        begin
          // Draw horizontal screen-wide rectangles with increasing "palette index"
          // The used palette index is encoded in the RGB components of the pixel
          DrawRectangle(0, LineHeight * I, GetScreenWidth(), LineHeight, TColor.Create(I, I, I, 255));
        end;

      EndShaderMode();

      DrawText(UTF8String('< >'), 10, 10, 30, DARKBLUE);
      DrawText(UTF8String('CURRENT PALETTE:'), 60, 15, 20, RAYWHITE);
      DrawText(PAnsiChar(UTF8String(PaletteText[CurrentPalette])), 300, 15, 20, RED);

      DrawFPS(700, 15);
    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadShader(Shader);       // Unload shader

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

