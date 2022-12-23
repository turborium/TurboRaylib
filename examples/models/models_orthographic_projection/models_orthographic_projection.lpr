program models_orthographic_projection;

uses
  SysUtils,
  models_orthographic_projection_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
