//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Insrtdlg;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
     StdCtrls, hh;

type
  TInsertStateDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ListBox1: TListBox;
    Caption1: TLabel;
    HelpButt: TButton;
    procedure HelpButtClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var

  InsertStateDialog: TInsertStateDialog;

implementation

{$R *.DFM}

procedure TInsertStateDialog.HelpButtClick(Sender: TObject);
begin
    HTMLHelpContext('Adding_State_Variable.htm');
end;

end.
