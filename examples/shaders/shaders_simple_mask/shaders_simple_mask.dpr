program shaders_simple_mask;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  raylib in '..\..\..\raylib\raylib.pas',
  raymath in '..\..\..\raylib\raymath.pas',
  rlgl in '..\..\..\raylib\rlgl.pas',
  shaders_simple_mask_src in 'shaders_simple_mask_src.pas';

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
