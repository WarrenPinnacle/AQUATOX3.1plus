//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
Unit Trophint;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, AQBaseForm,
  Forms, Dialogs, Global, Aquaobj, StdCtrls, AQSTUDY, TCollect, Printers,
  Grids, DBGrids, DB, DBTables, ExtCtrls, Buttons, AQSite, Variants, hh;

type
  TTrophIntForm = class(TAQBase)
    OKBtn: TBitBtn;
    Panel1: TPanel;
    TitleLabel: TLabel;
    StringGrid1: TStringGrid;
    ViewPanel: TPanel;
    ViewAllData: TRadioButton;
    RadioButton2: TRadioButton;
    SaveMatrixButton: TButton;
    LoadMatrixButton: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    HelpButton: TButton;
    ToExcelButt: TButton;
    procedure OKBtnClick(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1Exit(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ViewAllDataMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SaveMatrixButtonClick(Sender: TObject);
    procedure LoadMatrixButtonClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure ToExcelButtClick(Sender: TObject);
  private
    Procedure UpdateScreen;
    { Private declarations }
  public
    changed      : boolean;
    PtrTrophInt  : ^TrophIntArray;
    SV           : TStates;
    AnimName     : String;
    Function  EditTrophInt: Boolean;
    Procedure EditTrophFile(FileDir,AnimNm: String);
  end;

var
  TrophIntForm  : TTrophIntForm;
  InvalidEntry  : Boolean;
  RowTypes      : Array [1..100] of AllVariables;

implementation

Uses Grid2Excel;

Function TTrophIntForm.EditTrophInt: Boolean;
Begin
 With StringGrid1 do
  begin
     ColWidths[0]:=200;
     ColWidths[3]:=250;

     RowCount := 2;

     Rows[0].Clear;
     Rows[0].Add(' ');
     Rows[0].Add('Preference (ratio)');
     Rows[0].Add('Egestion (frac.)');
     Rows[0].Add('References:');
  end;

  TitleLabel.Caption := 'Trophic Interactions of '+ AnimName +':';
  WindowState:=WSMaximized;
  UpdateScreen;

  EditTrophInt := (ShowModal=mrok);
End;

procedure TTrophIntForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic13.htm');
end;

Procedure TTrophIntForm.EditTrophFile(FileDir,AnimNm: String);
Var nsLoop: AllVariables;
    TRInt: TrophIntArray;
    PA: TAnimal;
Begin
  PtrTrophint := @TRInt;
  SV := nil;
  AnimName := AnimNm;
  CancelBtn.Visible := True;

  If Not FileExists(FileDir+AnimNm+'.int')
    then
      Begin
        For nsLoop := Cohesives to LastBiota do
          Begin
            TrInt[nsloop].Pref:=0;
            TrInt[nsloop].ECoeff:=0;
            TrInt[nsloop].XInteraction:='';
          End;
        If MessageDlg('Trophic Interactions File Does Not Exist ('+FileDir+AnimNm+'.int)  '+
           'Do you wish to load a different file to use with this animal?',MTConfirmation,[MBYes,MBNo],0)
           =MRYes then LoadMatrixButtonClick(nil);
      End
    else {file exists so load file}
      Begin
        PA := TAnimal.Init(NullStateVar,StV,'',SV,0,True);
        If PA.ReadTrophInt(FileDir+AnimNm+'.int') then TrInt := PA.PTrophInt^;
        PA.Destroy;
      End;

  If EditTrophInt then
    Begin
      PA := TAnimal.Init(NullStateVar,StV,'',SV,0,True);
      PA.PTrophInt^ := TRInt;
      PA.WriteTrophInt(FileDir+'\'+AnimNm+'.int');
      PA.Destroy;
    End; 
End;


Procedure TTrophIntForm.UpdateScreen;
Var NsLoop   : AllVariables;
    ViewAll  : Boolean;
    ViewThis : Boolean;
    StateName: String;
    UName: String;

Begin
 InvalidEntry := False;

 ViewAll := ViewAllData.Checked;
 ViewPanel.Visible := True;
 If SV=Nil then
   Begin
     ViewAll := True;
     ViewPanel.Visible := False;
   End;

 StringGrid1.RowCount := 1;
 For NsLoop := Cohesives to LastBiota do
   Begin
     If ViewAll then ViewThis := True
                else ViewThis := SV.GetStatePointer(NsLoop,StV,WaterCol) <> nil;
     If NSLoop in [SedmRefrDetr,SedmLabDetr] then ViewThis := True;           
     If NSLoop in [DissRefrDetr..DissLabDetr,BuriedLabileDetr,BuriedRefrDetr,Cohesives..Salinity] then ViewThis := False;
     If ViewThis then With StringGrid1 do
       Begin
         If SV=nil then UName := ''
                   else UName := SV.UniqueName(NsLoop);
         StateName := OutputText(NsLoop,StV,WaterCol,UName,False,False,0);

         RowCount:=RowCount+1;
         Rows[RowCount-1].Clear;
         Rows[RowCount-1].Add(StateName);
         Rows[RowCount-1].Add(FloatToStrF(PtrTrophint^[NsLoop].Pref,ffGeneral,6,3));
         Rows[RowCount-1].Add(FloatToStrF(PtrTrophint^[NsLoop].ECoeff,ffGeneral,6,3));
         Rows[RowCount-1].Add(PtrTrophint^[NsLoop].XInteraction);
         RowTypes[RowCount-1] := NSLoop;
       End;
   End;

   StringGrid1.FixedRows := 1;
   Update;
End;

{$R *.DFM}

procedure TTrophIntForm.OKBtnClick(Sender: TObject);
begin
  FocusControl(OKBtn);

  ModalResult := MrOK;
end;

Procedure TTrophIntForm.StringGrid1KeyPress(Sender: TObject;  var Key: Char);
{Autocalculate OTHER field}
Var i, j : integer;
    Value: Extended;
Begin
  If not (Word(Key) in [VK_Return,VK_Tab,VK_Up,VK_Down]) then exit;

  InvalidEntry := False;

  For i := 1 to StringGrid1.RowCount-1 do
    Begin
      For j := 1 to 2 do
        Begin
          Try
            Value := StrToFloat(Trim(StringGrid1.Cells[j,i]));
          Except
            Raise EAquatoxError.Create(StringGrid1.Cells[j,i]+' is not a valid number.');
          End;
          If j=1 then PtrTrophint^[RowTypes[i]].Pref := Value
                 else PtrTrophint^[RowTypes[i]].ECoeff := Value;
        End;
      PtrTrophint^[RowTypes[i]].XInteraction := (StringGrid1.Cells[3,i]);
    End;

End;

procedure TTrophIntForm.StringGrid1Exit(Sender: TObject);
Var Key: Char;
begin
  Key := Char(VK_Return);
  StringGrid1KeyPress(Sender, Key);
end;

procedure TTrophIntForm.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
Var Key: Char;
begin
   Key := Char(VK_Return);
   StringGrid1KeyPress(Sender, Key);
end;

procedure TTrophIntForm.ToExcelButtClick(Sender: TObject);
begin
  StringGrid2Excel(StringGrid1,'TrophicInteractions');
end;

procedure TTrophIntForm.ViewAllDataMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  UpdateScreen;
end;

Procedure TTrophIntForm.SaveMatrixButtonClick(Sender: TObject);
Var PA: TAnimal;
Begin
  SaveDialog1.InitialDir := DEFAULT_DIR;
  If not SaveDialog1.Execute then exit;

  PA := TAnimal.Init(NullStateVar,StV,'',SV,0,True);
  PA.PTrophInt^ := PtrTrophint^;
  PA.WriteTrophInt(SaveDialog1.FileName);
  PA.Destroy;
End;


Procedure TTrophIntForm.LoadMatrixButtonClick(Sender: TObject);
Var PA: TAnimal;

Begin
  OpenDialog1.InitialDir := DEFAULT_DIR;
  If not OpenDialog1.Execute then exit;
  PA := TAnimal.Init(NullStateVar,StV,'',SV,0,True);
  If PA.ReadTrophInt(OpenDialog1.FileName) then
    Begin
      MessageDlg('Trophic Interactions Read Successfully',MTConfirmation,[MBOK],0);
      PtrTrophint^ := PA.PTrophInt^;
    End;

  PA.Destroy;
  UpdateScreen;
End;

procedure TTrophIntForm.CancelBtnClick(Sender: TObject);
begin
  FocusControl(CancelBtn);
end;

end.

