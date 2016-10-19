//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Constructor TStates.Init(A,B : word; aL : TAQTSite; aC : PChemArray; aSR : PSetup_Record;
                         aDR: PDiagenesis_Rec; PST: TStates; AllSVs: Pointer);
Var Loop: VerticalSegments;
    ToxLoop: T_SVType;
    i: Integer;
    LayLoop: T_SVLayer;
    nsloop: AllVariables;
    Blank: InteractionFields;

Begin
   Inherited Init(A,B); {TCollection}
   Location := aL;
   ChemPtrs := aC;
   SetupRec := aSR;
   Diagenesis_Params := aDR;

   WaterVolZero := False;
   Water_Was_Zero := False;
   Last_Non_Zero_Vol := 0;

   If PST=nil then PStatesTemplate := Self
              else PStatesTemplate := PST;

   For Loop:=Epilimnion to Hypolimnion do
     begin
       Results[loop]:=TResultsCollection.Init;
       ControlResults[loop]:=TResultsCollection.Init;
     end;

   OOSStack := nil;  
   HypoSegment := nil;
   EpiSegment  := nil;
   ThermLink   := nil;
   ThermLink2  := nil;

   PMultiRec   := nil;
   VSeg := Epilimnion;
   HypoTempIC:=0;
   With HypoTempLoads do     {Set up Loadings Data}
   begin
     Loadings:=TLoadings.Init(10,20);
     ConstLoad:=0;
     MultLdg := 1.0;
     UseConstant:=True;
     NoUserLoad :=True;
     Alt_Loadings[PointSource]    := nil;
     Alt_Loadings[DirectPrecip]   := nil;
     Alt_Loadings[NonPointSource] := nil;
   end;

   With Shade do     {Set up Loadings Data}
   begin
     Loadings:=TLoadings.Init(10,20);
     ConstLoad:=0;
     MultLdg := 1.0;
     UseConstant:=True;
     NoUserLoad:=False;
     Alt_Loadings[PointSource]    := nil;
     Alt_Loadings[DirectPrecip]   := nil;
     Alt_Loadings[NonPointSource] := nil;
   end;

   With Z_Thermocline do     {Set up Loadings Data}
   begin
     Loadings:=TLoadings.Init(10,20);
     ConstLoad:=0;
     MultLdg := 1.0;
     UseConstant:=True;
     NoUserLoad:=False;
     Alt_Loadings[PointSource]    := nil;
     Alt_Loadings[DirectPrecip]   := nil;
     Alt_Loadings[NonPointSource] := nil;
   end;


   CalcVelocity := True;
   DynVelocity  := TLoadings.Init(10,20);

   If PST=nil  {This is the template, insert PRate Info}
     then
       begin
         New(PRateInfo);
         PRateInfo^.Dirnm                 := Output_Dir;
         PRateInfo^.FileNm                := 'Rates.DB';
         PRateInfo^.WriteDaily            := True;
         PRateInfo^.WriteToMemory         := True;
         PRateInfo^.FileInit[Epilimnion]  := False;
         PRateInfo^.FileInit[Hypolimnion] := False;
         New(ProgData);
       end
     else
       Begin
         PRateInfo := PST.PRateInfo;
         ProgData := PST.ProgData;
       End;


   If PST=nil then begin
                     New(PControlInfo);
                     DefaultControlInfo(PControlInfo^);
                   End;
   If PST<>nil then PControlInfo := PST.PControlInfo;

   If PST=nil then New(PModelTimeStep)
              else PModelTimeStep := PST.PModelTimeStep;

   VertDispersionCalcDate               := -99;
   OldVertDispersionVal                 := -99;

   TimeLastGullConc := -99;
   TimeLastInorgSedAvg[True] := -99;
   TimeLastInorgSedAvg[False] := -99;

   LastWellMixedTime := -99;
   LastWellMixedCalc := True;

   Last_Datapoint_Written[Epilimnion]   := -99;
   Last_Results_Written[Epilimnion]     := -99;
   Last_Datapoint_Written[Hypolimnion]  := -99;
   Last_Results_Written[Hypolimnion]    := -99;

   DerivStep := 0;

   If PST=nil then Begin
                     New(PMessageStr);
                     PMessageStr^ := '';
                     New(PMessageErr);
                     PMessageErr^ := False
                   End
              else Begin
                     PMessageStr  := PST.PMessageStr;
                     PMessageErr  := PST.PMessageErr;
                   End;

   If PST=nil then Begin
                     New(PSavePPB);
                     PSavePPB^ := True
                   End
              else PSavePPB  := PST.PSavePPB;

   If PST=nil then Begin
                     New(PSaveBAFs);
                     PSaveBAFs^ := True
                   End
              else PSaveBAFs  := PST.PSaveBAFs;

   For ToxLoop := FirstToxTyp to LastToxTyp do
     Begin
       Diff[ToxLoop] := 0;
       For LayLoop := SedLayer1 to LowestLayer do
         PoreDiff[ToxLoop,LayLoop] := 0;
       FirstExposure[ToxLoop] := 0;
     End;

   Stratified  := False;
   Anoxic      := False;

   Distributions := TDistributionList.Init(20,10);

   ObservedData := TObservedData.Create;
   Graphs       := TGraphs.Create;

   UseExternalConcTox  := False;

   PAllSVsColl := @AllSVs;
   In_FB_Links := nil; Out_FB_Links := nil;
   In_Cs_Links := nil; Out_Cs_Links := nil;

   IsStrat:=False; IsEpilimnion:=True;  {linked mode stratification inputs}

   AutoCalcXSec := True;  {linked mode XSec inputs}

   If PST<>nil then
     Begin
       If LinkedMode then XSecData := TLoadings.Init(5,5);
     End;

   For i:=1 to 10 do
     With SedData[i] do
       Begin
          BedDepthIC         := 0.3; {m}
          BedDensity         := 0; {g/cm3}
          NotUsed            := 0;
          UpperDispCoeff     := TLoadings.Init(3,3); {m2/d}
          FracWater          := 0; {fraction}
          BedVolume          := 0; {current, m3}
          DynBedDepth        := 0; {m3}
          VolumeLost         := 0; {m3}
          PoreSqueeze        := 0; {m3}
       End;

   StoreResults        := True;
   StoreDistribs       := True;

   TPresent            := -99;
   TPreviousStep       := -99;
   ModelStartTime      := -99;
   YearNum_PrevStep    := -99;

   MeanDischarge       := 0;
   MeanVolume          := 0; {current, m3}
   MeanEstVel          := 0;

   SedNonReactive := False;
   MaxUpperThick := 0.5;
   BioTurbThick  := 0.2;

   Anoxic              := False;
   Stratified          := False;
   StudyProgDlg        := nil;

   ClearMBData(0);

   For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
     Begin
        GullBMF  [ToxLoop] := 0;
        GullClear[ToxLoop] := 0;
        GullRef  [ToxLoop] := '';
        GullClearRef[ToxLoop] := '';
     End;
   Blank.Pref   := 0;
   Blank.ECoeff := 0;
   Blank.XInteraction := '';
   For nsloop := SedmRefrDetr to LastBiota do
     GullPref[nsloop] := Blank;

   LastCalcEstVel:=0; LastTimeEstVel:=0;
   LastPctEmbedCalc := -99;
   PercentEmbedded := 0;

   UseConstEvap := True;
   DynEvap      := TLoadings.Init(10,50);

   UseConstZMean := True;
   DynZmean      := TLoadings.Init(10,50);

   LinkedMode := False;

   BirdPrey:= TCollection.Init(10,5);
   PO2Concs  := TLoadings.Init(100,50);
   PSedConcs := TLoadings.Init(100,50);
   PLightVals := TLoadings.Init(50,50);

End;  {TStates.Init}

{-----------------------------------------------------------------------------------------}
Procedure TStates.DestroyResults(Control: Boolean);
Var Loop: VerticalSegments;
Begin
  For Loop:=Epilimnion to Hypolimnion do
    Begin
      If Control and (ControlResults[loop] <> nil) then
        Begin
          ControlResults[loop].destroy;
          ControlResults[loop] := nil;
        End;

      If not Control and (Results[loop] <> nil) then
        Begin
          Results[loop].destroy;
          Results[loop] := nil;
        End;
    End;
End;

{-----------------------------------------------------------------------------------------}

Function TStates.Keyof(Item: Pointer): Pointer;
begin
  KeyOf:=Item;
end;

Function TStates.Compare(key1,key2: pointer):integer;

{*****************************************************}
{ This function determines the order in which the     }
{ TStateVariable objects are sorted in their TStates  }
{ Collection.  The list is now sorted on two keys:    }
{ SV_Type and then NState.                            }
{                                                     }
{ Coded by JSC, Modified 7/24/98                      }
{*****************************************************}

begin
     If      TStateVariable(key1).Layer   > TStateVariable(key2).Layer  then compare:=1
     else if TStateVariable(key1).Layer   < TStateVariable(key2).Layer  then compare:=-1
     else if TStateVariable(key1).SVType  > TStateVariable(key2).SVType then compare:=1
     else if TStateVariable(key1).SVType  < TStateVariable(key2).SVType then compare:=-1
     else if TStateVariable(key1).nstate  > TStateVariable(key2).nstate then compare:=1
     else if TStateVariable(key1).nstate  < TStateVariable(key2).nstate then compare:=-1
     else compare:=0;
end;


Function TStates.GetIndex(S: AllVariables;  T: T_SVType; L:T_SVLayer) : integer;
begin
    If T>PIntrnl then GetIndex:=-1
                 else GetIndex:=MemLocRec.Indx[S,T,L];
end;

Function TStates.StaticZMean: Double;
Var PVol: TVolume;
Begin
  With Location.Locale do
   If UseBathymetry
    then StaticZMean := Location.Locale.ICZMean  {zmean does not vary in this case}
    else
      Begin
        PVol := GetStatePointer(Volume,StV,WaterCol);
        StaticZMean := PVol.InitialCond / SurfArea;  {Initial zmean based on const surf area over vertical profile}
            {m}           {m3}               {m2}
      End;       

End;

{----------------------------------------------------------------------}

Function TStates.OrgTox_In_System: Boolean;
{ sees if there's an organic toxicant in the system }
Var Loop: StateVariables;
    ToxLoop: T_SVType;
Begin
  OrgTox_In_System:=False;
  For ToxLoop:=FirstOrgTxTyp to LastOrgTxTyp do
    If GetState(AssocToxSV(ToxLoop),StV,WaterCol) > Tiny
      then Begin
             OrgTox_in_System := True;
             Exit; {optimization}
           End;

  For ToxLoop:=FirstOrgTxTyp to LastOrgTxTyp do
    If GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol) <> nil then
      For Loop:=FirstState to LastState do
        If GetState(Loop,ToxLoop,WaterCol)>Tiny then
          Begin
            OrgTox_In_System:=True;
            Exit; {Exit the Function}
          End;
End;
{----------------------------------------------------------------------}

Function TStates.NumOrgToxicants: Integer; {num toxicants in SV List}
Var ToxLoop: AllVariables;
Begin
 Result := 0;
 For ToxLoop := FirstOrgTox to LastOrgTox do
   If GetIndex(ToxLoop,StV,WaterCol) > -1 then
      Inc(Result);

End;
{----------------------------------------------------------------------}

Function TStates.DynamicZMean: Double;  {Variable ZMean of segment or both segments if dynamic stratification}
Begin
  If Not Location.Locale.UseBathymetry then
    Begin
      DynamicZMean := Volume_Last_Step / Location.Locale.SurfArea;
      Exit;
    End;

  If UseConstZmean
    then DynamicZMean := Location.Locale.ICZMean
    else DynamicZMean := DynZMean.GetLoad(TPresent,True);
  If Result=0 then DynamicZMean := Location.Locale.ICZMean;
End;

{----------------------------------------------------------------------}
Function  TStates.SegVol: Double;        {volume of segment or individual layer if stratified}
Begin
  If LinkedMode or (not Stratified) then SegVol := Volume_Last_Step
                                    else SegVol := Location.Morph.SegVolum[VSeg];
End;
{----------------------------------------------------------------------}
Function  TStates.SurfaceArea: Double;   {Surface area of segment or individual layer if stratified}
Var EpiFrac: Double;
Begin
  SurfaceArea := Location.Locale.Surfarea;
  If (not LinkedMode) and (Stratified) and (Location.Locale.UseBathymetry)
    then
      Begin
        With Location do with Locale do
        EpiFrac := AreaFrac(MeanThick[Epilimnion],ZMax);
        If VSeg = Epilimnion then SurfaceArea := Result * EpiFrac
                             else SurfaceArea := Result * (1-EpiFrac);
      End;
End;

{----------------------------------------------------------------------}

Function TStates.PhytoResFactor: Double;
Var TotLen, Area_Mi2: Double;
Begin
    PhytoResFactor := 1.0;
    With Location.Locale do
     If Not UsePhytoRetention or
        ((EnterTotalLength and (TotalLength = 0)) or
         ((not EnterTotalLength) and (WaterShedArea=0)))
      then exit
      else With Location.Locale do
        Begin
          If EnterTotalLength
            then TotLen := TotalLength
            else
              Begin
                Area_Mi2 := WatershedArea * 0.386;
                {mi2}       {km2}
                TotLen := 1.4 * POWER(Area_Mi2,0.6);   {Leopold et al. 1964, p. 145}
                {mi}                    {mi2}
                TotLen := TotLen * 1.609;
                {km}       {mi}
              End;

          PhytoResFactor := TotLen/SiteLength;

          If Result < 1.0 then Raise EAQUATOXError.Create('Phytoplankton Retention Parameterization Error.  Total site length is less than segment length.'); 
        End;
End;

{----------------------------------------------------------------------}

Function TStates.Ice_Cover_Temp: Double;
Begin
  Case Location.SiteType of
    Estuary: Ice_Cover_Temp := -1.8; {Ocean water with a typical salinity of 35 parts per thousand freezes only at -1.8 degC (28.9 deg F).}
    Stream:  Ice_Cover_Temp :=  0.0; {Temperature at which ice cover assumed to occur in moving water}
    else     Ice_Cover_Temp :=  3.0; {Temperature at which ice cover occurs in fresh water}
  end; {case}
End;

{----------------------------------------------------------------------}

Function TStates.Velocity(PctRiffle,PctPool:Double; Averaged: Boolean): Double;
Var XSecArea, AvgFlow,UpFlow,DownFlow: Double;
    PctRun,RunVel,RiffleVel,PoolVel,Vol: Double;
    {----------------------------------------------------------------------------------------------------}
    Procedure EstuaryVelocity;
    Var ResidFlowVel,TidalVel,TidalPrism: Double;
        PV: TVolume;
    Begin
       With Location.Locale do
         If SiteWidth<=0 then Raise EAQUATOXERROR.Create ('"Site Width" in the Site Data Record must be greater than zero');

       If Not Averaged
         Then
           Begin
             If (TPresent = LastTimeEstVel) then Begin Velocity := LastCalcEstVel; Exit; End;
               {Optimization of daily estuary calculation}

             With Location.Locale do
               XSecArea := SiteWidth * DynamicZMean;
                  {m2}        {m}           {m}

             PV := GetStatePointer(Volume,StV,WaterCol);
             TidalPrism := 2.0 * PV.TidalAmplitude(TPresent) * Location.Locale.SurfArea;
               {m3/d}                        {m/d}                                {m2}
             TidalVel := TidalPrism / XSecArea;
               {m/d}       {m3/d}       {m2}
             ResidFlowVel := Location.Discharge[Epilimnion] / XSecArea;
               {m/d}                   {outflow m3/d}            {m2}
             Velocity := ABS(ResidFlowVel + TidalVel * (1+0.5*SIN(2*pi*JulianDate(TPresent)/12))) /86400 * 100;
               {cm/s}            {m/d}        {m/d}                                                {s/d} {cm/m}

             LastCalcEstVel:=Result; LastTimeEstVel:=TPresent;
            {Optimization of daily estuary calculation}
          End
        Else {Averaged=True} Velocity := MeanEstVel {Averaged over a year}
    End;
    {----------------------------------------------------------------------------------------------------}

Begin
   If EstuarySegment then
     Begin
       EstuaryVelocity;
       Exit;
     End;

  If Averaged then Vol := MeanVolume
              else Vol := Volume_Last_Step;

  If (Location.SiteType=Stream)
    then Begin
            CalcHRadius(Averaged);
            XSecArea := Sed_Data.Width * Sed_Data.Channel_Depth ;
               {m2}               {m}                  {m}
            If Averaged then CalcHRadius(False);
         End
    else XSecArea := Vol / (Location.Locale.SiteLength * 1000);
                    {m3}                        {km}      {m/km}

  PctRun := 100 - PctRiffle - PctPool;

  If (CalcVelocity or Averaged) then
    Begin
        With Location do with Morph do
          Begin
            UpFlow   := InflowH2O[VSeg];
            DownFlow := Discharge[VSeg];
          End;

        If Averaged then
          Begin
            UpFlow := MeanDischarge;  {m3/d}
            DownFlow := MeanDischarge;
          End;

        AvgFlow := (UpFlow + DownFlow) / 2;
         {m3/d}      {m3/d}  {m3/d}

        RunVel := AvgFlow / XSecArea * (1/86400) * 100;
        {cm/s}      {m3/d}    {m2}    {  d/s  }   {cm/m}

        If RunVel<0 then RunVel:=0;
    End
      Else
        Begin  {User Entered Velocity}
          RunVel := DynVelocity.GetLoad(TPresent,True);
           {cm/s}
          AvgFlow :=  RunVel * XSecArea * 86400 * 0.01;
           {m3/d}     {cm/s}    {m2}      {s/d}  {m/cm}
        End;

  If AvgFlow < 2.59E5
    then
      Begin   {Q < 2.59e5 m3/d}
        RiffleVel := 1.60 * RunVel;
        PoolVel   := 0.36 * RunVel;
      End
    else If AvgFlow < 5.18E5
      then
        Begin  {2.59E5 m3/d < Q < 5.18e5 m3/d}
          RiffleVel := 1.30 * RunVel;
          PoolVel   := 0.46 * RunVel;
        End
      else If AvgFlow < 7.77E5
        then
          Begin { 5.18e5 m3/d Q < 7.77e5 m3/d }
            RiffleVel := 1.10 * RunVel;
            PoolVel   := 0.56 * RunVel;
          End
        else
          Begin  { Q >= 7.77e5 m3/d }
            RiffleVel := 1.00 * RunVel;
            PoolVel   := 0.66 * RunVel;
          End;

  Velocity := (RiffleVel * (PctRiffle /100)) +
   {cm/s}     (RunVel    * (PctRun    /100)) +
              (PoolVel   * (PctPool   /100));
End;


Function TStates.SedLayerArea: Double;
Begin
  With Location.Locale do
      SedLayerArea := SurfArea  {even if surface area grows or shrinks, track sediments under initial surface area}
                       {m2}
End;

Function TStates.MaxEpiThick: Double;
Begin
  If not Z_Thermocline.NoUserLoad then
    Begin
      MaxEpiThick := ReturnLoad(TPresent,Z_Thermocline);
    End
  else
    With Location do with Locale do
      If (Not UseBathymetry) then MaxEpiThick := MeanThick[Epilimnion] {used for depthtop of hypolimnion}
                             else MaxEpiThick := POWER(10, (0.336 * log10(SiteLength*1000) - 0.245)) {Hanna, 1990}
End;

Function TStates.ThermoclArea: Double;
Var PThermoSeg: TSegmentLink;
Begin
  With Location do
    If LinkedMode and Stratified
      Then
        Begin
          PThermoSeg := ThermLink;                            {Thermocline area is defined by the}
          ThermoClArea := PThermoSeg.GetXSection(TPresent);   {area between the epi and hypo segment}
          If Result > 0 then exit;  {otherwise use bathymetry calculation below if user did not enter thermocline area.  10/14/2010}
        End;

  With Location do
    if LinkedMode and (not Stratified)
        then ThermoclArea := 0  {Thermocl Area not relevant in this case}
        else Begin
                If EstuarySegment
                  then ThermoclArea := Locale.SurfArea * (1-AreaFrac(MeanThick[Epilimnion], Locale.ZMax))  {estuary mode}
                  else ThermoclArea := Locale.SurfArea * (1-AreaFrac(MaxEpiThick, Locale.ZMax));  {not linked mode or user did not enter thermocline area}
             End

End;



Function TStates.GetPStatesFromID(ID: SegIDString): TStates;
Var PC: TCollection;
    i: Integer;
    PSV: TStateVariable;
Begin
   GetPStatesFromID := nil;
   If Not LinkedMode then exit;

   PC := PAllSVsColl;
   For i := 0 to PC.Count-1 do
     Begin
       PSV := PC.At(i);
       If PSV.Allstates.PSegID^ = ID then
         Begin
           GetPStatesFromID := PSV.AllStates;
           Break;
         End;
     End;
End;

Function TStates.GetIndexFromName(S : ShortString) : integer;
{This Function does not need to be optimized, it is never used within
the study runs}

Var i : integer;
    NotFound : boolean;
Begin
   i:=0;
   NotFound:=True;
   While (i<Count) and (NotFound) do
     begin
       if AbbrString(TStateVariable(At(i)).PName^,':')=S
         then NotFound:=False
         else i:=i+1;
     end;
   if Notfound then i:=-1;
   GetIndexFromName:=i;
End;


Function TStates.GetState(S:AllVariables; T:T_SVType; L:T_SVLayer) : double;
var p: TStateVariable;
begin
   p:=GetStatePointer(S,T,L);
   if not (p=nil) then GetState:=p.State
                  else GetState:=-1;
end;


Function TStates.GetStatePointer(S: AllVariables; T: T_SVType; L:T_SVLayer ) : pointer;

begin
  Try
   If (T>PIntrnl) or (s< H2OTox1) or (S>=NullStateVar)
                   then GetStatePointer:=nil
                   else GetStatePointer:=MemLocRec.Ptr[S,T,L];
  Except
   Raise EAQUATOXError.Create('Error Accessing Pointer (MemLocRec)');
  End;
end;


Function TStates.GetStatePointerFromName(S : ShortString) : pointer;
var temp:pointer;
    i : integer;
begin
   temp:=nil;
   i:=GetIndexFromName(AbbrString(S,':'));
   if i>=0 then temp:=TStateVariable(At(i));
   GetStatePointerFromName:=temp;
end;


Function TStates.GetLoad(S: AllVariables;  T: T_SVType; L:T_SVLayer) : double;
var temp:double;
    p : pointer;
begin
   temp:=0;
   p:=GetStatePointer(S,T,L);
   if (not (p=nil)) then temp:=TStateVariable(p).Loading;
   GetLoad:=temp;
end;


Procedure TStates.CalculateAllLoads(TimeIndex : double);
var i: integer;
    Junk: Double;
begin
   If EstuarySegment then TSalinity(GetStatePointer(Salinity,StV,WaterCol)).CalculateLoad(TimeIndex); {get salinity vals for salt balance}
   TVolume(GetStatePointer(Volume,StV,WaterCol)).CalculateLoad(TimeIndex);
   TVolume(GetStatePointer(Volume,StV,WaterCol)).Derivative(Junk);
   For i:=0 to count-1 do
     TStateVariable(At(i)).CalculateLoad(TimeIndex);
end;

{-----------------------------------------------------------------------------------------}
Function TStates.InorgSedDep(InclSand: Boolean): Double;
Var SurfArea, Sed, SS60day : Double;
    BSSand,BSSilt, BSClay: TBottomSediment;
    SSand,SSilt, SCLay: TSandSiltClay;

Begin
    Sed := 0;
    SurfArea := Location.Locale.SurfArea;
    BSSand := GetStatePointer(NonCohesives2,Stv,SedLayer1);
    BSSilt := GetStatePointer(NonCohesives,Stv,SedLayer1);
    BSClay := GetStatePointer(Cohesives,Stv,SedLayer1);
    SSand  := GetStatePointer(Sand,Stv,WaterCol);
    SSilt  := GetStatePointer(Silt,Stv,WaterCol);
    SClay  := GetStatePointer(Clay,Stv,WaterCol);

    If (BSSilt=nil) and (SSilt=nil) then  { 3-5-08 No sand-silt-clay model             }
      Begin                               { so use fn. based on 60 day avg TSS         }
        SS60Day := InorgSed60Day(FALSE);  { function is used for both filter-          }
        If SS60Day < tiny                 { feeding dilution and benthic drift trigger }
          then InorgSedDep := 0
          else InorgSedDep	:=	0.270 * ln(SS60Day) - 0.072;
             { kg/m2 day                    mg/L }
          If Result<0 then Result := 0;   
        Exit;
      End;

    If BSSilt <> nil then
      Sed := (BSSilt.Deposition + BSClay.Deposition) / SurfArea ;
    {g/m2 d}            {g/d}                 {g/d}        {m2}
    If (BSSand <> nil) and InclSand then
      Sed := Sed + (BSSand.Deposition) / SurfArea ;
    {g/m2 d}           {g/d}               {m2}

    If SSilt <> nil then
      Sed := (SSilt.Deposition + SClay.Deposition) * SegVol / SurfArea;
    {g/m2 d}       {g/m3 day}          {g/m3 day}     {m3}     {m2}
    If (SSand <> nil) and InclSand then
      Sed := Sed       + (SSand.Deposition) * SegVol / SurfArea;
    {g/m2 d} {g/m2 d}        {g/m3 day}       {m3}        {m}

    InorgSedDep := Sed      /  1000;
      {kg/m2 d}  {g/m2 d}     {g/kg}
End;
{-----------------------------------------------------------------------------------------}

Function TStates.CalcDeposition(NS: AllVariables; Typ: T_SVType): Double;  {Calc deposition input into diagenesis model}
{ Calculate Deposition for each sed carbon & nutrient class in  (gC/m2 d) (gN/m2 d) (gP/m2 d) (gSi/m2 d}

Const Def_to_G3= 0.00;  {0% of defecation to G3}

Var Def, Sed : Double;
    {- - - - - - - - - - - - - - - - - - - - - - - - - - - }
    Procedure SumDef(PA: TAnimal);
      Var   NFrac, Def2Detr   : Double;
          { all defecation goes to sediment }
      Begin
        If NS = Avail_Silica then Exit;
        If PA.IsAnimal Then
          Begin
            Case NS of
                PON_G1, POP_G1, POC_G1:  {G1 equivalent to labile}
                       Def2Detr := Def2SedLabDetr * (1-Def_to_G3);
                PON_G2, POP_G2, POC_G2:  {G2 equivalent to refractory}
                       Def2Detr := (1-Def2SedLabDetr) * (1-Def_to_G3);
                else   Def2Detr := Def_to_G3;  {G3 class is inert}
             end; {case}

            Case NS of PON_G1..PON_G3:  NFrac := Location.Remin.N2OrgLab;  {Was PA.PAnimalData.N2Org, 6/6/2008, defecation has same nutrients as labile detritus}
                       POP_G1..POP_G3:  NFrac := Location.Remin.P2OrgLab;  {Was PA.PAnimalData.P2Org, 6/6/2008, defecation has same nutrients as labile detritus}
                else  {POC_G1..POC_G3:} NFrac := 1/Detr_OM_2_OC;  {Winberg et al. 1971, relevant to animals, non-macrophyte plants, bacteria}
             end; {Case}

             If (Typ = StV)
                 then Def := Def + Def2Detr * PA.Defecation * NFrac
                     {g/m3}             {g/m3}
                 else Def := Def + Def2Detr * PA.DefecationTox(Typ) * 1e3;
                    {ug/m3}        {unitless}           {ug/L}        {L/m3}

          End;
      End;
    {- - - - - - - - - - - - - - - - - - - - - - - - - - - }
    Procedure SumSed(P: TStateVariable);
    Const PlantSinkLabile = 0.92;
    var PP:TPlant;
        NFrac, Frac: Double;
      begin
       {Ignore the N and P content in G3 because it is so small.}
       {Currently No Macrophyte Linkage through mortality & breakage}
       If (P.SVType<>StV) then exit;

       If P.IsAlgae then
        begin
          PP:=TPlant(P);

          Case NS of
              Avail_Silica : Frac := 1.0;
              PON_G1, POP_G1, POC_G1:  {G1 equivalent to labile}
                     Frac := PlantSinkLabile;
              PON_G2, POP_G2, POC_G2:  {G2 equivalent to refractory}
                     Frac := (1-PlantSinkLabile);
              else   Frac := 0;        {G3 class is inert, no plant sink to G3 for now}
           end; {Case}

          With Diagenesis_Params^ do
          Case NS of Avail_Silica  :  If PP.NState in [FirstDiatom..LastDiatom]  {taxonomic type diatoms}
                                        then NFrac := Si_Diatom.Val
                                        else NFrac := 0;
                     PON_G1..PON_G3:  NFrac := PP.N_2_Org;
                     POP_G1..POP_G3:  NFrac := PP.P_2_Org;
                else  {POCG1..POCG3:} NFrac := 1/Detr_OM_2_OC;  {Winberg et al. 1971, relevant to animals, non-macrophyte plants, bacteria}
           end; {case}

          If Not PP.IsLinkedPhyto {in which case all deposition goes to the periphyton directly}
            Then
              Begin
               If (Typ = StV)
                 then Sed := Sed + PP.Sedimentation * Frac * NFrac
                     {g/m3}             {g/m3}
                 else Sed := Sed + PP.Sedimentation * Frac * GetPPB(PP.NState,Typ,PP.Layer) * 1e-3;
                    {ug/m3}             {g/m3}                      {ug/kg}                     {kg/g}
              End; {not linkedphyto}

        end; {algae}

        If ((P.NState=SuspLabDetr)  and (ns in [PON_G1,POP_G1,POC_G1])) or   {G1 equivalent to labile}
           ((P.NState=SuspRefrDetr) and (ns in [PON_G2,POP_G2,POC_G2,POC_G3])) then
             Begin
               If (Typ = StV) then
                With Location.Remin do With Diagenesis_Params^ do
                 Case NS of PON_G1 :  NFrac := N2OrgLab;
                            PON_G2 :  NFrac := N2Org_Refr;
                            POP_G1 :  NFrac := P2OrgLab;
                            POP_G2 :  NFrac := P2Org_Refr  ;
                            POC_G3 :  NFrac := 1/Detr_OM_2_OC * LigninDetr.Val;
                            POC_G2 :  NFrac := 1/Detr_OM_2_OC * (1-LigninDetr.Val) ;
                       else {POCG1:}  NFrac := 1/Detr_OM_2_OC;
                 End {Case}

               Else {If (Typ <> StV) then}
                With Location.Remin do With Diagenesis_Params^ do
                 Case NS of POC_G3 :  NFrac := LigninDetr.Val;
                            POC_G2 :  NFrac :=(1-LigninDetr.Val);
                       else {POCG1:}  NFrac := 1;
                 End; {Case}

               If (Typ = StV)
                 then Sed := Sed + TSuspendedDetr(P).Sedimentation  * NFrac
                     {g/m3}                               {g/m3}
                 else Sed := Sed + TSuspendedDetr(P).Sedimentation  * NFrac * GetPPB(P.NState,Typ,P.Layer) * 1e-3
                    {ug/m3}                               {g/m3}       {ug/kg}                         {kg/g}
             End; {Detritus}

      end;
    {- - - - - - - - - - - - - - - - - - - - - - - - - - - }
Var i: Integer;
Begin
  Def := 0; Sed := 0;
  For i:=0 to count-1 do
    Begin
      SumSed(at(i));
      SumDef(at(i));
    End;

  With Location.Morph do With Diagenesis_Params^ do
  CalcDeposition := (Sed + Def) *  SegVolum[VSeg]  / DiagenesisVol(2) * H2.Val;
   {g/m2 d}         {   g/m3 w  }      {m3 w}         {m3 sed}         {m sed}
   {ug/m2 d}        {   ug/m3 w  }     {m3 w}         {m3 sed}         {m sed}  {toxicant deposition units}

End;
{-----------------------------------------------------------------------------------------}

Procedure Linear_System(a11, a12, a21, a22, b1, b2: double; Var x1, x2: Double);

Begin
  x1 := (a22 * b1 - a12 * b2) / (a11 * a22 - a12 * a21);
  x2 := (a11 * b2 - a21 * b1) / (a11 * a22 - a12 * a21);
End;

{-----------------------------------------------------------------------------------------}
Function TStates.Diagenesis_Included: Boolean;
Begin
  Diagenesis_Included := GetStatePointer(POC_G1,StV,SedLayer2) <> nil;
End;
{-----------------------------------------------------------------------------------------}

Function TStates.DiagenesisVol(Layer: Integer): Double;  {Sed Volume Diagensis}
Var EpiFrac: Double;
Begin
  If Layer = 1 then  DiagenesisVol := Location.Locale.SurfArea * Diagenesis_Params.H1.Val
               else  DiagenesisVol := Location.Locale.SurfArea * Diagenesis_Params.H2.Val;
                        {m3}                             {m2}                          {m}

  If Stratified then
    Begin
       With Location do With Morph do
       EpiFrac := AreaFrac(MeanThick[Epilimnion],Location.Locale.ZMax);  //10-14-2010 Note that ZMax parameter pertains to both segments in event of stratification
       If VSeg=Epilimnion then DiagenesisVol := Result * EpiFrac
                          else DiagenesisVol := Result * (1-EpiFrac);
    End;
End;

{-----------------------------------------------------------------------------------------}

Function TStates.MassTransfer: Double;
Var O2: Double;
Const MAX_S : Double = 1; {m/d}
Begin
    O2 := GetState(Oxygen, StV, WaterCol);
    If (O2< tiny)
        then MassTransfer := MAX_S {1e6}  {max mass transfer if o2 goes to zero}
        else MassTransfer := SOD    /  O2; {mass transfer coeff}
               {m/d}     {go2/m2 d}  {gO2/m3}

    If Result > MAX_S then Result := MAX_S;
    If Result < tiny then Result := Tiny; {avoid divide by zero error}
End;

{-----------------------------------------------------------------------------------------}

Procedure TStates.CalculateSOD;  {Calc deposition input into diagenesis model}

{AQUATOX has been modified to include a representation of the sediment bed as
 presented in Di Toro’s Sediment Flux Modeling (2001).       }

    Procedure SetL1State(NS: AllVariables; Val: Double);
    Var PSV: TStateVariable;
    Begin
      PSV := GetStatePointer(NS,StV,SedLayer1);
      PSV.State := Val;
    End;

Var SOD_test, s, Temp, O2, CSOD, NSOD: Double;
    IV, ns: AllVariables;
    TInv  : TAnimal;
    BenthicBiomass: Double;
    ErrorOK: Boolean;
    Jc, Jn, Jp, Jc_O2Equiv : Double;  {diagenesis tracking}
    ppc: TPOC_Sediment;
    ppn: TPON_Sediment;
    ppp: TPOP_Sediment;
    JO2NO3, K2NH4, K2Denit_1, KDenit_2 : Double;
    NH3_0, NO3_0, NO3_1, NO3_2, NH4_1, NH4_2: Double;
    PO4_0, PO4_1, PO4_2: Double;
    COD_0, HST1, HST2 : Double;
    a11,a12,b1,a21,a22,b2: Double;
    Sech_Arg, CH4toCO2, CH4Sat, CSODmax : Double;
    fda1, fpa1, fda2, fpa2: Double;  {ammonia}
    fd1, fp1, fd2, fp2: Double;  {H2S}
    k1h1d, k1h1p, k2Oxid: Double;
    k2h2d, k2h2p, F12, F21, xk1, xk2: Double;
    IterCount: Integer;

Begin {CalculateSOD}
  If Not Diagenesis_Included then exit;  {No Diagenesis Model attached}
  O2 := GetState(Oxygen, StV, WaterCol);
  Temp := GetState(Temperature, StV, WaterCol);

  {determine diagenesis fluxes}
  Jc := 0;  Jn := 0;  Jp := 0;

  With Diagenesis_Params^ do
   For ns := POC_G1 to POC_G3 do
    Begin
      ppc := GetStatePointer(ns,Stv,SedLayer2);
      Jc := Jc + ppc.mineralization * H2.Val * 32 / 12 ;       // CSOD
    End; {gO2/ m2 d}    {g C / m3 d}   {m}    {g O2/ g C}

  With Diagenesis_Params^ do
   For ns := PON_G1 to PON_G3 do
    Begin
      ppn := GetStatePointer(ns,Stv,SedLayer2);
      Jn := Jn + ppn.mineralization * H2.Val;                  //NSOD in N units
    End; {gN/ m2 d}    {gN / m3 d}     {m}

  With Diagenesis_Params^ do
   For ns := POP_G1 to POP_G3 do
    Begin
      ppp := GetStatePointer(ns,Stv,SedLayer2);
      Jp := Jp + ppp.mineralization * H2.Val;                  //p mineralization
    End;  {gP/ m2 d}   {gP / m3 d }      {m}

  If SOD < 0 then  {start with an initial esitmate of SOD}
                  SOD_test := Jc    +  (Jn  * 4.57)
                  {gO2 /m2 d}  {gO2/d} {gN2/d} {gO2/gN}
             else SOD_test := SOD;        {use SOD prev. time step}

{  POCG1_2 := GetState(POC_G1,StV,SedLayer2) * 32 / 12 ;
  {mg O2/L}           {mg C / L }           {mg O2/ mg C}

  With Diagenesis_Params^ do
    Begin
      BenthicBiomass := 0;
      For IV := FirstInvert to LastInvert do
        Begin
          TInv := GetStatePointer(IV,StV,WaterCol);
          If TInv <> nil then with Location.Locale do
            If (TInv.PAnimalData^.Animal_Type='Benthic Invert.') or
               (TInv.PAnimalData^.Animal_Type='Benthic Insect') then
                 BenthicBiomass := BenthicBiomass + TInv.State * Volume_Last_Step / SurfArea;
                   {g/m2}             {g/m2}             {g/m3}        {m3}           {m2}
        End;

      If BenthicBiomass < 0.001 then BenthicBiomass := 0.001;  {corresponds to min particle mixing of 1.67E-06 cm/d}

      w12 := POWER(10, log10(BenthicBiomass)-2.778151) * 0.0001  / H2.Val;
     {m/d}   {cm2/d}          {g/m2}                  {m2/cm2}   {m}

(*    w12 := (Dp.val * POWER(ThtaDp.val,(Temp - 20)) / (H2.Val * POC1R.Val + 1e-18)) * (POCG1_2 {/POC1R.Val})
     {m/d}     {m2/d}                                     {m}
                     * (O2 / (Km_O2_Dp.val + O2 + 1e-18)) +{  DpMin.Val} 0.00006 / H2.Val ;
                                                            {min bioturb}  {m2/d}  {m}   *)
      {** NO BENTHIC STRESS FOR NOW **}

      KL12 := Dd.val * POWER(ThtaDd.Val,(Temp - 20)) / (H2.Val);
      {m/d}    {m2/d}                                    {m}
      {** NO Dissolved Phase Mixing Coefficient Due to Organism Activities  **}
    End;
                 
  IterCount := 0;

  With Diagenesis_Params^ do
  Repeat
   NH3_0 := GetState(Ammonia,StV,WaterCol);       //dissolved ammonia water column
   NH4_1 := GetState(Ammonia,StV,SedLayer1);      //ammonia Layer 1
   NH4_2 := GetState(Ammonia,StV,SedLayer2);      //ammonia Layer 2
   NO3_0 := GetState(Nitrate,StV,WaterCol);       //nitrate water column
   NO3_1 := GetState(Nitrate,StV,SedLayer1);      //nitrate Layer 1
   NO3_2 := GetState(Nitrate,StV,SedLayer2);
   PO4_0 := GetState(Phosphate,StV,WaterCol);     //phosphate water column
   PO4_1 := GetState(Phosphate,StV,SedLayer1);
   PO4_2 := GetState(Phosphate,StV,SedLayer2);

   {compute s}
    If (O2< tiny)
       then s := 1e6
       else s  := SOD_Test   / O2; {mass transfer coeff}
            {m/d} {go2/m2 d} {gO2/m3}
    If s < tiny then s := tiny;  {avoid crash solving linear eqns.}

    {Solve for Ammonia}
    fda1 := 1/(1+m1.val * kdNH3.Val);
    fpa1 := 1-fda1;
    fda2 := 1/(1+m2.val * kdNH3.Val);
    fpa2 := 1-fda2;

    If NH4_1 < tiny
      then K2NH4 := 0
      else K2NH4 := TNH4_Sediment(GetStatePointer(Ammonia,StV,SedLayer1)).Nitr_Rate(NH4_1);

   //     Write linear system of equations around Ammonia
    a11 := -fda1 * KL12 - fpa1 * w12 - k2NH4/s - fda1 * s - w2.Val;
    a12 := fda2 * KL12 + fpa2 * w12;
    b1 := -s * NH3_0;
    a21 := fda1 * KL12 + fpa1 * w12 + w2.Val;

    a22 := -fda2 * KL12 - fpa2 * w12 - w2.Val - H2.Val /(1/500);
    { If Layer2 Steady State then a22 := -fda2 * KL12 - fpa2 * w12 - w2.Val; }

    b2 := -Jn - H2.Val /(1/500)* NH4_2;
    { If Layer2 Steady State then b2 := -Jn; }

    Linear_System(a11, a12, a21, a22, b1, b2, NH4_1, NH4_2);

    NSOD := 4.57 * K2NH4/s * NH4_1;
          {gO2/gN}

    {Solve for Nitrate}
    k2Denit_1 := TNO3_Sediment(GetStatePointer(Nitrate,StV,SedLayer1)).DeNit_Rate(NO3_1);
     {m2/d2}
    kDenit_2  := TNO3_Sediment(GetStatePointer(Nitrate,StV,SedLayer2)).DeNit_Rate(NO3_2);
     {m/d}

    a11 := - KL12 - k2Denit_1/ s    - w2.Val - s;
            {m/d} {m2/d2}   {m/d}    {m/d}
    a12 := KL12;
    b1 := -s * NO3_0 - k2NH4/s * NH4_1 ;
        {m/d} {g/m3}   {  m/d }  {g/m3}
    a21 := KL12 + w2.Val;

    a22 := -KL12 - kDenit_2 - w2.Val - H2.Val/(1/500);
          {m/d}     {m/d}    {m/d}    {m/d}

    { If Layer2 Steady_State then a22 := -w12 - kDenit_2 - w2.Val; }

    b2 := -H2.Val/(1/500)* NO3_2;
    { If Layer2 Steady State then b2 := 0; }

    Linear_System(a11, a12, a21, a22, b1, b2, NO3_1, NO3_2);

    {Solve for Methane / Sulfide}

    JO2NO3 := 2.86 * ( K2Denit_1/s * NO3_1  + KDenit_2 * NO3_2);
    {g/m2 d}           {m2/d2} {m/d} {g/m3}    {m/d}     {g/m3}

    Jc_O2Equiv := Jc - JO2NO3;

    If GetState(Salinity,StV,WaterCol) < SaltSW.Val {ppt}
      then
        Begin      {Solve for Methane}
          If Jc_O2Equiv < 0 then JC_O2Equiv := 0;

          CH4SAT := 100 * (1 + DynamicZMean / 10) * POWER(1.024,(20 - Temp));
                                    {m}
          CSODmax := Min(Sqrt(2 * KL12 * CH4SAT * JC_O2equiv), JC_O2equiv);
          SECH_ARG := (KappaCH4.Val * POWER(ThtaCH4.Val , (Temp - 20))) / s ;  //     CSOD Equation 10.35 from DiTorro
          If (SECH_ARG < 400)                                            //    The hyperbolic secant is defined as HSec(X) = 2 / (Exp(X) + Exp(-X))
            Then CSOD := CSODmax * (1 - (2 / (Exp(SECH_ARG) + Exp(-SECH_ARG))))
            Else CSOD := CSODmax;
        End                                          // HSec(SECH_ARG) < 3.8E-174 ~ 0
    else
      Begin  {solve for sulfide}
        HST1 := GetState(Sulfide,StV,SedLayer1);
        HST2 := GetState(Sulfide,StV,SedLayer2);
        COD_0 := GetState(COD,StV,WaterCol);

        fd1 := 1/(1+m1.val * kdH2S1.Val);
        fp1 := 1- fd1;
        fd2 := 1/(1+m2.val * kdH2S2.Val);
        fp2 := 1 - fd2;

        k2Oxid := TSulfide_Sediment(GetStatePointer(Sulfide,StV,SedLayer1)).K2Oxid;
        F12 := w12 * fp1 + KL12 * fd1;
        F21 := w12 * fp2 + KL12 * fd2;

        a11 := -F12 - k2Oxid/s - w2.val - fd1*s;
        a12 := F21;
        b1 := -s * COD_0;

        a21 := F12 + w2.val;
        a22 := -F21 - w2.val - H2.val/(1/500);
        b2  := -JC_O2equiv - H2.val/(1/500)* HST2;

        Linear_System(a11, a12, a21, a22, b1, b2, HST1, HST2);

        { CSOD }
        CSOD := (k2Oxid / s)  * HST1;
      End;

    {Test Derived SOD_Test}
    SOD := (SOD_test + CSOD + NSOD) / 2;
  {g O2/m2 d}

    If SOD=0 then ErrorOK := True
             else ErrorOK := ABS((SOD-SOD_test)/SOD) <= SetupRec.RelativeError;

    inc(IterCount);
    if IterCount > 5000 then ErrorOK := True;

    SOD_test := SOD;

  Until ErrorOK;

  If Diagenesis_Steady_State then
   With Diagenesis_Params^ do
    Begin   {   STEADY STATE IN LAYER 1  }
      SetL1State(Ammonia,NH4_1);
      SetL1State(Nitrate,NO3_1);
      SetL1State(Sulfide,HST1);

      {Solve PO4}
      fd1 := TPO4_Sediment(GetStatePointer(Phosphate,StV,SedLayer1)).fdp1;
      fp1 := 1 - fd1;
      fd2 := (1 / (1 + m2.val * KdPO42.val));
      fp2 := 1 - fd2;

      a11 := -fd1 * KL12 - fp1 * w12 - fd1 * s - w2.val;
      a12 := fd2 * KL12 + fp2 * w12;
      b1  := -s * PO4_0;
      a21 := fd1 * KL12 + fp1 * w12 + w2.val;
      a22 := -fd2 * KL12 - fp2 * w12 - w2.val - H2.val/(1/500);
      b2  := -Jp - H2.val/(1/500)* PO4_2;
{     If Layer2 steadystate Then
        Begin
           a22 := -fd2 * KL12 - fp2 * w12 - w2.val;
           b2  := -Jp;
        End; }


      Linear_System(a11, a12, a21, a22, b1, b2, PO4_1, PO4_2);
      SetL1State(Phosphate,PO4_1);
   {  SetL1State(Silica,Si_1);    } {steady state for silica not complete}
    End;

End;  {CalculateSOD }

{-----------------------------------------------------------------------------------------}
Function TStates.Diagenesis_Detr(NS: AllVariables): Double; {quantity of sedimented detritus in diagenesis model in mg/L(wc)}
Var OM, SedN_OM,SedP_OM,SedC_OM: Double;
Begin
  With Location.Remin do
   If NS=SedmRefrDetr then
      Begin
        SedN_OM := GetState(PON_G2,StV,SedLayer2) / N2Org_Refr;
        SedP_OM := GetState(POP_G2,StV,SedLayer2) / P2Org_Refr;
        {g OM/m3 s}        {g P or N / m3 }       {g P or N / g OM}
        SedC_OM := GetState(POC_G2,StV,SedLayer2) * Detr_OM_2_OC;
        {g OM/m3 s}         {g OC/m3}              {g OM / g OC}
      End
    else {SedmLabDetr}
      Begin
        SedN_OM := GetState(PON_G1,StV,SedLayer2) / N2OrgLab;
        SedP_OM := GetState(POP_G1,StV,SedLayer2) / P2OrgLab;
        {g OM/m3}          {g P or N / m3}         {g P or N / g OM}
        SedC_OM := GetState(POC_G1,StV,SedLayer2) * Detr_OM_2_OC;
        {g OM/m3}          {g OC/m3}               {g OM / g OC}
      End;

  OM   := Min(SedN_OM,Min(SedP_OM,SedC_OM));
 {g OM /m3}

  With Location.Morph do
    Diagenesis_Detr := OM * DiagenesisVol(2) / SegVolum[VSeg];
    {g OM/m3 water}   {g/m3}    {m3}            {m3 water}
End;

{-----------------------------------------------------------------------------------------}

{-----------------------------------------}
{      microbial decomposition            }
{ Relevant to Organic Matter and Toxicant }
{-----------------------------------------}

Function TStateVariable.Decomposition(DecayMax, KAnaer : double; Var FracAerobic: Double) :double;
Var   T, p, Decomp, KMicrob, DOCorr, Factor, HalfSatO, O2Conc, EnvironLim : double;
  {-------------------------------------------------------------}
  Function DecTCorr: Double;
  var    Temp, Theta : double;
  const  Theta20 = 1.047;
  Begin
     Temp := GetState(Temperature,StV,WaterCol);
     If Temp >= 19 then
       Theta := Theta20
     else
       Theta := 1.185 - 0.00729 * Temp;
     DecTCorr := POWER(Theta, (Temp - Location.Remin.TOpt));
     If Temp > Location.Remin.TMax then
       DecTCorr := 0;
  End; {DecTCorr}
  {-------------------------------------------------------------}
Begin
  Decomposition:= 0;

 { O2Conc := 0; }
{ If Layer = WaterCol  then O2Conc := GetState(Oxygen,StV,WaterCol); }
(*  If (Layer = SedLayer1) or (NState in [SedmLabDetr,SedmRefrDetr])
                       then  O2Conc := GetState(Oxygen,StV,WaterCol) * 0.50; {Assume 50% as much O2 in active layer}  *)

  O2Conc := GetState(Oxygen,StV,WaterCol);
  If Layer > SedLayer1 then O2Conc := 0;      {Anaerobic below active layer}

  FracAerobic := 0;
  If ((nstate in [SuspRefrDetr,DissRefrDetr,SedmRefrDetr]) and (SVType=StV)) then exit;
  If DecayMax < tiny then Exit;

  If State > VSmall then
  Begin
    if (Layer = SedLayer1) or (NState in [SedmLabDetr,SedmRefrDetr]) {orgtox or stv}
       then HalfSatO := 8.0 {to acct. for anoxia in sediment & near-sed. zone}
       else HalfSatO := 0.5;  {Bowie et al., 1985}
    with Location.Remin do
      begin
  {     T := AllStates.TCorr(Q10, TRef, TOpt, TMax);}
        T := DecTCorr;
        p := TRemineralize(Self).pHCorr(pHMin, pHMax);
      end;

    If O2Conc=0 then Factor := 0
                else Factor :=  O2Conc/(HalfSatO + O2Conc);

    DOCorr   := Factor + (1.0 - Factor) * KAnaer/DecayMax;

    If DoCorr>Tiny then FracAerobic := (Factor/DoCorr);  {Return Fraction of Decomp. that is Aerobic for BioTransformation Calc.}

    EnvironLim := DOCorr * T * p;
    KMicrob   := DecayMax * EnvironLim;
    {1/d}          {1/d}      {frac}
    Decomp  :=  KMicrob * State;
   {g/m3 d}      {1/d}   {g/m3 or ug/L for toxicants}
  End {> VSmall}
  else
    Decomp := 0.0;

  Decomposition := Decomp;
End;                      {microbial}

{-----------------------------------------------------------------------------------------}

Procedure Convert_Initial_Condition_Units(P: TStateVariable);
{Sedimented Detritus, Mercury Init Conditions, Periphyton & Macrophytes, and Zoobenthos and Fish must
 have their initial conditions converted.}

Var Mass: Double;
    CarrierState: Double;
    Wet2Dry: Double;

Begin
  { Toxicant that is neither buried nor dissolved in water must have its InitCond converted
    to mass from ppb.  Utilizes wettodry, so must be after CalcWetToDry call }
  If (p.SVType in [FirstToxTyp..LastToxTyp]) and (p.Layer=WaterCol) then
        Begin
          CarrierState:=P.AllStates.GetState(TToxics(P).Carrier,StV,WaterCol);

          If P.nstate in [SedmRefrDetr..SuspLabDetr] then Wet2Dry := 1.0
                                                     else Wet2Dry := TToxics(P).WetToDry;

                  {detritus input in dry weight units, no conversion necessary, 9-29-2006}

          Mass := P.InitialCond * Wet2Dry / 1e6 * CarrierState;
         {ug/L}     {(ug/kg)     (unitless) (mg/kg)     (mg/L)}

          P.State:= Mass;
        End;

  { Toxicant in multi-layer sediment model, diagenesis model must have InitCond converted to ug/m2 from ppb }
  If (p.SVType in [FirstToxTyp..LastToxTyp]) and ((p.nstate in [BuriedRefrDetr,BuriedLabileDetr]) or
        ((p.Layer>WaterCol) and not (p.NState in [PoreWater,LaDomPore,ReDomPore]))) then
        Begin
          CarrierState:=P.AllStates.GetState(TToxics(P).Carrier,StV,P.Layer);

          Mass := P.InitialCond * TToxics(P).WetToDry * 1e-3 * CarrierState;
         {ug/m2}    {(ug/kg)                 (unitless)  (kg/g)    (g/m2)}

         If (P.NState in [POC_G1..POC_G3]) then with P.AllStates.Diagenesis_Params^ do
              Mass := P.InitialCond * TToxics(P).WetToDry * 1e-3 * CarrierState * H2.Val;
             {ug/m2}    {(ug/kg)                 (unitless)  (kg/g)    (g/m3)        (m) }

          P.State:= Mass;
        End;

  { Toxicant in Pore Water must be converted to mg/L pw from ppb }
  If (p.SVType in [FirstToxTyp..LastToxTyp]) and (p.Layer>WaterCol) and (p.NState in [LaDomPore,ReDomPore]) then
        Begin
          CarrierState:=P.AllStates.GetState(TToxics(P).Carrier,StV,P.Layer);

          Mass := P.InitialCond * TToxics(P).WetToDry / 1e6 * CarrierState;
        {ug/L pw}  {(ug/kg)                  (unitless) (mg/kg)   (mg/L pw)}

          P.State:= Mass;
        End;

  {Fish, Sedimented Detritus, Periphyton, Macrophytes, Zoobenthos must undergo unit conversion}
  If P.AllStates.Convert_g_m2_to_mg_L(P.NState,P.SVType, P.Layer)
      Then with P.AllStates do
          P.State := P.InitialCond * Location.Locale.SurfArea / Volume_Last_Step;
            {g/m3}           {g/m2}                      {m2}           {m3}

  If (P.SVType in [FirstToxTyp..LastToxTyp]) then TToxics(P).PPB := P.Allstates.GetPPB(P.NState,P.SVType,P.Layer);  {Init PPB}

End;

  {---------------------------------------------------------------}

{ PROCEDURE NOT USED IN LINKED MODE }

Function TStates.ManningCoeff: Double;
Begin
  With Location.Locale do
     { mannings coefficient }
     If UseEnteredManning then ManningCoeff := EnteredManning
       else
         If (StreamType='concrete channel') then ManningCoeff := 0.020
           else If (StreamType='dredged channel') then ManningCoeff := 0.030
             else ManningCoeff := 0.040; {natural stream}
End;

  {---------------------------------------------------------------}

Procedure TStates.CalcHRadius(Averaged:Boolean);
{calculate the hydraulic radius & Channel Depth}
Var Runoff: Double;
    Vol: Double;
Begin With Sed_Data do
 Begin
   {UPDATE RUNOFF / DISCHARGE DATA}
   If Averaged then Runoff := MeanDischarge
               else Runoff := Location.Discharge[Vseg];

   Avg_Disch := Runoff / 86400;
   IF Avg_Disch<=0 then Avg_Disch :=  Location.Discharge_Using_QBase / 86400;
                          {m3/s}                {m3/d}                  {s/d}

   Channel_Depth := POWER(Avg_Disch * Manning   / (Sqrt(Slope)*Width) , 3/5);

   If Averaged then Vol := MeanVolume else Vol := Volume_Last_Step;
   Avg_Depth :=  Vol / Location.Locale.SurfArea;  {simpler depth formulation to match HSPF 2-5-2003}

   HRadius := Avg_Depth * Width / (2 * Avg_Depth + Width);
 End; {with}
End;

  {---------------------------------------------------------------}

Function TStates.CalculateTElapsed(Tox: T_SVType): Double;
{Calculates the number of elapsed days since first exposure to the given toxicant}
Var EpiSeg   : TStates;
Begin
  { the first exposure to the tox is assumed to be at the first toxicant presence within the simulation. }
    EpiSeg := Self;
    If VSeg=Hypolimnion then EpiSeg := EpiSegment;

    If EpiSeg.FirstExposure[Tox] = 0.0 then {first exposure not yet initialized}
       EpiSeg.FirstExposure[Tox] := TPresent; {JSC 9-4-2001  Removed steady-state assumption}

    CalculateTElapsed := TPresent - EpiSeg.FirstExposure[Tox] + 1;
End;

  {---------------------------------------------------------------}

Procedure TStates.CalculateSumPrey;
Var nsloop: AllVariables;
    PA    : TAnimal;
{Calculates the total prey available to an animal in the given timestep.  This is used
 for normalization of the ingestion function within TANIMAL.INGESTS }
Begin
  For nsloop:=FirstAnimal to LastAnimal do
    Begin
      PA := GetStatePointer(nsloop,StV,WaterCol);
      If PA<>nil then PA.CalculateSumPrey;
    End;
End;

  {---------------------------------------------------------------}

Procedure TStates.CopyMultiFishData;
{ Copies data stored within the Multi Fish Record all Multi Fish StateVariables }
{ Supports Multi Fish Interface}
Var SVLoop  : AllVariables;
    TypLoop : T_SVTYpe;
    PSV     : TStateVariable;
    AR      : ZooRecord;
    F1      : ^ZooRecord;
    TR      : TrophIntArray;
    AgeIndex: Integer;
    ICRec   : AgeDist;
    LoadRec : AgeDist;
    HasData : Boolean;
    MI      : MigrInputType;

Begin
  HasData:= True;
  For SVLoop:=Fish1 to Fish15 do
    For TypLoop := StV to LastOrgTxTyp do
      Begin
        PSV := GetStatePointer(SVLoop,TypLoop,WaterCol);
        If PSV<>nil then
          Begin
            AgeIndex := Ord(SVLoop) - Ord(Fish1) + 1;

            {Copy underlying animal data from Fish2 to all older fish}
            If (TypLoop=StV) then
              Begin
                If (SVLoop=Fish2) then AR := TAnimal(PSV).PAnimalData^;
                If (SVLoop>Fish2) then TAnimal(PSV).PAnimalData^ := AR;

                If SVLoop=Fish2 then HasData := PSV.PHasData^;
                If (SVLoop>Fish2) then PSV.PHasData^ := HasData;

                If (SVLoop=Fish2) then TR := TAnimal(PSV).PTrophInt^;
                If (SVLoop>Fish2) then TAnimal(PSV).PTrophInt^ := TR;

                If (SVLoop=Fish2) then MI := TAnimal(PSV).MigrInput;
                If (SVLoop>Fish2) then TAnimal(PSV).MigrInput := MI;

                If (SVLoop=Fish2) then {Copy Spawn Data back into Fish1}
                  Begin
                    F1 := @TAnimal(GetStatePointer(Fish1,StV,WaterCol)).PAnimalData^;
                    F1.AutoSpawn  := TAnimal(PSV).PAnimalData.AutoSpawn;
                    F1.SpawnDate1 := TAnimal(PSV).PAnimalData.SpawnDate1;
                    F1.SpawnDate2 := TAnimal(PSV).PAnimalData.SpawnDate2;
                    F1.SpawnDate3 := TAnimal(PSV).PAnimalData.SpawnDate3;
                    F1.XSpawnDate := TAnimal(PSV).PAnimalData.XSpawnDate;
                    F1.UnlimitedSpawning := TAnimal(PSV).PAnimalData.UnlimitedSpawning;
                    F1.SpawnLimit := TAnimal(PSV).PAnimalData.SpawnLimit;
                  End;

                {Copy lipidfrac, mean weight and mortality data}
                TAnimal(PSV).PAnimalData.FishFracLipid := PMultiRec.PLipidFrac.Vals[AgeIndex];
                TAnimal(PSV).PAnimalData.KMort         := PMultiRec.PMortCoeff.Vals[AgeIndex];
                TAnimal(PSV).PAnimalData.MeanWeight    := PMultiRec.PMeanWeight.Vals[AgeIndex];

                {Copy InitCond Data}
                ICRec:=PMultiRec.InitCond
              End
                else {typloop not StV} ICRec:=PMultiRec.ChemIC[TypLoop];

            PSV.InitialCond := ICRec.Vals[AgeIndex];

            {Copy Loadings Data}
            With PSV.LoadsRec do
              Begin
                UseConstant := True;
                NoUserLoad  := False;
                If TypLoop=StV then LoadRec:=PMultiRec.Loadings
                               else LoadRec:=PMultiRec.ChemLoad[TypLoop];
                ConstLoad   := LoadRec.Vals[AgeIndex];
              End;
          End;
      End; {SVLoop and TypLoop}

End;

  {---------------------------------------------------------------}

Procedure TStates.CopySuspDetrData;
 { Copies Data stored within DissRefrDetr into the Initial Conditions of the two or four detrital
   compartments: supports SuspDetr input Interface }

Var PR       : TRemineralize;
    PD       : TDissRefrDetr;
    Loop     : StateVariables;
    SVLoop   : T_SVType;
    MultFrac : Double;

    {----------------------------------------------------------}

    Procedure CalcMultFrac(NS: StateVariables; S_Type: T_SVType);
    {Gets the correct fraction to multiply the general loadings
     data by to fit the appropriate compartment / data type}

    Var  ConvertFrac, RefrFrac, PartFrac : Double;
         RefrPercent, PartPercent : Double;  {User Input Percentage of Refractory or Particulate}
       Begin
         MultFrac    := 1.0;
         ConvertFrac := 1.0;
         If S_Type>StV then exit;  {Tox data is ppb, so it stays const. for four compartments regardless of breakdown}

         RefrPercent := PD.InputRecord.Percent_RefrIC;
         PartPercent := PD.InputRecord.Percent_PartIC;

         If ns in [DissRefrDetr..DissLabDetr]
               then PartFrac := 1 - (PartPercent /100)
               else PartFrac := (PartPercent /100);

         If (ns in [DissRefrDetr,SuspRefrDetr])
              then RefrFrac := (RefrPercent /100)
              else RefrFrac := 1 - (RefrPercent /100);

         If (S_Type = StV) {don't convert toxicant init conds}
           then Case PD.InputRecord.DataType of
                  CBOD: ConvertFrac      := Location.Conv_CBOD5_to_OM(RefrPercent);
                  Org_Carb: ConvertFrac := Detr_OM_2_OC;
                end; {Case}
         MultFrac := ConvertFrac * RefrFrac * PartFrac;
       End;

    {----------------------------------------------------------}

Begin
  PD := GetStatePointer(DissRefrDetr,StV,WaterCol);
  For SVLoop := StV to LastOrgTxTyp do  {Loop through state variable type and then each associated toxicant type}
   If SVLoop <> Porewaters then
    If (SVLoop=StV) or ((GetStatePointer(AssocToxSV(SVLoop),StV,WaterCol) <> nil)) then
     For Loop := DissRefrDetr to SuspLabDetr do    {Loop through each detritus record in water col.}
       Begin
         CalcMultFrac(Loop,SVLoop);  {Determine MultFrac for Initial condition}
         PR:=GetStatePointer(Loop,SVLoop,WaterCol);
         If PR<>nil then
           With PD.InputRecord do
             Case SVLoop of
                  StV    : Begin
                             PR.InitialCond := InitCond * MultFrac;
                             PR.LoadsRec.Loadings.Hourly := Load.Loadings.Hourly;
                           End;
                  FirstToxTyp..LastToxTyp: PR.InitialCond := ToxInitCond[SVLoop];
             End; {case}     {Split of the initial condition}
       End; {For Loop}
End; {Procedure TStates.CopySuspDetrData}


Procedure TStates.SetStateToInitConds(INIT_RISK_CONC: Boolean);
      {----------------------------------------------------------------------------------}
      (* Table is copied into Sed_Data at the start of the study run}
        Begin
         With Sed_Data do
          Begin
            Mett[1]:= 0.0 ;  MetV[1]:= 1.792;
            Mett[2]:= 5.0 ;  MetV[2]:= 1.519;
            Mett[3]:= 10.0;  MetV[3]:= 1.308;
            Mett[4]:= 15.0;  MetV[4]:= 1.141;
            Mett[5]:= 20.0;  MetV[5]:= 1.007;
            Mett[6]:= 25.0;  MetV[6]:= 0.897;
            Mett[7]:= 30.0;  MetV[7]:= 0.804;
            Mett[8]:= 35.0;  MetV[8]:= 0.727;
            Mett[9]:= 40.0;  MetV[9]:= 0.661;
            Mett[10]:= 45.0; MetV[10]:= 0.605;
            Mett[11]:= 50.0; MetV[11]:= 0.556;
            Mett[12]:= 55.0; MetV[12]:= 0.513;
            Mett[13]:= 60.0; MetV[13]:= 0.477;
            Mett[14]:= 65.0; MetV[14]:= 0.444;
            Mett[15]:= 70.0; MetV[15]:= 0.413;
            Mett[16]:= 75.0; MetV[16]:= 0.390;
            Mett[17]:= 80.0; MetV[17]:= 0.367;
            Mett[18]:= 85.0; MetV[18]:= 0.347;
            Mett[19]:= 90.0; MetV[19]:= 0.317;
            Mett[20]:= 95.0; MetV[20]:= 0.311;
            Mett[21]:=100.0; MetV[21]:= 0.296;
          End;
        End; {SetMet} *)

        Procedure Initialize_Sediment_Data;

        Const  PorSand : double = 0.4;
               PorSilt : double = 0.5;
               PorClay : double = 0.5; {Pettijohn, 1957, Sedimentary Rocks}

               Rho_Sand : double = 2600;  { density of particles [kg/m3] }
               Rho_Clay : double = 2400;
               Rho_Silt : double = 2400;  {Also defined in Sediment.Inc}

        Var    Sand_SV, Silt_SV, Clay_SV: TSandSiltClay;
               SedVol: Double; { vol of sedimept in bed, excluding water, m3}
               BedVol: Double; { volume of bed, including water and sediment, m3 }
               BedSand, BedSilt, BedClay: Double; { fraction of Sediment type in bed sediments }

        Begin
          With Sed_Data do
             Begin
               { SetMet;  Fall velocities are now a model input.}

               BedDepthWarning    :=False;   {these variables used to avoid incessant warnings}
               FloodPlainWarning  :=False;

               With Location.Locale do
                 begin
                   Width   := SurfArea / (SiteLength * 1000);
                    {m}       {sq.m}        {km}   {m/km}
                   Slope   := Channel_Slope;
                   {m/m}
                   if (Location.SiteType <> Stream) or (Slope <= 0) then Slope := 0.00001; {site is not a stream}

                   yflood  := Max_Chan_Depth;
                   {m}            {m}
                   if (Location.SiteType <> Stream) or (yflood <= 0) then yflood:=zmax+1; {site is not a stream}

                   { mannings coefficient }
                   If UseEnteredManning then Manning := EnteredManning
                     else
                       If (StreamType='concrete channel') then Manning := 0.020
                         else If (StreamType='dredged channel') then Manning := 0.030
                           else Manning := 0.040; {natural stream}

                   Max_Depth := SedDepth + StaticZMean;
                   CLength := SiteLength * 1000;
                     {m}       {km}       {m/km}
                 end; {With}

               AWidth := Width;
                 {m}     {m}

               If GetState(Sand,StV,WaterCol) = -1 then exit;  {no sand/silt/clay in model}

               Sand_SV := GetStatePointer(Sand,StV,WaterCol);
               Silt_SV := GetStatePointer(Silt,StV,WaterCol);
               Clay_SV := GetStatePointer(Clay,StV,WaterCol);

               BedSand := Sand_SV.FracInBed;
               BedSilt := Silt_SV.FracInBed;
               BedClay := Clay_SV.FracInBed;
               Bed_Porosity := BedSand * PorSand + BedSilt * PorSilt + BedClay * PorClay;
                 {frac}        {frac}     {frac}    {frac}   {frac}     {frac}   {frac}

               {-------------------------------------------------}
               {  CALCULATE INITIAL SEDIMENT VOLUMES AND MASSES  }
               {-------------------------------------------------}

              With Location.Locale do
               sedvol := SedDepth*CLength*awidth*(1-bed_porosity);  {vol of sediment in bed, excluding water}
                 {m3}     {m}       {m}    {m}         {frac}

               bedvol := sedvol/(1-bed_porosity);
                {m3}      {m3}        {frac}
               BedDepth := bedvol/(Clength*awidth);
                {m}         {seddepth}

               mclay:=sedvol*Rho_Clay*BedClay;
               msilt:=sedvol*Rho_Silt*BedSilt;
               msand:=sedvol*Rho_Sand*BedSand;
                {kg}   {m3}  {kg/m3}   {frac}

      {         if (BedDepth>=Max_Depth) then
                 Begin
                    MessageDlg('Warning!  Bed sediment depth exceeds maximum allowable value'
                      ,mterror,[mbOK],0);
                      BedDepth
                      Warning:=True;
                 End; }

          End; {with}
        End; {Initialize_Sediment_Data}

      {----------------------------------------------------------------------------------}
       Procedure Check_Nutrient_IC;      { if using TN or TP for init cond }
       Var PNO3   : TNO3Obj;
           PPO4   : TPO4Obj;
           PNH4   : TNH4Obj;
           ThisVar: TStateVariable;
           PPl    : TPlant;
           Nut2Org  : Double;
           CNutrient : Double;
           NutrLoop,NSLoop : AllVariables;
       Begin
        PNO3 := GetStatePointer(Nitrate,StV,WaterCol);
        PPO4 := GetStatePointer(Phosphate,StV,WaterCol);
        For NutrLoop := Nitrate to Phosphate do
         Begin
           If ((NutrLoop=Nitrate)   and (PNO3.TN_IC)) or
              ((NutrLoop=Phosphate) and (PPO4.TP_IC)) then
             Begin
               If NutrLoop=Nitrate then ThisVar := TStateVariable(PNO3)
                                   else ThisVar := TStateVariable(PPO4);
               CNutrient := ThisVar.State;  {Total Nutrient in mg/L}

               For nsloop := DissRefrDetr to SuspLabDetr do
                If GetState(nsLoop,StV,WaterCol)>0 then
                  Begin
                   With Location.Remin do
                    If nutrLoop = Nitrate
                     then
                      Case nsloop of
                        SuspRefrDetr:           Nut2Org := N2Org_Refr;
                        SuspLabDetr:            Nut2Org := N2OrgLab;
                        DissRefrDetr:           Nut2Org := N2OrgDissRefr;
                        Else {DissLabDetr:}     Nut2Org := N2OrgDissLab;
                        End  {Case}
                     else
                      Case nsloop of
                        SuspRefrDetr:           Nut2Org := P2Org_Refr;
                        SuspLabDetr :           Nut2Org := P2OrgLab;
                        DissRefrDetr:           Nut2Org := P2OrgDissRefr;
                        Else {DissLabDetr:}     Nut2Org := P2OrgDissLab;
                        End; {Case}

                    CNutrient := CNutrient - GetState(nsLoop,StV,WaterCol)*Nut2Org;
                     {mg/L}       {mg/L}            {mg/L}                 {N2Org}
                  End;

               For nsloop := FirstPlant to LastPlant do
                 Begin
                  PPL := GetStatePointer(nsLoop,StV,WaterCol);
                  If PPL<>nil then
                   If PPL.IsPhytoplankton then
                     Begin
                       If nutrloop=nitrate then Nut2Org := PPL.PAlgalRec.N2OrgInit
                                           else Nut2Org := PPL.PAlgalRec.P2OrgInit;
                       CNutrient := CNutrient - PPl.State * Nut2Org;
                        {mg/L}      {mg/L}          {mg/L}   {N2Org}
                     End;
                 End;

               If CNutrient<0 then CNutrient :=0;
               ThisVar.State := CNutrient;

               If NutrLoop=Nitrate then
                 Begin {No ammonia if nitrogen initial condition is input as Total N}
                   PNH4 := GetStatePointer(Ammonia,StV,WaterCol);
                   PNH4.State := 0;
                 End;
             End;
         End;
       End;
      {----------------------------------------------------------------------------------}
       Procedure StateToIC(P : TStateVariable);
       Var TLP: T_SVType;
           TP: TPlant;
           j: Integer;
       Begin
         P.State := P.InitialCond;

         If P.SVType=STV then
           Begin
             IF INIT_RISK_CONC then
               {Using ToxicityRecord Initialize Organisms with
               the appropriate RISKCONC, LCINFINITE, and K2}
               if p.IsPlantOrAnimal then
                  TOrganism(p).CalcRiskConc(true);

             {Initialize TAnimal Variables}
             if p.IsAnimal then
               Begin
                 TAnimal(p).Spawned:=False;
                 TAnimal(p).SpawnTimes:=0;
                 TAnimal(p).PromSmFish:=0;
                 TAnimal(p).EmergeInsect:=0;
                 TAnimal(p).Recruit:=0;
                 fillchar(TAnimal(p).AnadromousData,SizeOf(TAnimal(p).AnadromousData),0);

                 If (TAnimal(p).PAnimalData.Animal_Type = 'Fish') or
                    (TAnimal(p).PAnimalData.Animal_Type = 'Pelagic Invert.') then
                     TAnimal(p).PAnimalData.AveDrift := 0;
                 If INIT_RISK_CONC then TAnimal(P).Assign_Anim_Tox;
               End;

            {Initialize BCF calculation}
            IF INIT_RISK_CONC then
              If P.Layer < SedLayer1 then
                For TLP := FirstOrgTxTyp to LastOrgTxTyp do
                  If (GetStatePointer(AssocToxSV(TLP),StV,WaterCol)<>nil) then
                    If p.NState in [FirstDetr..LastDetr,FirstBiota..LastBiota] then
                      TOrganism(p).BCF(0,TLP);

            if P.IsPlant then
              Begin
                TPlant(P).SinkToHypo:=0;
                TPlant(P).SloughEvent := False;
                TPlant(P).NutrLim_Step := 1;
              End;

            if P.NState= Volume then
                   begin
                      TVolume(P).Discharg := 0;
                      TVolume(P).Inflow   := 0;
                      TVolume(P).LastTimeTA := 0;
                      TVolume(P).LastCalcTA := 0;
                      Volume_Last_Step := P.InitialCond;
{                     Thick_Last_Step := P.Location.Locale.ICZMean; }
                      With Location do
                        VolFrac_Last_Step := TVolume(P).VolFrac(MaxEpiThick, Locale.ZMax, P_Shape);
                      If EstuarySegment then VolFrac_Last_Step := TVolume(P).FracUpper;
                   end;

            if (P.NState=PoreWater) and (P.SVType=StV) then
              PWVol_Last_Step[P.Layer] := P.InitialCond;

           End; {Non-Chemical State Variables}

         {initialize internal nutrients in ug/L}
            if p.SVType in [NIntrnl,PIntrnl] then
              Begin
                TP := GetStatePointer(P.NState,StV,WaterCol);  // associated plant
                If P.SVType = NIntrnl
                   then P.InitialCond := TP.InitialCond * TP.PAlgalRec.N2OrgInit * 1000
                   else P.InitialCond := TP.InitialCond * TP.PAlgalRec.P2OrgInit * 1000;
                          {ug N/L}          {mg OM/L}                  {gN/gOM}   {ug/mg}
                P.State := P.InitialCond;
              End;

         {Initialize Toxics}
         If (p.SVType in [FirstOrgTxTyp..LastOrgTxTyp]) or
            (p.NState in [FirstOrgTox..LastOrgTox]) then
             Begin
               TToxics(P).PPB:= 0;
               if (P.NState in [FirstAnimal..LastAnimal]) and (P.SVType in [FirstOrgTxTyp..LastOrgTxTyp]) then
                  TToxics(P).InitialLipid;
             End;

         With P do
           Begin
             {init deriv info}
             yHold:=0; yOrig:=0;
             For j:= 1 to 6 do
               StepRes[j] := 0;
           End;

        For j:=1 to 6 do
          Begin
            p.WashoutStep[j] := 0;
          End;

        Convert_Initial_Condition_Units(P);
        {Sedimented Detritus, Mercury Init Conditions, Periphyton & Macrophytes, and Zoobenthos must
         have their initial conditions converted, this call must come after CalculateWetToDry above}

        If P.RateColl<>nil then P.RateColl.Destroy;
        P.RateColl := nil;
        P.RateIndex := -1;

       End;
      {----------------------------------------------------------------------------------}
Var i,SedIndex  : Integer;
    pv          : TVolume;
    ToxLoop     : T_SVTYpe;
    PP          : TPlant;
    LightTest   : Integer;
    MaxDailyLight: Double;
    PL          : TLight;
    NS          : AllVariables;

Begin {TStates.SetStateToInitConds}
   If OOSStack<>nil then OOSStack.FreeAll;  OOSStack := nil;

   PV:=(GetStatePointer(Volume,StV,WaterCol));
   If (Location.SiteType<>Stream) and (PV.Calc_Method=Manning)
      Then PV.Calc_Method := KeepConst;
   Volume_Last_Step := PV.InitialCond;

   For i:=0 to count-1 do
         StatetoIC(at(i));

   Check_Nutrient_IC;   {must be called after initial conditions are set}

    {initialize time variables}
     For ToxLoop:=FirstToxTyp to LastToxTyp do
       FirstExposure[ToxLoop] := 0;
     {It's possible that in a long-term simulation with multiple toxic peaks,
      the FIRSTEXP variables should be reset to zero elsewhere in the model run}

     LastCalcEstVel:=0; LastTimeEstVel:=0;  {velocity calc is not up-to-date}
     LastWellMixedTime := -99;
     LastWellMixedCalc := True;

     YearNum_PrevStep :=1;
     TimeLastGullConc := -99;
     TimeLastInorgSedAvg[True] := -99;
     TimeLastInorgSedAvg[False] := -99;

{     LastCascLoad     := -99; }
     MigrateDate      := -99;
     AnadromousDate   := -99;
     SOD := -99;
{     IncomingCascLoads := False; } {Assumed to have no incoming casc loads until otherwise proven}

     If Not LinkedMode
       then Begin
              Stratified := False;  {Set in SetupStratification for Linked Mode}
              VSeg:=Epilimnion;
            End;

     Water_Was_Zero := False;
     Anoxic     := False;

     VertDispersionCalcDate          :=-99;
     OldVertDispersionVal            :=-99;

     Initialize_Sediment_Data;

     If Not LinkedMode then
       Begin
         PRateInfo.FileInit[Epilimnion]  := False;   {Set in TLinkedStudies.Run for Linked Mode}
         PRateInfo.FileInit[Hypolimnion] := False;
       End;

     Location.Morph.InflowH2O[Epilimnion]:=0;
     Location.Morph.InflowH2O[Hypolimnion]:=0;

     DerivStep := 0;

   Last_Datapoint_Written[Epilimnion]   := -99;
   Last_Results_Written[Epilimnion]     := -99;
   Last_Datapoint_Written[Hypolimnion]  := -99;
   Last_Results_Written[Hypolimnion]    := -99;

   {Initialize Sed-Sub-Model}
   SetInitHardPan;
   UpdateSedData;
   For SedIndex := 1 to SedLayers do
     Begin
       SedData[SedIndex].VolumeLost  := 0;
       SedData[SedIndex].PoreSqueeze := 0;
     End;
   InitL2Dens := SedData[2].BedDensity;
   L1AimDens  := SedData[1].BedDensity;
   If InitL2Dens<Tiny then InitL2Dens := SedData[1].BedDensity;
   If SedLayers>0 then BaseTopDepth := - SedData[1].BedDepthIC;

   PO2Concs.Destroy;
   PO2Concs := TLoadings.Init(100,50);
   PSedConcs.Destroy;
   PSedConcs := TLoadings.Init(100,50);
   PLightVals.Destroy;
   PLightVals:= TLoadings.Init(50,50);

   PL := GetStatePointer(Light,StV,WaterCol);
   PL.CalculateLoad(SetupRec.FirstDay);  {Set DailyLight for First Day}
   MaxDailyLight := PL.DailyLight;
   For LightTest := Trunc(SetupRec.FirstDay)+1 to Trunc(SetupRec.FirstDay)+365 do
   {Get Maximum daily light for one year from simulation start point}
     Begin
       PL.CalculateLoad(LightTest);  {Set DailyLight for "LightTest" Day}
       If MaxDailyLight < PL.DailyLight
         then MaxDailyLight := PL.DailyLight;
     End;
   PL.CalculateLoad(SetupRec.FirstDay);

   For NS := FirstPlant to LastPlant do
     Begin
       PP := GetStatePointer(NS,StV,WaterCol);
       If PP<>nil then with PP.PAlgalRec^ do
           If EnteredLightSat >= MaxDailyLight
              then PP.ZOpt := 0.1  {towards top of water column due to low light conditions}
              else PP.ZOpt := ln(EnteredLightSat/ MaxDailyLight)/-Extinct(PP.IsPeriphyton,True,True,False,False);
     End;                           {Ly/d}            {Ly/d}       {1/m}

   PercentEmbedded := Location.Locale.BasePercentEmbed;
   LastPctEmbedCalc := SetupRec.FirstDay;

End; {TStates.SetStateToInitConds}

{----------------------------------------------------------------------------------}

Procedure TStates.SetMemLocRec;

Var SVLoop: StateVariables;
    TypeLoop: T_SvType;
    LayerLoop: T_SvLayer;
    i: Integer;
    p: Pointer;
    PSV: TStateVariable;

Begin
  PSV:=TStateVariable.Init(NullStateVar,StV,WaterCol,'',Self,0,true);
    For TypeLoop  := StV to PIntrnl do
     For SVLoop    := FirstState to LastState do
      For LayerLoop := WaterCol to SedLayer10 do
      Begin
        PSV.nstate := SVLoop;
        PSV.SvType := TypeLoop;
        PSV.Layer  := LayerLoop;

        {Set Indexes}
        If Not Search(PSV,i) then i:=-1;
        MemLocRec.Indx[SVLoop,TypeLoop,LayerLoop]:=i;

        {Set Pointers}
        p:=nil;
        if i>=0 then p:=At(i);
        MemLocRec.Ptr[SVLoop,TypeLoop,LayerLoop]:=p;
      End; {SvLoop}

  PSV.Destroy;

End; {SetMemLocRec}


Procedure TStates.Zero_Utility_Variables;
{This Procedure is executed at the beginning of the model run and each
 step of the model run along the way.}
Begin
End;


Procedure TStates.SetMeanDischarge(TimeIndex: Double);
Var MD, MV : Double;
    PV     : TVolume;
    AverageDischargeLoad, AverageInflowLoad: Double;

    {------------------------------------------------------}
    Procedure AverageVolumeLoads;
    Var DateIndex: Double;
        N, Sum_Dl, Sum_IL: Double;
    Begin
      Sum_DL:=0;
      Sum_IL:=0;
      N:=0;
      DateIndex:=TimeIndex-1;
        Repeat
           DateIndex:=DateIndex+1;
           N:=N+1;
           PV.CalculateLoad(DateIndex);
           Sum_DL:= Sum_DL + PV.DischargeLoad;
           Sum_IL:= Sum_IL + PV.InflowLoad;
        Until ((DateIndex-365)>=TimeIndex) or (DateIndex>=SetupRec.LastDay);

      AverageDischargeLoad := Sum_DL / N;
      AverageInflowLoad    := Sum_IL / N;
      PV.CalculateLoad(TimeIndex); {reset TVolume values}
    End;
    {------------------------------------------------------}
    Function CalcKnownValueMD: Double;
    { Calculates the discharge for every time step then averages over a year }
    { Given that KnownValLoad - State = Inflow - Discharge - Evap
      and that for each day, State should = KnownValLoad(T-1) then
      Discharge = Inflow - KnownValLoad + KnownValLoad(T-1) - Evap }
    Var DateIndex: Double;
        N, KnownVal_Tminus1, Sum_Disch, SumVol  : Double;
    Begin
      Sum_Disch:=0;  SumVol := 0;
      KnownVal_Tminus1:=PV.InitialCond;
      N:=0;

      DateIndex:=TimeIndex-1;
        Repeat
           DateIndex:=DateIndex+1;
           N:=N+1;
           PV.CalculateLoad(DateIndex);
           Sum_Disch:= Sum_Disch + PV.InflowLoad   - PV.KnownValueLoad
                                 + KnownVal_Tminus1 - PV.Evaporation;   //need to handle dynamic evaporation properly
           KnownVal_Tminus1 := PV.KnownValueLoad;
           SumVol := SumVol + PV.KnownValueLoad;
        Until ((DateIndex-365)>=TimeIndex) or (DateIndex>=SetupRec.LastDay);

      CalcKnownValueMD := Sum_Disch / N;
      MV := SumVol / N;
      If Result<0 then CalcKnownValueMD := 0;
      PV.CalculateLoad(TimeIndex); {reset TVolume values}
    End;
    {------------------------------------------------------}
    Procedure CalcEstMeanVars;
    {Calculate MeanDischarge and MeanEstVel for Estuaries}
    Var N, DateIndex, SumEstVel, SumDisch, TTPres: Double;
        TS: TSalinity;
    Begin
      N:=0;
      TTpres := TPresent;
      TS := GetStatePointer(Salinity,StV,WaterCol);
      SumEstVel := 0;
      SumDisch := 0;
      DateIndex:=TimeIndex-1;

        Repeat
          DateIndex:=DateIndex+1;
          N:=N+1;
          TPresent := DateIndex;
          PV.CalculateLoad(DateIndex);
          TS.CalculateLoad(DateIndex);

          Location.Discharge[Epilimnion] := PV.UpperOutflow;
          SumEstVel := SumEstVel + Velocity(0,0,False);
          SumDisch  := SumDisch  + Location.Discharge[Epilimnion];
        Until ((DateIndex-365)>=TimeIndex) or (DateIndex>=SetupRec.LastDay);

      MeanDischarge := SumDisch / N;
      MeanEstVel   := SumEstVel / N;

      TPresent := TTPres;
      PV.CalculateLoad(TimeIndex); {reset TVolume values}
      TS.CalculateLoad(TimeIndex);
      Location.Discharge[Epilimnion] := PV.UpperOutflow;

    End;
    {------------------------------------------------------}
    Function CalcDynamicMV: Double;
    { Calculates the volume for every time step then averages over a year }

    Var DateIndex: Double;
        N, DynamVol, SumVol : Double;
    Begin
      SumVol := 0;
      DynamVol:=PV.State;
      N:=0;

      DateIndex:=TimeIndex-1;
        Repeat
           DateIndex:=DateIndex+1;
           N:=N+1;
           PV.CalculateLoad(DateIndex);
           DynamVol := DynamVol + PV.InflowLoad - PV.DischargeLoad - PV.Evaporation;  //need to handle dynamic evaporation properly
           SumVol := SumVol + DynamVol;
        Until ((DateIndex-365)>=TimeIndex) or (DateIndex>=SetupRec.LastDay);

      CalcDynamicMV := SumVol / N;
      If Result<0 then CalcDynamicMV := 0;
      PV.CalculateLoad(TimeIndex); {reset TVolume values}
    End;
    {------------------------------------------------------}

Var Temp: Double;

begin
  MD:=0; MV := 0;
  MeanDischarge:=0;
  MeanVolume := 0;
  MeanEstVel := 0;
  PV:=GetStatePointer(Volume,StV,WaterCol);

  If EstuarySegment then  {5-30-2008}
    Begin
      MeanVolume := PV.InitialCond;    {for entire system}
      CalcEstMeanVars;
      Exit;
    End;

  If (PV.Calc_Method in [Dynam,KeepConst,Manning]) then AverageVolumeLoads;

  {Meandischarge is set, depending on the volume calculation method}
    Case PV.Calc_Method of
       Manning    : Begin
                      MD := AverageDischargeLoad;
                      Temp := PV.Discharg;  {calculate manning's volume based on mean discharge}
                      PV.Discharg := MD;
                      MV := PV.Manning_Volume;
                      PV.Discharg := Temp;
                    End;
       Dynam      : Begin
                      MD := AverageDischargeLoad;
                      MV := CalcDynamicMV;
                    End;
       KeepConst  : begin
                      MD := AverageInflowLoad - PV.Evaporation; {Currently Assuming Evap is constant over the year}  //need to handle dynamic evaporation properly
                      if MD < 0 then MD := 0;
                      MV := PV.InitialCond;
                    end;
       KnownVal   : MD := CalcKnownValueMD; {Also Assuming Evap is constant over the year, this can be changed}
                       {MV Calculated in CalcKnownValueMD as well}
       End; {Case}

   If Stratified and (Not LinkedMode)
     Then With Location.Morph do
       Begin
         Case PV.StratOutflow of
           FTBoth: MeanDischarge := MD * (SegVol / Volume_Last_Step); {Discharge is split up between Epi & Hyp segments weighted by volume}
           FTEpi: If VSeg=Epilimnion then MeanDischarge := MD
                                     else MeanDischarge := 0;
           FTHyp: If VSeg=Hypolimnion then MeanDischarge := MD
                                      else MeanDischarge := 0;

           End {Case}
       End
     Else MeanDischarge := MD;

   If (Stratified) and (Not LinkedMode)
     Then With Location.Morph do
       Begin   {Volume is split up between Epi & Hyp segments }
         MeanVolume := MV * (SegVol / Volume_Last_Step);
       End
     Else MeanVolume := MV;

    IF MeanVolume = 0 then
      Begin
        CalcDynamicMV;
      End;

end;

{------------------------------------------------------------------------}

Procedure TStates.CALCPPB; {was fugacity}
Var  ToxSV         : AllVariables;
     ToxTyp       : T_SVType;

Const
   UnitVol : Double = 1.0;  {cu m}

   Procedure KineticPPB(P : TStateVariable);
   Begin
     If ((P.SVType=ToxTyp) or (P.NState=ToxSV)) then
         TToxics(P).PPB := GetPPB(P.NState,P.SVType,P.Layer)/TToxics(P).WetToDry;
         { wet-weight concentration }
     If (P.SVType=ToxTyp) and (P.NState in [FirstDetr..LastDetr]) then
         TToxics(P).PPB := GetPPB(P.NState,P.SVType,P.Layer);
         { dry-weight concentration for detritus }
   End;
   {---------------------------------------}
   Procedure CalcKineticPPB;
   Var  i: Integer;
   Begin
      ToxSV:=AssocToxSV(ToxTyp);

      For i:=0 to Count-1 do
          KineticPPB(At(i));
   End;
   {---------------------------------------}
Var ToxLoop: T_SVType;
Begin {CalcPPB}
  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
    If GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol)<>nil then
      Begin
        ToxTyp := ToxLoop;
        CalcKineticPPB;
      End;
End;

Function TStateVariable.NutrToOrg(S: AllVariables): Double;
Var Nitr: Boolean;
    PA: TAnimal;
    PP: TPlant;
Begin
  Nitr := (S in [Nitrate, Ammonia]);

  With Location.Remin do
   Case NState of
    SedmRefrDetr,SuspRefrDetr:  If Nitr then NutrToOrg := N2Org_Refr
                                       else NutrToOrg := P2Org_Refr;
    SedmLabDetr,SuspLabDetr: If Nitr then NutrToOrg := N2OrgLab
                                       else NutrToOrg := P2OrgLab;
    DissRefrDetr:              If Nitr then NutrToOrg := N2OrgDissRefr
                                       else NutrToOrg := P2OrgDissRefr;
    DissLabDetr:               If Nitr then NutrToOrg := N2OrgDissLab
                                       else NutrToOrg := P2OrgDissLab;

    FirstAnimal..LastAnimal: Begin
                               PA := TAnimal(Self);
                               If Nitr then NutrToOrg := PA.PAnimalData.N2Org
                                       else NutrToOrg := PA.PAnimalData.P2Org;
                             End;
    else {plant}             Begin
                               PP := TPlant(Self);
                               If Nitr then NutrToOrg := PP.N_2_Org
                                       else NutrToOrg := PP.P_2_Org;
                             End;
    end; {Case}
End;

{-------------------------------------------------------------------------------------------------------}

Function TStatevariable.WetToDry: Double;
Begin
  With Location.Remin do
   Case NState of
    SedmRefrDetr: WetToDry :=  Wet2DrySRefr;
    SedmLabDetr: WetToDry :=  Wet2DrySLab;
    SuspRefrDetr:  WetToDry :=  Wet2DryPRefr;
    SuspLabDetr: WetToDry :=  Wet2DryPLab;
    DissRefrDetr,DissLabDetr: WetToDry := 1.0;
    ReDomPore, LaDOMPore, PoreWater : WetToDry := 1.0;
    BuriedRefrDetr,BuriedLabileDetr: WetToDry := 1.0;
    Else Raise EAQUATOXError.Create('TStateVariable Wet To Dry called for irrelevant variable.');
   End; {case}
End;

{-------------------------------------------------------------------------------------------------------}

Function TStateVariable.GetPPB(S: AllVariables;  T: T_SVType; L: T_SVLayer): double;
Begin
  GetPPB := AllStates.GetPPB(S,T,L);
End;

{-------------------------------------------------------------------------------------------------------}


Function TStates.InorgSedConc(WeightedAvg: Boolean): Double;  {Conc Inorganic sediments in mg/L}
  {Modified to allow for weighted average in the event of linked-mode well-mixed stratification, 2-27-08}

Var InorgSed, SedState: Double;
    DetrLoop, AlgLoop, SedLoop: AllVariables;
    PTSS: TSandSiltClay;
    PPhyto: TPlant;
    OtherSeg: TStates;
    ThisSegThick, OtherSegThick: Double;

    Function GetExtState(S: AllVariables;  T: T_SVType; L: T_SVLayer) : double;
        {Performs weighted avg. by seg. thick if required 2-27-08}
    Begin
       if Not WeightedAvg
         then Result := GetState(S,T,L)
         else
           Begin
             Result := (OtherSeg.GetState(S,T,L)*OtherSegThick + GetState(S,T,L)*ThisSegThick)
                       / (ThisSegThick + OtherSegThick);
           End;

    End;

Begin
   If WeightedAvg then with Location.Locale do
     Begin
       ThisSegThick := DynamicZMean;                      //10-14-2010 removed ZMAX from this calculation
       If VSeg = Epilimnion then OtherSeg := HypoSegment
                            else OtherSeg := EpiSegment;
       OtherSegThick := OtherSeg.DynamicZMean;
     End;

   InorgSed := 0;

   If GetStatePointer(Sand,StV,WaterCol) <> nil then
     For SedLoop:=Sand to Clay do  {If there is sand..clay in a simulation there is no TSS, nor cohesives}
       begin
         SedState:=GetExtState(SedLoop,Stv,WaterCol);
         If SedState>-1 then InorgSed := InorgSed + SedState;
       end;

   If GetStatePointer(Cohesives,StV,WaterCol) <> nil then
     For SedLoop:=Cohesives to NonCohesives do   {If there are cohesives/noncohesives, in a simulation there is not TSS nor sand..clay}
       begin
         SedState:=GetExtState(SedLoop,Stv,WaterCol);
         If SedState>-1 then InorgSed := InorgSed + SedState;
       end;

   PTSS := GetStatepointer(TSS,StV,WaterCol);
   If PTSS <> nil then  {If there is TSS in a simulation there are no cohesives nor sand..clay}
     Begin
       InOrgSed := GetExtState(TSS,StV,WaterCol);

       If PTSS.TSS_Solids then {TSS includes algae so, to avoid double-counting, this algorithm subtracts the phytoplankton biomass
                                 from the TSS ("inorganic sediment") before computing the extinction coeff.}
        For AlgLoop := FirstAlgae to LastAlgae do
         Begin
           PPhyto := GetStatepointer(AlgLoop,StV,WaterCol);
           If PPhyto <> nil then
             If PPhyto.IsPhytoplankton then {1/7/2005}
               InOrgSed := InOrgSed - GetExtState(AlgLoop,StV,WaterCol);
         End;

       If PTSS.TSS_Solids then
         For DetrLoop := SuspRefrDetr to SuspLabDetr do
          If GetExtState(DetrLoop,StV,WaterCol)>0 then
            InOrgSed := InorgSed - GetExtState(DetrLoop,StV,WaterCol);

        If InorgSed<0 then InorgSed := 0;  {10-18-07 bullet proofing}
     End;

  InorgSedConc := InOrgSed;
End;

{-------------------------------------------------------------------------------------------------------}

Function  TStates.InorgSed60Day(MustHave60: Boolean): Double;  {60 day running average of inorganic seds, mg/L}
{3/5/2008, if MustHave60=TRUE then returns zero if the data-record (simulation time) is less than 60 days }
Var OverTime     : Boolean;
    PSS: TSVConc;
    i: Integer;
    RunningSum, LastInorg, LastTime: Double;

Begin
  If Trunc(TimeLastInorgSedAvg[MustHave60]) = Trunc(TPresent) then
    Begin  {optimization, only calculate once per day}
      Result := LastInorgSedAvg[MustHave60];
      Exit;
    End;

   LastInorg :=  InorgSedConc(False);
   If MustHave60 then Result := 0
                 else Result := LastInorg;  {Used if Count of historical data =0}
   LastTime := TPresent;

   OverTime := False;
   i := 0;
   RunningSum := 0;

   With PSedConcs do
    If Count>0 then
      Begin
        Repeat
          PSS := At(i);
          If (TPresent - PSS.Time - 0.001) >  60  Then OverTime := True;
             {  days               (min) }    {d}

          RunningSum := RunningSum + ((PSS.SVConc + LastInorg) / 2) * (LastTime - PSS.Time);
            {mg/L d}                      {mg/L}    {mg/L}               {d}         {d}
          {trapezoidal integration}

          LastTime  := PSS.Time;
          LastInorg := PSS.SVConc;
          inc(i);

        Until (i=count) or OverTime;

        If TPresent-LastTime > Tiny then  {must have time-record to process}
           If (TPresent-LastTime < 60) and MustHave60
             then Result := 0  {not 60 days of data}
             else Result := RunningSum / (TPresent - LastTime);
                              {mg/L d}     {      d            }

      End;{Count>0}

  TimeLastInorgSedAvg[MustHave60] := TPresent;
  LastInorgSedAvg[MustHave60] := Result;
End;

{ ******************************************************* }
{                    Stroganov Function                   }
{   Limits the rate for non-optimal temp - biolog10ical     }
{   based on O'Neill et al., 1972; Kitchell et al., 1972  }
{   and Bloomfield et al., 1973                           }
{ ******************************************************* }
Function TStates.TCorr(Q10, TRef, TOpt, TMax : double) : double;
const  XM : Double = 2.0;
       KT : Double = 0.5;
       Minus : Double = -1.0;

var  WT, YT, XT, VT, Acclimation : double;
     Temp, Sign, TMaxAdapt, TOptAdapt : double;

begin {  tcorr  }
  Sign := 1.0; { initialize }

  Temp:=GetState(Temperature,StV,WaterCol);

  if (Temp-TRef) < 0.0 then
    Sign := Minus;
  Acclimation := Sign * XM * (1.0 - EXP(-KT * ABS(Temp - TRef))); {Kitchell et al., 1972}
  TMaxAdapt := TMax+Acclimation;
  {   C          C     C  }
  TOptAdapt := TOpt+Acclimation;

  if Q10 <= 1.0 then {JSC added "=" otherwise YT=0, division by zero}
     Q10 := 2.0;    {rate of change per 10 degrees}
  if TMaxAdapt <= TOptAdapt then
     TMaxAdapt := TOptAdapt + VSmall;
  WT := LN(Q10) * (TMaxAdapt-TOptAdapt);
  YT := LN(Q10) * (TMaxAdapt-TOptAdapt+2.0); { NOT IN CEM MODELS }
  XT := (SQR(WT) * SQR(1.0+SQRT(1.0+40.0/YT)))/400.0;
  VT := (TMaxAdapt-Temp)/(TMaxAdapt-TOptAdapt);

  if VT < 0.0 then
     TCorr := 0.0
  else
      TCorr := POWER(VT, XT) * EXP(XT * (1.0-VT));
      {unitless }

end; { tcorr }

Function TStates.Extinct(Incl_Periphyton,Incl_BenthicMacro,Incl_FloatingMacro,IsSurfaceFloater, WeightedAvg: Boolean): double;
  {Modified to allow for weighted average in the event of linked-mode well-mixed stratification, 2-27-08}

Var   PhytoExtinction, TempExt : double;
      Phyto : FirstPlant..LastPlant;
      Pphyto: TPlant;
      DetrLoop: StateVariables;
      DetrState: Double;
      IncludePlant: Boolean;
      OtherSeg: TStates;
      ThisSegThick, OtherSegThick: Double;
    (************************************)
    (* Straskraba, '76; Hutchinson, '57 *)
    (* BUT simplify to linear relation  *)
    (************************************)

    Function GetExtState(S: AllVariables;  T: T_SVType; L: T_SVLayer) : double;
        {Performs weighted avg. by seg. thick if required 2-27-08}
    Begin
       if Not WeightedAvg
         then Result := GetState(S,T,L)
         else
           Begin
             Result := (OtherSeg.GetState(S,T,L)*OtherSegThick + GetState(S,T,L)*ThisSegThick)
                       / (ThisSegThick + OtherSegThick);
           End;

    End;

Begin { extinct }
   If WeightedAvg then with Location.Locale do
     Begin
       ThisSegThick := DynamicZMean;                      //10-14-2010 removed ZMAX from this calculation
       If VSeg = Epilimnion then OtherSeg := HypoSegment
                            else OtherSeg := EpiSegment;
       OtherSegThick := OtherSeg.DynamicZMean;
     End;

   PhytoExtinction := 0.0; { initialize }
   For Phyto := FirstPlant to LastPlant do
       Begin
          PPhyto:=GetStatePointer(Phyto,StV,WaterCol);
          If PPhyto<>nil then with PPhyto.PAlgalRec^ do
            Begin
              {All Phytoplankton gets included}
              IncludePlant := (PlantType='Phytoplankton');
              {Periphyton & Bryophytes get included if requested}
              IncludePlant := IncludePlant or
                 (((PlantType='Periphyton') or (PlantType='Bryophytes')) and (Incl_Periphyton));
              {Benthic Macrophytes get included if requested}
              IncludePlant := IncludePlant or ((PlantType='Macrophytes') and
                                               (PPhyto.MacroType=benthic) and (Incl_BenthicMacro));
              {Floating Macrophytes get included if requested}
              IncludePlant := IncludePlant or ((PlantType='Macrophytes') and
                                               (PPhyto.MacroType<>benthic) and (Incl_FloatingMacro));

             If IncludePlant then With PPhyto.PAlgalRec^ do
               Begin
                 If IsSurfaceFloater and (PPhyto.PAlgalRec^.SurfaceFloating)   // 3/9/2012 move from "blue-green" to surface floater designation
                   {3-8-06 account for more intense self shading in upper layer of water column due to concentration of cyanobacteria there}
                   Then PhytoExtinction := PhytoExtinction + ECoeffPhyto * GetState(Phyto,StV,WaterCol) * Location.MeanThick[VSeg] / PPhyto.DepthBottom
                          {1/m}              {1/m}             {1/(m g/m3)}     {g/m3 volume} {layer, m}    {thick of algae, m}
                   Else PhytoExtinction := PhytoExtinction + ECoeffPhyto * GetExtState(Phyto,StV,WaterCol);
                          {1/m}              {1/m}             {1/(m g/m3)}     {g/m3}
               End;
            End;
       End;

   TempExt := PhytoExtinction + Location.Locale.ECoeffWater;

   {---------------------------------------------------------------------------}
   {Organic Suspended Sediment Extinction}
   For DetrLoop := DissRefrDetr to LastDetr do
     Begin
       DetrState := GetExtState(DetrLoop,Stv,WaterCol);
       If DetrState>0 then with Location.Locale do
         Begin
           If DetrLoop in [DissRefrDetr,DissLabDetr]
             then TempExt := TempExt + ECoeffDOM * DetrState
             else TempExt := TempExt + ECoeffPOM * DetrState;
         End;
     End;

   {---------------------------------------------------------------------------}
   {Inorganic Suspended SEDIMENT EXTINCTION}
   TempExt := TempExt + InorgSedConc(WeightedAvg) * Location.Locale.ECoeffSed;
   {---------------------------------------------------------------------------}

   If TempExt < Tiny then TempExt := Tiny;
   If TempExt > 25.0 then TempExt := 25.0;

   Extinct:=TempExt;
End;

Function TStates.ZEuphotic: Double;
Var RExt, ZEup: Double;
Begin
    RExt := Extinct(False,False,True,False,False);

    If RExt<=0.0
      then ZEup := 4.605  / Location.Locale.ECoeffWater  { 4.605 is ln 1% of surface light }
           { m }                              { 1/m }
      else ZEup := 4.605  / RExt;

    With Location.Locale do
      If UseBathymetry
        then if (ZEup > ZMax) then ZEup := ZMax;
        {else if (ZEup > DynamicZMean) then ZEup := DynamicZMean; }

  ZEuphotic := ZEup;
End;

(*********************************)
(* primary production - algae    *)
(*********************************)
Function TStates.DepthTop : double;
Begin
   DepthTop := 0.0;
   If vseg=hypolimnion Then DepthTop := MaxEpiThick;
   If LinkedMode and Stratified and WellMixed then DepthTop := 0;  {well mixed, average entire light climate, 2-27-08}
End;

Function TStates.WellMixed: Boolean;  {determination of well-mixed in vert stratified linked system }
Var Flow1, Flow2, TotVol: Double;     {based on flow between segments.  Well Mixed = True
                                       If avg. daily Flow between segs. > 30% of tot vol  2-27-2008}
Begin
  WellMixed := False;
  If Not Stratified then exit;
  If Not Linkedmode then exit;  {only relevant to linked mode stratification}

  If Trunc(LastWellMixedTime) = Trunc(TPresent) then
    Begin
      WellMixed := LastWellMixedCalc;
      Exit;
    End;

  With Location.Morph do
    TotVol := SegVolum[Epilimnion] + SegVolum[Hypolimnion];
  if TotVol = 0 then exit;

  Flow1 := 0; Flow2 := 0;
  if ThermLink <> nil then
     Flow1 := TSegmentLink(ThermLink).GetWaterFlow(TPresent);
  if ThermLink2 <> nil then
     Flow2 := TSegmentLink(ThermLink2).GetWaterFlow(TPresent);


  WellMixed := (Flow1+Flow2) / 2  > TotVol * 0.3 ;
              {Avg Flow up & down}  {30% of total volume}

  LastWellMixedtime := TPresent;
  LastWellMixedCalc := Result;

End;

(*****************************************)
(*     fraction of day with daylight     *)
(*  A = amplitude, from Groden, 1977     *)
(*  P formulated & coded by RAP, 6/26/98 *)
(*****************************************)
Function TStates.Photoperiod: double;
var PL: TLight;
{RAP added Sign, 8/23/95}
   A, P, Sign, X : double;
   Function Radians(X: Double):Double;
   begin
     Radians := Pi * X/180;
   end;
begin
  PL := GetStatePointer(Light,StV,WaterCol);
  If PL.CalculatePhotoperiod
    Then
      Begin
        If Location.Locale.Latitude < 0.0 then
          Sign := -1.0 else
          Sign :=  1.0;
        X := JulianDate(TPresent);
        A := 0.1414 * Location.Locale.Latitude - Sign * 2.413;
        P := (12.0 + A * COS(380.0 * Radians(X)/365.0 + 248))/24.0;
        Photoperiod := P;
     End
   Else Photoperiod := PL.UserPhotoPeriod / 24.0;
end;

Procedure TStates.GetTemperatures(Var TempEpi,TempHypo: Double);
Begin
   TempEpi:=-1;  TempHypo:=-1;

   If VSeg=Epilimnion then TempEpi:=GetState(Temperature,Stv,WaterCol)
                      else TempHypo:=GetState(Temperature,Stv,WaterCol);

   If Stratified then if VSeg=Epilimnion
                                 then TempHypo:= HypoSegment.GetState(Temperature,Stv,WaterCol)
                                 else TempEpi := EpiSegment.GetState(Temperature,Stv,WaterCol)
                 else {not Stratified} TempHypo := TempEpi;
End;


Procedure TStates.CopyLayer(FromLayer,ToLayer:T_SVLayer);

Var FromLayerNum,ToLayerNum: Integer;
    CopyVarIndex           : AllVariables;
    CopyTypIndex           : T_SVType;
    FromPSV,ToPSV          : TStateVariable;

Begin
   {COPY APPROPRIATE INFORMATION IN SEDDATA RECORD}
   FromLayerNum:=ORD(FromLayer);
   ToLayerNum:=ORD(ToLayer);
   SedData[ToLayerNum].BedDensity   := SedData[FromLayerNum].BedDensity;
   SedData[ToLayerNum].FracWater    := SedData[FromLayerNum].FracWater;
   SedData[ToLayerNum].BedVolume    := SedData[FromLayerNum].BedVolume;
   SedData[ToLayerNum].DynBedDepth  := SedData[FromLayerNum].DynBedDepth;
   SedData[ToLayerNum].VolumeLost   := SedData[FromLayerNum].VolumeLost;
   SedData[ToLayerNum].PoreSqueeze  := SedData[FromLayerNum].PoreSqueeze;

   {COPY APPROPRIATE INFORMATION ABOUT EACH STATE VARIABLE IN LAYER}
   For CopyVarIndex := PoreWater to SedmLabDetr do
    For CopyTypIndex := STV to LastToxTyp do
     Begin
       FromPSV := GetStatePointer(CopyVarIndex,CopyTypIndex,FromLayer);
       ToPSV := GetStatePointer(CopyVarIndex,CopyTypIndex,ToLayer);
       If (FromPSV<>nil) and (ToPSV<>nil) then ToPSV.State := FromPSV.State;
     End;

   {CONVERT UNITS FOR SEDDETR If SEDLAYER1 is FROMLAYER}
   If FromLayer=SedLayer1 then
    For CopyVarIndex := SedmRefrDetr to SedmLabDetr do
     For CopyTypIndex := STV to LastToxTyp do
      Begin
        FromPSV := GetStatePointer(CopyVarIndex,CopyTypIndex,WaterCol);
        ToPSV := GetStatePointer(CopyVarIndex,CopyTypIndex,ToLayer);
        If (FromPSV<>nil) and (ToPSV<>nil) then
          If CopyTypIndex=StV
            then ToPSV.State := FromPSV.State * StaticZMean
                       {g/m2}             {mg/L}   {m}
            else ToPSV.State := FromPSV.State * StaticZMean * 1e3;
                       {ug/m2}           {ug/L}    {m}        {L/m3}
      End;

   {CONVERT UNITS FOR SEDDETR If SEDLAYER1 is TOLAYER}
   If ToLayer=SedLayer1 then
    For CopyVarIndex := SedmRefrDetr to SedmLabDetr do
     For CopyTypIndex := STV to LastToxTyp do
      Begin
        FromPSV := GetStatePointer(CopyVarIndex,CopyTypIndex,FromLayer);
        ToPSV := GetStatePointer(CopyVarIndex,CopyTypIndex,WaterCol);
        If (FromPSV<>nil) and (ToPSV<>nil) then
          If CopyTypIndex=StV
            then ToPSV.State := FromPSV.State / StaticZMean
                       {mg/L}            {g/m2}    {m}
            else ToPSV.State := FromPSV.State / StaticZMean * 1e-3;
                       {ug/L}           {ug/m2}    {m}          {m3/L}
      End;

End;

Procedure TStates.SetInitHardPan;
Var SedIndex: Integer;
    HardPanFound: Boolean;
Begin
  SedIndex := 0;
  HardPanFound := False;
  If Not SedModelIncluded then exit;

  Repeat
    Inc(SedIndex);
    If (SedData[SedIndex].BedDepthIC<=0) then HardPanFound:=True;
  Until (SedIndex = SedLayers) or HardPanFound;

  If HardPanFound then HardPan := SedIndex
                  else HardPan := SedLayers + 1;
End;


{------------------------------------------------------------------------------}
Procedure TStates.UpdateSedData;    {10-26-2000  JSC}
{Periodically updates the top bed's volume, depth, and porosity data}

Var BedIndex: Integer;
    CurrentLayer: T_SVLayer;
    SedVar: AllVariables;
    SurfArea, PWVol : Double;
    SumNormVol, SumMass: Double;

    Procedure ZeroRecord;
    Begin
      With SedData[BedIndex] do
        Begin
          BedDensity  := 0;
          FracWater   := 0;
          BedVolume   := 0;
          DynbedDepth := 0;
          VolumeLost  := 0;
          PoreSqueeze := 0;
        End;
    End;

    Function GetSedVar: Double;
    {Returns State of SedVar in g/m2}
    Begin
      If (SedVar in [SedmRefrDetr..SedmLabDetr]) and (CurrentLayer=SedLayer1)
        then GetSedVar := GetState(SedVar,StV,WaterCol) * StaticZMean
                                    {g/m3}                   {m}
        else GetSedVar := GetState(SedVar,StV,CurrentLayer);
    End;                           {g/m2}

Begin
  Surfarea := Location.Locale.SurfArea;

  CurrentLayer := WaterCol;
  For BedIndex := 1 to SedLayers do
    If BedIndex >= HardPan
      then ZeroRecord
      else
        Begin {Above Hardpan}
          Inc(CurrentLayer);

          SumMass := 0;
          SumNormVol := 0;
          For SedVar := Cohesives to SedmLabDetr do
            If GetSedVar>0 then
              Begin
                If Densities[SedVar]>0 then
                  SumNormVol := SumNormVol + GetSedVar / Densities[SedVar];
                   {cm3/m2}      {cm3/m2}     {g/m2}          {g/cm3}
                SumMass := SumMass + GetSedVar * SurfArea;
                  {g}        {g}      {g/m2}      {m2}
              End;

          SumNormVol := SumNormVol / 1.0E+06;
           {m3/m2}      {cm3/m2}     {cm3/m3}

          SumNormVol := SumNormVol + GetState(PoreWater,StV,CurrentLayer);
           {m3/m2}       {m3/m2}              {m3/m2}

          PWVol := GetState(PoreWater,StV,CurrentLayer) * SurfArea;
           {m3}              {m3/m2}                        {m2}
          If PWVol<0 then PWVol := 0;

          SumMass := SumMass + PWVol * 1.0E+06;
            {g}        {g}      {m3}  {g h2o / m3}

          With SedData[BedIndex] do
            Begin
              BedVolume := SumNormVol * SurfArea;
                {m3}        {m3/m2}      {m2}
              DynBedDepth := SumNormVol;
                 {m}         {m3/m2}
              If BedVolume<>0
                then BedDensity := SumMass / BedVolume
                      {g/m3}         {g}      {m3}
                else BedDensity := 0;

              If BedVolume<>0
                then FracWater :=  PWVol / BedVolume
                     {fraction}     {m3}     {m3}
                else FracWater := 0;
            End;
        End; {Above Hardpan}

End;

Procedure TStates.PushLayerOnStack;
{Copies Data from the bottom layer onto the stack that is buried "out of the system"}
Var NewOOSL      : TOOSLayer;

    CopyVarIndex : AllVariables;
    CopyTypIndex : T_SVType;
    OOSLIndex    : Integer;
    VarState,ToxLossinKG : Double;
    PoreWaterVol : Double;

Begin
  If OOSStack = nil then OOSStack := TCollection.Init(3,3);

  NewOOSL := TOOSLayer.Create;

  NewOOSL.Data[1] := SedData[SedLayers].BedDensity;
  NewOOSL.Data[2] := SedData[SedLayers].FracWater;
  NewOOSL.Data[3] := SedData[SedLayers].BedVolume;
  NewOOSL.Data[4] := SedData[SedLayers].DynBedDepth;
  NewOOSL.Data[5] := SedData[SedLayers].VolumeLost;
  NewOOSL.Data[6] := SedData[SedLayers].PoreSqueeze;

  OOSLIndex := 6;

  PoreWaterVol := TPoreWater(GetStatePointer(PoreWater,StV,T_SVLayer(SedLayers))).VolumeInL;
  For CopyVarIndex := PoreWater to SedmLabDetr do
   For CopyTypIndex := STV to LastToxTyp do
     Begin
       Inc(OOSLIndex);
       VarState := GetState(CopyVarIndex,CopyTypIndex,T_SVLayer(SedLayers));
       NewOOSL.Data[OOSLIndex]:=VarState;

         If (CopyTypIndex>StV) and (VarState>0) then {save categorized tox loss to output}
           With ToxLossArray[CopyTypIndex] do
             Begin
               If (CopyVarIndex in [PoreWater..LaDomPore])
                 then ToxLossinKG := VarState * PoreWaterVol * 1e-9
                         {kg}       {ug/L (pw)}    {L}        {kg/ug}
                 else ToxLossinKG := VarState * SedLayerArea * 1e-9;
                         {kg}        {ug/m2}       {m2}       {kg/ug}
               OOSBury[0]  := OOSBury[0] + ToxLossInKg;
               TotalToxLoss[0] := TotalToxLoss[0] + ToxLossInKg;
             End;
     End;

  OOSStack.Insert(NewOOSL);
End;


Procedure TStates.PopLayerOffStack;
{Copies data into the bottom layer from the stack that was buried "out of the system"}
Var OldOOSL       : TOOSLayer;
    PSV           : TStateVariable;
    OOSLIndex     : Integer;
    CopyVarIndex  : AllVariables;
    CopyTypIndex  : T_SVType;
    VarState,ToxGaininKG : Double;
    PoreWaterVol : Double;


Begin
  If OOSStack = nil then raise EAQUATOXError.Create('Programming Error, popping off non existent stack');
  If OOSStack.Count=0 then raise EAQUATOXError.Create('Programming Error, popping off empty stack');

  OldOOSL := OOSStack.At(OOSStack.Count-1);

  SedData[SedLayers].BedDensity  := OldOOSL.Data[1];
  SedData[SedLayers].FracWater   := OldOOSL.Data[2];
  SedData[SedLayers].BedVolume   := OldOOSL.Data[3];
  SedData[SedLayers].DynBedDepth := OldOOSL.Data[4];
  SedData[SedLayers].VolumeLost  := OldOOSL.Data[5];
  SedData[SedLayers].PoreSqueeze := OldOOSL.Data[6];

  PoreWaterVol := 0;
  OOSLIndex := 6;
   For CopyVarIndex := PoreWater to SedmLabDetr do
    For CopyTypIndex := STV to LastToxTyp do
     Begin
       Inc(OOSLIndex);

       VarState := -1;
       PSV := GetStatePointer(CopyVarIndex,CopyTypIndex,T_SVLayer(SedLayers));
       If PSV<>nil then
         Begin
           PSV.State := OldOOSL.Data[OOSLIndex];
           VarState := PSV.State;
         End;

       If (CopyVarIndex=PoreWater) and (CopyTypIndex=StV) then
          PoreWaterVol := PSV.State * SedLayerArea * 1000;
                              {m3/m2}     {m2}       {L/m3}

         If (CopyTypIndex>StV) and (VarState>0) then {save categorized tox loss to output}
           With ToxLossArray[CopyTypIndex] do
             Begin
               If (CopyVarIndex in [PoreWater..LaDomPore])
                 then ToxGaininKG := VarState * PoreWaterVol * 1e-9
                         {kg}       {ug/L (pw)}    {L}        {kg/ug}
                 else ToxGaininKG := VarState * SedLayerArea * 1e-9;
                         {kg}        {ug/m2}       {m2}       {kg/ug}
               OOSBury[0]  := OOSBury[0] - ToxGainInKg;
               TotalToxLoss[0] := TotalToxLoss[0] - ToxGainInKg;
             End;
     End;

  OOSStack.AtFree(OOSStack.Count-1);
End;

Procedure TStates.ChangeData;
{Make sure all data is updated prior to study run}
Var i: Integer;
    PSV: TStateVariable;
    Loop2: T_SVType;
    ZM: Double;
Begin
  For i:=0 to count-1 do
    Begin
      PSV:=At(i);
      If PSV.IsAnimal then TAnimal(PSV).ChangeData;
      If PSV.IsPlant then TPlant(PSV).ChangeData;
    End;

  ZM := Location.Locale.ICZMean;
  If Stratified and LinkedMode {with segments linked together}
    then
      Begin
        If VSeg=Epilimnion then ZM := ZM + HypoSegment.Location.Locale.ICZMean
                           else ZM := ZM + EpiSegment.Location.Locale.ICZMean;
      End;

  Location.ChangeData(ZM);

  For Loop2  := FirstOrgTxTyp to LastOrgTxTyp do
    If ChemPtrs^[Loop2] <> nil
      Then ChemPtrs^[Loop2].ChangeData;

End;

Function TStates.SedModelIncluded:Boolean;
Var    TopCohesive: TBottomSediment;
Begin
   TopCohesive := (GetStatePointer(Cohesives,StV,SedLayer1));
   SedModelIncluded := TopCohesive <> nil;
End;


Procedure TStates.CombineTopTwoLayers;
Var CopyVarIndex    : AllVariables;
    CopyTypIndex    : T_SVType;
    TestVar         : Pointer;
    TopLayer        : T_SVLayer;
    TopPSV          : TStateVariable;
    TopValue, BotValue, TopCarry, BotCarry, TotCarry: Double;

Begin
    {Combine Toxicants so as to Maintain Mass Balance}

    {Var Types:  Pore Water, StV, m3/m2    , sum
                 Pore Water, Tox, ug/L     , weighted avg. using pore water vols.
                 DOM Pore  , StV, mg/L     , weighted avg. using pore water vols.
                 DOM Pore  , Tox, ug/L     , weighted avg. using pore water vols.
                 Coh-NonCoh, StV, g/m2     , sum
                 Coh-NonCoh, Tox, ug/m2    , sum
                 SedmDetr  , StV, mg/L(wc) , sum (L in wc unchanged)
                 SedmDetr  , StV, ug/L(wc) , sum (L in wc unchanged)  }

    {Vars for weighted average}
    TopCarry := GetState(PoreWater,STV,SedLayer1);
    BotCarry := GetState(PoreWater,STV,SedLayer2);
    TotCarry := TopCarry + BotCarry;

    For CopyTypIndex := LastToxTyp downto StV do
     For CopyVarIndex := PoreWater to SedmLabDetr do
       Begin
         TestVar := GetStatePointer(CopyVarIndex,CopyTypIndex,SedLayer2);
         If TestVar<>nil then
           Begin
             If CopyVarIndex>=SedmRefrDetr then TopLayer := WaterCol
                                           else TopLayer := SedLayer1;
             TopPSV   := GetStatePointer(CopyVarIndex,CopyTypIndex,TopLayer);
             TopValue := GetState(CopyVarIndex,CopyTypIndex,TopLayer);
             BotValue := GetState(CopyVarIndex,CopyTypIndex,SedLayer2);
             If CopyVarIndex>=SedmRefrDetr then
               If CopyTypIndex>StV
                  then BotValue := BotValue * SedLayerArea / (SegVol * 1e3)
                      {ug/L wc}     {ug/m2}       {m2}        {m3 wc} {L/m3}
                  else BotValue := BotValue * SedLayerArea / SegVol;
                       {mg/L}      {g/m2}       {m2}          {m3}

                 If (CopyVarIndex in [ReDOMPore..LaDOMPore]) or
                    ((CopyTypIndex>StV) and (CopyVarIndex=PoreWater))
                   then Begin
                          If TotCarry < tiny
                            then TopPSV.State := 0
                            else TopPSV.State := (TopValue * (TopCarry/TotCarry)) +
                                                  (BotValue * (BotCarry/TotCarry))   { use weighted avg }
                        End
                   else TopPSV.State := TopValue + BotValue;               { use summation    }
           End;
       End;
End;

Procedure TStates.SplitTopLayer;
Var CopyVarIndex   : AllVariables;
    CopyTypIndex   : T_SVType;
    BotPSV         : TStateVariable;
    TopLayer       : T_SVLayer;
    TopPSV         : TStateVariable;
    BotPore        : TPoreWater;
    TopValue       : Double;
    ConvTopVal     : Double;
    VolumeLost     : Double;
    FracSq,ConcSq  : Double;
    AimDensity, BedVol, BedMass: Double;
    UpperDepth, LowerDepth, TotDepth: Double;

Begin
    {Split the variables between two layers so as to maintain mass balance}

    { Var Types:  Pore Water, StV, m3/m2 , weighted avg. by depth
                  Pore Water, Tox, ug/L  , duplicate unchanged
                  DOM Pore  , StV, mg/L  , duplicate unchanged
                  DOM Pore  , Tox, ug/L  , duplicate unchanged
                  Coh-NonCoh, StV, g/m2  , weighted avg. by depth
                  Coh-NonCoh, Tox, ug/m2 , weighted avg. by depth
                  SedmDetr  , StV, g/m2  , weighted avg. by depth -after convert wc units
                  SedmDetr  , StV, ug/m2 , weighted avg. by depth -after convert wc units}

    {Split State Vars to upper two layers}
    UpperDepth := SedData[1].BedDepthIC;
    LowerDepth := SedData[1].DynBedDepth-UpperDepth;
    TotDepth   := SedData[1].DynBedDepth;

    {Toxicants are concentrations, so duplicate}
    For CopyVarIndex := PoreWater to SedmLabDetr do
     For CopyTypIndex := StV to LastToxTyp do
       Begin
         BotPSV := GetStatePointer(CopyVarIndex,CopyTypIndex,SedLayer2);
         If BotPSV<>nil then
           Begin
             If CopyVarIndex>=SedmRefrDetr
               then TopLayer := WaterCol
               else TopLayer := SedLayer1;
             TopPSV := GetStatePointer(CopyVarIndex,CopyTypIndex,TopLayer);
             TopValue := TopPSV.State;
             ConvTopVal := TopValue;
             If CopyVarIndex>=SedmRefrDetr then
               If CopyTypIndex>StV
                  then ConvTopVal := TopValue *  1e3 *  SegVol / SedLayerArea
                        {ug/m2}      {ug/L}    {L/m3}    {m3}         {m2}
                  else ConvTopVal := TopValue * DynamicZMean;
                         {g/m2}      {g/m3}         {m}

             If (CopyVarIndex in [ReDOMPore..LaDOMPore]) or
                ((CopyTypIndex>StV) and (CopyVarIndex=PoreWater))
                  then BotPSV.State := TopValue  { duplicate unchanged }
                  else
                    Begin                         { weighted avg. by depth }
                      TopPSV.State := (TopValue   * (UpperDepth/TotDepth));
                      BotPSV.State := (ConvTopVal * (LowerDepth/TotDepth));
                    End;
           End;
       End;

    {code below will compress the top bed to the density of what was
     previously the second layer}

    AimDensity := SedData[2].BedDensity;
     {g/m3}
    BedVol := LowerDepth * SedLayerArea;
     {m3}        {m}            {m2}
    BedMass    := BedVol * SedData[1].BedDensity;
      {g}          {m3}                  {g/m3}

    VolumeLost := (BedMass-(AimDensity*BedVol))/(1e6-AimDensity);
      {m3}

    SedData[2].PoreSqueeze := VolumeLost;

    If VolumeLost <=0 then exit;

    BotPore := GetStatePointer(PoreWater,StV,SedLayer2);
    FracSq := (VolumeLost/SedLayerArea) / BotPore.State;
                   {m3}       {m2}                {m3/m2}

    If FracSq<=0 then exit;  {No pore water in the layer to squeeze}

    If FracSq >1 then {can't squeeze more pore water than there is...}
      Begin
        VolumeLost := BotPore.State * SedLayerArea;
          {m3}                {m3/m2}   {m2}
      End;

    BotPore.State := BotPore.State - VolumeLost / SedLayerArea;
            {m3/m2}           {m3/m2}    {m3}           {m2}

   {Squeeze Toxicants, DOM to water column}
    For CopyVarIndex := PoreWater to LaDomPore do
     For CopyTypIndex := StV to LastToxTyp do
       Begin
         BotPSV := GetStatePointer(CopyVarIndex,CopyTypIndex,SedLayer2);
         If (BotPSV<>nil) and
            ((CopyVarIndex>PoreWater) or (CopyTypIndex>StV)) then
           Begin
             ConcSq := BotPSV.State;
           {unit/L sq}

             TopPSV := nil;
             Case CopyVarIndex of
               PoreWater: TopPSV := GetStatePointer(AssocToxSV(CopyTypIndex),StV,WaterCol);
               ReDOMPore: TopPSV := GetStatePointer(DissRefrDetr,CopyTypIndex,WaterCol);
               LaDOMPore: TopPSV := GetStatePointer(DissLabDetr,CopyTypIndex,WaterCol);
             End; {Case}

             TopPSV.State := TopPSV.State + (ConcSq * VolumeLost) / SegVol;
                                 {unit/L wc} {unit/L sq}   {m3 sq}    {m3 wc}
           End;
       End;
End;


Procedure TStates.ZeroBottomLayer;
Var ZeroVarIndex    : AllVariables;
    ZeroTypIndex    : T_SVType;
    ZeroPSV         : TStateVariable;

Begin
  For ZeroVarIndex := PoreWater to SedmLabDetr do
   For ZeroTypIndex := StV to LastToxTyp do
     Begin
       ZeroPSV := GetStatePointer(ZeroVarIndex,ZeroTypIndex,T_SVLayer(SedLayers));
       If (ZeroPSV<>nil) then ZeroPSV.State := 0;
     End;

   With SedData[SedLayers] do
     Begin
       BedDensity  := 0;
       FracWater   := 0;
       BedVolume   := 0;
       DynbedDepth := 0;
       VolumeLost  := 0;
       PoreSqueeze := 0;
     End;
End;

{_______________________________________________________________________________________}

Procedure TStates.DoThisEveryStep(hdid: Double);
{Procedure runs after the derivatives have completed each time step}
Var CurrentYearNum: Integer;

    {-----------------------------------------------------------------}
    Procedure ExposeSed;
    Var Index: Integer;
        LayerLoop, CopyFrom, CopyTo: T_SVLayer;
        PW: TPoreWater;
    begin
      If (Hardpan=2) or(SedLayers=1) then exit; {No layers to expose}

      BaseTopDepth := BaseTopDepth - SedData[2].DynBedDepth;

      CombineTopTwoLayers;

      If SedLayers>2 then
        Begin {Move up all other Sed Layers}
          CopyFrom := SedLayer2;
          CopyTo   := SedLayer1;
          For Index := 2 to SedLayers do
            Begin
              Inc(CopyFrom); Inc(CopyTo);
              CopyLayer(CopyFrom,CopyTo);
            End;

          If HardPan > (SedLayers + 1)
             then PopLayerOffStack
             else ZeroBottomLayer;
        End;

      If SedLayers=2 then ZeroBottomLayer;

      HardPan := HardPan - 1;

      For LayerLoop:= SedLayer1 to LowestLayer do
        Begin
          PW := GetStatePointer(PoreWater,StV,LayerLoop);
          If PW<>nil then PWVol_Last_Step[LayerLoop] := PW.State
                     else PWVol_Last_Step[LayerLoop] := 0;
        End;

      UpdateSedData;
      L1AimDens  := SedData[1].BedDensity;
    End;
    {-----------------------------------------------------------------}
    Procedure CompressSed;
    Var LayerLoop,CopyFrom, CopyTo: T_SVLayer;
        Index: Integer;
        PW: TPoreWater;
    begin
      If HardPan > SedLayers then PushLayerOnStack;

      If SedLayers>2 then
        Begin
          CopyTo   := T_SVLayer(SedLayers);
          CopyFrom := Pred(CopyTo);

          For Index := SedLayers downto 3  do
            Begin
              CopyLayer(CopyFrom,CopyTo);
              Dec(CopyTo); Dec(CopyFrom);
            End;
        End;

      SplitTopLayer;

      HardPan := HardPan + 1;

      UpdateSedData;
      L1AimDens  := SedData[1].BedDensity;

      BaseTopDepth := BaseTopDepth + SedData[2].DynBedDepth; 

      For LayerLoop:= SedLayer1 to LowestLayer do
        Begin
          PW := GetStatePointer(PoreWater,StV,LayerLoop);
          If PW<>nil then PWVol_Last_Step[LayerLoop] := PW.State
                     else PWVol_Last_Step[LayerLoop] := 0;
        End;
    end;
    {-----------------------------------------------------------------}
    Procedure MultiFishPromote;
    Var Young,MFLoop: AllVariables;
        PYF, POF    : TStateVariable;  {PYoungFish, POldFish}
        PAnml       : TAnimal;
        ToxLoop     : T_SVTYpe;
        OldestFish  : Boolean;  {Is program evaluating oldest age-class in simulation}
    Begin
      PAnml := GetStatePointer(Fish3,StV,WaterCol);
      If (PAnml=nil) then exit;

      OldestFish:=True;
      If PAnml.SpawnNow and (not PAnml.Spawned) and (PAnml.SpawnTimes=0) then {first spawning of the year}
        For MFLoop := Fish15 downto Fish1 do
          If GetStatePointer(MFLoop,StV,WaterCol)<>nil then
            Begin
              Young := Pred(MFLoop);
              {promote fish itself}
              POF := GetStatePointer(MFLoop,StV,WaterCol);
              PYF := GetStatePointer(Young,StV,WaterCol);
              If OldestFish          then POF.State := POF.State + PYF.State
                else If MFLoop=Fish1 then POF.State := 0  {YOY}
                                     else POF.State := PYF.State;

              {promote org toxicants and mercury}
              For ToxLoop:=FirstToxTyp to LastToxTyp do
                Begin
                  POF := GetStatePointer(MFLoop,ToxLoop,WaterCol);
                  If POF<>nil then
                    Begin
                      PYF := GetStatePointer(Young,ToxLoop,WaterCol);
                      If OldestFish          then POF.State := POF.State + PYF.State
                        else If MFLoop=Fish1 then POF.State := 0
                                             else POF.State := PYF.State;
                    End;
                End;
              If OldestFish then OldestFish:=False;
            End;
    End;
    {---------------------------------------------------------------------------------------------}
    Procedure Anadromous_Migr;
    Var yr,mo,dy: Word;
        JulianDate: Integer;
        FLoop: AllVariables;
        YoungFish, PFish: TAnimal;


        {---------------------------------------------------------------------------------------------}
        Procedure JuvenileMigration;
        Var BioMigr: Double; // biomass migrating in mg/L
            PToxFish:  TToxics;
            ToxLoop: T_SVTYpe;

        Begin
          BioMigr := PFish.State * YoungFish.AnadRec.FracMigrating;
          Pfish.State := PFish.State - BioMigr;

          With YoungFish.AnadromousData do
            Begin
              Biomass := BioMigr;
              For ToxLoop:=FirstToxTyp to LastToxTyp do
                Begin
                  PToxFish := GetStatePointer(FLoop,ToxLoop,WaterCol);
                  If PToxFish<>nil then
                    Begin
                       Concs[ToxLoop] := PToxFish.State*YoungFish.AnadRec.FracMigrating;  {ug/L}
                       PToxFish.State := PToxFish.State - Concs[ToxLoop];
                    End;
                End;
            End;
        End;
        {---------------------------------------------------------------------------------------------}
        Procedure AdultReturn;
        Var K2, GrowthMult, DepurationEffect: Double;
            DaysPassed: Integer;
            PToxFish:  TToxics;
            ToxLoop: T_SVTYpe;
            ChemOption: UptakeCalcMethodType;
        Begin
          With YoungFish.AnadRec do
             DaysPassed := (365*YoungFish.AnadRec.YearsOffSite) + DateAdultReturn - DateJuvMigr;
          GrowthMult := PFish.PAnimalData^.MeanWeight / YoungFish.PAnimalData^.MeanWeight;

          With YoungFish.AnadromousData do
            PFish.State := PFish.State + Biomass * GrowthMult * (1-YoungFish.AnadRec.MortalityFrac);

          For ToxLoop:=FirstToxTyp to LastToxTyp do
            Begin
              PToxFish := GetStatePointer(FLoop,ToxLoop,WaterCol);
              If PToxFish<>nil then
                Begin
                   ChemOption := ChemPtrs^[ToxLoop].Anim_Method;
                   With YoungFish.Anim_Tox[ToxLoop] do
                    If (ChemOption = CalcK2) and (not ChemPtrs^[ToxLoop].ChemRec.IsPFA)
                      then K2 := Entered_K1 / Entered_BCF
                      else K2 := Entered_K2; {1/d}
                   DepurationEffect := Power((1-K2),DaysPassed);

                   With YoungFish.AnadromousData do
                     PToxFish.State := PToxFish.State + Concs[ToxLoop] * DepurationEffect * (1-YoungFish.AnadRec.MortalityFrac); {ug/L}
                End;
            End;

        End;
        {---------------------------------------------------------------------------------------------}


    Begin
      If Trunc(TPresent)=AnadromousDate then Exit; {check migration once each day}
      AnadromousDate := Trunc(TPresent); {round down to a daily value}
      DecodeDate(TPresent,Yr,Mo,Dy);
      JulianDate := Trunc(TPresent - EncodeDate(Yr-1,12,31));

      For FLoop:=FirstFish to LastFish do
        Begin
          PFish := GetStatePointer(FLoop,StV,WaterCol);
          If (PFish<>nil) then
            If (PFish.PSameSpecies^ <> nullstatevar) then
              Begin
                If PFish.IsSmallFish then YoungFish := PFish
                                     else YoungFish := GetStatePointer(PFish.PSameSpecies^,StV,WaterCol);
                If (YoungFish <> nil) then
                 If (YoungFish.AnadRec.IsAnadromous) then
                  Begin
                    If PFish.IsSmallFish and (YoungFish.AnadRec.DateJuvMigr = JulianDate) then JuvenileMigration;
                    If Not PFish.IsSmallFish and (YoungFish.AnadRec.DateAdultReturn = JulianDate) then AdultReturn;
                  End;
              End;
        End;
    End;
    {---------------------------------------------------------------------------------------------}
    Procedure FishRecruit;
    Var FLoop:   AllVariables;
        PFish:   TAnimal;
        PToxFish:  TToxics;
        ToxLoop: T_SVTYpe;
    Begin
      For FLoop:=FirstFish to LastFish do
        Begin
          PFish := GetStatePointer(FLoop,StV,WaterCol);
          If PFish<>nil then
            Begin
              PFish.State := PFish.State + PFish.RecrSave;
              For ToxLoop:=FirstToxTyp to LastToxTyp do
                Begin
                  PToxFish := GetStatePointer(FLoop,ToxLoop,WaterCol);
                  If PToxFish<>nil then
                     PToxFish.State := PToxFish.State + PToxFish.RecrSave;
                End;
            End;
        End;
    End;
    {-----------------------------------------------------------------}
(*   Procedure CalculateLipid(P : TStateVariable);
     {********************************************}
     {*       calculate changes in lipids        *}
     {*       based on condition of fish         *}
     {*     -  ignore defecation {food quality}  *}
     {  DISABLED 4/28/2009, out-of-date           }
     {********************************************}
    var       DeltaLipid : double;

    const     MaxRateFattening:double = 0.001; {frac. lipid/day}
              MaxLipid:double = 0.12;  {ave. max., not gravid females}
    begin
      If P.IsFish then
        with TAnimal(P) do with PAnimalData^ do
          begin
            DeltaLipid := (Consumption - Respiration) /
                          (MaxConsumption - EndogResp) *
                          (MaxRateFattening * (TPresent-TPreviousStep));
            CalcLipid := CalcLipid + DeltaLipid;
            If CalcLipid <= 0.0 then
               CalcLipid := 0.001;
            If CalcLipid > MaxLipid then
               CalcLipid := MaxLipid;
          end; {if fish}
    end; {CalculateLipid}  *)

    {-----------------------------------------------------------------}
    Procedure UpdateSedConcs;  {write suspended sed concs for mort effects}
    var pconc, newconc: TSVConc;
        i: Integer;
        deleted : boolean;
    Begin
      newconc := TSVConc.Init(InorgSedConc(False),TPresent);
      PSedConcs.AtInsert(0,newconc);

      i := PSedConcs.Count-1;  {clean up any data points greater than 61 days old}
      Repeat
        Deleted := False;
        PConc := PSedConcs.At(i);
        If TPresent - PConc.Time  > 61 {days}
          then
            Begin
              PSedConcs.AtFree(i);
              Deleted := True;
            End;
        Dec(i);
      Until (not deleted) or (i<0);
    End;
    {-----------------------------------------------------------------}
    Procedure UpdateO2Concs;
    var pconc, newconc: TSVConc;
        i: Integer;
        deleted : boolean;
    Begin
      newconc := TSVConc.Init(GetState(Oxygen,StV,WaterCol),TPresent);
      PO2Concs.AtInsert(0,newconc);

      i := PO2Concs.Count-1;  {clean up any data points greater than 96 hours old}
      Repeat
        Deleted := False;
        PConc := PO2Concs.At(i);
        If TPresent - PConc.Time  > 4 {days or 96 hours}
          then
            Begin
              PO2Concs.AtFree(i);
              Deleted := True;
            End;
        Dec(i);
      Until (not deleted) or (i<0);
    End;
    {-----------------------------------------------------------------}
    Procedure UpdateLightVals;  {Time history of daily average light values}
    var pconc, newconc: TSVConc;
        i: Integer;
        PL: TLight;
        deleted : boolean;
    Begin
      PL := GetStatePointer(Light,StV,WaterCol);
      newconc := TSVConc.Init(PL.DailyLight,TPresent);
      PLightVals.AtInsert(0,newconc);

      i := PLightVals.Count-1;  {clean up any data points greater than 96 hours old}
      Repeat
        Deleted := False;
        PConc := PLightVals.At(i);
        If TPresent - PConc.Time  > 4 {days or 96 hours}
          then
            Begin
              PLightVals.AtFree(i);
              Deleted := True;
            End;
        Dec(i);
      Until (not deleted) or (i<0);
    End;
    {-----------------------------------------------------------------}

    Procedure SetFracKilled_and_Spawned(P: TStateVariable);
    Var PAnim: TAnimal;
        MidWinterJulianDate, sl: Integer;
        ToxLoop: T_SVType;
        ionized: Boolean;
        WeightedCumFracKill, WeightedTempResistant: Double;
    Begin
      If P.IsPlant then
        TPlant(P).NutrLim_Step := TPlant(P).NutrLimit;

      If Location.Locale.Latitude < 0.0 then MidWinterJulianDate := 182
                                        else MidWinterJulianDate := 1;

      If P.IsPlantOrAnimal then
        With TOrganism(P) do
          Begin
            WeightedCumFracKill   := (C1*SedDeltaCumFracKill[1]+C3*SedDeltaCumFracKill[3]+C4*SedDeltaCumFracKill[4]+C6*SedDeltaCumFracKill[6])*hdid;
            WeightedTempResistant := (C1*SedDeltaResistant[1]+C3*SedDeltaResistant[3]+C4*SedDeltaResistant[4]+C6*SedDeltaResistant[6])*hdid;
            If WeightedCumFracKill > 0 then SedPrevFracKill := SedPrevFracKill + WeightedCumFracKill;
            If WeightedTempResistant > 0 then  SedResistant := SedResistant  + WeightedTempResistant;
            If SedResistant>1 then SedResistant :=1;
            For sl := 1 to 6 do
              Begin
                SedDeltaCumFracKill[sl] := 0;  {initialize for next step's calculations}
                SedDeltaResistant[sl] := 0;
              End;

            For ionized := False to True do
              Begin
                WeightedCumFracKill   := (C1*AmmoniaDeltaCumFracKill[ionized,1]+C3*AmmoniaDeltaCumFracKill[ionized,3]+C4*AmmoniaDeltaCumFracKill[ionized,4]+C6*AmmoniaDeltaCumFracKill[ionized,6])*hdid;
                WeightedTempResistant := (C1*AmmoniaDeltaResistant[ionized,1]+C3*AmmoniaDeltaResistant[ionized,3]+C4*AmmoniaDeltaResistant[ionized,4]+C6*AmmoniaDeltaResistant[ionized,6])*hdid;
                If WeightedCumFracKill > 0 then AmmoniaPrevFracKill[ionized] := AmmoniaPrevFracKill[ionized] + WeightedCumFracKill;
                If WeightedTempResistant > 0 then AmmoniaResistant[ionized]    := AmmoniaResistant[ionized]  + WeightedTempResistant;
                If AmmoniaResistant[ionized] > 1 then AmmoniaResistant[ionized] := 1;
                For sl := 1 to 6 do
                  Begin
                    AmmoniaDeltaCumFracKill[ionized,sl] := 0;
                    AmmoniaDeltaResistant[ionized,sl] := 0;
                  End;
              End;

            For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
              Begin
                WeightedCumFracKill   := (C1*DeltaCumFracKill[toxloop,1]+C3*DeltaCumFracKill[toxloop,3]+C4*DeltaCumFracKill[toxloop,4]+C6*DeltaCumFracKill[toxloop,6])*hdid;
                WeightedTempResistant := (C1*DeltaResistant[toxloop,1]+C3*DeltaResistant[toxloop,3]+C4*DeltaResistant[toxloop,4]+C6*DeltaResistant[toxloop,6])*hdid;
                If WeightedCumFracKill > 0 then PrevFracKill[ToxLoop] := PrevFracKill[ToxLoop] + WeightedCumFracKill;
                If WeightedTempResistant > 0 then Resistant[ToxLoop]    := Resistant[ToxLoop]  + WeightedTempResistant;
                If Resistant[ToxLoop] > 1 then Resistant[ToxLoop] := 1;
                For sl := 1 to 6 do
                  Begin
                    DeltaCumFracKill[toxloop,sl] := 0;
                    DeltaResistant[toxloop,sl] := 0;
                  End;
              End;

            If JulianDate(TPresent) = MidWinterJulianDate then  {9-17-07 JSC, see specs in section 8.1}
              Begin  {it is assumed that resistance persists in the population until the end of the growing season}
                SedPrevFracKill := 0;
                SedResistant := 0;
                For ionized := False to True do
                  Begin
                    AmmoniaPrevFracKill[ionized] := 0;
                    AmmoniaResistant[ionized]    := 0;
                  End;
                For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
                  Begin
                    PrevFracKill[ToxLoop] := 0;
                    Resistant[ToxLoop]    := 0;
                    FirstExposure[ToxLoop] := 0;
                  End;
              End;
          End;

      If P.IsAnimal then
        Begin
          PAnim:=TAnimal(P);
          With PAnim do With PAnimalData^ do
            If (SpawnNow) and (not Spawned)
              Then Begin
                     Inc(SpawnTimes);
                     { Spawned must be set to true so that fish do not
                       spawn multiple times in the same day / temp. range }
                     Spawned:=True;
                   End
              Else If (Not SpawnNow) then Spawned:=False;

          {Reset Number of Spawning Times in Midwinter}
          If JulianDate(TPresent) = MidWinterJulianDate then PAnim.SpawnTimes := 0;
        End;  {if IsAnimal}
    End;  {Set FracKilled and Spawned}
    {-----------------------------------------------------------------}
    Procedure CheckSloughEvent(P: TPlant);
    Begin
      If P.IsPlant then with P do
        Begin
          If SloughEvent then
            Begin
              If (State<=SloughLevel) then
                Begin
                  SloughEvent := False;
                  If nstate in [FirstGreens..LastGreens] then ProgData.SloughGr   := False else
                  If nstate in [FirstDiatom..LastDiatom] then ProgData.SloughDia  := False
                                                         else ProgData.SloughBlGr := False;
                End;
            End; {sloughevent}
        End; {IsPlant}
    End;
    {-----------------------------------------------------------------}

    Procedure MigrateAnimals;
    Var MigrLoop: AllVariables;
        PA: TAnimal;
        FromSV, ToSV: TStateVariable;
        MigrIndex,MonthIndex,DayIndex,YrIndex: Word;
        MigrToPS: TStates;
        TypLoop: T_SVType;
        AmountMoving: Double;
    Begin
      If Not LinkedMode or CascadeRunning then Exit;

      If Trunc(TPresent)=MigrateDate then Exit; {check migration once each day}
      MigrateDate := Trunc(TPresent); {round down to a daily value}

      DecodeDate(TDateTime(TPresent),YrIndex,MonthIndex,DayIndex);

      For MigrLoop := FirstAnimal to LastAnimal do    {Code tested 12-24-08}
        Begin
          PA := GetStatePointer(MigrLoop,StV,WaterCol);
          If PA<>nil then
            For MigrIndex:=1 to 5 do
              If (PA.MigrInput[MigrIndex].MM=MonthIndex) and
                 (PA.MigrInput[MigrIndex].DD=DayIndex)  and
                 (PA.MigrInput[MigrIndex].FracMigr>0)  and
                 (PA.MigrInput[MigrIndex].ToSeg<>'') then
                Begin {Time for this animal to migrate}
                  MigrToPS := GetPStatesFromID(PA.MigrInput[MigrIndex].ToSeg);
                  If MigrToPS <> nil then
                    For TypLoop := StV to LastToxTyp do
                      Begin
                        FromSV := GetStatePointer(MigrLoop,TypLoop,WaterCol);
                        If FromSV<>nil then
                          Begin
                            ToSV := MigrToPS.GetStatePointer(MigrLoop,TypLoop,WaterCol);
                            AmountMoving := FromSV.State * Volume_Last_Step * PA.MigrInput[MigrIndex].FracMigr;
                             {unit*m3/L}        {unit / L}      {m3}           {              fraction         }
                            FromSV.State := FromSV.State - AmountMoving / Volume_Last_Step;
                              {unit/L}          {unit / L}    {unit*m3/L}        {m3}
                            ToSV.state   := ToSV.State   + AmountMoving / MigrToPS.Volume_Last_Step;
                              {unit/L}          {unit / L}    {unit*m3/L}                {m3}
                          End;
                      End; {typloop}
                End; {if migrating time}
        End; {MigrLoop}
    End;
    {-----------------------------------------------------------------}
    Procedure CalculatePercentEmbedded;  {3-12-08}
    Var Inorg60, PECalc: Double;
    Begin
      Inorg60 := InorgSed60Day(True);
      If Inorg60 < tiny
        then PECalc := 0
        else PECalc := 100 * (0.077 * ln(Inorg60)- 0.020);

      If PECalc < 0 then PECalc := 0;
      If PECalc > 100 then Begin
                             PECalc := 100;
                           End;
      If PECalc > PercentEmbedded then PercentEmbedded := PECalc;

      LastPctEmbedCalc := TPresent;
    End;
    {-----------------------------------------------------------------}

Var i: Integer;
Begin   {Dothiseverystep}

   For i:=0 to count-1 do
     CheckSloughEvent(at(i));

   UpdateLightVals; {update light history values for calculating effects}
   UpdateO2Concs; {update oxygen concentration history for calculating effects}
   UpdateSedConcs; {update sediment conc. history for calculating effects}
   MultiFishPromote;
   FishRecruit;  {add effects of recruitment to all fish vars.  Must be called after multifish promote.}
   Anadromous_Migr;  

   If GetStatePointer(Sand,StV,WaterCol) <> nil then Update_Sed_Bed(TPresent-TPreviousStep);
   {JSC 2-21-2003, Update sediment bed after each derivative step if sediment model is running}

   {After every step, PrevFracKill must be set to Current FracKill for
    correct computation of POISONED}
   {Also, for each animal species spawning data must be updated}
   For i:=0 to count-1 do
      SetFracKilled_and_Spawned(at(i));

   {
   If Not SetupRec.DisableLipidCalc then   Disabled on 4/28/09, code has not been maintained and updated
      For i:=0 to count-1 do
         CalculateLipid(at(i)); {moved from fugacity}

   {update meandischarge calculation each year}
   CurrentYearNum := (Trunc((TPresent-ModelStartTime + 2 ) / 365) + 1);
   If (Not EstuarySegment) and
    (CurrentYearNum > YearNum_PrevStep) then
     SetMeanDischarge(Tpresent);

   If TPresent - LastPctEmbedCalc > 60 {days} then  {3-11-08}
     CalculatePercentEmbedded;

   If SedModelIncluded and not SedNonReactive then
     Begin
       UpdateSedData;
       If SedData[1].DynBedDepth > MaxUpperThick then CompressSed;
       If SedData[1].DynBedDepth < BioTurbThick then ExposeSed;
     End;

   If VSeg=Epilimnion then {Only change yearnum once}
     begin
       YearNum_PrevStep:=CurrentYearNum;
       If (LinkedMode and Stratified) then HypoSegment.YearNum_PrevStep:=CurrentYearNum;
     end;

   MigrateAnimals;

   If Not LinkedMode then ProgData.AnoxicVis:=Anoxic;

End;  {DoThisEveryStep}

{_____________________________________________________________________________________________}


Procedure TStates.WriteCascadeWashout(TimeIndex:TDateTime; hdid: Double);
{ This Procedure Writes Cascade Washout as a daily rate (or hourly depending on time-step),
  doing the same numerical analysis as RKCK does.  The results are also aggregated over the
  course of a time-step, in order to account for the full movement via washout in a day.  The
  daily / hourly rate provides mass balance from one segment to the next (errors on the order of
  machine accuracy).  JSC-- 2-24-2000 }
{ JSC Updated 8-20-2007 Added support for cascade loadings in hourly simulations }

Var LinkLoop, i    : Integer;
    PSv            : TStateVariable;
    PLnk           : TSegmentLink;
    Flow           : Double;
    PctToThisLink  : Double;
    ResultList     : TResults;
    FirstPoint     : Boolean;
    FinishPointNow  : Boolean;
    ResultsWriteTime : Double;
    WashoutVal       : Double;
    TimeStep         : Double;
    PctCalc          : Double;

   {---------------------------------------------------------------------------------------------}

    Procedure WriteWashPoint(Ns: AllVariables; Typ: T_SVType; L: T_SVLayer; Val: Double);
    {Add a washout point to the results list}
    Var NewDPoint : TDatapoint;
        PntIndx : Integer;
    Begin
      PntIndx := ResultList.Datapoints.Count;
      NewDPoint:=TDataPoint.Init(Ns,Typ,L,Val,False,False,False,0,0,PLnk.CascadeWash,Self,False,PntIndx,'');
      Resultlist.Datapoints.Insert(NewDPoint);
    End;

   {---------------------------------------------------------------------------------------------}

Const   C1=37./378;C3=250./621;C4=125./594;C6=512./1771;

Var RepeatCount: Integer;
    ResultsIncrement : Double;
Begin    {WriteCascadeWashout}
  For LinkLoop := 0 to Out_Cs_Links.Count-1 do
    Begin
      PLnk := Out_Cs_Links.At(LinkLoop);
      If PLnk.CascadeWash = nil then PLnk.CascadeWash := TResultsCollection.Init;

      Flow := PLnk.GetWaterFlow(TPresent);
      If Location.Discharge[VSeg] < tiny
        then PctToThisLink :=0
        else PctToThisLink := Flow / Location.Discharge[VSeg];

      RepeatCount := 0;
      Repeat
        Inc(RepeatCount);
        FinishPointNow := True;
        FirstPoint     := False;

        ResultsIncrement := 1;
        IF PModelTimeStep^ = TSHOURLY THEN ResultsIncrement := 1/24;  {8/20/07}

        ResultsWriteTime := PLnk.LastCsPointWritten + ResultsIncrement;
        If ResultsWriteTime > TimeIndex then
           Begin              {Only aggregate partial step}
             ResultsWriteTime := TimeIndex;
             FinishPointNow := False;
           End;

        If ResultsWriteTime<0 then Begin     {Write first datapoint}
                                      ResultsWriteTime := TimeIndex;
                                      FirstPoint := True;
                                   End;

        {Create new result pointer}
        If FinishPointNow then ResultList := TResults.Init(ResultsWriteTime,True);

        {Write all state variables to cascade washout results structure}
        For i:=0 to Count-1 do
          Begin
            PSv := At(i);
            With PSv do
              Begin
                If LinkLoop>0
                  then WashoutVal := WashoutAgg
                  else
                    Begin
                      If (FirstPoint) then WashoutAgg := 0;

                      If FinishPointNow or (RepeatCount>1)
                                             then TimeStep := ResultsWriteTime - LastTimeWrit
                                             else TimeStep := hdid;
                      If FirstPoint then TimeStep := 0;

                      If Location.SiteType=TribInput  { pass loadings through this dummy segment }
                        then With Location do with Morph do
                             Begin
                               PSV.CalculateLoad(TimeIndex);
                               WashoutVal := WashoutAgg + Loading   * SegVol *  TimeStep
                              {1000*mass d}              {mass/L}      {m3}        {d}
                             End
                        else WashoutVal := WashoutAgg + (C1*WashoutStep[1]+C3*WashoutStep[3]+C4*WashoutStep[4]+C6*WashoutStep[6])* TimeStep;
                            {1000*mass d}                    {1000*mass}                                                            {d}

                      WashoutAgg := WashoutVal;
                      LastTimeWrit := ResultsWriteTime;
                    End;

                If FinishPointNow then
                  Begin
                     If PSV.Layer=SedLayer1 {bedload}
                       then PctCalc := 1
                       else PctCalc := PctToThisLink;

                     WriteWashPoint(NState,SVType,Layer,WashoutVal * PctCalc);
                                                        {conc*m3}   {unitless}
                     If (LinkLoop=Out_Cs_Links.Count-1) then WashoutAgg := 0;
                  End;
             End;
          End;

        If FinishPointNow then
          Begin
            PLnk.CascadeWash.Insert(ResultList);
            PLnk.LastCsPointWritten := ResultsWriteTime;
          End;

      Until (not FinishPointNow) or (FinishPointNow and (ResultsWriteTime=TimeIndex)) or FirstPoint;

    End;   {LnkLoop}
End; {WriteCascadeWashout}

{_____________________________________________________________________________________________}

(*  Now part of derivatives for each state variable

Procedure TStates.Add_Cascade_Washin(TimeIndex: Double);
Var i, j: Integer;
    PLnk: TSegmentLink;
    Washin, UpStWashout, WaterFlow: Double;
    PSV: TStateVariable;
    TimeStep: Double;
    DayIndex: Double;

Begin
  If LastCascLoad < 0 then
    Begin
      LastCascLoad := TimeIndex;  {Initialize time to beginning of model run}
      Exit;
    End;

    For i:=0 to In_Cs_Links.Count-1 do  {Step through all incoming cascade links}
      Begin

        PLnk := In_Cs_Links.At(i);
        If PLnk.CascadeWash <> nil then
          Begin
            WaterFlow := PLnk.GetWaterFlow(TimeIndex);
            If Waterflow<0 then Raise EAQUATOXERROR.Create('Error In Link '+PLnk.Name+'.  Cascade Water Flows may not be negative.');

            If WaterFlow > 0 then
              For j := 0 to Count-1 do
                Begin
                  PSV := At(j);

                  DayIndex := TimeIndex + 1;
                  If DayIndex = Int(DayIndex) then DayIndex := TimeIndex;
                  UpStWashout := PLnk.CascadeWash.GetState(PSV.NState,PSV.SVType,PSV.Layer,False,False,False,False,0,DayIndex);

                  Timestep := TimeIndex - LastCascLoad;

                  UpStWashout := UpStWashout * Timestep; {Adjust for the size of the step that was taken}

                  If UpStWashout > 0 then
                    Begin
                      If PSV.Layer=SedLayer1 {bedload}
                        then Washin := UpStWashout / SedLayerArea       {Adjust for area of sediment layer in new seg}
                        else Washin := UpStWashout / Volume_Last_Step;  {Adjust for volume of water in the new segment}
                      PSV.State := PSV.State + Washin;
                    End;
              End;
          End; {cascadewash <> nil}
      End;  {for i ... In_CS_Links}

  LastCascLoad := TimeIndex;
End; *)

{------------------------------------------------------------------------------------------------}

Procedure TStates.WriteResults(TimeIndex:TDateTime; SaveStep:Double; LastPoint:Boolean; hdid: Double);

        {-----------------------------------------------------------------}
        { WriteResults coalates all output that is to be written after    }
        { a successful timestep and writes it to the results structure.   }
        { Results are then integrated over the data-storage step-size     }
        { trapezoidally, or an instantaneous concentration is output      }
        {-----------------------------------------------------------------}

Var
   ResultList : TResults;
   TrapIt     : Boolean;
   WriteTwice : Boolean;
   NumWrites  : Integer;
   WriteSeg   : VerticalSegments;
   WriteMinMaxFlux: Boolean;
   Min1,Min2,Max1,Max2,Duration1,Flux1: Integer;

   {---------------------------------------------------------------------------------------------}
   Procedure PostProcessResults(InterHypo: Boolean);
                               {intermittent hypolimnion?}
   Var
     ResultsWriteTime : Double;
     FirstPoint       : Boolean;
     FinishPointNow   : Boolean;
     NumPointsWritten : Integer;
     LatestRL         : TResults;
     LatestRIndex     : Integer;
     LatestDP         : TDataPoint;

     {-----------------------------------------------------------------}
     { This Proc. takes unevenly timed results with the boolean FINAL  }
     { flag set to false and converts them to even time-stepped points }
     { with the boolean FINAL flag set to true.                        }
     {-----------------------------------------------------------------}

        {------------------------------------------------------------------------------------------------}
         Procedure SpinUpBiota;                                  {3-24-2008}
         { Sets the initial condition of each biotic compartment to its integrated value on the last time-step of
           the simulation.  These variables must be passed back to the "main" simulation in THREAD.PAS }
         Var TS: TStateVariable;
             TRC: TResultsCollection;
             ns: AllVariables;
             ll: T_SVLayer;
             i: Integer;
             TDP: TDataPoint;
             SumSuspDetr, ConvertFrac: Double;
             PD: TDissRefrDetr;
         Begin
           TRC := Results[Epilimnion];
          If ABS (TPresent-SetupRec.LastDay)<1 then  //ensure run completed
           Begin
             For ns := FirstBiota to LastBiota do
              Begin
                i := TRC.GetHeaderIndex(ns,StV,WaterCol,False,False,False,0,0);
                if i > -1 then i := TResHeader(TRC.Headers.At(i)).PointIndex;
                if i > -1 then
                  Begin
                    TDP := TResults(TRC.At(TRC.Count-1)).DataPoints.At(i);
                    TS := GetStatePointer(NS,stv,waterCol);
                    TS.InitialCond := TDP.State;
                  End;
              End;

              If SetupRec.SPIN_Nutrients then   // Nutrient Spinup Added 9/27/2011
                Begin
                  for ns := Ammonia to SedmLabDetr do
                   for ll := WaterCol to SedLayer2 do
                    Begin
                      i := TRC.GetHeaderIndex(ns,StV,ll,False,False,False,0,0);
                      if i > -1 then i := TResHeader(TRC.Headers.At(i)).PointIndex;
                      if i > -1 then
                        Begin
                          TDP := TResults(TRC.At(TRC.Count-1)).DataPoints.At(i);
                          TS := GetStatePointer(NS,stv,ll);
                          If TS<>nil then
                            Begin
                              TS.InitialCond := TDP.State;
                              If (ns=Nitrate) and (ll=WaterCol) then TNo3Obj(TS).TN_IC := False;    //Spun-up initial conditions set not to reflect TN or TP
                              If (ns=Phosphate) and (ll=WaterCol) then TPO4Obj(TS).TP_IC := False;
                            End;
                        End;
                    End;

                  SumSuspDetr := 0;
                  For ns := DissRefrDetr to SuspLabDetr do
                    Begin
                      i := TRC.GetHeaderIndex(ns,StV,watercol,False,False,False,0,0);
                      if i > -1 then i := TResHeader(TRC.Headers.At(i)).PointIndex;
                      if i > -1 then
                        Begin
                          TDP := TResults(TRC.At(TRC.Count-1)).DataPoints.At(i);
                          TS := GetStatePointer(NS,stv,watercol);
                          TS.InitialCond := TDP.State;
                          SumSuspDetr := SumSuspDetr  + TDP.State;
                        End;
                    End;

                  PD := GetStatePointer(DissRefrDetr,StV,WaterCol);
                  ConvertFrac := 1.0;
                  Case PD.InputRecord.DataType of    // Convert to CBOD or OC if required
                      CBOD: ConvertFrac      := Location.Conv_CBOD5_to_OM(PD.InputRecord.Percent_RefrIC);
                      Org_Carb: ConvertFrac := Detr_OM_2_OC;
                    end; {Case}
                  PD.InputRecord.InitCond := SumSuspDetr / ConvertFrac;

                End;  // If Spinup Nutrients
           End;
         End;
        {-------------------------------------------------------------------------------------------}
         Function LinearInterpolate(OldVal,NewVal,OldTime,NewTime,InterpTime: Double): Double;
         {Interpolates to InterpTime between two points, OldPoint and NewPoint}
         Begin
          If (InterpTime>NewTime) or (InterpTime<OldTime)                      {Test Input}
             then Raise EAQUATOXERROR.Create('Interpolation Timestamp Error');

          LinearInterpolate := OldVal + ((NewVal-OldVal)/(NewTime-OldTime)) * (InterpTime-OldTime);
                               { y1 }   {             Slope  (dy/dx)      }   {    Delta X       }
         End;
        {-------------------------------------------------------------------------------------------}
         Procedure CleanupResults;
         {Erases Non "Final" results that are no longer relevant}
         Var Bottom, Top, i: Integer;
             CleanRes : TResults;
             FreeNextPt : Boolean;
         Begin
           If NumPointsWritten=0 then Exit;

           FreeNextPt := False; {save one "non-final" at the end}
           Bottom := 1; {save first point}
           Top := Results[WriteSeg].Count-2;
           If LastPoint or (InterHypo and (Not Stratified)) then
             Begin
               Inc(Top);
               Bottom := 0;
               FreeNextPt := True; {don't save one "non-final" at the end}
             End;
           For i := Top DownTo Bottom do
             Begin
               CleanRes := Results[WriteSeg].At(i);
               If Not CleanRes.Final then
                 If Not FreeNextPt then FreeNextPt := True   {save one "non-final" at the end}
                                   else Results[WriteSeg].AtFree(i)
             End;
         End;
        {-------------------------------------------------------------------------------------------}

        Procedure TrapezoidalIntegration(PntIndex:Integer);

        Var Start_Interval_Time, End_Interval_Time: Double;
            Start_SI_Time, End_SI_Time: Double;  {SI = Subinterval}
            Start_SI_Val, End_SI_Val: Double;
            Start_SI_Index : Integer;
            SumThusFar: Double;
            StartRL   : TResults;
            NewDPoint : TDatapoint;
            DivideStep: Double;

        Begin
          SumThusFar := 0;

          End_Interval_Time   := ResultsWriteTime;
          Start_Interval_Time := ResultsWriteTime - SaveStep;

          If LastPoint or (InterHypo and (Not Stratified))
            then Start_Interval_Time := Last_DataPoint_Written[WriteSeg];

          End_SI_Time    := LatestRL.Date;
          End_SI_Val     := LatestDP.State;
          Start_SI_Index := LatestRIndex;  {We'll step back to find the "real" SI Index}

          REPEAT  {Step through sub intervals, trapezoidally integrate and calculate SumThusFar}

            Repeat  {Step backwards until find previous "non final" (non-integrated) datapoint}
              Start_SI_Index := Start_SI_Index - 1;
              StartRL := Results[WriteSeg].At(Start_SI_Index);
            Until (Start_SI_Index=0) or (not StartRL.Final);

            Start_SI_Time := StartRL.Date;

            If PntIndex<StartRL.DataPoints.Count
              Then Start_SI_Val  := TDataPoint(StartRL.DataPoints.At(PntIndex)).State
              Else Start_SI_Val := 0;

            If End_SI_Time > End_Interval_Time
              Then
                Begin  {Linearly interpolate to get the end sub-interval point}
                  End_SI_Val  := LinearInterpolate(Start_SI_Val,End_SI_Val,Start_SI_Time,End_SI_Time,End_Interval_Time);
                  End_SI_Time := End_Interval_Time;
                End;

            If Start_SI_Time < Start_Interval_Time
              Then
                Begin  {Linearly interpolate to get the beginning sub-interval point}
                  Start_SI_Val  := LinearInterpolate(Start_SI_Val,End_SI_Val,Start_SI_Time,End_SI_Time,Start_Interval_Time);
                  Start_SI_Time := Start_Interval_Time;
                End;

            SumThusFar := SumThusFar + ((Start_SI_Val + End_SI_Val) / 2) * (End_SI_Time - Start_SI_Time);
                                       {The area of the relevant trapezoid is calculated above}

            End_SI_Time  := Start_SI_Time;  {Set up end point for next sub-interval, if relevant}
            End_SI_Val   := Start_SI_Val;

          UNTIL (Start_SI_Time = Start_Interval_Time);

          DivideStep := SaveStep;
          If LastPoint then DivideStep := End_Interval_Time - Start_Interval_Time;
          SumThusFar := SumThusFar / DivideStep;  {Turn sum into average by dividing by step-size}
          NewDPoint:=TDataPoint.Init_Header_Exists(SumThusFar);
          Resultlist.Datapoints.Insert(NewDPoint);
        End;
        {-------------------------------------------------------------------------------------------}
        Procedure InstantaneousConc(PntIndex:Integer);
        Var NewDPoint : TDatapoint;
            OldDPoint : TDatapoint;
            InterpVal : Double;
            PreviousRL: TResults;

        Begin  {Instantaneous Conc.}
             If (ResultsWriteTime = TimeIndex)
                then
                   Begin  {Write Point itself}
                     NewDPoint:=TDataPoint.Init_Header_Exists(LatestDP.State);
                     Resultlist.Datapoints.Insert(NewDPoint);
                   End
                else      {Write point at proper interval by averaging}
                   Begin
                     PreviousRL := Results[WriteSeg].At(LatestRIndex-1);  {pointer to the last set of points written}
                     OldDPoint  := PreviousRL.DataPoints.At(PntIndex);

                     InterpVal := LinearInterpolate(OldDPoint.State,LatestDP.State,PreviousRL.Date,LatestRL.Date,ResultsWriteTime);
                     NewDPoint:=TDataPoint.Init_Header_Exists(InterpVal);
                     Resultlist.Datapoints.Insert(NewDPoint);
                   End;
        End; {Instantaneous Conc.}
        {-------------------------------------------------------------------------------------------}
        Procedure CalcMinMax(PntIndex:Integer; TrapMin: Boolean; Flux: Boolean);
        Var This_Index : Integer;
            Start_Interval_Time, ThisTime, ThisVal, MinThusFar, MaxThusFar: Double;
            StartRL   : TResults;
            NewDPoint : TDatapoint;

        Begin
          TrapIt := True;
          Start_Interval_Time := ResultsWriteTime - SaveStep;

          If LastPoint or (InterHypo and (Not Stratified))
            then Start_Interval_Time := Last_DataPoint_Written[WriteSeg];

          MinThusFar  := LatestDP.State;
          MaxThusFar  := LatestDP.State;
          This_Index := LatestRIndex;  {We'll step back over the interval being written to}

          REPEAT  {Step Backwards through interval}

            Repeat  {Step backwards until find previous "non final" (non-integrated) datapoint}
              This_Index := This_Index - 1;
              StartRL := Results[WriteSeg].At(This_Index);
            Until (This_Index=0) or (not StartRL.Final);

            ThisTime := StartRL.Date;
            If ThisTime > Start_Interval_Time then
              Begin
                ThisVal  := TDataPoint(StartRL.DataPoints.At(PntIndex)).State;
                If (ThisVal < MinThusFar) then MinThusFar := ThisVal;
                If (ThisVal > MaxThusFar) then MaxThusFar := ThisVal;
              End;

          UNTIL (ThisTime <= Start_Interval_Time) or (This_Index=0);

          If Flux then NewDPoint:=TDataPoint.Init_Header_Exists(MaxThusFar-MinThusFar)
                  else If TrapMin
                    then NewDPoint:=TDataPoint.Init_Header_Exists(MinThusFar)
                    else NewDPoint:=TDataPoint.Init_Header_Exists(MaxThusFar);

          Resultlist.Datapoints.Insert(NewDPoint);
        End;
        {-------------------------------------------------------------------------------------------}
        Procedure Find_Trap_Indices;      {FIND INDICES OF DATA-POINTS THAT NEED MIN / MAX / DURATION CALCULATIONS RATHER THAN INTEGRATION}
        Begin
          If WriteMinMaxFlux then
            Begin
               Min1 := Results[WriteSeg].GetHeaderIndex(AllVariables(MinOxygen),OtherOutput,WaterCol,False,False,False,0,0);
               Max1 := Results[WriteSeg].GetHeaderIndex(AllVariables(MaxOxygen),OtherOutput,WaterCol,False,False,False,0,0);
               Flux1 := Results[WriteSeg].GetHeaderIndex(AllVariables(O2FluxOut),OtherOutput,WaterCol,False,False,False,0,0);
               Min2 := Results[WriteSeg].GetHeaderIndex(AllVariables(MinNH3Union),OtherOutput,WaterCol,False,False,False,0,0);
               Max2 := Results[WriteSeg].GetHeaderIndex(AllVariables(MaxNH3Union),OtherOutput,WaterCol,False,False,False,0,0);

               Min1 := TResHeader(Results[WriteSeg].Headers.At(Min1)).PointIndex;
               Min2 := TResHeader(Results[WriteSeg].Headers.At(Min2)).PointIndex;
               Max1 := TResHeader(Results[WriteSeg].Headers.At(Max1)).PointIndex;
               Flux1 := TResHeader(Results[WriteSeg].Headers.At(Flux1)).PointIndex;
               Max2 := TResHeader(Results[WriteSeg].Headers.At(Max2)).PointIndex;
            End;

           Duration1 := Results[WriteSeg].GetHeaderIndex(AllVariables(O2Duration),OtherOutput,WaterCol,False,False,False,0,0);
           If Duration1>-1 then Duration1 := TResHeader(Results[WriteSeg].Headers.At(Duration1)).PointIndex;
        End;
        {-------------------------------------------------------------------------------------------}
        Procedure CalcDuration(PntIndex:Integer);
        Var Start_Interval_Time, End_Interval_Time: Double;
            Start_SI_Time, End_SI_Time: Double;  {SI = Subinterval}
            Start_SI_Val, End_SI_Val, SI_Duration: Double;
            Thresh,UpperVal,LowerVal: Double;
            Start_SI_Index : Integer;
            DurationThusFar: Double;
            StartRL   : TResults;
            NewDPoint : TDataPoint;

        Begin
          TrapIt := True;
          DurationThusFar := 0;
          Thresh := TO2Obj(GetStatePointer(Oxygen,StV,WaterCol)).Threshhold;

          End_Interval_Time   := ResultsWriteTime;
          Start_Interval_Time := ResultsWriteTime - SaveStep;

          If LastPoint or (InterHypo and (Not Stratified))
            then Start_Interval_Time := Last_DataPoint_Written[WriteSeg];

          End_SI_Time    := LatestRL.Date;
          End_SI_Val     := LatestDP.State;
          Start_SI_Index := LatestRIndex;  {We'll step back to find the "real" SI Index}

          REPEAT  {Step through sub intervals, trapezoidally integrate and calculate SumThusFar}

            Repeat  {Step backwards until find previous "non final" (non-integrated) datapoint}
              Start_SI_Index := Start_SI_Index - 1;
              StartRL := Results[WriteSeg].At(Start_SI_Index);
            Until (Start_SI_Index=0) or (not StartRL.Final);

            Start_SI_Time := StartRL.Date;
            Start_SI_Val  := TDataPoint(StartRL.DataPoints.At(PntIndex)).State;

            If End_SI_Time > End_Interval_Time
              Then
                Begin  {Linearly interpolate to get the end sub-interval point}
                  End_SI_Val  := LinearInterpolate(Start_SI_Val,End_SI_Val,Start_SI_Time,End_SI_Time,End_Interval_Time);
                  End_SI_Time := End_Interval_Time;
                End;

            If Start_SI_Time < Start_Interval_Time
              Then
                Begin  {Linearly interpolate to get the beginning sub-interval point}
                  Start_SI_Val  := LinearInterpolate(Start_SI_Val,End_SI_Val,Start_SI_Time,End_SI_Time,Start_Interval_Time);
                  Start_SI_Time := Start_Interval_Time;
                End;

            If (Start_SI_Val < Thresh) or (End_SI_Val<Thresh) then
              Begin
                SI_Duration := (End_SI_Time - Start_SI_Time);
                UpperVal := Max(Start_SI_Val,End_SI_Val);
                LowerVal := Min(Start_SI_Val,End_SI_Val);
                If (Start_SI_Val <= Thresh) and (End_SI_Val <= Thresh)
                  then DurationThusFar := DurationThusFar + SI_Duration
                  else DurationThusFar := DurationThusFar + SI_Duration * ((Thresh - LowerVal)/(UpperVal-LowerVal));
              End;

            End_SI_Time  := Start_SI_Time;  {Set up end point for next sub-interval, if relevant}
            End_SI_Val   := Start_SI_Val;

          UNTIL (Start_SI_Time = Start_Interval_Time);

          NewDPoint:=TDataPoint.Init_Header_Exists(DurationThusFar);
          Resultlist.Datapoints.Insert(NewDPoint);
        End;
        {-------------------------------------------------------------------------------------------}


Var PointLoop  : Integer;
   Begin  {PostProcessResults}

     LatestRIndex := Results[WriteSeg].Count-1;
     LatestRL   := Results[WriteSeg].At(LatestRIndex);  {pointer to the last set of points written}

     Find_Trap_Indices;{FIND INDICES OF MIN / MAX DATA POINTS}

     NumPointsWritten := 0;
     Repeat

       FinishPointNow := True;
       FirstPoint     := False;

       ResultsWriteTime := Last_DataPoint_Written[WriteSeg] + SaveStep;  {Next Fixed Interval to Write}
       If ResultsWriteTime > TimeIndex then
         Begin
           ResultsWriteTime := TimeIndex;                      {We haven't gotten there yet}
           FinishPointNow   := False;
         End;

       If Last_DataPoint_Written[WriteSeg] = -99 then
          Begin                                                {This was the first point written}
            ResultsWriteTime := TimeIndex;
            FirstPoint       := True;
            FinishPointNow   := False;
            LatestRL.Final  := True;                           {Mark this point as permanent (final)}
            Last_Datapoint_Written[WriteSeg] := TimeIndex;
          End;

       If LastPoint and (InterHypo and (Not Stratified)) then exit;  {nothing to process}
       If (InterHypo and (Not Stratified)) and (LatestRL.Final) then
         Begin
           Last_Datapoint_Written[WriteSeg] := -99;
           exit; {nothing to process}
         End;

       If LastPoint or (InterHypo and (Not Stratified)) then
         Begin
           FinishPointNow   :=True;
           If (InterHypo and (Not Stratified)) then
             Begin
               TimeIndex := LatestRL.Date;
               If ResultsWriteTime > TimeIndex then ResultsWriteTime := TimeIndex;
             End;
         End;

       If FinishPointNow then                                  {We passed the end of the interval, so post-process now}
         Begin
           Inc(NumPointsWritten);
           ResultList := TResults.Init(ResultsWriteTime,True);  {create a new "final" results structure with the proper timeindex}

           For PointLoop := 0 to LatestRL.Datapoints.Count-1 do      {Go through each datapoint}
             Begin
               LatestDP := LatestRL.DataPoints.At(PointLoop);

               TrapIt := False;
               If WriteMinMaxFlux then
                 Begin
                   If (PointLoop=Min1) or (PointLoop=Min2) then CalcMinMax(PointLoop,True,False);
                   If (PointLoop=Max1) or (PointLoop=Max2) then CalcMinMax(PointLoop,False,False);
                   If (PointLoop=Flux1) then CalcMinMax(PointLoop,False,True);
                 End;

               If PointLoop = Duration1 then CalcDuration(PointLoop);

               If not TrapIt
                  then If SetupRec.AverageOutput        {fill in data using Trapezoid/Instantaneous method}
                    then TrapezoidalIntegration(PointLoop)
                    else InstantaneousConc(PointLoop);
             End;

           Results[WriteSeg].AtInsert(LatestRIndex,ResultList);  {Insert the new datapoints just before the last date stamp}
           Inc(LatestRIndex);

         End;

       Last_Results_Written[WriteSeg] := TimeIndex;
       If FinishPointNow then Last_DataPoint_Written[WriteSeg] := ResultsWriteTime;

     Until    (not FinishPointNow)
           or (FinishPointNow and (ResultsWriteTime=TimeIndex))
           or (FirstPoint);

     CleanupResults;  {Remove the non-final datapoints that are no longer relevant to the study}

     If LastPoint and SetupRec.SPINUP_MODE and (WriteSeg=Epilimnion) then SpinUpBiota; {3-24-2008}
   End;  {PostProcessResults}

   {------------------------------------------------------------------------------------------------}
   Procedure WritePoint(Ns: AllVariables; Typ: T_SVType; L: T_SVLayer; IsPPB,IsTV: Boolean; IsBF: Word; Val: Double);
   {---------------------------------}
   { Add a point to the results list }
   {---------------------------------}

   Var NewDPoint : TDataPoint;
       PntIndx   : Integer;
       Convert   : Boolean;
   Begin
     Convert := Convert_g_m2_to_mg_L(NS,Typ,L);
     Val := OutputState(NS,Typ,L,Val);
     PntIndx := Resultlist.Datapoints.Count;
     NewDPoint:=TDataPoint.Init(Ns,Typ,L,Val,ISPPB,IsTV,False,IsBF,0,Results[WriteSeg],Self,Convert,PntIndx,'');
     Resultlist.Datapoints.Insert(NewDPoint);
   End; {WritePoint}

   {---------------------------------------------------------------------------------------------}
    Procedure Write_Nutrient_Variables;
    Var N2Org,P2Org, Tot, TotN, TotP, NPart, PPart, NSed, PSed : Double;
        O2Conc, UnIonNH3, pkh, NH4, TKelvin: Double;
        TNWC,TPWC: Double; {TN & TP in the water column, mg/L seston plus dissolved, no inverts.}
        CBOD     : Double; {CBOD in the water column, mg/L}
        SedVol   : Double;
        NSloop: AllVariables;
        PPL: TPlant;  PAn: TAnimal;
        typ: T_SVType;  LayLoop: T_SVLayer;

    Begin
     TotN := GetState(Ammonia,StV,WaterCol) + GetState(Nitrate,StV,WaterCol);  TNWC := TotN;  // dissolved in water column
     TotP := GetState(Phosphate,StV,WaterCol);  TPWC := TotP;

     WritePoint(AllVariables(NDissWater),Ntrack,WaterCol,False,True,0,TotN * SegVol * 1000.0 * 1e-6);
     WritePoint(AllVariables(NDissWater),Ptrack,WaterCol,False,True,0,TotP * SegVol * 1000.0 * 1e-6);
                              {kg}                                        {mg/L}  {m3}    {L/m3}  {kg/mg}
     CBOD   :=0;
     NPart :=0; NSed :=0;
     PPart :=0; PSed :=0;
     For nsloop := SedmRefrDetr to SuspLabDetr do
      If GetState(nsLoop,StV,WaterCol)>0 then
        Begin
          With Location.Remin do
           Case nsloop of
             SedmRefrDetr, SuspRefrDetr: Begin N2Org := N2Org_Refr;     P2Org := P2Org_Refr;    End;
             SedmLabDetr, SuspLabDetr:   Begin N2Org := N2OrgLab;       P2Org := P2OrgLab;      End;
             DissRefrDetr:               Begin N2Org := N2OrgDissRefr;  P2Org := P2OrgDissRefr; End;
             Else {DissLabDetr:}         Begin N2Org := N2OrgDissLab;   P2Org := P2OrgDissLab;  End;
             End; {Case}

             If nsloop in [SedmRefrDetr, SedmLabDetr]
               Then
                 Begin     {track as part of sediment}
                   NSed := NSed + GetState(nsLoop,StV,WaterCol) * N2Org * SegVol * 1000.0 * 1e-6;
                   PSed := PSed + GetState(nsLoop,StV,WaterCol) * P2Org * SegVol * 1000.0 * 1e-6;
                 End        {kg}           {mg/L}                         {m3}     {L/m3}   {kg/mg}
               else
                 Begin  {track as part of susp-detr}
                   NPart := NPart + GetState(nsLoop,StV,WaterCol) * N2Org;
                   PPart := PPart + GetState(nsLoop,StV,WaterCol) * P2Org;
                 End;

             If nsloop in [SuspRefrDetr,DissRefrDetr,SuspLabDetr,DissLabDetr] then  {dissolved & Suspended Particulate only for TN&TC Calc}
               Begin
                 TNWC := TNWC + GetState(nsLoop,StV,WaterCol) * N2Org;  {mg/L}
                 TPWC := TPWC + GetState(nsLoop,StV,WaterCol) * P2Org;  {mg/L}
                 
                 If nsloop in [SuspLabDetr,DissLabDetr] then
                   CBOD  := CBOD + GetState(nsLoop,StV,WaterCol) * Location.Remin.O2Biomass;
                                   {mg/L}                        {converts OM to BOD5}
               End;
        End;

     WritePoint(AllVariables(NDetr),Ntrack,WaterCol,False,True,0,NPart * SegVol * 1000.0 * 1e-6);
     WritePoint(AllVariables(NDetr),Ptrack,WaterCol,False,True,0,PPart * SegVol * 1000.0 * 1e-6);
                              {kg}                                {mg/L}  {m3}    {L/m3}  {kg/mg}

     TotN := TotN + NPart;      // particulate detritus
     TotP := TotP + PPart;

     If Diagenesis_Included then {Sum Nutrients in Diagenesis Layers}
       Begin
         SedVol := DiagenesisVol(2);
         For nsloop := PON_G1 to PON_G3 do
             NSed := NSed + GetState(NSLoop,StV,SedLayer2) * SedVol  * 1e-3;
              {kg}           {g/m3}                           {m3}   {kg/g}
         For nsloop := POP_G1 to POP_G3 do
             PSed := PSed + GetState(NSLoop,StV,SedLayer2) * SedVol  * 1e-3;
              {kg}            {g/m3}                           {m3}   {kg/g}
         For LayLoop := SedLayer1 to SedLayer2 do
           Begin
             If (LayLoop = SedLayer1) and Diagenesis_Steady_State then Continue;  // 10/27/2010 steady state layer not tracked for Conservation of Mass Balance
             If LayLoop = SedLayer1 then SedVol := DiagenesisVol(1)
                                    else SedVol := DiagenesisVol(2);
             NSed := NSed + GetState(Ammonia,  Stv,LayLoop) * SedVol  * 1e-3;
             NSed := NSed + GetState(Nitrate,  Stv,LayLoop) * SedVol  * 1e-3;
             PSed := PSed + GetState(Phosphate,Stv,LayLoop) * SedVol  * 1e-3;
             {kg}              {g/m3}                           {m3}    {kg/g}
           End;
       End;
     WritePoint(AllVariables(NSediment),Ntrack,WaterCol,False,True,0,NSed); {kg}
     WritePoint(AllVariables(NSediment),Ptrack,WaterCol,False,True,0,PSed); {kg}

     TotN := TotN + NSed / (SegVol * 1000.0 * 1e-6);  {add sed layer quantity of nutrients in mg/L}
     TotP := TotP + PSed / (SegVol * 1000.0 * 1e-6);
     {mg/L}         {kg}    {m3}      {l/m3} {kg/mg}

     NPart :=0;
     PPart :=0;
     For nsloop := FirstPlant to LastPlant do
      If GetState(nsLoop,StV,WaterCol)>0 then
       Begin
         PPL := GetStatePointer(nsLoop,StV,WaterCol);
         NPart := NPart + PPl.State * PPL.N_2_Org;
         PPart := PPart + PPl.State * PPL.P_2_Org;

         If (PPL.IsPhytoplankton) then
           Begin
             TNWC := TNWC + PPl.State * PPL.N_2_Org; {mg/L}
             TPWC := TPWC + PPl.State * PPL.P_2_Org; {mg/L}
            {  CBOD   := CBOD + PPl.State / BOD_Frac;  8-13-2007}
                               {mg/L}
           End;
       End;
     WritePoint(AllVariables(NPlants),Ntrack,WaterCol,False,True,0,NPart * SegVol * 1000.0 * 1e-6);
     WritePoint(AllVariables(NPlants),Ptrack,WaterCol,False,True,0,PPart * SegVol * 1000.0 * 1e-6);

     TotN := TotN + NPart;  // n in plants
     TotP := TotP + PPart;

     NPart :=0;
     PPart :=0;
     For nsloop := FirstAnimal to LastAnimal do   // calculate nutrients in animals
      If GetState(nsLoop,StV,WaterCol)>0 then
       Begin
         PAn := GetStatePointer(nsLoop,StV,WaterCol);
         NPart := NPart + PAn.State * PAn.PAnimalData.N2Org;
         PPart := PPart + PAn.State * PAn.PAnimalData.P2Org;

//         If (PAn.PAnimalData.Animal_Type='Pelagic Invert.') then
//           Begin
//             TNWC := TNWC + PAn.State * PAn.PAnimalData.N2Org; {mg/L}  4/16/2012  Took zooplankton out of the calculation of TN and TP to preserve comparison with observed data.
//             TPWC := TPWC + PAn.State * PAn.PAnimalData.P2Org; {mg/L}  4/16/2012
//           End;

       End;
     WritePoint(AllVariables(NAnimals),Ntrack,WaterCol,False,True,0,NPart * SegVol * 1000.0 * 1e-6);
     WritePoint(AllVariables(NAnimals),Ptrack,WaterCol,False,True,0,PPart * SegVol * 1000.0 * 1e-6);

     TotN := TotN + NPart;   // track all nutrients in modeled system, not just water column
     TotP := TotP + PPart;

     WritePoint(AllVariables(TN),OtherOutput,WaterCol,False,False,0,TNWC);
     WritePoint(AllVariables(TP),OtherOutput,WaterCol,False,False,0,TPWC);
     WritePoint(AllVariables(BODOut),OtherOutput,WaterCol,False,False,0,CBOD);

     TotN := TotN * SegVol * 1000.0 * 1e-6;
     TotP := TotP * SegVol * 1000.0 * 1e-6;
     {kg}   {mg/L}   {m3}    {L/m3}  {kg/mg}

     {NUTRIENT FATE / MASS BALANCE TRACKING }
     For NSLoop := Nitrate to Phosphate do
       With MBLossArray[NSLoop] do
        Begin
         If NSLoop=Nitrate then typ:=NTrack else typ:=PTrack;
         If NSLoop=Nitrate then tot:=TotN   else tot:=TotP;

         WritePoint(AllVariables(TotNMass),typ,watercol,False,True,0,tot);
         WritePoint(AllVariables(TotNLoss),typ,watercol,False,True,0,TotalNLoss[0]);
         WritePoint(AllVariables(TotalNWash),typ,watercol,False,True,0,TotalWashout[0]);
         WritePoint(AllVariables(NWashH2o),typ,watercol,False,True,0,WashoutH2O[0]);
         WritePoint(AllVariables(NWashAnim),typ,watercol,False,True,0,WashoutAnim[0]);
         WritePoint(AllVariables(NWashDetr),typ,watercol,False,True,0,WashoutDetr[0]);
         WritePoint(AllVariables(NWashPlant),typ,watercol,False,True,0,WashoutPlant[0]);
         WritePoint(AllVariables(NEmergeI),typ,watercol,False,True,0,EmergeIns[0]);
         If NSLoop=Nitrate then   WritePoint(AllVariables(NDenitr),typ,watercol,False,True,0,Denitrify[0]);
         If NSLoop=Phosphate then WritePoint(AllVariables(NSorbCaCO3),typ,watercol,False,True,0,CaCO3Sorb[0]);
         WritePoint(AllVariables(NBurial),typ,watercol,False,True,0,Burial[0]);
         WritePoint(AllVariables(NFishing),typ,watercol,False,True,0,FishingLoss[0]);

         With MBLoadArray[NSLoop] do
          Begin
            WritePoint(AllVariables(NTotLoad),typ,watercol,False,True,0,TotOOSLoad[0]);
            WritePoint(AllVariables(NLoadDissH2O),typ,watercol,False,True,0,LoadH2O[0]);
            WritePoint(AllVariables(NLoadDetr),typ,watercol,False,True,0,LoadDetr[0]);
            WritePoint(AllVariables(NLoadBiota),typ,watercol,False,True,0,LoadBiota[0]);
            WritePoint(AllVariables(NPWMacro),typ,watercol,False,True,0,LoadPWMacro[0]);
            If NSLoop=Nitrate then
               WritePoint(AllVariables(NFixation),typ,watercol,False,True,0,LoadFixation[0]);
            WritePoint(AllVariables(NExposure),typ,watercol,False,True,0,Exposure[0]);
            WritePoint(AllVariables(BoundaryCond),typ,watercol,False,True,0,BoundLoad[0]-BoundLoss[0]);

          With MBLayerArray[NSLoop] do
           Begin
             WritePoint(AllVariables(NLSink),typ,watercol,False,True,0,NSink[0]);
             WritePoint(AllVariables(NLTDiff),typ,watercol,False,True,0,NTurbDiff[0]);
             WritePoint(AllVariables(NLMigr),typ,watercol,False,True,0,NMigrate[0]);
             WritePoint(AllVariables(NLayerNet),typ,watercol,False,True,0,NNetLayer[0]);
             WritePoint(AllVariables(NMBTest),typ,watercol,False,True,0,Tot+TotalNLoss[0]-TotOOSLoad[0]-NNetLayer[0]);
           End; {with}
         End; {with}
       End; {nsloop, with}

     {ionized ammonia, after Bowie et al., 1985, p. 5-20}
     NH4 := GetState(Ammonia,StV,WaterCol);
     TKelvin := 273.16 + GetState(Temperature,StV,WaterCol);
     pkh := 0.09018 + 2729.92/TKelvin;
     UnIonNH3 := NH4/(1 + POWER(10, (pkh - GetState(pH,StV,WaterCol))));
               {mg/L}{      fraction that is un-ionized     }

     { Below Variables are not integrated, but min / max / duration is calculated }
     WritePoint(AllVariables(NH3UnIon),OtherOutput,WaterCol,False,False,0,UnIonNH3);

     O2Conc := GetState(Oxygen,StV,WaterCol);
     If WriteMinMaxFlux then
          Begin
            WritePoint(AllVariables(MinNH3UnIon),OtherOutput,WaterCol,False,False,0,UnIonNH3);
            WritePoint(AllVariables(MaxNH3UnIon),OtherOutput,WaterCol,False,False,0,UnIonNH3);
            WritePoint(AllVariables(MinOxygen),OtherOutput,WaterCol,False,False,0,O2Conc);
            WritePoint(AllVariables(MaxOxygen),OtherOutput,WaterCol,False,False,0,O2Conc);
            If (TimeIndex = SetupRec.FirstDay) then O2Conc := 0; {write 0 for first duration & flux}
               WritePoint(AllVariables(O2FluxOut),OtherOutput,WaterCol,False,False,0,O2Conc);
          End;

     If (TimeIndex = SetupRec.FirstDay) then O2Conc := 0; {write 0 for first duration & flux}
     If TO2Obj(GetStatePointer(Oxygen,StV,WaterCol)).CalcDuration
       then WritePoint(AllVariables(O2Duration),OtherOutput,WaterCol,False,False,0,O2Conc);

     If Diagenesis_Included then
       Begin {write diagenesis fluxes in mg/m2 d}
         WritePoint(AllVariables(TSP_Diag),OtherOutput,WaterCol,False,False,0,Diag_track[TSP_Diag,0]);
         WritePoint(AllVariables(NO3_Diag),OtherOutput,WaterCol,False,False,0,Diag_track[NO3_Diag,0]);
         WritePoint(AllVariables(NH3_Diag),OtherOutput,WaterCol,False,False,0,Diag_track[NH3_Diag,0]);
         WritePoint(AllVariables(POP_Dep),OtherOutput,WaterCol,False,False,0,Diag_track[POP_Dep,0]);
         WritePoint(AllVariables(POC_Dep),OtherOutput,WaterCol,False,False,0,Diag_track[POC_Dep,0]);
         WritePoint(AllVariables(PON_Dep),OtherOutput,WaterCol,False,False,0,Diag_track[PON_Dep,0]);

         WritePoint(AllVariables(PFluxDiagenesis),OtherOutput,WaterCol,False,False,0,MBLayerArray[phosphate].PFluxD[0]);
       End;

     WritePoint(AllVariables(CaCO3p),OtherOutput,WaterCol,False,False,0,CalcitePcpt);

     WritePoint(AllVariables(GPP_Out),OtherOutput,WaterCol,False,False,0,GPP[0]);
     WritePoint(AllVariables(CommResp_Out),OtherOutput,WaterCol,False,False,0,TOTResp[0]);
     If TotResp[0] < tiny
       then WritePoint(AllVariables(PtoR_Out),OtherOutput,WaterCol,False,False,0,0)
       else WritePoint(AllVariables(PtoR_Out),OtherOutput,WaterCol,False,False,0,GPP[0]/TotResp[0]);

   End; {WRITE_NUTRIENT_VARIABLES}

   {---------------------------------------------------------------------------------------------}
   Function TSSAdj(Inorg:Double): Double;  {Add algae and detritus to inorganic "TSS" for output}
   Var AllSed: Double;
       AlgLoop, DetrLoop: AllVariables;
       PPhyto: TPlant;
   Begin
     AllSed := Inorg;
               {mg/L}
     For AlgLoop := FirstAlgae to LastAlgae do
       Begin
         PPhyto := GetStatepointer(AlgLoop,StV,WaterCol);
         If PPhyto <> nil then
           If PPhyto.IsPhytoplankton then {1/7/2005}
             AllSed := AllSed + GetState(AlgLoop,StV,WaterCol);
       End;                                  {mg/L}

      For DetrLoop := SuspRefrDetr to SuspLabDetr do
        If GetState(DetrLoop,StV,WaterCol)>0 then
          AllSed := AllSed + GetState(DetrLoop,StV,WaterCol);
                                          {mg/L}
      TSSAdj := AllSed;
   End;
   {---------------------------------------------------------------------------------------------}

   Procedure WriteDataPoint(P: TStateVariable);
   {---------------------------------------------------------------------------}
   {    Having been passed a state variable, writes the appropriate output     }
   {---------------------------------------------------------------------------}
   Var PntIndx, i: Integer;
       PR: TRate;
       NewDPoint: TDataPoint;
       ThisRate, ValOut: Double;
   Begin
      If not P.PTrackResults^ then exit;
      If OutputText(P.NState,P.SVType,P.Layer,'',False,False,0)='Undisplayed' then exit;

      If ((P.NState=TSS) and (not TSandSiltClay(P).TSS_Solids)) then WritePoint(P.NState,P.SVType,P.Layer,False,False,0,TSSAdj(GetState(TSS,StV,WaterCol)))
        else If P.NState=Volume        {Write DataPoint for State Variable Itself}
          then WritePoint(Volume,StV,WaterCol,False,False,0, SegVol)
          else Begin
                  ValOut := P.state;
                  If P.IsAlgae and (P.SVType = StV) and (P.Layer = WaterCol) then
                   If (TPlant(P).PAlgalRec^.SurfaceFloating) and (StaticZMean > 3) {m} then
                     ValOut := P.State * StaticZMean / 3;   // Output blue-greens in the top 3 meters as most representitive of sampling techniques.
                                                {m}    {m}
                  WritePoint(P.NState,P.SVType,P.Layer,False,False,0, ValOut);
               End;

     If (P.NState=Light) and (P.State>480) then
       Begin
         P.State := P.State + 0;
       End;

      {WRITE Part Per Billion (PPB) Output}
      If PSavePPB^ then
        Begin
          If (P.SVType in [FirstOrgTxTyp..LastOrgTxTyp]) and (P.NState<>PoreWater) then
             WritePoint(P.NState,P.SVType,P.Layer,True,False,0, TToxics(P).ppb);
        End;

      {WRITE Rates Output}
      If (SetupRec.SaveBRates) and (P.PShowRates^) and (PRateInfo.WriteToMemory) then
       If P.RateColl <> nil then
        With P do
         For i := 1 to RateColl.Count-1 do
          Begin
            PR := RateColl.At(i);

            ThisRate := PR.GetRate;
            If Pos('_LIM',PR.Name)<=0 then
              Begin
                if P.State < Tiny then ThisRate := 0
                                  else ThisRate := (ThisRate / P.State) * 100;
              End;

            PntIndx := Resultlist.Datapoints.Count;
            NewDPoint:=TDataPoint.Init(NState,SVType,Layer,ThisRate,False,False,True,0,i,Results[WriteSeg],Self,FALSE,PntIndx,PR.Name);
            Resultlist.Datapoints.Insert(NewDPoint);
          End;

   end;  {Write DataPoint}

   {---------------------------------------------------------------------------------------------}

   Procedure WritePointsToTResults;
   {---------------------------------------------------------------------------}
   { Write all points to the TResults Structure using the above two procedures,}
   {            also write other types of output for this time-step            }
   {---------------------------------------------------------------------------}

   {---------------------------------------------------------------------------}
   Function PeriChlor_Conv(AFDW: Double): Double;  {double curve orig. coded RAP & JSC 11-04-05}
   Begin
     PeriChlor_Conv := 5; {Change to constant factor 11-16-07}
   End;
   {---------------------------------------------------------------------------}

Const  BryoChlor_Conv = 8.91;       {Stream Bryophyte Group, 1999, p. 160}
       O2Photo = 1.6;  {see Bowie et al., 1985 for numerous references}
   Var i, SedIndex          : Integer;
       ToxLoop              : AllVariables;
       Loop   : StateVariables;
       TypeLoop             : T_SVType;
       LayerLoop            : T_SVLayer;
       ChlorophyllA         : Double;
       ChlorALoop, FishLoop, DetrLoop : StateVariables;
       BirdPPB, BirdPPBMaxClear, Pref, MossChlor :  Double;
       Outname:                  string;
       AlgLoop, InvtLoop      : StateVariables;
       pp                     : TPreference;
       LivingAlg, THalfL, PeriChlor, PeriBiomass,
       FishConcSum, FishPPB, TLossMass,
       FishToxSum, SumTox, SumToxMass,
       ToxDissWater,ToxSuspDetr, ToxAnimals,
       ToxPlants, ToxMassSed,
       SumHg, SumHgMass, HgHalfL,
       SumRates, CheckZero    : Double;
       DissolvedTox, Lipid    : Double;
       PWVolumeInL            : Double;
       Index                  : Integer;
       PVol                   : TVolume;
       PPore                  : TPoreWater;
       PTox                   : TToxics;
       PLnk                   : TSegmentLink;
       Washin, UpStWashout, WaterFlow: Double;
       PPl                    : TPlant;
       ToxTyp                 : T_SVType;
       FoundPhyto, ItExists   : Boolean;
       SedToxSum, SedConcSum,
       ResTime, SedToxPPB     : Double;
       BlGrBio, PhytBiomass, TotPlantBiomass    : Double;

           {-------------------------------------------------------------------}
           Procedure Calculate_Half_Life(Tox: T_SVType);
           Var WaterLossRate, SedLossRate: Double;
           Begin
             With ToxLossArray[Tox] do
               Begin
                 If ToxDissWater<tiny
                   then WaterLossRate := 0
                   else WaterLossRate := (DissHydr[0]   + DissPhot[0]  + DissMicrob[0]
                                          + DissWash[0] + DissVolat[0] + DissSorp[0]  )  / ToxDissWater;
                 If ToxMassSed<tiny
                   then SedLossRate := 0
                   else SedLossRate   := (SedMicrob[0] + SedDesorp[0]+ SedHydr[0]+ SedScour[0])  / ToxMassSed;
                           {1/d}         {             all kg/d                               }       {kg}

               End;

             If (ToxDissWater<Tiny) or (WaterLossRate<Tiny)
              then
               Begin
                 WritePoint(AllVariables(DT50Water),AssocToxTyp(ToxLoop),WaterCol,False,True,0, 0);
                 WritePoint(AllVariables(DT95Water),AssocToxTyp(ToxLoop),WaterCol,False,True,0, 0);
               End
              else
                Begin
                  WritePoint(AllVariables(DT50Water),AssocToxTyp(ToxLoop),WaterCol,False,True,0, 0.693 /WaterlossRate);
                  WritePoint(AllVariables(DT95Water),AssocToxTyp(ToxLoop),WaterCol,False,True,0, 2.996/WaterlossRate);
                End;

             If (ToxMassSed<Tiny) or (SedLossRate<Tiny)
              then
               Begin
                 WritePoint(AllVariables(DT50Sed),AssocToxTyp(ToxLoop),WaterCol,False,True,0, 0);
                 WritePoint(AllVariables(DT95Sed),AssocToxTyp(ToxLoop),WaterCol,False,True,0, 0);
               End
                 else
                  Begin
                    WritePoint(AllVariables(DT50Sed),AssocToxTyp(ToxLoop),WaterCol,False,True,0,   0.693 /SedLossRate);
                    WritePoint(AllVariables(DT95Sed),AssocToxTyp(ToxLoop),WaterCol,False,True,0,   2.996/SedLossRate);
                  End;
           End;

           {-------------------------------------------------------------------}

   Var ZSecchi: Double;
       TO2: TO2Obj;
       FoundEPT,FoundChiro: Boolean;
       FoundE, FoundP, FoundT, FoundEunotia: Boolean;
       WetDry, ChiroBio,EPTBio,BInvtBio: Double;
       EBio, PBio, TBio, EunotiaBio: Double;
       BlGrPeriBio,DiatomPeriBio,GreenPeriBio: Double;
       DiatomBio, GreensBio, OtherBio: Double;
       FishBio,PlgInvtBio: Double;
       IsBenthos: Boolean;

       OligochaeteBio, AmphipodBio,GastropodBio,BivalveBio: Double;
       FoundAmphi, FoundGastro, FoundBivalve, FoundOligo: Boolean;
       PA,PA2: TAnimal;
       PP2: TPlant;
       TNIP: T_N_Internal_Plant;
   Begin {WritePointstoTResults}
      WriteSeg:=VSeg;
      If WriteTwice and (NumWrites=2) then WriteSeg:=Hypolimnion;
      If LinkedMode then WriteSeg:=Epilimnion;

      WriteMinMaxFlux := ((PModelTimeStep^ = TSHOURLY) and (SaveStep>1/24)) or
                         ((not (PModelTimeStep^ = TSHourly)) and (SaveStep >1));

      {Create new result pointer for new DataPoint}
      ResultList := Tresults.Init(TimeIndex,False);

      {Write all state variables to results structure}
      For i:=0 to Count -1 do
            WriteDataPoint(At(i));

      {Calculate Chlorophyll A, ug/L}
      ChlorophyllA := 0;
      BlGrBio := 0;
      DiatomBio := 0;
      GreensBio := 0;
      OtherBio  := 0;

      PhytBiomass  := 0;
      For ChlorALoop := FirstAlgae to LastAlgae do
       If GetStatePointer(ChlorALoop,StV,WaterCol)<>nil then
        If TPlant(GetStatePointer(ChlorALoop,StV,WaterCol)).PAlgalRec.PlantType='Phytoplankton' then
         Begin
          If ChlorALoop in [FirstBlGreen..LastBlGreen]
           then ChlorophyllA := ChlorophyllA + (GetState(ChlorALoop,StV,WaterCol)*(0.526/45))*1000
           else ChlorophyllA := ChlorophyllA + (GetState(ChlorALoop,StV,WaterCol)*(0.526/28))*1000;

          PhytBiomass := PhytBiomass + GetState(ChlorALoop,StV,WaterCol);

          If ChlorALoop in [FirstBlGreen..LastBlGreen] then BlGrBio := BlGrBio + GetState(ChlorALoop,StV,WaterCol);
          If ChlorALoop in [FirstDiatom..LastDiatom] then DiatomBio := DiatomBio + GetState(ChlorALoop,StV,WaterCol);
          If ChlorALoop in [FirstGreens..LastGreens] then GreensBio := GreensBio + GetState(ChlorALoop,StV,WaterCol);
          If ChlorALoop in [OtherAlg1..OtherAlg2] then OtherBio := OtherBio + GetState(ChlorALoop,StV,WaterCol);
         End;
      WritePoint(AllVariables(chla),OtherOutput,WaterCol,False,False,0, ChlorophyllA);


      If PhytBiomass > 0
        then
          Begin
            WritePoint(AllVariables(PctBlGrPhyto),OtherOutput,WaterCol,False,False,0, BlGrBio/PhytBiomass * 100); {9-11-2006}
            WritePoint(AllVariables(PctDiatomsPhyto),OtherOutput,WaterCol,False,False,0, DiatomBio/PhytBiomass * 100); {9-30-2010}
            WritePoint(AllVariables(PctGreensPhyto),OtherOutput,WaterCol,False,False,0, GreensBio/PhytBiomass * 100); {9-30-2010}
            WritePoint(AllVariables(PctOtherPhyto),OtherOutput,WaterCol,False,False,0, OtherBio/PhytBiomass * 100); {9-30-2010}
          End
        else
          Begin
            WritePoint(AllVariables(PctBlGrPhyto),OtherOutput,WaterCol,False,False,0, 0);
            WritePoint(AllVariables(PctDiatomsPhyto),OtherOutput,WaterCol,False,False,0, 0);
            WritePoint(AllVariables(PctGreensPhyto),OtherOutput,WaterCol,False,False,0, 0);
            WritePoint(AllVariables(PctOtherPhyto),OtherOutput,WaterCol,False,False,0, 0);

          End;

      WritePoint(AllVariables(Phyto_Biomass),OtherOutput,WaterCol,False,False,0,PhytBiomass);

     If SetupRec.Internal_Nutrients then
      For AlgLoop := FirstPlant to LastPlant do   //2/24/2014 write internal nutrients if relevant
       If GetStatePointer(AlgLoop,Nintrnl,Watercol) <> nil then
         Begin
           Ppl := GetStatePointer(AlgLoop,StV,watercol);
           WritePoint(AlgLoop,OtherOutput,WaterCol,False,False,6, PPL.N_2_Org);
           WritePoint(AlgLoop,OtherOutput,WaterCol,False,False,7, PPL.P_2_Org);
         End;

     MossChlor := 0;
     ItExists := False;
     For AlgLoop := FirstMacro to LastMacro do          {RAP & JSC 11/05/02}
        Begin
          PPl := GetStatePointer(AlgLoop,StV,watercol);
          If PPl<>nil then
           If PPL.PAlgalRec.PlantType='Bryophytes' then
             Begin
               ItExists := True;
               MossChlor := MossChlor + PPl.State* SegVol /SurfaceArea * BryoChlor_Conv ;
                            {mg/m2}      {g/m3}      {m3}       {m2}      {g/m2 alg to mg/m2 chla}
             End;
        End;
     If ItExists then WritePoint(AllVariables(Moss_chla),OtherOutput,WaterCol,False,False,0,MossChlor);

     FoundEunotia:= False;
     EunotiaBio := 0;
     BlGrPeriBio := 0;
     DiatomPeriBio:= 0;
     GreenPeriBio:= 0;
     PeriBiomass := 0;
     ItExists := False;
      For AlgLoop := FirstAlgae to LastAlgae do
        Begin
          PPl := GetStatePointer(AlgLoop,StV,WaterCol);
          If PPl<>nil then
           If PPL.IsPeriphyton then
             Begin
               ItExists := True;
               PeriBiomass := PeriBiomass + PPl.State * SegVol /SurfaceArea;
                  {g/m2}         {g/m2}        {g/m3}     {m3}       {m2}

               If AlgLoop in [FirstDiatom..LastDiatom] then DiatomPeriBio := DiatomPeriBio + PPl.State * SegVol /SurfaceArea;
               If AlgLoop in [FirstBlGreen..LastBlGreen] then BlgrPeriBio := BlgrPeriBio + PPl.State * SegVol /SurfaceArea;
               If AlgLoop in [FirstGreens..LastGreens] then GreenPeriBio := GreenPeriBio + PPl.State * SegVol /SurfaceArea;
               If PPl.IsEunotia then Begin FoundEunotia := True; EunotiaBio := EunotiaBio + PPl.State * SegVol /SurfaceArea; End;
             End;
        End;

      PeriChlor := PeriBiomass * PeriChlor_Conv(PeriBiomass);
       {mg/m2}       {g/m2}      {g/m2 peri to mg/m2 chla}

      If ItExists then
        Begin
          WritePoint(AllVariables(Peri_chla),OtherOutput,WaterCol,False,False,0,PeriChlor);
          WritePoint(AllVariables(Peri_Biomass),OtherOutput,WaterCol,False,False,0,PeriBiomass);
          If (PeriBiomass < tiny)
            then
              Begin
                WritePoint(AllVariables(PctBlGrPeri),OtherOutput,WaterCol,False,False,0,0);
                WritePoint(AllVariables(PctDiatomsPeri),OtherOutput,WaterCol,False,False,0,0);
                WritePoint(AllVariables(PctGreensPeri ),OtherOutput,WaterCol,False,False,0,0);
                If FoundEunotia then WritePoint(AllVariables(PctEunotia),OtherOutput,WaterCol,False,False,0,0);
              End
            else
              Begin
                WritePoint(AllVariables(PctBlGrPeri   ),OtherOutput,WaterCol,False,False,0,BlGrPeriBio/PeriBiomass*100);
                WritePoint(AllVariables(PctDiatomsPeri),OtherOutput,WaterCol,False,False,0,DiatomPeriBio/PeriBiomass*100);
                WritePoint(AllVariables(PctGreensPeri ),OtherOutput,WaterCol,False,False,0,GreenPeriBio/PeriBiomass*100);
                If FoundEunotia then WritePoint(AllVariables(PctEunotia),OtherOutput,WaterCol,False,False,0,EunotiaBio/PeriBiomass*100);
              End;
        End;

      WritePoint(AllVariables(BenthicChla),OtherOutput,WaterCol,False,False,0,PeriChlor + MossChlor);
      WritePoint(AllVariables(FracLitOut),OtherOutput,WaterCol,False,False,0,Location.FracLittoral(ZEuphotic,Volume_Last_Step));

      {Calculate Secchi Depth}
      ZSecchi := Min( Max(Location.Locale.ZMax,DynamicZMean) ,1.2/extinct(False,False,False,False,False));  {Changed from 1.9 3-3-08}
      WritePoint(AllVariables(Secchi),OtherOutput,WaterCol,False,False,0,ZSecchi );
      WritePoint(AllVariables(DynZMeanOut),OtherOutput,WaterCol,False,False,0, DynamicZMean);

      For ToxLoop := FirstOrgTox to LastOrgTox do
       If (GetStatePointer(ToxLoop,StV,WaterCol)<>nil) then
        Begin
          {calculate total toxicant}
          SumTox     := 0.0; {ug/L}
          SumToxMass  := 0.0;  {kg}
          ToxDissWater := 0.0; {kg}
          ToxSuspDetr  := 0.0; {kg}
          ToxAnimals  := 0.0; {kg}
          ToxPlants   := 0.0;  {kg}
          ToxMassSed  := 0.0;  {kg}

          CheckZero := GetState(ToxLoop,StV,WaterCol);
          If CheckZero > Tiny then
            Begin
              SumTox := CheckZero;
              SumToxMass := CheckZero * SegVol * 1000.0 * 1e-9;
                 {kg}        {ug/L}       {m3}     {L/m3}  {kg/ug}

              ToxDissWater := SumToxMass {kg};
            End;

          ToxTyp := AssocToxTyp(ToxLoop);
          For LayerLoop := WaterCol to LowestLayer do
            Begin
              PPore := GetStatePointer(PoreWater,StV,LayerLoop);
              IF PPore <> nil then PWVolumeInL := PPore.VolumeInL
                              else PWVolumeInL := 0;

              For Loop:= PoreWater to LastAnimal do
                If GetStatePointer(Loop,ToxTyp,LayerLoop) <> nil then
                  Begin
                    CheckZero := GetState(Loop,ToxTyp,LayerLoop);
                    If CheckZero > 0 then
                      If LayerLoop=WaterCol
                        then
                          Begin
                           If loop in [BuriedRefrDetr..BuriedLabileDetr]
                            then  {buried}
                              Begin
                                ToxMassSed := ToxMassSed + CheckZero * SedLayerArea * 1e-9;
                                SumToxMass := SumToxMass + CheckZero * SedLayerArea * 1e-9;
                              End  {kg}                     {ug/m2}        {m2}      {kg/ug}
                            else
                              begin  {not buried, in water col or active layer}
                                SumTox := SumTox + CheckZero;
                                {ug/L}    {ug/L}    {ug/L}
                                SumToxMass := SumToxMass + CheckZero * SegVol * 1000.0 * 1e-9;
                                   {kg}                     {ug/L}      {m3}    {L/m3}  {kg/ug}

                                If Loop in [FirstAnimal..LastAnimal] then
                                  ToxAnimals := ToxAnimals + CheckZero * SegVol * 1000.0 * 1e-9;
                                If Loop in [FirstPlant..LastPlant] then
                                  ToxPlants := ToxPlants + CheckZero * SegVol * 1000.0 * 1e-9;
                                If Loop in [DissRefrDetr,DissLabDetr,SuspRefrDetr,SuspLabDetr] then
                                  ToxSuspDetr := ToxSuspDetr + CheckZero * SegVol * 1000.0 * 1e-9;
                                        {kg}                    {ug/L}      {m3}    {L/m3}   {kg/ug}
                                If Loop in [SedmRefrDetr,SedmLabDetr] then
                                  ToxMassSed := ToxMassSed + CheckZero * SegVol * 1000.0 * 1e-9;
                                        {kg}                   {ug/L}      {m3}     {L/m3}  {kg/ug}
                              end
                          End
                        else {in sediment layers}
                          begin
                            If Loop in [PoreWater..LaDomPore]
                                    then CheckZero := CheckZero * PWVolumeInL * 1e-9
                                            {kg}      {ug/L pw}      {L pw }   {kg/ug}
                                    else CheckZero := CheckZero * SedLayerArea * 1e-9;
                                            {kg}       {ug/m2}        {m2}      {kg/ug}
                            ToxMassSed := ToxMassSed + CheckZero;
                            SumToxMass := SumToxMass + CheckZero;
                          end;

                  End;
            End;

           Calculate_Half_Life(ToxTyp);

           WritePoint(AllVariables(TotalTox),ToxTyp,WaterCol,False,True,0,SumTox);
           WritePoint(AllVariables(TotalToxMass),ToxTyp,WaterCol,False,True,0,SumToxMass);
           WritePoint(AllVariables(NDissWater),ToxTyp,WaterCol,False,True,0,ToxDissWater);
           WritePoint(AllVariables(NDetr),ToxTyp,WaterCol,False,True,0,ToxSuspDetr);
           WritePoint(AllVariables(NAnimals),ToxTyp,WaterCol,False,True,0,ToxAnimals);
           WritePoint(AllVariables(NPlants),ToxTyp,WaterCol,False,True,0,ToxPlants);
           WritePoint(AllVariables(NSediment),ToxTyp,WaterCol,False,True,0,ToxMassSed);

           WritePoint(AllVariables(NonDissocOut),ToxTyp,WaterCol,False,True,0,TToxics(GetStatePointer(ToxLoop,StV,WaterCol)).NonDissoc);
           WritePoint(AllVariables(ToxLoading),ToxTyp,WaterCol,False,True,0,TToxics(GetStatePointer(ToxLoop,StV,WaterCol)).Loading);

           SedToxSum := GetState(SedmRefrDetr,AssocToxTyp(ToxLoop),WaterCol) +
                        GetState(SedmLabDetr,AssocToxTyp(ToxLoop),WaterCol);
           SedConcSum := GetState(SedmRefrDetr,StV,WaterCol) +
                         GetState(SedmLabDetr,StV,WaterCol);
           If SedConcSum<Tiny
             then SedToxPPB := 0
             else SedToxPPB :=  SedToxSum / SedConcSum * 1e6 ;
                  {ug/kg dry}    {ug/L}    {mg dry/L}  {mg/kg}
           WritePoint(AllVariables(TOrgSedPPB),AssocToxTyp(ToxLoop),WaterCol,False,True,0,SedToxPPB);

           {** GULL MODEL ** Calculate Bird Concentrations using BCFs}
           BirdPPB := 0;
           If (BirdPrey<>nil) then
            If (BirdPrey.Count>0) then
             Begin
               For Loop := SedmRefrDetr to LastBiota  do
                If GetStatePointer(Loop,Stv,WaterCol)<>nil then
                 Begin
                   Pref := 0;
                   if (BirdPrey.Count>0)
                     then With BirdPrey do For i:=0 to count-1 do
                        Begin
                          pp := At(i);
                          If (pp.nstate=loop) then Pref := PP.Preference;
                        End;
                   If Pref>0 then
                      BirdPPB := BirdPPB + (Pref * GullBMF[ToxTyp] * GetPPB(Loop,ToxTyp,WaterCol));

                 End;
               BirdPPB := BirdPPB / 5; {wet to dry}

               BirdPPBMaxClear := 0;
               If (TimeLastGullConc > 0) and (BirdPPB < GullConcLastStep[ToxTyp])
                    then BirdPPBMaxClear := GullConcLastStep[ToxTyp] - GullConcLastStep[ToxTyp] * (GullClear[ToxTyp]) * (TPresent - TimeLastGullConc);
                                                 {ppb}                         {ppb}                    {1/d}                {d}           {d}

               If BirdPPB < BirdPPBMaxClear then BirdPPB := BirdPPBMaxClear ;
               GullConcLastStep[ToxTyp] := BirdPPB;

               WritePoint(AllVariables(BirdConc),ToxTyp,WaterCol,False,True,0,BirdPPB);
             End;

           With ToxLossArray[ToxTyp] do
             Begin
               TLossMass := TotalToxLoss[0]+SumToxMass;
               WritePoint(AllVariables(TotTLoss),ToxTyp,WaterCol,False,True,0,TotalToxLoss[0]);
               WritePoint(AllVariables(TLossandMass),ToxTyp,WaterCol,False,True,0,TLossMass);
               WritePoint(AllVariables(TotalTWash),ToxTyp,WaterCol,False,True,0,TotalWashout[0]);
               WritePoint(AllVariables(TWashH2O),ToxTyp,WaterCol,False,True,0,WashoutH2O[0]);
               WritePoint(AllVariables(TWashAnim),ToxTyp,WaterCol,False,True,0,WashoutAnim[0]);
               WritePoint(AllVariables(TWashDetr),ToxTyp,WaterCol,False,True,0,WashoutDetr[0]);
               WritePoint(AllVariables(TWashPlant),ToxTyp,WaterCol,False,True,0,WashoutPlant[0]);
               WritePoint(AllVariables(TWashSed),ToxTyp,WaterCol,False,True,0,WashoutSedm[0]);
               WritePoint(AllVariables(THydrol),ToxTyp,WaterCol,False,True,0,Hydrolys[0]);
               WritePoint(AllVariables(TPhotol),ToxTyp,WaterCol,False,True,0,Photolys[0]);
               WritePoint(AllVariables(TVolatil),ToxTyp,WaterCol,False,True,0,Volatiliz[0]);
               WritePoint(AllVariables(TMicrobMet),ToxTyp,WaterCol,False,True,0,MicrobMet[0]);
               WritePoint(AllVariables(TBioTrans),ToxTyp,WaterCol,False,True,0,BioTransf[0]);
               WritePoint(AllVariables(TEmergeI),ToxTyp,WaterCol,False,True,0,EmergeIns[0]);
               WritePoint(AllVariables(TFishing),ToxTyp,WaterCol,False,True,0,FishingLoss[0]);
               WritePoint(AllVariables(TBuryOOS),ToxTyp,WaterCol,False,True,0,OOSBury[0]);
             End;

           With ToxLoadArray[ToxTyp] do
             Begin
               WritePoint(AllVariables(TTotOOSLoad),ToxTyp,WaterCol,False,True,0,TotOOSLoad[0]);
               WritePoint(AllVariables(TLoadH2O),ToxTyp,WaterCol,False,True,0,ToxLoadH2O[0]);
               WritePoint(AllVariables(TLoadSed),ToxTyp,WaterCol,False,True,0,ToxLoadSed[0]);
               WritePoint(AllVariables(TLoadDetr),ToxTyp,WaterCol,False,True,0,ToxLoadDetr[0]);
               WritePoint(AllVariables(TLoadBiota),ToxTyp,WaterCol,False,True,0,ToxLoadBiota[0]);
               WritePoint(AllVariables(TMBTest),ToxTyp,WaterCol,False,True,0,TLossMass-TotOOSLoad[0]);
             End;
        END;

      Index:=GetIndex(Silt,StV,WaterCol);
      If Index>-1 then
        begin
          WritePoint(AllVariables(BedDepth),OtherOutput,WaterCol,False,False,0,Sed_Data.BedDepth);
          WritePoint(AllVariables(Tau),OtherOutput,WaterCol,False,False,0,Sed_Data.Tau);
        end;        

      PVol := GetStatePointer(Volume,StV,WaterCol);

      {If LinkedMode then WritePoint(AllVariables(InflowWater),OtherOutput,WaterCol,False,False,False,PVol.InflowLoad)
                     else } WritePoint(AllVariables(InflowWater),OtherOutput,WaterCol,False,False,0,Location.Morph.InflowH2O[VSeg]);

      WritePoint(AllVariables(VelocityOut),OtherOutput,WaterCol,False,False,0,Velocity(0,0,False));
      If Location.SiteType = Stream then
        Begin
          WritePoint(AllVariables(VelRiff),OtherOutput,WaterCol,False,False,0,Velocity(100,0,False));
          WritePoint(AllVariables(VelPool),OtherOutput,WaterCol,False,False,0,Velocity(0,100,False));
        End;  

      WritePoint(AllVariables(DischWater),OtherOutput,WaterCol,False,False,0,Location.Discharge[Vseg]);

      With Location do
        WritePoint(AllVariables(SegThick),OtherOutput,WaterCol,False,False,0,MeanThick[VSeg]);

      PVol := GetStatePointer(Volume,StV,WaterCol);
      If EstuarySegment then WritePoint(AllVariables(TidalAmp),OtherOutput,WaterCol,False,False,0,PVol.TidalAmplitude(TimeIndex));

      If PSaveBAFs^ then    // BAF CALCULATIONS HERE
       For ToxLoop := FirstOrgTox to LastOrgTox do
        For Loop := FirstBiota to LastBiota do
         If GetStatePointer(Loop,AssocToxTyp(ToxLoop),WaterCol) <> nil then
          Begin
            DissolvedTox := GetState(ToxLoop,StV,WaterCol);

            {If user specifies, include tox in dissolved detritus in BAF calculations}
            If SetupRec.UseComplexedInBAF then
              For DetrLoop := DissRefrDetr to DissLabDetr do
                If GetState(DissRefrDetr,AssocToxTyp(ToxLoop),WaterCol) > tiny then
                   DissolvedTox := DissolvedTox + GetState(DetrLoop,AssocToxTyp(ToxLoop),WaterCol);

            If Loop in [FirstPlant..LastPlant]
              then
                Begin
                  PP2 := GetStatePointer(Loop,StV,WaterCol);
                  Lipid := PP2.PAlgalRec^.PlantFracLipid;   {wet}
                  WetDry := PP2.PAlgalRec^.Wet2Dry;
                End
              else
                Begin
                  PA2 := GetStatePointer(Loop,StV,WaterCol);
                  Lipid := PA2.PAnimalData^.FishFracLipid;  {wet}
                  WetDry := PA2.PAnimalData^.Wet2Dry;
                End;

            PTox := GetStatePointer(Loop,AssocToxTyp(ToxLoop),WaterCol);

            If (DissolvedTox < tiny) or (PTox.PPB<tiny) or (Lipid<tiny)
               then WritePoint(Loop,AssocToxTyp(ToxLoop),WaterCol,False,False,1 {BAFVar 1 Lipid},0)
               else WritePoint(Loop,AssocToxTyp(ToxLoop),WaterCol,False,False,1,log10((PTox.PPB / DissolvedTox )/ Lipid));
                                                                                         {ug/kg wet}   {ug/L}      {g / g wet}

            If (DissolvedTox < tiny) or (PTox.PPB<tiny) or (Lipid<tiny)
               then WritePoint(Loop,AssocToxTyp(ToxLoop),WaterCol,False,False,2 {BAFVar 1 Lipid},0)
               else WritePoint(Loop,AssocToxTyp(ToxLoop),WaterCol,False,False,2,log10((PTox.PPB / DissolvedTox )));
                                                                                       {ug/kg wet}   {ug/L}
          End;   {write BAF output}

       {write K1,K2,BCF output}
       For ToxLoop := FirstOrgTox to LastOrgTox do
        For Loop := FirstAnimal to LastAnimal do
         If GetStatePointer(Loop,AssocToxTyp(ToxLoop),WaterCol) <> nil then
          Begin
           PA2 := GetStatePointer(Loop,StV,WaterCol);
           WritePoint(Loop,AssocToxTyp(ToxLoop),WaterCol,False,False,3 {BAFVar 3 K1},PA2.DerivedK1[AssocToxTyp(ToxLoop)]);
           WritePoint(Loop,AssocToxTyp(ToxLoop),WaterCol,False,False,4 {BAFVar 4 K2},PA2.DerivedK2[AssocToxTyp(ToxLoop)]);
           WritePoint(Loop,AssocToxTyp(ToxLoop),WaterCol,False,False,5 {BAFVar 5 BCF},PA2.OrgToxBCF[AssocToxTyp(ToxLoop)]);
          End;

      {Avg. Multi Fish Data if present}
      If GetIndex(Fish1,StV,WaterCol) > -1 then
        Begin
          FishConcSum :=0;
          For FishLoop := Fish1 to Fish15 do
            If Getstate(FishLoop,StV,WaterCol) > -1 then
               FishConcSum := FishConcSum + GetState(FishLoop,StV,WaterCol);
          WritePoint(AllVariables(MultiFishConc),OtherOutput,WaterCol,False,False,0,FishConcSum);

          For ToxLoop := FirstOrgTox to LastOrgTox do
            If GetState(ToxLoop,StV,WaterCol) > -1 then
              Begin
                FishToxSum := 0;
                For FishLoop := Fish1 to Fish15 do
                  If GetState(FishLoop,AssocToxTyp(ToxLoop),WaterCol) > -1 then
                    FishToxSum := FishToxSum + GetState(FishLoop,AssocToxTyp(ToxLoop),WaterCol);
                      {ug/L}                            {ug/L}

                If FishConcSum < tiny
                   then FishPPB := 0
                   else FishPPB := FishToxSum / FishConcSum * 1e6    / 5.0;
                        {ug/kg}     {ug/L}       {mg/L}     {mg/kg}   {wet to dry}

                WritePoint(AllVariables(MultiFishTox),AssocToxTyp(ToxLoop),WaterCol,False,True,0, FishToxSum);
                WritePoint(AllVariables(MultiFishPPB),AssocToxTyp(ToxLoop),WaterCol,False,True,0, FishPPB);
              End;
        End;

      {Write Data about sed Layers}
      For SedIndex := 1 to SedLayers do
        Begin
          WritePoint(AllVariables(BedDepth),OtherOutput,T_SVLayer(SedIndex),False,False,0,SedData[SedIndex].DynBedDepth);
          WritePoint(AllVariables(BedDnsty),OtherOutput,T_SVLayer(SedIndex),False,False,0,SedData[SedIndex].BedDensity/1e6);
          WritePoint(AllVariables(FracWatr),OtherOutput,T_SVLayer(SedIndex),False,False,0,SedData[SedIndex].FracWater);
          WritePoint(AllVariables(BedVlm),OtherOutput,T_SVLayer(SedIndex),False,False,0,SedData[SedIndex].BedVolume);
        End;

      If SedLayers > 0 then
          WritePoint(AllVariables(DeltaBedHeight),OtherOutput,WaterCol,False,False,0,BaseTopDepth+SedData[1].DynBedDepth);
     Results[WriteSeg].Insert(ResultList);

     WRITE_NUTRIENT_VARIABLES;

     FoundPhyto := False;
     AlgLoop := Pred(FirstAlgae);
     Repeat
       Inc(AlgLoop);
       If GetState(AlgLoop,StV,WaterCol)>-1 then
         Begin
           PPl := GetStatePointer(AlgLoop,StV,WaterCol);
           If PPl.PAlgalRec.PlantType='Phytoplankton' then
             Begin
               FoundPhyto := True;
               WritePoint(AllVariables(PhytoResTime),OtherOutput,WaterCol,False,False,0,PPl.ResidenceTime);
             End;
         End;
     Until FoundPhyto or (AlgLoop=LastAlgae);

     FoundChiro := False; FoundOligo := False;
     FoundAmphi:= False;  FoundGastro:= False;  FoundBivalve:= False;
     FoundEPT := False;   {don't write this output if no EPT in simulation, or benthos not characterized}
     FoundE := False; FoundP:= False; FoundT:= False;  {same idea as foundEPT}
     ChiroBio := 0;  FishBio := 0;
     AmphipodBio:= 0; GastropodBio:= 0; BivalveBio:= 0;
     EPTBio := 0; EBio := 0; PBio := 0; TBio := 0; EunotiaBio := 0;
     BInvtBio := 0; PlgInvtBio := 0;
     For InvtLoop := FirstInvert to LastInvert do
       Begin
         PA := GetStatePointer(InvtLoop,StV,WaterCol);
         If PA<>nil then
          If (PA.PAnimalData^.Animal_Type='Benthic Invert.') or
             (PA.PAnimalData^.Animal_Type='Benthic Insect') then
           Begin
             If (PA.PAnimalData.BenthicDesignation = 'Mayfly') or
                (PA.PAnimalData.BenthicDesignation = 'Stonefly') or
                (PA.PAnimalData.BenthicDesignation = 'Caddisfly') then
                  Begin
                    FoundEPT := True;
                    EPTBio := EPTBio + PA.State; {mg/L}
                  End;

             If (PA.PAnimalData.BenthicDesignation = 'Mayfly') then // % Ephemeroptera (mayfly larvae)
                  Begin
                    FoundE := True;
                    EBio := EBio + PA.State; {mg/L}
                  End;
             If (PA.PAnimalData.BenthicDesignation = 'Stonefly') then // % Plecoptera (stonefly larvae)
                  Begin
                    FoundP := True;
                    PBio := PBio + PA.State; {mg/L}
                  End;
             If (PA.PAnimalData.BenthicDesignation = 'Caddisfly') then  //%Trichoptera (caddisfly larvae)
                  Begin
                    FoundT := True;
                    TBio := TBio + PA.State; {mg/L}
                  End;

             If (PA.PAnimalData.BenthicDesignation = 'Chironomid') then
                  Begin
                    FoundChiro := True;
                    ChiroBio := ChiroBio + PA.State; {mg/L}
                  End;

             If (PA.PAnimalData.BenthicDesignation = 'Amphipod') then
                  Begin
                    FoundAmphi := True;
                    AmphipodBio := AmphipodBio + PA.State; {mg/L}
                  End;

             If (PA.PAnimalData.BenthicDesignation = 'Oligochaete') then
                  Begin
                    FoundOligo := True;
                    OligochaeteBio := OligochaeteBio + PA.State; {mg/L}
                  End;

             If (PA.PAnimalData.BenthicDesignation = 'Other Bivalve') then
                  Begin
                    FoundBivalve := True;
                    BivalveBio := BivalveBio + PA.State; {mg/L}
                  End;

             If (PA.PAnimalData.BenthicDesignation = 'Gastropod') then
                  Begin
                    FoundGastro := True;
                    GastropodBio := GastropodBio + PA.State; {mg/L}
                  End;

             If PA.IsBenthos and (PA.PAnimalData.BenthicDesignation <> 'Mussel') then   //exclude mussel due to size / tendency to exclude from samples
               BInvtBio := BInvtBio + PA.State;
           End
         else // Pelagic Invert.
           PlgInvtBio := PlgInvtBio + PA.State; {mg/L}
       End;

     For FishLoop := FirstFish to LastFish do
       Begin
         PA := GetStatePointer(FishLoop,StV,WaterCol);
         If PA<>nil then FishBio := FishBio + PA.State {mg/L}
       End;

     WritePoint(AllVariables(PlgInvt_Biomass),OtherOutput,WaterCol,False,False,0,PlgInvtBio);  {mg/L for pelagic}

     WritePoint(AllVariables(BInvt_Biomass),OtherOutput,WaterCol,False,False,0,   BInvtBio * SegVol / SurfaceArea);
     WritePoint(AllVariables(Fish_Biomass),OtherOutput,WaterCol,False,False,0,     FishBio * SegVol / SurfaceArea);
                                                                                    {g/m3}    {m3}       {m2}

     If BInvtBio < tiny then BInvtBio := 1; {avoid divide by zero, PctEPT and ChiroBio will be zero}

     If FoundEPT then WritePoint(AllVariables(PctEPT),OtherOutput,WaterCol,False,False,0,EPTBio / BInvtBio * 100);
     If FoundE then WritePoint(AllVariables(PctEphemeroptera ),OtherOutput,WaterCol,False,False,0,EBio / BInvtBio * 100);
     If FoundP then WritePoint(AllVariables(PctPlecoptera),OtherOutput,WaterCol,False,False,0,PBio / BInvtBio * 100);
     If FoundT then WritePoint(AllVariables(PctTrichoptera),OtherOutput,WaterCol,False,False,0,TBio / BInvtBio * 100);

     If FoundChiro then WritePoint(AllVariables(PctChiro),OtherOutput,WaterCol,False,False,0,ChiroBio / BInvtBio * 100);
     If FoundAmphi then WritePoint(AllVariables(PctAmphipods),OtherOutput,WaterCol,False,False,0,AmphipodBio / BInvtBio * 100);
     If FoundOligo then WritePoint(AllVariables(PctOligochaete),OtherOutput,WaterCol,False,False,0,OligochaeteBio / BInvtBio * 100);
     If FoundBivalve then WritePoint(AllVariables(PctBivalves),OtherOutput,WaterCol,False,False,0,BivalveBio / BInvtBio * 100);
     If FoundGastro then WritePoint(AllVariables(PctGastropods),OtherOutput,WaterCol,False,False,0,GastropodBio / BInvtBio * 100);

     If Location.Discharge[Vseg] > tiny
         then ResTime := SegVol  / Location.Discharge[Vseg]
               {days}    {cu m}    {cu m/ d}
         else ResTime := 99999;  {no discharge, set ResTime to an arbitrary high number}
     WritePoint(AllVariables(RetTime),OtherOutput,WaterCol,False,False,0,ResTime);

     If GetStatePointer(POC_G1,Stv,SedLayer2) <> nil
        then WritePoint(AllVariables(SOD_OUT),OtherOutput,WaterCol,False,False,0,SOD)
        else Begin
               TO2 := GetStatePointer(Oxygen,Stv,WaterCol);
               With Location.Remin do
                 SOD :=   ( TO2.SumDetrDecomp(StV,True) * O2Biomass ) * SegVol / SurfaceArea;
               {g O2 /m2}          {g OM /m3}            {g O2/ gOM}    {m3}         {m2}
               WritePoint(AllVariables(SOD_OUT),OtherOutput,WaterCol,False,False,0,SOD);
             End;

     WritePoint(AllVariables(InorgDep),OtherOutput,WaterCol,False,False,0,InorgSedDep(True)); {include sand}
     WritePoint(AllVariables(InorgSed),OtherOutput,WaterCol,False,False,0,InorgSedConc(False)); {not weighted avg.}
     WritePoint(AllVariables(TSS60Day),OtherOutput,WaterCol,False,False,0,InorgSed60Day(False)); {doesn't require 60-day}

     WritePoint(AllVariables(PctEmbedded),OtherOutput,WaterCol,False,False,0,PercentEmbedded);
     WritePoint(AllVariables(MeanVol),OtherOutput,WaterCol,False,False,0,MeanVolume);

     If GetStatePointer(TSS,StV,WaterCol) = nil
        then WritePoint(TSS,StV,WaterCol,False,False,0,TSSAdj(InorgSedConc(False)));

     If EstuarySegment then
       Begin
         WritePoint(AllVariables(SaltInflow),OtherOutput,WaterCol,False,False,0,PVol.SaltWaterInflow   );  {m3/d}
         WritePoint(AllVariables(FreshInflow),OtherOutput,WaterCol,False,False,0, PVol.ResidFlow  );  {m3/d}
         WritePoint(AllVariables(EstEntr),OtherOutput,WaterCol,False,False,0,  PVol.SaltWaterInflow );  {m3/d}
         WritePoint(AllVariables(EstUpperOut),OtherOutput,WaterCol,False,False,0, PVol.UpperOutflow );  {m3/d}
       End;

     TotPlantBiomass  := (PeriBiomass + (PhytBiomass * SegVol / SurfaceArea));
     {g /m2}               {g /m2}        {g / m3}     {m3}      {m2}
     If GPP[0] < tiny
       then WritePoint(AllVariables(BtoP_Out),OtherOutput,WaterCol,False,False,0, 0 )
       else WritePoint(AllVariables(BtoP_Out),OtherOutput,WaterCol,False,False,0,  TotPlantBiomass / ( GPP[0]    / O2Photo)  );
                                                                                      {g biomass /m2}    {g o2/m2 d} {o2/photo bio.}
   End; {WritePointsToTResults}
   {---------------------------------------------------------------------------------------------}
   Procedure UpdateDriverVars;
     {--------------------------------------------------------}
     { Ensure DriverVars are up-to-date for current timeindex }
     {--------------------------------------------------------}

   Var DriverLoop: AllVariables;
       PSV: TStateVariable;
   Begin
     For DriverLoop := Temperature to pH do
       Begin
         PSV := GetStatePointer(DriverLoop,StV,WaterCol);
         If PSV<> Nil then PSV.CalculateLoad(TimeIndex);
       End;

     PSV := GetStatePointer(TSS,StV,WaterCol);
     If PSV<> Nil then PSV.CalculateLoad(TimeIndex);
   End;
   {---------------------------------------------------------------------------------------------}

   {---------------------------------------------------------------------------}
   { The Main Procedure of WriteResults.  This Procedure fills in the below    }
   { variables and then calls WritePointsToTResults.  This call occurs once,   }
   { or twice if stratified and in single segment Mode.  Finally, a call to    }
   { post-process the results is performed, to clean up the results and        }
   { place them at the proper interval.                                        }
   {---------------------------------------------------------------------------}

Begin {WriteResults}

   UpdateDriverVars;

   Begin
      WriteTwice := (not Stratified) and (SetupRec.AlwaysWriteHypo) and (not LinkedMode);
      NumWrites:=0;
      REPEAT
        Inc(NumWrites);
        WritePointsToTResults;
        PostProcessResults(False);  {Trapezoidally integrate or linearly interpolate}
      UNTIL (NumWrites=2) or (Not WriteTwice);
   End;

  If (VSeg=Epilimnion) and (Results[Hypolimnion]<>nil) then
    If (Not WriteTwice) and (Results[Hypolimnion].Count > 0) then
    Begin
      WriteSeg := Hypolimnion;
      PostProcessResults(True);
    End;
{   Timer.StopTime(2); }

End;  {WriteResults}

{------------------------------------------------------------------------------------------------}
Procedure TStates.OverturnMBData;  {Add hypolimnion effects to epilimnion during overturn}
Var TypLoop: T_SVType;
    NSLoop:  AllVariables;
Begin
  GPP[0] := GPP[0] + HypoSegment.GPP[0];
  NPP[0] := NPP[0] + HypoSegment.NPP[0];
  TotResp[0] := TotResp[0] + HypoSegment.TotResp[0];

  For TypLoop := FirstOrgTxTyp to LastOrgTxTyp do
   Begin
    With ToxLossArray[TypLoop] do
      Begin
        TotalToxLoss [0] := TotalToxLoss[0] + HypoSegment.ToxLossArray[TypLoop].TotalToxLoss[0];
        TotalWashout [0] := TotalWashout[0] + HypoSegment.ToxLossArray[TypLoop].TotalWashout [0];
        WashoutH2O   [0] := WashoutH2O[0] +   HypoSegment.ToxLossArray[TypLoop].WashoutH2O   [0];
        WashoutAnim  [0] := WashoutAnim[0] +  HypoSegment.ToxLossArray[TypLoop].WashoutAnim  [0];
        WashoutDetr  [0] := WashoutDetr[0] +  HypoSegment.ToxLossArray[TypLoop].WashoutDetr  [0];
        WashoutPlant [0] := WashoutPlant[0] + HypoSegment.ToxLossArray[TypLoop].WashoutPlant [0];
        WashoutSedm  [0] := WashoutSedm[0] +  HypoSegment.ToxLossArray[TypLoop].WashoutSedm  [0];
        Hydrolys     [0] := Hydrolys[0] +     HypoSegment.ToxLossArray[TypLoop].Hydrolys     [0];
        Photolys     [0] := Photolys[0] +     HypoSegment.ToxLossArray[TypLoop].Photolys     [0];
        Volatiliz    [0] := Volatiliz[0] +    HypoSegment.ToxLossArray[TypLoop].Volatiliz    [0];
        MicrobMet    [0] := MicrobMet[0] +    HypoSegment.ToxLossArray[TypLoop].MicrobMet    [0];
        BioTransf    [0] := BioTransf[0]+     HypoSegment.ToxLossArray[TypLoop].BioTransf    [0];
        EmergeIns    [0] := EmergeIns[0] +    HypoSegment.ToxLossArray[TypLoop].EmergeIns    [0];
        FishingLoss  [0] := FishingLoss[0] +  HypoSegment.ToxLossArray[TypLoop].FishingLoss  [0];
        OOSBury      [0] := OOSBury[0] +      HypoSegment.ToxLossArray[TypLoop].OOSBury  [0];

      End;

   With ToxLayerArray[TypLoop] do
    Begin
      ToxSink      [0] := ToxSink[0] + HypoSegment.ToxLayerArray[TypLoop].ToxSink      [0];
      ToxDeltaThick[0] := ToxDeltaThick[0] + HypoSegment.ToxLayerArray[TypLoop].ToxDeltaThick[0];
      ToxTurbDiff  [0] := ToxTurbDiff[0] + HypoSegment.ToxLayerArray[TypLoop].ToxTurbDiff  [0];
      ToxEntrain   [0] := ToxEntrain[0] + HypoSegment.ToxLayerArray[TypLoop].ToxEntrain   [0];
      ToxMigrate   [0] := ToxMigrate[0] + HypoSegment.ToxLayerArray[TypLoop].ToxMigrate   [0];
      ToxNetLayer  [0] := ToxNetLayer[0] + HypoSegment.ToxLayerArray[TypLoop].ToxNetLayer  [0];
    End;

    With ToxLoadArray[TypLoop] do
      Begin
        ToxLoadH2O [0]   := ToxLoadH2O[0] + HypoSegment.ToxLoadArray[TypLoop].ToxLoadH2O [0];
        ToxLoadSed [0]   := ToxLoadSed[0] + HypoSegment.ToxLoadArray[TypLoop].ToxLoadSed [0];
        ToxLoadDetr [0]  := ToxLoadDetr[0] + HypoSegment.ToxLoadArray[TypLoop].ToxLoadDetr [0];
        ToxLoadBiota [0] := ToxLoadBiota[0] + HypoSegment.ToxLoadArray[TypLoop].ToxLoadBiota [0];
        TotOOSLoad [0]   := TotOOSLoad[0] + HypoSegment.ToxLoadArray[TypLoop].TotOOSLoad [0];
      End;
   End;

 For NSLoop := Nitrate to Phosphate do
   Begin
     With MBLossArray[NSLoop] do
      Begin
        TotalNLoss [0] := TotalNLoss[0] + HypoSegment.MBLossArray[NSLoop].TotalNLoss [0];
        TotalWashout [0] := TotalWashout[0] + HypoSegment.MBLossArray[NSLoop].TotalWashout [0];
        WashoutH2O   [0] := WashoutH2O[0] +   HypoSegment.MBLossArray[NSLoop].WashoutH2O   [0];
        WashoutAnim  [0] := WashoutAnim[0] +  HypoSegment.MBLossArray[NSLoop].WashoutAnim  [0];
        WashoutDetr  [0] := WashoutDetr[0] +  HypoSegment.MBLossArray[NSLoop].WashoutDetr  [0];
        WashoutPlant [0] := WashoutPlant[0] + HypoSegment.MBLossArray[NSLoop].WashoutPlant [0];
        EmergeIns    [0] := EmergeIns[0] +    HypoSegment.MBLossArray[NSLoop].EmergeIns    [0];
        Denitrify    [0] := Denitrify[0] +  HypoSegment.MBLossArray[NSLoop].Denitrify    [0];
        Burial       [0] := Burial[0]    +  HypoSegment.MBLossArray[NSLoop].Burial       [0];
        FishingLoss  [0] := FishingLoss[0] +  HypoSegment.MBLossArray[NSLoop].FishingLoss[0];
        CaCO3Sorb    [0] := CaCO3Sorb[0] +  HypoSegment.MBLossArray[NSLoop].CaCO3Sorb    [0];
        BoundLoss    [0] := BoundLoss[0] +  HypoSegment.MBLossArray[NSLoop].BoundLoss    [0];
      End;

    With MBLoadArray[NSLoop] do
      Begin
        LoadH2O [0]   := LoadH2O[0] + HypoSegment.MBLoadArray[NSLoop].LoadH2O [0];
        LoadDetr [0]  := LoadDetr[0] + HypoSegment.MBLoadArray[NSLoop].LoadDetr [0];
        LoadBiota [0] := LoadBiota[0] + HypoSegment.MBLoadArray[NSLoop].LoadBiota [0];
        LoadPWMacro [0]  := LoadPWMacro[0] + HypoSegment.MBLoadArray[NSLoop].LoadPWMacro [0];
        LoadFixation [0]  := LoadFixation[0] + HypoSegment.MBLoadArray[NSLoop].LoadFixation [0];
        TotOOSLoad [0]   := TotOOSLoad[0] + HypoSegment.MBLoadArray[NSLoop].TotOOSLoad [0];
        Exposure [0]  := Exposure[0] + HypoSegment.MBLoadArray[NSLoop].Exposure [0];
        BoundLoad    [0] := BoundLoad[0] +  HypoSegment.MBLoadArray[NSLoop].BoundLoad    [0];
      End;

    With MBLayerArray[NSLoop] do
      Begin
        NSink [0]   := NSink[0] + HypoSegment.MBLayerArray[NSLoop].NSink [0];
        NTurbDiff [0]   := NTurbDiff[0] + HypoSegment.MBLayerArray[NSLoop].NTurbDiff [0];
        NMigrate [0]   := NMigrate[0] + HypoSegment.MBLayerArray[NSLoop].NMigrate [0];
        NNetLayer [0]   := NNetLayer[0] + HypoSegment.MBLayerArray[NSLoop].NNetLayer [0];
        PFluxD [0]   := PFluxD[0] + HypoSegment.MBLayerArray[NSLoop].PFluxD [0];
      End;
   End; {nsloop}
End;


Procedure TStates.ProcessMBData(hdid: Double);      // precisely solve given 6 RK Steps
Const   C1=37./378;C3=250./621;C4=125./594;C6=512./1771;
Var TypLoop: T_SVType;
    NSLoop:  AllVariables;
    Loop: TAddtlOutput;
Begin
  For TypLoop := FirstOrgTxTyp to LastOrgTxTyp do
   Begin
    With ToxLossArray[TypLoop] do
      Begin                                         {these variables in units of total KG from simulation start}
        TotalToxLoss [0] := TotalToxLoss[0] + hdid*(C1*TotalToxLoss[1]+c3*TotalToxLoss[3]+c4*TotalToxLoss[4]+C6*TotalToxLoss[6]) ;
        TotalWashout [0] := TotalWashout[0] + hdid*(C1*TotalWashout[1]+c3*TotalWashout[3]+c4*TotalWashout[4]+C6*TotalWashout[6]);
        WashoutH2O   [0] := WashoutH2O[0] +   hdid*(C1*WashoutH2O[1]+c3*WashoutH2O[3]+c4*WashoutH2O[4]+C6*WashoutH2O[6]);
        WashoutAnim  [0] := WashoutAnim[0] +  hdid*(C1*WashoutAnim[1]+c3*WashoutAnim[3]+c4*WashoutAnim[4]+C6*WashoutAnim[6]);
        WashoutDetr  [0] := WashoutDetr[0] +  hdid*(C1*WashoutDetr[1]+c3*WashoutDetr[3]+c4*WashoutDetr[4]+C6*WashoutDetr[6]);
        WashoutPlant [0] := WashoutPlant[0] + hdid*(C1*WashoutPlant[1]+c3*WashoutPlant[3]+c4*WashoutPlant[4]+C6*WashoutPlant[6]);
        WashoutSedm  [0] := WashoutSedm[0] +  hdid*(C1*WashoutSedm[1]+c3*WashoutSedm[3]+c4*WashoutSedm[4]+C6*WashoutSedm[6]);
        Hydrolys     [0] := Hydrolys[0] +     hdid*(C1*Hydrolys[1]+c3*Hydrolys[3]+c4*Hydrolys[4]+C6*Hydrolys[6]);
        Photolys     [0] := Photolys[0] +     hdid*(C1*Photolys[1]+c3*Photolys[3]+c4*Photolys[4]+C6*Photolys[6]);
        Volatiliz    [0] := Volatiliz[0] +    hdid*(C1*Volatiliz[1]+c3*Volatiliz[3]+c4*Volatiliz[4]+C6*Volatiliz[6]);
        MicrobMet    [0] := MicrobMet[0] +    hdid*(C1*MicrobMet[1]+c3*MicrobMet[3]+c4*MicrobMet[4]+C6*MicrobMet[6]);
        BioTransf    [0] := BioTransf[0]+     hdid*(C1*Biotransf[1]+c3*Biotransf[3]+c4*Biotransf[4]+C6*Biotransf[6]);
        EmergeIns    [0] := EmergeIns[0] +    hdid*(C1*EmergeIns[1]+c3*EmergeIns[3]+c4*EmergeIns[4]+C6*EmergeIns[6]);
        FishingLoss  [0] := FishingLoss[0] +  hdid*(C1*FishingLoss[1]+c3*FishingLoss[3]+c4*FishingLoss[4]+C6*FishingLoss[6]);
        If Not SedModelIncluded
          then   OOSBury  [0] := OOSBury[0] +  hdid*(C1*OOSBury[1]+c3*OOSBury[3]+c4*OOSBury[4]+C6*OOSBury[6]);
          {else  OOSBury Tracked outside of derivs }
        DissHydr [0] := (C1*DissHydr[1]+c3*DissHydr[3]+c4*DissHydr[4]+C6*DissHydr[6]) ; {These variables in units of kg/day}
        DissPhot [0] := (C1*DissPhot[1]+c3*DissPhot[3]+c4*DissPhot[4]+C6*DissPhot[6]) ;
        DissMicrob [0] := (C1*DissMicrob[1]+c3*DissMicrob[3]+c4*DissMicrob[4]+C6*DissMicrob[6]) ;
        DissWash [0] := (C1*DissWash[1]+c3*DissWash[3]+c4*DissWash[4]+C6*DissWash[6]) ;
        DissVolat [0] := (C1*DissVolat[1]+c3*DissVolat[3]+c4*DissVolat[4]+C6*DissVolat[6]) ;
        DissSorp [0] := (C1*DissSorp[1]+c3*DissSorp[3]+c4*DissSorp[4]+C6*DissSorp[6]) ;
        SedMicrob [0] := (C1*SedMicrob[1]+c3*SedMicrob[3]+c4*SedMicrob[4]+C6*SedMicrob[6]) ;
        SedDesorp [0] := (C1*SedDesorp[1]+c3*SedDesorp[3]+c4*SedDesorp[4]+C6*SedDesorp[6]) ;
        SedScour [0] := (C1*SedScour[1]+c3*SedScour[3]+c4*SedScour[4]+C6*SedScour[6]) ;
        SedHydr [0] := (C1*SedHydr[1]+c3*SedHydr[3]+c4*SedHydr[4]+C6*SedHydr[6])
      End;

   With ToxLayerArray[TypLoop] do
    Begin
      ToxSink      [0] := ToxSink[0] + hdid*(C1*ToxSink[1]+c3*ToxSink[3]+c4*ToxSink[4]+C6*ToxSink[6]);
      ToxDeltaThick[0] := ToxDeltaThick[0] + hdid*(C1*ToxDeltaThick[1]+c3*ToxDeltaThick[3]+c4*ToxDeltaThick[4]+C6*ToxDeltaThick[6]);
      ToxTurbDiff  [0] := ToxTurbDiff[0] + hdid*(C1*ToxTurbDiff[1]+c3*ToxTurbDiff[3]+c4*ToxTurbDiff[4]+C6*ToxTurbDiff[6]);
      ToxEntrain   [0] := ToxEntrain[0] + hdid*(C1*ToxEntrain[1]+c3*ToxEntrain[3]+c4*ToxEntrain[4]+C6*ToxEntrain[6]);
      ToxMigrate   [0] := ToxMigrate[0] + hdid*(C1*ToxMigrate[1]+c3*ToxMigrate[3]+c4*ToxMigrate[4]+C6*ToxMigrate[6]);
      ToxNetLayer  [0] := ToxNetLayer[0] + hdid*(C1*ToxNetLayer[1]+c3*ToxNetLayer[3]+c4*ToxNetLayer[4]+C6*ToxNetLayer[6]);
    End;

    With ToxLoadArray[TypLoop] do
      Begin
        ToxLoadH2O [0]   := ToxLoadH2O[0] + hdid*(C1*ToxLoadH2O[1]+c3*ToxLoadH2O[3]+c4*ToxLoadH2O[4]+C6*ToxLoadH2O[6]) ;
        ToxLoadSed [0]   := ToxLoadSed[0] + hdid*(C1*ToxLoadSed[1]+c3*ToxLoadSed[3]+c4*ToxLoadSed[4]+C6*ToxLoadSed[6]) ;
        ToxLoadDetr [0]  := ToxLoadDetr[0] + hdid*(C1*ToxLoadDetr[1]+c3*ToxLoadDetr[3]+c4*ToxLoadDetr[4]+C6*ToxLoadDetr[6]) ;
        ToxLoadBiota [0] := ToxLoadBiota[0] + hdid*(C1*ToxLoadBiota[1]+c3*ToxLoadBiota[3]+c4*ToxLoadBiota[4]+C6*ToxLoadBiota[6]) ;
        TotOOSLoad [0]   := TotOOSLoad[0] + hdid*(C1*TotOOSLoad[1]+c3*TotOOSLoad[3]+c4*TotOOSLoad[4]+C6*TotOOSLoad[6]) ;
      End;
   End;

 For NSLoop := Nitrate to Phosphate do
   Begin
     With MBLossArray[NSLoop] do
      Begin
        TotalNLoss [0] := TotalNLoss[0] + hdid*(C1*TotalNLoss[1]+c3*TotalNLoss[3]+c4*TotalNLoss[4]+C6*TotalNLoss[6]) ;
        TotalWashout [0] := TotalWashout[0] + hdid*(C1*TotalWashout[1]+c3*TotalWashout[3]+c4*TotalWashout[4]+C6*TotalWashout[6]);
        WashoutH2O   [0] := WashoutH2O[0] +   hdid*(C1*WashoutH2O[1]+c3*WashoutH2O[3]+c4*WashoutH2O[4]+C6*WashoutH2O[6]);
        WashoutAnim  [0] := WashoutAnim[0] +  hdid*(C1*WashoutAnim[1]+c3*WashoutAnim[3]+c4*WashoutAnim[4]+C6*WashoutAnim[6]);
        WashoutDetr  [0] := WashoutDetr[0] +  hdid*(C1*WashoutDetr[1]+c3*WashoutDetr[3]+c4*WashoutDetr[4]+C6*WashoutDetr[6]);
        WashoutPlant [0] := WashoutPlant[0] + hdid*(C1*WashoutPlant[1]+c3*WashoutPlant[3]+c4*WashoutPlant[4]+C6*WashoutPlant[6]);
        EmergeIns    [0] := EmergeIns[0] +    hdid*(C1*EmergeIns[1]+c3*EmergeIns[3]+c4*EmergeIns[4]+C6*EmergeIns[6]);
        Denitrify    [0] := Denitrify[0] +  hdid*(C1*Denitrify[1]+c3*Denitrify[3]+c4*Denitrify[4]+C6*Denitrify[6]);
        Burial       [0] := Burial[0]    +  hdid*(C1*Burial[1]+c3*Burial[3]+c4*Burial[4]+C6*Burial[6]);
        FishingLoss  [0] := FishingLoss[0]    +  hdid*(C1*FishingLoss[1]+c3*FishingLoss[3]+c4*FishingLoss[4]+C6*FishingLoss[6]);
        CaCO3Sorb    [0] := CaCO3Sorb[0] +  hdid*(C1*CaCO3Sorb[1]+c3*CaCO3Sorb[3]+c4*CaCO3Sorb[4]+C6*CaCO3Sorb[6]);
        BoundLoss    [0] :=  {PER TIME STEP} (C1*BoundLoss[1]+c3*BoundLoss[3]+c4*BoundLoss[4]+C6*BoundLoss[6]);
      End;

    With MBLoadArray[NSLoop] do
      Begin
        LoadH2O [0]   := LoadH2O[0] + hdid*(C1*LoadH2O[1]+c3*LoadH2O[3]+c4*LoadH2O[4]+C6*LoadH2O[6]);
        LoadDetr [0]  := LoadDetr[0] + hdid*(C1*LoadDetr[1]+c3*LoadDetr[3]+c4*LoadDetr[4]+C6*LoadDetr[6]);
        LoadBiota [0] := LoadBiota[0] + hdid*(C1*LoadBiota[1]+c3*LoadBiota[3]+c4*LoadBiota[4]+C6*LoadBiota[6]);
        LoadPWMacro [0]  := LoadPWMacro[0] + hdid*(C1*LoadPWMacro[1]+c3*LoadPWMacro[3]+c4*LoadPWMacro[4]+C6*LoadPWMacro[6]);
        LoadFixation [0]  := LoadFixation[0] + hdid*(C1*LoadFixation[1]+c3*LoadFixation[3]+c4*LoadFixation[4]+C6*LoadFixation[6]);
        TotOOSLoad [0]   := TotOOSLoad[0] + hdid*(C1*TotOOSLoad[1]+c3*TotOOSLoad[3]+c4*TotOOSLoad[4]+C6*TotOOSLoad[6]);
        Exposure [0]  := Exposure[0] + hdid*(C1*Exposure[1]+c3*Exposure[3]+c4*Exposure[4]+C6*Exposure[6]);
        BoundLoad    [0] :=                      (C1*BoundLoad[1]+c3*BoundLoad[3]+c4*BoundLoad[4]+C6*BoundLoad[6]);
      End;

    With MBLayerArray[NSLoop] do
      Begin
        NSink [0]   := NSink[0] + hdid*(C1*NSink[1]+c3*NSink[3]+c4*NSink[4]+C6*NSink[6]);
        NTurbDiff [0]   := NTurbDiff[0] + hdid*(C1*NTurbDiff[1]+c3*NTurbDiff[3]+c4*NTurbDiff[4]+C6*NTurbDiff[6]) ;
        NMigrate [0]   := NMigrate[0] + hdid*(C1*NMigrate[1]+c3*NMigrate[3]+c4*NMigrate[4]+C6*NMigrate[6]);
        NNetLayer [0]   := NNetLayer[0] + hdid*(C1*NNetLayer[1]+c3*NNetLayer[3]+c4*NNetLayer[4]+C6*NNetLayer[6]) ;
        PFluxD [0]   := PFluxD[0] + hdid*(C1*PFluxD[1]+c3*PFluxD[3]+c4*PFluxD[4]+C6*PFluxD[6]) ;
      End;
   End;

  GPP [0] := (C1*GPP[1]+c3*GPP[3]+c4*GPP[4]+C6*GPP[6]) ;
  TotResp [0] :=  (C1*TotResp[1]+c3*TotResp[3]+c4*TotResp[4]+C6*TotResp[6]) ;
   For Loop := TSP_Diag to PON_Dep do
     Diag_Track[Loop,0] := (C1*Diag_Track[Loop,1]+c3*Diag_Track[Loop,3]+c4*Diag_Track[Loop,4]+C6*Diag_Track[Loop,6]);

End;


Procedure TStates.ClearMBData(StartLoop: Integer);
Var TypLoop: T_SVType;
    StepLoop: Integer;
    NSLoop:AllVariables;
    Loop: TAddtlOutput;

Begin

  For TypLoop := FirstOrgTxTyp to LastOrgTxTyp do
   For StepLoop := StartLoop to 6 do
    Begin
     With ToxLossArray[TypLoop] do
      Begin
        TotalToxLoss[StepLoop] :=0;
        TotalWashout[StepLoop] :=0;
        WashoutH2O[StepLoop]   :=0;
        WashoutAnim[StepLoop]  :=0;
        WashoutDetr[StepLoop]  :=0;
        WashoutPlant[StepLoop] :=0;
        WashoutSedm[StepLoop]  :=0;
        Hydrolys[StepLoop]     :=0;
        Photolys[StepLoop]     :=0;
        Volatiliz[StepLoop]    :=0;
        MicrobMet[StepLoop]    :=0;
        BioTransf[StepLoop]    :=0;
        EmergeIns[StepLoop]    :=0;
        OOSBury[StepLoop]      :=0;
        FishingLoss[StepLoop]  :=0;

        DissHydr [StepLoop]:=0;
        DissPhot [StepLoop]:=0;
        DissMicrob [StepLoop]:=0;
        DissWash [StepLoop]:=0;
        DissVolat [StepLoop]:=0;
        DissSorp [StepLoop]:=0;
        SedMicrob [StepLoop]:=0;
        SedDesorp [StepLoop]:=0;
        SedScour [StepLoop]:=0;
        SedHydr [StepLoop]:=0;
      End;

   With ToxLayerArray[TypLoop] do
    Begin
      ToxSink      [StepLoop] :=0;
      ToxDeltaThick[StepLoop] :=0;
      ToxTurbDiff  [StepLoop] :=0;
      ToxEntrain   [StepLoop] :=0;
      ToxMigrate   [StepLoop] :=0;
      ToxNetLayer  [StepLoop] :=0;
    End;

     With ToxLoadArray[TypLoop] do
      Begin
        ToxLoadH2O[StepLoop] :=0;
        ToxLoadSed[StepLoop] :=0;
        ToxLoadDetr[StepLoop] :=0;
        ToxLoadBiota[StepLoop] :=0;
        TotOOSLoad[StepLoop] :=0;
      End;
    End;

 For NSLoop := Nitrate to Phosphate do
   For StepLoop := StartLoop to 6 do
    Begin
     With MBLossArray[NSLoop] do
      Begin
        TotalNLoss [StepLoop] :=0;
        TotalWashout [StepLoop] :=0;
        WashoutH2O   [StepLoop] :=0;
        WashoutAnim  [StepLoop] :=0;
        WashoutDetr  [StepLoop] :=0;
        WashoutPlant [StepLoop] :=0;
        EmergeIns    [StepLoop] :=0;
        Denitrify    [StepLoop] :=0;
        Burial       [StepLoop] :=0;
        FishingLoss  [StepLoop] :=0;
        CaCO3Sorb    [StepLoop] :=0;
        BoundLoss    [StepLoop] := 0;

      End;

    With MBLoadArray[NSLoop] do
      Begin
        LoadH2O [StepLoop] :=0;
        LoadDetr [StepLoop] :=0;
        LoadBiota [StepLoop] :=0;
        LoadPWMacro [StepLoop] :=0;
        LoadFixation [StepLoop] :=0;
        TotOOSLoad [StepLoop] :=0;
        Exposure [StepLoop] :=0;
        BoundLoad[StepLoop] := 0;
      End;

    With MBLayerArray[NSLoop] do
      Begin
        NSink [StepLoop] :=0;
        NTurbDiff [StepLoop] :=0;
        NMigrate [StepLoop] :=0;
        NNetLayer [StepLoop] :=0;
        PFluxD[StepLoop] := 0;
      End;

     For Loop := TSP_Diag to PON_Dep do
       Diag_Track[Loop,StepLoop] := 0;

     NPP [StepLoop] := 0;
     GPP [StepLoop] := 0;
     TotResp[StepLoop] := 0;

    End; {StepLoop}

End;

{------------------------------------------------------------------------------------------------}


{**** TStateVariable Methods   ****}
constructor TStateVariable.Init(Ns : StateVariables; SVT: T_SVType; L: T_SVLayer;
                                aName : ShortString; P : TStates; IC : double; IsTempl: Boolean);
Var Loop: Alt_LoadingsType;
    SVTempl: TStateVariable;
    j: Integer;

begin
   IsTemplate := IsTempl;
   SVTempl := Nil;
   If Not IsTemplate then SVTempl := P.PStatesTemplate.GetStatePointer(NS,SVT,L);

   If IsTemplate then Begin
                        New(PName);
                        PName^ := aName
                      End
                 else PName  := SVTempl.PName;

   nState:=Ns;
   SVType:=SVT;
   Layer := L;
   InitialCond:=IC;
   State:=0;
   AllStates:=P;
   If P<>nil then
     Begin
       Location :=P.Location;
       ChemPtrs :=P.ChemPtrs;
     End;

   If ISTemplate  then Begin
                         New(PShowRates);
                         PShowRates^ := True;
                       End
                  else PShowRates := SVTempl.PShowRates;

   RateColl    := nil;
   RateIndex   := -1;
   LoadNotes1 := '';
   LoadNotes2 := '';

   If ISTemplate  then Begin
                         New(PTrackResults);
                         PTrackResults^ := True
                       End
                  else PTrackResults := SVTempl.PTrackResults;

   With LoadsRec do     {Set up Loadings Data}
   begin
     Loadings:=TLoadings.Init(5,10);
     ConstLoad:=0;
     MultLdg := 1.0;
     UseConstant:=True;
     NoUserLoad:=Ns in [pH..oxygen];

     For loop:=PointSource to NonPointSource do
       begin
         If Has_Alt_Loadings(ns,SVT,L) then
            Alt_Loadings[loop] :=TLoadings.Init(10,20) else Alt_Loadings[loop]:=nil;
         Alt_ConstLoad[loop]   :=0;
         Alt_UseConstant[loop] :=True;
         Alt_MultLdg[loop]     :=1.0;
       end;

   end; {With LoadsRec}

   If ISTemplate then Begin
                        New(PRequiresData);
                        New(PHasData);
                        PRequiresData^ := False;
                        PHasData^ := False;
                      End
                 else Begin
                        PRequiresData := SVTempl.PRequiresData;
                        PHasData := SVTempl.PHasData;
                      End;

   YHold:=0; YOrig:=0;
   For j := 1 to 6 do
     StepRes[j] := 0;

   UpdateUnits;
end;

(* Function TStateVariable.FloodLoss: Double;
Begin
   FloodLoss := 0;  {floodloss is implicit in washout}
End; *)

{-------------------------------------------------------------------------------}

Function TStateVariable.Washout: Double;
{ Downstream Washout of all dissolved or floating immobile SVs.
  Virtual method that is overridden if necessary }
Var Disch: Double;
Begin
  Disch := Location.Discharge[AllStates.VSeg];

  if Disch < Small then WashOut := 0.0
                   else WashOut := Disch * State / AllStates.SegVol;
                      {unit / d}  {m3/d}  {unit}             {cu m.}

  WashoutStep[AllStates.DerivStep] := Result * AllStates.SegVol;
               {1000*mass}            {mass/L*d}             {m3}
End;

{-------------------------------------------------------------------------------}

Function TStateVariable.Washin: Double;

      Function  Cascade_Washin : Double;
      Var i: Integer;
          PLnk: TSegmentLink;
          UpStWashout, WaterFlow: Double;
          ResultsIncrement, TimeIndex: Double;
          Hourly: Boolean;

      {January 2007 Writing cascade-washin within the derivatives means that downstream concentrations
       are calculated more accurately.  JSC}
      {8/20/2007 added support for hourly runs with cascade mode}

      Begin
        Cascade_Washin := 0;
        Hourly := AllStates.PModelTimeStep^ = TSHOURLY;
        With AllStates do
          For i:=0 to In_Cs_Links.Count-1 do  {Step through all incoming cascade links}
            Begin
              PLnk := In_Cs_Links.At(i);
              If PLnk.CascadeWash <> nil then
                Begin
                  WaterFlow := PLnk.GetWaterFlow(TPresent);
                  If Waterflow<0 then Raise EAQUATOXERROR.Create('Error In Link '+PLnk.Name+'.  Cascade Water Flows may not be negative.');

                  If WaterFlow > 0 then
                    Begin
                      ResultsIncrement := 1;
                      IF Hourly THEN ResultsIncrement := 1/24;  {8/20/07}

                      TimeIndex := TPresent + ResultsIncrement;  {loadings actually written with time-stamp of time-step after loading}
                      If TimeIndex = Int(TimeIndex) then TimeIndex := TPresent;
                      If Hourly THEN If 24*TimeIndex = Int(24*TimeIndex) then TimeIndex := TPresent; {8/20/07}

                      UpStWashout := PLnk.CascadeWash.GetState(NState,SVType,Layer,False,False,False,0,0,TimeIndex,Hourly);
                      If Hourly then UpStWashout := UpStWashout * 24; {loading per 1/24th of a day to loading per day units} 

                      If UpStWashout > 0 then
                        Begin
                          If Layer=SedLayer1 {bedload}
                            then Cascade_Washin := Result + UpStWashout / SedLayerArea       {Adjust for area of sediment layer in new seg}
                            else Cascade_Washin := Result + UpStWashout / Volume_Last_Step;  {Adjust for volume of water in the new segment}
                        End;
                    End;
                End; {cascadewash <> nil}
            End;  {for i ... In_CS_Links}

      End; {Cascade Washin}


{WASHIN -- Inflow of SVs from upstream feedback link(s), only relevant for linked mode}
Var i: Integer;
    PUpstreamVar: TStateVariable;
    PLnk   : TSegmentLink;
    PUpVol : TVolume;
    Junk: Double;
    UpStVolume,SegVol: Double;
    UpStWashout: Double;
    TotUpStWash,FracWashThisLink : Double;
    Waterflow: Double;

Begin
  WashIn :=0;
  If Not AllStates.LinkedMode then exit;

  SegVol :=AllStates.SegVol;

  With AllStates.In_FB_Links do   {With all incoming feedback links}
    Begin
      For i:=0 to Count-1 do  {Step through all incoming feedback links}
        Begin
          PLnk := At(i);

          WaterFlow := PLnk.GetWaterFlow(AllStates.TPresent);
          If WaterFlow > Tiny then
            Begin
              PUpVol := PLnk.FromPStates.GetStatePointer(Volume,STV,WaterCol);    {TVolume for the upstream segment}
              If PLnk.FromPStates.VolumeUpdated <> AllStates.TPresent then
                Begin     {make upper segment's discharge data up-to-date for Washout Call}
                  PUpVol.CalculateLoad(AllStates.TPresent);
                  PUPVol.Derivative(Junk);
                End;

              TotUpStWash := PUPVol.DischargeLoad;

              WaterFlow := PLnk.GetWaterFlow(AllStates.TPresent);
              If Waterflow<0 then Raise EAQUATOXERROR.Create('Error In Link '+PLnk.Name+'.  As of this version, water flows within links must not be negative.  '+
                                                             'You may, however, create a link going the other way with a positive water flow.');

              FracWashThisLink := Waterflow / TotUpStWash;  {calculate pct of total outflow that goes to this segment}

              PUpstreamVar := PLnk.FromPStates.GetStatePointer(NState,SVType,Layer);
              UpStVolume   := PUpVol.AllStates.Volume_Last_Step;
              UpStWashout  := PUpstreamVar.WashOut * UpStVolume * FracWashThisLink;   {Washout is virtual method}
              WashIn       := Result + (UpStWashout / SegVol);

(*              { --------------------  LIPSKY CODE    -------------------------}
              If PLnk.Name = 'S-LP' then
                Begin
                  If (NState = Ammonia) or (NState = Nitrate) then Result := Result * (1-(N_REMOVAL_S_LP/100));
                  If (NState = Phosphate) then Result := Result * (1-(P_REMOVAL_S_LP/100));
                End;
              { --------------------  END LIPSKY CODE  -------------------------}   *)


            End;  {WaterFlow > Tiny}
        End;
    End;  {with FB Links}

  Washin := Result + Cascade_Washin;
End;  {Washin}

{-------------------------------------------------------------------------------}

Function TStates.CalcitePcpt: Double;
Const OM_2_OC = 1.90;
      C2Calcite = 8.33;
Var TP: TPlant;
    PVars: AllVariables;
    Photo: Double;
Begin
   Photo := 0;
   CalcitePcpt := 0;
   IF GetState(pH,StV,WaterCol) < 7.5 then exit;  // JSC, From 8.25 to 7.5 on 7/2/2009

   For PVars := FirstPlant to LastPlant do
     Begin
       TP := GetStatePointer(PVars,StV,WaterCol);
       If TP<> nil then
        If TP.Is_Pcp_CaCO3
          {subset of plants, all plants except Bryophytes and "Other Algae" compartments}
         then Photo := Photo + TP.Photosynthesis;
     End;

   CalcitePcpt :=   C2Calcite      * (Photo     /  OM_2_OC);
 {mg calcite/L d} {g Calcite / gC}  {mg OM/L d}  {g OM/ gOC}

End;

{-------------------------------------------------------------------------------}

constructor TphObj.Init;
Begin
  alkalinity := 1000; { ( default ueq CaCO3/L) }
  inherited;
End;

{-------------------------------------------------------------------------------}

Procedure TStateVariable.UpdateUnits;
{*********************************}
{ Sets the correct units given    }
{ the statevar type               }
{ coded by JSC, modified 7/22/98  }
{*********************************}
Begin
   If (SVType in [FirstToxTyp..LastToxTyp])
         then
           Begin
             if (nstate=PoreWater)
               then Begin StateUnit:='ug/L';
                          LoadingUnit:='N A';
                    End
               else if NState in [SedmRefrDetr..SuspLabDetr, Cohesives..NonCohesives2,
                                  POC_G1..POC_G3, BuriedRefrDetr,BuriedLabileDetr]
                  Then Begin
                         StateUnit:='ug/kg dry';
                         LoadingUnit:='ug/kg dry';
                       End
                  Else Begin
                         StateUnit:='ug/kg wet';
                         LoadingUnit:='ug/kg wet';
                       End;
           End
   else {not a toxicant in an organism or sediment}
     case nstate of
        Light: Begin StateUnit:='Ly/d';
                     LoadingUnit:='Ly/d';
               end;
        pH:    Begin StateUnit:='pH';
                     LoadingUnit:='pH';
               end;
        BuriedRefrDetr,BuriedLabileDetr:
                      Begin StateUnit:='g/m2';
                            LoadingUnit:='N.A.';
                      end;
        Temperature:  Begin StateUnit:='deg. C';
                            LoadingUnit:='deg. C';
                      end;
        Volume  :     Begin StateUnit:='cu.m';
                            LoadingUnit:='cu.m';
                      end;
        WindLoading:  Begin StateUnit:='m/s';
                            LoadingUnit:='m/s';
                      end;
        PoreWater:    Begin StateUnit:='cu.m/m2';
                            LoadingUnit:='N A';
                      end;
        Salinity:     Begin StateUnit:='ppt';
                            LoadingUnit:='ppt';
                      end;
        Ammonia, Phosphate, Nitrate,Avail_Silica, COD, TAM, Silica:
           If Layer > WaterCol
              then    Begin StateUnit:='g/m3';
                            LoadingUnit:='N A';
                      end
             else     Begin StateUnit:='mg/L';
                            LoadingUnit:='mg/L';
                      end;
        POC_G1,POC_G2,POC_G3 :
                        Begin StateUnit:='g C/m3';
                              LoadingUnit:='N A';
                        end;
        PON_G1,PON_G2,PON_G3 :
                        Begin StateUnit:='g N/m3';
                              LoadingUnit:='N A';
                        end;
        POP_G1,POP_G2,POP_G3 :
                        Begin StateUnit:='g P/m3';
                              LoadingUnit:='N A';
                        end;
        Methane,Sulfide:
           If Layer > WaterCol
             then    Begin StateUnit:='g O2eq./m3';
                            LoadingUnit:='N A';
                      end
             else     Begin StateUnit:='mg/L';
                            LoadingUnit:='mg/L';
                      end;
        LaDOMPore,ReDOMPore:
                      Begin StateUnit:='g/cu.m';
                            LoadingUnit:='N A';
                      end;
        Sand..TSS, Cohesives..NonCohesives2:
           If Layer > WaterCol
             then    Begin StateUnit:='g/sq.m';
                            LoadingUnit:='N A';
                      end
             else     Begin StateUnit:='mg/L';
                            LoadingUnit:='mg/L';
                      end;
        FirstOrgTox..LastOrgTox:
                      Begin StateUnit:='ug/L';
                            LoadingUnit:='ug/L';
                      end;
        FirstPlant..LastPlant: If svtype=Stv then (Self as TPlant).ChangeData
                                             else Begin  // NIntrnl or PIntrnl
                                                    StateUnit:='ug/L';
                                                    LoadingUnit:='N A';
                                                  End;
        SedmRefrDetr, SedmLabDetr:
           If Layer > SedLayer1
             then    Begin StateUnit:='g/m2 dry';
                           LoadingUnit:='N A';
                     end
             else    Begin StateUnit:='g/m2 dry';
                           LoadingUnit:='N A';
                     end;
        FirstAnimal..LastAnimal: (Self as TAnimal).ChangeData;
        DissRefrDetr..SuspLabDetr:
                     Begin StateUnit:='mg/L dry';
                           LoadingUnit:='mg/L dry';
                     end;
        Else         Begin StateUnit:='mg/L';
                           LoadingUnit:='mg/L';
                     end;
     End; {Case}
End;

Destructor TStateVariable.Destroy;
var loop: Alt_LoadingsType;
Begin
  If IsTemplate then
    Begin
      Dispose(PShowRates);
      Dispose(PTrackResults);
      Dispose(PName);
      Dispose(PHasData);
      Dispose(PRequiresData);
    End;

  With LoadsRec do
   Begin
    If Loadings <> nil then Loadings.Destroy;
    For loop:=PointSource to NonPointSource do
      If Alt_Loadings[loop] <> nil then Alt_Loadings[Loop].Destroy;
   End; {WithLoadsRec}

  If RateColl <> nil then RateColl.Destroy;

End; {TStateVar.Destroy}

Destructor TStates.Destroy;
Var loop: VerticalSegments;
    psLoop: Alt_LoadingsType;
    IsTemplate: Boolean;
    i: Integer;
Begin
  IsTemplate := (PStatesTemplate = Self);
  Location   := nil;
  ChemPtrs   := nil;
  SetupRec   := nil;
  Diagenesis_Params := nil;

  For Loop:=Epilimnion to Hypolimnion do
     Begin
       If Results[loop]<>nil then Results[loop].Destroy;
       Results[loop]:=nil;
       If ControlResults[loop]<>nil then ControlResults[loop].Destroy;
       ControlResults[loop]:=nil;
     End;

  If (Not LinkedMode) and (HypoSegment<>nil) then HypoSegment.Destroy;

   For i:=1 to 10 do
     With SedData[i] do
        TLoadings(UpperDispCoeff).Destroy;

  If (Distributions<>nil) then Distributions.Destroy;

  If IsTemplate then
     Begin
       Dispose(PRateInfo);
       Dispose(PControlInfo);
       Dispose(PModelTimeStep);
       Dispose(PSavePPB);
       Dispose(PSaveBAFs);
     End;

  With HypoTempLoads do
    if Loadings <> nil then Loadings.Destroy;
  For PSLoop := PointSource to NonPointSource do
    If HypoTempLoads.Alt_Loadings[PSLoop]<>nil then HypoTempLoads.Alt_Loadings[PSLoop].Destroy;

  With Shade do
    if Loadings <> nil then Loadings.Destroy;

  With Z_Thermocline do
    if Loadings <> nil then Loadings.Destroy;

  If PMultiRec <> nil then
    Begin
      If IsTemplate then With PMultiRec^ do
        Begin
          Dispose(PNumAges);
          Dispose(PSpawnAge);
          Dispose(PName);
          Dispose(PLipidFrac);
          Dispose(PMortCoeff);
          Dispose(PMeanWeight);
        End;
      Dispose(PMultiRec);
    End;

  If (LinkedMode and IsTemplate) or ((Not LinkedMode) and (VSeg=Epilimnion)) then
    Begin
      Dispose(PMessageStr);
      Dispose(PMessageErr);
    End;

  IF Linkedmode and (not IsTemplate) then
    Begin
      XSecData.Destroy;
    End;

  BirdPrey.Destroy;
  PO2Concs.Destroy;
  PLightVals.Destroy;
  PSedConcs.Destroy;
  If Graphs <> nil then Graphs.Destroy;
  If ObservedData <> nil then ObservedData.Destroy;
  If DynVelocity <> nil then DynVelocity.Destroy;
  If DynZMean <> nil then DynZMean.Destroy;

  inherited Destroy;
End; {TStates.Destroy}

{-----------------------------------------------------------------------}
Function TStates.OutputState(Ns: AllVariables; Typ: T_SVType; L: T_SVLayer; Val: Double): Double;
Var Convert: Boolean;

Begin
   OutputState := Val;
   Convert := Convert_g_m2_to_mg_L(NS,Typ,L);
   With Location do
     If Convert
       Then
         Begin
            OutputState := Val * SegVol / SurfaceArea;
             {g/m2}       {g/m3}   {m3}      {m2}
            If (NS in [FirstFish..LastFish]) and (Typ=StV) then
                  OutputState := Val  * Volume_Last_Step / Locale.SurfArea;
                  {g/m2}      {g/m3}   {m3, entire sys}  {m2, entire sys}
         End;
End;

{-------------------------------------------------------------------------------}

Function TStates.Convert_g_m2_to_mg_L(S: AllVariables;  T: T_SVType; L: T_SVLayer): Boolean;
Var P:TStateVariable;
    Convert: Boolean;
Begin
  Convert := False;
  P := GetStatePointer(S,T,L);

  If (L=WaterCol) and (P<>nil) then
      Begin                                   
         {Fish must be converted from mg/L to g/sq.m}
         If ((S in [FirstFish..LastFish]) and (T=StV)) then Convert:=True;

         {Sedimented Detritus must be converted from mg/L to g/sq.m}
         If ((S in [SedmRefrDetr,SedmLabDetr]) and (T=StV)) then Convert:=True;

         {Periphyton & Macrophytes must be converted from mg/L to g/sq.m}
         If (T=StV) and (P.IsPlant)
           Then If (TPlant(P).PAlgalRec.PlantType<>'Phytoplankton') then Convert:=True;

         {ZooBenthos must be converted from mg/L to g/sq.m}
         If (T=StV) and (P.IsAnimal)
           then If  (TAnimal(P).PAnimalData.Animal_Type='Benthic Invert.') or
                    (TAnimal(P).PAnimalData.Animal_Type='Benthic Insect')
             Then Convert:=True;
      End;

  If (T=OtherOutput) and (TAddtlOutput(S)=MultiFishConc) then Convert := True; {Sum of multifish concs. needs to be converted for output}

  Convert_g_m2_to_mg_L := Convert;
End;
{-----------------------------------------------------------------------}
Function TStates.UniqueName(S: AllVariables) : String;
{If SV is an animal or a plant, returns a unique name for that variable, otherwise
 returns blank}
Const UNIQUENAMELEN = 25;
Var EnumLoop: AllVariables;
    YourName,MyName  : String[UNIQUENAMELEN];
    ShortFishName    : String[8];
    P: TStateVariable;
    PA: TAnimal;
    PP: TPlant;
    Matches: Integer;
Begin
  UniqueName:='';
  P := GetStatePointer(S,StV,WaterCol);
  If P=nil then exit;

  Matches:=1;
  MyName:='';

  If (P.NState in [Fish1..Fish15]) then
    Begin
      ShortFishName := PMultiRec.PName^;
      Case P.NState of
         Fish1         : MyName := ShortFishName +'0';
         Fish2         : MyName := ShortFishName +'I';
         Fish3         : MyName := ShortFishName +'II';
         Fish4         : MyName := ShortFishName +'III';
         Fish5         : MyName := ShortFishName +'IV';
         Fish6         : MyName := ShortFishName +'V';
         Fish7         : MyName := ShortFishName +'VI';
         Fish8         : MyName := ShortFishName +'VII';
         Fish9         : MyName := ShortFishName +'VIII';
         Fish10        : MyName := ShortFishName +'IX';
         Fish11        : MyName := ShortFishName +'X';
         Fish12        : MyName := ShortFishName +'XI';
         Fish13        : MyName := ShortFishName +'XII';
         Fish14        : MyName := ShortFishName +'XIII';
         Fish15        : MyName := ShortFishName +'XIV';
      End; {Case}
    End;

  If P.IsAnimal and not(P.NState in [Fish1..Fish15]) then
    Begin
      MyName :=TAnimal(P).PAnimalData.AnimalName;
      For EnumLoop:= FirstAnimal to AllVariables(Ord(S)-1) do
        Begin
          PA :=GetStatePointer(EnumLoop,StV,WaterCol);
          If PA <> nil then
            Begin
              YourName := PA.PAnimalData.AnimalName;
              If YourName = MyName Then Matches:=Matches+1;
            End;
        End;
      IF Matches>1 then MyName:=MyName+IntToStr(Matches);
    End; {Animal Code}

  If P.IsPlant then
    Begin
      MyName :=TPlant(P).PAlgalRec.PlantName;
      For EnumLoop:= FirstPlant to AllVariables(Ord(S)-1) do
        Begin
          PP := GetStatePointer(EnumLoop,StV,WaterCol);
          If PP <> Nil then
            Begin
              YourName := PP.PAlgalRec.PlantName;
              If YourName=MyName Then Matches:=Matches+1;
            End;
        End;
    End; {Plant Code}

  IF Matches>1 then If Length(MyName)<UNIQUENAMELEN
       then MyName:=MyName+Chr(Ord('0')+Matches)
       else MyName[UNIQUENAMELEN]:=Chr(Ord('0')+Matches);

  UniqueName:=MyName;
End;

{-----------------------------------------------------------------------}

Function TStateVariable.GetInflowLoad(TimeIndex : Double): Double;
{ This Procedure calculates inflow loadings only}
{ In the case of stratification, the user may specify which segment the inflow goes to 2-6-2007 }

Begin
 GetInflowLoad:=0;
 If LoadsRec.NoUserLoad then exit;

 With LoadsRec do
 Begin
   If UseConstant then GetInflowLoad:=ConstLoad
     else
       begin
         GetInflowLoad:=0;
         if Loadings<>nil then
            GetInflowLoad:=Loadings.GetLoad(TimeIndex,True);
       end;  {else}
     GetInflowLoad := Result * MultLdg;
 End; {With}
end;

Procedure TStateVariable.CalculateLoad(TimeIndex : Double);
{ This Procedure calculates inflow loadings only}

Begin
  Loading := GetInflowLoad(TimeIndex);
end;

{-----------------------------------------------------------------------}

Function TStateVariable.SegmentDiffusion(UpLinks: Boolean): Double;
{Diffusion of SVs with up or downstream link, only relevant for linked mode}
Var i: Integer;
    POtherSegVar : TStateVariable;
    PLnk         : TSegmentLink;
    DiffCalc     : Double;
    ThisConc, OtherSegConc : Double; {g/m3}
    DispCoeff, Area, Length: Double;
    Links        : TCollection;

Begin
  SegmentDiffusion :=0;
  DiffCalc := 0;
  If Not AllStates.LinkedMode then Raise EAQUATOXError.Create('Programming Error, SegDiff Relevant to LinkedMode only');
  If AllStates.CascadeRunning then Raise EAQUATOXError.Create('Programming Error, SegDiff Not Relevant to Cascade Segment');

  If UpLinks then Links := AllStates.In_FB_Links
             else Links := AllStates.Out_FB_Links;

  With Links do
    Begin
      If Count=0 then exit;
      For i:=0 to Count-1 do
        Begin
          PLnk := At(i);

          ThisConc := State;
          If UpLinks then POtherSegVar := PLnk.FromPStates.GetStatePointer(NState,SVType,Layer)
                     else POtherSegVar := PLnk.ToPStates.GetStatePointer(NState,SVType,Layer);
          OtherSegConc := POtherSegVar.State;

          Length    := PLnk.CharLength;
          DispCoeff := PLnk.GetDiffusion(AllStates.TPresent);
          Area      := PLnk.GetXSection(AllStates.TPresent);

          If Length>0 then
             DiffCalc := DiffCalc + ((DispCoeff * Area)/Length) * (OtherSegConc - ThisConc);
              {g/d}        {g/d}       {m2/d}     {m2}   {m}          {g/m3}       {g/m3}
        End;
    End;

  SegmentDiffusion := DiffCalc / AllStates.SegVol;
      {g/m3 d}         {g/d}                {m3}
End;


Function TStates.CalcVertDispersion: Double;

Var VSegHolder                       : VerticalSegments;
    TempTminus1hypo, TempTplus1hypo,
    TempCurrentEpi,  TempCurrentHypo : Double;
    TempPtr                          : TTemperature;
    Retention                        : Double;

 Begin
  If LinkedMode then Raise EAQUATOXERROR.Create('CalcVertDisp not relevant to LinkedMode');

  With Location do
    Begin
      If TotDischarge > 0
             then Retention := Volume_Last_Step / TotDischarge
                     {d}         {m cubed}        {m cubed/d}
             else Retention := 1000;

      VSegHolder:=VSeg;   {Save current segment}

      {Calculate Temperatures at different time steps}
      VSeg:=Hypolimnion;
      TempPtr:=GetStatePointer(Temperature,StV,WaterCol);
      TempPtr.CalculateLoad(TPresent-1);  TempTminus1hypo:=TempPtr.State;
      TempPtr.CalculateLoad(TPresent+1);  TempTplus1hypo:=TempPtr.State;
      TempPtr.CalculateLoad(TPresent);    TempCurrentHypo:=TempPtr.State;
      VSeg:=Epilimnion;
      TempPtr.CalculateLoad(TPresent);    TempCurrentEpi :=TempPtr.State;
{      IncrTemp := (TempTplus1hypo > TempTminus1hypo); }

      {Restore TStates to original state}
      VSeg:=VSegHolder;
      TempPtr.CalculateLoad(TPresent);

      If (ThermoclArea< Tiny) or (Retention <=0) then CalcVertDispersion := 0
        else If Retention <=180                   {9/9/98 was 10e4}
          then CalcVertDispersion := 1.37 * 10000 *POWER(Retention,-2.269)
                {m squared / day}                         {d}
          else
             begin
               If TempCurrentEpi=TempCurrentHypo then CalcVertDispersion:=100
               else With Location do With Morph do With Locale do
                  CalcVertDispersion :=DynamicZMean *((SegVolum[Hypolimnion]/(ThermoclArea * 1.0)) *
                    {m squared/d}     {thick, m}          {m cubed}         {m squared}  {deltaT}
                                   (Abs(TempTminus1hypo-TempTplus1hypo) /
                                   (TempCurrentEpi-TempCurrentHypo))); {all temps deg C}

             end; {else}
  end;  {with}
end;  {CalcVertDispersion}

Function TStateVariable.TurbDiff: double;

Var VertDispersion: Double;
    BulkMixCoeff  : Double;
    OtherSegState : Double;
    {--------------------------------------------------------------------------}
    Procedure EstuaryTurbDiff;
    Var Wind, Langmuir: Double;
    Begin
      BulkMixCoeff := 0.1; {m2/d, JSC 10-23-2002, as specified in QAPP, p 9}

      if AllStates.Vseg=Epilimnion then Wind := GetState(WindLoading,StV,WaterCol)
                                   else Wind := AllStates.EpiSegment.GetState(WindLoading,StV,WaterCol);

      With Location do          {5/20/2008} 
        If (MeanThick[Epilimnion]<3) and (Wind>=3) then Langmuir := 5
                                 {m}         {m/s} else Langmuir := 1;

      With AllStates do
        If VSeg=Epilimnion then OtherSegState := HypoSegment.GetState(nstate,SVType,Layer)
                           else OtherSegState := EpiSegment.GetState(nstate,SVType,Layer);

      With AllStates do
          TurbDiff := (BulkMixCoeff/Volume_Last_Step)*Langmuir*(OtherSegState - state);
          {g/m3 d}    {m cubed/ d}     {m cubed}     {unitless}    {g/m3}         {g/m3}

      If (Result<0) and (-Result > State) then Result := -State;
      If (Result>0) and (Result > OtherSegState) then Result := OtherSegState;
       {TurbDiff can not exceed state variable concentration	10/21/2002}
    End;
    {--------------------------------------------------------------------------}

Begin {TurbDiff}
  If AllStates.LinkedMode     then Raise EAQUATOXERROR.Create('TurbDiff not relevant to LinkedMode');
  If AllStates.EstuarySegment then Begin EstuaryTurbDiff; Exit; End;

  TurbDiff:=0;

  {Calculate Vertical Dispersion}
  With AllStates do
    If (VertDispersionCalcDate=TPresent)
       then VertDispersion := OldVertDispersionVal      {optimization}
       else begin
              VertDispersion     := CalcVertDispersion;
              VertDispersionCalcDate := TPresent;
              OldVertDispersionVal   := VertDispersion;
            end;

  If not AllStates.Stratified then exit;

  With AllStates do
    BulkMixCoeff := VertDispersion * ThermoclArea / StaticZMean;
    {m cubed/ d}    {m squared/ d}     {m squared}   {Thick, m}

  With AllStates do
    If VSeg=Epilimnion then OtherSegState := HypoSegment.GetState(nstate,SVType,Layer)
                       else OtherSegState := EpiSegment.GetState(nstate,SVType,Layer);

  With AllStates do
    TurbDiff := (BulkMixCoeff/SegVol) *(OtherSegState - state);
    {g/m3 d}     {m cubed/ d}  {m3}        {g/m3}       {g/m3}

  If (Result<0) and (-Result > State) then Result := -State;
  If (Result>0) and (Result > OtherSegState) then Result := OtherSegState;
  {TurbDiff can not exceed state variable concentration	10/21/2002 / Mar/1/2004}

End;

Procedure TStateVariable.ClearRate;
Begin
  RateIndex := -1;
  If RateColl = nil then RateColl := TCollection.Init(20,10);
End;

Procedure TStateVariable.SaveRate(Nm: String; Rt: Double);
Var PR: TRate;
Begin
  Inc(RateIndex);

  If RateIndex > RateColl.Count-1 then
    Begin
      PR := TRate.Init(Nm);
      RateColl.Insert(PR);
    End;

  PR := RateColl.At(RateIndex);
  PR.Rate[AllStates.DerivStep] := Rt;
End;

{------------------------------------------------------------------------}
Function TStateVariable.CanMigrate: Boolean;
Var  AType : String;
Begin
     CanMigrate:=False;

     {Fish Can migrate}
     If (nstate in [FirstFish..LastFish]) then CanMigrate:=True

     {Pelagic Invertebrates Can Migrate}
     Else If (nstate in [FirstInvert..LastInvert])
              Then Begin
                     AType := TAnimal(GetStatePointer(nstate,StV,WaterCol)).PAnimalData.Animal_Type;
                     If (AType='Pelagic Invert.') Then CanMigrate := True;
                   End;

End; {CanMigrate}

{------------------------------------------------------------------------}

Function TStateVariable.StratMigration: Double;

Var OtherSegPtr: TStateVariable;
    HypVol: Double;
    HypO2 : Double;
    OSeg  : VerticalSegments;
    SaltConc, OtherSalt: Double;
    SaltGoodHere,SaltGoodThere: Boolean;
    PA    : TAnimal;
    FishHere_gm2, FishOther_gm2, Migr_gm2: Double;
    OtherSeg: TStates;

Begin
 StratMigration := 0;

 If Not IsAnimal then exit;

 TAnimal(Self).IsLeavingSeg:=False;

 If (Not CanMigrate) or (Not AllStates.Stratified) then exit;

 With AllStates do
   If VSeg=Epilimnion then OtherSeg := HypoSegment else OtherSeg := EpiSegment;

 {MIGRATE TO EQUALITY BECAUSE SYSTEM WELL MIXED}
 With AllStates do
   If IsFish and LinkedMode and WellMixed then {3-5-2008}
     Begin  {in well mixed stratified linked-mode systems, fish migrate to equality on g/m2 basis}
       FishHere_gm2 :=  State / Location.Locale.SurfArea * Volume_Last_Step;
            {g/m}       {g/m3}                {m2}              {m3}

       OtherSegPtr := OtherSeg.GetStatePointer(NState,SVType,Layer);
       FishOther_gm2 := OtherSegPtr.State / OtherSeg.Location.Locale.SurfArea * OtherSeg.Volume_Last_Step;
            {g/m}          {g/m3}                                      {m2}                  {m3}

       Migr_gm2 := ((FishOther_gm2 + FishHere_gm2)/2)  - FishHere_gm2;

       StratMigration := Migr_gm2 * Location.Locale.SurfArea / Volume_Last_Step;
        {g/m3}           {g/m2}                      {m2}            {m3}
       Exit;
     End;

 {MIGRATE DUE TO OXYGEN}
 With AllStates do
 If VSeg=Epilimnion
   then HypO2 := HypoSegment.GetState(Oxygen,StV,WaterCol)
   else HypO2 := GetState(Oxygen,StV,WaterCol);

 PA := GetStatePointer(NState,StV,WaterCol);
 If HypO2 <= PA.PAnimalData.O2_EC50growth then
   BEGIN
     With AllStates do
      If VSeg=Epilimnion then
          With Location.Morph do
            begin
              OtherSegPtr := HypoSegment.GetStatePointer(NState,SVType,Layer);
              HypVol := SegVolum[Hypolimnion];
              StratMigration :=((OtherSegPtr.State*HypVol)/SegVolum[Epilimnion] );
              {  Add Hypolimnion Conc. to Epilimnion after translating to
                 correct concentration (different volumes in Epi and Hypo) }
            end
        else {vseg = Hypolimnion}
          Begin
            StratMigration := - State;
            TAnimal(Self).IsLeavingSeg:=True;     {only use this boolean when 100% of animals are leaving}
          End;

      Exit;  {IF Migrating due to oxygen, no migration due to salinity}
   END;

 {MIGRATE DUE TO SALINITY} {5-30-08}
  SaltConc := GetState(Salinity,StV,WaterCol);
  SaltGoodHere := (SaltConc > TAnimal(Self).PAnimalData.SalMin_Ing) and
                  (SaltConc < TAnimal(Self).PAnimalData.SalMax_Ing);

  With AllStates do
    If VSeg=Epilimnion
      then OtherSalt := HypoSegment.GetState(Salinity,StV,WaterCol)
      else OtherSalt := EpiSegment.GetState(Salinity,StV,WaterCol);
  SaltGoodThere := (OtherSalt > TAnimal(Self).PAnimalData.SalMin_Ing) and
                   (OtherSalt < TAnimal(Self).PAnimalData.SalMax_Ing);

  If SaltGoodThere and Not SaltGoodHere then
    Begin
      StratMigration := -State;           {migrate out of this segment to a better environment}
      TAnimal(Self).IsLeavingSeg:=True;   {only use this boolean when 100% of animals are leaving}
    End;

  If SaltGoodHere and Not SaltGoodThere then
    With AllStates do with Location.Morph do
      begin
        OtherSegPtr := OtherSeg.GetStatePointer(NState,SVType,Layer);
        If VSeg=Epilimnion then OSeg:=Hypolimnion else OSeg := Epilimnion;
        StratMigration :=((OtherSegPtr.State*SegVolum[OSeg])/SegVolum[VSeg]);
        {  Add Hypolimnion Conc. to Epilimnion after translating to
           correct concentration (different volumes in Epi and Hypo) }
      end

End;  {StratMigration}


{TSTATEVARIABLE IDENTIFICATION METHODS 9/13/98 jsc}

Function TStateVariable.IsPlant:Boolean;
Begin
  IsPlant := (nstate in [FirstPlant..LastPlant]) and (SVType = StV);
End;

Function TStateVariable.IsMacrophyte:Boolean;
Begin
  IsMacrophyte := (nstate in [FirstMacro..LastMacro]) and (SVType = StV);
End;


Function TStateVariable.IsAlgae:Boolean;
Begin
  IsAlgae := (nstate in [FirstAlgae..LastAlgae]) and (SVType = StV);
End;

Function TStateVariable.IsAnimal:Boolean;
Begin
  IsAnimal := (nstate in [FirstAnimal..LastAnimal]) and (SVType = StV);
End;

Function TStateVariable.IsFish:Boolean;
Begin
  IsFish := (nstate in [FirstFish..LastFish]) and (SVType = StV);
End;

Function TStateVariable.IsSmallFish:Boolean;
Begin
  IsSmallFish := (nstate in [SmForageFish1,SmForageFish2,SmBottomFish1,SmBottomFish2,
                             SmGameFish1..SmGameFish4]) and (SVType = StV);
End;

Function TStateVariable.IsInvertebrate:Boolean;
Begin
  IsInvertebrate := (nstate in [FirstInvert..LastInvert]) and (SVType = StV);
End;

Function TStateVariable.IsPlantOrAnimal:Boolean;
Begin
  IsPlantOrAnimal := (nstate in [FirstBiota..LastBiota]) and (SVType = StV);
End;


{TRESULTSCOLLECTION METHODS}

Constructor TResultsCollection.Init;
Begin
   Inherited Init(20,10); {TCollection}
   Headers:=THeaderColl.Init(20,10);
End;

Destructor TResultsCollection.Destroy;
Begin
  If Headers <> nil then Headers.Destroy;
  inherited Destroy;
End;


Function THeaderColl.KeyOf(Item: Pointer): Pointer;
Begin
   Keyof:=@(TResHeader(Item).SortIndex);
End;

Function THeaderColl.Compare(Key1, Key2: Pointer): Integer;
Begin
  If  LongInt(key1^)     > LongInt(key2^) then compare:=1
  else if LongInt(key1^) < LongInt(key2^) then compare:=-1
  else compare := 0;

End;

Function TResultsCollection.GetHeaderIndex(AllSt: AllVariables; Typ: T_SVType; L: T_SVLayer; PPB,ToxVar,RateVar : Boolean; BAFVar: Word; RateIndex: Integer): Integer;
Var i: Integer;
    Key :  LongInt;
Begin
  GetHeaderIndex:=-1;
  If Headers=nil then exit;

  Key := TResHeader(nil).CalcUniqueIndex(AllSt,Typ,L,PPB,ToxVar,RateVar,BAFVar,RateIndex);
  If Not Headers.Search(@key,i) then i:=-1;
  GetHeaderIndex:=i;
End;

Function TResultsCollection.CreateHeader(AllSt: AllVariables; Typ: T_SVType; L: T_SVLayer; PPB, ToxVar, RateVar : Boolean; BAFVar: Word; RtIndx: Integer;
                                            SV: PPStates;    G_SqM: Boolean;    PointIndex: Integer; RateStr: String): Integer;
{Creates a new header in the next available slot and returns the index integer}
Var NewHeader: TResHeader;
    UStr, HStr: String;
    {----------------------------------------------------------------------------------------------}
    Procedure AssignUnits;
    Var PSV: TStateVariable;
        AO: TAddtlOutput;
    Begin
      PSV:=nil;
      UStr := '';

      If RateVar then Begin
                        UStr :=  'Percent';
                        If Pos('_LIM',RateStr)>0 then Ustr := 'frac';
                        Exit; {assignunits}
                      End;

      If Not (PPB or ToxVar or (BAFVar>0)) then PSV := SV.GetStatePointer(AllSt,Typ,L);
      If PSV<>nil then UStr := PSV.StateUnit;
      If (AllSt = TSS) and (Typ = StV) then UStr := 'mg/L';
      If  (Typ in [FirstToxTyp..LastToxTyp]) and
       not (AllSt in [BuriedRefrDetr,BuriedLabileDetr])
        then Ustr:='ug/L';
      If (AllSt in [BuriedRefrDetr,BuriedLabileDetr]) then
        Begin
           If (Typ in [FirstToxTyp..LastToxTyp])
             then Ustr:='ug/m2'
             else Ustr:='g/m2';
        End;

      If (Typ=OtherOutput) then
        Begin
          AO := TAddtlOutput(AllSt);
          Case AO of
            DeltaBedHeight, DynZMeanOut, SegThick,
              Secchi, BedDepth     : UStr := 'm';
            InflowWater,DischWater : UStr := 'cu.m/d';
            Chla                   : UStr := 'ug/L';
            Tau                    : UStr := 'kg/sq.m';
            InorgDep               : UStr := 'kg/m2 d';
            Peri_Chla, Moss_Chla, BenthicChla
                                   : UStr := 'mg/sq.m';
            Phyto_Biomass, PlgInvt_Biomass
                                   : UStr := 'mg/L dry';
            TSP_Diag..PON_Dep      : UStr := 'mg/m2 d';
            InorgSed, TSS60Day     : UStr := 'mg/L';
            CaCO3p                 : UStr := 'mg/L d';
            SaltInflow, FreshInflow,
              EstEntr, EstUpperOut : UStr := 'cu.m/d';
            Peri_Biomass, MultiFishConc, NekInvt_Biomass, BInvt_Biomass, Fish_Biomass
                                   : UStr := 'g/m2 dry';
            VelocityOut, VelRiff,VelPool  : UStr := 'cm/s';
            BedDnsty               : UStr := 'g/cm3';
            PctEmbedded, PctEPT, PctChiro    : UStr := '%';
            PctEphemeroptera, PctTrichoptera, PctPlecoptera, PctEunotia : UStr := '%';
            FracWatr, FracLitOut, PtoR_Out : UStr := 'frac';
            BtoP_Out               : UStr := 'days';
            BedVlm,MeanVol         : UStr := 'cu.m';
            TN, TP, BODout,NH3UnIon, MinOxygen, MaxOxygen, O2FluxOut, MinNH3UnIon, MaxNH3Union : UStr := 'mg/L';
            O2Duration             : Ustr := 'days';
            RetTime,PhytoResTime   : Ustr := 'days';
            SOD_OUT, NPP_Out, GPP_Out,CommResp_Out : Ustr := 'gO2/m2 d';
            PctBlGrPhyto,SteinAnim,SteinPlant,SteinInvert,SteinAll: Ustr := '%';
            PctAmphipods, PctGastropods, PctBivalves, PctBlGrPeri,
              PctDiatomsPhyto, PctGreensPhyto, PctOtherPhyto,
              PctOligochaete, PctDiatomsPeri, PctGreensPeri : Ustr := '%';
            PFluxDiagenesis        : UStr := 'kg';
          End; {Case}
        End;

      If ToxVar then
        Begin
          AO := TAddtlOutput(AllSt);
          Case AO of
            NonDissocOut           : UStr := 'frac.';
            THalfLife, DT50Water, DT95Water,
            Dt50Sed, Dt95Sed       : UStr := 'days';
            ToxLoading, TotalTox,
              MultiFishTox         : UStr := 'ug/L';
            MultiFishPPB,BirdConc  : UStr := 'ug/kg wet';
            TOrgSedPPB             : UStr := 'ug/kg dry';
            TotTLoss..TFishing     : Ustr := 'kg';
            TotalToxMass, NSediment: Ustr := 'kg';
            TotNMass..NLayerNet    : UStr := 'kg';
            NSorbCaCO3,NFishing    : UStr := 'kg';
            BoundaryCond           : UStr := 'kg/timestep';
          End; {Case}
        End;

      If BafVar= 1 then Ustr := 'log10BAF lipid';
      If BafVar= 2 then Ustr := 'log10BAF wet';
      If BafVar= 3 then Ustr := 'L/kg d';   // k1
      If BafVar= 4 then Ustr := '1/d';      // k2
      If BafVar= 5 then Ustr := 'L/kg';     // BCF
      If(BAFVar=6) or
        (BAFVar=7) then Ustr := 'g/g';      // N or P to organic matter

      If PPB    then begin
                       If (AllSt in [SedmRefrDetr..SuspLabDetr, Cohesives..NonCohesives2, POC_G1..POC_G3])
                          then UStr := 'ug/kg dry'  {sediments}
                          else UStr := 'ug/kg wet'; {organisms}
                     end;
     If G_SqM  then UStr := 'g/m2 dry';

     If (L>WaterCol) and (Not PPB) then
       Begin
         If AllSt in [PoreWater..LaDOMPore]
           then
             Begin
               If Typ=StV then
                           Begin
                             If AllSt=PoreWater then Ustr := 'm3/m2';
                           End
                        else Ustr := 'ug/L'
             End
           else
             Begin
               If AllSt in [ammonia,nitrate,phosphate,silica..POP_G3] then exit; {diagenesis vars units}
               If Typ=StV then Ustr := 'g/sq.m'
                          else If (Typ<>OtherOutput) then Ustr := 'ug/sq.m'
             End;
       End; {If L>WaterCol}

    End;
    {----------------------------------------------------------------------------------------------}
Begin
  CreateHeader:=Headers.Count;

  HStr := OutputText(AllSt,Typ,L,SV.UniqueName(AllSt),PPB,ToxVar,BAFVar);
  If RateVar then HStr := HStr + ' '+RateStr;

  AssignUnits;

  NewHeader := TResHeader.Init(AllSt,Typ,L,PPB,ToxVar,RateVar,BAFVar,RtIndx,HStr,UStr,PointIndex);
  Headers.Insert(NewHeader);
End;


Function TResultsCollection.GetState(AllSt: AllVariables; Typ: T_SVType; L: T_SVLayer;
         PPB, ToxVar, RateVar : Boolean; BAFVar: Word; RateIndex: Integer; Date:TDateTime; Hourly: Boolean): Double;
Var PH: TResHeader;
    PR: TResults;
    ResIndex, PntIndex: Integer;

Begin
  GetState := -1;
  PH := Headers.At(GetHeaderIndex(AllSt,Typ,L, PPB,ToxVar,RateVar,BAFVar, RateIndex));

  ResIndex := GetResIndex(Date, Hourly);
  If ResIndex < 0 then exit;
  PR := At(ResIndex);
  PntIndex := PH.PointIndex;

  GetState := TDataPoint(PR.DataPoints.At(PntIndex)).State;
End;

Function TResultsCollection.GetResIndex(Date: TDateTime; Hourly: Boolean): Integer;

{Finds the index of the given date.  Returns -1 if the date is before
 all existant dates -2 if the date is after all existent dates and
 -3 if the date doesn't exist.

 Assumes that Results collection is sorted from lowest to highest date.
 In current implementation, that assumption is valid.  JSC (2/6/97)}

Var Loop: Integer;
Begin
  If Int(Date)<Int(TResults(At(0)).Date) then GetResIndex:=-1
  else if Int(Date)>Int(TResults(At(Count-1)).Date) then GetResIndex:=-2
  else Begin
         GetResIndex:=-3;
         For Loop:=0 to Count-1 do
            If ((Not Hourly) and (Int(Date)=Int(TResults(At(Loop)).Date))) or
               (Hourly and (Int(24*Date)=Int(24*TResults(At(Loop)).Date))) then
               begin
                 GetResIndex:=Loop;
                 Break;
               end;
       End;
End;


{TResHeader METHODS}
Constructor TResHeader.Init(AllSt: AllVariables; Typ: T_SVType; L:T_SVLayer ;PP, TV, RV : Boolean; BF: word; RI: Integer; HStr,Unt: String; PI: Integer);
Begin
  AllState:= AllSt;
  SVType  := Typ;
  Layer   := L;
  HeadStr := HStr;
  UnitStr := Unt;
  PPB     := PP;
  ToxVar  := TV;
  BAFVar  := BF;
  RateVar := RV;
  PointIndex := PI;
  RateIndex := RI;
  SortIndex := CalcUniqueIndex(AllSt,Typ,L,PP,TV,RV,BF,RI);
End;

Function TResHeader.CalcUniqueIndex(AllSt: AllVariables; Typ: T_SVType; L:T_SVLayer; PP, TV, RV : Boolean; BAFFlg: Word; RtIndex: Integer): LongInt;
{ Creates a unique index by which to sort all headers in order of their output}
{ There cannot be more than 199 AllStates or more than 49 SVTypes for this to work}
Var UI: LongInt;
Begin
  UI := (Ord(AllSt)+1) + (Ord(Typ)+1)*200 + (Ord(L)+1)*200*50;
  If PP then UI:=UI+(200*50*20);
  If TV then UI:=UI+(200*50*20*2);
  If BAFFlg=1 then UI:=UI+(200*50*20*4);
  If BAFFlg>1 then UI:=UI+(200*50*20*(6+BAFFlg));  // BAFFlg 2-5 results in multiplier of 8 - 11

  If RV then UI:=(UI*30)+(200*50*20*6) + RtIndex;
  CalcUniqueIndex:=UI;
End;

Function TResHeader.ListStr(DBFList: Boolean): String;
Var NameStr: String;
Begin
  NameStr:=HeadStr;
   If (UnitStr<>'') {and (not PPB) and (BAFVar=0) } then
      If DBFList then NameStr := NameStr + '_' + UnitStr
                 else NameStr := NameStr + ' (' + UnitStr + ')';
  ListStr := NameStr;
End;



{TRESULT METHODS}

Constructor TResults.Init(RDate: TDateTime; Fnl: Boolean);
Begin
   Date:=RDate;
   Final := Fnl;
   DataPoints:=TCollection.Init(50,50);
End;

Destructor TResults.Destroy;
Begin
   If DataPoints<>nil then DataPoints.Destroy;
   inherited;
End;


Function TResults.GetIndex(NS: AllVariables; Typ: T_SVType; L:T_SVLayer; PPB,ToxVar,RateVar: Boolean; BAFVar: word; RI: Integer;
                           Var RC: TResultsCollection): Integer;

Var HeaderIndex: Integer;
    PH: TResHeader;
begin
  GetIndex:=-1;
  HeaderIndex := RC.GetHeaderIndex(NS,Typ,L,PPB,ToxVar,RateVar,BAFVar,RI);
  If HeaderIndex=-1 then exit;

  PH := RC.Headers.At(HeaderIndex);
  GetIndex:=PH.PointIndex;
end;


{TDATAPOINT METHODS}

Constructor TDataPoint.Init(AllSt : AllVariables; Typ : T_SVType; L:T_SVLayer;
                            St    : Double; PPB, ToxVar, RateVar : Boolean; BAFFlag: word; RI: Integer;
                            RC    : TResultsCollection;  SV    : TStates;
                            G_SqM : Boolean;  PI: Integer; RateStr: String);

Var Index: Integer;
Begin
   Index := RC.GetHeaderIndex(AllSt,Typ,L,PPB,ToxVar,RateVar,BAFFlag,RI);
   If Index=-1 then RC.CreateHeader(AllSt,Typ,L,PPB,ToxVar,RateVar,BAFFlag,RI,@SV,G_SqM,PI,RateStr);
   State:=St;
End;


Constructor TDataPoint.Init_Header_Exists(St: Double);
Begin
   State:=St;
End;

Constructor TRate.Init(Nm : String);
Var Stp: Integer;
Begin
  Name := Nm;
  For Stp := 0 to 6 do
    Rate[Stp] := 0;
End;

Function TRate.GetRate: Double;
Begin
  Try
  GetRate := (C1*Rate[1]+C3*Rate[3]+C4*Rate[4]+C6*Rate[6]);
  Except
    GetRate := 0;
  End;
End;

{-------------------------------------------------------}

constructor TVolume.Init(Ns : StateVariables; Typ: T_SVType; aName : ShortString; P : TStates;
                         IC : double; IsTempl: Boolean);
begin
   inherited Init(Ns,Typ,WaterCol,aName,P,IC, IsTempl);
   Inflow:=0;
   Discharg:=0;
   InflowLoad:=0;
   DischargeLoad:=0;
   OOSDischFracLoad:=1;
   OOSInflowFracLoad:=1;
   KnownValueLoad:=0;
   Calc_Method:= KeepConst;
   StratInflow:=FtBoth;
   StratOutflow:=FTBoth;
   StratAutomatically := True;
   StratDates  := TLoadings.Init(10,50);
end;

Destructor TVolume.Destroy;
Begin
  StratDates.Destroy;
  inherited;
End;

Function TVolume.Manning_Volume: Double;
{ WATER VOLUME (using Manning's eq.) in cu/m }
Var Q, Y, Width, CLength: Double;
Begin

  With Location.Locale do
    CLength := SiteLength * 1000;
      {m}       {km}       {m/km}

  { AVERAGE FLOW DISCHARGE }
   Q := Discharg / 86400;
  {m3/s} {m3/d}    {s/d}

   With Location.Locale do
     Width   := SurfArea / (SiteLength * 1000);
      {m}        {sq.m}         {km}    {m/km}

   With Location.Locale do
     Y   := POWER(Q  * AllStates.ManningCoeff / (Sqrt(Channel_Slope)*Width) , 3/5);
    {m}         {m3/s}             {s/ m^1/3}              {m/m}       {m}

   Manning_Volume := Y * Clength * width;
      {cu. m}       {m}     {m}     {m}
End;

{ THIS PROCEDURE (VolFrac) ONLY USED IN BATHYMETRY MODE, NOT FOR RIVERS }

Function TVolume.VolFrac(Z, ZMx, P : double) : double;
Var ZZMax3 : Double;
Begin
   IF P = -3.0 THEN
      P :=  - 2.99; { to avoid zero divide }
   ZZMax3 := POWER(Z/ZMx, 3.0);
   VolFrac := (6.0*Z/ZMx - 3.0*(1.0 - P)*(Z/ZMx)*(Z/ZMx)
   {fraction       m  m          unitless  m   m    m   m }
               - 2.0*P*ZZMax3)/(3.0 + P);
               {unitless               }
  { assuming generalized morphometry }
End; { volfrac }

{------------------------------------------------------------------------------------------------}

Function TVolume.ResidFlow: Double;
Begin
  ResidFlow := Loading - Evaporation;  {Load = Inflow load + Direct Precip + PS. + N.P.S.}
   {m3/d}      {m3/d}     {m3/d}
End;

{------------------------------------------------------------------------------------------------}

Procedure TVolume.DeltaVolume;

{************************************************************************************************}
{*                                                                                              *}
{*  This procedure replaces DeltaMorph as of 12-9-99.                                           *}
{*                                                                                              *}
{*  This procedure ensures all dynamic Morph data is properly set, including:                   *}
{*         Volume, InflowH2O, Discharge, ZMix, MeanThick, TotDischarge                          *}
{*                                                                                              *}
{*  Other Morph variables are not dynamic over a study run, such as                             *}
{*         P_Shape, ECoeffWater.  They are not modified by this Procedure              *}
{*                                                                                              *}
{*  DeltaVolume is called whenever the Volume S.V. or Volume Loadings Data have changed         *}
{*                                                                                              *}
{************************************************************************************************}


Var OtherSeg: VerticalSegments;
    OtherPV : TVolume;
    Avg_Disch,WidthCalc, Channel_Depth: Double;

    {----------------------------------------------------------}
    Procedure EstuaryDeltaVolume;
    Var PV: TVolume;
        Frac_Up: Double;
    Begin
      PV := GetStatePointer(Volume,StV, WaterCol);

    With AllStates do with Location do with Morph do
      Begin
        if VolFrac_Last_Step > 0 then Frac_Up := VolFrac_Last_Step
                                 else Frac_Up := PV.FracUpper;
        MeanThick[Epilimnion]   :=  DynamicZMean * Frac_Up;  {ThickUpper}
        MeanThick[Hypolimnion]  :=  DynamicZMean * (1-Frac_Up);  {ThickLower}
        SegVolum [Epilimnion]  := Frac_Up * Volume_Last_Step;
        SegVolum [Hypolimnion] := (1-Frac_Up) * Volume_Last_Step;
        InflowH2o[Epilimnion]  := PV.ResidFlow;
        InflowH2o[Hypolimnion] := PV.SaltwaterInflow;
        Discharge[Epilimnion]  := PV.UpperOutflow;
        Discharge[Hypolimnion] := 0; {entrainment to upper layer is = PV.SaltwaterInflow };
        OOSDischFrac     := 1; {OOSDischFracLoad;}
        OOSInflowFrac    := 1; {OOSInflowFracLoad;}
      End;
    End;
    {----------------------------------------------------------}

Begin
  If AllStates.EstuarySegment then Begin EstuaryDeltaVolume; Exit; End;

    If Location.SiteType = TribInput then with AllStates do with Location do with Morph do
                Begin SegVolum[VSeg]   := 1000;
                      Discharge[VSeg]  := Discharg;
                      MeanThick[VSeg]  := SegVolum[VSeg]/Locale.SurfArea;
                      OOSDischFrac     := 1; {OOSDischFracLoad;}
                      OOSInflowFrac    := 1; {OOSInflowFracLoad;}
                      InflowH2O[VSeg]  := Discharg;
                      Volume_Last_Step := 1000;
                      Exit;  {TribInput vol arbitrary but must be > 0}
                End;

  If State<Tiny then State:=0; {Volume cannot be negative}
  With AllStates do with Location do with Morph do
   Begin
    OOSDischFrac := 1;
    OOSInflowFrac := 1;
    If Stratified then
      Begin
        If LinkedMode {with segments linked together}
          then
            Begin
              If VSeg=Epilimnion then OtherSeg := Hypolimnion
                                 else OtherSeg := Epilimnion;
              If VSeg=Epilimnion then OtherPV  := HypoSegment.GetStatePointer(Volume,StV,WaterCol)
                                 else OtherPV  := EpiSegment.GetStatePointer(Volume,StV,WaterCol);

              SegVolum[VSeg]      := Volume_Last_Step;
              SegVolum[OtherSeg]  := OtherPV.AllStates.Volume_Last_Step;
              Discharge[VSeg]     := Discharg;
              OOSDischFrac        := OOSDischFracLoad;
              OOSInflowFrac       := OOSInflowFracLoad;
              Discharge[OtherSeg] := OtherPV.Discharg;
              InflowH2O[VSeg]     := Inflow;
              InflowH2O[OtherSeg] := OtherPV.Inflow;
              MeanThick[VSeg]     := SegVolum[VSeg]/Locale.SurfArea;
              MeanThick[OtherSeg] := OtherPV.State/OtherPV.Location.Locale.SurfArea;
            End
          else {not linked mode but stratified}
            Begin
              SegVolum [Epilimnion]  := Volume_Last_Step * VolFrac(MaxEpiThick, Locale.ZMax, P_Shape);  {no stratification if not UseBathymetry}
              SegVolum [Hypolimnion] := Volume_Last_Step - SegVolum[Epilimnion];  {cu. m}
              MeanThick[Epilimnion]  := SegVolum[Epilimnion]/Locale.SurfArea;
              MeanThick[Hypolimnion] := SegVolum[Hypolimnion]/ThermoclArea;

              Case StratOutflow of
                 FtBoth: Begin Discharge[Epilimnion]  := Discharg * (SegVolum[Epilimnion]  /(SegVolum[Epilimnion] + SegVolum[Hypolimnion]));
                               Discharge[Hypolimnion] := Discharg * (SegVolum[Hypolimnion] /(SegVolum[Epilimnion] + SegVolum[Hypolimnion]));
                         End;
                 FtEpi: Begin Discharge[Epilimnion]  := Discharg;
                              Discharge[Hypolimnion] := 0;
                        End;
                 FtHyp: Begin Discharge[Epilimnion]  := 0;
                              Discharge[Hypolimnion] := Discharg;
                        End;
              End; {case}

              Case StratInflow of
                 FtBoth: Begin InflowH2O[Epilimnion]  := Inflow * (SegVolum[Epilimnion]  /(SegVolum[Epilimnion] + SegVolum[Hypolimnion]));
                               InflowH2O[Hypolimnion] := Inflow * (SegVolum[Hypolimnion] /(SegVolum[Epilimnion] + SegVolum[Hypolimnion]));
                         End;
                 FtEpi: Begin InflowH2O[Epilimnion]  := Inflow;
                              InflowH2O[Hypolimnion] := 0;
                        End;
                 FtHyp: Begin InflowH2O[Epilimnion]  := 0;
                              InflowH2O[Hypolimnion] := Inflow;
                        End;
              End; {case}
            End;
      End {if Stratified} 
    Else
      Begin {not Stratified}
        SegVolum[Epilimnion]  := Volume_Last_Step;

        If LinkedMode or (not Locale.UseBathymetry)
          then SegVolum[Hypolimnion] := 0
          else SegVolum[Hypolimnion] := State - (State * VolFrac(MaxEpiThick, Locale.ZMax, P_Shape));
                                         {If Hyp was to exist, used for CalcVertDisp}

        If LinkedMode then
          Begin
            OOSDischFrac := OOSDischFracLoad;
            OOSInflowFrac := OOSInflowFracLoad;
          End;
        MeanThick[Epilimnion]  := DynamicZMean;
        MeanThick[Hypolimnion] := 0.0;
        Discharge[Epilimnion]  := Discharg;
        Discharge[Hypolimnion] := 0;
        InflowH2O[Epilimnion]  := Inflow;
        InflowH2O[Hypolimnion] := 0;
      End;  {not stratified}

    TotDischarge:=Discharge[Epilimnion] + Discharge[Hypolimnion];

  End; {Withs}

  With Location.Morph do
    If (not AllStates.LinkedMode) or (AllStates.AutoCalcXSec)
        Then
          Begin
            If (Location.SiteType=Stream)
                then With Location.Locale do
                  Begin
                    WidthCalc :=  SurfArea / (SiteLength * 1000);
                       {m}         {sq.m}        {km}   {m/km}

                    Avg_Disch := Location.Discharge[AllStates.VSeg] / 86400;
                    Channel_Depth := POWER(Avg_Disch * AllStates.ManningCoeff / (Sqrt(Channel_Slope)*WidthCalc) , 3/5);

                    XSecArea := WidthCalc * Channel_Depth;
                       {m2}       {m}           {m}
                  End
                else XSecArea := AllStates.Volume_Last_Step / (Location.Locale.SiteLength * 1000);
                                                 {m3}                            {km}      {m/km}
          End
        Else XSecArea := AllStates.XSecData.GetLoad(AllStates.TPresent,True);

End;

Procedure TVolume.Calculate_Linked_Inflow(TimeIndex: double);
Var i: Integer;
    PLnk: TSegmentLink;
    OOSInflow: Double;
Begin
     With AllStates do
      Begin
       {InflowLoad includes flow entered on volume screen (unmodeled upstream areas)}
        With LoadsRec do
          Begin
            If Alt_UseConstant[PointSource]  {Pointsource is inflow in this case}
              then InflowLoad := (Alt_ConstLoad[PointSource]*  Alt_MultLdg[PointSource])
              else if Alt_Loadings[PointSource]<>nil
                   then InflowLoad:=(Alt_Loadings[PointSource].GetLoad(TimeIndex,True) * Alt_MultLdg[PointSource]);
          End;

         OOSInflow := InflowLoad;   // inflow from inflow screen only -- associated with loadings

        {It also includes inflow from upstream feedback links}
        For i:=0 to In_FB_Links.Count-1 do
          Begin
            PLnk := In_FB_Links.At(i);
            InflowLoad := InflowLoad + PLnk.GetWaterFlow(TimeIndex);
          End;

        {It also includes inflow from upstream cascade links}
        For i:=0 to In_Cs_Links.Count-1 do
          Begin
            PLnk := In_Cs_Links.At(i);
            InflowLoad := InflowLoad + PLnk.GetWaterFlow(TimeIndex);
          End;

        If InflowLoad=0 then OOSInflowFracLoad := 0
                        else OOSInflowFracLoad := OOSInflow/InflowLoad;
     End; {with allstates}
End;



Procedure TVolume.CalculateLinkedDischarge(TimeIndex : double);
Var i: Integer;
    PLnk: TSegmentLink;
    OOSLoad: Double;
Begin
  DischargeLoad := 0;

  {DischargeLoad includes outflow to unmodeled downstream areas (entered in "volume" screen)}
  With LoadsRec do   {No links so use Outflow Water Loading that was input by user}
    Begin
      If Alt_UseConstant[DirectPrecip]  {DirecPrecip is discharge in this case}
        then DischargeLoad := (Alt_ConstLoad[DirectPrecip]*  Alt_MultLdg[DirectPrecip])
        else if Alt_Loadings[DirectPrecip]<>nil
             then DischargeLoad:=(Alt_Loadings[DirectPrecip].GetLoad(TimeIndex,True) * Alt_MultLdg[DirectPrecip]);
    End;

  OOSLoad := DischargeLoad;   {track water flowing out of system (OOS) for toxicant loss}

  With AllStates do
    Begin
      {It also includes outflow to downstream feedback links}
      For i:=0 to Out_FB_Links.Count-1 do
        Begin
          PLnk := Out_FB_Links.At(i);
          DischargeLoad := DischargeLoad + PLnk.GetWaterFlow(TimeIndex);
        End;
      {It also includes outflow to downstream cascade links}
      For i:=0 to Out_Cs_Links.Count-1 do
        Begin
          PLnk := Out_Cs_Links.At(i);
          DischargeLoad := DischargeLoad + PLnk.GetWaterFlow(TimeIndex);
        End;
    End;

  If DischargeLoad=0 then OOSDischFracLoad := 0
                     else OOSDischFracLoad := OOSLoad/DischargeLoad;
End;

Procedure TVolume.CalculateLoad(TimeIndex : double);
{This Procedure gets Inflow loadings from Water Volume screen.
 Discharge & KnownValue "loadings" are also copied if they are relevant}

    {--------------------------------------------------------------------------}
    Procedure EstuaryVolumeCalcLoad;
    Var Loop      : Alt_LoadingsType;
        AddLoad   : Double;
      Begin
        With LoadsRec do
          Begin
            Inherited CalculateLoad(TimeIndex); {TStateVariable} {Inflow Load in m3/d}

             For Loop:=PointSource to NonPointSource do
               Begin
                 AddLoad:=0;
                 If Alt_UseConstant[Loop]
                   then AddLoad := Alt_ConstLoad[Loop]  {m3/d}
                   else if Alt_Loadings[Loop]<>nil then AddLoad := Alt_Loadings[Loop].GetLoad(TimeIndex,True);

                   AddLoad := AddLoad * Alt_MultLdg[Loop];
                   {m3/d}     {m3/d}     {unitless}

                   Loading:=Loading + AddLoad;
                    {m3/d}  {m3/d}     {m3/d}
                 End; {Loop}
          End; {With}
      End;
    {--------------------------------------------------------------------------}

Begin
  If AllStates.EstuarySegment then
    Begin
      EstuaryVolumeCalcLoad;
      Exit;
    End;

  InflowLoad := 0;
  DischargeLoad:=0;
  OOSDischFracLoad  := 1;
  OOSInflowFracLoad := 1;

  If AllStates.LinkedMode and (Calc_Method=Dynam)  {segments linked together}
    then
      Begin
        Calculate_Linked_Inflow(TimeIndex);
        CalculateLinkedDischarge(TimeIndex);
      End
    else {not Linked Mode or "calibration" linked mode}
      With LoadsRec do
        Begin
          {Calculate Inflow}
          If not (Calc_Method = Manning) then
            Begin
              If Alt_UseConstant[PointSource]  {Pointsource is inflow in this case}
                then InflowLoad := (Alt_ConstLoad[PointSource]*  Alt_MultLdg[PointSource])
                else if Alt_Loadings[PointSource]<>nil
                     then InflowLoad:=(Alt_Loadings[PointSource].GetLoad(TimeIndex,True) * Alt_MultLdg[PointSource]);
            End;

          {Calculate Discharge}
          If Calc_Method in [Dynam,Manning] then
            Begin
              If Alt_UseConstant[DirectPrecip]  {DirecPrecip is discharge in this case}
                then DischargeLoad := (Alt_ConstLoad[DirectPrecip]*  Alt_MultLdg[DirectPrecip])
                else if Alt_Loadings[DirectPrecip]<>nil
                     then DischargeLoad:=(Alt_Loadings[DirectPrecip].GetLoad(TimeIndex,True) * Alt_MultLdg[DirectPrecip]);
            End;
        End; {with}

  {Calculate Known Value}
  KnownValueLoad:=0;
  If Calc_Method=KnownVal then
    KnownValueLoad := LoadsRec.Loadings.GetLoad(TimeIndex,True) * LoadsRec.MultLdg;

  DeltaVolume;
End; {Procedure}



Function TVolume.Evaporation: Double;
Var EpiFrac: Double;

Begin
  With AllStates do
   If UseConstEvap then
     Begin
      If LinkedMode and (VSeg=Hypolimnion) then Evaporation := 0
        else With Location.Locale do
          Evaporation := MeanEvap * 0.0254 / 365 * SurfArea
          {cu m/d}       {in/yr}    {m/in} {d/yr}   {sq m}
     End
   Else {Use Time-Series ("dynamic") Evaporation}
     Begin
       Evaporation := DynEvap.GetLoad(TPresent,True);  {cu m/d}
       If Stratified and not LinkedMode then
         Begin
            With Location do with Locale do
            EpiFrac := AreaFrac(MeanThick[Epilimnion],ZMax);
            If VSeg = Epilimnion then Result := Result * EpiFrac
                                 else Result := Result * (1-EpiFrac);

         End;
     End;
End;


(***********************************)
(* water temperature of segment    *)
(* Ward 1963, ASCE 1989, 6:1-16    *)
(***********************************)
Procedure TTemperature.CalculateLoad(TimeIndex : double);
{Changes State, not Loadings... Rewritten JSC, 22-May-95}
Const PhaseShift = 90;
Var Temperature : Double;
    MeanTemp, TempRange: Double;
    AdjustedJulian: Double; {Julian date adjusted for hemisphere}

Begin
  With LoadsRec do
  begin
    {allows for user input of load, jsc}
    If Not NoUserLoad then
      begin
        If (AllStates.VSeg=Epilimnion)
        or (AllStates.HypoTempLoads.NoUserLoad)
           then Inherited CalculateLoad(TimeIndex) {TStateVariable}
           else {hypolimnion: User entered data}
             With AllStates.HypoTempLoads do
               Begin
                 If UseConstant then Loading:=ConstLoad
                 else
                   begin
                     Loading:=0;
                     if Loadings<>nil then
                        Loading:=Loadings.GetLoad(TimeIndex,True);
                   end;  {else}
                   Loading:=Loading*MultLdg;
               End; {With HypoTempLoads}
          State:=Loading;
      end {if userload}

    Else {NoUserLoad for both Epi and Hypo Temp Loadings}
      begin
        AdjustedJulian := JulianDate(TimeIndex);
        If Location.Locale.Latitude < 0.0 then AdjustedJulian := AdjustedJulian + 182;

        MeanTemp := Location.Locale.TempMean[AllStates.VSeg];
        TempRange := Location.Locale.TempRange[AllStates.VSeg];

        If AllStates.LinkedMode then
          Begin    {MeanTemp and Range are stored in "Epilimnion" for each linked segment regardless of stratification}
            MeanTemp := Location.Locale.TempMean[Epilimnion];
            TempRange := Location.Locale.TempRange[Epilimnion];
          End;

        Temperature := MeanTemp + (-1.0 * TempRange/2.0
                     * (SIN(0.0174533 * (0.987 * (AdjustedJulian + PhaseShift) -30))));
        if Temperature < 0.0 then Temperature := 0.0;
        Temperature := Temperature*MultLdg; {allow perturbation JSC 1-23-03}

        State:=Temperature;
      end;

    Loading:=0;
  End; {With LoadsRec}
end;


Constructor TLight.Init(Ns :StateVariables; SVT: T_SVType; Lyr: T_SVLayer; aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
Begin
  inherited; { TStateVariable.Init(Ns,SVT,Lyr,aName,P,IC,IsTempl); }
  CalculatePhotoperiod := True;
  UserPhotoPeriod      := 12;
End;

Procedure TLight.CalculateLoad(TimeIndex : double);
var adjustedjulian, lighttime, light,solar, ShadeVal, pp,fracdaypassed : double;
{Calculates light load at the top layer of the water system, modified
 later with LtTop and LtDepth which use DepthTop and DepthBottom}

begin
  With LoadsRec do
  Begin
   {allows for user input of load}
   If Not NoUserLoad then begin
                            Inherited CalculateLoad(TimeIndex); {TStateVariable}
                            Light := Loading;
                          end
      Else {NoUserLoad, calculate based on date}
        Begin
           AdjustedJulian := JulianDate(TimeIndex);
           If Location.Locale.Latitude < 0.0 then AdjustedJulian := AdjustedJulian + 182;
           Solar := Location.Locale.LightMean + Location.Locale.LightRange/2.0
                    * SIN(0.0174533 * AdjustedJulian - 1.76);
           Light := Solar {/2.0};
           if Light < 0.0 then Light := 0.0;

           Light := Light * MultLdg; {allow perturbation JSC 1-23-03}
        End;

   With AllStates do            {ACCOUNT FOR ICE COVER}
    if VSeg=Epilimnion then
      if GetState(Temperature,StV,WaterCol) < Ice_Cover_Temp then    {Aug 2007, changed from 33% to 15%}
        Light:=Light*0.15;   {Wetzel (2001).}
{       Light:=Light*0.33;   {ave. of values, Wetzel '75, p. 61, Used in Rel2.2 and before}

   ShadeVal := 1 - (0.98* ReturnLoad(TimeIndex,AllStates.Shade));  // 11/18/2009  2% of incident radiation is transmitted through canopy
   Light := Light * ShadeVal;

   State       := Light;
   DailyLight  := Light;
   HourlyLight := 0;

   IF (AllStates.PModelTimeStep^ = TSHOURLY) and
     (nouserload or (LoadsRec.UseConstant) or not (LoadsRec.Loadings.Hourly)) THEN
     BEGIN  {distribute daily loading over daylight hours}
       pp := AllStates.Photoperiod;
       FracDayPassed := TimeIndex - Trunc(TimeIndex);
       LightTime := FracDayPassed - ((1-pp)/2);
       If (FracDayPassed < (1-pp)/2) or (FracDayPassed > 1-((1-pp)/2))
         then State := 0
         else State := (Pi/2)*(Light/pp)* SIN(Pi*LightTime/pp) * MultLdg * ShadeVal;
       HourlyLight := State;
     END;

   Loading:=0;

  End; {With LoadRec}
end; {TLight.CalculateLoad}

{----------------------------------------}
{ wind, based on 140-day Missouri record }
{ computed using first 10 harmonics      }
{ therefore, will have a 140-day repeat  }
{----------------------------------------}

Constructor TWindLoading.Init(Ns :StateVariables; SVT: T_SVType; Lyr: T_SVLayer; aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
Begin
  inherited; { TStateVariable.Init(Ns,SVT,Lyr,aName,P,IC,IsTempl); }
  MeanValue :=0;
End;

Procedure TWindLoading.CalculateLoad(TimeIndex : double);

Begin
  Loading := 0;

  If GetState(Temperature,StV,WaterCol) < AllStates.Ice_Cover_Temp then
     begin
       State:=0;
       exit;
     end;

  If AllStates.Vseg=hypolimnion then begin state:=0; exit; end;
  with LoadsRec do begin
  {allows for user input of load, jsc}
  If Not NoUserLoad then
             begin
               inherited CalculateLoad(TimeIndex);  {TStateVariable}
               State:=Loading;
               exit;
             end;

  State:=CalculateWindLoading(TimeIndex,MeanValue) * MultLdg;
         {CODE IN FOURIER.INC}
  end; {with}
end;


Procedure TpHObj.CalculateLoad(TimeIndex : double);

  function asinh(x: Double):double;
  begin
    asinh:=system.ln(system.sqrt(sqr(x)+1)+x)
  end;

  { pH calculation based on Marmorek et al., 1996 (modified Small and Sutton, 1986)}
  Function pHCalc:double;
  Const pkw = 1E-14; {ionization constant water}
  Var T, CCO2, DOM, pH2CO3, Alpha, A, B, C: Double;
  Begin
    T      := AllStates.GetState(Temperature,StV,WaterCol);  {deg C}
    CCO2   := AllStates.GetState(CO2,StV,WaterCol)/44*1000; {ueq/mg}
    DOM    := AllStates.GetState(DissRefrDetr,StV,WaterCol); {mg/L}
    pH2CO3 := POWER(10,-(6.57-0.0118*T+0.00012*(SQR(T)))*0.92);
    Alpha  := pH2CO3 * CCO2 + pkw;
    A      := -log10(POWER(Alpha,0.5));
    B      := 1/LN(10);
    C      := 2*(POWER(Alpha,0.5));
    Try
      pHCalc := A + B*ASINH((Alkalinity-5.1*DOM*0.5)/C);
    Except
      phCalc := 7; {default if ASINH function crashes}
    End;

  end; {pHCalc}

Begin
 With LoadsRec do
 Begin
   {allows for user input of load, jsc}
   If Not NoUserLoad then  begin
                             inherited CalculateLoad(TimeIndex); {TStateVariable}
                             State:=Loading;
                             exit; {this proc}
                           end;

   State := phCalc;
   If (State>8.25) then State := 8.25;
   If (State<3.75) then State := 3.75;  // 9/8/2009

 End; {WithLoadsRec}
End;



Function  TStateVariable.GetState(S: AllVariables;  T: T_SVType; L:T_SVLayer) : double;
Begin
  GetState:=AllStates.GetState(S,T,L);
End;

Function  TStateVariable.GetStatePointer(S: AllVariables;  T: T_SVType; L:T_SVLayer) : pointer;
Begin
  GetStatePointer:=AllStates.GetStatePointer(S,T,L);
End;

{-------------------------------------------------------------------}

Procedure LoadCollectionItems(IsTemp: Boolean;
                              St : TStream;
                              PColl  : TCollection;
                              Sort   : Boolean;
                              ReadVersionNum: Double);

Var i,ObjID  : Integer;
    PItem    : Pointer;
    NumItems : Integer;
 {   PrevObj  : Integer; {used in debugging}

Begin
  NumItems:=PColl.Count;
  If Sort then PColl.Count:=0;
  For i:=0 to NumItems-1 do
  Begin
    WaitDlg.Tease;

{    If ObjID <> 1008 then PrevObj := ObjID; {used in debugging}
    ObjID:=0;
    St.Read(ObjID,2);

    Case ObjID of
      1001: PItem:=TAnimal.Load(IsTemp, St,ReadVersionNum);
      1002: PItem:=TPlant.Load(IsTemp, St,ReadVersionNum);
      1003: PItem:=TLoad.Load(IsTemp, St,ReadVersionNum);
      1004: PItem:=TLoadings.Load(IsTemp, St,ReadVersionNum);
      1005: PItem:=TCollection.Load(IsTemp, St,ReadVersionNum);
      1006: PItem:=TToxics.Load(IsTemp, St,ReadVersionNum);
      1007: PItem:=TStateVariable.Load(IsTemp, St,ReadVersionNum);
      1008: PItem:=TPreference.Load(IsTemp, St,ReadVersionNum);
      1009: PItem:=TFishTox.Load(IsTemp, St,ReadVersionNum);
      1010: PItem:=TResults.Load(IsTemp, St,ReadVersionNum);
      1011: PItem:=TDataPoint.Load(IsTemp, St,ReadVersionNum);
      1012: PItem:=TStateVariable.Load(IsTemp, St,ReadVersionNum);
      1013: PItem:=TTemperature.Load(IsTemp, St,ReadVersionNum);
      1014: PItem:=TWindLoading.Load(IsTemp, St,ReadVersionNum);
      1015: PItem:=TLight.Load(IsTemp, St,ReadVersionNum);
      1016: PItem:=TOrganism.Load(IsTemp, St,ReadVersionNum);
      1017: PItem:=TMacrophyte.Load(IsTemp, St,ReadVersionNum);
      1018: PItem:=TRemineralize.Load(IsTemp, St,ReadVersionNum);
      1019: PItem:=TPO4Obj.Load(IsTemp, St,ReadVersionNum);
      1020: PItem:=TNH4Obj.Load(IsTemp, St,ReadVersionNum);
      1021: PItem:=TNO3Obj.Load(IsTemp, St,ReadVersionNum);
      1022: PItem:=TSuspLabDetr.Load(IsTemp, St,ReadVersionNum);
      1023: PItem:=TSedLabileDetr.Load(IsTemp, St,ReadVersionNum);
      1024: PItem:=TSuspRefrDetr.Load(IsTemp, St,ReadVersionNum);
      1025: PItem:=TSedRefrDetr.Load(IsTemp, St,ReadVersionNum);
      1026: PItem:=TCo2Obj.Load(IsTemp, St,ReadVersionNum);
      1027: PItem:=TO2Obj.Load(IsTemp, St,ReadVersionNum);
      1028: PItem:=TParticleTox.Load(IsTemp, St,ReadVersionNum);
      1029: PItem:=TAlgae_zooTox.Load(IsTemp, St,ReadVersionNum);
      1034: PItem:=TpHObj.Load(IsTemp, St,ReadVersionNum);
      1035: PItem:=TDistribution.Load(IsTemp, St,ReadVersionNum);
      1036: PItem:=TSandSiltClay.Load(IsTemp, St,ReadVersionNum);
      1037: PItem:=TBuriedDetr1.Load(IsTemp, St,ReadVersionNum);
      1038: PItem:=TBuriedDetrTox1.Load(IsTemp, St,ReadVersionNum);
      1039: PItem:=TVolume.Load(IsTemp, St,ReadVersionNum);
      1040: PItem:=TDissRefrDetr.Load(IsTemp, St,ReadVersionNum);
      1041: PItem:=TDissLabDetr.Load(IsTemp, St,ReadVersionNum);
      1042: PItem:=TPlantToxRecord.Load(IsTemp, St,ReadVersionNum);
      1043: PItem:=TAnimalToxRecord.Load(IsTemp, St,ReadVersionNum);
      1044: PItem:=TResultsCollection.Load(IsTemp, St,ReadVersionNum);
      1045: PItem:=TResHeader.Load(IsTemp, St,ReadVersionNum);
      1046: PItem:=TBioTransObject.Load(IsTemp, St,ReadVersionNum);
      1047: PItem:=TBottomSediment.Load(IsTemp, St,ReadVersionNum);
      1048: PItem:=TPoreWater.Load(IsTemp, St,ReadVersionNum);
      1049: PItem:=TDOMPoreWater.Load(IsTemp, St,ReadVersionNum);
      1050: PItem:=TSuspSedimentTox.Load(IsTemp, St,ReadVersionNum);
      1051: PItem:=TBottomSedimentTox.Load(IsTemp, St,ReadVersionNum);
      1052: PItem:=TPoreWaterTox.Load(IsTemp, St,ReadVersionNum);
      1053: PItem:=TDOMPoreWaterTox.Load(IsTemp, St,ReadVersionNum);
      1054: PItem:=TDissDetr.Load(IsTemp, St,ReadVersionNum);
      1055: PItem:=TSuspendedDetr.Load(IsTemp, St,ReadVersionNum);
      1056: PItem:=TSedimentedDetr.Load(IsTemp, St,ReadVersionNum);
      1057: PItem:=TBottomCohesives.Load(IsTemp, St,ReadVersionNum);
      1058: PItem:=TSalinity.Load(IsTemp, St,ReadVersionNum);
      1059: PItem:=TBuriedDetr2.Load(IsTemp, St,ReadVersionNum);
      1060: PItem:=TBuriedDetrTox2.Load(IsTemp, St,ReadVersionNum);
      1061: PItem:=TSuspSediment.Load(IsTemp, St,ReadVersionNum);
      1062: PItem:=TNH4_Sediment.Load(IsTemp, St,ReadVersionNum);
      1063: PItem:=TNO3_Sediment.Load(IsTemp, St,ReadVersionNum);
      1064: PItem:=TPO4_Sediment.Load(IsTemp, St,ReadVersionNum);
      1065: PItem:=TPOC_Sediment.Load(IsTemp, St,ReadVersionNum);
      1066: PItem:=TPON_Sediment.Load(IsTemp, St,ReadVersionNum);
      1067: PItem:=TPOP_Sediment.Load(IsTemp, St,ReadVersionNum);
      1068: PItem:=TMethane.Load(IsTemp, St,ReadVersionNum);
      1069: PItem:=TSulfide_Sediment.Load(IsTemp, St,ReadVersionNum);
      1070: PItem:=TSilica_Sediment.Load(IsTemp, St,ReadVersionNum);
      1071: PItem:=TCOD.Load(IsTemp, St,ReadVersionNum);
      1072: PItem:=TPOCTox.Load(IsTemp, St,ReadVersionNum);
      1073: PItem:=T_N_Internal_Plant.Load(IsTemp, St,ReadVersionNum);


      ELSE Begin
             If (ObjID >1029) and (ObjID < 1034)
              then Raise EAQUATOXError.Create('Mercury Studies cannot be loaded')
              else Raise EAQUATOXError.Create('Tried to Load Object Not in Registry');
           End;
    end;

    If    (ObjID=1012) {Dispose of irrelevant TDriverVar, "epilimnion"}
       or ((ReadVersionNum<1.99) and ((ObjID=1037) or (ObjID=1038))) {Dispose of obsolete BuriedDetritus compartments}
      then TStateVariable(PItem).Destroy
      else If Sort then TSortedCollection(PColl).Insert(PItem)
                   else PColl.AtPut(i,PItem);

  End;
End;

{-------------------------------------------------------------------}

Procedure WriteTextCollection(Var LF      : TextFile;
                              PColl   : TCollection);
Var  P : BaseClass;
     i: Integer;
Begin
  For i:=0 to PColl.Count-1 do
  begin
    P:=PColl.At(i);
    P.WriteText(LF);
  end;
End;

{-------------------------------------------------------------------}

Procedure StoreCollectionItems(IsTemp: Boolean;
                               Var St  : Tstream;
                               PColl   : TCollection);
Var I,ObjID: Integer;
    P     : BaseClass;

Begin
  For i:=0 to PColl.Count-1 do
  begin
    P:=PColl.At(i);
    ObjID:=P.ObjectID;
    St.Write(ObjID,2);
    P.Store(IsTemp,St);
  end;
End;


{-------------------------------------------------------------------}


Procedure TStates.Overturn(StudyDestroy: Boolean);
Var i: integer;
    ns: StateVariables;
    typ, ToxLoop: T_SVType;
    Ionized: Boolean;
    Lay: T_SVLayer;
    EpiState,HypState,TotVar : Double;
    EpiVol,HypVol,TotVol : Double;
    EpiDVOl, HypDVol: Double;
    P: TOrganism;

    Function WeightedAvg(EpiValue,HypValue: double):double;
    {EpiVol, HypVol, and TotVol must be initialized before using this fn}
    begin
      WeightedAvg := (EpiValue * (EpiVol/TotVol)) +
                     (HypValue * (HypVol/TotVol)) ;
    end;

Begin  {overturn is always passed the epilimnion segment}
 TRY
  If HypoSegment=nil then exit;
  ProgData.StratVis:=False;
  ProgData.AnoxicVis:=False;

  EpiVol:=Location.Morph.SegVolum[Epilimnion];
  HypVol:=Location.Morph.SegVolum[Hypolimnion];
  TotVol:=EpiVol+HypVol;

  EpiDVol := 0; HypDVol := 0;
  IF Diagenesis_Included then
    Begin
       EpiDVol := DiagenesisVol(2);
       HypDVol := HypoSegment.DiagenesisVol(2);
    End;

  Stratified:=False;
  HypoSegment.Stratified:=False;

  SetMeanDischarge(TPresent);

  {Pass Results Back to SV}
  Results[Hypolimnion]:=Hyposegment.Results[Hypolimnion];
  Hyposegment.Results[Hypolimnion] := nil;

  {Hold on to hypolimnion rate TTable in case stratification reoccurs}
  HypTable  := HypoSegment.WriteTable;

  {Update Mass balance Variables}
  OverturnMBData;

  {Reincorporate two segments using weighted average}
  For i:=0 to count-1 do
    begin
      ns := TStateVariable(At(i)).nstate;
      typ := TStateVariable(At(i)).SVtype;
      lay := TStateVariable(At(i)).Layer;
      If not (ns in [Volume..pH]) then  {if state variable is represented by concentration}
        begin
          EpiState := TStateVariable(At(i)).state;
          HypState := TStateVariable(HypoSegment.At(i)).state;
          TStateVariable(At(i)).state:=WeightedAvg(EpiState,HypState);

          If Convert_g_m2_to_mg_L(ns,typ,lay) and not (ns in [firstfish..lastfish]) then
          With Location do
               Begin
                 TotVar := (EpiState * EpiVol + HypState * HypVol);
                 {g}         {g/m3}     {m3}     {g/m3}    {m3}
                 TStateVariable(At(i)).state := TotVar / TotVol;
                 {g/m3}                           {g}       {m3}
               End;

          If Diagenesis_Included and (lay>WaterCol) then
            Begin
              TotVar :=  EpiState * EpiDVol +  HypState * HypDVol;
               {g}      {g/m3 sed}    {m3}    {g/m3 sed}   {m3}
              TStateVariable(At(i)).state := TotVar / (DiagenesisVol(2));
              {g/m3 sed}                       {g}       {m3}
            End;
        end;
    end; {for do}

 {Reconcile PrevFracKill, Resistant, and NH4PrevFracKill using Weighted Average}
  For i:=0 to count-1 do
     begin
       P:=at(i);
       If P.IsPlantOrAnimal then
         Begin
           For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
            begin
              EpiState := P.PrevFracKill[ToxLoop];
              HypState := TOrganism(HypoSegment.at(i)).PrevFracKill[ToxLoop];
              P.PrevFracKill[ToxLoop] := WeightedAvg(EpiState,HypState);

              EpiState := P.Resistant[ToxLoop];
              HypState := TOrganism(HypoSegment.at(i)).Resistant[ToxLoop];
              P.Resistant[ToxLoop] := WeightedAvg(EpiState,HypState);
            end;

           For Ionized := False to True do
            begin
              EpiState := P.AmmoniaPrevFracKill[ionized];
              HypState := TOrganism(HypoSegment.at(i)).AmmoniaPrevFracKill[ionized];
              P.AmmoniaPrevFracKill[ionized] := WeightedAvg(EpiState,HypState);

              EpiState := P.AmmoniaResistant[ionized];
              HypState := TOrganism(HypoSegment.at(i)).AmmoniaResistant[ionized];
              P.AmmoniaResistant[ionized] := WeightedAvg(EpiState,HypState);
            end;

            EpiState := P.SedPrevFracKill;
            HypState := TOrganism(HypoSegment.at(i)).SedPrevFracKill;
            P.SedPrevFracKill := WeightedAvg(EpiState,HypState);

            EpiState := P.SedResistant;
            HypState := TOrganism(HypoSegment.at(i)).SedResistant;
            P.SedResistant := WeightedAvg(EpiState,HypState);
         End;
     end;

  Last_Datapoint_Written[Hypolimnion] := HypoSegment.Last_Datapoint_Written[hypolimnion];

  Volume_Last_Step := TotVol;

  Hyposegment.Destroy;

  TCollection(PAllSVsColl^).SavePointers;
  TCollection(PAllSVsColl^):=Self;

 Finally

  hyposegment:=nil;

 End;
End;


Procedure TStates.Check_Stratification;
{************************************}
{ See if stratification / overturn   }
{ should occur based on various cues }
{ coded by JSC                       }
{ modified by RAP, 7/22/98           }
{************************************}

Var EpiTemp,HypTemp: Double;
    SegSaver: VerticalSegments;
    EpiBenthicArea: Double;
{    VertDisp: Double; }

   { -------------------------------------------------------------------------------------}
    Procedure Initiate_Stratification;
    {This Procedure Duplicates the State Variables into HypoSegment and gets hyposegment
     ready to run by determining how much of each state variable it should
     receive}
    Var MemStream: TMemoryStream;
        AllSVColl: TCollection;
        EpiVol,HypVol: TVolume;

        Procedure DuplicateTState;
        {Duplicates TState by storing into a memory buffer and loading out of that buffer
         this takes advantage of the extensive store/load procedures to duplicate the
         large and complex object}
        Var i        : Integer;
            EpiSV   : TStateVariable;
            VersionNum: Double;
            ReadVersionNum: Double;
            { -------------------------------------------------------------------------------------}
             Procedure SetVars(psv:TStateVariable);
             Var TotSV: Double;
                 EpiToxSV, HypToxSV: TToxics;
                 TTox    : ToxicantType;
                 ToxIndex: Integer;
                 TotalTox, TotalVol: Double;
                 IsFloatingMacro, IsFloatingPhyto: Boolean;
                 PMacro: TMacrophyte;
                 TP      : TPlant;
                 Convert: Boolean;

             Begin
                psv.AllStates:=HypoSegment;
                psv.Location:=Location;
                psv.ChemPtrs:=ChemPtrs;
                psv.IsTemplate := True;

                IsFloatingMacro := False;
                If PSV.nstate in [FirstMacro..LastMacro] then
                  Begin
                    PMacro := TMacrophyte(PSV);
                    If PMacro.MacroType<>Benthic then IsFloatingMacro := True; {must be floating so concentrate in epilimnion}
                  End;


                With Location do With Locale do
                  EpiBenthicArea := (AreaFrac(MeanThick[Epilimnion],ZMax));
                BenthicArea := EpiBenthicArea;

                EpiSV := psv.AllStates.EpiSegment.GetStatePointer(psv.NState,StV,WaterCol);

                IsFloatingPhyto := False;
                If PSV.IsPlant then
                  Begin
                    TP := TPlant(PSV);
                    TP.ZOpt := TP.ZOpt;
                    If TP.PAlgalRec^.SurfaceFloating then IsFloatingPhyto := True; {concentrate in epilimnion}
                  End;

                If IsFloatingPhyto then
                  With Location do With Locale do
                  Begin
                      TotSV    := psv.State * Volume_Last_Step;
                      {g}          {g/m3}         {m3}

                      EpiSV := psv.AllStates.EpiSegment.GetStatePointer(psv.NState,StV,WaterCol);
                      EpiSV.State := TotSV  / Morph.SegVolum[Epilimnion];   // Concentrate floating phyto in eplimnion
                      {g/m3}          {g}                 {m3}

                      PSV.State := 0;  {no floating phyto in hypolimnion}
                  End;

                Convert := Convert_g_m2_to_mg_L(PSV.NState,PSV.SVType,PSV.Layer) and
                           not (PSV.NState in [FirstFish..LastFish]);

                {Split up vars that reside on bottom with units of g/m2 based on areafrac}
                If Convert then
                  With Location do With Locale do
                    Begin
                      TotSV    := psv.State * Volume_Last_Step;
                      {g}          {g/m3}         {m3}

                      If IsFloatingMacro then EpiBenthicArea := 1; {100% of floating macrophytes reside in epilimnion}

                      EpiSV := psv.AllStates.EpiSegment.GetStatePointer(psv.NState,StV,WaterCol);
                      EpiSV.State := TotSV  * EpiBenthicArea / Morph.SegVolum[Epilimnion];
                      {g/m3}          {g}       {frac}           {m3}

                      PSV.State := TotSV * (1-EpiBenthicArea) / Morph.SegVolum[Hypolimnion]; {hypolimnion calculation}
                      {g/m3}          {g}       {frac}           {m3}

                      {Split of toxicant within these variables}
                      For TTox := FirstToxTyp to LastToxTyp do
                        Begin
                          ToxIndex := GetIndex(PSV.NState,TTox,WaterCol);
                          If ToxIndex>-1 then
                            Begin
                              EpiToxSV := psv.AllStates.EpiSegment.At(ToxIndex);
                              HypToxSV := psv.AllStates.At(ToxIndex);
                              TotalVol := Morph.SegVolum[Epilimnion] + Morph.SegVolum[Hypolimnion];
                              TotalTox := EpiToxSV.State * TotalVol * 1000;
                                {ug}         {ug/L}          {m3}     {L/m3}

                              EpiToxSV.State := (TotalTox * EpiBenthicArea) / (Morph.SegVolum[Epilimnion] * 1000);
                                {ug/L}             {ug}        {frac}                {m3}                 {L/m3}

                              HypToxSV.State := (TotalTox * (1-EpiBenthicArea)) / (Morph.SegVolum[Hypolimnion] * 1000);
                                {ug/L}             {ug}       {frac}                  {m3}                     {L/m3}
                            End;
                        End;
                    End;
             End;  {SetVars}
            { -------------------------------------------------------------------------------------}
             Procedure CRC(psv:TStateVariable);
             Begin
               If psv.IsPlantOrAnimal then TOrganism(PSV).CalcRiskConc(true);
             End; {CRC}
            { -------------------------------------------------------------------------------------}
        Begin {DuplicateTState}
          MemStream:=TMemoryStream.Create;
          TeaseScreen:=False;

          StoreResults  := False;
          StoreDistribs := False;
          Store(True,TStream(MemStream));          {Store Collection in memory}
          StoreResults  := True;
          StoreDistribs := True;

          VersionNum:=StrToFloat(AbbrString(VersionStr,' '));
          ReadVersionNum:=VersionNum;         {Get Correct Version Num for Read}
          MemStream.Seek(0, soFromBeginning); {Go to beginning of stream}
          HypoSegment:=TStates.Load(False,True,TStream(MemStream),ReadVersionNum,False,False); {Load Collection from Memory}
          MemStream.Destroy;

          HypoSegment.Results[Hypolimnion] := Results[Hypolimnion];  {Pass Hyp Segment the Hyp Results}
          Results[Hypolimnion] := nil;
          HypoSegment.Results[Epilimnion] := nil;                    {Nullify the Epi Results in the Hyp Segment}

          HypoSegment.ControlResults[Epilimnion] := nil;
          HypoSegment.ControlResults[Hypolimnion] := nil;
          Hyposegment.Distributions := nil;

          HypoSegment.SetMemLocRec;
          HypoSegment.Location:=Location;
          HypoSegment.ChemPtrs:=ChemPtrs;
          HypoSegment.SetupRec:=SetupRec;
          HypoSegment.Diagenesis_Params:=Diagenesis_Params;

          HypoSegment.VSeg := Hypolimnion;
          HypoSegment.TSMessage := TSMessage;
          HypoSegment.Sed_Data := Sed_Data;
          HypoSegment.EpiSegment := Self;

          HypoSegment.Stratified          := True;
          HypoSegment.Anoxic              := Anoxic;
          HypoSegment.ProgData            := ProgData;
          HypoSegment.EstuarySegment      := EstuarySegment;

          Dispose(HypoSegment.PMessageStr);
          Dispose(HypoSegment.PMessageErr);
          HypoSegment.PMessageStr := PMessageStr;
          HypoSegment.PMessageErr := PMessageErr;

          HypoSegment.LastCalcEstVel:=0;
          HypoSegment.LastTimeEstVel:=0;  {velocity calc is not up-to-date}
          HypoSegment.LastWellMixedTime := -99;

          HypoSegment.LastPctEmbedCalc := LastPctEmbedCalc;
          HypoSegment.PercentEmbedded  := PercentEmbedded;

          HypoSegment.TimeLastGullConc := TimeLastGullConc;
          HypoSegment.GullConcLastStep := GullConcLastStep;
          HypoSegment.SOD := SOD;

          {Copy Time Data}
          HypoSegment.TPresent            := TPresent;
          HypoSegment.TPreviousStep       := TPreviousStep;
          HypoSegment.PModelTimeStep      := New(PTimeStepType);
          HypoSegment.PModelTimeStep^     := PModelTimeStep^;
          HypoSegment.ModelStartTime      := ModelStartTime;
          HypoSegment.YearNum_PrevStep    := YearNum_PrevStep;

          HypoSegment.MeanVolume          := MeanVolume;
          HypoSegment.MeanEstVel          := MeanEstVel;
          HypoSegment.Volume_Last_Step    := Volume_Last_Step;  {OVERALL SYSTEM VOLUME}
          HypoSegment.VolFrac_Last_Step   := -99;   {don't calculate dilute/conc due to strat.}
          VolFrac_Last_Step   := -99;               {don't calculate dilute/conc due to strat.}

          HypoSegment.TimeLastGullConc := -99;
          HypoSegment.TimeLastInorgSedAvg[True] := -99;
          HypoSegment.TimeLastInorgSedAvg[False] := -99;

          {Pass to hypolimnion the rates table the previous hypolimnion segment was writing to}
          If PRateInfo.FileInit[Vseg] then
            HypoSegment.WriteTable := HypTable;

          If Not SetupRec.AlwaysWriteHypo
            then
              Begin
                HypoSegment.Last_Datapoint_Written[Epilimnion]  := -99;
                HypoSegment.Last_Results_Written[Epilimnion]    := -99;
                HypoSegment.Last_Datapoint_Written[Hypolimnion] := -99;
                HypoSegment.Last_Results_Written[Hypolimnion]   := -99;
              End
            else
              Begin
                HypoSegment.Last_Datapoint_Written := Last_Datapoint_Written;
                HypoSegment.Last_Results_Written := Last_Results_Written;
              End;

          If EstuarySegment then TSalinity(HypoSegment.GetStatePointer(Salinity,StV,WaterCol)).CalculateLoad(TPresent);  {Set Salinities in hypolimnion}
          EpiVol := GetStatePointer(Volume,StV,WaterCol);
          EpiVol.DeltaVolume;  {Set epilimnion volume information}

          HypVol := HypoSegment.GetStatePointer(Volume,StV,WaterCol);
          SetVars(HypVol);
          HypVol.Discharg := EpiVol.Discharg;
          HypVol.DeltaVolume;  {Set  hypolimnion volume information}

          If EstuarySegment then
            Begin
              VolFrac_Last_Step := EpiVol.FracUpper;
              HypoSegment.VolFrac_Last_Step := EpiVol.FracUpper;
            End;

          InitMeanThick := Location.MeanThick[Epilimnion];
          HypoSegment.InitMeanThick := Location.MeanThick[Hypolimnion];

          { Set allstates, location, and chemical to the correct value }
          For i:=0 to count-1 do
               SetVars(HypoSegment.at(i));

          For i:=0 to count-1 do
               CRC(HypoSegment.at(i));

          AllSVColl := TCollection.Init(20,10);
          For i:=0 to count-1 do
            AllSVColl.Insert(At(i));
          For i:=0 to HypoSegment.Count-1 do
            AllSVColl.Insert(HypoSegment.At(i));

          TCollection(PAllSVsColl^):=AllSVColl;
       End; {Duplicate}
       { -------------------------------------------------------------------------------------}

    Begin {Initiate Stratification}
      ProgData.StratVis:=True;

      Stratified:=True;
      TVolume(GetStatePointer(Volume,StV,WaterCol)).DeltaVolume;  {Set Morphometry for DuplicateTState}

      DuplicateTState;

      SetMeanDischarge(TPresent);
      Hyposegment.SetMeanDischarge(TPresent);

      TVolume(GetStatePointer(Volume,StV,WaterCol)).DeltaVolume;  {Set Morphometry after Duplication}
      If EstuarySegment then TSalinity(HypoSegment.GetStatePointer(Salinity,StV,WaterCol)).CalculateLoad(TPresent);  {Set Salinities in hypolimnion}
      TVolume(HypoSegment.GetStatePointer(Volume,StV,WaterCol)).DeltaVolume;  {Set Hypolimnion Morphometry after Duplication}

    End;  {Duplicate TStates}
    {-------------------------------------------------------------------------------------------}
Var TV: TVolume;
    Entered: Double;
Begin     {Check_Stratification}
With Location Do
  Begin
    If EstuarySegment then if not Stratified then Initiate_Stratification; {Estuary is always stratified}
    If LinkedMode then exit;       { Stratification is not dynamic but is set by the user in linked mode }
    If SedModelIncluded then exit; { dynamic stratification not yet enabled when the multi-layer sed model is included }
    If Not Locale.Usebathymetry then Exit; {dynamic stratification not enabled when bathymetry turned off}

    TV := GetStatePointer(Volume,Stv,WaterCol);
    If TV.StratAutomatically then
      Begin
        {Get Epi and Hypo Temps}
        SegSaver:=VSeg;
        VSeg:=Hypolimnion;
        TTemperature(GetStatePointer(Temperature,StV,WaterCol)).CalculateLoad(TPresent);
        HypTemp:=GetState(Temperature,StV,WaterCol);
        VSeg:=Epilimnion;
        TTemperature(GetStatePointer(Temperature,StV,WaterCol)).CalculateLoad(TPresent);
        EpiTemp:=GetState(Temperature,StV,WaterCol);
        VSeg:=SegSaver;
      { VertDisp := } CalcVertDispersion;

        If Stratified
          and (Not EstuarySegment)
          and (VSeg=Epilimnion)
    {     and (VertDisp > 7.0) }
          and ((EpiTemp - HypTemp) < 3.0)
    {     and (Not IncrTemp) } then
                  Overturn(false);   {"false" meaning study is not done executing}

        If Not Stratified then
          Begin
            If ((MaxEpiThick + 1.0) < locale.ZMax) {avoid very small hypolimnion}
            and (GetState(Temperature,StV,WaterCol)>4.0)
            and ((EpiTemp - HypTemp) > 3.0)
            and not (Location.SiteType in [Stream,Enclosure]) {these site types don't stratify}
            and Location.Locale.UseBathymetry   {no stratification unless bathymetry is enabled}
          { then if (VertDisp <= 7.0)
            and IncrTemp }
               then Initiate_Stratification;
          End; {Not Stratified}
      End  {StratifyAutomatically}
    else  {Stratify and Overturn based on user input}
      Begin
        Entered := TV.StratDates.GetLoad(TPresent,False);
        If Entered < 0 then exit;
        If (Entered=0) and Stratified then Overturn(false);
        If (Entered>0) and (not Stratified) then Initiate_Stratification;
      End;
  End;
End;

{Object IDs for storing in collections}

Function TAnimal.ObjectID:SmallInt;       Begin  ObjectID:=1001;  End;
Function TPlant.ObjectID:SmallInt;        Begin  ObjectID:=1002;  End;
Function TToxics.ObjectID:SmallInt;       Begin  ObjectID:=1006;  End;
Function TStateVariable.ObjectID:SmallInt;Begin  ObjectID:=1007;  End;
Function TPreference.ObjectID:SmallInt;   Begin  ObjectID:=1008;  End;
Function TFishTox.ObjectID:SmallInt;      Begin  ObjectID:=1009;  End;
Function TResults.ObjectID:SmallInt;      Begin  ObjectID:=1010;  End;
Function TDataPoint.ObjectID:SmallInt;    Begin  ObjectID:=1011;  End;
Function TTemperature.ObjectID:SmallInt;  Begin  ObjectID:=1013;  End;
Function TWindLoading.ObjectID:SmallInt;  Begin  ObjectID:=1014;  End;
Function TLight.ObjectID:SmallInt;        Begin  ObjectID:=1015;  End;
Function TOrganism.ObjectID:SmallInt;     Begin  ObjectID:=1016;  End;
Function TMacrophyte.ObjectID:SmallInt;   Begin  ObjectID:=1017;  End;
Function TRemineralize.ObjectID:SmallInt; Begin  ObjectID:=1018;  End;
Function TPO4Obj.ObjectID:SmallInt;       Begin  ObjectID:=1019;  End;
Function TNH4Obj.ObjectID:SmallInt;       Begin  ObjectID:=1020;  End;
Function TNO3Obj.ObjectID:SmallInt;       Begin  ObjectID:=1021;  End;
Function TSuspLabDetr.ObjectID:SmallInt;   Begin  ObjectID:=1022;  End;
Function TSedLabileDetr.ObjectID:SmallInt; Begin  ObjectID:=1023;  End;
Function TSuspRefrDetr.ObjectID:SmallInt; Begin  ObjectID:=1024;  End;
Function TSedRefrDetr.ObjectID:SmallInt;  Begin  ObjectID:=1025;  End;
Function TCo2Obj.ObjectID:SmallInt;       Begin  ObjectID:=1026;  End;
Function TO2Obj.ObjectID:SmallInt;        Begin  ObjectID:=1027;  End;
Function TParticleTox.ObjectID:SmallInt;  Begin  ObjectID:=1028;  End;
Function TAlgae_zooTox.ObjectID:SmallInt; Begin  ObjectID:=1029;  End;
{Function TMercuryTox.ObjectID:SmallInt;   Begin  ObjectID:=1030;  End;
Function TMeHg.ObjectID:SmallInt;         Begin  ObjectID:=1031;  End;
Function THgII.ObjectID:SmallInt;         Begin  ObjectID:=1032;  End;
Function THg0.ObjectID:SmallInt;          Begin  ObjectID:=1033;  End;  }
Function TpHObj.ObjectID:SmallInt;        Begin  ObjectID:=1034;  End;
{PDistribution gets 1035, in Uncert.Pas                    1035}
Function TSandSiltClay.ObjectID:SmallInt;  Begin  ObjectID:=1036;  End;
Function TBuriedDetr1.ObjectID:SmallInt;   Begin  ObjectID:=1037;  End;
Function TBuriedDetrTox1.ObjectID:SmallInt;Begin  ObjectID:=1038;  End;
Function TVolume.ObjectID:SmallInt;       Begin  ObjectID:=1039;  End;
Function TDissRefrDetr.ObjectID:SmallInt; Begin  ObjectID:=1040;  End;
Function TDissLabDetr.ObjectID:SmallInt;  Begin  ObjectID:=1041;  End;
Function TPlantToxRecord.ObjectID;        Begin  ObjectID:=1042;  End;
Function TAnimalToxRecord.ObjectID;       Begin  ObjectID:=1043;  End;
Function TResultsCollection.ObjectID;     Begin  ObjectID:=1044;  End;
Function TResHeader.ObjectID;                Begin  ObjectID:=1045;  End;
Function TBioTransObject.ObjectID;        Begin  ObjectID:=1046;  End;
Function TBottomSediment.ObjectID;        Begin  ObjectID:=1047;  End;
Function TPoreWater.ObjectID;             Begin  ObjectID:=1048;  End;
Function TDOMPoreWater.ObjectID;          Begin  ObjectID:=1049;  End;
Function TSuspSedimentTox.ObjectID;       Begin  ObjectID:=1050;  End;
Function TBottomSedimentTox.ObjectID;     Begin  ObjectID:=1051;  End;
Function TPoreWaterTox.ObjectID;          Begin  ObjectID:=1052;  End;
Function TDOMPoreWaterTox.ObjectID;       Begin  ObjectID:=1053;  End;
Function TDissDetr.ObjectID;              Begin  ObjectID:=1054;  End;
Function TSuspendedDetr.ObjectID;         Begin  ObjectID:=1055;  End;
Function TSedimentedDetr.ObjectID;        Begin  ObjectID:=1056;  End;
Function TBottomCohesives.ObjectID;       Begin  ObjectID:=1057;  End;
Function TSalinity.ObjectID;              Begin  ObjectID:=1058;  End;
Function TBuriedDetr2.ObjectID:SmallInt;   Begin  ObjectID:=1059;  End;
Function TBuriedDetrTox2.ObjectID:SmallInt;   Begin  ObjectID:=1060;  End;
Function TSuspSediment.ObjectID:SmallInt;     Begin  ObjectID:=1061;  End;
{function TNH4_Sediment.ObjectID: SmallInt;  Begin  ObjectID:=1062;  End;
function TNO3_Sediment.ObjectID: SmallInt;  Begin  ObjectID:=1063;  End;
function TPO4_Sediment.ObjectID: SmallInt;  Begin  ObjectID:=1064;  End;
function TPOC_Sediment.ObjectID: SmallInt;  Begin  ObjectID:=1065;  End;
function TPON_Sediment.ObjectID: SmallInt;  Begin  ObjectID:=1066;  End;
function TPOP_Sediment.ObjectID: SmallInt;  Begin  ObjectID:=1067;  End;
function TMethane.ObjectID: SmallInt;       Begin  ObjectID:=1068;  End;
function TSulfide_Sediment.ObjectID: SmallInt; Begin  ObjectID:=1069;  End;
function TSilica_Sediment.ObjectID: SmallInt; Begin  ObjectID:=1070;  End;
function TCOD.ObjectID: SmallInt;             Begin  ObjectID:=1071;  End; }
function TPOCTox.Objectid: SmallInt;            Begin  ObjectID:=1072;  End;
Function T_N_Internal_Plant.ObjectID:SmallInt;  Begin  ObjectID:=1073;  End;



    (************************************)
    (*                                  *)
    (*     DIFFERENTIAL EQUATIONS       *)
    (*                                  *)
    (************************************)

Procedure TStateVariable.Derivative;

Begin
   {Write Rates for Output}
  With AllStates.SetupRec^ do
   If (SaveBRates or ShowIntegration) then
     Begin
       ClearRate;
       SaveRate('State',State);
     End;

   DB:=0;
End;

{--------------------------------------------------------------------------------------}

Procedure TVolume.Derivative(var DB: double);
{************************************}
{ Calculate a change in volume       }
{ coded by JSC,                      }
{ Modified by JSC 7/20/98 (% Change) }
{************************************}

{Does not account for pore water exchanges in the overall water volume, they are assumed
 to be negligable.  The toxicant in the pore waters is, of course, tracked}

Var Evap : Double;
Begin
  If AllStates.EstuarySegment then
    Begin
      DeltaVolume;
      With AllStates do with SetupRec^ do
       If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
        End;
      db :=0;
      Exit;
    End;

  Evap := Evaporation;

      Case Calc_Method of
        KeepConst: Begin  {db = 0}
                     Inflow    := InflowLoad;
                     Discharg := Inflow - Evap;
                     If Discharg < 0 then
                       begin
                         Discharg := 0;
                         Inflow := Evap;
                       end;
                   End;
        Dynam: Begin
                 Inflow := InflowLoad;
                 Discharg := DischargeLoad;
               End;
        KnownVal:
               Begin  {db = knownvalload-state, inflow, evap known}
                 Inflow := InflowLoad;
                 Discharg := Inflow - Evap + State - KnownValueLoad;
                 If Discharg < 0 then
                   begin
                     Inflow := Inflow - Discharg;
                     Discharg := 0;
                   end;
               End;
        Manning: Begin
                   {db = Manning_Volume-state, discharge, evap known}
                   Discharg := DischargeLoad;

                   Inflow := Manning_Volume - State + Discharg + Evap;
                   If Inflow < 0 then
                     Begin
                       Discharg := Discharg - Inflow;
                       Inflow := 0;
                     End;

    {             Discharg := Location.Discharge_using_QBASE;          }
    {             Inflow   := Manning_Volume - State + Discharg + Evap; }
                 End;
        End; {Case}

  DeltaVolume;  {change value of TotDischarge}

  {Write Rates for Output}
  With AllStates.SetupRec^ do
   If (SaveBRates or ShowIntegration) then
    Begin
      ClearRate;
      SaveRate('State',State);
      SaveRate('Inflow',Inflow);
      SaveRate('Discharge',Discharg);
      SaveRate('Evap',Evap);
    End;

      Begin
        db := Inflow - Discharg - Evap;
        if abs(db) < Small then db := 0;
      End;

  AllStates.VolumeUpdated := AllStates.TPresent;
End;

{-----------------------------------------------------------------------}

Procedure TStates.Count_Num_RateFiles(Var NumFiles, Num_Rates_Per_File, RCount: Integer);
 Var i : integer;
     PS: TStateVariable;

 Begin
   {If PRateInfo.ErrorOnly
     then Num_Rates_Per_File:=90
     else} Num_Rates_Per_File:=5;

   RCount:=0;
   For i:=0 to count-1 do
     Begin
       PS:=At(i);
       If PS<> nil then
          If PS.PShowRates^ then RCount:=RCount+1;
     End;
   NumFiles:=((RCount - 1) div Num_Rates_Per_File) + 1;
 End;
{-------------------------------------------------------------}

constructor TSVConc.Init(Conc,Tm: Double);
Begin
  SVConc := Conc;
  Time   := Tm;
End;

