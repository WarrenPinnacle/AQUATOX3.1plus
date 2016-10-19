//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit wiz_19;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Global, AQUAOBJ, hh,
  wizardbase, StdCtrls, ExtCtrls, Db, DBTables, DBCtrls, Grids, DBGrids, WizGlobal, Loadings;

type
  TWizBase19 = class(TWizBase)
    Panel8: TPanel;
    NPSUnitLabel2: TLabel;
    NPSUnitLabel: TLabel;
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
  private
    { Private declarations }
  public
    Function  ExecuteScreen: WizOutput; override;
    Procedure UpdateScreen; virtual;
    Procedure GetTableData;
    Procedure PutTableData;
  end;

var
  WizBase19: TWizBase19;
  NPSVar: Array[1..50] of AllVariables;
  CurrentVar: AllVariables;
  DBaseNeedsSaving: Boolean;

implementation

uses imp_load, Convert;

{$R *.DFM}

        {----------------------------------------------------------}
        Procedure LoadingsFromTable(Table: TTable; Var LColl: TLoadings);
        {Copies loadings data from the table to the Collection}
        Var loop,recnum: Integer;
            NewLoad:     TLoad;
        Begin
            If LColl<>nil then LColl.Destroy;
            With Table do begin
              First;
              RecNum:=RecordCount;
              Lcoll:=TLoadings.Init(RecNum,10);
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



Function HasNPSLoad(Vr: AllVariables): Boolean;
Begin
  HasNPSLoad := Has_Alt_Loadings(Vr,StV,WaterCol);
End;

Procedure TWizBase19.GetTableData;
Var PSV: TStateVariable;
    PDRD: TDissRefrDetr;
Begin
  If not Table1.Active then Exit;

  Try
   WizBusy := True;
  
  If CurrentVar<>NullStateVar then
    Begin
      PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
      If CurrentVar=DissRefrDetr
        then Begin
               PDRD := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
               LoadingsFromTable(Table1,PDRD.InputRecord.Load.Alt_Loadings[NonPointsource])
             End
        else LoadingsFromTable(Table1,PSV.LoadsRec.Alt_Loadings[NonPointsource]);
    End;

  Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;
    
End;


Procedure TWizBase19.PutTableData;
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
                 Post;
               end;
         end;

Begin
  WizBusy := True;
  Try

  Table1.DatabaseName:=Program_Dir;
  Table1.Active:=False;
  Table1.EmptyTable;
  Table1.Active := True;

  PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
  If CurrentVar=DissRefrDetr
    then Begin
           PDRD := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
           DynLoad := PDRD.InputRecord.Load.Alt_Loadings[NonPointsource]
         End
    else DynLoad := PSV.LoadsRec.Alt_Loadings[NonPointsource];

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



Procedure TWizBase19.UpdateScreen;
Var VarLoop: AllVariables;
    IDStr,UName: String;
    PSV : TStateVariable;
    PDRD: TDissRefrDetr;
    NumFlows: Integer;
    ConstCh: Boolean;
    ThisLoad: LoadingsRecord;
Begin
  If Not W19_ListWritten then
    Begin
      NumFlows := 0;
      LoadBox.Items.Clear;
       For VarLoop := H2OTox1 to Fish15 do
        Begin
          PSV := WizStudy.SV.GetStatePointer(VarLoop,StV,WaterCol);
          If (PSV<>nil) and (HasNPSLoad(VarLoop)) and
             (not (varloop in[DissLabDetr..SuspLabDetr])) then
            Begin
              Inc(NumFlows);
              NPSVar[NumFlows] := VarLoop;
              If VarLoop=DissRefrDetr
                then UName:='Susp and Diss Detr'
                else UName := WizStudy.SV.UniqueName(VarLoop);
              IDStr := OutputText(VarLoop,StV,WaterCol,UName,False,False,0);
              Loadbox.Items.Add('Non Point-Source '+IDStr);
            End
        End;
      W19_ListWritten := True;
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
      NPSUnitLabel.Enabled := False;
      NPSUnitLabel2.Enabled := False;
      IgnoreAllButt.Visible := False;
      exit;
    End;

  NPSUnitLabel.Enabled := True;
  NPSUnitLabel2.Enabled := True;
  DynamButt.Enabled := True;
  ConstButt.Enabled := True;
  Panel8.Enabled := True;
  Panel8.Color := clBtnFace;
  CurrentVar := NPSVar[LoadBox.ItemIndex+1];

  PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
  If CurrentVar=DissRefrDetr
    then Begin
           PDRD := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
           ThisLoad := PDRD.InputRecord.Load
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
      NPSUnitLabel.Enabled := False;
      NPSUnitLabel2.Enabled := False;
    End;


  ConstCh := ThisLoad.Alt_UseConstant[NonPointsource];
  ConstButt.Checked := ConstCh;
  DynamButt.Checked := Not ConstCh;
  EnableDisable(nil);

  ConstEdit.Text :=  FloatToStrF(Thisload.Alt_ConstLoad[NonPointsource],ffgeneral,9,4);

End;




Function  TWizBase19.ExecuteScreen: WizOutput;
Begin
  If FirstVisit then W19_DataChanged := False;
  W19_ListWritten := False;
  CurrentVar := NullStateVar;
  DBaseNeedsSaving := False;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;

  If DBaseNeedsSaving then GetTableData;
  If (WizStatus=0) then WizStatus := 2;
  If (WizStatus=1) and (W19_DataChanged) then WizStatus := 2;

End;


procedure TWizBase19.enabledisable(Sender: TObject);
Var ConstChosen: Boolean;
    PSV: TStateVariable;
    PDRD: TDissRefrDetr;
    PThisLoad: PLoadingsRecord;
Begin
  If IgnoreAllButt.Visible and IgnoreAllButt.Checked then exit;

  ConstChosen := ConstButt.Checked;

  If CurrentVar<>NullStateVar then
    Begin
      PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
      If CurrentVar=DissRefrDetr
        then Begin
               PDRD := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
               PThisLoad := @(PDRD.InputRecord.Load)
             End
        else PThisLoad := @(PSV.LoadsRec);

      If PThisLoad^.Alt_UseConstant[NonPointSource] <> ConstChosen then W19_DataChanged := True;
      PThisLoad^.Alt_UseConstant[NonPointSource] := ConstChosen;
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

procedure TWizBase19.LoadBoxClick(Sender: TObject);

begin
  If DBaseNeedsSaving then GetTableData;
  UpdateScreen;
  PutTableData;
end;

procedure TWizBase19.ConstEditExit(Sender: TObject);
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
        W19_DataChanged := True;
        PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
        If CurrentVar=DissRefrDetr
          then Begin
                 PDRD := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
                 PDRD.InputRecord.Load.Alt_ConstLoad[NonPointsource] := Conv;
               End
          else PSV.LoadsRec.Alt_ConstLoad[NonPointsource] := Conv;
      End;
  UpdateScreen;
end;

procedure TWizBase19.GridExit(Sender: TObject);
begin
  W19_DataChanged := True;
  DBaseNeedsSaving := True;
end;

procedure TWizBase19.FImportClick(Sender: TObject);
begin
  W19_DataChanged:= True;
  DBaseNeedsSaving   := True;
  Table1.Active:=False;
  ImportForm.ChangeLoading(LoadBox.Items[LoadBox.ItemIndex]+' ('+NPSUnitLabel2.Caption+')',Table1,False,False,CTNone);
  Table1.Active:=True;
  Update;
end;

procedure TWizBase19.NavClick(Sender: TObject; Button: TNavigateBtn);
begin
  DBaseNeedsSaving := True;
end;

procedure TWizBase19.IgnoreAllButtClick(Sender: TObject);
Var IgnoreChosen: Boolean;
    PSV: TStateVariable;
begin
  IgnoreChosen := IgnoreAllButt.Checked;

  If CurrentVar<>NullStateVar then
    Begin
      PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
      IF (PSV.LoadsRec.NoUserLoad<>IgnoreChosen) then W19_DataChanged := True;
      PSV.LoadsRec.NoUserLoad := IgnoreChosen;
    End;

  UpdateScreen;
End;

procedure TWizBase19.Button10Click(Sender: TObject);
begin
  HTMLHelpContext('Important_Note_about_Dynamic_Loadings.htm');
end;

end.
