//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit EditButtons;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Global, AQBaseForm, hh;

type
  TEditButtForm = class(TAQBase)
    OKBtn: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    ScrollBox1: TScrollBox;
    BMP1: TImage;
    Label2: TLabel;
    BMP0: TImage;
    Label3: TLabel;
    BMP2: TImage;
    Label4: TLabel;
    BMP3: TImage;
    Label5: TLabel;
    BMP4: TImage;
    Label6: TLabel;
    BMP5: TImage;
    Label7: TLabel;
    BMP6: TImage;
    Label8: TLabel;
    BMP7: TImage;
    Label9: TLabel;
    BMP8: TImage;
    Label10: TLabel;
    BMP9: TImage;
    Label11: TLabel;
    BMP10: TImage;
    Label12: TLabel;
    BMP11: TImage;
    Label13: TLabel;
    BMP12: TImage;
    Label14: TLabel;
    BMP13: TImage;
    Label15: TLabel;
    BMP14: TImage;
    Label16: TLabel;
    BMP15: TImage;
    Label17: TLabel;
    BMP16: TImage;
    Label18: TLabel;
    BMP17: TImage;
    Label19: TLabel;
    BMP18: TImage;
    Label20: TLabel;
    BMP19: TImage;
    Label21: TLabel;
    BMP20: TImage;
    Label22: TLabel;
    BMP21: TImage;
    Label23: TLabel;
    BMP22: TImage;
    Label24: TLabel;
    BMP23: TImage;
    Label25: TLabel;
    BMP24: TImage;
    Label26: TLabel;
    BMP25: TImage;
    Label27: TLabel;
    BMP26: TImage;
    Label28: TLabel;
    BMP27: TImage;
    Label29: TLabel;
    BMP28: TImage;
    Label30: TLabel;
    BMP29: TImage;
    Label31: TLabel;
    BMP30: TImage;
    Label32: TLabel;
    BMP31: TImage;
    Label33: TLabel;
    Label34: TLabel;
    SepX: TImage;
    Button1: TButton;
    HelpButton: TButton;
    BMP32: TImage;
    GenScnLabel: TLabel;
    BMP33: TImage;
    Label35: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    FormDone: Boolean;
    ButtonDeleted: Boolean;
    ButtonIndex: Integer;
    procedure Execute;
    { Public declarations }

  end;
var
  EditButtForm: TEditButtForm;

implementation

{$R *.DFM}

Procedure TEditButtForm.Execute;
Begin
  FormDone := False;
  ButtonDeleted := False;
  Show;
  Repeat
    Application.ProcessMessages;
  Until FormDone or ButtonDeleted;
  If FormDone then Hide;

End;

procedure TEditButtForm.OKBtnClick(Sender: TObject);
begin
  FormDone := True;
end;

procedure TEditButtForm.FormDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
{  TControl(sender).Cursor := CrDrag; }
end;

procedure TEditButtForm.Image1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := Source is TToolButton;
end;

procedure TEditButtForm.Image1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  ButtonIndex := TToolButton(Source).Index;
  ButtonDeleted := True;
end;

procedure TEditButtForm.Button1Click(Sender: TObject);
begin
  ButtonIndex := -1;
  ButtonDeleted := True;
end;

procedure TEditButtForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic75.htm');
end;

procedure TEditButtForm.FormShow(Sender: TObject);
begin
  BMP32.Visible := GenScnInstalled;
  GenScnLabel.Visible := GenScnInstalled;
end;

end.
