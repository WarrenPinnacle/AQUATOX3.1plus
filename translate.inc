//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
{PROCEDURES USED FOR TRANSLATING OLDER AQUATOX VERSIONS, JSC 4-5-99}
{UPDATED for expanded comment fields, JSC 2-9-2009}

Type

  OldZooRecord =
    packed record {d4-5}
      AnimalName          : refString;
      ToxicityRecord      : string[15];
      FHalfSat            : Double;
      XFHalfSat           : refstring;
      CMax                : Double;      {max consumption}
      XCMax               : refstring;
      BMin                : Double;
      XBMin               : refstring;
      Q10                 : Double;
      XQ10                : refstring;
      TOpt                : Double;
      XTOpt               : refstring;
      TMax                : Double;
      XTMax               : refstring;
      TRef                : Double;
      XTRef               : refstring;
      EndogResp           : Double;
      XEndogResp          : refstring;
      KResp               : Double;
      XKResp              : refstring;
      KExcr               : Double;
      XKExcr              : refstring;
      PctGamete           : Double;
      XPctGamete          : refstring;
      GMort               : Double;
      XGMort              : refstring;
      KMort               : Double;     {Mortality Coefficient}
      XKMort              : refstring;
      Placeholder         : Double;     { Not Used, Takes the place of EMort }
      XPlaceHolder        : refstring;
      KCap                : Double;
      XKCap               : refstring;
      MeanWeight          : Double;
      XMeanWeight         : refstring;
      FishFracLipid       : Double;
      XFishFracLipid      : refstring;
      LifeSpan            : Double;      { Mean Lifespan in days }
      XLifeSpan           : refstring;
      Animal_Type         : string[15];
      AveDrift            : Double;
      XAveDrift           : refstring;   {Background Drift}
      {V185 Additions Below}
      AutoSpawn           : Boolean;     {Calc Spawn Automatically based on Temps?}

      SpawnDate1          : TDateTime;
      SpawnDate2          : TDateTime;
      SpawnDate3          : TDateTime;
      XSpawnDate          : refstring;
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
      XFracInWaterCol     : refstring;
      Guild_Taxa          : string[15];

      PrefRiffle          : Double;
      XPrefRiffle         : RefString;
      PrefPool            : Double;
      XPrefPool           : RefString;
      VelMax              : Double;
      XVelMax             : RefString;
      XAllomConsumpt      : RefString;
      XAllomResp          : RefString;

            {ESTUARY ADDITIONS BELOW}
      {Salinity & Ingestion}
      Salmin_Ing,         {minimum salinity tolerance 0/00}
      SalMax_Ing,         {max salinity tolerance 0/00}
      Salcoeff1_Ing,
      Salcoeff2_Ing       : Double; {unitless}
      XSalinity_Ing       : refstring;
      {Salinity & Gameteloss}
      Salmin_Gam,         {minimum salinity tolerance 0/00}
      SalMax_Gam,         {max salinity tolerance 0/00}
      Salcoeff1_Gam,
      Salcoeff2_Gam       : Double; {unitless}
      XSalinity_Gam       : refstring;
      {Salinity & Respiration}
      Salmin_Rsp,         {minimum salinity tolerance 0/00}
      SalMax_Rsp,         {max salinity tolerance 0/00}
      Salcoeff1_Rsp,
      Salcoeff2_Rsp       : Double; {unitless}
      XSalinity_Rsp       : refstring;
      {Salinity & Mortility}
      Salmin_Mort,         {minimum salinity tolerance 0/00}
      SalMax_Mort,         {max salinity tolerance 0/00}
      Salcoeff1_Mort,
      Salcoeff2_Mort       : Double; {unitless}
      XSalinity_Mort       : refstring;

      Fishing_Frac         : Double;    {fraction / day}
      XFishing_Frac        : refstring;

      UNUSED_Pct_Habitat   : Double;
      UNUSED_XPct_Habitat  : refstring;

      P2Org                : Double;
      XP2Org               : refstring;
      N2Org                : Double;
      XN2Org               : refstring;

      Wet2Dry              : Double;
      XWet2Dry             : refstring;

      O2_LethalConc        : Double;
      O2_LethalPct         : Double;
      O2_LCRef             : RefString;

      O2_EC50growth        : Double;
      XO2_EC50growth       : RefString;
      O2_EC50repro         : Double;
      XO2_EC50repro        : RefString;

      Ammonia_LC50         : Double;
      XAmmonia_LC50        : RefString;

      Sorting              : Double;    {3.46, SABS}
      XSorting             : RefString;
      SuspSedFeeding       : Boolean;
      XSuspSedFeeding      : RefString;
      SlopeSSFeed          : Double;
      XSlopeSSFeed         : RefString;
      InterceptSSFeed      : Double;
      XInterceptSSFeed     : RefString;

      SenstoSediment       : RefString;
      XSensToSediment      : RefString;
      Trigger              : Double;
      XTrigger             : RefString;

      SenstoPctEmbed       : Boolean;   {3-6-2008}
      PctEmbedThreshold    : Double;
      XPctEmbedThreshold   : RefString;

      BenthicDesignation   : RefString; {10/24/08 Benthic Metric Designation}

      PlaceHolderD1        : Double;
      PlaceHolderD2        : Double;
      PlaceHolderD3        : Double;
    end;


  OLDChemicalRecord =  packed record
      ChemName             : RefString;
      CASRegNo             : String[20];
      MolWt                : Double;
      Solubility           : Double;
      XSolubility          : RefString;
      Henry                : Double;
      XHenry               : RefString;
      pka                  : Double;
      Xpka                 : RefString;
      VPress               : Double;
      XVPress              : RefString;
      LogKow               : Double; {Log KOW, log octanol water part. coeff.}
      XLogKow              : RefString;
      En                   : Double; {Activation Energy for Temperature}
      XEn                  : RefString;
      KMDegrdn             : Double;
      XKMDegrdn            : RefString;
      KMDegrAnaerobic      : Double;
      XKMDegrAnaerobic     : RefString;
      KUnCat               : Double;
      XKUncat              : RefString;
      KAcid                : Double;
      XKAcid               : RefString;
      KBase                : Double;
      XKBase               : RefString;
      PhotolysisRate       : Double;
      XPhotoLysisRate      : RefString;
      OxRateConst          : Double;
      XOxRateConst         : RefString;

      KPSed                : Double;
      XKPSed               : RefString;
      Weibull_Shape        : Double;
      XWeibull_Shape       : RefString;
      ChemIsBase           : Boolean;
      CalcKPSed            : Boolean;

      CohesivesK1          : Double;
      CohesivesK2          : Double;
      CohesivesKp          : Double;
      CohesivesRef         : RefString;
      NonCohK1             : Double;
      NonCohK2             : Double;
      NonCohKp             : Double;
      NonCohRef            : RefString;
      NonCoh2K1            : Double;
      NonCoh2K2            : Double;
      NonCoh2Kp            : Double;
      NonCoh2Ref           : RefString;

            {PFA Parameters}
      IsPFA                : Boolean;
      PFAType              : String[12];
      PFAChainLength       : Double;
      XPFAChainLength      : RefString;
      PFASedKom            : Double;
      XPFASedKom           : RefString;
      PFAAlgBCF            : Double;
      XPFAAlgBCF           : RefString;
      PFAMacroBCF          : Double;
      XPFAMacroBCF         : RefString;

      WeibullSlopeFactor   : Double;
      XWeibullSlopeFactor  : RefString;

      PlaceholderD1        : Double;  {place holders so additional parameters do not require storload mods}
      PlaceholderD2        : Double;
      PlaceholderD3        : Double;
      PlaceholderD4        : Double;
      PlaceholderR1        : RefString;
      PlaceholderR2        : RefString;
      PlaceholderR3        : RefString;
      PlaceholderR4        : RefString;
      PlaceholderB1        : Boolean;
      PlaceholderB2        : Boolean;
   End;

  OldReminRecord =
    packed record
      RemRecName    : RefString;
      DecayMax_Lab  : Double;
      XDecayMax_Lab : RefString;
      Q10_NotUsed   : Double;
      XQ10          : RefString;
      TOpt          : Double;
      XTOpt         : RefString;
      TMax          : Double;
      XTMax         : RefString;
      TRef_NotUsed  : Double;
      XTRef         : RefString;
      pHMin         : Double;
      XpHMin        : RefString;
      pHMax         : Double;
      XpHMax        : RefString;
      P2OrgLab      : Double;
      N2OrgLab      : Double;
      PlaceHolder   : Double; {Was Org2 Nitrate}
      XP2OrgLab     : RefString;
      XN2OrgLab     : RefString;
      O2Biomass     : Double;
      XO2Biomass    : RefString;
      O2N           : Double;
      XO2N          : RefString;
      KSed          : Double;
      XKsed         : RefString;
      PSedRelease_NotUsed   : Double;
      XPSedrelease  : RefString;
      NSedRelease_NotUsed   : Double;
      XNSedRelease  : RefString;
      DecayMax_Refr : Double;    {g/g d}
      XDecayMax_Refr: RefString;

      {ESTUARY ADDITIONS BELOW}
      KSedTemp            : Double;
      XKSedTemp           : RefString;
      KSedSalinity        : Double;
      XKSedSalinity       : RefString;
      {ESTUARY ADDITIONS Above}

      P2Org_Refr     : Double;
      XP2Org_Refr    : RefString;
      N2Org_Refr     : Double;
      XN2Org_Refr    : RefString;
      Wet2DryPRefr   : Double;
      XWet2DryPRefr  : RefString;
      Wet2DryPLab    : Double;
      Xet2DryPLab    : RefString;
      Wet2DrySRefr   : Double;
      XWet2DrySRefr  : RefString;
      Wet2DrySLab    : Double;
      XWet2DrySLab   : RefString; {1216}
      N2OrgDissLab   : Double;
      XN2OrgDissLab  : RefString;
      P2OrgDissLab   : Double;
      XP2OrgDissLab  : RefString;
      N2OrgDissRefr  : Double;
      XN2OrgDissRefr : RefString;
      P2OrgDissRefr  : Double;
      XP2OrgDissRefr : RefString;

      KD_P_Calcite   : Double;     {Sorption of P to CaCO3, L/Kg}
      XKD_P_Calcite  : RefString;

      BOD5_CBODu     : Double;
      XBOD5_CBODu    : RefString;

      PlaceholderD1  : Double;  {place holders so additional parameters do not require storload mods}
      PlaceholderD2  : Double;
      PlaceholderD3  : Double;
      PlaceholderR1  : RefString;
      PlaceholderR2  : RefString;
      PlaceholderR3  : RefString;
      PlaceholderB1  : Boolean;
      PlaceholderB2  : Boolean;

    end;



  OldPlantRecord =
    packed record
      PlantName           : RefString;
      PlantType           : string[15];
      ToxicityRecord      : string[15];
      EnteredLightSat     : Double;
      XLightSat           : RefString;
      KPO4                : Double;
      XKPO4               : RefString;
      KN                  : Double;    {n half Sat}
      XKN                 : RefString;
      KCarbon             : Double;
      XKCarbon            : RefString;
      Q10                 : Double;
      XQ10                : RefString;
      TOpt                : Double;
      XTOpt               : RefString;
      TMax                : Double;
      XTMax               : RefString;
      TRef                : Double;
      XTRef               : RefString;
      PMax                : Double;
      XPMax               : RefString;
      KResp               : Double;
      XKResp              : RefString;
      KMort               : Double;
      XKMort              : RefString;
      EMort               : Double;
      XEMort              : RefString;
      KSed                : Double;
      XKSed               : RefString;
      ESed                : Double;
      XESed               : RefString;
      P2Org               : Double;
      XP2Org              : RefString;   f29,f30: Byte; {d4-5}
      N2Org               : Double;
      XN2Org              : RefString;   f31,f32: Byte; {d4-5}
      ECoeffPhyto         : Double;
      XECoeffPhyto        : RefString;
      CarryCapac          : Double;
      XCarryCapac         : RefString;
      Red_Still_Water     : Double;
      XRed_Still_Water    : RefString;
      Macrophyte_Type     : string[15];
      Macro_Drift         : Double;
      Taxonomic_Type      : string[15];
      PrefRiffle          : Double;
      XPrefRiffle         : RefString;
      PrefPool            : Double;
      XPrefPool           : RefString;
      FCrit               : Double;
      XFCrit              : RefString;
      Macro_VelMax        : Double;
      XVelMax             : RefString;
            {ESTUARY ADDITIONS BELOW}
      KSedTemp            : Double;
      XKSedTemp           : RefString;
      KSedSalinity        : Double;
      XKSedSalinity       : RefString;
      {Salinity & Photosynthesis}
      Salmin_Phot,         {minimum salinity tolerance 0/00}
      SalMax_Phot,         {max salinity tolerance 0/00}
      Salcoeff1_Phot,
      Salcoeff2_Phot        : Double; {unitless}
      XSalinity_Phot       : RefString;
      {Salinity & Mortility}
      Salmin_Mort,         {minimum salinity tolerance 0/00}
      SalMax_Mort,         {max salinity tolerance 0/00}
      Salcoeff1_Mort,
      Salcoeff2_Mort       : Double; {unitless}
      XSalinity_Mort       : RefString;

      Wet2Dry              : Double;
      XWet2Dry             : RefString;

      Resp20              : Double;
      XResp20             : RefString;

      PctSloughed          : Double;
      XPctSloughed         : RefString;

      UseAdaptiveLight     : Boolean;
      MaxLightSat          : Double;
      XMaxLightSat         : RefString;
      MinLightSat          : Double;
      XMinLightSat         : RefString;

      PlaceholderB2        : Boolean;  {1900 to here}
   end;

  OldSiteRecord =
    packed record
      SiteName             : RefString;
      ECoeffWater          : Double;
      SiteLength           : Double;   {units are KM}
      XLength              : RefString;
      StaticVolume         : Double;
      XVolume              : RefString;
      SurfArea             : Double;
      XSurfArea            : RefString;
      ICZMean              : Double;
      XZMean               : RefString;
      ZMax                 : Double;
      XZMax                : RefString;
      TempMean             : Array[VerticalSegments] of Double;
      XTempMean            : Array[VerticalSegments] of RefString;
      TempRange            : Array[VerticalSegments] of Double;
      XTempRange           : Array[VerticalSegments] of RefString;
      Latitude             : Double;
      XLatitude            : RefString;
      LightMean            : Double;
      XLightMean           : RefString;
      LightRange           : Double;
      XLightRange          : RefString;
      AlkCaCO3             : Double;
      XAlkCaCO3            : RefString;
      HardCaCO3            : Double;
      XHardCaCO3           : RefString;
      SiteComment          : string[255];
      SO4ConC              : Double;
      XSO4Conc             : RefString;
      TotalDissSolids      : Double;
      XTotalDissSolids     : RefString;
      StreamType           : string[20];
      Channel_Slope        : Double;
      XChannel_Slope       : RefString;
      Max_Chan_Depth       : Double;
      XMax_Chan_Depth      : RefString;
      SedDepth             : Double;
      XSedDepth            : RefString;
      EnclWallArea         : Double;
      XEnclWallArea        : RefString;
      MeanEvap             : Double;       {inches / year}
      XMeanEvap            : RefString;
      UseEnteredManning    : Boolean;
      EnteredManning       : Double;
      XECoeffWater         : RefString;

      PctRiffle            : Double;
      XPctRiffle           : RefString;
      PctPool              : Double;
      XPctPool             : RefString;

      UseBathymetry        : Boolean;

      ts_clay              : Double;  { clay critical shear stress for scour [kg/m2] }
      Xts_clay             : RefString;
      ts_silt              : Double;  { silt critical shear stress for scour [kg/m2] }
      Xts_silt             : RefString;
      tdep_clay            : Double;   { clay critical shear stress for deposition [kg/m2] }
      Xtdep_clay           : RefString;
      tdep_silt            : Double;   { silt critical shear stress for deposition [kg/m2] }
      Xtdep_silt           : RefString;
      FallVel_clay         : Double;  { clay fall velocity, m/s}
      XFallVel_clay        : RefString;
      FallVel_silt         : Double;  { silt fall velocity, m/s}
      XFallVel_silt        : RefString;

     {ESTUARY ADDITIONS BELOW}

      SiteWidth            : Double;
      XSiteWidth           : RefString;

  {m2} amplitude1 : Double; k1: Double; ConstRef1: RefString;
  {s2} amplitude2 : Double; k2: Double; ConstRef2: RefString;
  {n2} amplitude3 : Double; k3: Double; ConstRef3: RefString;
  {k1} amplitude4 : Double; k4: Double; ConstRef4: RefString;
  {o1} amplitude5 : Double; k5: Double; ConstRef5: RefString;
 {SSA} amplitude6 : Double; k6: Double; ConstRef6: RefString;
  {SA} amplitude7 : Double; k7: Double; ConstRef7: RefString;
  {P1} amplitude8 : Double; k8: Double; ConstRef8: RefString;

      Min_Vol_Frac         : Double;
      XMin_Vol_Frac        : RefString;

      WaterShedArea        : Double;
      XWaterShedArea       : RefString;
      EnterTotalLength     : Boolean;
      TotalLength          : Double;
      XTotalLength         : RefString; {3.43}

      ECoeffSED            : Double;
      XECoeffSED           : RefString;
      ECoeffDOM            : Double;
      XECoeffDOM           : RefString;
      ECoeffPOM            : Double;
      XECoeffPOM           : RefString;  {3.44}

      UseCovar             : Boolean;
      EnteredKReaer        : Double;
      XEnteredKReaer       : RefString;
      UsePhytoRetention    : Boolean;

      BasePercentEmbed     : Double;     {3-6-2008}
      XBasePercentEmbed    : RefString;

      Altitude             : Double;     {12/27/2008}  {3.60}
      XAltitude            : RefString;

      PlaceholderN1        : Double;
      PlaceholderR1        : RefString;
    end;



Function UpdateNState(ns: AllVariables; ReadVers: Double):AllVariables;
Var Order: Integer;
    Answer: Integer;
Begin
  Order := Ord(ns);
  Answer := Order;

  If ReadVers < 3.10 then
    Begin
      If (ReadVers > 1.5) and (ReadVers<2.58) then
        Begin
          If (Order > 19) and (Order < 28) then Answer := Answer -3;
          If (Order > 31) and (Order < 40) then Answer := Answer +4;
          If (Order > 39) and (Order < 50) then Answer := 35;
          If (Order > 49) and (Order < 52) then Answer := Answer -6;
          If (Order > 51) and (Order < 54) then Answer := Answer -2;
          If (Order > 53) and (Order < 56) then Answer := Answer +2;
          If (Order > 55) and (Order < 60) then Answer := Answer +6;
          If (Order > 59) then Answer := Answer + 10;
        End;

      If (ReadVers > 2.58) then
        Begin
          If (Order > 19) and (Order < 28) then Answer := Answer -3;
          If (Order > 31) and (Order < 40) then Answer := Answer +4;
          If (Order > 39) and (Order < 50) then Answer := 35;
          If (Order > 49)                  then Answer := Answer -6;
        End;
    End;

  IF (ReadVers < 3.39) and (AllVariables(Answer)>TSS) then Answer := Answer+15;
     {make way for sed diagenesis vars.}

  UpdateNState := AllVariables(Answer);
End;


Procedure TranslateAlgalRec(Var St: TStream; ReadVers: Double; Var AlgRec: OldPlantRecord; NST: AllVariables);
Var Junk: Double;
    NYU1: String[15];
    NYU2: Double;
Begin
  If (ReadVers > 1.99) and (ReadVers<2.99) then with AlgRec do
    Begin
      St.Read(PlantName,Sizeof(PlantName));
      St.Read(PlantType,Sizeof(PlantType));
      St.Read(ToxicityRecord,Sizeof(ToxicityRecord)); St.Read(Junk,2);
      St.Read(EnteredLightSat,Sizeof(EnteredLightSat));
      St.Read(XLightSat,Sizeof(XLightSat)); St.Read(Junk,2);
      St.Read(KPO4,Sizeof(KPO4));
      St.Read(XKPO4,Sizeof(XKPO4));         St.Read(Junk,2);
      St.Read(KN,Sizeof(KN));
      St.Read(XKN,Sizeof(XKN));             St.Read(Junk,2);
      St.Read(KCarbon,Sizeof(KCarbon));
      St.Read(XKCarbon,Sizeof(XKCarbon));   St.Read(Junk,2);
      St.Read(Q10,Sizeof(Q10));
      St.Read(XQ10,Sizeof(XQ10));           St.Read(Junk,2);
      St.Read(TOpt,Sizeof(TOpt));
      St.Read(XTOpt,Sizeof(XTOpt));         St.Read(Junk,2);
      St.Read(TMax,Sizeof(TMax));
      St.Read(XTMax,Sizeof(XTMax));         St.Read(Junk,2);
      St.Read(TRef,Sizeof(TRef));
      St.Read(XTRef,Sizeof(XTRef));         St.Read(Junk,2);
      St.Read(PMax,Sizeof(PMax));
      St.Read(XPMax,Sizeof(XPMax));         St.Read(Junk,2);
      St.Read(KResp,Sizeof(KResp));
      St.Read(XKResp,Sizeof(XKResp));       St.Read(Junk,2);
      St.Read(KMort,Sizeof(KMort));
      St.Read(XKMort,Sizeof(XKMort));       St.Read(Junk,2);
      St.Read(EMort,Sizeof(EMort));
      St.Read(XEMort,Sizeof(XEMort));       St.Read(Junk,2);
      St.Read(KSed,Sizeof(KSed));
      St.Read(XKSed,Sizeof(XKSed));         St.Read(Junk,2);
      St.Read(ESed,Sizeof(ESed));
      St.Read(XESed,Sizeof(XESed));         St.Read(Junk,2);
      St.Read(P2Org,Sizeof(P2Org));
      St.Read(XP2Org,Sizeof(XP2Org));       St.Read(Junk,2);
      St.Read(N2Org,Sizeof(N2Org));
      St.Read(XN2Org,Sizeof(XN2Org));       St.Read(Junk,2);
      St.Read(ECoeffPhyto,Sizeof(ECoeffPhyto));
      St.Read(XECoeffPhyto,Sizeof(XECoeffPhyto));      St.Read(Junk,2);
      St.Read(CarryCapac,Sizeof(CarryCapac));
      St.Read(XCarryCapac,Sizeof(XCarryCapac));        St.Read(Junk,2);
      St.Read(Red_Still_Water,Sizeof(Red_Still_Water));
      St.Read(XRed_Still_Water,Sizeof(XRed_Still_Water));
      St.Read(NYU1,Sizeof(NYU1));            St.Read(Junk,2);
      St.Read(NYU2,Sizeof(NYU2));
      St.Read(Taxonomic_Type,Sizeof(Taxonomic_Type));
      St.Read(PrefRiffle,Sizeof(PrefRiffle));
      St.Read(XPrefRiffle,Sizeof(XPrefRiffle));
      St.Read(PrefPool,Sizeof(PrefPool));
      St.Read(XPrefPool,Sizeof(XPrefPool));
      St.Read(FCrit,Sizeof(FCrit));
      St.Read(XFCrit,Sizeof(XFCrit));
      St.Read(Macro_VelMax,Sizeof(Macro_VelMax));
      St.Read(XVelMax,Sizeof(XVelMax));

      If ReadVers<2.575
         Then
           Case nst of
             FirstDiatom..LastDiatom:    Begin  Resp20:= 0.08;  XResp20:= 'Riley and von Aux, 1949, cited in C.& W.1983'; end;
             Firstgreens..Lastgreens:    Begin  Resp20:= 0.10;  XResp20:='Laws and Wong, 1978, per Collins and Wl. 1983'; end;
             Firstblgreen..Lastblgreen:  Begin  Resp20:= 0.20;  XResp20:='Collins, 1980'; end;
             FirstMacro..LastMacro:      Begin  Resp20:= 0.024; XResp20:='LeCren and Lowe-McConnell, 1980, p. 195'; end;
                     else {other}        Begin  Resp20:= 0.050; XResp20:='Smith, 1979, cited Collins and Wlosinski 1983'; end;
           End;

     Wet2Dry:= 5.0;
     XWet2Dry:= '<--- default';

      If ReadVers>2.505 then
         Begin
          st.read(Wet2Dry,sizeof(Double));
          st.read(XWet2Dry,sizeof(RefString));
          st.read(Resp20,sizeof(Double));
          st.read(XResp20,sizeof(RefString));
         End;

      Macro_Drift := 0;
      KSedTemp            := 0;
      XKSedTemp           := 'placeholder';
      KSedSalinity        := 0;
      XKSedSalinity       := 'placeholder';
      Salmin_Phot         := 0;
      SalMax_Phot         := 0;
      Salcoeff1_Phot      := 0;
      Salcoeff2_Phot      := 0; {unitless}
      XSalinity_Phot      := 'placeholder';
      Salmin_Mort         := 0; {unitless}
      SalMax_Mort          := 0; {unitless}
      Salcoeff1_Mort       := 0; {unitless}
      Salcoeff2_Mort       := 0; {unitless}
      XSalinity_Mort       := 'placeholder';
    End;
End;


Procedure TranslateAlgalRec2(Var OPR: OldPlantRecord; Var NPR: PlantRecord);
Begin
      NPR.PlantName := OPR.PlantName;
      NPR.PlantType := OPR.PlantType;
      NPR.ToxicityRecord := OPR.ToxicityRecord;
      NPR.EnteredLightSat := OPR.EnteredLightSat;
      NPR.XLightSat := OPR.XLightSat;
      NPR.KPO4 := OPR.KPO4;
      NPR.XKPO4 := OPR.XKPO4;
      NPR.KN := OPR.KN;
      NPR.XKN := OPR.XKN;
      NPR.KCarbon := OPR.KCarbon;
      NPR.XKCarbon := OPR.XKCarbon;
      NPR.Q10 := OPR.Q10;
      NPR.XQ10 := OPR.XQ10;
      NPR.TOpt := OPR.TOpt;
      NPR.XTOpt := OPR.XTOpt;
      NPR.TMax := OPR.TMax;
      NPR.XTMax := OPR.XTMax;
      NPR.TRef := OPR.TRef;
      NPR.XTRef := OPR.XTRef;
      NPR.PMax := OPR.PMax;
      NPR.XPMax := OPR.XPMax;
      NPR.KResp := OPR.KResp;
      NPR.XKResp := OPR.XKResp;
      NPR.KMort := OPR.KMort;
      NPR.XKMort := OPR.XKMort;
      NPR.EMort := OPR.EMort;
      NPR.XEMort := OPR.XEMort;
      NPR.KSed := OPR.KSed;
      NPR.XKSed := OPR.XKSed;
      NPR.ESed := OPR.ESed;
      NPR.XESed := OPR.XESed;
      NPR.P2OrgInit := OPR.P2Org;
      NPR.XP2Org := OPR.XP2Org;
      NPR.N2OrgInit := OPR.N2Org;
      NPR.XN2Org := OPR.XN2Org;
      NPR.ECoeffPhyto := OPR.ECoeffPhyto;
      NPR.XECoeffPhyto := OPR.XECoeffPhyto;
      NPR.CarryCapac := OPR.CarryCapac;
      NPR.XCarryCapac := OPR.XCarryCapac;
      NPR.Red_Still_Water := OPR.Red_Still_Water;
      NPR.XRed_Still_Water := OPR.XRed_Still_Water;
      NPR.Macrophyte_Type := OPR.Macrophyte_Type;
      NPR.Macro_Drift := OPR.Macro_Drift;
      NPR.Taxonomic_Type := OPR.Taxonomic_Type;
      NPR.PrefRiffle := OPR.PrefRiffle;
      NPR.XPrefRiffle := OPR.XPrefRiffle;
      NPR.PrefPool := OPR.PrefPool;
      NPR.XPrefPool := OPR.XPrefPool;
      NPR.FCrit := OPR.FCrit;
      NPR.XFCrit := OPR.XFCrit;
      NPR.Macro_VelMax := OPR.Macro_VelMax;
      NPR.XVelMax := OPR.XVelMax;
      NPR.KSedTemp := OPR.KSedTemp;
      NPR.XKSedTemp := OPR.XKSedTemp;
      NPR.KSedSalinity := OPR.KSedSalinity;
      NPR.XKSedSalinity := OPR.XKSedSalinity;
      NPR.Salmin_Phot := OPR.Salmin_Phot;
      NPR.SalMax_Phot := OPR.SalMax_Phot;
      NPR.Salcoeff1_Phot := OPR.Salcoeff1_Phot;
      NPR.Salcoeff2_Phot := OPR.Salcoeff2_Phot;
      NPR.XSalinity_Phot := OPR.XSalinity_Phot;
      NPR.Salmin_Mort := OPR.Salmin_Mort;
      NPR.SalMax_Mort := OPR.SalMax_Mort;
      NPR.Salcoeff1_Mort := OPR.Salcoeff1_Mort;
      NPR.Salcoeff2_Mort := OPR.Salcoeff2_Mort;
      NPR.XSalinity_Mort := OPR.XSalinity_Mort;
      NPR.Wet2Dry := OPR.Wet2Dry;
      NPR.XWet2Dry := OPR.XWet2Dry;
      NPR.Resp20 := OPR.Resp20;
      NPR.XResp20 := OPR.XResp20;
      NPR.PctSloughed := OPR.PctSloughed;
      NPR.XPctSloughed := OPR.XPctSloughed;
      NPR.UseAdaptiveLight := OPR.UseAdaptiveLight;
      NPR.MaxLightSat := OPR.MaxLightSat;
      NPR.XMaxLightSat := OPR.XMaxLightSat;
      NPR.MinLightSat := OPR.MinLightSat;
      NPR.XMinLightSat := OPR.XMinLightSat;
      NPR.PlaceholderB2 := OPR.PlaceholderB2;
End;

Procedure TranslateChemRec(Var St: TStream; ReadVers: Double; Var ChemRec: OldChemicalRecord);
Var Junk, TEq    : Double;
    PlaceHolder  : Boolean;
    PlaceHolder2 : String[10];
Begin
  If (ReadVers > 1.99) and (ReadVers<2.99) then with ChemRec do
   Begin
      st.read(ChemName ,sizeof(ChemName));
      st.read(CASRegNo ,sizeof(CASRegNo));   St.Read(Junk,1);
      st.read(MolWt,sizeof(MolWt));
      st.read(Solubility ,sizeof(Solubility ));
      st.read(XSolubility,sizeof(XSolubility)); St.Read(Junk,2);
      st.read(Henry,sizeof(Henry));
      st.read(XHenry ,sizeof(XHenry )); St.Read(Junk,2);
      st.read(pka,sizeof(pka));
      st.read(Xpka ,sizeof(Xpka ));     St.Read(Junk,2);
      st.read(VPress ,sizeof(VPress ));
      st.read(XVPress,sizeof(XVPress)); St.Read(Junk,2);
      st.read(LogKow ,sizeof(LogKow));
      st.read(XLogKow,sizeof(XLogKow));     St.Read(Junk,2);
      st.read(En ,sizeof(En ));
      st.read(XEn,sizeof(XEn));          St.Read(Junk,2);
      st.read(KMDegrdn ,sizeof(KMDegrdn ));
      st.read(XKMDegrdn,sizeof(XKMDegrdn));  St.Read(Junk,2);
      st.read(KMDegrAnaerobic,sizeof(KMDegrAnaerobic));
      st.read(XKMDegrAnaerobic ,sizeof(XKMDegrAnaerobic ));  St.Read(Junk,2);
      st.read(KUnCat ,sizeof(KUnCat ));
      st.read(XKUncat,sizeof(XKUncat));   St.Read(Junk,2);
      st.read(KAcid,sizeof(KAcid));
      st.read(XKAcid ,sizeof(XKAcid ));  St.Read(Junk,2);
      st.read(KBase,sizeof(KBase));
      st.read(XKBase ,sizeof(XKBase ));   St.Read(Junk,2);
      st.read(PhotolysisRate ,sizeof(PhotolysisRate ));
      st.read(XPhotoLysisRate,sizeof(XPhotoLysisRate));   St.Read(Junk,2);
      st.read(OxRateConst,sizeof(OxRateConst));
      st.read(XOxRateConst ,sizeof(XOxRateConst ));  St.Read(Junk,2);
      st.read(TEq,sizeof(TEq));
      st.read(KPSed,sizeof(KPSed));
      st.read(XKPSed ,sizeof(XKPSed ));         St.Read(Junk,2);
      st.read(Weibull_Shape,sizeof(Weibull_Shape));
      st.read(XWeibull_Shape,sizeof(XWeibull_Shape));
      st.read(ChemIsBase ,sizeof(ChemIsBase ));
      st.read(PLACEHOLDER,sizeof(PLACEHOLDER));
      st.read(PLACEHOLDER2 ,sizeof(PLACEHOLDER2 ));
      st.read(CalcKPSed,sizeof(CalcKPSed));
      If ReadVers > 2.599 then
        Begin
          st.read(WeibullSlopeFactor,sizeof(WeibullSlopeFactor));
          st.read(XWeibullSlopeFactor,sizeof(XWeibullSlopeFactor));
        End;

      CohesivesK1  := 0;
      CohesivesK2  := 0;
      CohesivesKp  := 0;
      CohesivesRef := 'no sorp/desorp';
      NonCohK1     := 0;
      NonCohK2     := 0;
      NonCohKp     := 0;
      NonCohRef    := 'no sorp/desorp';
      NonCoh2K1    := 0;
      NonCoh2K2    := 0;
      NonCoh2Kp    := 0;
      NonCoh2Ref   := 'no sorp/desorp';

      IsPFA         := False;
      PFAType       := '';
      PFAChainLength  :=0;
      XPFAChainLength :='';
      PFASedKom       :=0;
      XPFASedKom      :='';
      PFAAlgBCF       :=0;
      XPFAAlgBCF      :='';
      PFAMacroBCF     :=0;
      XPFAMacroBCF    :='';
   End;

End;

Procedure TranslateChemRec2(Var OCR: OLDChemicalRecord; Var CR: ChemicalRecord);
Begin
  CR.ChemName             := OCR.ChemName;
  CR.CASRegNo             := OCR.CASRegNo;
  CR.MolWt                := OCR.MolWt;
  CR.Solubility           := OCR.Solubility;
  CR.XSolubility          := OCR.XSolubility;
  CR.Henry                := OCR.Henry;
  CR.XHenry               := OCR.XHenry;
  CR.pka                  := OCR.pka;
  CR.Xpka                 := OCR.Xpka;
  CR.VPress               := OCR.VPress;
  CR.XVPress              := OCR.XVPress;
  CR.LogKow               := OCR.LogKow;
  CR.XLogKow              := OCR.XLogKow;
  CR.En                   := OCR.En;
  CR.XEn                  := OCR.XEn;
  CR.KMDegrdn             := OCR.KMDegrdn;
  CR.XKMDegrdn            := OCR.XKMDegrdn;
  CR.KMDegrAnaerobic      := OCR.KMDegrAnaerobic;
  CR.XKMDegrAnaerobic     := OCR.XKMDegrAnaerobic;
  CR.KUnCat               := OCR.KUnCat;
  CR.XKUncat              := OCR.XKUncat;
  CR.KAcid                := OCR.KAcid;
  CR.XKAcid               := OCR.XKAcid;
  CR.KBase                := OCR.KBase;
  CR.XKBase               := OCR.XKBase;
  CR.PhotolysisRate       := OCR.PhotolysisRate;
  CR.XPhotoLysisRate      := OCR.XPhotoLysisRate;
  CR.OxRateConst          := OCR.OxRateConst;
  CR.XOxRateConst         := OCR.XOxRateConst;
  CR.KPSed                := OCR.KPSed;
  CR.XKPSed               := OCR.XKPSed;
  CR.Weibull_Shape        := OCR.Weibull_Shape;
  CR.XWeibull_Shape       := OCR.XWeibull_Shape;
  CR.ChemIsBase           := OCR.ChemIsBase;
  CR.CalcKPSed            := OCR.CalcKPSed;
  CR.CohesivesK1          := OCR.CohesivesK1;
  CR.CohesivesK2          := OCR.CohesivesK2;
  CR.CohesivesKp          := OCR.CohesivesKp;
  CR.CohesivesRef         := OCR.CohesivesRef;
  CR.NonCohK1             := OCR.NonCohK1;
  CR.NonCohK2             := OCR.NonCohK2;
  CR.NonCohKp             := OCR.NonCohKp;
  CR.NonCohRef            := OCR.NonCohRef;
  CR.NonCoh2K1            := OCR.NonCoh2K1;
  CR.NonCoh2K2            := OCR.NonCoh2K2;
  CR.NonCoh2Kp            := OCR.NonCoh2Kp;
  CR.NonCoh2Ref           := OCR.NonCoh2Ref;
  CR.IsPFA                := OCR.IsPFA;
  CR.PFAType              := OCR.PFAType;
  CR.PFAChainLength       := OCR.PFAChainLength;
  CR.XPFAChainLength      := OCR.XPFAChainLength;
  CR.PFASedKom            := OCR.PFASedKom;
  CR.XPFASedKom           := OCR.XPFASedKom;
  CR.PFAAlgBCF            := OCR.PFAAlgBCF;
  CR.XPFAAlgBCF           := OCR.XPFAAlgBCF;
  CR.PFAMacroBCF          := OCR.PFAMacroBCF;
  CR.XPFAMacroBCF         := OCR.XPFAMacroBCF;
  CR.WeibullSlopeFactor   := OCR.WeibullSlopeFactor;
  CR.XWeibullSlopeFactor  := OCR.XWeibullSlopeFactor;
End;


Procedure TranslateAnimalData(Var St: TStream; ReadVers: Double; Var AnimalDat: OldZooRecord; IsInvert: Boolean);
Var NYU1: RefString;
    Junk,NYU2: Double;

Begin
  If (ReadVers > 1.99) and (ReadVers<2.99) then with AnimalDat do
   Begin
     st.read(AnimalName,sizeof(AnimalName));
     st.read(ToxicityRecord ,sizeof(ToxicityRecord ));  St.Read(Junk,2);
     st.read(FHalfSat,sizeof(FHalfSat));
     st.read(XFHalfSat ,sizeof(XFHalfSat )); St.Read(Junk,2);
     st.read(CMax ,sizeof(CMax ));
     st.read(XCMax,sizeof(XCMax));  St.Read(Junk,2);
     st.read(BMin ,sizeof(BMin ));
     st.read(XBMin,sizeof(XBMin));  St.Read(Junk,2);
     st.read(Q10,sizeof(Q10));
     st.read(XQ10 ,sizeof(XQ10 ));  St.Read(Junk,2);
     st.read(TOpt ,sizeof(TOpt ));
     st.read(XTOpt,sizeof(XTOpt));  St.Read(Junk,2);
     st.read(TMax ,sizeof(TMax ));
     st.read(XTMax,sizeof(XTMax)); St.Read(Junk,2);
     st.read(TRef ,sizeof(TRef ));
     st.read(XTRef,sizeof(XTRef)); St.Read(Junk,2);
     st.read(EndogResp ,sizeof(EndogResp ));
     st.read(XEndogResp,sizeof(XEndogResp)); St.Read(Junk,2);
     st.read(KResp,sizeof(KResp));
     st.read(XKResp,sizeof(XKResp));St.Read(Junk,2);
     st.read(KExcr,sizeof(KExcr));
     st.read(XKExcr,sizeof(XKExcr)); St.Read(Junk,2);
     st.read(PctGamete ,sizeof(PctGamete ));
     st.read(XPctGamete,sizeof(XPctGamete)); St.Read(Junk,2);
     st.read(GMort,sizeof(GMort));
     st.read(XGMort,sizeof(XGMort)); St.Read(Junk,2);
     st.read(KMort,sizeof(KMort));
     st.read(XKMort,sizeof(XKMort)); St.Read(Junk,2);
     st.read(Placeholder,sizeof(Placeholder));
     st.read(XPlaceHolder ,sizeof(XPlaceHolder )); St.Read(Junk,2);
     st.read(KCap ,sizeof(KCap ));
     st.read(XKCap,sizeof(XKCap)); St.Read(Junk,2);
     st.read(MeanWeight,sizeof(MeanWeight));
     st.read(XMeanWeight,sizeof(XMeanWeight)); St.Read(Junk,2);
     st.read(FishFracLipid,sizeof(FishFracLipid));
     st.read(XFishFracLipid ,sizeof(XFishFracLipid )); St.Read(Junk,2);
     st.read(LifeSpan,sizeof(LifeSpan));
     st.read(XLifeSpan ,sizeof(XLifeSpan ));
     st.read(Animal_Type,sizeof(Animal_Type));  St.Read(Junk,2);
     st.read(AveDrift,sizeof(AveDrift));
     st.read(XAveDrift ,sizeof(XAveDrift ));
     st.read(AutoSpawn ,sizeof(AutoSpawn )); St.Read(Junk,1);
     st.read(SpawnDate1,sizeof(SpawnDate1));
     st.read(SpawnDate2,sizeof(SpawnDate2));
     st.read(SpawnDate3,sizeof(SpawnDate3));
     st.read(XSpawnDate,sizeof(XSpawnDate));
     st.read(UnlimitedSpawning ,sizeof(UnlimitedSpawning )); St.Read(Junk,1);
     st.read(SpawnLimit,sizeof(SpawnLimit));
     st.read(UseAllom_C,sizeof(UseAllom_C));  St.Read(Junk,3);
     st.read(CA ,sizeof(CA ));
     st.read(CB ,sizeof(CB ));
     st.read(UseAllom_R,sizeof(UseAllom_R));  St.Read(Junk,3);
     st.read(RA ,sizeof(RA ));
     st.read(RB ,sizeof(RB ));
     st.read(UseSet1 ,sizeof(UseSet1 ));   St.Read(Junk,3);
     st.read(RQ,sizeof(RQ));
     st.read(RTO,sizeof(RTO));
     st.read(RTM,sizeof(RTM));
     st.read(RTL,sizeof(RTL));
     st.read(RK1,sizeof(RK1));
     st.read(RK4,sizeof(RK4));
     st.read(ACT,sizeof(ACT));
     st.read(BACT,sizeof(BACT));
     st.read(NYU2,sizeof(NYU2));
     st.read(NYU1,sizeof(NYU1));
     st.read(Guild_Taxa,sizeof(Guild_Taxa)); St.Read(Junk,2);
     st.read(PrefRiffle ,sizeof(PrefRiffle ));
     st.read(XPrefRiffle,sizeof(XPrefRiffle));
     st.read(PrefPool ,sizeof(PrefPool ));
     st.read(XPrefPool,sizeof(XPrefPool));
     st.read(VelMax,sizeof(VelMax));
     st.read(XVelMax,sizeof(XVelMax));
     st.read(XAllomConsumpt,sizeof(XAllomConsumpt));
     st.read(XAllomResp ,sizeof(XAllomResp));

     Wet2Dry:= 5.0;
     XWet2Dry:= '<--- default';

     If ReadVers>2.505 then
         Begin
          st.read(P2Org,sizeof(Double));
          st.read(XP2Org,sizeof(RefString));
          st.read(N2Org,sizeof(Double));
          st.read(XN2Org,sizeof(RefString));
          st.read(Wet2Dry,sizeof(Double));
          st.read(XWet2Dry,sizeof(RefString));
         End;

     If ReadVers<2.505 then
       If IsInvert
        then
          Begin
            P2Org  := 0.010;
            XP2Org := '<--- Invert Default';
            N2Org  := 0.09;
            XN2Org := '<--- Invert Default';
          end
        else
          Begin
            P2Org  := 0.025;
            XP2Org := '<--- Fish Default';
            N2Org  := 0.01;
            XN2Org := '<--- Fish Default';
          end;

     If Animal_Type='Fish' then FracInWaterCol := 1
                           else FracInWaterCol := 0.5;
     XFracInWaterCol := 'Default for this Animal Type';

     {Salinity & Ingestion}
     Salmin_Ing:=0;         {minimum salinity tolerance 0/00}
     SalMax_Ing:=0;         {max salinity tolerance 0/00}
     Salcoeff1_Ing:=0;
     Salcoeff2_Ing:=0; {unitless}
     XSalinity_Ing := 'Placeholder';
     {Salinity & Gameteloss}
     Salmin_Gam:=0;         {minimum salinity tolerance 0/00}
     SalMax_Gam:=0;         {max salinity tolerance 0/00}
     Salcoeff1_Gam:=0;
     Salcoeff2_Gam:=0; {unitless}
     XSalinity_Gam:= 'Placeholder';
     {Salinity & Respiration}
     Salmin_Rsp:=0;         {minimum salinity tolerance 0/00}
     SalMax_Rsp:=0;         {max salinity tolerance 0/00}
     Salcoeff1_Rsp:=0;
     Salcoeff2_Rsp:=0; {unitless}
     XSalinity_Rsp:= 'Placeholder';
     {Salinity & Mortility}
     Salmin_Mort   :=0;         {minimum salinity tolerance 0/00}
     SalMax_Mort   :=0;         {max salinity tolerance 0/00}
     Salcoeff1_Mort:=0;
     Salcoeff2_Mort:=0; {unitless}
     XSalinity_Mort:= 'Placeholder';

     Fishing_Frac  := 0; {fraction / day}
     XFishing_Frac := 'Placeholder';
{     Pct_Habitat   := 100;
     XPct_Habitat  := 'Default Value'; }

   End;
End;

Procedure TranslateAnimalData2(Var OZR: OldZooRecord; Var ZR: ZooRecord);
Begin
  ZR.AnimalName          := OZR.AnimalName;
  ZR.ToxicityRecord      := OZR.ToxicityRecord;
  ZR.FHalfSat            := OZR.FHalfSat;
  ZR.XFHalfSat           := OZR.XFHalfSat;
  ZR.CMax                := OZR.CMax;
  ZR.XCMax               := OZR.XCMax;
  ZR.BMin                := OZR.BMin;
  ZR.XBMin               := OZR.XBMin;
  ZR.Q10                 := OZR.Q10;
  ZR.XQ10                := OZR.XQ10;
  ZR.TOpt                := OZR.TOpt;
  ZR.XTOpt               := OZR.XTOpt;
  ZR.TMax                := OZR.TMax;
  ZR.XTMax               := OZR.XTMax;
  ZR.TRef                := OZR.TRef;
  ZR.XTRef               := OZR.XTRef;
  ZR.EndogResp           := OZR.EndogResp;
  ZR.XEndogResp          := OZR.XEndogResp;
  ZR.KResp               := OZR.KResp;
  ZR.XKResp              := OZR.XKResp;
  ZR.KExcr               := OZR.KExcr;
  ZR.XKExcr              := OZR.XKExcr;
  ZR.PctGamete           := OZR.PctGamete;
  ZR.XPctGamete          := OZR.XPctGamete;
  ZR.GMort               := OZR.GMort;
  ZR.XGMort              := OZR.XGMort;
  ZR.KMort               := OZR.KMort;
  ZR.XKMort              := OZR.XKMort;
  ZR.Placeholder         := OZR.Placeholder;
  ZR.XPlaceHolder        := OZR.XPlaceHolder;
  ZR.KCap                := OZR.KCap;
  ZR.XKCap               := OZR.XKCap;
  ZR.MeanWeight          := OZR.MeanWeight;
  ZR.XMeanWeight         := OZR.XMeanWeight;
  ZR.FishFracLipid       := OZR.FishFracLipid;
  ZR.XFishFracLipid      := OZR.XFishFracLipid;
  ZR.LifeSpan            := OZR.LifeSpan;
  ZR.XLifeSpan           := OZR.XLifeSpan;
  ZR.Animal_Type         := OZR.Animal_Type;
  ZR.AveDrift            := OZR.AveDrift;
  ZR.XAveDrift           := OZR.XAveDrift;
    ZR.AutoSpawn           := OZR.AutoSpawn;
  ZR.SpawnDate1          := OZR.SpawnDate1;
  ZR.SpawnDate2          := OZR.SpawnDate2;
  ZR.SpawnDate3          := OZR.SpawnDate3;
  ZR.XSpawnDate          := OZR.XSpawnDate;
  ZR.UnlimitedSpawning   := OZR.UnlimitedSpawning;
  ZR.SpawnLimit          := OZR.SpawnLimit;
  ZR.UseAllom_C          := OZR.UseAllom_C;
  ZR.CA                  := OZR.CA;
  ZR.CB                  := OZR.CB;
  ZR.UseAllom_R          := OZR.UseAllom_R;
  ZR.RA                  := OZR.RA;
  ZR.RB                  := OZR.RB;
  ZR.UseSet1             := OZR.UseSet1;
  ZR.RQ  := OZR.RQ;
  ZR.RTO  := OZR.RTO;
  ZR.RTM  := OZR.RTM;
  ZR.RTL  := OZR.RTL;
  ZR.RK1  := OZR.RK1;
  ZR.RK4  := OZR.RK4;
  ZR.ACT  := OZR.ACT;
  ZR.BACT := OZR.BACT;
  ZR.FracInWaterCol      := OZR.FracInWaterCol;
  ZR.XFracInWaterCol     := OZR.XFracInWaterCol;
  ZR.Guild_Taxa          := OZR.Guild_Taxa;
  ZR.PrefRiffle          := OZR.PrefRiffle;
  ZR.XPrefRiffle         := OZR.XPrefRiffle;
  ZR.PrefPool            := OZR.PrefPool;
  ZR.XPrefPool           := OZR.XPrefPool;
  ZR.VelMax              := OZR.VelMax;
  ZR.XVelMax             := OZR.XVelMax;
  ZR.XAllomConsumpt      := OZR.XAllomConsumpt;
  ZR.XAllomResp          := OZR.XAllomResp;
  ZR.Salmin_Ing        := OZR.Salmin_Ing;
  ZR.SalMax_Ing        := OZR.SalMax_Ing;
  ZR.Salcoeff1_Ing       := OZR.Salcoeff1_Ing;
  ZR.Salcoeff2_Ing       := OZR.Salcoeff2_Ing;
  ZR.XSalinity_Ing       := OZR.XSalinity_Ing;
  ZR.Salmin_Gam        := OZR.Salmin_Gam;
  ZR.SalMax_Gam        := OZR.SalMax_Gam;
  ZR.Salcoeff1_Gam     := OZR.Salcoeff1_Gam;
  ZR.Salcoeff2_Gam       := OZR.Salcoeff2_Gam;
  ZR.XSalinity_Gam       := OZR.XSalinity_Gam;
  ZR.Salmin_Rsp        := OZR.Salmin_Rsp;
  ZR.SalMax_Rsp        := OZR.SalMax_Rsp;
  ZR.Salcoeff1_Rsp     := OZR.Salcoeff1_Rsp;
  ZR.Salcoeff2_Rsp       := OZR.Salcoeff2_Rsp;
  ZR.XSalinity_Rsp       := OZR.XSalinity_Rsp;
  ZR.Salmin_Mort        := OZR.Salmin_Mort;
  ZR.SalMax_Mort        := OZR.SalMax_Mort;
  ZR.Salcoeff1_Mort      := OZR.Salcoeff1_Mort;
  ZR.Salcoeff2_Mort       := OZR.Salcoeff2_Mort;
  ZR.XSalinity_Mort       := OZR.XSalinity_Mort;
  ZR.Fishing_Frac         := OZR.Fishing_Frac;
  ZR.XFishing_Frac        := OZR.XFishing_Frac;
  ZR.P2Org                := OZR.P2Org;
  ZR.XP2Org               := OZR.XP2Org;
  ZR.N2Org                := OZR.N2Org;
  ZR.XN2Org               := OZR.XN2Org;
  ZR.Wet2Dry              := OZR.Wet2Dry;
  ZR.XWet2Dry             := OZR.XWet2Dry;
  ZR.O2_LethalConc        := OZR.O2_LethalConc;
  ZR.O2_LethalPct         := OZR.O2_LethalPct;
  ZR.O2_LCRef             := OZR.O2_LCRef;
  ZR.O2_EC50growth        := OZR.O2_EC50growth;
  ZR.XO2_EC50growth       := OZR.XO2_EC50growth;
  ZR.O2_EC50repro         := OZR.O2_EC50repro;
  ZR.XO2_EC50repro        := OZR.XO2_EC50repro;
  ZR.Ammonia_LC50         := OZR.Ammonia_LC50;
  ZR.XAmmonia_LC50        := OZR.XAmmonia_LC50;
  ZR.Sorting              := OZR.Sorting;
  ZR.XSorting             := OZR.XSorting;
  ZR.SuspSedFeeding       := OZR.SuspSedFeeding;
  ZR.XSuspSedFeeding      := OZR.XSuspSedFeeding;
  ZR.SlopeSSFeed          := OZR.SlopeSSFeed;
  ZR.XSlopeSSFeed         := OZR.XSlopeSSFeed;
  ZR.InterceptSSFeed      := OZR.InterceptSSFeed;
  ZR.XInterceptSSFeed     := OZR.XInterceptSSFeed;
  ZR.SenstoSediment       := OZR.SenstoSediment;
  ZR.XSensToSediment      := OZR.XSensToSediment;
  ZR.Trigger              := OZR.Trigger;
  ZR.XTrigger             := OZR.XTrigger;
  ZR.SenstoPctEmbed       := OZR.SenstoPctEmbed;
  ZR.PctEmbedThreshold    := OZR.PctEmbedThreshold;
  ZR.XPctEmbedThreshold   := OZR.XPctEmbedThreshold;
  ZR.BenthicDesignation   := OZR.BenthicDesignation;
End;

Procedure TranslateTrophInt(Var St: TStream; ReadVers: Double; Var TrophInt: TrophIntArray);
Var OldTrophInt  :Array[1..73] of InteractionFields;
    OldTrophInt2 :Array[1..89] of InteractionFields;
    Loop: Integer;
    CMP,NewNState: AllVariables;
Begin
   for CMP := Cohesives to LastBiota do
   With TrophInt[CMP] do
     Begin
        Pref:=0; ECoeff:=0; XInteraction:='';
     End;

  If ReadVers < 2.58
    then
      Begin
        St.Read(OldTrophInt,Sizeof(OldTrophInt));
        For Loop := 1 to 73 do
          Begin
            NewNState := UpdateNState(AllVariables(Loop+31),ReadVers);
            If NewNState<>Salinity then TrophInt[NewNState] := OldTrophInt[Loop];
          End;
      End
    else
      Begin
        St.Read(OldTrophInt2,Sizeof(OldTrophInt2));
        For Loop := 1 to 89 do
          Begin
            NewNState := UpdateNState(AllVariables(Loop+31),ReadVers);
            If NewNState<>Salinity then TrophInt[NewNState] := OldTrophInt2[Loop];
          End;
      End

End;

Procedure TranslateSiteRecord(Var St: TStream; ReadVers: Double; Var OSR: OldSiteRecord);
var junk: Double;
Begin
  If (ReadVers > 1.99) and (ReadVers<2.99) then with OSR do
   Begin
      st.read(SiteName,sizeof(SiteName));         st.read(junk,2);
      st.read(ECoeffWater,sizeof(ECoeffWater));
      st.read(SiteLength,sizeof(SiteLength));
      st.read(XLength,sizeof(XLength));           st.read(junk,2);
      st.read(StaticVolume,sizeof(StaticVolume));
      st.read(XVolume,sizeof(XVolume));           st.read(junk,2);
      st.read(SurfArea,sizeof(SurfArea));
      st.read(XSurfArea,sizeof(XSurfArea));       st.read(junk,2);
      st.read(ICZMean,sizeof(ICZMean));
      st.read(XZMean,sizeof(XZMean));             st.read(junk,2);
      st.read(ZMax,sizeof(ZMax));
      st.read(XZMax,sizeof(XZMax));               st.read(junk,2);
      st.read(TempMean,sizeof(TempMean));
      st.read(XTempMean,sizeof(XTempMean));
      st.read(TempRange,sizeof(TempRange));
      st.read(XTempRange,sizeof(XTempRange));     
      st.read(Latitude,sizeof(Latitude));
      st.read(XLatitude,sizeof(XLatitude));       st.read(junk,2);
      st.read(LightMean,sizeof(LightMean));
      st.read(XLightMean,sizeof(XLightMean));     st.read(junk,2);
      st.read(LightRange,sizeof(LightRange));
      st.read(XLightRange,sizeof(XLightRange));   st.read(junk,2);
      st.read(AlkCaCO3,sizeof(AlkCaCO3));
      st.read(XAlkCaCO3,sizeof(XAlkCaCO3));       st.read(junk,2);
      st.read(HardCaCO3,sizeof(HardCaCO3));
      st.read(XHardCaCO3,sizeof(XHardCaCO3));
      st.read(SiteComment,sizeof(SiteComment));   st.read(junk,2);
      st.read(SO4ConC,sizeof(SO4ConC));
      st.read(XSO4Conc,sizeof(XSO4Conc));         st.read(junk,2);
      st.read(TotalDissSolids,sizeof(TotalDissSolids));
      st.read(XTotalDissSolids,sizeof(XTotalDissSolids));
      st.read(StreamType,sizeof(StreamType));     st.read(junk,1);
      st.read(Channel_slope,sizeof(Channel_slope));
      st.read(XChannel_slope,sizeof(XChannel_slope));  st.read(junk,2);
      st.read(Max_Chan_Depth,sizeof(Max_Chan_Depth));
      st.read(XMax_Chan_Depth,sizeof(XMax_Chan_Depth));  st.read(junk,2);
      st.read(SedDepth,sizeof(SedDepth));
      st.read(XSedDepth,sizeof(XSedDepth));               st.read(junk,2);
      st.read(EnclWallArea,sizeof(EnclWallArea));
      st.read(XEnclWallArea,sizeof(XEnclWallArea));     st.read(junk,2);
      st.read(MeanEvap,sizeof(MeanEvap));
      st.read(XMeanEvap,sizeof(XMeanEvap));
      st.read(UseEnteredManning,sizeof(UseEnteredManning));  st.read(junk,1);
      st.read(EnteredManning,sizeof(EnteredManning));
      st.read(XECoeffWater,sizeof(XECoeffWater));
      st.read(PctRiffle,sizeof(PctRiffle));
      st.read(XPctRiffle,sizeof(XPctRiffle));
      st.read(PctPool,sizeof(PctPool));
      st.read(XPctPool,sizeof(XPctPool));
      st.read(ts_clay,sizeof(ts_clay));
      st.read(Xts_clay,sizeof(Xts_clay));
      st.read(ts_silt,sizeof(ts_silt));
      st.read(Xts_silt,sizeof(Xts_silt));
      st.read(tdep_clay,sizeof(tdep_clay));
      st.read(Xtdep_clay,sizeof(Xtdep_clay));
      st.read(tdep_silt,sizeof(tdep_silt));
      st.read(Xtdep_silt,sizeof(Xtdep_silt));
      st.read(Fallvel_clay,sizeof(Fallvel_clay));
      st.read(XFallvel_clay,sizeof(XFallvel_clay));
      st.read(Fallvel_silt,sizeof(Fallvel_silt));
      st.read(XFallvel_silt,sizeof(XFallvel_silt));

      Min_Vol_Frac         := 0.01;
      XMin_Vol_Frac        := 'default';

      WaterShedArea := 0;
      XWatershedArea:='0 = not used';
      EnterTotalLength := True;
      TotalLength := 0;
      XTotalLength:='0 = not used';

      If ReadVers > 2.565
        Then
          Begin
{            st.read(Min_Vol_Frac,sizeof(Min_Vol_Frac ));
            st.read(XMin_Vol_Frac,sizeof( XMin_Vol_Frac )); }

            st.read(WaterShedArea,sizeof(WaterShedArea));
            st.read(XWaterShedArea,sizeof(XWaterShedArea ));
            st.read(EnterTotalLength,sizeof(EnterTotalLength  ));
            st.read(TotalLength,sizeof(TotalLength ));
            st.read(XTotalLength,sizeof(XTotalLength));
          End;

      UseBathymetry := True;
      SiteWidth   := 0;
      XSiteWidth  := 'estuaries only';

  {m2} amplitude1  :=0; k1 :=0; ConstRef1 := 'estuaries only';
  {s2} amplitude2  :=0; k2 :=0; ConstRef2 := 'estuaries only';
  {n2} amplitude3  :=0; k3 :=0; ConstRef3 := 'estuaries only';
  {k1} amplitude4  :=0; k4 :=0; ConstRef4 := 'estuaries only';
  {o1} amplitude5  :=0; k5 :=0; ConstRef5 := 'estuaries only';
 {SSA} amplitude6  :=0; k6 :=0; ConstRef6 := 'estuaries only';
  {SA} amplitude7  :=0; k7 :=0; ConstRef7 := 'estuaries only';
  {P1} amplitude8  :=0; k8 :=0; ConstRef8 := 'estuaries only';

   End;

End;




Procedure TranslateSiteRecord2(Var OSR: OldSiteRecord; Var Locale: SiteRecord);
Begin
      Locale.SiteName := OSR.SiteName;
      Locale.ECoeffWater := OSR.ECoeffWater;
      Locale.SiteLength := OSR.SiteLength;
      Locale.XLength := OSR.XLength;
      Locale.StaticVolume := OSR.StaticVolume;
      Locale.XVolume := OSR.XVolume;
      Locale.SurfArea := OSR.SurfArea;
      Locale.XSurfArea := OSR.XSurfArea;
      Locale.ICZMean := OSR.ICZMean;
      Locale.XZMean := OSR.XZMean;
      Locale.ZMax := OSR.ZMax;
      Locale.XZMax := OSR.XZMax;
      Locale.TempMean[Epilimnion] := OSR.TempMean[Epilimnion];
      Locale.TempMean[Hypolimnion] := OSR.TempMean[Hypolimnion];
      Locale.XTempMean[Epilimnion] := OSR.XTempMean[Epilimnion];
      Locale.XTempMean[Hypolimnion] := OSR.XTempMean[Hypolimnion];
      Locale.TempRange[Epilimnion] := OSR.TempRange[Epilimnion];
      Locale.TempRange[Hypolimnion] := OSR.TempRange[Hypolimnion];
      Locale.XTempRange[Epilimnion] := OSR.XTempRange[Epilimnion];
      Locale.XTempRange[Hypolimnion] := OSR.XTempRange[Hypolimnion];

      Locale.Latitude := OSR.Latitude;
      Locale.XLatitude := OSR.XLatitude;
      Locale.LightMean := OSR.LightMean;
      Locale.XLightMean := OSR.XLightMean;
      Locale.LightRange := OSR.LightRange;
      Locale.XLightRange := OSR.XLightRange;
      Locale.AlkCaCO3 := OSR.AlkCaCO3;
      Locale.XAlkCaCO3 := OSR.XAlkCaCO3;
      Locale.HardCaCO3 := OSR.HardCaCO3;
      Locale.XHardCaCO3 := OSR.XHardCaCO3;
      Locale.SiteComment   := OSR.SiteComment;
      Locale.SO4ConC := OSR.SO4ConC;
      Locale.XSO4Conc := OSR.XSO4Conc;
      Locale.TotalDissSolids := OSR.TotalDissSolids;
      Locale.XTotalDissSolids := OSR.XTotalDissSolids;
      Locale.StreamType := OSR.StreamType;
      Locale.Channel_Slope := OSR.Channel_Slope;
      Locale.XChannel_Slope := OSR.XChannel_Slope;
      Locale.Max_Chan_Depth := OSR.Max_Chan_Depth;
      Locale.XMax_Chan_Depth := OSR.XMax_Chan_Depth;
      Locale.SedDepth := OSR.SedDepth;
      Locale.XSedDepth := OSR.XSedDepth;
      Locale.EnclWallArea := OSR.EnclWallArea;
      Locale.XEnclWallArea := OSR.XEnclWallArea;
      Locale.MeanEvap := OSR.MeanEvap;
      Locale.XMeanEvap := OSR.XMeanEvap;
      Locale.UseEnteredManning := OSR.UseEnteredManning;
      Locale.EnteredManning := OSR.EnteredManning;
      Locale.XECoeffWater := OSR.XECoeffWater;

      Locale.PctRiffle := OSR.PctRiffle;
      Locale.XPctRiffle := OSR.XPctRiffle;
      Locale.PctPool := OSR.PctPool;
      Locale.XPctPool := OSR.XPctPool;

      Locale.UseBathymetry := OSR.UseBathymetry;

      Locale.ts_clay := OSR.ts_clay;
      Locale.Xts_clay := OSR.Xts_clay;
      Locale.ts_silt := OSR.ts_silt;
      Locale.Xts_silt := OSR.Xts_silt;
      Locale.tdep_clay := OSR.tdep_clay;
      Locale.Xtdep_clay := OSR.Xtdep_clay;
      Locale.tdep_silt := OSR.tdep_silt;
      Locale.Xtdep_silt := OSR.Xtdep_silt;
      Locale.FallVel_clay := OSR.FallVel_clay;
      Locale.XFallVel_clay := OSR.XFallVel_clay;
      Locale.FallVel_silt := OSR.FallVel_silt;
      Locale.XFallVel_silt := OSR.XFallVel_silt;

     {ESTUARY ADDITIONS BELOW}

      Locale.SiteWidth := OSR.SiteWidth;
      Locale.XSiteWidth := OSR.XSiteWidth;

    Locale.amplitude1 := OSR.amplitude1;
    Locale.k1 := OSR.k1;
    Locale.ConstRef1 := OSR.ConstRef1;
    Locale.amplitude2 := OSR.amplitude2;
    Locale.k2 := OSR.k2;
    Locale.ConstRef2 := OSR.ConstRef2;
   Locale.amplitude3 := OSR.amplitude3;
   Locale.k3 := OSR.k3;
   Locale.ConstRef3 := OSR.ConstRef3;
   Locale.amplitude4 := OSR.amplitude4;
   Locale.k4 := OSR.k4;
   Locale.ConstRef4 := OSR.ConstRef4;
   Locale.amplitude5 := OSR.amplitude5;
   Locale.k5 := OSR.k5;
   Locale.ConstRef5 := OSR.ConstRef5;
  Locale.amplitude6 := OSR.amplitude6;
  Locale.k6 := OSR.k6;
  Locale.ConstRef6 := OSR.ConstRef6;
  Locale.amplitude7 := OSR.amplitude7;
  Locale.k7 := OSR.k7;
  Locale.ConstRef7 := OSR.ConstRef7;
  Locale.amplitude8 := OSR.amplitude8;
  Locale.k8 := OSR.k8;
  Locale.ConstRef8 := OSR.ConstRef8;

      Locale.Min_Vol_Frac := OSR.Min_Vol_Frac;
      Locale.XMin_Vol_Frac := OSR.XMin_Vol_Frac;

      Locale.WaterShedArea := OSR.WaterShedArea;
      Locale.XWaterShedArea := OSR.XWaterShedArea;
      Locale.EnterTotalLength := OSR.EnterTotalLength;
      Locale.TotalLength := OSR.TotalLength;
      Locale.XTotalLength := OSR.XTotalLength;

      Locale.ECoeffSED := OSR.ECoeffSED;
      Locale.XECoeffSED := OSR.XECoeffSED;
      Locale.ECoeffDOM := OSR.ECoeffDOM;
      Locale.XECoeffDOM := OSR.XECoeffDOM;
      Locale.ECoeffPOM := OSR.ECoeffPOM;
      Locale.XECoeffPOM := OSR.XECoeffPOM;

      Locale.UseCovar := OSR.UseCovar;
      Locale.EnteredKReaer := OSR.EnteredKReaer;
      Locale.XEnteredKReaer := OSR.XEnteredKReaer;
      Locale.UsePhytoRetention := OSR.UsePhytoRetention;

      Locale.BasePercentEmbed := OSR.BasePercentEmbed;
      Locale.XBasePercentEmbed := OSR.XBasePercentEmbed;

      Locale.Altitude := OSR.Altitude;
      Locale.XAltitude := OSR.XAltitude;

      Locale.PlaceholderN1 := OSR.PlaceholderN1;
      Locale.PlaceholderR1 := OSR.PlaceholderR1;

End;


Procedure TranslateReminRecord(Var St: TStream; ReadVers: Double; Var remin: OldReminRecord);
var junk: Double;
Begin
  If (ReadVers > 1.99) and (ReadVers<2.99) then with remin do
   Begin
      st.read(RemRecName,sizeof(RemRecName));   st.read(junk,2);
      st.read(DecayMax_Lab,sizeof(DecayMax_Lab));
      st.read(XDecayMax_Lab,sizeof(XDecayMax_Lab)); st.read(junk,2);
      st.read(Q10_NotUsed,sizeof(Q10_NotUSed));
      st.read(XQ10,sizeof(XQ10));  st.read(junk,2);
      st.read(TOpt,sizeof(TOpt));
      st.read(XTOpt,sizeof(XTOpt)); st.read(junk,2);
      st.read(TMax,sizeof(TMax));
      st.read(XTMax,sizeof(XTMax));  st.read(junk,2);
      st.read(TRef_NotUsed,sizeof(TRef_NotUsed));
      st.read(XTRef,sizeof(XTRef));  st.read(junk,2);
      st.read(pHMin,sizeof(pHMin));
      st.read(XpHMin,sizeof(XpHMin));  st.read(junk,2);
      st.read(pHMax,sizeof(pHMax));
      st.read(XpHMax,sizeof(XpHMax));  st.read(junk,2);
      st.read(P2OrgLab,sizeof(P2OrgLab));
      st.read(N2OrgLab,sizeof(N2OrgLab));
      st.read(PlaceHolder,sizeof(PlaceHolder));
      st.read(XP2OrgLab,sizeof(XP2OrgLab));
      st.read(XN2OrgLab,sizeof(XN2OrgLab));
      st.read(O2Biomass,sizeof(O2Biomass));
      st.read(XO2Biomass,sizeof(XO2Biomass));  st.read(junk,2);
      st.read(O2N,sizeof(O2N));
      st.read(XO2N,sizeof(XO2N));              st.read(junk,2);
      st.read(KSed,sizeof(KSed));
      st.read(XKsed,sizeof(XKsed));            st.read(junk,2);
      st.read(PSedRelease_NotUsed,sizeof(PSedRelease_NotUsed));
      st.read(XPSedrelease,sizeof(XPSedrelease)); st.read(junk,2);
      st.read(NSedRelease_NotUsed,sizeof(NSedRelease_NotUsed));
      st.read(XNSedRelease,sizeof(XNSedRelease)); st.read(junk,2);
      st.read(Decaymax_refr,sizeof(Decaymax_refr));
      st.read(XDecaymax_refr,sizeof(XDecaymax_refr)); st.read(junk,2);

      KSedTemp            := 20;
      XKSedTemp           := 'default';
      KSedSalinity        := 0;
      XKSedSalinity       := 'default';

       P2Org_Refr       := 0.0002;
       XP2Org_Refr      := 'default';
       P2OrgDissRefr  := 0.0002;
       XP2OrgDissRefr := 'default';
       N2Org_Refr       := 0.002;
       XN2Org_Refr      := 'default';
       N2OrgDissRefr  := 0.002;
       XN2OrgDissRefr  := 'default';
       P2OrgDissLab   := 0.007;
       XP2OrgDissLab  := 'same as phytoplankton';
       N2OrgDissLab   := 0.059;
       XN2OrgDissLab  := 'same as phytoplankton';

       Wet2DryPRefr  := 5.0;
       XWet2DryPRefr := '<--- default';
       Wet2DryPLab   := 5.0;
       Xet2DryPLab   := '<--- default';
       Wet2DrySRefr  := 5.0;
       XWet2DrySRefr := '<--- default';
       Wet2DrySLab   := 5.0;
       XWet2DrySLab  := '<--- default';

      If ReadVers > 2.565
        Then
          Begin
            st.read(P2Org_Refr,Sizeof(P2Org_Refr));
            st.read(XP2Org_Refr,Sizeof(XP2Org_Refr));
            st.read(N2Org_Refr,Sizeof(Double));
            st.read(XN2Org_Refr,Sizeof(RefString));
            st.read(Wet2DryPRefr,Sizeof(Double));
            st.read(XWet2DryPRefr,Sizeof(RefString));
            st.read(Wet2DryPLab,Sizeof(Double));
            st.read(Xet2DryPLab,Sizeof(RefString));
            st.read(Wet2DrySRefr,Sizeof(Double));
            st.read(XWet2DrySRefr,Sizeof(RefString));
            st.read(Wet2DrySLab,Sizeof(Double));
            st.read(XWet2DrySLab,Sizeof(RefString));
            st.read(N2OrgDissLab,Sizeof(Double));
            st.read(XN2OrgDissLab,Sizeof(RefString));
            st.read(P2OrgDissLab,Sizeof(Double));
            st.read(XP2OrgDissLab,Sizeof(RefString));
            st.read(N2OrgDissRefr,Sizeof(Double));
            st.read(XN2OrgDissRefr,Sizeof(RefString));
            st.read(P2OrgDissRefr,Sizeof(Double));
            st.read(XP2OrgDissRefr,Sizeof(RefString));
          End;
   End;
End;

Procedure TranslateReminRecord2(var ORR: OldReminRecord; var Remin: ReminRecord);
Begin
    Remin.RemRecName := ORR.RemRecName;
    Remin.DecayMax_Lab := ORR.DecayMax_Lab;
    Remin.XDecayMax_Lab := ORR.XDecayMax_Lab;
    Remin.Q10_NotUsed  := ORR.Q10_NotUsed ;
    Remin.XQ10         := ORR.XQ10        ;
    Remin.TOpt         := ORR.TOpt        ;
    Remin.XTOpt        := ORR.XTOpt       ;
    Remin.TMax         := ORR.TMax        ;
    Remin.XTMax        := ORR.XTMax       ;
    Remin.TRef_NotUsed := ORR.TRef_NotUsed;
    Remin.XTRef        := ORR.XTRef       ;
    Remin.pHMin        := ORR.pHMin       ;
    Remin.XpHMin       := ORR.XpHMin      ;
    Remin.pHMax        := ORR.pHMax       ;
    Remin.XpHMax       := ORR.XpHMax      ;
    Remin.P2OrgLab     := ORR.P2OrgLab    ;
    Remin.N2OrgLab     := ORR.N2OrgLab    ;
    Remin.PlaceHolder  := ORR.PlaceHolder ;
    Remin.XP2OrgLab    := ORR.XP2OrgLab   ;
    Remin.XN2OrgLab    := ORR.XN2OrgLab   ;
    Remin.O2Biomass    := ORR.O2Biomass   ;
    Remin.XO2Biomass   := ORR.XO2Biomass  ;
    Remin.O2N          := ORR.O2N         ;
    Remin.XO2N         := ORR.XO2N        ;
    Remin.KSed         := ORR.KSed        ;
    Remin.XKsed        := ORR.XKsed       ;
    Remin.PSedRelease_NotUsed  := ORR.PSedRelease_NotUsed ;
    Remin.XPSedrelease := ORR.XPSedrelease;
    Remin.NSedRelease_NotUsed  := ORR.NSedRelease_NotUsed ;
    Remin.XNSedRelease := ORR.XNSedRelease;
    Remin.DecayMax_Refr := ORR.DecayMax_Refr;
    Remin.XDecayMax_Refr := ORR.XDecayMax_Refr;
    Remin.KSedTemp           := ORR.KSedTemp          ;
    Remin.XKSedTemp          := ORR.XKSedTemp         ;
    Remin.KSedSalinity       := ORR.KSedSalinity      ;
    Remin.XKSedSalinity      := ORR.XKSedSalinity     ;
    Remin.P2Org_Refr    := ORR.P2Org_Refr   ;
    Remin.XP2Org_Refr   := ORR.XP2Org_Refr  ;
    Remin.N2Org_Refr    := ORR.N2Org_Refr   ;
    Remin.XN2Org_Refr   := ORR.XN2Org_Refr  ;
    Remin.Wet2DryPRefr  := ORR.Wet2DryPRefr ;
    Remin.XWet2DryPRefr := ORR.XWet2DryPRefr;
    Remin.Wet2DryPLab   := ORR.Wet2DryPLab  ;
    Remin.Xet2DryPLab   := ORR.Xet2DryPLab  ;
    Remin.Wet2DrySRefr  := ORR.Wet2DrySRefr ;
    Remin.XWet2DrySRefr := ORR.XWet2DrySRefr;
    Remin.Wet2DrySLab   := ORR.Wet2DrySLab  ;
    Remin.XWet2DrySLab  := ORR.XWet2DrySLab ;
    Remin.N2OrgDissLab  := ORR.N2OrgDissLab ;
    Remin.XN2OrgDissLab := ORR.XN2OrgDissLab;
    Remin.P2OrgDissLab  := ORR.P2OrgDissLab ;
    Remin.XP2OrgDissLab := ORR.XP2OrgDissLab;
    Remin.N2OrgDissRefr := ORR.N2OrgDissRefr;
    Remin.XN2OrgDissRefr := ORR.XN2OrgDissRefr;
    Remin.P2OrgDissRefr := ORR.P2OrgDissRefr;
    Remin.XP2OrgDissRefr := ORR.XP2OrgDissRefr;
    Remin.KD_P_Calcite  := ORR.KD_P_Calcite ;
    Remin.XKD_P_Calcite := ORR.XKD_P_Calcite;
    Remin.NotUsed       := ORR.BOD5_CBODu   ;
End;
