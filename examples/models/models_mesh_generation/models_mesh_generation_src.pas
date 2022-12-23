(*******************************************************************************************
*
*   raylib example - procedural mesh generation
*
*   Example originally created with raylib 1.8, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit models_mesh_generation_src;

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
  NUM_MODELS = 9; // Parametric 3d shapes to generate

function GenMeshCustom(): TMesh; forward; // Generate a simple triangle mesh from code

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Camera: TCamera;
  Checked: TImage;
  Texture: TTexture2D;
  Models: array [0..NUM_MODELS-1] of TModel;
  I: Integer;
  Position: TVector3;
  CurrentModel: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - mesh generation'));

  // We generate a checked image for texturing
  Checked := GenImageChecked(2, 2, 1, 1, RED, GREEN);
  Texture := LoadTextureFromImage(Checked);
  UnloadImage(Checked);

  Models[0] := LoadModelFromMesh(GenMeshPlane(2, 2, 5, 5));
  Models[1] := LoadModelFromMesh(GenMeshCube(2.0, 1.0, 2.0));
  Models[2] := LoadModelFromMesh(GenMeshSphere(2, 32, 32));
  Models[3] := LoadModelFromMesh(GenMeshHemiSphere(2, 16, 16));
  Models[4] := LoadModelFromMesh(GenMeshCylinder(1, 2, 16));
  Models[5] := LoadModelFromMesh(GenMeshTorus(0.25, 4.0, 16, 32));
  Models[6] := LoadModelFromMesh(GenMeshKnot(1.0, 2.0, 16, 128));
  Models[7] := LoadModelFromMesh(GenMeshPoly(5, 2.0));
  Models[8] := LoadModelFromMesh(GenMeshCustom());

  // Set checked texture as default diffuse component for all models material
  for I := 0 to NUM_MODELS - 1 do
    Models[I].Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture;

  // Define the camera to look into our 3d world
  Camera := TCamera.Create(
    TVector3.Create(5.0, 5.0, 5.0),
    TVector3.Create(0.0, 0.0, 0.0),
    TVector3.Create(0.0, 1.0, 0.0),
    45.0,
    0);

  // Model drawing position
  Position := TVector3.Create(0, 0, 0);

  CurrentModel := 0;

  SetCameraMode(Camera, CAMERA_ORBITAL); // Set a orbital camera mode

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera);

    if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) then
      CurrentModel := (CurrentModel + 1) mod NUM_MODELS; // Cycle between the textures

    if IsKeyPressed(KEY_RIGHT) then
    begin
      Inc(CurrentModel);
      if CurrentModel >= NUM_MODELS then
        CurrentModel := 0;
    end
    else if IsKeyPressed(KEY_LEFT) then
    begin
      Dec(CurrentModel);
      if CurrentModel < 0 then
        CurrentModel := NUM_MODELS - 1;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

       DrawModel(Models[CurrentModel], Position, 1.0, WHITE);
       DrawGrid(10, 1.0);

      EndMode3D();

      DrawRectangle(30, 400, 310, 30, Fade(SKYBLUE, 0.5));
      DrawRectangleLines(30, 400, 310, 30, Fade(DARKBLUE, 0.5));
      DrawText(UTF8String('MOUSE LEFT BUTTON to CYCLE PROCEDURAL MODELS'), 40, 410, 10, BLUE);

      case CurrentModel of
        0: DrawText(UTF8String('PLANE'), 680, 10, 20, DARKBLUE);
        1: DrawText(UTF8String('CUBE'), 680, 10, 20, DARKBLUE);
        2: DrawText(UTF8String('SPHERE'), 680, 10, 20, DARKBLUE);
        3: DrawText(UTF8String('HEMISPHERE'), 640, 10, 20, DARKBLUE);
        4: DrawText(UTF8String('CYLINDER'), 680, 10, 20, DARKBLUE);
        5: DrawText(UTF8String('TORUS'), 680, 10, 20, DARKBLUE);
        6: DrawText(UTF8String('KNOT'), 680, 10, 20, DARKBLUE);
        7: DrawText(UTF8String('POLY'), 680, 10, 20, DARKBLUE);
        8: DrawText(UTF8String('Custom (triangle)'), 580, 10, 20, DARKBLUE);
      end;

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Texture); // Unload texture

  // Unload models data (GPU VRAM)
  for I := 0 to NUM_MODELS - 1 do
    UnloadModel(Models[I]);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

function GenMeshCustom(): TMesh; // Generate a simple triangle mesh from code
begin
  Result := Default(TMesh);
  Result.TriangleCount := 1;
  Result.VertexCount := Result.TriangleCount * 3;
  Result.Vertices := MemAlloc(Result.VertexCount * 3 * SizeOf(Single));    // 3 vertices, 3 coordinates each (x, y, z)
  Result.Texcoords := MemAlloc(Result.VertexCount * 2 * SizeOf(Single));   // 3 vertices, 2 coordinates each (x, y)
  Result.Normals := MemAlloc(Result.VertexCount * 3 * SizeOf(Single));     // 3 vertices, 3 coordinates each (x, y, z)

  // Vertex at (0, 0, 0)
  Result.Vertices[0] := 0;
  Result.Vertices[1] := 0;
  Result.Vertices[2] := 0;
  Result.Normals[0] := 0;
  Result.Normals[1] := 1;
  Result.Normals[2] := 0;
  Result.Texcoords[0] := 0;
  Result.Texcoords[1] := 0;

  // Vertex at (1, 0, 2)
  Result.Vertices[3] := 1;
  Result.Vertices[4] := 0;
  Result.Vertices[5] := 2;
  Result.Normals[3] := 0;
  Result.Normals[4] := 1;
  Result.Normals[5] := 0;
  Result.Texcoords[2] := 0.5;
  Result.Texcoords[3] := 1.0;

  // Vertex at (2, 0, 0)
  Result.Vertices[6] := 2;
  Result.Vertices[7] := 0;
  Result.Vertices[8] := 0;
  Result.Normals[6] := 0;
  Result.Normals[7] := 1;
  Result.Normals[8] := 0;
  Result.Texcoords[4] := 1;
  Result.Texcoords[5] := 0;

  // Upload mesh data from CPU (RAM) to GPU (VRAM) memory
  UploadMesh(@Result, False);
end;
 
end.

