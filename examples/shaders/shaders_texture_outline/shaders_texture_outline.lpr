program shaders_texture_outline;

uses
  SysUtils,
  shaders_texture_outline_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
