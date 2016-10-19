//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Corr_Edit;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls,AQBaseForm, Uncert, SysUtils, Dialogs;

type
  PIndxArray = ^TIndxArray;
  TIndxArray = Array of Integer;

  TEditCorrForm = class(TAQBase)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel1: TPanel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ComboBox2: TComboBox;
    CoeffEdit: TEdit;
    Label3: TLabel;
    procedure ComboBox1Change(Sender: TObject);
    procedure CoeffEditExit(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    PDS : TDistributionList;
    CN : Integer;
    TempCorr : Double;
    PIA : PIndxArray;
    Procedure UpdateScreen;
    { Private declarations }
  public
    Function EditCorr(TD:TDistributionList;CNum: Integer; Ptr: Pointer; TS: TStrings; I1,I2: Integer): Boolean;
    { Public declarations }
  end;


var
  EditCorrForm: TEditCorrForm;

implementation

Procedure TEditCorrForm.UpdateScreen;
Begin
  CoeffEdit.Text := FloatToStrF(TempCorr,ffgeneral,4,4);
End;

Function TEditCorrForm.EditCorr(TD:TDistributionList;CNum: Integer; Ptr: Pointer; TS: TStrings; I1,I2: Integer): Boolean;
Var PD: TDistribution;
Begin
  EditCorr := False;
  PDS := TD;
  CN := CNum;
  TempCorr := TD.Correlations[CNum].Correl;
  UpdateScreen;
  PIA := Ptr;
  ComboBox1.Items := TS;
  ComboBox2.Items := TS;

  ComboBox1.ItemIndex := I1;
  ComboBox2.ItemIndex := I2;

  If ShowModal = mrOK then
   With TD.Correlations[CNum] do
    Begin
     If (ComboBox1.ItemIndex = -1) or (ComboBox2.ItemIndex=-1) then exit;
     EditCorr := True;
     Correl := TempCorr;
     PD := TD.At(PIA^[Combobox1.ItemIndex]);
     DistNum1 := PD.DistNum;
     SVID1 := PD.SVID;
     TxRc1 := PD.ToxRec;
     PD := TD.At(PIA^[Combobox2.ItemIndex]);
     DistNum2 := PD.DistNum;
     SVID2 := PD.SVID;
     TxRc2 := PD.ToxRec;
    End;
End;


procedure TEditCorrForm.OKBtnClick(Sender: TObject);
begin
  OKBtn.SetFocus;
end;

{$R *.DFM}

procedure TEditCorrForm.ComboBox1Change(Sender: TObject);
begin
  OKBtn.Enabled := (Combobox1.ItemIndex <> ComboBox2.ItemIndex) and
    (Combobox1.ItemIndex<>-1) and (Combobox2.ItemIndex<>-1);
  {}
end;

procedure TEditCorrForm.CoeffEditExit(Sender: TObject);
Var
Conv: Double;
Result: Integer;

begin
    Val(Trim(TEdit(Sender).Text),Conv,Result);
    If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else begin
                        If Conv<-1.0 then
                          Begin
                            MessageDlg('The correlation coefficient must be between -1.0 and 1.0',mterror,[mbOK],0);
                            Conv := -1.0;
                          End;
                        If Conv>1.0  then
                          Begin
                            MessageDlg('The correlation coefficient must be between -1.0 and 1.0',mterror,[mbOK],0);
                            Conv := 1.0;
                          End;
                        TempCorr := Conv;
                       end;
    UpdateScreen;
end;

end.
