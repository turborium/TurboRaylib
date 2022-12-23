program core_smooth_pixelperfect;

uses
  SysUtils,
  core_smooth_pixelperfect_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
