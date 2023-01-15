(*******************************************************************************************
*
*   raylib [models] example - rlgl module usage with push/pop matrix transformations
*
*   NOTE: This example uses [rlgl] module functionality (pseudo-OpenGL 1.1 style coding)
*
*   Example originally created with raylib 2.5, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2018-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit models_rlgl_solar_system_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  rlgl,
  raylib,
  raymath;

// Draw sphere without any matrix transformation
// NOTE: Sphere is drawn in world position ( 0, 0, 0 ) with radius 1.0f
procedure DrawSphereBasic(Color: TColor);
var
  Rings, Slices: Integer;
  I, J: Integer;
begin
  Rings := 16;
  Slices := 16;

  // Make sure there is enough space in the internal render batch
  // buffer to store all required vertex, batch is reseted if required
  rlCheckRenderBatchLimit((Rings + 2) * Slices * 6);

  rlBegin(RL_TRIANGLES);
    rlColor4ub(Color.R, Color.G, Color.B, Color.A);

    for I := 0 to Rings + 0 do
    begin
      for J := 0 to Slices - 1 do
      begin
        rlVertex3f(Cos(DEG2RAD * (270 + (180 / (Rings + 1)) * I)) * Sin(DEG2RAD * (J * 360 / Slices)),
                   Sin(DEG2RAD * (270 + (180 / (Rings + 1)) * I)),
                   Cos(DEG2RAD * (270 + (180 / (Rings + 1)) * I)) * Cos(DEG2RAD * (J * 360 / Slices)));
        rlVertex3f(Cos(DEG2RAD * (270 + (180 / (Rings + 1)) * (I + 1))) * Sin(DEG2RAD * ((J + 1) * 360 / Slices)),
                   Sin(DEG2RAD * (270 + (180 / (Rings + 1)) * (I + 1))),
                   Cos(DEG2RAD * (270 + (180 / (Rings + 1)) * (I + 1))) * Cos(DEG2RAD * ((J + 1) * 360 / Slices)));
        rlVertex3f(Cos(DEG2RAD * (270 + (180 / (Rings + 1)) * (I + 1))) * Sin(DEG2RAD * (J * 360 / Slices)),
                   Sin(DEG2RAD * (270 + (180 / (Rings + 1)) * (I + 1))),
                   Cos(DEG2RAD * (270 + (180 / (Rings + 1)) * (I + 1))) * Cos(DEG2RAD * (J * 360 / Slices)));

        rlVertex3f(Cos(DEG2RAD * (270 + (180 / (Rings + 1)) * I)) * Sin(DEG2RAD * (J * 360 / Slices)),
                   Sin(DEG2RAD * (270 + (180 / (Rings + 1)) * I)),
                   Cos(DEG2RAD * (270 + (180 / (Rings + 1)) * I)) * Cos(DEG2RAD * (J * 360 / Slices)));
        rlVertex3f(Cos(DEG2RAD * (270 + (180 / (Rings + 1)) * (I))) * Sin(DEG2RAD * ((J + 1) * 360 / Slices)),
                   Sin(DEG2RAD * (270 + (180 / (Rings + 1)) * (I))),
                   Cos(DEG2RAD * (270 + (180 / (Rings + 1)) * (I))) * Cos(DEG2RAD * ((J + 1) * 360 / Slices)));
        rlVertex3f(Cos(DEG2RAD * (270 + (180 / (Rings + 1)) * (I + 1))) * Sin(DEG2RAD * ((J + 1) * 360 / Slices)),
                   Sin(DEG2RAD * (270 + (180 / (Rings + 1)) * (I + 1))),
                   Cos(DEG2RAD * (270 + (180 / (Rings + 1)) * (I + 1))) * Cos(DEG2RAD * ((J + 1) * 360 / Slices)));
      end;
    end;
  rlEnd();
end;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
  SunRadius = 4.0;
  EarthRadius = 0.6;
  EarthOrbitRadius = 8.0;
  MoonRadius = 0.16;
  MoonOrbitRadius = 1.5;
var
  Camera: TCamera;
  RotationSpeed, EarthRotation, EarthOrbitRotation, MoonRotation, MoonOrbitRotation: Single;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - rlgl module usage with push/pop matrix transformations'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(16.0, 16.0, 16.0);  // Camera position
  Camera.Target := TVector3.Create(0.0, 0.0, 0.0);       // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);           // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                   // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;               // Camera mode type

  SetCameraMode(Camera, CAMERA_FREE);

  RotationSpeed := 0.2;         // General system rotation speed

  EarthRotation := 0.0;         // Rotation of earth around itself (days) in degrees
  EarthOrbitRotation := 0.0;    // Rotation of earth around the Sun (years) in degrees
  MoonRotation := 0.0;          // Rotation of moon around itself
  MoonOrbitRotation := 0.0;     // Rotation of moon around earth in degrees

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera);

    EarthRotation := EarthRotation + (5.0 * RotationSpeed);
    EarthOrbitRotation := EarthOrbitRotation + (365 / 360.0 * (5.0 * RotationSpeed) * RotationSpeed);
    MoonRotation := MoonRotation + (2.0 * RotationSpeed);
    MoonOrbitRotation := MoonOrbitRotation + (8.0 * RotationSpeed);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        rlPushMatrix();
          rlScalef(SunRadius, SunRadius, SunRadius);         // Scale Sun
          DrawSphereBasic(GOLD);                             // Draw the Sun
        rlPopMatrix();

        rlPushMatrix();
          rlRotatef(EarthOrbitRotation, 0.0, 1.0, 0.0);      // Rotation for Earth orbit around Sun
          rlTranslatef(EarthOrbitRadius, 0.0, 0.0);          // Translation for Earth orbit

          rlPushMatrix();
            rlRotatef(EarthRotation, 0.25, 1.0, 0.0);        // Rotation for Earth itself
            rlScalef(EarthRadius, EarthRadius, EarthRadius); // Scale Earth

            DrawSphereBasic(BLUE);                           // Draw the Earth
          rlPopMatrix();

          rlRotatef(MoonOrbitRotation, 0.0, 1.0, 0.0);       // Rotation for Moon orbit around Earth
          rlTranslatef(MoonOrbitRadius, 0.0, 0.0);           // Translation for Moon orbit
          rlRotatef(MoonRotation, 0.0, 1.0, 0.0);            // Rotation for Moon itself
          rlScalef(MoonRadius, MoonRadius, MoonRadius);      // Scale Moon

          DrawSphereBasic(LIGHTGRAY);                        // Draw the Moon
        rlPopMatrix();

        // Some reference elements (not affected by previous matrix transformations)
        DrawCircle3D(TVector3.Create(0.0, 0.0, 0.0), EarthOrbitRadius, TVector3.Create(1, 0, 0), 90.0, Fade(RED, 0.5));
        DrawGrid(20, 1.0);

      EndMode3D();

      DrawText(UTF8String('EARTH ORBITING AROUND THE SUN!'), 400, 10, 20, MAROON);
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

