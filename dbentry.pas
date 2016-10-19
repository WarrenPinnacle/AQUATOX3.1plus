//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit DBEntry;

interface

uses
  Global,SysUtils, WinTypes, WinProcs, Messages, Classes,
  Graphics, Controls, Forms, Dialogs, StdCtrls, FileCtrl,
  Site, Plant, Animal, Remin, Finddlg,  DB, SV_IO,
  DBTables, ExtCtrls, Buttons;

type
  TDb_GetEntry = class(TForm)
    EntryList: TListBox;
    Header: TLabel;
    Table1: TTable;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label5: TLabel;
    Panel3: TPanel;
    DefaultButton: TRadioButton;
    OtherButton: TRadioButton;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    PathLabel: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    FileEdit: TEdit;
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    FilterComboBox1: TFilterComboBox;
    DriveComboBox1: TDriveComboBox;
    DefaultLabel: TLabel;
    procedure FileEditChange(Sender: TObject);
    procedure EntryListClick(Sender: TObject);
    procedure EntryListKeyPress(Sender: TObject; var Key: Char);
    procedure DefaultButtonClick(Sender: TObject);
    procedure OtherButtonClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
     {Set by user, Input Variables}
    HeadString,DefaultDbName,Filter: ShortString;
    {The Return Variables}
    FileDir,FileName,Entry : ShortString;

    Function GetEntry: Boolean;
    Function LoadToUnderlyingData(LibString: String; InTable:TTable):Boolean;
    Procedure CreateScreen;
  end;

var
  Db_GetEntry: TDb_GetEntry;


Function IndexByName(InTable: TTable; InStr: String): Integer;

implementation
{$R *.DFM}

Function IndexByName(InTable: TTable; InStr: String): Integer;
Var Found: Boolean;
Begin
  Result := 0;
  InTable.First;
  Repeat
    Inc(Result);
    Found := InTable.Fields[0].AsString = InStr;
    If Not Found then InTable.Next;
  Until Found;
End;


Function TDb_GetEntry.GetEntry: Boolean;

Begin
   GetEntry:=False;
   CreateScreen;
   If Showmodal = Mrok then GetEntry:=True;
End;

Procedure TDb_GetEntry.CreateScreen;
{Set up the screen to get a database entry name}

Begin
   DefaultLabel.Caption:='Default File--  '+DefaultDbName;
   DefaultButton.Checked:=True;
   Header.Caption:=HeadString;
   Panel1.Visible:=False;
   FilterComboBox1.Filter:=Filter
                   +'Paradox files (*.db)|*.db|All Files (*.*)|*.*';
   DefaultButtonClick(Db_GetEntry);
End;

Function TDb_GetEntry.LoadToUnderlyingData(LibString: String; InTable:TTable):Boolean;

Var LoadOK: Boolean;
    ChemRecHolder:  ChemicalRecord;
    AnimRecHolder:  ZooRecord;
    PlantRecHolder: PlantRecord;
    ReminRecHolder: ReminRecord;
    SiteRecHolder:  SiteRecord;

Begin
  With Db_GetEntry do
  begin
    HeadString:='Select '+LibString+' Entry to Load:';
    Filter:=LibString+' Library (*.'+Libstring[1]+'DB)|*.'+Libstring[1]+'DB|';

    Db_GetEntry.DefaultDbName:=LibString+'.'+LibString[1]+'DB';

    If Not GetEntry
      Then LoadOK := False
      Else Case LibString[1] of
            'C' : LoadOK:=Dbase_to_ChemRecord  (FileDir,FileName,Entry,-1,ChemRecHolder);
            'A' : LoadOK:=DBase_to_AnimalRecord(FileDir,FileName,Entry,-1,AnimRecHolder);
            'P' : LoadOK:=DBase_to_PlantRecord (FileDir,FileName,Entry,-1,PlantRecHolder);
            'R' : LoadOK:=DBase_to_ReminRecord (FileDir,FileName,Entry,ReminRecHolder);
            'S' : LoadOK:=DBase_to_SiteRecord  (FileDir,FileName,Entry,SiteRecHolder);
            else LoadOK := False;
           end; {Case}

    If LoadOK then
      With InTable do
        begin
          Active:=False;
          EmptyTable;
          Active:=True;
          Append;
          Fields[0].AsString:='Holder';
          Post;
          Active:=False;
          Case LibString[1] of
              'C' : ChemRecord_to_Dbase  (program_dir,'CHEMFORM.DB','Holder',ChemRecHolder);
              'A' : AnimalRecord_to_Dbase(program_dir,'ANIMFORM.DB','Holder',AnimRecHolder,False);
              'P' : PlantRecord_To_Dbase (program_dir,'PLNTFORM.DB','Holder',PlantRecHolder);
              'R' : ReminRecord_To_Dbase (program_dir,'REMNFORM.DB','Holder',ReminRecHolder);
              'S' : SiteRecord_To_Dbase  (program_dir,'SITEFORM.DB','Holder',SiteRecHolder);
             else LoadOK := False;
           End; {Case}
          Active:=True;
        End; {with}
  End; {with DB_Entry}

  LoadToUnderlyingData := LoadOK;
End;


{************************************************************************}
{****** THE REST OF THE PROCEDURES ARE SCREEN BUTTON-CLICK METHODS ******}
{************************************************************************}


procedure TDb_GetEntry.FileEditChange(Sender: TObject);
Var
   ChangeName,FileisThere: Boolean;
   ShortFileN, Holder,
   DBName,CorrectDbName,Dir: ShortString;
   Loop,RecNum: Integer;

begin
  OKBtn.Enabled:=False;
  EntryList.Items.Clear;
  DbName:=FileEdit.Text;
  Dir:=DirectoryListBox1.Directory;

  {Check and see if file exists}
  FileIsThere:=FileExists(Dir+'\'+DbName);
  If Not FileIsThere then Exit;

  {Check and see if index file exists as well}
  ShortFileN := AbbrString(DbName,'.');
  FileIsThere:=FileExists(dir+'\'+ShortFileN+'.PX');
  If Not FileIsThere then Exit;

  {Rename File For Reading}
  CorrectDbName:=ShortFileN+'.db';
  ChangeName:= Not (CorrectDbName=DbName);
  If ChangeName then
         if not RenameFile(dir+'\'+DbName,dir+'\'+CorrectDbName)
                then Exit;

  {Get Entry Names if File Exists}
  Table1.DataBaseName:=dir;
  Table1.TableName:=CorrectDbName;
  Try
     Table1.Active:=True;
     With Table1 do begin
              First;
              RecNum:=RecordCount;
              If RecNum>0 then
                 For loop:=1 to RecNum do
                     begin
                         Holder:=Fields[0].AsString;
                         EntryList.Items.Add(Holder);
                         Next;
                      end; {for do}
              EntryList.Update;
     end; {with}
  Except
  End;
  Table1.Active:=False;
  If ChangeName then
     RenameFile(dir+'\'+CorrectDbName,dir+'\'+DbName);
end;


procedure TDb_GetEntry.EntryListClick(Sender: TObject);
{Enable OK button only when an entry is selected}
begin
   If (EntryList.ItemIndex=-1) then OKBtn.Enabled:=False
   else OkBtn.Enabled:=EntryList.Items.Strings[EntryList.ItemIndex]<>'';
end;

procedure TDb_GetEntry.EntryListKeyPress(Sender: TObject; var Key: Char);
begin
  EntryListClick(Sender);
end;

procedure TDb_GetEntry.DefaultButtonClick(Sender: TObject);
begin
  DirectoryListBox1.Directory:=Default_Dir;
  FileListBox1.Directory:=Default_Dir;
  FileEdit.Text:=DefaultDbName;
  Panel1.Visible:=False;

end;

procedure TDb_GetEntry.OtherButtonClick(Sender: TObject);
begin
   FileListBox1.Update;
   Panel1.Visible:=True;
end;

procedure TDb_GetEntry.OKBtnClick(Sender: TObject);
begin
  FileName:=FileEdit.Text;
  FileDir:=DirectoryListBox1.Directory;
  Entry:=EntryList.Items.Strings[EntryList.ItemIndex];
end;

end.
