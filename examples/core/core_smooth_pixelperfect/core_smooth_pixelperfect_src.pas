(*******************************************************************************************
*
*   raylib [core] example - smooth pixel-perfect camera
*
*   Example contributed by Giancamillo Alessandroni (@NotManyIdeasDev) and
*   reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2021-2022 Giancamillo Alessandroni (@NotManyIdeasDev) and Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit core_smooth_pixelperfect_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
  VirtualScreenWidth = 160;
  VirtualScreenHeight = 90;
  VirtualRatio = ScreenWidth / VirtualScreenWidth;
var
  WorldSpaceCamera: TCamera2D;
  ScreenSpaceCamera: TCamera2D;
  Target: TRenderTexture2D;
  Rec01, Rec02, Rec03: TRectangle;
  SourceRec, DestRec: TRectangle;
  Origin: TVector2;
  Rotation, CameraX, CameraY: Single;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - smooth pixel-perfect camera'));

  WorldSpaceCamera := Default(TCamera2D); // Game world camera
  WorldSpaceCamera.Zoom := 1.0;

  ScreenSpaceCamera := Default(TCamera2D); // Smoothing camera
  ScreenSpaceCamera.Zoom := 1.0;

  Target := LoadRenderTexture(VirtualScreenWidth, VirtualScreenHeight); // This is where we'll draw all our objects.

  Rec01 := TRectangle.Create(70.0, 35.0, 20.0, 20.0);
  Rec02 := TRectangle.Create(90.0, 55.0, 30.0, 10.0);
  Rec03 := TRectangle.Create(80.0, 65.0, 15.0, 25.0);

  // The target's height is flipped (in the source Rectangle), due to OpenGL reasons
  SourceRec := TRectangle.Create(0.0, 0.0, Target.Texture.Width, -Target.Texture.Height);
  DestRec := TRectangle.Create(-VirtualRatio, -VirtualRatio, ScreenWidth + (VirtualRatio * 2), ScreenHeight + (VirtualRatio * 2));

  Origin := TVector2.Create(0.0, 0.0);

  Rotation := 0.0;

  SetTargetFPS(60);
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    Rotation := Rotation + 60.0 * GetFrameTime(); // Rotate the rectangles, 60 degrees per second

    // Make the camera move to demonstrate the effect
    CameraX := (Sin(GetTime()) * 50.0) - 10.0;
    CameraY := Cos(GetTime()) * 30.0;

    // Set the camera's target to the values computed above
    ScreenSpaceCamera.Target := TVector2.Create(CameraX, CameraY);

    // Round worldSpace coordinates, keep decimals into screenSpace coordinates
    WorldSpaceCamera.Target.X := Trunc(ScreenSpaceCamera.Target.X);
    ScreenSpaceCamera.Target.X := ScreenSpaceCamera.Target.X - WorldSpaceCamera.Target.X;
    ScreenSpaceCamera.Target.X := ScreenSpaceCamera.Target.X * VirtualRatio;

    WorldSpaceCamera.Target.Y := Trunc(ScreenSpaceCamera.Target.Y);
    ScreenSpaceCamera.Target.Y := ScreenSpaceCamera.Target.Y - WorldSpaceCamera.Target.Y;
    ScreenSpaceCamera.Target.Y := ScreenSpaceCamera.Target.Y * VirtualRatio;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginTextureMode(Target);
      ClearBackground(RAYWHITE);

      BeginMode2D(WorldSpaceCamera);
        DrawRectanglePro(Rec01, Origin, Rotation, BLACK);
        DrawRectanglePro(Rec02, Origin, -Rotation, RED);
        DrawRectanglePro(Rec03, Origin, Rotation + 45.0, BLUE);
      EndMode2D();
    EndTextureMode();

    BeginDrawing();
      ClearBackground(RED);

      BeginMode2D(ScreenSpaceCamera);
        DrawTexturePro(Target.Texture, SourceRec, DestRec, Origin, 0.0, WHITE);
      EndMode2D();

      DrawText(TextFormat(UTF8String('Screen resolution: %ix%i'), ScreenWidth, ScreenHeight), 10, 10, 20, DARKBLUE);
      DrawText(TextFormat(UTF8String('World resolution: %ix%i'), VirtualScreenWidth, VirtualScreenHeight), 10, 40, 20, DARKGREEN);
      DrawFPS(GetScreenWidth() - 95, 10);
    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadRenderTexture(Target);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

