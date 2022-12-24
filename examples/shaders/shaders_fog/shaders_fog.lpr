program shaders_fog;

uses
  SysUtils,
  shaders_fog_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
