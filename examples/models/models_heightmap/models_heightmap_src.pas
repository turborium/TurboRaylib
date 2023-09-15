(*******************************************************************************************
*
*   raylib [models] example - Heightmap loading and drawing
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit models_heightmap_src;

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

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Camera: TCamera;
  Texture: TTexture2D;
  Image: TImage;
  Mesh: TMesh;
  Model: TModel;
  MapPosition: TVector3;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - heightmap loading and drawing'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(18.0, 21.0, 18.0); // Camera position
  Camera.Target := TVector3.Create(0.0, 0.0, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type


  Image := LoadImage('resources/models/heightmap.png');     // Load heightmap image (RAM)
  Texture := LoadTextureFromImage(Image);        // Convert image to texture (VRAM)
  Mesh := GenMeshHeightmap(Image, TVector3.Create(16, 8, 16)); // Generate heightmap mesh (RAM and VRAM)
  Model := LoadModelFromMesh(Mesh);                  // Load model from generated mesh
  Model.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture; // Set map diffuse texture
  MapPosition := TVector3.Create(-8.0, 0.0, -8.0);           // Define model position
  UnloadImage(Image);             // Unload heightmap image from RAM, already uploaded to VRAM

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera, CAMERA_ORBITAL);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);
      BeginMode3D(Camera);
        DrawModel(Model, MapPosition, 1.0, RED);
        DrawGrid(20, 1.0);
      EndMode3D();
      DrawTexture(Texture, ScreenWidth - Texture.Width - 20, 20, WHITE);
      DrawRectangleLines(ScreenWidth - Texture.Width - 20, 20, Texture.Width, Texture.Height, GREEN);
      DrawFPS(10, 10);
    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Texture);     // Unload texture
  UnloadModel(Model);         // Unload model

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

