program textures_blend_modes;

uses
  SysUtils,
  textures_blend_modes_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
