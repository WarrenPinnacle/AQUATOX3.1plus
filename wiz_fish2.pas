//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_Fish2;

interface



uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, notused, hh ;

type
  TFishClassDialog = class(TOKBottomDlg)
    HelpBtn: TButton;
    Label1: TLabel;
    Forage: TRadioButton;
    Bottom: TRadioButton;
    Game: TRadioButton;
    SingleFishPanel: TPanel;
    SmForage: TRadioButton;
    SmBottom: TRadioButton;
    SmGame: TRadioButton;
    LgForage: TRadioButton;
    LgBottom: TRadioButton;
    LgGame: TRadioButton;
    procedure HelpBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FishClassDialog: TFishClassDialog;

implementation

{$R *.DFM}

procedure TFishClassDialog.HelpBtnClick(Sender: TObject);
begin
  HTMLHelpContext('Topic81.htm');
end;

end.
 
