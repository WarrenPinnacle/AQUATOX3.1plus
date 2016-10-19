//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 


unit WizardProg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, WizardBase,WizardSumm, WizGlobal, SyncObjs, AQStudy,
  Wiz_0, Wiz_1, Wiz_2, Wiz_3, Wiz_4, Wiz_5, Wiz_6, Wiz_7, Wiz_8, Wiz_9, Wiz_10, 
  Wiz_11, Wiz_12, Wiz_13, Wiz_14, Wiz_15, Wiz_16, Wiz_17, Wiz_18, Wiz_19, Wiz_20,
  Wiz_DBEntry, Global, AQBaseForm, hh;


type
  TWizardProgress = class(TAQBase)
    ScrollBox1: TScrollBox;
    SL1: TLabel;
    SL2: TLabel;
    SL3: TLabel;
    SL6: TLabel;
    SL5: TLabel;
    SL4: TLabel;
    SL12: TLabel;
    SL11: TLabel;
    SL10: TLabel;
    SL9: TLabel;
    sl8: TLabel;
    SL7: TLabel;
    SL19: TLabel;
    SL18: TLabel;
    SL17: TLabel;
    SL16: TLabel;
    SL15: TLabel;
    SL14: TLabel;
    SL13: TLabel;
    A1: TLabel;
    A2: TLabel;
    A3: TLabel;
    A4: TLabel;
    A5: TLabel;
    A6: TLabel;
    A7: TLabel;
    A8: TLabel;
    A9: TLabel;
    A10: TLabel;
    A11: TLabel;
    A12: TLabel;
    A13: TLabel;
    A14: TLabel;
    A15: TLabel;
    A16: TLabel;
    A17: TLabel;
    A18: TLabel;
    A19: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Shape19: TShape;
    LegendPanel: TPanel;
    Label20: TLabel;
    Shape20: TShape;
    Label21: TLabel;
    Shape21: TShape;
    Label22: TLabel;
    Shape22: TShape;
    Button1: TButton;
    helpbutton: TButton;
    Label23: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SL1DblClick(Sender: TObject);
    procedure Label19DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure helpbuttonClick(Sender: TObject);
  private
    { Private declarations }
  public
{    LastFormMade: Integer; }
    WizStudy: TAQUATOXSegment;
    CurrentForm: TWizBase;
    Function  ExecuteWizard(NewStudy: Boolean):Boolean;
    Procedure UpdateScreen;
    Procedure JumpToStep(Step: Integer);
    Procedure ResetBoxes;
    Procedure DefaultBoxes;
    Procedure ResetFirstVisit;
    Procedure MakeForm(Index: Integer);    
    { Public declarations }
  end;

var
  ScrTop,ScrLeft: Integer;
  WizardProgress: TWizardProgress;
  WizardDone: Boolean;
  ScreenInt: Integer;
  JumpToScreen: Integer;
  NewSetup: Boolean;
  Contents: Array [1..NumberOfSteps] of String;
  HelpRef: Array[0..NumberOfSteps+1] of String;
  Status: TWizStatus;
     {Status = 0: No data}
     {Status = 1: Default Data}
     {Status = 2: User Defined Data}
  StatColors: Array[0..2] of TColor;
{  FormsByIndex: Array[0..NumberOfSteps+1] of TWizBase; }
  FirstVisit: Array[0..NumberOfSteps+1] of Boolean;

implementation

uses Wiz_Fish1, Wiz_Fish2, Wiz_unfinished, Parent;

{$R *.DFM}

Function TWizardProgress.ExecuteWizard(NewStudy: Boolean): Boolean;
Var Outcome: WizOutput;
    DataUnfinished: Boolean;
    Loop: Integer;
    TL: TLabel;
    LName: String;

     {---------------------------------------------------------}
     Procedure Ready_Current_Form;
     Var OldF: TForm;
     Begin
       OldF := CurrentForm;
       MakeForm(ScreenInt);
       CurrentForm.OldForm := OldF;
       CurrentForm.IsnewSetup := NewSetup;
       CurrentForm.SummForm   := WizSummary;
       CurrentForm.ProgForm   := WizardProgress;
       CurrentForm.WizStudy   := WizStudy;
       CurrentForm.HelpContxt := HelpRef[screenInt];
       If (ScreenInt>0) and (ScreenInt <= NumberOfSteps)
          then CurrentForm.Wizstatus  := Status[ScreenInt];
       WizSummary.WizStudy    := WizStudy;
       WizSummary.UpdateScreen;
       CurrentForm.ScrTop:=ScrTop; CurrentForm.ScrLeft:=ScrLeft;
       CurrentForm.JumpIn := Outcome;
       CurrentForm.FirstVisit := FirstVisit[ScreenInt];

       If (ScreenInt=0) and (WizStudy=nil) then ResetFirstVisit;
       CurrentForm.FirstVisit := FirstVisit[ScreenInt];
     End;
     {---------------------------------------------------------}
Begin
  If NewStudy then WizStudy := Nil;
  ScreenInt := 0;
  NewSetup := NewStudy;
  If Not NewStudy then DefaultBoxes;

  UpdateScreen;
  Show;
  WizSummary.Show;
  Outcome := WzNext;
  CurrentForm := nil;

  Repeat
    UpdateScreen;
    Ready_Current_Form;
    Outcome := CurrentForm.ExecuteScreen;
    FirstVisit[ScreenInt] := CurrentForm.FirstVisit;

    WizStudy := CurrentForm.WizStudy;
    ScrTop := CurrentForm.ScrTop;  ScrLeft := CurrentForm.ScrLeft;

    If (ScreenInt>0) and (ScreenInt <= NumberOfSteps)
      then Status[ScreenInt]:= CurrentForm.WizStatus;
    If (ScreenInt=1) and (CurrentForm.WizStatus=1) then DefaultBoxes;
    If WizStudy=Nil then ResetBoxes;

    If Outcome = WzNext then Inc(ScreenInt);
    If Outcome = WzBack then Dec(ScreenInt);
    If Outcome = WzJump then ScreenInt := JumpToScreen;

    If (Outcome = WzFinished) or (ScreenInt=20) then
      Begin
        DataUnfinished := False;
        If NewStudy then
          Begin
            UpdateScreen;
            For Loop := 1 to NumberOfSteps do
              Begin
                LName := 'A'+IntToStr(Loop);
                TL := TLabel(FindComponent(LName));
                If Status[Loop]=0
                  then
                    Begin
                      DataUnfinished := True;
                      TL.Visible := True;
                    End
                  else TL.Visible := False;
              End; {For Loop}

            If DataUnfinished then
              Begin
                Show;
                Application.CreateForm(TWizUnfinishedDlg, WizUnfinishedDlg);
                If WizUnfinishedDlg.ShowModal = MrCancel
                  then Outcome:=WzNext
                  else Outcome:=WzFinished;
                WizUnfinishedDlg.Free;  
                If (ScreenInt=20) then ScreenInt:=19;
              End;
          End; {If NewStudy}

          If (Outcome = WzFinished) and (not DataUnfinished) and (ScreenInt<20) then
            Begin
              If MessageDlg('Leave the wizard and save changes?',mtConfirmation,[mbyes,mbno],0)=mrno
                  then Outcome:=WzNext
            End;
      End;

  Until Outcome in [WzCancel,WzFinished];

  WizardIsRunning := False;
  CurrentForm.Hide;
  Hide;
  WizSummary.Hide;
  ParentForm.Show;
  ExecuteWizard := (Outcome=WzFinished);
End;

Procedure TWizardProgress.UpdateScreen;
Var Loop: Integer;
    TL: TLabel;
    TS: TShape;
    LName: String;

Begin
  For Loop := 1 to NumberOfSteps do
    Begin
      LName := 'A'+IntToStr(Loop);
      TL := TLabel(FindComponent(LName));
      TL.Visible := (Loop=ScreenInt);

      LName := 'Label'+IntToStr(Loop);
      TL := TLabel(FindComponent(LName));
      TL.Visible := NewSetup;

      LName := 'Shape'+IntToStr(Loop);
      TS := TShape(FindComponent(LName));
      TS.Visible := NewSetup;
      If TS.Visible then TS.Brush.Color := StatColors[Status[Loop]];
    End;

  LegendPanel.Visible := Newsetup;
End;

Procedure TWizardProgress.ResetFirstVisit;
Var Loop: Integer;
Begin
  For Loop := 0 to NumberOfSteps+1 do
      FirstVisit[Loop] := True;
End;

Procedure TWizardProgress.MakeForm(Index: Integer);
Begin
{  If CurrentForm <> nil then CurrentForm.Free; }

  Case Index of
    0: Application.CreateForm(TWizBase0, WizBase0);
    1: Application.CreateForm(TWizBase1, WizBase1);
    2: Application.CreateForm(TWizBase2, WizBase2);
    3: Application.CreateForm(TWizBase3, WizBase3);
    4: Application.CreateForm(TWizBase4, WizBase4);
    5: Application.CreateForm(TWizBase5, WizBase5);
    6: Application.CreateForm(TWizBase6, WizBase6);
    7: Application.CreateForm(TWizBase7, WizBase7);
    8: Application.CreateForm(TWizBase8, WizBase8);
    9: Application.CreateForm(TWizBase9, WizBase9);
    10: Application.CreateForm(TWizBase10, WizBase10);
    11: Application.CreateForm(TWizBase11, WizBase11);
    12: Application.CreateForm(TWizBase12, WizBase12);
    13: Application.CreateForm(TWizBase13, WizBase13);
     14: Application.CreateForm(TWizBase14, WizBase14);
    15: Application.CreateForm(TWizBase15, WizBase15);
    16: Application.CreateForm(TWizBase16, WizBase16);
    17: Application.CreateForm(TWizBase17, WizBase17);
    18: Application.CreateForm(TWizBase18, WizBase18);
    19: Application.CreateForm(TWizBase19, WizBase19);
    20: Application.CreateForm(TWizBase20, WizBase20);
  End; {Case}

  Case Index of
    0: CurrentForm := WizBase0;
    1: CurrentForm := WizBase1;
    2: CurrentForm := WizBase2;
    3: CurrentForm := WizBase3;
    4: CurrentForm := WizBase4;
    5: CurrentForm := WizBase5;
    6: CurrentForm := WizBase6;
    7: CurrentForm := WizBase7;
    8: CurrentForm := WizBase8;
    9: CurrentForm := WizBase9;
    10: CurrentForm := WizBase10;
    11: CurrentForm := WizBase11;
    12: CurrentForm := WizBase12;
    13: CurrentForm := WizBase13;
    14: CurrentForm := WizBase14;
    15: CurrentForm := WizBase15;
    16: CurrentForm := WizBase16;
    17: CurrentForm := WizBase17;
    18: CurrentForm := WizBase18;
    19: CurrentForm := WizBase19;
    20: CurrentForm := WizBase20;
  End; {Case}

  CurrentForm.Caption:='AQUATOX-- Simulation Setup Wizard'; 

End;


procedure TWizardProgress.FormCreate(Sender: TObject);
Var Loop: Integer;
    TL: TLabel;
    Lname: String;
begin
  inherited;
  CurrentForm := nil;

  StatColors[0] := CLWhite;
  StatColors[1] := clBtnFace;
  StatColors[2] := ClBlack;
  ScrTop :=  128;
  ScrLeft := 230;
  Top := 0; Left := 1;

  ScreenInt := 1;

  Application.CreateForm(TWizBase, WizBase);
  Application.CreateForm(TWizSummary, WizSummary);
  Application.CreateForm(TWiz_GetEntry, Wiz_GetEntry);
  Application.CreateForm(TFishTypeDialog, FishTypeDialog);
  Application.CreateForm(TFishClassDialog, FishClassDialog);

{  FormsByIndex[0] := WizBase0;
  FormsByIndex[1] := WizBase1;
  FormsByIndex[2] := WizBase2;
  FormsByIndex[3] := WizBase3;
  FormsByIndex[4] := WizBase4;
  FormsByIndex[5] := WizBase5;
  FormsByIndex[6] := WizBase6;
  FormsByIndex[7] := WizBase7;
  FormsByIndex[8] := WizBase8;
  FormsByIndex[9] := WizBase9;
  FormsByIndex[10] := WizBase10;
  FormsByIndex[11] := WizBase11;
  FormsByIndex[12] := WizBase12;
  FormsByIndex[13] := WizBase13;
  FormsByIndex[14] := WizBase14;
  FormsByIndex[15] := WizBase15;
  FormsByIndex[16] := WizBase16;
  FormsByIndex[17] := WizBase17;
  FormsByIndex[18] := WizBase18;
  FormsByIndex[19] := WizBase19;
  FormsByIndex[20] := WizBase20; }

  Contents[1]  := 'Step 1: Simulation Type';
  Contents[2]  := 'Step 2: Simulation Period';
  Contents[3]  := 'Step 3: Nutrients';
  Contents[4]  := 'Step 4: Detritus';
  Contents[5]  := 'Step 5: Plants';
  Contents[6]  := 'Step 6: Invertebrates';
  Contents[7]  := 'Step 7: Fish';
  Contents[8]  := 'Step 8: Site Characteristics';
  Contents[9]  := 'Step 9: Water Volume';
  Contents[10] := 'Step 10: Water Temperature';
  Contents[11] := 'Step 11: Wind Loading';
  Contents[12] := 'Step 12: Light Loading';
  Contents[13] := 'Step 13: Water pH';
  Contents[14] := 'Step 14: Inorganic Solids';
  Contents[15] := 'Step 15: Chemicals';
  Contents[16] := 'Step 16: Inflow Loadings';
  Contents[17] := 'Step 17: Direct Precipitation';
  Contents[18] := 'Step 18: Point-source Loadings';
  Contents[19] := 'Step 19: Nonpoint-source Loads';

  HelpRef[0]  := 'Wizard_Overview.htm';
  HelpRef[1]  := 'Wizard__Simulation_Type.htm';
  HelpRef[2]  := 'Topic47.htm';
  HelpRef[3]  := 'Topic48.htm';
  HelpRef[4]  := 'Topic49.htm';
  HelpRef[5]  := 'Topic50.htm';
  HelpRef[6]  := 'Topic51.htm';
  HelpRef[7]  := 'Topic52.htm';
  HelpRef[8]  := 'Topic53.htm';
  HelpRef[9]  := 'Topic54.htm';
  HelpRef[10] := 'Topic55.htm';
  HelpRef[11] := 'Topic56.htm';
  HelpRef[12] := 'Topic57.htm';
  HelpRef[13] := 'Topic58.htm';
  HelpRef[14] := 'Topic59.htm';
  HelpRef[15] := 'Topic60.htm';
  HelpRef[16] := 'Topic61.htm';
  HelpRef[17] := 'Topic62.htm';
  HelpRef[18] := 'Topic63.htm';
  HelpRef[19] := 'Topic64.htm';
  HelpRef[20] := 'Wizard_Overview.htm';


  For Loop := 1 to NumberOfSteps do
    Begin
      Status[Loop] := 0;
      LName := 'SL'+IntToStr(Loop);
      TL := TLabel(FindComponent(LName));
      TL.Caption := Contents[Loop];
    End;

{  For Loop := 0 to NumberOfSteps do
      FormsByIndex[Loop].Caption:='AQUATOX-- Simulation Creation Wizard'; }

  NewSetup := True;

  UpdateScreen;
end;

Procedure TWizardProgress.JumpToStep(Step: Integer);
Begin
  {If OK Button has problems then exit}
  If Not CurrentForm.Visible then Exit;
  If Not CurrentForm.ForceExit then exit;
  If (ScreenInt=1) and (CurrentForm.WizStatus=1) then DefaultBoxes;
  JumpToScreen := Step;
  UpdateScreen;
End;

procedure TWizardProgress.SL1DblClick(Sender: TObject);
Var Step: Integer;
    NameStr : String;
begin
  NameStr := TLabel(sender).Name;
  Delete(NameStr,1,2);
  Step := StrToInt(NameStr);
  JumpToStep(Step);
end;

procedure TWizardProgress.ResetBoxes;
Var Loop: Integer;
Begin
  For Loop := 1 to NumberOfSteps do
    Begin
      Status[Loop] := 0;
    End;
End;

procedure TWizardProgress.DefaultBoxes;
Var Loop: Integer;
Begin
  For Loop := 1 to NumberOfSteps do
    Begin
      Status[Loop] := 1;
    End;
End;


procedure TWizardProgress.Label19DblClick(Sender: TObject);
Var Step: Integer;
    NameStr : String;
begin
  NameStr := TLabel(sender).Name;
  Delete(NameStr,1,5);
  Step := StrToInt(NameStr);
  JumpToStep(Step);
end;

procedure TWizardProgress.FormShow(Sender: TObject);
begin
  UpdateScreen;
end;

procedure TWizardProgress.Button1Click(Sender: TObject);
begin
  Hide;
end;

procedure TWizardProgress.FormDestroy(Sender: TObject);
begin
 WizSummary.Free;
 WizBase.Free;
 FishTypeDialog.Free;
 FishClassDialog.Free;
 Wiz_GetEntry.Free;

 If CurrentForm <> nil then CurrentForm.Free;
end;

procedure TWizardProgress.helpbuttonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic65.htm');
end;

end.
