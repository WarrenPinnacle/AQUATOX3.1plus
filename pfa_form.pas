//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 

unit PFA_form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, DBCtrls, ExtCtrls, DB, DBTables, AQBaseForm;

type
  TPFAForm = class(TAQBase)
    Panel1: TPanel;
    PFATitle: TLabel;
    OKBtn: TBitBtn;
    Table1: TTable;
    DataSource1: TDataSource;
    IsPFABox: TDBCheckBox;
    Panel2: TPanel;
    L1: TLabel;
    B1: TDBComboBox;
    L2: TLabel;
    B2: TDBEdit;
    B3: TDBEdit;
    L3: TLabel;
    L4: TLabel;
    B4: TDBEdit;
    B5: TDBEdit;
    L6: TLabel;
    B6: TDBEdit;
    B7: TDBEdit;
    L8: TLabel;
    B8: TDBEdit;
    B9: TDBEdit;
    L5: TLabel;
    L7: TLabel;
    L9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure DBCheckBox1Click(Sender: TObject);
    procedure DBEdit4KeyPress(Sender: TObject; var Key: Char);
    procedure IsPFABoxClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    Changed : Boolean;
    { Public declarations }
  end;

var
  PFAForm: TPFAForm;

implementation

{$R *.DFM}

procedure TPFAForm.FormCreate(Sender: TObject);
begin
  inherited;
  Changed:= False;
end;

procedure TPFAForm.DBCheckBox1Click(Sender: TObject);
begin
  Changed:=True;
end;

procedure TPFAForm.DBEdit4KeyPress(Sender: TObject; var Key: Char);
begin
    Changed := True;
end;

procedure TPFAForm.IsPFABoxClick(Sender: TObject);
Var ISPFA: Boolean;
begin
  ISPFA := IsPFABox.Checked;
  L1.Enabled := ISPFA;   B1.Enabled := ISPFA;
  L2.Enabled := ISPFA;   B2.Enabled := ISPFA;
  L3.Enabled := ISPFA;   B3.Enabled := ISPFA;
  L4.Enabled := ISPFA;   B4.Enabled := ISPFA;
  L5.Enabled := ISPFA;   B5.Enabled := ISPFA;
  L6.Enabled := ISPFA;   B6.Enabled := ISPFA;
  L7.Enabled := ISPFA;   B7.Enabled := ISPFA;
  L8.Enabled := ISPFA;   B8.Enabled := ISPFA;
  L9.Enabled := ISPFA;   B9.Enabled := ISPFA;
end;



procedure TPFAForm.FormActivate(Sender: TObject);
begin
   IsPFABoxClick(nil);
end;

end.
