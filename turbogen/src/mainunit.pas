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
    procedure EditProjectNameChange(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  protected
    procedure ChangeBounds(ALeft, ATop, AWidth, AHeight: Integer; AKeepBase: Boolean); override;
  end;

var
  FormMain: TFormMain;

implementation

uses
  Math;

{$R *.lfm}

{ TFormMain }

procedure TFormMain.EditProjectNameChange(Sender: TObject);
begin
  EditMainUnitName.Text := EditProjectName.Text + 'Main';
end;

procedure TFormMain.ButtonMakeClick(Sender: TObject);
var
  Generator: TProjectGenerator;
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
      Generator.Make();
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
  SelectDirectoryDialog.Execute;
  EditProjectPath.Text := SelectDirectoryDialog.FileName;
end;

procedure TFormMain.CheckBoxOutputPathChange(Sender: TObject);
begin
  EditOutputPath.Enabled := CheckBoxOutputPath.Checked;
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

