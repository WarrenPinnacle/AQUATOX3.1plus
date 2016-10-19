//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Observed_Data;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Global, Series, StdCtrls, FileCtrl, ExtCtrls, Grids, Wait, DB,
  DBTables, Excel2000, Comobj, ActiveX, TeEngine, hh;


type
  TSaveFont = class(TComponent)
  private
    fFont: TFont;
    procedure SetFont(AFont: TFont);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Font: TFont read fFont write SetFont;
  end;

CONST NO_ERR_VAL = -9999;

type
     TObservedSeries = Class
      NumRecs: Integer;
      UniqueIndex: LongInt;  {Unique numerical identifier, -1000 or lower}
      ObsDates,ObsVals,ErrMin,ErrMax: Array of Double;
      HasErrors: Boolean;
      HasNDs: Boolean;
      NDFlag: Array of Word;
      NameStr: String[40];
      Unitstr: String[40];
      VSeg: VerticalSegments;
      Comment: XLRefString;
      Constructor Create(UI: Integer);
      Constructor Load(IsTemp: Boolean; Var st: TStream; ReadVersionNum: Double);
      Procedure Store(IsTemp: Boolean; Var st: TStream); Virtual;
      Procedure InitLength(l: Integer);
      Procedure AddLength;
      Destructor Destroy;  override;
  End;

  TYItems =  Array [False..True {IsY1},1..20] of LongInt;  {holds sortindex, the unique index for each results datapoint}

   TGSR = Packed Record
     GraphName: XLRefString;
     YItems: TYItems;  {holds sortindex, the unique index for each results datapoint}
     IsShowing: Array[False..True,1..20] of Boolean;
     Colors: Array[False..True, 1..20] of TColor;
     Shapes: Array[False..True,1..20] of TSeriesPointerStyle;
     LineThick, Size:  Array[False..True,1..20] of Word;
     VertGL, Y1GL, Y2GL, Graph3D: Boolean;
     DefaultTitle, DefaultX, DefaultY1, DefaultY2: Boolean;
     GraphTitle1, GraphTitle2, XLabel, Y1Label, Y2Label: XLRefString;
     VSeg: VerticalSegments;
     Y1AutoScale, Y2AutoScale,AutoScaleAll,DiffAutoScale: Boolean;
     Y1Min,Y1Max,Y2Min,Y2Max,DiffMin,DiffMax: Double;
     Use2Scales: Boolean;
     XMin, XMax: Double;
     Threshold,Left_Thresh: Double;  {10/26/2010 Converted non-used Y1&Y2Gap to Threshold to simplifiy load/store. }
     Y1Format, Y2Format: String[30]; {NOT USED YET}
     Scenario: Integer;                    {size 1266 to here}
     GraphType: Integer; {0= X Y plot, 1= Percent Exceedence, 2= Duration} {1270}
     Logarithmic: Boolean;  {1271}
     RepeatPeriods: Boolean;
   End;

   TLinkedSeriesGSR = Packed Record
      Color: TColor;
      Shape: TSeriesPointerStyle;
      LineThick, Size: Word;
      Suppress: Boolean;
   End;

   TLinkedGSR = Class
      nseries: Integer;
      GSRs: Array of TLinkedSeriesGSR;
      Constructor CreateBlank(ns: Integer);
      Constructor Load(IsTemp: Boolean; Var st: TStream; ReadVersionNum: Double);
      Procedure AddLength(num: Integer);
      Procedure Store(IsTemp: Boolean; Var st: TStream); Virtual;
      Destructor Destroy;  Override;
   End;


   TGraphSetup = Class
     data: TGSR;
     SaveFont1,SaveFont2,SaveFont3,SaveFont4: TSaveFont;
     Linked: Boolean;
     LinkedGSR: TLinkedGSR;
     Constructor Load(IsTemp: Boolean; Var st: TStream; ReadVersionNum: Double);
     Constructor CreateEmptyGraph(linked:Boolean);
     Procedure Store(IsTemp: Boolean; Var st: TStream); Virtual;
     Destructor Destroy;  Override;
   End;

  TGraphs = Class
     NumGraphs, SelectedGraph: Integer;
     GArray : Array of TGraphSetup;
     Constructor Create;
     Procedure AddGraph(G: TGraphSetup);
     Procedure DeleteGraph(Index: Integer);
     Constructor Load(IsTemp: Boolean; Var st: TStream; ReadVersionNum: Double);
     Procedure Store(IsTemp: Boolean; Var st: TStream); Virtual;
     Destructor Destroy; Override;
   End;

   TObservedData = Class
     NumSeries: Integer;
     CurrentIndex: LongInt; {Starting with -1000 and counting backwards, unique ID}
     OSeries : Array of TObservedSeries;
     Constructor Create;
     Constructor Load(IsTemp: Boolean; Var st: TStream; ReadVersionNum: Double);
     Procedure AddFromFile(IsTemp: Boolean; Var st: TStream; ReadVersionNum: Double);
     Procedure Store(IsTemp: Boolean; Var st: TStream); Virtual;
     Destructor Destroy; Override;
  End;

    TEdit_Data_Form = class(TForm)
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
    NoteBox: TListBox;
    Panel2: TPanel;
    ODLaBEL: TLabel;
    ObsSeriesList: TListBox;
    AddButton: TButton;
    DeleteButton: TButton;
    Panel3: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    SeriesNameEdit: TEdit;
    HypCB: TCheckBox;
    Label10: TLabel;
    SeriesUnitEdit: TEdit;
    Label11: TLabel;
    NDCB: TCheckBox;
    Label12: TLabel;
    ErrorBarCB: TCheckBox;
    Label8: TLabel;
    CommentEdit: TMemo;
    GridPanel: TPanel;
    StringGrid1: TStringGrid;
    ImportButton: TButton;
    HelpButton: TButton;
    CancelBtn: TButton;
    OKBtn: TButton;
    CancelImport: TButton;
    ImpTable: TTable;
    DataSource1: TDataSource;
    Label9: TLabel;
    ExcelOptPanel: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    SheetEdit: TEdit;
    RowEdit: TEdit;
    DCEdit: TEdit;
    VCEdit: TEdit;
    Label13: TLabel;
    ImportNDBox: TCheckBox;
    ImportErrBox: TCheckBox;
    ImportButt: TButton;
    SaveAllButton: TButton;
    LoadAllButton: TButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure SeriesNameEditChange(Sender: TObject);
    procedure SeriesUnitEditChange(Sender: TObject);
    procedure ErrorBarCBClick(Sender: TObject);
    procedure NDCBClick(Sender: TObject);
    procedure HypCBClick(Sender: TObject);
    procedure CommentEditChange(Sender: TObject);
    procedure ObsSeriesListClick(Sender: TObject);
    procedure ImportButtClick(Sender: TObject);
    procedure FCB1Change(Sender: TObject);
    procedure ImportButtonClick(Sender: TObject);
    procedure CancelImportClick(Sender: TObject);
    procedure FileEditChange(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure StringGrid1Exit(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveAllButtonClick(Sender: TObject);
    procedure LoadAllButtonClick(Sender: TObject);
  private
    Selected: Integer;
    Updating: Boolean;
    ValStr  : String[60];
    EditRow, EditCol : Integer;
    { Private declarations }
  public
    Changed: Boolean;
    OD: TObservedData;
    Function AttemptImport: Boolean;
    Procedure ChangeToImport;
    Procedure ChangeToGrid;
    Procedure EditObsData(Var TOD: TObservedData);
    Procedure UpdateScreen(DrawGrid: Boolean);
    { Public declarations }
  end;

var
  Edit_Data_Form: TEdit_Data_Form;

implementation
{$R *.dfm}

uses aquaobj;

procedure TSaveFont.SetFont(AFont: TFont);
begin
  fFont.Assign(AFont);
end;

constructor TSaveFont.Create(AOwner: TComponent);
begin
  inherited;
  fFont := TFont.Create;
  fFont.Name := 'Tahoma';
  fFont.Size := 10;
  fFont.Style := [];
end;

destructor TSaveFont.Destroy;
begin
  fFont.Free;
  inherited;
end;


Constructor TObservedSeries.Create(UI: Integer);
Begin
  NumRecs := 0;
  ObsDates := nil;
  ObsVals := nil;
  ErrMin := nil;
  ErrMax := nil;
  NDFlag := nil;
  HasErrors:= False;
  HasNDs  := False;
  NameStr := 'New Series';
  VSeg := Epilimnion;
  Comment := '';
  UnitStr := 'unknown';
  UniqueIndex := UI;
End;

Constructor TObservedSeries.Load(IsTemp: Boolean; Var st: TStream; ReadVersionNum: Double);
Var i: Integer;
Begin
  St.Read(NumRecs,Sizeof(NumRecs));

  SetLength(ObsDates,NumRecs);
  SetLength(ObsVals,NumRecs);
  SetLength(ErrMin,NumRecs);
  SetLength(ErrMax,NumRecs);
  SetLength(NDFlag,NumRecs);

  St.Read(HasErrors, Sizeof(HasErrors));
  St.Read(HasNDs, Sizeof(HasNDs));

  For i := 0 to NumRecs-1 do
    Begin
      St.Read(ObsDates[i],Sizeof(ObsDates[i]));
      St.Read(ObsVals[i],Sizeof(ObsVals[i]));
      If HasErrors then St.Read(ErrMin[i],Sizeof(ErrMin[i]))
                   else ErrMin[i] := NO_ERR_VAL;
      If HasErrors then St.Read(ErrMax[i],Sizeof(ErrMax[i]))
                   else ErrMax[i] := NO_ERR_VAL;
      If HasNDs then St.Read(NDFlag[i],Sizeof(NDFlag[i]))
                else NDFlag[i] := 0;
    End;

  St.Read(NameStr, Sizeof(NameStr));
  St.Read(VSeg, Sizeof(VSeg));
  St.Read(Comment, Sizeof(Comment));
  St.Read(UnitStr, Sizeof(UnitStr));
  St.Read(UniqueIndex, Sizeof(UniqueIndex));


End;

Procedure TObservedSeries.Store(IsTemp: Boolean; Var st: TStream);
Var i: Integer;
Begin
  St.Write(NumRecs,Sizeof(NumRecs));

  St.Write(HasErrors, Sizeof(HasErrors));
  St.Write(HasNDs, Sizeof(HasNDs));

  For i := 0 to NumRecs-1 do
    Begin
      St.Write(ObsDates[i],Sizeof(ObsDates[i]));
      St.Write(ObsVals[i],Sizeof(ObsVals[i]));
      If HasErrors then St.Write(ErrMin[i],Sizeof(ErrMin[i]));
      If HasErrors then St.Write(ErrMax[i],Sizeof(ErrMax[i]));
      If HasNDs then St.Write(NDFlag[i],Sizeof(NDFlag[i]));
    End;

  St.Write(NameStr, Sizeof(NameStr));
  St.Write(VSeg, Sizeof(VSeg));
  St.Write(Comment, Sizeof(Comment));
  St.Write(UnitStr, Sizeof(UnitStr));
  St.Write(UniqueIndex, Sizeof(UniqueIndex));

End;

Procedure TObservedSeries.InitLength(L: Integer);
Var i: Integer;
Begin
  SetLength(ObsDates,0);
  SetLength(ObsVals,0);
  SetLength(ErrMin,0);
  SetLength(ErrMax,0);
  SetLength(NDFlag,0);
  SetLength(ObsDates,L);
  SetLength(ObsVaLs,L);
  SetLength(ErrMin,L);
  SetLength(ErrMax,L);
  SetLength(NDFLag,L);
  For i := 0 to L-1 do
    Begin
      ObsDates[i] := 0;
      ObsVals[i] := 0;
      ErrMin[i] := NO_ERR_VAL;
      ErrMax[i] := NO_ERR_VAL;
      NDFlag[i] := 0;
    End;
End;

Procedure TObservedSeries.AddLength;
Var i: Integer;
Begin
  SetLength(ObsDates,NumRecs*3);
  SetLength(ObsVals,NumRecs*3);
  SetLength(ErrMin,NumRecs*3);
  SetLength(ErrMax,NumRecs*3);
  SetLength(NDFlag,NumRecs*3);
  For i := NumRecs+1 to NumRecs*3 do
    Begin
      ObsDates[i-1] := 0;
      ObsVals[i-1] := 0;
      ErrMin[i-1] := NO_ERR_VAL;
      ErrMax[i-1] := NO_ERR_VAL;
      NDFlag[i-1] := 0;
    End;

End;

Destructor TObservedSeries.Destroy;
Begin
  ObsDates := nil;
  ObsVals := nil;
  ErrMin := nil;
  ErrMax := nil;
  NDFlag := nil;
  inherited;
End;

procedure TEdit_Data_Form.AddButtonClick(Sender: TObject);
begin
  Changed := True;
  Inc(OD.NumSeries);
  Dec(OD.CurrentIndex);
  If (OD.NumSeries > Length(OD.OSeries)) then
    SetLength(OD.OSeries,Length(OD.OSeries)+5);
  OD.OSeries[OD.NumSeries-1] := TObservedSeries.Create(OD.CurrentIndex);
  Selected := OD.NumSeries-1;
  UpdateScreen(True);
end;

procedure TEdit_Data_Form.ImportButtClick(Sender: TObject);
begin
  ChangeToImport;
end;

Function TEdit_Data_Form.AttemptImport;

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


      Function GetColumn(Var InStr: String; Col: Integer): String;
      Var i: Integer;
          ThisCol: Integer;
          DelimChar: Char;
      Begin
       i := 0;
       ThisCol := 1;

       If FCB1.ItemIndex=4 then DelimChar := ','
                           else DelimChar := Chr(9);
        Result := '';
        Repeat
          inc(i);
          If (Instr[i] = DelimChar) then Inc(ThisCol)
           else If ThisCol = Col then Result := Result + Instr[i];
        Until (i = Length(Instr)) or (ThisCol>Col);
      End;

Var Infile : TextFile;
    FileDone,SkipLine,GoodData: Boolean;
    HasND, HasErrBar: Boolean;
    NDStr, EMax, EMin, InStr,DateStr,LoadStr : String;
    i,Loop  : Integer;
    LoadND  : Word;
    LoadEMin, LoadEMax: Double;
    LoadDate  : TDateTime;
    Conv, LoadVal   : Double;
    SheetI, RowI, ColI1,ColI2, Reslt: Integer;
    lcid: integer;
    WBk: _WorkBook;
    WS: _Worksheet;
    Excel: _Application;

    TOS: TObservedSeries;

           Procedure SetND;
           Begin
             LoadND := 0;
             IF Trim(NDStr) <> '' then
                Begin
                  HasND := True;
                  If Trim(NDStr) = '>' then LoadND := 2
                                       else LoadND := 1
                End;
             TOS.NDFlag[i-1] := LoadND;
           End;

Begin
  lcid := 0;
  AttemptImport := False;

  If Selected = -1 then AddButtonClick(nil);
  TOS := OD.OSeries[Selected];
  IF TOS.NumRecs > 0 then if
    (MessageDlg('Overwrite data in existing data-set?',mtconfirmation,[mbyes,mbno],0)
      = MRno) then Exit;

  WaitDlg.Setup('Please Wait One Moment, Importing Data');
  LoadDate:=1; LoadVal:=1;
  GoodData := False;
  HasND := False;
  HasErrBar := False;

  Case FCB1.ItemIndex of
    4,1: Begin  {CSV or Tab delim Input}
          Try
           TOS.InitLength(100);

           ASSIGNFILE(Infile,DirectoryListBox1.Directory+'\'+FileEdit.Text);
           Reset(Infile);
           i:=0;

           While not EOF(Infile) do
             Begin
               Readln(Infile,InStr);

                  Try
                   DateStr := GetColumn(InStr,1);
                   LoadStr := GetColumn(InStr,2);
                   LoadDate := StrToDatetime(DateStr);
                   LoadVal  := StrToFloat(LoadStr);

                   NDStr := ''; EMin := ''; EMax := '';
                   If ImportNDBox.Checked then
                      NDStr := GetColumn(InStr,3);

                   IF ImportErrBox.Checked then
                     Begin
                       EMin := GetColumn(InStr,4);
                       EMax := GetColumn(InStr,5);
                     End;

                   GoodData := True;
                   AttemptImport := True;
                   Inc(i);
                   If i>Length(TOS.ObsDates) then TOS.AddLength;
                   TOS.NumRecs := i;
                   TOS.ObsDates[i-1] := LoadDate;
                   TOS.ObsVals[i-1] := LoadVal;

                    LoadEMin := NO_ERR_VAL;
                    LoadEMax := NO_ERR_VAL;
                    IF (Trim(EMin) <> '') then
                      Begin
                        HasErrBar := True;
                        LoadEMin := StrToFloat(EMin);
                      End;
                    IF (Trim(EMax) <> '') then
                      Begin
                        HasErrBar := True;
                        LoadEMax := StrToFloat(EMax);
                      End;
                    TOS.ErrMin[i-1]:= LoadEMin;
                    TOS.ErrMax[i-1]:= LoadEMax;

                    SetND;

                   Except
                     If i>0 then
                       Begin
                         MessageDlg('Error Importing Line "'+InStr+'"',MTError,[MBOK],0);
                         Raise EAQUATOXError.create(Exception(ExceptObject).Message);
                       End;
                   End; {try}

             End;

          If Not GoodData then
            Begin
              Raise EAQUATOXError.create('No Valid Data could be Found');
            End;

          Except
            CloseFile(Infile);
            Raise EAQUATOXError.create(Exception(ExceptObject).Message);
          End;

          TOS.HasErrors := HasErrBar;
          TOS.HasNDs := HasND;

          CloseFile(Infile);
       End; {CSV Input or Tab Delim}
    0: Begin  {Excel Input}
         Try

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


           i:=0;
           loop:=RowI - 1;
           TOS.InitLength(100);

           lcid := LOCALE_USER_DEFAULT;
           Excel := CoExcelApplication.Create;
           Excel.Visible[lcid] := False;

           WBk := Excel.Workbooks.Open(DirectoryListBox1.Directory+'\'+FileEdit.Text, EmptyParam, EmptyParam, EmptyParam,
                                       EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
                                       EmptyParam, EmptyParam, EmptyParam,  EmptyParam,  LCID);
           WS := WBk.Worksheets.Item[SheetI] as _Worksheet;
           WS.Activate(LCID);

            While not FileDone do
             Begin

               If Not FileDone then
                 Begin
                   Try
                     SkipLine := False;
                     LoadStr  := WS.Cells.Item[loop+1,ColI1].value2;
                     If LoadStr = '' then
                         Begin
                           SkipLine := True;
                           If Loop>0 then FileDone := True;
                         End
                       else
                         Begin
                           LoadDate := StrToFloat(LoadStr);
                           LoadVal  := StrToFloat(WS.Cells.Item[loop+1,ColI2].value2);
                         End;
                   Except
                     If loop>0 then FileDone := True;
                     Inc(Loop);
                     SkipLine := True;
                   End;

                   If Not SkipLine then
                     Begin
                       Inc(i);
                       If i>Length(TOS.ObsDates) then TOS.AddLength;
                       TOS.NumRecs := i;
                       TOS.ObsDates[i-1] := LoadDate;
                       TOS.ObsVals[i-1] := LoadVal;
                       GoodData := True;
                       AttemptImport := True;

                       If ImportNDBox.Checked then
                         Begin
                           NDStr  := WS.Cells.Item[loop+1,ColI2+1].value2;
                           SetND;
                         End;

                       LoadEMin := NO_ERR_VAL;
                       LoadEMax := NO_ERR_VAL;

                       If ImportErrBox.Checked then
                         Begin
                           InStr := WS.Cells.Item[loop+1,ColI2+2].Value2;
                           If InStr<>'' then
                             Begin
                               LoadEMin := WS.Cells.Item[loop+1,ColI2+2].value2;
                               HasErrBar := True;
                             End;

                           InStr := WS.Cells.Item[loop+1,ColI2+3].Value2;
                           If InStr<>'' then
                             Begin
                               LoadEMax := WS.Cells.Item[loop+1,ColI2+3].value2;
                               HasErrBar := True;
                             End;
                         End;

                       TOS.ErrMin[i-1]:= LoadEMin;
                       TOS.ErrMax[i-1]:= LoadEMax;

                       loop := loop+1;
                       If ((i mod 20) = 1) then WaitDlg.Tease;
                     End;
                 End;
             End;

          If Not GoodData then
            Begin
              Raise EAQUATOXError.create('No Valid Data could be Found');
            End;

           TOS.HasErrors := HasErrBar;
           TOS.HasNDs := HasND;

           Wbk.Close(False,EmptyParam,EmptyParam,LCID);
           Excel.Quit
         Except
           Wbk.Close(False,EmptyParam,EmptyParam,LCID);
           Excel.Quit;
           WaitDlg.Hide;
         End;   
       End; {0}

    Else {Database Import}
      Begin
        ShowMessage('Database Import not yet enabled');
(*        Try
          IncomingTable.Active:=False;
          IncomingTable.TableName:=FileNm;
          IncomingTable.DatabaseName:=DirNm;
          If FCB1.ItemIndex=2
              then IncomingTable.TableType := TTDbase
              else IncomingTable.TableType := TTParadox;
          IncomingTable.Active:=True;
          IncomingTable.First;

          TopLoop:=IncomingTable.RecordCount ;

          For Loop:=1 to TopLoop do
            Begin
              LoadDate:=IncomingTable.Fields[0].AsDateTime;
              LoadVal :=IncomingTable.Fields[1].AsFloat;
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
      End; {Else} *)
   End;

 { WaitDlg.Hide; }
{  IncomingTable.Active:=False;
  Table.Active := Not FileError;
  ImportData   := Not FileError; }
End;  {Case}
  WaitDlg.Hide;

End;

Procedure TEdit_Data_Form.ChangeToGrid;
Begin
   GridPanel.Visible := True;
   NoteBox.Visible := False;
   ImportButton.Visible := False;
   ImportButt.Enabled := True;
{   EditButt.Visible := True; }
   HelpButton.Visible := True;
   CancelBtn.Visible := True;
   OKBtn.Visible := True;

End;

Procedure TEdit_Data_Form.ChangeToImport;
Begin
   GridPanel.Visible := False;
   NoteBox.Visible := True;
   ImportButton.Visible := True;
   ImportButt.Enabled := False;
{   EditButt.Visible := False; }
   HelpButton.Visible := False;
   CancelBtn.Visible := False;
   OKBtn.Visible := False;
End;


procedure TEdit_Data_Form.ImportButtonClick(Sender: TObject);
begin
   If AttemptImport then UpdateScreen(True);
   ChangeToGrid;
end;



procedure TEdit_Data_Form.CancelBtnClick(Sender: TObject);
begin
  If Changed then
    If MessageDlg('Cancel all changes to observed data?',mtconfirmation,[mbyes,mbno],0)
       = MRNo then Exit;
  ModalResult := MRCancel;
end;

procedure TEdit_Data_Form.CancelImportClick(Sender: TObject);
begin
  ChangeToGrid;
end;

procedure TEdit_Data_Form.CommentEditChange(Sender: TObject);
begin
  If Selected <0 then exit;
  If Not Updating then Changed := True;
  OD.OSeries[Selected].Comment := TEdit(Sender).Text;
end;

procedure TEdit_Data_Form.DeleteButtonClick(Sender: TObject);
var i: Integer;
begin
  If Selected = -1 then exit;
  With ObsSeriesList do
    If MessageDlg('Delete Data in Series '+Items[ItemIndex]+ '?',mtconfirmation,[mbok,mbcancel],0)
      = MrCancel then Exit;
  Changed := True;
  OD.OSeries[Selected].Destroy;
  For i := Selected to OD.NumSeries-2 do
    OD.OSeries[i] := OD.OSeries[i+1];
  Dec(OD.NumSeries);
  UpdateScreen(True);
end;

Procedure TEdit_Data_Form.UpdateScreen(DrawGrid: Boolean);
Var i: Integer;
Begin
  Updating := True;
  ObsSeriesList.Clear;
  If OD.NumSeries = 0 then Selected := -1;
  For i := 0 to OD.NumSeries - 1 do
    With OD.OSeries[i] do
      Begin
        ObsSeriesList.Items.Add(NameStr + ' (' +UnitStr+')');
        If Selected = i then
          Begin
            SeriesNameEdit.Text := NameStr;
            SeriesUnitEdit.Text := UnitStr;
            ErrorBarCB.Checked := HasErrors;
            NDCB.Checked := HasNDs;
            HypCB.Checked := VSeg = Hypolimnion;
            CommentEdit.Text := Comment;
          End;
      End;
  ObsSeriesList.ItemIndex := Selected;

  StringGrid1.Visible := (Selected > -1);
  If DrawGrid and (Selected > -1) then
   With OD.OSeries[Selected] do
    With StringGrid1 do
     Begin
       for i := 0 to Rowcount - 1 do Rows[i].Clear;
       Colcount := 2;

       IF HasNDs then ColCount := 3;
       If HasErrors then ColCount := ColCount+2;
       RowCount := NumRecs + 1;
       If RowCount > 1 then FixedRows := 1;
       Rows[0].Add('Date/Time');
       Rows[0].Add('Data');
       If HasNDs then Rows[0].Add('NonDetect');
       If HasErrors then
          Begin
            Rows[0].Add('Err Bar Min');
            Rows[0].Add('Err Bar Max');
          End;
       For i := 1 to NumRecs do
         Begin
           Rows[i].Add(DateTimeToStr(ObsDates[i-1]));
           Rows[i].Add(FloatToStrF(ObsVals[i-1],ffgeneral,12,5));
           If HasNDs then
               Case NDFlag[i-1] of
                 0: Rows[i].Add('');
                 1: Rows[i].Add('<');
                 else Rows[i].Add('>');
               End; {Case}
           If HasErrors then
             Begin
              If (ErrMin[i-1]<>NO_ERR_VAL)
                then Rows[i].Add(FloatToStrF(ErrMin[i-1],ffgeneral,12,5))
                else Rows[i].Add('');
              If (ErrMax[i-1]<>NO_ERR_VAL)
                then Rows[i].Add(FloatToStrF(ErrMax[i-1],ffgeneral,12,5))
                else Rows[i].Add('');
             End
         End;
    End;

  Updating := False;

End;

Procedure TEdit_Data_Form.EditObsData(Var TOD: TObservedData);
Var TMS: TMemoryStream;
Begin
  EditRow := -1;  EditCol := -1;
  StringGrid1.Selection := TGridRect(Rect(0, 0, 0, 0));
  Changed := False;
  TMS := TMemoryStream.Create;
  OD := TOD;
  TOD.Store(True,TStream(TMS));

  Selected := 0;
  UpdateScreen(true);
  FCB1Change(nil);
  ValStr := '~';

  If ShowModal=MRCancel
   then If Changed then
                     Begin
                        TMS.Seek(0, soFromBeginning); {Go to beginning of stream}
                        TOD.Destroy;
                        TOD := TObservedData.Load(True,TStream(TMS),VersionNum);
                        Changed := False;
                      End;
  TMS.Destroy;
End;


procedure TEdit_Data_Form.ErrorBarCBClick(Sender: TObject);
begin
  If Updating Then Exit;
  If Selected <0 then exit;
  Changed := True;
  OD.OSeries[Selected].HasErrors := ErrorBarCB.Checked;
  UpdateScreen(True)
end;

procedure TEdit_Data_Form.FCB1Change(Sender: TObject);
Var datetimeformatstr: String;
begin
  datetimeformatstr := shortdateformat+' '+shorttimeformat;

  ExcelOptPanel.Visible := (FCB1.ItemIndex = 0);
  NoteBox.Items.Clear;

  Case FCB1.ItemIndex of
    0: Begin
         NoteBox.Items.Add('');
         NoteBox.Items.Add('  Excel Data');
         NoteBox.Items.Add('');
         NoteBox.Items.Add('  By Default, Column A of the first sheet in the book');
         NoteBox.Items.Add('  should hold the date or date and time. Col. B should');
         NoteBox.Items.Add('  hold data to be imported.  Col. C holds Non-Detect Flags');
         NoteBox.Items.Add('  if relevant. ("<" or non-blank for less than, ">" for ');
         NoteBox.Items.Add('  greater. Cols. D & E hold optional min. and max. bars.');
         NoteBox.Items.Add('  Or the location of data within Excel can be entered above.');
       End;
    1: Begin
         NoteBox.Items.Add('');
         NoteBox.Items.Add('  Tab Delimited Text');
         NoteBox.Items.Add('');
         NoteBox.Items.Add('  Each line of the text file must have the date or');
         NoteBox.Items.Add('  date and  time in the format:' +datetimeformatStr+ '.');
         NoteBox.Items.Add('  Data is in the next col. (Col.B) of the tab del. file') ;
         NoteBox.Items.Add('  Column C holds any Non-Detect Flags if relevant.');
         NoteBox.Items.Add('  ("<" or non-blank for "less than", ">" for "greater.")');
         NoteBox.Items.Add('  Columns D & E hold optional min. and max. bars.');
       End;
    2: Begin
         NoteBox.Items.Add('');
         NoteBox.Items.Add('  DBase File');
         NoteBox.Items.Add('');
         NoteBox.Items.Add('  Database Import not yet Enabled');
(*
         NoteBox.Items.Add('  Column A of the database should hold the date or');
         NoteBox.Items.Add('  date and time.  Col B should hold data to import.');
         NoteBox.Items.Add('  Column C holds any Non-Detect Flags if relevant.');
         NoteBox.Items.Add('  ("<" or any non-blank for less than, ">" for greater.)');
         NoteBox.Items.Add('  Columns D & E hold optional min. and max. bars.'); *)
       End;
    3: Begin
         NoteBox.Items.Add('');
         NoteBox.Items.Add('  Paradox Database');
         NoteBox.Items.Add('');
         NoteBox.Items.Add('  Database Import not yet Enabled');
(*
         NoteBox.Items.Add('  Column A of the database should hold the date or');
         NoteBox.Items.Add('  date and time.  Col B should hold data to import.');
         NoteBox.Items.Add('  Column C holds any Non-Detect Flags if relevant.');
         NoteBox.Items.Add('  ("<" or any non-blank for less than, ">" for greater.)');
         NoteBox.Items.Add('  Columns D & E hold optional min. and max. bars.'); *)
       End;
    4: Begin
         NoteBox.Items.Add('');
         NoteBox.Items.Add('  Comma Delimited Text');
         NoteBox.Items.Add('');
         NoteBox.Items.Add('  Each line of the text file must have the date or');
         NoteBox.Items.Add('  date and  time in the format:' +datetimeformatStr+ '.');
         NoteBox.Items.Add('  Data is in the next col. (Col.B) of the comma del. file') ;
         NoteBox.Items.Add('  Column C holds any Non-Detect Flags if relevant.');
         NoteBox.Items.Add('  ("<" or non-blank for "less than", ">" for "greater.")');
         NoteBox.Items.Add('  Columns D & E hold optional min. and max. bars.');
       End;
  End;

end;

procedure TEdit_Data_Form.FileEditChange(Sender: TObject);
Var FileIsThere: Boolean;
    FullName: String;
begin
  ImportButton.Enabled:=False;
  FullName:=DirectoryListBox1.Directory + '\' +FileEdit.Text;

  {Check and see if file exists}
  FileIsThere:=FileExists(FullName);
  If FileIsThere then FileIsThere := Pos('*',FullName)=0;
  If FileIsThere then FileIsThere := Pos('?',FullName)=0;

  ImportButton.Enabled := FileIsThere;
End;  

procedure TEdit_Data_Form.FormCreate(Sender: TObject);
begin
  GridPanel.BringToFront;
end;

procedure TEdit_Data_Form.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Import_Observed_Data.htm');
end;

procedure TEdit_Data_Form.HypCBClick(Sender: TObject);
begin
  If Selected <0 then exit;
  If Not Updating then Changed := True;
  If HypCB.Checked then OD.OSeries[Selected].VSeg := Hypolimnion
                   else OD.OSeries[Selected].VSeg := Epilimnion;
end;

procedure TEdit_Data_Form.NDCBClick(Sender: TObject);
begin
  If Updating Then Exit;
  If Selected <0 then exit;
  Changed := True;
  OD.OSeries[Selected].HasNDs := NDCB.Checked;
  UpdateScreen(True);
end;

procedure TEdit_Data_Form.ObsSeriesListClick(Sender: TObject);
begin
  If Updating then Exit;
  Selected := ObsSeriesList.ItemIndex;
  UpdateScreen(true);
  StringGrid1.Selection := TGridRect(Rect(0, 0, 0, 0));
end;

procedure TEdit_Data_Form.SaveAllButtonClick(Sender: TObject);
Var FileStream : TFileStream;
    Filen: String;
    VersionWrite: String[10];

begin
   If Not PromptForFileName(FileN,'AQUATOX Observed Data File (*.AODF)|*.AODF','.AODF','Select File to Save AQUATOX Observed Data To','',True)
    then Exit;

   Try
     FileStream:=TFileStream.Create(FileN,fmCreate);
   Except
     MessageDlg(Exception(ExceptObject).Message,mterror,[mbOK],0);
     Exit;
   End; {Try Except}

   VersionWrite:=VersionStr;
   FileStream.Write(VersionWrite,Sizeof(VersionWrite));

   OD.Store(True,TStream(FileStream));
   FileStream.Destroy;

   MessageDlg('All Series saved to '+FileN,mtinformation,[mbok],0);

end;

procedure TEdit_Data_Form.LoadAllButtonClick(Sender: TObject);

Var FileStream : TFileStream;
    VersionCheck : String[10];
    ReadVers: Double;
    FileN: String;

Begin

  If Not PromptForFileName(FileN,'AQUATOX Observed Data File (*.AODF)|*.AODF','.AODF','Select File to Load AQUATOX Observed Data from','',False)
     then Exit;

   Try
     FileStream:=TFileStream.Create(FileN,fmOpenRead);
   Except
     MessageDlg(Exception(ExceptObject).Message,mterror,[mbOK],0);
     Exit;
   End; {Try Except}

   {Check Version #}
   FileStream.Read(VersionCheck,Sizeof(VersionCheck));
   Try
     VersionNum:=0;
     ReadVers:=StrToFloat(AbbrString(VersionCheck,' '));
     VersionNum:=StrToFloat(AbbrString(VersionStr,' '));
   Except
     MessageDlg('File is not a valid AQUATOX Observed Data File',mterror,[mbOK],0);
     FileStream.Destroy;
     Exit;
   End; {Try Except}

{   If ReadVers<VersionNum then
      MessageDlg('Converting from '+VersionCheck+' to '+VersionStr,MTInformation,[MbOK],0);

   If ReadVers>VersionNum
     then
        Begin
           MessageDlg('File Version ('+VersionCheck+') is Greater than Executable Version: Unreadable.',mterror,[mbOK],0);
           WaitDlg.Hide;
        End }

   OD.AddFromFile(True,TStream(FileStream),ReadVers);
   FileStream.Destroy;
   
   Changed := True;
   UpdateScreen(True);
   MessageDlg('Added Series from '+FileN,mtinformation,[mbok],0);

end;


procedure TEdit_Data_Form.SeriesNameEditChange(Sender: TObject);
begin
  If Updating then Exit;
  If Selected <0 then exit;
  Changed := True;
  OD.OSeries[Selected].NameStr := TEdit(Sender).Text;
  UpdateScreen(false);
end;

procedure TEdit_Data_Form.SeriesUnitEditChange(Sender: TObject);
begin
  If Updating then Exit;
  If Selected <0 then exit;
  Changed := True;
  OD.OSeries[Selected].UnitStr := TEdit(Sender).Text;
  UpdateScreen(false);
end;

procedure TEdit_Data_Form.StringGrid1Exit(Sender: TObject);
Var R,C: Integer;
    V: String;
begin
  IF EditRow < 0 then exit;
  If (Trim(ValStr) = '~') then exit;
  R := EditRow; C := EditCol; V := ValStr;
  EditRow := -1; EditCol := -1; ValStr := '~';
  Changed := True;

  If (C>1) and not (OD.OSeries[Selected].HasNDs) then inc(C);
    With OD.OSeries[Selected] do
    Case C of
      0: ObsDates[R-1] := StrtoDateTime(V);
      1: ObsVals[R-1] := StrToFloat(V);
      2: Begin If (Trim(V) = '>') then NDFlag[R-1] := 2 else IF Trim(V) = ''
                                  then NDFlag[R-1] := 0 else NDFlag[R-1] := 1; End;
      3: If Trim(V)='' then ErrMin[R-1] := NO_ERR_VAL
                       else ErrMin[R-1] := StrToFloat(V);
      4: If Trim(V)='' then ErrMax[R-1] := NO_ERR_VAL
                       else ErrMax[R-1] := StrToFloat(V);
    End;

  UpdateScreen(true);

end;

procedure TEdit_Data_Form.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var i: Integer;
begin

  If (Key = VK_DELETE)  and (ssCtrl in Shift) then
    With OD.OSeries[Selected] do
      Begin
        IF EditRow < 0 then exit;
        If NumRecs = 0 then exit;
        Dec(NumRecs);
        For i := EditRow-1 to NumRecs-1 do
          Begin
            ObsDates[i] := ObsDates [i+1];
            ObsVals[i]  := ObsVals[i+1];
            NDFlag[i]  := NDFlag[i+1];
            ErrMin[i]  := ErrMin[i+1];
            ErrMax[i]  := ErrMax[i+1];
          End;
        UpdateScreen(True);
      End;

  If (Key = VK_INSERT)  and (ssCtrl in Shift) then
    With OD.OSeries[Selected] do
      Begin
        IF EditRow < 0 then EditRow := 1;
        Inc(NumRecs);
        If NumRecs > Length(ObsDates) then AddLength;

        For i := NumRecs-2 downto EditRow-1 do
          Begin
            ObsDates[i+1] := ObsDates [i];
            ObsVals[i+1]  := ObsVals[i];
            NDFlag[i+1]  := NDFlag[i];
            ErrMin[i+1]  := ErrMin[i];
            ErrMax[i+1]  := ErrMax[i];
          End;

        ObsDates[EditRow-1] := StrToDate('1/1/2007');
        ObsVals[EditRow-1] := 0;
        ErrMin[EditRow-1] := NO_ERR_VAL;
        ErrMax[EditRow-1] := NO_ERR_VAL;
        NDFlag[EditRow-1] := 0;

        UpdateScreen(True);
      End;

end;

procedure TEdit_Data_Form.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #27 then
    Begin
      EditRow := -1; EditCol := -1; ValStr := '~';  UpdateScreen(true); CancelBtn.SetFocus;
    End;


end;

procedure TEdit_Data_Form.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  StringGrid1Exit(nil);
  EditRow := ARow;
  EditCol := ACol;
end;

procedure TEdit_Data_Form.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  If (EditRow<>ARow) or (EditCol<>ACol) Then Exit;
  ValStr  := Value;
{  EditRow := ARow;
  EditCol := ACol; }

end;

{ TObservedData }

constructor TObservedData.Create;
begin
  NumSeries := 0;
  CurrentIndex := -1000;
  OSeries := nil;
end;

destructor TObservedData.Destroy;
Var i: Integer;
begin
  For i := 0 to NumSeries-1 do
    OSeries[i].Free;
  OSeries := nil;
  inherited;
end;

Procedure TObservedData.AddFromFile(IsTemp: Boolean; var st: TStream;
  ReadVersionNum: Double);
var NumToAdd, i, Indx: Integer;

begin
  St.Read(NumToAdd, Sizeof(NumToAdd));
  St.Read(Indx, Sizeof(Indx));

  SetLength(OSeries,NumSeries+NumToAdd+2);
  For i := 0 to NumToAdd-1 do
    Begin
      OSeries[NumSeries+i] := TObservedSeries.Load(IsTemp,St,ReadVersionNum);
      Dec(CurrentIndex);
      OSeries[NumSeries+i].UniqueIndex := CurrentIndex;
    End;

  NumSeries := NumSeries + NumToAdd;
end;


constructor TObservedData.Load(IsTemp: Boolean; var st: TStream;
  ReadVersionNum: Double);
var i: Integer;
begin
  St.Read(NumSeries, Sizeof(NumSeries));
  St.Read(CurrentIndex, Sizeof(CurrentIndex));
  SetLength(OSeries,NumSeries+2);
  For i := 0 to NumSeries-1 do
    OSeries[i] := TObservedSeries.Load(IsTemp,St,ReadVersionNum);
end;

procedure TObservedData.Store(IsTemp: Boolean; var st: TStream);
var i: Integer;
begin
  St.Write(NumSeries, Sizeof(NumSeries));
  St.Write(CurrentIndex, Sizeof(CurrentIndex));

  For i := 0 to NumSeries-1 do
    OSeries[i].Store(IsTemp,St);
end;


{ TGraphs }

Procedure TGraphs.AddGraph(G: TGraphSetup);
Begin
  Inc(NumGraphs);
  If Length(GArray) < NumGraphs then
    SetLength(GArray,NumGraphs+5);
  GArray[NumGraphs-1] := G;
  SelectedGraph := NumGraphs;
End;

Procedure TGraphs.DeleteGraph(Index: Integer);
Var i: Integer;
Begin
  GArray[Index-1].Destroy;
  For i := Index-1 to NumGraphs-2 do
    GArray[i] := GArray[i+1];
  Dec(NumGraphs);
End;


constructor TGraphs.Create;
begin
  NumGraphs := 0;
  SelectedGraph := 0;
  GArray := nil;
end;

destructor TGraphs.Destroy;
Var i: Integer;
begin
  For i := 0 to NumGraphs-1 do
    If GArray[i] <> nil then GArray[i].Destroy;
  GArray := nil;
  inherited;
end;

constructor TGraphs.Load(IsTemp: Boolean; var st: TStream;
  ReadVersionNum: Double);
Var i: Integer;
begin
  St.Read(NumGraphs, Sizeof(NumGraphs));
  St.Read(SelectedGraph, Sizeof(SelectedGraph));
  SetLength(GArray,NumGraphs+5);
  For i := 0 to NumGraphs-1 do
      GArray[i] := TGraphSetup.Load(IsTemp,St,ReadVersionNum);

end;

procedure TGraphs.Store(IsTemp: Boolean; var st: TStream);
Var i: Integer;
begin
  St.Write(NumGraphs, Sizeof(NumGraphs));
  St.Write(SelectedGraph, Sizeof(SelectedGraph));
  For i := 0 to NumGraphs-1 do
    GArray[i].Store(IsTemp,St);
end;

{ TGraphSetup }

Constructor TGraphSetup.Load(IsTemp: Boolean; var st: TStream;
  ReadVersionNum: Double);

var bl: boolean;
    il: integer;

begin

   If ReadVersionNum > 3.815
    then St.Read(Data,Sizeof(Data))
     else
       Begin
         Data.RepeatPeriods := False;
         If ReadVersionNum > 3.505
           then St.Read(Data,1271)
             Else
               Begin
                 Data.Logarithmic := False;
                 If ReadVersionNum > 3.315
                   then St.Read(Data,1270)
                   else Begin St.Read(Data,1266);  Data.GraphType := 0; End;
               End;
       End;

   If ReadVersionNum < 3.715 then
      Begin
        Data.Threshold := -9999;
        Data.Left_Thresh := 1;
      End;

   If ReadVersionNum < 3.825 then
    for bl := false to true do
     for il := 1 to 20 do
      Data.LineThick[bl,il] := 2;  // 10/11/12

   SaveFont1 := TSaveFont.Create(nil);
   SaveFont2 := TSaveFont.Create(nil);
   SaveFont3 := TSaveFont.Create(nil);
   SaveFont4 := TSaveFont.Create(nil);
   St.ReadComponent(SaveFont1);
   St.ReadComponent(SaveFont2);
   St.ReadComponent(SaveFont3);
   St.ReadComponent(SaveFont4);

   If ReadVersionNum > 3.805 then
     Begin
       St.Read(Linked,Sizeof(Linked));
       If Linked then
         Begin
           LinkedGSR := TLinkedGSR.Create;
           LinkedGSR.Load(IsTemp,St,ReadVersionNum);
         End else LinkedGSR := nil;
     End else begin  {Pre 3.81}
                Linked := False; LinkedGSR := nil;
              end;
end;

procedure TGraphSetup.Store(IsTemp: Boolean; var st: TStream);
begin
   St.Write(data,sizeof(data));
   St.WriteComponent(SaveFont1);
   St.WriteComponent(SaveFont2);
   St.WriteComponent(SaveFont3);
   St.WriteComponent(SaveFont4);
   St.Write(Linked,Sizeof(Linked));
   If Linked then LinkedGSR.Store(IsTemp,St);

end;

constructor TGraphSetup.CreateEmptyGraph;
Var i: Integer;
    IsY1: Boolean;
Begin
 With data do
  Begin
    GraphName :=  'New Graph';
    For IsY1 := False to True do
     for i := 1 to 20 do
      Begin
        YItems[IsY1,i] := -99;
{        SegIDs[IsY1,i] := ''; }
        Colors[IsY1,i] := ClDefault;
        LineThick[IsY1,i] := 2;     //10/11/12
        Shapes[IsY1,i] :=  psSmallDot;
        Size[IsY1,i] := 3;
      End;

     VertGL := False;
     Y1GL := True;
     Y2GL := False;
     Graph3D := False;
     DefaultTitle:=True; DefaultX:=True;
     DefaultY1:=True; DefaultY2:=True;
     GraphTitle1 := '';
     GraphTitle2 := '';
     XLabel := '';
     Y1Label := '';
     Y2Label := '';
     VSeg := Epilimnion;
     Y1AutoScale := True;
     Y2AutoScale := True;
     Y1Min:=0; Y1Max:=0; Y2Min:=0; Y2Max:=0;
     DiffAutoScale := False;
     DiffMin := -100; DiffMax := 400;
     Use2Scales := True;
     XMin := 0; XMax:= 0;

     Threshold := -9999;
     Left_Thresh := 1;

(*   Y1Gap := -1;
     Y2Gap := -1;       {TO DO}  *)

     Y1Format := '';  Y2Format:= ''; {TO DO}

     Scenario := 1; {Perturbed}
     GraphType := 0;
  End;

  SaveFont1:= TSaveFont.Create(nil);
  SaveFont1.Font.Name := 'Arial';
  SaveFont1.Font.Size := 10;
  SaveFont1.Font.Color := clNavy;
  SaveFont1.Font.Style := [fsBold];
  SaveFont2:= TSaveFont.Create(nil);
  SaveFont3:= TSaveFont.Create(nil);
  SaveFont4:= TSaveFont.Create(nil);

End;

Destructor TGraphSetup.Destroy;
Begin
  SaveFont1.Destroy;
  SaveFont2.Destroy;
  SaveFont3.Destroy;
  SaveFont4.Destroy;
  inherited;
End;

{------------------------------------------------------------------------------}
{TLinkedGSR New 4/17/2012 to allow for graph setup screen to work with linked segments}

Constructor TLinkedGSR.CreateBlank(ns: Integer);
var i: Integer;
Begin
 nseries := 0;  // no series data yet added
 SetLength(GSRs,ns);
 For i:=0 to ns-1 do
  with GSRs[i] do
   Begin
     Color := ClDefault;
     LineThick := 2;     //10/11/12
     Shape :=  psSmallDot;
     Size  := 3;
     Suppress := False;
   End;
End;

Procedure TLinkedGSR.AddLength(num: Integer);
Var oldlen, i: Integer;
Begin
  oldlen := Length(GSRs);
  SetLength(GSRs,oldlen+num);
  For i := oldlen to oldlen+num-1 do
  with GSRs[i] do
   Begin
     Color := ClDefault;
     LineThick := 2;     //10/11/12
     Shape :=  psSmallDot;
     Size  := 3;
     Suppress := False;
   End;
End;


Constructor TLinkedGSR.Load(IsTemp: Boolean; Var st: TStream; ReadVersionNum: Double);
Var i: Integer;
Begin
  St.Read(nseries,Sizeof(nseries));
  SetLength(GSRs,nseries);
  For i:=0 to nseries-1 do
   with GSRs[i] do
     Begin
       St.Read(Color, Sizeof(Color));
       St.Read(LineThick, Sizeof(LineThick));
       If ReadVersionNum < 3.825 then LineThick := 2;     //10/11/12
       St.Read(Shape, Sizeof(Shape));
       St.Read(Size, Sizeof(Size));
       St.Read(Suppress, Sizeof(Suppress));
     End;
End;



Procedure TLinkedGSR.Store(IsTemp: Boolean; Var st: TStream);
Var i: Integer;
Begin
  St.Write(nseries,Sizeof(nseries));
  For i:=0 to nseries-1 do
   with GSRs[i] do
     Begin
       St.Write(Color, Sizeof(Color));
       St.Write(LineThick, Sizeof(LineThick));
       St.Write(Shape, Sizeof(Shape));
       St.Write(Size, Sizeof(Size));
       St.Write(Suppress, Sizeof(Suppress));
     End;

End;

Destructor TLinkedGSR.Destroy;
Begin
 GSRs := nil;
End;




end.
