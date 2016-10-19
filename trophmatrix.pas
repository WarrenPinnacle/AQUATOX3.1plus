unit trophmatrix;

interface

uses
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Global, Aquaobj, StdCtrls, AQSTUDY, AQBaseForm,
  Grids, DBGrids, DB, DBTables, ExtCtrls, Buttons, AQSite, hh;

type
  TEditTrophIntForm = class(TAQBase)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    Export2Excel: TButton;
    HelpButton: TButton;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    ShowPref: TRadioButton;
    ShowEgest: TRadioButton;
    ShowComments: TRadioButton;
    Renormalize: TButton;
    Label2: TLabel;
    Label3: TLabel;
    procedure Export2ExcelClick(Sender: TObject);
    procedure ShowPrefClick(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure StringGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
    procedure StringGrid1Exit(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure RenormalizeClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
  private
    ValStr  : String[60];
    EditRow, EditCol : Integer;
    TempTIs      : Array of TrophIntArray;
    PreyCount, PredCount  : Integer;
    Function ColumnHeader(St: String):Integer;
  public
    AQTStudy: TAQUATOXSegment;  {Variable that holds the main study for reference}
    Changed      : Boolean;
    PredArray, PreyArray  : Array[1..100] of AllVariables;
    Procedure EditTrophMatrix;
    Procedure CopyToTemp;
    Procedure CopyFromTemp;
    Procedure UpdateScreen;
  end;

var
  EditTrophIntForm: TEditTrophIntForm;

implementation

uses ChangVar, variants, Excel2000, ActiveX, SysUtils, ComCtrls,Comobj;

Procedure TEditTrophIntForm.UpdateScreen;
Var i,j: Integer;
    UName,FS: String;
    Val: Double;
begin
 With StringGrid1 do
  Begin
    For i := 0 to RowCount-1 do
      StringGrid1.Rows[i].Clear;

    Rows[0].Add(' ');
    For i := 1 to PredCount do
      Begin
        UName := AQTStudy.SV.UniqueName(PredArray[i]);
        FS := OutputText(PredArray[i],StV,WaterCol,UName,False,False,0);
        Rows[0].Add(FS);
      End;

    For i := 1 to PreyCount do
     Begin
      UName := AQTStudy.SV.UniqueName(PreyArray[i]);
      FS := OutputText(PreyArray[i],StV,WaterCol,UName,False,False,0);
      Rows[i].Add(FS);
      For j := 1 to PredCount do
        Begin
          Val := TempTIs[j-1,PreyArray[i]].Pref;
          If ShowPref.Checked
            then Begin If Val = 0 then FS := '' Else FS := FloattoStrF(Val*100,fffixed,6,1); End
            else if ShowEgest.Checked
              then Begin If Val=0 then FS := '  (na)' Else FS := FloattoStrF(TempTIs[j-1,PreyArray[i]].ECoeff,fffixed,6,2); End
              else FS := TempTIs[j-1,PreyArray[i]].XInteraction;
          Rows[i].Add(FS);
        End;
     End;
  End;
End;

Procedure TEditTrophIntForm.CopyToTemp;
Var PSV: TStateVariable;
    PA : TAnimal;
    PredIndex,i,j,k: Integer;
    loop: AllVariables;
    BlankIF: InteractionFields;
    TPref: TPreference;
    Found: Boolean;

     procedure GetPref(P: TPreference; ns: AllVariables);
     Begin
       If (p.NState=ns) then Begin
                                Found := True;
                                TPref := P;
                              End;
     End;

Begin
   PredCount := 0;
   For i:=0 to AQTStudy.SV.Count-1 do
     Begin
       PSV := AQTStudy.SV.At(i);
       If PSV.IsAnimal then
         Begin
           Inc(PredCount);
           PredArray[PredCount] := PSV.NState;
         End;
     End;
   SetLength(TempTIs,PredCount);

   PreyCount := 2;
   PreyArray[1] := SedmRefrDetr;
   PreyArray[2] := SedmLabDetr;
   For i:=0 to AQTStudy.SV.Count-1 do
     Begin
       PSV := AQTStudy.SV.At(i);
       If (PSV.IsAnimal or PSV.IsPlant or ((PSV.NState in [SuspRefrDetr, SuspLabDetr]) and (PSV.SVType=STV))) then
         Begin
           Inc(PreyCount);
           PreyArray[PreyCount] := PSV.NState;
         End;
     End;

   BlankIF.Pref := 0;
   BlankIF.ECoeff:= 0;
   BlankIF.XInteraction:= '';

   For i := 0 to PredCount-1 do
     For loop := Cohesives to LastBiota do
       TempTIs[i,Loop] := blankif;

   AQTStudy.SV.Zero_Utility_Variables;
   AQTStudy.SV.SetMemLocRec;                   {Set up array of pointers to memory}
   AQTStudy.SV.SetStateToInitConds(false);            {Set up State Variables}
   AQTStudy.SV.NormDiff(-1);

   PredIndex := 0;
   For i:=0 to AQTStudy.SV.Count-1 do
     Begin
       PSV := AQTStudy.SV.At(i);
       If PSV.IsAnimal then
         Begin
           Inc(PredIndex);
           PA := TAnimal(PSV);
           For j:=1 to preycount do
             Begin
               Found := False;
               With PA.MyPrey do
                 For k:=0 to count-1 do
                   GetPref(at(k),PreyArray[j]);
               If Found then
                 Begin
                   TempTIs[PredIndex-1,TPref.nState].Pref := TPref.Preference ;
                   TempTIs[PredIndex-1,TPref.nState].ECoeff := TPref.EgestCoeff ;
                   TempTIs[PredIndex-1,TPref.nState].XInteraction := PA.PTrophint^[TPref.nstate].XInteraction;
                 End;
             End;
         End;
     End;
End;

Procedure TEditTrophIntForm.CopyFromTemp;
Var PSV: TStateVariable;
    PA : TAnimal;
    PredIndex,i,j: Integer;

Begin
   PredIndex := 0;
   For i:=0 to AQTStudy.SV.Count-1 do
     Begin
       PSV := AQTStudy.SV.At(i);
       If PSV.IsAnimal then
         Begin
           Inc(PredIndex);
           PA := TAnimal(PSV);
           For j:=1 to preycount do
             PA.PTrophInt^[PreyArray[j]] := TempTIs[PredIndex-1,PreyArray[j]]
         End;
     End;
End;

Procedure TEditTrophIntForm.EditTrophMatrix;
Var i: Integer;
Begin
 CopyToTemp;
 EditRow := -1;
 EditCol := -1;
 ValStr := '~';

 With StringGrid1 do
  Begin
    ColCount := PredCount+1;
    RowCount := PreyCount+1;

    ColWidths[0]:=130;
    For i:=1 to ColCount-1 do ColWidths[i]:= 70;
  End;

 UpdateScreen;

  WindowState:=WSMaximized;
  If ShowModal = MrCancel then
    Begin
      Changed := False;
      exit;
    End;

  If Changed then CopyFromTemp;
End;

{$R *.DFM}

procedure TEditTrophIntForm.ShowPrefClick(Sender: TObject);
begin
  UpdateScreen;
  StringGrid1.Selection := TGridRect(Rect(0, 0, 0, 0));
end;

procedure TEditTrophIntForm.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  If (ACol>0) and (ARow>0) then
    If ShowEgest.Checked and (TempTIs[ACol-1,PreyArray[ARow]].Pref = 0)
     then
        with StringGrid1.Canvas do
        begin
          Font.Color := clGray;
          TextRect(Rect, Rect.Left + 2, Rect.Top + 2, StringGrid1.Cells[ACol, ARow]);
        end;
end;

procedure TEditTrophIntForm.StringGrid1Exit(Sender: TObject);
Var R,C: Integer;
    V: String;
    Val: Double;
begin
  IF EditRow < 0 then exit;
  If (Trim(ValStr) = '~') then exit;
  R := EditRow; C := EditCol; V := ValStr;
  EditRow := -1; EditCol := -1; ValStr := '~';
  Changed := True;
  If ShowComments.Checked
    then TempTIs[C-1,PreyArray[R]].XInteraction := V
    else Begin
           If Trim(V)='' then Val := 0
                         else Val := StrToFloat(V);
           If ShowPref.Checked then TempTIs[C-1,PreyArray[R]].Pref := Val/100
                               else TempTIs[C-1,PreyArray[R]].ECoeff := Val;
         End;
  UpdateScreen;

end;

procedure TEditTrophIntForm.StringGrid1GetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: string);
begin
  Value := LongRefString(Value);
end;

procedure TEditTrophIntForm.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  If ShowEgest.Checked and (TempTIs[ACol-1,PreyArray[ARow]].Pref = 0) then canselect := False;
  StringGrid1Exit(nil);
end;

procedure TEditTrophIntForm.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  ValStr  := Value;
  EditRow := ARow;
  EditCol := ACol;
end;

Function TEditTrophIntForm.ColumnHeader(St: String):Integer;
Var i: Integer;
Begin
  ColumnHeader := -1;
  For i:=0 to StringGrid1.ColCount-1 do
    If StringGrid1.Cells[i,0] = St then ColumnHeader:=i;
End;

procedure TEditTrophIntForm.Export2ExcelClick(Sender: TObject);
  Var i,j: Integer;
    UName, StateName: String;
    Pref: Double;
    lcid: integer;
    Res: variant;
    WBk: _WorkBook;
    WS: _Worksheet;
    Excel: _Application;
    Unknown: IUnknown;
    AppWasRunning: boolean; // tells you if you can close Excel when you've finished

     procedure GetPref(P: TPreference; ns: AllVariables);
     Begin
       If (p.NState=ns) then Pref := P.Preference; {EgestCoeff}
     End;

Begin
      // Create save dialog and set it options
      with SaveDialog1 do
      begin
         DefaultExt := 'xls' ;
         Filter := 'Excel files (*.xls*)|*.xls*|All files (*.*)|*.*' ;
         Options := [ofOverwritePrompt,ofPathMustExist,ofNoReadOnlyReturn,ofHideReadOnly] ;
         Title := 'Please Specify an Excel File into which to Save this Table:';
      end ;

   if not SaveDialog1.Execute then exit;

   UName := SaveDialog1.FileName;
   If FileExists(SaveDialog1.FileName) then If Not DeleteFile(UName)
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

   For j := 1 to preycount do
     Begin
       UName := AQTStudy.SV.UniqueName(PreyArray[j]);
       StateName := OutputText(PreyArray[j],StV,WaterCol,UName,False,False,0);
       WS.Cells.Item[j+1,1].Value := StateName;
       WS.Cells.Item[j+1,1].Font.Size := 9;
       WS.Cells.Item[j+1,1].Font.Bold := True;
     End;

   For i:=1 to PredCount do
     Begin
       UName := AQTStudy.SV.UniqueName(PredArray[i]);
       StateName := OutputText(PredArray[i],StV,WaterCol,UName,False,False,0);
       WS.Cells.Item[1,i+1].Value := StateName;
       WS.Cells.Item[1,i+1].Font.Size := 9;
       WS.Cells.Item[1,i+1].Font.Bold := True;

       For j:=1 to preycount do
         Begin
           WS.Cells.Item[j+1,i+1].Value := TempTis[i-1,PreyArray[j]].Pref;
           WS.Cells.Item[j+1,i+1].NumberFormat := '#0.0%;0;';
           WS.Cells.Item[j+1,i+1].Borders[xlEdgeLeft].LineStyle := xlThin;
           WS.Cells.Item[j+1,i+1].Borders[xlEdgeTop].LineStyle := xlThin;
           WS.Cells.Item[j+1,i+1].Borders[xlEdgeBottom].LineStyle := xlThin;
           WS.Cells.Item[j+1,i+1].Borders[xlEdgeRight].LineStyle := xlThin;
         End;
     End;

     WS.Range['A1', 'A1'].EntireColumn.AutoFit;
     WS.Cells.Item[2,2].Select;
     Excel.ActiveWindow.FreezePanes := True;

    if StrToFloat(Excel.Version[LCID]) > 11
      Then  Wbk.SaveAs(SaveDialog1.FileName,56,EmptyParam,EmptyParam,EmptyParam
                      ,EmptyParam,xlnochange,EmptyParam,EmptyParam,EmptyParam,EmptyParam,LCID)
      else  Wbk.SaveAs(SaveDialog1.FileName,EmptyParam,EmptyParam,EmptyParam,EmptyParam
               ,EmptyParam,xlnochange,EmptyParam,EmptyParam,EmptyParam,EmptyParam,LCID);

      If MessageDlg('Trophic Interactions have been exported.  View them now?',mtconfirmation,[mbyes,mbno],0)
        = MRNo then Begin
                      Wbk.Close(False,EmptyParam,EmptyParam,LCID);
                      If not AppWasRunning then Excel.Quit
                    End
               else Excel.Visible[lcid] := True;
end;

procedure TEditTrophIntForm.FormDestroy(Sender: TObject);
begin
  TempTIs := Nil;
end;

procedure TEditTrophIntForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic13.htm');
end;

procedure TEditTrophIntForm.RenormalizeClick(Sender: TObject);
Var SumPref: Double;
    i,j: Integer;
begin
   For i := 0 to PredCount -1 do
     Begin
       SumPref := 0;
       For j := 1 to PreyCount do
         SumPref := SumPref + TempTIs[i,PreyArray[j]].Pref;
       If SumPref>0 then
        For j := 1 to PreyCount do
         TempTIs[i,PreyArray[j]].Pref := TempTIs[i,PreyArray[j]].Pref / SumPref;
     End;
   UpdateScreen;
end;

end.

