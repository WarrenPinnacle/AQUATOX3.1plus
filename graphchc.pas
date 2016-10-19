//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
{ Form Template - Source and Destination Choices Lists }
unit Graphchc;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, SysUtils, hh;

type
  TGraphChoiceDlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel3: TPanel;
    IncludeBtn: TSpeedButton;
    ExcludeBtn: TSpeedButton;
    ExAllBtn: TSpeedButton;
    SourceList: TListBox;
    DstList: TListBox;
    IncAllBtn: TSpeedButton;
    Panel1: TPanel;
    SrcLabel: TLabel;
    Panel2: TPanel;
    DstLabel: TLabel;
    GenScnButton: TBitBtn;
    filterpanel: TPanel;
    FilterButt: TRadioButton;
    SubStrEdit: TEdit;
    ShowAllButt: TRadioButton;
    ExcludeBox: TCheckBox;
    HelpButt: TButton;
    procedure IncludeBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure IncAllBtnClick(Sender: TObject);
    procedure ExcAllBtnClick(Sender: TObject);
    procedure MoveSelected(List: TCustomListBox; Items: TStrings);
    procedure SetItem(List: TListBox; Index: Integer);
    function GetFirstSelection(List: TCustomListBox): Integer;
    procedure SetButtons;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure SubStrEditChange(Sender: TObject);
    procedure ShowAllButtClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HelpButtClick(Sender: TObject);
  private
    { Private declarations }
  public
    MasterList: TStringList;
    procedure UpdateScreen;
    { Public declarations }
  end;

var
  GraphChoiceDlg : TGraphChoiceDlg;
  DlgChanged     : Boolean;

implementation

{$R *.DFM}

procedure TGraphChoiceDlg.UpdateScreen;
Var i, j: integer;
    found: boolean;
    substr, headstr: String;

    Procedure AddToList;
    Begin
      SourceList.Items.Add(MasterList[i]);
    End;
Begin
  SourceList.Clear;
  For i := 0 to MasterList.Count-1 do
    Begin
      found := False;
      For j:=0 to DstList.Items.Count-1 do
        If MasterList[i] = DstList.Items[j] then found := true;

      If Not Found then
         If ShowAllButt.Checked then AddToList
          else
             Begin
                SubStr := Uppercase(Trim(SubStrEdit.Text));
                HeadStr := Uppercase(MasterList[i]);
                If SubStr = ''
                  then AddToList
                  else If (ExcludeBox.Checked) and (Pos(SubStr,HeadStr)=0) then AddToList
                  else If (not ExcludeBox.Checked) and (Pos(SubStr,HeadStr)>0) then AddToList;
             End;
    End;
  SetButtons;
End;

procedure TGraphChoiceDlg.IncludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  DlgChanged := True;
  Index := GetFirstSelection(SourceList);
  MoveSelected(SourceList, DstList.Items);
  SetItem(SourceList, Index);
end;

procedure TGraphChoiceDlg.ExcludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  DlgChanged := True;
  Index := GetFirstSelection(DstList);
  MoveSelected(DstList, SourceList.Items);
  SetItem(DstList, Index);
  UpdateScreen;
end;

procedure TGraphChoiceDlg.IncAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  DlgChanged := True;
  for I := 0 to SourceList.Items.Count - 1 do
    DstList.Items.AddObject(SourceList.Items[I],
      SourceList.Items.Objects[I]);
  SourceList.Items.Clear;
  SetItem(SourceList, 0);
end;

procedure TGraphChoiceDlg.ExcAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  DlgChanged := True;
  for I := 0 to DstList.Items.Count - 1 do
    SourceList.Items.AddObject(DstList.Items[I], DstList.Items.Objects[I]);
  DstList.Items.Clear;
  SetItem(DstList, 0);
  UpdateScreen;
end;

procedure TGraphChoiceDlg.MoveSelected(List: TCustomListBox; Items: TStrings);
var
  I: Integer;
begin
  for I := List.Items.Count - 1 downto 0 do
    if List.Selected[I] then
    begin
      Items.AddObject(List.Items[I], List.Items.Objects[I]);
      List.Items.Delete(I);
    end;
end;

procedure TGraphChoiceDlg.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := SourceList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  IncludeBtn.Enabled := not SrcEmpty;
  IncAllBtn.Enabled := not SrcEmpty;
  ExcludeBtn.Enabled := not DstEmpty;
  ExAllBtn.Enabled := not DstEmpty;
end;

function TGraphChoiceDlg.GetFirstSelection(List: TCustomListBox): Integer;
begin
  for Result := 0 to List.Items.Count - 1 do
    if List.Selected[Result] then Exit;
  Result := LB_ERR;
end;

procedure TGraphChoiceDlg.SetItem(List: TListBox; Index: Integer);
var
  MaxIndex: Integer;
begin
  with List do
  begin
    SetFocus;
    MaxIndex := List.Items.Count - 1;
    if Index = LB_ERR then Index := 0
    else if Index > MaxIndex then Index := MaxIndex;
    Selected[Index] := True;
  end;
  SetButtons;
end;

procedure TGraphChoiceDlg.FormShow(Sender: TObject);
begin
  Height         := Screen.Height - 80;
{  SrcList.Height := Height - 137;
  DstList.Height := Height - 137;
  GenScnButton.Top      := Height - 62;
  OKBtn.Top      := Height - 62;
  CancelBtn.Top  := Height - 62;
  Panel3.height  := Height - 90; }
  UpdateScreen;
  SetButtons;
  DlgChanged := False
end;


procedure TGraphChoiceDlg.OKBtnClick(Sender: TObject);
begin
  OKBtn.SetFocus;

  If DlgChanged then ModalResult:=MrOK
                else ModalResult:=MrCancel;

end;

procedure TGraphChoiceDlg.SubStrEditChange(Sender: TObject);
begin
  UpdateScreen;
  FilterButt.checked := True;
end;

procedure TGraphChoiceDlg.ShowAllButtClick(Sender: TObject);
begin
  UpdateScreen;
end;

procedure TGraphChoiceDlg.FormCreate(Sender: TObject);
begin
  MasterList := TStringList.Create;
end;

procedure TGraphChoiceDlg.HelpButtClick(Sender: TObject);
begin
   If GenScnButton.Visible
     then HTMLHelpContext('Exporting_Results.htm')
     else HTMLHelpContext('Selecting_Output.htm');
end;

end.
