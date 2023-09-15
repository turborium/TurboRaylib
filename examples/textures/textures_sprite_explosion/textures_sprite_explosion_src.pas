(*******************************************************************************************
*
*   raylib [textures] example - sprite explosion
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2023 Anata and Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit textures_sprite_explosion_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  NUM_FRAMES_PER_LINE = 5;
  NUM_LINES           = 5;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  FxBoom: TSound;
  Explosion: TTexture2D;
  FrameWidth, FrameHeight: Single;
  CurrentFrame, CurrentLine: Integer;
  FrameRec: TRectangle;
  Position: TVector2;
  Active: Boolean;
  FramesCounter: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] example - sprite explosion'));

  InitAudioDevice(); // Initialize audio device

  // Load explosion sound
  FxBoom := LoadSound(UTF8String('resources/textures/boom.wav'));

  // Load explosion texture
  Explosion := LoadTexture(UTF8String('resources/textures/explosion.png')); // *** MEGUMIN HERE ***

  // Init variables for animation
  FrameWidth := Explosion.Width div NUM_FRAMES_PER_LINE; // Sprite one frame rectangle width
  FrameHeight := Explosion.Height div NUM_LINES; // Sprite one frame rectangle height
  CurrentFrame := 0;
  CurrentLine := 0;

  FrameRec := TRectangle.Create(0, 0, FrameWidth, FrameHeight);
  Position := TVector2.Create(0.0, 0.0);

  Active := False;
  FramesCounter := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    // Check for mouse button pressed and activate explosion (if not active)
    if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) and not Active then
    begin
      Position := GetMousePosition();
      Active := True;

      Position.X := Position.X - FrameWidth / 2.0;
      Position.Y := Position.Y - FrameHeight / 2.0;

      PlaySound(fxBoom);
    end;

    // Compute explosion animation frames
    if Active then
    begin
      Inc(FramesCounter);

      if FramesCounter > 2 then
      begin
        Inc(CurrentFrame);

        if CurrentFrame >= NUM_FRAMES_PER_LINE then
        begin
          CurrentFrame := 0;
          Inc(CurrentLine);

          if CurrentLine >= NUM_LINES then
          begin
            CurrentLine := 0;
            Active := False;
          end;
        end;
        FramesCounter := 0;
      end;
    end;

    FrameRec.X := FrameWidth * CurrentFrame;
    FrameRec.Y := FrameHeight * CurrentLine;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      // Draw explosion required frame rectangle
      if Active then
        DrawTextureRec(Explosion, FrameRec, Position, WHITE);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Explosion);   // Unload texture
  UnloadSound(FxBoom);        // Unload sound

  CloseAudioDevice();

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

