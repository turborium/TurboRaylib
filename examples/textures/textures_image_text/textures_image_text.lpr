program textures_image_text;

uses
  SysUtils,
  textures_image_text_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
