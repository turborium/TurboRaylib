program textures_npatch_drawing;

uses
  SysUtils,
  textures_npatch_drawing_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
