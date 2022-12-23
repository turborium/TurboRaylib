program audio_multichannel_sound;

uses
  SysUtils,
  audio_multichannel_sound_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
