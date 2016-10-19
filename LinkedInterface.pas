//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit LinkedInterface;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Global, AQStudy, ExcelFuncs,
  ExtCtrls, StdCtrls, Buttons, Menus, LinkedSegs, Librarys2, Study_io, AquaObj, ClearResults,
  ImgList, Loadings, Db, DBTables, MigrEdit, LinkedThread, SV_IO, ExportResults, hh;

Const UM_AFTERACTIVE = WM_USER + 120;
type
  TLinkedForm = class(TForm)
    MainPanel: TPanel;
    DataLabel: TLabel;
    ProgramLabel: TLabel;
    ChemicalButton: TBitBtn;
    SetupBitBtn: TBitBtn;
    RunBitBtn: TBitBtn;
    OutputBitBtn: TBitBtn;
    NotesBitBtn: TBitBtn;
    ControlButt: TBitBtn;
    ExportButton: TBitBtn;
    Panel2: TPanel;
    Bevel1: TBevel;
    ListBox1: TListBox;
    Panel3: TPanel;
    AddButton: TButton;
    DeleteButton: TButton;
    EditButton: TButton;
    StudyNameEditBox: TEdit;
    StudyNameLabel: TLabel;
    ShowSegmentButton: TRadioButton;
    ShowLinkButton: TRadioButton;
    PrinterSetupDialog1: TPrinterSetupDialog;
    toxiclabel: TLabel;
    LastRunLabel: TLabel;
    controllabel: TLabel;
    ControlRunLabel: TLabel;
    UncertLabel: TLabel;
    LoadPictureButton: TButton;
    ClearMapButton: TButton;
    OpenDialog1: TOpenDialog;
    ScrollBox1: TScrollBox;
    AssociatedMap: TImage;
    SaveDialog1: TSaveDialog;
    ExportTable: TTable;
    ModLabel: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    UpBtn: TBitBtn;
    DownBtn: TBitBtn;
    HidePassBox: TCheckBox;
    HelpButton: TBitBtn;
    Button1: TButton;
    SpinUpLabel: TLabel;
    InternalNutLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Save1Click(Sender: TObject);
    procedure PrintSetup1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Animals1Click(Sender: TObject);
    procedure Chemicals1Click(Sender: TObject);
    procedure Plants1Click(Sender: TObject);
    procedure Sites1Click(Sender: TObject);
    procedure Remineralization1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure SetupBitBtnClick(Sender: TObject);
    procedure NotesBitBtnClick(Sender: TObject);
    procedure ChemicalButtonClick(Sender: TObject);
    procedure LoadPictureButtonClick(Sender: TObject);
    procedure ClearMapButtonClick(Sender: TObject);
    procedure ShowLinkButtonClick(Sender: TObject);
    procedure StudyNameEditBoxChange(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure ClearResults1Click(Sender: TObject);
    procedure Uncertainty1Click(Sender: TObject);
    procedure RateSavingInformation1Click(Sender: TObject);
    procedure ControlRunSetup1Click(Sender: TObject);
    procedure RunBitBtnClick(Sender: TObject);
    procedure ControlButtClick(Sender: TObject);
    procedure OutputBitBtnClick(Sender: TObject);
    procedure ExportButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HidePassBoxClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    protected
    procedure UMAfterActive(var Message: TMessage); message UM_AFTERACTIVE;
  private
    SaveSuccess: Boolean;
    ListBoxIDs : TListBoxIDs;
{    Procedure SetupDebugScreen; }
  public
    LinkedSegmts : TLinkedSegs;
    Procedure BorrowParameters;
    Procedure GraphsToWord;
    Procedure ExportLinkedParmsToText;
    Constructor Create(AOwner: TComponent; LS: TLinkedSegs); reintroduce;
    Function CopyTheStudy(Complete: Boolean): TLinkedSegs;
    procedure Export_to_2_2;
    procedure Export_to_3;
    Procedure Show_LinkedSegmts_Info;
    Function  Check_Save_and_Cancel(ActionGerund: ShortString): Boolean;
    procedure ExecuteSimulation(IsControl: Boolean);
    Procedure BeforeDestruction;  Override;
    Procedure EditTrophInt;
    Procedure EditPlantLink;
    Procedure Changed_True;
    Procedure Display_Modlabel;
    Procedure AddExcelTimeseries;
    Procedure SegIDChanged(PI: Pointer);
    { Public declarations }
  end;

var
  LinkedForm   : TLinkedForm;

Function OpenLS(FileN: String): Pointer;


implementation

uses Wait, RateScrn, results, Setup, Control, Uncert, u_setup, LinkedExcelTemplate, BufferTStream,
  Notesdlg, ChangVar, edstatev, Main, newsegment, Progress, LinkEdit, AQTOpenDialog,
  chartprop,  Output, Debug, Parent, Graphchc, trophmatrix, TCollect, AllPlantLinksEdit;

{$R *.DFM}

Constructor TLinkedForm.Create(AOwner: TComponent; LS: TLinkedSegs);
Begin
  If LS=nil then LinkedSegmts := nil;
  Inherited Create(AOwner);

  LinkedSegmts := LS;
  If LS<> nil then
   If LS.ImagePtr <> nil then
     AssociatedMap.Picture.Bitmap := LS.ImagePtr;
End;

Procedure TLinkedForm.GraphsToWord;
Var i: Integer;
    AQTStudy: TAQUATOXSegment;
    OS: TOutputScreen;
    Cntrl: Boolean;
Begin

  Cntrl := LinkedSegmts.ControlRun <> -1;
  If (LinkedSegmts.ControlRun <> -1) and
     (LinkedSegmts.LastRun <> -1) then
    Cntrl :=  MessageDlg('Export Control Graphs (as opposed to Perturbed)?',
                mtconfirmation,[mbyes,mbno],0) = mryes;  {}


  For i := 0 to LinkedSegmts.SegmentColl.Count-1 do
    Begin
       AQTStudy := LinkedSegmts.SegmentColl.At(i);
       If AQTStudy.Location.SiteType <> TribInput then
         Begin
           AQTStudy.SV.PSegID := @AQTStudy.SegNumber;
           OS := TOutputScreen.Create(Parent,AQTStudy,AQTStudy,nil, LinkedSegmts);
           OS.ExportGraphsToWord(Cntrl);
           OS.Free;
         End;
    End;
  WordInitialized := False;


End;

Procedure TLinkedForm.Show_LinkedSegmts_Info;
{SHOW ALL INFO ABOUT CURRENT LINKED STUDY ON STUDY SCREEN.}

Var DateHolder: String;
    PSL: TSegmentLink;
    Loop, i: Integer;
    PATS: TAQUATOXSegment;

Begin
    Show;
    WaitDlg.Hide;
    Enabled := True;

    If LinkedSegmts=nil then   {Show the empty screen with disabled options}
       Begin
(*       Study1.Enabled:=False;
         mlb.ExportResults1.Enabled:=False;
         MainPanel.Visible:=False;
         Save1.Enabled:=False;
         SaveAs1.Enabled:=False; *)
         Caption:='Linked System Mode';
         SpinupLabel.Visible := False;
       End
     Else   {A LINKED STUDY EXISTS}
      With LinkedSegmts do
       Begin
         Caption:='Linked System Mode: "'+LinkedSegmts.FileName+'"';

         If (LinkedSegmts.TemplateSeg=nil) then exit;

         ParentForm.UpdateMenu(LinkedSegmts.TemplateSeg);

         {Enable Menu Items which require a study}
(*       ExportResults1.Enabled:=True;
         Study1.Enabled:=True;
         Save1.Enabled   := True;
         SaveAs1.Enabled := True; *)

         Display_ModLabel;

         {Update Names on Screen}
         StudyNameEditBox.Text:=SystemName;
         SpinupLabel.Visible := TemplateSeg.PSetup^.SPINUP_MODE;

         InternalNutLabel.Visible := TemplateSeg.PSetup^.Internal_Nutrients;

         {Show Uncertainty Setup}
         With TemplateSeg.PUncertainty^ do
            Begin
              {Show Uncertainty Setup}
                UncertLabel.Caption:='Model is set up to run '+
                        IntToStr(NumSteps)+ ' uncertainty iterations.';
                If Run_Sensitivity then UncertLabel.Caption := 'Model is set up to run in sensitivity mode.';
                UncertLabel.Visible:= Run_Uncertainty or Run_Sensitivity;
            End;

         {Write Last Run}
         If        LastRun = -1 then LastRunLabel.Caption:='No Run Recorded'
           else If LastRun = -2 then LastRunLabel.Caption:='Partial Run Only'
           else If LastRun = -3 then LastRunLabel.Caption:='Perturbed Run Not Current'
           else begin
                  DateTimeToString(DateHolder,'mm-d-y t',LastRun);
                  LastRunLabel.Caption:=DateHolder ;
                end; {if}

         If         ControlRun = -1 then ControlRunLabel.Caption:='No Ctrl. Run Recorded'
            else If ControlRun = -2 then ControlRunLabel.Caption:='Partial Ctrl. Run Only'
            else If ControlRun = -3 then ControlRunLabel.Caption:='Control Run Not Current'
            else begin
                   DateTimeToString(DateHolder,'mm-d-y t',ControlRun);
                   ControlRunLabel.Caption:=DateHolder ;
                 end; {if}

         {Show the screen}
         Update;
         UpdateControlState;

         If (AssociatedMap.Picture.Bitmap.empty)
           then Panel1.Visible := True
           else Panel1.Visible := False;

         ListBox1.Items.Clear;

         If ShowSegmentButton.Checked
           then
             For Loop := 0 to SegmentColl.Count - 1 do
               Begin
                 PATS := SegmentColl.At(Loop);
                 If not HidePassBox.Checked or (PATS.SV.Location.SiteType<>TribInput) then
                   Begin
                     ListBox1.Items.Add('['+ PATS.SegNumber + ']: '+PATS.StudyName);
                     ListBoxIDs[ListBox1.Count-1] := PATS.SegNumber;
                   End;
               End
           else
             For Loop := 0 to Links.Count-1 do
               Begin
                 PSL := Links.At(Loop);
                 If HidePassBox.Checked then
                   Begin
                     PATS := nil;
                     For i := 0 to SegmentColl.Count - 1 do
                       Begin
                         PATS := SegmentColl.At(i);
                         If PATS.SegNumber = PSL.FromID then break;
                       End;
                     If PATS.Location.SiteType = TribInput then continue;
                   End;
                 ListBox1.Items.Add(PSL.Name + ': From ['+PSL.FromID+'] to ['+PSL.ToID+']');
               End;

          Update;

       End; {Else}

End;

Function TLinkedForm.Check_Save_and_Cancel(ActionGerund: ShortString): Boolean;
{Upon Opening New Study, Closing the program, etc. (specified in ActionGerund)
 This proecdure ensures user does not wish to save current study first}

 Var MR : TModalResult;
     NullObj: Tobject;
 Begin
   NullObj:=Nil;
   Check_Save_and_Cancel:=False;
   Display_ModLabel;

   If LinkedSegmts<>nil then if LinkedSegmts.LastChange > LinkedSegmts.TimeLoaded then
      Begin
         Mr := MessageDlg('Save '+LinkedSegmts.Filename + ' Before '+ActionGerund+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
         If (Mr=mrYes) then Save1Click(NullObj);
         If (Mr=mrCancel) then Check_Save_and_Cancel:=True;
      End;
 End;


procedure TLinkedForm.FormCreate(Sender: TObject);
begin
 { LinkedSegmts := nil; }
end;

procedure TLinkedForm.Exit1Click(Sender: TObject);
Var Act: TCloseAction;
begin
  Act:=CaFree;
  FormClose(sender,Act);
end;


Function TLinkedForm.CopyTheStudy(Complete: Boolean): TLinkedSegs;
Var MemStream: TMemoryStream;
    Copy     : TLinkedSegs;
    VersionCheck : String[10];
{    VLoop : VerticalSegments; }
    ReadVersionNum: Double;

Begin

   {DUPLICATE STUDY IN MEMORYSTREAM}

   Try
     MemStream:=TMemoryStream.Create;
     LinkedSegmts.StoreLS(True,TStream(MemStream),Complete,True);
   Except
     WaitDlg.Hide;
     Show_LinkedSegmts_Info;
     MemStream.Destroy;
     Raise;
   End;

   {LOAD STUDY INTO COPY}

   Try
     MemStream.Seek(0, soFromBeginning); {Go to beginning of stream}
     MemStream.Read(VersionCheck,Sizeof(VersionCheck));
     ReadVersionNum:=StrToFloat(AbbrString(VersionCheck,' '));
     Copy := TLinkedSegs.Load(True,TStream(MemStream),ReadVersionNum,Complete,True);
     MemStream.Destroy;  {Finished copy}

   Except
     WaitDlg.Hide;
     Show_LinkedSegmts_Info;
     Raise;
   End;

  CopyTheStudy := Copy;

End;

Procedure TLinkedForm.Changed_True;
Begin
  LinkedSegmts.LastChange := Now;
  ModLabel.Visible := (LinkedSegmts.LastChange > LinkedSegmts.TimeLoaded);
End;

Procedure TLinkedForm.Display_Modlabel;
Var i, Loop: Integer;
    PATS: TAQUATOXSegment;
Begin
  If LinkedSegmts = nil then exit;

  With LinkedSegmts do
     For Loop := 0 to SegmentColl.Count - 1 do
       Begin
         PATS := SegmentColl.At(Loop);
         for i:= 0 to ParentForm.MDIChildCount-1 do
           if ParentForm.MDIChildren[i] is TOutputscreen then
             If TOutputscreen(Parentform.MDIChildren[i]).MainStudy = PATS then
               If (TOutputscreen(Parentform.MDIChildren[i]).Changed > PATS.LastChange) then
                 PATS.LastChange := TOutputscreen(Parentform.MDIChildren[i]).Changed;

         If (PATS.LastChange > LinkedSegmts.TimeLoaded) then
            LinkedSegmts.LastChange := PATS.LastChange;
       End;

  ModLabel.Visible := (LinkedSegmts.LastChange > LinkedSegmts.TimeLoaded);
  MainPanel.Visible  := True;
End;


Procedure TLinkedForm.ExecuteSimulation(IsControl: Boolean);
Var RunLinked: TLinkedSegs;
    WorkStudy: TAQUATOXSegment;
    NumTests : Integer;
    ThisProgress: TProgressDialog;
    StoreStep: Double;

   {------------------------------------------------------------------}
   Procedure CountNumTests;
   var dloop,j: Integer;
       WS: TAQUATOXSegment;
   Begin
     NumTests := 0;
     With LinkedSegmts do
      For j:=-1 to SegmentColl.Count-1 do
       Begin
         If j=-1 then WS := TemplateSeg
                 else WS := SegmentColl.At(j);
          With WS.SV do
            For dloop := 0 to Distributions.Count - 1 do
              If TDistribution(Distributions.At(dloop)).UseForSens then NumTests := NumTests + 2;
       End;
   End;
   {------------------------------------------------------------------}

  Function ExecuteSensitivity: Boolean;
  var j: Integer;
      WS: TAQUATOXSegment;
      TestFileN: String;
  begin
   With LinkedSegmts do
    Begin
      Result := False;
      If TemplateSeg.PUncertainty^.NumSens = 0 then
        Begin
          MessageDlg('Model is set up to run in Sensitivity Mode, but no output variables are set up for tracking',
                     mterror,[mbok],0);
          Exit;
        End;

      StoreStep := TemplateSeg.PSetup^.StoreStepSize;
      If not TemplateSeg.PSetup^.StepSizeInDays then StoreStep := StoreStep / 24;
      if StoreStep <=7 then
        if MessageDlg('Your data averaging period is less than one week.  Is this your intention?  Recall that ' +
                      'a sensitivity analysis saves selected results from the last data-point output in your model run.  '+
                      'This means the last time-step (less than one week) will be output as sensitivity results. '+
                      'If a longer averaging time is desired, change the averaging (data storage) time-step in '+
                      'the setup screen.  Continue Run?',mtconfirmation,[mbyes,mbno],0) = MRNo
          then exit;

      CountNumTests;

      If Not NumTests = 0 then
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

      For j:=0 to SegmentColl.Count-1 do
       Begin
         WS := SegmentColl.At(j);
         If WS.SV.Location.sitetype<>TribInput Then
           Begin
             TestFileN := ChangeFileExt(SaveDialog1.FileName,'_' + WS.SegNumber +'.xls');
             If FileExists(TestFileN) then If Not DeleteFile(TestFileN)
                then Begin
                       MessageDlg('Cannot gain exclusive access to file "'+TestFileN  +'" to overwrite it.',mtError,[mbOK],0);
                       Exit;
                     End;
           End;
       End;

      TemplateSeg.Unc_Dir  := ExtractFilePath(SaveDialog1.FileName);
      TemplateSeg.Unc_File := ExtractFileName(SaveDialog1.FileName);
      TemplateSeg.Unc_Ext  := '';

      TemplateSeg.Sens_File := SaveDialog1.FileName;

      With TemplateSeg.PUncertainty^ do
        Begin
          AdvancedSens   := FALSE;
          StartIteration := 1;
          Processors2Use := 2;
        End;

      Result := True;
    End;
  end;
  {-----------------------------------------------------------------------}

Var RunSens, SensDone: Boolean;
    SensIter, j: Integer;
    NumIters: Integer;

  Procedure SetupSensRun;
  Begin
   With LinkedSegmts.TemplateSeg.PUncertainty^ do
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

   {------------------------------------------------------------------}

  Procedure Setup_Uncert_Sens;
  Begin
      RunLinked.TemplateSeg.RunIterations:=False;
      If RunLinked.TemplateSeg.PUncertainty^.Run_Uncertainty then
        begin
         If not PrimaryInterface.Get_Uncertainty_File_Info(LinkedSegmts.TemplateSeg) then
             Begin ThisProgress.Free; Exit;  End;

          RunLinked.LUnc_Dir  := LinkedSegmts.TemplateSeg.Unc_Dir;
          RunLinked.LUnc_File := LinkedSegmts.TemplateSeg.Unc_File;
          RunLinked.LUnc_Ext  := LinkedSegmts.TemplateSeg.Unc_Ext;
          RunLinked.TemplateSeg.RunIterations:=True;
        end;

     If RunSens then
      With RunLinked.TemplateSeg do
       Begin
         Sens_File := LinkedSegmts.TemplateSeg.Sens_File;
         If SensIter > 1 then
           Begin
             Delete(Sens_File,Length(Sens_File)-3,4);
             Sens_File :=  Sens_File + IntToStr(SensIter) + '.xls';
           End;
         RunIterations:=True;
         Control_Is_Running:=IsControl;
       End;

     With RunLinked.TemplateSeg.PUncertainty^ do If Run_Uncertainty or Run_Sensitivity
       Then With ThisProgress do
         Begin
           UncertPanel.Visible:=True;
           If Run_Uncertainty then UncertTitleLabel.Caption :='Latin Hypercube Uncertainty Analysis:'
                              else UncertTitleLabel.Caption :='Sensitivity Analysis in Progress:';
           ThisProgress.UncertStatusLabel.Caption:='Deterministic Simulation ';
         End;

  End;

   {------------------------------------------------------------------}

Var i: Integer;
Begin        {ExecuteSimulation}
   If LinkedSegmts.SegmentColl.Count = 0 then
     Begin
       MessageDlg('Error, You must have at least one segment in a linked study.',
                   MTError,[mbOK],0);
       Show_LinkedSegmts_Info;
       Exit;
     End;

   SegLog := '';
   Changed_True;
   SensIter := 0;
   SensDone := False;

   Repeat
     With LinkedSegmts.TemplateSeg.PUncertainty^ do
      If Run_Sensitivity then
        SetupSensRun;


      With LinkedSegmts do
      For i:=-1 to SegmentColl.Count-1 do
        Begin
          If i=-1 then WorkStudy := TemplateSeg
                  else WorkStudy := SegmentColl.At(i);
           With WorkStudy.SV do
              For j := 0 to Graphs.NumGraphs-1 do
                Begin
                  Graphs.GArray[j].data.XMin := 0;
                  Graphs.GArray[j].data.XMax := 0;
                End;
        End;

     WaitDlg.Setup('Please Wait, Preparing for Simulation Run');
     RunLinked := CopyTheStudy(False);
     WaitDlg.Hide;
     Update;

     If RunLinked = nil then exit;
     if not RunLinked.Verify_Runnable(True) then Begin
                                               RunLinked.Destroy;
                                               exit;
                                            End;

     RunSens := LinkedSegmts.TemplateSeg.PUncertainty^.Run_Sensitivity;
     If RunSens and Not ExecuteSensitivity then Exit;

     RunLinked.TemplateSeg.Control_Is_Running := IsControl;

     ThisProgress := TProgressDialog.Create(Owner, LinkedSegmts.TemplateSeg, Self);
     ThisProgress.StepSizeLabel.Visible:=False;

     With ThisProgress do
         If RunLinked.TemplateSeg.PSetup.ShowIntegration then ThisProgress.Height:=DebugHeight
                                                         else ThisProgress.Height:=StandardHeight;

     RunLinked.TemplateSeg.SV.StudyProgDlg := ThisProgress;
     RunLinked.StudyProgress := ThisProgress;

     ThisProgress.ControlLabel.Visible:=IsControl;
     RunLinked.TemplateSeg.Control_Is_Running:= IsControl;;

     Update;

     If (LinkedSegmts = nil) then exit;

     Setup_Uncert_Sens;

     ThisProgress.ModalResult:=0;
     ThisProgress.Gauge1.Progress:=0;
     ThisProgress.Show;

     ThisProgress.Update;

     Inc(LinkedSegmts.SimsRunning);
     TLinkedSimulation.Create(RunLinked, LinkedSegmts, Show_LinkedSegmts_Info,AssociatedMap);

   Until (Not RunSens) or SensDone;

   For i := 0 to ListBox1.Items.Count-1 do
     ListBox1.Selected[i] := False;

   PostMessage(ListBox1.Handle, WM_LButtonUp, 0,0 );
   Application.ProcessMessages;

{   Show_LinkedSegmts_Info; }
End;


procedure TLinkedForm.FormClose(Sender: TObject; var Action: TCloseAction);
Var i,j: Integer;
begin

   Action := caFree;
   ParentForm.UpdateMenu(nil);
   for i:= 0 to ParentForm.MDIChildCount-1 do
      Begin
        if ParentForm.MDIChildren[i] is TPrimaryInterface then
          If TForm(ParentForm.MDIChildren[i]).Owner = Self then
             Begin
               For j:= 0 to ParentForm.MDIChildCount-1 do
                  if ParentForm.MDIChildren[j] is TOutputscreen then
                    If TOutputscreen(Parentform.MDIChildren[j]).MainStudy = TPrimaryInterface(ParentForm.MDIChildren[i]).AQTStudy then
                      TOutputscreen(Parentform.MDIChildren[j]).MainStudy := nil;
               TPrimaryInterface(ParentForm.MDIChildren[i]).AQTStudy := nil;
             End;
        if ParentForm.MDIChildren[i] is TOutpuTScreen then
          If TOutputScreen(ParentForm.MDIChildren[i]).MainStudy = LinkedSegmts.TemplateSeg then
            TOutputScreen(ParentForm.MDIChildren[i]).MainStudy := nil;
      End;
end;

procedure TLinkedForm.Save1Click(Sender: TObject);
Var SaveDialog: TSaveDialog;
begin
  SaveSuccess:=false;

  saveDialog := TSaveDialog.Create(nil);
  saveDialog.Title := 'Save your simulation As';
  saveDialog.InitialDir := LinkedSegmts.DirName;
  saveDialog.Filter := 'AQUATOX Linked Studies (*.als)|*.als|All Files (*.*)|*.*';
  saveDialog.Options := [ofOverwritePrompt,ofPathMustExist,ofNoReadOnlyReturn,ofHideReadOnly, ofEnableSizing] ;
  saveDialog.DefaultExt := 'aps';
  saveDialog.FilterIndex := 1;


  If LinkedSegmts.FileName='LINKED1.ALS' then
    With LinkedSegmts do
      Begin
        if not SaveDialog.Execute then
          Begin
            SaveDialog.Free;
            Exit;
          End;
        FileName := ExtractFileName(SaveDialog.FileName);
        DirName := ExtractFilePath(SaveDialog.FileName);
      End;


  WaitDlg.Setup('Please Wait One Moment, Saving File');
  Enabled:=False;
  Try
    LinkedSegmts.SaveToFile(AssociatedMap);

  LinkedSegmts.TimeLoaded := Now;
  LinkedSegmts.LastChange := LinkedSegmts.TimeLoaded;
  Show_LinkedSegmts_Info;

  SaveSuccess:=true;
  With LinkedSegmts do
    ParentForm.UpdateRecentlyUsed(TemplateSeg,DirName,FileName);


  Except
    WaitDlg.Hide;
    Show_LinkedSegmts_Info;
    SaveDialog.Free;
    Raise;
  End;

  SaveDialog.Free;

End;

procedure TLinkedForm.SaveAs1Click(Sender: TObject);
Var SaveDialog: TSaveDialog;
begin
  SaveSuccess:=false;

  saveDialog := TSaveDialog.Create(nil);
  saveDialog.Title := 'Save your simulation As';
  saveDialog.InitialDir := LinkedSegmts.DirName;
  saveDialog.Filter := 'AQUATOX Linked Studies (*.als)|*.als|All Files (*.*)|*.*';
  saveDialog.Options := [ofOverwritePrompt,ofPathMustExist,ofNoReadOnlyReturn,ofHideReadOnly, ofEnableSizing] ;
  saveDialog.DefaultExt := 'aps';
  saveDialog.FilterIndex := 1;
  SaveDialog.FileName := LinkedSegmts.DirName + LinkedSegmts.FileName;

  if not SaveDialog.Execute then
      Begin
        SaveDialog.Free;
        Exit;
      End;
  LinkedSegmts.FileName := ExtractFileName(SaveDialog.FileName);
  LinkedSegmts.DirName := ExtractFilePath(SaveDialog.FileName);

  WaitDlg.Setup('Please Wait One Moment, Saving File');
  Enabled:=False;

  Try
    LinkedSegmts.SaveToFile(AssociatedMap);
    With LinkedSegmts do
      ParentForm.UpdateRecentlyUsed(TemplateSeg,DirName,FileName);

  Except
    WaitDlg.Hide;
    Show_LinkedSegmts_Info;
    SaveDialog.Free;
    Raise;
  End;

  SaveDialog.Free;
  LinkedSegmts.TimeLoaded := Now;
  LinkedSegmts.LastChange := LinkedSegmts.TemplateSeg.TimeLoaded;
  Show_LinkedSegmts_Info;
end;

procedure TLinkedForm.PrintSetup1Click(Sender: TObject);
begin
   PrinterSetupDialog1.Execute;
end;

procedure TLinkedForm.FormDestroy(Sender: TObject);
{Called when program finishes execution}
begin
   {$I-}
   {$I+}
   If not (LinkedSegmts=nil) then LinkedSegmts.Destroy;
  AssociatedMap.Picture.Bitmap.ReleaseHandle;

end;

procedure TLinkedForm.BeforeDestruction;
var
  n: integer;
  frm: TForm;

begin
    for n := ComponentCount-1 downto 0 do
    begin
        if Components[n] is TForm then
        begin
            frm := TForm(Components[n]);
            if frm.FormStyle = fsMDIChild then frm.Destroy;
        end;
    end;
    inherited;
end;


procedure TLinkedForm.FormShow(Sender: TObject);
begin
  Show_LinkedSegmts_Info;
end;

procedure TLinkedForm.HelpButtonClick(Sender: TObject);
begin
    HTMLHelpContext('working_with_linked.htm');

end;

procedure TLinkedForm.HidePassBoxClick(Sender: TObject);
begin
  UpBtn.Visible := not HidePassBox.Checked;
  DownBtn.Visible := not HidePassBox.Checked;
  Show_LinkedSegmts_Info;

end;

procedure TLinkedForm.Close1Click(Sender: TObject);
{Get the Study out of memory}
begin
   if Check_Save_and_Cancel('Closing Study') then exit;

   If LinkedSegmts<>nil then LinkedSegmts.Destroy;
   AssociatedMap.Picture.Bitmap.ReleaseHandle;

   LinkedSegmts:=nil;
   Show_LinkedSegmts_Info;
end;

procedure TLinkedForm.Animals1Click(Sender: TObject);
begin
  Library_File1.EditLibrary('Animal');
end;

procedure TLinkedForm.Chemicals1Click(Sender: TObject);
begin
  Library_File1.EditLibrary('Chemical');
End;

procedure TLinkedForm.Plants1Click(Sender: TObject);
begin
  Library_File1.EditLibrary('Plant');
end;

procedure TLinkedForm.Sites1Click(Sender: TObject);
begin

  Library_File1.EditLibrary('Site');
end;

procedure TLinkedForm.Remineralization1Click(Sender: TObject);
begin
  Library_File1.EditLibrary('Remin');
end;

procedure TLinkedForm.New1Click(Sender: TObject);
Var FirstSegment : TAQUATOXSegment;
    ErrorMessage: String;
    MemStream: TMemoryStream;
    VersionCheck : String[10];
    ReadVersionNum: Double;
    OpenDialog: TAQTOpenDialog;
    TLS: TLinkedSegs;
begin
   TLS := TLinkedSegs.Init('New Linked Study');
   LinkedSegmts := TLS;

   MessageDlg('In order to create a new linked study, you will first choose a single segment AQUATOX study '+
              'to serve as the template for your linked segments.', mtinformation, [mbok], 0);


  openDialog := TAQTOpenDialog.Create(self);
  openDialog.InitialDir := Studies_Dir;
  openDialog.Options := [ofFileMustExist, ofHideReadOnly, ofEnableSizing];
  openDialog.Filter := 'AQUATOX Studies (*.aps)|*.aps|All Files (*.*)|*.*';
  openDialog.FilterIndex := 1;

  If not openDialog.Execute then
    Begin
      OpenDialog.Free;
      Close;
      Exit;
    End;

   WaitDlg.Setup('Please Wait One Moment, Loading Template');

   Try
     LoadFile(LinkedSegmts.TemplateSeg,OpenDialog.FileName);  {Load the study as the template}

     MemStream:=TMemoryStream.Create;
     TeaseScreen:=False;
     LinkedSegmts.TemplateSeg.SV.StoreResults := True;
     LinkedSegmts.TemplateSeg.SV.StoreDistribs := True;
     LinkedSegmts.TemplateSeg.SV.LinkedMode := True;
     LinkedSegmts.TemplateSeg.Store(True,TStream(MemStream));    {Store Collection in memory}
     VersionNum:=StrToFloat(AbbrString(VersionStr,' '));
     ReadVersionNum:=VersionNum;         {Get Correct Version Num for Read}

     MemStream.Seek(0, soFromBeginning); {Go to beginning of stream}
     MemStream.Read(VersionCheck,Sizeof(VersionCheck));

     FirstSegment:=TAQUATOXSegment.Load(True,True,TStream(MemStream),ReadVersionNum,True,True); {Call Load Method}
     FirstSegment.SV.LinkedMode := True;
     MemStream.Destroy;
   Except
     LinkedSegmts := nil;
     WaitDlg.Hide;
     OpenDialog.Free;
     Close;
     Raise;
   End;

   LinkedSegmts.TemplateSeg.AllOtherSegs := LinkedSegmts.SegmentColl;
   FirstSegment.ShowTemplate(LinkedSegmts.TemplateSeg, ErrorMessage,True,False);
   FirstSegment.SegNumber := '1';

   If ErrorMessage<>'' then
     Begin
       MessageDlg('AQUATOX unexpectedly Got Error: '+ErrorMessage+' while creating a new linked study',
                   MTError, [mbok], 0);
       LinkedSegmts := nil;
       Close;
       Exit;
     End;

   LinkedSegmts.SegmentColl.Insert(FirstSegment);
   LinkedSegmts.ClearAllResults(0);

   If MessageDlg('Use Excel Template to Populate Linked Segments?',
                 MTConfirmation, [mbyes,mbno], 0) = mryes then
        ApplyExcelTemplate(LinkedSegmts);

   OpenDialog.Free;
   Show_LinkedSegmts_Info;
end;

Procedure TLinkedForm.AddExcelTimeseries;
Begin
   ApplyExcelTemplate(LinkedSegmts);
End;


Function OpenLS(FileN:String):Pointer;
Var FileStream : TReadOnlyCachedFileStream;
    PC_FileN    :  Array[0..255] of char;
    VersionCheck : String[10];
    ReadMap  : Boolean;
    ReadVers: Double;
    NewLS: TLinkedSegs;
    Map1 : TBitmap;

Begin
  NewLS := Nil;
  Map1 := Nil;
  OpenLS := Nil;

  WaitDlg.Setup('Please Wait One Moment, Loading File');

  {Load the File}
(* If (LinkedSegmts<>nil) then Dispose(LinkedSegmts,Destroy);
   AssociatedMap.Picture.Bitmap.ReleaseHandle;    *)

   StrPCopy(PC_FileN,FileN);

   Try
     FileStream:=TReadOnlyCachedFileStream.Create(PC_FileN,fmOpenRead);
   Except
     MessageDlg(Exception(ExceptObject).Message,mterror,[mbOK],0);
{     LinkedSegmts:=nil; }
{     Study_IO_DLG.Free; }
     WaitDlg.Hide;
{     Close; }
     Exit;
   End; {Try Except}

   {Check Version #}
   FileStream.Read(VersionCheck,Sizeof(VersionCheck));
   Try
     VersionNum:=0;
     ReadVers:=StrToFloat(AbbrString(VersionCheck,' '));
     VersionNum:=StrToFloat(AbbrString(VersionStr,' '));
   Except
     MessageDlg('File is not a valid AQUATOX Linked Version File',mterror,[mbOK],0);
{     LinkedSegmts:=nil; }
     FileStream.Destroy;
     WaitDlg.Hide;
{     Close; }
     Exit;
   End; {Try Except}

   If ReadVers<VersionNum then
      MessageDlg('Converting from '+VersionCheck+' to '+VersionStr,MTInformation,[MbOK],0);

   If ReadVers>VersionNum
     then
        Begin
           MessageDlg('File Version ('+VersionCheck+') is Greater than Executable Version: Unreadable.',mterror,[mbOK],0);
           WaitDlg.Hide;
        End
     else
        Try
          NewLS:=TLinkedSegs.Load(True,TStream(FileStream),ReadVers,True,True); {Call Load Method}
          NewLS.FileName:=ExtractFileName(FileN);
          NewLS.DirName:=ExtractFilePath(FileN);
          If ReadVers>=3.0299 then
            begin
              FileStream.Read(ReadMap,Sizeof(ReadMap));
              Map1 := TBitmap.Create;
              If ReadMap then Map1.LoadFromStream(FileStream)
                         else Map1 := nil;
            end;

        Except
          MessageDlg(Exception(ExceptObject).Message,mterror,[mbOK],0);
          Try
            FileStream.Destroy;
            If Map1 <> nil then Map1.ReleaseHandle;
            If NewLS<> nil then NewLS.Destroy;
          Except
{            LinkedSegmts := nil; }
            WaitDlg.Hide;
{            Close; }
          End;
        End;

   WaitDlg.Hide;
   If NewLS=nil then exit;
   NewLS.ImagePtr := Map1;
   NewLS.TemplateSeg.TimeLoaded := Now;
   NewLS.TemplateSeg.LastChange := NewLS.TemplateSeg.TimeLoaded;
   FileStream.Destroy;
   OpenLS := NewLS;
End;


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

procedure TLinkedForm.SetupBitBtnClick(Sender: TObject);
Var Int_Nut: Boolean;

begin
  CreateSetupForms;

  Try

  ResultsForm.SV      := LinkedSegmts.TemplateSeg.SV;
  ResultsForm.NumSegs := LinkedSegmts.SegmentColl.Count;

  USetupForm.PassVars(LinkedSegmts.TemplateSeg.PUncertainty,LinkedSegmts.TemplateSeg.SV,LinkedSegmts.TemplateSeg,LinkedSegmts,True);
  LinkedSegmts.Update_Distributions;

  DistributionForm.Changed := False;

  Int_Nut := LinkedSegmts.TemplateSeg.PSetup^.Internal_Nutrients;
  With LinkedSegmts.TemplateSeg do
     StudySetupDialog.EditSetup(PSetup^,SV.PRateInfo^, SV, SV.PControlInfo^,SV.LinkedMode,SV.NumOrgToxicants>0);

  With LinkedSegmts.TemplateSeg.PSetup^ do
   If Int_Nut <> Internal_Nutrients then
    If Internal_Nutrients then LinkedSegmts.Add_Internal_Nutrients
                          else LinkedSegmts.Remove_Internal_Nutrients;

  If StudySetupDialog.Changed or
     USetupForm.Changed or
     DistributionForm.Changed
     then CHANGED_TRUE;

  Finally
  DestroySetupForms;

  End;

  Show_LinkedSegmts_Info;
end;



procedure TLinkedForm.NotesBitBtnClick(Sender: TObject);
{Bring up the Notes Dialog}
begin
   Changed_True;

   Application.CreateForm(TNotesDialog,NotesDialog);
   NotesDialog.DisplayNotes(LinkedSegmts.TemplateSeg.NewNotes);
   NotesDialog.Free;
end;

procedure TLinkedForm.ChemicalButtonClick(Sender: TObject);
Var NumToxs           : Integer;
    ToxLoop,ToxFound  : AllVariables;
    EntryStr          : String;
    SelTox            : Array[0..10] of AllVariables;
Begin

 NumToxs := 0;
 ToxFound := FirstOrgTox;

 For ToxLoop := FirstOrgTox to LastOrgTox do
   Begin
     If LinkedSegmts.TemplateSeg.SV.GetIndex(ToxLoop,StV,WaterCol) > -1 then
       Begin
         Inc(NumToxs);
         ToxFound := ToxLoop
       End;
   End;

 If NumToxs = 0 then begin
                       MessageDlg('There is no Organic Toxicant in the current study.',mtInformation,[mbOK],0);
                       Exit;
                     end;

 If NumToxs > 0 then
   Begin
     Application.CreateForm(TChangeVarForm,ChangeVarForm);
     ChangeVarForm.Caption := 'Select a Variable to View';
     ChangeVarForm.EntryList.Items.Clear;
     NumToxs := 0;
     For ToxLoop := FirstOrgTox to LastOrgTox do
       Begin
         If LinkedSegmts.TemplateSeg.SV.GetIndex(ToxLoop,StV,WaterCol) > -1 then
           Begin
             SelTox[NumToxs] := ToxLoop;
             Inc(NumToxs);
             EntryStr := TStateVariable(LinkedSegmts.TemplateSeg.SV.GetStatePointer(ToxLoop,StV,WaterCol)).PName^;
             ChangeVarForm.EntryList.Items.Add(EntryStr);
           End;
       End;
     ChangeVarForm.EntryList.ItemIndex:=0;
     If ChangeVarForm.ShowModal = MrCancel Then
       Begin
         ChangeVarForm.Free;
         Exit;
       End;
     ToxFound := SelTox[ChangeVarForm.EntryList.ItemIndex];
     Changed_True;
     ChangeVarForm.Free;

   End;

  Application.CreateForm(TStateVarDialog, StateVarDialog);
  StateVarDialog.EditSV(LinkedSegmts.TemplateSeg.SV.GetStatePointer(ToxFound,StV,WaterCol),nil,nil);
  If StateVarDialog.Changed then Changed_True;

  StateVarDialog.Free;

  Show_LinkedSegmts_Info;
End;

procedure TLinkedForm.LoadPictureButtonClick(Sender: TObject);
begin
  If not OpenDialog1.Execute then exit;
  AssociatedMap.Picture.LoadFromFile(OpenDialog1.FileName);
  Panel1.Visible:= False;
  Changed_True;
  Show_LinkedSegmts_Info;
end;

procedure TLinkedForm.ClearMapButtonClick(Sender: TObject);
begin
  AssociatedMap.Picture.Bitmap.ReleaseHandle;
  Changed_True;
  Show_LinkedSegmts_Info;
end;

procedure TLinkedForm.ShowLinkButtonClick(Sender: TObject);
begin
  Show_LinkedSegmts_Info;
end;

procedure TLinkedForm.StudyNameEditBoxChange(Sender: TObject);
Begin
    if LinkedSegmts.SystemName<>StudyNameEditBox.Text then
          LinkedSegmts.SystemName:=StudyNameEditBox.Text;
End;

procedure TLinkedForm.SegIDChanged(PI: Pointer);

var Primary: TPrimaryInterface;
    MigrLoop,Loop2,SegCount: Integer;
    PAnml : TAnimal;
    PLnk  : TSegmentLink;
    AnmlLoop: AllVariables;
    PATS  : TAQUATOXSegment;
Begin
  Primary := PI;

  SegCount:=0;
  If Primary.AQTStudy.SegNumber <> Primary.OldSegID then
    Begin  {Ensure Segment ID is unique}
     For Loop2 := 0 to LinkedSegmts.SegmentColl.Count-1 do
       If LowerCase(Trim(Primary.AQTStudy.SegNumber))= TAQUATOXSegment(LinkedSegmts.SegmentColl.At(Loop2)).SegNumber
         Then Inc(SegCount);

     If SegCount>1 then
        Begin
          MessageDlg('You changed the segment ID to a non unique value.  Reverting to the old value.',
                      MtError,[MBOK],0);
          Primary.AQTStudy.SegNumber := Primary.OldSegID;
          Primary.Show_Study_Info;
          Exit;
        End;
    End;

     If Primary.AQTStudy.SegNumber <> Primary.OldSegID then {Fix Segment IDs}
        For Loop2 := 0 to LinkedSegmts.Links.Count-1 do
          Begin
            PLnk := LinkedSegmts.Links.At(Loop2);
            If (PLnk.FromID = Primary.OldSegID) then PLnk.FromID := Primary.AQTStudy.SegNumber;
            If (PLnk.ToID = Primary.OldSegID)   then PLnk.ToID   := Primary.AQTStudy.SegNumber;
          End;

      With LinkedSegmts do
       If Primary.AQTStudy.SegNumber <> Primary.OldSegID then {Fix Migration IDs}
        For Loop2 := 0 to SegmentColl.Count-1 do
          Begin
            PATS := SegmentColl.At(Loop2);
            For AnmlLoop := FirstAnimal to LastAnimal do
              Begin
                PAnml := PATS.SV.GetStatePointer(AnmlLoop,StV,Watercol);
                If PAnml<>nil then
                  For MigrLoop := 1 to 5 do
                    If PAnml.MigrInput[MigrLoop].ToSeg=Primary.OldSegID
                      Then PAnml.MigrInput[MigrLoop].ToSeg:= Primary.AQTStudy.SegNumber;
              End;
          End;

     Primary.OldSegID :=  Primary.AQTStudy.SegNumber;

End;



procedure TLinkedForm.EditButtonClick(Sender: TObject);
Var i, Loop, Loop2, SelectedIndex: Integer;
    PLnk  :TSegmentLink;
    PATS  : TAQUATOXSegment;
    Primary: TPrimaryInterface;
    bCreated: Boolean;

    Procedure SetPATSName;
    Begin
      PATS.Dirname  := LinkedSegmts.Dirname;
      PATS.Filename := LinkedSegmts.Filename;
      Delete(PATS.Filename,Length(PATS.Filename)-3,4);
      PATS.FileName := PATS.FileName+'_'+PATS.SegNumber+'.aps';
    End;

begin

  SelectedIndex := ListBox1.SelCount;
  If SelectedIndex < 0 then
      Begin
         MessageDlg('No State Variable is Selected.',mterror,[mbOK],0);
         Exit;
      End;

  If ShowSegmentButton.Checked then
    Begin
      {Multiple Item Selection Loop}
      For Loop:=0 to ListBox1.Items.Count-1 do
      If ListBox1.Selected[Loop] then
        Begin
          {Get the Index of the Segment in the Colection}
          SelectedIndex:= LinkedSegmts.SegIndexByID(ListBoxIDs[Loop]);

          {Error Checking}
          If SelectedIndex=-1 then
             Begin
                MessageDlg('AQUATOX Internal Error: Edit Item Missing Error',mterror,[mbOK],0);
                Exit;
             End;

          Primary := nil;
          bCreated:=False;
          for i:= 0 to ParentForm.MDIChildCount-1 do
          begin
            if ParentForm.MDIChildren[i] is TPrimaryInterface then
            begin
              Primary :=ParentForm.MDIChildren[i] as TPrimaryInterface;
              If (Primary.AQTStudy.SegNumber =
                  TAQUATOXSegment(LinkedSegmts.SegmentColl.At(SelectedIndex)).SegNumber) then
                Begin
                  bCreated:=True;
                  Break;
                End;
            end;
          end;

          If not bCreated then
            Begin
              PATS := LinkedSegmts.SegmentColl.At(SelectedIndex);
              SetPATSName;
              Primary := TPrimaryInterface.Create(Self,PATS);
              Primary.TitleLabel.Caption := 'Single Segment of "'+LinkedSegmts.SystemName+'"';
              Primary.LinkedPS := LinkedSegmts;
              Primary.Show_Study_Info;
            End;

          Primary.LinkedPS := LinkedSegmts;
          Primary.PNumSegs := @(LinkedSegmts.SegmentColl.Count);

          Primary.Show;
          Primary.SetFocus;

        End; {Multiple Item Loop}

    End; {Show Segment Button}

 If ShowLinkButton.Checked then
   Begin

      {Multiple Item Selection Loop}
      For Loop:=0 to ListBox1.Items.Count-1 do
      If ListBox1.Selected[Loop] then
        Begin
          {Get the Index of the Link in the Collection}
          SelectedIndex:=-1;
          For Loop2 := 0 to LinkedSegmts.Links.Count-1 do
            Begin
              PLnk := LinkedSegmts.Links.At(Loop2);
              If (PLnk.Name + ': From ['+PLnk.FromID+'] to ['+PLnk.ToID+']') = ListBox1.Items[Loop]
                then SelectedIndex := Loop2;
            End;

          {Error Checking}
          If SelectedIndex=-1 then
             Begin
                MessageDlg('AQUATOX Internal Error: Edit Item Missing Error',mterror,[mbOK],0);
                Exit;
             End;

          Application.CreateForm(TLinkForm,LinkForm);

          LinkForm.ToBox.Items.Clear;
          With LinkedSegmts do
            For Loop2 := 0 to SegmentColl.Count - 1 do
              Begin
                PATS := SegmentColl.At(Loop2);
                LinkForm.ToBox.Items.Add('['+ PATS.SegNumber + ']: '+PATS.StudyName);
                ListBoxIDs[Loop2] := PATS.SegNumber;
              End;

          LinkForm.FromBox.Items := LinkForm.ToBox.Items;
          PLnk := LinkedSegmts.Links.At(SelectedIndex);
          LinkForm.SedModelIncluded := LinkedSegmts.TemplateSeg.SV.SedModelIncluded;
          LinkForm.EditLink(PLnk, @ListBoxIDs);
          LinkForm.Free;
        End; {Multi Item Selection Loop}

     Show_LinkedSegmts_Info;
   End; {ShowLinkButton}

end;  {Edit Button Click Handle}


procedure TLinkedForm.EditTrophInt;

Begin
  Application.Createform(TEditTrophIntForm,EditTrophIntForm);
  EditTrophIntForm.AQTStudy := LinkedSegmts.TemplateSeg;
  EditTrophIntForm.EditTrophMatrix;
  If EditTrophIntForm.Changed then Changed_True;
  EditTrophIntForm.Free;
End;

procedure TLinkedForm.EditPlantLink;

Begin
  Application.Createform(TPlantLinksEdit,PlantLinksEdit);
  PlantLinksEdit.EditAllLinks(LinkedSegmts.TemplateSeg.SV);
  If PlantLinksEdit.Changed then Changed_true;
  PlantLinksEdit.Free;
End;


procedure TLinkedForm.ListBox1DblClick(Sender: TObject);
begin
  EditButtonClick(Sender);
end;

procedure TLinkedForm.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   If Key=VK_DELETE then DeleteButtonClick(Sender);
   If Key=VK_INSERT then AddButtonClick(Sender);
   If Key=VK_RETURN then EditButtonClick(Sender);
end;

procedure TLinkedForm.AddButtonClick(Sender: TObject);
Var NewSegID, NewSegName, CheckID: String;
    CopySegment, AddBlankSegment, LoadSegment: Boolean;
    PATS: TAQUATOXSegment;
    Loop: Integer;
    VersionCheck : String[10];
    ReadVers: Double;
    NewLink: TSegmentLink;

    Procedure PerformCopySegment;
    Var SegToCopy,NewSeg: TAQUATOXSegment;
        MemStream: TMemoryStream;
        ErrorMessage: String;
    Begin
      If LinkedSegmts.SegmentColl.Count=1
        then SegToCopy := LinkedSegmts.SegmentColl.At(0)
        else
          Begin
            Application.CreateForm(TChangeVarForm,ChangeVarForm);

            ChangeVarForm.Caption := 'Select a Segment to Copy';
            ChangeVarForm.EntryList.Items.Clear;
            {ChangeVarForm.NumToxs := 0; }
            ChangeVarForm.EntryList.Items := ListBox1.Items;
            ChangeVarForm.EntryList.ItemIndex:=0;
            If ChangeVarForm.ShowModal = MrCancel then
               Begin
                 ChangeVarForm.Free;
                 Exit;
               End;
            SegToCopy := LinkedSegmts.SegmentColl.At(ChangeVarForm.EntryList.ItemIndex);
          End;

        MemStream:=TMemoryStream.Create;
        TeaseScreen:=False;
        SegToCopy.SV.StoreResults := True;
        SegToCopy.SV.StoreDistribs := True;
        SegToCopy.Store(False,TStream(MemStream));    {Store Collection in memory}
        VersionNum:=StrToFloat(AbbrString(VersionStr,' '));
        ReadVers:=VersionNum;         {Get Correct Version Num for Read}

        MemStream.Seek(0, soFromBeginning); {Go to beginning of stream}
        MemStream.Read(VersionCheck,Sizeof(VersionCheck));
        NewSeg:=TAQUATOXSegment.Load(True,False,TStream(MemStream),ReadVers,True,True); {Call Load Method}
        MemStream.Destroy;

        NewSeg.ShowTemplate(LinkedSegmts.TemplateSeg, ErrorMessage,True,False);

        If ErrorMessage<>'' then
           Begin
             MessageDlg('AQUATOX unexpectedly Got Error: '+ErrorMessage+' while copying the segment',
                         MTError, [mbok], 0);
             Exit;
           End;

        NewSeg.SegNumber := NewSegID;
        NewSeg.StudyName := NewSegName;
        NewSeg.SV.LinkedMode := True;
        LinkedSegmts.SegmentColl.Insert(NewSeg);
        LinkedSegmts.ClearAllResults(0);
    End;

    Procedure PerformAddBlank;
    Var SegToCopy,NewSeg: TAQUATOXSegment;
        MemStream: TMemoryStream;
        ErrorMessage: String;
        VLoop: VerticalSegments;
        i: Integer;
        PSV: TStateVariable;
        LLoop: Alt_LoadingsType;
        ReadVers: Double;
    Begin
      SegToCopy := LinkedSegmts.SegmentColl.At(0);

      MemStream:=TMemoryStream.Create;
      TeaseScreen:=False;
      SegToCopy.SV.StoreResults := True;
      SegToCopy.SV.StoreDistribs := True;
      SegToCopy.Store(False,TStream(MemStream));    {Store Collection in memory}
      VersionNum:=StrToFloat(AbbrString(VersionStr,' '));
      ReadVers:=VersionNum;         {Get Correct Version Num for Read}
      MemStream.Seek(0, soFromBeginning); {Go to beginning of stream}
      MemStream.Read(VersionCheck,Sizeof(VersionCheck));
      NewSeg:=TAQUATOXSegment.Load(True,False,TSTream(MemStream),ReadVers,True,True); {Call Load Method}
      MemStream.Destroy;

      NewSeg.ShowTemplate(LinkedSegmts.TemplateSeg, ErrorMessage,True,False);

      If ErrorMessage<>'' then
         Begin
           MessageDlg('AQUATOX unexpectedly Got Error: '+ErrorMessage+' while creating a blank segment',
                       MTError, [mbok], 0);
           Exit;
         End;

      NewSeg.SegNumber := NewSegID;
      NewSeg.StudyName := NewSegName;

      {Blank Out Study}
      NewSeg.Filename := '';
      NewSeg.Dirname := Studies_Dir;

      For VLoop:=Epilimnion to Hypolimnion do
       Begin
         NewSeg.SV.Results[vloop].FreeAll;
         NewSeg.SV.ControlResults[vloop].FreeAll;
         NewSeg.LastRun      := -1;
         NewSeg.ControlRun   := -1;
       End;

      NewSeg.NewNotes := TStringList.Create;
      NewSeg.Location.Locale.SiteName := '';
      NewSeg.SV.LinkedMode := True;

      For i := 0 to NewSeg.SV.Count-1 do
        Begin
          PSV := NewSeg.Sv.At(i);
          With PSV do
            Begin
              InitialCond:=0;
              State:=0;
              RateColl  := nil;
              LoadNotes1 := '';
              LoadNotes2 := '';
              With LoadsRec do     {Set up Loadings Data}
                 begin
                   Loadings.Destroy;
                   Loadings:=TLoadings.Init(10,20);
                   ConstLoad:=0;
                   MultLdg := 1.0;
                   UseConstant:=True;

                   For LLoop:=PointSource to NonPointSource do
                     begin
                       If Has_Alt_Loadings(nstate,SVType,Layer) then
                          Alt_Loadings[LLoop] :=TLoadings.Init(10,20) else Alt_Loadings[LLoop]:=nil;
                       Alt_ConstLoad[LLoop]   :=0;
                       Alt_UseConstant[LLoop] :=True;
                       Alt_MultLdg[LLoop]     :=1.0;
                     end;
                 end; {With LoadsRec}
            End;
        End;
      LinkedSegmts.SegmentColl.Insert(NewSeg);
      LinkedSegmts.ClearAllResults(0);
    End;

    Procedure PerformLoadSegment;
    Var NewSegment: TAQUATOXSegment;
        ErrorMessage: String;
        OpenDialog: TAQTOpenDialog;

    Begin
      MessageDlg('The new study you are loading must have exactly the same state variable list as the '+
                 'studies in the current linked system.',MtInformation,[MBOK],0);

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

      NewSegment := nil;
      Try  LoadFile(NewSegment,OpenDialog.FileName);  {Load the study as the template}

      NewSegment.ShowTemplate(LinkedSegmts.TemplateSeg, ErrorMessage,True,False);
      If ErrorMessage<>'' then
        Begin
          MessageDlg('There is a difference between the study being loaded and the linked studies: '+
                      ErrorMessage+' This study therefore cannot be added.',MTError,[MBOK],0);
          NewSegment := nil;
          WaitDlg.Hide;
          Exit;
        End;

      Except
        MessageDlg('Exception Raised while loading new segment',MTError,[MBOK],0);
        MessageDlg(Exception(ExceptObject).Message,mterror,[mbOK],0);
        WaitDlg.Hide;
        Exit;
      End;

      NewSegment.SegNumber := NewSegID;
      NewSegment.SV.LinkedMode := True;

      LinkedSegmts.SegmentColl.Insert(NewSegment);
      LinkedSegmts.ClearAllResults(0);

      WaitDlg.Hide;
    End;

begin
  If ShowSegmentButton.Checked then
    Begin
      Application.CreateForm(TAddSegForm,AddSegForm);
      With AddSegForm do
        Begin
          StudyNameEditBox.Text :='New Segment';
          SegNumTextBox.Text := '';
          If ShowModal=MrCancel then
            Begin
              AddSegForm.Free;
              exit;
            End;
          NewSegID := SegNumTextBox.Text;
          NewSegName := StudyNameEditBox.Text;
          CopySegment := CopySegButt.Checked;
          AddBlankSegment := Addblankbutt.Checked;
          LoadSegment := LoadSegButt.Checked;
        End;

      If NewSegID='' then
        Begin
          MessageDlg('You must enter a unique and Non-Blank Segment ID for your new segment',MtError,[MBOK],0);
          AddSegForm.Free;
          AddButtonClick(nil);
          Exit;
        End;

      For Loop := 0 to LinkedSegmts.SegmentColl.Count-1 do
        Begin
          PATS := LinkedSegmts.SegmentColl.At(Loop);
          CheckID := PATS.SegNumber;
          If Lowercase(Trim(CheckID))=LowerCase(Trim(NewSegID)) then
            Begin
              MessageDlg('The Segment ID you entered is not unique.',MtError,[MBOK],0);
              AddSegForm.Free;
              Exit;
            End;
        End;

      If CopySegment then PerformCopySegment;
      If AddBlankSegment then PerformAddBlank;
      If LoadSegment then PerformLoadSegment;

      Show_LinkedSegmts_Info;
      AddSegForm.Free;
    End;  {Add Segment Code}

  If ShowLinkButton.Checked then
      Begin
        If LinkedSegmts.SegmentColl.Count<2 then
          Begin
            MessageDlg('There are not two segments to link.',MtError,[MBOK],0);
            Exit;
          End;

        Application.CreateForm(TLinkForm,LinkForm);
        LinkForm.ToBox.Items.Clear;
        With LinkedSegmts do
          For Loop := 0 to SegmentColl.Count - 1 do
            Begin
              PATS := SegmentColl.At(Loop);
              LinkForm.ToBox.Items.Add('['+ PATS.SegNumber + ']: '+PATS.StudyName);
              ListBoxIDs[Loop] := PATS.SegNumber;
            End;

        LinkForm.FromBox.Items := LinkForm.ToBox.Items;
        NewLink := TSegmentLink.Init('New Link');
        LinkForm.SedModelIncluded := LinkedSegmts.TemplateSeg.SV.SedModelIncluded;
        If LinkForm.EditLink(NewLink, @ListBoxIDs) then LinkedSegmts.Links.Insert(NewLink);
        LinkForm.Free;

        Show_LinkedSegmts_Info;
      End; {Add Link Code}
end;

procedure TLinkedForm.DeleteButtonClick(Sender: TObject);
Var Loop, Loop2, SelectedIndex: Integer;
    PLnk: TSegmentLink;
    PATS: TAQUATOXSegment;

begin
  SelectedIndex := ListBox1.SelCount;
  If SelectedIndex < 0 then
      Begin
         MessageDlg('No Segment or Link is Selected.',mterror,[mbOK],0);
         Exit;
      End;

  If ShowSegmentButton.Checked then
    Begin
      {Multiple Item Selection Loop}
      For Loop:=0 to ListBox1.Items.Count-1 do
      If ListBox1.Selected[Loop] then
        Begin
          {Get the Index of the Segment in the Collection}
          SelectedIndex:= LinkedSegmts.SegIndexByID(ListBoxIDs[Loop]);

          {Error Checking}
          If SelectedIndex=-1 then
             Begin
                MessageDlg('AQUATOX Internal Error: Edit Item Missing Error',mterror,[mbOK],0);
                Exit;
             End;

          If MessageDlg('Delete Segment '+ListBox1.Items.Strings[Loop]+' and all associated links (and any associated "tributary-input" segments)?',
                         MTConfirmation,[mbyes,mbcancel],0) = mrYes then
            Begin
              If LinkedSegmts.SegmentColl.Count=1
                then begin
                       MessageDlg('Error, You must have at least one segment in a linked study.',
                                   MTError,[mbOK],0);
                       Show_LinkedSegmts_Info;
                       Exit;
                     End;

               Changed_True;
               LinkedSegmts.SegmentColl.AtFree(SelectedIndex);

               For Loop2 := LinkedSegmts.Links.Count-1 downto 0 do
                 Begin  {Delete Associated Links}
                   PLnk := LinkedSegmts.Links.At(Loop2);
                   If (PLnk.FromID = ListBoxIDs[Loop])
                      then LinkedSegmts.Links.AtFree(Loop2);
                   If (PLnk.ToID = ListBoxIDs[Loop])
                      then Begin
                             PATS := LinkedSegmts.SegmentByID(PLnk.FromID);  {ID and delete pass through segs.}
                             If PATS.Location.SiteType = TribInput then
                                LinkedSegmts.SegmentColl.AtFree(LinkedSegmts.SegIndexByID(PLnk.FromID));
                             LinkedSegmts.Links.AtFree(Loop2);
                           End;
                 End;

            End;
        End;
    End; {ShowSegment}

  If ShowLinkButton.Checked then
    Begin
      {Multiple Item Selection Loop}
      For Loop:=0 to ListBox1.Items.Count-1 do
      If ListBox1.Selected[Loop] then
        Begin
          {Get the Index of the Link in the Collection}
          SelectedIndex:=-1;
          For Loop2 := 0 to LinkedSegmts.Links.Count-1 do
            Begin
              PLnk := LinkedSegmts.Links.At(Loop2);
              If (PLnk.Name + ': From ['+PLnk.FromID+'] to ['+PLnk.ToID+']') = ListBox1.Items[Loop]
                then SelectedIndex := Loop2;
            End;

          {Error Checking}
          If SelectedIndex=-1 then
             Begin
                MessageDlg('AQUATOX Internal Error: Edit Item Missing Error',mterror,[mbOK],0);
                Exit;
             End;

          If MessageDlg('Delete '+ListBox1.Items.Strings[Loop]+'?',
                         MTConfirmation,[mbyes,mbcancel],0) = mrYes
             Then LinkedSegmts.Links.AtFree(SelectedIndex);
        End;
    End; {ShowLinks}

   Show_LinkedSegmts_Info;
end;

Procedure TLinkedForm.BorrowParameters;
Var InputStudy: TAquatoxSegment;
    Err: String;
    OpenDialog: TAQTOpenDialog;
    i: Integer;
    AQTStudy: TAQUATOXSegment;
    CopyInitCond: Boolean;

Begin
   If MessageDlg('Please save first:  The new study you are loading must have exactly the same state variable list as the '+
                 'studies in the current linked system or your original study may be corrupted.',MtInformation,[MBOK, MBCancel],0) = MRCancel then exit;

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

   LinkedSegmts.TemplateSeg.TakeParameters(InputStudy,Err,CopyInitCond);

   If Err='' then
     For i := 0 to LinkedSegmts.SegmentColl.Count-1 do
       Begin
         AQTStudy := LinkedSegmts.SegmentColl.At(i);
         AQTStudy.ShowTemplate(LinkedSegmts.TemplateSeg, Err,False,CopyInitCond);
       End;

    If Err<>'' then
      Begin
        MessageDlg('There is a difference between the input study and the main linked system: '+
                    Err+' To avoid corruption, simulation is being closed.',MTError,[MBOK],0);
        InputStudy := nil;

        LinkedSegmts.Destroy;
        LinkedSegmts := nil;
        WaitDlg.Hide;
        LinkedForm.Close;
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





procedure TLinkedForm.Button1Click(Sender: TObject);
Var ExcelCol, i,j,k: Integer;
    AQTStudy: TAQUATOXSegment;
{    OutFile: TextFile; }
    TEx: TExcelOutput;
    BaseName: String;

Begin


       BaseName := {Output_Dir + }'ExtData.xls';

      // Execute save dialog
      TEx := TExcelOutput.Create(False);
      If TEx.GetSaveName(BaseName,'Please Specify an Excel File into which to Save these Data:') then
      begin

       WaitDlg.Setup('Please Wait, Writing Table to Excel File');

       ExcelCol := 1;
       For i := 0 to LinkedSegmts.SegmentColl.Count-1 do
         Begin
            AQTStudy := LinkedSegmts.SegmentColl.At(i);
            With AQTStudy.SV.ObservedData do
              For j := 0 to NumSeries-1 do
               With OSeries[j] do
                Begin
                  WaitDlg.Tease;
                  TEx.WS.Cells.Item[1,ExcelCol].Value := NameStr;
                  TEx.WS.Cells.Item[1,ExcelCol+1].Value := UnitStr;

                  TEx.WS.Cells.Item[2,ExcelCol].Value := AQTStudy.SegNumber;
                  TEx.WS.Cells.Item[2,ExcelCol+1].Value := 'n='+IntToStr(NumRecs);
                  TEx.WS.Cells.Item[3,ExcelCol].Value := Comment;
                  TEx.WS.Cells.Item[4,ExcelCol].Value := 'Date';
                  TEx.WS.Cells.Item[4,ExcelCol+1].Value := 'Vals';
                  If HasNDs then TEx.WS.Cells.Item[4,ExcelCol+2].Value := 'NDs';
                  For k := 0 to NumRecs -1 do
                    Begin
                      WaitDlg.Tease;
                      TEx.WS.Cells.Item[5+k,ExcelCol].Value := ObsDates[k];
                      TEx.WS.Cells.Item[5+k,ExcelCol+1].Value := ObsVals[k];
                      If HasNDs then
                          Case NDFlag[k] of
                            0: TEx.WS.Cells.Item[5+k,ExcelCol+2].Value := '';
                            1: TEx.WS.Cells.Item[5+k,ExcelCol+2].Value := '<';
                            else TEx.WS.Cells.Item[5+k,ExcelCol+2].Value := '>';
                          End; {Case}
                    End;

                  Inc(ExcelCol);Inc(ExcelCol);
                  If HasNDs then Inc(ExcelCol);
                End;
         End;

       TEx.SaveAndClose
      End;

   WaitDlg.Hide;
{  AssignFile(Outfile,'c:\newtemp\ObsSum.csv');
  Rewrite(outfile);
  Writeln(Outfile,'"Seg ID","Series Name","Units","n=","Comment"');
  For i := 0 to LinkedSegmts.SegmentColl.Count-1 do
    Begin
       AQTStudy := LinkedSegmts.SegmentColl.At(i);
       With AQTStudy.SV.ObservedData do
         For j := 0 to NumSeries-1 do
          With OSeries[j] do
           Begin
             Write(OutFile,'"',AQTStudy.SegNumber,'",');
             Write(OutFile,'"',NameStr,'",');
             Write(OutFile,'"',UnitStr,'",');
             Write(OutFile,'"',NumRecs,'",');
             Write(OutFile,'"',Comment,'",');
             Writeln(OutFile);
           End;
    End;
  WordInitialized := False; }

end;

procedure TLinkedForm.ClearResults1Click(Sender: TObject);
Var ClearMode: Integer;
begin
   Application.CreateForm(TClearResForm,ClearResForm);
   If ClearResForm.ShowModal = MRCancel then Exit;

   ClearMode := 0;
   If ClearResForm.ClearCtrl.Checked then ClearMode := 1;
   If ClearResForm.ClearPert.Checked then ClearMode := 2;
   ClearResForm.Free;

   LinkedSegmts.ClearAllResults(ClearMode);
   Show_LinkedSegmts_Info;
end;


procedure TLinkedForm.Uncertainty1Click(Sender: TObject);
begin
  CreateSetupForms;
  USetupForm.OrigRecord :=LinkedSegmts.TemplateSeg.PUncertainty;

  USetupForm.PassVars(LinkedSegmts.TemplateSeg.PUncertainty,LinkedSegmts.TemplateSeg.SV,LinkedSegmts.TemplateSeg,LinkedSegmts,True);
  LinkedSegmts.Update_Distributions;

  USetupForm.Edit_USetup;

  If USetupForm.Changed or USetupForm.DistChanged then Changed_True;
  DestroySetupForms;
  Show_LinkedSegmts_Info;
end;

procedure TLinkedForm.UpBtnClick(Sender: TObject);
Var Loop,SelectedIndex: Integer;
    P: Pointer;
    Down : Boolean;
    TC: TCollection;
    Increment : Integer;
    Start, Finish: Integer;
    SelArr: Array of Boolean;
begin
  SetLength(SelArr,ListBox1.Count);
  For Loop := 0 to ListBox1.Count-1 do SelArr[Loop] := False;

  Down := TButton(Sender).Name[1]='D' {DownButton};
  If Down then Increment := 1 else Increment := -1;  {direction of movement}
  If Down then Start := ListBox1.Items.Count-2 else Start := 1;
  If Down then Finish := -1 else Finish := ListBox1.Items.Count;


  SelectedIndex := ListBox1.SelCount;
  If SelectedIndex <= 0 then
      Begin
         MessageDlg('No List Item is Selected.',mterror,[mbOK],0);
         Exit;
      End;

  If ShowSegmentButton.Checked
    then TC := LinkedSegmts.SegmentColl
    else TC := LinkedSegmts.Links;

  Loop := Start;
  Repeat
    If ListBox1.Selected[Loop] then
      With TC do
        Begin
          p := Items[Loop];
          Items[Loop] := Items[Loop+Increment];
          Items[Loop+Increment] := p;
          SelArr[Loop+Increment] := True;
          Changed_True;
        End;
    Loop := Loop - Increment;
  Until Loop=Finish;;
  Show_LinkedSegmts_Info;

  For Loop := 0 to ListBox1.Count-1 do ListBox1.Selected[Loop] := SelArr[Loop];
  SelArr := nil;
end;

procedure TLinkedForm.RateSavingInformation1Click(Sender: TObject);
begin
  CreateSetupForms;
  RSetupForm.Edit_RSetup(LinkedSegmts.TemplateSeg.SV.PRateInfo^, LinkedSegmts.TemplateSeg.SV);
  DestroySetupForms;
end;

procedure TLinkedForm.ControlRunSetup1Click(Sender: TObject);
begin
  CreateSetupForms;
  ControlForm.Edit_Control(LinkedSegmts.TemplateSeg.SV.PControlInfo^, LinkedSegmts.TemplateSeg.SV);

  DestroySetupForms;
end;

(* Procedure TLinkedForm.SetupDebugScreen;
Var Loop: Integer;
    PATS: TAQUATOXSegment;
Begin
  With LinkedSegmts do
   With DebugScreen do
    Begin
      Finalize(PPStatesArray);
      NumSegs := SegmentColl.Count;
      SegBox.Items.Clear;

      SetLength(PPStatesArray,NumSegs);

      For Loop := 0 to SegmentColl.Count - 1 do
        Begin
          PATS := TAQUATOXSegment(SegmentColl.At(Loop));
          PPStatesArray[Loop] := @(PATS.SV);
          SegBox.Items.Add('['+ PATS.SegNumber + ']: '+PATS.StudyName);
        End;

      SegBox.ItemIndex := 0;
    End;
End; *)

procedure TLinkedForm.RunBitBtnClick(Sender: TObject);
begin
  ExecuteSimulation(False);
end;

procedure TLinkedForm.ControlButtClick(Sender: TObject);

begin
  ExecuteSimulation(True);
end;

procedure TLinkedForm.OutputBitBtnClick(Sender: TObject);
Var OLS: TLinkedSegs;
    TOS: TOutputScreen;
begin
  If (LinkedSegmts.ControlRun = -2) or (LinkedSegmts.LastRun=-2)
    Then
      Begin
        MessageDlg('No "Partial" runs are permitted when viewing Linked Results.  Use '+
                   '"Clear Results" in the Segment Menu if necessary',mtError,[mbOK],0);
      End
    Else
      Begin

        WaitDlg.Setup('Please Wait, Creating Output Screen');

        OLS := CopyTheStudy(True);

        If OLS=nil then
           Begin
             WaitDlg.Hide;
             exit;
           End;

        OLS.TemplateSeg.Unc_Dir  := '';
        OLS.TemplateSeg.Unc_File := '';
        OLS.TemplateSeg.Unc_Ext  := '';
        OLS.TemplateSeg.SV.LinkedMode := True;

        If OLS=nil then
           Begin
             WaitDlg.Hide;
             Exit;
           End;

        TOS := TOutputScreen.Create(Parent,OLS.TemplateSeg,LinkedSegmts.TemplateSeg, OLS,LinkedSegmts);
        TOS.SetFocus;
      End;
end;

procedure TLinkedForm.ExportButtonClick(Sender: TObject);
Var AQTS: TAQUATOXSegment;
    ControlRes: Boolean;
begin
  AQTS := LinkedSegmts.SegmentColl.At(0);
  If (AQTS.SV.Results[Epilimnion].Count<=0) and (AQTS.SV.ControlResults[Epilimnion].Count<=0) then
          begin
            MessageDlg('There Are No Results To Export.',mtError,[mbok],0);
            Exit;
          end;

  If (AQTS.SV.Results[Epilimnion].Count<=0)
    then controlres := True
    else If (AQTS.SV.ControlResults[Epilimnion].Count<=0)
      then ControlRes := False
      else ControlRes := MessageDlg('Export Perturbed Results? (as opposed to Control Results)',
                             mtconfirmation,[mbyes,mbno],0) = mrno;

  If ((LinkedSegmts.ControlRun = -2) and (ControlRes)) or
     ((LinkedSegmts.LastRun=-2) and (Not ControlRes))
    Then
      Begin
        MessageDlg('No "Partial" runs are permitted when exporting Linked Results.',mtError,[mbOK],0);
      End
    Else
      Begin
        Update;
        ExportLinkedResults(SaveDialog1,ControlRes,LinkedSegmts,ExportTable,'');
        Show_LinkedSegmts_Info;
      End;
end;

procedure TLinkedForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If LinkedSegmts=nil then
    Begin
      CanClose := True;
      Exit;
    End;

  If LinkedSegmts.SimsRunning>0 then
    Begin
      MessageDlg('You Cannot Close a Study While it is Running',mtinformation,[mbok],0);
      CanClose := False;
      Exit;
    End;

  CanClose := True;
  SaveSuccess := True;
  if Check_Save_and_Cancel('closing') or (not savesuccess) then CanClose := False;
  With LinkedSegmts do
  If CanClose then ParentForm.UpdateRecentlyUsed(TemplateSeg,DirName,FileName);

end;

procedure TLinkedForm.UMAfterActive(var Message: TMessage);
begin
   Display_Modlabel;

   If LinkedSegmts = nil
     then ParentForm.UpdateMenu(nil)
     else ParentForm.UpdateMenu(LinkedSegmts.TemplateSeg);

   Update;
end;

procedure TLinkedForm.FormActivate(Sender: TObject);
begin
   PostMessage(Handle, UM_AFTERACTIVE, 0, LongInt(Sender));
end;

procedure TLinkedForm.Export_to_2_2;
Var DN, FN: ShortString;
    NS: AllVariables;
    PA: TAnimal;
    PP: TPlant;
Begin
  If not Library_File1.ReturnDBName('Animal',DN,FN) then exit;
  With LinkedSegmts.TemplateSeg.SV do
   For ns := FirstAnimal to LastAnimal do
    If GetStatePointer(ns,StV,WaterCol)<>nil then
      Begin
        PA := GetStatePointer(ns,StV,WaterCol);
        AnimalRecord_To_2_2_Dbase(DN,FN,PA.PAnimalData^.AnimalName,PA.PAnimalData^);
      End;

  If not Library_File1.ReturnDBName('Plant',DN,FN) then exit;
  With LinkedSegmts.TemplateSeg.SV do
   For ns := FirstPlant to LastPlant do
    If GetStatePointer(ns,StV,WaterCol)<>nil then
      Begin
        PP := GetStatePointer(ns,StV,WaterCol);
        PlantRecord_To_2_2_Dbase(DN,FN,PP.PAlgalRec.PlantName,PP.PAlgalRec^);
      End;

  MessageDlg('Export Completed Successfully',mtinformation,[mbok],0);
End;


procedure TLinkedForm.Export_to_3;
Var DN, FN: ShortString;
    NS: AllVariables;
    PA: TAnimal;
    PP: TPlant;
Begin
  If not Library_File1.ReturnDBName('Animal',DN,FN) then exit;
  With LinkedSegmts.TemplateSeg.SV do
   For ns := FirstAnimal to LastAnimal do
    If GetStatePointer(ns,StV,WaterCol)<>nil then
      Begin
        PA := GetStatePointer(ns,StV,WaterCol);
        AnimalRecord_To_Dbase(DN,FN,PA.PAnimalData^.AnimalName,PA.PAnimalData^,False);
      End;

  If not Library_File1.ReturnDBName('Plant',DN,FN) then exit;
  With LinkedSegmts.TemplateSeg.SV do
   For ns := FirstPlant to LastPlant do
    If GetStatePointer(ns,StV,WaterCol)<>nil then
      Begin
        PP := GetStatePointer(ns,StV,WaterCol);
        PlantRecord_To_Dbase(DN,FN,PP.PAlgalRec.PlantName,PP.PAlgalRec^);
      End;

  MessageDlg('Export Completed Successfully',mtinformation,[mbok],0);
End;


Procedure TLinkedForm.ExportLinkedParmsToText;
Var   SaveDialog : TSaveDialog ;
      BaseName: String;
      LogFile: TextFile;
begin
{   SaveDialog := nil; }

   try
      // Create save dialog and set it options
      SaveDialog := TSaveDialog.Create(Self) ;
      with SaveDialog do
      begin
         DefaultExt := 'txt' ;
         Filter := 'Text file (*.txt)|*.txt|All files (*.*)|*.*' ;
         BaseName := LinkedSegmts.FileName;
         Delete(BaseName,Length(BaseName)-3,4);
         FileName := LinkedSegmts.DirName + BaseName + '_Text.txt';
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
        LinkedSegmts.WriteText(LogFile);
        MessageDlg('Text Export Complete.',mtinformation,[mbok],0);
        CloseFile(LogFile);
      End;
   except
     MessageDlg('Error Exporting to Text.',mterror,[mbok],0);
     CloseFile(LogFile);
     Raise;
   end;

end;


end.
