program textures_sprite_button;

uses
  SysUtils,
  textures_sprite_button_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
