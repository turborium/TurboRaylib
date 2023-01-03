// ----------------------------------------------------------------------------
// %ProjectName% - TurboRaylib project
//
// TurboRaylib is a cool and clean Raylib bindings for Object Pascal
// See: https://github.com/turborium/TurboRaylib/ 
//
// Raylib is a programming library to enjoy videogames programming,
// no fancy interface, no visual helpers, no debug button... 
// just coding in the most pure spartan-programmers way. 
// See: https://www.raylib.com/
// ----------------------------------------------------------------------------

unit %MainUnitName%;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$CODEPAGE UTF8}{$ENDIF}

interface

procedure Main();

implementation

uses
  SysUtils,
  raylib;

const
  ScreenWidth = 800;
  ScreenHeight = 600;
  
// Program main entry point
procedure Main();
begin
  // Initialization
  SetConfigFlags(FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('%ProjectName%'));
  SetTargetFPS(60); // Set 60 frames-per-second

  // Main loop
  while not WindowShouldClose() do
  begin
    // Update
    // TODO: Update your variables here

    // Draw
    BeginDrawing();
      ClearBackground(RAYWHITE);
      DrawText(UTF8String('Congrats! You created TurboRaylib app!'), 190, 250, 20, LIGHTGRAY);
    EndDrawing();
  end;

  // De-Initialization
  CloseWindow();
end;
 
end.