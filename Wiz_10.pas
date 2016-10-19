//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_10;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls, Global, WizGlobal, Aquaobj, Grids,
  DBGrids, Db, DBTables, DBCtrls, Loadings, hh;

type
  TWizBase10 = class(TWizBase)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    AnnMeanButt: TRadioButton;
    ConstButt: TRadioButton;
    TimeVaryButt: TRadioButton;
    ConstPanel: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    TempEdit: TEdit;
    Table1: TTable;
    Table2: TTable;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
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
    ICTempEdit: TEdit;
    HypVaryPanel: TPanel;
    Label21: TLabel;
    HypGrid: TDBGrid;
    NoButt: TRadioButton;
    YesButt: TRadioButton;
    HypButton: TButton;
    HypNav: TDBNavigator;
    HypImport: TButton;
    AnnMeanPanel: TPanel;
    Label25: TLabel;
    Label29: TLabel;
    StratLabel: TLabel;
    HypPanel: TPanel;
    Label8: TLabel;
    Label10: TLabel;
    EpiAvgLabel: TLabel;
    EpiRangeLabel: TLabel;
    AveEpiTemp: TEdit;
    EpiTempRange: TEdit;
    Label7: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    HAvgHypTemp: TEdit;
    RangeHyp: TEdit;
    Label9: TLabel;
    Label11: TLabel;
    Label15: TLabel;
    HypLabel: TLabel;
    Label18: TLabel;
    epistratlabel: TLabel;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    procedure ButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure AboutDynamicDataClick(Sender: TObject);
    procedure ConvNumb(Sender: TObject);
    procedure EpiImportClick(Sender: TObject);
    procedure HypImportClick(Sender: TObject);
    procedure YesNoClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
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
  Wizbase10: TWizbase10;

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


Procedure TWizbase10.UpdateScreen;
Var PT: TTemperature;
    Val: Double;
    showHyp: Boolean;

Begin
  PT := WizStudy.SV.GetStatePointer(Temperature,StV,WaterCol);

  If W10_Screen=0 then
    Begin
      MainPanel.Visible := True;
      NextButton.Enabled := (W10_TempMethChosen) or (WizStatus>0);

      If W10_TempMethChosen or (WizStatus>0)
        then
          Begin
            AnnMeanButt.Checked := PT.LoadsRec.NoUserLoad;
            ConstButt.Checked    := Not AnnMeanbutt.Checked and PT.LoadsRec.UseConstant;
            TimeVaryButt.Checked  := Not AnnMeanbutt.Checked and Not PT.LoadsRec.UseConstant;
          End
        else
          Begin
            ConstButt.Checked   := False;
            AnnMeanButt.Checked  := False;
            TimeVaryButt.Checked  := False;
          End;
    End;

  If W10_Screen=1 then
    Begin
      If PT.LoadsRec.NoUserLoad
        Then With WizStudy.Location.Locale do
          Begin

            Val := TempMean[Epilimnion];
            If (WizStatus<>0) or W10_FieldEdited[1]
              then AveEpiTemp.Text := FloatToStrF(Val,ffgeneral,9,4)
              else AveEpiTemp.Text := '';

            Val := TempRange[Epilimnion];
            If (WizStatus<>0) or W10_FieldEdited[2]
              then EpiTempRange.Text := FloatToStrF(Val,ffgeneral,9,4)
              else EpiTempRange.Text := '';


            Val := TempMean[Hypolimnion];
            If (WizStatus<>0) or W10_FieldEdited[3]
              then HAvgHypTemp.Text := FloatToStrF(Val,ffgeneral,9,4)
              else HAvgHypTemp.Text := '';

            Val := TempRange[Hypolimnion];
            If (WizStatus<>0) or W10_FieldEdited[4]
              then RangeHyp.Text := FloatToStrF(Val,ffgeneral,9,4)
              else RangeHyp.Text := '';

            ShowHyp := not (WizStudy.Location.SiteType in [Stream..Enclosure]);
            StratLabel.Visible := not ShowHyp;
            HypPanel.Visible := not ShowHyp;
            If ShowHyp then EpiAvgLabel.Caption := 'Avg. Epilimnion Temp.'
                       else EpiAvgLabel.Caption := 'Average Temperature';
            If ShowHyp then EpiRangeLabel.Caption := 'Epilimnion Temp. Range'
                       else EpiRangeLabel.Caption := 'Temperature Range';

          End {Annual Means}

        Else if PT.LoadsRec.UseConstant
         Then
          Begin
            Val := PT.LoadsRec.ConstLoad;
            If (WizStatus<>0) or W10_FieldEdited[5]
              then TempEdit.Text := FloatToStrF(Val,ffFixed,10,3)
              else TempEdit.Text := '';

            PT.InitialCond := PT.LoadsRec.ConstLoad; 
            PT.LoadsRec.UseConstant := True;

          End {UseConstant}
        Else
          Begin  {TimeVarying}
            ShowHyp := not (WizStudy.Location.SiteType in [Stream,Enclosure]);

            PT.LoadsRec.UseConstant := False;

            HypVaryPanel.Visible := ShowHyp;
            EpiStratLabel.Visible := ShowHyp;
            If ShowHyp then EpiVaryPanel.Left := 40
                       else EpiVaryPanel.Left := 168;

            Val := PT.InitialCond;
            If (WizStatus<>0) or W10_FieldEdited[5]
              then ICTempEdit.Text := FloatToStrF(Val,ffFixed,10,3)
              else ICTempEdit.Text := '';

            NoButt.Checked  := WizStudy.SV.HypoTempLoads.NoUserLoad;
            YesButt.Checked := not WizStudy.SV.HypoTempLoads.NoUserLoad;

            HypButton.Enabled := YesButt.Checked;
            HypImport.Enabled := YesButt.Checked;
            HypNav.Enabled    := YesButt.Checked;
            HypGrid.Enabled   := YesButt.Checked;
            HypLabel.Enabled  := YesButt.Checked;
            If NoButt.Checked then HypGrid.Color :=ClGray
                              else HypGrid.Color :=EditColor;

          End; {TimeVarying}

      MainPanel.Visible := False;
      AnnMeanPanel.Visible := PT.LoadsRec.NoUserLoad;
      ConstPanel.Visible   := (not PT.LoadsRec.NoUserLoad) and (PT.LoadsRec.UseConstant);
      DynamPanel.Visible   := (not PT.LoadsRec.NoUserLoad) and (not PT.LoadsRec.UseConstant);
    End; {If W10_Screen=1}
End;

procedure TWizbase10.PutDatabaseData;
Var TableIn: TTable;
    i: Integer;
    PT: TTemperature;


         Procedure PutInDbase(P: TLoad);
         {Used to put loadings data into TableIn}
         begin

            With TableIn do
               begin
                 Append;
                 Fields[0].AsDateTime:= P.Date;
                 Fields[1].AsFloat:=P.Loading;
                 TFloatField(Fields[1]).DisplayFormat:='0.000';
                 Post;
               end;

         end;

Begin
  PT := WizStudy.SV.GetStatePointer(Temperature,StV,WaterCol);

  WizBusy := True;
  Try

  Table1.DatabaseName:=Program_Dir; Table2.DatabaseName:=Program_Dir;
  Table1.Active:=False;             Table2.Active:=False;
  Table1.EmptyTable;                Table2.EmptyTable;
  Table1.Active := True;            Table2.Active := True;

  TableIn := Table1;
    With PT.LoadsRec.Loadings do
      For i:=0 to count-1 do
        PutInDbase(at(i));

  TableIn := Table2;
    With WizStudy.SV.HypoTempLoads.Loadings do
      For i:=0 to count-1 do
        PutInDbase(at(i));

  Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;

End;

procedure TWizbase10.GetDatabaseData;
Var PT: TTemperature;

begin
  If not Table1.Active then exit;
  PT := WizStudy.SV.GetStatePointer(Temperature,StV,WaterCol);

  Try
    WizBusy := True;
    LoadingsFromTable(Table1,PT.LoadsRec.Loadings);
    LoadingsFromTable(Table2,WizStudy.SV.HypoTempLoads.Loadings);
  Except
    WizBusy := False;
    Raise;
  End;

  WizBusy := False;
End;

Function TWizbase10.ExecuteScreen: WizOutput;
Var Loop: Integer;
Begin
  If FirstVisit then
    Begin
      W10_TempMethChosen := False;
      For Loop := 1 to W10_NumFields do
        W10_FieldEdited[Loop] := False;
    End;

  If JumpIn = WzBack then Begin
                            If Not W10_TempMethChosen then W10_Screen := 0
                                                      else W10_Screen := 1;
                            PutDatabaseData;
                          End
                     else W10_Screen := 0;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (DataFinished) then WizStatus := 2;
  For Loop := 1 to W10_NumFields do
    If (WizStatus=1) and (W10_FieldEdited[Loop]) then WizStatus := 2;
End;


procedure TWizBase10.Button5Click(Sender: TObject);
begin
  Application.CreateForm(TConvertForm,ConvertForm);
  If Sender = Button1 then ConvertForm.ConvertNumber(AveEpiTemp,CTTemp);
  If Sender = Button3 then ConvertForm.ConvertNumber(EpiTempRange,CTTemp);
  If Sender = Button4 then ConvertForm.ConvertNumber(HAvgHypTemp,CTTemp);
  If Sender = Button5 then ConvertForm.ConvertNumber(RangeHyp,CTTemp);
  If Sender = Button6 then ConvertForm.ConvertNumber(ICTempEdit,CTTemp);
  If Sender = Button7 then ConvertForm.ConvertNumber(TempEdit,CTTemp);
  ConvertForm.Free;
end;

procedure TWizbase10.ButtonClick(Sender: TObject);
Var PT: TTemperature;
begin
  PT := WizStudy.SV.GetStatePointer(Temperature,StV,WaterCol);

  PT.LoadsRec.NoUserLoad := AnnMeanButt.Checked;
  PT.LoadsRec.UseConstant := ConstButt.Checked;

  W10_TempMethChosen := ((ConstButt.Checked) or
                    (AnnMeanButt.Checked) or
                    (TimeVaryButt.Checked));
  UpdateScreen;
end;

Function TWizbase10.DataFinished: Boolean;
Var PT: TTemperature;
    Loop: Integer;
Begin
  PT := WizStudy.SV.GetStatePointer(Temperature,StV,WaterCol);

  DataFinished:=True;
  If PT.LoadsRec.NoUserLoad  
    then Begin
           For Loop := 1 to 4 do
             If Not W10_FieldEdited[Loop] then DataFinished := False;
         End
    else DataFinished := W10_FieldEdited[5];

End;


procedure TWizBase10.NextButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;
  If (W10_Screen=1)
    then
      Begin
        GetDatabaseData;
        inherited
      End
    else
      Begin
        Inc(W10_Screen);
        PutDatabaseData;
        UpdateScreen;
      End;
end;

procedure TWizBase10.BackButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;
  If W10_Screen>0
    then
      Begin
        GetDatabaseData;
        Dec(W10_Screen);
        UpdateScreen;
      End
    else inherited;
end;

procedure TWizbase10.AboutDynamicDataClick(Sender: TObject);
begin
  HTMLHelpContext('Important_Note_about_Dynamic_Loadings.htm');
end;

procedure TWizbase10.ConvNumb(Sender: TObject);
Var Conv  : Double;
    Result: Integer;
    Txt: String;
Var PT: TTemperature;
begin
  PT := WizStudy.SV.GetStatePointer(Temperature,StV,WaterCol);
  Txt :=Tedit(Sender).Text;
  If Trim(Txt)='' then exit;

  Val(Txt,Conv,Result);
  If (Result<>0)
       then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
       else With WizStudy.location.Locale do
            Begin
              Case TEdit(Sender).Name[1] of
                'A': Begin
                       If (TempMean[Epilimnion]<>Conv) or (WizStatus=0) then W10_FieldEdited[1]:=True;
                       TempMean[Epilimnion] :=Conv;
                       XTempMean[Epilimnion] := '';
                     End;
                'E': Begin
                       If (TempRange[Epilimnion]<>Conv) or (WizStatus=0) then W10_FieldEdited[2]:=True;
                       TempRange[Epilimnion] :=Conv;
                       XTempRange[Epilimnion] := '';
                     End;
                'H': Begin
                       If (TempMean[Hypolimnion]<>Conv) or (WizStatus=0) then W10_FieldEdited[3]:=True;
                       TempMean[Hypolimnion] :=Conv;
                       XTempMean[Hypolimnion] := '';
                     End;
                'R': Begin
                       If (TempRange[Hypolimnion]<>Conv) or (WizStatus=0) then W10_FieldEdited[4]:=True;
                       TempRange[Hypolimnion] :=Conv;
                       XTempRange[Hypolimnion] := '';
                     End;
                'I': Begin
                       If (PT.InitialCond<>Conv) or (WizStatus=0) then W10_FieldEdited[5]:=True;
                       PT.InitialCond :=Conv;
                     End;  
                'T': Begin
                       If (PT.LoadsRec.ConstLoad<>Conv) or (WizStatus=0) then W10_FieldEdited[5]:=True;
                       PT.LoadsRec.ConstLoad := Conv;
                       PT.InitialCond :=Conv;
                     End;

              End; {case}
            End; {else}
  UpdateScreen;
End;

procedure TWizBase10.EpiImportClick(Sender: TObject);
begin
  If WizBusy then Exit;
  Table1.Active:=False;
  ImportForm.ChangeLoading('Epilimnion Temp. (deg. C)',Table1,False,False,CTTemp);
  Table1.Active:=True;
  Update;
end;

procedure TWizBase10.HypImportClick(Sender: TObject);
begin
  If WizBusy then Exit;
  Table2.Active:=False;
  ImportForm.ChangeLoading('Hypolimnion Temp. (deg. C)',Table2,False,False,CTTemp);
  Table2.Active:=True;
  Update;
end;

procedure TWizBase10.YesNoClick(Sender: TObject);
begin
  WizStudy.SV.HypoTempLoads.NoUserLoad := NoButt.Checked;
  UpdateScreen;
end;

end.
 