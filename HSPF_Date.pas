//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit HSPF_Date;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, AQBaseForm;

type
  THSPFDate = class(TAQBase)
    Label1: TLabel;
    Date1: TLabel;
    Label3: TLabel;
    Date2: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    FirstDayEdit: TEdit;
    LastDayEdit: TEdit;
    Label7: TLabel;
    OKBtn: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    StartDate, EndDate: TDateTime;
    Procedure SelectRange(Var SD,ED: TDateTime);
    { Public declarations }
  end;

var
  HSPFDate: THSPFDate;

implementation

Procedure THSPFDate.SelectRange(Var SD,ED: TDateTime);
Begin
  StartDate := SD;
  EndDate := ED;

  FirstDayEdit.Text:=' '+DateToStr(SD);
  LastDayEdit.Text :=' '+DateToStr(ED);
  Date1.Caption := DateToStr(SD);
  Date2.Caption := DateToStr(ED);

  ShowModal;

  SD := StartDate;
  ED := EndDate;

End;




{$R *.DFM}

procedure THSPFDate.OKBtnClick(Sender: TObject);
Var ReadStart,ReadEnd: TDateTime;
begin

    Try
       ReadStart := StrToDate(FirstDayEdit.Text);
       ReadEnd   := StrToDate(LastDayEdit.Text);
    Except
       MessageDlg('Incorrect Date Format Entered: Must be '+ShortDateFormat,mterror,[mbOK],0);
       Exit;
    End; {try Except}

    If ReadStart>=ReadEnd then
      Begin
        MessageDlg('The end date must occur after the start date',mterror,[mbOK],0);
        Exit;
      End;

    If ReadStart+1<StartDate then
      Begin
        MessageDlg('The start date you entered occurs before the HSPF loadings start',mterror,[mbOK],0);
        Exit;
      End;

    If ReadEnd>EndDate then
      Begin
        MessageDlg('The end date you entered occurs after the HSPF loadings end',mterror,[mbOK],0);
        Exit;
      End;

    EndDate := ReadEnd;
    StartDate := ReadStart;
    ModalResult := MROK

end;

end.
