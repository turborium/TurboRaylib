(*******************************************************************************************
*
*   raylib [shaders] example - Model shader
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit shaders_model_shader_src;

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
  Camera: TCamera;
  Model: TModel;
  Texture: TTexture2D;
  Shader: TShader;
  Position: TVector3;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - model shader'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(4.0, 4.0, 4.0);  // Camera position
  Camera.Target := TVector3.Create(0.0, 1.0, -1.0);   // Camera looking at point
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);        // Camera up vector (rotation towards target)
  Camera.Fovy := 45.0;                                // Camera field-of-view Y
  Camera.Projection := CAMERA_PERSPECTIVE;            // Camera mode type

  Model := LoadModel(UTF8String('resources/shaders/models/watermill.obj'));                   // Load OBJ model
  Texture :=  LoadTexture(UTF8String('resources/shaders/models/watermill_diffuse.png'));      // Load model texture

  // Load basic lighting shader
  Shader := LoadShader(
    TextFormat(UTF8String('resources/shaders/shaders/glsl%i/lighting.vs'), GLSL_VERSION),
    TextFormat(UTF8String('resources/shaders/shaders/glsl%i/lighting.fs'), GLSL_VERSION));

  // Load shader for model
  // NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
  Shader := LoadShader(nil, TextFormat(UTF8String('resources/shaders/shaders/glsl%i/grayscale.fs'), Integer(GLSL_VERSION)));

  Model.Materials[0].Shader := Shader;                              // Set shader effect to 3d model
  Model.Materials[0].Maps[MATERIAL_MAP_DIFFUSE].Texture := Texture; // Bind texture to model

  Position := TVector3.Create(0.0, 0.0, 0.0);    // Set model position

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera, CAMERA_FIRST_PERSON);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        DrawModel(Model, Position, 0.2, WHITE);   // Draw 3d model with texture

        DrawGrid(10, 1.0);     // Draw a grid

      EndMode3D();

      DrawText(UTF8String('(c) Watermill 3D model by Alberto Cano'), ScreenWidth - 210, ScreenHeight - 20, 10, GRAY);

      DrawFPS(10, 10);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadShader(Shader);       // Unload shader
  UnloadTexture(Texture);     // Unload texture
  UnloadModel(Model);         // Unload model

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

end.

