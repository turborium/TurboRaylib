program shapes_draw_ring;

uses
  SysUtils,
  shapes_draw_ring_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
