program audio_raw_stream;

uses
  SysUtils,
  audio_raw_stream_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
