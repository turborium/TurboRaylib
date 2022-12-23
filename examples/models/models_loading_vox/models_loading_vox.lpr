program models_loading_vox;

uses
  SysUtils,
  models_loading_vox_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
