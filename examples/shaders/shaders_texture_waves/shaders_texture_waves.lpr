program shaders_texture_waves;

uses
  SysUtils,
  shaders_texture_waves_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
