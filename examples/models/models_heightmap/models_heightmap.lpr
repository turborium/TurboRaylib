program models_heightmap;

uses
  SysUtils,
  models_heightmap_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
