program textures_draw_tiled;

uses
  SysUtils,
  textures_draw_tiled_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
