program textures_background_scrolling;

uses
  SysUtils,
  textures_background_scrolling_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
