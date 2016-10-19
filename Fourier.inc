//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Function CalculateWindLoading(TimeIndex,MeanVal: Double): Double;
{JSC Modified 4/29/2008 to incorporate 365 day series.}
var
  AddVar, Wind, DateVal: double;
  N : Integer;
const
  Pi = 3.141592654;
  Intercept = 5.043;
  Coeffs : Array[1..24] of double = (0.83408,0.87256,0.4245,-0.2871,-0.2158,-0.6634,-0.0264,-0.2766,0.0236,-0.3492,-0.442,0.89,-1.4385,0.634,0.0935,-1.06,-0.564,-0.291,-0.6484,0.6162,0.1083,0.4047,0.0268,-0.1209);
  Freq   : Array[1..24] of double = (1,1,2,2,4,4,8,8,16,16,32,32,64,64,128,128,200,200,300,300,6,6,3,3);

begin
  If MeanVal <=0 then MeanVal := 3.0 {default};
  Wind := MeanVal;
  DateVal := 2*pi*JulianDate(TimeIndex)/ 365;

  For N := 1 to 24 do
   Begin
     If N MOD 2 = 1 then AddVar := Coeffs[N]*COS(Freq[N]*DateVal)   {COS Coefficients in odd array registers}
                    else AddVar := Coeffs[N]*SIN(Freq[N]*DateVal);  {SIN COefficients in even array registers}
     Wind := Wind + AddVar;
   End;

  if Wind < 0.0 then Wind := 0.0;
  CalculateWindLoading:=Wind;
End;

