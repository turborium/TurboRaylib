program core_world_screen;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  raylib in '..\..\..\raylib\raylib.pas',
  raymath in '..\..\..\raylib\raymath.pas',
  rlgl in '..\..\..\raylib\rlgl.pas',
  core_world_screen_src in 'core_world_screen_src.pas';

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
