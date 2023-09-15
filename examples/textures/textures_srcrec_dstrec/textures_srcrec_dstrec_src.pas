(*******************************************************************************************
*
*   raylib [textures] example - Texture source and destination rectangles
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit textures_srcrec_dstrec_src;

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
  Scarfy: TTexture2D;
  FrameWidth, FrameHeight: Integer;
  SourceRec, DestRec: TRectangle;
  Origin: TVector2;
  Rotation: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] examples - texture source and destination rectangles'));

  Scarfy := LoadTexture(UTF8String('resources/textures/scarfy.png')); // Texture loading

  FrameWidth := Scarfy.Width div 6;
  FrameHeight := Scarfy.Height;

  // Source rectangle (part of the texture to use for drawing)
  SourceRec := TRectangle.Create(0.0, 0.0, FrameWidth, FrameHeight);

  // Destination rectangle (screen rectangle where drawing part of texture)
  DestRec := TRectangle.Create(ScreenWidth / 2.0, ScreenHeight / 2.0, FrameWidth * 2.0, FrameHeight * 2.0);

  // Origin of the texture (rotation/scale point), it's relative to destination rectangle size
  Origin := TVector2.Create(FrameWidth, FrameHeight);

  Rotation := 0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    Inc(Rotation);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      // NOTE: Using DrawTexturePro() we can easily rotate and scale the part of the texture we draw
      // sourceRec defines the part of the texture we use for drawing
      // destRec defines the rectangle where our texture part will fit (scaling it to fit)
      // origin defines the point of the texture used as reference for rotation and scaling
      // rotation defines the texture rotation (using origin as rotation point)
      DrawTexturePro(Scarfy, SourceRec, DestRec, Origin, Rotation, WHITE);

      DrawLine(Trunc(DestRec.X), 0, Trunc(DestRec.X), ScreenHeight, GRAY);
      DrawLine(0, Trunc(DestRec.Y), ScreenWidth, Trunc(DestRec.Y), GRAY);

      DrawText(UTF8String('(c) Scarfy sprite by Eiden Marsal'), ScreenWidth - 200, ScreenHeight - 20, 10, GRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Scarfy); // Texture unloading

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

