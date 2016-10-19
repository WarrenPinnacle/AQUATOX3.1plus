//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Site;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Global, DBCtrls,
  Classes, Graphics, Controls, Printfrm, Printing, Mask, Librarys,
  FindDlg, Forms, Dialogs, DBTables, DB, StdCtrls, ExtCtrls, Grids,
  dbgrids, dbgrids2, Convert, hh;

type
  TEdit_Site = class(TPrintingForm)
    DBText1: TDBText;
    SaveButton: TButton;
    CancelButton: TButton;
    DBNavigator1: TDBNavigator;
    ScrollBox1: TScrollBox;
    Label5: TLabel;
    NameEdit: TLabel;
    MeanDepthLabel: TLabel;
    Label3: TLabel;
    EpiTempLabel: TLabel;
    hyptemplabel: TLabel;
    hyprangelabel: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label24: TLabel;
    Label32: TLabel;
    maxdepthlabel: TLabel;
    EpiTempRangeLabel: TLabel;
    Label13: TLabel;
    Label18: TLabel;
    Bevel2: TBevel;
    LengthEdit: TDBEdit;
    DBEdit1: TDBEdit;
    MeanDepthEdit: TDBEdit;
    SAEdit: TDBEdit;
    ETempRange: TDBEdit;
    hyptempedit: TDBEdit;
    ETempEdit: TDBEdit;
    EditAvgLight: TDBEdit;
    DBEdit18: TDBEdit;
    hyprangeedit: TDBEdit;
    EditLightRange: TDBEdit;
    VolEdit: TDBEdit;
    maxdepthEdit: TDBEdit;
    FindButton: TButton;
    NewButton: TButton;
    DataSource2: TDataSource;
    Table2: TTable;
    Label1: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label25: TLabel;
    Label9: TLabel;
    Label29: TLabel;
    Label40: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label41: TLabel;
    MeanDepthUnit: TLabel;
    maxdepthunit: TLabel;
    hyptempcap2: TLabel;
    hyptempcap1: TLabel;
    hyprangecap2: TLabel;
    hyprangecap1: TLabel;
    Label33: TLabel;
    Label55: TLabel;
    DBMemo1: TDBMemo;
    PrintButton: TButton;
    PrintDialog1: TPrintDialog;
    Label56: TLabel;
    DBEdit8: TDBEdit;
    Label57: TLabel;
    DBEdit12: TDBEdit;
    Label58: TLabel;
    Label23: TLabel;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    maxdepthcomment: TDBEdit;
    DBEdit28: TDBEdit;
    DBEdit31: TDBEdit;
    MeanDepthComment: TDBEdit;
    hyptempcomment: TDBEdit;
    hyprangecomment: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    Label17: TLabel;
    Label10: TLabel;
    Label22: TLabel;
    Label26: TLabel;
    Label30: TLabel;
    Label35: TLabel;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    Label34: TLabel;
    Label36: TLabel;
    DBEdit27: TDBEdit;
    DBEdit29: TDBEdit;
    StreamButton: TButton;
    Label20: TLabel;
    Label7: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    DBEdit33: TDBEdit;
    DBEdit34: TDBEdit;
    savelib: TButton;
    LoadButton: TButton;
    Bevel1: TBevel;
    UseBathymetry: TDBCheckBox;
    Label4: TLabel;
    Label50: TLabel;
    DBEdit35: TDBEdit;
    Label51: TLabel;
    DBEdit36: TDBEdit;
    HelpButton: TButton;
    Label6: TLabel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Label14: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    DBEdit54: TDBEdit;
    DBEdit53: TDBEdit;
    DBEdit52: TDBEdit;
    DBEdit51: TDBEdit;
    DBEdit50: TDBEdit;
    DBEdit49: TDBEdit;
    DBEdit48: TDBEdit;
    DBEdit47: TDBEdit;
    DBEdit46: TDBEdit;
    DBEdit45: TDBEdit;
    DBEdit44: TDBEdit;
    DBEdit43: TDBEdit;
    DBEdit42: TDBEdit;
    DBEdit41: TDBEdit;
    DBEdit40: TDBEdit;
    DBEdit39: TDBEdit;
    DBEdit38: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit57: TDBEdit;
    DBEdit56: TDBEdit;
    DBEdit55: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit9: TDBEdit;
    Label2: TLabel;
    Label8: TLabel;
    DBEdit3: TDBEdit;
    DBEdit26: TDBEdit;
    WA1: TLabel;
    WA3: TLabel;
    WA4: TLabel;
    TL2: TLabel;
    WA2: TDBEdit;
    WA5: TDBEdit;
    TLBox: TDBCheckBox;
    TL1: TDBEdit;
    TL3: TDBEdit;
    NotEstuaryPanel: TPanel;
    parmwarning: TLabel;
    Grid: TDBGrid2;
    GridButt: TButton;
    Label70: TLabel;
    Label71: TLabel;
    ESWLabel: TLabel;
    ESWUnit: TLabel;
    ESWEdit: TDBEdit;
    ESWComment: TDBEdit;
    Label42: TLabel;
    Label31: TLabel;
    Label39: TLabel;
    DBEdit37: TDBEdit;
    XEC: TDBEdit;
    Label43: TLabel;
    Label72: TLabel;
    DBEdit59: TDBEdit;
    DBEdit60: TDBEdit;
    Label73: TLabel;
    Label74: TLabel;
    DBEdit61: TDBEdit;
    DBEdit62: TDBEdit;
    UseCovar: TDBCheckBox;
    KE1: TDBEdit;
    KReaerL2: TLabel;
    KE2: TDBEdit;
    kreaerL1: TLabel;
    ConvertLight1: TButton;
    ConvertLight2: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    LimWallAreaEdit: TDBEdit;
    UsePhytoRetCheckBox: TDBCheckBox;
    Bevel5: TBevel;
    Label11: TLabel;
    Label12: TLabel;
    Label75: TLabel;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    Label76: TLabel;
    DBEdit7: TDBEdit;
    Label77: TLabel;
    DBEdit11: TDBEdit;
    Label78: TLabel;
    ExportExcel: TButton;
    Label79: TLabel;
    procedure AppException(Sender: TObject; E: Exception);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FindButtonClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure RetHandle(Sender: TObject; var Key: Char);
    procedure PrintButtonClick(Sender: TObject);
    procedure StreamButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure savelibClick(Sender: TObject);
    procedure UseBathymetryClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridButtClick(Sender: TObject);
    procedure UseCovarClick(Sender: TObject);
    procedure ConvertLight1Click(Sender: TObject);
    procedure ConvertLight2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure UsePhytoRetCheckBoxClick(Sender: TObject);
    procedure ExportExcelClick(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    Procedure ConvNum(TE: TDBEdit; CType: ConvertType );
  public
    Changed: Boolean;
    SType: SiteTypes;
    LibMode: Boolean;
    LinkedMod: Boolean;
    { Public declarations }
  end;

var
  Edit_Site: TEdit_Site;

implementation

uses StreamFrm, DBEntry, ExcelFuncs, Excel2000, WAIT;

{$R *.DFM}

Procedure TEdit_Site.ConvNum;
Begin
  Application.CreateForm(TConvertform,ConvertForm);
  ConvertForm.ConvertNumber(TE,CType);
  ConvertForm.Free;
End;

procedure TEdit_site.FindButtonClick(Sender: TObject);
{Handle the Find Button}
begin
    Application.CreateForm(TSearchDialog, SearchDialog);

    SearchDialog.SearchType.caption:='site';
    SearchDialog.GetColumnFromDB(Grid,0);

    SearchDialog.ShowModal;
    if SearchDialog.ResultItem > -1 then
      with Table2 do
        begin
          SetKey;
          Fields[0].AsString := SearchDialog.ReturnString;
          GotoNearest;
        end;
    SearchDialog.Free;
end;

procedure TEdit_site.NewButtonClick(Sender: TObject);
{the New Button}
Var Counter: Integer;
    name   : ShortString;

begin
  Counter:=0;
  name:='';
  Repeat         {Protect against multiple names}
     Counter:=Counter+1;
     If Counter>1 then Str(Counter,Name);
     name:='NewSite'+name;
  until not Table2.FindKey([name]);

  Table2.InsertRecord([name]);  {Insert the new Record}
  DBEdit1.SetFocus;
  DBEdit1.Selectall;
end;


procedure TEdit_site.AppException(Sender: TObject; E: Exception);
begin
   If E.Message='Key violation.' then  {multiple name error message}
      MessageDlg('A Site of that Name Already Exists, Please Give Your Entry a New Name',mtError,[mbOK],0)
   else
   Application.ShowException(E);      {mainly handles invalid # format}
end;


procedure TEdit_site.DBNavigator1Click(Sender: TObject;
  Button: TNavigateBtn);
begin
       Scrollbox1.VertScrollBar.Position:=0;
end;

procedure TEdit_Site.ExportExcelClick(Sender: TObject);
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

         CurrentColumns.WrapText := False;
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

procedure TEdit_Site.Button10Click(Sender: TObject);
begin
  ConvNum(HypRangeEdit,CTTemp);
end;

procedure TEdit_Site.Button11Click(Sender: TObject);
begin
  ConvNum(LimWallAreaEdit,CTSurfArea);
end;

procedure TEdit_Site.Button12Click(Sender: TObject);
begin
  ConvNum(TL1,CTLength);
end;

procedure TEdit_Site.Button1Click(Sender: TObject);
begin
  ConvNum(LengthEdit,CtLength);
end;

procedure TEdit_Site.Button2Click(Sender: TObject);
begin
  ConvNum(VolEdit ,CTVolume)
end;

procedure TEdit_Site.Button3Click(Sender: TObject);
begin
  ConvNum(SAEdit,CTSurfArea);
end;

procedure TEdit_Site.Button4Click(Sender: TObject);
begin
  ConvNum(ESWEdit,CTDepth);
end;

procedure TEdit_Site.Button5Click(Sender: TObject);
begin
  ConvNum(MeanDepthEdit,CTDepth);
end;

procedure TEdit_Site.Button6Click(Sender: TObject);
begin
  ConvNum(MaxDepthEdit,CTDepth);
end;

procedure TEdit_Site.Button7Click(Sender: TObject);
begin
  ConvNum(ETempEdit,CTTemp);
end;

procedure TEdit_Site.Button8Click(Sender: TObject);
begin
  ConvNum(ETempRange,CTTemp);
end;

procedure TEdit_Site.Button9Click(Sender: TObject);
begin
  ConvNum(HypTempEdit,CTTemp);
end;

procedure TEdit_site.CancelButtonClick(Sender: TObject);
begin
   If MessageDlg('Discard all edits?',mtConfirmation,mbOKCancel,0)=mrOK then
   Edit_site.ModalResult:=MRCancel;
end;

procedure TEdit_Site.ConvertLight1Click(Sender: TObject);
begin
  ConvNum(EditAvgLight,CTLight);
end;

procedure TEdit_Site.ConvertLight2Click(Sender: TObject);
begin
  ConvNum(EditLightRange,CTLight);
end;

procedure TEdit_site.SaveButtonClick(Sender: TObject);
Var LibraryMode:Boolean;
begin
   LibraryMode := DbNavigator1.Visible;

   If Table2.State in [dsedit,dsinsert] then Table2.Post;
   If not LibraryMode then Edit_Site.ModalResult:=MROK
      else if MessageDlg('Save changes and exit?',mtConfirmation,mbOKCancel,0)=mrOK
           then Edit_Site.ModalResult:=MROK;
end;

{THE FOLLOWING PROCEDURE HANDLES THE EVENT WHEN THE USER PRESSES RETURN.
 SEE CHEM.PAS}
procedure TEdit_site.RetHandle(Sender: TObject; var Key: Char);
begin
  Changed := True;

  If Key=#13 then if Table2.State in [dsedit,dsinsert] then
   begin      {enables return key}
     Tdbedit(sender).enabled:=false;
     Tdbedit(sender).enabled:=true;
     Table2.Post;
   end; {if}

   inherited;
end;

procedure TEdit_site.FormResize(Sender: TObject);
begin
  ScrollBox1.Height:=edit_site.ClientHeight-62;
  ScrollBox1.Width:=edit_site.ClientWidth+2;

  Grid.Height:=edit_site.ClientHeight-62;
  Grid.Width:=edit_site.ClientWidth+2;

{  TFloatField(Table2.Fields[9]).DisplayFormat := '0.0000E+00';
  TFloatField(Table2.Fields[7]).DisplayFormat := '0.0000E+00'; }
  TFloatField(Table2.Fields[5]).DisplayFormat := '0.0000E+00';
  TFloatField(Table2.Fields[3]).DisplayFormat := '0.0000E+00';
end;

procedure TEdit_site.FormCreate(Sender: TObject);
begin
  inherited;
  Changed := False;

  Application.OnException:=AppException;

  LinkedMod := False;
end;


procedure TEdit_Site.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  If Grid.Visible then Grid.Perform(WM_VSCROLL,1,0)
                  else ScrollBox1.Perform(WM_VSCROLL,1,0);
end;

procedure TEdit_Site.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  If Grid.Visible then Grid.Perform(WM_VSCROLL,0,0)
                  else ScrollBox1.Perform(WM_VSCROLL,0,0);
end;

procedure TEdit_Site.PrintButtonClick(Sender: TObject);
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
  ClientHeight:=SCROLLBOXHEIGHT div 3;
  Scrollbox1.Borderstyle:=bsNone;
  Scrollbox1.Top:=0;
  Scrollbox1.Left:=0;
  Scrollbox1.Width:=634;
  Scrollbox1.Height:=SCROLLBOXHEIGHT div 3;
  Scrollbox1.VertScrollBar.Position:=0;

  update;

  PrintCoverForm.Gauge1.Progress:=3;
  PrintCoverForm.Update;

  PrintAQF(1,3);
  Scrollbox1.VertScrollBar.Position:= SCROLLBOXHEIGHT div 3;
  update;
  PrintCoverForm.Gauge1.Progress:=30;
  PrintCoverForm.Update;
  PrintAQF(2,3);
  Scrollbox1.VertScrollBar.Position:= SCROLLBOXHEIGHT;
  update;
  PrintCoverForm.Gauge1.Progress:=60;
  PrintCoverForm.Update;
  PrintAQF(3,3);

  {Restore Window Position}
  Scrollbox1.Borderstyle:=bsSingle;
  Scrollbox1.HorzScrollBar.Visible:=True;
  Scrollbox1.Align:=alNone;

  PrintButton.Visible:=true;
  DBNAVIGATOR1.VISIBLE:=not LBV;
  GridButt.Visible :=not LBV;
  ExportExcel.Visible :=not LBV;
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

Procedure TEdit_Site.StreamButtonClick(Sender: TObject);
Var St: String;
    NeedToFind: Boolean;
begin
  if Table2.State in [dsedit,dsinsert] then Table2.Post;

  NeedToFind:=False;
  If not Table2.BOF then
    Begin
      NeedToFind:=True;
      St:= Table2.Fields[0].AsString;
    End;

  Table2.Active:=False;

  With StreamForm.Table2 do
    begin
      TableName:=Table2.TableName;
      DatabaseName:=Table2.DatabaseName;
      Active:=True;
      If NeedToFind then
        begin
          SetKey;
          Fields[0].AsString:= St;
          GotoNearest;
        end;
    end;

  StreamForm.Showmodal;
  If StreamForm.Table2.State in [dsedit,dsinsert] then StreamForm.Table2.Post;
  StreamForm.Table2.Active:=False;

  Table2.Active:=True;
  If NeedToFind then with Table2 do
        begin
          SetKey;
          Fields[0].AsString:= St;
          GotoNearest;
        end;

  FormResize(nil);
End;

procedure TEdit_Site.LoadButtonClick(Sender: TObject);
begin
  Application.CreateForm(TDb_GetEntry, Db_GetEntry);
  If Db_GetEntry.LoadToUnderlyingData('Site',Table2) then Changed:=True;
  DB_GetEntry.Free;
end;

procedure TEdit_Site.savelibClick(Sender: TObject);
Var S: ShortString;
begin
  Library_File.SaveToLibrary('Site',Table2,S,-1);
end;

procedure TEdit_Site.UseBathymetryClick(Sender: TObject);
begin
  MaxDepthLabel.Enabled  := UseBathymetry.Checked;
  MaxDepthEdit.Enabled  := UseBathymetry.Checked;
  MaxDepthUnit.Enabled  := UseBathymetry.Checked;
  MaxDepthComment.Enabled  := UseBathymetry.Checked;

  MeanDepthLabel.Enabled  := UseBathymetry.Checked;
  MeanDepthEdit.Enabled  := UseBathymetry.Checked;
  MeanDepthUnit.Enabled  := UseBathymetry.Checked;
  MeanDepthComment.Enabled  := UseBathymetry.Checked;

end;

procedure TEdit_Site.UseCovarClick(Sender: TObject);
begin
  KReaerL1.Enabled  := Not UseCovar.Checked;
  KReaerL2.Enabled  := Not UseCovar.Checked;
  KE1.Enabled  := Not UseCovar.Checked;
  KE2.Enabled  := Not UseCovar.Checked;
end;

procedure TEdit_Site.UsePhytoRetCheckBoxClick(Sender: TObject);
begin
  If not UsePhytoRetCheckBox.Checked then
    Begin
      TLBox.Enabled := False;
      TL1.Enabled := False;
      TL2.Enabled := False;
      TL3.Enabled := False;
      WA1.Enabled := False;
      WA2.Enabled := False;
      WA3.Enabled := False;
      WA4.Enabled := False;
      WA5.Enabled := False;
    End else
    Begin
      TLBox.Enabled := True;
      TL1.Enabled := TLBox.Checked;
      TL2.Enabled := TLBox.Checked;
      TL3.Enabled := TLBox.Checked;
      WA1.Enabled := not TLBox.Checked;
      WA2.Enabled := not TLBox.Checked;
      WA3.Enabled := not TLBox.Checked;
      WA4.Enabled := not TLBox.Checked;
      WA5.Enabled := not TLBox.Checked;
    End;

end;

procedure TEdit_Site.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic24.htm');
end;

procedure TEdit_Site.FormShow(Sender: TObject);
begin
  Parmwarning.Visible := DBNavigator1.Visible;

  GridButt.Visible := LibMode;
  ExportExcel.Visible := LibMode;

  Grid.BringToFront;

  If LinkedMod then
    Begin
      EpiTempLabel.Caption := 'Average Temperature';
      EpiTempRangeLabel.Caption := 'Temperature Range';
      HypTempLabel.Enabled := False;
      HypTempEdit.Enabled := False;
      HypTempCap1.Enabled := False;
      HypTempCap2.Enabled := False;
      HypTempComment.Enabled := False;
      HypRangeLabel.Enabled := False;
      HypRangeEdit.Enabled := False;
      HypRangeCap1.Enabled := False;
      HypRangeCap2.Enabled := False;
      HypRangeComment.Enabled := False;
    End;

  If LibMode then exit;

  streambutton.enabled := SType = Stream;
  hyptemplabel.Enabled := SType<>stream;
  hyptempedit.Enabled  := SType<>stream;
  hyptempcomment.enabled := SType<>stream;
  hyprangelabel.enabled := SType<>stream;
  hyprangeedit.enabled := SType<>stream;
  hyprangecomment.enabled := SType<>stream;

  NotEstuaryPanel.Visible := Stype<>Estuary;

  ESWEdit.Enabled := Stype = Estuary;
  ESWComment.Enabled := Stype = Estuary;
  ESWLabel.Enabled := Stype = Estuary;
  ESWUnit.Enabled := Stype = Estuary;


end;

procedure TEdit_Site.GridButtClick(Sender: TObject);
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

 