//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Librarys;

interface

uses
  Global,SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, FileCtrl, Finddlg,  DB, DBTables, SV_IO, AQBaseform;

type
  TLibrary_File = class(TAQBase)
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
    OK_Button: TButton;
    Cancel_Button: TButton;
    SaveTable: TTable;
    procedure OK_ButtonClick(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure FileEditChange(Sender: TObject);
    procedure OKDisable(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    ReturnDir: ShortString;
    Function Transfer_TempFile(LibString,NDir,NFile: ShortString;TOTEMP:Boolean):Boolean;
    Function SaveToLibrary(LibString: ShortString; Var InTable: TTable; Var ReturnDir: ShortString; Indx: Integer):Boolean;
  end;

var
  Library_File: TLibrary_File;
  Dir,FileN: ShortString;

implementation



Function TLibrary_File.Transfer_TempFile(LibString,NDir,NFile: ShortString;TOTEMP:Boolean):Boolean;
{This Procedure transfers the selected Database to a Temporary File, so
Changes can be accepted or rejected..  If TOTEMP is true, the transfer
is to the temporary file, if TOTEMP is false, the transfer is back to
the original database}
Var Source,Srcappd,Destination,DestAppd,LibAppd: ShortString;
    Copy_OK: Boolean;

Begin
  LibAppd:=AbbrString(NFile,'.');  {Get Abridged File Name}

  IF TOTEMP THEN  BEGIN  SrcAppd := Dir + '\' + LibAppd;
                         Source  := Dir + '\' + NFile;
                         Destination:=Program_Dir+'tempedit';
                         Copy_OK:=AQTCopyFile(Source,Destination+'.db');
                         If not Copy_OK then
                            MessageDlg('Unable to create temporary database file',mterror,[mbOK],0)
                         Else Begin
                                 Copy_OK:= AQTCopyFile(SrcAppd+'.px',Destination+'.px');
                                 If not Copy_OK then
                                    MessageDlg('Unable to create temporary index file, file may be incorrect type',
                                                mterror,[mbOK],0)
                              End;
                   END
            ELSE   BEGIN Destination:=Dir+'\'+FileN;
                         DestAppd:=Dir+'\'+LibAppd;
                         Source:=Program_Dir+'tempedit';
                         Copy_OK:=AQTCopyFile(Source+'.db',Destination);
                         If not Copy_OK then
                            MessageDlg('Unable to update Library Database, Your Changes are in TEMPFILE.DB.',mterror,
                                              [mbOK],0)
                         Else Begin
                                 Copy_OK:= AQTCopyFile(Source+'.px',Destappd+'.px');
                                 If not Copy_OK then
                                    MessageDlg('Unable to update Library Index, Your Changes remain in TEMPFILE.DB.',mterror,
                                              [mbOK],0);
                              End;
                   END;

   Transfer_TempFile:=Copy_OK;

end;    {Transfer_TempFile}


{$R *.DFM}


Function TLibrary_File.SaveToLibrary(LibString: ShortString; Var InTable: TTable;Var ReturnDir: ShortString; Indx: Integer):Boolean;

Var SmallFilter: ShortString;
    ChangeName,FileisThere: Boolean;
    ShortFileN,
    CorrectDbName: ShortString;
    KeyStr, KeyStr2: String;
    ChemRecHolder: ChemicalRecord;
    AnimRecHolder: ZooRecord;
    PlantRecHolder: PlantRecord;
    ReminRecHolder: ReminRecord;
    SiteRecHolder:  SiteRecord;
    i: Integer;

Begin
  SaveToLibrary:=False;
  Application.CreateForm(TLibrary_File, Library_File);

  KeyStr := InTable.Fields[0].AsString;

  {ENABLE DIALOG BOX TO FIND LOCATION OF LIBRARY FILE}
  With Library_File do
     begin
       FileListBox1.Directory:=Default_Dir;
       Caption:='Save "'+ KeyStr +'" to which '+LibString+' Library?';
       SmallFilter:=FilterComboBox1.Filter;
       FilterComboBox1.Filter:=LibString+' Library (*.'+Libstring[1]+'DB)|*.'+Libstring[1]+'DB|'+SmallFilter;
       RadioButton1.Caption:='Default: '+LibString+'.'+Libstring[1]+'DB';
       RadioButton1.Checked:=True;
       ShowModal;
       Hide;
       FilterComboBox1.Filter:=SmallFilter;
     end; {with}

  If FileN='Default' then begin  Dir:=Default_Dir;
                                 FileN:=Libstring+'.'+Libstring[1]+'DB';
                          end;

  If FileN='Cancel' then
    Begin
      Library_file.Free;
      Exit;
    End;

  {Check and see if file exists}
  FileIsThere:=FileExists(Dir+'\'+FileN);
  If Not FileIsThere then Begin
                            MessageDlg('File Not Found: '+Dir+'\'+FileN,MtError,[mbOK],0);
                            Library_file.Free;
                            Exit;
                          End;

  {Check and see if index file exists as well}
  ShortFileN := AbbrString(FileN,'.');
  FileIsThere:=FileExists(CleanFileName((Dir+'\'+ShortFileN+'.PX')));
  If Not FileIsThere then Begin
                            MessageDlg('PX (database index) File Not Found.',MtError,[mbOK],0);
                            Library_file.Free;
                            Exit;
                          End;

  {Rename File}
  CorrectDbName:=ShortFileN+'.db';
  ChangeName:= Not (CorrectDbName=FileN);
  If ChangeName then
         if not RenameFile(CleanFileName(Dir+'\'+FileN),CleanFileName(Dir+'\'+CorrectDbName))
                then Begin
                       MessageDlg('File Rename Error.  '+CleanFileName(Dir+'\'+FileN)+'  to  '+CleanFileName(Dir+'\'+CorrectDbName),MtError,[mbOK],0);
                       Library_file.Free;
                       Exit;
                     End;

  With Library_File.SaveTable do
    Begin
     TableName    := CorrectDbName;
     DatabaseName := Dir;
     Active       := True;
    End;

  KeyStr := InTable.Fields[0].AsString;
  If Indx > 0 then KeyStr2 := '' else KeyStr2 := KeyStr;


  If (Library_File.SaveTable.FindKey([KeyStr]))
    then Begin
           If MessageDlg('The entry "'+KeyStr+'" already exists in that Database.  Overwrite?',MtConfirmation,[mbYes,mbNo],0) = mrno
              then
                Begin
                  MessageDlg('No data have been written to the Library.  Change the name of your entry and save again if you wish.',MtInformation,[mbOK],0);
                  Library_File.SaveTable.Active:=False;
                  If ChangeName then
                    RenameFile(Dir+'\'+CorrectDbName,Dir+'\'+FileN);
                  Library_file.Free;
                  Exit;
                End;
         End
    else With Library_File do
         Begin
           SaveTable.Insert;
           SaveTable.Fields[0].AsString := KeyStr;
           SaveTable.Post;
         End;

  Library_File.SaveTable.Active:=False;
  If InTable.State in [dsedit,dsinsert] then InTable.Post;
  InTable.Active:=False;


  Case LibString[1] of
   'C': Begin   {Chemical}
         Dbase_to_ChemRecord(InTable.DatabaseName,InTable.TableName,KeyStr2,Indx,ChemRecHolder);
         ChemRecord_to_DBase(Library_File.SaveTable.DatabaseName,Library_File.SaveTable.TableName,KeyStr,ChemRecHolder);
         {Toxicity data is copied in CHEM.PAS}
        End;
   'A': Begin  {Animal}
         Dbase_to_AnimalRecord(InTable.DatabaseName,InTable.TableName,KeyStr2,Indx,AnimRecHolder);
         AnimalRecord_to_DBase(Library_File.SaveTable.DatabaseName,Library_File.SaveTable.TableName,KeyStr,AnimRecHolder,False);
        End;
   'P': Begin  {Plant}
         Dbase_to_PlantRecord(InTable.DatabaseName,InTable.TableName,KeyStr2,Indx,PlantRecHolder);
         PlantRecord_to_DBase(Library_File.SaveTable.DatabaseName,Library_File.SaveTable.TableName,KeyStr,PlantRecHolder);
        End;
   'S': Begin  {Site}
         Dbase_to_SiteRecord(InTable.DatabaseName,InTable.TableName,KeyStr,SiteRecHolder);
         SiteRecord_to_DBase(Library_File.SaveTable.DatabaseName,Library_File.SaveTable.TableName,KeyStr,SiteRecHolder);
        End;
   'R': Begin  {Remineralization}
         Dbase_to_ReminRecord(InTable.DatabaseName,InTable.TableName,KeyStr,ReminRecHolder);
         ReminRecord_to_DBase(Library_File.SaveTable.DatabaseName,Library_File.SaveTable.TableName,KeyStr,ReminRecHolder);
        End;
  End; {Case}



  InTable.Active:=True;

  If Indx>0 then
    Begin
      InTable.First;
      For i := 2 to Indx do
        InTable.Next;
    End;

  If ChangeName then
     RenameFile(Dir+'\'+CorrectDbName,Dir+'\'+FileN);

  MessageDlg('Data successfully written to the Library.',MtInformation,[mbOK],0);

  ReturnDir:=Dir;
  SaveToLibrary := True;
  Library_file.Free;
End;

{************************************************************************}
{****** THE REST OF THE PROCEDURES ARE SCREEN BUTTON-CLICK METHODS ******}
{************************************************************************}

procedure TLibrary_File.OK_ButtonClick(Sender: TObject);
begin
    If RadioButton1.Checked then FileN:='Default'
                           else begin FileN:=FileEdit.Text;
                                      Dir:=DirectoryListBox1.Directory;
                                end;

end;

procedure TLibrary_File.RadioButton2Click(Sender: TObject);
begin
   Library_File.Height:=392;
   OK_BUTTON.Enabled:=FileExists(DirectoryListBox1.Directory+'/'+fileedit.text);
   {Enable OK button only if file exists}
end;

procedure TLibrary_File.RadioButton1Click(Sender: TObject);
begin
   Library_File.Height:=100;         
   OK_Button.Enabled:=True;
end;

procedure TLibrary_File.Cancel_ButtonClick(Sender: TObject);
begin
     FileN:='Cancel';
end;

procedure TLibrary_File.FileEditChange(Sender: TObject);
begin
  OK_BUTTON.Enabled:=FileExists(DirectoryListBox1.Directory+'/'+fileedit.text);
  {Enable OK button only if file exists}
end;

procedure TLibrary_File.OKDisable(Sender: TObject);
begin
     OK_BUTTON.Enabled:=False;
end;

procedure TLibrary_File.FileListBox1DblClick(Sender: TObject);
{Accept double click on file name if appropriate}
begin
    if OK_Button.Enabled then begin
                                FileN:=FileEdit.Text;
                                Dir:=DirectoryListBox1.Directory;
                                Library_File.ModalResult:=MROK;
                              end;
end;

end.
