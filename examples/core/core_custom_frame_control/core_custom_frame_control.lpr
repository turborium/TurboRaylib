program core_custom_frame_control;

uses
  SysUtils,
  core_custom_frame_control_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
