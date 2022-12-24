program shaders_basic_lighting;

uses
  SysUtils,
  shaders_basic_lighting_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
