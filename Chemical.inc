//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Constructor TChemical.Init;
Var BTLoop: BioTransType;
    NewBTR: TBioTransObject;
begin
  Fillchar(ChemRec,Sizeof(ChemRec),'0');
  Anim_Tox  := TCollection.Init(20,10);
  Plant_Tox := TCollection.Init(20,10);
  HenryPa   :=0;
  Kow       :=0;
  Tox_Air   :=0;

  BioTrans   := TCollection.Init(20,10);
  For BTLoop := BTAerobicMicrobial to BTFish do
    Begin
      NewBTR := TBioTransObject.Init(BTLoop,NullStateVar);
      BioTrans.Insert(NewBTR);
    End;
end;

Destructor TChemical.Destroy;
begin
  If Anim_Tox  <> nil then Anim_Tox.Destroy;
  If Plant_Tox <> nil then Plant_Tox.Destroy;
  If BioTrans  <> nil then BioTrans.Destroy;
end;

Procedure TChemical.ChangeData;   { Add parameter for chemical record later}
begin
  with ChemRec do
    begin
      KOW := POWER(10.0, LogKow);
      HenryPa := Henry * 1.01325e5; {atm cu m/mol  -> Pa cu m/mol}
    end;
end;


Procedure  TChemical.Store(IsTemp: Boolean; Var st: TStream);
Begin
     st.write(ChemRec,Sizeof(ChemRec));
     st.write(Kow,Sizeof(Kow));
     st.write(HenryPA,Sizeof(HenryPA));
     st.write(Tox_Air,Sizeof(Tox_Air));
     Anim_Tox.Store(IsTemp,St);
     StoreCollectionitems(IsTemp,st,Anim_Tox);
     Plant_Tox.Store(IsTemp,St);
     StoreCollectionitems(IsTemp,st,Plant_Tox);
     BioTrans.Store(IsTemp,ST);
     StoreCollectionitems(IsTemp,st,BioTrans);
     st.write(Anim_Method,Sizeof(Anim_Method));
     st.write(Plant_Method,Sizeof(Plant_Method));
End;


Procedure  TChemical.WriteText;
  Procedure WriteMeth(n:string; m:UptakeCalcMethodType);
  Begin
    Case m of
     Default_Meth: Writeln(LF,n+': '+'Default Uptake Method');
     CalcBCF: Writeln(LF,n+': '+'Enter K1 & K2, Calc BCF');
     CalcK1: Writeln(LF,n+': '+'Enter BCF & K2, Calc K1');
     CalcK2: Writeln(LF,n+': '+'Enter BCF & K1, Calc K2');
    End; {Case}
  End;

Begin
     Writeln(LF,'-----------------------------------');
     ChemRec_To_Text(LF,ChemRec);
     Writeln(LF,('Kow: '+FloattoStrF(Kow,ffGeneral,5,5)));
     Writeln(LF,('HenryPA: '+FloattoStrF(HenryPA,ffGeneral,5,5)));
     Writeln(LF,('Tox_Air: '+FloattoStrF(Tox_Air,ffGeneral,5,5)));
     Writeln(LF,'-----------------------------------');
     Writeln(LF,'TOXICITY DATA');
     WriteTextCollection(LF,Anim_Tox);
     WriteTextCollection(LF,Plant_Tox);
     Writeln(LF,'-----------------------------------');
     BioTrans.WriteText(LF);
     WriteMeth('Anim_Method: ',Anim_Method);
     WriteMeth('Plant_Method: ',Plant_Method);
End;


Constructor  TChemical.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Var OCR: OldChemicalRecord;
Begin
   If ReadVersionNum > 3.605
      then St.Read(ChemRec,Sizeof(ChemRec))
      else Begin {OCR}
             If ReadVersionNum < 2.999
               then TranslateChemRec(St, ReadVersionNum, OCR)
               else St.Read(OCR,Sizeof(OCR)); {current version}
             TranslateChemRec2(OCR,ChemRec);
           End;

   If ReadVersionNum < 3.625 then
    with ChemRec do
     Begin
       CalcKOMRefrDOM       := True;
       KOMRefrDOM           := 0;
       XKOMRefrDOM          := '';
     End;

   If ReadversionNum < 3.765 then
    with ChemRec do
     Begin
       K1Detritus           := 1.39;
       XK1Detritus          := 'default';
     End;

  st.Read(Kow,Sizeof(Kow));
  st.Read(HenryPA,Sizeof(HenryPA));
  st.Read(Tox_Air,Sizeof(Tox_Air));

  Anim_Tox:=TCollection.Load(IsTemp,St,ReadVersionNum);
  LoadCollectionitems(IsTemp,st,Anim_Tox,False,ReadVersionNum);
  Plant_Tox:=TCollection.Load(IsTemp,St,ReadVersionNum);
  LoadCollectionitems(IsTemp,st,Plant_Tox,False,ReadVersionNum);

  BioTrans:=TCollection.Load(IsTemp,St,ReadVersionNum);
  LoadCollectionitems(IsTemp,st,BioTrans,False,ReadVersionNum);

     If ReadVersionNum > 2.545
       then
         Begin
           st.Read(Anim_Method,Sizeof(Anim_Method));
           st.Read(Plant_Method,Sizeof(Plant_Method));
         End
       else
         Begin
           Anim_Method := Default_Meth;
           Plant_Method := Default_Meth;
         End;

End;

{-------------------------------------------------------------------}

Function TChemical.WEffTox(nondissoc: double): Double;
     Var LogKow: Double;
     {This Code is mirrored in CHEMTOX.PAS for K2 Estimation.  Changes made here should be made there.}
     Begin
       LogKow:=ChemRec.LogKow;
       If LogKow< 1.5 then
          WEffTox:= 0.1
       else If (LogKow >= 1.5) and (LogKow < 3.0) then
          WEffTox:= 0.1 + (Nondissoc) * (0.3 * LogKOW - 0.45)
       else If (LogKow >= 3.0) and (LogKow <= 6.0) then
          WEffTox:= 0.1 + (Nondissoc) * 0.45
       else If (LogKow > 6.0)  and (LogKow < 8.0) then
          WEffTox:= 0.1 + (Nondissoc) * (0.45 - 0.23 * (LogKOW - 6.0))
       else {LogKOW >= 8.0}
          WEffTox:= 0.1;
     End;

{-------------------------------------------------------------------}


Function TChemical.DBase_To_AnimToxColl (DbDir,DbName: ShortString):Boolean;
Var loop, Recnum : Integer;
    NewATR       : TAnimalToxRecord;
    Table1       : TTable;

Begin
   DBase_To_AnimToxColl:=True;
   Table1 := TTable.Create(nil);

   Try
      With Table1 do begin
       Active:=False;
       DatabaseName:=DBDir;
       TableName:=DbName;
       Active:=True;
      end;

   With Table1 do
     begin
       If Anim_Tox<>nil then Anim_Tox.Destroy;
       Anim_Tox:=TCollection.Init(20,10);
       First;
       RecNum:=RecordCount;
       For loop:=1 to RecNum do
          begin
            NewATR := TAnimalToxRecord.Create;
            NewATR.Animal_name    := Fields[0].AsString;
            NewATR.LC50           := Fields[1].AsFloat;
            NewATR.LC50_exp_time  := Fields[2].AsFloat;
            NewATR.LC50_comment   := Fields[3].AsString;
            NewATR.Entered_K2     := Fields[4].AsFloat;
            NewATR.Entered_K1     := Fields[5].AsFloat;
            NewATR.Entered_BCF    := Fields[6].AsFloat;
            NewATR.Bio_rate_const := Fields[7].AsFloat;
            NewATR.EC50_growth    := Fields[8].AsFloat;
            NewATR.Growth_exp_time:= Fields[9].AsFloat;
            NewATR.EC50_repro     := Fields[10].AsFloat;
            NewATR.Repro_exp_time := Fields[11].AsFloat;
            NewATR.EC50_comment   := Fields[12].AsString;
            NewATR.MEan_wet_wt    := Fields[13].AsFloat;
            NewATR.Lipid_frac     := Fields[14].AsFloat;
            NewATR.Drift_Thresh   := Fields[15].AsFloat;
            NewATR.Drift_Comment  := Fields[16].AsString; 
            Anim_Tox.Insert(NewATR);
            Next;
          end; {for do}

        Active:=False;
     end; {with}

   Except

   DBase_To_AnimToxColl:=False;
   Table1.Active:=False;

   End; {Try Except}

   Table1.Free;

END;  {DBase_To_AnimToxColl}

{-----------------------------------------------------------------}

Function TChemical.AnimToxColl_To_Dbase (DbDir,DbName: ShortString):Boolean;
Var loop, Recnum : Integer;
    CurrentATR   : TAnimalToxRecord;
    Table1       : TTable;
Begin

   AnimToxColl_To_DBase := True;
   Table1 := TTable.Create(nil);

   Try
      With Table1 do begin
       Active:=False;
       DatabaseName:=DBDir;
       TableName:=DbName;
       EmptyTable;
       Active:=True;
      end;

   With Table1 do
     begin
       RecNum:=Anim_Tox.Count-1;
       If RecNum>=0 then
         For loop:=0 to RecNum do
          begin
            CurrentATR := Anim_Tox.At(loop);
            If CurrentATR.Animal_Name <> '' then
              Begin
                Append;
                Fields[0].AsString  := CurrentATR.Animal_name;
                Fields[1].AsFloat   := CurrentATR.LC50;
                Fields[2].AsFloat   := CurrentATR.LC50_exp_time;
                Fields[3].AsString  := CurrentATR.LC50_comment;
                Fields[4].AsFloat   := CurrentATR.Entered_K2;
                Fields[5].AsFloat   := CurrentATR.Entered_K1;
                Fields[6].AsFloat   := CurrentATR.Entered_BCF;
                Fields[7].AsFloat   := CurrentATR.Bio_rate_const;
                Fields[8].AsFloat   := CurrentATR.EC50_growth;
                Fields[9].AsFloat   := CurrentATR.Growth_exp_time;
                Fields[10].AsFloat  := CurrentATR.EC50_repro;
                Fields[11].AsFloat  := CurrentATR.Repro_exp_time;
                Fields[12].AsString := CurrentATR.EC50_comment;
                Fields[13].AsFloat  := CurrentATR.Mean_wet_wt;
                Fields[14].AsFloat  := CurrentATR.Lipid_frac;
                Fields[15].AsFloat  := CurrentATR.Drift_Thresh;
                Fields[16].AsString := CurrentATR.Drift_Comment;
                Post;
              End;
          end; {for do}

        Active:=False;
     end; {with}

   Except

   AnimToxColl_To_Dbase:=False;
   Table1.Active:=False;

   End; {Try Except}
   Table1.Free;
END;     {AnimToxColl_To_Dbase}

{-----------------------------------------------------------------}

Function TChemical.DBase_To_PlantToxColl(DbDir,DbName: ShortString ):Boolean;
Var loop, Recnum : Integer;
    NewPTR       : TPlantToxRecord;
    Table1       : TTable;
Begin
   DBase_To_PlantToxColl:=True;
  Table1 := TTable.Create(nil);

   Try
      With Table1 do begin
       Active:=False;
       DatabaseName:=DBDir;
       TableName:=DbName;
       Active:=True;
      end;

   With Table1 do
     begin
       If Plant_Tox<>nil then Plant_Tox.Destroy;
       Plant_Tox:=TCollection.Init(3,3);
       First;
       RecNum:=RecordCount;
       For loop:=1 to RecNum do
          begin
            NewPTR := TPlantToxRecord.Create;
            NewPTR.Plant_name     := Fields[0].AsString;
            NewPTR.EC50_photo     := Fields[1].AsFloat;
            NewPTR.EC50_exp_time  := Fields[2].AsFloat;
            NewPTR.EC50_dislodge  := Fields[3].AsFloat;
            NewPTR.EC50_comment   := Fields[4].AsString;
            NewPTR.K2             := Fields[5].AsFloat;
            NewPTR.K1             := Fields[6].AsFloat;
            NewPTR.Entered_BCF    := Fields[7].AsFloat;
            NewPTR.Bio_rate_const := Fields[8].AsFloat;
            NewPTR.LC50           := Fields[9].AsFloat;
            NewPTR.LC50_exp_time  := Fields[10].AsFloat;
            NewPTR.LC50_comment   := Fields[11].AsString;
            NewPTR.Lipid_Frac     := Fields[12].AsFloat;

            Plant_Tox.Insert(NewPTR);
            Next;
          end; {for do}
     end; {with}

   Except

   DBase_To_PlantToxColl:=False;
   Table1.Active:=False;

   End; {Try Except}

   Table1.Free;

END;  {DBase_To_AnimToxColl}

{-----------------------------------------------------------------}

Function TChemical.PlantToxColl_To_Dbase(DbDir,DbName: ShortString):Boolean;

Var loop, Recnum : Integer;
    CurrentPTR   : TPlantToxRecord;
    Table1       : TTable;

Begin
  Table1 := TTable.Create(nil);
  PlantToxColl_To_Dbase:=True;
   Try
      With Table1 do begin
       Active:=False;
       DatabaseName:=DBDir;
       TableName:=DbName;
       EmptyTable;
       Active:=True;
      end;

   With Table1 do
     begin
       RecNum:=Plant_Tox.Count-1;
       If RecNum>=0 then
         For loop:=0 to RecNum do
          begin
            CurrentPTR := Plant_Tox.At(loop);
            If CurrentPtr.Plant_Name <> '' then
              Begin
                Append;
                Fields[0].AsString := CurrentPtr.Plant_name;
                Fields[1].AsFloat  := CurrentPtr.EC50_photo;
                Fields[2].AsFloat  := CurrentPtr.EC50_exp_time;
                Fields[3].AsFloat  := CurrentPtr.EC50_dislodge;
                Fields[4].AsString := CurrentPtr.EC50_comment;
                Fields[5].AsFloat  := CurrentPtr.K2;
                Fields[6].AsFloat  := CurrentPtr.K1;
                Fields[7].AsFloat  := CurrentPtr.Entered_BCF;
                Fields[8].AsFloat  := CurrentPtr.Bio_rate_const;
                Fields[9].AsFloat  := CurrentPtr.LC50;
                Fields[10].AsFloat  := CurrentPtr.LC50_exp_time;
                Fields[11].AsString := CurrentPtr.LC50_comment;
                Fields[12].AsFloat  := CurrentPTR.Lipid_Frac;
                Post;
              End;
          end; {for do}
     end; {with}

   Except

   PlantToxColl_To_Dbase:=False;
   Table1.Active:=False;

   End; {Try Except}
  Table1.Free;
END;     {PlantToxColl_To_Dbase}

{-----------------------------------------------------------------}

Function TChemical.Get_BioTrans_Record(BT: BioTransType; US: AllVariables):TBioTransObject;
Var i: Integer;
    BioRec: TBioTransObject;
Begin
  Get_BioTrans_Record := nil;
  For i:=0 to BioTrans.Count-1 do
    Begin
      BioRec:= BioTrans.At(i);
      If (BioRec.BTType= BT) and (BioRec.UserSpec= US) then
         Begin
           Get_BioTrans_Record := BioRec;
           Break;
         End;
    End;

End;

{-----------------------------------------------------------------}

Constructor TBioTransObject.Init(BT: BioTransType; US: AllVariables);
Var ToxLoop: T_SVType;
Begin
  BTType   := BT;
  UserSpec := US;
  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
    Percent[ToxLoop] := 0;
End;

Procedure TBioTransObject.Store(IsTemp: Boolean;Var st: TStream);
Begin
  st.Write(BTType, Sizeof(BTTYpe));
  st.Write(UserSpec, Sizeof(UserSpec));
  St.Write(Percent, Sizeof(Percent));
End;

Procedure TBioTransObject.WriteText;
Var ToxLoop: T_SVType;
Begin
  Case BtType of
    BTAerobicMicrobial: Writeln(LF,'BTAerobicMicrobial');
    BTAnaerobicMicrobial: Writeln(LF,'BTAnaerobicMicrobial');
    BTAlgae: Writeln(LF,'BTAlgae');
    BTBenthInsect: Writeln(LF,'BTBenthInsect');
    BTOtherInvert: Writeln(LF,'BTOtherInvert');
    BTFish: Writeln(LF,'BTFish');
    BTUserSpecified: Writeln(LF,'BTUserSpecified');
   End; {case}

  If BtType=BTUserSpecified then Writeln(LF,'Relevant to '+StateText(UserSpec,StV,WaterCol));
  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
    Write(LF,'T'+IntToStr(Ord(ToxLoop)-1)+':'+FloatToStrF(Percent[ToxLoop],FFGeneral,5,5)+';');
  Writeln(LF);  
End;

Constructor TBioTransObject.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Begin
  st.Read(BTType, Sizeof(BTTYpe));
  st.Read(UserSpec, Sizeof(UserSpec));
  If (ReadVersionNum<3.399)
      then UserSpec := Updatenstate(UserSpec,ReadversionNum);

  St.Read(Percent, Sizeof(Percent));
End;

