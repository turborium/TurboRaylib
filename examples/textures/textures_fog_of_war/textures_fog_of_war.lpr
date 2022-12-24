program textures_fog_of_war;

uses
  SysUtils,
  textures_fog_of_war_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
