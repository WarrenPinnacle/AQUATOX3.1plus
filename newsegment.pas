//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit newsegment;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, hh,
  StdCtrls;

type
  TAddSegForm = class(TForm)
    CopySegButt: TRadioButton;
    Addblankbutt: TRadioButton;
    LoadSegButt: TRadioButton;
    SegNumTextBox: TEdit;
    StudyNameLabel: TLabel;
    StudyNameEditBox: TEdit;
    SegIDLabel: TLabel;
    Button1: TButton;
    Button2: TButton;
    HelpButton: TButton;
    procedure HelpButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddSegForm: TAddSegForm;

implementation

{$R *.DFM}

procedure TAddSegForm.HelpButtonClick(Sender: TObject);
begin
    HTMLHelpContext('Adding_New_Segment.htm');
end;

end.
