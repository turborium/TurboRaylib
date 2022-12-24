program shapes_logo_raylib;

uses
  SysUtils,
  shapes_logo_raylib_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
