program textures_srcrec_dstrec;

uses
  SysUtils,
  textures_srcrec_dstrec_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
