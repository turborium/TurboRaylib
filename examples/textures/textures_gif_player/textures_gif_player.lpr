program textures_gif_player;

uses
  SysUtils,
  textures_gif_player_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
