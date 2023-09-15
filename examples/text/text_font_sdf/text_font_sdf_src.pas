(*******************************************************************************************
*
*   raylib [text] example - Font SDF loading
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit text_font_sdf_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  GLSL_VERSION  = 330;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Msg: string;
  FileSize: Cardinal;
  FileData: PByte;
  FontDefault: TFont;
  Atlas: TImage;
  FontSDF: TFont;
  Shader: TShader;
  FontPosition, TextSize: TVector2;
  FontSize: Single;
  CurrentFont: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [text] example - SDF fonts'));

  // NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)
  Msg := 'Signed Distance Fields';

  // Loading file to memory
  FileSize := 0;
  FileData := LoadFileData(UTF8String('resources/text/anonymous_pro_bold.ttf'), @FileSize);

  // Default font generation from TTF font
  FontDefault := Default(TFont);
  FontDefault.BaseSize := 30;
  FontDefault.GlyphCount := 95;

  // Loading font data from memory data
  // Parameters > font size: 16, no glyphs array provided (0), glyphs count: 95 (autogenerate chars array)
  FontDefault.Glyphs := LoadFontData(FileData, FileSize, 16, nil, 95, FONT_DEFAULT);
  // Parameters > glyphs count: 95, font size: 16, glyphs padding in image: 4 px, pack method: 0 (default)
  Atlas := GenImageFontAtlas(FontDefault.Glyphs, @FontDefault.Recs, 95, 16, 4, 0);
  FontDefault.Texture := LoadTextureFromImage(Atlas);
  UnloadImage(Atlas);

  // SDF font generation from TTF font
  FontSDF := Default(TFont);
  FontSDF.BaseSize := 30;
  FontSDF.GlyphCount := 95;
  // Parameters > font size: 16, no glyphs array provided (0), glyphs count: 0 (defaults to 95)
  FontSDF.Glyphs := LoadFontData(FileData, FileSize, 16, nil, 0, FONT_SDF);
  // Parameters > glyphs count: 95, font size: 16, glyphs padding in image: 0 px, pack method: 1 (Skyline algorythm)
  Atlas := GenImageFontAtlas(FontSDF.Glyphs, @FontSDF.Recs, 95, 16, 0, 1);
  FontSDF.Texture := LoadTextureFromImage(Atlas);
  UnloadImage(Atlas);

  UnloadFileData(FileData);      // Free memory from loaded file

  // Load SDF required shader (we use default vertex shader)
  Shader := LoadShader(nil, TextFormat(UTF8String('resources/text/shaders/glsl%i/sdf.fs'), GLSL_VERSION));
  SetTextureFilter(FontSDF.Texture, TEXTURE_FILTER_BILINEAR);    // Required for SDF font

  FontPosition := TVector2.Create(40, ScreenHeight / 2.0 - 50);
  TextSize := TVector2.Create(0, 0);
  FontSize := 100.0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    FontSize := FontSize + GetMouseWheelMove() * 8.0;

    if FontSize < 6 then
      FontSize := 6;

    if IsKeyDown(KEY_SPACE) then
      CurrentFont := 1
    else
      CurrentFont := 0;

    if CurrentFont = 0 then
      TextSize := MeasureTextEx(FontDefault, PAnsiChar(UTF8String(Msg)), FontSize, 0)
    else
      TextSize := MeasureTextEx(FontSDF, PAnsiChar(UTF8String(Msg)), FontSize, 0);

    FontPosition.X := GetScreenWidth() / 2 - TextSize.X / 2;
    FontPosition.Y := GetScreenHeight() / 2 - TextSize.Y / 2 + 80;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      if CurrentFont = 1 then
      begin
        // NOTE: SDF fonts require a custom SDf shader to compute fragment color
        BeginShaderMode(Shader);    // Activate SDF font shader
            DrawTextEx(FontSDF, PAnsiChar(UTF8String(Msg)), FontPosition, FontSize, 0, BLACK);
        EndShaderMode();            // Activate our default shader for next drawings

        DrawTexture(FontSDF.Texture, 10, 10, BLACK);
      end else
      begin
        DrawTextEx(FontDefault, PAnsiChar(UTF8String(Msg)), FontPosition, FontSize, 0, BLACK);
        DrawTextureEx(FontDefault.Texture, TVector2.Create(10, 10), 0, 0.6, BLACK);
      end;

      if CurrentFont = 1 then
        DrawText(UTF8String('SDF!'), 320, 20, 80, RED)
      else
        DrawText(UTF8String('default font'), 315, 40, 30, GRAY);

      DrawText(UTF8String('FONT SIZE: 30.0'), GetScreenWidth() - 240, 20, 20, DARKGRAY);
      DrawText(TextFormat(UTF8String('RENDER SIZE: %02.02f'), FontSize), GetScreenWidth() - 240, 50, 20, DARKGRAY);
      DrawText(UTF8String('Use MOUSE WHEEL to SCALE TEXT!'), GetScreenWidth() - 240, 90, 10, DARKGRAY);

      DrawText(UTF8String('HOLD SPACE to USE SDF FONT VERSION!'), 340, GetScreenHeight() - 30, 20, MAROON);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadFont(FontDefault);    // Default font unloading
  UnloadFont(FontSDF);        // SDF font unloading

  UnloadShader(Shader);       // Unload SDF shader

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

