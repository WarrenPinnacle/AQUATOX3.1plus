//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wait;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls;

type
  TWaitDlg = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Shape1: TShape;
    Delay1: TShape;
    Delay2: TShape;
    Delay3: TShape;
    Delay4: TShape;
    Delay5: TShape;
    Bevel1: TBevel;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    Status: Integer;
    Procedure Setup(T: String);
    Procedure Tease;
  end;

var
  WaitDlg: TWaitDlg;
  OldCursor: TCursor;
  LastTease: TDateTime;

implementation

Procedure TWaitDlg.Setup(T: String);
Begin
  Label1.Caption:=T;
  Delay1.Brush.Color:=ClNavy;
  Delay2.Brush.Color:=ClNavy;
  Delay3.Brush.Color:=ClNavy;
  Delay4.Brush.Color:=ClNavy;
  Delay5.Brush.Color:=ClNavy;
  Show;
  Update;
  Status:=1;
End;

Procedure TWaitDlg.Tease;
Begin
  If not WaitDlg.Visible then exit;

  If Now-LastTease<0.35e-5  {only tease four times each second}
    then exit
    else LastTease := Now;

  Application.ProcessMessages;    

  Case Status of
    1: Delay1.Brush.Color:=ClWhite;
    2: Delay2.Brush.Color:=ClWhite;
    3: Delay3.Brush.Color:=ClWhite;
    4: Delay4.Brush.Color:=ClWhite;
    5: Delay5.Brush.Color:=ClWhite;
    6: Delay1.Brush.Color:=ClNavy;
    7: Delay2.Brush.Color:=ClNavy;
    8: Delay3.Brush.Color:=ClNavy;
    9: Delay4.Brush.Color:=ClNavy;
    10: Delay5.Brush.Color:=ClNavy;
  End;

  Inc(Status);
  If Status=11 then
    Begin
      Status:=1;
      Application.ProcessMessages;
      Show;
    End;

  Update;
End;

{$R *.DFM}

procedure TWaitDlg.FormShow(Sender: TObject);
begin
  If Screen.Cursor <> crHourGlass then OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
end;

procedure TWaitDlg.FormHide(Sender: TObject);
begin
  Screen.Cursor := OldCursor;
end;

Begin
  LastTease := Now;
end.


