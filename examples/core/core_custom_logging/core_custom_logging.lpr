program core_custom_logging;

uses
  SysUtils,
  core_custom_logging_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
