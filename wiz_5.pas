//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_5;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SV_IO,wizardbase, StdCtrls, ExtCtrls, WizGlobal, Db, DBTables, Global, AQUAOBJ;


type
  TWizBase5 = class(TWizBase)
    ListBox2: TListBox;
    AvailLabel: TLabel;
    InSimLabel: TLabel;
    LimitLabel: TLabel;
    RemoveButton: TButton;
    InstrLabel: TLabel;
    Panel1: TPanel;
    list1: TLabel;
    list2: TLabel;
    list3: TLabel;
    list4: TLabel;
    list5: TLabel;
    list6: TLabel;
    list7: TLabel;
    list8: TLabel;
    list9: TLabel;
    list10: TLabel;
    list11: TLabel;
    list12: TLabel;
    Table1: TTable;
    icpanel: TPanel;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
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
    ICLabel17: TLabel;
    ICEdit17: TEdit;
    Unit17: TLabel;
    ICLabel18: TLabel;
    ICEdit18: TEdit;
    Unit18: TLabel;
    ICLabel19: TLabel;
    ICEdit19: TEdit;
    Unit19: TLabel;
    ICLabel20: TLabel;
    ICEdit20: TEdit;
    Unit20: TLabel;
    ICLabel21: TLabel;
    ICEdit21: TEdit;
    Unit21: TLabel;
    ICLabel22: TLabel;
    ICEdit22: TEdit;
    Unit22: TLabel;
    ICLabel23: TLabel;
    ICEdit23: TEdit;
    Unit23: TLabel;
    ICLabel24: TLabel;
    ICEdit24: TEdit;
    Unit24: TLabel;
    ICLabel25: TLabel;
    ICEdit25: TEdit;
    Unit25: TLabel;
    ICLabel26: TLabel;
    ICEdit26: TEdit;
    Unit26: TLabel;
    MoreButton: TButton;
    procedure ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure MainPanelDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure CursorBack(Sender, Target: TObject; X, Y: Integer);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure RemoveButtonClick(Sender: TObject);
    procedure ICEdit1Exit(Sender: TObject);
    procedure MoreButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    FirstUpdate: Boolean;
    PageIndex: Integer;
    Num_Entries: Integer;
    Procedure SetDataToFinished;
    Function  ExecuteScreen: WizOutput; override;
    Procedure UpdateScreen; virtual;
    Function  DataFinished: Boolean;
    { Public declarations }
  end;

var
  WizBase5: TWizBase5;


implementation

{$R *.DFM}

Procedure TWizBase5.UpdateScreen;
Var Holder, LName, NStr: String;
    List: Array[1..W5_NumLabels] of String;
    RecNum,Loop,LabelIndex: Integer;
    TL  : TLabel;
    PSV : TStateVariable;
    IndexLoop: AllVariables;
    NameLabel,UnitLabel: TLabel;
    EditBox: TEdit;

Begin
  ICPanel.Visible := (W5_Screen=W5_NumScreens);
  MainPanel.Visible := not (W5_Screen=W5_NumScreens);

  LimitLabel.Caption := '(Maximum of Six)';
  Case W5_Screen of
    0: Begin
         W5_PType := 'Diatoms';
         W5_BeginIndex := FirstDiatom;
         W5_EndIndex := LastDiatom;
       End;
    1: Begin
         W5_PType := 'Greens';
         W5_BeginIndex := FirstGreens;
         W5_EndIndex := LastGreens;
       End;
    2: Begin
         W5_PType := 'BlueGreens';
         W5_BeginIndex := FirstBlGreen;
         W5_EndIndex := LastBlGreen;
       End;
    3: Begin
         W5_PType := 'Other Algae';
         W5_BeginIndex := OtherAlg1;
         W5_EndIndex := OtherAlg2;
         LimitLabel.Caption := '(Maximum of Two)';
       End;
    else Begin
         W5_PType := 'Macrophytes';
         W5_BeginIndex := FirstMacro;
         W5_EndIndex := LastMacro;
       End;
   End; {case}

  If W5_Screen=3 then nstr :='n'
              else nstr :='';
  InstrLabel.Caption := 'To add a'+nstr+' '+W5_PType+' Compartment to the simulation, drag its name from the list of available '+W5_PType+' to the simulation box on the right.  '+
                        'To remove a'+nstr+' '+W5_PType+' Compartment from the simulation, select it and click the Remove button below.';
  AvailLabel.Caption := 'Available '+W5_PType+':';
  InSimLabel.Caption := W5_PType+' in Simulation:';
  Title.Caption := 'Step 5:  Plants to Simulate ('+W5_PType+')';

  For Loop := 1 to W5_NumLabels do
     List[Loop] := '';

  If (W5_Screen<W5_NumScreens) then
    Begin
      If not RenameFile(Default_dir+'\Plant.PDB',Default_dir+'\Plant.DB') then Exit;
      Table1.DataBaseName:=Default_Dir;
      Table1.TableName:='Plant.DB';
      Try
         Table1.Active:=True;
         With Table1 do
           begin
              If FirstUpdate then
                Begin
                  PageIndex:=0;
                  First;
                  RecNum:=RecordCount;
                  Num_Entries := 0;
                  For Loop:=1 to RecNum do
                     begin
                         Holder:=Fields[0].AsString;
                         If (FieldByName('Taxonomic Type').AsString=W5_PType) {or
                            ((FieldByName('Taxonomic Type').AsString<>'Macrophytes') and (W5_Screen=3))} then
                             Inc(Num_Entries);
                         Next;
                      end; {for do}
                  Morebutton.visible := (Num_Entries>12);
                  FirstUpdate := False;
                End;

              First;
              RecNum:=RecordCount;
              LabelIndex:=0;
              If RecNum>0 then
                 For Loop:=1 to RecNum do
                     begin
                         Holder:=Fields[0].AsString;
                         If (FieldByName('Taxonomic Type').AsString=W5_PType) {or
                            ((FieldByName('Taxonomic Type').AsString<>'Macrophytes') and (W5_Screen=3))} then
                           Begin
                             Inc(LabelIndex);
                             If (LabelIndex > (PageIndex*12)) and
                                (LabelIndex < (PageIndex*12)+13)
                                 then List[LabelIndex-(PageIndex*12)] := Holder;
                           End;
                         Next;
                      end; {for do}

              For Loop := 1 to W5_NumLabels do
                Begin
                  LName := 'list'+IntToStr(Loop);
                  TL := TLabel(WizBase5.FindComponent(LName));
                  TL.Caption := List[Loop];
                  TL.DragMode := DMAutomatic;
                  If TL.Caption='' then TL.DragMode := DmManual;
                End;
          end; {with}
      Except
      End;
      Table1.Active:=False;
      RenameFile(Default_dir+'\Plant.DB',Default_dir+'\Plant.PDB');

      RemoveButton.Enabled := False;
      ListBox2.Items.Clear;
      For IndexLoop := W5_BeginIndex to W5_EndIndex do
       If WizStudy.SV.GetStatePointer(IndexLoop,StV,WaterCol)<>nil then
         Begin
           PSV := WizStudy.SV.GetStatePointer(IndexLoop,StV,WaterCol);
           ListBox2.Items.Add(PSV.PName^);
         End;
    End;  {W5_Screen<W5_NumScreens}

  If W5_Screen=W5_NumScreens then
    Begin
      W5_NumICs := 0;
      For IndexLoop := FirstPlant to LastPlant do
        If WizStudy.SV.GetStatePointer(Indexloop,StV,WaterCol)<>nil then
          Begin
            Inc(W5_NumICs);
            W5_ICFields[W5_NumICs] := IndexLoop;
          End;

      Scrollbox1.VertScrollbar.Visible := False;

      For Loop := 1 to W5_NumFields do
        Begin
          NameLabel := TLabel(FindComponent('ICLabel'+IntToStr(Loop)));
          UnitLabel := TLabel(FindComponent('Unit'   +IntToStr(Loop)));
          EditBox   := TEdit(FindComponent('ICEdit' +IntToStr(Loop)));

          NameLabel.Visible := (Loop<=W5_NumICs);
          UnitLabel.Visible := (Loop<=W5_NumICs);
          EditBox.Visible   := (Loop<=W5_NumICs);

          If Loop>W5_NumICs then Continue;

          PSV := WizStudy.SV.GetStatePointer(W5_ICFields[Loop],StV,WaterCol);
          TPlant(PSV).ChangeData; {Ensure units are up to date}

          If Loop<=8 then
            Begin
              If (W5_NumICs > 8)
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

          If Loop>16 then
            Scrollbox1.VertScrollbar.Visible := True;

          NameLabel.Caption := PSV.PName^;
          UnitLabel.Caption := PSV.StateUnit;

          If (WizStatus<>0) or W5_FieldEdited[Loop]
            then EditBox.Text := FloatToStrF(PSV.InitialCond,ffgeneral,9,4)
            else EditBox.Text := '';

        End;
    End; {W5_Screen=W5_NumScreens}

End;

Procedure TWizBase5.SetDataToFinished;
Var loop: Integer;
Begin
  For Loop := 1 to W5_NumFields do
    W5_FieldEdited[Loop] := True;
End;

Function TWizBase5.DataFinished: Boolean;
Var Loop: Integer;
Begin
  If W5_NumICs=-1 then
    Begin
      DataFinished := False;
      Exit;
    End;
  DataFinished := True;
  For Loop := 1 to W5_NumICs do
    If not W5_FieldEdited[Loop] then DataFinished := False;
End;


Function  TWizBase5.ExecuteScreen: WizOutput;
Var Loop: Integer;
Begin
  FirstUpdate:= True;
  If (Name<>'WizBase5') and (Name<>'WizBase5_1') then
     Begin
       ExecuteScreen := Inherited ExecuteScreen;
       Exit;
     End;

  W5_NumScreens := 5;

  If FirstVisit then
    Begin
      For Loop := 1 to W5_NumFields do
       W5_FieldEdited[Loop] := False;
      W5_NumICs := -1;
    End;

  If JumpIn = WzBack then W5_Screen:=W5_NumScreens
                     else W5_Screen:=0;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (DataFinished) then WizStatus := 2;
  For Loop := 1 to W5_NumICs do
    If (WizStatus=1) and (W5_FieldEdited[Loop]) then WizStatus := 2;

End;


procedure TWizBase5.ListBox1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TLabel;
end;

procedure TWizBase5.ListBox1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
Var NewIndex: AllVariables;
    NewPSV  : TStateVariable;
    FileN   : String;
begin
  If Name='WizBase5' then FileN := 'Plant.PDB'
                     else FileN := 'Animal.ADB';

  With Sender as TListBox do
    Begin
      If (FileN = 'Animal.ADB') or (W5_PType = 'Other Algae')
        Then
          Begin
            If Items.Count=2 then
              Begin
                MessageDlg('AQUATOX can only model two '+W5_PType+'.',MTError,[MBOK],0);
                Exit;
              End;
          End
        Else If Items.Count=6 then
              Begin
                MessageDlg('AQUATOX can only model six '+W5_PType+'.',MTError,[MBOK],0);
                Exit;
              End;

      If W5_NumICs>-1 then SetDataToFinished;

      NewIndex := W5_BeginIndex;
      While WizStudy.SV.GetStatePointer(NewIndex,StV,WaterCol)<>nil do
        Inc(NewIndex);
      WizStudy.AddStateVariable(NewIndex,WaterCol,0,True);
      NewPSV :=WizStudy.SV.GetStatePointer(NewIndex,StV,WaterCol);

      If FileN='Plant.PDB'
        then
          Begin
            DBase_To_PlantRecord(Default_Dir,FileN,TLabel(Source).Caption,-1,TPlant(NewPSV).PAlgalRec^);
            NewPSV.PName^ := NewPSV.PName^+': ['+TPlant(NewPSV).PAlgalRec^.PlantName+']';
            NewPSV.PHasData^ := True;
          End
        else
          Begin
            DBase_To_AnimalRecord(Default_Dir,FileN,TLabel(Source).Caption,-1,TAnimal(NewPSV).PAnimalData^);
            NewPSV.PName^ := NewPSV.PName^+': ['+TAnimal(NewPSV).PAnimalData^.AnimalName+']';
            NewPSV.PHasData^ := True;
            If not TAnimal(NewPSV).ReadTrophInt(Default_Dir+'\TrophInt\'+TAnimal(NewPSV).PAnimalData^.AnimalName+'.int')
               then MessageDlg('Warning, cannot read trophic interaction file for Animal '+TAnimal(NewPSV).PAnimalData^.AnimalName
                               +'.  Trophic interactions are set to zero.',mtwarning,[mbok],0);
                               

          End;
      Items.Add(NewPSV.PName^);
    end;
end;

procedure TWizBase5.MainPanelDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  TControl(sender).Cursor := CrDrag;
end;

Procedure TWizBase5.CursorBack(Sender, Target: TObject; X, Y: Integer);
Var Loop: Integer;
    LName: String;
Begin
  MainPanel.Cursor := CrDefault;
  Panel1.Cursor := CrDefault;
  For Loop := 1 to W5_NumLabels do
    Begin
      LName := 'list'+IntToStr(Loop);
      TLabel(FindComponent(LName)).Cursor := CrDefault;
    End;
End;

procedure TWizBase5.NextButtonClick(Sender: TObject);
begin
  FirstUpdate := True;
  If W5_Screen<W5_NumScreens
    then
      Begin
        Inc(W5_Screen);
        UpdateScreen;
      End
    else inherited;
end;


procedure TWizBase5.BackButtonClick(Sender: TObject);
begin
  FirstUpdate := True;
  If W5_Screen>0
    then
      Begin
        Dec(W5_Screen);
        UpdateScreen;
      End
    else inherited;
end;

procedure TWizBase5.ListBox2Click(Sender: TObject);
begin
  RemoveButton.Enabled := ListBox2.ItemIndex>-1;
end;

procedure TWizBase5.RemoveButtonClick(Sender: TObject);
Var RemStr: String;
    DeleteVar: AllVariables;
    SelectedIndex: Integer;
    PSV: TStateVariable;

       Procedure DeleteTheVariable;
       {Deletes the variable identified by DeleteVar and all associated toxicants}
       Var ToxLoop   : T_SVType;
           ToxicrecIndex: Integer;
       Begin
         {Delete associated toxicant and internal nutrient records if they exist}
         For ToxLoop:=FirstToxTyp to PIntrnl do
         Begin
           ToxicRecIndex:=WizStudy.SV.GetIndex(DeleteVar,ToxLoop,WaterCol);
           If ToxicRecIndex>-1 then
               Begin
                  WizStudy.SV.AtFree(ToxicRecIndex);
                  WizStudy.SV.SetMemLocRec;
               End;
          End;

         WizStudy.SV.AtFree(SelectedIndex);
         WizStudy.SV.SetMemLocRec;
       End;

begin
  If ListBox2.ItemIndex=-1 then exit;
  RemStr := ListBox2.Items[ListBox2.Itemindex];
  SelectedIndex:=WizStudy.SV.GetIndexFromName(AbbrString(RemStr,':'));
  PSV:= WizStudy.SV.at(SelectedIndex);
  DeleteVar := PSV.NState;
  DeleteTheVariable;
  ListBox2.Items.Delete(ListBox2.Itemindex);
  RemoveButton.Enabled := False;
end;

procedure TWizBase5.ICEdit1Exit(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update W5_Screen}
Var Conv  : Double;
    Result: Integer;
    Txt: String;
    EditNum: Integer;
    EditName: String;
    ThisVar: AllVariables;
Begin
  Txt :=Tedit(Sender).Text;
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
        ThisVar := W5_ICFields[EditNum];
        If (Get_IC_Ptr(ThisVar)^<>Conv) or (WizStatus=0) then W5_FieldEdited[EditNum]:=True;
        Get_IC_Ptr(ThisVar)^ :=Conv;
      End;
End;

procedure TWizBase5.MoreButtonClick(Sender: TObject);
begin
  Inc(PageIndex);
  If ((PageIndex*12)>=Num_Entries) then PageIndex := 0;
  UpdateScreen;
end;

end.
