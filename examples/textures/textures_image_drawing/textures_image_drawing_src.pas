(*******************************************************************************************
*
*   raylib [textures] example - Image loading and drawing on it
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   Example originally created with raylib 1.4, last time updated with raylib 1.4
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2016-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit textures_image_drawing_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Cat, Parrots: TImage;
  Font: TFont;
  Texture: TTexture2D;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] examples - texture source and destination rectangles'));

  // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

  Cat := LoadImage(UTF8String('resources/textures/cat.png')); // Load image in CPU memory (RAM)
  ImageCrop(@Cat, TRectangle.Create(100, 10, 280, 380));      // Crop an image piece
  ImageFlipHorizontal(@Cat);                                  // Flip cropped image horizontally
  ImageResize(@Cat, 150, 200);                                // Resize flipped-cropped image

  Parrots := LoadImage(UTF8String('resources/textures/parrots.png')); // Load image in CPU memory (RAM)

  // Draw one image over the other with a scaling of 1.5f
  ImageDraw(@Parrots, Cat, TRectangle.Create(0, 0, Cat.Width, Cat.Height), TRectangle.Create(30, 40, Cat.Width * 1.5, Cat.Height * 1.5), WHITE);
  ImageCrop(@Parrots, TRectangle.Create(0, 50, Parrots.Width, Parrots.Height - 100)); // Crop resulting image

  // Draw on the image with a few image draw methods
  ImageDrawPixel(@Parrots, 10, 10, RAYWHITE);
  ImageDrawCircle(@Parrots, 10, 10, 5, RAYWHITE);
  ImageDrawRectangle(@Parrots, 5, 20, 10, 10, RAYWHITE);

  UnloadImage(cat); // Unload image from RAM

  // Load custom font for frawing on image
  Font := LoadFont(UTF8String('resources/textures/custom_jupiter_crash.png'));

  // Draw over image using custom font
  ImageDrawTextEx(@Parrots, Font, UTF8String('PARROTS & CAT'), TVector2.Create(300, 230), Font.BaseSize, -2, WHITE);

  UnloadFont(Font); // Unload custom font (already drawn used on image)

  Texture := LoadTextureFromImage(Parrots); // Image converted to texture, uploaded to GPU memory (VRAM)
  UnloadImage(Parrots); // Once image has been converted to texture and uploaded to VRAM, it can be unloaded from RAM

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

      DrawTexture(Texture, ScreenWidth div 2 - Texture.Width div 2, ScreenHeight div 2 - Texture.Height div 2 - 40, WHITE);
      DrawRectangleLines(ScreenWidth div 2 - Texture.Width div 2, ScreenHeight div 2 - Texture.Height div 2 - 40, Texture.Width, Texture.Height, DARKGRAY);

      DrawText(UTF8String('We are drawing only one texture from various images composed!'), 240, 350, 10, DARKGRAY);
      DrawText(UTF8String('Source images have been cropped, scaled, flipped and copied one over the other.'), 190, 370, 10, DARKGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Texture); // Texture unloading

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

