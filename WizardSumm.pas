//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit WizardSumm;

interface

uses

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AQStudy, Global, AQBaseForm, hh;

type
  TWizSummary = class(TAQBase)
    helpbutton: TButton;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Name: TLabel;
    SimType: TLabel;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure helpbuttonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    WizStudy: TAQUATOXSegment;
    Procedure UpdateScreen;
    { Public declarations }
  end;

var
  WizSummary: TWizSummary;

implementation

{$R *.DFM}

Procedure TWizSummary.Button1Click(Sender: TObject);
begin
  Hide;
end;

Procedure TWizSummary.UpdateScreen;
Begin
  If WizStudy=nil then
    Begin
      Name.Caption := 'Unnamed';
      SimType.Caption := 'Not Chosen';
      ListBox1.Items.Clear;
      Exit;
    End;

  Name.Caption := WizStudy.StudyName;
  Case WizStudy.SV.Location.SiteType of
     Pond: SimType.Caption := 'Pond';
     Stream: SimType.Caption := 'Stream';
     Enclosure: SimType.Caption := 'Enclosure';
     Reservr1D: SimType.Caption := 'Reservoir';
     Estuary: SimType.Caption := 'Estuary';
     else SimType.Caption := 'Lake';
    End; {Case}

  WizStudy.DisplayNames(ListBox1.Items);

End;

procedure TWizSummary.FormCreate(Sender: TObject);
begin
  Top := 0; Left := 765;
end;

procedure TWizSummary.FormShow(Sender: TObject);
begin
  UpdateScreen;
end;

procedure TWizSummary.helpbuttonClick(Sender: TObject);
begin
   HTMLHelpContext('Topic66.htm');
end;

end.
