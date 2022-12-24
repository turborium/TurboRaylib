program shapes_logo_raylib;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  raylib in '..\..\..\raylib\raylib.pas',
  raymath in '..\..\..\raylib\raymath.pas',
  rlgl in '..\..\..\raylib\rlgl.pas',
  shapes_logo_raylib_src in 'shapes_logo_raylib_src.pas';

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
