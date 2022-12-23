program core_2d_camera_mouse_zoom;

uses
  SysUtils,
  core_2d_camera_mouse_zoom_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
