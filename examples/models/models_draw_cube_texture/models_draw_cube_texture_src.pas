(*******************************************************************************************
*
*   raylib [models] example - Draw textured cube
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2022-2023 Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit models_draw_cube_texture_src;

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

//------------------------------------------------------------------------------------
// Custom Functions Declaration
//------------------------------------------------------------------------------------
procedure DrawCubeTexture(Texture: TTexture2D; Position: TVector3; Width, Height, Length: Single; Color: TColor); forward;// Draw cube textured
procedure DrawCubeTextureRec(Texture: TTexture2D; Source: TRectangle; Position: TVector3; Width, Height, Length: Single; Color: TColor); forward;// Draw cube with a region of a texture

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Camera: TCamera;
  Texture: TTexture2D;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [models] example - draw cube texture'));

  // Define the camera to look into our 3d world
  Camera := Default(TCamera);
  Camera.Position := TVector3.Create(0.0, 10.0, 10.0);
  Camera.Target := TVector3.Create(0.0, 0.0, 0.0);
  Camera.Up := TVector3.Create(0.0, 1.0, 0.0);
  Camera.Fovy := 45.0;
  Camera.Projection := CAMERA_PERSPECTIVE;

  // Load texture to be applied to the cubes sides
  Texture := LoadTexture(UTF8String('resources/models/cubicmap_atlas.png'));

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      BeginMode3D(Camera);

        // Draw cube with an applied texture
        DrawCubeTexture(Texture, TVector3.Create(-2.0, 2.0, 0.0), 2.0, 4.0, 2.0, WHITE);
        // Draw cube with an applied texture, but only a defined rectangle piece of the texture
        DrawCubeTextureRec(Texture, TRectangle.Create(0, Texture.Height / 2, Texture.Width / 2, Texture.Height / 2),
          TVector3.Create(2.0, 1.0, 0.0), 2.0, 2.0, 2.0, WHITE);
        DrawGrid(10, 1.0); // Draw a grid

      EndMode3D();

      DrawFPS(10, 10);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(Texture);     // Unload map texture

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;


//------------------------------------------------------------------------------------
// Custom Functions Definition
//------------------------------------------------------------------------------------
// Draw cube textured
// NOTE: Cube position is the center position
procedure DrawCubeTexture(Texture: TTexture2D; Position: TVector3; Width, Height, Length: Single; Color: TColor);
var
  X, Y, Z: Single;
begin
  X := Position.X;
  Y := Position.Y;
  Z := Position.Z;
  // Set desired texture to be enabled while drawing following vertex data
  rlSetTexture(Texture.Id);
  rlBegin(RL_QUADS);
    rlColor4ub(Color.R, Color.G, Color.B, Color.A);
    // Front Face
    rlNormal3f(0.0, 0.0, 1.0);       // Normal Pointing Towards Viewer
    rlTexCoord2f(0.0, 0.0); rlVertex3f(X - Width / 2, Y - Height / 2, Z + Length / 2);  // Bottom Left Of The Texture and Quad
    rlTexCoord2f(1.0, 0.0); rlVertex3f(X + Width / 2, Y - Height / 2, Z + Length / 2);  // Bottom Right Of The Texture and Quad
    rlTexCoord2f(1.0, 1.0); rlVertex3f(X + Width / 2, Y + Height / 2, Z + Length / 2);  // Top Right Of The Texture and Quad
    rlTexCoord2f(0.0, 1.0); rlVertex3f(X - Width / 2, Y + Height / 2, Z + Length / 2);  // Top Left Of The Texture and Quad
    // Back Face
    rlNormal3f(0.0, 0.0, -1.0);     // Normal Pointing Away From Viewer
    rlTexCoord2f(1.0, 0.0); rlVertex3f(X - Width / 2, Y - Height / 2, Z - Length / 2);  // Bottom Right Of The Texture and Quad
    rlTexCoord2f(1.0, 1.0); rlVertex3f(X - Width / 2, Y + Height / 2, Z - Length / 2);  // Top Right Of The Texture and Quad
    rlTexCoord2f(0.0, 1.0); rlVertex3f(X + Width / 2, Y + Height / 2, Z - Length / 2);  // Top Left Of The Texture and Quad
    rlTexCoord2f(0.0, 0.0); rlVertex3f(X + Width / 2, Y - Height / 2, Z - Length / 2);  // Bottom Left Of The Texture and Quad
    // Top Face
    rlNormal3f(0.0, 1.0, 0.0);       // Normal Pointing Up
    rlTexCoord2f(0.0, 1.0); rlVertex3f(X - Width / 2, Y + Height / 2, Z - Length / 2);  // Top Left Of The Texture and Quad
    rlTexCoord2f(0.0, 0.0); rlVertex3f(X - Width / 2, Y + Height / 2, Z + Length / 2);  // Bottom Left Of The Texture and Quad
    rlTexCoord2f(1.0, 0.0); rlVertex3f(X + Width / 2, Y + Height / 2, Z + Length / 2);  // Bottom Right Of The Texture and Quad
    rlTexCoord2f(1.0, 1.0); rlVertex3f(X + Width / 2, Y + Height / 2, Z - Length / 2);  // Top Right Of The Texture and Quad
    // Bottom Face
    rlNormal3f(0.0, -1.0, 0.0);     // Normal Pointing Down
    rlTexCoord2f(1.0, 1.0); rlVertex3f(X - Width / 2, Y - Height / 2, Z - Length / 2);  // Top Right Of The Texture and Quad
    rlTexCoord2f(0.0, 1.0); rlVertex3f(X + Width / 2, Y - Height / 2, Z - Length / 2);  // Top Left Of The Texture and Quad
    rlTexCoord2f(0.0, 0.0); rlVertex3f(X + Width / 2, Y - Height / 2, Z + Length / 2);  // Bottom Left Of The Texture and Quad
    rlTexCoord2f(1.0, 0.0); rlVertex3f(X - Width / 2, Y - Height / 2, Z + Length / 2);  // Bottom Right Of The Texture and Quad
    // Right face
    rlNormal3f(1.0, 0.0, 0.0);       // Normal Pointing Right
    rlTexCoord2f(1.0, 0.0); rlVertex3f(X + Width / 2, Y - Height / 2, Z - Length / 2);  // Bottom Right Of The Texture and Quad
    rlTexCoord2f(1.0, 1.0); rlVertex3f(X + Width / 2, Y + Height / 2, Z - Length / 2);  // Top Right Of The Texture and Quad
    rlTexCoord2f(0.0, 1.0); rlVertex3f(X + Width / 2, Y + Height / 2, Z + Length / 2);  // Top Left Of The Texture and Quad
    rlTexCoord2f(0.0, 0.0); rlVertex3f(X + Width / 2, Y - Height / 2, Z + Length / 2);  // Bottom Left Of The Texture and Quad
    // Left Face
    rlNormal3f(-1.0, 0.0, 0.0);    // Normal Pointing Left
    rlTexCoord2f(0.0, 0.0); rlVertex3f(X - Width / 2, Y - Height / 2, Z - Length / 2);  // Bottom Left Of The Texture and Quad
    rlTexCoord2f(1.0, 0.0); rlVertex3f(X - Width / 2, Y - Height / 2, Z + Length / 2);  // Bottom Right Of The Texture and Quad
    rlTexCoord2f(1.0, 1.0); rlVertex3f(X - Width / 2, Y + Height / 2, Z + Length / 2);  // Top Right Of The Texture and Quad
    rlTexCoord2f(0.0, 1.0); rlVertex3f(X - Width / 2, Y + Height / 2, Z - Length / 2);  // Top Left Of The Texture and Quad
  rlEnd();
  rlSetTexture(0);
end;
// Draw cube with texture piece applied to all faces
procedure DrawCubeTextureRec(Texture: TTexture2D; Source: TRectangle; Position: TVector3; Width, Height, Length: Single; Color: TColor); // Draw cube with a region of a texture
var
  X, Y, Z: Single;
  TexWidth, TexHeight: Single;
begin
  X := Position.X;
  Y := Position.Y;
  Z := Position.Z;
  TexWidth := Texture.Width;
  TexHeight := Texture.Height;
  // Set desired texture to be enabled while drawing following vertex data
  rlSetTexture(Texture.Id);
  // We calculate the normalized texture coordinates for the desired texture-source-rectangle
  // It means converting from (tex.width, tex.height) coordinates to [0.0f, 1.0f] equivalent
  rlBegin(RL_QUADS);
    rlColor4ub(Color.R, Color.G, Color.B, Color.A);
    // Front face
    rlNormal3f(0.0, 0.0, 1.0);
    rlTexCoord2f(Source.X/TexWidth, (Source.Y + Source.Height)/TexHeight);
    rlVertex3f(X - Width/2, Y - Height/2, z + Length/2);
    rlTexCoord2f((Source.X + Source.Width)/TexWidth, (Source.Y + Source.Height)/TexHeight);
    rlVertex3f(X + Width/2, Y - Height/2, z + Length/2);
    rlTexCoord2f((Source.X + Source.Width)/TexWidth, Source.Y/TexHeight);
    rlVertex3f(X + Width/2, Y + Height/2, z + Length/2);
    rlTexCoord2f(Source.X/TexWidth, Source.Y/TexHeight);
    rlVertex3f(X - Width/2, Y + Height/2, z + Length/2);
    // Back face
    rlNormal3f(0.0, 0.0, - 1.0);
    rlTexCoord2f((Source.X + Source.Width)/TexWidth, (Source.Y + Source.Height)/TexHeight);
    rlVertex3f(X - Width/2, Y - Height/2, z - Length/2);
    rlTexCoord2f((Source.X + Source.Width)/TexWidth, Source.Y/TexHeight);
    rlVertex3f(X - Width/2, Y + Height/2, z - Length/2);
    rlTexCoord2f(Source.X/TexWidth, Source.Y/TexHeight);
    rlVertex3f(X + Width/2, Y + Height/2, z - Length/2);
    rlTexCoord2f(Source.X/TexWidth, (Source.Y + Source.Height)/TexHeight);
    rlVertex3f(X + Width/2, Y - Height/2, z - Length/2);
    // Top face
    rlNormal3f(0.0, 1.0, 0.0);
    rlTexCoord2f(Source.X/TexWidth, Source.Y/TexHeight);
    rlVertex3f(X - Width/2, Y + Height/2, z - Length/2);
    rlTexCoord2f(Source.X/TexWidth, (Source.Y + Source.Height)/TexHeight);
    rlVertex3f(X - Width/2, Y + Height/2, z + Length/2);
    rlTexCoord2f((Source.X + Source.Width)/TexWidth, (Source.Y + Source.Height)/TexHeight);
    rlVertex3f(X + Width/2, Y + Height/2, z + Length/2);
    rlTexCoord2f((Source.X + Source.Width)/TexWidth, Source.Y/TexHeight);
    rlVertex3f(X + Width/2, Y + Height/2, z - Length/2);
    // Bottom face
    rlNormal3f(0.0, - 1.0, 0.0);
    rlTexCoord2f((Source.X + Source.Width)/TexWidth, Source.Y/TexHeight);
    rlVertex3f(X - Width/2, Y - Height/2, z - Length/2);
    rlTexCoord2f(Source.X/TexWidth, Source.Y/TexHeight);
    rlVertex3f(X + Width/2, Y - Height/2, z - Length/2);
    rlTexCoord2f(Source.X/TexWidth, (Source.Y + Source.Height)/TexHeight);
    rlVertex3f(X + Width/2, Y - Height/2, z + Length/2);
    rlTexCoord2f((Source.X + Source.Width)/TexWidth, (Source.Y + Source.Height)/TexHeight);
    rlVertex3f(X - Width/2, Y - Height/2, z + Length/2);
    // Right face
    rlNormal3f(1.0, 0.0, 0.0);
    rlTexCoord2f((Source.X + Source.Width)/TexWidth, (Source.Y + Source.Height)/TexHeight);
    rlVertex3f(X + Width/2, Y - Height/2, z - Length/2);
    rlTexCoord2f((Source.X + Source.Width)/TexWidth, Source.Y/TexHeight);
    rlVertex3f(X + Width/2, Y + Height/2, z - Length/2);
    rlTexCoord2f(Source.X/TexWidth, Source.Y/TexHeight);
    rlVertex3f(X + Width/2, Y + Height/2, z + Length/2);
    rlTexCoord2f(Source.X/TexWidth, (Source.Y + Source.Height)/TexHeight);
    rlVertex3f(X + Width/2, Y - Height/2, z + Length/2);
    // Left face
    rlNormal3f( - 1.0, 0.0, 0.0);
    rlTexCoord2f(Source.X/TexWidth, (Source.Y + Source.Height)/TexHeight);
    rlVertex3f(X - Width/2, Y - Height/2, z - Length/2);
    rlTexCoord2f((Source.X + Source.Width)/TexWidth, (Source.Y + Source.Height)/TexHeight);
    rlVertex3f(X - Width/2, Y - Height/2, z + Length/2);
    rlTexCoord2f((Source.X + Source.Width)/TexWidth, Source.Y/TexHeight);
    rlVertex3f(X - Width/2, Y + Height/2, z + Length/2);
    rlTexCoord2f(Source.X/TexWidth, Source.Y/TexHeight);
    rlVertex3f(X - Width/2, Y + Height/2, z - Length/2);
  rlEnd();
  rlSetTexture(0);
end;
 
end.

