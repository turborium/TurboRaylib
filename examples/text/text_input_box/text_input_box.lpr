program text_input_box;

uses
  SysUtils,
  text_input_box_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
