program audio_raw_stream;

uses
  SysUtils,
  audio_raw_stream_src;

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
