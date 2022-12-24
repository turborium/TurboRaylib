program shaders_postprocessing;

uses
  SysUtils,
  shaders_postprocessing_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
