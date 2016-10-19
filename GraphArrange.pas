
//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
unit GraphArrange;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Global,
     Buttons, ExtCtrls,Aquaobj, AQBaseForm, HH, Observed_Data;

Type PAV = ^AllVariables;

type
  TGraphArrangeForm = class(TAQBase)
    OKBtn: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    ListBox1: TListBox;
    RenameEdit: TEdit;
    Label2: TLabel;
    UpBtn: TBitBtn;
    DownBtn: TBitBtn;
    DelButton: TButton;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ListBox1StartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListBox1Click(Sender: TObject);
    procedure RenameEditChange(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DownBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    SVPtr: TStateVariable;
    SpecPtr: PAV;
    IsPlantSpec: Boolean;
    ID: Integer;
    Order: Array of Integer;
    InitCond: Array of TGraphSetup;
    Procedure ArrangeGraphs(GSR: TGraphs);

    { Public declarations }
  end;

var
  GraphArrangeForm: TGraphArrangeForm;

implementation

uses math;

{$R *.DFM}

procedure TGraphArrangeForm.ArrangeGraphs;
Var i: Integer;
Begin
  SetLength(InitCond,GSR.NumGraphs);
  For i := 0 to GSR.NumGraphs-1 do
    InitCond[i] := GSR.GArray[i];

  For i := 0 to GSR.NumGraphs-1 do
    Begin
      If Order[i]<0 then
        Begin
          GSR.GArray[i] := InitCond[(-Order[i]) -1];
          GSR.DeleteGraph(i+1);
        End
      else
        Begin
          GSR.GArray[i] := InitCond[Order[i]-1];
          GSR.GArray[i].data.GraphName := ListBox1.Items[i];
        End;
    End;

End;

procedure TGraphArrangeForm.DelButtonClick(Sender: TObject);
Var i, ii, svo: Integer;
begin
  ii := ListBox1.ItemIndex;
  If ii = -1 then exit;
  svo := Order[ii];
  ListBox1.Items.Delete(ii);
  For i := ii to ListBox1.Count-1 do
    Order[i] := Order[i+1];
  Order[ListBox1.Count] := -svo;
  If ii > ListBox1.Count-1 then ListBox1.ItemIndex := ListBox1.Count-1
                           else ListBox1.ItemIndex := ii;
  ListBox1Click(nil);

end;

procedure TGraphArrangeForm.DownBtnClick(Sender: TObject);
Var svo,ii: Integer;

begin
 With ListBox1 do
   Begin
     ii := ItemIndex;
     If (ItemIndex > Count-2) or (ItemIndex<0) then exit;
     With ListBox1 do
       items.move(ItemIndex,ItemIndex+1);

     svo := Order[ii];
     Order[ii] := Order[ii+1];
     Order[ii+1] := svo;

     Listbox1.itemindex:=ii+1;
   End;
end;

procedure TGraphArrangeForm.FormDestroy(Sender: TObject);
begin
  Order := nil;
end;

procedure TGraphArrangeForm.FormShow(Sender: TObject);
Var i: Integer;
begin
  SetLength(Order,ListBox1.Count);
  For i := 1 to ListBox1.Count do
    Order[i-1] := i;
  ListBox1.dragmode:=dmAutomatic;
  ListBox1.ItemIndex := 0;
  ListBox1Click(nil);
end;

procedure TGraphArrangeForm.ListBox1Click(Sender: TObject);
begin
  If ListBox1.ItemIndex < 0 then exit;
  RenameEdit.Text := ListBox1.Items[ListBox1.ItemIndex];
end;

procedure TGraphArrangeForm.ListBox1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
Var InsertIndex,svo,i: Integer;
begin
 InsertIndex := listbox1.itemAtPos(point(x,y),false);
 If InsertIndex > ListBox1.Count-1 then InsertIndex := ListBox1.Count-1;
 If InsertIndex >=0 then
  begin
    listbox1.items.move(ID, InsertIndex);

    If ID < InsertIndex then
      Begin
        svo := Order[ID];
        For i := ID to InsertIndex-1 do
          Order[i] := Order [i+1];
        Order[InsertIndex] := svo;
      End
    else
      Begin
        svo := Order[ID];
        For i := ID downto InsertIndex+1 do
          Order[i] := Order [i-1];
        Order[InsertIndex] := svo;
      End;

    listbox1.itemindex:=InsertIndex;
  end;
end;

procedure TGraphArrangeForm.ListBox1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := True;
end;

procedure TGraphArrangeForm.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_Delete then DelButtonClick(nil);
end;

procedure TGraphArrangeForm.ListBox1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
    ID :=Listbox1.itemindex;
end;

procedure TGraphArrangeForm.RenameEditChange(Sender: TObject);
begin
  If ListBox1.ItemIndex = -1 then Exit;
  ListBox1.Items[ListBox1.ItemIndex] := RenameEdit.Text;
end;

procedure TGraphArrangeForm.UpBtnClick(Sender: TObject);
Var ii, svo: Integer;
begin
 If ListBox1.ItemIndex < 1 then exit;
 ii := ListBox1.ItemIndex;
 With ListBox1 do
   Begin
     items.move(ItemIndex,ItemIndex-1);

     svo := Order[ii];
     Order[ii] := Order[ii-1];
     Order[ii-1] := svo;

     itemindex := ii-1;
   End;
end;

end.
