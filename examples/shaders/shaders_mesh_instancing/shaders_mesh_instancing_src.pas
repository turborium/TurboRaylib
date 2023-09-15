(*******************************************************************************************
*
*   raylib [shaders] example - Mesh instancing
*
*   Example contributed by @seanpringle and reviewed by Max (@moliad) and Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2020-2023 @seanpringle, Max (@moliad) and Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit shaders_mesh_instancing_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib,
  raymath,
  rlights;

const
  GLSL_VERSION = 330;

  MAX_INSTANCES = 10000;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Shader: TShader;
  Camera: TCamera;
  Cube: TMesh;
  Transforms: array of TMatrix;
  I: Integer;
  Translation, Rotation: TMatrix;
  Axis: TVector3;
  Angle: Single;
  AmbientLoc: Integer;
  MatInstances, MatDefault: TMaterial;
  ShaderVal: array of Single;
  CameraPos: array of Single;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags({FLAG_MSAA_4X_HINT or} FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [shaders] example - mesh instancing'));

  // Define the camera to look into our 3d world
  Camera := TCamera.Create(
    TVector3.Create(-125.0, 125.0, -125.0),      // position
    TVector3.Create(0.0, 0.0, 0.0),      // target
    TVector3.Create(0.0, 1.0, 0.0),      // up
    45.0, CAMERA_PERSPECTIVE             // fov, type
  );

  // Define mesh to be instanced
  Cube := GenMeshCube(1.0, 1.0, 1.0);

  // Define transforms to be uploaded to GPU for instances
  SetLength(Transforms, MAX_INSTANCES);   // Pre-multiplied transformations passed to rlgl

  // Translate and rotate cubes randomly
  for I := 0 to High(Transforms) do
  begin
    Translation := MatrixTranslate(GetRandomValue(-50, 50), GetRandomValue(-50, 50), GetRandomValue(-50, 50));
    Axis := Vector3Normalize(TVector3.Create(GetRandomValue(0, 360), GetRandomValue(0, 360), GetRandomValue(0, 360)));
    Angle := GetRandomValue(0, 10) * DEG2RAD;
    Rotation := MatrixRotate(Axis, Angle);

    Transforms[I] := MatrixMultiply(Rotation, Translation);
  end;

  // Load lighting shader
  Shader := LoadShader(TextFormat(UTF8String('resources/shaders/shaders/glsl%i/lighting_instancing.vs'), Integer(GLSL_VERSION)),
                             TextFormat(UTF8String('resources/shaders/shaders/glsl%i/lighting.fs'), Integer(GLSL_VERSION)));
  // Get shader locations
  Shader.Locs[SHADER_LOC_MATRIX_MVP] := GetShaderLocation(Shader, UTF8String('mvp'));
  Shader.Locs[SHADER_LOC_VECTOR_VIEW] := GetShaderLocation(Shader, UTF8String('viewPos'));
  Shader.Locs[SHADER_LOC_MATRIX_MODEL] := GetShaderLocationAttrib(Shader, UTF8String('instanceTransform'));

  // Set shader value: ambient light level
  AmbientLoc := GetShaderLocation(Shader, UTF8String('ambient'));
  ShaderVal := [0.2, 0.2, 0.2, 1.0];
  SetShaderValue(Shader, AmbientLoc, @ShaderVal[0], SHADER_UNIFORM_VEC4);

  // Create one light
  CreateLight(LIGHT_DIRECTIONAL, TVector3.Create(50.0, 50.0, 0.0), Vector3Zero(), WHITE, Shader);

  // NOTE: We are assigning the intancing shader to material.shader
  // to be used on mesh drawing with DrawMeshInstanced()
  MatInstances := LoadMaterialDefault();
  MatInstances.Shader := Shader;
  MatInstances.Maps[MATERIAL_MAP_DIFFUSE].Color := RED;

  // Load default material (using raylib intenral default shader) for non-instanced mesh drawing
  // WARNING: Default shader enables vertex color attribute BUT GenMeshCube() does not generate vertex colors, so,
  // when drawing the color attribute is disabled and a default color value is provided as input for thevertex attribute
  MatDefault := LoadMaterialDefault();
  MatDefault.Maps[MATERIAL_MAP_DIFFUSE].Color := BLUE;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    UpdateCamera(@Camera, CAMERA_ORBITAL);

    // Update the light shader with the camera view position
    CameraPos := [Camera.Position.X, Camera.Position.Y, Camera.Position.Z];
    SetShaderValue(Shader, Shader.Locs[SHADER_LOC_VECTOR_VIEW], @CameraPos[0], SHADER_UNIFORM_VEC3);
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        // Draw cube mesh with default material (BLUE)
        DrawMesh(Cube, MatDefault, MatrixTranslate(-10.0, 0.0, 0.0));

        // Draw meshes instanced using material containing instancing shader (RED + lighting),
        // transforms[] for the instances should be provided, they are dynamically
        // updated in GPU every frame, so we can animate the different mesh instances
        DrawMeshInstanced(Cube, MatInstances, @Transforms[0], MAX_INSTANCES);

        // Draw cube mesh with default material (BLUE)
        DrawMesh(Cube, MatDefault, MatrixTranslate(10.0, 0.0, 0.0));

      EndMode3D();

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

