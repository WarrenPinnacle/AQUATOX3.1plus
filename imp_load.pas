//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Unit imp_load;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, hh,
  DB, DBTables, FileCtrl, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, Global,
  AQBaseForm, ComCtrls, Tabnotbk, ExcelFuncs, Comobj, ActiveX, Variants, Convert;

Type
  TImportForm = class(TAQBase)
    Label5: TLabel;
    ImpTable: TTable;
    Label6: TLabel;
    LoadName: TLabel;
    DataSource1: TDataSource;
    IncomingTable: TTable;
    TabbedNotebook1: TTabbedNotebook;
    Panel3: TPanel;
    DefaultLabel: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    PathLabel: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    FileEdit: TEdit;
    FileListBox1: TFileListBox;
    DirectoryListBox1: TDirectoryListBox;
    FCB1: TFilterComboBox;
    DriveComboBox1: TDriveComboBox;
    CancelBtn: TBitBtn;
    OKBtn: TBitBtn;
    HelpButton: TButton;
    ErrPanel: TPanel;
    ErrLabel: TLabel;
    NoteBox: TListBox;
    Panel2: TPanel;
    Label7: TLabel;
    Panel4: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    FileEdit2: TEdit;
    FileListBox2: TFileListBox;
    DirectoryListBox2: TDirectoryListBox;
    FCB2: TFilterComboBox;
    DriveComboBox2: TDriveComboBox;
    BitBtn1: TBitBtn;
    ExportButt: TBitBtn;
    Button1: TButton;
    ListBox1: TListBox;
    DataSource2: TDataSource;
    Label13: TLabel;
    Button2: TButton;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label14: TLabel;
    Label15: TLabel;
    ExcelOptPanel: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    SheetEdit: TEdit;
    RowEdit: TEdit;
    DCEdit: TEdit;
    VCEdit: TEdit;
    Button3: TButton;
    DBGrid2: TDBGrid;
    DBGrid1: TDBGrid;
    ConvertBox: TCheckBox;
    UnitsBox: TComboBox;
    ConvertToLabel: TLabel;
    ConvertLabel: TLabel;
    procedure FileEditChange(Sender: TObject);
    procedure FCB1Change(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FCB2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FileEdit2Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ConvertBoxClick(Sender: TObject);
  private
    Function ImportData (DirNm, FileNm: String; Demo: Boolean; Var Table: TTable): Boolean;
    Function ExportData(DirNm, FileNm: String): Boolean;
  public
    Hourlymode: Boolean;
    CType: ConvertType;
    Function ChangeLoading(LoadNm: String; Var Table: TTable; WaterData, Hourly: Boolean; CT: ConvertType): Boolean;

  end;

Var
  ImportForm: TImportForm;

Implementation

uses Wait, Excel2000;

{$R *.DFM}


{---------------------------------------------------------------------}

Function TImportForm.ExportData(DirNm, FileNm: String): Boolean;
{If demo, it only gets the first 6 fields}

Var Outfile : TextFile;
    Loop, RecNum: Integer;
    DelimChar: Char;
    Msk,FullName: String;
    TEx: TExcelOutput;

Begin

  ExportData := True;

  Msk := ExtractFileExt(FCB2.Mask);
  If LowerCase(ExtractFileExt(FileNm)) <> Msk then FileNm := FileNm + Msk;

  {Check if file exists and ask user if overwriting is desired}
  If FileExists(DirNm+'\'+FileNm) or FileExists(DirNm+FileNm) then
     If (MessageDlg('Overwrite Existing File?',mtConfirmation,[mbyes,mbno],0)= mrno)
        then Begin ExportData := False; Exit; End;

  FullName := DirNm+'\'+FileNm;
  While Pos('\\',Fullname)>0 do
     Delete(Fullname,Pos('\\',Fullname),1);

  If FileExists(FullName) then If Not DeleteFile(FullName)
    then Begin
           MessageDlg('Cannot gain exclusive access to the file to overwrite it.',mtError,[mbOK],0);
           ExportData := False; Exit;
         End;

  TRY

  WaitDlg.Setup('Please Wait One Moment, Exporting Data');

  Case FCB2.ItemIndex of
    2,1: Begin  {CSV or Tab delim Export}
          Try
             ASSIGNFILE(Outfile,FullName);
             Rewrite(Outfile);
          Except
             WaitDlg.Hide;
             Raise EAQUATOXError.Create('Invalid Filename');
          End;

          Try
            With IncomingTable do
              begin
                First;
                RecNum:=RecordCount;
                For loop:=1 to RecNum do
                  begin
                     If FCB2.ItemIndex=2 then DelimChar := ','
                                         else DelimChar := Chr(9);
                     If hourlymode
                       then Writeln(OutFile,DateTimeToStr(Fields[0].AsDateTime),DelimChar,FloatToStr(Fields[1].AsFloat))
                       else Writeln(OutFile,DateToStr(Fields[0].AsDateTime),DelimChar,FloatToStr(Fields[1].AsFloat));
                     Next;
                  end; {for do}

              end; {with}

          Except
            CloseFile(Outfile);
            WaitDlg.Hide;
            Raise EAQUATOXError.create(Exception(ExceptObject).Message);
          End;

          CloseFile(Outfile);
       End; {CSV Input or Tab Delim}
    0: Begin  {Excel Export}
         TEx := nil;
         Try
            TEx := TExcelOutput.Create(False);
            If Not TEx.OpenFiles
              then TEx := nil
              else
                Begin
                  TEx.WS.Cells.Item[1,1].Value := 'Date:';
                  TEx.WS.Cells.Item[1,2].Value := LoadName.Caption;

                  With IncomingTable do
                    begin
                      First;
                      RecNum:=RecordCount;
                      For loop:=1 to RecNum do
                        begin
                           TEx.WS.Cells.Item[Loop+1,1].Value := Fields[0].AsDateTime;
                           TEx.WS.Cells.Item[Loop+1,2].Value := Fields[1].AsFloat;
                           Next;
                           If ((Loop mod 20) = 0) then WaitDlg.Tease;
                        end; {for do}
                    end; {with}

                  TEx.WS.Range['A1', 'A1'].EntireColumn.AutoFit;
                  If HourlyMode then TEx.WS.Range['A1', 'A1'].EntireColumn.Cells.NumberFormat := 'm/d/yyyy h:mm AM/PM';

                  TEx.FileN := FullName;
                  Tex.SaveandClose;
                End;

         Except
            WaitDlg.Hide;
            TRY
             If TEx<>nil then TEx.CloseFiles;
            Except
            END;
            Raise;
         End;
       End; 
   End; {Case}

  FINALLY

  WaitDlg.Hide;
  IncomingTable.Active:=False;

  END;

End;

{---------------------------------------------------------------------}

Function TImportForm.ImportData (DirNm, FileNm: String; Demo: Boolean;
                                 Var Table: TTable): Boolean;
{If demo, it only gets the first 6 fields}

Var Infile : TextFile;
    FileDone,FileError,SkipLine,GoodData: Boolean;
    InStr,DateStr,LoadStr,YearStr,MoStr,DayStr : String;
    i,DelimIndex,Loop, TopLoop,HeaderIndex  : Integer;
    Conv: Double; SheetI, RowI, ColI1, ColI2, Reslt: Integer;
    LoadDate  : TDateTime;
    Intercept, LoadVal   : Double;
    lcid: integer;
    WBk: _WorkBook;
    WS: _Worksheet;
    Excel: _Application;

     Function ConvExcelRow(St: String): Integer;
     Var Num1,Num2: Integer;
     Begin
       Result := -1;
       If Length(St) = 0 then exit;
       If (St[1] < 'A') or (St[1]>'Z') then exit;
       Num1 := ORD(ST[1])-ORD('A') + 1;
       If Length(St)=1 then begin Result := Num1; exit; end;
       If (St[2] < 'A') or (St[2]>'Z') then exit;
       Num2 := ORD(ST[2])-ORD('A') + 1;
       Result := (Num1*26)+Num2;
       If Result > 255 then Result := -1;
     End;

     Procedure AddEntry(Date:TDateTime; Load: Double);
     Begin
       Try
        With Table do
           Begin
             Append;
             Fields[0].AsDateTime:= Date;
             Fields[1].AsFloat:=Load;
             Post;
             If (Load>1000) or (Load <0.0001) then
                   Begin
                     TFloatField(Fields[1]).DisplayFormat:='0.0000e-00';
                     TFloatField(Fields[1]).DisplayWidth := 10;
                   End;
           End;
       Except
         Table.Delete;
         Raise;
        { Raise EAQUATOXError.Create('There must be no repeated dates in your import data set');}
       End;
     End;

Begin
  If Not Demo then WaitDlg.Setup('Please Wait One Moment, Importing Data');
  If CType = CTTemp then Intercept := -32
                    else Intercept := 0;

  LoadDate:=1; LoadVal:=1;
  FileError:=False;
  GoodData := False;
  Table.Active       := False;
  Table.DatabaseName := Program_Dir;
  Table.EmptyTable;
  Table.Active       := True;
  TFloatField(Table.Fields[1]).DisplayFormat:='###0.####';

  Case FCB1.ItemIndex of
    4,1: Begin  {CSV or Tab delim Input}
          Try
           ASSIGNFILE(Infile,DirNm+'\'+FileNm);
           Reset(Infile);
           i:=0;

           While not EOF(Infile) and not ((i>4) and (demo)) do
             Begin
               Readln(Infile,InStr);

               SkipLine:=False;
               If FCB1.ItemIndex=4 then DelimIndex := Pos(',',Instr)
                                   else DelimIndex := Pos(Chr(9),Instr);
               If (DelimIndex<=1) or (Pos('/',Instr)=0) then SkipLine:=True;

               If Not SkipLine then
                 Begin
                  Try
                   DateStr := Trim(Copy(InStr,1,DelimIndex-1));
                   LoadStr := Trim(Copy(InStr,DelimIndex+1,Length(InStr)-DelimIndex));
                   If hourlymode then LoadDate := StrToDatetime(DateStr)
                                 else LoadDate := StrToDate(DateStr);
                   LoadVal  := StrToFloat(LoadStr);
                   If (not demo) and ConvertBox.Checked then LoadVal := (LoadVal+Intercept) * Conversions[CType,UnitsBox.ItemIndex+1];
                   Except
                     SkipLine:=True;
                     If i>0 then Raise EAQUATOXError.create(Exception(ExceptObject).Message);
                   End; {try}
                 End; {if not}

               If Not SkipLine then
                 Begin
                   AddEntry(LoadDate,LoadVal);
                   GoodData:=True;
                   Inc(i);
                   If (Not Demo) and ((i mod 20) = 1) then WaitDlg.Tease;
                 End;
             End;

          If Not GoodData then
            Begin
              If Demo then ErrLabel.Caption := 'No Valid Data could be Found'
                      else Raise EAQUATOXError.create('No Valid Data could be Found');
              FileError:=True;
            End;

          Except
            FileError:=True;
            CloseFile(Infile);
            If Demo then ErrLabel.Caption := Exception(ExceptObject).Message
                    else Raise EAQUATOXError.create(Exception(ExceptObject).Message);
          End;

          CloseFile(Infile);
       End; {CSV Input or Tab Delim}
    0: Begin  {Excel Input}
           If Demo then WaitDlg.Setup('Gathering Sample Data');
           FileDone := False;

           Val(Trim(SheetEdit.Text),Conv,Reslt);
           If Reslt<>0 then Begin
                               SheetI := 1; SheetEdit.Text := '1';
                            End
                        else SheetI:=Trunc(Abs(Conv));

           Val(Trim(RowEdit.Text),Conv,Reslt);
           If Reslt<>0 then Begin
                               RowI := 1; RowEdit.Text := '1';
                            End
                        else RowI:=Trunc(Abs(Conv));

           Val(Trim(DCEdit.Text),Conv,Reslt);
           If Reslt<>0 then Begin
                               ColI1 := ConvExcelRow(Trim(DCEdit.Text));
                               If ColI1<0 then
                                 Begin
                                   ColI1 := 1; DCEdit.Text := 'A';
                                 End;
                            End
                        else ColI1:=Trunc(Abs(Conv));

           Val(Trim(VCEdit.Text),Conv,Reslt);
           If Reslt<>0 then Begin
                               ColI2 := ConvExcelRow(Trim(VCEdit.Text));
                               If ColI2<0 then
                                 Begin
                                   ColI2 := 1; VCEdit.Text := 'B';
                                 End;
                            End
                        else ColI2:=Trunc(Abs(Conv));

           TRY

           lcid := LOCALE_USER_DEFAULT;
           Excel := CoExcelApplication.Create;
           Excel.Visible[lcid] := False;

           WBk := Excel.Workbooks.Open(DirNm+'\'+FileNm, EmptyParam, EmptyParam, EmptyParam,
                                       EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
                                       EmptyParam, EmptyParam, EmptyParam,  EmptyParam,  LCID);
           WS := WBk.Worksheets.Item[SheetI] as _Worksheet;
           WS.Activate(LCID);

           i:=0;
           loop:=RowI-1; {0}


            While not FileDone and not ((i>4) and (demo)) do
             Begin

               If Not FileDone then
                 Begin
                   Try
                     SkipLine := False;
                     LoadStr  := WS.Cells.Item[loop+1,ColI1].value2;
                     LoadDate := StrToFloat(LoadStr);
                     LoadVal  := StrToFloat(WS.Cells.Item[loop+1,ColI2].value2);
                     If (not demo) and ConvertBox.Checked
                         then LoadVal := (LoadVal+Intercept) * Conversions[CType,UnitsBox.ItemIndex+1];
                   Except
                     If loop>0 then FileDone := True;
                     Inc(Loop);
                     SkipLine := True;
                   End;

                   If Not SkipLine then
                     Begin
                       AddEntry(LoadDate,LoadVal);
                       i:=i+1;
                       GoodData := True;
                       loop := loop+1;
                       If (Not Demo) and ((i mod 20) = 1) then WaitDlg.Tease;
                     End;
                 End;
             End;

          If Not GoodData then
            Begin
              If Demo then ErrLabel.Caption := 'No Valid Data could be Found'
                      else Raise EAQUATOXError.create('No Valid Data could be Found');
              FileError:=True;
            End;

            Wbk.Close(False,EmptyParam,EmptyParam,LCID);

(*         Try
           FileDone := False;
           XLSRead.FileName := DirNm+'\'+FileNm;
           XLSRead.OpenFile;
           i:=0;
           loop:=0;

           While not FileDone and not ((i>4) and (demo)) do
             Begin
               Try
                 If Not XLSRead.Seek(0,0,loop,DateVal) then FileDone := True;
                 If Not XLSRead.Seek(0,1,loop,FloatVal) then FileDone := True;
               Except
                 Raise EAquatoxError.Create('Excel Read Error.');
               End;

               If Not FileDone then
                 Begin
                   Try
                     SkipLine := False;
                     LoadDate := DateVal;
                     LoadVal  := FloatVal;
                   Except
                     If loop>0 then FileDone := True;
                     Inc(Loop);
                     SkipLine := True;
                   End;

                   If Not SkipLine then
                     Begin
                       AddEntry(LoadDate,LoadVal);
                       i:=i+1;
                       GoodData := True;
                       loop := loop+1;
                       If (Not Demo) and ((i mod 20) = 1) then WaitDlg.Tease;
                     End;
                 End;
             End;

          If Not GoodData then
            Begin
              If Demo then ErrLabel.Caption := 'No Valid Data could be Found'
                      else Raise EAQUATOXError.create('No Valid Data could be Found');
              FileError:=True;
            End;

          Except
            XLSRead.CloseFile;
            FileError:=True;
            If Demo then ErrLabel.Caption := Exception(ExceptObject).Message
                    else Raise EAQUATOXError.create(Exception(ExceptObject).Message);
          End;

         XLSRead.CloseFile; *)

           FINALLY
             WaitDlg.Hide;
             Excel.Quit
           END;
       End; {0}

    5: Begin  {USGS Input}
        Try
         ASSIGNFILE(Infile,DirNm+'\'+FileNm);
         Reset(Infile);
         i:=0;
         HeaderIndex:= 0;

         While not EOF(Infile) and not ((i>4) and (demo)) do
           Begin
             Readln(Infile,InStr);

             SkipLine:=False;
             If Length(Instr)=0 then Skipline := True;
             If Not SkipLine then if InStr[1]='#' then SkipLine := True;
             If Not SkipLine then Inc(HeaderIndex);
             If HeaderIndex<3 then SkipLine := True;

             DelimIndex:=0;
             If Not SkipLine then
               Begin  {find second tab delimiter}
                 Loop := 0;
                 Repeat
                   Inc(Loop);
                   If Instr[Loop]=CHR(9) then Inc(DelimIndex)
                 Until (Loop=Length(InStr)) or (DelimIndex=2);

                 If Loop=Length(InStr) then SkipLine   := True
                                       else DelimIndex := Loop;
               End;

             If Not SkipLine then
               Begin
                Try
                 YearStr := Trim(Copy(InStr,DelimIndex+1,4));
                 MoStr   := Trim(Copy(InStr,DelimIndex+6,2));
                 DayStr  := Trim(Copy(InStr,DelimIndex+9,2));
                 LoadStr := '';
                 Loop := DelimIndex+12;
                   While (InStr[Loop] <> CHR(9)) and (Loop<=Length(InStr)) do
                     Begin
                       LoadStr := LoadStr + InStr[Loop];
                       Inc(Loop);
                     End;
                 LoadDate := EncodeDate(StrToInt(YearStr),StrToInt(MoStr),StrToInt(DayStr));;
                 LoadVal  := StrToFloat(LoadStr) * SecsPerDay * 0.028317 ;
                                {f3 / s}            {s / d}     {m3/f3}
                 Except
                   SkipLine:=True;
                 End; {try}
               End; {if not}

             If Not SkipLine then
               Begin
                 AddEntry(LoadDate,LoadVal);
                 GoodData:=True;
                 Inc(i);
                 If (Not Demo) and ((i mod 20) = 1) then WaitDlg.Tease;
               End;
           End;

          If Not GoodData then
            Begin
              If Demo then ErrLabel.Caption := 'No Valid Data could be Found'
                      else Raise EAQUATOXError.create('No Valid Data could be Found');
              FileError:=True;
            End;

          Except
            CloseFile(Infile);
            FileError:=True;
            WaitDlg.Hide;
            If Demo then ErrLabel.Caption := Exception(ExceptObject).Message
                    else Raise EAQUATOXError.create(Exception(ExceptObject).Message);
          End;

        CloseFile(Infile);
       End;
    Else {Database Import}
      Begin
        Try
          IncomingTable.Active:=False;
          IncomingTable.TableName:=FileNm;
          IncomingTable.DatabaseName:=DirNm;
          If FCB1.ItemIndex=2
              then IncomingTable.TableType := TTDbase
              else IncomingTable.TableType := TTParadox;
          IncomingTable.Active:=True;
          IncomingTable.First;

          TopLoop:=IncomingTable.RecordCount ;
          If (TopLoop>5) and (demo) then Toploop:=5;

          For Loop:=1 to TopLoop do
            Begin
              LoadDate:=IncomingTable.Fields[0].AsDateTime;
              LoadVal :=IncomingTable.Fields[1].AsFloat;
              If (not demo) and ConvertBox.Checked
                then LoadVal := (LoadVal+Intercept) * Conversions[CType,UnitsBox.ItemIndex+1];
              AddEntry(LoadDate,LoadVal);
              IncomingTable.Next;
              If (Not Demo) and ((Loop mod 20) = 1) then WaitDlg.Tease;
            End;

        Except
          IncomingTable.Active:=False;
          FileError:=True;
          If Demo then ErrLabel.Caption := Exception(ExceptObject).Message
                  else Raise EAQUATOXError.create(Exception(ExceptObject).Message);
        End; {except}
      End; {Else}
   End; {Case}

  WaitDlg.Hide;
  IncomingTable.Active:=False;
  Table.Active := Not FileError;
  ImportData   := Not FileError;
End;


{---------------------------------------------------------------------}

procedure TImportForm.Button3Click(Sender: TObject);
begin
  FileEditChange(nil);
end;

Function TImportForm.ChangeLoading(LoadNm: String; Var Table: TTable; WaterData, Hourly: Boolean; CT: ConvertType): Boolean;

Procedure ImpLoad;
Var CanExit:Boolean;
    i: Integer;
Begin
  CType := CT;

  ConvertBox.Visible := (CType <> CTNone);
  UnitsBox.Visible := (CType <> CTNone);
  ConvertToLabel.Visible := (CType <> CTNone);
  ConvertLabel.Visible := False;
  ConvertBox.Checked := False;

  If CType <> CTNone then
    Begin
      UnitsBox.Items.Clear;
      For i := 1 to MaxConversions do
        Begin
          If ConvertFrom[CType,i] <> '' then
            UnitsBox.Items.Add(ConvertFrom[CType,i]);
        End;
      UnitsBox.ItemIndex := 0;
      ConvertToLabel.Caption := 'to '+ConvertTo[CType];
      Unitsbox.Enabled := False;
    End;

  HourlyMode := Hourly;
  If Hourly then ImpTable.TableName := 'LoadHourI.db';
  OKBtn.Enabled := False;

  IncomingTable.TableName := Table.TableName;
  IncomingTable.DatabaseName := Table.DatabaseName;

  With FCB1 do
    If WaterData then Filter := 'Excel (*.xls*)|*.xls*|Tab Delimited Text (*.txt)|*.txt|DBase File (*.dbf)|*.dbf|Paradox File (*.db)|*.db|Comma Delim. Text (*.csv)|*.csv|USGS Flow Data (*.*)|*.*'
                 else Filter := 'Excel (*.xls*)|*.xls*|Tab Delimited Text (*.txt)|*.txt|DBase File (*.dbf)|*.dbf|Paradox File (*.db)|*.db|Comma Delim. Text (*.csv)|*.csv';

  ChangeLoading := False;
  LoadName.Caption:=LoadNm;

  Repeat
    CanExit := True;
    If ShowModal = MrOK then
    Case TabbedNotebook1.PageIndex of
     0:  Begin
            ChangeLoading := True;
            If not ImportData(DirectoryListBox1.Directory,FileEdit.Text,False,Table)
               then Raise EAquatoxError.Create('Import Error');
         End;
     1:  Begin
            If not ExportData(DirectoryListBox2.Directory,FileEdit2.Text)
               then CanExit := False;
         End;
     2:  Begin
           IncomingTable.Active := False;
           IncomingTable.EmptyTable;
         End;
    End; {Case}
  Until CanExit;        
End;

Begin
  Application.CreateForm(TImportForm, ImportForm);
  Self := importForm;
  ImpLoad;
  ImportForm.Free;
End;


procedure TImportForm.ConvertBoxClick(Sender: TObject);
Var Intercept: Double;
begin
  If CType = CTTemp then Intercept := -32
                    else Intercept := 0;

  UnitsBox.Enabled := ConvertBox.Checked;
  Convertlabel.Visible := ConvertBox.Checked;
  If ConvertLabel.Visible then
     ConvertLabel.Caption := '(1 '+ UnitsBox.Text + ' = ' +
         FloatToStrf((1+Intercept) * Conversions[CType,UnitsBox.ItemIndex+1],ffgeneral,9,4) +
         ' '+ConvertTo[CType] +')' ;

end;



{---------------------------------------------------------------------}

Procedure TImportForm.FileEditChange(Sender: TObject);
Var Dir,FileName,FullName : String;
    FileIsThere           : Boolean;
    LoadError             : Boolean;
Begin
  OKBtn.Enabled:=False;

  FileName:=FileEdit.Text;
  Dir:=DirectoryListBox1.Directory;
  FullName:=Dir+'\'+FileName;

  {Check and see if file exists}
  FileIsThere:=FileExists(FullName);
  If FileIsThere then FileIsThere := Pos('*',FullName)=0;
  If FileIsThere then FileIsThere := Pos('?',FullName)=0;

  If Not FileIsThere then Begin
                            ErrPanel.Visible:=True;
                            ErrLabel.Caption:='No File Has Been Selected';
                            Exit;
                          End;

  LoadError := not ImportData(Dir,FileName,True,ImpTable);

  If LoadError then
    Begin
      ErrLabel.Caption := 'Error Reading File';
      ErrPanel.Visible := True;
      OKBtn.Enabled := False;
    End
  else
    Begin
     OKBtn.Enabled:=True;
     ErrPanel.Visible:=False;
    End;

End;

{---------------------------------------------------------------------}
procedure TImportForm.FileEdit2Change(Sender: TObject);
Var FileName,Dir,FullName: String;

begin
  ExportButt.Enabled:=True;

  FileName:=FileEdit2.Text;
  Dir:=DirectoryListBox1.Directory;
  FullName:=Dir+'\'+FileName;

  {Check and see if file exists}
  If TRIM(FileName) = '' then ExportButt.Enabled := False;
  If Pos('*',FullName)>0 then ExportButt.Enabled := False;
  If Pos('?',FullName)>0 then ExportButt.Enabled := False;
end;
{---------------------------------------------------------------------}


Procedure TImportForm.FCB1Change(Sender: TObject);
Var datestr: String;
    datetimeformat: String;
Begin
  ConvertBox.Visible := (CType <> CTNone) and (FCB1.ItemIndex<>5);
  UnitsBox.Visible := (CType <> CTNone) and (FCB1.ItemIndex<>5);
  ConvertToLabel.Visible := (CType <> CTNone) and (FCB1.ItemIndex<>5);
  ConvertLabel.Visible := (CType <> CTNone) and (FCB1.ItemIndex<>5) and (ConvertBox.Checked);

  If hourlymode then datestr := 'date and time'
                else datestr := 'date';
  If hourlymode then datetimeformat := shortdateformat+' '+shorttimeformat
                else datetimeformat := shortdateformat;

  NoteBox.Items.Clear;
  ExcelOptPanel.Visible := (FCB1.ItemIndex = 0);

  Case FCB1.ItemIndex of
    0: Begin
         NoteBox.Items.Add('');
         NoteBox.Items.Add('    Excel Data');
         NoteBox.Items.Add('');
         NoteBox.Items.Add('    Column A of the first sheet in ');
         NoteBox.Items.Add('    the workbook should hold the');
         NoteBox.Items.Add('    '+datestr+'.  Column B should');
         NoteBox.Items.Add('    hold data to be imported.  (Or, ');
         NoteBox.Items.Add('    specify row, col, sheet below)');
       End;
    1: Begin
         NoteBox.Items.Add('');
         NoteBox.Items.Add('    Tab Delimited Text');
         NoteBox.Items.Add('');
         NoteBox.Items.Add('    Each line of the text file must');
         NoteBox.Items.Add('    have a unique '+datestr+' entry');
         NoteBox.Items.Add('    in the form '+datetimeformat);
         NoteBox.Items.Add('    followed by a tab character,');
         NoteBox.Items.Add('    then a loading entry in the');
         NoteBox.Items.Add('    appropriate units.');
       End;
    2: Begin
         NoteBox.Items.Add('');
         NoteBox.Items.Add('    DBase File');
         NoteBox.Items.Add('');
         NoteBox.Items.Add('    The first field of the database must');
         NoteBox.Items.Add('    be a '+datestr+' field with unique');
         NoteBox.Items.Add('    '+datestr+'s; the second field ');
         NoteBox.Items.Add('    must be numeric, with loading');
         NoteBox.Items.Add('    data in the appropriate units.');
       End;
    3: Begin
         NoteBox.Items.Add('');
         NoteBox.Items.Add('    Paradox Database');
         NoteBox.Items.Add('');
         NoteBox.Items.Add('    The first field of the database must');
         NoteBox.Items.Add('    be a '+datestr+' field with unique');
         NoteBox.Items.Add('    '+datestr+'s; the second field');
         NoteBox.Items.Add('    must be numeric, with loading data');
         NoteBox.Items.Add('    in the appropriate units.');
       End;
    4: Begin
         NoteBox.Items.Add('');
         NoteBox.Items.Add('    Comma Delimited Text');
         NoteBox.Items.Add('');
         NoteBox.Items.Add('    Each line of the text file must');
         NoteBox.Items.Add('    have a unique '+datestr+' entry');
         NoteBox.Items.Add('    in the form '+datetimeformat);
         NoteBox.Items.Add('    followed by a comma character,');
         NoteBox.Items.Add('    then a loading entry in the');
         NoteBox.Items.Add('    appropriate units.');
       End;
    5: Begin
         NoteBox.Items.Add('');
         NoteBox.Items.Add('   USGS Flow Data');
         NoteBox.Items.Add('');
         NoteBox.Items.Add('   Save USGS Daily Streamflow');
         NoteBox.Items.Add('   data (http://water.usgs.gov/)');
         NoteBox.Items.Add('   as a tab separated file ');
         NoteBox.Items.Add('   with date format YYYY-MM-DD. ');
         NoteBox.Items.Add('   Data will be converted from ');
         NoteBox.Items.Add('   cu.ft./sec to cu.m/day');
       End;
  End;
End;

procedure TImportForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Import_and_Export_Loadings.htm');
end;

procedure TImportForm.FCB2Change(Sender: TObject);
Var datestr: String;
    datetimeformat: String;
Begin
  If hourlymode then datestr := 'date and time'
                else datestr := 'date';
  If hourlymode then datetimeformat := shortdateformat+' '+shorttimeformat
                else datetimeformat := shortdateformat;

  ListBox1.Items.Clear;

  Case FCB2.ItemIndex of
    1: Begin
         ListBox1.Items.Add('');
         ListBox1.Items.Add('    Comma Delimited Text');
         ListBox1.Items.Add('');
         ListBox1.Items.Add('    Each line of the text file will');
         ListBox1.Items.Add('    have a unique date entry in the');
         ListBox1.Items.Add('    form '+datetimeformat);
         ListBox1.Items.Add('    followed by a comma, then');
         ListBox1.Items.Add('    a loading entry for that '+datestr);
       End;
    2: Begin
         ListBox1.Items.Add('');
         ListBox1.Items.Add('    Tab Delimited Text');
         ListBox1.Items.Add('');
         ListBox1.Items.Add('    Each line of the text file will');
         ListBox1.Items.Add('    have a unique date entry in the');
         ListBox1.Items.Add('    form '+datetimeformat);
         ListBox1.Items.Add('    followed by a tab character, then');
         ListBox1.Items.Add('    a loading entry for that '+datestr);
       End;
    0: Begin
         ListBox1.Items.Add('');
         ListBox1.Items.Add('    Excel Data');
         ListBox1.Items.Add('');
         ListBox1.Items.Add('    Column A of the first sheet in ');
         ListBox1.Items.Add('    the workbook will hold the');
         ListBox1.Items.Add('    '+datestr+'.  Column B will');
         ListBox1.Items.Add('    hold the exported data. ');
       End;
  End;

End;


procedure TImportForm.FormShow(Sender: TObject);
begin
  FCB1change(nil);
  FCB2Change(nil);
  FileEdit2Change(nil);
end;

procedure TImportForm.TabbedNotebook1Change(Sender: TObject;
  NewTab: Integer; var AllowChange: Boolean);
begin
  If NewTab>0 then Begin
                     DBGrid2.Visible := True;
                     IncomingTable.Active := True;
                     TFloatField(IncomingTable.Fields[1]).DisplayFormat:='###0.####';
                     TFloatField(IncomingTable.Fields[1]).DisplayWidth := 14;
                    End
              else Begin
                     DBGrid2.Visible := False;
                     IncomingTable.Active := False;
                   End;
end;


End.
