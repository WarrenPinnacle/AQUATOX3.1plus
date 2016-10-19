//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit getfishage;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs;

type
  TGetFishForm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Bevel2: TBevel;
    Label3: TLabel;
    FishName: TEdit;
    procedure OKBtnClick(Sender: TObject);
  private

    { Private declarations }
  public
    Function RetFishAge: Integer;
    { Public declarations }
  end;

var
  GetFishForm: TGetFishForm;
    TextValue: Integer;  

implementation

{$R *.DFM}

Function TGetFishForm.RetFishAge: Integer;
Begin
  RetFishAge := 0;
  If ShowModal = MrCancel then exit;
  RetFishAge := TextValue;
End;


procedure TGetFishForm.OKBtnClick(Sender: TObject);
Var Conv: Double;  Result: Integer;
Begin
    Val(Trim(Edit1.Text),Conv,Result);
    Conv:=Abs(Conv);
    If Result<>0 then
        Begin
          MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0);
          Exit;
        End;

    TextValue := Trunc(Conv);

    If (TextValue<3) or (TextValue>15) then
        Begin
          MessageDlg('Age must be between 3 and 15',mterror,[mbOK],0);
          Exit;
        End;

    ModalResult := MrOK;

end;

end.
