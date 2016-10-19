//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Aqsite;
interface

uses Classes, Global, TCollect, SV_IO, Dialogs, SysUtils,
      Progress, Forms, Loadings;
type
  TAQTSite = Class(Baseclass)
      Locale        : SiteRecord;
      Discharge     : Array[VerticalSegments] of real48;  {cu m/day}
      Remin         : ReminRecord;
      SiteType      : SiteTypes;
      MeanThick     : Array[VerticalSegments] of Double;
      P_Shape,
      TotDischarge  : Double;  {was originally Q in older code}
      Morph         : MorphRecord;  {variable morphometry results, NoSave}
      ICSurfArea    : Double;  {Surface Area Initial Condition, NoSave}
      Constructor Init;
      Procedure Store(IsTemp: Boolean; var St: TStream); Override;
      Constructor Load(IsTemp: Boolean; Var st: TStream; ReadVersionNum: Double);
      procedure ChangeData(ZM: Double);
      Procedure WriteText(Var LF: TextFile); Override;
      {ChangeData MUST be called when the underlying data record is changed}
      Function Discharge_Using_QBase: Double;
      Function FracLittoral(ZEuphotic,Volume: Double): Double;
      Function AreaFrac(Z, ZMax : double) : double;
      Function Conv_CBOD5_to_OM(RefrPct:Double): Double;
   end;

implementation

Uses math;

{$I translate.inc}
{$I Site.Inc}
end.
