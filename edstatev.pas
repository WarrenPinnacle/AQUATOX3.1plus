//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
Unit Edstatev;
{ Bring up the dialog to edit state variables and interface with
  the underlying data editing: JSC }

Interface

Uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Grids, ExtCtrls, AquaObj, DB, DBTables, DBCtrls, DBGrids,
  Global, Dialogs, SysUtils, Animal,Plant,Chem, SV_IO, DbEntry,
  Loadings, TCollect, MigrEdit, AQBaseForm, Convert;

Type
  T_SVCategory= (SVPlant,SVAnimal,SVChemical,SVTemp,SVWindLight,SVOther);

  SV_Temp_Holder = Record
    AnimalRecord: ZooRecord;
    PlantRecord: PlantRecord;
    ChemRecord: ChemicalRecord;
    SVType : T_SVCategory;
    SVName : ShortString;
    HasData: Boolean;
    InitCond, ConstLoad: Double;
    Alternate_Loadings: Boolean;
    PS_ConstLoad, DP_ConstLoad, NPS_ConstLoad: Double;
    Tox_Air_or_Alk: Double;
    WindMean: Double;
    FracInBed: Double;
    BuriedTox : Array[FirstToxTyp..LastToxTyp] of Double;
    UseConst, NoUserLoad, PS_UseConst,DP_UseConst,NPS_UseConst: Boolean;
    MultLdg,PS_MultLdg,DP_MultLdg, NPS_MultLdg: Double;
    ShowingNPS:    Boolean;
    Notes1, Notes2 : String[50];
    TN_IC,TN_Inflow,TN_PS,TN_NPS: Boolean;

    ShowingPSLoad: Boolean;  {Relevant for Sand..Clay}

    ToxDynamLoad,PSTDL,NPSTDL   : Array [FirstOrgTox..LastOrgTox] of TLoadings;  {Associated Tox Data, inflow, pointsource, nonpointsource}
    ToxPointer                  : Array [FirstOrgTox..LastOrgTox] of TStateVariable;   {Associated Tox Data}
    ToxUseconst,PSUC,NPSUC      : Array [FirstOrgTox..LastOrgTox] of Boolean;          {Associated Tox Data}
    ToxInitCond,ToxMultLdg,ToxConstLoad,
          PSML,PSCL,NPSML,NPSCL : Array [FirstOrgTox..LastOrgTox] of Double;  {Associated Tox Data}

    Calc_M: VolumeMethType;             {relevant to volume screen only}
    SameSpec : AllVariables;            {sm and lg gamefish only}
    Photoperiod: Double;                {light screen only}
    CalcPhotoPeriod: Boolean;           {light screen only}
    TempInitCond, TempConstLoad,        {temp screen only}
                  TempMultLdg : Double; {temp screen only}
    TempUseConst : Boolean;             {temp screen only}
    TempTrophInt : TrophIntArray;       {animal screen only}
    NoSysStrat   : Boolean;             {Temp Screen Only }
    AnimMeth, PlantMeth: UptakeCalcMethodType; {chemtox screen}
    O2CalcDuration: Boolean;            {Oxygen screen only}
    O2Thresh: Double;                   {Oxygen screen only}
    O2NoLoadOrWash: Boolean;            {Oxygen screen only}
    TSSSolids: Boolean;                 {TSS Represents Solids or Inorganics Only?}

    TempCo2Equil : Boolean;
    TempCO2Series: TLoadings;
   End;


Type
  TStateVarDialog = class(TAQBase)
    StatePanel: TPanel;
    DynRadButt: TRadioButton;
    CL_Unit: TLabel;
    ConstRadButt: TRadioButton;
    ICEdit: TEdit;
    IC_Unit: TLabel;
    InitCondLabel: TLabel;
    LoadEdit: TEdit;
    LoadingsLabel: TLabel;
    Label5: TLabel;
    ToxicPanel: TPanel;
    TCL_Unit: TLabel;
    TIC_Unit: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    TDynRadButt: TRadioButton;
    TConstRadButt: TRadioButton;
    TICEDIT: TEdit;
    ATLoadEdit: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Table1: TTable;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Table2: TTable;
    DBGrid2: TDBGrid;
    DBNavigator2: TDBNavigator;
    Button1: TButton;
    MeanRangeButt: TRadioButton;
    CL_Unit2: TLabel;
    TCL_Unit2: TLabel;
    LoadingsPanel: TPanel;
    Panel1: TPanel;
    Table3: TTable;
    DataSource3: TDataSource;
    Table4: TTable;
    DataSource4: TDataSource;
    GasPhasePanel: TPanel;
    Label13: TLabel;
    GasPhaseEdit: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    MultLoadLabel: TLabel;
    MultEdit: TEdit;
    Label18: TLabel;
    TMultEdit: TEdit;
    WindMeanPanel: TPanel;
    WindMeanLabel: TLabel;
    WindMeanEdit: TEdit;
    VolumePanel: TPanel;
    ManningButt: TRadioButton;
    ConstButt: TRadioButton;
    DynamicButt: TRadioButton;
    KnownValButt: TRadioButton;
    DPPanel: TPanel;
    DPLabel: TLabel;
    directunitlabel2: TLabel;
    Label19: TLabel;
    DPLoadEdit: TEdit;
    DPGrid: TDBGrid;
    DBNavigator4: TDBNavigator;
    Panel8: TPanel;
    DPDynRadio: TRadioButton;
    DPConstRadio: TRadioButton;
    DPMultEdit: TEdit;
    PSPanel: TPanel;
    PointUnitLabel: TLabel;
    PointLabel: TLabel;
    PointUnitLabel2: TLabel;
    Label20: TLabel;
    PSDynRadio: TRadioButton;
    PSConstRadio: TRadioButton;
    PSLoadEdit: TEdit;
    PSGrid: TDBGrid;
    DBNavigator3: TDBNavigator;
    PSMultEdit: TEdit;
    ImportButt1: TButton;
    ImportButt3: TButton;
    ImportButt4: TButton;
    ImportButt5: TButton;
    NPSPanel: TPanel;
    NPSUnit: TLabel;
    NPSUnit2: TLabel;
    Label34: TLabel;
    NPSDLRadio: TRadioButton;
    NPSCLRadio: TRadioButton;
    NPSConstLoad: TEdit;
    NPSGrid: TDBGrid;
    DBNavigator6: TDBNavigator;
    NPSMultEdit: TEdit;
    ImportButt6: TButton;
    NPSLabel: TLabel;
    Table5: TTable;
    DataSource5: TDataSource;
    DirectUnitLabel: TLabel;
    NotesEdit: TEdit;
    NotesLabel: TLabel;
    NotesEdit2: TEdit;
    PrintButton: TSpeedButton;
    EraseTable: TTable;
    FracAvail: TButton;
    Anadromous: TButton;
    PhotoPeriodPanel: TPanel;
    Label30: TLabel;
    Label31: TLabel;
    CalcPhotoRadioButton: TRadioButton;
    UsePhotoPeriodRadioButton: TRadioButton;
    ZPhotoperiodEdit: TEdit;
    ToxComboBox: TComboBox;
    LinkInflowWarning: TLabel;
    LinkOutflowWarning: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    EditButton: TButton;
    LoadButton: TButton;
    VolumeButt: TButton;
    PSNPSButt: TButton;
    ToggleButton: TButton;
    LoadingBox2: TComboBox;
    MigrationButton: TButton;
    HypTempPanel: TPanel;
    StratLabel: TLabel;
    YesButt: TRadioButton;
    NoButt: TRadioButton;
    HideTox4: TPanel;
    BuriedToxPanel: TPanel;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label29: TLabel;
    ToxCombobox2: TComboBox;
    OrgToxEdit: TEdit;
    MethMercEdit: TEdit;
    ReactMercEdit: TEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    HelpButton: TButton;
    ToxicityDataButton: TButton;
    SaltPanel: TPanel;
    TotN_IC: TCheckBox;
    TotN_Inflow: TCheckBox;
    TotN_PS: TCheckBox;
    TotN_NPS: TCheckBox;
    nitratelabel: TLabel;
    HourlyCB: TCheckBox;
    O2DurationPanel: TPanel;
    O2DurationCB: TCheckBox;
    O2DurationLabel: TLabel;
    XO2ThreshEdit: TEdit;
    O2DurationUnitLabel: TLabel;
    O2DurationWarningLabel: TLabel;
    O2LoadPanel: TPanel;
    NoO2LoadCB: TCheckBox;
    VolButton2: TButton;
    TSSPanel: TPanel;
    SolidsButton: TRadioButton;
    SedimentButton: TRadioButton;
    TSSLabel: TLabel;
    ConvertButton: TButton;
    ConvertButton2: TButton;
    PSConvertButt: TButton;
    DPConvertButt: TButton;
    ConvertAlk: TButton;
    TempConvert1: TButton;
    TempConvert2: TButton;
    NPSConvertButt: TButton;
    EstSaltButton: TButton;
    SaveButton: TButton;
    EvapButton: TButton;
    CO2EquilButton: TButton;
    procedure Verify_Number(Sender: TObject);
    procedure EnableDisable(Sender: TObject);
    procedure enabledisable2(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
    procedure CancelBtnClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure DBGrid1Exit(Sender: TObject);
    procedure DBGrid2Exit(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure PSGridExit(Sender: TObject);
    procedure DPGridExit(Sender: TObject);
    procedure EnableDisable3(Sender: TObject);
    procedure EnableDisable4(Sender: TObject);

    procedure VerifyMultLdg(Sender: TObject);
    procedure EnableDisable5(Sender: TObject);
    procedure VolumeButtClick(Sender: TObject);
    procedure ImportButt1Click(Sender: TObject);
    procedure PSNPSButtClick(Sender: TObject);
    procedure enabledisable6(Sender: TObject);
    procedure NPSGridExit(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure NotesEditExit(Sender: TObject);
    procedure FracAvailClick(Sender: TObject);
    procedure CalcPhotoRadioButtonClick(Sender: TObject);
    procedure ToxComboBoxChange(Sender: TObject);
    procedure ToggleButtonClick(Sender: TObject);
    procedure MigrationButtonClick(Sender: TObject);
    procedure YesButtClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure TotN_NPSClick(Sender: TObject);
    procedure TotN_InflowClick(Sender: TObject);
    procedure TotN_ICClick(Sender: TObject);
    procedure TotN_PSClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure HourlyCBClick(Sender: TObject);
    procedure O2DurationCBClick(Sender: TObject);
    procedure NoO2LoadCBClick(Sender: TObject);
    procedure VolButton2Click(Sender: TObject);
    procedure SedimentButtonClick(Sender: TObject);
    procedure ConvertButtonClick(Sender: TObject);
    procedure ConvertAlkClick(Sender: TObject);
    procedure EstSaltButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure EvapButtonClick(Sender: TObject);
    procedure CO2EquilButtonClick(Sender: TObject);
    procedure AnadromousClick(Sender: TObject);
Private
    SV: TStateVariable;      {Holds the Pointer to the State Var itself}
    TempSV: SV_Temp_Holder;  {Holds temp info about State Var so user
                              can cancel if he/she wants to}
    Showwarnings: Boolean;
    procedure CopyLipidFractions(JustOne, IsAnimal: Boolean);
    Function CType(Sender: TObject): ConvertType;
  public
    LinkedS, ThisAQTS: Pointer;
    VolumeScreen   : Boolean;
    EstuaryVol     : Boolean;
    SedScreen      : Boolean;
    SaltScreen     : Boolean;
    LightScreen    : Boolean;
    TempScreen     : Boolean;
    BuriedScreen   : Boolean;
    IsDetrScreen   : Boolean;
    LipidModified : Boolean;
    MiddlePosition : Integer;
    TNO3           : TNO3Obj;
    PPhos          : TPO4Obj;

    CurrentTox     : AllVariables;
    LoadType       : Integer;
    NumToxs        : Integer;
    SelTox         : Array[0..20] of AllVariables;
    ToxTable       : Array[FirstOrgTox..LastOrgTox] of TTable;
    WorkingTCB     : TComboBox;
    ToxChanged          : Boolean;
    Biotransfformchanged: Boolean;
    EstVarChanged       : Boolean;
    LinkedM: Boolean;
    Changed: Boolean;
    DontUpdateHCB, UpdatingScr: Boolean;
    procedure SetupForm;
    Procedure EditSV(IncomingS: TStateVariable; LS,TAQTS: Pointer);
    Procedure CopyToTemp;
    Procedure CopyFromTemp;
    Procedure UpdateScreen;
    Procedure LoadingsFromTable(Table: TTable; Var LColl: TLoadings);
    Function  GetSVType(SV: TStateVariable):T_SVCategory;
    { Public declarations }
  end;
{$R *.DFM}

Var
    StateVarDialog : TStateVarDialog;


implementation

uses imp_load, Phosph, ChemTox, regress, EstKPSed, ec50lc50,
  biotransf, Detrscreen, trophmatrix, trophint, StratFlow, hh, Estuary_Loads,
  librarys, Librarys2, SITESCRE, AQStudy, PFAK2s, Anadromous;

{**********************}

Function TStateVarDialog.GetSVType(SV: TStateVariable):T_SVCategory;
{Sort out which type the record is}
Begin
     GetSVType:=SVOther;
     SaltScreen   := (SV.NState = Salinity);
     TempScreen   := (SV.NState = Temperature);
     VolumeScreen := (SV.NState = Volume);
     EstuaryVol   := VolumeScreen and (SV.Location.SiteType=Estuary);
     LightScreen  := (SV.NState = Light);
     SedScreen    := (SV.NState in [Cohesives..NonCohesives2]);
     BuriedScreen := (SV.NState in [BuriedRefrDetr..BuriedLabileDetr]);

     If SV.Nstate in [WindLoading..Light] then GetSVType:=SVWindLight
               else if SV.NState = Temperature then GetSVType := SVTemp
               else If SV.PRequiresData^ then
               If (SV.IsPlant) then GetSVType:=SVPlant
               else if SV.Nstate in [FirstOrgTox..LastOrgTox] then GetSVType:=SVChemical
               else GetSVType:=SVAnimal;
End;

{**********************}

Procedure TStateVarDialog.EditSV(IncomingS: TStateVariable;LS,TAQTS: Pointer);

Begin
 LinkedS := LS;
 ThisAQTS := TAQTS;
 ToxChanged := False;
 EstVarChanged := False;

 If IncomingS.NState in [DissRefrDetr]
   Then
     Begin
       IsDetrScreen := True;
       Application.CreateForm(TEditDetritus, EditDetritus);
       EditDetritus.IsDetrScreen := True;
       EditDetritus.EditDetr(IncomingS);
       EditDetritus.Free;
       Exit;
     End;

 If IncomingS.IsAnimal then Application.CreateForm(TMigrForm, MigrForm);

 IsDetrScreen := False;
 SetupForm;

   Changed:=False;
   SV:=IncomingS;
   LinkedM := SV.AllStates.LinkedMode;
   CopyToTemp;
   UpdateScreen;
   If ShowModal<>MrCancel
     then CopyFromTemp
     else Changed:=(ToxChanged or EstVarChanged);

   Table1.Active:=False; Table2.Active:=False;
   Table3.Active:=False; Table4.Active:=False;
   Table5.Active:=False;

   If (SV.Nstate=Phosphate) then PhosAvailForm.Free;

   If BioTransfFormChanged then Changed:=True;
   If IncomingS.IsAnimal then MigrForm.Free;
End;

{**********************}

Procedure TStateVarDialog.CopyLipidFractions(JustOne, IsAnimal: Boolean);
Var NewLipidFrac : Double;
    ToxLoop   : T_SVType;
    P : Pointer;
    SVLoop, SVBottom, SVTop: AllVariables;
    Confirmed: Boolean;

    Function GetConfirmation: Boolean;
    Begin
      Confirmed := True;
      Result := MessageDlg('Because LipidFrac differs from those in the Chem Tox records, AQUATOX will update the LipidFrac fields in the chemical toxicity records for all toxicants in the study.',
                        mtConfirmation, [mbok,mbcancel], 0) = MrOK;
    End;

Begin
  Confirmed := False;
  If JustOne then Confirmed := True;

  If JustOne then Begin
                    SVBottom := SV.NState;
                    SVTop := SV.NState;
                  End
             else If IsAnimal then
                  Begin
                    SVBottom := FirstAnimal;
                    SVTop := LastAnimal;
                  End
             else {IsPlant}
                  Begin
                    SVBottom := FirstPlant;
                    SVTop := LastPlant;
                  End;

  For SVLoop := SVBottom to SVTop do
   Begin
    P := SV.GetStatePointer(SVLoop,Stv,WaterCol);
    If P<>nil then
     Begin
      If IsAnimal then NewLipidFrac := TAnimal(P).PAnimalData^.FishFracLipid
                  else NewLipidFrac := TPlant(P).PAlgalRec^.PlantFracLipid;

      If IsAnimal then TAnimal(P).Assign_Anim_Tox  {update the Anim_Tox array for this animal}
                  else TPlant(P).Assign_Plant_Tox;

      For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
        If IsAnimal then
         Begin
           If TAnimal(P).Anim_Tox[ToxLoop] <> nil then
            If TAnimal(P).Anim_Tox[ToxLoop].Lipid_Frac <> NewLipidFrac
             then
              Begin
                If Not Confirmed then if Not GetConfirmation then Exit;
                TAnimal(P).Anim_Tox[ToxLoop].Lipid_Frac := NewLipidFrac;
              End
          End {is animal}
        else {is plant}
         If TPlant(P).Plant_Tox[ToxLoop] <> nil then
          If TPlant(P).Plant_Tox[ToxLoop].Lipid_Frac <> NewLipidFrac
           then
            Begin
              If Not Confirmed then if Not GetConfirmation then Exit;
              TPlant(P).Plant_Tox[ToxLoop].Lipid_Frac := NewLipidFrac;
            End
     End; {p<> nil}
   End; {SVLoop}
End;

Procedure TStateVarDialog.CopyToTemp;
{This procedure copies data into temp SV
and loads data into databases for screen updates}

Var TableIn  : TTable;
    ToxLoop2 : AllVariables;
    ToxLoop  : T_SVType;
    PBT      : TBuriedDetrTox1;

         Procedure PutInDbase(P: TLoad);
         {Used to put loadings data into TableIn}
         begin
            Try
              With TableIn do
                 begin
                   Append;
                   Fields[0].AsDateTime:= P.Date;
                   Fields[1].AsFloat:=P.Loading;
                   Post;
                   If (P.Loading>1000) or (P.Loading<0.0001) then
                     Begin
                       TFloatField(Fields[1]).DisplayFormat:='0.0000e-00';
                       TFloatField(Fields[1]).DisplayWidth := 10;
                     End;
                 end;
            Except
              TableIn.Cancel;
              MessageDlg('Warning, Error writing to database, duplicate date may be present ('+DateToStr(P.Date)+ '); one of the loadings for that date will not be loaded.',
                          mterror,[mbok],0);
            End;
         end;
var i: integer;
Begin
   LoadType := 0;
   LoadingBox2.ItemIndex := 0;
   BioTransfFormChanged := False;

  {Find SV Type and Load Records if Relevant}
  With TempSV do
  begin
    SVType:=GetSVType(SV);
    Case SVType of
       SVAnimal: AnimalRecord:=TAnimal(SV).PAnimalData^;
       SVPlant:  PlantRecord:=TPlant(SV).PAlgalRec^;
       SVChemical: ChemRecord:=SV.ChemPtrs^[AssocToxTyp(SV.NState)].ChemRec;
      End; {Case}

    If SVType=SVAnimal then
      Begin
        TempTrophInt := TAnimal(SV).PTrophInt^;
        MigrForm.MigrTemp := TAnimal(SV).MigrInput;
      End;  

    If LightScreen then Photoperiod := TLight(SV).UserPhotoPeriod;
    If LightScreen then CalcPhotoperiod := TLight(SV).CalculatePhotoPeriod;

    If SV.nstate=oxygen then O2CalcDuration:=TO2Obj(SV).CalcDuration;
    If SV.nstate=oxygen then O2Thresh:=TO2Obj(SV).Threshhold;
    If SV.nstate=oxygen then O2NoLoadOrWash:=TO2Obj(SV).NoLoadOrWash;
    If SV.nstate=TSS    then TSSSolids := TSandSiltClay(SV).TSS_Solids;
    If SV.nstate = CO2  then TempCO2Equil := TCO2Obj(SV).ImportCo2Equil;

    If VolumeScreen then Calc_M := TVolume(SV).Calc_Method;

    If SV.nstate in [sand..clay] then FracInBed := TSandSiltClay(SV).FracInBed;
    If SV.nstate = WindLoading   then WindMean := TWindLoading(SV).MeanValue;

    If BuriedScreen then
      For ToxLoop := FirstToxTyp to LastToxTyp do
       begin
         PBT := SV.GetStatePointer(SV.nstate,ToxLoop,WaterCol);
         If (PBT <> nil)
            Then BuriedTox[ToxLoop] := PBT.InitialCond
            Else BuriedTox[ToxLoop] := -99;
       end;

    {Load Other Data from SV}
    SVName     := SV.PName^;
    InitCond   := SV.InitialCond;
    ConstLoad  := SV.LoadsRec.ConstLoad;
    MultLdg    := SV.LoadsRec.MultLdg;
    UseConst   := SV.LoadsRec.UseConstant;
    NoUserLoad := SV.LoadsRec.NoUserLoad;
    HasData    := SV.PHasData^;
    If SVType=SVChemical then
      Begin
        Tox_Air_or_Alk := SV.ChemPtrs^[AssocToxTyp(SV.NState)].Tox_Air;
        AnimMeth :=  SV.ChemPtrs^[AssocToxTyp(SV.NState)].Anim_Method ;
        PlantMeth := SV.ChemPtrs^[AssocToxTyp(SV.NState)].Plant_Method;
      End;
    If SV.NState=pH then Tox_Air_or_Alk := TpHObj(SV).Alkalinity;
    Notes1     := SV.LoadNotes1;
    Notes2     := SV.LoadNotes2;

    If SVType=SVAnimal then SameSpec := TAnimal(SV).PSameSpecies^;
    If SVType=SVPlant then SameSpec := TPlant(SV).PSameSpecies^;

    If SV.Nstate in [Ammonia,Nitrate] then
      Begin
        TNO3 := SV.GetStatePointer(Nitrate,StV,WaterCol);
        TN_IC := TNO3.TN_IC;
        TN_Inflow := TNO3.TN_Inflow;
        TN_PS := TNO3.TN_PS;
        {TN_DP := TNO3.TN_DP; }
        TN_NPS  := TNO3.TN_NPS;
      End;

    If SV.Nstate = phosphate then
      Begin
        PPhos := SV.GetStatePointer(Phosphate,StV,WaterCol);
        TN_IC := PPhos.TP_IC;
        TN_Inflow := PPhos.TP_Inflow;
        TN_PS := PPhos.TP_PS;
        TN_NPS  := PPhos.TP_NPS;
      End;

    NumToxs    := 0;
    CurrentTox := NullStateVar;
    If BuriedScreen then WorkingTCB := ToxComboBox2
                    else WorkingTCB := ToxComboBox;
    WorkingTCB.Items.Clear;
    For ToxLoop2 := FirstOrgTox to LastOrgTox do
      Begin
        If SV.AllStates.GetIndex(SV.nstate,AssocToxTyp(ToxLoop2),WaterCol) > -1 then
          Begin
            SelTox[NumToxs] := ToxLoop2;
            Inc(NumToxs);
            WorkingTCB.Items.Add(SV.ChemPtrs^[AssocToxTyp(ToxLoop2)].ChemRec.ChemName);
            ToxDynamLoad [ToxLoop2] := nil;
            PSTDL        [ToxLoop2] := nil;
            NPSTDL       [ToxLoop2] := nil;

            ToxPointer   [ToxLoop2] := SV.AllStates.GetStatePointer(SV.nstate,AssocToxTyp(ToxLoop2),WaterCol);
            ToxInitCond  [ToxLoop2] := ToxPointer[ToxLoop2].InitialCond;

            ToxConstLoad [ToxLoop2] := ToxPointer[ToxLoop2].LoadsRec.ConstLoad;
            PSCL         [ToxLoop2] := ToxPointer[ToxLoop2].LoadsRec.Alt_Constload[PointSource];
            NPSCL        [ToxLoop2] := ToxPointer[ToxLoop2].LoadsRec.Alt_Constload[NonPointSource];

            ToxMultLdg   [ToxLoop2] := ToxPointer[ToxLoop2].LoadsRec.MultLdg;
            PSML         [ToxLoop2] := ToxPointer[ToxLoop2].LoadsRec.Alt_MultLdg[PointSource];
            NPSML        [ToxLoop2] := ToxPointer[ToxLoop2].LoadsRec.Alt_MultLdg[NonPointSource];

            ToxUseConst  [ToxLoop2] := ToxPointer[ToxLoop2].LoadsRec.UseConstant;
            PSUC         [ToxLoop2] := ToxPointer[ToxLoop2].LoadsRec.Alt_UseConstant[PointSource];
            NPSUC        [ToxLoop2] := ToxPointer[ToxLoop2].LoadsRec.Alt_UseConstant[NonPointSource];

            If CurrentTox = NullStateVar then CurrentTox := ToxLoop2;
          End;
      End;

    WorkingTCB.ItemIndex := 0;

    If TempScreen then
       begin
         NoSysStrat   := SV.AllStates.HypoTempLoads.NoUserLoad;
         TempInitCond := SV.AllStates.HypoTempIC;
         TempConstLoad:= SV.AllStates.HypoTempLoads.ConstLoad;
         TempUseConst := SV.AllStates.HypoTempLoads.UseConstant;
         TempMultLdg  := SV.AllStates.HypoTempLoads.MultLdg;
       end;

    ShowingPSLoad:=True;  {initial panel setup}
    ShowingNPS   :=False;

   If SV.NState in HOURLYLIST then
     Begin
       DontUpdateHCB:= True;
       HourlyCB.Checked := SV.LoadsRec.Loadings.hourly;
       DontUpdateHCB:= False;
     End;

    {Ready the Database Files for the Loadings Data}
    Table1.DatabaseName:=Program_Dir; Table2.DatabaseName:=Program_Dir;
    Table1.Active:=False;             Table2.Active:=False;
                                      Table2.EmptyTable;
                                      Table2.Active:=True;

    If (SV.NState in HOURLYLIST) then if SV.LoadsRec.Loadings.hourly then
      Begin
        Table1.TableName := 'loadhour.DB';
        DBGrid1.Left := 30;
        DBGrid1.Width := 243;
      End;
    Table1.EmptyTable;
    Table1.Active:=True;

    {Load the Database Data into the Files}
    TableIn:=Table1;
    TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
    With SV.LoadsRec.Loadings do For i:=0 to count-1 do
                                  PutInDbase(at(i));

    TableIn:=Table2;
    If CurrentTox <> NullStateVar then
         With ToxPointer[CurrentTox].LoadsRec.Loadings do For i:=0 to count-1 do
                                  PutInDbase(at(i));

    If TempScreen then with SV.AllStates.HypoTempLoads.Loadings do For i:=0 to count-1 do
                                  PutInDbase(at(i));

    If SaltScreen then with SV.LoadsRec.Alt_Loadings[PointSource] do For i:=0 to count-1 do
                                  PutInDbase(at(i));

    If (SV.Nstate=Phosphate) then  {Copy data into fraction phosphate available form}
      Begin
        Application.CreateForm(TPhosAvailForm, PhosAvailForm);
        PhosAvailForm.FracAvail:=TPO4Obj(SV).FracAvail;
        PhosAvailForm.Alt_FracAvail[PointSource]:=TPO4Obj(SV).Alt_FracAvail[PointSource];
        PhosAvailForm.Alt_FracAvail[NonPointSource]:=TPO4Obj(SV).Alt_FracAvail[NonPointSource];
        PhosAvailForm.Alt_FracAvail[DirectPrecip]:=TPO4Obj(SV).Alt_FracAvail[DirectPrecip];
      End;


    If (SV.NState = Co2) then
      Begin
          Table5.DatabaseName:=Program_Dir; Table5.Active:=False;
          Table5.EmptyTable;                Table5.Active:=True;
          {Load the Data into the DB Files}
          TableIn:=Table5;
          TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
            With TCO2Obj(SV).CO2Equil do For i:=0 to count-1 do
                                    PutInDbase(at(i));
      End;


    {*** Additional Loadings Data ***}
    Alternate_Loadings := not (SV.LoadsRec.Alt_Loadings[PointSource] = nil);
    If SaltScreen then
     With SV.LoadsRec do
      Begin
        PS_UseConst:=Alt_UseConstant[PointSource];
        PS_ConstLoad:=Alt_ConstLoad[PointSource];
        PS_MultLdg:=Alt_MultLdg[PointSource];
      End;
    If Alternate_Loadings and (not saltscreen) then
      With SV.LoadsRec do
        Begin
          PS_ConstLoad:=Alt_ConstLoad[PointSource];
          DP_ConstLoad:=Alt_ConstLoad[DirectPrecip];
          NPS_ConstLoad:=Alt_ConstLoad[NonPointSource];
          PS_UseConst:=Alt_UseConstant[PointSource];
          DP_UseConst:=Alt_UseConstant[DirectPrecip];
          NPS_UseConst:=Alt_UseConstant[NonPointSource];
          PS_MultLdg:=Alt_MultLdg[PointSource];
          DP_MultLdg:=Alt_MultLdg[DirectPrecip];
          NPS_MultLdg:=Alt_MultLdg[NonPointSource];

          {Ready the Database Files for the Multiple Loadings Data}
          Table3.DatabaseName:=Program_Dir; Table4.DatabaseName:=Program_Dir;
          Table3.Active:=False;             Table4.Active:=False;
          Table3.EmptyTable;                Table4.EmptyTable;
          Table3.Active:=True;              Table4.Active:=True;
          Table5.DatabaseName:=Program_Dir; Table5.Active:=False;
          Table5.EmptyTable;                Table5.Active:=True;

          {Load the Data into the DB Files}
          TableIn:=Table3;
          TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
            With SV.LoadsRec.Alt_Loadings[PointSource] do For i:=0 to count-1 do
                                    PutInDbase(at(i));

          TableIn:=Table4;
          TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
          With SV.LoadsRec.Alt_Loadings[DirectPrecip] do For i:=0 to count-1 do
                                    PutInDbase(at(i));

          TableIn:=Table5;
          TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
          With SV.LoadsRec.Alt_Loadings[NonPointSource] do For i:=0 to count-1 do
                                    PutInDbase(at(i));

        End;

   End; {With}

  LipidModified:=False;

  If TempSV.SVType=SVChemical then
    Begin
      {Save Toxicity Record to database}
      SV.ChemPtrs^[AssocToxTyp(SV.NState)].AnimToxColl_To_Dbase(Program_Dir,'AnimToxForm.DB');
      SV.ChemPtrs^[AssocToxTyp(SV.NState)].PlantToxColl_To_Dbase(Program_Dir,'PlantToxForm.DB');
    End;

End;  {Copy_To_Temp}

{*********************************************************************}

Procedure TStateVarDialog.LoadingsFromTable(Table: TTable; Var LColl: TLoadings);
{Copies loadings data from the table to the Collection}
Var loop,recnum: Integer;
    NewLoad:     TLoad;
Begin
    If LColl<>nil then LColl.Destroy;
    With Table do begin
      First;
      RecNum:=RecordCount;
      Lcoll:= TLoadings.Init(2,1);
         For loop:=1 to RecNum do
              begin
                   NewLoad:= TLoad.Init(Fields[0].AsDateTime,Fields[1].AsFloat);
                   LColl.Insert(NewLoad);
                   Next;
              end; {for do}
    end; {with}

End; {LoadingsFromTable}
{----------------------------------------------------------}
Function TStateVarDialog.CType(Sender: TObject): ConvertType;
Begin
   If SV=nil then Begin
                    Result := CTPollutant;  {Susp&Diss Detr}
                    Exit;
                  End;
   Case SV.NState of
      Temperature:  Result := CtTemp;

      Volume:       If (Sender = ConvertButton) or
                       (Sender = ImportButt1)  then Result := CTVolume
               else If Sender = ConvertButton2 then Result := CTNone
               else                                 Result := CTFlow;

      Light:        Result := CTLight;
      WindLoading:  Result := CTWind;
      Else          Result := CTNone;
   End; {case}

  If SV.NState<>Volume then
    Begin
      If (Sender=PSConvertButt) then Result := CTPollutant;
      If (Sender=NPSConvertButt) then Result := CTPollutant;
      If ((Sender=ImportButt6) or (Sender = ImportButt4))
          and (SV.NState<>Volume) and (SV.NState<>CO2) then Result := CTPollutant;
    End;

  If (SV.NState <> Temperature) and ((Sender = TempConvert1) or (Sender = TempConvert2))
     then Result := CTNone;
End;

procedure TStateVarDialog.ConvertAlkClick(Sender: TObject);
begin
  Application.CreateForm(TConvertForm,ConvertForm);
  ConvertForm.ConvertNumber(GasPhaseEdit,CTAlkalinity);
  ConvertForm.Free;
end;

procedure TStateVarDialog.ConvertButtonClick(Sender: TObject);
Var TE: TEdit;
begin

  TE := LoadEdit; {convertbutton2}
  If Sender = ConvertButton then  TE := ICEdit;
  If Sender = PSConvertButt then  TE := PSLoadEdit;
  If Sender = DPConvertButt then  TE := DPLoadEdit;
  If Sender = TempConvert1  then  TE := TICEdit;
  If Sender = TempConvert2  then  TE := ATLoadEdit;

  Application.CreateForm(TConvertForm,ConvertForm);
  ConvertForm.ConvertNumber(TE,CType(Sender));
  ConvertForm.Free;
end;

Procedure TStateVarDialog.CopyFromTemp;
{This procedure copies data from tempSV back into the State Variable}
Var ToxLoop    : T_SVType;
    ToxInt     : Integer;
    InTox      : ^TLoadings;
    ATC, PTC   : TCollection;
    PBT        : TBuriedDetrTox1;
    ATC2, PTC2 : TCollection;
    ATR, ATR2  : TAnimalToxRecord;
    PTR, PTR2  : TPlantToxRecord;
    Loop, Loop2: Integer;
    PAnm, OtherSV : TAnimal;
    PPlt          : TPlant;
    NewLipidFrac  : Double;
    AssocToxRec   : String;
    SVLoop        : AllVariables;

Begin
  If ToxChanged then Changed := True;

  If SV.nstate in [sand..clay] then
    Begin
      If (TSandSiltClay(SV).FracInBed <> TempSV.FracInBed) then Changed:=True;
      TSandSiltClay(SV).FracInBed := TempSV.FracInBed;
    End;

  If SV.Nstate = WindLoading   then
    Begin
      If (TWindLoading(SV).MeanValue <> TempSV.WindMean) then Changed := True;
      TWindLoading(SV).MeanValue := TempSV.WindMean;
    End;

  If TempSV.SVType=SVAnimal     then Begin
                                       TAnimal(SV).PTrophInt^ := TempSV.TempTrophInt;
                                       TAnimal(SV).MigrInput := MigrForm.MigrTemp;
                                     End;

  If BuriedScreen then
    For ToxLoop := FirstToxTyp to LastToxTyp do
       begin
         PBT := SV.GetStatePointer(SV.nstate,ToxLoop,WaterCol);
         If (PBT <> nil) Then
           Begin
             If (PBT.InitialCond <> TempSV.BuriedTox[ToxLoop]) then Changed:=True;
             PBT.InitialCond := TempSV.BuriedTox[ToxLoop];
           End;
       end;

  If LightScreen then
    Begin
      If (TLight(SV).UserPhotoPeriod <> TempSV.Photoperiod) then Changed:=True;
      TLight(SV).UserPhotoPeriod := TempSV.Photoperiod;
    End;

  If SV.nstate=oxygen then with TempSV do            
    Begin
      If (TO2Obj(SV).CalcDuration <> O2CalcDuration) then Changed:=True;
      TO2Obj(SV).CalcDuration := O2CalcDuration;

      If (TO2Obj(SV).Threshhold <> O2Thresh) then Changed:=True;
      TO2Obj(SV).Threshhold := O2Thresh;

      If (TO2Obj(SV).NoLoadOrWash <> O2NoLoadOrWash) then Changed:=True;
      TO2Obj(SV).NoLoadOrWash := O2NoLoadOrWash;
    End;

  If SV.nstate=TSS then with TempSV do
    Begin
      If TSandSiltClay(SV).TSS_Solids <> TSSSolids then Changed := True;
      TSandSiltClay(SV).TSS_Solids := TSSSolids;
    End;

  If SV.nstate = CO2 then with TempSV do
    Begin
      If TCO2Obj(SV).ImportCo2Equil <> TempCO2Equil then Changed := True;
      TCO2Obj(SV).ImportCo2Equil := TempCO2Equil;
    End;


  If LightScreen then
    Begin
      If (TLight(SV).CalculatePhotoPeriod <> TempSV.CalcPhotoperiod) then Changed:=True;
      TLight(SV).CalculatePhotoPeriod := TempSV.CalcPhotoperiod ;
    End;

  {Return Underlying data records if relevant}
  With TempSV do begin
    Case SVType of
       SVAnimal: begin
                      TAnimal(SV).PAnimalData^:=AnimalRecord;
                      TAnimal(SV).ChangeData;
                 end;
       SVPlant:  begin
                      TPlant(SV).PAlgalRec^:=PlantRecord;
                      TPlant(SV).ChangeData;
                 end;
       SVChemical: begin
                      SV.ChemPtrs^[AssocToxTyp(SV.NState)].ChemRec:=ChemRecord;
                      SV.ChemPtrs^[AssocToxTyp(SV.NState)].ChangeData;
                   end;
       End; {Case}

    {Return Other Data from SV}
    If (SV.PName^<>SVName) then Changed := True;
    SV.PName^        := SVName;

    If (SV.InitialCond <> InitCond) then Changed := True;
    SV.InitialCond := InitCond;

    If (SV.LoadsRec.ConstLoad <> ConstLoad)   then Changed := True;
    If (SV.LoadsRec.MultLdg    <> MultLdg)    then Changed := True;
    If (SV.LoadsRec.UseConstant <> UseConst)  then Changed := True;
    If (SV.LoadsRec.NoUserLoad <> NoUserLoad) then Changed := True;

    SV.LoadsRec.ConstLoad   := ConstLoad;
    SV.LoadsRec.MultLdg     := MultLdg;
    SV.LoadsRec.UseConstant := UseConst;
    SV.LoadsRec.NoUserLoad  := NoUserLoad;

    SV.PHasData^            := HasData;

    If SV.NState=pH then
      Begin
        If (TpHObj(SV).Alkalinity <> Tox_Air_or_Alk) then Changed := True;
        TpHObj(SV).Alkalinity := Tox_Air_or_Alk;
      End;

    If SVType=SVChemical then
      Begin
        If (SV.ChemPtrs^[AssocToxTyp(SV.NState)].Tox_Air <> Tox_Air_or_Alk) then Changed := True;
        SV.ChemPtrs^[AssocToxTyp(SV.NState)].Tox_Air := Tox_Air_or_Alk;

        If SV.ChemPtrs^[AssocToxTyp(SV.NState)].Anim_Method <> AnimMeth then Changed := True;
        SV.ChemPtrs^[AssocToxTyp(SV.NState)].Anim_Method := AnimMeth;
        If SV.ChemPtrs^[AssocToxTyp(SV.NState)].Plant_Method <> PlantMeth then Changed := True;
        SV.ChemPtrs^[AssocToxTyp(SV.NState)].Plant_Method := PlantMeth;
      End;

    If SV.NState=pH then Tox_Air_or_Alk := TpHObj(SV).Alkalinity;

    If (SV.LoadNotes1 <> Notes1) then Changed := True;
    If (SV.LoadNotes2 <> Notes2) then Changed := True;
    SV.LoadNotes1 := Notes1;
    SV.LoadNotes2 := Notes2;

    If SV.Nstate in [Ammonia,Nitrate] then
      Begin
        TNO3 := SV.GetStatePointer(Nitrate,StV,WaterCol);

        If (TNO3.TN_IC <> TN_IC) then changed := True;
        If (TNO3.TN_Inflow <> TN_Inflow) then changed := True;
        If (TNO3.TN_PS <> TN_PS) then changed := True;
        If (TNO3.TN_NPS  <> TN_NPS) then changed := True;

        TNO3.TN_IC := TN_IC;
        TNO3.TN_Inflow := TN_Inflow;
        TNO3.TN_PS := TN_PS;
        TNO3.TN_NPS  := TN_NPS;
      End;

    If SV.NState=Phosphate then
      Begin
        PPhos := SV.GetStatePointer(Phosphate,StV,WaterCol);

        If (PPhos.TP_IC <> TN_IC) then changed := True;
        If (PPhos.TP_Inflow <> TN_Inflow) then changed := True;
        If (PPhos.TP_PS <> TN_PS) then changed := True;
        If (PPhos.TP_NPS  <> TN_NPS) then changed := True;

        PPhos.TP_IC := TN_IC;
        PPhos.TP_Inflow := TN_Inflow;
        PPhos.TP_PS := TN_PS;
        PPhos.TP_NPS  := TN_NPS;
      End;

    {Copy the species data}
    If SVType=SVAnimal then
      begin
        {If No Species is selected, but one was previously, the other compartment needs to
         be reset as well}
        If (TAnimal(SV).PSameSpecies^ <> SameSpec) then Changed:=True;
        If (SameSpec=NullStateVar) and (TAnimal(SV).PSameSpecies^<>NullStateVar) then
            TAnimal(SV.GetStatePointer(TAnimal(SV).PSameSpecies^,StV,WaterCol)).PSameSpecies^:=NullStateVar;

        {Set this compartment}
        TAnimal(SV).PSameSpecies^ := SameSpec;

        If SameSpec<>NullStateVar then
          Begin
            OtherSV:=SV.GetStatePointer(SameSpec,StV,WaterCol);
            {If the other SV is pointing to another species, reset that species}
            If (OtherSV.PSameSpecies^ <> NullStateVar) and
               (OtherSV.PSameSpecies^ <> SV.NState) then
               TAnimal(SV.GetStatePointer(OtherSV.PSameSpecies^,StV,WaterCol)).PSameSpecies^:=NullStateVar;

            {Set the other sv that is the same species to point to this sv}
            OtherSV.PSameSpecies^:=SV.NState;
          End;
      end;

    If SVType=SVPlant then
      Begin
        If (TPlant(SV).PSameSpecies^ <> SameSpec) then Changed:=True;
        TPlant(SV).PSameSpecies^ := NullStateVar;
        If TempSV.PlantRecord.PlantType='Periphyton' then TPlant(SV).PSameSpecies^ := SameSpec;
      End;

    If VolumeScreen then
      Begin
        If (TVolume(SV).Calc_Method <> Calc_M) then Changed:=True;
        TVolume(SV).Calc_Method := Calc_M;
      End;

    {Return data about the toxic records}
    If (CurrentTox <> nullstatevar)  and (not BuriedScreen) then
      For ToxInt := 0 to WorkingTCB.Items.Count-1 do
        Begin
           If (ToxPointer[SelTox[ToxInt]].LoadsRec.ConstLoad <> ToxConstLoad[SelTox[ToxInt]]) Then Changed:=True;
           ToxPointer[SelTox[ToxInt]].LoadsRec.ConstLoad   := ToxConstLoad[SelTox[ToxInt]];
           If ToxPointer[SelTox[ToxInt]].LoadsRec.ALT_ConstLoad[PointSource]    <> PSCL[SelTox[ToxInt]] Then Changed:=True;
           ToxPointer[SelTox[ToxInt]].LoadsRec.ALT_ConstLoad[PointSource]    := PSCL[SelTox[ToxInt]];
           If ToxPointer[SelTox[ToxInt]].LoadsRec.ALT_ConstLoad[NonPointSource] <> NPSCL[SelTox[ToxInt]] Then Changed:=True;
           ToxPointer[SelTox[ToxInt]].LoadsRec.ALT_ConstLoad[NonPointSource] := NPSCL[SelTox[ToxInt]];

           If ToxPointer[SelTox[ToxInt]].LoadsRec.MultLdg     <> ToxMultLdg[SelTox[ToxInt]]then Changed:=True;
           If ToxPointer[SelTox[ToxInt]].LoadsRec.ALT_MultLdg[PointSource]    <> PSML[SelTox[ToxInt]]then Changed:=True;
           If ToxPointer[SelTox[ToxInt]].LoadsRec.ALT_MultLdg[NonPointSource] <> NPSML[SelTox[ToxInt]]then Changed:=True;
           ToxPointer[SelTox[ToxInt]].LoadsRec.MultLdg     := ToxMultLdg[SelTox[ToxInt]];
           ToxPointer[SelTox[ToxInt]].LoadsRec.ALT_MultLdg[PointSource]    := PSML[SelTox[ToxInt]];
           ToxPointer[SelTox[ToxInt]].LoadsRec.ALT_MultLdg[NonPointSource] := NPSML[SelTox[ToxInt]];

           If ToxPointer[SelTox[ToxInt]].LoadsRec.UseConstant <> ToxUseConst[SelTox[ToxInt]]then Changed:=True;
           If ToxPointer[SelTox[ToxInt]].LoadsRec.ALT_UseConstant[PointSource]    <> PSUC [SelTox[ToxInt]]then Changed:=True;
           If ToxPointer[SelTox[ToxInt]].LoadsRec.ALT_UseConstant[NonPointSource] <> NPSUC[SelTox[ToxInt]]then Changed:=True;
           ToxPointer[SelTox[ToxInt]].LoadsRec.UseConstant := ToxUseConst[SelTox[ToxInt]];
           ToxPointer[SelTox[ToxInt]].LoadsRec.ALT_UseConstant[PointSource]    := PSUC [SelTox[ToxInt]];
           ToxPointer[SelTox[ToxInt]].LoadsRec.ALT_UseConstant[NonPointSource] := NPSUC[SelTox[ToxInt]];

           If ToxPointer[SelTox[ToxInt]].InitialCond          <> ToxInitCond[SelTox[ToxInt]] then Changed:=True;;
           ToxPointer[SelTox[ToxInt]].InitialCond          := ToxInitCond[SelTox[ToxInt]];

           InTox := @ToxPointer[SelTox[ToxInt]].LoadsRec.Loadings;  {pointer to current dynamic loadings}
           If (CurrentTox = SelTox[ToxInt])
              and ((not SedScreen) or (LoadType=0))
               then Begin          {Return data from table itself}
                     LoadingsFromTable(Table2,InTox^);
                     If ToxDynamLoad[CurrentTox] <> nil then ToxDynamLoad[SelTox[ToxInt]].Destroy;
                   End
               else If ToxDynamLoad[SelTox[ToxInt]] <> nil then {return data from tempsv}
                 Begin
                   If (InTox^ <> nil) then InTox^.Destroy;
                   InTox^ := ToxDynamLoad[SelTox[ToxInt]];
                 End;

           If SedScreen then
             Begin
               InTox := @ToxPointer[SelTox[ToxInt]].LoadsRec.Alt_Loadings[PointSource];  {pointer to current dynamic PS loadings}
               If (CurrentTox = SelTox[ToxInt]) and (LoadType=1)
                   then Begin          {Return data from table itself}
                         LoadingsFromTable(Table2,InTox^);
                         If PSTDL[CurrentTox] <> nil then PSTDL[SelTox[ToxInt]].Destroy;
                       End
                   else If PSTDL[SelTox[ToxInt]] <> nil then {return data from tempsv}
                     Begin
                       If (InTox^ <> nil) then InTox^.Destroy;
                       InTox^ := PSTDL[SelTox[ToxInt]];
                     End;

               InTox := @ToxPointer[SelTox[ToxInt]].LoadsRec.Alt_Loadings[NonPointSource];  {pointer to current dynamic NPS loadings}
               If (CurrentTox = SelTox[ToxInt]) and (LoadType=2)
                   then Begin          {Return data from table itself}
                         LoadingsFromTable(Table2,InTox^);
                         If NPSTDL[CurrentTox] <> nil then NPSTDL[SelTox[ToxInt]].Destroy;
                       End
                   else If NPSTDL[SelTox[ToxInt]] <> nil then {return data from temNPSv}
                     Begin
                       If (InTox^ <> nil) then InTox^.Destroy;
                       InTox^ := NPSTDL[SelTox[ToxInt]];
                     End;
             End; {SedScreen}

        End; {if currenttox <> nullstatevar}

    If (SV.NState = Co2) then
      Begin
        LoadingsFromTable(Table5,TCO2Obj(SV).CO2Equil);
      End;

    If TempScreen then
       begin
         If (SV.AllStates.HypoTempLoads.NoUserLoad  <> NoSysStrat) Then Changed:=True;
         If (SV.AllStates.HypoTempIC                <> TempInitCond) Then Changed:=True;
         If (SV.AllStates.HypoTempLoads.ConstLoad   <> TempConstLoad) Then Changed:=True;
         If (SV.AllStates.HypoTempLoads.UseConstant <> TempUseConst) Then Changed:=True;
         If (SV.AllStates.HypoTempLoads.MultLdg     <> TempMultLdg) Then Changed:=True;

         SV.AllStates.HypoTempLoads.NoUserLoad  := NoSysStrat;
         SV.AllStates.HypoTempIC                := TempInitCond;
         SV.AllStates.HypoTempLoads.ConstLoad   := TempConstLoad;
         SV.AllStates.HypoTempLoads.UseConstant := TempUseConst;
         SV.AllStates.HypoTempLoads.MultLdg     := TempMultLdg;
       end;

    {Copy the Database Data into the SV Files}
    LoadingsFromTable(Table1,SV.LoadsRec.Loadings);
    If SVtype=SVTemp then LoadingsFromTable(Table2,SV.AllStates.HypoTempLoads.Loadings);
    If SaltScreen then LoadingsFromTable(Table2,SV.LoadsRec.Alt_Loadings[PointSource]);
    If (SV.nstate in HOURLYLIST) then SV.LoadsRec.Loadings.Hourly := HourlyCB.Checked;

    If (SV.Nstate=Phosphate) then  {Copy data from fraction phosphate available form}
      Begin
        If (TPO4Obj(SV).FracAvail<>PhosAvailForm.FracAvail) Then Changed:=True;
        If (TPO4Obj(SV).Alt_FracAvail[PointSource]<>PhosAvailForm.Alt_FracAvail[PointSource]) Then Changed:=True;
        If (TPO4Obj(SV).Alt_FracAvail[NonPointSource]<>PhosAvailForm.Alt_FracAvail[NonPointSource]) Then Changed:=True;
        If (TPO4Obj(SV).Alt_FracAvail[DirectPrecip]<>PhosAvailForm.Alt_FracAvail[DirectPrecip]) Then Changed:=True;

        TPO4Obj(SV).FracAvail:=PhosAvailForm.FracAvail;
        TPO4Obj(SV).Alt_FracAvail[PointSource]:=PhosAvailForm.Alt_FracAvail[PointSource];
        TPO4Obj(SV).Alt_FracAvail[NonPointSource]:=PhosAvailForm.Alt_FracAvail[NonPointSource];
        TPO4Obj(SV).Alt_FracAvail[DirectPrecip]:=PhosAvailForm.Alt_FracAvail[DirectPrecip];
      End;


    {*** ALTERNATE LOADINGS DATA ***}
    If SaltScreen then
     With SV.LoadsRec do
      Begin
        If (Alt_ConstLoad[PointSource]     <> PS_ConstLoad) then Changed:=True;
        If (Alt_UseConstant[PointSource]   <> PS_UseConst) then Changed:=True;
        If (Alt_MultLdg[PointSource]       <> PS_MultLdg) then Changed:=True;

        Alt_ConstLoad[PointSource]     := PS_ConstLoad;
        Alt_UseConstant[PointSource]   := PS_UseConst;
        Alt_MultLdg[PointSource]       := PS_MultLdg;
      End;
    If Alternate_Loadings and not saltscreen then
      With SV.LoadsRec do
        Begin
          If (Alt_ConstLoad[PointSource]     <> PS_ConstLoad) then Changed:=True;
          If (Alt_ConstLoad[DirectPrecip]    <> DP_ConstLoad) then Changed:=True;
          If (Alt_ConstLoad[NonPointSource]  <> NPS_ConstLoad) then Changed:=True;
          If (Alt_UseConstant[PointSource]   <> PS_UseConst) then Changed:=True;
          If (Alt_UseConstant[DirectPrecip]  <> DP_UseConst) then Changed:=True;
          If (Alt_UseConstant[NonPointSource]<> NPS_UseConst) then Changed:=True;
          If (Alt_MultLdg[PointSource]       <> PS_MultLdg) then Changed:=True;
          If (Alt_MultLdg[DirectPrecip]      <> DP_MultLdg) then Changed:=True;
          If (Alt_MultLdg[NonPointSource]    <> NPS_MultLdg) then Changed:=True;

          Alt_ConstLoad[PointSource]     := PS_ConstLoad;
          Alt_ConstLoad[DirectPrecip]    := DP_ConstLoad;
          Alt_ConstLoad[NonPointSource]  := NPS_ConstLoad;
          Alt_UseConstant[PointSource]   := PS_UseConst;
          Alt_UseConstant[DirectPrecip]  := DP_UseConst;
          Alt_UseConstant[NonPointSource]:= NPS_UseConst;
          Alt_MultLdg[PointSource]       := PS_MultLdg;
          Alt_MultLdg[DirectPrecip]      := DP_MultLdg;
          Alt_MultLdg[NonPointSource]    := NPS_MultLdg;

          LoadingsFromTable(Table3,SV.LoadsRec.Alt_Loadings[PointSource]);
          LoadingsFromTable(Table4,SV.LoadsRec.Alt_Loadings[DirectPrecip]);
          LoadingsFromTable(Table5,SV.LoadsRec.Alt_Loadings[NonPointSource]);

        End;
  End; {With}


  If TempSV.SVType=SVChemical then
    Begin
      {Return Toxicity Record}
      SV.ChemPtrs^[AssocToxTyp(SV.NState)].Dbase_To_AnimToxColl(Program_Dir,'AnimToxForm.DB');
      SV.ChemPtrs^[AssocToxTyp(SV.NState)].Dbase_To_PlantToxColl(Program_Dir,'PlantToxForm.DB');

      If LipidModified then
        If MessageDlg('Because Lipid Fraction data may have been changed in the Toxicity Screen, '+
                      'each Lipid Fraction from this chemical''s toxicity record will be copied over to the '+
                      'other toxicants in this study.  Lipid Frac will change in each relevant (linked) organism''s underlying data.',
                       mtConfirmation, [mbok,mbcancel], 0) = mrok then
          Begin
            ATC := SV.ChemPtrs^[AssocToxTyp(SV.NState)].Anim_Tox;
            {For Each Animal Lipid Fraction in this chemical}
            For Loop := 0 to ATC.Count - 1 do
              Begin
                ATR := ATC.At(Loop);
                NewLipidFrac := ATR.Lipid_Frac;
                AssocToxRec  := ATR.Animal_Name;

                {Copy to each animal with the same toxicity record}
                For SVLoop := FirstAnimal to LastAnimal do
                  Begin
                    PAnm := SV.GetStatePointer(SVLoop,StV,WaterCol);
                    If PAnm<> nil then
                      If PAnm.PAnimalData^.ToxicityRecord = AssocToxRec
                        then PAnm.PAnimalData^.FishFracLipid := NewLipidFrac;
                  End;

                {And copy to each chemical toxicity record with the same name}
                For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
                  If SV.ChemPtrs^[ToxLoop]<>nil then
                    Begin
                      ATC2 := SV.ChemPtrs^[ToxLoop].Anim_Tox;
                      For Loop2 := 0 to ATC2.Count-1 do
                        Begin
                          ATR2 := ATC2.At(Loop2);
                          If AssocToxRec = ATR2.Animal_Name then
                            ATR2.Lipid_Frac := NewLipidFrac;
                        End;
                    End;
              End; {Animal Loop}


            PTC := SV.ChemPtrs^[AssocToxTyp(SV.NState)].Plant_Tox;
            {For Each Plant Lipid Fraction in this chemical}
            For Loop := 0 to PTC.Count - 1 do
              Begin
                PTR := PTC.At(Loop);
                NewLipidFrac := PTR.Lipid_Frac;
                AssocToxRec  := PTR.Plant_Name;

                {Copy to each plant with the same toxicity record}
                For SVLoop := FirstPlant to LastPlant do
                  Begin
                    PPlt := SV.GetStatePointer(SVLoop,StV,WaterCol);
                    If PPlt<> nil then
                      If PPlt.PAlgalRec^.ToxicityRecord = AssocToxRec
                        then PPlt.PAlgalRec^.PlantFracLipid := NewLipidFrac;
                  End;


                {Copy to each chemical toxicity record with the same name}
                For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
                  If SV.ChemPtrs^[ToxLoop]<>nil then
                    Begin
                      PTC2 := SV.ChemPtrs^[ToxLoop].Plant_Tox;
                      For Loop2 := 0 to PTC2.Count-1 do
                        Begin
                          PTR2 := PTC2.At(Loop2);
                          If AssocToxRec = PTR2.Plant_Name then
                            PTR2.Lipid_Frac := NewLipidFrac;
                        End;
                    End;
              End; {Plant Loop}
          End;  {Copy Lipid Frac Data}
    End;  {SVType is Chemical}
End;  {Copy_From_Temp}

{*************************************************************************}

Procedure TStateVarDialog.UpdateScreen;
Var ShortSVName : ShortString;
    TempEnable  : Boolean;

             procedure PlantUnits;
             {Display Correct Units for plants}
             begin
                If (TempSV.PlantRecord.PlantType='Phytoplankton')
                   then begin IC_Unit.Caption  := 'mg/L dry';
                              CL_Unit.Caption  := 'mg/L dry';
                              CL_Unit2.Caption := 'mg/L dry';
                        end
                   else begin IC_Unit.Caption  := 'g/m2 dry';
                              CL_Unit.Caption  := 'g/m2 dry';
                              CL_Unit2.Caption := 'g/m2 dry';
                        end;
             end; {Sub-Procedure PlantUnits}

             procedure AnimalUnits;
             {Display Correct Units for Inverts}
             begin
                If (SV.nstate in [FirstAnimal..LastAnimal]) then
                  If (TempSV.AnimalRecord.Animal_Type='Benthic Invert.') or
                     (TempSV.AnimalRecord.Animal_Type='Benthic Insect')  or
                     (TempSV.AnimalRecord.Animal_Type='Fish')
                     then begin IC_Unit.Caption :='g/m2 dry';
                                CL_Unit.Caption :='g/m2 dry';
                                CL_Unit2.Caption:='g/m2 dry';
                          end
                     else begin IC_Unit.Caption :='mg/L dry';
                                CL_Unit.Caption :='mg/L dry';
                                CL_Unit2.Caption:='mg/L dry';
                                WindMeanPanel.Visible:=False;

                          end;
             end; {Sub-Procedure AnimalUnits}


Begin    {updatescreen}
   If (SV.Nstate=Phosphate) then FracAvail.Caption := 'Fraction Available'
     else If (TempSV.SVType=SVAnimal) then FracAvail.Caption := 'Trophic Matrix'
                                      else FracAvail.Caption := 'Biotransformation';

   If (SV.IsFish) and (TempSV.SameSpec <> nullstatevar) then Anadromous.Visible := True;

   MigrationButton.Visible := (TempSV.SVType=SVAnimal) and SV.AllStates.LinkedMode;

   InitCondLabel.Caption:='Initial Condition:';

   PhotoperiodPanel.Visible := LightScreen;
   If LightScreen then
     Begin
       CalcPhotoRadioButton.Checked := TempSV.CalcPhotoPeriod;
       ZPhotoperiodEdit.Text :=  FloatToStrF(TempSV.PhotoPeriod,fffixed,4,1);
     End;

   If SV.nstate=Oxygen then
     Begin
       O2DurationCB.Checked := TempSV.O2CalcDuration;
       XO2ThreshEdit.Text :=  FloatToStrF(TempSV.O2Thresh,fffixed,4,1);
       NoO2LoadCB.Checked := TempSV.O2NoLoadOrWash;
     End;

   If SV.nstate=TSS then SolidsButton.Checked := TempSV.TSSSolids;
   If SV.nstate=TSS then SedimentButton.Checked := not TempSV.TSSSolids;

   LinkInflowWarning.Visible  := False;
   LinkOutflowWarning.Visible := False;

   LoadingBox2.Visible := SedScreen;
   DPPanel.Visible := Not SedScreen;

   CO2EquilButton.Visible := SV.NState = CO2;
//   If SV.NState=CO2 and 

   EstSaltButton.Visible := (SV.Location.SiteType=Estuary) and
                            (SV.NState in [Oxygen,Ammonia,Nitrate,Phosphate,CO2]);
   If (SV.Location.SiteType=Estuary) and (SV.NState=Ammonia)
     then NitrateLabel.Top := 515;
   If (SV.Location.SiteType=Estuary) and (SV.NState=Oxygen)
     then Begin EstSaltButton.Top := 549; EstSaltButton.Height := 19; End;


   If SaltScreen then ToxicPanel.BringToFront;
   ICEdit.Visible := Not SaltScreen;
   IC_Unit.Visible := Not SaltScreen;
   InitCondLabel.Visible := Not SaltScreen;
   DPConstRadio.Caption    := 'Use Const. Loading of';
   DPDynRadio.Caption      := 'Use Dynamic Loadings';

   ConvertButton.Visible := CType(ConvertButton) <> CTNone;
   ConvertButton2.Visible := CType(ConvertButton2) <> CTNone;
   PSConvertButt.Visible := CType(PSConvertButt) <> CTNone;
   DPConvertButt.Visible := CType(DPConvertButt) <> CTNone;
   TempConvert1.Visible := CType(TempConvert1) <> CTNone;
   TempConvert2.Visible := CType(TempConvert2) <> CTNone;

   If SV.NState in [FirstFish..LastFish] then             //10/15/2010
       begin
         PointLabel.Caption:='Fish Stocking in grams per day';
         DPLabel.Caption:='Fish Stocking in grams per sq.m';
         VolumeButt.Visible:=False;
         VolButton2.Visible  := False;
         VolumePanel.Visible:=False;
         DirectUnitLabel.Caption  := 'g/m2 - d';
         DirectUnitLabel2.Caption := 'g/m2 - d';
         PointUnitLabel.Caption   := 'g / d';
         PointUnitLabel2.Caption  := 'g / d';
       end
   Else If EstuaryVol then
       Begin
         NPSLabel.Caption := 'NPS Load (to freshwater layer):';
         NPSUnit.Caption := 'cu.m / d';
         NPSUnit2.Caption := 'cu.m / d';

         VolumeButt.Visible  :=True;
         VolButton2.Visible  := False;
  {      VolumePanel.Visible :=True; }
         PointLabel.Caption:='Point Sources of water (to freshwater)';
         DPLabel.Caption:='Direct Precipitation of water';
         WindMeanPanel.Visible := False;
         DirectUnitLabel.Caption := 'cu.m / d';
         DirectUnitLabel2.Caption:= 'cu.m / d';
         PointUnitLabel.Caption  := 'cu.m/d';
         PointUnitLabel2.Caption := 'cu.m / d';
       End
   Else If VolumeScreen then
       Begin
         EvapButton.Visible := True;
         WindMeanPanel.Visible := False;
         VolumeButt.Visible  :=True;
         VolButton2.Visible  := Not LinkedM and (SV.Location.SiteType in [Reservr1D,Pond,Lake]);
         VolumePanel.Visible :=True;
         PointLabel.Caption      := 'Inflow of Water';
         DPLabel.Caption         := 'Discharge of Water';
         DPConstRadio.Caption    := 'Use Const. Discharge of';
         DPDynRadio.Caption      := 'Use a Time-Series';

         If SV.AllStates.LinkedMode
           then Begin
                  LinkInflowWarning.Visible  := True;
                  LinkOutflowWarning.Visible := True;
                End;

         DirectUnitLabel.Caption := 'cu.m / d';
         DirectUnitLabel2.Caption:= 'cu.m / d';
         PointUnitLabel.Caption  := 'cu.m/d';
         PointUnitLabel2.Caption := 'cu.m / d';

         ManningButt.Enabled:=(SV.AllStates.Location.SiteType=Stream) { and (Not SV.AllStates.LinkedMode) };
       {  ConstButt.Enabled:= (Not SV.AllStates.LinkedMode); }
         KnownValButt.Enabled := True;

         With TempSV do
           If (Calc_M=Manning) and (not ManningButt.Enabled)
             Then Calc_M:=Dynam;

         With TempSV do
           If (Calc_M=KeepConst) and (not ConstButt.Enabled)
             Then Calc_M:=Dynam;

         With TempSV do
           If (Calc_M=KnownVal) and (not KnownValButt.Enabled)
             Then Calc_M:=Dynam;

         MultEdit.Enabled := False;
         MultLoadLabel.Enabled := False;


    (*     If SV.AllStates.LinkedMode
           then
             begin
               Case TempSV.Calc_M of
                  Dynam:   begin
                             DynamicButt.Checked:=True;
                             DbGrid1.Enabled:=False;
                             DBGrid1.Color:=ClGray;
                             DbNavigator1.Enabled := False;
                           end;
                  KnownVal:begin
                             KnownValButt.Checked:=True;
                             DBGrid1.Enabled:=True;
                             DBGrid1.Color:=EditColor;
                             DbNavigator1.Enabled := True;
                           end;
                 End; {Case}
               DbNavigator4.Enabled := True;
               PSPanel.Enabled:=True;
               PSGrid.Color:=EditColor;
               PSPanel.Color:=clBtnFace;
               DPPanel.Enabled:=True;
               DPGrid.Color:=EditColor;
               DPPanel.Color:=clBtnFace;
             end
           else                    *)
             Case TempSV.Calc_M of
                Manning: begin
                           ManningButt.Checked:=True;
                           PSPanel.Enabled:=False;
                           PSGrid.Color:=ClGray;
                           PSPanel.Color:=ClGray;
                           DPPanel.Enabled:=True;
                           DPGrid.Color:=EditColor;
                           DPPanel.Color:=clBtnFace;
                           DbGrid1.Enabled:=False;
                           DBGrid1.Color:=ClGray;
                           DbNavigator4.Enabled := True;
                           DbNavigator1.Enabled := False;


                         end;
                KeepConst:begin
                           ConstButt.Checked:=True;
                           PSPanel.Enabled:=True;
                           PSGrid.Color:=EditColor;
                           If PSConstRadio.Checked then
                              begin
                                PSGrid.Color:=ClGray;
                                DbNavigator3.Enabled:=False;
                              end;
                           PSPanel.Color:=clBtnFace;
                           DPPanel.Enabled:=False;
                           DPGrid.Color:=ClGray;
                           DPPanel.Color:=ClGray;
                           DbGrid1.Enabled:=False;
                           DBGrid1.Color:=ClGray;
                           DbNavigator4.Enabled := False;
                           DbNavigator1.Enabled := False;
                         end;
                Dynam:   begin
                           DynamicButt.Checked:=True;
                           PSPanel.Enabled:=True;
                           PSGrid.Color:=EditColor;
                           DbNavigator4.Enabled := True;
                           PSPanel.Color:=clBtnFace;
                           If PSConstRadio.Checked then
                              begin
                                PSGrid.Color:=ClGray;
                                DbNavigator3.Enabled:=False;
                              end;
                           DPPanel.Enabled:=True;
                           DPGrid.Color:=EditColor;
                           If DPConstRadio.Checked then
                              begin
                                DPGrid.Color:=ClGray;
                                DBNavigator4.Enabled:=False;
                              end;
                           DPPanel.Color:=clBtnFace;
                           DbGrid1.Enabled:=False;
                           DBGrid1.Color:=ClGray;
                           DbNavigator1.Enabled := False;
                         end;
                KnownVal:begin
                           MultEdit.Enabled := True;
                           MultLoadLabel.Enabled := True;
                           KnownValButt.Checked:=True;
                           PSPanel.Enabled:=True;
                           PSGrid.Color:=EditColor;
                           PSPanel.Color:=clBtnFace;
                           If PSConstRadio.Checked then
                              begin
                                PSGrid.Color:=ClGray;
                                DbNavigator3.Enabled:=False;
                              end;
                           DPPanel.Enabled:=False;
                           DPGrid.Color:=ClGray;
                           DPPanel.Color:=ClGray;
                           DbGrid1.Enabled:=True;
                           DbNavigator4.Enabled := False;
                           If DPConstRadio.Checked then
                              begin
                                DPGrid.Color:=ClGray;
                                DBNavigator4.Enabled:=False;
                              end;
                           DBGrid1.Color:=EditColor;
                           DbNavigator1.Enabled := True;
                         end;
             end; {Case}
       end {if VolumeScreen}
     else
       begin
         VolumeButt.Visible:=False;
         VolButton2.Visible  := False;
         VolumePanel.Visible:=False;
         PointLabel.Caption:='Loadings from Point Sources';
         DPLabel.Caption:='Loadings from Direct Precipitation';
         DirectUnitLabel.Caption  := 'g/m2 - d';
         DirectUnitLabel2.Caption := 'g/m2 - d';
         PointUnitLabel.Caption   := 'g / d';
         PointUnitLabel2.Caption  := 'g / d';

         If MeanRangeButt.Checked and (SV.NState<>CO2)
           then
             Begin
               NPSPanel.Enabled := False;
               NPSPanel.Color   := ClGray;
               PSPanel.Enabled := False;
               PSPanel.Color   := ClGray;
               DPPanel.Enabled := False;
               DPPanel.Color   := ClGray;
             End
           else
             Begin
               NPSPanel.Enabled := True;
               NPSPanel.Color   := clBtnFace;
               PSPanel.Enabled := True;
               PSPanel.Color   := clBtnFace;
               DPPanel.Enabled := True;
               DPPanel.Color   := clBtnFace;
             End;
       end;

         NitrateLabel.Visible := False;
         If SV.NState=Ammonia then
           Begin
             NitrateLabel.Visible := True;
             If TempSV.TN_PS then
               Begin
                 PSPanel.Enabled := False;
                 PSPanel.Color   := ClGray;
               End;
             If TempSV.TN_NPS then
               Begin
                 NPSPanel.Enabled := False;
                 NPSPanel.Color   := ClGray;
               End;
             If TempSV.TN_Inflow then
               Begin
                 DbGrid1.Enabled:=False;
                 DbGrid1.Color:=clGray;
                 DbNavigator1.Enabled:=False;
                 LoadEdit.Enabled:=False;
               End else
               Begin
                 DbGrid1.Enabled:=True;
                 DbGrid1.Color:=EditColor;
                 DbNavigator1.Enabled:=True;
                 LoadEdit.Enabled:=True;
               End;

             If TempSV.TN_IC then ICEdit.Enabled := False
                             else ICEdit.Enabled := True;

           End;

   HourlyCB.Visible := SV.Nstate in HOURLYLIST;
   O2DurationPanel.Visible := (SV.Nstate = Oxygen);
   O2LoadPanel.Visible  := (SV.Nstate = Oxygen);
   TSSPanel.Visible     := (SV.NState = TSS);

   {Put up appropriate data for sand..clay}
   If SV.Nstate in [Sand..Clay]
     then
        begin
           InitCondLabel.Caption:='Initial Susp. Sed.';
           WindMeanPanel.Visible:=True;
           WindMeanLabel.Caption := 'Frac in Bed Seds:';
           WindMeanEdit.Text:=FloatToStrF(TempSV.FracInBed,ffgeneral,9,4);
           DPLabel.Caption:='Loadings from Direct Precipitation';
           DirectUnitLabel.Caption:='Kg / d';
           DirectUnitLabel2.Caption:='Kg / d';
        end
     else if (not VolumeScreen) and not (sv.nstate in [firstfish..lastfish]) then
          begin
            WindMeanPanel.Visible:=False;
            DPLabel.Caption:='Loadings from Direct Precipitation';
            DirectUnitLabel.Caption  := 'g/m2 - d';
            DirectUnitLabel2.Caption := 'g/m2 - d';
          end;

   If EstuaryVol then InitCondLabel.Caption := 'Estuary Volume';

   If BuriedScreen then
       begin
          BuriedToxPanel.Visible:=True;
          panel7.visible:=True;
          If CurrentTox<>NullStateVar then
            Begin
              OrgToxEdit.Text:=FloatToStrF(TempSV.BuriedTox[AssocToxTyp(CurrentTox)],ffgeneral,9,4);
              Panel7.Visible:=False;
            End;

          Panel6.Visible:=True;
       end
    else BuriedToxPanel.Visible:=False;


   {Put up Appropriate caption}
   If TempSV.SVType=SVChemical then Begin
                                      Caption:='AQUATOX- Edit Chemical Data';
                                      GasPhasePanel.Visible:=True;
                                    End
                               else Begin
                                      Caption:='AQUATOX- Edit State Variable Data';
                                      GasPhasePanel.Visible:=False;
                                    End;

   {Put up Mean Range Button if Appropriate}
   If TempSV.SVType=SVTemp then
                         begin
                           If LinkedM then MeanRangeButt.Caption:='Use Annual Mean'
                                      else MeanRangeButt.Caption:='Use Ann Means for Both Strata';
                           MeanRangeButt.Visible:=True;
                         end
   else If (TempSV.SVType=SVWindLight) then
                         begin
                           MeanRangeButt.Caption:='Use Annual Mean and Range Loadings';
                           MeanRangeButt.Visible:=True;
                         end
   else If (SV.NState=pH) then
                         begin
                           MeanRangeButt.Caption:='Calculate using Alkalinity';
                           MeanRangeButt.Visible:=True;
                         end
   else if (SV.Nstate in [Phosphate,Ammonia,Nitrate,CO2,Oxygen])  then
                         begin
                           MeanRangeButt.Caption:='Ignore All Loadings';
                           MeanRangeButt.Visible:=True;
                         end
   else MeanRangeButt.Visible:=False;

   If SV.NState in [pH, TSS, Temperature, Salinity, COD]
     Then
       Begin
         LoadingsLabel.Caption := 'State Variable Valuation:';
         ConstRadButt.Caption  := 'Use Constant Value of';
         DynRadButt.Caption    := 'Use Dynamic Valuation ';
       End
     Else
       Begin
         LoadingsLabel.Caption := 'Loadings from Inflow:';
         ConstRadButt.Caption  := 'Use Constant Loading of';
         DynRadButt.Caption    := 'Use Dynamic Loadings ';
       End;

   If SV.NState in [Salinity, Temperature]
     Then
       Begin
         TConstRadButt.Caption  := 'Use Constant Value of';
         TDynRadButt.Caption    := 'Use Dynamic Valuation ';
       End
     Else
       Begin
         TConstRadButt.Caption  := 'Use Constant Loading of';
         TDynRadButt.Caption    := 'Use Dynamic Loadings ';
       End;

   If EstuaryVol then ConstRadButt.Caption := 'Upstream Inflow of water';

   If SV.NState=WindLoading then begin
                                    MeanRangeButt.Caption:='Use Default Time Series';
                                    If TempSV.NoUserLoad then WindMeanPanel.Visible:=True;
                                    WindMeanLabel.Caption := 'Mean Value (m/s)';
                                    WindMeanEdit.Text:=FloatToStrF(TempSV.WindMean,ffgeneral,9,4);
                                  end;
   If SV.NState=pH          then begin
                                    MeanRangeButt.Caption:='Compute From Tot. Alkalinity';
                                    MeanRangeButt.Enabled:=True;
                                  End;

    TotN_IC.Visible := False;
    TotN_Inflow.Visible := False;
    TotN_PS.Visible := False;
    TotN_NPS.Visible := False;

    If SV.Nstate in [Ammonia,Nitrate,Phosphate] then
      Begin
        TotN_IC.Visible := True;
        TotN_Inflow.Visible := True;
        TotN_PS.Visible := True;
        TotN_NPS.Visible := True;
        If SV.NState = Ammonia then TotN_PS.Enabled := False;
        If SV.NState = Ammonia then TotN_NPS.Enabled := False;

        If SV.NState=Phosphate
          then
            Begin
              TotN_IC.Caption := 'Value is Total P';
              TotN_Inflow.Caption := 'Inflows are TP';
              TotN_PS.Caption := 'PS Loads are TP';
              TotN_NPS.Caption := 'NPS loads are TP';
            End;

        TotN_IC.Checked :=TempSV.TN_IC;
        TotN_Inflow.Checked := TempSV.TN_Inflow;
        ShowWarnings := False;
        TotN_PS.Checked := TempSV.TN_PS;
        TotN_NPS.Checked := TempSV.TN_NPS;
        ShowWarnings := True;

      End;

   {Reset Default Screen Position}
   If (BuriedScreen) or
      (((CurrentTox = NullStateVar) and Not (TempSV.Alternate_Loadings)
                                   and Not (TempScreen and Not LinkedM)))
                                   and (Not SaltScreen) then
                                     begin
                                       StatePanel.Left :=MiddlePosition;
                                       HelpButton.Left  := 287+MiddlePosition;
                                       LoadingsPanel.Visible:=False;
                                       NPSPanel.Visible:=False;
                                     end;

   If ((TempSV.Alternate_Loadings) and not (SV.NState in [Volume, FirstFish..LastFish,Salinity]))
      or EstuaryVol
                   then begin
                          PSNPSButt.Visible:=True;
{                          If TempSV.SVType=SVChemical
                             then PSNPSButt.Left:=11
                             else PSNPSButt.Left:=468; }
                        end
                   else PSNPSButt.Visible:=False;

   If (SV.NState=CO2) then
     Begin
       UpdatingScr := True;
       NPSDLRadio.Checked := TempSV.TempCo2Equil;
       UpdatingScr := False;

       NPSCLRadio.Caption := 'Have AQUATOX Calculate CO2 Equil.';
       NPSConvertButt.Visible := False;
       NPSLabel.Caption := 'Equilibrium CO2 Import';
       NPSDLRadio.Caption := 'Import CO2 Equil from CO2SYS or other';
       NPSUnit2.Caption := 'mg/L';
       NPSConstLoad.Visible := False;
       Label34.Visible := False;
       NPSMultEdit.Visible := False;
       NPSUnit.Visible := False;
       If TempSV.TempCo2Equil then
         Begin
           NPSPanel.Visible := True;
           StatePanel.Left:=11;
           HelpButton.Left := 311;
         End
        else
         Begin
           NPSPanel.Visible := False;
           StatePanel.Left :=MiddlePosition;
           HelpButton.Left  := 287+MiddlePosition;
         End;
     End;

   If (BuriedScreen or ((CurrentTox=NullStateVar) and Not ((TempSV.SVType=SVTemp) or SaltScreen))) then ToxicPanel.Visible:=False;

   If TempSV.ShowingNPS then PSNPSButt.Caption:='P.S. / D.P.'
                        else PSNPSButt.Caption:='N.P.S.';

   If SV.Nstate in [Sand..Clay] then PSNPSButt.Visible:=True;

   If SV.Nstate in [Cohesives..NonCohesives2] then
       With TempSV do
         begin
           ToggleButton.Visible:= True;
           If ShowingPSLoad then ToggleButton.Caption:='&View Tox. Loadings'
                            else ToggleButton.Caption:='&View Other Loadings';
           If not ShowingPSLoad then ToxicPanel.BringToFront
                                else ToxicPanel.SendToBack;
           PSNPSButt.Visible:=ShowingPSLoad;
         end
      else ToggleButton.Visible:=False;

   {Write in Names}
   ShortSVName:=AbbrString(TempSV.SVName,':');
   Label5.Caption:=TempSV.SVName;
   If TempSV.SVType=SVTemp then
                         begin
                           If LinkedM
                             then Label5.Caption := 'Segment Temperature'
                             else Label5.Caption := 'Epilimnion Temperature:';
                           If LinkedM then ToxicPanel.Visible := False;
                           Label10.Caption:='Hypolimnion Temperature:';
                           WorkingTCB.Visible := False;
                           Label11.Caption:='';
                         end
                    else begin
                           Label10.Caption:='Exposure to:';
                           WorkingTCB.Visible := True;
                           Label11.Caption:='(of '+ShortSVName+')';
                         end;
   If SaltScreen then begin
                         Label5.Caption :='Upper Layer Salinity:';
                         Label10.Caption:='Lower Layer Salinity:';
                         WorkingTCB.Visible := False;
                         Label11.Caption:='';
                      end;

                      

   {If there are Toxic Data to Display, then display them}
   If (((CurrentTox<>NullStateVar) or (TempScreen and not LinkedM)) or SaltScreen) and
      not BuriedScreen then
      Begin
         StatePanel.Left:=11;
         HelpButton.Left := 311;
         ToxicPanel.Visible:=True;
         LoadingsPanel.Visible:=False;
         NPSPanel.Visible:=False;

         HypTempPanel.Visible := TempScreen;
         If TempScreen then VolButton2.Visible := True;

         SaltPanel.Visible := False;
         If TempScreen
          then Begin
                 YesButt.Checked := Not TempSV.NoSysStrat;  NoButt.Checked := TempSV.NoSysStrat;
                 If NoButt.Checked then TempSV.TempUseConst := True;
                 TempEnable := YesButt.Checked;
                 TConstRadButt.Enabled := TempEnable;
                 TDynRadButt.Enabled := TempEnable;
                 ATLoadEdit.Enabled := TempEnable;
                 TICEdit.Enabled := TempEnable;
                 TIC_Unit.Enabled := TempEnable;
                 Label8.Enabled := TempEnable;
                 TICEDIT.Text:=FloatToStrF(TempSV.TempInitCond,ffGeneral,9,4);
                 ATLoadEdit.Text:=FloatToStrF(TempSV.TempConstLoad,ffGeneral,9,4);
               End
          else Begin
                 TConstRadButt.Enabled := True;
                 TDynRadButt.Enabled := True;
                 ATLoadEdit.Enabled := True;
                 TICEdit.Enabled := True;
                 TIC_Unit.Enabled := True;
                 Label8.Enabled := True;

                 If SaltScreen
                   then
                     Begin
                       SaltPanel.Visible := True;
                       ATLoadEdit.Text:=FloatToStrF(TempSV.PS_ConstLoad,ffgeneral,9,4);
                     End
                   else
                     Begin
                       TICEDIT.Text:=FloatToStrF(TempSV.ToxInitCond[CurrentTox],ffGeneral,9,4);
                       Case LoadType of
                         0: ATLoadEdit.Text:=FloatToStrF(TempSV.ToxConstLoad[CurrentTox],ffGeneral,9,4);
                         1: ATLoadEdit.Text:=FloatToStrF(TempSV.PSCL[CurrentTox],ffGeneral,9,4);
                         2: ATLoadEdit.Text:=FloatToStrF(TempSV.NPSCL[CurrentTox],ffGeneral,9,4);
                       End; {case}
                     End;
               End;

         {Display Proper Units}
         If SaltScreen then
           Begin
              TIC_Unit.Caption :='ppt';
              TCL_Unit.Caption :='ppt';
              TCL_Unit2.Caption :='ppt';
           end
         Else If TempScreen
          then
            begin
              TIC_Unit.Caption :='deg. C';
              TCL_Unit.Caption :='deg. C';
              TCL_Unit2.Caption :='deg. C';
            end
          else
           Begin
             TIC_Unit.Caption :=TempSV.ToxPointer[CurrentTox].StateUnit;
             TCL_Unit.Caption :=TempSV.ToxPointer[CurrentTox].LoadingUnit;
             TCL_Unit2.Caption :=TempSV.ToxPointer[CurrentTox].LoadingUnit;
           End;
      End;

    { IF Multiple Loadings Data Exist then Display them }
    If TempSV.Alternate_Loadings  and (not SaltScreen) then
      Begin
        StatePanel.Left:=11;
        HelpButton.Left := 311;

        If TempSV.ShowingPSLoad then
           Begin
             LoadingsPanel.Visible:= not TempSV.ShowingNPS;
             NPSPanel.Visible := TempSV.ShowingNPS;
           End;

        If TempSV.NoUserLoad then LoadingsPanel.Color:=ClGray
                             else LoadingsPanel.Color:=clBtnFace;

        If  (TempSV.PS_ConstLoad>9.9e4) or VolumeScreen
           then PSLoadEdit.Text:=FloatToStrF(TempSV.PS_ConstLoad,ffexponent,5,5)
           else PSLoadEdit.Text:=FloatToStrF(TempSV.PS_ConstLoad,ffgeneral,9,4);
        PSConstRadio.Checked:=TempSV.PS_UseConst;
        PSDynRadio.Checked:=Not(TempSV.PS_UseConst);

        If VolumeScreen then DPLoadEdit.Text:=FloatToStrF(TempSV.DP_ConstLoad,ffexponent,5,5)
                        else DPLoadEdit.Text:=FloatToStrF(TempSV.DP_ConstLoad,ffgeneral,9,4);
        DPConstRadio.Checked:=TempSV.DP_UseConst;
        DPDynRadio.Checked:=Not(TempSV.DP_UseConst);

        NPSConstLoad.Text:=FloatToStrF(TempSV.NPS_ConstLoad,ffgeneral,9,4);
        NPSCLRadio.Checked:=TempSV.NPS_UseConst;
        NPSDLRadio.Checked:=Not(TempSV.NPS_UseConst);
      End;

   {Display Proper Units}
   IC_Unit.Caption := SV.StateUnit   ;
   CL_Unit.Caption := SV.LoadingUnit ;
   CL_Unit2.Caption := SV.LoadingUnit ;

   If EstuaryVol then
     Begin
       CL_Unit.Caption  := 'cu.m / d';
       CL_Unit2.Caption := 'cu.m / d';
     End;

   If TempSV.SVType=SVPlant then PlantUnits;
   If TempSV.SVType=SVAnimal then AnimalUnits;

   {If there is underlying data, display buttons to edit it}
   SaveButton.Visible:=SV.PRequiresData^;
   LoadButton.Visible:=SV.PRequiresData^;
   EditButton.Visible:=SV.PRequiresData^;

   {Show Frac Avail Button if phosphate}
   FracAvail.Visible := (SV.nstate=Phosphate) or (TempSV.SVType in [SVChemical,SVAnimal]);
   ToxicityDataButton.Visible := (TempSV.SVType = SVChemical); 

   {Display Notes}
   NotesEdit.Text := TempSV.Notes1;
   NotesEdit2.Text := TempSV.Notes2;

   {Display MultLdgs Data}
   MultEdit.Text  :=FloatToStrF(TempSV.MultLdg,ffGeneral,9,4);
   DPMultEdit.Text:=FloatToStrF(TempSV.DP_MultLdg,ffGeneral,9,4);
   PSMultEdit.Text:=FloatToStrF(TempSV.PS_MultLdg,ffGeneral,9,4);
   NPSMultEdit.Text:=FloatToStrF(TempSV.NPS_MultLdg,ffGeneral,9,4);
   If CurrentTox<>NullStateVar
     then Case LoadType of
       0: TMultEdit.Text :=FloatToStrF(TempSV.ToxMultLdg[CurrentTox],ffGeneral,9,4);
       1: TMultEdit.Text :=FloatToStrF(TempSV.PSML[CurrentTox],ffGeneral,9,4);
       2: TMultEdit.Text :=FloatToStrF(TempSV.NPSML[CurrentTox],ffGeneral,9,4);
     End; {Case}
   If SaltScreen then TMultEdit.Text := FloatToStrF(TempSV.PS_MultLdg,ffGeneral,9,4);

   {Display the Init Conditions and Const Load Data}
   If VolumeScreen then ICEDIT.Text:=FloatToStrF(TempSV.InitCond,ffExponent,5,5)
                   else ICEDIT.Text:=FloatToStrF(TempSV.InitCond,ffGeneral,7,4);
   LoadEdit.Text:=FloatToStrF(TempSV.ConstLoad,ffGeneral,9,4);
   GasPhaseEdit.Text:=FloatToStrF(TempSV.Tox_Air_or_Alk,ffgeneral,9,4);
   If SV.nstate=pH then
     Begin
       Label13.Caption := 'Mean Alkalinity';
       Label15.Caption := 'ueq CaCO3/L';
       Label15.Font.Size:=8;
       Label16.Visible := False;
       ConvertAlk.Visible := True;
       GasPhasePanel.Visible := True;
     End;

   {Get Radio Buttons to their Correct State}
   With TempSV do
   Begin
      ConstRadButt.Checked:=UseConst and Not NoUserLoad;
      DynRadButt.Checked:=Not UseConst and Not NoUserLoad;
      If (CurrentTox <> NullStateVar) and not BuriedScreen then
        Begin
          Case LoadType of
            0: Begin
                 TConstRadButt.Checked:=ToxUseConst[CurrentTox];
                 TDynRadButt.Checked:=Not ToxUseConst[CurrentTox];
               End;
            1: Begin
                 TConstRadButt.Checked:=PSUC[CurrentTox];
                 TDynRadButt.Checked:=Not PSUC[CurrentTox];
               End;
            2: Begin
                 TConstRadButt.Checked:=NPSUC[CurrentTox];
                 TDynRadButt.Checked:=Not NPSUC[CurrentTox];
               End;
          End; {Case}
        End;
      If TempScreen then
        Begin
          TConstRadButt.Checked:=TempUseConst;
          TDynRadButt.Checked:=Not TempUseConst;
        End;
      If SaltScreen then
        Begin
          TConstRadButt.Checked := PS_UseConst;
          TDynRadButt.Checked   := Not PS_UseConst;
        End;
      MeanRangeButt.Checked:=NoUserLoad;
   End;

   {If SV.nstate=temperature then} enabledisable(nil);
   enabledisable2(nil);

   If SV.NState<>CO2 then enabledisable6(nil);

   {The Databases Update on The Screen Automatically}
   Update; {Redraw the form}
End;  {UpdateScreen}

{*************************************************************************}

procedure TStateVarDialog.Verify_Number(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update screen}
Var
Conv: Double;
Result: Integer;

begin
    Val(Trim(TEdit(Sender).Text),Conv,Result);
    If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else begin
                         case TEdit(Sender).Name[1] of
                            'I': TempSV.InitCond:=Conv;
                            'L': TempSV.ConstLoad:=Conv;
                            'T': If TempScreen then TempSV.TempInitCond:=Conv
                                               else TempSV.ToxInitCond[CurrentTox] := Conv;
                            'A': If SaltScreen then TempSV.PS_ConstLoad:=Conv else
                                 If TempScreen then TempSV.TempConstLoad:=Conv
                                               else Case LoadType of
                                                 0: TempSV.ToxConstLoad[CurrentTox] := Conv;
                                                 1: TempSV.PSCL[CurrentTox] := Conv;
                                                 2: TempSV.NPSCL[CurrentTox] := Conv;
                                               End; {Case}
                            'P': TempSV.PS_ConstLoad:=Conv;
                            'D': TempSV.DP_ConstLoad:=Conv;
                            'G': TempSV.Tox_Air_or_Alk:=Conv;
                            'W': If SV.nstate in [sand..clay]
                                    then TempSV.FracInBed:= Conv
                                    else TempSV.WindMean:= Conv;
                            'O': TempSV.BuriedTox[AssocToxTyp(CurrentTox)]:=Conv;
                            'X': TempSV.O2Thresh := Conv; 
                            'N': TempSV.NPS_ConstLoad:=Conv;
                            'Z': Begin
                                  If (Conv>24) or (Conv<0)
                                      then MessageDlg('Photoperiod must be between 0 and 24 hours.',mterror,[mbOK],0)
                                      else TempSV.PhotoPeriod := Conv;
                                 End;
                          end; {case}
                      end; {else}
    UpdateScreen;
end; {VerifyNumber}

{*************************************************************************}

procedure TStateVarDialog.VerifyMultLdg(Sender: TObject);

{ Convert MultLdg Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update screen}
Var
Conv: Double;
Result: Integer;

begin
    Val(Trim(TEdit(Sender).Text),Conv,Result);
    Conv:=Abs(Conv);
    If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else begin
                         case TEdit(Sender).Name[1] of
                            'M': TempSV.MultLdg    :=Conv;
                            'D': TempSV.DP_MultLdg :=Conv;
                            'P': TempSV.PS_MultLdg :=Conv;
                            'T': If SaltScreen then TempSV.PS_MultLdg := Conv else
                                 If TempScreen then TempSV.TempMultLdg :=Conv
                                               else Case LoadType of
                                                 0: TempSV.ToxMultLdg[CurrentTox]  :=Conv;
                                                 1: TempSV.PSML[CurrentTox]  :=Conv;
                                                 2: TempSV.NPSML[CurrentTox]  :=Conv;
                                               End; {case}
                            'N': TempSV.NPS_MultLdg:=Conv;
                         end; {case}
                      end; {else}
    UpdateScreen;
end; {VerifyMult}

{*************************************************************************}

{ENABLEDISABLE: 6 PROCEDURES THAT HANDLE BUTTON CLICKS AND THEIR
                EFFECTS ON THE SCREEN INTERFACE.}

procedure TStateVarDialog.EnableDisable(Sender: TObject);

begin
   If VolumeScreen and (not EstuaryVol) then Exit;
   If Not IsDetrScreen then
     Begin
       If (TempSV.UseConst<>ConstRadButt.Checked)    or
          (TempSV.NoUserLoad<>MeanRangeButt.Checked) then Changed:=True;
       TempSV.UseConst:=ConstRadButt.Checked;
       TempSV.NoUserLoad:=MeanRangeButt.Checked;
     End;

   ToxicPanel.Enabled:=True;

   Label13.Enabled :=True;
   Label15.Enabled :=True;
   GasPhaseEdit.Enabled := True;
   If SV<> nil then
    If (SV.NState=pH) and (not MeanRangeButt.Checked) then
     Begin
       Label13.Enabled :=False;
       Label15.Enabled :=False;
       GasPhaseEdit.Enabled := False;
     End;

   If SV<> nil then
    If (SV.NState=Ammonia) and (TempSV.TN_Inflow) then
      Begin
        If (Sender<>nil) then UpdateScreen;
        exit;
      End;

   ToxicPanel.Color:=clBtnFace;
   If ConstRadButt.Checked then begin
                                  LoadEdit.Enabled:=True;
                                  DbGrid1.Enabled:=False;
                                  DbGrid1.Color:=clGray;
                                  DbNavigator1.Enabled:=False;
{                                  If TempSV.Alternate_Loadings and (not EstuaryVol)
                                     and (not TempSV.NPSShowing) then LoadingsPanel.Visible:=True; }
                                  If TempSV.SVType=SVTemp then ToxicPanel.Color:=clBtnFace;
                                end
   else if (DynRadButt.Checked) then begin
                                     LoadEdit.Enabled:=False;
                                     DbGrid1.Enabled:=True;
                                     DbGrid1.Color:=EditColor;
                                     DbNavigator1.Enabled:=True;
{                                     If TempSV.Alternate_Loadings and (not EstuaryVol) then LoadingsPanel.Visible:=True; }
                                     If TempSV.SVType=SVTemp then ToxicPanel.Color:=clBtnFace;
                                    end
                        else begin      {ignore loadings button is checked}
                               If SV.Nstate = WindLoading then LoadEdit.Enabled:=True
                                                           else LoadEdit.Enabled:=False;
                               DbGrid1.Enabled:=False;
                               DbGrid1.Color:=clGray;
                               DbNavigator1.Enabled:=False;
                               If TempSV.SVType=SVTemp then
                                 Begin
                                   ToxicPanel.Color:=ClGray;
                                   ToxicPanel.Enabled:=False;
                                 End;
                             end;

  If Not IsDetrScreen and (Sender<>nil) then UpdateScreen;
end;

Procedure TStateVarDialog.EnableDisable2(Sender: TObject);
begin
   If VolumeScreen then Exit;
   If Not TempScreen and Not SaltScreen and (CurrentTox=nullstatevar) then exit;

   If TempScreen
     then
       Begin
         If TempSV.TempUseConst<>TConstRadButt.Checked then Changed:=True;
         TempSV.TempUseConst:=TConstRadButt.Checked;
       End
   Else If SaltScreen
     then
      Begin
         If TempSV.PS_UseConst<>TConstRadButt.Checked then Changed:=True;
         TempSV.PS_UseConst:=TConstRadButt.Checked;
      End
   Else If Not IsDetrScreen then
         Begin
           Case LoadType of
              0: Begin
                   If (TempSV.ToxUseConst[CurrentTox]<>TConstRadButt.Checked) then Changed:=True;
                   TempSV.ToxUseConst[CurrentTox]:=TConstRadButt.Checked;
                 End;
              1: Begin
                   If (TempSV.PSUC[CurrentTox]<>TConstRadButt.Checked) then Changed:=True;
                   TempSV.PSUC[CurrentTox]:=TConstRadButt.Checked;
                 End;
              2: Begin
                   If (TempSV.NPSUC[CurrentTox]<>TConstRadButt.Checked) then Changed:=True;
                   TempSV.NPSUC[CurrentTox]:=TConstRadButt.Checked;
                 End;
           End; {Case}
         End;

   If (TConstRadButt.Checked) then
                                begin
                                  aTLoadEdit.Enabled:=True;
                                  DbGrid2.Enabled:=False;
                                  DbGrid2.Color:=clGray;
                                  DbNavigator2.Enabled:=False;
                                end
                           else begin
                                   aTLoadEdit.Enabled:=False;
                                   DbGrid2.Enabled:=True;
                                   DbGrid2.Color:=EditColor;
                                   DbNavigator2 .Enabled:=True;
                                end;
end;

procedure TStateVarDialog.EnableDisable3(Sender: TObject);
begin
  If (TempSV.PS_UseConst<>PSConstRadio.Checked) then Changed:=True;
  TempSV.PS_UseConst:=PSConstRadio.Checked;
  If PSConstRadio.Checked then begin
                                 PSLoadEdit.Enabled:=True;
                                 PSGrid.Enabled:=False;
                                 PSGrid.Color:=ClGray;
                                 DbNavigator3.Enabled:=False;
                               end
                          else begin
                                 PSLoadEdit.Enabled:=False;
                                 PSGrid.Enabled:=True;
                                 PSGrid.Color:=EditColor;
                                 DbNavigator3.Enabled:=True;
                               end;
end;

procedure TStateVarDialog.EnableDisable4(Sender: TObject);
begin
  If (TempSV.DP_UseConst<>DPConstRadio.Checked) then Changed:=True;
  TempSV.DP_UseConst:=DPConstRadio.Checked;
  If DPConstRadio.Checked then begin
                                 DPLoadEdit.Enabled:=True;
                                 DPGrid.Enabled:=False;
                                 DPGrid.Color:=ClGray;
                                 DbNavigator4.Enabled:=False;
                               end
                          else begin
                                 DPLoadEdit.Enabled:=False;
                                 DPGrid.Enabled:=True;
                                 DPGrid.Color:=EditColor;
                                 DbNavigator4.Enabled:=True;
                               end;
end;

procedure TStateVarDialog.EnableDisable5(Sender: TObject);
begin
  If ManningButt.Checked then TempSV.Calc_M:=Manning;
  If ConstButt.Checked   then TempSV.Calc_M:=KeepConst;
  If DynamicButt.Checked then TempSV.Calc_M:=Dynam;
  If KnownValButt.Checked then TempSV.Calc_M:=KnownVal;
  Changed:=True;
  UpdateScreen;
end;

procedure TStateVarDialog.enabledisable6(Sender: TObject);
begin
  If (SV<>nil) then
    If (SV.NState=Co2) then
    Begin
      If UpdatingScr then Exit;
      TempSV.TempCo2Equil := not NPSCLRadio.Checked;
      UpdateScreen;
      Exit;
    End;

  If (TempSV.NPS_UseConst<>NPSCLRadio.Checked) then Changed:=True;
  TempSV.NPS_UseConst:=NPSCLRadio.Checked;
  If NPSCLRadio.Checked then begin
                                 NPSConstLoad.Enabled:=True;
                                 NPSGrid.Enabled:=False;
                                 NPSGrid.Color:=ClGray;
                                 DbNavigator6.Enabled:=False;
                               end
                          else begin
                                 NPSConstLoad.Enabled:=False;
                                 NPSGrid.Enabled:=True;
                                 NPSGrid.Color:=EditColor;
                                 DbNavigator6.Enabled:=True;
                               end;
end;

{End of EnableDisable Routines}
{*************************************************************************}

procedure TStateVarDialog.AnadromousClick(Sender: TObject);
Var TF: TAnimal;
begin
   If SV.IsSmallFish then TF := TAnimal(SV)
                     else TF := SV.AllStates.GetStatePointer(TempSV.SameSpec,StV,WaterCol);
   Application.CreateForm(TAnadromousForm, AnadromousForm);
   AnadromousForm.EditAndRecord(TF.AnadRec);
   AnadromousForm.Free;
end;

procedure TStateVarDialog.AppException(Sender: TObject; E: Exception);
begin
   If E.Message='Key violation.' then  {multiple name error message}
      MessageDlg('You have already entered a loading for that date.',mtError,[mbOK],0)
   else
   Application.ShowException(E);      {mainly handles invalid # format}
end;

procedure TStateVarDialog.FormCreate(Sender: TObject);
begin
  SV := nil;
  inherited;
{  Application.OnException:=AppException; }
  If Screen.WorkAreaHeight>620 then
    Begin

      Height := 600;
      VolumeButt.Top := 532;
      VolButton2.Top := 532;
      EvapButton.Top := 532;
      CO2EquilButton.Top := 532;
      EstSaltButton.Top := 532;
      EditButton.Top := 532;
      LoadButton.Top := 532;
      SaveButton.Top := 532;
      OKBtn.Top := 532;
      CancelBtn.Top := 532;
      PSNPSButt.Top := 532;
      ToggleButton.Top := 532;
    End;
  DontUpdateHCB := False;
end;

procedure TStateVarDialog.CancelBtnClick(Sender: TObject);
Begin
   If Not Changed then ModalResult:=MRCancel
      else If MessageDlg('Discard all edits (including any changes to underlying data)?',mtConfirmation,mbOKCancel,0)=mrOK
           then ModalResult:=MRCancel;
end;

procedure TStateVarDialog.CO2EquilButtonClick(Sender: TObject);
begin
  TempSV.TempCO2Equil := True;
  NPSDLRadio.Checked := True;
//  UpdateScreen;
end;

{*************************************************************************}

procedure TStateVarDialog.EstSaltButtonClick(Sender: TObject);
begin
  Application.CreateForm(TEstuaryLoadForm, EstuaryLoadForm);
  EstVarChanged := EstuaryLoadForm.EditLoads(SV.AllStates.EstuarySaltLoads) ;
  EstuaryLoadForm.Free;
end;


procedure TStateVarDialog.EvapButtonClick(Sender: TObject);
begin
  Application.CreateForm(TSiteDialog, SiteDialog);
  SiteDialog.LinkedMode := SV.Allstates.LinkedMode;
  SiteDialog.MeanDepthToggleClick(nil);
  SiteDialog.EditSite(TAQUATOXSegment(ThisAQTS));
  If SiteDialog.Changed then CHANGED := TRUE;
  SiteDialog.Free;

end;

Procedure TStateVarDialog.EditButtonClick(Sender: TObject);
{Procedure Loads Record into Database for editing in one of the entry
screens, creates the entry forms, changes them to reflect the appropriate
type of editing, shows them modally, and returns the data to the record
form}

Var
   ModalResult, DBNum: Integer;
   RecordName: ShortString;
   LoadResult, ItemFound: Boolean;
   PAT: TAnimalToxRecord;
   PPT: TPlantToxRecord;
   PC : TCollection;
   LipidFrac: Double;
   FirstEntry: Boolean;

              {----------------------------------------------------------------------------------------------------}
              Procedure SetupAnimalUnderlyingData;
              Var SVLoop: AllVariables;
                  TA: TAnimal;
                  ToxLoop: T_SVType;
                  Loop,Loop2: Integer;
                  FoundIt: Boolean;

              Begin  {Animal}
                Application.CreateForm(TEdit_Animal, Edit_Animal);
                With Edit_Animal.Table2 do
                  begin
                    LipidFrac := TempSV.AnimalRecord.FishFracLipid;
                    Active:=False;
                    DatabaseName:=program_dir;
                    TableName:='ANIMFORM.DB';
                    EmptyTable;

                    For SVLoop := LastAnimal downto FirstAnimal do
                      Begin
                        TA := SV.GetStatePointer(SVLoop,STV,WaterCol);
                        If TA<> nil then
                          Begin
                            If TA.NState = SV.NState
                              then LoadResult := AnimalRecord_to_Dbase(program_dir,'ANIMFORM.DB',TempSV.AnimalRecord.AnimalName,TempSV.AnimalRecord,False)
                              else LoadResult := AnimalRecord_to_Dbase(program_dir,'ANIMFORM.DB',TA.PAnimalData^.AnimalName,TA.PAnimalData^,False);

                            If not LoadResult then
                                   Begin
                                      MessageDlg('AQUATOX ERROR- Animal Record Not Loading',mterror,[mbOK],0);
                                      Edit_Animal.Free;
                                      Exit;
                                   End;
                          End;
                      End; {SVLoop}

                    Edit_Animal.LibraryMode := False;
                    Edit_Animal.DbNavigator1.Visible:=True;
                    Edit_Animal.CancelButton.Visible:=True;
                    Edit_Animal.FindButton.Visible:=True;
                    Edit_Animal.SciSearch.Visible:=True;
                    Edit_Animal.NewButton.Visible:=False;
                    Edit_Animal.SaveButton.Caption:='&OK';
//                    Edit_Animal.LoadButton.Visible:=False;
                    Edit_Animal.SaveLib.Visible:=True;
                    Edit_Animal.MultiFish := False;
                    Edit_Animal.MultiLayerOn := SV.AllStates.SedModelIncluded;
                    Edit_Animal.YOYFish := False;
                    Edit_Animal.Table2.IndexFieldNames := '';    // 2/12/2010 allow sorting by trophic level
                    Active := True;

                    SVLoop := FirstAnimal;
                    FoundIt := False;
                    First;
                    Repeat
                      TA := SV.GetStatePointer(SVLoop,STV,WaterCol);
                      If TA<>nil then
                        Begin
                          FoundIt := SVLoop = SV.nstate;
                          If Not FoundIt then Next;
                        End;
                      Inc(SVLoop);
                    Until FoundIt;

                    If SV.IsFish and (SV.nstate < Fish1) then Edit_Animal.SpeciesDataButton.Visible:=True;
                    Edit_Animal.SVPtr:=SV;
                    Edit_Animal.StatePtr:=SV.AllStates;
                    Edit_Animal.SpecPtr := @(TempSV.SameSpec);
                    Edit_Animal.TrophIntPtr := @(TempSV.TempTrophInt);
                    Edit_Animal.DBNavigator1.VisibleButtons := [nbFirst,nbPrior,nbNext,nbLast];

                    For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
                     {Add additional toxicity fields to Edit_Animal ToxComboBox items}
                     If SV.GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol)<>nil then
                      Begin
                        If FirstEntry then Edit_Animal.ToxComboBox.Items.Clear;
                        FirstEntry := False;
                        PC := SV.AllStates.ChemPtrs^[ToxLoop].Anim_Tox;
                        With Edit_Animal.ToxComboBox do
                         For loop := 0 to PC.Count-1 do
                          Begin
                            ItemFound:=False;
                            PAT := PC.At(loop);
                            For loop2 := 0 to Items.Count-1 do
                              If Lowercase(Items.Strings[loop2]) =
                                 Lowercase(PAT.Animal_Name) then ItemFound:=True;
                            If Not ItemFound then Items.Append(PAT.Animal_Name);
                          End;
                      End;

                    Edit_Animal.AnimalTypeBoxChange(nil);

                    ModalResult:=Edit_Animal.ShowModal;
                    If Edit_Animal.Changed then Changed:=True;
                    RecordName:=Fields[0].AsString;
                 End; {with}

              If Edit_Animal.ToxChanged then ToxChanged := True;
              Edit_Animal.Hide;
              Edit_Animal.Free;
              If ModalResult<>MrCancel then
                begin
                    DBNum := 0;
                    For SVLoop := FirstAnimal to LastAnimal do
                      Begin
                        TA := SV.GetStatePointer(SVLoop,STV,WaterCol);
                        If TA<> nil then
                          Begin
                            Inc(DBNum);
                            If TA.NState = SV.NState
                              then LoadResult := Dbase_to_AnimalRecord(program_dir,'ANIMFORM.DB','',DBNum,TempSV.AnimalRecord)
                              else LoadResult := Dbase_to_AnimalRecord(program_dir,'ANIMFORM.DB','',DBNum,TA.PAnimalData^);

                            If not LoadResult then
                               Begin
                                  MessageDlg('AQUATOX ERROR- Animal Records Not Reading Back',mterror,[mbOK],0);
                                  Exit;
                               End;
                          End;
                      End; {SVLoop}

                  TempSV.SVName:=AbbrString(TempSV.SVName,':')+': ['+TempSV.AnimalRecord.AnimalName+']';

                  If SV.AllStates.NumOrgToxicants > 0 then
                      CopyLipidFractions(False,True);

                end;
              End; {SETUPANIMALUNDERLYINGDATA}
              {----------------------------------------------------------------------------------------------------}
              Procedure SetupPlantUnderlyingData;
              Var SVLoop: AllVariables;
                  TP:TPlant;
                  ToxLoop: T_SVType;
                  Loop,Loop2: Integer;
                  FoundIt: Boolean;
              Begin  {Plant}
                Application.CreateForm(TEdit_Plant, Edit_Plant);
                With Edit_Plant.Table3 do
                  begin
                    LipidFrac := TempSV.PlantRecord.PlantFracLipid;  // TESTME
                    Active:=False;
                    DatabaseName:=program_dir;
                    TableName:='PLNTFORM.DB';
                    EmptyTable;

                    For SVLoop := LastPlant downto FirstPlant do
                      Begin
                        TP := SV.GetStatePointer(SVLoop,STV,WaterCol);
                        If TP<> nil then
                          Begin
                            If TP.NState = SV.NState
                              then LoadResult := PlantRecord_to_Dbase(program_dir,'PLNTFORM.DB',TempSV.PlantRecord.PlantName,TempSV.PlantRecord)
                              else LoadResult := PlantRecord_to_Dbase(program_dir,'PLNTFORM.DB',TP.PAlgalRec^.PlantName,TP.PAlgalRec^);

                            If not LoadResult then
                                   Begin
                                      MessageDlg('AQUATOX ERROR- Plant Record Not Loading',mterror,[mbOK],0);
                                      Edit_Plant.Free;
                                      Exit;
                                   End;
                          End;
                      End; {SVLoop}

                    Edit_Plant.LibraryMode := False;
                    Edit_Plant.DbNavigator1.Visible:=True;
                    Edit_Plant.CancelButton.Visible:=True;
                    Edit_Plant.FindButton.Visible:=True;
                    Edit_Plant.SciSearch.Visible:=True;
                    Edit_Plant.NewButton.Visible:=False;
                    Edit_Plant.SaveButton.Caption:='&OK';
                    Edit_Plant.SaveLib.Visible:=True;
                    Active:=True;

                    Edit_Plant.SVPtr:=SV;
                    Edit_Plant.SpecPtr := @(TempSV.SameSpec);

                    SVLoop := FirstPlant;
                    FoundIt := False;
                    First;
                    Repeat
                      TP := SV.GetStatePointer(SVLoop,STV,WaterCol);
                      If TP<>nil then
                        Begin
                          FoundIt := SVLoop = SV.nstate;
                          If Not FoundIt then Next;
                        End;
                      Inc(SVLoop);
                    Until FoundIt;

                    For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
                     {Add additional toxicity fields to Edit_Plant ToxComboBox items}
                     If SV.GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol)<>nil then
                      Begin
                        PC := SV.AllStates.ChemPtrs^[ToxLoop].Plant_Tox;
                        With Edit_Plant.ToxComboBox do
                         For loop := 0 to PC.Count-1 do
                          Begin
                            ItemFound:=False;
                            PPT := PC.At(loop);
                            For loop2 := 0 to Items.Count-1 do
                              If Lowercase(Items.Strings[loop2]) =
                                 Lowercase(PPT.Plant_Name) then ItemFound:=True;
                            If Not ItemFound then Items.Append(PPT.Plant_Name);
                          End;
                      End;
                    Edit_Plant.PlantTypeBoxChange(nil);

                    ModalResult:=Edit_Plant.ShowModal;
                    If Edit_Plant.Changed then Changed:=True;
                    RecordName:=Fields[0].AsString;
                End; {with}

              If Edit_Plant.ToxChanged then ToxChanged := True;
              Edit_Plant.Hide;
              Edit_Plant.Free;
              If ModalResult<>MrCancel then
                begin
                  DBNum := 0;
                  For SVLoop := FirstPlant to LastPlant do
                    Begin
                      TP := SV.GetStatePointer(SVLoop,STV,WaterCol);
                      If TP<> nil then
                        Begin
                          Inc(DBNum);
                          If TP.NState = SV.NState
                              then LoadResult := Dbase_to_PlantRecord(program_dir,'PLNTFORM.DB','',DBNum,TempSV.PlantRecord)
                              else LoadResult := Dbase_to_PlantRecord(program_dir,'PLNTFORM.DB','',DBNum,TP.PAlgalRec^);

                          If not LoadResult then
                             Begin
                                MessageDlg('AQUATOX ERROR- Plant Record Not Reading Back',mterror,[mbOK],0);
                                Exit;
                             End;
                        End;
                    End; {SVLoop}

                  TempSV.SVName:=AbbrString(TempSV.SVName,':')+': ['+TempSV.PlantRecord.PlantName+']';

                  If SV.AllStates.NumOrgToxicants > 0 then
                     CopyLipidFractions(False,False);

                end;
            End; {if = plant, SetupPlantUnderlyingData}
              {----------------------------------------------------------------------------------------------------}

            Procedure SetupChemicalUnderlyingData;
              Var SVLoop: AllVariables;
                  PCR: PChemicalRecord;
                  FoundIt: Boolean;

            Begin  {Chemical}
                Application.CreateForm(TEdit_Chemical, Edit_Chemical);
                Application.CreateForm(TKPSedConfirm, KPSedConfirm);
                Application.CreateForm(TPFAK2Form, PFAK2Form);
                Application.CreateForm(TChemToxForm, ChemToxForm);
                Application.CreateForm(TEC50LC50Dialog, EC50LC50Dialog);
                Application.CreateForm(TRegrDialog, RegrDialog);
                Edit_Chemical.PLipidModified := @LipidModified;
                Edit_Chemical.ExtTox := SV.AllStates.SetupRec.UseExternalConcs;
                ChemToxForm.AnimalMeth := TempSV.AnimMeth;
                ChemToxForm.PlantMeth := TempSV.PlantMeth;

                With Edit_Chemical.Table1 do
                  begin
                    Active:=False;
                    DatabaseName:=program_dir;
                    TableName:='CHEMFORM.DB';
                    EmptyTable;

                    Active:=False;

                    For SVLoop := LastOrgTox downto FirstOrgTox do
                      Begin
                        PCR := @SV.ChemPtrs^[AssocToxTyp(SVLoop)].ChemRec;
                        If (PCR<> nil) and (SV.GetStatePointer(SVLoop,StV,WaterCol) <> nil) then
                          Begin
                            If SVLoop = SV.NState
                              then LoadResult := ChemRecord_to_Dbase(program_dir,'ChemFORM.DB',TempSV.ChemRecord.ChemName,TempSV.ChemRecord)
                              else LoadResult := ChemRecord_to_Dbase(program_dir,'ChemFORM.DB',PCR^.ChemName,PCR^);

                            If not LoadResult then
                                   Begin
                                      MessageDlg('AQUATOX ERROR- Animal Record Not Loading',mterror,[mbOK],0);
                                      Edit_Chemical.Free;
                                      Exit;
                                   End;
                          End;
                      End; {SVLoop}

                    Edit_Chemical.LibraryMode:=False;
                    Edit_Chemical.DbNavigator1.Visible:=True;
                    Edit_Chemical.CancelButton.Visible:=True;
                    Edit_Chemical.FindButton.Visible:=True;
                    Edit_Chemical.NewButton.Visible:=False;
                    Edit_Chemical.SaveButton.Caption:='&OK';
//                  Edit_Chemical.LoadButton.Visible:=False;
                    Edit_Chemical.SaveLib.Visible:=True;
                    Edit_Chemical.MultiLayerOn := SV.AllStates.SedModelIncluded;

                    Active:=True;

                    SVLoop := FirstOrgTox;
                    FoundIt := False;
                    First;
                    Repeat
                      PCR := @SV.ChemPtrs^[AssocToxTyp(SVLoop)].ChemRec;
                      If (PCR<> nil) and (SV.GetStatePointer(SVLoop,StV,WaterCol) <> nil) then
                        Begin
                          FoundIt := SVLoop = SV.nstate;
                          If Not FoundIt then Next;
                        End;
                      Inc(SVLoop);
                    Until FoundIt;

                    ModalResult := MROK;
                    If TButton(Sender).Name = 'ToxicityDataButton'
                       then Edit_Chemical.ToxButtonClick(nil)
                       else ModalResult:=Edit_Chemical.ShowModal;
                    If Edit_Chemical.Changed then Changed:=True;
                    RecordName:=Fields[0].AsString;

                End; {with}

              Edit_Chemical.Hide;
              Edit_Chemical.Free;
              KPSedConfirm.Free;
              PFAK2Form.Free;
              EC50LC50Dialog.Free;
              RegrDialog.Free;

              If ModalResult<>MrCancel then
                begin
                    DBNum := 0;
                    For SVLoop := FirstOrgTox to LastOrgTox do
                      Begin
                        PCR := @SV.ChemPtrs^[AssocToxTyp(SVloop)].ChemRec;
                        If (PCR<> nil) and (SV.GetStatePointer(SVLoop,StV,WaterCol) <> nil) then
                          Begin
                            Inc(DBNum);
                            If SVLoop = SV.NState
                              then LoadResult := Dbase_to_ChemRecord(program_dir,'CHEMFORM.DB','',DBNum,TempSV.ChemRecord)
                              else LoadResult := Dbase_to_ChemRecord(program_dir,'CHEMFORM.DB','',DBNum,PCR^);

                          If not LoadResult then
                               Begin
                                  MessageDlg('AQUATOX ERROR- Chemical Records Not Reading Back',mterror,[mbOK],0);
                                  Exit;
                               End;
                          End;
                      End; {SVLoop}

                 TempSV.SVName:=AbbrString(TempSV.SVName,':')+': ['+TempSV.ChemRecord.ChemName+']';

                 Edit_Chemical.ExtTox := SV.AllStates.SetupRec.UseExternalConcs;
                 TempSV.AnimMeth := ChemToxForm.AnimalMeth ;
                 TempSV.PlantMeth := ChemToxForm.PlantMeth ;
                end;
              ChemToxForm.Free;
            End; {SetupChemicalUnderlyingData}
              {----------------------------------------------------------------------------------------------------}

Begin  {EditButtonClick}
     FirstEntry := True;
     If TempSV.SVType=SVAnimal then
       SetupAnimalUnderlyingData
         ELSE if TempSV.SVTYPE=SVPlant then
           SetupPlantUnderlyingData
           ELSE SetupChemicalUnderlyingData; {Must = Chemical}

     If ModalResult<>MrCancel then
        begin
          If ((TempSV.HasData=False) and (RecordName<>''))
             then begin
                    MessageDlg('If changes are kept, this State Variable will be set as having "Associated Data"',
                                  MTInformation,[MBOK],0);
                    MessageDlg('Warning! Model will not run properly if required fields are left blank.',MTWarning,[MBOK],0);
                    TempSV.HasData:=True;
                  End;
        end;

     Application.OnException:=AppException;  {Reset Application to this Form's Error Handler}
     UpdateScreen;
End;   {EditButtonClick}

{**************************************************************************}
{DBGRID EXIT:  4 Procedures that handle Database/Interface Interactions}

PROCEDURE TStateVarDialog.DBGrid1Exit(Sender: TObject);
begin
  If Table1.state in [dsedit,dsinsert] then Table1.Post; Changed:=True;
end;
PROCEDURE TStateVarDialog.DBGrid2Exit(Sender: TObject);
begin
  If Table2.state in [dsedit,dsinsert] then Table2.Post; Changed:=True;
end;
PROCEDURE TStateVarDialog.PSGridExit(Sender: TObject);
begin
  If Table3.State in [dsedit,dsinsert] then Table3.Post; Changed:=True;
end;
PROCEDURE TStateVarDialog.DPGridExit(Sender: TObject);
begin
  If Table4.State in [dsedit,dsinsert] then Table4.Post; Changed:=True;
end;
PROCEDURE TStateVarDialog.NPSGridExit(Sender: TObject);
begin
  If Table5.State in [dsedit,dsinsert] then Table5.Post; Changed:=True;
end;

{**************************************************************************}

procedure TStateVarDialog.SaveButtonClick(Sender: TObject);
Var PA: TAnimal;
    Ent,DN,FN: ShortString;
    TrophDir: String;
Begin
  Case TempSV.SVType of
  SVAnimal : Begin
               If not Library_File1.ReturnDBName('Animal',DN,FN) then exit;
               If not AnimalRecord_To_Dbase(DN,FN,TempSV.AnimalRecord.AnimalName,TempSV.AnimalRecord,True) then exit;
               Begin
                  PA := TAnimal.Init(NullStateVar,StV,'',Nil,0,True);
                  PA.PTrophInt^ := TrophIntArray(TempSV.TempTrophInt);
                  If DirectoryExists(DN+'\Trophint')
                     then TrophDir := DN+'\Trophint\'
                     else TrophDir := DN+'\';
                  PA.WriteTrophInt(TrophDir+TempSV.AnimalRecord.AnimalName+'.int');
                  PA.Destroy;
               End;
               MessageDlg(TempSV.AnimalRecord.AnimalName+ ' Underlying Data and Trophic Interactions Successfully Saved to the Databases.',mtinformation,[mbok],0);
             End;
  SVPlant : Begin
               If not Library_File1.ReturnDBName('Plant',DN,FN) then exit;
               If not PlantRecord_To_Dbase(DN,FN,TempSV.PlantRecord.PlantName,TempSV.PlantRecord) then exit;
               MessageDlg(TempSV.PlantRecord.PlantName+ ' Underlying Data Successfully Saved to the Database.',mtinformation,[mbok],0);
             End;

  SVChemical :
             Begin
               If not Library_File1.ReturnDBName('Chemical',DN,FN) then exit;
               If not ChemRecord_To_Dbase(DN,FN,TempSV.ChemRecord.ChemName,TempSV.ChemRecord) then exit;
               Ent := TempSV.ChemRecord.ChemName;
               AQTCopyFile(Program_Dir+'\AnimToxForm.DB',DN+'\ChemToxDBs\'+Ent+'_Animal_Tox.DB');
               AQTCopyFile(Program_Dir+'\PlantToxForm.DB',DN+'\ChemToxDBs\'+Ent+'_Plant_Tox.DB');
               MessageDlg(TempSV.ChemRecord.ChemName+ ' Underlying Data and Toxicity Databases Successfully Saved to the Databases.',mtinformation,[mbok],0);
             End;

   End; {Case}
end;

{**************************************************************************}

procedure TStateVarDialog.LoadButtonClick(Sender: TObject);
{setup DB_GetEntry Dialog and call it modally... Then load the
 selected data if appropriate}
Var LoadOK: Boolean;
    TrophDir: String;
    PA: TAnimal;
begin
  Application.CreateForm(TDb_GetEntry, Db_GetEntry);
  With Db_GetEntry do
  begin
  Case TempSV.SVType of
       SVAnimal :  Begin
                      HeadString:='Select Animal Entry to Load:';
                      Filter:='Animal DBs (*.adb)|*.ADB|';
                      DefaultDbName:='Animal.ADB';
                   End;
       SVPlant  :  Begin
                      HeadString:='Select Plant Entry to Load:';
                      Filter:='Plant DBs (*.pdb)|*.PDB|';
                      DefaultDbName:='Plant.PDB';
                   End;
       SVChemical: Begin
                      HeadString:='Select Chemical Entry to Load:';
                      Db_GetEntry.Filter:='Chemical DBs (*.cdb)|*.CDB|';
                      Db_GetEntry.DefaultDbName:='Chemical.CDB';
                   End;
  End; {Case}

  If Not GetEntry Then Exit;

  Changed:=True;
  LoadOK:= False;

  Case TempSV.SVType of
       SVAnimal :  Begin
                     LoadOK:=Dbase_to_AnimalRecord(FileDir,FileName,Entry,-1,TempSV.AnimalRecord);
                     PA := TAnimal.Init(NullStateVar,StV,'',Nil,0,True);
                     If DirectoryExists(FileDir+'\Trophint')
                        then TrophDir := FileDir+'\Trophint\'
                        else TrophDir := FileDir+'\';
                     If PA.ReadTrophInt(TrophDir+TempSV.AnimalRecord.AnimalName+'.int')
                        then TempSV.TempTrophInt := PA.PTrophint^;
                     PA.Destroy; 
                   End;
       SVPlant  :  LoadOK:=Dbase_to_PlantRecord(FileDir,FileName,Entry,-1,TempSV.PlantRecord);
       SVChemical: Begin
                     LoadOK:= (Dbase_to_ChemRecord(FileDir,FileName,Entry,-1,TempSV.ChemRecord));
                     If (FileDir+'\'=Default_Dir) or (FileDir=Default_Dir)then FileDir:=FileDir+'\ChemToxDBs';
                     If not FileExists(FileDir+'\'+Entry+'_Animal_Tox.DB')
                       Then Begin
                              MessageDlg('Associated Animal Toxicity file '+FileDir+'\'+Entry+'_Animal_Tox.DB does'+
                                         'not exist.  Emptying Tox Record.',mterror,[mbOK],0);
                              EraseTable.DatabaseName:=Program_Dir; EraseTable.TableName:='AnimToxForm.DB';
                              EraseTable.EmptyTable;
                            End
                       Else AQTCopyFile(FileDir+'\'+Entry+'_Animal_Tox.DB',Program_Dir+'\AnimToxForm.DB' );

                     If not FileExists(FileDir+'\'+Entry+'_Plant_Tox.DB')
                       Then Begin
                              MessageDlg('Associated Plant Toxicity file '+FileDir+'\'+Entry+'_Plant_Tox.DB does'+
                                         'not exist.  Emptying Tox Record.',mterror,[mbOK],0);
                              EraseTable.DatabaseName:=Program_Dir; EraseTable.TableName:='PlantToxForm.DB';
                              EraseTable.EmptyTable;
                            End
                       Else AQTCopyFile(FileDir+'\'+Entry+'_Plant_Tox.DB',Program_Dir+'\PlantToxForm.DB' );
                   End;
  end; {Case}

If LoadOK then TempSV.SVName:=AbbrString(TempSV.SVName,':')+': ['+Entry+']'
          else TempSV.SVName:=AbbrString(TempSV.SVName,':')+': [Load Error]';
End; {With};

  DB_GetEntry.Free;

  UpdateScreen;
  If Not LoadOK then MessageDlg('Load Error: Press Cancel From This Screen To Restore Original Values.',mterror,[mbOK],0);

  If LoadOK then TempSV.HasData:=True;

  If LoadOK and ((TempSV.SVType=SVAnimal) or (TempSV.SVType=SVPlant)) then
   If SV.AllStates.OrgTox_In_System then
    If MessageDlg('Because LipidFrac was changed, AQUATOX will update the LipidFrac fields for all toxicants in the study.',
                   mtConfirmation, [mbok,mbcancel], 0) = mrok then
       CopyLipidFractions(True,TempSV.SVType=SVAnimal);

End; {Procedure}

{*************************************************************************}

procedure TStateVarDialog.PSNPSButtClick(Sender: TObject);
begin
  TempSV.ShowingNPS:= not(TempSV.ShowingNPS);
  UpdateScreen;
end;

procedure TStateVarDialog.VolButton2Click(Sender: TObject);
Var TV: TVolume;
begin
  Application.CreateForm(TStratFlowForm,StratFlowForm);

  If VolumeScreen then TV := TVolume(SV)
                  else TV := TVolume(SV.AllStates.GetStatePointer(Volume,StV,WaterCol));
  StratflowForm.EditStratInfo(TV,@SV.AllStates.Z_Thermocline);

  StratFlowForm.Free;
end;

procedure TStateVarDialog.VolumeButtClick(Sender: TObject);
begin
  TempSV.InitCond:=SV.AllStates.Location.Locale.StaticVolume;
  UpdateScreen;
end;

{ IMPORT BUTTON CLICKS }

Procedure TStateVarDialog.ImportButt1Click(Sender: TObject);
Var LoadTable: TTable;
    Nm,Fmt   : String;
    Hrly     : Boolean;
Begin
  Hrly := False;
  Case TButton(Sender).Name[11] of
     '1': begin
            LoadTable:=Table1;
            If (HourlyCB.Visible) and (HourlyCB.Checked) then Hrly := True;
            Nm := TempSV.SVName + ' ('+CL_Unit.Caption+')';
          end;
     '2': begin
            LoadTable:=Table1;
            Nm := TempSV.SVName + '(mg/L)';
          end;
     '3': begin
            LoadTable:=Table2;
            Case SV.nstate of
              Temperature: Nm := 'Hypolimnion Temperature (C)';
              Salinity   : NM := 'Salinity, Lower Level (ppt)';
              else Nm := TempSV.SVName + ': Tox Load ('+TCL_Unit.Caption+')';
            End; {Case}
          end;
     '4': begin
            LoadTable:=Table3;
            Nm := TempSV.SVName + ': '+ PointLabel.Caption +
                  ' ('+PointUnitLabel2.Caption+')';
          end;
     '5': begin
            LoadTable:=Table4;
            Nm := TempSV.SVName + ': '+ DPLabel.Caption +
                  ' ('+DirectUnitLabel.Caption+')';
          end;
     '6': begin
           LoadTable:=Table5;
           If SV.NState=CO2
             then Nm := 'CO2 Equilibria: (mg/L)'
             else Nm := TempSV.SVName + ': '+ NPSLabel.Caption + ' ('+NPSUnit.Caption+')';
          end;
  End;

  Fmt := TFloatField(LoadTable.Fields[1]).DisplayFormat;
  LoadTable.Active:=False;
  If ImportForm.ChangeLoading(Nm,LoadTable,VolumeScreen, Hrly, CType(Sender)) then Changed:=True;
  LoadTable.Active:=True;
  TFloatField(LoadTable.Fields[1]).DisplayFormat := Fmt ;

  Update;
End;


procedure TStateVarDialog.PrintButtonClick(Sender: TObject);
begin
   PrintScale:=PoPrintToFit;
   If MessageDlg('Print Screen?',MTConfirmation,[MBYes,MbNo],0) =MrYes then Print;
end;


procedure TStateVarDialog.SedimentButtonClick(Sender: TObject);
begin
   TempSV.TSSSolids := SolidsButton.Checked;
end;

procedure TStateVarDialog.SetupForm;
begin
  MiddlePosition:=210;
  If Screen.WorkAreaHeight < 601
     then Position := PODesigned
     else Position := POScreenCenter;
end;

procedure TStateVarDialog.NotesEditExit(Sender: TObject);
begin
  TempSV.Notes1:=NotesEdit.Text;
  TempSV.Notes2:=NotesEdit2.Text;
end;

Procedure TStateVarDialog.FracAvailClick(Sender: TObject);
Begin
  If (SV.NState=Phosphate) {Frac Avail Button on Phosphate Screen}
    Then PhosAvailForm.ShowModal
    Else If (TempSV.SVType=SVChemical) then  {Biotransformation Button on Animal Screen}
      Begin
        Application.CreateForm(TBioTransfForm, BioTransfForm);
        BiotransfForm.Changed := BioTransfFormChanged;
        BioTransfForm.ChemName  := TempSV.ChemRecord.ChemName;
        BioTransfForm.BioTrans  := SV.ChemPtrs^[AssocToxTyp(SV.NState)].BioTrans;
        BioTransfForm.SV        := SV.AllStates;
        BioTransfForm.ChemState := SV.NState;
        BioTransfForm.EditBioTransf;
        BioTransfFormChanged := BiotransfForm.Changed;
        BioTransfForm.Free;
      End
    Else {Trohpic Interaction Button on Animal Screen}
      Begin
        Application.CreateForm(TTrophIntForm, TrophIntForm);
        Try
          Application.Createform(TEditTrophIntForm,EditTrophIntForm);
          EditTrophIntForm.AQTStudy := ThisAQTS;
          TAnimal(SV).PTrophInt^ := TempSV.TempTrophInt;
          EditTrophIntForm.EditTrophMatrix;
          If EditTrophIntForm.Changed then
            Begin
              Changed := true;
              TempSV.TempTrophInt := TAnimal(SV).PTrophInt^;
            End;
        Finally
          EditTrophIntForm.Free;
        End;
      End;
End;

procedure TStateVarDialog.CalcPhotoRadioButtonClick(Sender: TObject);
begin
  TempSV.CalcPhotoPeriod := CalcPhotoRadioButton.Checked;
end;

procedure TStateVarDialog.ToxComboBoxChange(Sender: TObject);
Var TableIn: TTable;
    InColl : TCollection;
    i      : Integer;

         Procedure PutInDbase(P: TLoad);
         {Used to put loadings data into TableIn}
         begin
            With TableIn do
               begin
                 Append;
                 Fields[0].AsDateTime:= P.Date;
                 Fields[1].AsFloat:=P.Loading;
                 Post;
                 If (P.Loading>1000) or (P.Loading<0.0001) then
                   Begin
                     TFloatField(Fields[1]).DisplayFormat:='0.0000e-00';
                     TFloatField(Fields[1]).DisplayWidth := 10;
                   End;
               end;
         end;
Begin

 If IsDetrScreen then Exit;

 With TempSV do
  Begin
    if SedScreen
      then
        Begin
          Case LoadType of
            0: LoadingsFromTable(Table2,ToxDynamLoad[CurrentTox]);
            1: LoadingsFromTable(Table2,PSTDL[CurrentTox]);
            2: LoadingsFromTable(Table2,NPSTDL[CurrentTox]);
          End;
        end
      else LoadingsFromTable(Table2,ToxDynamLoad[CurrentTox]);

    If SedScreen then LoadType := LoadingBox2.ItemIndex  {can be selected}
                 else LoadType := 0;  {inflow loadings}
    CurrentTox:=SelTox[WorkingTCB.ItemIndex];

    InColl := nil;
    Case LoadType of
       0: If ToxDynamLoad[CurrentTox] <> nil
            then InColl := ToxDynamLoad[CurrentTox]
            else InColl := ToxPointer[CurrentTox].LoadsRec.Loadings;
       1: If PSTDL[CurrentTox] <> nil
            then InColl := PSTDL[CurrentTox]
            else InColl := ToxPointer[CurrentTox].LoadsRec.Alt_Loadings[PointSource];
       2: If NPSTDL[CurrentTox] <> nil
            then InColl := NPSTDL[CurrentTox]
            else InColl := ToxPointer[CurrentTox].LoadsRec.Alt_Loadings[NonPointSource];
    End; {Case}

    Table2.Active:=False;
    Table2.EmptyTable;
    Table2.Active:=True;

    {Load the Database Data into the Files}
    TableIn:=Table2;
    TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
    If CurrentTox <> NullStateVar then
           With InColl do
             For i:=0 to count-1 do
                PutInDbase(at(i));

    UpdateScreen;
  End;
End;

procedure TStateVarDialog.ToggleButtonClick(Sender: TObject);
begin
  TempSV.ShowingPSLoad:= not(TempSV.ShowingPSLoad);
  UpdateScreen;
end;

procedure TStateVarDialog.MigrationButtonClick(Sender: TObject);
begin
  If MigrForm.EditMigr(LinkedS,ThisAQTS) then changed:=true;
end;

procedure TStateVarDialog.YesButtClick(Sender: TObject);
begin
 TempSV.NoSysStrat := NoButt.Checked;
 UpdateScreen;

end;

procedure TStateVarDialog.HelpButtonClick(Sender: TObject);
begin
  Case SV.NState of
    WindLoading:  HTMLHelpContext('Topic28.htm');
    Light: HTMLHelpContext('Topic29.htm');
    pH:    HTMLHelpContext('Topic30.htm');
    sand..clay: HTMLHelpContext('Topic82.htm');
    Volume:      HTMLHelpContext('Topic31.htm');
    TSS:         HTMLHelpContext('TSS.htm');
    Temperature: HTMLHelpContext('Topic27.htm');
    DissRefrDetr: HTMLHelpContext('Topic18.htm');
    SedmLabDetr,SedmRefrDetr: HTMLHelpContext('Default_Sediment.htm');
    FirstOrgTox..LastOrgTox: HTMLHelpContext('DissOrgToxLoadings.htm');
    Nitrate,Ammonia,Phosphate: HTMLHelpContext('NutrientLoadings.htm');
    else         HTMLHelpContext('Topic17.htm');
  end; {case}
end;

procedure TStateVarDialog.TotN_ICClick(Sender: TObject);
begin  TempSV.TN_IC  :=TotN_IC.Checked; UpdateScreen; end;
procedure TStateVarDialog.TotN_InflowClick(Sender: TObject);
begin  TempSV.TN_Inflow := TotN_Inflow.Checked; UpdateScreen; end;
procedure TStateVarDialog.TotN_PSClick(Sender: TObject);
begin
  TempSV.TN_PS :=TotN_PS.Checked;
  If ShowWarnings and TotN_PS.Checked
    then MessageDlg('Note:  you need to ensure that organic matter '+
     'and detritus are being loaded into the system as a point-source for the computation '+
     'using total point-source nutrients to be correct.',mtinformation,[mbok],0);
end;
procedure TStateVarDialog.TotN_NPSClick(Sender: TObject);
begin  TempSV.TN_NPS :=TotN_NPS.Checked;
  If ShowWarnings and TotN_NPS.Checked
    then MessageDlg('Note:  you need to ensure that organic matter '+
     'and detritus are being loaded into the system as a non point-source for the computation '+
     'using total non point-source nutrients to be correct.',mtinformation,[mbok],0);
end;


procedure TStateVarDialog.OKBtnClick(Sender: TObject);
begin
  OKBtn.SetFocus;
end;

procedure TStateVarDialog.HourlyCBClick(Sender: TObject);
Var hourly: boolean;
    fromstr, tostr: string;
begin
  if DontupdateHCB then exit;

  Hourly := HourlyCB.Checked;
  If hourly then fromstr := 'daily'
            else fromstr := 'hourly';
  If not hourly then tostr := 'daily'
                else tostr := 'hourly';

  If Table1.RecordCount > 0 then
    If MessageDlg('Convert from '+fromstr+' time-step to '+tostr+' time-step?  (Note you '+
                  'will lose any data, you may wish to save your data first.)',
                   mtconfirmation,[mbyes,mbcancel],0) = MRCancel then
       Begin
         DontupdateHCB := True;
         HourlyCB.Checked := Not HourlyCB.Checked;
         DontupdateHCB := False;
         exit;
       End;

  Table1.Active := False;
  If hourly then Table1.TableName := 'loadhour.DB'
            else Table1.TableName := 'loading.DB';
  Table1.EmptyTable;
  Table1.Active := True;

  If hourly then DBGrid1.Left := 30
            else DBGrid1.Left := 85;
  If hourly then DBGrid1.Width := 243
            else DBGrid1.Width := 188;

end;

procedure TStateVarDialog.O2DurationCBClick(Sender: TObject);
begin
   TempSV.O2CalcDuration := O2DurationCB.Checked;
end;

procedure TStateVarDialog.NoO2LoadCBClick(Sender: TObject);
begin
   TempSV.O2NoLoadOrWash := NoO2LoadCB.Checked;
end;

end.

