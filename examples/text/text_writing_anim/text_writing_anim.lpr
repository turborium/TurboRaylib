program text_writing_anim;

uses
  SysUtils,
  text_writing_anim_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
