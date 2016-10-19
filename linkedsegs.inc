//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Constructor TLinkedSegs.Init(ASystemName : ShortString);
Var Loop: T_SVType;
Begin
   Filename   := 'LINKED1.ALS';
   DirName    := Studies_Dir;
   LastRun    := -1;
   ControlRun := -1;
   SystemName := ASystemName;

   TemplateSeg := nil;
   SegmentColl := TCollection.Init(5,3);

   For Loop := FirstOrgTxTyp to LastOrgTxTyp do
               Chemical[Loop] := nil;

   LUnc_Dir:= ''; LUnc_File:=''; LUnc_Ext:='';

   Links := TCollection.Init(5,3);
   Notes := '`';

   LastChange := -99;
   TimeLoaded := -99;
   SimsRunning := 0;     

   Upper_Cascade_Coll := nil;
   Lower_Cascade_Coll := nil;
   Feedback_Coll := nil;
End;

Destructor TLinkedSegs.Destroy;
Var Loop: T_SVType;
Begin
  If TemplateSeg <> nil then TemplateSeg.Destroy;

  SegmentColl.Destroy;

  For Loop := FirstOrgTxTyp to LastOrgTxTyp do
      If Chemical[Loop]<>nil then Chemical[Loop].Destroy;

  If Links<>nil then Links.Destroy;
End;
{----------------------------------------------------------------------------}
Function  TLinkedSegs.SegIndexByID(ID: SegIDString): Integer;
Var Loop: Integer;
Begin
  {Get the Index of the Segment in the Collection}
  SegIndexByID:=-1;
  For Loop := 0 to SegmentColl.Count-1 do
    If TAQUATOXSegment(SegmentColl.At(Loop)).SegNumber= ID
      then SegIndexByID := Loop;

End;
{----------------------------------------------------------------------------}
Function  TLinkedSegs.SegmentByID(ID: SegIDString) : TAQUATOXSegment;
Var i: Integer;
Begin
  i := SegIndexByID(ID);
  If i=-1 then SegmentByID := nil
          else SegmentByID := SegmentColl.At(i);
End;
{----------------------------------------------------------------------------}

Procedure TLinkedSegs.SaveToFile(Img: TImage);
Var FileStream: TWriteCachedFileStream;
    PC_FileN:  String;
    WriteMap:  Boolean;
Begin
  PC_FileN:=DirName+FileName;

  FileStream:=TWriteCachedFileStream.Create(PC_FileN,fmCreate);
  StoreLS(True,TStream(FileStream),True,True);

  If Img = nil
    then WriteMap := False
    else WriteMap := not Img.Picture.Bitmap.empty;

  FileStream.Write(WriteMap,Sizeof(WriteMap));
  If WriteMap then Img.Picture.Bitmap.SaveToStream(FileStream);

  FileStream.Destroy;
End;


Procedure TLinkedSegs.StoreLS(IsTemp: Boolean; var st: Tstream; StoreRes,StoreDist: Boolean);
Var VersionWrite: String[10];
    PAQTS: TAQUATOXSegment;
    PLK: TSegmentLink;
    i: Integer;
    Loop2: T_SVTYpe;
Begin
   TeaseScreen:=True;
   VersionWrite:=VersionStr;
   st.Write(VersionWrite,Sizeof(VersionWrite));

   St.Write(FileName, Sizeof(FileName));
   St.Write(Dirname, Sizeof(Dirname));
   St.Write(LastRun, Sizeof(LastRun));
   St.Write(ControlRun, Sizeof(ControlRun));
   St.Write(SystemName, Sizeof(SystemName));

   TemplateSeg.SV.StoreResults := StoreRes;
   TemplateSeg.SV.StoreDistribs := StoreDist;
   TemplateSeg.Store(True, St);

   SegmentColl.Store(False, St);
   For i:=0 to SegmentColl.Count-1 do
      begin
        PAQTS:=SegmentColl.At(i);
        PAQTS.SV.StoreResults := StoreRes;
        PAQTS.SV.StoreDistribs := StoreDist;
        PAQTS.Store(False, St);
      end;

   St.Write(Chemical, Sizeof(Chemical));
   For Loop2 := FirstOrgTxTyp to LastOrgTxTyp do
     If Chemical[Loop2]<>nil then Chemical[Loop2].Store(True,St);

   Links.Store(True, St);
   For i:=0 to Links.Count-1 do
      begin
        PLK:=Links.At(i);
        PLK.Store(True, St);
      end;

   St.Write(Notes, Sizeof(Notes));
   St.Write(Setup, Sizeof(Setup));
End;

Constructor TLinkedSegs.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double; LoadResults,LoadDistribs: Boolean);
Var PAQTS: TAQUATOXSegment;
    PLK: TSegmentLink;
    i: Integer;
    Loop2: T_SVTYpe;
    ErrorMsg: String;
    VersionJunk: String[10];
    OldFileN: String[40];
Begin
   If ReadVersionNum < 3.585
     then Begin
            st.Read(OldFileN,Sizeof(OldFileN));
            FileName := OldFileN;
          End
     else st.Read(FileName,Sizeof(FileName));

   St.Read(Dirname, Sizeof(Dirname));
   St.Read(LastRun, Sizeof(LastRun));
   St.Read(ControlRun, Sizeof(ControlRun));
   St.Read(SystemName, Sizeof(SystemName));

   St.Read(VersionJunk, Sizeof(VersionJunk));
   TemplateSeg := TAQUATOXSegment.Load(True,True,St,ReadVersionNum,LoadResults,LoadDistribs);

   SegmentColl := TCollection.Load(False,St,ReadVersionNum);
   TemplateSeg.AllOtherSegs := SegmentColl;
   For i:=0 to SegmentColl.Count-1 do
      begin
        St.Read(VersionJunk, Sizeof(VersionJunk));
        PAQTS:=TAQUATOXSegment.Load(True,False,St,ReadVersionNum,LoadResults,LoadDistribs);
        PAQTS.ShowTemplate(TemplateSeg,ErrorMsg,True,False);
        If ErrorMsg<>'' then
           Raise EAquatoxError.Create('AQUATOX unexpectedly Got Error: '+ErrorMsg+
                                      ' while linking a study to the template.');
        PAQTS.SV.Update_Distributions;
        SegmentColl.AtPut(i,PAQTS);
      end;

   St.Read(Chemical, Sizeof(Chemical));
   For Loop2 := FirstOrgTxTyp to LastOrgTxTyp do
     If Chemical[Loop2]<>nil then
       Begin
         Chemical[Loop2]:=nil;
         Chemical[Loop2]:=TChemical.Load(True,St,ReadVersionNum);
       End;

   Links:= TCollection.Load(True,St,ReadVersionNum);
   For i:=0 to Links.Count-1 do
      begin
        PLK:=TSegmentLink.Load(True,St,ReadVersionNum);
        Links.AtPut(i,PLK);
      end;

   St.Read(Notes, Sizeof(Notes));
   St.Read(Setup, Sizeof(Setup));

   LUnc_Dir:= ''; LUnc_File:=''; LUnc_Ext:='';

   Upper_Cascade_Coll := nil;
   Lower_Cascade_Coll := nil;
   Feedback_Coll := nil;
End;


Procedure TLinkedSegs.Update_Distributions;
Var i: Integer;
    WorkingStudy: TAQUATOXSegment;

Begin
  For i:=-1  to SegmentColl.Count-1 do
    Begin
      If i=-1 then WorkingStudy := TemplateSeg
              else WorkingStudy := SegmentColl.At(i);
      WorkingStudy.SV.Update_Distributions;        
    End;

End;

Procedure TLinkedSegs.ClearAllResults(ClearMode: Integer);
Var i: Integer;
    VLoop: VerticalSegments;
    WorkingStudy: TAQUATOXSegment;
Begin
  For i:=-1  to SegmentColl.Count-1 do
    Begin
      If i=-1 then WorkingStudy := TemplateSeg
              else WorkingStudy := SegmentColl.At(i);
      For VLoop:=Epilimnion to Hypolimnion do
         Begin
          If (ClearMode = 0) or (ClearMode = 2) then
            Begin
              WorkingStudy.SV.Results[Vloop].Destroy;
              WorkingStudy.SV.Results[Vloop] := TResultsCollection.Init;
              WorkingStudy.LastRun      := -1;
              LastRun := -1;
            End;

          If ClearMode<2 then
            Begin
              WorkingStudy.SV.ControlResults[Vloop].Destroy;
              WorkingStudy.SV.ControlResults[Vloop] := TResultsCollection.Init;
              WorkingStudy.ControlRun   := -1;
              ControlRun := -1;
            End;
         End;
    End;
End;


Procedure TLinkedSegs.Add_Internal_Nutrients;
var i: Integer;
    WorkingStudy: TAQUATOXSegment;
    IsTempl: Boolean;
Begin
    For i := -1 to SegmentColl.Count-1 do
      Begin
        IsTempl := (i=-1);
        If IsTempl then WorkingStudy := TemplateSeg
                   else WorkingStudy := SegmentColl.At(i);
        WorkingStudy.Add_Internal_Nutrients
      End;
End;

Procedure TLinkedSegs.Remove_Internal_Nutrients;
var i: Integer;
    WorkingStudy: TAQUATOXSegment;
    IsTempl: Boolean;
Begin
    For i := -1 to SegmentColl.Count-1 do
      Begin
        IsTempl := (i=-1);
        If IsTempl then WorkingStudy := TemplateSeg
                   else WorkingStudy := SegmentColl.At(i);
        WorkingStudy.Remove_Internal_Nutrients;
      End;
End;

{**************************************************************************************}
{*                                                                                    *}
{*                       Function TLinkedSegs.Verify_Runnable                         *}
{*                                                                                    *}
{*            Verify a study is runnable and setup segment/link structure             *}
{*                                                                                    *}
{**************************************************************************************}

Function TLinkedSegs.Verify_Runnable(ShowMsg: Boolean): Boolean;
Var WorkingStudy: TAQUATOXSegment;
    i: Integer;
    BaseRateName, ExtString: String;
    ASegID: String;

    {-----------------------------------------------------------------}
    Function SetupStratification: Boolean;  {Ensure validity of stratification setup and
                                             setup strat variables for process code to use}

    Var PartnerLoop,SegLoop: Integer;
        AQTS: TAQUATOXSegment;
        Partner : TStates;
        FoundPartner: Boolean;
        ErrorFound  : Boolean;
        ThisSegStr, OtherSegStr: String;
        PSLnk: TSegmentLink;
        {-----------------------------------------------------------------------------}
        Function Verify_Potential_Partner: Boolean;
        Begin
          Verify_Potential_Partner := False;
          If Partner.IsStrat then
           If Partner.IsEpilimnion <> AQTS.SV.IsEpilimnion then
            Begin
              Verify_Potential_Partner := True;
              AQTS.SV.Stratified     := True;
              Partner.Stratified      := True;

              if AQTS.SV.ThermLink = nil then
                 Begin
                    AQTS.SV.ThermLink := PSLnk;  {Setting up a pointer to the "Thermocline" linkage}
                    Partner.ThermLink  := PSLnk;
                 End
              else
                 Begin
                    AQTS.SV.ThermLink2 := PSLnk;  {Setting up a pointer to the 2nd "Thermocline" linkage}
                    Partner.ThermLink2  := PSLnk;
                 End;



              If AQTS.SV.IsEpilimnion  {setup variables for process code}
                then Begin
                       AQTS.SV.Hyposegment := Partner;
                       Partner.EpiSegment := AQTS.SV;

                       AQTS.SV.VSeg := Epilimnion;
                       Partner.VSeg := Hypolimnion;
                     End
                else Begin
                       AQTS.SV.Episegment := Partner;
                       Partner.HypoSegment := AQTS.SV;
                       AQTS.SV.VSeg := Hypolimnion;
                       Partner.VSeg := Epilimnion;
                     End;
            End;
        End;
        {-----------------------------------------------------------------------------}

    Begin
      ErrorFound := False;
      TemplateSeg.SV.StudyProgDlg := StudyProgress;

      For SegLoop := 0 to SegmentColl.Count-1 do  {Go to every segment to see if its part of a strat-pair}
        Begin
          AQTS := SegmentColl.At(SegLoop);
          AQTS.SV.VSeg:=Epilimnion;
          AQTS.SV.Stratified := False;
          AQTS.SV.ThermLink := nil;
          AQTS.SV.ThermLink2 := nil;
          AQTS.SV.StudyProgDlg := StudyProgress;

          With AQTS.SV do
          If IsStrat then
            Begin
              FoundPartner := False;
              If IsEpilimnion then ThisSegStr  := 'Epilimnion'
                              else ThisSegStr  := 'Hypolimnion';
              If IsEpilimnion then OtherSegStr := 'Hypolimnion'
                              else OtherSegStr := 'Epilimnion';

              For PartnerLoop := 0 to In_FB_Links.Count-1 do
                Begin
                  PSLnk := In_FB_Links.At(PartnerLoop);
                  Partner := PSLnk.FromPStates;
                  If Verify_Potential_Partner then FoundPartner := True;
                End;

              For PartnerLoop := 0 to Out_FB_Links.Count-1 do
                Begin
                  PSLnk := Out_FB_Links.At(PartnerLoop);
                  Partner := PSLnk.ToPStates;
                  If Verify_Potential_Partner then FoundPartner := True;
                End;

              If Not FoundPartner then
                Begin
                  ErrorFound := True;
                  MessageDlg2('Error:  Segment '+AQTS.SegNumber+' ('+ThisSegStr+' Segment) is not'+
                             ' linked to '+OtherSegStr+' segment.',mterror,[mbok],0);
                End;
            End;
        End;


      SetupStratification := Not ErrorFound;
    End;
    {-----------------------------------------------------------------}
    Function SetupLinks: Boolean;
    Var SegLoop, LnkLoop: Integer;
        AQTS: TAQUATOXSegment;
        PLnk: TSegmentLink;
    Begin
      SetupLinks := True;

      For SegLoop := 0 to SegmentColl.Count-1 do  {Clear Links from TStates Object}
        Begin
          AQTS := SegmentColl.At(SegLoop);
          If AQTS.SV.In_FB_Links<>nil then AQTS.SV.In_FB_Links.SavePointers;
          If AQTS.SV.Out_FB_Links<>nil then AQTS.SV.Out_FB_Links.SavePointers;
          AQTS.SV.In_FB_Links := TCollection.Init(2,2);
          AQTS.SV.Out_FB_Links := TCollection.Init(2,2);

          If AQTS.SV.In_Cs_Links<>nil then AQTS.SV.In_Cs_Links.SavePointers;
          If AQTS.SV.Out_Cs_Links<>nil then AQTS.SV.Out_Cs_Links.SavePointers;
          AQTS.SV.In_Cs_Links := TCollection.Init(2,2);
          AQTS.SV.Out_Cs_Links := TCollection.Init(2,2);
        End;

      For LnkLoop := 0 to Links.Count-1 do
        Begin
          PLnk := Links.At(LnkLoop);

          If (PLnk.CascadeWash<>nil) then PLnk.CascadeWash.Destroy;
          PLnk.CascadeWash := nil;         {Reset datastructure where cascade washout data are stored}
          PLnk.LastCSPointWritten := -99;  {Init Time variables for writing cascade washout results}

            For SegLoop := 0 to SegmentColl.Count-1 do
              Begin
                AQTS := SegmentColl.At(SegLoop);
                IF AQTS.SegNumber = PLnk.FromID then
                  Begin
                    If PLnk.LinkType = FeedbackLnk
                      then AQTS.SV.Out_FB_Links.Insert(PLnk)
                      else AQTS.SV.Out_Cs_Links.Insert(PLnk);
                    PLnk.FromPStates := AQTS.SV;
                  End;
                IF AQTS.SegNumber = PLnk.ToID then
                  Begin
                    If PLnk.LinkType = FeedbackLnk
                      then AQTS.SV.In_FB_Links.Insert(PLnk)
                      else AQTS.SV.In_Cs_Links.Insert(PLnk);
                    PLnk.ToPStates := AQTS.SV;
                  End;
              End;
        End;

      For SegLoop := 0 to SegmentColl.Count-1 do
        Begin
          AQTS := SegmentColl.At(SegLoop);
          With AQTS.SV do
            Begin
              VolumeUpdated := -1;  {Setting this variable tells program that Volume needs to be updated for washout calc.}

              IsCascadeSeg := (In_FB_Links.Count = 0) and (Out_FB_Links.Count = 0);
              IsTop_Cs_Seg := (In_Cs_Links.Count  = 0) and IsCascadeSeg;

              If (In_FB_Links.Count = 0) and (Out_FB_Links.Count = 0) and
                 (In_Cs_Links.Count = 0) and (Out_Cs_Links.Count = 0) and (SegmentColl.Count>1) then
                Begin
                 { MessageDlg2('Segment '+AQTS.SegNumber+' is not linked to the system.  Simulation will not execute.',
                             mterror,[mbok],0);
                  SetupLinks := False;
                  Exit; }
                End;
            End;
        End;
    End;
    {-----------------------------------------------------------------}
    Function CategorizeSegments: Boolean;

    Var ErrorFound: Boolean;

    { This function categorizes each segment as an upper cascade segment, a lower cascade segment
      or a feedback segment.  It does this in the following order:

      I. Identify upper cascade segments
      II. Identify and verify feedback segments
      III. Identify lower cascade segments }

      Procedure ID_Upper_Cascade;
      Var SegLoop: Integer;
          AQTS: TAQUATOXSegment;

          {This Sub-Procedure Identifies the upper cascade segments in the following manner

             A.) Find segments with no incoming links and no outgoing feedback links.
                 1. Mark these segments as cascade segments and upper cascade segments, add to
             B.) Recursively move down out_cs_links
                 1. If no in or out fb_links then Mark these segments as above.}

          Procedure Found_Upper_Cascade(UC: TStates);
          Var SLoop: Integer;
              TS: TAQUATOXSegment;

          Begin
            UC.IsCascadeSeg := True;
            UC.IsUpperCS    := True;

            For SLoop := 0 to SegmentColl.Count-1 do  {Find AQUATOXSegment associated with UC}
              Begin
                TS := SegmentColl.At(SLoop);
                If (TS.SV = UC) then
                  Upper_Cascade_Coll.Insert(TS);      {insert proper study into collection}
              End;
          End;  {Found_Upper_Cascade}

          Procedure Move_Down_Cascade(TestSeg: TStates);  {Recursively move down Out_CS_Links}
          Var PLnk: TSegmentLink;
              LnkLoop: Integer;
          Begin
            With TestSeg do
              Begin
                If IsCascadeSeg then exit;             {already found this one so move on}

                If (In_FB_Links.Count>0) or
                   (Out_FB_Links.Count>0) then exit;  {not a cascade segment}

                Found_Upper_Cascade(TestSeg);          {mark as an upper cascade segment}

                For LnkLoop := 0 to Out_CS_Links.Count-1 do  {recursively test links below this one}
                  Begin
                    PLnk := Out_CS_Links.At(LnkLoop);
                    Move_Down_Cascade(PLnk.ToPStates);
                  End;
              End;
          End;  {Move_Down_Cascade}

      Begin  {ID_Upper_Cascade}
        If Upper_Cascade_Coll <> nil then Upper_Cascade_Coll.SavePointers; {Clear collection}
        Upper_Cascade_Coll := TCollection.Init(4,4);                           {Setup collection}

        For SegLoop := 0 to SegmentColl.Count-1 do  {Reset Cascade Link Tracking Variables}
          Begin
            AQTS := SegmentColl.At(SegLoop);
            AQTS.SV.IsCascadeSeg := False;
            AQTS.SV.IsUpperCS := False;
            AQTS.SV.CS_Executed := False;
          End;

        For SegLoop := 0 to SegmentColl.Count-1 do  {Find segments with no incoming links and no outgoing feedback links.}
          Begin
            AQTS := SegmentColl.At(SegLoop);
            With AQTS.SV do
              If (In_FB_Links.Count=0) and
                 (In_CS_Links.Count=0) and
                 (Out_FB_Links.Count=0) then Move_Down_Cascade(AQTS.SV)
          End;
      End;  {ID_Upper_Cascade}

      {----------------------------------------------------------------}

      Procedure ID_Feedback;

      {This Sub-Procedure Identifies the feedback segments in the following manner

        A.) Finds segments with in or out feedback links.
           1. Adds these segments to the feedback_coll
        B.) Ensures all feedback segments are linked together
           1. Loops through feedback_coll and marks linked_fb_seg as false.
           2. Goes to first segment in feedback_Coll
              a.) marks linked_fb_seg as true
              b.) recursively moves up and down fb_segs and marks linked_fb_seg as true
           3. Loops through feedback_coll.  If not linked_fb_Seg then raise an error
        C.) Points all OtherFBSegs pointers (within TAQUATOXSegment) towards Feedback_Coll }

      Var SegLoop: Integer;
          AQTS: TAQUATOXSegment;

          Procedure Test_FB_Links(TestSeg: TStates);  {Recursively test FB_Links}
          Var PLnk: TSegmentLink;
              LnkLoop: Integer;
          Begin
            With TestSeg do
              Begin
                If Linked_FB_Seg then exit;      {already found this one so move on}

                Linked_FB_Seg := True;           {mark this segment as found and linked}

                For LnkLoop := 0 to In_FB_Links.Count-1 do  {recursively test links above this one}
                  Begin
                    PLnk := In_FB_Links.At(LnkLoop);
                    Test_FB_Links(PLnk.FromPStates);
                  End;

                For LnkLoop := 0 to Out_FB_Links.Count-1 do  {recursively test links below this one}
                  Begin
                    PLnk := Out_FB_Links.At(LnkLoop);
                    Test_FB_Links(PLnk.ToPStates);
                  End;
              End;
          End;  {Test_FB_Links}

      Begin
        If Feedback_Coll <> nil then Feedback_Coll.SavePointers; {Clear collection}
        Feedback_Coll := TCollection.Init(4,4);                      {Setup collection}

        For SegLoop := 0 to SegmentColl.Count-1 do  {Add Feedback segments to the collection}
          Begin
            AQTS := SegmentColl.At(SegLoop);
            With AQTS.SV do
              If (In_FB_Links.Count>0) or
                 (Out_FB_Links.Count>0) then
                   Begin
                     Feedback_Coll.Insert(AQTS);
                     AQTS.SV.Linked_FB_Seg := False;
                   End;
          End;

        If Feedback_Coll.Count>0 then
          Begin
            AQTS := Feedback_Coll.At(0);
            Test_FB_Links(AQTS.SV);    {recursively move up and down fb_segs and mark linked_fb_seg as true}

            For SegLoop := 0 to Feedback_Coll.Count-1 do
              Begin
                AQTS := Feedback_Coll.At(SegLoop);
                If not AQTS.SV.Linked_FB_Seg then
                  Begin
                    MessageDlg2('You may not have more than one group of segments linked with Feedback Links.  '+
                               'This study cannot be executed.',mterror,[mbok],0);
                    ErrorFound := True;
                    Break;
                  End
              End;
          End;

        TemplateSeg.OtherFBSegs := Feedback_Coll;
        For SegLoop := 0 to SegmentColl.Count-1 do  {Add Feedback segments to the collection}
          Begin
            AQTS := SegmentColl.At(SegLoop);
            AQTS.OtherFBSegs := Feedback_Coll;
          End;
      End;

      {----------------------------------------------------------------}

      Procedure ID_Lower_Cascade;

      {This Sub-Procedure Identifies the lower cascade segments in the following manner

        A.) Loops through all segments.
        B.) If Segment not in upper_cascade_coll or _feedback_coll then
          1.) Mark as cascade segment
          2.) Add to Lower_Cascade_Coll
        C.) Identify Which of Lower_Cascade_Coll IsTopCSSegment
          1.) By definition, these segments should have incoming cascade links
          2.) If there are no cascade segments above each segment it IsTopCSSegment  }

      Var SegLoop, InnerLoop: Integer;
          AQTS, TestS: TAQUATOXSegment;
          TestLnk: TSegmentLink;
          TestSV: TStates;
          Found: Boolean;

      Begin
        If Lower_Cascade_Coll <> nil then Lower_Cascade_Coll.SavePointers; {Clear collection}
        Lower_Cascade_Coll := TCollection.Init(4,4);                           {Setup collection}

        For SegLoop := 0 to SegmentColl.Count-1 do  {Reset Cascade Link Tracking Variables}
          Begin
            Found := False;
            AQTS := SegmentColl.At(SegLoop);

            For InnerLoop := 0 to Feedback_Coll.Count-1 do
              Begin
                TestS := Feedback_Coll.At(InnerLoop);
                If TestS = AQTS then Found := True;
              End;

            For InnerLoop := 0 to Upper_Cascade_Coll.Count-1 do
              Begin
                TestS := Upper_Cascade_Coll.At(InnerLoop);
                If TestS = AQTS then Found := True;
              End;

            If Not Found then
              Begin
                AQTS.SV.IsCascadeSeg := True;
                AQTS.SV.IsUpperCS := False;
                Lower_Cascade_Coll.Insert(AQTS);
              End;
          End;

        { Identify Which of Lower_Cascade_Coll IsTopCSSegment }
        For SegLoop := 0 to Lower_Cascade_Coll.Count-1 do
          Begin
            AQTS := Lower_Cascade_Coll.At(SegLoop);
            AQTS.SV.IsTop_Cs_Seg := True;
            For InnerLoop := 0 to AQTS.SV.In_Cs_Links.Count-1 do
              Begin
                TestLnk := AQTS.SV.In_Cs_Links.At(InnerLoop);
                TestSV  := TestLnk.FromPStates;
                If TestSV.IsCascadeSeg then AQTS.SV.IsTop_CS_Seg := False;
              End;
          End;
      End;

      {----------------------------------------------------------------}

    Begin
      ErrorFound := False;

      ID_Upper_Cascade;

      ID_Feedback;

      If Not ErrorFound then ID_Lower_Cascade;

      If Not ErrorFound then
        If (Upper_Cascade_Coll.Count > 0) and
           (Lower_Cascade_Coll.Count > 0) and
           (Feedback_Coll.Count = 0) then
             Begin
               MessageDlg2('This linked system is not properly linked together.  '+
                          'This study cannot be executed.',mterror,[mbok],0);
               ErrorFound := True;

             End;

      CategorizeSegments := Not ErrorFound;
    End;  {CategorizeSegments}
    {-----------------------------------------------------------------}
    Procedure Test_Migration;  {Ensures migration is set up in feedback segments only or issues a warning}
    Var i,j: Integer;
        MigrLoop: AllVariables;
        MigrToStudy,WorkingStudy: TAQUATOXSegment;
        PA: TAnimal;
        MigrIndex: Integer;
        MigrID: SegIDString;
        ThisSegWarned: Boolean;

    Begin
      For i:=0 to SegmentColl.Count-1 do
        Begin
          ThisSegWarned := False;
          WorkingStudy := SegmentColl.At(i);
          For MigrLoop := FirstAnimal to Fish2 do 
            Begin
              PA := WorkingStudy.SV.GetStatePointer(MigrLoop,StV,WaterCol);
              If PA<>nil then
                For MigrIndex:=1 to 5 do
                  If (PA.MigrInput[MigrIndex].MM>0) and
                     (PA.MigrInput[MigrIndex].DD>0) and
                     (PA.MigrInput[MigrIndex].FracMigr>0) then
                    Begin
                      If (not WorkingStudy.SV.Linked_FB_Seg)
                        Then
                          Begin
                             If Not ThisSegWarned then
                               If ShowMsg then MessageDlg2('Warning: All Migration from Segment '+WorkingStudy.SegNumber+' will be ignored '
                                 +'as this segment is not feedback-linked to other segments in the study.',mterror,[mbok],0);
                             ThisSegWarned:=True;
                          End
                        Else
                          Begin
                            MigrID := PA.MigrInput[MigrIndex].ToSeg;
                            For j := 0 to SegmentColl.Count-1 do
                              if i<>j then
                                Begin
                                  MigrToStudy := SegmentColl.At(j);
                                  If (MigrToStudy.SegNumber = MigrID) and
                                     not (MigrToStudy.SV.Linked_FB_Seg) then
                                        If ShowMsg then MessageDlg2('Warning: Migration of '+PA.PName^+' in Segment '+WorkingStudy.SegNumber+' is input as going to Segment '
                                                   +MigrID+' which is not feedback-linked to it.  This Migration will be ignored. '
                                                   ,mterror,[mbok],0);
                                End;
                          End; {else}
                    End;
            End;
        End;
    End;
    {-----------------------------------------------------------------}

Var MR:TModalResult;
    PCFileN: array[0..300] of Char;
    TVol: TVolume;
Begin {VERIFY_RUNNABLE}
  Verify_Runnable:=True;
  For i:=0 to SegmentColl.Count-1 do
    Begin
      WorkingStudy := SegmentColl.At(i);
      ASegID := WorkingStudy.SegNumber;
      If not WorkingStudy.Verify_Runnable(WorkingStudy.Control_Is_Running,(i=0) and (ShowMsg)) then
        Begin
          Verify_Runnable:=False;
          Exit;
        End;

      TVol := WorkingStudy.SV.GetStatePointer(Volume,StV,WaterCol);
      If (Links.Count > 0) and (TVol.Calc_Method <> Dynam)
        then Begin
               If WorkingStudy.SV.Location.sitetype=TribInput then  {9/25/2009}
                  TVol.Calc_Method := Dynam
               else
                 Begin
                   If WorkingStudy.SV.Location.sitetype=Estuary
                    then MessageDlg2(Workingstudy.SegNumber+' Error:  A system that is linked together must not include segents of "Estuary" type. '+
                                                            ' Change the site type in the "Site" edit window.',mterror,[mbok],0)
                    else MessageDlg2(Workingstudy.SegNumber+' Error:  A system that is linked together must use the ' +
                               '"Dynamic" water volume calculation method',mterror,[mbok],0);
                   Verify_Runnable := False
                 End;
             End;
    End;

  If Not SetupLinks
     then Verify_Runnable := False
     else If Not CategorizeSegments
        then Verify_Runnable := False
        else If Not SetupStratification
           then Verify_Runnable := False;

  Test_Migration;

  WorkingStudy := TemplateSeg;
  If WorkingStudy.PSetup^.SaveBRates and Result then
    Begin
      WorkingStudy.SV.PRateInfo^.DirNm  := Output_Dir ;
      BaseRateName := FileName;
      Delete(BaseRateName,Length(BaseRateName)-3,4);
      BaseRateName := BaseRateName+'_Rate';
      ExtString := '.db';
      WorkingStudy.SV.PRateInfo^.FileNm := BaseRateName + ExtString;
      With WorkingStudy.SV.PRateInfo^ do
        Begin
          If WorkingStudy.Control_Is_Running then FileNm := 'C_'+FileNm;

          If FileExists(DirNm+BaseRateName+'_S'+ASegID+ExtString) then
             WorkingStudy.PSetup^.SaveBRates := MessageDlg2('Overwrite Rate File : '+FileNm+'?'
                                                        ,mtConfirmation,[mbYes,mbNo],0)= mrYes;
        End;

        If WorkingStudy.PSetup^.SaveBRates then
         With WorkingStudy.SV.PRateInfo^ do
          If not WriteToMemory and FileExists(DirNm+ChangeFileExt(FileNm,'.xls')) then
            Begin
              MR := MessageDlg2('Overwrite Excel File : '+ChangeFileExt(FileNm,'.xls')+'?'
                                                 ,mtConfirmation,[mbYes,mbNo,mbCancel],0);
              If MR=MRCancel then Begin Verify_Runnable := False; Exit; End;

              StrPCopy(PCFileN,DirNm+ChangeFileExt(FileNm,'.xls'));
              If MR=mrYes then
               Begin
                If Not DeleteFile(PCFileN)
                  then
                    Begin
                       MessageDlg2('That Excel file is in use or cannot be deleted.',mterror,[mbOK],0);
                       Verify_Runnable:=False;
                    End;
               End; {MR=MRyes}
            End; {If Not writeparadox}
    End;

End;

{**************************************************************************************}
{*                           Procedure TLinkedSegs.Run                             *}
{**************************************************************************************}

Procedure TLinkedSegs.Run(Unc_Sens_InProg: Boolean);

Var ErrorString: ShortString;
    WorkingStudy: TAQUATOXSegment;
    Abort: Boolean;

    {------------------------------------------------------------------------------}
    Procedure Run_One_Cs_Seg(AQTS: TAQUATOXSegment);
    Var StoreStep: DOuble;
    Begin
      AQTS.SV.CascadeRunning := True;
      With AQTS do with SV do
        Begin
          StudyProgress.LinkModeLabel.Visible := True;
          StudyProgress.LinkModeLabel.Caption := 'Running "Cascade Segment" '+SegNumber;

          SegLog := SegLog + ', '+ SegNumber;

          AllSVs := AQTS.SV;
          SV.PAllSVsColl := @AQTS.AllSVs;

          If not AQTS.SetupForRun then
            Begin
              Abort := True;
              Exit;
            End;

          New(SV.PSegID);    {Setup Pointer back to SegID for output purposes}
          SV.PSegID^ := SegNumber;

          SV.RateFileInit := False;

          StoreStep := PSetup^.StoreStepSize;
          If not PSetup^.StepSizeInDays then StoreStep := StoreStep / 24;
          With PSetup^ do
                      Integrate(FirstDay,LastDay,RelativeError,MINIMUM_STEPSIZE,StoreStep);

          If StudyProgress.ModalResult>0 then Abort := True;
          If Abort then LastRun:=-2
                   else LastRun := Date+Time;
        End;
    End;

    {------------------------------------------------------------------------------}
    Procedure Run_Cascade_Segs(CColl: TCollection);

    { This procedure runs all of the cascade segments passed to it in the collection. }

    { The procedure loops through all of the "top" segments (with no incoming cascade links
      to another cascade segment).

      These segments are run and then the program recursively moves down their cascade links
      to the next lowest segment.  A segment can only be run if all of the cascade links
      above it have been executed.  If not, the program waits until the next chain of execution
      from a different "top" segment reaches that segment to execute it. }

        {-----------------------------------------------------------}
        Procedure ExecuteChain(Seg: TAQUATOXSegment);
        Var LnkLoop, SegLoop: Integer;
            Lnk    : TSegmentLink;
            TestPS : TStates;
            TestAQTS: TAQUATOXSegment;
        Begin
          For LnkLoop := 0 to Seg.SV.In_Cs_Links.Count-1 do
            Begin
              Lnk := Seg.SV.In_Cs_Links.At(LnkLoop);
              TestPS := Lnk.FromPStates;
              If ((TestPS.IsCascadeSeg) and (not TestPS.Cs_Executed)) then Exit;  {Must wait until upper CSegs have executed}
            End;

          Run_One_Cs_Seg(Seg);

          If Abort then Exit;

          Seg.SV.CS_Executed := True;

          {recursively move down this segment's cascade links to its next lowest segment(s)}
          For LnkLoop := 0 to Seg.SV.Out_CS_Links.Count-1 do
            Begin
              Lnk := Seg.SV.Out_CS_Links.At(LnkLoop);
              TestPS := Lnk.ToPStates;
              For SegLoop := 0 to CColl.Count-1 do
                Begin
                  TestAQTS := CColl.At(SegLoop);
                  If TestAQTS.SV = TestPS then ExecuteChain(TestAQTS);
                End;
            End;
        End;
        {-----------------------------------------------------------}

    Var CCLoop       : Integer;
        AQTS         : TAQUATOXSegment;

    Begin  {Procedure Run_Cascade_Segs}
      If CColl.Count=0 then exit;

      For CCLoop := 0 to CColl.Count-1 do
        Begin
          AQTS := CColl.At(CCLoop);
          If AQTS.SV.IsTop_Cs_Seg
            Then ExecuteChain(AQTS);
        End;
    End;   {Procedure Run_Cascade_Segs}
    {------------------------------------------------------------------------------}
    Procedure Run_Feedback_Segments;
    Var i,j: Integer;
        storestep: Double;
    Begin
      StudyProgress.LinkModeLabel.Visible := True;
      StudyProgress.LinkModeLabel.Caption := 'Running "Feedback" Segments Together';

      If TemplateSeg.AllSVs<>nil then TemplateSeg.AllSVs.SavePointers;
      TemplateSeg.AllSVs := TCollection.Init(3,3);  {Clear AllSVs for feedback run}

      If Feedback_Coll.Count=0 then exit;

      For i:=0 to Feedback_Coll.Count-1 do
         Begin
           WorkingStudy := Feedback_Coll.At(i);
           WorkingStudy.SV.CascadeRunning := False;

           If not WorkingStudy.SetupForRun then
             Begin
               Abort := True;
               Exit;
             End;

           New(WorkingStudy.SV.PSegID);    {Setup Pointer back to SegID for output purposes}
           WorkingStudy.SV.PSegID^ := WorkingStudy.SegNumber;

           WorkingStudy.SV.RateFileInit := False;

           For j := 0 to WorkingStudy.SV.Count-1 do
             TemplateSeg.AllSVs.Insert(WorkingStudy.SV.At(j));  {Insert all SVs into AllSVs}
           WorkingStudy.AllSVs := TemplateSeg.AllSVs;
           WorkingStudy.SV.PAllSVsColl := TemplateSeg.AllSVs;
         End;

         TemplateSeg.AllOtherSegs := SegmentColl;

         With TemplateSeg do With PSetup^ do
           Begin
             StoreStep := StoreStepSize;
             If not StepSizeInDays then StoreStep := StoreStep / 24;
             Integrate(FirstDay,LastDay,RelativeError,MINIMUM_STEPSIZE,StoreStep);
           End;

         If StudyProgress.ModalResult>0 then Abort := True;
         For i:=0 to Feedback_Coll.Count-1 do
           Begin
              WorkingStudy := Feedback_Coll.At(i);
              With WorkingStudy do
                If Abort then LastRun:=-2
                         else LastRun := Date+Time;
           End;
      End;
    {------------------------------------------------------------------------------}
var i: integer;
Begin
   Abort := False;

   Try
     Run_Cascade_Segs(Upper_Cascade_Coll);
     If Not Abort then Run_Feedback_Segments;
     If Not Abort then Run_Cascade_Segs(Lower_Cascade_Coll);

   Except
     ErrorString:=Exception(ExceptObject).Message;
     
     TemplateSeg.SV.ProgData.ProgCancel := True;

     TemplateSeg.SV.PMessageStr^ := 'Run-Time Error During Study Run.';
     TemplateSeg.SV.PMessageErr^ := True;
     TemplateSeg.SV.TSMessage;
     TemplateSeg.SV.PMessageStr^ := ErrorString;
     TemplateSeg.SV.TSMessage;
   End;

   If TemplateSeg.Control_Is_Running
     then
       If StudyProgress.ModalResult>0 then ControlRun:=-2
                                      else ControlRun := Date+Time
     else
       If StudyProgress.ModalResult>0 then LastRun:=-2
                                      else LastRun := Date+Time;

   For i := 1 to Length(OpenUncFiles) do
     If TemplateSeg.Unc_File=OpenUncFiles[i-1] then
       OpenUncFiles[i-1] := '';

   If TemplateSeg.PSetup^.SaveBRates then
     For i:=0 to SegmentColl.Count-1 do
     Begin
       WorkingStudy := SegmentColl.At(i);
       With WorkingStudy do
         Begin
           Try
             SV.PSegID := @(WorkingStudy.SegNumber);
             If Not SV.PRateInfo^.WriteToMemory then ConvertRatestoXLS;
           Except
             ErrorString:=Exception(ExceptObject).Message;
             SV.PMessageStr^ := 'Run-Time Error Writing XLS File.';
             SV.PMessageErr^ := True;
             SV.TSMessage;
             SV.PMessageStr^ := ErrorString;
             SV.TSMessage;
           End;
         End;
     End;

   WorkingStudy := TemplateSeg;
   If StudyProgress.ModalResult<=0 then
     Begin
       With WorkingStudy.PUncertainty^ do
         If (Not Unc_Sens_InProg) and (Run_Uncertainty) and (WorkingStudy.RunIterations) then LatinHypercubeRun;
       With WorkingStudy.PUncertainty^ do
          If (Not Unc_Sens_InProg) and (Run_Sensitivity) and (WorkingStudy.RunIterations) then SensitivityRun;
     End;
End;

{---------------------------------------------------------------------------------}


{---------------------------------------------------------------------------------}


{---------------------------------------------------------------------------------}


Procedure TLinkedSegs.LatinHypercubeRun;
Type UResultsTypes = (MinRes,MaxRes,StdRes,MeanRes);
Var DistribLoop  : Integer;
    ResLoop      : UResultsTypes;
    Dist         : TDistribution;
    NumStepsLoop : Integer;
    Uncertainty  : Uncertainty_Setup_Record;
    SegmtLoop    : Integer;
    DrawValue    : Double;
    ResultsHolder: Array[0..MAX_NUMBER_SEGMENTS] of ResultsType;
    ErrorString  : ShortString;
    UncertRes    : Array[0..MAX_NUMBER_SEGMENTS,MinRes..MeanRes] of ResultsType;
    TextOut      : TextFile;
    DateHolder,IterationHolder  : String;
    UserInterrupt: Boolean;
    IterationsDone: Integer;
    ExportTable   : TTable;
    ISDBF         : Boolean;
   {------------------------------------------------------------------}
    Function RandomInt(Top: Integer): Integer;
    {Returns a random integer from 1..Top, using Randnum.Pas}
    Begin
      RandomInt:=Trunc(RandUniform*Top)+1;
    End;
   {------------------------------------------------------------------}
    Function ICDF(Prob:Double): Double;
    Var Res: Double;
    Begin
     Res := Error_Value;
       With Dist do
        Case Disttype of
          Normal       : Res:=ICdfNormal(Prob,Parm[1],Parm[2]);
          Triangular   : Res:=ICdfTriangular(Prob,Parm[2],Parm[3],Parm[1]);
          LogNormal    : Res:=ICdfLogNormal(Prob,exp(Parm[1]),exp(Parm[2]));
          Uniform      : Res:=ICdfuniform(Prob,Parm[1],Parm[2]);
        end;
     If Res = Error_Value then Raise EAQUATOXError.Create('Distribution Error!  ICDF Called with Invalid Parameters.');
     ICDF:=Res;
    End;
   {------------------------------------------------------------------}
    Function CDF(XVal:Double): Double;
    Var Res: Double;
    Begin
     Res := Error_Value;
       With Dist do
         Case Disttype of
               Triangular: Res:=cdfTriangular(XVal,Parm[2],Parm[3],Parm[1]);
               Normal:     Res:=cdfNormal(XVal,Parm[1],Parm[2]);
               LogNormal:  Res:=cdfLogNormal(XVal,exp(Parm[1]),exp(Parm[2]));
               Uniform:    Res:=cdfuniform(XVal,Parm[1],Parm[2]);
          end;
     If Res = Error_Value then Raise EAQUATOXError.Create('Distribution Error!  CDF Called with Invalid Parameters.');
     CDF:=Res;
    End;
   {------------------------------------------------------------------}
    Function CalculateDraw(Interval: Integer): Double;
   {This Procedure calculates the x value of the distribution
    given the interval in [1..NumIterations]}

    Var ProbLow,ProbHigh: Double;
        Width, Where: Double; {Describe Cum Probability Interval}
        RandProb: Double;     {Random Prob within Interval}
    Begin
      ProbHigh:=1.0;
      {Current implementation does not have truncated distributions
       so ProbHigh = 1.0 rather than CDF(Xmax)}

      {Other than Distribution number 1 (LogKOW), Xmin should be zero}
      {triangular and uniform already are subject to Xmin of zero through
       the entry screen}
      ProbLow:=0.0;
      If (Dist.DistNum>1) and (Dist.DistType in [normal,lognormal])
         then ProbLow:=CDF(0);

      {Width is the width of the probability interval, where is the upper
       bounds of the probability interval, RandProb is the random value
       within the probability interval (From LATIN.FOR)}
      Width:=(ProbHigh-ProbLow)/Uncertainty.NumSteps;
      Where:=(Width*Interval) + Problow;
      RandProb:=Where - Width*RandUniform;

      CalculateDraw:=ICDF(RandProb);
    End;

   {------------------------------------------------------------------}
    Procedure FillVariableDraws;
   {This Procedure fills the TCollection associated with each used
    distribution with NumSteps (number of iterations) UncertDraw objects
    each which has the numbered interval and the calculated draw from
    the Function CalculateDraw}

    {In order to calculate the rank order of each parameter's draw
    (ensures non-repeatability and tells which interval to sample from),
    the Procedure calculates a random number for each draw and then ranks
    them.  Optimized Feb 10, 97, JSC}

    Var IterationLoop: Integer;
        FindSlotLoop : Integer;
        LowValue     : Double;
        LowValIndex  : Integer;
        NewDraw      : TUncertDraw;

    Begin
      Dist.Draws:=TCollection.Init(5,5);

      {insert correct number of draws with random number that will
       then be ranked to get the Latin Hypercube Interval}
      For IterationLoop:=1 to Uncertainty.NumSteps do
        begin
          NewDraw:=TUncertDraw.Init(0,RandUniform,0);
          Dist.Draws.Insert(NewDraw);
        end;

      For IterationLoop:=1 to Uncertainty.NumSteps do
        Begin
          LowValue:=99;
          LowValIndex:=0;
          For FindSlotLoop:=0 to Uncertainty.NumSteps-1 do
              If TUncertDraw(Dist.Draws.At(FindSlotLoop)).RandomDraw<=LowValue
                then
                  Begin
                    LowValIndex:=FindSlotLoop;
                    LowValue:=TUncertDraw(Dist.Draws.At(FindSlotLoop)).RandomDraw;
                  End;
          NewDraw:=Dist.Draws.At(LowValIndex);
          NewDraw.RandomDraw:=99;
          NewDraw.IntervalNum:=IterationLoop;
          NewDraw.Value:=CalculateDraw(IterationLoop)
        End;
    End;

   {------------------------------------------------------------------}

    Procedure Accumulate_Uncertainty_Results;
    Var DateLoop,i : Integer;
        ResLp      : UResultsTypes;
        Results1   : TResults;
        UResults1  : Array[MinRes..MeanRes] of TResults;
        DataPoints1: TDataPoint;
        UDataPts1  : Array [MinRes..MeanRes] of TDataPoint;
        IterationValue,UncertValue: Double;
        SegmtLoop    : Integer;

        {------------------------TOP-CREATEDISTS--------------------------}
        Procedure CreateDists;
        Var DL,j       : Integer;
            Res        : UResultsTypes;
            WriteZeros : Boolean;
            PH         : TResHeader;
            PntIndx    : Integer;
            WorkingPATS: TAQUATOXSegment;
        Begin
          WorkingPATS := TAQUATOXSegment(SegmentColl.At(SegmtLoop));
          With WorkingPATS do
           Begin
              For Res:=MinRes to MeanRes do
                 UncertRes[SegmtLoop,Res,Epilimnion] := TResultsCollection.Init;

              For DL:=0 to SV.Results[Epilimnion].Count-1 do
              Begin
                Results1:=SV.Results[Epilimnion].At(DL);

                WriteZeros:=False;

                For Res:=MinRes to MeanRes do
                    UResults1[Res]:=TResults.Init(Results1.Date,True);

                For j:=0 to Results1.DataPoints.Count-1 do   {For each datapoint}
                  Begin
                    DataPoints1:=Results1.DataPoints.At(j);
                    With DataPoints1 do For Res := MinRes to MeanRes do
                      Begin
                        PntIndx := UResults1[Res].DataPoints.Count;
                        If j> SV.Results[Epilimnion].headers.Count-1
                          then PH := nil
                          else PH := SV.Results[Epilimnion].headers.At(j);

                        If WriteZeros then UDataPts1[Res]:=TDataPoint.Init(PH.AllState,PH.SVType,PH.Layer,0,PH.PPB,PH.ToxVar,PH.RateVar,PH.BAFVar,0,UncertRes[SegmtLoop,Res,Epilimnion],SV,False,PntIndx,'') else
                        If Res=StDRes then UDataPts1[Res]:=TDataPoint.Init(PH.AllState,PH.SVType,PH.Layer,State*State,PH.PPB,PH.ToxVar,PH.RateVar,PH.BAFVar,0,UncertRes[SegmtLoop,Res,Epilimnion],SV,False,PntIndx,'')
                                      else UDataPts1[Res]:=TDataPoint.Init(PH.AllState,PH.SVType,PH.Layer,State,PH.PPB,PH.ToxVar,PH.RateVar,PH.BAFVar,0,UncertRes[SegmtLoop,Res,Epilimnion],SV,False,PntIndx,'');
                        UResults1[Res].DataPoints.Insert(UDataPts1[Res]);
                      End;
                   End; {j Loop}

                For Res:=MinRes to MeanRes do
                  UncertRes[SegmtLoop,Res,Epilimnion].Insert(UResults1[Res]);
              End; {DL loop}
            End; {SegmtLoop}
        End;
        {---------------------BOTTOM-CREATEDISTS--------------------------}

    Begin    {Accumulate_Uncertainty_Results}
     If Uncertainty.SaveToCSV then ExportLinkedResults(nil,false,self,nil, LUnc_Dir+LUnc_File+IntToStr(NumStepsLoop)+'.CSV');

     For SegmtLoop:=0 to SegmentColl.Count-1 do
      With TAQUATOXSegment(SegmentColl.At(SegmtLoop)) do
       Begin
        If SV.Results[Epilimnion]=nil then break;
        If SV.Results[Epilimnion].Count<=1 then break;

        If NumStepsLoop=1
          then CreateDists
          else
            Begin
              For DateLoop:=0 to SV.Results[Epilimnion].Count-1 do
              Begin
                Results1:=SV.Results[Epilimnion].At(DateLoop);

                For ResLp:=MinRes to MeanRes do
                  UResults1[ResLp]:=UncertRes[SegmtLoop,ResLp,Epilimnion].At(DateLoop);

                For i:=0 to Results1.DataPoints.Count-1 do   {For every datapoint,}
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
            End; {Else}
       End; {With TAQUATOXSegment do}

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
      FileN := LUnc_Dir+LUnc_File+'.TXT';

      ASSIGNFILE(TextOut,FileN);
      REWRITE(TextOut);
      Writeln(Textout,'---------------------------------------------------------');
      Writeln(TextOut);
      Writeln(TextOut,'        Uncertainty Run for Linked Model "',FileName,'"');
      Writeln(TextOut,'        -- ',SystemName,' --');
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
    Procedure SummarizeDist(SegID: String);
    {Summarizes the distribution for the text output}
    Var ParmLoop: Integer;
        ParmInfo: Array[0..4] of String;
    Begin
    With Dist do
    Begin
      Writeln(TextOut,'Seg'+SegID+': '+Name,':   Point Estimate:'+FloatToStrF(PointEstimate,ffGeneral,4,4));
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
       Var DateLoop,i : Integer;
           ResLp      : UResultsTypes;
           UResults1  : Array[StdRes..MeanRes] of TResults;
           UDataPts1  : Array [StdRes..MeanRes] of TDataPoint;
           Sum,SumSquare: Double;
           InSqrt     : Double;
           n          : Integer;
           SegmtLoop  : Integer;
       Begin
         For SegmtLoop:=0 to SegmentColl.Count-1 do
          With TAQUATOXSegment(SegmentColl.At(SegmtLoop)) do
           Begin
             { Exit routine and reset Directories if no results avail to write }
             If SV.Results[Epilimnion]=nil then exit;
             If SV.Results[Epilimnion].Count<=1 then exit;

             { Loop through dates and write results to DBase }
             For DateLoop:=0 to SV.Results[Epilimnion].Count-1 do
              Begin
                For ResLp:=StdRes to MeanRes do
                  UResults1[ResLp]:=UncertRes[SegmtLoop,ResLp,Epilimnion].At(DateLoop);
                For i:=0 to UResults1[StdRes].DataPoints.Count-1 do   {For every datapoint}
                  begin
                    For ResLp:=StdRes to MeanRes do
                      UDataPts1[ResLp]:=Uresults1[ResLp].DataPoints.At(i);

                    Sum       := UdataPts1[MeanRes].State;
                    SumSquare := UdataPts1[StdRes].State;

                    n:=IterationsDone;

                    If n>0 then UDataPts1[MeanRes].State:=Sum/n;
                    {The standard deviation is calculated using the "nonbiased" or "n-1" method.}
                    If n>1 then InSqrt:= ((n*SumSquare)-(Sum*Sum)) / (n*(n-1))
                           else InSqrt:=0;
                    If InSqrt>0 then UDataPts1[StdRes].State:=Sqrt(InSqrt)
                                else UDataPts1[StdRes].State:=0;
                  end; {i loop}
              End; {Dateloop}
         End; {SegmtLoop}
       End; {PostProcessUncertResults}

   {----------------- Procedure WriteResultsToDBase  ---------------}
   Var OuterLoop, Loop: Integer;
       PointsColl: TResults;
       UncertColl: Array[MinRes..MeanRes] of TResults;
       RsLoop     : UResultsTypes;
       Num_to_Write: Integer;
       WritePoints: Boolean;
       WriteDeterm: Boolean;
       DetermIndex, Prog: Integer;
       NumIteratns: Double;
       SegmtLoop  : Integer;
       DBFQuery   : TQuery;
       PHd        : TResHeader;
       LastString : String;
       IterFieldInc, TopFileLoop     : Integer;
       FileLoop, NumFields, TopIndex : Integer;
       CurrentHeader, BottomHeader   : Integer;
       MaxFields                     : Integer;

          {-------------------------------------------------------------------------------}
          Procedure SetupOutputDatabase(WorkSeg: TAQUATOXSegment; Num: Integer);
          Begin
           With ExportTable do With WorkSeg do
           Begin
             DatabaseName :=Unc_Dir;
             TableName := Unc_File+Unc_Ext;
             If Num>1 then TableName := Unc_File+'_'+InttoStr(Num)+Unc_Ext;

             If      Unc_Ext = '.dbf' then TableType:=ttDBase
             Else If Unc_Ext = '.prn' then TableType:=ttascii
                                      else TableType:=ttParadox;

             {Clear Table Structure}
             Active:=False;
             FieldDefs.Clear;
             IndexDefs.Clear;
             FieldDefs.Add('Date',ftDate,0,False);

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

            Name:=P.HeadStr;

            DName:=Name;
             {If Name<>'Undisplayed' then }
               For i:=1 to 5 do
                 begin
                   If (LUnc_Ext = '.dbf') and  (Pos('Tox.',Name)=1)
                       Then Delete(Name,2,3);  {Pare down name for Dbase Output}
                   If LUnc_Ext = '.dbf'
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
          Begin
            FI:=FieldIndex;
            ExportTable.Fields[FI].AsFloat:=
                  TDataPoint(UncertColl[MinRes].DataPoints.At(DataIndex)).State;
            Inc(FI);
            ExportTable.Fields[FI].AsFloat:=
                  TDataPoint(UncertColl[MeanRes].DataPoints.At(DataIndex)).State;
            Inc(FI);
            ExportTable.Fields[FI].AsFloat:=
                  TDataPoint(UncertColl[StdRes].DataPoints.At(DataIndex)).State;
            Inc(FI);
            ExportTable.Fields[FI].AsFloat:=
                  TDataPoint(UncertColl[MaxRes].DataPoints.At(DataIndex)).State;
            Inc(FI);
            If WriteDeterm then Determ:=TDataPoint(PointsColl.DataPoints.At(DataIndex)).State
                           else Determ:=0;
            ExportTable.Fields[FI].AsFloat:=Determ;
          End;
          {---------------------------------------------------------}

       Begin  {WriteResultstoDBase}
         IsDBF := (LUnc_Ext = '.dbf');
         If IsDBF then MAXFIELDS :=40
                  else MAXFIELDS :=51;

         StudyProgress.ModalResult := mrNone;

         NumIteratns:=0;
         If IterationsDone>0 then PostProcessUncertResults;

         StudyProgress.UncertStatusLabel.Caption := 'Writing Output Database(s)';
         StudyProgress.Gauge1.Progress:=0;
         StudyProgress.DateLabel.Caption:='';
         StudyProgress.Update;

         For SegmtLoop:=0 to SegmentColl.Count-1 do
          With TAQUATOXSegment(SegmentColl.At(SegmtLoop)) do
           Begin

            BottomHeader := 0;
            StudyProgress.DateLabel.Caption:='Seg '+SV.PSegID^;
            StudyProgress.Update;

            NumFields:=SV.Results[Epilimnion].Headers.Count;

            TopFileLoop := (((NumFields-1) div (MAXFIELDS-1))+1);
            For FileLoop:=1 to TopFileLoop do
              Begin
                SetupOutputDatabase(SegmentColl.At(SegmtLoop),FileLoop);
                {If FileLoop=1 then  MessageDlg2(IntToStr(MaxFields-1)+' Results Sets will be written to each database file',mtInformation,[mbOK],0);}

                { Calculate Top Field for this File }
                If NumFields < (FileLoop*(MAXFIELDS-1))
                   then TopIndex :=(NumFields mod (MAXFIELDS-1))
                   else TopIndex := MAXFIELDS-1;

                { Create Appropriate Fields to Export }
                CurrentHeader:=BottomHeader-1;
                For Loop := 1 to TopIndex do
                  Begin
                    Inc(CurrentHeader);
                    PHd := SV.Results[Epilimnion].Headers.At(CurrentHeader);
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
                Num_to_Write := SV.Results[Epilimnion].Count-1;

                For OuterLoop:=0 to Num_to_Write do
                 Begin
                  WritePoints:=True;

                  If WritePoints then
                    Begin
                      WriteDeterm:=True;
                      DetermIndex:=OuterLoop;

                      If DetermIndex<0 then WriteDeterm:=False;
                      If WriteDeterm then PointsColl:=SV.Results[Epilimnion].At(DetermIndex);

                      ExportTable.Append;
                      ExportTable.Fields[0].AsDateTime:=TResults(SV.Results[Epilimnion].At(OuterLoop)).Date;

                      IterFieldInc:=0;

                      For RsLoop:=MinRes to MeanRes do
                         UncertColl[RsLoop]:= UncertRes[SegmtLoop,RsLoop,Epilimnion].At(OuterLoop);

                      CurrentHeader:=BottomHeader-1;
                      For Loop := 1 to TopIndex do
                        Begin
                          Inc(CurrentHeader);
                          PHd := SV.Results[Epilimnion].Headers.At(CurrentHeader);
                          UpdateExportTable(((Loop-1)*5)+1+IterFieldInc,PHD.PointIndex);
                        End;  {For Loop}

                       ExportTable.Post;
                    End; {If WritePoints}

                  Prog := Round ((((FileLoop-1)*Num_To_Write) + OuterLoop) / (Num_To_Write * TopFileLoop) * 100);
                  If Prog <> StudyProgress.Gauge1.Progress then
                    Begin
                      StudyProgress.Gauge1.Progress := Prog;
                      StudyProgress.Update;
                      Application.ProcessMessages;
                      If StudyProgress.ModalResult<>0 then
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

         END; {SegmtLoop}
        StudyProgress.DateLabel.Caption:='';
       End;  {Procedure WriteResultsToDBase}
   {------------------------------------------------------------------}
   Procedure OpenExportTable;
   {Ensures Access To Table Is Error Free}
   Var SegmtLoop: Integer;
   Begin
     For SegmtLoop:=0 to SegmentColl.Count-1 do
      With TAQUATOXSegment(SegmentColl.At(SegmtLoop)) do
        IF (SV.Results[Epilimnion].Count>0) then
         With ExportTable do
          Begin
            Unc_File     := LUnc_File+'_seg'+SV.PSegID^;  {Set filenames for each seg}
            Unc_Ext      := LUnc_Ext;
            Unc_Dir      := LUnc_Dir;

            Active       := False;                         {Setup Table}
            DatabaseName := Unc_Dir;
            TableName    := Unc_File+Unc_Ext;

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
    With TAQUATOXSegment(SegmentColl.At(SegmtLoop)) do
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
  Procedure Sample_ConstLoad;
  {Each iteration, loads the constant load distribution samples into
   dynamic loading variables that the program utilizes}
  Var Stepsholder  : Integer;
      NumTimeSteps : Integer;
      StepLoop     : Integer;
      P            : TStateVariable;
      NewLoad      : TLoad;
      DrawValue    : Double;

  Begin
    With TAQUATOXSegment(SegmentColl.At(SegmtLoop)) do
      P:=SV.GetStatePointer(Dist.SVID.NState,Dist.SVID.SVType,Dist.SVID.Layer);
    If P=nil then Raise EAQUATOXError.Create('Distribution Error!  No variable exists under distribution');

    If not Dist.LoadsCopied then Writeln(TextOut,Dist.Name,' '+' Not Used.  Dynamic Loadings Selected.')
                             else Writeln(TextOut,Dist.Name,' '+' Sampled each timestep.');
    If not Dist.LoadsCopied then exit;

    If not (P.LoadsRec.Loadings=nil) then P.LoadsRec.Loadings.Destroy;
    P.LoadsRec.Loadings:=nil;
    P.LoadsRec.Loadings:=TLoadings.Init(5,5);

    NumTimeSteps:=Trunc(Setup.LastDay-Setup.FirstDay+1);

    StepsHolder:=Uncertainty.NumSteps;
    Try
      Uncertainty.NumSteps:=NumTimeSteps;
      Dist.Draws.FreeAll;
      FillVariableDraws;  {Fill Draws with number of timesteps}
      Uncertainty.NumSteps:=StepsHolder;
    Except
      Uncertainty.NumSteps:=StepsHolder;
      Raise;
    End;

    For StepLoop:=1 to NumTimeSteps do
      begin
        DrawValue:=TUncertDraw(Dist.Draws.At(StepLoop-1)).Value;
        NewLoad:=TLoad.Init((Setup.FirstDay+StepLoop-1),DrawValue);
        With P.LoadsRec.Loadings do
             AtInsert(Count,NewLoad);
      end;
  End;
  {----------------------------------------------------------------}
  Procedure Finish_ConstLoad;
  {Reset loadings data to their original state}
  Var P: TStateVariable;
  Begin
    With TAQUATOXSegment(SegmentColl.At(SegmtLoop)) do
      P:=SV.GetStatePointer(Dist.SVID.NState,Dist.SVID.SVType,Dist.SVID.Layer);
    If P=nil then Raise EAQUATOXError.Create('Distribution Error!  No variable exists under distribution');

    If Dist.LoadsCopied then
       begin
         If p.LoadsRec.Loadings<>nil then p.LoadsRec.Loadings.Destroy;
         p.LoadsRec.Loadings:=nil;
         p.LoadsRec.Loadings:=Dist.DynLoadings;
         p.LoadsRec.UseConstant:=True;
       end;
  End;

  {----------------------------------------------------------------}
  {---        BEGIN MAIN Procedure LATIN HYPERCUBE RUN          ---}
  {----------------------------------------------------------------}
Var WorkingSeg: TAQUATOXSegment;
    SegID     : String;
    VSegLoop: VerticalSegments;
Begin
  Uncertainty    := TemplateSeg.PUncertainty^;
  IterationsDone := 0;
  UserInterrupt  := False;
  ExportTable    := TTable.Create(Nil);

  Try

  InitTextResults;     {Setup File Handling for writing output}
  OpenExportTable;

  If Uncertainty.UseSeed then SetSeed(Uncertainty.RandomSeed)
                         else SetSeed(-1);

  StudyProgress.UncertStatusLabel.Caption := 'Calculating Latin Hypercube Draws...';
  StudyProgress.Update;
  {The below nested loop fills the VariableDraws array and saves
   the point estimates so they can be restored after the LH run}
  For SegmtLoop:=-1 to SegmentColl.Count-1 do
   Begin
     If SegmtLoop=-1 then WorkingSeg := TemplateSeg
                     else WorkingSeg := TAQUATOXSegment(SegmentColl.At(SegmtLoop));
     With WorkingSeg do
       Begin
         If SegmtLoop>-1 then ResultsHolder[SegmtLoop]:=SV.Results;
         For DistribLoop:=0 to SV.Distributions.Count-1 do
            Begin
              Dist:=SV.Distributions.At(DistribLoop);
              With Dist do
                If UseDist then
                   Begin
                     FillVariableDraws;
                     If (Dist.DistNum=ConstLoad_RegDist_Index) then Init_ConstLoad;
                     PointEstimate:=SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^;
                     If SegmtLoop>-1 then SummarizeDist(SV.PSegID^)
                                     else SummarizeDist('s, ALL');
                   End;
            End;
       End;
   End;
   
  Writeln(TextOut,'---------------------------------------------------------');

  For VSegLoop := Epilimnion to Hypolimnion do
   For SegmtLoop:=0 to SegmentColl.Count-1 do
    With TAQUATOXSegment(SegmentColl.At(SegmtLoop)) do
     Begin
         SV.Results[VSegLoop]:=TResultsCollection.Init;
         For ResLoop:=MinRes to MeanRes do
             UncertRes[SegmtLoop,ResLoop,VSegLoop]:=nil;
     End;

  For NumStepsLoop:=1 to Uncertainty.NumSteps do
    Begin
      {Update Progress Dialog}
      IterationHolder:='Iteration '+IntToStr(NumStepsLoop)+ ' of '+IntToStr(Uncertainty.NumSteps);
      TemplateSeg.SV.ProgData.UncertStatLabel := IterationHolder;

      Writeln(TextOut,IterationHolder);
      Writeln(TextOut);

      {Load the latin hypercube values into the simulation}
      For SegmtLoop:=-1 to SegmentColl.Count-1 do
        Begin
          If SegmtLoop=-1 then WorkingSeg := TemplateSeg
                          else WorkingSeg := TAQUATOXSegment(SegmentColl.At(SegmtLoop));
          With WorkingSeg do
             For DistribLoop:=0 to SV.Distributions.Count-1 do
               Begin
                 Dist:=SV.Distributions.At(DistribLoop);
                 With Dist do
                   If UseDist then
                      If (Dist.DistNum<>ConstLoad_RegDist_Index)
                        then begin
                               DrawValue:=TUncertDraw(Draws.At(NumStepsLoop-1)).Value;
                               SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^:=DrawValue;
                               If SegmtLoop=-1 then SegID :='s, ALL'
                                               else SegID := SV.PSegID^;
                               Writeln(TextOut,'Seg'+SegID+': '+Dist.Name,' '+FloatToStrF(DrawValue,ffGeneral,6,5));
                             end
                         else Sample_ConstLoad;
               End;
        End;

      {Go through run Procedure for each iteration}
      Verify_Runnable(False);

      Run(True);

      If (StudyProgress.ModalResult>0) or UserInterrupt then
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
    StudyProgress.ModalResult:=1;
    TemplateSeg.SV.PMessageStr^ := 'Run-Time Error During Uncertainty Iteration.';
    TemplateSeg.SV.PMessageErr^ := True;
    TemplateSeg.SV.TSMessage;
    TemplateSeg.SV.PMessageStr^ := ErrorString;
    TemplateSeg.SV.TSMessage;
    DateTimeToString(DateHolder,'mm-d-y t',Now);
      Try
        Writeln(TextOut,'Run Terminated at '+ DateHolder );
        Writeln(TextOut,'    Due to '+ErrorString);
      Except
        TemplateSeg.SV.PMessageStr^ := 'No Data Written';
        TemplateSeg.SV.TSMessage;
        TemplateSeg.SV.ProgData.ProgCancel := True;
        TemplateSeg.SV.UpdateProg;
      End;

  End; {Except}

  CloseFile(TextOut);
  StudyProgress.LinkModeLabel.Caption := '';

  Try

  For SegmtLoop:=0 to SegmentColl.Count-1 do
    Begin
      WorkingSeg := TAQUATOXSegment(SegmentColl.At(SegmtLoop));
      WorkingSeg.SV.DestroyResults(False);
      WorkingSeg.SV.Results := ResultsHolder[SegmtLoop];  {Pass deterministic results back to SV}

      If IterationsDone<=0 then with WorkingSeg do
        Begin
          Unc_Dir:=''; Unc_File:=''; Unc_Ext:='';
        End;
    End;

  IF IterationsDone<=0
     then begin
            ExportTable.Active:=False;
            ExportTable.Close;
          end
     else WriteResultsToDBase;

  For SegmtLoop:=0 to SegmentColl.Count-1 do  {Free memory where uncert results were stored}
    For ResLoop:=MinRes to MeanRes do
        begin
           If UncertRes[SegmtLoop,ResLoop,Epilimnion]<>nil then UncertRes[SegmtLoop,ResLoop,Epilimnion].Destroy;
           UncertRes[SegmtLoop,ResLoop,Epilimnion]:=nil;
        end;



  Except
    ErrorString:=Exception(ExceptObject).Message;
    TemplateSeg.SV.ProgData.ProgCancel := True;

    TemplateSeg.SV.PMessageStr^ := 'Run-Time Error Writing Database After Uncertainty Run';
    TemplateSeg.SV.PMessageErr^ := True;
    TemplateSeg.SV.TSMessage;
    TemplateSeg.SV.PMessageStr^ := ErrorString;
    TemplateSeg.SV.TSMessage;
    TemplateSeg.SV.UpdateProg;

    ExportTable.Active:=False;
    ExportTable.Close;
  End; {Except}

  {Load the point estimate values back into the simulation}

  For SegmtLoop:=-1 to SegmentColl.Count-1 do
    Begin
      If SegmtLoop=-1 then WorkingSeg := TemplateSeg
                      else WorkingSeg := TAQUATOXSegment(SegmentColl.At(SegmtLoop));
      With WorkingSeg do
        For DistribLoop:=0 to SV.Distributions.Count-1 do
          Begin
            Dist:=SV.Distributions.At(DistribLoop);
            With Dist do
              If UseDist then
                  Begin
                    SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^:=Dist.PointEstimate;
                    If (Dist.DistNum=ConstLoad_RegDist_Index) then Finish_ConstLoad;
                  End;
          End;
    End;
End;  {LatinHyperCubeRun}

Procedure TLinkedSegs.WriteText(Var LF: TextFile);
Var VersionWrite: String[10];
    i: Integer;
    PAQTS: TAQUATOXSegment;
    PLK: TSegmentLink;
Begin
   TeaseScreen:=True;
   VersionWrite:=VersionStr;
   Writeln(LF,'AQUATOX Linked Segments Model Text Parameterization');
   Writeln(LF,'-----------------------------------');
   Writeln(LF,'AQUATOX Version: '+VersionWrite);
   Writeln(LF,'FileName: '+FileName);
   Writeln(LF,'Directory: '+DirName);
   Writeln(LF,'SystemName: '+SystemName);

   For i:=0 to SegmentColl.Count-1 do
      begin
        Writeln(LF,'--------------------   START OF NEW SEGMENT   ---------------------');
        PAQTS:=SegmentColl.At(i);
        PAQTS.WriteText(LF);
      end;

   For i:=0 to Links.Count-1 do
      begin
        PLK:=Links.At(i);
        PLK.WriteText(LF);
      end;
End;



{------------------------------------------------------------------------------------------------------------------}

{------------------------------------------------------------------------------------------------------------------}

{------------------------------------------------------------------------------------------------------------------}



Procedure TLinkedSegs.SensitivityRun;
Var
    ResultsHolder: Array of ResultsType;
    NegTest, UserInterrupt: Boolean;
    StepNum, NumTests, WriteRow, IterationsDone: Integer;
    TextOut      : TextFile;
    NegStr,DateHolder   : String;
    TestVal      : Double;
    PointIndexes : Array[1..100] of Integer;
    Dist         : TDistribution;
    DistLinked   : Boolean;
    TEx          : Array of TExcelOutput;

    {--------------------------------------------------------------}
    Procedure WriteOutputs(RC: TResultsCollection; Row: Integer; Epi: Boolean; SegIndex: Integer);
    Var i, WriteCol : Integer;
        WWS: _Worksheet;
        OutVal: Double;
    Begin
      WWS := TEx[SegIndex].WS;
      WriteCol := 0;
      For i:=1 to TemplateSeg.PUncertainty^.NumSens do
       If PointIndexes[i] > -99 then
         Begin
           Inc(WriteCol);
           OutVal := TDataPoint(TResults(RC.At(RC.Count-1)).DataPoints.At(PointIndexes[i])).State;
           WWS.Cells.Item[Row+1,WriteCol+2].Value := OutVal;
           //Write(Textout,', '+FloatToStrF(OutVal,ffgeneral,8,4));
         End;
    End;
    {--------------------------------------------------------------}
    Procedure CreateExcel;
    Var {TCF: TCellFormat; }
        SegmtLoop, i,j,ColN: Integer;
        PH: TResHeader;
        WorkingSeg: TAQUATOXSegment;
        WroteOutputs: Boolean;
    Begin
     SetLength(TEx,SegmentColl.Count);
     WroteOutputs := False;

     For SegmtLoop:=0 to SegmentColl.Count-1 do
      Begin
        TEx[SegmtLoop] := nil;
        WorkingSeg := TAQUATOXSegment(SegmentColl.At(SegmtLoop));
        If SegmtLoop = 0 then Write(TextOut,'Outputs Tracked -->');
        If WorkingSeg.SV.Location.sitetype<>TribInput then
        With WorkingSeg do
         Begin
          Coinitialize(nil);

          TEx[SegmtLoop] := TExcelOutput.Create(True);
          If Not TEx[SegmtLoop].OpenFiles then
            Begin
              TEx[SegmtLoop] := nil;
              Raise EAquatoxError.Create('Error Creating Excel Files for Sensitivity Output');
            End;

          TEx[SegmtLoop].FileN := ChangeFileExt(TemplateSeg.Sens_File,'_' + WorkingSeg.SegNumber +'.xls');

          TEx[SegmtLoop].WS.Name := 'Sensitivity';
          TEx[SegmtLoop].WS.Cells.Item[1,1].Value := FloatToStrF(TemplateSeg.PUncertainty^.NominalPercent,ffgeneral,8,2)+'% Sensitivity Test';
          TEx[SegmtLoop].WS.Cells.Item[1,2].Value := 'Parameter Value';
          TEx[SegmtLoop].WS.Cells.Item[2,1].Value := 'Base Case';
          TEx[SegmtLoop].WS.Cells.Item[2,2].Value := 'N A';

          ColN := 0;
          For i:=1 to TemplateSeg.PUncertainty^.NumSens do    // loop through selected sensitivity outputs
             Begin
               PointIndexes[i] := -99;
               For j := 0 to ResultsHolder[SegmtLoop][Epilimnion].Headers.Count-1 do   // loop through results in each segment
                 Begin
                   PH := ResultsHolder[SegmtLoop][Epilimnion].Headers.At(j);
                   If PH.SortIndex = TemplateSeg.PUncertainty^.SensTrack[i] then
                     Begin
                       Inc(ColN);
                       TEx[SegmtLoop].WS.Cells.Item[1,ColN+2].Value := PH.ListStr(False);
                       If not WroteOutputs then Write(TextOut,', "',PH.ListStr(False)+'"');
                       TEx[SegmtLoop].WS.Cells.Item[3,ColN+2].Value := '''';
                       PointIndexes[i] := PH.PointIndex;
                     End;
                 End;
             End;

           If not WroteOutputs then Writeln(Textout);
           WriteOutputs(ResultsHolder[SegmtLoop][Epilimnion],1,True,SegmtLoop);
           If not WroteOutputs then Writeln(Textout);
           WroteOutputs := True;
           WriteRow := 2;
           TEx[SegmtLoop].WS.Cells.Item[WriteRow+1,1].Value := 'Test Parameter';

        End; {with}
     End; {for do}
    End;
   {------------------------------------------------------------------}
    Procedure InitTextResults;
    Var FileN: String;
    Begin
      FileN := ChangeFileExt(TemplateSeg.Sens_File,'.txt');

      ASSIGNFILE(TextOut,FileN);
      REWRITE(TextOut);
      Writeln(Textout,'---------------------------------------------------------');
      Writeln(TextOut);
      Writeln(TextOut,'        Sensitivity Test for Model "',FileName,'"');
      Writeln(TextOut,'        -- ',SystemName,' --');
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
   var i,j: Integer;
       WS: TAQUATOXSegment;
   Begin
     NumTests := 0;
      For j:=-1 to SegmentColl.Count-1 do
       Begin
         If j=-1 then WS := TemplateSeg
                 else WS := SegmentColl.At(j);
         With WS.SV do
            For i := 0 to Distributions.Count - 1 do
              If TDistribution(Distributions.At(i)).UseForSens then NumTests := NumTests + 2;
       End;
   End;
   {------------------------------------------------------------------}
   Procedure SavePointEsts;
     {The below nested loop fills the VariableDraws array and saves
   the point estimates so they can be restored after the Sensitivity run}
   Var DistribLoop: Integer;
       j: Integer;
       WS: TAQUATOXSegment;
   Begin
    For j:=-1 to SegmentColl.Count-1 do
     Begin
      If j=-1 then WS := TemplateSeg
              else WS := SegmentColl.At(j);
       With WS do
         With SV.Distributions do
          For DistribLoop:=0 to Count-1 do
           With TDistribution(At(DistribLoop)) do
           If UseForSens then PointEstimate:=SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^;
     End;
   End;
   {------------------------------------------------------------------}
   Procedure RestorePointEsts;
   {Load the point estimate values back into the simulation}
   Var DistribLoop: Integer;
       j: Integer;
       WS: TAQUATOXSegment;
   Begin
    For j:=-1 to SegmentColl.Count-1 do
     Begin
      If j=-1 then WS := TemplateSeg
              else WS := SegmentColl.At(j);
       With WS do
         With SV.Distributions do
          For DistribLoop:=0 to Count-1 do
           With TDistribution(At(DistribLoop)) do
           If UseForSens then SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^ := PointEstimate;
     End;
   End;
   {------------------------------------------------------------------}
   Procedure Write_Sensitivity_Results(SegID: String);
   Var LinkSTr: String;
       WWS: _Worksheet;
       segmtLoop: Integer;
       WroteOutputs:Boolean;
       WorkS: TAQUATOXSegment;
   Begin
    WroteOutputs := False;
    For segmtLoop:=0 to SegmentColl.Count-1 do
     Begin
       WorkS := SegmentColl.At(segmtLoop);
       If SegmtLoop = 0 then Inc(WriteRow);
       If WorkS.SV.Location.sitetype<>TribInput then
        With WorkS do
        Begin
          If SV.Results[Epilimnion]=nil then break;
          If SV.Results[Epilimnion].Count<=1 then break;
          WWS := TEx[segmtLoop].WS;

          WWS.Cells.Item[WriteRow+1,2].Value := TestVal;

          If DistLinked then LinkStr := ' * Linked *' else LinkStr := '';
          WWS.Cells.Item[WriteRow+1,1].Value := SegID + Dist.Name + LinkStr + ' '+NegStr;

//          If Not WroteOutputs then
//            Begin
//              Write(TExtOut,'"'+SegID + Dist.Name + LinkStr + ' '+NegStr+'"');
//              Write(TExtOut,' Modified to Value '+FloatToStrF(TestVal,ffgeneral,8,4)+'    >');
//            End;

          WriteOutputs(SV.Results[Epilimnion],WriteRow,True,SegmtLoop);

          TEx[SegmtLoop].Save;  {Save Excel file after each iteration}

          {Update Text output}
          If Not WroteOutputs then
            Begin
              IterationsDone:=StepNum;
              Writeln(Textout,'Testing '+SegID + Dist.Name+ ' At Value '+FloatToStrF(TestVal,ffgeneral,8,4));
              Writeln(Textout,'Iteration '+IntToStr(StepNum)+' Completed.  Excel File Updated.');
              Writeln(Textout,'---------------------------------------------------------');
              WroteOutputs := True;
            End;
        End;
      End;
    End;      {Write_Sensitivity_Results}
   {------------------------------------------------------------------}
   Function IsLinkedPlant: Boolean;
   Var PP: TPlant;
   Begin
     IsLinkedPlant := False;
     If (Dist.SVID.nstate in [FirstPlant..LastPlant]) and (Dist.SVID.SVType=STV) then
       Begin
         PP := TemplateSeg.SV.GetStatePointer(Dist.SVID.NState,Dist.SVID.SVType,WaterCol);
         IF PP = nil then exit;
         IsLinkedPlant := PP.IsLinkedPhyto;
         If Not Result then
           If ((PP.IsPeriphyton) and
               (PP.PSameSpecies^ <> NullStateVar )) then
                  IsLinkedPlant := TemplateSeg.SV.GetStatePointer(PP.PSameSpecies^,StV,WaterCol) <> nil
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
          If (not TemplateSeg.SV.Distributions.FindDistrib(DistNum,SVID2,ToxRec,Index))
           then Exit;

         LinkedDist:=TemplateSeg.SV.Distributions.At(Index);

         If Restore
           then
             Begin
               With LinkedDist do TemplateSeg.SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^ := PointEstimate;
             End {restore}
           else
             Begin
               LinkedDist.PointEstimate:=TemplateSeg.SV.Return_Var_Pointer(LinkedDist.DistNum,SVID2,LinkedDist.ToxRec)^;
               VaryAmount := (TemplateSeg.PUncertainty^.NominalPercent/100) * LinkedDist.PointEstimate;
               If NegTest then TVL := LinkedDist.PointEstimate - VaryAmount
                          else TVL := LinkedDist.PointEstimate + VaryAmount;
               With LinkedDist do TemplateSeg.SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^ := TVL;
               Writeln(Textout,'( -- linked plant '+ LinkedDist.Name+ ' Modified to Value '+FloatToStrF(TVL,ffgeneral,8,4)+ '-- )');
             End; {vary}

       End;

   Var ploop: AllVariables;
       pperi: TPlant;
   Begin
     PP := TemplateSeg.SV.GetStatePointer(Dist.SVID.NState,Dist.SVID.SVType,WaterCol);
     If PP.IsLinkedPhyto
       then For ploop := FirstAlgae to LastAlgae do
         Begin  {there could be multiple periphyton compartments linked to one phytoplantkon}
           PPeri := TemplateSeg.SV.GetStatePointer(PLoop,Stv,WaterCol);
           If PPeri <> nil then
             If (PPeri.IsPeriphyton) and
               (PPeri.PSameSpecies^ = Dist.SVID.NState)
                  then SetParam(ploop)
         End
       else {periphyton}
         SetParam(PP.PSamespecies^)

   End;
   {------------------------------------------------------------------}

Var VaryAmount: Double;
    ErrorString: String;
    SegID, IterationHolder: String;
    i: Integer;
    SegLoop: VerticalSegments;
    SegSaveLoop, segmtLoop: Integer;
    WorkS: TAQUATOXSegment;
    WroteOutputs: Boolean;

Begin     {SensitivityRun}
  WroteOutputs := False;
  If (Not TemplateSeg.SV.PRateInfo^.WriteToMemory) then
     TemplateSeg.PSetup^.SaveBRates := False;

  IterationsDone:=0;
  UserInterrupt:=False;

  DistLinked := False;
  TRY

  SetLength(ResultsHolder,SegmentColl.Count);
  For segmtLoop:=0 to SegmentColl.Count-1 do
    Begin
      WorkS := SegmentColl.At(segmtLoop);
      With WorkS do
        Begin
          ResultsHolder[SegmtLoop]:=SV.Results;
          For SegLoop := Epilimnion to Hypolimnion do
            SV.Results[SegLoop]:=TResultsCollection.init;
        End;
    End;

  InitTextResults;
  CreateExcel;
  CountNumTests;
  SavePointEsts;

  StepNum := 0;

  For segmtLoop:=-1 to SegmentColl.Count-1 do
    BEGIN
      If SegmtLoop=-1 then WorkS := TemplateSeg
                      else WorkS := TAQUATOXSegment(SegmentColl.At(SegmtLoop));

      With WorkS.SV do
       For i := 0 to Distributions.Count - 1 do
        If TDistribution(Distributions.At(i)).UseForSens then
         For NegTest := False to True do
          Begin
            {Update Progress Dialog}
            Inc(StepNum);
//            With TemplateSeg.PUncertainty^ do
 //              If (StepNum < StartIter) or (StepNum>EndIter) then continue;  {if split into multi-processors}
            DateTimeToString(DateHolder,'mm-d-y t',Now);

            IterationHolder:='Iteration '+IntToStr(StepNum)+ ' of '+IntToStr(NumTests) + ' Starts at '+DateHolder;
            TemplateSeg.SV.ProgData.UncertStatLabel := IterationHolder;
            Writeln(TextOut,IterationHolder);

            Dist := TDistribution(Distributions.At(i));
            If NegTest then NegStr := '-' else NegStr := '+';

            VaryAmount := (TemplateSeg.PUncertainty^.NominalPercent/100) * Dist.PointEstimate;
            If NegTest then TestVal := Dist.PointEstimate - VaryAmount
                       else TestVal := Dist.PointEstimate + VaryAmount;

            With Dist do
             WorkS.SV.Return_Var_Pointer(DistNum,SVID,ToxRec)^ := TestVal;

            If TemplateSeg.PUncertainty^.LinkPeriPhyto then
              Begin
                DistLinked := IsLinkedPlant;
                If DistLinked then AdjustLinkedPlants(False);
              End;

           {Go through run Procedure for each iteration}
           Verify_Runnable(False);

           Run(True);

           With Dist do Return_Var_Pointer(DistNum,SVID,ToxRec)^ := PointEstimate;
           {Restore original value to parameter}
           If DistLinked then AdjustLinkedPlants(True);

           If (TemplateSeg.SV.ProgData.ProgCancel) or UserInterrupt then
               begin
                  UserInterrupt:=True;
                  DateTimeToString(DateHolder,'mm-d-y t',Now);
                  Writeln(TextOut,'Run Terminated by user at '+ DateHolder );
                  Break; {exit loop}
               end
               else
                 Try
                   If SegmtLoop >-1 then SegID := '['+ WorkS.SegNumber+'] '
                                    else SegID := '';
                   Write_Sensitivity_Results(SegID);
                 Except
                   DateTimeToString(DateHolder,'mm-d-y t',Now);
                   TRY
                     For SegSaveLoop := 0 to SegmentColl.Count-1 do
                       If TAQUATOXSegment(SegmentColl.At(SegSaveLoop)).SV.Location.sitetype<>TribInput
                         Then Begin
                                Writeln(TextOut,'After write error, attempting to Save Excel file at '+TEX[SegmtLoop].FileN );
                                TEx[SegSaveLoop].SaveAndClose;
                              End;
                   Finally
                     Writeln(TextOut,'Run Terminated:  Error writing results to Excel at '+ DateHolder );
                   End;

                   TemplateSeg.SV.ProgData.ProgCancel := True;
                   Raise;
                 End;

            DistLinked := False;
          End;  {Nested For Do Loops (i, negtest)}

        If Not UserInterrupt and not WroteOutputs then
          begin
            DateTimeToString(DateHolder,'mm-d-y t',Now);
            Writeln(TextOut,'Run Successfully Completed At '+ DateHolder );
            Writeln(TextOut,'---------------------------------------------------------');
            WroteOutputs := True;
          end;

       If UserInterrupt then Break;
    END;  //segmtloop

  Except

      ErrorString:=Exception(ExceptObject).Message;
      TemplateSeg.SV.ProgData.ProgCancel := True;

      TemplateSeg.SV.PMessageStr^ := 'Run-Time Error During Sensitivity Iteration.';
      TemplateSeg.SV.PMessageErr^ := True;
      TemplateSeg.SV.TSMessage;
      TemplateSeg.SV.PMessageStr^ := ErrorString;
      TemplateSeg.SV.TSMessage;

      DateTimeToString(DateHolder,'mm-d-y t',Now);
        Try
          Writeln(TextOut,'Run Terminated at '+ DateHolder );
          Writeln(TextOut,'    Due to '+ErrorString);
        Except
          TemplateSeg.SV.PMessageStr^ := 'No Data Written';
          TemplateSeg.SV.TSMessage;
          TemplateSeg.SV.ProgData.ProgCancel := True;
          TemplateSeg.SV.UpdateProg;
        End;

      TemplateSeg.SV.UpdateProg;
      If DistLinked then AdjustLinkedPlants(True);

  End; {Except}

  CloseFile(TextOut);

  Try

   For SegmtLoop:=0 to SegmentColl.Count-1 do
    If TEx[SegmtLoop] <> nil then
      Begin
        TEx[SegmtLoop].WS.Range['A1', 'A1'].EntireColumn.AutoFit;
        TEx[SegmtLoop].SaveAndClose;
        TEx[SegmtLoop] := nil;
      End;

  Finally

   For SegmtLoop:=0 to SegmentColl.Count-1 do
    TAQUATOXSegment(SegmentColl.At(SegmtLoop)).SV.Results:=ResultsHolder[SegmtLoop];

   RestorePointEsts;
   TEx := nil;
   ResultsHolder := nil;
  End;
End;   {SensitivityRun}

{-------------------------------------------------------------------}


