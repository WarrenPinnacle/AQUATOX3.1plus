//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit AQBaseForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Global, StdCtrls;

type
  TAQBase = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AQBase: TAQBase;

implementation

{$R *.DFM}

procedure TAQBase.FormCreate(Sender: TObject);
Var i: Integer;
Begin
    for i := 0 to ComponentCount - 1 do
      Begin
        if Components[i] is TControl then
          If TEdit(Components[i]).Color = 14347226 then TEdit(Components[i]).Color := EditColor;
       End;
end;

end.
