program models_waving_cubes;

uses
  SysUtils,
  models_waving_cubes_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
