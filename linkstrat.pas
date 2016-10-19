//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit linkstrat;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, jpeg, ExtCtrls;

type
  TStratDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel1: TPanel;
    NotStratButt: TRadioButton;
    StratButt: TRadioButton;
    Panel2: TPanel;
    EpiButt: TRadioButton;
    HypButt: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    HelpButton: TButton;
    procedure NotStratButtClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
     Procedure EditStrat(Var IsStrat,IsEpi: Boolean);
    { Public declarations }
  end;

var
  StratDialog: TStratDialog;

implementation

uses hh;

Procedure TStratDialog.EditStrat(Var IsStrat,IsEpi: Boolean);
begin
  NotStratButt.Checked := Not IsStrat;
  StratButt.Checked := IsStrat;
  EpiButt.Checked := IsEpi;
  HypButt.Checked := Not IsEpi;

  NotStratButtClick(nil);

  If ShowModal=MrCancel then exit;

  IsStrat := StratButt.Checked;
  IsEpi := EpiButt.Checked;
end;
{$R *.DFM}

procedure TStratDialog.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Stratification_in_Linked_System.htm');
end;

procedure TStratDialog.NotStratButtClick(Sender: TObject);
begin
  Panel2.Enabled  := Stratbutt.Checked;
  EpiButt.Enabled := Stratbutt.Checked;
  HypButt.Enabled := Stratbutt.Checked;
  Label1.Enabled  := Stratbutt.Checked;
  Label2.Enabled  := Stratbutt.Checked;
end;

end.
