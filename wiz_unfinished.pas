//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_unfinished;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, notused, hh;

type
  TWizUnfinishedDlg = class(TOKBottomDlg)
    HelpBtn: TButton;
    Explanation: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    procedure HelpBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WizUnfinishedDlg: TWizUnfinishedDlg;

implementation

{$R *.DFM}

procedure TWizUnfinishedDlg.HelpBtnClick(Sender: TObject);
begin
  HTMLHelpContext('Topic79.htm');
end;

end.
 
