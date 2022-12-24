program shaders_shapes_textures;

uses
  SysUtils,
  shaders_shapes_textures_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
