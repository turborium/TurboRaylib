(*******************************************************************************************
*
*   raylib [models] example - Detect basic 3d collisions (box vs sphere vs box)
*
*   Example originally created with raylib 1.3, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit models_box_collisions_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

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
  PlayerPosition, PlayerSize: TVector3;
  PlayerColor: TColor;
  EnemyBoxPos, EnemyBoxSize, EnemySpherePos: TVector3;
  EnemySphereSize: Single;
  Collision: Boolean;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - box collisions'));

  // Define the camera to look into our 3d world
  Camera := TCamera.Create(
    TVector3.Create(0.0, 10.0, 10.0),
    TVector3.Create(0.0, 0.0, 0.0),
    TVector3.Create(0.0, 1.0, 0.0),
    45.0, 0);

  PlayerPosition := TVector3.Create(0.0, 1.0, 2.0);
  PlayerSize := TVector3.Create(1.0, 2.0, 1.0);
  PlayerColor := GREEN;

  EnemyBoxPos := TVector3.Create(-4.0, 1.0, 0.0);
  EnemyBoxSize := TVector3.Create(2.0, 2.0, 2.0);

  EnemySpherePos := TVector3.Create(4.0, 0.0, 0.0);
  EnemySphereSize := 1.5;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    // Move player
    if IsKeyDown(KEY_RIGHT) then
      PlayerPosition.X := PlayerPosition.X + 0.2
    else if IsKeyDown(KEY_LEFT) then
      PlayerPosition.X := PlayerPosition.X - 0.2
    else if IsKeyDown(KEY_DOWN) then
      PlayerPosition.Z := PlayerPosition.Z + 0.2
    else if IsKeyDown(KEY_UP) then
      PlayerPosition.Z := PlayerPosition.Z - 0.2;

    Collision := False;

    // Check collisions player vs enemy-box
    if CheckCollisionBoxes(
      TBoundingBox.Create(
        TVector3.Create(PlayerPosition.X - PlayerSize.X / 2, PlayerPosition.Y - PlayerSize.Y / 2, PlayerPosition.Z - PlayerSize.Z / 2),
        TVector3.Create(PlayerPosition.X + PlayerSize.X / 2, PlayerPosition.Y + PlayerSize.Y / 2, PlayerPosition.Z + PlayerSize.Z / 2)
      ),
      TBoundingBox.Create(
        TVector3.Create(EnemyBoxPos.X - EnemyBoxSize.X / 2, EnemyBoxPos.Y - EnemyBoxSize.Y / 2, EnemyBoxPos.Z - EnemyBoxSize.Z / 2),
        TVector3.Create(EnemyBoxPos.X + enemyBoxSize.X / 2, EnemyBoxPos.Y + EnemyBoxSize.Y / 2, EnemyBoxPos.Z + EnemyBoxSize.Z / 2)
      )
    ) then Collision := True;

    // Check collisions player vs enemy-sphere
    if CheckCollisionBoxSphere(
      TBoundingBox.Create(
        TVector3.Create(PlayerPosition.X - PlayerSize.X / 2, PlayerPosition.Y - PlayerSize.Y / 2, PlayerPosition.Z - PlayerSize.Z / 2),
        TVector3.Create(PlayerPosition.X + PlayerSize.X / 2, PlayerPosition.Y + PlayerSize.Y / 2, PlayerPosition.Z + PlayerSize.Z / 2)
      ),
      EnemySpherePos,
      EnemySphereSize
    ) then Collision := True;

    if Collision then
      PlayerColor := RED
    else
      PlayerColor := GREEN;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        // Draw enemy-box
        DrawCube(EnemyBoxPos, EnemyBoxSize.X, EnemyBoxSize.Y, EnemyBoxSize.Z, GRAY);
        DrawCubeWires(EnemyBoxPos, EnemyBoxSize.X, EnemyBoxSize.Y, EnemyBoxSize.Z, DARKGRAY);

        // Draw enemy-sphere
        DrawSphere(EnemySpherePos, enemySphereSize, GRAY);
        DrawSphereWires(EnemySpherePos, EnemySphereSize, 16, 16, DARKGRAY);

        // Draw player
        DrawCubeV(PlayerPosition, PlayerSize, PlayerColor);

        DrawGrid(10, 1.0);        // Draw a grid

      EndMode3D();

      DrawText(UTF8String('Move player with cursors to collide'), 220, 40, 20, GRAY);

      DrawFPS(10, 10);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

