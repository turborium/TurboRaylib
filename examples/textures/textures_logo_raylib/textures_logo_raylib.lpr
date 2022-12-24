program textures_logo_raylib;

uses
  SysUtils,
  textures_logo_raylib_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
