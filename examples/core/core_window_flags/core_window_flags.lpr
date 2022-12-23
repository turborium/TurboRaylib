program core_window_flags;

uses
  SysUtils,
  core_window_flags_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
