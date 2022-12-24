program shaders_custom_uniform;

uses
  SysUtils,
  shaders_custom_uniform_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
