//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit RateScrn;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Global, AquaObj, Dialogs, FileCtrl;

type
  TRSetupForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    IncludeBtn: TSpeedButton;
    IncAllBtn: TSpeedButton;
    ExcludeBtn: TSpeedButton;
    ExAllBtn: TSpeedButton;
    SrcList: TListBox;
    DstList: TListBox;
    Label1: TLabel;
    procedure IncludeBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure IncAllBtnClick(Sender: TObject);
    procedure ExcAllBtnClick(Sender: TObject);
    procedure MoveSelected(List: TCustomListBox; Items: TStrings);
    procedure SetItem(List: TListBox; Index: Integer);
    function GetFirstSelection(List: TCustomListBox): Integer;
    procedure SetButtons;
    procedure OKBtnClick(Sender: TObject);
  private
    SV : TStates;
    Procedure UpdateScreen;
    Procedure WriteSVs;
    Procedure ReadSVs;
  public
    TempRRecord : RateInfoType;
    Changed    : Boolean;
    Procedure Edit_RSetup(Var InRate: RateInfoType; PS: Pointer);
  end;

var
  RSetupForm: TRSetupForm;

implementation

{$R *.DFM}

procedure TRSetupForm.IncludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Changed := True;
  Index := GetFirstSelection(SrcList);
  MoveSelected(SrcList, DstList.Items);
  SetItem(SrcList, Index);
end;


procedure TRSetupForm.ExcludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Changed := True;
  Index := GetFirstSelection(DstList);
  MoveSelected(DstList, SrcList.Items);
  SetItem(DstList, Index);
end;

procedure TRSetupForm.IncAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  Changed := True;
  for I := 0 to SrcList.Items.Count - 1 do
    DstList.Items.AddObject(SrcList.Items[I], 
      SrcList.Items.Objects[I]);
  SrcList.Items.Clear;
  SetItem(SrcList, 0);
end;

procedure TRSetupForm.ExcAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  Changed := True;
  for I := 0 to DstList.Items.Count - 1 do
    SrcList.Items.AddObject(DstList.Items[I], DstList.Items.Objects[I]);
  DstList.Items.Clear;
  SetItem(DstList, 0);
end;

procedure TRSetupForm.MoveSelected(List: TCustomListBox; Items: TStrings);
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

procedure TRSetupForm.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := SrcList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  IncludeBtn.Enabled := not SrcEmpty;
  IncAllBtn.Enabled := not SrcEmpty;
  ExcludeBtn.Enabled := not DstEmpty;
  ExAllBtn.Enabled := not DstEmpty;
end;

function TRSetupForm.GetFirstSelection(List: TCustomListBox): Integer;
begin
  for Result := 0 to List.Items.Count - 1 do
    if List.Selected[Result] then Exit;
  Result := LB_ERR;
end;

procedure TRSetupForm.SetItem(List: TListBox; Index: Integer);
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

Procedure TRSetupForm.UpdateScreen;
Begin
 With TempRRecord do
 Begin
  SetButtons;
  WriteToMemory := True;
 End;
End;


Procedure TRSetupForm.WriteSVs;
Var i: Integer;
    PS: TStateVariable;
    Txt: String;
Begin
  SrcList.Clear;
  DstList.Clear;
  For i:= 0 to SV.Count-1 do
    Begin
      PS  := SV.At(i);
      Txt := OutputText(PS.Nstate,PS.SVType,PS.Layer,'',False,False,0);
      If not (Txt='Undisplayed') then
        If PS.PShowRates^ then DstList.Items.Add(Txt)
                           else SrcList.Items.Add(Txt)
    End;
End;

Procedure TRSetupForm.ReadSVs;
Var i,j: Integer;
    PS: TStateVariable;
    Txt: String;
Begin
  For i:= 0 to SV.Count-1 do
    Begin
      PS  := SV.At(i);
      PS.PShowRates^:=False;
      Txt := OutputText(PS.Nstate,PS.SVType,PS.Layer,'',False,False,0);
      For j := 1 to DstList.Items.Count do
        If (DstList.Items.Strings[j-1] = Txt) then PS.PShowRates^:=True;
    End;
End;



Procedure TRSetupForm.Edit_RSetup(Var InRate: RateInfoType; PS: Pointer);
Begin
  Changed:=False;
  TempRRecord:=InRate;
  SV := TStates(PS);
  WriteSVs;
  UpdateScreen;

  If ShowModal<>MrCancel
    Then
      Begin
        InRate:=TempRRecord;
        ReadSVs;
      End
    Else Changed:=False;
End;


procedure TRSetupForm.OKBtnClick(Sender: TObject);
begin
   OKBtn.SetFocus;

end;

end.
