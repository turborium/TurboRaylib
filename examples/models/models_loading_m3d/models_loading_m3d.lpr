program models_loading_m3d;

uses
  SysUtils,
  models_loading_m3d_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
