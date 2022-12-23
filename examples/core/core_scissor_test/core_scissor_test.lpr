program core_scissor_test;

uses
  SysUtils,
  core_scissor_test_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
