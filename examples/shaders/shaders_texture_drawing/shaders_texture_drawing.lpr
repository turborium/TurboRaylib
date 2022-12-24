program shaders_texture_drawing;

uses
  SysUtils,
  shaders_texture_drawing_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
