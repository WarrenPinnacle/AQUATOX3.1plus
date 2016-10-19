//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Constructor TToxics.Init(Ns, Carry : StateVariables; SVT: T_SVType; L: T_SVLayer; aName : ShortString;
                         P : TStates;  IC : Double; IsTempl: Boolean);
Begin
   Carrier:=Carry;
   Inherited Init(Ns,SVT,L,aName,P,IC, IsTempl);
   if Ns in [FirstOrgTox..LastOrgTox] then PRequiresData^:=True;
   ppb:=0;
   RecrSave := 0;
End;

Destructor TToxics.Destroy;
Begin
   Inherited Destroy; 
End;


Function TToxics.OrgType: T_SVType;
Begin
  If NState in [FirstOrgTox..LastOrgTox] then OrgType := AssocToxTyp(NState)
                                         else OrgType := SVType;
End;

{==================================================}
{        chemical and microbial degradation        }
{            partitioning among phases             }
{==================================================}

(************************************)
(* temperature correction - chemical*)
(************************************)

Function TToxics.Arrhen(Temperature : double): double;

Const
  R = 1.987; { univ. gas in cal/deg mol }
  Kelvin0 = 273.16;
  TObs = 25.0;

Var
  Intermed1,
  Intermed2 : double; { to use in exp }

Begin
   with ChemPtrs^[OrgType].ChemRec do
   begin
     if En <= 0.0 then With AllStates do
       begin
         En := 18000.0;   {average value as default} {cal/mol}
         PMessageStr^ := 'Assuming Activation Energy For Temperature = 18000 cal/mol';
         PMessageErr^ := False;
         TSMessage;
       end;

     Intermed1 := En/(R * (Temperature + Kelvin0));
     Intermed2 := En/(R * (TObs + Kelvin0));
     Arrhen := EXP(-(Intermed1 - Intermed2));
   end; {with}
End; { arrhen }

(*************************************)
(*           hydrolysis              *)
(*************************************)

Function TToxics.Hydrolysis : double ;
Var  KAcidExp,  KHyd,  Hydrol,  KBaseExp, HydrolInKg : double;
Begin

    with ChemPtrs^[OrgType].ChemRec do begin
      KAcidExp := KAcid*POWER(10.0,-GetState(pH,StV,WaterCol));
      KBaseExp := KBase*POWER(10.0,GetState(pH,StV,WaterCol)-14.0);
      KHyd :=       ( KAcidExp   {acid catalyzed}
		    + KBaseExp   {base catalyzed}
		    + KUncat     {uncatalyzed}
		    {+ KCal})    {misc, removed from current ver.}
		    * Arrhen(GetState(Temperature,StV,WaterCol));
      Hydrol     := KHyd * State;
      Hydrolysis := Hydrol;

        With AllStates do with ToxLossArray[OrgType] do
           Begin {save for tox loss output & categorization}
             HydrolInKg := Hydrol  * SegVol * 1000.0 * 1e-9;
                {kg}      {ug/L}         {m3}         {L/m3}  {kg/ug}

             If NState in [POC_G1..POC_G3]
               then HydrolInKg := Hydrol * Location.Locale.SurfArea * 1e-9;
                       {kg}      {ug/m2}                      {m2}    {kg/ug}

             TotalToxLoss[Derivstep] := TotalToxLoss[Derivstep] + HydrolInKg;
             Hydrolys[Derivstep] := Hydrolys[Derivstep]  + HydrolInKg;

             If (SVType=Stv) {tox dissolved in water} or (NState in [DissRefrDetr,DissLabDetr])
               then DissHydr[Derivstep] := DissHydr[Derivstep]  + HydrolInKg;
             If (NState in [SedmRefrDetr,SedmLabDetr, POC_G1..POC_G3])
               then SedHydr[Derivstep] := SedHydr[Derivstep]  + HydrolInKg;
           End;
    end;
End; { hydrolysis }

(************************************)
(*            oxidation             *)
(************************************)
Function TToxics.Oxidation : double ;
Var oxid : double;
Begin
   Oxid := 0.0;

   {If Oxidation turned back on, enable mass balance tracking}

   Oxidation := Oxid;
End;


    (****************************)
    (*  simple approach of      *)
    (* Schwarzenbach et al. 1993 )
    (****************************)

Function TToxics.Photolysis  : double;

Var   Solar0, LightFactor, ScreeningFactor, PhotolInKg,
      RadDistr0, Thick, KPhot, PhotoL, PhotRate, Alpha : Double;

Const AveSolar = 500;  {L/d}
      RadDistr = 1.6;

Begin
  Alpha := AllStates.Extinct(False,True,True,False,False); {don't include periphyton, but include all other plants}

  With AllStates do
   If ChemPtrs^[OrgType].ChemRec.PhotolysisRate > 0.0 then
     begin
       If Vseg=Epilimnion then begin
                                 Solar0 :=GetState(Light,StV,WaterCol);
                                 RadDistr0 := 1.2;
                               end
                          else begin
                                 Solar0 :=GetState(Light,StV,WaterCol)*exp(-Alpha*Location.MeanThick[Epilimnion]);
                                 RadDistr0 := 1.6;
                               end;

       Thick := Location.MeanThick[VSeg];

       PhotRate := ChemPtrs^[OrgType].ChemRec.PhotolysisRate;

       LightFactor:=Solar0/AveSolar;

       ScreeningFactor := (RadDistr/RadDistr0) * ( (1-exp(-Alpha*Thick)) / (Alpha*Thick));

       KPhot := PhotRate * ScreeningFactor * LightFactor;

       Photol := KPhot * State ;
     end {if}
       else
         Photol  := 0.0;
    if Photol < 0.0 then Photol := 0.0;

    Photolysis := Photol;

      With AllStates do with ToxLossArray[OrgType] do
         Begin {save for tox loss output & categorization}
           PhotolInKg := Photol  * SegVol * 1000.0 * 1e-9;
              {kg}      {ug/L}         {m3}         {L/m3}  {kg/ug}
           Photolys[Derivstep] := Photolys[Derivstep]  + PhotolInKg;
           TotalToxLoss[Derivstep] := TotalToxLoss[Derivstep] + PhotolInKg;
           If (SVType=StV) or (NState in [DissRefrDetr,DissLabDetr])
              then DissPhot[Derivstep] := DissPhot[Derivstep]  + PhotolInKg;
         End;

End; {Photolysis}


  (********************************)
  (*       Volatilization         *)
  (*   based on formulations in   *)
  (*   Schwarzenbach et al. 1993  *)
  (********************************)

Function TToxics.Volatilization  : double ;
Var WindLd,
    Volat, VolatInKg,
    ToxSat,    {Saturation concentration of pollutant mg/m3}
    KOVol,      {mass transfer coeff., m/d}
    KLiq,       {liquid-phase mass trans. coeff., m/d}
    KGas,       {gas-phase mass trans. coeff., m/d}
    Temp: double; {degrees C at time of evaluation}
    T : double;   {degrees Kelvin}
    Sal: double; {salinity o/oo}
    HLCSaltFactor: Double; {henry law salinity factor, unitless}
    HenryLaw : double;  {local, atm cu m/mol units -> unitless}
Const
  Gas = 8.206E-5; {atm cu m/mol K} {R in tech doc.}
  Kelvin0 = 273.16;
  cmpsec2mpd = 864.0;                           
Begin
  Volatilization:=0;
  If (State<Tiny) then Exit;

  Temp := GetState(Temperature,StV,WaterCol);
  With ChemPtrs^[OrgType].ChemRec do
  Begin
    if (Henry > 0.0) and (Temp > AllStates.Ice_Cover_Temp)
       and (AllStates.VSeg=Epilimnion) and (NonDissoc>VSmall) then
      Begin
        T := Kelvin0 + GetState(Temperature,StV,WaterCol);  {to correct for T of obs.}

        Sal := GetState(Salinity,StV,WaterCol);
        If Sal>0 then HLCSaltFactor := 1 + 0.01143 * Sal
                 else HLCSaltFactor := 1;
                 
        HenryLaw := (Henry    *   HLCSaltFactor) / (Gas * T);
        {unitless =(atm cu m/mol)   unitless     / ((atm cu m/mol K) * K) }

        WindLd:= GetState(WindLoading,StV,WaterCol);
        if WindLd<=0 then WindLd:=0.1             {RAP 4/10/96}
                     else WindLd := WindLd * 0.5; {m/s at 10 m to m/s at 10 cm based on Banks, 1975}
        KGas := 168.0 * WindLd * POWER((18.0/MolWt), 0.25); {Thomann & Muller,'87}
        {m/d              m/s                             }
        {KGas := (0.3 + 0.2 * WindLd) * POWER((18.0/MolWt), 1.17) * cmpsec2mpd * HenryLaw;}
        {m/d                 m/s                                   m/d/(cm/s)   unitless}
        if NonDissoc < Small then
          KOVol := 0.0
        else begin
         With AllStates do
          KLiq := TO2Obj(GetStatePointer(Oxygen,StV,WaterCol)).KReaer * Location.MeanThick[VSeg] * POWER((32.0/MolWt), 0.25) * 1/NonDissoc;
          {m/d                                          /d                        m           unitless      unitless fraction }
         If KLiq = 0
           then KOVol := 0
           else KOVol := 1.0/(1.0/KLiq + 1.0/(KGas * HenryLaw * NonDissoc)); {sum of resistances}
                {m/d                           m/d         m/d    unitless}
         end;

        ToxSat:= ChemPtrs^[OrgType].Tox_Air / (HenryLaw * NonDissoc) * 1000 ;
        {mg/cu m or ug/L}           {g/m3}    {unitless} {unitless}   {mg/g}
        Volat := KOVol/Location.MeanThick[Epilimnion] * (ToxSat - State);
      { ug/L d    m/d                m                   mg/cu m   mg/cu m}
      End
    Else
      Volat := 0.0;

    Volatilization := -Volat;   //10/22/2010  JSC Changed Sign

      If Volat<0 then
        With AllStates do with ToxLossArray[OrgType] do
           Begin {save for tox loss output & categorization}
             VolatInKg := -Volat * SegVol * 1000.0 * 1e-9;
                {kg}      {ug/L}         {m3}         {L/m3}  {kg/ug}
             TotalToxLoss[Derivstep] := TotalToxLoss[Derivstep] + VolatInKg;
             Volatiliz[Derivstep] := Volatiliz[Derivstep]  + VolatInKg;
             DissVolat[Derivstep] := DissVolat[Derivstep]  + VolatInKg;
           End;                                            

  end; {with}
End;

(**********************************************)
(*      microbial degradation of chemical     *)
(**********************************************)
Function TToxics.MicrobialMetabolism(Var FracAerobic: Double) : double;
Var KM, Microbial,MicrobInKg : Double;
    PWVolumeInL              : Double;
    PPore                    : TPoreWater;

Begin
 FracAerobic := 0;

 With ChemPtrs^[OrgType].ChemRec do
   If KMDegrdn > 0.0 then
     Begin
       KM := KMDegrdn;    {KM usually is determined for water  12-10-1997}
       If not (NState in [FirstOrgTox..LastOrgTox]) {if the toxicant is not in the water phase}
          then KM := KM * 4.0; {increased activity in detritus as opposed to water, see Gunnison '85}
                               {based on AECos experiments, Athens EPA Lab}
       Microbial := Decomposition(KM, KMDegrAnaerobic, FracAerobic);
     End
   else Microbial := 0.0;

  MicrobialMetabolism := Microbial;

          {----------------------write mass balance output ------------------------}
          With AllStates do with ToxLossArray[OrgType] do
           Begin {save for tox loss output & categorization}
             PPore := GetStatePointer(PoreWater,StV,Layer);
             PWVolumeInL := 0;
             IF PPore <> nil
              then If (PPore.VolumeInM3>tiny)
                then PWVolumeInL := PPore.VolumeInL;

             If Layer=WaterCol
                then MicrobInKg := Microbial  * SegVol * 1000.0 * 1e-9
                        {kg}      {ug/L wc}        {m3 wc}         {L/m3}  {kg/ug}
                else if (NState in [PoreWater..LaDOMPore])
                    then MicrobInKg := Microbial  * PWVolumeInL * 1e-9
                           {kg}        {ug/L pw}       {L pw}    {kg/ug}
                else if (NState in [POC_G1..POC_G3])
                    then MicrobInKg := Microbial * Location.Locale.SurfArea * 1e-9
                           {kg}        {ug/m2}            {m2}                {kg/ug}
                    else MicrobInKg := Microbial * SedLayerArea * 1e-9;
                            {kg}        {ug/m2}        {m2}      {kg/ug}

             TotalToxLoss[Derivstep] := TotalToxLoss[Derivstep] + MicrobInKg;
             MicrobMet[Derivstep]    := MicrobMet[Derivstep]    + MicrobInKg;

             If Layer=WaterCol then
               Begin
                 If (SVType=Stv) {tox dissolved in water} or (NState in [DissRefrDetr,DissLabDetr])
                   then DissMicrob[Derivstep] := DissMicrob[Derivstep]  + MicrobInKg;
                 If (NState in [SedmRefrDetr,SedmLabDetr])
                   then SedMicrob[Derivstep] := SedMicrob[Derivstep]  + MicrobInKg;
               End;
           End;
          {----------------------write mass balance output ------------------------}

End;

(************************************)
(*        biotransformation         *)
(************************************)
Function TToxics.Biotransformation : double;
Var Carry: TStateVariable;
    BioTInKg: Double;
begin
  Biotransformation := 0;

  Carry := GetStatePointer(nstate,StV,WaterCol);
  If Carry.IsAnimal
     then Biotransformation := State * TAnimal(Carry).Anim_Tox[OrgType].Bio_Rate_Const;
  If Carry.IsPlant
     then Biotransformation := State * TPlant(Carry).Plant_Tox[OrgType].Bio_Rate_Const;

   With AllStates do with ToxLossArray[OrgType] do
     Begin {save for tox loss output & categorization}
       BioTInKg := Result  * SegVol * 1000.0 * 1e-9;
          {kg}       {ug/L}          {m3}         {L/m3}  {kg/ug}

       TotalToxLoss[Derivstep] := TotalToxLoss[Derivstep] + BioTInKg;
       BioTransf[Derivstep] := BioTransf[Derivstep]  + BioTInKg;
     End;

end;

(**************************************************************)
(*        Microbial_BioTrans_To_This_SV       JSC, 5/27/99    *)
(*                                                            *)
(*  Calculates the Microbial BioTransformation from other     *)
(*  org. chemicals into this H2OTox or Detrital Compartment   *)
(*                                                            *)
(**************************************************************)

Function TToxics.Microbial_BioTrans_To_This_SV(Aerobic: Boolean):Double;
Var MBTSum   : Double;
    ToxLoop  : T_SVType;
    FracToMe : Double;
    BTRec    : TBioTransObject;
    MicrobM  : Double;
    FracAerobic: Double;
    ToxPtr   : TToxics;

Begin
  If not (NState in [PoreWater,ReDOMPore,LaDOMPore,FirstOrgTox..LastOrgTox, FirstDetr..LastDetr, Cohesives..NonCohesives2, POC_G1..POC_G3]) then
     Raise EAQUATOXERROR.CREATE('Programming Error, BioTrans_To_This_SV must be passed an org tox, sed, or detrital category');

  MBTSum := 0;
  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do                   { loop through all org toxicants }
    Begin
      If NState in [FirstTox..LastTox]  {Tox In Water}
         then ToxPtr := GetStatePointer(AssocToxSV(ToxLoop),StV,Layer)
         else ToxPtr := GetStatePointer(NState,ToxLoop,Layer);
      If ToxPtr <> nil then
        If (ToxPtr.State>0) then  {if this toxicant exists then}
          With AllStates.ChemPtrs^[ToxLoop] do
          Begin
            If Aerobic then BTRec := Get_BioTrans_Record(BTAerobicMicrobial,NullStateVar)
                       else BTRec := Get_BioTrans_Record(BTAnaerobicMicrobial,NullStateVar);

            FracToMe := BTRec.Percent[OrgType]/100.0;       {fraction of biotrans to this org tox compartment}

            IF FracToMe > 0 then
              Begin
                MicrobM := ToxPtr.MicrobialMetabolism(FracAerobic);  {also returns frac aerobic}
                If Aerobic then MicrobM := MicrobM * FracAerobic
                           else MicrobM := MicrobM * (1-FracAerobic);

                MBTSum := MBTSum + (MicrobM * FracToMe);
              End;
          End;
    End;

   Microbial_BioTrans_To_This_SV := MBTSum;
End;

(**************************************************************)
(*                  Biotrans_To_This_Org      JSC, 5/27/99    *)
(*                                                            *)
(*  Calculates all of the BioTransformation from other        *)
(*  organic chemicals into this organism toxicant compartment *)
(*                                                            *)
(**************************************************************)

Function TToxics.Biotrans_To_This_Org: Double;

Var ToxLoop    : T_SVType;
    BTSum      : Double;
    BTRec      : TBioTransObject;
    AnimPtr    : TAnimal;
    FracToMe   : Double;
    AnimToxPtr : TToxics;

Begin
  If not (NState in [FirstBiota..LastBiota]) then
     Raise EAQUATOXERROR.CREATE('Programming Error, BioTrans_To_This_Org must be passed an organism');

  BTSum := 0;
  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do                   {loop through all org toxicants    }
    If (ToxLoop <> SVType) and (GetState(NState,ToxLoop,WaterCol)>tiny)  {if this toxicant is relevant then }
      then With AllStates.ChemPtrs^[ToxLoop] do
        Begin
          BTRec := Get_BioTrans_Record(BTUserSpecified,NState); {see if species specific Biotrans data exists}
          If BTRec = nil then                                   {otherwise, use general parameterization}
            Case NState of
              FirstAlgae..LastAlgae : BTRec := Get_BioTrans_Record(BTAlgae,NullStateVar);
              FirstFish..LastFish   : BTRec := Get_BioTrans_Record(BTFish,NullStateVar);
              else Begin
                     AnimPtr := GetStatePointer(NState,StV,WaterCol);
                     If (AnimPtr.PAnimalData^.Animal_Type='Benthic Insect')
                        Then BTRec := Get_BioTrans_Record(BTBenthInsect,NullStateVar)
                        Else BTRec := Get_BioTrans_Record(BTOtherInvert,NullStateVar);
                   End; {else}
            End; {Case}

          FracToMe := BTRec.Percent[OrgType]/100.0;            {fraction of biotrans to this org tox compartment}

          IF FracToMe > 0 then
            Begin
              AnimToxPtr := GetStatePointer(NState,ToxLoop,WaterCol);
              BTSum := BTSum + (FracToMe * AnimToxPtr.BioTransformation);
            End;
        End;  {loop through toxicants}

   Biotrans_To_This_Org := BTSum;
End;


  (************************************)
  (*              ionization          *)
  (************************************)
  Function TToxics.Ionization: Double;
(*  Function BaseIonize : Double;
    BEGIN
    with ChemPtrs^.ChemRec do begin
        BaseIonize := StVar[Phase] * POWER(10.0,-(pH-2.0))
                      /(POWER(10.0, -Pka) + POWER(10.0, -(pH-2.0)));
      {pH at colloid surface = bulk pH -2}
      end;
    END;*) (* baseionize *)

    (******************************)
    (* ionization of acid compound*)
    (******************************)

(*    Function AcidIonize:  Double;
    BEGIN
      with ChemRec do begin
        if pka <> 0.0 then
          AcidIonize := StVar[Phase] * POWER(10.0, -Pka)
                        /(POWER(10.0, -Pka) + POWER(10.0,-pH))
        else
          AcidIonize := 0.0;
      end;
    END;*) (*acidionize*)
  begin  {Ionization}
(*   with ChemRec do begin
    If pka < 0.0 then
      Ionize[Phase] := BaseIonize
    else
      Ionize[Phase] := AcidIonize;
    Ionization := Ionize[Phase];
    end; *)
    Ionization:=0;
   end;


Procedure TToxics.CalculateLoadByBCF;
Var Org_PPB, BCF, CarrierState, ToxState: Double;
    PCarrier: TOrganism;
Begin
   PCarrier    :=  GetStatePointer(NState,StV,WaterCol);
   CarrierState:=  PCarrier.State;
   {mg dry/L}
   ToxState := GetState(AssocToxSV(SVType),StV,WaterCol);
    {ug/L}

   If NState in [FirstDetr..LastDetr]
     then BCF := CalculateKOM 
     else BCF := PCarrier.BCF(AllStates.CalculateTElapsed(SVType),SVType);
       {L/kg dry}

   Org_PPB :=  ToxState  *  BCF ;
 {ug/kg dry}   {ug/L}     {L/Kg dry}

   State  := Org_PPB * CarrierState / 1e6;
  {ug/L     ug/kg dry   mg dry /L    mg/kg}
End;

    (******************************)
    (* obtain loading for unit vol*)
    (******************************)

Procedure TToxics.CalculateLoad(TimeIndex : Double);
{  atmospheric and point-source loadings should be to epilimnion in single-segment mode. 11/19/96}
 { All chemical loadings to upper layer for estuary version, biota split between layers 10-17-02}

Var SegVolume, Inflow : Double;
    Loop              : Alt_LoadingsType;
    CPtr              : TStateVariable;
    CarrierLdg        : Double;
    AddLoad, LoadRes  : Double;
    PInputRec         : PDetritalInputRecordType;
    ToxLoad, Wet2Dry  : Double;

Begin
  Loading:=0;

  If AllStates.SetupRec^.BCFUptake and (nstate in [FirstDetr..LastDetr, FirstBiota..LastBiota]) then
    Begin
       CalculateLoadByBCF;
       Exit;
    End;

  PInputRec := nil;
  SegVolume := AllStates.SegVol;
  If (SegVolume=0) then Raise EAquatoxError.Create('Water Volume is Zero, Cannot continue Simulation');
  With Location.Morph do
    Inflow := InflowH2O[AllStates.VSeg] * OOSInflowFrac;

  If NState in [DissRefrDetr..SuspLabDetr,Cohesives..NonCohesives2]
    then
      Begin  {Code to support organisms or sediments with PS, NPS, Inflow Loadings}
        CPtr      := GetStatePointer(Carrier,StV,WaterCol);
        Loading   := 0;

        If NState in [DissRefrDetr..SuspLabDetr]
          then Begin         {Split into four compartments}
                 PInputRec := @TDissRefrDetr(GetStatePointer(DissRefrDetr,StV,WaterCol)).InputRecord;
                 LoadRes := ReturnLoad(TimeIndex,PInputRec^.Load) * TDetritus(CPtr).MultFrac(TimeIndex,False,nil);
                 ToxLoad := ReturnLoad(TimeIndex,PInputRec^.ToxLoad[SVType]);
               End
          else Begin
                 LoadRes := ReturnLoad(TimeIndex,CPtr.LoadsRec);
                 ToxLoad := ReturnLoad(TimeIndex,LoadsRec);
               End;

        LoadRes := LoadRes * Inflow / SegVolume * ToxLoad / 1e6;
        {ug/L       mg/L     cu m/d     cu m       ug/kg   mg/kg }


        { Atmospheric and point-source loadings should be to epilimnion in single-segment mode;  9/9/98 }
        If AllStates.LinkedMode or (AllStates.VSeg=Epilimnion) then
          For Loop:=PointSource to NonPointSource do
            If Loop <> DirectPrecip then {Irrelevant for Susp,Dissolved Detritus and Sediment}
              Begin
                If NState in [DissRefrDetr..SuspLabDetr]
                  then Begin         {Split into two or four compartments}
                         AddLoad := ReturnAltLoad(TimeIndex,PInputRec^.Load,Loop) * TDetritus(CPtr).MultFrac(TimeIndex,True,@Loop);
                                        {g/d}                                                       {unitless}
                         ToxLoad := ReturnAltLoad(TimeIndex,PInputRec^.ToxLoad[SVType],Loop);
                         {ug/kg}
                       End
                  else Begin
                         AddLoad := ReturnAltLoad(TimeIndex,CPtr.LoadsRec,Loop);
                         ToxLoad := ReturnAltLoad(TimeIndex,LoadsRec,Loop);
                       End;

               AddLoad := AddLoad / SegVolume * ToxLoad / 1e6;
               {ug/L}     {g/d}     {cu m}      {ug/kg}  {mg/kg}

               LoadRes := LoadRes + AddLoad;
                           {mg/L d} {mg/L d}
              End;

        Loading := LoadRes;

        Exit; {Loading calculation is complete for Loadings of Tox in Susp&Diss Detritus}
      End;

  If (nstate in [FirstDetr..LastDetr,FirstBiota..LastBiota])
   then
     Begin {Toxicants within Organisms Loadings}
        {Calc CarrierLdg, the inflow loading of the carrier}
        CPtr     := GetStatePointer(Carrier,StV,WaterCol);
        CarrierLdg := ReturnLoad(TimeIndex,CPtr.LoadsRec) * Inflow / SegVolume;
         {ug/kg}

        Inherited CalculateLoad(TimeIndex);  {TStateVariable} {Put the organism's inflow tox load in ug/kg into the Loading variable}

        If nstate in [SedmRefrDetr..SuspLabDetr]  {sediment input in dry weight units}
           then Wet2Dry := 1.0
           else Wet2Dry := WetToDry;

       {CarrierLdg is inflow loading only and has already been normalized for segment volume}
        Loading := Loading * CarrierLdg / 1e6   *   Wet2Dry;
        {ug/L d     ug/kg      mg/L      mg/kg  {loadings need conversion to dry weight}

        Exit; {loading calculation is complete for toxicants within organisms}
     End;

  SegVolume := AllStates.SegVol;
  If AllStates.EstuarySegment and (AllStates.VSeg=Hypolimnion) then exit; {estuary vsn. 10-17-2002}

  {Inflow Loadings of Toxicant in Water}
  Inherited CalculateLoad(TimeIndex);  {TStateVariable}
  With Location.Morph do
    Inflow := InflowH2O[AllStates.VSeg]* (OOSInflowFrac);

  If AllStates.EstuarySegment then Inflow := Location.Morph.InflowH2O[Epilimnion];
                                      {upstream loadings only, estuary vsn. 10-17-02}

  Loading := Loading * Inflow / SegVolume ;
  {ug/L d     ug/L     cu m/d      cu m}

  {Point Source Non-Point Source and Direct Precipitation Loadings of Toxicant in Water}
  With LoadsRec do
    If AllStates.LinkedMode or (AllStates.VSeg=Epilimnion) then
      If (not (Alt_Loadings[PointSource]=nil)) then
        For Loop:=PointSource to NonPointSource do
          Begin
            AddLoad:=0;
            If Alt_UseConstant[Loop]
              then AddLoad := Alt_ConstLoad[Loop]  {g/d or g/sq m. d}
              else if Alt_Loadings[Loop]<>nil then AddLoad := Alt_Loadings[Loop].GetLoad(TimeIndex,True);

            AddLoad := (AddLoad * Alt_MultLdg[Loop]/SegVolume)  *  1e3 ;
            {ug/L d}     {g/d }      {unitless}       {cu m}     {mg/g}   { (mg/m3)=(ug/L) }
            If Loop=DirectPrecip then AddLoad := AddLoad   *  Location.Locale.SurfArea;
                                      {ug/L d} {ug/(sq m.)(L)(d)}               {sq m.}
            Loading:=Loading + AddLoad;
                     {ug/L d} {ug/L d}
          End; {Loop}
End;


Function TToxics.WetToDry: Double;
Var PS: TStateVariable;
Begin
  PS := GetStatePointer(Carrier,StV,Layer);
  if nState in [FirstOrgTox..LastOrgTox,              {dissolved in water}
                Sand..NonCohesives2, POC_G1..POC_G3]  {or in sediment}
    then WetToDry := 1.0
    else WetToDry := PS.WetToDry;
End;


(************************************)
(*      NonDissoc (Ionization)      *)
(************************************)

Function TToxics.NonDissoc: Double;
Var pH_Val: Double; {pH Value}
    Charged: Double;

Begin
 With ChemPtrs^[OrgType].ChemRec do
   if IsPFA then
     Begin
       NonDissoc := 0;
       Exit;
     End;

 Charged := 0;
 If nstate in [FirstAnimal..LastAnimal{DissRefrDetr, PartRefrDetr,  suspLabDetr}] then
   Charged := -0.5;  {lower pH at gill surface--McKim & Erickson, 1991}

 pH_Val:=GetState(pH,StV,WaterCol);
 With ChemPtrs^[OrgType].ChemRec do
  Begin
    If pKa=0
      then Nondissoc := 1
      else If ChemIsBase
        then Nondissoc := 1 /(1+POWER(10,pKa-pH_Val))
        else Nondissoc := 1 /(1+POWER(10,(pH_Val+Charged-pKa)));
  End; {With}
End;


(************************************)
(*            Discharge             *)
(************************************)

Function TToxics.Washout: Double;
begin
  If SVType<>StV then Raise EAQUATOXError.Create('Programming Error, TToxics.Washout must be passed Tox Dissolved in Water');

  WashOut := Inherited WashOut; {TStateVariable}
end;

Function TToxics.WashIn: Double;
Begin
  If SVType<>StV then Raise EAQUATOXError.Create('Programming Error, TToxics.WashIn must be passed Tox Dissolved in Water');

  WashIn := Inherited WashIn;   {TStateVariable}
End;

(************************************)
(*            Wash In               *)
(************************************)

Function TToxics.ToxInCarrierWashin: Double;
Var PUpstreamCarrier: TStateVariable;
    i      : Integer;
    PUpVol : TVolume;
    PLnk   : TSegmentLink;
    Junk   : Double;
    UpStVolume, SegVolume  : Double;
    WaterFlow, UpStWashout : Double;
    TotUpStWash,PctWashThisLink : Double;
Begin
  ToxInCarrierWashin :=0;

  If SVType=StV then Raise EAQUATOXError.Create('Programming Error, ToxInCarrierWashin must be called by Tox dissolved in Carrier');
  If Not AllStates.LinkedMode then Exit;

  SegVolume :=AllStates.SegVol;

  With AllStates.In_FB_Links do    {With all incoming feedback links}
    Begin
      For i:=0 to Count-1 do   {Step through all incoming feedback links}
        Begin
          PLnk := At(i);

          WaterFlow := PLnk.GetWaterFlow(AllStates.TPresent);
          If WaterFlow > Tiny then
            Begin

              PUpVol := PLnk.FromPStates.GetStatePointer(Volume,StV,WaterCol);  {TVolume for the upstream segment}
              If PLnk.FromPStates.VolumeUpdated <> AllStates.TPresent then
                Begin      {make upper segment's discharge data up-to-date for Washout Call}
                  PUpVol.CalculateLoad(AllStates.TPresent);
                  PUpVol.Derivative(Junk);
                End;

              TotUpStWash := PUpVol.DischargeLoad;
              PctWashThisLink := WaterFlow / TotUpStWash;

              PUpstreamCarrier := PLnk.FromPStates.GetStatePointer(NState,StV,WaterCol);
              UpStVolume := PUpVol.AllStates.SegVol;
              If PUpstreamCarrier.IsAnimal then UpStWashout := TAnimal(PUpstreamCarrier).Drift * UpStVolume
                                           else UpStWashout := PUpstreamCarrier.Washout * UpStVolume; {Washout is virtual method}

              ToxInCarrierWashin := Result + (UpStWashout / SegVolume * PLnk.FromPStates.GetPPB(NState,SVType,Layer)* 1e-6 * PctWashThisLink);
            End; {If WaterFlow > tiny}
        End;
    End;  {with feedback links}
End;  {ToxInCarrierWashin}

(************************************)
(*         Toxic Diffusion          *)
(************************************)

Function TToxics.ToxDiff : Double;
{Toxic within organisms or detritus diffusion between epilimnion and hypolimnion in non-linked mode}
Var OtherSeg: TStates;
    CarrierDiff: Double;
Begin
  ToxDiff := 0;
  If not AllStates.Stratified then exit;

  If AllStates.VSeg=Epilimnion then OtherSeg:=AllStates.Hyposegment
                               else OtherSeg:=AllStates.Episegment;

  CarrierDiff := TStateVariable(GetStatePointer(NState,StV,WaterCol)).TurbDiff;

  If CarrierDiff>0 then ToxDiff := CarrierDiff * OtherSeg.GetPPB(NState,SVType,Layer) * 1e-6
                   else ToxDiff := CarrierDiff * AllStates.GetPPB(NState,SVType,Layer) * 1e-6;
End;



Function TToxics.ToxSegDiff(UpLinks: Boolean):Double;
{Diffusion of Toxicant within SVs to or from up or downstream link, only relevant for linked mode}
Var i: Integer;
    PLnk         : TSegmentLink;
    ToxDiffCalc  : Double;
    CarryDiff    : Double;
    SegVolume    : Double;
    OtherSeg     : TStates;
    ThisSegCarryConc, OtherSegCConc : Double; {g/m3}
    DispCoeff, Area, Length: Double;
    Links        : TCollection;

Begin
  ToxSegDiff  := 0;
  ToxDiffCalc := 0;
  If Not AllStates.LinkedMode then Raise EAQUATOXError.Create('Programming Error, ToxSegDiff only relevant to LinkedMode');

  SegVolume := AllStates.SegVol;

  If UpLinks then Links := AllStates.In_FB_Links
             else Links := AllStates.Out_FB_Links;

  With Links do
    Begin   {documentation here}
      If Count=0 then exit;
      For i:=0 to Count-1 do
        Begin
          PLnk := At(i);

          ThisSegCarryConc := GetState(NState,StV,WaterCol);
          If UpLinks then  OtherSeg := PLnk.FromPStates
                     else  OtherSeg := PLnk.ToPStates;
          OtherSegCConc := OtherSeg.GetState(NState,StV,WaterCol);

          Length    := PLnk.CharLength;
          DispCoeff := PLnk.GetDiffusion(AllStates.TPresent);
          Area      := PLnk.GetXSection(AllStates.TPresent);

          CarryDiff:=0;
          If Length>0 then
             CarryDiff := (((DispCoeff * Area)/Length) * (OtherSegCConc - ThisSegCarryConc)) / SegVolume;
              {mg/L d}        {m2/d}     {m2}   {m}          {g/m3}          {g/m3}               {m3}

          If CarryDiff>0 then ToxDiffCalc := ToxDiffCalc + CarryDiff * OtherSeg.GetPPB(NState,SVType,Layer) * 1e-6
                         else ToxDiffCalc := ToxDiffCalc + CarryDiff * AllStates.GetPPB(NState,SVType,Layer) * 1e-6;
                                {ug/l d}       {ug/l d}      {mg/L d}                 {ug/kg}                {kg/mg}
        End;
    End;

  ToxSegDiff := ToxDiffCalc;
End;


{==============================================}
{    differential equation helper functions    }
{==============================================}

Function TStates.GetPPB(S: AllVariables;  T: T_SVType; L: T_SVLayer): Double;
{calculation of toxicant ppb levels during kinetic derivatives}
{this function general for toxicants and hgtoxicants.  Returns dry weight ppb}

Var PT: TToxics;
    CarrierState,
    ToxState: double;
    PPBResult : double;
Begin
   {ns must be a toxicant state variable or the program will halt}
   If not ((S in [FirstTox..LastTox]) or (T in [FirstToxTyp..LastToxTyp])) then
        Raise EAquatoxError.Create('Programming Error, GetPPB has been passed a non-toxicant.');

   If Diagenesis_Included and (S in [SedmRefrDetr,SedmLabDetr]) then
        Begin
          If (S = SedmRefrDetr)
            then GetPPB    :=  GetPPB(POC_G2,T,SedLayer2) / Detr_OM_2_OC
            else GetPPB    :=  GetPPB(POC_G1,T,SedLayer2) / Detr_OM_2_OC;
                {ug/kg OM}               {ug /kg OC}              {OM/OC}
          Exit;
        End;


   PT:=GetStatepointer(S,T,L);
   CarrierState:=GetState(S,StV,L);
   ToxState := GetState(S,T,L);

   If (S in [FirstTox..LastTox,PoreWater])  {Toxicant Dissolved in Water}
     then PPBResult := PT.State
     else If (CarrierState < Tiny) or (ToxState < Tiny) then PPBResult:=0  {No Toxicant or carrier}
     else If (L > WaterCol) and (S in [Cohesives..NonCohesives2,SedmRefrDetr,SedmLabDetr])
                                     {Toxicant in sed layers in units of ug/m2}
       then PPBResult := ToxState / CarrierState * 1e3
             {ug/kg       ug/m2        g/m2        g/kg}
       else PPBResult := ToxState / CarrierState  * 1e6;  {Toxicant in Carrier in water}
             {ug/kg       ug/L         mg/L        mg/kg}

   If S in [POC_G1..POC_G3]
     then If (CarrierState< tiny)
        then PPBResult :=0
        else with Diagenesis_Params^ do
              PPBResult := ( ToxState / (CarrierState * H2.Val)) * 1e3;
              {ug/kg}        {ug/m2}       {g/m3}        {m}      {g/kg}

   If S in [BuriedRefrDetr..BuriedLabileDetr]
     then If (CarrierState< tiny)
        then PPBResult :=0
        else PPBResult := ( ToxState / CarrierState ) * 1e3;
              {ug/kg}       {ug/m2}      {g/m2}        {g/kg}

   GetPPB := PPBResult;
End;


Function TToxics.CalculateKOM: Double;
        {Used in Detrital Sorption, Desorption below}
Var KOM, KOW  : Double;
    IonCorr   : Double;
    NonDiss   : Double;

Begin
  If not ((NState in [POC_G1..POC_G3,SedmRefrDetr..SuspLabDetr, LaDOMPore,ReDOMPore]) and (SVTYPE in [FirstToxTyp..LastToxTyp])) then
     Raise EAQUATOXError.Create('Programming Error, CalculateKOM must be passed a detrital toxicant');
  KOW := ChemPtrs^[SVType].KOW;

  If ChemPtrs^[SVType].ChemRec.ChemIsBase then IonCorr := 0.01
                                          else IonCorr := 0.1;

  With ChemPtrs^[SVType].ChemRec do
   If IsPFA then
     Begin
       CalculateKOM := PFASedKom;
       exit;
     End;

  Nondiss := Nondissoc; {prevent multiple calculations}

  KOM := -9999;
  With ChemPtrs^[SVType].ChemRec do
    Begin
      If (NState = SedmRefrDetr) and (not CalcKPSed)  then KOM :=    KPSed     * 0.526;   {translate user entered value to proper units}
                                                         {L/kg OM} {L/kg OC} {g OC / g OM}

      If ((NState in [DissRefrDetr, ReDOMPORE]) and (not CalcKOMRefrDOM))  then KOM := KOMRefrDOM;
    End;

  If (KOM < 0) then
    Case NState of
       DissRefrDetr, ReDOMPore:  KOM := (NonDiss * 2.88 * POWER(KOW,0.67) + (1-NonDiss) * IonCorr * 2.88 * POWER(KOW,0.67))* 0.526;
                      {generalized from Freidig et al. 1998,  Modified 3/13/2009}
       DissLabDetr,LaDOMPore:    KOM := (NonDiss *  0.88 * KOW             + (1-NonDiss) * IonCorr *  0.88 * KOW          )* 0.526;
                      {generalized from Koelmans and Heugens 1998}
       SedmLabDetr, SuspLabDetr, POC_G1:
                      KOM := (NonDiss * 23.44 * POWER(KOW,0.61) + (1-NonDiss) * IonCorr * 23.44 * POWER(KOW,0.61))* 0.526;
                      {based on fresh algal detritus parameters in Koelmans, Anzion, & Lijklema 1995}
       Else           KOM := (NonDiss *  1.38 * POWER(KOW,0.82) + (1-NonDiss) * IonCorr *  1.38 * POWER(KOW,0.82));
       {SedRefr/suspRefr generalized from Schwarzenbach et al. 1993, p. 275 and Smejtek and Wang, 1993, for ionized compound}
    End; {case}


  CalculateKOM := KOM;
End;

{------------------------------------------------------------------------------------------------------------------}

Function TToxics.Sorption: Double;
{Calculate Organic Sorption for Sediments/ Detritus}
{Returns units of ug/L, Liters of water column or pore water depending on location of sed-detrital toxicant passed}

Var CarrierState, K1, UptakeLimit, ToxState, Kp, Diff1: Double;
    ToxIsPoreW: Boolean;
    PoreLayer: T_SVLayer;
    ThisPore: TPoreWater;
Begin
  Sorption := 0;

  PoreLayer := Layer;  If PoreLayer=WaterCol then PoreLayer := SedLayer1; {utility var for sediments}

  If not (NState in [POC_G1..POC_G3,ReDOMPore..LastDetr]) then
      Raise EAquatoxError.Create('Programming Error: Sorption was passed a non sediment/detritus');

  {K1}
  With ChemPtrs^[OrgType].ChemRec do
    Case nstate of
      Cohesives:      K1 := CohesivesK1;
      NonCohesives:   K1 := NonCohK1;
      NonCohesives2:  K1 := NonCoh2K1;
      else {organics} K1 := K1Detritus;    {calibrated to 1.39}
    End; {Case}
  If K1=0 then exit;

  {ToxState}
  ToxState := 0;
  If (Layer = WaterCol) or (nstate in [POC_G1..POC_G3])
     then ToxState := GetState(AssocToxSV(SVType),StV,WaterCol);
          {ug/L wc}

  { Sed Detritus is labeled as being in the "WaterCol" though it really resides in SedLayer1
    This is to provide compatibility when the model runs without the Sediment Sub Model }
  ToxIsPoreW := False;
  If AllStates.SedModelIncluded then
    Begin
      ToxIsPoreW := (Layer > WaterCol) or (nstate in [SedmRefrDetr..SedmLabDetr]);
      If ToxIsporeW then ToxState := GetState(PoreWater,SVType,PoreLayer);
                         {ug/L pw}
    End;
  If ToxState <= Tiny then exit;

  {Michaelis}
  With ChemPtrs^[OrgType].ChemRec do
    Case nstate of
      Cohesives:      Kp := CohesivesKp;
      NonCohesives:   Kp := NonCohKp;
      NonCohesives2:  Kp := NonCoh2Kp;
      else {organics} Kp := CalculateKOM;
    End; {Case}
  If Kp=0 then exit;

  With AllStates do
  UptakeLimit := (Kp*ToxState - GetPPB(NState,SVType,Layer))/(Kp*ToxState);
  if UptakeLimit < 0 then UptakeLimit := 0;

  {Diff}
  If ToxIsPoreW then Diff1 := AllStates.PoreDiff[SVType,PoreLayer]
                else Diff1 := AllStates.Diff[SVType];

  {NonDissoc is a separate function (TToxics.NonDissoc) found above}

  {CarrierState}
  CarrierState := GetState(NState,StV,Layer);
  {mg/L or g/m2 (buried)}
  If ToxIsPoreW and (NState>LaDOMPore)
    Then  {Carrerstate must be converted to mg/L(porewater)}
      Begin
        ThisPore := GetStatePointer(PoreWater,StV,PoreLayer);
        If ThisPore.VolumeinM3 < Tiny then Exit;
        With AllStates do
          If (nstate in [Cohesives..NonCohesives2]) or (Layer>SedLayer1)
            then CarrierState := CarrierState * SedLayerArea / ThisPore.VolumeinM3
                  {mg/L pw}        {g/m2}          {m2}                     {m3 pw}
            else CarrierState := CarrierState * SegVol / ThisPore.VolumeinM3;
                  {mg/L pw}       {mg/L wc}       {m3 wc}                  {m3 pw}
      End;

  With AllStates do
   If not (NState in [POC_G1..POC_G3])
    then Sorption :=  K1   * ToxState * UptakeLimit * Diff1 * CarrierState * 1e-6
          {ug/L-d}  {L/kgdry-d} {ug/L}  {unitless} {unitless}   {mg/L}      {kg/mg}

    else {Diagenesis Units}
        Sorption :=  K1         * ToxState * UptakeLimit * Diff1 * CarrierState  * 1e-3 * Detr_OM_2_OC ;
        {ug/m2-d} {L/kgdry OM-d} {ug tox/L}   {unitless} {unitless} {g POC/m2}    {kg/g}    {OM/POC}

End;

{------------------------------------------------------------------------------------------------------------------}

Function TToxics.Desorption: Double;

{Calculate Organic Desorption for Sediments/ Detritus}
  var Desorp: Double;
      K2, KOM: Double;
Begin
  If not (NState in [ReDOMPore..LastDetr]) then
      Raise EAquatoxError.Create('Programming Error: Desorption was passed a non sediment/detritus');

  Desorption := 0;    
  If State<=0 then exit;

  With ChemPtrs^[OrgType].ChemRec do
  Case nstate of
    Cohesives:      K2 := CohesivesK2;
    NonCohesives:   K2 := NonCohK2;
    NonCohesives2:  K2 := NonCoh2K2;
    else {organics}
      Begin
        KOM := CalculateKOM;
        If KOM=0 then K2 := 0
                 else K2 :=  K1Detritus /KOM; {(1/(0.72 * KPSed))}        // 9/25/2011 was hard-wired to 1.39
                     { Karickoff's obs. }
      End; {organics}
  End; {Case}

  Desorp := K2 * State;
  {ug/L-d} {1/d}  {ug/L}  {water col units}
 {ug/m2-d} {1/d}  {ug/m2} {buried units}

  If Desorp < 0 then Desorp := 0;
  Desorption := Desorp;
End;

{-------------------------------------------------------------------------}
Function TAlgae_ZooTox.PlantUptake: Double;
{ Integrated MacroUptake into AlgalUptake for ease of coding / code reading  9/16/98 jsc }

Var PFAK2,K2,Local_K1, UptakeLimit, ToxState,DissocFactor: Double;
    AlgalPtr: TPlant;
    ChemOption: UptakeCalcMethodType;

    Function MacroUptake: Double;
    Var K1,
        DissocFactor : Double;

    Begin
      If NonDissoc < 0.2
         then DissocFactor := 0.2
         else DissocFactor := NonDissoc;

       With ChemPtrs^[SVType] do With ChemRec do
         If IsPFA
           then Begin
                  PFAK2 := AlgalPtr.Plant_Tox[SVType].K2;
                  K1 := PFAMacroBCF * PFAK2
               {L/kg-d}    {L/kg}    {1/d}
                End
           else With ChemPtrs^[SVType] do
                K1 := 1 / (0.0020 + (500/ (KOW * DissocFactor)));
                {K1 function is mirrored in CHEMTOX.PAS, any change here needs to be made there}

      K2 := AlgalPtr.Plant_Tox[SVType].k2;
      If K2>96 then K1 := K1 * (96/k2); {scaling factor 10-02-03}

      With AllStates do
        MacroUptake := K1    *   Diff[SVType]   * ToxState *  AlgalPtr.State * 1e-6;
          {ug/L-d}  {L/kg-d} {unitless}            {ug/L}           {mg/L}     {kg/mg}
    End;

Begin
  ChemOption := ChemPtrs^[SVType].Plant_Method;

  PlantUptake:=0;
  AlgalPtr :=AllStates.GetStatePointer(Carrier,StV,WaterCol);
  ToxState := GetState(AssocToxSV(SVType),StV,WaterCol);

  If (AlgalPtr=nil) or (ToxState <= Tiny) then exit;

  {---------------------------------------------------------------------}
  If ChemOption <> Default_Meth then
    Begin
      With AlgalPtr.Plant_Tox[SVType] do

       If ChemOption = CalcK1
        then Local_K1 := K2 * Entered_BCF
        else Local_K1 := K1;

        With AllStates do
          PlantUptake := Local_K1 * Diff[SVType] * ToxState * AlgalPtr.State * 1e-6;
            {ug/L-d}    {L/kg-d}       {ug/L}      {mg/L}       {kg/mg}
      Exit;
    End;
  {---------------------------------------------------------------------}

  If NState in [FirstMacro..LastMacro]
    then PlantUptake:=MacroUptake
    else
      Begin  {Non Macrophyte Plants}
        If NonDissoc < 0.2
           then DissocFactor := 0.2
           else DissocFactor := NonDissoc;

        With ChemPtrs^[SVType] do With ChemRec do
          If IsPFA
           then Begin
                  PFAK2 := AlgalPtr.Plant_Tox[SVType].K2;
                  Local_K1 := PFAAlgBCF * PFAK2
               {L/kg-d}   {L/kg}    {1/d}
                End
           else Local_K1 := 1/(1.8e-6 + 1/(ChemPtrs^[SVType].KOW * DissocFactor));
                        {fit to Sijm et al.1998 data for PCBs}

        With AllStates do
          UptakeLimit := (AlgalPtr.BCF(0,SVType)*ToxState - GetPPB(NState,SVType,Layer))/(AlgalPtr.BCF(0,SVType)*ToxState);
        If UptakeLimit < 0 then UptakeLimit := 0;

        K2 := AlgalPtr.Plant_Tox[SVType].k2;
        If K2>96 then Local_K1 := Local_K1 * (96/k2); {scaling factor 10-02-03}

        With AllStates do
          PlantUptake := Local_K1 * UptakeLimit * Diff[SVType] * ToxState * AlgalPtr.State * 1e-6;
            {ug/L-d}      {L/kg-d}   {unitless}                  {ug/L}        {mg/L}        {kg/mg}
      End; { algae }
End;



Procedure TToxics.InitialLipid;
var IL : double;
    CP : TAnimal;
Begin
  with ChemPtrs^[SVType].ChemRec do
    Begin
      CP:=TAnimal(GetStatePointer(Carrier,StV,WaterCol));
      IL := CP.PAnimalData^.FishFracLipid;
    End; {with}
  CP.CalcLipid:=IL;
End;

{--------------------------------------------------------------------------}

Function TAlgae_ZooTox.SumDietUptake: Double;

{*************************************}
{ Calculate dietary uptake of Org Tox }
{ from all prey.  Tox Uptake that is  }
{ defecated is excluded from sum.     }
{ modified JSC, 7/21/98               }
{*************************************}

Var Loop: StateVariables;
    SumDiet, KD, ToxPrey, EgestCoeff, GutEffRed, GutEffTox: Double;
    CP : TAnimal;
Begin
  CP := GetStatePointer(Carrier,StV,WaterCol);
  SumDiet:=0;
  For Loop:=FirstDetr to LastAnimal do
   If Loop in [FirstDetr..LastDetr, FirstBiota..LastBiota] then
    Begin
      KD := CP.IngestSpecies(Loop,nil,EgestCoeff,GutEffRed);
      ToxPrey :=0;
      If KD>0 then
        With AllStates do
          Begin
            GutEffTox := CP.GutEffOrgTox(SVType) * GutEffRed;
            If GetState(Loop,SVType,WaterCol) > -1
              then ToxPrey :=GetPPB(Loop,SVType,WaterCol) * KD  * 1e-6 * GutEffTox
                   {ug/L}            {ug/kg}              {mg/L} {kg/mg}
              else If Diagenesis_included
                then Begin
                       If (loop = SedmRefrDetr)
                         then ToxPrey :=  GetPPB(POC_G2,SVType,SedLayer2) * KD  * 1e-6 * GutEffTox / Detr_OM_2_OC ;
                              {ug/L}               {ug /kg OC}          {mg OM/L}{kg/mg} {unitless}    {OM/OC}
                       If (loop = SedmLabDetr)
                         then ToxPrey :=  GetPPB(POC_G1,SVType,SedLayer2) * KD  * 1e-6 * GutEffTox / Detr_OM_2_OC ;
                              {ug/L}               {ug /kg OC}          {mg OM/L}{kg/mg} {unitless}    {OM/OC}
                     End
                else ToxPrey:=0;

            If ToxPrey < 0 then ToxPrey := 0;
          End;
      SumDiet:= SumDiet + ToxPrey;
    End;
  SumDietUptake:=SumDiet;
End;



Function TToxics.AnimalDeriv: Double;
{Calculation of Derivs for Inverts and Fish}
Var LgF, CP: TAnimal;
    AZT: TAlgae_ZooTox;
    pp,Lo,Gill,Diet,Dep,Predt,Mort,BioT_out,BioT_in,Fi,Entr,
    Gam,TD,DiffUp,DiffDown,DrifO,DrifI,PSGF,Recr,EmergI,Migr  :Double;
    AD: Double;
    ATR: String;
    BigFishLoop: AllVariables;

    {----------------------------------------------------------------
     Function AnimalGrowthRate: Double;
     Begin
       With CP do
          AnimalGrowthRate:= (Consumption - Respiration - AnimExcretion - GameteLoss);
     End;
    {----------------------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Loading',Lo);

          If (carrier in [FirstInvert..LastInvert]) and
             (TAnimal(CP).PAnimalData^.Animal_Type<>'Benthic Invert.') and
             (TAnimal(CP).PAnimalData^.Animal_Type<>'Benthic Insect') then
            If Not AllStates.LinkedMode
              then SaveRate('TurbDiff',TD)
              else {If Not AllStates.CascadeRunning then}
                Begin
                  SaveRate('DiffUp',DiffUp);
                  SaveRate('DiffDown',DiffDown);
                End;

          SaveRate('Biotr IN',BioT_in);
          SaveRate('Biotr OUT',BioT_out);

          CP:= TAnimal(GetStatePointer(Carrier,StV,WaterCol));
          ATR:=CP.PAnimalData^.ToxicityRecord;
          If (ATR='Stonefly') or (ATR='Chironomid') then
             SaveRate('EmergInsct',EmergI);

          If CanMigrate then SaveRate('Migration',Migr);

            Begin
              SaveRate('GillUptake',Gill);
              SaveRate('DietUptk',Diet);
              SaveRate('Depuration',Dep);
{             SaveRate('Defecation',Def);  Defecation is implicit in DietUptk}
              SaveRate('Predation',Predt);
              SaveRate('Mortality',Mort);
              SaveRate('GameteLoss',Gam);

              SaveRate('FishingLoss',Fi);

              If nstate in [FirstInvert..LastInvert] then
                Begin
                  SaveRate('Drift',DrifO);
                  SaveRate('DriftIn',DrifI);
                  If AllStates.EstuarySegment then
                     SaveRate('Entrainment',Entr);
                End;

              If CP.IsFish then
                Begin
                  If (nstate < Fish1) then {size class fish}
                    Begin
                      SaveRate('PromSGFish',PSGF);
                      SaveRate('Recruit',Recr);
                    End;
                  If NState in [Fish1..Fish15] then
                    Begin
                      SaveRate('Recruit',Recr);
                    End;
                End;
            End;
        End;
    End;
    {----------------------------------------------------------------}

Var LargeCompartment,SmallCompartment: AllVariables;
    TopPore: TPoreWater;
    EpiSalt,LoadInKg, OOSDriftInKg, EmergIInKg, FishInKg : Double;
    SaltGoodEpi: Boolean;
    OtherSeg: TStates;

Begin {AnimalDeriv}

  Lo:=0; Gill:=0; Diet:=0; Dep:=0; Predt:=0; Mort:=0; Gam:=0; BioT_In:=0; DiffUp:=0; DiffDown:=0;
  DrifO:=0; DrifI:=0; PSGF:=0; EmergI:=0; Recr:=0; Migr:=0; BioT_Out:=0; TD:=0; Entr:=0; Fi:=0;

  CP:= TAnimal(GetStatePointer(Carrier,StV,WaterCol));
  If Eutrophication or AllStates.SetupRec^.BCFUptake then
    Begin
      AnimalDeriv:=0;
      RecrSave := 0;
    End
  Else
   Begin
     Lo:=Loading;
     pp := AllStates.GetPPB(NState,SVType,Layer);

     {Pelagic invertebrates are subject to entrainment}
     If AllStates.EstuarySegment then
       If CP.IsInvertebrate and
         (CP.PAnimalData^.Animal_Type<>'Benthic Invert.') and
         (CP.PAnimalData^.Animal_Type<>'Benthic Insect')
         then With AllStates do
            Begin
              If VSeg=Epilimnion  {5-30-08, no entrainment for pelagic inverts. if salt climate is not desirable}
                then EpiSalt := GetState(Salinity,StV,WaterCol)
                else EpiSalt := EpiSegment.GetState(Salinity,StV,WaterCol);

              SaltGoodEpi := (EpiSalt > CP.PAnimalData.SalMin_Ing) and
                             (EpiSalt < CP.PAnimalData.SalMax_Ing);
              If SaltGoodEpi then Entr := EstuaryEntrainment;
              If Entr<0 then Entr := Entr * pp * 1e-6;
              If Entr>0 then Entr := Entr * HypoSegment.GetPPB(NState,SVType,Layer) * 1e-6;
            End;  {Pelagic Invertebrate in Estuary subject to Entrainment}


     AZT := GetStatePointer(NState,SVType,Layer);

     Migr := CP.StratMigration;  {mg/L}
     If Migr <> 0 then With AllStates do
       Begin
          If VSeg=Epilimnion then OtherSeg:= Hyposegment
                             else OtherSeg:= Episegment;

          If Migr>0 then Migr := Migr * OtherSeg.GetPPB(NState,SVType,Layer) * 1e-6
                    else Migr := Migr * pp * 1e-6;
       End;

     EmergI := CP.EmergeInsect * pp * 1e-6;

     With AllStates do with ToxLossArray[OrgType] do
       Begin {save for tox loss output & categorization}
         EmergIInKg := EmergI  * SegVol * 1000.0 * 1e-9;
            {kg}       {ug/L}          {m3}         {L/m3}  {kg/ug}

         TotalToxLoss[Derivstep] := TotalToxLoss[Derivstep] + EmergIInKg;
         EmergeIns[Derivstep] := EmergeIns[Derivstep]  + EmergIInKg;
       End;

     DrifO := CP.Drift * pp * 1e-6;  {invertebrates only}

     With AllStates do
         WashoutStep[DerivStep] := DrifO * SegVol; {save for cascade output}

       With AllStates do with ToxLossArray[SVType] do With Location.Morph do
         Begin {save for tox loss output & categorization}
           If Entr<0 then OOSDriftInKg := (-Entr+DrifO) {* OOSDischFrac} * SegVol * 1000.0 * 1e-9
                     else OOSDriftInKg :=      DrifO    {* OOSDischFrac} * SegVol * 1000.0 * 1e-9;
                            {kg}             {ug/L}         {frac}         {m3}    {L/m3}  {kg/ug}
           TotalToxLoss[Derivstep] := TotalToxLoss[Derivstep] + OOSDriftInKg;
           TotalWashout[Derivstep] := TotalWashout[Derivstep] + OOSDriftInKg;
           WashoutAnim[Derivstep]  := WashoutAnim[Derivstep]  + OOSDriftInKg;
         End;

     DrifI := ToxInCarrierWashin;

     With AllStates do with ToxLoadArray[SVType] do
         Begin {save for tox loss output & categorization}
           If Entr>0 then LoadInKg :=  (Lo+Entr+DrifI) * SegVol * 1000.0 * 1e-9
                     else LoadInKg :=  (Lo+DrifI)      * SegVol * 1000.0 * 1e-9;
                           {kg}       {ug/L}             {m3}     {L/m3}  {kg/ug}

           TotOOSLoad[Derivstep]   := TotOOSLoad[Derivstep] + LoadInKg;
           ToxLoadBiota[Derivstep] := ToxLoadBiota[Derivstep] + LoadInKg;
         End;

     BioT_Out := BioTransformation;
     BioT_In  := BioTrans_To_This_Org;

     Gill := CP.GillUptake(SVType,WaterCol);
     TopPore := GetStatePointer(PoreWater,SVType,SedLayer1);
     If (TopPore<>nil) then
       If (ToPPore.VolumeInM3>tiny) then
         Gill := Gill + CP.GillUptake(SVType,SedLayer1);

     Diet := AZT.SumDietUptake;
     Dep  := Depuration;

     Predt := CP.Predation * pp * 1e-6;
     Mort  := CP.Mortality * pp * 1e-6;

     Fi    := CP.PAnimalData^.Fishing_Frac * CP.State * pp * 1e-6;
     With AllStates do with ToxLossArray[SVType] do With Location.Morph do
         Begin {save for tox loss output & categorization}
           FishInKg := Fi * SegVol * 1000.0 * 1e-9;
              {kg}    {ug/L}   {m3}  {L/m3}  {kg/ug}
           TotalToxLoss[Derivstep] := TotalToxLoss[Derivstep] + FishInKg;
           FishingLoss[Derivstep]  := FishingLoss[Derivstep]  + FishInKg;
         End;

     If CP.PSameSpecies^<>nullstatevar then With AllStates do
        Begin
          If Not CP.IsSmallFish then
             begin
               LargeCompartment := CP.NState;
               SmallCompartment := CP.PSameSpecies^;
             end
           else
             begin
               LargeCompartment := CP.PSameSpecies^;
               SmallCompartment := CP.NState;
             end;

          Recr := CP.Recruit  * GetPPB(LargeCompartment,SVType,Layer) * 1e-6;
          PSGF := CP.PromSmFish * GetPPB(SmallCompartment,SVType,Layer) * 1e-6;
        End;

     {Calculate Recruitment / Promotion for Multi-Age Fish}
     If (NState=Fish1) then {Calculate Tox movement through Recruitment to YOY of multi-age fish}
        Begin
          Recr := 0;
          For BigFishLoop := Fish2 to Fish15 do
            If GetStatePointer(BigFishLoop,StV,WaterCol) <> nil then With AllStates do
              Begin
                LgF:=GetStatePointer(BigFishLoop,StV,WaterCol);
                LGF.GameteLoss;   {call LgGF^.GameteLoss to get Recruit}
                Recr := Recr - LGF.Recruit * GetPPB(BigFishLoop,SVType,WaterCol) * 1e-6;  {sum recruitment from larger fish}
              End;
        End; {Fish1}
     If NState in [Fish2..Fish15] then Recr := CP.Recruit * pp * 1e-6;

     Gam  := CP.GameteLoss * pp * 1e-6; {Must Be Called After Recr Calculation}

     AnimalDeriv := Loading + Gill + Diet - Dep - DrifO + DrifI - BioT_Out + BioT_In + Migr
                    - (Predt + Mort + Gam + Fi) {+ Recr} + PSGF - EmergI + Entr;

     If (AllStates.DerivStep=5) then RecrSave := Recr;  {derivstep 5 is time X+h}

 {Pelagic invertebrates are subject to currents }
  If (carrier in [FirstInvert..LastInvert]) and
     (TAnimal(CP).PAnimalData^.Animal_Type<>'Benthic Invert.') and
     (TAnimal(CP).PAnimalData^.Animal_Type<>'Benthic Insect')
             then Begin
                    If Not AllStates.LinkedMode then TD := ToxDiff
                                      else If Not AllStates.CascadeRunning then
                                           Begin
                                             DiffUp := ToxSegDiff(True);
                                             DiffDown := ToxSegDiff(False);
                                           End;
                    AnimalDeriv := Result + TD + DiffUp + DiffDown;
                  End;


   End; {Not Eutrophication}

  AD := Result;
  AnimalDeriv := AD;

  WriteRates;
End;


{----------------------------------------}
{  NORMDIFF                              }
{                                        }
{  compute normalized rate differences   }
{  for uptake rates given conc. gradient }
{  for Org Tox, HgII and MeHg            }
{                                        }
{  also, normalize preference for the    }
{  amount of food available in a given   }
{  time step                             }
{----------------------------------------}
Procedure TStates.NormDiff(Step: Double);
var
  ns:        AllVariables;
{  AlgToxPtr: TAlgae_ZooTox;
  OrgPtr:    TOrganism;
  PT:        TToxics; }
  CP:        TAnimal;
  i:         Integer;
  PP:        TPreference;
{  PL:        TPlant; }
  Egest, Pref, {SumUptake, TDiff, }
{  H2oState, PoreState,} PreyState, SumPref:   Double;
  ToxLoop:   T_SVType;
  LayLoop:   T_SVLayer;
  SedModelRunning : Boolean;
{  PWVol : Double; }
{  StartLoop: AllVariables; }

Begin
  SedModelRunning := SedModelIncluded;

{  SumUptake := 0.0; }
  {Org Tox}
  If Step>-1 then {don't calculate Diff when exporting trophic interactions}
   For ToxLoop := FirsTOrgTxTyp to LasTOrgTxTyp do
{    Begin }
      Diff[ToxLoop] := 1;

(*   If FALSE {not TURN_OFF_TH2O_DB} then  {COMPETITIVE UPTAKE TURNED OFF}
       IF GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol)<>nil then
        BEGIN
          H2oState := GetState(AssocToxSV(ToxLoop),StV,WaterCol);

          If SedModelRunning then StartLoop := DissRefrDetr  {SedmDetr is used in Sediment's normdiff (below)}
                             else StartLoop := SedmRefrDetr;
          For ns := StartLoop to LastDetr do
            Begin
              PT:=GetStatePointer(ns,ToxLoop,WaterCol);
              If PT<>nil then
                   SumUptake := SumUptake + PT.Sorption;
            End; {detr}

          For ns := Cohesives to NonCohesives2 do
            Begin
              PT:=GetStatePointer(ns,ToxLoop,WaterCol);
              If PT<>nil then
                   SumUptake := SumUptake + PT.Sorption;
            End; {inorg}

          For ns := FirstPlant to LastPlant do
            Begin
              AlgToxPtr:=GetStatePointer(ns,ToxLoop,WaterCol);
              If AlgToxPtr=nil then OrgPtr:=nil
                               else OrgPtr:=GetStatePointer(AlgToxPtr.carrier,StV,WaterCol);
              If (AlgToxPtr <> nil) or (OrgPtr <> nil)
                Then SumUptake := SumUptake + AlgToxPtr.PlantUptake;
            End;  {all plants}

          For ns := FirstAnimal to LastAnimal do
            Begin
              PT:=GetStatePointer(ns,ToxLoop,WaterCol);
              If (PT=nil) then OrgPtr:=nil
                          else OrgPtr:=GetStatePointer(PT.carrier,StV,WaterCol);

              If (PT<>nil) and (OrgPtr<>nil)
                then
                  begin
                     CP:= TAnimal(GetStatePointer(PT.Carrier,StV,WaterCol));
                     SumUptake := SumUptake + CP.GillUptake(ToxLoop,WaterCol);
                  end; {not nil}
            End; {tox in animals}

            TDiff := SumUptake * 1.0 {day};
            If (TDiff > H2oState) and (TDiff>Tiny)
              then begin
                     Diff[ToxLoop] := H2oState/TDiff;
                     if Diff[ToxLoop] > 1.0 then Diff[ToxLoop] := 1.0;
                   end
              else Diff[ToxLoop] := 1;
        END;
    End; {Organic Tox. in water column Loop}  *)

  For LayLoop := SedLayer1 to T_SVLayer(SedLayers) do
{    Begin
      SumUptake := 0.0; }
      {Org Tox in Pore Water}

      If SedModelRunning then
       For ToxLoop := FirstOrgTxTyp to LasTOrgTxTyp do

{        Begin }

          PoreDiff[ToxLoop,LayLoop] := 1;

(*          IF GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol)<>nil then
            Begin
              PoreState := GetState(PoreWater,ToxLoop,LayLoop);
              For ns := SedmRefrDetr to SedmLabDetr do
                Begin
                  If LayLoop=SedLayer1 then PT:=GetStatePointer(ns,ToxLoop,WaterCol)
                                       else PT:=GetStatePointer(ns,ToxLoop,LayLoop);
                  IF PT<>nil then
                       SumUptake := SumUptake + PT.Sorption;
                        {ug/L pw}
                End; {detr}

              For ns := Cohesives to NonCohesives2 do
                Begin
                  PT:=GetStatePointer(ns,ToxLoop,LayLoop);
                  IF PT<>nil then
                       SumUptake := SumUptake + PT.Sorption;
                        {ug/L pw}
                End; {inorg}

              If LayLoop=SedLayer1 then
                Begin
                  PWVol := TPoreWater(GetStatePointer(PoreWater,StV,SedLayer1)).VolumeInM3;
                  If PWVol > Tiny then
                    For ns := FirstAnimal to LastAnimal do
                      Begin
                        PT:=GetStatePointer(ns,ToxLoop,WaterCol);
                        If (PT=nil) then OrgPtr:=nil
                                    else OrgPtr:=GetStatePointer(PT.carrier,StV,WaterCol);

                        if (PT<>nil) and (OrgPtr<>nil)
                          then
                            begin
                               CP:= TAnimal(GetStatePointer(PT.Carrier,StV,WaterCol));
                               SumUptake := SumUptake + CP.GillUptake(ToxLoop,SedLayer1) * SegVol / PWVol;
                                {ug/L pw}    {ug/L pw}       {ug/L wc}                          {m3}            {m3}

                            end; {not nil}
                      End; {tox in animals}
                End;

                TDiff := SumUptake * 1.0 {day};
                If (TDiff > PoreState) and (TDiff>Tiny)
                  then begin
                         PoreDiff[ToxLoop,LayLoop] := PoreState/TDiff;
                         if PoreDiff[ToxLoop,LayLoop] > 1.0 then PoreDiff[ToxLoop,LayLoop] := 1.0;
                       end
                  else PoreDiff[ToxLoop,LayLoop] := 1;
            End;
        End; {Organic Tox. Loop in Sediments}
    End;                                   *)

{normalize preference for the amount of food avail. in a given time step}

 For ns := FirstAnimal to LastAnimal do
  Begin
    CP:= TAnimal(GetStatePointer(ns,StV,WaterCol));
    If CP<> nil then
      Begin
        CP.ChangeData;  {reload original preferences from entry screen}


    (*        If CP.NState in [FirstInvert..LastInvert] then
             { Preferences are set to zero if:
               Predt is Benthic Invert. and prey is Phytoplankton
               Predt is Pelagic Invert. and prey is Periphyton }
             { 2-12-2002, Moved before normalization so preferences total to 1.0 }
             { 8-04-2006, DISABLED THIS CODE FOR RELEASE 3 }

              Begin
                If (CP.PAnimalData^.Animal_Type='Benthic Invert.') or
                   (CP.PAnimalData^.Animal_Type='Benthic Insect')
                  Then For i := 0 to CP.MyPrey.Count - 1 do
                    Begin
                      PP:=TPreference(CP.MyPrey.At(i));
                      If PP.NState in [FirstPlant..LastPlant] then
                        Begin
                          PL:=GetStatePointer(PP.NState,StV,WaterCol);
                          If PL <> nil then
                            If PL^.IsPhytoplankton
                              then PP.Preference := 0;
                        End;
                    End;

                If (CP.PAnimalData^.Animal_Type='Pelagic Invert.')
                  Then For i := 0 to CP.MyPrey.Count - 1 do
                    Begin
                      PP:=TPreference(CP.MyPrey.At(i));
                      If PP.NState in [FirstPlant..LastPlant] then
                        Begin
                          PL:=GetStatePointer(PP.NState,StV,WaterCol);
                          If PL <> nil then
                            If PL^.IsPeriphyton
                              then PP.Preference := 0;
                        End;
                    End;
              End;  *)

        {Sum up preference values for all food sources that are present above
         the minimum biomass level for feeding during a particular time step.}
        SumPref := 0;
        For i := 0 to CP.MyPrey.count - 1 do
          Begin
            PP:=TPreference(CP.MyPrey.At(i));
            If (not (PP.nstate in [SedmRefrDetr, SedmLabDetr]))
              and (GetStatePointer(PP.nstate,StV,WaterCol)=nil) then PP.Preference := 0;

           If (PP.nstate in [SedmRefrDetr, SedmLabDetr]) and (GetStatePointer(POC_G1,StV,SedLayer2) <> nil) {diagenesis model included}
              then Begin If Step<>-1 then PreyState := Diagenesis_Detr(PP.nstate) else PreyState:= 0; End
              else PreyState := GetState(PP.nstate,StV,WaterCol);     {mg/L wc}

(*            If (PP.nstate in [SedmRefrDetr]) then    REMOVED THIS (undocumented?) LOGIC  JULY 6, 2007
              If PreyState > 50 then
                PP.Preference := 0.01 * PP.Preference; {anoxic seds & detritivore will feed only at surface} *)

            If (PreyState <= CP.BMin_in_mg_L) and (Step<>-1) then
              PP.Preference := 0;

            SumPref := SumPref + PP.Preference;
          End;

        {normalize preferences}
        For i := 0 to CP.MyPrey.count - 1 do
          Begin
            PP:=TPreference(CP.MyPrey.At(i));
            If (PP.Preference > 0) and (SumPref > 0) then
              PP.Preference := PP.Preference/SumPref;
          End;


      End; {if TAnimal not nil}
  End; {loop through animals}

  {**GULL MODEL** Normalize preferences for bird model}
  BirdPrey.FreeAll;
  For ns := Cohesives to LastBiota do  {RELOAD ORIGINAL PREFERENCES}
   If GetStatePointer(ns,StV,WaterCol)<>nil then
     begin
       If ns in [DissRefrDetr,DissLabDetr,BuriedRefrDetr..BuriedLabileDetr] 
           then Pref :=0
           else Pref := GullPref[ns].Pref;

       If (Pref>0) then
          begin
            Egest := 0;
            PP:= TPreference.init(Pref,Egest,ns);
            BirdPrey.Insert(PP);
          end;
     end;

    {**GULL MODEL** Sum up preference values for all food sources that are present above
     the minimum biomass level for feeding during a particular time step.}
    SumPref := 0;
    For i := 0 to BirdPrey.count - 1 do
      Begin
        PP:=TPreference(BirdPrey.At(i));
        SumPref := SumPref + PP.Preference;
      End;

    {**GULL MODEL** normalize preferences}
    For i := 0 to BirdPrey.count - 1 do
      Begin
        PP:=TPreference(BirdPrey.At(i));
        If (PP.Preference > 0) and (SumPref > 0) then
          PP.Preference := PP.Preference/SumPref;
      End;

End;



    (************************************)
    (*                                  *)
    (*     DIFFERENTIAL EQUATIONS       *)
    (*                                  *)
    (************************************)


Procedure TToxics.Derivative;
{Derivative for Toxicant Dissolved in Water}
Var ThisPPB, Dec                                  : Double;
    Lo, Hyd, Pho, Mic, Vl ,ToxDis, Inflow, TDF    : Double;
    FracAerobic, Mic_in_Aer, Mic_in_Anaer, DiffUp : Double;
    DetrSorption, DetrDesorption, PlantSorp       : Double;
    InorgSorpt, InorgDesorpt, Entr                : Double;
    GillSorption, Dep, Decomp, DiffDown, DiffSed  : Double;
    PoreWUp, PoreWDown, PWToxLevel, FracInWater   : Double;
    FracPoreWUp, OOSDriftInKg, LoadInKg           : Double;
    ToTPoreWater                                  : TPoreWater;
    ToTPoreWaterTox                               : TPoreWaterTox;
    PT                                            : TToxics;
    PD                                            : TDetritus;
    TPOC                                          : TPOC_Sediment;
    TPOCT                                         : TPOCTox;
    NsLoop, StartLoop, DecompLoop                 : AllVariables;
    AlgalToxPtr                                   : TAlgae_ZooTox;
    ToxType                                       : T_SVType;
    SedModelRunning                               : Boolean;

    Procedure WriteRates; {for toxicant dissolved in water}
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Load',Lo);
          SaveRate('Hydrolysis',Hyd);
          SaveRate('Photolysis',Pho);
          SaveRate('MicroMet',Mic);
          SaveRate('AerMM In',Mic_in_Aer);
          SaveRate('AnaerMM In',Mic_in_Anaer);
          SaveRate('Volatil',Vl);
          SaveRate('ToxDisch',ToxDis);
          SaveRate('Inflow',Inflow);

          If Not AllStates.LinkedMode
            then SaveRate('TurbDiff',TDF)
            else {If Not AllStates.CascadeRunning then }
              Begin
                SaveRate('DiffUp',DiffUp);
                SaveRate('DiffDown',DiffDown);
              End;

          If AllStates.SedModelIncluded then
            Begin
              SaveRate('DiffSed',DiffSed);
              SaveRate('InorgSorpt',InorgSorpt);
              SaveRate('InorgDesorpt',InorgDesorpt);
              SaveRate('PW_Capture',PoreWDown);
              SaveRate('PW_Expuls',PoreWUp);
            End;

          SaveRate('GillSorption',GillSorption);
          SaveRate('Depuration',Dep);
          SaveRate('DetrSorpt',DetrSorption);
          SaveRate('Decomp',Decomp);
          SaveRate('DetrDesorpt',DetrDesorption);
          SaveRate('PlantSorp',PlantSorp);
          If AllStates.EstuarySegment then
             SaveRate('Entrainment',Entr);
        End;
    End;
Var UnitFix, DissSorpInKG: Double;
Begin  {Derivative for Toxicant Dissolved in Water}
  SedModelRunning := GetStatePointer(PoreWater,StV,SedLayer1)<>nil;

  ToxType := AssocToxTyp(NState);
  DiffSed:=0; PoreWUp:=0; Dep:=0; Entr:=0;
  Lo:=0; Hyd:=0; Pho:=0; Mic:=0; Vl:=0; ToxDis:=0; TDF:=0; DiffDown:=0;
  Decomp:=0; DetrSorption:=0; DetrDesorption:=0; GillSorption:=0; Inflow:= 0;
  PlantSorp:=0; Mic_in_Aer:=0; Mic_in_Anaer :=0; DiffUp:=0; PoreWDown:=0;

(*  db := Loading - (1.25 {1.23} / 365.25) * state - ToxDis;  {Validity Tests}
    WriteRates;
    exit; *)

  If Eutrophication or AllStates.SetupRec^.KeepDissToxConst then
      dB := 0.0
  else
    With AllStates do begin
      CalculateLoad(TPresent);
      Lo:=Loading;
      If AllStates.EstuarySegment then Entr := EstuaryEntrainment;

      With AllStates do with ToxLoadArray[AssocToxTyp(nstate)] do
         Begin {save for tox loss output & categorization}
           If Entr>0 then LoadInKg :=  (Lo+Entr) * SegVol * 1000.0 * 1e-9
                     else LoadInKg :=    Lo      * SegVol * 1000.0 * 1e-9;
                          {kg}       {ug/L}         {m3}     {L/m3} {kg/ug}
           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           ToxLoadH2O[Derivstep] := ToxLoadH2O[Derivstep] + LoadInKg;
         End;

      Hyd:=Hydrolysis;
      Pho:=Photolysis;
      Mic:=MicrobialMetabolism(FracAerobic);
      Mic_in_Aer   := Microbial_BioTrans_To_This_SV(True);
      Mic_in_Anaer := Microbial_BioTrans_To_This_SV(False);
      Vl :=Volatilization;
      ToxDis:= WashOut;

        With AllStates do with ToxLossArray[AssocToxTyp(nstate)] do With Location.Morph do
           Begin {save for tox loss output & categorization}
             If Entr<0 then OOSDriftInKg := (-Entr+ToxDis)  {* OOSDischFrac} * SegVol * 1000.0 * 1e-9
                       else OOSDriftInKg :=      ToxDis     {* OOSDischFrac} * SegVol * 1000.0 * 1e-9;
                               {kg}             {ug/L}       {frac}         {m3}    {L/m3}  {kg/ug}
             TotalToxLoss[Derivstep] := TotalToxLoss[Derivstep] + OOSDriftInKg;
             TotalWashout[Derivstep] := TotalWashout[Derivstep] + OOSDriftInKg;
             WashoutH2O[Derivstep]   := WashoutH2O[Derivstep]   + OOSDriftInKg;
             DissWash[DerivStep]     := DissWash[DerivStep] + OOSDriftInKg;
           End;

      If LinkedMode then Inflow := WashIn;

      If LinkedMode and (Not CascadeRunning)
        Then
          Begin
            DiffUp   := SegmentDiffusion(True);
            DiffDown := SegmentDiffusion(False);
          End
        Else If Not LinkedMode then TDF := TurbDiff;

       ToTPoreWaterTox := GetStatePointer(PoreWater,ToxType,SedLayer1);
       If ToTPoreWaterTox <> nil then DiffSed := -ToTPoreWaterTox.UpperDiffusion(True);

      InorgSorpt   := 0;
      InorgDesorpt := 0;
      If SedModelRunning then
        For NSLoop := Cohesives to NonCohesives2 do
          Begin
            PT := GetStatePointer(NSLoop,ToxType,WaterCol);
            If (PT<>nil) then
              Begin
                InorgSorpt   := InorgSorpt  +PT.Sorption;
                InorgDesorpt := InorgDesorpt+PT.Desorption;
              End;
          End;

      ToTPoreWater := GetStatePointer(PoreWater,StV,SedLayer1);
      If (ToTPoreWater <> nil) then
       If (TotPoreWater.VolumeInM3 > Tiny) then
        Begin
          PWToxLevel := GetState(PoreWater,ToxType,SedLayer1);
          {ug/L pw}

           With AllStates do
              FracPoreWUp  := TotPoreWater.To_Above / PWVol_Last_Step[SedLayer1];
                {frac/d}                     {m3/m2 d}        {m3/m2}

          PoreWUp  := PWToxLevel * FracPoreWUp * TotPoreWater.VolumeInM3 / AllStates.SegVol;
        {ug/L(wc) d}  {ug/L pw}    {fraction/d}                  {m3 pw}                   {m3 wc}

          {wc=watercolumn, pw=porewater}

          With AllStates do
            PoreWDown :=  State * TotPoreWater.From_Above * SedLayerArea / SegVol;
          {ug/L(wc) d}   {ug/L wc}                {m3/m2 d}      {m2}          {m3}

        end;


      If not AllStates.SetupRec^.BCFUptake then
        BEGIN  {Animal and plant sorption / desorption}

          If SedModelRunning                   { If the sed submodel is being utilized then seddetr }
            Then StartLoop := DissRefrDetr     { decomposition, sorption and desorption is     }
            Else StartLoop := SedmRefrDetr;    { associated with the tox in the active layer's pore water }
                                               { not the tox in the water column . . . }

          Decomp:=0;
          For DecompLoop := StartLoop to LastDetr do
            Begin
              PD := GetStatePointer(DecompLoop,StV,WaterCol);
              If (PD<>nil) then
                Begin
                  Dec     := PD.Decomposition(Location.Remin.DecayMax_Lab, KAnaerobic, FracAerobic);
                  ThisPPB := GetPPB(DecompLoop,ToxType,WaterCol);
                  Decomp  := Decomp + (Dec * ThisPPB * 1e-6);
                End;
            End;

          If Diagenesis_Included then
           For DecompLoop := POC_G1 to POC_G3 do
            Begin
              TPOC := GetStatePointer(DecompLoop,StV,SedLayer2);
              If (TPOC<>nil) then with Location.Morph do
                Begin
                  Dec     := TPOC.Mineralization;  {g/m3 sed. d}
                  ThisPPB := GetPPB(DecompLoop,ToxType,SedLayer2);
                  Decomp  := Decomp + (Dec     *  ThisPPB * 1e-6)  * DiagenesisVol(2) / SegVolum[VSeg];
                {ug/L day}         {mg/L sed. d}  {ug/kg}  {kg/mg}     {m3 sed}          {m3 water}
                End;
            End;

          DetrSorption   := 0;
          DetrDesorption := 0;
          For NSLoop := StartLoop to LastDetr do
            Begin
              PT := GetStatePointer(NSLoop,ToxType,WaterCol);
              If (PT<>nil) then
                Begin
                  DetrSorption:=DetrSorption+PT.Sorption;
                  DetrDesorption:=DetrDesorption+PT.Desorption;
                End;
            End;

          If Diagenesis_Included then
           For NSLoop := POC_G1 to POC_G3 do
            Begin
              UnitFix := Location.Locale.SurfArea / (SegVol * 1000);
               {m2/L}                     {m2}         {m3}    {L/m3}

              TPOCT := GetStatePointer(NSLoop,ToxType,SedLayer2);
              If (TPOCT<>nil) then with Location.Morph do
                Begin
                  DetrSorption:=DetrSorption    +TPOCT.Sorption  * UnitFix;
                  DetrDesorption:=DetrDesorption+TPOCT.Desorption* UnitFix;
                    {ug/L d}                           {ug/m2 d}   {m2/L}
                End;
            End;


          PlantSorp := 0;
          For NSLoop := FirstPlant to LastPlant do
            begin
              AlgalToxPtr:=(GetStatePointer(NSLoop,ToxType,WaterCol));
              if not (AlgalToxPtr = nil) then
                PlantSorp := PlantSorp + AlgalToxPtr.PlantUptake;
            end;

          GillSorption := 0;
          For NSLoop := FirstAnimal to LastAnimal do
            if not (GetStatePointer(NSLoop,StV,WaterCol) = nil)
              then GillSorption:=GillSorption+TAnimal(GetStatePointer(NSLoop,StV,WaterCol)).GillUptake(ToxType,WaterCol);

                With AllStates do with ToxLossArray[AssocToxTyp(nstate)] do With Location.Morph do
                   Begin {save for tox loss output & categorization}
                     DissSorpInKg := (DetrSorption+PlantSorp+GillSorption)
                                                          * Volume_Last_Step * 1000.0 * 1e-9;
                        {kg}         {ug/L + ug/L + ug/L}        {m3}         {L/m3}  {kg/ug}
                     DissSorp[DerivStep]     := DissSorp[DerivStep] + DissSorpInKg;
                   End;

          ToTPoreWater := GetStatePointer(PoreWater,StV,SedLayer1);
          Dep := 0;
          For NSLoop := FirstBiota to LastBiota do
            Begin
              PT:=(GetStatePointer(NSLoop,AssocToxTyp(NState),WaterCol));
              If PT <> nil then
                Begin
                  FracInWater := 1;
                  If (SedModelRunning) and (NSLoop in [FirstAnimal..LastAnimal])
                     and (TotPoreWater.VolumeInM3 > Tiny) then
                    FracInWater := TAnimal(GetStatePointer(NSLoop,STV,WaterCol)).PAnimalData^.FracInWaterCol;
                  Dep:= Dep + PT.Depuration*FracInWater;
                End;
            End;

        END; {If Not Estimate By BCF}

       dB := Lo - Hyd - Pho - Mic - Vl - ToxDis + Inflow + TDF + Mic_in_Aer + Mic_in_Anaer + DiffUp + DiffDown + DiffSed + Entr;

       db := db + Decomp
                - DetrSorption + DetrDesorption
                - InorgSorpt   + InorgDesorpt
                - GillSorption + Dep
                - PlantSorp + PoreWUp - PoreWDown;

    end; {with}

  WriteRates;
End;
{-------------------------------------------------------------------------}

Procedure TParticleTox.Derivative;
{DERIVATIVE FOR TOXICANT IN DETRITUS}

Var   CP: TRemineralize;
      EpiCP: TSuspendedDetr;
      Lo, So, Des, Co, pp, Ing, SumSed,Photo,WashO, WashI,MTD,STH  : Double;
      Decmp, Sedm, SumDef, Hydr, MM, SETTD, ToPW, PWExp, Entr      : Double;
      FracAerobic, Mic_in_Aer, Mic_in_Anaer, Resusp, DiffSed,GTD   : Double;
      TD, DiffUp, DiffDown, PWDOMToxLevel,SFE                      : Double;
      DepT, ScrT, BrT, ExpT,SedDesorpInKg,SedScourInKg             : Double;
      SedDetrVar, SuspDetrVar, TopDOM  : AllVariables;
      ToTPoreWater             : TPoreWater;
      ToTDOMPoreTox            : TDOMPoreWaterTox;
      OOSDriftInKg, LoadInKg   : Double;
      PBD1                     : TBuriedDetr1;

         {Various Helper functions for calculating derivs}
         {----------------------------------------------------------}
         Function Decomp(ns: StateVariables): Double;
         {Labile Compartments only}
         Var FracAerobic: Double;
         Begin
           With AllStates do
             Decomp := TRemineralize(GetStatePointer(ns,StV,WaterCol)).Decomposition(Location.Remin.DecayMax_Lab, KAnaerobic, FracAerobic);
         End;
         {----------------------------------------------------------}
         Function ColonizeDissRefrDetr: Double;
         begin
           ColonizeDissRefrDetr:=TDissRefrDetr(GetStatePointer(DissRefrDetr,StV,WaterCol)).Colonization;
         end;
         {----------------------------------------------------------}
         Function ColonizeSuspRefrDetr: Double;
         Begin
           ColonizeSuspRefrDetr:=TSuspRefrDetr(GetStatePointer(SuspRefrDetr,StV,WaterCol)).Colonization;
         End;
         {----------------------------------------------------------}
         Function ColonizeSedRefrDetr: Double;
         Begin
           ColonizeSedRefrDetr:=TSedRefrDetr(GetStatePointer(SedmRefrDetr,StV,WaterCol)).Colonization;
         End;
         {----------------------------------------------------------}
         Function SumDefecationTox: Double;
         {sum all of the Predator defecation of toxicant}
         Var SumDef : Double;
             ns     : statevariables;
         Begin
           SumDef := 0;
           For ns := FirstAnimal to LastAnimal do
            if not (GetStatePointer(ns,StV,WaterCol) = nil)
              then SumDef:=SumDef+TAnimal(GetStatePointer(ns,StV,WaterCol)).DefecationTox(SVType);
           SumDefecationTox := SumDef;
         End;
         {----------------------------------------------------------}
         Function SumExcToxToDiss(DissPart: AllVariables):Double;
         {Sum of Toxicant Excretion from Plants to Dissolved Particulate}
         Var Loop     : AllVariables  ;
             DP       : TDetritus ;
             PPl       : TPlant ;
             Exc2Diss : Double;
         Begin
           Exc2Diss := 0;
           DP := GetStatePointer(DissPart,StV,WaterCol);
           For Loop:=FirstPlant to LastPlant do
             If GetStatePointer(Loop,StV,WaterCol)<>nil then With AllStates do
               Begin
                 PPl:=GetStatePointer(Loop,StV,WaterCol);
                 Exc2Diss := Exc2Diss + PPl.PhotoResp * DP.Excr_To_Diss_Detr(Loop)
                             * GetPPB(Loop,SVType,Layer) * 1e-6;
               End;
           SumExcToxToDiss:=Exc2Diss;
         End;
         {----------------------------------------------------------}
(*         Procedure CalculateSloughing_and_ToxDislodge;
         {Sum of tox movement due to Sloughing & Tox DisLodge from Plants to Suspended Detritus}
         Var Loop     : AllVariables  ;
             PP       : TPlant ;
         Begin
           PlSlg := 0;
           PlToxD := 0;
           For Loop:=FirstAlgae to LastAlgae do
             If GetStatePointer(Loop,StV,WaterCol)<>nil then
               Begin
                 PP:=GetStatePointer(Loop,StV,WaterCol);
                 PlSlg := PlSlg + PP.Sloughing       * GetPPB(Loop,SVType,WaterCol) * 1e-6;
                 PlToxD := PlToxD + PP.ToxicDislodge * GetPPB(Loop,SVType,WaterCol) * 1e-6;
                 {ug/L}    {ug/L}        {mg/L}
               End;
         End; *)
         {----------------------------------------------------------}
         Function IngestOfCarrier: Double;
         Var SumIngest,ER,GER: Double;
             Ptr : Pointer;
             ns  : AllVariables;
         Begin
           SumIngest:=0;
           For ns := FirstAnimal to LastAnimal do
             Begin
               Ptr:=GetStatePointer(ns,StV,WaterCol);
               If not (ptr=nil) then
                 SumIngest:=SumIngest+TAnimal(Ptr).IngestSpecies(carrier,nil,ER,GER);
             End;
           IngestofCarrier := SumIngest;
         End;
         {----------------------------------------------------------}
         Function Sediment(ns: statevariables): Double;
         Var P: Pointer;
         Begin
           P:= GetStatePointer(NS,StV,WaterCol);
           If ns=SuspLabDetr then Sediment := TSuspLabDetr(P).Sedimentation
                             else Sediment := TSuspRefrDetr(P).Sedimentation;
         End;
         {----------------------------------------------------------}
         Function Resuspension(ns: statevariables): Double;
         Var PSD: TSuspendedDetr;
         Begin
           PSD := GetStatePointer(NS,StV,WaterCol);
           Resuspension := PSD.Resuspension;
         End;
         {----------------------------------------------------------}
         Function MortalityToDetrTox(ns: statevariables): Double;
         {Calculates the toxicants in mortality / macro breakage / toxdischarge / sloughing to detritus interactions}
         Var   MortTox : Double;
              {----------------------------------------------------------}
              Procedure SumMortTox(POr: TOrganism);
              Var DP                  : TDetritus;
                  Mort2Detr           : Double;
                  j, Mort, FracMult   : Double;
              Begin
                If POr.IsPlantOrAnimal then
                  Begin
                    DP := AllStates.GetStatePointer(ns,StV,WaterCol);  {Get detrital toxicant carrier state variable}
                    Mort2Detr := DP.Mort_To_Detr(POr.NState);

                    Mort := POr.Mortality;
                    If POr.IsMacrophyte then Mort:=Mort+TMacrophyte(POR).Breakage;
                    If POr.IsPlant and (Not POr.IsMacrophyte) then with TPlant(POr) do
                      Begin
                        Mort:=Mort+ToxicDislodge;
                        TPlant(POr).CalcSlough; {update sloughevent}
                        If Sloughevent then
                          Begin
                            j := -999; {signal to not write mass balance tracking}
                            TPlant(POr).Derivative(j); {update sloughing}
                            If PSameSpecies^ = NullStateVar then FracMult := 1.0
                                                            else FracMult := 2/3;
                           {1/3 of periphyton will go to phytoplankton and 2/3 to detritus with sloughing/scour.}
                            Mort := Mort + Sloughing * FracMult;
                          End;
                      End;

                    MortTox := MortTox + Mort2Detr * Mort * AllStates.GetPPB(POr.nstate,SVType,WaterCol) * 1e-6;
                  End;   {if}
              End; {SumMortTox}
              {----------------------------------------------------------}

           Var i: integer;
           Begin
             MortTox:=0;
             With AllStates do For i:=0 to count-1 do
                   SumMortTox(at(i));
             MortalityToDetrTox := MortTox;
           End;
         {----------------------------------------------------------}
         Function GamLossToDetrTox: Double;
         {Calculates the toxicants in gamete loss to detritus interactions}
         Var GamTox : double;
             i      : integer;

              Procedure SumGamTox(IP: TStateVariable);
              Var PA            : TAnimal;

              Begin
                if IP.IsAnimal then
                   begin
                     PA:=TAnimal(IP);
                     GamTox := GamTox + PA.GameteLoss * AllStates.GetPPB(IP.NState,SVType,Layer) * 1e-6;
                   end;   {if }
              End; {SumGamTox}

           Begin
             GamTox:=0;
             With AllStates do For i:=0 to count-1 do
                   SumGamTox(at(i));

             GamLossToDetrTox := GamTox;
           End;

         {----------------------------------------------------------}
         Function SumPlantSedTox: Double;
         Var SedTox: Double;

            Procedure SumSedTox(IP: TStateVariable);
            var PPl       : TPlant;
                Sed2Detr : Double;
                DP        : TDetritus;
            begin
              if IP.IsAlgae then
               begin
                 PPl:=TPlant(IP);
                 DP:=TDetritus(CP);
                 Sed2Detr := DP.PlantSink_To_Detr(PPl.NState);
                 SedTox := SedTox + (PPl.Sedimentation * Sed2Detr * GetPPB(PPl.NState,SVType,WaterCol) * 1e-6);
               end;
            end;

         Var i: integer;
         Begin
             SedTox:=0;
             With AllStates do For i:=0 to count-1 do
                   SumSedTox(at(i));
             SumPlantSedTox := SedTox;
         End;
         {----------------------------------------------------------}
         Procedure CalcPW(PWState: AllVariables);
         Var PWExppw: Double;
         {Given a passed Pore Water State Variable, Calculates values for PWExp,ToPW for this Toxicant}
         Begin
           PWExp := 0; ToPW:=0;
           ToTPoreWater := GetStatePointer(PoreWater,StV,SedLayer1);

           If (ToTPoreWater <> nil) then
            If (TotPoreWater.VolumeInM3 > tiny) then
             Begin
               PWDOMToxLevel := GetState(PWState,SVType,SedLayer1);
               {ug/L (pw)}

               With AllStates do
                 PWExppw := PWDOMToxLevel * TotPoreWater.To_Above / PWVol_Last_Step[SedLayer1];
               {ug/L pw d}    {ug/L pw}                  {m3/m2 d}      {m3/m2}

               With AllStates do
                 PWExp := PWExppw *  TotPoreWater.VolumeInM3 / SegVol;
              {ug/L wc d} {ug/L pw d}                   {m3 pw}   {m3 wc}

               With AllStates do
                 ToPW  := State  * TotPoreWater.From_Above * SedLayerArea / SegVol;
             {ug/L wc d} {ug/L wc}                 {m3/m2 d}    {m2}          {m3 wc}
             End;
         End;
         {----------------------------------------------------------}
         Function M2_L: Double;
         Begin
           M2_L := Location.Locale.SurfArea / (AllStates.SegVol * 1000);
          {m2/L}                     {m2}                  {m3}              {L/m3}
         End;
         {----------------------------------------------------------}
         Function DeposTox: Double;
         {Deposition of Toxicant}
         begin
           If nstate in [SuspRefrDetr..SuspLabdetr]
             then  {DeposTox removes toxicant from part detr}
                   DeposTox := PBD1.TotalDep * GetPPB(nstate,SVType,WaterCol) * M2_L *  1e-3
                    {ug/L d}         {g/m2 d}          {ug/kg}                  {m2/L}  {kg/g}
             else  {DeposTox adds toxicant to seddetr}
                   DeposTox := PBD1.TotalDep * PBD1.Frac_Dep_ToSed
                    {ug/L d}         {g/m2 d}          {unitless}
                                * GetPPB(suspdetrvar,SVType,WaterCol) * M2_L *  1e-3;
                                              {ug/kg}                  {m2/L}  {kg/g}
         end;
         {----------------------------------------------------------}
         Function ScourTox: Double;   {relevant to sed and susp toxs}
         Var SC: Double;
         begin
           If nstate in [susplabdetr,susprefrdetr]
             then
               begin
                 {Add Scoured Tox from Sed Layer to susp layer}
                 SC:= GetState(SedDetrVar,StV,WaterCol)* PBD1.Frac_Sed_Scour * GetPPB(SedDetrVar,svtype,watercol) * 1e-6;
                 {Add Scoured Tox from Buried Layer to susp layer}
                 ScourTox:=SC + PBD1.State * PBD1.Frac_Buried_Scour * GetPPB(PBD1.NState,svtype,watercol) *  M2_L *  1e-3
                 {ug/L d}           {g/m2}            {1/d}                {ug/kg}                             {m2/L}  {kg/g}
               end
             else {Scour removes Toxicant from Sed Detr}
                 ScourTox := GetState(SedDetrVar,stv,watercol) * PBD1.Frac_Sed_Scour * GetPPB(nstate,svtype,watercol) * 1e-6;
                 {ug/L d}        {mg/L}                                  {1/d}                 {ug/kg}                  {kg/mg}
         end;
         {----------------------------------------------------------}
         Function BurialTox: Double;
         Var Bur: Double;
             P  : Pointer;
         begin  {Burial removes toxicant from SedDetr}
           P   := GetStatePointer(SedDetrVar,stv,watercol);
           Bur := PBD1.SedDetr_To_Buried + TDetritus(P).DailyBurial;
           BurialTox := Bur * GetPPB(nstate,svtype,watercol) * 1e-6;
            {ug/L}    {mg/L}           {ug/kg}                 {kg/mg}
         end;
         {----------------------------------------------------------}
         Function ExposeTox: Double;
         begin  {Exposure adds toxicant to SedDetr}
           ExposeTox := PBD1.BuriedDetr_To_Sed * GetPPB(PBD1.nstate,svtype,watercol) * M2_L *  1e-3;
            {ug/L}         {g/m2 d}                          {ug/kg}                   {m2/L}   {kg/g}
         end;
         {----------------------------------------------------------}
         Procedure WriteRates;
         Begin
           With AllStates.SetupRec^ do
            If (SaveBRates or ShowIntegration) then
             Begin
               ClearRate;
               SaveRate('State',State);
               SaveRate('Load',Lo);
               SaveRate('Hydrolysis',Hydr);
               SaveRate('MicrobMet',MM);
               SaveRate('AerMM In',Mic_in_Aer);
               SaveRate('AnaerMM In',Mic_in_Anaer);

               If not AllStates.SedModelIncluded then
                 Begin
                   If not (nstate in [DissRefrDetr,Disslabdetr]) then
                       SaveRate('ScourTox',ScrT);

                   If nstate in [SedmRefrDetr,SedmLabDetr] then
                     Begin
                       SaveRate('BurialTox',BrT);
                       SaveRate('ExposureTox',ExpT);
                     End;
                  End;   

               If not (nstate in [SedmRefrDetr..SedmLabDetr]) then
                 begin
                   SaveRate('Photol',Photo);
                   SaveRate('Washout',WashO);
                   SaveRate('Washin',WashI);
                   SaveRate('MortToDetr',MTD);
                   If Not AllStates.LinkedMode
                      then SaveRate('TurbDiff',TD)
                      else {If Not AllStates.CascadeRunning then}
                        Begin
                          SaveRate('DiffUp',DiffUp);
                          SaveRate('DiffDown',DiffDown);
                        End;
                    If AllStates.EstuarySegment then
                       SaveRate('Entrainment',Entr);
                    SaveRate('NetBoundary',Lo+WashI-WashO +Entr+DiffUp+DiffDown+TD);
                 end;

               If nstate in [SedmRefrDetr..SedmLabDetr] then
                 Begin
                   SaveRate('SumDef',SumDef);
                   SaveRate('SumPlantSed',SumSed);
                 End;

               If nstate in [SuspRefrDetr..SuspLabDetr] then
                 Begin
                   SaveRate('SinkToHyp',STH);
                   SaveRate('SinkFromEpi',SFE);
                 End;

               SaveRate('Sorption',So);
               SaveRate('Desorption',Des);

               If not (nstate=DissLabDetr) then
                  SaveRate('ColRefr',Co);

               If not (nstate in [DissRefrDetr..DissLabDetr]) then
                 begin
                   SaveRate('Ingest',Ing);
                   SaveRate('Sediment',Sedm + DepT);
                   SaveRate('ReSusp',Resusp);
                 end;

               If (SedDetrVar<>SedmRefrDetr) then
                  SaveRate('Decomp',Decmp);     {not for refractory compartments}

               If (nstate = SuspLabDetr) then
                 Begin
                   SaveRate('GameteToDetr',GTD);
{                  SaveRate('PlantToxDisl',PlToxD);
                   SaveRate('PlantEntrain',PlSlg); }
                 End;

               If (nstate in [DissRefrDetr..DissLabDetr]) then
                 begin
                   SaveRate('SumExcrete',SETTD);
                   SaveRate('ToPore',ToPW);
                   SaveRate('PWExpulsion',PWExp);
                   If AllStates.SedModelIncluded then SaveRate('DiffusSed',DiffSed);
                 end;

             End;
    End;
    {----------------------------------------------------------------}
Begin
  Lo:=0; So:=0; Des:=0; Co:=0; SumDef:=0; Ing:=0; SumSed:=0;  WashI:=0;
  Decmp:=0; Sedm:=0; Resusp:=0; Hydr:=0; MM:=0; GTD:=0; SETTD:=0; STH:=0; SFE:=0;
  Photo:=0; WashO:=0; TD:=0; MTD:=0; PWExp:=0; ToPW:=0; Entr := 0;
  Mic_in_Aer:=0; Mic_in_Anaer :=0; DiffUp:=0; DiffDown:=0; DiffSed := 0;
  DepT:=0; ScrT:=0; BrT:=0; ExpT:=0;

  CP:=GetStatePointer(Carrier,StV,WaterCol);
  pp  := GetPPB(NState,SVType,Layer);

  If (nstate in [SedmLabDetr,SuspLabDetr,DissLabDetr])
     then begin
            SedDetrVar   := SedmLabDetr;
            PBD1  := GetStatePointer(BuriedLabileDetr,stv,watercol);
            SuspDetrVar  := SuspLabDetr;
          end
     else {nstate in [SedmRefrDetr,SuspRefrDetr,DissRefrDetr])}
         begin
           SedDetrVar  := SedmRefrDetr;
           PBD1  := GetStatePointer(BuriedRefrDetr,stv,watercol);
           SuspDetrVar := SuspRefrDetr;
         end;

  If Not (AllStates.SedModelIncluded) and (PBD1<>nil) then   // scour from deeply buried layer in "classic" model
    Begin
      PBD1.CalcTotalDep; PBD1.CalcTotalScour;
    End;

  If Eutrophication or AllStates.SetupRec^.BCFUptake
   then  dB := 0.0
   else
    Begin
      Lo := Loading;

      With AllStates do
        If EstuarySegment and not (NState in [SedmLabDetr,SedmRefrDetr])
          then Begin
                 Entr := EstuaryEntrainment;
                 If Entr<0 then Entr := Entr * pp * 1e-6;
                 If Entr>0 then Entr := Entr * HypoSegment.GetPPB(NState,SVType,Layer) * 1e-6;
               End;

      With AllStates do with ToxLoadArray[SVType] do
         Begin {save for tox loss output & categorization}
           If Entr>0 then LoadInKg := (Lo+Entr) * SegVol * 1000.0 * 1e-9
                     else LoadInKg :=  Lo       * SegVol * 1000.0 * 1e-9;
                            {kg}       {ug/L}       {m3}    {L/m3} {kg/ug}
           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           ToxLoadDetr[Derivstep] := ToxLoadDetr[Derivstep] + LoadInKg;
         End;

      Hydr  := Hydrolysis;
      MM    := MicrobialMetabolism(FracAerobic);
      Mic_in_Aer   := Microbial_BioTrans_To_This_SV(True);
      Mic_in_Anaer := Microbial_BioTrans_To_This_SV(False);

      With AllStates do
       If (nState = SedmLabDetr) then
         Begin
            If (Not SedModelIncluded) and (PBD1<>nil) then  // non multi-sed but buried sediment
              Begin
                DepT  := DeposTox;
                ScrT  := ScourTox;
                BrT   := BurialTox;
                ExpT  := ExposeTox;
              End;

            SumDef := SumDefecationTox * Def2SedLabDetr;
            Ing   := IngestOfCarrier * pp * 1e-6;

            So  := Sorption;
            ToTPoreWater := GetStatePointer(PoreWater,StV,SedLayer1);
            If (So>0) and SedModelIncluded then
              So      :=     So    * TotPoreWater.VolumeInM3 / SegVol;
             {ug/L wc}   {ug/L pw}                  {m3 pw}         {m3 wc}

            Des := Desorption;

                With AllStates do with ToxLossArray[OrgType] do With Location.Morph do
                   Begin {save for 1/2 life calculation}
                     SedDesorpInKg := Des  * SegVol * 1000.0 * 1e-9;
                        {kg}         {ug/L}          {m3}         {L/m3}  {kg/ug}
                     SedDesorp[DerivStep]     := SedDesorp[DerivStep] + SedDesorpInKg;
                   End;

            Co  := (ColonizeSedRefrDetr * GetPPB(SedmRefrDetr,SVType,Layer) * 1e-6);

            SumSed:= SumPlantSedTox;
            Decmp := Decomp(SedmLabDetr) * pp * 1e-6;

            Sedm  := Sediment(SuspLabDetr);
            If Sedm>0 then Sedm := Sedm * GetPPB(SuspLabDetr,SVType,Layer) * 1e-6   {sedimentation}
                      else Sedm := Sedm * pp * 1e-6;  {resuspension}
            ReSusp := Resuspension(SuspLabDetr) * pp * 1e-6;

            With AllStates do with ToxLossArray[OrgType] do With Location.Morph do
               Begin {save scour for 1/2 life calculation, can be in Resusp, Sedm, or ScrT depending on bed model used}
                 SedScourInKg := Resusp+ScrT  * SegVol * 1000.0 * 1e-9;
                    {kg}           {ug/L}         {m3}   {L/m3}  {kg/ug}
                 If Sedm <0 then SedScourInKg := Resusp+ScrT-Sedm  * SegVol * 1000.0 * 1e-9;
                                    {kg}           {ug/L}             {m3}   {L/m3}  {kg/ug}
                 SedScour[DerivStep]     := SedScour[DerivStep] + SedScourInKg;
               End;

           If (SedModelIncluded) and (TotPoreWater.VolumeInM3<tiny) then
              Begin  {no pore water exists for decomposition, sorption, desorption}
                Decmp := 0;
                So    := 0;
                Des   := 0;
              End;

            dB  :=  Lo + So - Des + Co + SumDef - (Decmp + Ing) + Sedm - Resusp + Mic_In_Aer + Mic_In_Anaer
                    - Hydr - MM + SumSed + DepT - ScrT - BrT + ExpT ;
         End  {SedLabileDetrTox}
        else if (NState in [SedmRefrDetr]) then
          Begin
            If (Not SedModelIncluded) and (PBD1<>nil) then
              Begin
                DepT  := DeposTox;
                ScrT  := ScourTox;
                BrT   := BurialTox;
                ExpT  := ExposeTox;
              End;

            So  := Sorption;
            ToTPoreWater := GetStatePointer(PoreWater,StV,SedLayer1);
            If (So>0) and SedModelIncluded then
              So      :=     So    * TotPoreWater.VolumeInM3 / SegVol;
             {ug/L wc}   {ug/L pw}                  {m3 pw}         {m3 wc}

            Des := Desorption;

                With AllStates do with ToxLossArray[OrgType] do With Location.Morph do
                   Begin {save for 1/2 life calculation}
                     SedDesorpInKg := Des  * SegVol * 1000.0 * 1e-9;
                        {kg}         {ug/L}          {m3}         {L/m3}  {kg/ug}
                     SedDesorp[DerivStep]     := SedDesorp[DerivStep] + SedDesorpInKg;
                   End;

            If (NState = SedmRefrDetr) then Co := ColonizeSedRefrDetr * pp * 1e-6;
            SumSed := SumPlantSedTox;
            SumDef := SumDefecationTox;
            If (NState=SedmRefrDetr) then SumDef:=SumDef * (1-Def2SedLabDetr);
            Ing := IngestOfCarrier * pp * 1e-6;

            Sedm  := Sediment(SuspDetrVar);
            If Sedm>0 then Sedm := Sedm * GetPPB(SuspDetrVar,SVType,Layer) * 1e-6   {sedimentation}
                      else Sedm := Sedm * pp * 1e-6;  {resuspension}

            ReSusp := Resuspension(SuspDetrVar) * pp * 1e-6;

            If (SedModelIncluded) and (TotPoreWater.VolumeInM3<tiny) then
              Begin  {no pore water exists for decomposition, sorption, desorption}
                So    := 0;
                Des   := 0;
              End;

            With AllStates do with ToxLossArray[OrgType] do With Location.Morph do
               Begin {save scour for 1/2 life calculation, can be in Resusp, Sedm, or ScrT depending on bed model used}
                 SedScourInKg := Resusp+ScrT  * SegVol * 1000.0 * 1e-9;
                    {kg}           {ug/L}         {m3}   {L/m3}  {kg/ug}
                 If Sedm <0 then SedScourInKg := Resusp+ScrT-Sedm  * SegVol * 1000.0 * 1e-9;
                                    {kg}           {ug/L}             {m3}   {L/m3}  {kg/ug}
                 SedScour[DerivStep]     := SedScour[DerivStep] + SedScourInKg;
               End;

            {kinetic derivative for SedmRefrDetrTox}
            dB :=  Lo + So - Des + SumDef + SumSed - (Co + Ing)
                   + Sedm - Resusp - Hydr - MM + Mic_In_Aer + Mic_In_Anaer + DepT - ScrT - BrT + ExpT

          End {SedmRefrDetr / SedmDetr}
        else if (nstate = SuspLabDetr) then
          Begin
            If (Not SedModelIncluded) and (PBD1<>nil) then
              Begin
                DepT  := DeposTox;
                ScrT  := ScourTox;
              End;

            Photo := PhotoLysis;
            WashO := CP.Washout * GetPPB(SuspLabDetr,SVType,Layer)* 1e-6;
            WashoutStep[AllStates.DerivStep] := WashO * AllStates.SegVol;

              With AllStates do with ToxLossArray[SVType] do With Location.Morph do
                 Begin {save for tox loss output & categorization}
                   If Entr < 0 then OOSDriftInKg := (-Entr+WashO)  {* OOSDischFrac} * SegVol * 1000.0 * 1e-9
                               else OOSDriftInKg := WashO          {* OOSDischFrac} * SegVol * 1000.0 * 1e-9;
                                       {kg}         {ug/L}            {frac}       {m3}     {L/m3}  {kg/ug}
                   TotalToxLoss[DerivStep] := TotalToxLoss[DerivStep] + OOSDriftInKg;
                   TotalWashout[DerivStep] := TotalWashout[DerivStep] + OOSDriftInKg;
                   WashoutDetr[DerivStep]  := WashoutDetr[DerivStep]  + OOSDriftInKg;
                 End;

            WashI := ToxInCarrierWashin;
            If Not LinkedMode then TD := ToxDiff
                              else If Not CascadeRunning then
                                   Begin
                                     DiffUp := ToxSegDiff(True);
                                     DiffDown := ToxSegDiff(False);
                                   End;

            With AllStates do with ToxLoadArray[SVType] do
               Begin {save for tox loss output & categorization}
                 LoadInKg := (WashI+DiffUp+DiffDown) * SegVol * 1000.0 * 1e-9;
                   {kg}            {ug/L}               {m3}    {L/m3} {kg/ug}
                 TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
                 ToxLoadDetr[Derivstep] := ToxLoadDetr[Derivstep] + LoadInKg;
               End;

            STH   := TSuspendedDetr(CP).DetrSinkToHypo * GetPPB(SuspLabDetr,SVType,Layer) * 1e-6;
            With AllStates do
            If VSeg=Hypolimnion then
               Begin
                 EpiCP := EpiSegment.GetStatePointer(Carrier,StV,WaterCol);  {Refinement 10-20-2002 JSC}
                 SFE := EpiCP.DetrSinkToHypo * EpiSegment.GetPPB(SuspLabDetr,SVType,WaterCol)* 1e-6;
               End;

            So  := Sorption;
            Des := Desorption;

            Sedm  := Sediment(SuspLabDetr);
            Decmp:= Decomp(SuspLabDetr) * GetPPB(SuspLabDetr,SVType,Layer) * 1e-6;

            If Diagenesis_Included and (Sedm<0) then Sedm := 0;  {no resuspension in diagenesis model}
            If Sedm>=0 then Sedm := Sedm * GetPPB(SuspLabDetr,SVType,Layer) * 1e-6   {sedimentation}
                       else Sedm := Sedm * GetPPB(SedmLabDetr,SVType,Layer) * 1e-6;  {resuspension}

            If Diagenesis_included
              then ReSusp := 0
              else ReSusp := Resuspension(SuspLabDetr) * GetPPB(SedmLabDetr,SVType,Layer) * 1e-6;

            MTD := MortalityToDetrTox(SuspLabDetr);
            GTD := GamLossToDetrTox;
(*            CalculateSloughing_and_ToxDislodge; {PlSlg, ToxD are set} *)

            Ing  := IngestOfCarrier * GetPPB(SuspLabDetr,SVType,Layer)* 1e-6;
            Co   := ColonizeSuspRefrDetr * GetPPB(SuspRefrDetr,SVType,Layer) * 1e-6 +
                    ColonizeDissRefrDetr * GetPPB(DissRefrDetr,SVType,Layer) * 1e-6 ;

            {kinetic derivative for SuspLabDetrTox}
            dB   :=  Lo + So - Des + MTD + GTD {+ PlSlg + PlToxD} + WashI + Resusp - (Sedm + WashO + Decmp + Ing) + Entr
                        + Co - Hydr - Photo - MM + TD + DepT + ScrT + DiffUp + DiffDown - STH + SFE + Mic_In_Aer + Mic_In_Anaer

          End {SuspLabDetr Toxicant Deriv}

        else if (NState in [SuspRefrDetr]) then
          Begin
            If (not SedModelIncluded) and (PBD1<>nil) then
              Begin
                DepT  := DeposTox;
                ScrT  := ScourTox;
              End;
                
            Photo := Photolysis;
            WashO := CP.Washout * pp * 1e-6;
            WashoutStep[AllStates.DerivStep] := WashO * AllStates.SegVol;

             With AllStates do with ToxLossArray[SVType] do With Location.Morph do
               Begin {save for tox loss output & categorization}
                   If Entr < 0 then OOSDriftInKg := (-Entr+WashO)  {* OOSDischFrac} * SegVol * 1000.0 * 1e-9
                               else OOSDriftInKg := WashO          {* OOSDischFrac} * SegVol * 1000.0 * 1e-9;
                                       {kg}         {ug/L}            {frac}       {m3}     {L/m3}  {kg/ug}
                 TotalToxLoss[DerivStep] := TotalToxLoss[DerivStep] + OOSDriftInKg;
                 TotalWashout[DerivStep] := TotalWashout[DerivStep] + OOSDriftInKg;
                 WashoutDetr[DerivStep]  := WashoutDetr[DerivStep]  + OOSDriftInKg;
               End;


            WashI := ToxInCarrierWashin;
            If Not LinkedMode then TD := ToxDiff
                              else If Not CascadeRunning then
                                   Begin
                                     DiffUp   := ToxSegDiff(True);
                                     DiffDown := ToxSegDiff(False);
                                   End;
            With AllStates do with ToxLoadArray[SVType] do
               Begin {save for tox loss output & categorization}
                 LoadInKg := (WashI+DiffUp+DiffDown) * SegVol * 1000.0 * 1e-9;
                   {kg}            {ug/L}               {m3}    {L/m3} {kg/ug}
                 TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
                 ToxLoadDetr[Derivstep] := ToxLoadDetr[Derivstep] + LoadInKg;
               End;


            STH  := TSuspendedDetr(CP).DetrSinkToHypo * GetPPB(NState,SVType,Layer) * 1e-6;
            If VSeg=Hypolimnion then
               Begin
                 EpiCP := EpiSegment.GetStatePointer(Carrier,StV,WaterCol);  {Refinement 10-20-2002 JSC}
                 SFE := EpiCP.DetrSinkToHypo * EpiSegment.GetPPB(SuspRefrDetr,SVType,WaterCol)* 1e-6;
               End;

            So  := Sorption;
            Des := Desorption;

            Sedm:= Sediment(NState);
            If Diagenesis_Included and (Sedm<0) then Sedm := 0;  {no resuspension in diagenesis model}
            If Sedm>=0 then Sedm := Sedm * GetPPB(NState,SVType,Layer) * 1e-6   {sedimentation}
                       else Sedm := Sedm * GetPPB(SedDetrVar,SVType,Layer) * 1e-6;  {resuspension}

            If Diagenesis_included
              then ReSusp := 0
              else ReSusp := Resuspension(NState) * GetPPB(SedDetrVar,SVType,Layer) * 1e-6;

            If (NState=SuspRefrDetr) then Co := ColonizeSuspRefrDetr * PP * 1e-6;

            MTD := MortalityToDetrTox(NState);
            Ing := IngestOfCarrier * pp * 1e-6;

            {kinetic Deriv for SuspRefrDetrTox }
            dB  :=  Lo + So - Des + MTD + WashI + Resusp - (Sedm + WashO + Co + Ing) +Entr - Hydr + GTD {+ PlSlg + PlToxD}
                    - Photo - MM + TD + DiffUp + DiffDown + DepT + ScrT - STH + SFE + Mic_In_Aer + Mic_In_Anaer;

         End {SuspRefrDetr / SuspRefr Toxicant Deriv}

       else if (NState = DissLabDetr) then
         Begin
           Photo := Photolysis;
           WashO := CP.Washout * PP * 1e-6;
           WashoutStep[AllStates.DerivStep] := WashO * AllStates.SegVol;

            With AllStates do with ToxLossArray[SVType] do With Location.Morph do
               Begin {save for tox loss output & categorization}
                   If Entr < 0 then OOSDriftInKg := (-Entr+WashO)  {* OOSDischFrac} * SegVol * 1000.0 * 1e-9
                               else OOSDriftInKg := WashO          {* OOSDischFrac} * SegVol * 1000.0 * 1e-9;
                                       {kg}         {ug/L}            {frac}       {m3}     {L/m3}  {kg/ug}
                 TotalToxLoss[DerivStep] := TotalToxLoss[DerivStep] + OOSDriftInKg;
                 TotalWashout[DerivStep] := TotalWashout[DerivStep] + OOSDriftInKg;
                 WashoutDetr[DerivStep]  := WashoutDetr[DerivStep]  + OOSDriftInKg;
                 DissWash[DerivStep]     := DissWash[DerivStep] + OOSDriftInKg;
               End;


           WashI := ToxInCarrierWashin;
           If Not LinkedMode then TD := ToxDiff
                             else If Not CascadeRunning then
                                  Begin
                                    DiffUp := ToxSegDiff(True);
                                    DiffDown := ToxSegDiff(False);
                                  End;
            With AllStates do with ToxLoadArray[SVType] do
               Begin {save for tox loss output & categorization}
                 LoadInKg := (WashI+DiffUp+DiffDown) * SegVol * 1000.0 * 1e-9;
                   {kg}            {ug/L}               {m3}    {L/m3} {kg/ug}
                 TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
                 ToxLoadDetr[Derivstep] := ToxLoadDetr[Derivstep] + LoadInKg;
               End;
                                  

           ToTDOMPoreTox := GetStatePointer(LaDOMPore,SVType,SedLayer1);
           If ToTDOMPoreTox<>nil then DiffSed := -ToTDOMPoreTox.UpperToxDiff(True);

           So    := Sorption;
           Des   := Desorption;

           MTD   := MortalityToDetrTox(DissLabDetr);
           SETTD := SumExcToxToDiss(DissLabDetr);
           Decmp := Decomp(DissLabDetr) * GetPPB(DissLabDetr,SVType,Layer) *1e-6;

{          Co    := ColonizeDissRefrDetr * GetPPB(DissRefrDetrTox) * 1e-6;
                    Colonization of DissRefrDetr-->suspLabDetr June 24, 1998 }

           CalcPW(LaDomPore);  {Calculates values for PWExp,ToPW}

           dB   :=  Lo + So - Des + MTD + SETTD + WashI - (WashO + Decmp) + Entr
                      - Hydr -  Photo - MM + TD + DiffUp + DiffDown + DiffSed + Mic_In_Aer + Mic_In_Anaer + PWExp - ToPW


         End {DissLabDetr Tox Deriv}
       else if (NState = DissRefrDetr) then
         Begin
           Photo := Photolysis;
           WashO := CP.Washout * PP * 1e-6;
           WashoutStep[AllStates.DerivStep] := WashO * AllStates.SegVol;

             With AllStates do with ToxLossArray[SVType] do With Location.Morph do
               Begin {save for tox loss output & categorization}
                   If Entr < 0 then OOSDriftInKg := (-Entr+WashO)  {* OOSDischFrac} * SegVol * 1000.0 * 1e-9
                               else OOSDriftInKg := WashO          {* OOSDischFrac} * SegVol * 1000.0 * 1e-9;
                                       {kg}         {ug/L}            {frac}       {m3}     {L/m3}  {kg/ug}
                 TotalToxLoss[DerivStep] := TotalToxLoss[DerivStep] + OOSDriftInKg;
                 TotalWashout[DerivStep] := TotalWashout[DerivStep] + OOSDriftInKg;
                 WashoutDetr[DerivStep]  := WashoutDetr[DerivStep]  + OOSDriftInKg;
                 DissWash[DerivStep]     := DissWash[DerivStep] + OOSDriftInKg;
               End;


           WashI := ToxInCarrierWashin;
           If Not LinkedMode then TD := ToxDiff
                             else If Not CascadeRunning then
                                  Begin
                                    DiffUp := ToxSegDiff(True);
                                    DiffDown := ToxSegDiff(False);
                                  End;
            With AllStates do with ToxLoadArray[SVType] do
               Begin {save for tox loss output & categorization}
                 LoadInKg := (WashI+DiffUp+DiffDown) * SegVol * 1000.0 * 1e-9;
                   {kg}            {ug/L}               {m3}    {L/m3} {kg/ug}
                 TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
                 ToxLoadDetr[Derivstep] := ToxLoadDetr[Derivstep] + LoadInKg;
               End;

           TopDOM := ReDOMPore;

           ToTDOMPoreTox := GetStatePointer(TopDOM,SVType,SedLayer1);
           If ToTDOMPoreTox<>nil then DiffSed := -ToTDOMPoreTox.UpperToxDiff(True);

           So    := Sorption;
           Des   := Desorption;

           MTD   := MortalityToDetrTox(NState);
           SETTD := SumExcToxToDiss(NState);
           If nstate=DissRefrDetr then
              Co    := ColonizeDissRefrDetr * GetPPB(NState,SVType,Layer) * 1e-6;

           CalcPW(TopDOM); {Calculates values for PWExp,ToPW}

           dB   :=  Lo + So - Des + MTD + SETTD + WashI - (WashO + Co) + Entr
                       - Hydr -  Photo - MM + TD + DiffUp + DiffDown + DiffSed + Mic_In_Aer + Mic_In_Anaer + PWExp - ToPW

         End; {DissRefrDetrTox}
    End; {If Not Eutrophication}

  WriteRates;
End;

{-------------------------------------------------------------------------}

Procedure TPOCTox.Derivative(var db: Double);
Var   So, Des, DepTox, Minrl, Bur, Pred, Mic_In_Anaer, Hydr, MM : Double;
      CP: TPOC_Sediment;
      PP: Double;

    {----------------------------------------------------------------}
         Procedure WriteRates;
         Begin
           With AllStates.SetupRec^ do
            If (SaveBRates or ShowIntegration) then
             Begin
               ClearRate;
               SaveRate('State',State);
               SaveRate('Sorption',So);
               SaveRate('Desorption',Des);
               SaveRate('Deposit Tox',DepTox);
               SaveRate('Mineraliz',Minrl);
               SaveRate('BurialTox',Bur);
               SaveRate('Predation',Pred);
               SaveRate('Hydrolysis',Hydr);

               SaveRate('MicrobMet',MM);
               SaveRate('AnaerMM In',Mic_in_Anaer);

             End;
    End;
    {----------------------------------------------------------------}

Var FA, H2, BuryInKg, SedDesorpInKg: Double;
Begin
  CP := GetStatePointer(NState,StV,Layer);

  So:=0; Des:=0; DepTox:=0; Minrl:=0; Bur:=0; Pred:=0;
  Mic_In_Anaer:=0; Hydr:=0; MM:=0;

  If Eutrophication or AllStates.SetupRec^.BCFUptake or (CP.State=0) then
    dB := 0.0
  else
    Begin
      So := Sorption;     {ug/m2 d}
      Des := Desorption;  {ug/m2 d}

      With AllStates do with ToxLossArray[OrgType] do With Location.Morph do
         Begin {save for 1/2 life calculation}
           SedDesorpInKg := Des  * Location.Locale.SurfArea * 1e-9;
              {kg}         {ug/m2}          {m2}              {kg/ug}
           SedDesorp[DerivStep]     := SedDesorp[DerivStep] + SedDesorpInKg;
         End;

      DepTox := AllStates.CalcDeposition(NState,SVType);  {ug/m2 d}

      PP := GetPPB(NState,SVType,Layer);
      H2 := AllStates.Diagenesis_Params^.H2.Val;

      Minrl := CP.Mineralization * PP   * H2 * 1e-3;
      Bur   := CP.Burial         * PP   * H2 * 1e-3;
    {ug/m2 d}     {g /m3 d}        {ug/kg} {m}  {kg/g}
      With AllStates do with Location.Morph do
        Pred  := CP.Predn        * PP   * SegVolum[VSeg] / SedLayerArea * 1e-3;
      {ug/m2 d} {g OC/m3 w}  {ug tox/kg OC}   {m3}            {m2}       {kg/g}

      With AllStates do with ToxLossArray[OrgType] do With Location.Morph do
         Begin {save for Tox MB Tracking}
           BuryInKg := Bur  * Location.Locale.SurfArea * 1e-9;
              {kg}    {ug/m2}          {m2}              {kg/ug}
           TotalToxLoss[DerivStep] := TotalToxLoss[DerivStep] + BuryInKg;
           OOSBury[DerivStep]      := OOSBury[DerivStep] + BuryInKg;
         End;

      MM           := MicrobialMetabolism(FA);               {anaerobic only}
    {ug/m2 d}
      Mic_in_Anaer := Microbial_BioTrans_To_This_SV(False);  {anaerobic only}
      Hydr         := Hydrolysis;


      dB  :=  So - Des + DepTox - Minrl - Bur - Pred - MM + Mic_In_Anaer
              - Hydr ;  {ug/m2 d}  {input is ug/kg}
    End;

   WriteRates;
End;

{-------------------------------------------------------------------------}

Function TToxics.Depuration: Double;
Var CP : TOrganism;
    Clear: Double;
    ChemOption: UptakeCalcMethodType;
    AlgalP: TPlant;
    AnimP : TAnimal;
    TCR, K2: Double;
Begin
  If not (NState in [FirstBiota..LastBiota]) then Raise EAQUATOXERROR.Create('TToxics.Depuration must be passed a toxicant within an organism');

  Depuration := 0;
  CP:=GetStatePointer(NState,StV,WaterCol);

  If (nstate in [FirstAnimal..LastAnimal]) then
    If (TAnimal(CP).IsLeavingSeg) then exit;

  If (NState in [FirstPlant..LastPlant])
    then
      begin
         ChemOption := ChemPtrs^[SVType].Plant_Method;
         AlgalP:=TPlant(CP);
         If ChemOption = CalcK2
            then K2 := AlgalP.Plant_Tox[SVType].K1 /
                             AlgalP.Plant_Tox[SVType].Entered_BCF
            else K2 := AlgalP.Plant_Tox[SVType].K2;
         If K2>96 then K2 := K2 * (96/k2); {scaling factor 10-02-03}
         Clear := K2 * State;    {passive}
      end
    else
      begin {animal code}
         ChemOption := ChemPtrs^[SVType].Anim_Method;
         AnimP:=TAnimal(CP);

         With AnimP.Anim_Tox[SVType] do
          If (ChemOption = CalcK2) and (not ChemPtrs^[SVType].ChemRec.IsPFA)
            then K2 := Entered_K1 / Entered_BCF
            else K2 := Entered_K2;

         If K2>96 then K2 := K2 * (96/k2); {scaling factor 10-02-03}

         With AnimP.PAnimalData^ do
           TCR := AllStates.TCorr(Q10,TRef,TOpt,TMax);  {TCorrect}

         If ChemOption <> Default_Meth then TCR := 1.0;

         Clear := K2 *   TCR   * State;
       {ug/L d} {1/d} {unitless} {ug/L}

         AnimP.DerivedK2[SVType] := K2;
       end; {animal code}

  If Clear < 0 then Clear := 0;

  Depuration := Clear;
End;

{-------------------------------------------------------------------------}

Procedure TAlgae_ZooTox.Derivative;
{Derivitives for Plants, Animals are sent to AnimalDeriv}
Var HypCp, EpiCp, CP   : TPlant;
    Dep,STH,SFE, BioT_Out, BioT_In, ToxD, OOSDriftInKg, Entr, Flt: Double;
    TD,DiffUp,DiffDown,Pp,WashO, WashI, Lo, Predt, Mort, Sed, Uptake, Exc    : Double;
    Sed2Me, MacBrk, Slgh, LoadInKg : Double;
    SurfaceFloater : Boolean;

    {----------------------------------------------------------------}
    Function ToxToPhytoFromSlough: Double;
    Var PlantLoop: AllVariables;
        PPl: TPlant;
        TPSlough, j: Double;
    Begin
      TPSlough := 0;
      For PlantLoop := FirstAlgae to LastAlgae do
        Begin
          PPl := GetStatePointer(PlantLoop,StV,WaterCol);
          If PPl <> nil then
            If PPl.PSameSpecies^=nstate then
              Begin
                PPl.CalcSlough; {update sloughevent}
                If PPl.Sloughevent then
                  Begin
                    j := -999; {signal to not write mass balance tracking}
                    PPl.Derivative(j); {update sloughing}
                    TPSlough  := TPSlough + PPl.Sloughing * Getppb(PPl.nstate,SVType,WaterCol) * 1e-6 * (1/3);
                    {1/3 of periphyton will go to phytoplankton and 2/3 to detritus with sloughing/Slough.}
                  End;
              End;
        End;
      ToxToPhytoFromSlough := TPSlough;
    End;
    {----------------------------------------------------------------}
     Function ToxSed2Me: Double;
    {Calculates toxicant transfer due to sedimentation of phytoplankton
     to each periphyton compartment JSC Sept 8, 2004}
    Var PPBPhyto: Double;
    Begin
      ToxSed2Me := 0;
      If not CP.IsPeriphyton then exit;
      If CP.PSameSpecies^ = NullStateVar then exit;
      If CP.GetStatePointer(CP.PSameSpecies^,StV,WaterCol)=nil then exit;

      PPBPhyto := GetPPB(CP.PSameSpecies^,SVType,WaterCol);

      ToxSed2Me := CP.SedToMe * PPBPhyto * 1e-6;
        {ug/L}         {mg/L}    {ug/kg}  {kg/mg}
    End;
    {----------------------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Loading',Lo);

          If (carrier in [FirstAlgae..LastAlgae]) and
             (TPlant(GetStatePointer(Carrier,StV,WaterCol)).IsPhytoplankton) then
             Begin
               If Not AllStates.LinkedMode
                then SaveRate('TurbDiff',TD)
                else { If Not AllStates.CascadeRunning then}
                  Begin
                    SaveRate('DiffUp',DiffUp);
                    SaveRate('DiffDown',DiffDown);
                  End;
             End;

          If (carrier in [FirstAlgae..LastAlgae]) and
             (not TPlant(GetStatePointer(Carrier,StV,WaterCol)).IsPhytoplankton) then
             Begin
               SaveRate('ToxDislodge',ToxD);
             End;

          SaveRate('Biotr IN',BioT_in);
          SaveRate('Biotr OUT',BioT_out);

          If NOT (NState in [FirstMacro..LastMacro]) then
            Begin
              SaveRate('Washout',WashO);
              SaveRate('Washin',WashI);
              SaveRate('SinkToHyp',STH);
              SaveRate('SinkFromEp',SFE);
              If SurfaceFloater then SaveRate('Floating',Flt);
              If AllStates.EstuarySegment then SaveRate('Entrainment',Entr);
              SaveRate('NetBoundary',Lo+WashI-WashO+DiffUp+Entr+DiffDown+TD);
             End;

          If (NState in [Firstmacro..LastMacro]) and (TMacrophyte(CP).MacroType=FreeFloat) then
            Begin
              SaveRate('Washout',WashO);
              SaveRate('Washin',WashI);
              SaveRate('NetBoundary',Lo+WashI-WashO+DiffUp+DiffDown+TD);
              SaveRate('Mac Break',MacBrk);
            End;

            Begin
              SaveRate('Uptake',Uptake);
              SaveRate('Mortality',Mort);
              SaveRate('Predation',Predt);
              SaveRate('Depuration',Dep);
              SaveRate('Excretion',Exc);
              If (CP.IsPeriphyton) then
                 SaveRate('Sed to Phyt',Sed2Me);
              If nstate in [FirstAlgae..LastAlgae] then
                Begin
                  SaveRate('Peri Slough',Slgh);
                  SaveRate('Sediment',Sed);
                End;
            End;
        End;
    End;
    {----------------------------------------------------------------}

Begin
 CP := GetStatePointer(Carrier,StV,WaterCol);
 SurfaceFloater := CP.PAlgalRec^.SurfaceFloating;

 WashO:=0;  Lo:=0;  Predt:=0; Mort:=0; Sed:=0; WashI:=0; DiffUp:=0; DiffDown:=0;
 Uptake:=0; Exc:=0; SFE:=0; BioT_Out:=0; BioT_In:=0; TD:=0; ToxD:=0; Entr:=0;
 Sed:=0; MacBrk:=0; Slgh:=0; Sed2Me :=0; Flt := 0;

If not (nstate in [FirstPlant..LastPlant]) then db:= AnimalDeriv
 Else If Eutrophication or AllStates.SetupRec^.BCFUptake or (CP.State=0) then
  dB := 0.0
 else
  if nstate in [FirstMacro..LastMacro] {macrophytes}
    then
     Begin
      BioT_Out :=  BioTransformation;
      BioT_In  :=  BioTrans_To_This_Org;
        begin
          Lo       :=  Loading;
          pp       :=  Getppb(NState,SVType,Layer) * 1e-6;

          WashO    :=  CP.Washout * Pp;
          WashoutStep[AllStates.DerivStep] := WashO * AllStates.SegVol;

            With AllStates do with ToxLossArray[SVType] do With Location.Morph do
             Begin {save for tox loss output & categorization}
               OOSDriftInKg := WashO  {* OOSDischFrac} * SegVol * 1000.0 * 1e-9;
                  {kg}         {ug/L}    {frac}             {m3}         {L/m3}  {kg/ug}
               TotalToxLoss[DerivStep] := TotalToxLoss[DerivStep] + OOSDriftInKg;
               TotalWashout[DerivStep] := TotalWashout[DerivStep] + OOSDriftInKg;
               WashoutPlant[DerivStep] := WashoutPlant[DerivStep] + OOSDriftInKg;
             End;

          WashI    :=  ToxInCarrierWashin;

          With AllStates do with ToxLoadArray[SVType] do
             Begin {save for tox loss output & categorization}
               LoadInKg := (Lo+WashI) * SegVol * 1000.0 * 1e-9;
                  {kg}      {ug/L}       {m3}     {L/m3} {kg/ug}
               TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
               ToxLoadBiota[Derivstep] := ToxLoadBiota[Derivstep] + LoadInKg;
             End;

          Dep      :=  Depuration;
          Uptake   :=  PlantUptake;
          Mort     :=  CP.Mortality * pp ;
          Predt    :=  CP.predation * Getppb(NState,SVType,Layer) * 1e-6 ;
          Exc      :=  CP.PhotoResp * pp ;
          MacBrk   :=  TMacrophyte(CP).Breakage * pp;

          dB       :=  Lo + Uptake - Dep - (Predt + Mort + Exc + MacBrk) - BioT_Out + BioT_In - WashO + WashI
        end
     End
  else if nstate in [FirstAlgae..LastAlgae] then
    Begin
      Pp := GetPPB(NState,SVType,Layer) * 1e-6;
      WashO := CP.Washout * Pp;
      WashoutStep[AllStates.DerivStep] := WashO * AllStates.SegVol;

      With AllStates do
        If (TPlant(CP).IsPhytoplankton) and EstuarySegment
          then Begin
                 Entr := EstuaryEntrainment;
                 If Entr<0 then Entr := Entr * pp;
                 If Entr>0 then Entr := Entr * HypoSegment.GetPPB(NState,SVType,Layer) * 1e-6;
               End;

      With AllStates do with ToxLossArray[SVType] do With Location.Morph do
         Begin {save for tox loss output & categorization}
           If Entr<0 then OOSDriftInKg := (-Entr+WashO)  {* OOSDischFrac} * SegVol * 1000.0 * 1e-9
                     else OOSDriftInKg := (    WashO  )  {* OOSDischFrac} * SegVol * 1000.0 * 1e-9;
                               {kg}            {ug/L}       {frac}        {m3}    {L/m3}  {kg/ug}
           TotalToxLoss[DerivStep] := TotalToxLoss[DerivStep] + OOSDriftInKg;
           TotalWashout[DerivStep] := TotalWashout[DerivStep] + OOSDriftInKg;
           WashoutPlant[DerivStep] := WashoutPlant[DerivStep] + OOSDriftInKg;
         End;

      WashI := ToxInCarrierWashin;
      Lo := Loading;

      With AllStates do with ToxLoadArray[SVType] do
         Begin {save for tox loss output & categorization}
           If Entr>0 then LoadInKg :=  (Lo+Entr+WashI) * SegVol * 1000.0 * 1e-9
                     else LoadInKg :=  ( Lo+WashI)     * SegVol * 1000.0 * 1e-9;
                          {kg}       {ug/L}               {m3}     {L/m3} {kg/ug}
           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           ToxLoadBiota[Derivstep] := ToxLoadBiota[Derivstep] + LoadInKg;
         End;

      STH    := CP.SinkToHypo * Pp;
      With AllStates do
        If VSeg=Hypolimnion then
           Begin
             EpiCP := EpiSegment.GetStatePointer(Carrier,StV,WaterCol);  {Refinement 10-20-2002 JSC}
             SFE := EpiCP.SinkToHypo * EpiSegment.GetPPB(nstate,SVType,WaterCol)* 1e-6;
           End;

      If SurfaceFloater then
       If AllStates.Stratified then
        Begin
          Flt := CP.Floating * Pp;
          With AllStates do
            If VSeg=Epilimnion then
               Begin
                 HypCP := HypoSegment.GetStatePointer(Carrier,StV,WaterCol);
                 Flt := HypCP.Floating * HypoSegment.GetPPB(nstate,SVType,WaterCol)* 1e-6;
               End;
        End;


      BioT_Out :=  BioTransformation;
      BioT_In  :=  BioTrans_To_This_Org;

      Predt  := CP.Predation * Pp;
      Mort   := CP.Mortality * Pp;
      Exc    := CP.PhotoResp * Pp;

      ToxD   := CP.ToxicDislodge * Pp;

      Sed    := CP.Sedimentation * Pp; {plant sedimentation}
      Sed2Me := ToxSed2Me;
      If (CP.IsPeriphyton)
        then Slgh := CP.Sloughing * pp
        else Slgh := - ToxToPhytoFromSlough;

      Uptake := PlantUptake;
      Dep    := Depuration;

      dB := Lo + Uptake - Dep + WashI - (WashO + Predt + Mort + Sed + Exc + ToxD + Slgh)
            - BioT_Out + BioT_In - STH + SFE + Flt + Sed2Me + Entr;


    End {algae};

  {Phytoplankton are subject to currents }
  With TPlant(GetStatePointer(Carrier,StV,WaterCol)).PAlgalRec^ do
   If (carrier in [FirstAlgae..LastAlgae]) and (PlantType='Phytoplankton') and (Not SurfaceFloating)
       then Begin
              If Not AllStates.LinkedMode then TD := ToxDiff
                                else If Not AllStates.CascadeRunning then
                                     Begin
                                       DiffUp := ToxSegDiff(True);
                                       DiffDown := ToxSegDiff(False);
                                     End;
              dB := dB + TD + DiffUp + DiffDown;
            End;

  If nState in [FirstPlant..LastPlant] then
    Begin
      WriteRates;
    End;
end;

{---------------------------------------------------------------------------}

Procedure TFishTox.Derivative;

begin
  dB:= AnimalDeriv;  {no turb diff for fish}
end;

