program shapes_top_down_lights;

uses
  SysUtils,
  shapes_top_down_lights_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
