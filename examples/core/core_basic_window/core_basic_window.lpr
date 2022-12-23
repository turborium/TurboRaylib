program core_basic_window;

uses
  SysUtils,
  core_basic_window_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
