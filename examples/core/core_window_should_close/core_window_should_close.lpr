program core_window_should_close;

uses
  SysUtils,
  core_window_should_close_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
