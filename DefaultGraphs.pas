//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit DefaultGraphs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Observed_Data, Aquaobj, Global, hh;

type
  TDefaultGraphForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    GraphMenu: TComboBox;
    ChemLabel: TLabel;
    ToxComboBox: TComboBox;
    ScenarioBox: TComboBox;
    Label1: TLabel;
    HelpButton: TButton;
    procedure RadioButton1Click(Sender: TObject);
    procedure ScenarioBoxChange(Sender: TObject);
    procedure ToxComboBoxChange(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
  private
    NumToxs    : Integer;
    procedure UpdateScenBox;
    procedure UpdateChems;
  public
    SelTox         : Array[0..20] of T_SVType;
    CR, PR: TResultsCollection;
    SV: TStates;
    Difference: Boolean;
    Function ChooseDefaultGraph(linked:Boolean): TGraphSetup;
  end;

Const
  DefaultGraphList : Array[1..14] of String = ('New Graph','All Animals', 'All Plants', 'Nutrients',
  'Chem. PPB. Animals','Chem PPB. Plants','Benthic Plants Summary', 'Phytoplankton Summary','Invertebrates','Fish','Detritus',
  'Temperature','Chla','Water Vol.');

Function MakeDefaultGraph(Index: Integer; PRC:TResultsCollection; Linked:Boolean):TGraphSetup;

var
  Chemical_to_Graph: T_SVType;
  DefaultGraphForm: TDefaultGraphForm;

implementation


{$R *.dfm}

{ TDefaultGraphForm }


procedure TDefaultGraphForm.UpdateScenBox;
Begin
  If PR.Count = 0 then ScenarioBox.ItemIndex := 0;
  If CR.Count = 0 then ScenarioBox.ItemIndex := 1;
  If (PR.Count = 0) or (CR.Count = 0) then ScenarioBox.Enabled := False;
End;


procedure TDefaultGraphForm.UpdateChems;
Var WR: TResultsCollection;
    ToxLoop : T_SVType;
Begin
  If ScenarioBox.ItemIndex = 0 then WR := CR
                               else WR := PR;

   NumToxs    := 0;
   Chemical_To_Graph := StV;
   ToxComboBox.Items.Clear;
   For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
     If WR.GetHeaderIndex(AssocToxSV(ToxLoop),StV,WaterCol,False,False,False,0,0) > -1
        then
          Begin
            Inc(NumToxs);
            SelTox[NumToxs] := ToxLoop;
            ToxComboBox.Items.Add(SV.ChemPtrs^[ToxLoop].ChemRec.ChemName);
            If Chemical_To_Graph = StV then Chemical_To_Graph := ToxLoop;
          End;

    ToxComboBox.ItemIndex := 0;
    If Chemical_To_Graph = StV
      then
        Begin
          RadioButton5.Enabled := False;
          RadioButton6.Enabled := False;
          ToxComboBox.Visible  := False;
          ChemLabel.Visible    := False;
        End
      else
        Begin
          RadioButton5.Enabled := True;
          RadioButton6.Enabled := True;
          ToxComboBox.Visible  := RadioButton6.Checked or RadioButton5.Checked;
          ChemLabel.Visible    := RadioButton6.Checked or RadioButton5.Checked;
        End;
End;


function MakeDefaultGraph(Index: Integer; PRC:TResultsCollection; linked:Boolean):TGraphSetup;
Var i, y1Index,y2Index: Integer;
    Y1UnitStr, Y2UnitStr: String;
    PH : TResHeader;
    AddHeader: Boolean;
Begin
  Result := TGraphSetup.CreateEmptyGraph(linked);
  If Index=1 then exit;

  Result.data.GraphName := DefaultGraphList[Index];
  Result.data.GraphTitle1 := Result.data.GraphName;

  Y1Index := 1; Y2Index := 1;
  Y1UnitStr := ''; Y2UnitStr := '';

  For i := 1 to PRC.Headers.Count do
    Begin
      PH := PRC.Headers.At(i-1);
      AddHeader := False;
      With PH do
       Case Index of
        2:{All Animals} AddHeader := (AllState in [FirstAnimal..LastAnimal]) and (SVType=StV) and
                                     not (PPB or ToxVar or (BAFVar>0) or RateVar);
        3:{All Plants} AddHeader := (AllState in [FirstPlant..LastPlant]) and (SVType=StV) and
                                     not (PPB or ToxVar or (BAFVar>0) or RateVar);
        4:{Nutrients} AddHeader := (AllState in [Ammonia..Phosphate]) and (SVType=StV) and (Layer=WaterCol) and
                                     not (PPB or ToxVar or (BAFVar>0) or RateVar);
        5: {Chem. PPB. Animals} AddHeader := (AllState in [FirstAnimal..LastAnimal]) and (SVType=Chemical_to_Graph) and PPB and
                                     not (ToxVar or (BAFVar>0) or RateVar);
        6: {Chem. PPB. Plants} AddHeader := (AllState in [FirstPlant..LastPlant]) and (SVType=Chemical_to_Graph) and PPB and
                                     not (ToxVar or (BAFVar>0) or RateVar);
        7: {Benthic Plants} AddHeader := ((AllState in [FirstPlant..LastPlant]) and (SVType=StV) and
                                     not (PPB or ToxVar or (BAFVar>0) or RateVar) and (UnitStr = 'g/m2 dry')) or
                                     ((SVType=OtherOutput) and (TAddtlOutput(AllState) in [Peri_Chla, Moss_Chla]));
        8: {Phytoplankton} AddHeader := ((AllState in [FirstPlant..LastPlant]) and (SVType=StV) and
                                     not (PPB or ToxVar or (BAFVar>0) or RateVar) and (UnitStr = 'mg/L dry')) or
                                     ((SVType=OtherOutput) and (TAddtlOutput(AllState) = Chla));
        9:{Inverts} AddHeader := (AllState in [FirstInvert..LastInvert]) and (SVType=StV) and
                                     not (PPB or ToxVar or (BAFVar>0) or RateVar);
        10:{Fish} AddHeader := (AllState in [FirstFish..LastFish]) and (SVType=StV) and
                                     not (PPB or ToxVar or (BAFVar>0) or RateVar);
        11:{Detritus} AddHeader := (AllState in [SedmRefrDetr..SuspLabDetr]) and (SVType=StV) and
                                        not (PPB or ToxVar or (BAFVar>0) or RateVar);
        12:{Temperature} AddHeader := (AllState in [Temperature]) and (SVType=StV) and
                                        not (PPB or ToxVar or (BAFVar>0) or RateVar);
        13:{Chl a} AddHeader := (TAddtlOutput(AllState) in [Chla,Peri_Chla, Moss_Chla,BenthicChla]) and (SVType=OtherOutput) and
                                        not (PPB or ToxVar or (BAFVar>0) or RateVar);
        14:{Water Vol} AddHeader := ((AllState in [Volume]) and (SVType=StV)) or
                                    ((TAddtlOutput(AllState) in [InflowWater,DischWater]) and (SVType=OtherOutput))
                                     and not (PPB or ToxVar or (BAFVar>0) or RateVar);


       End; {Case}

       If AddHeader then
         If (((Y1Index=1) or (PH.UnitStr = Y1UnitStr)) and (Y1Index<21))
           then
             Begin
               Result.data.YItems[True,Y1Index] := PH.SortIndex;
               Y1UnitStr := PH.UnitStr;
               Inc(Y1Index);
             End
           else if (((Y2Index=1) or (PH.UnitStr = Y2UnitStr)) and (Y2Index<21))
             then
               Begin
                 Result.data.YItems[False,Y2Index] := PH.SortIndex;
                 Y2UnitStr := PH.UnitStr;
                 Inc(Y2Index);
               End;
    End;
end;

function TDefaultGraphForm.ChooseDefaultGraph(linked:Boolean): TGraphSetup;
Var Index: Integer;
Begin
  Chemical_to_Graph := StV;
  UpdateScenBox;
  UpdateChems;

  If ShowModal = mrCancel then Begin Result := nil; Exit; End;

  Index := 1;
{  If RadioButton1.Checked then Index := 1 else }
  If RadioButton2.Checked then Index := 2 else
  If RadioButton3.Checked then Index := 3 else
  If RadioButton4.Checked then Index := 4 else
  If RadioButton5.Checked then Index := 5 else
  If RadioButton6.Checked then Index := 6 else
  If RadioButton7.Checked then Index := GraphMenu.ItemIndex+7;

  If ScenarioBox.ItemIndex = 1
    then Result := MakeDefaultGraph(Index, PR, Linked)
    else Result := MakeDefaultGraph(Index, CR, Linked);
End;

procedure TDefaultGraphForm.HelpButtonClick(Sender: TObject);
begin
    HTMLHelpContext('New_Graph.htm');
end;

procedure TDefaultGraphForm.RadioButton1Click(Sender: TObject);
begin
  GraphMenu.Enabled   := RadioButton7.Checked;
  ToxComboBox.Visible := RadioButton6.Checked or RadioButton5.Checked;
  ChemLabel.Visible   := RadioButton6.Checked or RadioButton5.Checked;
end;

procedure TDefaultGraphForm.ScenarioBoxChange(Sender: TObject);
begin
  UpdateChems;
end;

procedure TDefaultGraphForm.ToxComboBoxChange(Sender: TObject);
begin
   Chemical_To_Graph := SelTox[ToxComboBox.ItemIndex+1];
end;

end.
