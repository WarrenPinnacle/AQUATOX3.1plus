//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Parent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, FileCtrl,
  Menus, ExtCtrls, ToolWin, ComCtrls, Global, AQStudy, Librarys2, Main, IniFiles, Progress,
  Basins, Registry, ImgList, AQUAOBJ, AQBaseForm, LinkedInterface, Db, BDE, DBIProcs,
  DBTables, ActiveX, WinHelpViewer2 ;

type
  TParentForm = class(TAQBase)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Close1: TMenuItem;
    SaveAs1: TMenuItem;
    ExportResults1: TMenuItem;
    ExportControlResults1: TMenuItem;
    N5: TMenuItem;
    Print1: TMenuItem;
    PrintSetup1: TMenuItem;
    N4: TMenuItem;
    RunBatch1: TMenuItem;
    Exit1: TMenuItem;
    N12: TMenuItem;
    RF1: TMenuItem;
    RF2: TMenuItem;
    RF3: TMenuItem;
    RF4: TMenuItem;
    RF5: TMenuItem;
    View1: TMenuItem;
    ShowToolbar1: TMenuItem;
    HideToolbar1: TMenuItem;
    N11: TMenuItem;
    EditToolbar1: TMenuItem;
    Library1: TMenuItem;
    Animals1: TMenuItem;
    Chemicals1: TMenuItem;
    Plants1: TMenuItem;
    Sites1: TMenuItem;
    Remineralization1: TMenuItem;
    N2: TMenuItem;
    LibraryHelp1: TMenuItem;
    Study1: TMenuItem;
    InitialCondition1: TMenuItem;
    Chemical1: TMenuItem;
    Site1: TMenuItem;
    Setup1: TMenuItem;
    Notes1: TMenuItem;
    N6: TMenuItem;
    Run1: TMenuItem;
    Control1: TMenuItem;
    Output1: TMenuItem;
    N9: TMenuItem;
    AddSV: TMenuItem;
    N10: TMenuItem;
    Uncertainty1: TMenuItem;
    Rate1: TMenuItem;
    ControlSetup1: TMenuItem;
    ClearResults1: TMenuItem;
    Help1: TMenuItem;
    Contents1: TMenuItem;
    Tutorial1: TMenuItem;
    N8: TMenuItem;
    About1: TMenuItem;
    ToolBar: TToolBar;
    Save1: TMenuItem;
    CloseAll1: TMenuItem;
    Window: TMenuItem;
    Tile1: TMenuItem;
    Cascade1: TMenuItem;
    PrinterSetupDialog1: TPrinterSetupDialog;
    ImageList1: TImageList;
    Panel1: TPanel;
    Image1: TImage;
    EditwithWizard1: TMenuItem;
    N1: TMenuItem;
    ShowBigButtons1: TMenuItem;
    ExportToGenscn: TMenuItem;
    EditTrophicInteractions1: TMenuItem;
    ImportDatafromSWAT1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SetEditColor1: TMenuItem;
    ColorDialog1: TColorDialog;
    Sediment1: TMenuItem;
    AddNonReactiveSedLayer1: TMenuItem;
    N7: TMenuItem;
    RemoveBuriedSedLayer1: TMenuItem;
    AddBuriedSedLayer1: TMenuItem;
    N13: TMenuItem;
    RemoveSedimentModel1: TMenuItem;
    AddSedimentModel1: TMenuItem;
    N14: TMenuItem;
    NewLinkedSimulation1: TMenuItem;
    Shorebirds1: TMenuItem;
    Exportto21Databases1: TMenuItem;
    ExportParametersAsText1: TMenuItem;
    SaveDialog1: TSaveDialog;
    AddaNewLibrary1: TMenuItem;
    N3: TMenuItem;
    ExporttoRel3Databases1: TMenuItem;
    ExportTable: TTable;
    N15: TMenuItem;
    AddSedimentDiagenesis1: TMenuItem;
    RemoveSedimentDiagenesis1: TMenuItem;
    ExportAllGraphstoMSWord1: TMenuItem;
    AddTimeseriesfromExcel1: TMenuItem;
    EditAllPlantLinkages1: TMenuItem;
    akeParametersfromAnotherStudy1: TMenuItem;
    ImportWDM: TMenuItem;
    N16: TMenuItem;
    AddSandSiltClayModel1: TMenuItem;
    RemoveSandSiltClayModel1: TMenuItem;
    procedure Contents1Click(Sender: TObject);
    procedure Tutorial1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure InitialCondition1Click(Sender: TObject);
    procedure Site1Click(Sender: TObject);
    procedure Setup1Click(Sender: TObject);
    procedure Notes1Click(Sender: TObject);
    procedure Run1Click(Sender: TObject);
    procedure Control1Click(Sender: TObject);
    procedure Output1Click(Sender: TObject);
    procedure AddSVClick(Sender: TObject);
    procedure Uncertainty1Click(Sender: TObject);
    procedure Rate1Click(Sender: TObject);
    procedure ControlSetup1Click(Sender: TObject);
    procedure ClearResults1Click(Sender: TObject);
    procedure Animals1Click(Sender: TObject);
    procedure Chemicals1Click(Sender: TObject);
    procedure Plants1Click(Sender: TObject);
    procedure Sites1Click(Sender: TObject);
    procedure Remineralization1Click(Sender: TObject);
    procedure LibraryHelp1Click(Sender: TObject);
    procedure ShowToolbar1Click(Sender: TObject);
    procedure HideToolbar1Click(Sender: TObject);
    procedure EditToolbar1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure WizButtonClick(Sender: TObject);
    procedure ExportResults1Click(Sender: TObject);
    procedure ExportControlResults1Click(Sender: TObject);
    procedure PrintSetup1Click(Sender: TObject);
    procedure RecentlyUsedClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolBarDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ToolBarDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormCreate(Sender: TObject);  
    procedure CloseAll1Click(Sender: TObject);
    procedure Tile1Click(Sender: TObject);
    procedure Cascade1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Exit1Click(Sender: TObject);
    procedure EditwithWizard1Click(Sender: TObject);
    procedure ShowBigButtons1Click(Sender: TObject);
    procedure EnterWizard1Click(Sender: TObject);
    procedure Chemical1Click(Sender: TObject);
    procedure ExportToGenscnClick(Sender: TObject);
    procedure EditTrophicInteractions1Click(Sender: TObject);
    procedure ImportDatafromSWAT1Click(Sender: TObject);
    procedure RunBatch1Click(Sender: TObject);
    procedure SetEditColor1Click(Sender: TObject);
    procedure AddSedimentModel1Click(Sender: TObject);
    procedure RemoveSedimentModel1Click(Sender: TObject);
    procedure AddBuriedSedLayer1Click(Sender: TObject);
    procedure RemoveBuriedSedLayer1Click(Sender: TObject);
    procedure AddNonReactiveSedLayer1Click(Sender: TObject);
    procedure NewLinkedSimulation1Click(Sender: TObject);
    procedure Shorebirds1Click(Sender: TObject);
    procedure Exportto21Databases1Click(Sender: TObject);
    procedure ExportParametersAsText1Click(Sender: TObject);
    procedure AddaNewLibrary1Click(Sender: TObject);
    procedure ExporttoRel3Databases1Click(Sender: TObject);
    procedure AddSedimentDiagenesis1Click(Sender: TObject);
    procedure ExportAllGraphstoMSWord1Click(Sender: TObject);
    procedure RemoveSedimentDiagenesis1Click(Sender: TObject);
    procedure AddTimeseriesfromExcel1Click(Sender: TObject);
    procedure EditAllPlantLinkages1Click(Sender: TObject);
    procedure akeParametersfromAnotherStudy1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ImportWDMClick(Sender: TObject);
    procedure AddSandSiltClayModel1Click(Sender: TObject);
    procedure RemoveSandSiltClayModel1Click(Sender: TObject);
  private
    FHWnd: THandle;
    procedure WndProc(var Msg: TMessage);  //disable for reportmemoryleaks  1/21/2011
    Function SimulationRunning: Boolean;
  public
    ShowBigButtons: Boolean;
    IncomingFile: String;
    MUST_WAIT: Boolean;  {user must wait while studies are being loaded or saved, 8/24/2009}
    Function CheckValidForm:Boolean;
    Function OpenFile(Nm: String): Boolean;
    Procedure SteinHausExport(St: String; OutputStudy: TAQUATOXSegment);
    Procedure BeforeDestruction;  Override;
    Procedure UpdateMenu(ThisStudy: TAQUATOXSegment);
    Procedure UpdateWForm;
    Procedure WriteIniFileData;
    Procedure ReadIniFileData;
    Procedure EnableDisableToolbar(CStudy : TAQUATOXSegment);
    Procedure SetToolbarMenuItems;
    Function  ToolButtonCreate(Index: Integer): TToolButton;
    Function  CompressFileN(FN,DR:String): String;
    Procedure UpdateRecentlyUsed(ClosingStudy: TAQUATOXSegment; DirN,FileN: String);
    Function  FindActiveStudy: TAQUATOXSegment;
    Function  GetStudyForm: TPrimaryInterface;
    Function  GetLinkForm: TLinkedForm;
    Function  IsLinkForm: Boolean;
    Procedure CheckBasinsLinkage;
    Procedure AcceptFiles(Var msg:TMessage); message WM_Dropfiles;

    { Public declarations }
  end;

Const NumFilesSaved=5;

var
  ParentForm  : TParentForm;
  RecentFiles : Array[1..NumFilesSaved] of String;
  FileMenus   : Array[1..NumFilesSaved] of TMenuItem;
  IniMax      : Boolean;
  IniTop, IniLeft, IniHeight, IniWidth : Integer;
  FC: TNotifyEvent;


implementation

uses AQTOpenDialog, Splash, EditButtons, WizardProg, Study_io, Wait, Batch, LibraryType, Diagenesis, ShellAPI, hh, Math,
  LOADINGS, StrUtils;

{$R *.DFM}

Type
ChangeRec = packed record
    szName: DBINAME;
    iType: word;
    iSubType: word;
    iLength: word;
    iPrecision: byte;
  end;


Function TParentForm.SimulationRunning: Boolean;
Var i: Integer;
    frm: TForm;

Begin
  Result := false;
  If Must_Wait
   then result := True
   else
     for i:= MdiChildCount - 1 downto 0 do
       Begin
         frm := MDIChildren[i];
         If frm=nil then continue;
         If frm.Tag = 23 then Begin result := true; exit; End;
         If frm.Tag = 56 then
           if TPrimaryInterface(frm).AQTStudy.SimsRunning > 0 then
             Begin result := true; exit; End;
       End;
End;

procedure TParentForm.WndProc(var Msg: TMessage);   //disable for reportmemoryleaks  1/21/2011
var Allow: boolean;
begin
  inherited;
  if Msg.Msg = WM_POWERBROADCAST then
    case Msg.WParam of
      PBT_APMQUERYSUSPEND:
       begin
        if (Msg.LParam and 1) = 1 then Allow := True  //if user initiated
                                  else Allow := not SimulationRunning;
        if Allow then Msg.Result := integer(true)
                 else Msg.Result := BROADCAST_QUERY_DENY;
       end;

      PBT_APMQUERYSTANDBY:
       begin
        if (Msg.LParam and 1) = 1 then Allow := True //if user initiated
                                  else Allow := not SimulationRunning;
        if Allow then Msg.Result := integer(true)
                 else Msg.Result := BROADCAST_QUERY_DENY;
       end;

      PBT_APMBATTERYLOW:
        Msg.Result := integer(true)

    end
  else
    if Msg.Msg = WM_QUERYENDSESSION then
     begin
       Allow := not SimulationRunning;
       Msg.Result := integer(Allow);
     end;
end;


Procedure TParentForm.AcceptFiles(var msg: TMessage);
const cnMaxFileNameLen = 255;
var
  i,
  nCount     : integer;
  acFileName : array [0..cnMaxFileNameLen] of char;
begin
  nCount := DragQueryFile( msg.WParam, $FFFFFFFF, acFileName, cnMaxFileNameLen );   // find out how many files we're accepting

  for i := 0 to nCount-1 do   // query Windows one at a time for the file name
  begin
    DragQueryFile( msg.WParam, i, acFileName, cnMaxFileNameLen );

    OpenFile(acFileName);


  end;

  DragFinish( msg.WParam );
end;

Function TParentForm.CompressFileN(FN,DR:String): String;
Var TFile: String;
    Index,Loop,CopyUp: Integer;
Begin
  If UpperCase(DR) = UpperCase(Studies_Dir)
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
            If (TFile[Length(TFile)]<>'\') then TFile := TFile + '\';
            TFile := TFile + FN;
          End;
  CompressFileN := TFile;
End;

Procedure TParentForm.UpdateRecentlyUsed(ClosingStudy: TAQUATOXSegment; DirN,FileN: String);
Var FileInList, SavedItems: Integer;
    Loop: Integer;
    CName: String;

Begin
  If ClosingStudy=nil then exit;
  If ClosingStudy.TimeLoaded <= 0 then exit; {don't put new studies that haven't been saved on the recently used files list}
  If FileN = 'AQUATOX1.APS' then exit; {don't put new studies that haven't been saved on the recently used files list}
  If FileN = 'LINKED1.ALS' then exit; {don't put new studies that haven't been saved on the recently used files list}

  SavedItems := 0;
  For Loop := 1 to NumFilesSaved do
   If FileMenus[Loop].Visible then SavedItems := Loop;

  FileInList := 0;
  For Loop := 1 to SavedItems do
    If LowerCase(DirN+FileN) = LowerCase(RecentFiles[Loop])
      Then FileInList := Loop;

  If FileInList=1 then exit;
  If FileInList>1 then  {move the file down to first position and move up other files}
    Begin
      For Loop := FileInList-1 downto 1 do
        Begin
          FileMenus[Loop+1].Caption := FileMenus[Loop].Caption;
          RecentFiles[Loop+1] := RecentFiles[Loop];
          CName := FileMenus[Loop+1].Caption;
          CName[2] := IntToStr(Loop+1)[1];
          FileMenus[Loop+1].Caption := CName;
        End;
      RecentFiles[1] := DirN+FileN;
      FileMenus[1].Caption := '&1: '+CompressFileN(FileN,DirN);
      FileMenus[1].Visible := True;
      Update;
      WriteIniFileData;
      Exit;
    End;

  For Loop := SavedItems downto 1 do
   If Loop<NumFilesSaved then
     Begin
       FileMenus[Loop+1].Caption := FileMenus[Loop].Caption;
       RecentFiles[Loop+1] := RecentFiles[Loop];
     End;

  For Loop := SavedItems+1 downto 1 do
   If Loop<=NumFilesSaved then
    Begin
      FileMenus[Loop].Visible := True;
      CName := FileMenus[Loop].Caption;
      CName[2] := IntToStr(Loop)[1];
      FileMenus[Loop].Caption := CName;
    End;

  RecentFiles[1] := DirN+FileN;
  FileMenus[1].Caption := '&1: '+CompressFileN(FileN,DirN);
  FileMenus[1].Visible := True;
  Update;
  WriteIniFileData;

End;

procedure TParentForm.Contents1Click(Sender: TObject);
begin
  HTMLHelpContext('Overview1.htm');
End;

procedure TParentForm.Tutorial1Click(Sender: TObject);
begin
  HTMLHelpContext('Deleting_and_Adding_a_Plant.htm');
end;

procedure TParentForm.About1Click(Sender: TObject);
begin
   Application.CreateForm(TSplashForm, SplashForm);
   SplashForm.LicenseButton.Visible := True;
   SplashForm.ExitButton.Visible := True;
   SplashForm.SourceCode.Visible := True;
   SplashForm.VersionInfo.Caption:='(Build Number '+Trim(BuildStr)+')';
   SplashForm.VersionInfo.Visible := True;
   Splashform.ShowModal;
   Splashform.Free;
end;

procedure TParentForm.InitialCondition1Click(Sender: TObject);
begin
  If Not IsLinkForm then
     If CheckValidForm then
       GetStudyForm.InitCondButtonClick(nil);
end;

procedure TParentForm.Chemical1Click(Sender: TObject);
begin
  If IsLinkForm
    then GetLinkForm.ChemicalButtonClick(nil)
    else If CheckValidForm
      then GetStudyForm.ChemicalButtonClick(nil);
end;


procedure TParentForm.Site1Click(Sender: TObject);
begin
  If Not IsLinkForm then
    If CheckValidForm then GetStudyForm.SiteBitBtnClick(nil);
end;

procedure TParentForm.Setup1Click(Sender: TObject);
begin
  If IsLinkForm
    then GetLinkForm.SetupBitBtnClick(nil)
    else If CheckValidForm
      then GetStudyForm.SetupBitBtnClick(nil);
end;

procedure TParentForm.Notes1Click(Sender: TObject);
begin
   If IsLinkForm
    then GetLinkForm.NotesBitBtnClick(nil)
    else If CheckValidForm then GetStudyForm.NotesButtonClick(nil);
end;


procedure TParentForm.Run1Click(Sender: TObject);
begin
   If IsLinkForm
    then GetLinkForm.RunBitBtnClick(nil)
    else If CheckValidForm
      then GetStudyForm.RunButtonClick(nil);
end;

procedure TParentForm.Control1Click(Sender: TObject);
begin
   If IsLinkForm
    then GetLinkForm.ControlButtClick(nil)
    else If CheckValidForm then GetStudyForm.ControlButtClick(nil);
end;

procedure TParentForm.Output1Click(Sender: TObject);
begin
   If IsLinkForm
    then GetLinkForm.OutputBitBtnClick(nil)
    else If CheckValidForm then GetStudyForm.OutputBitBtnClick(nil);
end;

procedure TParentForm.AddSVClick(Sender: TObject);
begin
  If Not IsLinkForm then
     If CheckValidForm then GetStudyForm.AddButtonClick(nil);
end;

procedure TParentForm.AddTimeseriesfromExcel1Click(Sender: TObject);
begin
   If IsLinkForm
    then GetLinkForm.AddExcelTimeseries
    else AddTimeseriesfromExcel1.Enabled := False;
end;

procedure TParentForm.akeParametersfromAnotherStudy1Click(Sender: TObject);
begin
     If IsLinkForm
    then GetLinkForm.BorrowParameters
    else If CheckValidForm then GetStudyForm.BorrowParameters;
end;

procedure TParentForm.Uncertainty1Click(Sender: TObject);
begin
   If IsLinkForm
    then GetLinkForm.Uncertainty1Click(nil)
    else If CheckValidForm then GetStudyForm.Uncertainty1Click(nil);
end;

procedure TParentForm.Rate1Click(Sender: TObject);
begin
   If IsLinkForm
    then GetLinkForm.RateSavingInformation1Click(nil)
    else If CheckValidForm then GetStudyForm.Rate1Click(nil);
end;

procedure TParentForm.ControlSetup1Click(Sender: TObject);
begin
  If IsLinkForm
    then GetLinkForm.ControlRunSetup1Click(nil)
    else If CheckValidForm then GetStudyForm.ControlSetup1Click(nil);
end;

procedure TParentForm.ClearResults1Click(Sender: TObject);
begin
  If IsLinkForm
    then GetLinkForm.ClearResults1Click(nil)
    else If CheckValidForm then GetStudyForm.ClearResults1Click(nil);
end;

procedure TParentForm.Animals1Click(Sender: TObject);
begin
  Library_File1.EditLibrary('Animal');
end;

procedure TParentForm.Chemicals1Click(Sender: TObject);
begin
  Library_File1.EditLibrary('Chemical');
end;

procedure TParentForm.Plants1Click(Sender: TObject);
begin
  Library_File1.EditLibrary('Plant');
end;

procedure TParentForm.Sites1Click(Sender: TObject);
begin
  Library_File1.EditLibrary('Site');
end;

procedure TParentForm.Remineralization1Click(Sender: TObject);
begin
  Library_File1.EditLibrary('Remin');
end;

procedure TParentForm.LibraryHelp1Click(Sender: TObject);
begin
  HTMLHelpContext('Topic8.htm');
end;

procedure TParentForm.ShowToolbar1Click(Sender: TObject);
begin
  Toolbar.Visible := True;
  HideToolbar1.Enabled := True;
  ShowToolbar1.Enabled := False;
end;

procedure TParentForm.HideToolbar1Click(Sender: TObject);
begin
  Toolbar.Visible := False;
  HideToolbar1.Enabled := False;
  ShowToolbar1.Enabled := True;
end;


procedure TParentForm.EditToolbar1Click(Sender: TObject);
Var TB: TToolButton;
    Loop, i: Integer;
begin
  ToolBar.Visible := True;
  File1.Enabled    := False;
  View1.Enabled    := False;
  Library1.Enabled := False;
  Study1.Enabled   := False;
  Help1.Enabled    := False;
  Window.Enabled  := False;

  for i:= MdiChildCount - 1 downto 0 do
    MDIChildren[i].Enabled := False;

  For Loop := ToolBar.ButtonCount-1 downto 0 do
    Begin
      TB := ToolBar.Buttons[Loop];
      TB.DragMode  := DmAutomatic;
      TB.Enabled := True;
      TB.MenuItem := nil;
    End;

  Application.CreateForm(TEditButtForm, EditButtForm);
  Try
  With EditButtForm do
    Repeat
      Execute;
      If ButtonDeleted then
        If ButtonIndex=-1
          then
            Begin {remove all separators}
              For Loop := ToolBar.ButtonCount-1 downto 0 do
                Begin
                  TB := ToolBar.Buttons[Loop];
                  If TB.Style=TBSDivider then
                    TB.Free;
                  ToolBar.Invalidate;
                End;
            End
          else
            Begin
              TB := ToolBar.Buttons[ButtonIndex];
              TB.Free;
              ToolBar.Invalidate;
            End;
    Until FormDone;
  Finally
    EditButtForm.Free;
  End;

  For Loop := ToolBar.ButtonCount-1 downto 0 do
    Begin
      TB := ToolBar.Buttons[Loop];
      TB.DragMode  := DmManual;
    End;

  File1.Enabled    := True;
  View1.Enabled    := True;
  Help1.Enabled    := True;
  Window.Enabled  := True;

  WriteIniFileData;
  with Toolbar do while ButtonCount <> 0 do Buttons[0].Free; 
  ReadIniFileData;

  Update;
  SetToolbarMenuItems;

  for i:= MdiChildCount - 1 downto 0 do
    MDIChildren[i].Enabled := True;

  EnableDisableToolbar(FindActiveStudy);
  If CheckValidForm then GetStudyForm.FormActivate(nil);
  Toolbar.Invalidate;
end;


procedure TParentForm.New1Click(Sender: TObject);
Var OldCursor: TCursor;
    NewStudy : TAQUATOXSegment;

{New Study Menu Item or Wizard Hat on Toolbar}
Begin
   OldCursor := Screen.Cursor;
   Screen.Cursor := crHourGlass;

   Application.CreateForm(TWizardProgress, WizardProgress);

   Screen.Cursor := OldCursor;
   WizardIsRunning := True;
   Enabled := False;

   If WizardProgress.ExecuteWizard(True)
     then NewStudy := WizardProgress.WizStudy
     else Begin
            If WizardProgress.WizStudy<>nil then WizardProgress.Wizstudy.Destroy;
            NewStudy := nil;
          End;

   Enabled := True;
   WizardIsRunning := False;
   WizardProgress.Free;
   If NewStudy <> nil then
     Begin
       NewStudy.Adjust_Internal_Nutrients;
       NewStudy.SV.Update_Distributions;
       NewStudy.LastChange := Now;
       NewStudy.TimeLoaded := 0;

       Panel1.Visible := False;
       TPrimaryInterface.Create(Self,NewStudy);
     End;

    Invalidate;

end;

Function TParentForm.OpenFile(Nm: String): Boolean;
Var PNewStudy: TAQUATOXSegment;
    P: Pointer;
    ErrorString: String;
    TA: TAnimal;

(*    Procedure EXTRAPROCESSING;  //Extra processing for batch results 2/15/2011

    Var FileStream : TFileStream;
    PC_FileN    :  Array[0..255] of char;
    Begin

      WaitDlg.Setup('Please Wait One Moment, Loading New Ctrl. Res');

      PNewStudy.SV.ControlResults[Epilimnion].Free;

      StrPCopy(PC_FileN,'C:\work\AQUATOX\Documents\WorkingDocs\Batch\ctrlresultsonly.aps');

      Try
        FileStream:=TFileStream.Create(PC_FileN,fmOpenRead);
      Except
        MessageDlg(Exception(ExceptObject).Message,mterror,[mbOK],0);
        PNewStudy:=nil;
        Exit;
      End; {Try Except}

      {Check Version #}
      PNewStudy.SV.ControlResults[Epilimnion] := TResultsCollection.Load(True,TStream(FileStream),VersionNum);  //Load control results only
      LoadCollectionitems(True, TStream(FileStream),PNewStudy.SV.ControlResults[Epilimnion],False,VersionNum);

      FileStream.Free;

      WaitDlg.Setup('Please Wait One Moment, Saving File');
      Enabled:=False;

      Try
      PNewStudy.SV.StoreResults := True;
      PNewStudy.SV.StoreDistribs := True;
      SaveFile(PNewStudy);
      WaitDlg.Setup('Please Wait One Moment, Exporting Steinhaus');
      SteinhausExport(ChangeFileExt(PNewStudy.DirName + PNewStudy.FileName,'.CSV'),PNewStudy);

      Finally
        Enabled := True;
      End;

    End;  *)


Begin
  BODConvertWarning := False;
  PNewStudy := nil;
  Result := False;                                                                      

  Try
  WaitDlg.Setup('Please Wait One Moment, Loading File');
  MUST_WAIT := True;

  If Uppercase(ExtractFileExt(Nm))='.ALS' then
    Begin
       p := OpenLS(Nm);
       If p<>nil then
         Begin
           Result := True;
           Panel1.Visible := False;
           LinkedForm := TLinkedForm.Create(Self,p);
         End;

       WaitDlg.Hide;
       MUST_WAIT := False;
       Exit;
    End;

  If Uppercase(ExtractFileExt(Nm))='.INT' then       //Upgrade trophic interaction files 11/18/2010
    Begin
     TA := TAnimal.init(lggamefish1,stv,'Junk',nil,0,true);
     TA.ReadTrophint(Nm);
     TA.WriteTrophint(Nm);
     TA.Free;
     Exit;
    End;

  {Load the File}

    LoadFile(PNewStudy, Nm);
    MUST_WAIT := False;

  Except
    PNewStudy:=nil;
    WaitDlg.Hide;
    MUST_WAIT := False;

    ErrorString:=Exception(ExceptObject).Message;
    MessageDlg(ErrorString,mterror,[mbok],0);
    Result := False;

    Exit;
  End;

  If PNewStudy<> nil then
    Begin
      Result := True;
      Panel1.Visible := False;
      TPrimaryInterface.Create(Self,PNewStudy);
      UpdateRecentlyUsed(PNewStudy,PNewStudy.DirName,PNewStudy.FileName);
    End;

//  EXTRAPROCESSING;  // Enables batch processing of groups of files dragged and dropped on AQUATOX Interface

  WaitDlg.Hide;

End;


procedure TParentForm.Open1Click(Sender: TObject);
Var OpenDialog: TAQTOpenDialog;
    Nm: String;
    ViewHandle: THandle;
begin
  {Put up Load File Dialog, Exit if Cancel Pressed}

  openDialog := TAQTOpenDialog.Create(self);
  openDialog.InitialDir := Studies_Dir;
  openDialog.Options := [ofFileMustExist, ofHideReadOnly, ofEnableSizing];
  openDialog.Filter := 'AQUATOX Study Files (*.a?s)|*.a?s|AQUATOX Single Segments (*.aps)|*.aps|AQUATOX Linked Segments (*.als)|*.als|All Files (*.*)|*.*';
  openDialog.FilterIndex := 1;
  openDialog.OnFolderChange := openDialog.FolderChange;

  ViewHandle := FindWindowEx(Windows.GetParent(Handle), 0, 'SHELLDLL_DefView', NIL);
  if (ViewHandle <> 0) then
    SendMessage(ViewHandle, WM_COMMAND, $702B, 0);

  If not openDialog.Execute then
    Begin
      OpenDialog.Free;
      Exit;
    End;
  Nm := OpenDialog.FileName;

  OpenDialog.Free;

  OpenFile(Nm);

end;


Procedure TParentForm.Save1Click(Sender: TObject);
Begin
  TRY
  MUST_WAIT := True;

  If IsLinkForm
    then GetLinkForm.Save1Click(nil)
    else If CheckValidForm then GetStudyForm.Save1Click(nil);

  FINALLY
  MUST_WAIT := FALSE;
  END;

End;

Procedure TParentForm.SaveAs1Click(Sender: TObject);
Begin
  TRY
  MUST_WAIT := True;

  If IsLinkForm
    then GetLinkForm.SaveAs1Click(nil)
    else if CheckValidForm then GetStudyForm.SaveAs1Click(nil);

  FINALLY
  MUST_WAIT := FALSE;
  END;

End;

Procedure TParentForm.ExportResults1Click(Sender: TObject);
Begin
  If IsLinkForm
    then GetLinkForm.ExportButtonClick(nil)
    else If CheckValidForm then GetStudyForm.ExportResults1Click(nil);
End;

procedure TParentForm.ExportAllGraphstoMSWord1Click(Sender: TObject);
begin
  If IsLinkForm
    then GetLinkForm.GraphstoWord
    else If CheckValidForm then GetStudyForm.GraphsToWord;

end;

Procedure TParentForm.ExportControlResults1Click(Sender: TObject);
Begin
   If CheckValidForm then GetStudyForm.ExportControlResults1Click(nil);
End;

Procedure TParentForm.PrintSetup1Click(Sender: TObject);
Begin
    PrinterSetupDialog1.Execute;
End;

Procedure TParentForm.ReadIniFileData;
Var INI: TIniFile;
    Loop: Integer;
    NameButtStr,CName: String;
    ButtIndex,TypIndex: Integer;

Begin
  For Loop := 1 to NumFilesSaved do
    Begin
      CName := 'RF'+IntToStr(Loop);
      FileMenus[Loop] := TMenuItem(FindComponent(CName));
    End;

  INI := TIniFile.Create(Program_Dir+'AQUATOX.INI');

  {Recent File Data}

  For Loop:=1 to NumFilesSaved do
    Begin
      RecentFiles[Loop]:=INI.ReadString('RecentFiles','File'+IntToStr(Loop),'');
      FileMenus[Loop].Visible := RecentFiles[Loop]<>'';
      If FileMenus[Loop].Visible
        then FileMenus[Loop].Caption := '&'+IntToStr(Loop)+': '+CompressFileN(ExtractFileName(RecentFiles[Loop]),ExtractFileDir(RecentFiles[Loop]))
    End;

  {Window Location Data}

  IniMax    := Ini.ReadBool('WindowState','Maximized',True);
  IniTop    := Ini.ReadInteger('WindowState','Top',25);
  IniLeft   := Ini.ReadInteger('WindowState','Left',25);
  IniHeight := Ini.ReadInteger('WindowState','Height',545);
  IniWidth  := Ini.ReadInteger('WindowState','Width',642);

  ShowBigButtons  := Ini.ReadBool('WindowState','BigButtons',True);
  If ShowBigButtons then ShowBigButtons1.Caption := 'Hide Big &Buttons'
                    else ShowBigButtons1.Caption := 'Show Big &Buttons';

  {Tool Bar Data}

  ToolBar.Visible := Ini.ReadBool('ToolButtons','Visible',False);
  If Not ToolBar.Visible then HideToolbar1Click(nil);
  ButtIndex:=0;
  Repeat
    Inc(ButtIndex);
    NameButtStr := 'Button'+IntToStr(ButtIndex);
    TypIndex := Ini.ReadInteger('ToolButtons',NameButtStr,-99);
    If TypIndex<>-99 then ToolButtonCreate(TypIndex);
  Until TypIndex=-99;
  SetToolBarMenuItems;

   {EDIT COLOR}
   EditColor := Ini.ReadInteger('Colors','EditColor',14347226);

  INI.Free;

End;




Procedure TParentForm.WriteIniFileData;
Var INI: TIniFile;
    Loop, ButtonNum: Integer;
    SavedItems: Integer;
    NameButtStr,StrToWrite: String;
    TB: TToolButton;

Begin
  INI := TIniFile.Create(Program_Dir+'AQUATOX.INI');

  {Recent File Data}

  SavedItems := 0;
  For Loop := 1 to NumFilesSaved do
    If FileMenus[Loop].Visible then SavedItems := Loop;
  For Loop:=1 to NumFilesSaved do
    Begin
      If Loop>SavedItems then StrToWrite:=''
                         else StrToWrite:= RecentFiles[Loop];
      INI.WriteString('RecentFiles','File'+IntToStr(Loop),StrToWrite);
    End;

  {Window Location Data}

  Ini.WriteBool('WindowState','Maximized',(WindowState=WSMaximized));
  If WindowState=WSMaximized
    then
      begin {write default screen pos}
        Ini.WriteInteger('WindowState','Top',25);
        Ini.WriteInteger('WindowState','Left',25);
        Ini.WriteInteger('WindowState','Height',545);
        Ini.WriteInteger('WindowState','Width',642);
      end
    else
      Begin
        Ini.WriteInteger('WindowState','Top',Top);
        Ini.WriteInteger('WindowState','Left',Left);
        Ini.WriteInteger('WindowState','Height',Height);
        Ini.WriteInteger('WindowState','Width',Width);
      End;

  Ini.WriteBool('WindowState','BigButtons',ShowBigButtons);


  {Tool Bar Data}

  Ini.WriteBool('ToolButtons','Visible',ToolBar.Visible);
  ButtonNum:=0;
  For Loop := ToolBar.ButtonCount-1 downto 0 do
    Begin
      TB := ToolBar.Buttons[Loop];
      Inc(ButtonNum);
      NameButtStr := 'Button'+IntToStr(ButtonNum);
      Ini.WriteInteger('ToolButtons',NameButtStr,TB.Tag);
    End;
  Inc(ButtonNum);
  NameButtStr := 'Button'+IntToStr(ButtonNum);
  Ini.WriteInteger('ToolButtons',NameButtStr,-99);

  {EDIT COLOR}
   Ini.WriteInteger('Colors','EditColor',EditColor);

  INI.Free;
End;


procedure TParentForm.RecentlyUsedClick(Sender: TObject);
Var FileIndex, Loop : Integer;
    Str: String;
    LoadSuccess: Boolean;
begin
  FileIndex := StrToInt(TMenuItem(Sender).Name[3]);


{  if Check_Save_and_Cancel('Opening New Study') then exit; }

  WaitDlg.Setup('Please Wait One Moment, Loading File');

  LoadSuccess := OpenFile(RecentFiles[FileIndex]);

(*  If Uppercase(ExtractFileExt())='.ALS'
    then
      Begin
        LoadSucces
       {  LinkedForm := TLinkedForm.Create(Self,nil); }
         p := OpenLS(RecentFiles[FileIndex]);
         If p<>nil then
           Begin
             Panel1.Visible := False;
             LinkedForm := TLinkedForm.Create(Self,p);
           End;
         LoadSuccess := p <> nil;
      End
    else
      Begin

        Try
          PNewStudy:=nil;
          LoadFile(PNewStudy,RecentFiles[FileIndex]);
          WaitDlg.Hide;
          If PNewStudy<>nil then TPrimaryInterface.Create(Self,PNewStudy);
        Except
          PNewStudy:=nil;
          WaitDlg.Hide;
          Raise;
        End;


        Panel1.Visible := False;
        LoadSuccess := PNewStudy<>nil;
      End; *)

  If Not LoadSuccess then
    Begin
      For Loop := FileIndex to NumFilesSaved-1 do
        Begin
          Str := FileMenus[Loop+1].Caption;
          If Str <> '' then Str[2] := PRED(Str[2]);
          FileMenus[Loop].Caption := Str;
          FileMenus[Loop].Visible := FileMenus[Loop+1].Visible;
          RecentFiles[Loop]       := RecentFiles[Loop+1];
        End;

      FileMenus[NumFilesSaved].Caption := '';
      FileMenus[NumFilesSaved].Visible := False;
      RecentFiles[NumFilesSaved]       := '';

      Exit;
    End;

end;

Function TParentForm.FindActiveStudy: TAQUATOXSegment;
Var ActForm: TForm;
Begin
  FindActiveStudy := nil;
  ActForm := ActiveMDIChild;
  If (ActForm=nil) then exit;
  If ActForm.Tag = 69 then
    Begin
      If TLinkedForm(ActForm).LinkedSegmts = nil
        then FindActiveStudy := nil
        else FindActiveStudy := TLinkedForm(ActForm).LinkedSegmts.TemplateSeg;
    End;
  If ActForm.Tag = 56 then FindActiveStudy := TPrimaryInterface(ActForm).AQTStudy;
  If ActForm.Tag = 23 then FindActiveStudy := TProgressDialog(ActForm).StudyPtr;
End;

Procedure TParentForm.UpdateWForm;
Begin
  UpdateMenu(FindActiveStudy);
End;                                

Function TParentForm.IsLinkForm: Boolean;
Var ThisStudy: TAQUATOXSegment;
Begin
  IsLinkForm := False;
  ThisStudy := FindActiveStudy;
  If ThisStudy=nil then exit;
  IsLinkForm :=(ThisStudy.SV.Linkedmode) and (ThisStudy.SV.PStatesTemplate = ThisStudy.SV);
End;

procedure TParentForm.UpdateMenu(ThisStudy: TAQUATOXSegment);
Var LinkMain, MainFormActive: Boolean;
    ActForm: TForm;
begin
  ActForm := ActiveMDIChild;
  If (ActForm=nil) or (ThisStudy=nil)
                 then MainFormActive := False
                 else MainFormActive := (ActForm.Tag = 56);

  If ShowBigButtons then ShowBigButtons1.Caption := 'Hide Big &Buttons'
                    else ShowBigButtons1.Caption := 'Show Big &Buttons';

  If ThisStudy = nil then LinkMain := False
                     else LinkMain := IsLinkForm;

  New1.Enabled := True;

  If LinkMain then
    Begin
      Save1.Enabled := True;
      SaveAs1.Enabled := True;
      Study1.Enabled := True;
      Close1.Enabled := True;
      AddTimeseriesfromExcel1.Enabled := True;
      InitialCondition1.Enabled := False;
      Sediment1.Enabled     := False;
      ExportToGenScn.Enabled := GenScnInstalled;
      Site1.Enabled := False;
      ClearResults1.Enabled := True;
      Exit1.Enabled := True;
      AddSV.Enabled := False;
      EditTrophicInteractions1.Enabled := True;
      EditAllPlantLinkages1.Enabled := True;
    End
  else
   If Not MainFormActive then
    Begin
      Library1.Enabled:=True;
      Study1.Enabled:=False;
      Sediment1.Enabled     := False;
      ExportResults1.Enabled:=False;
      EditwithWizard1.Enabled:=False;
      ExportToGenScn.Enabled := False;
      AddTimeseriesfromExcel1.Enabled := False;
      ExportControlResults1.Enabled:=False;
      Save1.Enabled:=False;
      SaveAs1.Enabled:=False;
      ToolBar.Invalidate;
      Exit1.Enabled := True;
      parentform.Caption:='AQUATOX'
    End
  Else   {A STUDY EXISTS}
    Begin
      Exit1.Enabled := True;
      ClearResults1.Enabled := True;
      Close1.Enabled := True;
      AddTimeseriesfromExcel1.Enabled := False;

      If ThisStudy.SV.LinkedMode then
        Begin
          New1.Enabled := False;
          Save1.Enabled := False;
          Run1.Enabled := False;
          Control1.Enabled := False;
          ClearResults1.Enabled := False;
          { RunBatch1.Enabled := False; }
          Close1.Enabled := False;
          Exit1.Enabled := False;
        End;

       InitialCondition1.Enabled := True;
       Site1.Enabled := True;
       AddSV.Enabled := True;
       ExportResults1.Enabled := True;

       EditTrophicInteractions1.Enabled := True;
       EditAllPlantLinkages1.Enabled := True;
       ExportResults1.Enabled:=(ThisStudy.SV.Results[epilimnion].Count>0);
       ExportControlResults1.Enabled:=(ThisStudy.SV.ControlResults[epilimnion].Count>0);
       ExportToGenScn.Enabled := (ExportResults1.Enabled or ExportControlResults1.Enabled) and GenScnInstalled;

       AddSandSiltClayModel1.Enabled  := ThisStudy.SV.GetStatePointer(Sand,StV,WaterCol) = nil;  {No sand-silt-clay Model attached}
       RemoveSandSiltClayModel1.Enabled := not AddSandSiltClayModel1.Enabled;

       AddSedimentModel1.Enabled     := ThisStudy.SV.SedLayers = 0;
       RemoveSedimentModel1.Enabled  := ThisStudy.SV.SedLayers > 0;
       AddBuriedSedLayer1.Enabled    := (ThisStudy.SV.SedLayers > 0) and (not ThisStudy.SV.SedNonReactive);
       AddNonReactiveSedLayer1.Enabled  := ThisStudy.SV.SedLayers = 0;
       RemoveBuriedSedLayer1.Enabled := ThisStudy.SV.SedLayers > 1;
       Sediment1.Enabled     := True;

       AddSedimentDiagenesis1.Enabled     := ThisStudy.SV.GetStatePointer(POC_G1,StV,SedLayer2) = nil;  {No Diagenesis Model attached}
       RemoveSedimentDiagenesis1.Enabled  := not AddSedimentDiagenesis1.Enabled;

       Library1.Enabled:=True;
       {Enable Menu Items which require a study}
       EditwithWizard1.Enabled:=True;

       Study1.Enabled:=True;
       Save1.Enabled := Not ThisStudy.SV.LinkedMode;

       SaveAs1.Enabled := True;
       ToolBar.Invalidate;

       ParentForm.Caption:='AQUATOX-- Main Window';
    End;

   EnableDisableToolbar(ThisStudy);

   If WizardIsRunning and (WizardProgress.CurrentForm<>nil) then WizardProgress.CurrentForm.Show;

end;

procedure TParentForm.FormShow(Sender: TObject);
begin
  If IniMax then WindowState:=WSMaximized
            else
              Begin
                WindowState:=WSNormal;
                Top := IniTop;
                Left := IniLeft;
                Height := IniHeight;
                Width := IniWidth;
              End;

end;


Procedure TParentForm.CheckBasinsLinkage;
Var  PNewStudy: TAQUATOXSegment;
     P : Pointer;

Begin
 If IncomingFile = '' then exit;

  PNewStudy := nil;
  If Uppercase(IncomingFile) = 'HSPF'
    then
      Begin
        Application.CreateForm(TLBasinsInfo, LBasinsInfo);
        Try

        LBasinsInfo.Get_HSPF_Linkage(PNewStudy,True);
        If PNewStudy = nil then exit;
        LBasinsInfo.Get_BASINS_Linkage(PNewStudy,True);
        Panel1.Visible := False;
        If PNewStudy <> nil then TPrimaryInterface.Create(Self,PNewStudy);
        Invalidate;
        LBasinsInfo.HSPFPanel.Visible := True;
        LBasinsInfo.GISPanel.Visible  := False;
        LBasinsInfo.SwatPanel.Visible := False;
        If LBasinsInfo.ShowModal = MrOK then
          Begin
            If CheckValidForm then GetStudyForm.WizBtnClick(nil);
            Show;
          End;

        Finally
          LBasinsInfo.Free;
        End;
      End;

  If Uppercase(IncomingFile) = 'UNKNOWN'
    then
      Begin
        Application.CreateForm(TLBasinsInfo, LBasinsInfo);
        Try

        LBasinsInfo.Get_BASINS_Linkage(PNewStudy,False);
        Panel1.Visible := False;
        If PNewStudy <> nil then TPrimaryInterface.Create(Self,PNewStudy);
        Invalidate;
        LBasinsInfo.HSPFPanel.Visible := False;
        LBasinsInfo.GISPanel.Visible  := True;
        LBasinsInfo.SwatPanel.Visible := False;
        If LBasinsInfo.ShowModal = MrOK then
          Begin
            If CheckValidForm then GetStudyForm.WizBtnClick(nil);
            Show;
          End;

        Finally
          LBasinsInfo.Free;
        End;
      End;

  If (Uppercase(IncomingFile) <> 'HSPF') and (Uppercase(IncomingFile) <> 'UNKNOWN')
    then
      Begin
        Application.CreateForm(TLBasinsInfo, LBasinsInfo);
        Try

        WaitDlg.Setup('Please Wait One Moment, Loading File');

        Try
          PNewStudy := Nil;

          If Uppercase(ExtractFileExt(IncomingFile))='.ALS' then
            Begin
               p := OpenLS(IncomingFile);
               If p<>nil then
                 Begin
                   Panel1.Visible := False;
                   LinkedForm := TLinkedForm.Create(Self,p);
                 End;
               Exit;
            End;

          LoadFile(PNewStudy, IncomingFile);
        Except
          PNewStudy:=nil;
          WaitDlg.Hide;
          IncomingFile := '';
          Invalidate;
          Raise;
          Exit;
        End;

        IncomingFile := '';
        WaitDlg.Hide;
        If PNewStudy=nil then Exit;
        Panel1.Visible := False;
        TPrimaryInterface.Create(Self,PNewStudy);
        Invalidate;

        Finally
          LBasinsInfo.Free;
        End;
      End;

End;

procedure TParentform.WizButtonClick(Sender: TObject);

begin
   If FindActiveStudy<>nil
      then GetStudyForm.WizBtnClick(nil)  {if a study exists, edit it}
      else New1Click(nil);                                     {otherwise create a new study}
end;


procedure TParentForm.FormCreate(Sender: TObject);
Var Dir: String;
    Reg: TRegistry;
{Run when application starts, load default file locations}
begin

   Coinitialize(nil);
   DragAcceptFiles( Handle, True );

   inherited;

  if not (csDesigning in ComponentState) then
    FHWnd := AllocateHWnd(WndProc);     //disable for reportmemoryleaks  1/21/2011

   WizardIsRunning := False;
   MUST_WAIT := False; 

   If ShortDateFormat = 'dd-MMM-yy' then ShortDateFormat := 'mm-dd-yyyy';
   If ShortDateFormat = 'dd/MMM/yy' then ShortDateFormat := 'mm/dd/yyyy';
   If Pos('yyyy',ShortDateFormat) = 0 then
     Insert('yy',ShortDateFormat,Pos('yy',ShortDateFormat));

   Program_Dir:=ExtractFilePath(Application.ExeName);
   Dir:=Program_Dir;
   Delete(Dir,Length(Dir)-7,8);
   Default_Dir:=Dir+'Database\';
   Output_Dir:=Dir+'Output\';
   Studies_Dir:=Dir+'Studies\';

   If not (DirectoryExists(Program_Dir) and
           DirectoryExists(Default_Dir) and
           DirectoryExists(Default_Dir) and
           DirectoryExists(Default_Dir)) then
      Begin
        MessageDlg('AQUATOX is not set up in a correct directory structure!  AQUATOX will not function.',mterror,[mbok],0);
        Halt;
      End;

  If FileExists(Program_Dir+'AnimForm.PX') then DeleteFile(Program_Dir+'AnimForm.PX');    // 3/23/2011  Delete index files no longer relevant now that there's grid-mode within a study.
  If FileExists(Program_Dir+'PlntForm.PX') then DeleteFile(Program_Dir+'PlntForm.PX');
  If FileExists(Program_Dir+'ChemForm.PX') then DeleteFile(Program_Dir+'ChemForm.PX');

  Session.NetFileDir := Program_Dir;

   HelpFilePath := Program_Dir+'AQUATOX.CHM';
   ReadIniFileData;

   If (Screen.Height < 599) or (Screen.Width<799) then
     MessageDlg('AQUATOX 3 does not support screen resolutions less than 800x600.  (This problem could also be caused by selecting "large font sizes" in Windows along with relatively low screen resolutions.)  Please change your display characteristics.',
                 mtinformation,[mbok],0);

   EnableDisableToolbar(nil);

   IncomingFile := ParamStr(1);

   Reg := TRegistry.Create;
   with Reg do
     Begin
       RootKey := HKEY_LOCAL_MACHINE;
       If OpenKey('SOFTWARE\AQUA TERRA Consultants\GenScn\ExePath', false)
         then
           Begin
             GenScnPath := ReadString('')+'\GenScn.exe';
             GenScnInstalled := FileExists(GenScnPath);
           End
         else
           Begin
             GenScnPath := '';
             GenScnInstalled := False;
           End;
       Free;
     End; {with Reg}

     SWATDir := 'C:\BASINS\modelout\SWAT';
     If Not DirectoryExists(SwatDir) then
       Begin
         SWATDir := 'D:\BASINS\modelout\SWAT';
         If Not DirectoryExists(SwatDir) then SwatDir := Output_Dir;
       End;

   OpenWriteFiles := nil;
   OpenUncFiles := nil;

end;

procedure TParentForm.BeforeDestruction;
var
  n: integer;
  frm: TForm;

begin
  for n:=Self.MDIChildCount - 1 downto 0 do
  begin  {destroy output windows first so they pass back information}
    frm := Self.MDIChildren[n];
    if (frm.FormStyle = fsMDIChild) and (frm.Tag=200) {output window} then
      Begin
         frm.Destroy;
      End;
  end;

  for n:=Self.MDIChildCount - 1 downto 0 do
  begin
    frm := Self.MDIChildren[n];
    If frm<>nil then
      if frm.FormStyle = fsMDIChild then frm.Destroy;
  end;

  inherited;
end;


Function Tparentform.ToolButtonCreate(Index: Integer): TToolButton;
Var NewButt: TToolButton;
Begin
  Newbutt := TToolButton.Create(ToolBar);

  Newbutt.Parent := ToolBar;
  NewButt.OnDragOver := ToolBarDragOver;
  NewButt.OnDragDrop := ToolBarDragDrop;
{  NewButt.OnClick    := ToolButtonClick; }
  NewButt.Tag := Index;
  NewButt.ShowHint := (Index>-1);
  NewButt.Style := TBSButton;

  If Index>-1 then Newbutt.ImageIndex := Index;

  If Index=-1 then
    Begin
      NewButt.MenuItem := Nil;
      NewButt.OnClick  := Nil;
      NewButt.Style := TBSDivider;
      NewButt.Width := 12;
    End;

  ToolButtonCreate := NewButt;
End;

Procedure TParentForm.SetToolbarMenuItems;
Var Loop: Integer;
    TB: TToolButton;
Begin
  For Loop := 0 to ToolBar.ButtonCount-1 {downto 0} do
    Begin
      TB := ToolBar.Buttons[Loop];
      Case TB.Tag of
        0: TB.OnClick := EnterWizard1Click;
        1: TB.MenuItem := Open1;
        2: TB.MenuItem := Close1;
        3: TB.MenuItem := Save1;
        4: TB.MenuItem := SaveAs1;
        5: TB.MenuItem := ExportResults1;
        6: TB.MenuItem := ExportControlResults1;
        7: TB.MenuItem := PrintSetup1;
        8: TB.MenuItem := RunBatch1;
        9: TB.MenuItem := Exit1;
        10: TB.MenuItem := HideToolbar1;
        11: TB.MenuItem := EditToolbar1;
        12: TB.MenuItem := Animals1;
        13: TB.MenuItem := Chemicals1;
        14: TB.MenuItem := Plants1;
        15: TB.MenuItem := Sites1;
        16: TB.MenuItem := Remineralization1;
        17: TB.MenuItem := InitialCondition1;
        18: TB.MenuItem := Chemical1;
        19: TB.MenuItem := Site1;
        20: TB.MenuItem := Setup1;
        21: TB.MenuItem := Notes1;
        22: TB.MenuItem := Run1;
        23: TB.MenuItem := Control1;
        24: TB.MenuItem := Output1;
        25: TB.MenuItem := AddSV;
        26: TB.MenuItem := Uncertainty1;
        27: TB.MenuItem := Rate1;
        28: TB.MenuItem := ControlSetup1;
        29: TB.MenuItem := ClearResults1;
        30: TB.MenuItem := Contents1;
        31: TB.MenuItem := About1;
        32: TB.MenuItem := ExportToGenscn;
        33: TB.MenuItem := ImportDataFromSwat1;
      end; {case}

      If TB.Tag>-1
          then TB.ImageIndex := TB.Tag
          else Begin TB.Style := TBSDivider;
                     TB.Width := 12;
                     TB.MenuItem := Nil;
                     TB.OnClick  := Nil;
               End;

      Case TB.Tag of
        0: TB.Hint := 'Enter AQUATOX Wizard';
        1: TB.Hint := 'Open File';
        2: TB.Hint := 'Close File';
        3: TB.Hint := 'Save File';
        4: TB.Hint := 'Save File As';
        5: TB.Hint := 'Export Perturbed Results';
        6: TB.Hint := 'Export Control Results';
        7: TB.Hint := 'Printer Setup';
        8: TB.Hint := 'Run Batch Mode';
        9: TB.Hint := 'Exit AQUATOX';
        10: TB.Hint := 'Hide Toolbar';
        11: TB.Hint := 'Edit Toolbar';
        12: TB.Hint := 'Animal Library';
        13: TB.Hint := 'Chemical Library';
        14: TB.Hint := 'Plant Library';
        15: TB.Hint := 'Site Library';
        16: TB.Hint := 'Remin Library';
        17: TB.Hint := 'Initial Conditions';
        18: TB.Hint := 'Chemicals';
        19: TB.Hint := 'Site';
        20: TB.Hint := 'Setup';
        21: TB.Hint := 'Notes';
        22: TB.Hint := 'Run Simulation';
        23: TB.Hint := 'Run Control Simulation';
        24: TB.Hint := 'Show Output';
        25: TB.Hint := 'Add a State Variable';
        26: TB.Hint := 'Uncertainty and Sensitivity Setup';
        27: TB.Hint := 'Rate Information';
        28: TB.Hint := 'Control Setup';
        29: TB.Hint := 'Clear all Results';
        30: TB.Hint := 'Enter Help File';
        31: TB.Hint := 'About AQUATOX';
        32: TB.Hint := 'Export all Results to Genscn';
        33: TB.Hint := 'Import Data From SWAT';
      end; {case}
  Toolbar.invalidate;

    End;
End;

procedure Tparentform.ToolBarDragDrop(Sender, Source: TObject; X, Y: Integer);
Var Newbutt: TToolButton;
    SetXLoc: Boolean;
    XLoc, YLoc: Integer;
    ButtonIndex: Integer;
    IndexString: String;
        {-----------------------------------------------------------------------}
        Procedure LocateButton;
        Begin
          If TComponent(Sender).Name =''
            then SetXLoc := True
            else If TComponent(Sender).Name[1]='T'
               then SetXLoc := False
               else SetXLoc := True;

          If Not SetXLoc
                then Begin
                       XLoc := X;
                       YLoc := Y;
                     End
                else With Sender as TToolButton do
                     Begin
                       If x > Width div 2
                         then XLoc := TToolButton(Sender).Left+X
                         else XLoc := TToolButton(Sender).Left-1;
                       YLoc := TToolButton(Sender).Top;
                     End;

          Newbutt.SetBounds(XLoc, YLoc, NewButt.Width, NewButt.Height);
        End;
        {-----------------------------------------------------------------------}

Begin
  If Source is TToolButton then
    Begin
      NewButt := TToolButton(Source);
      LocateButton;
      Update;
      Exit;
    End;
  {handle case of button moving}

  IndexString := TImage(Source).Name[4];
  If Length(TImage(Source).Name)>4 then IndexString := IndexString+TImage(Source).Name[5];

  If Indexstring='X'
    then ButtonIndex := -1 {separator}
    else ButtonIndex := StrToInt(IndexString);

  Newbutt := ToolButtonCreate(ButtonIndex);
  NewButt.DragMode := DMAutomatic;

  LocateButton;
  Update;
end;

procedure Tparentform.ToolBarDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
{  TControl(sender).Cursor := CrDrag;}
  Accept := (Source is TImage) or (Source is TToolButton);
end;

Procedure TParentform.EnableDisableToolbar(CStudy : TAQUATOXSegment);
Var TB: TToolButton;
    Loop: Integer;
Begin
{  Application.ProcessMessages; }
  For Loop := ToolBar.ButtonCount-1 downto 0 do
    Begin
      TB := ToolBar.Buttons[Loop];
      If TB.Tag = 8 then TB.Enabled := False;
      If TB.Tag in [3..6,17..29,32]
        Then TB.Enabled := (CStudy<>nil)
        Else TB.Enabled := True;
      If (CStudy<>nil) and (TB.Tag=5) then
        TB.Enabled := (CStudy.SV.Results[epilimnion].Count>0);
      If (CStudy<>nil) and (TB.Tag=6) then
        TB.Enabled := (CStudy.SV.ControlResults[epilimnion].Count>0);
      If (CStudy<>nil) and (TB.Tag=32) then
        TB.Enabled := (islinkform or ((CStudy.SV.ControlResults[epilimnion].Count>0) or
                                    (CStudy.SV.Results[epilimnion].Count>0))) and GenScnInstalled;

      If (Tb.Tag in [17,19,25,6]) and islinkform then TB.Enabled := False;
      If (TB.Tag = 2) then Begin If CStudy = nil
          then TB.Enabled := False
          else TB.Enabled := (not CStudy.SV.Linkedmode) or IsLinkForm; End;

    End;
End;


Procedure TParentForm.Close1Click(Sender: TObject);
Begin
   If ActiveMDIChild=nil then exit;
   If MUST_WAIT then exit;
   ActiveMDIChild.Close;
End;

procedure TParentForm.CloseAll1Click(Sender: TObject);
var i: integer;
begin
  If MUST_WAIT then exit;
  Try
  for i:= MdiChildCount - 1 downto 0 do
    If (MDIChildren[i].Owner = Self) then
      MDIChildren[i].Close;
  Finally    
  Application.ProcessMessages;
  UpdateMenu(FindActiveStudy);
  End;
end;

procedure TParentForm.Tile1Click(Sender: TObject);
begin
  Tile;
end;

Function TParentForm.GetStudyForm: TPrimaryInterface;
Var ActForm: TForm;
Begin
  GetStudyForm := nil;
  ActForm := ActiveMDIChild;
  If (ActForm=nil) then exit;
  If ActForm.Tag = 56 then GetStudyForm := TPrimaryInterface(ActForm);
  If ActForm.Tag = 23 then GetStudyForm := TPrimaryInterface(TProgressDialog(ActForm).StudyForm);
End;

Function TParentForm.GetLinkForm: TLinkedForm;
Var ActForm: TForm;
Begin
  Result := nil;
  ActForm := ActiveMDIChild;
  If (ActForm=nil) then exit;
  If ActForm.Tag = 69 then GetLinkForm := TLinkedForm(ActForm);
  If ActForm.Tag = 23 then GetLinkForm := TLinkedForm(TProgressDialog(ActForm).StudyForm);
End;

Function TParentForm.CheckValidForm: Boolean;
Begin
  CheckValidForm := not (FindActiveStudy=nil);
  If Not Result then UpdateMenu(nil);
End;


procedure TParentForm.Cascade1Click(Sender: TObject);
begin
  Cascade;
end;

procedure TParentForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteIniFileData;
  OpenWriteFiles := nil;
  OpenUncFiles := nil;
//  if not (csDesigning in ComponentState) then
   //  DeallocateHWnd(FHwnd);      // this causes crash so commented out.

end;

procedure TParentForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  HH.HtmlHelp(0, nil, HH_CLOSE_ALL, 0);
end;

procedure TParentForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TParentForm.EditwithWizard1Click(Sender: TObject);
begin
  If CheckValidForm then
    If IsLinkForm then MessageDlg('Wizard must be activated from within a single segment',mtinformation,[mbok],0)
                  else GetStudyForm.WizBtnClick(nil);
end;

procedure TParentForm.ShowBigButtons1Click(Sender: TObject);
Var i: Integer;
begin
  ShowBigButtons := Not(ShowBigButtons);

  If ShowBigButtons then ShowBigButtons1.Caption := 'Hide Big &Buttons'
                    else ShowBigButtons1.Caption := 'Show Big &Buttons';

  for i:= 0 to MdiChildCount - 1 do
    Begin
      If MDIChildren[i].Tag=56 then
        Begin
          TPrimaryInterface(MDIChildren[i]).Show_Study_Info;
          TPrimaryInterface(MDIChildren[i]).AdjustOnButtonChange
        End;
    End;


  {}
end;

procedure TParentForm.EnterWizard1Click(Sender: TObject);
Var ActForm: TForm;
begin
  ActForm := ActiveMDIChild;
  If (ActForm<>nil)
    then
      If ActForm.Tag = 56
        then TPrimaryInterface(ActForm).WizBtnClick(nil)
        else New1Click(nil)
    else New1Click(nil);
end;

procedure TParentForm.ExportToGenscnClick(Sender: TObject);
Var ActForm: TForm;
begin
  ActForm := ActiveMDIChild;
  If CheckValidForm then
   With LBasinsInfo do
    If IsLinkForm
     then ExportGenScn(True,FindActiveStudy,TLinkedForm(ActForm).LinkedSegmts)
     else ExportGenScn(False,FindActiveStudy,nil);
end;

procedure TParentForm.EditTrophicInteractions1Click(Sender: TObject);
begin
  If IsLinkForm
    then GetLinkForm.EditTrophInt
    else If CheckValidForm
      then GetStudyForm.EditTrophInt;
end;

procedure TParentForm.EditAllPlantLinkages1Click(Sender: TObject);
begin
  If IsLinkForm
    then GetLinkForm.EditPlantLink
    else If CheckValidForm
      then GetStudyForm.EditPlantLink;
end;


procedure TParentForm.ImportDatafromSWAT1Click(Sender: TObject);
Var   PNewStudy : TAQUATOXSegment;
begin
  Application.CreateForm(TLBasinsInfo, LBasinsInfo);
  Try

  OpenDialog1.InitialDir := SwatDir;
  OpenDialog1.Title := 'Select a Completed SWAT Simulation to Import Data From';
  OpenDialog1.Filter := 'SWAT I/O files (*.cio)|*.CIO';
  If not OpenDialog1.Execute then Exit;

  LBasinsInfo.Get_SWAT_Linkage(OpenDialog1.FileName,PNewStudy);

  If PNewStudy = nil then exit;

  Panel1.Visible := False;
  TPrimaryInterface.Create(Self,PNewStudy);
  Invalidate;

  LBasinsInfo.HSPFPanel.Visible := False;
  LBasinsInfo.GISPanel.Visible  := False;
  LBasinsInfo.SwatPanel.Visible := True;
  If LBasinsInfo.ShowModal = MrOK then
    Begin
      If CheckValidForm then GetStudyForm.WizBtnClick(nil);
      Show;
    End;

  Finally
    LBasinsInfo.Free;
  End;
  {}
end;

procedure TParentForm.ImportWDMClick(Sender: TObject);
Var CurrentStudy: TAQUATOXSegment;

begin
  If Not IsLinkForm then
    If CheckValidForm then
      Begin
        CurrentStudy := FindActiveStudy;
        If CurrentStudy = nil then exit;

        Application.CreateForm(TLBasinsInfo, LBasinsInfo);
        Try

      //  OpenDialog1.InitialDir := SwatDir;
        OpenDialog1.Title := 'Select a WDM File to Import Data From';
        OpenDialog1.Filter := 'WDM files (*.wdm)|*.WDM';
        If not OpenDialog1.Execute then Exit;

        LBasinsInfo.WDMFile := OpenDialog1.FileName;
        LBasinsInfo.Scenario := '';
        LBasinsInfo.Location := '';

        LBasinsInfo.Get_HSPF_Linkage(CurrentStudy, False);

        Finally
          LBasinsInfo.Free;
        End;
      End;

     UpdateMenu(CurrentStudy);
end;

procedure TParentForm.RunBatch1Click(Sender: TObject);
Var  PNewStudy : TAQUATOXSegment;
     ThisInterface: TPrimaryInterface;
     DateHolder: String;
     UseMultipliers: Boolean;

   PROCEDURE OUTPUTBATCH;
   Var F,OutF      : Textfile;
       FileName    : String;
       CurrResults : TResults;
       L, Indx     : Integer;
       ToxLoop,Loop: AllVariables;
       RC          : TResultsCollection;
       FileInit    : Boolean;

   BEGIN
     FileInit := False;
     AssignFile(F,Studies_Dir+'batch\batch.txt');
     Try
       Reset(F);
     Except
       Raise EAQUATOXError.Create('Cannot Read "STUDIES\batch\batch.txt"');
       Exit;
     End;

     While Not EOF(F) do
       Begin
         Readln(F,FileName);

           {*************************************}
           {            READING STUDY            }
           {*************************************}

           WaitDlg.Setup('Please Wait One Moment, Loading File');
           ParentForm.Menu :=nil;
           Toolbar.visible:= False;

           FileName := Studies_Dir+'batch\' + FileName;

           PNewStudy := nil;

           {Load the File}
           WaitDlg.Setup('Please Wait One Moment, Loading File');

              Try
                LoadFile(PNewStudy, FileName);
              Except
                PNewStudy:=nil;
                WaitDlg.Hide;
                ParentForm.Menu := MainMenu1;
                Toolbar.visible:= True;

                Raise;
                Exit;
              End;

              Panel1.Visible := False;
              WaitDlg.Hide;

              ThisInterface := TPrimaryInterface.Create(Self,PNewStudy);


           {*************************************}
           {          SETUP OUTPUT FILE          }
           {*************************************}

           If Not FileInit then
             Begin
               AssignFile(OutF,Studies_Dir+'batch\batchout.csv');
               Rewrite(OutF);

               Write(OutF,'StudyName,');
               RC          := PNewStudy.SV.Results[Epilimnion];
               CurrResults := RC.At(PNewStudy.SV.Results[Epilimnion].Count-1);

               For ToxLoop := FirstOrgTox to LastOrgTox do
                 For Loop := FirstBiota to LastBiota do
                   Begin
                     Indx := CurrResults.GetIndex(Loop,AssocToxTyp(ToxLoop),watercol, False,False,false,1,0,RC);
                     If Indx > -1 then Write(OutF,TResHeader(RC.Headers.At(Indx)).ListStr(False),',');
                   End;

               Writeln(OutF);
               FileInit := True;
             End;

           {*************************************}
           {       WRITE RESULTS FROM STUDY      }
           {*************************************}

           Write(OutF,FileName+',');
           For ToxLoop := FirstOrgTox to LastOrgTox do
             For Loop := FirstBiota to LastBiota do
               Begin
                 RC          := PNewStudy.SV.Results[Epilimnion];
                 CurrResults := RC.At(PNewStudy.SV.Results[Epilimnion].Count-1);
                 L := CurrResults.GetIndex(Loop,AssocToxTyp(ToxLoop),WaterCol,False,False,False,1,0,RC);
                 If L <> -1 then Write(OutF,FloatToStr(TDataPoint(CurrResults.DataPoints.At(L)).State),',')
               End;
           Writeln(OutF);

           ThisInterface.free;
       End;

    {*************************************}
    {            CLEAN UP                 }
    {*************************************}
    ParentForm.Menu := MainMenu1;
    Toolbar.visible:= True;

    CloseFile(OutF);
    CloseFile(F);
    MessageDlg('Batch Output Summary Complete.  Data written to '+Studies_Dir+'\batch\batchout.csv',Mtinformation,[mbok],0);

   END; {OUTPUTBATCH}

   PROCEDURE RUNBATCH;
   Var F: Textfile;
    MultStr, FileName: String;
    TSSMult, NMult, PMult: Double;
    PC : Integer;
    TSV : TStateVariable;

   BEGIN
     TSSMult := -1; PMult := -1; NMult := -1;

     AssignFile(F,Studies_Dir+'batch\batch.txt');
     Try
       Reset(F);
     Except
       Raise EAQUATOXError.Create('Cannot Read "STUDIES\batch\batch.txt"');
       Exit;
     End;

     ParentForm.Menu := nil;
     Toolbar.visible:= False;

     While Not eof(F) do
       Begin
         Readln(F,FileName);

         UseMultipliers := False;
         PC := POS(',',Filename);
         If PC > 0 then
           Begin
             UseMultipliers := True;
             MultStr := RightStr(FileName,Length(Filename)-PC);
             FileName := LeftStr(FileName,PC-1);
             PC := POS(',',MultStr);
             If PC <= 0
               then Begin
                      NMult := StrToFloat(MultStr);
                      PMult := -1;
                      TSSMult := -1;
                    End
               else Begin
                      NMult := StrToFloat(LeftStr(MultStr,PC-1));
                      MultStr := RightStr(MultStr,Length(MultStr)-PC);
                      PC := POS(',',MultStr);
                      If PC <= 0
                        Then
                          Begin
                            PMult := StrToFloat(MultStr);
                            TSSMult := -1;
                          End
                        Else
                          Begin
                            PMult := StrToFloat(LeftStr(MultStr,PC-1));
                            TSSMult := StrToFloat(RightStr(MultStr,Length(MultStr)-PC));
                          End;
                    End;
           End;

         If Uppercase(ExtractFileExt(FileName))='.ALS'
           then   MessageDlg2('Batch mode is not enabled for linked mode studies.',mtError,[mbok],0)
           Else
             Begin

             FileName := ChangeFileExt(FileName,'.APS');

             DateTimeToString(DateHolder,'mm-d-y t',Now);
             Writeln(BatchLog,'Running "'+FileName+'" at '+DateHolder);

             If FileExists(Studies_Dir+'batch\'+FileName) then
               Begin

                 {*************************************}
                 {            READING STUDY            }
                 {*************************************}

                 WaitDlg.Setup('Please Wait One Moment, Loading File');

                 FileName := Studies_Dir+'batch\' + FileName;

                 PNewStudy := nil;

                 Try
                   LoadFile(PNewStudy,FileName);
                 Except
                   PNewStudy:=nil;
                   WaitDlg.Hide;
                   ParentForm.Menu := MainMenu1;
                   Toolbar.visible:= True;
                   Raise;
                 End;

                 If PNewStudy=nil then
                   Begin
                     ParentForm.Menu := MainMenu1;
                     Toolbar.visible:= True;
                     WaitDlg.Hide;
                     Exit;
                   End;

                 WaitDlg.Hide;
                 Panel1.Visible := False;

                 ThisInterface := TPrimaryInterface.Create(Self,PNewStudy);
                 ThisInterface.Enabled := False;
                 ParentForm.Menu := nil;
                 Toolbar.visible:= False;

                 Invalidate;

                 {*************************************}
                 {            ALTERING STUDY           }
                 {*************************************}

                 If UseMultipliers then
                   Begin
                     TSV := PNewStudy.SV.GetStatePointer(Nitrate,StV,WaterCol);
                     TSV.LoadsRec.MultLdg := NMult;

                     TSV := PNewStudy.SV.GetStatePointer(Phosphate,StV,WaterCol);
                     If PMult > -1 then TSV.LoadsRec.MultLdg := PMult;

                     TSV := PNewStudy.SV.GetStatePointer(TSS,StV,WaterCol);
                     If (TSV<>nil) and (TSSMult > -1) then TSV.LoadsRec.MultLdg := TSSMult;

                     FileName := LeftStr(FileName,Length(FileName)-Length(ExtractFileExt(FileName)));
                     FileName := FileName + '_'+ FloatToStrf(NMult,ffgeneral,2,2) + '_'
                                               + FloatToStrf(PMult,ffgeneral,2,2) + '_'
                                               + FloatToStrf(TSSMult,ffgeneral,2,2) + '.aps';

                     PNewStudy.FileName := RightStr(FileName,Length(FileName)-Length(ExtractFilePath(FileName)));
                   End;

                 {*************************************}
                 {            RUNNING STUDY            }
                 {*************************************}

                 Try
                   ThisInterface.RunButtonClick(nil);

                 Repeat
                   Application.ProcessMessages;
                 Until PNewStudy.SimsRunning =0;

                 Except
                  ParentForm.Menu := MainMenu1;
                  Toolbar.visible:= True;
                  Raise;
                 End;

                 If BatchDlg.RunCtrl.Checked then
                   Begin
                     Try
                       ThisInterface.ControlButtClick(nil);

                     Repeat
                       Application.ProcessMessages;
                     Until PNewStudy.SimsRunning =0;

                     Except
                      ParentForm.Menu := MainMenu1;
                      Toolbar.visible:= True;
                      Raise;
                     End;
                   End;

                 {*************************************}
                 {            SAVING STUDY             }
                 {*************************************}


                 Try
                   If BatchDlg.SteinBox.Checked then
                       SteinhausExport(ChangeFileExt(FileName,'.CSV'),PNewStudy);   //fixed 2/10/2011
                 Except
                   Writeln(BatchLog,'ERROR Writing Steinhouse Indices for '+Studies_Dir+'batch\'+FileName);
                   BatchErr := True;
                 End;


                 ThisInterface.Save1Click(nil);

                 ThisInterface.Free;
              End
            Else  {filexists = false}
              Begin
                Writeln(BatchLog,'File Does Not Exist: '+Studies_Dir+'batch\'+FileName);
                BatchErr := True;
              End;
         End; {No Linked Error}
       End;  {While}

    {*************************************}
    {            CLEAN UP                 }
    {*************************************}
    ParentForm.Menu := MainMenu1;
    Toolbar.visible:= True;

    CloseFile(F);
    MessageDlg('Batch Run Complete.',Mtinformation,[mbok],0);


   END; {Runbatch}


Begin
  Application.CreateForm(TBatchDlg, BatchDlg);
    If BatchDLG.ShowModal = MrCancel then exit;

  Try
    BatchIsRunning := True;
    BatchErr := False;
    AssignFile(BatchLog,Studies_Dir+'batch\batchlog.txt');
    Rewrite(BatchLog);

    If BatchDlg.IsOutput then OutputBatch
                         else RunBatch;

  Finally
    DateTimeToString(DateHolder,'mm-d-y t',Now);
    Writeln(BatchLog,'Batch Run Complete at '+DateHolder);
    Closefile(BatchLog);
    BatchIsRunning := False;
    BatchDlg.Free;
    UpdateMenu(FindActiveStudy);
  End;

  If BatchErr then MessageDlg('NOTE: Error or Information Written to STUDIES\BATCH\BATCHLOG.TXT',mtinformation,[mbok],0);

End;


Procedure TParentForm.SteinHausExport(St: String; OutputStudy: TAQUATOXSegment);

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

Const NumIndices = 5;
      StartIndex: Array [0..NumIndices] of AllVariables = (NullStateVar,FirstPlant, FirstAnimal, FirstInvert, FirstFish, FirstPlant);
      EndIndex:   Array [0..NumIndices] of AllVariables = (NullStateVar,LastPlant, LastAnimal, LastInvert, LastFish,LastFish);
      NameIndex:  Array [0..NumIndices] of String = ('Date','Plants','Animals','Invertebrates','Fish','All Organisms');

Var LC,LP, j, NumValues, LoopIndices: Integer;
    LoopVars: AllVariables;
    Control_Num, Perturbed_Num: Double;
    SumMin,SumCon,SumPer: Double;
    Control_Results,Perturbed_Results  : TResults;
    PH: TResHeader;
    OutFile: Textfile;

Begin

    Begin

      NumValues:= OutputStudy.SV.Results[Epilimnion].Count;
      If (NumValues<>OutputStudy.SV.ControlResults[Epilimnion].Count) then
        Begin
          MessageDlg2('Cannot write Steinhaus Indices, Control and Perturbed Results are Different Length.',mtError,[mbok],0);
          Exit;
        End;

      AssignFile(OutFile,St);
      Rewrite(OutFile);

      For LoopIndices := 0 to NumIndices do
            Write(OutFile, NameIndex[LoopIndices],',');
      Writeln (Outfile);

      j := 0;
      While j <= NumValues -1 do
       Begin
        For LoopIndices := 0 to NumIndices do
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
                       LP := PH.PointIndex;
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

            If LoopIndices=0 then Write(Outfile,DateToStr(Control_Results.Date),',')
                             else Write(Outfile,(2*SumMin/(SumCon+SumPer)),',');

          End; {Loop}

        j := j + 1;
        Writeln (OutFile);
        End;

      Closefile(OutFile);
{      XLSWrite1.CloseFile; }
      MessageDlg2('Steinhaus Indices Written to CSV File.',mtinformation,[mbok],0);  

    End;

End;




procedure TParentForm.SetEditColor1Click(Sender: TObject);
begin
  MessageDlg('Select the color which you would like to use as the background color when editing text.  '+
              'The text color will be black, so select a light color that black will show up against.',
              MTInformation,[mbok],0);
  ColorDialog1.Color := EditColor ;
  ColorDialog1.Execute;
  EditColor := ColorDialog1.Color;
end;

procedure TParentForm.AddSandSiltClayModel1Click(Sender: TObject);
begin
  If CheckValidForm then GetStudyForm.AddSSC(True);
end;

procedure TParentForm.AddSedimentDiagenesis1Click(Sender: TObject);
begin
   If CheckValidForm then GetStudyForm.AddDiagenesis;
end;

procedure TParentForm.AddSedimentModel1Click(Sender: TObject);
begin
   If CheckValidForm then GetStudyForm.AddSedimentModel1Click(nil);
end;

procedure TParentForm.RemoveSandSiltClayModel1Click(Sender: TObject);
begin
   If CheckValidForm then GetStudyForm.RemoveSSC(True);
end;

procedure TParentForm.RemoveSedimentDiagenesis1Click(Sender: TObject);
begin
   If CheckValidForm then GetStudyForm.RemoveDiagenesis;
end;

procedure TParentForm.RemoveSedimentModel1Click(Sender: TObject);
begin
   If CheckValidForm then GetStudyForm.RemoveSedimentModel1Click(nil);
end;

procedure TParentForm.AddBuriedSedLayer1Click(Sender: TObject);
begin
   If CheckValidForm then GetStudyForm.AddBuriedSedLayer1Click(nil);
end;

procedure TParentForm.RemoveBuriedSedLayer1Click(Sender: TObject);
begin
   If CheckValidForm then GetStudyForm.RemoveBuriedSedLayer1Click(nil);
end;

procedure TParentForm.AddNonReactiveSedLayer1Click(Sender: TObject);
begin
   If CheckValidForm then GetStudyForm.AddNonReactiveSedLayer1Click(nil);
end;

procedure TParentForm.NewLinkedSimulation1Click(Sender: TObject);
Var LinkedForm: TLinkedForm;
begin
  LinkedForm := TLinkedForm.Create(Self,nil);
  LinkedForm.LinkedSegmts := nil;
  LinkedForm.New1Click(nil);
  Panel1.Visible := False;
  {}
end;

procedure TParentForm.Shorebirds1Click(Sender: TObject);
begin
   If IsLinkForm
    then exit
    else If CheckValidForm then GetStudyForm.BirdButtClick(nil);
end;

procedure TParentForm.Exportto21Databases1Click(Sender: TObject);
begin
  If MessageDlg('This function will export all plants and animals in the existing simulation into a pair of '+
                'existing Release 2.2 databases.  All existing animals and plants with the same name will be overwritten.',
                mtconfirmation,[mbok,mbcancel],0) = mrcancel then exit;
  If IsLinkForm
    then GetLinkForm.Export_to_2_2
    else If CheckValidForm
      then GetStudyForm.Export_to_2_2;

end;

procedure TParentForm.ExportParametersAsText1Click(Sender: TObject);

Begin
  If IsLinkForm
    then GetLinkForm.ExportLinkedParmsToText
    else If CheckValidForm
      then GetStudyForm.ExportParametersAsText;
End;



procedure TParentForm.AddaNewLibrary1Click(Sender: TObject);
{Var FileN, TypeStr, DBFileN, LibName: String;
    Table1: TTable; }
begin
{   Application.CreateForm(TLibTypeForm, LibTypeForm);
   If LibTypeForm.ShowModal = MROK then
     Begin
       If LibTypeForm.AnimalButton.Checked then
         Begin
           TypeStr := '.ADB';
           DBFileN := 'AnimForm';
           LibName := 'Animal';
         End;

       If LibTypeForm.PlantButton.Checked then
         Begin
           TypeStr := '.PDB';
           DBFileN := 'PlntForm';
           LibName := 'Plant';
         End;

       If LibTypeForm.SiteButton.Checked then
         Begin
           TypeStr := '.SDB';
           DBFileN := 'SiteForm';
           LibName := 'Site';
         End;

       If LibTypeForm.ChemButton.Checked then
         Begin
           TypeStr := '.CDB';
           DBFileN := 'ChemForm';
           LibName := 'Chemical';
         End;

       If LibTypeForm.ReminButton.Checked then
         Begin
           TypeStr := '.RDB';
           DBFileN := 'RemnForm';
           LibName := 'Remin';
         End;

       SaveDialog1.InitialDir := Default_Dir;
       SaveDialog1.Title := 'Select a Filename for a new empty '+LibName + ' Library ';
       SaveDialog1.Filter := LibName + ' DBs (*'+Lowercase(TypeStr)+')|*'+TypeStr+'|Paradox DBs (*.db)|*.DB';
       If not SaveDialog1.Execute then Exit;

       If not AQTCopyFile(Default_Dir+DBFileN+'.db',SaveDialog1.FileName) then exit;


       If not AQTCopyFile(Default_Dir+DBFileN+'.PX',ExtractFileN(SaveDialog1.FileName)+'.px') then exit;


       ExportTable.DatabaseName :=
       ExportTable.EmptyExportTable;

       MessageDlg('Library Successfully Created',mtinformation,[mbok],0);


     End;

   LibTypeForm.Free;          }
end;

procedure TParentForm.ExporttoRel3Databases1Click(Sender: TObject);
begin
    If MessageDlg('This function will export all plants and animals in the existing simulation into a pair of '+
                'existing Release 3 databases.  All existing animals and plants with the same name will be overwritten.',
                mtconfirmation,[mbok,mbcancel],0) = mrcancel then exit;
  If IsLinkForm
    then GetLinkForm.Export_to_3
    else If CheckValidForm
      then GetStudyForm.Export_to_3;
end;

end.
