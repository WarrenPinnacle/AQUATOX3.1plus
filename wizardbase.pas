//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit wizardbase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, WizGlobal, AQStudy, Global, AquaObj, AQBaseForm, hh;

type
  TWizBase = class(TAQBase)
    MainPanel: TPanel;
    HelpButton: TButton;
    BackButton: TButton;
    NextButton: TButton;
    CancelButton: TButton;
    FinishButton: TButton;
    ProgButton: TButton;
    SummButton: TButton;
    Title: TLabel;
    Explanation: TLabel;
    procedure ProgButtonClick(Sender: TObject);
    procedure SummButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure FinishButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);  
    procedure HelpButtonClick(Sender: TObject);
  private
    { Private declarations } 

  public
    WizStudy: TAQUATOXSegment;
    SummForm, ProgForm: TForm;
    IsNewSetup: Boolean;
    FirstVisit: Boolean;
    WizBusy: Boolean;
    WizStatus: Word;
    HelpContxt: String;
    ScrTop, ScrLeft: Integer;
    JumpIn: WizOutput;     {how was this screen jumped into?}
    OldForm: TForm;
    Function ExecuteScreen: WizOutput; virtual;
    Function  ForceExit: Boolean; virtual;
    Function Get_IC_Ptr(S: AllVariables): PDouble;
    { Public declarations }
  end;

var
  WizBase: TWizBase;
  WizOutcome: WizOutput;

implementation

{$R *.DFM}

Function TWizBase.Get_IC_Ptr(S: AllVariables): PDouble;
Var PSV: TStateVariable;
Begin
  PSV := WizStudy.SV.GetStatePointer(S,StV,WaterCol);
  Get_IC_Ptr := @(PSV.InitialCond);
End;


procedure TWizBase.ProgButtonClick(Sender: TObject);
begin
  ProgForm.Show;
end;

procedure TWizBase.SummButtonClick(Sender: TObject);
begin
  SummForm.Show;
end;

Function TWizBase.ForceExit: Boolean;
Begin
  WizOutcome := WzJump;
  FocusControl(ProgButton);
  ForceExit := True;
End;

Function TWizBase.ExecuteScreen: WizOutput;
Begin
  Top := ScrTop;
  Left := ScrLeft;
  Show;

  If (OldForm<>nil) and (OldForm<>Self) then OldForm.Free;
  WizOutcome := WzNoOutcome;
  WizBusy := False;
  Repeat
    Application.ProcessMessages;
  Until WizOutCome<>WzNoOutcome;
  ExecuteScreen := WizOutcome;
  ScrTop := Top;
  ScrLeft := Left;
  FirstVisit := False;
End;

procedure TWizBase.NextButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;
  WizOutcome := WzNext; 
end;

procedure TWizBase.CancelButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;
  If MessageDlg('Throw out all changes made through the Setup Wizard?',MtConfirmation,[mbyes,mbno],0)
     = mrno then exit;
  WizOutcome:=WzCancel;
end;

procedure TWizBase.BackButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;
  WizOutcome := WzBack;
end;

procedure TWizBase.FinishButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;
  WizOutcome := WzFinished;
end;

procedure TWizBase.FormCreate(Sender: TObject);
begin
  inherited;
  ScrTop := Top;
  ScrLeft := Left;
end;

procedure TWizBase.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext(HelpContxt);
end;

end.
