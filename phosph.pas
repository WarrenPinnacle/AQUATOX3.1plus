//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Phosph;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Global, AQBaseForm;

type
  TPhosAvailForm = class(TAQBase)
    Panel1: TPanel;
    Label1: TLabel;
    OKBtn: TBitBtn;
    Inflow: TEdit;
    NPSUnit: TLabel;
    Label2: TLabel;
    PS: TEdit;
    Label3: TLabel;
    DP: TEdit;
    Label4: TLabel;
    NPS: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
      FracAvail      : Double;
      Alt_FracAvail  : Array [PointSource..NonPointSource] of double;
  end;

var
  PhosAvailForm: TPhosAvailForm;

implementation

{$R *.DFM}

procedure TPhosAvailForm.FormShow(Sender: TObject);
begin
  Inflow.Text:= '  '+FloatToStrF(FracAvail,ffGeneral,15,4);
  PS.Text    := '  '+FloatToStrF(Alt_FracAvail[PointSource],ffGeneral,15,4);
  DP.Text    := '  '+FloatToStrF(Alt_FracAvail[DirectPrecip],ffGeneral,15,4);
  NPS.Text   := '  '+FloatToStrF(Alt_FracAvail[NonPointSource],ffGeneral,15,4);
end;


Procedure TPhosAvailForm.OKBtnClick(Sender: TObject);

    Function Convert(IT,Txt: String):Double;
    Var Conv: Double;
        Reslt: Integer;
    Begin
      Val(Trim(IT),Conv,Reslt);
      If Reslt<>0
        then Begin
                Conv:=-1;
                MessageDlg('Incorrect '+txt+' Numerical Format Entered',mterror,[mbOK],0);
             End
        else If (Conv<0) or (Conv>1) then
           MessageDlg(txt+' Fraction must be within [0..1]',mterror,[mbOK],0);
      Convert := Conv;
    End;

Begin
  OKBtn.SetFocus;
  
  FracAvail:=Convert(Inflow.Text,'Inflow');
  If (FracAvail<0) or (FracAvail>1) then exit;

  Alt_FracAvail[PointSource]:=Convert(PS.Text,'Point Source');
  If (Alt_FracAvail[PointSource]<0) or (Alt_FracAvail[PointSource]>1) then exit;

  Alt_FracAvail[DirectPrecip]:=Convert(DP.Text,'Direct Precip.');
  If (Alt_FracAvail[DirectPrecip]<0) or (Alt_FracAvail[DirectPrecip]>1) then exit;

  Alt_FracAvail[NonPointSource]:=Convert(NPS.Text,'Non-Point Source');
  If (Alt_FracAvail[NonPointSource]<0) or (Alt_FracAvail[NonPointSource]>1) then exit;

  ModalResult := MROK;
End;

end.
