(*******************************************************************************************
*
*   raylib [textures] example - gif playing
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2021-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit textures_gif_player_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  MAX_FRAME_DELAY = 20;
  MIN_FRAME_DELAY = 1;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  AnimFrames: Integer;
  ImScarfyAnim: TImage;
  TexScarfyAnim: TTexture;
  NextFrameDataOffset: Cardinal;
  CurrentAnimFrame: Integer;
  FrameDelay: Integer;
  FrameCounter: Integer;
  I: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] example - gif playing'));

  AnimFrames := 0;

  // Load all GIF animation frames into a single Image
  // NOTE: GIF data is always loaded as RGBA (32bit) by default
  // NOTE: Frames are just appended one after another in image.data memory
  ImScarfyAnim := LoadImageAnim(UTF8String('resources/textures/scarfy_run.gif'), @AnimFrames);

  // Load texture from image
  // NOTE: We will update this texture when required with next frame data
  // WARNING: It's not recommended to use this technique for sprites animation,
  // use spritesheets instead, like illustrated in textures_sprite_anim example
  TexScarfyAnim := LoadTextureFromImage(ImScarfyAnim);

  NextFrameDataOffset := 0;    // Current byte offset to next frame in image.data

  CurrentAnimFrame := 0;       // Current animation frame to load and draw
  FrameDelay := 8;             // Frame delay to switch between animation frames
  FrameCounter := 0;           // General frames counter

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    Inc(FrameCounter);
    if FrameCounter >= FrameDelay then
    begin
      // Move to next frame
      // NOTE: If final frame is reached we return to first frame
      Inc(CurrentAnimFrame);
      if CurrentAnimFrame >= AnimFrames then
        CurrentAnimFrame := 0;

      // Get memory offset position for next frame data in image.data
      NextFrameDataOffset := ImScarfyAnim.Width * ImScarfyAnim.Height * 4 * CurrentAnimFrame;

      // Update GPU texture data with next frame image data
      // WARNING: Data size (frame size) and pixel format must match already created texture
      UpdateTexture(TexScarfyAnim, PByte(imScarfyAnim.data) + NextFrameDataOffset);

      FrameCounter := 0;
    end;

    // Control frames delay
    if IsKeyPressed(KEY_RIGHT) then Inc(FrameDelay)
    else if IsKeyPressed(KEY_LEFT) then Dec(FrameDelay);

    if FrameDelay > MAX_FRAME_DELAY then FrameDelay := MAX_FRAME_DELAY
    else if FrameDelay < MIN_FRAME_DELAY then FrameDelay := MIN_FRAME_DELAY;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(TextFormat(UTF8String('TOTAL GIF FRAMES:  %02i'), AnimFrames), 50, 30, 20, LIGHTGRAY);
      DrawText(TextFormat(UTF8String('CURRENT FRAME: %02i'), CurrentAnimFrame), 50, 60, 20, GRAY);
      DrawText(TextFormat(UTF8String('CURRENT FRAME IMAGE.DATA OFFSET: %02i'), NextFrameDataOffset), 50, 90, 20, GRAY);

      DrawText(UTF8String('FRAMES DELAY: '), 100, 305, 10, DARKGRAY);
      DrawText(TextFormat(UTF8String('%02i frames'), FrameDelay), 620, 305, 10, DARKGRAY);
      DrawText(UTF8String('PRESS RIGHT/LEFT KEYS to CHANGE SPEED!'), 290, 350, 10, DARKGRAY);

      for I := 0 to MAX_FRAME_DELAY - 1 do
      begin
        if I < FrameDelay then DrawRectangle(190 + 21 * I, 300, 20, 20, RED);
        DrawRectangleLines(190 + 21 * I, 300, 20, 20, MAROON);
      end;

      DrawTexture(TexScarfyAnim, GetScreenWidth() div 2 - TexScarfyAnim.Width div 2, 140, WHITE);

      DrawText(UTF8String('(c) Scarfy sprite by Eiden Marsal'), ScreenWidth - 200, ScreenHeight - 20, 10, GRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(TexScarfyAnim);   // Unload texture
  UnloadImage(ImScarfyAnim);      // Unload image (contains all frames)

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

