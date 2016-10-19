//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
{--------------------------------------}
{      MULTI LAYER SEDIMENT MODEL      }
{--------------------------------------}

{******************************}
{*   TSuspSediment OBJECT     *}
{******************************}

Constructor TSuspSediment.Init(Ns : StateVariables; SVT: T_SVType; L: T_SVLayer; aName : ShortString;
                           P : TStates; IC : double; IsTempl: Boolean);

Begin
  Inherited Init(Ns,SVT,L,aName,P,IC,IsTempl);
  StateUnit   :='mg/L';
  LoadingUnit :='mg/L';
End;

{----------------------------------------------------------------------}
Destructor  TSuspSediment.Destroy;
Begin
   inherited Destroy;
End;

{----------------------------------------------------------------------}
Procedure TSuspSediment.CalculateLoad(TimeIndex : double);

{ atmospheric and point-source loadings should be to epilimnion in single-segment version. 11/19/96}

Var Loop      : Alt_LoadingsType;
    SegVolume : Double;
    Inflow    : Double;
    MultLdBy  : Double;

Begin
 With LoadsRec do
 Begin
    Loading:=0;
    If NoUserLoad then exit;

    SegVolume := AllStates.SegVol;
    With Location.Morph do
      Inflow := InflowH2O[AllStates.VSeg]* (OOSInflowFrac);

    {Inflow Loadings}
    Begin
      Inherited CalculateLoad(TimeIndex);  {TStateVariable}

      If NState=TSS then
         Begin
           State := Loading;
           Exit;  {valuation not loading, no need to adjust for flow and volume}
         End;

      Loading := Loading * Inflow / SegVolume;
      {unit/d     unit     cu m/d    cu m   }
    End;

    {Add Point Source, D.P., and Non-Point Source Loadings}
    If AllStates.LinkedMode or (AllStates.VSeg=Epilimnion) then
     If (not (Alt_Loadings[PointSource]=nil)) then
       For Loop:=PointSource to NonPointSource do
         Begin
            If Loop = DirectPrecip then MultLdBy := 1000 {g / kg}
                                   else MultLdBy := 1;
            If Alt_UseConstant[Loop]
               then Loading:=Loading+ ((Alt_ConstLoad[Loop] * MultLdBy *  Alt_MultLdg[Loop])/ SegVolume)
                    {mg/L d} {mg/L d}     {g/d or kg/d}     {conv to g/d}       {unitless}    {cu m}
               else if Alt_Loadings[Loop]<>nil
                    then Loading:=Loading+ (Alt_Loadings[Loop].GetLoad(TimeIndex,True)* MultLdBy  * Alt_MultLdg[Loop])/SegVolume;
         End;

 End; {With LoadsRec}
End;

{------------------------------------------------------------------}

Procedure TSuspSediment.Derivative(var DB: double);
Var Lo,WaO,WaI,Sc,De : Double;
    TopSediment      : TBottomSediment;
    Vol: Double;

    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          If (nstate=TSS) then Exit;
          SaveRate('Load',Lo);
          SaveRate('Scour',Sc);
          SaveRate('Deposition',De);
          SaveRate('Washout',WaO);
          SaveRate('WashIn',WaI);
          SaveRate('NetBoundary',Lo+WaI-WaO);
        End;
    End;
    {--------------------------------------------------}
Begin
   Sc := 0;   De := 0;  {initialize}
   Vol := AllStates.SegVol;

   If (nstate=TSS) then
     Begin
       db := 0;
       State := Loading;
       WriteRates;
       Exit;
     End;

   Lo := Loading;

   TopSediment := GetStatePointer(NState,StV,SedLayer1);
   If TopSediment <> nil then
       Begin
          De := TopSediment.Deposition / Vol;
        {mg/L d}            {g/d}       {m3}
          Sc := TopSediment.Scour  / Vol;
        {mg/L d}            {g/d}   {m3}
       End;

   WaO := Washout;
   WaI := WashIn;

   db := Lo + Sc - De - WaO + WaI ; {all units mg/l d}

   WriteRates;
End;

{--------------------------------------------------------------------------------------------------------------}
{*************************************}
{*      TSuspSedimentTOX OBJECT      *}
{*************************************}

Procedure TSuspSedimentTox.Derivative(var DB: double);
Var ScourTox,DeposTox,Lo, Sorpt, Desorpt: Double;
    TopLayer : TBottomSediment;
    CP: TSuspSediment;
    WashO, WashI, FracAerobic: Double;
    Mic,Mic_in_Aer,Mic_in_Anaer: Double;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('Load',Lo);
          SaveRate('State',State);
          SaveRate('ScourTox',ScourTox);
          SaveRate('DeposTox',DeposTox);
          SaveRate('Washout',WashO);
          SaveRate('WashIn',WashI);
          SaveRate('MicroMet',Mic);
          SaveRate('AerMM In',Mic_in_Aer);
          SaveRate('AnaerMM In',Mic_in_Anaer);
          SaveRate('Sorpt',Sorpt);
          SaveRate('Desorpt',Desorpt);
          SaveRate('NetBoundary',Lo+WashI-WashO);
        End;
    End;
    {--------------------------------------------------}

Var Volum, OOSDriftInKg, LoadInKg: Double;
Begin
   Lo := Loading;

   Volum := AllStates.SegVol;

   Sorpt :=0;    Desorpt :=0;
   DeposTox :=0; ScourTox:=0;

   CP := GetStatePointer(NState,StV,WaterCol);        {Susp sediment in which this tox is located}
   TopLayer := GetStatePointer(NState,StV,SedLayer1); {Top Layer of Buried Sediment}

   If TopLayer <> nil then
      Begin
        DeposTox := TopLayer.Deposition / Volum * GetPPB(NState,SVType,WaterCol) * 1e-6;
        {ug/L d}               {g/d}      {m3}                {ug/kg}            {kg/mg}
        ScourTox := TopLayer.Scour / Volum * GetPPB(NState,SVType,SedLayer1) * 1e-6;
        {ug/L d}            {g/d}     {m3}                {ug/kg}            {kg/mg}
      End;

  WashO := CP.Washout * GetPPB(NState,SVType,Layer) * 1e-6;

   With AllStates do with ToxLossArray[SVType] do With Location.Morph do
     Begin {save for tox loss output & categorization}
       OOSDriftInKg := WashO {*  OOSDischFrac }* SegVol * 1000.0 * 1e-9;  // 3/20/2014 remove OOSDischFrac
          {kg}         {ug/L}    {frac}           {m3}    {L/m3}  {kg/ug}
       TotalToxLoss[DerivStep] := TotalToxLoss[DerivStep] + OOSDriftInKg;
       TotalWashout[DerivStep] := TotalWashout[DerivStep] + OOSDriftInKg;
       WashoutSedm [DerivStep] := WashoutSedm[DerivStep] + OOSDriftInKg;
     End;

  WashoutStep[AllStates.DerivStep] := WashO * AllStates.SegVol;

  WashI := ToxInCarrierWashin;

    With AllStates do with ToxLoadArray[SVType] do
       Begin {save for tox loss output & categorization}
         LoadInKg := (Lo+WashI) * SegVol * 1000.0 * 1e-9;
            {kg}        {ug/L}      {m3}  {L/m3}   {kg/ug}

         TotOOSLoad[Derivstep] := TotOOSLoad[Derivstep] + LoadInKg;
         ToxLoadSed[Derivstep] := ToxLoadSed[Derivstep] + LoadInKg;
       End;

  Mic          := MicrobialMetabolism(FracAerobic);  {returns FracAerobic which is not used}
  Mic_in_Aer   := Microbial_BioTrans_To_This_SV(True);
  Mic_in_Anaer := Microbial_BioTrans_To_This_SV(False);

  Sorpt   := Sorption;
  Desorpt := Desorption;

  DB := Lo + ScourTox - DeposTox - WashO + WashI - Mic + Mic_in_Aer + Mic_in_Anaer + Sorpt - Desorpt ;  {all units ug/L (wc) d}
  WriteRates;
End;

{--------------------------------------------------------------------------------------------------------------}
{*********************************}
{*    TBottomSediment OBJECT     *}
{*********************************}

{CREATE EMPTY LOADSREC, USED IN MANY PROCEDURES}
Function EmptyLoad: LoadingsRecord;
Begin
   EmptyLoad.Loadings:=TLoadings.Init(2,1);
   EmptyLoad.ConstLoad:=0;
   EmptyLoad.MultLdg := 1.0;
   EmptyLoad.UseConstant:=True;
   EmptyLoad.NoUserLoad:=False;
   EmptyLoad.Alt_Loadings[PointSource]   := nil;
   EmptyLoad.Alt_Loadings[DirectPrecip]  := nil;
   EmptyLoad.Alt_Loadings[NonPointSource]:= nil;
End;


Constructor TBottomSediment.Init(Ns : StateVariables; SVT: T_SVType; L: T_SVLayer; aName : ShortString;
                                 P : TStates; IC : double; IsTempl: Boolean);
Begin
  Inherited Init(Ns,SVT,L,aName,P,IC,IsTempl);

  If (NState in [Cohesives..NonCohesives2]) and (Layer=SedLayer1) then
    Begin
      LDeposition := EmptyLoad;
      LScour      := EmptyLoad;
    End;

End;

Destructor  TBottomSediment.Destroy;
Begin
  If (NState in [Cohesives..NonCohesives2]) and (Layer=SedLayer1) then
    Begin
      LDeposition.Loadings.Destroy;
      LScour.Loadings.Destroy;
    End;
  inherited Destroy;
End;


Function TBottomSediment.CalcBedLoad: Double;
{Calculates BedLoad in Feedback Mode}
Var i: Integer;
    BLoad: Double;
    PLnk: TSegmentLink;
Begin

  CalcBedLoad := 0;
  If Layer <> SedLayer1 then Exit; {Bedload only to active layer}
  If Not AllStates.LinkedMode then exit;

  BLoad := 0;
  With AllStates.In_FB_Links do   {With all incoming feedback links}
    Begin
      For i:=0 to Count-1 do  {Step through all incoming feedback links}
        Begin
          PLnk := At(i);

          With AllStates do
            BLoad := BLoad + PLnk.GetBedLoad(NState,TPresent) / SedLayerArea ;
           {g/m2 d} {g/m2 d}          {g/d}                       {m2}

        End;
    End;  {with FB Links}

  CalcBedLoad := BLoad;
End;


Function TBottomSediment.CalcBedLoss: Double;
{Calculates BedLoss in Feedback Mode}
Var i: Integer;
    FB_BLoss, CS_BLoss: Double;
    PLnk: TSegmentLink;
Begin
  CalcBedLoss := 0;
  If Layer <> SedLayer1 then Exit; {BedLoss only to active layer}
  If Not AllStates.LinkedMode then exit;

  FB_BLoss := 0;
  With AllStates do with Out_FB_Links do   {With all outgoing feedback links}
    Begin
      For i:=0 to Count-1 do  {Step through all outgoing feedback links}
        Begin
          PLnk := At(i);

          FB_BLoss := FB_BLoss + PLnk.GetBedLoad(NState,TPresent) / AllStates.SedLayerArea ;
         {g/m2 d}     {g/m2 d}          {g/d}                                  {m2}
        End;
    End;  {with FB Links}

  CS_BLoss := 0;
  With AllStates do with Out_CS_Links do   {With all outgoing feedback links}
    Begin
      For i:=0 to Count-1 do  {Step through all outgoing feedback links}
        Begin
          PLnk := At(i);

          CS_BLoss := CS_BLoss + PLnk.GetBedLoad(NState,TPresent) / AllStates.SedLayerArea ;
         {g/m2 d}     {g/m2 d}          {g/d}                                  {m2}
        End;
    End;  {with FB Links}

  WashoutStep[AllStates.DerivStep] := CS_BLoss * AllStates.SedLayerArea;
                                       {g/m2 d}                {m2}
  CalcBedLoss := FB_BLoss + CS_BLoss;
End;


Procedure TBottomSediment.CalculateLoad(TimeIndex : double);      {Gets User Inputs of Scour & Deposition}
Var SuspState: Double;
Begin
  If Layer=SedLayer1 then
    Begin
      ScourLoad := ReturnLoad(AllStates.TPresent,LScour); {g/d}
      With AllStates do  {Can't scour more than there is...}
        If ScourLoad > State * SedLayerArea then ScourLoad := State * SedLayerArea;
            {g/d}      {g/m2}      {m2}           {g/d}       {g/m2}      {m2}

      DepLoad   := ReturnLoad(AllStates.TPresent,LDeposition); {g/d}
      SuspState := GetState(NState,StV,WaterCol);
      With AllStates do {Can't deposit more than there is...}
        If DepLoad > SuspState * SegVol then DepLoad := SuspState * SegVol;
            {g/d}     {g/m3}          {m3}              {g/d}       {g/m3}          {m3}
    End;
  Loading  := 0;
End;


Function TBottomSediment.Scour;

     Function ScourSand: Double;
     Const d_sand : double = 0.30;   { effective particle size in mm }
     Var vel, tstar, acsand,pcsand,dsandm: Double;
     Begin
       AllStates.CalcHRadius(False);

       vel := AllStates.Velocity(0,0,False) * 0.01;
      {m/s}                {cm/s}             {m/cm}
       dsandm := d_sand / 1000;
       With AllStates.Sed_Data do
         tstar  := (1./1.65)* HRadius * slope / dsandm ;
       With AllStates.Sed_Data do
         pcsand :=1000 * 0.05 * (1./1.65)*(Vel * slope) / (sqrt(1.65*9.807*dsandm))*Sqrt(tstar);
         {mg/L}                           {m/s}
       acsand := GetState(Noncohesives2,StV,WaterCol);
       If acSand > pcSand then ScourSand := 0
                          else ScourSand := (pcsand - acsand) * AllStates.SegVol {* 1e3 * 1e-3 };
                                {g/d)        {mg/L}   {mg/L}                    {m3}         {L/m3}  {g/mg}

     End;

     Function ScourSiltClay: Double;
     Const
        Ero_Clay : double = 0.244;{ 1.5;}   { erodability coefficients  kg/m2 day}
        Ero_Silt : double = 0.244;{ 1.7;}
     Var ts_nstate, ero_nstate: Double;
     Begin
       AllStates.CalcHRadius(False);

       With AllStates.Sed_Data do
         tau := 1000.0 * HRadius * slope;   {1000 is unit weight, or density, of water (62.4 lb/ft3 or 1000 kg/m3)}
        {kg/m2} {kg/m3}    {m}     {m/m}

       With Location.Locale do
         If nState=NonCohesives then begin
                               ts_nstate   := ts_Silt;   { kg/m2 }
                               Ero_nstate  := Ero_Silt;    { kg/m2 d }
                             end
        {nstate = clay} else begin
                               ts_nstate   := ts_Clay;   { kg/m2 }
                               Ero_nstate  := Ero_Clay;    { m/s }
                             end;


       With AllStates.Sed_Data do
       With AllStates.SedData[1] do
         If DynBedDepth = 0
           then ScourSiltClay :=0
           else If(tau>ts_nstate)    {warning???}
             then scourSiltClay := (Ero_NState/DynBedDepth)*(( tau / ts_nstate)-1.0) * AllStates.SegVol * 1000
                     {g/d}          {kg/m2 d}    {m}          {kg/m2}  {kg/m2}                    {m3}              {g/kg}
             else scourSiltClay := 0.0;

     End;


Begin
  If Layer=SedLayer1 then Scour := ScourLoad {g/d}
                     else Scour := 0;  { There is no Upward movement of this lower layer outside of
                                         total erosion of the top layer and corresponding upward movement,
                                         which is handled outside the derivatives in procedure DoThisEveryStep }

  If (Layer=SedLayer1) and AllStates.UseSSC then
    Begin
      if nstate = NonCohesives2 {sand}
        then Scour := ScourSand {g/d}
        else Scour := ScourSiltClay; {g/d}
    End;

End;

Function TBottomSediment.Deposition;

     Function DepositSand: Double;
     Const d_sand : double = 0.30;   { effective particle size in mm }
     Var vel, tstar, acsand,pcsand,dsandm: Double;
     Begin
       AllStates.CalcHRadius(False);

       vel := AllStates.Velocity(0,0,False) * 0.01;
      {m/s}                {cm/s}            {m/cm}
       dsandm := d_sand / 1000;
       With AllStates.Sed_Data do
         tstar  := (1./1.65)* HRadius * slope / dsandm ;
       With AllStates.Sed_Data do
         pcsand :=1000 * 0.05 * (1./1.65)*(Vel * slope) / (sqrt(1.65*9.807*dsandm))*Sqrt(tstar);
         {mg/L}                           {m/s}
       acsand := GetState(Noncohesives2,StV,WaterCol);
       If acSand < pcSand then DepositSand := 0
                          else DepositSand := (acsand - pcsand) * AllStates.SegVol * 1000;  {TESTME}
                                {g/d)          {mg/L}   {mg/L}                    {m3}         {L/m3}

     End;


     Function DepositSiltClay: Double;
     Var tdep_nstate, vt_nstate: Double;
     Begin
       AllStates.CalcHRadius(False);

       With AllStates.Sed_Data do
         tau := 1000.0 * HRadius * slope;   {1000 is unit weight, or density, of water (62.4 lb/ft3 or 1000 kg/m3)}
        {kg/m2} {kg/m3}    {m}     {m/m}

       With Location.Locale do
         If nState=NonCohesives then
                       begin
                         tdep_nstate := tdep_Silt;  { kg/m2 }
                         vt_nstate   := FallVel_Silt; { m/s }
                       end
  {nstate = clay} else begin
                         tdep_nstate := tdep_Clay;  { kg/m2 }
                         vt_nstate   := FallVel_Clay; { m/s }
                       end;

       With AllStates.Sed_Data do
       With AllStates.SedData[1] do
         If DynBedDepth = 0
           then DepositSiltClay :=0
           else if(tau<tdep_nstate) then DepositSiltClay :=(State/1000)*(1-exp((-vt_nstate*SecsPerDay/DynBedDepth)*(1.0-tau/tdep_nstate))) * AllStates.SegVol * 1000
                                           {g/d}              {kg/m3}             {m/s}     {s/d}           {m}                                    {m3}       {g/kg}
                                    else DepositSiltClay :=0.0;

     End;

Begin
  If Layer=SedLayer1
    then Deposition := DepLoad  {g/d}
    else Deposition := 0;

  If (Layer=SedLayer1) and AllStates.UseSSC then
    Begin
      if nstate = NonCohesives2 {sand}
        then Deposition := DepositSand {g/d}  {TESTME}
        else Deposition := DepositSiltClay {g/d}
    End;

End;


{----------------------------------------------------------------------}

Procedure TBottomSediment.Derivative(var DB: double);
Var Sco,Dep,BedLoad,BedLoss: Double;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Scour',Sco);
          SaveRate('Deposition',Dep);
          SaveRate('BedLoad',BedLoad);
          SaveRate('BedLoss',BedLoss);
        End;
    End;
    {--------------------------------------------------}

Begin
  Dep := Deposition / AllStates.SedLayerArea;
{g/m2 d}   {g/d}              {m2}
  Sco := Scour / AllStates.SedLayerArea;
{g/m2 d}   {g/d}              {m2}

  BedLoad := CalcBedLoad; {g/m2 d}
  BedLoss := CalcBedLoss; {g/m2 d}

  DB := Dep - Sco + Bedload - BedLoss;   {all units g/m2 d}
  WriteRates;
End;


{--------------------------------------------------------------------------------------------------------------}
{*********************************}
{*    TBottomCohesives OBJECT    *}
{*********************************}

{minor modification to allow for input of deposition/ erosion velocities}
{uses bottomsediment derivative}
Constructor TBottomCohesives.Init(Ns : StateVariables; SVT: T_SVType; L: T_SVLayer; aName : ShortString;
                                 P : TStates; IC : double; IsTempl: Boolean);
Begin
  Inherited Init(Ns,SVT,L,aName,P,IC,IsTempl);

  If (Layer=SedLayer1) then
    Begin
      LErodVel := EmptyLoad;
      LDepVel  := EmptyLoad;
    End;

End;

Procedure TBottomCohesives.CalculateLoad(TimeIndex : double);
Begin
  Inherited CalculateLoad(TimeIndex);

  If Layer=SedLayer1 then
    Begin
      EVel := ReturnLoad(AllStates.TPresent,LErodVel); {m/d}
      DVel := ReturnLoad(AllStates.TPresent,LDepVel);  {m/d}
    End;
  Loading  := 0;
End;

Destructor TBottomCohesives.Destroy;
Begin
  If (Layer=SedLayer1) then
    Begin
      LErodVel.Loadings.Destroy;
      LDepVel.Loadings.Destroy;
    End;
  inherited Destroy;
End;


{--------------------------------------------------------------------------------------------------------------}
{************************************}
{*    TBottomSedimentTOX OBJECT     *}
{************************************}

Function TBottomSedimentTox.CalcToxBedLoad: Double;
{Calculates BedLoadTox in Feedback Mode}
Var i: Integer;
    BLoad, BLoadTox: Double;

    PLnk: TSegmentLink;
    UpPPB: Double;
    PUpStreamCarrier: TBottomSediment;
Begin

  CalcToxBedLoad := 0;
  If Layer <> SedLayer1 then Exit; {Bedload only to active layer}
  If Not AllStates.LinkedMode then exit;

  BLoadTox := 0;
  With AllStates.In_FB_Links do   {With all incoming feedback links}
    Begin
      For i:=0 to Count-1 do  {Step through all incoming feedback links}
        Begin
          PLnk := At(i);

          PUpstreamCarrier := PLnk.FromPStates.GetStatePointer(NState,StV,Layer);
          UpPPB := PUpStreamCarrier.GetPPB(NState,SVType,Layer);

          BLoad :=  PLnk.GetBedLoad(NState,AllStates.TPresent) / AllStates.SedLayerArea ;
        {g/m2 d}          {g/d}                                    {m2}
          BLoadTox := BLoadTox +  BLoad  * UpPPB * 1e-3;
         {ug/m2 d}    {ug/m2 d}  {g/m2 d} {ug/kg} {kg/g}
        End;
    End;  {with FB Links}

    {cascade bedload is added in TStates.Add_Cascade_Washin}

  CalcToxBedLoad := BLoadTox;
End;



Function TBottomSedimentTox.CalcToxBedLoss: Double;
{Calculates BedLossTox in Feedback Mode}
Var i: Integer;
    BLoss, FB_BLossTox, CS_BLossTox: Double;
    PLnk: TSegmentLink;
    ThisPPB: Double;
Begin
  CalcToxBedLoss := 0;
  If Layer <> SedLayer1 then Exit; {BedLoss only to active layer}
  If Not AllStates.LinkedMode then exit;

  FB_BLossTox := 0;
  With AllStates.Out_FB_Links do   {With all outgoing feedback links}
    Begin
      For i:=0 to Count-1 do  {Step through all outgoing feedback links}
        Begin
          PLnk := At(i);

          ThisPPB := GetPPB(NState,SVType,Layer);

          BLoss :=  PLnk.GetBedLoad(NState,AllStates.TPresent) / AllStates.SedLayerArea ;
        {g/m2 d}          {g/d}                                 {m2}
          FB_BLossTox := FB_BLossTox + BLoss * ThisPPB * 1e-3;
          {ug/m2}         {ug/m2}     {g/m2}  {ug/kg}  {kg/g}
        End;
    End;  {with FB Links}

  CS_BLossTox := 0;
  With AllStates.Out_CS_Links do   {With all outgoing cascade links}
    Begin
      For i:=0 to Count-1 do  {Step through all outgoing cascade links}
        Begin
          PLnk := At(i);

          ThisPPB := GetPPB(NState,SVType,Layer);

          BLoss :=  PLnk.GetBedLoad(NState,AllStates.TPresent) / AllStates.SedLayerArea ;
        {g/m2 d}           {g/d}                                   {m2}
          CS_BLossTox := CS_BLossTox + BLoss * ThisPPB * 1e-3;
          {ug/m2}         {ug/m2}     {g/m2}  {ug/kg}  {kg/g}
        End;
    End;  {with CS Links}

  WashoutStep[AllStates.DerivStep] := CS_BLossTox * AllStates.SedLayerArea;
                                          {ug/m2}                  {m2}
  CalcToxBedLoss := FB_BLossTox + CS_BLossTox;
End;



Procedure TBottomSedimentTox.Derivative(var DB: double);
Var ThisSedm: TBottomSediment;
    ThisPore: TPoreWater;
    ScoTox,DepTox,Sorpt,Desorpt  : Double;
    BedLoad,BedLoss, FracAerobic : Double;
    Mic,Mic_in_Aer,Mic_in_Anaer  : Double;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('ScoTox',ScoTox);
          SaveRate('DepTox',DepTox);
          SaveRate('BedLoad',BedLoad);
          SaveRate('BedLoss',BedLoss);
          SaveRate('MicroMet',Mic);
          SaveRate('AerMM In',Mic_in_Aer);
          SaveRate('AnaerMM In',Mic_in_Anaer);
          SaveRate('Sorpt',Sorpt);
          SaveRate('Desorpt',Desorpt);
        End;
    End;
    {--------------------------------------------------}

Begin
  ThisSedm := GetStatePointer(NState,StV,Layer);  {Buried Sediment in which this toxicant resides}
  ThisPore := GetStatePointer(PoreWater,StV,Layer);  {Pore water in this layer}

  Sorpt := 0; Desorpt := 0;

  If ThisPore.VolumeInM3 < tiny
    Then
      Begin
        Sorpt := 0;
        Desorpt := 0;
      End
    Else
      Begin
        Sorpt :=   Sorption   * ThisPore.VolumeInL / AllStates.SedLayerArea;
       {ug/m2 d}  {ug/L d pw}               {L}                     {m2}
        Desorpt := Desorption;
      End;

  If ThisSedm.State < Tiny
    Then ScoTox := 0
    Else ScoTox := ThisSedm.Scour / AllStates.SedLayerArea / ThisSedm.State * State;
       {ug/m2 d}           {g/d}               {m2}              {g/m2}  {ug/m2}

  DepTox := ThisSedm.Deposition / AllStates.SedLayerArea * GetPPB(NState,SVType,Pred(Layer)) * 1e-3;
 {ug/m2 d}              {g/d}                {m2}                                {ug/kg}       {kg/g}

  BedLoad := CalcToxBedLoad; {ug/m2}
  BedLoss := CalcToxBedLoss; {ug/m2}

  Mic          := MicrobialMetabolism(FracAerobic);  {returns FracAerobic which is not used}
  Mic_in_Aer   := Microbial_BioTrans_To_This_SV(True);
  Mic_in_Anaer := Microbial_BioTrans_To_This_SV(False);

  DB :=  DepTox - ScoTox + BedLoad - BedLoss - Mic + Mic_in_Aer + Mic_in_Anaer + Sorpt - Desorpt;  {all units ug/m2 d}
  WriteRates;
End;

{----------------------------------------------------------------------}

Procedure TBottomSedimentTox.CalculateLoad(TimeIndex : double);
Begin
  Loading  := 0;
End;

{--------------------------------------------------------------------------------------------------------------}
{************************************}
{*      TBURIEDDETRIUS OBJECT       *}
{************************************}
{Buried Detritus Associated with the MULTI-LAYER SEDIMENT MODEL}

Constructor TBuriedDetr2.Init(Ns : StateVariables; SVT: T_SVType; Lyr:T_SVLayer; aName : ShortString;
                             P : TStates; IC : double; IsTempl: Boolean);
begin
  Inherited Init(Ns,SVT,Lyr,aName,P,IC,IsTempl);
end;

{----------------------------------------------------------------------}

Procedure TBuriedDetr2.CalculateLoad(TimeIndex : double);
Begin
  Loading  := 0; {No loading for buried Detr}
  If (Layer=SedLayer1) then Raise EAQUATOXError.Create('AQUATOX Internal Error: No BuriedDetr in SedLayer1');
End;

{----------------------------------------------------------------------}

Procedure TBuriedDetr2.Derivative(var DB: double);
Var Decomp: Double;
    FracAerobic: Double;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          If (nstate<>SedmRefrDetr) then SaveRate('Decomp',Decomp)
                                    else SaveRate('NoDeriv',0);
        End;
    End;
    {--------------------------------------------------}

Begin
  Decomp := 0;
  If (NState <> SedmRefrDetr)
    then Decomp := Decomposition(Location.Remin.DecayMax_Lab, KAnaerobic, FracAerobic);

  DB := - Decomp;   {units g/m2 d}
  WriteRates;
End;

{--------------------------------------------------------------------------------------------------------------}
{************************************}
{*      TBURIEDDETRTOX OBJECT       *}
{************************************}
{Toxicant in Buried Detritus Associated with the MULTI-LAYER SEDIMENT MODEL}

Procedure TBuriedDetrTox2.CalculateLoad(TimeIndex : double);

Begin
  Loading  := 0; {No loading for buried Detr Toxins}
End;

{----------------------------------------------------------------------}

Procedure TBuriedDetrTox2.Derivative(var DB: double);
Var ThisDetr: TBuriedDetr2;
    ThisPore: TPoreWater;
    DetrSorpt,DetrDesorpt, FracAerobic: Double;
    Decomp,Mic,Mic_in_Aer,Mic_in_Anaer: Double;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          If (Nstate<>SedmRefrDetr) then SaveRate('Decomp',Decomp);
          SaveRate('DetrSorpt',DetrSorpt);
          SaveRate('DetrDesorpt',DetrDesorpt);
          SaveRate('MicroMet',Mic);
          SaveRate('AerMM In',Mic_in_Aer);
          SaveRate('AnaerMM In',Mic_in_Anaer);
        End;
    End;
    {--------------------------------------------------}

Begin
  ThisDetr := GetStatePointer(NState,StV,Layer);  {Buried Detritus in which this toxicant resides}
  ThisPore := GetStatePointer(PoreWater,StV,Layer);  {Pore water in this layer}

  Mic          := MicrobialMetabolism(FracAerobic);  {returns FracAerobic which is not used}
  Mic_in_Aer   := Microbial_BioTrans_To_This_SV(True);
  Mic_in_Anaer := Microbial_BioTrans_To_This_SV(False);

  Decomp := 0;
  DetrSorpt := 0;
  DetrDesorpt := 0;

  If ThisPore.VolumeInM3 > tiny then
    Begin
      Decomp := 0;
      If (NState<>SedmRefrDetr)
        then Decomp := ThisDetr.Decomposition(Location.Remin.DecayMax_Lab, KAnaerobic, FracAerobic) *
            {ug/m2}                 {g/m2}
                       GetPPB(NState,SVType,Layer)  * 1e-3;
                             {ug/kg}                  {kg/g}

      DetrSorpt := Sorption    * ThisPore.VolumeInL / AllStates.SedLayerArea;
       {ug/m2 d}   {ug/L d pw}               {L}                     {m2}

      DetrDesorpt := Desorption;
    End;

  DB := - Mic + Mic_in_Aer + Mic_in_Anaer - Decomp + DetrSorpt - DetrDesorpt;
        {all units ug/m2 d}
  WriteRates;
End;

{--------------------------------------------------------------------------------------------------------------}
{************************************}
{*      TPOREWATER OBJECT           *}
{************************************}

Function TPoreWater.VolumeInM3;
Begin
  With AllStates do
  VolumeInM3 := PWVol_Last_Step[Layer] * AllStates.SedLayerArea;
    {m3}            {m3/m2}                             {m2}
End;

Function TPoreWater.VolumeInL;
Begin
  VolumeInL := VolumeInM3 * 1e3;
    {L}           {m3}     {L/m3}
End;

Procedure TPoreWater.Derivative(var DB: double);
Var LossUp,GainUp: Double;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('LossUp',LossUp);
          SaveRate('GainUp',GainUp);
        End;
    End;
    {--------------------------------------------------}

Begin
  GainUp := From_Above;  {This gain is due to deposition and segment density remaining constant}
  LossUp := To_Above;    {This loss is due to erosion and segment density remaining constant}
  {m3/m2 d}

  DB := GainUp - LossUp ;  {All Units m3/m2 d}
  WriteRates;
End;

{----------------------------------------------------------------------}

Procedure TPoreWater.CalculateLoad(TimeIndex : double);
Begin
  Loading    := 0; {No loading for TPoreWater}
End;

Function TPoreWater.To_Above: Double;

Var BedDens, SedDens  : Double;
    SedErd        : Double;
    SedLoop       : AllVariables;
    PSuspD        : TSuspendedDetr;
    SedVar        : TStateVariable;
    RemWat        : Double;

Begin
  If (Layer > SedLayer1)
    then To_Above := 0 {Currently there are no pore water interactions below the active layer.}
    else
      Begin
        RemWat  := 0;
        BedDens := AllStates.L1AimDens;

        For SedLoop := Cohesives to SedmLabDetr do
         If SedLoop<>Salinity then
          Begin
            If SedLoop in [Cohesives..NonCohesives2]
              then SedVar := GetStatePointer(SedLoop,StV,SedLayer1)
              else SedVar := GetStatePointer(SedLoop,StV,WaterCol);
            If SedVar<>nil then
              Begin
                SedDens := AllStates.Densities[SedLoop] * 1.0E+06;
                 {g/m3}                {g/cm3}             {cm3/m3}

                If SedLoop in [Cohesives..NonCohesives2]
                  then SedErd  := TBottomSediment(SedVar).ScourLoad
                       {g/d}                                {g/d}
                  else
                    Begin
                      Case SedLoop of
                          SedmRefRDetr : PSuspD := GetStatePointer(SuspRefrDetr,StV,WaterCol);
                                   else  PSuspD := GetStatePointer(SuspLabDetr,StV,WaterCol);
                          End; {Case}
                      With AllStates do
                        SedErd := PSuspD.Resuspension * SedlayerArea * DynamicZMean;
                        {g/d}                {mg/L d}         {m2}           {m}
                    End;

                If BedDens <= 1e6 then Raise EAQUATOXERROR.Create('Bed Density Must be greater than the density of water.');
                {Calculate water added to maintain density}
                RemWat  := RemWat + ((SedErd/SedDens)-(SedErd/BedDens))/((1/BedDens)-1e-6);
               {cm^3/d}
              End;
          End;

        To_Above := RemWat*1.0E-06 / AllStates.SedLayerArea;
        With AllStates do
         If Result>PWVol_Last_Step[Layer] then To_Above := PWVol_Last_Step[Layer] {state};  {can't remove more water than there is}
      End;
End;

Function TPoreWater.From_Above: Double;

Var BedDens, SedDens : Double;
    SedDep        : Double;
    SedLoop       : AllVariables;
    PSuspD        : TSuspendedDetr;
    SedVar        : TStateVariable;
    AddWat        : Double;

Begin
  If (Layer > SedLayer1)
    then From_Above := 0 {Currently there are no pore water interactions below the active layer.}
    else
      Begin
        AddWat  := 0;
        BedDens := AllStates.L1AimDens;

        For SedLoop := Cohesives to SedmLabDetr do
         If SedLoop <> Salinity then
          Begin
            If SedLoop<SedmRefrDetr
              then SedVar := GetStatePointer(SedLoop,StV,SedLayer1)
              else SedVar := GetStatePointer(SedLoop,StV,WaterCol);
            If SedVar<>nil then
              Begin
                SedDens := AllStates.Densities[SedLoop] * 1.0E+06;
                 {g/m3}                {g/cm3}             {cm3/m3}

                If SedLoop in [Cohesives..NonCohesives2]
                  then SedDep  := TBottomSediment(SedVar).DepLoad
                       {g/d}                                {g/d}
                  else
                    Begin
                      Case SedLoop of
                          SedmRefRDetr : PSuspD := GetStatePointer(SuspRefrDetr,StV,WaterCol);
                                   else  PSuspD := GetStatePointer(SuspLabDetr,StV,WaterCol);
                          End; {Case}
                      With AllStates do
                        SedDep := PSuspD.Sedimentation * SedLayerArea * DynamicZMean;
                        {g/d}                {mg/L d}         {m2}           {m}
                    End;

                If BedDens=0 then Raise EAQUATOXError.Create('ERROR: Bed Density is set to zero');    
                {Calculate water added to maintain density}
                AddWat  := AddWat + ((SedDep/SedDens)-(SedDep/BedDens))/((1/BedDens)-1e-6);
               {cm^3/d}
              End;
          End;

        From_Above := AddWat*1.0E-06 / AllStates.SedLayerArea;
        If Result<tiny then From_Above := 0;
      End;

End;

{--------------------------------------------------------------------------------------------------------------}
{************************************}
{*      TPOREWATERTOX OBJECT        *}
{************************************}

Function TPoreWaterTox.UpperDiffusion (UpperUnits: Boolean): double;
{ Diffusion calculation }
Var DiffCalc, NormVol                        : Double;
    UpperSegConc, ThisConc                   : Double;
    Area, Length, DispCoeff                  : Double;
    UpperPorosity, ThisPorosity, AvgPorosity : Double;
    LayerNum                                 : Integer;
    ThisPW                                   : TPoreWater;

Begin
  UpperDiffusion := 0;
  ThisConc     := State;
  If Layer=SedLayer1 then UpperSegConc := GetState(AssocToxSV(SVType),StV,WaterCol)
                     else UpperSegConc := GetState(NState,SVType,Pred(Layer));

  LayerNum:=ORD(Layer);
  With AllStates.SedData[LayerNum] do
    Begin
      Area         := AllStates.SedLayerArea;
      ThisPorosity := FracWater;
      DispCoeff    := TLoadings(UpperDispCoeff).GetLoad(AllStates.TPresent,True);
      If DispCoeff<Tiny then Exit;

      If (LayerNum=1)
        then
          Begin
            Length := DynBedDepth;        { the depth of the surficial benthic segment }
            UpperPorosity := 1;
            AvgPorosity := ThisPorosity;
          End
        else
          Begin
            Length := (DynBedDepth+AllStates.SedData[LayerNum-1].DynBedDepth)/2; { the distance between two benthic segment midpoints }
            UpperPorosity := AllStates.SedData[LayerNum-1].FracWater;
            AvgPorosity := (UpperPorosity+ThisPorosity) / 2;
          End;

      If (ThisPorosity<tiny) or (UpperPorosity<tiny) then exit;    
      ThisPW    := GetStatePointer(PoreWater,StV,Layer);
      If ThisPW.VolumeInM3 < tiny then exit;

      DiffCalc := 0;
      If (UpperPorosity>0) and (Length>0)
        then DiffCalc := ((DispCoeff * Area * SQR(AvgPorosity))/Length) * ((UpperSegConc/UpperPorosity) - (ThisConc/ThisPorosity));
              {mg/d}        {m2/d}     {m2}         {frac}       {m}          {mg/m3}      {frac}           {mg/m3}   {frac}

      If UpperUnits and (Layer=SedLayer1)  {If UpperUnits than normalize for volume of water in upper segment}
        then NormVol := AllStates.SegVol
        else If UpperUnits
          then NormVol := TPoreWater(GetStatePointer(PoreWater,StV,Pred(Layer))).VolumeInM3
          else NormVol := ThisPW.VolumeInM3;  {Otherwise normalize for volume of water in this segment}

      IF NormVol<tiny
        then UpperDiffusion := 0
        else UpperDiffusion := DiffCalc / NormVol;
                 {mg/m3 d}       {mg/d}     {m3}
                 {ug/l  d}
    End;
End;

Procedure TPoreWaterTox.Derivative(var DB: double);
Var LossUp,GainUp: Double;
    LowerTox : TPoreWaterTox;
    DiffUp, DiffDown: Double;
    Mic_in_Aer, Mic_in_Anaer, Mic : Double;
    Decomp,DetrSorpt,DetrDesorpt,GillUp,Depur: Double;
    WaterColToxLevel, FracAerobic: Double;
    PWVolLiters, WVolLiters: Double;
    FracInSed, InorgSorpt, InorgDesorpt: Double;
    ThisPore: TPoreWater;
    SedDecomp, PPBSed, DissDecomp, PPBDiss: Double;
    DecompState,DetrLoop,NSLoop,InorgLoop: AllVariables;
    PT: TToxics;
    PA: TAnimal;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('LossUp',LossUp);
          SaveRate('GainUp',GainUp);
          SaveRate('DiffUp',DiffUp);
          SaveRate('DiffDown',DiffDown);
          SaveRate('GillUptake',GillUp);
          SaveRate('Decomp',Decomp);
          SaveRate('Depur',Depur);
          SaveRate('DetrSorpt',DetrSorpt);
          SaveRate('DetrDesorpt',DetrDesorpt);
          SaveRate('InorgSorpt',InorgSorpt);
          SaveRate('InorgDesorpt',InorgDesorpt);
          SaveRate('MicroMet',Mic);
          SaveRate('AerMM In',Mic_in_Aer);
          SaveRate('AnaerMM In',Mic_in_Anaer);
        End;
    End;
    {--------------------------------------------------}

Begin
  GainUp:=0;LossUp:=0;GillUp:=0;Mic:=0;Mic_in_Aer:=0;Mic_in_Anaer:=0;DiffDown:=0;
  Decomp:=0;DetrSorpt:=0;DetrDesorpt:=0;InorgSorpt:=0;InorgDesorpt:=0;Depur:=0;DiffUp:=0;

  WaterColToxLevel := GetState(AssocToxSV(SVType),StV,WaterCol);
      {ug/L}           {ug/L}
  ThisPore := GetStatePointer(NState,StV,Layer); {Pore water in which this toxicant resides}
  PWVolLiters := ThisPore.VolumeInL;
  WVolLiters := AllStates.SegVol * 1e3;
                             {m3}            {L/m3}
  If ThisPore.VolumeInM3 < Tiny
    then db := 0  {no pore water}
    else
      Begin
        GainUp := (WaterColToxLevel * ThisPore.From_Above * AllStates.SedLayerArea * 1e3 )/ PWVolLiters;
        {ug/L pw d}     {ug/L}                 {m3/m2 d}                {m2}      {L/m3}      {L pw}

        With AllStates do
          LossUp :=  State * ThisPore.To_Above / PWVol_Last_Step[Layer];
         {ug/L d}    {ug/L}          {m3/m2 d}       {m3/m2}

        Mic          := MicrobialMetabolism(FracAerobic);  {returns FracAerobic which is not used}
        Mic_in_Aer   := Microbial_BioTrans_To_This_SV(True);
        Mic_in_Anaer := Microbial_BioTrans_To_This_SV(False);

        DecompState := SedmLabDetr;

        If Layer=SedLayer1
          then
            Begin
              SedDecomp  := TStateVariable(GetStatePointer(DecompState,StV,WaterCol)).Decomposition(Location.Remin.DecayMax_Lab, KAnaerobic, FracAerobic);
              PPBSed     := GetPPB(DecompState,SVType,WaterCol);
              Decomp := SedDecomp * PPBSed * 1e-6   * WVolLiters   / PWVolLiters;
           {ug/L(pw) d}   {mg/L d}    {ug/kg} {kg/mg}     {L wc}          {L pw}
            End
          else
            Begin
              SedDecomp  := TStateVariable(GetStatePointer(DecompState,StV,Layer)).Decomposition(Location.Remin.DecayMax_Lab, KAnaerobic, FracAerobic);
              PPBSed     := GetPPB(DecompState,SVType,Layer);
              Decomp     := SedDecomp * PPBSed * 1e-3  * AllStates.SedLayerArea / PWVolLiters;
             {ug/L d}        {g/m2 d}   {ug/kg} {kg/g}               {m2}            {L}
            End;


        DecompState := LaDOMPore;

        DissDecomp  := TStateVariable(GetStatePointer(DecompState,StV,Layer)).Decomposition(Location.Remin.DecayMax_Lab, KAnaerobic, FracAerobic);
        PPBDiss     := GetPPB(DecompState,SVType,Layer);

        Decomp := Decomp + DissDecomp * PPBDiss * 1e-6 ;
      {ug/L pw d} {ug/L d} {mg/L pw d}  {ug/kg}  {kg/mg}

        If not AllStates.SetupRec^.BCFUptake then
          BEGIN
            GillUp := 0;
            If Layer < SedLayer2 then
             For NSLoop := FirstAnimal to LastAnimal do
               Begin
                 PA := GetStatePointer(NSLoop,StV,WaterCol);
                 If PA <> nil
                   then GillUp:=GillUp+PA.GillUptake(SVType,SedLayer1);
               End;

            GillUp := GillUp * WVolLiters / PWVolLiters;
            {ug/L pw d) {ug/L wc d)  {L wc}       {L pw}           {pw=porewater wc=watercolumn}

            Depur := 0;
            If (Layer=SedLayer1) then
              For NSLoop := FirstAnimal to LastAnimal do
                Begin
                  PT:=(GetStatePointer(NSLoop,SVType,WaterCol));
                  If PT <> nil then
                    Begin
                      FracInSed := 1 - (TAnimal(GetStatePointer(NSLoop,STV,WaterCol)).PAnimalData^.FracInWaterCol);
                      Depur:=   Depur   + PT.Depuration * FracInSed * WVolLiters / PWVolLiters;;
                  {ug/L pw d} {ug/L dpw}       {ug/L wc}   {unitless}     {L wc}        {L pw}
                    End;
                End;
          END;

        {SORPTION AND DESORPTION CODE}
        DetrSorpt := 0;
        DetrDesorpt := 0;
        {SEDDETR FIRST}
          For DetrLoop := SedmRefrDetr to SedmLabDetr do
            If GetStatePointer(DetrLoop,SVType,WaterCol) <> nil then
              If Layer=SedLayer1
                then Begin
                        PT := GetStatePointer(DetrLoop,SVType,WaterCol);
                        DetrSorpt   := DetrSorpt   + PT.Sorption;
                         {ug/L pw}      {ug/L pw}        {ug/L pw}
                        DetrDesorpt := DetrDesorpt + PT.Desorption * WVolLiters / PWVolLiters;
                         {ug/L pw}      {ug/L pw}        {ug/L wc}       {L wc}         {L pw}
                     End
                else Begin
                        PT := GetStatePointer(DetrLoop,SVType,Layer);
                        DetrSorpt   := DetrSorpt   + PT.Sorption;
                         {ug/L pw}      {ug/L pw}        {ug/L pw}
                        DetrDesorpt := DetrDesorpt + PT.Desorption * AllStates.SedLayerArea / PWVolLiters;
                         {ug/L pw}      {ug/L pw}        {ug/m2}                   {m2}           {L pw}
                     End;

        {THEN DOM in PORE WATER}
          For DetrLoop := ReDOMPore to LaDOMPore do
            Begin
              PT := GetStatePointer(DetrLoop,SVType,Layer);
              If PT<>nil then
                Begin
                  DetrSorpt   := DetrSorpt   + PT.Sorption ;
                  DetrDesorpt := DetrDesorpt + PT.Desorption;
                   {ug/L pw}     {ug/L pw}         {ug/L pw}
                End;
            End;

        {Then Inorganics}
        InorgSorpt := 0;
        InorgDesorpt := 0;
          For InorgLoop := Cohesives to NonCohesives2 do
            If GetStatePointer(InorgLoop,SVType,WaterCol) <> nil then
                Begin
                    PT := GetStatePointer(InorgLoop,SVType,Layer);
                    InorgSorpt   := InorgSorpt   + PT.Sorption;
                     {ug/L pw}      {ug/L pw}        {ug/L pw}
                    InorgDesorpt := InorgDesorpt + PT.Desorption * AllStates.SedLayerArea / PWVolLiters;
                     {ug/L pw}      {ug/L pw}        {ug/m2}                   {m2}           {L pw}
                 End;

        DiffUp   := UpperDiffusion(False);

        DiffDown := 0;
        If Layer<LowestLayer then
          Begin
            LowerTox := GetStatePointer(NState,SVType,Succ(Layer));
            If LowerTox<>nil then DiffDown:=-LowerTox.UpperDiffusion(True);
          End;
      End; {pwvol>tiny}

  DB := GainUp - LossUp - GillUp - Mic + Mic_in_Aer + Mic_in_Anaer + Decomp - DetrSorpt + DetrDesorpt
        - InorgSorpt + InorgDesorpt + Depur + DiffUp + DiffDown; { All units micrograms per Liter of pore water per day }
  WriteRates;
End;

{----------------------------------------------------------------------}

Procedure TPoreWaterTox.CalculateLoad(TimeIndex : double);
Begin
  Loading  := 0; {No loading for TPoreWater Toxins}
End;

{--------------------------------------------------------------------------------------------------------------}
{************************************}
{*      TDOMPOREWATER OBJECT        *}
{************************************}

Function TDOMPoreWater.UpperDiffusion(UpperUnits: Boolean): double;
Var DiffCalc, NormVol                        : Double;
    UpperSegConc, ThisConc                   : Double;
    Area, Length, DispCoeff                  : Double;
    UpperPorosity, ThisPorosity, AvgPorosity : Double;
    LayerNum                                 : Integer;
    ThisPW                                   : TPoreWater;

Begin
  UpperDiffusion := 0;
  ThisConc     := State;
  ThisPW := GetStatePointer(PoreWater,StV,Layer);
  If ThisPW.VolumeInM3 < tiny then exit;
  If Layer=SedLayer1
    Then
       Begin
         If NState=LaDOMPore
           then UpperSegConc := GetState(DissLabDetr,StV,WaterCol)
           else {NState=ReDOMPore}
                UpperSegConc := GetState(DissRefrDetr,StV,WaterCol);
       End
     Else UpperSegConc := GetState(NState,StV,Pred(Layer));

  LayerNum:=ORD(Layer);
  With AllStates.SedData[LayerNum] do
    Begin
      Area         := AllStates.SedLayerArea;
      ThisPorosity := FracWater;
      DispCoeff    := TLoadings(UpperDispCoeff).GetLoad(AllStates.TPresent,True);
      If DispCoeff<Tiny then Exit;

      If (LayerNum=1)
        then
          Begin
            Length := DynBedDepth;        { the depth of the surficial benthic segment }
            UpperPorosity := 1;
            AvgPorosity := ThisPorosity;
          End
        else
          Begin
            Length := (DynBedDepth+AllStates.SedData[LayerNum-1].DynBedDepth)/2; { the distance between two benthic segment midpoints }
            UpperPorosity := AllStates.SedData[LayerNum-1].FracWater;
            AvgPorosity := (UpperPorosity+ThisPorosity) / 2;
          End;

      ThisPW    := GetStatePointer(PoreWater,StV,Layer);
      If ThisPW.VolumeInM3 < tiny then exit;

      DiffCalc := 0;
      If (UpperPorosity>0) and (Length>0)
        then DiffCalc := ((DispCoeff * Area * SQR(AvgPorosity))/Length) * ((UpperSegConc/UpperPorosity) - (ThisConc/ThisPorosity));
               {g/d}        {m2/d}     {m2}         {frac}       {m}           {g/m3}      {frac}            {g/m3}   {frac}

      If UpperUnits and (Layer=SedLayer1)  {If UpperUnits than normalize for volume of water in upper segment}
        then NormVol := AllStates.SegVol
        else If UpperUnits
          then NormVol := TPoreWater(GetStatePointer(PoreWater,StV,Pred(Layer))).VolumeInM3
          else NormVol := ThisPW.VolumeInM3;  {Otherwise normalize for volume of water in this segment}

      IF NormVol < Tiny
        then UpperDiffusion := 0
        else UpperDiffusion := DiffCalc / NormVol;
                 {g/m3 d}        {g/d}     {m3}
                 {mg/l d}
    End;
End;

{--------------------------------------------------------------------------------------------------------------}

Procedure TDOMPoreWater.Derivative;
Var LossUp,GainUp,Decomp: Double;
    DiffUp, DiffDown: Double;
    UpperDOMLevel: Double;
    ThisPore: TPoreWater;
    LowerDOMPore: TDOMPoreWater;
    FracAerobic: Double;
    watercpt   : AllVariables;
    PWVolLiters: Double;
    {--------------------------------------------------}

    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('LossUp',LossUp);
          SaveRate('GainUp',GainUp);
          SaveRate('DiffUp',DiffUp);
          SaveRate('DiffDown',DiffDown);

          IF nstate<>ReDomPore then SaveRate('Decomp',Decomp);
        End;
    End;
    {--------------------------------------------------}

Begin
  GainUp:=0;LossUp:=0;Decomp:=0;DiffUp:=0;DiffDown:=0;

  If NState=LaDOMPore
    then WaterCpt := DissLabDetr
    else {NState=ReDOMPore }
         WaterCpt := DissRefrDetr;

  If Layer=SedLayer1
    then UpperDOMLevel := GetState(WaterCpt,StV,WaterCol)
            {mg/L wc}
    else UpperDOMLevel := GetState(NState,SVType,Pred(Layer));
            {mg/L pw}

  ThisPore := GetStatePointer(PoreWater,StV,Layer); {Pore water in which this toxicant resides}
  PWVolLiters := ThisPore.VolumeInL;

  If ThisPore.VolumeInM3 < Tiny
    then db := 0
    else
      Begin
        GainUp :=  (UpperDOMLevel * ThisPore.From_Above * AllStates.SedLayerArea * 1e3) / PWVolLiters;
       {mg/L pw d}     {mg/L upper}         {m3 upper/m2 d}             {m2}       {L/m3}    {L}

        With AllStates do
          LossUp :=  State * ThisPore.To_Above / PWVol_Last_Step[Layer];
         {mg/L d}   {mg/L}          {m3/m2 d}         {m3/m2}

        Decomp := 0;
        If Nstate<>ReDOMPore
          then Decomp := Decomposition(Location.Remin.DecayMax_Lab, KAnaerobic, FracAerobic);

        DiffUp   := UpperDiffusion(False);

        DiffDown := 0;
        If Layer<LowestLayer then
          Begin
            LowerDOMPore := GetStatePointer(NState,SVType,Succ(Layer));
            If LowerDOMPore<>nil then DiffDown:=-LowerDOMPore.UpperDiffusion(True);
          End;
      End; {pwvolliters>tiny}

  DB := GainUp - LossUp - Decomp + DiffUp + DiffDown;   {all units mg/L (pore water) per day}
  WriteRates;
End;

{----------------------------------------------------------------------}

Procedure TDOMPoreWater.CalculateLoad(TimeIndex : double);
Begin
  Loading  := 0; {No loading for TDOMPoreWater}
End;


{--------------------------------------------------------------------------------------------------------------}
{************************************}
{*     TDOMPOREWATERTOX OBJECT      *}
{************************************}

Function TDOMPoreWaterTox.UpperToxDiff(UpperUnits: Boolean): Double;
{Tox movement due to DOM diffusion}

Var CarrierDOM: TDOMPoreWater;
    CarrierDiff: Double;
    UpperSegPPB: Double;
Begin
  CarrierDOM := GetStatePointer(NState,StV,Layer);
  CarrierDiff := CarrierDOM.UpperDiffusion(UpperUnits);
  If Layer=SedLayer1
     Then
       Begin
         If NState=LaDOMPore
           then UpperSegPPB := GetPPB(DissLabDetr,SVType,WaterCol)
           else {NState=ReDOMPore}
                UpperSegPPB := GetPPB(DissRefrDetr,SVType,WaterCol)
       End
     Else UpperSegPPB := GetPPB(NState,SVType,Pred(Layer));

  If CarrierDiff>0 then UpperToxDiff := CarrierDiff * UpperSegPPB * 1e-6
                   else UpperToxDiff := CarrierDiff * GetPPB(NState,SVType,Layer) * 1e-6;
End;
                                     

Procedure TDOMPoreWaterTox.Derivative;
Var LossUp,GainUp,Decomp: Double;
    DiffUp, DiffDown: Double;
    UpperDOMToxLevel: Double;
    ThisPore: TPoreWater;
    LowerDOMTox : TDOMPoreWaterTox;
    ThisDOM: TDOMPorewater;
    Mic,Mic_in_Aer,Mic_in_Anaer: Double;
    DOMSorpt, DOMDesorpt : Double;
    WaterCompartment: AllVariables;
    PWVolLiters : Double;
    FracAerobic: Double;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('LossUp',LossUp);
          SaveRate('GainUp',GainUp);
          SaveRate('DiffUp',DiffUp);
          SaveRate('DiffDown',DiffDown);
          SaveRate('Decomp',Decomp);
          SaveRate('DOMSorpt',DOMSorpt);
          SaveRate('DOMDesorpt',DOMDesorpt);
          SaveRate('MicroMet',Mic);
          SaveRate('AerMM In',Mic_in_Aer);
          SaveRate('AnaerMM In',Mic_in_Anaer);
        End;
    End;
    {--------------------------------------------------}

Begin
  GainUp :=0; LossUp :=0; Decomp :=0; DiffUp :=0; DiffDown :=0;
  Mic :=0; Mic_in_Aer :=0; Mic_in_Anaer :=0; DOMSorpt :=0; DOMDesorpt :=0;

  If NState=LaDOMPore
    then WaterCompartment := DissLabDetr
    else {NState=ReDOMPore}
         WaterCompartment := DissRefrDetr;

  If Layer=SedLayer1
    then UpperDOMToxLevel := GetState(watercompartment,SVType,WaterCol)
           {ug/L}             {ug/L}
    else UpperDOMToxLevel := GetState(NState,SVType,Pred(Layer));
           {ug/L}             {ug/L}

  ThisPore := GetStatePointer(PoreWater,StV,Layer); {Pore water in which this toxicant resides}
  ThisDOM  := GetStatePointer(NState,StV,Layer); {DOM carrier}
  PWVolLiters := ThisPore.VolumeInL;

  If ThisPore.VolumeInM3 < Tiny
    then
      Begin
        db := 0  {no pore water}
      End
    Else
      Begin
        GainUp :=  UpperDOMToxLevel * ThisPore.From_Above * AllStates.SedLayerArea * 1e3 / PWVolLiters;
        {ug/L d}     {ug/L upper}               {m3/m2 d}                     {m2}   {L/m3}     {L}

        With AllStates do
           LossUp :=  State * ThisPore.To_Above / PWVol_Last_Step[Layer];
          {ug/L d}   {ug/L}          {m3/m2 d}         {m3/m2}

        Mic          := MicrobialMetabolism(FracAerobic);  {returns FracAerobic which is not used}
       {ug/L d}           {ug/L d}
        Mic_in_Aer   := Microbial_BioTrans_To_This_SV(True);
       {ug/L d}           {ug/L d}
        Mic_in_Anaer := Microbial_BioTrans_To_This_SV(False);
       {ug/L d}           {ug/L d}

        Decomp := 0;
        If Nstate<>ReDomPore
          then Decomp := ThisDOM.Decomposition(Location.Remin.DecayMax_Lab, KAnaerobic, FracAerobic) *
             {ug/L pw d}             {mg/L d pw}
                         GetPPB(NState,SVType,Layer) * 1e-6;
                               {ug/kg}                {kg/mg}

        DOMSorpt := Sorption;
        {ug/L d}     {ug/L d}
        DOMDesorpt := Desorption;
        {ug/L d}        {ug/L d}

        DiffUp   := UpperToxDiff(False);

        DiffDown := 0;
        If Layer<LowestLayer then
          Begin
            LowerDOMTox := GetStatePointer(NState,SVType,Succ(Layer));
            If LowerDOMTox<>nil then DiffDown:=-LowerDOMTox.UpperToxDiff(True);
          End;
      End; {PWVolLiters>Tiny}

  DB := GainUp - LossUp - Decomp + DiffUp + DiffDown
        - Mic + Mic_in_Aer + Mic_in_Anaer + DOMSorpt - DOMDesorpt;  {all units ug/L pw d}
  WriteRates;
End;

{----------------------------------------------------------------------}

Procedure TDOMPoreWaterTox.CalculateLoad(TimeIndex : double);
Begin
  Loading  := 0; {No loading for TDOMPoreWater Toxins}
End;


{-------------------------------------------------------------------------------------------------------------}
{-------------------------------------------------------------------------------------------------------------}
{-------------------------------------------------------------------------------------------------------------}


{---------------------------}
{-   SAND SILT CLAY MODEL  -}
{---------------------------}


Constructor TSandSiltClay.Init(Ns : StateVariables; SVT: T_SVType; Lyr: T_SVLayer; aName : ShortString; P : TStates;
                           IC : double; IsTempl: Boolean);
begin
  Inherited Init(Ns,SVT,Lyr,aName,P,IC,IsTempl);
  StateUnit:='mg/L';
  LoadingUnit:='mg/L';
  Case nstate of
     Sand: FracInBed:=0.4;
     Silt: FracInBed:=0.4;
     Clay: FracInBed:=0.2;
    End; {Case}
  Frac_Silt_Scour:=0;
  Frac_Silt_Dep:=0;
  TSS_Solids := True;
end;

{---------------------------------------------------------------------}

{fall velocities are now a model input}

(* Function TSandSiltClay.Viscous: double;
{ Interpolates between values in mett, metv {Result in m2/s }
  Var
    del : double;
    i,kend,nn : integer;
    Current_Temp: Double;

  Begin With AllStates.Sed_Data do
  Begin  { proc viscous }

   Current_Temp:= GetState(Temperature,StV);
   viscous:=0;
   kend:=21;
   nn:=kend-1;

   if(abs(Current_Temp-mett[kend])<0.001) then
     viscous := metv[kend]*0.000001
   else
     for i:=1 to nn do
      if ((abs(Current_Temp-mett[i])<0.001) or ((Current_Temp>=mett[i]) and (Current_Temp<mett[i+1]))) then
       begin
         del:=(metv[i+1]-metv[i])*0.000001*((Current_Temp-mett[i])/(mett[i+1]-mett[i]));
         viscous:=metv[i]*0.000001+del;
         Break;
       end;
 end; {with}
 end; { proc viscous } *)

{---------------------------------------------------------------------}

Function TSandSiltClay.Scour_And_Dep;   {mg/L}

{     The Scour Function calculates scour and deposition of           }
{     sediment particles.  Scour and deposition                       }
{     are estimated according to the Krone and Partheniades formulas  }
{     as applied in HSPF.  Function result is "Scour" in mg/L         }
{     deposition set in "deposition" variable                         }

Const
(*  ts_clay   : double = 0.6;  {1.4;  { clay critical shear stress for scour [kg/m2] }
    ts_silt   : double = 0.7;  {1.4;  { silt critical shear stress for scour [kg/m2] }
    tdep_clay : double = 0.07; { clay critical shear stress for deposition [kg/m2] }
    tdep_silt : double = 0.1;  { silt critical shear stress for deposition [kg/m2] }  Model Inputs as of 3-1-03 *)

(*  d_silt   : double = 0.020; { effective particle size in mm }
    d_clay   : double = 0.002;  *)

  Ero_Clay : double = 0.244;{ 1.5;}   { erodability coefficients  kg/m2 day}
  Ero_Silt : double = 0.244;{ 1.7;}

Var
 chk_nstate                      : Double;
 scour_nstate                    : Double;
 ts_nstate, tdep_nstate,
 m_nstate, vt_nstate, Ero_Nstate : Double;

 Begin With AllStates.Sed_Data do
  Begin
   AllStates.CalcHRadius(False);

{   IF (Avg_Depth > yflood) and (not FloodPlainWarning) then
     begin
       MessageDlg('Warning!  channel overflows into the floodplain',mterror,[mbOK],0);
       FloodPlainWarning := True;
     end;  }

   If nState=Sand then begin
                         Scour_And_Dep := Scour_Sand; {mg/L}
                         exit;
                       end;

   {initialize variables to correct state variable}
   with Location.locale do
   If nState=Silt then begin
                         ts_nstate   := ts_Silt;   { kg/m2 }
                         tdep_nstate := tdep_Silt; { kg/m2 }
                         m_nState    := mSilt;      { kg }
                         Ero_nstate  := Ero_Silt;    { kg/m2 d }
                         vt_nstate   := FallVel_Silt; { m/s }
                       end
  {nstate = clay} else begin
                         ts_nstate   := ts_Clay;   { kg/m2 }
                         tdep_nstate := tdep_Clay; { kg/m2 }
                         m_nState    := mClay;      { kg }
                         Ero_nstate  := Ero_Clay;    { m/s }
                         vt_nstate   := FallVel_Clay; { m/s }
                       end;

{  SHEAR STRESS  }
   tau := 1000.0 * HRadius * slope;   {1000 is unit weight, or density, of water (62.4 lb/ft3 or 1000 kg/m3)}
 {kg/m2} {kg/m3}    {m}     {m/m}

{  CALCULATE SCOUR  }
   If(tau>ts_nstate) then scour_nstate := (Ero_NState/Avg_Depth)*(( tau / ts_nstate)-1.0)
                          {kg/m3 d}         {kg/m2 d}    {m}      {kg/m2}  {kg/m2}
                     else scour_nstate := 0.0;

   chk_nstate := scour_nstate * Avg_Depth * Clength * width;
   If (m_nstate<=chk_nstate) then  scour_nstate:=m_nstate/( Avg_Depth * Clength * width);
                                     {kg/m3 d}     {kg}         {m}        {m}      {m}
{  ----------------------------------------                                     }
{  PARTICULATE SEDIMENT LOST TO DEPOSITION                                      }
{  ----------------------------------------                                     }

(*  Compute fall velocities for each sediment type                              }
{   need to input water temperature to obtain the kinematic viscosity           }
   Visc:=Viscous;
  {m2/s}
   vt_nstate :=9.807/(18.0*visc)*1.65*Sqr(d_nstate/1000);
     {m/s}    {m/s2}      {m2/s}            {mm}  {mm/m} *)

  if(tau<tdep_nstate) then deposition :=(State/1000)*(1-exp((-vt_nstate*SecsPerDay/Avg_Depth)*(1.0-tau/tdep_nstate)))
                           {kg/m3 d}       {kg/m3}             {m/s}     {s/d}            {m}
                      else deposition :=0.0;

 If nstate=Clay then begin
                       Scour_Clay := Scour_NState; {kg/m3}
                       Dep_Clay := Deposition;  {kg/m3}
                     end
                else begin
                       Scour_Silt := Scour_Nstate; {kg/m3}
                       Dep_Silt := Deposition;  {kg/m3}
                     end;

 Deposition    := Deposition   * 1000;
 Scour_And_Dep := Scour_Nstate * 1000;
 {mg/L}            {kg/m3}      {kg/m3 to mg/l}

 end; {with}
end; {Scour}

{---------------------------------------------------------------------}
Function TSandSiltClay.Scour_Sand: Double;  {mg/L}

{     The SAND TRANSPORT Method Calculates                                                    }
{     Sand Concentration from the Engelund Hansen Method (1967)     }

{     If sand is overall deposited, the result is put in Deposition and
      Scour is set to zero.  If sand is overall scoured, the result is
      put in Scour (function result), and Deposition is set to zero
      function result is Scour, deposition set in "deposition" variable  }

Const
  d_sand : double = 0.30;   { effective particle size in mm }

Var
  tstar, chksan, dsandm, msands, msandt, pcsand : double;
  NewConcSand : Double;
  Vel: Double;

Begin With AllStates.Sed_Data do
 Begin { begin proc sandt }
   vel := AllStates.Velocity(0,0,False) * 0.01;
  {m/s}                {cm/s}             {m/cm}
   dsandm := d_sand / 1000; {}
   tstar  := (1./1.65)* HRadius * slope / dsandm ;
   pcsand := 0.05 * (1./1.65)*(Vel * slope) /
                              {m/s}
              (sqrt(1.65*9.807*dsandm))*Sqrt(tstar);
   chksan := pcsand * Avg_Depth * width * Clength;
   msands := (State / 1000)   * Avg_Depth * width * Clength;
    {kg}      {sand in kg/m3}       {m}            {m}      {m}
   msandt := msands + msand;
     {kg}     {kg}     {kg}

   sco_sand :=0; dep_sand:=0; {kg}

   If(chksan<=msands) then
     begin
       dep_sand    := msands-chksan; {kg}
       NewConcSand := pcsand ;
         {kg/m3}      {kg/m3}
     end
   else if (chksan>=msandt) then
     begin
       msand := 0.0;
       NewConcSand := msandt/( Avg_Depth *width*Clength);
     end
   else
     begin
       sco_sand    := chksan-msands;  {kg}
       NewConcSand := (msands+sco_sand)/(( Avg_Depth *width*Clength));
                       {kg}     {kg}             {m}       {m}    {m}
     end;

  If NewConcSand > (State / 1000)
       {kg/m3}        {kg/m3}
     then begin
            Scour_Sand := (NewConcSand - (State / 1000)) * 1000;
             {mg/L}          {kg/m3}          {kg/m3}    {conv. to mg/L}
            Deposition := 0;
          end
     else begin
            Deposition := ((State / 1000) - NewConcSand) * 1000;
             {mg/L}        {kg/m3}         {kg/m3}    {conv. to mg/L}
            Scour_Sand := 0;
          end;

  End; {with}
 End; { end procedure sandt }

{---------------------------------------------------------------------}
procedure TStates.Update_Sed_Bed(Timestep: Double);
{ Calculates sediment volumes and check bed thickness }

Var Vol_Clay,Vol_Sand,VolTot: Double;

Const  Rho_Sand : double = 2600;  { density of particles [kg/m3] }
       Rho_Clay : double = 2400;
       Rho_Silt : double = 2400;  { also defined in STATE.INC}


Begin

If Location.SiteType=Tribinput then exit;

With Sed_Data do
  begin  { proc check }
     mclay:=mclay + (dep_clay-scour_clay)* Avg_Depth*Clength*awidth * TimeStep;
     msilt:=msilt + (dep_silt-scour_silt)* Avg_Depth*Clength*awidth * TimeStep;
     {kg}            {kg/m3}   {kg/m3}       {m}       {m}    {m}
     msand:=msand + (dep_sand-sco_sand)* TimeStep;
     {kg}              {kg}      {kg}

   if mclay<0 then mclay :=0;
   if msilt<0 then msilt :=0;
   if msand<0 then msand :=0;

{     ----------------     }
{     SEDIMENT VOLUMES     }
{     ----------------     }

   vol_clay := mclay/Rho_Clay;
   vol_silt := msilt/Rho_Silt;
   vol_sand := msand/Rho_Sand;

   voltot   := (vol_clay+vol_silt+vol_sand)/(1-bed_porosity);
   cbedto   := (mclay+msilt+msand)/voltot;
   BedDepth := voltot/(Clength*awidth);

{   if (BedDepth>=Max_Depth) and (not BedDepthWarning) then
     begin
       MessageDlg('Warning!  Bed sediment depth exceeds maximum allowable value',mterror,[mbOK],0);
       BedDepthWarning := True;
     end; }

 end; {with}
End; { proc check }
{----------------------------------------------------------------------}
Procedure TSandSiltClay.Update_Sed_Data;

Begin

  With AllStates.Sed_Data do
    Begin

{ ------------------------- }
{ CALCULATE DEPOSITION DATA }
{ ------------------------- }

     If not (nstate=silt) then exit;

     If State=0 then Frac_Silt_dep   := 0
                else Frac_Silt_dep   := Deposition / State;
                       {frac / d}           {mg/L d}   {mg/L}

     If (msilt=0) or (vol_silt=0) then Frac_Silt_Scour:=0
       else Frac_Silt_scour := (scour_silt/1000)   / (msilt / vol_silt) ;
                 {frac / d}       {mg/L d}  {to kg/m3}     {kg}     {m3}

     If Frac_Silt_Dep>1 then Frac_Silt_Dep:=1;
     If Frac_Silt_Dep<0 then Frac_Silt_Dep:=0;
     If Frac_Silt_Scour>1 then Frac_Silt_Scour:=1;
     If Frac_Silt_Scour<0 then Frac_Silt_Scour:=0;

  End;
End;

{----------------------------------------------------------------------}

Function TSandSiltClay.Washout;
Var Disch, SegVolume  : Double;
Begin
  SegVolume := AllStates.SegVol;
  Disch := Location.Discharge[AllStates.VSeg];

  if Disch < Small then WashOut := 0.0
                   else WashOut := Disch *  State  /  SegVolume;
                       {mg/L / d}   {m3/d}  {mg/L}    {cu m.}

  WashoutStep[AllStates.DerivStep] := Result * AllStates.SegVol;
end;

{----------------------------------------------------------------------}


Procedure TSandSiltClay.CalculateLoad(TimeIndex : double);

{ atmospheric and point-source loadings should be to epilimnion. 11/19/96}

Var Loop      : Alt_LoadingsType;
    SegVolume : Double;
    Inflow    : Double;
    MultLdBy  : Double;

Begin
 With LoadsRec do
 Begin
    Loading:=0;
    If NoUserLoad then exit;

    SegVolume := AllStates.SegVol;
    With Location.Morph do
      Inflow := InflowH2O[AllStates.VSeg]* (OOSInflowFrac);

    {Inflow Loadings}
    Begin
      inherited CalculateLoad(TimeIndex);

      If NState=TSS then
         Begin
           State := Loading;
           exit;  {valuation not loading, no need to adjust for flow and volume}
         End;

      Loading:=Loading * Inflow / SegVolume;
      {mg/L d   mg/L     cu m/d    cu m   }
    End;

    {Add Point Source, D.P., and Non-Point Source Loadings}
    If AllStates.VSeg=Epilimnion then
     If (not (Alt_Loadings[PointSource]=nil)) then
       For Loop:=PointSource to NonPointSource do
         Begin
            If Loop = DirectPrecip then MultLdBy := 1000 {g / kg}
                                   else MultLdBy := 1;
            If Alt_UseConstant[Loop]
               then Loading:=Loading+ ((Alt_ConstLoad[Loop] * MultLdBy *  Alt_MultLdg[Loop])/ SegVolume)
                    {mg/L d} {mg/L d}     {g/d or kg/d}     {conv to g/d}       {unitless}    {cu m}
               else if Alt_Loadings[Loop]<>nil
                    then Loading:=Loading+ (Alt_Loadings[Loop].GetLoad(TimeIndex,True)* MultLdBy  * Alt_MultLdg[Loop])/SegVolume;
         End;

 End; {With LoadsRec}
End;

{------------------------------------------------------------------}
{Buried Detritus Associated with the SAND-SILT-CLAY MODEL}
{------------------------------------------------------------------}

Constructor TBuriedDetr1.Init(Ns : StateVariables; SVT: T_SVType; Lyr:T_SVLayer; aName : ShortString; P : TStates;
                           IC : double; IsTempl: Boolean);  {Buried Detritus Associated with the SAND SILT CLAY MODEL}
begin
  Inherited Init(Ns,SVT,Lyr,aName,P,IC,IsTempl);
  StateUnit:='g/m2';
  LoadingUnit:='N.A.';

  TotalScour :=0;       {g/m2 d}
  Frac_Sed_Scour:=0;
  Frac_Buried_Scour:=0;
  BuriedDetr_To_Sed:=0;  {g/m2 d}
  TotalDep:=0;           {g/m2 d}
  Frac_Dep_ToSed:=0;
  Frac_Dep_ToBuried:=0;
  SedDetr_To_Buried:=0;  {mg/L}
end;

Procedure TBuriedDetr1.CalculateLoad(TimeIndex : double);

Begin
  Loading  := 0; {No loading for buried Detr}
End;

{------------------------------------------------------------------}

Procedure TBuriedDetr1.CalcTotalScour;
{ Calculate the total quantity of scoured detritus in kg/m3 and the percent
  of the SedDetr that is scoured and the percent of the buriedDetr that is scoured}

Var Frac_Scour, Buried_Scour: Double;
    UnitFix, MSedDetr: Double;

Begin
  Frac_Sed_Scour:=0;
  Frac_Buried_Scour:=0;
  BuriedDetr_To_Sed:=0;
  If GetState(Sand,StV,WaterCol)=-1 then exit;

  UnitFix := (AllStates.SegVol * 1000) / Location.Locale.SurfArea  *  1e-3 ;
{L/m2 * g/mg} {                  m3         L/m3}                  {m2}         {g/mg}

  Frac_Scour := TSandSiltClay(GetStatePointer(Silt,StV,WaterCol)).Frac_Silt_Scour;
  If nstate=BuriedRefrDetr then MSedDetr := GetState(SedmRefrDetr,StV,WaterCol) * UnitFix
                           else MSedDetr := GetState(SedmLabDetr,StV,WaterCol)  * UnitFix;
                                {g/m2}              {mg/L}                       {L/m2 * g/mg}

  TotalScour := (State + MSedDetr) * Frac_Scour;
   {g/m2 d}      {g/m2}   {g/m2}       {1/d}

  If TotalScour=0 then begin
                         Frac_Sed_Scour:=0;
                         Frac_Buried_Scour:=0;
                         exit;
                       end;

  If MSedDetr=0 then Frac_Sed_Scour:=0 else
      Frac_Sed_Scour := TotalScour / MSedDetr ;
                         {g/m2 d}   {g/m2}

  If Frac_Sed_Scour <= 1.0 then Frac_Buried_Scour:=0
     {unless all sed is scoured then no buried sed will be scoured}
     else begin
            Buried_Scour:= TotalScour - MSedDetr;
             {g/m2 d}        {g/m2 d}    {g/m2}
            If state = 0 then Frac_Buried_Scour :=0 else
               Frac_Buried_Scour := Buried_Scour / state ;
                                    {g/m2 d}       {g/m2}
            If Frac_Buried_Scour > 1.0 then Frac_Buried_Scour := 1.0;
            Frac_Sed_Scour := 1.0;
          end;

  BuriedDetr_To_Sed := Frac_Sed_Scour * MSedDetr;
  {g / m2 d}                              {g/m2}

  If Frac_Sed_Scour < 0 then Frac_Sed_Scour:=0;
  If Frac_Buried_Scour < 0 then Frac_Buried_Scour:=0;

End;

{------------------------------------------------------------------}

Procedure TBuriedDetr1.CalcTotalDep;
{ Calculate the total quantity of deposition in g/m2 d}
Var Frac_Dep: Double;
    PartDetr   : Double;
    Dep        : Double;
Begin
  Frac_Dep_ToSed := 0.0;
  Frac_Dep_ToBuried := 0.0;
  SedDetr_To_Buried := 0.0;
  If GetState(Sand,StV,WaterCol)=-1 then exit;

  If nstate=BuriedRefrDetr then PartDetr := GetState(SuspRefrDetr,StV,WaterCol)
                           else PartDetr := GetState(SuspLabDetr,StV,WaterCol);
{  If nstate=BuriedRefrDetr then SedDetr  := GetState(SedmRefrDetr,StV,WaterCol)
                           else SedDetr  := GetState(SedmLabDetr,StV,WaterCol); }

  Frac_Dep := TSandSiltClay(GetStatePointer(Silt,StV,WaterCol)).Frac_Silt_Dep;

  Dep := PartDetr * Frac_Dep;
 {mg/L}   {mg/L}     {1/d}

  TotalDep := Dep    * AllStates.SegVol / Location.Locale.SurfArea { * 1e3 *  1e-3 };
 {g/m2 d}    {mg/L d}                 {m3}                              {m2}     {L/m3}  {g/mg}

 Frac_Dep_ToSed := 1.0;    {5-23-08 No deep burial of detritus directly from sedimentation}
 Frac_Dep_ToBuried := 0.0; {       this is effectively taken care of by "daily burial" }
 SedDetr_To_Buried := 0.0;

(* If Dep+SedDetr <= InitCond then begin
                         Frac_Dep_ToSed := 1.0;
                         Frac_Dep_ToBuried := 0.0;
                       end
                  else begin
                         If Dep=0 then Frac_Dep_ToSed:=0 else
                             Frac_Dep_ToSed := SedDetr / Dep;
                         Frac_Dep_ToBuried := 1-Frac_Dep_ToSed;
                       end;

  SET SedDetr_To_Buried
           {mg/L}                          *)
End;

{------------------------------------------------------------------}
{Toxicant in Buried Detritus Associated with the SAND-SILT-CLAY MODEL}
{------------------------------------------------------------------}


constructor TBuriedDetrTox1.init(Ns,Carry :StateVariables; SVT: T_SVType; L: T_SVLayer;
                       aName :ShortString; P :TStates; IC :double; IsTempl: Boolean);
Begin
   Inherited Init(Ns,Carry,SvT,L,aName,P,IC,IsTempl);  {TToxics}
End;

{---------------------------------------------------------------------}

Procedure TBuriedDetrTox1.CalculateLoad(TimeIndex : double);

Begin
  Loading  := 0; {No loading for buried Detr Toxins}
End;


    (************************************)
    (*                                  *)
    (*     DIFFERENTIAL EQUATIONS       *)
    (*                                  *)
    (************************************)


Procedure TSandSiltClay.Derivative(var DB: double);
Var Lo,Wa,WaI,Sc,De: Double;

    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          If (nstate=TSS) then Exit;
          SaveRate('Load',Lo);
          SaveRate('Scour',Sc);
          SaveRate('Washout',Wa);
          SaveRate('Deposition',De);
          SaveRate('WashIn',WaI);
        End;
    End;
    {--------------------------------------------------}

Begin
   If (nstate=TSS) then
     Begin
       db := 0;
       State := Loading;
       WriteRates;
       Exit;
     End;

   Lo := Loading;
   Sc := Scour_and_dep; {must be calculated first, to ensure Deposition is calculated}
   Wa := Washout;
   De := Deposition;
   WaI := WashIn;

   db := Lo + WaI + Sc - De - Wa ; {all units mg/L d}
   WriteRates;
   Update_Sed_Data;
End;

{----------------------------------------------------------------------}

Procedure TBuriedDetr1.Derivative(var DB: double);
Var Dep,Bur,Sco,Exp,DailyBur: Double;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);  
          SaveRate('Deposition',Dep);
          SaveRate('Burial',Bur);
          SaveRate('Scour',Sco);
          SaveRate('Exposure',Exp);
        End;
    End;
    {--------------------------------------------------}

Begin
  CalcTotalDep; CalcTotalScour;

  If nstate = BuriedLabileDetr
     then DailyBur := TDetritus(GetStatePointer(SedmLabDetr,StV,WaterCol)).DailyBurial
     else DailyBur := TDetritus(GetStatePointer(SedmRefrDetr,StV,WaterCol)).DailyBurial;
          {mg/L}

  Dep := TotalDep * Frac_Dep_ToBuried; {deposition}
{g/m2 d}  {g/m2 d}

  Bur := (SedDetr_To_Buried + DailyBur)  * AllStates.SegVol / Location.Locale.SurfArea { * 1e3 *  1e-3 };
{g/m2 d}    {mg/L}             {mg/L}                  {m3}                               {m2}       {L/m3}   {g/mg}

  Sco := State * Frac_Buried_Scour; {scour}
         {g/m2}   {1/d}
  Exp := BuriedDetr_To_Sed;  {Exposure}
         {g/m2 d}

  DB := Dep + Bur - Sco - Exp;  {all units g/m2 d}
  WriteRates;
End;

{---------------------------------------------------------------------}

Procedure TBuriedDetrTox1.Derivative(var DB: double);
Var PBD: TBuriedDetr1;
    P  : Pointer;
    DailyBur: Double;
    Dep,Bur,Sco,Exp: Double;
    SedState, PartState: AllVariables;
    {--------------------------------------------------}
    Procedure WriteRates;
    Begin
     With AllStates.SetupRec^ do
      If (SaveBRates or ShowIntegration) then
        Begin
          ClearRate;
          SaveRate('State',State);
          SaveRate('Deposition',Dep);
          SaveRate('Burial',Bur);
          SaveRate('Scour',Sco);
          SaveRate('Exposure',Exp);
        End;
    End;
    {--------------------------------------------------}
Begin
   If Nstate = BuriedLabileDetr
    then begin
           SedState:=SedmLabDetr;
           PartState:=SuspLabDetr;
           PBD:=GetStatePointer(BuriedLabileDetr,StV,WaterCol);
           P := GetStatePointer(SedmLabDetr,StV,WaterCol);
           DailyBur := TDetritus(P).DailyBurial;
         end
    else begin
           SedState:=SedmRefrDetr;
           PartState:=SuspRefrDetr;
           PBD:=GetStatePointer(BuriedRefrDetr,StV,WaterCol);
           P := GetStatePointer(SedmRefrDetr,StV,WaterCol);
           DailyBur := TDetritus(P).DailyBurial;
         end;

  With PBD do
    Begin
      CalcTotalDep; CalcTotalScour;
      Dep:= TotalDep * Frac_Dep_ToBuried;
    {g/m2 d}
      Bur:=  (SedDetr_To_Buried + DailyBur)  * AllStates.SegVol / Location.Locale.SurfArea { * 1e3 *  1e-3 };
    {g/m2 d}     {mg/L}             {mg/L}                  {m3}                               {m2}       {L/m3}   {g/mg}
      Sco:= PBD.State * Frac_Buried_Scour;
    {g/m2 d}  {g/m2}          {1/d}
      Exp:= BuriedDetr_To_Sed;
    {g/m2 d}
    End;

  Dep   :=   Dep * GetPPB ( PartState,SVType,WaterCol ) * 1e-3;
  Bur   :=   Bur * GetPPB ( SedState,SVType,WaterCol  ) * 1e-3;
  Sco   :=   Sco * GetPPB ( nstate,SVType,WaterCol )    * 1e-3;
  Exp   :=   Exp * GetPPB ( nstate,SVType,WaterCol )    * 1e-3;
{ug/m2 d} {g/m2 d}                  {ug/kg}               {kg/g}

 DB  :=  Dep + Bur - Sco - Exp;  {All units ug/m2 d}
 WriteRates;
End;

