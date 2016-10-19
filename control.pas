//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Control;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Global, AquaObj, AQBaseForm, hh;

Var TempCR: Control_Opt_Rec;
    SV: TStates;

type
  TControlForm = class(TAQBase)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel1: TPanel;
    Inflow1: TCheckBox;
    PS1: TCheckBox;
    Title1: TLabel;
    DP1: TCheckBox;
    NPS1: TCheckBox;
    OrgToxCB1: TCheckBox;
    BurTox1: TCheckBox;
    Mult1: TCheckBox;
    Panel3: TPanel;
    Title3: TLabel;
    Inflow3: TCheckBox;
    PS3: TCheckBox;
    DP3: TCheckBox;
    NPS3: TCheckBox;
    Mult3: TCheckBox;
    Title3b: TLabel;
    Panel5: TPanel;
    Title5: TLabel;
    Inflow5: TCheckBox;
    PS5: TCheckBox;
    DP5: TCheckBox;
    NPS5: TCheckBox;
    Mult5: TCheckBox;
    Panel4: TPanel;
    Title4: TLabel;
    Inflow4: TCheckBox;
    PS4: TCheckBox;
    DP4: TCheckBox;
    NPS4: TCheckBox;
    Mult4: TCheckBox;
    Zero5: TCheckBox;
    Zero4: TCheckBox;
    Zero3: TCheckBox;
    Zero1: TCheckBox;
    HelpButton: TButton;
    AllToggleButton1: TButton;
    AllToggleButton3: TButton;
    AllToggleButton4: TButton;
    AllToggleButton2: TButton;
    procedure InflowClick(Sender: TObject);
    procedure PSClick(Sender: TObject);
    procedure DPClick(Sender: TObject);
    procedure NPSClick(Sender: TObject);
    procedure MultClick(Sender: TObject);
    procedure OrgToxCB1Click(Sender: TObject);
    procedure BurTox1Click(Sender: TObject);
    procedure Zero5Click(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure AllToggleButton1Click(Sender: TObject);
    procedure AllToggleButton3Click(Sender: TObject);
    procedure AllToggleButton2Click(Sender: TObject);
    procedure AllToggleButton4Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    Procedure UpdateScreen;
  public
    Changed    : Boolean;
    Procedure Edit_Control(Var InCtr: Control_Opt_Rec; PS: Pointer);
    Function HasChanged(PInCtr: PControl_Opt_Rec): Boolean;
  end;

var
  ControlForm: TControlForm;

implementation

{$R *.DFM}

Function TControlForm.HasChanged(PInCtr: PControl_Opt_Rec): Boolean;

Begin
  With PInCtr^ do
    HasChanged :=
      (Tox.ZeroInitCond <> TempCR.Tox.ZeroInitCond) or
      (Tox.OmitInflow <> TempCR.Tox.OmitInflow) or
      (Tox.OmitPS <> TempCR.Tox.OmitPS) or
      (Tox.OmitDP <> TempCR.Tox.OmitDP) or
      (Tox.OmitNPS <> TempCR.Tox.OmitNPS) or
      (Tox.SetMult <> TempCR.Tox.SetMult) or
      (Tox.OmitTox <> TempCR.Tox.OmitTox) or
      (Tox.OmitBuried <> TempCR.Tox.OmitBuried) or

      (Nutrient.ZeroInitCond <> TempCR.Nutrient.ZeroInitCond) or
      (Nutrient.OmitInflow <> TempCR.Nutrient.OmitInflow) or
      (Nutrient.OmitPS <> TempCR.Nutrient.OmitPS) or
      (Nutrient.OmitDP <> TempCR.Nutrient.OmitDP) or
      (Nutrient.OmitNPS <> TempCR.Nutrient.OmitNPS) or
      (Nutrient.SetMult <> TempCR.Nutrient.SetMult) or
      (Nutrient.OmitTox <> TempCR.Nutrient.OmitTox) or
      (Nutrient.OmitBuried <> TempCR.Nutrient.OmitBuried) or

      (Sediment.ZeroInitCond <> TempCR.Sediment.ZeroInitCond) or
      (Sediment.OmitInflow <> TempCR.Sediment.OmitInflow) or
      (Sediment.OmitPS <> TempCR.Sediment.OmitPS) or
      (Sediment.OmitDP <> TempCR.Sediment.OmitDP) or
      (Sediment.OmitNPS <> TempCR.Sediment.OmitNPS) or
      (Sediment.SetMult <> TempCR.Sediment.SetMult) or
      (Sediment.OmitTox <> TempCR.Sediment.OmitTox) or
      (Sediment.OmitBuried <> TempCR.Sediment.OmitBuried) or

      (Detritus.ZeroInitCond <> TempCR.Detritus.ZeroInitCond) or
      (Detritus.OmitInflow <> TempCR.Detritus.OmitInflow) or
      (Detritus.OmitPS <> TempCR.Detritus.OmitPS) or
      (Detritus.OmitDP <> TempCR.Detritus.OmitDP) or
      (Detritus.OmitNPS <> TempCR.Detritus.OmitNPS) or
      (Detritus.SetMult <> TempCR.Detritus.SetMult) or
      (Detritus.OmitTox <> TempCR.Detritus.OmitTox) or
      (Detritus.OmitBuried <> TempCR.Detritus.OmitBuried);

End;


Procedure TControlForm.Edit_Control(Var InCtr: Control_Opt_Rec; PS: Pointer);
Begin
  Changed:=False;
  TempCR :=InCtr;
  SV := TStates(PS);
  UpdateScreen;

  If ShowModal<>MrCancel then
      Begin
        Changed := HasChanged(@InCtr);
        InCtr := TempCR
      End
    Else Changed:=False;
End;


Procedure TControlForm.UpdateScreen;
Var ToxLoop  : AllVariables;
    ToxFound : Boolean;
Begin
  ToxFound := False;
  For ToxLoop:= FirstOrgTox to LastOrgTox do
    If SV.GetStatePointer(ToxLoop,StV,WaterCol)<>nil then ToxFound := True;

  If ToxFound
    Then With TempCR.Tox do
      Begin
        Panel1.Enabled:=True;
        Inflow1.Checked:=OmitInflow;
        PS1.Checked := OmitPS;
        DP1.Checked := OmitDP;
        NPS1.Checked:= OmitNPS;
        Mult1.Checked:=SetMult;
        OrgToxCB1.Checked:=OmitTox;
        BurTox1.Checked:=OmitBuried;
        Zero1.Checked:=ZeroInitCond;

        Title1.Font.Color := ClMaroon;
        Inflow1.Enabled := True;
        PS1.Enabled     := True;
        DP1.Enabled     := True;
        NPS1.Enabled    := True;
        Mult1.Enabled   := True;
        OrgToxCB1.Enabled := True;
        BurTox1.Enabled := True;
        Zero1.Enabled   := True;
      End
    else
      Begin
        Title1.Font.Color := ClGray;
        Panel1.Enabled  := False;
        Inflow1.Enabled := False;
        PS1.Enabled     := False;
        DP1.Enabled     := False;
        NPS1.Enabled    := False;
        Mult1.Enabled   := False;
        OrgToxCB1.Enabled := False;
        BurTox1.Enabled := False;
        Zero1.Enabled   := False;
      End;

    With TempCR.Nutrient do
      Begin
        Panel3.Enabled:=True;
        Inflow3.Checked:=OmitInflow;
        PS3.Checked := OmitPS;
        DP3.Checked := OmitDP;
        NPS3.Checked:= OmitNPS;
        Mult3.Checked:=SetMult;
        Zero3.Checked:=ZeroInitCond;
      End;

    With TempCR.Detritus do
      Begin
        Panel4.Enabled:=True;
        Inflow4.Checked:=OmitInflow;
        PS4.Checked := OmitPS;
        DP4.Checked := OmitDP;
        NPS4.Checked:= OmitNPS;
        Mult4.Checked:=SetMult;
        Zero4.Checked:=ZeroInitCond;
      End;

  If (SV.GetStatePointer(Sand,StV,WaterCol)<>nil) or
     (SV.GetStatePointer(TSS,StV,WaterCol)<>nil) or
     (SV.GetStatePointer(Cohesives,StV,WaterCol)<>nil) 
    Then With TempCR.Sediment do
      Begin
        Panel5.Enabled:=True;
        Inflow5.Checked:=OmitInflow;
        PS5.Checked := OmitPS;
        DP5.Checked := OmitDP;
        NPS5.Checked:= OmitNPS;
        Mult5.Checked:=SetMult;
        Zero5.Checked:=ZeroInitCond;

        Title5.Font.Color := ClMaroon;
        Inflow5.Enabled := True;
        PS5.Enabled     := True;
        DP5.Enabled     := True;
        NPS5.Enabled    := True;
        Mult5.Enabled   := True;
        Zero5.Enabled   := True;
      End
    else
      Begin
        Title5.Font.Color := ClGray;
        Panel5.Enabled  := False;
        Inflow5.Enabled := False;
        PS5.Enabled     := False;
        DP5.Enabled     := False;
        NPS5.Enabled    := False;
        Mult5.Enabled   := False;
        Zero5.Enabled   := False;
      End;

End;

{-------------------  BUTTON CLICK PROCEDURES ----------------------}

procedure TControlForm.Zero5Click(Sender: TObject);
Var Selected: Boolean;
    TC : TCheckBox;
Begin
  TC := TCheckbox(Sender);
  Selected := TC.Checked;
  Case TC.Name[5] of
    '1' : TempCR.Tox.ZeroInitCond     :=Selected;
    '3' : TempCR.Nutrient.ZeroInitCond:=Selected;
    '4' : TempCR.Detritus.ZeroInitCond:=Selected;
    '5' : TempCR.Sediment.ZeroInitCond:=Selected;
  End;
End;


procedure TControlForm.InflowClick(Sender: TObject);
Var Selected: Boolean;
    TC : TCheckBox;
Begin
  TC := TCheckbox(Sender);
  Selected := TC.Checked;
  Case TC.Name[7] of
    '1' : TempCR.Tox.OmitInflow:=Selected;
    '3' : TempCR.Nutrient.OmitInflow:=Selected;
    '4' : TempCR.Detritus.OmitInflow:=Selected;
    '5' : TempCR.Sediment.OmitInflow:=Selected;
  End;
End;

procedure TControlForm.PSClick(Sender: TObject);
Var Selected: Boolean;
    TC : TCheckBox;
Begin
  TC := TCheckbox(Sender);
  Selected := TC.Checked;
  Case TC.Name[3] of
    '1' : TempCR.Tox.OmitPS:=Selected;
    '3' : TempCR.Nutrient.OmitPS:=Selected;
    '4' : TempCR.Detritus.OmitPS:=Selected;
    '5' : TempCR.Sediment.OmitPS:=Selected;
  End;
End;

procedure TControlForm.DPClick(Sender: TObject);
Var Selected: Boolean;
    TC : TCheckBox;
Begin
  TC := TCheckbox(Sender);
  Selected := TC.Checked;
  Case TC.Name[3] of
    '1' : TempCR.Tox.OmitDP:=Selected;
    '3' : TempCR.Nutrient.OmitDP:=Selected;
    '4' : TempCR.Detritus.OmitDP:=Selected;
    '5' : TempCR.Sediment.OmitDP:=Selected;
  End;
End;

procedure TControlForm.NPSClick(Sender: TObject);
Var Selected: Boolean;
    TC : TCheckBox;
Begin
  TC := TCheckbox(Sender);
  Selected := TC.Checked;
  Case TC.Name[4] of
    '1' : TempCR.Tox.OmitNPS:=Selected;
    '3' : TempCR.Nutrient.OmitNPS:=Selected;
    '4' : TempCR.Detritus.OmitNPS:=Selected;
    '5' : TempCR.Sediment.OmitNPS:=Selected;
  End;
End;

procedure TControlForm.MultClick(Sender: TObject);
Var Selected: Boolean;
    TC : TCheckBox;
Begin
  TC := TCheckbox(Sender);
  Selected := TC.Checked;
  Case TC.Name[5] of
    '1' : TempCR.Tox.SetMult:=Selected;
    '3' : TempCR.Nutrient.SetMult:=Selected;
    '4' : TempCR.Detritus.SetMult:=Selected;
    '5' : TempCR.Sediment.SetMult:=Selected;
  End;
End;

procedure TControlForm.OrgToxCB1Click(Sender: TObject);
Var Selected: Boolean;
    TC : TCheckBox;
Begin
  TC := TCheckbox(Sender);
  Selected := TC.Checked;
  Case TC.Name[9] of
    '1' : TempCR.Tox.OmitTox:=Selected;
  End;
End;

procedure TControlForm.BurTox1Click(Sender: TObject);
Var Selected: Boolean;
    TC : TCheckBox;
Begin
  TC := TCheckbox(Sender);
  Selected := TC.Checked;
  Case TC.Name[7] of
    '1' : TempCR.Tox.OmitBuried:=Selected;
  End;
End;

{-------------------  END BUTTON CLICK PROCEDURES --------------------}

procedure TControlForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic36.htm');
end;

procedure TControlForm.AllToggleButton1Click(Sender: TObject);
begin
  Inflow1.Checked := Not Zero1.Checked;
  PS1.Checked := Not Zero1.Checked;
  DP1.Checked := Not Zero1.Checked;
  NPS1.Checked := Not Zero1.Checked;
  OrgToxCB1.Checked := Not Zero1.Checked;
  BurTox1.Checked := Not Zero1.Checked;
  Mult1.Checked := Not Zero1.Checked;
  Zero1.Checked := Not Zero1.Checked;
end;

procedure TControlForm.AllToggleButton3Click(Sender: TObject);
begin
  Inflow5.Checked := Not Zero5.Checked;
  PS5.Checked := Not Zero5.Checked;
  DP5.Checked := Not Zero5.Checked;
  NPS5.Checked := Not Zero5.Checked;
  Mult5.Checked := Not Zero5.Checked;
  Zero5.Checked := Not Zero5.Checked;
end;

procedure TControlForm.AllToggleButton2Click(Sender: TObject);
begin
  Inflow3.Checked := Not Zero3.Checked;
  PS3.Checked := Not Zero3.Checked;
  DP3.Checked := Not Zero3.Checked;
  NPS3.Checked := Not Zero3.Checked;
  Mult3.Checked := Not Zero3.Checked;
  Zero3.Checked := Not Zero3.Checked;
end;

procedure TControlForm.AllToggleButton4Click(Sender: TObject);
begin
  Inflow4.Checked := Not Zero4.Checked;
  PS4.Checked := Not Zero4.Checked;
  DP4.Checked := Not Zero4.Checked;
  NPS4.Checked := Not Zero4.Checked;
  Mult4.Checked := Not Zero4.Checked;
  Zero4.Checked := Not Zero4.Checked;
end;

procedure TControlForm.OKBtnClick(Sender: TObject);
begin
   OKBtn.SetFocus;
end;

end.
