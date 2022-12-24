program textures_bunnymark;

uses
  SysUtils,
  textures_bunnymark_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
