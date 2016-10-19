//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_15;

interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SV_IO,wizardbase, StdCtrls, ExtCtrls, WizGlobal, Db, DBTables, Global, AQUAOBJ;

Type
  TWizBase15 = class(TWizBase)
    SimBox: TListBox;
    AvailLabel: TLabel;
    InSimLabel: TLabel;
    RemoveButton: TButton;
    Table1: TTable;
    icpanel: TPanel;
    LabelICTop: TLabel;
    ICLabel: TLabel;
    ChemBox: TListBox;
    AddButton: TButton;
    MassLabel: TLabel;
    MassNumber: TLabel;
    ScrollBox1: TScrollBox;
    ICLabel1: TLabel;
    Edit1: TEdit;
    Label1: TLabel;
    ICLabel2: TLabel;
    Edit2: TEdit;
    ICLabel3: TLabel;
    Edit3: TEdit;
    ICLabel4: TLabel;
    Edit4: TEdit;
    ICLabel5: TLabel;
    Edit5: TEdit;
    ICLabel6: TLabel;
    Edit6: TEdit;
    ICLabel7: TLabel;
    Edit7: TEdit;
    ICLabel8: TLabel;
    Edit8: TEdit;
    ICLabel9: TLabel;
    Edit9: TEdit;
    ICLabel10: TLabel;
    Edit10: TEdit;
    ICLabel11: TLabel;
    Edit11: TEdit;
    ICLabel12: TLabel;
    Edit12: TEdit;
    ICLabel13: TLabel;
    Edit13: TEdit;
    ICLabel14: TLabel;
    Edit14: TEdit;
    ICLabel15: TLabel;
    Edit15: TEdit;
    ICLabel16: TLabel;
    Edit16: TEdit;
    ICLabel17: TLabel;
    Edit17: TEdit;
    ICLabel18: TLabel;
    Edit18: TEdit;
    ICLabel19: TLabel;
    Edit19: TEdit;
    ICLabel20: TLabel;
    Edit20: TEdit;
    ICLabel21: TLabel;
    Edit21: TEdit;
    ICLabel22: TLabel;
    Edit22: TEdit;
    ICLabel23: TLabel;
    Edit23: TEdit;
    ICLabel24: TLabel;
    Edit24: TEdit;
    ICLabel25: TLabel;
    Edit25: TEdit;
    ICLabel26: TLabel;
    Edit26: TEdit;
    ICLabel27: TLabel;
    Edit27: TEdit;
    ICLabel28: TLabel;
    Edit28: TEdit;
    ICLabel29: TLabel;
    Edit29: TEdit;
    ICLabel30: TLabel;
    Edit30: TEdit;
    ICLabel31: TLabel;
    Edit31: TEdit;
    ICLabel32: TLabel;
    Edit32: TEdit;
    ICLabel33: TLabel;
    Edit33: TEdit;
    ICLabel34: TLabel;
    Edit34: TEdit;
    ICLabel35: TLabel;
    Edit35: TEdit;
    ICLabel36: TLabel;
    Edit36: TEdit;
    ICLabel37: TLabel;
    Edit37: TEdit;
    ICLabel38: TLabel;
    Edit38: TEdit;
    ICLabel39: TLabel;
    Edit39: TEdit;
    ICLabel40: TLabel;
    Edit40: TEdit;
    ICLabel41: TLabel;
    Edit41: TEdit;
    ICLabel42: TLabel;
    Edit42: TEdit;
    ICLabel43: TLabel;
    Edit43: TEdit;
    ICLabel44: TLabel;
    Edit44: TEdit;
    ICLabel45: TLabel;
    Edit45: TEdit;
    ICLabel46: TLabel;
    Edit46: TEdit;
    ICLabel47: TLabel;
    Edit47: TEdit;
    ICLabel48: TLabel;
    Edit48: TEdit;
    ICLabel49: TLabel;
    Edit49: TEdit;
    ICLabel50: TLabel;
    Edit50: TEdit;
    ICLabel51: TLabel;
    Edit51: TEdit;
    ICLabel52: TLabel;
    Edit52: TEdit;
    ICLabel53: TLabel;
    Edit53: TEdit;
    ICLabel54: TLabel;
    Edit54: TEdit;
    ICLabel55: TLabel;
    Edit55: TEdit;
    ICLabel56: TLabel;
    Edit56: TEdit;
    ICLabel57: TLabel;
    Edit57: TEdit;
    ICLabel58: TLabel;
    Edit58: TEdit;
    ICLabel59: TLabel;
    Edit59: TEdit;
    ICLabel60: TLabel;
    Edit60: TEdit;
    ICLabel61: TLabel;
    Edit61: TEdit;
    ICLabel62: TLabel;
    Edit62: TEdit;
    ICLabel63: TLabel;
    Edit63: TEdit;
    ICLabel64: TLabel;
    Edit64: TEdit;
    ICLabel65: TLabel;
    Edit65: TEdit;
    ICLabel66: TLabel;
    Edit66: TEdit;
    ICLabel67: TLabel;
    Edit67: TEdit;
    ICLabel68: TLabel;
    Edit68: TEdit;
    ICLabel69: TLabel;
    Edit69: TEdit;
    ICLabel70: TLabel;
    Edit70: TEdit;
    ICLabel71: TLabel;
    Edit71: TEdit;
    ICLabel72: TLabel;
    Edit72: TEdit;
    ICLabel73: TLabel;
    Edit73: TEdit;
    ICLabel74: TLabel;
    Edit74: TEdit;
    ICLabel75: TLabel;
    Edit75: TEdit;
    ICLabel76: TLabel;
    Edit76: TEdit;
    ICLabel77: TLabel;
    Edit77: TEdit;
    ICLabel78: TLabel;
    Edit78: TEdit;
    ICLabel79: TLabel;
    Edit79: TEdit;
    ICLabel80: TLabel;
    Edit80: TEdit;
    ICLabel81: TLabel;
    Edit81: TEdit;
    ICLabel82: TLabel;
    Edit82: TEdit;
    ICLabel83: TLabel;
    Edit83: TEdit;
    ICLabel84: TLabel;
    Edit84: TEdit;
    ICLabel85: TLabel;
    Edit85: TEdit;
    ICLabel86: TLabel;
    Edit86: TEdit;
    ICLabel87: TLabel;
    Edit87: TEdit;
    ICLabel88: TLabel;
    Edit88: TEdit;
    ICLabel89: TLabel;
    Edit89: TEdit;
    ICLabel90: TLabel;
    Edit90: TEdit;
    ICLabel91: TLabel;
    Edit91: TEdit;
    ICLabel92: TLabel;
    Edit92: TEdit;
    ICLabel93: TLabel;
    Edit93: TEdit;
    ICLabel94: TLabel;
    Edit94: TEdit;
    ICLabel95: TLabel;
    Edit95: TEdit;
    ICLabel96: TLabel;
    Edit96: TEdit;
    ICLabel97: TLabel;
    Edit97: TEdit;
    ICLabel98: TLabel;
    Edit98: TEdit;
    ICLabel99: TLabel;
    Edit99: TEdit;
    ICLabel100: TLabel;
    Edit100: TEdit;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure SimBoxClick(Sender: TObject);
    procedure RemoveButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure ConvNumber(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure UpdateChems;
    Function  ExecuteScreen: WizOutput; override;
    Procedure UpdateScreen; virtual;
    { Public declarations }
  end;

Const NumFields = 100;
var
  WizBase15: TWizBase15;


implementation

{$R *.DFM}

Procedure TWizBase15.UpdateChems;
Var IndexLoop: AllVariables;
Begin
  W15_NumChems := 0;
  For IndexLoop := FirstOrgTox to LastOrgTox do
    If WizStudy.SV.GetStatePointer(IndexLoop,StV,WaterCol)<>nil then
      Begin
        Inc(W15_NumChems);
        W15_ChemsInStudy[W15_NumChems] := IndexLoop;
      End;
End;

Procedure TWizBase15.UpdateScreen;
Var RecNum,Loop: Integer;
    PTox : TToxics;
    CheckLoop, ThisChem: AllVariables;
    ThisChemTyp: T_SVType;
    ThisIC: TStateVariable;
    NameL,UnitL : TLabel;
    EditBox: TEdit;
    LName, ChemName: String;
    SumToxMass, CheckZero: Double;
    TLoop: AlLVariables;
    SegVolume: Double;


Begin
  ICPanel.Visible := (W15_Screen>0);

  If (W15_Screen=0) then
    Begin
      MainPanel.Visible := True;
      ICPanel.Visible := False;

      If not RenameFile(Default_dir+'\Chemical.CDB',Default_dir+'\Chemical.DB') then Exit;
      Table1.DataBaseName:=Default_Dir;
      Table1.TableName:='Chemical.DB';
      Try
         ChemBox.Items.Clear;
         Table1.Active:=True;
         With Table1 do
           begin
              First;
              RecNum:=RecordCount;
              If RecNum>0 then
                 For Loop:=1 to RecNum do
                     begin
                       ChemBox.Items.Add(Fields[0].AsString);
                       Next;
                     end; {for do}

          end; {with}
      Except
      End;

      Table1.Active:=False;
      RenameFile(Default_dir+'\Chemical.DB',Default_dir+'\Chemical.CDB');

      RemoveButton.Enabled := False;
      AddButton.Enabled := False;
      SimBox.Items.Clear;

      UpdateChems;
      If W15_NumChems>0 then
        For Loop := 1 to W15_NumChems do
          Begin
            PTox := WizStudy.SV.GetStatePointer(W15_ChemsInStudy[Loop],StV,WaterCol);
            SimBox.Items.Add(PTox.PName^);
          End;
    End;  {W15_Screen=0}

  If W15_Screen>0 then
    Begin
      MainPanel.Visible := False;
      ICPanel.Visible := True;
      ThisChem := W15_ChemsInStudy[W15_Screen];
      ThisChemTyp := AssocToxTyp(ThisChem);
      ChemName := WizStudy.SV.ChemPtrs^[ThisChemTyp].Chemrec.ChemName;

      PTox := WizStudy.SV.GetStatePointer(ThisChem,StV,WaterCol);
      LabelICTop.Caption := 'Step 15: Initial Condition: '+PTox.PName^;

      W15_InitConds[1] := ThisChem;
      W15_NumICs := 1;
      For CheckLoop := Ammonia to pH do
        Begin
          ThisIC := WizStudy.SV.GetStatePointer(CheckLoop,ThisChemTyp,WaterCol);
          If (ThisIC<>nil) and (not (CheckLoop in [DissLabDetr..SuspLabDetr]))
            then
              Begin
                Inc(W15_NumICs);
                W15_InitConds[W15_NumICs] := CheckLoop;
              End;
        End;  {For CheckLoop}

        ICLabel1.Caption := ChemName+' In Water';
        Label1.Caption := 'ug/L';
        PTox := WizStudy.SV.GetStatePointer(ThisChem,StV,WaterCol);
        Edit1.Text := FloatToStrF(PTox.InitialCond,ffgeneral,9,4);

        For Loop := 2 to 100 do
          Begin
            LName := 'ICLabel'+IntToStr(Loop);
            NameL := TLabel(WizBase15.FindComponent(LName));
            LName := 'Label'+IntToStr(Loop);
            UnitL := TLabel(WizBase15.FindComponent(LName));
            LName := 'Edit'+IntToStr(Loop);
            EditBox := TEdit(WizBase15.FindComponent(LName));

            If Loop>W15_NumICs
              then
                Begin
                  NameL.Visible := False;
                  UnitL.Visible := False;
                  EditBox.Visible := False;
                End
              else
                Begin
                  NameL.Visible := True;
                  UnitL.Visible := True;
                  EditBox.Visible := True;
                  PTox := WizStudy.SV.GetStatePointer(W15_InitConds[Loop],ThisChemTyp,WaterCol);
                  If W15_InitConds[Loop]=DissRefrDetr
                    then NameL.Caption := 'T'+IntToStr(Ord(ThisChemTyp)-1) + ' in Susp and Diss Detritus'
                    else NameL.Caption := 'T'+IntToStr(Ord(ThisChemTyp)-1) + ' in '+OutputText(W15_InitConds[Loop],StV,WaterCol,WizStudy.SV.UniqueName(W15_InitConds[Loop]),False,False,0);
                  UnitL.Caption := PTox.StateUnit;
                  EditBox.Text := FloatToStrF(PTox.InitialCond,ffgeneral,9,4);
                End;

          End; {For loop}

        ScrollBox1.VertScrollBar.Range := 15 + 27*W15_NumICs;


        With WizStudy.SV do
          Begin
            CopySuspDetrData;
            SetStateToInitConds(FALSE);
            SegVolume := TStateVariable(GetStatePointer(Volume,StV,WaterCol)).InitialCond;
            SumToxMass := 0.0;
            CheckZero := GetState(ThisChem,StV,WaterCol);
            If CheckZero > Tiny then
              Begin
                SumToxMass := CheckZero * SegVolume * 1000.0 * 1e-9;
                   {kg}         {ug/L}       {m3}     {L/m3}  {kg/ug}
              End;

            For TLoop:= SedmRefrDetr to LastAnimal do
             If TLoop in [SedmRefrDetr..SuspLabDetr,FirstBiota..LastBiota] then
               begin
                 CheckZero := GetState(TLoop,ThisChemTyp,WaterCol);
                 If CheckZero > Tiny then
                   Begin
                     SumToxMass := SumToxMass + CheckZero * SegVolume * 1000.0 * 1e-9;
                        {kg}                      {ug/L}      {m3}      {L/m3}  {kg/ug}
                   End;
               end;
             For TLoop:= BuriedRefrDetr to BuriedLabileDetr  do
               begin
                 CheckZero := GetState(TLoop,ThisChemTyp,WaterCol);
                 If CheckZero > Tiny then
                   Begin
                     SumToxMass := SumToxMass + CheckZero * SedLayerArea * 1e-9
                      {kg}           {kg}         {ug/m2}        {m2}      {kg/ug}
                   End;
               end;
          End;

        MassLabel.Caption  := 'Total Initial Condition Mass of '+ ChemName +':';
        MassNumber.Caption := FloatToStrF(SumToxMass,ffGeneral,6,4) +' kg';

    End; {W15_Screen>0}

End;


Function  TWizBase15.ExecuteScreen: WizOutput;
Begin
  If FirstVisit then W15_DataChanged := False;

  UpdateChems;

  If JumpIn = WzBack then W15_Screen := W15_NumChems
                     else W15_Screen := 0;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) then WizStatus := 2;
  If (WizStatus=1) and (W15_DataChanged) then WizStatus := 2;

End;



procedure TWizBase15.NextButtonClick(Sender: TObject);
begin
  Scrollbox1.VertScrollBar.Position := 0;
  If W15_Screen<W15_NumChems
    then
      Begin
        Inc(W15_Screen);
        UpdateScreen;
      End
    else inherited;
end;


procedure TWizBase15.BackButtonClick(Sender: TObject);
begin
  Scrollbox1.VertScrollBar.Position := 0;
  If W15_Screen>0
    then
      Begin
        Dec(W15_Screen);
        UpdateScreen;
      End
    else inherited;
end;

procedure TWizBase15.SimBoxClick(Sender: TObject);
begin
  RemoveButton.Enabled := SimBox.ItemIndex>-1;
  AddButton.Enabled := ChemBox.ItemIndex>-1;
end;

procedure TWizBase15.RemoveButtonClick(Sender: TObject);
Var DeleteVar: AllVariables;
Begin
  If SimBox.ItemIndex=-1 then exit;

  W15_DataChanged := True;
  DeleteVar := W15_ChemsInStudy[SimBox.Itemindex+1];
  WizStudy.Remove_OrgTox_SVs(DeleteVar);
  UpdateScreen;
  RemoveButton.Enabled := False;


End;



procedure TWizBase15.AddButtonClick(Sender: TObject);
Var NewIndex: AllVariables;
    NewPSV  : TStateVariable;
    FileN,Entry   : String;
    ToxAddLoop : StateVariables;
    p          : Pointer;
    ToxType    : T_SVType;

begin
  If ChemBox.ItemIndex<0 then Exit;
  W15_DataChanged := True;
  AddButton.Enabled := False;
  FileN := 'Chemical.CDB';

  With WizStudy do
    Begin
      If SimBox.Items.Count=20 then
        Begin
          MessageDlg('AQUATOX cannot model over twenty organic chemicals.',MTError,[MBOK],0);
          Exit;
        End;

      NewIndex := H2OTox1;
      While SV.GetStatePointer(NewIndex,StV,WaterCol)<>nil do
        Inc(NewIndex);

      ToxType := AssocToxTyp(NewIndex);
      If PChems[ToxType]<>nil then PChems[ToxType].Destroy;
      PChems[ToxType] := TChemical.Init;

      {Load Chemical}
      Entry := ChemBox.Items[ChemBox.ItemIndex];
      DBase_To_ChemRecord(Default_Dir,FileN,Entry,-1,PChems[ToxType].ChemRec);
      SV.ChemPtrs^[ToxType].Dbase_To_AnimToxColl(Default_Dir+'ChemToxDBs\',Entry+'_Animal_Tox.DB');
      SV.ChemPtrs^[ToxType].Dbase_To_PlantToxColl(Default_Dir+'ChemToxDBs\',Entry+'_Plant_Tox.DB');

      AddStateVariable(NewIndex,WaterCol,0,True);
      SV.SetMemLocRec;
      NewPSV :=WizStudy.SV.GetStatePointer(NewIndex,StV,WaterCol);

      PChems[ToxType].ChangeData;
      NewPSV.PHasData^:=True;

      {For each state variable, add associated toxicant if relevant}
      For ToxAddLoop := FirstState to LastState do
         Begin
           p := SV.GetStatePointer(ToxAddLoop,StV,WaterCol);
           If p<>nil then AddOrgToxStateVariable(ToxAddLoop,WaterCol,ToxType,True);
         End;

      SV.SetMemLocRec;
    End; {with}
  UpdateScreen;
End;


procedure TWizBase15.ConvNumber(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update W15_Screen}
Var Conv  : Double;
    Result: Integer;
    Txt: String;
    EditNum: Integer;
    EditName: String;
    ThisChem,ThisVar: AllVariables;
    ThisChemTyp: T_SVType;
    PTox: TToxics;
Begin
  Txt :=TEdit(Sender).Text;
  If Trim(Txt)='' then Txt :='0';
  Val(Txt,Conv,Result);
  Conv:=Abs(Conv);
  If (Result<>0)
    then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
    else
      Begin
        W15_DataChanged := True;
        EditName := TEdit(Sender).Name;
        If Length(EditName)<6 then EditNum := StrToInt(EditName[5])
                              else EditNum := StrToInt(EditName[5]+EditName[6]);
        ThisVar := W15_InitConds[EditNum];
        ThisChem := W15_ChemsInStudy[W15_Screen];
        ThisChemTyp := AssocToxTyp(ThisChem);

        If EditNum=1
          then PTox := WizStudy.SV.GetStatePointer(ThisChem,StV,WaterCol)
          else PTox := WizStudy.SV.GetStatePointer(ThisVar,ThisChemTyp,WaterCol);

        If ThisVar=DissRefrDetr
          then
            Begin
              TDissRefrDetr(WizStudy.SV.GetStatePointer(ThisVar,StV,WaterCol)).InputRecord.ToxInitCond[ThisChemTyp] := Conv;
              WizStudy.SV.CopySuspDetrData;
            End
          else PTox.InitialCond := Conv;
      End;

  UpdateScreen;
End;

end.
