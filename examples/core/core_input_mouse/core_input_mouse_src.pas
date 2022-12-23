unit core_input_mouse_src;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  BallPosition: TVector2;
  BallColor: TColor;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_WINDOW_HIGHDPI or FLAG_MSAA_4X_HINT);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [core] example - mouse input'));

  BallPosition := TVector2.Create(100.0, 100.0);
  BallColor := DARKBLUE;

  SetTargetFPS(60);                 // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do  // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    BallPosition := GetMousePosition();

    if IsMouseButtonPressed(MOUSE_BUTTON_LEFT) then
      BallColor := MAROON
    else if IsMouseButtonPressed(MOUSE_BUTTON_MIDDLE) then
      BallColor := LIME
    else if IsMouseButtonPressed(MOUSE_BUTTON_RIGHT) then
      BallColor := DARKBLUE
    else if IsMouseButtonPressed(MOUSE_BUTTON_SIDE) then
      BallColor := PURPLE
    else if IsMouseButtonPressed(MOUSE_BUTTON_EXTRA) then
      BallColor := YELLOW
    else if IsMouseButtonPressed(MOUSE_BUTTON_FORWARD) then
      BallColor := ORANGE
    else if IsMouseButtonPressed(MOUSE_BUTTON_BACK) then
      BallColor := BEIGE;
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawCircleV(BallPosition, 40, BallColor);

      DrawText(UTF8String('move ball with mouse and click mouse button to change color'), 10, 10, 20, DARKGRAY);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow();        // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;
 
end.
