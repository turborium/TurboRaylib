(*******************************************************************************************
*
*   raylib [textures] example - Load textures from raw data
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   Example originally created with raylib 1.3, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
program textures_raw_data;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}
{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  raylib in '..\..\..\raylib\raylib.pas';

{$POINTERMATH ON}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  FudesumiRaw: TImage;
  Fudesumi: TTexture2D;
  Width, Height: Integer;
  Pixels: PColor;
  X, Y: Integer;
  CheckedIm: TImage;
  Checked: TTexture2D;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] example - texture from raw data'));

  // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

  // Load RAW image data (512x512, 32bit RGBA, no file header)
  FudesumiRaw := LoadImageRaw(UTF8String('resources/textures/fudesumi.raw'), 384, 512, PIXELFORMAT_UNCOMPRESSED_R8G8B8A8, 0);
  Fudesumi := LoadTextureFromImage(FudesumiRaw); // Upload CPU (RAM) image to GPU (VRAM)
  UnloadImage(FudesumiRaw); // Unload CPU (RAM) image data

  // Generate a checked texture by code
  Width := 960;
  Height := 480;

  // Dynamic memory allocation to store pixels data (Color type)
  Pixels := MemAlloc(Width * Height * SizeOf(TColor));

  for Y := 0 to Height - 1 do
    for X := 0 to Width - 1 do
      if ((X div 32 + Y div 32) div 1) mod 2 = 0 then
        Pixels[Y * Width + X] := ORANGE
      else
        Pixels[Y * Width + X] := GOLD;

  // Load pixels data into an image structure and create texture
  CheckedIm := TImage.Create(
    Pixels, // We can assign pixels directly to data
    Width,
    Height,
    1,
    PIXELFORMAT_UNCOMPRESSED_R8G8B8A8
  );

  Checked := LoadTextureFromImage(CheckedIm);
  UnloadImage(CheckedIm); // Unload CPU (RAM) image data (pixels)

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

      DrawTexture(Checked, ScreenWidth div 2 - Checked.Width div 2, ScreenHeight div 2 - Checked.Height div 2, Fade(WHITE, 0.5));
      DrawTexture(Fudesumi, 430, -30, WHITE);

      DrawText(UTF8String('CHECKED TEXTURE '), 84, 85, 30, BROWN);
      DrawText(UTF8String('GENERATED by CODE'), 72, 148, 30, BROWN);
      DrawText(UTF8String('and RAW IMAGE LOADING'), 46, 210, 30, BROWN);

      DrawText(UTF8String('(c) Fudesumi sprite by Eiden Marsal'), 310, ScreenHeight - 20, 10, BROWN);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Fudesumi); // Texture unloading
  UnloadTexture(Checked); // Texture unloading

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

