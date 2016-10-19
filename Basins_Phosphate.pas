//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Basins_Phosphate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Global, AQBaseForm;

type
  TPhosphate_form = class(TAQBase)
    Label1: TLabel;
    Panel1: TPanel;
    FracAvailEdit: TEdit;
    OKBtn: TBitBtn;
    Label6: TLabel;
    Panel2: TPanel;
    PO4box: TCheckBox;
    PPO4box: TCheckBox;
    TORPbox: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel3: TPanel;
    TSPButton: TRadioButton;
    TotPButton: TRadioButton;
    TotPLinkBox: TCheckBox;
    procedure VerifyInput(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure TotPLinkBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure GetPData(Var PO4,PPO4,TORP,AddTP, TotP: Boolean; Var PFracAvail: Double);
    Procedure UpdateScreen;
    { Public declarations }
  end;

var
  Phosphate_form: TPhosphate_form;
  FracAvail: Double;

implementation

{$R *.DFM}

Procedure TPhosphate_form.UpdateScreen;
Begin
   FracAvailEdit.Text:=FloatToStrF(FracAvail,ffgeneral,9,4);
End;

procedure TPhosphate_form.TotPLinkBoxClick(Sender: TObject);
begin
  PO4Box.Enabled := not TotPLinkBox.Checked;
  PPO4Box.Enabled := not TotPLinkBox.Checked;
  TORPBox.Enabled := not TotPLinkBox.Checked;

end;

Procedure TPhosphate_form.GetPData(Var PO4,PPO4,TORP,AddTP, TotP: Boolean; Var PFracAvail: Double);
Begin
  FracAvail := 1.0;

  TotPLinkBox.Visible := AddTP;
  TotPLinkBox.Checked := TotPLinkBox.Visible;
  TotPLinkBoxClick(nil);

  PO4Box.Visible := PO4;
  If not PO4Box.Visible then PO4Box.Checked := False;

  PPO4Box.Visible := PPO4;
  If not PPO4Box.Visible then PPO4Box.Checked := False;

  TORPBox.Visible := TORP;
  If not TORPBox.Visible then TORPBox.Checked := False;

  UpdateScreen;
  ShowModal;
  PFracAvail := FracAvail;
  PO4 := PO4Box.Checked;
  AddTP := TotPLinkBox.Checked;
  PPO4 := PPO4Box.Checked;
  TORP := TORPBox.Checked;
  TotP := TotPButton.Checked;

End;


procedure TPhosphate_form.VerifyInput(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update screen}
Var
Conv: Double;
Result: Integer;

Begin
    Val(Trim(Tedit(Sender).Text),Conv,Result);
    Conv:=Abs(Conv);
    If (Result<>0) Or
       ((Conv>1) or (Conv<0))
                 then MessageDlg('Incorrect Numerical Format Entered (must be a fraction between 0 and 1)',mterror,[mbOK],0)
                 else FracAvail :=Conv;
    UpdateScreen;
end; {DetrVerify}

procedure TPhosphate_form.OKBtnClick(Sender: TObject);
begin
  OKBtn.SetFocus;
end;

end.
