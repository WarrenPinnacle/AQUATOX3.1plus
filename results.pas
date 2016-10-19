//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
{ Form Template - Source and Destination Choices Lists }
unit results;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, AQUAOBJ, Global, SysUtils, Dialogs, AQBaseForm, hh;

type
  TResultsForm = class(TAQBase)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel1: TPanel;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    IncludeBtn: TSpeedButton;
    ExcludeBtn: TSpeedButton;
    ExAllBtn: TSpeedButton;
    SrcList: TListBox;
    DstList: TListBox;
    Panel2: TPanel;
    SavePPB: TCheckBox;
    Panel3: TPanel;
    MemTitle: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cstudy: TLabel;
    pstudy: TLabel;
    totstudy: TLabel;
    SaveBAFs: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    ucstudy: TLabel;
    upstudy: TLabel;
    utotstudy: TLabel;
    HelpButton: TButton;
    procedure IncludeBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure IncAllBtnClick(Sender: TObject);
    procedure ExcAllBtnClick(Sender: TObject);
    procedure MoveSelected(List: TCustomListBox; Items: TStrings);
    procedure SetItem(List: TListBox; Index: Integer);
    function GetFirstSelection(List: TCustomListBox): Integer;
    procedure SetButtons;
    procedure CheckboxClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    NumPoints: Double;
    Procedure UpdateResults;
  public
    Changed: Boolean;
    NumSegs: Integer;
    LinkedMod: Boolean;
    SV: TStates;
    Procedure ResultsSetup(NumPts: Double);{ Public declarations }
  end;

var
  ResultsForm: TResultsForm;

implementation

{$R *.DFM}

Procedure TResultsForm.UpdateResults;
Var StateLoop  : AllVariables;
    TypLoop    : T_SVType;
    LayerLoop  : T_SVLayer;
    VarName    : String;
    Num_Vars   : Integer;
    Num_Toxs   : Integer;
    SizePoint  : Integer;
    HeadSize   : LongInt;
    ResSize    : Integer;
    ResultsSize: Double;


Begin
  Num_Vars  := SrcList.Items.Count+1;
  Num_Toxs  := 0;
  For TypLoop := FirstToxTyp to LastToxTyp do
    If SV.GetStatePointer(AssocToxSV(TypLoop),StV,WaterCol) <> nil
      Then Inc(Num_Toxs);

  SizePoint := Sizeof(TDataPoint);
  HeadSize  := Sizeof(THeader);
  ResSize   := Sizeof(TResults);

  If SavePPB.Checked then
    Begin
      For TypLoop := FirstToxTyp to LastToxTyp do
       For StateLoop := FirstState to LastState do
        For LayerLoop := WaterCol to SedLayer10 do
          If SV.GetStatePointer(StateLoop,TypLoop,LayerLoop) <> nil then
            Begin
              VarName := OutputText(StateLoop,TypLoop,LayerLoop,SV.UniqueName(StateLoop),False,False,0);
              If SrcList.Items.IndexOf(VarName)>-1 then Num_Vars:=Num_Vars+1;
            End;
    End;

  If SaveBAFs.Checked then
    Begin
      For TypLoop := FirstOrgTxTyp to LastOrgTxTyp do
       For StateLoop := FirstBiota to LastBiota do
        If SV.GetStatePointer(StateLoop,TypLoop,WaterCol) <> nil then
            Begin
              VarName := OutputText(StateLoop,TypLoop,WaterCol,SV.UniqueName(StateLoop),False,False,0);
              If SrcList.Items.IndexOf(VarName)>-1 then Num_Vars:=Num_Vars+1;
            End;
    End;

  Num_Vars := Num_Vars + 13                  {addtl misc output}
                       + (20 * Num_Toxs)     {Tox loss/load output}
                       + (3 * SV.SedLayers) {Sed Layer Data That is Output};

  ResultsSize := ((HeadSize * Num_Vars) +
                  (SizePoint * Num_Vars * NumPoints) +
                  (ResSize * NumPoints)) / (1024*1024);

  If LinkedMod then ResultsSize := ResultsSize * NumSegs;
  If LinkedMod then MemTitle.Caption := 'Memory Utilization  ('+IntToStr(NumSegs)+' segments)';

  CStudy.caption := FloattoStr(RoundDec(2,ResultsSize)) + '  MB';
  PStudy.caption  := FloattoStr(RoundDec(2,ResultsSize)) + '  MB';
  TotStudy.caption := FloattoStr(RoundDec(2,(ResultsSize*2))) + '  MB';

  ResultsSize := ResultsSize * 5;
  UCStudy.caption := FloattoStr(RoundDec(2,ResultsSize)) + '  MB';
  UPStudy.caption  := FloattoStr(RoundDec(2,ResultsSize)) + '  MB';
  UTotStudy.caption := FloattoStr(RoundDec(2,(ResultsSize*(6/5)))) + '  MB';

  Update;
End;

Procedure TResultsForm.ResultsSetup(NumPts: Double);
Var StateLoop: AllVariables;
    TypLoop  : T_SVType;
    LayerLoop: T_SVLayer;
    PSV: TStateVariable;

Begin
  SrcList.Items.Clear;
  DstList.Items.Clear;

  SavePPB.Checked := SV.PSavePPB^;
  SaveBAFs.Checked := SV.PSaveBAFs^;

  For TypLoop := StV to LastOrgTxTyp do
   For StateLoop:=FirstState to LastState do
    For LayerLoop := WaterCol to SedLayer10 do
      Begin
        PSV:= SV.GetStatePointer(StateLoop,TypLoop,LayerLoop);
        If (PSV <> nil) then if PSV.PTrackResults^
           then SrcList.Items.Add(OutputText(StateLoop,TypLoop,LayerLoop,SV.UniqueName(StateLoop),False,False,0))
           else DstList.Items.Add(OutputText(StateLoop,TypLoop,LayerLoop,SV.UniqueName(StateLoop),False,False,0));
      End;

  NumPoints:=NumPts;
  UpdateResults;

  SetButtons;

  If ShowModal=MrCancel then exit;
End;

{-------------------------------------------------------------------------}

procedure TResultsForm.IncludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(SrcList);
  If Index<>-1 then Changed := True;
  MoveSelected(SrcList, DstList.Items);
  SetItem(SrcList, Index);
  UpdateResults;
end;

procedure TResultsForm.ExcludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(DstList);
  MoveSelected(DstList, SrcList.Items);
  SetItem(DstList, Index);
  Changed := True;
  UpdateResults;
end;

procedure TResultsForm.IncAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to SrcList.Items.Count - 1 do
    DstList.Items.AddObject(SrcList.Items[I],
      SrcList.Items.Objects[I]);
  SrcList.Items.Clear;
  Changed := True;
  SetItem(SrcList, 0);
end;

procedure TResultsForm.ExcAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to DstList.Items.Count - 1 do
    SrcList.Items.AddObject(DstList.Items[I], DstList.Items.Objects[I]);
  DstList.Items.Clear;
  SetItem(DstList, 0);
  UpdateResults;
end;

procedure TResultsForm.MoveSelected(List: TCustomListBox; Items: TStrings);
var
  I: Integer;
begin
  for I := List.Items.Count - 1 downto 0 do
    if List.Selected[I] then
    begin
      Items.AddObject(List.Items[I], List.Items.Objects[I]);
      List.Items.Delete(I);
    end;
end;

procedure TResultsForm.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := SrcList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  IncludeBtn.Enabled := not SrcEmpty;
  ExcludeBtn.Enabled := not DstEmpty;
  ExAllBtn.Enabled := not DstEmpty;
end;

function TResultsForm.GetFirstSelection(List: TCustomListBox): Integer;
begin
  for Result := 0 to List.Items.Count - 1 do
    if List.Selected[Result] then Exit;
  Result := LB_ERR;
end;

procedure TResultsForm.SetItem(List: TListBox; Index: Integer);
var
  MaxIndex: Integer;
begin
  with List do
  begin
    SetFocus;
    MaxIndex := List.Items.Count - 1;
    if Index = LB_ERR then Index := 0
    else if Index > MaxIndex then Index := MaxIndex;
    Selected[Index] := True;
  end;
  SetButtons;
end;

procedure TResultsForm.CheckboxClick(Sender: TObject);
begin
  UpdateResults;
  If (SV.PSavePPB^<>SavePPB.Checked) Then Changed := True;
end;

procedure TResultsForm.OKBtnClick(Sender: TObject);
Var StateLoop: AllVariables;
    TypLoop  : T_SVType;
    PSV: TStateVariable;
    LayerLoop: T_SVLayer;
    VarName: String;

begin
  If SrcList.Items.Count=0 then
    Begin
      ModalResult:=MrNone;
      MessageDlg('You must track results for at least one state variable.',MtInformation,[mbOK],0);
      Exit;
    End;

  If Changed then If ( MessageDlg('Modify Results Tracking?',mtConfirmation,[mbYes,MbNo],0) = MrNo )
  then
     Begin
       Changed := False;
       Exit;
     End;

  SV.PSavePPB^ := SavePPB.Checked;
  SV.PSaveBAFs^ := SaveBAFs.Checked;

  For TypLoop := StV to LastOrgTxTyp do
   For StateLoop:=FirstState to LastState do
    For LayerLoop := WaterCol to SedLayer10 do
      Begin
        PSV:= SV.GetStatePointer(StateLoop,TypLoop,LayerLoop);
        If PSV<> nil then
          Begin
            VarName := OutputText(StateLoop,TypLoop,LayerLoop,SV.UniqueName(StateLoop),False,False,0);
            If SrcList.Items.IndexOf(VarName)>-1 then PSV.PTrackResults^:=True
                                                 else PSV.PTrackResults^:=False;
          End;
      End;
End;

procedure TResultsForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic37.htm');
end;

procedure TResultsForm.CancelBtnClick(Sender: TObject);
begin
    Changed := False;
end;

end.
