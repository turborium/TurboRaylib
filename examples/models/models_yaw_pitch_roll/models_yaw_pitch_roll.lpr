program models_yaw_pitch_roll;

uses
  SysUtils,
  models_yaw_pitch_roll_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
