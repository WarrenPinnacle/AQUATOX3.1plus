//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit EstKPSed;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, AQBaseForm;

type
  TKPSedConfirm = class(TAQBase)
    Label1: TLabel;
    Label2: TLabel;
    LogKOWLabel: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    Button3: TButton;
    Label5: TLabel;
    TypeLabel: TLabel;
    AnimalPanel: TPanel;
    UseClassic: TRadioButton;
    Rashleigh: TRadioButton;
    procedure Button3Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
  end;

var
  KPSedConfirm: TKPSedConfirm;

implementation

{$R *.DFM}

procedure TKPSedConfirm.Button3Click(Sender: TObject);
begin
  Height :=  403;
  update;
end;

procedure TKPSedConfirm.FormHide(Sender: TObject);
begin
  Height:=172;
end;

end.
