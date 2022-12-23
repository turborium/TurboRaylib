program audio_sound_loading;

uses
  SysUtils,
  audio_sound_loading_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
