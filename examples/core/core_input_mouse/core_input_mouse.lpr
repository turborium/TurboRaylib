program core_input_mouse;

uses
  SysUtils,
  core_input_mouse_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
