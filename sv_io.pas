//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
unit SV_IO;

{ PRIMARY INTERFACE BETWEEN DATABASES AND STATE VARIABLES:

Comments:  1. Don't change order of elements within
              DBase Files... Correct Loading depends on the order.
           2. Working with Dbase Files requires the name *.DB,
              so some file-name manipulation is required...
           3. These functions return false if the transfer is not
              successful, but do not raise an error unless a file transfer
              error occurs, or the appropriate entry is not found.  JonC }

{ NOTE:  THE PROCESS TO CHANGE DATABASES / DATA ASSOCIATED WITH
         STATE VARIABLES REQUIRES 8 STEPS:

o     1. make a note of the size of the record data structure in GLOBAL.PAS
o     2. changing the record data structure in GLOBAL.PAS
o     3. altering the databases accordingly (Database AND Program directory)
o     4. changing the sv_io interface between database and data structure _ TEXT OUTPUT (9)
o     5. updating the store/load procedures for new studies, may require
         new version num in global or update of all relevant studies.
o     6. creating the portion of the entry screen with the correct units, tab order,
         and entry boxes, setting DATAFIELD within DBEDIT components
o     7. getting the appropriate default values for the databases
o     8. modifying process code to use the new data, testing
o     9. modifying text output
o     10. Add to uncertainty, sensitivity parameters (DISTRIBS.PAS)
x     11. Tech. Doc. modifications  (Add Process Eqns to Tech doc or placeholder
           Add parameters to Appendix B in Tech Doc or placeholder }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,  DBTables, DB, Global, TCollect;

type
  EAquatoxError=Exception;

{ ***** Interaction of Records and Databases ***** }
Function DBase_To_ChemRecord  (DbDir,DbName,DbEntry: ShortString; Num: Integer; Var CR: Chemicalrecord):Boolean;
Function ChemRecord_To_Dbase  (DbDir,DbName,DbEntry: ShortString; CR: Chemicalrecord):Boolean;
Procedure ChemRec_To_Text     (Var LF: TextFile; CR: Chemicalrecord);

Function DBase_To_AnimalRecord(DbDir,DbName,DbEntry: ShortString; Num: Integer; Var AR: ZooRecord):Boolean;
Function AnimalRecord_To_Dbase(DbDir,DbName,DbEntry: ShortString; AR: ZooRecord; Prompt:Boolean):Boolean;
Procedure AnimRec_To_Text     (Var LF: TextFile; AR:ZooRecord);

Function DBase_To_SiteRecord  (DbDir,DbName,DbEntry: ShortString; Var SR: SiteRecord):Boolean;
Function SiteRecord_To_Dbase  (DbDir,DbName,DbEntry: ShortString; SR: SiteRecord):Boolean;
Procedure SiteRec_To_Text     (Var LF: TextFile; SR: SiteRecord);

Function DBase_To_ReminRecord (DbDir,DbName,DbEntry: ShortString; Var RR: ReminRecord):Boolean;
Function ReminRecord_To_Dbase (DbDir,DbName,DbEntry: ShortString; RR: ReminRecord):Boolean;
Procedure ReminRec_To_Text    (Var LF: TextFile; RR: ReminRecord);

Function DBase_To_PlantRecord (DbDir,DbName,DbEntry: ShortString; Num: Integer; Var PR: PlantRecord):Boolean;
Function PlantRecord_To_Dbase (DbDir,DbName,DbEntry: ShortString; PR: PlantRecord):Boolean;
Procedure PlantRec_To_Text    (Var LF: TextFile; PR: PlantRecord);

Function AnimalRecord_To_2_2_Dbase(DbDir,DbName,DbEntry: ShortString; AR: ZooRecord):Boolean;
Function PlantRecord_To_2_2_Dbase (DbDir,DbName,DbEntry: ShortString; PR: PlantRecord):Boolean;

Function AQTRenameFile(Dir,Name1,Name2: String): Boolean;
implementation

Var Table1: TTable;

Function AQTRenameFile(Dir,Name1,Name2: String):Boolean;
{Rename a file in Dir from Name1 to Name2 }
Var F: File;

Begin
   Try
     CleanDashes(Name1);
     CleanDashes(Name2);

     AssignFile(f,Dir+'\'+Name1);
     Rename(f,Dir+'\'+Name2);
     AQTRenameFile:=True;
   Except
     Raise EAquatoxError.Create('File Rename Error');
     AQTRenameFile:=False;
   End;
End;

Function GetEntryByNum(DbDir,DbName: ShortString; Num: Integer):Boolean;
Var  CorrectDbName:ShortString;
     ChangeName:Boolean;
     i: Integer;

Begin
   GetEntryByNum:=True;
   Try
   With Table1 do begin
      Active:=False;
      DatabaseName:=DBDir;

      {Deal with this name changing pain in the neck}
      CorrectDbName:=AbbrString(DbName,'.')+'.DB';
      ChangeName:= Not (Lowercase(CorrectDbName)=Lowercase(DbName));
      If ChangeName then GetEntryByNum:=AQTRenameFile(DBDir,DbName,CorrectDbName);

      {Find the Appropriate Entry}
      Tablename:=CorrectDbName;
      Active:=True;

      Table1.First;
      For i := 2 to Num do
        Table1.Next;

   End; {With}
   Except
     GetEntryByNum:=False;
   End; {Try Except}
End;


Function GetEntry(DbDir,DbName,DbEntry: ShortString; AddIt, Prompt: Boolean):Boolean;
{Ready the database file for reading or writing by changing the
 name if required, and Finding the right Entry}

Var
CorrectDbName:ShortString;
ChangeName:Boolean;

Begin
   GetEntry:=True;
   Try
   With Table1 do begin
      Active:=False;
      DatabaseName:=DBDir;

      {Deal with this name changing pain in the neck}
      CorrectDbName:=AbbrString(DbName,'.')+'.DB';
      ChangeName:= Not (Lowercase(CorrectDbName)=Lowercase(DbName));
      If ChangeName then GetEntry:=AQTRenameFile(DBDir,DbName,CorrectDbName);

      {Find the Appropriate Entry}
      Tablename:=CorrectDbName;
      Active:=True;
      SetKey;
      Fields[0].AsString:=DbEntry;

      {Raise Error if Entry is not Found}
      If Not Gotokey then
         Begin
           If AddIt
             then
               with Table1 do
                 Begin
                   Insert;
                   Fields[0].AsString := DBEntry;
                   Post;
                 End
             else
               begin  MessageDlg('DBase Error, ['+Dbdir+'\'+DbName+':'+DbEntry+'] not found.',mterror,[mbOK],0);
                                  Active:=False; AQTRenameFile(DBDir,AbbrString(DbName,'.')+'.DB',DbName);
                                  GetEntry:=False;
               end;
         End
        Else If Prompt
          then If MessageDlg('The entry "'+Fields[0].AsString+'" already exists in that Database.  Overwrite?',MtConfirmation,[mbYes,mbNo],0) = mrno
           then Result := False;
   End; {With}
   Except
   GetEntry:=False;
   End; {Try Except}
End;

Procedure ResetFile(DbDir,DbName: ShortString);
{Reset the Dbase File to its original state after working with it}
Var
CorrectDbName:ShortString;
ChangeName:Boolean;

Begin
      Table1.Active:=False;

      {Deal with this name changing pain in the neck}
      CorrectDbName:=AbbrString(DbName,'.')+'.DB';
      ChangeName:= Not (lowercase(CorrectDbName)=lowercase(DbName));
      If ChangeName then AQTRenameFile(DBDir,CorrectDbName,DBName);
End;

{*************************************************
****** Interaction of Records and Databases ******
**************************************************}

Function DBase_To_ChemRecord(DbDir,DbName,DbEntry: ShortString; Num: Integer; Var CR: Chemicalrecord):Boolean;
Begin
   Try
   Table1 := TTable.Create(nil);

   If DBEntry = ''
      then DBase_To_ChemRecord:=GetEntryByNum(DbDir,DbName,Num)
      else DBase_To_ChemRecord:=GetEntry(DbDir,DbName,DbEntry,False,False);

   With Table1 do begin
   With Cr do begin
      ChemName             := Fieldbyname('ChemName').AsString;
      MolWt                := Fields[1].asfloat;
      Solubility           := Fields[2].asfloat;
      XSolubility          := Fields[3].asstring;
      Henry                := Fields[4].asfloat;
      XHenry               := Fields[5].asstring;
      Xpka                 := Fields[6].AsString;
      pka                  := Fields[7].asfloat;
      CASRegNo             := Fields[8].AsString;
      VPress               := Fields[9].asfloat;
      XVPress              := Fields[10].asstring;
      LogKow               := Fields[11].asfloat;
      XLogKow              := Fields[12].asstring;
      En                   := Fields[13].asfloat;
      XEn                  := Fields[14].asstring;
      KMDegrAnaerobic      := Fields[15].asfloat;
      XKMDegrAnaerobic     := Fields[16].asstring;
      KMDegrdn             := Fields[17].asfloat;
      XKMDegrdn            := Fields[18].asstring;
      KUnCat               := Fields[19].asfloat;
      XKUncat              := Fields[20].asstring;
      KAcid                := Fields[21].asfloat;
      XKAcid               := Fields[22].asstring;
      KBase                := Fields[23].asfloat;
      XKBase               := Fields[24].asstring;
      PhotoLysisRate       := Fields[25].asfloat;
      XPhotoLysisRate      := Fields[26].asstring;
      OxRateConst          := Fields[27].asfloat;
      XOxRateConst         := Fields[28].asstring;

      KPSed            := Fields[29].asfloat;
      XKpSed           := Fields[30].asstring;
      Weibull_Shape    := Fields[31].asfloat;
      XWeibull_Shape   := Fields[32].asstring;
      ChemIsBase       := Fields[33].asBoolean;
      CalcKPSed        := Fields[34].AsBoolean;

      CohesivesK1          := Fields[35].asfloat;
      CohesivesK2          := Fields[36].asfloat;
      CohesivesKp          := Fields[37].asfloat;
      CohesivesRef         := Fields[38].asstring;
      NonCohK1             := Fields[39].asfloat;
      NonCohK2             := Fields[40].asfloat;
      NonCohKp             := Fields[41].asfloat;
      NonCohRef            := Fields[42].asstring;
      NonCoh2K1            := Fields[43].asfloat;
      NonCoh2K2            := Fields[44].asfloat;
      NonCoh2Kp            := Fields[45].asfloat;
      NonCoh2Ref           := Fields[46].asstring;

      IsPFA                := Fields[47].asBoolean;
      PFAType              := Fields[48].asString;
      PFAChainLength       := Fields[49].asFloat;
      XPFAChainLength      := Fields[50].asString;
      PFASedKom            := Fields[51].asFloat;
      XPFASedKom           := Fields[52].asString;
      PFAAlgBCF            := Fields[53].asFloat;
      XPFAAlgBCF           := Fields[54].asString;
      PFAMacroBCF          := Fields[55].asFloat;
      XPFAMacroBCF         := Fields[56].asString;

      WeibullSlopeFactor   := Fields[57].asFloat;
      XWeibullSlopeFactor  := Fields[58].asString;

      CalcKOMRefrDOM       := Fields[59].asBoolean;
      KOMRefrDOM           := Fields[60].asFloat;
      XKOMRefrDOM          := Fields[61].asString;

      K1Detritus           := Fields[62].asFloat;
      XK1Detritus          := Fields[63].asString;


   end; {with CR}
   end; {with SV_IO_Form.Table1}

   ResetFile(DbDir,DbName);
   Except

   DBase_To_ChemRecord:=False;
   If FileExists(DBDir+'\'+AbbrString(DbName,'.')+'.DB') then
      ResetFile(DbDir,DbName);
   End; {try Except}
   Table1.Free;   
End;    {DBase_To_ChemRecord}

{-----------------------------------------------------------------}

Function ChemRecord_To_Dbase(DbDir,DbName,DbEntry: ShortString; CR: Chemicalrecord):Boolean;
Begin
   Table1 := TTable.Create(nil);

   Try

      ChemRecord_To_Dbase:=GetEntry(DbDir,DbName,DbEntry,True,False);

  With Table1 do begin

      Edit;

  With Cr do begin
      Fieldbyname('ChemName').AsString:=ChemName;
      Fields[1].asfloat:=MolWt;
      Fields[2].asfloat:=Solubility;
      Fields[3].asstring:=XSolubility;
      Fields[4].asfloat:=Henry;
      Fields[5].asstring:=XHenry;
      Fields[6].AsString :=XPkA;
      Fields[7].asfloat:=pka;
      Fields[8].AsString:=CASRegNo;
      Fields[9].asfloat:=VPress;
      Fields[10].asstring:=XVPress;
      Fields[11].asfloat:=LogKow;
      Fields[12].asstring:=XLogKow;
      Fields[13].asfloat:=En;
      Fields[14].asstring:=XEn;
      Fields[15].asfloat:=KMDegrAnaerobic;
      Fields[16].asstring:=XKMDegrAnaerobic;
      Fields[17].asfloat:=KMDegrdn;
      Fields[18].asstring:=XKMDegrdn;
      Fields[19].asfloat:=KUnCat;
      Fields[20].asstring:=XKUncat;
      Fields[21].asfloat:=KAcid;
      Fields[22].asstring:=XKAcid;
      Fields[23].asfloat:=KBase;
      Fields[24].asstring:=XKBase;
      Fields[25].asfloat:=PhotoLysisRate;
      Fields[26].asstring:=XPhotoLysisRate;
      Fields[27].asfloat:=OxRateConst;
      Fields[28].asstring:=XOxRateConst;
      Fields[29].asfloat  :=KPSed;
      Fields[30].asstring :=XKpSed;
      Fields[31].asfloat  :=Weibull_Shape;
      Fields[32].asstring :=XWeibull_Shape;
      Fields[33].asBoolean:=ChemIsBase;
      Fields[34].AsBoolean:=CalcKPSed;

      Fields[35].asfloat:=CohesivesK1;         
      Fields[36].asfloat:=CohesivesK2;
      Fields[37].asfloat:=CohesivesKp;
      Fields[38].asstring:=CohesivesRef;
      Fields[39].asfloat:=NonCohK1;
      Fields[40].asfloat:=NonCohK2;
      Fields[41].asfloat:=NonCohKp;
      Fields[42].asstring:=NonCohRef;
      Fields[43].asfloat:=NonCoh2K1;
      Fields[44].asfloat:=NonCoh2K2;
      Fields[45].asfloat:=NonCoh2Kp;
      Fields[46].asstring:=NonCoh2Ref;

      Fields[47].asBoolean := IsPFA;
      Fields[48].asString  := PFAType;
      Fields[49].asFloat   := PFAChainLength;
      Fields[50].asString  := XPFAChainLength;
      Fields[51].asFloat   := PFASedKom;
      Fields[52].asString  := XPFASedKom;
      Fields[53].asFloat   := PFAAlgBCF;
      Fields[54].asString  := XPFAAlgBCF;
      Fields[55].asFloat   := PFAMacroBCF;
      Fields[56].asString  := XPFAMacroBCF;

      Fields[57].asFloat   := WeibullSlopeFactor;
      Fields[58].asString  := XWeibullSlopeFactor;

      Fields[59].asBoolean := CalcKOMRefrDOM;
      Fields[60].asFloat   := KOMRefrDOM;
      Fields[61].asString  := XKOMRefrDOM;

      Fields[62].asFloat   := K1Detritus;
      Fields[63].asString  := XK1Detritus;

   end; {with CR}
   Post;
   end; {with SV_IO_Form.Table1}

   ResetFile(DbDir,DbName);

   Except

   ChemRecord_To_Dbase:=False;
   If FileExists(DBDir+'\'+AbbrString(DbName,'.')+'.DB') then
      ResetFile(DbDir,DbName);

   End; {try Except}
   Table1.Free;
End;    {ChemRecord_To_Dbase}

{-----------------------------------------------------------------}

Procedure ChemRec_To_Text;
Begin
  With CR do
    Begin
     Writeln(LF,'ChemName: '+ChemName);
     Writeln(LF,'CASRegNo: '+CASRegNo);
     Writeln(LF,'MolWt: '+FloatToStrF(MolWt,ffgeneral,5,5));
     Writeln(LF,'Solubility: '+FloatToStrF(Solubility,ffgeneral,5,5)+' -- '+XSolubility);
     Writeln(LF,'Henry: '+FloatToStrF(Henry,ffgeneral,5,5)+' -- '+XHenry);
     Writeln(LF,'pka: '+FloatToStrF(pka,ffgeneral,5,5)+' -- '+Xpka);
     Writeln(LF,'VPress: '+FloatToStrF(VPress,ffgeneral,5,5)+' -- '+XVPress);
     Writeln(LF,'LogP: '+FloatToStrF(LogKow,ffgeneral,5,5)+' -- '+XLogKow);
     Writeln(LF,'En: '+FloatToStrF(En,ffgeneral,5,5)+' -- '+XEn);
     Writeln(LF,'KMDegrdn: '+FloatToStrF(KMDegrdn,ffgeneral,5,5)+' -- '+XKMDegrdn);
     Writeln(LF,'KMDegrAnaerobic: '+FloatToStrF(KMDegrAnaerobic,ffgeneral,5,5)+' -- '+XKMDegrAnaerobic);
     Writeln(LF,'KUnCat: '+FloatToStrF(KUnCat,ffgeneral,5,5)+' -- '+XKUnCat);
     Writeln(LF,'KAcid: '+FloatToStrF(KAcid,ffgeneral,5,5)+' -- '+XKAcid);
     Writeln(LF,'KBase: '+FloatToStrF(KBase,ffgeneral,5,5)+' -- '+XKBase);
     Writeln(LF,'PhotolysisRate: '+FloatToStrF(PhotolysisRate,ffgeneral,5,5)+' -- '+XPhotolysisRate);
     Writeln(LF,'OxRateConst: '+FloatToStrF(OxRateConst,ffgeneral,5,5)+' -- '+XOxRateConst);
     Write(LF,'CalcKPSed: '); If CalcKPSed then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     If Not CalcKPSed then Writeln(LF,'KPSed: '+FloatToStrF(KPSed,ffgeneral,5,5)+' -- '+XKPSed);
     Write(LF,'CalcKOMRefrDOM: '); If CalcKOMRefrDOM then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     If Not CalcKOMRefrDOM then Writeln(LF,'KOMRefrDOM: '+FloatToStrF(KOMRefrDOM,ffgeneral,5,5)+' -- '+XKOMRefrDOM);
     Writeln(LF,'Weibull_Shape: '+FloatToStrF(Weibull_Shape,ffgeneral,5,5)+' -- '+XWeibull_Shape);
     Write(LF,'ChemIsBase: '); If ChemIsBase then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Writeln(LF,'K1Detritus: '+FloatToStrF(K1Detritus,ffgeneral,5,5) +' -- ' + XK1Detritus);
     Writeln(LF,'CohesivesK1: '+FloatToStrF(CohesivesK1,ffgeneral,5,5));
     Writeln(LF,'CohesivesK2: '+FloatToStrF(CohesivesK2,ffgeneral,5,5));
     Writeln(LF,'CohesivesKp: '+FloatToStrF(CohesivesKp,ffgeneral,5,5));
     Writeln(LF,'CohesivesRef: '+CohesivesRef);
     Writeln(LF,'NonCohK1: '+FloatToStrF(NonCohK1,ffgeneral,5,5));
     Writeln(LF,'NonCohK2: '+FloatToStrF(NonCohK2,ffgeneral,5,5));
     Writeln(LF,'NonCohKp: '+FloatToStrF(NonCohKp,ffgeneral,5,5));
     Writeln(LF,'NonCohRef: '+NonCohRef);
     Writeln(LF,'NonCoh2K1: '+FloatToStrF(NonCoh2K1,ffgeneral,5,5));
     Writeln(LF,'NonCoh2K2: '+FloatToStrF(NonCoh2K2,ffgeneral,5,5));
     Writeln(LF,'NonCoh2Kp: '+FloatToStrF(NonCoh2Kp,ffgeneral,5,5));
     Writeln(LF,'NonCoh2Ref: '+NonCoh2Ref);
     Write(LF,'IsPFA: '); If IsPFA then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Writeln(LF,'PFAType: '+PFAType);
     Writeln(LF,'PFAChainLength: '+FloatToStrF(PFAChainLength,ffgeneral,5,5)+' -- '+XPFAChainLength);
     Writeln(LF,'PFASedKom: '+FloatToStrF(PFASedKom,ffgeneral,5,5)+' -- '+XPFASedKom);
     Writeln(LF,'PFAAlgBCF: '+FloatToStrF(PFAAlgBCF,ffgeneral,5,5)+' -- '+XPFAAlgBCF);
     Writeln(LF,'PFAMacroBCF: '+FloatToStrF(PFAMacroBCF,ffgeneral,5,5)+' -- '+XPFAMacroBCF);
     Writeln(LF,'WeibullSlopeFactor: '+FloatToStrF(WeibullSlopeFactor,ffgeneral,5,5)+' -- '+XWeibullSlopeFactor);
    End; {with}
End; {proc}


{-----------------------------------------------------------------}

Function DBase_To_AnimalRecord(DbDir,DbName,DbEntry: ShortString; Num: Integer; Var AR: ZooRecord):Boolean;
Begin
   Table1 := TTable.Create(nil);

   Try
   If DBEntry = ''
      then DBase_To_AnimalRecord:=GetEntryByNum(DbDir,DbName,Num)
      else DBase_To_AnimalRecord:=GetEntry(DbDir,DbName,DbEntry,False,False);

   With Table1 do begin
   With AR do begin
      AnimalName        := Fieldbyname('AnimalName').AsString;
      FHalfSat          := Fields[1].AsFloat;
      XFHalfSat         := Fields[2].AsString;
      CMax              := Fields[3].AsFloat;
      XCMax             := Fields[4].AsString;
      BMin              := Fields[5].AsFloat;
      XBMin             := Fields[6].AsString;
      Q10               := Fields[7].AsFloat;
      XQ10              := Fields[8].AsString;
      TOpt              := Fields[9].AsFloat;
      XTOpt             := Fields[10].AsString;
      TMax              := Fields[11].AsFloat;
      XTMax             := Fields[12].AsString;
      TRef              := Fields[13].AsFloat;
      XTRef             := Fields[14].AsString;
      EndogResp         := Fields[15].AsFloat;
      XEndogResp        := Fields[16].AsString;
      KResp             := Fields[17].AsFloat;
      XKResp            := Fields[18].AsString;
      KExcr             := Fields[19].AsFloat;
      XKExcr            := Fields[20].AsString;
      PctGamete         := Fields[21].AsFloat;
      XPctGamete        := Fields[22].AsString;
      GMort             := Fields[23].AsFloat;
      XGMort            := Fields[24].AsString;
      KMort             := Fields[25].AsFloat;
      XKMort            := Fields[26].AsString;
      KCap              := Fields[27].AsFloat;
      XKCap             := Fields[28].AsString;
      MeanWeight        := Fields[29].AsFloat;
      XMeanWeight       := Fields[30].AsString;
      FishFracLipid     := Fields[31].AsFloat;
      XFishFracLipid    := Fields[32].AsString;
      ToxicityRecord    := Fields[33].AsString;
      LifeSpan          := Fields[34].AsFloat;
      XLifeSpan         := Fields[35].AsString;
      Animal_Type       := Fields[36].AsString;
      AveDrift          := Fields[37].asfloat;
      XAveDrift         := Fields[38].asString;
      AutoSpawn         := Fields[39].asBoolean;
      SpawnDate1        := Fields[40].asDateTime;
      SpawnDate2        := Fields[41].asDateTime;
      SpawnDate3        := Fields[42].asDateTime;
      XSpawnDate        := Fields[43].asString;
      UnlimitedSpawning := Fields[44].asBoolean;
      SpawnLimit        := Fields[45].asInteger;
      UseAllom_C        := Fields[46].asBoolean;
      CA                := Fields[47].asFloat;
      CB                := Fields[48].asFloat;
      UseAllom_R        := Fields[49].asBoolean;
      RA                := Fields[50].asFloat;
      RB                := Fields[51].asFloat;
      UseSet1           := Fields[52].asBoolean;
      RQ                := Fields[53].asFloat;
      RTO               := Fields[54].asFloat;
      RTM               := Fields[55].asFloat;
      RTL               := Fields[56].asFloat;
      RK1               := Fields[57].asFloat;
      RK4               := Fields[58].asFloat;
      ACT               := Fields[59].asFloat;
      BACT              := Fields[60].asFloat;
      FracInWaterCol    := Fields[61].asFloat;
      XFracInWaterCol   := Fields[62].asString;
      Guild_Taxa        := Fields[63].asString;

      PrefRiffle        := Fields[64].asFloat;
      XPrefRiffle       := Fields[65].asstring;
      PrefPool          := Fields[66].asFloat;
      XPrefPool         := Fields[67].asstring;
      VelMax            := Fields[68].asFloat;
      XVelMax           := Fields[69].asstring;
      XAllomConsumpt    := Fields[70].asstring;
      XAllomResp        := Fields[71].asstring;
      Salmin_Ing        := Fields[72].asFloat;
      SalMax_Ing        := Fields[73].asFloat;
      Salcoeff1_Ing     := Fields[74].asFloat;
      Salcoeff2_Ing     := Fields[75].asFloat;
      XSalinity_Ing     := Fields[76].asstring;
      Salmin_Gam        := Fields[77].asFloat;
      SalMax_Gam        := Fields[78].asFloat;
      Salcoeff1_Gam     := Fields[79].asFloat;
      Salcoeff2_Gam     := Fields[80].asFloat;
      XSalinity_Gam     := Fields[81].asstring;
      Salmin_Rsp        := Fields[82].asFloat;
      SalMax_Rsp        := Fields[83].asFloat;
      Salcoeff1_Rsp     := Fields[84].asFloat;
      Salcoeff2_Rsp     := Fields[85].asFloat;
      XSalinity_Rsp     := Fields[86].asstring;
      Salmin_Mort       := Fields[87].asFloat;
      SalMax_Mort       := Fields[88].asFloat;
      Salcoeff1_Mort    := Fields[89].asFloat;
      Salcoeff2_Mort    := Fields[90].asFloat;   //10/17/2012 Fix
      XSalinity_Mort    := Fields[91].asstring;
      Fishing_Frac      := Fields[92].asFloat;
      XFishing_Frac     := Fields[93].asstring;
{       Pct_Habitat       := Fields[94].asFloat;
      XPct_Habitat      := Fields[95].asstring; }

      P2Org             := Fields[96].asFloat;
      XP2Org            := Fields[97].asString;
      N2Org             := Fields[98].asFloat;
      XN2Org            := Fields[99].asString;
      Wet2Dry           := Fields[100].AsFloat;
      XWet2Dry          := Fields[101].AsString;

      O2_LethalConc     := Fields[102].AsFloat;
      O2_LethalPct      := Fields[103].AsFloat;
      O2_LCRef          := Fields[104].AsString;
      O2_EC50growth     := Fields[105].AsFloat;
      XO2_EC50growth    := Fields[106].AsString;
      O2_EC50repro      := Fields[107].AsFloat;
      XO2_EC50repro     := Fields[108].AsString;

      Ammonia_LC50          := Fields[109].AsFloat;
      XAmmonia_LC50         := Fields[110].AsString;

      Sorting              := Fields[111].AsFloat;    {3.46, SABS}
      XSorting             := Fields[112].AsString;
      SuspSedFeeding       := Fields[113].AsBoolean;
      XSuspSedFeeding      := Fields[114].AsString;
      SlopeSSFeed          := Fields[115].AsFloat;
      XSlopeSSFeed         := Fields[116].AsString;
      InterceptSSFeed      := Fields[117].AsFloat;
      XInterceptSSFeed     := Fields[118].AsString;
      SenstoSediment       := Fields[119].AsString;
      XSensToSediment      := Fields[120].AsString;
      Trigger              := Fields[121].AsFloat;
      XTrigger             := Fields[122].AsString;

      SenstoPctEmbed     := Fields[123].AsBoolean;
      PctEmbedThreshold  := Fields[124].AsFloat  ;
      XPctEmbedThreshold := Fields[125].AsString ;
      BenthicDesignation := Fields[126].AsString ;
      ScientificName     := Fields[127].AsString ;

   end; {with AR}
   end; {with SV_IO_Form.Table1}

   ResetFile(DbDir,DbName);
   Except

   DBase_To_animalRecord:=False;
   If FileExists(DBDir+'\'+AbbrString(DbName,'.')+'.DB') then
                                             ResetFile(DbDir,DbName);

   End; {try Except}
   Table1.Free;
End;    {DBase_To_animalRecord}

{-----------------------------------------------------------------}

Function AnimalRecord_to_Dbase(DbDir,DbName,DbEntry: ShortString; AR: ZooRecord;Prompt:Boolean):Boolean;

Begin

   Try
   Table1 := TTable.Create(nil);

      AnimalRecord_to_Dbase:=GetEntry(DbDir,DbName,DbEntry,True,Prompt);
      If not Result then Exit;

   With Table1 do begin

      Edit;

   With AR do begin
      Fieldbyname('AnimalName').AsString:=AnimalName;
      Fields[1].AsFloat   := FHalfSat;
      Fields[2].AsString  := XFHalfSat;
      Fields[3].AsFloat   := CMax;
      Fields[4].AsString  := XCMax;
      Fields[5].AsFloat   := BMin;
      Fields[6].AsString  := XBMin;
      Fields[7].AsFloat   := Q10;
      Fields[8].AsString  := XQ10;
      Fields[9].AsFloat   := TOpt;
      Fields[10].AsString := XTOpt;
      Fields[11].AsFloat  := TMax;
      Fields[12].AsString := XTMax;
      Fields[13].AsFloat  := TRef;
      Fields[14].AsString := XTRef;
      Fields[15].AsFloat  := EndogResp;
      Fields[16].AsString := XEndogResp;
      Fields[17].AsFloat  := KResp;
      Fields[18].AsString := XKResp;
      Fields[19].AsFloat  := KExcr;
      Fields[20].AsString := XKExcr;
      Fields[21].AsFloat  := PctGamete;
      Fields[22].AsString := XPctGamete;
      Fields[23].AsFloat  := GMort;
      Fields[24].AsString := XGMort;
      Fields[25].AsFloat  := KMort;
      Fields[26].AsString := XKMort;
      Fields[27].AsFloat  := KCap;
      Fields[28].AsString := XKCap;
      Fields[29].AsFloat  := MeanWeight;
      Fields[30].AsString := XMeanWeight;
      Fields[31].AsFloat  := FishFracLipid;
      Fields[32].AsString := XFishFracLipid;
      Fields[33].AsString := ToxicityRecord;
      Fields[34].AsFloat  := LifeSpan;
      Fields[35].AsString := XLifeSpan;
      Fields[36].AsString := Animal_Type;
      Fields[37].asFloat  := AveDrift;
      Fields[38].asString := XAveDrift;
      Fields[39].asBoolean:= AutoSpawn;
      Fields[40].asDateTime := SpawnDate1;
      Fields[41].asDateTime := SpawnDate2;
      Fields[42].asDateTime := SpawnDate3;
      Fields[43].asString := XSpawnDate;
      Fields[44].asBoolean:= UnlimitedSpawning;
      Fields[45].asInteger:= SpawnLimit;
      Fields[46].asBoolean:= UseAllom_C;
      Fields[47].asFloat  := CA;
      Fields[48].asFloat  := CB;
      Fields[49].asBoolean:= UseAllom_R;
      Fields[50].asFloat  := RA;
      Fields[51].asFloat  := RB;
      Fields[52].asBoolean:= UseSet1;
      Fields[53].asFloat  := RQ;
      Fields[54].asFloat  := RTO;
      Fields[55].asFloat  := RTM;
      Fields[56].asFloat  := RTL;
      Fields[57].asFloat  := RK1;
      Fields[58].asFloat  := RK4;
      Fields[59].asFloat  := ACT;
      Fields[60].asFloat  := BACT;
      Fields[61].asFloat  := FracInWaterCol;
      Fields[62].asString := XFracInWaterCol;
      Fields[63].asString := Guild_Taxa;

      Fields[64].asFloat :=PrefRiffle;
      Fields[65].asstring :=XPrefRiffle;
      Fields[66].asFloat :=PrefPool;
      Fields[67].asstring :=XPrefPool;
      Fields[68].asFloat :=VelMax;
      Fields[69].asstring :=XVelMax;
      Fields[70].asstring :=XAllomConsumpt;
      Fields[71].asstring :=XAllomResp;
      Fields[72].asFloat :=Salmin_Ing;
      Fields[73].asFloat :=SalMax_Ing;
      Fields[74].asFloat :=Salcoeff1_Ing;
      Fields[75].asFloat :=Salcoeff2_Ing;
      Fields[76].asstring :=XSalinity_Ing;
      Fields[77].asFloat :=Salmin_Gam;
      Fields[78].asFloat :=SalMax_Gam;
      Fields[79].asFloat :=Salcoeff1_Gam;
      Fields[80].asFloat :=Salcoeff2_Gam;
      Fields[81].asstring :=XSalinity_Gam;
      Fields[82].asFloat :=Salmin_Rsp;
      Fields[83].asFloat :=SalMax_Rsp;
      Fields[84].asFloat :=Salcoeff1_Rsp;
      Fields[85].asFloat :=Salcoeff2_Rsp;
      Fields[86].asstring :=XSalinity_Rsp;
      Fields[87].asFloat :=Salmin_Mort;
      Fields[88].asFloat :=SalMax_Mort;
      Fields[89].asFloat :=Salcoeff1_Mort;
      Fields[90].asFloat :=Salcoeff2_Mort;   //10/17/2012 Fix
      Fields[91].asstring :=XSalinity_Mort;
      Fields[92].asFloat :=Fishing_Frac;
      Fields[93].asstring :=XFishing_Frac;
{      Fields[94].asFloat :=Pct_Habitat;
      Fields[95].asstring :=XPct_Habitat; }

      Fields[96].asFloat := P2Org;
      Fields[97].asString := XP2Org;
      Fields[98].asFloat := N2Org;
      Fields[99].asString := XN2Org;
      Fields[100].AsFloat := Wet2Dry;
      Fields[101].AsString := XWet2Dry;

      Fields[102].AsFloat := O2_LethalConc;
      Fields[103].AsFloat := O2_LethalPct;
      Fields[104].AsString := O2_LCRef;
      Fields[105].AsFloat := O2_EC50growth;
      Fields[106].AsString := XO2_EC50growth;
      Fields[107].AsFloat := O2_EC50repro;
      Fields[108].AsString := XO2_EC50repro;

      Fields[109].AsFloat := Ammonia_LC50;
      Fields[110].AsString := XAmmonia_LC50;

      Fields[111].AsFloat :=Sorting;
      Fields[112].AsString:=XSorting;
      Fields[113].AsBoolean:=SuspSedFeeding;
      Fields[114].AsString:=XSuspSedFeeding;
      Fields[115].AsFloat:=SlopeSSFeed;
      Fields[116].AsString:=XSlopeSSFeed;
      Fields[117].AsFloat:=InterceptSSFeed;
      Fields[118].AsString:=XInterceptSSFeed;
      Fields[119].AsString:=SenstoSediment;
      Fields[120].AsString:=XSensToSediment;
      Fields[121].AsFloat:=Trigger;
      Fields[122].AsString:=XTrigger;

      Fields[123].AsBoolean := SenstoPctEmbed;
      Fields[124].AsFloat   := PctEmbedThreshold;
      Fields[125].AsString  := XPctEmbedThreshold;
      Fields[126].AsString  := BenthicDesignation;
      Fields[127].AsString  := ScientificName;

   end; {with AR}
   Post;
   end; {with SV_IO_Form.Table1}

   ResetFile(DbDir,DbName);
   Except

   AnimalRecord_to_Dbase:=False;
   If FileExists(DBDir+'\'+AbbrString(DbName,'.')+'.DB') then
                                             ResetFile(DbDir,DbName);
   End; {try Except}
   Table1.Free;
End;    {AnimalRecord_to_Dbase}

{-----------------------------------------------------------------}


Procedure AnimRec_To_Text;
Begin
  With AR do
    Begin
     Writeln(LF,'AnimalName: '+AnimalName);
     Writeln(LF,'ScientificName: '+ScientificName);
     Writeln(LF,'ToxicityRecord: '+ToxicityRecord);
     Writeln(LF,'FHalfSat: '+FloatToStrF(FHalfSat,ffgeneral,5,5)+' -- '+XFHalfSat);
     Writeln(LF,'CMax: '+FloatToStrF(CMax,ffgeneral,5,5)+' -- '+XCMax);
     Writeln(LF,'BMin: '+FloatToStrF(BMin,ffgeneral,5,5)+' -- '+XBMin);
     Writeln(LF,'Q10: '+FloatToStrF(Q10,ffgeneral,5,5)+' -- '+XQ10);
     Writeln(LF,'TOpt: '+FloatToStrF(TOpt,ffgeneral,5,5)+' -- '+XTOpt);
     Writeln(LF,'TMax: '+FloatToStrF(TMax,ffgeneral,5,5)+' -- '+XTMax);
     Writeln(LF,'TRef: '+FloatToStrF(TRef,ffgeneral,5,5)+' -- '+XTRef);
     Writeln(LF,'EndogResp: '+FloatToStrF(EndogResp,ffgeneral,5,5)+' -- '+XEndogResp);
     Writeln(LF,'KResp: '+FloatToStrF(KResp,ffgeneral,5,5)+' -- '+XKResp);
     Writeln(LF,'KExcr: '+FloatToStrF(KExcr,ffgeneral,5,5)+' -- '+XKExcr);
     Writeln(LF,'PctGamete: '+FloatToStrF(PctGamete,ffgeneral,5,5)+' -- '+XPctGamete);
     Writeln(LF,'GMort: '+FloatToStrF(GMort,ffgeneral,5,5)+' -- '+XGMort);
     Writeln(LF,'KMort: '+FloatToStrF(KMort,ffgeneral,5,5)+' -- '+XKMort);
     Writeln(LF,'Placeholder: '+FloatToStrF(Placeholder,ffgeneral,5,5)+' -- '+XPlaceholder);
     Writeln(LF,'KCap: '+FloatToStrF(KCap,ffgeneral,5,5)+' -- '+XKCap);
     Writeln(LF,'MeanWeight: '+FloatToStrF(MeanWeight,ffgeneral,5,5)+' -- '+XMeanWeight);
     Writeln(LF,'FishFracLipid: '+FloatToStrF(FishFracLipid,ffgeneral,5,5)+' -- '+XFishFracLipid);
     Writeln(LF,'LifeSpan: '+FloatToStrF(LifeSpan,ffgeneral,5,5)+' -- '+XLifeSpan);
     Writeln(LF,'Animal_Type: '+Animal_Type);
     If BenthicDesignation <> '' then Writeln(LF,'Benthic Designation: '+BenthicDesignation);

     Writeln(LF,'AveDrift: '+FloatToStrF(AveDrift,ffgeneral,5,5)+' -- '+XAveDrift);
     Write(LF,'AutoSpawn: '); If AutoSpawn then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     If not AutoSpawn then
       Begin
         Writeln(LF,'SpawnDate1: '+DateToStr(SpawnDate1));
         Writeln(LF,'SpawnDate2: '+DateToStr(SpawnDate2));
         Writeln(LF,'SpawnDate3: '+DateToStr(SpawnDate3));
       End;
     Writeln(LF,'XSpawnDate: '+XSpawnDate);
     Write(LF,'UnlimitedSpawning: '); If UnlimitedSpawning then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Writeln(LF,'SpawnLimit: '+IntToStr(SpawnLimit));
     Write(LF,'UseAllom_C: '); If UseAllom_C then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Writeln(LF,'CA: '+FloatToStrF(CA,ffgeneral,5,5));
     Writeln(LF,'CB: '+FloatToStrF(CB,ffgeneral,5,5));
     Write(LF,'UseAllom_R: '); If UseAllom_R then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Writeln(LF,'RA: '+FloatToStrF(RA,ffgeneral,5,5));
     Writeln(LF,'RB: '+FloatToStrF(RB,ffgeneral,5,5));
     Write(LF,'UseSet1: '); If UseSet1 then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Writeln(LF,'RK1,: '+FloatToStrF(RK1,ffgeneral,5,5));
     Writeln(LF,'FracInWaterCol: '+FloatToStrF(FracInWaterCol,ffgeneral,5,5)+' -- '+XFracInWaterCol);
     Writeln(LF,'Guild_Taxa: '+Guild_Taxa);
     Writeln(LF,'PrefRiffle: '+FloatToStrF(PrefRiffle,ffgeneral,5,5)+' -- '+XPrefRiffle);
     Writeln(LF,'PrefPool: '+FloatToStrF(PrefPool,ffgeneral,5,5)+' -- '+XPrefPool);
     Writeln(LF,'VelMax: '+FloatToStrF(VelMax,ffgeneral,5,5)+' -- '+XVelMax);
     Writeln(LF,'XAllomConsumpt: '+XAllomConsumpt);
     Writeln(LF,'XAllomResp: '+XAllomResp);
     Writeln(LF,'Salcoeff2_Ing: '+FloatToStrF(Salcoeff2_Ing,ffgeneral,5,5));
     Writeln(LF,'XSalinity_Ing: '+XSalinity_Ing);
     Writeln(LF,'Salcoeff2_Gam: '+FloatToStrF(Salcoeff2_Gam,ffgeneral,5,5));
     Writeln(LF,'XSalinity_Gam: '+XSalinity_Gam);
     Writeln(LF,'Salcoeff2_Rsp: '+FloatToStrF(Salcoeff2_Rsp,ffgeneral,5,5));
     Writeln(LF,'XSalinity_Rsp: '+XSalinity_Rsp);
     Writeln(LF,'Salcoeff2_Mort: '+FloatToStrF(Salcoeff2_Mort,ffgeneral,5,5));
     Writeln(LF,'XSalinity_Mort: '+XSalinity_Mort);
     Writeln(LF,'Fishing_Frac: '+FloatToStrF(Fishing_Frac,ffgeneral,5,5)+' -- '+XFishing_Frac);
{     Writeln(LF,'Pct_Habitat: '+FloatToStrF(Pct_Habitat,ffgeneral,5,5)+' -- '+XPct_Habitat); }
     Writeln(LF,'P2Org: '+FloatToStrF(P2Org,ffgeneral,5,5)+' -- '+XP2Org);
     Writeln(LF,'N2Org: '+FloatToStrF(N2Org,ffgeneral,5,5)+' -- '+XN2Org);
     Writeln(LF,'Wet2Dry: '+FloatToStrF(Wet2Dry,ffgeneral,5,5)+' -- '+XWet2Dry);
     Writeln(LF,'LC'+FloatToStrF(O2_LethalPct,ffgeneral,5,5)+
                     FloatToStrF(O2_LethalConc,ffgeneral,5,5)+' -- '+O2_LCRef);
     Writeln(LF,'EC50 Growth: '+FloatToStrF(O2_EC50growth,ffgeneral,5,5)+' -- '+XO2_EC50growth);
     Writeln(LF,'EC50 Repro: '+FloatToStrF(O2_EC50repro,ffgeneral,5,5)+' -- '+XO2_EC50repro);
     Writeln(LF,'Ammonia LC50: '+FloatToStrF(Ammonia_LC50,ffgeneral,5,5)+' -- '+XAmmonia_LC50);

     Writeln(LF,'Sorting: '+FloatToStrF(Sorting,ffgeneral,5,5)+' -- '+XSorting);
     If SuspSedFeeding then
       Begin
         Writeln(LF,'Animal IS a Visual Feeder'+' -- '+XSuspSedFeeding);
         Writeln(LF,'SlopeSSFeed: '+FloatToStrF(SlopeSSFeed,ffgeneral,5,5)+' -- '+XSlopeSSFeed);
         Writeln(LF,'InterceptSSFeed: '+FloatToStrF(InterceptSSFeed,ffgeneral,5,5)+' -- '+XInterceptSSFeed);
       End;
     Writeln(LF,'SensToSediment: '+SensToSediment+' -- '+XSensToSediment);
     Writeln(LF,'Drift Trigger: '+FloatToStrF(Trigger,ffgeneral,5,5)+' -- '+XTrigger);
     If Not SenstoPctEmbed
       then Writeln(LF,'Animal not sensitive to percent embeddedness')
       else Writeln(LF,'Pct. Embedded Threshhold: '+FloatToSTrF(PctEmbedThreshold,ffgeneral,5,5) +' -- '+XPctEmbedThreshold);


    End;
End;

{-----------------------------------------------------------------}

Function DBase_To_SiteRecord(DbDir,DbName,DbEntry: ShortString; Var SR: SiteRecord):Boolean;

Begin
      Table1 := TTable.Create(nil);

   Try
      DBase_To_siteRecord:=GetEntry(DbDir,DbName,DbEntry,False,False);

   If Result then
   With Table1 do begin
   With SR do begin
      siteName             := Fieldbyname('Site Name').AsString;
      SiteLength           := Fields[1].AsFloat;
      XLength              := Fields[2].AsString;
      StaticVolume         := Fields[3].AsFloat;
      XVolume              := Fields[4].AsString;
      SurfArea             := Fields[5].AsFloat;
      XSurfArea            := Fields[6].AsString;
      ICZMean              := Fields[7].AsFloat;
      XZMean               := Fields[8].AsString;
      ZMax                 := Fields[9].AsFloat;
      XZMax                := Fields[10].AsString;
      TempMean[Epilimnion] := Fields[11].AsFloat;
      XTempMean[Epilimnion]:= Fields[12].AsString;
      TempMean[Hypolimnion]:= Fields[13].AsFloat;
      XTempMean[Hypolimnion]:= Fields[14].AsString;
      TempRange[Epilimnion] := Fields[15].AsFloat;
      XTempRange[Epilimnion]:= Fields[16].AsString;
      TempRange[Hypolimnion]:= Fields[17].AsFloat;
      XTempRange[Hypolimnion]:=Fields[18].AsString;
      Latitude             := Fields[19].AsFloat;
      XLatitude            := Fields[20].AsString;
      LightMean            := Fields[21].AsFloat;
      XLightMean           := Fields[22].AsString;
      LightRange           := Fields[23].AsFloat;
      XLightRange          := Fields[24].AsString;
      AlkCaCO3             := Fields[25].AsFloat;
      XAlkCaCO3            := Fields[26].AsString;
      HardCaCO3            := Fields[27].AsFloat;
      XHardCaCO3           := Fields[28].AsString;
      SiteComment          := Fields[29].AsString;
      SO4Conc              := Fields[30].AsFloat;
      XSO4Conc             := Fields[31].AsString;
      TotalDissSolids      := Fields[32].AsFloat;
      XTotalDissSolids     := Fields[33].AsString;
      StreamType           := Fields[34].AsString;
      Channel_Slope        := Fields[35].AsFloat;
      XChannel_Slope       := Fields[36].AsString;
      Max_Chan_Depth       := Fields[37].AsFloat;
      XMax_Chan_Depth      := Fields[38].AsString;
      SedDepth             := Fields[39].AsFloat;
      XSedDepth            := Fields[40].AsString;
      EnclWallArea        := Fields[41].AsFloat;
      XEnclWallArea       := Fields[42].AsString;
      MeanEvap             := Fields[43].AsFloat;   {inches / year}
      XMeanEvap            := Fields[44].AsString;
      UseEnteredManning    := Fields[45].AsBoolean;
      EnteredManning       := Fields[46].AsFloat;
      UseBathymetry        := Fields[47].AsBoolean;
      ECoeffWater          := Fields[48].AsFloat;
      XECoeffWater         := Fields[49].AsString;

      PctRiffle            := Fields[50].AsFloat;
      XPctRiffle           := Fields[51].AsString;
      PctPool              := Fields[52].AsFloat;
      XPctPool             := Fields[53].AsString;
      ts_clay              := Fields[54].AsFloat;
      Xts_clay             := Fields[55].AsString;
      ts_silt              := Fields[56].AsFloat;
      Xts_silt             := Fields[57].AsString;
      tdep_clay            := Fields[58].AsFloat;
      Xtdep_clay           := Fields[59].AsString;
      tdep_silt            := Fields[60].AsFloat;
      Xtdep_silt           := Fields[61].AsString;
      FallVel_clay         := Fields[62].AsFloat;
      XFallVel_clay        := Fields[63].AsString;
      FallVel_silt         := Fields[64].AsFloat;
      XFallVel_silt        := Fields[65].AsString;
      SiteWidth            := Fields[66].AsFloat;
      XSiteWidth           := Fields[67].AsString;
 {m2} amplitude1           := Fields[68].AsFloat;
      k1                   := Fields[69].AsFloat;
      ConstRef1            := Fields[70].AsString;
 {s2} amplitude2           := Fields[71].AsFloat;
      k2                   := Fields[72].AsFloat;
      ConstRef2            := Fields[73].AsString;
 {n2} amplitude3           := Fields[74].AsFloat;
      k3                   := Fields[75].AsFloat;
      ConstRef3            := Fields[76].AsString;
 {k1} amplitude4           := Fields[77].AsFloat;
      k4                   := Fields[78].AsFloat;
      ConstRef4            := Fields[79].AsString;
 {o1} amplitude5           := Fields[80].AsFloat;
      k5                   := Fields[81].AsFloat;
      ConstRef5            := Fields[82].AsString;
{SSA} amplitude6           := Fields[83].AsFloat;
      k6                   := Fields[84].AsFloat;
      ConstRef6            := Fields[85].AsString;
 {SA} amplitude7           := Fields[86].AsFloat;
      k7                   := Fields[87].AsFloat;
      ConstRef7            := Fields[88].AsString;
 {P1} amplitude8           := Fields[89].AsFloat;
      k8                   := Fields[90].AsFloat;
      ConstRef8            := Fields[91].AsString;
      Min_Vol_Frac         := Fields[92].AsFloat;
      XMin_Vol_Frac        := Fields[93].AsString;

      WaterShedArea        := Fields[94].AsFloat;
      XWaterShedArea       := Fields[95].AsString;
      EnterTotalLength     := Fields[96].AsBoolean;
      TotalLength          := Fields[97].AsFloat;
      XTotalLength         := Fields[98].AsString;

      ECoeffSED            := Fields[99].AsFloat;
      XECoeffSED           := Fields[100].AsString;
      ECoeffDOM            := Fields[101].AsFloat;
      XECoeffDOM           := Fields[102].AsString;
      ECoeffPOM            := Fields[103].AsFloat;
      XECoeffPOM           := Fields[104].AsString;

      UseCovar             := Fields[105].AsBoolean;
      EnteredKReaer        := Fields[106].AsFloat;
      XEnteredKReaer       := Fields[107].AsString;

      UsePhytoRetention    := Fields[108].AsBoolean;

      BasePercentEmbed     := Fields[109].AsFloat;
      XBasePercentEmbed    := Fields[110].AsString;

      Altitude             := Fields[111].AsFloat;
      XAltitude            := Fields[112].AsString;

 end; {with SR}
 end; {with SV_IO_Form.Table1}

   ResetFile(DbDir,DbName);

   Except

   DBase_To_siteRecord:=False;
   If FileExists(DBDir+'\'+AbbrString(DbName,'.')+'.DB') then
                                             ResetFile(DbDir,DbName);
   End; {try Except}
   Table1.Free;
End;    {DBase_To_siteRecord}
{-----------------------------------------------------------------}

Function SiteRecord_To_Dbase(DbDir,DbName,DbEntry: ShortString; SR: SiteRecord):Boolean;

Begin
      Table1 := TTable.Create(nil);

   Try
      SiteRecord_to_Dbase:=GetEntry(DbDir,DbName,DbEntry,True,False);

   With Table1 do begin
      Edit;

   With SR do begin
      Fieldbyname('Site Name').AsString:=siteName;
      Fields[1].AsFloat:=SiteLength;
      Fields[2].AsString:=XLength;
      Fields[3].AsFloat:=StaticVolume;
      Fields[4].AsString:=XVolume;
      Fields[5].AsFloat:=SurfArea;
      Fields[6].AsString:=XSurfArea;
      Fields[7].AsFloat:=ICZMean;
      Fields[8].AsString:=XZMean;
      Fields[9].AsFloat:=ZMax;
      Fields[10].AsString:=XZMax;
      Fields[11].AsFloat:=TempMean[Epilimnion];
      Fields[12].AsString:=XTempMean[Epilimnion];
      Fields[13].AsFloat:=TempMean[Hypolimnion];
      Fields[14].AsString:=XTempMean[Hypolimnion];
      Fields[15].AsFloat:=TempRange[Epilimnion];
      Fields[16].AsString:=XTempRange[Epilimnion];
      Fields[17].AsFloat :=TempRange[Hypolimnion];
      Fields[18].AsString:=XTempRange[Hypolimnion];
      Fields[19].AsFloat :=Latitude;
      Fields[20].AsString:=XLatitude;
      Fields[21].AsFloat :=LightMean;
      Fields[22].AsString:=XLightMean;
      Fields[23].AsFloat :=LightRange;
      Fields[24].AsString:=XLightRange;
      Fields[25].AsFloat :=AlkCaCO3;
      Fields[26].AsString:=XAlkCaCO3;
      Fields[27].AsFloat :=HardCaCO3;
      Fields[28].AsString:=XHardCaCO3;
      Fields[29].AsString:=SiteComment;
      Fields[30].AsFloat := SO4Conc;
      Fields[31].AsString:=XSO4Conc;
      Fields[32].AsFloat :=TotalDissSolids;
      Fields[33].AsString:=XTotalDissSolids;
      Fields[34].AsString:=StreamType;
      Fields[35].AsFloat :=Channel_Slope;
      Fields[36].AsString:=XChannel_Slope;
      Fields[37].AsFloat :=Max_Chan_Depth;
      Fields[38].AsString:=XMax_Chan_Depth;
      Fields[39].AsFloat :=SedDepth;
      Fields[40].AsString:=XSedDepth;
      Fields[41].AsFloat :=EnclWallArea;
      Fields[42].AsString:=XEnclWallArea;
      Fields[43].AsFloat :=MeanEvap;
      Fields[44].AsString:=XMeanEvap;
      Fields[45].AsBoolean:=UseEnteredManning;
      Fields[46].AsFloat  :=EnteredManning;
      Fields[47].AsBoolean :=UseBathymetry;
      Fields[48].AsFloat  := ECoeffWater;
      Fields[49].AsString := XECoeffWater;

      Fields[50].AsFloat :=PctRiffle;
      Fields[51].AsString :=XPctRiffle;
      Fields[52].AsFloat :=PctPool;
      Fields[53].AsString :=XPctPool;
      Fields[54].AsFloat :=ts_clay;
      Fields[55].AsString :=Xts_clay;
      Fields[56].AsFloat :=ts_silt;
      Fields[57].AsString :=Xts_silt;
      Fields[58].AsFloat :=tdep_clay;
      Fields[59].AsString :=Xtdep_clay;
      Fields[60].AsFloat :=tdep_silt;
      Fields[61].AsString :=Xtdep_silt;
      Fields[62].AsFloat :=FallVel_clay;
      Fields[63].AsString :=XFallVel_clay;
      Fields[64].AsFloat :=FallVel_silt;
      Fields[65].AsString :=XFallVel_silt;
      Fields[66].AsFloat :=SiteWidth;
      Fields[67].AsString :=XSiteWidth;
      Fields[68].AsFloat :={m2} amplitude1;
      Fields[69].AsFloat :=k1;
      Fields[70].AsString :=ConstRef1;
      Fields[71].AsFloat :={s2} amplitude2;
      Fields[72].AsFloat :=k2;
      Fields[73].AsString :=ConstRef2;
      Fields[74].AsFloat :={n2} amplitude3;
      Fields[75].AsFloat :=k3;
      Fields[76].AsString :=ConstRef3;
      Fields[77].AsFloat :={k1} amplitude4;
      Fields[78].AsFloat :=k4;
      Fields[79].AsString :=ConstRef4;
      Fields[80].AsFloat :={o1} amplitude5;
      Fields[81].AsFloat :=k5;
      Fields[82].AsString :=ConstRef5;
      Fields[83].AsFloat :={SSA} amplitude6;
      Fields[84].AsFloat :=k6;
      Fields[85].AsString :=ConstRef6;
      Fields[86].AsFloat :={SA} amplitude7;
      Fields[87].AsFloat :=k7;
      Fields[88].AsString :=ConstRef7;
      Fields[89].AsFloat :={P1} amplitude8;
      Fields[90].AsFloat := k8;
      Fields[91].AsString:= ConstRef8;
      Fields[92].AsFloat := Min_Vol_Frac;
      Fields[93].AsString:= XMin_Vol_Frac;

      Fields[94].AsFloat := WaterShedArea;
      Fields[95].AsString := XWaterShedArea;
      Fields[96].AsBoolean := EnterTotalLength;
      Fields[97].AsFloat := TotalLength;
      Fields[98].AsString := XTotalLength;

      Fields[99].AsFloat := ECoeffSED ;
      Fields[100].AsString := XECoeffSED;
      Fields[101].AsFloat := ECoeffDOM ;
      Fields[102].AsString := XECoeffDOM;
      Fields[103].AsFloat := ECoeffPOM ;
      Fields[104].AsString := XECoeffPOM;

      Fields[105].AsBoolean :=UseCovar;
      Fields[106].AsFloat   :=EnteredKReaer;
      Fields[107].AsString  :=XEnteredKReaer;
      Fields[108].AsBoolean := UsePhytoRetention;

      Fields[109].AsFloat   := BasePercentEmbed;
      Fields[110].AsString  := XBasePercentEmbed ;

      Fields[111].AsFloat   := Altitude;
      Fields[112].AsString  := XAltitude ;


    end; {with SR}
 Post;
 end; {with SV_IO_Form.Table1}

   ResetFile(DbDir,DbName);
   Except

   SiteRecord_to_Dbase:=False;
   If FileExists(DBDir+'\'+AbbrString(DbName,'.')+'.DB') then
                                            ResetFile(DbDir,DbName);
   End; {try Except}
   Table1.Free;
End;    {SiteRecord_to_Dbase}
{-----------------------------------------------------------------}

Procedure SiteRec_To_Text;
Begin
 With SR do
  Begin
     Writeln(LF,'SiteName: '+SiteName);
     Writeln(LF,'ECoeffWater: '+FloatToStrF(ECoeffWater,ffgeneral,5,5));
     Writeln(LF,'SiteLength: '+FloatToStrF(SiteLength,ffgeneral,5,5));
     Writeln(LF,'XLength: '+XLength);
     Writeln(LF,'StaticVolume: '+FloatToStrF(StaticVolume,ffgeneral,5,5));
     Writeln(LF,'XVolume: '+XVolume);
     Writeln(LF,'SurfArea: '+FloatToStrF(SurfArea,ffgeneral,5,5)+' -- '+XSurfArea);
     Writeln(LF,'ICZMean: '+FloatToStrF(ICZMean,ffgeneral,5,5));
     Writeln(LF,'XZMean: '+XZMean);
     Writeln(LF,'ZMax: '+FloatToStrF(ZMax,ffgeneral,5,5)+' -- '+XZMax);
     Writeln(LF,'TempMean[Epilimnion]: '+FloatToStrF(TempMean[Epilimnion],ffgeneral,5,5)+' -- '+XTempMean[Epilimnion]);
     Writeln(LF,'TempRange[Epilimnion]: '+FloatToStrF(TempRange[Epilimnion],ffgeneral,5,5)+' -- '+XTempRange[Epilimnion]);
     Writeln(LF,'TempMean[Hypolimnion]: '+FloatToStrF(TempMean[Hypolimnion],ffgeneral,5,5)+' -- '+XTempMean[Hypolimnion]);
     Writeln(LF,'TempRange[Hypolimnion]: '+FloatToStrF(TempRange[Hypolimnion],ffgeneral,5,5)+' -- '+XTempRange[Hypolimnion]);
     Writeln(LF,'Latitude: '+FloatToStrF(Latitude,ffgeneral,5,5)+' -- '+XLatitude);
     Writeln(LF,'Altitude: '+FloatToStrF(Altitude,ffgeneral,5,5)+' -- '+XAltitude);
     Writeln(LF,'LightMean: '+FloatToStrF(LightMean,ffgeneral,5,5)+' -- '+XLightMean);
     Writeln(LF,'LightRange: '+FloatToStrF(LightRange,ffgeneral,5,5)+' -- '+XLightRange);
     Writeln(LF,'AlkCaCO3: '+FloatToStrF(AlkCaCO3,ffgeneral,5,5)+' -- '+XAlkCaCO3);
     Writeln(LF,'HardCaCO3: '+FloatToStrF(HardCaCO3,ffgeneral,5,5)+' -- '+XHardCaCO3);
     Writeln(LF,'SiteComment: '+SiteComment);
     Writeln(LF,'SO4ConC: '+FloatToStrF(SO4ConC,ffgeneral,5,5)+' -- '+XSO4ConC);
     Writeln(LF,'TotalDissSolids: '+FloatToStrF(TotalDissSolids,ffgeneral,5,5)+' -- '+XTotalDissSolids);
     Writeln(LF,'StreamType: '+StreamType);
     Writeln(LF,'Channel_Slope: '+FloatToStrF(Channel_Slope,ffgeneral,5,5)+' -- '+XChannel_Slope);
     Writeln(LF,'Max_Chan_Depth: '+FloatToStrF(Max_Chan_Depth,ffgeneral,5,5)+' -- '+XMax_Chan_Depth);
     Writeln(LF,'SedDepth: '+FloatToStrF(SedDepth,ffgeneral,5,5)+' -- '+XSedDepth);
     Writeln(LF,'EnclWallArea: '+FloatToStrF(EnclWallArea,ffgeneral,5,5)+' -- '+XEnclWallArea);
     Writeln(LF,'MeanEvap: '+FloatToStrF(MeanEvap,ffgeneral,5,5)+' -- '+XMeanEvap);
     Write(LF,'UseEnteredManning: '); If UseEnteredManning then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Writeln(LF,'EnteredManning: '+FloatToStrF(EnteredManning,ffgeneral,5,5));
     Writeln(LF,'XECoeffWater: '+XECoeffWater);
     Writeln(LF,'PctRiffle: '+FloatToStrF(PctRiffle,ffgeneral,5,5)+' -- '+XPctRiffle);
     Writeln(LF,'PctPool: '+FloatToStrF(PctPool,ffgeneral,5,5)+' -- '+XPctPool);
     Write(LF,'UseBathymetry: '); If UseBathymetry then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
     Writeln(LF,'ts_clay: '+FloatToStrF(ts_clay,ffgeneral,5,5)+' -- '+Xts_clay);
     Writeln(LF,'ts_silt: '+FloatToStrF(ts_silt,ffgeneral,5,5)+' -- '+Xts_silt);
     Writeln(LF,'tdep_clay: '+FloatToStrF(tdep_clay,ffgeneral,5,5)+' -- '+Xtdep_clay);
     Writeln(LF,'tdep_silt: '+FloatToStrF(tdep_silt,ffgeneral,5,5)+' -- '+Xtdep_silt);
     Writeln(LF,'FallVel_clay: '+FloatToStrF(FallVel_clay,ffgeneral,5,5)+' -- '+XFallVel_clay);
     Writeln(LF,'FallVel_silt: '+FloatToStrF(FallVel_silt,ffgeneral,5,5)+' -- '+XFallVel_silt);
     Writeln(LF,'SiteWidth: '+FloatToStrF(SiteWidth,ffgeneral,5,5)+' -- '+XSiteWidth);
     Writeln(LF,'{m2}: amplitude '+FloatToStrF(amplitude1 ,ffgeneral,5,5)+'; k '+FloatToStrF( k1 ,ffgeneral,5,5));
     Writeln(LF,'{s2}: amplitude '+FloatToStrF(amplitude2 ,ffgeneral,5,5)+'; k '+FloatToStrF( k2 ,ffgeneral,5,5));
     Writeln(LF,'{n2}: amplitude '+FloatToStrF(amplitude3 ,ffgeneral,5,5)+'; k '+FloatToStrF( k3 ,ffgeneral,5,5));
     Writeln(LF,'{k1}: amplitude '+FloatToStrF(amplitude4 ,ffgeneral,5,5)+'; k '+FloatToStrF( k4 ,ffgeneral,5,5));
     Writeln(LF,'{o1}: amplitude '+FloatToStrF(amplitude5 ,ffgeneral,5,5)+'; k '+FloatToStrF( k5 ,ffgeneral,5,5));
     Writeln(LF,'{SSA}:amplitude '+FloatToStrF(amplitude6 ,ffgeneral,5,5)+'; k '+FloatToStrF( k6 ,ffgeneral,5,5));
     Writeln(LF,'{SA}: amplitude '+FloatToStrF(amplitude7 ,ffgeneral,5,5)+'; k '+FloatToStrF( k7 ,ffgeneral,5,5));
     Writeln(LF,'{P1}: amplitude '+FloatToStrF(amplitude8 ,ffgeneral,5,5)+'; k '+FloatToStrF( k8 ,ffgeneral,5,5));
     Writeln(LF,'Min_Vol_Frac: '+FloatToStrF(Min_Vol_Frac,ffgeneral,5,5)+' -- '+XMin_Vol_Frac);
     Writeln(LF,'WaterShedArea: '+FloatToStrF(WaterShedArea,ffgeneral,5,5)+' -- '+XWaterShedArea);
     If UsePhytoRetention then
       Begin
         Writeln(LF,'Use enhanced phytoplankton / zooplankton retention algorithm:');
         Write  (LF,'   EnterTotalLength: '); If EnterTotalLength then Writeln(LF,'TRUE') else Writeln(LF,'FALSE');
         Writeln(LF,'   TotalLength: '+FloatToStrF(TotalLength,ffgeneral,5,5)+' -- '+XTotalLength);
       End;

     Writeln(LF,'ECoeffSed: '+FloatToStrF(ECoeffSed,ffgeneral,5,5)+' -- '+XECoeffSed);
     Writeln(LF,'ECoeffDOM: '+FloatToStrF(ECoeffDOM,ffgeneral,5,5)+' -- '+XECoeffDOM);
     Writeln(LF,'ECoeffPOM: '+FloatToStrF(ECoeffPOM,ffgeneral,5,5)+' -- '+XECoeffPOM);

     If UseCovar then Writeln(LF,'Using default reaeration (Covar)')
                 else Writeln(LF,'Entered KReaer '+FloatToStrF(EnteredKReaer,ffgeneral,5,5)+' -- '+XEnteredKReaer);

     Writeln(LF,'Baseline Percent Embedded: '+FloatToStrF(BasePercentEmbed,ffgeneral,5,5)+' -- '+XBasePercentEmbed);
  End;
End;

{-----------------------------------------------------------------}

Function DBase_To_ReminRecord(DbDir,DbName,DbEntry: ShortString; Var RR: ReminRecord):Boolean;

Begin
      Table1 := TTable.Create(nil);

  Try
      DBase_To_ReminRecord:=GetEntry(DbDir,DbName,DbEntry,False,False);

   With Table1 do begin

   With RR do begin
      RemRecName    := Fields[0].AsString;
      DecayMax_Lab  := Fields[1].AsFloat;
      XDecayMax_Lab := Fields[2].AsString;
      Q10_NotUsed   := Fields[3].AsFloat;
      XQ10          := Fields[4].AsString;
      TOpt          := Fields[5].AsFloat;
      XTOpt         := Fields[6].AsString;
      TMax          := Fields[7].AsFloat;
      XTMax         := Fields[8].AsString;
      TRef_NotUsed  := Fields[09].AsFloat;
      XTRef         := Fields[10].AsString;
      pHMin         := Fields[11].AsFloat;
      XpHMin        := Fields[12].AsString;
      pHMax         := Fields[13].AsFloat;
      XpHMax        := Fields[14].AsString;
      P2OrgLab      := Fields[15].AsFloat;
      XP2OrgLab     := Fields[16].AsString;
      N2OrgLab      := Fields[17].AsFloat;
      XN2OrgLab     := Fields[18].AsString;
      O2Biomass     := Fields[19].AsFloat;
      XO2Biomass    := Fields[20].AsString;
      O2N           := Fields[21].AsFloat;
      XO2N          := Fields[22].AsString;
      KSed          := Fields[23].AsFloat;
      XKsed         := Fields[24].AsString;
      PSedRelease_NotUsed   := Fields[25].AsFloat;
      XPSedrelease  := Fields[26].AsString;
      NSedRelease_NotUsed   := Fields[27].AsFloat;
      XNSedRelease  := Fields[28].AsString;
      DecayMax_Refr := Fields[29].AsFloat;
      XDecayMax_Refr:= Fields[30].AsString;

      KSedTemp      := Fields[31].AsFloat;
      XKSedTemp     := Fields[32].AsString;
      KSedSalinity  := Fields[33].AsFloat;
      XKSedSalinity := Fields[34].AsString;

      P2Org_Refr     := Fields[35].AsFloat;
      XP2Org_Refr    := Fields[36].AsString;
      N2Org_Refr     := Fields[37].AsFloat;
      XN2Org_Refr    := Fields[38].AsString;
      Wet2DryPRefr  := Fields[39].AsFloat;
      XWet2DryPRefr := Fields[40].AsString;
      Wet2DryPLab   := Fields[41].AsFloat;
      Xet2DryPLab   := Fields[42].AsString;
      Wet2DrySRefr  := Fields[43].AsFloat;
      XWet2DrySRefr := Fields[44].AsString;
      Wet2DrySLab   := Fields[45].AsFloat;
      XWet2DrySLab  := Fields[46].AsString;
      N2OrgDissLab :=  Fields[47].AsFloat;
      XN2OrgDissLab := Fields[48].AsString;
      P2OrgDissLab  := Fields[49].AsFloat;
      XP2OrgDissLab := Fields[50].AsString;
      N2OrgDissRefr := Fields[51].AsFloat;
      XN2OrgDissRefr:= Fields[52].AsString;
      P2OrgDissRefr := Fields[53].AsFloat;
      XP2OrgDissRefr:= Fields[54].AsString;
      KD_P_Calcite  := Fields[55].AsFloat;
      XKD_P_Calcite := Fields[56].AsString;

      NotUsed  := Fields[57].AsFloat;
      XNotUsed := Fields[58].AsString;

      KNitri        := Fields[59].AsFloat;
      XKNitri       := Fields[60].AsString;
      KDenitri_Bot  := Fields[61].AsFloat;
      XKDenitri_Bot := Fields[62].AsString;
      KDenitri_Wat  := Fields[63].AsFloat;
      XKDenitri_Wat := Fields[64].AsString;

 end; {with RR}
 end; {with SV_IO_Form.Table1}


   ResetFile(DbDir,DbName);
   Except

   DBase_To_ReminRecord:=False;
   If FileExists(DBDir+'\'+AbbrString(DbName,'.')+'.DB') then
                                             ResetFile(DbDir,DbName);
   End; {try Except}
      Table1.Free;
End;    {DBase_To_ReminRecord}
{-----------------------------------------------------------------}

Function ReminRecord_To_Dbase(DbDir,DbName,DbEntry: ShortString; RR: ReminRecord):Boolean;

Begin
      Table1 := TTable.Create(nil);

   Try
      ReminRecord_to_Dbase:=GetEntry(DbDir,DbName,DbEntry,True,False);

   With Table1 do begin
      Edit;

   With RR do begin
      Fields[0].AsString  := RemRecName;
      Fields[1].AsFloat   := DecayMax_Lab;
      Fields[2].AsString  := XDecayMax_Lab;
      Fields[3].AsFloat   := Q10_NotUsed;
      Fields[4].AsString  := XQ10;
      Fields[5].AsFloat   := TOpt;
      Fields[6].AsString  := XTOpt;
      Fields[7].AsFloat   := TMax;
      Fields[8].AsString  := XTMax;
      Fields[09].AsFloat  := TRef_NotUsed;
      Fields[10].AsString := XTRef;
      Fields[11].AsFloat  := pHMin;
      Fields[12].AsString := XpHMin;
      Fields[13].AsFloat  := pHMax;
      Fields[14].AsString := XpHMax;
      Fields[15].AsFloat  := P2OrgLab;
      Fields[16].AsString := XP2OrgLab;
      Fields[17].AsFloat  := N2OrgLab;
      Fields[18].AsString := XN2OrgLab;
      Fields[19].AsFloat  := O2Biomass;
      Fields[20].AsString := XO2Biomass;
      Fields[21].AsFloat  := O2N;
      Fields[22].AsString := XO2N;
      Fields[23].AsFloat  := KSed;
      Fields[24].AsString := XKsed;
      Fields[25].AsFloat  := PSedRelease_NotUsed;
      Fields[26].AsString := XPSedrelease;
      Fields[27].AsFloat  := NSedRelease_NotUsed;
      Fields[28].AsString := XNSedRelease;
      Fields[29].AsFloat  := DecayMax_Refr;
      Fields[30].AsString := XDecayMax_Refr;

      Fields[31].AsFloat  :=KSedTemp;
      Fields[32].AsString :=XKSedTemp;
      Fields[33].AsFloat  :=KSedSalinity;
      Fields[34].AsString :=XKSedSalinity;

      Fields[35].AsFloat  := P2Org_Refr;
      Fields[36].AsString := XP2Org_Refr;
      Fields[37].AsFloat  := N2Org_Refr;
      Fields[38].AsString := XN2Org_Refr;
      Fields[39].AsFloat  :=Wet2DryPRefr;
      Fields[40].AsString :=XWet2DryPRefr;
      Fields[41].AsFloat  :=Wet2DryPLab;
      Fields[42].AsString :=Xet2DryPLab;
      Fields[43].AsFloat  :=Wet2DrySRefr;
      Fields[44].AsString :=XWet2DrySRefr;
      Fields[45].AsFloat  :=Wet2DrySLab;
      Fields[46].AsString :=XWet2DrySLab;
      Fields[47].AsFloat :=N2OrgDissLab;
      Fields[48].AsString :=XN2OrgDissLab;
      Fields[49].AsFloat :=P2OrgDissLab;
      Fields[50].AsString :=XP2OrgDissLab;
      Fields[51].AsFloat :=N2OrgDissRefr;
      Fields[52].AsString :=XN2OrgDissRefr;
      Fields[53].AsFloat :=P2OrgDissRefr;
      Fields[54].AsString :=XP2OrgDissRefr;
      Fields[55].AsFloat := KD_P_Calcite;
      Fields[56].AsString :=XKD_P_Calcite;

      Fields[57].AsFloat  := NotUsed ;
      Fields[58].AsString := XNotUsed;

      Fields[59].AsFloat  := KNitri    ;
      Fields[60].AsString := XKNitri   ;
      Fields[61].AsFloat  := KDenitri_Bot;
      Fields[62].AsString := XKDenitri_Bot;
      Fields[63].AsFloat  := KDenitri_Wat;
      Fields[64].AsString := XKDenitri_Wat;

 end; {with RR}
  Post;
 end; {with SV_IO_Form.Table1}


   ResetFile(DbDir,DbName);
   Except

   ReminRecord_to_Dbase:=False;
   If FileExists(DBDir+'\'+AbbrString(DbName,'.')+'.DB') then
                                            ResetFile(DbDir,DbName);
   End; {try Except}
   Table1.Free;
End;    {ReminRecord_to_Dbase}
{-----------------------------------------------------------------}
Procedure ReminRec_To_Text    (Var LF: TextFile; RR: ReminRecord);
Begin
 With RR do
  Begin
     Writeln(LF,'RemRecName: '+RemRecName);
     Writeln(LF,'DecayMax_Lab: '+FloatToStrF(DecayMax_Lab,ffgeneral,5,5)+' -- '+XDecayMax_Lab);
     Writeln(LF,'TOpt: '+FloatToStrF(TOpt,ffgeneral,5,5)+' -- '+XTOpt);
     Writeln(LF,'TMax: '+FloatToStrF(TMax,ffgeneral,5,5)+' -- '+XTMax);
     Writeln(LF,'pHMin: '+FloatToStrF(pHMin,ffgeneral,5,5)+' -- '+XpHMin);
     Writeln(LF,'pHMax: '+FloatToStrF(pHMax,ffgeneral,5,5)+' -- '+XpHMax);
     Writeln(LF,'P2OrgLab: '+FloatToStrF(P2OrgLab,ffgeneral,5,5));
     Writeln(LF,'N2OrgLab: '+FloatToStrF(N2OrgLab,ffgeneral,5,5));
     Writeln(LF,'PlaceHolder: '+FloatToStrF(PlaceHolder,ffgeneral,5,5));
     Writeln(LF,'XP2OrgLab: '+XP2OrgLab);
     Writeln(LF,'XN2OrgLab: '+XN2OrgLab);
     Writeln(LF,'O2Biomass: '+FloatToStrF(O2Biomass,ffgeneral,5,5)+' -- '+XO2Biomass);
     Writeln(LF,'O2N: '+FloatToStrF(O2N,ffgeneral,5,5)+' -- '+XO2N);
     Writeln(LF,'KSed: '+FloatToStrF(KSed,ffgeneral,5,5)+' -- '+XKSed);
     Writeln(LF,'DecayMax_Refr: '+FloatToStrF(DecayMax_Refr,ffgeneral,5,5)+' -- '+XDecayMax_Refr);
     Writeln(LF,'KSedTemp: '+FloatToStrF(KSedTemp,ffgeneral,5,5)+' -- '+XKSedTemp);
     Writeln(LF,'KSedSalinity: '+FloatToStrF(KSedSalinity,ffgeneral,5,5)+' -- '+XKSedSalinity);
     Writeln(LF,'P2Org_Refr: '+FloatToStrF(P2Org_Refr,ffgeneral,5,5)+' -- '+XP2Org_Refr);
     Writeln(LF,'N2Org_Refr: '+FloatToStrF(N2Org_Refr,ffgeneral,5,5)+' -- '+XN2Org_Refr);
     Writeln(LF,'Wet2DryPRefr: '+FloatToStrF(Wet2DryPRefr,ffgeneral,5,5)+' -- '+XWet2DryPRefr);
     Writeln(LF,'Wet2DryPLab: '+FloatToStrF(Wet2DryPLab,ffgeneral,5,5));
     Writeln(LF,'Xet2DryPLab: '+Xet2DryPLab);
     Writeln(LF,'Wet2DrySRefr: '+FloatToStrF(Wet2DrySRefr,ffgeneral,5,5)+' -- '+XWet2DrySRefr);
     Writeln(LF,'Wet2DrySLab: '+FloatToStrF(Wet2DrySLab,ffgeneral,5,5)+' -- '+XWet2DrySLab);
     Writeln(LF,'N2OrgDissLab: '+FloatToStrF(N2OrgDissLab,ffgeneral,5,5)+' -- '+XN2OrgDissLab);
     Writeln(LF,'P2OrgDissLab: '+FloatToStrF(P2OrgDissLab,ffgeneral,5,5)+' -- '+XP2OrgDissLab);
     Writeln(LF,'N2OrgDissRefr: '+FloatToStrF(N2OrgDissRefr,ffgeneral,5,5)+' -- '+XN2OrgDissRefr);
     Writeln(LF,'P2OrgDissRefr: '+FloatToStrF(P2OrgDissRefr,ffgeneral,5,5)+' -- '+XP2OrgDissRefr);
     Writeln(LF,'KD_P_Calcite: '+FloatToStrF(KD_P_Calcite,ffgeneral,5,5)+' -- '+XKD_P_Calcite);
     Writeln(LF,'BOD5_CBODu Conv. Factor no longer used');
     Writeln(LF,'KNitri: '+FloatToStrF(KNitri,ffgeneral,5,5)+' -- '+XKNitri);
     Writeln(LF,'KDenitri_Bot: '+FloatToStrF(KDenitri_Bot,ffgeneral,5,5)+' -- '+XKDenitri_Bot);
     Writeln(LF,'KDenitri_Wat: '+FloatToStrF(KDenitri_Wat,ffgeneral,5,5)+' -- '+XKDenitri_Wat);
  End;
End;
{-----------------------------------------------------------------}


Function DBase_To_PlantRecord(DbDir,DbName,DbEntry: ShortString; Num: Integer; Var PR: PlantRecord):Boolean;

Begin
      Table1 := TTable.Create(nil);

   Try
   If DBEntry = ''
      then DBase_To_PlantRecord:=GetEntryByNum(DbDir,DbName,Num)
      else DBase_To_PlantRecord:=GetEntry(DbDir,DbName,DbEntry,False,False);


   With Table1 do begin
     With PR do begin
      PlantName           :=FieldbyName('PlantName').AsString;
      EnteredLightSat     :=Fields[1].AsFloat;
      XLightSat           :=Fields[2].AsString;
      KPO4                :=Fields[3].AsFloat;
      XKPO4               :=Fields[4].AsString;
      KN                  :=Fields[5].AsFloat;  {n half Sat}
      XKN                 :=Fields[6].AsString;
      KCarbon             :=Fields[7].AsFloat;
      XKCarbon            :=Fields[8].AsString;
      Q10                 :=Fields[9].AsFloat;
      XQ10                :=Fields[10].AsString;
      TOpt                :=Fields[11].AsFloat;
      XTOpt               :=Fields[12].AsString;
      TMax                :=Fields[13].AsFloat;
      XTMax               :=Fields[14].AsString;
      TRef                :=Fields[15].AsFloat;
      XTRef               :=Fields[16].AsString;
      PMax                :=Fields[17].AsFloat;
      XPMax               :=Fields[18].AsString;
      KResp               :=Fields[19].AsFloat;
      XKResp              :=Fields[20].AsString;
      KMort               :=Fields[21].AsFloat;
      XKMort              :=Fields[22].AsString;
      EMort               :=Fields[23].AsFloat;
      XEMort              :=Fields[24].AsString;
      KSed                :=Fields[25].AsFloat;
      XKSed               :=Fields[26].AsString;
      ESed                :=Fields[27].AsFloat;
      XESed               :=Fields[28].AsString;
      P2OrgInit           :=Fields[29].AsFloat;
      XP2Org              :=Fields[30].AsString;
      N2OrgInit           :=Fields[31].AsFloat;
      XN2Org              :=Fields[32].AsString;
      ECoeffPhyto         :=Fields[33].AsFloat;
      XECoeffPhyto        :=Fields[34].AsString;
      CarryCapac          :=Fields[35].AsFloat;
      XCarryCapac         :=Fields[36].AsString;
      Red_Still_Water     :=Fields[37].AsFloat;
      XRed_Still_Water    :=Fields[38].AsString;
      PlantType           :=Fields[39].AsString;
      ToxicityRecord      :=Fields[40].AsString;
      Macrophyte_Type     :=Fields[41].AsString;
      Macro_Drift         :=Fields[42].AsFloat;
      Taxonomic_Type      :=Fields[43].AsString;

      PrefRiffle          := Fields[44].AsFloat;
      XPrefRiffle         := Fields[45].AsString;
      PrefPool            := Fields[46].AsFloat;
      XPrefPool           := Fields[47].AsString;
      FCrit               := Fields[48].AsFloat;
      XFCrit              := Fields[49].AsString;
      Macro_VelMax        := Fields[50].AsFloat;
      XVelMax             := Fields[51].AsString;
      KSedTemp            := Fields[52].AsFloat;
      XKSedTemp           := Fields[53].Asstring;
      KSedSalinity        := Fields[54].AsFloat;
      XKSedSalinity       := Fields[55].Asstring;
      Salmin_Phot         := Fields[56].AsFloat;
      SalMax_Phot         := Fields[57].AsFloat;
      Salcoeff1_Phot      := Fields[58].AsFloat;
      Salcoeff2_Phot      := Fields[59].AsFloat;
      XSalinity_Phot      := Fields[60].Asstring;
      Salmin_Mort         := Fields[61].AsFloat;
      SalMax_Mort         := Fields[62].AsFloat;
      Salcoeff1_Mort      := Fields[63].AsFloat;
      Salcoeff2_Mort      := Fields[64].AsFloat;
      XSalinity_Mort      := Fields[65].Asstring;

      Wet2Dry             :=Fields[66].AsFloat;
      XWet2Dry            :=Fields[67].AsString;
      Resp20              :=Fields[68].AsFloat;
      XResp20             :=Fields[69].AsString;
      PctSloughed         :=Fields[70].AsFloat;
      XPctSloughed        :=Fields[71].AsString;
      UseAdaptiveLight    :=Fields[72].AsBoolean;
      MaxLightSat         :=Fields[73].AsFloat;
      XMaxLightSat        :=Fields[74].AsString;
      MinLightSat         :=Fields[75].AsFloat;
      XMinLightSat        :=Fields[76].AsString;
      ScientificName      :=Fields[77].AsString;
      PlantFracLipid      := Fields[78].AsFloat ;
      XPlantFracLipid     := Fields[79].AsString ;

      SurfaceFloating     := Fields[80].AsBoolean ;

      NHalfSatInternal    := Fields[81].AsFloat ;
      XNHalfSatInternal   := Fields[82].AsString ;
      PHalfSatInternal    := Fields[83].AsFloat ;
      XPHalfSatInternal   := Fields[84].AsString ;
      MaxNUptake          := Fields[85].AsFloat ;
      XMaxNUptake         := Fields[86].AsString ;
      MaxPUptake          := Fields[87].AsFloat ;
      XMaxPUptake         := Fields[88].AsString ;
      Min_N_Ratio         := Fields[89].AsFloat ;
      XMin_N_Ratio        := Fields[90].AsString ;
      Min_P_Ratio         := Fields[91].AsFloat ;
      XMin_P_Ratio        := Fields[92].AsString ;

 end; {with PR}
 end; {with SV_IO_Form.Table1}

   ResetFile(DbDir,DbName);
   Except

   DBase_To_PlantRecord:=False;
   If FileExists(DBDir+'\'+AbbrString(DbName,'.')+'.DB') then
                                           ResetFile(DbDir,DbName);
   End; {try Except}
   Table1.Free;
End;    {DBase_To_PlantRecord}
{-----------------------------------------------------------------}

Function PlantRecord_To_Dbase(DbDir,DbName,DbEntry: ShortString; PR: PlantRecord):Boolean;

Begin
      Table1 := TTable.Create(nil);

   Try
      PlantRecord_to_Dbase:=GetEntry(DbDir,DbName,DbEntry,True,False);

   With Table1 do begin

   Edit;

   With PR do
    begin
      FieldbyName('PlantName').AsString:=PlantName;
      Fields[1].AsFloat:=EnteredLightSat;
      Fields[2].AsString:=XLightSat;
      Fields[3].AsFloat:=KPO4;
      Fields[4].AsString:=XKPO4;
      Fields[5].AsFloat:=KN;
      Fields[6].AsString:=XKN;
      Fields[7].AsFloat:=KCarbon;
      Fields[8].AsString:=XKCarbon;
      Fields[9].AsFloat:=Q10;
      Fields[10].AsString:=XQ10;
      Fields[11].AsFloat:=TOpt;
      Fields[12].AsString:=XTOpt;
      Fields[13].AsFloat:=TMax;
      Fields[14].AsString:=XTMax;
      Fields[15].AsFloat:=TRef;
      Fields[16].AsString:=XTRef;
      Fields[17].AsFloat:=PMax;
      Fields[18].AsString:=XPMax;
      Fields[19].AsFloat:=KResp;
      Fields[20].AsString:=XKResp;
      Fields[21].AsFloat:= KMort;
      Fields[22].AsString:=XKMort;
      Fields[23].AsFloat:=EMort;
      Fields[24].AsString:=XEMort;
      Fields[25].AsFloat:=KSed;
      Fields[26].AsString:=XKSed;
      Fields[27].AsFloat:=ESed;
      Fields[28].AsString:=XESed;
      Fields[29].AsFloat:=P2OrgInit;
      Fields[30].AsString:=XP2Org;
      Fields[31].AsFloat:=N2OrgInit;
      Fields[32].AsString:=XN2Org;
      Fields[33].AsFloat:=ECoeffPhyto;
      Fields[34].AsString:=XECoeffPhyto;
      Fields[35].AsFloat:= CarryCapac;
      Fields[36].AsString:=XCarryCapac;
      Fields[37].AsFloat:=Red_Still_Water;
      Fields[38].AsString:=XRed_Still_Water;
      Fields[39].AsString:=PlantType;
      Fields[40].AsString:=ToxicityRecord;
      Fields[41].AsString :=Macrophyte_Type;
      Fields[42].AsFloat :=Macro_Drift;
      Fields[43].AsString :=Taxonomic_Type;

      Fields[44].AsFloat :=PrefRiffle;
      Fields[45].AsString :=XPrefRiffle;
      Fields[46].AsFloat :=PrefPool;
      Fields[47].AsString :=XPrefPool;
      Fields[48].AsFloat :=FCrit;
      Fields[49].AsString :=XFCrit;
      Fields[50].AsFloat :=Macro_VelMax;
      Fields[51].AsString :=XVelMax;
      Fields[52].AsFloat :=KSedTemp;
      Fields[53].Asstring :=XKSedTemp;
      Fields[54].AsFloat :=KSedSalinity;
      Fields[55].Asstring :=XKSedSalinity;
      Fields[56].AsFloat :=Salmin_Phot;
      Fields[57].AsFloat :=SalMax_Phot;
      Fields[58].AsFloat :=Salcoeff1_Phot;
      Fields[59].AsFloat :=Salcoeff2_Phot;
      Fields[60].Asstring :=XSalinity_Phot;
      Fields[61].AsFloat :=Salmin_Mort;
      Fields[62].AsFloat :=SalMax_Mort;
      Fields[63].AsFloat :=Salcoeff1_Mort;
      Fields[64].AsFloat :=Salcoeff2_Mort;
      Fields[65].Asstring :=XSalinity_Mort;

      Fields[66].AsFloat  := Wet2Dry;
      Fields[67].AsString := XWet2Dry;
      Fields[68].AsFloat  := Resp20;
      Fields[69].AsString := XResp20;
      Fields[70].AsFloat  := PctSloughed;
      Fields[71].AsString  := XPctSloughed;
      Fields[72].AsBoolean := UseAdaptiveLight;
      Fields[73].AsFloat  := MaxLightSat;
      Fields[74].AsString := XMaxLightSat;
      Fields[75].AsFloat  := MinLightSat;
      Fields[76].AsString := XMinLightSat;
      Fields[77].AsString := ScientificName;
      Fields[78].AsFloat   := PlantFracLipid;
      Fields[79].AsString  := XPlantFracLipid;
      Fields[80].AsBoolean := SurfaceFloating;

      Fields[81].AsFloat   := NHalfSatInternal;
      Fields[82].AsString  := XNHalfSatInternal;
      Fields[83].AsFloat   := PHalfSatInternal;
      Fields[84].AsString  := XPHalfSatInternal;
      Fields[85].AsFloat   := MaxNUptake;
      Fields[86].AsString  := XMaxNUptake;
      Fields[87].AsFloat   := MaxPUptake;
      Fields[88].AsString  := XMaxPUptake;
      Fields[89].AsFloat   := Min_N_Ratio;
      Fields[90].AsString  := XMin_N_Ratio;
      Fields[91].AsFloat   := Min_P_Ratio;
      Fields[92].AsString  := XMin_P_Ratio;
    end; {with PR}
  Post;
 end;{with SV_IO_Form.Table1}


   ResetFile(DbDir,DbName);
   Except

   PlantRecord_to_Dbase:=False;
   If FileExists(DBDir+'\'+AbbrString(DbName,'.')+'.DB') then
                                             ResetFile(DbDir,DbName);
   End; {try Except}
   Table1.Free;
End;    {PlantRecord_to_Dbase}
{-----------------------------------------------------------------}

Function AnimalRecord_to_2_2_Dbase(DbDir,DbName,DbEntry: ShortString; AR: ZooRecord):Boolean;

Var ShortFileN,CorrectDbName: ShortString;
    KeyStr: String;
    ChangeName: Boolean;

Begin
   Table1 := TTable.Create(nil);

   Try
    {Rename File}
    ShortFileN := AbbrString(DBName,'.');
    CorrectDbName:=ShortFileN+'.db';
    ChangeName:= Not (CorrectDbName=DbName);
    If ChangeName then
           if not RenameFile(DBDir+'\'+DBName,DBDir+'\'+CorrectDbName)
                  then Begin
                         MessageDlg('File Rename Error.',MtError,[mbOK],0);
                         AnimalRecord_to_2_2_Dbase := false;
                         Exit;
                       End;

  With Table1 do
    Begin
     TableName    := CorrectDbName;
     DatabaseName := DBDir;
     Active       := True;
     KeyStr := DBEntry;
    End;


     If not (Table1.FindKey([KeyStr]))
       then with Table1 do
         Begin
           Insert;
           Fields[0].AsString := KeyStr;
           Post;
         End;

   With Table1 do begin

      Edit;

   With AR do begin
      Fieldbyname('AnimalName').AsString:=AnimalName;
      Fields[1].AsFloat   := FHalfSat;
      Fields[2].AsString  := XFHalfSat;
      Fields[3].AsFloat   := CMax;
      Fields[4].AsString  := XCMax;
      Fields[5].AsFloat   := BMin;
      Fields[6].AsString  := XBMin;
      Fields[7].AsFloat   := Q10;
      Fields[8].AsString  := XQ10;
      Fields[9].AsFloat   := TOpt;
      Fields[10].AsString := XTOpt;
      Fields[11].AsFloat  := TMax;
      Fields[12].AsString := XTMax;
      Fields[13].AsFloat  := TRef;
      Fields[14].AsString := XTRef;
      Fields[15].AsFloat  := EndogResp;
      Fields[16].AsString := XEndogResp;
      Fields[17].AsFloat  := KResp;
      Fields[18].AsString := XKResp;
      Fields[19].AsFloat  := KExcr;
      Fields[20].AsString := XKExcr;
      Fields[21].AsFloat  := PctGamete;
      Fields[22].AsString := XPctGamete;
      Fields[23].AsFloat  := GMort;
      Fields[24].AsString := XGMort;
      Fields[25].AsFloat  := KMort;
      Fields[26].AsString := XKMort;
      Fields[27].AsFloat  := KCap;
      Fields[28].AsString := XKCap;
      Fields[29].AsFloat  := MeanWeight;
      Fields[30].AsString := XMeanWeight;
      Fields[31].AsFloat  := FishFracLipid;
      Fields[32].AsString := XFishFracLipid;
      Fields[33].AsString := ToxicityRecord;
      Fields[34].AsFloat  := LifeSpan;
      Fields[35].AsString := XLifeSpan;
      Fields[36].AsString := Animal_Type;
      Fields[37].asFloat  := AveDrift;
      Fields[38].asString := XAveDrift;
      Fields[39].asBoolean:= AutoSpawn;
      Fields[40].asDateTime := SpawnDate1;
      Fields[41].asDateTime := SpawnDate2;
      Fields[42].asDateTime := SpawnDate3;
      Fields[43].asString := XSpawnDate;
      Fields[44].asBoolean:= UnlimitedSpawning;
      Fields[45].asInteger:= SpawnLimit;
      Fields[46].asBoolean:= UseAllom_C;
      Fields[47].asFloat  := CA;
      Fields[48].asFloat  := CB;
      Fields[49].asBoolean:= UseAllom_R;
      Fields[50].asFloat  := RA;
      Fields[51].asFloat  := RB;
      Fields[52].asBoolean:= UseSet1;
      Fields[53].asFloat  := RQ;
      Fields[54].asFloat  := RTO;
      Fields[55].asFloat  := RTM;
      Fields[56].asFloat  := RTL;
      Fields[57].asFloat  := RK1;
      Fields[58].asFloat  := RK4;
      Fields[59].asFloat  := ACT;
      Fields[60].asFloat  := BACT;
      Fields[61].asFloat  := FracInWaterCol;
      Fields[62].asString := XFracInWaterCol;
      Fields[63].asString := Guild_Taxa;
      Fields[64].asFloat  := PrefRiffle;
      Fields[65].asString := XPrefRiffle;
      Fields[66].asFloat  := PrefPool;
      Fields[67].asString := XPrefPool;
      Fields[68].asFloat  := VelMax;
      Fields[69].asString := XVelMax;
      Fields[70].asString := XAllomConsumpt;
      Fields[71].asString := XAllomResp;
      Fields[72].asFloat  :=P2Org;
      Fields[73].asString :=XP2Org;
      Fields[74].asFloat  :=N2Org;
      Fields[75].asString :=XN2Org;
      Fields[76].AsFloat  :=Wet2Dry;
      Fields[77].AsString :=XWet2Dry;

   end; {with AR}
   Post;
   end; {with SV_IO_Form.Table1}

   ResetFile(DbDir,DbName);
   AnimalRecord_to_2_2_Dbase := True;

   Except
   AnimalRecord_to_2_2_Dbase:=False;
   If FileExists(DBDir+'\'+AbbrString(DbName,'.')+'.DB') then
                                             ResetFile(DbDir,DbName);

   End; {Try Except}
   Table1.Free;

End;    {AnimalRecord_to_Dbase}

{-----------------------------------------------------------------}

Function PlantRecord_To_2_2_Dbase(DbDir,DbName,DbEntry: ShortString; PR: PlantRecord):Boolean;
Var ShortFileN,CorrectDbName: ShortString;
    KeyStr: String;
    ChangeName: Boolean;

Begin
   Table1 := TTable.Create(nil);

   Try
    {Rename File}
    ShortFileN := AbbrString(DBName,'.');
    CorrectDbName:=ShortFileN+'.db';
    ChangeName:= Not (CorrectDbName=DbName);
    If ChangeName then
           if not RenameFile(DBDir+'\'+DBName,DBDir+'\'+CorrectDbName)
                  then Begin
                         PlantRecord_To_2_2_Dbase := False;
                         MessageDlg('File Rename Error.',MtError,[mbOK],0);
                         Exit;
                       End;

  With Table1 do
    Begin
     TableName    := CorrectDbName;
     DatabaseName := DBDir;
     Active       := True;
     KeyStr := DBEntry;
    End;


     If not (Table1.FindKey([KeyStr]))
       then with Table1 do
         Begin
           Insert;
           Fields[0].AsString := KeyStr;
           Post;
         End;

   With Table1 do begin

   Edit;

   With PR do
    begin
      FieldbyName('PlantName').AsString:=PlantName;
      Fields[1].AsFloat:=EnteredLightSat;
      Fields[2].AsString:=XLightSat;
      Fields[3].AsFloat:=KPO4;
      Fields[4].AsString:=XKPO4;
      Fields[5].AsFloat:=KN;
      Fields[6].AsString:=XKN;
      Fields[7].AsFloat:=KCarbon;
      Fields[8].AsString:=XKCarbon;
      Fields[9].AsFloat:=Q10;
      Fields[10].AsString:=XQ10;
      Fields[11].AsFloat:=TOpt;
      Fields[12].AsString:=XTOpt;
      Fields[13].AsFloat:=TMax;
      Fields[14].AsString:=XTMax;
      Fields[15].AsFloat:=TRef;
      Fields[16].AsString:=XTRef;
      Fields[17].AsFloat:=PMax;
      Fields[18].AsString:=XPMax;
      Fields[19].AsFloat:=KResp;
      Fields[20].AsString:=XKResp;
      Fields[21].AsFloat:= KMort;
      Fields[22].AsString:=XKMort;
      Fields[23].AsFloat:=EMort;
      Fields[24].AsString:=XEMort;
      Fields[25].AsFloat:=KSed;
      Fields[26].AsString:=XKSed;
      Fields[27].AsFloat:=ESed;
      Fields[28].AsString := XESed;
      Fields[29].AsFloat  := P2OrgInit;
      Fields[30].AsString := XP2Org;
      Fields[31].AsFloat  := N2OrgInit;
      Fields[32].AsString := XN2Org;
      Fields[33].AsFloat  := ECoeffPhyto;
      Fields[34].AsString := XECoeffPhyto;
      Fields[35].AsFloat  := CarryCapac;
      Fields[36].AsString := XCarryCapac;
      Fields[37].AsFloat  := Red_Still_Water;
      Fields[38].AsString := XRed_Still_Water;
      Fields[39].AsString := PlantType;
      Fields[40].AsString := ToxicityRecord;
      Fields[42].AsString := Taxonomic_Type;
      Fields[43].AsFloat  := PrefRiffle;
      Fields[44].AsString := XPrefRiffle;
      Fields[45].AsFloat  := PrefPool;
      Fields[46].AsString := XPrefPool;
      Fields[47].AsFloat  := FCrit;
      Fields[48].AsString := XFCrit;
      Fields[49].AsFloat  := Macro_VelMax;
      Fields[50].AsString := XVelMax;
      Fields[51].AsFloat  :=Wet2Dry;
      Fields[52].AsString :=XWet2Dry;

      Fields[55].AsFloat  :=Resp20;
      Fields[56].AsString :=XResp20;
    end; {with PR}
  Post;
 end;{with SV_IO_Form.Table1}

   PlantRecord_to_2_2_Dbase := True;
   ResetFile(DbDir,DbName);
   Except

   PlantRecord_to_2_2_Dbase:=False;
   If FileExists(DBDir+'\'+AbbrString(DbName,'.')+'.DB') then
                                             ResetFile(DbDir,DbName);

   End; {Try Except}
   Table1.Free;

End;    {PlantRecord_to_Dbase}
{-----------------------------------------------------------------}
Procedure PlantRec_To_Text(Var LF: TextFile; PR: PlantRecord);
Begin
 With PR do
  Begin
     Writeln(LF,'PlantName: '+PlantName);
     Writeln(LF,'ScientificName: '+ScientificName);
     Writeln(LF,'PlantType: '+PlantType);
     If SurfaceFloating then Writeln(LF,' -- Surface Floating');
     Writeln(LF,'ToxicityRecord: '+ToxicityRecord);
     Writeln(LF,'EnteredLightSat: '+FloatToStrF(EnteredLightSat,ffgeneral,5,5)+' -- '+XLightSat);
     Writeln(LF,'KPO4: '+FloatToStrF(KPO4,ffgeneral,5,5)+' -- '+XKPO4);
     Writeln(LF,'KN: '+FloatToStrF(KN,ffgeneral,5,5)+' -- '+XKN);
     Writeln(LF,'KCarbon: '+FloatToStrF(KCarbon,ffgeneral,5,5)+' -- '+XKCarbon);
     Writeln(LF,'Q10: '+FloatToStrF(Q10,ffgeneral,5,5)+' -- '+XQ10);
     Writeln(LF,'TOpt: '+FloatToStrF(TOpt,ffgeneral,5,5)+' -- '+XTOpt);
     Writeln(LF,'TMax: '+FloatToStrF(TMax,ffgeneral,5,5)+' -- '+XTMax);
     Writeln(LF,'TRef: '+FloatToStrF(TRef,ffgeneral,5,5)+' -- '+XTRef);
     Writeln(LF,'PMax: '+FloatToStrF(PMax,ffgeneral,5,5)+' -- '+XPMax);
     Writeln(LF,'KResp: '+FloatToStrF(KResp,ffgeneral,5,5)+' -- '+XKResp);
     Writeln(LF,'KMort: '+FloatToStrF(KMort,ffgeneral,5,5)+' -- '+XKMort);
     Writeln(LF,'EMort: '+FloatToStrF(EMort,ffgeneral,5,5)+' -- '+XEMort);
     Writeln(LF,'KSed: '+FloatToStrF(KSed,ffgeneral,5,5)+' -- '+XKSed);
     Writeln(LF,'ESed: '+FloatToStrF(ESed,ffgeneral,5,5)+' -- '+XESed);
     Writeln(LF,'P2OrgInit: '+FloatToStrF(P2OrgInit,ffgeneral,5,5)+' -- '+XP2Org);
     Writeln(LF,'N2OrgInit: '+FloatToStrF(N2OrgInit,ffgeneral,5,5)+' -- '+XN2Org);
     Writeln(LF,'ECoeffPhyto: '+FloatToStrF(ECoeffPhyto,ffgeneral,5,5)+' -- '+XECoeffPhyto);
     Writeln(LF,'CarryCapac: '+FloatToStrF(CarryCapac,ffgeneral,5,5)+' -- '+XCarryCapac);
     Writeln(LF,'Red_Still_Water: '+FloatToStrF(Red_Still_Water,ffgeneral,5,5)+' -- '+XRed_Still_Water);
     Writeln(LF,'Macrophyte_Type: '+Macrophyte_Type);
     Writeln(LF,'Macro_Drift: '+FloatToStrF(Macro_Drift,ffgeneral,5,5));
     Writeln(LF,'Taxonomic_Type: '+Taxonomic_Type);
     Writeln(LF,'PrefRiffle: '+FloatToStrF(PrefRiffle,ffgeneral,5,5)+' -- '+XPrefRiffle);
     Writeln(LF,'PrefPool: '+FloatToStrF(PrefPool,ffgeneral,5,5)+' -- '+XPrefPool);
     Writeln(LF,'FCrit: '+FloatToStrF(FCrit,ffgeneral,5,5)+' -- '+XFCrit);
     Writeln(LF,'Macro_VelMax: '+FloatToStrF(Macro_VelMax,ffgeneral,5,5));
     Writeln(LF,'XVelMax: '+XVelMax);
     Writeln(LF,'KSedTemp: '+FloatToStrF(KSedTemp,ffgeneral,5,5)+' -- '+XKSedTemp);
     Writeln(LF,'KSedSalinity: '+FloatToStrF(KSedSalinity,ffgeneral,5,5)+' -- '+XKSedSalinity);
     Writeln(LF,'Salcoeff2_Phot: '+FloatToStrF(Salcoeff2_Phot,ffgeneral,5,5));
     Writeln(LF,'XSalinity_Phot: '+XSalinity_Phot);
     Writeln(LF,'Salcoeff2_Mort: '+FloatToStrF(Salcoeff2_Mort,ffgeneral,5,5));
     Writeln(LF,'XSalinity_Mort: '+XSalinity_Mort);
     Writeln(LF,'Wet2Dry: '+FloatToStrF(Wet2Dry,ffgeneral,5,5)+' -- '+XWet2Dry);
     Writeln(LF,'Frac Lipid (wet): '+FloatToStrF(PlantFracLipid,ffgeneral,5,5)+' -- '+XPlantFracLipid);
     Writeln(LF,'Resp20: '+FloatToStrF(Resp20,ffgeneral,5,5)+' -- '+XResp20);
     Writeln(LF,'PctSloughed: '+FloatToStrF(PctSloughed,ffgeneral,5,5)+' -- '+XPctSloughed);
     If UseAdaptiveLight then Writeln(LF,' -- Use Adaptive Light for this Plant -- ');
     Writeln(LF,'MaxLightSat: '+FloatToStrF(MaxLightSat,ffgeneral,5,5)+' -- '+XMaxLightSat);
     Writeln(LF,'MinLightSat: '+FloatToStrF(MinLightSat,ffgeneral,5,5)+' -- '+XMinLightSat);

     Writeln(LF,'NHalfSatInternal: '+FloatToStrF(NHalfSatInternal,ffgeneral,5,5)+' -- '+XNHalfSatInternal);
     Writeln(LF,'PHalfSatInternal: '+FloatToStrF(PHalfSatInternal,ffgeneral,5,5)+' -- '+XPHalfSatInternal);
     Writeln(LF,'MaxNUptake: '+FloatToStrF(MaxNUptake,ffgeneral,5,5)+' -- '+XMaxNUptake);
     Writeln(LF,'MaxPUptake: '+FloatToStrF(MaxPUptake,ffgeneral,5,5)+' -- '+XMaxPUptake);
     Writeln(LF,'Min_N_Ratio: '+FloatToStrF(Min_N_Ratio,ffgeneral,5,5)+' -- '+XMin_N_Ratio);
     Writeln(LF,'Min_P_Ratio: '+FloatToStrF(Min_P_Ratio,ffgeneral,5,5)+' -- '+XMin_P_Ratio);
  End;
End;

end.

