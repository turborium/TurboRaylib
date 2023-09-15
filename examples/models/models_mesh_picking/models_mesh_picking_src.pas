(*******************************************************************************************
*
*   raylib [models] example - Mesh picking in 3d mode, ground plane, triangle, mesh
*
*   Example contributed by Joel Davis (@joeld42) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2017-2023 Joel Davis (@joeld42) and Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit models_mesh_picking_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  Math,
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
  Ray: TRay;
  Tower: TModel;
  Texture: TTexture;
  TowerPos: TVector3;
  TowerBBox: TBoundingBox;
  G0, G1, G2, G3, Ta, Tb, TC, Bary, Sp: TVector3;
  Sr: Single;
  Collision, GroundHitInfo, TriHitInfo, SphereHitInfo, BoxHitInfo, MeshHitInfo: TRayCollision;
  HitObjectName: string;
  CursorColor: TColor;
  M: Integer;
  NormalEnd: TVector3;
  YPos: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - mesh picking'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(20.0, 20.0, 20.0); // Camera position
  Camera.Target := TVector3.Create(0.0, 8.0, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.6, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  Ray := Default(TRay);

  Tower := LoadModel(UTF8String('resources/models/models/obj/turret.obj'));             // Load OBJ model
  Texture := LoadTexture(UTF8String('resources/models/models/obj/turret_diffuse.png')); // Load model texture
  Tower.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture;                     // Set model diffuse texture

  TowerPos := TVector3.Create(0.0, 0.0, 0.0);                        // Set model position
  TowerBBox := GetMeshBoundingBox(Tower.Meshes[0]);                  // Get mesh bounding box

  // Ground quad
  G0 := TVector3.Create(-50.0, 0.0, -50.0);
  G1 := TVector3.Create(-50.0, 0.0,  50.0);
  G2 := TVector3.Create( 50.0, 0.0,  50.0);
  G3 := TVector3.Create( 50.0, 0.0, -50.0);

  // Test triangle
  Ta := TVector3.Create(-25.0, 0.5, 0.0);
  Tb := TVector3.Create( -4.0, 2.5, 1.0);
  Tc := TVector3.Create( -8.0, 6.5, 0.0);

  Bary := TVector3.Create(0.0, 0.0, 0.0);

  // Test sphere
  Sp := TVector3.Create(-30.0, 5.0, 5.0);
  Sr := 4.0;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsCursorHidden() then UpdateCamera(@Camera, CAMERA_FIRST_PERSON);          // Update camera

    // Toggle camera controls
    if IsMouseButtonPressed(MOUSE_BUTTON_RIGHT) then
    begin
      if IsCursorHidden() then
        EnableCursor()
      else
        DisableCursor();
    end;

    // Display information about closest hit
    Collision := Default(TRayCollision);
    HitObjectName := 'None';
    Collision.Distance := MaxSingle;
    Collision.Hit := False;
    CursorColor := WHITE;

    // Get ray and test against objects
    Ray := GetMouseRay(GetMousePosition(), Camera);

    // Check ray collision against ground quad
    GroundHitInfo := GetRayCollisionQuad(Ray, G0, G1, G2, g3);

    if (GroundHitInfo.Hit) and (GroundHitInfo.Distance < Collision.Distance) then
    begin
      Collision := GroundHitInfo;
      CursorColor := GREEN;
      HitObjectName := 'Ground';
    end;

    // Check ray collision against test triangle
    TriHitInfo := GetRayCollisionTriangle(Ray, Ta, Tb, Tc);

    if (TriHitInfo.Hit) and (TriHitInfo.Distance < Collision.Distance) then
    begin
      Collision := TriHitInfo;
      CursorColor := PURPLE;
      HitObjectName := 'Triangle';

      Bary := Vector3Barycenter(Collision.Point, Ta, Tb, Tc);
    end;

    // Check ray collision against test sphere
    SphereHitInfo := GetRayCollisionSphere(Ray, Sp, Sr);

    if (SphereHitInfo.Hit) and (SphereHitInfo.Distance < Collision.Distance) then
    begin
      Collision := SphereHitInfo;
      CursorColor := ORANGE;
      HitObjectName := 'Sphere';
    end;

    // Check ray collision against bounding box first, before trying the full ray-mesh test
    BoxHitInfo := GetRayCollisionBox(Ray, TowerBBox);

    if (BoxHitInfo.Hit) and (BoxHitInfo.Distance < Collision.Distance) then
    begin
      Collision := BoxHitInfo;
      CursorColor := ORANGE;
      HitObjectName := 'Box';

      // Check ray collision against model meshes
      MeshHitInfo := Default(TRayCollision);
      for M := 0 to Tower.MeshCount - 1 do
      begin
        // NOTE: We consider the model.transform for the collision check but
        // it can be checked against any transform Matrix, used when checking against same
        // model drawn multiple times with multiple transforms
        MeshHitInfo := GetRayCollisionMesh(Ray, Tower.Meshes[M], Tower.Transform);
        if MeshHitInfo.Hit then
        begin
          // Save the closest hit mesh
          if (not Collision.Hit) or (Collision.Distance > MeshHitInfo.Distance) then
            Collision := MeshHitInfo;

          break; // Stop once one mesh collision is detected, the colliding mesh is m
        end;
      end;

      if MeshHitInfo.Hit then
      begin
        Collision := MeshHitInfo;
        CursorColor := ORANGE;
        HitObjectName := 'Mesh';
      end;
    end;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        // Draw the tower
        // WARNING: If scale is different than 1.0f,
        // not considered by GetRayCollisionModel()
        DrawModel(Tower, TowerPos, 1.0, WHITE);

        // Draw the test triangle
        DrawLine3D(Ta, Tb, PURPLE);
        DrawLine3D(tb, Tc, PURPLE);
        DrawLine3D(Tc, Ta, PURPLE);

        // Draw the test sphere
        DrawSphereWires(Sp, Sr, 8, 8, PURPLE);

        // Draw the mesh bbox if we hit it
        if BoxHitInfo.Hit then
          DrawBoundingBox(TowerBBox, LIME);

        // If we hit something, draw the cursor at the hit point
        if Collision.hit then
        begin
          DrawCube(Collision.Point, 0.3, 0.3, 0.3, CursorColor);
          DrawCubeWires(Collision.Point, 0.3, 0.3, 0.3, RED);

          NormalEnd.X := Collision.Point.X + Collision.Normal.X;
          NormalEnd.Y := Collision.Point.Y + Collision.Normal.Y;
          NormalEnd.Z := Collision.Point.Z + Collision.Normal.Z;

          DrawLine3D(Collision.Point, NormalEnd, RED);
        end;

        DrawRay(Ray, MAROON);

        DrawGrid(10, 10.0);

      EndMode3D();

      // Draw some debug GUI text
      DrawText(TextFormat(UTF8String('Hit Object: %s'), PAnsiChar(UTF8String(HitObjectName))), 10, 50, 10, BLACK);

      if Collision.Hit then
      begin
        YPos := 70;

        DrawText(TextFormat(UTF8String('Distance: %3.2f'), Collision.Distance), 10, YPos, 10, BLACK);

        DrawText(TextFormat(UTF8String('Hit Pos: %3.2f %3.2f %3.2f'),
                            Collision.Point.X,
                            Collision.Point.Y,
                            Collision.Point.Z), 10, YPos + 15, 10, BLACK);

        DrawText(TextFormat(UTF8String('Hit Norm: %3.2f %3.2f %3.2f'),
                            Collision.Normal.X,
                            Collision.Normal.Y,
                            Collision.Normal.Z), 10, YPos + 30, 10, BLACK);

        if TriHitInfo.Hit and TextIsEqual(PAnsiChar(UTF8String(HitObjectName)), UTF8String('Triangle')) then
            DrawText(TextFormat(UTF8String('Barycenter: %3.2f %3.2f %3.2f'), Bary.X, Bary.Y, Bary.Z), 10, YPos + 45, 10, BLACK);
      end;

      DrawText(UTF8String('Use Mouse to Move Camera'), 10, 430, 10, GRAY);

      DrawText(UTF8String('(c) Turret 3D model by Alberto Cano'), ScreenWidth - 200, ScreenHeight - 20, 10, GRAY);

      DrawFPS(10, 10);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadModel(Tower);         // Unload model
  UnloadTexture(Texture);     // Unload texture


  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

