//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit PFAK2s;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, AQBaseForm;

type
  TPFAK2Form = class(TAQBase)
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    TypeLabel: TLabel;
    procedure Button3Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
  end;

var
  PFAK2Form: TPFAK2Form;

implementation

{$R *.DFM}

procedure TPFAK2Form.Button3Click(Sender: TObject);
begin
  Height :=  403;
  update;
end;

procedure TPFAK2Form.FormHide(Sender: TObject);
begin
  Height:=172;
end;

end.
