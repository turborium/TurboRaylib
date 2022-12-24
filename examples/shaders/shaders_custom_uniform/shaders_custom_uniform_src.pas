(*******************************************************************************************
*
*   raylib [shaders] example - Apply a postprocessing shader and connect a custom uniform variable
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
unit shaders_custom_uniform_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib,
  raymath;

const
  GLSL_VERSION = 330;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Texture: TTexture2D;
  Shader: TShader;
  Camera: TCamera;
  Model: TModel;
  Position: TVector3;
  SwirlCenterLoc: Integer;
  SwirlCenter: array [0..1] of Single;
  Target: TRenderTexture2D;
  MousePosition: TVector2;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT {or FLAG_WINDOW_HIGHDPI});
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - custom uniform variable'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(8.0, 8.0, 8.0);  // Camera position
  Camera.Target := TVector3.Create(0.0, 1.5, 0.0);    // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);        // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;            // Camera mode type

  Model := LoadModel(UTF8String('resources/shaders/models/barracks.obj'));                   // Load OBJ model
  Texture := LoadTexture(UTF8String('resources/shaders/models/barracks_diffuse.png'));   // Load model texture (diffuse map)
  Model.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture;                     // Set model diffuse texture

  Position := TVector3.Create(0.0, 0.0, 0.0);                                    // Set model position

  // Load postprocessing shader
  // NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
  Shader := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/swirl.fs'), Integer(GLSL_VERSION)));

  // Get variable (uniform) location on the shader to connect with the program
  // NOTE: If uniform variable could not be found in the shader, function returns -1
  SwirlCenterLoc := GetShaderLocation(Shader, UTF8String('center'));

  SwirlCenter[0] := ScreenWidth / 2;
  SwirlCenter[1] := ScreenHeight / 2;

  // Create a RenderTexture2D to be used for render to texture
  Target := LoadRenderTexture(ScreenWidth, ScreenHeight);

  // Setup orbital camera
  SetCameraMode(Camera, CAMERA_ORBITAL);  // Set an orbital camera mode

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera);

    MousePosition := GetMousePosition();

    SwirlCenter[0] := MousePosition.X;
    SwirlCenter[1] := ScreenHeight - MousePosition.Y;

    // Send new value to the shader to be used on drawing
    SetShaderValue(Shader, SwirlCenterLoc, @SwirlCenter[0], SHADER_UNIFORM_VEC2);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginTextureMode(Target);       // Enable drawing to texture
      ClearBackground(RAYWHITE);  // Clear texture background

      BeginMode3D(Camera);        // Begin 3d mode drawing
        DrawModel(Model, Position, 0.5, WHITE);   // Draw 3d model with texture
        DrawGrid(10, 1.0);     // Draw a grid
      EndMode3D();                // End 3d mode drawing, returns to orthographic 2d mode

      DrawText(UTF8String('TEXT DRAWN IN RENDER TEXTURE'), 200, 10, 30, RED);
    EndTextureMode();               // End drawing to texture (now we have a texture available for next passes)

    BeginDrawing();
      ClearBackground(RAYWHITE);  // Clear screen background

      // Enable shader using the custom uniform
      BeginShaderMode(Shader);
        // NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
        DrawTextureRec(Target.Texture, TRectangle.Create(0, 0, Target.Texture.Width, -Target.Texture.Height), TVector2.Create(0, 0), WHITE);
      EndShaderMode();

      // Draw some 2d text over drawn texture
      DrawText(UTF8String('(c) Barracks 3D model by Alberto Cano'), ScreenWidth - 220, ScreenHeight - 20, 10, GRAY);
      DrawFPS(10, 10);
    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadShader(Shader);               // Unload shader
  UnloadTexture(Texture);             // Unload texture
  UnloadModel(Model);                 // Unload model
  UnloadRenderTexture(Target);        // Unload render texture

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

