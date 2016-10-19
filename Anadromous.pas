//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
unit Anadromous;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons, Dialogs, hh,
  StdCtrls, jpeg, ExtCtrls, AQBaseForm, AQUAOBJ, Global, TCollect, SysUtils, AQStudy;

type
  TAnadromousForm = class(TAQBase)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    JuvDateEdit: TEdit;
    Label2: TLabel;
    Panel1: TPanel;
    SteadyStateBox: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    AdultDateEdit: TEdit;
    JuvDayLabel: TLabel;
    AdultDayLabel: TLabel;
    Label6: TLabel;
    FracMigr: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    YearsOffSiteEdit: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    MortFracEdit: TEdit;
    Label11: TLabel;
    HelpButton: TButton;
    procedure JuvDateEditExit(Sender: TObject);
    procedure SteadyStateBoxClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);

  private
     Updating: Boolean;
    { Private declarations }
  public
     Changed: Boolean;
     TempAndRecord : AnadromousInputRec ;
     Procedure EditAndRecord(Var AndRecord:AnadromousInputRec );
     Procedure UpdateScreen;
    { Public declarations }
  end;

var
  AnadromousForm: TAnadromousForm;
  InitConds: Array of Double;

implementation

Uses Diagenesis, ExcelFuncs, WAIT;

{$R *.DFM}


Procedure TAnadromousForm.UpdateScreen;
Const BaseDate = 40543;
Var   SDF: String;
Begin
  Updating := True;
  SteadyStateBox.Checked := TempAndRecord.IsAnadromous;
  If Not TempAndRecord.IsAnadromous then ScrollBox1.Color := ClGray
                                    else ScrollBox1.Color := clBtnFace;

  JuvDateEdit.Text := IntToStr(TempAndRecord.DateJuvMigr);
  FracMigr.Text := FloatToStrF(TempAndRecord.FracMigrating,ffgeneral,6,4);
  AdultDateEdit.Text := IntToStr(TempAndRecord.DateAdultReturn);
  YearsOffSiteEdit.Text := IntToStr(TempAndRecord.YearsOffSite);
  MortFracEdit.Text := FloatToStrF(TempAndRecord.MortalityFrac,ffgeneral,6,4);

  SDF := ShortDateFormat;
  ShortDateFormat := 'mmm d';
  JuvDayLabel.Caption := ('(usually '+DateToStr(BaseDate+ TempAndRecord.DateJuvMigr)+')');
  AdultDayLabel.Caption := ('(usually '+DateToStr(BaseDate+ TempAndRecord.DateAdultReturn)+')');
  ShortDateFormat := SDF;

  Updating := False;
End;

Procedure TAnadromousForm.EditAndRecord(Var AndRecord:AnadromousInputRec );

begin
  TempAndRecord := AndRecord;
  UpdateScreen;

  Changed := False;
  If ShowModal = mrCancel then exit;

  AndRecord := TempAndRecord;
end;


procedure TAnadromousForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Anadromous.htm');
end;

procedure TAnadromousForm.JuvDateEditExit(Sender: TObject);
Var Result: Integer;
    Conv: Double;
begin
    Val(Trim(TEdit(Sender).Text),Conv,Result);
    Conv:=Abs(Conv);
    If Result=0
      then
        Case TEdit(Sender).Name[1] of
          'J' : TempAndRecord.DateJuvMigr := Trunc(Conv);
          'F' : TempAndRecord.FracMigrating := (Conv);
          'A' : TempAndRecord.DateAdultReturn := Trunc(Conv);
          'Y' : TempAndRecord.YearsOffSite:= Trunc(Conv);
          'M' : TempAndRecord.MortalityFrac := (Conv);
        End; {case}

    UpdateScreen;
end;

procedure TAnadromousForm.SteadyStateBoxClick(Sender: TObject);
begin
  If Updating then Exit;
  TempAndRecord.IsAnadromous := SteadyStateBox.Checked;
  UpdateScreen;
end;

end.

