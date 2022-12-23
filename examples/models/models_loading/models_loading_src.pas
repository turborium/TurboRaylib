(*******************************************************************************************
*
*   raylib [models] example - Models loading
*
*   NOTE: raylib supports multiple models file formats:
*
*     - OBJ  > Text file format. Must include vertex position-texcoords-normals information,
*              if files references some .mtl materials file, it will be loaded (or try to).
*     - GLTF > Text/binary file format. Includes lot of information and it could
*              also reference external files, raylib will try loading mesh and materials data.
*     - IQM  > Binary file format. Includes mesh vertex data but also animation data,
*              raylib can load .iqm animations.
*     - VOX  > Binary file format. MagikaVoxel mesh format:
*              https://github.com/ephtracy/voxel-model/blob/master/MagicaVoxel-file-format-vox.txt
*     - M3D  > Binary file format. Model 3D format:
*              https://bztsrc.gitlab.io/model3d
*
*   Example originally created with raylib 2.0, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit models_loading_src;

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
  Model: TModel;
  Texture: TTexture;
  Position: TVector3;
  Bounds: TBoundingBox;
  Selected: Boolean;
  DroppedFiles: TFilePathList;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - models loading'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(50.0, 50.0, 50.0); // Camera position
  Camera.Target := TVector3.Create(0.0, 10.0, 0.0);     // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  Model := LoadModel(UTF8String('resources/models/models/obj/castle.obj'));   // Load model
  Texture := LoadTexture(UTF8String('resources/models/models/obj/castle_diffuse.png')); // Load model texture
  Model.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture;            // Set map diffuse texture

  Position := TVector3.Create(0.0, 0.0, 0.0);                    // Set model position

  Bounds := GetMeshBoundingBox(Model.Meshes[0]);   // Set model bounds

  // NOTE: bounds are calculated from the original size of the model,
  // if model is scaled on drawing, bounds must be also scaled

  SetCameraMode(Camera, CAMERA_FREE);     // Set a free camera mode

  Selected := False;          // Selected object flag

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera);

    // Load new models/textures on drag&drop
    if IsFileDropped() then
    begin
      DroppedFiles := LoadDroppedFiles();

      if DroppedFiles.Count = 1 then // Only support one file dropped
      begin
        if IsFileExtension(DroppedFiles.Paths[0], '.obj') or
           IsFileExtension(DroppedFiles.Paths[0], '.gltf') or
           IsFileExtension(DroppedFiles.Paths[0], '.glb') or
           IsFileExtension(DroppedFiles.Paths[0], '.vox') or
           IsFileExtension(DroppedFiles.Paths[0], '.iqm') or
           IsFileExtension(DroppedFiles.Paths[0], '.m3d') then       // Model file formats supported
        begin
          UnloadModel(Model);                          // Unload previous model
          Model := LoadModel(DroppedFiles.Paths[0]);   // Load new model
          Model.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture; // Set current map diffuse texture

          Bounds := GetMeshBoundingBox(Model.Meshes[0]);

          // TODO: Move camera position from target enough distance to visualize model properly
        end
        else if IsFileExtension(DroppedFiles.Paths[0], '.png') then  // Texture file formats supported
        begin
          // Unload current model texture and load new one
          UnloadTexture(Texture);
          Texture := LoadTexture(DroppedFiles.Paths[0]);
          Model.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture;
        end;
      end;

      UnloadDroppedFiles(droppedFiles);    // Unload filepaths from memory
    end;

    // Select model on mouse click
    if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) then
    begin
      // Check collision between ray and box
      if GetRayCollisionBox(GetMouseRay(GetMousePosition(), Camera), Bounds).Hit then
        Selected := not Selected
      else
        Selected := False;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        DrawModel(Model, Position, 1.0, WHITE);        // Draw 3d model with texture

        DrawGrid(20, 10.0);         // Draw a grid

        if Selected then
          DrawBoundingBox(Bounds, GREEN);   // Draw selection box

      EndMode3D();

      DrawText(UTF8String('Drag & drop model to load mesh/texture.'), 10, GetScreenHeight() - 20, 10, DARKGRAY);
      if Selected then
        DrawText(UTF8String('MODEL SELECTED'), GetScreenWidth() - 110, 10, 10, GREEN);

      DrawText(UTF8String('(c) Castle 3D model by Alberto Cano'), ScreenWidth - 200, ScreenHeight - 20, 10, GRAY);

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

