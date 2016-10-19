//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Default;
{Brings up a dialog box that determines if the user wants to edit the
 default library file, or another library file, chosen through a file
 menu : JoNC}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, FileCtrl;

type
  TLibrary_File = class(TForm)
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label2: TLabel;
    FileEdit: TEdit;
    Label3: TLabel;
    PathLabel: TLabel;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    FilterComboBox1: TFilterComboBox;
    Label1: TLabel;
    Label4: TLabel;
    DriveComboBox1: TDriveComboBox;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FileEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Library_File: TLibrary_File;
  Dir,FileN: ShortString;

implementation

{$R *.DFM}


procedure TLibrary_File.Button1Click(Sender: TObject);
begin
    If RadioButton1.Checked then FileN:='Default'
                           else begin FileN:=FileEdit.Text;
                                      Dir:=PathLabel.Caption;
                                end;
   Library_File.Hide;
end;

procedure TLibrary_File.RadioButton2Click(Sender: TObject);
begin
   Library_File.Height:=392;
   Button1.Enabled:=FileExists(pathlabel.caption+'/'+fileedit.text);
     {Enable OK button only if file exists}
end;

procedure TLibrary_File.RadioButton1Click(Sender: TObject);
begin
   Library_File.Height:=100;

end;

procedure TLibrary_File.Button2Click(Sender: TObject);
begin
     FileN:='Cancel';
     Library_File.Hide;
end;

procedure TLibrary_File.FileEditChange(Sender: TObject);
begin
  Button1.Enabled:=FileExists(pathlabel.caption+'/'+fileedit.text);
     {Enable OK button only if chosen file exists}
end;

end.
