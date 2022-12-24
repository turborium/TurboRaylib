program shapes_easings_ball_anim;

uses
  SysUtils,
  shapes_easings_ball_anim_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
