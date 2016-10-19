//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Remin;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBTables, DB, StdCtrls, Mask, DBCtrls, ExtCtrls,
  PrintFrm,Printing, FindDlg, Librarys, AQBaseForm, hh, Grids, dbgrids2;

type
  TRemineralization = class(TPrintingForm)
    SaveButton: TButton;
    CancelButton: TButton;
    DBNavigator1: TDBNavigator;
    DataSource1: TDataSource;
    Table1: TTable;
    PrintButton: TButton;
    PrintDialog1: TPrintDialog;
    savelib: TButton;
    LoadButton: TButton;
    ScrollBox1: TScrollBox;
    Label5: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label23: TLabel;
    Label32: TLabel;
    Label18: TLabel;
    Bevel2: TBevel;
    Label31: TLabel;
    Label33: TLabel;
    Label25: TLabel;
    Label9: TLabel;
    Label29: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label22: TLabel;
    Label13: TLabel;
    Label35: TLabel;
    Label37: TLabel;
    DBEdit10: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit25: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit26: TDBEdit;
    DBEdit28: TDBEdit;
    DBEdit29: TDBEdit;
    DBEdit33: TDBEdit;
    DBEdit38: TDBEdit;
    DBEdit41: TDBEdit;
    FindButton: TButton;
    NewButton: TButton;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    Label1: TLabel;
    Label36: TLabel;
    Label34: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    DBEdit22: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    DBEdit27: TDBEdit;
    HelpButton: TButton;
    Label38: TLabel;
    Label17: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    DBEdit8: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit44: TDBEdit;
    DBEdit45: TDBEdit;
    DBEdit46: TDBEdit;
    DBEdit47: TDBEdit;
    DBEdit48: TDBEdit;
    DBEdit49: TDBEdit;
    DBEdit50: TDBEdit;
    DBEdit51: TDBEdit;
    Label20: TLabel;
    Label21: TLabel;
    Label24: TLabel;
    Label47: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    DBEdit32: TDBEdit;
    DBEdit35: TDBEdit;
    DBEdit36: TDBEdit;
    DBEdit37: TDBEdit;
    DBEdit39: TDBEdit;
    DBEdit40: TDBEdit;
    DBEdit42: TDBEdit;
    DBEdit43: TDBEdit;
    parmwarning: TLabel;
    Label28: TLabel;
    Label30: TLabel;
    Label39: TLabel;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    Label41: TLabel;
    Label40: TLabel;
    Label48: TLabel;
    DBEdit15: TDBEdit;
    DBEdit31: TDBEdit;
    Label14: TLabel;
    Label4: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    DBEdit5: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit30: TDBEdit;
    DBEdit34: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit9: TDBEdit;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    DBEdit52: TDBEdit;
    DBEdit53: TDBEdit;
    DBEdit54: TDBEdit;
    DBEdit55: TDBEdit;
    DBEdit56: TDBEdit;
    DBEdit57: TDBEdit;
    Label64: TLabel;
    Label63: TLabel;
    Label65: TLabel;
    GridButt: TButton;
    Grid: TDBGrid2;
    ExportExcel: TButton;
    Label66: TLabel;
    procedure FindButtonClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure CancelButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure RetHandle2(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure savelibClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    
    procedure GridButtClick(Sender: TObject);
    procedure ExportExcelClick(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
  public
    changed: boolean;
    { Public declarations }
  end;

var
  Remineralization: TRemineralization;

implementation

uses DBEntry, ExcelFuncs, Excel2000, WAIT;


procedure TRemineralization.AppException(Sender: TObject; E: Exception);
begin
   If E.Message='Key violation.' then  {multiple name error message}
      MessageDlg('A Remin Record of that Name Already Exists, Please Give Your Entry a New Name',mtError,[mbOK],0)
   else
   Application.ShowException(E);      {mainly handles invalid # format}
end;


procedure TRemineralization.CancelButtonClick(Sender: TObject);
begin
   If MessageDlg('Discard all edits?',mtConfirmation,mbOKCancel,0)=mrOK then
   Remineralization.ModalResult:=MRCancel;
end;

procedure TRemineralization.SaveButtonClick(Sender: TObject);
begin
      if table1.State in [dsedit,dsinsert] then table1.Post;
      If SaveButton.Caption = '&OK' then
        Remineralization.ModalResult:=MROK
        else If MessageDlg('Save changes and exit?',mtConfirmation,mbOKCancel,0)=mrOK then
           Remineralization.ModalResult:=MROK;
end;

{THE FOLLOWING PROCEDURE HANDLES THE EVENT WHEN THE USER PRESSES RETURN.
 SEE CHEM.PAS}
procedure TRemineralization.RetHandle2(Sender: TObject; var Key: Char);
begin
    Changed := True;
      If Key=#13 then if table1.State in [dsedit,dsinsert] then
       begin      {enables return key}
         Tdbedit(sender).enabled:=false;
         Tdbedit(sender).enabled:=true;
         table1.Post;
       end; {if}
end;

procedure TRemineralization.FormResize(Sender: TObject);
begin
    ScrollBox1.Height:=Remineralization.ClientHeight-49;
    ScrollBox1.Width:=Remineralization.ClientWidth+2;

    Grid.Height:=Remineralization.ClientHeight-59;
    Grid.Width:=Remineralization.ClientWidth+2;

end;

procedure TRemineralization.FormCreate(Sender: TObject);
begin
   inherited;
   Application.OnException:=AppException;
   Changed := False;;
end;


procedure TRemineralization.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  If Grid.Visible then Grid.Perform(WM_VSCROLL,1,0)
                  else ScrollBox1.Perform(WM_VSCROLL,1,0);

end;

procedure TRemineralization.FormMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  If Grid.Visible then Grid.Perform(WM_VSCROLL,0,0)
                  else ScrollBox1.Perform(WM_VSCROLL,0,0);

end;

procedure TRemineralization.PrintButtonClick(Sender: TObject);
var old_win_height,old_win_top,old_win_left,old_win_width,
    old_sb_height,old_sb_top,old_sb_left,old_sb_width,
    old_sb_vsb_position: longint;
    LBV: Boolean;
    SCROLLBOXHEIGHT: INTEGER;

begin
  If Not PrintDialog1.Execute then exit;
  SCROLLBOXHEIGHT := Scrollbox1.Vertscrollbar.Range;

  Application.CreateForm(TPrintCoverForm, PrintCoverForm);
  PrintCoverForm.Gauge1.Progress:=0;
  PrintCoverForm.Show;
  {Save Window Position}
  old_win_height:=height;
  old_win_top:=top;
  old_win_left:=Left;
  old_win_width:=Width;
  old_sb_height:=Scrollbox1.Height;
  old_sb_top:=Scrollbox1.Top;
  old_sb_left:=Scrollbox1.Left;
  old_sb_width:=Scrollbox1.Width;
  old_sb_vsb_position:=Scrollbox1.VertScrollBar.Position;

  {Set up Screen for Printing}
  Scrollbox1.Align:=alNone;

  {Hide Upper Buttons}
  GridButt.Visible := False;
  ExportExcel.Visible := False;

  PrintButton.Visible:=False;
  DBNAVIGATOR1.VISIBLE:=False;
  SAVEBUTTON.VISIBLE:=False;
  CancelButton.VISIBLE:=False;
  LBV:=LoadButton.Visible;
  LoadButton.Visible:=False;
  SaveLib.Visible:=False;

  Top:=0;
  Left:=0;
  Width:=634;
  Scrollbox1.HorzScrollBar.Visible:=False;
  ClientHeight:=SCROLLBOXHEIGHT DIV 4;
  Scrollbox1.Borderstyle:=bsNone;
  Scrollbox1.Top:=0;
  Scrollbox1.Left:=0;
  Scrollbox1.Width:=634;
  Scrollbox1.Height:=SCROLLBOXHEIGHT DIV 4;
  Scrollbox1.VertScrollBar.Position:=0;

  update;

  PrintCoverForm.Gauge1.Progress:=2;
  PrintCoverForm.Update;

  PrintAQF(1,4);
  Scrollbox1.VertScrollBar.Position:= SCROLLBOXHEIGHT DIV 4;
  update;
  PrintCoverForm.Gauge1.Progress:=20;
  PrintCoverForm.Update;
  PrintAQF(2,4);
  Scrollbox1.VertScrollBar.Position:= (SCROLLBOXHEIGHT DIV 4) * 2;
  update;
  PrintCoverForm.Gauge1.Progress:=40;
  PrintCoverForm.Update;
  PrintAQF(3,4);
  Scrollbox1.VertScrollBar.Position:= SCROLLBOXHEIGHT;
  update;
  PrintCoverForm.Gauge1.Progress:=65;
  PrintCoverForm.Update;
  PrintAQF(4,4);

  {Restore Window Position}
  Scrollbox1.Borderstyle:=bsSingle;
  Scrollbox1.HorzScrollBar.Visible:=True;
  Scrollbox1.Align:=alNone;

  PrintButton.Visible:=true;
  GridButt.Visible := not LBV;
  ExportExcel.Visible := not LBV;
  DBNAVIGATOR1.VISIBLE:=not LBV;
  SAVEBUTTON.VISIBLE:=true;
  CancelButton.VISIBLE:=true;
  LoadButton.Visible:=LBV;
  SaveLib.Visible:=LBV;

  height:=old_win_height;
  top:=old_win_top;
  Left:=old_win_left;
  Width:=old_win_width;
  Scrollbox1.Height:=old_sb_height;
  Scrollbox1.Top:=old_sb_top;
  Scrollbox1.Left:=old_sb_left;
  Scrollbox1.Width:=old_sb_width;
  Scrollbox1.VertScrollBar.Position:=old_sb_vsb_position;
  Update;
  Show;
  PrintCoverForm.Hide;
  PrintCoverForm.Free;
end;

{$R *.DFM}

procedure TRemineralization.FindButtonClick(Sender: TObject);
{Handle the Find Button}
begin
    Application.CreateForm(TSearchDialog, SearchDialog);

    SearchDialog.SearchType.caption:='remin rec.';
    SearchDialog.GetColumnFromDB(Grid,0);

    SearchDialog.ShowModal;
    if SearchDialog.ResultItem > -1 then
      with Table1 do
        begin
          SetKey;
          Fields[0].AsString := SearchDialog.ReturnString;
          GotoNearest;
        end;

    SearchDialog.Free;          
end;


procedure TRemineralization.NewButtonClick(Sender: TObject);
{the New Button}
Var Counter: Integer;
    name   : ShortString;

begin
  Counter:=0;
  name:='';
  Repeat         {Protect against multiple names}
     Counter:=Counter+1;
     If Counter>1 then Str(Counter,Name);
     name:='NewRemin'+name;
  until not table1.FindKey([name]);

  Table1.InsertRecord([name]);  {Insert the new Record}
  DBEdit1.SetFocus;
  DBEdit1.Selectall;
end;

procedure TRemineralization.DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
begin
  Scrollbox1.VertScrollBar.Position:=0;
end;

procedure TRemineralization.ExportExcelClick(Sender: TObject);
 var
      TEx: TExcelOutput;
      dbgrd: TDBGrid2;
      intRow,       // index for query rows
      intCol  : Integer ; // index for query columns
      CurrentColumns : Variant ;   // Sheets to AutoFit
      qry   : TQuery ;  // Query related to dbgrd
      BookMark  : TBookMark ; // Bookmark for query
      BaseName: String;
                                
begin
 // Initialize

   dbgrd := Grid;

   TEx := TExcelOutput.Create(False);

   qry := nil ;
   BookMark := nil ;

   try
    // Dereference database grid to get datasource and supplying query
      qry := TQuery(TDataSource(dbgrd.DataSource).DataSet) ;

      // If the query is inactive or record count < 1 then outta here
      if qry.Active = False then
       exit ;
      if qry.RecordCount < 1 then
       exit ;

      // Execute save dialog
      If TEx.GetSaveName(BaseName,'Please Specify an Excel File into which to Save this Table:') then
      begin
       WaitDlg.Setup('Please Wait, Writing Table to Excel File');

         // Insert column headers into sheet
         intRow := 1;
         for intCol := 1 to qry.FieldCount do
           Begin
              TEx.WS.Cells.Item[intRow,intCol].Value := qry.Fields[intCol-1].FieldName;
              TEx.WS.Cells.Item[intRow,intCol].Font.FontStyle := 'Bold';
           End;
         WaitDlg.Tease;

         // Disable controls attached to query
         qry.DisableControls ;

         // Save place in query
         BookMark := qry.GetBookmark ;

         // Position to first row
         qry.First ;

         // Insert data into sheet
         while not qry.EOF do
         begin
            WaitDlg.Tease;
            inc(intRow) ;
            for intCol := 1 to qry.FieldCount do
            begin
               Try
                 TEx.WS.Cells.Item[intRow,intCol].Value := qry.Fields[intCol-1].AsString;
               Except
                 TEx.WS.Cells.Item[intRow,intCol].Value := ''''+qry.Fields[intCol-1].AsString;
               End;

               If IntCol=1 then
                 begin
                   WaitDlg.Tease;
                   TEx.WS.Cells.Item[intRow,intCol].Font.FontStyle := 'Bold';
                 end;
            end;

            qry.Next;
         end ;

         CurrentColumns := TEx.WS.Columns;
         CurrentColumns.AutoFit;

         // Restore position in query
         qry.GotoBookmark(BookMark) ;

         // Free bookmark
         qry.FreeBookmark(BookMark) ;
         BookMark := nil;

         // Enable controls attached to query
         qry.EnableControls ;

         TEx.WS.Cells.Item[2,2].Select;
         TEx.Excel.ActiveWindow.FreezePanes := True;


       TEx.WS := TEx.Excel.Worksheets.Item[1] as _Worksheet;
       TEx.WS.Activate(TEx.LCID) ;
       TEx.SaveAndClose;

      end ;

   WaitDlg.Hide;

   // Exceptions
   except

    on E:Exception do
      begin
         // If Excel was started, quit it.
         try
           TEx.CloseFiles;
           TEx.Close;
         except
         end;
         // Restore position in query and enable controls
         if BookMark <> nil then
         begin
            qry.GoToBookMark(BookMark) ;
            qry.FreeBookMark(BookMark) ;
            qry.EnableControls ;
         end ;

         WaitDlg.Hide;
         // Status user
         MessageDLG('Save Failed: '+E.Message,   mtError,[mbOK],0) ;
      end ;
   end ;
end;

procedure TRemineralization.LoadButtonClick(Sender: TObject);
begin
  Application.CreateForm(TDb_GetEntry, Db_GetEntry);
  IF Db_GetEntry.LoadToUnderlyingData('Remin',Table1) then Changed:=True;
  DB_GetEntry.Free;
end;

procedure TRemineralization.savelibClick(Sender: TObject);
Var S: ShortString;
begin
  Library_File.SaveToLibrary('Remin',Table1,S,-1);
end;

procedure TRemineralization.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Remineralization.htm');
end;

procedure TRemineralization.FormShow(Sender: TObject);
begin
  Parmwarning.Visible := DBNavigator1.Visible;
  GridButt.Visible := DBNavigator1.Visible;
  ExportExcel.Visible := DBNavigator1.Visible;
  Grid.BringToFront;
end;

procedure TRemineralization.GridButtClick(Sender: TObject);
var i: Integer;
begin
  Grid.Columns.Items[0].Width := 180;
  For i := 0 to Grid.Columns.Count - 1 do
    if Grid.Columns.Items[i].Width > 180 then Grid.Columns.Items[i].Width := 180;

  Grid.Visible := not Grid.Visible;
  PrintButton.Enabled := not Grid.Visible;
  Scrollbox1.Visible := not Scrollbox1.Visible;    
end;

End.
