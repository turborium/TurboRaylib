program core_input_mouse_wheel;

uses
  SysUtils,
  core_input_mouse_wheel_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
