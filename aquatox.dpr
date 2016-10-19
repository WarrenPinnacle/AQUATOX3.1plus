program Aquatox;

//AQUATOX SOURCE CODE Copyright (c) 2008 Eco Modeling
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//

uses
  Windows,
  ShFolder,
  Forms,
  Dialogs,
  SysUtils,
  Corr_Edit in 'Corr_Edit.pas' {EditCorrForm},
  ANIMAL in 'ANIMAL.PAS' {Edit_Animal},
  remin in 'remin.pas' {Remineralization},
  SITE in 'SITE.PAS' {Edit_Site},
  MAIN in 'MAIN.PAS' {PrimaryInterface},
  librarys in 'librarys.pas' {Library_File},
  sv_io in 'sv_io.pas' {SV_IO_Form},
  PRINTING in 'PRINTING.PAS' {PrintCoverForm},
  Basins_BOD in 'Basins_BOD.PAS' {BODForm},
  NEWSTUDY in 'NEWSTUDY.PAS' {NewStudyDialog},
  NOTESDLG in 'NOTESDLG.PAS' {NotesDialog},
  INSRTDLG in 'INSRTDLG.PAS' {InsertStateDialog},
  edstatev in 'edstatev.pas' {conv},
  PROGRESS in 'PROGRESS.PAS' {ProgressDialog},
  SITESCRE in 'SITESCRE.PAS' {SiteDialog},
  DBENTRY in 'DBENTRY.PAS' {Db_GetEntry},
  output in 'output.pas' {OutputScreen},
  graphchoice2 in 'graphchoice2.pas' {GraphChoice2},
  STUDY_IO in 'STUDY_IO.PAS' {Study_IO_Dlg},
  results in 'results.pas' {ResultsForm},
  trophmatrix in 'trophmatrix.pas' {EditTrophIntForm},
  initcond in 'initcond.pas' {InitCondForm},
  SPLASH in 'SPLASH.PAS' {SplashForm},
  global in 'global.pas',
  AQSITE in 'AQSITE.PAS',
  LOADINGS in 'LOADINGS.PAS',
  u_setup in 'u_setup.pas' {USetupForm},
  ChangVar in 'ChangVar.Pas' {ChangeVarForm},
  Estuary_Loads in 'Estuary_Loads.pas' {EstuaryLoadForm},
  imp_load in 'imp_load.pas' {ImportForm},
  RateScrn in 'RateScrn.pas' {RSetupForm},
  Control in 'Control.pas' {ControlForm},
  PFAK2s in 'PFAK2s.pas' {PFAK2Form},
  ec50lc50 in 'ec50lc50.pas' {ec50lc50dialog},
  regress in 'regress.pas' {regrdialog},
  GraphArrange in 'GraphArrange.pas' {GraphArrangeForm},
  Librarys2 in 'Librarys2.pas' {Library_File1},
  StratFlow in 'StratFlow.pas' {StratFlowForm},
  uncert in 'uncert.pas' {DistributionForm},
  MigrEdit in 'MigrEdit.pas' {DistributionForm},
  clearresults in 'clearresults.pas' {ClearResForm},
  GraphSetup in 'GraphSetup.pas' {GraphSetupScreen},
  graphchc in 'graphchc.pas' {GraphChoiceDlg},
  getfishage in 'getfishage.pas' {GetFishForm},
  multifish in 'multifish.pas' {MultFishForm},
  trophint in 'trophint.pas' {TrophIntForm},
  batch in 'batch.pas' {BatchDlg},
  LinkedSegs in 'LinkedSegs.Pas',
  LinkedInterface in 'LinkedInterface.pas' {LinkedForm},
  Convert in 'Convert.pas' {ConvertForm},
  LinkEdit in 'LinkEdit.Pas' {LinkForm},
  Debug in 'Debug.pas' {DebugScreen},
  morphedit in 'morphedit.pas' {MorphDlg},
  Detrscreen in 'Detrscreen.pas' {EditDetritus},
  SedLayers in 'SedLayers.pas' {EditSedForm},
  Parent in 'Parent.pas' {ParentForm},
  LibraryType in 'LibraryType.pas' {LibTypeForm},
  matrixmath in 'matrixmath.pas',
  aquatox_TLB in 'aquatox_TLB.pas',
  ATCData_TLB in 'ATCData_TLB.pas',
  DBGrids2 in 'DBGrids2.pas',
  Observed_Data in 'Observed_Data.pas' {Edit_Data_Form},
  DefaultGraphs in 'DefaultGraphs.pas' {DefaultGraphForm},
  ExportResults in 'ExportResults.pas',
  Diagenesis_Calcs in 'Diagenesis_Calcs.pas',
  LinkedExcelTemplate in 'LinkedExcelTemplate.pas' {LinkedExcelForm},
  AQTOpenDialog in 'AQTOpenDialog.pas',
  Stat_Calc in 'Stat_Calc.pas' {Statistic_Form},
  ExcelFuncs in 'ExcelFuncs.pas',
  Grid2Excel in 'Grid2Excel.pas',
  aqstudy in 'aqstudy.pas',
  aquaobj in 'aquaobj.pas',
  basins in 'basins.pas' {LBasinsInfo},
  chemtox in 'chemtox.pas' {ChemToxForm},
  Diagenesis in 'Diagenesis.pas' {DiagenesisForm},
  TSI_Calc in 'TSI_Calc.pas' {TSI_Form},
  Plant in 'Plant.pas' {Edit_Plant},
  chem in 'chem.pas' {Edit_Chemical},
  Anadromous in 'Anadromous.pas' {AnadromousForm},
  setup in 'setup.pas' {StudySetupDialog},
  Thread in 'Thread.pas',
  LinkedThread in 'LinkedThread.pas',
  linkstrat in 'linkstrat.pas' {StratDialog},
  TCollect in 'TCollect.pas',
  BufferTStream in 'BufferTStream.pas',
  wiz_17 in 'wiz_17.pas',
  wiz_4 in 'wiz_4.pas',
  wait in 'wait.pas' {WaitDlg},
  WinHelpViewer in 'WinHelpViewer.pas',
  WinHelpViewer2 in 'WinHelpViewer2.pas',
  wiz_0 in 'wiz_0.pas',
  wiz_1 in 'wiz_1.pas',
  Wiz_2 in 'Wiz_2.pas',
  wiz_3 in 'wiz_3.pas',
  wiz_5 in 'wiz_5.pas',
  Wiz_6 in 'Wiz_6.pas',
  wiz_7 in 'wiz_7.pas',
  Wiz_8 in 'Wiz_8.pas',
  Wiz_9 in 'Wiz_9.pas',
  Wiz_10 in 'Wiz_10.pas',
  Wiz_11 in 'Wiz_11.pas',
  Wiz_12 in 'Wiz_12.pas',
  Wiz_13 in 'Wiz_13.pas',
  Wiz_14 in 'Wiz_14.pas',
  Wiz_15 in 'Wiz_15.pas',
  wiz_16 in 'wiz_16.pas',
  wiz_18 in 'wiz_18.pas',
  wiz_19 in 'wiz_19.pas',
  wiz_20 in 'wiz_20.pas',
  wiz_dbentry in 'wiz_dbentry.pas',
  Wiz_Fish1 in 'Wiz_Fish1.pas',
  wiz_fish2 in 'wiz_fish2.pas',
  wiz_unfinished in 'wiz_unfinished.pas',
  wizardbase in 'wizardbase.pas' {WizBase},
  WizardProg in 'WizardProg.pas' {WizardProgress},
  WizardSumm in 'WizardSumm.pas' {WizSummary},
  wizglobal in 'wizglobal.pas';

{$R *.RES}

Var Timecheck: TDatetime;

procedure RegistryCFX;
var
  hOCX:integer;
  pReg: procedure;

begin
  hOCX := LoadLibrary('CFX32.OCX');
  if (hOCX <> 0) Then
  begin
       pReg := GetProcAddress(hOCX,'DllRegisterServer');
       pReg;    { Call the registration function }
       FreeLibrary(hOCX);
  end;

end;

Var ReadFileN, ReadStr, SentParam: String;

{    LIPSKYFILE: TEXTFILE;
    POSITN: INTEGER; }

begin
 // ReportMemoryLeaksOnShutdown := DebugHook <> 0;  {report mem leaks}

(*  { -----------     LIPSKY CODE  ------------------ }

TRY
  ASSIGN(LIPSKYFILE,ExtractFilePath(Application.ExeName)+'NUTRIENT_REMOVAL.TXT');
  RESET(LIPSKYFILE);
  READLN(LIPSKYFILE,READSTR);
  POSITN := Pos(':',ReadStr);
  If POSITN = 0 then Raise EAQUATOXERROR.Create('No ":" on line 1');
  DELETE(ReadStr,1,POSITN);
  P_REMOVAL_S_LP := StrToFloat(ReadStr);

  READLN(LIPSKYFILE,READSTR);
  POSITN := Pos(':',ReadStr);
  If POSITN = 0 then Raise EAQUATOXERROR.Create('No ":" on line 2');
  DELETE(ReadStr,1,POSITN);
  N_REMOVAL_S_LP := StrToFloat(ReadStr);

  CLOSEFILE(LIPSKYFILE);

  ReadStr := 'FLOW FIELD S-LP, P REMOVAL: '+FloatToStrF(P_REMOVAL_S_LP,fffixed,5,1)+'%';
  ReadStr := ReadStr + '; N REMOVAL: '+FloatToStrF(N_REMOVAL_S_LP,fffixed,5,1)+'%';
  MESSAGEDLG(ReadStr,mtinformation,[mbok],0);

EXCEPT
  MESSAGEDLG('PROBLEM WITH NUTRIENT REMOVAL FILE '+ReadFileN,mterror,[mbok],0);
  N_REMOVAL_S_LP := 0;
  P_REMOVAL_S_LP := 0;

END;

  { -----------     LIPSKY CODE  ------------------ }  *)


  DecimalSeparator := '.';
  UseLatestCommonDialogs := False;

  Application.Initialize;
  Application.Title := 'AQUATOX Release 3.1 plus';
  Application.ShowHint := True;
  Application.CreateForm(TParentForm, ParentForm);
  Application.CreateForm(TLinkedExcelForm, LinkedExcelForm);
  Application.CreateForm(TStatistic_Form, Statistic_Form);
  Application.CreateForm(TLBasinsInfo, LBasinsInfo);
  Application.CreateForm(TChemToxForm, ChemToxForm);
  Application.CreateForm(TDiagenesisForm, DiagenesisForm);
  Application.CreateForm(TAnadromousForm, AnadromousForm);
  Application.CreateForm(TTSI_Form, TSI_Form);
  Application.CreateForm(TEdit_Plant, Edit_Plant);
  Application.CreateForm(TEdit_Chemical, Edit_Chemical);
  Application.CreateForm(TAnadromousForm, AnadromousForm);
  Application.CreateForm(TStudySetupDialog, StudySetupDialog);
  Application.CreateForm(TStratDialog, StratDialog);
  SentParam := ParamStr(1);
  If SentParam<>''
    then ParentForm.IncomingFile := SentParam;

  Application.CreateForm(TWaitDlg, WaitDlg);
  Application.CreateForm(TSplashForm, SplashForm);
  SplashForm.VersionInfo.Visible := False;
  SplashForm.Show;
  SplashForm.Update;
  TimeCheck:=Now;

  Repeat Until Now-TimeCheck>2.8e-5; {Hold splash form for a minimum of 2 seconds}
  SplashForm.Hide;
  ParentForm.CheckBasinsLinkage;

  Application.Run;
end.
