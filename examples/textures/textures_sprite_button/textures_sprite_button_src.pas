(*******************************************************************************************
*
*   raylib [textures] example - sprite button
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit textures_sprite_button_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  NUM_FRAMES = 3; // Number of frames (rectangles) for the button sprite texture

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  FxButton: TSound;
  Button: TTexture2D;
  FrameHeight: Single;
  SourceRec, BtnBounds: TRectangle;
  BtnState: Integer;
  BtnAction: Boolean;
  MousePoint: TVector2;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] example - sprite button'));

  InitAudioDevice(); // Initialize audio device

  FxButton := LoadSound(UTF8String('resources/textures/buttonfx.wav')); // Load button sound
  Button := LoadTexture(UTF8String('resources/textures/button.png')); // Load button texture

  // Define frame rectangle for drawing
  FrameHeight := Button.Height / NUM_FRAMES;
  SourceRec := TRectangle.Create(0, 0, Button.Width, FrameHeight);

  // Define button bounds on screen
  BtnBounds := TRectangle.Create(ScreenWidth / 2.0 - Button.Width / 2.0, ScreenHeight / 2.0 - Button.Height div NUM_FRAMES / 2.0, Button.Width, FrameHeight);

  //BtnState := 0; // Button state: 0-NORMAL, 1-MOUSE_HOVER, 2-PRESSED
  //BtnAction := False; // Button action should be activated

  MousePoint := TVector2.Create(0.0, 0.0);

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    MousePoint := GetMousePosition();
    BtnAction := False;

    // Check button state
    if CheckCollisionPointRec(MousePoint, BtnBounds) then
    begin
      if IsMouseButtonDown(MOUSE_BUTTON_LEFT) then
        BtnState := 2
      else
        BtnState := 1;

      if IsMouseButtonReleased(MOUSE_BUTTON_LEFT) then
        BtnAction := True;
    end else
      BtnState := 0;

    if BtnAction then
    begin
        PlaySound(FxButton);

        // TODO: Any desired action
    end;

    // Calculate button frame rectangle to draw depending on button state
    SourceRec.Y := BtnState * FrameHeight;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawTextureRec(Button, SourceRec, TVector2.Create(BtnBounds.X, BtnBounds.Y), WHITE); // Draw button frame

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Button);  // Unload button texture
  UnloadSound(FxButton);  // Unload sound

  CloseAudioDevice();     // Close audio device

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

