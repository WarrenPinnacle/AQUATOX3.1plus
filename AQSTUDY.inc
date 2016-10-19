//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Function TAQUATOXSegment.RemoveStateVariable(NS : StateVariables; Typ: T_SVType; Lyr: T_SVLayer): Boolean;
Var RecIndex: Integer;
Begin
   Result := False;
   RecIndex := SV.GetIndex(NS,Typ,Lyr);
   If RecIndex>-1 then
     Begin
       SV.AtFree(RecIndex);
       SV.SetMemLocRec;
       Result := True;
     End;
End;

Procedure TAQUATOXSegment.AddStateVariable(NS : StateVariables; Lyr: T_SVLayer; IC : Double; IsTempl: Boolean);
Var P : TStateVariable;
    ToxLoop : AllVariables;
{Add the NS variable and the associated toxicity S.V. if appropriate}

Begin
   case NS of
      Volume:            P:=TVolume.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Temperature:       P:=TTemperature.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Windloading:       P:=TWindloading.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Light:             P:=TLight.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      pH:                P:=TpHObj.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Phosphate: If Lyr>WaterCol
                         then P:=TPO4_Sediment.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl)
                         else P:=TPO4Obj.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Ammonia: If Lyr>WaterCol
                         then P:=TNH4_Sediment.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl)
                         else P:=TNH4Obj.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Nitrate: If Lyr>WaterCol
                         then P:=TNO3_Sediment.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl)
                         else P:=TNO3Obj.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Silica, Avail_Silica:   P:=TSilica_Sediment.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Sulfide:           P:=TSulfide_Sediment.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Methane:           P:=TMethane.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      COD:               P:=TCOD.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      POC_G1..POC_G3:    P:=TPOC_Sediment.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      POP_G1..POP_G3:    P:=TPOP_Sediment.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      PON_G1..PON_G3:    P:=TPON_Sediment.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      CO2:               P:=TCO2Obj.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Oxygen:            P:=TO2Obj.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Salinity:          P:=TSalinity.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      PoreWater:         P:=TPoreWater.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      ReDOMPore..LaDOMPore:P:=TDOMPoreWater.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      BuriedLabileDetr:    P:=TBuriedDetr1.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      BuriedRefrDetr:      P:=TBuriedDetr1.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Sand..TSS :        P:=TSandSiltClay.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      Cohesives : If Lyr>WaterCol
                          then P:=TBottomCohesives.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl)
                          else P:=TSuspSediment.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      NonCohesives..NonCohesives2: If Lyr>WaterCol
                          then P:=TBottomSediment.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl)
                          else P:=TSuspSediment.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      SedmLabDetr: If Lyr>WaterCol
                          then P:=TBuriedDetr2.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl)
                          else P:=TSedLabileDetr.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      SedmRefrDetr: If Lyr>WaterCol
                          then P:=TBuriedDetr2.init(NS,StV,Lyr,StateText(NS,StV,Lyr),SV,IC,IsTempl)
                          else P:=TSedRefrDetr.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      SuspRefrDetr:            P:=TSuspRefrDetr.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      SuspLabDetr:             P:=TSuspLabDetr.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      DissRefrDetr:            P:=TDissRefrDetr.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      DissLabDetr:             P:=TDissLabDetr.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      FirstAlgae..LastAlgae:   P:=TPlant.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      FirstMacro..LastMacro:   P:=TMacrophyte.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      FirstAnimal..LastAnimal: P:=TAnimal.init(NS,StV,StateText(NS,StV,Lyr),SV,IC,IsTempl);
      FirstOrgTox..LastOrgTox: P:=TToxics.init(NS,Volume,StV,Lyr,StateText(NS,StV,Lyr)+': [' +
                                 PChems^[AssocToxTyp(NS)].ChemRec.ChemName + ']',SV,IC,IsTempl);
      else P:=nil;
   end;   {case}
   if P <> nil then SV.Insert(P);
   if p=nil then Raise EAQUATOXERROR.Create('Programming Error:  Illegal Add of SV Type');

   IF (SV.Location.sitetype=TribInput) then TStateVariable(P).LoadsRec.ConstLoad := 0;  {don't seed biota in a pass through segment}

   SV.SetMemLocRec;
   {Add OrgTox SVs if H2OTox is included}
   For ToxLoop:=FirstOrgTox to LastOrgTox do
     If SV.GetStatePointer(ToxLoop,StV,WaterCol)<>nil then AddOrgToxStateVariable(NS,Lyr,AssocToxTyp(ToxLoop),IsTempl);

   If (NS in [FirstPlant..LastPlant]) and SV.SetupRec.Internal_Nutrients then AddInternalNutSVs(NS,IsTempl);
end;


Procedure TAQUATOXSegment.AddOrgToxStateVariable(NS: StateVariables; Lyr: T_SVLayer; ToxType :T_SVType; IsTempl: Boolean);
Var P: TStateVariable;
Begin
   {Add Associated Toxic State Variables if Appropriate}
   case NS of
      BuriedLabileDetr: P:=TBuriedDetrTox1.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl);
      BuriedRefrDetr:   P:=TBuriedDetrTox1.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl);
      SuspRefrDetr..SuspLabDetr:  P:=TParticleTox.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl);
      DissRefrDetr..DissLabDetr:  P:=TParticleTox.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl);
      PoreWater:              P:=TPoreWaterTox.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl);
      ReDOMPore..LaDOMPore:      P:=TDOMPoreWaterTox.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl);

      Cohesives..NonCohesives2: If Lyr>WaterCol
                   then P:=TBottomSedimentTox.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl)
                   else P:=TSuspSedimentTox.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl);
      SedmRefrDetr..SedmLabDetr: If Lyr>WaterCol
                   then P:=TBuriedDetrTox2.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl)
                   else P:=TParticleTox.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl);

      FirstPlant..LastPlant,
      FirstInvert..LastInvert:  P:=TAlgae_ZooTox.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl);
      FirstFish..LastFish:      P:=TFishTox.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl);
      POC_G1..POC_G3:           P:=TPOCTox.init(NS,NS,ToxType,Lyr,'Undisplayed',SV,0,IsTempl);
      else P:=nil;
   end;
   if P <> nil then SV.Insert(P);
   SV.SetMemLocRec;

End;

Procedure TAQUATOXSegment.AddInternalNutSVs(NS : StateVariables; IsTempl: Boolean);
Var P: TStateVariable;
    TP: TPlant;
Begin
  TP := SV.GetStatePointer(Ns,Stv,WaterCol);
  If TP=nil then exit;
  If TP.IsMacrophyte then
      If  not (TMacrophyte(TP).MacroType= FreeFloat) then exit;  //add floating but not others

  P:=T_N_Internal_Plant.init(NS,NIntrnl,WaterCol,'Undisplayed',SV,0,IsTempl);
  if P <> nil then SV.Insert(P);
  SV.SetMemLocRec;

  P:=T_N_Internal_Plant.init(NS,PIntrnl,WaterCol,'Undisplayed',SV,0,IsTempl);
  if P <> nil then SV.Insert(P);
  SV.SetMemLocRec;
End;


Procedure TAQUATOXSegment.RemoveInternalNutSVs(NS : StateVariables);
Begin
   RemoveStateVariable(NS,NIntrnl,WaterCol);
   RemoveStateVariable(NS,PIntrnl,WaterCol);
End;


Constructor TAQUATOXSegment.Init(AStudyName : ShortString; TemplStdy: TAQUATOXSegment);
Var Loop2: T_SVType;
    PStatesTemplate: Pointer;
Begin
   If TemplStdy=nil then TemplateSeg := Self
                    else TemplateSeg := TemplStdy;

   If TemplStdy=nil then New(PSetup)
                    else PSetup := TemplStdy.PSetup;

   If TemplStdy=nil then New(PUncertainty)
                    else PUncertainty := TemplStdy.PUncertainty;

   StudyName  := AStudyName;
   FileName   := 'AQUATOX1.APS';
   DirName    := Studies_Dir;
   LastChange := -99;
   TimeLoaded := -99;
   LastRun    := -1;
   ControlRun := -1;
   NewNotes   := TStringList.Create;
   NewNotes.Add(' ');
   Location    := TAQTSite.init;
   SegNumber    := '';
   AllOtherSegs := nil;
   OtherFBSegs  := nil;

   If TemplStdy=nil
     then
       Begin
         New(PChems);
         For Loop2  := FirstOrgTxTyp to LastOrgTxTyp do
             PChems^[Loop2] := nil;
 //         PChems^[FirstOrgTxTyp] := TChemical.init;  ??   // Fix 2/22/2012 JSC
       End
     else PChems := TemplStdy.PChems;

   New(PDiagenesis);                            //10-28-2010  Diagenesis Parameters now segment-specific
   SetDefaultDiagenesis(PDiagenesis^,false);

//   If TemplStdy=nil
//     then
//       Begin
//         New(PDiagenesis);
//         SetDefaultDiagenesis(PDiagenesis^,false);
//       End
//     else PDiagenesis := TemplStdy.PDiagenesis;

   Unc_Dir    := ''; Unc_File:=''; Unc_Ext:='';

   If TemplStdy=nil then PStatesTemplate := nil
                    else PStatesTemplate := TemplStdy.SV;
   SV := TStates.init(20,10,Location,PChems,PSetup,PDiagenesis,PStatesTemplate,AllSVs);

   Control_Is_Running := False;
   RunIterations := False;
   SimsRunning := 0;

End;

Destructor TAQUATOXSegment.Destroy;
Var Loop2: T_SVType;
    IsTemplate: Boolean;
Begin
   IsTemplate := (TemplateSeg = Self);

   If IsTemplate then
     Begin
       IF PChems <> nil then
        For Loop2 := FirstOrgTxTyp to LastOrgTxTyp do
          If PChems^[Loop2]<>nil then PChems^[Loop2].Destroy;
       IF PChems <> nil then Dispose(PChems);
       If PSetup <> nil then Dispose(PSetup);
       Dispose(PUncertainty);
     End;

   Dispose(PDiagenesis);   //10-28-2010 segment-specific

   If SV<>nil then SV.Destroy;
   If Location<>nil then Location.Destroy;

End;



Procedure TAQUATOXSegment.GetAllInsertableStates(P : TStrings);
{Gets all state variables that are not already displayed and thus can
 be inserted into the current study. }

Var S : StateVariables;
    NewStateName : ShortString;
begin

    S:=FirstState;
    repeat
       NewStateName:=StateText(S,StV,WaterCol);
       If (NewStateName<>'Undisplayed') then
         If (SV.GetIndex(S,StV,WaterCol) = -1) then
           If not (S in [SedmRefrDetr,SedmLabDetr,Silica..POP_G3]) then
               P.Add(NewStateName);
       Inc(S);
    until S=LastState;  {last state will not display (nullstatevar)}
end;


{--------------------------------------------------------------------------}
Function TAQUATOXSegment.SetupforRun:Boolean;
Var Loop: VerticalSegments;
    TVol: TVolume;
Begin
  SetupForRun:=True;
  With SV do
    Begin
      SV.EstuarySegment := (SV.Location.SiteType=Estuary) and (not SV.LinkedMode);

      If SV.Location.sitetype=TribInput then  {9/25/2009}
        Begin
          TVol := SV.GetStatePointer(Volume,StV,WaterCol);
          TVol.Calc_Method := Dynam;
          If TVol.InitialCond < Tiny then TVol.InitialCond := 1.0;  {arbitrary but must be non-zero}
        End;

      CopySuspDetrData;
      Zero_Utility_Variables;
      SetMemLocRec;                   {Set up array of pointers to memory}

      SetStateToInitConds(True);            {Set up State Variables}

      For Loop := Epilimnion to Hypolimnion do
        Begin
          Results[loop].Destroy;
          Results[loop] := TResultsCollection.Init;
        End;

      TPresent := PSetup^.FirstDay;

      If PSetup^.ModelTSDays
        then PModelTimeStep^ := TSDaily
        else PModelTimeStep^ := TSHourly;

      CalculateAllLoads(PSetup^.FirstDay);  {Calc initial Loads and Initialize Morphometry}
      SetMeanDischarge(PSetup^.FirstDay);   {Calc mean discharge for first year}

    End; {With}
End;  {SetupRun}

{--------------------------------------------------------------------------}

Procedure TAQUATOXSegment.Run;
Var ErrorString: ShortString;
    Loop: Integer;
    StoreStep: Double;
Begin

   Try
     If not SetupforRun then exit;

     If PSetup^.SaveBRates and (not SV.PRateInfo^.WriteToMemory) then
       Begin
         SetLength(OpenWriteFiles, Length(OpenWriteFiles)+1);
         OpenWriteFiles[Length(OpenWriteFiles)-1] := SV.PRateInfo^.FileNm;
       End;

     AllSVs := SV;
     SV.PAllSVsColl := @AllSVs;
     StoreStep := PSetup^.StoreStepSize;
     If not PSetup^.StepSizeInDays then StoreStep := StoreStep / 24;
     Integrate(PSetup^.FirstDay,PSetup^.LastDay,PSetup^.RelativeError,MINIMUM_STEPSIZE,StoreStep);
     {Integrate Parameters: x1, x2, eps, h1, hmin, dxsav: double );  }
   Except
     ErrorString:=Exception(ExceptObject).Message;
     SV.ProgData.ProgCancel := True;

     SV.PMessageStr^ := 'Run-Time Error During Study Run.';
     SV.PMessageErr^ := True;
     SV.TSMessage;
     SV.PMessageStr^ := ErrorString;
     SV.TSMessage;
   End;

   If SV.ProgData.ProgCancel  then LastRun:=-2
                              else LastRun := Date+Time;

   Try
     If (PSetup^.SaveBRates) and (Not SV.PRateInfo^.WriteToMemory) then ConvertRatestoXLS;
   Except
     ErrorString:=Exception(ExceptObject).Message;

     SV.PMessageStr^ := 'Run-Time Error Writing XLS File.';

     SV.PMessageErr^ := True;
     SV.TSMessage;
     SV.PMessageStr^ := ErrorString;
     SV.TSMessage;
   End;

   Try
     Try
       If SV.Stratified then SV.Overturn(True);  {Returns vital info to SV}
     Except
     End;  {Continue even if error raised during overturn}

   If SV.ProgData.ProgCancel then Begin
                                     Unc_Dir   := ''; Unc_File:=''; Unc_Ext:='';
                                   End;

   If not SV.ProgData.ProgCancel then
      If (PUncertainty^.Run_Uncertainty) and (RunIterations) then LatinHypercubeRun;

   If not SV.ProgData.ProgCancel then
      If (PUncertainty^.Run_Sensitivity) and (RunIterations) then SensitivityRun;

   If SV.OOSStack<>nil then SV.OOSStack.FreeAll;  SV.OOSStack := nil;

   For Loop := 1 to Length(OpenWriteFiles) do
     If SV.PRateInfo^.FileNm=OpenWriteFiles[Loop-1] then
       OpenWriteFiles[loop-1] := '';

   SV.WriteTable.Free;
   If SV.PRateInfo^.FileInit[Hypolimnion] then SV.HypTable.Free;

   For Loop := 1 to Length(OpenUncFiles) do
     If Unc_File=OpenUncFiles[Loop-1] then
       OpenUncFiles[loop-1] := '';

   Finally
 End; {try Finally}
End;

{-------------------------------------------------------------------}
{Types for saving a control run's information}

Type CtrlRange = FirstState..LastState;
     PSavedRun=^SavedRunInfoRec;
     SavedRunInfoRec = Record
         Constload:     Array[CtrlRange,StV..LastOrgTxTyp] of Double;
         UseConst:      Array[CtrlRange,StV..LastOrgTxTyp] of Boolean;
         InitialCond:   Array[CtrlRange,StV..LastOrgTxTyp,WaterCol..LowestLayer] of Double;
         MultLdg:       Array[CtrlRange,StV..LastOrgTxTyp] of Double;

         AltLdgCL:      Array[CtrlRange,StV..LastOrgTxTyp,Alt_LoadingsType] of Double;
         AltLdgUC:      Array[CtrlRange,StV..LastOrgTxTyp,Alt_LoadingsType] of Boolean;
         AltMltLdg:     Array[CtrlRange,StV..LastOrgTxTyp,Alt_LoadingsType] of Double;

         ResultsHolder:   Array[Epilimnion..Hypolimnion] of Pointer;
         TimingHolder:    TDateTime;
         InputRecHolder:  DetritalInputRecordType;
       End;


Procedure TAQUATOXSegment.SetupControlRun(Var P: Pointer);

{This procedure copies the toxicant values into holding
 arrays of type PSavedRun which the variable P points at.

 The procedure then points a temporary variable at the results collection
 and initializes a new one for the control results, and then zeros out the
 toxicant values for the control run.}

Var PS:               PSavedRun;
    SVLoop:           StateVariables;
    TypLoop:          StV..LastOrgTxTyp;
    LayerLoop:        T_SVLayer;
    SVPtr:            TStateVariable;
    StratLoop:        VerticalSegments;
    AltLoop:          Alt_LoadingsType;
    PDRD:             TDissRefrDetr;
    PBD:              TBuriedDetr1;
    CheckRecord:      Control_Opt_SubRec;
    PT:               TToxics;
    OmitAlt, KillLoad,
    KillIC:           Boolean;
    ModifySV:         Boolean;
Begin

  CONTROL_IS_RUNNING:=TRUE;

  New(PS);
  PS.TimingHolder:=LastRun;

  PDRD := SV.GetStatePointer(DissRefrDetr,StV,WaterCol);
  PS.InputRecHolder := PDRD.InputRecord; {save for later restoration}

  For StratLoop:= Epilimnion to Hypolimnion do
   begin
     PS.ResultsHolder[StratLoop]:=SV.Results[StratLoop];
     SV.Results[StratLoop]:=TResultsCollection.init;
   end;

  For TypLoop := StV to LastOrgTxTyp do
   For SVLoop:=FirstState to LastState do
    Begin
      ModifySV := (TypLoop>StV) or (SVLoop in [FirstTox..LastTox,Ammonia..Phosphate,Sand..NonCohesives2,FirstDetr..LastDetr]);
                   {Only Modify Toxicants, Nutrients, Sediments, and Detritus}
      If SVLoop in [BuriedRefrDetr,BuriedLabileDetr] then ModifySV := False;
                   {Buried Toxicants are handled below}
        If  ModifySV
         then
           begin
             If (SVLoop in [FirstOrgTox..LastOrgTox]) or (TypLoop in [FirstOrgTxTyp..LastOrgTxTyp])
                  then CheckRecord:=SV.PControlInfo^.Tox else
             If (SVLoop in [Sand..Noncohesives2])
                  then CheckRecord:=SV.PControlInfo^.Sediment else
             If (SVLoop in [Ammonia..Phosphate])
                  then CheckRecord:=SV.PControlInfo^.Nutrient
             else CheckRecord:=SV.PControlInfo^.Detritus;

             If TypLoop in [FirstOrgTxTyp..LastOrgTxTyp]
               then KillLoad:=CheckRecord.OmitTox
               else KillLoad:=CheckRecord.OmitInflow;

             SVPtr:= SV.GetStatePointer(SvLoop,TypLoop,WaterCol);
             If (SVPtr<>nil) then
               With SVPtr do With LoadsRec do
                 Begin
                  If KillLoad then
                    begin
                      PS.ConstLoad[SvLoop,TypLoop] := ConstLoad;
                      ConstLoad:=0;
                      PS.UseConst[SvLoop,TypLoop] := UseConstant;
                      UseConstant:=True;

                      If SVLoop=DissRefrDetr then with PDRD.InputRecord do
                        If TypLoop=StV then
                          Begin
                            Load.ConstLoad := 0;
                            Load.UseConstant := True;
                          End else
                          Begin
                            ToxLoad[TypLoop].ConstLoad := 0;
                            ToxLoad[TypLoop].UseConstant := True;
                          End;
                    end;

                  If CheckRecord.SetMult then
                    begin
                      PS.MultLdg[SvLoop,TypLoop] := MultLdg;
                      MultLdg:=1.0;
                      If Has_Alt_Loadings(SVLoop,TypLoop,WaterCol) then
                        For AltLoop := PointSource to NonPointSource do
                          Begin
                            PS.AltMltLdg[SvLoop,TypLoop,AltLoop] := Alt_MultLdg[AltLoop];
                            Alt_MultLdg[AltLoop] := 1.0;
                          End;

                      If SVLoop=DissRefrDetr then with PDRD.InputRecord do
                        If TypLoop=StV then
                          Begin
                            Load.MultLdg := 1.0;
                            For AltLoop := PointSource to NonPointSource do
                              Load.Alt_MultLdg[AltLoop] := 1.0;
                          End else
                          Begin
                            ToxLoad[TypLoop].MultLdg := 1.0;
                            For AltLoop := PointSource to NonPointSource do
                              ToxLoad[TypLoop].Alt_MultLdg[AltLoop] := 1.0;
                          End;

                    end;

                  If TypLoop in [FirstOrgTxTyp..LastOrgTxTyp]
                     then KillIC:=CheckRecord.OmitTox
                     else KillIC:=CheckRecord.ZeroInitCond;

                  If KillIC then
                    begin
                      PS.InitialCond[SvLoop,TypLoop,WaterCol] := InitialCond;
                      InitialCond:=0.0;

                      If SVLoop=DissRefrDetr then with PDRD.InputRecord do
                        If TypLoop=StV then InitCond := 0.0
                                       else ToxInitCond[TypLoop] := 0.0;

                    end;

                  {Alternate Loadings}
                  If Has_Alt_Loadings(SVLoop,TypLoop,WaterCol) then
                    For AltLoop := PointSource to NonPointSource do
                    Begin
                      If AltLoop = PointSource then OmitAlt := CheckRecord.OmitPS
                         else If AltLoop = NonPointSource then OmitAlt := CheckRecord.OmitNPS
                                                          else OmitAlt := CheckRecord.OmitDP;
                      If OmitAlt then
                          begin
                            PS.AltLdgCL[SvLoop,TypLoop,AltLoop] := Alt_ConstLoad[AltLoop];
                            Alt_ConstLoad[AltLoop]:=0;
                            PS.AltLdgUC[SvLoop,TypLoop,AltLoop] := Alt_UseConstant[AltLoop];
                            Alt_UseConstant[AltLoop]:=True;

                            If SVLoop=DissRefrDetr then with PDRD.InputRecord do
                              If TypLoop=StV then
                                Begin
                                  Load.Alt_ConstLoad[AltLoop] := 0;
                                  Load.Alt_UseConstant[AltLoop] := True;
                                End else
                                Begin
                                  ToxLoad[TypLoop].Alt_ConstLoad[AltLoop]  := 0;
                                  ToxLoad[TypLoop].Alt_UseConstant[AltLoop] := True;
                                End;
                          end;
                    End;
                 End;  {with}
           End; {If ModifySV}
        End; {SvLoop}

  {Handle Buried Toxicants (Multi Layer)}
  For TypLoop := FirstOrgTxTyp to LastOrgTxTyp do
   For SVLoop:=PoreWater to SedmLabDetr do
    For LayerLoop := SedLayer1 to LowestLayer do
      Begin
        PT := SV.GetStatePointer(SvLoop,TypLoop,LayerLoop);
           If not (PT=nil) then
             Begin
               If (TypLoop in [FirstOrgTxTyp..LastOrgTxTyp]) and (SV.PControlInfo^.Tox.OmitBuried) Then
                 Begin
                   PS.InitialCond[SVLoop,TypLoop,LayerLoop]:=PT.InitialCond;
                   PT.InitialCond:=0;
                 End;
             End;
         End;

    {Handle Buried Tox Non Multi Layer}
    For TypLoop := FirstToxTyp to LastToxTyp do
      For SVLoop := BuriedRefrDetr to BuriedLabileDetr do
         Begin
           PBD:= SV.GetStatePointer(SvLoop,TypLoop,WaterCol);
           If not (PBD=nil) then
             Begin
               If (TypLoop in [FirstOrgTxTyp..LastOrgTxTyp]) and (SV.PControlInfo^.Tox.OmitBuried) Then
                 Begin
                   PS.InitialCond[SVLoop,TypLoop,WaterCol]:=PBD.InitialCond;
                   PBD.InitialCond:=0;
                 End;
             End;
         End;


  p := PS;
End;

Procedure TAQUATOXSegment.RestoreStudyAfterControlRun(Var P:Pointer);
Var PS:               PSavedRun;
    PT:               TToxics;
    SVLoop:           StateVariables;
    TypLoop:          StV..LastOrgTxTyp;
    LayerLoop:        T_SVLayer;
    SVPtr:            TStateVariable;
    PDRD:             TDissRefrDetr;
    StratLoop:        VerticalSegments;
    PBD:              TBuriedDetr1;
    AltLoop:          Alt_LoadingsType;
    CheckRecord:      Control_Opt_SubRec;
    OmitAlt, RestoreLoad,
    RestoreIC:           Boolean;
    RestoreSV:           Boolean;

Begin
    PS:=P;

    {Reset the study to the correct settings}
    ControlRun:=LastRun;
    LastRun:=PS.TimingHolder;

    PDRD := SV.GetStatePointer(DissRefrDetr,StV,WaterCol);
    PS.InputRecHolder.InitCond := PDRD.InputRecord.InitCond;  //in case of spinup
    PDRD.InputRecord := PS.InputRecHolder; {restore from earlier save, susp&diss detritus conditions}


    For StratLoop:= Epilimnion to Hypolimnion do
      begin
        SV.ControlResults[StratLoop].Destroy;
        SV.ControlResults[stratloop]:=SV.Results[stratloop];
        SV.Results[StratLoop]:=PS.ResultsHolder[StratLoop];
      end;

  For TypLoop := StV to LastOrgTxTyp do
   For SVLoop:=FirstOrgTox to LastBiota do
     Begin
        RestoreSV := (TypLoop>StV) or (SVLoop in [FirstTox..LastTox,Ammonia..Phosphate,Sand..NonCohesives2,FirstDetr..LastDetr]);
                     {Only Modify Toxicants, Nutrients, Sediments, and Detritus}
        If RestoreSV then
          begin
             If (SVLoop in [FirstOrgTox..LastOrgTox]) or (TypLoop in [FirstOrgTxTyp..LastOrgTxTyp])
                  then CheckRecord:=SV.PControlInfo^.Tox else
             If (SVLoop in [Sand..NonCohesives2])
                  then CheckRecord:=SV.PControlInfo^.Sediment else
             If (SVLoop in [Ammonia..Phosphate])
                  then CheckRecord:=SV.PControlInfo^.Nutrient
             else CheckRecord:=SV.PControlInfo^.Detritus;

             If TypLoop in [FirstOrgTxTyp..LastOrgTxTyp]
               then RestoreLoad:=CheckRecord.OmitTox
               else RestoreLoad:=CheckRecord.OmitInflow;

             SVPtr:= SV.GetStatePointer(SvLoop,TypLoop,WaterCol);
             If (SVPtr<>nil) then
               With SVPtr do With LoadsRec do
                 Begin
                  If RestoreLoad then
                    begin
                      ConstLoad := PS.ConstLoad[SvLoop,TypLoop];
                      UseConstant := PS.UseConst[SvLoop,TypLoop];
                    end;

                  If CheckRecord.SetMult then
                    begin
                      MultLdg:=PS.MultLdg[SvLoop,TypLoop];
                      If Has_Alt_Loadings(SVLoop,TypLoop,WaterCol) then
                        For AltLoop := PointSource to NonPointSource do
                            Alt_MultLdg[AltLoop]:=PS.AltMltLdg[SvLoop,TypLoop,AltLoop];
                    end;

                  If TypLoop in [FirstOrgTxTyp..LastOrgTxTyp]
                    then RestoreIC:=CheckRecord.OmitTox
                    else RestoreIC:=CheckRecord.ZeroInitCond;

                  If RestoreIC then InitialCond := PS.InitialCond[SvLoop,TypLoop,WaterCol];

                  {Alternate Loadings}
                  If Has_Alt_Loadings(SVLoop,TypLoop,WaterCol) then
                    For AltLoop := PointSource to NonPointSource do
                    Begin
                      If AltLoop = PointSource then OmitAlt := CheckRecord.OmitPS
                         else If AltLoop = NonPointSource then OmitAlt := CheckRecord.OmitNPS
                                                          else OmitAlt := CheckRecord.OmitDP;
                      If OmitAlt then
                          begin
                            Alt_ConstLoad[AltLoop] := PS.AltLdgCL[SvLoop,TypLoop,AltLoop];
                            Alt_UseConstant[AltLoop] := PS.AltLdgUC[SvLoop,TypLoop,AltLoop];
                          end;
                    End;
                 End;  {with}
          End; {RestoreSV}
     End; {SvLoop}


  For TypLoop := OrgTox1 to OrgTox20 do
   For SVLoop:=PoreWater to SedmLabDetr do
    For LayerLoop := SedLayer1 to LowestLayer do
      Begin
        PT := SV.GetStatePointer(SvLoop,TypLoop,LayerLoop);
           If not (PT=nil) then
             Begin
               If (TypLoop in [FirstOrgTxTyp..LastOrgTxTyp]) and (SV.PControlInfo^.Tox.OmitBuried) Then
                   PT.InitialCond := PS.InitialCond[SVLoop,TypLoop,LayerLoop];
             End;
         End;

    {Handle Buried Tox (non multi layer)}
    For TypLoop := FirstToxTyp to LastToxTyp do
      For SVLoop := BuriedRefrDetr to BuriedLabileDetr do
         Begin
           PBD:= SV.GetStatePointer(SvLoop,TypLoop,WaterCol);
           If not (PBD=nil) then
             Begin
               If (TypLoop in [FirstOrgTxTyp..LastOrgTxTyp]) and (SV.PControlInfo^.Tox.OmitBuried) Then
                   PBD.InitialCond:=PS.InitialCond[SVLoop,TypLoop,WaterCol];
             End;
         End;

 CONTROL_IS_RUNNING:=False;

 Dispose(p); p:=nil;
end;

{-------------------------------------------------------------------}

Procedure TAQUATOXSegment.SensitivityRun;
Var
    ResultsHolder: ResultsType;
    NegTest, UserInterrupt: Boolean;
    StepNum, NumTests, WriteRow, IterationsDone: Integer;
    TextOut      : TextFile;
    NegStr,DateHolder   : String;
    TestVal      : Double;
    PointIndices : Array[1..100] of Integer;
    Dist         : TDistribution;
    DistLinked   : Boolean;
    TEx          : TExcelOutput;
    WS2: _Worksheet;

    {--------------------------------------------------------------}
    Procedure WriteOutputs(RC: TResultsCollection; Row: Integer; Epi: Boolean);
    Var i, WriteCol : Integer;
        WWS: _Worksheet;
        OutVal: Double;
    Begin
      If Epi then WWS := TEx.WS else WWS := WS2;
      WriteCol := 0;
      For i:=1 to PUncertainty^.NumSens do
       If PointIndices[i] > -99 then
         Begin
           Inc(WriteCol);
           OutVal := TDataPoint(TResults(RC.At(RC.Count-1)).DataPoints.At(PointIndices[i])).State;
           WWS.Cells.Item[Row+1,WriteCol+2].Value := OutVal;
           //Write(Textout,', '+FloatToStrF(OutVal,ffgeneral,8,4));
         End;
    End;
    {--------------------------------------------------------------}
    Procedure CreateExcel;
    Var {TCF: TCellFormat; }
        i,j,ColN: Integer;
        PH: TResHeader;

    Begin
      Coinitialize(nil);

      TEx := TExcelOutput.Create(True);
      If Not TEx.OpenFiles then 
        Begin
          TEx := nil;
          Raise EAquatoxError.Create('Error Creating Excel Files for Sensitivity Output');
        End;

      TEx.FileN := ChangeFileExt(Sens_File,'.xls');

      TEx.WS.Name := 'Sensitivity';
      TEx.WS.Cells.Item[1,1].Value := FloatToStrF(PUncertainty^.NominalPercent,ffgeneral,8,2)+'% Sensitivity Test';
      TEx.WS.Cells.Item[1,2].Value := 'Parameter Value';
      TEx.WS.Cells.Item[2,1].Value := 'Base Case';
      TEx.WS.Cells.Item[2,2].Value := 'N A';

      If SV.Results[Hypolimnion].Count>0 then
        Begin
          WS2 := TEx.Wbk.Sheets.Add(EmptyParam,TEx.Wbk.sheets.item[1],1,xlWorkSheet,TEx.LCID) as _Worksheet;
          WS2.Name := 'Hyp Sens.';
          WS2.Cells.Item[1,1].Value := FloatToStrF(PUncertainty^.NominalPercent,ffgeneral,8,2)+'% Sensitivity Test';
          WS2.Cells.Item[1,2].Value := 'Parameter Value';
          WS2.Cells.Item[2,1].Value := 'Base Case (Hyp)';
          WS2.Cells.Item[2,2].Value := 'N A';
        End;

      Write(TextOut,'Outputs Tracked --->');
      ColN := 0;
      For i:=1 to PUncertainty^.NumSens do
         Begin
           PointIndices[i] := -99;
           For j := 0 to SV.Results[Epilimnion].Headers.Count-1 do
             Begin
               PH := SV.Results[Epilimnion].Headers.At(j);
               If PH.SortIndex = PUncertainty^.SensTrack[i] then
                 Begin
                   Inc(ColN);
                   TEx.WS.Cells.Item[1,ColN+2].Value := PH.ListStr(False);
                   Write(TextOut,', "',PH.ListStr(False)+'"');
                   TEx.WS.Cells.Item[3,ColN+2].Value := '''';
                   If SV.Results[Hypolimnion].Count>0 then
                     Begin
                       WS2.Cells.Item[1,ColN+2].Value := PH.ListStr(False);
                       WS2.Cells.Item[3,ColN+2].Value := '''';
                     End;
                   PointIndices[i] := PH.PointIndex;
                 End;
             End;
         End;

       Writeln(Textout);
       WriteOutputs(SV.Results[Epilimnion],1,True);
       Writeln(Textout);
       WriteRow := 2;
       TEx.WS.Cells.Item[WriteRow+1,1].Value := 'Test Parameter';

       If SV.Results[Hypolimnion].Count>0 then
         Begin
           WriteOutputs(SV.Results[Hypolimnion],1,False);
           WS2.Cells.Item[WriteRow+1,1].Value := 'Test Parameter';
         End;

    End;
   {------------------------------------------------------------------}
    Procedure InitTextResults;
    Var FileN: String;
    Begin
      FileN := ChangeFileExt(Sens_File,'.txt');

      ASSIGNFILE(TextOut,FileN);
      REWRITE(TextOut);
      Writeln(Textout,'---------------------------------------------------------');
      Writeln(TextOut);
      Writeln(TextOut,'        Sensitivity Test for Model "',FileName,'"');
      Writeln(TextOut,'        -- ',StudyName,' --');
      Writeln(TextOut);
      Writeln(Textout,'---------------------------------------------------------');
      DateTimeToString(DateHolder,'mm-d-y t',Now);
      Writeln(TextOut,'        Run Starts at '+ DateHolder);
      Writeln(TextOut,'---------------------------------------------------------');
      Writeln(TextOut);
      Writeln(TextOut);
    End;
   {------------------------------------------------------------------}
   Procedure CountNumTests;
   var i: Integer;
   Begin
     NumTests := 0;
     With SV do
       For i := 0 to Distributions.Count - 1 do
         If TDistribution(Distributions.At(i)).UseForSens then NumTests := NumTests + 2;
   End;
   {------------------------------------------------------------------}
   Procedure SavePointEsts;
     {The below nested loop fills the VariableDraws array and saves
   the point estimates so they can be restored after the Sensitivity run}
   Var DistribLoop: Integer;
   Begin
     With SV.Distributions do
      For DistribLoop:=0 to Count-1 do
       With TDistribution(At(DistribLoop)) do
       If UseForSens then PointEstimate:=SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^;
   End;
   {------------------------------------------------------------------}
   Procedure RestorePointEsts;
   {Load the point estimate values back into the simulation}
   Var DistribLoop: Integer;
   Begin
     With SV.Distributions do
      For DistribLoop:=0 to Count-1 do
       With TDistribution(At(DistribLoop)) do
       If UseForSens then SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^ := PointEstimate;
   End;
   {------------------------------------------------------------------}
   Procedure Write_Sensitivity_Results;
   Var SegLoop: verticalsegments;
       LinkSTr: String;
       WWS: _Worksheet;
    Begin
      Inc(WriteRow);
      For Segloop:=Epilimnion to Hypolimnion do
       Begin
        If SV.Results[SegLoop]=nil then break;
        If SV.Results[SegLoop].Count<=1 then break;
        If SegLoop = Epilimnion then WWS := TEx.WS else WWS := WS2;

        WWS.Cells.Item[WriteRow+1,2].Value := TestVal;

        If SegLoop = Hypolimnion then NegStr := NegStr + ' (Hyp)';

        If DistLinked then LinkStr := ' * Linked *' else LinkStr := '';
        WWS.Cells.Item[WriteRow+1,1].Value := Dist.Name + LinkStr + ' '+NegStr;
        Write(TExtOut,'"'+Dist.Name + LinkStr + ' '+NegStr+'"');
        Write(TExtOut,' Modified to Value '+FloatToStrF(TestVal,ffgeneral,8,4)+'       > ');

        WriteOutputs(SV.Results[SegLoop],WriteRow,SegLoop=Epilimnion);
       End; {SegLoop}

      TEx.Save;  {Save Excel file after each iteration}

      {Update Text output}
      IterationsDone:=StepNum;
      Writeln(Textout);
      Writeln(Textout,'Was Testing '+Dist.Name+ ' At Value '+FloatToStrF(TestVal,ffgeneral,8,4));

      Writeln(Textout,'Iteration '+IntToStr(StepNum)+' Completed.  Excel File Updated.');
      Writeln(Textout,'---------------------------------------------------------');

    End;      {Write_Sensitivity_Results}
   {------------------------------------------------------------------}
   Function IsLinkedPlant: Boolean;
   Var PP: TPlant;
   Begin
     IsLinkedPlant := False;
     If (Dist.SVID.nstate in [FirstPlant..LastPlant]) and (Dist.SVID.SVType=STV) then
       Begin
         PP := SV.GetStatePointer(Dist.SVID.NState,Dist.SVID.SVType,WaterCol);
         IF PP = nil then exit;
         IsLinkedPlant := PP.IsLinkedPhyto;
         If Not Result then
           If ((PP.IsPeriphyton) and
               (PP.PSameSpecies^ <> NullStateVar )) then
                  IsLinkedPlant := SV.GetStatePointer(PP.PSameSpecies^,StV,WaterCol) <> nil
       End;
   End;
   {------------------------------------------------------------------}
   Procedure AdjustLinkedPlants(Restore: Boolean);
   Var PP: TPlant;

       Procedure SetParam(plantstate: allvariables);
       Var VaryAmount,TVL: Double;
           SVID2: SV_ID;
           Index: Integer;
           LinkedDist: TDistribution;
       Begin
         SVID2.NState := PlantState;
         SVID2.SVType := StV;
         SVID2.Layer  := WaterCol;

         With Dist do
          If (not SV.Distributions.FindDistrib(DistNum,SVID2,ToxRec,Index))
           then Exit;

         LinkedDist:=SV.Distributions.At(Index);

         If Restore
           then
             Begin
               With LinkedDist do SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^ := PointEstimate;
             End {restore}
           else
             Begin
               LinkedDist.PointEstimate:=SV.Return_Var_Pointer(LinkedDist.DistNum,SVID2,LinkedDist.ToxRec)^;
               VaryAmount := (PUncertainty^.NominalPercent/100) * LinkedDist.PointEstimate;
               If NegTest then TVL := LinkedDist.PointEstimate - VaryAmount
                          else TVL := LinkedDist.PointEstimate + VaryAmount;
               With LinkedDist do SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^ := TVL;
               Writeln(Textout,'( -- linked plant '+ LinkedDist.Name+ ' Modified to Value '+FloatToStrF(TVL,ffgeneral,8,4)+ '-- )');
             End; {vary}

       End;

   Var ploop: AllVariables;
       pperi: TPlant;
   Begin
     PP := SV.GetStatePointer(Dist.SVID.NState,Dist.SVID.SVType,WaterCol);
     If PP.IsLinkedPhyto
       then For ploop := FirstAlgae to LastAlgae do
         Begin  {there could be multiple periphyton compartments linked to one phytoplantkon}
           PPeri := SV.GetStatePointer(PLoop,Stv,WaterCol);
           If PPeri <> nil then
             If (PPeri.IsPeriphyton) and
               (PPeri.PSameSpecies^ = Dist.SVID.NState)
                  then SetParam(ploop)
         End
       else {periphyton}
         SetParam(PP.PSamespecies^)

   End;
   {------------------------------------------------------------------}

Var VaryAmount, StoreStep: Double;
    ErrorString: String;
    IterationHolder: String;
    i: Integer;
    SegLoop: VerticalSegments;

Begin     {SensitivityRun}
  If (Not SV.PRateInfo^.WriteToMemory) then 
     PSetup^.SaveBRates := False;
     
  IterationsDone:=0;
  UserInterrupt:=False;

  DistLinked := False;
  TRY

  ResultsHolder:=SV.Results;
  
  InitTextResults;
  CreateExcel;
  CountNumTests;

  For SegLoop := Epilimnion to Hypolimnion do
    SV.Results[SegLoop]:=TResultsCollection.init;

  SavePointEsts;

  StepNum := 0;

  With SV do
   For i := 0 to Distributions.Count - 1 do
    If TDistribution(Distributions.At(i)).UseForSens then
     For NegTest := False to True do
      Begin
        {Update Progress Dialog}
        Inc(StepNum);
        With PUncertainty^ do
          If (StepNum < StartIter) or (StepNum>EndIter) then continue;  {if split into multi-processors}
        DateTimeToString(DateHolder,'mm-d-y t',Now);

        IterationHolder:='Iteration '+IntToStr(StepNum)+ ' of '+IntToStr(NumTests) + ' Starts at '+DateHolder;
        SV.ProgData.UncertStatLabel := IterationHolder;
        Writeln(TextOut,IterationHolder);
        Writeln(Textout);

        Dist := TDistribution(Distributions.At(i));
        If NegTest then NegStr := '-' else NegStr := '+';

        VaryAmount := (PUncertainty^.NominalPercent/100) * Dist.PointEstimate;
        If NegTest then TestVal := Dist.PointEstimate - VaryAmount
                   else TestVal := Dist.PointEstimate + VaryAmount;

        With Dist do
         SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^ := TestVal;

        If PUncertainty^.LinkPeriPhyto then
          Begin
            DistLinked := IsLinkedPlant;
            If DistLinked then AdjustLinkedPlants(False);
          End;

       {Go through run Procedure for each iteration}
       If not SetupforRun then UserInterrupt:=True;

       If not UserInterrupt then
         Begin
          AllSVs := SV;
          SV.PAllSVsColl := @AllSVs;
          StoreStep := PSetup^.StoreStepSize;
          If not PSetup^.StepSizeInDays then StoreStep := StoreStep / 24;
          Integrate(PSetup^.FirstDay,PSetup^.LastDay,PSetup^.RelativeError,MINIMUM_STEPSIZE,StoreStep);
          {Integrate Parameters:  x1, x2, eps, h1, hmin, dxsav: double );  }

          If Stratified then SV.Overturn(true);  {Returns vital info to SV}

          With Dist do SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^ := PointEstimate;
          {Restore original value to parameter}
          If DistLinked then AdjustLinkedPlants(True);
         End;

       If (SV.ProgData.ProgCancel) or UserInterrupt then
           begin
              UserInterrupt:=True;
              DateTimeToString(DateHolder,'mm-d-y t',Now);
              Writeln(TextOut,'Run Terminated by user at '+ DateHolder );
              Break; {exit loop}
           end
           else
             Try
               Write_Sensitivity_Results;
             Except
               DateTimeToString(DateHolder,'mm-d-y t',Now);
               TRY
                 Writeln(TextOut,'Attempting to Save Excel file at '+TEX.FileN );
                 TEx.SaveAndClose;
               Finally
                 Writeln(TextOut,'Run Terminated:  Error writing results to Excel at '+ DateHolder );
               End;
               SV.ProgData.ProgCancel := True;

               Raise;
             End;

        DistLinked := False;
      End;  {Nested For Do Loops (i, negtest)}

    If Not UserInterrupt then
      begin
        DateTimeToString(DateHolder,'mm-d-y t',Now);
        Writeln(TextOut,'Run Successfully Completed At '+ DateHolder );
        Writeln(TextOut,'---------------------------------------------------------');
      end;

  Except

      ErrorString:=Exception(ExceptObject).Message;
      SV.ProgData.ProgCancel := True;

      SV.PMessageStr^ := 'Run-Time Error During Sensitivity Iteration.';
      SV.PMessageErr^ := True;
      SV.TSMessage;
      SV.PMessageStr^ := ErrorString;
      SV.TSMessage;

      DateTimeToString(DateHolder,'mm-d-y t',Now);
        Try
          Writeln(TextOut,'Run Terminated at '+ DateHolder );
          Writeln(TextOut,'    Due to '+ErrorString);
        Except
          SV.PMessageStr^ := 'No Data Written';
          SV.TSMessage;
          SV.ProgData.ProgCancel := True;
          SV.UpdateProg;
        End;

      SV.UpdateProg;
      If DistLinked then AdjustLinkedPlants(True);

  End; {Except}

  CloseFile(TextOut);

  Try
    If TEx <> nil then
      Begin
        TEx.WS.Range['A1', 'A1'].EntireColumn.AutoFit;
        If SV.Results[Hypolimnion].Count>0 then
          WS2.Range['A1', 'A1'].EntireColumn.AutoFit;

        TEx.SaveAndClose;
      End;

  Finally

    SV.Results:=ResultsHolder;
    RestorePointEsts;

  End;

End;   {SensitivityRun}

{-------------------------------------------------------------------}

Procedure TAQUATOXSegment.LatinHypercubeRun;
Type UResultsTypes = (MinRes,MaxRes,StdRes,MeanRes);
     DeclineArray  = Array[FirstBiota..LastBiota] of Double;

Var DistribLoop  : Integer;
    ResLoop      : UResultsTypes;
    Dists        : TDistributionList;
    Dist         : TDistribution;
    NumStepsLoop : Integer;
    Declines     : Array of DeclineArray;
    DrawValue    : Double;
    ResultsHolder: ResultsType;
    SegLoop      : VerticalSegments;
    ErrorString  : ShortString;
    IterRes      : TResultsCollection;
    UncertRes    : Array[MinRes..MeanRes] of ResultsType;
    TextOut      : TextFile;
    DateHolder,IterationHolder  : String;
    UserInterrupt: Boolean;
    IterationsDone: Integer;
    ExportTable   : TTable;
    IsDBF         : Boolean;
   {------------------------------------------------------------------}
    Function RandomInt(Top: Integer): Integer;
    {Returns a random integer from 1..Top, using Randnum.Pas}
    Begin
      RandomInt:=Trunc(RandUniform*Top)+1;
    End;

    Procedure Accumulate_Uncertainty_Results;
    Var Segloop    : VerticalSegments;
        DateLoop,i : Integer;
        ResLp      : UResultsTypes;
        Results1   : TResults;
        UResults1  : Array[MinRes..MeanRes] of TResults;
        IterRes1   : TResults;
        DataPoints1: TDataPoint;
        UDataPts1  : Array [MinRes..MeanRes] of TDataPoint;
        IterData1  : TDataPoint;
        IterationValue,UncertValue: Double;
        StartVal, EndVal: Double;
        LongListIndex: Integer;
        PH          : TResHeader;
        OrgLoop     : AllVariables;
        {------------------------TOP-CREATEDISTS--------------------------}
        Procedure CreateDists;
        Var DL,j       : Integer;
            Res        : UResultsTypes;
            HypIndex   : Integer;
            WriteZeros : Boolean;
            Ph         : TResHeader;
            PntIndx    : Integer;
        Begin
          For Res:=MinRes to MeanRes do
             UncertRes[Res,SegLoop] := TResultsCollection.init;

          If SegLoop=Hypolimnion then IterRes := TResultsCollection.init;

          For DL:=0 to SV.Results[Epilimnion].Count-1 do
          Begin
            Results1:=SV.Results[Epilimnion].At(DL);

            WriteZeros:=False;
            If SegLoop=Hypolimnion then
              begin
                HypIndex := SV.Results[Hypolimnion].GetResIndex(Results1.Date,False);
                If (HypIndex<=-1) then WriteZeros:=True
                                  else Results1:=SV.Results[Hypolimnion].At(HypIndex);
              end;

            For Res:=MinRes to MeanRes do
                UResults1[Res]:=TResults.init(Results1.Date,True);

            If SegLoop=Hypolimnion then IterRes1:=TResults.init(Results1.Date,True);

            For j:=0 to Results1.DataPoints.Count-1 do   {For each datapoint}
              Begin
                DataPoints1:=Results1.DataPoints.At(j);
                With DataPoints1 do For Res := MinRes to MeanRes do
                  Begin
                    PntIndx := UResults1[Res].DataPoints.Count;
                    PH := SV.Results[Epilimnion].Headers.At(j);
                    If WriteZeros then UDataPts1[Res]:=TDataPoint.init(PH.AllState,PH.SVType,PH.Layer,0,PH.PPB,PH.ToxVar,PH.RateVar,PH.BAFVar,0,UncertRes[Res,SegLoop],SV,False,PntIndx,'') else
                    If Res=StDRes then UDataPts1[Res]:=TDataPoint.init(PH.AllState,PH.SVType,PH.Layer,State*State,PH.PPB,PH.ToxVar,PH.RateVar,PH.BAFVar,0,UncertRes[Res,SegLoop],SV,False,PntIndx,'')
                                  else UDataPts1[Res]:=TDataPoint.init(PH.AllState,PH.SVType,PH.Layer,State,PH.PPB,PH.ToxVar,PH.RateVar,PH.BAFVar,0,UncertRes[Res,SegLoop],SV,False,PntIndx,'');
                    UResults1[Res].DataPoints.Insert(UDataPts1[Res]);
                  End;
               End; {j Loop}

            If SegLoop=Hypolimnion then
              begin
                PntIndx := IterRes1.DataPoints.Count;
                If WriteZeros then IterData1:=TDataPoint.init(NullStateVar,STV,WaterCol,0,False,False,False,0,0,IterRes,SV,False,PntIndx,'')
                              else IterData1:=TDataPoint.init(NullStateVar,STV,WaterCol,1,False,False,False,0,0,IterRes,SV,False,PntIndx,'');
                IterRes1.DataPoints.Insert(IterData1);
                IterRes.Insert(IterRes1);
              end;

            For Res:=MinRes to MeanRes do
              UncertRes[Res,SegLoop].Insert(UResults1[Res]);

          End;  {DL loop}
        End;
        {---------------------BOTTOM-CREATEDISTS--------------------------}

    Begin    {Accumulate_Uncertainty_Results}
      If PUncertainty^.SaveToCSV then ExportResults1(nil,false,nil,self, Unc_Dir+Unc_File+IntToStr(NumStepsLoop)+'.CSV');

      For Segloop:=Epilimnion to Hypolimnion do
       Begin
        If SV.Results[SegLoop]=nil then break;
        If SV.Results[SegLoop].Count<=1 then break;

        If NumStepsLoop=1 then CreateDists else
        Begin
          For DateLoop:=0 to SV.Results[SegLoop].Count-1 do
          Begin
            Results1:=SV.Results[SegLoop].At(DateLoop);

            If (SegLoop=Hypolimnion) then
              Begin
                LongListIndex:=SV.Results[Epilimnion].GetResIndex(Results1.Date,False);
                If LongListIndex<0 then Raise EAQUATOXError.Create('Hypolimnion Segment Algorithm Error.');
                For ResLp:=MinRes to MeanRes do
                   UResults1[ResLp]:=UncertRes[ResLp,SegLoop].At(LongListIndex);

                {Increment Iteration Counter}
                TDataPoint(TResults(IterRes.At(LongListIndex)).DataPoints.At(0)).State :=
                  TDataPoint(TResults(IterRes.At(LongListIndex)).DataPoints.At(0)).State + 1;
                For ResLp:=MinRes to MeanRes do
                   UResults1[ResLp]:=UncertRes[ResLp,SegLoop].At(LongListIndex);
              End
            else {SegLoop=Epi}
              For ResLp:=MinRes to MeanRes do
                UResults1[ResLp]:=UncertRes[ResLp,SegLoop].At(DateLoop);

            For i:=0 to Results1.DataPoints.Count-1 do   {For every datapoint}
              Begin
                DataPoints1:=Results1.DataPoints.At(i);
                IterationValue:=DataPoints1.State;
                For ResLp:=MinRes to MeanRes do
                begin
                  UDataPts1[ResLp]:=Uresults1[ResLp].DataPoints.At(i);
                  UncertValue:=UDataPts1[ResLp].State;
                  Case ResLp of
                    MeanRes: UDataPts1[ResLp].State   := UncertValue+IterationValue;
                             {Sum data for now}
                    MinRes : If IterationValue<UncertValue then
                               UDataPts1[ResLp].State := IterationValue;
                    MaxRes : If IterationValue>UncertValue then
                               UDataPts1[ResLp].State := IterationValue;
                    StdRes : UDataPts1[ResLp].State   := UncertValue + (IterationValue*IterationValue);
                            {Sum of Squares for now}
                    end; {Case}
                end; {ResLp}
             end; {i loop}

          End; {dateloop}
        End; {else}

      End; {SegLoop}

      {Update Percent Decline for Organisms}
      SetLength(Declines,NumStepsLoop);
      For OrgLoop := FirstBiota to LastBiota do
        Declines[NumStepsLoop-1,OrgLoop] := -99999;

      DateLoop := SV.Results[Epilimnion].Count-1;
      Results1 := SV.Results[Epilimnion].At(DateLoop);
      For i := 0 to SV.Results[Epilimnion].Headers.Count-1 do
        Begin
          PH:= SV.Results[Epilimnion].Headers.At(i);
          With PH do
            If (AllState in [FirstBiota..LastBiota]) and
               (SVType = STV) and
               Not (PPB or ToxVar or (BAFVar>0))
            then
              Begin
                Results1:=SV.Results[Epilimnion].At(0);
                DataPoints1:=Results1.DataPoints.At(PointIndex);
                StartVal := DataPoints1.State;
                Results1:=SV.Results[Epilimnion].At(DateLoop);
                DataPoints1:=Results1.DataPoints.At(PointIndex);
                EndVal   := DataPoints1.State;
                If StartVal>0
                  then Declines[NumStepsLoop-1,AllState] := (1 - (EndVal / StartVal)) * 100
                  else Declines[NumStepsLoop-1,AllState] := 0;
              End;
        End;

      {Update Text output}
      IterationsDone:=NumStepsLoop;
      Writeln(Textout);
      Writeln(Textout,'Iteration '+IntToStr(NumStepsLoop)+' Completed.  Database Updated.');
      Writeln(Textout,'---------------------------------------------------------');

    End;      {Accumulate_Uncertainty_Results}
   {------------------------------------------------------------------}
    Procedure InitTextResults;
    Var FileN: String;
    Begin
      FileN := Unc_Dir+Unc_File+'.TXT';
      CleanDashes(FileN);

      ASSIGNFILE(TextOut,FileN);
      REWRITE(TextOut);
      Writeln(Textout,'---------------------------------------------------------');
      Writeln(TextOut);
      Writeln(TextOut,'        Uncertainty Run for Model "',FileName,'"');
      Writeln(TextOut,'        -- ',StudyName,' --');
      Writeln(TextOut);
      Writeln(Textout,'---------------------------------------------------------');
      DateTimeToString(DateHolder,'mm-d-y t',Now);
      Writeln(TextOut,'        Run Starts at '+ DateHolder);
      Writeln(TextOut,'---------------------------------------------------------');
      Writeln(TextOut);
      Writeln(TextOut,'        ** DISTRIBUTIONS SUMMARY **');
      Writeln(TextOut);
    End;
   {--------------------TOP-SUMMARIZEDIST----------------------------}
    Procedure SummarizeDist;
    {Summarizes the distribution for the text output}
    Var ParmLoop: Integer;
        ParmInfo: Array[0..4] of String;
    Begin
    With Dist do
    Begin
      Writeln(TextOut,Name,':   Point Estimate:'+FloatToStrF(PointEstimate,ffGeneral,4,4));
      Case DistType of
        Triangular: begin
                      ParmInfo[0]:='Triangular';
                      ParmInfo[1]:='Most Likely';
                      ParmInfo[2]:='Minimum';
                      ParmInfo[3]:='Maximum';
                      ParmInfo[4]:='<unused>';
                    end;
        Normal    : begin
                      ParmInfo[0]:='Normal';
                      ParmInfo[1]:='Mean';
                      ParmInfo[2]:='Std. Deviation';
                      ParmInfo[3]:='<unused>';
                      ParmInfo[4]:='<unused>';
                    end;
        LogNormal : begin
                      ParmInfo[0]:='LogNormal';
                      ParmInfo[1]:='Mean';
                      ParmInfo[2]:='Std. Deviation';
                      ParmInfo[3]:='<unused>';
                      ParmInfo[4]:='<unused>';
                    end;
        Uniform   : begin
                      ParmInfo[0]:='Uniform';
                      ParmInfo[1]:='Minimum';
                      ParmInfo[2]:='Maximum';
                      ParmInfo[3]:='<unused>';
                      ParmInfo[4]:='<unused>';
                   end;
      End; {case}
      Write(TextOut,'  '+ParmInfo[0]+' : ');
      For ParmLoop:=1 to 4 do
         If ParmInfo[ParmLoop] <> '<unused>' then
            Write(TextOut,ParmInfo[ParmLoop]+'='+FloatToStrF(Parm[ParmLoop],ffGeneral,4,4)+'; ');
      Writeln(TextOut);
      Writeln(TextOut);
    End; {with}
    End; {Proc}
   {------------------------------------------------------------------}
    Procedure WriteResultsToDBase;
   {------------------------------------------------------------------}
       Procedure PostProcessUncertResults;
       { calculate stdev and mean from sum and sumsquare data }
       Var Segloop    : VerticalSegments;
           DateLoop,i : Integer;
           ResLp      : UResultsTypes;
           UResults1  : Array[StdRes..MeanRes] of TResults;
           UDataPts1  : Array [StdRes..MeanRes] of TDataPoint;
           Sum,SumSquare: Double;
           InSqrt     : Double;
           n          : Integer;
       Begin
        For Segloop:=Epilimnion to Hypolimnion do
         Begin

         { Exit routine and reset Directories if no results avail to write }
          If SV.Results[SegLoop]=nil then exit;
          If SV.Results[SegLoop].Count<=1 then exit;

          { Loop through dates and write results to DBase }
          For DateLoop:=0 to SV.Results[Epilimnion].Count-1 do
          Begin
            For ResLp:=StdRes to MeanRes do
              UResults1[ResLp]:=UncertRes[ResLp,SegLoop].At(DateLoop);
            For i:=0 to UResults1[StdRes].DataPoints.Count-1 do   {For every datapoint}
              begin
                For ResLp:=StdRes to MeanRes do
                  UDataPts1[ResLp]:=Uresults1[ResLp].DataPoints.At(i);

                Sum      :=UdataPts1[MeanRes].State;
                SumSquare:=UdataPts1[StdRes].State;

                If SegLoop=Epilimnion
                   then n:=IterationsDone
                   else n:=Trunc(TDataPoint(TResults(IterRes.At(DateLoop)).DataPoints.At(0)).State);

                If n>0 then UDataPts1[MeanRes].State:=Sum/n;
                {The standard deviation is calculated using the "nonbiased" or "n-1" method.}
                If n>1 then InSqrt:= ((n*SumSquare)-(Sum*Sum)) / (n*(n-1))
                       else InSqrt:=0;
                If InSqrt>0 then UDataPts1[StdRes].State:=Sqrt(InSqrt)
                            else UDataPts1[StdRes].State:=0;
              end; {i loop}
          End; {Dateloop}
         End; {SegLoop}
       End; {PostProcessUncertResults}

   {----------------- Procedure WriteResultsToDBase  ---------------}
   Var OuterLoop, Loop: Integer;
       PointsColl: TResults;
       UncertColl: Array[MinRes..MeanRes] of TResults;
       RsLoop     : UResultsTypes;
       Num_to_Write: Integer;
       SegLoop   : VerticalSegments;
       WritePoints: Boolean;
       WriteDeterm: Boolean;
       DetermIndex, Prog: Integer;
       NumIteratns: Double;
       PHd        : TResHeader;
       DBFQuery   : TQuery;
       LastString : String;
       IterFieldInc, TopFileLoop     : Integer;
       FileLoop, NumFields, TopIndex : Integer;
       CurrentHeader, BottomHeader   : Integer;
       MaxFields                     : Integer;

          {-------------------------------------------------------------------------------}
          Procedure SetupOutputDatabase(Num: Integer);
          Begin
           With ExportTable do
           Begin
             DatabaseName :=Unc_Dir;
             TableName    :=Unc_File+Unc_Ext;
             If Num>1 then TableName := Unc_File+InttoStr(Num)+Unc_Ext;

             If SegLoop=Hypolimnion then TableName:='Hyp_'+TableName;

             If      Unc_Ext = '.dbf' then TableType:=ttDBase
             Else If Unc_Ext = '.prn' then TableType:=ttascii
                                      else TableType:=ttParadox;

             {Clear Table Structure}
             Active:=False;
             FieldDefs.Clear;
             IndexDefs.Clear;
             FieldDefs.Add('Date',ftDate,0,False);
             If SegLoop=Hypolimnion then FieldDefs.Add('Iterations',ftFloat,0,False);

             If IsDBF then
                 Begin
                   CreateTable;
                   DBFQuery := TQuery.Create(nil);
                   with DBFQuery do
                     begin
                       DatabaseName := Unc_Dir;
                       Close;
                       with SQL do
                         begin
                           Clear;
                           Add('ALTER TABLE "'+TableName+'"');
                         end; {with SQL}
                     end; {with DBFQuery}
                 End;
            End; {with}
          End;
          {---------------------------------------------------------}
          Procedure MakeUncertEntry(P: TResHeader);
          Var Name,DName: String;
              i: Integer;
          Begin

            Name:=P.ListStr(Unc_Ext='.dbf');
{            Name:=P.HeadStr; }

            DName:=Name;
             {If Name<>'Undisplayed' then }
               For i:=1 to 5 do
                 begin
                   If (Unc_Ext = '.dbf') and  (Pos('Tox.',Name)=1)
                       Then Delete(Name,2,3);  {Pare down name for Dbase Output}
                   If Unc_Ext = '.dbf'
                     THEN
                       Case i of
                         1: DName:='L'+Name; 2: DName:='M'+Name; 3: DName:='S'+Name;
                         4: DName:='H'+Name; 5: DName:='D'+Name;
                       End {Case}
                     ELSE
                       Case i of
                         1: DName:='Min '+Name; 2: DName:='Mean '+Name; 3: DName:='Std '+Name;
                         4: DName:='Max '+Name; 5: DName:='Det '+Name;
                       End; {Case}

                   If IsDBF
                     then
                       Begin
                         ProcessDBFName(DName, @DBFQuery.SQL);
                         DBFQuery.SQL.Add('ADD "'+ExportTable.TableName+'"."'+DName+'" NUMERIC(20,15),');
                       End
                     else ExportTable.FieldDefs.Add(DName,ftFloat,0,False);
                 end; {i loop}
           End; {Proc}
          {---------------------------------------------------------}
          Procedure UpdateExportTable(FieldIndex,DataIndex: Integer);
          {Export all five types of data for each datapoint}
          Var FI: Integer;
              Determ: Double;
              {---------------------------------------------------------}
              Procedure Postit(Val: Double);
              Begin
                If FI > ExportTable.FieldCount-1 then
                  Raise EAQUATOXError.Create('Field Indices Exceeded for table '+ExportTable.TableName);

                ExportTable.Fields[FI].AsFloat:= Val;

              End;
              {---------------------------------------------------------}

          Begin
            FI:=FieldIndex;
            Postit(TDataPoint(UncertColl[MinRes].DataPoints.At(DataIndex)).State);
            Inc(FI);
            Postit(TDataPoint(UncertColl[MeanRes].DataPoints.At(DataIndex)).State);
            Inc(FI);
            Postit(TDataPoint(UncertColl[StdRes].DataPoints.At(DataIndex)).State);
            Inc(FI);
            Postit(TDataPoint(UncertColl[MaxRes].DataPoints.At(DataIndex)).State);
            Inc(FI);
            If WriteDeterm then Determ:=TDataPoint(PointsColl.DataPoints.At(DataIndex)).State
                           else Determ:=0;
            Postit(Determ);
          End;
          {---------------------------------------------------------}

       Begin
         IsDBF := (Unc_Ext = '.dbf');
         If IsDBF then MAXFIELDS :=40
                  else MAXFIELDS :=50;

         SV.ProgData.ProgCancel := False;

         NumIteratns:=0;
         If IterationsDone>0 then PostProcessUncertResults;

         SV.ProgData.UncertStatLabel := 'Writing Output Database(s)';
         SV.ProgData.ProgInt :=0;
         SV.ProgData.DateStr :='';

         SV.UpdateProg;

         FOR SegLoop:=Epilimnion TO Hypolimnion DO
          IF (SV.Results[SegLoop].Count>0) then
           BEGIN
            BottomHeader := 0;
            If SegLoop=Epilimnion then SV.ProgData.DateStr :='Epilimnion'
                                  else SV.ProgData.DateStr :='Hypolimnion';
            SV.UpdateProg;

            NumFields:=SV.Results[SegLoop].Headers.Count;

            TopFileLoop := (((NumFields-1) div (MAXFIELDS-1))+1);
            For FileLoop:=1 to TopFileLoop do
              Begin
                SetupOutputDatabase(FileLoop);

                { Calculate Top Field for this File }
                If NumFields < (FileLoop*(MAXFIELDS-1))
                   then TopIndex :=(NumFields mod (MAXFIELDS-1))
                   else TopIndex := MAXFIELDS-1;

                { Create Appropriate Fields to Export }
                CurrentHeader:=BottomHeader-1;
                For Loop := 1 to TopIndex do
                  Begin
                    Inc(CurrentHeader);
                    PHd := SV.Results[SegLoop].Headers.At(CurrentHeader);
                    MakeUncertEntry(PHd);
                  End;

                If IsDBF then With DBFQuery.SQL do
                     Begin
                       LastString := Strings[Count-1]; {trim comma after last entry}
                       SetLength(LastString,Length(LastString)-1);
                       Strings[Count-1] := LastString;
                       DBFQuery.ExecSQL;   {add fields with appropriate scale}
                       DBFQuery.Free;
                     End
                   else ExportTable.CreateTable;

                ExportTable.Active:=True;

                {Write the datapoints into the Uncert Table}
                Num_to_Write := SV.Results[SegLoop].Count-1;

                For OuterLoop:=0 to Num_to_Write do
                 Begin
                  WritePoints:=True;
                  If (SegLoop=Hypolimnion) then
                    Begin
                      NumIteratns:=(TDataPoint(TResults(IterRes.At(OuterLoop)).DataPoints.At(0)).State);
                      if NumIteratns<1 then WritePoints:=False;
                    End;

                  If WritePoints then
                    Begin
                      WriteDeterm:=True;
                      DetermIndex:=OuterLoop;
                      If SegLoop=Hypolimnion then
                        DetermIndex := SV.Results[SegLoop].GetResIndex(TResults(SV.Results[Epilimnion].At(OuterLoop)).Date,False);
                      If DetermIndex<0 then WriteDeterm:=False;
                      If WriteDeterm then PointsColl:=SV.Results[SegLoop].At(DetermIndex);

                      ExportTable.Append;
                      ExportTable.Fields[0].AsDateTime:=TResults(SV.Results[SegLoop].At(OuterLoop)).Date;
                      If SegLoop=Hypolimnion then ExportTable.Fields[1].AsFloat:=NumIteratns;

                      If SegLoop=Hypolimnion then IterFieldInc:=1
                                             Else IterFieldInc:=0;

                      For RsLoop:=MinRes to MeanRes do
                         UncertColl[RsLoop]:= UncertRes[RsLoop,SegLoop].At(OuterLoop);

                      CurrentHeader:=BottomHeader-1;
                      For Loop := 1 to TopIndex do
                        Begin
                          Inc(CurrentHeader);
                          PHd := SV.Results[SegLoop].Headers.At(CurrentHeader);
                          UpdateExportTable(((Loop-1)*5)+1+IterFieldInc,PHd.PointIndex);
                        End;  {For Loop}

                      ExportTable.Post;
                    End; {If WritePoints}

                  Prog := Round ((((FileLoop-1)*Num_To_Write) + OuterLoop) / (Num_To_Write * TopFileLoop) * 100);
                  If Prog <> SV.ProgData.ProgInt then
                    Begin
                      SV.ProgData.ProgInt := Prog;
                      SV.UpdateProg;

                      If SV.ProgData.ProgCancel then
                        Begin
                          ExportTable.Active:=False;
                          ExportTable.Close;
                          exit;
                        End; {user interrupt}
                    End;  {If Round}

                End; {OuterLoop}

              ExportTable.Active:=False;
              ExportTable.Close;

              BottomHeader:=CurrentHeader+1;  {For next File}

           End; {FileLoop}

         END; {For SegLoop:=Epilimnion to Hypolimnion}
        SV.ProgData.DateStr:='';
       End;  {Procedure WriteResultsToDBase}
   {------------------------------------------------------------------}
   Procedure OpenExportTable;
   {Ensures Access To Table Is Error Free}
   Var SegLoop: VerticalSegments;
   Begin
    FOR SegLoop:=Epilimnion TO Hypolimnion DO
      IF (SV.Results[SegLoop].Count>0) then
       With ExportTable do
        Begin
          Active:=False;
          DatabaseName:=Unc_Dir;
          TableName:=Unc_File+Unc_Ext;
          If SegLoop=Hypolimnion then TableName:='Hyp_'+TableName;

          If      Unc_Ext = '.dbf' then TableType:=ttDBase
          Else If Unc_Ext = '.prn' then TableType:=ttascii
          Else                          TableType:=ttParadox;

          {Clear Table Structure}
          Active:=False;
          FieldDefs.Clear;
          IndexDefs.Clear;
          FieldDefs.Add('Date',ftDate,0,False);

          CreateTable;
          Active:=False;

      end; {with ExportTable}
  End; {OpenExportTable}

  {----------------------------------------------------------------}
  Procedure Init_ConstLoad;
  {Initializes the program to ready the copying of the constload
   distribution into the dynamic loadings collection}
  Var P: TStateVariable;
  Begin
    P:=SV.GetStatePointer(Dist.SVID.NState,Dist.SVID.SVType,Dist.SVID.Layer);
    If P=nil then Raise EAQUATOXError.Create('Distribution Error!  No variable exists under distribution');

    Dist.LoadsCopied:=P.LoadsRec.UseConstant;
    If Dist.LoadsCopied then begin
                                Dist.DynLoadings:=P.LoadsRec.Loadings;
                                P.LoadsRec.Loadings:=nil;
                                P.LoadsRec.UseConstant:=False;
                              end;
  End;

  {----------------------------------------------------------------}
  Procedure WritePercentDeclines;
  Var OrgLoop: AllVariables;
      Loop: Integer;
      DeclOut: TextFile;
      FileN, NameStr: String;
  Begin
    FileN := Unc_Dir+Unc_File+'_decline.CSV';
    While Pos('\\',FileN)>0 do
      Delete(FileN,Pos('\\',FileN),1);

    ASSIGNFILE(DeclOut,FileN);
    REWRITE(DeclOut);

    For OrgLoop := FirstBiota to LastBiota do
      If Declines[0,OrgLoop] <> -99999 then
        Begin
          NameStr := SV.UniqueName(OrgLoop);
          While Pos(',',NameStr)>0 do
            Delete(NameStr,Pos(',',NameStr),1); {commas in the name distort CSV output}
          Write(DeclOut,NameStr);

          For Loop := 0 to IterationsDone-1 do
            Write(DeclOut,',',Declines[Loop,OrgLoop]);
          Writeln(DeclOut);
        End; {If}

    CLOSEFILE(DeclOut);
    Declines := nil;
  End; {WritePercentDeclines}
  {----------------------------------------------------------------}
  Procedure Sample_ConstLoad;
  {Each iteration, loads the constant load distribution samples into
   dynamic loading variables that the program utilizes}
  Var NumTimeSteps: Integer;
      StepLoop    : Integer;
      P           : TStateVariable;
      NewLoad     : TLoad;
      DrawValue   : Double;

  Begin
    P:=SV.GetStatePointer(Dist.SVID.NState,Dist.SVID.SVType,Dist.SVID.Layer);
    If P=nil then Raise EAQUATOXError.Create('Distribution Error!  No variable exists under distribution');

    If not Dist.LoadsCopied then Writeln(TextOut,Dist.Name,' '+' Not Used.  Dynamic Loadings Selected.')
                             else Writeln(TextOut,Dist.Name,' '+' Sampled each timestep.');
    If not Dist.LoadsCopied then exit;

    If not (P.LoadsRec.Loadings=nil) then P.LoadsRec.Loadings.Destroy;
    P.LoadsRec.Loadings:=nil;
    P.LoadsRec.Loadings:=TLoadings.init(20,20);

    NumTimeSteps:=Trunc(PSetup^.LastDay-PSetup^.FirstDay+1);

    Try
      Dist.Draws.FreeAll;
      Dist.FillDraws(NumTimeSteps,PUncertainty^.RandomSampling);  {Fill Draws with number of timesteps }
    Except
      Raise;
    End;

    For StepLoop:=1 to NumTimeSteps do
      begin
        DrawValue:=TUncertDraw(Dist.Draws.At(StepLoop-1)).Value;
        NewLoad:=TLoad.init((PSetup^.FirstDay+StepLoop-1),DrawValue);
        With P.LoadsRec.Loadings do
             AtInsert(Count,NewLoad);
      end;
  End;
  {----------------------------------------------------------------}
  Procedure Finish_ConstLoad;
  {Reset loadings data to their original state}
  Var P: TStateVariable;
  Begin
    P:=SV.GetStatePointer(Dist.SVID.NState,Dist.SVID.SVType,Dist.SVID.Layer);
    If P=nil then Raise EAQUATOXError.Create('Distribution Error!  No variable exists under distribution');

    If Dist.LoadsCopied then
       begin
         If P.LoadsRec.Loadings<>nil then P.LoadsRec.Loadings.Destroy;
         P.LoadsRec.Loadings:=nil;
         P.LoadsRec.Loadings:=Dist.DynLoadings;
         P.LoadsRec.UseConstant:=True;
       end;
  End;

  {----------------------------------------------------------------}
  {---        BEGIN MAIN Procedure LATIN HYPERCUBE RUN          ---}
  {----------------------------------------------------------------}
Var StoreStep: Double;
Begin
  If (Not SV.PRateInfo^.WriteToMemory) then 
     PSetup^.SaveBRates := False;

  IterationsDone:=0;
  UserInterrupt:=False;
  Dists := SV.Distributions;
  ExportTable:=TTable.Create(Nil);

  Try

  InitTextResults;
  ResultsHolder:=SV.Results;

  OpenExportTable;

  If PUncertainty^.UseSeed then SetSeed(PUncertainty^.RandomSeed)
                           else SetSeed(-1);

  SV.ProgData.UncertStatLabel := 'Calculating Latin Hypercube Draws...';
  SV.UpdateProg;

  SV.Distributions.FillVariableDraws(PUncertainty^.NumSteps,PUncertainty^.RandomSampling);
  IF (SV.Distributions.NumCorrelations > 0) then
    SV.Distributions.CorrelateDraws(PUncertainty^.NumSteps);

  With SV.Distributions do
   For DistribLoop:=0 to Count-1 do
     Begin
       Dist:=At(DistribLoop);
       With Dist do
         If UseDist then
            Begin
              If (Dist.DistNum=ConstLoad_RegDist_Index) then Init_ConstLoad;
              PointEstimate:=SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^;
              SummarizeDist;
            End;
     End;

  Writeln(TextOut,'---------------------------------------------------------');

  For SegLoop:=epilimnion to hypolimnion do
    begin
        SV.Results[SegLoop]:=TResultsCollection.init;
        For ResLoop:=MinRes to MeanRes do
            UncertRes[ResLoop,SegLoop]:=nil;
    end;

  For NumStepsLoop:=1 to PUncertainty^.NumSteps do
  With SV do
    Begin
      {Update Progress Dialog}
      IterationHolder:='Iteration '+IntToStr(NumStepsLoop)+ ' of '+IntToStr(PUncertainty^.NumSteps);
      SV.ProgData.UncertStatLabel := IterationHolder;
      Writeln(TextOut,IterationHolder);
      Writeln(TextOut);

      {Load the latin hypercube values into the simulation}
      For DistribLoop:=0 to Dists.Count-1 do
        Begin
          Dist:=Dists.At(DistribLoop);
          With Dist do
            If UseDist then
               If (Dist.DistNum<>ConstLoad_RegDist_Index)
                 then begin
                        DrawValue:=TUncertDraw(Draws.At(NumStepsLoop-1)).Value;
                        Return_Var_Pointer(DistNum,SVID,ToxRec)^:=DrawValue;
                        Writeln(TextOut,Dist.Name,' '+FloatToStrF(DrawValue,ffGeneral,6,5));
                      end
                  else Sample_ConstLoad;
       End;

      {Go through run Procedure for each iteration}
      If not SetupforRun then UserInterrupt:=True;

      If not UserInterrupt then
        BEGIN
          AllSVs := SV;
          SV.PAllSVsColl := @AllSVs;
          StoreStep := PSetup^.StoreStepSize;
          If not PSetup^.StepSizeInDays then StoreStep := StoreStep / 24;
          Integrate(PSetup^.FirstDay,PSetup^.LastDay,PSetup^.RelativeError,MINIMUM_STEPSIZE,StoreStep);
          {Integrate Parameters:  x1, x2, eps, h1, hmin, dxsav: double );  }

          If Stratified then SV.Overturn(true);  {Returns vital info to SV}
        END;

      If (SV.ProgData.ProgCancel) or UserInterrupt then
         begin
            UserInterrupt:=True;
            DateTimeToString(DateHolder,'mm-d-y t',Now);
            Writeln(TextOut,'Run Terminated by user at '+ DateHolder );
            Break; {exit loop}
         end
         else Accumulate_Uncertainty_Results;

    End;  {NumStepsLoop}

    If Not UserInterrupt then
      begin
        DateTimeToString(DateHolder,'mm-d-y t',Now);
        Writeln(TextOut,'Run Successfully Completed At '+ DateHolder );
        Writeln(TextOut,'---------------------------------------------------------');
      end;

  Except
    ErrorString:=Exception(ExceptObject).Message;
    SV.ProgData.ProgCancel := True;

    SV.PMessageStr^ := 'Run-Time Error During Uncertainty Iteration.';
    SV.PMessageErr^ := True;
    SV.TSMessage;
    SV.PMessageStr^ := ErrorString;
    SV.TSMessage;

    DateTimeToString(DateHolder,'mm-d-y t',Now);
      Try
        Writeln(TextOut,'Run Terminated at '+ DateHolder );
        Writeln(TextOut,'    Due to '+ErrorString);
      Except
        SV.PMessageStr^ := 'No Data Written';
        SV.TSMessage;
        SV.ProgData.ProgCancel := True;
        SV.UpdateProg;

      End;

  End; {Except}

  CloseFile(TextOut);

  Try
    SV.DestroyResults(False);

    SV.Results:=ResultsHolder;

    IF IterationsDone<=0
       then begin
              Unc_Dir:=''; Unc_File:=''; Unc_Ext:='';
              ExportTable.Active:=False;
              ExportTable.Close;
            end
       else begin
              WriteResultsToDBase;
              WritePercentDeclines;
            end;

    For SegLoop:=Epilimnion to Hypolimnion do
       For ResLoop:=MinRes to MeanRes do
          begin
             If UncertRes[ResLoop,SegLoop]<>nil then  UncertRes[ResLoop,SegLoop].Destroy;
             UncertRes[ResLoop,SegLoop]:=nil;
          end;

  Except
    ErrorString:=Exception(ExceptObject).Message;
    SV.ProgData.ProgCancel := True;

    SV.PMessageStr^ := 'Run-Time Error Writing Database After Uncertainty Run';
    SV.PMessageErr^ := True;
    SV.TSMessage;
    SV.PMessageStr^ := ErrorString;
    SV.TSMessage;
    SV.UpdateProg;

    ExportTable.Active:=False;
    ExportTable.Close;
  End; {Except}

  SV.UpdateProg;

  {Load the point estimate values back into the simulation}
    For DistribLoop:=0 to Dists.Count-1 do
       Begin
         Dist:=Dists.At(DistribLoop);
         With Dist do
           If UseDist then
               Begin
                 SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^:=Dist.PointEstimate;
                 If (Dist.DistNum=ConstLoad_RegDist_Index) then Finish_ConstLoad;
               End;
       End;

End;  {LatinHyperCubeRun}


{-----------------------------------------------------------------------------------}

Procedure TAQUATOXSegment.StateDataFromDBase(State: StateVariables; Typ: T_SVType;
                                             Dir, DBFileName, Entry: ShortString);
{Given a statevariable and a database name and entry, loads the data: JonC}
{Used when a new study is being created}
Var i: integer;
    StatusOK: Boolean;
    TrophDir: String;

Begin
   StatusOK:=False;
   i:=SV.Getindex(State,Typ,WaterCol);
   if i<0 then Raise EAQUATOXError.Create('TAQUATOXSegment.StateDataFromDBase Error: State Not Found')
   else Case DBFileName[1] of
          'A': Begin
                  StatusOK:=DBase_To_AnimalRecord(Dir,DBFileName,Entry,-1,TAnimal(SV.AT(i)).PAnimalData^);
                  TAnimal(SV.AT(i)).ChangeData;
                  If StatusOK then
                    Begin
                      If DirectoryExists(Dir+'\Trophint')
                          then TrophDir := Dir+'\Trophint\'
                          else TrophDir := Dir+'\';
                      If not TAnimal(SV.AT(i)).ReadTrophInt(TrophDir+TAnimal(SV.AT(i)).PAnimalData^.AnimalName+'.int')
                        then MessageDlg2('Warning, cannot read trophic interaction file for Animal '+TAnimal(SV.AT(i)).PAnimalData^.AnimalName
                                        +'.  Trophic interactions are set to zero.',mtwarning,[mbok],0);
                    End;
               End;
          'P': Begin
                  StatusOK:=DBase_To_PlantRecord (Dir,DBFileName,Entry,-1,TPlant(SV.AT(i)).PAlgalRec^);
                  TPlant(SV.AT(i)).ChangeData;
               End;
        End;
   If StatusOK then TStateVariable(SV.At(i)).PName^ := TStateVariable(SV.At(i)).PName^+': ['+Entry+']';
   TStateVariable(SV.At(i)).PHasData^ := StatusOK;
End;

Procedure TAQUATOXSegment.Load_Blank_Study(Site: Sitetypes);
{Loads a Blank Study}

Var  SiteName: ShortString;
     PSV: TStateVariable;
     i: Integer;
begin
    {Load Appropriate Default Site}
    SiteName:='Default ';
    Case Site of
              Pond: SiteName:=SiteName+'Pond';
              Stream: SiteName:=SiteName+'Stream';
              Reservr1D: Sitename:=SiteName+'Reservoir';
              Lake: Sitename:=SiteName+'Lake';
              Enclosure: SiteName := SiteName+'Enclosure';
              Estuary: SiteName := SiteName+'Estuary';
         end; {Case}

    If DBase_To_SiteRecord(Default_Dir,'Site.SDB',SiteName,Location.Locale)
       then Location.ChangeData(Location.Locale.ICZMean)
       else fillchar(Location.Locale,SizeOf(Location.Locale),0);

    {Load Default Remin Record}
   If Not DBase_To_ReminRecord(Default_Dir,'Remin.RDB','Default Remin Record',Location.Remin)
      then fillchar(Location.Remin,SizeOf(Location.Remin),0);


  {Add State Variables with appropriate initial conditions}
   SV.SetMemLocRec;
   AddStateVariable(Volume,WaterCol,10000,True);
   AddStateVariable(Temperature,WaterCol,0,True);
   AddStateVariable(Light,WaterCol,0,True);
   SV.SetMemLocRec;
   PSV:=SV.GetStatePointer(Light,StV,WaterCol);
   PSV.LoadsRec.NoUserLoad := True;

   AddStateVariable(Phosphate,WaterCol,0,True);
   AddStateVariable(Ammonia,WaterCol,0,True);
   AddStateVariable(Nitrate,WaterCol,0,True);
   AddStateVariable(CO2,WaterCol,0,True);
   AddStateVariable(Oxygen,WaterCol,0,True);

   AddStateVariable(SedmLabDetr,WaterCol,0,True);
   AddStateVariable(SuspLabDetr,WaterCol,0,True);
   AddStateVariable(DissLabDetr,WaterCol,0,True);
   AddStateVariable(SedmRefrDetr,WaterCol,0,True);
   AddStateVariable(SuspRefrDetr,WaterCol,0,True);
   AddStateVariable(DissRefrDetr,WaterCol,0,True);

   PSV:=SV.GetStatePointer(Light,StV,WaterCol);
   PSV.LoadsRec.NoUserLoad := True;

   AddStateVariable(pH,WaterCol,7.5,True);
   PSV:=SV.GetStatePointer(pH,StV,WaterCol);
   PSV.LoadsRec.UseConstant := True;
   PSV.LoadsRec.ConstLoad := 7.5;

   AddStateVariable(WindLoading,WaterCol,0,True);
   SV.SetMemLocRec;
   PSV:=SV.GetStatePointer(WindLoading,StV,WaterCol);
   PSV.LoadsRec.NoUserLoad := True;
   SV.SetMemLocRec;

   {Default Study Setup Data}
   PSetup^.FirstDay :=  36161;  {Jan 1, 1999}
   PSetup^.LastDay  :=  36525;  {Dec 31, 1999}
   PSetup^.StoreStepSize := 1;
   PSetup^.StepSizeInDays := True;
   PSetup^.ModelTSDays := True;
   PSetup^.RelativeError := 0.001;
   PSetup^.MinStepSize   := 1e-10;
   PSetup^.SaveBRates    := False;
   PSetup^.AlwaysWriteHypo := False;
   PSetup^.ShowIntegration := False;
   PSetup^.UseComplexedInBAF := False;
   PSetup^.DisableLipidCalc  := TRUE;  //disabled 4/28/09
   PSetup^.KeepDissToxConst  := False;
   PSetup^.UseExternalConcs  := False;
   PSetup^.BCFUptake         := False;
   PSetup^.Spinup_Mode       := False;
   PSetup^.NFix_UseRatio     := False;
   PSetup^.NtoPRatio         := 7.0;
   PSetup^.Spin_Nutrients := True;

   {Default Uncertainty Data}
    With PUncertainty^ do
      begin
        Run_Uncertainty := False;
        NumSteps        := 20;
        RandomSeed      := 100;
        UseSeed         := True;
        Run_Sensitivity := False;
        NominalPercent := 10;
        NumUncert := 0;
        NumSens := 0;
        For i := 1 to 100 do
          Begin
            SensTrack[i] := -99;
            UncertTrack[i] := -99;
          End;
        LinkPeriPhyto := False;
      end;
End;  {Load Blank Study}





Procedure TAQUATOXSegment.DisplayNames(List:TStrings);
{Puts all statevariables from collection into TSTRINGS item for screen
      display:   Ordered by enumerated list position. JonC}

Var Index: Integer;
    SVLoop: AllVariables;
    Name: String;

Begin
   List.Clear;
   For SvLoop := FirstState to LastState do
     Begin
       Index:=SV.GetIndex(SvLoop,STV,WaterCol);
       If Index > -1 then
           begin
             Name:= TStateVariable(SV.At(index)).PName^;
             If Name = 'Undisplayed' then Index:=-1;
           end;
       If Index>-1 then List.Add(Name);
    End;
End;



Function TAQUATOXSegment.Verify_Runnable(IsControl, SendMessage: Boolean): Boolean;
{Runs various data checks on the Study Data to Ensure that a run is
possible If not, it brings up a dialog error and returns false : JonC}

     Function MessageDlg3(St: String; ATyp: TMsgDlgType; AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
     {MessageDLG3 is designed to run only once when model is run in Linked Mode}
     Begin
       Result := 0;
       If (not SV.LinkedMode) or SendMessage
         then Result := MessageDlg2(St, ATyp, AButtons, HelpCtx);
     End;

     Procedure VerifyHasData(p:TStateVariable);
     {Checks the state variable it is passed to see if it is a plant
      or animal and has no data.  If so, Raises Error and Returns False}
      begin
         if (P.PRequiresData^ and (Not P.PHasData^)) then
            begin
              Verify_Runnable:=False;
              MessageDlg3('StateVariable "'+P.PName^+'" Has No Associated Data.',mterror,[mbOK],0);
            end;
      end;


Var i: Integer;
    PPW: TPoreWater;
    sandf,siltf,clayf: Double;
    PlantIndex,AnimalIndex,SpecError: AllVariables;
    PA, PA2: TAnimal;
    PP, PP2: TPlant;
    BaldFile, ExtString,BaseRateName: String;
    LayLoop: T_SVLayer;
    Loop: Integer;
    PCFileN: array[0..300] of Char;
    Loop2: T_SVType;
    MR: TModalResult;
    SgID: String;

Begin
  SgID := '';
  If SV.LinkedMode then SgID := 'SEG '+ SegNumber +': ';

  With SV.SetupRec^ do
  If (SPINUP_MODE) and (not Spin_Nutrients) then
     If MessageDlg3('Warning, the model is running in "Spinup Mode."  Initial conditions '+
                    'for biota will be set to their value on the last time-step of output.',
                     mtwarning,[mbok,mbcancel],0) = MRCancel then
        Begin
          Verify_Runnable:=False;
          exit;
        End;

  With SV.SetupRec^ do
  If (SPINUP_MODE) and (Spin_Nutrients) then
     If MessageDlg3('Warning, the model is running in "Spinup Mode."  Initial conditions '+
                    'for biota, organic matter, and nutrients in the water column and sediment bed will be set to their value on the last time-step of output.',
                     mtwarning,[mbok,mbcancel],0) = MRCancel then
        Begin
          Verify_Runnable:=False;
          exit;
        End;

  Verify_Runnable:=True;
  If SV.Count<1 then begin
                        MessageDlg3('No State Variables Are Loaded.',mterror,[mbOK],0);
                        Verify_Runnable:=False;
                        exit;
                      end;


  With SV do for i:=0 to Count-1 do
      VerifyHasData(at(i));

  For Loop2:=FirstOrgTxTyp to LastOrgTxTyp do
    If PChems^[Loop2] <> nil then
     If PChems^[Loop2].ChemRec.MolWt <= 0 then
                 begin
                   MessageDlg3('Molecular Weight of all Chemicals Must Be Greater Than Zero.',mterror,[mbOK],0);
                   Verify_Runnable:=False;
                 end;

  If PSetup^.FirstDay>=PSetup^.LastDay then
                 begin
                    MessageDlg3('In Setup Screen, Last Day must be after First Day.',mterror,[mbOK],0);
                    Verify_Runnable:=False;
                 end;

  If (Location.SiteType = Estuary) and (SV.GetState(Salinity,StV,WaterCol)=-1) then
                 begin
                    MessageDlg3('An Estuary Segment Must have Salinity included as a State Variable.',mterror,[mbOK],0);
                    Verify_Runnable:=False;
                 end;

  If SV.GetState(Sand,StV,WaterCol)>-1 then
    begin
     SandF:=TSandSiltClay(SV.GetStatePointer(Sand,StV,WaterCol)).FracInBed;
     SiltF:=TSandSiltClay(SV.GetStatePointer(Silt,StV,WaterCol)).FracInBed;
     ClayF:=TSandSiltClay(SV.GetStatePointer(Clay,StV,WaterCol)).FracInBed;

     If ((SandF+SiltF+ClayF < 0.98) or (SandF+SiltF+ClayF > 1.02)) and (Location.SiteType <> TribInput)then
       begin
         MessageDlg2(SgID+' Cannot Run Study:  Fraction of Sand, Silt, Clay in bed sediment must sum to 1.0',mterror,[mbOK],0);
         Verify_Runnable:=False;
       end;
    end;

  If SV.Diagenesis_Included then With SV do
    Begin
      If (GetStatePointer(BuriedRefrDetr,StV,WaterCol) <> nil) or
         (GetStatePointer(BuriedLabileDetr,StV,WaterCol) <> nil) then
       begin
         MessageDlg2(SgID+' Cannot Run Study:  Buried Detritus may not be included in a diagenesis model run.',mterror,[mbOK],0);
         Verify_Runnable:=False;
       end;

    End;


    For PlantIndex := FirstPlant to LastPlant do
     With SV do
      Begin
        PP := GetStatePointer(PlantIndex,StV,WaterCol);
        If PP<>nil then
          Begin
            If (PP.PAlgalRec^.PlantType = 'Bryophytes') and
               not (PP.nstate in [FirstMacro..LastMacro]) then
                Begin
                   MessageDlg3('Error: Bryophyte '+PP.PName^+' is not in a macrophyte object.  This plant must be loaded ' +
                            'into Macrophyte1..Macrophyte6 to be modeled properly.',mterror,[mbOK],0);
                   Verify_Runnable := False;
                   Exit;
                End;

          If (PP.PAlgalRec^.SurfaceFloating) and (not PP.IsPhytoplankton) then
            PP.PAlgalRec^.SurfaceFloating := False;  //relevant to phytoplankton only

          For Loop2:=FirstOrgTxTyp to LastOrgTxTyp do
           If PChems^[Loop2] <> nil then
            If PChems^[Loop2].ChemRec.IsPFA then
             Begin
               PP.CalcRiskConc(False);
               If PP.Plant_Tox[Loop2].K2 <= 0 then
                           begin
                             If MessageDlg3('Warning.  PFA K2 for plant '+PP.Plant_Tox[Loop2].Plant_Name+' set to zero.  No algal uptake of PFA will be modeled as uptake rate is a function of BCF and elimination rate.',mtwarning,[mbOK, mbcancel],0)
                                = mrCancel then
                                  Begin
                                    Verify_Runnable:=False;
                                    exit;
                                  End;
                           end;
             End;

            If PP.IsPeriphyton then
              Begin
                PP2 := GetStatePointer(PP.PSameSpecies^,StV,WaterCol);
                If PP2 = nil
                  then
                    Begin
                      If (Location.Sitetype=Stream) then
                        If MessageDlg3('Warning: Periphyton '+PP.PName^+' is not linked to a phytoplankton compartment.  ' +
                                    'Chlorophyll may be undercounted in a scour event.',mterror,[mbOK,mbCancel],0) = MRCancel
                           then
                             Begin
                               Verify_Runnable := False;
                               Exit;
                             End;
                      PP.PSameSpecies^ := NullStateVar;
                    End
                  else {PP2<>nil}
                    If not PP2.IsPhytoplankton then
                      Begin
                        PP.PSameSpecies^ := NullStateVar;
                        If MessageDlg3('Warning: Periphyton '+PP.PName^+' is linked to a NON-PHYTOPLANKTON compartment.  ' +
                                    'It will be modified to "scour to detritus"',mterror,[mbOK,mbCancel],0) = MRCancel
                           then
                             Begin
                               Verify_Runnable := False;
                               Exit;
                             End;
                      End;
              End;
          End;
      End;

    SpecError := NullStateVar;
    With SV do
    For AnimalIndex := FirstAnimal to LgGameFish4 do
      Begin
        PA := GetStatePointer(AnimalIndex,StV,WaterCol);
        If PA<>nil then
          If PA.PSameSpecies^ <> NullStateVar then
            Begin
              PA2:=GetSTatePointer(PA.PSameSpecies^,StV,WaterCol);
              If PA.PAnimalData^.N2Org <> PA2.PAnimalData^.N2Org then SpecError := AnimalIndex;
              If PA.PAnimalData^.P2Org <> PA2.PAnimalData^.P2Org then SpecError := AnimalIndex;
            End;
      End;

    For AnimalIndex := FirstAnimal to Fish2 do
      Begin
        PA := SV.GetStatePointer(AnimalIndex,StV,WaterCol);
        If PA<>nil then
          If PA.AHabitat_Limit = 0 then
            If MessageDlg2(SgID+' Warning: Animal '+PA.PName^+' has zero available habitat (riffle, run, pool).  ' +
                           'Animal consumption will be set to zero.',mterror,[mbOK,mbCancel],0) = MRCancel
               then
                 Begin
                   Verify_Runnable := False;
                   Exit;
                 End;
      End;

    For AnimalIndex := FirstPlant to LastPlant do
      Begin
        PP := SV.GetStatePointer(AnimalIndex,StV,WaterCol);
        If PP<>nil then
          If PP.PHabitat_Limit = 0 then
            If MessageDlg2(SgID+' Warning: Plant '+PP.PName^+' has zero available habitat (riffle, run, pool).  ' +
                           'Photosynthesis will be set to zero.',mterror,[mbOK,mbCancel],0) = MRCancel
               then
                 Begin
                   Verify_Runnable := False;
                   Exit;
                 End;
      End;

      PA := SV.GetSTatePointer(Fish1,StV,WaterCol);
      If PA<>nil then
          Begin
            PA2:=SV.GetSTatePointer(Fish2,StV,WaterCol);
            If PA.PAnimalData^.N2Org <> PA2.PAnimalData^.N2Org then SpecError := Fish1;
            If PA.PAnimalData^.P2Org <> PA2.PAnimalData^.P2Org then SpecError := Fish1;
          End;


      If SpecError <> NullStateVar then
        Begin
          PA := SV.GetStatePointer(SpecError,StV,WaterCol);
          MessageDlg3('Warning:  Nutrients will not balance, young and old organisms ' +
                      'must have the same nutrient to organics fraction.  Reference organism '
                       +PA.PName^,mterror,[mbOK],0);
        End;

    If (Location.SiteType<>Stream) and (Location.SiteType<>TribInput) and (SV.GetState(Sand,StV,WaterCol) > -1) then
      begin
        MessageDlg2(SgID+' Sand, Silt, Clay must be deleted for all sites except for streams',mterror,[mbOK],0);
        Verify_Runnable:=False;
      end;

    If (SV.GetState(Sand,StV,WaterCol) > -1) and (SV.GetState(TSS,StV,WaterCol) > -1) then
      begin
        MessageDlg3('You cannot have both "Sand, Silt, Clay" and "T.S.S." as variables in the same study.',mterror,[mbOK],0);
        Verify_Runnable:=False;
      end;

    If (SV.GetState(Sand,StV,WaterCol) > -1) and (SV.GetState(Cohesives,StV,WaterCol) > -1) then
      begin
        MessageDlg3('You cannot have both "Sand, Silt, Clay" and "Cohesives / NonCohesives" as variables in the same study.',mterror,[mbOK],0);
        Verify_Runnable:=False;
      end;

    If (SV.GetState(TSS,StV,WaterCol) > -1) and (SV.GetState(Cohesives,StV,WaterCol) > -1) then
      begin
        MessageDlg3('You cannot have both "T.S.S." and "Cohesives / NonCohesives" as variables in the same study.',mterror,[mbOK],0);
        Verify_Runnable:=False;
      end;

    If Location.SiteType = Estuary then
      Begin
        If (Location.Locale.Amplitude1 = 0) and
           (Location.Locale.Amplitude2 = 0) and
           (Location.Locale.k1 = 0) and
           (Location.Locale.k2 = 0) then
             If MessageDlg2('Important estuary tidal range parameters are set to zero (site screen).  Tidal range effects likely misparameterized',
             mterror,[mbOK,mbcancel],0) = MRCancel then Verify_Runnable := False;
      End;

    For LayLoop := SedLayer1 to SedLayer10 do
      Begin
        PPW := SV.GetstatePointer(PoreWater,StV,LayLoop);
        If PPW<>nil then
          Begin
            If PPW.InitialCond<0 then
              Begin
                MessageDlg2(SgID+' Error in Sediment Layer #'
                   + IntToStr(ORD(LayLoop))
                   +'.  Layer thickness is too small for all the sediment you have in there.',mterror,[mbOK],0);
                Verify_Runnable:=False;
              End;
          End;
      End;

  If PSetup^.SaveBRates and Result then With SV.PRateInfo^ do
    Begin
      If Not SV.LinkedMode then
        Begin
          DirNm  := Output_Dir;

          BaseRateName := FileName;
          Delete(BaseRateName,Length(BaseRateName)-3,4);
          BaseRateName := BaseRateName+'_Rate';
          ExtString := '.db';
          FileNm := BaseRateName + ExtString;
          If IsControl then FileNm := 'C_'+FileNm;

          If FileExists(DirNm+FileNm) then
            Begin
              MR := MessageDlg3('Overwrite Rate File : '+FileNm+'?'
                                                 ,mtConfirmation,[mbYes,mbNo,mbCancel],0);
              If MR=MRCancel then Begin Verify_Runnable := False; Exit; End;
              PSetup^.SaveBRates := (MR = mrYes);
            End;

          If not WritetoMemory and FileExists(DirNm+ChangeFileExt(FileNm,'.xls')) then
            Begin
              MR := MessageDlg3('Overwrite Excel File : '+ChangeFileExt(FileNm,'.xls')+'?'
                                                 ,mtConfirmation,[mbYes,mbNo,mbCancel],0);
              If MR=MRCancel then Begin Verify_Runnable := False; Exit; End;
              PSetup^.SaveBRates := (MR = mrYes);

              StrPCopy(PCFileN,DirNm+ChangeFileExt(FileNm,'.xls'));
              If MR=mrYes then
               Begin
                If Not DeleteFile(PCFileN)
                  then
                    Begin
                       MessageDlg3('That Excel file is in use or cannot be deleted.',mterror,[mbOK],0);
                       Verify_Runnable:=False;
                    End;

                   BaldFile := FileNm;
                   Delete(BaldFile,Length(BaldFile)-2,3);
                   BaldFile:=BaldFile+'_Hyp';

                   If FileExists(DirNm+ChangeFileExt(BaldFile,'.xls')) then
                     Begin
                       StrPCopy(PCFileN,DirNm+ChangeFileExt(BaldFile,'.xls'));
                       If Not DeleteFile(PCFileN)
                         then
                           Begin
                              MessageDlg3('File '+DirNm+ChangeFileExt(BaldFile,'.xls')+' is in use or cannot be deleted.',mterror,[mbOK],0);
                              Verify_Runnable:=False;
                           End;
                     End;
               End; {MR=MRyes}
            End; {If Not writeparadox}

          If PSetup^.SaveBRates and (not SV.PRateInfo^.WriteToMemory) then
            Begin
              For Loop := 1 to Length(OpenWriteFiles) do
                If FileNm=OpenWriteFiles[Loop-1] then
                   Begin
                      MessageDlg3('That Rate File is Currently Being Written to by another simulation run.',mterror,[mbOK],0);
                      Verify_Runnable:=False;
                   End;
            End; {If PSetup^}
        End; {not linkedmode}

    End; {If PSetup^}
End; {Verify Runnable}

            {---------------------------------------------------------------------}

            procedure SaveStringsToStream(Strings: TStringList; Var Stream: TStream);
            var
              L: LongInt;
              Buffer: TMemoryStream;
            begin
              Buffer := TMemoryStream.Create;
              try
                Strings.SaveToStream(Buffer);
                Buffer.Position := 0;
                L := Buffer.Size;
                Stream.Write(L, SizeOf(L));
                Stream.CopyFrom(Buffer, L);
              finally
                Buffer.Free;
              end;
            end;
            {---------------------------------------------------------------------}
            procedure LoadStringsFromStream(Var Strings: TStringList; Var Stream: TStream);
            var
              L : LongInt;
              Buffer: TMemoryStream;
            begin
              Buffer := TMemoryStream.Create;
              try
                Stream.Read(L, SizeOf(L));
                Buffer.CopyFrom(Stream, L);
                Buffer.Seek(0, soFromBeginning); {Go to beginning of stream}
                Strings.LoadFromStream(Buffer);
              finally
                Buffer.Free;
              end;
            end;

            {---------------------------------------------------------------------}


Procedure  TAQUATOXSegment.Store(IsTemp: Boolean; Var st: Tstream);
Var VersionWrite: String[10];
    Loop2       : T_SVTYpe;
Begin
     TeaseScreen:=True;
     VersionWrite:=VersionStr;
     st.Write(VersionWrite,Sizeof(VersionWrite));
     st.Write(FileName,Sizeof(Filename));
     st.Write(Dirname,Sizeof(Dirname));
     st.Write(LastRun,Sizeof(LastRun));
     st.Write(ControLRun,Sizeof(ControlRun));
     st.Write(StudyName,Sizeof(StudyName));

     If NewNotes.Count = 0 then NewNotes.Add(' ');  //NewNotes must not be blank for proper loading and storing.
     SaveStringsToStream(NewNotes,St); (* st.Write(Notes,Sizeof(Notes)); *)

     If Not IsTemp then st.Write(SegNumber, Sizeof(SegNumber));

     SV.Store(IsTemp, St);

     If IsTemp then st.Write(PSetup^,Sizeof(PSetup^));
     st.Write(PDiagenesis^,Sizeof(PDiagenesis^));                   //10-28 segment specific
     If IsTemp then st.Write(PUncertainty^,Sizeof(PUncertainty^));

     Location.Store(IsTemp,St);

     If IsTemp then
       Begin
         St.Write(PChems^, Sizeof(PChems^));
         For Loop2 := FirstOrgTxTyp to LastOrgTxTyp do
           If PChems^[Loop2]<>nil then PChems^[Loop2].Store(IsTemp,St);
       End;
End;

Procedure  TAquatoxSegment.WriteText;
Var VersionWrite: String[10];
    Loop2       : T_SVTYpe;
Begin

     SV.Zero_Utility_Variables;
     SV.SetMemLocRec;                   {Set up array of pointers to memory}
     SV.SetStateToInitConds(FALSE);     {Set up State Variables}
     SV.NormDiff(-1);

     If not SV.LinkedMode then
         Begin
           TeaseScreen:=True;
           VersionWrite:=VersionStr;
           Writeln(LF,'AQUATOX Model Text Parameterization');
           Writeln(LF,'-----------------------------------');
           Writeln(LF,'AQUATOX Version: '+VersionWrite);
           Writeln(LF,'FileName: '+FileName);
           Writeln(LF,'Directory: '+DirName);
           Writeln(LF,'StudyName: '+StudyName);
         End
      Else
         Writeln(LF,'SEGMENT: '+SegNumber+', '+StudyName);

     Writeln(LF,'-----------------------------------');
     Writeln(LF,'  SETUP RECORD ');
     With PSetup^ do
       Begin
         Writeln(LF,'FirstDay: '+DateToStr(FirstDay));
         Writeln(LF,'LastDay: '+DateToStr(LastDay));
         Write(LF,'StoreStepSize: '+FloatToStrF(StoreStepSize,ffgeneral,5,5));
         If StepSizeInDays then Writeln(LF,' day(s)') else Writeln(LF,' HOUR(S)');
         If not ModelTSDays then Writeln(LF,'MODEL SET UP TO RUN WITH HOURLY TIMESTEP');
         Writeln(LF,'MinStepSize: '+FloatToStrF(MinStepSize,ffgeneral,5,5));
         Writeln(LF,'RelativeError: '+FloatToStrF(RelativeError,ffgeneral,5,5));
         Write(LF,'SaveBRates: '); If SaveBRates then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
         Write(LF,'AlwaysWriteHypo: '); If AlwaysWriteHypo then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
         Write(LF,'ShowIntegration: '); If ShowIntegration then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
         Write(LF,'UseComplexedInBAF: '); If UseComplexedInBAF then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
       //  Write(LF,'DisableLipidCalc: '); If DisableLipidCalc then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
         Write(LF,'KeepDissToxConst: '); If KeepDissToxConst then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
         Write(LF,'UseExternalConcs: '); If UseExternalConcs then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
         Write(LF,'BCFUptake: '); If BCFUptake then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
         If Spinup_Mode then Writeln(LF,'--- SPINUP MODE ---');
       End;

     Location.WriteText(LF);

     SV.WriteText(LF);

     For Loop2 := FirstOrgTxTyp to LastOrgTxTyp do
       If SV.GetStatePointer(AssocToxSV(Loop2),StV,WaterCol)<>nil then PChems^[Loop2].WriteText(LF);

End;


Constructor  TAQUATOXSegment.Load(LinkedM,IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double; LoadResults, LoadDistribs:Boolean);
Var LayerLoop: T_SVLayer;
    i: Integer;
    Loop2: T_SVType;
    Notes: String[255];

      Procedure SetVars(p:TStateVariable);
      Begin
        P.AllStates:=SV;
        P.Location:=SV.Location;
        P.ChemPtrs:=SV.ChemPtrs;
        If IsTemp then P.UpdateUnits;
      End;

      Procedure SetUnUsed(Var TP:TParameter);
      Begin
       With TP do
        Begin
          Val := 0;
          Units := '';  name := 'unused';
          Comment := '';
          Symbol := 'unused';
        End;
      End;

Var junk: Boolean;
    oldstudyname: String[20];
    OldFileN: String[40];
    Loop: VerticalSegments;
Begin
   TeaseScreen:=True;
   FileName:='';

   If ReadVersionNum < 3.585
     then Begin
            st.Read(OldFileN,Sizeof(OldFileN));
            FileName := OldFileN;
          End
     else st.Read(FileName,Sizeof(FileName));
   st.Read(Dirname,Sizeof(Dirname));

   If ReadVersionNum<3.00 then  st.Read(Junk,Sizeof(Junk)); {was "changed," no longer req. saving.}

   st.Read(LastRun,Sizeof(LastRun));
   st.Read(ControlRun,Sizeof(ControlRun));

   StudyName := '';
   If ReadVersionNum < 3.135
     then Begin
            st.Read(oldstudyName,Sizeof(oldstudyName));
            StudyName := OldStudyName;
          End
     else st.Read(StudyName,Sizeof(StudyName));

   NewNotes := TStringList.Create;
   If ReadVersionNum < 3.745 then
     Begin
       st.Read(Notes,Sizeof(Notes));
       NewNotes.Add(Notes);
     End
      else LoadStringsFromStream(NewNotes,St);

   If Not IsTemp then st.read(SegNumber, Sizeof(SegNumber))
                 else SegNumber := '';

   SV:=TStates.Load(LinkedM,IsTemp, St,ReadVersionNum,LoadResults,LoadDistribs);

   If ReadVersionNum<1.725 then MessageDlg2('Average drift for benthic animals will be initialized to zero',
                      mtinformation,[mbOk],0);

   If (ReadVersionNum<3.155) and IsTemp then MessageDlg2('Oxygen LC50s and EC50s (for calculating low oxygen effects) set to rough defaults for all animals.',
                      mtinformation,[mbOk],0);

   If (ReadVersionNum<3.165) and IsTemp then MessageDlg2('Ammonia LC50s for animals set to 10 mg/L as a rough default.',
                      mtinformation,[mbOk],0);

   If (ReadVersionNum<3.825) and IsTemp then MessageDlg2('Internal-nutrient parameters for plants loaded with defaults.',
                      mtinformation,[mbOk],0);

   If (ReadVersionNum<2.505) then
         MessageDlg2('"P to Org" and "N to Org" set to broad defaults in animal records.  "Wet to Dry" set to 5.0 for all organisms and Detritus.',
                      mtinformation,[mbOk],0);


   If ReadVersionNum < 3.00 then
      Begin
        (MessageDlg2('Frac Exposure to Water Column is being set to default values in the Animal Underlying Data.', MTInformation, [MbOK], 0));
        (MessageDlg2('Results are not Loaded.', MTInformation, [MbOK], 0));
         For Loop:=Epilimnion to Hypolimnion do
           Begin
             SV.Results[loop].FreeAll;
             SV.ControlResults[loop].FreeAll;
             LastRun      := -1;
             ControlRun   := -1;
           End;
        SV.PRateInfo^.WriteToMemory := True;

      End;

   If (ReadVersionNum < 3.455) and IsTemp then
       MessageDlg2('New Animal and Plant Parameters Pertaining to Suspended and Bedded Sediment Effects are Set Such That Effects are Zero.', MTInformation, [MbOK], 0);

   If (ReadVersionNum < 3.685) and IsTemp then
       MessageDlg2('Plant Fractions Lipid (in Underlying Data) are set to 0.2.  (This is currently relevant to BAF computation only.)', MTInformation, [MbOK], 0);

    {READ THE SETUP RECORD}
    If IsTemp then
      Begin
        New(PSetup);

        If ReadVersionNum<3.015
          then
            Begin
              If ReadVersionNum < 2.605 then St.Read(PSetup^,48)
                                        else St.Read(PSetup^,49);

              If ReadVersionNum < 3.00 then PSetup^.AverageOutput := True;
              PSetup^.UseExternalConcs := False;
              PSetup^.BCFUptake := False;
            End
          else St.Read(PSetup^,sizeof(PSetup^));

        If ReadVersionNum < 3.145 then
          Begin
            PSetup^.StepSizeInDays := True;
            PSetup^.ModelTSDays    := True;
          End;

        If ReadVersionNum < 3.555 then
            PSetup^.Spinup_Mode := False;

        If ReadVersionNum < 3.659 then
            PSetup^.NFix_UseRatio := False;

        If ReadVersionNum < 3.669 then
            PSetup^.NtoPRatio := 7.0;  //default 3/19/2010

        If ReadVersionNum < 3.765 then
            PSetup^.Spin_Nutrients := True;

        PSetup.DisableLipidCalc := TRUE;  // Disabled 4/28/09

        If ReadVersionNum < 3.785 then
          Begin
            PSetup^.FixStepSize := 0.1;
            PSetup^.UseFixStepSize := FALSE;  //defaults
          End;

        If readversionNum < 3.825 then PSetup^.Internal_Nutrients := False;
      End;

   If ReadVersionNum < 3.725 then   //DIAGENESIS PARAMETER READING
    BEGIN
     If IsTemp
       then
         Begin
           New(PDiagenesis);
           If ReadVersionNum < 3.395
             then SetDefaultDiagenesis(PDiagenesis^,false)
             else if ReadVersionNum < 3.425
               then
                 Begin
                   st.Read(PDiagenesis^,13688);
                   SetDefaultDiagenesis(PDiagenesis^,false);
                 End
               else
                 if ReadVersionNum < 3.465
                   then
                     Begin
                       st.Read(PDiagenesis^,15328);
                       with PDiagenesis^.LigninDetr do
                          Begin
                            Val := 0.01;
                            Units := 'unitless';  name := 'Fraction of suspended detritus that is non-reactive';
                            Comment := 'default';
                            Symbol := 'LigninDetr';
                          End;
                     End
                   else If ReadVersionNum < 3.515
                    then st.Read(PDiagenesis^,15560)
                    else st.Read(PDiagenesis^,Sizeof(PDiagenesis^));

           If ReadVersionNum < 8.61 then SetDefaultDiagenesis(PDiagenesis^,true);
           PDiagenesis^.W12 := 0;
           PDiagenesis^.KL12 := 0;
           SetUnused(PDiagenesis^.Unused_frpon1);
           SetUnused(PDiagenesis^.Unused_frpon2);
           SetUnused(PDiagenesis^.Unused_frpoc1);
           SetUnused(PDiagenesis^.Unused_frpoc2);
           SetUnused(PDiagenesis^.Unused_frpop1);
           SetUnused(PDiagenesis^.Unused_frpop2);
           SetUnused(PDiagenesis^.Unused_ThtaDp);
           SetUnused(PDiagenesis^.Unused_POC1R);
           SetUnused(PDiagenesis^.Unused_KM_O2_Dp);

           If ReadVersionNum < 3.515 then
             with PDiagenesis^.H1 do
              Begin
                Val :=  0.001;
                Units := 'm';  name := 'thickness of sediment aerobic layer 1';
                Comment := '1 mm default, may be increased to speed computation time';
                Symbol := 'H1';
              End;

           If ReadVersionNum < 3.515 then
             with PDiagenesis^.Si_Diatom do
              Begin
                Val := 0.425;
                Units := 'g/g dry';  name := 'Fraction of silica in diatoms (dry)';
                Comment := 'Horne (1994) states that silica makes up 25 to 60% of the dry weight of diatoms.';
                Symbol := 'Si_Diatom';
               End;
         End;

     If Not IsTemp then PDiagenesis := Nil;
     SV.Diagenesis_Params  := PDiagenesis;

    END; {ReadVersionNum < 3.725}  ///10-28-2010  Diagenesis Parameters now segment-specific

    If ReadVersionNum>3.725 then
      Begin
        New(PDiagenesis);
        st.Read(PDiagenesis^,Sizeof(PDiagenesis^));
        SV.Diagenesis_Params  := PDiagenesis;
      End;

    If (ReadVersionNum < 3.125) and  (ReadVersionNum > 2.599) and IsTemp
      then Begin
             PSetup^.BCFUptake := False;
             PSetup^.UseExternalConcs := False;
             MessageDlg2('Uptake and toxicity options set to default values within the setup menu.'
                       ,mtinformation,[mbOK],0);

           End;

    If Not IsTemp then PSetup := Nil;
    SV.SetupRec:=PSetup;

    If IsTemp then
     If ReadVersionNum < 2.999 then
       Begin
         SV.Distributions.Destroy;
         MessageDlg2('Distribution Data is being reinitialized.'
                     ,mtinformation,[mbOK],0);
         SV.Distributions:=TDistributionList.init(30,20);
       End;

    If IsTemp then
      Begin
        New(PUncertainty);
        PUncertainty^.RandomSampling := True;
        PUncertainty^.SaveToCSV := False;
        If ReadVersionnum < 3.615 then
          Begin
            If (ReadVersionNum < 3.1999) and ((ReadVersionNum<2.79) or (ReadVersionNum>2.81))
              then with PUncertainty^ do
                Begin
                  St.Read(PUncertainty^, 16);
                  Run_Sensitivity := False;
                  NominalPercent := 10;
                  NumUncert := 0;
                  NumSens := 0;
                  For i := 1 to 100 do
                    Begin
                      SensTrack[i] := -99;
                      UncertTrack[i] := -99;
                    End;
                  LinkPeriPhyto := False;
                End
              else St.Read(PUncertainty^, 835)
          End Else Begin
                     If ReadVersionNum < 3.645
                       then St.Read(PUncertainty^, 861)
                       else If ReadVersionNum < 3.655
                          then St.Read(PUncertainty^, 862)
                          else St.Read(PUncertainty^, Sizeof(PUncertainty^));
                   End;

        If (ReadVersionNum < 3.58) and (Not PUncertainty^.Run_Sensitivity) then
          PUncertainty^.NominalPercent := 10;  {JSC Change default nominal percent to 10, 7/25/08}
        If ReadVersionNum < 3.615 then
         with PUncertainty^ do
          Begin
            AdvancedSens    := False;  {3.62}
            StartIteration  := 0;
            Processors2Use  := 1;
            StartIter       := 0;
            EndIter  := 0;
            AverageAll      := True;
            AverageYears    := 1;
          End;
      End;
    If Not IsTemp then PUncertainty := Nil;


    Location:=TAQTSite.Load(IsTemp,St,ReadVersionNum);
    Location.ChangeData(Location.Locale.ICZMean);
    SV.Location:=Location;

    If IsTemp then
      Begin
        New(PChems);
        St.Read(PChems^, Sizeof(PChems^));
        For Loop2 := FirstOrgTxTyp to LastOrgTxTyp do
           If PChems^[Loop2]<>nil then
             Begin
               PChems^[Loop2]:=nil;
               PChems^[Loop2]:=TChemical.Load(IsTemp, St,ReadVersionNum);
             End;
      End;
    If Not IsTemp then PChems := Nil;

{    If  ReadVersionNum <= 1.799 then
       Begin
         MessageDlg2('Results will not be loaded.',mtinformation,[mbOK],0);
         SV.Results[Epilimnion].FreeAll;
         SV.ControlResults[Epilimnion].FreeAll;
         SV.Results[Hypolimnion].FreeAll;
         SV.ControlResults[Hypolimnion].FreeAll;
         SV.Results[Epilimnion].Headers.FreeAll;
         SV.ControlResults[Epilimnion].Headers.FreeAll;
         SV.Results[Hypolimnion].Headers.FreeAll;
         SV.ControlResults[Hypolimnion].Headers.FreeAll;
       End; }

    IF IsTemp then
      For Loop2:= FirstOrgTxTyp to LastOrgTxTyp do
        If PChems^[Loop2]<>nil then PChems^[Loop2].ChangeData;

    SV.ChemPtrs:=PChems;

    { Set allstates, location, and chemical to the correct value }
    With SV do for i:=0 to count-1 do
      SetVars(at(i));

    {Kill the old epilimnion state variable}
    i:=0;
    While i<SV.Count do
        If TStateVariable(SV.at(i)).NState=NullStateVar then SV.AtFree(i)
                                                          else i:=i+1;

    {Setup Memory Location Record, used for quick memory access}
    SV.SetMemLocRec;

    SV.CopySuspDetrData;

    If not SV.LinkedMode and LoadDistribs then SV.Update_Distributions;  {in linked mode, segment must be shown template first}
    Unc_Dir:=''; Unc_File:=''; Unc_Ext:='';
    AllOtherSegs := nil;
    OtherFBSegs  := nil;

    If IsTemp then TemplateSeg := Self
              else TemplateSeg := Nil;

    SV.Sedlayers:=0;
    For LayerLoop := SedLayer1 to LowestLayer do
      If SV.GetStatePointer(PoreWater,StV,LayerLoop) <> nil then Inc(SV.SedLayers);

    AllSVs:=nil;
    SV.PAllSVsColl := @AllSVs;

    If IsTemp then
      If (PChems^[FirstOrgTxTyp] <> nil) and (SV.GetStatePointer(H2OTox1,StV,WaterCol)=nil) then
          PChems^[FirstOrgTxTyp] := nil;
End;

{--------------------------------------------------------------------}

Procedure TAQUATOXSegment.AddMultiAgeFish(WizardCall: Boolean);
Var Age: Integer;
    Loop, i: Integer;
    MultiFishName: String;
    BlankAgeDist: AgeDist;
    AR: ZooRecord;
    CurrState: AllVariables;
    AnimLoadOK, IsTempl, OlderAnimLoad: Boolean;
    PA: TAnimal;
    TrophDir, DBDir: String;
    TIntSave : TrophIntArray;
    LipidYOY, LipidOlder: Double;
    MWeightYOY, MWeightOlder: Double;
    MortYOY, MortOlder: Double;
    PMRTemplate : PMultiAgeInput;

    Procedure AddMultiAge(WorkingStudy: TAQUATOXSegment);
    Var ToxLoop: T_SVType;
    Begin
      With workingstudy do
        Begin
          New(SV.PMultiRec);
          With SV.PMultiRec^ do
            Begin
              If IsTempl
                then
                  Begin
                    PMRTemplate := SV.PMultiRec;
                    New(PNumAges);
                    New(PSpawnAge);
                    New(PName);
                    New(PLipidFrac);
                    New(PMortCoeff);
                    New(PMeanWeight);
                    PNumAges^   := Age;          { number of age classes tracked }
                    PSpawnAge^  := 3;            { Default }
                    PLipidFrac^ := BlankAgeDist;
                    PMortCoeff^ := BlankAgeDist;
                    PMeanWeight^:= BlankAgeDist;
                    PName^ := GetFishForm.FishName.Text;
                  End
                else
                  Begin
                    PNumAges   := PMRTemplate.PNumAges;
                    PSpawnAge  := PMRTemplate.PSpawnAge;
                    PLipidFrac := PMRTemplate.PLipidFrac;
                    PMortCoeff := PMRTemplate.PMortCoeff;
                    PMeanWeight:= PMRTemplate.PMeanWeight;
                    PName      := PMRTemplate.PName;
                  End;

              InitCond  := BlankAgeDist;
              Loadings  := BlankAgeDist;
              For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
                Begin
                  ChemIC[ToxLoop]   := BlankAgeDist;
                  ChemLoad[ToxLoop] := BlankAgeDist;
                End;

              Loop:=0;
              CurrState := Fish1;
              Repeat
                AddStateVariable(CurrState,WaterCol,0,IsTempl);
                SV.SetMemLocRec;
                Inc(Loop);
                Inc(CurrState);
              Until (Loop=Age);
            End;
        End;
    End;

Begin
  Application.CreateForm(TGetFishForm, GetFishForm);

  Age := GetFishForm.RetFishAge;
  If Age=0 then Begin GetFishForm.Free; exit;  End;

  BlankAgeDist.UserDefined:=True;
  BlankAgeDist.DType := Normal;
  For Loop := 1 to 4 do
    BlankAgeDist.Parm[Loop] := 0;
  For Loop:= 1 to 15 do
    BlankAgeDist.Vals[Loop] := 0;
  BlankAgeDist.LoadNotes1 := '';
  BlankAgeDist.LoadNotes2 := '';

  IsTempl := True;
  If SV.LinkedMode
    then For i := -1 to AllOtherSegs.Count-1 do
          Begin
            IsTempl := (i=-1);
            If IsTempl then AddMultiAge(TemplateSeg)
                       else AddMultiAge(AllOtherSegs.At(i));
          End
    else AddMultiAge(Self);
  GetFishForm.Free;

  Application.CreateForm(TDb_GetEntry, Db_GetEntry); 

  If WizardCall
    then  With Wiz_GetEntry do
      Begin
        Header.Caption := 'Select the fish species data you wish to use for the YOY multi-age class fish.';
        If Not GetEntry(3) then AnimLoadOK := False
                           else AnimLoadOK := DBase_To_AnimalRecord(Default_Dir,'Animal.ADB',Entry,-1,AR);
        DBDir := Default_Dir;
      End
    else With Db_GetEntry do
      Begin
        HeadString:='Select Fish Species Data for the Multi-Age Fish: YOY';
        Filter:='Animal DBs (*.adb)|*.ADB|';
        DefaultDbName:='Animal.ADB';
        If Not GetEntry Then AnimLoadOK := False
                        Else AnimLoadOK := DBase_To_AnimalRecord(FileDir,FileName,Entry,-1,AR);
        DBDir := FileDir;
      End;

  DB_GetEntry.Free;

  AR.UseAllom_C := True;  {allometric always used with multi age fish}
  AR.UseAllom_R := True;  {allometric always used with multi age fish}
  LipidYOY   := AR.FishFracLipid;
  MortYOY    := AR.KMort;
  MWeightYOY := AR.MeanWeight;

  PA := SV.GetStatePointer(Fish1,StV,WaterCol);
  PA.PHasData^:=AnimLoadOK;
  PA.PName^ := 'Age-Class Fish: ';
  If AnimLoadOK then Begin
                       PA.PAnimalData^ := AR;
                       PA.ChangeData;
                     End;
  If AnimLoadOK then
    Begin
       If DirectoryExists(DBDir+'\Trophint')
           then TrophDir := DBDir+'\Trophint\'
           else TrophDir := DBDir+'\';
       If not PA.ReadTrophInt(TrophDir+AR.AnimalName+'.int')
         then MessageDlg2('Warning, cannot read trophic interaction file for Animal '+PA.PAnimalData^.AnimalName
                         +'.  Trophic interactions are set to zero.',mtwarning,[mbok],0);
    End;

  MultiFishName := PA.PAnimalData^.AnimalName;
  If Pos('YOY',MultiFishName)>0 then Delete(MultiFishName,Pos('YOY',MultiFishName),3);
  If Pos(',',MultiFishName)>0 then Delete(MultiFishName,Pos(',',MultiFishName),1);
  Trim(MultiFishName);
  SV.PMultiRec^.PName^ := MultiFishName;
  PA.PName^ := PA.PName^ + '['+MultiFishName+']';

  LipidOlder  := AR.FishFracLipid;
  MortOlder   := AR.KMort;
  MWeightOlder:= AR.MeanWeight;
  AR.UseAllom_C := True;  {allometric always used with multi age fish}
  AR.UseAllom_R := True;  {allometric always used with multi age fish}


  Application.CreateForm(TDb_GetEntry, Db_GetEntry);

  OlderAnimLoad := AnimLoadOK;
  If AnimLoadOK then
   If MessageDlg2('Do you wish to load a different set of species data for age classes that are over one year?',mtconfirmation,[mbyes,mbno],0) = mryes
    Then
      If WizardCall
        Then With Wiz_GetEntry do
          Begin
            Header.Caption := 'Select the fish species data you wish to use for the older multi-age class fish.';
            If Not GetEntry(3) then OlderAnimLoad := False
                               else OlderAnimLoad := DBase_To_AnimalRecord(Default_Dir,'Animal.ADB',Entry,-1,AR);
            DBDir := Default_Dir;
          End
        Else With Db_GetEntry do
          Begin
           HeadString:='Select Animal Entry to Load into older fish:';
            Filter:='Animal DBs (*.adb)|*.ADB|';
            DefaultDbName:='Animal.ADB';
            If Not GetEntry Then OlderAnimLoad := False
                            Else OlderAnimLoad := DBase_To_AnimalRecord(FileDir,FileName,Entry,-1,AR);
            DBDir := FileDir;
          End;

  DB_GetEntry.Free;

  Loop:=1;
  CurrState := Fish2;
  Repeat
    PA := SV.GetStatePointer(CurrState,StV,WaterCol);
    PA.PHasData^:=OlderAnimLoad;
    If AnimLoadOK then Begin
                         PA.PAnimalData^ := AR;
                         PA.ChangeData;
                       End;

    If (CurrState=Fish2) and OlderAnimLoad
      then
        Begin
          If DirectoryExists(DBDir+'\Trophint')
              then TrophDir := DBDir+'\Trophint\'
              else TrophDir := DBDir+'\';
          If not PA.ReadTrophInt(TrophDir+PA.PAnimalData^.AnimalName+'.int')
             then MessageDlg2('Warning, cannot read trophic interaction file for Animal '+PA.PAnimalData^.AnimalName
                             +'.  Trophic interactions are set to zero.',mtwarning,[mbok],0);
          TIntSave := PA.PTrophInt^;
        End
      else PA.PTrophInt^ := TIntSave;

    Inc(Loop);
    Inc(CurrState);
  Until (Loop=Age);

  SV.PMultiRec^.PLipidFrac^.Vals[1] := LipidYOY;
  SV.PMultiRec^.PMortCoeff^.Vals[1] := MortYOY;
  SV.PMultiRec^.PMeanWeight^.Vals[1]:= MWeightYOY;

  For Loop:=2 to 15 do
    Begin
      SV.PMultiRec^.PLipidFrac^.Vals[Loop]  := LipidOlder;
      SV.PMultiRec^.PMortCoeff^.Vals[Loop]  := MortOlder;
      SV.PMultiRec^.PMeanWeight^.Vals[Loop] := MWeightOlder;
    End;

End;

{--------------------------------------------------------------------}

Procedure TAQUATOXSegment.Add_OrgTox_SVs(State: StateVariables;ChemNm: String);

Var   ChemLoadOK : Boolean;
      ToxAddLoop : StateVariables;
      ToxSedLoop : T_SVLayer;
      p          : Pointer;
      ToxType    : T_SVType;
      Loop       : Integer;
      AlterStudy : TAQUATOXSegment;
      IsTempl    : Boolean;

Begin
    LastChange := Now;
    If ControlRun > 0 then ControlRun := -3;
    ToxType := AssocToxTyp(State);

    If PChems^[ToxType]<>nil then PChems^[ToxType].Destroy;
    PChems^[ToxType] := TChemical.init;

    Application.CreateForm(TDb_GetEntry, Db_GetEntry);
    With Db_GetEntry do
     Begin
       If ChemNm='' then ChemNm := StateText(State,StV,WaterCol);
       HeadString:='Select Chemical Parameter Data to Load into '+ChemNm+':';
       If ChemNm='Point Source' then HeadString:='Select Organic Chem. Data to Represent Selected Point Source:';
       Filter:='Chemical DBs (*.cdb)|*.CDB|';
       DefaultDbName:='Chemical.CDB';
       If Not GetEntry
         Then
           Begin
             Fillchar(PChems^[ToxType].ChemRec,Sizeof(PChems^[ToxType].ChemRec),' ');
             With PChems^[ToxType].ChemRec do
               Begin
                  ChemName := 'Unspecified';
                  MolWt                := 0;
                  Solubility           := 0;
                  Henry                := 0;
                  pka                  := 0;
                  VPress               := 0;
                  LogKow               := 0; {Log KOW, log octanol water part. coeff.}
                  En                   := 0; {Activation Energy for Temperature}
                  KMDegrdn             := 0;
                  KMDegrAnaerobic      := 0;
                  KUnCat               := 0;
                  KAcid                := 0;
                  KBase                := 0;
                  PhotolysisRate       := 0;
                  OxRateConst          := 0;
                  KPSed                := 0;
                  Weibull_Shape        := 0;
               End;
             ChemLoadOK := False;
           End
         Else
           Begin
             {Load Selected Chemical}
             ChemLoadOK := DBase_To_ChemRecord(FileDir,FileName,Entry,-1,PChems^[ToxType].ChemRec);
             If FileDir + '\' =Default_Dir then FileDir := FileDir +'\ChemToxDBs';
             SV.ChemPtrs^[ToxType].Dbase_To_AnimToxColl(FileDir,Entry+'_Animal_Tox.DB');
             SV.ChemPtrs^[ToxType].Dbase_To_PlantToxColl(FileDir,Entry+'_Plant_Tox.DB');
             If ChemLoadOK then PChems^[ToxType].ChangeData;
           End;
     End; {with}

    If not ChemLoadOK
     Then Begin
            If PChems^[ToxType]<>nil then PChems^[ToxType].Destroy;
            PChems^[ToxType] := nil;
          End
     Else If SV.LinkedMode then
       For Loop:=-1 to AllOtherSegs.Count-1 do
        Begin
          IsTempl := (Loop=-1);
          If IsTempl then AlterStudy := TemplateSeg
                     else AlterStudy := AllOtherSegs.At(Loop);
          With AlterStudy do
            Begin
              {Add the OrgTox}
              AddStateVariable(State,WaterCol,0,IsTempl);
              SV.SetMemLocRec;

              TStateVariable(SV.GetStatePointer(State,StV,WaterCol)).PHasData^:=ChemLoadOK;

              {For each state variable, add associated toxicant if relevant}
              For ToxAddLoop := FirstState to LastState do
               For ToxSedLoop := WaterCol to SedLayer10 do
                 Begin
                   p := SV.GetStatePointer(ToxAddLoop,StV,ToxSedLoop);
                   If p<>nil then AddOrgToxStateVariable(ToxAddLoop,ToxSedLoop,ToxType,IsTempl);
                 End;

              SV.SetMemLocRec;
            End;
        End {Linked Mode}
      Else
        Begin
          {Add the OrgTox}
          AddStateVariable(State,WaterCol,0,True);
          SV.SetMemLocRec;

          If ChemLoadOK then PChems^[ToxType].ChangeData;
          TStateVariable(SV.GetStatePointer(State,StV,WaterCol)).PHasData^:=ChemLoadOK;

          {For each state variable, add associated toxicant if relevant}
          For ToxAddLoop := FirstState to LastState do
           For ToxSedLoop := WaterCol to SedLayer10 do
             Begin
               p := SV.GetStatePointer(ToxAddLoop,StV,ToxSedLoop);
               If p<>nil then AddOrgToxStateVariable(ToxAddLoop,ToxSedLoop,ToxType,True);
             End;

          SV.SetMemLocRec;
        End;

  Db_GetEntry.Free;

End;

{------------------------------------------------------------------------------------------------}


Procedure TAQUATOXSegment.Add_Internal_Nutrients;
Var PLoop  : AllVariables;
    TP: TPlant;
    Addme: Boolean;
Begin
   For PLoop :=  FirstPlant to LastPlant do
     Begin
       TP := SV.GetStatePointer(PLoop,StV,WaterCol);
       If TP<>nil then
         Begin
           Addme := True;
           If TP.IsMacrophyte then
             If  not (TMacrophyte(TP).MacroType= FreeFloat) then Addme := False;  //add floating but not others
           If Addme then Addme := SV.GetStatePointer(PLoop,NIntrnl,WaterCol) = nil;

           If Addme then AddInternalNutSVs(PLoop,(TemplateSeg=Self))
         End;
     End;
End;

Procedure TAQUATOXSegment.Remove_Internal_Nutrients;
Var PLoop  : AllVariables;
Begin
  For PLoop := FirstPlant to LastPlant do
   If SV.GetStatePointer(PLoop,NIntrnl,WaterCol) <> nil
    then RemoveInternalNutSVs(PLoop);
End;

Procedure TAQUATOXSegment.Adjust_Internal_Nutrients;
// If internal nutrients are modeled, checks to see if plant types have changed thus requiring a change in state variables (rooted macrophytes don't have internal Nut SVs.)
Var PLoop  : AllVariables;
    TP: TPlant;
    Removeme: Boolean;
Begin
  If not PSetup^.Internal_Nutrients then exit;

  Add_Internal_Nutrients; // only adds internal nutrients if they don't already exist for the plant (exclude rooted macro.)
  For PLoop :=  FirstPlant to LastPlant do
    Begin
      TP := SV.GetStatePointer(PLoop,StV,WaterCol);
      If TP<>nil then
        Begin
          Removeme := False;
          If TP.IsMacrophyte then
            If not (TMacrophyte(TP).MacroType= FreeFloat) then Removeme := True;  //Remove internal nutrients from rooted & benthic macrophytes
          If Removeme then Removeme := SV.GetStatePointer(PLoop,NIntrnl,WaterCol) <> nil;

          If Removeme then RemoveInternalNutSVs(PLoop);
        End;
     End;
End;

{------------------------------------------------------------------------------------------------}

Procedure TAQUATOXSegment.Remove_Sediment_Model;
Var TypLoop  : T_SVType;
    CosLoop  : AllVariables;
    LayLoop  : T_SVLayer;

Begin
  SV.SedLayers := 0;

  {Delete Cohesives, NonCohesives, Porewater, BuriedSedDetr & Assoc Tox in each layer}
   For TypLoop := STV to LastToxTyp do
    For CosLoop := PoreWater to SedmLabDetr do
     For LayLoop := WaterCol to SedLayer10 do
      If (CosLoop<SedmRefrDetr) or (LayLoop>WaterCol) then {Don't delete SedDetr or SedDetrTox in water column}
        RemoveStateVariable(CosLoop,TypLoop,LayLoop);

End;

{------------------------------------------------------------------------------------------------}

Procedure TAQUATOXSegment.Add_Sediment_Model;
Var TypLoop  : T_SVType;
    CosLoop  : AllVariables;
    IsTempl  : Boolean;
Begin
  IsTempl := (TemplateSeg=Self);

  {Delete BuriedRefrDetr & BuriedLabDetr}
   For TypLoop := STV to LastToxTyp do
    For CosLoop := BuriedRefrDetr to BuriedLabileDetr do
      RemoveStateVariable(CosLoop,TypLoop,WaterCol);


  SV.SedNonReactive := False;
  SV.SedLayers := 1;

  AddStateVariable(Cohesives,WaterCol,0,IsTempl);     {Sediments in water column}
  AddStateVariable(NonCohesives,WaterCol,0,IsTempl);
  AddStateVariable(NonCohesives2,WaterCol,0,IsTempl);

  AddStateVariable(Cohesives,SedLayer1,0,IsTempl);    {Sediments in the first layer}
  AddStateVariable(NonCohesives,SedLayer1,0,IsTempl);
  AddStateVariable(NonCohesives2,SedLayer1,0,IsTempl);

  AddStateVariable(PoreWater,SedLayer1,0,IsTempl);    {Pore Waters in the first layer}
  AddStateVariable(LaDOMPore,SedLayer1,0,IsTempl);     {Labile DOM in Pore Waters in the first layer}
  AddStateVariable(ReDOMPore,SedLayer1,0,IsTempl);     {Refr DOM in Pore Waters in the first layer}
  {Active layer of detritus already included in the "water column" layer as sedrefrdetr/sedlabiledetr}
End;

{--------------------------------------------------------------------}
Procedure TAQUATOXSegment.Remove_Diagenesis_Model;
Var TypLoop  : T_SVType;
    CosLoop  : AllVariables;
    LayLoop  : T_SVLayer;
    IsTempl  : Boolean;
Begin
  IsTempl := (TemplateSeg=Self);
  {Add SedRefrDetr & SedLabDetr}
  AddStateVariable(SedmRefrDetr,WaterCol,0,IsTempl);
  AddStateVariable(SedmLabDetr,WaterCol,0,IsTempl);

  {Delete Sediment Vars}
   For TypLoop := STV to LastToxTyp do
    For CosLoop := Ammonia to BuriedLabileDetr do
     For LayLoop := SedLayer1 to SedLayer2 do
       RemoveStateVariable(CosLoop,TypLoop,LayLoop);

  RemoveStateVariable(COD,StV,WaterCol);

End;

{--------------------------------------------------------------------}
Procedure TAQUATOXSegment.Add_Diagenesis_Model;
Var TypLoop  : T_SVType;
    CosLoop  : AllVariables;
    IsTempl  : Boolean;
Begin
  IsTempl := (TemplateSeg=Self);

  {Delete BuriedRefrDetr & BuriedLabDetr}
   For TypLoop := STV to LastToxTyp do
    For CosLoop := BuriedRefrDetr to BuriedLabileDetr do
      RemoveStateVariable(CosLoop,TypLoop,WaterCol);

  {Delete SedRefrDetr & SedLabDetr}
   For TypLoop := STV to LastToxTyp do
    For CosLoop := SedmRefrDetr to SedmLabDetr do
      RemoveStateVariable(CosLoop,TypLoop,WaterCol);

  SV.SedNonReactive := False;
  SV.SedLayers := 0;

  AddStateVariable(COD,WaterCol,1.3,IsTempl);
  AddStateVariable(Sulfide,SedLayer1,0,IsTempl);
  AddStateVariable(Sulfide,SedLayer2,0,IsTempl);
  AddStateVariable(Avail_Silica,SedLayer2,0,IsTempl);
  AddStateVariable(Silica,SedLayer1,0,IsTempl);
  AddStateVariable(Silica,SedLayer2,0,IsTempl);
  AddStateVariable(Methane,SedLayer2,0.1,IsTempl);
  AddStateVariable(POC_G1 ,SedLayer2,28,IsTempl);
  AddStateVariable(POC_G2 ,SedLayer2,23,IsTempl);
  AddStateVariable(POC_G3 ,SedLayer2,18,IsTempl);
  AddStateVariable(PON_G1 ,SedLayer2,41,IsTempl);
  AddStateVariable(PON_G2 ,SedLayer2,42,IsTempl);
  AddStateVariable(PON_G3 ,SedLayer2,17,IsTempl);
  AddStateVariable(POP_G1 ,SedLayer2,0.6,IsTempl);
  AddStateVariable(POP_G2 ,SedLayer2,0.5,IsTempl);
  AddStateVariable(POP_G3 ,SedLayer2,0.4,IsTempl);
  AddStateVariable(Ammonia,SedLayer1,0.1,IsTempl);
  AddStateVariable(Ammonia,SedLayer2,4.5,IsTempl);
  AddStateVariable(Nitrate,SedLayer1,0.1,IsTempl);
  AddStateVariable(Nitrate,SedLayer2,0.01,IsTempl);
  AddStateVariable(Phosphate,SedLayer1,0.01,IsTempl);
  AddStateVariable(Phosphate,SedLayer2,0.2,IsTempl);

End;


{--------------------------------------------------------------------}
Procedure TAQUATOXSegment.Remove_Sediment_Layer;
Var TypLoop  : T_SVType;
    CosLoop  : AllVariables;
    DelLyr   : T_SVLayer;

Begin
  If SV.SedLayers=1 then EAQUATOXERROR.Create('Remove_Sediment_Layer cannot be called with only one layer left');

  DelLyr := T_SVLayer(SV.SedLayers);
 {Delete Cohesives, NonCohesives, Porewater, BuriedSedDetr & Assoc Tox for this layer}
  For TypLoop := STV to LastToxTyp do                                     
   For CosLoop := PoreWater to SedmLabDetr do
     RemoveStateVariable(CosLoop,TypLoop,DelLyr);

  SV.SedLayers := SV.SedLayers-1;
End;
{------------------------------------------------------------------------------------------------}
Procedure TAQUATOXSegment.Add_Sediment_Layer;
Var AddLyr : T_SVLayer;
    IsTempl: Boolean;
Begin
  IsTempl := (TemplateSeg=Self);
  If SV.SedLayers=Num_SVLayers
     then EAQUATOXERROR.Create('Add_Sediment_Layer Error: no more than '+IntToStr(Num_SVLayers)+' layers allowed');

  SV.SedLayers := SV.SedLayers+1;
  AddLyr := T_SVLayer(SV.SedLayers);

  AddStateVariable(Cohesives,AddLyr,0,IsTempl);    {Sediments in the added layer}
  AddStateVariable(NonCohesives,AddLyr,0,IsTempl);
  AddStateVariable(NonCohesives2,AddLyr,0,IsTempl);

  AddStateVariable(PoreWater,AddLyr,0,IsTempl);    {Pore Waters in the added layer}

  AddStateVariable(LaDOMPore,AddLyr,0,IsTempl);      {Labile DOM in Pore Waters in the added layer}
  AddStateVariable(ReDOMPore,AddLyr,0,IsTempl);       {Refr DOM in Pore Waters in the added layer}
  AddStateVariable(SedmRefrDetr,AddLyr,0,IsTempl);     {Sed R Detr in the added layer}
  AddStateVariable(SedmLabDetr,AddLyr,0,IsTempl);    {Sed L Detr in the added layer}
End;
{------------------------------------------------------------------------------------------------}


Procedure TAQUATOXSegment.Remove_OrgTox_SVs(State: StateVariables);
Var SelectedIndex: Integer;
    ToxType:       T_SVType;
    Loop:          Integer;

    Procedure DeleteChemFrom(WorkingStudy: TAQUATOXSegment);
    Var ToxDelLoop:    StateVariables;
        LayerLoop:     T_SVLayer;
    Begin
      With workingstudy do
        Begin
         {Delete Chemical Object}
         SV.AtFree(SelectedIndex);
         SV.SetMemLocRec;
         If PChems^[ToxType]<>nil then PChems^[ToxType].Destroy;
         PChems^[ToxType] := nil;

         {For each state variable, Delete OrgTox associated toxicant if relevant}
         For ToxDelLoop := FirstState to LastState do
          For LayerLoop := WaterCol to SedLayer10 do
            RemoveStateVariable(ToxDelLoop,ToxType,LayerLoop);
        End;
    End;

Begin
   {Confirm this is what the user wants to do}
   If (MessageDlg2('Delete '+StateText(State,StV,WaterCol)+ ' and all associated state variables?',
                  MTConfirmation, [MbYes,MbCancel], 0) = MrCancel) then exit;
   LastChange := Now;
   ToxType := AssocToxTyp(State);

   SelectedIndex:=SV.GetIndex(State,StV,WaterCol);
   {Error Checking}
   If SelectedIndex=-1 then
         Begin
           MessageDlg2('AQUATOX Internal Error: Toxicant Delete Item Missing',mterror,[mbOK],0);
           Exit;
         End;

   If SV.LinkedMode then
     For Loop:=-1 to AllOtherSegs.Count-1 do
       If Loop=-1 then DeleteChemFrom(TemplateSeg)
                  else DeleteChemFrom(AllOtherSegs.At(Loop));

   If Not SV.LinkedMode then DeleteChemFrom(Self);
End;

{------------------------------------------------------------------------------------------------}

Procedure TAQUATOXSegment.ShowTemplate(Template: TAQUATOXSegment; Var ErrorMessage: String; Disp,CopyInit: Boolean);
{ Takes a full study and enslaves it to the template study that is passed as a parameter}
{ Disposes of redundant info and points the pointers back to the template study instead }

Var Loop  : Integer;
    Loop2 : T_SVType;
    PSV, TSV : TStateVariable;
    MissingText : String;
Begin
  ErrorMessage := '';

  TemplateSeg := Template;
  AllOtherSegs := Template.AllOtherSegs;

  If Disp then if PUncertainty<>nil then Dispose(PUncertainty);
  PUncertainty := Template.PUncertainty;

  If Disp then if PSetup<>nil then Dispose(PSetup);
  PSetup := Template.PSetup;

//  If Disp then if PDiagenesis<>nil then Dispose(PDiagenesis);
//  PDiagenesis := Template.PDiagenesis;
  If PDiagenesis = nil then        //10-28-2010  diagenesis params. now seg. specific
    Begin
      new(PDiagenesis);
      PDiagenesis^ := Template.PDiagenesis^;
      SV.Diagenesis_Params := PDiagenesis;
    End;

  If Disp then if PChems<>nil then
   For Loop2 := FirstOrgTxTyp to LastOrgTxTyp do
     If PChems^[Loop2]<>nil then PChems^[Loop2].Destroy;
  If Disp then if PChems<>nil then Dispose(PChems);
  PChems := Template.PChems;

  AllSVs := Template.AllSVs;
  SV.PAllSVsColl := @AllSVs;

  With SV do
    Begin
      IF XSecData = nil then XSecData := TLoadings.Init(5,5);  {9/13/07}

      PStatesTemplate := Template.SV;

      If Disp then If PMessageStr<>nil then Dispose(PMessageStr);
      PMessageStr := Template.SV.PMessageStr;
      If Disp then If PMessageErr<>nil then Dispose(PMessageErr);
      PMessageErr := Template.SV.PMessageErr;

      If Disp then If ProgData<>nil then Dispose(ProgData);
      ProgData := Template.SV.ProgData;
      If Disp then If PRateInfo<>nil then Dispose(PRateInfo);
      PRateInfo := PStatesTemplate.PRateInfo;
      If Disp then If PControlInfo<>nil then Dispose(PControlInfo);
      PControlInfo := PStatesTemplate.PControlInfo;

      If Disp then If PModelTimeStep<>nil then Dispose(PModelTimeStep);
      PModelTimeStep := PStatesTemplate.PModelTimeStep;

      If Disp then If PSavePPB<>nil then Dispose(PSavePPB);
      PSavePPB := PStatesTemplate.PSavePPB;
      If Disp then If PSaveBAFs<>nil then Dispose(PSaveBAFs);
      PSaveBAFs := PStatesTemplate.PSaveBAFs;

      ChemPtrs := PChems;
      SetupRec := PSetup;
//      Diagenesis_Params  := PDiagenesis;

      If PMultiRec <> nil then
        Begin
          PMultiRec^.PNumAges := PStatesTemplate.PMultiRec^.PNumAges;
          PMultiRec^.PSpawnAge := PStatesTemplate.PMultiRec^.PSpawnAge;
          PMultiRec^.PName      := PStatesTemplate.PMultiRec^.PName;
          PMultiRec^.PLipidFrac := PStatesTemplate.PMultiRec^.PLipidFrac;
          PMultiRec^.PMortCoeff := PStatesTemplate.PMultiRec^.PMortCoeff;
          PMultiRec^.PMeanWeight := PStatesTemplate.PMultiRec^.PMeanWeight;
        End;

      For Loop := 0 to Count-1 do
        Begin
          PSV := At(Loop);
          TSV := PStatesTemplate.GetStatePointer(PSV.NState,PSV.SVType,PSV.Layer);
          If (TSV=nil) then
            Begin
              MissingText := OutputText(PSV.Nstate,PSV.SVType,PSV.Layer,'',False,False,0);
              ErrorMessage := 'The new study has State Variable ['+MissingText+
                              '] which is not in the Linked Study Template.';
              Exit;
            End;

          If CopyInit and (PSV.IsAnimal or PSV.IsPlant) then PSV.InitialCond := TSV.InitialCond;
          PSV.IsTemplate := False;
          If Disp then If PSV.PShowRates<>nil then Dispose(PSV.PShowRates);
          PSV.PShowRates := TSV.PShowRates;
          If Disp then If PSV.PTrackResults<>nil then Dispose(PSV.PTrackResults);
          PSV.PTrackResults := TSV.PTrackResults;
          If Disp then If PSV.PHasData<>nil then Dispose(PSV.PHasData);
          PSV.PHasData := TSV.PHasData;
          If Disp then If PSV.PRequiresData<>nil then Dispose(PSV.PRequiresData);
          PSV.PRequiresData := TSV.PRequiresData;
          If Disp then If PSV.PName<>nil then Dispose(PSV.PName);
          PSV.PName := TSV.PName;

          PSV.ChemPtrs := PChems;

          If PSV.IsAnimal then
            Begin
               If Disp then If TAnimal(PSV).PAnimalData<>nil then Dispose(TAnimal(PSV).PAnimalData);
               TAnimal(PSV).PAnimalData := TAnimal(TSV).PAnimalData;
               If Disp then If TAnimal(PSV).PTrophInt<>nil then Dispose(TAnimal(PSV).PTrophInt);
               TAnimal(PSV).PTrophInt := TAnimal(TSV).PTrophInt;
               If Disp then If TAnimal(PSV).PSameSpecies<>nil then Dispose(TAnimal(PSV).PSameSpecies);
               TAnimal(PSV).PSameSpecies := TAnimal(TSV).PSameSpecies;
            End;

          If PSV.IsPlant then
            Begin
               If Disp then If TPlant(PSV).PAlgalRec<>nil then Dispose(TPlant(PSV).PAlgalRec);
               TPlant(PSV).PAlgalRec := TPlant(TSV).PAlgalRec;
               If Disp then If TPlant(PSV).PSameSpecies<>nil then Dispose(TPlant(PSV).PSameSpecies);
               TPlant(PSV).PSameSpecies := TPlant(TSV).PSameSpecies;
            End;

        End;

      {Cross Check Template Validity}
      For Loop := 0 to PStatesTemplate.Count-1 do
        Begin
          TSV := PStatesTemplate.At(Loop);
          PSV := GetStatePointer(TSV.NState,TSV.SVType,TSV.Layer);
          If (PSV=nil) then
            Begin
              MissingText := OutputText(TSV.Nstate,TSV.SVType,TSV.Layer,'',False,False,0);
              ErrorMessage := 'The Linked Study Template has State Variable ['+MissingText+
                              '] but the new study does not have this SV.';
              Exit;
            End;
        End;
    End;
End;

{------------------------------------------------------------------------------------------------}

Procedure TAQUATOXSegment.TakeParameters(InputStudy: TAQUATOXSegment; Var ErrorMessage: String; CopyInit: Boolean);
{ Takes a study that has been loaded into memory (InputStudy) and borrows all "global"
  non-segment-specific parameters from it. Opposite of ShowTemplate above.   }

Var Loop  : Integer;
    Loop2 : T_SVType;
    PSV, ISSV : TStateVariable;
    MissingText : String;
Begin
  ErrorMessage := '';

(*  If PDiagenesis<>nil then Dispose(PDiagenesis);
  PDiagenesis := InputStudy.PDiagenesis;
  SV.Diagenesis_Params  := PDiagenesis;    //bug fix 3/19/2010
  InputStudy.PDiagenesis := nil; *)   //10-28 diagenesis now segment specific

  If PChems<>nil then
   For Loop2 := FirstOrgTxTyp to LastOrgTxTyp do
     If PChems^[Loop2]<>nil then PChems^[Loop2].Destroy;

  If PChems<>nil then Dispose(PChems);
  PChems := InputStudy.PChems;
  InputStudy.PChems := nil;

  With SV do
    Begin
      IF XSecData = nil then XSecData := TLoadings.Init(5,5);  {9/13/07}

      If PControlInfo<>nil then Dispose(PControlInfo);
      PControlInfo := InputStudy.SV.PControlInfo;
      InputStudy.SV.PControlInfo := nil;

      If PModelTimeStep<>nil then Dispose(PModelTimeStep);
      PModelTimeStep := InputStudy.SV.PModelTimeStep;
      InputStudy.SV.PModelTimeStep := nil;

      If PSavePPB<>nil then Dispose(PSavePPB);
      PSavePPB := InputStudy.SV.PSavePPB;
      InputStudy.SV.PSavePPB := nil;

      If PSaveBAFs<>nil then Dispose(PSaveBAFs);
      PSaveBAFs := InputStudy.SV.PSaveBAFs;
      InputStudy.SV.PSaveBAFs := nil;

      If PMultiRec <> nil then with PMultiRec^ do
        Begin
          Dispose(PNumAges);
          Dispose(PSpawnAge);
          Dispose(PName);
          Dispose(PLipidFrac);
          Dispose(PMortCoeff);
          Dispose(PMeanWeight);
          Dispose(PMultiRec);
        End;
      If InputStudy.SV.PMultiRec <> nil then
        Begin
          New(PMultiRec);
          New(PMultiRec^.PNumAges);
          New(PMultiRec^.PSpawnAge);
          New(PMultiRec^.PName);
          New(PMultiRec^.PLipidFrac);
          New(PMultiRec^.PMortCoeff);
          New(PMultiRec^.PMeanWeight);
          PMultiRec^.PNumAges   := InputStudy.SV.PMultiRec^.PNumAges;
          PMultiRec^.PSpawnAge  := InputStudy.SV.PMultiRec^.PSpawnAge;
          PMultiRec^.PName      := InputStudy.SV.PMultiRec^.PName;
          PMultiRec^.PLipidFrac := InputStudy.SV.PMultiRec^.PLipidFrac;
          PMultiRec^.PMortCoeff := InputStudy.SV.PMultiRec^.PMortCoeff;
          PMultiRec^.PMeanWeight := InputStudy.SV.PMultiRec^.PMeanWeight;
          InputStudy.SV.PMultiRec^.PNumAges := nil;
          InputStudy.SV.PMultiRec^.PSpawnAge := nil;
          InputStudy.SV.PMultiRec^.PName := nil;
          InputStudy.SV.PMultiRec^.PLipidFrac := nil;
          InputStudy.SV.PMultiRec^.PMortCoeff := nil;
          InputStudy.SV.PMultiRec^.PMeanWeight := nil;
        End
            else PMultiRec := nil;

      For Loop := 0 to Count-1 do
        Begin
          PSV := At(Loop);
          ISSV := InputStudy.SV.GetStatePointer(PSV.NState,PSV.SVType,PSV.Layer);
          If (ISSV=nil) then
            Begin
              MissingText := OutputText(PSV.Nstate,PSV.SVType,PSV.Layer,'',False,False,0);
              ErrorMessage := 'The main study has State Variable ['+MissingText+
                              '] which is not in the Input Study.';
              InputStudy.Destroy;
              Exit;
            End;

          If CopyInit and (PSV.IsAnimal or PSV.IsPlant) then PSV.InitialCond := ISSV.InitialCond;

          If PSV.PShowRates<>nil then Dispose(PSV.PShowRates);
          PSV.PShowRates := ISSV.PShowRates;
          ISSV.PShowRates := nil;

          If PSV.PTrackResults<>nil then Dispose(PSV.PTrackResults);
          PSV.PTrackResults := ISSV.PTrackResults;
          ISSV.PTrackResults := nil;

          If PSV.PHasData<>nil then Dispose(PSV.PHasData);
          PSV.PHasData := ISSV.PHasData;
          ISSV.PHasData := nil;

          If PSV.PRequiresData<>nil then Dispose(PSV.PRequiresData);
          PSV.PRequiresData := ISSV.PRequiresData;
          ISSV.PRequiresData := nil;

          If PSV.PName<>nil then Dispose(PSV.PName);
          PSV.PName := ISSV.PName;
          ISSV.PName := nil;

          If PSV.IsAnimal then
            Begin
               If TAnimal(PSV).PAnimalData<>nil then Dispose(TAnimal(PSV).PAnimalData);
               TAnimal(PSV).PAnimalData := TAnimal(ISSV).PAnimalData;
               TAnimal(ISSV).PAnimalData := nil;

               If TAnimal(PSV).PTrophInt<>nil then Dispose(TAnimal(PSV).PTrophInt);
               TAnimal(PSV).PTrophInt := TAnimal(ISSV).PTrophInt;
               TAnimal(ISSV).PTrophInt := nil;

               If TAnimal(PSV).PSameSpecies<>nil then Dispose(TAnimal(PSV).PSameSpecies);
               TAnimal(PSV).PSameSpecies := TAnimal(ISSV).PSameSpecies;
               TAnimal(ISSV).PSameSpecies := nil;
            End;

          If PSV.IsPlant then
            Begin
               If TPlant(PSV).PAlgalRec<>nil then Dispose(TPlant(PSV).PAlgalRec);
               TPlant(PSV).PAlgalRec := TPlant(ISSV).PAlgalRec;
               TPlant(ISSV).PAlgalRec := nil;

               If TPlant(PSV).PSameSpecies<>nil then Dispose(TPlant(PSV).PSameSpecies);
               TPlant(PSV).PSameSpecies := TPlant(ISSV).PSameSpecies;
               TPlant(ISSV).PSameSpecies := nil;
            End;

        End;

      {Cross Check Template Validity}
      For Loop := 0 to InputStudy.SV.Count-1 do
        Begin
          ISSV := InputStudy.SV.At(Loop);
          PSV := GetStatePointer(ISSV.NState,ISSV.SVType,ISSV.Layer);
          If (PSV=nil) then
            Begin
              MissingText := OutputText(ISSV.Nstate,ISSV.SVType,ISSV.Layer,'',False,False,0);
              ErrorMessage := 'The Input Study Template has State Variable ['+MissingText+
                              '] but the main study does not have this SV.';
              InputStudy.Destroy;
              Exit;
            End;
        End;
    End;

  InputStudy.Destroy;
End;

{-------------------------------------------------------------------------------}

Procedure TAQUATOXSegment.WriteRatesToDB(TimeIndex: TDateTime; RKQSHypo: Boolean; hdid: Double);

Var Table: TTable;
    WorkingTStates: TStates;
    RCount, Num_Rates_Per_File: Integer;
    NumFiles: Integer;
    AddCount: Integer;
    FirstInFile: Boolean;
    PS: TStateVariable;
    ns: AllVariables;
    Typ: T_SvType;
    Lyr: T_SVLayer;
    WriteIndex,SegIndex : Integer;
    StopRepeat:  Boolean;
   {-------------------------------------------------------------}
   Procedure Count_Num_To_Write;
   Var i : integer;
       PS: TStateVariable;
   Begin
     {With WorkingTStates.PRateInfo^ do
              If ErrorOnly then Num_Rates_Per_File:=90
                           else } Num_Rates_Per_File:=5;

     RCount:=0;
     For i:=0 to WorkingTStates.Count-1 do
       Begin
         PS:=WorkingTStates.At(i);
         If PS<> nil then
            If PS.PShowRates^ then RCount:=RCount+1;
       End;
     NumFiles:=((RCount - 1) div Num_Rates_Per_File) + 1;
   End;
   {-------------------------------------------------------------}
   Procedure SetName(FileNum: Integer);
   Var LetStr,BaldFile: String;
   Begin
     LetStr   := '_'+Chr(FileNum+64);
     If FileNum=1 then LetStr:='';
     BaldFile := WorkingTStates.PRateInfo^.FileNm;
     Delete(BaldFile,Length(BaldFile)-2,3);
     If SV.LinkedMode then BaldFile := BaldFile + '_S'+WorkingTStates.PSegID^
                       else if WorkingTStates.VSeg=Hypolimnion then BaldFile:=BaldFile+'_Hyp';
     Table.TableName:=BaldFile+LetStr+ExtractFileExt(WorkingTStates.PRateInfo^.FileNm);
   End;
   {-------------------------------------------------------------}
   Procedure AddField(PS: TStateVariable; Num: Integer);

   Var OutTxt,OutNum: String;
       PR: TRate;
       i, UpLimit: Integer;
   Begin
     OutTxt := OutputText(PS.NState,PS.SVType,PS.Layer,WorkingTStates.UniqueName(PS.NState),False,False,0);
{     If DBase then Delete(OutTxt,11,10); }
     If OutTxt[Length(OutTxt)] in ['0'..'9'] then OutTxt := OutTxt + '_';

     Table.FieldDefs.Add(OutTxt, ftFloat, 0, False);

     OutNum:=IntToStr(Num);
     If PS.RateColl=nil then exit;

     {If WorkingTStates.PRateInfo^.ErrorOnly Then UpLimit:=1
                                             Else } UpLimit:=PS.RateColl.Count-1;

     {Write all of the collected rates here, and number them}
     If PS.RateColl.Count>1 then
       For i:=1 to UpLimit do
         Begin
           PR:=PS.RateColl.At(i);
           OutTxt:=PR.Name;
           {If IsDBF then Delete(OutTxt,9,10);}
           OutTxt:=OutTxt+OutNum;
           Table.FieldDefs.Add(OutTxt, ftFloat, 0, False);
         End;
   End;
   {-------------------------------------------------------------}
   Procedure InitFile;
   Var j : Integer;
   Begin
     With WorkingTStates do
       Begin
         WriteTable := TTable.Create(nil);
         Table := WriteTable;
         Table.DatabaseName:=PRateInfo^.DirNm;

         If Not LinkedMode then PRateInfo^.Fileinit[vseg]:=True
                           else RateFileInit := True;
         If VSeg=hypolimnion then EpiSegment.PRateInfo^.Fileinit[vseg]:=true;
       End;
         
     ns := FirstState;
     Typ:= StV;
     Lyr:= WaterCol;
     AddCount:=0;
     For j:=1 to NumFiles do
       Begin
        SetName(j);
        Try
         With Table do with FieldDefs do
          Begin
            IndexDefs.Clear;
            Clear;
            Add('Date', ftDate, 0, False);
            Add('Time', ftTime, 0, False);
            FirstInFile:=True;

            While (addcount<RCount) and
                  ((addcount mod Num_Rates_Per_File <> 0) or (FirstInFile)) do
              Begin
                PS:=WorkingTStates.GetStatePointer(ns,Typ,Lyr);
                If PS<>nil then
                  If PS.PShowRates^ then
                    Begin
                      AddField(PS,AddCount+1);
                      AddCount := AddCount+1;
                      FirstInFile := False;
                    End;

                Inc(ns);
                If ns=LastState then
                  begin
                    ns:=FirstState;
                    Inc(Typ);
                  end;
              End;

            CreateTable;
            EmptyTable;
          End;
     Except
       Raise EAQUATOXERROR.CREATE('Error Creating Rate Output Database');
     End;
    End; {for}
   End;
   {-------------------------------------------------------------}
   Procedure AddRates(PS: TStateVariable);
   Var PR: TRate;
       i, count: Integer;
       UpLimit:  Integer;
       ThisRate,ThisState,ThisVal: Double;

   Begin
     If PS.RateColl=nil then Exit;
     Count := PS.RateColl.Count;
     If Count=0 then Exit;

     ThisState := PS.AllStates.OutputState(PS.NState,PS.SVType,PS.Layer,PS.State);
     ThisVal := PS.State;

     Table.Fields[WriteIndex].AsFloat:=ThisState;
     Inc(WriteIndex);
     UpLimit := Count-1;

     If Count>1 then
       For i:=1 to UpLimit do
       Begin
         PR:=PS.RateColl.At(i);
         ThisRate := PR.GetRate;
         if i>1 then If ThisVal<tiny then ThisRate :=0
                                     else ThisRate := ThisRate/ThisVal;
         If Pos('_LIM',Table.Fields[WriteIndex].FieldName)>0
                                     then ThisRate := ThisRate*ThisVal;
            {JSC 1-8-02, Photosynthesis limitations are not percentages}
         Table.Fields[WriteIndex].AsFloat:=ThisRate;
         Inc(WriteIndex);
       End;
   End;
   {-------------------------------------------------------------}

Var j: Integer;
Begin
  SegIndex := 0;

Repeat
  If (SV.LinkedMode and SV.CascadeRunning) then WorkingTStates := SV
    else If SV.LinkedMode then WorkingTStates := TAQUATOXSegment(OtherFBSegs.At(SegIndex)).SV
    else If SegIndex=0 then WorkingTStates := SV
    else If SegIndex=1 then WorkingTStates := SV.HypoSegment;

  With WorkingTStates do with PRateInfo^ do
    Begin
     If WaterVolZero or (Location.SiteType = TribInput) then exit;

     Count_Num_RateFiles(NumFiles, Num_Rates_Per_File, RCount);
     If RCount=0 then exit;

     PS := GetStatePointer(Volume,StV,WaterCol);
     If PS.RateColl=nil then exit; {12/16/03 ensure rates have been written before file init}

     Table := WriteTable;
     If Not LinkedMode then If Not FileInit[Vseg] then InitFile;
     If LinkedMode then If not WorkingTStates.RateFileInit then InitFile;

     Table.DatabaseName:=DirNm;

     ns := FirstState;
     Typ := StV;
     Lyr:= WaterCol;

     AddCount:=0;
       For j:=1 to NumFiles do
         Begin
          SetName(j);
       Try
           With Table do
            Begin
              Table.Active:=True;
              Table.Append;
              Table.Fields[0].AsDateTime := TimeIndex;
              Table.Fields[1].AsDateTime := TimeIndex;
              WriteIndex := 2;

              FirstInFile:=True;

              While (addcount<RCount) and
                    ((addcount mod Num_Rates_Per_File <> 0) or (FirstInFile)) do
                Begin
                  PS:=WorkingTStates.GetStatePointer(ns,Typ,Lyr);
                  If PS<>nil then
                    If PS.PShowRates^ then Begin
                                            AddRates(PS);
                                            addcount:=addcount+1;
                                            FirstInFile:=False;
                                          End;
                  Inc(ns);
                  If ns=LastState then
                      begin
                        ns:=FirstState;
                        Inc(Typ);
                      end;
                End;

              Table.Post;
              Table.Active:=False;
            End;
       Except
         Raise EAQUATOXERROR.CREATE('Error Writing to Rate Output Database');
       End;
      End; {for}

    End; {with}

  Inc (SegIndex);

  If (Not SV.LinkedMode) then StopRepeat := (Not WorkingTStates.Stratified) or (Not RKQSHypo) or (SegIndex=2)
                          else StopRepeat := (SegIndex > (OtherFBSegs.Count-1));
  If (SV.LinkedMode and SV.CascadeRunning) then StopRepeat := True;

Until StopRepeat;

End;

{-------------------------------------------------------------------------------}

Procedure TAQUATOXSegment.Perform_Dilute_or_Concentrate(TimeIndex: Double);
{*************************************}
{ Modifies Concentration to           }
{ account for a change in volume      }
{ Executed after successful rkqs step }
{ coded by JSC, 10/5/99               }
{ Added pore waters, 11/29/00         }
{ Added delta thermocline 7/16/07     }
{*************************************}

    Procedure Track_Nutrient_Exchange(ns: AllVariables; NetMassTrans: Double; WTS: TStates);
    Var N2Org,P2Org: Double;
        PAn: TAnimal; PPl: TPlant;
    Begin
      N2Org := 0; P2Org := 0;
      If ns in [SedmRefrDetr..SuspLabDetr] then
        Begin
          With WTS.Location.Remin do
           Case ns of
             SedmRefrDetr, SuspRefrDetr: Begin N2Org := N2Org_Refr;     P2Org := P2Org_Refr;    End;
             SedmLabDetr, SuspLabDetr:   Begin N2Org := N2OrgLab;       P2Org := P2OrgLab;      End;
             DissRefrDetr:               Begin N2Org := N2OrgDissRefr;  P2Org := P2OrgDissRefr; End;
             Else {DissLabDetr:}         Begin N2Org := N2OrgDissLab;   P2Org := P2OrgDissLab;  End;
             End; {Case}
        End;
      If ns in [FirstPlant..LastPlant] then
        Begin
           PPL := WTS.GetStatePointer(ns,StV,WaterCol);
           N2Org := PPL.N_2_Org;
           P2Org := PPL.P_2_Org;
        End;
      If ns in [FirstAnimal..LastAnimal] then
        Begin
          PAn := WTS.GetStatePointer(ns,StV,WaterCol);
          N2Org := PAn.PAnimalData.N2Org;
          P2Org := PAn.PAnimalData.P2Org;
        End;

      If ns in [nitrate,ammonia] then N2Org := 1.0;
      If ns = phosphate then P2Org := 1.0;

      WTS.MBLayerArray[Nitrate].NNetLayer[0]   := WTS.MBLayerArray[Nitrate].NNetLayer[0]   + NetMassTrans /1000 * N2Org;
      WTS.MBLayerArray[Phosphate].NNetLayer[0] := WTS.MBLayerArray[Phosphate].NNetLayer[0] + NetMassTrans /1000 * P2Org;
                                                                             {kg}              {g}      {g/kg}  {g/g}
    End;

Var PSV: TStateVariable;
    i, SegLoop: Integer;
    PVol: TVolume;
    Vol_Prev_Step, NewVolume, FracChange, VolInitCond: Double;
    GainVol, PrevSegVol, NewSegVol, NewVolFrac, MassT0,
    LossVol, OtherSegState, DeltaSegVol, PrevVolFrac, mass: Double;
    WorkingTStates: TStates;
    EndRepeat: Boolean;
    VarLoop: AllVariables;
    LayerLoop: T_SVLayer;
    ToxLoop: T_SVType;
    PoreLoop: AllVariables;
    PTox, PWater: TStateVariable;

Begin
  SegLoop := -1;
  Repeat                                              {Loop through multiple segments}
    Inc(SegLoop);
    If (SV.LinkedMode and SV.CascadeRunning)
      then WorkingTStates := SV
      else If SV.LinkedMode
        then WorkingTStates := TAQUATOXSegment(OtherFBSegs.At(Segloop)).SV
        else If SegLoop=0 then WorkingTStates := SV
                          else WorkingTStates := SV.HypoSegment;

    With WorkingTStates do                             {with the current segment}
      Begin
        IF Location.SiteType = TribInput then Exit;

        VolInitCond := TVolume(GetStatePointer(Volume,StV,WaterCol)).InitialCond;
        NewVolume := GetState(Volume,StV,WaterCol);

        If NewVolume<= VolInitCond * Location.Locale.MIN_VOL_FRAC               {Check for Water Volume Zero and Move On}
           then begin
                  ProgData.WZVis:=True;
                  ProgData.AnoxicVis := False;
                  WaterVolZero := True;
                  Water_Was_Zero := True;
                  Volume_Last_Step := GetState(Volume,StV,WaterCol);
                  exit;
                end;

        If Water_Was_Zero then Volume_Last_Step := Last_Non_Zero_Vol;           {Recover from Water Volume Zero State}
        Water_Was_Zero := False;
        ProgData.WZVis := False;
        WaterVolZero   := False;

        PVol := GetStatePointer(Volume,StV,WaterCol);
        Vol_Prev_Step := Volume_Last_Step;

        If (Not EstuarySegment) and (Not LinkedMode) and Stratified then with PVol do with Location do   {Deal with non-linked stratification}
          Begin
             If (VSeg = Epilimnion)
               then Vol_Prev_Step := Volume_Last_Step * VolFrac(MaxEpiThick, Locale.ZMax, P_Shape)  {note, no stratification if not UseBathymetry}
               else Vol_Prev_Step := Volume_Last_Step * (1-VolFrac(MaxEpiThick, Locale.ZMax, P_Shape));
          End;

        NewVolume := GetState(Volume,StV,WaterCol);
        Volume_Last_Step := NewVolume;

        LossVol := 0; GainVol := 0; PRevSegVol := 0; NewSegVol := 0; NewVolFrac := 1;
        If Stratified and not LinkedMode {dynamic stratification}
          then
            Begin
              PVol.DeltaVolume; {Update SegVolum Calculations}
              NewVolume := Location.Morph.SegVolum[VSeg];

              PrevVolFrac := VolFrac_Last_Step;

              With Location do
                If EstuarySegment then NewVolFrac := PVol.FracUpper
                                  else NewVolFrac := PVol.VolFrac(MaxEpiThick, Locale.ZMax, P_Shape);

              IF (NewVolFrac<>PrevVolFrac) and (PrevVolFrac<>-99) then  {Z_Thermocline has changed, must move water, 7-27-07}
                Begin
                  If (VSeg = Epilimnion)
                    then
                      Begin
                        PrevSegVol  :=  PrevVolFrac * GetState(Volume,StV,WaterCol);   { prior to moving water due to delta z_thermocline }
                        NewSegVol   :=  NewVolFrac * GetState(Volume,StV,WaterCol);    { after moving water due to delta z_thermocline }
                      End
                    else
                      Begin
                        PrevSegVol  :=  (1-PrevVolFrac) * GetState(Volume,StV,WaterCol);
                        NewSegVol  :=  (1-NewVolFrac) * GetState(Volume,StV,WaterCol);
                      End;

                  DeltaSegVol :=  NewSegVol - PrevSegVol; {calc in m3}

                  LossVol := ABS(MIN(DeltaSegVol,0));
                  GainVol := MAX(DeltaSegVol,0);
                End;
            End;   {End Stratified Code}

        Last_Non_Zero_Vol := NewVolume;
        IF EstuarySegment then FracChange := 1
                          else FracChange := (NewVolume / Vol_Prev_Step);

        WorkingTStates.VolFrac_Last_Step := NewVolFrac;
        PVol.DeltaVolume; {Update SegVolum Calculations}

        For i:=0 to Count-1 do          {PERFORM DILUTE-CONCENTRATE}
          Begin
            PSV:=At(i);
            With PSV do
            If Layer=WaterCol then
              If (NState in [FirstBiota..LastBiota,FirstTox..LastTox,Ammonia..LastDetr]) and
                NOT ((PSV.NState in [FirstTox..LastTox]) and SetupRec^.KeepDissToxConst)
                    then State := State / FracChange;  {dilute/concentrate}
          End;

        If (LossVol>0) or (GainVol>0) then
          For i:=0 to Count-1 do
            Begin
              PSV:=At(i);
              With PSV do
              If Layer=WaterCol then
                If (NState in [FirstBiota..LastBiota,FirstTox..LastTox,Ammonia..LastDetr]) and
                  NOT ((PSV.NState in [FirstTox..LastTox]) and SetupRec^.KeepDissToxConst)
                      then Begin
                             {move water based on delta z thermocline 7-27-07}
                             MassT0 := State * PrevSegVol;
                                {g}    {g/m3}    {m3}
                             If VSeg = Epilimnion
                                then OtherSegState := HypoSegment.GetState(PSV.NState,PSV.SVType,PSV.Layer)
                                else OtherSegState := EpiSegment.GetState(PSV.NState,PSV.SVType,PSV.Layer);
                             If LossVol > 0
                               then mass := (State * PrevSegVol) - (LossVol * State)
                               else mass := (State * PrevSegVol) + (GainVol * OtherSegState); {gainvol>0}
                                    {g}     {g/m3}     {m3}          {m3}     {g/m3}
                             State := mass /  NewSegVol;
                             {g/m3}    {g}      {m3}

                             Track_Nutrient_Exchange(PSV.NState, Mass-MassT0,WorkingTStates); {net mass transfer}
                                                                   {g}
                           End;
            End;
        If (LossVol>0) or (GainVol>0) then PVol.DeltaVolume;


        {pore waters also dilute/concentrate}
        For LayerLoop := SedLayer1 to LowestLayer do
          If GetStatePointer(PoreWater,StV,LayerLoop) <> nil then
            Begin
              NewVolume := GetState(PoreWater,StV,LayerLoop);
              If NewVolume * SV.SedLayerArea > tiny then
                 {m3/m2}              {m2}
                Begin
                  If PWVol_Last_Step[LayerLoop]<tiny
                    then FracChange := 1
                    else FracChange := (NewVolume / PWVol_Last_Step[LayerLoop]);
                  If FracChange <> 1.0 then
                    For VarLoop := PoreWater to LaDOMPore do
                     For ToxLoop := StV to LastToxTyp do
                      Begin
                        PSV:=GetStatePointer(VarLoop,ToxLoop,LayerLoop);
                        If (PSV<>nil) and not ((VarLoop=PoreWater) and (ToxLoop=StV))
                          Then PSV.State := PSV.State / FracChange;
                      End;

                  PWVol_Last_Step[LayerLoop] := NewVolume;
                End
               else
                Begin
                  IF PWVol_Last_Step[LayerLoop]>0 then
                    Begin {need to handle residual toxicant dissolved in pore water}
                      With SV do
                       For PoreLoop := PoreWater to LaDomPore do
                        For ToxLoop := STV to LastOrgTxTyp do
                          Begin
                            PTox := GetStatePointer(PoreLoop,ToxLoop,LayerLoop);
                            If PTox<>nil then
                              Begin
                                If ToxLoop>StV then
                                  Begin
                                    PWater := GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol);
                                    PWater.State := PWater.State + PTox.State * PWVol_Last_Step[LayerLoop] * SV.sedlayerArea / SegVol;
                                        {ug/L wc}     {ug/L wc}        {ug/L pw}       {m3/m2 pw}                    {m2}      {m3 wc}
                                  End;
                                PTox.State := 0;
                              End;
                          End;
                    End;
                  PWVol_Last_Step[LayerLoop] := 0; {newvolume < tiny}
                End;
            End;
      End;

    If SV.LinkedMode then EndRepeat := (SegLoop = OtherFBSegs.Count-1) or SV.CascadeRunning
                      else EndRepeat := (SegLoop=1) or (not SV.Stratified);
  Until EndRepeat;
End;

{-------------------------------------------------------------------------------}

Procedure TAQUATOXSegment.ConvertRatestoXLS;
Var NumFiles, Num_Rates_Per_File, RCount: Integer;
    Table: TTable;
    EndRepeat: Boolean;
    WorkingTStates: TStates;
{    TCF: TCellFormat; }
    SegLoop: Integer;
    SaveTitle: String;
    {Excel Vars}
    lcid: integer;
    WBk: _WorkBook;
    WS,WS2: _Worksheet;
    Excel: _Application;

   Procedure SetName(FileNum: Integer);
   Var LetStr,BaldFile: String;
   Begin
     LetStr   := '_'+Chr(FileNum+64);
     If FileNum=1 then LetStr:='';
     BaldFile := WorkingTStates.PRateInfo^.FileNm;
     Delete(BaldFile,Length(BaldFile)-2,3);
     If SV.LinkedMode then BaldFile := BaldFile + '_S'+WorkingTStates.PSegID^
                       else if WorkingTStates.VSeg=Hypolimnion then BaldFile:=BaldFile+'_Hyp';
     Table.TableName:=BaldFile+LetStr+ExtractFileExt(WorkingTStates.PRateInfo^.FileNm);
   End;

   {---------------------------------------------------------------------------}
   Procedure WriteDBsToXLS;
   Var FileLoop,i,j: Integer;
       RecNum, FieldNum: Integer;
       FormatNum: Integer;
       FieldName: String;
   Begin
     For FileLoop := 1 to NumFiles do
       Begin
         SetName(FileLoop);

         If FileExists(Table.DatabaseName+'\'+Table.TableName) then
           Begin
             Table.Active := True;
             Table.First;
             RecNum:=Table.RecordCount;
             FieldNum := Table.Fieldcount;
             For i:=1 to RecNum do
              Begin
                For j := 0 to FieldNum-1 do
                  begin
                    FieldName := Table.FieldDefs.Items[j].Name;
                    if i=1 then WS.Cells.Item[1,j+1].Value := FieldName;
                                 {XLSWrite.WriteString(j,0,-1,FieldName); }

                    If (not (FieldName[Length(FieldName)] in ['0'..'9'])) or
                       (Pos('Error',FieldName) > 0) or (Pos('_LIM',FieldName) > 0)
                        then FormatNum := -1     {Numbers Not Pctgs}
                        else FormatNum :=  1;    {Percentages}
                    IF j=0 then FormatNum := 0;  {Date Field}

                    If FormatNum = 0 then WS.Cells.Item[i+1,j+1].NumberFormat := 'm/d/yyyy';
                    if j=1 then WS.Cells.Item[i+1,j+1].NumberFormat := 'h:mm AM/PM';
                    If FormatNum = 1 then WS.Cells.Item[i+1,j+1].NumberFormat := '#0.0%';
                    If j=1 then WS.Cells.Item[i+1,j+1].Value := TimeToStr(Table.Fields[j].AsDateTime)
                           else WS.Cells.Item[i+1,j+1].Value := Table.Fields[j].AsFloat;
                   With SV do
                     Begin
                       UpdateProg;
                       If ProgData.ProgCancel then Begin
                                                      Table.Active := False;
                                                      Table.DeleteTable;
                                                      Exit;
                                                   End;

                     End;

                  end; {for do}
                Table.Next;
              End;

             Table.Active := False;
             Table.DeleteTable;

             WS.Activate(lcid);
             WS.Cells.Item[2,2].Select;
             Excel.ActiveWindow.FreezePanes := True;

             WS.Range['A1', 'A1'].EntireColumn.AutoFit;

             If (FileLoop<NumFiles) then WS := WBk.Worksheets[fileloop+1] as _Worksheet;

             {Update Progress Gauge}
             With SV do
               Begin
                 ProgData.ProgInt := Round(100*FileLoop / NumFiles);
                 UpdateProg;
                 If ProgData.ProgCancel then Exit;

               End;
           End;
       End;
   End;
   {---------------------------------------------------------------------------}

Var i: Integer;
    XlsName: String;

Begin
  Coinitialize(nil);

  SegLoop := -1;
  Repeat
    Inc(SegLoop);
    If (SV.LinkedMode)
      then WorkingTStates := SV
      else If SegLoop=0 then WorkingTStates := SV
                        else WorkingTStates := SV.HypoSegment;

      If WorkingTStates <> nil then
        Begin

          lcid := LOCALE_USER_DEFAULT;
          Excel := CoExcelApplication.Create;
          WBk := Excel.WorkBooks.Add(xlWBATWorksheet,LCID);
          WS := Excel.ActiveSheet as _Worksheet;

           Table := TTable.Create(nil);

           { Table.Name := 'ReadTable'; }
           Table.Active := False;
           Table.TableType := ttparadox;

           Try

           Table.DatabaseName:=SV.PRateInfo^.DirNm;
           WorkingTStates.Count_Num_RateFiles(NumFiles, Num_Rates_Per_File, RCount);

           With SV do
             Begin
               ProgData.UncertPanelVis   := True;
               SaveTitle := ProgData.UncertTitleLabel;
               ProgData.UncertTitleLabel := 'Writing Rates Data to Excel';
               ProgData.UncertStatLabel  := '';
               ProgData.ProgInt := 0 ;
               UpdateProg;
             End;

           With WorkingTStates do
             IF (SV.LinkedMode and SV.RateFileInit) or
                (not SV.LinkedMode and SV.PRateInfo^.FileInit[VSeg]) then
               Begin
                 XlsName := SV.PRateInfo^.FileNm;
                 Delete(XlsName,Length(XlsName)-2,3);
                 If SV.LinkedMode then XlsName := XlsName + '_S'+SV.PSegID^
                                   else if VSeg=Hypolimnion then XlsName:=XlsName+'_Hyp';

                 XLSName := SV.PRateInfo^.DirNm + ChangeFileExt(XLSName,'.xls');
                 For i := 2 to NumFiles do
                     WBk.Sheets.Add(emptyparam,emptyparam,emptyparam,emptyparam,lcid);
                 For i := 1 to NumFiles do
                   Begin
                     WS2 := WBk.WorkSheets[i] as _Worksheet;
                     WS2.Name := 'AQT Rates ('+IntToStr(i)+')';
                   End;
                 WS := WBk.WorkSheets[1] as _Worksheet;

                 WriteDBsToXLS;

                 If SV.ProgData.ProgCancel then Begin Excel.DisplayAlerts[lcid] := False; Excel.Quit; Exit; End;

                 if StrToFloat(Excel.Version[LCID]) > 11
                    Then  Wbk.SaveAs(XLSName,56,EmptyParam,EmptyParam,EmptyParam
                                    ,EmptyParam,xlnochange,EmptyParam,EmptyParam,EmptyParam,EmptyParam,LCID)
                    else  Wbk.SaveAs(XLSName,EmptyParam,EmptyParam,EmptyParam,EmptyParam
                             ,EmptyParam,xlnochange,EmptyParam,EmptyParam,EmptyParam,EmptyParam,LCID);
                 Wbk.Close(False,EmptyParam,EmptyParam,LCID);
                 Excel.Quit;

               End;

           Table.Free;

           Except
              Wbk.Close(False,EmptyParam,EmptyParam,LCID);
              Excel.Quit;
              Table.Free;
              Raise;
           End;
        End;
      EndRepeat :=  SV.LinkedMode or (SegLoop = 1) or SV.ProgData.ProgCancel;
  Until EndRepeat;

  SV.ProgData.UncertTitleLabel := SaveTitle;

End;

{-------------------------------------------------------------------------------}

