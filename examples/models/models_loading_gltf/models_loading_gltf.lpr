program models_loading_gltf;

uses
  SysUtils,
  models_loading_gltf_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
