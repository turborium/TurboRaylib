program core_3d_camera_mode;

uses
  SysUtils,
  core_3d_camera_mode_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.