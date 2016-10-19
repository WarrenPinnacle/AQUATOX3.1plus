//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//

unit Animal;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,Printing, Aquaobj, Global,
  Forms, Dialogs, DBTables, DB, StdCtrls, Mask, DBCtrls, ExtCtrls,FindDlg,Printfrm, Librarys,
  Grids, dbgrids2, {Prtgrid, Prtgrid_new,} SV_IO, hh;

type
  TEdit_Animal = class(TPrintingForm)
    DBText1: TDBText;
    SaveButton: TButton;
    CancelButton: TButton;
    DBNavigator1: TDBNavigator;
    Label5: TLabel;
    NameEdit: TLabel;                   
    Label2: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label32: TLabel;
    F: TLabel;
    ConsumptionLabel2: TLabel;
    Label18: TLabel;
    Bevel2: TBevel;
    DBEdit10: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    ConsumptionEdit: TDBEdit;
    DBEdit14: TDBEdit;
    ConsumptionEdit2: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit26: TDBEdit;
    DBEdit28: TDBEdit;
    DBEdit29: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit31: TDBEdit;
    FindButton: TButton;
    NewButton: TButton;
    DataSource2: TDataSource;
    Table2: TTable;
    Label1: TLabel;
    ConsumptionLabel: TLabel;
    Label25: TLabel;
    Label9: TLabel;
    Label29: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    DBEdit32: TDBEdit;
    DBEdit35: TDBEdit;
    Label26: TLabel;
    MortDBEdit2: TDBEdit;
    MortDBEdit1: TDBEdit;
    MortLabel1: TLabel;
    Label42: TLabel;
    GamMortLabel: TDBEdit;
    DBEdit43: TDBEdit;
    DBEdit44: TDBEdit;
    DBEdit45: TDBEdit;
    Label43: TLabel;
    excretionlabel: TLabel;
    excretionedit: TDBEdit;
    excretionlabel2: TLabel;
    excretionedit2: TDBEdit;
    Label46: TLabel;
    Label47: TLabel;
    MortLabel2: TLabel;
    KCapLabel: TLabel;
    RespirationLabel: TLabel;
    RespirationEdit: TDBEdit;
    resplabel2: TLabel;
    respcommentedit: TDBEdit;
    DBEdit50: TDBEdit;
    Label53: TLabel;
    DBEdit51: TDBEdit;
    Label54: TLabel;
    PrintButton: TButton;
    Scrollbox1: TScrollBox;
    PrintDialog1: TPrintDialog;
    Label59: TLabel;
    ToxComboBox: TDBComboBox;
    Label63: TLabel;
    AnimalTypeBox: TDBComboBox;
    Label33: TLabel;
    LipidLabel1: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    LipidDBEdit1: TDBEdit;
    LipidDBEdit2: TDBEdit;
    DBEdit78: TDBEdit;
    DBEdit79: TDBEdit;
    Label85: TLabel;
    Bevel1: TBevel;
    savelib: TButton;
    ADLabel: TLabel;
    ADLabel2: TLabel;
    ADEdit2: TDBEdit;
    ADEdit: TDBEdit;
    LipidLabel2: TLabel;
    Label4: TLabel;
    AutoSpawnCheckBox: TDBCheckBox;
    SpawnEitherLabel: TLabel;
    SpawnDateLabel: TLabel;
    spawndate1: TDBEdit;
    spawndate2: TDBEdit;
    spawndate3: TDBEdit;
    Bevel3: TBevel;
    DateLabel: TLabel;
    SpawnEitherLabel2: TLabel;
    UnlimitedSpawnCheckBox: TDBCheckBox;
    SpawnLimitLabel: TLabel;
    SpawnLimit: TDBEdit;
    Bevel4: TBevel;
    Label12: TLabel;
    Bevel5: TBevel;
    Label14: TLabel;
    AllometricConsumpt: TDBCheckBox;
    CAEdit: TDBEdit;
    CBEdit: TDBEdit;
    CALabel: TLabel;
    CBLabel: TLabel;
    CALabel2: TLabel;
    CBLabel2: TLabel;
    Bevel6: TBevel;
    Label15: TLabel;
    AllometricResp: TDBCheckBox;
    RAEdit: TDBEdit;
    RBEdit: TDBEdit;
    RALabel1: TLabel;
    RBLabel1: TLabel;
    RALabel2: TLabel;
    RBLabel2: TLabel;
    UseSet1Box: TDBCheckBox;
    Label16: TLabel;
    Label17: TLabel;
    ActEdit2: TDBEdit;
    ActLabel2: TLabel;
    ACTLabel3: TLabel;
    RQEdit: TDBEdit;
    RTOEdit: TDBEdit;
    RQLabel: TLabel;
    RTOLabel: TLabel;
    RTMEdit: TDBEdit;
    RTLEdit: TDBEdit;
    RTMLabel: TLabel;
    RTLLabel: TLabel;
    RK1Edit: TDBEdit;
    RK4Edit: TDBEdit;
    RK1Label: TLabel;
    RK4Label: TLabel;
    ACTEdit: TDBEdit;
    BACTEdit: TDBEdit;
    ACTLabel: TLabel;
    BACTLabel: TLabel;
    XSpawnDateLabel: TLabel;
    XSpawnDateEdit: TDBEdit;
    AllometricMultiPanel2: TPanel;
    AllometricMultiPanel: TPanel;
    FIWCLabel: TLabel;
    FIWCUnit: TLabel;
    FIWCComment: TDBEdit;
    FIWCEdit: TDBEdit;
    TaxTypeBox: TDBComboBox;
    Label11: TLabel;
    BMinUnits: TLabel;
    VelMax1: TLabel;
    VelMax2: TDBEdit;
    VelMax3: TLabel;
    VelMax4: TDBEdit;
    RunLabel: TLabel;
    RunPct: TLabel;
    Label20: TLabel;
    DBEdit40: TDBEdit;
    Label49: TLabel;
    Label48: TLabel;
    DBEdit39: TDBEdit;
    DBEdit42: TDBEdit;
    DBEdit12: TDBEdit;
    Bevel7: TBevel;
    Label52: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    DBEdit13: TDBEdit;
    FishRemoveEdit: TDBEdit;
    Bevel8: TBevel;
    Label30: TLabel;
    Label31: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label41: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label62: TLabel;
    DBEdit19: TDBEdit;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    DBEdit25: TDBEdit;
    DBEdit27: TDBEdit;
    DBEdit30: TDBEdit;
    DBEdit33: TDBEdit;
    DBEdit34: TDBEdit;
    DBEdit36: TDBEdit;
    DBEdit37: TDBEdit;
    DBEdit38: TDBEdit;
    DBEdit41: TDBEdit;
    DBEdit46: TDBEdit;
    DBEdit47: TDBEdit;
    DBEdit48: TDBEdit;
    DBEdit49: TDBEdit;
    DBEdit52: TDBEdit;
    HelpButton: TButton;
    GridButt: TButton;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    DBEdit53: TDBEdit;
    DBEdit54: TDBEdit;
    DBEdit55: TDBEdit;
    DBEdit56: TDBEdit;
    DBEdit57: TDBEdit;
    DBEdit58: TDBEdit;
    parmwarning: TLabel;
    Grid: tdbgrid2;
    Bevel9: TBevel;
    Label70: TLabel;
    Label71: TLabel;
    DBEdit59: TDBEdit;
    Label72: TLabel;
    DBEdit60: TDBEdit;
    DBEdit61: TDBEdit;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    DBEdit62: TDBEdit;
    DBEdit63: TDBEdit;
    Label77: TLabel;
    Label78: TLabel;
    DBEdit64: TDBEdit;
    DBEdit65: TDBEdit;
    Label79: TLabel;
    Bevel10: TBevel;
    Label80: TLabel;
    Label81: TLabel;
    DBEdit66: TDBEdit;
    Label82: TLabel;
    DBEdit67: TDBEdit;
    EditAllLinks: TButton;
    MeanWtLabel: TLabel;
    MeanWtLabel2: TLabel;
    MeanWtEdit1: TDBEdit;
    MeanWtEdit2: TDBEdit;
    DBEdit17: TDBEdit;
    Label27: TLabel;
    Label28: TLabel;
    DBEdit18: TDBEdit;
    VFCheckBox: TDBCheckBox;
    VFRef: TDBEdit;
    SSLabel3: TLabel;
    SSLabel2: TLabel;
    SSLabel: TLabel;
    SSLabel4: TLabel;
    ISEdit: TDBEdit;
    SSEdit: TDBEdit;
    SSEditRef: TDBEdit;
    ISEditRef: TDBEdit;
    Bevel11: TBevel;
    s2slabel: TLabel;
    s2sedit: TDBComboBox;
    s2sref: TDBEdit;
    tlabel: TLabel;
    TUnitLabel: TLabel;
    TRefEdit: TDBEdit;
    TEdit: TDBEdit;
    SortLabel: TLabel;
    SortEdit: TDBEdit;
    SortUnit: TLabel;
    SortRef: TDBEdit;
    EmbedUnits: TLabel;
    EmbedText: TLabel;
    DBCheckBox1: TDBCheckBox;
    EmbedEdit: TDBEdit;
    EmbedRef: TDBEdit;
    Bevel12: TBevel;
    BenthicDesignationBox: TDBComboBox;
    BenthicDesigLabel: TLabel;
    ExportExcel: TButton;
    SciLabel: TLabel;
    DBEdit2: TDBEdit;
    SciSearch: TButton;
    TrophicIntButton: TButton;
    SpeciesDataButton: TButton;
    ConvertLight1: TButton;
    Procedure FindButtonClick(Sender: TObject);
    Procedure NewButtonClick(Sender: TObject);
    Procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    Procedure CancelButtonClick(Sender: TObject);
    Procedure SaveButtonClick(Sender: TObject);
    Procedure DBEdit1KeyPress(Sender: TObject; var Key: Char);
    Procedure FormResize(Sender: TObject);
    Procedure AppException(Sender: TObject; E: Exception);
    Procedure FormCreate(Sender: TObject);
    Procedure PrintButtonClick(Sender: TObject);
    Procedure SpeciesDataButtonClick(Sender: TObject);
    Procedure LoadButtonClick(Sender: TObject);
    Procedure savelibClick(Sender: TObject);
    Procedure AnimalTypeBoxChange(Sender: TObject);
    Procedure Table2AfterOpen(DataSet: TDataSet);
    Procedure FormShow(Sender: TObject);
    Procedure AutoSpawnCheckBoxClick(Sender: TObject);
    Procedure UnlimitedSpawnCheckBoxClick(Sender: TObject);
    Procedure AllometricConsumptClick(Sender: TObject);
    Procedure UseSet1BoxClick(Sender: TObject);
    procedure SpawnLimitExit(Sender: TObject);
    procedure TrophicIntButtonClick(Sender: TObject);
    procedure DBEdit39Exit(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure AnimalTypeBoxExit(Sender: TObject);
    procedure UseSet1BoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridButtClick(Sender: TObject);
    procedure EditAllLinksClick(Sender: TObject);
    procedure VFCheckBoxClick(Sender: TObject);
    procedure DBCheckBox1Click(Sender: TObject);
    procedure ExportExcelClick(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Table2AfterScroll(DataSet: TDataSet);
    procedure ConvertLight1Click(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure CAEditExit(Sender: TObject);
    procedure RAEditExit(Sender: TObject);
    procedure MeanWtEdit1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    LibraryMode, MultiLayerOn: Boolean;
    OrigDBDir: String;
    ToxChanged, Changed, MultiFish, YOYFish: Boolean;
    StatePtr,SVPtr,SpecPtr,TrophIntPtr: Pointer;
    Procedure GotoRow(R: Integer);
    { Public declarations }
  end;

var
  Edit_Animal: TEdit_Animal;
  IsInsect: Boolean;

implementation

uses Species, DBEntry, trophint, AllToxLinksEdit, WAIT, ExcelFuncs, Excel2000, Convert, Math;

{$R *.DFM}

Procedure TEdit_Animal.GotoRow(R: Integer);
Var qry: TQuery;
    indx: Integer;
begin
   qry := TQuery(DataSource2.DataSet);
   if qry.Active = False then exit ;
   if qry.RecordCount < 1 then exit ;
   qry.DisableControls ;
   qry.First ;
   For indx := 1 to R do
     If not qry.EOF then
        qry.Next;
   qry.EnableControls ;
end;

Procedure TEdit_Animal.FindButtonClick(Sender: TObject);
{Handle the Find Button}
Var SciName: Boolean;
begin
    Application.CreateForm(TSearchDialog, SearchDialog);
    SearchDialog.SearchType.caption:='animal';

    SciName := TButton(Sender).Name[1] = 'S';
    If SciName then SearchDialog.GetColumnFromDB(Grid,1)
               else SearchDialog.GetColumnFromDB(Grid,0);

    SearchDialog.ShowModal;
    if SearchDialog.ResultItem > -1 then
      GotoRow(SearchDialog.ResultItem);

    SearchDialog.Free;
end;

Procedure TEdit_Animal.NewButtonClick(Sender: TObject);
{the New Button}
Var Counter: Integer;
    name   : ShortString;

begin
  Counter:=0;
  name:='';
  Repeat        {Protect against multiple names}
     Counter:=Counter+1;
     If Counter>1 then Str(Counter,Name);
     name:='NewAnimal'+name;
  until not Table2.FindKey([name]);

  Table2.InsertRecord([name]);  {Insert the new Record}
  DBEdit1.SetFocus;
  DBEdit1.Selectall;
end;


Procedure TEdit_Animal.AppException(Sender: TObject; E: Exception);
begin
   If E.Message='Key violation.' then  {multiple name error message}
      MessageDlg('An Animal of that Name Already Exists, Please Give Your Entry a New Name',mtError,[mbOK],0)
   else
   Application.ShowException(E);      {mainly handles invalid # format}
end;


Procedure TEdit_Animal.DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
begin
   Scrollbox1.VertScrollBar.Position:=0;
   AnimalTypeBoxChange(nil);
   UseSet1BoxClick(nil);
   AllometricConsumptClick(nil);
   DBEdit39Exit(nil);
end;

procedure TEdit_Animal.CAEditExit(Sender: TObject);
Var CA, CB, MW, CMx: Double;

begin
  If Not Table2.FieldByName('UseAllometric_C').AsBoolean then Exit;
  CA :=Table2.FieldByName('CA').AsFloat;
  CB :=Table2.FieldByName('CB').AsFloat;
  MW :=Table2.FieldByName('Mean Weight').AsFloat;

//  Try
    Table2.Edit;
    CMx := RoundDec(5,CA * POWER(MW,CB));
    Table2.FieldByName('Max Consumpt').AsFloat := CMx;
    Table2.Post;
//  Except
//  End;

end;

Procedure TEdit_Animal.CancelButtonClick(Sender: TObject);
begin
   If MessageDlg('Discard all edits?',mtConfirmation,mbOKCancel,0)=mrOK then
   Edit_Animal.ModalResult:=MRCancel;
end;

procedure TEdit_Animal.ConvertLight1Click(Sender: TObject);
begin
  Application.CreateForm(TConvertform,ConvertForm);
  ConvertForm.ConvertNumber(FishRemoveEdit,CTFracPerDay);
  ConvertForm.Free;
end;

Procedure TEdit_Animal.SaveButtonClick(Sender: TObject);
begin
   If Table2.State in [dsedit,dsinsert] then Table2.Post;
   If MultiFish then Edit_Animal.ModalResult:=MROK
      else
     If MessageDlg('Save changes and exit?',mtConfirmation,mbOKCancel,0)=mrOK
        then Edit_Animal.ModalResult:=MROK;
end;


{THE FOLLOWING  Procedure HANDLE THE EVENT WHEN THE USER PRESSES RETURN.}
procedure TEdit_Animal.DBCheckBox1Click(Sender: TObject);
begin
  EmbedText.Enabled := DBCheckBox1.Checked;
  EmbedEdit.Enabled := DBCheckBox1.Checked;
  EmbedUnits.Enabled := DBCheckBox1.Checked;
  EmbedRef.Enabled := DBCheckBox1.Checked;
end;

Procedure TEdit_Animal.DBEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  Changed := True;

      If Key=#13 then if Table2.State in [dsedit,dsinsert] then
       begin      {enables return key}
         Table2.post;
         tdbedit(sender).enabled:=false;
         tdbedit(sender).enabled:=true;
       end; {if}
end;

Procedure TEdit_Animal.FormResize(Sender: TObject);
begin
    ScrollBox1.Height:=edit_animal.ClientHeight-62;
    ScrollBox1.Width:=edit_animal.ClientWidth-5;
    Grid.Height:=edit_animal.ClientHeight-62;
    Grid.Width:=edit_animal.ClientWidth-5;

end;

Procedure TEdit_Animal.FormCreate(Sender: TObject);
begin
   inherited;
   Application.OnException:=AppException;
   changed := false;
   ScrollBox1.VertScrollBar.Position := 0;
end;

procedure TEdit_Animal.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  If Grid.Visible then Grid.Perform(WM_VSCROLL,1,0)
                  else Scrollbox1.Perform(WM_VSCROLL,1,0);
end;

procedure TEdit_Animal.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  If Grid.Visible then Grid.Perform(WM_VSCROLL,0,0)
                  else ScrollBox1.Perform(WM_VSCROLL,0,0);
end;

Procedure TEdit_Animal.PrintButtonClick(Sender: TObject);
var old_win_height,old_win_top,old_win_left,old_win_width,
    old_sb_height,old_sb_top,old_sb_left,old_sb_width,
    old_sb_vsb_position: longint;
    LBV: Boolean;
    SCROLLBOXHEIGHT: INTEGER;

begin
  If Grid.Visible then
    Begin
      MessageDlg('Grid Printing is Currently Not Enabled.',mtinformation,[mbok],0);
      Exit;
    End;

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
  LBV:=SaveLib.Visible;
//  LoadButton.Visible:=False;
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
  ExportExcel.Visible := not LBV;
  GridButt.Visible := not LBV;

  DBNAVIGATOR1.VISIBLE:=not LBV;
  SAVEBUTTON.VISIBLE:=true;
  CancelButton.VISIBLE:=true;
//  LoadButton.Visible:=LBV;
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

procedure TEdit_Animal.RAEditExit(Sender: TObject);
Var RA, RB, MW, RMx: Double;
begin
  If Not Table2.FieldByName('UseAllometric_R').AsBoolean then Exit;
  RA :=Table2.FieldByName('RA').AsFloat;
  RB :=Table2.FieldByName('RB').AsFloat;
  MW :=Table2.FieldByName('Mean Weight').AsFloat;

//  Try
    Table2.Edit;
    RMx := RoundDec(5,1.5*RA * POWER(MW,RB));
    Table2.FieldByName('Endog Resp').AsFloat := RMx;
    Table2.Post;
    
//  Except
//  End;
end;

Procedure TEdit_Animal.SpeciesDataButtonClick(Sender: TObject);
Begin
  Application.CreateForm(TSpeciesDialog, SpeciesDialog);
  Try
    SpeciesDialog.IsPlantSpec := False;
    SpeciesDialog.SVPtr   := Edit_Animal.SVPtr;
    SpeciesDialog.SpecPtr := Edit_Animal.SpecPtr;
    SpeciesDialog.EditSpecies(Table2.Fields[0].AsString);
  Finally
    SpeciesDialog.Free;
  End;
End;

Procedure TEdit_Animal.LoadButtonClick(Sender: TObject);
Var PA: TAnimal;
Var TrophDir:String;
Begin
  Application.CreateForm(TDb_GetEntry, Db_GetEntry);
  If Db_GetEntry.LoadToUnderlyingData('Animal',Table2) then
    Begin
      Changed := True;
      PA := TAnimal.Init(NullStateVar,StV,'',nil,0,True);
      If DirectoryExists(DB_GetEntry.FileDir+'\Trophint')
         then TrophDir := DB_GetEntry.FileDir+'\Trophint\'
         else TrophDir := DB_GetEntry.FileDir+'\';

      If PA.ReadTrophInt(TrophDir+Table2.Fields[0].AsString+'.int')
         then TrophIntArray(TrophIntPtr^) := PA.PTrophint^;
      PA.Destroy;
    End;
  Db_GetEntry.Free;
End;


procedure TEdit_Animal.MeanWtEdit1Exit(Sender: TObject);
begin
  CAEditExit(nil);
  RAEditExit(nil);
end;

Procedure TEdit_Animal.SavelibClick(Sender: TObject);
Var RDir: ShortString;
    PA: TAnimal;
    RI: Integer;
Begin
  RI := IndexByName(Table2,Table2.Fields[0].AsString);

  If Library_File.SaveToLibrary('Animal',Table2,RDir,RI) then
    Begin
      PA := TAnimal.Init(NullStateVar,StV,'',Nil,0,True);
      PA.PTrophInt^ := TrophIntArray(TrophIntPtr^);
      If DirectoryExists(RDir+'\Trophint')
         then PA.WriteTrophInt(RDir+'\Trophint\'+Table2.Fields[0].AsString+'.int')
         else PA.WriteTrophInt(RDir+'\'+Table2.Fields[0].AsString+'.int');
      PA.Destroy;
    End;

End;



Procedure TEdit_Animal.AnimalTypeBoxChange(Sender: TObject);
Var IsPelagic, IsBenthos, IsFish, SSFeeder: Boolean;

Begin
  IsBenthos := AnimalTypeBox.ItemIndex > 1;
  BenthicDesignationBox.Enabled := IsBenthos;
  BenthicDesigLabel.Enabled := IsBenthos;

  ADLabel.Visible  := IsBenthos;
  ADLabel2.Visible := IsBenthos;
  ADEdit.Visible   := IsBenthos;
  ADEdit2.Visible  := IsBenthos;
  TEdit.Visible  := IsBenthos;
  TLabel.Visible := IsBenthos;
  TUnitLabel.Visible := IsBenthos;
  TRefEdit.Visible := IsBenthos;

  IsFish := AnimalTypeBox.ItemIndex =0;
  If IsFish then ScrollBox1.VertScrollBar.Range := 2850
            else ScrollBox1.VertScrollBar.Range := 2040;

  SSFeeder := (TaxTypeBox.ItemIndex > 0) and (TaxTypeBox.ItemIndex<6);
  SortEdit.Enabled := SSFeeder;
  SortLabel.Enabled := SSFeeder;
  SortUnit.Enabled := SSFeeder;
  SortRef.Enabled := SSFeeder;

  IsPelagic := AnimalTypeBox.ItemIndex = 1;
  If IsPelagic then KCapLabel.Caption := 'mg / L'
               else KCapLabel.Caption := 'g/sq.m';

  If IsPelagic then BMinUnits.Caption := 'mg / L'
               else BMinUnits.Caption := 'g/sq.m';

  VelMax1.Enabled := not IsPelagic;
  VelMax2.Enabled := not IsPelagic;
  VelMax3.Enabled := not IsPelagic;
  VelMax4.Enabled := not IsPelagic;

  VFCheckBoxclick(nil);
  DBCheckBox1Click(nil);
End;


Procedure TEdit_Animal.Table2AfterOpen(DataSet: TDataSet);
Begin
  AnimalTypeBoxChange(nil);
End;

procedure TEdit_Animal.Table2AfterScroll(DataSet: TDataSet);
begin
  If Visible and (Not LibraryMode) then
    Begin
      SpeciesDataButton.Enabled := False;
      TrophicIntButton.Enabled := False;
    End;   
end;

Procedure TEdit_Animal.FormShow(Sender: TObject);
Var FIWCShow: Boolean;
Begin
  ToxChanged := False;
  Parmwarning.Visible := LibraryMode;

  Grid.BringToFront;
  Grid.Columns[63].Index := 1; {move taxa & animal type to front (left) of gridmode}
  Grid.Columns[37].Index := 1;
  Grid.Columns[127].Index := 1;  {move sci name up front}

  FIWCShow := LibraryMode or MultiLayerOn;
  FIWCLabel.Enabled := FIWCShow;
  FIWCUnit.Enabled := FIWCShow;
  FIWCComment.Enabled := FIWCShow;
  FIWCEdit.Enabled := FIWCShow;

   If MultiFish then
     Begin
       LipidLabel1.Enabled  := False;
       LipidDBEdit1.Enabled := False;
       LipidLabel2.Enabled  := False;
       LipidDBEdit2.Enabled := False;

       MortLabel1.Enabled  := False;
       MortDBEdit1.Enabled := False;
       MortLabel2.Enabled  := False;
       MortDBEdit2.Enabled := False;

       MeanWtLabel.Enabled := False;
       MeanWtLabel2.Enabled := False;
       MeanWtEdit1.Enabled  := False;
       MeanWtEdit2.Enabled  := False;

       AllometricConsumpt.Enabled := False;
       AllometricResp.Enabled     := False;

       AllometricMultiPanel.Visible  := True;
       AllometricMultiPanel2.Visible := True;
     End;

   If YOYFish then
     Begin
       SpawnEitherLabel.Enabled  := False;
       SpawnEitherLabel2.Enabled := False;
       AutoSpawnCheckBox.Enabled := False;
       UnlimitedSpawnCheckBox.Enabled := False;
       SpawnDateLabel.Enabled  := False;
       XSpawnDateLabel.Enabled := False;
       DateLabel.Enabled  := False;
       SpawnDate1.Enabled := False;
       SpawnDate2.Enabled := False;
       SpawnDate3.Enabled := False;
       XSpawnDateEdit.Enabled  := False;
       SpawnLimitLabel.Enabled := False;
       SpawnLimit.Enabled := False;
     End;

   SpawnLimitExit(nil);
   DBEdit39Exit(nil);
end;

Procedure TEdit_Animal.AutoSpawnCheckBoxClick(Sender: TObject);
begin
  SpawnDateLabel.Enabled  := Not AutoSpawnCheckBox.Checked;
  XSpawnDateLabel.Enabled := Not AutoSpawnCheckBox.Checked;
  XSpawnDateEdit.Enabled  := Not AutoSpawnCheckBox.Checked;
  SpawnDate1.Enabled := Not AutoSpawnCheckBox.Checked;
  SpawnDate2.Enabled := Not AutoSpawnCheckBox.Checked;
  SpawnDate3.Enabled := Not AutoSpawnCheckBox.Checked;
  DateLabel.Caption  := '(Enter Dates '+ShortDateFormat + ')   Year entered is irrelevant';
  DateLabel.Enabled  := Not AutoSpawnCheckBox.Checked;
end;


procedure TEdit_Animal.VFCheckBoxClick(Sender: TObject);
begin
  SSEdit.Enabled := VFCheckBox.Checked;
  SSEditRef.Enabled := VFCheckBox.Checked;
  ISEdit.Enabled := VFCheckBox.Checked;
  ISEditRef.Enabled := VFCheckBox.Checked;
  SSLabel.Enabled := VFCheckBox.Checked;
  SSLabel2.Enabled := VFCheckBox.Checked;
  SSLabel3.Enabled := VFCheckBox.Checked;
  SSLabel4.Enabled := VFCheckBox.Checked;
end;





Procedure TEdit_Animal.UnlimitedSpawnCheckBoxClick(Sender: TObject);
begin
  SpawnLimitLabel.Enabled := Not UnlimitedSpawnCheckBox.Checked;
  SpawnLimit.Enabled := Not UnlimitedSpawnCheckBox.Checked;
  SpawnLimitExit(nil);
end;

procedure TEdit_Animal.SpawnLimitExit(Sender: TObject);
begin
  If (SpawnLimit.Field=nil) then exit;
  SpawnDate1.Visible := (UnlimitedSpawnCheckBox.Checked) or (spawnlimit.Field.AsInteger >0);
  SpawnDate2.Visible := (UnlimitedSpawnCheckBox.Checked) or (spawnlimit.Field.AsInteger >1);
  SpawnDate3.Visible := (UnlimitedSpawnCheckBox.Checked) or (spawnlimit.Field.AsInteger >2);

end;


Procedure TEdit_Animal.AllometricConsumptClick(Sender: TObject);
begin
  CALabel.Enabled  := AllometricConsumpt.Checked;
  CBLabel.Enabled  := AllometricConsumpt.Checked;
  CALabel2.Enabled := AllometricConsumpt.Checked;
  CBLabel2.Enabled := AllometricConsumpt.Checked;
  CAEdit.Enabled   := AllometricConsumpt.Checked;
  CBEdit.Enabled   := AllometricConsumpt.Checked;

  ConsumptionLabel.Enabled  := Not AllometricConsumpt.Checked;
  ConsumptionLabel2.Enabled := Not AllometricConsumpt.Checked;
  ConsumptionEdit.Enabled   := Not AllometricConsumpt.Checked;
  ConsumptionEdit2.Enabled  := Not AllometricConsumpt.Checked;

  If AllometricConsumpt.Checked then CAEditExit(nil);

end;

Procedure TEdit_Animal.UseSet1BoxClick(Sender: TObject);
begin
  RespirationLabel.Enabled  := Not AllometricResp.Checked;
  RespLabel2.Enabled        := Not AllometricResp.Checked;
  RespirationEdit.Enabled   := Not AllometricResp.Checked;
  RespCommentEdit.Enabled   := Not AllometricResp.Checked;

  If Not AllometricResp.Checked
    Then
      Begin
        RALabel1.Enabled:=False;
        RAEdit.Enabled:=False;
        RALabel2.Enabled:=False;
        RBLabel1.Enabled:=False;
        RBEdit.Enabled:=False;
        RBLabel2.Enabled:=False;
        UseSet1Box.Enabled:=False;

        RQEdit.Enabled:=False;
        RQLabel.Enabled:=False;
        RTOEdit.Enabled:=False;
        RTOLabel.Enabled:=False;
        RTMEdit.Enabled:=False;
        RTMLabel.Enabled:=False;
        RTLEdit.Enabled:=False;
        RTLLabel.Enabled:=False;
        RK1Edit.Enabled:=False;
        RK1Label.Enabled:=False;
        RK4Edit.Enabled:=False;
        RK4Label.Enabled:=False;
        ACTEdit.Enabled:=False;
        ACTLabel.Enabled:=False;
        BACTEdit.Enabled:=False;
        BACTLabel.Enabled:=False;
        ActLabel2.Enabled := False;
        ActEdit2.Enabled:=False;
        ActLabel3.Enabled:=False;
      End
    Else
      Begin
        RALabel1.Enabled:=True;
        RAEdit.Enabled:=True;
        RALabel2.Enabled:=True;
        RBLabel1.Enabled:=True;
        RBEdit.Enabled:=True;
        RBLabel2.Enabled:=True;
        UseSet1Box.Enabled:=True;

        If UseSet1Box.Checked
         then
          Begin
            RQEdit.Enabled:=True;
            RQLabel.Enabled:=True;
            RTOEdit.Enabled:=True;
            RTOLabel.Enabled:=True;
            RTMEdit.Enabled:=True;
            RTMLabel.Enabled:=True;
            RTLEdit.Enabled:=True;
            RTLLabel.Enabled:=True;
            RK1Edit.Enabled:=True;
            RK1Label.Enabled:=True;
            RK4Edit.Enabled:=True;
            RK4Label.Enabled:=True;
            ACTEdit.Enabled:=True;
            ACTLabel.Enabled:=True;
            BACTEdit.Enabled:=True;
            BACTLabel.Enabled:=True;

            ActLabel2.Enabled := False;
            ActEdit2.Enabled:=False;
            ActLabel3.Enabled:=False;
          End
         else
          Begin {useSet2}
            ActLabel2.Enabled := True;
            ActEdit2.Enabled:=True;
            ActLabel3.Enabled:=True;

            RQEdit.Enabled:=False;
            RQLabel.Enabled:=False;
            RTOEdit.Enabled:=False;
            RTOLabel.Enabled:=False;
            RTMEdit.Enabled:=False;
            RTMLabel.Enabled:=False;
            RTLEdit.Enabled:=False;
            RTLLabel.Enabled:=False;
            RK1Edit.Enabled:=False;
            RK1Label.Enabled:=False;
            RK4Edit.Enabled:=False;
            RK4Label.Enabled:=False;
            ACTEdit.Enabled:=False;
            ACTLabel.Enabled:=False;
            BACTEdit.Enabled:=False;
            BACTLabel.Enabled:=False;
          End;
      End;
End;


procedure TEdit_Animal.TrophicIntButtonClick(Sender: TObject);
begin
  Application.CreateForm(TTrophIntForm, TrophIntForm);
  Try

  If Librarymode
    then Begin If DirectoryExists(OrigDBDir+'\Trophint')
             then TrophIntForm.EditTrophFile(OrigDBDir+'\Trophint\',Table2.FieldByName('AnimalName').AsString)
             else TrophIntForm.EditTrophFile(OrigDBDir+'\'         ,Table2.FieldByName('AnimalName').AsString)
         End
    else
      Begin
        TrophIntForm.AnimName  := Table2.FieldByName('AnimalName').AsString;
        TrophIntForm.SV        := StatePtr;
        TrophIntForm.PtrTrophInt := TrophIntPtr;
        TrophIntForm.EditTrophInt;
        If TrophIntForm.Changed then Changed:=True;
      End;

  Finally
    TrophIntForm.Free;
  End;
End;

procedure TEdit_Animal.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic23.htm');
end;

procedure TEdit_Animal.AnimalTypeBoxExit(Sender: TObject);
begin
  Changed := True;
end;

procedure TEdit_Animal.UseSet1BoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Changed := True;
end;


procedure TEdit_Animal.DBEdit39Exit(Sender: TObject);
Var PctRun, PctRiffle,PctPool: Double;
begin
  PctRiffle:=Table2.FieldByName('PctRiffle').AsFloat;
  PctPool:=Table2.FieldByName('PctPool').AsFloat;
  PctRun := 100-PctRiffle-PctPool;
  If (PctRun<0)
     then Begin
            RunPct.Caption := 'ERROR   ';
            RunLabel.Caption := 'Riffle + Pool must be less than 100';
          End
     else If (PctRun>100)
       then Begin
              RunPct.Caption := 'ERROR   ';
              RunLabel.Caption := 'Riffle + Pool cannot be negative';
            End
       else Begin
              RunPct.Caption := FloatToStrF(PctRun,ffFixed,4,2) + '   %';
              RunLabel.Caption := '(All Biomass not in Riffle or Pool)';
            End;
end;



procedure TEdit_Animal.GridButtClick(Sender: TObject);
var i: Integer;
begin
  Grid.Columns.Items[0].Width := 180;
  For i := 0 to Grid.Columns.Count - 1 do
    if Grid.Columns.Items[i].Width > 180 then Grid.Columns.Items[i].Width := 180;
    
  Grid.Visible := not Grid.Visible;
  PrintButton.Enabled := not Grid.Visible;
  Scrollbox1.Visible := not Scrollbox1.Visible;
end;

procedure TEdit_Animal.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Shift = [ssCtrl]) and (Key = VK_DELETE) and (Not LibraryMode) then
     Key := 0; {ignore}
end;

Procedure TEdit_Animal.EditAllLinksClick(Sender: TObject);
Var SVLoop: AllVariables;
    TA: TAnimal;
    RI,i : Integer;
Begin
    If LibraryMode then Exit;

    RI := IndexByName(Table2,Table2.Fields[0].AsString);

    Application.CreateForm(TToxLinksEdit, ToxLinksEdit);

    ToxLinksEdit.EditAllLinks(TStates(StatePtr));
    If ToxLinksEdit.Changed then
     Begin
       Table2.First;
       For SVLoop := FirstAnimal to LastAnimal do
         Begin
            Table2.Edit;
            TA := TStateVariable(SVPtr).GetStatePointer(SVLoop,STV,WaterCol);
            If TA<>nil then Begin
                              Table2.FieldByName('Toxicity Record').AsString := TA.PAnimalData^.ToxicityRecord;
                              Table2.Next;
                            End;
         End; {SVLoop}
       ToxChanged := True;
     End;

    If RI>0 then
      Begin
        Table2.First;
        For i := 2 to RI do
          Table2.Next;
      End;

    ToxLinksEdit.Free;
End;

procedure TEdit_Animal.ExportExcelClick(Sender: TObject);
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

End.
