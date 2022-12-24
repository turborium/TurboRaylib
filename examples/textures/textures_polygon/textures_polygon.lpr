program textures_polygon;

uses
  SysUtils,
  textures_polygon_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
