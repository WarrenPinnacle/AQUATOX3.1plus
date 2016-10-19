//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_6;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Wiz_5, Db, DBTables, StdCtrls, ExtCtrls, WizGlobal, AQUAOBJ, Global, wizardBase;

type
  TWizBase6 = class(TWizBase5)
  private
    { Private declarations }
  public
    Function  ExecuteScreen: WizOutput; override;
    Procedure UpdateScreen; override;
    { Public declarations }
  end;

var   WizBase6: TWizBase6;

implementation

Procedure TWizBase6.UpdateScreen;
Var Holder, LName: String;
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
  
  Case W5_Screen of
    0: Begin
         W5_PType := 'Shredder';
         W5_BeginIndex := Shredder1;
         W5_EndIndex := Shredder2;
       End;
    1: Begin
         W5_PType := 'Sed Feeder';
         W5_BeginIndex := SedFeeder1;
         W5_EndIndex := SedFeeder2;
       End;
    2: Begin
         W5_PType := 'Susp Feeder';
         W5_BeginIndex := SuspFeeder1;
         W5_EndIndex := SuspFeeder2;
       End;
    3: Begin
         W5_PType := 'Clam';
         W5_BeginIndex := Clams1;
         W5_EndIndex := Clams2;
       End;
    4: Begin
         W5_PType := 'Grazer';
         W5_BeginIndex := Grazer1;
         W5_EndIndex := Grazer2;
       End;
    5: Begin
         W5_PType := 'Snail';
         W5_BeginIndex := Snail1;
         W5_EndIndex := Snail2;
       End;
  else Begin
         W5_PType := 'Pred Invert';
         W5_BeginIndex := PredInvt1;
         W5_EndIndex := PredInvt2;
       End;
   End; {case}

  InstrLabel.Caption := 'To add a '+W5_PType+' Compartment to the simulation, drag its name from the list of available '+W5_PType+'s to the simulation box on the right.  '+
                        'To remove a '+W5_PType+' Compartment from the simulation, select it and click the Remove button below.';
  AvailLabel.Caption := 'Available '+W5_PType+'s:';
  InSimLabel.Caption := W5_PType+'s in Simulation:';
  Title.Caption := 'Step 6:  Invertebrates to Simulate ('+W5_PType+'s)';

  For Loop := 1 to W5_NumLabels do
     List[Loop] := '';

  If (W5_Screen<W5_NumScreens) then
    Begin
      If not RenameFile(Default_dir+'\Animal.ADB',Default_dir+'\Animal.DB') then Exit;
      Table1.DataBaseName:=Default_Dir;
      Table1.TableName:='Animal.DB';
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
                         If (FieldByName('GuildTaxa').AsString=W5_PType)
                           then Inc(Num_Entries);
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
                         If (FieldByName('GuildTaxa').AsString=W5_PType) then
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
                  TL := TLabel(WizBase6.FindComponent(LName));
                  TL.Caption := List[Loop];
                  TL.DragMode := DMAutomatic;
                  If TL.Caption='' then TL.DragMode := DmManual;
                End;
          end; {with}
      Except
      End;
      Table1.Active:=False;
      RenameFile(Default_dir+'\Animal.DB',Default_dir+'\Animal.ADB');

      RemoveButton.Enabled := False;
      ListBox2.Items.Clear;
      For IndexLoop := W5_BeginIndex to W5_EndIndex do
       If WizStudy.SV.GetStatePointer(IndexLoop,StV,WaterCol)<>nil then
         Begin
           PSV := WizStudy.SV.GetStatePointer(IndexLoop,StV,WaterCol);
           ListBox2.Items.Add(PSV.PName^);
         End;
    End;  {W5_Screen<5}

  If W5_Screen=W5_NumScreens then
    Begin
      W5_NumICs := 0;
      For IndexLoop := FirstInvert to LastInvert do
        If WizStudy.SV.GetStatePointer(Indexloop,StV,WaterCol)<>nil then
          Begin
            Inc(W5_NumICs);
            W5_ICFields[W5_NumICs] := IndexLoop;
          End;

      For Loop := 1 to W5_NumFields do
        Begin
          NameLabel := TLabel(FindComponent('ICLabel'+IntToStr(Loop)));
          UnitLabel := TLabel(FindComponent('Unit'   +IntToStr(Loop)));
          EditBox   :=  TEdit(FindComponent('ICEdit' +IntToStr(Loop)));

          NameLabel.Visible := (Loop<=W5_NumICs);
          UnitLabel.Visible := (Loop<=W5_NumICs);
          EditBox.Visible   := (Loop<=W5_NumICs);

          If Loop>W5_NumICs then Continue;

          PSV := WizStudy.SV.GetStatePointer(W5_ICFields[Loop],StV,WaterCol);
          TAnimal(PSV).ChangeData; {Ensure units are up to date}

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

          NameLabel.Caption := PSV.PName^;
          UnitLabel.Caption := PSV.StateUnit;

          If (WizStatus<>0) or W5_FieldEdited[Loop]
            then EditBox.Text := FloatToStrF(PSV.InitialCond,ffgeneral,9,4)
            else EditBox.Text := '';

        End;
    End; {W5_Screen=W5_NumScreens}

End;

Function  TWizBase6.ExecuteScreen: WizOutput;
Var Loop: Integer;
Begin
  FirstUpdate:= True;
  If FirstVisit then
   For Loop := 1 to W5_NumFields do
    W5_FieldEdited[Loop] := False;
  If FirstVisit then W5_NumICs := -1;

  W5_NumScreens := 7;

  If JumpIn = WzBack then W5_Screen:=W5_NumScreens
                     else W5_Screen:=0;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (DataFinished) then WizStatus := 2;
  For Loop := 1 to W5_NumICs do
    If (WizStatus=1) and (W5_FieldEdited[Loop]) then WizStatus := 2;

End;



{$R *.DFM}

end.
