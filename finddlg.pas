//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
unit Finddlg;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, DBGrids2 ;

type
  TSearchDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    SubStrEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    SearchType: TLabel;
    SourceList: TListBox;
    ItemCaption: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure SubStrEditChange(Sender: TObject);
    procedure SourceListClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SourceListDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    SearchArray: Array of String;    { Public declarations }
    ResultItem, NItems: Integer;
    ReturnString: String;
    procedure UpdateScreen;
    Procedure GetColumnFromDB(DBG: TDBGrid2; FieldN: Integer);
  end;

var
  SearchDialog: TSearchDialog;


implementation

Uses Sysutils, DBTables, DB;

{$R *.DFM}

procedure TSearchDialog.CancelBtnClick(Sender: TObject);
begin
     ResultItem := -1;
     ReturnString := '';
end;

procedure TSearchDialog.SourceListClick(Sender: TObject);
begin
  OKBtn.Enabled := (SourceList.ItemIndex >= 0);

end;

procedure TSearchDialog.SourceListDblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
  If ResultItem > -1 then ModalResult:=MROK;
end;

procedure TSearchDialog.SubStrEditChange(Sender: TObject);
begin
  UpdateScreen;
end;


procedure TSearchDialog.FormDestroy(Sender: TObject);
begin
  SearchArray := nil;
end;

procedure TSearchDialog.FormShow(Sender: TObject);
begin
  UpdateScreen;
end;

procedure TSearchDialog.GetColumnFromDB(DBG: TDBGrid2; FieldN: Integer);
Var qry   : TQuery ;  // Query related to dbgrd
    BookMark  : TBookMark ; // Bookmark for query

begin
//   qry := nil ;
//   BookMark := nil ;

    qry := TQuery(TDataSource(DBG.DataSource).DataSet) ;
    if qry.Active = False then exit ;
    if qry.RecordCount < 1 then exit ;

     qry.DisableControls ;
     BookMark := qry.GetBookmark ;
     qry.First ;

     SetLength(SearchArray,100);
     NItems := 0;
     // Insert data into array
     while not qry.EOF do
       begin
          Inc(NItems);
          if NItems > Length(SearchArray) then SetLength(SearchArray,NItems*2);

          SearchArray[NItems-1] := qry.Fields[FieldN].AsString;
          qry.Next;
       end;

     qry.GotoBookmark(BookMark) ;
     qry.FreeBookmark(BookMark) ;
//     BookMark := nil;
     qry.EnableControls ;

end;

procedure TSearchDialog.OKBtnClick(Sender: TObject);
Var i: Integer;
    SelStr: String;
begin
   ResultItem := -1;
   If SourceList.ItemIndex<0 then exit;
   SelStr := SourceList.Items[SourceList.ItemIndex];

  For i := 0 to NItems - 1 do
    if Searcharray[i] = SelStr then
      Begin
        ResultItem := i;
        ReturnString := SelStr;
        Exit;
      End;
end;

procedure TSearchDialog.UpdateScreen;
Var Substr: String;
    Addit: Boolean;
    i: Integer;
begin
  SubStr := Uppercase(Trim(SubStrEdit.Text));
  Sourcelist.Clear;
  For i := 0 to NItems - 1 do
    Begin
      If SearchArray[i] = ''
        then Addit := False
        else If SubStr = ''
          then Addit := True
          else Addit := Pos(SubStr,Uppercase(SearchArray[i])) > 0;

      if Addit then SourceList.Items.Add(SearchArray[i]);
    End;

  If SourceList.Items.Count = 1 then SourceList.Selected[0] := True
                                else SourceList.ItemIndex := -1;

  Update;
  OKBtn.Enabled := (SourceList.ItemIndex >= 0);
end;

end.
