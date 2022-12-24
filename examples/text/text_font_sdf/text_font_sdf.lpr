program text_font_sdf;

uses
  SysUtils,
  text_font_sdf_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
