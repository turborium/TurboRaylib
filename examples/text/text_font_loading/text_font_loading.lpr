program text_font_loading;

uses
  SysUtils,
  text_font_loading_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
