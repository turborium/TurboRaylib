program textures_sprite_anim;

uses
  SysUtils,
  textures_sprite_anim_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
