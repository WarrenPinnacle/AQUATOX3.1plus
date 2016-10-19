//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Newstudy;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls;

type
  TNewStudyDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    Default_Button: TRadioButton;
    Blank_Button: TRadioButton;
    Stream_Button: TRadioButton;
    Res_Button: TRadioButton;
    Pond_Button: TRadioButton;
    Lake_Button: TRadioButton;
    Label1: TLabel;
    Limno_Button: TRadioButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewStudyDialog: TNewStudyDialog;

implementation

{$R *.DFM}

end.
