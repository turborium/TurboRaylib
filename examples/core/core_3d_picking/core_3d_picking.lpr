program core_3d_picking;

uses
  SysUtils,
  core_3d_picking_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
