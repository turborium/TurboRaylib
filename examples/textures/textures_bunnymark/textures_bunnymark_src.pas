(*******************************************************************************************
*
*   raylib [textures] example - Bunnymark
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit textures_bunnymark_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib,
  raymath,
  rlgl;

const
  MAX_BUNNIES = 100000; // 100K bunnies limit

  // This is the maximum amount of elements (quads) per batch
  // NOTE: This value is defined in [rlgl] module and can be changed there
  MAX_BATCH_ELEMENTS = 8192;

type
  TBunny = record
    Position: TVector2;
    Speed: TVector2;
    Color: TColor;
  end;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  TexBunny: TTexture2D;
  Bunnies: array of TBunny;
  BunniesCount: Integer;
  I: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] example - bunnymark'));

  // Load bunny texture
  TexBunny := LoadTexture(UTF8String('resources/textures/wabbit_alpha.png'));

  SetLength(Bunnies, MAX_BUNNIES); // Bunnies array

  BunniesCount := 0; // Bunnies counter

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsMouseButtonDown(MOUSE_BUTTON_LEFT) then
    begin
      // Create more bunnies
      for I := 0 to 100 - 1 do
      begin
        if BunniesCount < MAX_BUNNIES then
        begin
          Bunnies[BunniesCount].Position := GetMousePosition();
          Bunnies[BunniesCount].Speed.X := GetRandomValue(-250, 250) / 60.0;
          Bunnies[BunniesCount].Speed.Y := GetRandomValue(-250, 250) / 60.0;
          Bunnies[BunniesCount].Color := TColor.Create(GetRandomValue(50, 240), GetRandomValue(80, 240), GetRandomValue(100, 240), 255);
          Inc(BunniesCount);
        end;
      end;
    end;

    // Update bunnies
    for I := 0 to BunniesCount - 1 do
    begin
      Bunnies[I].Position.X := Bunnies[I].Position.X + Bunnies[I].Speed.X;
      bunnies[I].Position.Y := Bunnies[I].Position.Y + Bunnies[I].Speed.Y;

      if ((Bunnies[I].Position.X + TexBunny.Width div 2) > GetScreenWidth()) or
         ((Bunnies[I].Position.X + TexBunny.Width div 2) < 0) then
        Bunnies[I].Speed.X := -Bunnies[I].Speed.X;
      if ((Bunnies[I].Position.Y + TexBunny.Height div 2) > GetScreenHeight()) or
         ((Bunnies[I].Position.Y + TexBunny.Height div 2) < 0) then
        Bunnies[I].Speed.Y := -Bunnies[I].Speed.Y;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      for I := 0 to BunniesCount - 1 do
      begin
        // NOTE: When internal batch buffer limit is reached (MAX_BATCH_ELEMENTS),
        // a draw call is launched and buffer starts being filled again;
        // before issuing a draw call, updated vertex data from internal CPU buffer is send to GPU...
        // Process of sending data is costly and it could happen that GPU data has not been completely
        // processed for drawing while new data is tried to be sent (updating current in-use buffers)
        // it could generates a stall and consequently a frame drop, limiting the number of drawn bunnies
        DrawTexture(TexBunny, Trunc(Bunnies[I].Position.X), Trunc(Bunnies[I].Position.Y), Bunnies[I].Color);
      end;

      DrawRectangle(0, 0, ScreenWidth, 40, BLACK);
      DrawText(TextFormat(UTF8String('bunnies: %i'), BunniesCount), 120, 10, 20, GREEN);
      DrawText(TextFormat(UTF8String('batched draw calls: %i'), Integer(1 + BunniesCount div MAX_BATCH_ELEMENTS)), 320, 10, 20, MAROON);

      DrawFPS(10, 10);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  Bunnies := nil; // Unload bunnies data array

  UnloadTexture(TexBunny); // Unload bunny texture

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

