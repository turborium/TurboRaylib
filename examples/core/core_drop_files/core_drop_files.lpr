program core_drop_files;

uses
  SysUtils,
  core_drop_files_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
