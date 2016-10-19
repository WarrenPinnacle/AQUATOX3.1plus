//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_11;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls, Global, WizGlobal, Aquaobj, Grids,
  DBGrids, Db, DBTables, DBCtrls, Loadings, hh;

type
  TWizBase11 = class(TWizBase)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    DefaultButt: TRadioButton;
    ConstButt: TRadioButton;
    TimeVaryButt: TRadioButton;
    ConstPanel: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    WindEdit: TEdit;
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
    Import: TButton;
    ICWindEdit: TEdit;
    DefaultPanel: TPanel;
    Label25: TLabel;
    Label29: TLabel;
    StratLabel: TLabel;
    Label8: TLabel;
    EpiAvgLabel: TLabel;
    MeanValEdit: TEdit;
    Label9: TLabel;
    Label11: TLabel;
    Label18: TLabel;
    Label7: TLabel;
    procedure ButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure AboutDynamicDataClick(Sender: TObject);
    procedure ConvNumb(Sender: TObject);
    procedure ImportClick(Sender: TObject);
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
  Wizbase11: TWizbase11;

implementation

uses Imp_Load, Convert;

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


Procedure TWizbase11.UpdateScreen;
Var PW: TWindLoading;
    Val: Double;

Begin
  PW := WizStudy.SV.GetStatePointer(WindLoading,StV,WaterCol);
  If (PW=nil) then
    Begin
      WizStudy.AddStateVariable(WindLoading,WaterCol,0,True);
      PW := WizStudy.SV.GetStatePointer(WindLoading,StV,WaterCol);
    End;

  If W11_Screen=0 then
    Begin
      MainPanel.Visible := True;
      NextButton.Enabled := (W11_WindMethChosen) or (WizStatus>0);

      If W11_WindMethChosen or (WizStatus>0)
        then
          Begin
            DefaultButt.Checked := PW.LoadsRec.NoUserLoad;
            ConstButt.Checked    := Not Defaultbutt.Checked and PW.LoadsRec.UseConstant;
            TimeVaryButt.Checked  := Not Defaultbutt.Checked and Not PW.LoadsRec.UseConstant;
          End
        else
          Begin
            ConstButt.Checked   := False;
            DefaultButt.Checked  := False;
            TimeVaryButt.Checked  := False;
          End;
    End;

  If W11_Screen=1 then
    Begin
      If PW.LoadsRec.NoUserLoad
        Then
          Begin

            Val := PW.MeanValue;
            If (WizStatus<>0) or W11_FieldEdited[1]
              then MeanValEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
              else MeanValEdit.Text := '';


          End {Default Time Series}

        Else if PW.LoadsRec.UseConstant
         Then
          Begin
            Val := PW.LoadsRec.ConstLoad;
            If (WizStatus<>0) or W11_FieldEdited[2]
              then WindEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
              else WindEdit.Text := '';

            PW.InitialCond := PW.LoadsRec.ConstLoad;
            PW.LoadsRec.UseConstant := True;

          End {UseConstant}
        Else
          Begin  {TimeVarying}
            PW.LoadsRec.UseConstant := False;

            Val := PW.InitialCond;
            If (WizStatus<>0) or W11_FieldEdited[2]
              then ICWindEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
              else ICWindEdit.Text := '';

          End; {TimeVarying}

      MainPanel.Visible := False;
      DefaultPanel.Visible := PW.LoadsRec.NoUserLoad;
      ConstPanel.Visible   := (not PW.LoadsRec.NoUserLoad) and (PW.LoadsRec.UseConstant);
      DynamPanel.Visible   := (not PW.LoadsRec.NoUserLoad) and (not PW.LoadsRec.UseConstant);
    End; {If W11_Screen=1}
End;

procedure TWizbase11.PutDatabaseData;
Var TableIn: TTable;
    i: Integer;
    PW: TWindLoading;


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
  PW := WizStudy.SV.GetStatePointer(WindLoading,StV,WaterCol);

  WizBusy := True;
  Try

  Table1.DatabaseName:=Program_Dir;
  Table1.Active:=False;
  Table1.EmptyTable;
  Table1.Active := True;

  TableIn := Table1;
    With PW.LoadsRec.Loadings do
      For i:=0 to count-1 do
        PutInDbase(at(i));

  Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;

End;

procedure TWizbase11.GetDatabaseData;
Var PW: TWindLoading;

begin
  If not Table1.Active then exit;
  PW := WizStudy.SV.GetStatePointer(WindLoading,StV,WaterCol);

  Try
  WizBusy := True;
  LoadingsFromTable(Table1,PW.LoadsRec.Loadings);
  Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;
End;

Function TWizbase11.ExecuteScreen: WizOutput;
Var Loop: Integer;
Begin
  If FirstVisit then
    Begin
      W11_WindMethChosen := False;
      For Loop := 1 to W11_NumFields do
        W11_FieldEdited[Loop] := False;
    End;

  If JumpIn = WzBack then Begin
                            If Not W11_WindMethChosen then W11_Screen := 0
                                                      else W11_Screen := 1;
                            PutDatabaseData;
                          End
                     else W11_Screen := 0;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (DataFinished) then WizStatus := 2;
  For Loop := 1 to W11_NumFields do
    If (WizStatus=1) and (W11_FieldEdited[Loop]) then WizStatus := 2;
End;


procedure TWizbase11.ButtonClick(Sender: TObject);
Var PW: TWindLoading;
begin
  PW := WizStudy.SV.GetStatePointer(WindLoading,StV,WaterCol);

  PW.LoadsRec.NoUserLoad := DefaultButt.Checked;
  PW.LoadsRec.UseConstant := ConstButt.Checked;

  W11_WindMethChosen := ((ConstButt.Checked) or
                    (DefaultButt.Checked) or
                    (TimeVaryButt.Checked));
  UpdateScreen;
end;

Function TWizbase11.DataFinished: Boolean;
Var PW: TWindLoading;
Begin
  PW := WizStudy.SV.GetStatePointer(WindLoading,StV,WaterCol);

  If PW.LoadsRec.NoUserLoad
    then DataFinished := W11_FieldEdited[1]
    else DataFinished := W11_FieldEdited[2];

End;


procedure TWizBase11.NextButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;
  If (W11_Screen=1)
    then
      Begin
        GetDatabaseData;
        inherited
      End
    else
      Begin
        Inc(W11_Screen);
        PutDatabaseData;
        UpdateScreen;
      End;
end;

procedure TWizBase11.BackButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;
  If W11_Screen>0
    then
      Begin
        GetDatabaseData;
        Dec(W11_Screen);
        UpdateScreen;
      End
    else inherited;
end;

procedure TWizbase11.AboutDynamicDataClick(Sender: TObject);
begin
  HTMLHelpContext('Important_Note_about_Dynamic_Loadings.htm');
end;

procedure TWizbase11.ConvNumb(Sender: TObject);
Var Conv  : Double;
    Result: Integer;
    Txt: String;
Var PW: TWindLoading;
begin
  PW := WizStudy.SV.GetStatePointer(WindLoading,StV,WaterCol);
  Txt :=Tedit(Sender).Text;
  If Trim(Txt)='' then exit;

  Val(Txt,Conv,Result);
  Conv:=Abs(Conv);
  If (Result<>0)
       then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
       else With WizStudy.location.Locale do
            Begin
              Case TEdit(Sender).Name[1] of
                'M': Begin
                       If (PW.MeanValue<>Conv) or (WizStatus=0) then W11_FieldEdited[1]:=True;
                       PW.MeanValue :=Conv;
                     End;
                'W': Begin
                       If (PW.LoadsRec.ConstLoad<>Conv) or (WizStatus=0) then W11_FieldEdited[2]:=True;
                       PW.InitialCond :=Conv;
                       PW.LoadsRec.ConstLoad := Conv;
                     End;
                'I': Begin
                       If (PW.InitialCond<>Conv) or (WizStatus=0) then W11_FieldEdited[2]:=True;
                       PW.InitialCond :=Conv;
                     End;
              End; {case}
            End; {else}
  UpdateScreen;
End;

procedure TWizBase11.ImportClick(Sender: TObject);
begin
  Table1.Active:=False;
  ImportForm.ChangeLoading('Wind Loading (m/s)',Table1,False,False,CTNone);
  Table1.Active:=True;
  Update;
end;

end.
 