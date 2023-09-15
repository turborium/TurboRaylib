program models_draw_cube_texture;

uses
  SysUtils,
  models_draw_cube_texture_src;

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
