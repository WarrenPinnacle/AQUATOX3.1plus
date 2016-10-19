//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
{ SITE.INC }

{ DeltaMorph procedures have been moved to TVOLUME.DELTAVOLUME found in STATE.INC }

{----------------------------------------------------------------------------------------}
Function TAQTSite.AreaFrac(Z, ZMax : double) : double;
{ The AreaFrac function returns the fraction of surface area that is
  at or above depth Z given ZMax and also P which defines the morphometry of the water body }

{ For example, if your water body were a cone, when you made horizontal slices thorugh the cone,
 looking from the top, you could conceivably see both the surface area and the water/sediment boundary
 where the slice has been made.  This would look like a circle within a circle, or a donut.
 Given a depth and a maximum depth, Areafrac calculates the fraction of the total surface
 area that is the donut (epilimnion surf. area)  To get the donut hole, (1-AreaFrac) should be used in the code }

   Begin      {RAP, 9/5/95 constrained to <= 1}
     If Z > ZMax
        then AreaFrac := 1.0  { Z is greater than maximum depth }
        else AreaFrac := (1.0 - P_Shape)*Z/ZMax + P_Shape * SQR(Z/ZMax); {elliptic hyperboloid}    {RAP Fix Eqn. Signs 1-26-2001}
          {  fraction     unitless      m/m       unitless    m/m }

     if Result<0 then Result := 0;
     if Result>1 then Result := 1;
   End; { areafrac }
{----------------------------------------------------------------------------------------}

Procedure TAQTSite.WriteText(Var LF: TextFile);
Var SiteStr: String;
Begin
     case SiteType of
       Reservr1d  : SiteStr := 'Reservoir';
       Lake       : SiteStr := 'Lake';
       Pond       : SiteStr := 'Pond';
       Stream     : SiteStr := 'Stream';
       Enclosure  : SiteStr := 'Enclosure';
       estuary:     SiteStr := 'Estuary';
       tribinput:    SiteStr := 'Tributary input';
       else         SiteStr := '!! ERROR !!';
     end; {case}


     Writeln(LF,'-----------------------------------');
     Writeln(LF,'SITE TYPE: '+SiteStr);
     SiteRec_To_Text(LF,Locale);
     Writeln(LF,'-----------------------------------');
     ReminRec_To_Text(LF,Remin);

End;
{----------------------------------------------------------------------------------------}

Function TAQTSite.FracLittoral(ZEuphotic, Volume: Double): Double;
{Fraction of Tot Area Available for PhotoSynth}
Var FracLit: Double;
    LocalZMean: Double;
Begin
  If Locale.UseBathymetry then
    Begin
      FracLit := AreaFrac(ZEuphotic, Locale.ZMax);     //10-14-2010 Note that ZMax parameter pertains to both segments in event of stratification
      If SiteType=Enclosure then with Locale do
         FracLit := FracLit * (SurfArea + EnclWallArea ) / SurfArea ;
    End
  else {don't use bathymetry, it is less relevant for rivers}
    Begin
      LocalZMean := Volume / Locale.SurfArea;
           {m}
      FracLit := ZEuphotic / LocalZMean;
       {frac}      {m}          {m}
    End;

  If FracLit>1 then FracLit:=1;
  If FracLit<0 then FracLit:=0;

  FracLittoral:=FracLit;
End;


Procedure  TAQTSite.Store(IsTemp: Boolean; Var st: TStream);

Begin
     st.write(Locale,Sizeof(Locale));
     st.write(Discharge,Sizeof(Discharge));
     st.write(Remin,Sizeof(Remin));
     st.write(SiteType,Sizeof(SiteType));
     st.write(MeanThick[Epilimnion],Sizeof(Double));
     st.write(MeanThick[Hypolimnion],Sizeof(Double));
     st.write(P_Shape,Sizeof(P_Shape));
     st.write(TotDischarge,Sizeof(TotDischarge));
End;


Constructor  TAQTSite.Load(IsTemp: Boolean; Var st: TStream; ReadVersionNum: Double);
Var MaxEpiThick: Double;
    OSR: OldSiteRecord;
    ORR: OldReminRecord;
Begin
   If ReadVersionNum > 3.605 then
     St.Read(Locale,Sizeof(Locale))
     Else
       Begin  {OSR}
           If ReadVersionNum>2.999
              then Begin
                     If ReadVersionNum > 3.485
                       then St.Read(OSR,Sizeof(OSR))
                       else Begin
                              St.Read(OSR,2829);
                            End;
                   End
              else TranslateSiteRecord(St, ReadVersionNum,OSR);

          If ReadVersionNum < 3.485 then with OSR do
            Begin
              UseCovar := True;
              EnteredKReaer := 0;
              XEnteredKReaer := 'NA';
            End;

          If ReadVersionNum < 3.505 then with OSR do
            UsePhytoRetention := (EnterTotalLength and (TotalLength > 0)) or
                                 ((not EnterTotalLength) and (WaterShedArea > 0));

          If ReadVersionNum < 3.435 then with OSR do
             Begin
                ECoeffPOM := 0.12;  XECoeffPOM := 'Verduin, 1982';
                ECoeffSed := 0.17;  XECoeffSed := 'mid value from Straskraba & Gnauck, 1985';
                ECoeffDOM := 0.03;  XECoeffDOM := 'calc. from Effler et al., 1985';
             End;

          If ReadVersionNum < 3.535 then with OSR do
             Begin
                BasePercentEmbed   := 0;
                XBasePercentEmbed  := 'No Embeddedness as Default';
             End;

          If ReadVersionNum < 3.595 then with OSR do
             Begin
                Altitude           := 200;
                XBasePercentEmbed  := 'Default, Used for O2Sat';
             End;

          TranslateSiteRecord2(OSR,Locale);
       END;

     St.Read(Discharge,Sizeof(Discharge));

     If ReadVersionNum > 3.605
       then St.Read(Remin,Sizeof(Remin))
       else
         Begin {ORR}
           If ReadVersionNum>2.999
                then St.Read(ORR,Sizeof(ORR))
                else TranslateReminRecord(St, ReadVersionNum,ORR);

           If ReadVersionNum < 3.525 then
             Begin
               ORR.KD_P_Calcite := 300; {L/kg}
               ORR.XKD_P_Calcite := 'Default';
             End;

           If ReadVersionNum < 3.545 then
             Begin
               ORR.BOD5_CBODu     := 2.47; {ratio}
               ORR.XBOD5_CBODu    := 'Thomann & Mueller, 1987';
            End;

           TranslateReminRecord2(ORR,Remin);
         End;

     If ReadVersionNum < 3.625 then
      with Remin do
       Begin
         KNitri         := 0.3;
         XKNitri        := 'Default';
         KDenitri_Bot   := 0.2;
         XKDenitri_Bot  := 'Default';
         KDenitri_Wat   := 0.09;
         XKDenitri_Wat  := 'Default';
       End;

     st.read(SiteType,Sizeof(SiteType));
     st.read(MeanThick[Epilimnion],Sizeof(Double));
     st.read(MeanThick[Hypolimnion],Sizeof(Double));
     st.read(P_Shape,Sizeof(P_Shape));
     If ReadVersionNum<2.99
       then  st.read(MaxEpiThick,Sizeof(MaxEpiThick)); {not used}

     st.read(TotDischarge,Sizeof(TotDischarge));

     ICSurfArea := 0;  {Set at beginning of simulation run}
End;


constructor TAQTSite.Init;
begin
   fillchar(Locale,SizeOf(Locale),0);
   fillchar(Remin,SizeOf(Remin),0);

   MeanThick[Epilimnion] := 0;
   MeanThick[Hypolimnion] := 0;
   P_Shape  := 0;
   TotDischarge:=0;
   ICSurfArea := 0;
end;

procedure TAQTSite.ChangeData(ZM: Double);
begin
  { RAP, 9/5/95 made P calculation universal - no reason to override for site type }
   with Locale do
    If UseBathymetry then
     P_Shape := 6.0 * ZM  / ZMax - 3.0;   {Junge in Hrbacek '66}
   { unitless                  m   m }

   { P is constrained:    -1 <= P <= 1 }
   If (P_Shape>1.0) then P_Shape:=1.0 else if (P_Shape<-1.0) then P_Shape:=-1.0;

(*   With Locale do
     case SiteType of
       Reservr1d  : ECoeffWater := 0.6;
       Lake       : ECoeffWater := 0.2;
       Pond       : ECoeffWater := 0.6; {RAP 9/5/95, was 1.3;}
       Stream     : ECoeffWater := 0.05;
       Enclosure: ECoeffWater := 0.6;
     end; {case} *)
end;

{---------------------------------------------------------------}

Function TAQTSite.Discharge_Using_QBase: Double;
{THIS FUNCTION NOT UTILIZED BY THE LINKED VERSION}
Var QBase, IDepth, Slope, Manning, Width: Double;
{ This function is used for streams when Tot_discharge = 0 }
Begin
 With Locale do
  Begin
   IDepth  := ICZMean;
   Slope   := Channel_Slope;
   if Slope <= 0 then Slope := 0.0001; {site is not a stream}
   { mannings coefficient }
   If UseEnteredManning then Manning := EnteredManning
     else
       If (StreamType='concrete channel') then Manning := 0.020
         else If (StreamType='dredged channel') then Manning := 0.030
           else Manning := 0.040; {natural stream}

   Width   := Locale.SurfArea / (SiteLength*1000);
    {m}         {m2}              {km}     {m/km}
  End;  {with}

{    -------------------------------------------------------------     }
{    BASE FLOW                                                         }
{    Manning's equation for initial flow depth, rectangular channel    }
{    -------------------------------------------------------------     }

  QBase := (POWER(IDepth,(5/3)) * Sqrt(slope) * Width ) / Manning;
  {m3/s}           {m}                {m/m}      {m}     {s/ m^1/3}


  Discharge_Using_QBase := QBase * 86400;
  {m3/d}                   {m3/s}  {s/d}
End;


Function TAQTSite.Conv_CBOD5_to_OM(RefrPct: Double):Double;
{Conversion Factor CBOD * Conv_BOD5 = OM }
Var BOD5_CBODu: Double;
Begin
   BOD5_CBODu := 1/((100-RefrPct)/100);
   With Remin do
     Conv_CBOD5_to_OM := BOD5_CBODu / O2Biomass;
End;
