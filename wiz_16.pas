//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit wiz_16;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Global, AQUAOBJ,
  wizardbase, StdCtrls, ExtCtrls, Db, DBTables, DBCtrls, Grids, DBGrids, WizGlobal, Loadings, hh;

type
  TWizBase16 = class(TWizBase)
    Panel8: TPanel;
    LoadUnitLabel2: TLabel;
    LoadUnitLabel: TLabel;
    Grid: TDBGrid;
    DynamButt: TRadioButton;
    ConstButt: TRadioButton;
    Button10: TButton;
    Nav: TDBNavigator;
    FImport: TButton;
    Table1: TTable;
    DataSource1: TDataSource;
    InSimLabel: TLabel;
    LoadBox: TListBox;
    ConstEdit: TEdit;
    IgnoreAllButt: TCheckBox;
    procedure enabledisable(Sender: TObject);
    procedure LoadBoxClick(Sender: TObject);
    procedure ConstEditExit(Sender: TObject);
    procedure GridExit(Sender: TObject);
    procedure FImportClick(Sender: TObject);
    procedure NavClick(Sender: TObject; Button: TNavigateBtn);
    procedure IgnoreAllButtClick(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    Function  ExecuteScreen: WizOutput; override;
    Procedure UpdateScreen; virtual;
    Procedure GetTableData;
    Procedure PutTableData;
  end;

var
  WizBase16: TWizBase16;
  InflowVar: Array[1..300] of AllVariables;
  InflowTyp: Array[1..300] of T_SVType;
  CurrentVar: AllVariables;
  CurrentTyp: T_SVType;
  DBaseNeedsSaving: Boolean;
  HourlyMode: Boolean;
  {}
  
implementation

uses imp_load, Convert;

{$R *.DFM}

        {----------------------------------------------------------}
        Procedure LoadingsFromTable(Table: TTable; Var LColl: TLoadings);
        {Copies loadings data from the table to the Collection}
        Var loop,recnum: Integer;
            NewLoad:     TLoad;
            HourlyLdg :     Boolean;
        Begin
            HourlyLdg := False;
            If LColl <>nil then HourlyLdg := LColl.Hourly;
            If LColl<>nil then LColl.Destroy;
            With Table do begin
              First;
              RecNum:=RecordCount;
              Lcoll:=TLoadings.Init(RecNum,10);
              LColl.Hourly := HourlyLdg;
                 For loop:=1 to RecNum do
                      begin
                           NewLoad:= TLoad.Init(Fields[0].AsDateTime,Fields[1].AsFloat);
                           LColl.Insert(NewLoad);
                           Next;
                      end; {for do}
              Active := False;
            end; {with}

        End; {LoadingsFromTable}
        {----------------------------------------------------------}



Function HasInflowLoad(Vr: AllVariables; Tp: T_SVType): Boolean;
Begin
  HasInflowLoad := True;
  If (Vr in [SedmRefrDetr,SedmLabDetr,DissLabDetr..SuspLabDetr,TSS,
             BuriedRefrDetr, BuriedLabileDetr])
    then HasInflowLoad := False;
End;

Procedure TWizBase16.GetTableData;
Var PSV: TStateVariable;
    PDRD: TDissRefrDetr;
Begin
  If not Table1.Active then Exit;

  Try
   WizBusy := True;

  If CurrentVar<>NullStateVar then
    Begin
      PSV := WizStudy.SV.GetStatePointer(CurrentVar,CurrentTyp,WaterCol);
      If CurrentVar=DissRefrDetr
        then Begin
               PDRD := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
               If CurrentTyp=StV
                 then LoadingsFromTable(Table1,PDRD.InputRecord.Load.Loadings)
                 else LoadingsFromTable(Table1,PDRD.InputRecord.ToxLoad[CurrentTyp].Loadings);
             End
        else LoadingsFromTable(Table1,PSV.LoadsRec.Loadings);
    End;

  Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;

End;


Procedure TWizBase16.PutTableData;
Var TableIn: TTable;
    i: Integer;
    DynLoad: TLoadings;
    PSV: TStateVariable;
    PDRD: TDissRefrDetr;

         Procedure PutInDbase(P: TLoad);
         {Used to put loadings data into TableIn}
         begin
            With TableIn do
               begin
                 Append;
                 Fields[0].AsDateTime:= P.Date;
                 Fields[1].AsFloat:=P.Loading;
                 TFloatField(Fields[1]).DisplayFormat:='0.0000';
                 Post;
               end;
         end;

Begin
  WizBusy := True;
  Try

  HourlyMode := False;
  Table1.Active:=False;
  Table1.DatabaseName:=Program_Dir;
  Table1.TableName := 'Load8.db';
  Table1.EmptyTable;
  Table1.Active := True;

  PSV := WizStudy.SV.GetStatePointer(CurrentVar,CurrentTyp,WaterCol);
  If CurrentVar=DissRefrDetr
    then Begin
           PDRD := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
           If CurrentTyp=StV
             then DynLoad := PDRD.InputRecord.Load.Loadings
             else DynLoad := PDRD.InputRecord.ToxLoad[CurrentTyp].Loadings;
         End
    else DynLoad := PSV.LoadsRec.Loadings;

  If DynLoad.hourly then
    Begin
      HourlyMode := True;
      Table1.Active := False;
      Table1.TableName := 'LoadHour.db';
      Table1.EmptyTable;
      Table1.Active := True;
    End;

  TableIn := Table1;
    With DynLoad do
      For i:=0 to count-1 do
        PutInDbase(at(i));

  Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;
        

  DBaseNeedsSaving := False;
End;



Procedure TWizBase16.UpdateScreen;
Var VarLoop: AllVariables;
    TypLoop: T_SVType;
    IDStr,UName: String;
    PSV : TStateVariable;
    PDRD: TDissRefrDetr;
    NumFlows: Integer;
    ConstCh: Boolean;
    ThisLoad: LoadingsRecord;
Begin
  If Not W16_ListWritten then
    Begin
      NumFlows := 0;
      LoadBox.Items.Clear;
      For TypLoop := StV to LastToxTyp do
       For VarLoop := H2OTox1 to Fish15 do
        Begin
          PSV := WizStudy.SV.GetStatePointer(VarLoop,TypLoop,WaterCol);
          If (PSV<>nil) and (HasInflowLoad(VarLoop,TypLoop)) then
            Begin
              Inc(NumFlows);
              InflowVar[NumFlows] := VarLoop;
              InflowTyp[NumFlows] := TypLoop;
              If VarLoop=DissRefrDetr
                then UName:='Susp and Diss Detr'
                else UName := WizStudy.SV.UniqueName(VarLoop);
              If (TypLoop in [OrgTox1..OrgTox20]) then UName := ' '+UName;
              IDStr := OutputText(VarLoop,TypLoop,WaterCol,UName,False,False,0);
              Loadbox.Items.Add('Inflow '+IDStr);
            End
        End;
      W16_ListWritten := True;
    End;

  If LoadBox.ItemIndex=-1 then
    Begin
      CurrentVar := NullStateVar;
      ConstEdit.Enabled:=False;
      Grid.Enabled:=False;
      Grid.Color:=ClGray;
      Nav.Enabled:=False;
      Panel8.Enabled := False;
      Panel8.Color := clBtnFace;
      DynamButt.Enabled := False;
      ConstButt.Enabled := False;
      LoadUnitLabel.Enabled := False;
      LoadUnitLabel2.Enabled := False;
      IgnoreAllButt.Visible := False;
      exit;
    End;

  LoadUnitLabel.Enabled := True;
  LoadUnitLabel2.Enabled := True;
  DynamButt.Enabled := True;
  ConstButt.Enabled := True;
  Panel8.Enabled := True;
  Panel8.Color := clBtnFace;
  CurrentVar := InflowVar[LoadBox.ItemIndex+1];
  CurrentTyp := InflowTyp[LoadBox.ItemIndex+1];

  PSV := WizStudy.SV.GetStatePointer(CurrentVar,CurrentTyp,WaterCol);
  If CurrentVar=DissRefrDetr
    then Begin
           PDRD := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
           If CurrentTyp=StV
             then ThisLoad := PDRD.InputRecord.Load
             else ThisLoad := PDRD.InputRecord.ToxLoad[CurrentTyp];
         End
    else ThisLoad := PSV.LoadsRec;


  If CurrentVar in [Phosphate,Ammonia,Nitrate,CO2,Oxygen]
     then IgnoreAllButt.Visible := True
     else IgnoreAllButt.Visible := False;
  IgnoreAllButt.Checked := ThisLoad.NoUserLoad;

  If IgnoreAllButt.Visible and IgnoreAllButt.Checked then
    Begin
      ConstEdit.Enabled:=False;
      Grid.Enabled:=False;
      Grid.Color:=ClGray;
      Nav.Enabled:=False;
      Panel8.Enabled := False;
      Panel8.Color := ClGray;
      DynamButt.Enabled := False;
      ConstButt.Enabled := False;
      LoadUnitLabel.Enabled := False;
      LoadUnitLabel2.Enabled := False;
    End;

  ConstCh := ThisLoad.UseConstant;
  ConstButt.Checked := ConstCh;
  DynamButt.Checked := Not ConstCh;
  EnableDisable(nil);

  ConstEdit.Text :=  FloatToStrF(Thisload.ConstLoad,ffgeneral,9,4);
  LoadUnitLabel.Caption := PSV.LoadingUnit;
  LoadUnitLabel2.Caption := PSV.LoadingUnit;

End;




Function  TWizBase16.ExecuteScreen: WizOutput;
Begin
  If FirstVisit then W16_DataChanged := False;
  W16_ListWritten := False;
  CurrentVar := NullStateVar;
  DBaseNeedsSaving := False;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;

  If DBaseNeedsSaving then GetTableData;
  If (WizStatus=0) then WizStatus := 2;
  If (WizStatus=1) and (W16_DataChanged) then WizStatus := 2;

End;


procedure TWizBase16.enabledisable(Sender: TObject);
Var ConstChosen: Boolean;
    PSV: TStateVariable;
    PDRD: TDissRefrDetr;
    PThisLoad: PLoadingsRecord;
Begin
  If IgnoreAllButt.Visible and IgnoreAllButt.Checked then exit;

  ConstChosen := ConstButt.Checked;

  If CurrentVar<>NullStateVar then
    Begin
      PSV := WizStudy.SV.GetStatePointer(CurrentVar,CurrentTyp,WaterCol);
      If CurrentVar=DissRefrDetr
        then Begin
               PDRD := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
               If CurrentTyp=StV
                 then PThisLoad := @(PDRD.InputRecord.Load)
                 else PThisLoad := @(PDRD.InputRecord.ToxLoad[CurrentTyp]);
             End
        else PThisLoad := @(PSV.LoadsRec);

      If PThisLoad^.UseConstant <> ConstChosen then W16_DataChanged := True;
      PThisLoad^.UseConstant := ConstChosen;
    End;

  If ConstChosen then  begin
                         ConstEdit.Enabled:=True;
                         Grid.Enabled:=False;
                         Grid.Color:=ClGray;
                         Nav.Enabled:=False;
                       end
                  else begin
                         ConstEdit.Enabled:=False;
                         Grid.Enabled:=True;
                         Grid.Color:=EditColor;
                         Nav.Enabled:=True;
                       end;


end;

procedure TWizBase16.LoadBoxClick(Sender: TObject);

begin
  If DBaseNeedsSaving then GetTableData;
  UpdateScreen;
  PutTableData;
end;

procedure TWizBase16.ConstEditExit(Sender: TObject);
Var Conv  : Double;
    Result: Integer;
    Txt: String;
    PSV: TStateVariable;
    PDRD: TDissRefrDetr;

begin
  Txt :=TEdit(Sender).Text;
  If Trim(Txt)='' then Txt :='0';
  Val(Txt,Conv,Result);
  Conv:=Abs(Conv);
  If (Result<>0)
    then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
    else
      Begin
        W16_DataChanged := True;
        PSV := WizStudy.SV.GetStatePointer(CurrentVar,CurrentTyp,WaterCol);
        If CurrentVar=DissRefrDetr
          then Begin
                 PDRD := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
                 If CurrentTyp=StV
                   then PDRD.InputRecord.Load.ConstLoad := Conv
                   else PDRD.InputRecord.ToxLoad[CurrentTyp].ConstLoad := Conv;
               End
          else PSV.LoadsRec.ConstLoad := Conv;
      End;
  UpdateScreen;
end;

procedure TWizBase16.GridExit(Sender: TObject);
begin
  W16_DataChanged := True;
  DBaseNeedsSaving := True;
end;

procedure TWizBase16.FImportClick(Sender: TObject);
begin
  W16_DataChanged:=True;
  DBaseNeedsSaving   := True;
  Table1.Active:=False;

  ImportForm.ChangeLoading(LoadBox.Items[LoadBox.ItemIndex]+' ('+LoadUnitLabel2.Caption+')',Table1,False,HourlyMode, CTNone);
  Table1.Active:=True;
  Update;
end;

procedure TWizBase16.NavClick(Sender: TObject; Button: TNavigateBtn);
begin
  DBaseNeedsSaving := True;
end;

procedure TWizBase16.IgnoreAllButtClick(Sender: TObject);
Var IgnoreChosen: Boolean;
    PSV: TStateVariable;
begin
  IgnoreChosen := IgnoreAllButt.Checked;

  If CurrentVar<>NullStateVar then
    Begin
      PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
      IF (PSV.LoadsRec.NoUserLoad<>IgnoreChosen) then W16_DataChanged := True;
      PSV.LoadsRec.NoUserLoad := IgnoreChosen;
    End;

  UpdateScreen;
end;

procedure TWizBase16.Button10Click(Sender: TObject);
begin
  HTMLHelpContext('Important_Note_about_Dynamic_Loadings.htm');
end;

procedure TWizBase16.FormCreate(Sender: TObject);
begin
  HourlyMode := False;
  inherited;

end;

end.

 