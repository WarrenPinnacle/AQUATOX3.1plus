//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit LinkedExcelTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LinkedSegs, StdCtrls, Loadings;

type
  TLinkedExcelForm = class(TForm)
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  LinkedExcelForm: TLinkedExcelForm;

Procedure ApplyExcelTemplate(PLS: TLinkedSegs);

implementation

Uses Excel2000, Comobj, ActiveX, AQSTudy, Global, AQUAOBJ, Wait, Observed_Data;

Procedure ApplyExcelTemplate(PLS: TLinkedSegs);
Const BLANK_VAL = -9999;
Var lcid: integer;
    WBk: _WorkBook;
    WS: _Worksheet;
    Excel: _Application;
    SheetIndex, StartColIndex, ColIndex:Integer;
    AddType: String;
    DoneReading: Boolean;

    Function ReadText(R,C: Integer): String;
    Begin
      Result := WS.Cells.Item[R,C].value2;
    End;

    Function ReadNum(R,C: Integer): Double;
    Var T : String;
    Begin
      T := ReadText(R,C);
      If Trim(T) = '' then Result := BLANK_VAL
                      else Result := StrToFloat(T);
    End;

    Procedure LoadingsFromExcel(SR,SC: Integer; Var LColl: TLoadings; NonDetects: Boolean; TOS: TObservedSeries);
    {Copies loadings data from Excel to the Collection}
    Var row    : Integer;
        NewLoad: TLoad;
        DateStr: String;
        Finished: Boolean;
        Increment : Integer;
        LoadVal   : Double;
        i: Integer;
    Begin
        If NonDetects then Increment := 2
                      else Increment := 1;

        If LColl<>nil then
          Begin
            LColl.Destroy;
            LColl :=TLoadings.Init(20,100);
          End;

        i := 0;

        Row := SR;                                         
        Repeat
          DateStr := ReadText(Row,SC);
          Finished := (Trim(DateStr) = '') or (Trim(DateStr) = 'end');
          If Not Finished then
            Begin
              LoadVal := ReadNum(Row,SC+Increment);
              If LoadVal <> BLANK_VAL then
                Begin
                  If LColl <> nil then
                    Begin
                      If NonDetects
                        then if (Trim(ReadText(Row,SC+1)) <> '')
                          then LoadVal := LoadVal/2;  {1/2 DL for now}
                      NewLoad:= TLoad.Init(StrToFloat(DateStr),LoadVal);
                      If Not LColl.Insert(NewLoad) then
                        LinkedExcelForm.Memo1.Lines.Add('---> WARNING Duplicate Date Loading '+ DateToStr(StrToFloat(DateStr))+ '.  Data will be lost');
                    End
                  else {Observed Data}
                    Begin
                       Inc(i);
                       If i>Length(TOS.ObsDates) then TOS.AddLength;
                       TOS.NumRecs := i;

                       TOS.ObsDates[i-1] := StrToFloat(DateStr);
                       TOS.ObsVals[i-1] :=  LoadVal;

                      If NonDetects
                        then if (Trim(ReadText(Row,SC+1)) <> '')
                          then If Trim(ReadText(Row,SC+1)) = '>'
                            then TOS.NDFlag[i-1] := 2
                            else TOS.NDFlag[i-1] := 1;
                    End
                End;
              Inc(Row);
              WaitDlg.Tease;
            End;
        Until Finished;
    End; {LoadingsFromExcel}


    Procedure ReadNewSeg(IsTrib: Boolean);
    Var SegToCopy,NewSeg: TAQUATOXSegment;
        MemStream: TMemoryStream;
        IDStr, OpStr, ErrorMessage: String;
        ReadVers, VersionNum: Double;
        VersionCheck : String[10];
        PVol         : TVolume;
        Loop2        : Integer;

    Begin
        OpStr := 'Modified';
        IDStr := Trim(ReadText(3,ColIndex));

        {Get the Index of the Segment in the Colection}
        NewSeg:=nil;
        For Loop2 := 0 to PLS.SegmentColl.Count-1 do
          If TAQUATOXSegment(PLS.SegmentColl.At(Loop2)).SegNumber= Trim(IDStr)
            then NewSeg := PLS.SegmentColl.At(Loop2);

        If NewSeg = nil then
          Begin
           OpStr := 'Added';
            SegToCopy := PLS.SegmentColl.At(0);
            MemStream:=TMemoryStream.Create;
            SegToCopy.SV.StoreResults := True;
            SegToCopy.SV.StoreDistribs := True;
            SegToCopy.Store(False,TStream(MemStream));    {Store Collection in memory}
            VersionNum:=StrToFloat(AbbrString(VersionStr,' '));
            ReadVers:=VersionNum;         {Get Correct Version Num for Read}

            MemStream.Seek(0, soFromBeginning); {Go to beginning of stream}
            MemStream.Read(VersionCheck,Sizeof(VersionCheck));
            NewSeg:=TAQUATOXSegment.Load(True,False,TStream(MemStream),ReadVers,True,True); {Call Load Method}
            MemStream.Destroy;

            NewSeg.ShowTemplate(PLS.TemplateSeg, ErrorMessage,True,False);

            PLS.SegmentColl.Insert(NewSeg);
            PLS.ClearAllResults(0);

            If ErrorMessage<>'' then
               Begin
                 MessageDlg('AQUATOX unexpectedly Got Error: '+ErrorMessage+' while copying the segment',
                             MTError, [mbok], 0);
                 Exit;
               End;
          End;

        With NewSeg do
          Begin
            StudyName := ReadText(2,ColIndex);
            SegNumber := Trim(ReadText(3,ColIndex));
            SV.LinkedMode := True;

            Location.Locale.SiteName := StudyName;

            PVol := SV.GetStatePointer(Volume,StV,WaterCol);
            {set inflow, disch to zero}
            PVol.LoadsRec.Alt_UseConstant[PointSource] := True;  {Pointsource is inflow in this case}
            PVol.LoadsRec.Alt_ConstLoad[PointSource] := 0;
            PVol.LoadsRec.Alt_UseConstant[DirectPrecip] := True;     {DirecPrecip is discharge in this case}
            PVol.LoadsRec.Alt_ConstLoad[DirectPrecip] := 0;
            PVol.Calc_Method := dynam;

            If IsTrib then
              Begin
                Location.SiteType := TribInput;
                LinkedExcelForm.Memo1.Lines.Add(OpStr+' Tributary Input: ' + StudyName );
                Exit;
              End;

            Location.Locale.SiteLength := ReadNum(4,ColIndex);
            Location.Locale.StaticVolume := ReadNum(5,ColIndex);
            PVol.InitialCond := Location.Locale.StaticVolume;
            Location.Locale.SurfArea := ReadNum(6,ColIndex);
            Location.Locale.ICZMean := ReadNum(7,ColIndex);
            Location.Locale.ZMax := ReadNum(8,ColIndex);

            If Trim(ReadText(9,ColIndex)) <> '' then
                Location.Locale.Channel_Slope := ReadNum(9,ColIndex);

            If Trim(ReadText(10,ColIndex)) <> '' then
              Begin
                Location.Locale.UseEnteredManning := True;
                Location.Locale.EnteredManning := ReadNum(10,ColIndex);
              End;

            Inc(ColIndex);
            WaitDlg.Tease;
            LinkedExcelForm.Memo1.Lines.Add(OpStr+' Segment: ' + StudyName )
          End;
    End;

    Procedure ReadNewLink(IsTrib: Boolean);
    Var NewLink: TSegmentLink;
        FrmID, TID, OpStr  : String;
        Loop2  : Integer;

    Begin
      OpStr := 'Modified';
      FrmId := Trim(ReadText(3,ColIndex));
      TID   := Trim(ReadText(4,ColIndex));

      {Get the Index of the Link in the Colection}
      NewLink:=nil;
      For Loop2 := 0 to PLS.Links.Count-1 do
       If TSegmentLink(PLS.Links.At(Loop2)).FromID= FrmID
        then If TSegmentLink(PLS.Links.At(Loop2)).ToID=TID      
         then NewLink := PLS.Links.At(Loop2);

      If NewLink = nil then
        Begin
          NewLink := TSegmentLink.Init(ReadText(2,ColIndex));
          OpStr := 'Added';
          PLS.Links.Insert(NewLink);
        End;

      NewLink.FromID := FrmID;
      NewLink.ToID := TID;

      If IsTrib or (pos('cascade',Lowercase(ReadText(5,ColIndex)))>0)
        then NewLink.LinkType := CascadeLnk
        else Begin
               NewLink.LinkType := FeedbackLnk;
               NewLink.CharLength := 10; {m default}
             End;

      LoadingsFromExcel(7,ColIndex,NewLink.WaterFlowData,False,nil);

      LinkedExcelForm.Memo1.Lines.Add(OpStr+' Link: ' + NewLink.Name);

      If IsTrib then Exit;

      Inc(ColIndex);
      Inc(ColIndex);
    End;


    Procedure ReadNewTrib;
    Begin
      ReadNewSeg(True);
      ReadNewLink(True);

      LinkedExcelForm.Memo1.Lines.Add('Processed "Tributary" Input: ' + ReadText(2,ColIndex));

      Inc(ColIndex);
      Inc(ColIndex);
    End;         

    Procedure ReadObserved;
    Var ActStr, IDStr: String;
        ReadName : String[40];
        NonDetects: Boolean;
        PSeg: TAQUATOXSegment;
        TOS: TObservedSeries;
        OD : TObservedData;
        j, Loop2 : Integer;
        Junk: TLoadings;
    Begin
      Junk := nil;
      IDStr := ReadText(3,ColIndex);
      NonDetects := Pos('true',lowercase(ReadText(2,ColIndex)))>0;

      {Get the Index of the Segment in the Colection}
      PSeg:=nil;
      For Loop2 := 0 to PLS.SegmentColl.Count-1 do
        If TAQUATOXSegment(PLS.SegmentColl.At(Loop2)).SegNumber= Trim(IDStr)
          then PSeg := PLS.SegmentColl.At(Loop2);

      If PSeg = nil then
        Begin
          LinkedExcelForm.Memo1.Lines.Add('---> ERROR Finding Index '+ IDStr);
          Exit;
        End;

      TOS := nil;
      ActStr := 'Overwrote';
      OD := PSeg.SV.ObservedData;
      ReadName := ReadText(4,ColIndex);
      For j := 0 to OD.NumSeries-1 do
        If lowercase(OD.OSeries[j].NameStr) = lowercase(ReadName)
          then TOS := OD.OSeries[j];

      If TOS=nil then
        Begin
          ActStr := 'Added';
          Inc(OD.NumSeries);
          Dec(OD.CurrentIndex);
          If (OD.NumSeries > Length(OD.OSeries)) then
            SetLength(OD.OSeries,Length(OD.OSeries)+5);
          OD.OSeries[OD.NumSeries-1] := TObservedSeries.Create(OD.CurrentIndex);
          TOS := OD.OSeries[OD.NumSeries-1];
        End;

      TOS.InitLength(100);
      TOS.NameStr := ReadName;
      TOS.UnitStr := ReadText(5,ColIndex);
      TOS.Comment := ReadText(5,ColIndex+1);
      TOS.HasNDs := NonDetects;

      LoadingsFromExcel(7,ColIndex,Junk{nil},NonDetects,TOS);

      LinkedExcelForm.Memo1.Lines.Add(ActStr + ' Observed Data: ' + TOS.NameStr+' ('+TOS.UnitStr+')  for '+IDStr);

      Inc(ColIndex);
      If NonDetects then Inc(ColIndex);
      Inc(ColIndex);

    End;


    Procedure ReadTimeSeries(TSIndex: Integer);
    Var IDStr, PlantStr: String;
        NonDetects: Boolean;
        PSeg: TAQUATOXSegment;
        Loop2: Integer;
        PLRec : PLoadingsRecord;
        PSV   : TStateVariable;
        PPLd   : TLoadings;
        PVol  : TVolume;
        PD     : TDissRefrDetr;
        lp: PointSOurce..NonPOintSource;
        PlantVar: AllVariables;
    Begin
      IDStr := ReadText(3,ColIndex);
      NonDetects := Pos('true',lowercase(ReadText(2,ColIndex)))>0;

      {Get the Index of the Segment in the Colection}
      PSeg:=nil;
      For Loop2 := 0 to PLS.SegmentColl.Count-1 do
        If TAQUATOXSegment(PLS.SegmentColl.At(Loop2)).SegNumber= Trim(IDStr)
          then PSeg := PLS.SegmentColl.At(Loop2);

      If PSeg = nil then
        Begin
          LinkedExcelForm.Memo1.Lines.Add('---> ERROR Finding Index '+ IDStr);
          Exit;
        End;

      PSV := nil;
      PPLd := nil;
      PLRec := nil;
      With PSeg.SV do
       Case TSIndex of
         1,17: PSV := GetStatePointer(Nitrate,StV,WaterCol);
         2  : PSV := GetStatePointer(Ammonia,StV,WaterCol);
         3,16: PSV := GetStatePointer(Phosphate,StV,WaterCol);
         4,5: Begin
               PD := GetStatePointer(DissRefrDetr,StV,WaterCol);
               With PD.InputRecord.Percent_Refr do
                  Begin
                    UseConstant := True;
                    MultLdg := 1;
                    If TSIndex = 4 then ConstLoad := 0.5  {OM assumed 50% refr}
                                   else ConstLoad := 0.1; {CBOD assumed 90% labile}
                  End;
               With PD.InputRecord.Percent_Part do
                  Begin
                    UseConstant := True;
                    MultLdg := 1;
                    ConstLoad := 0.1;  {OM assumed 90% diss}
                  End;
               PLRec := @PD.InputRecord.Load;
               If TSIndex = 4 then PD.InputRecord.DataType:=Org_Matt
                              else PD.InputRecord.DataType:=CBOD;
               PD.LoadNotes1 := ReadText(4,ColIndex);
               PD.LoadNotes2 := ReadText(5,ColIndex);
              End;
         6: PSV := GetStatePointer(pH,StV,WaterCol);
         7: PSV := GetStatePointer(TSS,StV,WaterCol);
         8: PSV := GetStatePointer(Temperature,StV,WaterCol);
         9: Begin                                                //add dynamic import for Evap?
              UseConstZMean  := False;
              PPLd := DynZMean;
            End;
         10: PLRec := @Shade;
         11: Begin
               CalcVelocity := False;
               PPLd := DynVelocity;
             End;
         12: Begin
               PVol := GetStatePointer(Volume,StV,WaterCol);
               PVol.LoadsRec.Alt_UseConstant[PointSource] := False;  {Pointsource is inflow in this case}
               PPLd := PVol.LoadsRec.Alt_Loadings[PointSource];
             End;
         13: Begin
               PVol := GetStatePointer(Volume,StV,WaterCol);
               PVol.LoadsRec.Alt_UseConstant[DirectPrecip] := False;  {DirecPrecip is discharge in this case}
               PPLd := PVol.LoadsRec.Alt_Loadings[DirectPrecip];
             End;
         14: PSV := GetStatePointer(Oxygen,StV,WaterCol);
         15: Begin
               PlantStr := Trim(lowercase(ReadText(2,ColIndex+1)));
               If PlantStr = 'diatoms1' then PSV := GetStatePointer(diatoms1,StV,WaterCol)
                  else If PlantStr = 'diatoms2' then PSV := GetStatePointer(diatoms2,StV,WaterCol)
                  else If PlantStr = 'diatoms3' then PSV := GetStatePointer(diatoms3,StV,WaterCol)
                  else If PlantStr = 'diatoms4' then PSV := GetStatePointer(diatoms4,StV,WaterCol)
                  else If PlantStr = 'diatoms5' then PSV := GetStatePointer(diatoms5,StV,WaterCol)
                  else If PlantStr = 'diatoms6' then PSV := GetStatePointer(diatoms6,StV,WaterCol)
                  else If PlantStr = 'greens1' then PSV := GetStatePointer(greens1,StV,WaterCol)
                  else If PlantStr = 'greens2' then PSV := GetStatePointer(greens2,StV,WaterCol)
                  else If PlantStr = 'greens3' then PSV := GetStatePointer(greens3,StV,WaterCol)
                  else If PlantStr = 'greens4' then PSV := GetStatePointer(greens4,StV,WaterCol)
                  else If PlantStr = 'greens5' then PSV := GetStatePointer(greens5,StV,WaterCol)
                  else If PlantStr = 'greens6' then PSV := GetStatePointer(greens6,StV,WaterCol)
                  else If PlantStr = 'blgreens1' then PSV := GetStatePointer(blgreens1,StV,WaterCol)
                  else If PlantStr = 'blgreens2' then PSV := GetStatePointer(blgreens2,StV,WaterCol)
                  else If PlantStr = 'blgreens3' then PSV := GetStatePointer(blgreens3,StV,WaterCol)
                  else If PlantStr = 'blgreens4' then PSV := GetStatePointer(blgreens4,StV,WaterCol)
                  else If PlantStr = 'blgreens5' then PSV := GetStatePointer(blgreens5,StV,WaterCol)
                  else If PlantStr = 'blgreens6' then PSV := GetStatePointer(blgreens6,StV,WaterCol)
                  else If PlantStr = 'Cyanobacteria1' then PSV := GetStatePointer(blgreens1,StV,WaterCol)
                  else If PlantStr = 'Cyanobacteria2' then PSV := GetStatePointer(blgreens2,StV,WaterCol)
                  else If PlantStr = 'Cyanobacteria3' then PSV := GetStatePointer(blgreens3,StV,WaterCol)
                  else If PlantStr = 'Cyanobacteria4' then PSV := GetStatePointer(blgreens4,StV,WaterCol)
                  else If PlantStr = 'Cyanobacteria5' then PSV := GetStatePointer(blgreens5,StV,WaterCol)
                  else If PlantStr = 'Cyanobacteria6' then PSV := GetStatePointer(blgreens6,StV,WaterCol)
                  else If PlantStr = 'otheralg1' then PSV := GetStatePointer(otheralg1,StV,WaterCol)
                  else If PlantStr = 'otheralg2' then PSV := GetStatePointer(otheralg2,StV,WaterCol);

               If PSV = nil then
                 Begin
                   If PlantStr <> '' then
                     Begin
                       LinkedExcelForm.Memo1.Lines.Add('---> WARNING! Cannot find plant compartment '+PlantStr+
                                                       '; Chla loaded to "first" phytoplankton compartment.');
                       PlantStr := '';
                     End;
                   For PlantVar := FirstPlant to LastPlant do
                     Begin
                       PSV := GetStatePointer(PlantVar,StV,WaterCol);
                       If PSV<>nil then
                         If (TPlant(PSV).IsPhytoplankton)
                           then Break; {For do loop}
                     End;
                 End;

               If PSV<> nil then LinkedExcelForm.Memo1.Lines.Add('---> Chla loaded to '+PlantStr+' '+TPlant(PSV).PAlgalRec^.PlantName)
                            else Raise EAQUATOXError.Create('There are no phytoplankton compartments into which to load ChlA data');
             End;

       End; {case}

      If PSV<>nil then
        Begin
          PSV.LoadNotes1 := ReadText(4,ColIndex);
          PSV.LoadNotes2 := ReadText(5,ColIndex);
          PLRec := @PSV.LoadsRec;
          If TSIndex = 17 then TNO3Obj(PSV).TN_Inflow := True;
          If TSIndex = 16 then TPO4Obj(PSV).TP_Inflow := True;
          If TSIndex = 1 then TNO3Obj(PSV).TN_Inflow := False;
          If TSIndex = 3 then TPO4Obj(PSV).TP_Inflow := False;

        End;

      If PLRec <> nil then
       with PLRec^ do
        Begin
          PPLd := Loadings;
          ConstLoad := 0;
          UseConstant := False;
          NoUserLoad := False;
          If TSIndex = 15 then MultLdg :=          28    / 0.526    * 0.001  {convert ChlA to OM}
                            {g OM/mg chla}  {g c/ g chla} {g c/g om}  {g/mg}
                          else MultLdg := 1.0;
          For lp := PointSource to NonPointSource do
            Begin
              Alt_ConstLoad[Lp] := 0;
              Alt_UseConstant[Lp] := True;
              Alt_MultLdg[Lp] := 1.0;
            End;
        End;

      LoadingsFromExcel(7,ColIndex,PPLd,NonDetects,nil);

      LinkedExcelForm.Memo1.Lines.Add('Read Dynamic Loading: ' + ReadText(1,ColIndex)+ ' for '+IDStr);
      If PLRec <> nil then LinkedExcelForm.Memo1.Lines.Add('     (PS,NPS,DP Loadings set to zero)');
      If NonDetects then   LinkedExcelForm.Memo1.Lines.Add('     (Non-Detects set to 1/2 DL)');
      If TSIndex= 4 then   LinkedExcelForm.Memo1.Lines.Add('     (OM assumed 50% refr, 90% dissolved)');
      If TSIndex= 5 then   LinkedExcelForm.Memo1.Lines.Add('     (CBOD assumed 90% labile, 90% dissolved)');


      Inc(ColIndex);
      If NonDetects then Inc(ColIndex);
      Inc(ColIndex);

    End;

Begin

  Application.CreateForm (TLinkedExcelForm,LinkedExcelForm);

  With LinkedExcelForm.OpenDialog1 do
    Begin
      Title:='Select an Excel File with a Legal Template:';
      If not Execute then Begin LinkedExcelForm.Free; exit; End;
    End;

  With LinkedExcelForm do
    Begin
      Button1.Enabled := False;
      Show;

      TRY

        lcid := LOCALE_USER_DEFAULT;
        Excel := CoExcelApplication.Create;
        Excel.Visible[lcid] := False;

        LinkedExcelForm.Memo1.Lines.Clear;
        LinkedExcelForm.Memo1.Lines.Add('Reading from Excel File '+OpenDialog1.FileName);
        WaitDlg.Setup('Please Wait, Reading from Excel');

        Try
          SheetIndex := 1;
          WBk := Excel.Workbooks.Open(OpenDialog1.FileName, EmptyParam, EmptyParam, EmptyParam,
                                      EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam,
                                      EmptyParam, EmptyParam, EmptyParam,  EmptyParam,  LCID);
          WS := WBk.Worksheets.Item[SheetIndex] as _Worksheet;
          WS.Activate(LCID);

          ColIndex := 2;
          DoneReading := False;
          REPEAT

            StartColIndex := ColIndex;
            AddType := lowercase(ReadText(1,ColIndex));

            If Pos('newseg',AddType) > 0 then ReadNewSeg(False);
            If Pos('newlink',AddType) > 0 then ReadNewLink(False);
            If Pos('newtrib',AddType) > 0 then ReadNewTrib;
            If Pos('no3',AddType) > 0 then ReadTimeSeries(1);
            If Pos('nh4',AddType) > 0 then ReadTimeSeries(2);
            If Pos('tsp',AddType) > 0 then ReadTimeSeries(3);
            If Pos('om',AddType) > 0 then  ReadTimeSeries(4);
            If Pos('bod',AddType) > 0 then ReadTimeSeries(5);
            If Pos('cbod',AddType) > 0 then ReadTimeSeries(5);
            If Pos('ph',AddType) > 0 then  ReadTimeSeries(6);
            If Pos('tss',AddType) > 0 then    ReadTimeSeries(7);
            If Pos('temp',AddType) > 0 then   ReadTimeSeries(8);
            If Pos('zmean',AddType) > 0 then  ReadTimeSeries(9);
            If Pos('shade',AddType) > 0 then  ReadTimeSeries(10);
            If Pos('vel',AddType) > 0 then    ReadTimeSeries(11);
            If Pos('inflow',AddType) > 0 then ReadTimeSeries(12);
            If Pos('disch',AddType) > 0 then  ReadTimeSeries(13);
            If Pos('o2',AddType) > 0    then  ReadTimeSeries(14);
            If Pos('chla',AddType) > 0    then  ReadTimeSeries(15);
            If (Pos('tp',AddType) > 0) and (Pos('nextpage',AddType) <= 0) then ReadTimeSeries(16);
            If Pos('tn',AddType) > 0 then ReadTimeSeries(17);
            If Pos('observed',AddType) > 0 then  ReadObserved;

            If Pos('nextpage',AddType) > 0    then
               Begin
                  Inc(Sheetindex);
                  WS := WBk.Worksheets.Item[SheetIndex] as _Worksheet;
                  ColIndex := 2;
               End;

            If (Pos('end',AddType)>0) or (AddType='') then
              Begin
                DoneReading:=True;
                LinkedExcelForm.Memo1.Lines.Add('--- READ SUCCESSFULLY COMPLETED ---');
              End;

            If (Not DoneReading) and (ColIndex = StartColIndex) then
              Begin
                LinkedExcelForm.Memo1.Lines.Add('ERROR:  Don''t Recognize Command: "' + ADDTYPE +'" or Error while processing this command.');
                DoneReading := True;
              End;

          Until DoneReading;
        Finally
          Wbk.Close(False,EmptyParam,EmptyParam,LCID);
        End;
      FINALLY
        Excel.Quit;
        WaitDlg.Hide;
        Hide;
        Button1.Enabled := True;

        ShowModal;
        LinkedExcelForm.Free;
      END;

    End;
End;

{$R *.dfm}

procedure TLinkedExcelForm.Button2Click(Sender: TObject);
begin
  Memo1.SelectAll;
  Memo1.CopyToClipboard;
  {}
end;

end.
