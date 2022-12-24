program text_font_filters;

uses
  SysUtils,
  text_font_filters_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
