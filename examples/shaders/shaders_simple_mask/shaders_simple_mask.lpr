program shaders_simple_mask;

uses
  SysUtils,
  shaders_simple_mask_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
