program textures_to_image;

uses
  SysUtils,
  textures_to_image_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
