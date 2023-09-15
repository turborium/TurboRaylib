program shapes_easings_box_anim;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  raylib in '..\..\..\raylib\raylib.pas',
  raymath in '..\..\..\raylib\raymath.pas',
  rlgl in '..\..\..\raylib\rlgl.pas',
  reasings in '..\..\..\raylib\extras\reasings.pas',
  shapes_easings_box_anim_src in 'shapes_easings_box_anim_src.pas';

begin
  try
    // set current directory to exe path
    SetCurrentDir(ExtractFilePath(ParamStr(0)));
	
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
