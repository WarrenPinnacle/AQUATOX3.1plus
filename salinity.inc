//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Procedure TSalinity.Derivative;
Begin
   inherited Derivative(DB); {TStateVariable}
   db:=0;
End;

Procedure TSalinity.CalculateLoad(TimeIndex : Double);
Begin
  Loading := 0;
  State := ReturnLoad(TimeIndex,LoadsRec);
  SalinityUpper := State;
  SalinityLower := ReturnAltLoad(TimeIndex,LoadsRec,PointSource);
  If Allstates<> nil then
    If AllStates.vseg=hypolimnion then State:=SalinityLower;
End;

Function TStates.SalEffect(Min,Max,Coeff1,Coeff2: Double): Double;
Var Salt: Double;
Begin
  SalEffect := 1;
  Salt := GetState(Salinity,StV,WaterCol);
  If Salt =-1 then exit;

  If (Salt>=Min) and (Salt<=Max)
    then SalEffect := 1
    else if Salt<Min then SalEffect := Coeff1 * Exp(Salt-Min)
    else   {Salt>Max}     SalEffect := Coeff2 * Exp(Max-Salt)
End;

Function TOrganism.SalMort(Min,Max,Coeff1,Coeff2: Double): Double;
Var Salt: Double;
Begin
  SalMort := 0;
  Salt := GetState(Salinity,StV,WaterCol);
  If Salt =-1 then exit;
  
  If (Salt>=Min) and (Salt<=Max)
    then SalMort := 0
    else if Salt<Min then SalMort := Coeff1 * Exp(Min-Salt)
    else   {Salt>Max}     SalMort := Coeff2 * Exp(Salt-Max)
End;
