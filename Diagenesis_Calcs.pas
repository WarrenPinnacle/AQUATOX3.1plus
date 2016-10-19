//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 

{AQUATOX has been modified to include a representation of the sediment bed as
 presented in Di Toro’s Sediment Flux Modeling (2001).       }

Unit Diagenesis_Calcs;

interface

uses Aquaobj, Global;

Type

  TNH4_Sediment = class(TStateVariable)
      constructor init(Ns :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      Function Nitr_Rate(NH4_1: Double): Double;  {k2 nh4, oxic layer reaction velocity}
      Function Flux2Water :Double; {rate in g/m3 (sed) d}
      Procedure  Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
  End;

  TNO3_Sediment = class(TStateVariable)
      Function Denit_Rate(NO3Conc: Double): Double; {k2 nh4, oxic layer reaction velocity}
      Function Flux2Water :Double; {rate in g/m3 (sed) d}
      constructor init(Ns :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      Procedure  Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
  End;

  TPO4_Sediment = class(TStateVariable)
      Function fdp1 :Double; {frac dissolved in layer1}
      Function Flux2Water :Double; {rate in g/m3 (sed) d}
      constructor init(Ns :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      Procedure  Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
  End;


  TPOC_Sediment = class(TStateVariable)
      Function Mineralization: Double;
      Function Predn: Double;
      Function Burial: Double;
      constructor init(Ns :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      Procedure  Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
  End;


  TPON_Sediment = class(TStateVariable)
      Function Mineralization: Double;
      constructor init(Ns :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      Procedure  Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
  End;

  TPOP_Sediment = class(TStateVariable)
      function Mineralization: Double;
      constructor init(Ns :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      Procedure  Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
  End;

  TMethane = class(TStateVariable)
      constructor init(Ns :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      Procedure  Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
  End;

  TSulfide_Sediment = class(TStateVariable)
      function Diagenesis: Double;
      function k2Oxid: Double;
      constructor init(Ns :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      Procedure  Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
  End;

  TSilica_Sediment = class(TStateVariable)
      function Dissolution(fdsi2: double): Double;
      constructor init(Ns :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      Procedure  Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
  End;

  TCOD = class(TStateVariable)
      constructor init(Ns :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
      Procedure  Derivative(var DB: double); override;
      Procedure CalculateLoad(TimeIndex : Double); override;
      Function ObjectID: SmallInt; override;
  End;



implementation

Uses Diagenesis, Math;

{ TNH4_Sediment }
procedure TNH4_Sediment.CalculateLoad(TimeIndex: Double);
begin
  Loading := 0;
end;

Function TNH4_Sediment.Nitr_Rate(NH4_1: Double):Double;  {K1 nh4, oxic layer reaction velocity}
Var Temp, Salt, KappaNH3, O2: Double;
begin
 With AllStates.Diagenesis_Params^ do
   Begin
     O2   := AllStates.GetState(Oxygen,StV,WaterCol);
     Temp := AllStates.GetState(Temperature,StV,WaterCol);
     Salt := AllStates.GetState(Salinity,StV,WaterCol);

     If Salt > SaltND.Val then KappaNH3 := KappaNH3s.Val
                          else KappaNH3 := KappaNH3f.Val;

     {EFDC EQ. 5-19}
     Nitr_Rate := SQR(KappaNH3) * POWER(ThtaNH3.Val ,(Temp - 20)) * KM_NH3.Val /
     {m2 /d2}          {m/d}            {unitless}                  {mg N/ L}
                    (KM_NH3.Val + NH4_1)  * O2 / (2 * KM_O2_NH3.Val + O2);
   End;              {mgN /L }   {mgN / L}  {mg/L}       {mg/L}      {mg/L}
end;

Function TNH4_Sediment.Flux2Water: Double;
Var fda1, s, NH4_0: Double;
Begin
    NH4_0 := AllStates.GetState(Ammonia,StV,WaterCol);
    s   := AllStates.MassTransfer;
    {m/d}

    With AllStates.Diagenesis_Params^ do
      Begin
        fda1 := 1/(1+m1.val * kdNH3.Val);
        Flux2Water :=  s*(fda1*State - NH4_0) / H1.val ;
         {g/m3 d}     {m/d}    {g/m3}   {g/m3}    {m}
      End;
End;


procedure TNH4_Sediment.Derivative(var DB: double);
Var fpa1, fda1, fpa2, fda2, s: Double;
    Nitr, Burial, Flux2Anaerobic, Flux2Wat, Dia_Flux: Double;
    NH4_2, NH4_1: Double;
    ns: AllVariables;  ppn: TPON_Sediment;

     Procedure WriteRates;
     Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) and (Layer = SedLayer1) then
        Begin
          ClearRate;
          SaveRate('State',state);
          SaveRate('Nitrification',nitr);
          SaveRate('Burial',Burial);
          SaveRate('Flux2Water',Flux2Wat);
          SaveRate('Flux2Anaerobic',Flux2Anaerobic);
        End;

     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) and (Layer = SedLayer2) then
        Begin
          ClearRate;
          SaveRate('State',state);
{         SaveRate('Dia_Flux_LIM',Dia_Flux*AllStates.Diagenesis_Params^.H2.Val); {Provide output in g/m2 d }
          SaveRate('Dia_Flux',Dia_Flux);
          SaveRate('Burial',Burial);
          SaveRate('Flux2Anaerobic',Flux2Anaerobic);
        End;

    End;
    {--------------------------------------------------}
    Procedure TrackMB;
    Var SedVol, LossInKg: Double;
    Begin
      If Layer = SedLayer2 then
        Begin
          SedVol := AllStates.DiagenesisVol(2);
          LossInKg := (Burial * SedVol * 1e-3);  {loss from the system}
        {kg N / d}    {g/m3 d}   {m3}   {kg/g}
          with AllStates do with MBLossArray[Nitrate] do
            Begin
              TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
              BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg;  {Loss from the system}
              Burial[Derivstep] := Burial[Derivstep] + LossInKg;
            End;
        End;
    End;
    {--------------------------------------------------}

begin {TNH4_Sediment.Derivative}
 With AllStates.Diagenesis_Params^ do
  begin

    NH4_1 := AllStates.GetState(Ammonia,StV,SedLayer1);
    NH4_2 := AllStates.GetState(Ammonia,StV,SedLayer2);
    fda1 := 1/(1+m1.val * kdNH3.Val);
    fpa1 := 1-fda1;
    fda2 := 1/(1+m2.val * kdNH3.Val);
    fpa2 := 1-fda2;

    Flux2Anaerobic :=  -( w12  * (fpa2*NH4_2 - fpa1*NH4_1) + KL12  * (fda2*NH4_2 - fda1*NH4_1));
    {g/m2 d}             {m/d}      {g/m3}      {g/m3}      {m/d         {g/m3}        {g/m3}
    If Layer=SedLayer1 then Flux2Anaerobic := Flux2Anaerobic / H1.Val
                       else Flux2Anaerobic := Flux2Anaerobic / H2.Val;
                               {g/m3 d}          {g/m2 d}       {m}

    If Layer = SedLayer1 then
      Begin
        s   := AllStates.MassTransfer;
      {m/d}

        Burial  :=  w2.Val / H1.Val * state;
                   {m/d}       {m}     {g/m3}
        Nitr := Nitr_Rate(state) / s * state / H1.Val;  {EFDC eq. 5-20}
      {g/m3 d}      {m2/d2}      {m/d} {g/m3}   {m}

        Flux2Wat := Flux2Water;

        db :=  - Nitr - Burial - Flux2Wat - Flux2Anaerobic;
      {g/m3 d}  {g/m3 d}

       If AllStates.Diagenesis_Steady_State then db := 0; {Layer 1 is STEADY STATE}

      End
    else {SedLayer2}
      Begin
        Dia_Flux := 0;
        For ns := PON_G1 to PON_G3 do
          Begin
            ppn := GetStatePointer(ns,Stv,SedLayer2);
            Dia_Flux := Dia_Flux + ppn.mineralization ;
             {mg/L d}                       {mg/L d}
          End;

        Flux2Anaerobic := Flux2Anaerobic + (w2.Val * NH4_1 / H2.Val); {include burial from L1}
        Burial :=  w2.Val * NH4_2 / H2.Val ;

        db :=   Dia_Flux - Burial + Flux2Anaerobic;
      {g/m3 d}  {g/m3 d}
      End;
  end;
  WriteRates;
  TrackMB;
end;

constructor TNH4_Sediment.Init;
begin
  inherited;
end;

{ TPO4_Sediment }

procedure TPO4_Sediment.CalculateLoad(TimeIndex: Double);
begin
  Loading := 0;
end;

Function TPO4_Sediment.fdp1: Double;
Var dKDPO41, KDPO41, Salt, O2: Double;
Begin
    Salt := AllStates.GetState(Salinity,StV,WaterCol);
    O2  := AllStates.GetState(Oxygen,StV,WaterCol);

    With AllStates.Diagenesis_Params^ do
      Begin
        If Salt > SaltND.Val then dKDPO41 := dKDPO41s.Val
                             else dKDPO41 := dKDPO41f.Val;

        If (O2 > O2critPO4.Val)
          Then KdPO41 := KdPO42.Val * dKDPO41
          Else KdPO41 := KdPO42.Val * POWER(dKDPO41 ,(O2 / O2critPO4.Val));

        fdp1 := (1 / (1 + m1.val * KdPO41));
      End;
End;

Function TPO4_Sediment.Flux2Water: Double;
Var s, PO4_0: Double;
Begin
    PO4_0 := AllStates.GetState(Phosphate,StV,WaterCol);
    s   := AllStates.MassTransfer;
    {m/d}

    With AllStates.Diagenesis_Params^ do
        Flux2Water := s*( fdp1*State - PO4_0) / H1.Val;
        {g/m3 d}     {m/d}    {g/m3}   {g/m3}    {m}

End;

procedure TPO4_Sediment.Derivative(var DB: double);
Var Dia_Flux, Burial, Flux2Anaerobic, Flux2Wat: Double;
    PO4_2, PO4_1: Double;
    fdp2, fpp1, fpp2: Double;
    ns: AllVariables;  ppp : TPOP_Sediment;

    {--------------------------------------------------}
    Procedure TrackMB;
    Var SedVol, LossInKg: Double;
    Begin
     If Layer=SedLayer2 then
      Begin
        SedVol := AllStates.DiagenesisVol(2);
        LossInKg := (Burial * SedVol * 1e-3) ;  {loss from the system}
       {kg N / d}   {g/m3 d}   {m3}   {kg/g}
        with AllStates do with MBLossArray[Phosphate] do
          Begin
            TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
            BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg;  {Loss from the system}
            Burial[Derivstep] := Burial[Derivstep] + LossInKg;
          End;
      End;
    End;
    {--------------------------------------------------}
     Procedure WriteRates;
     Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) and (Layer = SedLayer1) then
        Begin
          ClearRate;
          SaveRate('State',state);
          SaveRate('Burial',Burial);
          SaveRate('Flux2Water',Flux2Wat);
          SaveRate('Flux2Anaerobic',Flux2Anaerobic);
        End;

     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) and (Layer = SedLayer2) then
        Begin
          ClearRate;
          SaveRate('State',state);
          SaveRate('Dia_Flux',Dia_Flux);
          SaveRate('Burial',Burial);
          SaveRate('Flux2Anaerobic',Flux2Anaerobic);
        End;
    End;
    {--------------------------------------------------}

begin {TPO4_Sediment.Deriv}

 With AllStates.Diagenesis_Params^ do
  begin
    fpp1 := 1 - fdp1;
    fdp2 := (1 / (1 + m2.val * KdPO42.val));
    fpp2 := 1 - fdp2;

    PO4_1 := AllStates.GetState(Phosphate,StV,SedLayer1);
    PO4_2 := AllStates.GetState(Phosphate,StV,SedLayer2);

    Flux2Anaerobic :=  - ((w12*(fpp2*PO4_2 - fpp1*PO4_1) + KL12 * (fdp2*PO4_2 - fdp1*PO4_1)));
     {g/m2 d}              {m/d}    {g/m3}                  {m/d}    {g/m3}
    If Layer=SedLayer1 then Flux2Anaerobic := Flux2Anaerobic / H1.Val
                       else Flux2Anaerobic := Flux2Anaerobic / H2.Val;
                               {g/m3 d}          {g/m2 d}       {m}

    If Layer = SedLayer1 then
      Begin
        Burial  :=  w2.Val / H1.Val * state;
                    {m/d}     {m}     {g/m3}

        Flux2Wat :=  Flux2Water;
       {g/ m3 d}
        db :=   - Burial - Flux2Wat - Flux2Anaerobic;
      {g/m3 d}
       If AllStates.Diagenesis_Steady_State then db := 0; {Layer 1 is STEADY STATE}

      End
    else {SedLayer2}
      Begin
        Flux2Anaerobic := Flux2Anaerobic + (w2.Val * PO4_1 / H2.Val); {include burial from L1}
        Burial :=  w2.Val * PO4_2 / H2.Val;

        Dia_Flux := 0;
        For ns := POP_G1 to POP_G3 do
          Begin
            ppp := GetStatePointer(ns,Stv,SedLayer2);
            Dia_Flux := Dia_Flux + ppp.mineralization;
          End;                           {g/ m3 d}

        db :=  Dia_Flux - Burial + Flux2Anaerobic;
      {g/m3 d}
      End;
  end;
  WriteRates;
  TrackMB;
end;

constructor TPO4_Sediment.Init;
begin
  Inherited;
end;

{ TNO3_Sediment }

procedure TNO3_Sediment.CalculateLoad(TimeIndex: Double);
begin
  Loading := 0;
end;

Function TNO3_Sediment.Denit_Rate(NO3Conc: Double): Double;  {eqns 5.23&24}  {m2/d2, L1, m/d L2}
Var Temp, Salt, KappaNO3: Double;
begin
   Temp := AllStates.GetState(Temperature,StV,WaterCol);
   Salt := AllStates.GetState(Salinity,StV,WaterCol);

 With AllStates.Diagenesis_Params^ do
  If Layer=SedLayer1 then
   Begin
     If Salt > SaltND.Val then KappaNO3 := KappaNO3_1s.Val
                          else KappaNO3 := KappaNO3_1f.Val;

     Denit_Rate := (SQR(KappaNO3) * POWER(ThtaNO3.Val,(Temp - 20)));
   End
  else {SedLayer2, Anaerobic}
     Denit_Rate := (KappaNO3_2.Val) * POWER(ThtaNO3.Val,(Temp - 20));

end;

Function TNO3_Sediment.Flux2Water: Double;
Var s, NO3_0: Double;
Begin

    NO3_0 := AllStates.GetState(Nitrate,StV,WaterCol);
    s   := AllStates.MassTransfer;
    {m/d}

    With AllStates.Diagenesis_Params^ do
     Flux2Water := s  * (State - NO3_0) / H1.Val;
    {g/m3 d}     {m/d}   {g/m3}   {g/m3}    {m }
End;

procedure TNO3_Sediment.Derivative(var DB: double);
Var s, Nitr, DeNitr, Burial, Flux2Anaerobic, Flux2Wat: Double;
    NH4_1, NO3_2, NO3_1 : Double;
    TNH4_1: TNH4_Sediment;

    {--------------------------------------------------}
    Procedure TrackMB;
    Var SedVol, DenitrInKg, BuryInKg: Double;
    Begin
      If Layer = SedLayer2 then SedVol := AllStates.DiagenesisVol(2)
                           else SedVol := AllStates.DiagenesisVol(1);
      If Layer = SedLayer2
        then BuryInKg := (Burial * SedVol * 1e-3)  {burial loss from the system}
        else BuryInKg := 0;  {burial from Layer 1 goes to Layer 2}

      If (Layer = SedLayer2) or (not Allstates.Diagenesis_Steady_State) then  //don't track denitrification MB in steady-state layer as irrelevant
         DenitrInKg := (Denitr * SedVol * 1e-3)   {denitrification loss from the system}
       {kg N / d}      {g/m3 d}   {m3}   {kg/g}
       else DenitrinKg := 0;

      with AllStates do with MBLossArray[Nitrate] do
        Begin
          TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + BuryInKg + DenitrInKg;
          Burial[Derivstep]     := Burial[Derivstep] + BuryInKg;
          BoundLoss[DerivStep] := BoundLoss[DerivStep] + BuryInKg + DenitrInKg;  {Loss from the system}
          Denitrify[Derivstep]  := Denitrify[Derivstep] + DenitrInKg;
        End;
    End;
    {--------------------------------------------------}
     Procedure WriteRates;
     Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) and (Layer = SedLayer1) then
        Begin
          ClearRate;
          SaveRate('State',state);
          SaveRate('Nitrification',nitr);
          SaveRate('Denitrification',Denitr);
          SaveRate('Burial',Burial);
          SaveRate('Flux2Water',Flux2Wat);
          SaveRate('Flux2Anaerobic',Flux2Anaerobic);
        End;

     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) and (Layer = SedLayer2) then
        Begin
          ClearRate;
          SaveRate('State',state);
          SaveRate('Burial',Burial);
          SaveRate('Denitrification',Denitr);
          SaveRate('Flux2Anaerobic',Flux2Anaerobic);
        End;
    End;
    {--------------------------------------------------}

begin {TNO3_Sediment.Derivative}
 TNH4_1 := AllStates.GetStatePointer(Ammonia,StV,SedLayer1);

 With AllStates.Diagenesis_Params^ do
  begin
    NO3_1 := AllStates.GetState(Nitrate,StV,SedLayer1);
    NH4_1 := AllStates.GetState(Ammonia,StV,SedLayer1);
    NO3_2 := AllStates.GetState(Nitrate,StV,SedLayer2);
    Flux2Anaerobic := - KL12 * (NO3_2 - NO3_1) ;
    {g/m2 d}            {m/d}   {g/m3}
    If Layer=SedLayer1 then Flux2Anaerobic := Flux2Anaerobic / H1.Val
                       else Flux2Anaerobic := Flux2Anaerobic / H2.Val;
                               {g/m3 d}          {g/m2 d}       {m}


    s   := AllStates.MassTransfer;
    {m/d}

    If Layer = SedLayer1 then
      Begin
        Burial  :=  w2.Val / H1.Val * state;
                   {m/d}     {m}     {mg/L}

        Nitr := TNH4_1.Nitr_Rate(NH4_1) / s *  NH4_1 / H1.Val ;  {EFDC eq. 5-20}
      {g/m3 d}                   {m2/d2} {m/d}  {g/m3}    {m}

        DeNitr := Denit_Rate(State)/s * State / H1.Val;
        {g/m3 d}   {m2/d2}        {m/d} {g/m3}  {m}

        Flux2Wat :=  Flux2Water;

        db :=   Nitr - Denitr - Burial - Flux2Wat - Flux2Anaerobic;
      {g/m3 d}

       If AllStates.Diagenesis_Steady_State then db := 0; {Layer 1 is STEADY STATE}

      End
    else {SedLayer2}
      Begin
        Flux2Anaerobic := Flux2Anaerobic + (w2.Val * NO3_1 / H2.Val);   {include burial from L1}
        Burial :=  w2.Val * (NO3_2) / H2.Val;   {deep burial}
        DeNitr := Denit_Rate(State) * State / H2.Val;
        {g/m3 d}   {m/d}              {g/m3}  {m}

        db :=  - Denitr - Burial + Flux2Anaerobic;
      {g/m3 d}
      End;
  end;
  WriteRates;
  TrackMB;
end;

constructor TNO3_Sediment.Init;
begin
  inherited;
end;

{ TPOC_Sediment }

procedure TPOC_Sediment.CalculateLoad(TimeIndex: Double);
begin
  Loading := 0;
end;

function TPOC_Sediment.Mineralization: Double;  {gC/m3 day}
Var Temp: Double;
Begin
 Temp := AllStates.GetState(Temperature,stv,watercol);
 With AllStates.Diagenesis_Params^ do
   Case NState of
     POC_G1: Mineralization := KPOC1.Val * POWER(ThtaPOC1.Val,Temp-20) * State;
     POC_G2: Mineralization := KPOC2.Val * POWER(ThtaPOC2.Val,Temp-20) * State;
        else Mineralization := KPOC3.Val * POWER(ThtaPOC3.Val,Temp-20) * State;
             {g C/m3 d}          {1/d}           {unitless}             {g C/m3}
     End;
End;

Function TPOC_Sediment.Burial: Double;

Begin
  With AllStates.Diagenesis_Params^ do
     Burial  :=  w2.Val / H2.Val * state;
End;             {m/d}     {m}     {mg/L}


Function TPOC_Sediment.Predn: Double;
Begin
     Predn := 0;
     If NState=POC_G1 then Predn := TOrganism(Self).Predation /  Detr_OM_2_OC;
     If NState=POC_G2 then Predn := TOrganism(Self).Predation /  Detr_OM_2_OC;
                         {g OC/m3 w}               {g OM /m3}   {g OM / g OC} ;
End;

procedure TPOC_Sediment.Derivative(var DB: double);
Var Minrl, Deposition, Bury, Pred: Double;

    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',state);
          SaveRate('Deposition',Deposition);
          SaveRate('Mineralization',Minrl);
          SaveRate('Burial',Bury);
          SaveRate('Predation',Pred );
        End;
    End;

begin
   With AllStates do with Diagenesis_Params^ do
     Begin
       Deposition := CalcDeposition(NState,StV)  / H2.Val ;
        {mg C/L}        {g O2/m2}                   {m}
       Diag_Track[POC_Dep,DerivStep] := Diag_Track[POC_Dep,DerivStep] + Deposition * H2.Val * 1e3;
         {mg/m2 d}                                                      {g/m3 sed}   {m sed}  {mg/g}
       Minrl := Mineralization;
       Bury  := Burial;
     End;

     Pred := Predn;

     With AllStates do With Location.Morph do
       Pred := Pred * SegVolum[VSeg] / DiagenesisVol(2);
    {g/m3 s} {g/m3 w}   {m3 w}               {m3 s}

   DB := Deposition - Minrl - Burial - Pred;
   WriteRates;
end;

constructor TPOC_Sediment.Init;
begin
  inherited;
end;


{ TPON_Sediment }

procedure TPON_Sediment.CalculateLoad(TimeIndex: Double);
begin
   Loading := 0;
end;

function TPON_Sediment.Mineralization: Double;
Var Temp: Double;
Begin
 Temp := AllStates.GetState(Temperature,stv,watercol);
 With AllStates.Diagenesis_Params^ do
   Case NState of
     PON_G1: Mineralization := KPON1.Val * POWER(ThtaPON1.Val,Temp-20) * State;
     PON_G2: Mineralization := KPON2.Val * POWER(ThtaPON2.Val,Temp-20) * State;
        else Mineralization := KPON3.Val * POWER(ThtaPON3.Val,Temp-20) * State;
             {g N/m3 d}          {1/d}           {unitless}             {g N/m3}
   End;
End;


procedure TPON_Sediment.Derivative(var DB: double);
Var Minerl, Deposition, Burial, Pred: Double;

    {--------------------------------------------------}
    Procedure TrackMB;
    Var SedVol, LossInKg: Double;
    Begin
      SedVol := AllStates.DiagenesisVol(2);
      LossInKg   := (Burial * SedVol * 1e-3) ;  {burial loss from the system}
    {kg N / d}      {g/m3 d}   {m3}   {kg/g}

      with AllStates do with MBLossArray[Nitrate] do
        Begin
          TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
          BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg ;  {Loss from the system}
          Burial[Derivstep]     := Burial[Derivstep] + LossInKg;
        End;
    End;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',state);
          SaveRate('Deposition',Deposition);
          SaveRate('Mineralization',Minerl);
          SaveRate('Burial',Burial);
          SaveRate('Predation',Pred );

        End;
    End;
    {--------------------------------------------------}

begin
   With AllStates do with Diagenesis_Params^ do
     Begin
       Minerl := Mineralization;
       Deposition := CalcDeposition(NState,StV) / H2.Val ;
       {mg/L}                {g/m2}                 {m}
       Diag_Track[PON_Dep,DerivStep] := Diag_Track[PON_Dep,DerivStep] + Deposition * H2.Val * 1e3;
         {mg/m2 d}                                                      {g/m3 sed}   {m sed}  {mg/g}
       Burial  :=  w2.Val / H2.Val * state;
     End;          {m/d}     {m}     {mg/L}

     Pred := 0;
     If NState=PON_G1 then Pred := TOrganism(Self).Predation * Location.Remin.N2OrgLab;
     If NState=PON_G2 then Pred := TOrganism(Self).Predation * Location.Remin.N2Org_Refr;
                         {g N/m3 w}               {g OM /m3}               {g N / g OM }
     With AllStates do With Location.Morph do
       Pred := Pred * SegVolum[VSeg] / DiagenesisVol(2);
    {g/m3 s} {g/m3 w}   {m3 w}             {m3 s}

   DB := Deposition - Minerl - Burial - Pred;
   WriteRates;
   TrackMB;

end;

constructor TPON_Sediment.Init;
begin
  inherited;

end;


{ TPOP_Sediment }

procedure TPOP_Sediment.CalculateLoad(TimeIndex: Double);
begin
  Loading := 0;
end;


function TPOP_Sediment.Mineralization: Double;
Var Temp: Double;
Begin
 Temp := AllStates.GetState(Temperature,stv,watercol);
 With AllStates.Diagenesis_Params^ do
   Case NState of
     POP_G1: Mineralization := KPOP1.Val * POWER(ThtaPOP1.Val,Temp-20) * State;
     POP_G2: Mineralization := KPOP2.Val * POWER(ThtaPOP2.Val,Temp-20) * State;
        else Mineralization := KPOP3.Val * POWER(ThtaPOP3.Val,Temp-20) * State;
             {g P/m3 d}          {1/d}           {unitless}             {g C/m3}
     End;
End;


procedure TPOP_Sediment.Derivative(var DB: double);
Var Deposition, Burial, Minerl, Pred: Double;

    {--------------------------------------------------}
    Procedure TrackMB;
    Var SedVol, LossInKg: Double;
    Begin
      SedVol := AllStates.DiagenesisVol(2);
      LossInKg   := (Burial * SedVol * 1e-3) ;  {burial loss from the system}
    {kg N / d}      {g/m3 d}   {m3}   {kg/g}

      with AllStates do with MBLossArray[Phosphate] do
        Begin
          TotalNLoss[Derivstep] := TotalNLoss[Derivstep] + LossInKg;
          Burial[Derivstep]     := Burial[Derivstep] + LossInKg;
          BoundLoss[DerivStep] := BoundLoss[DerivStep] + LossInKg ;  {Loss from the system}
        End;
    End;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',state);
          SaveRate('Deposition',Deposition);
          SaveRate('Mineralization',Minerl);
          SaveRate('Burial',Burial);
          SaveRate('Predation',Pred );
        End;
    End;

begin
   With AllStates do with Diagenesis_Params^ do
     Begin
       Minerl := Mineralization;
       Deposition := CalcDeposition(NState,StV) / H2.Val;
       {mg/L d}            {g/m2 d}                {m}
       Diag_Track[POP_Dep,DerivStep] := Diag_Track[POP_Dep,DerivStep] + Deposition * H2.Val * 1e3;
         {mg/m2 d}                                                      {g/m3 sed}   {m sed}  {mg/g}
       Burial  :=  w2.Val / H2.Val * state;
     End;{g/m3}    {m/d}     {m}     {g/m3}

     Pred := 0;
     If NState=POP_G1 then Pred := TOrganism(Self).Predation * Location.Remin.P2OrgLab;
     If NState=POP_G2 then Pred := TOrganism(Self).Predation * Location.Remin.P2Org_Refr;
                         {g P/m3 w}                {g P /m3}  {g P / g OM }
     With AllStates do With Location.Morph do
       Pred := Pred * SegVolum[VSeg] / DiagenesisVol(2);
    {g/m3 s} {g/m3 w}   {m3 w}             {m3 s}

   DB := Deposition - Minerl - Burial - Pred;
  {g/m3 d}
   WriteRates;
   TrackMB;
end;


constructor TPOP_Sediment.Init;
begin
  Inherited;
end;

{ TMethane }

procedure TMethane.CalculateLoad(TimeIndex: Double);
begin
  Loading := 0;
end;

procedure TMethane.Derivative(var DB: double);
Var SECH_ARG, Dia_Flux, Flux2Wat, Oxid  : Double;
    PNO3_1, PNO3_2: TNO3_Sediment;
    CSODmax, Temp,
    CSOD, CH4Sat, S, JO2NO3          : Double;

    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',state);
          SaveRate('Dia_Flux',Dia_Flux);
          SaveRate('Flux2Water',Flux2Wat);
          SaveRate('Oxidation',Oxid);
        End;
    End;

begin

   With AllStates.Diagenesis_Params^ do
     Begin
        If GetState(Salinity,StV,WaterCol) >= SaltSW.Val {ppt} then
          Begin  {Goes to Sulfide Instead}
            Dia_Flux :=0; Flux2Wat := 0; Oxid :=0; db := 0; WriteRates;
            Exit;
          End;

        Temp   := GetState(Temperature,StV,WaterCol);
   {    CH4_0  := GetState(Methane,StV,WaterCol); }

        Dia_Flux := TSulfide_Sediment(Self).Diagenesis * H2.Val;
       {g O2/m2 d}            {g O2/m3 d}                 {m}

         s   := AllStates.MassTransfer;
       {m/d}
        PNO3_1 := GetStatePointer(Nitrate,StV,SedLayer1);
        PNO3_2 := GetStatePointer(Nitrate,StV,SedLayer2);

        JO2NO3 := 2.86 * (   PNO3_1.Denit_Rate(PNO3_1.State)/s * PNO3_1.State
        {g/m2 d}           + PNO3_2.Denit_Rate(PNO3_2.State)   * PNO3_2.State);
                             { m/d                            }    {g/m3}

        Dia_Flux := Dia_Flux - JO2NO3;  { Jc_O2Equiv }
        {g/m2 d}    {g O2/m2}  {g O2/m2}
        If Dia_Flux<0 then Dia_Flux := 0;

        CH4SAT := 100 * (1 + AllStates.DynamicZMean / 10) * POWER(1.024,(20 - Temp));
        {saturation conc of methane in pore water {g 02/m3}

        CSODmax := Min(Sqrt(2 * KL12 * CH4SAT * Dia_Flux), Dia_Flux);

        SECH_ARG := (KappaCH4.Val * POWER(ThtaCH4.Val , (Temp - 20))) / s ;  //     CSOD Equation 10.35 from DiTorro
        If (SECH_ARG < 400)                                            //    The hyperbolic secant is defined as HSec(X) = 2 / (Exp(X) + Exp(-X))
          Then CSOD := CSODmax * (1 - (2 / (Exp(SECH_ARG) + Exp(-SECH_ARG))))
          Else CSOD := CSODmax;                                          // HSec(SECH_ARG) < 3.8E-174 ~ 0

        Flux2Wat := Dia_Flux - CSOD; {(CSODmax - CSOD); }
                             {oxidation}
        Oxid     := CSOD;

        DB             := (Dia_Flux - Flux2Wat - Oxid)/H2.Val;
       {g O2eq / m3 d}      {g O2eq / m2 d}            {m}
     End;

   WriteRates;
end;

constructor TMethane.Init;
begin
  Inherited;
end;

{------------------------------------------------------------------------------}

function TSulfide_Sediment.Diagenesis: Double;
Var s, Jc, Jn: Double;
    ns: Allvariables;
    ppc: TPOC_Sediment;
    PNO31, PNO32: TNO3_Sediment;
Begin
 Diagenesis := 0;
 If (Layer = SedLayer1) then exit;

   {determine diagenesis fluxes}
 Jc := 0;
 With AllStates.Diagenesis_Params^ do
   Begin
     For ns := POC_G1 to POC_G3 do
      Begin
        ppc := GetStatePointer(ns,Stv,SedLayer2);
        Jc := Jc + ppc.mineralization * 32 / 12 ;
      End; {gO2/ m3 d}    {g C / m3 }   {g O2/ g C}

     PNO31 := GetStatePointer(Nitrate,Stv,SedLayer1);
     PNO32 := GetStatePointer(Nitrate,Stv,SedLayer2);

     s   := AllStates.MassTransfer;
     {m/d}

     Jn  := 2.86* (PNO31.Denit_Rate(PNO31.State)/s * PNO31.State +
   {g/m3 d}                {m2/d2}             {m/d}      {g/m3}
                   PNO32.Denit_Rate(PNO32.State) * PNO32.State ) / H2.Val;
                            {m/d}                     {g/m3}        {m}

   End;

  Diagenesis :=  JC  -  JN;
 {g O2/m3 d}     {g O2/m3 d}
End;

function TSulfide_Sediment.k2Oxid: Double; {reaxn vel for sulfide oxidation}
Var Temp,O2, fdh2s1, fph2s1: Double;
Begin
  k2Oxid := 0;
  If Layer = SedLayer2 then Exit;

  With AllStates.Diagenesis_Params^ do
    Begin
      O2  := AllStates.GetState(Oxygen,StV,WaterCol);
      Temp := AllStates.GetState(Temperature,StV,WaterCol);

      fdh2s1 := 1/(1+m1.val * kdH2S1.Val);
      fph2s1 := 1-fdh2s1;

      k2Oxid :=  (SQR(KappaH2Sd1.Val) * fdh2s1 + (SQR(KappaH2Sp1.Val) * fph2s1)) * POWER(ThtaH2S.Val,Temp-20) * O2 / (2 * KMHSO2.Val);
     {g2/m2}
    End;
End;


procedure TSulfide_Sediment.CalculateLoad(TimeIndex: Double);
begin
  Loading := 0;
end;

procedure TSulfide_Sediment.Derivative(var DB: double);
Var Burial, Oxid, Dia_Flux,Flux2Wat, s, COD_0, Flux2Anaerobic: Double;
    H2S_2, H2S_1, fph2s1,  fdh2s1, fph2s2, fdh2s2: Double;

    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',state);
          If Layer = SedLayer1 then SaveRate('Oxidation',Oxid);
          If Layer = SedLayer1 then SaveRate('Flux2Water',Flux2Wat);
          If Layer = SedLayer2 then SaveRate('Dia_Flux',Dia_Flux);
          SaveRate('Burial',Burial);
          SaveRate('Flux2Anaerobic',Flux2Anaerobic);
        End;
    End;

begin
   With AllStates.Diagenesis_Params^ do
     Begin
        If GetState(Salinity,StV,WaterCol) < SaltSW.Val {ppt} then
          Begin  {Goes to Methane Instead}
            Dia_Flux:=0; Flux2Wat:= 0; Oxid:=0; Burial:=0; Flux2Anaerobic:=0; db:=0; WriteRates;
            Exit;
          End;

       Dia_Flux := Diagenesis;
       s   := AllStates.MassTransfer;
      {m/d}

      If Layer=SedLayer1
        then Oxid := k2Oxid   /s * State / H1.Val
                     {m2/d2} {m/d} {g/m3}   {m}
        else Oxid := 0;

      fdh2s1 := 1/(1+m1.val * kdH2S1.Val);
      fph2s1 := 1-fdh2s1;
      fdh2s2 := 1/(1+m2.val * kdH2S2.Val);
      fph2s2 := 1-fdh2s2;

      COD_0 := GetState(COD,StV,WaterCol);
      H2S_1 := GetState(Sulfide,StV,SedLayer1);
      H2S_2 := GetState(Sulfide,StV,SedLayer2);

      Flux2Anaerobic :=  - ((w12*(fpH2S2*H2S_2 - fpH2S1*H2S_1) + KL12 * (fdH2S2*H2S_2 - fdH2S1*H2S_1)));
      If Layer=SedLayer1 then Flux2Anaerobic := Flux2Anaerobic / H1.Val
                         else Flux2Anaerobic := Flux2Anaerobic / H2.Val;
                                 {g/m3 d}          {g/m2 d}       {m}

      If Layer=SedLayer2 then Flux2Anaerobic := Flux2Anaerobic + w2.Val / H2.Val * H2S_1; {burial from L1}

       If Layer = SedLayer2
         then Flux2Wat := 0
         else Flux2Wat := s*(fdh2s1*State - COD_0) / H1.Val;
                {mg/L d}   {m/d}    {mg/L}  {mg/L}     {m}

       If Layer = SedLayer2
          then  Burial  :=  w2.Val / H2.Val * state
          else  Burial  :=  w2.Val / H1.Val * state
     End;       {g/m3 d}    {m/d}     {m}     {g/m3}

   If Layer=SedLayer1
     then Begin
            If AllStates.Diagenesis_Steady_State
              then db := 0 {Layer 1 is STEADY STATE}
              else DB := - Oxid - Burial - Flux2Wat - Flux2Anaerobic;
          End  {SedLayer1}
     else DB := Dia_Flux - Burial + Flux2Anaerobic;
   WriteRates;
end;


constructor TSulfide_Sediment.Init;
begin
  Inherited;
end;

{-------------------------------------------------------------------------------}

{ TSilica_Sediment }

procedure TSilica_Sediment.CalculateLoad(TimeIndex: Double);
begin
  Loading := 0;
end;


function TSilica_Sediment.Dissolution(fdsi2:Double): Double;
Var PSi, Si2, Temp: Double;
Begin
 Dissolution := 0;
 If Layer = SedLayer1 then Exit;

 Temp := AllStates.GetState(Temperature,StV,WaterCol);

 PSi := AllStates.GetState(Avail_Silica,StV,SedLayer2);     // biogenic silica
 Si2 := AllStates.GetState(Silica,StV,SedLayer2);

 With AllStates.Diagenesis_Params^ do
   Dissolution := Ksi.val * POWER(ThtaSi.Val ,(Temp - 20)) *  (Psi/(Psi + KMpsi.val))
     {g/m3 d}      {1/d}       * (SiSat.val - fdsi2 * Si2);
                                   {g/m3}        {g/m3}
End;


procedure TSilica_Sediment.Derivative(var DB: double);
Var s, O2: Double;
    Diss, Flux2Anaerobic, Flux2Wat: Double;
    Si_2, Si_1, Si_0: Double;
    KdSi1: Double;
    fdsi1, fdsi2, fpsi1, fpsi2: Double;
    Deposition, Burial : Double;

    {----------------------------------------------------------------------}
    Procedure WriteAvailRates;  {biogenic silica, L2}
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',state);
          SaveRate('Deposition',Deposition);
          SaveRate('Dissolution',Diss);
          SaveRate('Burial',Burial);
        End;
    End;
    {----------------------------------------------------------------------}
    Procedure WriteSilicaRates;  {non-biogenic}
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) and (Layer = SedLayer1) then
        Begin
          ClearRate;
          SaveRate('State',state);
          SaveRate('Burial',Burial);
          SaveRate('Flux2Water',Flux2Wat);
          SaveRate('Flux2Anaerobic',Flux2Anaerobic);
        End;

     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) and (Layer = SedLayer2) then
        Begin
          ClearRate;
          SaveRate('State',state);
          SaveRate('Dissolution',Diss);
          SaveRate('Burial',Burial);
          SaveRate('Flux2Anaerobic',Flux2Anaerobic);
        End;
    End;  {writesilicarates}
    {----------------------------------------------------------------------}

Begin {TSilica_Sediment.Derivative}
  With AllStates.Diagenesis_Params^ do
    Begin
      O2  := AllStates.GetState(Oxygen,StV,WaterCol);
      If (O2 > O2critSi.Val)
         Then KdSi1 := KdSi2.Val * dKDSi1.Val
         Else KdSi1 := KdSi2.Val * POWER(dKDSi1.Val ,(O2 / O2critSi.Val));

      fdsi1 := (1 / (1 + m1.val * Kdsi1));
      fpsi1 := 1 - fdsi1;
      fdsi2 := (1 / (1 + m2.val * Kdsi2.val));
      fpsi2 := 1 - fdsi2;
    End;

  If nstate = Avail_Silica then  {Particulate Biogenic Silica}
    Begin
       With AllStates.Diagenesis_Params^ do
         Begin
           Diss := Dissolution(fdsi2);
           {mg/L d}
           Deposition := AllStates.CalcDeposition(NState,StV) / H2.Val;
           {mg/L d}                         {g/m2 d}              {m}
           Burial  :=  w2.Val / H2.Val * state;
         End;          {m/d}     {m}     {g/m3}

       DB := Deposition - Diss - Burial;
       {g/m3 d}
       WriteAvailRates;
    End;

  If nstate = Silica then  {Silica}
    Begin
      With AllStates.Diagenesis_Params^ do
      begin
          Si_0 := AllStates.GetState(Silica,StV,WaterCol);
          Si_1 := AllStates.GetState(Silica,StV,SedLayer1);
          Si_2 := AllStates.GetState(Silica,StV,SedLayer2);

          Flux2Anaerobic :=  - ((w12*(fpSi2*Si_2 - fpsi1*Si_1) + KL12 * (fdsi2*Si_2 - fdsi1*Si_1))) ;
            {g/m2 d}             {m/d}   {g/m3}                  {m/d}   {g/m3}
          If Layer=SedLayer1 then Flux2Anaerobic := Flux2Anaerobic / H1.Val
                             else Flux2Anaerobic := Flux2Anaerobic / H2.Val;
                                     {g/m3 d}          {g/m2 d}       {m}

          s   := AllStates.MassTransfer;
        {m/d}

          If Layer = SedLayer1 then
            Begin
              Burial  :=  w2.Val / H1.Val * state;
                          {m/d}     {m}     {mg/L}
              Flux2Wat :=  s*(fdsi1*State - Si_0) / H1.Val;
                {m/d}      {m/d}    {mg/L}   {mg/L}    {m}

              db :=   - Burial - Flux2Wat - Flux2Anaerobic;
              If AllStates.Diagenesis_Steady_State then db := 0; {Layer 1 is STEADY STATE}
            End
          else {SedLayer2}
            Begin
              Flux2Anaerobic := Flux2Anaerobic + w2.Val*Si_1/H2.Val; {burial from L1}
              Burial :=  w2.Val * Si_2/ H2.Val;
              Diss := Dissolution(fdsi2);

              db :=  Diss - Burial + Flux2Anaerobic;
            End;
        end;
       WriteSilicaRates;
    End;
End;


constructor TSilica_Sediment.Init;
begin
  Inherited;
end;
{-------------------------------------------------------------------------------}

constructor TCOD.Init;
begin
  Inherited;
end;

Procedure TCOD.Derivative(var db: Double);
begin
    db := 0;
    With AllStates.SetupRec^ do
     If (SaveBRates or ShowIntegration) then
       Begin
         ClearRate;
         SaveRate('State',State);
       End;
end;

Procedure TCOD.CalculateLoad(TimeIndex : Double);
Begin
  inherited CalculateLoad(TimeIndex); {TStateVariable}
  State := Loading;  {valuation not loading, no need to adjust for flow and volume}
End;


{------------------------------------------------------------------------------}
function TNH4_Sediment.ObjectID: SmallInt;  Begin  ObjectID:=1062;  End;
function TNO3_Sediment.ObjectID: SmallInt;  Begin  ObjectID:=1063;  End;
function TPO4_Sediment.ObjectID: SmallInt;  Begin  ObjectID:=1064;  End;
function TPOC_Sediment.ObjectID: SmallInt;  Begin  ObjectID:=1065;  End;
function TPON_Sediment.ObjectID: SmallInt;  Begin  ObjectID:=1066;  End;
function TPOP_Sediment.ObjectID: SmallInt;   Begin  ObjectID:=1067;  End;
function TMethane.ObjectID: SmallInt;         Begin  ObjectID:=1068;  End;
function TSulfide_Sediment.ObjectID: SmallInt; Begin  ObjectID:=1069;  End;
function TSilica_Sediment.ObjectID: SmallInt; Begin  ObjectID:=1070;  End;
function TCOD.ObjectID: SmallInt; Begin  ObjectID:=1071;  End;
{------------------------------------------------------------------------------}

End.
