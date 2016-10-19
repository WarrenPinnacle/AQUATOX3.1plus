//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit clearresults;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TClearResForm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    ClearAll: TRadioButton;
    ClearCtrl: TRadioButton;
    ClearPert: TRadioButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClearResForm: TClearResForm;

implementation

{$R *.DFM}

end.
