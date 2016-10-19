//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 

unit Estuary_Loads;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Global,
  StdCtrls, Buttons, Mask, DBCtrls, ExtCtrls, DB, DBTables, AQBaseForm, HH;

type
  TEstuaryLoadForm = class(TAQBase)
    Table2: TTable;
    DataSource2: TDataSource;
    ScrollBox1: TScrollBox;
    OKBtn: TBitBtn;
    EstuaryLoadsForm: TButton;
    panel1: TPanel;
    Label74: TLabel;
    Label17: TLabel;
    Label27: TLabel;
    Label1: TLabel;
    AmmoniaEdit: TEdit;
    AmmoniaRef: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    NitrateEdit: TEdit;
    NitrateRef: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    PhosphateEdit: TEdit;
    PhosphateRef: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    OxygenEdit: TEdit;
    OxygenRef: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    CO2Edit: TEdit;
    CO2Ref: TEdit;
    Label10: TLabel;
    CancelBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure EstuaryLoadsFormClick(Sender: TObject);
    procedure AmmoniaEditExit(Sender: TObject);
    procedure AmmoniaRefChange(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    Changed : Boolean;
    Procedure UpdateScreen;
    Function EditLoads(Var InRec: EstSaltLoadingRec): Boolean;
    { Public declarations }
  end;

var
  EstuaryLoadForm: TEstuaryLoadForm;
  TempLoads:  EstSaltLoadingRec;

implementation

{$R *.DFM}



procedure TEstuaryLoadForm.FormCreate(Sender: TObject);
begin
  inherited;
  Changed:= False;
end;

procedure TEstuaryLoadForm.OKBtnClick(Sender: TObject);
begin
  OKBtn.SetFocus;
end;

Procedure TEstuaryLoadForm.UpdateScreen;
Begin
  AmmoniaEdit.Text:=FloatToStrF(TempLoads.AmmoniaLoad,ffGeneral,9,4);
  NitrateEdit.Text:=FloatToStrF(TempLoads.NitrateLoad,ffGeneral,9,4);
  CO2Edit.Text:=FloatToStrF(TempLoads.CO2Load,ffGeneral,9,4);
  OxygenEdit.Text:=FloatToStrF(TempLoads.O2Load,ffGeneral,9,4);
  PhosphateEdit.Text:=FloatToStrF(TempLoads.PhosphateLoad,ffGeneral,9,4);

  AmmoniaRef.Text:= TempLoads.XAmmoniaLoad;
  NitrateRef.Text:=TempLoads.XNitrateLoad;
  CO2Ref.Text:=TempLoads.XCO2Load;
  OxygenRef.Text:=TempLoads.XO2Load;
  PhosphateRef.Text:=TempLoads.XPhosphateLoad;

End;

procedure TEstuaryLoadForm.AmmoniaRefChange(Sender: TObject);
begin
  case TEdit(Sender).Name[1] of
    'A': TempLoads.XAmmoniaLoad := TEdit(Sender).Text;
    'N': TempLoads.XNitrateLoad := TEdit(Sender).Text;
    'C': TempLoads.XCO2Load     := TEdit(Sender).Text;
    'O': TempLoads.XO2Load      := TEdit(Sender).Text;
    'P': TempLoads.XPhosphateLoad := TEdit(Sender).Text;
  End;
  Changed := True;
end;

Function TEstuaryLoadForm.EditLoads(Var InRec: EstSaltLoadingRec): Boolean;
Var MR: TModalResult;
Begin
  TempLoads := InRec;
  UpdateScreen;
  MR := ShowModal;
  If MR = MROK then InRec := TempLoads;
  EditLoads := Changed and (MR=MROK);
End;



procedure TEstuaryLoadForm.AmmoniaEditExit(Sender: TObject);
Var Conv: Double;
    Result: Integer;
begin
    Val(Trim(TEdit(Sender).Text),Conv,Result);
    If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else begin
                         Changed := True;
                         case TEdit(Sender).Name[1] of
                            'A': TempLoads.AmmoniaLoad :=Conv;
                            'N': TempLoads.NitrateLoad :=Conv;
                            'C': TempLoads.CO2Load :=Conv;
                            'O': TempLoads.O2Load :=Conv;
                            'P': TempLoads.PhosphateLoad :=Conv;
                          end; {case}
                      end; {else}
    UpdateScreen;
end; {VerifyNumber}



procedure TEstuaryLoadForm.EstuaryLoadsFormClick(Sender: TObject);
begin
  HTMLHelpContext('Estuary_Notes.htm');
end;

end.
