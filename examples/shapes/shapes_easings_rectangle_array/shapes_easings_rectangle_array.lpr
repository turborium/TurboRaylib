program shapes_easings_rectangle_array;

uses
  SysUtils,
  shapes_easings_rectangle_array_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
