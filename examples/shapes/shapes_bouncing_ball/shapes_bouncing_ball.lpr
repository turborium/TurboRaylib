program shapes_bouncing_ball;

uses
  SysUtils,
  shapes_bouncing_ball_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
