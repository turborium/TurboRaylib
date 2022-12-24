program textures_raw_data;

uses
  SysUtils,
  textures_raw_data_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
