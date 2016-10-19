//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit StratFlow;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Loadings,
  StdCtrls, Buttons, ExtCtrls, Global, AQBaseForm, DBCtrls, Grids, DBGrids, DB,
  DBTables, AQUAOBJ, jpeg, hh;

type
  TStratFlowForm = class(TAQBase)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    InEpi: TRadioButton;
    InHyp: TRadioButton;
    InBoth: TRadioButton;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    OutEpi: TRadioButton;
    OutHyp: TRadioButton;
    OutBoth: TRadioButton;
    Panel4: TPanel;
    Bevel2: TBevel;
    Label7: TLabel;
    ShadeLabel: TLabel;
    ZTGrid: TDBGrid;
    ZTNav: TDBNavigator;
    ZTImportButt: TButton;
    Panel3: TPanel;
    Unit3: TLabel;
    UseConstZTButton: TRadioButton;
    ConstZTEdit: TEdit;
    UseDynamZTButton: TRadioButton;
    NoZTUserLoad: TRadioButton;
    OKBtn: TBitBtn;
    Image1: TImage;
    Panel5: TPanel;
    Label5: TLabel;
    StratDefault: TRadioButton;
    DateStrat: TRadioButton;
    DateLabel: TLabel;
    Label6: TLabel;
    SDGrid: TDBGrid;
    SDNav: TDBNavigator;
    Button1: TButton;
    SDChangeButton: TButton;
    DataSource1: TDataSource;
    ZTTable: TTable;
    DataSource2: TDataSource;
    SDTable: TTable;
    Label8: TLabel;
    HelpButton: TButton;
    procedure OKBtnClick(Sender: TObject);
    procedure UseConstZTButtonClick(Sender: TObject);
    procedure ConstZTEditExit(Sender: TObject);
    procedure ZTImportButtClick(Sender: TObject);
    procedure SDChangeButtonClick(Sender: TObject);
    procedure StratDefaultClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure EditStratInfo(PV: TVolume;PZT: Pointer);
    Procedure UpdateScreen;
    Var ZTPointer: PLoadingsRecord;
        SDPointer: PPLoadings;
        UseDefault: PBoolean;
  end;

var
  StratFlowForm: TStratFlowForm;
  NoEnableDisable: Boolean;

implementation

uses Imp_Load, Convert, EdStateV;

{$R *.DFM}

Procedure TStratFlowForm.UpdateScreen;
begin
  ConstZTEdit.Text   := FloatToStrF(ZTPointer^.ConstLoad,ffGeneral,15,4);


  NoEnableDisable := True;

  StratDefault.Checked := UseDefault^;
  DateStrat.Checked := not UseDefault^;

  NoZTUserLoad.Checked := ZTPointer^.NoUserLoad;
  If Not ZTPointer^.NoUserLoad then
    Begin
      UseConstZTButton.Checked := ZTPointer^.UseConstant;
      UseDynamZTButton.Checked := not ZTPointer^.UseConstant;
    End;
  NoEnableDisable := False;

  UseConstZTButtonClick(nil);
  StratDefaultClick(nil);
end;

Procedure TStratFlowForm.EditStratInfo(PV: TVolume; PZT: Pointer);

Var TableIn: TTable;
    i: Integer;

         Procedure PutInDbase(P: TLoad);
         {Used to put loadings data into TableIn}
         begin
            With TableIn do
               begin
                 Append;
                 Fields[0].AsDateTime:= P.Date;
                 Fields[1].AsFloat:=P.Loading;
                 Post;
               end;
         end;


begin
  ZTPointer := PZT; 
  SDPointer := @PV.StratDates;
  UseDefault := @(PV.StratAutomatically);

  ZTTable.DatabaseName:=Program_Dir;
  ZTTable.Active:=False;
  ZTTable.EmptyTable;
  ZTTable.Active:=True;

  {Load the Database Data into the Files}
  TableIn:=ZTTable;
  TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
  With ZTPointer^.Loadings do For i:=0 to count-1 do
                                    PutInDbase(at(i));

  SDTable.DatabaseName:=Program_Dir;
  SDTable.Active:=False;
  SDTable.EmptyTable;
  SDTable.Active:=True;

  TableIn:=SDTable;
  TFloatField(TableIn.Fields[1]).DisplayFormat:='0';
  With SDPointer^ do For i:=0 to count-1 do
                                    PutInDbase(at(i));

  Case PV.StratInflow of
    FTEpi: InEpi.Checked := True;
    FtHyp: InHyp.Checked := True;
    Else   InBoth.Checked := True;
  End;
  Case PV.StratOutflow of
    FTEpi: OutEpi.Checked := True;
    FtHyp: OutHyp.Checked := True;
    Else   OutBoth.Checked := True;
  End;

  UpdateScreen;
  Showmodal;

  If InEpi.Checked then PV.StratInflow := FtEpi;
  If InHyp.Checked then PV.StratInflow := FtHyp;
  If InBoth.Checked then PV.StratInflow := FtBoth;
  If OutEpi.Checked then PV.StratOutflow := FtEpi;
  If OutHyp.Checked then PV.StratOutflow := FtHyp;
  If OutBoth.Checked then PV.StratOutflow := FtBoth;
  StateVarDialog.LoadingsFromTable(ZTTable,ZTPointer^.Loadings);
  StateVarDialog.LoadingsFromTable(SDTable,SDPointer^);
end;

procedure TStratFlowForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Stratification_Options.htm');
end;

procedure TStratFlowForm.ConstZTEditExit(Sender: TObject);
Var Conv   : Double;
    Result : Integer;
begin
  Val(Trim(TEdit(Sender).Text),Conv,Result);
  Conv:=Abs(Conv);
  If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
               else ZTPointer^.ConstLoad := Conv;

  UpdateScreen;

end;

Procedure TStratFlowForm.OKBtnClick(Sender: TObject);
Begin
  OKBtn.SetFocus;

  ModalResult := MROK;
End;


procedure TStratFlowForm.StratDefaultClick(Sender: TObject);
begin
 If NoEnableDisable then Exit;

 UseDefault^ := StratDefault.Checked;

 If not DateStrat.Checked then begin
                                 SDGrid.Enabled:=False;
                                 SDGrid.Color:=ClGray;
                                 SDNav.Enabled:=False;            
                               end
                          else begin {dynamic checked}
                                 SDGrid.Enabled:=True;
                                 SDGrid.Color:=EditColor;
                                 SDNav.Enabled:=True;
                               end;
 end;

procedure TStratFlowForm.UseConstZTButtonClick(Sender: TObject);
begin
 If NoEnableDisable then Exit;

 ZTPointer^.NoUserLoad := NoZTUserLoad.Checked;
 ZTPointer^.UseConstant := UseConstZTButton.Checked;
 If not UseDynamZTButton.Checked then begin
                                       ConstZTEdit.Enabled := UseConstZTButton.Checked;
                                       ZTGrid.Enabled:=False;
                                       ZTGrid.Color:=ClGray;
                                       ZTNav.Enabled:=False;
                                     end
                                else begin {dynamic checked}
                                       ConstZTEdit.Enabled:=False;
                                       ZTGrid.Enabled:=True;
                                       ZTGrid.Color:=EditColor;
                                       ZTNav.Enabled:=True;
                                     end;
end;

procedure TStratFlowForm.SDChangeButtonClick(Sender: TObject);
Var Nm: String;
begin
  Nm := 'Stratification and Overturn ("1" and "0")';

  SDTable.Active:=False;
  ImportForm.ChangeLoading(Nm,SDTable,False,False, CTNone);
  SDTable.Active:=True;

  TFloatField(SDTable.Fields[1]).DisplayFormat:='0';
  Update;
end;


procedure TStratFlowForm.ZTImportButtClick(Sender: TObject);
Var Nm: String;
begin
  Nm := 'Variable Thermocline Depth (m)';

  ZTTable.Active:=False;
  ImportForm.ChangeLoading(Nm,ZTTable,False,False, CTDepth);
  ZTTable.Active:=True;

  TFloatField(ZTTable.Fields[1]).DisplayFormat:='###0.###';
  Update;
end;

end.
