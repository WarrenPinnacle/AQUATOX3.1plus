//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_7;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls, WizGlobal, Global, AQUAOBJ, Wiz_Fish1, SV_IO;

type
  TWizBase7 = class(TWizBase)
    Label1: TLabel;
    FishList: TListBox;
    InSimLabel: TLabel;
    AddButton: TButton;
    Bevel1: TBevel;
    RemoveButton: TButton;
    icpanel: TPanel;
    Label2: TLabel;
    ICLabel: TLabel;
    ICLabel1: TLabel;
    Unit1: TLabel;
    ICLabel2: TLabel;
    Unit2: TLabel;
    ICLabel3: TLabel;
    Unit3: TLabel;
    ICLabel4: TLabel;
    Unit4: TLabel;
    ICLabel5: TLabel;
    Unit5: TLabel;
    ICLabel6: TLabel;
    Unit6: TLabel;
    ICLabel7: TLabel;
    Unit7: TLabel;
    ICLabel8: TLabel;
    Unit8: TLabel;
    ICLabel9: TLabel;
    Unit9: TLabel;
    ICLabel10: TLabel;
    Unit10: TLabel;
    ICLabel11: TLabel;
    Unit11: TLabel;
    ICLabel12: TLabel;
    Unit12: TLabel;
    ICLabel13: TLabel;
    Unit13: TLabel;
    ICLabel14: TLabel;
    Unit14: TLabel;
    ICLabel15: TLabel;
    Unit15: TLabel;
    ICLabel16: TLabel;
    Unit16: TLabel;
    ICEdit1: TEdit;
    ICEdit2: TEdit;
    ICEdit3: TEdit;
    ICEdit4: TEdit;
    ICEdit5: TEdit;
    ICEdit6: TEdit;
    ICEdit7: TEdit;
    ICEdit8: TEdit;
    ICEdit9: TEdit;
    ICEdit10: TEdit;
    ICEdit11: TEdit;
    ICEdit12: TEdit;
    ICEdit13: TEdit;
    ICEdit14: TEdit;
    ICEdit15: TEdit;
    ICEdit16: TEdit;
    morelabel: TLabel;
    procedure FishListClick(Sender: TObject);
    procedure RemoveButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure NumbConv(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure SetDataToFinished;  
    Function  ExecuteScreen: WizOutput; override;
    Procedure UpdateScreen;
    Function  DataFinished: Boolean;
    Function  MultiFishIncluded: Boolean;
  end;


var
  WizBase7: TWizBase7;


implementation

uses Wiz_Fish2, Wiz_DBEntry;

Function TWizBase7.MultiFishIncluded: Boolean;
Begin
  MultiFishIncluded := (WizStudy.SV.GetStatePointer(Fish1,StV,WaterCol)<>nil);
End;

Procedure TWizBase7.UpdateScreen;
Var FishTypeStr, FishNameStr, FishClassStr, FishText: String;
    List: Array[1..W7_NumLabels] of String;
    FishIndex: Integer;
    Loop: Integer;
    PSV : TStateVariable;
    PF  : TAnimal;
    FishLoop: AllVariables;
    NameLabel,UnitLabel: TLabel;
    EditBox: TEdit;
    FoundSameFish: Boolean;
    IndexLoop,StartIndex,EndIndex: AllVariables;

Begin

  For Loop := 1 to W7_NumLabels do
     List[Loop] := '';

  MainPanel.Visible := (W7_Screen=0);
  ICPanel.Visible   := (W7_Screen>0);

  If (W7_Screen<1) then
    Begin
      RemoveButton.Enabled := False;
      FishList.Items.Clear;
      For FishIndex:=1 to 50 do
        W7_FishArray[FishIndex] := NullStateVar;
      FishIndex:=0;
      For FishLoop := FirstFish to Fish1 do
       If WizStudy.SV.GetStatePointer(FishLoop,StV,WaterCol)<>nil then
         Begin
           PF := WizStudy.SV.GetStatePointer(FishLoop,StV,WaterCol);
           Inc(FishIndex);
           W7_FishArray[FishIndex] := FishLoop;
           FishTypeStr := 'single-compartment fish';
           If (FishLoop=Fish1)
             then FishTypeStr:='multi-age fish'
             else
               If PF.PSameSpecies^ <> NullStateVar then
                 Begin
                   FoundSameFish := False;
                   For Loop := 1 to FishIndex do
                     If W7_FishArray[Loop] = PF.PSameSpecies^
                       then FoundSameFish := True;

                   If FoundSameFish then
                     Begin
                       W7_FishArray[FishIndex] := nullstatevar;
                       Dec(FishIndex);
                       Continue;
                     End;

                   If WizStudy.SV.GetStatePointer(PF.PSameSpecies^,StV,WaterCol)<>nil
                      then FishTypeStr := 'two size-class fish'
                      else PF.PSameSpecies^ := NullStateVar;
                 End;

           FishNameStr := PF.PAnimalData.AnimalName;
           If FishTypeStr <> 'single-compartment fish' then
             Begin
               If Pos('YOY',FishNameStr)>0 then Delete(FishNameStr,Pos('YOY',FishNameStr),3);
               If Pos(',',FishNameStr)>0 then Delete(FishNameStr,Pos(',',FishNameStr),1);
             End;

           Case FishLoop of
             SmForageFish1..LgForageFish2: FishClassStr := 'forage fish';
             SmBottomFish1..LgBottomFish2: FishClassStr := 'bottom fish';
             SmGameFish1..LgGameFish4: FishClassStr := 'game fish';
             Fish1: FishClassStr := '';
             End; {Case}

           If FishTypeStr ='single-compartment fish' then
              If FishLoop in [SmForageFish1,SmForageFish2,SmBottomFish1,SmBottomFish2,SmGameFish1..SmGameFish4]
                then FishClassStr:= 'small '+FishClassStr
                else FishClassStr:= 'large '+FishClassStr;

           FishText := FishNameStr+': '+FishClassStr+', '+FishTypeStr;

           If FishClassStr='' then
             Begin
               FishClassStr := IntToStr(PF.AllStates.PMultiRec.PNumAges^)+' age-classes';
               FishText := FishNameStr+': '+FishTypeStr+', '+FishClassStr;
             End;

           FishList.Items.Add(FishText);
         End;
    End;  {W7_Screen<1}

  If W7_Screen>0 then
    Begin
      MoreLabel.Visible := (W7_Screen=1) and MultiFishIncluded;
      W7_NumICs[W7_Screen] := 0;
      If W7_Screen=1
        then
          Begin
            StartIndex := SmForageFish1;
            EndIndex   := LgGameFish4;
            ICLabel.Caption := 'Enter initial conditions for these fish in this simulation:'
          End
        else
          Begin
            StartIndex := Fish1;
            EndIndex   := Fish15;
            PF := WizStudy.SV.GetStatePointer(Fish1,StV,WaterCol);
            ICLabel.Caption := 'Enter init. conds. for each age of the age-class fish ('+PF.PAnimalData.AnimalName+')'
          End;

      For IndexLoop := StartIndex to EndIndex do
        If WizStudy.SV.GetStatePointer(Indexloop,StV,WaterCol)<>nil then
          Begin
            Inc(W7_NumICs[W7_Screen]);
            W7_ICFields[W7_NumICs[W7_Screen]] := IndexLoop;
          End;

      For Loop := 1 to W7_NumFields do
        Begin
          NameLabel := TLabel(FindComponent('ICLabel'+IntToStr(Loop)));
          UnitLabel := TLabel(FindComponent('Unit'   +IntToStr(Loop)));
          EditBox   :=  TEdit(FindComponent('ICEdit' +IntToStr(Loop)));

          NameLabel.Visible := (Loop<=(W7_NumICs[W7_Screen]));
          UnitLabel.Visible := (Loop<=(W7_NumICs[W7_Screen]));
          EditBox.Visible   := (Loop<=(W7_NumICs[W7_Screen]));

          If Loop>(W7_NumICs[W7_Screen]) then Continue;

          PSV := WizStudy.SV.GetStatePointer(W7_ICFields[Loop],StV,WaterCol);
          TAnimal(PSV).ChangeData; {Ensure units are up to date}

          If Loop<=8 then
            Begin
              If (W7_NumICs[W7_Screen] > 8)
                then
                  Begin
                    NameLabel.Left := 21;
                    UnitLabel.Left := 256;
                    EditBox.Left   := 150;
                  End
                else
                  Begin
                    NameLabel.Left := 149;
                    UnitLabel.Left := 384;
                    EditBox.Left   := 278;
                  End;
            End;

          If W7_Screen = 1 then NameLabel.Caption := PSV.PName^
                        else NameLabel.Caption := OutputText(PSV.Nstate,StV,WaterCol,WizStudy.SV.UniqueName(PSV.Nstate),False,False,0);
          PSV.UpdateUnits;
          UnitLabel.Caption := PSV.StateUnit;

          If (WizStatus<>0) or W7_FieldEdited[W7_Screen,Loop]
            then EditBox.Text := FloatToStrF(PSV.InitialCond,ffgeneral,9,4)
            else EditBox.Text := '';

        End;
    End; {W7_Screen>0}

End;

Function  TWizBase7.ExecuteScreen: WizOutput;
Var ScLoop,Loop: Integer;
Begin
  If FirstVisit then
   For Loop := 1 to W7_NumFields do
     For ScLoop := 1 to 2 do
       W7_FieldEdited[ScLoop,Loop] := False;
  If FirstVisit then W7_NumICs[1] := -1;

  If JumpIn = WzBack then
                       Begin
                         If MultiFishIncluded then W7_Screen:=2
                                              else W7_Screen:=1;
                       End
                     else W7_Screen:=0;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (DataFinished) then WizStatus := 2;
  For ScLoop := 1 to 2 do
   For Loop := 1 to W7_NumICs[ScLoop] do
    If (WizStatus=1) and (W7_FieldEdited[ScLoop,Loop]) then WizStatus := 2;

End;


Procedure TWizBase7.SetDataToFinished;
Var ScLoop,Loop: Integer;
Begin
  For ScLoop := 1 to 2 do
    For Loop := 1 to W7_NumFields do
      W7_FieldEdited[ScLoop,Loop] := True;
End;

Function TWizBase7.DataFinished: Boolean;
Var ScLoop,Loop: Integer;
Begin
  If W7_NumICs[1]=-1 then
    Begin
      DataFinished := False;
      Exit;
    End;

  DataFinished := True;
  If MultiFishIncluded
   then
    Begin
      For ScLoop := 1 to 2 do
       For Loop := 1 to W7_NumICs[scLoop] do
         If not W7_FieldEdited[ScLoop,Loop] then DataFinished := False
    End
   else For Loop := 1 to W7_NumICs[1] do
         If not W7_FieldEdited[1,Loop] then DataFinished := False;

End;


{$R *.DFM}

procedure TWizBase7.FishListClick(Sender: TObject);
begin
  RemoveButton.Enabled := FishList.ItemIndex>-1;
end;

procedure TWizBase7.RemoveButtonClick(Sender: TObject);
Var SameSpec,DeleteVar: AllVariables;
    PA: TAnimal;

       Procedure DeleteTheVariable;
       {Deletes the variable identified by DeleteVar and all associated toxicants}
       Var ToxLoop   : ToxicantType;
           ToxicrecIndex: Integer;
       Begin
         {Delete associated toxicant and hg records if they exist}
         For ToxLoop:=FirstToxTyp to LastToxTyp do
          Begin
           ToxicRecIndex:=WizStudy.SV.GetIndex(DeleteVar,ToxLoop,WaterCol);
           If ToxicRecIndex>-1 then
               Begin
                  WizStudy.SV.AtFree(ToxicRecIndex);
                  WizStudy.SV.SetMemLocRec;
               End;
          End;

         With WizStudy.SV do
           If GetIndex(DeleteVar,StV,WaterCol)>-1
             then AtFree(GetIndex(DeleteVar,StV,WaterCol));
         WizStudy.SV.SetMemLocRec;
       End;

begin
  If FishList.ItemIndex=-1 then exit;

  Deletevar := W7_FishArray[FishList.ItemIndex+1];
  PA := WizStudy.SV.GetStatePointer(DeleteVar,StV,WaterCol);
  SameSpec := PA.PSameSpecies^;

  If DeleteVar = Fish1 Then
      For DeleteVar := Fish1 to Fish15 do
          DeleteTheVariable
     Else DeleteTheVariable;

  If SameSpec<>NullStateVar then  {In the case of size-class fish, delete other compartment}
    Begin
      DeleteVar := SameSpec;
      DeleteTheVariable;
    End;

  RemoveButton.Enabled := False;
  UpdateScreen;
end;

procedure TWizBase7.AddButtonClick(Sender: TObject);
Type TFishType = (Single,Size,Age);
     TFishClass= (Forage,Bottom,Game);

   Function LowerClassAvailable(Cls:TFishClass):AllVariables;
   Var Index,StartIndex,EndIndex: AllVariables;
   Begin
     LowerClassAvailable := NullStateVar;
     Case Cls of
       Forage : Begin
                  StartIndex := SmForageFish1;
                  EndIndex   := SmForageFish2;
                End;
       Bottom : Begin
                  StartIndex := SmBottomFish1;
                  EndIndex   := SmBottomFish2;
                End;
       Else     Begin
                  StartIndex := SmGameFish1;
                  EndIndex   := SmGameFish4;
                End;
       End; {Case}

       For Index:=EndIndex downto StartIndex do
         If WizStudy.SV.GetStatePointer(Index,StV,WaterCol) = nil then
             LowerClassAvailable := Index;

   End;

   Function UpperClassAvailable(Cls:TFishClass):AllVariables;
   Var Index,StartIndex,EndIndex: AllVariables;
   Begin
     UpperClassAvailable := NullStateVar;
     Case Cls of
       Forage : Begin
                  StartIndex := LgForageFish1;
                  EndIndex   := LgForageFish2;
                End;
       Bottom : Begin
                  StartIndex := LgBottomFish1;
                  EndIndex   := LgBottomFish2;
                End;
       Else     Begin
                  StartIndex := LgGameFish1;
                  EndIndex   := LgGameFish4;
                End;
       End; {Case}

       For Index:=EndIndex downto StartIndex do
         If WizStudy.SV.GetStatePointer(Index,StV,WaterCol) = nil then
             UpperClassAvailable := Index;

   End;


Var  FishType: TFishType;
     FishClass: TFishClass;
     LowerFish, UpperFish: AllVariables;
     SmallFish: Boolean;
     PF, PSmF, PLgF: TAnimal;
     FCStr: String;
begin
  If FishTypeDialog.ShowModal = MrCancel then Exit;
  If FishTypeDialog.Single.Checked
    then FishType := Single
    else if FishTypeDialog.Size.Checked
      then FishType := Size
      else FishType := Age;

  If (FishType=Age) and (MultiFishIncluded) then
    Begin
      MessageDlg('Only one age-class fish may exist in each simulation.',MTError,[MBOK],0);
      Exit;
    End;

  FishClassDialog.SingleFishPanel.Visible := (FishType=Single);
  If FishType <> Age then
    If FishClassDialog.ShowModal=MrCancel then Exit;

  If ((FishType=Age)  and (W7_NumICs[2]>0)) or
     ((FishType<>Age) and (W7_NumICs[1]>0)) then SetDataToFinished;

  FishClass := Forage;
  If (FishType=Single)
     and (FishClassDialog.SmGame.Checked or FishClassDialog.LgGame.Checked)
     then FishClass := Game;
  If (FishType=Size) and FishClassDialog.Game.Checked
     then FishClass := Game;
  If (FishType=Single)
     and (FishClassDialog.SmBottom.Checked or FishClassDialog.LgBottom.Checked)
     then FishClass := Bottom;
  If (FishType=Size) and FishClassDialog.Bottom.Checked
     then FishClass := Bottom;

  Case FishClass of
    Game: FCStr := 'game';
    Bottom: FCStr := 'bottom';
    else FCStr := 'forage';
  end;

  LowerFish := LowerClassAvailable(FishClass);
  UpperFish := UpperClassAvailable(FishClass);

  If (FishType=Size) and ((LowerFish=NullStateVar) or (UpperFish=NullStateVar)) then
    Begin
      MessageDlg('Sorry, there are not enough State Variables of that fish-type left to create a new size-class fish.  '+
                 'Both a small and large fish variable must be empty.',MTError,[MBOK],0);
      Exit;
    End;

  If (FishType=Single) then
    Begin
      SmallFish := (FishClassDialog.SmGame.Checked) or
                   (FishClassDialog.SmBottom.Checked) or
                   (FishClassDialog.SmForage.Checked);
      If (SmallFish and (LowerFish=NullStateVar)) or
         (not SmallFish and (UpperFish=NullStateVar))
        then
          Begin
            MessageDlg('Sorry, there are no available State Variables in that size and class.',MTError,[MBOK],0);
            Exit;
          End;

      With Wiz_GetEntry do
        Begin
          Header.Caption := 'Select the '+FCStr+' fish species you wish to model:';
          If not GetEntry(Ord(FishClass)) then exit;
          With WizStudy do
            If SmallFish then Begin
                                AddStateVariable(LowerFish,WaterCol,0,True);
                                PF := SV.GetStatePointer(LowerFish,StV,WaterCol);
                              End
                         else Begin
                                AddStateVariable(UpperFish,WaterCol,0,True);
                                PF := SV.GetStatePointer(UpperFish,StV,WaterCol);
                              End;

          DBase_To_AnimalRecord(Default_Dir,'Animal.ADB',Entry,-1,PF.PAnimalData^);
          PF.PName^ := PF.PName^+': ['+PF.PAnimalData.AnimalName+']';
          If not PF.ReadTrophInt(Default_Dir+'\Trophint\'+PF.PAnimalData.AnimalName+'.int')
             then MessageDlg('Warning, cannot read trophic interaction file for Animal '+PF.PAnimalData.AnimalName
                             +'.  Trophic interactions are set to zero.',mtwarning,[mbok],0);
          PF.PHasData^ := True;
        End
    End;

  If FishType=Size then
   With WizStudy do
    Begin
      With Wiz_GetEntry do
        Begin
          Header.Caption := 'Select the '+fcstr+' fish species data for the SMALL (YOY) size-class fish.';
          If not GetEntry(ORD(FishClass)) then exit;    {cancel button press}

          AddStateVariable(LowerFish,WaterCol,0,True);
          AddStateVariable(UpperFish,WaterCol,0,True);
          PSmF := SV.GetStatePointer(LowerFish,StV,WaterCol);
          PSmF.PSameSpecies^ := UpperFish;
          PLgF := SV.GetStatePointer(UpperFish,StV,WaterCol);
          PLgF.PSameSpecies^ := LowerFish;
          DBase_To_AnimalRecord(Default_Dir,'Animal.ADB',Entry,-1,PSmF.PAnimalData^);

          PSmF.PHasData^ := True;
          If not PSmF.ReadTrophInt(Default_Dir+'\Trophint\'+PSmF.PAnimalData.AnimalName+'.int')
             then MessageDlg('Warning, cannot read trophic interaction file for Animal '+PSmF.PAnimalData.AnimalName
                             +'.  Trophic interactions are set to zero.',mtwarning,[mbok],0);
        End;

      If MessageDlg('Do you wish to load a different set of species data for the large size-class fish?',mtconfirmation,[mbyes,mbno],0) = mryes
        Then
          With Wiz_GetEntry do
            Begin
              Header.Caption := 'Select the '+fcstr+' fish species data for the large size-class fish.';
              If not GetEntry(ORD(FishClass))
                 then Begin
                        New(PLgF.PAnimalData);  {make new record}
                        PLgF.PAnimalData^ := PSmF.PAnimalData^ {copy the record}
                      End
                 else DBase_To_AnimalRecord(Default_Dir,'Animal.ADB',Entry,-1,PLgF.PAnimalData^);
            End
        Else Begin
               New(PLgF.PAnimalData); {make new record}
               PLgF.PAnimalData^ := PSmF.PAnimalData^ {copy the record}
             End;

      PLgF.PHasData^ := True;
      If not PLgF.ReadTrophInt(Default_Dir+'\Trophint\'+PLgF.PAnimalData.AnimalName+'.int')
             then MessageDlg('Warning, cannot read trophic interaction file for Animal '+PLgF.PAnimalData.AnimalName
                             +'.  Trophic interactions are set to zero.',mtwarning,[mbok],0);


      PSmF.PName^ := PSmF.PName^+': ['+PSmF.PAnimalData.AnimalName+']';
      PLgF.PName^ := PLgF.PName^+': ['+PLgF.PAnimalData.AnimalName+']';
    End;

  If FishType=Age then WizStudy.AddMultiAgeFish(True);

  UpdateScreen;
end;

procedure TWizBase7.NextButtonClick(Sender: TObject);
begin
  If ((W7_Screen=2)) or ((W7_Screen=1) and not MultiFishIncluded)
    then inherited
    else
      Begin
        Inc(W7_Screen);
        UpdateScreen;
      End;
end;

procedure TWizBase7.BackButtonClick(Sender: TObject);
begin
  If W7_Screen>0
    then
      Begin
        Dec(W7_Screen);
        UpdateScreen;
      End
    else inherited;
end;

procedure TWizBase7.NumbConv(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update W7_Screen}
Var Conv  : Double;
    Result: Integer;
    Txt: String;
    EditNum: Integer;
    EditName: String;
    ThisVar: AllVariables;
Begin
  Txt := TEdit(Sender).Text;
  If Trim(Txt)='' then exit;
  Val(Txt,Conv,Result);
  Conv:=Abs(Conv);
  If (Result<>0)
    then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
    else
      Begin
        EditName := TEdit(Sender).Name;
        If Length(EditName)<8 then EditNum := StrToInt(EditName[7])
                              else EditNum := StrToInt(EditName[7]+EditName[8]);
        ThisVar := W7_ICFields[EditNum];
        If (Get_IC_Ptr(ThisVar)^<>Conv) or (WizStatus=0) then W7_FieldEdited[W7_Screen,EditNum]:=True;
        Get_IC_Ptr(ThisVar)^ :=Conv;
      End;
End;

end.
