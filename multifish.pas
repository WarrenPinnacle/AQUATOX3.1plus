//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit MultiFish;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, OleCtrls, StdCtrls, Buttons, Aquaobj, Global,
  CalcDist, DB, DBTables, TeEngine, Series, TeeProcs, Chart, ActnList,
  Grids, TeeFunci, SV_IO, TCollect, MigrEdit, AQBaseForm, hh;

type
  namestring = String[45];

type
  TMultFishForm = class(TAQBase)
    TabControl1: TTabControl;
    Chart1: TChart;
    Series1: TAreaSeries;
    DistPanel: TPanel;
    Label2: TLabel;
    TriButton: TRadioButton;
    UniButton: TRadioButton;
    NormButton: TRadioButton;
    LogNormButton: TRadioButton;
    CancelBtn: TBitBtn;
    ParmPanel: TPanel;
    Label3: TLabel;
    p1label: TLabel;
    p2label: TLabel;
    p3label: TLabel;
    p4label: TLabel;
    Parm1Edit: TEdit;
    Parm2Edit: TEdit;
    Parm3Edit: TEdit;
    Parm4Edit: TEdit;
    ErrorPanel: TPanel;
    Panel5: TPanel;
    Label5: TLabel;
    Label4: TLabel;
    OKBtn: TBitBtn;
    UseDistPanel: TPanel;
    UseDistButt: TRadioButton;
    UserDefinedButt: TRadioButton;
    YOYButton: TButton;
    OlderFishButton: TButton;
    Panel6: TPanel;
    Label1: TLabel;
    notes2: TEdit;
    notes1: TEdit;
    ValuePanel: TPanel;
    StringGrid1: TStringGrid;
    ValueTitle: TLabel;
    ParmError: TLabel;
    TeeFunction1: TAddTeeFunction;
    HeaderLabel: TLabel;
    ChemPanel: TPanel;
    ToxComboBox: TComboBox;
    Label10: TLabel;
    NoToxPanel: TPanel;
    YOYTrophic: TButton;
    OlderTrophic: TButton;
    GenPanelBack: TPanel;
    GeneralPanel: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SpawnAgeEdit: TEdit;
    NameEdit: TEdit;
    HideGraphPanel: TPanel;
    YOYMigrButt: TButton;
    OlderMigrButt: TButton;
    HelpButton: TButton;
    Panel1: TPanel;
    ViewGraph: TRadioButton;
    ViewValues: TRadioButton;
    LoadYOY: TButton;
    LoadOlder: TButton;
    procedure VerifyNumber(Sender: TObject);
    procedure RetHandleClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure Parm4EditKeyPress(Sender: TObject; var Key: Char);
    procedure TriButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ViewGraphClick(Sender: TObject);
    procedure notes1Exit(Sender: TObject);
    procedure notes2Exit(Sender: TObject);
    procedure UseDistButtMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ViewGraphMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid1Exit(Sender: TObject);
    procedure ToxComboBoxChange(Sender: TObject);
    procedure YOYButtonClick(Sender: TObject);
    procedure YOYTrophicClick(Sender: TObject);
    procedure OlderTrophicClick(Sender: TObject);
    procedure NameEditChange(Sender: TObject);
    procedure YOYMigrButtClick(Sender: TObject);
    procedure OlderMigrButtClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure LoadYOYClick(Sender: TObject);
    procedure LoadOlderClick(Sender: TObject);
  private
    procedure updatescreen;
    procedure updategraph;
    procedure updatevalues;
    { Private declarations }
  public
    YOYEdited: Boolean;
    OlderEdited: Boolean;
    Changed: Boolean;
    LinkedMod: Boolean;
    LinkedS, ThisAQTS: Pointer;
    Function EditFish(P: TStateVariable; Var MAFI: MultiAgeFishInput;LS,TAQTS: Pointer): Boolean;
    { Public declarations }
  end;

Type PAgeDist = ^AgeDist;
var
  MultFishForm : TMultFishForm;
  TempMAFI     : MultiAgeFishInput;
  CurrentTox   : AllVariables;
  CurrentDist  : PAgeDist;
  SelTox       : Array[0..20] of AllVariables;
  YOYRecord, OlderRecord : ZooRecord;
  YOYTroph,  OlderTroph  : TrophIntArray;
  SV           : TStates;
  YOYMigr, OlderMigr: MigrInputType;

implementation

uses Animal, trophint, DBENTRY;

{$R *.DFM}

Function TMultFishForm.EditFish(P: TStateVariable; Var MAFI: MultiAgeFishInput; LS,TAQTS: Pointer): Boolean;
     {--------------------------------------------------------}
     Procedure CompareAgeDist(Var M1, M2: AgeDist);
     Var Loop: Integer;
     Begin
       If M1.UserDefined <> M2.UserDefined then Changed := True;
       If M1.DType <> M2.DType then Changed := True;
       For Loop := 1 to 4 do
         If M1.Parm[Loop] <> M2.Parm[Loop] then Changed := True;
       For Loop := 1 to 15 do
         If M1.Vals[Loop] <> M2.Vals[Loop] then Changed := True;
       If M1.LoadNotes1 <> M2.LoadNotes1 then Changed := True;
       If M1.LoadNotes2 <> M2.LoadNotes2 then Changed := True;
     End;
     {--------------------------------------------------------}
     Procedure SetupToxComboBox;
     Var ToxLoop: AllVariables;
         NumToxs: Integer;
     Begin
        NumToxs    := 0;
        CurrentTox := NullStateVar;
        ToxComboBox.Items.Clear;
        For ToxLoop := FirstOrgTox to LastOrgTox do
          Begin
            If P.AllStates.GetIndex(P.nstate,AssocToxTyp(ToxLoop),WaterCol) > -1 then
              Begin
                SelTox[NumToxs] := ToxLoop;                                    
                Inc(NumToxs);
                ToxComboBox.Items.Add(P.ChemPtrs^[AssocToxTyp(ToxLoop)].ChemRec.ChemName);
                If CurrentTox = NullStateVar then CurrentTox := ToxLoop;
              End;
          End;
        ToxComboBox.ItemIndex := 0;
     End;
     {--------------------------------------------------------}
Var OrgLoop: T_SVType;
    P2: TAnimal;
Begin                                                        
  LinkedS := LS;
  ThisAQTS := TAQTS;
  YOYEdited := False;
  OlderEdited := False;

//  If Height > Screen.WorkAreaHeight then Height := Screen.WorkAreaHeight;
{  Width := Screen.Width;
  Height := Screen.Height-30; }
  HeaderLabel.Caption := P.PName^;

  EditFish := False;
  YOYRecord   := TAnimal(P).PAnimalData^;
  YOYTroph    := TAnimal(P).PTrophInt^;
  YOYMigr     := TAnimal(P).MigrInput;
  LinkedMod   := P.AllStates.LinkedMode;
  P2 := P.GetStatePointer(Fish2,StV,WaterCol);
  OlderRecord := P2.PAnimalData^;
  OlderTroph  := P2.PTrophInt^;
  OlderMigr   := P2.MigrInput;

  SV := P.AllStates;

  TempMAFI := MAFI;
  SetupToxComboBox;
  UpdateScreen;
  Changed := False;

  If ShowModal = MrCancel then
    Begin
      Changed := False;
      Exit;
    End;

  EditFish := True;

  If MAFI.PNumAges  <> TempMAFI.PNumAges  then Changed:=True;
  If MAFI.PSpawnAge <> TempMAFI.PSpawnAge then Changed:=True;
  If MAFI.PName^     <>TempMAFI.PName^      then Changed:=True;

  CompareAgeDist(MAFI.InitCond,TempMAFI.InitCond);
  CompareAgeDist(MAFI.Loadings,TempMAFI.Loadings);
  For OrgLoop := FirstOrgTxTyp to LastOrgTxTyp do
    Begin
      CompareAgeDist(MAFI.ChemIC[OrgLoop],TempMAFI.ChemIC[OrgLoop]);
      CompareAgeDist(MAFI.ChemLoad[OrgLoop],TempMAFI.ChemLoad[OrgLoop]);
    End;
  CompareAgeDist(MAFI.PLipidFrac^,TempMAFI.PLipidFrac^);
  CompareAgeDist(MAFI.PMortCoeff^,TempMAFI.PMortCoeff^);
  CompareAgeDist(MAFI.PMeanWeight^,TempMAFI.PMeanWeight^);

  MAFI := TempMAFI;
  TAnimal(P).PAnimalData^ := YOYRecord;
  TAnimal(P).PTrophInt^   := YOYTroph;
  TAnimal(P).MigrInput    := YOYMigr;
  P.PHasData^ := P.PHasData^ or YOYEdited;

  P2 := P.GetStatePointer(Fish2,StV,WaterCol);
  P2.PHasData^    := P2.PHasData^ or OlderEdited;
  P2.PAnimalData^ := OlderRecord;
  P2.PTrophInt^   := OlderTroph;
  P2.MigrInput    := OlderMigr;

  P.PName^ := HeaderLabel.Caption;
  SV.CopyMultiFishData;
End;


Procedure TMultFishForm.UpdateValues;
Var NumValues,Loop: Integer;
Begin
  NumValues:=TempMAFI.PNumAges^;
  With StringGrid1 do
    Begin
      RowCount:=NumValues+1;
      ColWidths[0]:=70;
      ColWidths[1]:=90;
      Cols[0].Clear;
      Cols[0].Add('Fish Age:');
      Cols[0].Add(' < 1');
      For Loop := 2 to NumValues do
        Cols[0].Add(IntToStr(Loop-1)+' to '+IntToStr(Loop));
      Cols[1].Clear;
      Cols[1].Add('Value:');
      For Loop := 1 to NumValues do
        Cols[1].Add(FloatToStrF(CurrentDist.Vals[Loop],fffixed,7,6));
    End;
End;

Procedure TmultFishForm.UpdateGraph;
Var Val,LastVal,TempVal: Double;
    XVal: Double;
    NumValues,Loop: Integer;
    GraphError: Boolean;
    NewSeries: TAreaSeries;
Begin
  TRY
    With Chart1 do With CurrentDist^ do
    begin
      NumValues:=TempMAFI.PNumAges^;

      While Chart1.SeriesCount>0 do Chart1.Series[0].Free;
      NewSeries := TAreaSeries.Create(Chart1);
      NewSeries.SeriesColor := ClNavy;

      GraphError:=False;

      XVal:=0;
      LastVal:=0;
      Case DType of
           Normal:     LastVal:=cdfNormal(XVal,Parm[1],Parm[2])*Parm[3];
           LogNormal:  LastVal:=cdfLogNormal(XVal,exp(Parm[1]),exp(Parm[2]))*Parm[3];
      End; {Case}

      For Loop:=1 to NumValues do
        begin
          XVal := Loop;
          Val  := 0;

          If UserDefined
            then Val := Vals[Loop]
            else
              Begin
                 Case DType of
                       Triangular: Val:=cdfTriangular(XVal,0,NumValues,Parm[1]) ;
                       Normal:     Val:=cdfNormal(XVal,Parm[1],Parm[2]);
                       LogNormal:  Val:=cdfLogNormal(XVal,exp(Parm[1]),exp(Parm[2]));
                       Uniform:    Val:=Parm[1];
                  end;

                  If Not (Val=Error_Value) then
                  Case DType of
                       Triangular: Val:= Val * Parm[2];
                       Normal:     Val:= Val * Parm[3];
                       LogNormal:  Val:= Val * Parm[3];
                       Uniform:    Val:= Parm[1];
                  end;

                  TempVal:=Val;
                  If Not ((Val=Error_value) or (DType=Uniform)) then Val:=Val-LastVal;
                  LastVal:=TempVal;

                  Vals[Loop] := RoundDec(4,Val);
                End; {not user defined}

            If Val=error_value
              then Begin
                     GraphError:=True;
                     Vals[Loop] := 0;
                   End
              else NewSeries.AddXY(XVal,Val,'',clteecolor);
         End; {loop}

      ErrorPanel.Visible := GraphError;
      ParmError.Visible  := GraphError;

      IF UserDefined then begin
                            ErrorPanel.Visible := False;
                            ParmError.Visible  := False;
                          end;

      AddSeries(NewSeries);

    End; {With Chart1}

  EXCEPT
    ErrorPanel.Visible:=True;
  END;

End;

procedure TMultFishForm.UpdateScreen;
Var ThisDist: PAgeDist;
    TitleStr: String;
    CurrentToxTyp: T_SVType;
    GeneralSelect: Boolean;
    ToxStr       : String;
Begin
 YOYMigrButt.Visible   := LinkedMod;
 OlderMigrButt.Visible := LinkedMod;

 If (CurrentTox=NullStateVar)
   Then CurrentToxTyp := OrgTox1
   Else CurrentToxTyp := AssocToxTyp(CurrentTox);

 ToxStr := ToxComboBox.Items.Strings[ToxComboBox.ItemIndex];
 GeneralSelect:=False;
 Case TabControl1.TabIndex of
   0:   GeneralSelect:=True;
   1:   TitleStr:= 'Initial Condition (g/sq.m dry)';
   2:   TitleStr:= 'Loadings (g/sq.m dry)';
   3:   TitleStr:= 'Init Cond. Tox Exposure of '+ ToxStr +' (ug/kg)';
   4:   TitleStr:= 'Tox Exposure of '+ ToxStr +' in Loadings (ug/kg)';
   5:   TitleStr:= 'Lipid (fraction wet wt.)';
   6:   TitleStr:= 'Mortality Coefficient (1/d)';
   else TitleSTr:= 'Mean Wet Weight (g wet)';
 end; {Case}

 NameEdit.Text := TempMAFI.PName^;
 SpawnAgeEdit.Text := FloatToStrF(TempMAFI.PSpawnAge^,ffGeneral,15,4);

 GenPanelBack.Visible := GeneralSelect;
 UseDistPanel.Visible := not GeneralSelect;

 ValueTitle.Caption := TitleStr;
 Chart1.LeftAxis.Title.Caption := TitleStr;

 ChemPanel.Visible  := (TabControl1.TabIndex=3) or (TabControl1.TabIndex=4);
 NoToxPanel.Visible := (CurrentTox=NullStateVar) and (ChemPanel.Visible);
 NoToxPanel.BringToFront;
 GenPanelBack.BringToFront;

 Case TabControl1.TabIndex of
   1:   ThisDist := @TempMAFI.InitCond;
   2:   ThisDist := @TempMAFI.Loadings;
   3:   ThisDist := @TempMAFI.ChemIC[CurrentToxTyp];
   4:   ThisDist := @TempMAFI.ChemLoad[CurrentToxTyp];
   5:   ThisDist := @TempMAFI.PLipidFrac^;
   6:   ThisDist := @TempMAFI.PMortCoeff^;
   else ThisDist := @TempMAFI.PMeanWeight^;
 end; {Case}

 CurrentDist := ThisDist;

 ValuePanel.Visible := ViewValues.Checked and (not GeneralSelect);
 HideGraphPanel.Visible := ValuePanel.Visible;
 UseDistButt.Checked := not ThisDist.UserDefined;
 UserDefinedButt.Checked := ThisDist.UserDefined;

 Notes1.Text := ThisDist.LoadNotes1;
 Notes2.Text := ThisDist.LoadNotes2;

 DistPanel.Visible := (Not ThisDist.UserDefined) and (not GeneralSelect);
 ParmPanel.Visible := (Not ThisDist.UserDefined) and (not GeneralSelect);
 If ThisDist.UserDefined then StringGrid1.Options := StringGrid1.Options + [GOEditing]
                          else StringGrid1.Options := StringGrid1.Options - [GOEditing];

 If Not ThisDist.UserDefined then
   With ThisDist^ do
    Begin
      Case DType of
        Triangular: begin
                      TriButton.Checked:=True;
                      P1Label.Caption:='Most Likely';
                      P2Label.Caption:='Y Scale';
                      P3Label.Caption:='<unused>';
                      P4Label.Caption:='<unused>';
                    end;
        Normal    : begin
                      NormButton.Checked:=True;
                      P1Label.Caption:='Mean';
                      P2Label.Caption:='Std. Deviation';
                      P3Label.Caption:='Y Scale';
                      P4Label.Caption:='<unused>';
                    end;
        LogNormal : begin
                      LogNormButton.Checked:=True;
                      P1Label.Caption:='Mean';
                      P2Label.Caption:='Std. Deviation';
                      P3Label.Caption:='Y Scale';
                      P4Label.Caption:='<unused>';
                    end;
        Uniform   : begin
                      UniButton.Checked:=True;
                      P1Label.Caption:='Y Value';
                      P2Label.Caption:='<unused>';
                      P3Label.Caption:='<unused>';
                      P4Label.Caption:='<unused>';
                    end;
        End; {Case}            

        If P2Label.Caption='<unused>'
          then Begin
                 P2Label.Visible:=False;
                 Parm2Edit.Visible:=False;
               End
          else Begin
                 P2Label.Visible:=True;
                 Parm2Edit.Visible:=True;
               End;

        If P3Label.Caption='<unused>'
          then Begin
                 P3Label.Visible:=False;
                 Parm3Edit.Visible:=False;
               End
          else Begin
                 P3Label.Visible:=True;
                 Parm3Edit.Visible:=True;
               End;

        If P4Label.Caption='<unused>'
          then Begin
                 P4Label.Visible:=False;
                 Parm4Edit.Visible:=False;
               End
          else Begin
                 P4Label.Visible:=True;
                 Parm4Edit.Visible:=True;
               End;

        Parm1Edit.Text:=' '+FloatToStrF(Parm[1],ffGeneral,15,4);
        Parm2Edit.Text:=' '+FloatToStrF(Parm[2],ffGeneral,15,4);
        Parm3Edit.Text:=' '+FloatToStrF(Parm[3],ffGeneral,15,4);
        Parm4Edit.Text:=' '+FloatToStrF(Parm[4],ffGeneral,15,4);
      End;

  UpdateGraph;
  UpdateValues;

  update;
End;

procedure TMultFishForm.VerifyNumber(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update screen}
Var
Conv: Double;
Result: Integer;

begin
  Val(Trim(TEdit(Sender).Text),Conv,Result);
  If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
               else begin
                      case TEdit(Sender).Name[5] of
                         '1': CurrentDist.Parm[1]:=Abs(Conv);
                         '2': CurrentDist.Parm[2]:=Abs(Conv);
                         '3': CurrentDist.Parm[3]:=Abs(Conv);
                         '4': CurrentDist.Parm[4]:=Abs(Conv);
                         'n': TempMAFI.PSpawnAge^   := Abs(Conv);
                       end; {case}
                     end;
  UpdateScreen;
end;

procedure TMultFishForm.RetHandleClick(Sender: TObject);
begin
  UpdateScreen;
end;

procedure TMultFishForm.OKBtnClick(Sender: TObject);
begin
  ModalResult:=MrOK
end;

procedure TMultFishForm.CancelClick(Sender: TObject);
begin
  If MessageDlg('Discard all changes, including underlying data?',mtConfirmation,[mbOK,MbCancel],0)
          = MrOK then ModalResult:=MrCancel;

end;

procedure TMultFishForm.Parm4EditKeyPress(Sender: TObject; var Key: Char);
begin
   If (Key=#13) then VerifyNumber(sender);
end;

procedure TMultFishForm.TriButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  With CurrentDist^ do
    If      TriButton.Checked  then DType:=Triangular
    else if NormButton.Checked then DType:=Normal
    else if UniButton.Checked  then DType:=Uniform
    else                            DType:=Lognormal;
  UpdateScreen;
end;

procedure TMultFishForm.ViewGraphClick(Sender: TObject);
begin
  UpdateScreen;
end;

procedure TMultFishForm.notes1Exit(Sender: TObject);
begin
  CurrentDist.LoadNotes1 := Notes1.Text;
end;

procedure TMultFishForm.notes2Exit(Sender: TObject);
begin
  CurrentDist.LoadNotes2 := Notes2.Text;
end;

procedure TMultFishForm.UseDistButtMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CurrentDist.UserDefined := Not UseDistButt.Checked;
  UpdateScreen;
end;

procedure TMultFishForm.ViewGraphMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  UpdateScreen;
end;

procedure TMultFishForm.StringGrid1KeyPress(Sender: TObject;
  var Key: Char);
Var i : Integer;
    Value: Extended;
begin
  If not (Word(Key) in [VK_Return,VK_Tab,VK_Up,VK_Down]) then exit;

  For i := 1 to TempMAFI.PNumAges^ do
    Begin
      Try
        Value := StrToFloat(Trim(StringGrid1.Cells[1,i]));
      Except
        Raise EAquatoxError.Create(StringGrid1.Cells[1,i]+' is not a valid number.');
      End;
      CurrentDist.Vals[i] := Value;
    End;

end;

procedure TMultFishForm.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
Var Key: Char;
begin
  Key := Char(VK_Return);
  StringGrid1KeyPress(Sender, Key);
end;

procedure TMultFishForm.StringGrid1Exit(Sender: TObject);
Var Key: Char;
begin
  Key := Char(VK_Return);
  StringGrid1KeyPress(Sender, Key);
end;

procedure TMultFishForm.ToxComboBoxChange(Sender: TObject);
begin
   CurrentTox:=SelTox[ToxComboBox.ItemIndex];
   UpdateScreen;
end;

procedure TMultFishForm.YOYButtonClick(Sender: TObject);
Var PAR: ^ZooRecord;
    ToxLoop  : T_SVType;
    PC : TCollection;
    loop, loop2: Integer;
    PAT: TAnimalToxRecord;
    ItemFound: Boolean;
    RecordName: String;
    MR: TModalResult;
begin
  If TButton(Sender).Name='YOYButton'
    then PAR:=@YOYRecord
    else PAR:=@OlderRecord;

  Application.CreateForm(TEdit_Animal, Edit_Animal);
    With Edit_Animal.Table2 do
      begin
        Active:=False;
        DatabaseName:=program_dir;
        IndexFieldNames := '';    // 2/12/2010 allow sorting by trophic level
        TableName:='ANIMFORM.DB';
        EmptyTable;

{       Active:=True;
        Append;
        Fields[0].AsString:='Holder';
        Post;
        Active:=False;  }

        If not AnimalRecord_to_Dbase(program_dir,'ANIMFORM.DB',PAR^.AnimalName,PAR^,False) then
               Begin
                  MessageDlg('AQUATOX ERROR- Animal Record Not Loading',mterror,[mbOK],0);
                  Edit_Animal.Free;
                  Exit;
               End;
        Edit_Animal.DbNavigator1.Visible:=False;
        Edit_Animal.CancelButton.Visible:=False;
        Edit_Animal.FindButton.Visible:=False;

        If TButton(Sender).Name='YOYButton'
          then Edit_Animal.TrophIntPtr := @(YOYTroph)
          else Edit_Animal.TrophIntPtr := @(OlderTroph);

        Edit_Animal.NewButton.Visible:=False;
        Edit_Animal.SaveButton.Caption:='&OK';
//        Edit_Animal.LoadButton.Visible:=True;
        Edit_Animal.SaveLib.Visible:=False;
        Edit_Animal.MultiFish := True;
        Edit_Animal.YOYFish := TButton(Sender).Name='YOYButton';

        If TButton(Sender).Name='YOYButton'               {11-20-2001}
          then Edit_Animal.TrophIntPtr := @YOYTroph
          else Edit_Animal.TrophIntPtr := @OlderTroph;

        Edit_Animal.SpeciesDataButton.Visible:=False;
        Edit_Animal.SVPtr:=SV;
        Edit_Animal.SpecPtr := nil;
        Active:=True;

        For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
         {Add additional toxicity fields to Edit_Animal ToxComboBox items}
         If SV.GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol)<>nil then
          Begin
            PC := SV.ChemPtrs^[ToxLoop].Anim_Tox;
            With Edit_Animal.ToxComboBox do
             For loop := 0 to PC.Count-1 do
              Begin
                ItemFound:=False;
                PAT := PC.At(loop);
                For loop2 := 0 to Items.Count-1 do
                  If Lowercase(Items.Strings[loop2]) =
                     Lowercase(PAT.Animal_Name) then ItemFound:=True;
                If Not ItemFound then Items.Append(PAT.Animal_Name);
              End;
          End;

        MR:=Edit_Animal.ShowModal;
        If (MR<>MRCancel) and (Edit_Animal.Changed) then Changed:=True;
        RecordName:=Fields[0].AsString;
    End; {with}
  Edit_Animal.Hide;
  Edit_Animal.Free;
  If MR<>MrCancel then
     Begin
       Dbase_to_AnimalRecord(program_dir,'ANIMFORM.DB','',1,PAR^);
       If (TButton(Sender).Name='YOYButton') then YOYEdited := True
                                             else OlderEdited := True;
     End;

  PAR.UseAllom_C := True;  {allometric always used with multi age fish}
  PAR.UseAllom_R := True;  {allometric always used with multi age fish}

end;

Procedure TMultFishForm.YOYTrophicClick(Sender: TObject);
Begin
  Application.CreateForm(TTrophIntForm, TrophIntForm);
  Try
    TrophIntForm.AnimName := 'YOY ' + TempMAFI.PName^;
    TrophIntForm.SV := SV;
    TrophIntForm.PtrTrophInt := @YOYTroph;
    TrophIntForm.EditTrophInt;
    If TrophIntForm.Changed then Changed:=True;
  Finally
    TrophintForm.Free;
  End;

End;

procedure TMultFishForm.OlderTrophicClick(Sender: TObject);
begin
  Application.CreateForm(TTrophIntForm, TrophIntForm);
  Try
    TrophIntForm.AnimName := 'Older '+ TempMAFI.PName^;
    TrophIntForm.SV := SV;
    TrophIntForm.PtrTrophInt := @OlderTroph;
    TrophIntForm.EditTrophInt;
    If TrophIntForm.Changed then Changed:=True;
  Finally
    TrophintForm.Free;
  End;

end;

procedure TMultFishForm.NameEditChange(Sender: TObject);
begin
 TempMAFI.PName^ := NameEdit.Text;
 HeaderLabel.Caption := 'Multi Age Fish: ['+NameEdit.Text+']';
end;


procedure TMultFishForm.YOYMigrButtClick(Sender: TObject);
begin
  MigrForm.MigrTemp:=YOYMigr;
  MigrForm.EditMigr(LinkedS,ThisAQTS);
  YOYMigr := MigrForm.MigrTemp;
end;

procedure TMultFishForm.OlderMigrButtClick(Sender: TObject);
begin
  MigrForm.MigrTemp:=OlderMigr;
  MigrForm.EditMigr(LinkedS,ThisAQTS);
  OlderMigr := MigrForm.MigrTemp;
end;

procedure TMultFishForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic43.htm');
end;

procedure TMultFishForm.LoadOlderClick(Sender: TObject);

Var LoadOK: Boolean;
    PA: TAnimal;
    TrophDir:String;
begin
  Application.CreateForm(TDb_GetEntry, Db_GetEntry);
  With Db_GetEntry do
  begin
     HeadString:='Select Animal Entry to Load for Age 1+:';
     Filter:='Animal DBs (*.adb)|*.ADB|';
     DefaultDbName:='Animal.ADB';
     If Not GetEntry Then Exit;

     Changed:=True;

     LoadOK:=Dbase_to_AnimalRecord(FileDir,FileName,Entry,-1,OlderRecord);
     PA := TAnimal.Init(NullStateVar,StV,'',Nil,0,True);
    If DirectoryExists(FileDir+'\Trophint')
       then TrophDir := FileDir+'\Trophint\'
       else TrophDir := FileDir+'\';
     If PA.ReadTrophInt(TrophDir+OlderRecord.AnimalName+'.int')
        then OlderTroph := PA.PTrophint^;
     PA.Destroy;

  End; {With};

  DB_GetEntry.Free;

  UpdateScreen;
  If Not LoadOK then MessageDlg('Load Error: Press Cancel From This Screen To Restore Original Values.',mterror,[mbOK],0);

End; {Procedure}

procedure TMultFishForm.LoadYOYClick(Sender: TObject);
Var LoadOK: Boolean;
    PA: TAnimal;
    TrophDir:String;
begin
  Application.CreateForm(TDb_GetEntry, Db_GetEntry);
  With Db_GetEntry do
  begin
     HeadString:='Select Animal Entry to Load for YOY';
     Filter:='Animal DBs (*.adb)|*.ADB|';
     DefaultDbName:='Animal.ADB';
     If Not GetEntry Then Exit;

     Changed:=True;

     LoadOK:=Dbase_to_AnimalRecord(FileDir,FileName,Entry,-1,YOYRecord);
     PA := TAnimal.Init(NullStateVar,StV,'',Nil,0,True);
     If DirectoryExists(FileDir+'\Trophint')
         then TrophDir := FileDir+'\Trophint\'
         else TrophDir := FileDir+'\';
     If PA.ReadTrophInt(TrophDir+YOYRecord.AnimalName+'.int')
        then YOYTroph := PA.PTrophint^;
     PA.Destroy;

  End; {With};

  DB_GetEntry.Free;

  UpdateScreen;
  If Not LoadOK then MessageDlg('Load Error: Press Cancel From This Screen To Restore Original Values.',mterror,[mbOK],0);

End; {Procedure}

procedure TMultFishForm.TabControl1Change(Sender: TObject);
begin
  TabControl1.SetFocus;
end;

end.


