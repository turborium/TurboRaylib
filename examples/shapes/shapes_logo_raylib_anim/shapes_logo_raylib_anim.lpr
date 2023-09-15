program shapes_logo_raylib_anim;

uses
  SysUtils,
  shapes_logo_raylib_anim_src;

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
