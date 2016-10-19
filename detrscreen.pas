//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Detrscreen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Global,
  edstatev, Db, DBTables, Buttons, StdCtrls, DBCtrls, Grids, DBGrids, Loadings, hh,
  ExtCtrls, AQUAOBJ, TCollect;

type
  TEditDetritus = class(TStateVarDialog)
    Panel2: TPanel;
    OrgMattButt: TRadioButton;
    Label1: TLabel;
    OrgCarbButt: TRadioButton;
    BODButt: TRadioButton;
    Mode1: TButton;
    Mode2: TButton;
    Mode3: TButton;
    Mode4: TButton;
    Mode5: TButton;
    ICPanel: TPanel;
    NPSBreakCaption: TLabel;
    ICNPSEdit: TEdit;
    Label2: TLabel;
    AWOMlabel: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    LoadingBox: TComboBox;
    procedure ModeButtonsClick(Sender: TObject);
    procedure Verify_Detr_Num(Sender: TObject);
    procedure OrgMattButtClick(Sender: TObject);
    procedure Verify_Detr_Num2(Sender: TObject);
    procedure Verify_Detr_Tox(Sender: TObject);
    procedure EnableDisable(Sender: TObject);
    procedure enabledisable6(Sender: TObject);
    procedure enabledisable2(Sender: TObject);
    procedure ToxComboBoxChange2(Sender: TObject);
    procedure NotesEditExit(Sender: TObject);
    procedure LoadingBoxChange(Sender: TObject);
    procedure ImportButt1Click(Sender: TObject);
    procedure ImportButt6Click(Sender: TObject);
    procedure ImportButt3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
  private
    Procedure CopyDetritalInputRec(Var FromRec,ToRec: DetritalInputRecordType);
    Procedure DisposeDetritalInputRec(Var TheRec: DetritalInputRecordType);
    Procedure SaveCurrentModeDB;
    { Private declarations }
  public
    Procedure CopyToTemp;
    Procedure CopyFromTemp;
    Procedure UpdateScreen;
    Procedure ChangeDisplayMode;
    Procedure EditDetr(IncomingS: TStateVariable);
    { Public declarations }
  end;

var
  EditDetritus: TEditDetritus;
  TempInputRecord: DetritalInputRecordType;
  TempNotes1,TempNotes2: String[50];
  PS: TStateVariable;
  DisplayMode : Integer;
  CurrentToxT  : T_SVType;
  CurrentLoad,CurrentTLoad  : Integer;  {0=inflow, 1=pointsource, 2=nonpointsource}

  NumToxs        : Integer;
  SelToxT        : Array[0..20] of T_SVType;
  ToxTableT      : Array[FirstOrgTox..LastOrgTox] of TTable;

implementation

uses Imp_Load,  Convert;

{$R *.DFM}

{-----------------------------------------------------------------------------------}

Procedure TEditDetritus.DisposeDetritalInputRec(Var TheRec: DetritalInputRecordType);
Var ToxLoop: T_SVType;
    Alt_Loop: Alt_LoadingsType;
Begin
  With TheRec do
    Begin
      Load.Loadings.Destroy;
      Percent_Part.Loadings.Destroy;
      Percent_Refr.Loadings.Destroy;

      For Alt_Loop := PointSource to NonPointSource do
        Begin
          If (Load.Alt_Loadings[Alt_Loop]<>nil) then Load.Alt_Loadings[Alt_Loop].Destroy;
          If (Percent_Part.Alt_Loadings[Alt_Loop] <> nil) then Percent_Part.Alt_Loadings[Alt_Loop].Destroy;
          If (Percent_Refr.Alt_Loadings[Alt_Loop] <> nil) then Percent_Refr.Alt_Loadings[Alt_Loop].Destroy;

          For ToxLoop:=FirstToxTyp to LastToxTyp do
            Begin
              If (ToxLoad[ToxLoop].Alt_Loadings[Alt_Loop] <> nil) then ToxLoad[ToxLoop].Alt_Loadings[Alt_Loop].Destroy;
              If Alt_Loop = PointSource then ToxLoad[ToxLoop].Loadings.Destroy;
            End;
        End;
    End;
End;

{-----------------------------------------------------------------------------------}

Procedure TEditDetritus.CopyDetritalInputRec(Var FromRec,ToRec: DetritalInputRecordType);

     {------------------------------------------------------------------------------}
     Procedure CopyLoadingsRec(Var FromR, ToR: LoadingsRecord);

          {-------------------------------------------------------------------------}
          Procedure CopyTLoadings(Var FromP, ToP: TLoadings);
          Var loop: Integer;
              OldL, NewL: TLoad;
          Begin
            If FromP=Nil
              then ToP := Nil
              Else
                Begin
                  ToP := TLoadings.Init(5,5);
                  For loop :=0 to FromP.Count - 1 do
                    Begin
                      OldL := TLoad(FromP.At(loop));
                      NewL := TLoad.Init(OldL.Date,OldL.Loading);
                      ToP.Insert(NewL);
                    End;
                End;
          End;
          {--------------------------------------------------------------------------}

     Var ALLoop:  Alt_LoadingsType;
     Begin
       ToR := FromR;
       CopyTLoadings(FromR.Loadings,ToR.Loadings);
       For ALLoop := PointSource to NonPointSource do
         CopyTLoadings(FromR.Alt_Loadings[ALLoop],ToR.Alt_Loadings[ALLoop]);
     End;
     {------------------------------------------------------------------------------}

Var ToxLoop: T_SVType;
Begin
  ToRec := FromRec;
  CopyLoadingsRec(FromRec.Load,ToRec.Load);
  CopyLoadingsRec(FromRec.Percent_Part,ToRec.Percent_Part);
  CopyLoadingsRec(FromRec.Percent_Refr,ToRec.Percent_Refr);
  For ToxLoop:=FirstToxTyp to LastToxTyp do
    CopyLoadingsRec(FromRec.ToxLoad[ToxLoop],ToRec.ToxLoad[ToxLoop]);

  ToRec.Load.Loadings.Hourly := FromRec.Load.Loadings.Hourly;
End;

{-----------------------------------------------------------------------------------}

Procedure TEditDetritus.CopyToTemp;
Var ToxLoop: T_SVType;
    TableIn: TTable;
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

Begin
  CopyDetritalInputRec(TDissRefrDetr(PS).InputRecord,TempInputRecord);

  TempNotes1 := PS.LoadNotes1;
  TempNotes2 := PS.LoadNotes2;

  CurrentToxT  := STV;
  CurrentLoad  := 0;
  CurrentTLoad := 0;

  NumToxs := 0;
  ToxComboBox.Items.Clear;
  For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
    Begin
      If PS.AllStates.GetIndex(PS.NState,ToxLoop,WaterCol) > -1 then
          Begin
            SelToxT[NumToxs] := ToxLoop;
            Inc(NumToxs);
            ToxComboBox.Items.Add(PS.ChemPtrs^[ToxLoop].ChemRec.ChemName);
            If CurrentToxT = STV then CurrentToxT := ToxLoop;
          End;
    End;

   If DissRefrDetr in HOURLYLIST then
     Begin
       DontUpdateHCB:= True;
       HourlyCB.Checked := TempInputRecord.Load.Loadings.hourly;
       DontUpdateHCB:= False;
     End;

  ToxComboBox.ItemIndex := 0;
  LoadingBox.ItemIndex  := 0;
  LoadingBox2.ItemIndex := 0;


   If (PS.NState in HOURLYLIST) then if TempInputRecord.Load.Loadings.hourly then
      Begin
        Table1.TableName := 'loadhour.DB';
        DBGrid1.Left := 30;
        DBGrid1.Width := 243;
      End;

  {Ready the Database Files for the Loadings Data}
  Table1.DatabaseName:=Program_Dir;   Table2.DatabaseName:=Program_Dir;
  Table1.Active:=False;               Table2.Active:=False;
  Table1.EmptyTable;                  Table2.EmptyTable;
  Table1.Active:=True;                Table2.Active:=True;

  Table5.DatabaseName:=Program_Dir;
  Table5.Active:=False;
  Table5.EmptyTable;
  Table5.Active:=True;

  {Load the Database Data into the Files}
  TableIn:=Table1;
  TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
  With TempInputRecord.Load.Loadings do
    For i:=0 to count-1 do
      PutInDbase(at(i));

  TableIn:=Table2;
  TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
  If CurrentToxT <> STV then
    With TempInputRecord.ToxLoad[CurrentToxT].Loadings do
      For i:=0 to count-1 do
        PutInDbase(at(i));

  TableIn:=Table5;
  TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
  With TempInputRecord.Load.Alt_Loadings[PointSource] do
    For i:=0 to count-1 do
      PutInDbase(at(i));

End;

{-----------------------------------------------------------------------------------}

Procedure TEditDetritus.CopyFromTemp;
Begin
  If (PS.nstate in HOURLYLIST) then TempInputRecord.Load.Loadings.Hourly := HourlyCB.Checked;

  If CurrentToxT<>StV then
    Case CurrentTLoad of
      0: LoadingsFromTable(Table2,TempInputRecord.ToxLoad[CurrentToxT].Loadings);
      1: LoadingsFromTable(Table2,TempInputRecord.ToxLoad[CurrentToxT].Alt_Loadings[pointsource]);
      2: LoadingsFromTable(Table2,TempInputRecord.ToxLoad[CurrentToxT].Alt_Loadings[nonpointsource]);
    End; {Case}

  LoadingsFromTable(Table1,TempInputRecord.Load.Loadings);
  SaveCurrentModeDB;
  If (PS.nstate in HOURLYLIST) then TempInputRecord.Load.Loadings.Hourly := HourlyCB.Checked;

  CopyDetritalInputRec(TempInputRecord,TDissRefrDetr(PS).InputRecord);
  PS.LoadNotes1 := TempNotes1;
  PS.LoadNotes2 := TempNotes2;

  PS.AllStates.CopySuspDetrData;
End;

{-----------------------------------------------------------------------------------}

Procedure TEditDetritus.UpdateScreen;
Begin
  TCL_Unit2.Caption := 'ug/kg dry';

  HourlyCB.Visible := PS.Nstate in HOURLYLIST;

{  If Screen.Height>620
    then
      Begin
        OKBtn.Top := 532;
        CancelBtn.Top := 532;
        Mode1.Top := 532;
        Mode2.Top := 532;
        Mode3.Top := 532;
        Mode5.Visible := True;
        Mode4.Top := 519;
        Mode5.Top := 545;
      End
    else
      Begin
        OKBtn.Top := 510;
        CancelBtn.Top := 510;
        Mode1.Top := 510;
        Mode2.Top := 510;
        Mode3.Top := 510;
        Mode5.Visible := True;
        Mode4.Top := 496;
        Mode5.Top := 522;
      End;   }

  OKBtn.Top := 513;
  CancelBtn.Top := 513;

  ToxicPanel.Visible := DisplayMode = 1;
  NPSPanel.Visible := DisplayMode > 1;
  LoadingsPanel.Visible:=False;
  Mode1.Enabled := CurrentToxT <> STV;

  With TempInputRecord do
    Begin
      {Display the Init Conditions and Const. Load Data}
      ICEDIT.Text:=FloatToStrF(InitCond,ffGeneral,7,4);
      LoadEdit.Text:=FloatToStrF(Load.ConstLoad,ffGeneral,7,4);
      ConstRadButt.Checked := Load.UseConstant;
      DynRadButt.Checked   := Not Load.UseConstant;
      MultEdit.Text  :=FloatToStrF(Load.MultLdg,ffGeneral,7,4);

      If (DisplayMode<4)
        then
          Begin  {Fix captions / screen setup for PS/NPS}
            ICPanel.Visible := False;
            Label34.Visible:=True;
            NPSMultEdit.Visible:=True;
            NPSUnit.Caption := 'g/d';
            NPSUnit2.Caption := 'g/d';
            NPSCLRadio.Caption := 'Use Constant Loading of';
            NPSDLRadio.Caption := 'Use Dynamic Loading of';
            AWOMLabel.Visible := True;
          End
        else
          Begin  {Fix captions / screen setup for Percent Breakdown}
             ICPanel.Visible := True;
             Label34.Visible:=False;
             NPSMultEdit.Visible:=False;
             NPSUnit.Caption := 'percent';
             NPSUnit2.Caption := 'percent';
             NPSCLRadio.Caption := 'Use Constant Percentage of';
             NPSDLRadio.Caption := 'Use Timeseries of Percentages';
             AWOMLabel.Visible := False;
          End;


      {Display Init Conditions and Const Load data for the Right Panel}
      Case DisplayMode of
        1: Begin  {Tox Loading}
             TICEDIT.Text:=FloatToStrF(ToxInitCond[CurrentToxT],ffGeneral,8,4);
             Case CurrentTLoad of
               0: Begin
                     ATLoadEdit.Text:=FloatToStrF(ToxLoad[CurrentToxT].ConstLoad,ffGeneral,8,4);
                     TConstRadButt.Checked:=ToxLoad[CurrentToxT].UseConstant;
                     TDynRadButt.Checked:=Not ToxLoad[CurrentToxT].UseConstant;
                     TMultEdit.Text :=FloatToStrF(ToxLoad[CurrentToxT].MultLdg,ffGeneral,8,4);
                  End;
               1: Begin
                     ATLoadEdit.Text:=FloatToStrF(ToxLoad[CurrentToxT].Alt_ConstLoad[PointSource],ffGeneral,8,4);
                     TConstRadButt.Checked:=ToxLoad[CurrentToxT].Alt_UseConstant[PointSource];
                     TDynRadButt.Checked:=Not ToxLoad[CurrentToxT].Alt_UseConstant[PointSource];
                     TMultEdit.Text :=FloatToStrF(ToxLoad[CurrentToxT].Alt_MultLdg[PointSource],ffGeneral,8,4);
                  End;
               2: Begin
                     ATLoadEdit.Text:=FloatToStrF(ToxLoad[CurrentToxT].Alt_ConstLoad[NonPointSource],ffGeneral,8,4);
                     TConstRadButt.Checked:=ToxLoad[CurrentToxT].Alt_UseConstant[NonPointSource];
                     TDynRadButt.Checked:=Not ToxLoad[CurrentToxT].Alt_UseConstant[NonPointSource];
                     TMultEdit.Text :=FloatToStrF(ToxLoad[CurrentToxT].Alt_MultLdg[NonPointSource],ffGeneral,8,4);
                  End;
               End; {Case}
           End;
        2: Begin  {Point Source}
             NPSLabel.Caption := 'Point Source Loadings';
             NPSConstLoad.Text  := FloatToStrF(Load.Alt_ConstLoad[PointSource],ffGeneral,8,4);
             NPSCLRadio.Checked := Load.Alt_UseConstant[PointSource];
             NPSDLRadio.Checked := Not(Load.Alt_UseConstant[PointSource]);
             NPSMultEdit.Text:=FloatToStrF(Load.Alt_MultLdg[PointSource],ffGeneral,8,4);
           End;
        3: Begin  {Non Point Source}
             NPSLabel.Caption := 'Non-Point Source Loadings';
             NPSConstLoad.Text  := FloatToStrF(Load.Alt_ConstLoad[NonPointSource],ffGeneral,8,4);
             NPSCLRadio.Checked := Load.Alt_UseConstant[NonPointSource];
             NPSDLRadio.Checked := Not(Load.Alt_UseConstant[NonPointSource]);
             NPSMultEdit.Text:=FloatToStrF(Load.Alt_MultLdg[NonPointSource],ffGeneral,8,4);
           End;
        4: Begin  {% Particulate}
             NPSLabel.Caption := 'Percent that is Particulate';
             ICNPSEdit.Text := FloatToStrF(Percent_PartIC,ffGeneral,8,4);

             Case CurrentLoad of
               0: Begin
                     NPSConstLoad.Text  := FloatToStrF(Percent_Part.ConstLoad,ffGeneral,8,4);
                     NPSCLRadio.Checked := Percent_Part.UseConstant;
                     NPSDLRadio.Checked := Not(Percent_Part.UseConstant);
                  End;
               1: Begin
                     NPSConstLoad.Text  := FloatToStrF(Percent_Part.Alt_ConstLoad[PointSource],ffGeneral,8,4);
                     NPSCLRadio.Checked := Percent_Part.Alt_UseConstant[PointSource];
                     NPSDLRadio.Checked := Not(Percent_Part.Alt_UseConstant[PointSource]);
                  End;
               2: Begin
                     NPSConstLoad.Text  := FloatToStrF(Percent_Part.Alt_ConstLoad[NonPointSource],ffGeneral,8,4);
                     NPSCLRadio.Checked := Percent_Part.Alt_UseConstant[NonPointSource];
                     NPSDLRadio.Checked := Not(Percent_Part.Alt_UseConstant[NonPointSource]);
                  End;
             End; {Case}
           End;
        5: Begin  {% Refractory}
             NPSLabel.Caption := 'Percent that is Refractory';
             ICNPSEdit.Text := FloatToStrF(Percent_RefrIC,ffGeneral,8,4);

             Case CurrentLoad of
               0: Begin
                     NPSConstLoad.Text  := FloatToStrF(Percent_Refr.ConstLoad,ffGeneral,8,4);
                     NPSCLRadio.Checked := Percent_Refr.UseConstant;
                     NPSDLRadio.Checked := Not(Percent_Refr.UseConstant);
                  End;
               1: Begin
                     NPSConstLoad.Text  := FloatToStrF(Percent_Refr.Alt_ConstLoad[PointSource],ffGeneral,8,4);
                     NPSCLRadio.Checked := Percent_Refr.Alt_UseConstant[PointSource];
                     NPSDLRadio.Checked := Not(Percent_Refr.Alt_UseConstant[PointSource]);
                  End;
               2: Begin
                     NPSConstLoad.Text  := FloatToStrF(Percent_Refr.Alt_ConstLoad[NonPointSource],ffGeneral,8,4);
                     NPSCLRadio.Checked := Percent_Refr.Alt_UseConstant[NonPointSource];
                     NPSDLRadio.Checked := Not(Percent_Refr.Alt_UseConstant[NonPointSource]);
                  End;
             End; {Case}
           End;
      End; {Case}

      {Display Notes}
      NotesEdit.Text  := TempNotes1;
      NotesEdit2.Text := TempNotes2;

      OrgMattButt.Checked :=DataType=Org_Matt;
      OrgCarbButt.Checked :=DataType=Org_Carb;
      BODButt.Checked     :=DataType=CBOD;

    End; {With TempInputRecord}
   Update;
   EnableDisable(nil);
   EnableDisable6(nil);
End;

{-----------------------------------------------------------------------------------}

Procedure TEditDetritus.ChangeDisplayMode;
Var i: Integer;
    TableIn: TTable;
    WorkLoadings: TLoadings;

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
  WorkLoadings := Nil;
  If DisplayMode=1 then exit; {unnec. for tox screen}
  NPSConvertButt.Visible := (DisplayMode in [2,3]);

  TableIn := Table5;
  Table5.DatabaseName:=Program_Dir;
  Table5.Active:=False;
  Table5.EmptyTable;
  Table5.Active:=True;

  With TempInputRecord do
    Case DisplayMode of
      2: WorkLoadings := Load.Alt_Loadings[PointSource];
      3: WorkLoadings := Load.Alt_Loadings[NonPointSource];
      4: Case CurrentLoad of
           0: WorkLoadings := Percent_Part.Loadings;
           1: WorkLoadings := Percent_Part.Alt_Loadings[PointSource];
           2: WorkLoadings := Percent_Part.Alt_Loadings[NonPointSource];
         End; {Case}
      5: Case CurrentLoad of
           0: WorkLoadings := Percent_Refr.Loadings;
           1: WorkLoadings := Percent_Refr.Alt_Loadings[PointSource];
           2: WorkLoadings := Percent_Refr.Alt_Loadings[NonPointSource];
         End; {Case}
      End; {Case}

   TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
    With WorkLoadings do
      For i:=0 to count-1 do
        PutInDbase(at(i));

End;

{-----------------------------------------------------------------------------------}

Procedure TEditDetritus.EditDetr(IncomingS: TStateVariable);
Begin
  PS := IncomingS;
  TotN_IC.Visible := False;
  TotN_Inflow.Visible := False;
  TotN_PS.Visible := False;
  TotN_NPS.Visible := False;

  CopyToTemp;
  If CurrentToxT <> STV then DisplayMode := 1
                        else DisplayMode := 2;
  ChangeDisplayMode;
  UpdateScreen;
  If ShowModal<>MrCancel then CopyFromTemp;

  DisposeDetritalInputRec(TempInputRecord);
  Table1.Active:=False; Table2.Active:=False;
  Table5.Active:=False;
End;

procedure TEditDetritus.SaveCurrentModeDB;
Begin
  Case DisplayMode of
    2: LoadingsFromTable(Table5,TempInputRecord.Load.Alt_Loadings[PointSource]);     {Point Source}
    3: LoadingsFromTable(Table5,TempInputRecord.Load.Alt_Loadings[NonPointSource]);  {Non Point Source}
    4: Case CurrentLoad of
         0: LoadingsFromTable(Table5,TempInputRecord.Percent_Part.Loadings);                    {Percent Part, inflow}
         1: LoadingsFromTable(Table5,TempInputRecord.Percent_Part.Alt_Loadings[PointSource]);   {Percent Part, PS}
         2: LoadingsFromTable(Table5,TempInputRecord.Percent_Part.Alt_Loadings[NonPointSource]);{Percent Part, NPS}
       End;
    5: Case CurrentLoad of
         0: LoadingsFromTable(Table5,TempInputRecord.Percent_Refr.Loadings);                    {Percent Refr, inflow}
         1: LoadingsFromTable(Table5,TempInputRecord.Percent_Refr.Alt_Loadings[PointSource]);   {Percent Refr, PS}
         2: LoadingsFromTable(Table5,TempInputRecord.Percent_Refr.Alt_Loadings[NonPointSource]);{Percent Refr, NPS}
       End;
    End; {Case}
End;

procedure TEditDetritus.ModeButtonsClick(Sender: TObject);
begin
  SaveCurrentModeDB;

  Case TButton(Sender).Name[5] of
    '1': DisplayMode := 1;
    '2': DisplayMode := 2;
    '3': DisplayMode := 3;
    '4': DisplayMode := 4;
    '5': DisplayMode := 5;
    End; {Case}

  ChangeDisplayMode;
  UpdateScreen;
end;

procedure TEditDetritus.Verify_Detr_Num(Sender: TObject);
Var
  Conv: Double;
  Result: Integer;

Begin
    Val(Trim(TEdit(Sender).Text),Conv,Result);
    Conv:=Abs(Conv);
    If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else begin
                         case TEdit(Sender).Name[1] of
                            'I': TempInputRecord.InitCond       :=Conv;
                            'L': TempInputRecord.Load.ConstLoad :=Conv;
                            'M': TempInputRecord.Load.MultLdg   :=Conv;
                         end; {case}
                         Changed:=true;
                      end; {else}
    UpdateScreen;
End; {VerifyDetr}


procedure TEditDetritus.Verify_Detr_Num2(Sender: TObject);
Var
  Conv: Double;
  Result: Integer;

Begin
  Val(Trim(TEdit(Sender).Text),Conv,Result);
  Conv:=Abs(Conv);
  If Result<>0
    then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
    else With TempInputRecord do
      Begin
        If TEdit(Sender).Name = 'ICNPSEdit' then
          Case DisplayMode of
            4 : Percent_PartIC := Conv;
            5 : Percent_RefrIC := Conv;
          End; {Case and If}

        If TEdit(Sender).Name = 'NPSConstLoad' then
          Case DisplayMode of
            2 :  Load.Alt_ConstLoad[PointSource] := Conv;
            3 :  Load.Alt_ConstLoad[NonPointSource] := Conv;
            4 :  Case CurrentLoad of
                   0: Percent_Part.ConstLoad := Conv;
                   1: Percent_Part.Alt_ConstLoad[PointSource] := Conv;
                   2: Percent_Part.Alt_ConstLoad[NonPointSource] := Conv;
                 End; {Case}
            5 :  Case CurrentLoad of
                   0: Percent_Refr.ConstLoad := Conv;
                   1: Percent_Refr.Alt_ConstLoad[PointSource] := Conv;
                   2: Percent_Refr.Alt_ConstLoad[NonPointSource] := Conv;
                 End; {Case}
          End; {Case and If}

        If TEdit(Sender).Name = 'NPSMultEdit' then
          Case DisplayMode of
            2 : Load.Alt_MultLdg[PointSource] := Conv;
            3 : Load.Alt_MultLdg[NonPointSource] := Conv;
          End; {Case and If}
      End; {else}
  UpdateScreen;
End; {VerifyDetr2}

procedure TEditDetritus.Verify_Detr_Tox(Sender: TObject);
Var Conv: Double;
    Result: Integer;

Begin
    Val(Trim(TEdit(Sender).Text),Conv,Result);
    Conv:=Abs(Conv);
    If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else begin with TempInputRecord do
                         case TEdit(Sender).Name[2] of
                            'I': ToxInitCond[CurrentToxT]       :=Conv;  {Tox InitialCond}
                            'T': Case CurrentTLoad of
                                   0: ToxLoad[CurrentToxT].ConstLoad :=Conv;  {Tox ConstLoad}
                                   1: ToxLoad[CurrentToxT].Alt_ConstLoad[PointSource] :=Conv;  {Tox ConstLoad}
                                   2: ToxLoad[CurrentToxT].Alt_ConstLoad[NonPointSource] :=Conv;  {Tox ConstLoad}
                                 End;
                            'M': Case CurrentTLoad of
                                   0: ToxLoad[CurrentToxT].MultLdg :=Conv;  {Tox MultLdg}
                                   1: ToxLoad[CurrentToxT].Alt_MultLdg[PointSource] :=Conv;  {Tox MultLdg}
                                   2: ToxLoad[CurrentToxT].Alt_MultLdg[NonPointSource] :=Conv;  {Tox MultLdg}
                                 End;
                         end; {case}
                      end; {else}
    UpdateScreen;
End; {VerifyDetr}



procedure TEditDetritus.OrgMattButtClick(Sender: TObject);
begin
  If OrgMattButt.Checked
    then TempInputRecord.DataType:=Org_Matt
    else If OrgCarbButt.Checked
      then TempInputRecord.DataType := Org_Carb
        else TempInputRecord.DataType := CBOD;
  UpdateScreen;
end;

procedure TEditDetritus.EnableDisable(Sender: TObject);
begin
  inherited;
  TempInputRecord.Load.UseConstant := ConstRadButt.Checked
end;

procedure TEditDetritus.EnableDisable6(Sender: TObject);
begin
  inherited;
  Case DisplayMode of
    2: TempInputRecord.Load.Alt_UseConstant[PointSource] := NPSCLRadio.Checked;     {Point Source}
    3: TempInputRecord.Load.Alt_UseConstant[NonPointSource] := NPSCLRadio.Checked;  {Non Point Source}
    4: Case CurrentLoad of
         0: TempInputRecord.Percent_Part.UseConstant := NPSCLRadio.Checked;                       {Percent Part inflow}
         1: TempInputRecord.Percent_Part.Alt_UseConstant[PointSource] := NPSCLRadio.Checked;      {Percent Part PS}
         2: TempInputRecord.Percent_Part.Alt_UseConstant[NonPointSource] := NPSCLRadio.Checked;   {Percent Part NPS}
       End;
    5: Case CurrentLoad of
         0: TempInputRecord.Percent_Refr.UseConstant := NPSCLRadio.Checked;                       {Percent Refr inflow}
         1: TempInputRecord.Percent_Refr.Alt_UseConstant[PointSource] := NPSCLRadio.Checked;      {Percent Refr PS}
         2: TempInputRecord.Percent_Refr.Alt_UseConstant[NonPointSource] := NPSCLRadio.Checked;   {Percent Refr NPS}
       End;
    End; {Case}
end;

procedure TEditDetritus.EnableDisable2(Sender: TObject);
begin
  inherited;
  Case CurrentTLoad of
       0: TempInputRecord.ToxLoad[CurrentToxT].UseConstant := TConstRadButt.Checked;
       1: TempInputRecord.ToxLoad[CurrentToxT].Alt_UseConstant[PointSource] := TConstRadButt.Checked;
       2: TempInputRecord.ToxLoad[CurrentToxT].Alt_UseConstant[NonPointSource] := TConstRadButt.Checked;
    End; {Case}
end;


procedure TEditDetritus.ToxComboBoxChange2(Sender: TObject);
Var TableIn: TTable;
    InColl : TCollection;
    i      : Integer;

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
  Case CurrentTLoad of
    0: LoadingsFromTable(Table2,TempInputRecord.ToxLoad[CurrentToxT].Loadings);
    1: LoadingsFromTable(Table2,TempInputRecord.ToxLoad[CurrentToxT].Alt_Loadings[pointsource]);
    2: LoadingsFromTable(Table2,TempInputRecord.ToxLoad[CurrentToxT].Alt_Loadings[nonpointsource]);
  End; {Case}

  CurrentTLoad := LoadingBox2.ItemIndex;
  CurrentToxT :=SelToxT[ToxCombobox.ItemIndex];
  InColl := nil;

  Case CurrentTLoad of
    0: InColl := TempInputRecord.ToxLoad[CurrentToxT].Loadings;
    1: InColl := TempInputRecord.ToxLoad[CurrentToxT].Alt_Loadings[pointsource];
    2: InColl := TempInputRecord.ToxLoad[CurrentToxT].Alt_Loadings[nonpointsource];
  End; {Case}

  Table2.Active:=False;
  Table2.EmptyTable;
  Table2.Active:=True;

  {Load the Database Data into the Files}
  TableIn:=Table2;
  TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
  If CurrentToxT <> STV then
     With InColl do
       For i:=0 to count-1 do
          PutInDbase(at(i));

  UpdateScreen;
End;


procedure TEditDetritus.NotesEditExit(Sender: TObject);
begin
  TempNotes1:=NotesEdit.Text;
  TempNotes2:=NotesEdit2.Text;
end;

procedure TEditDetritus.LoadingBoxChange(Sender: TObject);
begin
  SaveCurrentModeDB;
  CurrentLoad := LoadingBox.ItemIndex;
  ChangeDisplayMode;
  UpdateScreen;
end;


procedure TEditDetritus.ImportButt1Click(Sender: TObject);
{Main Panel}
Var LoadTable: TTable;
    Nm       : String;
    Hrly     : Boolean;
Begin
  LoadTable:=Table1;

  Hrly := (HourlyCB.Visible) and (HourlyCB.Checked);
  Nm := 'Inflow Loadings, Susp. and Diss. Detritus (mg/L)';

  LoadTable.Active:=False;
  ImportForm.ChangeLoading(Nm,LoadTable,False,Hrly, CTNone);
  LoadTable.Active:=True;

  Update;
end;

procedure TEditDetritus.ImportButt6Click(Sender: TObject);
{NPS Panel}
Var LoadTable: TTable;
    Nm       : String;
begin
  LoadTable:=Table5;

  Nm := 'Error';
  Case DisplayMode of
    2: Nm := 'Susp. and Diss. Detritus Load: Point Source (g/d)';
    3: Nm := 'Susp. and Diss. Detritus Load: Non-Point Source (g/d)';
    4: Nm := 'Percent of '+LoadingBox.Text+' that is Particulate (percent)';
    5: Nm := 'Percent of '+LoadingBox.Text+' that is Refractory (percent)';
  End; {Case}

  LoadTable.Active:=False;
  If DisplayMode < 4 then ImportForm.ChangeLoading(Nm,LoadTable,False,False,CTPollutant)
                     else ImportForm.ChangeLoading(Nm,LoadTable,False,False,CTNone);
  LoadTable.Active:=True;

  Update;
end;

procedure TEditDetritus.ImportButt3Click(Sender: TObject);
{Toxic Panel}
Var LoadTable: TTable;
    Nm       : String;
begin
  LoadTable:=Table2;
  Nm := 'Susp. and Diss. Detritus: ' + ToxComboBox.Text + ' assoc. with ' +
        LoadingBox2.Text+' (ug/kg)';

  LoadTable.Active:=False;
  ImportForm.ChangeLoading(Nm,LoadTable,False,False, CTNone);
  LoadTable.Active:=True;

  Update;
end;

procedure TEditDetritus.FormShow(Sender: TObject);
begin
  inherited;
  If Screen.Height<620 then Top := 1;

end;

procedure TEditDetritus.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic18.htm');
end;

end.


