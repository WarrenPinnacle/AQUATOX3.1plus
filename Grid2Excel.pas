unit Grid2Excel;

interface

Uses Grids, DBGrids;

Procedure StringGrid2Excel(TG: TStringGrid; GridContents: String);

Procedure DBGrid2Excel(DBGrd: TDBGrid; BaseName: String; IsType2: Boolean);

implementation

uses ChangVar, variants, Excel2000, ActiveX, Windows, SysUtils, ComCtrls,Comobj, Dialogs,
     WinTypes, WinProcs, Messages, Classes, Controls, ExcelFuncs, DBTables, DB, Wait, DBGrids2;

Procedure StringGrid2Excel(TG: TStringGrid; GridContents: String);


Var SaveDialog1: TSaveDialog;
    i,j: Integer;
    Name: String;
    lcid: integer;
    Res: variant;
    WBk: _WorkBook;
    WS: _Worksheet;
    Excel: _Application;
    Unknown: IUnknown;
    AppWasRunning: boolean; // tells you if you can close Excel when you've finished

Begin
      // Create save dialog and set it options
      SaveDialog1 := TSaveDialog.Create(nil);
      with SaveDialog1 do
      begin
         DefaultExt := 'xls' ;
         Filter := 'Excel files (*.xls*)|*.xls*|All files (*.*)|*.*' ;
         Options := [ofOverwritePrompt,ofPathMustExist,ofNoReadOnlyReturn,ofHideReadOnly] ;
         Title := 'Please Specify an Excel File into which to Save this Table:';
      end ;

   if not SaveDialog1.Execute then Begin
                                     SaveDialog1.Free;
                                     exit;
                                   End;

   Name := SaveDialog1.FileName;
   If FileExists(SaveDialog1.FileName) then If Not SysUtils.DeleteFile(Name)
     then Begin
            MessageDlg('Cannot gain exclusive access to the file to overwrite it.',mtError,[mbOK],0);
            Exit;
          End;

      lcid := LOCALE_USER_DEFAULT;
      AppWasRunning := False;

      Res := GetActiveObject(CLASS_ExcelApplication, nil, Unknown);
        if (Res <> S_OK) then
          Excel := CoExcelApplication.Create

      else begin
        { make sure no other error occurred during GetActiveObject }
        OleCheck(Res);
        OleCheck(Unknown.QueryInterface(_Application, Excel));
        AppWasRunning := True;
      end;
      Excel.Visible[lcid] := AppWasRunning;

      WBk := Excel.WorkBooks.Add(xlWBATWorksheet,LCID);

      WS := Excel.ActiveSheet as _Worksheet;

   For i:=1 to TG.ColCount do
     Begin
       Name := TG.cells[i-1,0];
       WS.Cells.Item[1,i].Value := Name;
       WS.Cells.Item[1,i].Font.Size := 9;
       WS.Cells.Item[1,i].Font.Bold := True;

       For j:=2 to TG.RowCount do
         Begin
           WS.Cells.Item[j,i].Value := TG.Cells[i-1,j-1];
           WS.Cells.Item[j,i].Borders[xlEdgeLeft].LineStyle := xlSingle;
           WS.Cells.Item[j,i].Borders[xlEdgeTop].LineStyle := xlSingle;
           WS.Cells.Item[j,i].Borders[xlEdgeBottom].LineStyle := xlSingle;
           WS.Cells.Item[j,i].Borders[xlEdgeRight].LineStyle := xlSingle;
         End;
     End;

     WS.Range['A1','Z1'].EntireColumn.AutoFit;
     WS.Cells.Item[2,2].Select;
     Excel.ActiveWindow.FreezePanes := True;

    if StrToFloat(Excel.Version[LCID]) > 11
      Then  Wbk.SaveAs(SaveDialog1.FileName,56,EmptyParam,EmptyParam,EmptyParam
                      ,EmptyParam,xlnochange,EmptyParam,EmptyParam,EmptyParam,EmptyParam,LCID)
      else  Wbk.SaveAs(SaveDialog1.FileName,EmptyParam,EmptyParam,EmptyParam,EmptyParam
               ,EmptyParam,xlnochange,EmptyParam,EmptyParam,EmptyParam,EmptyParam,LCID);

      If MessageDlg(GridContents +' have been exported.  View them now?',mtconfirmation,[mbyes,mbno],0)
        = MRNo then Begin
                      Wbk.Close(False,EmptyParam,EmptyParam,LCID);
                      If not AppWasRunning then Excel.Quit
                    End
               else Excel.Visible[lcid] := True;

   SaveDialog1.Free;
end;

Procedure DBGrid2Excel(DbGrd: TDBGrid; BaseName: String; IsType2: Boolean);
 var
      TEx: TExcelOutput;
      intRow,       // index for query rows
      intCol  : Integer ; // index for query columns
      CurrentColumns : Variant ;   // Sheets to AutoFit
      qry   : TQuery ;  // Query related to dbgrd
      BookMark  : TBookMark ; // Bookmark for query
      DBG2: TDBGrid2;

begin
 // Initialize
   TEx := TExcelOutput.Create(False);

   qry := nil ;
   BookMark := nil ;
   DBG2 := TDBGrid2(dbgrd);

   try
    // Dereference database grid to get datasource and supplying query
      If IsType2
        then qry := TQuery(TDataSource(DBG2.DataSource).DataSet)
        else qry := TQuery(TDataSource(dbgrd.DataSource).DataSet) ;

      // If the query is inactive or record count < 1 then outta here
      if qry.Active = False then  exit ;
      if qry.RecordCount < 1 then exit ;

      // Execute save dialog
      If TEx.GetSaveName(BaseName,'Please Specify an Excel File into which to Save this Table:') then
      begin

       WaitDlg.Setup('Please Wait, Writing Table to Excel File');

         // Insert column headers into sheet
         intRow := 1 ;
         for intCol := 1 to qry.FieldCount do
           Begin
              TEx.WS.Cells.Item[intRow,intCol].Value := qry.Fields[intCol-1].FieldName;
              TEx.WS.Cells.Item[intRow,intCol].Font.FontStyle := 'Bold';
           End;
         WaitDlg.Tease;

         // Disable controls attached to query
         qry.DisableControls ;

         // Save place in query
         BookMark := qry.GetBookmark ;

         // Position to first row
         qry.First ;

         // Insert data into sheet
         while (not qry.EOF) do
         begin
            WaitDlg.Tease;
            inc(intRow) ;
            for intCol := 1 to qry.FieldCount do
            begin
               TEx.WS.Cells.Item[intRow,intCol].Value := qry.Fields[intCol-1].AsString;
               If IntCol=1 then
                 begin
                   WaitDlg.Tease;
                   TEx.WS.Cells.Item[intRow,intCol].Font.FontStyle := 'Bold';
                 end;
            end;

            qry.Next ;
         end ;

         CurrentColumns := TEx.WS.Columns;
         CurrentColumns.AutoFit;

         // Restore position in query
         qry.GotoBookmark(BookMark) ;

         // Free bookmark
         qry.FreeBookmark(BookMark) ;
         BookMark := nil;

         // Enable controls attached to query
         qry.EnableControls ;

         TEx.WS.Cells.Item[2,2].Select;
         TEx.Excel.ActiveWindow.FreezePanes := True;
         TEx.WS.Range['A1','Z1'].EntireColumn.AutoFit;

         TEx.SaveAndClose;

      end;

   WaitDlg.Hide;

   // Exceptions
   except

    on E:Exception do
      begin
         // If Excel was started, quit it.
         try
           TEx.CloseFiles;
           TEx.Close;
         except
         end;
         // Restore position in query and enable controls
         if BookMark <> nil then
         begin
            qry.GoToBookMark(BookMark) ;
            qry.FreeBookMark(BookMark) ;
            qry.EnableControls ;
         end ;

         WaitDlg.Hide;
         // Status user
         MessageDLG('Save Failed: '+E.Message,   mtError,[mbOK],0) ;
      end ;
   end ;
end;
end.
