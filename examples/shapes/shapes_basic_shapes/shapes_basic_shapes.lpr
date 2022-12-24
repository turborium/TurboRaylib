program shapes_basic_shapes;

uses
  SysUtils,
  shapes_basic_shapes_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
