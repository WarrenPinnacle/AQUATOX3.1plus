//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Basins_BOD;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Global, AQBaseForm;

type
  TBOD_Form = class(TAQBase)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel11: TPanel;
    Label7: TLabel;
    RefrInflow: TEdit;
    Panel1: TPanel;
    Label5: TLabel;
    PartInflow: TEdit;
    OKBtn: TBitBtn;
    ModelLabel: TLabel;
    Label6: TLabel;
    procedure VerifyInput(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure GetOrgData(ORC_In: Boolean; Var BOD_Pct_Refr,Pct_Particulate: Double);
    Procedure UpdateScreen;
    { Public declarations }
  end;

var
  BOD_Form: TBOD_Form;
  Pct_Refr,Pct_Part: Double;

implementation

{$R *.DFM}

Procedure TBOD_Form.UpdateScreen;
Begin
   PartInflow.Text:=FloatToStrF(Pct_Part,ffgeneral,9,4);
   RefrInflow.Text:=FloatToStrF(Pct_Refr,ffgeneral,9,4);
End;

Procedure TBOD_Form.GetOrgData(ORC_In: Boolean; Var BOD_Pct_Refr,Pct_Particulate: Double);
Begin
  If ORC_In then Label3.Caption := 'Additionally, AQUATOX must characterize incoming loads of organic matter (CBOD and Refractory Organic Carbon) as Dissolved or Particulate in nature.'
            else Label3.Caption := 'Additionally, AQUATOX must characterize incoming loads of CBOD as Dissolved or Particulate in nature.';

  Pct_Refr := BOD_Pct_Refr;
  Pct_Part := Pct_Particulate;
  UpdateScreen;
  ShowModal;
  BOD_Pct_Refr := Pct_Refr;
  Pct_Particulate := Pct_Part;
End;


procedure TBOD_Form.VerifyInput(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update screen}
Var
Conv: Double;
Result: Integer;

Begin
    Val(Trim(Tedit(Sender).Text),Conv,Result);
    Conv:=Abs(Conv);
    If (Result<>0) Or
       ((Conv>100) or (Conv<0))
                 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else begin
                         case TEdit(Sender).Name[1] of
                            'P': Pct_Part:=Conv;
                            'R': Pct_Refr:=Conv;
                         end; {case}
                      end; {else}
    UpdateScreen;
end; {DetrVerify}

end.
