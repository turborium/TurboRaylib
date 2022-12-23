program core_loading_thread;

uses
  SysUtils,
  core_loading_thread_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
