program models_first_person_maze;

uses
  SysUtils,
  models_first_person_maze_src;

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
