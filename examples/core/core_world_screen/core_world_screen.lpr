program core_world_screen;

uses
  SysUtils,
  core_world_screen_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
