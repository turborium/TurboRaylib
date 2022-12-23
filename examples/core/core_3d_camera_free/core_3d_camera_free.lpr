program core_3d_camera_free;

uses
  SysUtils,
  core_3d_camera_free_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
