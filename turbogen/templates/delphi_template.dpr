program %ProjectName%;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  raylib in 'raylib\raylib.pas',
  raymath in 'raylib\raymath.pas',
  rlgl in 'raylib\rlgl.pas',
  %MainUnitName% in '%MainUnitName%.pas';

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
