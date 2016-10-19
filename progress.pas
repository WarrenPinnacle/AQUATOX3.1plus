//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Progress;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Gauges, ExtCtrls, Global, Dialogs, AQBaseForm;

Const DebugHeight = 444;
      StandardHeight = 259;  

type
  TProgressDialog = class(TAQBase)
    Panel1: TPanel;
    Gauge1: TGauge;
    Label1: TLabel;
    Cancel: TBitBtn;
    StratLabel: TLabel;
    ControlLabel: TLabel;
    UncertPanel: TPanel;
    UncertTitleLabel: TLabel;
    UncertStatusLabel: TLabel;
    AnoxicLabel: TLabel;
    DateLabel: TLabel;
    SedLabel: TLabel;
    StepSizeLabel: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Gauge2: TGauge;
    Label2: TLabel;
    PercStep: TLabel;
    Panel4: TPanel;
    Label3: TLabel;
    ErrVariable: TLabel;
    Panel5: TPanel;
    Label4: TLabel;
    ErrValue: TLabel;
    Panel6: TPanel;
    Label5: TLabel;
    ErrRate: TLabel;
    Button1: TButton;
    LinkModeLabel: TLabel;
    watervolzero: TLabel;
    PeriLabel: TLabel;
    DiaLabel: TLabel;
    GrLabel: TLabel;
    BlGrLabel: TLabel;
    AutoSaveBox: TCheckBox;
    procedure CancelClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    StudyPtr: Pointer;
    StudyForm: TForm;
    Constructor Create(AOwner: TComponent; Study: Pointer; SForm: TForm); reintroduce;
    { Public declarations }
  end;

var
  ProgressDialog: TProgressDialog;

implementation

uses Debug, Parent;

{$R *.DFM}

procedure TProgressDialog.CancelClick(Sender: TObject);
begin
  IF MessageDlg('Cancel this operation?',mtconfirmation,[mbyes,mbno],0)=mryes
    then ModalResult := MrCancel;
end;

procedure TProgressDialog.Button1Click(Sender: TObject);
begin
  DebugScreen.Show;
end;

Constructor TProgressDialog.Create(AOwner: TComponent; Study: Pointer; SForm: TForm);
Begin
  StudyPtr := Study;
  StudyForm := SForm;

  Inherited Create(AOwner);


End;




procedure TProgressDialog.FormActivate(Sender: TObject);
begin
  ParentForm.UpdateWForm;
  AutoSaveBox.Visible := not BatchIsRunning; 
end;

end.


