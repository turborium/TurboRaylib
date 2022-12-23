program core_3d_camera_first_person;

uses
  SysUtils,
  core_3d_camera_first_person_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
