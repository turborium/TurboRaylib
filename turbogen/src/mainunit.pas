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
//  TurboRaylib - Delphi and FreePascal headers for Raylib 4.5.
//  Raylib - A simple and easy-to-use library to enjoy videogames programming (www.raylib.com)
//
//  Download compilled Raylib 4.5 library: https://github.com/raysan5/raylib/releases/tag/4.5.0
//
//  Copyright (c) 2022-2023 Turborium (https://github.com/turborium/TurboRaylib)
// -------------------------------------------------------------------------------------------------------------------
unit MainUnit;

{$MODE DELPHIUNICODE}{$CODEPAGE UTF8}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, FileUtil, ProjectGen;

type
  { TFormMain }

  TFormMain = class(TForm)
    BevelFooter: TBevel;
    BevelProjectName: TBevel;
    BevelMainUnitName: TBevel;
    BevelOutputFolder: TBevel;
    BevelProjectFolder: TBevel;
    ButtonMake: TButton;
    ButtonProjectFolder: TButton;
    CheckBoxOutputPath: TCheckBox;
    CheckGroupSupportOs: TCheckGroup;
    CheckGroupSupportIde: TCheckGroup;
    EditOutputPath: TEdit;
    EditMainUnitName: TEdit;
    EditProjectName: TEdit;
    EditProjectPath: TEdit;
    ImageLogo: TImage;
    LabelVersion: TLabel;
    LabelMainUnitName: TLabel;
    LabelProjectName: TLabel;
    LabelProjectFolder: TLabel;
    PanelProjectName: TPanel;
    PanelMainUnitName: TPanel;
    PanelProjectFolder: TPanel;
    PanelOutputFolder: TPanel;
    PanelProps: TPanel;
    PanelFooter: TPanel;
    PanelLogo: TPanel;
    SelectDirectoryDialog: TSelectDirectoryDialog;
    procedure ButtonMakeClick(Sender: TObject);
    procedure ButtonProjectFolderClick(Sender: TObject);
    procedure CheckBoxOutputPathChange(Sender: TObject);
    procedure EditMainUnitNameChange(Sender: TObject);
    procedure EditProjectNameChange(Sender: TObject);
    procedure EditProjectPathChange(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabelVersionClick(Sender: TObject);
  private
  protected
    procedure ChangeBounds(ALeft, ATop, AWidth, AHeight: Integer; AKeepBase: Boolean); override;
  end;

var
  FormMain: TFormMain;

implementation

uses
  Math{$IFDEF MSWINDOWS}, WinDirs{$ENDIF};

{$R *.lfm}

{ TFormMain }

procedure TFormMain.EditProjectNameChange(Sender: TObject);
begin
  EditMainUnitName.Text := EditProjectName.Text + 'Main';
  EditProjectPath.Text := ConcatPaths([{$IFDEF MSWINDOWS}GetWindowsSpecialDir(CSIDL_PERSONAL){$ELSE}GetUserDir(){$ENDIF}, EditProjectName.Text]);
end;

procedure TFormMain.EditProjectPathChange(Sender: TObject);
begin
end;

procedure TFormMain.ButtonMakeClick(Sender: TObject);
var
  Generator: TProjectGenerator;
  NoGenMain: Boolean;
begin
  Generator := TProjectGenerator.Create();
  try
    // Project Path
    Generator.ProjectPath := EditProjectPath.Text;

    // Project Name
    Generator.ProjectName := EditProjectName.Text;

    // Main Unit Name
    Generator.MainUnitName := EditMainUnitName.Text;

    // Output Folder
    if CheckBoxOutputPath.Checked then
      Generator.OutputPath := EditOutputPath.Text
    else
      Generator.OutputPath := '';

    // IDE
    Generator.IdeSet := [];
    if CheckGroupSupportIde.Checked[0] then
      Generator.IdeSet := Generator.IdeSet + [TIde.Delphi];
    if CheckGroupSupportIde.Checked[1] then
      Generator.IdeSet := Generator.IdeSet + [TIde.Lazarus];

    // OS
    Generator.OsSet := [];
    if CheckGroupSupportOs.Checked[0] then
      Generator.OsSet := Generator.OsSet + [TOs.Windows32];
    if CheckGroupSupportOs.Checked[1] then
      Generator.OsSet := Generator.OsSet + [TOs.Windows64];
    if CheckGroupSupportOs.Checked[2] then
      Generator.OsSet := Generator.OsSet + [TOs.Osx];
    if CheckGroupSupportOs.Checked[3] then
      Generator.OsSet := Generator.OsSet + [TOs.Linux];

    // make
    try
      NoGenMain := Generator.Make();

      if NoGenMain then
      begin
        MessageDlg('Info', 'The MainUnit already exists, it''s generation is skipped!',
          TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
      end;

      {$IFDEF MSWINDOWS}
      if MessageDlg('Success', 'The project was created successfully!'#10'Open the folder?',
        TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
      begin
        SysUtils.ExecuteProcess('explorer.exe', Generator.ProjectPath, []);
      end;
      {$ELSE}
      MessageDlg('Success', 'The project was created successfully!',
        TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
      {$ENDIF}

    except
      on E: Exception do
        MessageDlg('Error', E.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
    end;
  finally
    Generator.Free;
  end;
end;

procedure TFormMain.ButtonProjectFolderClick(Sender: TObject);
begin
  if SelectDirectoryDialog.Execute then
    EditProjectPath.Text := SelectDirectoryDialog.FileName;
end;

procedure TFormMain.CheckBoxOutputPathChange(Sender: TObject);
begin
  EditOutputPath.Enabled := CheckBoxOutputPath.Checked;
end;

procedure TFormMain.EditMainUnitNameChange(Sender: TObject);
begin
end;

procedure TFormMain.FormChangeBounds(Sender: TObject);
var
  WidthArray: array of Integer;
  MaxWidth: Integer;
begin
  WidthArray := [LabelProjectName.Width, LabelMainUnitName.Width, CheckBoxOutputPath.Width, LabelProjectFolder.Width];
  MaxWidth := MaxValue(WidthArray);
  BevelProjectName.Width := MaxWidth - LabelProjectName.Width;
  BevelMainUnitName.Width := MaxWidth - LabelMainUnitName.Width;
  BevelOutputFolder.Width := MaxWidth - CheckBoxOutputPath.Width;
  BevelProjectFolder.Width := MaxWidth - LabelProjectFolder.Width;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  EditProjectName.Text := TProjectGenerator.DefaultProjectName;
  EditMainUnitName.Text := TProjectGenerator.DefaultMainUnitName;
  EditOutputPath.Text := 'bin/';
  CheckBoxOutputPath.Checked := False;
  EditOutputPath.Enabled := CheckBoxOutputPath.Checked;
  // ide's
  CheckGroupSupportIde.Checked[0] := {$IFDEF MSWINDOWS}True{$ELSE}False{$ENDIF};// Delphi
  CheckGroupSupportIde.Checked[1] := True;// Lazarus
  // os
  CheckGroupSupportOs.Checked[0] := {$IFDEF MSWINDOWS}True{$ELSE}False{$ENDIF};// win x86
  CheckGroupSupportOs.Checked[1] := {$IFDEF MSWINDOWS}True{$ELSE}False{$ENDIF};// win x64
  CheckGroupSupportOs.Checked[2] := {$IFDEF DARWIN}True{$ELSE}False{$ENDIF};// osx
  CheckGroupSupportOs.Checked[3] := {$IFDEF LINUX}True{$ELSE}False{$ENDIF};// linux

  // default path
  SelectDirectoryDialog.FileName := {$IFDEF MSWINDOWS}GetWindowsSpecialDir(CSIDL_PERSONAL){$ELSE}GetUserDir(){$ENDIF};

  // temp hack
  EditProjectNameChange(nil);
end;

procedure TFormMain.LabelVersionClick(Sender: TObject);
begin

end;

procedure TFormMain.ChangeBounds(ALeft, ATop, AWidth, AHeight: Integer; AKeepBase: Boolean);
var
  Nothing: Integer;
begin
  Nothing := 0;
  GetPreferredSize(Nothing, AHeight);
  inherited ChangeBounds(ALeft, ATop, AWidth, AHeight, AKeepBase);
end;

end.

