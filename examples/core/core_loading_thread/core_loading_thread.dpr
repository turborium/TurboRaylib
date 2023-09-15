program core_loading_thread;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  raylib in '..\..\..\raylib\raylib.pas',
  raymath in '..\..\..\raylib\raymath.pas',
  rlgl in '..\..\..\raylib\rlgl.pas',
  core_loading_thread_src in 'core_loading_thread_src.pas';

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
