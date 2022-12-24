program textures_image_drawing;

uses
  SysUtils,
  textures_image_drawing_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
