//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_13;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls, Global, WizGlobal, Aquaobj, Grids,
  DBGrids, Db, DBTables, DBCtrls, Loadings, hh;

type
  TWizBase13 = class(TWizBase)
    Label5: TLabel;
    Panel2: TPanel;
    ConstButt: TRadioButton;
    TimeVaryButt: TRadioButton;
    ConstPanel: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    ConstpH: TEdit;
    Table1: TTable;
    DataSource1: TDataSource;
    DynamPanel: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    EpiVaryPanel: TPanel;
    Label17: TLabel;
    EpiGrid: TDBGrid;
    Button2: TButton;
    BNav: TDBNavigator;
    EpiImport: TButton;
    ICEdit: TEdit;
    Label9: TLabel;
    Label18: TLabel;
    procedure ButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure AboutDynamicDataClick(Sender: TObject);
    procedure ConvNumb(Sender: TObject);
    procedure EpiImportClick(Sender: TObject);
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

var
  Wizbase13: TWizbase13;

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


Procedure TWizbase13.UpdateScreen;
Var TpH: TLight;
    Val: Double;

Begin
  TpH := WizStudy.SV.GetStatePointer(pH,StV,WaterCol);

  If W13_Screen=0 then
    Begin
      MainPanel.Visible := True;
      NextButton.Enabled := (W13_pHMethChosen) or (WizStatus>0);

      If W13_pHMethChosen or (WizStatus>0)
        then
          Begin
            ConstButt.Checked    := TpH.LoadsRec.UseConstant;
            TimeVaryButt.Checked  := Not TpH.LoadsRec.UseConstant;
          End
        else
          Begin
            ConstButt.Checked   := False;
            TimeVaryButt.Checked  := False;
          End;
    End;

  If W13_Screen=1 then
    Begin
       If TpH.LoadsRec.UseConstant
         Then
          Begin
            Val := TpH.LoadsRec.ConstLoad;
            If (WizStatus<>0) or W13_FieldEdited[1]
              then ConstpH.Text := FloatToStrF(Val,ffgeneral,9,4)
              else ConstpH.Text := '';

            TpH.InitialCond := TpH.LoadsRec.ConstLoad;
            TpH.LoadsRec.UseConstant := True;

          End {UseConstant}
        Else
          Begin  {TimeVarying}
            TpH.LoadsRec.UseConstant := False;

            Val := TpH.InitialCond;
            If (WizStatus<>0) or W13_FieldEdited[1]
              then ICEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
              else ICEdit.Text := '';

          End; {TimeVarying}

      MainPanel.Visible := False;
      ConstPanel.Visible   :=  (TpH.LoadsRec.UseConstant);
      DynamPanel.Visible   :=  (not TpH.LoadsRec.UseConstant);
    End; {If W13_Screen=1}
End;

procedure TWizbase13.PutDatabaseData;
Var TableIn: TTable;
    i: Integer;
    TpH: TpHObj;


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
  TpH := WizStudy.SV.GetStatePointer(pH,StV,WaterCol);

  WizBusy := True;
  Try

  Table1.DatabaseName:=Program_Dir;
  Table1.Active:=False;
  Table1.EmptyTable;
  Table1.Active := True;

  TableIn := Table1;
    With TpH.LoadsRec.Loadings do
      For i:=0 to count-1 do
        PutInDbase(at(i));


  Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;
        
End;

procedure TWizbase13.GetDatabaseData;
Var TpH: TpHObj;

begin
  If not Table1.Active then exit;

    Try
     WizBusy := True;
     TpH := WizStudy.SV.GetStatePointer(pH,StV,WaterCol);
     LoadingsFromTable(Table1,TpH.LoadsRec.Loadings);
    Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;

End;

Function TWizbase13.ExecuteScreen: WizOutput;
Var Loop: Integer;
Begin
  If FirstVisit then
    Begin
      W13_pHMethChosen := False;
      For Loop := 1 to W13_NumFields do
        W13_FieldEdited[Loop] := False;
    End;

  If JumpIn = WzBack then Begin
                            If Not W13_pHMethChosen then W13_Screen := 0
                                                    else W13_Screen := 1;
                            PutDatabaseData;
                          End
                     else W13_Screen := 0;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (DataFinished) then WizStatus := 2;
  For Loop := 1 to W13_NumFields do
    If (WizStatus=1) and (W13_FieldEdited[Loop]) then WizStatus := 2;
End;


procedure TWizbase13.ButtonClick(Sender: TObject);
Var TpH: TpHObj;
begin
  TpH := WizStudy.SV.GetStatePointer(pH,StV,WaterCol);
  TpH.LoadsRec.UseConstant := ConstButt.Checked;

  W13_pHMethChosen := ((ConstButt.Checked) or
                   (TimeVaryButt.Checked));
  UpdateScreen;
end;

Function TWizbase13.DataFinished: Boolean;
Begin
  DataFinished := W13_FieldEdited[1];
End;


procedure TWizBase13.NextButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;

  If (W13_Screen=1)
    then
      Begin
        GetDatabaseData;
        inherited
      End
    else
      Begin
        Inc(W13_Screen);
        PutDatabaseData;
        UpdateScreen;
      End;
end;

procedure TWizBase13.BackButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;

  If W13_Screen>0
    then
      Begin
        GetDatabaseData;
        Dec(W13_Screen);
        UpdateScreen;
      End
    else inherited;
end;

procedure TWizbase13.AboutDynamicDataClick(Sender: TObject);
begin
  HTMLHelpContext('Important_Note_about_Dynamic_Loadings.htm');
end;

procedure TWizbase13.ConvNumb(Sender: TObject);
Var Conv  : Double;
    Result: Integer;
    Txt: String;
Var TpH: TpHObj;
begin
  TpH := WizStudy.SV.GetStatePointer(pH,StV,WaterCol);
  Txt :=Tedit(Sender).Text;
  If Trim(Txt)='' then exit;

  Val(Txt,Conv,Result);
  Conv:=Abs(Conv);
  If (Result<>0)
     then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
     else With WizStudy.location.Locale do
          Begin
            Case TEdit(Sender).Name[1] of
              'C': Begin
                     If (TpH.LoadsRec.ConstLoad<>Conv) or (WizStatus=0) then W13_FieldEdited[1]:=True;
                     TpH.InitialCond :=Conv;
                     TpH.LoadsRec.ConstLoad := Conv;
                   End;
              'I': Begin
                     If (TpH.InitialCond<>Conv) or (WizStatus=0) then W13_FieldEdited[1]:=True;
                     TpH.InitialCond :=Conv;
                   End;
            End; {case}
          End; {else}
  UpdateScreen;
End;

procedure TWizBase13.EpiImportClick(Sender: TObject);
begin
  Table1.Active:=False;
  ImportForm.ChangeLoading('pH of Water',Table1,False,False,CTNone);
  Table1.Active:=True;
  Update;
end;

end.
 