program models_billboard;

uses
  SysUtils,
  models_billboard_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
