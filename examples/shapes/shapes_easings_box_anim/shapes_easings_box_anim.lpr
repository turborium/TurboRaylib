program shapes_easings_box_anim;

uses
  SysUtils,
  shapes_easings_box_anim_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
