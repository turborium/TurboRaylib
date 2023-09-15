(*******************************************************************************************
*
*   raylib [core] example - 3d camera first person
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit core_3d_camera_first_person_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib,
  StrUtils;

const
  MAX_COLUMNS = 20;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Camera: TCamera3D;
  Heights: array [0..MAX_COLUMNS-1] of Single;
  Positions: array [0..MAX_COLUMNS-1] of TVector3;
  Colors: array [0..MAX_COLUMNS-1] of TColor;
  I: Integer;
  CameraMode: Integer;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - 3d camera first person'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera3D);
  Camera.Position := TVector3.Create(0.0, 2.0, 4.0);    // Camera position
  Camera.Target := TVector3.Create(0.0, 2.0, 0.0);      // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);          // Camera up vector (rotation towards target)
  Camera.Fovy := 60.0;                                  // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;              // Camera mode type

  CameraMode := CAMERA_FIRST_PERSON;

  // Generates some random columns
  for I := 0 to MAX_COLUMNS - 1 do
  begin
    Heights[i] := GetRandomValue(1, 12);
    Positions[i] := TVector3.Create(GetRandomValue(-15, 15), Heights[i] / 2.0, GetRandomValue(-15, 15));
    Colors[i] := TColor.Create(GetRandomValue(20, 255), GetRandomValue(10, 55), 30, 255);
  end;

  DisableCursor(); // Limit cursor to relative movement inside the window

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    // TODO: Update your variables here
    //-------------------------------------------------------------------------------------------
    // Switch camera mode
    if IsKeyPressed(KEY_ONE) then
    begin
      CameraMode := CAMERA_FREE;
      Camera.Up := TVector3.Create(0.0, 1.0, 0.0); // Reset roll
    end;
    if IsKeyPressed(KEY_TWO) then
    begin
      CameraMode := CAMERA_FIRST_PERSON;
      Camera.Up := TVector3.Create(0.0, 1.0, 0.0); // Reset roll
    end;
    if IsKeyPressed(KEY_THREE) then
    begin
      CameraMode := CAMERA_THIRD_PERSON;
      Camera.Up := TVector3.Create(0.0, 1.0, 0.0); // Reset roll
    end;
    if IsKeyPressed(KEY_FOUR) then
    begin
      CameraMode := CAMERA_ORBITAL;
      Camera.Up := TVector3.Create(0.0, 1.0, 0.0); // Reset roll
    end;
    // Switch camera projection
    if IsKeyPressed(KEY_P) then
    begin
      if Camera.Projection = CAMERA_PERSPECTIVE then
      begin
        // Create isometric view
        CameraMode := CAMERA_THIRD_PERSON;
        // Note: The target distance is related to the render distance in the orthographic projection
        Camera.Position := TVector3.Create(0.0, 2.0, -100.0);
        Camera.Target := TVector3.Create(0.0, 2.0, 0.0);
        Camera.Up := TVector3.Create(0.0, 1.0, 0.0);
        Camera.Projection := CAMERA_ORTHOGRAPHIC;
        Camera.Fovy := 20.0; // near plane width in CAMERA_ORTHOGRAPHIC
        CameraYaw(@Camera, -135 * DEG2RAD, True);
        CameraPitch(@Camera, -45 * DEG2RAD, True, True, False);
      end
      else if Camera.Projection = CAMERA_ORTHOGRAPHIC then
      begin
        // Reset to default view
        CameraMode := CAMERA_THIRD_PERSON;
        Camera.Position := TVector3.Create(0.0, 2.0, 10.0);
        Camera.Target := TVector3.Create(0.0, 2.0, 0.0);
        Camera.Up := TVector3.Create(0.0, 1.0, 0.0);
        Camera.Projection := CAMERA_PERSPECTIVE;
        Camera.Fovy := 60.0;
      end;
    end;
    // Update camera computes movement internally depending on the camera mode
    // Some default standard keyboard/mouse inputs are hardcoded to simplify use
    // For advance camera controls, it's reecommended to compute camera movement manually
    UpdateCamera(@Camera, CameraMode);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        DrawPlane(TVector3.Create(0.0, 0.0, 0.0), TVector2.Create(32.0, 32.0), LIGHTGRAY); // Draw ground
        DrawCube(TVector3.Create(-16.0, 2.5, 0.0), 1.0, 5.0, 32.0, BLUE);                  // Draw a blue wall
        DrawCube(TVector3.Create(16.0, 2.5, 0.0), 1.0, 5.0, 32.0, LIME);                   // Draw a green wall
        DrawCube(TVector3.Create(0.0, 2.5, 16.0), 32.0, 5.0, 1.0, GOLD);                   // Draw a yellow wall

        // Draw some cubes around
        for I := 0 to MAX_COLUMNS - 1 do
        begin
          DrawCube(Positions[i], 2.0, Heights[i], 2.0, Colors[i]);
          DrawCubeWires(Positions[i], 2.0, Heights[i], 2.0, MAROON);
        end;

        // Draw player cube
        if CameraMode = CAMERA_THIRD_PERSON then
        begin
          DrawCube(Camera.Target, 0.5, 0.5, 0.5, PURPLE);
          DrawCubeWires(Camera.Target, 0.5, 0.5, 0.5, DARKPURPLE);
        end;

      EndMode3D();

      // Draw info boxes
      DrawRectangle(5, 5, 330, 100, Fade(SKYBLUE, 0.5));
      DrawRectangleLines(5, 5, 330, 100, BLUE);
      DrawText(UTF8String('Camera controls:'), 15, 15, 10, BLACK);
      DrawText(UTF8String('- Move keys: W, A, S, D, Space, Left-Ctrl'), 15, 30, 10, BLACK);
      DrawText(UTF8String('- Look around: arrow keys or mouse'), 15, 45, 10, BLACK);
      DrawText(UTF8String('- Camera mode keys: 1, 2, 3, 4'), 15, 60, 10, BLACK);
      DrawText(UTF8String('- Zoom keys: num-plus, num-minus or mouse scroll'), 15, 75, 10, BLACK);
      DrawText(UTF8String('- Camera projection key: P'), 15, 90, 10, BLACK);
      DrawRectangle(600, 5, 195, 100, Fade(SKYBLUE, 0.5));
      DrawRectangleLines(600, 5, 195, 100, BLUE);
      DrawText(UTF8String('Camera status:'), 610, 15, 10, BLACK);
      DrawText(TextFormat(UTF8String('- Mode: %s'), UTF8String(IfThen(CameraMode = CAMERA_FREE, 'FREE',
                                        IfThen(CameraMode = CAMERA_FIRST_PERSON, 'FIRST_PERSON',
                                        IfThen(CameraMode = CAMERA_THIRD_PERSON, 'THIRD_PERSON',
                                        IfThen(CameraMode = CAMERA_ORBITAL, 'ORBITAL', 'CUSTOM')))))), 610, 30, 10, BLACK);
      DrawText(TextFormat(UTF8String('- Projection: %s'), UTF8String(IfThen(Camera.Projection = CAMERA_PERSPECTIVE, 'PERSPECTIVE',
                                              IfThen(Camera.Projection = CAMERA_ORTHOGRAPHIC, 'ORTHOGRAPHIC', 'CUSTOM')))), 610, 45, 10, BLACK);
      DrawText(TextFormat(UTF8String('- Position: (%06.3f, %06.3f, %06.3f)'), Camera.Position.X, Camera.Position.Y, Camera.Position.Z), 610, 60, 10, BLACK);
      DrawText(TextFormat(UTF8String('- Target: (%06.3f, %06.3f, %06.3f)'), Camera.Target.X, Camera.Target.Y, Camera.Target.Z), 610, 75, 10, BLACK);
      DrawText(TextFormat(UTF8String('- Up: (%06.3f, %06.3f, %06.3f)'), Camera.Up.X, Camera.Up.Y, Camera.Up.Z), 610, 90, 10, BLACK);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

