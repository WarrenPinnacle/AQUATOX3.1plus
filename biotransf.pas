//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit biotransf;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Global, Aquaobj, StdCtrls, AQSTUDY, TCollect, AQBaseForm,
  Grids, DBGrids, DB, DBTables, ExtCtrls, Buttons, AQSite, hh;

type
  TBioTransfForm = class(TAQBase)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel1: TPanel;
    Title: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    StringGrid1: TStringGrid;
    AddSpecies: TButton;
    RemoveSpecies: TButton;
    HelpButton: TButton;
    procedure OKBtnClick(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1Exit(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure AddSpeciesClick(Sender: TObject);
    procedure RemoveSpeciesClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
  private
    { Private declarations }
    Function ColumnHeader(St: String):Integer;
  public
    AQTStudy: TAQUATOXSegment;  {Variable that holds the main study for reference}
    BioTrans     : TCollection;
    Changed      : Boolean;
    ChemName     : String;
    SV           : TStates;
    ChemState    : AllVariables;
    Procedure EditBioTransf;
  end;

var
  BioTransfForm: TBioTransfForm;
  InvalidEntry  : Boolean;
  ColTypes      : Array of BioTransType;
  ColStates     : Array of AllVariables;

implementation

uses ChangVar;


Procedure TBioTransfForm.EditBioTransf;

Var TypLoop   : T_SVType;
    BioRec    : TBioTransObject;
    NewBioRec : TBioTransObject;
    FieldStr  : String;
    i, RowIndex, FieldIndex: Integer;
    Value     : Extended;
    Totals    : Array of Extended;

Begin
 InvalidEntry := False;
 With StringGrid1 do
  begin
     ColWidths[0]:=150;
     ColCount := BioTrans.Count+1;
     For i:=1 to ColCount-1 do ColWidths[i]:= 105; 

     RowCount := 1;

     SetLength(Totals, BioTrans.Count);
     SetLength(ColTypes, BioTrans.Count);
     SetLength(ColStates, BioTrans.Count);

     Rows[0].Clear;
     Rows[0].Add(' ');
     For i := 0 to BioTrans.Count -1 do
       Begin
         FieldStr     := '';
         Totals[i]    := 0;
         BioRec       := BioTrans.At(i);
         ColTypes[i]  := BioRec.BTType;
         ColStates[i] := BioRec.UserSpec;
         Case BioRec.BTType of
           BTAerobicMicrobial   : FieldStr := 'Aerobic Microb.:';
           BTAnaerobicMicrobial : FieldStr := 'Anaerobic:';
           BTAlgae              : FieldStr := 'In Algae:';
           BTBenthInsect        : FieldStr := 'Benthic Insect:';
           BTOtherInvert        : FieldStr := 'Other Invert.:';
           BTFish               : FieldStr := 'In Fish:';
           BTUserSpecified      : FieldStr := OutputText(BioRec.UserSpec,STV,WaterCol,SV.UniqueName(BioRec.UserSpec),False,False,0);
           End; {Case}
         Rows[0].Add(FieldStr);
       End; {Loop}

     For TypLoop := FirstOrgtxTyp to LastOrgtxTyp do {loop through toxicants}
       If (SV.GetStatePointer(AssocToxSV(TypLoop),StV,WaterCol)<> nil)  and
          (AssocToxSV(TypLoop)<>ChemState) then
         Begin
           RowCount := RowCount + 1;
           Rows[RowCount-1].Clear;
           Rows[RowCount-1].Add(SV.ChemPtrs^[TypLoop].ChemRec.ChemName);

           For i := 0 to BioTrans.Count -1 do
             Begin
               BioRec := BioTrans.At(i);
               Rows[RowCount-1].Add(FloatToStr(BioRec.Percent[TypLoop]));
               Totals[i]:= Totals[i] + BioRec.Percent[TypLoop];
             End;
         End;

     RowCount := RowCount + 1;
     Rows[RowCount-1].Clear;
     Rows[RowCount-1].Add('OTHER:');

     For i := 0 to BioTrans.Count -1 do
         Rows[RowCount-1].Add(FloatToStr(100.0-Totals[i]));

     FixedRows := 1;
  End; {with StringGrid1}

  Title.Caption := 'Biotransformation of '+ ChemName +':';
  WindowState:=WSMaximized;
  If ShowModal = MrCancel then
    Begin
      Changed := False;
      exit;
    End;

  BioTrans.FreeAll;
  BioTrans := TCollection.Init(20,20);
  For i := 0 to Length(ColStates)-1 do
   If StringGrid1.Cells[i+1,0] <> 'Deleted' then
     Begin
       NewBioRec := TBioTransObject.Init(ColTypes[i],ColStates[i]);
       BioTrans.Insert(NewBioRec);
     End;

  RowIndex := 0;
  For TypLoop := FirstOrgTxTyp to LastOrgTxTyp do {loop through toxicants}
     If (SV.GetStatePointer(AssocToxSV(TypLoop),StV,WaterCol)<> nil)  and
        (AssocToxSV(TypLoop)<>ChemState) then
         Begin
           FieldIndex:=1;
           Inc(RowIndex);
           For i := 0 to BioTrans.Count -1 do
            If StringGrid1.Cells[i+1,0] <> 'Deleted' then
             Begin
               BioRec := BioTrans.At(i);
               Try
                  Value := StrToFloat(Trim(StringGrid1.Cells[fieldindex,RowIndex]));
               Except
                  Raise EAquatoxError.Create(StringGrid1.Cells[fieldindex,RowIndex]+' is not a valid number.');
               End;
               BioRec.Percent[TypLoop] := Value;
               Inc(FieldIndex);
             End;
         End;

  SV.ChemPtrs^[AssocToxTyp(ChemState)].BioTrans := BioTrans;

End;

{$R *.DFM}

procedure TBioTransfForm.OKBtnClick(Sender: TObject);
begin
  If InvalidEntry
    then MessageDlg('Error, Percentages must sum to 100 and must not be negative.',MTError,[MbOK],0)
     else if Changed then ModalResult := MessageDlg('Save changes to chemicals biotransformation data?',MTConfirmation,[MbOK,MbCancel],0)
                     else ModalResult := MROK;    
end;




procedure TBioTransfForm.StringGrid1KeyPress(Sender: TObject;
  var Key: Char);
{Autocalculate OTHER field}
Var Totals: Array of Extended;
    i, j : integer;
    Value: Extended;
begin
  If not (Word(Key) in [VK_Return,VK_Tab,VK_Up,VK_Down]) then
    Begin
      Changed := True;
      exit;
    End;

  InvalidEntry := False;

  Setlength(Totals, StringGrid1.ColCount+1);
  For j:=0 to StringGrid1.ColCount do
    Totals[j] := 0;

  For i := 1 to StringGrid1.RowCount-2 do
    Begin
      For j := 1 to StringGrid1.ColCount-1 do
       If StringGrid1.Cells[j,0] <> 'Deleted' then
        Begin
          Try
            Value := StrToFloat(Trim(StringGrid1.Cells[j,i]));
          Except
            Raise EAquatoxError.Create(StringGrid1.Cells[j,i]+' is not a valid number.');
          End;
          If (Value<0) or (Value>100) then InvalidEntry := True;
          Totals[j] := Totals[j] + Value;
        End;
    End;

    j:=0;
    Repeat
      inc(j);
      StringGrid1.Cells[j,StringGrid1.RowCount-1] := FloatToStr(100.0-Totals[j]);
      If (Totals[j]<0) or (Totals[j]>100) then InvalidEntry := True;
    Until (j=StringGrid1.ColCount-1); 

    Changed := not invalidentry;    

End;

procedure TBioTransfForm.StringGrid1Exit(Sender: TObject);
Var Key: Char;
begin
  Key := Char(VK_Return);
  StringGrid1KeyPress(Sender, Key);
end;

procedure TBioTransfForm.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
Var Key: Char;
begin
  CanSelect := (ARow < StringGrid1.RowCount-1);
  If CanSelect then
    Begin
      Key := Char(VK_Return);
      StringGrid1KeyPress(Sender, Key);
    End;
end;

Function TBioTransfForm.ColumnHeader(St: String):Integer;
Var i: Integer;
Begin
  ColumnHeader := -1;
  For i:=0 to StringGrid1.ColCount-1 do
    If StringGrid1.Cells[i,0] = St then ColumnHeader:=i;
End;

procedure TBioTransfForm.AddSpeciesClick(Sender: TObject);

    {---------------------------------------}
    Procedure AddSpec;
    Var S         : AllVariables;
        PSV       : TStateVariable;
        Found     : Boolean;
        SelectStr : String;
        NameStr   : String;
        I         : Integer;

    Begin
      ChangeVarForm.Caption := 'Select a variable for which you have specific biotransformation data:';
      ChangeVarForm.EntryList.Items.Clear;

      S:=FirstBiota;
      repeat
          PSV := SV.GetStatePointer(S,StV,WaterCol);
          NameStr := OutputText(S,STV,WaterCol,SV.UniqueName(S),False,False,0);
          If (PSV<>nil) and
            (ColumnHeader(NameStr) < 0)
              then ChangeVarForm.EntryList.Items.Add(NameStr);
          Inc(S);
      until S > LastBiota;

      If ChangeVarForm.ShowModal = MRCancel then exit;
      If ChangeVarForm.EntryList.ItemIndex = -1 then exit;
      With ChangeVarForm.EntryList do
        SelectStr := Items[ItemIndex];

      Changed := True;

      S:=FirstBiota;
      Found:=False;
      Repeat
          PSV := SV.GetStatePointer(S,StV,WaterCol);
          NameStr := OutputText(S,STV,WaterCol,SV.UniqueName(S),False,False,0);
          If (PSV<>nil) then
            If (NameStr=SelectStr) then Found:=True;
          If (Not Found) then Inc(S);
      Until Found;

      SetLength(ColTypes, Length(ColTypes)+1);
      SetLength(ColStates, Length(ColStates)+1);
      ColTypes[Length(ColTypes)-1]  := BTUserSpecified;
      ColStates[Length(ColTypes)-1] := S;

      With StringGrid1 do
        begin
          ColCount := ColCount + 1;
          Rows[0].Add(SelectStr);
          For i:=1 to RowCount-2 do
            Rows[i].Add('0');
          Rows[RowCount-1].Add('100');
        end;
    End;
    {---------------------------------------}
Begin
   Application.CreateForm(TChangeVarForm, ChangeVarForm);
   AddSpec;
   ChangeVarForm.Free;
End;


procedure TBioTransfForm.RemoveSpeciesClick(Sender: TObject);
Var S         : AllVariables;
    PSV       : TStateVariable;
    SelectStr : String;
    NameStr   : String;
    ColNum    : Integer;
    {----------------------}
    Procedure RemSpec;

    begin
      ChangeVarForm.Caption := 'Select a variable to remove species specific data:';
      ChangeVarForm.EntryList.Items.Clear;

      S:=FirstBiota;
      repeat
          PSV := SV.GetStatePointer(S,StV,WaterCol);
          NameStr := OutputText(S,STV,WaterCol,SV.UniqueName(S),False,False,0);
          If (PSV<>nil) and
            (ColumnHeader(NameStr) > 0)
              then ChangeVarForm.EntryList.Items.Add(NameStr);
          Inc(S);
      until S > LastBiota;

      If ChangeVarForm.ShowModal = MRCancel then exit;
      If ChangeVarForm.EntryList.ItemIndex = -1 then exit;
      With ChangeVarForm.EntryList do
        SelectStr := Items[ItemIndex];

      Changed := True;

      ColNum := ColumnHeader(SelectStr);

      StringGrid1.ColWidths[ColNum]:=0;
      StringGrid1.Cells[ColNum,0] := 'Deleted';
    end;
    {--------------------}
Begin
   Application.CreateForm(TChangeVarForm, ChangeVarForm);
   RemSpec;
   ChangeVarForm.Free;
End;    

procedure TBioTransfForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic41.htm');
end;

end.

