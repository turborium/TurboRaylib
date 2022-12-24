program text_raylib_fonts;

uses
  SysUtils,
  text_raylib_fonts_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
