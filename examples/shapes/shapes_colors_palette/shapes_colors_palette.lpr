program shapes_colors_palette;

uses
  SysUtils,
  shapes_colors_palette_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
