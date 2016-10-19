//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_9;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls, Global, WizGlobal, Aquaobj, Grids,
  DBGrids, Db, DBTables, DBCtrls, Loadings, hh;

type
  TWizBase9 = class(TWizBase)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ManningLabel: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    VaryButt: TRadioButton;
    ConstButt: TRadioButton;
    KnownButt: TRadioButton;
    ManningButt: TRadioButton;
    ConstPanel: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    AGrid: TDBGrid;
    NPSUnit2: TLabel;
    AUseDynam: TRadioButton;
    NPSUnit: TLabel;
    EConstInflow1: TEdit;
    AUseConst: TRadioButton;
    Label7: TLabel;
    Label8: TLabel;
    AICEdit: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Button1: TButton;
    ANav: TDBNavigator;
    AImport: TButton;
    Table1: TTable;
    Table2: TTable;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DynamPanel: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Panel4: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    BGrid: TDBGrid;
    BUseDynam: TRadioButton;
    FConstInflow2: TEdit;
    BUseConst: TRadioButton;
    Button2: TButton;
    BNav: TDBNavigator;
    BImport: TButton;
    BICEdit: TEdit;
    Panel3: TPanel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    CGrid: TDBGrid;
    CUseDynam: TRadioButton;
    GConstOutflow1: TEdit;
    CUseConst: TRadioButton;
    Button4: TButton;
    CNav: TDBNavigator;
    CImport: TButton;
    KnownPanel: TPanel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Panel6: TPanel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    DGrid: TDBGrid;
    DUseDynam: TRadioButton;
    JConstKnownVal: TEdit;
    DUseConst: TRadioButton;
    Button6: TButton;
    DNav: TDBNavigator;
    DImport: TButton;
    CICEdit: TEdit;
    Panel7: TPanel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    EGrid: TDBGrid;
    EUseDynam: TRadioButton;
    HConstInflow2: TEdit;
    EUseConst: TRadioButton;
    Button8: TButton;
    ENav: TDBNavigator;
    EImport: TButton;
    ManningPanel: TPanel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Panel8: TPanel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    FGrid: TDBGrid;
    FUseDynam: TRadioButton;
    IConstOutFlow3: TEdit;
    FUseConst: TRadioButton;
    Button10: TButton;
    FNav: TDBNavigator;
    FImport: TButton;
    DICEdit: TEdit;
    ConvertICO3: TButton;
    ConvertDICE: TButton;
    ConvertCICE: TButton;
    ConvertJCKV: TButton;
    ConvertHCI2: TButton;
    ConvertFCI2: TButton;
    ConvertGCO1: TButton;
    ConvertBICE: TButton;
    ConvertAICE: TButton;
    ConvertECI1: TButton;
    procedure ButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure AboutDynamicDataClick(Sender: TObject);
    procedure InflowImportClick(Sender: TObject);
    procedure OutflowImportClick(Sender: TObject);
    procedure knownimportclick(Sender: TObject);
    procedure ConvNumb(Sender: TObject);
    procedure EnableDisable(Sender: TObject);
    procedure EImportClick(Sender: TObject);
    procedure ConvertClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure UpdateScreen;
    Function  DataFinished: Boolean;
    Function  ExecuteScreen: WizOutput; Override;
    Procedure GetDatabaseData;
    Procedure PutDatabaseData;
  end;

Const  NumFields = 3;  {Number of fields verified entered}
var
  WizBase9: TWizBase9;


implementation

uses Imp_Load, Convert, Wait;

{$R *.DFM}


        {----------------------------------------------------------}
        Procedure LoadingsFromTable(Table: TTable; Var LColl: TLoadings);
        {Copies loadings data from the table to the Collection}
        Var loop,recnum: Integer;
            NewLoad:     TLoad;
            StartTime:   TDateTime;
            WaitShown:   Boolean;
        Begin
            StartTime:=Now();
            WaitShown := False;
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
                           If WaitShown then WaitDlg.Tease;
                           If Not WaitShown and (Now-StartTime > 1.16e-5) then
                             Begin
                               WaitDlg.Setup('Please Wait One Moment, Saving Data');
                               WaitShown := True;
                             End;
                      end; {for do}
              If WaitShown then WaitDlg.Hide;
              Active := False;
            end; {with}

        End; {LoadingsFromTable}
        {----------------------------------------------------------}


Procedure TWizBase9.UpdateScreen;
Var IsStream: Boolean;
    PV: TVolume;
    Val: Double;
    CalcTyp: VolumeMethType;

Begin
  PV := WizStudy.SV.GetStatePointer(Volume,StV,WaterCol);
  CalcTyp := PV.Calc_Method;

  If W9_Screen=0 then
    Begin
      NextButton.Enabled := (W9_VolMethChosen) or (WizStatus>0);

      MainPanel.Visible := True;
      IsStream := WizStudy.Location.Sitetype=Stream;
      ManningLabel.Visible := IsStream;
      ManningButt.Visible := IsStream;
      If (Not IsStream) and (CalcTyp = Manning) then PV.Calc_Method := KeepConst;

      If (W9_VolMethChosen) or (WizStatus>0) then
        Begin
          ConstButt.Checked   := PV.Calc_Method = KeepConst;
          VaryButt.Checked    := PV.Calc_Method = Dynam;
          KnownButt.Checked   := PV.Calc_Method = KnownVal;
          ManningButt.Checked := PV.Calc_Method = Manning;
        End;
    End;

  If W9_Screen=1 then
    Begin
      Case CalcTyp of
        KeepConst:
          Begin
            Val := PV.InitialCond;
            If (WizStatus<>0) or W9_FieldEdited
              then AICEdit.Text := FloatToStrF(Val,ffExponent,4,4)
              else AICEdit.Text := '';

            Val := PV.LoadsRec.Alt_ConstLoad[InflowLoadT];
            EConstInflow1.Text :=  FloatToStrF(Val,ffExponent,4,4);

            AUseConst.Checked := PV.LoadsRec.Alt_UseConstant[InflowLoadT];
            AUseDynam.Checked := not PV.LoadsRec.Alt_UseConstant[InflowLoadT];
          End; {KeepConst}

        Dynam:
          Begin
            Val := PV.InitialCond;
            If (WizStatus<>0) or W9_FieldEdited
              then BICEdit.Text := FloatToStrF(Val,ffExponent,4,4)
              else BICEdit.Text := '';

            Val := PV.LoadsRec.Alt_ConstLoad[InflowLoadT];
            FConstInflow2.Text :=  FloatToStrF(Val,ffExponent,4,4);

            Val := PV.LoadsRec.Alt_ConstLoad[DischargeLoadT];
            GConstOutflow1.Text :=  FloatToStrF(Val,ffExponent,4,4);

            BUseConst.Checked := PV.LoadsRec.Alt_UseConstant[InflowLoadT];
            BUseDynam.Checked := not PV.LoadsRec.Alt_UseConstant[InflowLoadT];
            CUseConst.Checked := PV.LoadsRec.Alt_UseConstant[DischargeLoadT];
            CUseDynam.Checked := not PV.LoadsRec.Alt_UseConstant[DischargeLoadT];
          End; {Dynam}

        KnownVal:
          Begin
            Val := PV.InitialCond;
            If (WizStatus<>0) or W9_FieldEdited
              then CICEdit.Text := FloatToStrF(Val,ffExponent,4,4)
              else CICEdit.Text := '';

            Val := PV.LoadsRec.Alt_ConstLoad[InflowLoadT];
            HConstInflow2.Text :=  FloatToStrF(Val,ffExponent,4,4);

            Val := PV.LoadsRec.ConstLoad;
            JConstKnownVal.Text :=  FloatToStrF(Val,ffExponent,4,4);

            DUseConst.Checked := PV.LoadsRec.UseConstant;
            DUseDynam.Checked := not PV.LoadsRec.UseConstant;
            EUseConst.Checked := PV.LoadsRec.Alt_UseConstant[InflowLoadT];
            EUseDynam.Checked := not PV.LoadsRec.Alt_UseConstant[InflowLoadT];
          End; {KnownVal}
        Else
          Begin
            Val := PV.InitialCond;
            If (WizStatus<>0) or W9_FieldEdited
              then DICEdit.Text := FloatToStrF(Val,ffExponent,4,4)
              else DICEdit.Text := '';

            Val := PV.LoadsRec.Alt_ConstLoad[DirectPrecip];
            IConstOutflow3.Text :=  FloatToStrF(Val,ffExponent,4,4);

            FUseConst.Checked := PV.LoadsRec.Alt_UseConstant[DischargeLoadT];
            FUseDynam.Checked := not PV.LoadsRec.Alt_UseConstant[DischargeLoadT];
          End;  {Manning}
      End; {Case}

      MainPanel.Visible := False;
      ConstPanel.Visible   := (CalcTyp = KeepConst);
      KnownPanel.Visible   := (CalcTyp = KnownVal);
      DynamPanel.Visible   := (CalcTyp = Dynam);
      ManningPanel.Visible := (CalcTyp = Manning);
    End; {If W9_Screen=1}
End;

procedure TWizBase9.PutDatabaseData;
Var TableIn: TTable;
    i: Integer;
    PV: TVolume;
    CalcTyp: VolumeMethType;
    StartTime:   TDateTime;
    WaitShown:   Boolean;


         Procedure PutInDbase(P: TLoad);
         {Used to put loadings data into TableIn}
        Begin


           With TableIn do
               begin
                 Append;
                 Fields[0].AsDateTime:= P.Date;
                 Fields[1].AsFloat:=P.Loading;
                 If (P.Loading>1000) or (P.Loading<0.0001) then
                   Begin
                     TFloatField(Fields[1]).DisplayFormat:='0.0000e-00';
                     TFloatField(Fields[1]).DisplayWidth := 10;
                   End;
                 Post;
               end;

           If WaitShown then WaitDlg.Tease;
           If Not WaitShown and (Now-StartTime > 1.16e-5) then
             Begin
               WaitDlg.Setup('Please Wait One Moment, Loading Data');
               WaitShown := True;
             End;

         end;

Begin
  PV := WizStudy.SV.GetStatePointer(Volume,StV,WaterCol);
  CalcTyp := PV.Calc_Method;


  StartTime:=Now();
  WizBusy := True;
  Try

      WaitShown := False;
      Table1.DatabaseName:=Program_Dir; Table2.DatabaseName:=Program_Dir;
      Table1.Active:=False;             Table2.Active:=False;
      Table1.EmptyTable;                Table2.EmptyTable;
      If CalcTyp <> Manning   then Table1.Active := True;
      If CalcTyp <> KeepConst then Table2.Active := True;

      TableIn := Table1;
      If CalcTyp in [KeepConst,Dynam]
        then With PV.LoadsRec.Alt_Loadings[InflowLoadT] do
          For i:=0 to count-1 do
            PutInDbase(at(i));

      TableIn := Table2;
      If CalcTyp in [Manning, Dynam]
        then With PV.LoadsRec.Alt_Loadings[DischargeLoadT] do
          For i:=0 to count-1 do
            PutInDbase(at(i));
      If CalcTyp = KnownVal
         then With PV.LoadsRec.Alt_Loadings[InflowLoadT] do
          For i:=0 to count-1 do
            PutInDbase(at(i));

      TableIn := Table1;
      If CalcTyp = KnownVal
        then With PV.LoadsRec.Loadings do
          For i:=0 to count-1 do
            PutInDbase(at(i));

  Except
    WizBusy := False;
    If WaitShown then WaitDlg.Hide;
    Raise;
  End;

  WizBusy := False;
  If WaitShown then WaitDlg.Hide;
End;

procedure TWizBase9.GetDatabaseData;
Var PV: TVolume;
    CalcTyp: VolumeMethType;

begin
  PV := WizStudy.SV.GetStatePointer(Volume,StV,WaterCol);
  CalcTyp := PV.Calc_Method;

  Try
    WizBusy := True;

  If CalcTyp in [KeepConst,Dynam]
    then LoadingsFromTable(Table1,PV.LoadsRec.Alt_Loadings[InflowLoadT]);
  If CalcTyp in [Manning,Dynam]
    then LoadingsFromTable(Table2,PV.LoadsRec.Alt_Loadings[DischargeLoadT]);
  If CalcTyp = KnownVal
    then Begin
           LoadingsFromTable(Table1,PV.LoadsRec.Loadings);
           LoadingsFromTable(Table2,PV.LoadsRec.Alt_Loadings[InflowLoadT]);
         End;

  Except
    WizBusy := False;
    Raise;
  End;

  WizBusy := False;

End;

Function TWizBase9.ExecuteScreen: WizOutput;
Begin
  If FirstVisit then
    Begin
      W9_VolMethChosen := False;
      W9_FieldEdited := False;
    End;

  If JumpIn = WzBack then Begin
                            If Not W9_VolMethChosen then W9_Screen:=0
                                                    else W9_Screen := 1;
                            PutDatabaseData;
                          End
                     else W9_Screen := 0;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (DataFinished) then WizStatus := 2;
  If (WizStatus=1) and (W9_FieldEdited)  then WizStatus := 2;
End;


procedure TWizBase9.ButtonClick(Sender: TObject);
Var PV: TVolume;
begin
  PV := WizStudy.SV.GetStatePointer(Volume,StV,WaterCol);

  If ConstButt.Checked   then PV.Calc_Method := KeepConst;
  If VaryButt.Checked    then PV.Calc_Method := Dynam;
  If KnownButt.Checked   then PV.Calc_Method := KnownVal;
  If ManningButt.Checked then PV.Calc_Method := Manning;

  W9_VolMethChosen := ((ConstButt.Checked) or
                    (VaryButt.Checked) or
                    (KnownButt.Checked) or
                    (ManningButt.Checked));
  UpdateScreen;
end;

Function TWizBase9.DataFinished: Boolean;
Begin
  DataFinished := W9_FieldEdited;

End;


procedure TWizBase9.NextButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;
  If (W9_Screen=1)
    then
      Begin
        GetDatabaseData;
        inherited
      End
    else
      Begin
        Inc(W9_Screen);
        PutDatabaseData;
        UpdateScreen;
      End;
end;

procedure TWizBase9.BackButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;
  If W9_Screen>0
    then
      Begin
        GetDatabaseData;
        Dec(W9_Screen);
        UpdateScreen;
      End
    else inherited;
end;

procedure TWizBase9.AboutDynamicDataClick(Sender: TObject);
begin
  HTMLHelpContext('Important_Note_about_Dynamic_Loadings.htm');
end;

procedure TWizBase9.InflowImportClick(Sender: TObject);
Begin
  Table1.Active:=False;
  ImportForm.ChangeLoading('Water Inflow (cu.m/d)',Table1,True,False,CTFlow);
  Table1.Active:=True;
  Update;
End;

procedure TWizBase9.EImportClick(Sender: TObject);
begin
  Table2.Active:=False;
  ImportForm.ChangeLoading('Water Inflow (cu.m/d)',Table2,True,False,CTFlow);
  Table2.Active:=True;
  Update;

end;


procedure TWizBase9.OutflowImportClick(Sender: TObject);
begin
  Table2.Active:=False;
  ImportForm.ChangeLoading('Water Discharge (cu.m/d)',Table2,True,False,CTFlow);
  Table2.Active:=True;
  Update;
end;

procedure TWizBase9.KnownImportClick(Sender: TObject);
begin
  Table1.Active:=False;
  ImportForm.ChangeLoading('Known Water Volume (cu.m)',Table1,True,False,CTVolume);
  Table1.Active:=True;
  Update;
end;

procedure TWizBase9.ConvertClick(Sender: TObject);
Var TE: TEdit;
begin
  Application.CreateForm(TConvertForm,ConvertForm);
  TE := nil;

  If Sender = ConvertECI1 then TE := EConstInflow1;
  If Sender = ConvertFCI2 then TE := FConstInflow2;
  If Sender = ConvertGCO1 then TE := GConstOutflow1;
  If Sender = ConvertHCI2 then TE := HConstInflow2;
  If Sender = ConvertICO3 then TE := IConstOutflow3;

  If TE<> nil then Begin
                     ConvertForm.ConvertNumber(TE,CTFlow);
                     TE := nil;
                   End;

  If Sender = ConvertAICE then TE := AICEdit;
  If Sender = ConvertBICE then TE := BICEdit;
  If Sender = ConvertCICE then TE := CICEdit;
  If Sender = ConvertDICE then TE := DICEdit;
  If Sender = ConvertJCKV then TE := JConstKnownVal;

  If TE<> nil then ConvertForm.ConvertNumber(TE,CTVolume);

  ConvertForm.Free;

end;

procedure TWizBase9.ConvNumb(Sender: TObject);
Var Conv  : Double;
    Result: Integer;
    Txt: String;
Var PV: TVolume;
begin
  PV := WizStudy.SV.GetStatePointer(Volume,StV,WaterCol);
  Txt :=Tedit(Sender).Text;
  If Trim(Txt)='' then exit;

  Val(Txt,Conv,Result);
  Conv:=Abs(Conv);
  If (Result<>0)
       then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
       else With PV do
            Begin
              case TEdit(Sender).Name[1] of
                'A'..'D':
                     Begin
                       If (InitialCond<>Conv) or (WizStatus=0) then W9_FieldEdited:=True;
                       InitialCond :=Conv;
                     End;
                'J':         LoadsRec.ConstLoad :=Conv;
                'E','F','H': LoadsRec.Alt_ConstLoad[InflowLoadT] := Conv;
                'G','I':     LoadsRec.Alt_ConstLoad[DischargeLoadT] := Conv;
              End; {case}
            End; {else}
  UpdateScreen;
End;

procedure TWizBase9.EnableDisable(Sender: TObject);
Var ThisGrid : TDBGrid;
    ThisNav  : TDBNavigator;
    ThisConstEdit: TEdit;
    ConstChosen: Boolean;
    PV: TVolume;
begin
  PV := WizStudy.SV.GetStatePointer(Volume,StV,WaterCol);

  With Sender As TRadioButton do
    Begin
      If (Name[5]='D') {dynamic}
        Then ConstChosen := not Checked
        Else ConstChosen := Checked;

      Case Name[1] of
        'A' : Begin
                ThisGrid := AGrid;
                ThisNav  := ANav;
                ThisConstEdit := EConstInflow1;
                PV.LoadsRec.Alt_UseConstant[InflowLoadT] := ConstChosen;
              End;
        'B' : Begin
                ThisGrid := BGrid;
                ThisNav  := BNav;
                ThisConstEdit := FConstInflow2;
                PV.LoadsRec.Alt_UseConstant[InflowLoadT] := ConstChosen;
              End;
        'C' : Begin
                ThisGrid := CGrid;
                ThisNav  := CNav;
                ThisConstEdit := GConstOutflow1;
                PV.LoadsRec.Alt_UseConstant[DischargeLoadT] := ConstChosen;
              End;
        'D' : Begin
                ThisGrid := DGrid;
                ThisNav  := DNav;
                ThisConstEdit := JConstKnownVal;
                PV.LoadsRec.UseConstant := ConstChosen;
              End;
        'E' : Begin
                ThisGrid := EGrid;
                ThisNav  := ENav;
                ThisConstEdit := HConstInFlow2;
                PV.LoadsRec.Alt_UseConstant[InflowLoadT] := ConstChosen;
              End;
        else Begin {'F'}
                ThisGrid := FGrid;
                ThisNav  := FNav;
                ThisConstEdit := IConstOutFlow3;
                PV.LoadsRec.Alt_UseConstant[DischargeLoadT] := ConstChosen;
              End;
        End; {Case}
    End;

  If ConstChosen then  begin
                         ThisConstEdit.Enabled:=True;
                         ThisGrid.Enabled:=False;
                         ThisGrid.Color:=ClGray;
                         ThisNav.Enabled:=False;
                       end
                  else begin
                         ThisConstEdit.Enabled:=False;
                         ThisGrid.Enabled:=True;
                         ThisGrid.Color:=EditColor;
                         ThisNav.Enabled:=True;
                       end;

end;


end.
 