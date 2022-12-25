program textures_background_scrolling;

uses
  SysUtils,
  textures_background_scrolling_src;

begin
  try
    {$IFDEF UNIX}
    // Another "greatness" of UNIX, the current directory can be "/" or other trash,
    // when App opened from Finder, etc. This breaks load resources. 10/10.
    SetCurrentDir(ExtractFilePath(ParamStr(0)));
    {$ENDIF} 

    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
