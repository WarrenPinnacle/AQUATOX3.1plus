//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Printing;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Gauges, ExtCtrls;

type
  TPrintCoverForm = class(TForm)
    Panel1: TPanel;
    Gauge1: TGauge;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrintCoverForm: TPrintCoverForm;

implementation

{$R *.DFM}

end.
