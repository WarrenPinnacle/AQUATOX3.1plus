//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls, WizGlobal, Global;

type
  TWizBase3 = class(TWizBase)
    Label1: TLabel;
    Label2: TLabel;
    AmmoniaEdit: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    NitrateEdit: TEdit;
    Label6: TLabel;
    PhosphateEdit: TEdit;
    Label8: TLabel;
    CO2Edit: TEdit;
    Label10: TLabel;
    OxygenEdit: TEdit;
    Label5: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Bevel1: TBevel;
    procedure ConvNumber(Sender: TObject);
  private
    { Private declarations }
  public
    Function  ExecuteScreen: WizOutput; override;
    Procedure UpdateScreen;
    Function  DataFinished: Boolean;
    { Public declarations }
  end;

var
  WizBase3: TWizBase3;

implementation

{$R *.DFM}
Function  TWizBase3.ExecuteScreen: WizOutput;
Var Loop: Integer;
Begin
  If FirstVisit then
   For Loop := 1 to 5 do
    W3_FieldEdited[Loop] := False;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (DataFinished) then WizStatus := 2;
  For Loop := 1 to 5 do
    If (WizStatus=1) and (W3_FieldEdited[Loop]) then WizStatus := 2;

End;

Function TWizBase3.DataFinished: Boolean;
Var Loop: Integer;
Begin
  DataFinished := True;
  For Loop := 1 to 5 do
    If not W3_FieldEdited[Loop] then DataFinished := False;
End;


Procedure TWizBase3.UpdateScreen;
Var Val: Double;
Begin
   Val := Get_IC_Ptr(Ammonia)^;
   If (WizStatus<>0) or W3_FieldEdited[1]
     then AmmoniaEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
     else AmmoniaEdit.Text := '';

   Val := Get_IC_Ptr(Nitrate)^;
   If (WizStatus<>0) or W3_FieldEdited[2]
     then NitrateEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
     else NitrateEdit.Text := '';

   Val := Get_IC_Ptr(Phosphate)^;
   If (WizStatus<>0) or W3_FieldEdited[3]
     then PhosphateEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
     else PhosphateEdit.Text := '';

   Val := Get_IC_Ptr(CO2)^;
   If (WizStatus<>0) or W3_FieldEdited[4]
     then CO2Edit.Text := FloatToStrF(Val,ffgeneral,9,4)
     else CO2Edit.Text := '';

   Val := Get_IC_Ptr(Oxygen)^;
   If (WizStatus<>0) or W3_FieldEdited[5]
     then OxygenEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
     else OxygenEdit.Text := '';

End;



procedure TWizBase3.ConvNumber(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update screen}
Var Conv  : Double;
    Result: Integer;
    Txt: String;
begin
  Txt :=Tedit(Sender).Text;
  If Trim(Txt)='' then exit;
  Val(Txt,Conv,Result);
  Conv:=Abs(Conv);
  If (Result<>0)
       then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
       else begin
               case TEdit(Sender).Name[1] of
                  'A': Begin
                         If (Get_IC_Ptr(Ammonia)^<>Conv) or (WizStatus=0) then W3_FieldEdited[1]:=True;
                         Get_IC_Ptr(Ammonia)^ :=Conv;
                       End;
                  'N': Begin
                         If (Get_IC_Ptr(Nitrate)^<>Conv) or (WizStatus=0) then W3_FieldEdited[2]:=True;
                         Get_IC_Ptr(Nitrate)^ :=Conv;
                       End;
                  'P': Begin
                         If (Get_IC_Ptr(Phosphate)^<>Conv) or (WizStatus=0) then W3_FieldEdited[3]:=True;
                         Get_IC_Ptr(Phosphate)^ :=Conv;
                       End;
                  'C': Begin
                         If (Get_IC_Ptr(Co2)^<>Conv) or (WizStatus=0) then W3_FieldEdited[4]:=True;
                         Get_IC_Ptr(Co2)^ :=Conv;
                       End;
                  'O': Begin
                         If (Get_IC_Ptr(Oxygen)^<>Conv) or (WizStatus=0) then W3_FieldEdited[5]:=True;
                         Get_IC_Ptr(Oxygen)^ :=Conv;
                       End;
               end; {case}
            end; {else}
  UpdateScreen;
end;

end.
