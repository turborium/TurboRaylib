program shaders_raymarching;

uses
  SysUtils,
  shaders_raymarching_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
