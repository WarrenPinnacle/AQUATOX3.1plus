//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
{BF Misc methods moved from Plant.pas 6/30/94 }

constructor TPlant.Init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                        IC : double; IsTempl: Boolean);
Var ToxLoop: T_SVType;
    SVTempl: TStateVariable;

begin
   SVTempl := Nil;
   If Not IsTempl then SVTempl := P.PStatesTemplate.GetStatePointer(NS,SVT,WaterCol);

   If IsTempl then Begin
                     New(PAlgalRec);
                     fillchar(PAlgalRec^,SizeOf(PAlgalRec^),0);
                     New(PSameSpecies);
                     PSameSpecies^:=NullStateVar;
                   End
              else Begin
                     PAlgalRec:=TPlant(SVTempl).PAlgalRec;
                     PSameSpecies := TPlant(SVTempl).PSameSpecies;
                   End;

   Inherited Init(Ns,SVT,aName,P,IC, IsTempl); {TOrganism}

   PRequiresData^ := True;
   MortRates.OtherMort := 0;
   MortRates.SaltMort  := 0;
   For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
        MortRates.OrgPois[ToxLoop] := 0;

end;

destructor TPlant.Destroy;
begin
   If IsTemplate then
     Begin
       Dispose(PAlgalRec);
       Dispose(PSameSpecies);
     End;  

   Inherited Destroy;
end;

Function TPlant.PHabitat_Limit: Double;

Var HabitatAvail, PctRun, PrefRun: Double;
Begin
  PHabitat_Limit := 1.0;
  If Location.SiteType <> Stream then exit;

  With Location.Locale do With PAlgalRec^ do
    Begin
      PctRun := 100 - PctRiffle - PctPool;
      PrefRun := 100 - PrefRiffle - PrefPool;

      HabitatAvail := 0;
      if PrefRiffle>0 then HabitatAvail := HabitatAvail + PctRiffle/100;
      if PrefPool>0   then HabitatAvail := HabitatAvail + PctPool/100;
      if PrefRun>0    then HabitatAvail := HabitatAvail + PctRun/100;
    End;

  PHabitat_Limit := HabitatAvail;
End;

Procedure  TPlant.ChangeData;
begin
{Modify THE UNITS WHICH CHANGE WITH PLANT TYPE}
    If (IsPhytoplankton)
    then begin StateUnit:='mg/L dry';
               LoadingUnit:='mg/L dry';
         end
    else begin StateUnit:='g/m2 dry';
               LoadingUnit:='g/m2 dry';
         end;

    If PAlgalRec^.PlantType='Macrophytes' then
      Begin
        If PAlgalRec^.Macrophyte_Type='benthic'
          then MacroType := benthic
          else If PAlgalRec^.Macrophyte_Type='free-floating'
            then MacroType := freefloat
            else If PAlgalRec^.Macrophyte_Type='rooted floating'
              then MacroType := rootedfloat
              else MessageDlg('Warning:  Macrophyte '+PName^+' has an unrecognized type!',mtwarning,[mbok],0);
      End;
end;

{------------------------------------------------------------------------}
Procedure TPlant.Assign_Plant_Tox;
Var FoundToxIndx, i: Integer;
    PTR: TPlantToxRecord;
    ToxLoop: T_SVType;
    DataName: String;
Begin
 DataName:=Lowercase(PAlgalRec.ToxicityRecord);

 FOR TOXLOOP := FirstOrgTxTyp to LastOrgTxTyp do
  If GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol)<> nil then
   Begin
      FoundToxIndx:=-1;   // 10/27/2009

      For i:=0 to ChemPtrs^[ToxLoop].Plant_Tox.Count-1 do
         Begin
           PTR := ChemPtrs^[ToxLoop].Plant_Tox.At(i);
           If Lowercase(PTR.Plant_Name)=DataName then FoundToxIndx:=i;
         End;

       If FoundToxIndx=-1 Then Raise EAquatoxError.Create('Error!  '+OutputText(NState,SVType,watercol,'',False,False,0)+' uses the toxicity record "'
               + dataname + '" which is not found in chemical '+ChemPtrs^[ToxLoop].ChemRec.ChemName  + '''s Plant toxicity data.  Study cannot be executed.');

       PTR:= ChemPtrs^[ToxLoop].Plant_Tox.At(FoundToxIndx);

       Plant_Tox[ToxLoop]:=PTR;
   End;
End;


Function TPlant.WetToDry: Double;
Begin
  WetToDry := PAlgalRec^.Wet2Dry;
End;

Function TPlant.AggregateFracPhoto: Double;
Var ToxLoop: T_SVType;
    AggFracPhoto: Double;
Begin
  AggFracPhoto := 0;
  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
    If GetStatePointer(NState,ToxLoop,WaterCol) <> nil then
       AggFracPhoto := AggFracPhoto + (1-FracPhoto[ToxLoop]);
  If AggFracPhoto > 1.0 then AggFracPhoto := 1.0;
  AggFracPhoto := (1.0-AggFracPhoto);

  AggregateFracPhoto := AggFracPhoto;
End;


function TPlant.Photosynthesis : double;
var Photosyn, Substrate: double;
    PPL   : Double;
    Macro : AllVariables;
    MacroBiomass, MacroArea : Double;
    PMacro : Pointer;
    Salteffect : Double;
begin
    with pAlgalRec^ do begin
      If (PlantType='Phytoplankton')
        then Photosyn := PMax * PProdLimit * State
             {g/cu m-d   1/d    unitless     g/cu m }
        else With Location do
          begin {benthic}
             MacroBiomass := 0;  MacroArea := 0;
             For Macro := FirstMacro to LastMacro do
               begin
                 PMacro:=GetStatePointer(Macro,StV,WaterCol);
                 If PMacro <>nil then
                   MacroBiomass := MacroBiomass + GetState(Macro,StV,WaterCol);
               end;
             If IsPeriphyton
               then MacroArea := 0.12 * MacroBiomass;
            Substrate := FracLittoral(AllStates.ZEuphotic,AllStates.Volume_Last_Step) + MacroArea;
            PPL := PProdLimit;
            Vel_Limit := VLimit;
            Photosyn :=  PMax  * PPL  * Vel_Limit * State * Substrate;
            {g/m3-d      1/d   unitless  unitless   g/m3    unitless}
          end;

      SaltEffect := AllStates.SalEffect(Salmin_Phot,SalMax_Phot,Salcoeff1_Phot,Salcoeff2_Phot);
      Photosynthesis := Photosyn * HabitatLimit * SaltEffect;
    end; {with}
end; { Photosynthesis }


(*********************************)
(* algal excretion due to photo- *)
(* respiration, Desormeau, 1978  *)
(*********************************)
Function TPlant.PhotoResp : double;
var Excrete,LightStress : double;
{const      actually = KResp
     KStress = 0.03; }  {not 3.0; RAP 9/5/95}
begin
 with PAlgalRec^ do begin
  LightStress := 1.0 - LtLimit(AllStates.PModelTimeStep^);
  If LightStress < Small then LightStress := 0.0;
  {RAP, 9/7/95, KResp should be mult. by LightStress - see Collins et al., 1985}
  Excrete:= Photosynthesis * (KResp  {+ KStress} * LightStress);
  {g/cu m-d  g/cu m-d         unitless unitless     unitless  }
  PhotoResp := Excrete;
 end;
end; { algalexcr }

(***********************************)
(* dark respiration, Collins, 1980 *)
(***********************************)
Function TPlant.Respiration : double;
(*var
   Resp0,
   Resp,
   RespMax    : Double;  {RAP, 9/18/95}
const
   TResp = 0.065;  {Collins, 1980}
begin
 Resp0 := 0.006;
 with PAlgalRec^ do begin
   Case NState of
     FirstDiatom..LastDiatom  : Resp0 := 0.022;  {LeCren & Lowe-McConnell '80, p. 189}
     FirstGreens..LastGreens   : Resp0 := 0.006;  {LeCren & Lowe-McConnell '80, p. 189}
     FirstBlGreen..LastBlGreen : Resp0 := 0.072;  {Collins, 1980}
     FirstMacro..LastMacro    : Resp0 := 0.015;  {LeCren & Lowe-McConnell '80, p. 195}
     OtherAlg1,OtherAlg2     : Resp0 := 0.006;  {The same as greens for the time being RAP 11/2/98}
    end; {case}

   Resp := Resp0 * exp(TResp * GetState(Temperature,StV,WaterCol)) * State;
   {g/cu m-d      g/g-d         1/C                       C               g/cu m}
   RespMax := 0.6 * Photosynthesis;   {direct Function of growth rate: Harris, '86, p. 172}
   if Resp > RespMax then        {RAP, 9/18/95, constrain}
     Respiration := RespMax
   else
     Respiration := Resp;
   end;
 end; { algalrespire } *)

 Var Temp: Double;
 begin
   Temp := GetState(Temperature,StV,WaterCol);

   Respiration := PAlgalRec^.Resp20 * POWER(1.045,(Temp-20)) * State;
                      {g/g day}          {1/C}   {deg C}     {g/cu m}

 end; { algalrespire }


(*****************************************************************)
(* algal mortality due to low nutrients,  subopt light & high T  *)
(* ExcessT: Scavia & Park, 1977; Stress: Collins & Park, 1989    *)
(*****************************************************************)
Function TPlant.Mortality : Double ;
Var ExcessT, Dead, Stress : Double;
    Pois                  : Double;
    ToxLoop               : T_SVType;
    WaterTemp             : Double;
Begin
  WaterTemp := GetState(Temperature,StV,WaterCol);

  With PAlgalRec^ do
    Begin
      If WaterTemp > TMax
        then ExcessT := 1.0                               {6-12-2006 Fixed Logic}
        else ExcessT := EXP(WaterTemp - TMax) / 2.0;

      Stress :=   (1.0 - EXP(-EMort * (1.0 - (NutrLimit * LtLimit(TSDAILY)))));
                            { emort is approximate maximum fraction killed }
                            { per day by nutrient and light limitation     }


      Dead                := (KMort + ExcessT + Stress) * State;
     {g/cu m-d               (        g/g-d           )   g/cu m}
      MortRates.OtherMort := Dead;
    End;

   With PAlgalRec^ do
     MortRates.SaltMort := State * SalMort(Salmin_Mort,SalMax_Mort,Salcoeff1_Mort,Salcoeff2_Mort);
   Dead := Dead + MortRates.SaltMort;
   {g/cu m-d                g/cu m-d }
   
   For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
    If GetState(AssocToxSV(ToxLoop),StV,WaterCol)>0 then
     Begin
       Pois := Poisoned(ToxLoop);
       MortRates.OrgPois[ToxLoop] := Pois;
       Dead := Dead + Pois;
     End;

   If Dead > State then Dead := State;

   Mortality := Dead;

End; { mortality }

Function TStates.DensityFactor(KSTemp,KSSalt: Double): Double;

         Function WaterDensity(Reference: Boolean): Double;
         Var Salt,Temp: Double;
         Begin
           If Reference
             then Begin
                    Temp := KSTemp;
                    Salt := KSSalt;
                  End
             else Begin {ambient}
                    Temp := GetState(Temperature,StV,WaterCol);
                    Salt := GetState(Salinity,StV,WaterCol);
                  End;
           WaterDensity := 1 + (1E-3 * (28.14 - (0.0735 * Temp) - (0.00469 * SQR(Temp)) +
                                       (0.802 - ( 0.002* Temp)) * (Salt - 35) ))
         End;
Begin
  If GetStatePointer(Salinity,StV,WaterCol)=nil
    then DensityFactor := 1
    else DensityFactor := WaterDensity(True) / WaterDensity(False);
End;

Function TPlant.IsPeriphyton: Boolean;
Begin
  IsPeriphyton := PAlgalRec^.planttype = 'Periphyton';
End;

Function TPlant.IsPhytoplankton: Boolean;
Begin
  IsPhytoplankton := PAlgalRec^.planttype = 'Phytoplankton';
End;


Function TPlant.IsLinkedPhyto: Boolean;
Var PLoop: AllVariables;
    PPeri: TPlant;
Begin
  IsLinkedPhyto := False;
  If PAlgalRec^.PlantType <> 'Phytoplankton' then exit;

  For PLoop := FirstAlgae to LastAlgae do
    Begin
      PPeri := GetStatePointer(PLoop,Stv,WaterCol);
      If PPeri <> nil then
         If (PPeri.IsPeriphyton) and
            (PPeri.PSameSpecies^ = nstate)
              then Begin
                     IsLinkedPhyto := True;
                     Exit;
                   End;
    End;
End;

Function TPlant.SedToMe : Double ;
{Calculates sedimentation of phytoplankton to each periphyton compartment}
{JSC Sept 8, 2004}
Var ploop: AllVariables;
    PPeri, PPhyto: TPlant;
    LinkCount: Double;
    LinkMass : Double;
Begin
  SedToMe := 0;
  If Not IsPeriphyton then exit;
  If PSameSpecies^ = NullStateVar then exit;
  If GetStatePointer(PSameSpecies^,StV,WaterCol)=nil then exit;

  LinkCount := 0; LinkMass := 0;
  For ploop := FirstAlgae to LastAlgae do
    Begin
      PPeri := GetStatePointer(PLoop,Stv,WaterCol);
      If PPeri <> nil then
         If (PPeri.IsPeriphyton) and
            (PPeri.PSameSpecies^ = PSameSpecies^)
              then Begin
                     LinkCount := LinkCount + 1.0;
                     LinkMass  := LinkMass + PPeri.State;  {mg/L}
                   End;
         {will count itself and any other periphyton species linked to this phytoplankton}
    End;

  PPhyto := GetStatePointer(PSameSpecies^,Stv,WaterCol);
  If PPhyto=nil then exit;

  If LinkMass<VSmall   {If no periphyton mass, dist. evenly among all periphyton comps.  9/20/04}
    then SedtoMe := PPhyto.Sedimentation / LinkCount
    else SedtoMe := PPhyto.Sedimentation * (State / LinkMass);
                                             {mg/L}    {mg/L}
End;


(**************************************)
(*       loss due to sinking          *)
(**************************************)

Function TPlant.Sedimentation : Double ;
Var SedAccel, Sink, Thick, Decel, DensFactor: Double;
    TopCohesive: TBottomSediment;
Begin
 Sedimentation:=0;
 SinkToHypo:=0;

  Thick := Location.MeanThick[AllStates.VSeg];

  If not (IsPhytoplankton) then exit;
  If PAlgalRec^.SurfaceFloating then exit;

  With PAlgalRec^ do
    Begin
      SedAccel := EXP(ESed * (1.0 - PProdLimit)); {Collins & Park, 1989}

      DensFactor := AllStates.DensityFactor(KSedTemp,KSedSalinity) ;

      If AllStates.EstuarySegment
        then Sink := KSed / Thick * DensFactor * SedAccel * State
             {g/cu m-d   m/d    m     unitless   unitless   g/cu m}
        else
          Begin
            {unitless       unitless       unitless    }
            If AllStates.MeanDischarge < Tiny
               Then Sink := KSed/ Thick * SedAccel * State * DensFactor
                {g/cu m-d   m/d    m      unitless   g/cu m    unitless}
               Else
                 Begin {calculate Decel}
                   If AllStates.SedModelIncluded
                     Then
                       Begin
                         TopCohesive := (GetStatePointer(Cohesives,StV,SedLayer1));
                         With TopCohesive do
                           If (Scour=0) and (Deposition=0)
                             then Decel := 0
                             else If (Deposition > Scour)
                               then Decel := 1
                               else Decel := Deposition / Scour;
                       End
                     Else
                       Begin {No SedModel Included}
                         If Location.TotDischarge > AllStates.MeanDischarge
                            then Decel := AllStates.MeanDischarge/(Location.TotDischarge {+ 0.001})
                                     {            cu m/d                           cu m/d          }
                            else Decel := 1;
                       End;

                   Sink := KSed/Thick * SedAccel * State * Decel * DensFactor;
                 End; {MeanDisch > Tiny}

            If Not AllStates.SedModelIncluded
              Then If (GetState(WindLoading,StV,WaterCol) >= 2.5) {m/sec} and (Thick <= 1.0)
                Then Sink := 0.0; {should be a power fn. of wind & depth}

          End; {if Not EstuarySegment}
    End; {With PAlgalRec}

   If (not AllStates.Stratified) or (AllStates.Vseg=Hypolimnion) then Sedimentation:=Sink
     else
       begin  {stratified}
         With AllStates do with Location do with Locale do 
           If not UseBathymetry then SinkToHypo := (ThermoclArea / SurfArea) * Sink
                                else SinkToHypo := (1-AreaFrac(MaxEpiThick, ZMax)) * Sink;   //10-14-2010 Note that ZMax parameter pertains to both segments in event of stratification

         Sedimentation := Sink-SinkToHypo;
       end;

End; (* sedimentation *)

(*************************************)
(*      Sinking From Hypolimnion     *)
(*************************************)

Function TOrganism.SinkFromEp: Double;
Var SFE: Double;
    EpiVol, HypVol: Double;
Begin
  With AllStates do
   If not Stratified or (VSeg=Epilimnion) Then SFE := 0
   Else
     Begin
       SFE := TPlant(EpiSegment.GetStatePointer(nstate,StV,WaterCol)).SinkToHypo;
                                                                        {g/m3 epi}
       EpiVol := EpiSegment.SegVol;
       HypVol := SegVol;
       SFE := SFE * EpiVol / HypVol;
     End;

  SinkFromEp := SFE;
  {g/m3 hypo}

End;


Function TPlant.Floating: Double;
Var FFH: Double;  //float from hypolimnion
    EpiVol, HypVol: Double;
Begin
  Floating := 0;
  If not PAlgalRec^.SurfaceFloating then exit;
  If not AllStates.Stratified then exit;

  With AllStates do
   If VSeg=Hypolimnion
     then Floating := -State  // all surface floating phytoplankton to epilimnion
     else Begin {epilimnion code}
            FFH := TPlant(HypoSegment.GetStatePointer(nstate,StV,WaterCol)).State;
                                                                         {g/m3 hyp}
            EpiVol := SegVol;
            HypVol := HypoSegment.SegVol;
            Floating := FFH * HypVol / EpiVol;
          {g/m3 epi} {g/m3 hyp}
          End;

End;


(******************************************)
(* Sloughing & washout, last mod. 3/19/03 *)
(******************************************)

Function TPlant.ToxicDislodge: Double;
Var  ToxLevel, Dislodge : double;
            ToxLoop: T_SVType;
Const     MaxToxSlough = 0.1; {10% per day}
Begin
  Dislodge:=0;

  If (not IsPhytoplankton) then
    For ToxLoop:= FirstOrgTxTyp to LastOrgTxTyp do
     If Plant_Tox[ToxLoop]<>nil then With Plant_Tox[ToxLoop] do
      If EC50_Dislodge > Tiny then
        Begin
          ToxLevel  := GetState(AssocToxSV(ToxLoop),StV,WaterCol); {evaluates to -1 if tox not in study}
          if ToxLevel > 0
             then Dislodge := Dislodge + MaxToxSlough * ToxLevel/(ToxLevel + EC50_Dislodge) * State;   {Toxicant Induced Dislodge}
                  {g/m3 d}    {g/m3 d}     {10% / d}   {ug/L}     {ug/L}        {ug/L}       {g/m3}
        End;

  If Dislodge>State then Dislodge := State;
  ToxicDislodge := Dislodge;
 {g/m3 d            g/m3 d}
End;

Function TPlant.CalcSlough: double;

const     UnitArea = 1.0; {mm2}
          DragCoeff =  2.53E-4; {unitless, suitable for calibration because little exposure; 0.01 in Asaeda & Son, 2000}
          Rho = 1000; {kg/m3}
          CellArea_Fil = 5.0E-10; CellArea_Dia = 6.0E-11; {m2}
Const     RefDischarge = 3.5;  {cu m/d in flume}
          MINBIOMASS = 0 {mg/L}; {1e-6} {DISABLED}
Var       Wash,
          Biovol_Fil, Biovol_Dia : Double;
          DragForce : Double; {Newtons}
          AvgVel, DailyVel, Nutr, LtL: Double;
          Suboptimal: Double;
          Adaptation: Double;
Begin
  Wash := 0;
 {mg/L d}

  Nutr := NutrLim_Step;  LtL := LtLimit(TSDAILY);
  with PAlgalRec^, Location.Locale do
    Suboptimal :=  Nutr * LtL * AllStates.TCorr( Q10, TRef, TOpt, TMax) * 20;  {5 to 20 RAP 1-24-05}
  If Suboptimal > 1 then Suboptimal := 1;
    {uses nutrlimit calculated at the beginning of this time-step}

  If (not IsPhytoplankton) then
        begin {not floating, calculate slough & scour}
          Biovol_Fil := State/8.57E-9 * AllStates.DynamicZMean; {mm3/mm2}
          Biovol_Dia := State/2.08E-9 * AllStates.DynamicZMean; {mm3/mm2}

          With PAlgalRec^ do
            AvgVel := AllStates.Velocity(PrefRiffle,PrefPool,TRUE) * 0.01;  {Avg. Velocity exposure of this organism}
            {m/s}               {cm/s}                      {avg}   {m/cm}
          With PAlgalRec^ do
            DailyVel := AllStates.Velocity(PrefRiffle,PrefPool,FALSE) * 0.01;  {Avg. Velocity exposure of this organism}
            {m/s}                {cm/s}                         {avg}   {m/cm}

          If not (Location.SiteType = Stream) then AvgVel:=0.003; {based on KCap of 200 g/m2}
          Adaptation := Sqr(AvgVel)/0.006634;  {RAP 1/20/2005}

          If not Sloughevent then {check to see if sloughevent should be initiated}
           Begin
            If NState in [FirstDiatom..LastDiatom]
             then    {Periphyton -- Diatoms }
                 Begin
                   DragForce := Rho * DragCoeff * SQR(DailyVel) * POWER(Biovol_Dia * UnitArea,2/3)* 1E-6;
                   {kg m/s2}  {kg/m3} {unitless}          {m/s}           {mm3/mm2}       {mm2}  {m2/mm2}
                   if (Adaptation > 0) and (PAlgalRec^.FCrit > Tiny) and (State>MINBIOMASS) and  //3/19/2013 fcrit of zero means no scour
                      (DragForce > Suboptimal * PAlgalRec^.FCrit * Adaptation) then
                      Begin             {frac living}
                        SloughEvent := True;
                        With PAlgalRec^ do
                          SloughLevel := State * (1- (PctSloughed/100));
                        AllStates.ProgData.SloughDia := True;
                        AllStates.ProgData.PeriVis := True;
                      End;
                 End
             else  {filamentous (includes greens and blgreens and should not be confused
                                 with filamentous phytoplankton)}
                 Begin
                   DragForce := Rho * DragCoeff * SQR(DailyVel) * POWER((Biovol_Fil * UnitArea),2/3)* 1E-6;
                   {kg m/s2}  {kg/m3} {unitless}        {m/s}           {mm3/mm2}       {mm2}      {m2/mm2}
                   if (Adaptation > 0) and (PAlgalRec^.FCrit > Tiny) and (State>MINBIOMASS) and  //3/19/2013 fcrit of zero means no scour
                      (DragForce > Suboptimal * PAlgalRec^.FCrit * Adaptation) then
                      Begin
                        SloughEvent := True;
                        With PAlgalRec^ do
                          SloughLevel := State * (1- (PctSloughed/100));
                        AllStates.ProgData.PeriVis := True;
                        With AllStates do
                          If nstate in [FirstGreens..LastGreens] then ProgData.SloughGr := True
                                                                 else ProgData.SloughBlGr := True;
                      End;
                 End;
           End; {If Not Sloughevent} 

{          If SloughEvent then
              Begin
                If (State>SloughLevel) and (State>MINBIOMASS)
                  then Wash := State-(SloughLevel/2)
                  else Begin
                         SloughEvent := False;
                         With AllStates do
                           If nstate in [FirstGreens..LastGreens] then ProgData.SloughGr   := False else
                           If nstate in [FirstDiatom..LastDiatom] then ProgData.SloughDia  := False
                                                                  else ProgData.SloughBlGr := False;

                       End;
              End; {if sloughevent}

        end; {if not phytoplankton}

  CalcSlough := Wash;
  {g/m3 d}
End;  {Function Sloughing}

Function TPlant.Washout : double ;
Var Wash, SegVolume, Disch : double;
Begin
  SegVolume := AllStates.SegVol;
  Wash := 0;
  Washout := 0;
  Disch := Location.Discharge[AllStates.VSeg];
  If Disch=0 then exit;

  If (IsPhytoplankton)
      then
        Begin {Phytoplankton Code}
          With AllStates do With Location.Locale do
             Begin
               Wash :=  Disch  / SegVolume * State;
              {g/cu m-d}  {cu m/d}   {cu m}    {g/cu m}

               If Disch<tiny
                 then ResidenceTime := 999999
                 else ResidenceTime := SegVolume  / Disch * PhytoResFactor;
                        {days}           {cu m}    {cu m/ d}   {unitless}
             End
        End; {end Phytoplankton Code}

  Washout := Wash;
  {g/m3 d}
  WashoutStep[AllStates.DerivStep] := Wash * AllStates.SegVol;
End;  {Function Washout}



Function TPlant.KCAP_in_g_m3 : double;
Var EpiBenthicArea: Double;
Begin
  With AllStates do
    If (not stratified) or (linkedmode)
      then KCAP_in_g_m3 := PAlgalRec^.CarryCapac / StaticZMean   {note, deeper sites have lower g/m3 KCAP}
              {g/m3}                     {g/m2}        {m}
      else
        Begin  {carrying capacity must be split up based on epi benthic area, like the vars are}
          If VSeg=Hypolimnion then EpiBenthicArea := EpiSegment.BenthicArea
                              else EpiBenthicArea := BenthicArea;
          KCap_in_g_m3 := PAlgalRec^.CarryCapac * (1-EpiBenthicArea) / InitMeanThick;
            {g/m3}        {g/m2}                         {frac}              {m}
        End;

End;




{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}
{Macrophyte Specific Code}

Function TMacrophyte.Breakage: double;
(*******************************************)
{* breakage term for macrophytes 10-5-2001 *}
(*******************************************)
Const  Gradual = 20;  {JSC via RAP 11-05-2002}
Var Vel: Double;
Begin
  
  With PAlgalRec^ do
    Vel := AllStates.Velocity(PrefRiffle,PrefPool,False);
    
  If Vel >= PAlgalRec^.Macro_VelMax     {11/9/2001 constrain breakage so does not exceed "state"}
    then Breakage := State
    else Breakage := State * (exp((Vel - PAlgalRec^.Macro_VelMax )/Gradual));
  {mg/L d}    {mg/L}              {cm/s}                 {cm/s}    {cm/s}
end;

Function TMacrophyte.Mortality: double;
Var Dead, Pois {, HgPois}: Double;
    ToxLoop: T_SVType;
Begin
  with PAlgalRec^ do
   Dead:= (1-exp(-EMort*(1-AllStates.TCorr(Q10, TRef, TOpt, TMax)))) * State + (KMort * State);
  {emort is approximate maximum fraction killed per day by suboptimal temp.}

  MortRates.OtherMort := Dead;

  With PAlgalRec^ do
  MortRates.SaltMort := State * SalMort(Salmin_Mort,SalMax_Mort,Salcoeff1_Mort,Salcoeff2_Mort);
  Dead := Dead + MortRates.SaltMort;

  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
   If GetState(AssocToxSV(ToxLoop),StV,WaterCol)>0 then
    Begin
      Pois := Poisoned(ToxLoop);
      MortRates.OrgPois[ToxLoop] := Pois;
      Dead := Dead + Pois;
    End;

  If Dead > State then Dead := State;

  Mortality := Dead;
End; { TMacrophyte.Mortality }


Function TMacrophyte.Photosynthesis : double;
var LL,NL,Photosyn,FracLit : Double;
    TCorrValue, AggFP      : Double;
    SaltEffect   : Double;

Begin
  With PAlgalRec^ do
    Begin

      If (PlantType='Bryophytes') or (MacroType = freefloat)
                                  then NL := NutrLimit    {JSC 8-12-2002}
                                  else NL := 1.0;

      {floating macrophytes are not subject to light limitation}
      If (MacroType=benthic) then LL := LtLimit(AllStates.PModelTimeStep^)
                             else LL := 1.0;

      TCorrValue := AllStates.TCorr(Q10, TRef, TOpt, TMax);
      AggFP := AggregateFracPhoto;

      Temp_Limit := TCorrValue; {save for rate output  JSC 9-5-02}
      Chem_Limit := AggFP;      {save for rate output  JSC 9-5-02}

      Photosyn := PMax * NL    *   LL   * TCorrValue
      {g/sq m-d   1/d   unitless unitless unitless  }
                     * AggFP  * State;
                    { unitless  g/sq m }

      SaltEffect := AllStates.SalEffect(Salmin_Phot,SalMax_Phot,Salcoeff1_Phot,Salcoeff2_Phot);

      {frac littoral limitation applies to benthic and rooted floating macrophytes only}
      FracLit := Location.FracLittoral(AllStates.ZEuphotic,AllStates.Volume_Last_Step);
      If (MacroType<>freefloat)
        then Photosynthesis := SaltEffect *FracLit * Photosyn * HabitatLimit
        else Photosynthesis := SaltEffect *Photosyn * HabitatLimit;

    End; {with}
End; { Photosynthesis }

{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}
Function TPlant.PAR_OD(Light: Double): Double;
{ photosynthetically active radiation at optimum depth  8/22/2007 }
Var EX, PAR: Double;
Begin
  PAR := Light * 0.5;
  With AllStates do
  EX:=AllStates.Extinct(IsPeriphyton,True,True,False,WellMixed and Stratified and LinkedMode  );
       {don't include cyanobacteria self shading effects because result is used for LtAtTop and LtAtDepth}
  PAR_OD := PAR * EXP(-EX * ZOpt);  {TPlant.ZOpt Set at Initial Condition in TStates.SetStatesToInitConds}
End;                 {1/m}   {m}

{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}
Function TPlant.LightSat: Double;  {Aug 16, 2007, Light Saturation including Adaptive Light}
Var LightSatCalc: Double;
    LightHist: Array[1..3] of Double;  {light 1 2 and 3 calendar days before TPresent}

    Procedure LightHistory;
    Var i, index: Integer;
        LightVal: TSVConc;
        n: array[1..3] of Integer;
        PL: TLight;
    Begin
      For i := 1 to 3 do
        Begin
          LightHist[i] := 0;
          n[i] := 0;
        End;

      With AllStates.PLightVals do
        For i:=0 to Count-1 do
          Begin
            LightVal := At(i);
            index := Trunc(AllStates.TPresent) - Trunc(LightVal.Time-0.001);
            {-.001 fixes issue in which values time-stamped exactly at midnight refer to average light the previous day}

            If index in [1..3] then
              Begin
                If n[index] = 0 then
                   LightHist[index] := PAR_OD(LightVal.SVConc);
                                     { photosynthetically active radiation at optimum depth based on hist. light }
                Inc(n[index]);  {count incidences to ensure record exists}
              End;
          End;

      {if inadequate history exists, fill in historical values with more recent values}
      If n[1] = 0 then
                    Begin
                      PL := GetStatePointer(Light,StV,WaterCol);
                      LightHist[1] := PAR_OD(PL.DailyLight);
                      { photosynthetically active radiation at optimum depth based on current daily light}
                    End;
      If n[2] = 0 then LightHist[2] := LightHist[1];
      If n[3] = 0 then LightHist[3] := LightHist[2];
    End;

Begin
  If not PAlgalRec^.UseAdaptiveLight then
    Begin
      LightSat := PAlgalRec^.EnteredLightSat;
      Exit;
    End;

  LightHistory;

  {calculation}
  LightSatCalc := (0.7*LightHist[1] + 0.2*LightHist[2] + 0.1*LightHist[3]);  {8-20-07}

  {ensure calculation is within limits, 8-28-2007}
  If LightSatCalc < PAlgalRec^.MinLightSat then LightSatCalc := PAlgalRec^.MinLightSat;
  If LightSatCalc > PAlgalRec^.MaxLightSat then LightSatCalc := PAlgalRec^.MaxLightSat;

  Result := LightSatCalc;
End;

{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=}

{light limitation at top}
Function TPlant.LtAtTop(TS:TimeStepType) : double;
Var LightVal,LT,EX,DTop,LightCorr : Double;
    Incl_Periphyton: Boolean;
    PL: Tlight;

Begin
  {Floating Macrophytes not subject to light limitation, this function is never executed for them}

  Incl_Periphyton := not (IsPhytoplankton);

  DTop := AllStates.DepthTop;  {m}

  If (DTop=0) then Ex := 0 {avoid irrelevant calculation}
              else Begin
                     IF AllStates.EpiSegment <> nil  {8/17/07, use extinction from Epilimnion Segment}
                       then Ex := AllStates.Episegment.Extinct(Incl_Periphyton,True,True,False,False)
                       else Raise EAQUATOXError.Create('LtAtTop Error, DepthTop > 0, episegment = nil');
                   End;

  If (EX*DTop) > 20.0
    Then LT := 1.0
    Else
      Begin
        {only half is in spectrum used for photsyn. - Edmondson '56}
        PL := GetStatePointer(Light,StV,WaterCol);
        If TS=TSDaily then LightVal := PL.DailyLight
                      else LightVal := PL.HourlyLight;

        If TS=TSDaily then LightCorr := 1.0
                      else LightCorr := 1.25;

        LT := (-((LightVal/2)/(LightCorr*LightSat)) * EXP(-EX * DTop));
     {unitless      ly/d                  ly/d             1/m  m }
        If LT<-30 then LT:=0 else LT:=Exp(LT);  {Prevent a Crash, JSC}
      End;

  LtAtTop:=LT;
End; { ltatTop }


{light limitation at depth}
Function TPlant.LtAtDepth(TS:TimeStepType) : double;
Var LightVal, LD,EX,DTop, ExEpi, DBott,LightCorr, EpiExtinct : Double;
    WellMixedLinked, Incl_Periphyton: Boolean;
    PL: Tlight;

Begin
  {Floating Macrophytes not subject to light limitation, this function is never executed for them}
  DTop := AllStates.DepthTop;  {m}
  With AllStates do
    WellMixedLinked := LinkedMode and Stratified and WellMixed;

  If (DTop=0) then EpiExtinct := 1 {avoid irrelevant calculation}
              else Begin
                     Incl_Periphyton := not (IsPhytoplankton);
                     IF AllStates.EpiSegment <> nil  {8/17/07, use extinction from Epilimnion Segment}
                       then ExEpi := AllStates.Episegment.Extinct(Incl_Periphyton,True,True,False,False )
                       else Raise EAQUATOXError.Create('LtAtDepth Error, DepthTop > 0, episegment = nil');
                     EpiExtinct := EXP(-ExEpi * DTop);
                   End;

  Incl_Periphyton := not (IsPhytoplankton);

  EX:=AllStates.Extinct(Incl_Periphyton,True,True,False,WellMixedLinked);
  DBott:= DepthBottom;

  If (EX*DBott) > 20.0
    Then LD := 1.0
    Else
      Begin
        PL := GetStatePointer(Light,StV,WaterCol);
        If TS=TSDaily then LightVal := PL.DailyLight
                      else LightVal := PL.HourlyLight;
        If DTop>0 then LightVal := LightVal * EpiExtinct;  {8/17,07 account for light at the top of the hypolimnion}

        If TS=TSDaily then LightCorr := 1.0
                      else LightCorr := 1.25;
        {only half is in spectrum used for photsyn. - Edmondson '56}
        LD := (-((LightVal/2)/(LightCorr*LightSat)) * EXP(-EX * (DBott-DTop)));
      {unitless     ly/d                   ly/d           1/m    m      m  8/17/07 depth of layer}
        If LD<-30 then LD:=0 else LD:=Exp(LD);  {Prevent a Crash, JSC}
      End;

  LtAtDepth:=LD;
End; { ltatdepth }


Function TPlant.DepthBottom : double;
Var DB : Double;
Begin

  With AllStates do with Location.Locale do
    Begin
      If UseBathymetry then DB := ZMax
                       else DB := DynamicZMean;
      If UseBathymetry and Stratified and (VSeg=Epilimnion) then DB := MaxEpiThick;

      If LinkedMode and Stratified and (not WellMixed) and (VSeg=Hypolimnion)
         then DB := DB + DepthTop;

      If LinkedMode and Stratified and WellMixed then {2-27-2008  Avg Light Climate for entire segment}
        Begin
          If VSeg = Epilimnion then
              Begin
                If UseBathymetry then DB := ZMax  //10-14-2010 ZMax now pertains to the max depth, both segments,  Use Epi Seg. Variable
                                 else DB := DB + HypoSegment.DynamicZMean;
              End
            Else {VSeg = Hypolimnion}
              Begin
                If UseBathymetry then DB := EpiSegment.Location.Locale.ZMax  //10-14-2010 ZMax now pertains to the max depth, both segments,  Use Epi Seg. Variable
                                 else DB := DB + EpiSegment.DynamicZMean;
              End;
        End;
    End;

  If (IsPhytoplankton) then
    Begin
      With AllStates do with Location do
      If (GetState(Temperature,StV,WaterCol) <= Ice_Cover_Temp) and (VSeg = Epilimnion) and (MeanThick[VSeg]> 2.0) then
        DB := 2.0; {algae in top 2 m under ice}

       {Account for buoyancy due to gas vacuoles}
      If (AllStates.VSeg=Epilimnion) and (PAlgalRec^.SurfaceFloating) and (DB > 1.0) then  {Removed 0.2, 1-13-2005 RAP, 2-2007} // 3/9/2012 surfacefloating variable
        If (NutrLimit > 0.25) {healthy} then
          If(GetState(WindLoading,StV,WaterCol) < 3) {m/sec, otherwise Langmuir circ.}
            then DB := 0.1  {RAP 1-12-2005}
            else if DB > 3.0 then DB := 3.0; {roughly the depth of a Langmuir cell}

    End {phytoplankton}
  Else
    {macrophytes and periphyton}
    Begin
       If AllStates.ZEuphotic < DB then
         DB := AllStates.ZEuphotic;
    End;

  DepthBottom:=DB;
End;

(*****************************************)
(* algal light limitation                *)
(* Steele, 1962; Kremer & Nixon, 1979    *)
(* based on modification by DiToro, 1971 *)
(*****************************************)
Function TPlant.LtLimit(TS:TimeStepType) : Double ;
var LL : Double;
{RAP changed DB to DBot & added P & E. 8/23/95}
    DBot,DT,LT,LD,P,E : Double;

    {-------------------------------------------------}
    function PeriphytExt : double;
    var PeriExtinction : double;
        Phyto : AllVariables;
        PPhyt : TPlant;
    begin
      PeriExtinction := 0; {initialize}
      For Phyto := FirstAlgae to LastAlgae do
        begin
          PPhyt:=GetStatePointer(Phyto,StV,WaterCol);
          If PPhyt<>nil then
            If   (PPhyt.IsPeriphyton)
               then
                  PeriExtinction := PeriExtinction +
                                    PPhyt.PAlgalRec^.ECoeffPhyto
                                   * GetState(Phyto,StV,WaterCol);
        end;
      PeriphytExt := Exp(-PeriExtinction);
                           {1/m}
    end;
    {-------------------------------------------------}

Var PeriExt: Double;
    Inhibition, WellMixedLinked: Boolean;
    Const_a: Double;
begin
  LtLimit := 1;
  If (PAlgalRec^.PlantType='Macrophytes') and (MacroType=freefloat) then exit;

  DBot:=DepthBottom;
  DT:=AllStates.DepthTop;

  if (DBot - DT) < Tiny
  then Begin
         LL := 1.0; { avoid divide by zero }
         LowLt_Limit := 1.0;
         HighLt_Limit := 1.0;
       End
  else
    begin
      LT:=LtAtTop(TS);  LD:=LtAtDepth(TS);
      P := AllStates.PhotoPeriod;
      With AllStates do
        WellMixedLinked := LinkedMode and Stratified and WellMixed;  {2-27-08}
      E := AllStates.Extinct(False,True,True,PAlgalRec^.SurfaceFloating,WellMixedLinked);    {periphyton are not included because "PeriphytExt" handles periphyton extinction}  // 3/9/2012 bl-greens to surfacefloater
      If (not IsPhytoplankton)  {i.e. 'Periphyton', 'Macrophytes', or 'Bryophytes'}
         then PeriExt := PeriphytExt
         else PeriExt := 1.0;

     IF TS=TSDAILY
         THEN LL := 0.85 *(2.71828 * P/(E * (DBot - DT))) * (LD - LT) * PeriExt
         ELSE LL :=       (2.71828    /(E * (DBot - DT))) * (LD - LT) * PeriExt;  {removed 0.85 and photoperiod}

      if LL > 1.0 then LL := 1.0;
      if LL < Small then LL := 0.0;   {RAP, 9/11/95 }

      If (TS=AllStates.PModelTimeStep^) then
        Begin
          Lt_Limit := LL; {save for rate output  JSC 9-5-02}
          Const_a := EXP(-E*DT)*EXP(-E*DBot);
          Inhibition := LT-(Const_a*LD)< 0;
          If Inhibition then Begin LowLt_Limit := 1.0; HighLt_Limit := Lt_Limit; End         // 1/13/2014 make non-affected limitation 1.0
                        else Begin LowLt_Limit := Lt_Limit; HighLt_Limit := 1.0; End;
        End;
    end;

  LtLimit:=LL;
end;


(********************************)
(* algal phosphate limitation   *)
(* Michaelis-Menten kinetics    *)
(********************************)
function TPlant.PO4Limit : double;
var PLimit,P2O : double;
begin
   If AllStates.SetupRec^.Internal_Nutrients
   then with PAlgalRec^ do
     Begin
       P2O := P_2_Org;
       If P2O > tiny
         then PLimit := (1-(Min_P_Ratio/P2O))  // Internal nutrientsP Limit
         else PLimit := 0.0;
     End
   else
     Begin  //external nutrients
      If (GetState(Phosphate,StV,WaterCol) + PAlgalRec^.KPO4) =0
        then PLimit := 1.0
        else PLimit := GetState(Phosphate,StV,WaterCol)/( GetState(Phosphate,StV,WaterCol) + PAlgalRec^.KPO4);
                       {unitless  P/PO4           gPO4/cu m    P/PO4            gPO4/cu m            gP/cu m}
     End;  // external nutrients

  if PLimit < Small then PLimit := 0.0;   {RAP, 9/11/95 Tiny -> Small}
  PO4Limit := PLimit;
end; { phoslimit }


Function TPlant.Is_Pcp_CaCO3  : Boolean;  {Is this plant precipitating CaCO3?}
Begin
  Is_Pcp_CaCO3 := (GetState(pH,StV,WaterCol) >= 7.5) and  // JSC, From 8.25 to 7.5 on 7/2/2009
    not ((PAlgalRec.PlantType='Bryophytes') or (NState in [OtherAlg1, OtherAlg2]));
    {subset of plants, all plants except Bryophytes and "Other Algae" compartments}
End;

(********************************)
(* algal carbon limitation      *)
(* Michaelis-Menten kinetics    *)
(********************************)
Function TPlant.CO2Limit : double;
Var CLimit, CDioxide : double;
Const
     C2CO2 = 0.27;
    { KCO2 = 0.346; }{ave from Collins & Wlosinski, 1983}
Begin

{  IF Is_Pcp_CaCO3
    Then Begin CO2Limit := 1.0; Exit; End;
    {10/26/07 -- Because plants are deriving C from the bicarbonate reaction,
     those plants precipitating calcite are not limited by CO2 in the water column
     11/09/07 -- CO2 Limitation Returned to precipitating plants}

  CDioxide := GetState(CO2,StV,WaterCol);
  if CDioxide < Small then
     CLimit := 0.0
  else
    {RAP, 9/9/95 replaced constant KCO2 with PAlgalRec^.KCarbon}
    CLimit := C2CO2 * CDioxide/(C2CO2 * CDioxide + PAlgalRec^.KCarbon);
    {unitless C/CO2   gCO2/cu m C/CO2        gCO2/cu m      gC/cu m}
  CO2Limit := CLimit;
End; { phoslimit }


Function TPlant.Nutr_2_Org(NTyp: T_SVType): Double;
Begin
  If NTyp = NIntrnl then Result := N_2_Org
                    else Result := P_2_Org;
End;

Function TPlant.N_2_Org : Double;   {g N / g OM}
Begin
  If AllStates.SetupRec^.Internal_Nutrients and (State>Tiny)
    then Begin
            If GetStatePointer(NState,NIntrnl,WaterCol) <> nil
              then N_2_Org := GetState(NState,NIntrnl,WaterCol) / State *  1e-3
                   {g/g OM}             {ug N /L}              {mg OM/L}  {mg/ug}
              else N_2_Org := PAlgalRec^.N2OrgInit; // rooted macrophyte
          End
    else N_2_Org := PAlgalRec^.N2OrgInit;

End;


Function TPlant.P_2_Org : Double;
Begin
  If AllStates.SetupRec^.Internal_Nutrients and (State>Tiny)
    then Begin
           If GetStatePointer(NState,PIntrnl,WaterCol) <> nil
             then P_2_Org := GetState(NState,PIntrnl,WaterCol) / State *  1e-3
                                     {ug N /L}                  {mg/L}  {mg/ug}
             else P_2_Org := PAlgalRec^.P2OrgInit; // rooted macrophyte
         End
    else P_2_Org := PAlgalRec^.P2OrgInit;
End;



Function TPlant.IsFixingN: Boolean;
Var Nitrogen ,InorgP, NtoP : Double;
Begin
  IsFixingN := False;

  If not (nState in [FirstBlGreen..LastBlGreen]) then exit;  // cyanobacteria only

  If GetStatePointer(NState,NIntrnl,WaterCol) <> nil  // internal nutrients option 3/18/2014
    then
      Begin
        IsFixingN := (N_2_Org < 0.5 * PAlgalRec^.NHalfSatInternal);
        Exit;
      End;

  If Not AllStates.SetupRec^.NFix_UseRatio  //added option 3/19/2010
    then
      Begin
        Nitrogen := GetState(Nitrate,StV,WaterCol) + GetState(Ammonia,StV,WaterCol);
        IsFixingN := (Nitrogen < 0.5 * PAlgalRec^.KN);  // Official "Release 3" code
      End
    else  {NFix_UseRatio}
      Begin  {12-16-2009 N Fixing Option}
        InorgP := GetState(Phosphate,StV,WaterCol);
        If InorgP > tiny {Avoid Divide by Zero}
          then
            Begin
              NtoP := (GetState(Ammonia,StV,WaterCol)+GetState(Nitrate,StV,WaterCol))/InorgP;
              If (NtoP < AllStates.SetupRec^.NtoPRatio) then IsFixingN := True;
             {If inorganic N over Inorganic P ratio is less than NtoPRatio (Default of 7) then cyanobacteria fix nitrogen}
           End;
      End;

End;

(********************************)
(* algal nitrogen limitation    *)
(********************************)
function TPlant.NLimit : double ;
Var  Nitrogen, NL, N2O : double;
{const
     N2NH4 = 0.78;}        {1/24/03, deleted}
    { N2NO3 = 0.23; }       {1/24/03, deleted}

begin
   Nitrogen := {N2NH4 *} GetState(Ammonia,StV,WaterCol) + {N2NO3 *} GetState(Nitrate,StV,WaterCol);
   {gN/cu m    N/NH4            gNH4/cu m  N/NO3           gNO3/cu m}
   if IsFixingN then
     NL := 1.0  {N-fixation}
   else
     If AllStates.SetupRec^.Internal_Nutrients
     then with PAlgalRec^ do
       Begin
         N2O := N_2_Org;
         If N2O > tiny
           then NL := (1-(Min_N_Ratio/N2O))  // Internal nutrients N Limit
           else NL := 0.0;
       End  //with PAlgalRec

     else //external nutrients
       Begin
         If (Nitrogen + PAlgalRec^.KN)=0
           then NL := 1
           else  NL := Nitrogen/(Nitrogen + PAlgalRec^.KN);
              {unitless gN/cu m gN/cu m     gN/cu m}
       End;
   if NL < Small then NL := 0.0;
   NLimit:=NL;
end; { nitrolimit }

function TPlant.NutrLimit : double;
var NLM : double;
begin
   PO4_Limit := PO4Limit; {save for rate output  JSC 1-30-03}
   N_Limit := NLimit;     {save for rate output  JSC 1-30-03}
   NLM := Min(N_Limit, PO4_Limit);
   CO2_Limit := CO2Limit; {save for rate output  JSC 1-30-03}
   NLM := Min(NLM, CO2_Limit);
   Nutr_Limit := NLM;     {save for rate output  JSC 9-5-02}
   NutrLimit:=NLM;
end;

Function TPlant.PProdLimit: double ;
var PL, AggFP : double;
    LL, NL,
    TCorrValue : double;
begin
  with PAlgalRec^, Location.Locale do
      TCorrValue := AllStates.TCorr(Q10, TRef, TOpt, TMax);

   LL:=LtLimit(AllStates.PModelTimeStep^);
   NL:=NutrLimit;

   AggFP := AggregateFracPhoto;

   Temp_Limit := TCorrValue; {save for rate output  JSC 9-5-02}
   Chem_Limit := AggFP;      {save for rate output  JSC 9-5-02}

   PL := LL * NL * TCorrValue * AggFP;
   {all unitless }
   if PL > 1.0 then
      PL := 1.0; {make sure it is truly a reduction factor}
   PProdLimit:=PL;

end;


(***************************************)
(*  current limitation for periphyton  *)
(*  Colby and McIntire, 1978           *)
(***************************************)
Function TPlant.VLimit: double ;
Var   Vel, VL : Double;
Const VelCoeff = 0.057;

Begin
 With PAlgalRec^ do
  If (Location.SiteType=Stream)
   Then
    Begin
     Vel := AllStates.Velocity(PrefRiffle,PrefPool,False);
                        {cm/s}
     VL := Min(1.0, (Red_Still_Water + VelCoeff * Vel/(1.0 + VelCoeff * Vel)));
   {frac}               {unitless}    {unitless} {m/s}       {unitless} {m/s}
    End
   Else VL := Red_Still_Water;

  VLimit := VL;
End;

Function TPlant.PeriphytonSlough: Double;
Var PlantLoop: AllVariables;
    PP: TPlant;
    PSlough, j: Double;

Begin
  PSlough := 0;
  For PlantLoop := FirstAlgae to LastAlgae do
    Begin
      PP := GetStatePointer(PlantLoop,StV,WaterCol);
      If PP <> nil then
        If PP.PSameSpecies^=nstate then
          Begin
            PP.Washout; {update sloughevent}
            If PP.Sloughevent then
              Begin
                j := -999; {signal to not write mass balance tracking}
                PP.Derivative(j); {update sloughing}
                PSlough  := PSlough + PP.Sloughing * (1/3) ;
                {1/3 of periphyton will go to phytoplankton and 2/3 to detritus with sloughing/Slough.}
              End;
          End;
    End;
  PeriphytonSlough := PSlough;
End;


    (************************************)
    (*                                  *)
    (*     DIFFERENTIAL EQUATIONS       *)
    (*                                  *)
    (************************************)


Procedure TPlant.Derivative;
var  L, Pho, R, Slg, ToxD, Ex, M, Pr, WO, WI, S, STH, SFE, TD, DiffUp, DiffDown, En, PeriScr, Sed2Me, Fl: Double;
     Trackit: Boolean;
     SurfaceFloater: Boolean;
    {--------------------------------------------------}
    Procedure WriteRates;
    Var ToxLoop: T_SVType;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Load',L);
          SaveRate('Photosyn',Pho);
          SaveRate('Respir',R);
          SaveRate('Excret',Ex);

          For ToxLoop:=FirstOrgTxTyp to LastOrgTxTyp do
            If GetStatePointer(NState,ToxLoop,WaterCol)<>nil then
              SaveRate(PrecText(ToxLoop)+' Poisoned',MortRates.OrgPois[ToxLoop]);
          SaveRate('Other Mort',MortRates.OtherMort);

          If GetState(Salinity,StV,WaterCol) <> -1 then
            SaveRate('Salt Mort',MortRates.SaltMort);


          SaveRate('Predation',Pr);
          SaveRate('Washout',WO);
          If AllStates.LinkedMode then SaveRate('Washin',WI);
          SaveRate('NetBoundary',L+WI-WO+En+DiffUp+DiffDown+TD);  

          If (IsPeriphyton)
            then Begin
                   SaveRate('SedtoPeri',Sed2Me);
                 End;

          SaveRate('Sediment',S);
          If IsPhytoplankton then
            Begin
              SaveRate('PeriScour',PeriScr);
              If AllStates.EstuarySegment then
                 SaveRate('Entrainment',En);
              If Not AllStates.LinkedMode
                then SaveRate('TurbDiff',TD)
                else {If not AllStates.CascadeRunning then }
                     Begin
                       SaveRate('DiffUp',DiffUp);
                       SaveRate('DiffDown',DiffDown);
                     End;
            End;

          If not IsPhytoplankton then
              SaveRate('Sloughing',Slg);

          SaveRate('SinkToHypo',STH);
          SaveRate('SinkFromEpi',SFE);

          SaveRate('Lt_LIM',Lt_Limit);
          SaveRate('N_LIM',N_Limit);
          SaveRate('PO4_LIM',PO4_Limit);
          SaveRate('CO2_LIM',CO2_Limit);
          SaveRate('Nutr_LIM',Nutr_Limit);
          SaveRate('Temp_LIM',Temp_Limit);
          SaveRate('Chem_LIM',Chem_Limit);
          If (IsPeriphyton) then
            SaveRate('Vel_LIM',Vel_Limit);
          SaveRate('LowLt_LIM',LowLt_Limit);
          SaveRate('HighLt_LIM',HighLt_Limit);

          If SurfaceFloater then
             SaveRate('Floating',Fl);
        End;
    End;
    {--------------------------------------------------}
    Procedure TrackMB;
    Var NutrFrac, LoadInKg, LossInKg, LayerInKg: Double;
        Typ: AllVariables;
    Begin
     For Typ := Nitrate to Phosphate do With AllStates do
      Begin
       If Typ=Nitrate then NutrFrac := N_2_Org
                      else NutrFrac := P_2_Org;

       with MBLoadArray[Typ] do
         Begin {save for tox loss output & categorization}
           LoadInKg := (L    ) * SegVol * 1000.0 * 1e-6 * NutrFrac;
           {kg nutr} {mg org/L}   {m3}   {L/m3} {kg/mg} {nutr / org}
           BoundLoad[Derivstep] := BoundLoad[Derivstep] + LoadInKg;  {Load into modeled system}

           If EN<= 0 then LoadInKg :=  (L + WI)      * SegVol * 1000.0 * 1e-6 * NutrFrac
                     else LoadInKg :=  (L + WI + En) * SegVol * 1000.0 * 1e-6 * NutrFrac;
                         {kg nutr}     {mg org/L}     {m3}   {L/m3}  {kg/mg} {nutr / org}

           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           LoadBiota[Derivstep]  := LoadBiota[Derivstep]  + LoadInKg;
         End;

       If (IsPhytoplankton) then
        with Location.Morph do with MBLossArray[Typ] do
         Begin {save for tox loss output & categorization}
           LossInKg :=  WO {* OOSDischFrac}* SegVol * 1000.0 * 1e-6 * NutrFrac;  // 3/20/2014 remove OOSDischFrac
           {kg nutr} {mg org/L} {frac}        {m3}  {L/m3} {kg/mg} {nutr / org}
           BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg;  {Loss from the modeled system}

           If En<0 then LossInKg :=  (-En + WO {* OOSDischFrac}) * SegVol * 1000.0 * 1e-6 * NutrFrac;  {loss from this segment} // 3/20/2014 remove OOSDischFrac

           TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
           TotalWashout[Derivstep] := TotalWashout[Derivstep] + LossInKg;
           WashoutPlant[Derivstep] := WashoutPlant[Derivstep] + LossInKg;
         End;

       with MBLayerArray[Typ] do
         Begin {save for tox loss output & categorization}
           LayerInKg := (SFE-STH) * SegVol * 1000.0 * 1e-6 * NutrFrac;
           {kg nutr}    {mg org/L}   {m3}    {L/m3} {kg/mg} {nutr / org}
           NSink[Derivstep] := NSink[Derivstep] + LayerInKg;
           NNetLayer [Derivstep] := NNetLayer[Derivstep]  + LayerInKg;

            LayerInKg := (TD + DiffUp + DiffDown)   * SegVol * 1000.0 * 1e-6  * NutrFrac;
           {kg nutr}     {    mg org/L          }     {m3}    {L/m3} {kg/mg} {nutr / org}
            NTurbDiff [Derivstep] := NTurbDiff[Derivstep] + LayerInKg;
            NNetLayer [Derivstep] := NNetLayer[Derivstep] + LayerInKg;
          End;

      {gN/cu m }
      If (not AllStates.SetupRec^.Internal_Nutrients)
       then If (Typ=Nitrate) and (IsFixingN) {nitrogen fixation}
        then with MBLoadArray[Typ] do
         Begin {save for tox loss output & categorization}
           LoadInKg :=  Pho *  SegVol * 1000.0 * 1e-6 * NutrFrac;
           {kg nutr} {mg org/L} {m3}   {L/m3} {kg/mg} {nutr / org}
           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           LoadFixation[Derivstep] := LoadFixation[Derivstep] + LoadInKg;
         End;
      End;
    End;
    {--------------------------------------------------}
Var ToxLoop: T_SVType;
begin
  L:=0; Pho:=0; R:=0; Ex:=0; Pr:=0; WO:=0; WI := 0; S:=0; TD:=0; STH := 0; SFE := 0; En := 0;
  MortRates.OtherMort:=0; DiffUp:=0;DiffDown:=0;Slg:=0;ToxD:=0;PeriScr:=0; Sloughing:=0; Fl := 0;
  MortRates.SaltMort  := 0;   Sed2Me := 0;
  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
      MortRates.OrgPois[ToxLoop] := 0;
  trackit := (db <> -999); {signal to not write mass balance tracking}

  SurfaceFloater := PAlgalRec^.SurfaceFloating;

  L := Loading;
  WI := WashIn;

    begin
      M := Mortality;  { Mortality calculated first for Chronic Effect Calculation }
      Pho := Photosynthesis;
      R := Respiration;
      Ex := PhotoResp;
      Pr := Predation;
      WO := Washout;

      S := Sedimentation;  {SinkToHypo is Calculated Here}
      If Not SurfaceFloater then
        Begin
          STH := SinkToHypo;
          SFE := SinkFromEp;
          Sed2Me := SedToMe;
        End;

      If SurfaceFloater then Fl := Floating;

      If IsPhytoplankton then
         PeriScr := PeriphytonSlough;

      If not IsPhytoplankton then
         Slg  := CalcSlough;

      If Sloughevent then Slg:=0; {set precisely below  11/11/03}

      If IsPhytoplankton then
          If AllStates.LinkedMode and (not AllStates.CascadeRunning)
            then
              Begin
                DiffUp   := SegmentDiffusion(True);
                DiffDown := SegmentDiffusion(False);
              End
            else If (Not AllStates.LinkedMode) and (Not SurfaceFloater)
               then TD := TurbDiff;

      If (IsPhytoplankton) and AllStates.EstuarySegment
         then En := EstuaryEntrainment;

      dB := L + Pho - R - Ex - M - Pr - WO + WI - S + Sed2Me - STH + SFE + TD + En
              + DiffUp + DiffDown - ToxD - Slg + PeriScr + Fl ;

      If Sloughevent then
        begin
          Slg := State - (SloughLevel/2) + db;  {precisely slough to sloughlevel, 11/11/03}
          Sloughing := Slg;
          db := db - Slg;
        end;

    end;
  WriteRates;
  If Trackit then TrackMB;
end; { TPlant.derivative }

Function TMacrophyte.Washout: Double;
Var SegVolume, Disch, KCap, KCapLimit: Double;
    i: Integer;
    PLnk: TSegmentLink;
Begin
  Washout := 0;
  If (MacroType<>FreeFloat) then exit;

  With AllStates do with Location.Morph do
    SegVolume := SegVolum[VSeg];

  Disch := 0;
  If (not AllStates.linkedmode) or ((AllStates.Out_Cs_Links.Count = 0) and (AllStates.Out_FB_Links.Count = 0))
    Then Disch := Location.Discharge[AllStates.VSeg]
    Else With AllStates do
      Begin  {Not BottomLink}
        For i:=0 to Out_FB_Links.Count-1 do
          Begin
            PLnk := Out_FB_Links.At(i);
            If PLnk.ToPStates.VSeg = Epilimnion  {no macrophyte flow to hypolimnion}
               then Disch := Disch + PLnk.GetWaterFlow(TPresent);
          End;
        For i:=0 to Out_Cs_Links.Count-1 do
          Begin
            PLnk := Out_Cs_Links.At(i);
            If PLnk.ToPStates.VSeg = Epilimnion  {no macrophyte flow to hypolimnion}
               then Disch := Disch + PLnk.GetWaterFlow(TPresent);
          End;
      End;


   KCap :=  KCap_in_g_m3;
  {g/m3}              

  KCapLimit := 1 - ((KCap - State)/Kcap) ;

  Washout :=  KCapLimit * Disch / SegVolume * State;
{g/cu m-d}   {fraction} {cu m/d}   {cu m}    {g/cu m}

  WashoutStep[AllStates.DerivStep] := Result * AllStates.SegVol;
End;

Function TMacrophyte.WashIn: Double;
Begin
  WashIn := 0;
  If AllStates.VSeg=Hypolimnion then exit;
  WashIn := Inherited WashIn;  {TStateVariable}
End;

Procedure TMacrophyte.Derivative;
var  L, Pho, R, Ex, M, Pr, Br, WO, WI: Double;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Load',L);
          SaveRate('Photosyn',Pho);
          SaveRate('Respir',R);
          SaveRate('Excret',Ex);
          SaveRate('Mort',M);
          SaveRate('Predation',Pr);
          SaveRate('Breakage',Br);

          If MacroType=FreeFloat then
            Begin
              SaveRate('Washout',WO);
              If AllStates.LinkedMode then SaveRate('Washin',WI);
              SaveRate('NetBoundary',L+WI-WO);
            End;

          SaveRate('Lt_LIM',Lt_Limit);
          If (PAlgalRec^.PlantType = 'Bryophytes') or (MacroType=FreeFloat) then
            Begin
              SaveRate('Nutr_LIM',Nutr_Limit);
              SaveRate('N_LIM',N_Limit);
              SaveRate('PO4_LIM',PO4_Limit);
              SaveRate('CO2_LIM',CO2_Limit);
            End;
          SaveRate('Temp_LIM',Temp_Limit);
          SaveRate('Chem_LIM',Chem_Limit);
          SaveRate('LowLt_LIM',LowLt_Limit);
          SaveRate('HighLt_LIM',HighLt_Limit);
        End;
    End;
    {--------------------------------------------------}
    Procedure TrackMB;
    Var NutrFrac, LoadInKg: Double;
        Typ: AllVariables;
    Begin
     For Typ := Nitrate to Phosphate do With AllStates do
      Begin
       If Typ=Nitrate then NutrFrac := N_2_Org
                      else NutrFrac := P_2_Org;

       with MBLoadArray[Typ] do
         Begin {save for tox loss output & categorization}
           LoadInKg := (L) * SegVol * 1000.0 * 1e-6 * NutrFrac;
           BoundLoad[Derivstep] := BoundLoad[Derivstep] + LoadInKg;  {Load into modeled system}

           LoadInKg := (L+WI) * SegVol * 1000.0 * 1e-6 * NutrFrac;
           {kg nutr} {mg org/L}  {m3}    {L/m3} {kg/mg} {nutr / org}

           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           LoadBiota[Derivstep]  := LoadBiota[Derivstep]  + LoadInKg;
         End;

       If not (PAlgalRec^.PlantType = 'Bryophytes') and not (MacroType = freefloat)
            {bryophytes and freely floating macrophytes assimilate nutrients from water}
        then with MBLoadArray[Typ] do
         Begin {save for tox loss output & categorization}
           LoadInKg :=  Pho *  SegVol * 1000.0 * 1e-6 * NutrFrac;
           {kg nutr} {mg org/L}  {m3}   {L/m3} {kg/mg} {nutr / org}
           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           LoadPWMacro[Derivstep] := LoadPWMacro[Derivstep] + LoadInKg;
         End;

      End;
    End;
    {--------------------------------------------------}

Begin
  L:=0; Pho:=0; R:=0; Ex:=0; M:=0; Pr:=0; WO:=0; WI:=0; Br:=0;

  L := Loading;

  If (State < Tiny)
    then
      begin
        WI := WashIn;
        dB := L + WI;
      end
    else
      begin
        M := Mortality; { Mortality calculated first for Chronic Effect Calculation }
        Pho := Photosynthesis;
        R := Respiration;
        Ex:= PhotoResp;
        Pr:= Predation;
        Br := Breakage;
        If MacroType=FreeFloat then
          Begin
            WO:= WashOut;
            WI:= WashIn;
            {note: no macrophytes are subject to diffusion between segments}
          End;

        dB:= L + Pho - R - Ex - M - Pr - WO + WI - Br ;

      end;
   WriteRates;
   TrackMB;

   If (Macrotype<>Benthic) {floating} and (AllStates.VSeg=Hypolimnion) and (State>tiny)
     Then Raise EAQUATOXERROR.Create('Floating Macrophytes in a Hypolimnion segment. '+
                'This is the result of an invalid initial condition in the Linked-Study setup.');

End; { TMacrophyte.dBdT }


{ ------------------   INTERNAL NUTRIENTS OBJECTS -------------------------- }

Function T_N_Internal_Plant.Uptake: Double;
Var WC_Conc, HalfSat, HalfSatInternal, Ratio, MinRatio, MaxUptake: Double;
    CPlant: TPlant;
Begin
  Uptake := 0;
  CPlant :=  GetStatePointer(nstate,StV,WaterCol);

  With CPlant.PAlgalRec^ do
   If SVType = NIntrnl then
     Begin
       If (CPlant.IsFixingN) then Exit;  {N-fixation, not assimilation from the water column, uptake=0}

       WC_Conc := GetState(Ammonia,StV,WaterCol) + GetState(Nitrate,StV,WaterCol);
       HalfSat := KN;
       HalfSatInternal :=  NHalfSatInternal;
       Ratio := CPlant.N_2_Org;
       MinRatio := Min_N_Ratio;
       MaxUptake := MaxNUptake;
     End
   else {SVType = PInternl}
     Begin
       WC_Conc := GetState(Phosphate,StV,WaterCol);
       HalfSat := KPO4;
       HalfSatInternal :=  PHalfSatInternal;
       Ratio := CPlant.P_2_Org;
       MinRatio := Min_P_Ratio;
       MaxUptake := MaxPUptake;
     End;

  Uptake := MaxUptake * (WC_Conc/(HalfSat+WC_Conc)) * (HalfSatInternal/(HalfSatInternal+(Ratio-MinRatio))) * CPlant.State *  1e3;
 {ug/L d}    {g/g d}    {      unitless           }   {                  unitless                        }   {   mg / L  }  {ug/mg}
End;

Function T_N_Internal_Plant.NutrSegDiff(UpLinks: Boolean):Double;
{Diffusion of Nutr within SVs to or from up or downstream link, only relevant for linked mode}
Var i: Integer;
    PLnk         : TSegmentLink;
    NutrDiffCalc  : Double;
    CarryDiff    : Double;
    SegVolume    : Double;
    OtherSeg     : TStates;
    RelevantPlant: TPlant;
    ThisSegCarryConc, OtherSegCConc : Double; {g/m3}
    DispCoeff, Area, Length: Double;
    Links        : TCollection;

Begin
  NutrSegDiff  := 0;
  NutrDiffCalc := 0;
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

          If CarryDiff<>0 then
            Begin
              If CarryDiff>0 then RelevantPlant :=  OtherSeg.GetStatePointer(NState,SVType,Layer)
                             else RelevantPlant := AllStates.GetStatePointer(NState,SVType,Layer);

              NutrDiffCalc := NutrDiffCalc + CarryDiff * RelevantPlant.Nutr_2_Org(SVType) * 1e3;
               {ug/l d}       {ug/l d}       {mg/L d}                     {g/g}           {ug/mg}
            End;
        End;
    End;

  NutrSegDiff := NutrDiffCalc;
End;

Function T_N_Internal_Plant.NutInCarrierWashin: Double;
Var PUpstreamCarrier: TPlant;
    i      : Integer;
    PUpVol : TVolume;
    PLnk   : TSegmentLink;
    Junk   : Double;
    UpStVolume, SegVolume  : Double;
    WaterFlow, UpStWashout : Double;
    TotUpStWash,PctWashThisLink : Double;
Begin
  NutInCarrierWashin :=0;

  If SVType=StV then Raise EAQUATOXError.Create('Programming Error, NutInCarrierWashin must be called by Nut dissolved in Carrier');
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
              UpStWashout := PUpstreamCarrier.Washout * UpStVolume; {Washout is virtual method}

              If UpStWashout > 0 then
                NutInCarrierWashin := Result + (UpStWashout / SegVolume * PUpstreamCarrier.Nutr_2_Org(SVType) * 1e3 * PctWashThisLink);
                      {ug/L}                    {mg/L * M3}     {M3}                          {g/g}           {ug/mg}      {frac}

            End; {If WaterFlow > tiny}
        End;
    End;  {with feedback links}
End;  {ToxInCarrierWashin}

Function T_N_Internal_Plant.NutrDiff: Double;
{Toxic within organisms or detritus diffusion between epilimnion and hypolimnion in non-linked mode}
Var OtherSeg: TStates;
    RelevantPlant: TPlant;
    CarrierDiff: Double;
Begin
  NutrDiff := 0;
  If not AllStates.Stratified then exit;

  If AllStates.VSeg=Epilimnion then OtherSeg:=AllStates.Hyposegment
                               else OtherSeg:=AllStates.Episegment;

  CarrierDiff := TStateVariable(GetStatePointer(NState,StV,WaterCol)).TurbDiff;
  If CarrierDiff = 0 then Exit;

  If CarrierDiff>0 then RelevantPlant :=  OtherSeg.GetStatePointer(NState,SVType,Layer)
                   else RelevantPlant := AllStates.GetStatePointer(NState,SVType,Layer);

  NutrDiff := CarrierDiff * RelevantPlant.Nutr_2_Org(SVType) * 1e3
   {ug/L}       {mg/L}                       {g/g}           {ug/mg}

End;


Procedure T_N_Internal_Plant.Derivative(var DB: double);

Var HypCp, EpiCp, CP   : TPlant;
    STH, SFE, ToxD, Entr, Flt: Double;
    TD, DiffUp, DiffDown, N2O, WashO, WashI, Lo, Predt, Mort, Sed, Uptk, Exc, Rsp, FixN  : Double;
    SegVolSave, Sed2Me, MacBrk, Slgh, LoadInKg: Double;
    SurfaceFloater : Boolean;

    {----------------------------------------------------------------}
    Function NToPhytoFromSlough: Double;
    Var PlantLoop: AllVariables;
        PPl: TPlant;
        NPSlough, j: Double;
    Begin
      NPSlough := 0;
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
                    NPSlough  := NPSlough + PPl.Sloughing * PPl.Nutr_2_Org(SVType) * 1e3 * (1/3);
                      {ug/L}                      {mg/L}              {g/g}        {ug/mg}

                    {1/3 of periphyton will go to phytoplankton and 2/3 to detritus with sloughing/Slough.}
                  End;
              End;
        End;
      NToPhytoFromSlough := NPSlough;
    End;
    {----------------------------------------------------------------}
     Function NSed2Me: Double;
    {Calculates nutrient transfer due to sedimentation of phytoplankton
     to each periphyton compartment }
    Begin
      NSed2Me := 0;
      If not CP.IsPeriphyton then exit;
      If CP.PSameSpecies^ = NullStateVar then exit;
      If CP.GetStatePointer(CP.PSameSpecies^,StV,WaterCol)=nil then exit;

      NSed2Me := CP.SedToMe * CP.Nutr_2_Org(SVType) * 1e3;
        {ug/L}     {mg/L}                {g/g}        {ug/mg}
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
          SaveRate('Uptake',Uptk);
          SaveRate('Mortality',Mort);
          SaveRate('Respiration',Rsp);
          SaveRate('Excretion',Exc);
          SaveRate('Predation',Predt);


          If (nstate in [FirstAlgae..LastAlgae]) and
             (TPlant(GetStatePointer(nstate,StV,WaterCol)).IsPhytoplankton) then
             Begin
               If Not AllStates.LinkedMode
                then SaveRate('TurbDiff',TD)
                else { If Not AllStates.CascadeRunning then}
                  Begin
                    SaveRate('DiffUp',DiffUp);
                    SaveRate('DiffDown',DiffDown);
                  End;
             End;

          If (nstate in [FirstAlgae..LastAlgae]) and
             (not CP.IsPhytoplankton) then
             Begin
               SaveRate('ToxDislodge',ToxD);
             End;

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

          If (CP.IsPeriphyton) then
             SaveRate('Sed to Phyt',Sed2Me);
          If nstate in [FirstAlgae..LastAlgae] then
            Begin
              SaveRate('Peri Slough',Slgh);
              SaveRate('Sediment',Sed);
            End;

          If (SVType = NIntrnl) and (nstate in [FirstBlGreen..LastBlGreen])
            then SaveRate('N Fixation',FixN);

        End;
    End;
    {----------------------------------------------------------------}

Begin
 CP := GetStatePointer(nstate,StV,WaterCol);
 SurfaceFloater := CP.PAlgalRec^.SurfaceFloating;

 WashO:=0;  Lo:=0;  Predt:=0; Mort:=0; Sed:=0; WashI:=0; DiffUp:=0; DiffDown:=0;
 Uptk:=0; Exc:=0; SFE:=0; TD:=0; ToxD:=0; Entr:=0; Rsp := 0;
 Sed:=0; MacBrk:=0; Slgh:=0; Sed2Me :=0; Flt := 0; STH := 0; FixN := 0;

 If (CP.State<tiny) then
  dB := 0.0
 else
  if nstate in [FirstMacro..LastMacro] {macrophytes}
    then
     Begin
          N2O      :=  CP.Nutr_2_Org(SVType) * 1e3;
     {ug N / mg OM}       {g N / g OM}       {ug/g}

          Lo       :=  CP.Loading * N2O;
       {ug N/L d}     {mg OM/L d}  {ug N/mg OM}

          WashO    :=  CP.Washout * N2O;
          WashoutStep[AllStates.DerivStep] := WashO * AllStates.SegVol;

          WashI    :=  NutInCarrierWashin;
          Uptk     :=  Uptake;
          Mort     :=  CP.Mortality * N2O ;
          Predt    :=  CP.predation * N2O ;
          Exc      :=  CP.PhotoResp * N2O ;
          Rsp      := CP.Respiration * N2O;

          MacBrk   :=  TMacrophyte(CP).Breakage * N2O;

          dB       :=  Lo + Uptk - (Predt + Mort + Exc + Rsp + MacBrk) -  WashO + WashI    {macrophytes}
     End
  else if nstate in [FirstAlgae..LastAlgae] then
    Begin
      N2O      :=  CP.Nutr_2_Org(SVType) * 1e3;
     {ug N / mg OM}       {g N / g OM}    {ug/g}

      Lo       :=  CP.Loading * N2O;
   {ug N/L d}     {mg OM/L d}  {ug N/mg OM}
      WashO := CP.Washout * N2O;
      WashoutStep[AllStates.DerivStep] := WashO * AllStates.SegVol;

      With AllStates do
        If (TPlant(CP).IsPhytoplankton) and EstuarySegment
          then Begin
                 Entr := EstuaryEntrainment;
                 If Entr<0 then Entr := Entr * N2O;
                 If Entr>0 then
                   Begin
                     HypCP := HypoSegment.GetStatePointer(nstate,StV,WaterCol);
                     Entr := Entr * HypCP.Nutr_2_Org(SVType) * 1e3;
                   End;
               End;

      WashI := NutInCarrierWashin;

      STH    := CP.SinkToHypo * N2O;
      With AllStates do
        If VSeg=Hypolimnion then
           Begin
             EpiCP := EpiSegment.GetStatePointer(nstate,StV,WaterCol);  {Refinement 10-20-2002 JSC}
             SFE := EpiCP.SinkToHypo * EpiCP.Nutr_2_Org(SVType) * 1e3;
           End;

      If SurfaceFloater then
       If AllStates.Stratified then
        Begin
          Flt := CP.Floating * N2O;
          With AllStates do
            If VSeg=Epilimnion then
               Begin
                 HypCP := HypoSegment.GetStatePointer(nstate,StV,WaterCol);
                 Flt := HypCP.Floating * HypCP.Nutr_2_Org(SVType) * 1e3;
               End;
        End;

      Predt  := CP.Predation * N2O;
      Mort   := CP.Mortality * N2O;
      Exc    := CP.PhotoResp  * N2O;
      Rsp    := CP.Respiration * N2O;

      If (CP.IsFixingN) and (SVType = NIntrnl) then
       with AllStates do with MBLoadArray[Nitrate] do
         Begin
           FixN := CP.PAlgalRec^.MaxNUptake * CP.State *  1e3;
          {ug/L d}                 {g/g d}   {mg / L}   {ug/mg}
           SegVolSave := SegVol;
           LoadInKg :=  FixN *  SegVolSave * 1000.0 * 1e-9   ;  {save for nutrient MB & categorization}
           {kg nutr}   {ug/L}    {m3}        {L/m3}   {kg/ug}
           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
           LoadFixation[Derivstep] := LoadFixation[Derivstep] + LoadInKg;
         End;

      ToxD   := CP.ToxicDislodge * N2O;

      Sed    := CP.Sedimentation * N2O; {plant sedimentation}
      Sed2Me := NSed2Me;
      If (CP.IsPeriphyton)
        then Slgh := CP.Sloughing * N2O
        else Slgh := - NToPhytoFromSlough;

      Uptk := Uptake;

      dB := Lo + Uptk + WashI - (WashO + Predt + Mort + Sed + Exc + Rsp + ToxD + Slgh)  {algae}
            - STH + SFE + Flt + Sed2Me + Entr + FixN;
    End {algae};

  {Phytoplankton are subject to currents , diffusion & TD }
  With TPlant(GetStatePointer(nstate,StV,WaterCol)).PAlgalRec^ do
   If (nstate in [FirstAlgae..LastAlgae]) and (PlantType='Phytoplankton') and (Not SurfaceFloating)
       then Begin
              If Not AllStates.LinkedMode then TD := NutrDiff
                                else If Not AllStates.CascadeRunning then
                                     Begin
                                       DiffUp := NutrSegDiff(True);
                                       DiffDown := NutrSegDiff(False);
                                     End;
              dB := dB + TD + DiffUp + DiffDown;
            End;

  If nState in [FirstPlant..LastPlant] then
    Begin
      WriteRates;
    End;
end;


Procedure T_N_Internal_Plant.Store(IsTemp: Boolean; Var st: Tstream);
Begin
  inherited;
End;


Constructor T_N_Internal_Plant.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Begin
  inherited;
End;



