program core_2d_camera_platformer;

uses
  SysUtils,
  core_2d_camera_platformer_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
