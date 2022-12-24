program shaders_julia_set;

uses
  SysUtils,
  shaders_julia_set_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
