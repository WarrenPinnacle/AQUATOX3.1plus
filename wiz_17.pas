//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit wiz_17;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Global, AQUAOBJ,
  wizardbase, StdCtrls, ExtCtrls, Db, DBTables, DBCtrls, Grids, DBGrids, WizGlobal, Loadings, hh;

type
  TWizBase17 = class(TWizBase)
    Panel8: TPanel;
    DPUnitLabel2: TLabel;
    DPUnitLabel: TLabel;
    Grid: TDBGrid;
    DynamButt: TRadioButton;
    ConstButt: TRadioButton;
    Button10: TButton;
    Nav: TDBNavigator;
    FImport: TButton;
    Table2: TTable;
    DataSource1: TDataSource;
    InSimLabel: TLabel;
    LoadBox: TListBox;
    ConstEdit: TEdit;
    IgnoreAllButt: TCheckBox;
    procedure EnableDisable(Sender: TObject);
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
  WizBase17: TWizBase17;
  DPVar: Array[1..50] of AllVariables;
  CurrentVar: AllVariables;
  DBaseNeedsSaving: Boolean;

implementation

uses imp_load,convert;

{$R *.DFM}

        {----------------------------------------------------------}
        Procedure LoadingsFromTable(Table: TTable; Var LColl: Tloadings);
        {Copies loadings data from the table to the Collection}
        Var loop,recnum: Integer;
            NewLoad:     TLoad;
        Begin
            If LColl<>nil then LColl.Destroy;
            With Table do begin
              First;
              RecNum:=RecordCount;
              Lcoll:=Tloadings.Init(RecNum,10);
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

Function HasDTLoad(Vr: AllVariables): Boolean;
Begin
  HasDTLoad := Has_Alt_Loadings(Vr,StV,WaterCol);
  If Vr in [DissRefrDetr..SuspLabDetr] then HasDTLoad := False;
End;

Procedure TWizBase17.GetTableData;
Var PSV: TStateVariable;
Begin
  If not Table2.Active then Exit;

  Try
   WizBusy := True;

  If CurrentVar<>NullStateVar then
    Begin
      PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
      LoadingsFromTable(Table2,PSV.LoadsRec.Alt_Loadings[DirectPrecip]);
    End;

  Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;

End;


Procedure TWizBase17.PutTableData;
Var TableIn: TTable;
    i: Integer;
    DynLoad: Tloadings;
    PSV: TStateVariable;

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


  Table2.DatabaseName:=Program_Dir;
  Table2.Active:=False;
  Table2.EmptyTable;
  Table2.Active := True;

  PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
  DynLoad := PSV.LoadsRec.Alt_Loadings[DirectPrecip];

  TableIn := Table2;
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


Procedure TWizBase17.UpdateScreen;
Var VarLoop: AllVariables;
    IDStr,UName: String;
    PSV : TStateVariable;
    NumDPs: Integer;
    ConstCh: Boolean;
    ThisLoad: LoadingsRecord;
Begin
  If Not W17_ListWritten then
    Begin
      NumDPs := 0;
      LoadBox.Items.Clear;
       For VarLoop := H2OTox1 to Fish15 do
        Begin
          PSV := WizStudy.SV.GetStatePointer(VarLoop,StV,WaterCol);
          If (PSV<>nil) and (HasDTLoad(VarLoop)) then
            Begin
              Inc(NumDPs);
              DPVar[NumDPs] := VarLoop;
              UName := WizStudy.SV.UniqueName(VarLoop);
              IDStr := OutputText(VarLoop,StV,WaterCol,UName,False,False,0);
              If VarLoop in [FirstFish..LastFish]
                 then Loadbox.Items.Add('Fish Stocking of '+IDStr)
                 else Loadbox.Items.Add('Direct Precip. of '+IDStr);
            End
        End;
      W17_ListWritten := True;
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
      DPUnitLabel.Enabled := False;
      DPUnitLabel2.Enabled := False;
      IgnoreAllButt.Visible := False;
      exit;
    End;

  DPUnitLabel.Enabled := True;
  DPUnitLabel2.Enabled := True;
  DynamButt.Enabled := True;
  ConstButt.Enabled := True;
  Panel8.Enabled := True;
  Panel8.Color := clBtnFace;
  CurrentVar := DPVar[LoadBox.ItemIndex+1];

  PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
  ThisLoad := PSV.LoadsRec;

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
      DPUnitLabel.Enabled := False;
      DPUnitLabel2.Enabled := False;
    End;

  ConstCh := ThisLoad.Alt_UseConstant[DirectPrecip];
  ConstButt.Checked := ConstCh;
  DynamButt.Checked := Not ConstCh;
  EnableDisable(nil);

  ConstEdit.Text :=  FloatToStrF(ThisLoad.Alt_ConstLoad[DirectPrecip],ffgeneral,9,4);

End;




Function  TWizBase17.ExecuteScreen: WizOutput;
Begin
  If FirstVisit then w17_DataChanged := False;
  W17_ListWritten := False;
  CurrentVar := NullStateVar;
  DBaseNeedsSaving := False;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;

  If DBaseNeedsSaving then GetTableData;
  If (WizStatus=0) then WizStatus := 2;
  If (WizStatus=1) and (w17_DataChanged) then WizStatus := 2;

End;


procedure TWizBase17.enabledisable(Sender: TObject);
Var ConstChosen: Boolean;
    PSV: TStateVariable;
Begin
  If IgnoreAllButt.Visible and IgnoreAllButt.Checked then exit;

  ConstChosen := ConstButt.Checked;

  If CurrentVar<>NullStateVar then
    Begin
      PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
      IF (PSV.LoadsRec.Alt_UseConstant[DirectPrecip]<>ConstChosen) then w17_DataChanged := True;
      PSV.LoadsRec.Alt_UseConstant[DirectPrecip] := ConstChosen;
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

procedure TWizBase17.LoadBoxClick(Sender: TObject);

begin
  If DBaseNeedsSaving then GetTableData;
  UpdateScreen;
  PutTableData;
end;

procedure TWizBase17.ConstEditExit(Sender: TObject);
Var Conv  : Double;
    Result: Integer;
    Txt: String;
    PSV: TStateVariable;

begin
  Txt :=TEdit(Sender).Text;
  If Trim(Txt)='' then Txt :='0';
  Val(Txt,Conv,Result);
  Conv:=Abs(Conv);
  If (Result<>0)
    then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
    else
      Begin
        w17_DataChanged := True;
        PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
        PSV.loadsrec.Alt_ConstLoad[DirectPrecip] := Conv;
      End;
  UpdateScreen;
end;

procedure TWizBase17.GridExit(Sender: TObject);
begin
  w17_DataChanged := True;
  DBaseNeedsSaving := True;
end;

procedure TWizBase17.FImportClick(Sender: TObject);
begin
  w17_DataChanged := True;
  DBaseNeedsSaving   := True;
  Table2.Active:=False;
  ImportForm.ChangeLoading(LoadBox.Items[LoadBox.ItemIndex]+' (g/m2 d)',Table2,False,False,CTNone);
  Table2.Active:=True;
  Update;
end;

procedure TWizBase17.NavClick(Sender: TObject; Button: TNavigateBtn);
begin
  DBaseNeedsSaving := True;
end;


procedure TWizBase17.IgnoreAllButtClick(Sender: TObject);
Var IgnoreChosen: Boolean;
    PSV: TStateVariable;
begin
  IgnoreChosen := IgnoreAllButt.Checked;

  If CurrentVar<>NullStateVar then
    Begin
      PSV := WizStudy.SV.GetStatePointer(CurrentVar,StV,WaterCol);
      IF (PSV.LoadsRec.NoUserLoad<>IgnoreChosen) then w17_DataChanged := True;
      PSV.LoadsRec.NoUserLoad := IgnoreChosen;
    End;

  UpdateScreen;
End;

procedure TWizBase17.Button10Click(Sender: TObject);
begin
  HTMLHelpContext('Important_Note_about_Dynamic_Loadings.htm');
end;

end.
