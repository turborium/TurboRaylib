program models_geometric_shapes;

uses
  SysUtils,
  models_geometric_shapes_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
