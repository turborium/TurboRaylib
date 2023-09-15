program core_3d_camera_mode;

uses
  SysUtils,
  core_3d_camera_mode_src;

begin
  try
    // set current directory to exe path
    SetCurrentDir(ExtractFilePath(ParamStr(0))); 

    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
