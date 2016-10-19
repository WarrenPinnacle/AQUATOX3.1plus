//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
 Constructor TRemineralize.Init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                               IC : double; IsTempl: Boolean);
Begin
   Inherited Init(Ns,SVT,aName,P,IC, IsTempl);
End;

Destructor TRemineralize.Destroy;
Begin
   Inherited Destroy;
End;

Function TDetritus.MultFrac(TimeIndex: Double; IsAlt: Boolean; PAltLdg: PAlt_LoadingsType): Double;
{ Gets the correct fraction to multiply the general loadings data by to fit the appropriate compartment / data type }
{ This is based on Refr/Labile split and Part/Diss split.  Inflow loadings get appropriate conversion factor
  as well depending on whether data are BOD, TOC, or Org. Matter }

 Var  ConvertFrac, RefrFrac, PartFrac : Double;
      RefrPercent, PartPercent : Double;  {User Input Percentage of Refractory or Particulate}
      PInputRec: PDetritalInputRecordType;

Begin
  PInputRec := @TDissRefrDetr(GetStatePointer(DissRefrDetr,StV,WaterCol)).InputRecord;

  If NState in [SedmRefrDetr,SedmLabDetr] then
     Raise EAquatoxError.Create('Programming Error:  Mult Frac is not relevant to Sed. Detritus');

  ConvertFrac := 1.0;

  If IsAlt then RefrPercent := ReturnAltLoad(TimeIndex,PInputRec^.Percent_Refr,PAltLdg^)
           else RefrPercent := ReturnLoad(TimeIndex,PInputRec^.Percent_Refr);
  If IsAlt then PartPercent := ReturnAltLoad(TimeIndex,PInputRec^.Percent_Part,PAltLdg^)
           else PartPercent := ReturnLoad(TimeIndex,PInputRec^.Percent_Part);

  If NState in [DissRefrDetr,DissLabDetr]
        then PartFrac := 1 - (PartPercent /100)
        else PartFrac := (PartPercent /100);

  If NState in [DissRefrDetr,SuspRefrDetr]
        then RefrFrac := (RefrPercent /100)
        else RefrFrac := 1 - (RefrPercent /100);

  If (Not IsAlt) {Don't convert Point Source, Non Point Source Loads}
    then Case PInputRec^.DataType of
           CBOD: ConvertFrac     := Location.Conv_CBOD5_to_OM(RefrPercent);
           Org_Carb: ConvertFrac := Detr_OM_2_OC;
         end; {Case}
  MultFrac := ConvertFrac * RefrFrac * PartFrac;
End;

{-------------------------------------------------------------------------------------}
Function TDetritus.GetInflowLoad(TimeIndex : Double): Double;
Var PInputRec: PDetritalInputRecordType;

Begin
  PInputRec := @TDissRefrDetr(GetStatePointer(DissRefrDetr,StV,WaterCol)).InputRecord;

  Result := 0;
  If NState in [SedmRefrDetr,SedmLabDetr]
    Then Inherited GetInflowLoad(TimeIndex)  {TStateVariable}  {This function is for Susp&Diss Detritus Only}
    Else
      Begin
        {Inflow Loadings}
        Result := ReturnLoad(TimeIndex,PInputRec^.Load) * MultFrac(TimeIndex,False,nil);
      End;
End;
{-------------------------------------------------------------------------------------}


Procedure TDetritus.CalculateLoad(TimeIndex : Double);
{ This Procedure calculates inflow Susp & Diss Detrital loadings as input by the user}

Var PInputRec: PDetritalInputRecordType;
    Loop      : Alt_LoadingsType;
    Inflow, SegVolume : Double;
    LoadRes   : Double; {Hold the Result}
    AddLoad   : Double;

Begin
  PInputRec := @TDissRefrDetr(GetStatePointer(DissRefrDetr,StV,WaterCol)).InputRecord;
  SegVolume := AllStates.SegVol;
  If SegVolume=0 then Raise EAquatoxError.Create('Water Volume is Zero, Cannot continue Simulation');

  With Location.Morph do
  Inflow := InflowH2O[AllStates.VSeg] * (OOSInflowFrac);  // inflow from inflow screen only, associated with loadings

  If NState in [SedmRefrDetr,SedmLabDetr]
    Then Inherited CalculateLoad(TimeIndex)  {TRemineralize}  {This function is for Susp&Diss Detritus Only}
    Else
      Begin
        Loading := 0;
        LoadRes := GetInflowLoad(TimeIndex);
        LoadRes := LoadRes * Inflow / SegVolume;
        {unit/d     unit     cu m/d     cu m   }

{       Atmospheric and point-source loadings should be to epilimnion in single-segment mode;  9/9/98 }
        If AllStates.LinkedMode or (AllStates.VSeg=Epilimnion) then
          For Loop:=PointSource to NonPointSource do
              Begin
               AddLoad := ReturnAltLoad(TimeIndex,PInputRec^.Load,Loop) * MultFrac(TimeIndex,True,@Loop);
                                                {g/d}                               {unitless}
               AddLoad := AddLoad / SegVolume;
               {mg/L d}    {g/d}     {cu m}
               LoadRes := LoadRes + AddLoad;
                           {mg/L d} {mg/L d}
              End;

        Loading := LoadRes;
      End; {Else Susp&Diss Detritus}
End;

{-------------------------------------------------------------------------------------------------------}

Procedure TRemineralize.CalculateLoad(TimeIndex : Double);
 { Inflow should be split betweeen both segments weighted by volume: 12-8-99
   Atmospheric and point-source loadings should be to epilimnion. 9/9/98 }

Const Infl_NH3_in_DIN : Double = 0.12;  {Ammonia to Diss. inorg. nitrogen, 12% in inflow water  3/27/08}
      PS_NH3_in_DIN   : Double = 0.15;  {Ammonia to Diss. inorg. nitrogen, 15% in point-source loadings 3/27/08}
      NPS_NH3_in_DIN  : Double = 0.12;  {Ammonia to Diss. inorg. nitrogen, 12% in nonpoint-source loadings 3/27/08}

Var Loop      : Alt_LoadingsType;
    SegVolume : Double;
    Inflow    : Double;
    AddLoad   : Double;
    PNO3: TNo3Obj;


      {------------------------------------------------------------------------------------------------}
      Function DetrNutr2Org(ns: AllVariables): Double;
      Begin
        With Location.Remin do
          Case ns of
            SedmRefrDetr, SuspRefrDetr: If nstate=Phosphate then DetrNutr2Org := P2Org_Refr
                                                            else DetrNutr2Org := N2Org_Refr;
            SedmLabDetr, SuspLabDetr  : If nstate=Phosphate then DetrNutr2Org := P2OrgLab
                                                            else DetrNutr2Org := N2OrgLab;
            DissRefrDetr             : If nstate=Phosphate  then DetrNutr2Org := P2OrgDissRefr
                                                            else DetrNutr2Org := N2OrgDissRefr;
            else {DissLabDetr}         If nstate=Phosphate  then DetrNutr2Org := P2OrgDissLab
                                                            else DetrNutr2Org := N2OrgDissLab;
            End; {Case}
      End;
      {------------------------------------------------------------------------------------------------}
      Procedure TotNutrient_Alt_Ldg(LdType:Alt_LoadingsType);
      Var CNutrient: Double;
          nsloop: AllVariables;
          DetrAltLdg: Double;
          TDetr: TDetritus;
          LDType2: Alt_LoadingsType;
          PInputRec: PDetritalInputRecordType;
      Begin
        PInputRec := @TDissRefrDetr(GetStatePointer(DissRefrDetr,StV,WaterCol)).InputRecord;
        CNutrient := AddLoad;
        LdType2 := LdType;

        For nsloop := DissRefrDetr to SuspLabDetr do
          Begin
            TDetr := GetStatePointer(nsLoop,StV,WaterCol);
            If TDetr<>nil then
              Begin
                DetrAltLdg :=  ReturnAltLoad(TimeIndex,PInputRec^.Load,LdType) * TDetr.MultFrac(TimeIndex,True,@LdType2);
                                                  {g/d}                               {unitless}
                DetrAltLdg := DetrAltLdg / SegVolume;
                   {mg/L d}    {g/d}     {cu m}

                CNutrient := CNutrient - DetrAltLdg * DetrNutr2Org(nsloop);
                 {mg/L}        {mg/L}      {mg/L}      {Nut2Org}
              End;
          End;

        If LdType = PointSource  {3/27/2008}
          then
            Begin
              If NState = Ammonia then CNutrient := CNutrient * PS_NH3_in_DIN;
              If NState = Nitrate then CNutrient := CNutrient * (1-PS_NH3_in_DIN);
            End
          else {NPS}
            Begin
              If NState = Ammonia then CNutrient := CNutrient * NPS_NH3_in_DIN;
              If NState = Nitrate then CNutrient := CNutrient * (1-NPS_NH3_in_DIN);
            End;

        AddLoad := CNutrient;
        If CNutrient < 0 then AddLoad := 0;
      End;
      {------------------------------------------------------------------------------------------------}
      Procedure TotNutrient_Dynamic_Inflow;
      Var CNutrient: Double;
          PlantInflow, DetrInflow: Double;
          PSV: TStateVariable;
          nsLoop: AllVariables;
          InflLoad: Double;
      Begin
         CNutrient := Loading;  {Total Nutrient loading in mg/L d}

         For nsloop := DissRefrDetr to SuspLabDetr do
          Begin
            PSV := GetStatePointer(nsLoop,StV,WaterCol);
            If PSV<>nil then
              Begin
                InflLoad := TDetritus(PSV).GetInflowLoad(TimeIndex);   {Inflow Loadings Only}
                DetrInflow := InflLoad * Inflow / SegVolume; {Inflow Loadings Only}
                 {mg/L d}      {mg/L d}  {m3/d}    {m3}
                CNutrient := CNutrient - DetrInflow * DetrNutr2Org(nsloop);
                 {mg/L d}     {mg/L d}     {mg/L d}      {Nut2Org}
              End;
          End;

         For nsloop := FirstPlant to LastPlant do
          Begin
            PSV := GetStatePointer(nsLoop,StV,WaterCol);
            If PSV<>nil then
             If TPlant(PSV).IsPhytoplankton then
              Begin
                InflLoad := TStateVariable(PSV).GetInflowLoad(TimeIndex);   {Inflow Loadings Only}
                PlantInflow := InflLoad * Inflow / SegVolume; {Inflow Loadings Only}

                If NState=Phosphate
                  then CNutrient := CNutrient - PlantInflow * TPlant(PSV).P_2_Org
                  else CNutrient := CNutrient - PlantInflow * TPlant(PSV).N_2_Org;
                        {mg/L d}     {mg/L d}      {mg/L d}                {N2Org}
              End;
          End;

         If CNutrient<0 then CNutrient :=0;
         If NState = Ammonia then CNutrient := CNutrient * Infl_NH3_in_DIN;      {3/27/2008}
         If NState = Nitrate then CNutrient := CNutrient * (1-Infl_NH3_in_DIN);  {3/27/2008}

         Loading := CNutrient;
      End;
      {------------------------------------------------------------------------------------------------}

Begin
 With LoadsRec do
  Begin
    PNO3 := GetStatePointer(nitrate,stv,watercol);

    Loading:=0;
    SegVolume := AllStates.SegVol;
    With Location.Morph do
      Inflow := InflowH2O[AllStates.VSeg] * (OOSInflowFrac);

    With AllStates do
     If (EstuarySegment) and (VSeg=Hypolimnion) then   {Estuary Inflows from Salt Water, 6/3/08}
      With EstuarySaltLoads do
       Begin
         Inflow := Location.Morph.InflowH2O[Hypolimnion];  {lower segment inflow}
         Case NState of
           Oxygen:    Loading := O2Load        * Inflow / SegVolume;
                       {mg/L}   {mg/L}            {M3}      {M3}
           Ammonia:   Loading := AmmoniaLoad   * Inflow / SegVolume;
           Nitrate:   Loading := NitrateLoad   * Inflow / SegVolume;
           Phosphate: Loading := PhosphateLoad * Inflow / SegVolume;
           CO2 :      Loading := CO2Load       * Inflow / SegVolume;
                       {mg/L}    {mg/L}           {M3}      {M3}
           End; {case}
         Exit;
       End;

    If NoUserLoad then exit;

    {Inflow Loadings}
     Begin
       Loading := GetInflowLoad(TimeIndex);
       Loading:=Loading * Inflow/ SegVolume;
       {unit/d   unit     cu m/d    cu m   }

       If (NState=Ammonia) then
         If PNO3.TN_Inflow then
           Begin {3/27/08  Loadings must be gathered from NO3 input data structure}
             Loading := PNO3.GetInflowLoad(TimeIndex);
             Loading:=Loading * Inflow/ SegVolume;
             {unit/d   unit     cu m/d    cu m   }
             TotNutrient_Dynamic_Inflow;
           End;

       If (nstate=nitrate) then
         If PNO3.TN_Inflow then TotNutrient_Dynamic_Inflow;

       If (nstate=phosphate) then
         Begin
           If TPO4Obj(Self).TP_Inflow then TotNutrient_Dynamic_Inflow;
           Loading:=Loading*TPO4Obj(Self).FracAvail;
         End;
     End;

    {Add Point Source Non-Point Source and Direct Precipitation Loadings}
    If AllStates.VSeg=Epilimnion then
      If (not (Alt_Loadings[PointSource]=nil)) then
         For Loop:=PointSource to NonPointSource do
          If (Loop <> DirectPrecip) or (Not (NState in [DissRefrDetr..SuspLabDetr])) then {DirectPrecip Irrelevant for Susp&Dissolved Detritus}
           Begin
             AddLoad:=0;
             If Alt_UseConstant[Loop]
               then AddLoad := Alt_ConstLoad[Loop]  {g/d or g/sq m. d}
               else if Alt_Loadings[Loop]<>nil then AddLoad := Alt_Loadings[Loop].GetLoad(TimeIndex,True);

             AddLoad := AddLoad * Alt_MultLdg[Loop]/SegVolume;
             {mg/L d}    {g/d }     {unitless}       {cu m}
             If Loop=DirectPrecip then AddLoad := AddLoad   *  Location.Locale.SurfArea;
                                       {mg/L d}  {mg/sq m. d}         {sq m.}

             If nstate=phosphate then with TPO4Obj(Self) do
               If ((Loop=PointSource) and TP_PS) or ((Loop=NonPointSource) and TP_NPS) then
                 TotNutrient_Alt_Ldg(Loop);

             If nstate=nitrate then with PNO3 do
               If ((Loop=PointSource) and TN_PS) or ((Loop=NonPointSource) and TN_NPS) then
                 TotNutrient_Alt_Ldg(Loop);

             If nstate=Ammonia then with PNO3 do with PNO3.LoadsRec do
               If ((Loop=PointSource) and TN_PS) or ((Loop=NonPointSource) and TN_NPS) then
                 Begin  {3/27/08}
                   AddLoad:=0;
                   If Alt_UseConstant[Loop]  {PNO3}
                     then AddLoad := Alt_ConstLoad[Loop]  {PNO3, g/d}
                     else if Alt_Loadings[Loop]<>nil then AddLoad := Alt_Loadings[Loop].GetLoad(TimeIndex,True);
                   AddLoad := AddLoad * Alt_MultLdg[Loop]/SegVolume;
                   {mg/L d}    {g/d}      {unitless}       {cu m}

                   TotNutrient_Alt_Ldg(Loop); {3-27-08}
                 End;

             If nstate=phosphate then AddLoad:=AddLoad*TPO4Obj(Self).Alt_FracAvail[loop];
{              If nstate=nitrate then   AddLoad:=AddLoad*TNO3Obj(Self)^.Alt_FracAvail[loop]; }

             Loading:=Loading + AddLoad;
                    {mg/L d} {mg/L d}
           End; {Loop}
  End; {With LoadsRec}
End;

{-------------------------------------------------------------------------------------------------------}

Constructor TO2obj.init(Ns : StateVariables;  SVT: T_SVType; aName : ShortString; P : TStates;
                         IC : double; IsTempl: Boolean);
Begin
   CalcDuration := False;
   Threshhold   := 1.0;
   NoLoadOrWash := False;
   Inherited Init(Ns,SVT,aName,P,IC,IsTempl); {TRemineralize}
End;

Destructor TDissRefrDetr.Destroy;
Var ToxLoop: T_SVType;
    Alt_Loop: Alt_LoadingsType;
Begin
  With InputRecord do
    Begin
      Load.Loadings.Destroy;
      Load.Alt_Loadings[PointSource].Destroy;
      Load.Alt_Loadings[DirectPrecip].Destroy;
      Load.Alt_Loadings[NonPointSource].Destroy;
      For ToxLoop:=FirstOrgTxTyp to LastOrgTxTyp do
         If (ToxLoad[ToxLoop].Loadings <> nil) then ToxLoad[ToxLoop].Loadings.Destroy;

     Percent_Part.Loadings.Destroy;
     Percent_Refr.Loadings.Destroy;
     For Alt_Loop := PointSource to NonPointSource do
       Begin
         Percent_Part.Alt_Loadings[Alt_Loop].Destroy;
         Percent_Refr.Alt_Loadings[Alt_Loop].Destroy;
         For ToxLoop := FirstToxTyp to LastToxTyp do
             ToxLoad[ToxLoop].Alt_Loadings[Alt_Loop].Destroy;

       End;
     End;

  Inherited Destroy;
End;

{-------------------------------------------------------------------------------------------------------}

Constructor TDissRefrDetr.Init(Ns : StateVariables; SVT: T_SVType; aName : ShortString;
                               P  : TStates;        IC    : Double; IsTempl: Boolean);
Var L: LoadingsRecord;
    ToxLoop: T_SVType;
    Alt_Loop: Alt_LoadingsType;

Begin
   With InputRecord do
     Begin
       DataType     := Org_Matt;
       InitCond      := 0;
       Percent_PartIC := 90;
       Percent_RefrIC := 10;

       With L do     {Set up Empty Loadings Data Record to copy into other LoadingsRecords}
         Begin
           Loadings:=nil;
           ConstLoad:=0;
           MultLdg := 1.0;
           UseConstant:=True;
           NoUserLoad:=False;
           Alt_Loadings[PointSource]:=nil;
           Alt_Loadings[DirectPrecip]:=nil;
           Alt_Loadings[NonPointSource]:=nil;
         End;

       Load := L;
       Load.Loadings := TLoadings.Init(10,20);
       With Load do
        For Alt_Loop:=PointSource to NonPointSource do
         Begin
           Alt_Loadings[Alt_Loop] := TLoadings.Init(10,20);
           Alt_ConstLoad[Alt_Loop]   := 0;
           Alt_UseConstant[Alt_Loop] := True;
           Alt_MultLdg[Alt_Loop]     := 1;
         End;

       Percent_Part           := L;
       Percent_Part.ConstLoad := 90;
       Percent_Part.Loadings  := TLoadings.Init(10,20);

       Percent_Refr           := L;
       Percent_Refr.ConstLoad := 10;
       Percent_Refr.Loadings  := TLoadings.Init(10,20);

       For Alt_Loop := PointSource to NonPointSource do
         Begin
           Percent_Part.Alt_UseConstant[Alt_Loop] := True;
           Percent_Part.Alt_ConstLoad[Alt_Loop]  := 90;
           Percent_Part.Alt_Loadings[Alt_Loop]  := TLoadings.Init(10,20);
           Percent_Part.Alt_MultLdg[Alt_Loop]  := 1;

           Percent_Refr.Alt_UseConstant[Alt_Loop] := True;
           Percent_Refr.Alt_ConstLoad[Alt_Loop]  := 10;
           Percent_Refr.Alt_Loadings[Alt_Loop]  := TLoadings.Init(10,20);
           Percent_Refr.Alt_MultLdg[Alt_Loop]  := 1;
         End;

       For ToxLoop := FirstToxTyp to LastToxTyp do
         Begin
           ToxInitCond[ToxLoop] := 0;
           ToxLoad[ToxLoop] := L;
           ToxLoad[ToxLoop].Loadings := TLoadings.Init(10,20);
           For Alt_Loop := PointSource to NonPointSource do
              Begin
                ToxLoad[ToxLoop].Alt_UseConstant[Alt_Loop] := True;
                ToxLoad[ToxLoop].Alt_ConstLoad[Alt_Loop]  := 0;
                ToxLoad[ToxLoop].Alt_Loadings[Alt_Loop]  := TLoadings.Init(10,20);
                ToxLoad[ToxLoop].Alt_MultLdg[Alt_Loop]  := 1;
              End;
         End;
     End; {with InputRecord}

  Inherited Init(Ns,SvT, aName,P,IC, IsTempl); {TRemineralize}
End;


{---------------------------process equations--------------------------}

{--------------------------------}
{  correction for non-optimal pH }
{--------------------------------}
Function TRemineralize.pHCorr(pHMin, pHMax: double): double;
  Const
    KpH = 1.0;
  Var ppH : double;
  Begin
    ppH:=GetState(pH,StV,WaterCol);

    pHCorr := 1.0;
    if ppH <= pHMin then
      pHCorr := KpH * Exp(ppH - pHMin);
    if ppH > pHMax then
      pHCorr := KpH * Exp(pHMax - ppH);
  End;                      {phcorr}


{-------------------------------------------------------------------------------------------------------}

Function TRemineralize.SumDetrDecomp(OType: T_SVType; SedOnly: Boolean): Double;
{ If OType=NTrack returns sum of detrital decomp into ammonia
  If OType=NTrack returns sum detrital decomp into dissolved phosphorus
  otherwise returns sum of detrital decomposition in terms of organic matter }

  { Sum of Labile Detritus Decomposition }
Var RP   : TRemineralize;
    EndLoop, Loop : AllVariables;
    SumDecomp: Double;
    FracAerobic: Double;
    Decomp : Double;
Begin
  SumDecomp:=0;

  If SedOnly then EndLoop := SedmLabDetr
             else EndLoop := LastDetr;
  For Loop:=FirstDetr to EndLoop do
   With Location.Remin do
    Begin
      RP:=GetStatePointer(Loop,StV,WaterCol);
      If (RP=nil) then Decomp := 0
                  else Decomp := RP.Decomposition(DecayMax_Lab,KAnaerobic,FracAerobic);
      If OType=NTrack then
        if Loop=DissLabDetr then Decomp := Decomp * N2OrgDissLab
                            else Decomp := Decomp * N2OrgLab;
      If OType=PTrack then
        if Loop=DissLabDetr then Decomp := Decomp * P2OrgDissLab
                            else Decomp := Decomp * P2OrgLab;

      SumDecomp:=SumDecomp + Decomp;
    End;
  SumDetrDecomp:=SumDecomp;
End;

{-------------------------------------------------------------------------------------------------------}

Function TDetritus.Colonization : double;
Var  T, p, DOCorr, {N,} NLimit, ColonizeMax : double;
{Const N2NH4 = 0.78;
       N2NO3 = 0.23;
       HalfSatN = 0.15;
       MinN = 0.1;
       ColonizeMax = 0.05; Saunders 1980, 0.04}
                    {0.007;   McIntire & Colby, '78; Saunders '80}
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

Begin
  If not (nstate in [SuspRefrDetr,DissRefrDetr,SedmRefrDetr]) then
     Raise EAquatoxError.Create('Programming Error, Colonization must be passed a Refr Detr');


{  N := N2NH4*GetState(Ammonia) +  N2NO3*GetState(Nitrate);

  If N > MinN then  NLimit := (N - MinN)/(N - MinN + HalfSatN)
              else } NLimit := 1.0;

  ColonizeMax := Location.Remin.DecayMax_Refr;

  With Location.Remin do
    Begin
     { T := AllStates.TCorr(Q10, TRef, TOpt, TMax);}
      T := DecTCorr;
      p := pHCorr(pHMin, pHMax);
    End;

  If (nstate = SedmRefrDetr) and (State > 50) {anoxic}
     then DOCorr := 0.001 {GetState(Oxygen)/(3.00 + GetState(Oxygen))}
     else DOCorr := GetState(Oxygen,StV,WaterCol)/(0.75 + GetState(Oxygen,StV,WaterCol));

  Colonization := (ColonizeMax * NLimit * T * p * DOCorr) * State;
      {g/m3 d}      {g/g d}     {        unitless       }   {g/m3}
End;

{-------------------------}
{  sum instantaneous      }
{  contributions from     }
{  each process to Detr   }
{-------------------------}

Function TRemineralize.CalcAnimPredn: double;
Var NetPredation : double;
                 i : Integer;

   Procedure NutrPred(P: TAnimal);
   Var Cons: Double;
       PreyNutr2Org, PredNutr2Org, DiffNutrFrac: Double;
   Begin
      if P.IsAnimal then
        begin
           If nstate=Phosphate then PredNutr2Org := P.PAnimalData^.P2Org
                               else PredNutr2Org := P.PAnimalData^.N2Org;

           PreyNutr2Org := 0;
           Cons := P.EatEgest(Eat);
           If Cons>0 then
             Begin
               If nstate=Phosphate
                 then PreyNutr2Org := P.PhosCons/Cons
                 else PreyNutr2Org := P.NitrCons/Cons;
             End;

           DiffNutrFrac := PredNutr2Org-PreyNutr2Org;

           NetPredation := NetPredation - Cons*DiffNutrFrac;
        end;
   End;
Begin                   {excr}
  NetPredation := 0.0;
  With AllStates do For i:=0 to count-1 do
       NutrPred(at(i));

  CalcAnimPredn := NetPredation;
End;


{---------------------------------}
{ nitrification & denitrification }
{---------------------------------}
Function TNH4Obj.Nitrification: double;
Var T, p, Nitrify, DOCorr : double;
    EnvironLim : Double;  {Correction for Oxygen, Temperature, pH}
begin
 if State > VSmall then begin
   with Location.Remin do begin
     T := AllStates.TCorr(2.0, 10.0, 30.0, 60.0);
     p := pHCorr(7.0, 9.0);
     DOCorr :=  GetState(Oxygen,StV,WaterCol)/(0.5 + GetState(Oxygen,StV,WaterCol));
     EnvironLim := DOCorr * T * p;

     Nitrify := KNitri * EnvironLim * State {* Sed_Surf_Corr };  //  3/12/09 Removed Sed_Surf_Corr
               {Note KNitri may need to be calibrated to a lower value when Sed. Diagenesis enabled}

   end; {with}
 end  {> Tiny}
 else
   Nitrify := 0.0;
 Nitrification := Nitrify;
End;

{-------------------------------------------------------------------------------------------------------}

Function TNO3Obj.Denitrification : double;
Var T, p, DOCorr, Denitrify, EnvironLim {, Sed_Surf_Corr }: double;
Begin
 if State > VSmall then begin
   with Location.Remin do begin
     T := AllStates.TCorr(2.0, 10.0, 30.0, 60.0);
     p := pHCorr(5.0, 9.0);
     DOCorr :=  GetState(Oxygen,StV,WaterCol)/(0.5 + GetState(Oxygen,StV,WaterCol));
     EnvironLim := (1.0 - DOCorr) * T * p;

     Denitrify := ( KDenitri_Wat * EnvironLim ) * State;  //  3/13/09 Reformulated

(*     With AllStates do
      {Calculate Correction for Sediment Surface Phenomenon, Unitless}
      {Assumed that surface area = sediment area}
         Sed_Surf_Corr :=  SurfaceArea/SegVol;         Irrelevant 5-18-2011 *)

(*   If Not AllStates.Diagenesis_Included then
       Denitrify := Denitrify +  (KDenitri_Bot  * Sed_Surf_Corr * T * P) * State     Removed KDenitri Bottom as per "Denitrification 5-17-11.docx" *)

   end; {with}
 end  {> Tiny}
 else Denitrify := 0.0;
  Denitrification := Denitrify;
End;                      { denitrification }

{-------------------------------------------------------------------------------------------------------}

Function TNH4Obj.Remineralization;
Var Remin: Double;
Begin
   Remin := 0;

   PhotoResp := CalcPhotoResp;  { When photorespiration takes place in plants, excess nutrients are converted into NH4 }
   DarkResp :=  CalcDarkResp;   { When dark respiration occurs, excess nutrients are converted into NH4. }
   AnimExcr := CalcAnimResp + CalcAnimExcr;   // direct respiration losses plus excess nutrient losses from excretion to detritus
   AnimPredn := CalcAnimPredn;  { When predation occurs, differences in nutrients are refelcted in W.C.}
   SvNutrRelColonization := NutrRelColonization;
   SvNutrRelMortality := NutrRelMortality;
   SvNutrRelGamLoss := NutrRelGamLoss;
   SvNutrRelPeriScr := NutrRelPeriScr;
   SvNutrRelPlantSink := NutrRelPlantSink;
   SvNutrRelDefecation := NutrRelDefecation;

   SvSumDetrDecomp := SumDetrDecomp(NTrack,False);

   Remin := Remin + PhotoResp + DarkResp + AnimExcr + AnimPredn + SvNutrRelColonization + SvNutrRelMortality +
                    SvNutrRelGamLoss + SvNutrRelPeriScr + SvNutrRelPlantSink + SvNutrRelDefecation + SvSumDetrDecomp;
   {mg N/ L}         {mg N/ L}

   Remineralization := Remin;
End; {Remineralization}


Function TPO4Obj.Remineralization;
Var Remin: Double;
Begin
   Remin := 0;

   Remin := Remin +  SumDetrDecomp(PTrack,False);
 {mg P/ L}               {mg P/ L}

   Remin := Remin + CalcPhotoResp;
   Remin := Remin + CalcDarkResp;
   Remin := Remin + CalcAnimResp;
   Remin := Remin + CalcAnimExcr;
   Remin := Remin + CalcAnimPredn;
   Remin := Remin + NutrRelDefecation;
   Remin := Remin + NutrRelColonization;
   Remin := Remin + NutrRelPlantSink;
   Remin := Remin + NutrRelMortality;
   Remin := Remin + NutrRelGamLoss;
   Remin := Remin + NutrRelPeriScr;

   Remineralization := Remin;
End; {Remineralization}


Function TRemineralize.NutrRelPeriScr: Double;
{When Periphyton is scoured into phytoplankton nutrient balance must
  be maintained if they have different stochiometry}

Var PeriLoop, PhytLoop: AllVariables;
    PPeri, PPhyt: TPlant;
    NRPS,j: Double;
    Nut2OrgPeri, Nut2OrgPhyt: Double;
Begin
  NRPS := 0;
  For PhytLoop := FirstAlgae to LastAlgae do
   For PeriLoop := FirstAlgae to LastAlgae do
    Begin
      PPhyt := GetStatePointer(PhytLoop,StV,WaterCol);
      PPeri := GetStatePointer(PeriLoop,StV,WaterCol);
      If (PPhyt <> nil) and (PPeri <> nil) then
        If (PPeri.PSameSpecies^=PPhyt.NState) then
          Begin
            PPeri.CalcSlough; {update sloughevent}
            If PPeri.Sloughevent then
              Begin
               If (nstate = ammonia) then Nut2OrgPeri := PPeri.N_2_Org
                                     else Nut2OrgPeri := PPeri.P_2_Org;
               If (nstate = ammonia) then Nut2OrgPhyt := PPhyt.N_2_Org
                                     else Nut2OrgPhyt := PPhyt.P_2_Org;

                j := -999; {signal to not write mass balance tracking}
                PPeri.Derivative(j); {update sloughing}
                NRPS  := NRPS + PPeri.Sloughing * (1/3) * (Nut2OrgPeri - Nut2OrgPhyt);
                {1/3 of periphyton will go to phytoplankton and 2/3 to detritus with sloughing/scour.}
              End;
          End;
    End;

  NutrRelPeriScr := NRPS;
End;

{-------------------------------------------------------------------------------------------------------}

Function TRemineralize.NutrRelGamLoss: Double;
{When Gameteloss takes place in animals, (-->SuspLabDetr)
 excess nutrients are converted into NH4. }
Var ns: AllVariables;
    PAn: TAnimal;
    DiffNFrac,NGL: Double;
Begin
   NGL := 0;
   For ns := FirstAnimal to LastAnimal do
    If GetState(ns,stv,WaterCol)>0 then
      Begin
        PAn := GetStatePointer(ns,stv,WaterCol);
        With Location.Remin do
          If NState=Ammonia
            then DiffNFrac := PAn.PAnimalData^.N2Org - N2OrgLab
            else DiffNFrac := PAn.PAnimalData^.P2Org - P2OrgLab;

        NGL := NGL + PAn.Gameteloss * DiffNFrac;
      End;
   NutrRelGamLoss := NGL;
End;

{-------------------------------------------------------------------------------------------------------}

Function TRemineralize.NutrRelMortality: Double;
{When Anim & Plant die, excess nutrients are converted into NH4;
 Detritus tends to have a lower fraction of nutrients then the dying organisms.
 Macrophyte breakage and Tox Dislodge are included in mortality here
 for accounting of nutrient mass.}

Var ns: AllVariables;
    PDRD,PDLD,PPRD,PPLD: TDetritus;
    POr: TOrganism;
    Mort, DetrNFrac,DiffNFrac,NMort, j, FracMult: Double;
    Nut2Org_Refr, Nut2Org_Lab, Nut2Org_DissRefr, Nut2Org_DissLab : Double;
Begin
   PDRD := GetStatePointer(DissRefrDetr,StV,WaterCol);
   PDLD := GetStatePointer(DissLabDetr,StV,WaterCol);
   PPRD := GetStatePointer(SuspRefrDetr,StV,WaterCol);
   PPLD := GetStatePointer(SuspLabDetr,StV,WaterCol);

   With Location.Remin do
    If nstate=Ammonia
     then Begin Nut2Org_Refr:=N2Org_Refr; Nut2Org_Lab:=N2OrgLab;
                Nut2Org_DissRefr:=N2OrgDissRefr;
                Nut2Org_DissLab :=N2OrgDissLab;  End
     else Begin Nut2Org_Refr:=P2Org_Refr; Nut2Org_Lab:=P2OrgLab;
                Nut2Org_DissRefr:=P2OrgDissRefr;
                Nut2Org_DissLab :=P2OrgDissLab;  End;

   NMort := 0;
   For ns := FirstBiota to LastBiota do
    If GetState(ns,StV,WaterCol)>0 then
      Begin
        POr := GetStatePointer(ns,StV,WaterCol);

        DetrNFrac := PDRD.Mort_To_Detr(ns)*Nut2Org_DissRefr +
                     PPRD.Mort_To_Detr(ns)*Nut2Org_Refr +
                     PPLD.Mort_To_Detr(ns)*Nut2Org_Lab +
                     PDLD.Mort_To_Detr(ns)*Nut2Org_DissLab;

        DiffNFrac := POr.NutrToOrg(NState) - DetrNFrac;

        Mort := POr.Mortality;
        If POr.IsMacrophyte then Mort:=Mort+TMacrophyte(POR).Breakage;
        If POr.IsPlant and (Not POr.IsMacrophyte) then with TPlant(POr) do
          Begin
            Mort:=Mort+ToxicDislodge;
            TPlant(POR).CalcSlough; {update sloughevent}
            If Sloughevent then
              Begin
                j := -999; {signal to not write mass balance tracking}
                TPlant(POR).Derivative(j); {update sloughing}
                If PSameSpecies^ = NullStateVar then FracMult := 1.0
                                                else FracMult := 2/3;
               {1/3 of periphyton will go to phytoplankton and 2/3 to detritus with sloughing/scour.}
                Mort := Mort + Sloughing * FracMult;
              End;
          End;

        NMort := NMort + Mort * DiffNFrac;
      End;
   NutrRelMortality := NMort;
End;

{-------------------------------------------------------------------------------------------------------}

Function TRemineralize.NutrRelPlantSink: Double;
{When Plants sink, excess nutrients are converted into NH4;
Sedimented Detritus tends to have a lower fraction of nutrients then
the sinking plants}
Var ns, ploop: AllVariables;
    PSRD,PSLD: TDetritus;
    PPl, PPeri: TPlant;
    DetrNFrac,DiffNFrac,NSink: Double;
    Nut2Org_Refr, Nut2Org_Lab : Double;
    PeriMass, NumPeriLinks, PeriNFrac, PNFrac2 : Double;

Begin
   NutrRelPlantSink := 0 ;
   PSRD := GetStatePointer(SedmRefrDetr,StV,WaterCol);
   PSLD := GetStatePointer(SedmLabDetr,StV,WaterCol);
   If PSRD = nil then exit;  {diagenesis model in place}

   With Location.Remin do
     If nstate=Ammonia
       then Begin Nut2Org_Refr:=N2Org_Refr; Nut2Org_Lab:=N2OrgLab; End
       else Begin Nut2Org_Refr:=P2Org_Refr; Nut2Org_Lab:=P2OrgLab; End;

   NSink := 0;
   For ns := FirstAlgae to LastAlgae do
    If GetState(ns,StV,WaterCol)>0 then
      Begin
        PPl := GetStatePointer(ns,StV,WaterCol);
        If PPL.IsLinkedPhyto then
          Begin
            PeriNFrac := 0; PNFrac2 := 0;
            NumPeriLinks := 0;
            PeriMass := 0;

            For PLoop := FirstAlgae to LastAlgae do
              Begin
                PPeri := GetStatePointer(PLoop,StV,WaterCol);
                If PPeri <> nil then
                   If (PPeri.IsPeriphyton) and
                      (PPeri.PSameSpecies^ = PPL.nstate)
                        then Begin
                               NumPeriLinks := NumPeriLinks + 1.0;
                               PeriMass := PeriMass + PPeri.State;
                               If NState=Ammonia
                                  then PeriNFrac := PeriNFrac + PPeri.State*PPeri.N_2_Org
                                  else PeriNFrac := PeriNFrac + PPeri.State*PPeri.P_2_Org;
                               If PeriMass<VSmall then
                                If NState=Ammonia
                                  then PNFrac2 := PNFrac2 + PPeri.N_2_Org
                                  else PNFrac2 := PNFrac2 + PPeri.P_2_Org
                             End;
                   {will count itself and any other peiphyton species linked to this phytoplankton}
              End;

            If PeriMass<VSmall                             {9/20/2004 debug against zero periphyton}
              then PeriNFrac := PNFrac2 / NumPeriLinks     {used to split evenly among peri comps.}
              else PeriNFrac := PeriNFrac / PeriMass;      {used to weight by mass of periphyton comps.}

            If NState=Ammonia
              then DiffNFrac := PPL.N_2_Org - PeriNFrac
              else DiffNFrac := PPL.P_2_Org - PeriNFrac;

            NSink := NSink + PPL.Sedimentation * DiffNFrac;
          End
        else {not linked phyto}
          Begin
            DetrNFrac := PSRD.PlantSink_To_Detr(ns)*Nut2Org_Refr +
                         PSLD.PlantSink_To_Detr(ns)*Nut2Org_Lab;

            If NState=Ammonia
              then DiffNFrac := PPL.N_2_Org - DetrNFrac
              else DiffNFrac := PPL.P_2_Org - DetrNFrac;

            NSink := NSink + PPL.Sedimentation * DiffNFrac;
          End;

      End;
   NutrRelPlantSink := NSink;
End;

{-------------------------------------------------------------------------------------------------------}

Function TRemineralize.NutrRelColonization: Double;
{When organic matter is colonized from Refr--> Labile, nutrients
 must be accounted for in case the nutrient to organic ratio differs between
 the refractory and labile compartments}
Var Nut2Org_Refr, Nut2Org_Lab, Nut2Org_DissRefr: Double;
    SumColonize: Double;
    ns: AllVariables;
    PD: TDetritus;
Begin

   With Location.Remin do
    If nstate=Ammonia
     then Begin Nut2Org_Refr:=N2Org_Refr; Nut2Org_Lab:=N2OrgLab;
                Nut2Org_DissRefr:=N2OrgDissRefr;  End
     else Begin Nut2Org_Refr:=P2Org_Refr; Nut2Org_Lab:=P2OrgLab;
                Nut2Org_DissRefr:=P2OrgDissRefr;  End;

   SumColonize := 0;
   For ns:=SedmRefrDetr to SuspLabDetr do
     If ns in [SedmRefrDetr,SuspRefrDetr,DissRefrDetr] then
       Begin
         PD := GetStatePointer(ns,StV,WaterCol);
         If PD <> nil then
           If ns = DissRefrDetr
             then SumColonize := SumColonize + PD.Colonization * (Nut2Org_DissRefr - Nut2Org_Lab)
             else SumColonize := SumColonize + PD.Colonization * (Nut2Org_Refr - Nut2Org_Lab);
       End;

   NutrRelColonization := SumColonize

End;

Function TRemineralize.NutrRelDefecation: Double;
{When Defecation takes place in animals, excess nutrients are converted
into NH4.  Sedimented Detritus tends to have a lower fraction of nutrients then
the animals which are defecating organic matter.}
Var ns: AllVariables;
    PAn: TAnimal;
    DetrNFrac,DiffNFrac,NDef  : Double;
    Nut2Org_Refr, Nut2Org_Lab : Double;
Begin
{  NutrRelDefecation := 0;
   If AllStates.Diagenesis_Included then exit;  6/6/08, procedure now relevant to diagenesis model}

   With Location.Remin do
    If nstate=Ammonia
     then Begin Nut2Org_Refr:=N2Org_Refr; Nut2Org_Lab:=N2OrgLab; End
     else Begin Nut2Org_Refr:=P2Org_Refr; Nut2Org_Lab:=P2OrgLab; End;

   NDef := 0;
   For ns := FirstAnimal to LastAnimal do
    If GetState(ns,StV,WaterCol)>0 then
      Begin
        PAn := GetStatePointer(ns,StV,WaterCol);
        DetrNFrac := (1-Def2SedLabDetr) * Nut2Org_Refr +
                        Def2SedLabDetr  * Nut2Org_Lab;

        If AllStates.Diagenesis_Included then DetrNFrac := Nut2Org_Lab;
          {6/6/2008, diagenesis defecation has same nutrients as labile detritus} 

        If NState=Ammonia
          then DiffNFrac := PAn.PAnimalData^.N2Org - DetrNFrac
          else DiffNFrac := PAn.PAnimalData^.P2Org - DetrNFrac;

        NDef := NDef + PAn.Defecation * DiffNFrac;
      End;
   NutrRelDefecation := NDef;
End;

{-------------------------------------------------------------------------------------------------------}

Function TRemineralize.CalcAnimExcr: Double;
{When Excretion takes place in animals, excess nutrients are converted
into NH4.  Dissolved Detritus tends to have a lower fraction of nutrients then
the animals which are excreting organic matter.}
Var ns: AllVariables;
    PDRD,PDLD: TDetritus;
    PAn: TAnimal;
    DetrNFrac,DiffNFrac,Excret: Double;
    Nut2Org_DissRefr, Nut2Org_DissLab : Double;
Begin
   PDRD := GetStatePointer(DissRefrDetr,StV,WaterCol);
   PDLD := GetStatePointer(DissLabDetr,StV,WaterCol);

   With Location.Remin do
    If nstate=Ammonia
     then Begin Nut2Org_DissRefr:=N2OrgDissRefr; Nut2Org_DissLab:=N2OrgDissLab; End
     else Begin Nut2Org_DissRefr:=P2OrgDissRefr; Nut2Org_DissLab:=P2OrgDissLab; End;

   Excret := 0;
   For ns := FirstAnimal to LastAnimal do
    If GetState(ns,StV,WaterCol)>0 then
      Begin
        PAn := GetStatePointer(ns,StV,WaterCol);
        DetrNFrac := PDRD.Excr_To_Diss_Detr(ns)*Nut2Org_DissRefr +
                     PDLD.Excr_To_Diss_Detr(ns)*Nut2Org_DissLab;
        If NState=Ammonia
          then DiffNFrac := PAn.PAnimalData^.N2Org - DetrNFrac
          else DiffNFrac := PAn.PAnimalData^.P2Org - DetrNFrac;

        Excret := Excret + PAn.AnimExcretion * DiffNFrac;
      End;
   CalcAnimExcr := Excret;
End;

Function TRemineralize.CalcAnimResp: Double;
Var ns: AllVariables;
    PAn: TAnimal;
    Resp: Double;
    Nutr2Org: Double;
Begin
   Resp := 0;
   For ns := FirstAnimal to LastAnimal do
    If GetState(ns,StV,WaterCol)>0 then
      Begin
        PAn := GetStatePointer(ns,StV,WaterCol);
        If NState=Ammonia
          then Nutr2Org := PAn.PAnimalData^.N2Org
          else Nutr2Org := PAn.PAnimalData^.P2Org ;
        Resp := Resp +  PAn.Respiration * Nutr2Org;
      End;
   CalcAnimResp := Resp;
End;

{-------------------------------------------------------------------------------------------------------}

Function TRemineralize.CalcPhotoResp: Double;
{When photorespiration takes place in plants, excess nutrients are converted
into NH4.  Dissolved Detritus tends to have a lower fraction of nutrients then
the plants which are going through photorespiration}
Var ns: AllVariables;
    PDRD,PDLD: TDetritus;
    PPl: TPlant;
    DetrNFrac, DiffNFrac,PhotoRsp: Double;
    Nut2Org_DissRefr, Nut2Org_DissLab : Double;
Begin
   PDRD := GetStatePointer(DissRefrDetr,StV,WaterCol);
   PDLD := GetStatePointer(DissLabDetr,StV,WaterCol);

   With Location.Remin do
    If nstate=Ammonia
     then Begin Nut2Org_DissRefr:=N2OrgDissRefr; Nut2Org_DissLab:=N2OrgDissLab; End
     else Begin Nut2Org_DissRefr:=P2OrgDissRefr; Nut2Org_DissLab:=P2OrgDissLab; End;

   PhotoRsp := 0;
   For ns := FirstPlant to LastPlant do
    If GetState(ns,StV,WaterCol)>0 then
      Begin
        PPl := GetStatePointer(ns,StV,WaterCol);
        DetrNFrac := PDRD.Excr_To_Diss_Detr(ns) * Nut2Org_DissRefr +
                     PDLD.Excr_To_Diss_Detr(ns) * Nut2Org_DissLab ;
        If NState=Ammonia
          then DiffNFrac := PPL.N_2_Org - DetrNFrac
          else DiffNFrac := PPL.P_2_Org - DetrNFrac;

        PhotoRsp := PhotoRsp + PPL.PhotoResp * DiffNFrac;
      End;
   CalcPhotoResp := PhotoRsp;
End;

{-------------------------------------------------------------------------------------------------------}

Function TRemineralize.CalcDarkResp: Double;
{ When dark respiration occurs, excess nutrients are converted into NH4. }
Var ns: AllVariables;
    PPl: TPlant;
    Resp: Double;
    Nutr2Org: Double;
Begin
   Resp := 0;
   For ns := FirstPlant to LastPlant do
    If GetState(ns,StV,WaterCol)>0 then
      Begin
        PPl := GetStatePointer(ns,StV,WaterCol);
        If NState=Ammonia
          then Nutr2Org := PPL.N_2_Org
          else Nutr2Org := PPL.P_2_Org;
        Resp := Resp + PPL.Respiration * Nutr2Org;
      End;
   CalcDarkResp := Resp;
End;

{-------------------------------------------------------------------------------------------------------}

{-------------------------------------}
{  assimilation of nutrient by algae  }
{  incl. ammonia preference factor of }
{  Thomann and Fitzpatrick, 1982      }
{  used in WASP (Ambrose et al., 1991)}
{-------------------------------------}
Function TRemineralize.Assimilation : double;
 Var Assim : double;
     SVN, SVA : double;
     NH4Pref : double;
     TNIP: T_N_Internal_Plant;
 Const
     N2NO3 = 0.23;
     N2NH4 = 0.78;
   Procedure AddAssim(P: TStateVariable);
   var PP : TPlant;
       UptkNut : Double;
   const UptakeCO2 = 0.53;
   Begin
     UptkNut := 0;
     If (P.IsPlant) then
     begin
      PP:=TPlant(P);

      If (nstate in [Ammonia,Nitrate]) and (PP.IsFixingN) then
           Exit;  {N-fixation, not assimilation from the water column}

      If (nstate=CO2) and PP.Is_Pcp_CaCO3 then exit;
         {10-26-2007 Because plants are deriving C from the bicarbonate reaction,
          their photosynthesis does not result in a loss of CO2. }

      With PP.PAlgalRec^ do
        If (P.IsAlgae) or (PlantType = 'Bryophytes')  {JSC 9-25-2002, bryophytes assimilate nutrients}
         or ((PlantType = 'Macrophytes') and (PP.MacroType=freefloat)) {JSC 10-21-2007, Free-floating macro. assimilate nutrients}
       Then with PP.PAlgalRec^ do
        Begin
         If nstate <> CO2 then
          begin
            If nstate in [Ammonia,Nitrate]
              then TNIP  := GetStatePointer(PP.NState,NIntrnl,WaterCol)
              else TNIP  := GetStatePointer(PP.NState,PIntrnl,WaterCol);

            If AllStates.SetupRec^.Internal_Nutrients and (TNIP<>nil)
              then UptkNut := TNIP.Uptake * 1e-3
                   {mg/L}          {ug/L}  {mg/ug}
              else
                Begin // external nutrients
                  If nstate in [Ammonia,Nitrate]
                    then UptkNut := PP.N_2_Org * PP.Photosynthesis
                    else UptkNut := PP.P_2_Org * PP.Photosynthesis;
                        {mg/L}         {g/g}          {mg/L}
                End;

            If nstate in [Ammonia,Nitrate] then
              Begin
                If  ((KN + SVA) * (KN + SVN)) <>0 then
                     NH4Pref := SVA * SVN/((KN + SVA) * (KN + SVN))
                              + SVA * KN/((SVA + SVN) * (KN + SVN))
                     else NH4Pref:=0; {Protect Against Div by 0}
              End;
          end;  // non CO2 code

          Case nState of
            Ammonia :  Assim := Assim + UptkNut * NH4Pref;
                       {total nutr assimilated = Sum(photosyn * uptake * proportion)}
                       {g/cu m-d                     g/cu m-d  ~Redfield ratio unitless  }
            Nitrate :  Assim := Assim + UptkNut * (1.0 - NH4Pref);
            Phosphate: Assim := Assim + UptkNut;  {mg/L}
            CO2 :      Assim := Assim + PP.Photosynthesis * UptakeCO2;
          end; {case}  {mg/L}                {mg/L}            {g/g}
        End; {with PP PAlgalRec}
     end; {if is plant}
   end;  {Add Assim}

Var i: integer;
Begin
  Assim := 0.0;
  SVN:=GetState(Nitrate,StV,WaterCol) * N2NO3;
  SVA:=GetState(Ammonia,StV,WaterCol) * N2NH4;
  IF (SVA>0) or (SVN>0) then  {prevent Div by 0}
  With AllStates do For i:=0 to count-1 do
      AddAssim(at(i));

  Assimilation := Assim;
End; { assimilation }



{-------------------------------------------------------------------------------------------------------}
{---------------------------}
{  sum sources of detritus  }
{---------------------------}
Function TDetritus.PlantSink_To_Detr(Ns: AllVariables): Double;
Begin
  PlantSink_To_Detr := 0;

  Case Ns of
    FirstAlgae..LastAlgae:
        begin
    	    If NState=SedmLabDetr  then PlantSink_To_Detr := 0.92;
 	        If NState=SedmRefrDetr then PlantSink_To_Detr := 0.08;
        end;

    FirstMacro.. LastMacro:
        Raise EAquatoxError.Create('Programming Error: PlantSink_To_Detr Passed a macrophyte.');
    FirstAnimal.. LastAnimal:
        Raise EAquatoxError.Create('Programming Error: PlantSink_To_Detr Passed an animal.');
  End; {Case}
End;


Function TDetritus.Mort_To_Detr(Ns:AllVariables):Double;
Var PPl: TPlant;
Begin
  Mort_To_Detr:=0;

  Case ns of
    FirstAlgae..LastAlgae:
      begin
    	  If NState=DissLabDetr then Mort_To_Detr := 0.27;
        If NState=DissRefrDetr  then Mort_To_Detr := 0.03;
        If NState=SuspLabDetr  then Mort_To_Detr := 0.65;
        If NState=SuspRefrDetr then Mort_To_Detr := 0.05;
      end;

    FirstMacro..LastMacro:
        begin
          PPl := GetStatePointer(ns,StV,watercol);
          If PPL.PAlgalRec^.PlantType = 'Bryophytes'
            then
              Begin  {JSC 8-12-2002}
                If NState=DissLabDetr  then Mort_To_Detr := 0.00;
                If NState=DissRefrDetr then Mort_To_Detr := 0.25;
                If NState=SuspLabDetr  then Mort_To_Detr := 0.00;
                If NState=SuspRefrDetr then Mort_To_Detr := 0.75;
              End
            else
              Begin
                If NState=DissLabDetr  then Mort_To_Detr := 0.24;
                If NState=DissRefrDetr then Mort_To_Detr := 0.01; {0.06}
                If NState=SuspLabDetr  then Mort_To_Detr := 0.38;
                If NState=SuspRefrDetr then Mort_To_Detr := 0.37;
              End;
        end;

    FirstAnimal.. LastAnimal:
      begin
    	  If NState=DissLabDetr then Mort_To_Detr := 0.27;
        If NState=DissRefrDetr then Mort_To_Detr := 0.03;
        If NState=SuspLabDetr  then Mort_To_Detr := 0.56;
        If NState=SuspRefrDetr then Mort_To_Detr := 0.14;
      end;
   End; {case}

End; {Mort To Detr}

{-------------------------------------------------------------------------------------------------------}

Function TDetritus.Excr_To_Diss_Detr(Ns:AllVariables):Double;
Begin
  Excr_To_Diss_Detr := 0;
  Case ns of
    FirstAlgae..LastAlgae:
        begin
    	    If NState=DissLabDetr  then Excr_To_Diss_Detr := 0.9;
 	        If NState=DissRefrDetr then Excr_To_Diss_Detr := 0.1;
        end;
    FirstMacro..LastMacro:
        begin
      	  If NState=DissLabDetr  then Excr_To_Diss_Detr := 0.8;
       	  If NState=DissRefrDetr then Excr_To_Diss_Detr := 0.2;
        end;
    else {animal}
        begin
    	    If NState=DissLabDetr  then Excr_To_Diss_Detr := 1.0;
 	        If NState=DissRefrDetr then Excr_To_Diss_Detr := 0.0;
        end;
  End; {case}
End;

{-------------------------------------------------------------------------------------------------------}

Function TDetritus.SumGameteLoss: Double;
Var GamLoss : Double;
    Loop    : AllVariables;
    PA      : TAnimal;

Begin
  GamLoss:=0;
  For Loop:= FirstAnimal to LastAnimal do
    Begin
      PA:=GetStatePointer(Loop,StV,WaterCol);
      If PA<>nil then GamLoss:=GamLoss+PA.GameteLoss;
    End; {loop}
  SumGameteLoss:=GamLoss;
End;

{-------------------------------------------------------------------------------------------------------}

Function TDetritus.DetritalFormation: double;
Var   Mort,Excr,Sed,Gam,j,FracMult : double;
      i                            : integer;

    Procedure SumDF(P: TOrganism);
    Begin
      If P.IsPlantOrAnimal then
        begin
          Mort := Mort + P.Mortality * Mort_To_Detr(P.NState);
          If P.IsAnimal
            then Excr := Excr + TAnimal(P).AnimExcretion * Excr_To_Diss_Detr(P.NState)
            else Excr := Excr + TPlant(P).PhotoResp * Excr_To_Diss_Detr(P.NState);
          If (P.IsMacrophyte)
            then Mort := Mort + TMacrophyte(P).Breakage * Mort_To_Detr(P.NState);
          If P.IsPlant and (not P.IsMacrophyte)
            then With TPlant(P) do
              Begin
                Mort := Mort + TPlant(P).ToxicDislodge * Mort_To_Detr(P.NState);
                TPlant(P).CalcSlough; {update sloughevent}
                If SloughEvent then
                  Begin
                    j := -999; {signal to not write mass balance tracking}
                    TPlant(P).Derivative(j); {update sloughing}
                    If PSameSpecies^ = NullStateVar then FracMult := 1.0
                                                  else FracMult := 2/3;
                   {1/3 of periphyton will go to phytoplankton and 2/3 to detritus with sloughing/scour.}
                    Mort := Mort + Sloughing * FracMult  * Mort_To_Detr(P.NState);
                  End;
              End;
        end;
    End;

Begin
  Mort:=0; Excr:=0; Sed:=0; Gam:=0;
  If NState in [SedmLabDetr,SedmRefrDetr]
    then Sed := SedDetritalFormation
    else With AllStates do For i:=0 to count-1 do
              SumDF(at(i));
  If (NState = SuspLabDetr) then Gam := SumGameteLoss;
  DetritalFormation := Mort + Excr + Sed + Gam;
End;

{-------------------------------------------------------------------------------------------------------}

Function TDetritus.SedDetritalFormation: double;
Var Def, Sed : Double;
    I        : Integer;
    {------------------------------------------------------}
    Procedure SumDef(PP: TAnimal);
      Var   Def2Detr       : Double;
          { all defecation goes to sediment }
      Begin
        If PP.IsAnimal Then
          Begin
             If nstate=SedmLabDetr
                then Def2Detr := Def2SedLabDetr
                else Def2Detr := 1-Def2SedLabDetr;

            Def := Def + Def2Detr * PP.Defecation;
          End;
      End;
    {------------------------------------------------------}
    Procedure SumSed(P: TStateVariable);
      var PP:TPlant;
      begin
        if P.IsAlgae then
        begin
          PP:=TPlant(P);
          If Not PP.IsLinkedPhyto then Sed := Sed + PP.Sedimentation * PlantSink_To_Detr(P.NState);
        end;
      end;
    {------------------------------------------------------}

Begin
  Def:=0; Sed:=0;

  With AllStates do For i:=0 to count-1 do
       SumSed(at(i));

  With AllStates do For i:=0 to count-1 do
       SumDef(at(i));

  SedDetritalFormation := Def + Sed;
End;

Function TDetritus.DailyBurial: Double;
Var BenthArea: Double;
Begin
  { Enabled during dynamic stratification,  6-30-2009}

  If not (nstate in [SedmRefrDetr,SedmLabDetr]) then
     Raise EAquatoxError.Create('Programming error: Daily Burial Called for Non-Sed Detritus');

  With AllStates do
   If nstate = SedmLabDetr
     then DailyBurial := 0
     else If State<=Tiny
       then DailyBurial := 0
       else Begin
              If Stratified and (not linkedmode)  // dynamic stratification daily burial enabled 6/30/2009
                then With Location do With Locale do
                  Begin
                     BenthArea := AreaFrac(MeanThick[Epilimnion],ZMax);
                     If VSeg=Hypolimnion then BenthArea := 1-BenthArea;
                     BenthArea := BenthArea * Location.Locale.SurfArea;
                       {m2}

                     DailyBurial := (State - (InitialCond * BenthArea / Morph.SegVolum[VSeg]));
                       {g/m3 d}      {g/m3}     {g/m2}      {m2 seg.}             {m3 seg.}
                  End
                else DailyBurial := (State - (InitialCond * Location.Locale.SurfArea / Volume_Last_Step));
                       {g/m3 d}      {g/m3}     {g/m2}          {m2 entire system}      {m3 entire sys.}
            End;

  If (Result<0)  then DailyBurial := 0;
End;

{----------------------------------------------------------}
{                    reaeration                            }
{  assuming that reaeration affects only epilimnion        }
{                                                          }
{  updated 7/99  corrected WASP4 error and included        }
{                refinements for very shallow streams      }
{----------------------------------------------------------}

Function TO2Obj.KReaer : double;
Var KReaer1, KReaer2, Vel, TransitionDepth,
    Wnd, OxygenTransfer : double;
    ZDepth : double;
    H, U : double;    {depth and discharge in English units}
Const
    Theta = 1.024; {temp adjustment, Churchill et al., 1962}


    Procedure Estuarine_Reaeration;  {Banks}
    Var Thick, Velocity, Wind: Double;
    Begin
      With Location.Locale do
        Velocity := AllStates.Velocity(pctRiffle,PctPool,False) / 100;  {For Estuary Velocity, Riffle, Pool parameters irrelevant}
         {m/s}                 {cm/s}              {m/s}
      Wind := GetState(WindLoading,StV,WaterCol);
      Thick := Location.MeanThick[Epilimnion];

      KReaer := 3.93*Sqrt(Velocity)/POWER(Thick,1.5) + (0.728*SQRT(Wind)- 0.317*Wind + 0.0372*SQR(Wind))/Thick;
    End;

Begin

 if (AllStates.Vseg=hypolimnion) or (GetState(Temperature,StV,WaterCol)< AllStates.Ice_Cover_Temp) then
  KReaer := 0.0
 else If not Location.Locale.UseCovar
   then KReaer := Location.Locale.EnteredKReaer
   else
      begin
        If AllStates.EstuarySegment  (* or (Location.SiteType in [Lake,Reservr1D])  {JSC Test on Reserv, Lake 8/18/08} *)
          then Begin
                 Estuarine_Reaeration;
                 Exit;
               End;

        ZDepth := Location.MeanThick[Epilimnion];

        With Location.Locale do
          Vel := AllStates.Velocity(pctRiffle,PctPool,False)  * 0.01;
          {m/s}               {cm/s}                           {m/cm}

        If (not (Location.SiteType = Stream)) then Vel:=0;  {no velocity reaeration for nonstreams}

        Wnd:=GetState(WindLoading,StV,WaterCol);  {m/s at 10 m}
        If Wnd=-1 then Wnd:=0; {If state deleted, jsc}

        {Schwarzenbach et al., 1993, coverted to m/sec: }
        KReaer1 := ((4E-4 + 4E-5 * Wnd*Wnd)*864)/ZDepth;
        { 1/d                        m/sec        m}
        if ZDepth < 0.06 then begin {Krenkel and Orlob 1962 for shallow flume}
          U := vel * 3.2808; {m/s -> fps}
          H := ZDepth * 3.2808; {m -> ft}
          KReaer2 := (POWER((U * Location.Locale.Channel_Slope), 0.408))/POWER(H,0.66);
          end
        else begin
          {Covar, 1978; Ambrose et al., 1991: }
          if vel < 0.518 then
            TransitionDepth := 0.0
          else
            TransitionDepth := 4.411 * POWER(vel, 2.9135);

          if ZDepth < 0.61
            then KReaer2 := 5.349 * POWER(vel, 0.67) * POWER(ZDepth, -1.85) {Owens}
            else if ZDepth > TransitionDepth
               then KReaer2 := 3.93 * POWER(vel, 0.50) * POWER(ZDepth, -1.50) {O'Connor}
               else KReaer2 := 5.049 * POWER(vel, 0.97) * POWER(ZDepth, -1.67); {Churchill}
          end; {Covar}

        OxygenTransfer:=Max(KReaer1, KReaer2);
        if OxygenTransfer > 24 then OxygenTransfer := 24;
        OxygenTransfer := OxygenTransfer*POWER(Theta,(GetState(Temperature,StV,WaterCol)-20));
        KReaer := OxygenTransfer;
      end; {ELSE}
End; {KReaer}

{-------------------------------------------------------------------------------------------------------}

Function TO2Obj.Reaeration : double;
Const MPH2MPS = 0.447;
      Theta = 1.024; {temp adjustment, Churchill et al., 1962}
      {MolWt = 44.0;}
Var   BlG, Other : double;
      ZDepth, ZZDepth : double;
      AlgLoop: AllVariables;

      {----------------------------------}
      {  oxygen saturation as fn temp    }
      {  & salinity  Bowie et al., 1985  }
      {----------------------------------}
      Function O2Sat: double;
      var   TKelvin, Salt : double;
            lnCsf, lnCss  : double;
            AltEffect     : double;
      begin
         Salt := GetState(Salinity,StV,WaterCol);
         If Salt<0 then Salt:=0;
         TKelvin := 273.15 + GetState(Temperature,StV,WaterCol);

         lnCsf := -139.34411+(1.575701E5/TKelvin)-6.642308E7 /SQR(TKelvin)+1.243800E10/POWER(TKelvin,3)
                              -8.621949E11/POWER(TKelvin,4);
         If Salt>0 then lnCss :=  lnCsf-Salt*(0.017674-(10.754/TKelvin)+2140.7/SQR(TKelvin))
                   else lnCss := lnCsf;

         AltEffect := (100-(0.0035*3.28083*Location.Locale.Altitude))/100; {Fractional effect due to altitude from Zison et al. 1978}
                                                            {m}
         O2Sat :=  EXP(lnCss) *AltEffect;  {8/19/2008, Changed to APHA code as in Thomann & Mueller}

(*       O2Sat := 1.4277 * exp(-173.492 + 24963.39/TKelvin + 143.3483
                  * ln(TKelvin/100.0) - 0.218492 * TKelvin
                  + Salt * (-0.033096 + 0.00014259 * TKelvin - 1.7e-7 * SQR(TKelvin)));  {JSC 8/18/2008, Change from SQRT to SQR}  *)
      end;
      {---------------------------------}

Var O2S: Double;
Begin {Reaeration}                  //reaeration is additive to the derivative therefore
                                    // a positive number is oxygen from the air to the WC
                                    // a negative number is oxygen from the WC to the air
    ZDepth := Location.MeanThick[Epilimnion];

    BlG := 0;  {count cyanobacteria (blue-greens) biomass}
    For AlgLoop := FirstBlGreen to LastBlGreen do
      If GetState(AlgLoop,StV,WaterCol)>0 then BlG := BlG + GetState(AlgLoop,StV,WaterCol);

    Other := 0; {count other algae biomass, excluding macrophytes}
    For AlgLoop := FirstDiatom to LastGreens do
      If GetState(AlgLoop,StV,WaterCol)>0 then Other := Other + GetState(AlgLoop,StV,WaterCol);
    For AlgLoop := OtherAlg1 to OtherAlg2 do
      If GetState(AlgLoop,StV,WaterCol)>0 then Other := Other + GetState(AlgLoop,StV,WaterCol);

    If (BlG > 1.0) and (BlG > Other) then ZZDepth := 0.25 else ZZDepth := ZDepth;
	{10-15-2001, Modificaiton to account for Cyanobacteria Blooms}
    If ZZDepth > ZDepth then ZZDepth := ZDepth;  {bullet-proof}

    O2S := O2Sat;
    If ZZDepth < Tiny
      then Reaeration := 0
      else Reaeration := KReaer * (O2S - State) * ZDepth/ZZDepth;
           {mg/L d       1/d       mg/L   mg/L  correct for bl-gr bloom}

    If State>(O2S*2) then                                              // 10/27/2010  Oxygen is limited to twice saturation in the event of
       If (Result > (O2S*2)-State) then Reaeration := (O2S*2)-State    // ice cover or hypolimnion, extra goes to reaeration in this special case
                                                                       // 5/7/2012 refined logic so that reaeration is not inadvertently _reduced_ by this code (fix of 6-13-2011 bug)
End; {reaeration}

{----------------------------------------------------------}
{  atmos. exchange of carbon dioxide,Scwarzenbach et al.'93}
{  assuming that reaeration affects only epilimnion        }
{----------------------------------------------------------}
Function TCO2Obj.AtmosExch : double;
Const MPH2MPS = 0.447;
      Theta = 1.024; {temp adjustment, Churchill et al., 1962}
      MolWtCO2 = 44.0;
      MolWtO2 = 32.0;

Var   KLiqCO2: Double;
      P : TO2Obj;
      {--------------------------------}
      {   CO2 equilibrim as fn temp    }
      {    Bowie et al., 1985          }
      {--------------------------------}
      function CO2Sat: double;
      var   TKelvin,
            CO2Henry : double; {Henry's Law constant for CO2}
      const pCO2 =  0.00035; {atmos. partial pressure for CO2}   // fixme?  This number is rising
            MCO2 = 44000.0;
      begin
         If ImportCO2Equil
           then Result := CO2Equil.GetLoad(AllStates.TPresent,True)  //Import CO2Equil from CO2SYS or equivalent
           else
             Begin  //AQUATOX Calculated CO2Equil
               TKelvin := 273.15 + GetState(Temperature,StV,WaterCol);
               CO2Henry := MCO2 * POWER(10.0, (2385.73/TKelvin - 14.0184 + 0.0152642 * TKelvin));
               {g/cu m atm  mg CO2/mole }
               CO2Sat := CO2Henry * pCO2;
               {g/cu m   g/cu m-atm atm }
             End
      end;

Begin {atmosexch}
  AtmosExch:=0;
  If AllStates.Vseg=Hypolimnion then exit;

  P:=TO2Obj(GetStatePointer(Oxygen,StV,WaterCol));
  {Schwarzenbach et al., 1993: }
  KLiqCO2 := P.KReaer * POWER((MolWtO2/MolWtCO2),0.25);
  {1/d        1/d             }
  AtmosExch := KLiqCO2 * (CO2Sat - state);
  {g/cu m-d    1/d        g/cu m  g/cu m }

End; {atmosexch}

    {-------------------}

Function TCO2Obj.SumPhotosynthesis : double;
Var Add : double;
   Procedure AddPhoto(P : TStateVariable);
   var PP : TPlant;
   begin                      
      if P.IsPlant then begin
         PP:=TPlant(P);
         Add := Add + PP.Photosynthesis;
      end;
   end;
Var i: integer;
Begin
  Add := 0.0;
  With AllStates do For i:=0 to count-1 do
      AddPhoto(at(i));
  SumPhotosynthesis := Add;
End;                   { sumphotosynthesis }

    {-------------------}


Function TO2Obj.SumPhotosynthesis : double;
var Add : double;
   Procedure AddPhoto(P: TStateVariable);
   var PP : TPlant;
   begin
      if P.IsPlant then begin
         PP:=TPlant(P);
         Add := Add + PP.Photosynthesis;
      end;
   end;
Var i: integer;
begin
  Add := 0.0;
  With AllStates do For i:=0 to count-1 do
      AddPhoto(at(i));
  SumPhotosynthesis := Add;
end;                      { sumprod }

    {-------------------}
Function TO2Obj.SumRespiration(PlantOnly:Boolean): double;
var Add : double;
   Procedure AddResp(P: TStateVariable);
   var PP : TOrganism;
   begin
      If (P.IsPlant) or
         ((not PlantOnly) and P.IsPlantOrAnimal) then
       begin
         PP:=TOrganism(P);
         Add := Add + PP.Respiration;
       end;
   end;
Var i: integer;
begin
  Add := 0.0;
  With AllStates do For i:=0 to count-1 do
       AddResp(at(i));
  SumRespiration := Add;
end;                      { sumresp }



Function TSuspendedDetr.Resuspension : Double;
Var  SedState: Double;
     PTopC: TBottomCohesives;
     ErodVel, Thick: Double;
Begin                           {Relevant to multi-layer sed model only}
  Resuspension := 0;
  If AllStates.SedModelIncluded
    then
      Begin
        PTopC := (GetStatePointer(Cohesives,StV,SedLayer1));
        ErodVel := PTopC.EVel; {m/d}
        Thick := Location.MeanThick[AllStates.VSeg];

        Case NState of
           SuspLabDetr:  SedState := GetState(SedmLabDetr,StV,WaterCol);
           else {SuspRefrDetr}  SedState := GetState(SedmRefrDetr,StV,WaterCol);
                                                      {g/m3}
        End; {case}

        Resuspension := SedState * ErodVel / Thick;
          {mg/L d}       {mg/L}     {m/d}     {m}
      End
End;

Function TSuspendedDetr.Sedimentation : double;
Var Sedimented, Thick, Decel, SedState : double;
    DensFactor, FracDep, DepVel: Double;
    PTopC: TBottomCohesives;
    PSuspC: TSuspSediment;
Begin
  Thick := Location.MeanThick[AllStates.VSeg];
  With Location.Remin do
       DensFactor := AllStates.DensityFactor(KSedTemp,KSedSalinity);

  If AllStates.EstuarySegment
     then
       Begin
         With Location.Remin do
           Sedimented := KSed / Thick * DensFactor * State;
          {g/cu m-d       m/d    m       unitless   g/cu m}
       End {ESTUARYSEGMENT Sedimented Calculation}
     else
   If AllStates.SedModelIncluded
     then
       Begin
         PTopC := (GetStatePointer(Cohesives,StV,SedLayer1));
         PSuspC := (GetStatePointer(Cohesives,StV,WaterCol));
         If AllStates.UseSSC
           then Begin
                  If PSuspC.State < tiny then FracDep := 0
                    else FracDep := PTopC.Deposition / (PSuspC.State * AllStates.SegVol) ;
                          {1/d}              {g/d}          {g/m3}               {m3}
                  Sedimented := State * FracDep;
                 {mg/L d}      {mg/L}    {1/d}
                End
           else Begin
                 DepVel := PTopC.DVel; {m/d}
                 Sedimented := State * DepVel / Thick;
                 {mg/L d}     {mg/L}   {m/d}    {m}
                End;
       End  {SEDMODELINCLUDED}
    else {NOT ESTUARY, Sed Model Not Included}
      Begin
        DetrSinkToHypo:=0;
        Sedimentation :=0;

        If GetState(Sand,StV,WaterCol) > -1 then exit;
        {if the site is a stream and inorganic sediments are being modeled, sedimentation
         and resuspension are handled using silt as an indicator}

        if (AllStates.MeanDischarge > 0) and (Location.TotDischarge > AllStates.MeanDischarge) then
          Decel := AllStates.MeanDischarge/(Location.TotDischarge)
        else
          Decel := 1;

        With Location.Remin do
          If AllStates.MeanDischarge < Small
            Then Sedimented := KSed/Thick * State * DensFactor
            Else Sedimented := KSed/Thick * State * Decel * DensFactor;

          If (GetState(WindLoading,StV,WaterCol) >= 5.5) {m/sec} and (Thick <= 1.0) then
            Sedimented := - Sedimented; {should be a power fn. of depth}

          If (GetState(Temperature,StV,WaterCol)< AllStates.Ice_Cover_Temp)
               Then Sedimented:= 2 * Sedimented;

         (* If Sedimented>State then Sedimented := State; {Don't sediment more detritus than exists} *)
          If Sedimented<0 then {resuspension, but don't resuspend more Sed Detritus than exists}
            Begin
              Case NState of
                 SuspLabDetr:  SedState := GetState(SedmLabDetr,StV,WaterCol);
                 else {SuspRefrDetr} SedState := GetState(SedmRefrDetr,StV,WaterCol);
                End;
              If -Sedimented > SedState then Sedimented := -SedState;
            End;

      End; {Not Estuary Sed model not inluded code}

      DetrSinkToHypo:=0;
      If     (not AllStates.stratified)
          or (AllStates.Vseg=Hypolimnion)
          or (Sedimented<0)                then Sedimentation:=Sedimented
                                                 {mg/L d}       {mg/L d}
      else begin {stratified}
             With AllStates do with Location do with Locale do
               If not UseBathymetry then DetrSinkToHypo := (ThermoclArea / SurfArea) * Sedimented
                                    else DetrSinkToHypo := (1-AreaFrac(MaxEpiThick, ZMax)) * Sedimented;     //10-14-2010 Note that ZMax parameter pertains to both segments in event of stratification
             Sedimentation := Sedimented-DetrSinkToHypo;
              {mg/L d}         {mg/L d}     {frac}
           end;

End; { sedimentation }


Function TSuspendedDetr.DetrSinkFromEp: Double;
Var SFE: Double;
    EpiVol, HypVol: Double;
Begin
  With AllStates do
   If not Stratified or (VSeg=Epilimnion) Then SFE := 0
   Else
     Begin
       SFE := TSuspendedDetr(EpiSegment.GetStatePointer(NState,SVType,Layer)).DetrSinkToHypo;
       EpiVol := EpiSegment.SegVol;
       HypVol := SegVol;
       SFE := SFE * EpiVol / HypVol;
     End;

  DetrSinkFromEp := SFE;
End;

    (************************************)
    (*                                  *)
    (*     DIFFERENTIAL EQUATIONS       *)
    (*                                  *)
    (************************************)

Procedure TSuspendedDetr.Derivative;
Var DP  : TDissRefrDetr;
    PP  : TSuspRefrDetr;
    Lo,De,WaO,WaI,Pr,Se,Re,TD,DiffUp,DiffDown, FracAerobic,
    DF,Co,STH,SFE,PlSlg,PlToxD, McB, En, Scour : Double;
    PBD    : TBuriedDetr1;
    {----------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates do with SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Load',Lo);
          If (NState<>SuspRefrDetr) then
             Begin
               SaveRate('Decomp',De);
               SaveRate('PlntSlough',PlSlg);
               SaveRate('Macrobreak',McB);
               SaveRate('PlntTDislodge',PlToxD);
             End;
          SaveRate('DetrFm',DF);
          SaveRate('Colonz',ABS(Co));
          SaveRate('Washout',WaO);
          SaveRate('WashIn',WaI);
          SaveRate('Predation',Pr);
          SaveRate('Sedimentation',Se);
          If SedModelIncluded then SaveRate('Resuspension',Re);
          SaveRate('SinkToHypo',STH);
          SaveRate('SinkFromEpi',SFE);
          If Not AllStates.LinkedMode
            then SaveRate('TurbDiff',TD)
            else {If Not AllStates.CascadeRunning
              then} Begin
                     SaveRate('DiffUp',DiffUp);
                     SaveRate('DiffDown',DiffDown);
                   End;
          If AllStates.EstuarySegment then
             SaveRate('Entrainment',En);
          SaveRate('NetBoundary',Lo+WaI-WaO+En+DiffUp+DiffDown+TD);
          SaveRate('Scour',Scour);

        End;
    End;
    {--------------------------------------------------}
    Procedure TrackMB;
    Var NutrFrac, LoadInKg, LossInKg, LayerInKg: Double;
        Typ: AllVariables;
    Begin
     For Typ := Nitrate to Phosphate do With AllStates do
      Begin
       If NState = SuspLabDetr
         then If Typ=Nitrate then NutrFrac := Location.Remin.N2OrgLab
                             else NutrFrac := Location.Remin.P2OrgLab
         else If Typ=Nitrate then NutrFrac := Location.Remin.N2Org_Refr
                             else NutrFrac := Location.Remin.P2Org_Refr;

       with MBLoadArray[Typ] do
         Begin
           LoadInKg :=  (Lo) * SegVol * 1000.0 * 1e-6 * NutrFrac;
           BoundLoad[Derivstep] := BoundLoad[Derivstep] + LoadInKg;   {Load into modeled system}

           If En>0 then LoadInKg :=  (Lo + WaI + En) * SegVol * 1000.0 * 1e-6 * NutrFrac
                   else LoadInKg :=  (Lo + WaI)      * SegVol * 1000.0 * 1e-6 * NutrFrac;
                        {kg nutr}       {mg org/L}     {m3}   {L/m3}  {kg/mg} {nutr / org}

           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           LoadDetr[Derivstep] := LoadDetr[Derivstep] + LoadInKg;
         End;

       with Location.Morph do with MBLossArray[Typ] do
         Begin
           WashoutStep[DerivStep] := WaO * AllStates.SegVol;
             {g}                  {mg/L}                {m3}
           LossInKg := (WaO  {* OOSDischFrac}) * SegVol * 1000.0 * 1e-6 * NutrFrac;    // 3/20/2014 remove OOSDischFrac
           {kg nutr}  {mg org/L}                 {m3}     {L/m3} {kg/mg} {nutr / org}
           BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg;  {Loss from the modeled system}

           If En<0 then LossInKg :=  (-En + WaO {* OOSDischFrac} ) * SegVol * 1000.0 * 1e-6 * NutrFrac;  {loss from the system}  // 3/20/2014 remove OOSDischFrac

           TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
           TotalWashout[Derivstep] := TotalWashout[Derivstep] + LossInKg;
           WashoutDetr[Derivstep] := WashoutDetr[Derivstep] + LossInKg;
         End;

       with MBLayerArray[Typ] do
         Begin
           LayerInKg := (SFE-STH) * SegVol * 1000.0 * 1e-6 * NutrFrac;
           {kg nutr}    {mg org/L}    {m3}   {L/m3} {kg/mg} {nutr / org}
           NSink[Derivstep] := NSink[Derivstep] + LayerInKg;
           NNetLayer [Derivstep] := NNetLayer[Derivstep]  + LayerInKg;
         End;

       with MBLayerArray[Typ] do
          Begin
            LayerInKg := (TD + DiffUp + DiffDown) * SegVol * 1000.0 * 1e-6  * NutrFrac;
           {kg nutr}     {     mg org/L         }        {m3}          {L/m3} {kg/mg} {nutr / org}
            NTurbDiff [Derivstep] := NTurbDiff[Derivstep] + LayerInKg;
            NNetLayer [Derivstep] := NNetLayer[Derivstep] + LayerInKg;
          End;
      End;
    End;
    {--------------------------------------------------}
Var M2_M3: Double;
Begin {TSuspendedDetr.Derivative}
   Lo:=0;De:=0;WaO:=0;WaI:=0;Pr:=0;Se:=0;TD:=0;DiffUp:=0;DiffDown:=0;Scour:=0;
   DF:=0;Co:=0;STH:=0;SFE:=0;Re:=0;PlSlg:=0;PlToxD:=0;McB:=0;En:=0;

   If (NState=SuspLabDetr)
      then PBD := GetStatePointer(BuriedLabileDetr,StV,WaterCol)
      else PBD := GetStatePointer(BuriedRefrDetr,StV,WaterCol);

   If (NState=SuspLabDetr) then
     Begin
       PP := GetStatePointer(SuspRefrDetr,StV,WaterCol);
       DP := GetStatePointer(DissRefrDetr,StV,WaterCol);
       Co := PP.Colonization + DP.Colonization;
     End;
   If (NState=SuspRefrDetr) then Co := -Colonization;

   Lo := Loading;

{ Sloughing and Macrophyte Breakage handled within DetrialFormation Function }

   DF := DetritalFormation;
   WaO := Washout;
   If AllStates.LinkedMode then WaI := Washin;
   Pr := Predation;
   Se := Sedimentation;
   If AllStates.Diagenesis_Included and (Se < 0) then Se := 0;  {no resuspension in diagenesis model}
   Re := Resuspension;
   If nstate = SuspLabDetr then De := Decomposition(Location.Remin.DecayMax_Lab, KAnaerobic, FracAerobic);

   STH:= DetrSinkToHypo;  {SinkToHypo=0 if vseg=hypo}
   SFE:= DetrSinkFromEp;

   If GetStatePointer(Sand,Stv,WaterCol) <>nil then
      Begin
        If PBD = nil then Raise EAQUATOXError.Create('Buried Detritus must be utilized with sand silt clay');
        M2_M3  :=  Location.Locale.SurfArea / AllStates.SegVol ;
       {m2/M3}                     {m2}                       {m3}

        PBD.CalcTotalScour;
        Scour   := State * PBD.Frac_Sed_Scour ;
                   {mg/L}

        PBD.CalcTotalDep;
        Se       := PBD.TotalDep * PBD.Frac_Dep_ToSed * M2_M3;
                        {g/m2 d)                       {m2/m3}
      End;

   If AllStates.LinkedMode and (Not AllStates.CascadeRunning)
      then begin
             DiffUp   := SegmentDiffusion(True);
             DiffDown := SegmentDiffusion(False);
           end
      else If (Not AllStates.LinkedMode) then TD := TurbDiff;

   If AllStates.EstuarySegment then En := EstuaryEntrainment;

   dB := Lo + DF + Co - De - WaO + WaI - Se + Re - Pr + PlSlg + PlToxD + MCB
            - STH + SFE + TD +En + DiffUp + DiffDown + Scour ;

   WriteRates;
   TrackMB;
End;



Procedure TDissDetr.Derivative;
Var Lo,TD,DiffUp,DiffDown,DiffSed,WaO,WaI,DF,DE,Co,PWExp,ToPW, En : Double;
    DetrActiveLayer : TDOMPoreWater;
    DOMState : AllVariables;

     {----------------------------------------------------------}
     Procedure CalcPW;
     Var TopPoreWater: TPoreWater;
         PWDOMLevel: Double;
         PWExp_pw: Double;
     Begin
       PWExp:=0; ToPW:=0;
       TopPoreWater := GetStatePointer(PoreWater,StV,SedLayer1);
       If TopPoreWater <> nil then
         Begin
           PWDOMLevel := GetState(DOMState,StV,SedLayer1);
            {mg/L pw}

           With AllStates do
             If TopPoreWater.VolumeInM3 < tiny
               then PWExp_pw := 0
               else PWExp_pw := PWDOMLevel * TopPoreWater.To_Above / PWVol_Last_Step[SedLayer1];
                  {mg/L d pw}    {mg/L pw}                {m3/m2 d}       {m3/m2 d}

           PWExp   := PWExp_pw *  TopPoreWater.VolumeInM3 / AllStates.SegVol;
       {mg/L d wc }  {mg/L pw}                  {m3 pw}                       {m3 wc}

           With AllStates do
             ToPW  := State * TopPoreWater.From_Above * SedLayerArea / SegVol;;
         {mg/L wc d} {mg/L wc}               {m3/m2 d}     {m2}         {m3 wc}
         End;
     End;
    {----------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Load',Lo);
          SaveRate('DetrFm',DF);
          SaveRate('Washout',WaO);
          SaveRate('WashIn',WaI);
          If NState <> DissRefrDetr then SaveRate('Decomp',De);
          If NState = DissRefrDetr  then SaveRate('Colonz',Co);
          SaveRate('PW Expos',PWExp);
          SaveRate('To PoreW',ToPW);
          If Not AllStates.LinkedMode
             then SaveRate('TurbDiff',TD)
             else {If Not AllStates.CascadeRunning
               then} Begin
                      SaveRate('DiffUp',DiffUp);
                      SaveRate('DiffDown',DiffDown);
                    End;
          If AllStates.SedModelIncluded then SaveRate('DiffusSed',DiffSed);
          If AllStates.EstuarySegment then SaveRate('Entrainment',En);
          SaveRate('NetBoundary',Lo+WaI-WaO+En+DiffUp+DiffDown+TD);
        End;
    End;
    {--------------------------------------------------}
    Procedure TrackMB;
    Var LoadInKg, LossInKg, LayerInKg, NutrFrac: Double;
        Typ: AllVariables;
    Begin
     For Typ := Nitrate to Phosphate do With AllStates do
      Begin
       If NState = DissLabDetr
         then If Typ=Nitrate then NutrFrac := Location.Remin.N2OrgDissLab
                             else NutrFrac := Location.Remin.P2OrgDissLab
         else If Typ=Nitrate then NutrFrac := Location.Remin.N2OrgDissRefr
                             else NutrFrac := Location.Remin.P2OrgDissRefr;

       With MBLoadArray[Typ] do
         Begin
           LoadInKg :=  (Lo) * SegVol * 1000.0 * 1e-6 * NutrFrac;
           BoundLoad[Derivstep] := BoundLoad[Derivstep] + LoadInKg;  {Load into modeled system}

           LoadInKg := (Lo+WaI) * SegVol * 1000.0 * 1e-6 * NutrFrac;
           {kg nutr}    {mg org/L}      {m3}            {L/m3} {kg/mg} {nutr / org}
           If En > 0 then LoadInKg := (Lo+WaI+En) * SegVol * 1000.0 * 1e-6 * NutrFrac;

           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           LoadDetr[Derivstep] := LoadDetr[Derivstep] + LoadInKg;
         End;

      With MBLossArray[Typ] do With Location.Morph do
         Begin
           LossInKg := (WaO {*OOSDischFrac}) * SegVol * 1000.0 * 1e-6 * NutrFrac;  // 3/20/2014 remove OOSDischFrac
           {kg nutr}   {mg org/L}               {m3}   {L/m3} {kg/mg} {nutr / org}
           BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg;  {Loss from the modeled system}

           If En<0 then LossInKg := (-En+ WaO {*OOSDischFrac} ) * SegVol * 1000.0 * 1e-6 * NutrFrac;  // 3/20/2014 remove OOSDischFrac
           TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
           TotalWashout[Derivstep] := TotalWashout[Derivstep] + LossInKg;
           WashoutDetr[Derivstep] := WashoutDetr[Derivstep] + LossInKg;
         End;

       With MBLayerArray[Typ] do
        Begin
          LayerInKg := (TD + DiffUp + DiffDown)   * SegVol * 1000.0 * 1e-6 * NutrFrac;
           {kg nutr}   {       mg org/L       }           {m3}         {L/m3} {kg/mg} {nutr / org}
          NTurbDiff [Derivstep] := NTurbDiff[Derivstep] + LayerInKg;
          NNetLayer [Derivstep] := NNetLayer[Derivstep] + LayerInKg;
        End;
      End; {Typ Loop}
    End; {TrackMB}
    {--------------------------------------------------}
Var FracAerobic: Double;
Begin  {DissDetr.Derivative}
  Lo:=0;En:=0;TD:=0;DiffUp:=0;DiffDown:=0;WaO:=0;WaI:=0;DF:=0;Co:=0;PWExp:=0;ToPW:=0;DiffSed:=0;De:=0;

  If NState = DissRefrDetr
    then DOMState := ReDOMPore
    else { NState = DissLabDetr}
         DOMState := LaDOMPore;

  Lo := Loading;

  If nstate = DissLabDetr then De := Decomposition(Location.Remin.DecayMax_Lab, KAnaerobic, FracAerobic);
  DF := DetritalFormation;
  If (nstate= DissRefrDetr) then Co := Colonization;
  WaO := Washout;
  If AllStates.LinkedMode then WaI := Washin;
  If AllStates.LinkedMode and (Not AllStates.CascadeRunning)
      then Begin
             DiffUp   := SegmentDiffusion(True);
             DiffDown := SegmentDiffusion(False);
           End
      else If (Not AllStates.LinkedMode) then TD := TurbDiff;
  If AllStates.SedModelIncluded then
     Begin
       DetrActiveLayer := GetStatePointer(DOMState,StV,SedLayer1);
       DiffSed:=-DetrActiveLayer.UpperDiffusion(True);
     End;
  If AllStates.EstuarySegment then En := EstuaryEntrainment;

  CalcPW;

  dB := Lo + DF - De - Co - WaO + WaI + TD + DiffUp + DiffDown + DiffSed + PWExp - ToPW + En;

  WriteRates;
  TrackMB;
End;


Procedure TSedimentedDetr.Derivative;
var SuspP  : TSuspLabDetr;
    RefrP  : TSedRefrDetr;
    FracAerobic: Double;
    PBD    : TBuriedDetr1;
    Lo,De,Pr,Se,Re,DF,Co,Bur,Scour,Exps,Dep   : Double;

    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates do with SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Load',Lo);
          SaveRate('DetrFm',DF);
          SaveRate('Colonz',ABS(Co));
          SaveRate('Predation',Pr);
          If (NState<>SedmRefrDetr) then SaveRate('Decomp',De);
          SaveRate('Sedimentation',Se);
          SaveRate('Resuspension',Re);
          SaveRate('Burial',Bur);
          SaveRate('Scour',Scour);
          SaveRate('Exposure',Exps);
        End;
    End;
    {--------------------------------------------------}
    Procedure TrackMB;
    Var LoadInKg, LossInKg, NutrFrac: Double;
        Typ: AllVariables;
    Begin
     For Typ := Nitrate to Phosphate do With AllStates do
      Begin
       If NState = SedmLabDetr
         then If Typ=Nitrate then NutrFrac := Location.Remin.N2OrgLab
                             else NutrFrac := Location.Remin.P2OrgLab
         else If Typ=Nitrate then NutrFrac := Location.Remin.N2Org_Refr
                             else NutrFrac := Location.Remin.P2Org_Refr;

        With MBLoadArray[Typ] do
         Begin
           LoadInKg :=  Lo * SegVol * 1000.0 * 1e-6 * NutrFrac;
           {kg nutr} {mg org/L}    {m3}         {L/m3} {kg/mg} {nutr / org}

           BoundLoad[Derivstep] := BoundLoad[Derivstep] + LoadInKg;  {Load into modeled system}
           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           LoadDetr[Derivstep] := LoadDetr[Derivstep] + LoadInKg;

           LoadInKg := Exps * SegVol * 1000.0 * 1e-6 * NutrFrac;
           {kg nutr} {mg org/L}       {m3}   {L/m3} {kg/mg} {nutr / org}
           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           Exposure[Derivstep] := Exposure[Derivstep] + LoadInKg;
         End;

       With MBLossArray[Typ] do
         Begin
           LossInKg :=  Bur * SegVol * 1000.0 * 1e-6 * NutrFrac;
           {kg nutr} {mg org/L}    {m3}         {L/m3} {kg/mg} {nutr / org}
           TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
           BoundLoss[Derivstep] := BoundLoss[Derivstep] + LossInKg;
           Burial[Derivstep] := Burial[Derivstep] + LossInKg;
         End;
      End; {Typ Loop}
    End; {TrackMB}
    {--------------------------------------------------}

Var M2_M3: Double;    
begin {TSedimentedDetr.Derivative}
  Lo:=0; Se:=0; Re:=0; DF:=0; Co:=0; Pr:=0; De:=0; Exps:=0; Bur:=0; Dep:=0; Scour:=0;

  If (NState=SedmLabDetr)
    then
      Begin
        SuspP:= GetStatePointer(SuspLabDetr,StV,WaterCol);
        PBD:=GetStatePointer(BuriedLabileDetr,StV,WaterCol);
      End
    else {NState=SedmRefrDetr}
      Begin
        SuspP := GetStatePointer(SuspRefrDetr,StV,WaterCol);
        PBD:=GetStatePointer(BuriedRefrDetr,StV,WaterCol);
      End;

  Lo := Loading; {If we want to zero out loading we have to change interface}

  DF := DetritalFormation;

  RefrP := GetStatePointer(SedmRefrDetr,StV,WaterCol);
  Co    := RefrP.Colonization;
  If NState=SedmRefrDetr then Co := -Co;

  Pr := Predation;

  If PBD<>nil then
    Begin
      M2_M3  :=  Location.Locale.SurfArea / AllStates.SegVol ;
     {m2/M3}                     {m2}                       {m3}

      PBD.CalcTotalScour;
      Scour   := State * PBD.Frac_Sed_Scour ;
                 {mg/L}
      Exps := PBD.BuriedDetr_To_Sed * M2_M3 ;
      {mg/L d}          {g/m2 d)      {m2 / m3}

      PBD.CalcTotalDep;
      Dep      := PBD.TotalDep * PBD.Frac_Dep_ToSed * M2_M3;
                      {g/m2 d)                           {m2/m3}
      Bur      := PBD.SedDetr_To_Buried + DailyBurial;
                          {mg/L}             {mg/L}
    End;

  If NState<>SedmRefrDetr then De := Decomposition(Location.Remin.DecayMax_Lab, KAnaerobic, FracAerobic);

  Se := SuspP.Sedimentation;
  If AllStates.Diagenesis_Included and (Se < 0) then Se := 0;  {no resuspension in diagenesis model}
  Re := SuspP.Resuspension;

  Se := Se + Dep; { Combines deposition into the sedimentation rate }

  dB := Lo + Se - Re + DF + Co - Pr - De + Exps - Bur - Scour ;

  WriteRates;
  TrackMB;

End;


Procedure TO2Obj.Derivative;
Const  O2Photo = 1.6;  {see Bowie et al., 1985 for numerous references}
Var Lo,TD,DiffUp,DiffDown,Pho,Reae,Resp,BOD,SOD2,Nitr,WaO,WaI,En, DarkResp : Double;
    OtherSegment                     : TStates;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Load',Lo);
          If Not AllStates.LinkedMode
             then SaveRate('TurbDiff',TD)
             else {If Not AllStates.CascadeRunning
               then} Begin
                      SaveRate('DiffUp',DiffUp);
                      SaveRate('DiffDown',DiffDown);
                    End;
          SaveRate('Photosyn',Pho);
          SaveRate('Reaer',Reae);
          SaveRate('CBOD',BOD);
          SaveRate('Respiration',Resp);
          SaveRate('Nitrific',Nitr);
          SaveRate('Washout',WaO);
          SaveRate('WashIn',WaI);
          SaveRate('NetBoundary',Lo+WaI-WaO+En+DiffUp+DiffDown+TD);
          If AllStates.EstuarySegment then
             SaveRate('Entrainment',En);
          If AllStates.Diagenesis_Included then SaveRate('SOD',SOD2);
        End;
    End;
    {--------------------------------------------------}
    Procedure SetAnoxicVar;
    Begin
      With AllStates do
        Begin
          If Stratified then if VSeg=Hypolimnion then OtherSegment := EpiSegment
                                                 else OtherSegment := HypoSegment;

          If (State < 0.25) or
             (Stratified and (OtherSegment.GetState(Oxygen,StV,WaterCol) < 0.25))
                     then Anoxic := True
                     else Anoxic := False;

          If Stratified then OtherSegment.Anoxic := Anoxic;
        End;
    End;
    {--------------------------------------------------}

Begin {TO2Obj.Deriv}
 Lo:=0;TD:=0;DiffUp:=0;DiffDown:=0;Pho:=0;Reae:=0;Resp:=0;BOD:=0;Nitr:=0;WaO:=0;WaI:=0;En:=0;SOD2:=0;

 with Location.Remin do
   begin
     BOD  := O2Biomass * SumDetrDecomp(StV,False);

     If AllStates.Diagenesis_Included {diagenesis model attached}
       then with AllStates do with Location.Morph do With Diagenesis_Params^ do
         SOD2   :=  SOD  *    (DiagenesisVol(2) / H2.Val) / SegVolum[VSeg] ;
      {g/m3 w d} {g O2/m2 s d}    {m3 s}           {m s}           {m3}
     Resp := O2Biomass * SumRespiration(False);  // includes animals
     Nitr := O2N * TNH4Obj(GetStatePointer(Ammonia,StV,WaterCol)).Nitrification;

     With AllStates do
       TOTResp[DerivStep] := (Resp+BOD+SOD2+Nitr) * SegVol / Location.Locale.SurfArea;
          {g O2/m2 d}        {       g/m3 d     }    {m3}                     {m2}

     Lo   := Loading;
     Pho  := O2Photo        * SumPhotosynthesis;
  {mg O2/L}  {o2/photo bio.}  {mg biomass / L}
     With AllStates do
       Begin
       GPP[DerivStep] := Pho * SegVol / Location.Locale.SurfArea;
          {g O2/m2 d}  {g/m3 d}  {m3}                    {m2}
         DarkResp := O2Biomass * SumRespiration(True);
         NPP[DerivStep] := (Pho - DarkResp) * SegVol / Location.Locale.SurfArea;
            {g O2/m2 d}        {g/m3 d}       {m3}                     {m2}
       End;

     Reae := Reaeration;
     WaO  := Washout;
     If AllStates.LinkedMode then WaI := Washin;
     If AllStates.LinkedMode and (Not AllStates.CascadeRunning)
       then Begin
              DiffUp   := SegmentDiffusion(True);
              DiffDown := SegmentDiffusion(False);
            End
       else If (Not AllStates.LinkedMode) then TD := TurbDiff;
     If AllStates.EstuarySegment then En := EstuaryEntrainment;

     If NoLoadorWash then Begin Lo := 0; WaO :=0; WaI := 0; End;

     dB  :=  Lo + Reae + Pho - BOD - SOD2 - Resp - Nitr - WaO + WaI + TD + DiffUp + DiffDown + En;
     WriteRates;
   end;

  SetAnoxicVar;
End;

Procedure TCO2Obj.Derivative;
Var O2P : TO2Obj;
    CO2Assim, Re, De,TD,DiffUp,DiffDown: double;
    Lo, AE, WaO, WaI, En: Double;
Const CO2Biomass = 0.526;  {Winberg}
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Load',Lo);
          SaveRate('DetDecmp',De);
          SaveRate('Respiration',Re);
          SaveRate('CO2Assim',CO2Assim);
          SaveRate('AtmosEx',AE);
          SaveRate('Washout',WaO);
          SaveRate('WashIn',WaI);
          If Not AllStates.LinkedMode
             then SaveRate('TurbDiff',TD)
             else {If Not AllStates.CascadeRunning
               then} Begin
                      SaveRate('DiffUp',DiffUp);
                      SaveRate('DiffDown',DiffDown);
                    End;
          If AllStates.EstuarySegment then
             SaveRate('Entrainment',En);
          SaveRate('NetBoundary',Lo+WaI-WaO+En+DiffUp+DiffDown+TD);

        End;
    End;
    {--------------------------------------------------}
Begin  {CO2Obj.Derivative}
  CO2Assim:=0; Re:=0; De:=0;TD:=0;DiffUp:=0;DiffDown:=0;
  Lo:=0; AE:=0; WaO:=0; WaI:=0;  En := 0;

   with Location.Remin do begin
     O2P:=TO2Obj(GetStatePointer(Oxygen,StV,WaterCol));
     Lo := Loading;
     De := CO2Biomass * SumDetrDecomp(StV,False);
     Re := CO2Biomass * O2P.SumRespiration(False);
     CO2Assim := Assimilation;
     AE := AtmosExch;
     WaO := Washout;
     If AllStates.LinkedMode then WaI := Washin;
     If AllStates.LinkedMode and (Not AllStates.CascadeRunning)
         then Begin
                DiffUp   := SegmentDiffusion(True);
                DiffDown := SegmentDiffusion(False);
              End
         else If (Not AllStates.LinkedMode) then TD := TurbDiff;
     If AllStates.EstuarySegment then En := EstuaryEntrainment;

     dB   :=  Lo + Re + De - CO2Assim + AE - WaO + WaI + TD + DiffUp + DiffDown + En;

     WriteRates;
   end;
End;

Procedure TNH4Obj.Derivative;
Var   Lo,Re,Ni,Assm,WaO,WaI,TD,DiffUp,DiffDown,En,DiaFlx: Double;
      NSed : TNH4_Sediment;

    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Load',Lo);
          SaveRate('Remin',Re);
          SaveRate('Nitrif',Ni);
          SaveRate('Assimil',Assm);
          SaveRate('Washout',WaO);
          SaveRate('WashIn',WaI);
          If Not AllStates.LinkedMode
             then SaveRate('TurbDiff',TD)
             else {If Not AllStates.CascadeRunning
               then} Begin
                      SaveRate('DiffUp',DiffUp);
                      SaveRate('DiffDown',DiffDown);
                    End;
          If AllStates.EstuarySegment then
             SaveRate('Entrainment',En);

          If NSed<>nil then
             SaveRate('Diag_Flux',DiaFlx);
           SaveRate('NetBoundary',Lo+WaI-WaO+En+DiffUp+DiffDown+TD);

           // RELEASE 3.1 PLUS EXPLICIT AMMONIA REMINERALIZATION OUTPUT  JSC 8/16/2012
       {   SaveRate('PhotoResp',PhotoResp);
           SaveRate('DarkResp',DarkResp);
           SaveRate('AnimExcr',AnimExcr);
           SaveRate('AnimPredn',AnimPredn);
           SaveRate('NutrRelColonization',SvNutrRelColonization);
           SaveRate('NutrRelMortality',SvNutrRelMortality);
           SaveRate('NutrRelGamLoss',SvNutrRelGamLoss);
           SaveRate('NutrRelPeriScr',SvNutrRelPeriScr);
           SaveRate('NutrRelPlantSink',SvNutrRelPlantSink);
           SaveRate('NutrRelDefecation',SvNutrRelDefecation);
           SaveRate('DetritalDecomp',SvSumDetrDecomp); }
           // RELEASE 3.1 PLUS EXPLICIT AMMONIA REMINERALIZATION OUTPUT  JSC 8/16/2012
        End;
    End;
    {--------------------------------------------------}
    Procedure TrackMB;
    Var LoadInKg, LossInKg, LayerInKg: Double;
    Begin With AllStates do Begin
      With MBLoadArray[Nitrate] do
         Begin
           LoadInKg :=  (Lo) * SegVol * 1000.0 * 1e-6;
           BoundLoad[Derivstep] := BoundLoad[Derivstep] + LoadInKg;  {Load into modeled system}

           LoadInKg := (Lo + WaI) * SegVol * 1000.0 * 1e-6;
           {kg N}       {mg N/L     }       {m3}           {L/m3} {kg/mg}
           If En > 0 then LoadInKg := (Lo + WaI + En) * SegVol * 1000.0 * 1e-6;

           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           LoadH2O[Derivstep] := LoadH2O[Derivstep] + LoadInKg;
         End;

      With MBLossArray[Nitrate] do With Location.Morph do
         Begin
           LossInKg :=  WaO { * OOSDischFrac} * SegVol * 1000.0 * 1e-6;  // 3/20/2014 remove OOSDischFrac
           {kg N}    {mg N/L}                    {m3}   {L/m3} {kg/mg}
           BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg;  {Loss from the modeled system}

           If En < 0 then LossInKg :=  (-En + WaO {* OOSDischFrac} ) * SegVol * 1000.0 * 1e-6;  // 3/20/2014 remove OOSDischFrac

           TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
           TotalWashout[Derivstep] := TotalWashout[Derivstep] + LossInKg;
           WashoutH2O[Derivstep] := WashoutH2O[Derivstep] + LossInKg;
         End;

       With MBLayerArray[Nitrate] do
        Begin
          LayerInKg :=  (TD + DiffUp + DiffDown) * SegVol * 1000.0 * 1e-6;
           {kg N}       {        mg N/L         }    {m3}           {L/m3} {kg/mg}
          NTurbDiff [Derivstep] := NTurbDiff[Derivstep] + LayerInKg;
          NNetLayer [Derivstep] := NNetLayer[Derivstep] + LayerInKg;
        End;

     End; {with}
    End; {TrackMB}
    {--------------------------------------------------}
Begin  {NH4Obj.Derivative}
  Lo:=0; Re:=0; Ni:=0; Assm:=0; WaO:=0; WaI:=0; TD:=0; DiffUp:=0; DiffDown:=0; En:=0; DiaFlx:=0;

  Lo := Loading;
  Re := Remineralization;
  Ni := Nitrification;
  Assm := Assimilation;
  WaO := Washout;
  If AllStates.LinkedMode then WaI := Washin;
  If AllStates.LinkedMode and (Not AllStates.CascadeRunning)
     then Begin
            DiffUp   := SegmentDiffusion(True);
            DiffDown := SegmentDiffusion(False);
          End
     else If (Not AllStates.LinkedMode) then TD := TurbDiff;
  If AllStates.EstuarySegment then En := EstuaryEntrainment;

  NSed := GetStatePointer(Ammonia,StV,SedLayer1);
  If NSed<>nil then with AllStates do with Diagenesis_Params^ do With Location.Morph do
    Begin
      DiaFlx := NSed.Flux2Water * DiagenesisVol(1) / SegVolum[VSeg];
     {mg/L d}     {g/m3 sed1 d}       {m3 sed1}        {m3 water}
      Diag_Track[NH3_Diag,DerivStep] :=  NSed.Flux2Water * H1.Val * 1e3;
    End;     {mg/m2 d}                     {g/m3 sed d}       {m}    {mg/g}

{  if (State < VSmall) and ((Lo + Re + TD + DiffUp + DiffDown + En + DiaFlx) < VSmall)
    then  begin dB := 0.0; Lo:=0;Re:=0;Ni:=0;Assm:=0;WaO:=0;WaI:=0;TD:=0;DiffUp:=0;DiffDown:=0;En:=0;DiaFlx:=0; End
    else}  dB := Lo + Re - Ni - Assm - WaO + WaI + TD + DiffUp + DiffDown + En + DiaFlx;

  WriteRates;
  TrackMB
End;

Procedure TNO3Obj.Derivative;
Var   P : TNH4Obj;
      Lo, Nitr, Denitr,NO3Assim,WaO,WaI,TD,DiffUp,DiffDown,En, DiaFlx: double;
      N2Sed :  TNO3_Sediment;

    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Load',Lo);
          SaveRate('Nitrif',Nitr);
          SaveRate('DeNitrif',DeNitr);
          SaveRate('NO3Assim',NO3Assim);
          SaveRate('Washout',WaO);
          SaveRate('WashIn',WaI);
          If Not AllStates.LinkedMode
             then SaveRate('TurbDiff',TD)
             else {If Not AllStates.CascadeRunning
               then} Begin
                      SaveRate('DiffUp',DiffUp);
                      SaveRate('DiffDown',DiffDown);
                    End;
          If AllStates.EstuarySegment then
             SaveRate('Entrainment',En);
          If N2Sed<>nil then
             SaveRate('Diag_Flux',DiaFlx);
          SaveRate('NetBoundary',Lo+WaI-WaO+En+DiffUp+DiffDown+TD);

        End;
    End;
    {--------------------------------------------------}
    Procedure TrackMB;   {Track MB For NO3Obj}
    Var LoadInKg, LossInKg, LayerInKg: Double;
    Begin With AllStates do Begin
      With MBLoadArray[Nitrate] do
         Begin
           LoadInKg :=  (Lo) * SegVol * 1000.0 * 1e-6;
           BoundLoad[Derivstep] := BoundLoad[Derivstep] + LoadInKg;  {Load into modeled system}

           LoadInKg := (Lo + WaI) * SegVol * 1000.0 * 1e-6;
           {kg N}      {    mg N/L   }    {m3}           {L/m3} {kg/mg}
           If (En>0) then LoadInKg := (Lo + WaI + En) * SegVol * 1000.0 * 1e-6;

           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           LoadH2O[Derivstep] := LoadH2O[Derivstep] + LoadInKg;
         End;

      With MBLossArray[Nitrate] do with Location.Morph do
         Begin
           LossInKg :=  WaO {* OOSDischFrac} * SegVol * 1000.0 * 1e-6 ;  // 3/20/2014 remove OOSDischFrac
           {kg N}    {mg N/L}                    {m3}           {L/m3} {kg/mg}
           BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg;  {Loss from the modeled system}

           If En<0 then LossInKg := (-En + WaO {* OOSDischFrac} ) * SegVol * 1000.0 * 1e-6 ;  // 3/20/2014 remove OOSDischFrac
           TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
           TotalWashout[Derivstep] := TotalWashout[Derivstep] + LossInKg;
           WashoutH2O[Derivstep] := WashoutH2O[Derivstep] + LossInKg;

           LossInKg := DeNitr * SegVol * 1000.0 * 1e-6 ;
           {kg N}      {mg N/L}     {m3}           {L/m3} {kg/mg}
           TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
           BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg;  {Loss from the modeled system}
           Denitrify[Derivstep] := Denitrify[Derivstep] + LossInKg;
         End;

       With MBLayerArray[Nitrate] do
        Begin
          LayerInKg := (TD + DiffUp + DiffDown) * SegVol * 1000.0 * 1e-6 ;
           {kg N}      {      mg N/L          }      {m3}           {L/m3} {kg/mg}
          NTurbDiff [Derivstep] := NTurbDiff[Derivstep] + LayerInKg;
          NNetLayer [Derivstep] := NNetLayer[Derivstep] + LayerInKg;
        End;

     End; {with}
    End; {TrackMB}
    {--------------------------------------------------}

Begin {NO3Obj.Derivative}
  Lo:=0;Nitr:=0;Denitr:=0;NO3Assim:=0;WaO:=0;WaI:=0;TD:=0;DiffUp:=0;DiffDown:=0;En:=0;DiaFlx:=0;

  P:=TNH4Obj(GetStatePointer(Ammonia,StV,WaterCol));
  Lo := Loading;
  Nitr := P.Nitrification;
  Denitr := Denitrification;
  NO3Assim := Assimilation;
  WaO := Washout;
  If AllStates.LinkedMode then WaI := Washin;
  If AllStates.LinkedMode and (Not AllStates.CascadeRunning)
     then Begin
            DiffUp   := SegmentDiffusion(True);
            DiffDown := SegmentDiffusion(False);
          End
     else If (Not AllStates.LinkedMode) then TD := TurbDiff;
  If AllStates.EstuarySegment then En := EstuaryEntrainment;

  N2Sed := GetStatePointer(Nitrate,StV,SedLayer1);
  If N2Sed<>nil then with AllStates do with Diagenesis_Params^ do With Location.Morph do
    Begin
      DiaFlx := N2Sed.Flux2Water * DiagenesisVol(1) / SegVolum[VSeg];
     {mg/L d}      {g/m3 sed1 d}        {m3 sed1}        {m3 water}
      Diag_Track[NO3_Diag,DerivStep] :=  N2Sed.Flux2Water * H1.Val * 1e3;
    End;     {mg/m2 d}               {g/m3 sed d}       {m}    {mg/g}

{  If (State < VSmall) and ((Lo + Nitr + TD + DiffUp + DiffDown + En+ DiaFlx) < VSmall)
    then Begin dB := 0.0;  Lo:=0;Nitr:=0;Denitr:=0;NO3Assim:=0;WaO:=0;WaI:=0;TD:=0;DiffUp:=0;DiffDown:=0;En:=0;DiaFlx:=0; End
    else } dB := Lo + Nitr - Denitr - NO3Assim - WaO + WaI + TD + DiffUp + DiffDown + En + DiaFlx;

  WriteRates;
  TrackMB;
End;

Constructor TPO4Obj.Init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                         IC : double; IsTempl: Boolean);
Var ALLoop: Alt_LoadingsType;
Begin
   Inherited Init(Ns,SVT,aName,P,IC, IsTempl);  {TRemineralize}
   FracAvail := 1;
    For ALLoop:=PointSource to NonPointSource do
      Alt_FracAvail[ALLoop]:=1;
End;


Procedure TPO4Obj.Derivative;
Var   Lo, Remin, Assm, WaO, WaI,TD,DiffUp,DiffDown,En,DiaFlx,CaCO3srb : double;
      PSed :  TPO4_Sediment;

    {--------------------------------------------------}
    Procedure WriteRates; {PO4Obj}
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Load',Lo);
          SaveRate('Remin',Remin);
          SaveRate('Assim',Assm);
          SaveRate('Washout',WaO);
          SaveRate('WashIn',WaI);
          If Not AllStates.LinkedMode
             then SaveRate('TurbDiff',TD)
             else {If Not AllStates.CascadeRunning
               then} Begin
                      SaveRate('DiffUp',DiffUp);
                      SaveRate('DiffDown',DiffDown);
                    End;
          If AllStates.EstuarySegment then
             SaveRate('Entrainment',En);

          If PSed<>nil then
             SaveRate('Diag_Flux',DiaFlx);
          SaveRate('Sorpt.CaCO3',CaCO3srb);
          SaveRate('NetBoundary',Lo+WaI-WaO+En+DiffUp+DiffDown+TD);

        End;
    End;
    {--------------------------------------------------}
    Procedure TrackMB;    {PO4Obj}
    Var LoadInKg, LossInKg, LayerInKg: Double;
    Begin With AllStates do Begin
      With MBLoadArray[Phosphate] do
         Begin
           LoadInKg :=  (Lo) * SegVol * 1000.0 * 1e-6;
           BoundLoad[Derivstep] := BoundLoad[Derivstep] + LoadInKg;  {Load into modeled system}

           LoadInKg := (Lo + WaI) * SegVol * 1000.0 * 1e-6;
           {kg P}      {   mg P/L    }    {m3}     {L/m3} {kg/mg}
           If En>0 then LoadInKg := (Lo + WaI + En) * SegVol * 1000.0 * 1e-6;

           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           LoadH2O[Derivstep] := LoadH2O[Derivstep] + LoadInKg;
         End;

      With MBLossArray[Phosphate] do with Location.Morph do
         Begin
           LossInKg :=  WaO {* OOSDischFrac} * SegVol * 1000.0 * 1e-6 ;  // 3/20/2014 remove OOSDischFrac
           {kg P}    {mg P/L}                 {m3}    {L/m3} {kg/mg}
           BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg;  {Loss from the modeled system}

           If En <0 then LossInKg :=  (-En + WaO  {*OOSDischFrac} ) * SegVol * 1000.0 * 1e-6 ;  // 3/20/2014 remove OOSDischFrac

           TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
           TotalWashout[Derivstep] := TotalWashout[Derivstep] + LossInKg;
           WashoutH2O[Derivstep] := WashoutH2O[Derivstep] + LossInKg;

           LossInKg :=  CaCO3srb * SegVol * 1000.0 * 1e-6 ;
           {kg P}    {mg P/L}       {m3}    {L/m3} {kg/mg}
           TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
           BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg;  {Loss from the modeled system}
           CaCO3Sorb[Derivstep]  := CaCO3Sorb[Derivstep] + LossInKg;
         End;

       With MBLayerArray[Phosphate] do
        Begin
          LayerInKg := (TD + DiffUp + DiffDown)* SegVol * 1000.0 * 1e-6 ;
           {kg N}      {      mg P/L          }   {m3}    {L/m3}  {kg/mg}
          NTurbDiff [Derivstep] := NTurbDiff[Derivstep] + LayerInKg;
          NNetLayer [Derivstep] := NNetLayer[Derivstep] + LayerInKg;
        End;

     End; {with}
    End; {TrackMB}
    {--------------------------------------------------}
Var PFluxKg: Double;
Begin {PO4Obj.Derivative}
  Lo:=0;Remin:=0;Assm:=0;WaO:=0;WaI:=0;TD:=0;En:=0;DiffUp:=0;DiffDown:=0;DiaFlx:=0; CaCO3srb := 0;

  Lo := Loading;
  Remin := Remineralization;
  Assm := Assimilation;
  WaO := Washout; 
  If AllStates.LinkedMode then WaI := Washin;
  If AllStates.LinkedMode and (Not AllStates.CascadeRunning)
     then Begin
            DiffUp   := SegmentDiffusion(True);
            DiffDown := SegmentDiffusion(False);
          End
     else If (Not AllStates.LinkedMode) then TD := TurbDiff;
  If AllStates.EstuarySegment then En := EstuaryEntrainment;

  PSed := GetStatePointer(Phosphate,StV,SedLayer1);
  If PSed<>nil then with AllStates do with Diagenesis_Params^ do With Location.Morph do
    Begin
      DiaFlx := PSed.Flux2Water * DiagenesisVol(1) / SegVolum[VSeg];
     {mg/L d}     {g/m3 sed1 d}       {m3 sed1}        {m3 water}
      Diag_Track[TSP_Diag,DerivStep] :=  PSed.Flux2Water * H1.Val * 1e3;
                  {mg/m2 d}               {g/m3 sed d}       {m}    {mg/g}

      with MBLayerArray[Phosphate] do   // 3/16/2010 track total P flux from diagenesis into water column in kg since start of simulation
         Begin
            PFluxKg := (DiaFlx) * SegVol * 1000.0 * 1e-6 ;
             {kg}       {mg/L}     {m3}   {L/m3} {kg/mg}
            PFluxD [Derivstep] := PFluxD[Derivstep]  + PFluxKg;
         End;
    End;

  With AllStates do with Location.Remin do
    CaCO3Srb := KD_P_Calcite * State *    CalcitePcpt     * 1e-6;
    {mg P/L d}     {L/Kg}      {mg/L}  {mg Calcite/L d}    {kg/mg}

{  If (State < VSmall) and ((Lo + Remin + TD + DiffUp + DiffDown + En+DiaFlx) < VSmall)
    then begin dB := 0.0;   Lo:=0; Remin:=0; Assm:=0; WaO:=0; WaI:=0; TD:=0; En :=0; DiaFlx:=0; end
    else } dB := Lo + Remin - Assm - WaO + WaI + TD + DiffUp + DiffDown + En + DiaFlx - CaCO3Srb;

  WriteRates;
  TrackMB;
End;

