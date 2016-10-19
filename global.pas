//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
{************************}
{*}    UNIT Global;    {*}
{************************}
interface

uses Sysutils, Winprocs, TCollect, Dialogs, Classes, Graphics, Forms, Controls, StdCtrls, DBGrids;

(*VAR P_REMOVAL_S_LP : DOUBLE;
      N_REMOVAL_S_LP : DOUBLE;  {6/21/2011 LIPSKY CODE} *)

Const
{***  This version number must be a 10 character string! ***}
{  Follow the number with a space, to ensure correct interpretation  }
{  VersionStr          = '#.## ?????' }
   VersionStr : String = '3.83      ';
   BuildStr   : String = '3.1-Plus.001';

{  VersionStr is used in the about/splash screen and also is written to the saved-data
   file in order to automatically upgrade versions if the data-structures change.     }

   WRITE_STEIN_DURING_RUN = TRUE;

   {Uncertainty Data}
   Num_of_Reg_Distributions  = 276; {Number of Registered Distributions Currently in DISTRIBS.PAS}
   InitialCond_RegDist_Index = 122; {Set to correct number for units to be correct :INITIAL CONDITION}
   LogKow_RegDist_Index      = 6;   {Set to correct number to allow for below zero draws}
   ConstLoad_RegDist_Index   = 123; {Important for units and Uncert.Pas Warning    :CONST LOAD}
   DP_RegDist_Index          = 126; {                                              :DIRECT PRECIP }
   PS_RegDist_Index          = 127; {Needed to evaluate if Alt_Loadings present    :POINT SOURCE }
   NPS_RegDist_Index         = 128; {Needed to evaluate if Alt_Loadings present    :Non POINT SOURCE }

   MAX_SENS_OUTPUTS          = 100; {only track 100 outputs at this time due to Excel column limitation}

   Def2SedLabDetr : Double = 0.5;   {Defecation that is labile -- Const used in Toxprocs.Inc, Reminerl.Inc, State.Inc}
   Detr_OM_2_OC   : Double = 1.90;  {Organic Matter in Detritus over OC in Detritus, Winberg et al. 1971 }

type
   PDouble= ^Double;
   PTextFile = ^TextFile;
{  PNotes = ^TNotes;
   TNotes = array[0..4096] of char; }

   {Note, changes to this list affect loading of saved runs.  See TRANSLATE.INC}

  PAllVariables =^AllVariables;
  AllVariables = (
 {Toxicants}       H2OTox1,  H2OTox2,  H2OTox3,  H2OTox4,  H2OTox5,
                   H2OTox6,  H2OTox7,  H2OTox8,  H2OTox9,  H2OTox10,
                   H2OTox11, H2OTox12, H2OTox13, H2OTox14, H2OTox15,
                   H2OTox16, H2OTox17, H2OTox18, H2OTox19, H2OTox20,

 {Nutrients}       Ammonia, Nitrate, Phosphate, CO2, Oxygen,

 {Porewater}       PoreWater, ReDOMPore, LaDOMPore,  {m3/m2, ug/L pw}
 {Sediments}       Sand, Silt, Clay, TSS,

 {Diagenesis}      Silica, Avail_Silica, COD, TAM, Methane, Sulfide,
                   POC_G1, POC_G2, POC_G3,   {H2}
                   PON_G1, PON_G2, PON_G3,   {H2}
                   POP_G1, POP_G2, POP_G3,   {H2}

 {Mult.Layer Segs} Cohesives, NonCohesives, NonCohesives2, {g/m2, ug/m2}
 {Estuarine vsn.}  Salinity,

 {Detritus: Sedm}  SedmRefrDetr, SedmLabDetr,
 {Detritus: Diss}  DissRefrDetr, DissLabDetr,
 {Detritus: Susp}  SuspRefrDetr, SuspLabDetr,

 {Buried Detritus} BuriedRefrDetr, BuriedLabileDetr,

 {Plants: Algae}   Diatoms1, Diatoms2, Diatoms3, Diatoms4, Diatoms5, Diatoms6,
                   Greens1, Greens2, Greens3, Greens4, Greens5, Greens6,
                   BlGreens1, BlGreens2, BlGreens3, BlGreens4,BlGreens5,BlGreens6,
                   OtherAlg1, OtherAlg2,
 {Plants: Macro}   Macrophytes1, Macrophytes2, Macrophytes3, Macrophytes4, Macrophytes5, Macrophytes6,

 {Animls: DInvrt}  Shredder1, Shredder2, SedFeeder1, SedFeeder2,
 {Animls: HInvrt}  SuspFeeder1, SuspFeeder2, Clams1, Clams2, Grazer1, Grazer2, Snail1, Snail2,
 {Animls: PInvrt}  PredInvt1, PredInvt2,

 {Animals: Fish}   SmForageFish1, SmForageFish2, LgForageFish1, LgForageFish2,
 { size classes}   SmBottomFish1, SmBottomFish2, LgBottomFish1, LgBottomFish2,
                   SmGameFish1,   SmGameFish2,   SmGameFish3,   SmGameFish4,
                   LgGameFish1,   LgGameFish2,   LgGameFish3,   LgGameFish4,

 {Multi Age Fish}  Fish1, Fish2, Fish3, Fish4, Fish5, Fish6, Fish7, Fish8,
                   Fish9, Fish10, Fish11, Fish12, Fish13, Fish14, Fish15,

 {Driving Vars}    Volume,  Temperature,   WindLoading,   Light,  pH,

                   NullStateVar  {has utility uses}  );

Const HOURLYLIST = [ammonia..oxygen,sand..TSS,light,cohesives..NonCohesives2, DissRefrDetr..SuspLabDetr]; {List of variables with hourly loadings enabled}

      { Below constants help further characterize the above enumerated list...
          they must be updated when the list changes }

       FirstState   = H2OTox1;        LastState   = NullStateVar;
       FirstDetr    = SedmRefrDetr;   LastDetr    = SuspLabDetr;
       FirstPlant   = Diatoms1;       LastPlant   = Macrophytes6;
       FirstAlgae   = Diatoms1;       LastAlgae   = OtherAlg2;
       FirstDiatom  = Diatoms1;       LastDiatom  = Diatoms6;
       FirstGreens  = Greens1;        LastGreens  = Greens6;
       FirstBlGreen = BlGreens1;      LastBlGreen = BlGreens6;
       FirstMacro   = Macrophytes1;   LastMacro   = Macrophytes6;
       FirstAnimal  = Shredder1;      LastAnimal  = Fish15;
       FirstInvert  = Shredder1;      LastInvert  = PredInvt2;
       FirstDetrInv = Shredder1;      LastDetrInv = SedFeeder2;
       FirstHerbInv = SuspFeeder1;    LastHerbInv = Snail2;
       FirstPredInv = PredInvt1;      LastPredInv = PredInvt2;
       FirstFish    = SmForageFish1;  LastFish    = Fish15;
       FirstBiota   = Diatoms1;       LastBiota   = Fish15;  {this definition does not include detritus}
       FirstTox     = H2OTox1;        LastTox     = H2OTox20;
       FirstOrgTox  = H2OTox1;        LastOrgTox  = H2OTox20;

Type   PAlt_LoadingsType = ^Alt_LoadingsType;
       Alt_LoadingsType = (PointSource,DirectPrecip,NonPointSource);
       TDistType        = (Triangular,Uniform,Normal,LogNormal);

       StateVariables   =  H2OTox1..NullStateVar;
       VerticalSegments =  (Epilimnion,Hypolimnion);
       PTimeStepType    =  ^TimeStepType;
       TimeStepType     =  (TSHourly,TSDaily);

Const  InflowLoadT = PointSource;
       DischargeLoadT = DirectPrecip;

Type
  T_SVType   = {sv types}     ( StV, Porewaters,
                                OrgTox1,  OrgTox2,  OrgTox3,  OrgTox4,  OrgTox5,
                                OrgTox6,  OrgTox7,  OrgTox8,  OrgTox9,  OrgTox10,
                                OrgTox11, OrgTox12, OrgTox13, OrgTox14, OrgTox15,
                                OrgTox16, OrgTox17, OrgTox18, OrgTox19, OrgTox20,
                 {output types} NotUsed,  NotUsed2, OtherOutput, NTrack, PTrack,
                {Internal Nuts} NIntrnl, PIntrnl);

  T_SVLayer  = {Location of SV} (WaterCol,  SedLayer1, SedLayer2, SedLayer3,
                                 SedLayer4, SedLayer5, SedLayer6, SedLayer7,
                                 SedLayer8, SedLayer9, SedLayer10);

Const  LowestLayer = SedLayer10;
       Num_SVLayers = 10;
       FirstOrgTxTyp = OrgTox1;   LastOrgTxTyp = OrgTox20;
       FirstToxTyp = OrgTox1;     LastToxTyp = OrgTox20;

Type
  SV_ID        = Packed Record  
                   Nstate : AllVariables;
                   Svtype : T_SVType;
                   Layer  : T_SVLayer;
                 End; {Record}
  PSV_ID       = ^SV_ID;


  POldGraphSetupRecord = ^TOldGraphSetuprecord;
  TOldGraphSetupRecord = Packed Record
     Y1Items, Y2Items: Array[1..20] of Longint;
     VarShowOptions: Array[1..20] of Boolean;
     Y1AutoScale, Y2AutoScale: Boolean;
     Y1Min,Y1Max,Y2Min,Y2Max: Double;
     Use2Scales: Boolean;
     XMin, XMax: Double;
   End;


  ToxicantType = FirstOrgTxTyp..LastOrgTxTyp;
  DetrDataType = (CBOD,Org_Carb,Org_Matt);
  TO2Effects   = (O2Mortality,O2Growth_Red,O2Repro_Red);

  TAddtlOutput = ( Secchi, Chla, NondissocOut, BedDepth, InflowWater, ToxLoading, TotalTox, THalfLife,
                   MultiFishConc, MultiFishTox, MultiFishPPB, TotalToxMass, DischWater, DebugPurposes,
                   BedDnsty, FracWatr, BedVlm,

                   TotTLoss, TotalTWash, TWashH2o, TWashAnim, TWashDetr, {Tox Tracking, Can be positive or negative}
                   TWashPlant, TWashSed, THydrol, TPhotol, TVolatil, TMicrobMet, TBioTrans,TNotUsed,TEmergeI,
                   TLossandMass, TBuryOOS, TTotOOSLoad, TLoadH2O, TLoadSed, TLoadDetr, TLoadBiota, TMBTest,
                   TSink,TDeltaThick, TEntrain,TTurbdiff,TMigrate,TNetLayer, TFishing,

                   DeltaBedHeight,VelocityOut,DynZMeanOut,
                   Peri_Chla, Moss_Chla, Tau, VelRiff, VelPool,
                   SegThick, TidalAmp, RetTime, BirdConc,
                     {Nutrient Tracking Variables}
                   TotNMass, NDissWater, NDetr, NAnimals, NPlants,
                   TotNLoss, TotalNWash, NWashH2o, NWashAnim, NWashDetr, NWashPlant, NEmergeI, NDenitr, NBurial,
                   NTotLoad, NLoadDissH2O, NLoadDetr, NLoadBiota, NPWMacro, NFixation, NMBTest, NExposure,
                   NLSink, NLTDiff, NLMigr, NLayerNet,

                   {Total Nitrogen and Total Phosphorus in mg/L,  BOD5}
                   TN,TP,BODOut, NH3UnIon,

                   PhytoResTime, DT50Water, DT95Water, Dt50Sed, Dt95Sed, TOrgSedPPB,

                   MinOxygen, MaxOxygen, O2Duration, MinNH3UnIon, MaxNH3UnIon,

                   PctBlGrPhyto,
                   SteinAnim,SteinPlant,SteinInvert,SteinAll, SOD_OUT, NSediment, InorgDep,

                   Peri_Biomass, Phyto_Biomass, TSP_Diag, No3_Diag, NH3_Diag, POP_Dep, POC_Dep, PON_Dep, CaCO3p, NSorbCaCO3,
                   SaltInflow, FreshInflow, EstEntr, EstUpperOut,
                   InorgSed, TSS60Day, PctEmbedded, MeanVol, BenthicChla, FracLitOut, O2FluxOut, PctEPT, PctChiro,
                   GPP_Out,CommResp_Out,PtoR_Out,BtoP_Out, NFishing, // 2-10-2009
                   PctAmphipods, PctGastropods, PctBivalves, PctBlGrPeri, PctDiatomsPeri, PctGreensPeri, PctOligochaete,   // 10/6/2009
                   PFluxDiagenesis, {KG since simulation start}      // 3-16-2010   {ORD #142}
                   PctDiatomsPhyto, PctGreensPhyto, PctOtherPhyto,   // 9-30-2010
                   BoundaryCond,    {kg/timestep}                    // 2-14-2011
                   PctEphemeroptera, PctTrichoptera,PctPlecoptera, PctEunotia,   // 4-27-2012
                   BInvt_Biomass, PlgInvt_Biomass, Fish_Biomass, NPP_Out, NekInvt_Biomass);   // 1-21-2013

   UptakeCalcMethodType = (Default_Meth,CalcBCF,CalcK1,CalcK2);


Const  MAX_NUMBER_SEGMENTS = 500; {Keep Track of Segment IDs in Linked Mode}
Const  C1=37./378;C3=250./621;C4=125./594;C6=512./1771;  {Integration Constants}

Type  TListBoxIDs = Array[0..Max_Number_Segments] of String[4];
      PListBoxIDs = ^TListBoxIDs;

Type
 {Previous Vsn's Choosable Animals in Toxicity Screen:  necessary for reading old files}
  OldAnimals = (Trout, Bluegill, Bass, Catfish, Minnow, Daphnia,
                Chironomid, Stonefly, Ostracod, Amphipod, Other);
  OldAlgTox  = (Green,Diatom,BlueGr,Macro);
  TMacroType = (Benthic,Rootedfloat,Freefloat);

  Fish = Trout..Minnow;
  Zoo  = Daphnia..Amphipod;
  Alg = (Phyto,BlGr,Gr);
  SiteTypes = (Pond, Stream, Reservr1D, Lake, Enclosure,Estuary,TribInput);

  Wavelengths = Array[1..12] of Double;
  RefString   = String[45];
  NewRefString   = String[200];
  UnitString  = String[20];
  XLRefString = String[90];
  PRefString  = ^RefString;
  FileNString = String[255];
  DirString    = String[255];
  LongRefString = String[60];
  NameString   = String[60];
  PNameString = ^NameString;
  SegIDString = String[4];
  PSegIDString = ^SegIDString;
  PBoolean = ^Boolean;
  PInteger = ^Integer;
  PDirString = ^DirString;

  TMethdProc = procedure of object;
  PProgDataRec = ^ProgDataRec;
  ProgDataRec = packed record
      ErrVar, ErrRate,
      PercStepCaption,
      UncertStatLabel,
      UncertTitleLabel,
      ErrValue, DateStr          : String;
      UncertPanelVis,
      StratVis, AnoxicVis, WZVis,
      ProgCancel, StepSizeVis,
      PeriVis, SloughDia,
      SloughGr,SloughBlGr        : Boolean;
      ProgInt, Gauge2Int         : Integer;
    End;

  PChemicalRecord = ^ChemicalRecord;
  ChemicalRecord =  packed record
      ChemName             : NewRefString;
      CASRegNo             : String[20];
      MolWt                : Double;
      Solubility           : Double;
      XSolubility          : NewRefString;
      Henry                : Double;
      XHenry               : NewRefString;
      pka                  : Double;
      Xpka                 : NewRefString;
      VPress               : Double;
      XVPress              : NewRefString;
      LogKow               : Double; {Log KOW, log octanol water part. coeff.}
      XLogKow              : NewRefString;
      En                   : Double; {Activation Energy for Temperature}
      XEn                  : NewRefString;
      KMDegrdn             : Double;
      XKMDegrdn            : NewRefString;
      KMDegrAnaerobic      : Double;
      XKMDegrAnaerobic     : NewRefString;
      KUnCat               : Double;
      XKUncat              : NewRefString;
      KAcid                : Double;
      XKAcid               : NewRefString;
      KBase                : Double;
      XKBase               : NewRefString;
      PhotolysisRate       : Double;
      XPhotoLysisRate      : NewRefString;
      OxRateConst          : Double;
      XOxRateConst         : NewRefString;

      KPSed                : Double;
      XKPSed               : NewRefString;
      Weibull_Shape        : Double;
      XWeibull_Shape       : NewRefString;
      ChemIsBase           : Boolean;
      CalcKPSed            : Boolean;

      CohesivesK1          : Double;
      CohesivesK2          : Double;
      CohesivesKp          : Double;
      CohesivesRef         : NewRefString;
      NonCohK1             : Double;
      NonCohK2             : Double;
      NonCohKp             : Double;
      NonCohRef            : NewRefString;
      NonCoh2K1            : Double;
      NonCoh2K2            : Double;
      NonCoh2Kp            : Double;
      NonCoh2Ref           : NewRefString;

            {PFA Parameters}
      IsPFA                : Boolean;
      PFAType              : String[12];
      PFAChainLength       : Double;
      XPFAChainLength      : NewRefString;
      PFASedKom            : Double;
      XPFASedKom           : NewRefString;
      PFAAlgBCF            : Double;
      XPFAAlgBCF           : NewRefString;
      PFAMacroBCF          : Double;
      XPFAMacroBCF         : NewRefString;

      WeibullSlopeFactor   : Double;
      XWeibullSlopeFactor  : NewRefString;

      CalcKOMRefrDOM       : Boolean;
      KOMRefrDOM           : Double;
      XKOMRefrDOM          : NewRefString;

      K1Detritus           : Double;         // new to 3.77
      XK1Detritus          : NewRefString;

      PlaceholderD1        : Double;  {place holders so additional parameters do not require storload mods}
      PlaceholderD2        : Double;
      PlaceholderR1        : NewRefString;
      PlaceholderR2        : NewRefString;
      PlaceholderB1        : Boolean;
    end;

  MBTrackArray = Array[0..6] of Double;

  MBLossRecord =  {Record tracks MB loss for a particular state var. for a particular segment}
    Record
      TotalNLoss   : MBTrackArray;
      TotalWashout : MBTrackArray;
      WashoutH2O   : MBTrackArray;
      WashoutAnim  : MBTrackArray;
      WashoutDetr  : MBTrackArray;
      WashoutPlant : MBTrackArray;
      EmergeIns    : MBTrackArray;
      Denitrify    : MBTrackArray;
      Burial       : MBTrackArray;
      CaCO3Sorb    : MBTrackArray;
      FishingLoss  : MBTrackArray;
      BoundLoss    : MBTrackArray;   // Loss out of the model domain for this segment  2-14-2011  {PER TIME STEP}
    End;

  MBLoadRecord = {Record tracks MB loading for a particular state var. for a particular segment}
    Record
      LoadH2O   : MBTrackArray;
      LoadDetr   : MBTrackArray;
      LoadBiota   : MBTrackArray;
      LoadPWMacro : MBTrackArray;
      LoadFixation : MBTrackArray;
      TotOOSLoad  : MBTrackArray;  // redefined to mean "out of segment" load for linked-mode MB tracking refinement 3/20/2014
      Exposure  : MBTrackArray;
      BoundLoad    : MBTrackArray;   // gain intothe model domain for this segment  2-14-2011  {PER TIME STEP}
    End;

  MBLayerRecord = {Record tracks inter layer interactions for a particular state var. for a particular segment}
    Record
      NSink      : MBTrackArray;
      NTurbDiff  : MBTrackArray;
      NMigrate   : MBTrackArray;
      NNetLayer  : MBTrackArray;
      PFluxD     : MBTrackArray;
    End;

  EstSaltLoadingRec =
    Packed Record
      AmmoniaLoad: Double; {mg/L}
      XAmmoniaLoad: XLRefString;
      NitrateLoad: Double; {mg/L}
      XNitrateLoad: XLRefString;
      PhosphateLoad: Double; {mg/L}
      XPhosphateLoad: XLRefString;
      O2Load: Double; {mg/L}
      XO2Load: XLRefString;
      CO2Load: Double; {mg/L}
      XCO2Load: XLRefString;
    End;

  ToxTrackArray = Array[0..6] of Double;

  ToxLossRecord =  {Record tracks tox loss for a particular toxicant for a particular segment}
    Packed Record
      TotalToxLoss : ToxTrackArray;
      TotalWashout : ToxTrackArray;
      WashoutH2O   : ToxTrackArray;
      WashoutAnim  : ToxTrackArray;
      WashoutDetr  : ToxTrackArray;
      WashoutPlant : ToxTrackArray;
      WashoutSedm  : ToxTrackArray;
      Hydrolys     : ToxTrackArray;
      Photolys     : ToxTrackArray;
      Volatiliz    : ToxTrackArray;
      MicrobMet    : ToxTrackArray;
      BioTransf    : ToxTrackArray;
      EmergeIns    : ToxTrackArray;
      OOSBury      : ToxTrackArray;
      FishingLoss  : ToxTrackArray;

      DissHydr  : ToxTrackArray;
      DissPhot  : ToxTrackArray;
      DissMicrob: ToxTrackArray;
      DissWash  : ToxTrackArray;
      DissVolat : ToxTrackArray;
      DissSorp  : ToxTrackArray;
      SedMicrob : ToxTrackArray;
      SedHydr   : ToxTrackArray;
      SedDeSorp : ToxTrackArray;
      SedScour  : ToxTrackArray;
    End;

   ToxLayerRecord = {Record tracks inter layer interactions for a particular toxicant for a particular segment}
    Packed Record
      ToxSink      : ToxTrackArray;
      ToxDeltaThick: ToxTrackArray;
      ToxTurbDiff  : ToxTrackArray;
      ToxEntrain   : ToxTrackArray;
      ToxMigrate   : ToxTrackArray;
      ToxNetLayer  : ToxTrackArray;
    End;

  ToxLoadRecord = {Record tracks tox loading for a particular toxicant for a particular segment}
    Packed Record
      ToxLoadH2O  : ToxTrackArray;
      ToxLoadSed  : ToxTrackArray;
      ToxLoadDetr : ToxTrackArray;
      ToxLoadBiota: ToxTrackArray;
      TotOOSLoad  : ToxTrackArray;    // redefined to mean "out of segment" load for linked-mode MB tracking refinement 3/20/2014
    End;

  SiteRecord =
    packed record
      SiteName             : NewRefString;
      ECoeffWater          : Double;
      SiteLength           : Double;   {units are KM}
      XLength              : NewRefString;
      StaticVolume         : Double;
      XVolume              : NewRefString;
      SurfArea             : Double;
      XSurfArea            : NewRefString;
      ICZMean              : Double;
      XZMean               : NewRefString;
      ZMax                 : Double;
      XZMax                : NewRefString;
      TempMean             : Array[VerticalSegments] of Double;
      XTempMean            : Array[VerticalSegments] of NewRefString;
      TempRange            : Array[VerticalSegments] of Double;
      XTempRange           : Array[VerticalSegments] of NewRefString;
      Latitude             : Double;
      XLatitude            : NewRefString;
      LightMean            : Double;
      XLightMean           : NewRefString;
      LightRange           : Double;
      XLightRange          : NewRefString;
      AlkCaCO3             : Double;
      XAlkCaCO3            : NewRefString;
      HardCaCO3            : Double;
      XHardCaCO3           : NewRefString;
      SiteComment          : string[255];
      SO4ConC              : Double;
      XSO4Conc             : NewRefString;
      TotalDissSolids      : Double;
      XTotalDissSolids     : NewRefString;
      StreamType           : string[20];
      Channel_Slope        : Double;
      XChannel_Slope       : NewRefString;
      Max_Chan_Depth       : Double;
      XMax_Chan_Depth      : NewRefString;
      SedDepth             : Double;
      XSedDepth            : NewRefString;
      EnclWallArea         : Double;
      XEnclWallArea        : NewRefString;
      MeanEvap             : Double;       {inches / year}
      XMeanEvap            : NewRefString;
      UseEnteredManning    : Boolean;
      EnteredManning       : Double;
      XECoeffWater         : NewRefString;

      PctRiffle            : Double;
      XPctRiffle           : NewRefString;
      PctPool              : Double;
      XPctPool             : NewRefString;

      UseBathymetry        : Boolean;

      ts_clay              : Double;  { clay critical shear stress for scour [kg/m2] }
      Xts_clay             : NewRefString;
      ts_silt              : Double;  { silt critical shear stress for scour [kg/m2] }
      Xts_silt             : NewRefString;
      tdep_clay            : Double;   { clay critical shear stress for deposition [kg/m2] }
      Xtdep_clay           : NewRefString;
      tdep_silt            : Double;   { silt critical shear stress for deposition [kg/m2] }
      Xtdep_silt           : NewRefString;
      FallVel_clay         : Double;  { clay fall velocity, m/s}
      XFallVel_clay        : NewRefString;
      FallVel_silt         : Double;  { silt fall velocity, m/s}
      XFallVel_silt        : NewRefString;

     {ESTUARY ADDITIONS BELOW}

      SiteWidth            : Double;
      XSiteWidth           : NewRefString;

  {m2} amplitude1 : Double; k1: Double; ConstRef1: NewRefString;
  {s2} amplitude2 : Double; k2: Double; ConstRef2: NewRefString;
  {n2} amplitude3 : Double; k3: Double; ConstRef3: NewRefString;
  {k1} amplitude4 : Double; k4: Double; ConstRef4: NewRefString;
  {o1} amplitude5 : Double; k5: Double; ConstRef5: NewRefString;
 {SSA} amplitude6 : Double; k6: Double; ConstRef6: NewRefString;
  {SA} amplitude7 : Double; k7: Double; ConstRef7: NewRefString;
  {P1} amplitude8 : Double; k8: Double; ConstRef8: NewRefString;

      Min_Vol_Frac         : Double;
      XMin_Vol_Frac        : NewRefString;

      WaterShedArea        : Double;
      XWaterShedArea       : NewRefString;
      EnterTotalLength     : Boolean;
      TotalLength          : Double;
      XTotalLength         : NewRefString; {3.43}

      ECoeffSED            : Double;
      XECoeffSED           : NewRefString;
      ECoeffDOM            : Double;
      XECoeffDOM           : NewRefString;
      ECoeffPOM            : Double;
      XECoeffPOM           : NewRefString;  {3.44}

      UseCovar             : Boolean;
      EnteredKReaer        : Double;
      XEnteredKReaer       : NewRefString;
      UsePhytoRetention    : Boolean;

      BasePercentEmbed     : Double;     {3-6-2008}
      XBasePercentEmbed    : NewRefString;

      Altitude             : Double;     {12/27/2008}  {3.60}
      XAltitude            : NewRefString;

      PlaceholderN1        : Double;
      PlaceholderR1        : NewRefString;
    end;

  MorphRecord =   {Hold Results of Variable Morphometry}
  Packed Record
      SegVolum         : Array[VerticalSegments] of Double;   {segment volume last good solution step}
      InflowH2O        : Array[VerticalSegments] of Double;
      XSecArea         : Double;
      OOSDischFrac     : Double; {frac of total discharge that moving out of the system (linked mode)}
      OOSInflowFrac    : Double; {Frac of total inflow that is coming from out of the sys (linked mode)}
  end;

  ReminRecord =
    packed record
      RemRecName    : NewRefString;
      DecayMax_Lab  : Double;
      XDecayMax_Lab : NewRefString;
      Q10_NotUsed   : Double;
      XQ10          : NewRefString;
      TOpt          : Double;
      XTOpt         : NewRefString;
      TMax          : Double;
      XTMax         : NewRefString;
      TRef_NotUsed  : Double;
      XTRef         : NewRefString;
      pHMin         : Double;
      XpHMin        : NewRefString;
      pHMax         : Double;
      XpHMax        : NewRefString;
      P2OrgLab      : Double;
      N2OrgLab      : Double;
      PlaceHolder   : Double; {Was Org2 Nitrate}
      XP2OrgLab     : NewRefString;
      XN2OrgLab     : NewRefString;
      O2Biomass     : Double;
      XO2Biomass    : NewRefString;
      O2N           : Double;
      XO2N          : NewRefString;
      KSed          : Double;
      XKsed         : NewRefString;
      PSedRelease_NotUsed   : Double;
      XPSedrelease  : NewRefString;
      NSedRelease_NotUsed   : Double;
      XNSedRelease  : NewRefString;
      DecayMax_Refr : Double;    {g/g d}
      XDecayMax_Refr: NewRefString;

      {ESTUARY ADDITIONS BELOW}
      KSedTemp            : Double;
      XKSedTemp           : NewRefString;
      KSedSalinity        : Double;
      XKSedSalinity       : NewRefString;
      {ESTUARY ADDITIONS Above}

      P2Org_Refr     : Double;
      XP2Org_Refr    : NewRefString;
      N2Org_Refr     : Double;
      XN2Org_Refr    : NewRefString;
      Wet2DryPRefr   : Double;
      XWet2DryPRefr  : NewRefString;
      Wet2DryPLab    : Double;
      Xet2DryPLab    : NewRefString;
      Wet2DrySRefr   : Double;
      XWet2DrySRefr  : NewRefString;
      Wet2DrySLab    : Double;
      XWet2DrySLab   : NewRefString; {1216}
      N2OrgDissLab   : Double;
      XN2OrgDissLab  : NewRefString;
      P2OrgDissLab   : Double;
      XP2OrgDissLab  : NewRefString;
      N2OrgDissRefr  : Double;
      XN2OrgDissRefr : NewRefString;
      P2OrgDissRefr  : Double;
      XP2OrgDissRefr : NewRefString;

      KD_P_Calcite   : Double;     {Sorption of P to CaCO3, L/Kg}
      XKD_P_Calcite  : NewRefString;

      NotUsed        : Double;  // Was BOD5_CBODu
      XNotUsed       : NewRefString; // XBOD5_CBODu

      KNitri         : Double;   
      XKNitri        : NewRefString;
      KDenitri_Bot   : Double;
      XKDenitri_Bot  : NewRefString;
      KDenitri_Wat   : Double;
      XKDenitri_Wat  : NewRefString;

      PlaceholderB1  : Boolean;
      PlaceholderB2  : Boolean;
    end;

  InteractionFields =
    Packed record
      Pref : Double;
      ECoeff: Double;
      XInteraction: LongRefString;
          f1,f2,f3: Byte; {d4-5}
    end;

  PZooRecord = ^ZooRecord;
  ZooRecord =
    packed record {d4-5}
      AnimalName          : NewRefString;
      ToxicityRecord      : string[15];
      FHalfSat            : Double;
      XFHalfSat           : NewRefString;
      CMax                : Double;      {max consumption}
      XCMax               : NewRefString;
      BMin                : Double;
      XBMin               : NewRefString;
      Q10                 : Double;
      XQ10                : NewRefString;
      TOpt                : Double;
      XTOpt               : NewRefString;
      TMax                : Double;
      XTMax               : NewRefString;
      TRef                : Double;
      XTRef               : NewRefString;
      EndogResp           : Double;
      XEndogResp          : NewRefString;
      KResp               : Double;
      XKResp              : NewRefString;
      KExcr               : Double;
      XKExcr              : NewRefString;
      PctGamete           : Double;
      XPctGamete          : NewRefString;
      GMort               : Double;
      XGMort              : NewRefString;
      KMort               : Double;     {Mortality Coefficient}
      XKMort              : NewRefString;
      Placeholder         : Double;     { Not Used, Takes the place of EMort }
      XPlaceHolder        : NewRefString;
      KCap                : Double;
      XKCap               : NewRefString;
      MeanWeight          : Double;
      XMeanWeight         : NewRefString;
      FishFracLipid       : Double;
      XFishFracLipid      : NewRefString;
      LifeSpan            : Double;      { Mean Lifespan in days }
      XLifeSpan           : NewRefString;
      Animal_Type         : string[15];
      AveDrift            : Double;
      XAveDrift           : NewRefString;   {Background Drift}
      {V185 Additions Below}
      AutoSpawn           : Boolean;     {Calc Spawn Automatically based on Temps?}

      SpawnDate1          : TDateTime;
      SpawnDate2          : TDateTime;
      SpawnDate3          : TDateTime;
      XSpawnDate          : NewRefString;
      UnlimitedSpawning   : Boolean;
      SpawnLimit          : Integer;

      UseAllom_C          : Boolean;     {use allometric equations to calculate consumption}

      CA                  : Double;      {intercept for weight dependence}
      CB                  : Double;      {slope for weight dependence}
      UseAllom_R          : Boolean;     {use allometric equations to calculate respiration}

      RA                  : Double;      {intercept for spec. standard metabolism}
      RB                  : Double;      {weight dependence coeff.}
      UseSet1             : Boolean;     {Use "set 1" of resp. eqns.}

      RQ, RTO, RTM, RTL,
      RK1, RK4, ACT, BACT : Double;      {allometric respiration paramters} {size 1328}
      FracInWaterCol      : Double;
      XFracInWaterCol     : NewRefString;
      Guild_Taxa          : string[15];

      PrefRiffle          : Double;
      XPrefRiffle         : NewRefString;
      PrefPool            : Double;
      XPrefPool           : NewRefString;
      VelMax              : Double;
      XVelMax             : NewRefString;
      XAllomConsumpt      : NewRefString;
      XAllomResp          : NewRefString;

            {ESTUARY ADDITIONS BELOW}
      {Salinity & Ingestion}
      Salmin_Ing,         {minimum salinity tolerance 0/00}
      SalMax_Ing,         {max salinity tolerance 0/00}
      Salcoeff1_Ing,
      Salcoeff2_Ing       : Double; {unitless}
      XSalinity_Ing       : NewRefString;
      {Salinity & Gameteloss}
      Salmin_Gam,         {minimum salinity tolerance 0/00}
      SalMax_Gam,         {max salinity tolerance 0/00}
      Salcoeff1_Gam,
      Salcoeff2_Gam       : Double; {unitless}
      XSalinity_Gam       : NewRefString;
      {Salinity & Respiration}
      Salmin_Rsp,         {minimum salinity tolerance 0/00}
      SalMax_Rsp,         {max salinity tolerance 0/00}
      Salcoeff1_Rsp,
      Salcoeff2_Rsp       : Double; {unitless}
      XSalinity_Rsp       : NewRefString;
      {Salinity & Mortility}
      Salmin_Mort,         {minimum salinity tolerance 0/00}
      SalMax_Mort,         {max salinity tolerance 0/00}
      Salcoeff1_Mort,
      Salcoeff2_Mort       : Double; {unitless}
      XSalinity_Mort       : NewRefString;

      Fishing_Frac         : Double;    {fraction / day}
      XFishing_Frac        : NewRefString;

      P2Org                : Double;
      XP2Org               : NewRefString;
      N2Org                : Double;
      XN2Org               : NewRefString;

      Wet2Dry              : Double;
      XWet2Dry             : NewRefString;

      O2_LethalConc        : Double;
      O2_LethalPct         : Double;
      O2_LCRef             : NewRefString;

      O2_EC50growth        : Double;
      XO2_EC50growth       : NewRefString;
      O2_EC50repro         : Double;
      XO2_EC50repro        : NewRefString;

      Ammonia_LC50         : Double;
      XAmmonia_LC50        : NewRefString;

      Sorting              : Double;    {3.46, SABS}
      XSorting             : NewRefString;
      SuspSedFeeding       : Boolean;
      XSuspSedFeeding      : NewRefString;
      SlopeSSFeed          : Double;
      XSlopeSSFeed         : NewRefString;
      InterceptSSFeed      : Double;
      XInterceptSSFeed     : NewRefString;

      SenstoSediment       : NewRefString;
      XSensToSediment      : NewRefString;
      Trigger              : Double;
      XTrigger             : NewRefString;

      SenstoPctEmbed       : Boolean;   {3-6-2008}
      PctEmbedThreshold    : Double;
      XPctEmbedThreshold   : NewRefString;

      BenthicDesignation   : NewRefString; {10/24/08 Benthic Metric Designation}

      PlaceHolderD1        : Double;
      PlaceHolderD2        : Double;
      PlaceHolderD3        : Double;    // Size 10275 to here  3.67

      ScientificName       : NewRefString;

      PlaceholderB1        : Boolean;
      PlaceholderR1        : NewRefString;
      PlaceholderR2        : NewRefString;
      PlaceholderR3        : NewRefString;
    end;

  PTrophIntArray = ^TrophIntArray;
  TrophIntArray = Array[Cohesives..LastBiota] of InteractionFields;
  {Four excess entries at the beginning of the record is a coding artifact of old versions}

  PPlantRecord= ^PlantRecord;
  PlantRecord =
    packed record
      PlantName           : NewRefString;
      PlantType           : string[15];
      ToxicityRecord      : string[15];
      EnteredLightSat     : Double;
      XLightSat           : NewRefString;
      KPO4                : Double;
      XKPO4               : NewRefString;
      KN                  : Double;    {n half Sat}
      XKN                 : NewRefString;
      KCarbon             : Double;
      XKCarbon            : NewRefString;
      Q10                 : Double;
      XQ10                : NewRefString;
      TOpt                : Double;
      XTOpt               : NewRefString;
      TMax                : Double;
      XTMax               : NewRefString;
      TRef                : Double;
      XTRef               : NewRefString;
      PMax                : Double;
      XPMax               : NewRefString;
      KResp               : Double;
      XKResp              : NewRefString;
      KMort               : Double;
      XKMort              : NewRefString;
      EMort               : Double;
      XEMort              : NewRefString;
      KSed                : Double;
      XKSed               : NewRefString;
      ESed                : Double;
      XESed               : NewRefString;
      P2OrgInit           : Double;
      XP2Org              : NewRefString;
      N2OrgInit           : Double;
      XN2Org              : NewRefString;
      ECoeffPhyto         : Double;
      XECoeffPhyto        : NewRefString;
      CarryCapac          : Double;
      XCarryCapac         : NewRefString;
      Red_Still_Water     : Double;
      XRed_Still_Water    : NewRefString;
      Macrophyte_Type     : string[15];
      Macro_Drift         : Double;
      Taxonomic_Type      : string[15];
      PrefRiffle          : Double;
      XPrefRiffle         : NewRefString;
      PrefPool            : Double;
      XPrefPool           : NewRefString;
      FCrit               : Double;
      XFCrit              : NewRefString;
      Macro_VelMax        : Double;
      XVelMax             : NewRefString;
            {ESTUARY ADDITIONS BELOW}
      KSedTemp            : Double;
      XKSedTemp           : NewRefString;
      KSedSalinity        : Double;
      XKSedSalinity       : NewRefString;
      {Salinity & Photosynthesis}
      Salmin_Phot,         {minimum salinity tolerance 0/00}
      SalMax_Phot,         {max salinity tolerance 0/00}
      Salcoeff1_Phot,
      Salcoeff2_Phot        : Double; {unitless}
      XSalinity_Phot       : NewRefString;
      {Salinity & Mortility}
      Salmin_Mort,         {minimum salinity tolerance 0/00}
      SalMax_Mort,         {max salinity tolerance 0/00}
      Salcoeff1_Mort,
      Salcoeff2_Mort       : Double; {unitless}
      XSalinity_Mort       : NewRefString;

      Wet2Dry              : Double;
      XWet2Dry             : NewRefString;

      Resp20              : Double;
      XResp20             : NewRefString;

      PctSloughed          : Double;
      XPctSloughed         : NewRefString;

      UseAdaptiveLight     : Boolean;
      MaxLightSat          : Double;
      XMaxLightSat         : NewRefString;
      MinLightSat          : Double;
      XMinLightSat         : NewRefString;

      PlaceholderB2        : Boolean;  {Size 7011 to here 3.67}
      ScientificName       : NewRefString;

      PlantFracLipid       : Double;
      XPlantFracLipid      : NewRefString;

      SurfaceFloating      : Boolean;  {3.80}

      NHalfSatInternal     : Double;
      XNHalfSatInternal    : NewRefString;    {Size 7631 to here 3.82}
      PHalfSatInternal     : Double;
      XPHalfSatInternal    : NewRefString;
      MaxNUptake           : Double;
      XMaxNUptake          : NewRefString;
      MaxPUptake           : Double;
      XMaxPUptake          : NewRefString;
      Min_N_Ratio          : Double;
      XMin_N_Ratio         : NewRefString;
      Min_P_Ratio          : Double;
      XMin_P_Ratio         : NewRefString;

      PlaceholderD1        : Double;
      PlaceholderR1        : NewRefString;
      PlaceholderD2        : Double;
      PlaceholderR2        : NewRefString;
      PlaceholderD3        : Double;
      PlaceholderR3        : NewRefString;
      PlaceholderD4        : Double;
      PlaceholderR4        : NewRefString;
      PlaceholderD5        : Double;
      PlaceholderR5        : NewRefString;
      PlaceholderD6        : Double;
      PlaceholderR6        : NewRefString;
      PlaceholderB1        : Boolean;
      PlaceholderB3        : Boolean;

   end;

  PSetup_Record = ^Setup_Record;
  Setup_Record =
  Packed record
      FirstDay          : TDateTime;
      LastDay           : TDateTime;
      StoreStepSize     : Double;
      MinStepSize       : Double;
      RelativeError     : Double;
      Placeholder       : Boolean;  {equilibrium fugacity disabled}
      SaveBRates        : Boolean;
      AlwaysWriteHypo   : Boolean;
      ShowIntegration   : Boolean;
      UseComplexedInBAF : Boolean;
      DisableLipidCalc  : Boolean;
      KeepDissToxConst  : Boolean;
      AverageOutput     : Boolean;
      UseExternalConcs  : Boolean;
      BCFUptake         : Boolean;

      StepSizeInDays    : Boolean;
      ModelTSDays       : Boolean;

      Spinup_Mode       : Boolean;  {to v 3.56}
      NFix_UseRatio     : Boolean;  {to v 3.66}   // 3/16/2010, option to use NFix Ratio
      NtoPRatio         : Double;   {to v 3.67}   // 3/18/2010, capability to specify NFix Ratio

      Spin_Nutrients    : Boolean;  {to v 3.77}

      FixStepSize        : Double;
      UseFixStepSize     : Boolean;  {to 3.79}

      Internal_Nutrients : Boolean;  {New to 3.83 and 3.1 plus}

      PlaceholderD1,D2   : Double;  {place holders so additional parameters do not require storload mods}
      PlaceholderB1,B2,B3,B4,B5,B6: Boolean;
end;


  PUncertainty_Setup_Record = ^Uncertainty_Setup_Record;
  Uncertainty_Setup_Record =
  packed record {d4-5}
      Run_Uncertainty     : Boolean;
      Run_Sensitivity     : Boolean;       {new to 3.20}
        f2,f3             : Byte; {d4-5}
      NumSteps            : LongInt;
      RandomSeed          : LongInt;
      UseSeed             : Boolean;
        f4,f5,f6          : Byte; {d4-5}

      NominalPercent      : Double;        {new to 3.20 below }
      TrackUncertVars     : Boolean;
      NumUncert, NumSens  : Integer;
      SensTrack, UncertTrack: Array [1..100] of LongInt;
      LinkPeriPhyto       : Boolean;
      UseCorrelations     : Boolean;

      AdvancedSens        : Boolean;  {3.62  No Interface a this time}
      StartIteration      : Integer;
      Processors2Use      : Integer;
      StartIter, EndIter  : Integer;
      AverageAll          : Boolean;
      AverageYears        : Double;   {Size 861 to here}

      SaveToCSV           : Boolean;  {3.65 addition}
      RandomSampling      : Boolean;  {3.66 addition}

      PlaceholderD1       : Double;
      PlaceholderD2       : Double;
      PlaceholderB1       : Boolean;
      PlaceholderB2       : Boolean;
  end;

  PreRunDataRecord =
  Packed record
      IngestRate    : Array [FirstAnimal..LastAnimal] of Double;
      GrowthRate    : Array [FirstAnimal..LastAnimal] of Double;
      AveIngestRate : Array [FirstAnimal..LastAnimal] of Double;
      AveGrowthRate : Array [FirstAnimal..LastAnimal] of Double;
  end;

PRateInfoType=^RateInfoType;
RateInfoType = Packed Record
                 Dirnm,FileNm: String[255];
                 WriteDaily      : Boolean;
                 NotUsed         : Boolean;
                 FileInit        : Array[VerticalSegments] of Boolean;
                 WriteToMemory   : Boolean;      // set to true permanently, 8/27/2010
               End;

Sediment_Data_Rec =
Packed record  
  Width,        { channel bottom width in meters [m] }
  Slope,        { channel slope [m/m]                }
  Manning,      { Manning's n roughness coefficient  }
  yFlood,       { Maximum channel depth[m] before overflow into the floodplain}
  Clength,      { channel length [m] }
  AWidth,       { channel width [m] }
  Max_Depth,    { maximum allowable sediment depth [m] }
  BedDepth,     { depth of bed sediment }
  Bed_Porosity, { a function of porosities for each particle type }

  msilt, msand, mclay: Double;  { Sediment masses, [kg] }

{  mett, metv                                   : Viscdat; }

  { table of kinematic viscosities as a function of Temp}
  BedDepthWarning, FloodPlainWarning           : Boolean;
  { avoid repetative warnings }

  Channel_Depth : Double;  {Current channel depth in meters}
  Avg_Depth     : Double;  {Average depth of reach in meters}
  Avg_Disch     : Double;  {Current average flow discharge in [m3/s]}
  HRadius       : Double;


  Scour_Clay, Scour_Silt, Sco_Sand : Double;
  Dep_Clay, Dep_Silt, Dep_Sand  : Double;
  CBedTo   : Double;
  Vol_Silt : Double;
  Tau      : Double; {kg/m2}

end;

Control_Opt_SubRec = Packed Record
   ZeroInitCond, OmitInflow, OmitPS, OmitDP, OmitNPS, SetMult: Boolean;
   OmitTox, OmitBuried: Boolean {Relevant only to tox and Hg}
 End;

 PControl_Opt_Rec = ^Control_Opt_Rec;
 Control_Opt_Rec = Packed Record
  Tox,Nutrient,Sediment,Detritus: Control_Opt_SubRec;
 End;

 BedRecord = Packed Record
    BedDepthIC       : Double; {m}            {Input Parameter, Initial Condition}
    BedDensity       : Double; {g/m3}         {Calculated from Component Densities}
    NotUsed          : Double; {m}            {Not Used}
    UpperDispCoeff   : Pointer; {m2/d}        {Daily Input Parameter}
    NotUsed2         : Pointer;               {Not Used}
    FracWater        : Double; {fraction}     {Calculated}
    BedVolume        : Double; {m3}           {Dynamic, Calculated}
    DynBedDepth      : Double; {m3}           {Dynamic, Calculated}
    VolumeLost       : Double; {m3}           {Calc.}
    PoreSqueeze      : Double; {m3}           {Calc.}
 End;


EAquatoxError= Exception;

CONST
    SecsPerDay  : Double = 86400.0;
    M2GDay  : Double = 480; {  cc --> m2, mg --> g, hr --> day  }
    G  : Double = 9.8062; {  gravitational constant  }
    Mi2Meters : Double  = 1.609E3; {  mi --> m  }
    MPH2MSec  : Double = 0.447; {  mph --> m/sec  }

    Tiny     : Double = 5.0e-19; {mach. accuracy = 1.0e-19 }
    VSmall   : Double = 1.0e-10;
    Small    : Double = 1.0e-6;

    KAnaerobic   : Double = 0.3; { (1/d)   {decomp reduction - check Sanders, Gunnison}
    OrgToC       : Double = 0.526;  {fraction of organic carbon - based on Winberg et al. 1971}
    Minimum_Stepsize : Double =1.0e-10   {-5};

    Eutrophication  = False;

{BELOW TYPE USED FOR TIMING PROFILE ANALYSIS, JSC}

Const NumTTimes = 100;
Type TTiming=Class
  Times: Array[1..NumTTimes] of Double;
  TimeStarts: Array[1..NumTTimes] of Double;
  Constructor Create;
  Procedure StartTime(Index: Integer);
  Procedure StopTime(Index: Integer);
end;

{Var Timer: TTiming; }

Type {Distributions/ Uncertainty types}

Reg_Dist_Type = (SingleVarDist,AllAnimals,AllPlants,AllStateVars,AnimalTox,
                 PlantTox,AllOrgToxs,AllPhyto,AllPeriMacro,AllFish,EmptyDist);

Registered_Distribution= Packed Record {not saved}
   RDIndex   : Integer;
   RDType    : Reg_Dist_Type;
   RDName    : String[45];
  End; {record}

var
    {DIRECTORIES THAT AQUATOX USES}
    Default_Dir,
    Program_Dir,
    Output_Dir,
    Studies_Dir : ShortString;
    HelpFilePath: String;

    SegLog: String;
    WordInitialized : Boolean = False;
    WordApp             : Variant;

    BatchIsRunning, BatchErr: Boolean;
    BatchLog: TextFile;

    BODConvertWarning: Boolean;  // avoid repetitive BOD import loading

{   testlog: textfile;
    testopened: boolean = false; }

    GenScnInstalled:  Boolean;
    GenScnPath: ShortString;
    SWATDir: ShortString;

    {VARIABLES USED WHEN LOADING STUDIES}
    VersionNum                 : Double;  {The current version number}
{    VolumeLoaded               : Boolean; }

    {DISPLAY VARIABLES}
    TeaseInc: Integer;         {Used for updating wait dialog}
    TeaseScreen: Boolean;      {Is wait dialog visible?}

    OpenWriteFiles: Array of String;
    OpenUncFiles  : Array of String;

    WizardIsRunning: Boolean;
    EditColor      : TColor;
    WriteLoadingsToTextLog: Boolean;

Type
   TUncertDraw = Class(BaseClass)
     Value: Double;
     RandomDraw: Double;
     IntervalNum: Longint;
     Constructor Init(Val,RD:Double;Int:LongInt);
   end;


{Various Utility Functions}

  Function LegalFileName(fName:String): String;  {returns a legal file name from string (removes illegal chars.)}
  Function MessageDlg2(St: String; ATyp: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
  Procedure DefaultControlInfo(Var C: Control_Opt_Rec);
  Function Has_Alt_Loadings(ns: AllVariables; Typ: T_SVType; Lyr: T_SVLayer): Boolean;
  Function RoundDec(I: Integer; J: Double):Double;
  Function AbbrString(InStr: ShortString; DelimChar: Char):ShortString;
  Function CleanFileName(InStr: String): String;
  Function GetDataName(InStr: ShortString):ShortString;
  Function JulianDate(Indate: TDateTime): LongInt;
  Function GetStateFromName( Name: ShortString; Var S: StateVariables):Boolean;
  Function StateText(S : AllVariables; T:T_SVType; L:T_SVLayer) : ShortString;
  Function OutputText(S : AllVariables; T:T_SVType; L:T_SVLayer; ST: String; IsPPB, IsToxVar: Boolean; BAFVar: Word) : ShortString;
  Function AssocToxSV(T:T_SVType): AllVariables;
  Function AssocToxTyp(S: AllVariables): T_SVType;
  Function PrecText(T: T_SVType): ShortString;
  Function GetID(S : AllVariables; T:T_SVType; L:T_SVLayer): SV_ID;
  Procedure ProcessDBFName(Var N: String; P: Pointer);
  Function AQTCopyFile(Src,Dst: String): Boolean;
  Procedure CleanDashes(Var Instr:String);


{********************************************************************}
{*}                                                                {*}
{*}                        Implementation                          {*}
{*}                                                                {*}
{********************************************************************}

//  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
//  Dialogs,Main, StdCtrls, Grids, Menus, ExtCtrls, Clipbrd, Global, SLR6;

Uses Grids, Clipbrd;


Procedure CleanDashes(Var Instr:String);
Begin
   While Pos('\\',Instr)>0 do
     Delete(Instr,Pos('\\',Instr),1);
End;


Function LegalFileName(fName:String): String;  {returns a legal file name from string (removes illegal chars.)}

const badChars : tSysCharSet = [':', '\', '/', '*', '?', '<', '>', '"'];
var i, j, lth : integer;

begin
lth := Length (fName); 
SetLength (Result, lth); 
j := 0;
for i := 1 to lth do 
    begin
    if not (fName [i] in badChars) 
    then begin
        inc (j); 
        Result [j] := fName [i]; 
        end; 
    end; 
SetLength (Result, j);
end; 


Function MessageDlg2(St: String; ATyp: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
{Message DLG which does not show in batch mode so that batch runs do not get held up}
Begin
  If BatchIsRunning then
    Begin
      Writeln(BatchLog,St + ' [OK]');
      BatchErr := True;
      MessageDlg2 := mrOK;
      Exit;
    End;

  MessageDlg2 := MessageDlg(St,Atyp,AButtons,HelpCtx);
End;


Function AssocToxSV(T:T_SVType): AllVariables;
Begin
  Case T of
     FirstOrgTxTyp..LastOrgTxTyp: AssocToxSV := AllVariables(Ord(T)-2);
         else Raise EAQUATOXERROR.Create('Programming error, AssocToxSV Argument Out of Range');
  end; {case}
End;

Function AssocToxTyp(S: AllVariables): T_SVType;
Begin
  Case S of
     FirstOrgTox..LastOrgTox: AssocToxTyp := T_SVTYPE(Ord(S)+2);
         else Raise EAQUATOXERROR.Create('Programming error, AssocToxTyp Argument Out of Range');

  end; {case}
End;

Function GetID(S : AllVariables; T:T_SVType; L: T_SVLayer): SV_ID;
Begin
  GetID.Nstate:=S;  GetID.SVType:=T;  GetID.Layer := L;
End;

Function Has_Alt_Loadings(ns: AllVariables; Typ:T_SVType; Lyr: T_SVLayer): Boolean;
Begin
  Has_Alt_Loadings:=
      (Lyr = WaterCol) and
      ((ns in [Volume,FirstTox..LastTox,Phosphate,Oxygen,Ammonia,Nitrate,Salinity, 
              DissRefrDetr..LastDetr,Sand..Clay,FirstFish..LastFish]) and (Typ=StV)) or
       (ns in [Cohesives,NonCohesives,NonCohesives2]);
End;

Function  GetStateFromName(Name: ShortString;Var S:StateVariables):Boolean;
Var Found: Boolean;
{Function finds the STATEVARIABLES value associated with a given name.}

begin
  Found:=False;
  S:=FirstState;
  If StateText(S,StV,WaterCol)=Name then Found:=True
  else repeat
         inc(S);
         If StateText(S,StV,WaterCol)=Name then Found:=True;
       until (S=LastState) or Found;
  GetStateFromName:=Found;
end;

Function StateText(S : AllVariables; T:T_SVType; L:T_SVLayer) : ShortString;
{Returns the text name given a State Variable ID}
{Does not display buried sediment layers}

{StateNames that are associated with organic toxicant or Hg will not be
 displayed in the list of state variables in is version,
 thus they receive the 'UNDISPLAYED' Label}
begin
  StateText:='Undisplayed';
  If L>WaterCol then exit;

  If T=StV then
  case S of
   Volume        : StateText:='Water Volume';
   Temperature   : StateText:='Temperature';
   WindLoading   : StateText:='Wind Loading';
   Light         : StateText:='Light';
   pH            : StateText:='pH';
   Phosphate     : StateText:='Phosphate as P';
   Ammonia       : StateText:='Total Ammonia as N';
   Nitrate       : StateText:='Nitrate as N';
   Salinity      : StateText:='Salinity';
   Silica        : StateText:='Silica';
   Avail_Silica  : StateText:='Biogenic_Silica';
   COD           : StateText:='COD';
   TAM           : StateText:='TAM';
   Sulfide       : StateText:='Sulfide';
   Methane       : StateText:='Methane';
   POC_G1        : StateText:='POC_G1';
   POC_G2        : StateText:='POC_G2';
   POC_G3        : StateText:='POC_G3';
   PON_G1        : StateText:='PON_G1';
   PON_G2        : StateText:='PON_G2';
   PON_G3        : StateText:='PON_G3';
   POP_G1        : StateText:='POP_G1';
   POP_G2        : StateText:='POP_G2';
   POP_G3        : StateText:='POP_G3';
   CO2           : StateText:='Carbon dioxide';
   Oxygen        : StateText:='Oxygen';
   Sand           : StateText:='Sand';
   Silt          : StateText:='Silt';
   Clay          : StateText:='Clay';
   TSS           : StateText:='Tot. Susp. Solids';
   Cohesives     : StateText:='Cohesives <63';
   NonCohesives  : StateText:='Non-Cohesives 63-250';
   NonCohesives2 : StateText:='Non-Cohesives2 >250';
   SedmRefrDetr  : StateText:='Refrac. sed. detritus';
   SedmLabDetr   : StateText:='Labile sed. detritus';
   DissRefrDetr  : StateText:='Susp. and dissolved detritus';
   BuriedRefrDetr  : StateText:='BuriedRefrDetr';
   BuriedLabileDetr : StateText:='BuriedLabileDetr';

   Diatoms1      : StateText:='Diatoms1';
   Diatoms2      : StateText:='Diatoms2';
   Diatoms3      : StateText:='Diatoms3';
   Diatoms4      : StateText:='Diatoms4';
   Diatoms5      : StateText:='Diatoms5';
   Diatoms6      : StateText:='Diatoms6';
   Greens1       : StateText:='Greens1';
   Greens2       : StateText:='Greens2';
   Greens3       : StateText:='Greens3';
   Greens4       : StateText:='Greens4';
   Greens5       : StateText:='Greens5';
   Greens6       : StateText:='Greens6';
   BlGreens1     : StateText:='Cyanobacteria1';
   BlGreens2     : StateText:='Cyanobacteria2';
   BlGreens3     : StateText:='Cyanobacteria3';
   BlGreens4     : StateText:='Cyanobacteria4';
   BlGreens5     : StateText:='Cyanobacteria5';
   BlGreens6     : StateText:='Cyanobacteria6';
   OtherAlg1     : StateText:='OtherAlg1';
   OtherAlg2     : StateText:='OtherAlg2';
   Macrophytes1  : StateText:='Macrophyte1';
   Macrophytes2  : StateText:='Macrophyte2';
   Macrophytes3  : StateText:='Macrophyte3';
   Macrophytes4  : StateText:='Macrophyte4';
   Macrophytes5  : StateText:='Macrophyte5';
   Macrophytes6  : StateText:='Macrophyte6';

   Shredder1     : StateText:='Shredder1';
   Shredder2     : StateText:='Shredder2';
   SedFeeder1    : StateText:='SedFeeder1';
   SedFeeder2    : StateText:='SedFeeder2';
   SuspFeeder1   : StateText:='SuspFeeder1';
   SuspFeeder2   : StateText:='SuspFeeder2';
   Grazer1       : StateText:='Grazer1';
   Grazer2       : StateText:='Grazer2';
   PredInvt1     : StateText:='PredInvt1';
   PredInvt2     : StateText:='PredInvt2';
   Snail1        : StateText:='Snail1';
   Snail2        : StateText:='Snail2';
   Clams1        : StateText:='Clam1';
   Clams2        : StateText:='Clam2';
   SmForageFish1 : StateText:='SmForageFish1';
   LgForageFish1 : StateText:='LgForageFish1';
   SmForageFish2 : StateText:='SmForageFish2';
   LgForageFish2 : StateText:='LgForageFish2';
   SmBottomFish1 : StateText:='SmBottomFish1';
   LgBottomFish1 : StateText:='LgBottomFish1';
   SmBottomFish2 : StateText:='SmBottomFish2';
   LgBottomFish2 : StateText:='LgBottomFish2';
   SmGameFish1   : StateText:='SmGameFish1';
   SmGameFish2   : StateText:='SmGameFish2';
   SmGameFish3   : StateText:='SmGameFish3';
   SmGameFish4   : StateText:='SmGameFish4';
   LgGameFish1   : StateText:='LgGameFish1';
   LgGameFish2   : StateText:='LgGameFish2';
   LgGameFish3   : StateText:='LgGameFish3';
   LgGameFish4   : StateText:='LgGameFish4';
   Fish1         : StateText:='Multi.Age-Class Fish';
   FirstOrgTox..LastOrgTox: StateText:='Dissolved org. tox '+IntToStr(Ord(S)+1);
  end; {case statement}
end;  {Function STATETEXT}


Function PrecText(T: T_SVType): ShortString;
Begin
  PrecText :='T'+IntToStr(Ord(T)-1);
End;


Function OutputText(S : AllVariables; T:T_SVType; L:T_SVLayer; ST:String; ISPPB,IsToxVar:Boolean; BAFVar: Word) : ShortString;
{For output purposes, Returns the text name given an enumerated ALLVARIABLE value}
Var PreText,StateText : String;
    AO      : TAddtlOutput;

Begin
 OutputText:='Undisplayed';

 StateText:=ST;

 If StateText='' then
  case S of
   Volume        : StateText:='Water Vol';
   Temperature   : StateText:='Temp';
   WindLoading   : StateText:='Wind';
   Light         : StateText:='Light';
   pH            : StateText:='pH';
   Phosphate     : If L> WaterCol then StateText:='PO4'
                                  else StateText:='Tot. Sol. P';
   Ammonia       : If L> WaterCol then StateText:='Ammonia'
                                  else StateText:='NH3 & NH4+';
   Nitrate       : StateText:='NO3';
   CO2           : StateText:='CO2';
   Oxygen        : StateText:='Oxygen';
   Sand          : StateText:='Susp sand';
   Silt          : StateText:='Susp silt';
   Clay          : StateText:='Susp clay';
   TSS           : StateText:='TSS';
   SedmRefrDetr  : StateText:='R detr sed';
   SedmLabDetr   : StateText:='L detr sed';
   DissRefrDetr  : StateText:='R detr diss';
   DissLabDetr   : StateText:='L detr diss';
   SuspRefrDetr  : StateText:='R detr part';
   SuspLabDetr   : StateText:='L detr part';
   BuriedRefrDetr  : StateText:='BuryRDetr';
   BuriedLabileDetr: StateText:='BuryLDetr';
   Diatoms1      : StateText:='Diatoms1';
   Diatoms2      : StateText:='Diatoms2';
   Greens1       : StateText:='Greens1';
   Greens2       : StateText:='Greens2';
   BlGreens1     : StateText:='Cyanobacteria1';
   BlGreens2     : StateText:='Cyanobacteria2';
   OtherAlg1     : StateText:='OtherAlg1';
   OtherAlg2     : StateText:='OtherAlg2';
   Macrophytes1  : StateText:='Macrophyte1';
   Macrophytes2  : StateText:='Macrophyte2';
   Shredder1     : StateText:='Shredder1';
   Shredder2     : StateText:='Shredder2';
   SedFeeder1    : StateText:='SedFeeder1';
   SedFeeder2    : StateText:='SedFeeder2';
   SuspFeeder1   : StateText:='SuspFeeder1';
   SuspFeeder2   : StateText:='SuspFeeder2';
   Grazer1       : StateText:='Grazer1';
   Grazer2       : StateText:='Grazer2';
   PredInvt1     : StateText:='PredInvt1';
   PredInvt2     : StateText:='PredInvt2';
   Snail1        : StateText:='Snail1';
   Snail2        : StateText:='Snail2';
   Clams1        : StateText:='Clam1';
   Clams2        : StateText:='Clam2';
   SmForageFish1 : StateText:='SmForageFish1';
   LgForageFish1 : StateText:='LgForageFish1';
   SmForageFish2 : StateText:='SmForageFish2';
   LgForageFish2 : StateText:='LgForageFish2';
   SmBottomFish1 : StateText:='SmBottomFish1';
   LgBottomFish1 : StateText:='LgBottomFish1';
   SmBottomFish2 : StateText:='SmBottomFish2';
   LgBottomFish2 : StateText:='LgBottomFish2';
   SmGameFish1   : StateText:='SmGameFish1';
   SmGameFish2   : StateText:='SmGameFish2';
   SmGameFish3   : StateText:='SmGameFish3';
   SmGameFish4   : StateText:='SmGameFish4';
   LgGameFish1   : StateText:='LgGameFish1';
   LgGameFish2   : StateText:='LgGameFish2';
   LgGameFish3   : StateText:='LgGameFish3';
   LgGameFish4   : StateText:='LgGameFish4';
   Fish1         : StateText:='Fish 0';
   Fish2         : StateText:='Fish I';
   Fish3         : StateText:='Fish II';
   Fish4         : StateText:='Fish III';
   Fish5         : StateText:='Fish IV';
   Fish6         : StateText:='Fish V';
   Fish7         : StateText:='Fish VI';
   Fish8         : StateText:='Fish VII';
   Fish9         : StateText:='Fish VIII';
   Fish10        : StateText:='Fish IX';
   Fish11        : StateText:='Fish X';
   Fish12        : StateText:='Fish XI';
   Fish13        : StateText:='Fish XII';
   Fish14        : StateText:='Fish XIII';
   Fish15        : StateText:='Fish XIV';
   Salinity      : StateText:='Salinity';
   Diatoms3      : StateText:='Diatoms3';
   Diatoms4      : StateText:='Diatoms4';
   Diatoms5      : StateText:='Diatoms5';
   Diatoms6      : StateText:='Diatoms6';
   Greens3       : StateText:='Greens3';
   Greens4       : StateText:='Greens4';
   Greens5       : StateText:='Greens5';
   Greens6       : StateText:='Greens6';
   BlGreens3     : StateText:='Cyanobacteria3';
   BlGreens4     : StateText:='Cyanobacteria4';
   BlGreens5     : StateText:='Cyanobacteria5';
   BlGreens6     : StateText:='Cyanobacteria6';
   Macrophytes3  : StateText:='Macrophyte3';
   Macrophytes4  : StateText:='Macrophyte4';
   Macrophytes5  : StateText:='Macrophyte5';
   Macrophytes6  : StateText:='Macrophyte6';
   FirstOrgTox..LastOrgTox
                 : StateText:='T'+IntToStr(Ord(S)+1)+' H2O';
   PoreWater     : StateText :='Pore Water';
   ReDOMPore     : StateText :='R DOM PoreW';
   LaDOMPore     : StateText :='L DOM PoreW';
   Cohesives     : StateText :='Cohesives <63';
   NonCohesives  : StateText :='Non-Cohesives 63-250';
   NonCohesives2 : StateText :='Non-Cohesives >250';
   Silica        : StateText:='Silica';
   Avail_Silica  : StateText:='Biogenic_Silica';
   COD           : StateText:='COD';
   TAM           : StateText:='TAM';
   Sulfide       : StateText:='Sulfide';
   Methane       : StateText:='Methane';
   POC_G1        : StateText:='POC_G1';
   POC_G2        : StateText:='POC_G2';
   POC_G3        : StateText:='POC_G3';
   PON_G1        : StateText:='PON_G1';
   PON_G2        : StateText:='PON_G2';
   PON_G3        : StateText:='PON_G3';
   POP_G1        : StateText:='POP_G1';
   POP_G2        : StateText:='POP_G2';
   POP_G3        : StateText:='POP_G3';
 end; {case}

 If L>WaterCol then
   Begin
     If T=StV then StateText :=  'L' + IntToStr(ORD(L)) +' '+ StateText
              else StateText :=  'L' + IntToStr(ORD(L)) +' '+ PrecText(T) +  StateText;

   End;

 If StateText<>'' then OutputText:=StateText;

 If T in [FirstToxTyp..LastToxTyp]  then
   Begin
     PreText := PrecText(T);

     If Not IsToxVar then
       Begin
         If (L=WaterCol) then OutputText:=PreText+StateText;
       End; {Not ToxVar}
   End; {IF TOX}

   If IsPPB then
      if L>WaterCol then OutputText:='ppb'+Result
                    else OutputText:=Result+'(ppb)';

   If T=OtherOutput then
     Begin
       AO := TAddtlOutput(S);
       PreText := '';
       if L>WaterCol then PreText := 'L' + IntToStr(ORD(L));
       Case AO of
         InflowWater      : OutputText:='InflowH2O';
         DischWater       : OutputText:='DischH2O';
         Secchi           : OutputText:='Secchi d';
         Chla             : OutputText:='Phyto. Chlorophyll';
         Peri_Chla        : OutputText:='Peri. Chlorophyll';
         Peri_Biomass     : OutputText:='Peri. Biomass';
         Phyto_Biomass    : OutputText:='Phyto. Biomass';
         Moss_Chla        : OutputText:='Moss Chla';
         MultiFishConc    : OutputText:='Mult-Fish Biomass';
{        H2OTox1Disch     : OutputText:='Tox1 Casc. Inflow'; }
         BedDepth         : OutputText:=PreText+'Bed Depth';
         BedDnsty         : OutputText:=PreText+'Density';
         FracWatr         : OutputText:=PreText+'Poros';
         BedVlm           : OutputText:=PreText+'Volume';
         DeltaBedHeight   : OutputText:='Chg. Bed Height';
         SegThick         : OutputText:='Thickness';
         TidalAmp         : OutputText:='Tidal Height';
         RetTime          : OutputText:='Retention Time';
         VelocityOut      : OutputText:='Run Velocity';
         DynZMeanOut      : OutputText:='ZMean (Dynamic)';
         VelRiff          : OutputText:='Riffle Velocity';
         VelPool          : OutputText:='Pool Velocity';
         Tau              : OutputText:='Tau: Bed Shear';
         TN               : OutputText:='TN';
         TP               : OutputText:='TP';
         BODOut           : OutputText:='CBOD5';
         NH3UnIon         : OutputText:='Un-ionized NH3';
         PhytoResTime     : OutputText:='Phyto. Res. Time';
         MinNH3UnIon      : OutputText:='Min. Un-ionized NH3';
         MaxNH3UnIon      : OutputText:='Max. Un-ionized NH3';
         MinOxygen        : OutputText:='Min. Oxygen';
         MaxOxygen        : OutputText:='Max. Oxygen';
         O2Duration       : OutputText:='Oxygen Sub Thresh.';
         SteinAnim        : OutputText:='Steinhaus Animal';
         SteinPlant       : OutputText:='Steinhaus Plant';
         SteinInvert      : OutputText:='Steinhaus Invert';
         SteinAll         : OutputText:='Steinhaus All Org.';
         SOD_OUT          : OutputText:='SOD';
         InorgDep         : OutputText:='Inorg. Deposition';
         TSP_Diag         : OutputText:='P Diag. Flux';
         NO3_Diag         : OutputText:='Nitrate Diag. Flux';
         NH3_Diag         : OutputText:='Ammonia Diag. Flux';
         POP_Dep          : OutputText:='POP Deposition';
         PON_Dep          : OutputText:='PON Deposition';
         POC_Dep          : OutputText:='POC Deposition';
         CaCO3p           : OutputText:='CaCO3 Precip.';
         SaltInflow       : OutputText:='Est.Salt Inflow';
         FreshInflow      : OutputText:='Est.Fresh Inflow';
         EstEntr          : OutputText:='Est.Entrainment';
         EstUpperOut      : OutputText:='Est.Upper Outflow';
         InorgSed         : OutputText:='Inorg. Sed.';
         TSS60Day         : OutputText:='60-day avg. Inorg. Sed.';
         PctEmbedded      : OutputText:='Pct. Embeddedness';
         MeanVol          : OutputText:='Mean Volume (annual)';
         BenthicChla      : OutputText:='Benthic Chlorophyll';
         FracLitOut       : OutputText:='Frac. Littoral';
         O2FluxOut        : OutputText:='Oxygen Range';
         PctEPT           : OutputText:='Pct EPT';
         PctEphemeroptera : OutputText:='Pct Ephemeropt.';
         PctTrichoptera   : OutputText:='Pct Trichoptera';
         PctPlecoptera    : OutputText:='Pct Plecoptera';
         PctEunotia       : OutputText:='Pct Eunotia';
         PctChiro         : OutputText:='Pct Chironomid';
         GPP_Out          : OutputText:='GPP';
		     NPP_Out          : OutputText:='NPP';
         CommResp_Out     : OutputText:='Community Resp.';
         PtoR_Out         : OutputText:='P/R';
         BtoP_Out         : OutputText:='Turnover (B/P)';
         PctAmphipods     : OutputText:='Pct Amphipods';
         PFluxDiagenesis  : OutputText:='P Diag. Flux (cum.)';
         PctGastropods    : OutputText:='Pct Gastropods';
         PctBivalves      : OutputText:='Pct Bivalves';
         PctOligochaete   : OutputText:='Pct Oligochaete';
         PctDiatomsPeri   : OutputText:='Pct Diatoms Peri.';
         PctBlGrPeri      : OutputText:='Pct Cyanobacteria Peri.';
         PctGreensPeri    : OutputText:='Pct Greens  Peri.';
         PctBlGrPhyto     : OutputText:='Pct Cyanobacteria Phyto.';
         PctDiatomsPhyto  : OutputText:='Pct Diatoms Phyto.';
         PctGreensPhyto   : OutputText:='Pct Greens Phyto.';
         PctOtherPhyto    : OutputText:='Pct Other Phyto.';
         BInvt_Biomass    : OutputText:='Benthic Invt Biomass';
         PlgInvt_Biomass  : OutputText:='Pelagic Invt Biomass';
         NekInvt_Biomass  : OutputText:='Nekton Invt Biomass';
//       PInvt_Biomass    : OutputText:='Pelagic Invt Biomass';
         Fish_Biomass     : OutputText:='Fish Biomass';
       End; {Case}
     End; {If OtherOutput}

   If T=Ntrack then PreText := 'N';
   If T=Ptrack then PreText := 'P';

   If T=NIntrnl then OutputText:=ST + ' N Internal';
   If T=PIntrnl then OutputText:=ST + ' P Internal';

   If IsToxVar then
       Begin
         AO := TAddtlOutput(S);
         Case AO of
           NonDissocOut : OutputText:=PreText+' Nondissoc.';
           THalfLife    : OutputText:=PreText+' 1/2-life';
           DT50Water    : OutputText:=PreText+' DT50 Water';
           DT95Water    : OutputText:=PreText+' DT95 Water';
           Dt50Sed      : OutputText:=PreText+' DT50 Sediment';
           Dt95Sed      : OutputText:=PreText+' DT95 Sediment';
           TOrgSedPPB   : OutputText:=PreText+' Sediment';
           ToxLoading   : OutputText:=PreText+' Loading';
           TotalTox     : OutputText:=PreText+' Total tox';
           TotalToxMass : OutputText:=PreText+' Mass';
           TotTLoss     : OutputText:=PreText+' Tot Loss';
           TotalTWash   : OutputText:=PreText+' Tot Wash';
           TWashH2o     : OutputText:=PreText+' WashH2O';
           TWashAnim    : OutputText:=PreText+' WashAnim';
           TWashDetr    : OutputText:=PreText+' WashDetr';
           TWashPlant   : OutputText:=PreText+' WashPlnt';
           TWashSed     : OutputText:=PreText+' WashSedm';
           THydrol      : OutputText:=PreText+' Hydrol';
           TPhotol      : OutputText:=PreText+' Photol';
           TVolatil     : OutputText:=PreText+' Volatil';
           TMicrobMet   : OutputText:=PreText+' MicrobMet';
           TBioTrans    : OutputText:=PreText+' BioTrans';
           TEmergeI     : OutputText:=PreText+' EmergeI';
           TLossandMass : OutputText:=PreText+' Loss+Mass';
           TBuryOOS     : OutputText:=PreText+' DeepBurial';
           TTotOOSLoad  : OutputText:=PreText+' Tot Load';
           TLoadH2O     : OutputText:=PreText+' H2O Load';
           TLoadSed     : OutputText:=PreText+' Sed Load';
           TLoadDetr    : OutputText:=PreText+' Detr Load';
           TLoadBiota   : OutputText:=PreText+' Biota Load';
           TMBTest      : OutputText:=PreText+' MBTest';
           TSink        : OutputText:=PreText+' Net Sink';
           TEntrain     : OutputText:=PreText+' Net Entrain';
           TTurbdiff    : OutputText:=PreText+' Net TurbDiff';
           TMigrate     : OutputText:=PreText+' Net Migrate';
           TNetLayer    : OutputText:=PreText+' Net LayerExch';
           TFishing     : OutputText:=PreText+' Fishing Loss';
           TDeltaThick  : OutputText:=PreText+' Delta Thick';
           BirdConc     : OutputText:=PreText+' Birds etc.';
           MultiFishPPB     : OutputText:=PreText+' Mult-Fish';
           TotNMass         : OutputText:=PreText+' Tot. Mass';
           BoundaryCond : OutputText:=PreText+' Boundary Cond.';   {PER TIME STEP}
           TotNLoss: OutputText:=PreText+' Tot. Loss';
           TotalNWash: OutputText:=PreText+' Tot. Washout';
           NWashH2o: OutputText:=PreText+' Wash. Dissolved';
           NWashAnim: OutputText:=PreText+' Wash. Animals';
           NWashDetr: OutputText:=PreText+' Wash. Detritus';
           NWashPlant: OutputText:=PreText+' Wash. Plants';
           NEmergeI: OutputText:=PreText+' Loss EmergeI';
           NDenitr: OutputText:=PreText+' Loss Denitrif.';
           NBurial: OutputText:=PreText+' Burial';
           NFishing: OutputText:=PreText+' Loss Fishing';
           NTotLoad: OutputText:=PreText+' Tot. Load';
           NLoadDissH2O: OutputText:=PreText+' Load, Dissolved';
           NLoadDetr: OutputText:=PreText+' Load as Detritus';
           NLoadBiota: OutputText:=PreText+' Load as Biota';
           NPWMacro: OutputText:=PreText+' Root Uptake';
           NFixation: OutputText:=PreText+' Fixation';
           NMBTest: OutputText:=PreText+' MB Test';
           NExposure: OutputText:=PreText+' Exposure';
           NLSink: OutputText:=PreText+' Net Layer Sink';
           NLTDiff: OutputText:=PreText+' Net TurbDiff';
           NLMigr: OutputText:=PreText+' Net Layer Migr.';
           NLayerNet: OutputText:=PreText+' Total Net Layer';
           NDissWater: OutputText:=PreText+' Mass Dissolved';
           NDetr: OutputText:=PreText+' Mass Susp. Detritus';
           NAnimals: OutputText:=PreText+' Mass Animals';
           NPlants: OutputText:=PreText+' Mass Plants';
           NSediment: OutputText:=PreText+' Mass Bottom Sed.';
           NSorbCaCO3: OutputText:=PreText+' Sorb CaCO3';
         End; {Case}
       End; {Else}

   Case BAFVar of
     1 : OutputText := 'BAF Lipid '+Result;
     2 : OutputText := 'BAF wet '+Result;
     3 : OutputText := 'K1 '+Result;
     4 : OutputText := 'K2 '+Result;
     5 : OutputText := 'BCF '+Result;
     6 : OutputText := 'N to Org '+Result;
     7 : OutputText := 'P to Org '+Result;
   End; {Case}
End;  {Function OutputText}


Procedure DefaultControlInfo(Var C: Control_Opt_Rec);
{*************************************}
{ Reset the Control Setup Record that }
{ Is Passed to this procedure to its  }
{ default status.                     }
{ coded by JSC                        }
{*************************************}

  Procedure DefaultSubControlInfo(Var S: Control_Opt_SubRec; Res:Boolean);
  Begin
   S.OmitInflow:=Res; S.OmitPS:=Res;     S.OmitDP:=Res;
   S.OmitNPS:=Res;    S.SetMult:=Res;    S.ZeroInitCond:=Res;
   S.OmitTox:=Res;    S.OmitBuried:=Res;
  End;

Begin
  DefaultSubControlInfo(C.Tox,True);
  DefaultSubControlInfo(C.Nutrient,False);
  DefaultSubControlInfo(C.Sediment,False);
  DefaultSubControlInfo(C.Detritus,False);
End;



{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}
{                                                                         }
{      NUMERICAL AND STRING MANIPULATION UTILITIES FROM HERE DOWN         }
{                                                                         }
{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}



Function RoundDec(I: Integer; J: double):double;
{Rounds a Function to I decimals}

Var Mult: Longint;
    Loop: Integer;
Begin
    Mult:=1;
    if I>0 then For Loop:=1 to I do Mult:=Mult*10;
    If J*Mult < 1E9
       then RoundDec:=Round(J*Mult)/Mult
       Else RoundDec:=Int(J);
End;

Function JulianDate(Indate: TDateTime): LongInt;
{Given a delphi TDATETIME, Returns the Julian Date (# of days passed in the year)}

var inday,inmonth,inyear: Word;
    first_day_of_year: TDateTime;

Begin
   DecodeDate(Indate,inyear,inmonth,inday);
   First_day_of_year:=EncodeDate(Inyear,1,1);
   JulianDate:=Trunc(InDate - First_day_of_year)+1;
End;


Function GetDataName(InStr: ShortString):ShortString;
{Abridges a string to what appears inside the []}
Var
  indx,startindx: integer;
  Finished: Boolean;
  started: Boolean;
  OutStr: string[255];

begin
  Finished:=false;
  started:=false;
  indx:=0;
  startindx:=1;
  Repeat      {Add Chars Between Brackets to Outstr one Chr at a time.}
     inc(indx);
     If started then OutStr[startindx]:=InStr[indx];
     if started then inc(startindx);
     If Instr[indx]='[' then started:=true;
     if indx=Length(InStr) then Finished:=true
                        else if InStr[indx+1]=']' then Finished:=true;
  until Finished;

  OutStr[0]:=chr(startindx-1);
  GetDataName:=OutStr;
End; {GetDataName}


Function CleanFileName(InStr: String): String;  {Remove double slashes from file names}
Var i: Integer;
    wasslash: Boolean;
Begin
  Result := '';
  WasSlash := False;
  For i := 1 to Length(Instr) do
    Begin
      If (InStr[i] = '\') and WasSlash then Continue;
      Result := Result + InStr[i];
      WasSlash := (InStr[i] = '\');
    End;
End;


Function AbbrString(InStr: ShortString; DelimChar: Char):ShortString;
{Abridges a String to what appears before the DELIMCHAR
 Useful in File management, StateVar Name management.  JonC}
Var
 indx: integer;
 Finished: boolean;
 OutStr: string[255];

Begin
  Finished:=false;
  indx:=0;
  Repeat      {Add Chars one at a time until period is encountered
               or the end of the string is reached}
     inc(indx);
     OutStr[indx]:=InStr[indx];
  if indx=Length(InStr) then Finished:=true
                        else if InStr[indx+1]=DelimChar then Finished:=true;
  until Finished;

  OutStr[0]:=chr(indx);
  AbbrString:=OutStr;
End; {AbbrString}


Procedure ProcessDBFName(Var N: String; P: Pointer);
{ This procedure takes a DBF name and makes it legal.
  Illegal characters are killed, the name is limited to 10 characters, the name
  is checked against P, a pointer to a TStringlist with other names.  It is
  modified if it already exists within the list }
Var Loop, Instances: Integer;
    Duplicates: Boolean;
    TS         : TStrings;
Begin
  For Loop:=1 to Length(N) do
    If N[Loop] in [' ','/','(',')','\','-','&',',',':','.']
      Then N[Loop] := '_';

  N := Uppercase(N);
  If Length(N)>10 then SetLength(N,10);

  Instances := 0;
  Repeat
    Duplicates := False;

    TS := TStrings(P^);

    For Loop:=1 to TS.Count-1 do
      If Pos('"'+N+'"',TS.Strings[Loop])>0
        Then Begin
               Duplicates := True;
               Inc(Instances);
               N[Length(N)]:=Chr((Instances Mod 10) + 48);
               If (Instances>9) then N[Length(N)-1] := Chr((Instances Div 10) + 48);
             End;
  Until Not Duplicates
End;


{BELOW CODE USED FOR TIMING PROFILE ANALYSIS, JSC}

Constructor TTiming.Create;
Var Loop: Integer;
Begin
  For Loop:=1 to 10 do
    begin
       Times[Loop]:=0;
       TimeStarts[Loop]:=0;
    end;
end;

Procedure TTiming.StartTime(Index: Integer);
Begin
     TimeStarts[Index]:=GetTickCount;
End;

Procedure TTiming.StopTime(Index: Integer);
Begin
     Times[Index]:=Times[Index]+GetTickCount-TimeStarts[Index];
End;

Function AQTCopyFile(Src,Dst: String): Boolean;
{Copy a file from the source to the destination paths indicated,
 Copied out of Delphi Help under BlockRead}

Var Source,Dest: File;
    NumRead,NumWritten: Integer;
    Buf: array[1..2048] of Char;

Begin
  AQTCopyFile:=True;
     Try
         AssignFile(Source,Src);
         AssignFile(Dest,Dst);
         Reset(Source,1);
         Rewrite(Dest,1);
         Repeat
           Blockread(Source,Buf,Sizeof(Buf),NumRead);
           Blockwrite(Dest,Buf,NumRead,NumWritten);
         Until (NumRead=0) or (NumWritten<>NumRead);
         System.CloseFile(Source);
         System.CloseFile(Dest);
      Except
         MessageDlg('File Copy Error:  '+src+'  to  '+dst,mterror,[mbOK],0);
         AQTCopyFile:=False;
      end; {try}
End;

Constructor TUncertDraw.Init(Val,RD:Double;Int:LongInt);
Begin
  Value:=Val;
  IntervalNum:=Int;
  RandomDraw:=Rd;
End;



Begin
{  Timer:=TTiming.Create; }
End.




