program shapes_rectangle_scaling;

uses
  SysUtils,
  shapes_rectangle_scaling_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
