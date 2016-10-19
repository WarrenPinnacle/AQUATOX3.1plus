//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Batch;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, notused, hh;

type
  TBatchDlg = class(TOKBottomDlg)
    HelpBtn: TButton;
    Panel1: TPanel;
    OutputBatch: TButton;
    RunBatch: TButton;
    RunCtrl: TCheckBox;
    SteinBox: TCheckBox;
    procedure HelpBtnClick(Sender: TObject);
    procedure RunBatchClick(Sender: TObject);
    procedure OutputBatchClick(Sender: TObject);
  private
    { Private declarations }
  public
    IsOutput: Boolean;
  end;

var
  BatchDlg: TBatchDlg;

implementation


{$R *.DFM}

procedure TBatchDlg.HelpBtnClick(Sender: TObject);
begin
  HTMLHelpContext('Topic9.htm');
end;

procedure TBatchDlg.RunBatchClick(Sender: TObject);
begin
  IsOutput := False;
  ModalResult := MROK;
end;

procedure TBatchDlg.OutputBatchClick(Sender: TObject);
begin
  IsOutput := TRUE;
  ModalResult := MROK;
end;

end.

 
