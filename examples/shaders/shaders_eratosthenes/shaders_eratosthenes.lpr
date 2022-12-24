program shaders_eratosthenes;

uses
  SysUtils,
  shaders_eratosthenes_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
