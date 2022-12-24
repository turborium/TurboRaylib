program textures_sprite_explosion;

uses
  SysUtils,
  textures_sprite_explosion_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
