program shaders_mesh_instancing;

uses
  SysUtils,
  shaders_mesh_instancing_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
