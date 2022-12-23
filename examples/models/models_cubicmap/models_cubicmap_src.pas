(*******************************************************************************************
*
*   raylib [models] example - Cubicmap loading and drawing
*
*   Example originally created with raylib 1.8, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit models_cubicmap_src;

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
  Image: TImage;
  Cubicmap: TTexture2D;
  Mesh: TMesh;
  Model: TModel;
  Texture: TTexture2D;
  MapPosition: TVector3;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - cubesmap loading and drawing'));

  // Define the camera to look into our 3d world
  Camera := TCamera.Create(
    TVector3.Create(16.0, 14.0, 16.0),
    TVector3.Create(0.0, 0.0, 0.0),
    TVector3.Create(0.0, 1.0, 0.0),
    45.0, 0);

  Image := LoadImage(UTF8String('resources/models/cubicmap.png'));      // Load cubicmap image (RAM)
  Cubicmap := LoadTextureFromImage(Image);                               // Convert image to texture to display (VRAM)

  Mesh := GenMeshCubicmap(Image, TVector3.Create(1.0, 1.0, 1.0));
  Model := LoadModelFromMesh(Mesh);

  // NOTE: By default each cube is mapped to one part of texture atlas
  Texture := LoadTexture(UTF8String('resources/models/cubicmap_atlas.png'));    // Load map texture
  Model.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture;             // Set map diffuse texture

  MapPosition := TVector3.Create(-16.0, 0.0, -8.0); // Set model position

  UnloadImage(Image); // Unload cubesmap image from RAM, already uploaded to VRAM

  SetCameraMode(Camera, CAMERA_ORBITAL);  // Set an orbital camera mode

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

          DrawModel(Model, MapPosition, 1.0, WHITE);

      EndMode3D();

      DrawTextureEx(Cubicmap, TVector2.Create(ScreenWidth - Cubicmap.Width * 4.0 - 20, 20.0), 0.0, 4.0, WHITE);
      DrawRectangleLines(ScreenWidth - Cubicmap.Width * 4 - 20, 20, Cubicmap.Width * 4, Cubicmap.Height * 4, GREEN);

      DrawText(UTF8String('cubicmap image used to'), 658, 90, 10, GRAY);
      DrawText(UTF8String('generate map 3d model'), 658, 104, 10, GRAY);

      DrawFPS(10, 10);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Cubicmap);    // Unload cubicmap texture
  UnloadTexture(Texture);     // Unload map texture
  UnloadModel(Model);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

