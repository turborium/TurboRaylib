program models_mesh_picking;

uses
  SysUtils,
  models_mesh_picking_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
