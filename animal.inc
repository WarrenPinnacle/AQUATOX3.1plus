//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
{ TPreference methods }

Constructor TPreference.init(nP, nE : double; nS : StateVariables);
begin
   Preference:=nP; EgestCoeff:=nE;
   nState:=nS;
end;

{******************************************************************************}

{ TOrganism methods }

Constructor TOrganism.Init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                         IC : double; IsTempl: Boolean);
Var ToxLoop: T_SVType;
    StepLoop: Integer;
    Ionized: Boolean;
Begin
   Inherited Init(Ns,SVT,WaterCol,aName,P,IC, IsTempl);
   For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
     Begin
       LCInfinite   [ToxLoop] :=0;
       For StepLoop := 1 to 6 do
         Begin
           DeltaCumFracKill  [ToxLoop,StepLoop] := 0;
           DeltaResistant[ToxLoop,StepLoop] := 0;
         End;
       Resistant    [ToxLoop] :=0;
       PrevFracKill [ToxLoop] :=0;
       OrgToxBCF    [ToxLoop] :=0;
       RedGrowth    [ToxLoop] :=0;
       RedRepro     [ToxLoop] :=0;
       FracPhoto    [ToxLoop] :=1.0;
     End;

   For Ionized := False to True do
     Begin
       For StepLoop := 1 to 6 do
         Begin
           AmmoniaDeltaCumFracKill[ionized,StepLoop] := 0;
           AmmoniaDeltaResistant  [ionized,StepLoop] := 0;
         End;
       AmmoniaResistant[ionized]    :=0;
       AmmoniaPrevFracKill[ionized] :=0;
     End;

   For StepLoop := 1 to 6 do
     Begin
       SedDeltaCumFracKill[StepLoop] := 0;
       SedDeltaResistant  [StepLoop] := 0;
     End;
   SedResistant   :=0;
   SedPrevFracKill :=0;

   LoadsRec.ConstLoad := 1e-5;  {seed loading}
   If Ns=Salinity then LoadsRec.ConstLoad := 0;
End;

Procedure TOrganism.CalculateLoad(TimeIndex : Double);       // for animals & plants

Var SegVolume: Double;
    AddLoad, Infl,Wash: Double;
    Loop      : Alt_LoadingsType;
Begin
  SegVolume := AllStates.SegVol;

  Loading:=0;

  {Inflow Loadings}
     Begin
       Inherited CalculateLoad(TimeIndex);  {TStateVariable}

       With Location.Morph do
         Infl := Location.Morph.InflowH2O[AllStates.VSeg];  // * (OOSInflowFrac);   // JSC Remove OOSInflowFrac 3/20/2014

       If AllStates.EstuarySegment then
          Infl := Location.Morph.InflowH2O[Epilimnion]/2;  {upstream loadings only, estuary vsn. 10-17-02}

       If Infl > 0.0 then Loading:= Loading * Infl    / SegVolume               // JSC Fix Logic 2/16/2011
                           {conc/d}  {Conc}  {cu m d}    {cu m}
                     else Loading := 0;

       If AllStates.Convert_g_m2_to_mg_L(NState,SVType,Layer)
         then Loading := Loading * Location.Locale.SurfArea / AllStates.Volume_Last_Step;
         {Convert loading from g/m2 to g/m3 --  Seed loadings only}

      If IsPlant then
       If (TPlant(Self).IsPhytoplankton)  then
         With AllStates do
           Begin
             Wash := (Self as TPlant).Washout;
             Loading := Loading + (Wash - (Wash / PhytoResFactor));
             {mg/L}     {mg/L}    {mg/L}  {mg/L}     {unitless}
           End;

      If IsAnimal then
       If (TAnimal(Self).PAnimalData^.Animal_Type='Pelagic Invert.')  then
         With AllStates do
           Begin
             Wash := (Self as TAnimal).Drift;
             Loading := Loading + (Wash - (Wash / PhytoResFactor));
             {mg/L}     {mg/L}   {mg/L}  {mg/L}     {unitless}
           End;


      With LoadsRec do       // 10/15/2010 handle fish stocking
       If (nstate in [firstfish..lastfish]) and (not (Alt_Loadings[PointSource]=nil)) then
         For Loop:=PointSource to DirectPrecip do {NPS Irrelevant for Fish}
          Begin
             AddLoad:=0;
             If Alt_UseConstant[Loop]
               then AddLoad := Alt_ConstLoad[Loop]  {g/d or g/sq m. d}
               else if Alt_Loadings[Loop]<>nil then AddLoad := Alt_Loadings[Loop].GetLoad(TimeIndex,True);

             AddLoad := AddLoad * Alt_MultLdg[Loop]/SegVolume;
             {mg/L d}    {g/d }     {unitless}       {cu m}
             If Loop=DirectPrecip then AddLoad :=  AddLoad   *  Location.Locale.SurfArea;
                                       {mg/L d}  {mg/sq m. L d}         {sq m.}
             Loading:=Loading + AddLoad;
                     {mg/L d} {mg/L d}
           End; {loop}
     End; {inflow loadings}
End;


Function TOrganism.Respiration : double;
Begin
  Respiration:=0;
End;

{---------------------------------------------------------------------}

procedure TOrganism.CalcRiskConc(warn: Boolean);
 {This procedure should be executed at the beginning of model
  run and also when stratification occurs}

var DataName,ToxRecName: String[15];
    ErrString: String;
    PTR: Pointer;
    Ionized: Boolean;
    StepLoop, i, FoundToxIndx: Integer;
    ATR: TAnimalToxRecord;
    PlantTox: TPlantToxRecord;
    ToxLoop: T_SVType;
    NewTime, LC50_Time,
    Local_K2, MeanAge: Double;
    AnimTox: TToxics;

begin {CalcRiskConc}
   Ptr:=Self;

   For Ionized := False to True do
     Begin
       For StepLoop := 1 to 6 do
         Begin
           AmmoniaDeltaCumFracKill[ionized,StepLoop] := 0;
           AmmoniaDeltaResistant  [ionized,StepLoop] := 0;
         End;
       AmmoniaResistant[ionized]    :=0;
       AmmoniaPrevFracKill[ionized] :=0;
     End;

   For StepLoop := 1 to 6 do
     Begin
       SedDeltaCumFracKill[StepLoop] := 0;
       SedDeltaResistant  [StepLoop] := 0;
     End;
   SedResistant    :=0;
   SedPrevFracKill :=0;

   FOR TOXLOOP := FirstOrgTxTyp to LastOrgTxTyp do
     BEGIN
       LCInfinite[ToxLoop]   := 0;
       For StepLoop := 1 to 6 do
         Begin
           DeltaCumFracKill  [ToxLoop,StepLoop] := 0;
           DeltaResistant[ToxLoop,StepLoop] := 0;
         End;
       PrevFracKill[ToxLoop] := 0;
       Resistant[ToxLoop]    := 0;

       RedGrowth[ToxLoop]    := 0;
       RedRepro[ToxLoop]     := 0;
       FracPhoto[ToxLoop]    := 1.0;

       If IsAnimal then
         Begin
           DataName:=Lowercase(TAnimal(Ptr).PAnimalData^.ToxicityRecord);
           With TAnimal(Ptr) do
              HabitatLimit := AHabitat_Limit;

           If GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol)<> nil then
             Begin
               FoundToxIndx:=-1;
               For i:=0 to ChemPtrs^[ToxLoop].Anim_Tox.Count-1 do
                 Begin
                   ATR := ChemPtrs^[ToxLoop].Anim_Tox.At(i);
                   ToxRecName := Lowercase(ATR.Animal_Name);
                   If (ToxRecName=DataName) then FoundToxIndx:=i;
                 End;

               If FoundToxIndx=-1 Then Raise EAquatoxError.Create('Fatal Parameterization Error:  '+OutputText(NState,SVType,WaterCol,'',False,False,0)+' uses the toxicity record "'
                       + dataname + '" which is not found in the chemical '+  ChemPtrs^[ToxLoop].ChemRec.ChemName
                       +  ' animal toxicity data.  Study cannot be executed.');

               ATR:= ChemPtrs^[ToxLoop].Anim_Tox.At(FoundToxIndx);

               Local_K2 := ATR.Entered_K2;    // Note, User Entered K2 used for LCInfinite

               If Local_K2>96 then Local_K2 := Local_K2 * (96/Local_K2); {scaling factor 10-02-03}

               MeanAge := TAnimal(Ptr).PAnimalData^.LifeSpan;

               If MeanAge<tiny then Raise EAQUATOXERROR.Create('lifespan for '+TAnimal(Ptr).PName^
                                     +' is set to zero.  This parameter must be set for bioaccumulation calculations.');

               If Local_K2 < 0.693 / MeanAge then Local_K2 := 0.693/MeanAge;  {9/9/99}
               {Avoid very small LCInfinite for single year classes and YOY}

               AnimTox := GetStatePointer(NState,ToxLoop,WaterCol);
               AnimTox.InitialLipid;  {Initialize Lipid before LCINF calculation 10-7-99}

               If warn and (ATR.LC50 < tiny) and (ATR.EC50_Repro > 0) and (not AllStates.SetupRec^.UseExternalConcs) then
               with AllStates do
                 Begin
                   ErrString := 'Warning: EC50 Reproduction for ' + TAnimal(Ptr).PName^ +
                              ' within chemical '+ChemPtrs^[ToxLoop].ChemRec.ChemName +
                              ' is greater than zero, but no reproductive effects will be calculated because LC50 is set to zero. '+
                              ' This means that an application factor cannot be calculated (see eqn 420 in the Tech. Doc).';
                   PMessageStr^ := ErrString;
                   PMessageErr^ := True;
                   TSMessage;
                 End;

               If warn and (ATR.LC50 < tiny) and (ATR.EC50_Growth > 0) and (not AllStates.SetupRec^.UseExternalConcs) then
               with AllStates do
                 Begin
                   ErrString := 'Warning: EC50 Growth for ' + TAnimal(Ptr).PName^ +
                              ' within chemical '+ChemPtrs^[ToxLoop].ChemRec.ChemName +
                              ' is greater than zero, but no growth effects will be calculated because LC50 is set to zero. '+
                              ' This means that an application factor cannot be calculated (see eqn 418 in the Tech. Doc).';
                   PMessageStr^ := ErrString;
                   PMessageErr^ := True;
                   TSMessage;
                 End;

               LC50_Time := ATR.LC50_Exp_Time;
               If warn and (LC50_Time<=0) then with AllStates do
                 Begin
                   If TAnimal(Ptr).IsFish then newtime := 96
                                           else newtime := 48;

                   ErrString := 'Warning: LC50 Exposure Time for ' + TAnimal(Ptr).PName^ +
                              ' within chemical '+ChemPtrs^[ToxLoop].ChemRec.ChemName +
                              ' is set to zero.  Replacing zero LC50 Exposure Time with a value of '+
                              IntToStr(Trunc(newtime)) + ' hours.';
                   PMessageStr^ := ErrString;
                   PMessageErr^ := True;
                   TSMessage;
                   LC50_Time:=newtime;
                 End;

               TAnimal(Ptr).Assign_Anim_Tox;

               With ATR do
                 LCINFINITE[ToxLoop] := BCF(LC50_Time/24.0,ToxLoop) * LC50 * (1-Exp(-Local_K2*(LC50_Time/24.0)));
                 {ppb}                 {L/kg}            {h/d}           {ug/L}          {1/d}        {h}      {h/d}

             End; {orgtox code}

         End {end animal code}
       Else  {Organism is Plant}
         Begin
           TPlant(Ptr).IsEunotia := Pos('eunotia',Lowercase(TPlant(Ptr).PAlgalRec^.ScientificName)) > 0;

           DataName:=Lowercase(TPlant(Ptr).PAlgalRec^.ToxicityRecord);
           With TPlant(Ptr) do
              HabitatLimit := PHabitat_Limit;

           If GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol)<> nil then
            With ChemPtrs^[ToxLoop] do
             Begin
               FoundToxIndx:=-1;
               For i:=0 to Plant_Tox.Count-1 do
                 Begin
                   PlantTox := Plant_Tox.At(i);
                   If Lowercase(PlantTox.Plant_Name)=DataName then FoundToxIndx:=i;
                 End;

               If FoundToxIndx=-1 Then Raise EAquatoxError.Create('Fatal Parameterization Error:  '+OutputText(NState,SVType,WaterCol,'',False,False,0)+' uses the toxicity record "'
                       + dataname + '" which is not found in the chemical '+  ChemPtrs^[ToxLoop].ChemRec.ChemName
                       +  ' plant toxicity data.  Study cannot be executed.');

               PlantTox:= ChemPtrs^[ToxLoop].Plant_Tox.At(FoundToxIndx);
               TPlant(Ptr).Plant_Tox[ToxLoop]:=PlantTox;

               Local_K2 := PlantTox.K2;
               If Local_K2>96 then Local_K2 := Local_K2 * (96/Local_K2); {scaling factor 10-02-03}

               (*If TPlant(Ptr)^.PAlgalRec^.PlantType='Macrophytes' then MeanAge := 120
                                                                  else MeanAge := 30;

               If Local_K2 < 0.693 / MeanAge then Local_K2 := 0.693/MeanAge;  {9/9/99}
               {Avoid very small LCInfinite for single year classes and YOY} *)

               LC50_Time := PlantTox.LC50_Exp_Time;
               If warn and (LC50_Time<=0) then with AllStates do
                 Begin
                   PMessageStr^ := 'Warning: LC50 Exposure Time for ' + TPlant(Ptr).PName^ +
                              ' within chemical '+ChemPtrs^[ToxLoop].ChemRec.ChemName +
                              ' is set to zero.  Replacing zero LC50 Exposure Time with a value of 24 hours.';
                   PMessageErr^ := True;
                   TSMessage;
                   LC50_Time:=24;
                 End;

               If warn and (PlantTox.LC50 < tiny) and (PlantTox.EC50_Photo > 0) and (not AllStates.SetupRec^.UseExternalConcs) then
               with AllStates do
                 Begin
                   ErrString := 'Warning: EC50 Photosynthesis for ' + TPlant(Ptr).PName^ +
                              ' within chemical '+ChemPtrs^[ToxLoop].ChemRec.ChemName +
                              ' is greater than zero, but no photosynthesis effects will be calculated because LC50 is set to zero. '+
                              ' This means that an application factor cannot be calculated (see eqn 419 in the Tech. Doc).';
                   PMessageStr^ := ErrString;
                   PMessageErr^ := True;
                   TSMessage;
                 End;


               With PlantTox do
                 LCINFINITE[ToxLoop] := BCF(LC50_Time/24.0,ToxLoop) * LC50 * (1-Exp(-Local_K2*(LC50_Time/24.0)));
                 {ppb}                      {L/kg}       {h/d}           {ug/L}          {1/d}    {h}     {h/d}
             End; {with ChemPtrs}
         End; {Plant code}
     END; {ToxLoop}

end; {CalcRiskConc}
{------------------------------------------------------------------------}

Function TOrganism.BCF(TElapsed: Double; ToxTyp: T_SVType):Double;
Var KB, KOW, KPSed, NondissocVal, Lipid, NondissReduc: Double;
    PA : TAnimal;
    PP : TPlant;
    PT : TToxics;
   { NLOMFrac,} K2 : Double;
    ChemOption: UptakeCalcMethodType;

Const  DetrOCFrac    : Double = 0.526;  {detritus, Winberg et al., 1971}

Begin
  With ChemPtrs^[ToxTyp].ChemRec do
    If IsPFA then              {  -------------------------   PFA CODE BELOW ---------------------------- }
      Begin
        If IsAnimal
          then
            Begin
              PA := TAnimal(Self);
              With PA.Anim_Tox[ToxTyp] do
                Begin if (Entered_K2 < tiny)
                  then Raise EAQUATOXError.Create('K2 values (chemical toxicity screen) must be greater than zero (e.g. '+Animal_name+')')
                  else BCF := Entered_K1 / Entered_K2;
                End   //2/13/2012
            End
{            Begin
              ChainLength := Min(PFAChainLength,11);
              If PFAType = 'carboxylate' then BCF := WetToDry * POWER(10, -5.724  + 0.9146 * ChainLength)
                                         else BCF := WetToDry * POWER(10, -5.195  + 1.03   * ChainLength);
            End  }

          else //isPlant
            If IsAlgae then BCF := PFAAlgBCF
                       else BCF := PFAMacroBCF;

        OrgToxBCF[ToxTyp]:=Result;  {Save for FCM calculation}
        Exit; {PFA CODE COMPLETE}
      End; {PFA CODE}          {  -------------------------   PFA CODE ABOVE ---------------------------- }


  If IsAnimal then ChemOption := ChemPtrs^[ToxTyp].Anim_Method
              else ChemOption := ChemPtrs^[ToxTyp].Plant_Method;

  If ChemOption <> Default_Meth then   { -------------------   BCF = K1 / K2 BELOW  ---------------------------------}
      Begin
        BCF := 0;
        If IsAnimal then
          Begin
            PA := TAnimal(Self);
            With PA.Anim_Tox[ToxTyp] do
              If ChemOption = CalcK1
                then Begin if (Entered_K2 < tiny)
                               then Raise EAQUATOXError.Create('K2 values (chemical toxicity screen) must be greater than zero (e.g. '+Animal_name+')')
                               else BCF := Entered_K1 / Entered_K2;
                     End
                else BCF := Entered_BCF;
          End;
        If IsPlant then
          Begin
            PP := TPlant(Self);
            With PP.Plant_Tox[ToxTyp] do
              If ChemOption = CalcK1
                then Begin if (K2 < tiny)
                               then Raise EAQUATOXError.Create('K2 values (chemical toxicity screen) must be greater than zero (e.g. '+Plant_name+')')
                               else BCF := K1 / K2;
                     End
                else BCF := Entered_BCF;
          End;

        OrgToxBCF[ToxTyp]:=Result;  {Save for FCM calculation}
        Exit; {NON Default Methods}
      End;                             { -------------------   BCF = K1 / K2 ABOVE  ---------------------------------}


  {Default BCF Calculation Below}

  PT := GetStatePointer(AssocToxSV(ToxTyp),StV,WaterCol);
  NonDissocVal:=PT.NonDissoc;
  KOW := ChemPtrs^[ToxTyp].KOW;
  If IsAnimal then
    begin
(*       PA := TAnimal(Self);
       Lipid := PA.CalcLipid;

       NLOMFrac := 1/ WettoDry - Lipid;

       BCF := (Lipid *  KOW + NLOMFrac * 0.035 * KOW * (NondissocVal+0.01)) * WettoDry;
 {KBW, L/kg}  {frac}  {L/kg}   {frac}           {frac}    {frac}              {frac}               *)  //Alternate BCF TURNED OFF 10/15/2010

    PA := TAnimal(Self);  //  Code Prior to 9/8/2010
      if IsFish
       then begin
              Lipid := PA.CalcLipid;

            KB := Lipid * WetToDry * KOW * (NondissocVal+0.01); //  BCF Test 9/8/2010
              K2 := PA.Anim_Tox[ToxTyp].Entered_K2;
              If (K2 < Tiny) //  BCF Test 9/8/2010   Fix this logic, though if LCInfinite is the only thing this is being used for, maybe remove the TElapsed portion
                Then BCF := KB * (1.0 - Exp(-K2 * (TElapsed)))
                Else BCF := KB
            end {fish code}
              else
                If NState in [FirstDetrInv..LastDetrInv]
                   then Begin
                          PT := GetStatePointer(SuspRefrDetr,ToxTyp,WaterCol);
                          KPSed := PT.CalculateKOM;  {Use Schwarzenbach Eqn. for KPSED}
                          BCF := PA.PAnimalData^.FishFracLipid/DetrOCFrac * KPSed {based on Gobas 1993}
                        End
                   else BCF := WetToDry * 0.3663 * POWER(Kow,0.7520) {Southworth et al. 1978}
                               * (NonDissocVal + 0.01); {not detr invert}

    end {animal code}
  else  {Organism is Plant}
    begin
       NondissReduc := NondissocVal + 0.2;
       if NondissReduc > 1.0 then NondissReduc := 1.0;
       if (nstate in [FirstMacro..LastMacro])
         then BCF := 0.00575 * POWER(Kow,0.98) * NonDissReduc {dry wt.}
         else BCF := NondissocVal * 2.57 * POWER(KOW,(0.93)) + (1-NondissocVal) * 0.257 * POWER(KOW,(0.93));
                     {modified from Swackhamer & Skoglund 1993, p. 837}

                  { 7.29 * POWER(KOW,0.681) * NonDissReduc;  }
                  { 0.2 * 5 * KOW * NonDissReduc; } {dry wt.}
                  { 0.2 lipid * WetToDry * KOW, which is Dry}

       With ChemPtrs^[ToxTyp].ChemRec do
         if ISPFA then
           Begin
             if  (nstate in [FirstMacro..LastMacro]) then BCF := PFAMacroBCF
                                                     else BCF := PFAAlgBCF;
           End;
    end; {plant code}

  OrgToxBCF[ToxTyp]:=Result;  {Save for FCM calculation}

End; {BCF Calculation}

{------------------------------------------------------------------------}

Function TOrganism.Poisoned(ToxTyp: T_SVType) : double;

Var TElapsed:   Double; {Time elapsed since exposure to toxicant, days}
    LethalConc: Double; {Time varying LethalConc, ppb}
    Nonresistant, FracKill: Double;
    LifeSpan:   Double; {Lifespan of animal in days}
    AFGrowth, AFRepro, AFPhoto: Double;
    AnimalPtr:  TAnimal;
    LC50_Local, K2_Local: Double;
    CumFracNow: Double;
    NewResist: Double;
    {--------------------------------------------------------------------------}
    Procedure Calculate_Internal_Toxicity;
    Var ToxPPB:     Double; {PPB of the toxicant in the organism}
        ToxinOrg:   Double; {Toxicant in the organism}
        Shape:      Double; {unitless param expressing toxic response variability}
        Cum_Frac_Eqn_Part: Double;
    Begin
      CumFracNow := 0;
      RedGrowth[ToxTyp] := 0.0;  RedRepro[ToxTyp] := 0.0;  FracPhoto[ToxTyp] := 1.0;
      If (LC50_Local<Tiny) then Exit;  // 3/23/2012  if LC50 is zero, no effects, application factors are incalculable so no effects on repro, growth, photosynthesis either

      Shape    := ChemPtrs^[ToxTyp].ChemRec.Weibull_Shape;
      If Shape<=0 then Raise EAquatoxError.Create(PrecText(ToxTyp)+' Shape Parameter must be greater than zero.');

      ToxInOrg := AllStates.GetState(nState,ToxTyp,WaterCol);
      If (ToxInOrg <= 0.0) then exit;

      ToxPPB   := ( ToxInOrg / State ) * 1e6;
      {ug/kg         ug/L   /  mg/L     mg/kg}

      TElapsed := AllStates.CalculateTElapsed(ToxTyp);
      If (LifeSpan>0) and (TElapsed > LifeSpan) then TElapsed := Lifespan;  {JSC 8-12-2003}

      If (ToxPPB <= 0.0) or (TElapsed=0.0) then exit;

      If (K2_Local<tiny)
        then LethalConc := LCInfinite[ToxTyp]
        else If TElapsed > 4.605/K2_Local
          then LethalConc := LCInfinite[ToxTyp]
          else if (1 - Exp (-K2_Local * TElapsed))<0.0001
                  then LethalConc := LCInfinite[ToxTyp]/0.0001     {bullet proof}
                  else LethalConc := LCInfinite[ToxTyp]/(1 - Exp (-K2_Local * TElapsed));
                        {ppb}                   {ppb}                 {1/d}     {d}

     With AllStates do
      If LethalConc=0
        Then
          Begin
              If (ToxPPB>0) then CumFracNow := 1
                            else CumFracNow := 0;
          End
        Else
          If (Toxppb/LethalConc>70) then CumFracNow:= 1
            Else                          {Weibull cumulative equation}
              Begin
                Cum_Frac_Eqn_Part := -POWER(Toxppb /LethalConc,  1/Shape);
                                          {   ppb / ppb         unitless}
                CumFracNow := 1 - exp(Cum_Frac_Eqn_Part);
                if CumFracNow > 0.95 then CumFracNow := 1.0;

                if IsAnimal
                 then begin
                   if AFGrowth < Tiny then  RedGrowth[ToxTyp] := 0 else
                     RedGrowth[ToxTyp] := 1 - exp(-POWER(Toxppb /(LethalConc*AFGrowth), 1/Shape));
                   if AFRepro < Tiny then RedRepro[ToxTyp] := 0 else
                     RedRepro[ToxTyp] := 1 - exp(-POWER(Toxppb /(LethalConc*AFRepro),  1/Shape));
                   end
                 else  {plant}
                   if AFPhoto < Tiny then FracPhoto[ToxTyp] := 1 else
                     FracPhoto[ToxTyp] := exp(-POWER(Toxppb /(LethalConc*AFPhoto),  1/Shape));
              End;

    End;  {Calculate Internal Toxicity}
    {--------------------------------------------------------------------------}
    Procedure Calculate_External_Toxicity;
    Var k,ETA,SlopeFactor,Slope: Double;
        ToxinH2O:   Double; {Toxicant in the water}
    Begin
      CumFracNow := 0;
      SlopeFactor := ChemPtrs^[ToxTyp].ChemRec.WeibullSlopeFactor;
      If SlopeFactor<=0 then Raise EAquatoxError.Create(PrecText(ToxTyp)+' Weibull Slope Factor must be greater than zero.');
      ToxInH2O := GetState(AssocToxSV(ToxTyp),StV,WaterCol);
      If ToxInH2O <0 then exit;

      If LC50_Local>tiny then
        Begin
          Slope := SlopeFactor  / LC50_Local;
        {unitless} {LC50*Slope}   {LC50}
          ETA := (-2*LC50_Local*Slope)/Ln(0.5);
          Try
            k := -ln(0.5)/POWER(LC50_Local,ETA);
            CumFracNow := 1-exp(-k * POWER(ToxinH2O,ETA));
          Except
            Raise EAQUATOXError.Create('Floating Point Error Calculating External Toxicity.  Re-examine input parameters.');
            CumFracNow := 0
          End;
        End;

      If IsAnimal then With AnimalPtr.Anim_Tox[ToxTyp] do
         Begin
            if EC50_Growth < Tiny   // 3/9/2012  Remove Requirement for non-zero LC50 to apply EC50_Growth
              then  RedGrowth[ToxTyp] := 0
              else Begin
                     Slope := SlopeFactor  / EC50_Growth;
                     ETA := (-2*EC50_Growth*Slope)/Ln(0.5);
                     Try
                       k := -ln(0.5)/POWER(EC50_Growth,ETA);
                       RedGrowth[ToxTyp] := 1-exp(-k * POWER(ToxInH2O,ETA));
                     Except
                       Raise EAQUATOXError.Create('Floating Point Error Calculating Growth Limitations due to External Toxicity.  Re-examine input parameters.');
                       RedGrowth[ToxTyp] := 0;
                     End;
                   End;
            if EC50_Repro < Tiny   // 3/9/2012  Remove Requirement for non-zero LC50 to apply EC50_Repro
              then RedRepro[ToxTyp] := 0
              else Begin
                     Slope := SlopeFactor  / EC50_Repro;
                     ETA := (-2*EC50_Repro*Slope)/Ln(0.5);
                     Try
                       k := -ln(0.5)/POWER(EC50_Repro,ETA);
                       RedRepro[ToxTyp] := 1-exp(-k * POWER(ToxInH2O,ETA));
                     Except
                       Raise EAQUATOXError.Create('Floating Point Error Calculating Reproductive Limitations due to External Toxicity.  Re-examine input parameters.');
                       RedRepro[ToxTyp] := 0;
                     End;
                   End;
         End
      Else {IsPlant}
         Begin
           With TPlant(Self).Plant_Tox[ToxTyp] do  {plant}
              if EC50_Photo < Tiny then FracPhoto[ToxTyp] := 0 else  // 3/9/2012  Remove Requirement for non-zero LC50 to apply EC50_Repro
                Begin
                  Slope := SlopeFactor  / EC50_Photo;
                  ETA := (-2*EC50_Photo*Slope)/Ln(0.5);
                  Try
                    k := -ln(0.5)/POWER(EC50_Photo,ETA);
                    FracPhoto[ToxTyp] := exp(-k * POWER(ToxInH2O,ETA));
                  Except
                    Raise EAQUATOXError.Create('Floating Point Error Calculating Photosynthesis Limitations due to External Toxicity.  Re-examine input parameters.');
                    FracPhoto[ToxTyp] := 1
                  End;
                End;
         End;
   End;   {Calculate External Toxicity}
    {--------------------------------------------------------------------------}
Begin
  Poisoned:=0;
  AFGrowth:=0;  AFRepro:=0;  AFPhoto:=0;

  If State=0 then Exit;
  If Not (NState in [FirstBiota..LastBiota]) then Exit;

  If IsAnimal then
    begin
      AnimalPtr := TAnimal(Self);
      With AnimalPtr.Anim_Tox[ToxTyp] do
        Begin
          If AnimalPtr.Anim_Tox[ToxTyp] = nil then exit;
          If LC50<=0.0
            then Begin
                   AFGrowth := 0;
                   AFRepro  := 0;
                 End
            else Begin
                   AFGrowth  := EC50_Growth/LC50;
                   AFRepro   := EC50_Repro/LC50;
                 End;
          LC50_Local := LC50;
          K2_Local  := Entered_K2;
          LifeSpan  := AnimalPtr.PAnimalData^.LifeSpan;
        End;
    end
  else
   With TPlant(Self).Plant_Tox[ToxTyp] do
    Begin
      If TPlant(Self).Plant_Tox[ToxTyp] = nil then exit;
      If LC50<=0.0
          then AFPhoto := 0
          else AFPhoto := EC50_Photo/LC50;

      LC50_Local := LC50;
      K2_Local  := K2;
      LifeSpan := 0 ; {NA}
    End;

  If not AllStates.SetupRec^.UseExternalConcs
    then Calculate_Internal_Toxicity
    else Calculate_External_Toxicity;

  If CumFracNow<=0 then exit;

  {9-14-07 conversion of Resistant from biomass units to fraction units}
     NonResistant := State * (1-Resistant[ToxTyp]);
    {mg/L          mg/L          frac}

  With AllStates do
  if PrevFracKill[ToxTyp] >= CumFracNow
    then FracKill := 0
    else FracKill := (CumFracNow - PrevFracKill[ToxTyp])/(1 - PrevFracKill[ToxTyp]);

  With AllStates do
    Begin
      Poisoned := Resistant[ToxTyp]* State * FracKill + NonResistant * CumFracNow;
      {mg/L-d        frac             mg/L     g/g-d      mg/L            g/g-d }

      NewResist := (State-Result) / State;
       {frac}      {mg/L} {mg/L}   {mg/L}
      DeltaResistant  [ToxTyp,DerivStep] := NewResist - Resistant[ToxTyp] ;
      DeltaCumFracKill[ToxTyp,DerivStep] := CumFracNow - PrevFracKill[ToxTyp];
    End;
end;


{------------------------------------------------------------------------}
Procedure TAnimal.Assign_Anim_Tox;
Var FoundToxIndx, i: Integer;
    ATR: TAnimalToxRecord;
    ToxLoop: T_SVType;
    DataName: String;
Begin
 DataName:=Lowercase(PAnimalData.ToxicityRecord);

 FOR TOXLOOP := FirstOrgTxTyp to LastOrgTxTyp do
  If GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol)<> nil then
   Begin
      FoundToxIndx:=-1;   // 10/27/2009  

      For i:=0 to ChemPtrs^[ToxLoop].Anim_Tox.Count-1 do
         Begin
           ATR := ChemPtrs^[ToxLoop].Anim_Tox.At(i);
           If Lowercase(ATR.Animal_Name)=DataName then FoundToxIndx:=i;
         End;

       If FoundToxIndx=-1 Then Raise EAquatoxError.Create('Error!  '+OutputText(NState,SVType,watercol,'',False,False,0)+' uses the toxicity record "'
               + dataname + '" which is not found in chemical '+ChemPtrs^[ToxLoop].ChemRec.ChemName  + '''s animal toxicity data.  Study cannot be executed.');

       ATR:= ChemPtrs^[ToxLoop].Anim_Tox.At(FoundToxIndx);

       Anim_Tox[ToxLoop]:=ATR;
   End;
End;

{------------------------------------------------------------------------}
Function TAnimal.IsBenthos: Boolean;
Begin
  Result := (PAnimalData^.Animal_Type='Benthic Invert.') or
            (PAnimalData^.Animal_Type='Benthic Insect')
End;
{------------------------------------------------------------------------}
Function TAnimal.WetToDry: Double;
Begin
  WetToDry := PAnimalData^.Wet2Dry;
End;
{------------------------------------------------------------------------}
Function TAnimal.RefugeFrom(Prey:Allvariables): Double;
Const HalfSat  : Double = 100.0;
Var MacroState : Double;
    LoopVal    : AllVariables;
Begin
  MacroState:=0;
  For LoopVal:=FirstMacro to LastMacro do
    If (GetState(LoopVal,StV,WaterCol)>-1)
      then MacroState := MacroState + GetState(LoopVal,StV,WaterCol);

  if (Prey in [FirstAnimal..LastAnimal]) and
    not (PAnimalData^.Animal_Type='Pelagic Invert.') and
    not (Prey in [SedFeeder1, SedFeeder2, Clams1]) {which are infauna} {**}
    {reserve Clams2 for mussels, Corbicula}
      then RefugeFrom := 1 - (MacroState/(MacroState + HalfSat))
      else RefugeFrom := 1;
End;


{------------------------------------------------------------------------}
Function  TOrganism.Predation : double;
{Calculates Predation of the given organism }
{This algorithm now utilizes TAnimal.IngestSpecies (10/31/98)}
Var Prd : double; ns: AllVariables;

    Procedure CalcPredation(P: TStateVariable);
    Var PA : TAnimal;
        EgestRet,GER: Double;
    Begin
      If P.IsAnimal then
       begin
         PA:=TAnimal(P);
         Prd := Prd + PA.IngestSpecies(ns,nil,EgestRet,GER);
       end;
    End;

Var i: Integer;
begin
  Prd:=0;
  Predation:=0;
  If IsAnimal then
    If (TAnimal(Self).IsLeavingSeg) then exit;

   ns := NState;
   If (ns in [PON_G1,POP_G1,POC_G1]) then ns := SedmLabDetr;
   If (ns in [PON_G2,POP_G2,POC_G2]) then ns := SedmRefrDetr;

   With AllStates do For i:=0 to count-1 do
      CalcPredation(at(i));
   Predation:=Prd;
end;
{------------------------------------------------------------------------}

Function TOrganism.Mortality : double;  {overridden}
begin
   Mortality:=0;
end;

{******************************************************************************}

{ TANIMAL METHODS }

constructor TAnimal.Init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                         IC : double; IsTempl: Boolean);
Var ToxLoop: T_SVType;
    Blank: InteractionFields;
    nsloop: AllVariables;
    SVTempl: TStateVariable;
    MigrLoop: Integer;
begin
   SVTempl := Nil;
   If Not IsTempl then SVTempl := P.PStatesTemplate.GetStatePointer(NS,SVT,WaterCol);

   If IsTempl then Begin
                     New(PAnimalData);
                     fillchar(PAnimalData^,SizeOf(PAnimalData^),0);
                   End
              else PAnimalData := TAnimal(SVTempl).PAnimalData;

   MyPrey:= TCollection.Init(6,4);

   Blank.Pref   := 0;
   Blank.ECoeff := 0;
   Blank.XInteraction := '';

   If IsTempl then Begin
                     New(PTrophInt);
                     For nsloop := Cohesives to LastBiota do
                           PTrophInt^[nsloop] := Blank;
                     New(PSameSpecies);
                     PSameSpecies^:=NullStateVar;
                   End
              else Begin
                     PTrophInt := TAnimal(SVTempl).PTrophInt;
                     PSameSpecies := TAnimal(SVTempl).PSameSpecies;
                   End;

   Inherited Init(Ns,SVT,aName,P,IC, IsTempl); {TOrganism}

   Spawned:=False;
   PRequiresData^ := True;
   PromSmFish   := 0;
   EmergeInsect := 0;
   Recruit  := 0;
   RecrSave := 0;
   IsLeavingSeg:=False;
   SumPrey  := 0;
   MortRates.OtherMort := 0;
   For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
        MortRates.OrgPois[ToxLoop] := 0;

   For MigrLoop := 1 to 5 do
     Begin
       MigrInput[MigrLoop].FracMigr := 0;
       MigrInput[MigrLoop].ToSeg := '';
       MigrInput[MigrLoop].DD := 0;
       MigrInput[MigrLoop].MM := 0;
     End;

   Begin
     AnadRec.IsAnadromous := False;
     AnadRec.YearsOffSite := 0;
     AnadRec.DateJuvMigr := 70;
     AnadRec.DateAdultReturn := 100;
     AnadRec.FracMigrating := 0.2;
     AnadRec.MortalityFrac := 0.5;
   End;

   LastO2CalcTime[O2Mortality] := -99;
   LastO2CalcTime[O2Repro_Red] := -99;
   LastO2CalcTime[O2Growth_Red] := -99;
   LastSedCalcTime := -99;

End;

destructor TAnimal.Destroy;
Begin
   If IsTemplate then Begin
                        Dispose(PAnimalData);
                        Dispose(PTrophInt);
                        Dispose(PSameSpecies);
                      End;

   MyPrey.Destroy;
   Inherited Destroy;
end;

procedure  TAnimal.ChangeData;
var Pr : TPreference;
    CMP : StateVariables;
    Pref,Egest: Double;
begin
   {FIX THE UNITS WHICH CHANGE WITH INVERTEBRATE TYPE}
    If (nstate in [FirstInvert..LastInvert]) then
      If (PAnimalData^.Animal_Type='Benthic Invert.') or
         (PAnimalData^.Animal_Type='Benthic Insect') or
         (PAnimalData^.Animal_Type='Fish')
      then begin StateUnit:='g/m2 dry';
                 LoadingUnit:='g/m2 dry';
           end
      else begin StateUnit:='mg/L dry';
                 LoadingUnit:='mg/L dry';
           end;

   MyPrey.FreeAll;
   for CMP := Cohesives to LastBiota do
   begin
     If Cmp in [Cohesives..Salinity,DissRefrDetr,DissLabDetr,BuriedRefrDetr..BuriedLabileDetr] then
       Begin
         Pref:=0; Egest:=0;
       End
     Else
       Begin
         Pref:=PTrophInt^[Cmp].Pref;
         Egest:=PTrophInt^[Cmp].ECoeff;
       End;

     If (Pref>0) { or (Egest>0) } then
        begin
          Pr:=TPreference.init(Pref,Egest,CMP);
          MyPrey.Insert(Pr);
        end;
   end;

end;

Function TAnimal.ReadTrophint(FileNm: String): Boolean;

Var VersionCheck : String[10];
    ReadVers,ThisVers: Real;
    nsLoop     : AllVariables;
    nsRead     : AllVariables;
    FileStream : TFileStream;
    PC_FileN   : Array[0..255] of char;

Begin
  ReadTrophInt := False;

  For nsLoop := Cohesives to LastBiota do
    Begin
      PTrophInt^[nsloop].Pref:=0;
      PTrophInt^[nsloop].ECoeff:=0;
      PTrophInt^[nsloop].XInteraction:='';
    End;

  StrPCopy(PC_FileN,FileNm);
  FileStream := nil;
  Try
    FileStream:=TFileStream.Create(PC_FileN,fmOpenRead);
    FileStream.Read(VersionCheck,Sizeof(VersionCheck));
    ReadVers:=StrToFloat(AbbrString(VersionCheck,' ')); 

    ThisVers:=StrToFloat(AbbrString(VersionStr,' '));
  Except
    MessageDlg('Trophic Interaction file is unreadable.  Cannot read version number.',mterror,[mbOK],0);
    If FileStream<>nil then FileStream.Destroy;
    Exit;
  End; {Try Except}

  If ReadVers>ThisVers
    Then
      Begin
        MessageDlg('Trophic Interaction File  '+ FileNm+' originates from a version higher than this one ('+AbbrString(VersionCheck,' ')+') and is therefore, unreadable.',mterror,[mbOK],0);
        FileStream.Destroy;
        Exit;
      End;

  If ReadVers<ThisVers
    Then MessageDlg('Upgrading '+ FileNm+' trophic interaction file from lower version ('+AbbrString(VersionCheck,' ')+').',mtInformation,[mbOK],0);

  For nsLoop := Cohesives to LastBiota do
    Begin
      PTrophInt^[nsloop].Pref:=0;
      PTrophInt^[nsloop].ECoeff:=0;
      PTrophInt^[nsloop].XInteraction:='';
    End;

  Repeat
    FileStream.Read(nsRead, Sizeof(AllVariables));
    If ReadVers<3.39 then
        nsread := UpdateNState(nsread,ReadVers);

    If (nsRead<>nullstatevar) then
      Begin
        If not (Nsread in [Cohesives..LastBiota]) then
          Begin
            MessageDlg('Error reading '+ FileNm+' trophic interaction file.',mtError,[mbOK],0);
            FileStream.Destroy;
            Exit;
          End;    
        FileStream.Read(PTrophInt^[nsRead].Pref, Sizeof(Double));
        FileStream.Read(PTrophInt^[nsRead].ECoeff, Sizeof(Double));
        FileStream.Read(PTrophInt^[nsRead].XInteraction, Sizeof(PTrophInt^[nsRead].XInteraction));
      End;
  Until (nsRead = NullStateVar) or (FileStream.Position >= FileStream.Size) ;

  FileStream.Destroy;

  ReadTrophInt := True;
End;

Procedure TAnimal.WriteTrophint(FileNm: String);
Var nsLoop: AllVariables;
    null  : AllVariables;
    FileStream: TFileStream;
    PC_FileN   : Array[0..255] of char;
    VersionWrite: String[10];

Begin
  StrPCopy(PC_FileN,FileNm);

  Try
    FileStream:=TFileStream.Create(PC_FileN,fmCreate);
  Except
    MessageDlg(Exception(ExceptObject).Message,mterror,[mbOK],0);
    Exit;
  End; {Try Except}

  VersionWrite:=VersionStr;
  FileStream.Write(VersionWrite,Sizeof(VersionWrite));
  For nsLoop := Cohesives to LastBiota do
    Begin
      FileStream.Write(nsloop, Sizeof(AllVariables));
      FileStream.Write(PTrophInt^[nsLoop].Pref, Sizeof(Double));
      FileStream.Write(PTrophInt^[nsLoop].ECoeff, Sizeof(Double));
      FileStream.Write(PTrophInt^[nsLoop].XInteraction, Sizeof(PTrophInt^[nsLoop].XInteraction));
    End;

    Null := NullStateVar;
    FileStream.Write(Null,Sizeof(AllVariables));
    FileStream.Destroy;
End;



{---------------------------process equations--------------------------}

(*************************************)
(* consumption of prey by predator   *)
(*   after Park et al., 1978         *)
(*************************************)

Procedure TAnimal.CalculateSumPrey;
Var SumPrefPrey, SumTerm, PreyState : double;

    Procedure SumP(P: TPreference);
    Begin
     if P.Preference>0 then
       begin
         If (P.NState in [SedmRefrDetr, SedmLabDetr]) and AllStates.Diagenesis_Included {diagenesis model included}
            then PreyState := AllStates.Diagenesis_Detr(P.nstate)
            else PreyState := GetState(P.nstate,StV,WaterCol);     {mg/L wc}

         SumTerm := P.Preference * (PreyState-BMin_in_mg_L) * RefugeFrom(P.NState);

         If SumTerm<0 then SumTerm:=0;
         SumPrefPrey := SumPrefPrey + SumTerm;
       end;
    End;

Var i: Integer;
begin
  SumPrefPrey:=0;
  if (MyPrey.Count>0) then With MyPrey do For i:=0 to count-1 do
                                                      SumP(at(i));
  SumPrey:=SumPrefPrey;
end;

Function TOrganism.GutEffOrgTox(ToxTyp: T_SVType): Double;
Var GutEff: Double;
Begin
  With ChemPtrs^[ToxTyp].ChemRec do
   If IsPFA then
     begin
        If PFAType = 'carboxylate' then GutEff := POWER(10,-0.909539+0.085141*PFAChainLength)
                     {sulfonate}   else GutEff := -0.68+0.21*PFAChainLength;
        If (GutEff > 1.0) then GutEff := 1.00;
        GutEffOrgTox := GutEff;
     End
  {Non PFA code below}
  else If (NState in [FirstInvert..LastInvert])  then GutEffOrgTox:=0.35  {Landrum et al. 1990}
  else If (NState in [LgGameFish1..LgGameFish4]) then GutEffOrgTox:=0.92
                                                 else GutEffOrgTox:=0.62;
End;



Function TAnimal.DefecationTox(ToxType: ToxicantType): Double;
{Returns rate of transfer of organic and mercury toxicant due to defecation by predator}
{This algorithm now utilizes TAnimal.IngestSpecies (11/20/98)}

Var   DefToxCount: Double;
      EgestRet,GutEffRed   : Double;

     Procedure DefTox(P: TPreference);
     Var Ingestion : Double;
         KEgest    : Double;
         PPBPrey   : Double;
     Begin
       Ingestion:=IngestSpecies(P.NState,P,EgestRet,GutEffRed);

       KEgest  := (1-GutEffOrgTox(ToxType)*GutEffRed) * Ingestion;

        With AllStates do
           PPBPrey := GetPPB(P.NState,ToxType,WaterCol);

        DefToxCount := DefToxCount + KEgest * PPBPrey * 1e-6;
                                     {mg/L-d   ug/kg   kg/mg}
     end;

Var i: integer;
begin
  DefToxCount:=0;
  if (MyPrey.Count>0) then With MyPrey do For i:=0 to count-1 do
                                                      DefTox(at(i));
  DefecationTox:=DefToxCount;
end;


Function TAnimal.AHabitat_Limit: Double;

Var HabitatAvail, PctRun, PrefRun: Double;
Begin
  AHabitat_Limit := 1.0;
  If Location.SiteType <> Stream then exit;

  With Location.Locale do With PAnimalData^ do
    Begin
      PctRun := 100 - PctRiffle - PctPool;
      PrefRun := 100 - PrefRiffle - PrefPool;

      HabitatAvail := 0;
      if PrefRiffle>0 then HabitatAvail := HabitatAvail + PctRiffle/100;
      if PrefPool>0   then HabitatAvail := HabitatAvail + PctPool/100;
      if PrefRun>0    then HabitatAvail := HabitatAvail + PctRun/100;
    End;

  AHabitat_Limit := HabitatAvail;
End;



Function TAnimal.BMin_in_mg_L: Double;
Begin
   If  (PAnimalData^.Animal_Type<>'Pelagic Invert.')  {already in mg/L}
     then BMin_In_mg_L := PAnimalData^.BMin / AllStates.Volume_Last_Step * Location.Locale.SurfArea
                 {mg/L}             {g/m2}                    {m3}                          {m2}
     else BMin_In_mg_L := PAnimalData^.BMin;
                                    {mg/L}
End;

Function TAnimal.AggregateRedGrowth: Double;
Var ToxLoop: T_SVType;
    AggRedGrowth: Double;
Begin
  AggRedGrowth := 0;
  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
    If GetStatePointer(NState,ToxLoop,WaterCol) <> nil then
       AggRedGrowth := AggRedGrowth + RedGrowth[ToxLoop];

  If AggRedGrowth > 1.0 then AggRedGrowth := 1.0;

  AggregateRedGrowth := AggRedGrowth;
End;

Function TAnimal.AggregateRedRepro: Double;
Var ToxLoop: T_SVType;
    AggRedRepro: Double;
Begin
  AggRedRepro := 0;
  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
    If GetStatePointer(NState,ToxLoop,waterCol) <> nil then
       AggRedRepro := AggRedRepro + RedRepro[ToxLoop];

  AggredRepro := AggRedRepro + O2EffectFrac(O2Repro_Red);

  If AggRedRepro > 1.0 then AggRedRepro := 1.0;

  AggregateRedRepro := AggRedRepro;
End;


Function TAnimal.IngestSpecies(Prey: StateVariables; PPref: TPreference; Var EgestReturn, GutEffRed:Double): Double;
{ Returns amount of ingestion of a specific species by the animal                    }

{ If Preference is not passed (i.e. PPref=nil) GetPref finds the appropriate preference record }
{ This allows for combined optimization of coding and increased modularity           }

Var  IngestS,Pref, Food, PreyState: Double;
     SSedEffect, SaltEffect, AggRG: Double;

     {--------------------------------------------------}
     procedure GetPref(P: TPreference);
     Begin
       If (P.nstate=Prey) then
         Begin
           Pref := P.Preference;
           EgestReturn := P.Egestcoeff;
         End;
     End;
     {--------------------------------------------------}
     Function FoodDilution: Double;
     Var SurfArea, SandC, Sed, FdSub, PConstant: Double;
     Begin
      With PAnimalData^ do
       Begin
         FdSub := Food;
                 {mg/L}
         Sed := 0;
           If (Guild_Taxa = 'Susp Feeder') or
              (Guild_Taxa = 'Clam') then
                Begin
                   Sed := AllStates.InorgSedConc(False);
                   SandC := GetState(Sand,StV,WaterCol) + GetState(NonCohesives2,StV,WaterCol);
                   If  SandC > 0 then Sed := Sed - SandC; {Dilution Effects are only based on Silt and Clay}
                                     {mg/L}
                End;

         With PAnimalData^ do
           If (Guild_Taxa = 'Sed Feeder') or
              (Guild_Taxa = 'Snail') or
              (Guild_Taxa = 'Grazer') then
                Begin
                  If (Guild_Taxa = 'Sed Feeder')
                    then PConstant := 0.001  { RAP 5/6/2009 }
                    else PConstant := 0.01;  { account for the fact that snails & grazers feed
                                               periphyton above the depositional surface }

                  SurfArea := Location.Locale.SurfArea;
                   {m2}                         {m2}
                  Sed := AllStates.InorgSedDep(False) * 1000    * PConstant;
                 {g/m2}               {kg/m2}           {g/kg}  {Proportionality Constant}

                  FdSub := Food  * AllStates.Volume_Last_Step / SurfArea;
                  {g/m2}  {g/m3}                 {m3}              {m2}
                End;

         IF Sed>0 then FoodDilution := FdSub / (FdSub + Sed * (1-Sorting))
                  else FoodDilution := 1.0;
       End; {with}
     End;
     {--------------------------------------------------}
     Procedure Calc_GutEffRed;
     Begin
       GutEffRed := 1-AggRG;
     End;
     {--------------------------------------------------}
Var i: integer;
    InorgSed, RedGrow : double;
begin  {ingestspecies}
  IngestS:=0; Pref:=0; Food:=0; IngestSpecies:=0; EgestReturn:=0;

  If (Prey in [SedmRefrDetr, SedmLabDetr]) and AllStates.Diagenesis_Included {diagenesis model included}
       then PreyState := AllStates.Diagenesis_Detr(Prey)
       else PreyState := GetState(Prey,StV,WaterCol);     {mg/L wc}

  If PreyState <=0 then exit;

  If PPref <> nil then begin
                         Pref:=PPref.Preference;
                         EgestReturn := PPref.EgestCoeff;
                       end
                  else if (MyPrey.Count>0)
                     then With MyPrey do For i:=0 to count-1 do
                                                GetPref(at(i));

  If (Pref>0) then
    Food := (PreyState-BMin_in_mg_L) * RefugeFrom(Prey);

  If (Food>Tiny) then Food := Food * FoodDilution;

  AggRG := AggregateRedGrowth;
  RedGrow := (0.2 * AggRG) + O2EffectFrac(O2Growth_Red);
  If RedGrow > 1.0 then RedGrow := 1.0;

  if (Pref > 0.0) and (Food > 0.0)
             then  With PAnimalData^ do
               begin
                 IngestS := MaxConsumption * AllStates.TCorr(Q10,TRef,TOpt,TMax)
                            * Pref * Food /(SumPrey + FHalfSat)
                            * (1 - RedGrow) * State * HabitatLimit;

                 If IngestS>Food then IngestS:=Food;
                 If IngestS<0 then IngestS:=0;
               end;

  With PAnimalData^ do
    SaltEffect := AllStates.SalEffect(Salmin_Ing,SalMax_Ing,Salcoeff1_Ing,Salcoeff2_Ing);

  SSedEffect := 1;
  With PAnimalData^ do
   If SuspSedFeeding then
     Begin
      InorgSed := AllStates.InorgSedConc(False);
       If InorgSed > tiny
         then SSedEffect := SlopeSSFeed * LN(AllStates.InorgSedConc(False))+InterceptSSFeed
         else SSedEffect := 1.0;

       If SSedEffect>1 then SSedEffect := 1;
       If SSedEffect<0 then SSedEffect := 0;
     End;

  IngestSpecies := IngestS * SaltEffect * SSedEffect;      // revised 4/21/09

  Calc_GutEffRed;

end;

Function TAnimal.MaxConsumption: Double;
Begin
  With PAnimalData^ do
    If IsFish and UseAllom_C
      then MaxConsumption := CA * POWER(MeanWeight,CB)
      else MaxConsumption := CMax;
End;

Function TAnimal.EatEgest(Which : EatOrEgest): double;
{This procedure now utilizes TAnimal.IngestSpecies (11/20/98)}
Var EECount, Ingestion, IncrEgest, EgestRet, GER, IngestNoTox : double;

    Procedure EatE(P: TPreference);
    Var PSV:TStateVariable;
        Nutr2Org: Double;
    Begin
      PSV := GetStatePointer(P.NState,StV,WaterCol);

      If (P.Preference=0) or ((PSV=nil) and not (P.NState in [SedmRefrDetr,SedmLabDetr]))
        then
          begin
            Ingestion   := 0;
            IngestNoTox := 0;
          end
        else
          begin
            Ingestion   := IngestSpecies(P.NState,P,EgestRet,GER);
            IngestNoTox := Ingestion / (1 - (0.2 * AggregateRedGrowth));  {toxicant effect is removed from ingestion calculation}

            With Location.Remin do
            If PSV<>nil then Nutr2Org := PSV.NutrToOrg(Nitrate)
                        else If P.NState = SedmRefrDetr then Nutr2Org := N2Org_Refr  {diagenesis model special code}
                                           {SedmLabDetr} else Nutr2Org := N2OrgLab;
            NitrCons := NitrCons + Ingestion * Nutr2Org;

            With Location.Remin do
            If PSV<>nil then Nutr2Org := PSV.NutrToOrg(Phosphate)
                        else If P.NState = SedmRefrDetr then Nutr2Org := P2Org_Refr  {diagenesis model special code}
                                           {SedmLabDetr} else Nutr2Org := P2OrgLab;
            PhosCons := PhosCons + Ingestion * Nutr2Org ;
          end;

      if Which=Eat then EECount := EECount + Ingestion
                   else begin
                          IncrEgest := (1 - P.EgestCoeff) * 0.8 * AggregateRedGrowth;
                          EECount := EECount + (Ingestion * P.EgestCoeff) + (IngestNoTox * IncrEgest);
                        end;
    end;


Var i: Integer;
begin
   EECount:=0;
   NitrCons := 0; PhosCons :=0;
   if (MyPrey.Count>0) then With MyPrey do For i:=0 to count-1 do
                                                      EatE(at(i));
   EatEgest:=EECount;
end;

Function TAnimal.Consumption : double;
var Consume : double;
begin

  if State < Tiny then
    Consume := 0.0
  else
    Consume:=EatEgest(Eat);

  Consumption:=Consume;
end; {consume}

Function TAnimal.Defecation : double;
var Defecate : double;
Begin
  if (State < Tiny) or (IsLeavingSeg) then
    Defecate := 0.0
  else
    Defecate  := EatEgest(Egest);
  Defecation:=Defecate;
End; {Defecation}

(*************************************)
(*     Loss due to respiration       *)
(*       last modified 9/23/03       *)
(*************************************)
Function TAnimal.Respiration : double;
Var     SpecDynAction, SaltEffect,
        Respire, BasalResp  : Double;
        StdResp    : Double;
        RoutineResp: Double;
        Activity   : Double;
        TCorr, TFn : Double;
        Temp       : Double;
        Vel        : Double;
        DensityDep : Double;
Const   IncrResp = 0.5;  //modified 6/22/2009
Begin
  if (State < Tiny) or (IsLeavingSeg) then
    Respire := 0.0
  else
   with PAnimalData^ do
    begin
      TCorr := AllStates.TCorr(Q10,TRef,TOpt,TMax); {Stroganov}
      RoutineResp := EndogResp;     {legacy name elsewhere in code}
      SpecDynAction := KResp * (Consumption - Defecation);  {Hewett & Johnson '92}

      If IsFish then DensityDep := 1 + (IncrResp * State)/KCap_in_g_m3  {Kitchell et al., 1974; Park et al., 1974.  Account for Crowding}
                else DensityDep := 1;

      If IsFish and UseAllom_R  {allometric resp currently implemented for fish only}
        then
          Begin
            If UseSet1
              then
                Begin
                  Temp     := GetState(Temperature,StV,WaterCol);
                  TFn      := exp (RQ * Temp);
                  If Temp > RTL then Vel := RK1 * POWER(MeanWeight,RK4)
                                else Vel := ACT * exp(BACT * Temp) * POWER(MeanWeight,RK4);
                  Activity := exp(RTO * Vel)
                End
              else
                Begin
                  Activity := ACT; {Set 2}
                  TFn := TCorr;
                End;
            BasalResp := RA * 1.5;  {conversion from O2 to organic matter}
            StdResp := State * BasalResp * POWER(MeanWeight,RB) * TFn * DensityDep * Activity;
                     { <-------------------- STDRESP_PRED -------------------- > < ActiveResp_PRED >}
          End
        else  {not fish or not use allometric fish respiration calculation}
            StdResp := RoutineResp * TCorr * State * DensityDep;
      Respire := SpecDynAction + StdResp;

    end; {with animaldata}

  With PAnimalData^ do
    SaltEffect := AllStates.SalEffect(Salmin_Rsp,SalMax_Rsp,Salcoeff1_Rsp,Salcoeff2_Rsp);

  Respiration:=Respire*SaltEffect;
End;


{KCAP In proper units... 10-30-01, jsc}

Function TAnimal.KCAP_in_g_m3 : double;
Var EpiBenthicArea: Double;
Begin
  KCAP_in_g_m3 :=  PAnimalData^.KCap;
  {mg/L}                       {mg/L if pelagic}
  If PAnimalData^.Animal_Type = 'Pelagic Invert.' then Exit;  {pelagic KCAP already in g/m3}

  With AllStates do
    If (not stratified) or (linkedmode)
      then KCAP_in_g_m3 := PAnimalData^.KCap  / StaticZMean   {note, deeper sites have lower g/m3 KCAP}
              {g/m3}                   {g/m2}        {m}
      else
        Begin  {carrying capacity must be split up based on epi benthic area, like the vars are}
          If VSeg=Hypolimnion then EpiBenthicArea := EpiSegment.BenthicArea
                              else EpiBenthicArea := BenthicArea;
          KCap_in_g_m3 := PAnimalData^.KCap * (1-EpiBenthicArea) / InitMeanThick;
            {g/m3}                   {g/m2}          {frac}              {m}
        End;
End;


(*************************************)
(*     Loss due to excretion         *)
(*************************************)

Function TAnimal.AnimExcretion: double;
Begin
  if (State < Tiny) or (IsLeavingSeg) then
    AnimExcretion:= 0.0
  else
    AnimExcretion := PAnimalData^.KExcr * Respiration;
End;

(*************************************)
(*   Loss due to ammonia toxicity    *)
(*************************************)

Function TAnimal.AmmoniaMortality(ionized:boolean): Double;

    Function External_Mort(LC50,Conc:Double): Double;
    Var k,ETA,Slope: Double;
    Begin
      If Conc<0 then Conc := 0;  {bullet proof}
      Slope :=     0.7   / LC50;
    {unitless} {LC50*Slope}   {LC50}
      ETA := (-2*LC50*Slope)/Ln(0.5);
      Try
        k := -ln(0.5)/POWER(LC50,ETA);
        External_Mort := 1-exp(-k * POWER(Conc,ETA));
      Except
        Raise EAQUATOXError.Create('Floating Point Error Calculating Ammonia Toxicity.  Re-examine input parameters.');
      End;
    End;

Const pHt = 7.204;
      R   = 0.00704;
Var AmmoniaLC50: Double;
    TKelvin, pkh, Ammonia_Conc,UnIonNH3,pHval: Double;
    NewResist, AmmoniaNonResistant, CumFracNow, FracKill: Double;
Begin  {AmmoniaMortality}
  AmmoniaMortality := 0;
  AmmoniaLC50 := PAnimalData^.Ammonia_LC50;
  If AmmoniaLC50 < tiny then
    Begin
      exit;
    End;

  pHval := GetState(ph,stv,waterCol);

  If Ionized
    then AmmoniaLC50{ionized}   := (AmmoniaLC50/((R/((1+POWER(10,pHt-8)))+(1/(1+POWER(10,8-pHt))))))*(1/(1+POWER(10,pHval-pHt)))
    else AmmoniaLC50{unionized} := (AmmoniaLC50/((R/((1+POWER(10,pHt-8)))+(1/(1+POWER(10,8-pHt))))))*(R/(1+POWER(10,pHt-pHval)));

  Ammonia_Conc := GetState(Ammonia,StV,WaterCol);
  TKelvin := 273.16 + GetState(Temperature,StV,WaterCol);
  pkh := 0.09018 + 2729.92/TKelvin;
  UnIonNH3 := Ammonia_Conc/(1 + POWER(10, (pkh - GetState(pH,StV,WaterCol))));
             {mg/L}{      fraction that is un-ionized     }

  If Ionized then CumFracNow := External_Mort(AmmoniaLC50,Ammonia_Conc-UnIonNH3)
             else CumFracNow := External_Mort(AmmoniaLC50,UnIonNH3);

  If CumFracNow<Tiny then exit;

  {9-17-07 conversion of Resistant from biomass units to fraction units}
   AmmoniaNonResistant := State * (1-AmmoniaResistant[ionized]);
           {mg/L          mg/L          frac}

  if AmmoniaPrevFracKill[ionized] >= CumFracNow
    then FracKill := 0
    else FracKill := (CumFracNow - AmmoniaPrevFracKill[ionized])/(1 - AmmoniaPrevFracKill[ionized]);

  With AllStates do
    Begin
      AmmoniaMortality := AmmoniaResistant[ionized] * State *FracKill + AmmoniaNonResistant * CumFracNow;
         {mg/L-d               frac                   mg/L    g/g-d        mg/L                 g/g-d }

      NewResist := (State-Result) / State;
       {frac}      {mg/L} {mg/L}   {mg/L}
      AmmoniaDeltaResistant  [ionized,DerivStep] := NewResist - AmmoniaResistant[ionized] ;
      AmmoniaDeltaCumFracKill[ionized,DerivStep] := CumFracNow - AmmoniaPrevFracKill[ionized];
    End;

End;

(*************************************)
(* Loss due to low oxygen            *)
(*************************************)
Function TAnimal.O2EffectFrac(O2Eff:TO2Effects): double;
Const CALCTIMES: array [0..5] of integer = (1,4,12,24,48,96) {hours};
      CALCSTART1Day = 3;
      CALCSTOP      = 5;
Var CalcIteration, Cstart, i : Integer;
    CalcTime, EffectFrac, EffectPct: Double;
    TimePassed, MaxO2, Intercept: Double;
    O2EffectConc, O2EffectPct: Double;
    PO2: TSVConc;
    OverTime, Foundone: Boolean;
Begin
  {optimization}
  If AllStates.TPresent = LastO2CalcTime[O2Eff] then
     Begin
       O2EffectFrac := LastO2Calc[O2Eff];
       Exit;
     End;

  With PAnimalData^ do
    Begin
      Case O2Eff of
        O2Mortality : O2EffectConc := O2_LethalConc;
        O2Growth_Red: O2EffectConc := O2_EC50growth;
        else          O2EffectConc := O2_EC50repro;
      end; {case}
      O2EffectPct := 50;
      If O2Eff=O2Mortality then O2EffectPct := O2_LethalPct;
    End;

  EffectFrac := 0;
  O2EffectFrac := 0;

  With PAnimalData^ do
    If (O2EffectConc = 0) or
       (O2EffectPct > 99.9) or (O2EffectPct < 0.1) then exit;

  If AllStates.PModelTimeStep^ = TSHourly
    Then CStart := 0
    Else CStart := CALCSTART1Day;

  For CalcIteration := CStart to CALCSTOP do
    Begin
      CalcTime := CALCTIMES[CalcIteration];
      MaxO2 := GetState(Oxygen,StV,WaterCol);
      i := 0;
      OverTime := False;
      Foundone := False;

      With AllStates.PO2Concs do
        If Count>0 then
          Repeat
            PO2 := At(i);
            TimePassed := AllStates.TPresent - PO2.Time;
            If (TimePassed - 0.001) > (CalcTime/24)
               {  days      (min) }   {hours / h/d}
              Then OverTime := True
              Else Begin
                     If (CalcIteration=CStart)  {only evaluate longer times if enough data exist to support them}
                        then Foundone := True
                        else if (TimePassed > CALCTIMES[CalcIteration-1]/24) then Foundone := True;

                     If PO2.SVConc>MaxO2
                        then MaxO2 := PO2.SVConc; {find max during time period}
                   End;
            inc(i);
          Until (i=count) or OverTime;

      If Foundone then {must have enough of a time-record of O2 to make a comparison}
        Begin
          With PAnimalData^ do
            Intercept := O2EffectConc + (0.007*O2EffectPct);
          EffectPct := (((MaxO2-0.204+0.064*LN(CalcTime))/(0.191*LN(CalcTime)+0.392))-Intercept)/-0.007;

          If EffectPct>100 then EffectPct := 100;
          If EffectPct<0   then EffectPct := 0;
          If (EffectFrac*100< EffectPct) then EffectFrac := EffectPct / 100; {choose highest effect of time-periods evaluated}
        End;
    End;

  {Optimization}
  LastO2CalcTime[O2Eff] :=  AllStates.TPresent;
  LastO2Calc[O2Eff] := EffectFrac;

  O2EffectFrac := EffectFrac;
End;


Function TAnimal.Sediment_Mort: double;
{Fraction of mortality due to elevated sediment in a given time-step}

Const CALCTIMES: array [0..4] of double = (1,2,7,14,21) {days};
      CALCSTOPTOL   = 1;
      CALCSTOP      = 4;

Var SlopeSS, InterceptSS, SlopeTime: Double;
    ThisCumFrac, MaxCumFrac, NewResist, SedNonResistant, FracKill: Double;
    CStop, CalcIteration, i: Integer;
    TimePassed, CalcTime, MinSS: Double;
    OverTime, Foundone: Boolean;
    PSS: TSVConc;
Begin
  MaxCumFrac    := 0;
  Sediment_Mort := 0;
  If Not IsFish then Exit;

  {optimization}
  If AllStates.TPresent = LastSedCalcTime then
     Begin
       Sediment_Mort := LastSedCalc;
       Exit;
     End;

  If IsFish and (PAnimalData^.SenstoSediment <> 'Zero Sensitivity') then
    Begin
      CStop := CALCSTOPTOL; SlopeSS:= 1.62;  InterceptSS:= -14.2;  SlopeTime := 3.5;  {'Tolerant'}
                                      
      If PAnimalData^.SenstoSediment = 'Sensitive' then         {'Sensitive'}
        Begin  SlopeSS:=0.34;   InterceptSS:= -1.85;  SlopeTime:=0.1; CStop := CALCSTOP End;

      If PAnimalData^.SenstoSediment = 'Highly Sensitive' then  {'Highly Sensitive'}
        Begin  SlopeSS:=0.328; InterceptSS:=-1.375;  SlopeTime :=0.1; CStop := CALCSTOP End;

      For CalcIteration := 0 to CStop do
        Begin
          CalcTime := CALCTIMES[CalcIteration];
          MinSS := AllStates.InorgSedConc(False);
          i := 0;
          OverTime := False;
          Foundone := False;

          With AllStates.PSedConcs do
            If Count>0 then
              Repeat
                PSS := At(i);
                TimePassed := AllStates.TPresent - PSS.Time;
                If (TimePassed - 0.001) > (CalcTime)
                   {  days      (min) }     {d}
                  Then OverTime := True
                  Else Begin
                         If (CalcIteration=0)  {only evaluate longer times if enough data exist to support them}
                            then Foundone := True
                            else if (TimePassed > CALCTIMES[CalcIteration-1]) then Foundone := True;

                         If PSS.SVConc<MinSS
                            then MinSS := PSS.SVConc; {find minimum during time period}
                       End;
                inc(i);
              Until (i=count) or OverTime;

          If Foundone and (MinSS>tiny) then {must have enough of a time-record of TSS to make a comparison}
            Begin
              ThisCumFrac := SlopeSS * ln(MinSS) + InterceptSS + SlopeTime * ln(CalcTimes[CalcIteration]);
              If ThisCumFrac > MaxCumFrac then MaxCumFrac := ThisCumFrac;
            End; {foundone}
        End;  {calciteration}

      If MaxCumFrac<Tiny then exit;

      SedNonResistant := State * (1- SedResistant);
         {mg/L            mg/L             frac}

      if SedPrevFracKill >= MaxCumFrac
        then FracKill := 0
        else FracKill := (MaxCumFrac - SedPrevFracKill)/(1 - SedPrevFracKill);

      With AllStates do
        Begin
          Sediment_Mort := SedResistant * State * FracKill + SedNonResistant * MaxCumFrac;
             {mg/L-d           frac       mg/L     g/g-d        mg/L             g/g-d }

          NewResist := (State-Result) / State;
           {frac}      {mg/L} {mg/L}   {mg/L}
          SedDeltaResistant  [DerivStep] := NewResist - SedResistant ;
          SedDeltaCumFracKill[DerivStep] := MaxCumFrac - SedPrevFracKill;
        End;

    End; {IsFish}

  {Optimization}
  LastSedCalcTime := AllStates.TPresent;
  LastSedCalc     := Result;

End;

(*************************************)
(* Loss due to nonpredatory mortality*)
(*************************************)


Function TAnimal.Mortality: double;

Var Dead, Pois : double;
    ToxLoop: T_SVType;
Begin
  If (State < Tiny) or (IsLeavingSeg) 
    then Dead := 0.0
    else
      With PAnimalData^ do
        Begin
          Dead := KMort * State;
        {mg/L-d   g/g-d    mg/L}

          If GetState(Temperature,StV,WaterCol) > TMax then
              Dead := (KMort + EXP(GetState(Temperature,StV,WaterCol) - TMax)/2.0) * State;

          If SenstoPctEmbed and (AllStates.PercentEmbedded > PctEmbedThreshold) then Dead := State;
             {If site's percent embeddedness exceeds the threshold then assume 100% mortality}

          With MortRates do
            Begin
              OtherMort := Dead;
              O2Mort := O2EffectFrac(O2Mortality) * State;
              {mg/L-d     g/g-d                     mg/L}

              NH4Mort := AmmoniaMortality(true);  {NH4+ is ionized}
              NH3Mort := AmmoniaMortality(false); {NH3 is unionized}
              {mg/L-d         mg/L-d }

              Dead := Dead + O2Mort + NH4Mort + NH3Mort;
             {mg/L-d}       {mg/L-d}
            End;

          With PAnimalData^ do
            MortRates.SaltMort := State * SalMort(Salmin_Mort,SalMax_Mort,Salcoeff1_Mort,Salcoeff2_Mort);
          Dead := Dead + MortRates.SaltMort;
         {mg/L-d}                   {mg/L-d}
          For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
           If GetState(AssocToxSV(ToxLoop),StV,WaterCol)>0 then
            Begin
              Pois := Poisoned(ToxLoop);
              MortRates.OrgPois[ToxLoop] := Pois;
              Dead :=   Dead  +  Pois;
            {mg/L-d}  {mg/L-d} {mg/L-d}
            End;

          MortRates.SedMort := Sediment_Mort * state;
          Dead := Dead + MortRates.SedMort;

          If Dead > State then Dead := State;
           {mg/L-d} {mg/L}
        End;

  Mortality := ABS(Dead);
End;  {TAnimal.Mortality}



(************************************)
(* Loss due to mortality of gametes *)
(************************************)

Function TAnimal.SpawnNow: Boolean;
Var TOptSpawn: Double;
{Returns true if due to temperature range or date, this species could spawn on this day}
Var TempEpi, TempHypo: Double;
   {--------------------------------------------------------------------}
    Function InTempRange: Boolean;
    Begin
      InTempRange := (((TempEpi  >= 0.6 * TOptSpawn) and (TempEpi  <= (TOptSpawn - 1.0)))
                   or ((TempHypo >= 0.6 * TOptSpawn) and (TempHypo <= (TOptSpawn - 1.0))));
    End;
    {--------------------------------------------------------------------}
    Function ThisIsSpawningDate: Boolean;
    Var UseDate1,UseDate2,UseDate3: Boolean;
        JulianNow: Integer;
    Begin
      With PAnimalData^ do
        Begin
          JulianNow := JulianDate(AllStates.TPresent);
          UseDate1 := ((UnlimitedSpawning) or (SpawnLimit>0)) and (SpawnDate1<>0);
          UseDate2 := ((UnlimitedSpawning) or (SpawnLimit>1)) and (SpawnDate2<>0);
          UseDate3 := ((UnlimitedSpawning) or (SpawnLimit>2)) and (SpawnDate3<>0);

          ThisIsSpawningDate :=
            ((JulianNow=JulianDate(SpawnDate1)) and UseDate1) or
            ((JulianNow=JulianDate(SpawnDate2)) and UseDate2) or
            ((JulianNow=JulianDate(SpawnDate3)) and UseDate3);
        End;
    End;
    {--------------------------------------------------------------------}
Begin
  AllStates.GetTemperatures(TempEpi,TempHypo);

  If nstate<>Fish1 then TOptSpawn := PAnimalData^.TOpt
                   else TOptSpawn := TAnimal(GetStatePointer(Fish2,StV,WaterCol)).PAnimalData^.TOpt;
                   {for calculating prom/recr, FISH1 must use same TOPTSpawn as all other age classes}

  with PAnimalData^ do
    SpawnNow :=((AutoSpawn and InTempRange) or (Not AutoSpawn and ThisIsSpawningDate))
                 { spawning should occur due to temperature or user specification }
    AND (UnlimitedSpawning or (SpawnTimes<SpawnLimit)); { and they can still spawn this year }
End;

Function TAnimal.GameteLoss : Double;
var Gametes  : Double;
    TempEpi, TempHypo, SaltEffect, Capacity, FracAdults, IncrMort : Double;
    SmFPtr   : TAnimal;
    AgeIndex : Integer;
    SpawnAge : Double;
    KCapConv: Double;
begin
  GameteLoss := 0.0;
  Recruit    := 0.0;

  if (State < Tiny) or (IsLeavingSeg) then exit;

  KCapConv := KCap_in_g_m3;
  If IsInvertebrate then
    with PAnimalData^ do
    begin
       {For now the best way to handle gamete loss in invertebrates
        is to permit it to occur continually 1/17/97}
       If ((State > Tiny) and (KCapConv > 0.0)) then
           begin
             if State > KCapConv then Capacity := 0    {12/30/96}
                                 else Capacity := KCapConv-State;
             FracAdults := 1.0 - Capacity/KCapConv;
             IncrMort   := (1.0 - GMort) * AggregateRedRepro;

             SaltEffect := 1+SalMort(Salmin_Gam,SalMax_Gam,Salcoeff1_Gam,Salcoeff2_Gam);
               {Gameteloss is increased by salinity therefore the mortality equation is used}

             GameteLoss := (GMort + IncrMort) * FracAdults * PctGamete * SaltEffect * State;
             If (Result > State*FracAdults*PctGamete) then GameteLoss := FracAdults*State*PctGamete;  {10/17/2012, limit losses to frac.gametes}
           end;
       EXIT; {invert calculation complete}
    end; {invertebrate code}

  AllStates.GetTemperatures(TempEpi,TempHypo);

  If IsFish then with PAnimalData^ do
    begin
       Gametes := 0.0;
       FracAdults := 0.0;

       If SpawnNow and not Spawned
           And (State > Tiny) AND (KCapConv > 0.0)  {there are fish available to spawn}
           And (not IsSmallFish {which don't spawn}) then
           begin  {commence spawning}
             If State > KCapConv then Capacity := 0
                                 else Capacity := KCapConv-State;

             If (PSameSpecies^=NullStateVar) {If this compartment represents both small and large fish}
                 then FracAdults := 1.0 - Capacity/KCapConv
                 else FracAdults := 1;

             If NState in [Fish1..Fish15] then {multi age fish}
               Begin
                 AgeIndex := Ord(NState) - Ord(Fish1) + 1;      {upper bound of fish age}
                 SpawnAge := AllStates.PMultiRec^.PSpawnAge^;  {age at which fish start spawning}
                 If (AgeIndex<=SpawnAge) then FracAdults := 0   {if oldest age in class is less than spawning age, no adults in class}
                   else if (AgeIndex-1>=SpawnAge) then FracAdults := 1   {if youngest age in class exceeds spawning age, all adults in class}
                   else FracAdults := 1 -(SpawnAge-(AgeIndex-1));        {deal with fractional SpawnAge}
               End;

             IncrMort := (1.0 - GMort) * AggregateRedRepro;
             Gametes  := (GMort + IncrMort) * FracAdults * PctGamete * State;

             If (FracAdults * PctGamete) > 0 then {fish is spawning}
               begin
                 If (not (NState in [Fish1..Fish15])) and (PSameSpecies^=NullStateVar)
                    then Recruit := 0   {this compartment represents large and small fish}
                    else Begin
                           Recruit := -(1-(GMort+IncrMort)) * FracAdults * PctGamete * State;
                           If Recruit > 0 then Recruit := 0;
                           If not (NState in [Fish1..Fish15]) then
                             Begin  {assign proper recruit value to small fish of same species}
                               SmFPtr := GetStatePointer(PSameSpecies^,StV,WaterCol);
                               SmFPtr.Recruit := -Recruit;
                             End;
                         End;
               end;
           end; {if spawnnow and not spawned}

       SaltEffect := SalMort(Salmin_Gam,SalMax_Gam,Salcoeff1_Gam,Salcoeff2_Gam);
         {Gameteloss is increased by salinity therefore the mortality equation is used}
       GameteLoss := Abs(Gametes) * SaltEffect;

       If (Result > State*FracAdults*PctGamete) then GameteLoss := FracAdults*State*PctGamete;  {6/5/08, limit losses to frac.gametes}

    end; {with}
end;

    (*************************************)
    (* loss due to discharge from system *)
    (*************************************)

Function TAnimal.Scour_Entrainment: Double;
Const Gradual = 25;
      MaxRate = 1; {/d}
Var Vel: Double;
Begin
  With PAnimalData^ do
    Vel := AllStates.Velocity(PrefRiffle,PrefPool,False);

  If Vel >= PAnimalData^.VelMax     {11/9/2001 constrain so does not exceed "state"}
    then Scour_Entrainment := MaxRate * State
    else Scour_Entrainment := State * MaxRate * (exp((Vel - PAnimalData^.VelMax )/Gradual));
        {mg/L d}              {mg/L}   {/d}           {cm/s}              {cm/s}    {cm/s}
End;


Function TAnimal.Drift : Double;
var      Wash, Dislodge, SegVolume, Disch         : Double;
         EC50Gr, DriftThres, ToxLevel, AccelDrift : Double;
         AnimalPtr : TAnimal;
         ToxLoop   : T_SVType;
         InorgSdDep : Double;
Begin
  Wash  :=0.0;
  Drift :=0.0;

  If IsFish then exit;  {fish don't drift}

  If (State < Tiny) or (IsLeavingSeg) then exit;

  If IsInvertebrate
    Then With AllStates do
      begin
        SegVolume := AllStates.SegVol;
        Disch := Location.Discharge[VSeg];

        If (PAnimalData^.Animal_Type='Benthic Invert.') or
           (PAnimalData^.Animal_Type='Benthic Insect') THEN
          BEGIN {benthic}
            If PAnimalData^.AveDrift <= 0 then exit; {only evaluate if zoobenthos is capable of drifting}

            AccelDrift := 1.0;
            InorgSdDep := AllStates.InorgSedDep(True);
            If (InorgSdDep > PAnimalData^.Trigger) then
                AccelDrift := exp(InorgSdDep - PAnimalData^.Trigger);
                                   {kg/m2}                   {kg/m2}
            Dislodge := PAnimalData^.AveDrift * AccelDrift;

            For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
             If (GetState(AssocToxSV(ToxLoop),StV,WaterCol) > Tiny) then {if no toxicant in study, evaluates to -1}
               Begin
                AnimalPtr  := TAnimal(Self);
                EC50Gr     := AnimalPtr.Anim_Tox[ToxLoop].EC50_Growth;
                If EC50Gr > Tiny then
                  Begin
                    DriftThres := AnimalPtr.Anim_Tox[ToxLoop].Drift_Thresh;  {ug/L}
                    ToxLevel   := GetState(AssocToxSV(ToxLoop),StV,WaterCol);
                    If (ToxLevel > DriftThres) then
                      Dislodge := Dislodge + (ToxLevel-DriftThres)/((ToxLevel-DriftThres) + EC50Gr)
                                                 {Toxicant Induced Dislodge for this toxicant}
                  End;
               End; {toxloop}
            Wash  :=  Dislodge * State;      {9/17/03}
            {g/m3 d}  {/d}       {g/m3}
          END
        ELSE {pelagic}
          Wash  := (Disch / SegVolume) * State;
      end; {invertebrate}


  Drift := Wash;
  WashoutStep[AllStates.DerivStep] := Wash * AllStates.SegVol;

End; (* drift *)


Function TAnimal.Washout;
Begin
  Washout := Drift;
End;


Function TAnimal.GillUptake(ToxType: T_SVType; ToxLayer:T_SVLayer): Double;
Const WEffO2: Double = 0.62;  {McKim et al. 1985}
Var KUptake,PWVolLiters,WVolLiters: Double;
    Local_K1, Local_K2, O2Bio, OxygenConc: Double;
    PW: TPoreWater;
    PT : TToxics;
    WEffTox, Frac_This_Layer, ToxState :Double;
    ToxLoop: T_SVType;
    ChemOption: UptakeCalcMethodType;
    SedModelRunning : Boolean;
    SizeCorr: Double;

    {---------------------------------------------------------------------------------------------------------------------------------------}
    Procedure PFAUPTAKE;  //separated from main body 9/8/2010
    Const OneoverSizeRef = 1.3797;  {reciprocal of reference wt 5^-0.2}
    Begin
      If IsFish
        then SizeCorr := POWER(PAnimalData^.MeanWeight, -0.2) *OneOverSizeRef
        else SizeCorr := POWER(PAnimalData^.MeanWeight, -0.25)*OneOverSizeRef;  {Change 9/25/2011 invertebrates, Maloney and Field 1989}

      With ChemPtrs^[ToxType].ChemRec do With Allstates do
        Begin
//          ChainLength := Min(PFAChainLength,11);
//          If PFAType = 'carboxylate' then Local_K1 := WetToDry * POWER(10,-5.7213+0.7764*ChainLength)
//                      else {sulfonate}    Local_K1 := WetToDry * POWER(10,-5.85+0.966*ChainLength);
//          Local_K1 := Local_K1 * SizeCorr; {correct for size similar to depuration}
//          {L/kg-d      L/kg-d     unitless}

          Local_K1 := Anim_Tox[ToxType].Entered_K1;
          DerivedK1[ToxType] := Local_K1;

          If ToxLayer = WaterCol
             then GillUptake := Local_K1 * Diff[ToxType] * ToxState * State * 1e-6       //  eqn (402)
                  {ug/L-d       L/kg-d       unitless       ug/L      mg/L   kg/mg}
             else GillUptake := Local_K1 * PoreDiff[ToxType,SedLayer1] * ToxState * Frac_This_Layer *  PWVolLiters / WVolLiters * State * 1e-6;
                 {ug/L(wc)-d   L/kg-d               unitless             ug/L(pw)       unitless   *     L(pw)    /   L(wc)      mg/L   kg/mg}
                 {    (wc)=water column                             (pw)=pore water   }
                 { Normalizing to Units of the Water Column                           }
        End;
    End;
    {---------------------------------------------------------------------------------------------------------------------------------------}

Begin
  PWVolLiters := 0; WVolLiters:=0;
  GillUptake:=0;

  PW := GetStatePointer(PoreWater,StV,SedLayer1);
  SedModelRunning := PW<>nil;
  If ToxLayer>SedLayer1 then exit; {no uptake from below the active layer}

  If ToxLayer=SedLayer1
    then
      Begin
        Frac_This_Layer := 1-PAnimalData^.FracInWaterCol;
        ToxState := GetState(PoreWater,ToxType,SedLayer1);
        PWVolLiters := PW.VolumeinL;

        IF PW.VolumeInM3<Tiny then exit;
        WVolLiters := AllStates.SegVol * 1e3;
                                  {m3}   {L/m3}
      End
    else
      Begin
        If SedModelRunning then Frac_This_Layer := PAnimalData^.FracInWaterCol
                           else Frac_This_Layer := 1;
        ToxState := GetState(AssocToxSV(ToxType),StV,WaterCol)
      End;

  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
      Poisoned(ToxLoop);  {Ensure RedGrowth data is up-to-date.  This is required for dietary uptake calculation in SpecDynAction to be uniform}

  With AllStates do
    Begin
      PT:=GetStatePointer(NState,ToxType,WaterCol);
      If PT=nil then exit;

      With ChemPtrs^[ToxType].ChemRec do
      If IsPFA
        then PFAUPTAKE
        else {not PFA}
          Begin
             If AllStates.ChemPtrs^[ToxType]=nil then exit;
             ChemOption := ChemPtrs^[ToxType].Anim_Method;

              If ChemOption = Default_Meth then
               With AllStates do
                Begin
                  PT:=GetStatePointer(nstate,ToxType,WaterCol);
                  If PT=nil then exit;

                  O2Bio      := Location.Remin.O2Biomass;
                  OxygenConc := GetState(Oxygen,StV,WaterCol);
                  WEffTox    := ChemPtrs^[ToxType].WEffTox(PT.NonDissoc);
                  if OxygenConc > 0.0 then
                    KUptake:= (WEffTox * Respiration * O2Bio) / (OxygenConc * WEffO2)
                    {1/d       unitless   mg/L-d       mgO2/mg    mgO2         unitless}
                  else
                    KUptake := 0.0;

                  Local_K2 := Anim_Tox[ToxType].Entered_K2;
                  If Local_K2>96 then KUptake := KUptake * (96/Local_k2); {scaling factor 10-02-03}

                  If State < Tiny
                    then DerivedK1[ToxType] := 0
                    else DerivedK1[ToxType] := KUptake / (State       * 1e-6);    //9/9/2010
                         {L/kg D}               {1/d}  {bmass mg/L}   {kg/mg}

                  If ToxLayer = WaterCol
                     then GillUptake := KUptake * Diff[ToxType] * ToxState * Frac_This_Layer
                           {ug/L-d       1/d      set to 1.0       ug/L          unitless}
                     else GillUptake := KUptake * PoreDiff[ToxType,SedLayer1] * ToxState * Frac_This_Layer *  PWVolLiters / WVolLiters ;
                         {ug/L(wc)-d       1/d          set to 1.0               ug/L(pw)       unitless   *     L(pw)    /   L(wc)}
                         {    (wc)=water column                                 (pw)=pore water   }
                         { Normalizing to Units of the Water Column                               }
                End
              Else
                Begin  {ChemOption <> Default_Meth}
                  With Anim_Tox[ToxType] do
                   If ChemOption = CalcK1
                    then Local_K1 := Entered_K2 * Entered_BCF
                    else Local_K1 := Entered_K1;

                  DerivedK1[ToxType] := Local_K1;
                  With AllStates do
                   GillUptake := Local_K1 * Diff[ToxType] * ToxState * State * 1e-6;
                   {ug/L-d}       {L/kg-d}  {unitless}       {ug/L}   {mg/L}   {kg/mg}
                End;
          End;

    End; {With AllStates}
End; {Gilluptake}


{-----------------------------------------------------------------------}

Procedure TAnimal.Calc_Prom_Recr_Emrg(Growth : Double);
Const  KPro = 0.5; {+1, not YOY}
Var SmF, LgF:  TAnimal;
    TempEpi,TempHypo,Prom: Double;
    BigFishLoop: Allvariables;
Begin
  PromSmFish:=0;
  EmergeInsect:=0;

  {continuous promotion to next size class or emergence}
  Prom := KPro * (Growth);
  if Prom < 0 then Prom:=0;

  If (PSameSpecies^<>NullStateVar) Then
    If IsSmallFish
     Then
       Begin
         LgF:=GetStatePointer(PSameSpecies^,StV,WaterCol);
         LgF.GameteLoss;   {call LgGF^.GameteLoss to get Promotion Value}
         PromSmFish := - Prom;
         If AnadRec.IsAnadromous then PromSmFish := 0;   //No promotion to adult for anadromous fish
       End
     Else
       Begin
         SmF:=GetStatePointer(PSameSpecies^,StV,WaterCol);
         PromSmFish:=-SmF.PromSmFish;
         If SmF.AnadRec.IsAnadromous then PromSmFish := 0;    //No promotion to adult for anadromous fish
       End;
     {SmallFish are derived first, so PromSGF and Recruit will be
      current for the given time-step}

  IF (NState=Fish1) then {Calculate Recruitment for YOY of multi-age fish}
    Begin
      Recruit := 0;
      For BigFishLoop:= Fish2 to Fish15 do
        If GetStatePointer(BigFishLoop,StV,WaterCol) <> nil then
          Begin
            LgF:=GetStatePointer(BigFishLoop,StV,WaterCol);
            LgF.GameteLoss;   {call LgGF^.GameteLoss to get Recruit}
            Recruit := Recruit - LgF.Recruit;  {sum recruitment from larger fish}
          End;
    End; {Fish1}

  {Promotion of multi-age fish is found in TStates.DoThisEveryStep}

   with PAnimalData^ do
    If (PAnimalData^.Animal_Type='Benthic Insect') then
     begin
       AllStates.GetTemperatures(TempEpi,TempHypo);

       IF     ((TempEpi  > 0.8 * TOpt) and (TempEpi  < (TOpt - 1.0)))
           or ((TempHypo > 0.8 * TOpt) and (TempHypo < (TOpt - 1.0)))
               then  EmergeInsect := 2.0 * Prom;
     end;

End; {Promote_Recruit_Emerge}

    (************************************)
    (*                                  *)
    (*     DIFFERENTIAL EQUATIONS       *)
    (*                                  *)
    (************************************)

Procedure TAnimal.Derivative(var DB: double);
var Lo,Co,De,Re,Ex,Pr,Mo,Ga,Fi,DrO,TD,PSG,Recr,Emrg,Migr,DrI,DiffUp,DiffDown,Entr,En: Double;

    {--------------------------------------------------}
    Procedure WriteRates;
    Var ToxLoop: T_SVType;

    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Load',Lo);
          SaveRate('Consumption',Co);
          SaveRate('Defecation',De);
          SaveRate('Respiration',Re);
          SaveRate('Excretion',Ex);
          SaveRate('Fishing',Fi);
          If (PAnimalData^.Animal_Type<>'Pelagic Invert.') then
             SaveRate('Scour_Entrain',Entr);

           If IsInvertebrate and
             (PAnimalData^.Animal_Type<>'Benthic Invert.') and
             (PAnimalData^.Animal_Type<>'Benthic Insect')
               Then
                 Begin
                   If AllStates.EstuarySegment then
                      SaveRate('Estuary.Entrain',En);
                   If Not AllStates.LinkedMode
                     then SaveRate('TurbDiff',TD)
                     else Begin
                            SaveRate('DiffUp',DiffUp);
                            SaveRate('DiffDown',DiffDown);
                          End;
                 End;

          SaveRate('Predation',Pr);

          For ToxLoop:=FirstOrgTxTyp to LastOrgTxTyp do
            If GetStatePointer(NState,ToxLoop,waterCol)<>nil then
                SaveRate(PrecText(ToxLoop)+' Poisoned',MortRates.OrgPois[ToxLoop]);

          SaveRate('Low O2 Mort',MortRates.O2Mort);
          SaveRate('NH3 Mort',MortRates.NH3Mort);
          SaveRate('NH4+ Mort',MortRates.NH4Mort);

          If GetState(Salinity,StV,WaterCol) <> -1 then
            SaveRate('Salt Mort',MortRates.SaltMort);
          SaveRate('Other Mort',MortRates.OtherMort);
          If IsFish then
            SaveRate('Susp. Sed. Mort',MortRates.SedMort);
          SaveRate('Mortality',Mo);

          SaveRate('GameteLoss',Ga);
          SaveRate('Washout-Drift',DrO);
          If AllStates.LinkedMode then
            SaveRate('DriftIn',DrI);

          If (NState < Fish1) then {size class fish}
            Begin
              If (State < Tiny) and (Loading < Tiny)
                Then begin
                       SaveRate('Promotion',0);
                       SaveRate('Recruit',0);
                     end
                Else begin
                       SaveRate('Promotion',PSG);
                       SaveRate('Recruit',Recr);
                     end
            End; {Sm,Lg GameFish}

          If NState in [Fish1..Fish15] then
            Begin
              SaveRate('Recruit',Recr);
            End;

          If (PAnimalData^.Animal_Type='Benthic Insect') then
             SaveRate('EmergeI',Emrg);

          If CanMigrate then SaveRate('StratMigration',Migr);

          SaveRate('GrowthRate',Co-De-Re-Ex);

        End;
    End;
    {--------------------------------------------------}
    Procedure TrackMB;
    Var NutrFrac, FishInKg, LoadInKg, LossInKg, LayerInKg: Double;
        Typ: AllVariables;
    Begin
     For Typ := Nitrate to Phosphate do With AllStates do
      Begin
       If Typ=Nitrate then NutrFrac := PAnimalData^.N2Org
                      else NutrFrac := PAnimalData^.P2Org;

       with MBLoadArray[Typ] do
         Begin {save for tox loss output & categorization}
           LoadInKg :=  (Lo)     * SegVol * 1000.0 * 1e-6 * NutrFrac;
           {kg nutr}   {mg org/L}    {m3}  {L/m3} {kg/mg} {nutr / org}
           BoundLoad[Derivstep] := BoundLoad[Derivstep] + LoadInKg;  {Load into modeled system}

           If EN <=0 then LoadInKg :=  (Lo + DrI)      * SegVol * 1000.0 * 1e-6 * NutrFrac
                     else LoadInKg :=  (Lo + DrI + En) * SegVol * 1000.0 * 1e-6 * NutrFrac;
                         {kg nutr}         {mg org/L}     {m3}   {L/m3}  {kg/mg} {nutr / org}

           TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;  // out of segment load
           LoadBiota[Derivstep] := LoadBiota[Derivstep] + LoadInKg;
         End;

       with location.morph do with MBLossArray[Typ] do
         Begin {save for tox loss output & categorization}
           LossInKg :=  (DRO+Entr) {* OOSDischFrac} * SegVol * 1000.0 * 1e-6 * NutrFrac;          // 3/20/2014 remove OOSDischFrac, now out of segment loss
           {kg nutr}    {mg org/                       {m3}  {L/m3} {kg/mg} {nutr / org}
           BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg;  {Loss from the system}

           If En<0 then LossInKg :=  (-En + (DRO+Entr) {* OOSDischFrac}) * SegVol * 1000.0 * 1e-6 * NutrFrac;  {loss from this segment}  // 3/20/2014 remove OOSDischFrac


           FishInKg :=  (Fi) * SegVol * 1000.0 * 1e-6 * NutrFrac;               {6/30/2009 broke out fishing from washout in MB Tracking}
           FishingLoss[DerivStep] := FishingLoss[DerivStep] + FishInKg;
           BoundLoss[DerivStep] := BoundLoss[DerivStep] + FishInKg;  {Loss from the system}

           TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg + FishInKg;
           TotalWashout[Derivstep] := TotalWashout[Derivstep] + LossInKg;
           WashoutAnim[Derivstep] := WashoutAnim[Derivstep] + LossInKg;

           LossInKg :=    Emrg * SegVol * 1000.0 * 1e-6 * NutrFrac;    // emergence
           {kg nutr}    {mg org/L} {m3}  {L/m3} {kg/mg} {nutr / org}
           TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
           BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg;  {Loss from the modeled system}
           EmergeIns[Derivstep]  := EmergeIns[Derivstep] + LossInKg;
         End;

       with MBLayerArray[Typ] do
         Begin {save for tox loss output & categorization}
            LayerInKg := (TD+DiffUp+DiffDown)   * SegVol * 1000.0 * 1e-6  * NutrFrac;;
           {kg nutr}     {      mg org/L      }      {m3}    {L/m3} {kg/mg} {nutr / org}
            NTurbDiff [Derivstep] := NTurbDiff[Derivstep] + LayerInKg;
            NNetLayer [Derivstep] := NNetLayer[Derivstep] + LayerInKg;

            LayerInKg := Migr  * SegVol * 1000.0 * 1e-6  * NutrFrac;;
           {kg nutr}   {mg org/L}  {m3}  {L/m3} {kg/mg} {nutr / org}
            NMigrate [Derivstep] := NMigrate[Derivstep] + LayerInKg;
            NNetLayer [Derivstep] := NNetLayer[Derivstep] + LayerInKg;
          End;
      End;
    End;
    {--------------------------------------------------}
var ToxLoop: T_SVType;
    EpiSalt: Double;
    SaltGoodEpi: Boolean;
begin
  Lo:=0; Co:=0; De:=0; Re:=0;  Ex:=0; PSG:=0;  Emrg:=0; DiffDown:=0; Entr:=0;
  Pr:=0; Mo:=0; Ga:=0; DrO:=0; TD:=0; Recr:=0; Migr:=0; DiffUp:=0;   DrI:=0;
  MortRates.OtherMort:=0; Fi:=0;  MortRates.SaltMort  := 0; En :=0; 

  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
       MortRates.OrgPois[ToxLoop] := 0;

  Migr := StratMigration;
  { StratMigration calculated first to set IsMigrAnoxia to limit other loss terms in that case }

  Calc_Prom_Recr_Emrg(0);  //10/21/2010 calculate promotion from smaller fish (PromSmFish) for optimization code test below.
  If ((State < Tiny) and (Migr<Tiny) and (Loading < Tiny)) and (WashIn<Tiny) and (PromSmFish<Tiny) and (not (SpawnNow and not spawned)) and (Recruit < tiny)
                            {Spawning can be an important additive rate (recruit) for YOY or small fish}
    then Begin
           dB := 0.0;
           RecrSave := 0;
         End
    else Begin
           Migr := StratMigration;

           Mo:=Mortality;
          { Mortality calculated second for Chronic Effect Calculation }

           Lo:=Loading;
           Co:=Consumption;
           De:=Defecation;
           Re:=Respiration;
           Ex:=AnimExcretion;
           Pr:=Predation;
           Ga:=GameteLoss;
           DrO:=Drift;

           Calc_Prom_Recr_Emrg(Co-De-Re-Ex-Ga);
           If NState<Fish1 then PSG  := PromSmFish;

           Fi := PAnimalData^.Fishing_Frac * State;
           If AllStates.LinkedMode then DrI := WashIn;

           Recr := Recruit;  {Recr value is used in DoThisEveryStep}
           Emrg := EmergeInsect;
           If (PAnimalData^.Animal_Type<>'Pelagic Invert.')
             then Entr:=Scour_Entrainment;

           {Pelagic invertebrates are subject to currents}
           If IsInvertebrate and
             (PAnimalData^.Animal_Type<>'Benthic Invert.') and
             (PAnimalData^.Animal_Type<>'Benthic Insect')
              then
                Begin
                  If (AllStates.LinkedMode and (not AllStates.CascadeRunning))
                    then
                      Begin
                        DiffUp   := SegmentDiffusion(True);
                        DiffDown := SegmentDiffusion(False);
                      End
                    else If (Not AllStates.LinkedMode) then TD := TurbDiff;

                  If AllStates.EstuarySegment then With AllStates do
                    Begin
                      If VSeg=Epilimnion  {5-30-08, no entrainment for pelagic inverts. if salt climate is not desirable}
                        then EpiSalt := GetState(Salinity,StV,WaterCol)
                        else EpiSalt := EpiSegment.GetState(Salinity,StV,WaterCol);

                      SaltGoodEpi := (EpiSalt > PAnimalData.SalMin_Ing) and
                                     (EpiSalt < PAnimalData.SalMax_Ing);
                      If SaltGoodEpi then En := EstuaryEntrainment;
                    End;
                End;

           db  := Lo + Co - De - Re - Ex - Mo - Pr - Fi - Ga - DrO + DrI + PSG - Emrg + En - Entr + TD + Migr + DiffUp + DiffDown ;
          {mg/L}   {all mg/L}

           { Multi-Fish Promotion occurs on the first spawning of the year.
             Recruitment for all fish occurs each time spawning occurs. }
           { These effects are calculated after the timestep is complete;
             They are unique events, not suitable for the daily timestep inherent in RKQS }
           { See TSTATES.DoThisEveryStep }

           If (AllStates.DerivStep=5) then RecrSave   := Recr;  {derivstep 5 is time X+h}

         End; {State>Tiny}
    WriteRates;
    TrackMB;
end;

