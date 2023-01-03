// ------------------------------------------------------------------------------------------------------------------
//  ▄████▄▓██   ██▓ ▄▄▄▄   ▓█████  ██▀███   ██▓███    ██████▓██   ██▓ ▄████▄   ██░ ██  ▒█████    ██████  ██▓  ██████
// ▒██▀ ▀█ ▒██  ██▒▓█████▄ ▓█   ▀ ▓██ ▒ ██▒▓██░  ██▒▒██    ▒ ▒██  ██▒▒██▀ ▀█  ▓██░ ██▒▒██▒  ██▒▒██    ▒ ▓██▒▒██    ▒
// ▒▓█    ▄ ▒██ ██░▒██▒ ▄██▒███   ▓██ ░▄█ ▒▓██░ ██▓▒░ ▓██▄    ▒██ ██░▒▓█    ▄ ▒██▀▀██░▒██░  ██▒░ ▓██▄   ▒██▒░ ▓██▄
// ▒▓▓▄ ▄██▒░ ▐██▓░▒██░█▀  ▒▓█  ▄ ▒██▀▀█▄  ▒██▄█▓▒ ▒  ▒   ██▒ ░ ▐██▓░▒▓▓▄ ▄██▒░▓█ ░██ ▒██   ██░  ▒   ██▒░██░  ▒   ██▒
// ▒ ▓███▀ ░░ ██▒▓░░▓█  ▀█▓░▒████▒░██▓ ▒██▒▒██▒ ░  ░▒██████▒▒ ░ ██▒▓░▒ ▓███▀ ░░▓█▒░██▓░ ████▓▒░▒██████▒▒░██░▒██████▒▒
// ░ ░▒ ▒  ░ ██▒▒▒ ░▒▓███▀▒░░ ▒░ ░░ ▒▓ ░▒▓░▒▓▒░ ░  ░▒ ▒▓▒ ▒ ░  ██▒▒▒ ░ ░▒ ▒  ░ ▒ ░░▒░▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░░▓  ▒ ▒▓▒ ▒ ░
//   ░  ▒  ▓██ ░▒░ ▒░▒   ░  ░ ░  ░  ░▒ ░ ▒░░▒ ░     ░ ░▒  ░ ░▓██ ░▒░   ░  ▒    ▒ ░▒░ ░  ░ ▒ ▒░ ░ ░▒  ░ ░ ▒ ░░ ░▒  ░ ░
// ░       ▒ ▒ ░░   ░    ░    ░     ░░   ░ ░░       ░  ░  ░  ▒ ▒ ░░  ░         ░  ░░ ░░ ░ ░ ▒  ░  ░  ░   ▒ ░░  ░  ░
// ░ ░     ░ ░      ░         ░  ░   ░                    ░  ░ ░     ░ ░       ░  ░  ░    ░ ░        ░   ░        ░
// ░       ░ ░           ░                                   ░ ░     ░
// ------------------------------------------------------------------------------------------------------------------
//    _  __ ________       _  __ ______     _ ________         _  __ ________________
//   _  __ ____  __/___  ___________  /__________  __ \_____ _____  ____  /__(_)__  /_
//       _  __  /  _  / / /_  ___/_  __ \  __ \_  /_/ /  __ `/_  / / /_  /__  /__  __ \
//       _  _  /   / /_/ /_  /   _  /_/ / /_/ /  _, _// /_/ /_  /_/ /_  / _  / _  /_/ /
//          /_/    \__,_/ /_/    /_.___/\____//_/ |_| \__,_/ _\__, / /_/  /_/  /_.___/
//                                                           /____/
//
//  TurboRaylib - Delphi and FreePascal headers for Raylib 4.2.
//  Raylib - A simple and easy-to-use library to enjoy videogames programming (www.raylib.com)
//
//  Download compilled Raylib 4.2 library: https://github.com/raysan5/raylib/releases/tag/4.2.0
//
//  Copyright (c) 2022-2023 Turborium (https://github.com/turborium/TurboRaylib)
// -------------------------------------------------------------------------------------------------------------------
unit projectgen;

{$MODE DELPHIUNICODE}{$CODEPAGE UTF8}
{$SCOPEDENUMS ON}

interface

uses
  Classes, SysUtils, FileUtil, StrUtils, LazFileUtils, dialogs;

type
  TIde = (Delphi, Lazarus);
  TIdeSet = set of TIde;
  TOs = (Windows32, Windows64, Linux, Osx);
  TOsSet = set of TOs;

  { TProjectGenerator }

  TProjectGenerator = class sealed
  private
    FIdeSet: TIdeSet;
    FMainUnitName: string;
    FOsSet: TOsSet;
    FOutputPath: string;
    FProjectName: string;
    FProjectPath: string;
    FTurboRaylibPath: string;
    function CalcExePath(): string;
    function CalcExeName(): string;
    procedure CopyBin(SrcName, DstName: string; Dir: string='');
    procedure CopyRaylibBindings();
    procedure CopyDlls();
    function GetAbsoluteExePath(): string;
    procedure MakeDelphiProject();
    procedure MakeLazarusProject();
    function MakeMainUnitFile(): Boolean;
    procedure MakeSourceFile(SrcName, DstName: string);
    procedure Validate();
  public const
    DefaultProjectName = 'Project';
    DefaultMainUnitName = 'ProjectMain';
  public
    class function ValidateProjectName(ProjectName: string): Boolean;
    class function ValidateMainUnitName(UnitName: string): Boolean;
    class function ValidateOutputPath(OutputPath: string): Boolean;

    property TurboRaylibPath: string read FTurboRaylibPath;
    property ProjectPath: string read FProjectPath write FProjectPath;
    property ProjectName: string read FProjectName write FProjectName;
    property MainUnitName: string read FMainUnitName write FMainUnitName;
    property OutputPath: string read FOutputPath write FOutputPath;
    property IdeSet: TIdeSet read FIdeSet write FIdeSet;
    property OsSet: TOsSet read FOsSet write FOsSet;
    property AbsoluteExePath: string read GetAbsoluteExePath;

    constructor Create();
    destructor Destroy(); override;

    function Make(): Boolean;
  end;

implementation

uses
  LazLogger;

const
  PascalWords: array of string = ['and', 'array', 'as', 'asm', 'begin', 'case', 'class', 'const', 'constructor',
    'destructor', 'dispinterface', 'div', 'do', 'downto', 'else', 'end', 'except', 'exports', 'file', 'finalization',
    'finally', 'for', 'function', 'goto', 'if', 'implementation', 'in', 'inherited', 'initialization', 'inline',
    'interface', 'is', 'label', 'library', 'mod', 'nil', 'not', 'object', 'of', 'or', 'out', 'packed', 'procedure',
    'program', 'property', 'raise', 'record', 'repeat', 'resourcestring', 'set', 'shl', 'shr', 'string', 'then',
    'threadvar', 'to', 'try', 'type', 'unit', 'until', 'uses', 'var', 'while', 'with', 'xor'];

  InvalidFileNameChars: array of string = ['<', '>', ':', '|', '?', '*'];

function UniDelim(S: string): string;
begin
  Result := StringReplace(S, '\', '/', [rfReplaceAll]);
end;

{ TProjectGenerator }

constructor TProjectGenerator.Create();
begin
  inherited;
  FProjectName := DefaultProjectName;
  FMainUnitName := DefaultMainUnitName;
  FOutputPath := '';
end;

destructor TProjectGenerator.Destroy();
begin
  inherited;
end;

class function TProjectGenerator.ValidateProjectName(ProjectName: string): Boolean;
var
  Word: string;
begin
  Result := IsValidIdent(ProjectName);

  for Word in PascalWords do
    if Word = LowerCase(ProjectName) then
    begin
      Result := False;
      break;
    end;
end;

class function TProjectGenerator.ValidateMainUnitName(UnitName: string): Boolean;
var
  Word: string;
begin
  Result := IsValidIdent(UnitName);

  for Word in PascalWords do
    if Word = LowerCase(UnitName) then
    begin
      Result := False;
      break;
    end;
end;

class function TProjectGenerator.ValidateOutputPath(OutputPath: string): Boolean;
begin
  Result := not MatchText(OutputPath, InvalidFileNameChars);
end;

procedure TProjectGenerator.CopyBin(SrcName, DstName: string; Dir: string = '');
var
  SrcFileName, DstFileName, DstFilePath: string;
begin
  // make absolute path/name
  DstFileName := TrimFilename(ConcatPaths([ProjectPath, Dir, DstName]));
  DstFilePath := ExtractFilePath(DstFileName);
  // make dir if need
  if not DirectoryExists(DstFilePath) then
    if not ForceDirectories(DstFilePath) then
      raise Exception.Create('Create "' + DstFilePath + '" dir error!');
  // copy file
  SrcFileName := ConcatPaths([TurboRaylibPath, SrcName]);
  DstFileName := DstFileName;
  if not CopyFile(SrcFileName, DstFileName) then
    raise Exception.Create('Сopying "' + SrcFileName + '" to "' + DstFileName + '" error!');
end;

function TProjectGenerator.CalcExePath(): string;
begin
  Result := TrimFilename(OutputPath);
  if Trim(Result) = '' then
    Result := '.';
  Result := UniDelim(IncludeTrailingBackslash(Result));
end;

function TProjectGenerator.CalcExeName(): string;
var
  Path: string;
begin
  Path := CalcExePath();
  if Trim(Path) = './' then
    Result := ProjectName
  else
    Result := UniDelim(ConcatPaths([Path, ProjectName]));
end;

procedure TProjectGenerator.CopyRaylibBindings();
begin
  // pas files
  CopyBin('/raylib/raylib.pas', '/raylib/raylib.pas');
  CopyBin('/raylib/raymath.pas', '/raylib/raymath.pas');
  CopyBin('/raylib/rlgl.pas', '/raylib/rlgl.pas');
  CopyBin('/raylib/extras/reasings.pas', '/raylib/extras/reasings.pas');

  // readme
  CopyBin('/raylib/Readme.md', '/raylib/Readme.md');

  // raylib.inc
  CopyBin('/turbogen/templates/raylib.inc', '/raylib/raylib.inc');
end;

procedure TProjectGenerator.CopyDlls();
begin
  if TOs.Windows32 in OsSet then
  begin
    CopyBin('binaries/win32/raylib.dll', 'raylib32.dll', OutputPath);
  end;
  if TOs.Windows64 in OsSet then
  begin
    CopyBin('binaries/win64/raylib.dll', 'raylib64.dll', OutputPath);
  end;
  if TOs.Osx in OsSet then
  begin
    CopyBin('binaries/darwin/libraylib.4.2.0.dylib', 'libraylib.4.2.0.dylib', OutputPath);
    CopyBin('binaries/darwin/libraylib.420.dylib', 'libraylib.420.dylib', OutputPath);
    CopyBin('binaries/darwin/libraylib.dylib', 'libraylib.dylib', OutputPath);
  end;
  if TOs.Linux in OsSet then
  begin
    CopyBin('binaries/linux/libraylib.so', 'libraylib.so', OutputPath);
    CopyBin('binaries/linux/libraylib.so.4.2.0', 'libraylib.so.4.2.0', OutputPath);
    CopyBin('binaries/linux/libraylib.so.420', 'libraylib.so.420', OutputPath);
  end;
end;

function TProjectGenerator.GetAbsoluteExePath(): string;
begin
  Result := TrimFilename(ConcatPaths([FProjectPath, FOutputPath]));
end;

procedure TProjectGenerator.MakeSourceFile(SrcName, DstName: string);
var
  Lines: TStringList;
  Text, SrcFileName, DstFileName: string;
begin
  SrcFileName := ConcatPaths([TurboRaylibPath, SrcName]);
  DstFileName := ConcatPaths([ProjectPath, DstName]);

  Lines := TStringList.Create();
  try
    Lines.LoadFromFile(SrcFileName);
    Text := Lines.Text;

    // -------------------------------------------------------------------------
    Text := StringReplace(Text, '%ProjectName%', ProjectName, [rfReplaceAll]);
    Text := StringReplace(Text, '%MainUnitName%', MainUnitName, [rfReplaceAll]);
    Text := StringReplace(Text, '%OutputPath%', CalcExePath(), [rfReplaceAll]);
    Text := StringReplace(Text, '%ExeName%', CalcExeName(), [rfReplaceAll]);
    // -------------------------------------------------------------------------

    Lines.Text := Text;
    Lines.LineBreak := #13#10;
    Lines.SaveToFile(DstFileName, TEncoding.UTF8);
  finally
    Lines.Free();
  end;
end;

function TProjectGenerator.MakeMainUnitFile(): Boolean;
begin
  if FileExists(ConcatPaths([ProjectPath, MainUnitName + '.pas'])) then
    exit(True);
  MakeSourceFile('/turbogen/templates/main_unit_template.pas', MainUnitName + '.pas');
  Result := False;
end;

procedure TProjectGenerator.MakeLazarusProject();
begin
  MakeSourceFile('/turbogen/templates/lazarus_template.lpr', ProjectName + '.lpr');
  MakeSourceFile('/turbogen/templates/lazarus_template.lpi', ProjectName + '.lpi');
end;

procedure TProjectGenerator.MakeDelphiProject();
begin
  MakeSourceFile('/turbogen/templates/delphi_template.dpr', ProjectName + '.dpr');
  MakeSourceFile('/turbogen/templates/delphi_template.dproj', ProjectName + '.dproj');
end;

procedure TProjectGenerator.Validate();
begin
  if not ValidateProjectName(ProjectName) then
    raise Exception.Create('Invalid ProjectName "' + ProjectName + '"!');

  if not ValidateMainUnitName(MainUnitName) then
    raise Exception.Create('Invalid MainUnitName "' + MainUnitName + '"!');

  if MainUnitName = ProjectName then
    raise Exception.Create('ProjectName "' + ProjectName + '" and MainUnitName "' + MainUnitName + '" cannot be same!');

  if not ValidateOutputPath(OutputPath) then
    raise Exception.Create('Invalid OutputPath "' + OutputPath + '"!');

  if IdeSet = [] then
    raise Exception.Create('Invalid IdeSet, at least one IDE must be selected!');

  if (TIde.Delphi in IdeSet) and (([TOs.Windows32, TOs.Windows64] * OsSet) = []) then
    raise Exception.Create('Invalid OsSet, at least one Windows OS must be selected for Delphi!');

  if OsSet = [] then
    raise Exception.Create('Invalid OsSet, at least one OS must be selected!');
end;

function TProjectGenerator.Make(): Boolean;
begin
  Validate();

  // get root TurboRaylib path
  FTurboRaylibPath := TrimFilename(ExtractFilePath(ParamStr(0)) + '../');

  // copy raylib bindings
  CopyRaylibBindings();

  // make project files
  if TIde.Lazarus in IdeSet then
  begin
    MakeLazarusProject();
  end;
  if TIde.Delphi in IdeSet then
  begin
    MakeDelphiProject();
  end;

  // make main pascal file
  Result := MakeMainUnitFile();

  // copy dll's
  CopyDlls();
end;


end.

