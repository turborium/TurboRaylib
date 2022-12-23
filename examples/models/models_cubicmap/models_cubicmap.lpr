program models_cubicmap;

uses
  SysUtils,
  models_cubicmap_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
