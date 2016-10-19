//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 

unit StreamFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, DBCtrls, ExtCtrls, DB, DBTables, AQBaseForm, HH;

type
  TStreamForm = class(TAQBase)
    Table2: TTable;
    DataSource2: TDataSource;
    ScrollBox1: TScrollBox;
    Bevel1: TBevel;
    Label7: TLabel;
    Label74: TLabel;
    Label17: TLabel;
    Label27: TLabel;
    Label56: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    RunPct: TLabel;
    RunLabel: TLabel;
    ChannelSlope: TDBEdit;
    DBEdit4: TDBEdit;
    MaxChanDepth: TDBEdit;
    DBEdit8: TDBEdit;
    DBComboBox2: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    DBEdit3: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit9: TDBEdit;
    OKBtn: TBitBtn;
    panel1: TPanel;
    Label16: TLabel;
    Label19: TLabel;
    DBEdit10: TDBEdit;
    Label20: TLabel;
    DBEdit11: TDBEdit;
    Label21: TLabel;
    Label22: TLabel;
    DBEdit12: TDBEdit;
    Label23: TLabel;
    DBEdit13: TDBEdit;
    Label24: TLabel;
    DBEdit14: TDBEdit;
    Label25: TLabel;
    DBEdit15: TDBEdit;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label18: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    HelpButton: TButton;
    Label34: TLabel;
    Label35: TLabel;
    procedure FormCreate(Sender: TObject);  
    procedure DBCheckBox1Click(Sender: TObject);
    procedure DBEdit4KeyPress(Sender: TObject; var Key: Char);
    procedure DBEdit5Exit(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
  public
    Changed : Boolean;
    { Public declarations }
  end;

var
  StreamForm: TStreamForm;

implementation

{$R *.DFM}

procedure TStreamForm.FormCreate(Sender: TObject);  
begin
  inherited;
  Changed:= False;
end;

procedure TStreamForm.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  ScrollBox1.Perform(WM_VSCROLL,1,0);
end;

procedure TStreamForm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  ScrollBox1.Perform(WM_VSCROLL,0,0);
end;

procedure TStreamForm.DBCheckBox1Click(Sender: TObject);
begin
  Changed:=True;
end;

procedure TStreamForm.DBEdit4KeyPress(Sender: TObject; var Key: Char);
begin
    Changed := True;
end;

procedure TStreamForm.DBEdit5Exit(Sender: TObject);
Var PctRun, PctRiffle,PctPool: Double;
begin
  PctRiffle:=Table2.FieldByName('PctRiffle').AsFloat;
  PctPool:=Table2.FieldByName('PctPool').AsFloat;
  PctRun := 100-PctRiffle-PctPool;
  If (PctRun<0)
     then Begin
            RunPct.Caption := 'ERROR   ';
            RunLabel.Caption := 'Riffle + Pool must be less than 100';
          End
     else If (PctRun>100)
       then Begin
              RunPct.Caption := 'ERROR   ';
              RunLabel.Caption := 'Riffle + Pool cannot be negative';
            End
       else Begin
              RunPct.Caption := FloatToStrF(PctRun,ffFixed,4,2) + '   %';
              RunLabel.Caption := '(All Habitat that is not Riffle or Pool)';
            End;

end;

procedure TStreamForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic24.htm');
end;

end.
