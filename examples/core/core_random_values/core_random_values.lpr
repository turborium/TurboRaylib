program core_random_values;

uses
  SysUtils,
  core_random_values_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
