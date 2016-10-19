//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls;

type
  TWizBase0 = class(TWizBase)
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel1: TBevel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    Function ForceExit: Boolean; override;
    { Public declarations }
  end;

var
  WizBase0: TWizBase0;

implementation

{$R *.DFM}

procedure TWizbase0.FormShow(Sender: TObject);
begin
  inherited;
  If Not IsNewSetup
    then
      Begin
        Explanation.Caption := 'This wizard allows you to modify your existing AQUATOX simulation.';
        Label1.Caption := 'Available to your left is a progress window that shows you several ways in which you can modify your simulation.'+
                          ' You may double-click on any step in that window to move there.';
        Label2.Caption := 'To your right is a simulation summary window that shows you some of the changes to your simulation as you go about modifying it.';
      End
    else
      Begin
        Explanation.Caption := 'The simulation setup wizard will walk you through the steps required to create a new AQUATOX Simulation.';
        Label1.Caption := 'Available to your left is a progress window that shows you how far you have gotten in the simulation setup process.'+
                          '  You may double-click on any step in that window to move there.';
        Label2.Caption := 'To your right is a simulation summary window that shows you some of the changes to your simulation as you go about creating it.';
      End;

end;

Function TWizBase0.ForceExit: Boolean;
Begin
  If IsNewSetup
    then
      Begin
        MessageDlg('You must complete initial specifications before jumping to another wizard step.  Press the Next Button.',mterror,[mbok],0);
        ForceExit := False;
      End
    else ForceExit := inherited ForceExit;  
End;

end.
