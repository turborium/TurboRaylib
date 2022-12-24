program shaders_model_shader;

uses
  SysUtils,
  shaders_model_shader_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
