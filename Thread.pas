//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
unit Thread;

interface

uses
  Classes, AQStudy, Progress, SysUtils, Dialogs, Forms, Global, AQUAOBJ, Windows,
  StudyHasChanged, Controls, Study_IO, Wait;

type
  TSimulation = class(TThread)
  private
    MainStudy, TheStudy: TAQUATOXSegment;
    UpdateProc: TMethdProc;
    SaveSeparately: Boolean;
    SaveAfterRun  : Boolean;
    { Private declarations }
  protected
    procedure Execute; override;
  public
    StartTime: TDateTime;
    Procedure CallProg;
    Procedure ChangeProg;
    Procedure CallMessageDlg;
    Procedure ShowMessageDlg;
    Procedure SetProgDefaults;
    Procedure TestStudyChanged;
    Procedure CopyResultsBack;
    Procedure SaveAsUnique;
    procedure UpdateMainForm;
    constructor Create(TS,MS:TAQUATOXSegment; MP: TMethdProc);
  end;

type
 Execution_State = dword;

procedure SetThreadExecutionState(ESFlags:Execution_State);
          stdcall; external kernel32 name 'SetThreadExecutionState';

const
  ES_SYSTEM_REQUIRED = $00000001;
  ES_CONTINUOUS = $80000000;

implementation

{ Important: Methods and properties of objects in VCL can only be used in a
  method called using Synchronize }

{ JSC's Note: Because ProgressForm Utilizes the VCL, all progress calls have been relegated to
  the UpdateProg procedure found below.  First the ProgData datastructure is updated and then
  the UpdateProg procedure can be run in a synchronized manner }

{ A Threadsafe MessageDLG implementation is also provided}

procedure TSimulation.Execute;
Var P: Pointer;
begin
  FreeOnTerminate := True;

  If TheStudy.Control_Is_Running then TheStudy.SetupControlRun(P);

  Synchronize(SetProgDefaults);
  TheStudy.SV.UpdateProg := CallProg;
  TheStudy.SV.TSMessage  := CallMessageDlg;
  TheStudy.SV.LinkedMode := False;

  TheStudy.Run;

  If TheStudy.Control_Is_Running then
    Begin
      TheStudy.RestoreStudyAfterControlRun(P);
      TheStudy.Control_Is_Running := True;
    End;

  Synchronize(TestStudyChanged);

  If SaveSeparately then Synchronize(SaveAsUnique)
                    else Synchronize(CopyResultsBack);

  SetThreadExecutionState(ES_CONTINUOUS)  //allow system to idle to sleep normally

end;

Procedure TSimulation.SaveAsUnique;

var
  saveDialog : TSaveDialog;
  LoseSimOK, StudyDlgOK: Boolean;
  StratLoop: VerticalSegments;
  FileN : String;

begin

  saveDialog := TSaveDialog.Create(nil);
  saveDialog.Title := 'Save your simulation As';
  saveDialog.InitialDir := TheStudy.DirName;
  saveDialog.Filter := 'AQUATOX Single Segment (*.aps)|*.aps|all files|*.*';
  saveDialog.Options := [ofOverwritePrompt,ofPathMustExist,ofNoReadOnlyReturn,ofHideReadOnly, ofEnableSizing] ;
  saveDialog.DefaultExt := 'aps';
  saveDialog.FilterIndex := 1;

  Repeat
    LoseSimOK := False;
     StudyDlgOK := saveDialog.Execute;
     If Not StudyDlgOK then LoseSimOK := MessageDlg('You have not selected a file name, so the Simulation''s results will be lost',mtconfirmation,[mbok,mbcancel],0) = mrok;
  Until StudyDlgOK or LoseSimOK;

  FileN := saveDialog.FileName;
  saveDialog.Free;

  If Not StudyDlgOK then
     Begin
       Synchronize(UpdateMainForm);
       Exit;
     End;

  TheStudy.FileName := ExtractFileName(FileN);
  TheStudy.DirName := ExtractFilePath(FileN);

  WaitDlg.Setup('Please Wait One Moment, Saving File');

  Try

    If TheStudy.Control_Is_Running
      Then
        For StratLoop := Epilimnion to Hypolimnion do
          Begin
            TheStudy.SV.Results[StratLoop].Destroy;
            TheStudy.SV.Results[Stratloop]:=TResultsCollection.Init;
          End
      Else
        For StratLoop := Epilimnion to Hypolimnion do
          Begin
            TheStudy.SV.ControlResults[StratLoop].Destroy;
            TheStudy.SV.ControlResults[Stratloop]:=TResultsCollection.Init;
          End;

    If TheStudy.Control_Is_Running then TheStudy.LastRun := -1
                                   else TheStudy.ControlRun := -1;

   TheStudy.SV.StoreResults := True;
   TheStudy.SV.StoreDistribs := True;
   SaveFile(TheStudy);
  Except
    WaitDlg.Hide;
    Synchronize(UpdateMainForm);
    Raise;
  End;

  Synchronize(UpdateMainForm);
End;

Procedure TSimulation.SetProgDefaults;
Begin
  With TheStudy.SV do
    Begin
       ProgData.ErrVar := StudyProgDlg.ErrVariable.Caption;
       ProgData.ErrRate := StudyProgDlg.ErrRate.Caption;
       ProgData.PercStepCaption := StudyProgDlg.PercStep.Caption;
       ProgData.UncertStatLabel := StudyProgDlg.UncertStatusLabel.Caption;
       ProgData.UncertTitleLabel := StudyProgDlg.UncertTitleLabel.Caption;
       ProgData.ErrValue := StudyProgDlg.ErrValue.Caption;
       ProgData.DateStr := StudyProgDlg.DateLabel.Caption;
       ProgData.UncertPanelVis := StudyProgDlg.UncertPanel.Visible;
       ProgData.StratVis := StudyProgDlg.StratLabel.Visible;
       ProgData.AnoxicVis := StudyProgDlg.AnoxicLabel.Visible;
       ProgData.WZVis := StudyProgDlg.WaterVolZero.Visible;
       ProgData.StepSizeVis := StudyProgDlg.StepSizeLabel.Visible;
       ProgData.ProgInt := StudyProgDlg.Gauge1.Progress;
       ProgData.Gauge2Int := StudyProgDlg.Gauge2.Progress;
       ProgData.PeriVis := StudyProgDlg.PeriLabel.Visible;
       ProgData.SloughDia := StudyProgDlg.DiaLabel.Visible;
       ProgData.SloughGr := StudyProgDlg.GrLabel.Visible;
       ProgData.SloughBlGr := StudyProgDlg.BlGrLabel.Visible;
       ProgData.ProgCancel := False;       
    End;
End;


Procedure TSimulation.CallMessageDlg;
Begin
  Synchronize(ShowMessageDlg);
End;

Procedure TSimulation.ShowMessageDlg;
Var MT:TMsgDlgType;
Begin
  If TheStudy.SV.PMessageErr^ then MT := MTError
                              else MT := MTInformation;

  With TheStudy.SV do
    MessageDlg2(PMessageStr^,MT,[MBOK],0);
End;


Procedure TSimulation.CallProg;
Begin
  Synchronize(ChangeProg);
End;

Procedure TSimulation.ChangeProg;  {Thread Safe update of Progress Dialog}
Begin
  With TheStudy.SV do
    Begin
       StudyProgDlg.ErrVariable.Caption  := ProgData.ErrVar;
       StudyProgDlg.ErrRate.Caption      := ProgData.ErrRate;
       StudyProgDlg.PercStep.Caption     := ProgData.PercStepCaption;
       StudyProgDlg.UncertStatusLabel.Caption  := ProgData.UncertStatLabel;
       StudyProgDlg.UncertTitleLabel.Caption   := ProgData.UncertTitleLabel;
       StudyProgDlg.ErrValue.Caption     := ProgData.ErrValue;
       StudyProgDlg.DateLabel.Caption    := ProgData.DateStr;
       StudyProgDlg.UncertPanel.Visible  := ProgData.UncertPanelVis;
       StudyProgDlg.StratLabel.Visible   := ProgData.StratVis;
       StudyProgDlg.AnoxicLabel.Visible  := ProgData.AnoxicVis;
       StudyProgDlg.WaterVolZero.Visible := ProgData.WZVis;

       StudyProgDlg.StepSizeLabel.Visible:= ProgData.StepSizeVis;
       StudyProgDlg.Gauge1.Progress      := ProgData.ProgInt;
       StudyProgDlg.Gauge2.Progress      := ProgData.Gauge2Int;
       StudyProgDlg.DiaLabel.Visible     := ProgData.SloughDia;
       StudyProgDlg.GrLabel.Visible      := ProgData.SloughGr;
       StudyProgDlg.BlGrLabel.Visible    := ProgData.SloughBlGr;
       With ProgData^ do
         StudyProgDlg.PeriLabel.Visible    := PeriVis and (SloughDia or SloughGr or SloughBlGr);

       If ProgData.ProgCancel then StudyProgDlg.ModalResult := MRCancel;
       If (StudyProgDlg.ModalResult<>0) then ProgData.ProgCancel := True;
       StudyProgDlg.Update;
    End;
End;

Procedure TSimulation.CopyResultsBack;
Var TimeStamp: TDateTime;
    WorkingPStates, MainPStates : TStates;
    WorkingTSV, MainTSV: TStateVariable;
    WorkingPD, MainPD: TDissRefrDetr;
    ns: allvariables;
    ll: T_SVLayer;
    StratLoop: VerticalSegments;
Begin

  WorkingPStates := TheStudy.SV;
  MainPStates := MainStudy.SV;

  For StratLoop := Epilimnion to Hypolimnion do
    Begin
      If TheStudy.Control_Is_Running
          then Begin
                  MainPStates.ControlResults[StratLoop].Destroy;
                  WorkingPStates.Results[StratLoop].Destroy;
               End
          else Begin
                 MainPStates.Results[StratLoop].Destroy;
                 WorkingPStates.ControlResults[StratLoop].Destroy;
               End;
    End;

  If TheStudy.Control_Is_Running
     then MainPStates.ControlResults  := WorkingPStates.ControlResults
     else MainPStates.Results         := WorkingPStates.Results;

  For StratLoop := Epilimnion to Hypolimnion do
    Begin
      WorkingPStates.Results[StratLoop]:=nil;
      WorkingPStates.ControlResults[StratLoop]:=nil;
    End;

  Timestamp := Now;
  If TheStudy.Control_Is_Running
    then Begin
           If TheStudy.ControlRun<>-2
             then MainStudy.ControlRun := Timestamp
             else Begin
                    MainStudy.ControlRun := -2;
                    SaveAfterRun := False;
                  End;
         End
    else Begin
           If TheStudy.LastRun<>-2 then MainStudy.LastRun := Timestamp
                                   else Begin
                                          MainStudy.LastRun := -2;
                                          SaveAfterRun := False;
                                        End;
         End;

  If WorkingPStates.SetupRec.SPINUP_MODE then  {3-24-2008  copy results of spin-up back}
    For ns := FirstBiota to LastBiota do
     Begin
       WorkingTSV := TheStudy.SV.GetStatePointer(ns,stv,watercol);
       If WorkingTSV<>nil then
         Begin
           MainTSV := MainStudy.SV.GetStatePointer(ns,stv,watercol);
           If MainTSV<>nil then
             MainTSV.InitialCond := WorkingTSV.InitialCond
         End;
     End;

  If WorkingPStates.SetupRec.SPINUP_MODE then  {9/27/2011  copy results of nutrient spin-up back}
    If WorkingPStates.SetupRec.SPIN_Nutrients then
     Begin
       for ns := Ammonia to SedmLabDetr do
        for ll := WaterCol to SedLayer2 do
         Begin
            WorkingTSV := TheStudy.SV.GetStatePointer(ns,stv,ll);
            If WorkingTSV<>nil then
              Begin
                MainTSV := MainStudy.SV.GetStatePointer(ns,stv,ll);
                If MainTSV<>nil then
                  Begin
                    MainTSV.InitialCond := WorkingTSV.InitialCond;
                    If (ns=Nitrate) and (ll=WaterCol) then TNo3Obj(MainTSV).TN_IC := False;    //Spun-up initial conditions set not to reflect TN or TP
                    If (ns=Phosphate) and (ll=WaterCol) then TPO4Obj(MainTSV).TP_IC := False;
                  End;
              End; // workingTSV<>nil
         End;  // loop;
       WorkingPD := TheStudy.SV.GetStatePointer(DissRefrDetr,StV,WaterCol);
       MainPD := MainStudy.SV.GetStatePointer(DissRefrDetr,StV,WaterCol);
       If (MainPD<>nil) and (WorkingPD<>nil) then MainPD.InputRecord.InitCond := WorkingPD.InputRecord.InitCond;
     End;

  MainStudy.LastChange := Timestamp;

  If SaveAfterRun then
    Begin
      WaitDlg.Setup('Please Wait One Moment, Saving File');
      Try
        MainStudy.SV.StoreResults := True;
        MainStudy.SV.StoreDistribs := True;
        SaveFile(MainStudy);
        MainStudy.TimeLoaded := Now;
        MainStudy.LastChange := MainStudy.TimeLoaded;

      Except
        WaitDlg.Hide;
        Raise;
      End;
    End;

  Synchronize(UpdateMainForm);
End;

Procedure TSimulation.TestStudyChanged;
Var ThisStudyChangedDlg: TStudyChangedDlg;
Begin
  SaveSeparately := False;
  SaveAfterRun := False;
  If (MainStudy.LastChange>StartTime) and
    not (((TheStudy.Control_Is_Running) and (MainStudy.LastChange=MainStudy.LastRun)) or
         ((not TheStudy.Control_Is_Running) and (MainStudy.LastChange=MainStudy.ControlRun)))
         Then
           Begin
             Application.CreateForm(TstudychangedDlg, thisstudychangedDlg);
             ThisstudychangedDlg.Caption := TheStudy.FileName+' Changed During Simulation Run';
             SaveSeparately := (thisstudychangedDlg.ShowModal = MrOK);
             ThisstudychangedDlg.Free;
           End;
  If Not SaveSeparately and TheStudy.SV.StudyProgDlg.AutoSaveBox.Checked then SaveAfterRun := True;

End;

Procedure TSimulation.UpdateMainForm;
Begin
  Dec(MainStudy.SimsRunning);
  TheStudy.SV.StudyProgDlg.UncertPanel.Visible:=False;
  TheStudy.SV.StudyProgDlg.Free;
  TheStudy.Destroy;

  If MainStudy.PSetup^.Spinup_Mode
    Then If MessageDlg('Spin up completed.  Turn off spin-up mode now?',mtconfirmation,[mbyes,mbno],0)
         = mryes then MainStudy.PSetup^.Spinup_Mode := False;

  UpdateProc;
End;

Constructor TSimulation.Create(TS, MS:TAQUATOXSegment; MP: TMethdProc );
Begin
  MainStudy := MS;
  UpdateProc := MP;
  TheStudy  := TS;
  StartTime := Now;
  SetThreadExecutionState(ES_SYSTEM_REQUIRED or ES_CONTINUOUS);  //prevent the sleep idle time-out and power off
  Inherited Create(False);
End;


end.
