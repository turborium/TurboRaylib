program textures_image_loading;

uses
  SysUtils,
  textures_image_loading_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
