program models_rlgl_solar_system;

uses
  SysUtils,
  models_rlgl_solar_system_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
