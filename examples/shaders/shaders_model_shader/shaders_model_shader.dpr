program shaders_model_shader;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  raylib in '..\..\..\raylib\raylib.pas',
  raymath in '..\..\..\raylib\raymath.pas',
  rlgl in '..\..\..\raylib\rlgl.pas',
  shaders_model_shader_src in 'shaders_model_shader_src.pas';

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
