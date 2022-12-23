program audio_music_stream;

uses
  SysUtils,
  audio_music_stream_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
