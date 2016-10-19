//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit birdform;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, AQBaseForm,
  Forms, Dialogs, Global, Aquaobj, StdCtrls, AQSTUDY, TCollect, Printers,
  Grids, DBGrids, DB, DBTables, ExtCtrls, Buttons, Variants,  AQSite, hh, Grid2Excel;

type
  TBirdScreen = class(TAQBase)
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
    HelpButton: TButton;
    Panel2: TPanel;
    ToxComboBox: TComboBox;
    BCFEdit: TEdit;
    RefEdit: TEdit;
    ChemLabel2: TLabel;
    ClearEdit: TEdit;
    ClearRefEdit: TEdit;
    ChemLabel3: TLabel;
    ChemLabel: TLabel;
    ChemLabel4: TLabel;
    ToExcelButt: TButton;
    Label7: TLabel;
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
    procedure ToxComboBoxChange(Sender: TObject);
    procedure BCFEditExit(Sender: TObject);
    procedure RefEditExit(Sender: TObject);
    procedure ClearRefEditExit(Sender: TObject);
    procedure ToExcelButtClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Procedure UpdateScreen;
    { Private declarations }
  public
    Changed      : Boolean;
    PtrTrophInt  : ^TrophIntArray;
    SV           : TStates;
    AnimName     : String;
    Function  EditBirds: Boolean;
  end;

var
  BirdScreen  : TBirdScreen;
  NumToxs        : Integer;
  SelTox         : Array[0..20] of AllVariables;
  InvalidEntry  : Boolean;
  RowTypes      : Array [1..100] of AllVariables;
  CurrentTox    : AllVariables;

implementation

Function TBirdScreen.EditBirds: Boolean;
Var  ToxLoop     : AllVariables;
Begin

 Changed := False;
 With StringGrid1 do
  begin
     ColWidths[0]:=200;
     ColWidths[2]:=250;

     RowCount := 2;

     Rows[0].Clear;
     Rows[0].Add(' ');
     Rows[0].Add('Preference (ratio)');
     Rows[0].Add('References:');
  end;

{  TitleLabel.Caption := 'Trophic Interactions of '+ AnimName +':'; }
{  WindowState:=WSMaximized;  }

  NumToxs := 0;
  CurrentTox := NullStateVar;
  ToxComboBox.Items.Clear;
  For ToxLoop := FirstOrgTox to LastOrgTox do
    Begin
      If SV.GetIndex(ToxLoop,StV,WaterCol) > -1 then
        Begin
          SelTox[NumToxs] := ToxLoop;
          Inc(NumToxs);
          ToxComboBox.Items.Add(SV.ChemPtrs^[AssocToxTyp(ToxLoop)].ChemRec.ChemName);
          If CurrentTox = NullStateVar then CurrentTox := ToxLoop;
        End;
    End;

  ToxComboBox.ItemIndex := 0;

  UpdateScreen;

  EditBirds := (ShowModal=mrok);
End;



procedure TBirdScreen.FormShow(Sender: TObject);
begin
  Height := Screen.WorkAreaHeight - 100;
end;

Procedure TBirdScreen.UpdateScreen;
Var NsLoop   : AllVariables;
    ViewAll  : Boolean;
    ViewThis : Boolean;
    StateName: String;
    UName: String;

Begin
 InvalidEntry := False;

 If CurrentTox=NullStateVar
   then
     Begin
       ChemLabel.Enabled  := False;
       ChemLabel2.Enabled := False;
       ChemLabel3.Enabled := False;
       ChemLabel4.Enabled := False;
       BCFEdit.Enabled := False;
       RefEdit.Enabled := False;
       ClearEdit.Enabled := False;
       ClearRefEdit.Enabled := False;
     End
   else
     Begin
       ChemLabel.Enabled  := True;
       ChemLabel2.Enabled := True;
       ChemLabel3.Enabled := True;
       ChemLabel4.Enabled := True;
       BCFEdit.Enabled := True;
       RefEdit.Enabled := True;
       ClearEdit.Enabled := True;
       ClearRefEdit.Enabled := True;
       BCFEdit.Text := FloatToStrF(SV.GullBMF[AssocToxTyp(CurrentTox)],ffgeneral,9,4);
       RefEdit.Text := SV.GullRef[AssocToxTyp(CurrentTox)];
       ClearEdit.Text := FloatToStrF(SV.GullClear[AssocToxTyp(CurrentTox)],ffgeneral,9,4);
       ClearRefEdit.Text := SV.GullClearRef[AssocToxTyp(CurrentTox)];
     End;

 ViewAll := ViewAllData.Checked;
 ViewPanel.Visible := True;
 If SV=Nil then
   Begin
     ViewAll := True;
     ViewPanel.Visible := False;
   End;

 StringGrid1.RowCount := 1;
 For NsLoop := SedmRefrDetr to LastBiota do
   Begin
     If ViewAll then ViewThis := True
                else ViewThis := SV.GetStatePointer(NsLoop,StV,WaterCol) <> nil;
     If NSLoop in [DissRefrDetr..DissLabDetr,Cohesives..NonCohesives2] then ViewThis := False;
     If ViewThis then With StringGrid1 do
       Begin
         If SV=nil then UName := ''
                   else UName := SV.UniqueName(NsLoop);
         StateName := OutputText(NsLoop,StV,WaterCol,UName,False,False,0);
{         If NsLoop in [Fish1,Fish2] then
           Begin
             If SV=nil then StateName := 'MultiFish'
                       else If SV.GetStatePointer(NsLoop,StV) <> nil
                               then StateName := SV.PMultiRec.Name
                               else StateName := 'MultiFish';
             If NsLoop=Fish1 then StateName := StateName + ' YOY';
             If NsLoop=Fish2 then StateName := StateName + ' Older';
           End;  }

         RowCount:=RowCount+1;
         Rows[RowCount-1].Clear;
         Rows[RowCount-1].Add(StateName);
         Rows[RowCount-1].Add(FloatToStrF(PtrTrophInt[NsLoop].Pref,ffGeneral,6,3));
         Rows[RowCount-1].Add(PtrTrophInt[NsLoop].XInteraction);
         RowTypes[RowCount-1] := NSLoop;
       End;
   End;

   StringGrid1.FixedRows := 1;
   Update;
End;

{$R *.DFM}

procedure TBirdScreen.OKBtnClick(Sender: TObject);
{Var nsloop: AllVariables; }
begin
  FocusControl(OKBtn);

{  For nsloop := Fish3 to Fish15 do
      PTrophInt[nsloop] := PTrophInt[Fish2]; }

  ModalResult := MrOK;
end;

Procedure TBirdScreen.StringGrid1KeyPress(Sender: TObject;  var Key: Char);
{Autocalculate OTHER field}
Var i, j : integer;
    Value: Extended;
{    nsloop: AllVariables; }
Begin
  If not (Word(Key) in [VK_Return,VK_Tab,VK_Up,VK_Down]) then
    Begin
      Changed := True;
      exit;
    End;

  InvalidEntry := False;

  For i := 1 to StringGrid1.RowCount-1 do
    Begin
      For j := 1 to 1 do
        Begin
          Try
            Value := StrToFloat(Trim(StringGrid1.Cells[j,i]));
          Except
            Raise EAquatoxError.Create(StringGrid1.Cells[j,i]+' is not a valid number.');
          End;
          If j=1 then PtrTrophInt[RowTypes[i]].Pref := Value;
        End;
      PtrTrophInt[RowTypes[i]].XInteraction := (StringGrid1.Cells[3,i]);
    End;

{  For nsloop := Fish3 to Fish15 do
      PTrophInt[nsloop] := PTrophInt[Fish2]; }
End;

procedure TBirdScreen.StringGrid1Exit(Sender: TObject);
Var Key: Char;
begin
  Key := Char(VK_Return);
  StringGrid1KeyPress(Sender, Key);
end;

procedure TBirdScreen.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
Var Key: Char;
begin
   Key := Char(VK_Return);
   StringGrid1KeyPress(Sender, Key);
end;

procedure TBirdScreen.ViewAllDataMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  UpdateScreen;
end;

Procedure TBirdScreen.SaveMatrixButtonClick(Sender: TObject);
Var PA: TAnimal;
Begin
  SaveDialog1.InitialDir := DEFAULT_DIR;
  If not SaveDialog1.Execute then exit;

  PA := TAnimal.Init(NullStateVar,StV,'',SV,0,True);
  PA.PTrophInt^ := PtrTrophint^;
  PA.WriteTrophInt(SaveDialog1.FileName);
  PA.Destroy;
End;


Procedure TBirdScreen.LoadMatrixButtonClick(Sender: TObject);
Var PA: TAnimal;

Begin
  OpenDialog1.InitialDir := DEFAULT_DIR;
  If not OpenDialog1.Execute then exit;
  PA := TAnimal.Init(NullStateVar,StV,'',SV,0,True);
  If PA.ReadTrophInt(OpenDialog1.FileName) then
    Begin
      MessageDlg('Trophic Interactions Read Successfully',MTConfirmation,[MBOK],0);
      PtrTrophint^ := PA.PTrophInt^;
      Changed := True;
    End;

  PA.Destroy;
  UpdateScreen;
End;

procedure TBirdScreen.CancelBtnClick(Sender: TObject);
begin
  FocusControl(CancelBtn);
end;

procedure TBirdScreen.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Shorebirds.htm');
end;

procedure TBirdScreen.ToExcelButtClick(Sender: TObject);
begin
    StringGrid2Excel(StringGrid1,'TrophicInteractions');
end;

procedure TBirdScreen.ToxComboBoxChange(Sender: TObject);
begin
  CurrentTox:=SelTox[ToxComboBox.ItemIndex];
  UpdateScreen;
end;

procedure TBirdScreen.BCFEditExit(Sender: TObject);
Var
Conv: Double;
Reslt: Integer;

begin
    Val(Trim(Tedit(Sender).Text),Conv,Reslt);
    Conv:=Abs(Conv);
    If Reslt<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                else case TEdit(Sender).Name[1] of
                       'B': SV.GullBMF[AssocToxTyp(CurrentTox)] := Conv;
                       'C': SV.GullClear[AssocToxTyp(CurrentTox)] := Conv;
                     end;
    UpdateScreen;
end;

procedure TBirdScreen.RefEditExit(Sender: TObject);
begin
  SV.GullRef[AssocToxTyp(CurrentTox)] := Tedit(Sender).Text;
end;

procedure TBirdScreen.ClearRefEditExit(Sender: TObject);
begin
  SV.GullClearRef[AssocToxTyp(CurrentTox)] := Tedit(Sender).Text;
end;

end.

