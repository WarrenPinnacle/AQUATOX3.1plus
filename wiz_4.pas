//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls, WizGlobal, Global, AQUAOBJ, hh;

type
  TWizBase4 = class(TWizBase)
    Label1: TLabel;
    Button1: TButton;
    Bevel1: TBevel;
    Label2: TLabel;
    LabSedEdit: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    RefrSedEdit: TEdit;
    Label5: TLabel;
    WaterPanel: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    WCICEdit: TEdit;
    Panel2: TPanel;
    OCButt: TRadioButton;
    OMButt: TRadioButton;
    BODButt: TRadioButton;
    Label8: TLabel;
    PartPctEdit: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    ZRefrPctEdit: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    DiagenesisPanel: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    procedure ConvNumber(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure OMButtClick(Sender: TObject);
    procedure OCButtClick(Sender: TObject);
    procedure BODButtClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function  ExecuteScreen: WizOutput; override;
    Procedure UpdateScreen;
    Function  DataFinished: Boolean;
    { Public declarations }
  end;

var
  WizBase4: TWizBase4;

implementation

{$R *.DFM}

Function TWizBase4.DataFinished: Boolean;
Var Loop: Integer;
Begin
  DataFinished := True;
  For Loop := 1 to W4_NumFields do
    If not W4_FieldEdited[Loop] then DataFinished := False;
End;


Function  TWizBase4.ExecuteScreen: WizOutput;
Var Loop: Integer;
Begin
  If FirstVisit then
   For Loop := 1 to W4_NumFields do
    W4_FieldEdited[Loop] := False;

  If JumpIn = WzBack then W4_Screen:=1
                     else W4_Screen:=0;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (DataFinished) then WizStatus := 2;
  For Loop := 1 to W4_NumFields do
    If (WizStatus=1) and (W4_FieldEdited[Loop]) then WizStatus := 2;

End;


Procedure TWizBase4.UpdateScreen;
Var Val: Double;
    PD: TDissRefrDetr;
Begin
  WaterPanel.Visible := W4_Screen=1;
  MainPanel.Visible := Not (W4_Screen=1);

  PD := WizStudy.SV.GetStatePointer(DissRefrDetr,StV,watercol);

  DiagenesisPanel.Visible := WizStudy.SV.Diagenesis_Included;
  LabSedEdit.Enabled  := not WizStudy.SV.Diagenesis_Included;
  RefrSedEdit.Enabled := not WizStudy.SV.Diagenesis_Included;

  If Not DiagenesisPanel.Visible then
    Begin
      Val := Get_IC_Ptr(SedmLabDetr)^;
       If (WizStatus<>0) or W4_FieldEdited[1]
         then LabSedEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
         else LabSedEdit.Text := '';

       Val := Get_IC_Ptr(SedmRefrDetr)^;
       If (WizStatus<>0) or W4_FieldEdited[2]
         then RefrSedEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
         else RefrSedEdit.Text := '';
    End;

   With PD.InputRecord do
     Begin
       Val := PD.InputRecord.InitCond;
       If (WizStatus<>0) or W4_FieldEdited[3]
         then WCICEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
         else WCICEdit.Text := '';

       Val := Percent_PartIC;
       If (WizStatus<>0) or W4_FieldEdited[4]
         then PartPctEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
         else PartPctEdit.Text := '';

       Val := Percent_RefrIC;
       If (WizStatus<>0) or W4_FieldEdited[5]
         then ZRefrPctEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
         else ZRefrPctEdit.Text := '';

       If (WizStatus<>0) or W4_FieldEdited[6]
         Then
           Begin
             If DataType=Org_Matt then OMButt.Checked := True
                else if DataType= Org_Carb then OCButt.Checked := True
                  else BODButt.Checked := True;
           End
         Else
           Begin
             OCButt.Checked := False;
             OMButt.Checked := False;
             BODButt.Checked := False;
           End;
     End;

End;

Procedure TWizBase4.ConvNumber(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update W4_Screen}
Var Conv  : Double;
    Result: Integer;
    Txt: String;
    PD: TDissRefrDetr;
Begin
  PD := WizStudy.SV.GetStatePointer(DissRefrDetr,StV,WaterCol);
  Txt :=Tedit(Sender).Text;
  If Trim(Txt)='' then exit;
  Val(Txt,Conv,Result);
  Conv:=Abs(Conv);
  If (Result<>0)
       then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
       else if (TEdit(Sender).Name[1] in ['P','Z']) and ((conv<0) or (conv>100))
           then MessageDlg('Number must be from zero to one hundred.',mterror,[mbOK],0)
           else Begin
                  case TEdit(Sender).Name[1] of
                    'L': Begin
                           If (Get_IC_Ptr(SedmLabDetr)^<>Conv) or (WizStatus=0) then W4_FieldEdited[1]:=True;
                           Get_IC_Ptr(SedmLabDetr)^ := Conv;
                         End;
                    'R': Begin
                           If (Get_IC_Ptr(SedmRefrDetr)^<>Conv) or (WizStatus=0) then W4_FieldEdited[2]:=True;
                           Get_IC_Ptr(SedmRefrDetr)^ :=Conv;
                         End;
                    'W': With PD.InputRecord do
                           Begin
                             If (InitCond<>Conv) or (WizStatus=0) then W4_FieldEdited[3]:=True;
                             InitCond :=Conv;
                           End;
                    'P': With PD.InputRecord do
                           Begin
                             If (Percent_PartIC<>Conv) or (WizStatus=0) then W4_FieldEdited[4]:=True;
                             Percent_PartIC :=Conv;
                           End;
                    'Z': With PD.InputRecord do
                           Begin
                             If (Percent_RefrIC<>Conv) or (WizStatus=0) then W4_FieldEdited[5]:=True;
                             Percent_RefrIC := Conv;
                           End;
                  End; {case}
                End; {else}
  UpdateScreen;
End;

Procedure TWizBase4.NextButtonClick(Sender: TObject);
begin
  If W4_Screen=0
    then
      Begin
        W4_Screen:=1;
        UpdateScreen;
      End
    else inherited;
end;

Procedure TWizBase4.BackButtonClick(Sender: TObject);
begin
  If W4_Screen=1
    then
      Begin
        W4_Screen:=0;
        UpdateScreen;
      End
    else inherited;
end;

Procedure TWizBase4.OMButtClick(Sender: TObject);
Var  PD: TDissRefrDetr;
Begin
  PD := WizStudy.SV.GetStatePointer(DissRefrDetr,StV,WaterCol);

  With PD.InputRecord do
   Begin
     If (DataType<>Org_Matt) or (WizStatus=0) then W4_FieldEdited[6]:=True;
     DataType:=Org_Matt
   End
End;

procedure TWizBase4.OCButtClick(Sender: TObject);
Var  PD: TDissRefrDetr;
Begin
  PD := WizStudy.SV.GetStatePointer(DissRefrDetr,StV,WaterCol);

  With PD.InputRecord do
   Begin
     If (DataType<>Org_Carb) or (WizStatus=0) then W4_FieldEdited[6]:=True;
     DataType:=Org_Carb
   End
End;

procedure TWizBase4.BODButtClick(Sender: TObject);
Var  PD: TDissRefrDetr;
Begin
  PD := WizStudy.SV.GetStatePointer(DissRefrDetr,StV,WaterCol);

  With PD.InputRecord do
   Begin
     If (DataType<>CBOD) or (WizStatus=0) then W4_FieldEdited[6]:=True;
     DataType:=CBOD
   End
End;

procedure TWizBase4.Button1Click(Sender: TObject);

begin
  HTMLHelpContext('Topic49.htm');
end;

end.
