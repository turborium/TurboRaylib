(*******************************************************************************************
*
*   raylib [text] example - Codepoints loading
*
*   Example originally created with raylib 4.2, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2022 Ramon Santamaria (@raysan5)
*
********************************************************************************************)
program text_codepoints_loading;

{$IFDEF FPC}{$MODE DELPHIUNICODE}{$ENDIF}
{$APPTYPE CONSOLE}

{$POINTERMATH ON}

{$R *.res}

uses
  SysUtils,
  raylib in '..\..\..\raylib\raylib.pas';

// Text to be displayed, must be UTF-8 (save this code file as UTF-8)
// NOTE: It can contain all the required text for the game,
// this text will be scanned to get all the required codepoints
const Text: string = 'いろはにほへと　ちりぬるを\nわかよたれそ　つねならむ\nうゐのおくやま　けふこえて\nあさきゆめみし　ゑひもせす';

// Remove codepoint duplicates if requested
function CodepointRemoveDuplicates(Codepoints: PInteger; CodepointCount: Integer; CodepointResultCount: PInteger): PInteger;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
procedure Main();
const
  ScreenWidth = 800;
  ScreenHeight = 450;
var
  Score, Hiscore, Lives: Integer;

  CodepointCount: Integer;
  Codepoints: PInteger;
  CodepointsNoDupsCount: Integer;
  CodepointsNoDups: PInteger;
  Font: TFont;
  ShowFontAtlas: Boolean;
  CodepointSize, Codepoint: Integer;
  Ptr: PChar;
begin
  // Initialization
  //---------------------------------------------------------------------------------------------
  SetConfigFlags(FLAG_MSAA_4X_HINT or FLAG_WINDOW_HIGHDPI);
  InitWindow(ScreenWidth, ScreenHeight, UTF8String('raylib [text] example - codepoints loading'));

  // Get codepoints from text
  CodepointCount := 0;
  Codepoints := LoadCodepoints(PAnsiChar(UTF8String(Text)), @CodepointCount);

  // Removed duplicate codepoints to generate smaller font atlas
  CodepointsNoDupsCount := 0;
  CodepointsNoDups := CodepointRemoveDuplicates(Codepoints, CodepointCount, @CodepointsNoDupsCount);
  UnloadCodepoints(Codepoints);

  // Load font containing all the provided codepoint glyphs
  // A texture font atlas is automatically generated
  Font := LoadFontEx(UTF8String('resources/text/DotGothic16-Regular.ttf'), 36, CodepointsNoDups, CodepointsNoDupsCount);

  // Set bilinear scale filter for better font scaling
  SetTextureFilter(Font.Texture, TEXTURE_FILTER_BILINEAR);

  // Free codepoints, atlas has already been generated
  FreeMem(CodepointsNoDups);

  ShowFontAtlas := False;

  CodepointSize := 0;
  Codepoint := 0;
  Ptr := Text;

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //---------------------------------------------------------------------------------------------

  // Main game loop
  while not WindowShouldClose() do // Detect window close button or ESC key
  begin
    // Update
    //-------------------------------------------------------------------------------------------
    if IsKeyPressed(KEY_SPACE) then
      ShowFontAtlas :=  not ShowFontAtlas;

    // Testing code: getting next and previous codepoints on provided text
    if IsKeyPressed(KEY_RIGHT) then
    begin
      // Get next codepoint in string and move pointer
      Codepoint := GetCodepointNext(Ptr, &codepointSize);
      ptr += codepointSize;
    end
    else if (IsKeyPressed(KEY_LEFT))
    {
        // Get previous codepoint in string and move pointer
        codepoint = GetCodepointPrevious(ptr, &codepointSize);
        ptr -= codepointSize;
    }
    //-------------------------------------------------------------------------------------------

    // Draw
    //-------------------------------------------------------------------------------------------
    BeginDrawing();

      ClearBackground(RAYWHITE);

      DrawText(TextFormat(UTF8String('Score: %08i'), Score), 200, 80, 20, RED);

      DrawText(TextFormat(UTF8String('HiScore: %08i'), Hiscore), 200, 120, 20, GREEN);

      DrawText(TextFormat(UTF8String('Lives: %02i'), Lives), 200, 160, 40, BLUE);

      DrawText(TextFormat(UTF8String('Elapsed Time: %02.02f ms'), Single(GetFrameTime() * 1000)), 200, 220, 20, BLACK);

    EndDrawing();
    //-------------------------------------------------------------------------------------------
  end;

  // De-Initialization
  //---------------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //---------------------------------------------------------------------------------------------
end;

// Remove codepoint duplicates if requested
function CodepointRemoveDuplicates(Codepoints: PInteger; CodepointCount: Integer; CodepointResultCount: PInteger): PInteger;
var
  CodepointsNoDupsCount: Integer;
  I, J, K: Integer;
begin
  CodepointsNoDupsCount := CodepointCount;
  Result := AllocMem(CodepointCount * SizeOf(Integer));
  Move(Codepoints, Result, CodepointCount * SizeOf(Integer));

  // Remove duplicates
  for I := 0 to CodepointsNoDupsCount - 1 do
  begin
    J := I + 1;
    while J < CodepointsNoDupsCount do
    begin
      if Result[I] = Result[J] then
      begin
        for K := j to CodepointsNoDupsCount - 1 do
          Result[K] := Result[K + 1];

        Dec(CodepointsNoDupsCount);
        Dec(J);
      end;
      Inc(J);
    end;
  end;

  // NOTE: The size of codepointsNoDups is the same as original array but
  // only required positions are filled (codepointsNoDupsCount)

  CodepointResultCount^ := CodepointsNoDupsCount;
end;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

