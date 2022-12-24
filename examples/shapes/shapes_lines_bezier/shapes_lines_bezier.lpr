program shapes_lines_bezier;

uses
  SysUtils,
  shapes_lines_bezier_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
