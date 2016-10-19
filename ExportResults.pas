//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit ExportResults;

interface

Uses Dialogs, DBTables, AQUAOBJ, AQStudy, LinkedSegs, Global, Variants,
     GraphChc, OleCtrls;

Procedure ExportResults1(SaveDialog1: TSaveDialog; ControlExport: Boolean;
                         ExportTable: TTable; OStudy: TAQUATOXSegment; InFileN: String);

Procedure ExportLinkedResults(SaveDialog1: TSaveDialog; ControlExport: Boolean;
                        LS: TLinkedSegs;LinkExportTable: TTable; InFileN: String);

{---------------------------------------------------------------------------------------}

implementation

Uses Controls, Wait, ActiveX, Windows, SysUtils, DB, Forms, Basins, ExcelFuncs, Excel2000;

Procedure ExportResults1(SaveDialog1: TSaveDialog; ControlExport: Boolean;
                         ExportTable: TTable; OStudy: TAQUATOXSegment; InFileN: String);

Type TExportType = (DB,DBF,CSV,XT_EXCEL);
Var Extension,FileName,OutDir,OutFile     : String;
    FileLoop, Loop, NumFields, CurrHeaderIndex, TopIndex,
    OuterLoop, Num_To_Write, BottomHeader : Integer;
    OutResults : ResultsType;
    PR         : TResults;
    DP         : TDataPoint;
    SegLoop    : VerticalSegments;
    PH         : TResHeader;
    CSVFile    : TextFile;
    ExportType : TExportType;
    DBFQuery   : TQuery;
    ExcelRow,ExcelCol,MaxFields  : Integer;
    LastString,XLSFileName : String;
    ExportGenScn: Boolean;
    TEx: TExcelOutput;

            {-------------------------------------------------------------------------------}
            Function DisplayGraphChoiceDlg:Boolean;
            Var I: Integer;
                MR: TModalResult;
            Begin
              DisplayGraphChoiceDlg := False;

              {Clear the graphing choice dialog}
              GraphChoiceDlg.SourceList.Clear;
              GraphChoiceDlg.DstList.Clear;

              {SETUP AND DISPLAY THE RESULTS THAT CAN BE EXPORTED}

              GraphChoiceDlg.Caption := 'AQUATOX-- Select Results to Export';
              GraphChoiceDlg.DstLabel.Caption := 'Results to Export:';
              If GenScnInstalled then GraphChoiceDlg.GenScnButton.Visible := True;

              If ControlExport then OutResults:=OStudy.SV.ControlResults
                               else OutResults:=OStudy.SV.Results;

              For I := 0 to OutResults[Epilimnion].Headers.Count-1 do
                Begin
                  PH := OutResults[Epilimnion].Headers.At(I);
                  GraphChoiceDlg.MasterList.Add(PH.ListStr(False));
                End;

              ExportGenScn := False;
              Mr := GraphChoiceDlg.ShowModal;
              GraphChoiceDlg.GenScnButton.Visible := False;
              If Mr = MrCancel then Exit;
              If Mr = MrYes then
                Begin
                  ExportGenScn := True;
                  Exit;
                End;

              NumFields := GraphChoiceDlg.DstList.Items.Count;
              If NumFields < 1 then
                Begin
                  MessageDlg('You have not selected any results to export.',mterror,[mbOK],0);
                  Exit;
                End;

              DisplayGraphChoiceDlg := True;

            End;
            {-------------------------------------------------------------------------------}
            Procedure SetupOutputDatabase(Num: Integer);
            Begin
              OutDir:=ExtractFilePath(FileName);
              OutFile:=ExtractFileName(FileName);
              If SegLoop=Hypolimnion then Outfile:='Hyp_'+Outfile;

              Extension := LowerCase(ExtractFileExt(FileName));

              MaxFields := 1000;
              Case ExportType of
                 DBF      : MAXFIELDS:=200;
                 DB,XT_EXCEL : MAXFIELDS:=250;
                End; {case}

              If (SaveDialog1<>nil) and (Num=1) and (NumFields>MAXFIELDS) and (ExportType<>XT_Excel) and (SegLoop=Epilimnion) then
                  MessageDlg('The export will be broken up into more than one file as it has over '+
                     IntToStr(MaxFields)+' fields.',mtinformation,[mbOK],0);

              WaitDlg.Update;

              If (Num>1) then
                Begin
                  Delete(OutFile,Pos(Extension,Lowercase(OutFile)),Length(Extension));
                  OutFile:=OutFile+IntToStr(Num)+Extension;
                End;
            End;
            {-------------------------------------------------------------------------------}
            Function SetupTable(Tab: TTable; Nm: ShortString): Boolean;
            Var TabName: String;
            Begin
             Result := True;
             If ExportType = CSV then
               Begin
                 ASSIGNFILE(CSVFile,Nm);
                 Rewrite(CSVFile);
                 Write(CSVFile,'Date,');
                 Write(CSVFile,'Time,');
                 Exit;
               End;

             If ExportType = XT_EXCEL then
               Begin
                 Coinitialize(nil);
                 If (FileLoop=1) and (SegLoop = Epilimnion)
                   then
                     Begin
                       TEx := TExcelOutput.Create(False);
                       If Not TEx.OpenFiles then
                         Begin
                           TEx := nil;
                           Raise EAQUATOXError.Create('Error Exporting Results');
                         End;
                       TEx.FileN := OutDir + Nm;
                     End
                   else TEx.WS := TEx.Wbk.Sheets.Add(EmptyParam,TEx.Wbk.sheets.item[TEx.Wbk.sheets.count],1,xlWorkSheet,TEx.LCID) as _Worksheet;

                 TabName := 'AQUATOX Export';
                 If FileLoop>1 then TabName := 'AQUATOX' + '('+IntToStr(FileLoop)+')';
                 If SegLoop = Hypolimnion then TabName := TabName + ' Hypolimnion';
                 TEx.WS.Name := TabName;

                 TEx.WS.Cells.Item[1,1].Value := 'Date:';
                 TEx.WS.Cells.Item[2,1].Value := 'Time:';

                 Exit;
               End;

             If ExportType in [DBF,DB] then
              With Tab do
               Begin
                Active:=False;
                DatabaseName:=OutDir;
                TableName:=Nm;

                If ExportType = DBF then TableType:=ttDBase
                                    else TableType:=ttParadox;

               {Clear Table Structure}
               FieldDefs.Clear;
               IndexDefs.Clear;
               FieldDefs.Add('Date',ftDate,0,False);
               FieldDefs.Add('Time',ftTime,0,False);

               If ExportType = DBF then
                 Begin
                   CreateTable;
                   DBFQuery := TQuery.Create(nil);
                   with DBFQuery do
                     begin
                       DatabaseName := OutDir;
                       Close;
                       with SQL do
                         begin
                           Clear;
                           Add('ALTER TABLE "'+Nm+'"');
                         end; {with SQL}
                     end; {with DBFQuery}
                 End;
              End; {with Tab}
            End; {SetupTable}
            {-------------------------------------------------------------------------------}
            Procedure MakeExportEntry(Var T:TTable; N: Integer; RC: TResultsCollection);
            Var Name: String;
                TFD : TFieldDef;
                PH2 : TResHeader;
            Begin
              PH2 :=RC.Headers.At(N);
              Name:=PH2.ListStr(ExportType = DBF);

              {If Name<>'Undisplayed' then }
                If ExportType = CSV
                  then Begin
                         While Pos(',',Name)>0 do
                           Delete(Name,Pos(',',Name),1);
                         Write(CSVFile,Name+',');
                       End
                  else If ExportType = XT_EXCEL
                    then
                      Begin
                        Inc(ExcelCol);
                        TEx.WS.Cells.Item[1,ExcelCol+1].Value := Name;
                      End
                  else If ExportType = DBF
                     then
                       Begin
                         ProcessDBFName(Name, @DBFQuery.SQL);
                         DBFQuery.SQL.Add('ADD "'+T.TableName+'"."'+Name+'" NUMERIC(20,15),')
                       End
                     else
                       Begin
                         TFD := T.FieldDefs.AddFieldDef;
                         TFD.Name := Name;
                         TFD.DataType := FtFloat;
                       End;
            End;
            {-------------------------------------------------------------------------------}
Var EFE, BaseName, CAdd: String;
Begin
  DBFQuery := nil;
  TEx := nil;
  TeaseInc:=1;

  Application.CreateForm(TGraphChoiceDlg, GraphChoiceDlg);

  Try

  If SaveDialog1=nil
    then Begin
           FileName := InFileN;
           ExportType := CSV;
           If ControlExport then OutResults:=OStudy.SV.ControlResults
                            else OutResults:=OStudy.SV.Results;
           NumFields := OutResults[Epilimnion].Headers.Count
         End
    else
      Begin
        If not DisplayGraphChoiceDlg then
          Begin
            If ExportGenScn then LBasinsInfo.ExportGenScn(False,OStudy,nil);
            Exit;
          End;

        SaveDialog1.Title:='Export Results As:';

        BaseName := ExtractFileName(OStudy.FileName);
        Delete(BaseName,Length(BaseName)-3,4);
        If ControlExport then Cadd := '_C' else CAdd:='';
        SaveDialog1.FileName := {OStudy.DirName + }BaseName + '_Export'+CAdd+'.xls';
        SaveDialog1.Filter := 'Excel Format (*.xls*)|*.XLS*|Paradox Format (*.db)|*.DB|DBase Format (*.dbf)|*.DBF|Comma Separated (*.csv)|*.CSV';
        SaveDialog1.FilterIndex := 1;
        If not SaveDialog1.Execute then exit;
        FileName:=SaveDialog1.FileName;

        EFE := Lowercase(ExtractFileExt(FileName));
        If (EFE <> '.db') and (EFE <> '.dbf') and (EFE <> '.xls')
          and (EFE <> '.xls') and (EFE <> '.csv')  then
            Case SaveDialog1.FilterIndex of
               2: FileName:=FileName+'.db';
               3: FileName:=FileName+'.dbf';
               1: FileName:=FileName+'.xls';
               else FileName:=FileName+'.csv';
             End; {Case}

       If FileExists(SaveDialog1.FileName) then If Not DeleteFile(SaveDialog1.FileName)
         then Begin
                If (SaveDialog1<>nil) then MessageDlg('Cannot gain exclusive access to the file to overwrite it.',mtError,[mbOK],0);
                Exit;
              End;

        Case SaveDialog1.FilterIndex of
           2: ExportType := DB;
           3: ExportType := DBF;
           1: ExportType := XT_Excel;
           else ExportType := CSV;
         End; {Case}
     End;

  WaitDlg.Setup('Please Wait One Moment, Exporting Data');

TRY
  FOR SegLoop:=Epilimnion to Hypolimnion DO
    Begin
      BottomHeader := 0;

      If (OutResults[SegLoop].Count > 0) then
        Begin
          SetupOutputDatabase(1);

          For FileLoop:=1 to (((NumFields-1) div (MAXFIELDS-1))+1) do
            Begin
              If (FileLoop>1) then SetupOutputDatabase(FileLoop);
              SetupTable(ExportTable,OutFile);

              {Calculate Top Field for this File}
              If NumFields < (FileLoop*(MAXFIELDS-1))
                 then TopIndex :=(NumFields mod (MAXFIELDS-1))
                 else TopIndex := MAXFIELDS-1;

              ExcelCol := 1;
              ExcelRow := 0;
              {Create Appropriate Fields to Export}
              CurrHeaderIndex:=BottomHeader-1;
              For Loop := 1 to TopIndex do
                Begin
                  Repeat
                    Inc(CurrHeaderIndex);
                    PH := OutResults[Epilimnion].Headers.At(CurrHeaderIndex);
                  Until (SaveDialog1=nil) or (GraphChoiceDlg.DstList.Items.IndexOf(PH.ListStr(False))>-1);

                  MakeExportEntry(ExportTable,CurrHeaderIndex,OutResults[SegLoop]);
                End;

              If ExportType in [DB,DBF] then
                Begin
                  If ExportType = DBF
                    then With DBFQuery.SQL do
                      Begin
                        LastString := Strings[Count-1]; {trim comma after last entry}
                        SetLength(LastString,Length(LastSTring)-1);
                        Strings[Count-1] := LastString;
                        DBFQuery.ExecSQL;   {add fields with appropriate scale}
                      End
                    else ExportTable.CreateTable;

                  ExportTable.Active:=True;
                End;

              If ExportType=CSV then WriteLn(CSVFile);
              If ExportType = XT_Excel then
                Begin
                  Inc(ExcelRow);
                  ExcelCol:=1;
                End;

              {Write the datapoints into the Export Table}
              Num_to_Write := OutResults[SegLoop].Count-1;

              For OuterLoop:=0 to Num_to_Write do
                Begin
                  PR  :=OutResults[SegLoop].At(OuterLoop);
                  Case ExportType of
                    DB,DBF: Begin
                              ExportTable.Append;
                              ExportTable.Fields[0].AsDateTime:=PR.Date;
                              ExportTable.Fields[1].AsDateTime:=PR.Date;
                            End;
                    CSV: Begin
                            Write(CSVFile,DateToStr(PR.Date),', ');
                            Write(CSVFile,TimeToStr(PR.Date));
                         End;
                    else Begin
                           TEx.WS.Cells.Item[ExcelRow+1,1].Value := DateToStr(PR.Date);
                           TEx.WS.Cells.Item[ExcelRow+1,ExcelCol+1].Value := TimeToStr(PR.Date);
                         End;
                  End; {Case}

                  CurrHeaderIndex:=BottomHeader-1;
                  For Loop := 1 to TopIndex do
                    Begin
                      Repeat
                        Inc(CurrHeaderIndex);
                        PH := OutResults[Epilimnion].Headers.At(CurrHeaderIndex);
                      Until (SaveDialog1=nil) or (GraphChoiceDlg.DstList.Items.IndexOf(PH.ListStr(False))>-1);
                      DP := PR.DataPoints.At(PH.PointIndex);
                      Case ExportType of
                        CSV: Write(CSVFile,',' + FloatToStr(DP.State));
                        DB,DBF: TFloatField(ExportTable.Fields[Loop+1]).AsFloat := DP.State;
                        Else Begin
                               Inc(ExcelCol);
                               TEx.WS.Cells.Item[ExcelRow+1,ExcelCol+1].Value := DP.State;
                             End;
                      End; {Case}
                    End;

                  Case ExportType of
                    CSV: Writeln(CSVFile);
                    DB,DBF: ExportTable.Post;
                    Else Begin Inc(ExcelRow);ExcelCol := 1; End;
                  End; {Case}

                  Inc(TeaseInc);
                  If TeaseInc=3 then Begin WaitDlg.Tease; TeaseInc:=1; End;
                End;

              If ExportTable <> nil then
                Begin
                  ExportTable.Active:=False;
                  ExportTable.Close;
                End;

              If ExportType=CSV then CloseFile(CSVFile);

              If ExportType = XT_Excel then
                Begin
                   TEx.WS.Range['A1', 'A1'].EntireColumn.NumberFormat := 'm/d/yyyy';
                   TEx.WS.Range['B1', 'B1'].EntireColumn.NumberFormat := 'h:mm AM/PM';

                   TEx.WS.Cells.Item[2,2].Select;
                   TEx.Excel.ActiveWindow.FreezePanes := True;

                End;


              BottomHeader:=CurrHeaderIndex+1;  {For next File}

           End; {FileLoop}

       END; {If Not NoResults}
  END; {For SegLoop:=Epilimnion to Hypolimnion}

    If ExportType = XT_Excel then
      Begin
        TEx.WS := TEx.Excel.Worksheets.Item[1] as _Worksheet;
        TEx.WS.Activate(TEx.LCID) ;
        TEx.SaveandClose;
      End;

    WaitDlg.Hide;
    If SaveDialog1 <> nil then MessageDlg('Export Completed Successfully.',mtinformation,[mbok],0);
    DBFQuery.Free;

  EXCEPT
     If ExportTable <> nil then
       Begin
         ExportTable.Active:=False;
         ExportTable.Close;
       End;

     If TEx<>nil then TEx.CloseFiles;

     DBFQuery.Free;
     WaitDlg.Hide;
     Raise;
  END;

  Finally
    GraphchoiceDlg.Free;
  End;


End;


{------------------------------------------------------------------------------------------}


{                                        LINKED EXPORT BELOW                               }


{------------------------------------------------------------------------------------------}

procedure ExportLinkedResults(SaveDialog1: TSaveDialog; ControlExport: Boolean;
                        LS: TLinkedSegs;LinkExportTable: TTable; InFileN: String);

Type TExportType = (DB,DBF,CSV,XT_EXCEL);
Var Extension,FileName,OutDir,OutFile     : ShortString;
    NumFields, CurrHeaderIndex, TopIndex, BottomSegInd,
    BottomHeader,Num_To_Write : Integer;
    OutResults : ResultsType;
    DBFQuery   : TQuery;
    PR         : TResults;
    DP         : TDataPoint;
    ExportType : TExportType;
    SegCount   : Integer;
    PH         : TResHeader;
    CSVFile    : TextFile;
    ExcelRow,ExcelCol,MaxFields  : Integer;
    AQTS       : TAQUATOXSegment;
    LastString : String;
    FieldHeaders: Array[1..1001] of String;
    SegIndex: Integer;
    {Excel Vars}
    TEx: TExcelOutput;

            {-------------------------------------------------------------------------------}
            Function DisplayGraphChoiceDlg:Boolean;
            Var I: Integer;
            Begin
              DisplayGraphChoiceDlg := False;

              {Setup GraphChoice Dialog}
              GraphChoiceDlg.IncAllBtn.Enabled := True;

              {Clear the graphing choice dialog}
              GraphChoiceDlg.SourceList.Clear;
              GraphChoiceDlg.DstList.Clear;

              {SETUP AND DISPLAY THE RESULTS THAT CAN BE EXPORTED}
              If ControlExport
                then GraphChoiceDlg.Caption := 'Linked AQUATOX-- Select Control Results to Export'
                else GraphChoiceDlg.Caption := 'Linked AQUATOX-- Select Perturbed Results to Export';

              GraphChoiceDlg.DstLabel.Caption := 'Results to Export:';

              AQTS := LS.SegmentColl.At(0);
              If ControlExport then OutResults:=AQTS.SV.ControlResults
                               else OutResults:=AQTS.SV.Results;

              For I := 0 to OutResults[Epilimnion].Headers.Count-1 do
                Begin
                  PH := OutResults[Epilimnion].Headers.At(I);
                  GraphChoiceDlg.MasterList.Add(PH.HeadStr);
                End;

{              because of rates files there can be different #s of vars in each seg...  causing crash? }

              If GraphChoiceDlg.ShowModal=MrCancel then Exit;
              NumFields := GraphChoiceDlg.DstList.Items.Count;
              If NumFields < 1 then
                Begin
                  MessageDlg('You have not selected any results to export.',mterror,[mbOK],0);
                  Exit;
                End;

              DisplayGraphChoiceDlg := True;
            End;
            {-------------------------------------------------------------------------------}
            Procedure SetupOutputDatabase(Num: Integer);
            Begin
              AQTS := LS.SegmentColl.At(0);
              If ControlExport then OutResults:=AQTS.SV.ControlResults
                               else OutResults:=AQTS.SV.Results;

              OutDir:=ExtractFilePath(FileName);
              OutFile:=ExtractFileName(FileName);

              Extension := LowerCase(ExtractFileExt(Outfile));

              MaxFields := 1000;
              Case ExportType of
                 DBF        : MAXFIELDS:=200;
                 DB,XT_Excel   : MAXFIELDS:=250;
                End; {case}

              If (Num=1) and (NumFields*SegCount>MAXFIELDS) and (ExportType<>XT_Excel) then
                  If (SaveDialog1<>nil) then MessageDlg('The export will be broken up into more than one file as it has over '+
                     IntToStr(MaxFields)+' fields.',mtinformation,[mbOK],0);

              WaitDlg.Update;

              If Num>1 then
                Begin
                  Delete(OutFile,Pos(Extension,Lowercase(OutFile)),Length(Extension));
                  OutFile:=OutFile+IntToStr(Num)+Extension;
                End;
            End;
            {-------------------------------------------------------------------------------}
            Function SetupTable(Tab: TTable; Nm: ShortString; Num: Integer): Boolean;
            Var TabName: String;
            Begin
             Result := True;
             If ExportType = CSV then
               Begin
                 ASSIGNFILE(CSVFile,Nm);
                 Rewrite(CSVFile);
                 Write(CSVFile,'Date,');
                 Exit;
               End;

             If ExportType = XT_EXCEL then
               Begin
                 Coinitialize(nil);

                 If (Num=1)
                   then
                     Begin
                       TEx := TExcelOutput.Create(False);
                       If Not TEx.OpenFiles then
                         Begin
                           TEx := nil;
                           Raise EAQUATOXError.Create('Error Exporting Results');
                         End;
                       TEx.FileN := OutDir + Nm;
                     End
                   else TEx.WS := TEx.Wbk.Sheets.Add(EmptyParam,TEx.Wbk.sheets.item[TEx.Wbk.sheets.count],1,xlWorkSheet,TEx.LCID) as _Worksheet;

                 TabName := 'AQUATOX Export';
                 If Num>1 then TabName := 'AQUATOX' + '('+IntToStr(Num)+')';
                 TEx.WS.Name := TabName;

                 TEx.WS.Cells.Item[1,1].Value := 'Date:';
                 TEx.WS.Cells.Item[2,1].Value := 'Time:';

                 Exit;
               End;

             If ExportType in [DBF,DB] then
               With Tab do
                Begin
                  Active:=False;
                  DatabaseName:=OutDir;
                  TableName:=Nm;

                  If ExportType = DBF then TableType:=ttDBase
                                      else TableType:=ttParadox;

                 {Clear Table Structure}
                 FieldDefs.Clear;
                 IndexDefs.Clear;
                 FieldDefs.Add('Date',ftDate,0,False);

                 If ExportType = DBF  then
                   Begin
                     CreateTable;
                     DBFQuery := TQuery.Create(nil);
                     with DBFQuery do
                       begin
                         DatabaseName := OutDir;
                         Close;
                         with SQL do
                           begin
                             Clear;
                             Add('ALTER TABLE "'+Nm+'"');
                           end; {with SQL}
                       end; {with DBFQuery}
                   End;
                end; {with Tab}
            End; {SetupTable}
            {-------------------------------------------------------------------------------}
            Procedure MakeExportEntry(Var T:TTable; N: Integer; RC: TResultsCollection; SegID: String);
            Var Name: String;
                TFD : TFieldDef;
                PH2 : TResHeader;
            Begin
              PH2 :=RC.Headers.At(N);
              Name:=PH2.ListStr(ExportType = DBF);

              {If Name<>'Undisplayed' then }
                Begin
                  Name := SegID + '_'+ Name;
                  If ExportType = CSV
                    then Begin
                           While Pos(',',Name)>0 do
                             Delete(Name,Pos(',',Name),1);
                           Write(CSVFile,Name+',');
                         End
                    else If ExportType = XT_Excel
                      then
                        Begin
                         Name := 'S' + Name; Inc(ExcelCol);
                         TEx.WS.Cells.Item[1,ExcelCol+1].Value := Name;
                        End
                    else If ExportType = DBF
                       then
                         Begin
                           Name := 'S' + Name;
                           ProcessDBFName(Name, @DBFQuery.SQL);
                           DBFQuery.SQL.Add('ADD "'+T.TableName+'"."'+Name+'" NUMERIC(20,15),')
                         End
                       else
                         Begin
                           TFD := T.FieldDefs.AddFieldDef;
                           TFD.Name := Name;
                           TFD.DataType := FtFloat;
                         End;
                End;
            End;
            {-------------------------------------------------------------------------------}

    Procedure Doit;
    Var FileLoop, Loop, OuterLoop: Integer;
        Found: Boolean;
    Begin
      TEx := nil;
      SegCount := LS.SegmentColl.Count;
      DBFQuery := nil;

      TeaseInc:=1;

      If SaveDialog1=nil
         then Begin
                FileName := InFileN;
                ExportType := CSV;
                AQTS := LS.SegmentColl.At(0);
                If ControlExport then OutResults:=AQTS.SV.ControlResults
                                 else OutResults:=AQTS.SV.Results;
                NumFields := OutResults[Epilimnion].Headers.Count
              End
         else
           Begin
              If not DisplayGraphChoiceDlg then Exit;

              SaveDialog1.Title:='Export Results As:';
              SaveDialog1.InitialDir := ''; // Output_Dir;
              SaveDialog1.FileName := '';
              SaveDialog1.Filter := 'Excel Format (*.xls*)|*.XLS*|Paradox Format (*.db)|*.DB|DBase Format (*.dbf)|*.DBF|Comma Separated (*.csv)|*.CSV';

              If not SaveDialog1.Execute then exit;
              FileName:=SaveDialog1.FileName;

             If FileExists(SaveDialog1.FileName) then If Not DeleteFile(SaveDialog1.FileName)
               then Begin
                      If (SaveDialog1<>nil) then MessageDlg('Cannot gain exclusive access to the file to overwrite it.',mtError,[mbOK],0);
                      Exit;
                    End;

              If ExtractFileExt(FileName) = '' then
                  Case SaveDialog1.FilterIndex of
                     2: FileName:=FileName+'.db';
                     3: FileName:=FileName+'.dbf';
                     1: FileName:=FileName+'.xls';
                     else FileName:=FileName+'.csv';
                   End; {Case}

              Case SaveDialog1.FilterIndex of
                 2: ExportType := DB;
                 3: ExportType := DBF;
                 1: ExportType := XT_Excel;
                 else ExportType := CSV;
               End; {Case}
           End; {SaveDlg not nil}

    If ControlExport
      then WaitDlg.Setup('Please Wait One Moment, Exporting Control Results')
      else WaitDlg.Setup('Please Wait, Exporting Perturbed Results');

    TRY
        BottomSegInd := 0;
        BottomHeader := 0;

        If (OutResults[Epilimnion].Count > 0) then
          Begin
            SetupOutputDatabase(1);

            For FileLoop:=1 to ((((NumFields*SegCount)-1) div (MAXFIELDS-1))+1) do
              Begin
                If (FileLoop>1) then SetupOutputDatabase(FileLoop);
                SetupTable(LinkExportTable,OutFile,FileLoop);

                {Calculate Top Field for this File}
                If (NumFields*SegCount) < (FileLoop*(MAXFIELDS-1))
                   then TopIndex :=((NumFields*SegCount) mod (MAXFIELDS-1))
                   else TopIndex := MAXFIELDS-1;

                ExcelCol := 0;
                ExcelRow := 0;

                {Create Appropriate Fields to Export (labels in Excel file)}
                SegIndex := BottomSegInd;
                CurrHeaderIndex:= BottomHeader-1;
                If BottomHeader<>0 then   {IF not the first File or Page written}
                      Repeat
                        Inc(CurrHeaderIndex);  {Find the current header}
                        PH := OutResults[Epilimnion].Headers.At(CurrHeaderIndex);
                      Until (SaveDialog1=nil) or (GraphChoiceDlg.DstList.Items.IndexOf(PH.HeadStr)>-1);

                For Loop := 1 to TopIndex do  {Top Index in this page or file}
                  Begin
                    Inc(SegIndex);
                    If SegIndex>SegCount then SegIndex := 1;     {Find Relevant Result in order of Sorted Headers}
                    If SegIndex=1 then
                      Repeat
                        Inc(CurrHeaderIndex);
                        PH := OutResults[Epilimnion].Headers.At(CurrHeaderIndex);
                      Until (SaveDialog1=nil) or (GraphChoiceDlg.DstList.Items.IndexOf(PH.HeadStr)>-1);

                    AQTS := LS.SegmentColl.At(SegIndex-1);
                    MakeExportEntry(LinkExportTable,CurrHeaderIndex,OutResults[Epilimnion],AQTS.SegNumber);
                    FieldHeaders[Loop] := PH.HeadStr;
                  End;

              If ExportType in [DB,DBF] then
                Begin
                  If ExportType = DBF
                     then With DBFQuery.SQL do
                           Begin
                             LastString := Strings[Count-1]; {trim comma after last entry}
                             SetLength(LastString,Length(LastString)-1);
                             Strings[Count-1] := LastString;
                             DBFQuery.ExecSQL;   {add fields with appropriate scale}
                           End
                         else LinkExportTable.CreateTable;
                         LinkExportTable.Active:=True;
                End;

              If ExportType=CSV then WriteLn(CSVFile);
              If ExportType = XT_Excel then
                Begin
                  Inc(ExcelRow);
                  ExcelCol:=0;
                End;


                Num_to_Write:=999999;  {find seg with fewest number of dates, write that number... all segs should have an equal number}
                For OuterLoop := 0 to SegCount-1 do
                  Begin
                    AQTS := LS.SegmentColl.At(OuterLoop);
                    If ControlExport then OutResults:=AQTS.SV.ControlResults
                                     else OutResults:=AQTS.SV.Results;
                    If Num_to_Write > OutResults[Epilimnion].Count-1 then
                       Num_to_Write := OutResults[Epilimnion].Count-1;   {Number of Date Fields to write}
                  End;

                CurrHeaderIndex:= BottomHeader-1;
                {Write the datapoints into the Export Table}
                For OuterLoop:=0 to Num_to_Write do {Number of Date Fields to write}
                  Begin
                    PR := OutResults[Epilimnion].At(OuterLoop);

                    Case ExportType of       {WRITE THE DATE}
                      DB,DBF: Begin
                                LinkExportTable.Append;
                                LinkExportTable.Fields[0].AsDateTime:=PR.Date;
                              End;
                      CSV: Write(CSVFile,DateToStr(PR.Date));
                      else TEx.WS.Cells.Item[ExcelRow+1,ExcelCol+1].Value := PR.Date;
                     { else XLSWrite1.WriteNumber(ExcelCol,ExcelRow,0,PR.Date); }
                    End; {Case  WRITE THE DATE}

                    SegIndex := BottomSegInd;
                    For Loop := 1 to TopIndex do  {loop through number of output fields}
                      Begin
                        Inc(SegIndex);  {move through segments one-by-one}
                        If SegIndex>SegCount then SegIndex := 1;

                        AQTS := LS.SegmentColl.At(SegIndex-1);
                        If ControlExport then OutResults:=AQTS.SV.ControlResults
                                         else OutResults:=AQTS.SV.Results;

                        CurrHeaderIndex := -1;
                        Found := False;
                        If (CurrHeaderIndex < OutResults[Epilimnion].Headers.Count-1) then
                          Repeat
                            Inc(CurrHeaderIndex);
                            PH := OutResults[Epilimnion].Headers.At(CurrHeaderIndex);
                            Found := FieldHeaders[Loop]= PH.Headstr;
                          Until Found or (CurrHeaderIndex = OutResults[Epilimnion].Headers.Count-1);

                        If Found then
                          Begin
                            PR := OutResults[Epilimnion].At(OuterLoop);
                            DP := PR.DataPoints.At(PH.PointIndex);
                          End;

                        If Found then
                            Case ExportType of
                              CSV: Write(CSVFile,',' + FloatToStr(DP.State));
                              DB,DBF: TFloatField(LinkExportTable.Fields[Loop]).AsFloat := DP.State;
                              Else Begin
                                     Inc(ExcelCol);
                                     TEx.WS.Cells.Item[ExcelRow+1,ExcelCol+1].Value := DP.State;
                                   End;
                            End; {Case}

                        If Not Found then
                            Case ExportType of
                              CSV: Write(CSVFile,', N A');
                              XT_Excel:
                                   Begin
                                     Inc(ExcelCol);
                                     TEx.WS.Cells.Item[ExcelRow+1,ExcelCol+1].Value := 'N A';
                                   End;
                            End; {Case}
                      End;

                    Case ExportType of
                      CSV: Writeln(CSVFile);
                      DB,DBF: LinkExportTable.Post;
                      Else Begin Inc(ExcelRow);ExcelCol := 0; End;
                    End; {Case}

                    Inc(TeaseInc);
                    If TeaseInc=3 then Begin WaitDlg.Tease; TeaseInc:=1; End;
                  End;

                If LinkExportTable <> nil then
                  Begin
                    LinkExportTable.Active:=False;
                    LinkExportTable.Close;
                  End;  

                If ExportType=CSV then CloseFile(CSVFile);

              If ExportType = XT_Excel then
                Begin
                   TEx.WS.Range['A1', 'A1'].EntireColumn.NumberFormat := 'm/d/yyyy';

                   TEx.WS.Cells.Item[2,2].Select;
                   TEx.Excel.ActiveWindow.FreezePanes := True;
                 End;

                BottomSegInd := SegIndex;  {for next file}
                BottomHeader := CurrHeaderIndex;

             End; {FileLoop}

         END; {If There are Results}

      If ExportType = XT_Excel then TEx.SaveandClose;
       WaitDlg.Hide;
      If (SaveDialog1<>nil) then MessageDlg('Export Completed Successfully.',mtinformation,[mbok],0);
      DBFQuery.Free;

      EXCEPT

        If LinkExportTable <> nil then
          Begin
            LinkExportTable.Active:=False;
            LinkExportTable.Close;
          End;

         WaitDlg.Hide;

         If TEx<>nil then TEx.CloseFiles;
         DBFQuery.Free;
         GraphChoiceDlg.Free;
         Raise;
      END;

    End;

Begin
  Application.CreateForm(TGraphChoiceDlg, GraphChoiceDlg);
  Doit;
  GraphChoiceDlg.Free;
End;


end.
