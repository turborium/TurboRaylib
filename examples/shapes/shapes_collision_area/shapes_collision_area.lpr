program shapes_collision_area;

uses
  SysUtils,
  shapes_collision_area_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
