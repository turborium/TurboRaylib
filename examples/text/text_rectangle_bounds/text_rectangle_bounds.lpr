program text_rectangle_bounds;

uses
  SysUtils,
  text_rectangle_bounds_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.