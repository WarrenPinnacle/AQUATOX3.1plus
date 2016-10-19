//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit LinkedThread;

interface

uses
  Classes, Progress, SysUtils, Dialogs, Forms, Global, AQUAOBJ,ExtCtrls ,
  StudyHasChanged, Controls, Study_IO, Wait, AQStudy, LinkedSegs;

type
  TLinkedSimulation = class(TThread)
  private
    MLS, TLS: TLinkedSegs;  {MainLinkedStudy, TheLinkedSTudy}
    UpdateProc: TMethdProc;
    SaveSeparately, SaveAfterRun: Boolean;
    { Private declarations }
  protected
    procedure Execute; override;
  public
    StartTime: TDateTime;
    AssocMap: TImage;
    Procedure CallProg;
    Procedure ChangeProg;
    Procedure CallMessageDlg;
    Procedure ShowMessageDlg;
    Procedure SetProgDefaults;
    Procedure TestStudyChanged;
    Procedure CopyResultsBack;
    Procedure SaveAsUnique;
    procedure UpdateMainForm;
    constructor Create(TS,MS:TLinkedSegs; MP: TMethdProc; AMap: TImage);
  end;

implementation



{ Important: Methods and properties of objects in VCL can only be used in a
  method called using Synchronize }

{ JSC's Note: Because ProgressForm Utilizes the VCL, all progress calls have been relegated to
  the UpdateProg procedure found below.  First the ProgData datastructure is updated and then
  the UpdateProg procedure can be run in a synchronized manner }

{ A Threadsafe MessageDLG implementation is also provided}

procedure TLinkedSimulation.Execute;
Var SavedResults: Array[-1..Max_Number_Segments] of Pointer;
    i: integer;
    WorkingStudy: TAQUATOXSegment;
begin
  FreeOnTerminate := True;

   For i:=-1 to TLS.SegmentColl.Count-1 do
     Begin
       if i=-1 then WorkingStudy := TLS.TemplateSeg
               else WorkingStudy := TLS.SegmentColl.At(i);
       If TLS.TemplateSeg.Control_Is_Running then
         Begin
            WorkingStudy.SetupControlRun(SavedResults[i]);
            WorkingStudy.Control_Is_Running := True;
         End;   

       WorkingStudy.SV.UpdateProg := CallProg;
       WorkingStudy.SV.TSMessage  := CallMessageDlg;
       WorkingStudy.SV.LinkedMode := True;

    End;

  Synchronize(SetProgDefaults);

  TLS.Run(False);

  If TLS.TemplateSeg.Control_Is_Running then
  For i:=-1 to TLS.SegmentColl.Count-1 do
    Begin
      if i=-1 then WorkingStudy := TLS.TemplateSeg
              else WorkingStudy := TLS.SegmentColl.At(i);
      WorkingStudy.RestoreStudyAfterControlRun(SavedResults[i]);
      WorkingStudy.Control_Is_Running := True;
    End;

  Synchronize(TestStudyChanged);

  If SaveSeparately then Synchronize(SaveAsUnique)
                    else Synchronize(CopyResultsBack);

end;

Procedure TLinkedSimulation.SaveAsUnique;
Var LoseSimOK, StudyDlgOK: Boolean;
    StratLoop: VerticalSegments;
    FileN: String;
    i: integer;
    WorkingStudy: TAQUATOXSegment;
    SaveDialog: TSaveDialog;
Begin

  saveDialog := TSaveDialog.Create(nil);     
  saveDialog.Title := 'Save your simulation As';
  saveDialog.InitialDir := Studies_Dir;
  saveDialog.Filter := 'AQUATOX Linked Segments (*.als)|*.als|All Files (*.*)|*.*';
  saveDialog.Options := [ofOverwritePrompt,ofPathMustExist,ofNoReadOnlyReturn,ofHideReadOnly, ofEnableSizing] ;
  saveDialog.DefaultExt := 'als';
  saveDialog.FilterIndex := 1;

  Repeat
    LoseSimOK := False;
     StudyDlgOK := saveDialog.Execute;
     If Not StudyDlgOK then LoseSimOK := MessageDlg('You have not selected a file name, so the Simulation''s results will be lost',mtconfirmation,[mbok,mbcancel],0) = mrok;
  Until StudyDlgOK or LoseSimOK;

  FileN :=saveDialog.FileName;
  SaveDialog.Free;

  If Not StudyDlgOK then
     Begin
       Synchronize(UpdateMainForm);
       Exit;
     End;

  TLS.FileName := ExtractFileName(FileN);
  TLS.DirName := ExtractFilePath(FileN);

  WaitDlg.Setup('Please Wait One Moment, Saving File');

  Try

  If TLS.TemplateSeg.Control_Is_Running then
   For i:=-1 to TLS.SegmentColl.Count-1 do
     Begin
        If i=-1 then WorkingStudy := TLS.TemplateSeg
                else WorkingStudy := TLS.SegmentColl.At(i);
        If TLS.TemplateSeg.Control_Is_Running
          Then
            Begin
              For StratLoop := Epilimnion to Hypolimnion do
                 WorkingStudy.SV.ControlResults[StratLoop].Destroy;
              WorkingStudy.SV.ControlResults := WorkingStudy.SV.Results;
              For StratLoop := Epilimnion to Hypolimnion do
                WorkingStudy.SV.Results[Stratloop]:=TResultsCollection.Init;
              WorkingStudy.LastRun := -1;
            End
          Else
            For StratLoop := Epilimnion to Hypolimnion do
              Begin
                WorkingStudy.SV.ControlResults[StratLoop].Destroy;
                WorkingStudy.SV.ControlResults[Stratloop]:=TResultsCollection.Init;
                WorkingStudy.ControlRun := -1;
              End;
     End;

    TLS.TemplateSeg.SV.StoreResults := True;
    TLS.TemplateSeg.SV.StoreDistribs := True;

    If TLS.TemplateSeg.Control_Is_Running then TLS.LastRun := -1
                                          else TLS.ControlRun := -1;

   TLS.SaveToFile(AssocMap);

  Except
    WaitDlg.Hide;
    Synchronize(UpdateMainForm);
    Raise;
  End;

  Synchronize(UpdateMainForm);
End;

Procedure TLinkedSimulation.SetProgDefaults;
Begin
  With TLS.TemplateSeg.SV do
    Begin
       ProgData.ErrVar := StudyProgDlg.ErrVariable.Caption;
       ProgData.ErrRate := StudyProgDlg.ErrRate.Caption;
       ProgData.PercStepCaption := StudyProgDlg.PercStep.Caption     ;
       ProgData.UncertStatLabel := StudyProgDlg.UncertStatusLabel.Caption  ;
       ProgData.UncertTitleLabel := StudyProgDlg.UncertTitleLabel.Caption   ;
       ProgData.ErrValue := StudyProgDlg.ErrValue.Caption     ;
       ProgData.DateStr := StudyProgDlg.DateLabel.Caption    ;
       ProgData.UncertPanelVis := StudyProgDlg.UncertPanel.Visible  ;
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


Procedure TLinkedSimulation.CallMessageDlg;
Begin
  Synchronize(ShowMessageDlg);
End;

Procedure TLinkedSimulation.ShowMessageDlg;
Var MT:TMsgDlgType;
Begin
  If TLS.TemplateSeg.SV.PMessageErr^
    then MT := MTError
    else MT := MTInformation;

  With TLS.TemplateSeg.SV do
    MessageDlg2(PMessageStr^,MT,[MBOK],0);
End;


Procedure TLinkedSimulation.CallProg;
Begin
  Synchronize(ChangeProg);
End;

Procedure TLinkedSimulation.ChangeProg;  {Thread Safe update of Progress Dialog}
Begin
  With TLS.TemplateSeg.SV do
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

       If (StudyProgDlg.ModalResult<>0) then ProgData.ProgCancel := True;
       StudyProgDlg.Update;
    End;
End;

Procedure TLinkedSimulation.CopyResultsBack;
Var TimeStamp: TDateTime;
    MainAQTS,WorkAQTS: TAQUATOXSegment;
    WorkingPStates, MainPStates : TStates;
    WorkingTSV, MainTSV: TStateVariable;
    ns: allvariables;
    ll: T_SVLayer;
    SegIndex: Integer;
    StopRepeat: Boolean;
    WorkingPD, MainPD: TDissRefrDetr;
    StratLoop: VerticalSegments;
Begin
  SegIndex:=0;

  Repeat
    WorkAQTS := TLS.SegmentColl.At(SegIndex);
    MainAQTS := MLS.SegmentColl.At(SegIndex);

    WorkingPStates := WorkAQTS.SV;
    MainPStates    := MainAQTS.SV;

    For StratLoop := Epilimnion to Hypolimnion do
      Begin
        If TLS.TemplateSeg.Control_Is_Running
          then Begin
                  MainPStates.ControlResults[StratLoop].Destroy;
                  WorkingPStates.Results[StratLoop].Destroy;
               End
          else Begin
                 MainPStates.Results[StratLoop].Destroy;
                 WorkingPStates.ControlResults[StratLoop].Destroy;
               End;
      End;

    If TLS.TemplateSeg.Control_Is_Running
       then MainPStates.ControlResults  := WorkingPStates.ControlResults
       else MainPStates.Results         := WorkingPStates.Results;

    If TLS.TemplateSeg.Control_Is_Running
       then MainAQTS.ControlRun := WorkAQTS.ControlRun
       else MainAQTS.LastRun := WorkAQTS.LastRun;

    For StratLoop := Epilimnion to Hypolimnion do

      Begin
        WorkingPStates.Results[StratLoop]:=nil;
        WorkingPStates.ControlResults[StratLoop]:=nil;
      End;

    If WorkingPStates.SetupRec.SPINUP_MODE then  {3-24-2008  copy results of spin-up back}
        For ns := FirstBiota to LastBiota do
         Begin
           WorkingTSV := WorkingPStates.GetStatePointer(ns,stv,watercol);
           If WorkingTSV<>nil then
             Begin
               MainTSV := MainPStates.GetStatePointer(ns,stv,watercol);
               If MainTSV<>nil then
                 MainTSV.InitialCond := WorkingTSV.InitialCond
             End;
         End;

    If WorkingPStates.SetupRec.SPINUP_MODE then  {9/27/2011  copy results of nutrient spin-up back}
     If WorkingPStates.SetupRec.SPIN_Nutrients then
      Begin
        For ns := Ammonia to BuriedLabileDetr do
         For ll := WaterCol to SedLayer2 do
           Begin
             WorkingTSV := WorkingPStates.GetStatePointer(ns,stv,ll);
             If WorkingTSV<>nil then
               Begin
                 MainTSV := MainPStates.GetStatePointer(ns,stv,ll);
                 If MainTSV<>nil then
                   Begin
                     MainTSV.InitialCond := WorkingTSV.InitialCond;
                     If (ns=Nitrate) and (ll=WaterCol) then TNo3Obj(MainTSV).TN_IC := False;    //Spun-up initial conditions set not to reflect TN or TP
                     If (ns=Phosphate) and (ll=WaterCol) then TPO4Obj(MainTSV).TP_IC := False;
                   End;
               End; // workingTSV<>nil
           End;  // loop;
        WorkingPD := WorkingPStates.GetStatePointer(DissRefrDetr,StV,WaterCol);
        MainPD := MainPStates.GetStatePointer(DissRefrDetr,StV,WaterCol);
        If (MainPD<>nil) and (WorkingPD<>nil) then MainPD.InputRecord.InitCond := WorkingPD.InputRecord.InitCond;
      End;  //Spin_Nutrients

    Inc (SegIndex);
    StopRepeat := (SegIndex > (TLS.SegmentColl.Count-1));

  Until StopRepeat;

  Timestamp := Now;
  If TLS.TemplateSeg.Control_Is_Running
    then Begin
           If TLS.ControlRun<>-2
             then MLS.ControlRun := Timestamp
             else Begin
                    MLS.ControlRun := -2;
                    SaveAfterRun := False;
                  End;
         End
    else Begin
           If TLS.LastRun<>-2 then MLS.LastRun := Timestamp
                              else Begin
                                     MLS.LastRun := -2;
                                     SaveAfterRun := False;
                                   End;
         End;


  MLS.LastChange := Timestamp;

  If SaveAfterRun then
    Begin
      WaitDlg.Setup('Please Wait One Moment, Saving File');
      Try
        MLS.SaveToFile(AssocMap);
        MLS.TimeLoaded := Now;
        MLS.LastChange := MLS.TimeLoaded;

      Except
        WaitDlg.Hide;
        Raise;
      End;
    End;

  Synchronize(UpdateMainForm);
End;

Procedure TLinkedSimulation.TestStudyChanged;
Var ThisStudyChangedDlg: TStudyChangedDlg;
Begin
  SaveSeparately := False;
  SaveAfterRun := False;

  If (MLS.LastChange>StartTime) and
    not (((TLS.TemplateSeg.Control_Is_Running) and (MLS.LastChange=MLS.LastRun)) or
         ((not TLS.TemplateSeg.Control_Is_Running) and (MLS.LastChange=MLS.ControlRun)))
      then
        Begin
          Application.CreateForm(TstudychangedDlg, thisstudychangedDlg);
          ThisStudychangedDlg.Caption := TLS.FileName+' Changed During Simulation Run';
          SaveSeparately := (thisstudychangedDlg.ShowModal = MrOK);
          ThisStudyChangedDlg.Free;
        End;

  If Not SaveSeparately and TLS.TemplateSeg.SV.StudyProgDlg.AutoSaveBox.Checked then SaveAfterRun := True;

End;

Procedure TLinkedSimulation.UpdateMainForm;
Begin
  Dec(MLS.SimsRunning);
  TLS.TemplateSeg.SV.StudyProgDlg.UncertPanel.Visible:=False;
  TLS.TemplateSeg.SV.StudyProgDlg.Free;
  TLS.Destroy;

  UpdateProc;
End;

Constructor TLinkedSimulation.Create(TS,MS:TLinkedSegs; MP: TMethdProc; AMap: TImage);
Begin
  MLS := MS;
  AssocMap := AMap;
  UpdateProc := MP;
  TLS  := TS;

  StartTime := Now;
  Inherited Create(False);
End;


end.
