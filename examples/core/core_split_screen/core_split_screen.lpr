program core_split_screen;

uses
  SysUtils,
  core_split_screen_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
