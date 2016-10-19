//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit DrawThresh;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TThresholdForm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Panel1: TPanel;
    LeftAxisButt: TRadioButton;
    RightAxisButt: TRadioButton;
    Panel2: TPanel;
    ThreshEdit: TEdit;
    ErrLabel: TLabel;
    UnitLabel: TLabel;
    Memo1: TMemo;
    DrawAnalyzeButt: TButton;
    procedure ThreshEditExit(Sender: TObject);
    procedure LeftAxisButtClick(Sender: TObject);
  private
    { Private declarations }
  public
    LeftUnit, RightUnit: String;
    EnteredVal: Double;
    { Public declarations }
  end;

var
  ThresholdForm: TThresholdForm;

implementation

Uses Dialogs;

{$R *.DFM}

procedure TThresholdForm.ThreshEditExit(Sender: TObject);
Var Conv: Double;
  Result: Integer;

begin
  EnteredVal := -9999;
  Val(Trim(TEdit(Sender).Text),Conv,Result);
  If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
               else EnteredVal := Conv;
end;

procedure TThresholdForm.LeftAxisButtClick(Sender: TObject);
begin
  If LeftAxisButt.Checked then UnitLabel.Caption := LeftUnit
                          else UnitLabel.Caption := RightUnit;
end;

end.
