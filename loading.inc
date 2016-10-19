//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
{-------------------------------------------------------------------}

(*** TLoad Methods ***)
constructor TLoad.Init(aD : TDateTime; aL : double);
begin
   Date:=aD;
   Loading:=aL;
end;

(*** TLoadings Methods ***)

Function TLoadings.Keyof(Item: Pointer): Pointer;
begin
  KeyOf:=Item;
end;

Function TLoadings.Compare(key1,key2: pointer):integer;

{*****************************************************}
{ This function determines the order in which the     }
{ TLoadings are sorted in                             }
{*****************************************************}

begin
     If      TLoad(key1).Date > TLoad(key2).Date  then compare:=1
     else if TLoad(key1).Date < TLoad(key2).Date  then compare:=-1
     else compare:=0;
end;



Function TLoadings.GetDateIndex(TimeIndex : Double) : integer;
Var i        : Integer;
    NotFound : Boolean;
    Check    : TDateTime;
{ This Procedure gets the nearest loading index to the given date that
  is greater or equal to the given date.
  If the Given Date is after all loadings, it returns -1.
  If the Given Date is before all loadings, it returns 0.

  The loadings are sorted upon entry from low date to high date values }

  {Optimized 12-21-2000  JSC}

Begin

   i:=0;
   NotFound:=True;

   {optimization for daily time-series loading}
   {Uses information from the last index read before comprehensive search for date}
   If (LastIndexRead >= 0) and (LastIndexRead <= Count-1) then
     Begin
       Check:= TLoad(At(LastIndexRead)).Date;
       If Check = TimeIndex  {lastindex is this index too}
         then begin
                i := LastIndexRead;
                NotFound := False;
              end
         else If Check < TimeIndex
           then Begin  {Too low, try the next one}
                  If LastIndexRead = Count-1 {stepped too far, there is no next one}
                    then Begin
                           i:=-1;   {mark given date as after all loadings}
                           NotFound := False;
                         End
                    else Begin
                           Check:= TLoad(At(LastIndexRead+1)).Date;
                           If Check >= TimeIndex then {found our index}
                             Begin
                               i := LastIndexRead + 1;
                               NotFound := False;
                             End;
                           {otherwise we're still too low, no optimized solution}
                         End;
                End
           else Begin {Check > TimeIndex.. Either too high or just right}
                  If LastIndexRead=0
                    then Begin     {can't be too high, there is no lower index}
                           i := 0;
                           NotFound := False;
                         End
                    else Begin
                           Check:= TLoad(At(LastIndexRead-1)).Date;
                           If Check<=TimeIndex
                             then Begin
                                    NotFound := False;
                                    If Check=TimeIndex then i := LastIndexRead-1  {looking back, hit it on the money}
                                                       else i := LastIndexRead;   {looking back, realized we had it right in the first place}
                                  End;
                           {otherwise we've over-shot again, no optimized solution}
                         End;
                End;
     End;  {Optimization}

   While (i<Count) and (NotFound) do
      begin
         Check:= TLoad(At(i)).Date;
         if Check >= TimeIndex  then
            NotFound:=False
         else
            i:=i+1;
      end;

   If Notfound then i:=-1;
   GetDateIndex  := i;
   LastIndexRead := i;
End;


Function TLoadings.GetLoad(TimeIndex : double; Interp: Boolean) : double;

Var i : integer;
    TimeIndexHolder: Double;
    AddIndex: Boolean;
    ExtrapLoad: TLoad;
    NewDate: TDateTime;
    NewLoad: Double;
    m,x1,x2,y1,y2: Double;

{This procedure calculates the dynamic loading for a given timeindex.

If there is only one dynamic loading point present, that is essentially
the same thing as a constant load, no further data are available.

If there is more than one point, then the procedure linearly interpolates
the correct loading for the time index.  A year cycle is also assumed for
loading.  If the timeindex is between two points, a straight linear interpolation
is done.  If the timeindex is not between two points,
it is moved forward or backward by 1 year increments to try
and get it between two points.  If necessary another "dummy" loading is added
after the timeindex to make interpolation possible. (if jumping does not
place the point within two points}

{Updated 7-17-2005 to handle the case of hourly loadings JSC}

begin

  If Count=0 then begin GetLoad:=0;
                        Exit;
                  end;

  {If Only one loading, no extrapolation can be done}
  If Count=1 then begin GetLoad:=TLoad(At(0)).Loading;
                        Exit;
                  end;

  TimeIndexHolder := TimeIndex;
  If not Hourly then TimeIndexHolder:=Trunc(TimeIndex);
  AddIndex:=False;
  i:=GetDateIndex(TimeIndexHolder);
  {Four Cases, (1) TimeIndex before all loading dates,
               (2) TimeIndex after all loading dates,
               (3) TimeIndex in the middle of 2 loading dates
               (4) TimeIndex = Loading Date.}

   if i=-1 then begin {case 2}
                  Repeat  {Move TimeIndex back to create case 1,3, or 4}
                      TimeIndexHolder:=SubtractOneYear(TimeIndexHolder);
                      i:=GetDateIndex(TimeIndexHolder);
                  Until i>-1;
                end;


    {Try to Translate Case 1 into Case 3 or 4 by Moving TimeIndex up.
                                May jump all loadings and create case 2}

    if (i=0) then if (TLoad(At(i)).Date<>TimeIndexHolder) then begin
                  Repeat  {Move TimeIndex forward to create case 2,3, or 4}
                      TimeIndexHolder:=AddOneYear(TimeIndexHolder);
                      i:=GetDateIndex(TimeIndexHolder);
                  Until i<>0;
                 end;

    {Solve Case 4}
    if i>-1 then if (TLoad(At(i)).Date=TimeIndexHolder) then
                                               begin
                                                 GetLoad:=TLoad(At(i)).Loading;
                                                 Exit;
                                               end;


    if i=-1 then begin {Jumped to Case 2, Need to Add "New" Load at end for interpolation}
                   NewDate:=AddOneYear(Trunc(TLoad(At(0)).Date));
                   NewLoad:=TLoad(At(0)).Loading;
                   ExtrapLoad:=TLoad.Init(NewDate,NewLoad);
                   AtInsert(Count,ExtrapLoad);  {Insert New Record at end of list, Increment Count}
                   i:=Count-1; {Position pointer at last element in list}
                   AddIndex:=True;
                 end;

    if not interp then Begin GetLoad := -9999; Exit; End;

    {Case 3, Linear Interpolation between TLoad[i-1] (x1,y1), and TLoad[i] (x2,y2)}
                begin
                  y1:=TLoad(At(i-1)).Loading;  x1:=TLoad(At(i-1)).Date;
                  y2:=TLoad(At(i)).Loading;    x2:=TLoad(At(i)).Date;

                  {Finally, do the liner interpolation}
                  m:=(y2-y1)/(x2-x1); {slope}
                  GetLoad := m*(TimeIndexHolder-x1)+y1;

                  {If Added a loading index, delete that now}
                  If AddIndex then AtFree(Count-1);
                end; {Linear interpolation}
end;


Function TLoadings.SubtractOneYear(InDate: Double):Double;
Var Yr,Mo,Dy: Word;
Begin
  DecodeDate(Indate,Yr,Mo,Dy);
  If Mo<3 {before march} then Yr := Yr-1;  {we care if previous year was leap year}
  If IsLeapYear(Yr) then SubtractOneYear := InDate-366
                    else SubtractOneYear := InDate-365;
End;


Function TLoadings.AddOneYear(InDate: Double):Double;
Var Yr,Mo,Dy: Word;
Begin
  DecodeDate(Indate,Yr,Mo,Dy);
  If Mo>2 {after February} then Yr := Yr+1;  {we care if next year is leap year}
  If IsLeapYear(Yr) then AddOneYear := InDate+366
                    else AddOneYear := InDate+365;
End;

Procedure TLoadings.Store(IsTemp: Boolean; Var st: TStream);
Begin
   st.write(Hourly,Sizeof(Hourly));
   inherited;
End;

Constructor TLoadings.Load(IsTemp: Boolean; st: Tstream; ReadVersionNum: Double);
Begin
   If ReadVersionNum > 3.155 then st.read(Hourly,Sizeof(Hourly))
                             else Hourly  := False;
   inherited;   
End;

{------------------------------------------------------------------------------}


Procedure  TLoad.Store(IsTemp: Boolean; Var st: TStream);
Begin
     st.write(Date,Sizeof(Date));
     st.write(Loading,Sizeof(Loading));
End;

Procedure  TLoad.WriteText;
Begin
   If Not WriteLoadingsToTextLog then Exit;
   If Date = Trunc(Date) then Write(LF,DateToStr(Date)+', ')
                         else Write(LF,DateTimeToStr(Date)+', ');
   Write(LF,FloatToStrf(Loading,ffgeneral,5,5)+'; ');
End;


Constructor TLoad.Load(IsTemp: Boolean; st: Tstream; ReadVersionNum: Double);
Begin
     st.Read(Date,Sizeof(Date));
     st.Read(Loading,Sizeof(Loading));
End;


 {-------------------------------------------------------------------}
 Procedure LoadingsRectoText(Var LF: TextFile; Ld: LoadingsRecord; HasAlt: Boolean);
 Var Alt: Alt_LoadingsType;
     P: TLoad;
     i: Integer;
 Begin
  With Ld do
   Begin
     If NoUserLoad then Writeln(LF,'Loadings Ignored (annual means if relevant)');
     If UseConstant
       then Writeln(LF,'ConstLoad: '+FloatToStrF(ConstLoad,ffgeneral,5,5))
       else Begin
              Write(LF,'Dynamic Loadings: ');
              For i:=0 to Loadings.Count-1 do
              begin
                P:=Loadings.At(i);
                P.WriteText(LF);
              end;
              Writeln(LF);
            End;
     Writeln(LF,'Multiply Loading By: '+FloatToStrF(MultLdg,ffgeneral,5,5));

     If HasAlt then
       For Alt:= PointSource to NonPointSource do
         Begin
           Case Alt of
             PointSource: Writeln(LF,'Point Source Loadings');
             NonPointSource: Writeln(LF,'NonPoint Source Loadings');
             DirectPrecip: Writeln(LF,'Direct Precip Loadings');
           End; {Case}

           If Alt_UseConstant[Alt]
             then Writeln(LF,'  ConstLoad: '+FloatToStrF(Alt_ConstLoad[Alt],ffgeneral,5,5))
             else Begin
                    Write (LF,'  Dynamic Loadings: ');
                    For i:=0 to Alt_Loadings[Alt].Count-1 do
                    begin
                      P:=Alt_Loadings[Alt].At(i);
                      P.WriteText(LF);
                    end;
                    Writeln(LF);
                  End;
           Writeln(LF,'Multiply Loading By: '+FloatToStrF(Alt_MultLdg[Alt],ffgeneral,5,5));
         End;

   End; {With}
 End;
 {-------------------------------------------------------------------}

 Function ReturnLoad(TimeIndex: Double; Ld: LoadingsRecord) : Double;
 Var RetLoad: Double;    {Hold Result}
 Begin
   If Ld.UseConstant then RetLoad:=Ld.ConstLoad
     else
       begin
         RetLoad:=0;
         if Ld.Loadings<>nil then
            RetLoad:=Ld.Loadings.GetLoad(TimeIndex,True);
       end;  {else}
     RetLoad := RetLoad * Ld.MultLdg;
   ReturnLoad := RetLoad;
 End;

 {-------------------------------------------------------------------}

 Function ReturnAltLoad(TimeIndex: Double; Ld: LoadingsRecord; AltLdg: Alt_LoadingsType) : Double;
 Var RetLoad: Double;    {Hold Result}
 Begin
   If Ld.Alt_UseConstant[AltLdg] then RetLoad:=Ld.Alt_ConstLoad[AltLdg]
     else
       begin
         RetLoad:=0;
         if Ld.Alt_Loadings[AltLdg]<>nil then
            RetLoad:=Ld.Alt_Loadings[AltLdg].GetLoad(TimeIndex,True);
       end;  {else}
     RetLoad := RetLoad * Ld.Alt_MultLdg[AltLdg];
   ReturnAltLoad := RetLoad;
 End;

 {-------------------------------------------------------------------}



