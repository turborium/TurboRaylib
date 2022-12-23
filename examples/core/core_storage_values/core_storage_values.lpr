program core_storage_values;

uses
  SysUtils,
  core_storage_values_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
