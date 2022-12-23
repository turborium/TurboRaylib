program models_mesh_generation;

uses
  SysUtils,
  models_mesh_generation_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
