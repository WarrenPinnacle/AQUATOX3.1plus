//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Unit output;

Interface


Uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, TabNotBk, StdCtrls, Buttons, DB, Wait, Comobj, LinkedSegs,
  DBTables, TeeProcs, TeEngine, Grids, chartprop, ChangVar, Variants, hh,
  Aquaobj, TCollect, Global, AQSTUDY,  GraphChc, Printers, {Prtgrid, }
  Loadings, Series, Chart, DBGrids, ComCtrls, ExtCtrls, Excel2000, 
  AQBaseForm, TeePrevi, ActiveX, DBGrids2, Observed_Data, DefaultGraphs, Menus;

Const ChartColors: Array[0..9] of TColor =
                (ClBlack, ClRed, ClGreen, ClBlue,
                 ClFuchsia, $000080FF,   ClPurple, ClOlive, ClMaroon,  ClAqua );

Const UM_AFTERACTIVE = WM_USER + 120;

Type ChartLineRec = Record
        X1,Y1: Double;
        Clr      : TColor;
        PWid, LineType, SeriesIndex: Integer;
       End;

Type TResType = Record  {Tornado Rung Record}
       Name: String;
       Neg, Pos, Sens: Double;
     End;

Type SensArray=  Array of Array of TResType;

Type
  TOutputScreen = class(TAQBase)
    OutputNotebook: TTabbedNotebook;
    Table1: TTable;
    DataSource1: TDataSource;
    dbgrid1: TDBGrid2;
    Table2: TTable;
    DataSource2: TDataSource;
    EditButt: TButton;
    ControlTitle: TLabel;
    dbgrid2: TDBGrid2;
    ChangeDBaseButt: TButton;
    UncChangeVarButt: TButton;
    DatabaseLabel: TLabel;
    OpenDialog1: TOpenDialog;
    Button8: TButton;
    Chart4: TChart;
    DGraffsetupbutton: TButton;
    DCopyClipbd: TButton;
    ContrChangeButt: TButton;
    TCVSeg: TButton;
    Bevel3: TBevel;
    PerturbLabel: TLabel;
    ChartChangeButt: TButton;
    TPVseg: TButton;
    Bevel1: TBevel;
    PerturbedNRPanel: TPanel;
    UncToggle: TButton;
    SaveToFile: TButton;
    LoadFromFile: TButton;
    Panel1: TPanel;
    ExitButton: TButton;
    CSaveExcel: TButton;
    SaveExcel: TButton;
    UncTable: TTable;
    Chart1: TChart;
    GraphListBox: TComboBox;
    NewGraph: TButton;
    ScenarioBox: TComboBox;
    ComboBox2: TComboBox;
    graphmenu: TComboBox;
    RepeatButton: TButton;
    Label1: TLabel;
    Up1: TBitBtn;
    down1: TBitBtn;
    Up2: TBitBtn;
    Down2: TBitBtn;
    DiffErrorPanel: TPanel;
    ErrLabel: TLabel;
    ErrLabel2: TLabel;
    ShowMinMax: TCheckBox;
    Down3: TBitBtn;
    Up3: TBitBtn;
    UncBox1: TComboBox;
    NumRungsEdit: TEdit;
    NumRungsLabel: TLabel;
    refreshbutt: TButton;
    ExportAll: TButton;
    ThresholdButt: TButton;
    SegBox: TComboBox;
    HelpButton: TButton;
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    Print1: TMenuItem;
    GraphSetup1: TMenuItem;
    EraseGraph1: TMenuItem;
    OtherSegment1: TMenuItem;
    Help1: TMenuItem;
    ExternalData1: TMenuItem;
    WriteSteinhaus1: TMenuItem;
    rophicStateIndices1: TMenuItem;
    ExportallMSWord1: TMenuItem;
    ArrangeGraphs1: TMenuItem;
    StatisticsfromGraph1: TMenuItem;
    Series1TheFirstSeriesinthelistanditsgood: TLineSeries;
    Series2: TLineSeries;
    ShowSens: TButton;
    ToggleSensitivity: TButton;
    Procedure UpdateDst(ControlOutput, EpiGraph,IsTable :Boolean);
    Procedure MakeVariableList(RC: TResultsCollection; N: Integer);
    procedure FormResize(Sender: TObject);
    procedure PChartbuttClick(Sender: TObject);
    procedure EditGraphClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PrntBtn2Click(Sender: TObject);
    procedure ChangeDBaseButtClick(Sender: TObject);
    procedure UncChangeVarButtClick(Sender: TObject);
    procedure UncertPrintButtClick(Sender: TObject);
    procedure SegViewClick(Sender: TObject);
    procedure ChartClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    Procedure TableChoiceChanged(ControlOutput, EpiGraph :Boolean);
    procedure BGraphSetupButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure ChartChangeButtClick(Sender: TObject);
    procedure UncToggleClick(Sender: TObject);
    procedure ChartHelpButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExitButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LoadFromFileClick(Sender: TObject);
    procedure SaveToFileClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CSaveExcelClick(Sender: TObject);
    procedure SteinhausClick(Sender: TObject);
    procedure GraphListBoxChange(Sender: TObject);
    procedure ScenarioSelect(Sender: TObject);
    procedure graphmenuChange(Sender: TObject);
    procedure NewGraphClick(Sender: TObject);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown2Changing(Sender: TObject; var AllowChange: Boolean);
    procedure Up1Click(Sender: TObject);
    procedure down1Click(Sender: TObject);
    procedure Up2Click(Sender: TObject);
    procedure Down2Click(Sender: TObject);
    procedure Chart1AfterDraw(Sender: TObject);
    procedure ShowMinMaxClick(Sender: TObject);
    procedure Chart1GetNextAxisLabel(Sender: TChartAxis; LabelIndex: Integer;
      var LabelValue: Double; var Stop: Boolean);
    procedure UncBox1Change(Sender: TObject);
    procedure Up3Click(Sender: TObject);
    procedure Down3Click(Sender: TObject);
    procedure Chart4AfterDraw(Sender: TObject);
    procedure refreshbuttClick(Sender: TObject);
    procedure ExportAllClick(Sender: TObject);
    procedure ThresholdButtClick(Sender: TObject);
    procedure graphmenuKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure graphmenuClick(Sender: TObject);
    procedure RepeatButtonClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SegBoxChange(Sender: TObject);
    procedure Chart1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Copy1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure GraphSetup1Click(Sender: TObject);
    procedure EraseGraph1Click(Sender: TObject);
    procedure OtherSegment1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure ExternalData1Click(Sender: TObject);
    procedure WriteSteinhaus1Click(Sender: TObject);
    procedure rophicStateIndices1Click(Sender: TObject);
    procedure ExportallMSWord1Click(Sender: TObject);
    procedure ArrangeGraphs1Click(Sender: TObject);
    procedure StatisticsfromGraph1Click(Sender: TObject);
    procedure ShowSensClick(Sender: TObject);
    procedure ToggleSensitivityClick(Sender: TObject);
  protected
    procedure UMAfterActive(var Message: TMessage); message UM_AFTERACTIVE;
  private
    VUnc_Dir,VUnc_File,VUnc_Ext: ShortString;
    RowLabels, ColLabels : TStringList;

    Unc_Index: Integer;
    FirstShow: Boolean;
    UpdatingScreen: Boolean;
    LeftAxisItems, RightAxisItems  : Boolean;
    ThreshResults: TStringList;
    ChartLines: Array of ChartLineRec;
    NCL       : Integer;
    {Tornado Data Structures}
    EffectArr, TornArr: SensArray;
    BaseCaseArr: Array of Double;
    NumTRes: Array of Integer;
    NumEffects: Integer;
    ExecuteMenu: Boolean;
    ListBoxIDs: TListBoxIDs;
    procedure ChangeBioVars;
    procedure Update_UncertGraph;
    procedure Draw_Bio_Risk_Graph;
    procedure EraseCurrentGraph;
    procedure ReturnCSVName(Var FileN: String);
    Procedure Load_BioDat;
    Procedure CreateGraphList;
    Procedure ToggleSegment;
    Procedure ShowChosenGraph;
    Procedure ShowDiffGraph;
    Procedure GraphSetupChoose;
  public
    MainStudy: TAQUATOXSegment;
    GSRStudy, OutputStudy: TAQUATOXSegment;  {GSR Holds the Graph Setup Record, OutputStudy is the study or sample study in linked mode}
    ALL_SEGS: Boolean;
    MainLinkedS, LinkedS : TLinkedSegs;
    Changed : TDateTime;
    SensGraph, BioRiskGraph, BioDatLoaded: Boolean;
    SensPercent: Double;
    ShowEffects: Boolean;  {show alternative sensitivity diagrams?}
    Decline: Array of Array of Double;
    DeclName: Array of String;
    ShowDecline: Array of Boolean;
    EpiString, HypString: String;
    GraphIDs: Array[1..20,False..True,False..True] of LongInt;
    Constructor Create(AOwner: TComponent; Study, MainS: TAQUATOXSegment; LS, MLS: TLinkedSegs); reintroduce;
    Procedure InitializeChart(RC: TResultsCollection);
    Procedure DisplayResults(S: TAQUATOXSegment);
    Procedure CreateDefaultGraph(Control: Boolean);
    Procedure ExportGraphsToWord(Cntrl: Boolean);
    procedure Draw_Tornado(Index: Integer);
    procedure Setup_Tornado;
    Procedure ExternalData;
    Procedure CalcTSIs;
    Procedure CalcStatistics;
    Procedure OrganizeGraphs;
    Procedure QuickSort(var A: array of Double; iLo, iHi: Integer);
    Function DefaultTitles(Line:Integer; Ctrl: Boolean; Seg:VerticalSegments): String;
  end;

var
  OutputScreen: TOutputScreen;

implementation

uses graphchoice2, Study_io, Parent, Basins, GraphSetup, AQTOpenDialog, TeCanvas, copyclip,
     TSI_Calc, ExcelFuncs, DrawThresh, math, Stat_Calc, GraphArrange,StrUtils, ShellAPI;

{$R *.DFM}

function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..254] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;


{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}


Procedure TOutputScreen.EraseCurrentGraph;
Begin
  If MessageDlg('Erase Current Graph?',mtconfirmation,[mbok,mbcancel],0) = MRCancel then exit;

  GSRStudy.SV.Graphs.DeleteGraph(GraphListBox.ItemIndex+1);
  GSRStudy.SV.Graphs.SelectedGraph := 0;
  CreateGraphList;
  Changed := Now;
  ShowChosenGraph;
End;

procedure TOutputScreen.EraseGraph1Click(Sender: TObject);
begin
  EraseCurrentGraph;
end;

procedure TOutputScreen.UMAfterActive(var Message: TMessage);
begin
  ParentForm.UpdateMenu(nil);
end;


Procedure TOutputScreen.CreateDefaultGraph(Control: Boolean);
Var NewGraphSetup: TGraphSetup;
    PRC: TResultsCollection;

Begin
  If Control then PRC := OutputStudy.SV.ControlResults[Epilimnion]
             else PRC := OutputStudy.SV.Results[Epilimnion];

  NewGraphSetup := MakeDefaultGraph(3,PRC, All_Segs);

  GSRStudy.SV.Graphs.AddGraph(NewGraphSetup);

End;

{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

procedure TOutputScreen.ExportallMSWord1Click(Sender: TObject);
begin
  ExportGraphsToWord(ScenarioBox.ItemIndex=0);
         WordInitialized := False;
end;

Procedure TOutputScreen.ExportGraphsToWord(Cntrl: Boolean);
var
  Range: Variant;
  NumPars: Integer;
  Loop: Integer;

        Procedure AddandSelect;
        Begin
        WordApp.Documents.Item(1).Paragraphs.Add;
        NumPars := WordApp.Documents.Item(1).Paragraphs.Count;
        Range := WordApp.Documents.Item(1).Range(
            WordApp.Documents.Item(1).Paragraphs.Item(NumPars).Range.Start,
            WordApp.Documents.Item(1).Paragraphs.Item(NumPars).Range.End);
        End;


Begin
   If not WordInitialized then
      Begin
        try
          WordApp := GetActiveOLEObject('Word.Application');
        except
          WordApp := CreateOLEObject('Word.Application');
        end;
        WordApp.Visible := True;
        WordApp.Documents.Add;
        WordApp.Documents.Item(1).Paragraphs.Add;
        WordInitialized := True;
      End;

      If Cntrl then ScenarioBox.ItemIndex := 0
               else ScenarioBox.ItemIndex := 1;

      For Loop := 0 to GraphListBox.Items.Count-1 do
        Begin
          GraphListBox.ItemIndex := Loop;
          ShowChosenGraph;
          Chart1.CopytoClipBoardMetaFile(True);

          NumPars := WordApp.Documents.Item(1).Paragraphs.Count;
          WordApp.Documents.Item(1).Paragraphs.Add;
          WordApp.Documents.Item(1).Paragraphs.Add;
          WordApp.Documents.Item(1).Paragraphs.Add;

          Range := WordApp.Documents.Item(1).Range(
          WordApp.Documents.Item(1).Paragraphs.Item(NumPars + 2).Range.Start,
          WordApp.Documents.Item(1).Paragraphs.Item(NumPars + 2).Range.End);
          Range.Paste;

{          WordApp.Documents.Item(1).Paragraphs.Add;
          AddAndSelect;
          Range.Text := MakeFileName;
          AddAndSelect;
          Range.Text := DateTimeToStr(Now()); }
        End;
End;

{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

Constructor TOutputScreen.Create(AOwner: TComponent; Study, MainS: TAQUATOXSegment; LS, MLS: TLinkedSegs);
Begin
  MainStudy := MainS;
  OutputStudy := Study;
  GSRStudy := Study;
  LinkedS := LS;
  MainLinkedS := MLS;
  ChartLines := nil;
  NCL := 0;
  ALL_SEGS := LS<>nil;
  If All_Segs then OutputStudy := LS.SegmentColl.At(0);

  Inherited Create(AOwner);
End;

Procedure TOutputScreen.InitializeChart(RC: TResultsCollection);
Var Loop      : Integer;
    PH        : TResHeader;
Begin
   {Clear the graphing choice dialog}
   GraphChoiceDlg.SourceList.Clear;
   GraphChoiceDlg.DstList.Clear;

   If RC.Count<1 then exit;
   If RC.Count>20 then exit;  {takes too long to display default results in this case}

   For Loop:= 0 to RC.Headers.Count-1 do
     Begin
       PH := RC.Headers.At(Loop);
       If (PH.SVType=StV) and (not PH.RateVar) then
         GraphChoiceDlg.DstList.Items.Add(PH.ListStr(False));
       If All_Segs then
         If ((GraphChoiceDlg.DstList.Count+1) * LinkedS.SegmentColl.Count) > 200 then exit;
     End;
End;

{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

Procedure TOutputScreen.CreateGraphList;
Var i: Integer;
    perturbed_empty: boolean;
Begin
  UpdatingScreen := True;
  GraphListBox.Items.Clear;
  perturbed_empty := OutputStudy.SV.Results[Epilimnion].Count=0;

  With GSRStudy.SV.Graphs do
    Begin
      If NumGraphs = 0 then CreateDefaultGraph(Perturbed_Empty);
      For i := 1 to NumGraphs do
        GraphListBox.Items.Add(GArray[i-1].data.GraphName);

      If SelectedGraph = 0 then SelectedGraph := 1;
      GraphListBox.ItemIndex := SelectedGraph-1;
    End;

  If ScenarioBox.ItemIndex = -1 then
    If Perturbed_Empty then ScenarioBox.ItemIndex := 0
                       else ScenarioBox.ItemIndex := 1;
  UpdatingScreen := False;

End;

    {---------------------------------------------------------------------}
    Function Float2Text(Var CString: String; Val: Extended): String;
    Var PC1,PC2:  Array[0..100] of Char;
        i: Integer;
    Begin
      For i:=0 to 100 do
        PC1[i] := #0;
      StrPCopy(PC2,CString);
      FloatToTextFmt(PC1,Val,fvExtended,PC2);
      Float2Text := StrPas(PC1);
    End;
    {---------------------------------------------------------------------}
    Function SetCString(B,S: Double; Logaxis: Boolean): String;  {big, small number}
    Var i, NumDigits: Integer;
        ND1, ND2 : Double;  S1,S2: String;
    Begin
       If Logaxis then
         Begin
           If (S < 0.001) or (B > 1000) then Result := '0.0E+0'
                                        else Result := '###0.0##';
           Exit;
         End;

       If (B<=0) or (B-S<=0)
         then Begin Result := '#0.0'; Exit; End;
       ND1 := Log10(B)-Log10(B-S)+1;
       {If S>0 then ND2 := Log10(B)-Log10(S)
              else }ND2 := Log10(B);
       NumDigits := ROUND(Max(ND1+0.3,ND2+0.3));

       If NumDigits<1 then NumDigits := 1;  If NumDigits>8 then NumDigits := 8;
       If B < 0.02 then Begin
                          Result := '0.00';
                          For i := 3 to NumDigits do
                            Result := Result + '0';
                          Result := Result + 'E+00';
                        End
                   else Begin
                          If Round(Log10(B))<0 then Result := '0.0'
                                             else Result := '#';
                          For i:= Round(Log10(B)) downto Round(Log10(B))-NumDigits+1 do
                            Begin
                              If (i=0) then Result := Result+'0.0'
                                else If i>0 then Result := Result + '#'
                                            else Result := Result + '0';
                            End;

                          S1 := Float2Text(Result,S);  S2 := Float2Text(Result, S+0.08*(B-S));
                          If S1 = S2
                            then If pos('.',Result) = 0
                              then Result := Result + '.0'
                              else Result := Result + '0';

                          If B>1e6 then Result := Result +',';
                          If B>1e9 then Result := '0.00E+00';

                          If Result = '##' then Result := '##.0';
                        End;

    End;
    {---------------------------------------------------------------------}
    Function SetInterval(B,S: Double): Double;
    Var Intv, Intv2, Dig: Double;
    Begin
      Intv := (B-S) / 10;
      Dig := Trunc(Log10(Intv))-1;
      Intv2 := Round(Intv * POWER(10,-Dig));
      SetInterval := Intv2 * POWER(10,Dig);
    End;
    {---------------------------------------------------------------------}


Function TOutputScreen.DefaultTitles(Line:Integer; Ctrl: Boolean; Seg:VerticalSegments): String;
Var    RunDate    : TDateTime;
       StudyName, LastRunStr : String;
       HypExists: Boolean;
Begin

  If Ctrl then HypExists := OutputStudy.SV.ControlResults[Hypolimnion].Count > 0
          else HypExists := OutputStudy.SV.Results[Hypolimnion].Count > 0;

      If All_Segs
       then
        Begin
          If Ctrl then RunDate := LinkedS.ControlRun
                  else RunDate := LinkedS.LastRun;
          StudyName := LinkedS.SystemName;
        End
       else
        Begin
          If Ctrl then RunDate := OutputStudy.ControlRun
                  else RunDate := OutputStudy.LastRun;
          StudyName := OutputStudy.StudyName;
        End;

             If RunDate = -1 then LastRunStr:='No Results Attached'
        else If RunDate = -2 then LastRunStr:='Partial Run Only'
        else begin
               DateTimeToString(LastRunStr,'mm-d-y t',RunDate);
               LastRunStr := 'Run on '+LastRunStr;
             end; {if}

       If HypExists then
         Begin
           If Line = 1 then
             If Ctrl then Result := (StudyName + ' (Control)  ' + LastRunStr)
                     else Result := (StudyName + ' (PERTURBED)  '+LastRunStr);
           If Line = 2 then
             If Seg=Epilimnion then Result := ('('+EpiString+' Segment)')
                               else Result := ('('+HypString+' Segment)');
         End
       else  //not hypexists
         Begin
           If Line = 1 then
             If Ctrl then Result := (StudyName + ' (Control)')
                     else Result := (StudyName + ' (PERTURBED)');
           If Line = 2 then Result :=(LastRunStr)
         End;
End;

{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}
Procedure TOutputScreen.ShowChosenGraph;
{ This procedure sends the appropriate variables and their data to the
  graphing component, depending on what is shown in the dialog }

Var NumValues             : Integer;
    L,Loop,InnerLoop,j    : Integer;
    Results               : TResultsCollection;
    PH                    : TResHeader;
    CurrResults           : TResults;
    XMin2, XMax2          : Double;  // for annual averaging
    Dy, Mo, Yr, Dy2, Mo2, Yr2: Word;
    IsY1, Found, Control, ObservedWarned : Boolean;
    Drawit, DrawitBottom,CtrRes : Boolean;
    HypExists, InsertedLine     : Boolean;
    ScatterPlot                 : Boolean;
    EndDate, StartDate, Duratn, Number  : Double;
    Big, Small            : Array[False..True] of Double;
    UnitSav               : Array[False..True] of String;
    Chart                 : TChart;
    Seg                   : VerticalSegments;
    NewSeries             : TLineSeries;
    NumSegs, ResultID     : Integer;
    GSR                   : TGraphSetup;
    SeriesIndex, LegendIndex : Integer;
    LastRunStr, CString   : String;
    WorkingSeg            : TAQUATOXSegment;
    DataArray             : Array of Double;  {for manipulations, for special graphs, etc.}

    {---------------------------------------------------------------------}
    Procedure SetupButtons;
    Begin
      PerturbedNRPanel.Visible := (NumValues=0) and (Seg=Epilimnion);
      NewGraph.Visible         := (NumValues>0);
      EditButt.Visible         := (NumValues>0);
      Chart1.Visible           := (NumValues>0);
    End; {Setup Buttons}
    {---------------------------------------------------------------------}
    Procedure AddLogTick(iny: Double; LeftAxis: Boolean);
    Var FoundAxis: Boolean;
    Begin   {add tick marks to log plot}
      Inc(NCL);
      If Length(ChartLines) < NCL then
        SetLength(ChartLines,NCL+15);

      With ChartLines[NCL-1] do
        Begin
          If LeftAxis then LineType := 4
                      else LineType := 5;
          PWid := 1;
          Chart1.Update;         // 4/30/2012 ensure min and max for bottom axis set prior to using those values.
          With Chart1.BottomAxis do
          If LeftAxis then X1 := Minimum
                      else X1 := Maximum ;
          Y1 := iny;
          Clr := ClBlack;

          SeriesIndex := -1;     // Set relevent SeriesIndex within ChartLines
          FoundAxis := False;
          Repeat
            Inc(SeriesIndex);
            If (LeftAxis and (Chart1.Series[SeriesIndex].VertAxis = aLeftAxis)) or
               (not LeftAxis and (Chart1.Series[SeriesIndex].VertAxis = aRightAxis)) then
                 FoundAxis := True;
          Until FoundAxis or (SeriesIndex=Chart1.SeriesCount);
        End;
    End;
    {---------------------------------------------------------------------}
    Procedure AddCLR(inx,iny: Double; Cl: TColor; LT, PW: Integer);
    Begin   {add hand-drawn elements drawn on afterchartdraw}
      Inc(NCL);
      If Length(ChartLines) < NCL then
        SetLength(ChartLines,NCL+15);
      With ChartLines[NCL-1] do
        Begin
          LineType := LT;
          PWid := PW;
          X1 := inx;
          Y1 := iny;
          Clr := Cl;
          SeriesIndex := Chart1.SeriesCount;
        End;
    End;
    {---------------------------------------------------------------------}
    Procedure DrawLine(XVal, YVal: Double; X1,Y1,X2,Y2 : Integer; PS: TPointSeries; LS: TLineSeries);
    Const XUnt = 2;
          YUnt = 0.1;
    Begin
      LS.AddXY(XVal+X1*XUnt,YVal+Y1*YUnt,'',clnone);
      LS.AddXY(XVal+X1*XUnt,YVal+Y1*YUnt,'',clblack);
      LS.AddXY(XVal+X2*XUnt,YVal+Y2*YUnt,'',clblack);
      LS.AddXY(XVal+X2*XUnt,YVal+Y2*YUnt,'',clnone);
    End;
    {---------------------------------------------------------------------}
    Procedure Produce_Exceedance_Graph(top: Integer; SName: String);
    Var i: Integer;
        xval: Double;
        ThreshVal: Integer;
        CalcThresh: Boolean;
        ExceedStr: String;

    Begin
      If top<0 then exit;
      ThresholdButt.Visible := True;
      With GSR.Data do
        CalcThresh := ((IsY1 and (Left_Thresh=1)) or (Not IsY1 and (Left_Thresh=0))) and (Threshold<>-9999);
      ThreshVal := Top+1;

      QuickSort(DataArray,0,top);
      For i := top downto 0 do
        Begin
          If GSR.data.graphtype = 1
            then XVal := (top-i+1)/(top+1)*100  {percentage}
            else XVal := (top-i+1)/(top+1)* (Duratn);
          NewSeries.AddXY( XVal ,DataArray[i],'',clteecolor); {plot x,y}

          If CalcThresh then
            If DataArray[i] > GSR.Data.Threshold then ThreshVal := i;
        End;

      If CalcThresh then
        Begin
          If GSR.data.graphtype = 1 {percentage}
            then ExceedStr := FloatToStrF(((top-ThreshVal+1)/(top+1)*100),fffixed,6,1) + '% of the time.'
            else Exceedstr := FloatToStrF(((top-ThreshVal+1)/(top+1)*Duratn),fffixed,6,1) +
                             ' out of ' +FloatToStrF(Duratn,fffixed,6,1)+ ' days.';
          ThreshResults.Add(SName+' is exceeded '+ExceedStr);
        End;
    End;
    {---------------------------------------------------------------------}
    Procedure DrawBar(XVal, YVal, Yerr: Double; LS: TLineSeries);
    Begin
{      LS.AddXY(XVal-Tiny,YVal,'',clnone);}
      LS.AddXY(XVal,YVal,'',clTeeColor);
      LS.AddXY(XVal,YErr,'',clTeeColor);
      LS.AddXY(XVal+Tiny,YErr,'',clnone);
    End;
    {---------------------------------------------------------------------}


    Procedure DrawErrBars(ObsIndex: Integer; PS: TPointSeries);
    Var k: Integer;
        TOD: TObservedData;
        LS: TLineSeries;
    Begin
       LS := TLineSeries.Create(Chart1);
       LS.Pointer.visible:=True;
       LS.ShowInLegend := False;
       LS.LinePen.Width := 2;
       LS.LinePen.Color := clblack;
       LS.SeriesColor := clblack;
       LS.Pointer.Style := psSmallDot;
       LS.VertAxis := PS.VertAxis;
       Inc(SeriesIndex);

       TOD := MainStudy.SV.ObservedData;
       With TOD.OSeries[OBsIndex] do
        For k := 0 to TOD.OSeries[ObsIndex].NumRecs-1 do
          begin
            If (GSR.data.XMin=0) or (GSR.data.XMax=0) or
               ((TRUNC(ObsDates[k]) >= GSR.data.XMin) and
                (TRUNC(ObsDates[k]) <= GSR.data.XMax)) then
                 Begin
                   If (ErrMin[k] <> NO_ERR_VAL)
                    then Begin
                           DrawBar(ObsDates[k],ObsVals[k],Errmin[k],LS);
                           AddCLR(ObsDates[k],ErrMin[k],Clblack,1,2);   {add "hand-drawn" elements for on afterdraw}
                         End;
                   If (ErrMax[k] <> NO_ERR_VAL)
                    then Begin
                           DrawBar(ObsDates[k],ObsVals[k],ErrMax[k],LS);
                           AddCLR(ObsDates[k],ErrMax[k],Clblack,1,2);   {add "hand-drawn" elements for on afterdraw}
                         End;
                 End;

          end;

       Chart1.AddSeries(LS);
    End;
    {---------------------------------------------------------------------}
    Procedure DrawThreshold;
    Var LS: TLineSeries;
        XMax: Double;

    Begin
      If (GSR.Data.Threshold <> -9999) and (GSR.Data.GraphType in [1,2]) then
        Begin
           LS := TLineSeries.Create(Chart1);
           LS.Pointer.visible:=True;
           LS.ShowInLegend := True;
           LS.LinePen.Width := 2;
           LS.LinePen.Color := clblack;
           LS.SeriesColor := clblack;
           LS.Pointer.Style := psSmallDot;
           If GSR.Data.Left_Thresh=1 then LS.VertAxis := aLeftAxis
                                     else LS.VertAxis := aRightAxis;
           LS.Name := 'Threshold';
           Inc(SeriesIndex);
           If GSR.Data.Graphtype = 1 then XMax := 100
                                     else XMax := Duratn;
           LS.AddXY(0,GSR.Data.Threshold,'',clTeeColor);
           LS.AddXY(XMax,GSR.Data.Threshold,'',clTeeColor);
           Chart1.AddSeries(LS);
        End;
    End;

    {---------------------------------------------------------------------}
      Procedure CalcDuratn;         // 4/26/2012 Allow for seasonal averaging, JSC
      Var NumYrs: Integer;  TimePerYear, Extra: Double;
      Begin
        Duratn := EndDate - StartDate + 1;
        With GSR.data do
         If (GraphType = 2) and RepeatPeriods then
            Begin
              DecodeDate(XMax,Yr,Mo,Dy);
              DecodeDate(XMin,Yr2,Mo2,Dy2);
              NumYrs := Yr-Yr2+1;
              TimePerYear := EncodeDate(Yr, Mo,Dy) - EncodeDate(Yr, Mo2,Dy2) + 1 ;
              Duratn := TimePerYear * NumYrs;

              // Special cases where simulation dates start or end in the middle of the repeating period
              DecodeDate(StartDate,Yr,Mo,Dy);
              DecodeDate(XMin,Yr2,Mo2,Dy2);
              Extra := EncodeDate(Yr, Mo,Dy) - EncodeDate(Yr, Mo2,Dy2) ;
              If Extra>0 then Duratn := Duratn - Extra;

              DecodeDate(EndDate,Yr,Mo,Dy);
              DecodeDate(XMax,Yr2,Mo2,Dy2);
              Extra := EncodeDate(Yr, Mo2,Dy2) - EncodeDate(Yr, Mo,Dy) ;
              If Extra>0 then Duratn := Duratn - Extra;
            End;
      End;

    {---------------------------------------------------------------------}
      Procedure XMinMax2(indate: Double);         // 4/26/2012 Allow for seasonal averaging, JSC
      Begin
        XMin2 := GSR.data.XMin;
        XMax2 := GSR.data.XMax;
        With GSR.data do
           If (GraphType in [1,2]) and RepeatPeriods then
            Begin
              DecodeDate(indate,Yr,Mo,Dy);
              If XMin2>0 then
                Begin
                  DecodeDate(XMin2,Yr2,Mo2,Dy2);
                  XMin2 := EncodeDate(Yr, Mo2,Dy2);
                End;
              If XMax2>0 then
                Begin
                  DecodeDate(XMax2,Yr2,Mo2,Dy2);
                  XMax2 := EncodeDate(Yr, Mo2,Dy2);
                End;
            End;
      End;
    {---------------------------------------------------------------------}

    Procedure AddObservedData(Y1:Boolean; Index: Integer);
    Var NumToSave,j,k : Integer;
        TOD: TObservedData;
        PS : TPointSeries;
        CS  : TCustomSeries;
        ChosenColor, ShowColor: TColor;
        FoundErrs: Boolean;
    Begin
   {Set the data on the graph}
      If MainStudy = nil then exit;  {No observed data output when main window's been shut.}
      TOD := MainStudy.SV.ObservedData;
       For j := 0 to TOD.NumSeries-1 do
        If GSR.Data.YItems[Y1,Index] = TOD.OSeries[j].UniqueIndex then
          With TOD.OSeries[j] do
           Begin
             If GSR.Data.GraphType=3 then
               Begin
                 If Not ObservedWarned then
                 MessageDlg('Scatter plots are not enabled for observed data.'
                            ,MTWarning,[MBOK],0);
                 ObservedWarned := True;
                 Exit;
               End;

             If GSR.Data.GraphType=2 then
               Begin
                 If Not ObservedWarned then
                   MessageDlg('Within AQUATOX observed data are not treated as continuous; a duration graph cannot be plotted using observed data.'
                              ,MTWarning,[MBOK],0);
                 ObservedWarned := True;
                 Exit;
               End;

             CS := nil;  PS := nil;
             If GSR.Data.GraphType = 0 then
               Begin
                 PS := TPointSeries.Create(Chart);
                 CS  := PS;
               End;

             If GSR.Data.GraphType = 1 then
               Begin
                 NewSeries := TLineSeries.Create(Chart);
                 CS  := NewSeries;
               End;

             Inc(SeriesIndex);
             Inc(LegendIndex);

             CS.Pointer.visible:=True;

             If All_Segs and (GSR.LinkedGSR.nseries < LegendIndex) then GSR.LinkedGSR.nseries := LegendIndex;
             If All_Segs and (Length(GSR.LinkedGSR.GSRs) < LegendIndex) then GSR.LinkedGSR.AddLength(100);

             If ALL_Segs then with GSR.LinkedGSR.GSRs[LegendIndex-1] do
               Begin
                 CS.Pointer.VertSize := Size;
                 CS.Pointer.HorizSize := Size;
                 CS.Pointer.Style := Shape;
                 CS.LinePen.Width := LineThick;
                 CS.Visible := not Suppress;
               End
             else
               Begin
                 CS.Pointer.VertSize := GSR.data.Size[Y1,Index];
                 CS.Pointer.HorizSize := GSR.data.Size[Y1,Index];
                 CS.Pointer.Style := GSR.data.Shapes[Y1,Index];
                 CS.LinePen.Width := GSR.data.LineThick[Y1,Index];
               End;

             If (GSR.Data.GraphType = 0) then
               If CS.Pointer.Style = psSmallDot then CS.Pointer.Style := psCircle;

             FoundErrs := False;
//             EndDate   := -1e9;
//             StartDate :=  1e9;
             If not Scatterplot and (GSR.Data.GraphType>0) and (Length(DataArray) < TOD.OSeries[j].NumRecs) then
                SetLength(DataArray,NumRecs);  {array for manipulation}

             NumToSave := 0;
             For k := 0 to NumRecs-1 do
               begin
                  XMinMax2(ObsDates[k]);                           // 4/26/2012 Allow for seasonal averaging, JSC
                  If (XMin2=0) or (XMax2=0) or
                     ((TRUNC(ObsDates[k]) >= XMin2) and
                      (TRUNC(ObsDates[k]) <= XMax2)) then
                       Begin
                         If HasNDs and (NDFlag[k] > 0)
                                   then Begin ShowColor := Clteecolor;     // JSC 4/30/2012
                                              AddCLR(ObsDates[k],ObsVals[k],ClRed,NDFlag[k]+1,1);
                                        End
                                   else ShowColor := Clteecolor;

                         If HasErrors and ((ErrMin[k] <> NO_ERR_VAL) or
                                           (ErrMin[k] <> NO_ERR_VAL))
                                   then FoundErrs := True;

                        Inc(NumToSave);
                        If GSR.Data.GraphType>0
                            then DataArray[NumToSave-1] := ObsVals[k]  {save results for manipulation & plotting}
                            else PS.AddXY(ObsDates[k],ObsVals[k],'',ShowColor);

//                         If (ObsDates[k]<StartDate) then StartDate := ObsDates[k]; {start and end dates for duration graph}
//                         If (ObsDates[k]>EndDate)   then EndDate   := ObsDates[k];
                         If ObsVals[k] > Big[Y1]   then Big[Y1]   := ObsVals[k];
                         If ObsVals[k] < Small[Y1] then Small[Y1] := ObsVals[k];
                       end;
                end;
//             CalcDuratn;

             If ALL_Segs then chosencolor := GSR.LinkedGSR.GSRs[LegendIndex-1].Color
                         else chosencolor := GSR.data.Colors[Y1,Index];
             If chosencolor = ClDefault
               then CS.SeriesColor:=ChartColors[LegendIndex mod 10]
               else CS.SeriesColor:=chosencolor;

             If Y1 then CS.VertAxis := aLeftAxis
                   else CS.VertAxis := aRightAxis;
             CS.Pointer.InflateMargins := True;

             CS.Title := NameStr+' ('+UnitStr+')';

             If (GSR.data.GraphType=0) and FoundErrs then DrawErrBars(j,PS);
             If (GSR.data.Graphtype=1) then Produce_Exceedance_Graph(NumToSave-1,NameStr);
             Chart.AddSeries(CS);
             GSR.data.IsShowing[Y1,Index] := True;
           End;
    End; {AddObservedData}
    {---------------------------------------------------------------------}
    Procedure SETUP_CHART;
    Begin
      InsertedLine := False;
    With GSR.data do With Chart do
      Begin
        LeftAxis.Grid.Visible := Y1GL;
        RightAxis.Grid.Visible := Y2GL;

        View3D := Graph3D;
        BottomAxis.grid.Visible := VertGL;

        Title.Font := TTeeFont(GSR.SaveFont1.Font);
        BottomAxis.Title.Font := TTeeFont(GSR.SaveFont2.Font);
        LeftAxis.Title.Font := TTeeFont(GSR.SaveFont3.Font);
        RightAxis.Title.Font := TTeeFont(GSR.SaveFont4.Font);
      End;

     {Clear the graph}
     While Chart.SeriesCount>0 do Chart.Series[0].Free;

    End; {SETUP_CHART}
    {---------------------------------------------------------------------}
    Procedure SetLogAxis(Axis: TChartAxis; AName: String);
    Var Min, Max, mini,maxi: Double;
        a,b: Integer;
    Begin
      If Axis.Visible then
        Begin
          Try
            Axis.Logarithmic := True;
          Except
            MessageDlg('Log Plot Not Possible on'+Aname+'Axis due to negative or zero values',mterror,[mbok],0);
            Exit;
          End;

          IF Axis.Minimum > 0 then Begin
                                     If Log10(Axis.Minimum)<0
                                       then Min := POWER(10,Trunc(Log10(Axis.Minimum))-1)
                                       else Min := POWER(10,Trunc(Log10(Axis.Minimum)));
                                   End
                              else Min := 0.1;
          IF Axis.Maximum > 0 then Max := POWER(10,Trunc(Log10(Axis.Maximum)))
                              else Max := 100;

          If Max < Axis.Maximum then Max := POWER(10,Trunc(Log10(Axis.Maximum)+1));
          Axis.Grid.Visible := False;
          Axis.TickOnLabelsOnly := True;
          Axis.SetMinMax(Min, Max);
          Axis.Increment := Max;

          For a:=Round(Log10(Min)) to Round(Log10(Max))-1 do
           Begin
            Mini := POWER(10,a);
            Maxi := POWER(10,a+1);
            For b := 0 to 9 do
              AddLogTick(Mini + ((Maxi-Mini)/9)*b,Axis=Chart1.LeftAxis );
           End;
        End;
    End;
    {---------------------------------------------------------------------}
    Procedure INSERT_BLANK_LINE;
    Begin
       If InsertedLine or ScatterPlot or (not Drawit) then Exit;
       InsertedLine := True;
       NewSeries := TLineSeries.Create(Chart);
       NewSeries.Pointer.visible:=True;
       NewSeries.Title := '  ';

       NewSeries.Pointer.Style:=psSmallDot;
       NewSeries.Pointer.VertSize := 1;
       NewSeries.Pointer.HorizSize := 1;
       NewSeries.SeriesColor:=ClNone;
       Chart.AddSeries(NewSeries);
    End;
    {---------------------------------------------------------------------}
    Procedure SET_CHART_TITLES;
    Begin
       Chart.Title.Text.Clear;
       With GSR.Data do With Chart do
         Begin
           If DefaultTitle then
             Begin
              Title.Text.Add(DefaultTitles(1,Control,Seg));
              Title.Text.Add(DefaultTitles(2,Control,Seg));
            End
        else Begin
               Title.Text.Add(GraphTitle1);
               Title.Text.Add(GraphTitle2);
             End;
       End;
    End;

    {---------------------------------------------------------------------}

Var XPointIndex, NumToSave, SegLoop: Integer;
    XVal, Range: Double;
    chosencolor: TColor;
    Y1Var: Boolean;
    XCaption : String;
Begin  {ShowChosenGraph}

  ThresholdButt.Visible := False;
  XCaption:='';
  NCL := 0;  XPointIndex := 0;
  WorkingSeg := nil;
  DataArray  := nil;
  LeftAxisItems := False;
  RightAxisItems := False;
  ObservedWarned := False;
  ThreshResults.Clear;

  If GraphListBox.ItemIndex = -1 then exit;
  GSR := GSRStudy.SV.Graphs.GArray[GraphListBox.ItemIndex];
  Seg := GSR.data.VSeg;
  Chart := Chart1;
  ScatterPlot := (GSR.data.GraphType=3);
  If ScatterPlot then GSR.data.Logarithmic := False;

  SETUP_CHART;

  With Chart do Begin

  Control := ScenarioBox.ItemIndex = 0;
  If ScenarioBox.ItemIndex = 2 then Begin ShowDiffGraph; Exit; End;

  DiffErrorPanel.Visible := False;

  If Control then Results := OutputStudy.SV.ControlResults[Seg]
             else Results := OutputStudy.SV.Results[Seg];

  NumValues := Results.Count;

  SetupButtons;
  SeriesIndex := 0;
  LegendIndex := 0;

  If All_Segs then NumSegs := LinkedS.SegmentColl.Count
              else NumSegs := 1;

  If All_Segs and (GSR.LinkedGSR = nil) then
    Begin
      GSR.LinkedGSR := TLinkedGSR.CreateBlank(100);
      GSR.Linked := True;
    End;

  If GSR.data.AutoScaleAll then DrawitBottom := False
                           else DrawitBottom := True;

  For IsY1 := True downto False do
   Begin
    Big[IsY1 ] := -1e99;
    Small[IsY1] := 1e99;
   End;

  For Drawit := DrawitBottom to True do
  For IsY1 := True downto False do
   Begin
    UnitSav[IsY1] := '';
    For Loop := 1 to 20 do
     Begin
      For SegLoop := 1 to NumSegs do
       Begin
        If SegLoop = 1 then GSR.data.IsShowing[IsY1,Loop] := False;
        If (GSR.data.YItems[IsY1,Loop]<>-99) {and (NumValues>0) }
         then
          Begin
            Found:=False;
            ResultID := GSR.data.YItems[IsY1,Loop];

            If Not Drawit then CtrRes := not Control
                          else CtrRes := Control;
            If All_Segs
              then
                Begin
                  WorkingSeg := LinkedS.SegmentColl.At(SegLoop-1);
                  If CtrRes then Results := WorkingSeg.SV.ControlResults[Epilimnion]
                            else Results := WorkingSeg.SV.Results[Epilimnion];
                  If WorkingSeg.SV.Location.SiteType = TribInput then Continue; {Output irrelevant for tributary-input segments}
                End
              else
                If CtrRes then Results := OutputStudy.SV.ControlResults[Seg]
                          else Results := OutputStudy.SV.Results[Seg];
            NumValues := Results.Count;

            PH := nil;
            L := 0;
            For InnerLoop:=0 to Results.Headers.Count-1 do
               Begin
                 PH := Results.Headers.At(InnerLoop);
                 If ResultID = PH.SortIndex
                      then begin
                             Found:=true;
                             L := PH.PointIndex;
                             If UnitSav[IsY1] = ''
                               then UnitSav[IsY1] := PH.UnitStr
                               else If UnitSav[IsY1] <> PH.UnitStr
                                 then UnitSav[IsY1] := 'multiple units';
                             Break;
                           End;
               End; {InnerLoop}

            If (GSR.data.Use2Scales) and (Not IsY1) then INSERT_BLANK_LINE;

            If Not Found
             then Begin If SegLoop = 1 then GSR.data.IsShowing[IsY1,Loop] := False End
             else
              Begin
                If Drawit then
                  If IsY1 and ScatterPlot then
                    Begin
                      XPointIndex := L;
                      XCaption := PH.ListStr(False);
                    End
                  else
                    Begin
                      NewSeries := TLineSeries.Create(Chart);
                      NewSeries.Pointer.visible:=True;
                      Inc (SeriesIndex);
                      Inc (LegendIndex);
                      GSR.data.IsShowing[IsY1,Loop] := True;

                      If All_Segs and (GSR.LinkedGSR.nseries < SeriesIndex) then GSR.LinkedGSR.nseries := SeriesIndex;
                      If All_Segs and (Length(GSR.LinkedGSR.GSRs) < SeriesIndex) then GSR.LinkedGSR.AddLength(100);

                       If ALL_Segs then with GSR.LinkedGSR.GSRs[SeriesIndex-1] do
                         Begin
                           NewSeries.Pointer.VertSize := Size;
                           NewSeries.Pointer.HorizSize := Size;
                           NewSeries.Pointer.Style := Shape;
                           NewSeries.LinePen.Width := LineThick;
                           NewSeries.Visible := not Suppress;
                         End
                       else
                         Begin
                           NewSeries.Pointer.VertSize := GSR.data.Size[IsY1,Loop];
                           NewSeries.Pointer.HorizSize := GSR.data.Size[IsY1,Loop];
                           NewSeries.Pointer.Style := GSR.data.Shapes[IsY1,Loop];
                           NewSeries.LinePen.Width := GSR.data.LineThick[IsY1,Loop];
                         End;

                      If (ScatterPlot) then
                         If NewSeries.Pointer.Style = psSmallDot then NewSeries.Pointer.Style := psCircle;

                      NewSeries.Pointer.InflateMargins := True;

                      If Scatterplot then NewSeries.LinePen.Visible := False;
                    End;

                If Drawit and not Scatterplot and (GSR.Data.GraphType>0) and (Length(DataArray) < NumValues) then
                   SetLength(DataArray,NumValues);  {array for manipulation}

                EndDate := -1e9;
                StartDate := 1e9;
                J := 0;  NumToSave := 0;
                while J <= NumValues -1 do
                  begin
                    CurrResults:= Results.At(j);

                    XMinMax2(CurrResults.Date);                           // 4/26/2012 Allow for seasonal averaging, JSC
                    If (XMin2=0) or (XMax2=0) or
                       ((TRUNC(CurrResults.Date) >= XMin2) and
                        (TRUNC(CurrResults.Date) <= XMax2)) then
                        With GSR do
                         Begin
                           If L=-1 then Number:=0
                                   else Number:= TDataPoint(CurrResults.DataPoints.At(L)).State;

                           If Drawit and not (IsY1 and ScatterPlot) then
                             Begin
                               Inc(NumToSave);
                               If ScatterPlot
                                 then Begin
                                        XVal := TDataPoint(CurrResults.DataPoints.At(XPointIndex)).State;
                                        NewSeries.AddXY(XVal,Number,'',clteecolor); {plot x,y}
                                      End {Scatter Plot}
                                 else If GSR.Data.GraphType>0
                                   then DataArray[NumToSave-1] := Number  {save results for manipulation & plotting for duration / exceedence graphs}
                                   else NewSeries.AddXY(CurrResults.Date,Number,'',clteecolor); {plot x,y}

                               If (CurrResults.Date<StartDate) then StartDate := CurrResults.Date; {start and end dates for duration graph}
                               If (CurrResults.Date>EndDate)   then EndDate   := CurrResults.Date;
                             End;

                           Y1Var := IsY1;
                           If ScatterPlot then Y1Var := not IsY1;
                           If Number > Big[Y1Var] then Big[Y1Var]:=Number;
                           If Number < Small[Y1Var] then Small[Y1Var] := Number;
                         end;
                    J := J + 1;
                  end;
               CalcDuratn;

               If Drawit and not (IsY1 and ScatterPlot) then
                 Begin
                   If IsY1 then LeftAxisItems := True else RightAxisItems := True;
                   If not Scatterplot and (GSR.Data.GraphType>0) then
                     If All_Segs then Produce_Exceedance_Graph(NumToSave-1,WorkingSeg.SegNumber+': '+PH.ListStr(False))
                                 else Produce_Exceedance_Graph(NumToSave-1,PH.ListStr(False));

                   If ALL_Segs then chosencolor := GSR.LinkedGSR.GSRs[SeriesIndex-1].Color
                               else chosencolor := GSR.data.Colors[IsY1,Loop];

                   If chosencolor = ClDefault
                     then NewSeries.SeriesColor:=ChartColors[SeriesIndex mod 10]
                     else NewSeries.SeriesColor:=chosencolor;
                   If IsY1 or ScatterPlot then NewSeries.VertAxis := aLeftAxis
                                          else NewSeries.VertAxis := aRightAxis;
                   If All_Segs then NewSeries.Title := WorkingSeg.SegNumber+': '+PH.ListStr(False)
                               else NewSeries.Title := PH.ListStr(False);
                   Chart.AddSeries(NewSeries);
                 End;

              End; {found}

            If Drawit and (SegLoop=1) and (Not Found) then AddObservedData(IsY1,Loop);  {segloop avoids multiple graphs for linked window}
          End; {If Items<>-99}
       End; {SegLoop}
      End; {Loop}
   End; {IsY1 Loop, Drawit Loop}

  SET_CHART_TITLES;
 {Set default titles}

  With GSR.Data do
   Begin
     If DefaultX then
       Begin
         Case GraphType of
           1: BottomAxis.Title.Caption := 'Percent Exceedance';
           2: BottomAxis.Title.Caption := 'days';
           3: BottomAxis.Title.Caption := XCaption;
           else BottomAxis.Title.Caption := '';
         End;
       End
         else BottomAxis.Title.Caption := XLabel;

     IF DefaultY1
        then Begin
               If Scatterplot then LeftAxis.Title.Caption := UnitSav[False]
                              else LeftAxis.Title.Caption := UnitSav[True];
             End
          else LeftAxis.Title.Caption := Y1Label;

     IF DefaultY2
        then RightAxis.Title.Caption := UnitSav[False]
        else RightAxis.Title.Caption := Y2Label;

   End;

 DrawThreshold;

 For loop:=0 to Chart.SeriesCount-1 do
   Chart.Series[loop].XValues.DateTime:= (GSR.Data.GraphType = 0);

 Chart1.BottomAxis.Automatic := (Not ScatterPlot) or (GSR.data.Y1AutoScale);
 If Not Chart1.BottomAxis.Automatic then
   Begin
      Chart.BottomAxis.SetMinMax(GSR.data.Y1Min,GSR.data.Y1Max);
   End;

 Chart.LeftAxis.Automatic := (GSR.data.Y1AutoScale or GSR.data.AutoScaleAll);
 If Scatterplot then Chart.LeftAxis.Automatic := (GSR.data.Y2AutoScale);
 If not Chart.LeftAxis.Automatic
{        (GSR.data.Y1AutoScale or GSR.data.AutoScaleAll) }
   then  Begin
          If Scatterplot then
              Begin
                Chart.LeftAxis.SetMinMax(GSR.data.Y2Min,GSR.data.Y2Max);
                Big[True] := GSR.data.Y2Max;
                Small[True] := GSR.data.Y2Min;
              End
            else
              Begin
                Chart.LeftAxis.SetMinMax(GSR.data.Y1Min,GSR.data.Y1Max);
                Big[True] := GSR.data.Y1Max;
                Small[True] := GSR.data.Y1Min;
              End
        End;

 If GSR.data.AutoScaleAll and (Big[True]-Small[True] >= 1e-6)
   then Begin
          Range := Big[True] - Small[True];
          Chart.LeftAxis.SetMinMax(Small[True]-Range/50 ,Big[True]+Range/50);
         End;

 Chart.RightAxis.Automatic := GSR.data.Y2AutoScale or (GSR.data.AutoScaleAll);
 If not (GSR.data.Y2AutoScale or GSR.data.AutoScaleAll)
   then Begin
          Chart.RightAxis.SetMinMax(GSR.data.Y2Min,GSR.data.Y2Max);
          Big[False] := GSR.data.Y2Max;
          Small[False] := GSR.data.Y2Min;
        End;
 If GSR.data.AutoScaleAll and (Big[False]-Small[False] >= 1e-6)
   then Begin
          Range := Big[False] - Small[False];
          Chart.RightAxis.SetMinMax(Small[False]-Range/50 ,Big[False]+Range/50);
         End;

 If (Big[True]-Small[True] < 1e-6)  then
   Begin
     Big[True]   := Big[True]   + 5.0e-7;
     Small[True] := Small[True] - 5.0e-7;
     If Big[True] + Small[True] = 0 then
       Begin
        Big[True]   :=  1;
        Small[True] := -1;
       End;
     LeftAxis.Automatic := False;
     LeftAxis.SetMinMax(Small[True],Big[True]);
   End;

 If (Big[False]-Small[False] < 1e-6)  then
   Begin
     Big[False]   := Big[False]   + 5.0e-7;
     Small[False] := Small[False] - 5.0e-7;
     If Big[False] + Small[False] = 0 then
       Begin
        Big[False]   :=  1;
        Small[False] := -1;
       End;
     RightAxis.Automatic := False;
     RightAxis.SetMinMax(Small[False],Big[False]);
   End;

  If GSR.Data.Logarithmic
    then
      Begin
        If UnitSav[True] <>  '' then SetLogAxis(LeftAxis,' Left ');
        If UnitSav[False] <> '' then SetLogAxis(RightAxis,' Right ');
      End
    else
      Begin
        Chart1.LeftAxis.Logarithmic := False;
        Chart1.RightAxis.Logarithmic := False;
      End;

 CString := SetCString(Big[True],Small[True],LeftAxis.Logarithmic);
 LeftAxis.AxisValuesFormat := CString;
 If Big[True]-Small[True] <=0
   then LeftAxis.Visible := False
   else If not LeftAxis.Logarithmic
     then LeftAxis.Increment := SetInterval(Big[True],Small[True]);

 CString := SetCString(Big[False],Small[False],RightAxis.Logarithmic);
 Chart.RightAxis.AxisValuesFormat := CString;
 If Big[False]-Small[False] <=0
   then Chart.RightAxis.Visible := False
   else if not Rightaxis.Logarithmic
     then Chart.RightAxis.Increment := SetInterval(Big[False],Small[False]);

 Chart.Refresh;
 Chart.Repaint;

 End; {with Chart}

 DataArray := nil;
End; {ShowChosenGraph}

 {=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}
Procedure TOutputScreen.ShowDiffGraph;
{ This procedure creates the difference graph }
{ 9-5-07 added linked seg. support}

Var NumToGraph       : Integer;
    NumControlValues : Integer;
    SeriesIndex      : Integer;
    Results, CtrlResults  : TResultsCollection;
    NumResultValues  : Integer;
    LC,LP,Loop,InnerLoop,i,j           : Integer;
    Control_Results,Perturbed_Results  : TResults;
    Control_Num, Perturbed_Num         : Double;
    RC               : TResultsCollection;
    HypExists, Found, VarWarned : Boolean;
    Difference       : Double;
    CString, SegName          : String;
    ResultID, NumSegs: Integer;
    WorkingSeg       : TAQUATOXSegment;
    Biggest,Smallest : Double;
    ErrString, ErrString2 : String;
    NewSeries        : TLineSeries;
    GraphList        : Array[False..True,1..40] of TResHeader;
    Y1Index          : Array[1..40] of boolean;
    LoopIndex        : Array[1..40] of integer;
    YIndex, SegLoop  : Integer;
    GSR              : TGraphSetup;
    Y1, EpiGraph,ControlLoop  : Boolean;
    DoneWarning, DNEWarned, TinyWarned     : Boolean;
    Seg              : VerticalSegments;
    TempYItems       : TYItems;
    ChosenColor      : TColor;

Begin
  If All_Segs then NumSegs := LinkedS.SegmentColl.Count
              else NumSegs := 1;

   WorkingSeg := nil;
   SeriesIndex := 0;
   GSR := GSRStudy.SV.Graphs.GArray[GraphListBox.ItemIndex];
   Seg := GSR.data.VSeg;
   EpiGraph := Seg = Epilimnion;

   NumControlValues:= OutputStudy.SV.Results[Seg].Count;
   NumResultValues := OutputStudy.SV.ControlResults[Seg].Count;

   TempYItems := GSR.data.YItems;

   NumToGraph := 0;
   For Y1 := True downto False do
     For Loop := 1 to 20 do
      If TempYItems[Y1,Loop] <> -99 then Inc(NumToGraph);

   ErrString2 := '';
   ErrString := '';

   If (NumControlValues<>NumResultValues)
      Then
        Begin
          If Not EpiGraph then
                       Begin
                         ErrString  := 'Hypolimnion data record for control and perturbed have different n datapoints';
                         ErrString2 :='(Try Running with "always write hypolimnion data" option checked)';
                       End
                     else ErrString := 'Control and Perturbed Runs have a different number of datapoints.';
        End
      Else If (NumControlValues=0)
        then ErrString := 'There are no Data to Plot'
        else if (NumToGraph=0)
          then ErrString := 'No Variables are Chosen to Plot';
    ErrLabel.Caption:=ErrString;
    ErrLabel2.Caption  := ErrString2;

    DiffErrorPanel.Visible  := (ErrString<>'');
    DiffErrorPanel.BringtoFront;
    EditButt.Visible := (NumControlValues=NumResultValues) and (NumControlValues>0);
    NewGraph.Visible := EditButt.Visible;
    Chart1.Visible   := (ErrString='');
    If ErrString<>'' then numtograph:=0;

   For ControlLoop := False to True do
    For y1 := True downto False do
     For Loop:=1 to 40 do
      Graphlist[ControlLoop,Loop] := nil;

   For ControlLoop := False to True do
    Begin
      YIndex:=0;
      For y1 := True Downto False do
       For Loop:=1 to 20 do
        Begin
          If ControlLoop then RC := OutputStudy.SV.ControlResults[Seg]
                         else RC := OutputStudy.SV.Results[Seg];

          Found:=False;

          ResultID := TempYItems[Y1,Loop];

          For InnerLoop:=0 to RC.Headers.Count-1 do
             Begin
               If ResultID = TResHeader(RC.Headers.At(InnerLoop)).SortIndex
                    then begin
                           Found:=true;
                           Inc(YIndex);
                           GraphList[ControlLoop,YIndex]  := RC.Headers.At(InnerLoop);
                           Y1Index[YIndex] := Y1;
                           LoopIndex[YIndex] := Loop;
                           Break;
                         end;
             End;

           If Not Found and (ResultID<>-99) then
                             begin
                               TempYItems[Y1,Loop] := -99;
                               Dec(NumToGraph);
                             end;
        End; {loop}
    End; {ControlLoop}


TRY

   {Clear the graph}
   While Chart1.SeriesCount>0 do Chart1.Series[0].Free;

   {Code to set the data}
   Biggest  := -1000;
   Smallest :=  1000;

   DNEWarned := False;
   TINYWarned := False;
   DoneWarning := False;

   For i := 0 to NumToGraph-1 do
    For SegLoop := 1 to NumSegs do
     Begin
     NewSeries := TLineSeries.Create(Chart1);

     NewSeries.Pointer.visible:=true;
     Inc(SeriesIndex);

     If All_Segs and (GSR.LinkedGSR = nil) then
       Begin
         GSR.LinkedGSR := TLinkedGSR.CreateBlank(100);
         GSR.Linked := True;
       End;

     If All_Segs and (GSR.LinkedGSR.nseries < SeriesIndex) then GSR.LinkedGSR.nseries := SeriesIndex;
     If All_Segs and (Length(GSR.LinkedGSR.GSRs) < SeriesIndex) then GSR.LinkedGSR.AddLength(100);

     If ALL_Segs then with GSR.LinkedGSR.GSRs[SeriesIndex-1] do
       Begin
         NewSeries.Pointer.VertSize := Size;
         NewSeries.Pointer.HorizSize := Size;
         NewSeries.Pointer.Style := Shape;
         NewSeries.LinePen.Width := LineThick;
         NewSeries.Visible := not Suppress;
       End
     else
       Begin
         NewSeries.Pointer.VertSize := GSR.data.Size[Y1Index[i+1],LoopIndex[i+1]];
         NewSeries.Pointer.HorizSize := GSR.data.Size[Y1Index[i+1],LoopIndex[i+1]];
         NewSeries.Pointer.Style := GSR.data.Shapes[Y1Index[i+1],LoopIndex[i+1]];
         NewSeries.LinePen.Width := GSR.data.LineThick[Y1Index[i+1],LoopIndex[i+1]];
       End;

     NewSeries.Pointer.InflateMargins := True;

{      If NumControlValues > 200 then NewSeries.Pointer.Style:=psSmallDot; }
     VarWarned := False;

     If All_Segs
      then
        Begin
          WorkingSeg := LinkedS.SegmentColl.At(SegLoop-1);
          CtrlResults := WorkingSeg.SV.ControlResults[Epilimnion];
          Results := WorkingSeg.SV.Results[Epilimnion];
          If WorkingSeg.SV.Location.SiteType = TribInput then Continue; {Output irrelevant for tributary-input segments}
        End
      else
         Begin
           CtrlResults := OutputStudy.SV.ControlResults[Seg];
           Results := OutputStudy.SV.Results[Seg];
         End;

     j := 0; {k := 0;}
     while j <= NumControlValues -1 do
	      begin
          Control_Results   := CtrlResults.At(j);
          Perturbed_Results := Results.At(j);

          If (GSR.Data.XMin=0) or (GSR.Data.XMax=0) or
             ((TRUNC(Control_Results.Date) >= Trunc(GSR.Data.XMin)) and
              (TRUNC(Control_Results.Date) <= Trunc(GSR.Data.XMax))) then
             Begin
                LC :=GraphList[True,i+1].PointIndex;
                LP :=GraphList[False,i+1].PointIndex;
                If (LC=-1) or (LP=-1) then
                    Begin
                      UpdatingScreen := True;
                      Difference:=0;
                      If (not VarWarned) and (not Donewarning) then
                        Begin
                           If DNEWarned
                             then
                               Begin
                                 MessageDlg('Note: Multiple Variables do not exist in both the control and perturbed runs',MTWarning,[MBOK],0);
                                 DoneWarning := True;
                               End
                             else MessageDlg('Warning, Variable '+GraphList[True,i+1].HeadStr
                                            +' does not exist in both the control and perturbed runs',MTWarning,[MBOK],0);
                        End;
                      VarWarned := True;
                      DNEWarned := True;
                      UpdatingScreen := False;
                    End
               else Begin
                      Control_Num:=TDataPoint(Control_Results.DataPoints.At(LC)).State;
                      Perturbed_Num:=TDataPoint(Perturbed_Results.DataPoints.At(LP)).State;
                      If Control_Num<Tiny
                        then Begin
                               UpdatingScreen := True;
                               If not VarWarned and not DoneWarning
                                 then
                                   Begin
                                     SegName := '';
                                     If All_Segs then SegName := 'Seg '+WorkingSeg.SegNumber+': ' ;
                                     If TinyWarned
                                     then
                                         Begin
                                            MessageDlg('Warning, in the control run, MULTIPLE variables become zero '
                                            +' or so tiny as to result in infinite differences being calculated.  '
                                            +'AQUATOX will plot these differences as zero.',MTWarning,[MBOK],0);
                                           DoneWarning := True;
                                         End
                                      else MessageDlg('Warning, in the control run, variable '+SegName+GraphList[True,i+1].HeadStr
                                          +' becomes zero or so tiny as to result in infinite differences being calculated.  '
                                          +'AQUATOX will plot these differences as zero.',MTWarning,[MBOK],0);
                                   End;
                               VarWarned := True;
                               TinyWarned := True;
                               Difference:=0;
                               UpdatingScreen := False;
                             End
                        else Difference:=((Perturbed_Num-Control_Num)/Control_Num)*100;
                    End;

                 NewSeries.AddXY(Control_Results.Date,Difference,'',clteecolor);

                 If ALL_Segs then chosencolor := GSR.LinkedGSR.GSRs[SeriesIndex-1].Color
                             else chosencolor := GSR.data.Colors[Y1Index[i+1],LoopIndex[i+1]];

                 If chosencolor = ClDefault
                    then NewSeries.SeriesColor:=ChartColors[SeriesIndex mod 10]
                    else NewSeries.SeriesColor:=chosencolor;


                 If Difference > Biggest then Biggest:=Difference;
                 If Difference < Smallest then Smallest := Difference;
             End;

          j := J + 1;
        end;

     If All_Segs then NewSeries.Title := WorkingSeg.SegNumber+': '+GraphList[True,i+1].HeadStr
                 else NewSeries.Title := GraphList[True,i+1].HeadStr;;

     Chart1.AddSeries(NewSeries);
   End;

 {Set default titles}
 Chart1.Title.Text.Clear;

 IF Not All_Segs
   then Chart1.Title.Text.Add(OutputStudy.StudyName + ' (Difference) ' )
   else Chart1.Title.Text.Add(LinkedS.SystemName + ' (Difference) ' );

 HypExists := (OutputStudy.SV.ControlResults[Hypolimnion].Count > 0) and
              (OutputStudy.SV.Results[Hypolimnion].Count > 0);

 If All_Segs or (Not HypExists)
             then Chart1.Title.Text.Add(' ')
             else If EpiGraph
               then Chart1.Title.Text.Add('('+EpiString+' Segment)')
               else Chart1.Title.Text.Add('('+HypString+' Segment)');

 Chart1.LeftAxis.Title.Caption := '% DIFFERENCE';

 For loop:=0 to Chart1.SeriesCount-1 do
   Chart1.Series[loop].XValues.DateTime:=True;

 Chart1.BottomAxis.Automatic := True;
 Chart1.LeftAxis.Automatic := GSR.data.DiffAutoScale;
 If not (GSR.data.DiffAutoScale) then
   Begin
     Chart1.LeftAxis.Minimum:=GSR.data.DiffMin;
     Chart1.LeftAxis.Maximum:=GSR.data.DiffMax;
   End;

 With Chart1 do
   Begin
     CString := SetCString(LeftAxis.Minimum,LeftAxis.Maximum,LeftAxis.Logarithmic);
     LeftAxis.AxisValuesFormat := CString;
     If not LeftAxis.Logarithmic
         then If GSR.Data.DiffAutoScale
           then LeftAxis.Increment := SetInterval(Biggest,Smallest)
           else LeftAxis.Increment := SetInterval(LeftAxis.Maximum,LeftAxis.Minimum);
   End;

 Chart1.Refresh;
 Chart1.Repaint;

 If Biggest-Smallest < 0.02 then Chart1.LeftAxis.AxisValuesFormat := '0.00E+00'
                            else Chart1.LeftAxis.AxisValuesFormat := '###0.0##';

EXCEPT

Chart1.Visible:=False;

ErrLabel.Caption:='Error Creating Graph: Are Both Runs Current?';

END; {Except}

End;


procedure TOutputScreen.ShowMinMaxClick(Sender: TObject);
begin
  Update_UncertGraph;
end;

procedure TOutputScreen.ShowSensClick(Sender: TObject);
Var SensOut: TextFile;
    SensFileN: String;
    i: Integer;
begin
  TRY

  IF ShowEffects then SensFileN := 'Effects.txt'
                 else SensFileN := 'Sensitivities.txt';
  ASSIGNFILE(SensOut,Output_Dir +SensFileN);
  REWRITE(SensOut);

  IF ShowEffects then Writeln(SensOut, 'Effects of '+FloatToStrF(SensPercent,fffixed,6,0)+
                        '% change in "'+UncBox1.Text+'" parameter.  "Sensitivity" percentages shown.')
                 else Writeln(SensOut, 'Sensitivity of '+UncBox1.Text+' to '+FloatToStrF(SensPercent,fffixed,6,0)+
                        '% change in tested parameters');

  Writeln(SensOut);
  Writeln(SensOut,DatabaseLabel.Caption);
  Writeln(SensOut);

  IF ShowEffects
    then For i := NumEffects downto 1 do
           Writeln(SensOut,EffectArr[UncBox1.ItemIndex,i-1].Name)
    else For i := NumTRes[UncBox1.ItemIndex] downto 1 do
           Writeln(SensOut,TornArr[UncBox1.ItemIndex,i-1].Name);

  Finally
  CloseFile(SensOut);
  End;

  ExecuteFile('NOTEPAD.EXE',Output_Dir + SensFileN,'',SW_SHOW);
end;

{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}


Procedure TOutputScreen.DisplayResults(S: TAQUATOXSegment);
Begin {Setup Initial Display of Results}
  If S.SV.LinkedMode
    then Begin if All_Segs then Caption := 'Linked Segments Output Window: '+LinkedS.Systemname + ', '+LinkedS.FileName
               else Caption := 'Output Window-- Segment '+MainStudy.SegNumber + ': "'+S.Studyname + '" '+ MainLinkedS.Systemname + '; '+MainLinkedS.FileName
         End
    else Caption := 'Output Window-- '+OutputStudy.FileName;

  OutputStudy := S;

  EpiString := 'Epilimnion';
  HypString := 'Hypolimnion';
  If S.Location.SiteType = Estuary then
     Begin
       EpiString := 'Upper';
       HypString := 'Lower';
     End;

  TPVSeg.Caption:='View '+HypString;
  TCVSeg.Caption:='View '+HypString;

  TeaseInc:=1;
  With OutputStudy do
    begin
      VUnc_Dir  := Unc_Dir;
      VUnc_File := Unc_File;
      VUnc_Ext  := Unc_Ext;
      Unc_Index := - 1;
      Decline   := nil;
      DeclName  := nil;
      ShowDecline:=nil;
    end;

  GraphMenu.Enabled := True;
  If (OutputStudy.SV.Results[Epilimnion].Count=0) and (OutputStudy.SV.ControlResults[Epilimnion].Count=0)
     then Begin
            MessageDlg('No Results To Display.',mterror,[mbOK],0);
            GraphMenu.Enabled := False;
          End;

  TPVSeg.Visible  := OutputStudy.SV.Results[Hypolimnion].Count>0;
  TCVSeg.Visible  := OutputStudy.SV.ControlResults[Hypolimnion].Count>0;

    TRY
    SensGraph := False;
    BioRiskGraph := False;
    BioDatLoaded := False;

    Application.CreateForm(TGraphChoiceDlg, GraphChoiceDlg);
    GraphChoiceDlg.Caption := 'AQUATOX-- Select Results to Display';
    GraphChoiceDlg.DstLabel.Caption := 'Results to Display:';

    Try
      InitializeChart(OutputStudy.SV.Results[Epilimnion]);
      TableChoiceChanged(False,True);

      InitializeChart(OutputStudy.SV.ControlResults[Epilimnion]);
      TableChoiceChanged(True,True);

    Finally
      GraphChoiceDlg.Free;
    End;

    CreateGraphList;
    ShowChosenGraph;

    Update_UncertGraph;

  EXCEPT
    MessageDlg(Exception(ExceptObject).Message,mterror,[mbOK],0);
    WaitDlg.Hide;
    Exit;
  END;

  WaitDlg.Hide;

End;


{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

procedure TOutputScreen.FormResize(Sender: TObject);
{Change the display grid sizes when the screen size changes}
Var ChangingGrid: TDBGrid2;
    Loop: Integer;

Const GridHeightDelta   = 92+32;
      GridWidthDelta    = 14;
      GridTop           = 56;
      ChartHeightDelta  = 75+32;
      ChartWidthDelta   = 12;

begin
  ChangingGrid:=dbgrid1;
  HorzScrollBar.Visible := True;
  {Change size of both table grids}
  For Loop:=1 to 2 do
     begin
        Case Loop of
             1 : ChangingGrid:=dbgrid1;
             2 : ChangingGrid:=dbgrid2;
        end; {case}
        ChangingGrid.Top   :=GridTop;
        ChangingGrid.Height:=ClientHeight -GridHeightDelta;
        ChangingGrid.Width :=ClientWidth  -GridWidthDelta;
     end; {for do}

     {Change size of Charts}
     Chart1.Height:=ClientHeight - ChartHeightDelta;
     Chart1.Width :=ClientWidth  - ChartWidthDelta;
     Chart4.Height:=ClientHeight - ChartHeightDelta -25;
     Chart4.Width :=ClientWidth  - ChartWidthDelta;
     PerturbedNRPanel.Width := ClientWidth  - ChartWidthDelta;
     OutputNotebook.Width := ClientWidth;
end;

{******************************************************************}
{*                                                                *}
{*                CHANGE VARIABLES BUTTON CLICKS                  *}
{*                                                                *}
{******************************************************************}

Procedure TOutputScreen.EditGraphClick(Sender: TObject);
{Puts up the GraphChoiceDlg2 dialog when the change variables button is clicked}
Var Difference, Control   : Boolean;
    GSR                   : TGraphSetup;
    VSeg                  : VerticalSegments;
    CurrentGraph          : Integer;

Begin
  Control := ScenarioBox.ItemIndex = 0;
  Difference := ScenarioBox.ItemIndex = 2;
  GSR := GSRStudy.SV.Graphs.GArray[GraphListBox.ItemIndex];
  VSeg:=GSR.data.VSeg;

  Application.CreateForm(TGraphChoiceDlg2, GraphChoiceDlg2);
  Try

  If Control then GraphChoiceDlg2.RC := OutputStudy.SV.ControlResults[VSeg]
             else GraphChoiceDlg2.RC := OutputStudy.SV.Results[VSeg];
  If Control then GraphChoiceDlg2.HypExists := OutputStudy.SV.ControlResults[Hypolimnion].Count > 0
             else GraphChoiceDlg2.HypExists := OutputStudy.SV.Results[Hypolimnion].Count > 0;

  If MainStudy = nil
    then GraphChoiceDlg2.TOD := OutputStudy.SV.ObservedData
    else GraphChoiceDlg2.TOD := MainStudy.SV.ObservedData;

  If GraphChoiceDlg2.RC.Count = 0 then Exit;

  If GraphChoiceDlg2.EditGraphChoices(GSR,Difference,Control,All_Segs) then
    Begin
      CurrentGraph := GraphListBox.ItemIndex;
      CreateGraphList;
      GraphListBox.ItemIndex := CurrentGraph;
      ShowChosenGraph;
      Changed := Now;
    End;

  Finally
    GraphChoiceDlg2.Free;
  End;
End;



{******************************************************************}
{*                                                                *}
{*                 PRINT BUTTON CLICKS                            *}
{*                                                                *}
{******************************************************************}

Const CPAINT_PRINT = $1;
      Print_Margin = 100;

procedure TOutputScreen.UncertPrintButtClick(Sender: TObject);
{print chart btn}
begin
  Chart4.PrintProportional:=false;
  Chart4.PrintMargins:=Rect(10,10,10,10); { default 10 % printing margins }
  TeePrevi.TeePreview(Self, Chart4);
end;

procedure TOutputScreen.PChartbuttClick(Sender: TObject);
{print chart btn}

begin
  Chart1.PrintProportional:=false;
  Chart1.PrintMargins:=Rect(10,10,10,10); { default 10 % printing margins }
  TeePrevi.TeePreview(Self, Chart1);
end;

procedure TOutputScreen.Print1Click(Sender: TObject);
begin
  PChartbuttClick(nil);
end;

procedure TOutputScreen.PrntBtn2Click(Sender: TObject);
begin
end;


{******************************************************************}
{*               FORM CREATE AND FORM DESTROY                     *}
{******************************************************************}

procedure TOutputScreen.FormCreate(Sender: TObject);
Var Loop: Integer;
    PATS: TAQUATOXSegment;
begin  {This gets executed twice, before & after default graph drawing}

  RowLabels := nil;
  ColLabels := nil;

  ShowEffects := False;
  ExecuteMenu := True;
  LeftAxisItems := False;
  RightAxisItems := False;
  ThreshResults := TStringList.Create;

  inherited;

  If All_Segs then
    Begin
      LoadFromFile.Visible := False;
      SaveToFile.Visible := False;
    End;

  Try
  Changed := 0;
  Printer.Orientation:=poLandscape; { default paper orientation }
  Except
  End;

  If ALL_Segs then
    Begin
      SegBox.Visible := True;
      SegBox.Items.Clear;
      SegBox.Items.Add('** All Segments **');

      For Loop := 0 to LinkedS.SegmentColl.Count - 1 do
        Begin
          PATS := LinkedS.SegmentColl.At(Loop);
          If (PATS.SV.Location.SiteType<>TribInput) then
            Begin
              SegBox.Items.Add('['+ PATS.SegNumber + ']: '+PATS.StudyName);
              ListBoxIDs[SegBox.Items.Count-1] := PATS.SegNumber;
            End;
        End;
      SegBox.ItemIndex := 0;
    End;

  FirstShow := True;
end;

procedure TOutputScreen.FormClose(Sender: TObject; var Action: TCloseAction);

    Procedure ClearSensarray(Var SA: SensArray);
    Var i: Integer;
    Begin
      If SA <> nil then
        Begin
          For i := 0 to Length(SA)-1 do
            SA[i] := nil;
          SA := nil;
        End;
    End;

begin
  ClearSensArray(TornArr);
  ClearSensArray(EffectArr);

  BaseCaseArr := nil;
  NumTRes := nil;

  Action := CaFree;

end;



{******************************************************************}
{*                                                                *}
{*                     UNCERTAINTY OUTPUT                         *}
{*                                                                *}
{******************************************************************}
procedure TOutputScreen.RepeatButtonClick(Sender: TObject);
begin
  GraphmenuChange(nil);
end;

Procedure TOutputScreen.ReturnCSVName(Var FileN: String);
Begin
  FileN := VUnc_File;
  If Pos(ExtractFileExt(FileN),FileN) > 0 then
    Delete(FileN,Pos(ExtractFileExt(FileN),FileN),Length(ExtractFileExt(FileN)));
  FileN := VUnc_Dir+FileN+'_decline.CSV';

  If Not FileExists(FileN) then
    If Pos('_decline',FileN) > 0 then
      Delete(FileN,Pos('_decline',FileN)-1,1);

End;


procedure TOutputScreen.rophicStateIndices1Click(Sender: TObject);
begin
  CalcTSIs;
end;

Procedure TOutputScreen.Load_BioDat;
Var FileN,ThisNumStr: String;
    DeclOut: TextFile;
    LineNum, ColNum: Integer;
    Ch     : Char;
Begin
  BioDatLoaded := False;
  DeclName := nil;
  Decline  := nil;
  ShowDecline := nil;

  DatabaseLabel.Caption:='( no difference file selected )';
  If VUnc_Dir='' then begin
                        UncChangeVarButt.Visible:=False;
                        Chart4.Visible:=False;
                        exit;
                      end
                 else begin
                        UncChangeVarButt.Visible:=True;
                        Chart4.Visible:=True;
                      end;

  TRY
    ReturnCSVName(FileN);

    ASSIGNFILE(DeclOut,FileN);
    RESET(DeclOut);
  EXCEPT
    DatabaseLabel.Caption:='( error reading file )';
    UncChangeVarButt.Visible:=False;
    Chart4.Visible:=False;
    Raise EAQUATOXError.Create('Error Reading Decline.CSV file');
  END;

  TRY
    LineNum := 0;
    Repeat
      Inc(LineNum);
      SetLength(DeclName,LineNum);
      SetLength(Decline,LineNum);
      SetLength(ShowDecline,LineNum);
      ShowDecline[LineNum-1] := LineNum=1;
      DeclName[LineNum-1] := '';

      Repeat
        Read(DeclOut,ch);
        If (ch<>',') and not ((ch=#10) or (ch=#13)) then DeclName[LineNum-1] := DeclName[LineNum-1]+ch;
      Until EOF(DeclOut) or EOLn(DeclOut) or (ch=',');

      IF EOF(DeclOut) or EOLn(DeclOut) then Raise EAQUATOXError.create('Invalid File');

      ColNum := 0;

      Repeat
        Inc(ColNum);
        ThisNumStr := '';
        Repeat
          SetLength(Decline[LineNum-1],ColNum);
          Read(DeclOut,ch);
          If (ch<>',') and not ((ch=#10) or (ch=#13)) then ThisNumStr := ThisNumStr + ch;
        Until EOF(DeclOut) or EOLn(DeclOut) or (ch=',');
        Decline[LineNum-1,ColNum-1] := StrToFloat(Trim(ThisNumStr));
      Until EOF(DeclOut) or EOLn(DeclOut);

      Readln(DeclOut); {read line return chars}

    Until EOF(DeclOut);

    CloseFile(DeclOut);

  EXCEPT
       DatabaseLabel.Caption:='( Decline.CSV file invalid )';
       UncChangeVarButt.Visible:=False;
       Chart4.Visible:=False;
       CloseFile(DeclOut);
       Raise EAQUATOXError.Create('Error Interpreting Decline CSV file');
  END;

  DatabaseLabel.Caption:='Viewing Data in File: '+FileN;
  BioDatLoaded := True;
End;


        {--------------------------------------------------------------------}
procedure TOutputScreen.QuickSort(var A: array of Double; iLo, iHi: Integer);
Var
  Lo, Hi : Integer;
  T, Mid : Double;
Begin
  Lo := iLo;
  Hi := iHi;
  Mid := A[(Lo + Hi) div 2];
  repeat
    while A[Lo] < Mid do Inc(Lo);
    while A[Hi] > Mid do Dec(Hi);
    if Lo <= Hi then
    begin
      T := A[Lo];
      A[Lo] := A[Hi];
      A[Hi] := T;
      Inc(Lo);
      Dec(Hi);
    end;
  until Lo > Hi;
  if Hi > iLo then QuickSort(A, iLo, Hi);
  if Lo < iHi then QuickSort(A, Lo, iHi);
End;


procedure TOutputScreen.Draw_Bio_Risk_Graph;


Var NumDecls,NumIter, DecLoop, Loop: Integer;
    NewSeries: TLineSeries;
    PctProb,PctDecl: Double;
    SeriesIndex: Integer;
    SortedDecl: Array of Double;
    FileN: String;
Begin
  Chart4.Enabled:=True;
  {Destroy all existent data}
  While Chart4.SeriesCount>0 do Chart4.Series[0].Free;

  If Not BioDatLoaded then Load_BioDat;
  If Not BioDatLoaded then Exit;

  ReturnCSVName(FileN);
  DatabaseLabel.Caption:='Viewing Data in File: '+FileN;

  NumDecls := High(DeclName)+1;
  NumIter := High(Decline[0])+1;

  SeriesIndex := -1;
  For DecLoop := 0 to NumDecls - 1 do
    If ShowDecline[DecLoop] then
      Begin
        Inc(SeriesIndex);
        NewSeries := TLineSeries.Create(Chart4);
        NewSeries.Pointer.visible:=true;
        NewSeries.Pointer.Style:=TSeriesPointerStyle(SeriesIndex mod 4);
        NewSeries.Pointer.VertSize := 3;
        NewSeries.Pointer.HorizSize := 3;
        NewSeries.SeriesColor:=ChartColors[SeriesIndex mod 10];
        NewSeries.XValues.DateTime:=False;
        NewSeries.Title := DeclName[DecLoop];

        Chart4.AddSeries(NewSeries);

        SetLength(SortedDecl,NumIter);
        For Loop := 0 to NumIter-1 do
          Begin
            SortedDecl[Loop] := Decline[DecLoop,Loop];
          End;


        QuickSort(SortedDecl, Low(SortedDecl), High(SortedDecl));

(*        For Loop:= NumIter-2 downto 0 do  {Simple Insertion Sort}
          Begin
            Temp := SortedDecl[Loop];
            J := Loop+1;
            While(J <= NumIter-1) and (SortedDecl[j] < Temp) do
              Begin
               SortedDecl[j-1] := SortedDecl[j];
               Inc(J);
              End;
            SortedDecl[J-1] := Temp;
          End; *)

        For Loop:=1 to NumIter do
          Begin
            PctProb := (Loop/NumIter)*100;
            PctDecl := SortedDecl[NumIter-Loop];
            Chart4.Series[SeriesIndex].AddXY(PctDecl,PctProb,'',clteecolor);
          End;

        SortedDecl := nil;
      End;

  Chart4.Visible := True;
  UncChangeVarButt.Visible:=True;

  Chart4.Title.Text.Clear;
  Chart4.Title.Text.Add('Biomass Risk Graph');
  Chart4.Title.Text.Add(DateTimeToStr(Now));

  Chart4.BottomAxis.Title.Caption := 'Percent Decline at Simulation End';
  Chart4.LeftAxis.Title.Caption   := 'Percent Probability';

End;


procedure TOutputScreen.Draw_Tornado(Index: Integer);

Var NumBars, i, Num_To_Show, Min2Show, Max2Show: Integer;
    HBS_P, HBS_N:  THorizBarSeries;
    Conv: Double;
    Result: Integer;
    DrawArr : SensArray;

Begin
  If ShowEffects then DrawArr := EffectArr
                 else DrawArr := TornArr;

  If (DrawArr = nil) then exit;

  Val(Trim(NumRungsEdit.Text),Conv,Result);
  If Result <> 0 then Num_To_Show := 15
                 else Num_To_Show := Abs(Trunc(Conv));

  NumRungsEdit.Text := IntToStr(Num_To_Show);

  If ShowEffects
    then
      Begin
        If NumEffects > NUM_TO_SHOW
          then Min2Show := NumEffects-NUM_TO_SHOW+1
          else Min2Show := 1;
        Max2Show := NumEffects
      End
    else
      Begin
        If NumTRes[Index] > NUM_TO_SHOW
          then Min2Show := NumTRes[Index]-NUM_TO_SHOW+1
          else Min2Show := 1;
        Max2Show := NumTRes[Index]
      End;

  {Clear the graph}
  While Chart4.SeriesCount>0 do Chart4.Series[0].Free;

  HBS_P := THorizBarSeries.Create(Chart4);
  HBS_P.SeriesColor := clnavy;
  HBS_P.Visible := True;
  HBS_P.Marks.Visible := False;
  HBS_P.UseYOrigin := True;
  If ShowEffects then HBS_P.YOrigin := 0
                 else HBS_P.YOrigin := BaseCaseArr[Index];
  HBS_P.OffsetPercent := 25;
  HBS_P.BarWidthPercent := 60;
  HBS_P.Title := 'Positive';

  HBS_N := THorizBarSeries.Create(Chart4);
  HBS_N.SeriesColor := clred;
  HBS_N.Visible := True;
  HBS_N.Marks.Visible := False;
  HBS_N.BarWidthPercent := 60;
  HBS_N.UseYOrigin := True;
  If ShowEffects then HBS_P.YOrigin := 0
                 else HBS_N.YOrigin := BaseCaseArr[Index];
  HBS_N.Title := 'Negative';

  NumBars := 0;
  For i := Min2Show to Max2Show do
    Begin
      Inc(NumBars);
      HBS_P.AddXY(DrawArr[Index,i-1].Pos,NumBars ,DrawArr[Index,i-1].Name,clteecolor);
      HBS_N.AddXY(DrawArr[Index,i-1].Neg,NumBars ,'',clteecolor);
    End;

  Chart4.AddSeries(HBS_P);
  Chart4.AddSeries(HBS_N);
  Chart4.Legend.Visible := False;
  Chart4.Title.Text.Clear;
  If ShowEffects then Chart4.Title.Text.Add('Effect of '+FloatToStrF(SensPercent,fffixed,6,0)+
                       '% change in "'+UncBox1.Text+'" parameter')
                 else Chart4.Title.Text.Add('Sensitivity of '+UncBox1.Text+' to '+FloatToStrF(SensPercent,fffixed,6,0)+
                       '% change in tested parameters');
  If ShowEffects then Chart4.BottomAxis.Title.Caption := 'Percent Change'
                 else Chart4.BottomAxis.Title.Caption := UncBox1.Text;
  Chart4.BottomAxis.MinimumOffset := 6;
  Chart4.BottomAxis.MaximumOffset := 6;
  Chart4.BottomAxis.Axis.Width := 1;
  Chart4.LeftAxis.Axis.Width := 1;
  Chart4.LeftAxis.LabelsSeparation := 0;

  Chart4.Title.Text.Add(''); // DateTimeToStr(Now));
  Chart4.Visible := True;
End;  {Draw_Tornado}

{-----------------------------------------------------------------------------}

procedure TOutputScreen.Setup_Tornado;
Var NRows, NCols: Integer;
    ReadCol,ReadRow: Integer;
    ReadStr : String;
    lcid: integer;
    WBk: _WorkBook;
    WS: _Worksheet;
    Excel: _Application;
    SCurs: TCursor;

      {-----------------------------------------------------------------------------}
      Function OpenTornadoOutput: Boolean;
      Begin
         Result := True;

         Try
         lcid := LOCALE_USER_DEFAULT;
         Excel := CoExcelApplication.Create;
         Excel.Visible[lcid] := False;

         WBk := Excel.Workbooks.Open(VUnc_Dir+VUnc_File+VUnc_Ext, EmptyParam, EmptyParam, EmptyParam,
                                     EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
                                     EmptyParam, EmptyParam, EmptyParam,  EmptyParam,  LCID);
         WS := WBk.Worksheets.Item[1] as _Worksheet;
         WS.Activate(LCID);

         Except
           Screen.Cursor := SCurs;
           Result := False;
           MessageDlg('Cannot Access Tornado Diagram Excel File',mterror,[mbok],0);
           Try
             WBk.Close(FALSE,EmptyParam,0,lcid);
           Finally
             Excel.DisplayAlerts[LCID] := False;
             Excel.Quit;
           End;
         END;
      End;
      {-----------------------------------------------------------------------------}
      Procedure CloseTornadoOutput;
      Begin
         Screen.Cursor := SCurs;
          Try
           WBk.Close(FALSE,EmptyParam,0,lcid);
         Finally
           Excel.DisplayAlerts[LCID] := False;
           Excel.Quit;
         End;
      End;
      {-----------------------------------------------------------------------------}
      procedure QuickSort2(var A: array of TResType; iLo, iHi: Integer);
      Var
        Lo, Hi : Integer;
        Mid : Double;
        T: TResType;
      Begin
        Lo := iLo;
        Hi := iHi;
        Mid := A[(Lo + Hi) div 2].Sens;
        repeat
          while A[Lo].Sens < Mid do Inc(Lo);
          while A[Hi].Sens > Mid do Dec(Hi);
          if Lo <= Hi then
          begin
            T := A[Lo];
            A[Lo] := A[Hi];
            A[Hi] := T;
            Inc(Lo);
            Dec(Hi);
          end;
        until Lo > Hi;
        if Hi > iLo then QuickSort2(A, iLo, Hi);
        if Lo < iHi then QuickSort2(A, Lo, iHi);
      End;
      {-----------------------------------------------------------------------------}
      Procedure Read_Tornado_Data(Hyp: Boolean);
      Var Prev_Ln,Ln,i,j,k: Integer;
      HypStr: String;
      Begin
       If Hyp then HypStr := 'HYP ' else HypStr := '';
       Ln := UncBox1.Items.Count;
       Prev_Ln := 0;
       If Hyp then Prev_Ln := UncBox1.Items.Count div 2;

       SetLength(TornArr,Ln);
       SetLength(EffectArr,(NRows div 2));
       For k := 0 to (NRows div 2)-1 do
         SetLength(EffectArr[k],Ln);
       SetLength(BaseCaseArr,Ln);
       SetLength(NumTRes,Ln);

       Try

       For i := 0 to UncBox1.Items.Count-1-Prev_Ln do
         Begin
           j := i;
           If hyp then j := i + (Prev_Ln);
           SensPercent := StrToFloat(AbbrString(WS.Cells.Item[1,1].value2,'%'));
           BaseCaseArr[j] := StrToFloat(WS.Cells.Item[2,i+3].value2);
           ReadRow := 4;
           NumTRes[j] := 0;
           SetLength(TornArr[j],(NRows div 2));

           Repeat
               Begin
                 ReadStr := RowLabels[(ReadRow-4) div 2];
                 TornArr[j][NumTRes[j]].Pos  := StrToFloat(WS.Cells.Item[ReadRow,i+3].value2);
                 If BaseCaseArr[j] = 0 then EffectArr[NumTRes[j]][j].Pos := 0 {incalculable}
                                       else EffectArr[NumTRes[j]][j].Pos  :=100*((TornArr[j][NumTRes[j]].Pos) - BaseCaseArr[j]) / BaseCaseArr[j];
                 Inc(ReadRow);
                 TornArr[j][NumTRes[j]].Neg  := StrToFloat(WS.Cells.Item[ReadRow,i+3].value2);
                 If BaseCaseArr[j] = 0 then EffectArr[NumTRes[j]][j].Neg := 0 {incalculable}
                                       else EffectArr[NumTRes[j]][j].Neg := 100*((TornArr[j][NumTRes[j]].Neg) - BaseCaseArr[j]) / BaseCaseArr[j];
                 With TornArr[j][NumTRes[j]] do
                   Begin
                     If BaseCaseArr[j] = 0
                       then Sens := 0 {incalculable-- avoid divide by zero}
                       else Sens := ABS((ABS(Pos-BaseCaseArr[j])+ABS(Neg-BaseCaseArr[j]))/(2*BaseCaseArr[j]))/(SensPercent/100);
                     EffectArr[NumTRes[j]][j].Sens := Sens/100;

                     Name := FloatToStrF(Sens*100,FFGeneral,3,2) + '% - '+ReadStr;
                     if (Sens*100>999.5) then Name := FloatToStrF(Sens*100,FFGeneral,5,2) + '% - '+ReadStr;
                     EffectArr[NumTRes[j]][j].Name := FloatToStrF(Sens*100,FFGeneral,3,2) + '% - '+HypStr+UncBox1.Items[i];
                     if (Sens*100>999.5) then EffectArr[NumTRes[j]][j].Name := FloatToStrF(Sens*100,FFGeneral,5,2) + '% - '+UncBox1.Items[i];

                   End;
                 inc(NumTRes[j]);
               End;
             inc(ReadRow);
             WaitDlg.Tease;

            Until ReadRow = NRows + 4;

           QuickSort2(TornArr[j],0,NumTRes[j]-1);

           UncBox1.ItemIndex := 0;
           Draw_Tornado(0);
         End; {loop}

         For k := 0 to (NRows div 2) -1 do
           QuickSort2(EffectArr[k],0,Ln-1);

         Except
           MessageDlg('ERROR Reading Sensitivity Results in '+ VUnc_Dir+VUnc_File+VUnc_Ext,MTError,[mbok],0);
           DatabaseLabel.Caption:='ERROR Reading Sensitivity Results in '+ VUnc_Dir+VUnc_File+VUnc_Ext;
           Chart4.Visible := False;
           TornArr := nil;
         End;

      End;
      {-----------------------------------------------------------------------------}

Begin    {Setup_Tornado}

  if Not FileExists(VUnc_Dir+VUnc_File+VUnc_Ext) then
    Begin
      DatabaseLabel.Caption:='( Tornado Output Not Found )';
      SensGraph := False;
      Chart4.Walls.Back.Color := ClBtnFace;
      UncToggle.Visible := True;
      ShowMinMax.Visible := True;
      Chart4.Legend.Visible := True;
      UP3.Visible := False;
      Down3.Visible := False;
      UncBox1.Visible := False;
      NumRungsLabel.Visible := False;
      NumRungsEdit.Visible := False;
      RefreshButt.Visible := False;
      ShowSens.Visible := False;
      ToggleSensitivity.Visible := False;
      Exit;
    End;

  If Screen.Cursor = crHourglass
    then SCurs := 0
    else SCurs := Screen.Cursor;


  DatabaseLabel.Caption:='Viewing results in '+ VUnc_Dir+VUnc_File+VUnc_Ext;
  SensGraph := True;
  Chart4.Walls.Back.Color := ClWhite;
  UncToggle.Visible := False;
  ShowMinMax.Visible := False;

  Try
  OpenTornadoOutput;

  ShowEffects := False;
  ToggleSensitivity.Caption := 'Show Effects';
  UncBox1.Items.Clear;

  WaitDlg.Setup('Please Wait, Reading Data from Excel');


  If Collabels <> nil then ColLabels.Free;
  ColLabels := TStringList.Create;
  ReadCol := 3;
  NCols := 0;
  Repeat
    ReadStr := WS.Cells.Item[1,ReadCol].value2;
    if ReadStr <> '' then
      Begin
        UncBox1.Items.Add(ReadStr);
        Collabels.Add(ReadStr);
        inc (ReadCol);
        inc (NCols);
      End;
  Until ReadStr = '';
  NumEffects := NCols;

  If Rowlabels <> nil then RowLabels.Free;
  RowLabels := TStringList.Create;
  NRows := 0;
  Repeat
    ReadStr := WS.Cells.Item[NRows+4,1].value2;
    if ReadStr <> '' then
      Begin
        Delete(ReadStr,Length(ReadStr)-1,2);
        RowLabels.Add(ReadStr);
        inc (NRows);
        inc (NRows);
      End;
  Until ReadStr = '';

  if UncBox1.Items.Count>0
    then Begin
           Read_Tornado_Data(False);
           If Wbk.Worksheets.Count>1 then
             WS := WBk.Worksheets.Item[2] as _Worksheet;
           If WS.Name='Hyp Sens.' then
             Begin
               ReadCol := 3;
               Repeat
                 ReadStr := WS.Cells.Item[1,ReadCol].value2;
                 if ReadStr <> '' then
                   Begin
                     UncBox1.Items.Add('HYP '+ReadStr);
                     inc (ReadCol);
                     inc (NCols);
                   End;  
               Until ReadStr = '';
               NumEffects := NCols;
               Read_Tornado_Data(True);
             End;
         End
    else Begin
           MessageDlg('No valid sensitivity results found in '+ VUnc_Dir+VUnc_File+VUnc_Ext,MTError,[mbok],0);
           DatabaseLabel.Caption:='NO VALID RESULTS in '+ VUnc_Dir+VUnc_File+VUnc_Ext;
           TornArr := nil;
           Chart4.Visible := False;
         End;

   Finally


   WaitDlg.Hide;
   CloseTornadoOutput;

   End;

   Screen.Cursor := SCurs;
   UP3.Visible := True;
   Down3.Visible := True;
   UncBox1.Visible := True;
   NumRungsLabel.Visible := True;
   NumRungsEdit.Visible := True;
   Refreshbutt.Visible := True;
   ShowSens.Visible := True;
   ToggleSensitivity.Visible := True;

End;  {Setup_Tornado}




procedure TOutputScreen.Update_UncertGraph;
Var DateField: TField;
    LowField,MeanField,HighField,StdevField,DetermField: TField;
    DateofDB    : Double;
    NumPoints   : Integer;
    Unc_Name    : String;
    Loop        : Integer;
    Biggest,Littlest  : Double;
    Hypo         : Boolean;
    MinMaxNum, i : Integer;
    NewSeries    : TLineSeries;
    UncFileDate  : TDateTime;
    FDate: LongInt;
    FH: Integer;
    ext: String;

Begin
 If BioRiskGraph then
   Begin
     Draw_Bio_Risk_Graph;
     Exit;
   End;

 ext := LowerCase(ExtractFileExt(Vunc_File+VUnc_Ext));
 if (ext = '.xls') or (ext = '.xlsx') then Begin Setup_Tornado; Exit; End;
 SensGraph := False;
 Chart4.Walls.Back.Color := ClBtnFace;
 UncToggle.Visible := True;
 ShowMinMax.Visible := True;
 Chart4.Legend.Visible := True;
 UP3.Visible := False;
 Down3.Visible := False;
 UncBox1.Visible := False;
 NumRungsLabel.Visible := False;
 ShowSens.Visible := False;
 ToggleSensitivity.Visible := False;
 NumRungsEdit.Visible := False;
 Refreshbutt.Visible := False;

 Hypo := ( Pos('hyp_',LowerCase(VUnc_File)) = 1 );
 With UncTable do
 begin
  Active:=False;

  DatabaseLabel.Caption:='( no database selected )';
  If VUnc_Dir='' then begin
                        UncChangeVarButt.Visible:=False;
                        Chart4.Visible:=False;
                        exit;
                      end
                 else begin
                        UncChangeVarButt.Visible:=True;
                        Chart4.Visible:=True;
                      end;

  DatabaseName:=VUnc_Dir;
  TableName:=VUnc_File+VUnc_Ext;

  TRY
    Active:=True;
  EXCEPT
    DatabaseLabel.Caption:='( database not found )';
    Chart4.Visible:=False;
    UncChangeVarButt.Visible:=False;
    Raise;
  END;

  If FieldCount<6 then
    begin
       DatabaseLabel.Caption:='( invalid database selected )';
       UncChangeVarButt.Visible:=False;
       Chart4.Visible:=False;
       exit;
    end;

  DateField := FindField('Date');
  If DateField=nil then
    begin
       DatabaseLabel.Caption:='( no date field in database )';
       UncChangeVarButt.Visible:=False;
       Chart4.Visible:=False;
       exit;
    end;

  DatabaseLabel.Caption:='Viewing Data in File: '+VUnc_Dir+VUnc_File+VUnc_Ext;

  Active:=False;

  FH := FileOpen(VUnc_Dir+VUnc_File+VUnc_Ext, fmOpenRead);
  FDate := FileGetDate(FH);
  if FH > 0 then UncFileDate := FileDateToDateTime(Fdate)
            else UncFileDate := 0;
  FileClose(FH);

  If Unc_Index=-1 then
     Unc_Index:=0;

   Active:=True;

   LowField    := Fields[(Unc_Index*5)+1];
   MeanField   := Fields[(Unc_Index*5)+2];
   StdevField  := Fields[(Unc_Index*5)+3];
   HighField   := Fields[(Unc_Index*5)+4];
   DetermField := Fields[(Unc_Index*5)+5];

   If Hypo then
     begin
       LowField    := Fields[(Unc_Index*5)+2];
       MeanField   := Fields[(Unc_Index*5)+3];
       StdevField  := Fields[(Unc_Index*5)+4];
       HighField   := Fields[(Unc_Index*5)+5];
       DetermField := Fields[(Unc_Index*5)+6];
     end;

   NumPoints:=RecordCount;

   Unc_Name:=LowField.FieldName;
  End; {with UncTable}

  If LowerCase(ExtractFileExt(Vunc_File+VUnc_Ext)) = '.dbf'
              then Delete(Unc_Name,1,1)
              else Delete(Unc_Name,1,4);

  If (NumPoints<=1) then begin
                         DatabaseLabel.Caption:='( current database size too small for graphing )';
                         UncChangeVarButt.Visible:=False;
                         Chart4.Visible:=False;
                         exit;
                       end;

(*  If NumPoints > 200
    then Skip := NumPoints Div 200 + 1
    else Skip := 1; *)

  Chart4.Enabled:=True;
   {Destroy all existent data}
   While Chart4.SeriesCount>0 do Chart4.Series[0].Free;

   Biggest:=-1000;
   Littlest:=1000;

   For i := 0 to 5 do
    If (ShowMinMax.Checked) or (i=0) or (i>2) then
     Begin
       NewSeries := TLineSeries.Create(Chart4);
       NewSeries.Pointer.visible:=true;
       NewSeries.Pointer.Style:=TSeriesPointerStyle(i mod 4);
       NewSeries.Pointer.VertSize := 3;
       NewSeries.Pointer.HorizSize := 3;
       If NumPoints > 200 then NewSeries.Pointer.Style:=psSmallDot;

       Case i of 0 : NewSeries.Title := 'Mean';
                 1 : NewSeries.Title := 'Minimum';
                 2 : NewSeries.Title := 'Maximum';
                 3 : NewSeries.Title := 'Mean - StDev';
                 4 : NewSeries.Title := 'Mean + StDev';
                else NewSeries.Title := 'Deterministic';
       end; {case}

       NewSeries.SeriesColor:=ChartColors[i];
       NewSeries.XValues.DateTime:=True;

       Chart4.AddSeries(NewSeries);
     End; {loop of i}

     For Loop:=1 to NumPoints do
       With Chart4 do
        begin
          If Loop=1 then UncTable.First
                    else UncTable.Next;

          DateOfDB:=UncTable.Fields[0].AsFloat;

          If True {Loop mod skip = 0} then
              begin
                  Chart4.Series[0].AddXY(DateOfDB,MeanField.AsFloat,'',clteecolor);

                  MinMaxNum := 0;
                  If ShowMinMax.Checked then
                    Begin
                      MinMaxNum := 2;

                      Chart4.Series[1].AddXY(DateOfDB,LowField.AsFloat,'',clteecolor);
                      If LowField.AsFloat < Littlest
                         then Littlest := LowField.AsFloat;

                      Chart4.Series[2].AddXY(DateOfDB,HighField.AsFloat,'',clteecolor);
                      If HighField.AsFloat > Biggest
                         then Biggest := HighField.AsFloat;
                    End;

                  Chart4.Series[1+MinMaxNum].AddXY(DateOfDB,MeanField.AsFloat-StDevField.AsFloat,'',clteecolor);

                  Chart4.Series[2+MinMaxNum].AddXY(DateOfDB,MeanField.AsFloat+StDevField.AsFloat,'',clteecolor);

                  Chart4.Series[3+MinMaxNum].AddXY(DateOfDB,DetermField.AsFloat,'',clteecolor);
                  If DetermField.AsFloat > Biggest
                     then Biggest := DetermField.AsFloat;
                  If DetermField.AsFloat < Littlest
                     then Littlest := DetermField.AsFloat;
              end; {if loop mod skip}
        end; {With Chart4}


   UncTable.Active:=False;

   Chart4.Title.Text.Clear;

   Chart4.Title.Text.Add(Unc_Name);
   If UncFileDate > 0
     then  Chart4.Title.Text.Add(DateTimeToStr(UncFileDate))
     else  Chart4.Title.Text.Add(' ');

   Chart4.LeftAxis.Title.Caption := '';
   Chart4.BottomAxis.Title.Caption := '';

   If Biggest-Littlest < 0.02 then Chart4.LeftAxis.AxisValuesFormat := '0.00E+00'
                              else Chart4.LeftAxis.AxisValuesFormat := '###0.0##';

End;

procedure TOutputScreen.UpDown2Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := True;
end;

procedure TOutputScreen.UpDown2Click(Sender: TObject; Button: TUDBtnType);
Var I: Integer;
begin
  If Button=BTPrev then I := ScenarioBox.ItemIndex-1
                   else I := ScenarioBox.ItemIndex+1;
  If i = -1 then i := ScenarioBox.Items.Count-1;
  If i = ScenarioBox.Items.Count then i := 0;
  ScenarioBox.ItemIndex := i;
  ScenarioSelect(nil);

end;

procedure TOutputScreen.WriteSteinhaus1Click(Sender: TObject);
begin
  SteinhausClick(nil);
end;

procedure TOutputScreen.ChangeDBaseButtClick(Sender: TObject);
Var OutExt: String;
    FileN : String;
begin
  With OpenDialog1 do
    If not BioRiskGraph
      then
        begin
          Filter := 'Uncert., Sens. Results (*.db; *.xls*)|*.db;*.xls*|Paradox Files (*.db)|*.db|DBase Files (*.dbf)|*.dbf|Sensitivity Results (*.xls*)|*.xls*';
          DefaultExt := 'dbf';
          Title:='Select a New Database to View:';
          If VUnc_Dir<>'' then FileName := VUnc_Dir+VUnc_File+VUnc_Ext
                          else FileName := '';
          If not Execute then exit;

          OutExt := LowerCase(ExtractFileExt(FileName));
          If not ((OutExt='.dbf') or (OutExt='.db') or (OutExt='.db ') or (OutExt='.xls') or (OutExt='.xlsx'))
             then Raise EAquatoxError.Create('Output File must be of type (*.DBF) or (*.DB) or (*.XLS*)');

          VUnc_Dir  :=ExtractFilePath(FileName);
          VUnc_File :=ExtractFileName(FileName);
          VUnc_Ext  :='';
          BioDatLoaded := False;
        end
      else
        begin
          Filter := 'CSV Files (*.csv)|*.csv';
          DefaultExt := 'csv';
          Title:='Select a New decline.CSV to View:';
          If VUnc_Dir<>'' then Begin
                                 ReturnCSVName(FileN);
                                 FileName := FileN;
                               End
                          else FileName := '';

          If not Execute then exit;

          OutExt := LowerCase(ExtractFileExt(FileName));
          If not (OutExt='.csv')
             then Raise EAquatoxError.Create('Biomass Risk Graph File must be of type (*.CSV)');

          VUnc_Dir  :=ExtractFilePath(FileName);
          VUnc_File :=ExtractFileName(FileName);
          VUnc_File := LowerCase(VUnc_File);
          If Pos('_decline.csv',VUnc_File)>0 then
            Delete(VUnc_File,Pos('_decline.csv',VUnc_File),12);

          FileN := VUnc_Dir+VUnc_File;

          If FileExists(Vunc_Dir+VUnc_File+'.db')
            then VUnc_Ext  :='.db'
            else VUnc_Ext  :='.dbf';

          BioDatLoaded := False;
        end ;

 Unc_Index:=-1;
 Update_UncertGraph;
end;


Procedure TOutputScreen.ChangeBioVars;
Var DecLoop: Integer;
    NumDecls: Integer;
Begin
  Application.CreateForm(TGraphChoiceDlg, GraphChoiceDlg);

  Try
  {Clear the graphing choice dialog}
  GraphChoiceDlg.SourceList.Clear;
  GraphChoiceDlg.DstList.Clear;
  GraphChoiceDlg.Caption := 'Select Biomass for Risk Graph';
  GraphChoiceDlg.DstLabel.Caption := 'Results to Display:';

  NumDecls := High(DeclName)+1;
  For DecLoop := 0 to NumDecls-1 do
    Begin
      GraphChoiceDlg.MasterList.Add(DeclName[DecLoop]);
      If ShowDecline[DecLoop] then GraphChoiceDlg.DstList.Items.Add(DeclName[DecLoop]);
    End;

  If GraphChoiceDlg.ShowModal=MrCancel then Exit;

  For DecLoop := 0 to NumDecls-1 do
    ShowDecline[DecLoop] := (GraphChoiceDlg.DstList.Items.IndexOf(DeclName[DecLoop])>-1);

  Draw_Bio_Risk_Graph;

  Finally
    GraphChoiceDlg.Free;
  End;
End;


procedure TOutputScreen.UncBox1Change(Sender: TObject);
begin
  Draw_Tornado(UncBox1.ItemIndex);
end;

procedure TOutputScreen.UncChangeVarButtClick(Sender: TObject);
    {-------------------------------------}
    Procedure UncChange;
    Var Hypo: Boolean;
        NumRecs: Integer;
        Loop, Index: Integer;
        EntryStr: String;

    begin
      If BioRiskGraph then
        Begin
          ChangeBioVars;
          Exit;
        End;

      ChangeVarForm.Caption := 'Select a Variable to View';
      ChangeVarForm.EntryList.Items.Clear;
      UncTable.Active:=True;
      Hypo := ( Pos('hyp_',LowerCase(VUnc_File)) = 1 );
      Try

          NumRecs:=UncTable.FieldCount-1;
          If Hypo then NumRecs:=NumRecs-1;
          For Loop:=1 to NumRecs div 5 do
            begin
              Index:=((Loop-1)*5) +1;
              If Hypo then Index:=Index+1;
              EntryStr:=UncTable.Fields[Index].FieldName;
              If LowerCase(ExtractFileExt(Vunc_File+VUnc_Ext)) = '.dbf'
                  then Delete(EntryStr,1,1)
                  else Delete(EntryStr,1,4);

              ChangeVarForm.EntryList.Items.Add(EntryStr);
            end; {for do}
         ChangeVarForm.EntryList.Update;

      Except

      End;

      UncTable.Active:=False;
      If ChangeVarForm.ShowModal = MrCancel then Exit;
      If (ChangeVarForm.EntryList.ItemIndex=-1) then Exit;

      Unc_Index:=ChangeVarForm.EntryList.ItemIndex;
      Update_UncertGraph;
    end;
    {-------------------------------------}
Begin
  Application.CreateForm(TChangeVarForm, ChangeVarForm);
  UncChange;
  ChangeVarForm.Free;
End;


procedure TOutputScreen.SegBoxChange(Sender: TObject);
Var SegIndex: Integer;
    TMS: TMemoryStream;
begin
   If (MainStudy<>nil) and (MainStudy<>GSRStudy) then
     Begin
       TMS := TMemoryStream.Create;
       GSRStudy.SV.Graphs.Store(True,TStream(TMS));

       MainStudy.SV.Graphs.Free;
       TMS.Seek(0, soFromBeginning); {Go to beginning of stream}
       MainStudy.SV.Graphs := TGraphs.Load(True,TStream(TMS),VersionNum);  // store graphs to stream

       If Changed > MainStudy.LastChange then
           MainStudy.LastChange := Changed;
       TMS.Free;
     End;

  All_Segs := SegBox.ItemIndex = 0;
  If All_Segs then
    Begin
      OutputStudy := LinkedS.SegmentColl.At(0);
      GSRStudy := LinkedS.TemplateSeg;
      MainStudy := MainLinkedS.TemplateSeg;
    End
   else
    Begin
      SegIndex := LinkedS.SegIndexByID(ListBoxIDs[SegBox.ItemIndex]);
      OutputStudy := LinkedS.SegmentColl.At(SegIndex);
      GSRStudy := OutputStudy;
      MainStudy := MainLinkedS.SegmentColl.At(SegIndex);
    End;

  ChartLines := nil;
  NCL := 0;
  ExecuteMenu := True;
  LeftAxisItems := False;
  RightAxisItems := False;
  ThreshResults := TStringList.Create;

  FormShow(nil);

  {}
end;

Procedure TOutputScreen.SegViewClick(Sender: TObject);
Var Cntrl, Epi : Boolean;
    Butt       : TButton;
Begin
  Butt    :=  TButton(Sender);
  Cntrl   := (Butt.Name='CVSeg') or (Butt.Name='TCVSeg');

  If (Butt.Caption='View '+HypString)
    Then begin
           Epi:= False;
           Butt.Caption:='View '+EpiString;
         end
    Else begin
           Epi:= True;
           Butt.Caption:='View '+HypString;
         end;

  Application.CreateForm(TGraphChoiceDlg, GraphChoiceDlg);
  GraphChoiceDlg.Caption := 'AQUATOX-- Select Results to Display';
  GraphChoiceDlg.DstLabel.Caption := 'Results to Display:';
  Try

  UpdateDst(Cntrl,Epi,True);

  Begin
    TableChoiceChanged(Cntrl,Epi);
    WaitDlg.Hide;
  End;

  Finally

    GraphChoiceDlg.Free;
  End;

End;

{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

Procedure TOutputScreen.TableChoiceChanged(ControlOutput, EpiGraph :Boolean);
{ This procedure sends the appropriate variables and their data to the
  DBGrids, depending on what is shown in the dialog }

Const MaxFields = 253;  {Paradox files only accept 255 fields, so 254 variables and one date and one time}

Var NumToList, NumValues  : Integer;
    Loop                  : Integer;
    Results               : TResultsCollection;
    CurrResults           : TResults;
    Table                 : TTable;
    Seg                   : VerticalSegments;
    PH                    : TResHeader;
    OuterLoop, CurrentField : Integer;
    DP                    : TDataPoint;
    StateValue            : Double;

           {----------------------------------------------------------------}
            Procedure ClearTable(Var WT:TTable; nm: String);
            Var Num: Integer;
                FN: String;
            Begin
              FN := nm;
              num := 0;
              While FileExists(Output_Dir+FN+'.db') do
                Begin
                  Inc(Num);
                  FN := nm + IntToStr(Num);
                End;

              with WT do begin
                Active:=False;
                DatabaseName:=Output_Dir;
                TableName:=FN+'.db';
                FieldDefs.Clear;
                IndexDefs.Clear;
                FieldDefs.Add('Date',ftDate,0,False);
                FieldDefs.Add('Time',ftTime,0,False);
              End;
            End;
           {----------------------------------------------------------------}
            Procedure MakeTableEntry(Var T:TTable; N: Integer; RC: TResultsCollection);
            Var Name: String;
                PH2 : TResHeader;
                WorkStudy: TAQUATOXSegment;
                i: Integer;
            Begin
              If Not All_Segs then
                Begin
                  PH2 := RC.Headers.At(N);
                  Name:=PH2.ListStr(False);
                  T.FieldDefs.Add(Name,ftFloat,0,False);
                  exit;
                End;

              For i:=0 to LinkedS.SegmentColl.Count-1 do
                Begin
                   WorkStudy := LinkedS.SegmentColl.At(i);
                   If WorkStudy.SV.Location.SiteType = TribInput then continue; {output irrelevant for tributary segs}
                   Name:=WorkStudy.SegNumber+'_'+TResHeader(RC.Headers.At(N)).ListStr(False);
                   T.FieldDefs.Add(Name,ftFloat,0,False);
                End;
            End;
           {----------------------------------------------------------------}
           Procedure SetupButtons;
           Begin
             {BUTTON SETUP}
             If (NumToList=0) or (NumValues=0) then
               Begin
                 If Not ControlOutput
                    Then Begin
                           If NumValues=0 then ChartChangeButt.Visible:=False; {change vars. btn}
                           {PrntBtn1.Visible:=False; {print table btn}
                         End
                    Else Begin
                           If NumValues=0 then ContrChangeButt.Visible:=False; {change vars. btn}
                           {PrntBtn2.Visible:=False; {print table btn}
                         End;
               End
             Else   { NumToGraph > 0 }
                 If not ControlOutput
                    Then Begin
                           If TPVSeg.Visible
                             then if EpiGraph then PerturbLabel.Caption := 'Perturbed Simulation: '+EpiString
                                              else PerturbLabel.Caption := 'Perturbed Simulation: '+HypString
                             else PerturbLabel.Caption := 'Perturbed Simulation: Results';
                           ChartChangeButt.Visible:=True; {change vars. btn}
                           {PrntBtn1.Visible:=True; {print table btn}
                         End
                    Else Begin
                           If TCVSeg.Visible
                             then if EpiGraph then ControlTitle.Caption := 'Control Simulation: '+EpiString
                                              else ControlTitle.Caption := 'Control Simulation: '+HypString
                             else ControlTitle.Caption := 'Control Simulation: Results';
                           ContrChangeButt.Visible:=True; {change vars. btn}
                           {PrntBtn2.Visible:=True; {print table btn}
                         End;
           End;
           {----------------------------------------------------------------}
           Function GetLinkedDP(PH: TResHeader;SegLoop,OuterLoop:Integer): Boolean;
           Var AQTS: TAQUATOXSegment;
               Res: TResultsCollection;
               SegPH: TResHeader;
               i: Integer;
           Begin
             DP := nil;  Result := True;
             AQTS := LinkedS.SegmentColl.At(SegLoop);
             If AQTS.SV.Location.SiteType = TribInput then
                Begin
                  Result := False; {Output irrelevant for tributary-input segments}
                  Exit;
                End;

             If ControlOutput then Res := AQTS.SV.ControlResults[Epilimnion]
                              else Res := AQTS.SV.Results[Epilimnion];
             For i := 0 to Res.Headers.Count-1 do
               Begin
                 SegPH := Res.Headers.At(i);
                 If (PH.AllState = SegPH.AllState) then
                  if (PH.HeadStr = SegPH.HeadStr) then
                   Begin
                     DP := TResults(Res.At(OuterLoop)).DataPoints.At(SegPH.PointIndex);
                     Break;
                   End;
               End;


           End;
           {----------------------------------------------------------------}

Var Upper, SegLoop, NumToWrite:Integer;
    AQTS: TAQUATOXSegment;
    SS: String[25];
Begin
  If not WaitDlg.Visible then WaitDlg.Setup('Please Wait, Writing to Database');

  If EpiGraph then Seg := Epilimnion else Seg := Hypolimnion;
  If All_Segs then Seg := Epilimnion;

  If not ControlOutput then  Table := Table1
                       else  Table := Table2;

  If ControlOutput then Results := OutputStudy.SV.ControlResults[Seg]
                   else Results := OutputStudy.SV.Results[Seg];

  NumValues := Results.Count;

  NumToList:=GraphChoiceDlg.DstList.Items.Count;
  If All_Segs then NumToList := (NumToList * LinkedS.SegmentColl.Count);

  If NumToList>MaxFields then
      Begin
        MessageDlg('Your choices would produce an output table with '+IntToStr(NumToList)+
                   ' columns.  You cannot produce an output table with over '+IntToStr(MaxFields)+
                   ' columns.',mterror,[mbOK],0);
        Exit;
      End;

  SetupButtons;

  {Clear Tables}
  If not ControlOutput then ClearTable(Table,'SV_OUT')
                       else ClearTable(Table,'C_SV_OUT');

  If NumToList=0 then exit;

  For Loop:=0 to Results.Headers.Count-1 do
      Begin
        PH := Results.Headers.At(Loop);
        SS := PH.ListStr(False);
        If GraphChoiceDlg.DstList.Items.IndexOf(SS)>-1 then
          Begin
            MakeTableEntry(Table,Loop,Results);
            { Create Appropriate Fields to Display }
            Inc(TeaseInc);
            If TeaseInc=25 then Begin WaitDlg.Tease; TeaseInc:=1; End;
          End;
      End; {loop}

      If Table.FieldDefs.Count<2 then exit;

      Table.CreateTable;
      Table.Active:=True;

      TFloatField(Table.Fields[1]).DisplayFormat:=ShortTimeFormat;
      For Loop:=2 to Table.FieldDefs.Count-1 do
        Begin
          TFloatField(Table.Fields[loop]).DisplayFormat:='#,##0.####';
          TFloatField(Table.Fields[loop]).DisplayWidth := 9; {RAP, 12/7/95}
        End;

        If All_Segs then              //Count number of entries to write
          Begin
            NumtoWrite:=999999;
            For OuterLoop := 0 to LinkedS.SegmentColl.Count-1 do
              Begin
                AQTS := LinkedS.SegmentColl.At(OuterLoop);
                If AQTS.SV.Location.SiteType = TribInput then Continue; {Output irrelevant for tributary-input segments}
                If ControlOutput then Results := AQTS.SV.ControlResults[Epilimnion]
                                 else Results := AQTS.SV.Results[Epilimnion];
                If NumToWrite > Results.Count-1 then
                   NumToWrite := Results.Count-1;
             End;
          End else NumToWrite := Results.Count-1;

      For OuterLoop:=0 to NumToWrite do
        Begin
          {Create a new row of the table and add the date}
          Table.Append;
          CurrResults:=Results.At(OuterLoop);   // crashhere

          Table.Fields[0].AsDateTime:=CurrResults.Date;
          Table.Fields[1].AsDateTime:=CurrResults.Date;

          CurrentField := 2;

          For Loop:=0 to Results.Headers.Count-1 do
            Begin
              PH := Results.Headers.At(Loop);
              SS := PH.ListStr(False);
              If All_Segs then Upper := LinkedS.SegmentColl.Count-1
                          else Upper := 0;
              If GraphChoiceDlg.DstList.Items.IndexOf(SS)>-1 then
               For SegLoop := 0 to Upper do
                Begin
                  If All_Segs then Begin If not GetLinkedDP(PH,SegLoop,OuterLoop) then Continue End
                              else DP := CurrResults.DataPoints.At(PH.PointIndex);
                  StateValue := DP.State;
                  Table.Fields[CurrentField].AsFloat:=StateValue;
                  If (StateValue>1e4) or ((StateValue<>0.0) and (StateValue<0.001)) then
                    begin
                      TFloatField(Table.Fields[CurrentField]).DisplayFormat:='0.000e-00';
                      TFloatField(Table.Fields[CurrentField]).DisplayWidth := 9; {RAP, 12/7/95}
                    end;
                  Inc(CurrentField);

                  Inc(TeaseInc);
                  If TeaseInc=25 then Begin WaitDlg.Tease; TeaseInc:=1; End;
                End;
            End;
        End;

   Table.First;
End;

{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

procedure TOutputScreen.ThresholdButtClick(Sender: TObject);
Var MR: TModalResult;
    PLeftThresh,PThresh: PDouble;
begin

  Application.CreateForm(TThresholdForm,ThresholdForm);

  PThresh := @GSRStudy.SV.Graphs.GArray[GraphListBox.ItemIndex].data.Threshold;
  PLeftThresh := @GSRStudy.SV.Graphs.GArray[GraphListBox.ItemIndex].data.Left_Thresh;

  With ThresholdForm do
    Repeat
      EnteredVal := PThresh^;
      LeftAxisButt.Checked := (PLeftThresh^=1);
      LeftAxisButt.Enabled := LeftAxisItems;
      RightAxisButt.Enabled := RightAxisItems;
      LeftUnit := Chart1.LeftAxis.Title.Caption;
      RightUnit := Chart1.RightAxis.Title.Caption;
      Memo1.Lines := ThreshResults;
      If PThresh^ <> -9999 then ThreshEdit.Text := FloatToStrF(PThresh^,ffgeneral,6,3);

      MR := ShowModal;
      If MR = MRCancel then Begin ThresholdForm.Free; exit; End;

      PThresh^ := EnteredVal;
      If LeftAxisButt.Checked then PleftTHresh^ := 1
                              else PleftTHresh^ := 0;

      ShowChosenGraph;
    Until (MR=MROK);

  ThresholdForm.Free;
end;

{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

procedure TOutputScreen.ChartClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var GSR:TGraphSetup;
    PctString, VarString, DirString: String;
begin
  If Sender.Name = 'Chart1' then
    Begin
      If ScenarioBox.ItemIndex < 2
        then
          Begin
            GSR := GSRStudy.SV.Graphs.GArray[GraphListBox.ItemIndex];
            Case GSR.data.Graphtype of
              0: If Series.Title = ''
                then ShowMessage('Error Bar, '+ Datetostr(Series.XValue[valueindex]) + ':  ' + Floattostrf(Series.YValue[valueindex],ffGeneral,6,3))
                else ShowMessage(Series.Title+', '+ Datetostr(Series.XValue[valueindex]) + ':  ' + Floattostrf(Series.YValue[valueindex],ffGeneral,6,3));
              1: If Series.Name <> 'Threshold' then ShowMessage(Series.Title+' meets or exceeds '+ Floattostrf(Series.YValue[valueindex],ffGeneral,6,3) +',  '+ Floattostrf(Series.XValue[valueindex],ffFixed,6,1) + '% of the time.' );
              2: If Series.Name <> 'Threshold' then ShowMessage(Series.Title+' meets or exceeds '+ Floattostrf(Series.YValue[valueindex],ffGeneral,6,3)
                 +' for '+ Floattostrf(Series.XValue[valueindex],ffFixed,6,1) + ' days;  '+
                 Series.Title+' is less than '+ Floattostrf(Series.YValue[valueindex],ffGeneral,6,3)
                 +' for '+ Floattostrf(Series.XValue[Series.Count-1] - Series.XValue[valueindex],ffFixed,6,1) + ' days.' );
              3: ShowMessage(Chart1.BottomAxis.Title.Caption +': ' + Floattostrf(Series.XValue[valueindex],ffGeneral,6,3) +', '+ Series.Title+': ' + Floattostrf(Series.YValue[valueindex],ffGeneral,6,3));
            End; {case}
          End
        else
          Begin
            If Series.YValue[valueindex]< 0
              then ShowMessage('The perturbation caused '+Series.Title+' to decrease by '+Floattostrf(-Series.YValue[valueindex],ffGeneral,5,2)
                            +'% on ' +Datetostr(Series.XValue[valueindex]))
              else ShowMessage('The perturbation caused '+Series.Title+' to increase by '+Floattostrf(Series.YValue[valueindex],ffGeneral,5,2)
                            +'% on ' +Datetostr(Series.XValue[valueindex]));
          End;
    End;

  If (Sender.Name='Chart4') then
    If BioRiskGraph then ShowMessage('There is a '+Floattostrf(Series.YValue[valueindex],ffGeneral,4,2)+' percent chance that '+Series.Title+' will decline '+ Floattostrf(Series.XValue[valueindex],ffGeneral,4,2)+' percent')
      else If SensGraph then Begin
                               PctString := FloatToStrF(SensPercent,fffixed,6,0);
                               If Series = Chart4.Series[0] then DirString := 'Increasing'
                                                            else DirString := 'Decreasing';
                               VarString := TCustomSeries(Chart4.Series[0]).XLabel[ValueIndex];
                               Delete(VarString,1,Pos('-',Varstring));

                               If ShowEffects
                                 then
                                     ShowMessage(DirString+' the variable "'+UncBox1.Text + '" by ' + PctString +
                                                 '% caused a '+Floattostrf(Series.XValue[valueindex],ffGeneral,4,2)+'% change in'+
                                                  VarString)
                                 else
                                     ShowMessage(DirString+' the variable "'+VarString + '" by ' + PctString +
                                                 '% resulted in an average output value of '+Floattostrf(Series.XValue[valueindex],ffGeneral,5,3)+
                                                 ' as compared to the baseline result of '+Floattostrf(THorizBarSeries(Series).YOrigin,ffGeneral,5,3));
                             End
                        else ShowMessage(Series.Title+', '+ Datetostr(Series.XValue[valueindex]) + ':  ' + Floattostrf(Series.YValue[valueindex],ffGeneral,6,3));

end;


procedure TOutputScreen.ArrangeGraphs1Click(Sender: TObject);
begin
  OrganizeGraphs;
end;

procedure TOutputScreen.BGraphSetupButtonClick(Sender: TObject);
Var WorkingChart: TChart;

begin
  Case TButton(Sender).Name[1] of
    'A': WorkingChart:=Chart1;
{   'B': WorkingChart:=Chart2;
    'C': WorkingChart:=Chart3; }
    else WorkingChart:=Chart4;
  end; {Case}

  Application.CreateForm(TChartProperties, ChartProperties);

  ChartProperties.ChangeProp(WorkingChart);
  ChartProperties.Free;
  WorkingChart.Refresh;
  WorkingChart.Repaint;
end;

procedure TOutputScreen.Copy1Click(Sender: TObject);
begin
  CopyButtonClick(nil);
end;

procedure TOutputScreen.CopyButtonClick(Sender: TObject);
Var WorkingChart: TChart;
begin
  Application.CreateForm(TCopyClipbd, CopyClipbd);
  Try
  If CopyClipBd.Showmodal=mrcancel then exit;

  If Sender = nil then WorkingChart:=Chart1
                  else WorkingChart:=Chart4;

  If CopyClipBd.BmpButt.Checked then WorkingChart.CopytoClipBoardBitmap
                                else WorkingChart.CopytoClipBoardMetaFile(True);

  Finally
    CopyClipbd.Free;
  End;
end;

Procedure TOutputScreen.MakeVariableList(RC: TResultsCollection; N: Integer);
Var PH: TResHeader;
    SS: String[25];
Begin
  PH := TResHeader(RC.Headers.At(N));
  SS := PH.ListStr(False);
  GraphChoiceDlg.MasterList.Add(SS);
End;

procedure TOutputScreen.NewGraphClick(Sender: TObject);
Var NewGraph: TGraphSetup;
begin

  Application.Createform(TDefaultGraphForm,DefaultGraphForm);
  DefaultGraphForm.PR := OutputStudy.SV.Results[Epilimnion];
  DefaultGraphForm.CR := OutputStudy.SV.ControlResults[Epilimnion];
  DefaultGraphForm.SV := OutputStudy.SV;

  DefaultGraphForm.ScenarioBox.ItemIndex := ScenarioBox.ItemIndex;

  NewGraph := DefaultGraphForm.ChooseDefaultGraph(All_Segs);
  If NewGraph = nil then Exit;

  GSRStudy.SV.Graphs.AddGraph(NewGraph);
  CreateGraphList;
  ShowChosenGraph;
  Changed := Now;

  DefaultGraphForm.Free;

  If NewGraph.data.GraphName = 'New Graph' then EditGraphClick(nil);

end;

procedure TOutputScreen.Down2Click(Sender: TObject);
var i: integer;
begin
  i := ScenarioBox.ItemIndex+1;
  If i = ScenarioBox.Items.Count then i := 0;
  ScenarioBox.ItemIndex := i;
  ShowChosenGraph;
end;


procedure TOutputScreen.down1Click(Sender: TObject);
var i: integer;
begin
  i := GraphListBox.ItemIndex+1;
  If i = GraphListBox.Items.Count then i := 0;
  GraphListBox.ItemIndex := i;
  GraphListBoxChange(nil);
end;


procedure TOutputScreen.Up1Click(Sender: TObject);
var i: integer;
begin
  i := GraphListBox.ItemIndex-1;
  If i = -1 then i := GraphListBox.Items.Count-1;
  GraphListBox.ItemIndex := i;
  GraphListBoxChange(nil);
End;

procedure TOutputScreen.Up2Click(Sender: TObject);
var i: integer;
begin
  i := ScenarioBox.ItemIndex-1;
  If i = -1 then i := ScenarioBox.Items.Count-1;
  ScenarioBox.ItemIndex := i;
  ShowChosenGraph;
End;

{--  Sensitivity Up-Down  --}
procedure TOutputScreen.Up3Click(Sender: TObject);
var i: integer;
begin
  If UncBox1.Items.Count=0 then Exit;
  i := UncBox1.ItemIndex-1;
  If i = -1 then i := UncBox1.Items.Count-1;
  UncBox1.ItemIndex := i;
  Draw_Tornado(UncBox1.ItemIndex);
End;

procedure TOutputScreen.Down3Click(Sender: TObject);
Var i: Integer;
begin
  If UncBox1.Items.Count=0 then Exit;
  i := UncBox1.ItemIndex+1;
  If i = UncBox1.Items.Count then i := 0;
  UncBox1.ItemIndex := i;
  Draw_Tornado(UncBox1.ItemIndex);
end;
{---------------------------}

Procedure TOutputScreen.UpdateDst(ControlOutput, EpiGraph, IsTable :Boolean);
Var WorkingTable: TTable;
    WorkingChart: TChart;
    Loop        : Integer;
Begin
  {Clear the graphing choice dialog}
  GraphChoiceDlg.SourceList.Clear;
  GraphChoiceDlg.DstList.Clear;

  If IsTable then
    Begin
      WorkingTable := Table1;
      If ControlOutput then WorkingTable := Table2;
      For Loop := 2 to WorkingTable.FieldCount-1 do
        GraphChoiceDlg.DstList.Items.Add(WorkingTable.Fields[Loop].FieldName);
    End;

  If Not IsTable then
    Begin
      WorkingChart:=Chart1;
{      If ControlOutput then WorkingChart:=Chart2; }
      For Loop := 0 to WorkingChart.SeriesCount-1 do
        GraphChoiceDlg.DstList.Items.Add(WorkingChart.SeriesList.Items[Loop].Title);
    End;
End;

procedure TOutputScreen.Chart1AfterDraw(Sender: TObject);
var tmpX,tmpY:LongInt;
    i: Integer;
begin
  with TChart(Sender) do
   For i := 1 to NCL do
    With ChartLines[i-1] do
     Begin

        tmpY :=TChart(Sender).Series[SeriesIndex].GetVertAxis.CalcPosValue(Y1);
        tmpX :=TChart(Sender).Series[SeriesIndex].GetHorizAxis.CalcPosValue(X1);
        TChart(Sender).Canvas.Pen.Color:=Clr;
        TChart(Sender).Canvas.Pen.Width:=PWid;
        TChart(Sender).Canvas.MoveTo(tmpX,tmpY);
        If LineType = 1 {Err Bar} then
          Begin
           TChart(Sender).Canvas.LineTo(tmpX+3,tmpY);
           TChart(Sender).Canvas.LineTo(tmpX-3,tmpY);
          End;
        If LineType = 2 {ND LT} then
          Begin
           TChart(Sender).Canvas.LineTo(tmpX,tmpY+12);
           TChart(Sender).Canvas.LineTo(tmpX-4,tmpY+6);
           TChart(Sender).Canvas.LineTo(tmpX+4,tmpY+6);
           TChart(Sender).Canvas.LineTo(tmpX,tmpY+12);
          End;

        If LineType = 3 {ND GT} then
          Begin
           TChart(Sender).Canvas.LineTo(tmpX,tmpY-12);
           TChart(Sender).Canvas.LineTo(tmpX-4,tmpY-6);
           TChart(Sender).Canvas.LineTo(tmpX+4,tmpY-6);
           TChart(Sender).Canvas.LineTo(tmpX,tmpY-12);
          End;

        If LineType = 4 {Left Axis Log10 Tick Marks} then
            TChart(Sender).Canvas.LineTo(tmpX,tmpY);       //jsc adjust 4/30/12
            TChart(Sender).Canvas.LineTo(tmpX-5,tmpY);

        If LineType = 5 {Right Axis Log10 Tick Marks} then
            TChart(Sender).Canvas.LineTo(tmpX-1,tmpY);     //jsc adjust 4/30/12
            TChart(Sender).Canvas.LineTo(tmpX+4,tmpY);
       End;

{   TOutputScreen(Self).Color:=ClSilver; }
  {somehow above code was setting form color to black, this line works around that bug}
end;

{----------------------------------------------------------------------------------}

procedure TOutputScreen.Chart1GetNextAxisLabel(Sender: TChartAxis;
  LabelIndex: Integer; var LabelValue: Double; var Stop: Boolean);
Var Min, Max: Integer;
begin
  If not Sender.Logarithmic then Begin Stop := True; exit; End;
  If Sender.Minimum>0 then Min := Trunc(Log10(Sender.Minimum)) else Min := 0;
  Max := Trunc(Log10(Sender.Maximum))+2;
  LabelValue := POWER(10,Min+LabelIndex);
  Stop := (LabelValue = Max);
end;

procedure TOutputScreen.Chart1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  {}
end;

procedure TOutputScreen.Chart4AfterDraw(Sender: TObject);
Var TmpY, TmpX: LongInt;
    TBS: THorizBarSeries;
begin
    If Not SensGraph then Exit;
    TBS := THorizBarSeries(Chart4.Series[0]);
    tmpX :=Chart4.Series[0].GetHorizAxis.CalcPosValue(TBS.YOrigin);
    tmpY :=Chart4.Series[0].GetVertAxis.CalcPosValue(Chart4.LeftAxis.Minimum);
    Chart4.Canvas.Pen.Color:=ClBlack;
    Chart4.Canvas.Pen.Width:=1;
    Chart4.Canvas.MoveTo(tmpx, tmpy);
    tmpY :=Chart4.Series[0].GetVertAxis.CalcPosValue(Chart4.LeftAxis.Maximum);
    Chart4.Canvas.LineTo(tmpx,tmpy);
end;

{----------------------------------------------------------------------------------}

procedure TOutputScreen.ChartChangeButtClick(Sender: TObject);
Var WorkingTable: TTable;
    Control   : Boolean;
    Epi       : Boolean;
    VSeg      : VerticalSegments;
    Loop      : Integer;
    RC        : TResultsCollection;
    PCFileN: array[0..300] of Char;

begin
  Application.CreateForm(TGraphChoiceDlg, GraphChoiceDlg);
  GraphChoiceDlg.Caption := 'AQUATOX-- Select Results to Display';
  GraphChoiceDlg.DstLabel.Caption := 'Results to Display:';

  Try

  Control:= not (TComponent(Sender).Name='ChartChangeButt');

  WorkingTable := Table1;
  If Control then WorkingTable:=Table2;

  Epi:=True;
  If not Control and (TPVSeg.Caption='View '+EpiString) then Epi:=False;
  If Control and ( TCVSeg.Caption='View '+EpiString)    then Epi:=False;

  If Epi then VSeg:=Epilimnion
         else VSeg:=Hypolimnion;

  If Control then RC := OutputStudy.SV.ControlResults[VSeg]
             else RC := OutputStudy.SV.Results[Vseg];

  GraphChoiceDlg.SourceList.Clear;
  GraphChoiceDlg.DstList.Clear;

  If not ALL_SEGS then
    For Loop := 2 to WorkingTable.FieldCount-1 do  {Skip date and time}
      GraphChoiceDlg.DstList.Items.Add(WorkingTable.Fields[Loop].FieldName);

  For Loop := 0 to RC.Headers.Count-1 do
    MakeVariableList(RC,Loop);

  If GraphChoiceDlg.ShowModal<> MrCancel then
    Begin
      WorkingTable.Active:=False;
      StrPCopy(PCFileN,WorkingTable.DatabaseName+'\'+WorkingTable.TableName);
      If FileExists(WorkingTable.DatabaseName+'\'+WorkingTable.TableName) then DeleteFile(PCFileN);
      TableChoiceChanged(Control,Epi);
      WaitDlg.Hide;
    End;

  Finally
    GraphchoiceDlg.Free;
  End;
end;

procedure TOutputScreen.UncToggleClick(Sender: TObject);
begin
  Chart4.LeftAxis.Automatic := True;
  BioRiskGraph := Not BioRiskGraph;

  If BioRiskGraph then UncToggle.Caption := 'View Mean, Min., Max.'
                  else UncToggle.Caption := 'View Biomass Risk Graph';

  If BioRiskGraph then ChangeDBaseButt.Caption := 'View a Different CSV File'
                  else ChangeDBaseButt.Caption := 'View a Different Database';

  ShowMinMax.Visible := not BioRiskGraph;

  Update_UncertGraph;
end;

procedure TOutputScreen.ChartHelpButtonClick(Sender: TObject);
begin
  Case OutputNotebook.PageIndex of
       2:  HTMLHelpContext('Viewing_Graphical_Output.htm');
       3:  HTMLHelpContext('Topic72.htm');  {Uncertainty}
       else HTMLHelpContext('Viewing_Chart_Output.htm');
  end; {Case}
end;


procedure TOutputScreen.GraphListBoxChange(Sender: TObject);
begin
  If UpdatingScreen then Exit;
  ShowChosenGraph;
end;


{------------------------------------------------------------------------------}

procedure TOutputScreen.graphmenuChange(Sender: TObject);
begin
  If Not ExecuteMenu then Begin
                            ExecuteMenu := True;
                            Exit;
                          End;  

  ExecuteMenu := False;
  RepeatButton.Visible := True;
  Case GraphMenu.ItemIndex of
    0: CopyButtonClick(nil);
    1: PChartbuttClick(nil);
    2: GraphSetupChoose;
    3: EraseCurrentGraph;
    4: ToggleSegment;
    5: ChartHelpButtonClick(nil);
    6: ExternalData;
    7: SteinhausClick(nil);
    8: CalcTSIs;
    9: Begin
         ExportGraphsToWord(ScenarioBox.ItemIndex=0);
         WordInitialized := False;
       End;
    10: OrganizeGraphs;
    11: CalcStatistics;
  End; {Case}
  ExecuteMenu := True;

end;

procedure TOutputScreen.graphmenuClick(Sender: TObject);
begin
end;

{------------------------------------------------------------------------------}

procedure TOutputScreen.refreshbuttClick(Sender: TObject);
begin
  Draw_Tornado(UncBox1.ItemIndex);
end;

procedure TOutputScreen.ExportAllClick(Sender: TObject);
var
  Range: Variant;
  NumPars: Integer;
  Loop: Integer;

        Procedure AddandSelect;
        Begin
        WordApp.Documents.Item(1).Paragraphs.Add;
        NumPars := WordApp.Documents.Item(1).Paragraphs.Count;
        Range := WordApp.Documents.Item(1).Range(
            WordApp.Documents.Item(1).Paragraphs.Item(NumPars).Range.Start,
            WordApp.Documents.Item(1).Paragraphs.Item(NumPars).Range.End);
        End;


Begin
   If not WordInitialized then
      Begin
        try
          WordApp := GetActiveOLEObject('Word.Application');
        except
          WordApp := CreateOLEObject('Word.Application');
        end;
        WordApp.Visible := True;
        WordApp.Documents.Add;
        WordApp.Documents.Item(1).Paragraphs.Add;
        WordInitialized := True;
      End;

      For Loop := 0 to UncBox1.Items.Count-1 do
        Begin
          UncBox1.ItemIndex := Loop;
          UncBox1.Update;
          UncBox1Change(nil);
{          ShowChosenGraph; }
          Chart4.CopytoClipBoardMetaFile(True);  {Bitmap; {MetaFile(True); }

          NumPars := WordApp.Documents.Item(1).Paragraphs.Count;
          WordApp.Documents.Item(1).Paragraphs.Add;
          WordApp.Documents.Item(1).Paragraphs.Add;
          WordApp.Documents.Item(1).Paragraphs.Add;

          Range := WordApp.Documents.Item(1).Range(
          WordApp.Documents.Item(1).Paragraphs.Item(NumPars + 2).Range.Start,
          WordApp.Documents.Item(1).Paragraphs.Item(NumPars + 2).Range.End);
          Range.Paste;

{          WordApp.Documents.Item(1).Paragraphs.Add;
          AddAndSelect;
          Range.Text := MakeFileName;
          AddAndSelect;
          Range.Text := DateTimeToStr(Now()); }
        End;
End;

Procedure TOutputScreen.CalcTSIs;
Var GSR:TGraphSetup;
Begin
  If All_Segs then
    Begin
      MessageDlg('You must choose an individual segment before calculating TSIs.'
                 ,MTWarning,[MBOK],0);
      Exit;
    End;

  Application.CreateForm(TTSI_Form, TSI_Form);

  If SegBox.Visible
   then
    Begin
      TSI_Form.CtrlDate := LinkedS.ControlRun;
      TSI_Form.PertDate := LinkedS.LastRun;
      TSI_Form.StudyName := 'Segment '+MainStudy.SegNumber + ': "'+ LinkedS.Filename + '" '+LinkedS.SystemName;
    End
   else
    Begin
      TSI_Form.CtrlDate := OutputStudy.ControlRun;
      TSI_Form.PertDate := OutputStudy.LastRun;
      TSI_Form.StudyName := '"'+OutputStudy.FileName+'" '+OutputStudy.StudyName;
    End;

  GSR := GSRStudy.SV.Graphs.GArray[GraphListBox.ItemIndex];
  TSI_Form.CalculateTSIs(ScenarioBox.ItemIndex = 0, (GSR.data.VSeg = Epilimnion),
                         OutputStudy.SV.Results,OutputStudy.SV.ControlResults);

  TSI_Form.Free;
End;

Procedure TOutputScreen.OrganizeGraphs;
Var i: Integer;
Begin
  Application.CreateForm(TGraphArrangeForm, GraphArrangeForm);

  With GSRStudy.SV.Graphs do
    Begin
      If NumGraphs = 0 then
              Begin
                 MessageDlg('There are no graphs to arrange.'
                            ,MTWarning,[MBOK],0);
                 Exit;
              End;

      For i := 1 to NumGraphs do
        GraphArrangeForm.ListBox1.Items.Add(GArray[i-1].data.GraphName);
      If GraphArrangeForm.ShowModal = MROK then
        Begin
          GraphArrangeForm.ArrangeGraphs(GSRStudy.SV.Graphs);
          GSRStudy.SV.Graphs.SelectedGraph := 0;
          CreateGraphList;
          Changed := Now;
          ShowChosenGraph;
        End;

    End;

  GraphArrangeForm.Free;

End;

procedure TOutputScreen.OtherSegment1Click(Sender: TObject);
begin
  ToggleSegment;
end;

Procedure TOutputScreen.CalcStatistics;
Var GSR:TGraphSetup;
Begin
  If GraphListBox.ItemIndex = -1 then exit;

  Application.CreateForm(TStatistic_Form, Statistic_Form);

  GSR := GSRStudy.SV.Graphs.GArray[GraphListBox.ItemIndex];

  Statistic_Form.ALL_SEGS  := ALL_SEGS;
  Statistic_Form.LinkedS   := LinkedS;
  Statistic_Form.OutputStudy   := OutputStudy;
  Statistic_Form.OSPtr := OutputScreen;   
  Statistic_Form.CalculateStatistics(ScenarioBox.ItemIndex = 0, GSR,
                         OutputStudy.SV.Results,OutputStudy.SV.ControlResults);

  Statistic_Form.Free;
End;

{------------------------------------------------------------------------------}

Procedure TOutputScreen.ExternalData;
Begin
  If MainStudy = nil then
    Begin
      MessageDlg('Error, Main Study Window has been closed.',mterror,[mbok],0);
      Exit;
    End;

  Application.CreateForm(TEdit_Data_Form, Edit_Data_Form);
  Edit_Data_Form.EditObsData(MainStudy.SV.ObservedData);
  If Edit_Data_Form.Changed then MainStudy.LastChange := Now;
  Edit_Data_Form.Free;
  ShowChosenGraph;

End;

procedure TOutputScreen.ExternalData1Click(Sender: TObject);
begin
  ExternalData;
end;

{------------------------------------------------------------------------------}

procedure TOutputScreen.ToggleSegment;
Var GSR: TGraphSetup;
   HypExists: Boolean;
   Control: Boolean;
begin

 Control := ScenarioBox.ItemIndex = 0;
 If Control then HypExists := OutputStudy.SV.ControlResults[Hypolimnion].Count > 0
            else HypExists := OutputStudy.SV.Results[Hypolimnion].Count > 0;

 If Not HypExists then
   Begin
     MessageDlg('No results exist for the hypolimnion segment.',MtInformation,[MBOK],0);
     Exit;
   End;

  GSR := GSRStudy.SV.Graphs.GArray[GraphListBox.ItemIndex];
  With GSR.Data do
    If VSeg = Epilimnion then VSeg := Hypolimnion
                         else VSeg := Epilimnion;
  ShowChosenGraph;
end;

procedure TOutputScreen.ToggleSensitivityClick(Sender: TObject);
begin
  ShowEffects := not ShowEffects ;
  If ShowEffects
    then
      Begin
        ToggleSensitivity.Caption := 'Sensitivities';
        UncBox1.Items.Assign(RowLabels);
        NumRungsLabel.Caption := 'Show         Largest Effects';
        ShowSens.Caption := 'List Effects';
      End
    else
      Begin
        ToggleSensitivity.Caption := 'Show Effects';
        UncBox1.Items.Assign(ColLabels);
        NumRungsLabel.Caption := 'Show         Most Sensitive Variables';
        ShowSens.Caption := 'List Sensitivities';
      End;

  UncBox1.ItemIndex := 0;
  Draw_Tornado(0);
end;

{------------------------------------------------------------------------------}

procedure TOutputScreen.GraphSetup1Click(Sender: TObject);
begin
  GraphSetupChoose;
end;

procedure TOutputScreen.GraphSetupChoose;

   Procedure SetupAllSegVars;
   Var NSegs, SegLoop: Integer;
       WorkingSeg : TAQUATOXSegment;
   Begin
     NSegs := LinkedS.SegmentColl.Count;
     GraphSetupScreen.NSegs := NSegs;
     For SegLoop := 1 to NSegs do
       Begin
         WorkingSeg := LinkedS.SegmentColl.At(SegLoop-1);
         If WorkingSeg.SV.Location.SiteType = TribInput then
           Begin
             Dec(GraphSetupScreen.NSegs);
             Continue; {Output irrelevant for tributary-input segments}
           End;
       End;
   End;


begin
  Application.CreateForm(TGraphSetupScreen, GraphSetupScreen);

  If ALL_Segs then SetupAllSegVars;
  GraphSetupScreen.Linked := ALL_Segs;
//  GraphSetupScreen.
  GraphSetupScreen.EditProp(Chart1,GSRStudy.SV.Graphs.GArray[GraphListBox.ItemIndex],ScenarioBox.ItemIndex = 2);
  GraphSetupScreen.Free;
  ShowChosenGraph;
end;


procedure TOutputScreen.Help1Click(Sender: TObject);
begin
   ChartHelpButtonClick(nil);
end;

procedure TOutputScreen.graphmenuKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ExecuteMenu := ((Key = 13) or (Key = Ord(' ')));

  If ExecuteMenu
    then Begin Key:=0; GraphMenuChange(nil); End
    else if SendMessage(GraphMenu.Handle, CB_GETDROPPEDSTATE, 0, 0) <> 1
      then SendMessage(GraphMenu.Handle, CB_SHOWDROPDOWN, 1, 0);
end;

procedure TOutputScreen.FormDestroy(Sender: TObject);
Var  FileN: array[0..300] of Char;
     GraphHolder: TGraphs;
begin
  Table1.Active:=False;
  Table2.Active:=False;

  Try
    If (MainStudy<>nil) and (MainStudy<>GSRStudy) then
      Begin
        GraphHolder := MainStudy.SV.Graphs;
        MainStudy.SV.Graphs := GSRStudy.SV.Graphs;
        If Changed > MainStudy.LastChange then
            MainStudy.LastChange := Changed;
        GraphHolder.Destroy;
      End;

    If RowLabels <> nil then RowLabels.Free;
    If ColLabels <> nil then ColLabels.Free;

  Except
  End;

  If (MainStudy<>GSRStudy) then GSRStudy.SV.Graphs := nil;
  If ALL_Segs
    then Begin
           If LinkedS <> nil then LinkedS.Destroy;
         End
    else Begin
          If OutputStudy<>nil then
           If OutputStudy <> MainStudy then
            OutputStudy.Destroy;
         End;

  StrPCopy(FileN,Table1.DatabaseName+'\'+Table1.TableName);
  If FileExists(Table1.DatabaseName+'\'+Table1.TableName) then DeleteFile(FileN);
  StrPCopy(FileN,Table2.DatabaseName+'\'+Table2.TableName);
  If FileExists(Table2.DatabaseName+'\'+Table2.TableName) then DeleteFile(FileN);
end;

procedure TOutputScreen.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (shift = [ssAlt]) then
     if (key = ORD('M')) then
       If GraphMenu.Enabled then
         Begin
           GraphMenu.SetFocus;
           if SendMessage(GraphMenu.Handle, CB_GETDROPPEDSTATE, 0, 0) <> 1 then
              SendMessage(GraphMenu.Handle, CB_SHOWDROPDOWN, 1, 0); ;
         End;
end;

procedure TOutputScreen.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TOutputScreen.FormShow(Sender: TObject);
begin
   TornArr := nil;
   {Call the output Procedure}
  Try
    DisplayResults(OutputStudy);
  Except
    MessageDlg('Error Writing Output To Databases',mtError,[mbOK],0);
    WaitDlg.Hide;
    Close;
    Raise;
  End; {Try Except}

  If FirstShow then
    If Not (WindowState=WsMaximized) then
      Begin
        Height := 542;
        Width :=  710;
        OutputNotebook.Height := 483;
        FirstShow := False;
      End;


end;

procedure TOutputScreen.Label1Click(Sender: TObject);
begin
   If GraphMenu.Enabled then GraphMenu.SetFocus;
end;

procedure TOutputScreen.LoadFromFileClick(Sender: TObject);
Var NewStudy: TAQUATOXSegment;
    PCFileN: array[0..300] of Char;
    OpenDialog: TAQTOpenDialog;
begin
  IF All_Segs then exit;

  {if Check_Save_and_Cancel('Opening New Study') then exit; }

  NewStudy := nil;
  {Put up Load File Dialog, Exit if Cancel Pressed}

  openDialog := TAQTOpenDialog.Create(self);
  openDialog.InitialDir := Studies_Dir;
  openDialog.Options := [ofFileMustExist, ofHideReadOnly, ofEnableSizing];
  openDialog.Filter := 'AQUATOX Single Segments (*.aps)|*.aps|All Files|*.*';
  openDialog.FilterIndex := 1;
  If not openDialog.Execute then
    Begin
      opendialog.Free;
      Exit;
    End;

  {Load the File}
  WaitDlg.Setup('Please Wait One Moment, Loading File');

  Try
    LoadFile(NewStudy,OpenDialog.FileName);
  Except
    NewStudy:=nil;
    WaitDlg.Hide;
    OpenDialog.free;
    Raise;
    Exit;
  End;

  OpenDialog.free;
  WaitDlg.Hide;
  If NewStudy=nil then Exit;

  OutputStudy.Destroy;
  OutputStudy := NewStudy;
  GSRStudy := NewStudy;
  MainStudy := NewStudy;
 
  Table1.Active:=False;
  Table2.Active:=False;
  StrPCopy(PCFileN,Table1.DatabaseName+'\'+Table1.TableName);
  If FileExists(Table1.DatabaseName+'\'+Table1.TableName) then DeleteFile(PCFileN);
  StrPCopy(PCFileN,Table2.DatabaseName+'\'+Table2.TableName);
  If FileExists(Table2.DatabaseName+'\'+Table2.TableName) then DeleteFile(PCFileN);

  DisplayResults(Outputstudy);
  

end;

procedure TOutputScreen.SaveToFileClick(Sender: TObject);
Var SaveDialog: TSaveDialog;

begin
  IF All_Segs then exit;

  saveDialog := TSaveDialog.Create(nil);            
  saveDialog.Title := 'Save your results As';
  saveDialog.InitialDir := Studies_Dir;
  saveDialog.Filter := 'AQUATOX Single Segments (*.aps)|*.aps|All Files (*.*)|*.*';
  saveDialog.Options := [ofOverwritePrompt,ofPathMustExist,ofNoReadOnlyReturn,ofHideReadOnly, ofEnableSizing] ;
  saveDialog.DefaultExt := 'aps';
  saveDialog.FilterIndex := 1;

  If not SaveDialog.Execute then
    Begin
      SaveDialog.free;
      Exit;
    End;

  WaitDlg.Setup('Please Wait One Moment, Saving File');
  Enabled := False;

  Try
    OutputStudy.FileName := ExtractFileName(SaveDialog.FileName);
    OutputStudy.DirName := ExtractFilePath(SaveDialog.FileName);
    OutputStudy.SV.StoreResults := True;
    OutputStudy.SV.StoreDistribs := True;
    SaveFile(OutputStudy);
  Except
    SaveDialog.free;
    WaitDlg.Hide;
    Raise;
  End;

  WaitDlg.Hide;
  SaveDialog.free;
{  Caption := 'Output Window-- '+OutputStudy.FileName; }
  Enabled := True;

end;

procedure TOutputScreen.ScenarioSelect(Sender: TObject);
begin
   If UpdatingScreen then Exit;
   ShowChosenGraph;

end;

procedure TOutputScreen.FormActivate(Sender: TObject);
begin
  PostMessage(Handle, UM_AFTERACTIVE, 0, LongInt(Sender));
end;

procedure TOutputScreen.CSaveExcelClick(Sender: TObject);
 var
      Done, ExportBothSegs, iscontrol: Boolean;
      SegCount: Integer;
      TEx: TExcelOutput;
      dbgrd: TDBGrid2;
      intRow,       // index for query rows
      intCol  : Integer ; // index for query columns
      CurrentColumns : Variant ;   // Sheets to AutoFit
      qry   : TQuery ;  // Query related to dbgrd
      BookMark  : TBookMark ; // Bookmark for query
      BaseName: String;
      Butt: TButton;

begin
 // Initialize
   isControl := TButton(Sender).Name[1]='C';

   If isControl then dbgrd := dbgrid2
                else dbgrd := dbgrid1;

   TEx := TExcelOutput.Create(False);

   qry := nil ;
   BookMark := nil ;

   try
    // Dereference database grid to get datasource and supplying query
      qry := TQuery(TDataSource(dbgrd.DataSource).DataSet) ;

      // If the query is inactive or record count < 1 then outta here
      if qry.Active = False then
       exit ;
      if qry.RecordCount < 1 then
       exit ;

       If All_Segs then BaseName := LinkedS.FileName
                   else BaseName := OutputStudy.FileName;

       If isControl then BaseName := 'C_' + Basename
                    else BaseName := 'P_' + Basename;

       Delete(BaseName,Length(BaseName)-3,4);

       If All_Segs then BaseName := {LinkedS.DirName + } BaseName + '_Table.xls'
                   else BaseName := {OutputStudy.DirName +} BaseName + '_Table.xls';

      // Execute save dialog
      If TEx.GetSaveName(BaseName,'Please Specify an Excel File into which to Save this Table:') then
      begin
       ExportBothSegs := False;
       If (isControl and (TCVSeg.Visible)) or (not isControl and (TPVSeg.Visible))
        then ExportBothSegs := MessageDlg('Write output for both segments?',mtconfirmation,[mbyes,mbno],0) = mryes;

       WaitDlg.Setup('Please Wait, Writing Table to Excel File');

       SegCount := 0;

       REPEAT
         inc(SegCount);
         // Insert column headers into sheet
         intRow := 1;
         for intCol := 1 to qry.FieldCount do
           Begin
              TEx.WS.Cells.Item[intRow,intCol].Value := qry.Fields[intCol-1].FieldName;
              TEx.WS.Cells.Item[intRow,intCol].Font.FontStyle := 'Bold';
           End;
         WaitDlg.Tease;

         // Disable controls attached to query
         qry.DisableControls ;

         // Save place in query
         BookMark := qry.GetBookmark ;

         // Position to first row
         qry.First ;

         // Insert data into sheet
         while (not qry.EOF) do
         begin
            WaitDlg.Tease;
            inc(intRow) ;
            for intCol := 1 to qry.FieldCount do
            begin
               TEx.WS.Cells.Item[intRow,intCol].Value := qry.Fields[intCol-1].AsString;
               If IntCol=1 then
                 begin
                   WaitDlg.Tease;
                   TEx.WS.Cells.Item[intRow,intCol].Font.FontStyle := 'Bold';
                 end;
            end;

            qry.Next ;
         end ;

         CurrentColumns := TEx.WS.Columns;
         CurrentColumns.AutoFit;

         // Restore position in query
         qry.GotoBookmark(BookMark) ;

         // Free bookmark
         qry.FreeBookmark(BookMark) ;
         BookMark := nil;

         // Enable controls attached to query
         qry.EnableControls ;

         TEx.WS.Cells.Item[2,2].Select;
         TEx.Excel.ActiveWindow.FreezePanes := True;

         Done := True;
         If ExportBothSegs then
           Begin
             If isControl then Butt := TCVSeg
                          else Butt := TPVSeg;
             SegViewClick(Butt);
             TEx.WS.Name := RightStr(Butt.Caption,11);
             If SegCount = 1 then
               Begin
                 TEx.WS := TEx.Wbk.Sheets.Add(EmptyParam,TEx.Wbk.sheets.item[TEx.Wbk.sheets.count],1,xlWorkSheet,TEx.LCID) as _Worksheet;
                 Done := False;
               End;
           End;

       UNTIL Done;

       TEx.WS := TEx.Excel.Worksheets.Item[1] as _Worksheet;
       TEx.WS.Activate(TEx.LCID) ;
       TEx.SaveAndClose;

      end ;

   WaitDlg.Hide;

   // Exceptions
   except

    on E:Exception do
      begin
         // If Excel was started, quit it.
         try
           TEx.CloseFiles;
           TEx.Close;
         except
         end;
         // Restore position in query and enable controls
         if BookMark <> nil then
         begin
            qry.GoToBookMark(BookMark) ;
            qry.FreeBookMark(BookMark) ;
            qry.EnableControls ;
         end ;

         WaitDlg.Hide;
         // Status user
         MessageDLG('Save Failed: '+E.Message,   mtError,[mbOK],0) ;
      end ;
   end ;
end;

procedure TOutputScreen.StatisticsfromGraph1Click(Sender: TObject);
begin
   CalcStatistics;
end;

procedure TOutputScreen.SteinhausClick(Sender: TObject);


          Function FindHeader(InVar: AllVariables; Control: Boolean): TResHeader;
          Var ILoop: Integer;
              RC   : TResultsCollection;

          Begin
           If Control then RC := OutputStudy.SV.ControlResults[Epilimnion]
                      else RC := OutputStudy.SV.Results[Epilimnion];

           FindHeader := nil;
           For ILoop:=0 to RC.Headers.Count-1 do
             Begin
               With TResHeader(RC.Headers.At(ILoop)) do
                 If (InVar = AllState) and (SVType=StV)
                    then begin
                           FindHeader := RC.Headers.At(ILoop);
                           Break;
                         end;
             End;
         End;


Const NumIndices = 4;
      StartIndex: Array [0..NumIndices] of AllVariables = (NullStateVar,FirstPlant, FirstAnimal, FirstInvert, FirstFish);
      EndIndex:   Array [0..NumIndices] of AllVariables = (NullStateVar,LastPlant, LastAnimal, LastInvert, LastFish);
      NameIndex:  Array [0..NumIndices] of String = ('Date','Plants','Animals','Invertebrates','Fish');

Var LC,LP, j, NumCVals, NumValues, LoopIndices: Integer;
    LoopVars: AllVariables;
    SumMin,SumCon,SumPer: Double;
    Control_Num, Perturbed_Num: Double;
    Control_Results,Perturbed_Results  : TResults;
    PH: TResHeader;
    TEX : TExcelOutput;
    BaseName: String;

Begin {SteinhausClick}
  If All_Segs then
    Begin
      MessageDlg('Not Enabled for Multiple Linked Segments.   View output in an individual segment.',mtinformation,[mbok],0);
      Exit;
    End;

    NumValues:= OutputStudy.SV.Results[Epilimnion].Count;
    NumCVals:= OutputStudy.SV.ControlResults[Epilimnion].Count;

    If NumValues<>NumCVals then
      Begin
        MessageDlg('Results for Control and Perturbed Simulations are of different lengths.',mterror,[mbok],0);
        Exit;
      End;

     TEx := TExcelOutput.Create(False);
     If All_Segs then BaseName := LinkedS.FileName
                 else BaseName := OutputStudy.FileName;
     Delete(BaseName,Length(BaseName)-3,4);
     If All_Segs then BaseName := LinkedS.DirName  +  BaseName + '_Stein.xls'
                 else BaseName := OutputStudy.DirName + BaseName + '_Stein.xls';

  If TEx.GetSaveName(BaseName,'Please Specify an Excel File to write Steinhaus Indices') then
    Begin

      For LoopIndices := 0 to NumIndices do
        Begin
          TEx.WS.Cells.Item[1,LoopIndices+1].Value := NameIndex[LoopIndices];

          j := 0;
          While j <= NumValues -1 do
            Begin
              Control_Results   := TResults(OutputStudy.SV.ControlResults[Epilimnion].At(j));
              Perturbed_Results := TResults(OutputStudy.SV.Results[Epilimnion].At(j));

              SumMin :=0;
              SumCon :=0;
              SumPer :=0;

              If LoopIndices > 0 then
                For LoopVars := StartIndex[LoopIndices] to EndIndex[LoopIndices] do
                   Begin
                     PH := FindHeader(LoopVars,True);
                     If PH<>nil then
                       Begin
                         LC := PH.PointIndex;
                         PH := FindHeader(LoopVars,False);
                         If PH = nil then LP := -1
                                     else LP := PH.PointIndex;
                         If (LC>-1) and (LP>-1) then
                           Begin
                             Control_Num:=TDataPoint(Control_Results.DataPoints.At(LC)).State;
                             Perturbed_Num:=TDataPoint(Perturbed_Results.DataPoints.At(LP)).State;

                             SumMin := SumMin + Min(Control_Num,Perturbed_Num);
                             SumCon := SumCon + Control_Num;
                             SumPer := SumPer + Perturbed_Num;

                           End;
                       End;
                   End; {loop through relevant vars}

(*              If LoopIndices=0 then XLSWrite2.WriteNumber(LoopIndices,j+1,0,Control_Results.Date)
                               else XLSWrite2.WriteNumber(LoopIndices,j+1,1,(2*SumMin/(SumCon+SumPer))); *)

              If LoopIndices=0 then TEx.WS.Cells.Item[j+2,LoopIndices+1].Value :=Control_Results.Date
                               else If (SumCon+SumPer > tiny)
                                  then TEx.WS.Cells.Item[j+2,LoopIndices+1].Value := 2*SumMin/(SumCon+SumPer)
                                  else TEx.WS.Cells.Item[j+2,LoopIndices+1].Value := 0;

              j := j + 1;
            End; {while do}
         End; {Loop Indices}

      TEX.SaveAndClose;
    End;
End; {SteinhausClick}

end.

