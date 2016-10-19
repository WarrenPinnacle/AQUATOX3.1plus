//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 

unit ChangVar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TChangeVarForm = class(TForm)
    EntryList: TListBox;
    Label5: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure EntryListDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChangeVarForm: TChangeVarForm;

implementation

{$R *.DFM}

procedure TChangeVarForm.EntryListDblClick(Sender: TObject);
begin
  ModalResult:=MrOK;
end;

end.
 