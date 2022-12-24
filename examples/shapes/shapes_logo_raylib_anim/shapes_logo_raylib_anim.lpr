program shapes_logo_raylib_anim;

uses
  SysUtils,
  shapes_logo_raylib_anim_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
