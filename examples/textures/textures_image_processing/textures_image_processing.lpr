program textures_image_processing;

uses
  SysUtils,
  textures_image_processing_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
