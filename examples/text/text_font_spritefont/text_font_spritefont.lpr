program text_font_spritefont;

uses
  SysUtils,
  text_font_spritefont_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
