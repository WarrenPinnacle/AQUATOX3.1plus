//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls, WizGlobal;

type
  TWizBase2 = class(TWizBase)
    Label1: TLabel;
    Label2: TLabel;
    StartDateEdit: TEdit;
    EndDateEdit: TEdit;
    DateFormatLabel: TLabel;
    Bevel1: TBevel;
    procedure DateEditExit(Sender: TObject);
  private
    { Private declarations }
  public
    Function  ExecuteScreen: WizOutput; override;
    Procedure UpdateScreen;
    Function  DataFinished: Boolean;

    { Public declarations }
  end;

var
  WizBase2: TWizBase2;


implementation

{$R *.DFM}


Function TWizBase2.DataFinished: Boolean;
Begin
  DataFinished := W2_StartEdited and W2_EndEdited;
End;

Procedure TWizBase2.UpdateScreen;
Begin
   DateFormatLabel.Caption := 'Date Format is '+ShortDateFormat;
   If (WizStatus<>0) or W2_StartEdited then StartDateEdit.Text := '  '+DateToStr(WizStudy.PSetup.FirstDay)
                                    else StartDateEdit.Text := '';
   If (WizStatus<>0) or W2_EndEdited   then EndDateEdit.Text   := '  '+DateToStr(WizStudy.PSetup.LastDay)
                                    else EndDateEdit.Text   := '';
End;

Function  TWizBase2.ExecuteScreen: WizOutput;
Begin
  If FirstVisit then
    Begin
      W2_StartEdited := False;
      W2_EndEdited := False;
    End;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (W2_StartEdited and W2_EndEdited) then WizStatus := 2;
  If (WizStatus=1) and (W2_StartEdited or W2_EndEdited) then WizStatus := 2;
End;


Procedure TWizBase2.DateEditExit(Sender: TObject);
Var
  Conv: TDateTime;
begin
    Try
       If Trim(TEdit(Sender).Text)='' then Exit;
       Conv := StrToDate(TEdit(Sender).Text);
       case TEdit(Sender).Name[1] of
                      'S': Begin
                             If (WizStudy.PSetup.FirstDay<>Conv) or (WizStatus=0) then W2_StartEdited := True;
                             WizStudy.PSetup.FirstDay:=Conv;
                           End;
                      'E': Begin
                             If (WizStudy.PSetup.LastDay<>Conv) or (WizStatus=0) then W2_EndEdited := True;
                             WizStudy.PSetup.LastDay:=Conv;
                           End;
                      end; {case}
    Except
       on EconvertError do MessageDlg('Incorrect Date Format Entered: Must be '+ShortDateFormat,mterror,[mbOK],0)
    End; {try Except}
    UpdateScreen;
end;

end.
