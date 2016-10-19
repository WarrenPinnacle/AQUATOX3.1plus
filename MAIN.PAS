//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Main;

interface

uses  AQBaseForm, DB, DBTables, ExtCtrls, Dialogs, Buttons, StdCtrls, Controls,
  Graphics, Classes, Messages, Forms, AqStudy, hh;

Const UM_AFTERACTIVE = WM_USER + 120;
  
type
  TPrimaryInterface = class(TAQBase)
    PrinterSetupDialog1: TPrinterSetupDialog;
    SaveDialog1: TSaveDialog;
    Timer1: TTimer;
    ExportTable: TTable;
    PrimaryPanel: TPanel;
    SVLabel: TLabel;
    TitleLabel: TLabel;
    UncertLabel: TLabel;
    SegIDLabel: TLabel;
    StudyNameLabel: TLabel;
    betalabel: TLabel;
    ModLabel: TLabel;
    SegNumTextBox: TEdit;
    ModelRunPanel: TPanel;
    LastRunLabel: TLabel;
    controllabel: TLabel;
    ControlRunLabel: TLabel;
    Label5: TLabel;
    toxiclabel: TLabel;
    ListBox1: TListBox;
    AddButton: TButton;
    DeleteButton: TButton;
    EditButton: TButton;
    DividerPanel: TPanel;
    StudyNameEditBox: TEdit;
    BigButtPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    LinkedModeLabel: TLabel;
    SedLayerLabel: TLabel;
    MultiSegReturn: TBitBtn;
    StratificationButton: TBitBtn;
    ChemicalButton: TBitBtn;
    SiteButton: TBitBtn;
    SetupButton: TBitBtn;
    RunButton: TBitBtn;
    OutputButton: TBitBtn;
    NotesButton: TBitBtn;
    ControlButton: TBitBtn;
    ExportButton: TBitBtn;
    InitCondButton: TBitBtn;
    Panel1: TPanel;
    ExportControlButton: TBitBtn;
    WizardButton: TBitBtn;
    HelpButton: TBitBtn;
    SedLayersButton: TBitBtn;
    MorphometryButton: TBitBtn;
    BirdButt: TBitBtn;
    SpinUpLabel: TLabel;
    TrophIntButton: TBitBtn;
    InternalNutLabel: TLabel;
    Procedure StudyNameEditBoxChange(Sender: TObject);
    Procedure NotesButtonClick(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure DeleteButtonClick(Sender: TObject);
    Procedure ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    Procedure AddButtonClick(Sender: TObject);
    Procedure EditButtonClick(Sender: TObject);
    Procedure ChemicalButtonClick(Sender: TObject);
    Procedure SiteBitBtnClick(Sender: TObject);
    Procedure SetupBitBtnClick(Sender: TObject);
    Procedure OutputBitBtnClick(Sender: TObject);
    Procedure Save1Click(Sender: TObject);
    Procedure SaveAs1Click(Sender: TObject);
    Procedure FormClose(Sender: TObject; var Action: TCloseAction);
    Procedure PrintSetup1Click(Sender: TObject);
    Procedure ExportResults1Click(Sender: TObject);
    Procedure ControlButtClick(Sender: TObject);
    Procedure ListBox1DblClick(Sender: TObject);
    Procedure ExportControlResults1Click(Sender: TObject);
    Procedure InitCondButtonClick(Sender: TObject);
    Procedure DebugButton1Click(Sender: TObject);
    Procedure Uncertainty1Click(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    procedure ControlRunSetup1Click(Sender: TObject);
    procedure ClearResults1Click(Sender: TObject);
    procedure SegNumTextBoxChange(Sender: TObject);
    procedure MultiSegReturnClick(Sender: TObject);
    procedure StratButtonClick(Sender: TObject);
    procedure ThickButtonClick(Sender: TObject);
    procedure AddSedimentModel1Click(Sender: TObject);
    procedure RemoveSedimentModel1Click(Sender: TObject);
    procedure AddBuriedSedLayer1Click(Sender: TObject);
    procedure RemoveBuriedSedLayer1Click(Sender: TObject);
    procedure SedLayerButtClick(Sender: TObject);
    procedure AddNonReactiveSedLayer1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure WizBtnClick(Sender: TObject);
    procedure RunButtonClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure HelpButtonClick(Sender: TObject);
    procedure SegNumTextBoxExit(Sender: TObject);
    procedure BirdButtClick(Sender: TObject);
    procedure SaveDialog1TypeChange(Sender: TObject);
    procedure TrophIntButtonClick(Sender: TObject);
  protected
    procedure UMAfterActive(var Message: TMessage); message UM_AFTERACTIVE;
  private
    SaveSuccess: Boolean;
    Function Check_Save_and_Cancel(ActionGerund: ShortString): Boolean;
  public
    IncomingFile: String;
    LinkedPS: Pointer;
    PNumSegs: PInteger;
    AQTStudy: TAQUATOXSegment;  {Variable that holds the main study}
    OldSegID: String;
    Procedure BeforeDestruction; Override;
    Procedure BorrowParameters;
    Procedure AddDiagenesis;
    Procedure RemoveDiagenesis;
    Procedure AddSSC(update:Boolean);
    Procedure RemoveSSC(update:Boolean);
    Procedure ExportParametersAsText;
    Procedure GraphsToWord;
    Procedure EditTrophInt;
    Procedure EditPlantLink;
    procedure Export_to_2_2;
    procedure Export_to_3;
    Procedure CHANGED_TRUE;
    Procedure AdjustOnButtonChange;
    Procedure Show_Study_Info;
    Procedure ExecuteSimulation(IsControl: Boolean);
    Constructor Create(AOwner: TComponent; Study: TAQUATOXSegment); reintroduce;
    Function Get_Uncertainty_File_Info(Stdy: TAQUATOXSegment): Boolean;
    Function  CompressFileN(FN,DR:String): String;
    Procedure Rate1Click(Sender: TObject);
    Function CopyTheStudy(complete: Boolean): TAQUATOXSegment;
    Procedure ControlSetup1Click(Sender: TObject);
 end;

Const NumFilesSaved=5;

var
  PrimaryInterface: TPrimaryInterface;

implementation

uses RateScrn, Control, results, chartprop, ChangVar, DBEntry, Observed_Data,
  Debug, SedLayers, WizardProg, EditButtons, Parent, LinkedInterface,
  ExportResults, trophmatrix, Global, WinTypes, WinProcs,  Chem, LinkedSegs,
  MultiFish, MorphEdit, Gauges, NewStudy, Aquaobj, NotesDlg, InsrtDlg,
  SV_IO, Menus, Librarys2, Wait, Batch, COMMDLG, SysUtils, ClearResults,
  EdStateV, Progress, SiteScre, Setup, Output, Splash, Study_IO, LinkStrat,
  TCollect, InitCond,  Uncert, U_Setup, FileCtrl, BirdForm, AllPlantLinksEdit,
  Grids, DBGrids, Thread, ToolWin, Diagenesis, Diag_InitCond, AQTOpenDialog;

{$R *.DFM}


Function TPrimaryInterface.CompressFileN(FN,DR:String): String;
Var TFile: String;
    Index,Loop,CopyUp: Integer;
Begin
  If DR = Studies_Dir
     then TFile := FN
     else Begin
            TFile := DR[1]+DR[2]+Dr[3];
            Index := Length(DR);
            CopyUp := Length(DR)+1;
            While (Index>Length(Dr)-25) and (Index>3) do
              Begin
                If (DR[Index]='\') or (Index=4) then CopyUp := Index;
                Dec(Index);
              End;
            If CopyUp > 4 then TFile := TFile+'...';
            For Loop := CopyUp to Length(DR) do
              TFile := TFile+DR[Loop];
            TFile := TFile + '\' + FN;
          End;
  CompressFileN := TFile;
End;


Procedure TPrimaryInterface.AdjustOnButtonChange;
Begin
  If not (WindowState=WsMaximized) then
    If ParentForm.ShowBigButtons
      then Width := 642
      else ClientWidth := 336;

  Show_Study_Info;
End;

Procedure TPrimaryInterface.FormShow(Sender: TObject);
begin
  If Not (WindowState=WsMaximized) then
    If ParentForm.ShowBigButtons
      then
        Begin
          Height := 670;
          Width := 642;
        End
      else
        Begin
          Height := 670;
          ClientWidth := 336;
        End;

  Show_Study_Info;

end;

Procedure CreateSetupForms;
Begin
  Application.CreateForm(TRSetupForm, RSetupForm);
  Application.CreateForm(TResultsForm, ResultsForm);
  Application.CreateForm(TStudySetupDialog, StudySetupDialog);
  Application.CreateForm(TControlform, ControlForm);
  Application.CreateForm(TDistributionForm, DistributionForm);
  Application.CreateForm(TUSetupForm, USetupForm);
End;

Procedure DestroySetupForms;
Begin
  RSetupForm.Free;
  ResultsForm.Free;
  StudySetupDialog.Free;
  ControlForm.Free;
  DistributionForm.Free;
  USetupForm.Free;
End;

Procedure TPrimaryInterface.ControlSetup1Click(Sender: TObject);
begin
  CreateSetupForms;
  ControlForm.Edit_Control(AQTStudy.SV.PControlInfo^, AQTStudy.SV);
  If ControlForm.Changed then CHANGED_TRUE;
  DestroySetupForms;
  Show_Study_Info;
end;

Procedure TPrimaryInterface.CHANGED_TRUE;
{Handle the update of the AQTStudy data structure after the study has been
 modified}
Begin
  AQTStudy.LastChange := Now;
  ModLabel.Visible := (AQTStudy.LastChange > AQTStudy.TimeLoaded);
End;


Function TPrimaryInterface.Check_Save_and_Cancel(ActionGerund: ShortString): Boolean;
{Upon Opening New Study, Closing the program, etc. (specified in ActionGerund)
 This proecdure ensures user does not wish to save current study first}
                                                              
 Var MR : TModalResult;
     NullObj: Tobject;
     i: Integer;
     GraphHolder: TGraphs;

 Begin
   NullObj:=Nil;
   Check_Save_and_Cancel:=False;

   If AQTStudy<>nil then
    for i:= 0 to ParentForm.MDIChildCount-1 do
      if ParentForm.MDIChildren[i] is TOutputscreen then
        If TOutputscreen(Parentform.MDIChildren[i]).MainStudy = AQTStudy then
          If (TOutputscreen(Parentform.MDIChildren[i]).Changed > AQTStudy.LastChange) then
            AQTStudy.LastChange := TOutputscreen(Parentform.MDIChildren[i]).Changed;

   If AQTStudy.SV.LinkedMode then Exit;

   If AQTStudy<>nil then if AQTStudy.LastChange > AQTStudy.TimeLoaded then
      Begin
         Mr := MessageDlg('Save '+AQTStudy.FileName + ' Before '+ActionGerund+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
         if (Mr=mrYes) then
           Begin
            If AQTStudy<>nil then
              {Pass back any changes to the graphs in the output window}
              For i:= 0 to ParentForm.MDIChildCount-1 do
                if ParentForm.MDIChildren[i] is TOutputscreen then
                  If TOutputscreen(Parentform.MDIChildren[i]).MainStudy = AQTStudy then
                    If (TOutputscreen(Parentform.MDIChildren[i]).Changed = AQTStudy.LastChange) then
                      Begin
                        GraphHolder := AQTStudy.SV.Graphs;
                        AQTStudy.SV.Graphs := TOutputscreen(Parentform.MDIChildren[i]).GSRStudy.SV.Graphs;
                        GraphHolder.Destroy;
                        TOutputscreen(Parentform.MDIChildren[i]).GSRStudy.SV.Graphs := nil;
                      End;  
             Save1Click(NullObj);
           End;
         if Mr=mrCancel then Check_Save_and_Cancel:=True;


      End;


{   If (AQTStudy<>nil) and (not Result) then PrimaryInterface.UpdateMenuItems; }
   {add this study to the top of the recently used files list before closing it}

 End;

 Procedure TPrimaryInterface.Show_Study_Info;
{SHOW ALL INFO ABOUT CURRENT STUDY ON STUDY SCREEN }

 Var DateHolder: String;
     SedEnable: Boolean;
{    Memstat: TMemoryStatus;}

 Begin
    Caption :=  AQTStudy.Filename + '-- Main Window';
    BetaLabel.Caption := 'EPA Release 3.1 plus';
    ModLabel.Visible := (AQTStudy.LastChange > AQTStudy.TimeLoaded);

    Enabled:=True;
    WaitDlg.Hide;
    Parentform.UpdateMenu(AQTStudy);
    SpinupLabel.Visible := False;

    InternalNutLabel.Visible := AQTStudy.PSetup^.Internal_Nutrients;

    With AQTStudy.PUncertainty^ do
      Begin
        {Show Uncertainty Setup}
          UncertLabel.Caption:='Model is set up to run '+
                  IntToStr(NumSteps)+ ' uncert. iterations.';
          If Run_Sensitivity then UncertLabel.Caption := 'Model is set up to run in sensitivity mode.';
          UncertLabel.Visible:= Run_Uncertainty or Run_Sensitivity;
      End;

       {Write Last Run}
       If AQTStudy.LastRun = -1 then LastRunLabel.Caption:='No Results Attached'
  else If AQTStudy.LastRun = -2 then LastRunLabel.Caption:='Partial Run Only'
  else begin
         DateTimeToString(DateHolder,'mm-d-y t',AQTStudy.LastRun);
         LastRunLabel.Caption:=DateHolder ;
       end; {if}

       If AQTStudy.ControlRun = -1 then ControlRunLabel.Caption:='No Ctrl. Results Attached'
  else If AQTStudy.ControlRun = -2 then ControlRunLabel.Caption:='Partial Ctrl. Run Only'
  else begin
         DateTimeToString(DateHolder,'mm-d-y t',AQTStudy.ControlRun);
         ControlRunLabel.Caption:=DateHolder ;
       end; {if}

       {Add State Variables Names to Screen}
       AQTStudy.DisplayNames(ListBox1.Items);

       If ParentForm.ShowBigButtons
         then
           Begin
             BigButtPanel.Visible := True;
             DividerPanel.Visible := True;
             SVLabel.Top       := 64;
             UncertLabel.Top   := 44;
             UncertLabel.Left   := 351;
             ListBox1.Left     := 358;
             ListBox1.Top      := 93;
             AddButton.Left    := 381;
             DeleteButton.Left := 462;
             EditButton.Left   := 542;
             SVLabel.Visible   := True;
             ListBox1.Width    := PrimaryPanel.Width -682+309;
             ListBox1.Height   := PrimaryPanel.Height-620+458;
             AddButton.Top     := PrimaryPanel.Height-620+567;
             DeleteButton.Top     := PrimaryPanel.Height-620+567;
             EditButton.Top     := PrimaryPanel.Height-620+567;
           End
         else
           Begin     {HIDE BIG BUTTONS}
             BigButtPanel.Visible := False;
             DividerPanel.Visible := False;
             SVLabel.Top       := 64;
             UncertLabel.Top   := 162;
             UncertLabel.Left   := 40;
             ListBox1.Left     := 12;
             ListBox1.Top      := 197;
             AddButton.Left    := 53;
             DeleteButton.Left := 134;
             EditButton.Left   := 214;
             SVLabel.Visible   := False;
             ListBox1.Width    := PrimaryPanel.Width-29;
             ListBox1.Height   := PrimaryPanel.Height-270;
             AddButton.Top     := PrimaryPanel.Height-620+567;
             DeleteButton.Top  := PrimaryPanel.Height-620+567;
             EditButton.Top     := PrimaryPanel.Height-620+567;
           End;

      If AQTStudy.SV.LinkedMode then
        Begin
           If LinkedPS <> nil then
             Caption :=  'Segment '+AQTStudy.SegNumber + ': '+TLinkedSegs(LinkedPS).Systemname + ';  '+TLinkedSegs(LinkedPS).FileName;
           SegNumTextBox.Visible := True;
           StudyNameLabel.Top := 31;
           StudyNameLabel.Left := 106;
           SegIDLabel.Visible:= True;
           RunButton.Visible := False;
           ControlButton.Visible := False;
           StudyNameLabel.Left   := 82;
           StudyNameLabel.Caption := 'Seg. Name';
           StudyNameLabel.Top    := 30;
           StudyNameEditBox.Left := 78;
           StudyNameEditBox.Top  := 51;
           MultiSegReturn.Visible := True;
           StratificationButton.Visible := True;
           MorphometryButton.Visible := True;
           LinkedModeLabel.Visible := True;
        End;

        If AQTStudy.SV.SedLayers = 1
           then SedLayerLabel.Caption := 'There is 1 sediment layer modeled.'
           else SedLayerLabel.Caption := 'There are '+IntToStr(AQTStudy.SV.SedLayers)+' sediment layers modeled.';
        If AQTStudy.SV.SedNonReactive then SedLayerLabel.Caption := 'There is 1 NON-REACTIVE sediment layer.';
        If (AQTStudy.SV.GetStatePointer(POC_G1,StV,SedLayer2) <> nil) then SedLayerLabel.Caption := 'Sediment Diagenesis Model is Enabled.';

       {Show the screen}
       PrimaryPanel.Visible:=True;
       Update;

       SedEnable := (AQTStudy.SV.SedLayers > 0) or
                    (AQTStudy.SV.GetStatePointer(POC_G1,StV,SedLayer2) <> nil);
       SedLayerLabel.Enabled   := SedEnable;
       SedLayersButton.Enabled := SedEnable;

       PrimaryPanel.Visible  := True;
       If AQTStudy.SV.LinkedMode
          Then PrimaryInterface.Caption:='AQUATOX:  Linked Mode  (Segment View)'
          Else PrimaryInterface.Caption:='AQUATOX-- For Windows: "'+AQTStudy.FileName+'"';

       {Update Names on Screen}
       StudyNameEditBox.Text:=AQTStudy.StudyName;
       SegNumTextBox.Text:=AQTStudy.SegNumber;
       SpinUpLabel.Visible := AQTStudy.PSetup^.SPINUP_MODE;

       {Show the screen}
       PrimaryPanel.Visible:=True;
       Update;
 End;

{-----------------------------------------------------------}
{ THE NEXT ProcedureS HANDLE BUTTON CLICKS AND MENU CHOICES }
{-----------------------------------------------------------}

Constructor TPrimaryInterface.Create(AOwner: TComponent; Study: TAQUATOXSegment);
Begin
  LinkedPS := nil;
  AQTStudy := Study;
  OldSegID := Study.SegNumber;

  Inherited Create(AOwner);
End;

{The Library Menu Selections Follow.  They Call Routine in LIBRARYS.PAS}

Procedure TPrimaryInterface.StudyNameEditBoxChange(Sender: TObject);
{If the study name is changed by user, update datastructure}
begin
   if AQTStudy.StudyName<>StudyNameEditBox.Text then
      begin
         AQTStudy.StudyName:=StudyNameEditBox.Text;
         AQTStudy.LastChange := Now;
         ModLabel.Visible := True;
      end;
end;

procedure TPrimaryInterface.SegNumTextBoxChange(Sender: TObject);
begin
   if AQTStudy.SegNumber<>SegNumTextBox.Text then
      begin
         AQTStudy.SegNumber:=SegNumTextBox.Text;
         Changed_True;
         ModLabel.Visible := True;
      end;
end;

Procedure TPrimaryInterface.NotesButtonClick(Sender: TObject);
{Bring up the Notes Dialog}
begin
   Application.CreateForm(TNotesDialog,NotesDialog);
   NotesDialog.DisplayNotes(AQTStudy.NewNotes);
   If NotesDialog.Changed then CHANGED_TRUE;
   NotesDialog.Free;
end;

Procedure TPrimaryInterface.FormDestroy(Sender: TObject);
{Called when program finishes execution}
begin

   If not (AQTSTUDY=nil) then
    If Not AQTStudy.SV.LinkedMode then
     Begin
       AQTSTUDY.Destroy;
     End;
end;

Function TPrimaryInterface.Get_Uncertainty_File_Info(Stdy: TAQUATOXSegment): Boolean;
{Get the name of the file to output uncertainty info to and verify
 validity}
Var OutDir,OutFile,OutExt: ShortString;
    Loop: Integer;
    UncSaveDialog:TSaveDialog;
Begin
  Get_Uncertainty_File_Info:=False;
  UncSaveDialog := TSaveDialog.Create(nil);
  UncSaveDialog.Options := [ofoverwriteprompt,ofpathmustexist,ofcreateprompt,ofhidereadonly,ofEnableSizing];
  With UncSaveDialog do
    begin
      Filter := 'Paradox Format (*.db)|*.DB|DBase Format (*.dbf)|*.DBF';       {ENABLE XLS, Long Term Priority}
      InitialDir := ''; //OUTPUT_DIR;
      Title:='Output Uncertainty Results As: ';
      if not Execute then exit;
      OutDir:=ExtractFilePath(FileName);
      OutFile:=ExtractFileName(FileName);
      OutExt := LowerCase(ExtractFileExt(FileName));

      If OutExt = '' then
          Case FilterIndex of
             1: OutExt := '.db';
             2: OutExt := '.dbf';
             3,4: OutExt := '.xls';
             else OutExt := '.csv';
           End; {Case}
    end;

  If not ((OutExt='.dbf') or (OutExt='.db') or (OutExt='.db '))
     then Raise EAquatoxError.Create('Uncertainty Output File must be of type (*.DBF) or (*.DB)');

  Delete(OutFile,Pos(OutExt,Lowercase(OutFile)),Length(OutExt));

  If Pos ('HYP',Uppercase(Outfile)) =1
             then Raise EAquatoxError.Create('Cannot begin database name with HYP.  Reserved for Hypolimnion data.');

  Stdy.Unc_Dir:=OutDir;
  Stdy.Unc_File:=OutFile;
  Stdy.Unc_Ext:=OutExt;
  Get_Uncertainty_File_Info:=True;

  For Loop := 1 to Length(OpenUncFiles) do
    If Stdy.Unc_File=OpenUncFiles[Loop-1] then
       Begin
          MessageDlg('That Database file is currently being written to by another simulation run.',mterror,[mbOK],0);
          Get_Uncertainty_File_Info:=False;
       End;

  If Result then
    Begin
      SetLength(OpenUncFiles, Length(OpenUncFiles)+1);
      OpenUncFiles[Length(OpenUncFiles)-1] := Stdy.Unc_File;
    End;

End;


Procedure TPrimaryInterface.Rate1Click(Sender: TObject);
begin
  CreateSetupForms;
  AQTStudy.PSetup^.SaveBRates := True;
  RSetupForm.Edit_RSetup(AQTStudy.SV.PRateInfo^, AQTStudy.SV);
  If RSetupForm.Changed then CHANGED_TRUE;
  DestroySetupForms;
  Show_Study_Info;
end;



Procedure TPrimaryInterface.ExecuteSimulation(IsControl: Boolean);
Var ThisProgress: TProgressDialog;
    ProgStr: String;
    RunStudy: TAQUATOXSegment;
    NumTests, i: integer;
    StoreStep: Double;
    FoundSens: Boolean;

   Procedure CountNumTests;
   var i: Integer;
   Begin
     NumTests := 0;
     With AQTStudy.SV do
       For i := 0 to Distributions.Count - 1 do
         If TDistribution(Distributions.At(i)).UseForSens then NumTests := NumTests + 2;
   End;

  Function ExecuteSensitivity: Boolean;
  Var i: Integer;
  begin
      Result := False;
      If AQTStudy.PUncertainty^.NumSens = 0 then
        Begin
          MessageDlg('Model is set up to run in Sensitivity Mode, but no output variables are set up for tracking',
                     mterror,[mbok],0);
          Exit;
        End;

      StoreStep := AQTStudy.PSetup^.StoreStepSize;
      If not AQTStudy.PSetup^.StepSizeInDays then StoreStep := StoreStep / 24;
      if StoreStep <=7 then
        if MessageDlg('Your data averaging period is less than one week.  Is this your intention?  Recall that ' +
                      'a sensitivity analysis saves selected results from the last data-point output in your model run.  '+
                      'This means the last time-step (less than one week) will be output as sensitivity results. '+
                      'If a longer averaging time is desired, change the averaging (data storage) time-step in '+
                      'the setup screen.  Continue Run?',mtconfirmation,[mbyes,mbno],0) = MRNo
          then exit;

      FoundSens := False;
      With AQTStudy.SV do
        For i := 0 to Distributions.Count - 1 do
        If TDistribution(Distributions.At(i)).UseForSens then Begin FoundSens := True; Break; End;
      If Not FoundSens then
        Begin
          MessageDlg('Model is set up to run in Sensitivity Mode, but no parameters have been selected for testing',
                     mterror,[mbok],0);
          Exit;
        End;

      // Create save dialog and set it options
      with SaveDialog1 do
      begin
         DefaultExt := 'xls' ;
         Filter := 'Excel files (*.xls*)|*.xls*|All files (*.*)|*.*' ;
         Options := [ofOverwritePrompt,ofPathMustExist,ofNoReadOnlyReturn,ofHideReadOnly] ;
         Title := 'Please Specify an Excel File into which to Save your Sensitivity Results:';
      end ;

      if not SaveDialog1.Execute then exit;

      If FileExists(SaveDialog1.FileName) then If Not DeleteFile(SaveDialog1.FileName)
         then Begin
                MessageDlg('Cannot gain exclusive access to the file to overwrite it.',mtError,[mbOK],0);
                Exit;
              End;

      AQTStudy.Unc_Dir  := ExtractFilePath(SaveDialog1.FileName);
      AQTStudy.Unc_File := ExtractFileName(SaveDialog1.FileName);
      AQTStudy.Unc_Ext  := '';

      AQTStudy.Sens_File := SaveDialog1.FileName;

      With AQTStudy.PUncertainty^ do
        Begin
          AdvancedSens   := FALSE;
          StartIteration := 1;
          Processors2Use := 2;
        End;

      CountNumTests;
      Result := True;
  end;
  {-----------------------------------------------------------------------}

Var RunSens, SensDone: Boolean;
    SensIter: Integer;
    NumIters: Integer;

  Procedure SetupSensRun;
  Begin
   With AQTStudy.PUncertainty^ do
    Begin
     Inc(SensIter);
     If AdvancedSens
       Then
         Begin
           SensDone := SensIter = Processors2Use;
           NumIters := (NumTests - StartIteration) div Processors2Use;

           StartIter := StartIteration + NumIters * (SensIter-1);
           If SensDone
              then EndIter := NumTests
              else EndIter := StartIteration + NumIters * (SensIter) - 1;
         End
       else
         Begin
           SensDone := True;
           StartIter := 1;
           EndIter := NumTests;
         End;
    End;
  End;  {SetupSensRun}

  Procedure Setup_Uncert_Sens;
  Begin
     RunStudy.RunIterations:=False;
     If RunStudy.PUncertainty^.Run_Uncertainty then
        begin
          If not Get_Uncertainty_File_Info(AQTStudy) then exit;
          RunStudy.Unc_Dir  := AQTStudy.Unc_Dir;
          RunStudy.Unc_File := AQTStudy.Unc_File;
          RunStudy.Unc_Ext  := AQTStudy.Unc_Ext;
          RunStudy.RunIterations:=True;
        end;

     If RunSens then
       Begin
         RunStudy.Sens_File := AQTStudy.Sens_File;
         If SensIter > 1 then
           Begin
             Delete(RunStudy.Sens_File,Length(RunStudy.Sens_File)-3,4);
             RunStudy.Sens_File :=  RunStudy.Sens_File + IntToStr(SensIter) + '.xls';
           End;
         RunStudy.RunIterations:=True;
         RunStudy.Control_Is_Running:=IsControl;
       End;

     With RunStudy.PUncertainty^ do If Run_Uncertainty or Run_Sensitivity
       Then With ThisProgress do
         Begin
           UncertPanel.Visible:=True;
           If Run_Uncertainty then UncertTitleLabel.Caption :='Latin Hypercube Uncertainty Analysis:'
                              else UncertTitleLabel.Caption :='Sensitivity Analysis in Progress:';
           ThisProgress.UncertStatusLabel.Caption:='Deterministic Simulation ';
         End;

  End;

Begin  {ExecuteSimulation}
   If not AQTStudy.Verify_Runnable(IsControl,True) then exit;

   RunSens := AQTStudy.PUncertainty^.Run_Sensitivity;
   If RunSens and Not ExecuteSensitivity then Exit;
   SensIter := 0;
   SensDone := False;

   Repeat
     With AQTStudy.PUncertainty^ do
     If Run_Sensitivity then
       SetupSensRun;

     With AQTStudy.SV do
      For i := 0 to Graphs.NumGraphs-1 do
        Begin
          Graphs.GArray[i].data.XMin := 0;
          Graphs.GArray[i].data.XMax := 0;
        End;

     WaitDlg.Setup('Please Wait, Preparing for Simulation Run');
     RunStudy := CopyTheStudy(False);
     WaitDlg.Hide;

     If RunStudy = nil then exit;
     RunStudy.Control_Is_Running:=IsControl;
     Update;

     ThisProgress := TProgressDialog.Create(ParentForm, AQTStudy, Self);
     Setup_Uncert_Sens;

     If IsControl then ProgStr := 'Control Run-- '
                  else ProgStr := 'Perturbed Run-- ';
     ProgStr := ProgStr + RunStudy.FileName;
     ThisProgress.Caption := ProgStr;
     RunStudy.SV.StudyProgDlg := ThisProgress;

     With ThisProgress do
       If RunStudy.PSetup^.ShowIntegration
         then ThisProgress.Height:=DebugHeight
         else ThisProgress.Height:=StandardHeight;

     ThisProgress.StepSizeLabel.Visible:=False;
     ThisProgress.ControlLabel.Visible := IsControl;

     ThisProgress.ModalResult:=0;
     ThisProgress.Gauge1.Progress:=0;
     ThisProgress.Show;
     ThisProgress.update;

     Inc(AQTStudy.SimsRunning);
     TSimulation.Create(RunStudy, AQTStudy, Show_Study_Info);

   Until (Not RunSens) or SensDone;


     For i := 0 to ListBox1.Items.Count-1 do
       ListBox1.Selected[i] := False;

     PostMessage(ListBox1.Handle, WM_LButtonUp, 0,0 );
     Application.ProcessMessages;

End;

Procedure TPrimaryInterface.DeleteButtonClick(Sender: TObject);
{Delete the selected State Variable from the List}

Var DeleteName, ErrorMsg              : ShortString;
    Loop,InnerLoop, SelectedIndex, ToxicRecIndex : Integer;
    InorganicDeleted : Boolean;
    PSV       : TStateVariable;
    DeleteVar : AllVariables;


       Procedure DeleteSedModelFrom(WorkingStudy: TAQUATOXSegment);
       Begin
         WorkingStudy.Remove_Sediment_Model;
         CHANGED_TRUE;
       End;

       Procedure DeleteTheVariableFrom(WorkingStudy: TAQUATOXSegment);
       {Deletes the variable identified by DeleteVar and all associated toxicants}
       Var ToxLoop   : T_SVType;
       Begin
         {Delete associated toxicant records if they exist,  Also Internal Nutrient records}
         For ToxLoop:=FirstToxTyp to PIntrnl do
          Begin
           ToxicRecIndex:=WorkingStudy.SV.GetIndex(DeleteVar,ToxLoop,WaterCol);
           If ToxicRecIndex>-1 then
               Begin
                  WorkingStudy.SV.AtFree(ToxicRecIndex);
                  WorkingStudy.SV.SetMemLocRec;
               End;
          End;

         PSV := WorkingStudy.SV.GetStatePointer(DeleteVar,StV,WaterCol);

         If PSV<>nil then
          With WorkingStudy.SV do
           Begin   {must zero out reciprocal same species record}
             If PSV.NState in [FirstAnimal..LastAnimal] then
               If TAnimal(PSV).PSameSpecies^<>NullStateVar then
                 TAnimal(GetStatePointer(TAnimal(PSV).PSameSpecies^,StV,WaterCol)).PSameSpecies^ := NullStateVar;

             AtFree(GetIndex(DeleteVar,StV,WaterCol));
           End;

         CHANGED_TRUE;
         WorkingStudy.SV.SetMemLocRec;

       End; {DeleteTheVariable}


begin
    SelectedIndex := ListBox1.SelCount;
    If SelectedIndex = 0 then
        Begin
           MessageDlg('No State Variable is Selected.',mterror,[mbOK],0);
           Exit;
        End;

    If AQTStudy.SV.LinkedMode then MessageDlg('Note: Any State Variable you delete will be deleted from all linked studies',
                                   mtinformation,[mbok],0);

    {Multiple Item Selection Loop}
    InorganicDeleted := False;
    For Loop:=0 to ListBox1.Items.Count-1 do
    If ListBox1.Selected[Loop] then
      Begin
        SelectedIndex:=Loop;

        {Get the Name of var to delete}
        DeleteName:=ListBox1.Items[SelectedIndex];
        {Get the Index of the StateVariable in the Collection}
        SelectedIndex:=AQTStudy.SV.GetIndexFromName(AbbrString(DeleteName,':'));
        If InorganicDeleted then if (DeleteName = 'Sand') or (DeleteName = 'Silt') or (DeleteName = 'Clay') then Continue;

        {Error Checking}
        If SelectedIndex=-1 then
          Begin
            MessageDlg('Aquatox Internal Error: Delete Item Missing Error',mterror,[mbOK],0);
            Exit;
          End;

        PSV:= AQTStudy.SV.at(SelectedIndex);
        DeleteVar := PSV.NState;

        ErrorMsg:='';

       If (DeleteVar in [Sand,Silt,Clay])
          then if InorganicDeleted then Continue {go to next iteration of for-do loop}
               else begin
                      DeleteName := 'All Inorganic Sediments (sand, silt, clay)';
                      InorganicDeleted:=True;
                    end;

       If (DeleteVar in [Cohesives,NonCohesives,NonCohesives2])
          then if InorganicDeleted then Continue {go to next iteration of for-do loop}
               else begin
                      DeleteName := 'the Inorganic Sediments Submodel (Cohesives, NonCohesives, Sed Layers)';
                      InorganicDeleted:=True;
                    end;

      {Cannot Delete Temperature}
      If DeleteVar = Temperature then
         ErrorMsg:='Temperature cannot be deleted, Use "Annual Mean" if no data exists.';
      {Cannot Delete Light}
      If DeleteVar=Light then
         ErrorMsg:='Light cannot be deleted, Use "Annual Mean" if no data exists.';
      {Cannot Delete Others}
      If (DeleteVar in [Ammonia,Oxygen,Nitrate,Phosphate,SedmRefrDetr..SedmLabDetr,
                        DissRefrDetr,CO2,Volume,pH]) then
         ErrorMsg:=DeleteName+' cannot be deleted from the current version of AQUATOX.';


      If (DeleteVar in [FirstOrgTox..LastOrgTox]) then
        Begin
          AQTStudy.Remove_OrgTox_SVs(DeleteVar);
          Continue;
        End;

      {Perform Error Message if it exists}
      IF ErrorMsg<>''
       THEN MessageDlg(ErrorMsg,mterror,[mbOK],0)
       ELSE {Deletable}

       {Verify}
       If MessageDlg('Delete "'+DeleteName+'"?',mtConfirmation,mbOKCancel,0)<>MrCancel then

       If (DeleteVar in [Cohesives..NonCohesives2])
         Then
           Begin
             If AQTStudy.SV.LinkedMode
               then
                 For InnerLoop:=-1 to AQTStudy.AllOtherSegs.Count-1 do
                   If InnerLoop=-1 then DeleteSedModelFrom(AQTStudy.TemplateSeg)
                                   else DeleteSedModelFrom(AQTStudy.AllOtherSegs.At(InnerLoop))
               else DeleteSedModelFrom(AQTStudy);
             AQTStudy.SV.Update_Distributions;
             Show_Study_Info;
             Exit;
           End
       Else If (DeleteVar in [Sand,Silt,Clay])
         Then RemoveSSC(False)
         Else  {Not Inorganic Sediments}
           If DeleteVar = Fish1
             Then
               If AQTStudy.SV.LinkedMode
                 then
                   For InnerLoop:=-1 to AQTStudy.AllOtherSegs.Count-1 do
                     If InnerLoop=-1 then For DeleteVar := Fish1 to Fish15 do
                                              DeleteTheVariableFrom(AQTStudy.TemplateSeg)
                                     else For DeleteVar := Fish1 to Fish15 do
                                              DeleteTheVariableFrom(AQTStudy.AllOtherSegs.At(InnerLoop))
                 else {not linked mode and fish1}
                   For DeleteVar := Fish1 to Fish15 do
                       DeleteTheVariableFrom(AQTStudy)
             Else {Not Fish1 or Inorg Sediments}
               If AQTStudy.SV.LinkedMode
                 then
                   For InnerLoop:=-1 to AQTStudy.AllOtherSegs.Count-1 do
                     If InnerLoop=-1 then DeleteTheVariableFrom(AQTStudy.TemplateSeg)
                                     else DeleteTheVariableFrom(AQTStudy.AllOtherSegs.At(InnerLoop))
                 else {not linked mode}
                   DeleteTheVariableFrom(AQTStudy);

  End; {FOR, IF, Multi item select}

  AQTStudy.SV.Update_Distributions;
  Show_Study_Info;

end; {Delete Button Handle}

Procedure TPrimaryInterface.BorrowParameters;

Var InputStudy: TAquatoxSegment;
    Err: String;
    OpenDialog: TAQTOpenDialog;
    CopyInitCond: Boolean;

Begin
   If MessageDlg('The new study you are loading must have exactly the same state variable list as the '+
                 'current study.',MtInformation,[MBOK, MBCancel],0) = MRCancel then exit;

    openDialog := TAQTOpenDialog.Create(self);
    openDialog.InitialDir := Studies_Dir;
    openDialog.Options := [ofFileMustExist, ofHideReadOnly, ofEnableSizing];
    openDialog.Filter := 'AQUATOX Studies (*.aps)|*.aps|All Files (*.*)|*.*';
    openDialog.FilterIndex := 1;
    If not openDialog.Execute then
      Begin
        OpenDialog.Free;
        Exit;
      End;

    WaitDlg.Setup('Please Wait One Moment, Loading New Segment');

    InputStudy := nil;
    Try  LoadFile(InputStudy,OpenDialog.FileName);  {Load the study as the template}

   CopyInitCond := MessageDlg('Copy Initial Conditions for Animals & Plants?',MtConfirmation,[MBYes, MBNo],0) = MRYes;

   AQTStudy.TakeParameters(InputStudy,Err,CopyInitCond);

   If Err<>'' then
      Begin
        MessageDlg('There is a difference between the study being loaded and the current study: '+
                    Err+' Parameter Copying Incomplete.',MTError,[MBOK],0);
        InputStudy := nil;
        WaitDlg.Hide;
        Exit;
      End;

    Except
      MessageDlg('Exception Raised while loading new segment',MTError,[MBOK],0);
      MessageDlg(Exception(ExceptObject).Message,mterror,[mbOK],0);
      WaitDlg.Hide;
      Exit;
    End;

    MessageDlg('Parameter Copying Procedure Completed.',MtInformation,[MBOK],0); 
    WaitDlg.Hide;
End;



Procedure TPrimaryInterface.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Handle Key Presses on List of Variables}
begin
   If Key=VK_DELETE then DeleteButtonClick(Sender);
   If Key=VK_INSERT then AddButtonClick(Sender);
   If Key=VK_RETURN then EditButtonClick(Sender);
end;

Procedure TPrimaryInterface.AddButtonClick(Sender: TObject);
{Handle the Add Button }
Var
   Loop,SelectedIndex: Integer;
   SelectedName:ShortString;
   SelectedState: StateVariables;
   InorganicAdded:Boolean;
   PSV: TStateVariable;
   LoadOK: Boolean;
   TrophDir: String;
               {----------------------------------------------------------------------------------}
               Procedure PerformSingleAdd(WorkingStudy: TAQUATOXSegment);
               Begin
                 If (SelectedState in [Cohesives,NonCohesives]) then
                   Begin
                     If not InorganicAdded then
                       Begin
                         InorganicAdded := True;
                         If WorkingStudy.SV.Diagenesis_Included
                           then MessageDlg('You cannot run the multi-layer model and the sediment diagenesis model at the same time.',mterror,[mbok],0)
                           else If MessageDlg('Add the Inorganic Sediments Submodel? (Cohesives, NonCohesives, Sed Layers)',mtconfirmation,[mbYes,mbNo],0)=mrYes
                             then WorkingStudy.Add_Sediment_Model;
                       End;
                   End
                 Else If (SelectedState in [Sand..Clay]) then
                   Begin
                     If not InorganicAdded then AddSSC(False);
                     InorganicAdded := True;
                   End
                 Else If SelectedState=Fish1 then
                   Begin
                     WorkingStudy.AddMultiAgeFish(false);
                   End
                 Else Begin
                        Application.CreateForm(TDb_GetEntry, Db_GetEntry);
                        LoadOK := False;
                        If SelectedState in [FirstAnimal..LastAnimal] then
                          With Db_GetEntry do
                            Begin
                              HeadString:='Select Animal Entry to Load into '+StateText(SelectedState,StV,WaterCol)+':';
                              Filter:='Animal DBs (*.adb)|*.ADB|';
                              DefaultDbName:='Animal.ADB';
                              If GetEntry Then
                                Begin
                                  WorkingStudy.AddStateVariable(SelectedState,WaterCol,0,True);
                                  PSV := WorkingStudy.SV.GetStatePointer(SelectedState,StV,WaterCol);
                                  LoadOK := DBase_To_AnimalRecord(FileDir,FileName,Entry,-1,TAnimal(PSV).PAnimalData^);
                                  PSV.PHasData^ := LoadOK;
                                  If LoadOK then
                                    Begin
                                      PSV.PName^ := PSV.PName^+':['+TAnimal(PSV).PAnimalData^.AnimalName+']';
                                      If DirectoryExists(FileDir+'\Trophint')
                                        then TrophDir := FileDir+'\Trophint\'
                                        else TrophDir := FileDir+'\';
                                      If Not TAnimal(PSV).ReadTrophInt(TrophDir+TAnimal(PSV).PAnimalData^.AnimalName+'.int') then
                                         MessageDlg('Warning, cannot read trophic interaction file.  Trophic interactions are set to zero.',mtwarning,[mbok],0);
                                    End;
                                End;
                            End;

                        If SelectedState in [FirstPlant..LastPlant] then
                          With Db_GetEntry do
                            Begin
                              HeadString:='Select Plant Entry to Load into '+StateText(SelectedState,StV,WaterCol)+':';
                              Filter:='Plant DBs (*.pdb)|*.PDB|';
                              DefaultDbName:='Plant.PDB';
                              If GetEntry Then
                                Begin
                                   WorkingStudy.AddStateVariable(SelectedState,WaterCol,0,True);
                                   PSV := WorkingStudy.SV.GetStatePointer(SelectedState,StV,WaterCol);
                                   LoadOK := DBase_To_PlantRecord(FileDir,FileName,Entry,-1,TPlant(PSV).PAlgalRec^);
                                   PSV.PHasData^ := LoadOK;
                                   If LoadOK then PSV.PName^ := PSV.PName^+':['+TPlant(PSV).PAlgalRec^.PlantName+']';
                                End;
                            End;

                        DB_GetEntry.Free;
                      End; {Add Var}

                 If SelectedState in [Salinity,TSS,BuriedRefrDetr,BuriedLabileDetr] then WorkingStudy.AddStateVariable(SelectedState,WaterCol,0,True);

                 CHANGED_TRUE;
                 WorkingStudy.SV.SetMemLocRec;
                 {Associated toxic state is automatically added also, if appropriate}
               End;
               {----------------------------------------------------------------------------------}
               Procedure PerformLinkedAdd;
               Var WorkingStudy: TAQUATOXSegment;
                   IsTempl: Boolean;
                     {----------------------------------------------------------------------------------}
                     Procedure AddTheVars;
                     Var i: Integer;
                     Begin
                       For i := -1 to AQTStudy.AllOtherSegs.Count-1 do
                        Begin
                          IsTempl := (i=-1);
                          If IsTempl then WorkingStudy := AQTStudy.TemplateSeg
                                     else WorkingStudy := AQTStudy.AllOtherSegs.At(i);

                          WorkingStudy.AddStateVariable(SelectedState,WaterCol,0,IsTempl);
                          WorkingStudy.SV.SetMemLocRec;
                          PSV := AQTStudy.TemplateSeg.SV.GetStatePointer(SelectedState,StV,WaterCol);
                        End;
                     End;
                     {----------------------------------------------------------------------------------}
               Var i: Integer;
               Begin
                 If (SelectedState in [Cohesives,NonCohesives]) then
                   Begin
                     If not InorganicAdded then
                       Begin
                         InorganicAdded := True;
                         If AQTStudy.TemplateSeg.SV.Diagenesis_Included
                           then MessageDlg('You cannot run the multi-layer model and the sediment diagenesis model at the same time.',mterror,[mbok],0)
                           else If MessageDlg('Add the Multi-Layer Sediments Submodel? (Cohesives, NonCohesives, Sed Layers)',mtconfirmation,[mbYes,mbNo],0)=mrYes
                             Then
                              For i := -1 to AQTStudy.AllOtherSegs.Count-1 do
                               Begin
                                 IsTempl := (i=-1);
                                 If IsTempl then WorkingStudy := AQTStudy.TemplateSeg
                                            else WorkingStudy := AQTStudy.AllOtherSegs.At(i);
                                 WorkingStudy.Add_Sediment_Model;
                               End;
                       End;
                   End
                 Else If (SelectedState in [Sand..Clay]) then
                   Begin
                     If not InorganicAdded then AddSSC(False);
                     InorganicAdded := True;
                   End
                 Else If SelectedState=Fish1 then AQTStudy.AddMultiAgeFish(false)
                 Else Begin
                        LoadOK := False;
                        Application.CreateForm(TDb_GetEntry, Db_GetEntry);
                        If SelectedState in [FirstAnimal..LastAnimal] then
                          With Db_GetEntry do
                            Begin
                              HeadString:='Select Animal Entry to Load into '+StateText(SelectedState,StV,WaterCol)+':';
                              Filter:='Animal DBs (*.adb)|*.ADB|';
                              DefaultDbName:='Animal.ADB';
                              If GetEntry Then
                                Begin
                                  AddTheVars;
                                  LoadOK := DBase_To_AnimalRecord(FileDir,FileName,Entry,-1,TAnimal(PSV).PAnimalData^);
                                  PSV.PHasData^ := LoadOK;
                                  If LoadOK then
                                    Begin
                                      PSV.PName^ := PSV.PName^+':['+TAnimal(PSV).PAnimalData^.AnimalName+']';
                                      If DirectoryExists(FileDir+'\Trophint')
                                        then TrophDir := FileDir+'\Trophint\'
                                        else TrophDir := FileDir+'\';
                                      If Not TAnimal(PSV).ReadTrophInt(TrophDir+TAnimal(PSV).PAnimalData^.AnimalName+'.int') then
                                         MessageDlg('Warning, cannot read trophic interaction file.  Trophic interactions are set to zero.',mtwarning,[mbok],0);
                                    End;
                                End; {if getentry}
                            End;

                        If SelectedState in [FirstPlant..LastPlant] then
                          With Db_GetEntry do
                            Begin
                              HeadString:='Select Plant Entry to Load into '+StateText(SelectedState,StV,WaterCol)+':';
                              Filter:='Plant DBs (*.pdb)|*.PDB|';
                              DefaultDbName:='Plant.PDB';
                              If GetEntry Then
                                Begin
                                  AddTheVars;
                                  LoadOK := DBase_To_PlantRecord(FileDir,FileName,Entry,-1,TPlant(PSV).PAlgalRec^);
                                  PSV.PHasData^ := LoadOK;
                                  If LoadOK then PSV.PName^ := PSV.PName^+':['+TPlant(PSV).PAlgalRec^.PlantName+']';
                                End;
                            End;
                      End; {Add Var}

                 If SelectedState in [Salinity,TSS,BuriedRefrDetr,BuriedLabileDetr] then AddTheVars;

                 DB_GetEntry.Free;
                 CHANGED_TRUE;
                 {Associated toxic state is automatically added also, if appropriate}
               End;
               {----------------------------------------------------------------------------------}


begin
  Application.CreateForm(TInsertStateDialog, InsertStateDialog);

  If AQTStudy.SV.LinkedMode then MessageDlg('Note: Any State Variable you add will be added to all linked segments',
                                 mtinformation,[mbok],0);

  {Add the insertable states to the Insert Dialog Box}
  InsertStateDialog.ListBox1.Clear;
  AQTStudy.GetAllInsertableStates(InsertStateDialog.ListBox1.Items);

  {Show the dialog box, if user selects cancel then exit Procedure}
  If InsertStateDialog.ShowModal=mrCancel then
     Begin
       InsertStateDialog.Free;
       exit;
     End;

  {Get the Index, if nothing selected, then tell user, exit Procedure}
  SelectedIndex := InSertStateDialog.ListBox1.SelCount;
  If SelectedIndex = 0 then
      Begin
           MessageDlg('No State Variable is Selected.',mterror,[mbOK],0);
           InsertStateDialog.Free;
           Exit;
      End;

  {Multiple Item Selection Loop}
  InorganicAdded := False;
  For Loop:=0 to InSertStateDialog.ListBox1.Items.Count-1 do
  If InsertStateDialog.ListBox1.Selected[Loop] then
     Begin
       SelectedIndex:=Loop;
       {Get the actual text selected;}
       SelectedName:=InsertStateDialog.ListBox1.Items[SelectedIndex];

       {Find the associated StateVariable, if not found, raise error}
       If Not GetStateFromName(AbbrString(SelectedName,':'),SelectedState) then
          Begin
               MessageDlg('Aquatox Internal Error: Insert Item Missing Error',mterror,[mbOK],0);
               InsertStateDialog.Free;
               Exit;
          End;

       {Insert the state}
       If SelectedState in [FirstOrgTox..LastOrgTox] then
         AQTStudy.Add_OrgTox_SVs(SelectedState,'')
       Else
         If Not AQTStudy.SV.LinkedMode
           then PerformSingleAdd(AQTStudy)
           else PerformLinkedAdd;

     End; {FOR, IF (Multiple Selection)}

  InsertStateDialog.Free;
  AQTStudy.SV.Update_Distributions;

  {Update Screen}
  Show_Study_Info;
end;

Procedure TPrimaryInterface.EditButtonClick(Sender: TObject);
{Handle the Edit Button }
Var EditName: ShortString;
    Loop, SelectedIndex: Integer;
    SelectedState: AllVariables;

begin
  SelectedIndex := ListBox1.SelCount;
  If SelectedIndex = 0 then
      Begin
         MessageDlg('No State Variable is Selected.',mterror,[mbOK],0);
         Exit;
      End;

  {Multiple Item Selection Loop}
  For Loop:=0 to ListBox1.Items.Count-1 do
  If ListBox1.Selected[Loop] then
    Begin
      SelectedIndex:=Loop;

      {Get the Name of var to edit}
      EditName:=ListBox1.Items[SelectedIndex];

      {Get the Index of the StateVariable in the Collection}
      SelectedIndex:=AQTStudy.SV.GetIndexFromName(AbbrString(EditName,':'));
      SelectedState := TStateVariable(AQTStudy.SV.At(SelectedIndex)).NState;

      {Error Checking}
      If SelectedIndex=-1 then
         Begin
            MessageDlg('Aquatox Internal Error: Edit Item Missing Error',mterror,[mbOK],0);
            Exit;
         End;

{      If (SelectedState=Volume) and (AQTStudy.SV.Location.SiteType = TribInput) then
        Begin
          MessageDlg('This is a "Tributary Input" segment meaning that the water volume screen has '+
                     'no relevance.  Input concentrations of nutrients, organic matter, and/or chl-a '+
                     'in this segment and then use a cascade link to link this "tributary" segment '+
                     'to the main system.',mtinformation,[mbok],0);
          Continue;
        End; }

      If SelectedState=Fish1 then Begin
                                    Application.CreateForm(TMultFishForm, MultFishForm);
                                    If MultFishForm.EditFish(AQTStudy.SV.At(SelectedIndex),AQTStudy.SV.PMultiRec^,LinkedPS,AQTStudy)
                                       then CHANGED_TRUE;
                                    MultFishForm.Free;
                                  End
                             else Begin
                                    Application.CreateForm(TStateVarDialog, StateVarDialog);
                                    StateVarDialog.EditSV (AQTStudy.SV.at(SelectedIndex),LinkedPS,AQTStudy);
                                    If StateVarDialog.Changed then CHANGED_TRUE;
                                    StateVarDialog.Free;
                                  End;

    End; {Multiple Item Loop}

 AQTStudy.Adjust_Internal_Nutrients;  // in case plant types have changed
 Show_Study_Info;

end;  {Edit Button Click Handle}                                 

Procedure TPrimaryInterface.ChemicalButtonClick(Sender: TObject);
Var NumToxs   : Integer;
    ToxLoop,ToxFound  : AllVariables;
    EntryStr  : String;
    SelTox    : Array[0..10] of AllVariables;
Begin
 NumToxs := 0;
 ToxFound := FirstOrgTox;

 For ToxLoop := FirstOrgTox to LastOrgTox do
   Begin
     If AQTStudy.SV.GetIndex(ToxLoop,StV,WaterCol) > -1 then
       Begin
         Inc(NumToxs);
         ToxFound := ToxLoop
       End;
   End;

 If NumToxs = 0 then begin
                       MessageDlg('There is no Organic Toxicant in the current study.',mtInformation,[mbOK],0);
                       Exit;
                     end;

 Application.CreateForm(TChangeVarForm, ChangeVarForm);
 If NumToxs > 1 then
   Begin
     ChangeVarForm.Caption := 'Select a Variable to View';
     ChangeVarForm.EntryList.Items.Clear;
     NumToxs := 0;
     For ToxLoop := FirstOrgTox to LastOrgTox do
       Begin
         If AQTStudy.SV.GetIndex(ToxLoop,StV,WaterCol) > -1 then
           Begin
             SelTox[NumToxs] := ToxLoop;
             Inc(NumToxs);
             EntryStr := TStateVariable(AQTStudy.SV.GetStatePointer(ToxLoop,StV,WaterCol)).PName^;
             ChangeVarForm.EntryList.Items.Add(EntryStr);
           End;
       End;
     ChangeVarForm.EntryList.ItemIndex:=0;
     If ChangeVarForm.ShowModal = MrCancel then
        Begin
          ChangeVarForm.Free;
          Exit;
        End;
     ToxFound := SelTox[ChangeVarForm.EntryList.ItemIndex];
     ChangeVarForm.Free;
   End;

 Application.CreateForm(TStateVarDialog, StateVarDialog);
 Try
 StateVarDialog.EditSV(AQTStudy.SV.GetStatePointer(ToxFound,StV,WaterCol),LinkedPS,AQTStudy);

 If StateVarDialog.Changed then CHANGED_TRUE;
 Finally
   StateVarDialog.Free;
 End;

 Show_Study_Info;
End;

Procedure TPrimaryInterface.SiteBitBtnClick(Sender: TObject);

begin
  Application.CreateForm(TSiteDialog, SiteDialog);
  SiteDialog.LinkedMode := AQTStudy.SV.LinkedMode;
  SiteDialog.EditSite(AQTStudy);
  If SiteDialog.Changed then CHANGED_TRUE;
  SiteDialog.Free;
  Show_Study_info;
end;

Procedure TPrimaryInterface.SetupBitBtnClick(Sender: TObject);
Var Loop2: T_SVType;
    Int_Nut: Boolean;
begin

  CreateSetupForms;

  If AQTStudy.SV.LinkedMode then ResultsForm.NumSegs := PNumSegs^;
  ResultsForm.SV:=AQTStudy.SV;

  If not AQTStudy.SV.LinkedMode
    then USetupForm.PassVars(AQTStudy.PUncertainty,AQTStudy.SV,AQTStudy,nil,false)
    else with TLinkedSegs(LinkedPS) do
           USetupForm.PassVars(TemplateSeg.PUncertainty,TemplateSeg.SV,TemplateSeg,TLinkedSegs(LinkedPS),True);

  AQTStudy.SV.Update_Distributions;
  Int_Nut := AQTStudy.PSetup^.Internal_Nutrients;

  With AQTStudy do
     StudySetupDialog.EditSetup(PSetup^,SV.PRateInfo^, SV, SV.PControlInfo^,SV.LinkedMode, SV.NumOrgToxicants>0);

  With AQTStudy.PSetup^ do
  If (Int_Nut <> Internal_Nutrients) then
   If AQTStudy.SV.LinkedMode
    then Begin If Internal_Nutrients then TLinkedSegs(LinkedPS).Add_Internal_Nutrients
                                     else TLinkedSegs(LinkedPS).Remove_Internal_Nutrients
         End
    else Begin If Internal_Nutrients then AQTStudy.Add_Internal_Nutrients
                                     else AQTStudy.Remove_Internal_Nutrients;
         End;

  If StudySetupDialog.Changed or
     USetupForm.Changed or
     DistributionForm.Changed
     then CHANGED_TRUE;

  With AQTStudy do
   If PSetup^.UseExternalConcs then
    For Loop2:=FirstOrgTxTyp to LastOrgTxTyp do
     If PChems^[Loop2] <> nil then
      If SV.GetStatePointer(AssocToxSV(Loop2),StV, WaterCol) <> nil then
       If PChems^[Loop2].ChemRec.WeibullSlopeFactor <= 0 then
        begin
          MessageDlg2('External Weibull Slope Factor is set to zero for Chemical '+PChems^[Loop2].ChemRec.ChemName+'.  Model will not run.',mterror,[mbOK],0);
          Break;
        end;

  If AQTStudy.PSetup^.ModelTSDays and not AQTStudy.PSetup^.StepSizeInDays then
     MessageDlg2('Warning, your native model time-step days and your data-storage time-step unit is hours.',mtwarning,[mbOK],0);
  If not AQTStudy.PSetup^.ModelTSDays and AQTStudy.PSetup^.StepSizeInDays then
     MessageDlg2('Warning, your native model time-step is hours and your data-storage time-step unit is days.',mtwarning,[mbOK],0);

  DestroySetupForms;
  Show_Study_Info;
end;

Procedure TPrimaryInterface.OutputBitBtnClick(Sender: TObject);

Var OSt: TAQUATOXSegment;

begin
  WaitDlg.Setup('Please Wait, Creating Output Screen');

  OSt := CopyTheStudy(True);
  OST.Unc_Dir  := AQTStudy.Unc_Dir;
  OST.Unc_File := AQTStudy.Unc_File;
  OST.Unc_Ext  := AQTStudy.Unc_Ext;
  OST.SV.LinkedMode := AQTStudy.SV.LinkedMode;
  OST.Segnumber := AQTStudy.SegNumber;

  If OSt=nil then
     Begin
       WaitDlg.Hide;
       exit;
     End;

  AQTStudy.SV.PSegID := @AQTStudy.SegNumber;
  TOutputScreen.Create(Parent,OSt,AQTStudy,nil,LinkedPS);

end;


Procedure TPrimaryInterface.GraphsToWord;
Var OS: TOutputScreen;
    Cntrl: Boolean;
Begin
  Cntrl := AQTStudy.ControlRun <> -1;
  If (AQTStudy.ControlRun <> -1) and
     (AQTStudy.LastRun <> -1) then
    Cntrl :=  MessageDlg('Export Control Graphs (as opposed to Perturbed)?',
                mtconfirmation,[mbyes,mbno],0) = mryes;

  AQTStudy.SV.PSegID := @AQTStudy.SegNumber;
  OS := TOutputScreen.Create(Parent,AQTStudy,AQTStudy,nil,nil);
  OS.ExportGraphsToWord(Cntrl);
  OS.Free;
  WordInitialized := False;
End;


Procedure TPrimaryInterface.Save1Click(Sender: TObject);
Var SaveDialog: TSaveDialog;
begin
  SaveSuccess:=false;

  saveDialog := TSaveDialog.Create(nil);            
  saveDialog.Title := 'Save your simulation As';
  saveDialog.InitialDir := AQTStudy.DirName;
  saveDialog.Filter := 'AQUATOX Studies (*.aps)|*.aps|All Files (*.*)|*.*';
  saveDialog.Options := [ofOverwritePrompt,ofPathMustExist,ofNoReadOnlyReturn,ofHideReadOnly, ofEnableSizing] ;
  saveDialog.DefaultExt := 'aps';
  saveDialog.FilterIndex := 1;

  With AQTStudy do
    If FileName='AQUATOX1.APS' then
      Begin
        If not SaveDialog.Execute then
                 Begin
                   savedialog.Free;
                   Exit;
                 End;
        AQTStudy.FileName := ExtractFileName(SaveDialog.FileName);
        AQTStudy.DirName := ExtractFilePath(SaveDialog.FileName);
      End;

  WaitDlg.Setup('Please Wait One Moment, Saving File');
  Enabled:=False;
  Try
    AQTStudy.SV.StoreResults := True;
    AQTStudy.SV.StoreDistribs := True;
    SaveFile(AQTStudy);

  Show_Study_Info;

  With AQTStudy do
    ParentForm.UpdateRecentlyUsed(AQTStudy,DirName,FileName);

  SaveSuccess:=true;

  Except
    WaitDlg.Hide;
    Show_Study_Info;
    SaveDialog.Free;

    Raise;
  End;
  SaveDialog.Free;

end;

Procedure TPrimaryInterface.SaveAs1Click(Sender: TObject);
Var SaveDialog: TSaveDialog;
begin
  SaveSuccess:=false;

  saveDialog := TSaveDialog.Create(nil);
  saveDialog.Title := 'Save your simulation As';
  saveDialog.InitialDir := AQTStudy.DirName;
  saveDialog.Filter := 'AQUATOX Studies (*.aps)|*.aps|All Files (*.*)|*.*';
  saveDialog.Options := [ofOverwritePrompt,ofPathMustExist,ofNoReadOnlyReturn,ofHideReadOnly, ofEnableSizing] ;
  saveDialog.DefaultExt := 'aps';
  saveDialog.FilterIndex := 1;
  SaveDialog.FileName := AQTStudy.DirName + AQTStudy.FileName;

  If AQTStudy.SV.LinkedMode then
    Begin
      If MessageDlg('You are selecting to save this segment as a stand-alone single-segment AQUATOX study.',
                          mtconfirmation,[mbok,mbcancel],0) = mrcancel then
            Begin
              SaveDialog.Free;
              Exit;
            End;
      SaveDialog.FileName := AQTStudy.DirName + AQTStudy.StudyName+'.aps';
    End;

  If not SaveDialog.Execute then
                 Begin
                   savedialog.Free;
                   Exit;
                 End;

  AQTStudy.FileName := ExtractFileName(SaveDialog.FileName);
  AQTStudy.DirName := ExtractFilePath(SaveDialog.FileName);

  WaitDlg.Setup('Please Wait One Moment, Saving File');
  Enabled:=False;

  Try
    AQTStudy.SV.StoreResults := True;
    AQTStudy.SV.StoreDistribs := True;
    SaveFile(AQTStudy);
    With AQTStudy do
      ParentForm.UpdateRecentlyUsed(AQTStudy,DirName,FileName);

  Except
    WaitDlg.Hide;
    Show_Study_Info;
    SaveDialog.Free;

    Raise;
  End;

  SaveDialog.Free;
  Show_Study_Info;
end;

Procedure TPrimaryInterface.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  ParentForm.UpdateMenu(nil);
end;

Procedure TPrimaryInterface.PrintSetup1Click(Sender: TObject);
begin
   PrinterSetupDialog1.Execute;
end;

Procedure TPrimaryInterface.ExportResults1Click(Sender: TObject);
{Call Export in Output.Inc}
begin
  If (AQTStudy.SV.Results[Epilimnion].Count<=0) then
          begin
            MessageDlg('There Are No Results To Export.',mtError,[mbok],0);
            Exit;
          end;

   ExportResults1(SaveDialog1,False,ExportTable,AQTStudy,'');
end;

Procedure TPrimaryInterface.ExportControlResults1Click(Sender: TObject);
{Call Export in Output.Inc, For the Control Results}

Begin
  If (AQTStudy.SV.ControlResults[Epilimnion].Count<=0) then
      begin
        MessageDlg('There Are No Results To Export.',mtError,[mbok],0);
        Exit;
      end;

  ExportResults1(SaveDialog1,True,ExportTable,AQTStudy,'');
End;

Procedure TPrimaryInterface.ControlButtClick(Sender: TObject);
Begin
  ExecuteSimulation(True);
End;

Procedure TPrimaryInterface.ListBox1DblClick(Sender: TObject);
{If double clicked, edit the state variable}
begin
  EditButtonClick(Sender);
end;

Procedure TPrimaryInterface.InitCondButtonClick(Sender: TObject);
Begin
   Application.CreateForm(TInitCondForm, InitCondForm);
   InitCondForm.Caption := AQTStudy.Filename + ' Initial Conditions';
   If AQTStudy.SV.LinkedMode then
      InitCondForm.Caption :=  'Segment '+AQTStudy.SegNumber + ': '+AQTStudy.Studyname + ' Initial Conditions';
   InitCondForm.Show_Init_Conds(AQTStudy.SV,AQTStudy.Dirname+AQTStudy.FileName);
   InitCondForm.Free;
End;



Procedure TPrimaryInterface.DebugButton1Click(Sender: TObject);

     Procedure DisplaySV(P: TStateVariable);
     Begin
        ListBox1.Items.Add(OutputText(P.NState,P.SVType,P.Layer,'',False,False,0));
     End;
var i: Integer;
begin
  ListBox1.Clear;
  with AQTStudy.SV do for i:=0 to count-1 do
     DisplaySV(at(i));
end;



Procedure TPrimaryInterface.Uncertainty1Click(Sender: TObject);
begin
  CreateSetupForms;
  AQTStudy.SV.Update_Distributions;

  If not AQTStudy.SV.LinkedMode
    then USetupForm.PassVars(AQTStudy.PUncertainty,AQTStudy.SV,AQTStudy,nil,false)
    else with TLinkedSegs(LinkedPS) do
           USetupForm.PassVars(TemplateSeg.PUncertainty,TemplateSeg.SV,TemplateSeg,TLinkedSegs(LinkedPS),True);

  DistributionForm.Changed:=False;
  USetupForm.Edit_USetup;

  If USetupForm.Changed or USetupForm.DistChanged
     then CHANGED_TRUE;
  DestroySetupForms;
  Show_Study_Info;
end;





procedure TPrimaryInterface.ControlRunSetup1Click(Sender: TObject);
begin
  CreateSetupForms;
  ControlForm.Edit_Control(AQTStudy.SV.PControlInfo^, AQTStudy.SV);
  If ControlForm.Changed then CHANGED_TRUE;
  DestroySetupForms;
end;

procedure TPrimaryInterface.ClearResults1Click(Sender: TObject);
Var loop: VerticalSegments;
    ClearMode: Integer;
Begin
   Application.CreateForm(TClearResForm,ClearResForm);
   If ClearResForm.ShowModal = MRCancel then Exit;

   ClearMode := 0;
   If ClearResForm.ClearCtrl.Checked then ClearMode := 1;
   If ClearResForm.ClearPert.Checked then ClearMode := 2;
   ClearResForm.Free;

   For Loop:=Epilimnion to Hypolimnion do
     Begin
       If (ClearMode = 0) or (ClearMode = 2) then
         Begin
           AQTStudy.SV.Results[loop].Destroy;
           AQTStudy.SV.Results[loop] := TResultsCollection.Init;
           AQTStudy.LastRun      := -1;
         End;

       If (ClearMode < 2) then
         Begin
           AQTStudy.SV.ControlResults[loop].Destroy;
           AQTStudy.SV.ControlResults[loop] := TResultsCollection.Init;
           AQTStudy.ControlRun   := -1;
         End;
     End;

   Show_Study_Info;
end;


procedure TPrimaryInterface.MultiSegReturnClick(Sender: TObject);
begin
  Close;
end;

procedure TPrimaryInterface.StratButtonClick(Sender: TObject);
begin
  Application.CreateForm(TStratdialog, StratDialog);
  StratDialog.EditStrat(AQTStudy.SV.IsStrat,AQTStudy.SV.IsEpilimnion);
  StratDialog.Free;
end;

procedure TPrimaryInterface.ThickButtonClick(Sender: TObject);
begin
  Application.CreateForm(TMorphDlg, MorphDlg);
  With AQTStudy.SV do
       MorphDlg.MorphEdit(AutoCalcXSec,XSecData);      {Cross Section}
  MorphDlg.Free
end;

procedure TPrimaryInterface.TrophIntButtonClick(Sender: TObject);
begin
  EditTrophInt;  {3/20/2012}
end;

procedure TPrimaryInterface.AddSedimentModel1Click(Sender: TObject);
Var i: Integer;
    IsTempl: Boolean;
    WorkingStudy: TAQUATOXSegment;
begin
  If (MessageDlg('Add the Inorganic Sediments Submodel? (Cohesives, NonCohesives, Sed Layers)',
                  MTConfirmation, [MbYes,MbCancel], 0) = MrCancel) then exit;

  If Not AQTStudy.SV.LinkedMode
    then AQTStudy.Add_Sediment_Model
    else
      For i := -1 to AQTStudy.AllOtherSegs.Count-1 do
       Begin
         IsTempl := (i=-1);
         If IsTempl then WorkingStudy := AQTStudy.TemplateSeg
                    else WorkingStudy := AQTStudy.AllOtherSegs.At(i);
         WorkingStudy.Add_Sediment_Model;
       End;

   AQTStudy.SV.Update_Distributions;
   Show_Study_Info;    {Update Screen}
end;

Procedure TPrimaryInterface.AddSSC(update:Boolean);
Var i, top: Integer;
    isTempl: Boolean;
    WorkingStudy: TAQUATOXSegment;
Begin
   If AQTStudy.Location.SiteType <> Stream
     Then MessageDlg('Inorganic Sediments (Sand, Silt, and Clay) are only relevant to streams.  Use TSS instead.',mtinformation,[mbOK],0)
     Else If AQTStudy.SV.Diagenesis_Included then MessageDlg('You cannot run the sand-silt-clay and the sediment diagenesis model at the same time.',mterror,[mbok],0)
      Else
       Begin
         If MessageDlg('Add all inorganic sediments? (sand, silt, clay)',mtconfirmation,[mbYes,mbNo],0)=mrNo then exit;

         If AQTStudy.SV.LinkedMode then top := AQTStudy.AllOtherSegs.Count-1
                                   else top := -1;
         For i := -1 to top do
           Begin
             IsTempl := (i=-1);
             If AQTStudy.SV.LinkedMode
               then
                 Begin
                   If IsTempl then WorkingStudy := AQTStudy.TemplateSeg
                              else WorkingStudy := AQTStudy.AllOtherSegs.At(i);
                 End
               else WorkingStudy := AQTStudy;

             WorkingStudy.AddStateVariable(Sand,WaterCol,0,IsTempl);
             WorkingStudy.AddStateVariable(Silt,WaterCol,0,IsTempl);
             WorkingStudy.AddStateVariable(Clay,WaterCol,0,IsTempl);
             WorkingStudy.SV.SetMemLocRec;
           End;

          Changed_True;
          If Update then Show_Study_Info;
       End;
End;


Procedure TPrimaryInterface.RemoveSSC(update:Boolean);

       Procedure DeleteSandSiltClayFrom(WorkingStudy: TAQUATOXSegment);
       Begin
         With WorkingStudy.SV do
           Begin
             AtFree(GetIndex(sand,StV,WaterCol)); SetMemLocRec;
             AtFree(GetIndex(silt,StV,WaterCol)); SetMemLocRec;
             AtFree(GetIndex(clay,StV,WaterCol)); SetMemLocRec;
             CHANGED_TRUE;
           End;
       End;

Var InnerLoop: Integer;
Begin
   If Update then if MessageDlg('Remove all inorganic sediments? (sand, silt, clay)',mtconfirmation,[mbYes,mbNo],0)=mrNo then exit;

   If AQTStudy.SV.LinkedMode
     then
       For InnerLoop:=-1 to AQTStudy.AllOtherSegs.Count-1 do
         If InnerLoop=-1 then DeleteSandSiltClayFrom(AQTStudy.TemplateSeg)
                    else DeleteSandSiltClayFrom(AQTStudy.AllOtherSegs.At(InnerLoop))
     else DeleteSandSiltClayFrom(AQTStudy);

    Changed_True;

    If Update then Show_Study_Info;

End;


Procedure TPrimaryInterface.AddDiagenesis;
Var i: Integer;
    IsTempl: Boolean;
    WorkingStudy: TAQUATOXSegment;
begin
  If (MessageDlg('Add the Diagenesis Submodel? (Based on DiToro, 2001)',
                  MTConfirmation, [MbYes,MbCancel], 0) = MrCancel) then exit;

  If Not AQTStudy.SV.LinkedMode
    then AQTStudy.Add_Diagenesis_Model
    else
      For i := -1 to AQTStudy.AllOtherSegs.Count-1 do
       Begin
         IsTempl := (i=-1);
         If IsTempl then WorkingStudy := AQTStudy.TemplateSeg
                    else WorkingStudy := AQTStudy.AllOtherSegs.At(i);
         WorkingStudy.Add_Diagenesis_Model;
       End;

   AQTStudy.SV.Update_Distributions;
   Show_Study_Info;    {Update Screen}
end;

Procedure TPrimaryInterface.RemoveDiagenesis;
Var i: Integer;
    IsTempl: Boolean;
    WorkingStudy: TAQUATOXSegment;
begin
  If (MessageDlg('Remove the Diagenesis Submodel?',
                  MTConfirmation, [MbYes,MbCancel], 0) = MrCancel) then exit;

  If Not AQTStudy.SV.LinkedMode
    then AQTStudy.Remove_Diagenesis_Model
    else
      For i := -1 to AQTStudy.AllOtherSegs.Count-1 do
       Begin
         IsTempl := (i=-1);
         If IsTempl then WorkingStudy := AQTStudy.TemplateSeg
                    else WorkingStudy := AQTStudy.AllOtherSegs.At(i);
         WorkingStudy.Remove_Diagenesis_Model;
       End;

   AQTStudy.SV.Update_Distributions;
   Show_Study_Info;    {Update Screen}
end;



procedure TPrimaryInterface.RemoveSedimentModel1Click(Sender: TObject);
Var i: Integer;
    IsTempl: Boolean;
    WorkingStudy: TAQUATOXSegment;
begin
  If (MessageDlg('Remove the Inorganic Sediments Submodel? (Cohesives, NonCohesives, Sed Layers)',
                  MTConfirmation, [MbYes,MbCancel], 0) = MrCancel) then exit;

  If Not AQTStudy.SV.LinkedMode
    then AQTStudy.Remove_Sediment_Model
    else
      For i := -1 to AQTStudy.AllOtherSegs.Count-1 do
       Begin
         IsTempl := (i=-1);
         If IsTempl then WorkingStudy := AQTStudy.TemplateSeg
                    else WorkingStudy := AQTStudy.AllOtherSegs.At(i);
         WorkingStudy.Remove_Sediment_Model;
       End;

   AQTStudy.SV.Update_Distributions;
   Show_Study_Info;    {Update Screen}
end;

Procedure TPrimaryInterface.AddBuriedSedLayer1Click(Sender: TObject);
Var i: Integer;
    IsTempl: Boolean;
    WorkingStudy: TAQUATOXSegment;
Begin
  If AQTStudy.SV.SedLayers >= Num_SVLayers
    Then Begin
           MessageDlg('This version of AQUATOX, cannot exceed '+IntToStr(Num_SVLayers)+' sediment layers.',
                       MTInformation, [MBOK],0);
           Exit;
         End;

  If (MessageDlg('Add a buried sediment layer? (below existing layers)',
                  MTConfirmation, [MbYes,MbCancel], 0) = MrCancel) then exit;

  If Not AQTStudy.SV.LinkedMode
    then AQTStudy.Add_Sediment_Layer
    else
      For i := -1 to AQTStudy.AllOtherSegs.Count-1 do
       Begin
         IsTempl := (i=-1);
         If IsTempl then WorkingStudy := AQTStudy.TemplateSeg
                    else WorkingStudy := AQTStudy.AllOtherSegs.At(i);
         WorkingStudy.Add_Sediment_Layer;
       End;

   AQTStudy.SV.Update_Distributions;
   Show_Study_Info;    {Update Screen}
end;


procedure TPrimaryInterface.RemoveBuriedSedLayer1Click(Sender: TObject);
Var i: Integer;
    IsTempl: Boolean;
    WorkingStudy: TAQUATOXSegment;
begin
  If AQTStudy.SV.SedLayers <=1
    Then Begin
           MessageDlg('You cannot remove the active layer without removing the entire Sediment Bed Model.',
                       MTInformation, [MBOK],0);
           Exit;
         End;

  If (MessageDlg('Remove the lowest buried sediment layer?',
                  MTConfirmation, [MbYes,MbCancel], 0) = MrCancel) then exit;

  If Not AQTStudy.SV.LinkedMode
    then AQTStudy.Remove_Sediment_Layer
    else
      For i := -1 to AQTStudy.AllOtherSegs.Count-1 do
       Begin
         IsTempl := (i=-1);
         If IsTempl then WorkingStudy := AQTStudy.TemplateSeg
                    else WorkingStudy := AQTStudy.AllOtherSegs.At(i);
         WorkingStudy.Remove_Sediment_Layer;
       End;

   AQTStudy.SV.Update_Distributions;
   Show_Study_Info;    {Update Screen}

end;

procedure TPrimaryInterface.SedLayerButtClick(Sender: TObject);
Var Diagen: Boolean;
begin
  Diagen := (AQTStudy.SV.GetStatePointer(POC_G1,StV,SedLayer2) <> nil);
  If Diagen then
    Begin
      Application.CreateForm(TDiag_Init_Cond_Form,Diag_Init_Cond_Form);
      With Diag_Init_Cond_Form do
        Begin
          EditDiagenesis(AQTStudy);
          If Changed or DiaChanged then CHANGED_TRUE;
          Free;
        End;
    End else

    Begin {Multi-Layer Sed Model}
      Application.CreateForm(TEditSedForm,EditSedForm);
      EditSedForm.CurrentStudy := AQTStudy;
      EditSedForm.EditSedLayers;
      EditSedForm.Free;
      CHANGED_TRUE;
    End;

  Show_Study_Info;    {Update Screen}
end;



procedure TPrimaryInterface.AddNonReactiveSedLayer1Click(Sender: TObject);
Var i: integer;
    IsTempl: Boolean;
    WorkingStudy: TAQUATOXSegment;

    Procedure SetupNonReactive(PST: TStates);
    Var PSV: TStateVariable;
    Begin
      PSt.SedNonReactive := True;
      PSt.SedData[1].BedDepthIC:= 0.1524;
      PSt.MaxUpperThick := 0.1524;
      PSt.BioTurbThick  := 0.1524;

      PSt.Densities[cohesives] := 2.5;
      PSt.Densities[NonCohesives] := 2.5;
      PSt.Densities[NonCohesives2] := 2.5;
      PSt.Densities[SedmRefrDetr] := 2.0;
      PSt.Densities[SedmLabDetr] := 2.0;

      PSV := PSt.GetStatePointer(Cohesives,StV,SedLayer1);
      PSV.InitialCond := 1e5;
      PSV := PSt.GetStatePointer(NonCohesives,StV,SedLayer1);
      PSV.InitialCond := 1e5;
      PSV := PSt.GetStatePointer(NonCohesives2,StV,SedLayer1);
      PSV.InitialCond := 1e5;
    End;

begin
  If MessageDlg('This option will add a non-reactive sediment layer to your simulation.  This allows '+
                 'the user to specify the toxicity of pore water for uptake into biota.  This option is '+
                 'especially useful when used in conjunction with the "use external data" toxicant modeling '+
                 'option.',mtconfirmation,[mbok,mbcancel],0) = mrcancel then exit;


  If Not AQTStudy.SV.LinkedMode
    then
      Begin
        AQTStudy.Add_Sediment_Model;
        SetupNonReactive(AQTStudy.SV);
      End
    else
      Begin
        For i := -1 to AQTStudy.AllOtherSegs.Count-1 do
         Begin
           IsTempl := (i=-1);
           If IsTempl then WorkingStudy := AQTStudy.TemplateSeg
                      else WorkingStudy := AQTStudy.AllOtherSegs.At(i);
           WorkingStudy.Add_Sediment_Model;
           SetupNonReactive(WorkingStudy.SV);
         End;
      End;

   AQTStudy.SV.Update_Distributions;
   Show_Study_Info;    {Update Screen}


end;

procedure TPrimaryInterface.EditTrophInt;

Begin
  Application.Createform(TEditTrophIntForm,EditTrophIntForm);
  EditTrophIntForm.AQTStudy := AQTStudy;
  EditTrophIntForm.EditTrophMatrix;
  If EditTrophIntForm.Changed then Changed_true;
  EditTrophIntForm.Free;
End;

procedure TPrimaryInterface.EditPlantLink;

Begin
  Application.Createform(TPlantLinksEdit,PlantLinksEdit);
  PlantLinksEdit.EditAllLinks(AQTStudy.SV);
  If PlantLinksEdit.Changed then Changed_true;
  PlantLinksEdit.Free;
End;



Function TPrimaryInterface.CopyTheStudy(Complete: Boolean): TAQUATOXSegment;
Var MemStream: TMemoryStream;
    Copy     : TAQUATOXSegment;
    VersionCheck : String[10];
    ReadVersionNum: Double;

Begin

   {DUPLICATE STUDY IN MEMORYSTREAM}

   Try
     AQTStudy.SV.StoreResults := Complete;      {Tell load / save, whether to save results}
     AQTStudy.SV.StoreDistribs := True;         {Tell load / save, to save distribs, though}
     MemStream:=TMemoryStream.Create;
     AQTStudy.Store(True,TStream(MemStream));
   Except
     WaitDlg.Hide;
     Show_Study_Info;
     MemStream.Destroy;
     Raise;
   End;

   {LOAD STUDY INTO COPY}

   Try
     MemStream.Seek(0, soFromBeginning); {Go to beginning of stream}
     MemStream.Read(VersionCheck,Sizeof(VersionCheck));
     ReadVersionNum:=StrToFloat(AbbrString(VersionCheck,' '));
     Copy := TAQUATOXSegment.Load(True,True,TStream(MemStream),ReadVersionNum,Complete,True);
     MemStream.Destroy;  {Finished copy}

   Except
     WaitDlg.Hide;
     Show_Study_Info;
     Raise;
   End;

  CopyTheStudy := Copy;

End;


procedure TPrimaryInterface.UMAfterActive(var Message: TMessage);
begin
  ParentForm.UpdateMenu(AQTStudy);
end;



procedure TPrimaryInterface.FormActivate(Sender: TObject);
begin
   PostMessage(Handle, UM_AFTERACTIVE, 0, LongInt(Sender));

   PrimaryPanel.Enabled := True;
   ModLabel.Visible := (AQTStudy.LastChange > AQTStudy.TimeLoaded);
   Update;
End;

Procedure TPrimaryInterface.WizBtnClick(Sender: TObject);
Var MemStream: TMemoryStream;
    VersionCheck : String[10];
    ReadVersionNum: Double;
    CResultsHolder, ResultsHolder: ResultsType;
    DistHolder: TDistributionList;

Begin
  If AQTStudy.SV.LinkedMode then
    Begin
      MessageDlg('The AQUATOX Wizard is currently disabled for linked-mode.',MtInformation,[mbok],0);
      Exit;
    End;

  If AQTStudy.SimsRunning>0 then
    Begin
      MessageDlg('You Cannot Edit a Study with the Wizard While it is Running.',MtInformation,[mbok],0);
      Exit;
    End;

  WaitDlg.Setup('Please Wait, Backing Up File in Memory');
  Try

    AQTStudy.SV.StoreResults := False;
    AQTStudy.SV.StoreDistribs := False;

    MemStream:=TMemoryStream.Create;
    AQTStudy.Store(True,TStream(MemStream));

  Except
    WaitDlg.Hide;
    Show_Study_Info;
    MemStream.Destroy;

    Raise;
    Exit;
  End;

  Application.CreateForm(TWizardProgress, WizardProgress);

  WizardProgress.WizStudy := AQTStudy;
  WaitDlg.Hide;
  ParentForm.Enabled := False;

  WizardIsRunning := True;

   If not WizardProgress.ExecuteWizard(False)
     then
       Begin  {User selected cancel}
          WaitDlg.Setup('Please Wait, Reloading Backup File');

          Try
            ResultsHolder := AQTStudy.SV.Results;
            CResultsHolder := AQTStudy.SV.ControlResults;
            DistHolder    := AQTStudy.SV.Distributions;
            AQTStudy.SV.Results[Epilimnion] := nil;
            AQTStudy.SV.Results[Hypolimnion] := nil;
            AQTStudy.SV.ControlResults[Epilimnion] := nil;
            AQTStudy.SV.ControlResults[Hypolimnion] := nil;

            AQTStudy.SV.Distributions := nil;

            If AQTStudy<>nil then AQTStudy.Destroy;

            MemStream.Seek(0, soFromBeginning); {Go to beginning of stream}
            MemStream.Read(VersionCheck,Sizeof(VersionCheck));
            ReadVersionNum:=StrToFloat(AbbrString(VersionCheck,' '));
            AQTStudy := TAQUATOXSegment.Load(False,True,TStream(MemStream),ReadVersionNum,False,False);

            AQTStudy.SV.ControlResults := CResultsHolder;
            AQTStudy.SV.Results := ResultsHolder;
            AQTStudy.SV.Distributions := DistHolder;

            MemStream.Destroy;  {Finished backup}
          Except
            AQTStudy:=nil;
            WaitDlg.Hide;
            ParentForm.Enabled := True;
            FormActivate(nil);
            Show_Study_Info;
            Raise;
          End;

          WaitDlg.Hide;
       End
     else
       Begin  {User finished specifications}
         MemStream.Destroy;  {Didn't need backup}
         Show;

         AQTStudy.LastChange := Now;
         AQTStudy := WizardProgress.WizStudy;

         AQTStudy.Adjust_Internal_Nutrients;
         If AQTStudy <> nil then AQTStudy.SV.Update_Distributions;

       End;

   FormActivate(nil);
   WizardIsRunning := False;
   ParentForm.Enabled := True;
   WizardProgress.Free;
   Show_Study_Info;
 End;

procedure TPrimaryInterface.RunButtonClick(Sender: TObject);
begin
   ExecuteSimulation(False);
end;
         
procedure TPrimaryInterface.FormDeactivate(Sender: TObject);
begin
  PrimaryPanel.Enabled := False;
end;


procedure TPrimaryInterface.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := True;
  If AQTStudy=nil then exit;

  If not AQTStudy.SV.LinkedMode then
    BEGIN
      If AQTStudy.SimsRunning>0 then
        Begin
          MessageDlg('You Cannot Close a Study While it is Running',mtinformation,[mbok],0);
          CanClose := False;
          Exit;
        End;

      CanClose := True;
      SaveSuccess := True;
      if Check_Save_and_Cancel('closing') or (not savesuccess) then CanClose := False;
      If CanClose then ParentForm.UpdateRecentlyUsed(AQTStudy,AQTStudy.DirName,AQTStudy.FileName);
   END;

end;

procedure TPrimaryInterface.BeforeDestruction;
var i: integer;
begin
  for i:= 0 to ParentForm.MDIChildCount-1 do           {clean up data for existing output windows}
    if ParentForm.MDIChildren[i] is TOutputscreen then
      If TOutputscreen(Parentform.MDIChildren[i]).MainStudy = AQTStudy then
        TOutputscreen(Parentform.MDIChildren[i]).MainStudy := nil;
    inherited;
end;


procedure TPrimaryInterface.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic5.htm');
end;

procedure TPrimaryInterface.SegNumTextBoxExit(Sender: TObject);
begin
  TLinkedForm(Owner).SegIDChanged(Self);
  {}
end;

procedure TPrimaryInterface.BirdButtClick(Sender: TObject);
begin
   Application.CreateForm(TBirdScreen,BirdScreen);
   BirdScreen.SV := AQTStudy.SV;
   BirdScreen.PtrTrophint := @AQTStudy.SV.GullPref;
   BirdScreen.EditBirds;
   BirdScreen.Free;
end;

procedure TPrimaryInterface.Export_to_2_2;
Var DN, FN: ShortString;
    NS: AllVariables;
    PA: TAnimal;
    PP: TPlant;
Begin
  If not Library_File1.ReturnDBName('Animal',DN,FN) then exit;
  With AQTStudy.SV do
   For ns := FirstAnimal to LastAnimal do
    If GetStatePointer(ns,StV,WaterCol)<>nil then
      Begin
        PA := GetStatePointer(ns,StV,WaterCol);
        AnimalRecord_To_2_2_Dbase(DN,FN,PA.PAnimalData^.AnimalName,PA.PAnimalData^);
      End;

  If not Library_File1.ReturnDBName('Plant',DN,FN) then exit;
  With AQTStudy.SV do
   For ns := FirstPlant to LastPlant do
    If GetStatePointer(ns,StV,WaterCol)<>nil then
      Begin
        PP := GetStatePointer(ns,StV,WaterCol);
        PlantRecord_To_2_2_Dbase(DN,FN,PP.PAlgalRec^.PlantName,PP.PAlgalRec^);
      End;

  MessageDlg('Export Completed Successfully',mtinformation,[mbok],0);
End;

procedure TPrimaryInterface.Export_to_3;
Var DN, FN: ShortString;
    NS: AllVariables;
    PA: TAnimal;
    PP: TPlant;
Begin
  If not Library_File1.ReturnDBName('Animal',DN,FN) then exit;


  With AQTStudy.SV do
   For ns := FirstAnimal to LastAnimal do
    If GetStatePointer(ns,StV,WaterCol)<>nil then
      Begin
        PA := GetStatePointer(ns,StV,WaterCol);
        AnimalRecord_To_Dbase(DN,FN,PA.PAnimalData^.AnimalName,PA.PAnimalData^,False);
      End;

  If not Library_File1.ReturnDBName('Plant',DN,FN) then exit;
  With AQTStudy.SV do
   For ns := FirstPlant to LastPlant do
    If GetStatePointer(ns,StV,WaterCol)<>nil then
      Begin
        PP := GetStatePointer(ns,StV,WaterCol);
        PlantRecord_To_Dbase(DN,FN,PP.PAlgalRec^.PlantName,PP.PAlgalRec^);
      End;

  MessageDlg('Export Completed Successfully',mtinformation,[mbok],0);
End;


procedure TPrimaryInterface.SaveDialog1TypeChange(Sender: TObject);
Var OutFm: String;
    SaveDlg: TSaveDialog;
begin
  If SaveDialog1.Title='Output Uncertainty Results As: ' then exit;
  SaveDlg := TSaveDialog(Sender);
  if (Length(SaveDlg.FileName) > 0)
   then if not DirectoryExists(SaveDlg.FileName)
    then
     Begin
       Case SaveDlg.FilterIndex of
         2: outfm := '.db';
         3: outfm  := '.dbf';
         1: outfm := '.xls';
         else outfm  := '.csv';
       End; {Case}

      // Add file extension
      OutFm := ExtractFileName(ChangeFileExt(SaveDlg.FileName,OutFm));
      SaveDlg.FileName := OutFm;

      SendMessage( GetParent( saveDlg.handle ),
                   CDM_SETCONTROLTEXT,
                   1152,
                   integer(PChar(OutFm)));

     End;
end;

Procedure TPrimaryInterface.ExportParametersAsText;
Var   SaveDialog : TSaveDialog ;
      BaseName: String;
      LogFile: TextFile;
begin
{   SaveDialog := nil ; }

   try
      // Create save dialog and set it options
      SaveDialog := TSaveDialog.Create(Self) ;
      with SaveDialog do
      begin
         DefaultExt := 'txt' ;
         Filter := 'Text file (*.txt)|*.txt|All files (*.*)|*.*' ;
         BaseName := AQTStudy.FileName;
         Delete(BaseName,Length(BaseName)-3,4);
         FileName := AQTStudy.DirName + BaseName + '_Text.txt';
         Options := [ofOverwritePrompt,ofPathMustExist,ofNoReadOnlyReturn,ofHideReadOnly] ;
         Title := 'Specify a Text File for Parm. Export:';
      end;

      WriteLoadingsToTextLog := MessageDlg('Save Dynamic Loadings (Timeseries) to text file?',
          MTConfirmation,[mbyes,mbno],0) = MRYes;

      // Execute save dialog
      if SaveDialog.Execute then
      begin
        AssignFile(LogFile,SaveDialog.FileName);
        Rewrite(LogFile);
        AQTStudy.WriteText(LogFile);
        MessageDlg('Text Export Complete.',mtinformation,[mbok],0);
        CloseFile(LogFile);
      End;
   except
     MessageDlg('Error Exporting to Text.',mterror,[mbok],0);
     CloseFile(LogFile);
     Raise;
   end;

end;


End.

                                                                     

