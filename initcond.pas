//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
unit Initcond;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Global, Aquaobj, StdCtrls, AQSTUDY, AQBaseForm,
  Grids, DBGrids, DB, DBTables, ExtCtrls, Buttons, AQSite, dbgrids2;

type
  TInitCondForm = class(TAQBase)
    DataSource1: TDataSource;

    Table1: TTable;
    Panel1: TPanel;
    Label3: TLabel;
    OKBtn: TBitBtn;
    PrinterSetupDialog1: TPrinterSetupDialog;
    DbGrid1: TDBGrid2;
    HelpButton: TButton;
    PlantExportButt: TButton;
    procedure Table1BeforeInsert(DataSet: TDataset);
    procedure HelpButtonClick(Sender: TObject);
    procedure PlantExportButtClick(Sender: TObject);
  private
    Insertable: Boolean;
    { Private declarations }
  public
    FileN: String;
    Procedure Show_Init_Conds(SV: TStates; FileName: String);
  end;

var
  InitCondForm: TInitCondForm;

implementation

Uses Grid2Excel, hh;

procedure TInitCondForm.PlantExportButtClick(Sender: TObject);
begin
  DBGrid2Excel(TDBGrid(DBGrid1), FileN +  '_Init_Conds.xls',True)
end;

Procedure TInitCondForm.Show_Init_Conds(SV: TStates; FileName: String);

Var SVLoop, TestVar: AllVariables;
    TypLoop: T_SVType;
    PreText: String;
    SVptr  : TStateVariable;
    i, FieldIndex: Integer;


          Procedure AddtoDB(p: TStateVariable);
          {Add one state variable to the database of Init Conds}
          Begin
           With Table1 do
           Begin
             If P.SVType= StV then
               Begin
                 Append;
                 Fields[0].AsString :=OutputText(P.nstate,P.SVType,P.layer,SV.UniqueName(P.NState),False,False,0);
               End;

             Inc(FieldIndex);
             Fields[FieldIndex].AsFloat  :=p.InitialCond;
             If (p.InitialCond < 0.0001) and (P.InitialCond > tiny) then TFloatField(Table1.Fields[1]).DisplayFormat:='0.0000e-00';
             Inc(FieldIndex);
             Fields[FieldIndex].AsString :=P.StateUnit;
           End; {with}
          End;


Begin
 FileN := FileName;
 Insertable:=True;
 With InitCondForm.Table1 do
  begin
     Active:=False;
     DatabaseName:=Program_Dir;
     TableName:='InitCond.DB';
     FieldDefs.Clear;
     IndexDefs.Clear;
     FieldDefs.Add('State Variable Name',ftString,28,False);
     FieldDefs.Add('Init. Cond.',ftFloat,0,False);
     FieldDefs.Add('Units',ftString,12,False);

     For TypLoop := FirstToxTyp to LastToxTyp do
       Begin
         Case TypLoop of
           FirstOrgTxTyp..LastOrgTxTyp: PreText :='Tox'+ IntToStr(Ord(TypLoop));
         end; {case}

         TestVar := AssocToxSV(TypLoop);

         SVPtr:=SV.GetStatePointer(TestVar,StV,WaterCol);
         If SVPtr <> nil then
           Begin
             FieldDefs.Add(PreText+' I. C.',ftFloat,0,False);
             FieldDefs.Add(PreText+' Units',ftString,8,False);
           End;
       End; {TypLoop}

     CreateTable;
     Active:=True;

    TFloatField(Table1.Fields[1]).DisplayFormat:='###0.####';
    For SVloop:= FirstState to LastState do
     Begin
      FieldIndex := 0;
       For TypLoop := StV to LastOrgTxTyp do
        Begin
          SVPtr := SV.GetStatePointer(SVLoop,TypLoop,WaterCol);
          If not (SVPtr = nil) then AddtoDB(SVPtr);
        End;
     End;

    For i := 0 to FieldCount - 1 do
      If i mod 2 = 0 then
        Fields[i].ReadOnly:=True;

    First;

  End; {with initcondtable}

  Insertable:=False;

  InitCondForm.WindowState:=WSMaximized;
  If InitCondForm.ShowModal = MrCancel then exit;


end;


{$R *.DFM}


procedure TInitCondForm.Table1BeforeInsert(DataSet: TDataset);
begin
   If not Insertable then Raise EAquatoxError.Create('No Insertions or Deletions may be made.');
end;

procedure TInitCondForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic44.htm');
end;

end.

