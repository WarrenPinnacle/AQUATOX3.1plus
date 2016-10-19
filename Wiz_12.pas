//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_12;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls, Global, WizGlobal, Aquaobj, Grids,
  DBGrids, Db, DBTables, DBCtrls, Loadings, hh;

type
  TWizBase12 = class(TWizBase)
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
    CLEdit: TEdit;
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
    AnnMeanPanel: TPanel;
    Label25: TLabel;
    Label29: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    EpiAvgLabel: TLabel;
    RangeLabel: TLabel;
    AveLight: TEdit;
    LightRangeEdit: TEdit;
    Label9: TLabel;
    Label11: TLabel;
    Label18: TLabel;
    Label7: TLabel;
    LatitudeButt: TRadioButton;
    UseConstButt: TRadioButton;
    PhotoperiodEdit: TEdit;
    PhotoUnit: TLabel;
    ConvertLight2: TButton;
    ConvertLightButton: TButton;
    Button1: TButton;
    Button3: TButton;
    procedure ButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure AboutDynamicDataClick(Sender: TObject);
    procedure ConvNumb(Sender: TObject);
    procedure EpiImportClick(Sender: TObject);
    procedure UseConstButtClick(Sender: TObject);
    procedure ConvertLightButtonClick(Sender: TObject);
    procedure ConvertLight2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
  Wizbase12: TWizbase12;

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


Procedure TWizbase12.UpdateScreen;
Var PL: TLight;
    Val: Double;

Begin
  PL := WizStudy.SV.GetStatePointer(Light,StV,WaterCol);

{  If W12_Screen=0 then   }
    Begin
      MainPanel.Visible := True;
      NextButton.Enabled := (W12_LightMethChosen) or (WizStatus>0);

      If W12_LightMethChosen or (WizStatus>0)
        then
          Begin
            AnnMeanButt.Checked := PL.LoadsRec.NoUserLoad;
            ConstButt.Checked    := Not AnnMeanbutt.Checked and PL.LoadsRec.UseConstant;
            TimeVaryButt.Checked  := Not AnnMeanbutt.Checked and Not PL.LoadsRec.UseConstant;
          End
        else
          Begin
            ConstButt.Checked   := False;
            AnnMeanButt.Checked  := False;
            TimeVaryButt.Checked  := False;
          End;
    End;

  If W12_Screen=1 then
    Begin
      If PL.LoadsRec.NoUserLoad
        Then With WizStudy.Location.Locale do
          Begin
            LatitudeButt.Checked := PL.CalculatePhotoperiod;
            UseConstButt.Checked := not PL.CalculatePhotoperiod;
            PhotoUnit.Enabled       := not PL.CalculatePhotoperiod;
            PhotoPeriodEdit.Enabled := not PL.CalculatePhotoperiod;

            Val := PL.UserPhotoPeriod;
            PhotoperiodEdit.Text := FloatToStrF(Val,ffgeneral,9,4);

            Val := LightMean;
            If (WizStatus<>0) or W12_FieldEdited[1]
              then AveLight.Text := FloatToStrF(Val,ffgeneral,9,4)
              else AveLight.Text := '';


            Val := LightRange;
            If (WizStatus<>0) or W12_FieldEdited[2]
              then LightRangeEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
              else LightRangeEdit.Text := '';

          End {Annual Means}
        Else if PL.LoadsRec.UseConstant
         Then
          Begin
            Val := PL.LoadsRec.ConstLoad;
            If (WizStatus<>0) or W12_FieldEdited[3]
              then CLEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
              else CLEdit.Text := '';

            PL.InitialCond := PL.LoadsRec.ConstLoad;
            PL.LoadsRec.UseConstant := True;

          End {UseConstant}
        Else
          Begin  {TimeVarying}
            PL.LoadsRec.UseConstant := False;

            Val := PL.InitialCond;
            If (WizStatus<>0) or W12_FieldEdited[3]
              then ICEdit.Text := FloatToStrF(Val,ffgeneral,9,4)
              else ICEdit.Text := '';

          End; {TimeVarying}

      MainPanel.Visible := False;
      AnnMeanPanel.Visible := PL.LoadsRec.NoUserLoad;
      ConstPanel.Visible   := (not PL.LoadsRec.NoUserLoad) and (PL.LoadsRec.UseConstant);
      DynamPanel.Visible   := (not PL.LoadsRec.NoUserLoad) and (not PL.LoadsRec.UseConstant);
    End; {If W12_Screen=1}
End;

procedure TWizbase12.PutDatabaseData;
Var TableIn: TTable;
    i: Integer;
    PL: TLight;


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
  PL := WizStudy.SV.GetStatePointer(Light,StV,WaterCol);

  WizBusy := True;
  Try

  Table1.DatabaseName:=Program_Dir;
  Table1.Active:=False;
  Table1.EmptyTable;
  Table1.Active := True;

  TableIn := Table1;
    With PL.LoadsRec.Loadings do
      For i:=0 to count-1 do
        PutInDbase(at(i));

  Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;
        
End;

procedure TWizbase12.GetDatabaseData;
Var PL: TLight;

begin
  If not Table1.Active then exit;
  PL := WizStudy.SV.GetStatePointer(Light,StV,WaterCol);
  Try
    WizBusy := True;
    LoadingsFromTable(Table1,PL.LoadsRec.Loadings);
  Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;
End;

Function TWizbase12.ExecuteScreen: WizOutput;
Var Loop: Integer;
Begin
  If FirstVisit then
    Begin
      W12_LightMethChosen := False;
      For Loop := 1 to W12_NumFields do
        W12_FieldEdited[Loop] := False;
    End;

  If JumpIn = WzBack then Begin
                            If Not W12_LightMethChosen then W12_Screen := 0
                                                       else W12_Screen := 1;
                            PutDatabaseData;
                          End
                     else W12_Screen := 0;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (DataFinished) then WizStatus := 2;
  For Loop := 1 to W12_NumFields do
    If (WizStatus=1) and (W12_FieldEdited[Loop]) then WizStatus := 2;
End;


procedure TWizBase12.Button1Click(Sender: TObject);
begin
  Application.CreateForm(TConvertForm,ConvertForm);
  ConvertForm.ConvertNumber(ICEdit,CTLight);
  ConvertForm.Free;
end;

procedure TWizBase12.Button3Click(Sender: TObject);
begin
  Application.CreateForm(TConvertForm,ConvertForm);
  ConvertForm.ConvertNumber(CLEdit,CTLight);
  ConvertForm.Free;
end;

procedure TWizbase12.ButtonClick(Sender: TObject);
Var PL: TLight;
begin
  PL := WizStudy.SV.GetStatePointer(Light,StV,WaterCol);

  PL.LoadsRec.NoUserLoad := AnnMeanButt.Checked;
  PL.LoadsRec.UseConstant := ConstButt.Checked;

  W12_LightMethChosen := ((ConstButt.Checked) or
                         (AnnMeanButt.Checked) or
                         (TimeVaryButt.Checked));
  UpdateScreen;
end;

Function TWizbase12.DataFinished: Boolean;
Var PL: TLight;
    Loop: Integer;
Begin
  PL := WizStudy.SV.GetStatePointer(Light,StV,WaterCol);

  DataFinished:=True;

  If PL.LoadsRec.NoUserLoad
    then Begin
           For Loop := 1 to 2 do
             If Not W12_FieldEdited[Loop] then DataFinished := False;
         End
    else DataFinished := W12_FieldEdited[3];

End;


procedure TWizBase12.NextButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;

  If (W12_Screen=1)
    then
      Begin
        GetDatabaseData;
        inherited
      End
    else
      Begin
        Inc(W12_Screen);
        PutDatabaseData;
        UpdateScreen;
      End;
end;

procedure TWizBase12.BackButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;

  If W12_Screen>0
    then
      Begin
        GetDatabaseData;
        Dec(W12_Screen);
        UpdateScreen;
      End
    else inherited;
end;

procedure TWizbase12.AboutDynamicDataClick(Sender: TObject);
begin
  HTMLHelpContext('Important_Note_about_Dynamic_Loadings.htm');
end;

procedure TWizBase12.ConvertLight2Click(Sender: TObject);
begin
  Application.CreateForm(TConvertForm,ConvertForm);
  ConvertForm.ConvertNumber(LightRangeEdit,CTLight);
  ConvertForm.Free;

end;

procedure TWizBase12.ConvertLightButtonClick(Sender: TObject);
begin
  Application.CreateForm(TConvertForm,ConvertForm);
  ConvertForm.ConvertNumber(AveLight,CTLight);
  ConvertForm.Free;
end;

procedure TWizbase12.ConvNumb(Sender: TObject);
Var Conv  : Double;
    Result: Integer;
    Txt: String;
Var PL: TLight;
begin
  PL := WizStudy.SV.GetStatePointer(Light,StV,WaterCol);
  Txt :=Tedit(Sender).Text;
  If Trim(Txt)='' then exit;

  Val(Txt,Conv,Result);
  Conv:=Abs(Conv);
  If (Result<>0)
       then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
       else With WizStudy.location.Locale do
            Begin
              Case TEdit(Sender).Name[1] of
                'A': Begin
                       If (LightMean<>Conv) or (WizStatus=0) then W12_FieldEdited[1]:=True;
                       LightMean  := Conv;
                       XLightMean := '';
                     End;
                'L': Begin
                       If (LightRange<>Conv) or (WizStatus=0) then W12_FieldEdited[2]:=True;
                       LightRange  := Conv;
                       XLightRange := '';
                     End;
                'C': Begin
                       If (PL.LoadsRec.ConstLoad<>Conv) or (WizStatus=0) then W12_FieldEdited[3]:=True;
                       PL.InitialCond :=Conv;
                       PL.LoadsRec.ConstLoad := Conv;
                     End;
                'I': Begin
                       If (PL.InitialCond<>Conv) or (WizStatus=0) then W12_FieldEdited[3]:=True;
                       PL.InitialCond :=Conv;
                     End;
                'P': PL.UserPhotoPeriod := Conv;
              End; {case}
            End; {else}
  UpdateScreen;
End;

procedure TWizBase12.EpiImportClick(Sender: TObject);
begin
  Table1.Active:=False;
  ImportForm.ChangeLoading('Light Loadings (Ly/d)',Table1,False,False,CTLight);
  Table1.Active:=True;
  Update;
end;

procedure TWizBase12.UseConstButtClick(Sender: TObject);
Var PL: TLight;
begin
  PL := WizStudy.SV.GetStatePointer(Light,StV,WaterCol);
  If W12_Screen = 1 then PL.CalculatePhotoperiod := LatitudeButt.Checked;
  UpdateScreen;
end;

end.
 