(*******************************************************************************************
*
*   raylib [textures] example - N-patch drawing
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   Example contributed by Jorge A. Gomes (@overdev) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2018-2022 Jorge A. Gomes (@overdev) and Ramon Santamaria (@raysan5)
*   Copyright (c) 2022-2023 Peter Turborium (@turborium)
*
********************************************************************************************)
unit textures_npatch_drawing_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

{$POINTERMATH ON}

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
var
  NPatchTexture: TTexture2D;
  MousePosition, Origin: TVector2;
  DstRec1, DstRec2, DstRecH, DstRecV: TRectangle;
  NinePatchInfo1, NinePatchInfo2, H3PatchInfo, V3PatchInfo: TNPatchInfo;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [textures] example - N-patch drawing'));

  // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
  NPatchTexture := LoadTexture(UTF8String('resources/textures/ninepatch_button.png'));

  MousePosition := Default(TVector2);
  Origin := TVector2.Create(0, 0);

  // Position and size of the n-patches
  DstRec1 := TRectangle.Create(480.0, 160.0, 32.0, 32.0);
  DstRec2 := TRectangle.Create(160.0, 160.0, 32.0, 32.0);
  DstRecH := TRectangle.Create(160.0, 93.0, 32.0, 32.0);
  DstRecV := TRectangle.Create(92.0, 160.0, 32.0, 32.0);

  // A 9-patch (NPATCH_NINE_PATCH) changes its sizes in both axis
  NinePatchInfo1 := TNPatchInfo.Create(
    TRectangle.Create(0.0, 0.0, 64.0, 64.0),
    12, 40, 12, 12,
    NPATCH_NINE_PATCH
  );
  NinePatchInfo2 := TNPatchInfo.Create(
    TRectangle.Create(0.0, 128.0, 64.0, 64.0),
    16, 16, 16, 16,
    NPATCH_NINE_PATCH
  );
  // A horizontal 3-patch (NPATCH_THREE_PATCH_HORIZONTAL) changes its sizes along the x axis only
  H3PatchInfo := TNPatchInfo.Create(
    TRectangle.Create(0.0,  64.0, 64.0, 64.0),
    8, 8, 8, 8,
    NPATCH_THREE_PATCH_HORIZONTAL
  );
  // A vertical 3-patch (NPATCH_THREE_PATCH_VERTICAL) changes its sizes along the y axis only
  V3PatchInfo := TNPatchInfo.Create(
    TRectangle.Create(0.0, 192.0, 64.0, 64.0),
    6, 6, 6, 6,
    NPATCH_THREE_PATCH_VERTICAL
  );

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    MousePosition := GetMousePosition();

    // Resize the n-patches based on mouse position
    DstRec1.Width := MousePosition.X - DstRec1.X;
    DstRec1.Height := MousePosition.Y - DstRec1.Y;
    DstRec2.Width := MousePosition.X - DstRec2.X;
    DstRec2.Height := MousePosition.Y - DstRec2.Y;
    DstRecH.Width := MousePosition.X - DstRecH.X;
    DstRecV.Height := MousePosition.Y - DstRecV.Y;

    // Set a minimum width and/or height
    if DstRec1.Width < 1.0 then DstRec1.Width := 1.0;
    if DstRec1.Width > 300.0 then DstRec1.Width := 300.0;
    if DstRec1.Height < 1.0 then DstRec1.Height := 1.0;
    if DstRec2.Width < 1.0 then DstRec2.Width := 1.0;
    if DstRec2.Width > 300.0 then DstRec2.Width := 300.0;
    if DstRec2.Height < 1.0 then DstRec2.Height := 1.0;
    if DstRecH.Width < 1.0 then DstRecH.Width := 1.0;
    if DstRecV.Height < 1.0 then DstRecV.Height := 1.0;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      // Draw the n-patches
      DrawTextureNPatch(NPatchTexture, NinePatchInfo2, DstRec2, Origin, 0.0, WHITE);
      DrawTextureNPatch(NPatchTexture, NinePatchInfo1, DstRec1, Origin, 0.0, WHITE);
      DrawTextureNPatch(NPatchTexture, H3PatchInfo, DstRecH, Origin, 0.0, WHITE);
      DrawTextureNPatch(NPatchTexture, V3PatchInfo, DstRecV, Origin, 0.0, WHITE);

      // Draw the source texture
      DrawRectangleLines(5, 88, 74, 266, BLUE);
      DrawTexture(nPatchTexture, 10, 93, WHITE);
      DrawText(UTF8String('TEXTURE'), 15, 360, 10, DARKGRAY);

      DrawText(UTF8String('Move the mouse to stretch or shrink the n-patches'), 10, 20, 20, DARKGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  UnloadTexture(NPatchTexture);

  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.

