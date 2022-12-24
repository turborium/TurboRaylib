program shapes_following_eyes;

uses
  SysUtils,
  shapes_following_eyes_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
