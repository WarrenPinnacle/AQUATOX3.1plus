//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
{ TTestSite STORE AND LOAD HAVE BEEN MOVED TO SITE.INC }
{ TLOAD STORE AND TLOAD LOAD MOVED TO LOADING.INC      }
{ TCHEMICAL STORE AND LOAD IN CHEMICAL.INC             }

Procedure TStates.Store(IsTemp: Boolean; var st: Tstream);
Var Loop: VerticalSegments;
    WriteMultiRec: Boolean;
    SedLoop: Integer;
    BlankPLoad: TLoadings;

Begin
     Inherited;  {TCollection}

     StoreCollectionitems(IsTemp, St,Self);

     st.write(MeanDischarge,Sizeof(MeanDischarge));

     St.Write(HypoTempIC,Sizeof(HypoTempIC));
     St.write(HypoTempLoads,Sizeof(HypoTempLoads));
     With HypoTempLoads Do
      Begin
       Loadings.Store(IsTemp, St);
       StoreCollectionitems(IsTemp, St,Loadings);
      End;

     St.write(Shade,Sizeof(Shade));
     With Shade Do
      Begin
       Loadings.Store(IsTemp, St);
       StoreCollectionitems(IsTemp, St,Loadings);
      End;

     St.write(Z_Thermocline,Sizeof(Z_Thermocline));
     With Z_Thermocline Do
      Begin
       Loadings.Store(IsTemp, St);
       StoreCollectionitems(IsTemp, St,Loadings);
      End;

     St.write(CalcVelocity, Sizeof(CalcVelocity));
     DynVelocity.Store(IsTemp, St);
     StoreCollectionitems(IsTemp, St, DynVelocity);

   If StoreResults then
    For Loop:=Epilimnion to Hypolimnion do
     begin
       Results[Loop].Store(IsTemp, St);
       StoreCollectionitems(IsTemp, St,Results[loop]);
       ControlResults[loop].Store(IsTemp, St);
       StoreCollectionitems(IsTemp, St,ControlResults[loop]);
     end;

   If StoreDistribs then
    Begin
      Distributions.Store(IsTemp, St);
      StoreCollectionitems(IsTemp, St,Distributions);
    End;

    If IsTemp then
      Begin
        St.Write(PRateInfo^,Sizeof(PRateInfo^));
        St.Write(PControlInfo^,Sizeof(PControlInfo^));
        St.Write(PSavePPB^, Sizeof(PSavePPB^));
        St.Write(PSaveBAFs^, Sizeof(PSaveBAFs^));
      End;

     WriteMultiRec := PMultiRec<>nil;
     St.Write(WriteMultiRec,Sizeof(Boolean));
     If (WriteMultiRec) then with PMultiRec^ do
       Begin
         If IsTemp then
           Begin
             St.Write(PNumAges^,Sizeof(PNumAges^));
             St.Write(PSpawnAge^,Sizeof(PSpawnAge^));
             St.Write(PName^,Sizeof(PName^));
           End;
         St.Write(InitCond,Sizeof(InitCond));
         St.Write(Loadings,Sizeof(Loadings));
         St.Write(ChemIC,Sizeof(ChemIC));
         St.Write(ChemLoad,Sizeof(ChemLoad));
         If IsTemp then
           Begin
             St.Write(PLipidFrac^,Sizeof(PLipidFrac^));
             St.Write(PMortCoeff^,Sizeof(PMortCoeff^));
             St.Write(PMeanWeight^,Sizeof(PMeanWeight^));
           End;
       End;

     If LinkedMode and (Not IsTemp) then  {Used only in linked segments}
       Begin
         St.Write(IsStrat,Sizeof(IsStrat));
         St.Write(IsEpilimnion,Sizeof(IsEpilimnion));

         St.Write(AutoCalcXSec,Sizeof(AutoCalcXSec));
         XSecData.Store(IsTemp, St);
         StoreCollectionitems(IsTemp, St,XSecData);
       End;

     BlankPLoad := TLoadings.Init(2,2);
     St.Write(SedData,Sizeof(SedData));
     For SedLoop := 1 to 10 do
       If SedLoop>SedLayers
         then
           Begin
             BlankPLoad.Store(IsTemp, St);
             StoreCollectionitems(IsTemp, St,BlankPLoad);
           End
         else
           Begin
             TLoadings(SedData[SedLoop].UpperDispCoeff).Store(IsTemp, St);
             StoreCollectionitems(IsTemp, St,SedData[SedLoop].UpperDispCoeff);
           End;
     BlankPLoad.Destroy;

     St.Write(SedNonReactive,Sizeof(SedNonReactive));

     St.Write(Densities,Sizeof(Densities));
     St.Write(UseSSC,Sizeof(UseSSC));
     St.Write(MaxUpperThick,sizeof(MaxUpperThick));
     St.Write(BioTurbThick,sizeof(BioTurbThick));

     ObservedData.Store(IsTemp,St);
     Graphs.Store(IsTemp,St);

{   St.Write(GraphDat,Sizeof(GraphDat));
   St.Write(CGraphDat,Sizeof(GraphDat));
   St.Write(DGraphDat,Sizeof(GraphDat)); }

   St.write(UseConstZMean, Sizeof(UseConstZMean));
   DynZMean.Store(IsTemp,St);
   StoreCollectionitems(IsTemp,St,DynZMean);

   St.write(UseConstEvap, Sizeof(UseConstEvap));
   DynEvap.Store(IsTemp,St);
   StoreCollectionitems(IsTemp,St,DynEvap);

   St.Write(GullPref,Sizeof(GullPref));
   St.Write(GullBMF,Sizeof(GullBMF));
   St.Write(GullRef,Sizeof(GullRef));

   St.Write(GullClear,Sizeof(GullClear));
   St.Write(GullClearRef,Sizeof(GullClearRef));

   St.Write(EstuarySaltLoads,Sizeof(EstuarySaltLoads));
   St.Write(Diagenesis_Steady_State,Sizeof(Diagenesis_Steady_State))   
End;


Procedure TStates.WriteText;

    Procedure WriteAgeDist(Name: String; Var AD: AgeDist);
    var i: Integer;
    Begin With AD do
     Begin
      Write(LF,Name+': ');
      If UserDefined then Write(LF,'User Defined - ')
                     else Write(LF,'Distribution Defined - ');
      For i := 1 to PMultiRec^.PNumAges^ do
        Write(LF,IntToSTr(i)+': '+FloatToSTrF(Vals[i],ffgeneral,5,5)+';  ');
      Writeln(LF);
      If LoadNotes1 <> '' then Writeln(LF,LoadNotes1);
      If LoadNotes2 <> '' then Writeln(LF,LoadNotes2);
     End;
    End;

Var Chem: FirstOrgTxTyp..LastOrgTxTyp;
    nsLoop: AllVariables;
    SedLoop: Integer;
Begin
   WriteTextCollection(LF,Self);
   Writeln(LF,'Hypolimnion Temperature IC: ',FloatToStrF(HypoTempIC,ffgeneral,5,5));
   LoadingsRectoText(LF,HypoTempLoads,False);

   If PMultiRec<>nil then
    If GetStatePointer(Fish1,StV,WaterCol) <> nil then
     With PMultiRec^ do
       Begin
         Writeln(LF,'---------------------------------------');
         Writeln(LF,'MULTI-AGE-CLASS-FISH PARAMETERS');
         Writeln(LF,'Name: '+PName^);
         Writeln(LF,'NumAges: '+IntToStr(PNumAges^));
         Writeln(LF,'SpawnAge: '+FloatToStrF(PSpawnAge^,ffgeneral,5,5));
         WriteAgeDist('Init Cond',InitCond);
         WriteAgeDist('Loadings',Loadings);
         For Chem := FirstOrgTxTyp to LastOrgTxTyp do
          If GetStatePointer(AssocToxSV(Chem),StV,WaterCol) <> nil then
            Begin
             WriteAgeDist('T'+IntToStr(ORD(Chem)-1)+ 'IC',ChemIC[Chem]);
             WriteAgeDist('T'+IntToStr(ORD(Chem)-1)+ 'Load',ChemLoad[Chem]);
            End;
         WriteAgeDist('LipidFrac',PLipidFrac^);
         WriteAgeDist('MortCoeff',PMortCoeff^);
         WriteAgeDist('MeanWeight',PMeanWeight^);
       End;

   Writeln(LF,'---------------------------------------');
   Write(LF, 'Shade Inputs: ');
   LoadingsRectoText(LF,Shade,False);
   Writeln(LF);

   If Not Z_Thermocline.NoUserLoad
      then Begin
             Writeln(LF,'---------------------------------------');
             Write(LF, 'Thermocline Depth Inputs: ');
             LoadingsRectoText(LF,Z_Thermocline,False);
             Writeln(LF);
           End;

   If Not CalcVelocity then
     Begin
       Writeln(LF,'---------------------------------------');
       Write(LF, 'Dynamic Velocity Inputs: ');
       WriteTextCollection(LF,DynVelocity);
       Writeln(LF);
     End;

   If Not UseConstZMean then
     Begin
       Writeln(LF,'---------------------------------------');
       Write(LF, 'Dynamic ZMean Selected: ');
       WriteTextCollection(LF,DynZMean);
       Writeln(LF);
     End;

   If Not UseConstEvap then
     Begin
       Writeln(LF,'---------------------------------------');
       Write(LF, 'Dynamic Evap Selected: ');
       WriteTextCollection(LF,DynEvap);
       Writeln(LF);
     End;


   If LinkedMode then  {Used only in linked segments}
       Begin
         If IsStrat then
           Begin
             Write(LF,'PART OF LINKED STRATIFIED PAIR -- ');
             If IsEpilimnion then Writeln(LF,'EPILIMNION')
                             else Writeln(LF,'HYPOLIMNION');
           End;

         If Not AutoCalcXSec then
           Begin
             Writeln(LF,'---------------------------------------');
             Write(LF, 'User Entered Cross Sections: ');
             WriteTextCollection(LF,XSecData);
             Writeln(LF);
           End;
       End;

   If SedModelIncluded then
     Begin
       Writeln(LF,'---------------------------------------');
       Writeln(LF,'MULTI LAYER SEDIMENT MODEL');
       If SedNonReactive then Writeln(LF,'Sediment Layers are Non-Reactive');

       For SedLoop := 1 to 10 do
         If SedLoop<=SedLayers
           then with SedData[SedLoop] do
             Begin
               Writeln(LF,'LAYER '+IntToStr(SedLoop));
               Writeln(LF,'Initial Bed Depth '+ FloatToStrF(BedDepthIC,ffgeneral,5,5));
               Write(LF,'UpperDispCoeff ');
               WriteTextCollection(LF,UpperDispCoeff);
               Writeln(LF);
               Writeln(LF,'================');
             End;

       Write(LF,'Densities');
       For nsLoop := Cohesives to SedmLabDetr do
         Write(LF,', '+StateText(nsloop,stv,watercol)+': '+FloatToStrF(Densities[nsloop],ffgeneral,5,5));
       Writeln(LF,';');

       Writeln(LF,'MaxUpperThick '+FloatToStrF(MaxUpperThick,ffgeneral,5,5));
       Writeln(LF,'BioTurbThick '+FloatToStrF(BioTurbThick,ffgeneral,5,5));
       If UseSSC then Writeln(LF,'Sand, Silt, Clay Model Used to Calculate Erosion & Deposition.');

     End;

   If Location.SiteType=Estuary then
     with EstuarySaltLoads do
       Begin
         Writeln(LF,'================');
         Writeln(LF,'Estuary Salt Water Loadings, in mg/L');
         Writeln(LF,'Ammonia Load: '+FloatToStrF(AmmoniaLoad,ffgeneral,5,5)+' -- '+XAmmoniaLoad);
         Writeln(LF,'Nitrate Load: '+FloatToStrF(NitrateLoad,ffgeneral,5,5)+' -- '+XNitrateLoad);
         Writeln(LF,'Phosphate Load: '+FloatToStrF(PhosphateLoad,ffgeneral,5,5)+' -- '+XPhosphateLoad);
         Writeln(LF,'O2 Load: '+FloatToStrF(O2Load,ffgeneral,5,5)+' -- '+XO2Load);
         Writeln(LF,'CO2 Load: '+FloatToStrF(CO2Load,ffgeneral,5,5)+' -- '+XCO2Load);
         Writeln(LF,'================');
       End;

  (*
   St.Write(GullPref,Sizeof(GullPref));
   St.Write(GullBCF,Sizeof(GullBCF));
   St.Write(GullRef,Sizeof(GullRef));

   St.Write(GullClear,Sizeof(GullClear));
   St.Write(GullClearRef,Sizeof(GullClearRef));  GULL POST PROCESSING NOT INCLUDED IN TEXT OUTPUT AT THIS TIME *)

End;


Constructor TStates.Load(LinkedM,IsTemp: Boolean; St: Tstream; ReadVersionNum: Double; LoadResults, LoadDistribs: Boolean);
Var Loop: VerticalSegments;
    ToxLoop: T_SVType;
    ReadMultiRec: Boolean;
    Blank: InteractionFields;
    Junk: Double;
    i: Integer;
    LayLoop: T_SVLayer;
    nsLoop, DLoop: AllVariables;
    NotUsed: Array[1..3076] of Byte;
    OldControlInfo: Array[1..5] of Control_Opt_SubRec;
    GraphDat, CGraphDat, DGraphDat: TOldGraphSetupRecord;
Begin
   If IsTemp then PStatesTemplate := Self
             else PStatesTemplate := nil;

   If IsTemp then
     Begin
       New(PMessageStr);
       PMessageStr^ := '';
       New(PMessageErr);
       PMessageErr^ := False
     End;

    If IsTemp then New(PModelTimeStep); 

    LinkedMode := LinkedM;

    WaterVolZero := False;
    Water_Was_Zero := False;
    Last_Non_Zero_Vol := 0;

    HypoSegment:=nil;
    EpiSegment:=nil;
    VSeg:=Epilimnion;  {Always set to this on the read}

    Inherited Load(IsTemp,St,ReadVersionNum);   {inherited, TCollection}
    LoadCollectionitems(IsTemp,St,Self,True,ReadVersionNum);

    st.read(MeanDischarge,Sizeof(MeanDischarge));

    If ReadVersionNum< 2.99 then st.read(NotUsed,3076);   {mercuryparams}

   St.Read(HypoTempIC,Sizeof(HypoTempIC));
   St.Read(HypoTempLoads,Sizeof(HypoTempLoads));

   With HypoTempLoads Do
    Begin
     Loadings:=nil;
     Loadings:=TLoadings.Load(IsTemp, St,ReadVersionNum);
     LoadCollectionitems(IsTemp, St,Loadings,False,ReadVersionNum);
     Alt_Loadings[PointSource]:=nil;
     Alt_Loadings[DirectPrecip]:=nil;
     Alt_Loadings[NonPointSource]:=nil;
     MultLdg := 1.0;
    End;

   IF ReadVersionNum<1.88 then HypoTempLoads.NoUserLoad := False;

   If ReadVersionNum>2.99
     Then
       Begin
         St.Read(Shade,Sizeof(Shade));

         With Shade Do
          Begin
           Loadings:=nil;
           Loadings:=TLoadings.Load(IsTemp, St,ReadVersionNum);
           LoadCollectionitems(IsTemp, St,Loadings,False,ReadVersionNum);
           Alt_Loadings[PointSource]:=nil;
           Alt_Loadings[DirectPrecip]:=nil;
           Alt_Loadings[NonPointSource]:=nil;
           MultLdg := 1.0;
          End;
       End
     Else Shade := EmptyLoad;

   If ReadVersionNum>3.475
     Then
       Begin
         St.Read(Z_Thermocline,Sizeof(Z_Thermocline));

         With Z_Thermocline Do
          Begin
           Loadings:=nil;
           Loadings:=TLoadings.Load(IsTemp, St,ReadVersionNum);
           LoadCollectionitems(IsTemp, St,Loadings,False,ReadVersionNum);
           Alt_Loadings[PointSource]:=nil;
           Alt_Loadings[DirectPrecip]:=nil;
           Alt_Loadings[NonPointSource]:=nil;
           MultLdg := 1.0;
          End;
       End
     Else Begin
            Z_Thermocline := EmptyLoad;
            Z_ThermoCline.NoUserLoad := True;
          End;


   If ReadVersionNum>3.025
     Then
       Begin
         St.Read(CalcVelocity, Sizeof(CalcVelocity));
         DynVelocity:=nil;
         DynVelocity:=TLoadings.Load(IsTemp, St,ReadVersionNum);
         LoadCollectionitems(IsTemp, St,DynVelocity,False,ReadVersionNum);
       End
     Else
       Begin
         CalcVelocity := True;
         DynVelocity  := TLoadings.Init(2,10);
       End;

   TeaseInc:=1;

   If LoadResults then
     For Loop:=Epilimnion to Hypolimnion do
        begin
          Results[loop]:=TResultsCollection.Load(IsTemp, St,ReadVersionNum);
          LoadCollectionitems(IsTemp, St,Results[loop],False,ReadVersionNum);
          ControlResults[loop]:=TResultsCollection.Load(IsTemp, St,ReadVersionNum);
          LoadCollectionitems(IsTemp, St,ControlResults[loop],False,ReadVersionNum);
        end
     else
      For Loop:=Epilimnion to Hypolimnion do
        begin
          Results[loop]:=TResultsCollection.Init;
          ControlResults[loop]:=TResultsCollection.Init;
        end;

   If LoadDistribs
        then begin
                Distributions:=TDistributionList.Load(IsTemp,St,ReadVersionNum);
                Distributions.Duplicates:=True;
                LoadCollectionitems(IsTemp, St,Distributions,False,ReadVersionNum);
             end;

   If (Not LoadDistribs) then Distributions := Nil;

    If IsTemp then
      Begin
        New(PRateInfo);
        St.Read(PRateInfo^,Sizeof(PRateInfo^));
        PRateInfo^.WriteToMemory := True;  //Disable Excel Rate Output, 8/27/2010
      End;  

    If IsTemp then
      Begin
       New(PControlInfo);
       If (readversionNum<2.99)
         then
           Begin
             St.Read(OldControlInfo,Sizeof(OldControlInfo));
             PControlInfo^.Tox      := OldControlInfo[1];
             PControlInfo^.Nutrient := OldControlInfo[3];
             PControlInfo^.Sediment := OldControlInfo[4];
             PControlInfo^.Detritus := OldControlInfo[5];
           End
         Else  St.Read(PControlInfo^,Sizeof(PControlInfo^));
      End;

     If IsTemp then
       Begin
         New(PSavePPB);
         PSavePPB^:=True;
         St.Read(PSavePPB^,Sizeof(PSavePPB^));
       End;

     If IsTemp then
       Begin
         New(PSaveBAFs);
         PSaveBAFs^:=True;
         If ReadVersionNum > 2.99 then St.Read(PSaveBAFs^,Sizeof(PSaveBAFs^));
       End;

     If Not IsTemp then
       Begin
         PRateInfo := nil;
         PControlInfo := nil;
         PSavePPB := nil;
       End;

     If ReadVersionNum < 1.8499
       then ReadMultiRec := False
       else St.Read(ReadMultiRec,Sizeof(Boolean));

     If ReadMultiRec then
       Begin
         New(PMultiRec);
         {Current Version}
          with PMultiRec^ do
           Begin
             If IsTemp then
               Begin
                 New(PNumAges);
                 New(PSpawnAge);
                 New(PName);
                 New(PLipidFrac);
                 New(PMortCoeff);
                 New(PMeanWeight);
                 St.Read(PNumAges^,Sizeof(PNumAges^));
                 St.Read(PSpawnAge^,Sizeof(PSpawnAge^));
                 St.Read(PName^,Sizeof(PName^));
               End;
             If ReadVersionNum<3.00 then St.Read(Junk,2);
             St.Read(InitCond,Sizeof(InitCond));
             St.Read(Loadings,Sizeof(Loadings));
             St.Read(ChemIC,Sizeof(ChemIC));
             St.Read(ChemLoad,Sizeof(ChemLoad));

             If IsTemp then
               Begin
                 St.Read(PLipidFrac^,Sizeof(PLipidFrac^));
                 St.Read(PMortCoeff^,Sizeof(PMortCoeff^));
                 St.Read(PMeanWeight^,Sizeof(PMeanWeight^));
               End;

             If Not IsTemp then
               Begin
                 PNumAges := nil;
                 PSpawnAge := nil;
                 PName := nil;
                 PLipidFrac := nil;
                 PMortCoeff := nil;
                 PMeanWeight := nil;
               End;
           End;
       End;
     If not ReadMultiRec then PMultiRec := nil;

     {Results Have not been loaded into databases yet. . .}
{     ResultsLoaded           :=False;
     ContResLoaded           :=False;  }
     VertDispersionCalcDate  :=-99;
     OldVertDispersionVal    :=-99;

     TimeLastGullConc := -99;
     TimeLastInorgSedAvg[True] := -99;
     TimeLastInorgSedAvg[False] := -99;

     DerivStep := 0;

   For ToxLoop := FirstToxTyp to LastToxTyp do
     Begin
       Diff[ToxLoop] := 0;
       For LayLoop := SedLayer1 to LowestLayer do
         PoreDiff[ToxLoop,LayLoop] := 0;
       FirstExposure[ToxLoop] := 0;
     End;

   Anoxic      := False;
   OOSStack := nil;
   PAllSVsColl := nil;
   In_FB_Links := nil; Out_FB_Links := nil;
   In_Cs_Links := nil; Out_Cs_Links := nil;

   If LinkedMode and (Not IsTemp) then   {Used only in linked segments}
       Begin
         St.Read(IsStrat,Sizeof(IsStrat));
         St.Read(IsEpilimnion,Sizeof(IsEpilimnion));

         St.Read(AutoCalcXSec,Sizeof(AutoCalcXSec));
         XSecData := TLoadings.Load(IsTemp, St,ReadVersionNum);
         LoadCollectionitems(IsTemp, St,XSecData,False,ReadVersionNum);
       End
     else
       Begin
         IsStrat := False;      {these vars are not used in single-segment mode}
         IsEpilimnion := True;
         AutoCalcXSec := True;
         XSecData := nil;
       End;

   If ReadVersionNum < 2.99
     then
       For i:=1 to 10 do
         With SedData[i] do
           Begin
              BedDepthIC         := 0.3; {m}
              BedDensity         := 0; {g/cm3}
              NotUsed            := 0;
              UpperDispCoeff     := TLoadings.Init(3,3); {m2/d}
              FracWater          := 0; {fraction}
              BedVolume          := 0; {current, m3}
              DynBedDepth        := 0; {m3}
              VolumeLost         := 0; {m3}
              PoreSqueeze        := 0; {m3}
           End;

   If ReadVersionNum > 2.99
     then
       Begin
         St.Read(SedData,Sizeof(SedData));
         For i:=1 to 10 do
           Begin
             SedData[i].UpperDispCoeff := TLoadings.Load(IsTemp, St,ReadVersionNum);
             LoadCollectionitems(IsTemp, St,SedData[i].UpperDispCoeff,False,ReadVersionNum);
           End;
       End;

   If ReadVersionNum > 3.015 then St.Read(SedNonReactive,Sizeof(SedNonReactive))
                             else SedNonReactive := False;

   If ReadVersionNum> 2.99
     then St.Read(Densities,sizeof(densities))
     else For DLoop := Cohesives to SedmLabDetr do
       Densities[DLoop] := 0;

   If ReadVersionNum > 3.175 then St.Read(UseSSC,sizeof(UseSSC))
                             else UseSSC := False;

   MaxUpperThick := 0.5;
   BioTurbThick  := 0.2;
   If ReadVersionNum> 2.99 then
     Begin
        St.Read(MaxUpperThick,sizeof(MaxUpperThick));
        St.Read(BioTurbThick,sizeof(BioTurbThick));
     End;


   If ReadVersionNum > 3.29
     then
       Begin
         ObservedData := TObservedData.Load(IsTemp,St,ReadVersionNum);
         Graphs := TGraphs.Load(IsTemp,St, ReadVersionNum);
       End
     else
       Begin
         ObservedData := TObservedData.Create;
         Graphs := TGraphs.Create;

          If ReadVersionNum > 3.145 then
           Begin
             St.Read(GraphDat,Sizeof(GraphDat));
             St.Read(CGraphDat,Sizeof(GraphDat));
             St.Read(DGraphDat,Sizeof(GraphDat));
           End
          else
           Begin
             St.Read(GraphDat,215);
             St.Read(CGraphDat,215);
             St.Read(DGraphDat,215);
             GraphDat.XMin := 0;
             GraphDat.XMAX := 0;
             CGraphDat.XMin := 0;
             CGraphDat.XMAX := 0;
             DGraphDat.XMin := 0;
             DGraphDat.XMAX := 0;
           End;
       End;

   If ReadVersionNum>2.585
     Then
       Begin
         St.Read(UseConstZMean, Sizeof(UseConstZMean));
         DynZMean:=nil;
         DynZMean:=TLoadings.Load(IsTemp,St,ReadVersionNum);
         LoadCollectionitems(IsTemp,St,DynZMean,False,ReadVersionNum);
       End
     Else
       Begin
         UseConstZMean := True;
         DynZMean  := TLoadings.Init(10,50);
       End;

   If ReadVersionNum>3.735
     Then
       Begin
         St.Read(UseConstEvap, Sizeof(UseConstEvap));
         DynEvap:=nil;
         DynEvap:=TLoadings.Load(IsTemp,St,ReadVersionNum);
         LoadCollectionitems(IsTemp,St,DynEvap,False,ReadVersionNum);
       End
     Else
       Begin
         UseConstEvap := True;
         DynEvap  := TLoadings.Init(10,50);
       End;


    If IsTemp then New(ProgData);

    IF ReadVersionNum>3.105 then
      Begin
        St.Read(GullPref,Sizeof(GullPref));
        St.Read(GullBMF,Sizeof(GullBMF));
        St.Read(GullRef,Sizeof(GullRef));
        St.Read(GullClear,Sizeof(GullClear));
        St.Read(GullClearRef,Sizeof(GullClearRef));
      End
    else
      Begin
       For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
           Begin
              GullBMF  [ToxLoop] := 0;
              GullClear[ToxLoop] := 0;
              GullRef  [ToxLoop] := '';
              GullClearRef[ToxLoop] := '';
           End;
         Blank.Pref   := 0;
         Blank.ECoeff := 0;
         Blank.XInteraction := '';
         For nsloop := Cohesives to LastBiota do
           GullPref[nsloop] := Blank;
     End;

   If ReadVersionNum > 3.565
     then St.Read(EstuarySaltLoads,Sizeof(EstuarySaltLoads))
     else with EstuarySaltLoads do
          Begin
            AmmoniaLoad := 0.02; {mg/L}
            XAmmoniaLoad := 'Data from Galveston Bay, TX';
            NitrateLoad := 0.05; {mg/L}
            XNitrateLoad := 'Data from Galveston Bay, TX';
            PhosphateLoad := 0.03; {mg/L}
            XPhosphateLoad := 'Data from Galveston Bay, TX';
            O2Load := 7.0; {mg/L}
            XO2Load := 'Default oxygen inflow to lower segment';
            CO2Load := 90.0; {mg/L}
            XCO2Load := 'Anthoni, Dr. J. Floor,  2006, Chemical Composition of Seawater';
          End;

   If ReadVersionNum > 3.765
     then St.Read(Diagenesis_Steady_State,Sizeof(Diagenesis_Steady_State))
     else Diagenesis_Steady_State := False;

   BirdPrey:= TCollection.Init(10,5);
   PO2Concs := TLoadings.Init(100,50);
   PSedConcs := TLoadings.Init(100,50);
   PLightVals := TLoadings.Init(50,50);

   LastPctEmbedCalc := -99;
   PercentEmbedded := 0;
End;

{- - - - - - - - - - - - - - - - - - - - - ---------------------------------------------------------}

Procedure TStateVariable.WriteText;
Var PNO3: TNO3Obj;
Begin
     Writeln(LF);
     Writeln(LF,'-----------------------------------------------');
     Writeln(LF,'Name: '+OutputText(NState,SVType,Layer,'',False,False,0));
     Writeln(LF,'SV Display: '+PName^);
     Writeln(LF,'InitialCond: '+FloatToStrF(InitialCond,ffgeneral,5,5));
(*     Writeln(LF,'State: '+FloatToStrF(State,ffgeneral,5,5)); *)

     If nstate=WindLoading then Writeln(LF,'Mean Wind Loading: '+FloatToStrF(TWindLoading(Self).MeanValue,ffgeneral,5,5));

     If nstate=Ammonia then
       Begin
         PNo3 := GetStatePointer(Nitrate,StV,WaterCol);
         If PNo3.TN_IC then Writeln(LF,'NOTE:  AMMONIA INITIAL CONDITION IGNORED AS NITRATE INITIAL CONDITION IS ENTERED AS TOTAL N');
         If PNo3.TN_Inflow then Writeln(LF,'NOTE:  AMMONIA INFLOW LOADINGS ARE IGNORED AS NITRATE INFLOW LOADINGS ARE ENTERED AS TOTAL N');
       End;

     LoadingsRectoText(LF,LoadsRec,Has_Alt_Loadings(nstate,svtype,Layer));
     If LoadNotes1 <> '' then  Writeln(LF,'LoadNotes1: '+LoadNotes1);
     If LoadNotes2 <> '' then Writeln(LF,'LoadNotes2: '+LoadNotes2);
End;


Procedure TStateVariable.Store(IsTemp: Boolean; var st: Tstream);
var loop: Alt_LoadingsType;
Begin
     st.write(InitialCond,Sizeof(InitialCond));
     st.write(State,Sizeof(State));
     st.write(nState,Sizeof(nState));
     st.Write(SVType,Sizeof(SVType));
     st.Write(Layer,Sizeof(Layer));

     If IsTemp then st.write(PName^,Sizeof(PName^));

     {ALLSTATES SET IN TAQTSTUDY.LOAD}
     With LoadsRec Do
      Begin
       Loadings.Store(IsTemp, St);
       StoreCollectionitems(IsTemp, St,Loadings);

       st.write(ConstLoad,Sizeof(ConstLoad));
       st.write(UseConstant,Sizeof(UseConstant));
       st.write(NoUserLoad,Sizeof(NoUserLoad));

       TeaseInc:=1;
       For Loop:=PointSource to NonPointSource do
           begin
             st.write(Alt_ConstLoad[loop],Sizeof(Alt_ConstLoad[loop]));
             st.write(Alt_UseConstant[loop],Sizeof(Alt_UseConstant[loop]));
             st.write(Alt_MultLdg[loop],Sizeof(Alt_MultLdg[loop]));
             If Has_Alt_Loadings(nstate,SVType,Layer)
                then begin
                        Alt_Loadings[Loop].Store(IsTemp, St);
                        StoreCollectionitems(IsTemp, St,Alt_Loadings[Loop]);
                     end;
           End
      End;

     If IsTemp then
       Begin
         st.write(PRequiresData^,Sizeof(PRequiresData^));
         st.write(PHasData^,Sizeof(PHasData^));
       End;

     st.write(StateUnit,9);
     st.write(LoadingUnit,9);
     st.write(LoadsRec.MultLdg,Sizeof(LoadsRec.MultLdg));

     st.write(yHold,Sizeof(yHold));
     st.write(YOrig,Sizeof(YOrig));
     st.write(yout,Sizeof(yout));
     st.write(stepres[1],Sizeof(stepres[1]));
     st.write(yError,Sizeof(yError));
     st.write(yScale,Sizeof(yScale));

     If IsTemp then
       St.write(PShowRates^,Sizeof(PShowRates^));

     If nstate=WindLoading then st.write(TWindLoading(Self).MeanValue,sizeof(double));

     St.write(LoadNotes1,Sizeof(LoadNotes1));
     St.write(LoadNotes2,Sizeof(LoadNotes2));

     If IsTemp then
       St.Write(PTrackResults^, Sizeof(PTrackResults^));
End;



Constructor  TStateVariable.Load(IsTemp: Boolean;Var st: Tstream; ReadVersionNum: Double);
Var Loop: Alt_LoadingsType;
Begin
   IsTemplate := IsTemp;

   St.read(InitialCond,Sizeof(InitialCond));
   St.Read(State,Sizeof(State));

   st.Read(nstate,Sizeof(nstate));
   If ReadVersionNum < 3.39 then
     nstate := UpdateNState(nstate,ReadVersionNum);
   St.Read(SVType,Sizeof(SVType));

   If ReadVersionNum < 3.00
     then Layer := WaterCol
     else st.Read(Layer,Sizeof(Layer));

   If (nstate=Avail_Silica) and (Layer=SedLayer1) then Layer := SedLayer2; {fix errant location assignment}
   If (nstate=Methane) and (Layer=SedLayer1) then Layer := SedLayer2; {fix errant location assignment}

   If IsTemp then Begin
                    New(PName);
                    st.read(PName^,Sizeof(PName^));
                    If Pos('Bl-green',PName^) = 1 then
                      Begin
                        Delete(PName^,1,8);
                        PName^ := 'Cyanobacteria'+PName^;
                      End;
                  End;

   {ALLSTATES SET IN TAQTSTUDY.LOAD}
   With LoadsRec do
     Begin
       Loadings:=TLoadings.Load(IsTemp, St,ReadVersionNum);
       LoadCollectionitems(IsTemp, St,Loadings,False,ReadVersionNum);

       st.read(ConstLoad,Sizeof(ConstLoad));
       st.read(UseConstant,Sizeof(UseConstant));
       st.read(NoUserLoad,Sizeof(NoUserLoad));


       { READ ALTERNATIVE LOADINGS }
       For Loop:=PointSource to NonPointSource do
          Begin
            st.read(Alt_ConstLoad[loop],Sizeof(Alt_ConstLoad[loop]));
            st.read(Alt_UseConstant[loop],Sizeof(Alt_UseConstant[loop]));
            st.read(Alt_MultLdg[loop],Sizeof(Alt_MultLdg[loop]));

            If ((nstate=Oxygen) and (ReadVersionNum < 3.0)) or
               ((nstate in [firstfish..lastfish]) and (ReadVersionNum< 3.705)) //10-15-2010
              Then
                 Begin
                   Alt_Loadings[Loop]:=TLoadings.Init(2,1);
                   Alt_ConstLoad[Loop]:=0;
                   Alt_UseConstant[Loop]:=true;
                   Alt_MultLdg[Loop]:=1.0;
                 End
              Else If Has_Alt_Loadings(nstate,SVType,Layer)
                then
                  begin
                    Alt_Loadings[Loop]:=TLoadings.Load(IsTemp, St,ReadVersionNum);
                    LoadCollectionitems(IsTemp, St,Alt_Loadings[loop],False,ReadVersionNum);
                  end
                else Alt_Loadings[Loop]:=nil;
          End;

     End; {With LoadsRec}

   If IsTemp then
     Begin
       New(PRequiresData);
       New(PHasData);
       st.read(PRequiresData^,Sizeof(PRequiresData^));
       st.read(PHasData^,Sizeof(PHasData^));
     End;

   st.read(StateUnit,9);
   st.read(LoadingUnit,9);

   st.read(LoadsRec.MultLdg,Sizeof(LoadsRec.MultLdg));
   st.read(yHold,Sizeof(yHold));
   st.read(YOrig,Sizeof(YOrig));
   st.read(yout,Sizeof(yout));
   st.read(stepres[1],Sizeof(stepres[1]));
   st.read(yError,Sizeof(yError));
   st.read(yScale,Sizeof(yScale));

  If IsTemp then
    Begin
      New(PShowRates);
      St.read(PShowRates^,Sizeof(PShowRates^));
    End;

  RateColl  := nil;
  RateIndex := -1;

  If nstate=WindLoading then st.read(TWindLoading(Self).MeanValue,sizeof(double));

  LoadNotes1 := '';  LoadNotes2 := '';
  If ReadVersionNum > 1.635 then
    begin
      St.read(LoadNotes1,Sizeof(LoadNotes1));
      St.read(LoadNotes2,Sizeof(LoadNotes2));
    end;

  If IsTemp then
    Begin
      New(PTrackResults);
      If ReadVersionNum>1.799 then St.Read(PTrackResults^,Sizeof(PTrackResults^))
                              else PTrackResults^:=True;
    End;

  If Not IsTemp then
    Begin
      PShowRates := nil;
      PTrackResults := nil;
      PRequiresData := nil;
      PHasData := nil;
      Dispose(PName);
      PName := nil;
    End;
End;

Constructor TLight.Load(IsTemp: Boolean;Var St: TStream; ReadVersionNum: Double);
Begin
  Inherited Load(IsTemp, St,ReadVersionNum); 
  If ReadVersionNum<1.729
    then
      Begin
        CalculatePhotoperiod:=True;
        UserPhotoPeriod :=0;
      End
    else
      Begin
        St.read(CalculatePhotoperiod,Sizeof(CalculatePhotoperiod));
        St.read(UserPhotoPeriod,Sizeof(UserPhotoPeriod));
      End;
End;

Procedure TLight.Store(IsTemp: Boolean; var st: Tstream);
Begin
  Inherited; {TStateVariable}

  St.Write(CalculatePhotoperiod,Sizeof(CalculatePhotoperiod));
  St.Write(UserPhotoPeriod,Sizeof(UserPhotoPeriod));
End;

Procedure TLight.WriteText;
Begin
 Inherited WriteText(LF);   {TStateVariable}
 Write(LF,'CalculatePhotoperiod: '); If CalculatePhotoperiod then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
 Writeln(LF,'UserPhotoPeriod: '+FloatToStrF(UserPhotoPeriod,ffgeneral,5,5));
End;


Constructor TOrganism.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Var toxloop: T_SVType;
    steploop: integer;
    ionized: boolean;
    Junk: Double;
Begin
  Inherited Load(IsTemp, St,ReadVersionNum);   {TStateVariable}

  st.read(LCInfinite,Sizeof(LCInfinite));
  st.read(PrevFracKill,Sizeof(PrevFracKill));
  If ReadVersionNum<2.499
    then
      Begin
        st.read(DeltaCumFracKill,Sizeof(PrevFracKill));
        For steploop := 2 to 6 do
         For toxloop := FirstOrgTxTyp to LastOrgTxTyp do
           DeltaCumFracKill[ToxLoop,1{,StepLoop}] := 0;
      End
    else st.read(DeltaCumFracKill,Sizeof(DeltaCumFracKill));

  If ReadVersionNum<3.00
    Then
      Begin
        st.read(Junk,Sizeof(Junk));
        st.read(Junk,Sizeof(Junk));
        st.read(Junk,Sizeof(Junk));
        st.read(Junk,Sizeof(Junk));
        st.read(Junk,Sizeof(Junk));
        st.read(Junk,Sizeof(Junk));
        st.read(Junk,Sizeof(Junk));
        st.read(Junk,Sizeof(Junk));
        st.read(Junk,Sizeof(Junk));
        st.read(Junk,Sizeof(Junk));
      End;

  st.read(Resistant,Sizeof(Resistant));

  If ReadVersionNum > 3.165
    then
      Begin
        st.read(AmmoniaPrevFracKill,Sizeof(AmmoniaPrevFracKill));
        st.read(AmmoniaDeltaCumFracKill,Sizeof(AmmoniaDeltaCumFracKill));
        st.read(AmmoniaDeltaResistant,Sizeof(AmmoniaDeltaResistant));
        st.read(AmmoniaResistant,Sizeof(AmmoniaResistant));
      End
    else
      Begin
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
      End;

   If ReadVersionNum > 3.455
    then
      Begin
        st.read(SedPrevFracKill,Sizeof(SedPrevFracKill));
        st.read(SedDeltaCumFracKill,Sizeof(SedDeltaCumFracKill));
        st.read(SedDeltaResistant,Sizeof(SedDeltaResistant));
        st.read(SedResistant,Sizeof(SedResistant));
      End
    else
      Begin
         For StepLoop := 1 to 6 do
           Begin
             SedDeltaCumFracKill[StepLoop] := 0;
             SedDeltaResistant  [StepLoop] := 0;
           End;
         SedResistant    :=0;
         SedPrevFracKill :=0;
      End;


End;

Procedure TOrganism.Store(IsTemp: Boolean; var st: Tstream);

Begin
  Inherited; {TStateVariable}
  st.write(LCInfinite,Sizeof(LCInfinite));
  st.write(PrevFracKill,Sizeof(PrevFracKill));
  st.write(DeltaCumFracKill,Sizeof(DeltaCumFracKill));
  st.write(Resistant,Sizeof(Resistant));

  st.write(AmmoniaPrevFracKill,Sizeof(AmmoniaPrevFracKill));
  st.write(AmmoniaDeltaCumFracKill,Sizeof(AmmoniaDeltaCumFracKill));
  st.write(AmmoniaDeltaResistant,Sizeof(AmmoniaDeltaResistant));
  st.write(AmmoniaResistant,Sizeof(AmmoniaResistant));

  st.write(SedPrevFracKill,Sizeof(SedPrevFracKill));
  st.write(SedDeltaCumFracKill,Sizeof(SedDeltaCumFracKill));
  st.write(SedDeltaResistant,Sizeof(SedDeltaResistant));
  st.write(SedResistant,Sizeof(SedResistant));

End;

Procedure TNO3Obj.Store(IsTemp: Boolean;Var st: Tstream);
Var ALLoop: Alt_LoadingsType;
Begin
  Inherited; {TRemineralize}

 st.write(TN_IC,Sizeof(Boolean));
 st.write(TN_Inflow,Sizeof(Boolean));
 st.write(TN_PS,Sizeof(Boolean));
 st.write(TN_NPS,Sizeof(Boolean));
 st.write(NotUsed,Sizeof(NotUsed));
 For ALLoop:=PointSource to NonPointSource do
       st.write(Alt_NotUsed[ALLoop], Sizeof(Alt_NotUsed[ALLoop]));

End;

Procedure TNo3Obj.WriteText;
Begin
   Inherited; {TStateVariable}

 {   Writeln(LF,'FracAvail: '+FloatToStrF(FracAvail,ffgeneral,5,5));
     Writeln(LF,'Alt_FracAvail[pointsource]: '+FloatToStrF(Alt_FracAvail[pointsource],ffgeneral,5,5));
     Writeln(LF,'Alt_FracAvail[nonpointsource]: '+FloatToStrF(Alt_FracAvail[nonpointsource],ffgeneral,5,5)); NOT USED}
     Write(LF,'TN_IC: '); If TN_IC then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Write(LF,'TN_Inflow: '); If TN_Inflow then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Write(LF,'TN_PS: '); If TN_PS then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Write(LF,'TN_NPS: '); If TN_NPS then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
End;

Constructor TNO3Obj.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Var ALLoop: Alt_LoadingsType;
    Bool: Boolean;
Begin
 inherited Load(IsTemp,St,ReadVersionNum);   {inherited TRemineralize}
 If ReadVersionNum>2.515
   then
     Begin
       st.read(TN_IC,Sizeof(Boolean));
       st.read(TN_Inflow,Sizeof(Boolean));
       st.read(TN_PS,Sizeof(Boolean));
       If ReadVersionNum < 2.575 then st.read(Bool,Sizeof(Boolean));
       st.read(TN_NPS,Sizeof(Boolean));
       st.read(NotUsed,Sizeof(NotUsed));
       For ALLoop:=PointSource to NonPointSource do
         st.read(Alt_NotUsed[ALLoop], Sizeof(Alt_NotUsed[ALLoop]));
       If ReadVersionNum < 2.575 then st.read(Bool,Sizeof(Boolean));
     End
   else
     Begin
       TN_IC := False;
       TN_Inflow := False;
       TN_PS := False;
       TN_NPS := False;
{       FracAvail := 1;
       For ALLoop:=PointSource to NonPointSource do
         Alt_FracAvail[ALLoop]:=1;  NOT USED}
     End;
End;

Procedure TPO4Obj.Store(IsTemp: Boolean; Var st: Tstream);
Var ALLoop: Alt_LoadingsType;
Begin
  Inherited;  {TRemineralize}

 st.write(FracAvail,Sizeof(FracAvail));
 For ALLoop:=PointSource to NonPointSource do
       st.write(Alt_FracAvail[ALLoop], Sizeof(Alt_FracAvail[ALLoop]));

 st.write(TP_IC,Sizeof(Boolean));
 st.write(TP_Inflow,Sizeof(Boolean));
 st.write(TP_PS,Sizeof(Boolean));
 st.write(TP_NPS,Sizeof(Boolean));

End;

Procedure TPO4Obj.WriteText;
Begin
  Inherited WriteText(LF);   { TStateVariable}

     Writeln(LF,'FracAvail: '+FloatToStrF(FracAvail,ffgeneral,5,5));
     Writeln(LF,'Alt_FracAvail[pointsource]: '+FloatToStrF(Alt_FracAvail[pointsource],ffgeneral,5,5));
     Writeln(LF,'Alt_FracAvail[nonpointsource]: '+FloatToStrF(Alt_FracAvail[nonpointsource],ffgeneral,5,5));
     Write(LF,'TP_IC: '); If TP_IC then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Write(LF,'TP_Inflow: '); If TP_Inflow then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Write(LF,'TP_PS: '); If TP_PS then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Write(LF,'TP_NPS: '); If TP_NPS then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
End;


Constructor TPO4Obj.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Var ALLoop: Alt_LoadingsType;
    Bool: Boolean;
Begin
 inherited; {TRemineralize.Load(IsTemp, St,ReadVersionNum) }
 
 If ReadVersionNum>1.725
   then
     Begin
       st.read(FracAvail,Sizeof(FracAvail));
       For ALLoop:=PointSource to NonPointSource do
         st.read(Alt_FracAvail[ALLoop], Sizeof(Alt_FracAvail[ALLoop]));
     End
   else
     Begin
       MessageDlg2 ('Fractions Available for Phosphate loadings are being initialized to 1.0',mtInformation,[mbOK],0);
       FracAvail := 1;
       For ALLoop:=PointSource to NonPointSource do
         Alt_FracAvail[ALLoop]:=1;
     End;

 If (ReadVersionNum>2.515) and (ReadVersionNum < 2.575) then st.read(Bool,Sizeof(Boolean));

 If ReadVersionNum>2.575
   then
     Begin
       st.read(TP_IC,Sizeof(Boolean));
       st.read(TP_Inflow,Sizeof(Boolean));
       st.read(TP_PS,Sizeof(Boolean));
       st.read(TP_NPS,Sizeof(Boolean));
     End
   else
     Begin
       TP_IC := False;
       TP_Inflow := False;
       TP_PS := False;
       TP_NPS := False;
     End;
End;

Procedure  TphObj.Store(IsTemp: Boolean; var st: Tstream);
Begin
   inherited;
   st.write(alkalinity,Sizeof(alkalinity));
End;


Procedure TphObj.WriteText;
Begin
  Inherited;  {TStateVariable.WriteText(LF);}
  Writeln(LF,'Alkalinity: '+FloatToStrF(Alkalinity,ffgeneral,5,5));
End;


Constructor  TphObj.Load(IsTemp: Boolean; var st: Tstream; ReadVersionNum: Double);
Begin
  inherited;
  If ReadVersionNum > 2.535 then st.read(alkalinity,Sizeof(alkalinity))
                            else alkalinity := 1000; { ( default ueq CaCO3/L) }
End;


Procedure  TPreference.Store(IsTemp: Boolean; var st: Tstream);
Begin
     st.write(Preference,Sizeof(Preference));
     st.write(EgestCoeff,Sizeof(EgestCoeff));
     st.write(nState,Sizeof(nState));
End;

Procedure TPreference.WriteText;
Begin
  If Preference = 0 then exit;
  Write(LF,OutputText(nstate,stv,watercol,'',False,False,0));
  Write(LF,'  Preference: '+FloatToStrF(Preference,ffgeneral,5,5));
  Writeln(LF,'  EgestCoeff: '+FloatToStrF(EgestCoeff,ffgeneral,5,5));
End;

Constructor  TPreference.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Begin
   st.read(Preference,Sizeof(Preference));
   st.read(EgestCoeff,Sizeof(EgestCoeff));
   st.read(nState,Sizeof(nState));
   If (ReadVersionNum<=3.399) then nstate := Updatenstate(nstate,readversionnum);
End;

Procedure  TAnimal.Store(IsTemp: Boolean; var st: Tstream);
Begin
  Inherited;   {   TOrganism.Store(IsTemp, St);   }
   If IsTemp then
     Begin
       st.write(PAnimalData^,Sizeof(PAnimalData^));
       st.write(PTrophInt^,Sizeof(PTrophInt^));
     End;

   MyPrey.Store(IsTemp, St);
   StoreCollectionitems(IsTemp, St,MyPrey);

   st.write(CalcLipid,Sizeof(CalcLipid));
   st.write(Spawned,Sizeof(Spawned));
   st.write(SpawnTimes,Sizeof(SpawnTimes));
   st.write(AnadRec, Sizeof(AnadRec));
   If IsTemp then
     st.write(PSameSpecies^,Sizeof(PSameSpecies^));
   st.write(MigrInput,Sizeof(MigrInput));
End;


Procedure  TAnimal.WriteText;
Var MLoop: Integer;
Begin
   inherited; { TStateVariable.WriteText(LF)}
     AnimRec_To_Text(LF, PAnimalData^);

     Writeln(LF,'--- TROPHIC INTERACTIONS ---');
     ChangeData;  {reload original preferences from entry screen}
     WriteTextCollection(LF,MyPrey);

     If PSameSpecies^ <> NullStateVar then
       Writeln(LF,'Same Species as :'+StateText(PSameSpecies^,Stv,WaterCol));

     For MLoop := 1 to 5 do
      With MigrInput[MLoop] do
       If FracMigr > 0 then
        Writeln(LF,FloatToStrF(FracMigr,ffgeneral,5,5)+' Migrates to '
                   +ToSeg+' on Day: '+IntToStr(DD) + ' of Month: '+IntToStr(MM));
End;

Constructor TAnimal.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Var Junk: Double;
    MigrLoop: Integer;
    Loop: AllVariables;
    ToxLoop: T_SVType;
    OAD: OldZooRecord;
    BlankIF: InteractionFields;
Begin
     inherited; {TOrganism.Load(IsTemp, St,ReadVersionNum)}

     If IsTemp then
       Begin                                                             
         New(PAnimalData);
         New(PTrophInt);
         BlankIF.Pref := 0;
         BlankIF.ECoeff:= 0;
         BlankIF.XInteraction:= '';
         For loop := Cohesives to LastBiota do
           pTrophInt^[Loop] := blankif;

         if ReadVersionNum > 3.67 then st.read(PAnimalData^,Sizeof(PAnimalData^))
          else If ReadVersionNum > 3.605
          then st.read(PAnimalData^,10275)
           else
             Begin
               If ReadVersionNum > 3.165
                 then st.read(OAD,Sizeof(OAD))
                 else If ReadVersionNum > 2.999
                   then st.read(OAD,2403)
                   else TranslateAnimalData(St,ReadVersionNum,OAD,IsInvertebrate);
                TranslateAnimalData2(OAD,PAnimalData^);
             End;

         If ReadVersionNum > 2.999
             then st.read(PTrophInt^,Sizeof(PTrophInt^))
             else TranslateTrophInt(St,ReadVersionNum,PTrophInt^);


         If ReadVersionNum < 3.455 then with PAnimalData^ do
           Begin
             Sorting              := 1;    {3.46, SABS}
             XSorting             := 'Default -- no sediment effect';
             SuspSedFeeding       := False;
             XSuspSedFeeding      := 'Default -- no sediment effect';
             SlopeSSFeed          := 0;
             InterceptSSFeed      := 0;
             XSlopeSSFeed         := 'Default -- no sediment effect';
             XInterceptSSFeed     := 'Default -- no sediment effect';
             SenstoSediment       := 'Zero Sensitivity';
             XSensToSediment      := 'Default -- no sediment effect';
             Trigger              := 0;
             XTrigger             := 'Default -- no sediment effect';
           End;

         If ReadVersionNum < 3.535 then with PAnimalData^ do
           Begin
             SenstoPctEmbed       := False;
             PctEmbedThreshold   := 100;
             XPctEmbedThreshold  := 'No effect';
           End;

         If ReadVersionNum < 3.575 then
           Begin
             PAnimalData^.BenthicDesignation := '';
           End;

         If ReadVersionNum < 3.671 then
           Begin
             PAnimalData^.ScientificName := '';
           End;
       End;

     If Not IsTemp then
       Begin
         PAnimalData := nil;
         PTrophInt := nil;
       End;

     If IsTemp and (ReadVersionNum < 3.155) then with PAnimaldata^ do
       Begin
         O2_LethalConc  := 1.0;
         O2_LethalPct   := 50;
         O2_LCRef       := 'Default';

         O2_EC50growth  := 2.0;
         XO2_EC50growth := 'Default';
         O2_EC50repro   := 3.0;
         XO2_EC50repro  := 'Default';
       End;

     If IsTemp and (ReadVersionNum < 3.165) then with PAnimaldata^ do
       Begin
         Ammonia_LC50 := 25;   {3-6-2008}
         XAmmonia_LC50 := 'Default';
       End;

     MyPrey:=TCollection.Load(IsTemp, St,ReadVersionNum);
     LoadCollectionitems(IsTemp,St,MyPrey,False,ReadVersionNum);

     st.read(CalcLipid,Sizeof(CalcLipid));
     st.read(Spawned,Sizeof(Spawned));

     If ReadVersionNum > 1.849 then st.read(SpawnTimes,Sizeof(SpawnTimes));

     If ReadVersionNum > 3.775
        then st.read(AnadRec, Sizeof(AnadRec))
        else
           Begin
             AnadRec.IsAnadromous := False;
             AnadRec.YearsOffSite := 3;
             AnadRec.DateJuvMigr := 70;
             AnadRec.DateAdultReturn := 100;
             AnadRec.FracMigrating := 0.2;
             AnadRec.MortalityFrac := 0.5;
           End;

     If (ReadVersionNum < 2.99) then
        begin
          st.read(Junk,Sizeof(Junk)); {HG_EC50_Growth}
          st.read(Junk,Sizeof(Junk)); {HG_EC50_Repro}
        end;


    If IsTemp then ChangeData;

    PromSmFish:=0;
    EmergeInsect:=0;
    Recruit:=0;
    IsLeavingSeg:=False;
    SumPrey := 0;
    RecrSave := 0;

    PSameSpecies := nil;
    If IsTemp or (ReadVersionNum<3.115) then
      Begin
        New(PSameSpecies);
        st.read(PSameSpecies^,Sizeof(PSameSpecies^));
        If (ReadVersionNum<=3.399) then PSameSpecies^ := UpdateNstate(PSameSpecies^,readversionnum);
      End;

    MortRates.OtherMort := 0;
    For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
        MortRates.OrgPois[ToxLoop] := 0;

   If ReadVersionNum < 2.999
     Then
       For MigrLoop := 1 to 5 do
         Begin
           MigrInput[MigrLoop].FracMigr := 0;
           MigrInput[MigrLoop].ToSeg := '';
           MigrInput[MigrLoop].DD := 0;
           MigrInput[MigrLoop].MM := 0;
         End
     Else st.read(MigrInput,Sizeof(MigrInput));

   LastO2CalcTime[O2Mortality] := -99;  {init optimization vars.}
   LastO2CalcTime[O2Repro_Red] := -99;
   LastO2CalcTime[O2Growth_Red] := -99;
   LastSedCalcTime := -99;
End;

Procedure  TPlant.Store(IsTemp: Boolean; var st: Tstream);
Begin
  Inherited;  { TOrganism.Store(IsTemp, St);   }
    If IsTemp then  st.write(PAlgalRec^,Sizeof(PAlgalRec^));
    If IsTemp then  st.write(PSameSpecies^,Sizeof(PSameSpecies^));
End;

Procedure  TPlant.WriteText;
Begin
     inherited; { TStateVariable.WriteText(LF); }
     PlantRec_To_Text(LF, PAlgalRec^);

     If PSameSpecies^ <> NullStateVar then
       Writeln(LF,'Same Species as :'+StateText(PSameSpecies^,Stv,WaterCol));
End;


Constructor  TPlant.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Var ToxLoop: T_SVType;
    Junk: Double;
    OPR: OldPlantRecord;
Begin
     Inherited; {TOrganism.Load(IsTemp, St,ReadVersionNum);}
     If IsTemp then
       Begin
        New(PAlgalRec);
        If ReadVersionNum > 3.825 then st.read(PAlgalRec^,Sizeof(PAlgalRec^))
         else If ReadVersionNum > 3.67 then st.read(PAlgalRec^,7631)
          else If ReadVersionNum > 3.605
           then st.read(PAlgalRec^,7011)
           else
            Begin  {OldPlantRec}
             If ReadVersionNum<2.99
               then TranslateAlgalRec(St,ReadVersionNum,OPR,nstate)
               else st.read(OPR,sizeof(OPR));

               If LowerCase(OPR.ToxicityRecord)='blue-greens' then
                  OPR.ToxicityRecord:='Bluegreens';

               If IsTemp and (ReadVersionNum < 3.485) then With OPR do
                   UseAdaptiveLight := False;

               If IsTemp and (ReadVersionNum < 3.495) then With OPR do
                 Begin
                   MinLightSat := 80;    XMinLightSat := 'Default';
                   MaxLightSat := 300;   XMaxLightSat := 'Default';
                 End;

               If IsTemp and (ReadVersionNum < 3.405) then With OPR do
                 Begin
                   PctSloughed   := 90;
                   XPctSloughed  := '90% lost in sloughing event as default';
                 End;

               If ReadVersionNum<2.99 then
                 Begin
                   OPR.Macrophyte_Type := 'benthic';
                   st.read(Junk,Sizeof(Junk)); {>=1.799}
                 End;

              TranslateAlgalRec2(OPR,PAlgalRec^);
           End; {OPR}

         If ReadVersionNum < 3.685 then
           Begin
             PAlgalRec^.PlantFracLipid := 0.2;
             PAlgalRec^.XPlantFracLipid := 'Default when loading simulation.';
           End;

         If ReadVersionNum < 3.795 then
           PAlgalRec^.SurfaceFloating := (nstate in [BlGreens1..BlGreens6]) and (not IsPeriphyton);

         If ReadVersionNum < 3.825 then with PAlgalRec^ do
           Begin
              NHalfSatInternal     := 0.009;
              XNHalfSatInternal    := 'WASP7, Ambrose et al. 2006';
              PHalfSatInternal     := 0.0013;
              XPHalfSatInternal    := 'WASP7, Ambrose et al. 2006';
              MaxNUptake           := 0.72;
              XMaxNUptake          := 'WASP7, Ambrose et al. 2006';
              MaxPUptake           := 0.05;
              XMaxPUptake          := 'WASP7, Ambrose et al. 2006';
              Min_N_Ratio          := 0.0072;
              XMin_N_Ratio         := 'WASP7, Ambrose et al. 2006';
              Min_P_Ratio          := 0.001;
              XMin_P_Ratio         := 'WASP7, Ambrose et al. 2006';
           End;
       End; {IsTemp}

   If Not IsTemp then PAlgalRec := nil;

    MortRates.OtherMort := 0;
    For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
        MortRates.OrgPois[ToxLoop] := 0;

  If IsTemp then ChangeData;

  PSameSpecies := nil;
  If ReadVersionNum<2.525
    then Begin
            New(PSameSpecies);
            PSameSpecies^:=nullstatevar
         End
    else If IsTemp or (ReadVersionNum<3.115) then
         Begin
           New(PSameSpecies);
           st.read(PSameSpecies^,Sizeof(PSameSpecies^));
           If ReadVersionNum<3.39 then PSameSpecies^ := UpdateNstate(PSameSpecies^,readversionnum);
         End;

End;

{--------------------------------------------------------------------}

Constructor TVolume.Load(IsTemp: Boolean; Var st: TStream; ReadVersionNum: Double);
Begin
 Inherited; { TStateVariable.Load(IsTemp, St,ReadVersionNum);}

 st.read(Calc_Method,Sizeof(Calc_Method));
 If ReadVersionNum > 3.415
   then
     Begin
       st.read(StratInflow,Sizeof(StratInflow));
       st.read(StratOutflow,Sizeof(StratOutflow));
     End
   else Begin StratInflow:=FtBoth; StratOutflow:=FTBoth;  End;

 If ReadVersionNum > 3.505 then
     Begin
         St.Read(StratAutomatically,Sizeof(StratAutomatically));
         StratDates:=nil;
         StratDates:=TLoadings.Load(IsTemp,St,ReadVersionNum);
         LoadCollectionitems(IsTemp,St,StratDates,False,ReadVersionNum);
       End
     Else
       Begin
         StratAutomatically := True;
         StratDates  := TLoadings.Init(10,50);
       End;

 Inflow:=0; Discharg:=0;
 InflowLoad:=0;   DischargeLoad:=0; KnownValueLoad:=0;
 LastTimeTA := 0; LastCalcTA := 0;
 OOSDischFracLoad:=0; OOSInflowFracLoad:=0;


End;

Procedure TVolume.WriteText;
Begin
 inherited; { TStateVariable.WriteText(LF);   }
 Write(LF,'Water Volume Calculation Method: ');
 Case Calc_Method of
   Manning: Writeln(LF,'Mannings Eqn.');
   KeepConst: Writeln(LF,'Keep Const.');
   Dynam: Writeln(LF,'Dynamic.');
   KnownVal: Writeln(LF,'Use Known Val.');
 End; {Case}

 Case StratInflow of
   FTEpi: Writeln(LF,'Inflow to Epilimnion');
   FTHyp: Writeln(LF,'Inflow to Hypolimnion');
 End;

 Case StratOutflow of
   FTEpi: Writeln(LF,'Outflow to Epilimnion');
   FTHyp: Writeln(LF,'Outflow to Hypolimnion');
 End;

 IF not StratAutomatically then
   Begin
       Writeln(LF,'---------------------------------------');
       Writeln(LF,'Stratification at user input dates:');
       WriteTextCollection(LF,StratDates);
       Writeln(LF);
   End;

End;

Procedure TVolume.Store(IsTemp: Boolean; var st: TStream);
Begin
 Inherited;   { TStateVariable.Store(IsTemp, St);   }
 st.write(Calc_Method,Sizeof(Calc_Method));
 st.write(StratInflow,Sizeof(StratInflow));
 st.write(StratOutflow,Sizeof(StratOutflow));
 St.write(StratAutomatically,Sizeof(StratAutomatically));
 StratDates.Store(IsTemp, St);
 StoreCollectionitems(IsTemp, St,StratDates);

End;

{--------------------------------------------------------------------}

Procedure  TToxics.Store(IsTemp: Boolean; var st: Tstream);
Var Junk: Double;
Begin

  Inherited;
{    TStateVariable.Store(IsTemp, St);   }
     st.write(ppb,Sizeof(ppb));
     st.write(junk,Sizeof(junk));
     st.write(Carrier,Sizeof(Carrier));
End;

Constructor TToxics.load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Var NotUsed1,NU2,NU3,junk: Double;
Begin
     inherited; {TStateVariable.Load(IsTemp, St,ReadVersionNum);   }
     st.read(ppb,Sizeof(ppb));
     st.read(junk,Sizeof(junk));
     If ReadVersionNum < 3.00 then
       Begin
         st.read(NotUsed1,Sizeof(NotUsed1));
         st.read(NU2,Sizeof(NU2));
         st.read(NU3,Sizeof(NU2));
       End;
     st.read(Carrier,Sizeof(Carrier));
     If ReadVersionNum<3.39 then Carrier := UpdateNState(Carrier,ReadVersionNum);



     Carrier:=nstate;
     If nstate in [FirstTox..LastTox] then Carrier:=NullStateVar;
     RecrSave  :=0;
End;

Procedure  TFishTox.Store(IsTemp: Boolean; var st: Tstream);
Begin

  Inherited;
{     TToxics.Store(IsTemp, St);   }
End;

Constructor  TFishTox.load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Begin
     inherited; {TToxics.Load(IsTemp, St,ReadVersionNum);   }
End;


Procedure  TResHeader.Store(IsTemp: Boolean; var st: Tstream);
Begin
  St.Write(AllState, Sizeof(AllState));
  St.Write(SVType,   Sizeof(SVType));
  St.Write(Layer,    Sizeof(Layer));

  St.Write(HeadStr, Sizeof(HeadStr));
  St.Write(UnitSTr, Sizeof(UnitStr));
  St.Write(PPB,     Sizeof(PPB));
  St.Write(ToxVar,  Sizeof(ToxVar));
  St.Write(BAFVar,  Sizeof(BAFVar));
  St.Write(RateVar, Sizeof(RateVar));
  St.Write(SortIndex,Sizeof(SortIndex));
  St.Write(PointIndex,Sizeof(PointIndex));
  St.Write(RateIndex,Sizeof(RateIndex));

End;


Constructor  TResHeader.load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Var BAFBool: Boolean;
Begin
  St.Read(AllState, Sizeof(AllState));
  St.Read(SVType,   Sizeof(SVType));
  If (ReadVersionNum > 3.305) then St.Read(Layer, Sizeof(Layer))
                              else Layer := WaterCol;

   If (ReadVersionNum < 3.39) and (SVType = StV) then
     AllState := UpdateNState(AllState,ReadVersionNum);

  St.Read(HeadStr, Sizeof(HeadStr));
  St.Read(UnitStr, Sizeof(UnitStr));
  St.Read(PPB,     Sizeof(PPB));
  St.Read(ToxVar,  Sizeof(ToxVar));
  If ReadVersionNum < 3.695 then
    Begin
      St.Read(BAFBool,  Sizeof(BAFBool));
      BAFVar := 0;
      If BAFBool then BAFVar := 1;
    End
   else St.Read(BAFVar,  Sizeof(BAFVar));

  If ReadVersionNum > 3.185 then St.Read(RateVar, Sizeof(RateVar))
                            else RateVar := False;
  St.Read(SortIndex,Sizeof(SortIndex));
  St.Read(PointIndex,Sizeof(PointIndex));

  If ReadVersionNum < 3.415 then RateIndex := 0
                            else St.Read(RateIndex,Sizeof(RateIndex));

  If (ReadVersionNum < VersionNum) and (ReadVersionNum > 3.4201)
     then SortIndex := CalcUniqueIndex(AllState,SVType,Layer,PPB,ToxVar,RateVar,BAFVar,RateIndex);

End;


Procedure  TResultsCollection.Store(IsTemp: Boolean; var st: Tstream);
Begin
  Inherited;
{     TCollection.Store(IsTemp, St); }

     Headers.Store(IsTemp, St);
     StoreCollectionitems(IsTemp, St,Headers);
End;

Constructor  TResultsCollection.load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Begin
  inherited Load(IsTemp,St,ReadVersionNum); {TCollection}

  Headers:=THeaderColl.Load(IsTemp, St,ReadVersionNum);
  LoadCollectionitems(IsTemp, St,Headers,True, ReadVersionNum);
End;


Procedure  TResults.Store(IsTemp: Boolean; var st: Tstream);
Begin
     st.write(Date,Sizeof(Date));
     Datapoints.Store(IsTemp, St);
     StoreCollectionitems(IsTemp, St,DataPoints);
End;

Constructor  TResults.load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
begin
     st.read(Date,Sizeof(Date));
     Datapoints:=TCollection.Load(IsTemp, St,ReadVersionNum);
     LoadCollectionitems(IsTemp, St,DataPoints,False,ReadVersionNum);
     Final := True;
End;

Procedure  TDataPoint.Store(IsTemp: Boolean; var st: Tstream);
Begin
   If TeaseScreen then
     Begin
       Inc(TeaseInc);
       If TeaseInc=1000 then Begin WaitDlg.Tease; TeaseInc:=1; End;
     End;

     st.write(State,Sizeof(State));
End;

Constructor  TDataPoint.load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Var Junk: Word;

Begin
  If TeaseScreen then
     Begin
       Inc(TeaseInc);
       If TeaseInc=1000 then Begin WaitDlg.Tease; TeaseInc:=1; End;
     End;

   If ReadVersionNum < 1.725 then
      St.Read(Junk,1);

     st.read(State,Sizeof(State));
End;


Constructor TSuspSediment.Load(IsTemp: Boolean; Var St: Tstream; ReadVersionNum: Double);

Var junk: Double;

Begin
   inherited; {TStateVariable.Load(IsTemp, St,ReadVersionNum);   }

   If ReadVersionNum < 1.999
     then
       Begin
         st.read(junk,Sizeof(junk));
         st.read(junk,Sizeof(junk));
         st.read(junk,Sizeof(junk));
       End;

End;

Constructor TSandSiltClay.Load(IsTemp:Boolean; St: Tstream; ReadVersionNum: Double);
Begin
   inherited Load(IsTemp, St, ReadVersionNum);   {TStateVariable}
   st.read(FracInBed,Sizeof(FracInBed));
   st.read(Frac_Silt_Scour,Sizeof(Frac_Silt_Scour));
   st.read(Frac_Silt_Dep,Sizeof(Frac_Silt_Dep));
   If ReadVersionNum > 3.445
     then st.read(TSS_Solids,Sizeof(TSS_Solids))
     else TSS_Solids := True;
   Deposition := 0;
End;

Procedure TSandsiltclay.WriteText;
Begin
  inherited; { TStateVariable.WriteText(LF);   }
  Writeln(LF,'FracInBed: '+FloatToStrF(FracInBed,ffgeneral,5,5));
  Writeln(LF,'Frac_Silt_Scour: '+FloatToStrF(Frac_Silt_Scour,ffgeneral,5,5));
  Writeln(LF,'Frac_Silt_Dep: '+FloatToStrF(Frac_Silt_Dep,ffgeneral,5,5));
  If (NState = TSS) and TSS_Solids then Writeln(LF,'TSS represents Solids (including organics)')
                                   else Writeln(LF,'TSS represents Inorganic Sediments Only');

End;

Procedure TSandSiltClay.Store(IsTemp: Boolean; var st: Tstream);
Begin
  Inherited;
{   TStateVariable.Store(IsTemp, St);   }
   st.write(FracInBed,Sizeof(FracInBed));
   st.write(Frac_Silt_Scour,Sizeof(Frac_Silt_Scour));
   st.write(Frac_Silt_Dep,Sizeof(Frac_Silt_Dep));
   st.write(TSS_Solids,Sizeof(TSS_Solids));
End;


Procedure TSuspSediment.Store(IsTemp: Boolean; var st: Tstream);

Begin
  Inherited;
{   TStateVariable.Store(IsTemp, St);   }
End;

Constructor TBottomSediment.Load(IsTemp: Boolean; Var St: Tstream; ReadVersionNum: Double);
Var Junk: Double;
Begin
   inherited; {TStateVariable.Load(IsTemp, St,ReadVersionNum);    }

   If (NState in [Cohesives..NonCohesives2]) and (Layer=SedLayer1) then
      If ReadVersionNum > 1.999
        then
           Begin
             Load_Loadings(IsTemp, LScour,St,ReadVersionNum);
             Load_Loadings(IsTemp,LDeposition,St,ReadVersionNum);
           End
        else
           Begin
             LScour   := EmptyLoad;
             LDeposition := EmptyLoad;
           End;

  If ReadVersionNum>1.99 then st.read(Junk,Sizeof(Junk));
End;


Procedure TBottomSediment.Writetext;
Begin
 inherited; { TStateVariable.WriteText(LF);   }
 Write(LF,'SCOUR INPUTS-- ');
 LoadingsRectoText(LF,LScour,False);
 Write(LF,'DEPOSITION INPUTS-- ');
 LoadingsRectoText(LF,LDeposition,False);
End;


Procedure TBottomSediment.Store(IsTemp: Boolean; var st: Tstream);
Var Junk: Double;
Begin
  Inherited;
{   TStateVariable.Store(IsTemp, St);    }

   If (NState in [Cohesives..NonCohesives2]) and (Layer=SedLayer1) then
     Begin
       Store_Loadings(IsTemp,LScour,St);
       Store_Loadings(IsTemp,LDeposition,St);
     End;
   Junk := 56;  {lucky number}
   st.write(Junk,Sizeof(Junk));
End;


Procedure TStateVariable.Store_Loadings(IsTemp: Boolean; Var Ld: LoadingsRecord; Var st: TStream);
{Note this does not load and save MultLdg}
Begin
  With Ld Do
    Begin
      Loadings.Store(IsTemp, St);
      StoreCollectionitems(IsTemp, St,Loadings);
      st.write(ConstLoad,Sizeof(ConstLoad));
      st.write(UseConstant,Sizeof(UseConstant));
      st.write(NoUserLoad,Sizeof(NoUserLoad));
    End;
End;


Procedure TStateVariable.Load_Loadings(IsTemp: Boolean; Var Ld: LoadingsRecord; Var St: TStream; ReadVersionNum: Double);
{Note this does not load and save MultLdg}
Begin
  With Ld Do
    Begin
      Loadings := TLoadings.Load(IsTemp, St,ReadVersionNum);
      LoadCollectionitems(IsTemp, St,Loadings,False,ReadVersionNum);

      st.read(ConstLoad,Sizeof(ConstLoad));
      st.read(UseConstant,Sizeof(UseConstant));
      st.read(NoUserLoad,Sizeof(NoUserLoad));
      MultLdg := 1;
    End;
End;

Constructor TBottomCohesives.Load(IsTemp: Boolean; Var St: Tstream; ReadVersionNum: Double);
Begin
  inherited; {    TBottomSediment.Load(IsTemp, St,ReadVersionNum);    }

  If (Layer=SedLayer1) then
    If ReadVersionNum > 1.99
      then
         Begin
           Load_Loadings(IsTemp,LErodVel,st,ReadVersionNum);
           Load_Loadings(IsTemp,LDepVel,st,ReadVersionNum);
         End
      else
         Begin
           LErodVel:= EmptyLoad;
           LDepVel := EmptyLoad;
         End;
  EVel:=0;  DVel:=0;
End;

Procedure TBottomCohesives.Store(IsTemp: Boolean; var st: Tstream);
Begin
  Inherited;
{   TBottomSediment.Store(IsTemp, St);    }

   If (Layer=SedLayer1) then
     Begin
       Store_Loadings(IsTemp,LErodVel,st);
       Store_Loadings(IsTemp,LDepVel,st);
     End;
End;

Procedure TBottomCohesives.Writetext;
Begin
 inherited; {  TStateVariable.WriteText(LF);   }
 Write(LF,'ERODE VEL. INPUTS-- ');
 LoadingsRectoText(LF,LErodVel,False);
 Write(LF,'DEP.VEL. INPUTS-- ');
 LoadingsRectoText(LF,LDepVel,False);     
End;

Procedure TWindLoading.Writetext;
Begin
 inherited; {  TStateVariable.WriteText(LF);   }
 FloatToStrF(MeanValue,ffgeneral,5,5)
End;

Constructor TBuriedDetr1.Load(IsTemp:Boolean; St: Tstream; ReadVersionNum: Double);
Var Assoc_Tox,Assoc_MeHg, Assoc_HgII: Double;
Begin
   inherited Load(IsTemp, St,ReadVersionNum);    {TStateVariable}

   If ReadVersionNum<1.799 then
     Begin
       st.read(Assoc_Tox,Sizeof(Assoc_Tox));
       st.read(Assoc_MeHg,Sizeof(Assoc_MeHg));
       st.read(Assoc_HgII,Sizeof(Assoc_HgII));
       {AssocTox, MeHg, HgII is now irrelevant}
     End;

  TotalScour :=0;       {g/m2 d}
  Frac_Sed_Scour:=0;
  Frac_Buried_Scour:=0;
  BuriedDetr_To_Sed:=0;  {g/m2 d}
  TotalDep:=0;           {g/m2 d}
  Frac_Dep_ToSed:=0;
  Frac_Dep_ToBuried:=0;
  SedDetr_To_Buried:=0;  {mg/L}
End;

Procedure TBuriedDetr1.Store(IsTemp: Boolean; var st: Tstream);
Begin
  Inherited; {TStateVariable}
End;


Constructor TBuriedDetrTox1.Load(IsTemp:Boolean; St: Tstream; ReadVersionNum: Double);
Begin
   Inherited Load(IsTemp, St,ReadVersionNum);   {TToxics }
End;

Procedure TBuriedDetrTox1.Store(IsTemp: Boolean; var st: Tstream);
Begin
  Inherited;  {TToxics}
End;

Procedure TDissRefrDetr.Store(IsTemp: Boolean; Var st: Tstream);
Var Alt_Loop: Alt_LoadingsType;
    ToxLoop: T_SVType;
Begin
  With InputRecord do
    Begin
      St.Write(InputRecord,Sizeof(InputRecord));

      Load.Loadings.Store(IsTemp, St);
      StoreCollectionitems(IsTemp, St,Load.Loadings);
      For ToxLoop := FirstToxTyp to LastToxTyp do
        Begin
          ToxLoad[ToxLoop].Loadings.Store(IsTemp, St);
          StoreCollectionitems(IsTemp, St,ToxLoad[ToxLoop].Loadings);
        End;

      For Alt_Loop := PointSource to NonPointSource do
         With Load do
           Begin
             Alt_Loadings[Alt_Loop].Store(IsTemp, St);
             StoreCollectionitems(IsTemp, St,Alt_Loadings[Alt_Loop]);
           End;

      Percent_Part.Loadings.Store(IsTemp, St);
      StoreCollectionitems(IsTemp, St,Percent_Part.Loadings);
      Percent_Refr.Loadings.Store(IsTemp, St);
      StoreCollectionitems(IsTemp, St,Percent_Refr.Loadings);

      {Handle PS, NPS Loadings}
      For Alt_Loop := PointSource to NonPointSource do
         Begin
           Percent_Part.Alt_Loadings[Alt_Loop].Store(IsTemp, St);
           StoreCollectionitems(IsTemp, St,Percent_Part.Alt_Loadings[Alt_Loop]);
           Percent_Refr.Alt_Loadings[Alt_Loop].Store(IsTemp, St);
           StoreCollectionitems(IsTemp, St,Percent_Refr.Alt_Loadings[Alt_Loop]);
           For ToxLoop := FirstToxTyp to LastToxTyp do
             Begin
               ToxLoad[ToxLoop].Alt_Loadings[Alt_Loop].Store(IsTemp, St);
               StoreCollectionitems(IsTemp, St,ToxLoad[ToxLoop].Alt_Loadings[Alt_Loop]);
             End;
         End;

    End;

  Inherited; {TRemineralize}
End;

Procedure TDissRefrDetr.WriteText;
Var Chem: FirstOrgTxTyp..LastOrgTxTyp;
Begin
  inherited; { TStateVariable.WriteText(LF);   }

  With InputRecord do
    Begin
      Write(LF,'Percent_Part: ');
      LoadingsRectoText(LF,Percent_Part,False);
      Write(LF,'Percent_Refr: ');
      LoadingsRectoText(LF,Percent_Refr,False);
      Writeln(LF,'InitCond: '+FloatToStrF(InitCond,ffgeneral,5,5));
      LoadingsRectoText(LF,Load,True);
       For Chem := FirstOrgTxTyp to LastOrgTxTyp do
        If GetStatePointer(AssocToxSV(Chem),StV,WaterCol) <> nil then
          Begin
            Writeln(LF,'T'+IntToStr(ORD(Chem)-1)+' Init Cond: '+FloatToStrF(ToxInitCond[Chem],ffgeneral,5,5));
            LoadingsRectoText(LF,ToxLoad[Chem],False);
          End;
      Writeln(LF,'Percent_PartIC: '+FloatToStrF(Percent_PartIC,ffgeneral,5,5));
      Writeln(LF,'Percent_RefrIC: '+FloatToStrF(Percent_RefrIC,ffgeneral,5,5));
    End;
End;

Constructor TDissRefrDetr.Load(IsTemp: Boolean; Var st: Tstream;ReadVersionNum: Double);

Type Rel2InputRecord=  {Release 2}
     Packed Record
       Percent_Partold, Percent_Refrold,
       InitCondold                     : Double;
       MeHg_InitC, HgII_InitC          : Double;
       ToxInitCondold                  : ToxInitCondType;
       Load,MeHgLoad,HgIILoad          : LoadingsRecord;
       ToxLoadold                      : ToxLoadType;
       DataTypeold                     : DetrDataType;
                               f1,f2,f3: Byte; {d4-5}
       Percent_PartIC, Percent_RefrIC  : Double;
     End; {record}


Var Alt_Loop: Alt_LoadingsType;
    Rel2IR: Rel2InputRecord;
    ToxLoop: T_SVType;

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
       EmptyLoad.Alt_UseConstant[PointSource]   := True;
       EmptyLoad.Alt_UseConstant[DirectPrecip]  := True;
       EmptyLoad.Alt_UseConstant[NonPointSource]:= True;
       EmptyLoad.Alt_MultLdg[PointSource]   := 1;
       EmptyLoad.Alt_MultLdg[DirectPrecip]  := 1;
       EmptyLoad.Alt_MultLdg[NonPointSource]:= 1;
    End;

Begin
  If ReadVersionNum < 3.00
    Then Begin
           Inherited Load(IsTemp, St,ReadVersionNum);
           St.Read(Rel2IR,Sizeof(Rel2IR));
         End
    else St.Read(InputRecord,Sizeof(InputRecord));

  If (ReadVersionNum < 3.765) and (InputRecord.DataType = CBOD) and (Not BODConvertWarning) then
    Begin
      MessageDlg2 ('Warning: Your study has inputs of organic matter in BOD units. AQUATOX 3.1 uses a different method '+
                   'than Release 3.0 for converting CBOD to organic matter, based on percent refractory rather than BOD5_CBODu. '+
                   '(Please see equation 148c in the latest Tech. Doc.).  The quantity of OM loaded into your system may be different '+
                   'than in previous model results.  Note, the default BOD5_CBODu ratio was 2.47 which corresponds to a 60% refractory loading.'
                    ,mtWarning,[mbOK],0);
      BODConvertWarning := True;
    End;

  If ReadVersionNum<3.00 then with InputRecord do
    Begin
      DataType :=  Rel2IR.DataTypeold;
      InitCond :=  Rel2IR.InitCondold;
      Percent_PartIC :=  Rel2IR.Percent_PartIC;
      Percent_RefrIC :=  Rel2IR.Percent_RefrIC;
      Load           :=  Rel2IR.Load;
      Percent_Part := EmptyLoad;
      Percent_Refr := EmptyLoad;
      Percent_Part.ConstLoad := Rel2IR.Percent_Partold;
      Percent_Refr.ConstLoad := Rel2IR.Percent_Refrold;
      Percent_RefrIC := Rel2IR.Percent_RefrIC;
      Percent_PartIC := Rel2IR.Percent_PartIC;
      Percent_Part.UseConstant := True;
      Percent_Refr.UseConstant := True;
      ToxInitCond  := Rel2IR.ToxInitCondold;
      ToxLoad      := Rel2IR.ToxLoadold;
      InputRecord.Percent_Part.Loadings := TLoadings.Init(10,20);
      InputRecord.Percent_Refr.Loadings := TLoadings.Init(10,20);
      For Alt_Loop := PointSource to NonPointSource do
        Begin
          InputRecord.Percent_Part.Alt_UseConstant[Alt_Loop] := True;
          InputRecord.Percent_Refr.Alt_UseConstant[Alt_Loop] := True;
          InputRecord.Percent_Refr.Alt_ConstLoad[Alt_Loop] :=Rel2IR.Percent_Refrold;
          InputRecord.Percent_Part.Alt_ConstLoad[Alt_Loop] :=Rel2IR.Percent_Partold;

          InputRecord.Percent_Part.Alt_Loadings[Alt_Loop] := TLoadings.Init(10,20);
          InputRecord.Percent_Refr.Alt_Loadings[Alt_Loop] := TLoadings.Init(10,20);
          For ToxLoop := FirstToxTyp to LastToxTyp do
            Begin
              ToxLoad[ToxLoop].Alt_Loadings[Alt_Loop] := TLoadings.Init(10,20);
              ToxLoad[ToxLoop].Alt_UseConstant[Alt_Loop] := True;
              ToxLoad[ToxLoop].Alt_MultLdg[Alt_Loop] := 1.0;
              ToxLoad[ToxLoop].Alt_ConstLoad[Alt_Loop] := 0;
            End;
        End;
    end;

  If ReadVersionNum < 2.999 then with InputRecord do
    Begin
      Load.Loadings := TLoadings.Load(IsTemp, St,ReadVersionNum);
      LoadCollectionitems(IsTemp, St,Load.Loadings,False,ReadVersionNum);
      For ToxLoop := FirstToxTyp to LastToxTyp do
        Begin
          ToxLoad[ToxLoop].Loadings := TLoadings.Load(IsTemp, St,ReadVersionNum);
          LoadCollectionitems(IsTemp, St,ToxLoad[ToxLoop].Loadings,False,ReadVersionNum);
        End;

      Rel2IR.MeHgLoad.Loadings := TLoadings.Load(IsTemp, St,ReadVersionNum);
      LoadCollectionItems(IsTemp, St,Rel2IR.MeHgLoad.Loadings,False,ReadVersionNum);
      Rel2IR.hgiiLoad.Loadings := TLoadings.Load(IsTemp, St,ReadVersionNum);
      LoadCollectionItems(IsTemp, St,Rel2IR.hgiiLoad.Loadings,False,ReadVersionNum);
      For Alt_Loop := PointSource to NonPointSource do
         With Load do
           Begin
             Alt_Loadings[Alt_Loop] := TLoadings.Load(IsTemp, St,ReadVersionNum);
             LoadCollectionitems(IsTemp, St,Alt_Loadings[Alt_Loop],False,ReadVersionNum);
           End;
    End;


  If ReadVersionNum > 2.999
    then With InputRecord do
    Begin
      Load.Loadings := TLoadings.Load(IsTemp, St,ReadVersionNum);
      LoadCollectionitems(IsTemp, St,Load.Loadings,False,ReadVersionNum);
      For ToxLoop := FirstToxTyp to LastToxTyp do
        Begin
          ToxLoad[ToxLoop].Loadings := TLoadings.Load(IsTemp, St,ReadVersionNum);
          LoadCollectionitems(IsTemp, St,ToxLoad[ToxLoop].Loadings,False,ReadVersionNum);
        End;

      For Alt_Loop := PointSource to NonPointSource do
         With Load do
           Begin
             Alt_Loadings[Alt_Loop] := TLoadings.Load(IsTemp, St,ReadVersionNum);
             LoadCollectionitems(IsTemp, St,Alt_Loadings[Alt_Loop],False,ReadVersionNum);
           End;

      Percent_Part.Loadings := TLoadings.Load(IsTemp, St,ReadVersionNum);
      LoadCollectionitems(IsTemp, St,Percent_Part.Loadings,False,ReadVersionNum);
      Percent_Refr.Loadings := TLoadings.Load(IsTemp, St,ReadVersionNum);
      LoadCollectionitems(IsTemp, St,Percent_Refr.Loadings,False,ReadVersionNum);

      {Handle PS, NPS Loadings}
      For Alt_Loop := PointSource to NonPointSource do
         Begin
           Percent_Part.Alt_Loadings[Alt_Loop] := TLoadings.Load(IsTemp, St,ReadVersionNum);
           LoadCollectionitems(IsTemp, St,Percent_Part.Alt_Loadings[Alt_Loop],False,ReadVersionNum);
           Percent_Refr.Alt_Loadings[Alt_Loop] := TLoadings.Load(IsTemp, St,ReadVersionNum);
           LoadCollectionitems(IsTemp, St,Percent_Refr.Alt_Loadings[Alt_Loop],False,ReadVersionNum);
           For ToxLoop := FirstToxTyp to LastToxTyp do
             Begin
               ToxLoad[ToxLoop].Alt_Loadings[Alt_Loop] := TLoadings.Load(IsTemp, St,ReadVersionNum);
               LoadCollectionitems(IsTemp, St,ToxLoad[ToxLoop].Alt_Loadings[Alt_Loop],False,ReadVersionNum);
             End;
         End;
    End;

  If ReadVersionNum >= 2.999 then Inherited Load(IsTemp, St,ReadVersionNum); {TRemineralize}

End;

Procedure TCo2Obj.Store(IsTemp: Boolean; Var st: Tstream);
Begin
  St.Write(ImportCO2Equil,Sizeof(ImportCO2Equil));
  Co2Equil.Store(IsTemp, St);
  StoreCollectionitems(IsTemp, St,Co2Equil);
  inherited;
End;

Procedure TCo2Obj.WriteText;
Begin
  If ImportCo2Equil  then
     Begin
       Write(LF,'-- Using time-series CO2 Equilibria -- ');
       WriteTextCollection(LF,Co2Equil);
       Writeln(LF);
     End;
  inherited
End;

Constructor TCo2Obj.Init(Ns : StateVariables; SVT: T_SVType; aName : ShortString; P : TStates;
                       IC : double; IsTempl: Boolean);
Begin
  ImportCO2Equil := False;
  Co2Equil  := TLoadings.Init(2,10);
  inherited;
End;


Destructor TCo2Obj.Destroy;
Begin
  Co2Equil.Destroy;
End;

Constructor TCo2Obj.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Begin
  If ReadVersionNum < 3.765
    then
      Begin
        ImportCO2Equil := False;
        Co2Equil  := TLoadings.Init(2,10);
      End
    else
      Begin
        St.Read(ImportCO2Equil,Sizeof(ImportCO2Equil));
        Co2Equil:=nil;
        Co2Equil:=TLoadings.Load(IsTemp, St,ReadVersionNum);
        LoadCollectionitems(IsTemp, St,Co2Equil,False,ReadVersionNum);
      End;

  inherited;
End;


Procedure TO2Obj.Store(IsTemp: Boolean; Var st: Tstream);
Begin
  St.Write(Threshhold,Sizeof(Threshhold));
  St.Write(CalcDuration,Sizeof(CalcDuration));
  St.Write(NoLoadOrWash,Sizeof(NoLoadOrWash));
  inherited;
End;

Procedure TO2Obj.WriteText;
Begin
  If NoLoadOrWash then Write(LF,'-- OXYGEN INFLOW LOADS AND WASHOUT TURNED OFF --');
  inherited
End;

Constructor TO2Obj.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Begin
  If ReadVersionNum < 3.155
    then
      Begin
        CalcDuration := False;
        Threshhold := 3.0;
      End
    else
      Begin
        St.Read(Threshhold,Sizeof(Threshhold));
        St.Read(CalcDuration,Sizeof(CalcDuration));
      End;

  NoLoadOrWash := False;
  If ReadVersionNum > 3.175 then St.Read(NoLoadOrWash,Sizeof(NoLoadOrWash));
  inherited;
End;



Procedure TPlantToxRecord.Store(IsTemp: Boolean; var st: TStream);
Begin
  St.Write(Plant_name,Sizeof(Plant_name));
  St.Write(EC50_photo,Sizeof(EC50_photo));
  St.Write(EC50_exp_time,Sizeof(EC50_exp_time));
  St.Write(EC50_dislodge,Sizeof(EC50_dislodge));
  St.Write(EC50_comment,Sizeof(EC50_comment));
  St.Write(K2,Sizeof(K2));

  St.Write(K1,Sizeof(K1));
  St.Write(Entered_BCF,Sizeof(Entered_BCF));

  St.Write(Bio_rate_const,Sizeof(Bio_rate_const));
  St.Write(LC50,Sizeof(LC50));
  St.Write(LC50_exp_time,Sizeof(LC50_exp_time));
  St.Write(LC50_comment,Sizeof(LC50_comment));
  St.Write(Lipid_frac,Sizeof(Lipid_frac));
End;

Procedure TPlantToxRecord.WriteText;
Begin
   Writeln(LF,' + + + + + + + + + + + + + + ');
   Writeln(LF,'Plant_name: '+Plant_name);
   Writeln(LF,'EC50_photo: '+FloatToStrF(EC50_photo,ffgeneral,5,5));
   Writeln(LF,'EC50_exp_time: '+FloatToStrF(EC50_exp_time,ffgeneral,5,5));
   Writeln(LF,'EC50_dislodge: '+FloatToStrF(EC50_dislodge,ffgeneral,5,5));
   Writeln(LF,'EC50_comment: '+EC50_comment);
   Writeln(LF,'K2: '+FloatToStrF(K2,ffgeneral,5,5));
   Writeln(LF,'K1: '+FloatToStrF(K1,ffgeneral,5,5));
   Writeln(LF,'Entered_BCF: '+FloatToStrF(Entered_BCF,ffgeneral,5,5));
   Writeln(LF,'Bio_rate_const: '+FloatToStrF(Bio_rate_const,ffgeneral,5,5));
   Writeln(LF,'LC50: '+FloatToStrF(LC50,ffgeneral,5,5));
   Writeln(LF,'LC50_exp_time: '+FloatToStrF(LC50_exp_time,ffgeneral,5,5));
   Writeln(LF,'LC50_comment: '+LC50_comment);
   Writeln(LF,'Lipid_frac: '+FloatToStrF(Lipid_frac,ffgeneral,5,5));
End;


Constructor TPlantToxRecord.Load(IsTemp: Boolean; Var st: Tstream;ReadVersionNum: Double);
Begin
  St.Read(Plant_name,Sizeof(Plant_name));
  St.Read(EC50_photo,Sizeof(EC50_photo));
  St.Read(EC50_exp_time,Sizeof(EC50_exp_time));
  St.Read(EC50_dislodge,Sizeof(EC50_dislodge)) ;
  If ReadVersionNum > 3.605
    then St.Read(EC50_comment,Sizeof(EC50_comment))
    else St.Read(EC50_comment,Sizeof(RefString));
  St.Read(K2,Sizeof(K2));
  If ReadVersionNum>2.545 then
    Begin
      St.Read(K1,Sizeof(K1));
      St.Read(Entered_BCF,Sizeof(Entered_BCF));
    End;
  St.Read(Bio_rate_const,Sizeof(Bio_rate_const));
  St.Read(LC50,Sizeof(LC50));
  St.Read(LC50_exp_time,Sizeof(LC50_exp_time));
  If ReadVersionNum > 3.605
    then St.Read(LC50_comment,Sizeof(LC50_comment))
    else St.Read(LC50_comment,Sizeof(RefString));
  If ReadVersionNum>1.855 then St.Read(Lipid_frac,Sizeof(Lipid_frac))
                          else Lipid_Frac := 0.2;
End;


Procedure TAnimalToxRecord.Store(IsTemp: Boolean; var st: TStream);

Begin
   St.Write(Animal_name,Sizeof(Animal_name));
   St.Write(LC50,Sizeof(LC50));
   St.Write(LC50_exp_time,Sizeof(LC50_exp_time));
   St.Write(LC50_comment,Sizeof(LC50_comment));
   St.Write(Entered_K2,Sizeof(Entered_K2));

   St.Write(Entered_K1,Sizeof(Entered_K1));
   St.Write(Entered_BCF,Sizeof(Entered_BCF));

   St.Write(Bio_rate_const,Sizeof(Bio_rate_const));
   St.Write(EC50_growth,Sizeof(EC50_growth));
   St.Write(Growth_exp_time,Sizeof(Growth_exp_time));
   St.Write(EC50_repro,Sizeof(EC50_repro));
   St.Write(Repro_exp_time,Sizeof(Repro_exp_time));
   St.Write(EC50_comment,Sizeof(EC50_comment));
   St.Write(Mean_wet_wt,Sizeof(Mean_wet_wt));
   St.Write(Lipid_frac,Sizeof(Lipid_frac));
   St.Write(Drift_Thresh,Sizeof(Drift_Thresh));  //   (2/10/2009)
   St.Write(Drift_Comment,Sizeof(Drift_Comment));
End;

Procedure TAnimalToxRecord.WriteText;
Begin
   Writeln(LF,' + + + + + + + + + + + + + + ');
   Writeln(LF,'Animal_name: '+Animal_name);
   Writeln(LF,'LC50: '+FloatToStrF(LC50,ffgeneral,5,5));
   Writeln(LF,'LC50_exp_time: '+FloatToStrF(LC50_exp_time,ffgeneral,5,5));
   Writeln(LF,'LC50_comment: '+LC50_comment);
   Writeln(LF,'Entered_K2: '+FloatToStrF(Entered_K2,ffgeneral,5,5));
   Writeln(LF,'Entered_K1: '+FloatToStrF(Entered_K1,ffgeneral,5,5));
   Writeln(LF,'Entered_BCF: '+FloatToStrF(Entered_BCF,ffgeneral,5,5));
   Writeln(LF,'Bio_rate_const: '+FloatToStrF(Bio_rate_const,ffgeneral,5,5));
   Writeln(LF,'EC50_growth: '+FloatToStrF(EC50_growth,ffgeneral,5,5));
   Writeln(LF,'Growth_exp_time: '+FloatToStrF(Growth_exp_time,ffgeneral,5,5));
   Writeln(LF,'EC50_repro: '+FloatToStrF(EC50_repro,ffgeneral,5,5));
   Writeln(LF,'Repro_exp_time: '+FloatToStrF(Repro_exp_time,ffgeneral,5,5));
   Writeln(LF,'EC50_comment: '+EC50_comment);
   Writeln(LF,'Mean_wet_wt: '+FloatToStrF(Mean_wet_wt,ffgeneral,5,5));
   Writeln(LF,'Lipid_frac: '+FloatToStrF(Lipid_frac,ffgeneral,5,5));
   Writeln(LF,'Drift_Thresh: '+FloatToStrF(Drift_Thresh,ffgeneral,5,5));
   Writeln(LF,'Drift_Comment: '+Drift_Comment);
End;

Constructor TAnimalToxRecord.Load(IsTemp: Boolean; Var st: Tstream;ReadVersionNum: Double);
Begin
   St.Read(Animal_name,Sizeof(Animal_name));
   St.Read(LC50,Sizeof(LC50));
   St.Read(LC50_exp_time,Sizeof(LC50_exp_time));
   If ReadVersionNum > 3.605
     then St.Read(LC50_comment,Sizeof(LC50_comment))
     else st.Read(LC50_comment,Sizeof(RefString));
   St.Read(Entered_K2,Sizeof(Entered_K2));
   If ReadVersionNum>2.545 then
     Begin
       St.Read(Entered_K1,Sizeof(Entered_K1));
       St.Read(Entered_BCF,Sizeof(Entered_BCF));
     End;
   St.Read(Bio_rate_const,Sizeof(Bio_rate_const));
   St.Read(EC50_growth,Sizeof(EC50_growth));
   St.Read(Growth_exp_time,Sizeof(Growth_exp_time));
   St.Read(EC50_repro,Sizeof(EC50_repro));
   St.Read(Repro_exp_time,Sizeof(Repro_exp_time));
   If ReadVersionNum > 3.605
     then St.Read(EC50_comment,Sizeof(EC50_comment))
     else St.Read(EC50_comment,Sizeof(RefString));
   St.Read(Mean_wet_wt,Sizeof(Mean_wet_wt));
   St.Read(Lipid_frac,Sizeof(Lipid_frac));
   If ReadVersionNum>1.725 then
     Begin
       If ReadVersionNum > 3.605
         then St.Read(Drift_Thresh,Sizeof(Drift_Thresh))
         else St.Read(Drift_Thresh,Sizeof(RefString));

       If ReadVersionNum > 3.605
         then St.Read(Drift_Comment,Sizeof(Drift_Comment))
         else St.Read(Drift_Comment,Sizeof(RefString));
     End
   else
     If (Animal_Name = 'Chironomid') or
        (Animal_Name = 'Stonefly') or
        (Animal_Name = 'Ostracod') or
        (Animal_Name = 'Amphipod') or
        (Animal_Name = 'Isopod') or
        (Animal_Name = 'Corbicula') or
        (Animal_Name = 'Mayfly') or
        (Animal_Name = 'Other') then
       Begin
         Drift_Thresh:=EC50_Growth / 20;
         Drift_Comment := '5% of EC50Growth.';
       End
     else
       Begin
         Drift_Thresh  :=0;
         Drift_Comment := 'N.A. not zoobenthos';
       End;

End;



