//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Setup;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons, Uncert, hh,
  StdCtrls, DBCtrls, Global, SysUtils, Dialogs, ExtCtrls, U_Setup, AQBaseForm;

type
  TStudySetupDialog = class(TAQBase)
    ReturnHandleButton: TButton;
    Panel1: TPanel;
    UncertButt: TButton;
    ControlSetupButton: TButton;
    CancelBtn: TBitBtn;
    OKBtn: TBitBtn;
    OutputSetupButton: TButton;
    HelpButton: TButton;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Label7: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    FirstDayEdit: TEdit;
    LastDayEdit: TEdit;
    BiotaPanel: TPanel;
    Label13: TLabel;
    SPINModeBox: TCheckBox;
    NtoPButton: TCheckBox;
    Panel9: TPanel;
    DailySim: TRadioButton;
    HourlySim: TRadioButton;
    ToxPanel: TPanel;
    Label15: TLabel;
    Label14: TLabel;
    Panel3: TPanel;
    Label8: TLabel;
    Label20: TLabel;
    UseInternal: TRadioButton;
    UseExternalConcsBox: TRadioButton;
    usedissinBAF: TCheckBox;
    Panel7: TPanel;
    Label2: TLabel;
    DefaultTox: TRadioButton;
    KeepToxConst: TRadioButton;
    Panel8: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    NormUptakeButt: TRadioButton;
    BCFUptakeButt: TRadioButton;
    ToggleTox: TButton;
    outputpanel: TPanel;
    Label18: TLabel;
    Label12: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label17: TLabel;
    Label3: TLabel;
    Panel5: TPanel;
    InstantOutput: TRadioButton;
    avgoutput: TRadioButton;
    Panel2: TPanel;
    SaveBioRates: TRadioButton;
    DontSave: TRadioButton;
    RateSpecsButton: TButton;
    Panel4: TPanel;
    WriteHypo: TCheckBox;
    ShowIntBut: TRadioButton;
    DontShowIntBut: TRadioButton;
    StepSizeEdit: TEdit;
    Panel10: TPanel;
    Hours: TRadioButton;
    Days: TRadioButton;
    Bevel1: TBevel;
    NtoPRatioEdit: TEdit;
    RatioLabel: TLabel;
    NutrientSpinBox: TCheckBox;
    Panel11: TPanel;
    relerrlabel: TLabel;
    steplabel2: TLabel;
    StepLabel: TLabel;
    FixedStepSizeEdit: TEdit;
    RelErrEdit: TEdit;
    VarStepsize: TRadioButton;
    FixedStepsize: TRadioButton;
    FixStepSizeLabel: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ModelInternally: TRadioButton;
    UseExternal: TRadioButton;
    procedure NumberConv(Sender: TObject);
    procedure ConvDate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure EnableDisable(Sender: TObject);
    procedure UncertButtClick(Sender: TObject);
    procedure RateSpecsButtonClick(Sender: TObject);
    procedure ControlSetupButtonClick(Sender: TObject);
    procedure WriteHypoClick(Sender: TObject);
    procedure OutputSetupButtonClick(Sender: TObject);
    procedure usedissinBAFClick(Sender: TObject);
    procedure disablelipidboxClick(Sender: TObject);
    procedure keeptoxconstboxClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure UseInternalClick(Sender: TObject);
    procedure NormUptakeButtClick(Sender: TObject);
    procedure DailySimClick(Sender: TObject);
    procedure DaysClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure SPINModeBoxClick(Sender: TObject);
    procedure NtoPButtonClick(Sender: TObject);
    procedure ToggleToxClick(Sender: TObject);
    procedure NutrientSpinBoxClick(Sender: TObject);
    procedure VarStepsizeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ModelInternallyClick(Sender: TObject);
   private
    TempSetup: Setup_Record;     {Holds temp info about State Var so user
                                  can cancel if he/she wants to}
    PIncoming: PSetup_Record;                              
    RateStuff: RateInfoType;
    ControlStuff: Control_Opt_Rec;
    Ptr      : Pointer;
    { Private declarations }
  public
    Changed,LinkedMod: Boolean;
    Updating: Boolean;
    Procedure EditSetup(Var Incoming: Setup_Record; Var InRate: RateInfoType;
                        P: Pointer; Var InControl: Control_Opt_Rec; Linked, HasTox: Boolean);
    Procedure UpdateScreen;
    { Public declarations }
  end;

var
  StudySetupDialog: TStudySetupDialog;

implementation

uses RateScrn, Control, results;
{$R *.DFM}

{**********************}

Procedure TStudySetupDialog.EditSetup(Var Incoming: Setup_Record; Var InRate: RateInfoType;
                                      P: Pointer;  Var InControl: Control_Opt_Rec; Linked, HasTox: Boolean);

Begin
   Updating := False;
   LinkedMod           := Linked;
   Changed             := False;
   USetupForm.Changed  := False;
   ControlForm.Changed := False;
   RSetupForm.Changed  := False;
   ResultsForm.Changed := False;

   PIncoming := @Incoming;
   TempSetup:=Incoming;
   Ptr      := P;
   RateStuff:=InRate;
   ControlStuff := InControl;
   UpdateScreen;

   Update;
   Height := 870;
   If Not HasTox then
     Begin
       ToggleToxClick(nil);
       Height := 870-208;
     End;
   Update;
   If Height>Screen.WorkareaHeight-70 then Height := Screen.WorkareaHeight-70;
   Update;

   If ShowModal<>MrCancel then
     Begin
       {has the setup record changed?}
       If not  CompareMem(@Incoming, @TempSetup, SizeOf(Incoming)) then Changed := True;

       Incoming:=TempSetUp;
       //Changed:=True;
     End;

   IF RSetupForm.Changed then Changed:=True;
   InRate:=RateStuff;
   IF ControlForm.Changed then Changed:=True;
   InControl:=ControlStuff;
End;

{**********************}


Procedure TStudySetupDialog.UpdateScreen;
Var
  TempSt: ShortString;
Begin
   Updating := True;
   {Write in Dates}
   FirstDayEdit.Text:='  '+DateToStr(TempSetup.FirstDay);
   LastDayEdit.Text :='  '+DateToStr(TempSetup.LastDay);

   Str(TempSetup.StoreStepSize:6:2,TempSt);  StepSizeEDIT.Text:=TempSt;
   StepLabel.Caption:=FloatToStr(Minimum_StepSize);
   Str(TempSetup.RelativeError:6:4,TempSt);   RelErrEdit.Text:='  '+TempSt;

   Str(TempSetup.FixStepSize:6:3,TempSt);   FixedStepSizeEdit.Text:='  '+TempSt;

   Str(TempSetup.NtoPRatio:6:2,TempSt);  NtoPRatioEdit.Text:=TempSt;

   NutrientSpinBox.Checked := TempSetup.Spin_Nutrients;
   NutrientSpinBox.Enabled := TempSetup.Spinup_Mode;

   SaveBioRates.Checked := TempSetup.SaveBRates;
   DontSave.Checked := not TempSetup.SaveBRates;

   AvgOutput.Checked := TempSetup.AverageOutput;
   InstantOutput.Checked := not TempSetup.AverageOutput; 

   ShowIntBut.Checked := TempSetup.ShowIntegration;
   DontShowIntBut.Checked := not TempSetup.ShowIntegration;

   WriteHypo.Checked  := TempSetup.AlwaysWriteHypo;
   UseDissInBAF.Checked := TempSetup.UseComplexedInBAF;
   keeptoxconst.Checked := TempSetup.KeepDissToxConst;
   defaulttox.Checked := not (TempSetup.KeepDissToxConst);

   ModelInternally.Checked  := TempSetup.Internal_Nutrients;
   UseExternal.Checked := not TempSetup.Internal_Nutrients;

   UseExternalConcsbox.Checked := TempSetup.UseExternalConcs;
   UseInternal.Checked := not TempSetup.UseExternalConcs;

   FixedStepSize.Checked := TempSetup.UseFixStepSize;
   VarStepSize.Checked := not TempSetup.UseFixStepSize;
   RelErrLabel.Enabled := not TempSetup.UseFixStepSize;
   RelErrEdit.Enabled := not TempSetup.UseFixStepSize;
   StepLabel.Enabled := not TempSetup.UseFixStepSize;
   StepLabel2.Enabled := not TempSetup.UseFixStepSize;
   FixStepSizeLabel.Enabled := TempSetup.UseFixStepSize;
   FixedStepSizeEdit.Enabled := TempSetup.UseFixStepSize;

   BCFUptakebutt.Checked := TempSetup.BCFUptake;
   NormUptakeButt.Checked := not TempSetup.BCFUptake;

   Days.Checked := TempSetup.StepSizeInDays;
   Hours.Checked := Not TempSetup.StepSizeInDays;

   DailySim.Checked := TempSetup.ModelTSDays;
   HourlySim.Checked := Not TempSetup.ModelTSDays;

//   disablelipidbox.Checked := TempSetup.DisableLipidCalc;
   SpinModeBox.Checked := TempSetup.Spinup_Mode;

   NToPButton.Checked := TempSetup.NFix_UseRatio;
   NtoPRatioEdit.Enabled := NToPButton.Checked;
   RatioLabel.Enabled := NToPButton.Checked;

   Updating := False;
End;

{*********************************************************}

procedure TStudySetupDialog.CancelBtnClick(Sender: TObject);
Begin
     { If MessageDlg('Discard all edits?',mtConfirmation,mbOKCancel,0)=mrOK then  }
         StudySetupDialog.ModalResult:=MRCancel;
end;

procedure TStudySetupDialog.NumberConv(Sender: TObject);
Var
Conv: Double;
Result: Integer;

begin
  Val(Trim(TEdit(Sender).Text),Conv,Result);
  If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
    else begin
           case TEdit(Sender).Name[1] of
            'N': begin
                   TempSetup.NtoPRatio:=Conv;
                 end; {'N' in 'NtoPRatioEdit'}
            'S': begin
                   If (Conv<0.01)
                     then MessageDlg('Data Storage Step Size must be greater than 0.01',mterror,[mbOK],0)
                     else TempSetup.StoreStepSize:=Conv;
                 end; {'S'}
            'R': begin
                   TempSetup.RelativeError:=Conv;
                   If (Conv<0.0005) or (Conv>0.0101) then
                     MessageDlg('You have entered a value outside of the recommended range for Relative Error: (0.0005 to 0.01)',mtInformation,[mbOK],0)
                 end; {'R'}
            'F': begin
                   If (Conv>0.101) or (Conv<0.00999)
                     then MessageDlg('Fixed Step Size must be between 0.01 day and 0.1 day.',mtError,[mbOK],0)
                     else TempSetup.FixStepSize :=Conv;
                 end; {'R'}

           end; {case}
         end; {else}
  UpdateScreen;
end;




procedure TStudySetupDialog.ConvDate(Sender: TObject);
Var
  Conv: TDateTime;
begin
    Try
       Conv := StrToDate(TEdit(Sender).Text);
       case TEdit(Sender).Name[1] of
                      'F': TempSetup.FirstDay:=Conv;
                      'L': TempSetup.LastDay:=Conv;
                      end; {case}
    Except
       on EconvertError do MessageDlg('Incorrect Date Format Entered: Must be '+ShortDateFormat,mterror,[mbOK],0)
    End; {try Except}
    UpdateScreen;
end;


procedure TStudySetupDialog.EnableDisable(Sender: TObject);
begin
  If (TRadioButton(Sender).Name='SaveBioRates') or
     (TRadioButton(Sender).Name='DontSave') then
       If  SaveBioRates.Checked
           then TempSetup.SaveBRates := True
           else TempSetup.SaveBRates := False;

  If (TRadioButton(Sender).Name='ShowIntBut') or
     (TRadioButton(Sender).Name='DontShowIntBut') then
      if ShowIntBut.Checked
        then TempSetup.ShowIntegration := True
        else TempSetup.ShowIntegration := False;

  If (TRadioButton(Sender).Name='avgoutput') or
     (TRadioButton(Sender).Name='InstantOutput') then
       if AvgOutput.Checked
          then TempSetup.AverageOutput := True
          else TempSetup.AverageOutput := False;
end;

procedure TStudySetupDialog.FormCreate(Sender: TObject);
begin
  Height := 481
end;

procedure TStudySetupDialog.UncertButtClick(Sender: TObject);
Var SaveBRates: Boolean; {temporary holder so uncertainty screen reflects appropriate rates choice}
begin
   SaveBRates := PIncoming^.SaveBRates;
   PIncoming^.SaveBRates := TempSetup.SaveBRates;

   USetupForm.Edit_USetup;

   If (USetupForm.Changed) or (USetupForm.DistChanged) then Changed := True;
   PIncoming^.SaveBRates := SaveBRates;
end;

procedure TStudySetupDialog.RateSpecsButtonClick(Sender: TObject);
begin
  RSetupForm.Edit_RSetup(RateStuff, Ptr);
  If RSetupForm.Changed then Changed:=True;
end;

procedure TStudySetupDialog.ControlSetupButtonClick(Sender: TObject);
begin
  ControlForm.Edit_Control(ControlStuff, Ptr);
  If ControlForm.Changed then Changed:=True;
end;

procedure TStudySetupDialog.WriteHypoClick(Sender: TObject);
begin
  TempSetup.AlwaysWriteHypo:=WriteHypo.Checked;
  If Not Updating then UpdateScreen;
end;

procedure TStudySetupDialog.OutputSetupButtonClick(Sender: TObject);
begin
  ResultsForm.ResultsSetup((TempSetup.LastDay-TempSetup.FirstDay+2) / TempSetup.StoreStepSize );
  If ResultsForm.Changed then Changed := True;
end;

procedure TStudySetupDialog.ToggleToxClick(Sender: TObject);
begin
  If ToggleTox.Caption = 'show' then
    Begin
      ToggleTox.Caption := 'hide';
      ToxPanel.Height := 230;
      OutputPanel.Top := OutputPanel.Top+200;
      Scrollbox1.VertScrollbar.Range := ScrollBox1.VertScrollbar.Range + 200;
    End
 else
    Begin
      ToggleTox.Caption := 'show';
      ToxPanel.Height := 30;
      OutputPanel.Top := OutputPanel.Top-200;
      Scrollbox1.VertScrollbar.Range := ScrollBox1.VertScrollbar.Range - 200;
    End
end;

procedure TStudySetupDialog.usedissinBAFClick(Sender: TObject);
begin
  TempSetup.UseComplexedInBAF := UseDissInBAF.Checked;
  If Not Updating then UpdateScreen;
end;


procedure TStudySetupDialog.disablelipidboxClick(Sender: TObject);
begin
//  TempSetup.DisableLipidCalc := disablelipidbox.Checked;    // disabled 4/28/09
//  If Not Updating then UpdateScreen;
end;

procedure TStudySetupDialog.keeptoxconstboxClick(Sender: TObject);
begin
  TempSetup.KeepDissToxConst := keeptoxconst.Checked;
  If Not Updating then UpdateScreen;
end;

procedure TStudySetupDialog.ModelInternallyClick(Sender: TObject);
begin
  If Updating then exit;
  If TempSetup.Internal_Nutrients = ModelInternally.Checked then exit;
  TempSetup.Internal_Nutrients := ModelInternally.Checked;

  If TempSetup.Internal_Nutrients then
    Begin
      If MessageDlg('Modeling internal nutrients will add state variables for modeling N and P associated with each '+
                 'algal state variable and additional parameters in these plants’ underlying data will be utilized.  Proceed?',
                 MtConfirmation, [MBYes,MBNo], 0) = mrno
        Then TempSetup.Internal_Nutrients := FALSE;
    End
  else
    Begin
      If MessageDlg('You are selecting to no longer model internal nutrients.   Plants will be limited by their exposure to external nutrient concentrations. '+
      ' N and P state variables for algal groups will be removed. Proceed?',
                 MtConfirmation, [MBYes,MBNo], 0) = mrno
        Then TempSetup.Internal_Nutrients := TRUE;
    End;

  Updating := True;
  ModelInternally.Checked := TempSetup.Internal_Nutrients;
  Updating := False;

  UpdateScreen;
end;

procedure TStudySetupDialog.HelpButtonClick(Sender: TObject);
begin
   HTMLHelpContext('Topic32.htm');
end;

procedure TStudySetupDialog.UseInternalClick(Sender: TObject);
begin
  TempSetup.UseExternalConcs := UseExternalConcsBox.Checked;
  If Not Updating then UpdateScreen;
end;


procedure TStudySetupDialog.VarStepsizeClick(Sender: TObject);
begin
  TempSetup.UseFixStepSize := FixedStepSize.Checked;
  If Not Updating then UpdateScreen;
end;

procedure TStudySetupDialog.NormUptakeButtClick(Sender: TObject);
begin
  TempSetup.BCFUptake := BCFUptakeButt.Checked;
  If Not Updating then UpdateScreen;
end;

procedure TStudySetupDialog.NtoPButtonClick(Sender: TObject);
begin
  TempSetup.NFix_UseRatio := NtoPButton.Checked;
  If Not Updating then UpdateScreen;
end;

procedure TStudySetupDialog.DailySimClick(Sender: TObject);
begin
  TempSetup.ModelTSDays := DailySim.Checked;
  If Not Updating then UpdateScreen;
end;

procedure TStudySetupDialog.DaysClick(Sender: TObject);
begin
  TempSetup.StepSizeInDays := Days.Checked;
  If Not Updating then UpdateScreen;
end;

procedure TStudySetupDialog.OKBtnClick(Sender: TObject);
begin
  OKBtn.SetFocus;
end;

procedure TStudySetupDialog.SPINModeBoxClick(Sender: TObject);
begin
  TempSetup.Spinup_Mode := SPINModeBox.Checked;
  If Not Updating then UpdateScreen;
end;

procedure TStudySetupDialog.NutrientSpinBoxClick(Sender: TObject);
begin
  TempSetup.Spin_Nutrients := NutrientSpinBox.Checked;
  If Not Updating then UpdateScreen;
end;


end.
