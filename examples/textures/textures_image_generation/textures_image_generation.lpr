program textures_image_generation;

uses
  SysUtils,
  textures_image_generation_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
