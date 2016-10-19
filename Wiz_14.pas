//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_14;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls, Global, WizGlobal, Aquaobj, Grids,
  DBGrids, Db, DBTables, DBCtrls, Loadings, hh;

type
  TWizBase14 = class(TWizBase)
    methodlabel: TLabel;
    Panel2: TPanel;
    ConstButt: TRadioButton;
    TimeVaryButt: TRadioButton;
    ConstPanel: TPanel;
    Label4: TLabel;
    Label6: TLabel;
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
    Panel1: TPanel;
    YesButt: TRadioButton;
    NoButt: TRadioButton;
    ConstTSS: TEdit;
    SSSpanel: TPanel;
    Label1: TLabel;
    SSSButt: TRadioButton;
    ssslabel: TLabel;
    Label2: TLabel;
    GSiltscour: TEdit;
    HClayScour: TEdit;
    ISiltDep: TEdit;
    JClayDep: TEdit;
    Label3: TLabel;
    Label5: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    KSiltFall: TEdit;
    LClayFall: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label15: TLabel;
    BSiltFrac: TEdit;
    CClayFrac: TEdit;
    Asandfrac: TEdit;
    Label16: TLabel;
    DSandConc: TEdit;
    ESiltConc: TEdit;
    FClayConc: TEdit;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    procedure ButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure AboutDynamicDataClick(Sender: TObject);
    procedure EpiImportClick(Sender: TObject);
    procedure YesButtClick(Sender: TObject);
    procedure ConvNumb(Sender: TObject);
    procedure ConvNumb2(Sender: TObject);
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
  Wizbase14: TWizbase14;


implementation

uses Convert, imp_load;

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


Procedure TWizbase14.UpdateScreen;
Var Val: Double;
    PTSS, TSand,PSilt,PClay: TSandSiltClay;

Begin
  PTSS := WizStudy.SV.GetStatePointer(TSS,StV,WaterCol);
  TSand := WizStudy.SV.GetStatePointer(Sand,StV,WaterCol);
  PSilt := WizStudy.SV.GetStatePointer(Silt,StV,WaterCol);
  PClay := WizStudy.SV.GetStatePointer(Clay,StV,WaterCol);

  If (PTSS=nil) and (TSand=nil) then W14_Screen:=0;
  If (W14_Screen=1) and (PTSS=nil) then W14_Screen:=0;
  If (W14_Screen=2) and (TSand=nil) then W14_Screen:=0;

  If W14_Screen=0 then
    Begin

      MainPanel.Visible := True;
      SSSpanel.visible  := False;

      If WizStudy.Location.Sitetype=stream then SSSButt.Enabled := True
                                             else SSSButt.Enabled := False;

      If (WizStatus=0) and (not W14_YesNoClick) then
        Begin
          NoButt.Checked       := False;
          YesButt.Checked      := False;
          ConstButt.Enabled    := False;
          MethodLabel.Enabled  := False;
          TimeVaryButt.Enabled := False;
          NextButton.Enabled   := False;
          Exit;
        End;

      If (PTSS = nil) and (TSand=nil) then
        Begin
          NoButt.Checked       := True;
          YesButt.Checked      := False;
          SSSButt.Checked      := False;
          ConstButt.Enabled    := False;
          MethodLabel.Enabled  := False;
          TimeVaryButt.Enabled := False;
          NextButton.Enabled   := (W14_YesNoClick) or (WizStatus>0);
          Exit;
        End;

      If (PTSS <> nil) then
        Begin
          NoButt.Checked       := False;
          YesButt.Checked      := True;
          SSSButt.Checked      := False;
          ConstButt.Enabled    := True;
          MethodLabel.Enabled  := True;
          TimeVaryButt.Enabled := True;
          NextButton.Enabled := (W14_TSSMethChosen) or (WizStatus>0);
          If W14_TSSMethChosen or (WizStatus>0)
            then
              Begin
                ConstButt.Checked    := PTSS.LoadsRec.UseConstant;
                TimeVaryButt.Checked  := Not PTSS.LoadsRec.UseConstant;
              End
            else
              Begin
                ConstButt.Checked   := False;
                TimeVaryButt.Checked  := False;
              End;
        End;

      If (TSand <> nil) then
        Begin
          NoButt.Checked       := False;
          YesButt.Checked      := False;
          SSSButt.Checked      := True;
          ConstButt.Enabled    := False;
          MethodLabel.Enabled  := False;
          TimeVaryButt.Enabled := False;
          NextButton.Enabled   := True;
        End;
    End;

  If W14_Screen=1 then
    Begin
       If PTSS.LoadsRec.UseConstant
         Then
          Begin
            Val := PTSS.LoadsRec.ConstLoad;
            If (WizStatus<>0) or (W14_FieldEdited[1])
              then ConstTSS.Text := FloatToStrF(Val,ffFixed,10,4)
              else ConstTSS.Text := '';

            PTSS.InitialCond := PTSS.LoadsRec.ConstLoad;
            PTSS.LoadsRec.UseConstant := True;

          End {UseConstant}
        Else
          Begin  {TimeVarying}
            PTSS.LoadsRec.UseConstant := False;

            Val := PTSS.InitialCond;
            If (WizStatus<>0) or W14_FieldEdited[1]
              then ICEdit.Text := FloatToStrF(Val,ffFixed,10,4)
              else ICEdit.Text := '';

          End; {TimeVarying}
      MainPanel.Visible := False;
      SSSpanel.visible  := False;
      ConstPanel.Visible   :=  (PTSS.LoadsRec.UseConstant);
      DynamPanel.Visible   :=  (not PTSS.LoadsRec.UseConstant);
    End; {If W14_Screen=1}


  If W14_Screen=2 then
    Begin
      If (WizStatus<>0) or (W14_FieldEdited[2]) then
        Asandfrac.Text := FloatToStrF(TSand.FracInBed,ffGeneral,10,4);
      If (WizStatus<>0) or (W14_FieldEdited[3]) then
        BSiltFrac.Text := FloatToStrF(PSilt.FracInBed,ffGeneral,10,4);
      If (WizStatus<>0) or (W14_FieldEdited[4]) then
        CClayFrac.Text := FloatToStrF(PClay.FracInBed,ffGeneral,10,4);
      If (WizStatus<>0) or (W14_FieldEdited[5]) then
        DSandConc.Text := FloatToStrF(TSand.InitialCond,ffGeneral,10,4);
      If (WizStatus<>0) or (W14_FieldEdited[6]) then
        ESiltConc.Text := FloatToStrF(PSilt.InitialCond,ffGeneral,10,4);
      If (WizStatus<>0) or (W14_FieldEdited[7]) then
        FClayConc.Text := FloatToStrF(PClay.InitialCond,ffGeneral,10,4);
      With WizStudy.Location.Locale do
        Begin
          If (WizStatus<>0) or (W14_FieldEdited[8]) then
            GSiltscour.Text :=  FloatToStrF(ts_silt,ffGeneral,10,4);
          If (WizStatus<>0) or (W14_FieldEdited[9]) then
            HClayScour.Text :=  FloatToStrF(ts_clay,ffGeneral,10,4);
          If (WizStatus<>0) or (W14_FieldEdited[10]) then
            ISiltDep.Text :=    FloatToStrF(tdep_silt,ffGeneral,10,4);
          If (WizStatus<>0) or (W14_FieldEdited[11]) then
            JClayDep.Text :=    FloatToStrF(tdep_clay,ffGeneral,10,4);
          If (WizStatus<>0) or (W14_FieldEdited[12]) then
            KSiltFall.Text :=   FloatToStrF(FallVel_silt,ffGeneral,10,4);
          If (WizStatus<>0) or (W14_FieldEdited[13]) then
            LClayFall.Text :=   FloatToStrF(FallVel_clay,ffGeneral,10,4);
          End;

      SSSpanel.visible  := True;
      MainPanel.Visible := False;
      ConstPanel.Visible   :=  False;
      DynamPanel.Visible   :=  False;
    End; {If W14_Screen=2}
End;

procedure TWizbase14.PutDatabaseData;
Var TableIn: TTable;
    i: Integer;
    PTSS: TSandSiltClay;


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
  PTSS := WizStudy.SV.GetStatePointer(TSS,StV,WaterCol);

  WizBusy := True;
  Try

  Table1.DatabaseName:=Program_Dir;
  Table1.Active:=False;
  Table1.EmptyTable;
  Table1.Active := True;

  TableIn := Table1;
    With PTSS.LoadsRec.Loadings do
      For i:=0 to count-1 do
        PutInDbase(at(i));

  Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;


End;

procedure TWizbase14.GetDatabaseData;
Var PTSS: TSandSiltClay;
begin

  If not Table1.Active then exit;

    Try
     WizBusy := True;

  PTSS := WizStudy.SV.GetStatePointer(TSS,StV,WaterCol);
  LoadingsFromTable(Table1,PTSS.LoadsRec.Loadings);
    Except
    WizBusy := False;
    Raise;
  End;
  WizBusy := False;

End;

Function TWizbase14.ExecuteScreen: WizOutput;
Var Loop: Integer;
    PTSS: TSandSiltClay;
    TSand: TSandSiltClay;
begin
  PTSS := WizStudy.SV.GetStatePointer(TSS,StV,WaterCol);
  TSand := WizStudy.SV.GetStatePointer(Sand,StV,WaterCol);
  
  If FirstVisit then
    Begin
      W14_YesNoClick := False;
      W14_TSSMethChosen := False;
      W14_SSSMethChosen := False;
      For Loop := 1 to W14_NumFields do
        W14_FieldEdited[Loop] := False;
    End;

  If (JumpIn=WzBack) and (PTSS<>nil)
    then
                          Begin
                            W14_Screen := 1;
                            PutDatabaseData;
                          End
    else If (JumpIn=WzBack) and (TSand<>nil)
                     then W14_Screen := 2
                     else W14_Screen := 0;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (DataFinished) then WizStatus := 2;
  For Loop := 1 to W14_NumFields do
    If (WizStatus=1) and (W14_FieldEdited[Loop]) then WizStatus := 2;
End;


procedure TWizbase14.ButtonClick(Sender: TObject);
Var PTSS: TSandSiltClay;
begin
  PTSS := WizStudy.SV.GetStatePointer(TSS,StV,WaterCol);

  PTSS.LoadsRec.UseConstant := ConstButt.Checked;

  W14_TSSMethChosen := ((ConstButt.Checked) or
                       (TimeVaryButt.Checked));
  UpdateScreen;
end;

Function TWizbase14.DataFinished: Boolean;
Var Loop: Integer;
Begin
  If NoButt.Checked
    then DataFinished := True
    else if YesButt.Checked
      then DataFinished := W14_FieldEdited[1]
      else Begin
             DataFinished := True;
             For Loop := 2 to W14_NumFields do
               If not W14_FieldEdited[Loop] then DataFinished := False;
           End;
End;


procedure TWizBase14.NextButtonClick(Sender: TObject);
Var  TSand,PSilt,PClay: TSandSiltClay;
     SandF,SiltF,ClayF: Double;
Begin
  If WizBusy then Exit;

  TSand := WizStudy.SV.GetStatePointer(Sand,StV,WaterCol);
  PSilt := WizStudy.SV.GetStatePointer(Silt,StV,WaterCol);
  PClay := WizStudy.SV.GetStatePointer(Clay,StV,WaterCol);

  Case W14_Screen of
    0: If NoButt.Checked
         then inherited
         else if YesButt.Checked
           then
             Begin
               W14_Screen:=1;
               PutDatabaseData;
               UpdateScreen;
             end
           else
             Begin
               W14_Screen:=2;
               UpdateScreen;
             end;
    1: Begin
         GetDatabaseData;
         inherited
       End;
    2: Begin
         SandF:=TSand.FracInBed;
         SiltF:=PSilt.FracInBed;
         ClayF:=PClay.FracInBed;

         If (SandF+SiltF+ClayF < 0.98) or (SandF+SiltF+ClayF > 1.02) then
           begin
             MessageDlg('Fraction of Sand, Silt, Clay in bed sediment must sum to 1.0',mterror,[mbOK],0);
             exit
           end;
         inherited;
       End;
  end; {case}  
end;

procedure TWizBase14.BackButtonClick(Sender: TObject);
begin
  If WizBusy then Exit;

  If W14_Screen>0
    then
      Begin
        GetDatabaseData;
        Dec(W14_Screen);
        UpdateScreen;
      End
    else inherited;
end;

procedure TWizbase14.AboutDynamicDataClick(Sender: TObject);
begin
  HTMLHelpContext('Important_Note_about_Dynamic_Loadings.htm');
end;

procedure TWizbase14.ConvNumb2(Sender: TObject);
Var Conv  : Double;
    Result: Integer;
    Txt: String;
    TSand,PSilt,PClay: TSandSiltClay;
Begin
  TSand := WizStudy.SV.GetStatePointer(Sand,StV,WaterCol);
  PSilt := WizStudy.SV.GetStatePointer(Silt,StV,WaterCol);
  PClay := WizStudy.SV.GetStatePointer(Clay,StV,WaterCol);

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
                     If (TSand.FracInBed<>Conv) or (WizStatus=0) then W14_FieldEdited[2]:=True;
                     TSand.FracInBed :=Conv;
                   End;
              'B': Begin
                     If (PSilt.FracInBed<>Conv) or (WizStatus=0) then W14_FieldEdited[3]:=True;
                     PSilt.FracInBed :=Conv;
                   End;
              'C': Begin
                     If (PClay.FracInBed<>Conv) or (WizStatus=0) then W14_FieldEdited[4]:=True;
                     PClay.FracInBed :=Conv;
                   End;
              'D': Begin
                     If (TSand.InitialCond<>Conv) or (WizStatus=0) then W14_FieldEdited[5]:=True;
                     TSand.InitialCond :=Conv;
                   End;
              'E': Begin
                     If (PSilt.InitialCond<>Conv) or (WizStatus=0) then W14_FieldEdited[6]:=True;
                     PSilt.InitialCond :=Conv;
                   End;
              'F': Begin
                     If (PClay.InitialCond<>Conv) or (WizStatus=0) then W14_FieldEdited[7]:=True;
                     PClay.InitialCond :=Conv;
                   End;
              'G': Begin
                     If (ts_silt<>Conv) or (WizStatus=0) then W14_FieldEdited[8]:=True;
                     ts_silt :=Conv;
                   End;
              'H': Begin
                     If (ts_Clay<>Conv) or (WizStatus=0) then W14_FieldEdited[9]:=True;
                     ts_Clay :=Conv;
                   End;
              'I': Begin
                     If (tdep_silt<>Conv) or (WizStatus=0) then W14_FieldEdited[10]:=True;
                     tdep_silt :=Conv;
                   End;
              'J': Begin
                     If (tdep_Clay<>Conv) or (WizStatus=0) then W14_FieldEdited[11]:=True;
                     tdep_Clay :=Conv;
                   End;
              'K': Begin
                     If (fallvel_silt<>Conv) or (WizStatus=0) then W14_FieldEdited[12]:=True;
                     fallvel_silt :=Conv;
                   End;
              'L': Begin
                     If (fallvel_Clay<>Conv) or (WizStatus=0) then W14_FieldEdited[13]:=True;
                     fallvel_Clay :=Conv;
                   End;
            End; {case}
          End; {else}
  UpdateScreen;
End;

procedure TWizbase14.ConvNumb(Sender: TObject);
Var Conv  : Double;
    Result: Integer;
    Txt: String;
Var PTSS: TSandSiltClay;
begin
  PTSS := WizStudy.SV.GetStatePointer(TSS,StV,WaterCol);
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
                     If (PTSS.LoadsRec.ConstLoad<>Conv) or (WizStatus=0) then W14_FieldEdited[1]:=True;
                     PTSS.InitialCond :=Conv;
                     PTSS.LoadsRec.ConstLoad := Conv;
                   End;
              'I': Begin
                     If (PTSS.InitialCond<>Conv) or (WizStatus=0) then W14_FieldEdited[1]:=True;
                     PTSS.InitialCond :=Conv;
                   End;
            End; {case}
          End; {else}
  UpdateScreen;
End;



procedure TWizBase14.EpiImportClick(Sender: TObject);
begin
  Table1.Active:=False;
  ImportForm.ChangeLoading('TSS in Water (mg/L)',Table1,False,False, CTNone);
  Table1.Active:=True;
  Update;
end;

Procedure TWizBase14.YesButtClick(Sender: TObject);
Var TSand,PTSS: TSandSiltClay;


Begin
  W14_YesNoClick := True;

  TSand := WizStudy.SV.GetStatePointer(Sand,StV,WaterCol);
  PTSS := WizStudy.SV.GetStatePointer(TSS,StV,WaterCol);

  If YesButt.Checked and (TSand<>nil) then
    With WizStudy.SV do
       Begin
         AtFree(GetIndex(sand,StV,WaterCol)); SetMemLocRec;
         AtFree(GetIndex(silt,StV,WaterCol)); SetMemLocRec;
         AtFree(GetIndex(clay,StV,WaterCol)); SetMemLocRec;
       End;

     If YesButt.Checked and (PTSS=nil) then WizStudy.AddStateVariable(TSS,WaterCol,0,True);

  If SSSButt.Checked and (PTSS<>nil) then
    With WizStudy.SV do
       Begin
         AtFree(GetIndex(TSS,StV,WaterCol));
         SetMemLocRec;
       End;

    If SSSButt.Checked and (TSand=nil) then
      Begin
        WizStudy.AddStateVariable(Sand,WaterCol,0,True);
        WizStudy.AddStateVariable(Silt,WaterCol,0,True);
        WizStudy.AddStateVariable(Clay,WaterCol,0,True);
      End;   

  If NoButt.Checked and (PTSS<>nil) then
    With WizStudy.SV do
      Begin
        AtFree(GetIndex(TSS,StV,WaterCol));
        SetMemLocRec;
      End;

  UpdateScreen;    
End;

end.
 