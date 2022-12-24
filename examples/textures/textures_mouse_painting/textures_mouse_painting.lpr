program textures_mouse_painting;

uses
  SysUtils,
  textures_mouse_painting_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
