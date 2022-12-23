program audio_module_playing;

uses
  SysUtils,
  audio_module_playing_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
