(*******************************************************************************************
*
*   raylib [models] example - first person maze
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit models_first_person_maze_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib,
  raymath;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Camera: TCamera;
  ImMap: TImage;
  Cubicmap: TTexture2D;
  Mesh: TMesh;
  Model: TModel;
  Texture: TTexture2D;
  MapPosition, OldCamPos, Position: TVector3;
  PlayerPos: TVector2;
  MapPixels: PColor;
  PlayerRadius: Single;
  PlayerCellX, PlayerCellY: Integer;
  X, Y: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - first person maze'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(0.2, 0.4, 0.2);
  Camera.Target := TVector3.Create(0.185, 0.4, 0.0);
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);
  Camera.Fovy := 45.0;
  Camera.Projection := CAMERA_PERSPECTIVE;

  Position := TVector3.Create(0, 0, 0);

  ImMap := LoadImage(UTF8String('resources/models/cubicmap.png')); // Load cubicmap image (RAM)
  Cubicmap := LoadTextureFromImage(ImMap); // Convert image to texture to display (VRAM)
  Mesh := GenMeshCubicmap(ImMap, TVector3.Create(1.0, 1.0, 1.0));
  Model := LoadModelFromMesh(Mesh);

  // NOTE: By default each cube is mapped to one part of texture atlas
  Texture := LoadTexture(UTF8String('resources/models/cubicmap_atlas.png')); // Load map texture
  Model.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture; // Set map diffuse texture

  // Get map image data to be used for collision detection
  MapPixels := LoadImageColors(ImMap);
  UnloadImage(ImMap); // Unload image from RAM

  MapPosition := TVector3.Create(-16.0, 0.0, -8.0); // Set model position

  DisableCursor(); // Limit cursor to relative movement inside the window

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    OldCamPos := Camera.Position;    // Store old camera position

    UpdateCamera(@Camera, CAMERA_FIRST_PERSON);

    // Check player collision (we simplify to 2D collision detection)
    PlayerPos := TVector2.Create(Camera.Position.X, Camera.Position.Z);
    PlayerRadius := 0.1;  // Collision radius (player is modelled as a cilinder for collision)

    PlayerCellX := Trunc(PlayerPos.X - MapPosition.X + 0.5);
    PlayerCellY := Trunc(PlayerPos.Y - MapPosition.Z + 0.5);

    // Out-of-limits security check
    if PlayerCellX < 0 then
      PlayerCellX := 0
    else if PlayerCellX >= Cubicmap.Width then
      PlayerCellX := Cubicmap.Width - 1;

    if PlayerCellY < 0 then
      PlayerCellY := 0
    else if PlayerCellY >= Cubicmap.Height then
      PlayerCellY := Cubicmap.Height - 1;

    // Check map collisions using image data and player position
    // TODO: Improvement: Just check player surrounding cells for collision
    for Y := 0 to Cubicmap.Height - 1 do
    begin
      for X := 0 to Cubicmap.Width - 1 do
      begin
        if (MapPixels[Y * Cubicmap.Width + X].R = 255) and // Collision: white pixel, only check R channel
            (CheckCollisionCircleRec(PlayerPos, PlayerRadius,
            TRectangle.Create(MapPosition.X - 0.5 + X * 1.0, MapPosition.Z - 0.5 + Y * 1.0, 1.0, 1.0))) then
        begin
          // Collision detected, reset camera position
          Camera.Position := OldCamPos;
        end;
      end;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);
        DrawModel(Model, MapPosition, 1.0, WHITE);                     // Draw maze map
      EndMode3D();

      DrawTextureEx(Cubicmap, TVector2.Create(GetScreenWidth() - Cubicmap.Width * 4.0 - 20, 20.0), 0.0, 4.0, WHITE);
      DrawRectangleLines(GetScreenWidth() - Cubicmap.Width * 4 - 20, 20, Cubicmap.Width * 4, Cubicmap.Height * 4, GREEN);

      // Draw player position radar
      DrawRectangle(GetScreenWidth() - Cubicmap.Width * 4 - 20 + PlayerCellX * 4, 20 + PlayerCellY * 4, 4, 4, RED);

      DrawFPS(10, 10);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadImageColors(MapPixels);   // Unload color array

  UnloadTexture(Cubicmap);    // Unload cubicmap texture
  UnloadTexture(Texture);     // Unload map texture
  UnloadModel(Model);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

