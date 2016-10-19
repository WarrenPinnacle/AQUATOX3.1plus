//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_Fish1;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, notused, hh;

type
  TFishTypeDialog = class(TOKBottomDlg)
    HelpBtn: TButton;
    Label1: TLabel;
    Single: TRadioButton;
    Size: TRadioButton;
    Age: TRadioButton;
    procedure HelpBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FishTypeDialog: TFishTypeDialog;

implementation

{$R *.DFM}

procedure TFishTypeDialog.HelpBtnClick(Sender: TObject);
begin
  HTMLHelpContext('Topic80.htm');
end;

end.

