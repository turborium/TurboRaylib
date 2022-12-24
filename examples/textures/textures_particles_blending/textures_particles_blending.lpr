program textures_particles_blending;

uses
  SysUtils,
  textures_particles_blending_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
