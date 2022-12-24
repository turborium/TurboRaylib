program text_format_text;

uses
  SysUtils,
  text_format_text_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
