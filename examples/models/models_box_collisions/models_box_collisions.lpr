program models_box_collisions;

uses
  SysUtils,
  models_box_collisions_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
