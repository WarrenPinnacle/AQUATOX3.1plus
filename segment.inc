//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Constructor TSegmentLink.Init(ASegmentName : ShortString);
Var SedLoop: AllVariables;
Begin
   Name          := ASegmentName;
   FromID        := '';
   ToID          := '';
   LinkType      := FeedbackLnk;
   CharLength    := 0;
   XSectionData  := TLoadings.Init(5,5);
   DiffusionData := TLoadings.Init(5,5);
   WaterFlowData := TLoadings.Init(5,5);

   For SedLoop := Cohesives to NonCohesives2 do
     BedLoad[SedLoop] := TLoadings.Init(5,5);

   CurrentXSection  := 0;
   CurrentWaterFlow := 0;
   CurrentDiffusion := 0;
   GetLoadsDate  := -99;
   CascadeWash := nil;
End;

Destructor TSegmentLink.Destroy;
Var SedLoop: AllVariables;
Begin
  DiffusionData.Destroy;
  WaterFlowData.Destroy;
  XSectionData.Destroy;
  For SedLoop := Cohesives to NonCohesives2 do
     BedLoad[SedLoop].Destroy;
  If (CascadeWash<>nil) then CascadeWash.Destroy;
  inherited Destroy;
End;

Procedure TSegmentLink.Store(IsTemp: Boolean; var st: Tstream);
Var SedLoop: AllVariables;
Begin
  St.Write(Name,Sizeof(Name));
  St.Write(FromID,Sizeof(FromID));
  St.Write(ToID,Sizeof(ToID));
  St.Write(LinkType,Sizeof(LinkType));
  St.Write(CharLength,Sizeof(CharLength));

  DiffusionData.Store(IsTemp,St);
  StoreCollectionitems(IsTemp,St,DiffusionData);
  WaterFlowData.Store(IsTemp,St);
  StoreCollectionitems(IsTemp,St,WaterFlowData);
  XSectionData.Store(IsTemp,St);
  StoreCollectionitems(IsTemp,St,XSectionData);

  For SedLoop := Cohesives to NonCohesives2 do
    Begin
      BedLoad[SedLoop].Store(IsTemp,St);
      StoreCollectionitems(IsTemp,St,BedLoad[SedLoop]);
    End;

End;

Procedure TSegmentLink.WriteText;
Var LinkStr: String;
    SedLoop: AllVariables; 
Begin

  If LinkType = CascadeLnk then LinkStr := 'CASCADE '
                           else LinkStr := 'FEEDBACK ';

  Writeln(LF,'---------------------------------------');
  Writeln(LF,LinkStr+'LINK NAME: '+Name);
  Writeln(LF,'From: '+FromID +  '  To: '+TOID);

  Writeln(LF,'--------------------------');
   Write(LF, 'Water Flow Data: ');
   WriteTextCollection(LF,WaterFlowData);
   Writeln(LF);

   If LinkType <> CascadeLnk then
     Begin
       Writeln(LF,'CharLength: ',FloatToStrF(CharLength,ffgeneral,5,5));
       Write(LF, 'Diffusion: ');
       WriteTextCollection(LF,DiffusionData);
       Writeln(LF);
       Write(LF, 'XSections: ');
       WriteTextCollection(LF,XSectionData);
       Writeln(LF);
     End;

  For SedLoop := Cohesives to NonCohesives2 do
    Begin
       Write(LF,StateText(SedLoop,StV,WaterCol)+' BedLoad: ');
       WriteTextCollection(LF,BedLoad[SedLoop]);
       Writeln(LF);
    End;

End;

Constructor TSegmentLink.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Var SedLoop: AllVariables;
Begin
  St.Read(Name,Sizeof(Name));
  St.Read(FromID,Sizeof(FromID));
  St.Read(ToID,Sizeof(ToID));
  St.Read(LinkType,Sizeof(LinkType));
  St.Read(CharLength,Sizeof(CharLength));

  DiffusionData := TLoadings.Load(IsTemp,St,ReadVersionNum);
  LoadCollectionitems(IsTemp,St,DiffusionData,False,ReadVersionNum);
  WaterFlowData := TLoadings.Load(IsTemp,St,ReadVersionNum);
  LoadCollectionitems(IsTemp,St,WaterFlowData,False,ReadVersionNum);
  XSectionData := TLoadings.Load(IsTemp,St,ReadVersionNum);
  LoadCollectionitems(IsTemp,St,XSectionData,False,ReadVersionNum);

  For SedLoop := Cohesives to NonCohesives2 do
    Begin
      BedLoad[SedLoop] := TLoadings.Load(IsTemp,St,ReadVersionNum);
      LoadCollectionitems(IsTemp,St,BedLoad[SedLoop],False,ReadVersionNum);
    End;

  CurrentXSection  := 0;
  CurrentWaterFlow := 0;
  CurrentDiffusion := 0;

  GetLoadsDate     := -99;
  CascadeWash := nil;
End;

Procedure TSegmentLink.GetFromPLoadings(Time: TDateTime);
Var SedLoop: AllVariables;
Begin
  CurrentXSection  := XSectionData.GetLoad(Time,True);
  CurrentWaterFlow := WaterFlowData.GetLoad(Time,True);
  CurrentDiffusion := DiffusionData.GetLoad(Time,True);
  For SedLoop := Cohesives to NonCohesives2 do
    CurrentBedLoad[SedLoop] := BedLoad[SedLoop].GetLoad(Time,True);

  GetLoadsDate := Time;
End;

Function TSegmentLink.GetBedLoad(Sed: AllVariables;Time: TDateTime): Double;
Begin
  If Trunc(Time)<>Trunc(GetLoadsDate) then GetFromPLoadings(Time);
  GetBedLoad := CurrentBedLoad[Sed];
end;

Function TSegmentLink.GetWaterFlow(Time: TDateTime): Double;
Begin
  If Trunc(Time)<>Trunc(GetLoadsDate) then GetFromPLoadings(Time);
  GetWaterFlow := CurrentWaterFlow;
End;

Function TSegmentLink.GetDiffusion(Time: TDateTime): Double;
Begin
  If Trunc(Time)<>Trunc(GetLoadsDate) then GetFromPLoadings(Time);
  GetDiffusion := CurrentDiffusion;
End;

Function TSegmentLink.GetXSection(Time: TDateTime): Double;
Begin
  If Trunc(Time)<>Trunc(GetLoadsDate) then GetFromPLoadings(Time);
  GetXSection := CurrentXSection;
End;
