//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_1;

interface

uses
  WizGlobal,Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls, Global, AQStudy, FileCtrl;

type
  TWizBase1 = class(TWizBase)
    NewPanel: TPanel;
    RadioButton2: TRadioButton;
    RadioButton1: TRadioButton;
    ScratchPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    LakeButt: TRadioButton;
    PondButt: TRadioButton;
    Label3: TLabel;
    StreamButt: TRadioButton;
    Resbutt: TRadioButton;
    LimnoButt: TRadioButton;
    NameEdit: TEdit;
    StartOverButton: TButton;
    LoadDefPanel: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    ListBox1: TListBox;
    FileListBox1: TFileListBox;
    EstuaryButt: TRadioButton;
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure StartOverButtonClick(Sender: TObject);
    procedure PondButtClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure NameEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    Function  ExecuteScreen: WizOutput; override;
    Function  ForceExit:Boolean; Override;
    Procedure UpdateScreen;
    Function  DataFinished: Boolean;
    { Public declarations }
  end;

var
  WizBase1: TWizBase1;


implementation

uses Study_io, Wait;

Function TWizBase1.DataFinished: Boolean;
Begin
  DataFinished := (WizStudy<>nil) or
                  ((NameEdit.Text<>'') and ((PondButt.Checked) or
                                            (StreamButt.Checked) or
                                            (LimnoButt.Checked) or
                                            (ResButt.Checked) or
                                            (LakeButt.Checked) or
                                            (EstuaryButt.Checked)));
End;

Procedure TWizBase1.UpdateScreen;
Begin
  FinishButton.Enabled := not IsNewSetup;

  If WizStudy<>nil then NameEdit.Text := WizStudy.StudyName;
  If (WizStudy<>nil) and (W1_Screen=2) then W1_Screen:=1;

  If WizStudy<>nil then Case WizStudy.SV.Location.SiteType of
     Pond: PondButt.Checked := True;
     Stream: StreamButt.Checked := True;
     Enclosure: LimnoButt.Checked := True;
     Reservr1D: ResButt.Checked := True;
     Lake: LakeButt.Checked := True;
     Estuary: EstuaryButt.Checked := True;     
    End; {Case}

  RadioButton1.Enabled  := WizStudy=nil;
  RadioButton2.Enabled   := WizStudy=nil;
  StartOverButton.Visible := WizStudy<>nil;

  MainPanel.Visible   := W1_Screen=0;
  ScratchPanel.Visible := W1_Screen=1;
  LoadDefPanel.Visible  := W1_Screen=2;

  If W1_Screen = 2 then
   If ListBox1.Items.Count=0 then
    Begin
      FileListBox1.Directory := Studies_Dir;
      FileListBox1.Update;
      ListBox1.Items.Clear;
      ListBox1.Items:=FileListBox1.Items;
      W1_DefChosen := False;
    End;

  NextButton.Enabled := ((W1_Screen=0) and (W1_Choice <> 0)) or
                        ((W1_Screen=1) and DataFinished) or
                        ((W1_Screen=2) and W1_DefChosen);
End;

Function TWizBase1.ExecuteScreen: WizOutput;
Begin
  If FirstVisit then W1_Choice := 0;
  If FirstVisit then W1_Screen := 0;

  If not IsNewSetup then W1_Choice := 2;
  If not IsNewSetup then W1_Screen := 1;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;

End;

{$R *.DFM}



procedure TWizBase1.RadioButton1Click(Sender: TObject);
begin
  W1_Choice := 1;
  UpdateScreen;
end;

procedure TWizBase1.RadioButton2Click(Sender: TObject);
begin
  W1_Choice := 2;
  UpdateScreen;
end;

Procedure TWizBase1.NextButtonClick(Sender: TObject);
Var StudyName: String;
    SiteChosen: SiteTypes;
Begin
  Case W1_Screen of
    0: Begin
         If W1_Choice=1 then W1_Screen:=1
                        else W1_Screen:=2;
         UpdateScreen;
       End;
    1: Begin
         WizStatus := 2;

         If WizStudy=nil then
           Begin
             SiteChosen := Stream;
             If PondButt.Checked   then SiteChosen := Pond;
             If LimnoButt.Checked  then SiteChosen := Enclosure;
             If ResButt.Checked    then SiteChosen := Reservr1D;
             If LakeButt.Checked   then SiteChosen := Lake;
             If EstuaryButt.Checked then SiteChosen := Estuary;
             WizStudy:=TAquatoxSegment.Init(StudyName,nil);
             WizStudy.Load_Blank_Study(SiteChosen);
             WizStudy.StudyName := NameEdit.Text;
             WizStudy.SV.Location.SiteType := SiteChosen;
           End;

         inherited;
       End;
    2: Begin
         Try
            WizStudy := Nil;         
            LoadFile(WizStudy,Studies_Dir+ListBox1.Items[ListBox1.ItemIndex]);
         Except
            WizStudy:=nil;
            WaitDlg.Hide;
            Invalidate;
            Raise;
            Exit;
         End;

         WizStatus := 1;

         inherited;
       End;
    End; {case}
End;

Procedure TWizBase1.BackButtonClick(Sender: TObject);
Begin
  If (W1_Screen=0) or (not IsNewSetup)
    then Inherited
    else Begin
           W1_Screen:=0;
           UpdateScreen;
         End;
End;

procedure TWizBase1.StartOverButtonClick(Sender: TObject);
begin
  If MessageDlg('Scrap The Existing Study and Start From Scratch?',MTConfirmation,[MBOK,MBCancel],0)
  =MRCancel then Exit;

  NameEdit.Text := '';

  WizStudy.Destroy;
  WizStudy := Nil;
  WizOutcome := WzBack;
end;

procedure TWizBase1.PondButtClick(Sender: TObject);
begin
  If WizStudy<>nil then
    Begin
      If PondButt.Checked   then WizStudy.SV.Location.SiteType := Pond;
      If StreamButt.Checked then WizStudy.SV.Location.SiteType := Stream;
      If LimnoButt.Checked  then WizStudy.SV.Location.SiteType := Enclosure;
      If ResButt.Checked    then WizStudy.SV.Location.SiteType := Reservr1D;
      If LakeButt.Checked   then WizStudy.SV.Location.SiteType := Lake;
      If EstuaryButt.Checked then WizStudy.SV.Location.SiteType := Estuary;
    End;

  NextButton.Enabled := DataFinished;
end;

procedure TWizBase1.ListBox1Click(Sender: TObject);
begin
  If ListBox1.ItemIndex<>-1 then W1_DefChosen := True;
  UpdateScreen;
end;

Function TWizBase1.ForceExit: Boolean;
Begin                 If (Not DataFinished) and Not (((W1_Screen=2) or (W1_Screen=1)) and NextButton.Enabled)
    then
      Begin
        MessageDlg('You must complete initial specifications before jumping to another wizard step',mterror,[mbok],0);
        ForceExit := False;
      End
    else
      Begin
        NextButtonClick(nil);
        ForceExit := inherited ForceExit;

      End;
End;

procedure TWizBase1.NameEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If WizStudy<>nil then WizStudy.StudyName := NameEdit.Text;
  UpdateScreen;
end;

end.
