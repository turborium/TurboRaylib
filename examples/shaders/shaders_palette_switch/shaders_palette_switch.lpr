program shaders_palette_switch;

uses
  SysUtils,
  shaders_palette_switch_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
