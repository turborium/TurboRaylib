program core_window_letterbox;

uses
  SysUtils,
  core_window_letterbox_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
