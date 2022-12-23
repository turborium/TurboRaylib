program core_input_keys;

uses
  SysUtils,
  core_input_keys_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
