//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
{*************************}
{****} UNIT Aquaobj; {****}
{*************************}

Interface
uses  Classes, Global, TCollect, SV_IO, Dialogs, SysUtils, Math,
      Progress, Forms, AQSite, Loadings, Functs, Uncert, Observed_data,
      DB, DBTables, Wait, Diagenesis;

Type
  PPStates=^TStates;

  ToxInitCondType  = Array[FirstToxTyp..LastToxTyp] of Double;
  ToxLoadType   = Array[FirstToxTyp..LastToxTyp] of LoadingsRecord;

  THeaderColl=class(TSortedCollection)
     Function KeyOf(Item: Pointer): Pointer; override;
     Function Compare(Key1, Key2: Pointer): Integer; override;
  End;


   TAnimalToxRecord = class(Baseclass)
     Animal_name    : String[20];
     LC50           : Double;
     LC50_exp_time  : Double;
     LC50_comment   : NewRefString;
     Entered_K2     : Double;
     Entered_K1     : Double;
     Entered_BCF    : Double;
     Bio_rate_const : Double;
     EC50_growth    : Double;
     Growth_exp_time: Double;
     EC50_repro     : Double;
     Repro_exp_time : Double;
     EC50_comment   : NewRefString;
     Mean_wet_wt    : Double;
     Lipid_frac     : Double;
     Drift_Thresh   : Double;
     Drift_Comment  : NewRefString;
     Function ObjectID: SmallInt; override;
     Procedure Store(IsTemp: Boolean; Var st: TStream); Override;
     Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
     Procedure WriteText(Var LF: TextFile); override;
   End;

   TPlantToxRecord = class(Baseclass)
     Plant_name     : String[20];
     EC50_photo     : Double;
     EC50_exp_time  : Double;
     EC50_dislodge  : Double;
     EC50_comment   : NewRefString;
     K2             : Double;
     K1             : Double;
     Entered_BCF    : Double;
     Bio_rate_const : Double;
     LC50           : Double;
     LC50_exp_time  : Double;
     LC50_comment   : NewRefString;
     Lipid_frac     : Double;
     Function ObjectID: SmallInt; override;
     Procedure Store(IsTemp: Boolean; Var st: TStream); Override;
     Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
     Procedure WriteText(Var LF: TextFile); override;
   End;


  TResultsCollection = class(TCollection) {of TResults}
      Headers: THeaderColl; {of TResHeader}
      Constructor Init;
      Function GetHeaderIndex(AllSt: AllVariables; Typ: T_SVType; L: T_SVLayer; PPB, ToxVar, RateVar: Boolean; BAFVar: Word; RateIndex: Integer): Integer;
      Function CreateHeader  (AllSt: AllVariables; Typ: T_SVType; L: T_SVLayer; PPB, ToxVar, RateVar : Boolean; BAFVar: Word; RtIndx: Integer;
                                 SV: PPStates;    G_SqM: Boolean;    PointIndex: Integer; RateStr: String): Integer;
      Function GetResIndex(Date: TDateTime; Hourly: Boolean): Integer;
      Function GetState(AllSt: AllVariables; Typ: T_SVType; L: T_SVLayer;
                        PPB, ToxVar, RateVar : Boolean; BAFVar: word; RateIndex: Integer; Date:TDateTime; Hourly: Boolean): Double;
      Procedure Store(IsTemp: Boolean; Var st: TStream); override;
      Constructor Load(IsTemp: Boolean; Var st: TStream; ReadVersionNum: Double);
      Function ObjectID: SmallInt; override;
      Destructor Destroy; override;
  End;

  ResultsType  = Array[VerticalSegments] of TResultsCollection;

  BioTransType = (BTAerobicMicrobial,BTAnaerobicMicrobial,BTAlgae,BTBenthInsect,BTOtherInvert,BTFish,BTUserSpecified);

  TBioTransObject = Class(Baseclass)
      BTType   : BioTransType;
      UserSpec : AllVariables;
      Percent  : Array[FirstOrgTxTyp..LastOrgTxTyp] of Double;
      Constructor Init(BT: BioTransType; US: AllVariables);
      Procedure Store(IsTemp: Boolean; Var st: TStream); Override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Function ObjectID: SmallInt; override;
      Procedure WriteText(Var LF: TextFile); override;
   End;

  TChemical = class(Baseclass)
      ChemRec               : ChemicalRecord;
      Kow, HenryPA, Tox_Air : Double;
      Anim_Tox, Plant_Tox   : TCollection;
      BioTrans              : TCollection;
      Anim_Method, Plant_Method: UptakeCalcMethodType;
      constructor Init;
      procedure ChangeData;
      {ChangeData MUST be called when the underlying data record is changed}
      function WEfftox(nondissoc:double): Double;
      Procedure Store(IsTemp: Boolean; Var st: TStream); Override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Function DBase_To_AnimToxColl (DbDir,DbName: ShortString):Boolean;
      Function AnimToxColl_To_Dbase (DbDir,DbName: ShortString):Boolean;
      Function DBase_To_PlantToxColl(DbDir,DbName: ShortString):Boolean;
      Function PlantToxColl_To_Dbase(DbDir,DbName: ShortString):Boolean;
      Function Get_BioTrans_Record  (BT: BioTransType; US: AllVariables):TBioTransObject;
      Destructor Destroy; OverRide;
      Procedure WriteText(Var LF: TextFile); override;
   end;

  PMultiAgeInput = ^MultiAgeFishInput;

  PChemArray = ^ChemArray;
  ChemArray =  Array[FirstOrgTxTyp..LastOrgTxTyp] of TChemical;

  TStates=class(TSortedCollection)
     Location      : TAQTSite;           {Pointer to Site}
     Chemptrs      : PChemArray;          {Pointer to Array of Pointers to Chemical Records}
     SetupRec      : PSetup_Record;       {Pointer to user choices record}
     MeanDischarge : Double;
     MeanVolume    : Double;              {nosave}
     Results       : ResultsType;
     ControlResults: ResultsType;
     MemLocRec     : TMemLocRec;          {Array of pointers to SV loc in memory}
     HypoSegment   : TStates;             {If Stratification then state variables are
                                           split, hypolimnion collection stored here}
     EpiSegment    : TStates;             {Pointer back to Epilimnion within Hypolimnion Segment}
     ThermLink, ThermLink2  : Pointer;    {In Stratified Linked Mode, Pointer to Link(s) between Epi and Hypo}
     LastWellMixedTime : Double;
     LastWellMixedCalc : Boolean;
     VSeg          : VerticalSegments;    {In Which segment is this collection, epi or hypo}
     HypoTempIC    : Double;              {Init Cond of Hypo Temperature}
     HypoTempLoads : LoadingsRecord;      {Hypolimnion Temperature User Entered Loadings}

     Sed_Data      : Sediment_Data_Rec;   {Holds data for sediment calculations, no need to save or load}
     WaterVolZero  : Boolean;             {Is Water Volume Zero?  no need to save or load}

     Shade         : LoadingsRecord;      {Shade Data}
     Z_Thermocline : LoadingsRecord;      {Thermocline Depth}
     CalcVelocity  : Boolean;
     DynVelocity   : TLoadings;

     VertDispersionCalcDate,
     OldVertDispersionVal : Double;       {Allows removal of redundant VertDispersion Calculations}

     Distributions : TDistributionList;      {uncertainty distributions:  if template-global; if segment-seg data}

     PRateInfo : PRateInfoType;           {rate specifications}
     WriteTable, HypTable : TTable;       {table rates are written to}
     PControlInfo: PControl_Opt_Rec;      {control run specifications}
     PMultiRec  : PMultiAgeInput;         {pointer to input record for multi-age fish}
     PSavePPB  : PBoolean;                {Save PPB data with results?}
     PSaveBAFs : PBoolean;                {Save BAF data with results?}

     Diff:     Array[FirstToxTyp..LastToxTyp] of Double; {normalized rate differences for uptake, nosave}
     PoreDiff: Array[FirstToxTyp..LastToxTyp,SedLayer1..LowestLayer] of Double; {normalized rate differences for uptake by layer, nosave}

     LastCalcEstVel, LastTimeEstVel: Double; {Optimization of Estuary velocity calculation, nosave}
     MeanEstVel:       Double;    {Mean Estuary Velocity, nosave}
     Stratified:       Boolean;   {Is system stratified? , nosave}
     Anoxic:           Boolean;   {Is System Anoxic , nosave}

     FirstExposure:    Array[FirstToxTyp..LastToxTyp] of Double;  {First exposure to organic toxicant, nosave}
                                                                  {If Stratified, FirstExposur Array saved in epilimnion}

     Graphs                      : TGraphs;
     ObservedData                : TObservedData;
     UseExternalConcTox          : Boolean;

     DerivStep: Integer;             {Current Derivative Step 1 to 6, Don't save in Storload}
     Volume_Last_Step: Double;       {Volume in the previous step, used for calculating dilute/conc,  if stratified, volume of whole system (nosave)}
     VolFrac_Last_Step: Double;      {Fraction of volume in epilimnion in previous step, used if z_thermocline changes to ensure mass balance (dilute conc), nosave}
{     Thick_Last_Step,                {Thickness in the previous step of given layer, used for Estuaries only}
     Last_Non_Zero_Vol: Double;      {Used in dilute/conc to ensure no problems when volume is zeroed out}
     Water_Was_Zero: Boolean;        {  "                         "                   "                  }
     PWVol_Last_Step: Array[SedLayer1..LowestLayer] of Double;  {PW_Volume in the previous step (nosave)}
          
     Last_Datapoint_Written,{What was the timestamp on the last datapoint written?}
     Last_Results_Written   {When was the last time TRESULTS was updated} : Array[Epilimnion..Hypolimnion] of TDateTime;
     ModelStartTime:   Double;  {Start of model run}
     YearNum_PrevStep: Integer; {The year number during the previous step of the model run
                                 used to determine when a year has passed}
     StudyProgDlg      : TProgressDialog;

     {DATA FOR THREADSAFE OUTPUT DURING SIMULATION RUN}
     UpdateProg        : TMethdProc;
     ProgData          : PProgDataRec;
     TSMessage         : TMethdProc;
     PMessageStr       : PString;
     PMessageErr       : PBoolean;

     {LINKED MODE VARIABLES}
     PStatesTemplate: TStates;       {Points to the Template TStates if Linked, otherwise points to self}
     PAllSVsColl: Pointer;           {Points to the TCollection with all SVs in it}
     PSegID: PSegIDString;           {Points to the Unique Segment ID of the study in linked mode}
     In_FB_Links, Out_FB_Links: TCollection;  {Collections of In and Out Feedback Links in linked Mode, set before study run}
     In_Cs_Links, Out_Cs_Links: TCollection;  {Collections of In and Out Cascade Links in linked Mode, set before study run}
     IsTop_Cs_Seg  : Boolean;        {Is this a top Cascade segment?  If so, it executes first}
     VolumeUpdated : TDateTime;      {When was the last time inflow/discharge was updated for this segment}
     IsCascadeSeg  : Boolean;        {Is this segment to be run seperately}
     IsUpperCS     : Boolean;        {Is this segment run before or after feedback segments?}
     CS_Executed   : Boolean;        {Has this cascade link executed yet in this study run?}
     Linked_FB_Seg : Boolean;        {Used to determine if all FB segments are linked together}
     RateFileInit  : Boolean;        {Is rate file initialized for this segment?}
     IsStrat, IsEpilimnion: Boolean; {Is this segment part of a stratified pair?  If so, which part? saved}

{     IncrTemp             : Boolean;      {true: temperature is increasing}
     StoreResults         : Boolean;      {lets TStates.Store know whether to store results}
     StoreDistribs        : Boolean;      {lets TStates.Store know whether to store distributions data}

     {Variables to keep track of time}
     TPresent:         Double;  {Current Time in TDATETIME format, set in DERIVS }
     TPreviousStep:    Double;  {Time of the previous step, set in DOTHISEVERYSTEP}
     PModelTimeStep:    PTimeStepType;     {Hourly or Daily Time-Step   Note, question about template.}

     {Nutrient / Mass Balance Data}
     MBLossArray  : Array[Nitrate..Phosphate] of MBLossRecord;   {track Nutrient loss, nosave}
     MBLoadArray  : Array[Nitrate..Phosphate] of MBLoadRecord;   {track Nutrient loads, nosave}
     MBLayerArray : Array[Nitrate..Phosphate] of MBLayerRecord;  {track Nutrient layer int., nosave}
     Diag_Track   : Array[TSP_Diag..PON_Dep] of MBTrackArray;  {track passage of nutrients to wc from diagenesis layers}
     GPP, NPP, TOTResp : MBTrackArray;

     {Linked System Morphometry}
     AutoCalcXSec  : Boolean;        {Is XSec to be calculated (using volume and SiteLength)?}
     XSecData      : TLoadings;      {Otherwise it is taken from this dynamic input source}

     {Sediment Sub-Model Data}
     SedLayers     : Integer;        {Number of sed layers in system 1..10, or 0 if no sed modeling}
     SedNonReactive: Boolean;
     SedData       : Array[1..10] of BedRecord; {Sediment Data, I.C., etc.}
     Densities     : Array[Cohesives..SedmLabDetr] of Double; {Densities of elements of the sediment bed, saveme}
     UseSSC        : Boolean;        {UseSandSiltClay with Multi-Layer formulation? saveme}              
     MaxUpperThick : Double;         {Maximum thickness of the top sediment layer, saveme}
     BioTurbThick  : Double;         {Layer at which bioturbation takes place and min. thick of top sed layer, saveme}
     HardPan       : Integer;        {Layer at which hardpan barrier starts,  (nosave)}
     OOSStack      : TCollection;    {Where layers buried "out of the system" are stored}
     InitL2Dens    : Double;         {The initial density of the second layer}
     L1AimDens     : Double;         {The density of the top layer.  Needs separate tracking because of hardpan behavior}
     InitMeanThick : Double;         {init mean thickness of layer upon stratification}
     BaseTopDepth  : Double;         {Depth of the top layer with respect to the initial condition elevation of the top layer }
                                     {(helps keep track of overall erosion vs deposition) (nosave)}

{    LastCascLoad  : Double;         Time when last cascade loading was added to TSTATES, Destroy once per day NO LONGER RELVANT}
     MigrateDate, AnadromousDate   : Double;         {Date when last migration occured... occurs every day (nosave)}
     BenthicArea   : Double;         {benthic area when strat occurs}

     {Toxicant Fate / Mass Balance Data}
     ToxLossArray  : Array[FirstOrgTxTyp..LastOrgTxTyp] of ToxLossRecord;  {track toxicant loss, nosave}
     ToxLoadArray  : Array[FirstOrgTxTyp..LastOrgTxTyp] of ToxLoadRecord;  {track toxicant loads, nosave}
     ToxLayerArray : Array[FirstOrgTxTyp..LastOrgTxTyp] of ToxLayerRecord; {track toxicant layer int., nosave}

     EstuarySegment : Boolean;    {Is this segment set up as an estuary?}

     GullPref : TrophIntArray;                                        {Save}
     GullBMF  : Array[FirstOrgTxTyp..LastOrgTxTyp] of Double;         {Save}
     GullRef  : Array[FirstOrgTxTyp..LastOrgTxTyp] of Refstring;      {Save}
     BirdPrey : TCollection; {NoSave, used to hold normalized gull preferences}
     GullClear  : Array[FirstOrgTxTyp..LastOrgTxTyp] of Double;       {Save}
     GullClearRef : Array[FirstOrgTxTyp..LastOrgTxTyp] of Refstring;  {Save}
     GullConcLastStep : Array[FirstOrgTxTyp..LastOrgTxTyp] of Double; {noSave}
     TimeLastGullConc : Double;                                       {nosave}

     TimeLastInorgSedAvg : Array[False..True] of TDateTime;           {nosave}
     LastInorgSedAvg     : Array[False..True] of Double;              {nosave}

     UseConstZMean  : Boolean;
     DynZMean       : TLoadings;

     UseConstEvap   : Boolean;
     DynEvap        : TLoadings;

     LinkedMode, CascadeRunning : Boolean;   {Keep track of type of simulation running}

     PO2Concs   : TCollection; {time history of o2 concs}
     PSedConcs  : TCollection; {time history of Susp Inorg. Sed concs}
     PLightVals : TCollection; {time history Light concs}

     EstuarySaltLoads: EstSaltLoadingRec;  {Temporally Constant Salt Water Loads}

     {Diagenesis Parameters}
     Diagenesis_Params : PDiagenesis_Rec;
     SOD : Double;  {SOD, calculated before derivatives}
     Diagenesis_Steady_State: Boolean;

     LastPctEmbedCalc, PercentEmbedded : Double; {0-100% embedded}

     {Uncertainty Methods}
     Function  Ice_Cover_Temp : Double;
     Procedure Update_Distributions;
     Procedure DestroyResults(Control: Boolean);
     Function  Return_Registered_Dist(Index: Integer): Registered_Distribution;
     Function  Return_Var_Pointer(Index: Integer; ID: SV_ID; ToxRec: String): PDouble;

     Constructor init(A,B : word; aL : TAQTSite; aC : PChemArray; aSR : PSetup_Record;
                      aDR: PDiagenesis_Rec;PST: TStates; AllSVs: Pointer);
     Destructor Destroy; override;
     Function  KeyOf(Item: Pointer): Pointer; override;
     Function  Compare(Key1, Key2: Pointer): Integer; override;

     Procedure ChangeData;
     Function  DynamicZMean: Double;  {variable zmean of seg. or entire system if stratified}
     Function  StaticZMean: Double;   {init. cond. zmean of seg. or entire system if stratified}
     Function  SegVol: Double;        {volume of segment or individual layer if stratified}
     Function  SurfaceArea: Double;   {Surface area of segment or individual layer if stratified}
     Function  SedLayerArea: Double;
     Function  InorgSedConc(WeightedAvg: Boolean): Double;  {inorganic seds in mg/L}
     Function  InorgSed60Day(MustHave60: Boolean): Double;  {60 day running average of inorganic seds, mg/L}
     Function  MaxEpiThick: Double;
     Function  Velocity(PctRiffle,PctPool:Double; Averaged: Boolean): Double;
     Function  PhytoResFactor:  Double;
     Function  ThermoClArea: Double;
     Function  CalcitePcpt: Double;   {calcite precipitation, mg/L d}

     Function  GetIndex(S: AllVariables;  T: T_SVType; L: T_SVLayer) : integer;
     Function  GetIndexFromName(S : ShortString) : integer;
     Function  GetState(S: AllVariables;  T: T_SVType; L: T_SVLayer) : double;
     Function  GetStatePointer(S: AllVariables;  T: T_SVType; L: T_SVLayer) : pointer;
     Function  GetStatePointerFromName(S : ShortString) : pointer;

     Function  GetLoad(S: AllVariables;  T: T_SVType; L: T_SVLayer) : double;
     Function  OrgTox_In_System : Boolean;
     Function  NumOrgToxicants: Integer; {num toxicants in SV List}
     Function  GetPPB(S: AllVariables;  T: T_SVType; L: T_SVLayer): double;   virtual;

     Procedure Check_Stratification;
     Procedure Overturn(StudyDestroy: Boolean);
     Procedure GetTemperatures(Var TempEpi,TempHypo: Double);
     Procedure UpdateSedData;
     Procedure SetInitHardPan;
     Procedure PushLayerOnStack;
     Procedure PopLayerOffStack;

     Procedure CopyLayer(FromLayer,ToLayer:T_SVLayer);
     Function  SedModelIncluded: Boolean;  {is the multi-layer sed model included?  Not diagenesis}
     Function  InorgSedDep(InclSand: Boolean): Double; {Inorg Sed Deposited by either sand-silt-clay or multi-layer sed model in kg/m2 d}
     Procedure NormDiff(Step: Double);

     Function UniqueName(S: AllVariables) : String;
     Function Convert_g_m2_to_mg_L(S: AllVariables;  T: T_SVType; L: T_SVLayer): Boolean;
     Function  OutputState(Ns: AllVariables; Typ: T_SVType; L: T_SVLayer; Val: Double): Double;  {Convert state variable from internal "native units" to output units}
     Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
     Constructor Load(LinkedM,IsTemp: Boolean; st: Tstream; ReadVersionNum: Double; LoadResults, LoadDistribs: Boolean);
     Procedure DoThisEveryStep(hdid: Double);  {Designed to perform model manipulations that are required after each complete model step}
     Procedure CalculateAllLoads(TimeIndex : double);
     Procedure SetMeanDischarge(TimeIndex: double);
     Procedure SetStateToInitConds(INIT_RISK_CONC: Boolean);
     Procedure SetMemLocRec;
     Procedure Zero_Utility_Variables;
     Procedure ClearMBData(StartLoop: Integer);
     Procedure ProcessMBData(hdid: Double);
     Procedure OverturnMBData;
     Procedure CopyMultiFishData;
     Procedure CopySuspDetrData;
     Procedure CombineTopTwoLayers;
     Procedure SplitTopLayer;
     Procedure ZeroBottomLayer;
     Procedure CalculateSumPrey;

     Function  CalculateTElapsed(Tox: T_SVType):Double;

        {***  Process Equations  ***}
     Function TCorr(Q10, TRef, TOpt, TMax : double) : double;
     Procedure CalcPPB;

     Function Extinct(Incl_Periphyton,Incl_BenthicMacro,Incl_FloatingMacro, IsSurfaceFloater, WeightedAvg: Boolean) : double;
     Function ZEuphotic: Double;
     Function DepthTop   : double ;
     Function WellMixed: Boolean;     
     Function Photoperiod: double ;
     Function CalcVertDispersion: Double;
     Function  ManningCoeff: Double;
     Procedure CalcHRadius(Averaged:Boolean);
     Procedure Update_Sed_Bed(timestep: Double);

     Function DensityFactor(KSTemp,KSSalt: Double): Double;
     Function SalEffect(Min,Max,Coeff1,Coeff2: Double): Double;

     {Diagenesis Model}
     Function  Diagenesis_Included: Boolean; {Is diagenesis model included}
     Function  DiagenesisVol(Layer: Integer): Double; {vol of sed bed in m3}
     Function  MassTransfer : Double; {"s" in m/d}
     Function  CalcDeposition(NS:AllVariables; Typ: T_SVType): Double;  {Calc deposition input into diagenesis model}
     Procedure CalculateSOD; {Iterative Solution Scheme to calculate SOD before derivatives are solved}
     Function  Diagenesis_Detr(NS: AllVariables): Double; {quantity of sedimented detritus in diagenesis model in mg/L(wc)}

     Procedure WriteCascadeWashout(TimeIndex:TDateTime; hdid: Double);
(*     Procedure Add_Cascade_Washin(TimeIndex: Double); {Add washin from upper cascade links now inside derivs}  *)
     Function  GetPStatesFromID(ID: SegIDString): TStates; {find another segment}
(*     Procedure Delta_Estuary_Thick;  {Move state variables and modify concentration when stratification thickness changes} *)

     Procedure WriteResults(TimeIndex: TDateTime; SaveStep: Double; LastPoint: Boolean; hdid: Double);
     Procedure Count_Num_RateFiles(Var NumFiles, Num_Rates_Per_File, RCount: Integer);
     Procedure WriteText(Var LF: TextFile); override;
  end;


   TStateVariable= Class(Baseclass)
      InitialCond: double;           {Initial condition}
      State      : double;           {Current Value, usually concentration}
      NState     : AllVariables;     {List of Organisms and Toxicants}
      SVType     : T_SVType;         {StV, OrgTox}
      Layer      : T_SVLayer;        {Relevant for sed detr, inorg sed., and pore water types}
      PName      : PNameString;      {Text Name}
      AllStates  : TStates;          {Pointer to Collection of State Variables of which I am a member}

      LoadsRec   : LoadingsRecord;   {Holds all of the Loadings Information for this State Variable}
      Loading    : double;           {Loading of State Variable This time step}

      PRequiresData, PHasData: PBoolean; {If RequiresUnderlyingData and Not HasData then Model cannot be run}
      StateUnit,LoadingUnit: String[10]; {Units for display in EDSTATEV}

      yhold      : double;           {holds State value during derivative cycle}
      yorig      : double;           {used to restore state to beginning of time step}
      yout       : double;           {use in Integration}
      StepRes    : Array[1..6] of Double; {Holds Step Results}
      yerror     : double;           {holds error term from RKCK}
      yscale     : double;           {use in Integration}

      Location   : TAQTSite;        {Pointer to Site in which I'm located}
      Chemptrs   : PChemArray;       {Pointer to Array of Pointers to Chemical Records}

      PShowRates : PBoolean;         {Does the user want rates written for this SV?}
      RateColl   : TCollection;      {Collection of saved rates for current timestep}
      RateIndex  : Integer;          {current indexing of rates writing}

      LoadNotes1,
      LoadNotes2 : String[50];       {Notes associated with loadings}

      PTrackResults: PBoolean;       {Does the user want to save results for this variable?}

      IsTemplate: Boolean;           {Is this a member of the template study in a linked system?  True if single study run.}

      WashoutStep: Array[0..6] of Double; {Saved Washout Variables for use in outputting Cascade Outflow, nosave}
      WashoutAgg, LastTimeWrit :  Double; {Aggregate washout so far this day (Cascade Outflow), Date of last cascade data writing nosave}

      constructor init(Ns :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      destructor Destroy; Override;

      Procedure UpdateUnits;

      Procedure  Derivative(var DB: double); virtual;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Procedure Store(IsTemp: Boolean; Var St: Tstream); Override;
      Procedure Load_Loadings (IsTemp: Boolean; Var Ld: LoadingsRecord; Var St: Tstream; ReadVersionNum: Double);
      Procedure Store_Loadings(IsTemp: Boolean; Var Ld: LoadingsRecord; Var St: Tstream);

      Function ObjectID: SmallInt; override;

      Function  GetPPB(S: AllVariables;  T: T_SVType; L: T_SVLayer): double;   virtual;
      Function GetInflowLoad(TimeIndex : Double): Double; virtual;
      Procedure CalculateLoad(TimeIndex : double); virtual;
      Function  GetState(S: AllVariables;  T: T_SVType; L: T_SVLayer) : double;
      Function  GetStatePointer(S: AllVariables;  T: T_SVType; L: T_SVLayer) : pointer;

      Function WetToDry: Double; virtual;
      Function StratMigration     : Double;
      Function CanMigrate         : Boolean;
      Function Decomposition(DecayMax, KAnaer : double; Var FracAerobic: Double) :double;  {Relevant for tox in water, tox in detritus, and labile detritus}
      Function TurbDiff           : Double;  {Turb Diff for a given zone}
      Function SegmentDiffusion(UpLinks: Boolean): Double;
      Function Washout            : Double; virtual;
      Function Washin             : Double; virtual;

      Function  EstuaryEntrainment : Double;  {entrainment for suspended variables}

      Function NutrToOrg(S: AllVariables): Double;

      Function IsAnimal        : Boolean;
      Function IsMacrophyte    : Boolean;
      Function IsPlant         : Boolean;
      Function IsAlgae         : Boolean;
      Function IsInvertebrate  : Boolean;
      Function IsFish          : Boolean;
      Function IsSmallFish     : Boolean;
      Function IsPlantOrAnimal : Boolean;

      Procedure ClearRate;
      Procedure SaveRate(Nm: String; Rt: Double);
      Procedure WriteText(Var LF: TextFile); override;
   end;

   VolumeMethType = (Manning,KeepConst,Dynam,KnownVal);
   FlowType = (FTEpi,FTHyp,FTBoth);

   TVolume=class(TStateVariable)             
     LastCalcTA, LastTimeTA: Double; {don't need saving}
     Inflow, Discharg : Double;      {don't need saving}
     InflowLoad, DischargeLoad, KnownValueLoad, OOSDischFracLoad, OOSInflowFracLoad: Double; {don't need saving}
     Calc_Method : VolumeMethType;
     StratInflow, StratOutflow: FlowType;
     StratAutomatically: Boolean;
     StratDates : TLoadings;

     Constructor Init(Ns : StateVariables; Typ: T_SVType; aName : ShortString; P : TStates;
                      IC : double; IsTempl: Boolean);
     Procedure   CalculateLoad(TimeIndex : Double); override;
     Procedure   CalculateLinkedDischarge(TimeIndex : double);
     Procedure  Calculate_Linked_Inflow(TimeIndex : double);
     Function    ObjectID: SmallInt; override;
     Function    Manning_Volume: Double;

     Function    ResidFlow: Double;
     Function    FracUpper: Double;
     Function    FreshwaterHead: Double;
     Function    TidalAmplitude(TimeIndex: TDateTime): Double;
     Function    SaltWaterInflow: Double;
     Function    UpperOutflow: Double;

     Function    Evaporation: Double;
     Function    VolFrac(Z, ZMx, P : double) : double;
     Procedure   Derivative(var DB: double); override;
     Procedure   DeltaVolume;  {calculations required when volume has changed}
     Procedure   Store(IsTemp: Boolean; Var st: Tstream); override;
     Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
     Procedure WriteText(Var LF: TextFile); override;
     Destructor Destroy; override;
   end;


   TSandSiltClay = class(TStateVariable)
      FracInBed: Double; {fraction of sediment in bed sediments}
      Frac_Silt_Scour, Frac_Silt_Dep: Double;
                         {relevant to silt only, for use in burial}
      Deposition : Double;   {Does not need saving}
      TSS_Solids : Boolean;  {Does TSS Represent Solids (true) or Sediments}
{      Function  Viscous: Double; }
      Function Scour_Sand : Double;
      Function Scour_And_Dep : Double;
      Procedure Update_Sed_Data;
      Function Washout: Double; override;

      Procedure Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;

      Constructor Init(Ns : StateVariables; SVT: T_SVType; Lyr: T_SVLayer; aName : ShortString; P : TStates;
                       IC : double; IsTempl: Boolean);
      Procedure   Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; st: Tstream; ReadVersionNum: Double);
      Function    ObjectID: SmallInt; override;
      Procedure WriteText(Var LF: TextFile); override;
   end;


   TSuspSediment = class(TStateVariable)

      Procedure Derivative(var DB: double); override;
      Constructor Init(Ns : StateVariables; SVT: T_SVType; L: T_SVLayer; aName : ShortString; P : TStates;
                       IC : double; IsTempl: Boolean);
      Destructor  Destroy; override;
      Procedure   Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Procedure   CalculateLoad(TimeIndex : Double); override;
      Function    ObjectID: SmallInt; override;
   end;

   TOOSLayer = class(Baseclass)
     Data: Array[1..1000] of Double;
   End;


   TBottomSediment = class(TStateVariable)
      LScour,LDeposition : LoadingsRecord;  { Hold User Input when relevant -- (NState in [Cohesives..NonCohesives2]) and (Layer=SedLayer1)}
      ScourLoad, DepLoad : Double;          { Current Scour and Dep Load                      }
      Constructor Init(Ns : StateVariables; SVT: T_SVType; L: T_SVLayer; aName : ShortString; P : TStates;
                       IC : double; IsTempl: Boolean);
      Destructor  Destroy; override;
      Procedure   Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Function    Scour: Double;
      Function    Deposition: Double;
      Function    CalcBedLoad: Double;
      Function    CalcBedLoss: Double;
      Procedure   Derivative(var DB: double); override;
      Procedure   CalculateLoad(TimeIndex : Double); override;
      Function    ObjectID: SmallInt; override;
      Procedure WriteText(Var LF: TextFile); override;
   End;

   TBottomCohesives = class(TBottomSediment)
      LErodVel,LDepVel : LoadingsRecord;  { Hold User Input when relevant -- (NState in [Cohesives..NonCohesives2]) and (Layer=SedLayer1)}
      EVel, DVel : Double;                { Current erode and depositional velocities }
      Constructor Init(Ns : StateVariables; SVT: T_SVType; L: T_SVLayer; aName : ShortString; P : TStates;
                       IC : double; IsTempl: Boolean);
      Destructor  Destroy; override;
      Procedure   CalculateLoad(TimeIndex : Double); override;
      Procedure   Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Function    ObjectID: SmallInt; override;
      Procedure WriteText(Var LF: TextFile); override;
   End;

   {Buried sedlabdetr and sedrefrdetr for the sand-silt-clay model}
   TBuriedDetr1 = class(TStateVariable)
      TotalScour {kg/m3}, Frac_Sed_Scour, Frac_Buried_Scour, BuriedDetr_To_Sed {kg/m3}: Double;
      TotalDep {kg/m3}, Frac_Dep_ToSed, Frac_Dep_ToBuried,   SedDetr_To_Buried {mg/L}: Double;
      {These vars return data about scour and deposition, no saving needed}
      Procedure CalcTotalScour;
      Procedure CalcTotalDep;
      Procedure Derivative(var DB: double); override;
      Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; st: Tstream; ReadVersionNum: Double);
      Procedure   CalculateLoad(TimeIndex : Double); override;
      Constructor Init(Ns : StateVariables; SVT: T_SVType; Lyr:T_SVLayer; aName : ShortString; P : TStates;
                           IC : double; IsTempl: Boolean);
      Function ObjectID: SmallInt; override;
   end;


   {Buried sedlabdetr and sedrefrdetr for the Multi-Layer model}
   TBuriedDetr2 = class(TStateVariable)
      Procedure Derivative(var DB: double); override;
      Procedure   CalculateLoad(TimeIndex : Double); override;
      Constructor init(Ns : StateVariables; SVT: T_SVType; Lyr:T_SVLayer; aName : ShortString; P : TStates;
                           IC : double; IsTempl: Boolean);
      Function ObjectID: SmallInt; override;
   end;


   TTemperature=class(TStateVariable)
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
   end;

   TpHObj=class(TStateVariable)
      Alkalinity: Double;
      Constructor init(Ns : StateVariables; SVT: T_SVType; Lyr:T_SVLayer; aName : ShortString; P : TStates;
                           IC : double; IsTempl: Boolean);
      Procedure Store(IsTemp: Boolean; Var st: TStream); override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
      Procedure WriteText(Var LF: TextFile); override;
   end;

   TWindLoading=class(TStateVariable)
      MeanValue: Double;
      Constructor Init(Ns :StateVariables; SVT: T_SVType; Lyr: T_SVLayer; aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
      Procedure WriteText(Var LF: TextFile); override;
   end;

   TLight=class(TStateVariable)
      CalculatePhotoperiod : Boolean;
      UserPhotoPeriod      : Double;
      DailyLight, HourlyLight : Double;
      Constructor Init(Ns :StateVariables; SVT: T_SVType; Lyr: T_SVLayer; aName :ShortString; P :TStates; IC :double;IsTempl: Boolean);
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
      Procedure Store(IsTemp: Boolean; Var st: Tstream); override ;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Procedure WriteText(Var LF: TextFile); override;
   end;

   TPreference = class(Baseclass)
      Preference, EgestCoeff  : Double;
      nState                  : StateVariables;
      constructor init(nP, nE : Double; nS : StateVariables);
      Procedure Store(IsTemp: Boolean; Var st: Tstream); Override ;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Function ObjectID: SmallInt; override;
      Procedure WriteText(Var LF: TextFile); override;
   end;

   TOrganism=class(TStateVariable)
      LCInfinite,                    {Calculated from BCF, LC50, TObsElapsed}
      OrgToxBCF,                     {Save BCF for FCM Calc, (nosave)}

      PrevFracKill, Resistant    : Array[FirstOrgTxTyp..LastOrgTxTyp] of Double;
      DeltaCumFracKill, DeltaResistant : Array[FirstOrgTxTyp..LastOrgTxTyp,1..6] of Double;
                                         {Toxicity Tracking Variables}
      AmmoniaPrevFracKill, AmmoniaResistant          : Array[false..true] of Double; {boolean reflects ionized status}
      AmmoniaDeltaCumFracKill, AmmoniaDeltaResistant : Array[false..true,1..6] of Double; {Ammonia EFfects Tracking Variables}

      SedPrevFracKill, SedResistant          : Double;
      SedDeltaCumFracKill, SedDeltaResistant : Array[1..6] of Double; {Susp. Sediment EFfects Tracking Variables}


      RedGrowth, RedRepro, FracPhoto       : Array[FirstOrgTxTyp..LastOrgTxTyp] of Double;  {Chronic Effects}
      Function  GutEffOrgTox(ToxTyp: T_SVType) : double;
      constructor init(Ns :StateVariables; SVT: T_SVType; aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      Function  BCF(TElapsed: Double; ToxTyp: T_SVType): Double; virtual;  {Bioconcentration factor, KB}
      Function  Respiration    : double ; virtual;
      Procedure CalcRiskConc(warn: Boolean);
                {CalcRiskConc was reworked to be run at the beginning of model
                 run rather than each time step. (JSC Apr 5, 1996)}

      Function  Poisoned(ToxTyp: T_SVType) : double; virtual;
      Function  Predation      : double;
      Function  Mortality      : double ; virtual;
      Function  SinkFromEp     : double ;
      Function  SalMort(Min,Max,Coeff1,Coeff2: Double): Double;            

      Function ObjectID: SmallInt; override;
      Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Procedure CalculateLoad(TimeIndex : Double); override;
   end;

   PAgeDist = ^AgeDist;
   AgeDist = Packed Record
               UserDefined: Boolean; {User defined values, or use distribution?     }
               DType: TDistType;     {Triangular, lognormal, etc. if not UserDefined}
                  f1,f2: Byte; {d4-5}
               Parm : Array[1..4] of Double;
                                     {Parameters that describe the distribution     }
               Vals: Array[1..15] of Double;
                                     {Values of distribution or user defined vals.  }
               LoadNotes1, LoadNotes2: String[50]; {Notes associated with loadings  }
                  f3,f4: Byte; {d4-5}
             End; {AgeDist}

   ChemDist = Array[FirstOrgTxTyp..LastOrgTxTyp] of AgeDist;


   MultiAgeFishInput =
     Packed Record
       PNumAges : PInteger;   {number of age classes tracked}
       PSpawnAge: PDouble;    {Age at which spawning commences}
       PName    : PRefString; {User given Name}
       InitCond : AgeDist;    {initial condition input}
       Loadings : AgeDist;    {fish loadings input}
       ChemIC   : ChemDist;   {chemical initial condition input}
       ChemLoad : ChemDist;   {chemical loadings input}
       PLipidFrac:  PAgeDist; {distribution of lipid fraction}
       PMortCoeff:  PAgeDist; {mortality coefficients by age}
       PMeanWeight: PAgeDist; {mean wet weight by age}
     End;

   MortRatesRecord= Record  {not saved to disk}
                      OrgPois: Array[FirstOrgTxTyp..LastOrgTxTyp] of Double;
                      O2Mort,NH4Mort,NH3Mort: Double;
                      OtherMort: Double;
                      SaltMort: Double;
                      SedMort : Double;
                    end;

   MigrationInputRec = Packed Record
                         FracMigr: Double;
                         ToSeg   : SegIDString;
                         f1,f2,f3: Byte; {D4-2006}
                         MM,DD   : Integer;
                       End;
   MigrInputType = Array[1..5] of MigrationInputRec;

   AnadromousInputRec = Packed Record
                           IsAnadromous: Boolean;
                           YearsOffSite, DateJuvMigr, DateAdultReturn: Integer;
                           FracMigrating, MortalityFrac : Double;
                         End;

   AnadromousDataRec = Packed Record
                            Concs: Array[FirstOrgTxTyp..LastOrgTxTyp] of Double;  {chemical masses departing in ug/L}
                            Biomass: Double;  {fish concentrations departing in mg/L}
                         End;


   TAnimal  =   class(TOrganism)
      PAnimalData:  PZooRecord;
      PTrophInt  :  PTrophIntArray; {Eating Preferences and Egestion Coefficients}
      MyPrey     :  TCollection;    {Things I Eat}
      CalcLipid  :  Double;         {calculated lipid content, relevant to fish only}
      Spawned    :  Boolean;        {Has this species spawned already, within the correct temp range}
      SpawnTimes :  Integer;        {how many times has this species spawned since midwinter?}
      AnadRec    :  AnadromousInputRec; {If size class anadromous, this is relevant}

      PromSmFish:   Double;  {SmFish subject to promotion (nosave)}
      EmergeInsect: Double;  {insects subject to emergence (nosave)}
      Recruit:      Double;  {SmGameFish recruited from LgGameFish (nosave)}
                             {Negative in LgGameFish, Positive in SmGameFish}
      RecrSave:     Double;  {Saved for use in DoThisEveryStep (nosave)}
      IsLeavingSeg:  Boolean; {Is 100% of the animal currently migrating out of the segment due to anoxia or salinity(nosave)}
      MigrInput:    MigrInputType;
      KD: Double;            {KD calculated for PFA cheimcals}
      HabitatLimit: Double;  {Habitat Limitation nosave}

      Anim_Tox:     Array[FirstOrgTxTyp..LastOrgTxTyp] of TAnimalToxRecord; {pointer to relevant animal toxicity data (nosave)}

      PSameSpecies: PAllVariables;  {other state variable that represents the same species,
                                     relevant to only Sm and Lg Game Fish}

      SumPrey:      Double;  {The total sum of available prey to a predator in a given
                              timestep, calculated at the beginning of each timestep}

      MortRates:    MortRatesRecord; {Holds data about how animal is dying, (nosave)}

      NitrCons,PhosCons: Double; {holds data about the consumption of nutrients (nosave)}
      LastO2Calc, LastO2CalcTime   : Array[O2Mortality..O2Repro_Red] of Double; {optimization}
      LastSedCalc, LastSedCalcTime : Double; {optimization}

      AnadromousData : AnadromousDataRec; {NoSave}

      DerivedK1, DerivedK2:  Array[FirstOrgTxTyp..LastOrgTxTyp] of Double;  // 9/27/2010 model calculations for alternative BAF (nosave)

      constructor Init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                         IC : double; IsTempl: Boolean);
      Destructor Destroy; override;
      Procedure CalculateSumPrey;  {Set SumPrey property at start of time-step}
      Function  ReadTrophint(FileNm: String):Boolean;
      Procedure WriteTrophint(FileNm: String);

      Procedure ChangeData;
     {ChangeData MUST be called when the underlying data record is changed}
      Procedure Assign_Anim_Tox;

      Function  AggregateRedGrowth: Double;
      Function  AggregateRedRepro: Double;
      Function  BMin_in_mg_L : Double;
      Function  RefugeFrom(Prey: AllVariables): double;
      Function  EatEgest(Which : EatOrEgest): double;
      Function  DefecationTox(ToxType: ToxicantType): double;
      Function  IngestSpecies(Prey: StateVariables; PPref: TPreference; Var EgestReturn,GutEffRed:Double): double;
      Function  Consumption   : double ;
      Function  Respiration   : double ; override;
      Function  Defecation    : double ;
      Function  AnimExcretion : double ; virtual;
      Function  WetToDry      : Double;  override;
      Function  Mortality     : double ; override;
      Function  O2EffectFrac(O2Eff:TO2Effects):double;
      Function  AmmoniaMortality(ionized:boolean): Double;
      Function  Sediment_Mort : double;
      Function  GameteLoss    : double ;
      Function  Drift         : double ;
      Function  Washout       : Double ; override;
      Function  Scour_Entrainment : double ; virtual;
      Function  SpawnNow      : Boolean;
      Function  MaxConsumption: Double ;
      Function  AHabitat_Limit: Double;
      Function  IsBenthos: Boolean;  // includes benthic invert and benthic insect

      Function  GillUptake(ToxType: T_SVType; ToxLayer:T_SVLayer) : double ;
      Procedure Derivative(var DB: double); override;
      Procedure Calc_Prom_Recr_Emrg(growth: Double);
      Function  KCAP_in_g_m3 : double;

      Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Function ObjectID: SmallInt; override;
      Procedure WriteText(Var LF: TextFile); override;

  end;


  TPlant =class(TOrganism)
    PAlgalRec    : PPlantRecord;
    SinkToHypo   : Double;  {Set in Sedimentation}
    EC50_Photo   : Array[FirstOrgTxTyp..LastOrgTxTyp] of Double;

    Plant_Tox    : Array[FirstOrgTxTyp..LastOrgTxTyp] of TPlantToxRecord;
                  {pointer to relevant plant toxicity data (nosave)}
    MortRates:    MortRatesRecord; {Holds data about how plant category is dying, (nosave)}
    MacroType:    TMacroType;      {If plant is macrophyte, what type is it (nosave)}

    SloughEvent  : Boolean;  {have conditions for a sloughing event been met?  Nosave }
    SloughLevel  : Double;   {how far will biomass drop in a sloughin event?   NoSave}
    Sloughing    : Double;
    NutrLim_Step : Double;   {nutrlimit calculated at the beginning of each step  NoSave}
    HabitatLimit : Double;  {Habitat Limitation nosave}
    ZOpt         : Double;  {optimum depth for a given plant (a constant approximated at the beginning of the simulation)}

    Lt_Limit,Nutr_Limit,Temp_Limit,N_Limit,PO4_Limit, CO2_Limit,
       Chem_Limit, Vel_Limit, LowLt_Limit, HighLt_Limit : Double;   {track for rates, NOSAVE JSC 9-5-2002}
    ResidenceTime: Double;   {phytoplankton residence time, set in washout, NOSAVE}
    IsEunotia: Boolean;  {Is this Eunotia?  Scientific name includes "eunotia,"  NOSAVE}

    PSameSpecies:  PAllVariables;  {other state variable that represents the same species,
                                   relevant to periphyton}

    Constructor init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                     IC : double; IsTempl: Boolean);
    Destructor Destroy; override;
    Procedure  ChangeData;
   {ChangeData MUST be called when the underlying data record is changed}
    Procedure Assign_Plant_Tox;

    Function PeriphytonSlough: Double;
    Function AggregateFracPhoto: Double;
    Function Photosynthesis: double ; virtual;
    Function Respiration   : double ; override;
    Function PhotoResp     : double ; virtual;
    Function Mortality     : double ; override;
    Function Sedimentation : double ;
    Function Floating      : double ;
    Function SedToMe       : double ;
    Function Is_Pcp_CaCO3  : Boolean;
    Function IsLinkedPhyto : Boolean;

    Function Nutr_2_Org(NTyp: T_SVType): Double;
    Function N_2_Org       : Double;
    Function P_2_Org       : Double;

    Function IsFixingN     : Boolean;
    Function IsPeriphyton   : Boolean;
    Function IsPhytoplankton : Boolean;
    Function CalcSlough    : Double;
    Function LightSat      : Double;
    Function PAR_OD(Light: Double): Double; { photosynthetically active radiation at optimum depth }

    Function ToxicDislodge : double;

    Function WetToDry: Double; override;
    Function Washout       : double ; override;

    Procedure Derivative(var DB: double); override;
    Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
    Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
    Function ObjectID: SmallInt; override;

    Function DepthBottom: double ;
    Function LtAtTop(TS:TimeStepType)    : double ;
    Function LtAtDepth(TS:TimeStepType)  : double ;
    Function PO4Limit   : double ;
    Function NLimit     : double ;
    Function CO2Limit   : double ;
    Function PProdLimit : double ;
    Function VLimit     : double ;
    Function LtLimit(TS:TimeStepType)  : double ;
    Function NutrLimit  : double ;
    Function KCAP_in_g_m3 : double;
    Function PHabitat_Limit: Double;
    Procedure WriteText(Var LF: TextFile); override;
  end;

  TMacrophyte = class(TPlant)
    Function  Photosynthesis: double ; override;
    Function  Mortality: double; override;
    Procedure Derivative(var DB: double); override;
    Function  ObjectID : SmallInt; override;
    Function  Breakage: double;
    Function  Washout  : double ; override;
    Function  Washin   : Double ; override;
  end;

  T_N_Internal_Plant = class(TStateVariable)     // code at end of plant.inc  internal nutrients in plants
    Function Uptake: Double;
    Function NutrDiff : Double;
    Function NutInCarrierWashin: Double;
    Function NutrSegDiff(UpLinks: Boolean):Double;
    Procedure Derivative(var DB: double); override;
    Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
    Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
    Function    ObjectID: SmallInt; override;
  end;


  TRemineralize = class(TOrganism)
      Constructor Init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                       IC : double; IsTempl: Boolean);
      Destructor Destroy; override;
      Function pHCorr(pHMin, pHMax: double) : double ;
      Function SumDetrDecomp(OType: T_SVType; SedOnly: Boolean): Double;
      Function CalcAnimPredn : Double ;
      Function Assimilation  : Double;
      Function CalcPhotoResp : Double;
      Function CalcDarkResp  : Double;
      Function CalcAnimResp  : Double;
      Function CalcAnimExcr  : Double;
      Function NutrRelDefecation   : Double;
      Function NutrRelColonization : Double;
      Function NutrRelPlantSink    : Double;
      Function NutrRelMortality    : Double;
      Function NutrRelGamLoss      : Double;
      Function NutrRelPeriScr      : Double;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
    end;

  TPO4Obj = class(TRemineralize)
    {  Function AtmosDeposition : double ;  }
      FracAvail      : Double;
      Alt_FracAvail  : Array [PointSource..NonPointSource] of double;
      TP_IC,TP_Inflow,TP_PS,TP_NPS: Boolean;
      Constructor Init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                       IC : double; IsTempl: Boolean);
      Procedure Derivative(var DB: double); override;
      Function ObjectID: SmallInt; override;
      Function Remineralization: Double;
      Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Procedure WriteText(Var LF: TextFile); override;
    end;

  TNH4Obj = class(TRemineralize)
       PhotoResp,
       DarkResp,
       AnimExcr,
       AnimPredn,
       SvNutrRelColonization,
       SvNutrRelMortality,
       SvNutrRelGamLoss,
       SvNutrRelPeriScr,
       SvNutrRelPlantSink,
       SvNutrRelDefecation,
       SvSumDetrDecomp: Double;    //  {mg N/ L}
      Function Nitrification : double {real};
      Function Remineralization: Double;
      Procedure Derivative(var DB: double); override;
      Function ObjectID: SmallInt; override;
    end;

  TNO3Obj = class(TRemineralize)
      NotUsed      : Double;
      Alt_NotUsed  : Array [PointSource..NonPointSource] of Double;
      TN_IC,TN_Inflow,TN_PS,unused,TN_NPS: Boolean;
      Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Function Denitrification : double {real};
      Procedure Derivative(var DB: double); override;
      Function ObjectID: SmallInt; override;
      Procedure WriteText(Var LF: TextFile); override;
    end;


  TSalinity = class(TRemineralize)
      SalinityUpper, SalinityLower: Double;
      Procedure Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
    end;

  {************}
  {* DETRITUS *}
  {************}

  TDetritus = class(TRemineralize)
      Function DailyBurial: Double;  {Relevant for SedDetr only}
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function PlantSink_To_Detr(Ns: AllVariables): Double;
      Function Mort_To_Detr(NS: AllVariables):Double;
      Function SumGameteLoss: Double;
      Function Excr_To_Diss_Detr(NS: AllVariables):Double;
      Function Colonization: Double;
      Function GetInflowLoad(TimeIndex : Double): Double;  override;
      Function DetritalFormation: double ;
      Function SedDetritalFormation: double;
      Function MultFrac(TimeIndex: Double; IsAlt: Boolean; PAltLdg: PAlt_LoadingsType): Double;
               {returns fraction for splitting up loadings based on refr/part and diss/part split.}
    end;

  PDetritalInputRecordType = ^DetritalInputRecordType;
  DetritalInputRecordType =
      Packed Record
        DataType                        : DetrDataType;     { CBOD,Org_Carb,Org_Matt }
            f1,f2,f3: Byte; {d4-2006}
        InitCond                        : Double;           { Initial Condition of TOC/CBOD/organic matter }
        Percent_PartIC, Percent_RefrIC  : Double;           { Break down of the above Initial Condition }
        Load                            : LoadingsRecord;   { Loadings of organics }
        Percent_Part                    : LoadingsRecord;   { Constant or dynamic breakdowns of inflow, PS, NPS loadings }
        Percent_Refr                    : LoadingsRecord;   { Constant or dynamic breakdowns of inflow, PS, NPS loadings }
        ToxInitCond                     : ToxInitCondType;  { Tox. exposure of Init. Cond }
        ToxLoad                         : ToxLoadType;      { Constant or dynamic tox exposure of inflow, PS, NPS loadings }
      end; {Record}

  TDissDetr = class(TDetritus)
      Procedure Derivative(var DB: double); override;
      Function ObjectID: SmallInt; override;
    end;

  TDissRefrDetr = class(TDissDetr)
      InputRecord: DetritalInputRecordType;
      Constructor Init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                       IC : double; IsTempl: Boolean);
      Destructor Destroy; override;
      Function ObjectID: SmallInt; override;
      Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Procedure WriteText(Var LF: TextFile); override;
    end;

  TDissLabDetr = class(TDissDetr)
      Function ObjectID: SmallInt; override;
    end;

  TSuspendedDetr = class(TDetritus)
      DetrSinkToHypo: Double;
      Function Sedimentation  : Double ;
      Function Resuspension   : Double;
      Function DetrSinkFromEp : Double ;
      Procedure Derivative(var DB: double); override;
      Function ObjectID: SmallInt; override;
  end;

  TSuspLabDetr = class(TSuspendedDetr)
      Function ObjectID: SmallInt; override;
    end;

  TSuspRefrDetr = class(TSuspendedDetr)
      Function ObjectID: SmallInt; override;
    end;

  TSedimentedDetr = class(TDetritus)
      Procedure Derivative(var DB: double); override;
      Function ObjectID: SmallInt; override;
    end;

  TSedLabileDetr = class(TSedimentedDetr)
      Function ObjectID: SmallInt; override;
    end;

  TSedRefrDetr = class(TSedimentedDetr)
      Function ObjectID: SmallInt; override;
    end;


  TCO2Obj = class(TRemineralize)
      ImportCo2Equil : Boolean;
      CO2Equil: TLoadings;
      Function SumPhotosynthesis: double {real};
      Function AtmosExch : double;
      Procedure Derivative(var DB: double); override;
      Function ObjectID: SmallInt; override;
      Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
      Procedure WriteText(Var LF: TextFile); override;
      constructor init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                       IC : double; IsTempl: Boolean);
      Destructor Destroy; override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
    end;

  TO2Obj = class(TRemineralize)
      Threshhold: Double;
      CalcDuration: Boolean;
      NoLoadOrWash: Boolean;
      constructor init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                       IC : double; IsTempl: Boolean);
      Function SumRespiration(PlantOnly:Boolean): double ;
      Function SumPhotosynthesis: double ;
      Function KReaer : double;
      Function Reaeration : double ;
      Procedure Derivative(var DB: double); override;
      Function ObjectID: SmallInt; override;
      Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
      Procedure WriteText(Var LF: TextFile); override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
    end;

  TPorewater = class(TStateVariable)
      Function To_Above: Double;
      Function From_Above : Double;
      Function VolumeInM3: Double;
      Function VolumeInL: Double;
      Procedure Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : double); override;
      Function ObjectID: SmallInt; override;
  End;

  TDOMPoreWater = class(TStateVariable)
      Function UpperDiffusion(UpperUnits: Boolean): double;
      Procedure Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : double); override;
      Function ObjectID: SmallInt; override;
  End;

  {************}
  {*  TOXICS  *}
  {************}

  TToxics = class(TStateVariable)
      ppb        : Double;
      Carrier    : StateVariables;

      RecrSave   : Double;  {recruitment for dothiseverystep.  (nosave)}
      {-------------------------------------}
      constructor init(Ns, Carry : StateVariables; SVT: T_SVType; L: T_SVLayer; aName : ShortString; P : TStates;
                       IC : double; IsTempl: Boolean);
      destructor Destroy; override;
      Function OrgType: T_SVType;
      Function Arrhen(Temperature:double): double;
      Function Hydrolysis          : Double;
      Function Oxidation           : Double;
      Function Photolysis          : Double;
      Function Volatilization      : Double; virtual;
      Function Biotransformation   : Double;
      Function Ionization          : Double;
      Function Washout             : Double; override;
      Function Washin              : Double; override;
      Function ToxInCarrierWashin  : Double;
      Function ToxDiff             : Double;
{      Function ToxEntrain          : double; }
      Function Nondissoc           : Double;
      Function Depuration          : Double;
      Function ToxSegDiff(UpLinks: Boolean)    : Double;
      Function MicrobialMetabolism(Var FracAerobic: Double) : Double;
      Procedure CalculateLoadByBCF;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function WetToDry: Double; override;
      Procedure Derivative(var DB: double); override;
      Function AnimalDeriv: Double;
      Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Function CalculateKOM: Double;
      Function Sorption: Double;
      Function Desorption: Double;
      Procedure InitialLipid;
      Function ObjectID: SmallInt; override;
      Function Microbial_BioTrans_To_This_SV(Aerobic: Boolean):Double;
      Function Biotrans_To_This_Org: Double;
    end;

  TSuspSedimentTox = class(TToxics)
      Procedure Derivative(var DB: double); override;
      Function ObjectID: SmallInt; override;
  End;

  TBottomSedimentTox = class(TToxics)
      Function  CalcToxBedLoad: Double;
      Function  CalcToxBedLoss: Double;
      Procedure Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : double); override;
      Function ObjectID: SmallInt; override;
  End;

  TParticleTox = class(TToxics)
      Procedure Derivative(var DB: double); override;
      Function ObjectID: SmallInt; override;
  end;

  TPOCTox = class(TParticleTox)
      Procedure Derivative(var DB: double); override;
      Function ObjectID: SmallInt; override;
  end;


  TAlgae_ZooTox = class(TToxics)
      Function SumDietUptake: Double; {animals only}
      Function PlantUptake: Double;   {all plants}
      Procedure Derivative(var DB: double); override;
      Function ObjectID: SmallInt; override;
  end;

  TFishTox = class(TToxics)
      Procedure Derivative(var DB: double); override;
      Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Function ObjectID: SmallInt; override;
  end;

  TBuriedDetrTox1 = class(TToxics)
      Procedure Derivative(var DB: double); override;
      Procedure Store(IsTemp: Boolean; Var st: Tstream); override;
      Constructor Load(IsTemp: Boolean; st: Tstream; ReadVersionNum: Double);
      Procedure   CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
      constructor init(Ns,Carry :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
   end;                    

 {Multi-Layer Model}
  TBuriedDetrTox2 = class(TToxics)
      Procedure Derivative(var DB: double); override;
      Procedure   CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
   end;

  TPoreWaterTox = class(TToxics)
      Function UpperDiffusion(UpperUnits: Boolean): Double;
      Procedure Derivative(var DB: double); override;
      Procedure   CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; Override;
   end;

  TDOMPoreWaterTox = class(TToxics)
      Function  UpperToxDiff(UpperUnits: Boolean): Double;
      Procedure Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function  ObjectID: SmallInt; override;
   end;

   TResults = class(Baseclass)
           Date       : TDateTime;
           Final      : Boolean;  {is this a final, evenly spaced datapoint, or is it an intermediate point}
           DataPoints : TCollection;
      Constructor Init(RDate: TDateTime; Fnl: Boolean);
      Function GetIndex(NS: AllVariables; Typ: T_SVType; L: T_SVLayer; PPB,ToxVar,RateVar: Boolean; BAFVar: word; RI: Integer;
                        Var RC: TResultsCollection): Integer;
      Procedure Store(IsTemp: Boolean; Var st: Tstream); Override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Function ObjectID: SmallInt; override;
      Destructor Destroy;  override;
   End;

  {THeader holds information about a certain index number Data Point in TResults.DataPoint}
   TResHeader = class(Baseclass)
           AllState    : AllVariables;
           SVType      : T_SVType;
           Layer       : T_SVLayer;
           HeadStr     : String[40];
           UnitStr     : String[20];
           PPB, ToxVar, RateVar : Boolean;
           BAFVar      : word;
           SortIndex   : LongInt;  {Unique index for sorting points}
           PointIndex  : Integer;  {Location of datapoint within the TResults.Datapoints Collection}
           RateIndex   : Integer;  {If it's a rate, index of that rate}
      Constructor Init(AllSt: AllVariables; Typ: T_SVType; L:T_SVLayer; PP, TV, RV : Boolean;BF: Word; RI: Integer; HStr,Unt: String; PI: Integer);
      Procedure Store(IsTemp: Boolean; Var st: Tstream); Override;
      Function CalcUniqueIndex(AllSt: AllVariables; Typ: T_SVType; L: T_SVLayer; PP, TV, RV : Boolean;BAFflg: Word; RtIndex: Integer): LongInt;
      Function ListStr(DBFList: Boolean): String;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Function ObjectID: SmallInt; override;
   End;

   TDataPoint = class(Baseclass)
           State    : Double;
      Constructor Init(AllSt: AllVariables; Typ: T_SVType; L: T_SVLayer; St: Double;
                       PPB, ToxVar, RateVar : Boolean;  BAFFlag: Word;
                       RI: Integer; RC : TResultsCollection;
                       SV: TStates;  G_SqM : Boolean;  PI: Integer; RateStr: String);
      Constructor Init_Header_Exists(St: Double);
      Procedure Store(IsTemp: Boolean; Var st: Tstream); Override;
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
      Function ObjectID: SmallInt; override;
   End;

   TRate = class(Baseclass)
           Name : String[20];             
           Rate : Array[0..6] of Double;
      Constructor Init(Nm : String);
      Function GetRate: Double;
   End;

   TLinkType = (CascadeLnk, FeedbackLnk);

   TSVConc = class(Baseclass)
      SVConc: Double;
      Time  : Double;
      constructor Init(Conc,Tm: Double);
   End; {TO2Conc}

   TSegmentLink = class(Baseclass)
     Name         : RefString;
     FromID, ToID : SegIDString;
     LinkType     : TLinkType;
     CharLength   : Double;

     XSectionData : TLoadings;  {Intefacial Cross Sectional Area}
     DiffusionData: TLoadings;
     WaterFlowData: TLoadings;

     BedLoad: Array [Cohesives..Noncohesives2] of TLoadings;
     CurrentBedLoad : Array [Cohesives..Noncohesives2] of Double;

     FromPStates  : TStates;  {set before run, nosave}
     ToPStates    : TStates;  {set before run, nosave}

     CurrentWaterFlow, CurrentDiffusion, CurrentXSection: Double;
     GetLoadsDate : TDateTime;

     CascadeWash  : TResultsCollection;  { Washout from upper segment, relevant to cascade links only }
     LastCSPointWritten: TDateTime;

     constructor Init(ASegmentName : ShortString);
     destructor Destroy;  override;
     Procedure Store(IsTemp: Boolean; var st: Tstream);  Override;
     Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
     Procedure GetFromPLoadings(Time: TDateTime);
     Function  GetWaterFlow(Time: TDateTime): Double;
     Function  GetDiffusion(Time: TDateTime): Double;
     Function  GetXSection (Time: TDateTime): Double;
     Function  GetBedLoad(Sed: AllVariables;Time: TDateTime): Double;
     Procedure WriteText(Var LF: TextFile); override;
   End;    {TSegmentLink}


Procedure LoadCollectionItems(IsTemp: Boolean; St : Tstream; PColl: TCollection; Sort: Boolean; ReadVersionNum: Double);
Procedure StoreCollectionItems(IsTemp: Boolean; Var St : Tstream; PColl: TCollection);

{********************************************************************}
{*}                        implementation                          {*}
{********************************************************************}

uses diagenesis_calcs;

{$I Translate.Inc}
{$I State.inc}
{$I Animal.inc}
{$I Estuary.inc}
{$I Salinity.inc}
{$I Plant.inc}
{$I Reminerl.inc}
{$I ToxProcs.inc}
{$I Sediment.inc}
{$I Chemical.inc}
{$I Distribs.pas}
{$I Segment.inc}
{$I StorLoad.inc}

end.
