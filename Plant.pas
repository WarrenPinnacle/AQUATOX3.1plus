//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Plant;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Printfrm, Librarys,
  printing,FindDlg,Forms, Dialogs, DBTables, DB, StdCtrls, Mask, DBCtrls, ExtCtrls,
  Grids, Global, AQUAOBJ, SV_IO, DBGrids, dbgrids2, hh;

type
  TEdit_Plant = class(TPrintingForm)
    SaveButton: TButton;
    CancelButton: TButton;
    DBNavigator1: TDBNavigator;
    ScrollBox1: TScrollBox;
    Label5: TLabel;
    Label28: TLabel;
    NameEdit: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label23: TLabel;
    Label32: TLabel;
    F: TLabel;
    Label4: TLabel;
    Label13: TLabel;
    Label18: TLabel;
    Bevel2: TBevel;
    SatLightEdit: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit26: TDBEdit;
    DBEdit28: TDBEdit;
    DBEdit29: TDBEdit;
    DBEdit30: TDBEdit;
    DBEdit33: TDBEdit;
    DBEdit34: TDBEdit;
    DBEdit41: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit31: TDBEdit;
    NewButton: TButton;
    DataSource3: TDataSource;
    Table3: TTable;
    Label1: TLabel;
    Label7: TLabel;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    Label17: TLabel;
    Label20: TLabel;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    Label22: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label31: TLabel;
    Label33: TLabel;
    Label25: TLabel;
    Label9: TLabel;
    Label29: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    PrintButton: TButton;
    PrintDialog1: TPrintDialog;
    Label30: TLabel;
    Label37: TLabel;
    ToxComboBox: TDBComboBox;
    Label43: TLabel;
    Label44: TLabel;
    DBEdit36: TDBEdit;
    Label45: TLabel;
    DBEdit37: TDBEdit;
    Label46: TLabel;
    PlantTypeBox: TDBComboBox;
    savelib: TButton;
    MacroTypeBox: TDBComboBox;
    MacroTypeLabel: TLabel;
    TaxonomicTypeBox: TDBComboBox;
    Label47: TLabel;
    Label34: TLabel;
    Label54: TLabel;
    KCapLabel: TLabel;
    Label26: TLabel;
    redwater1: TLabel;
    redwater3: TLabel;
    Label42: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    RunPct: TLabel;
    RunLabel: TLabel;
    velmax: TLabel;
    velmax3: TLabel;
    FCrit1: TLabel;
    FCrit3: TLabel;
    KCapEdit: TDBEdit;
    DBEdit27: TDBEdit;
    redwater2: TDBEdit;
    redwater4: TDBEdit;
    DBEdit39: TDBEdit;
    DBEdit40: TDBEdit;
    DBEdit42: TDBEdit;
    DBEdit43: TDBEdit;
    velmax2: TDBEdit;
    velmax4: TDBEdit;
    FCrit2: TDBEdit;
    FCrit4: TDBEdit;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
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
    DBEdit44: TDBEdit;
    DBEdit45: TDBEdit;
    DBEdit46: TDBEdit;
    DBEdit47: TDBEdit;
    DBEdit48: TDBEdit;
    DBEdit49: TDBEdit;
    DBEdit50: TDBEdit;
    DBEdit51: TDBEdit;
    DBEdit52: TDBEdit;
    DBEdit53: TDBEdit;
    PhytLabel1: TLabel;
    PhytLabel4: TLabel;
    Label38: TLabel;
    PhytLabel2: TLabel;
    Label41: TLabel;
    Label70: TLabel;
    PhytLabel3: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    PhytEdit1: TDBEdit;
    DBEdit38: TDBEdit;
    PhytEdit4: TDBEdit;
    DBEdit8: TDBEdit;
    PhytEdit2: TDBEdit;
    DBEdit35: TDBEdit;
    DBEdit54: TDBEdit;
    PhytEdit3: TDBEdit;
    Label75: TLabel;
    Label76: TLabel;
    DBEdit56: TDBEdit;
    DBEdit57: TDBEdit;
    Label77: TLabel;
    Label78: TLabel;
    DBEdit58: TDBEdit;
    Label79: TLabel;
    DBEdit59: TDBEdit;
    SpeciesDataButton: TButton;
    parmwarning: TLabel;
    DBText1: TDBText;
    GridButt: TButton;
    Grid: TDBGrid2;
    EditAllLinks: TButton;
    PctSlough1: TLabel;
    PctSlough3: TLabel;
    PctSlough2: TDBEdit;
    PctSlough4: TDBEdit;
    Bevel1: TBevel;
    EditPlantLinks2: TButton;
    EditAllPlants2: TButton;
    Label10: TLabel;
    ConvertLight: TButton;
    Label14: TLabel;
    MinLightLabel: TLabel;
    MaxLightLabel: TLabel;
    MinLightEdit: TDBEdit;
    MaxLightEdit: TDBEdit;
    MaxLightComment: TDBEdit;
    MinLightComment: TDBEdit;
    MaxLightUnits: TLabel;
    ConvertMaxLight: TButton;
    MinLightUnits: TLabel;
    ConvertMinLight: TButton;
    ExportExcel: TButton;
    SciSearch: TButton;
    DBEdit2: TDBEdit;
    SciLabel: TLabel;
    FindButton: TButton;
    HelpButton: TButton;
    Label21: TLabel;
    DBEdit10: TDBEdit;
    DBEdit22: TDBEdit;
    LipidLabel1: TLabel;
    AdaptiveLightButton: TDBCheckBox;
    SurfFloatBox: TDBCheckBox;
    Label19: TLabel;
    INL1: TLabel;
    INL2: TLabel;
    INL3: TLabel;
    INL4: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    INL5: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    INL6: TLabel;
    INE1: TDBEdit;
    DBEdit32: TDBEdit;
    DBEdit55: TDBEdit;
    INE2: TDBEdit;
    INE3: TDBEdit;
    DBEdit62: TDBEdit;
    DBEdit63: TDBEdit;
    INE4: TDBEdit;
    INE5: TDBEdit;
    DBEdit67: TDBEdit;
    INE6: TDBEdit;
    DBEdit65: TDBEdit;
    procedure SaveButtonClick(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
    procedure CancelButtonClick(Sender: TObject);
    procedure FindButtonClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure RetHandle(Sender: TObject; var Key: Char);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure PlantTypeBoxChange(Sender: TObject);
    procedure Table3NewRecord(DataSet: TDataset);
    procedure DataSource3DataChange(Sender: TObject; Field: TField);
    procedure LoadButtonClick(Sender: TObject);
    procedure savelibClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure TaxonomicTypeBoxExit(Sender: TObject);
    procedure DBEdit39Exit(Sender: TObject);
    procedure SpeciesDataButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GridButtClick(Sender: TObject);
    procedure EditAllLinksClick(Sender: TObject);
    procedure EditPlantLinks2Click(Sender: TObject);
    procedure ConvertLightClick(Sender: TObject);
    procedure AdaptiveLightButtonClick(Sender: TObject);
    procedure SatLightEditExit(Sender: TObject);
    procedure DBNavigator1BeforeAction(Sender: TObject; Button: TNavigateBtn);
    procedure ExportExcelClick(Sender: TObject);
    procedure Table3AfterScroll(DataSet: TDataSet);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
     SortedGrid: Boolean;
    { Private declarations }
  public
      SVPtr,SpecPtr : Pointer;
      LibraryMode, PlantLinkChanged, ToxChanged, Changed: Boolean;
      Procedure CheckAdaptiveLight;
      Procedure GotoRow(R: Integer);
    { Public declarations }
  end;

var
  Edit_Plant: TEdit_Plant;

implementation

uses DBEntry, Species, AllToxLinksEdit, AllPlantLinksEdit, Convert, ExcelFuncs, Excel2000,
  WAIT;


procedure TEdit_Plant.AppException(Sender: TObject; E: Exception);
begin
   If E.Message='Key violation' then  {multiple name error message}
      MessageDlg('A Plant of that Name Already Exists, Please Give Your Entry a New Name',mtError,[mbOK],0)
   else
   Application.ShowException(E);      {mainly handles invalid # format}
end;

procedure TEdit_Plant.CheckAdaptiveLight;
Var IsAdaptive: Boolean;        
    SatLight, MinLight, MaxLight: Double;
Begin
  IsAdaptive := Table3.FieldByName('UseAdaptiveLght').AsBoolean;
  IF Not IsAdaptive then exit;

  MaxLight := Table3.FieldByName('MaxLightSat').AsFloat;
  MinLight := Table3.FieldByName('MinLightSat').AsFloat;
  SatLight := Table3.FieldByName('Saturating Light').AsFloat;

  If (SatLight>MaxLight) or (SatLight<MinLight) then
    Begin
      If MessageDlg('Adaptive Light is selected and the Saturating Light value entered ('
       + SatLightEdit.Text +') falls outside the Minimum to Maximum range.  '+
        'Expand the range to include the value? ',mtconfirmation,[mbyes,mbno],0) = MRYes
          Then
            Begin
              Table3.Edit;
              If SatLight>MaxLight then Table3.FieldByName('MaxLightSat').AsFloat := SatLight;
              If SatLight<MinLight then Table3.FieldByName('MinLightSat').AsFloat := SatLight;
              Table3.Post;
            End;
     End;



End;



procedure TEdit_Plant.FormResize(Sender: TObject);
begin
    ScrollBox1.Height:=edit_plant.ClientHeight-59;
    ScrollBox1.Width:=edit_plant.ClientWidth+2;
    Grid.Height:=edit_plant.ClientHeight-59;
    Grid.Width:=edit_plant.ClientWidth+2;
end;

procedure TEdit_Plant.FormCreate(Sender: TObject);
begin
   inherited;
   SortedGrid := False;
   ToxChanged := False;
   PlantLinkChanged := False;
   Changed := False;
   Application.OnException:=AppException;
end;

procedure TEdit_Plant.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  If Grid.Visible then Grid.Perform(WM_VSCROLL,1,0)
                  else Scrollbox1.Perform(WM_VSCROLL,1,0);
end;

procedure TEdit_Plant.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  If Grid.Visible then Grid.Perform(WM_VSCROLL,0,0)
                  else ScrollBox1.Perform(WM_VSCROLL,0,0);
end;

{$R *.DFM}

procedure TEdit_Plant.SatLightEditExit(Sender: TObject);
begin
  CheckAdaptiveLight;
end;

procedure TEdit_Plant.SaveButtonClick(Sender: TObject);
begin
   CheckAdaptiveLight;

   If Table3.State in [dsedit,dsinsert] then Table3.Post;
   If MessageDlg('Save changes and exit?',mtConfirmation,mbOKCancel,0)=mrOK
           then Edit_Plant.ModalResult:=MROK;
end;


procedure TEdit_Plant.CancelButtonClick(Sender: TObject);
begin
   If MessageDlg('Discard all edits?',mtConfirmation,mbOKCancel,0)=mrOK then
   edit_plant.ModalResult:=MRCancel;
end;

procedure TEdit_Plant.ConvertLightClick(Sender: TObject);
begin
  Application.CreateForm(TConvertForm,ConvertForm);
  If Sender = ConvertLight then ConvertForm.ConvertNumber(SatLightEdit,CTLight);
  If Sender = ConvertMaxLight then ConvertForm.ConvertNumber(MaxLightEdit,CTLight);
  If Sender = ConvertMinLight then ConvertForm.ConvertNumber(MinLightEdit,CTLight);
  ConvertForm.Free;
end;

Procedure TEdit_Plant.GotoRow(R: Integer);
Var qry: TQuery;
    indx: Integer;
begin
   qry := TQuery(DataSource3.DataSet);
   if qry.Active = False then exit ;
   if qry.RecordCount < 1 then exit ;
   qry.DisableControls ;
   qry.First ;
   For indx := 1 to R do
     If not qry.EOF then
        qry.Next;
   qry.EnableControls ;
end;

Procedure TEdit_Plant.FindButtonClick(Sender: TObject);
{Handle the Find Button}
Var SciName: Boolean;
begin
    Application.CreateForm(TSearchDialog, SearchDialog);
    SearchDialog.SearchType.caption:='plant';

    SciName := TButton(Sender).Name[1] = 'S';
    If SciName then SearchDialog.GetColumnFromDB(Grid,1)
               else SearchDialog.GetColumnFromDB(Grid,0);

    SearchDialog.ShowModal;
    if SearchDialog.ResultItem > -1 then
      GotoRow(SearchDialog.ResultItem);

    SearchDialog.Free;
end;

procedure TEdit_Plant.NewButtonClick(Sender: TObject);
{the New Button}
Var Counter: Integer;
    name   : ShortString;

begin
  Counter:=0;
  name:='';
  Repeat         {Protect against multiple names}
     Counter:=Counter+1;
     If Counter>1 then Str(Counter,Name);
     name:='NewPlant'+name;
  until not table3.FindKey([name]);

  table3.InsertRecord([name]);  {Insert the new Record}
  DBEdit1.SetFocus;
  DBEdit1.Selectall;
end;


procedure TEdit_Plant.RetHandle(Sender: TObject; var Key: Char);
{THE FOLLOWING  PROCEDURE HANDLE THE EVENT WHEN THE USER PRESSES RETURN.
 SEE CHEM.PAS}

begin
  Changed := True;
      If Key=#13 then if table3.State in [dsedit,dsinsert] then
       begin      {enables return key}
         table3.post;
         tdbedit(sender).enabled:=false;
         tdbedit(sender).enabled:=true;
       end; {if}
end;

procedure TEdit_Plant.DBNavigator1BeforeAction(Sender: TObject;
  Button: TNavigateBtn);
begin
   CheckAdaptiveLight;
end;

procedure TEdit_Plant.DBNavigator1Click(Sender: TObject;
  Button: TNavigateBtn);

Begin
   Scrollbox1.VertScrollBar.Position:=0;
   DBEdit39Exit(nil);

end;



procedure TEdit_Plant.PrintButtonClick(Sender: TObject);
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
  LBV:=SaveLib.Visible;
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

  GridButt.Visible :=not LBV;
  ExportExcel.Visible := not LBV;
  PrintButton.Visible:=true;
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

procedure TEdit_Plant.PlantTypeBoxChange(Sender: TObject);
Var NutrientsEnabled,PhytoPlankton: Boolean;
    MacroType, PlantType: ShortString;
    LabelColor: TColor;

begin
   PlantType:=PlantTypeBox.Text;
   MacroType := MacroTypeBox.Text;

   {Enable/Disable Nutrient Data Input}
   NutrientsEnabled:= (MacroType='free-floating') or (not (PlantType='Macrophytes'));
   If NutrientsEnabled then LabelColor:=clBlack else LabelColor:=clGray;
   Dbedit11.Enabled:= NutrientsEnabled;
   Dbedit4.Enabled:=  NutrientsEnabled;
   Dbedit36.Enabled:= NutrientsEnabled;
   Label7.Font.Color:=LabelColor;
   Label3.Font.Color:=LabelColor;
   Label44.Font.Color:=LabelColor;
   Dbedit11.Font.Color:=LabelColor;
   Dbedit4.Font.Color:=LabelColor;
   Dbedit36.Font.Color:=LabelColor;

   INE1.Enabled := NutrientsEnabled;
   INE2.Enabled := NutrientsEnabled;
   INE3.Enabled := NutrientsEnabled;
   INE4.Enabled := NutrientsEnabled;
   INE5.Enabled := NutrientsEnabled;
   INE6.Enabled := NutrientsEnabled;
   INL1.Font.Color := LabelColor;
   INL2.Font.Color := LabelColor;
   INL3.Font.Color := LabelColor;
   INL4.Font.Color := LabelColor;
   INL5.Font.Color := LabelColor;
   INL6.Font.Color := LabelColor;

   {Enable/Disable bottom of screen}
   PhytoPlankton:=(PlantType='Phytoplankton');

{   DbEdit25.Enabled:=PhytoPlankton;
   DbEdit2.Enabled:=PhytoPlankton;
   DbEdit22.Enabled:=not(PhytoPlankton);
   DbEdit32.Enabled:=not(PhytoPlankton); }

   SpeciesDataButton.Visible := not LibraryMode and (PlantType='Periphyton');
   EditPlantLinks2.Visible := not LibraryMode and (PlantType='Periphyton');
   EditAllPlants2.Visible := not LibraryMode and (PlantType<>'Periphyton');

   If PhytoPlankton then
      begin
        PhytEdit1.enabled := True;
        PhytEdit2.enabled := True;
        PhytEdit3.enabled := True;
        PhytEdit4.enabled := True;
        PhytLabel1.Font.Color:=ClBlack;
        PhytLabel2.Font.Color:=ClBlack;
        PhytLabel3.Font.Color:=ClBlack;
        PhytLabel4.Font.Color:=ClBlack;
      end
   else
      begin
        PhytEdit1.enabled := False;
        PhytEdit2.enabled := False;
        PhytEdit3.enabled := False;
        PhytEdit4.enabled := False;
        PhytLabel1.Font.Color:=ClGray;
        PhytLabel2.Font.Color:=ClGray;
        PhytLabel3.Font.Color:=ClGray;
        PhytLabel4.Font.Color:=ClGray;
      end ;
   update;

   If (PlantType='Macrophytes') or (PlantType='Bryophytes')
     then
       Begin
         VelMax.Font.Color := ClBlack;
         VelMax2.Enabled := True;
         KCapEdit.Enabled := True;
         KCapLabel.Font.Color :=ClBlack;
       End
     else
       Begin
         VelMax.Font.Color  := ClGray;
         VelMax2.Enabled := False;
         KCapEdit.Enabled := False;
         KCapLabel.Font.Color :=ClGray;
       End;

   if (PlantType='Periphyton')
     then
       Begin
         FCrit1.Font.Color := ClBlack;
         FCrit2.Enabled := True;
         RedWater1.Font.Color:=ClBlack;
         RedWater2.Enabled := True;
         PctSlough1.Font.Color:=ClBlack;
         PctSlough2.Enabled := True;
       End
     else
       Begin
         FCrit1.Font.Color := ClGray;
         FCrit2.Enabled := False;
         RedWater1.Font.Color:=ClGray;
         RedWater2.Enabled := False;
         PctSlough1.Font.Color:=ClGray;
         PctSlough2.Enabled := False;
       End;

   SurfFloatBox.Visible := (PlantType='Phytoplankton');
   MacroTypeBox.Visible := (PlantType='Macrophytes');
   MacroTypeLabel.Visible := (PlantType='Macrophytes');
end;

procedure TEdit_Plant.Table3AfterScroll(DataSet: TDataSet);
begin
    If Visible and (Not LibraryMode) then
    Begin
      SpeciesDataButton.Enabled := False;
    End;
end;

procedure TEdit_Plant.Table3NewRecord(DataSet: TDataset);
begin
   PlantTypeBoxchange(DataSet);
   AdaptiveLightButtonClick(nil);
end;

procedure TEdit_Plant.AdaptiveLightButtonClick(Sender: TObject);
begin
  MaxLightLabel.Enabled := AdaptiveLightButton.Checked;
  MaxLightUnits.Enabled := AdaptiveLightButton.Checked;
  MaxLightEdit.Enabled := AdaptiveLightButton.Checked;
  MaxLightComment.Enabled := AdaptiveLightButton.Checked;
  MinLightLabel.Enabled := AdaptiveLightButton.Checked;
  MinLightUnits.Enabled := AdaptiveLightButton.Checked;
  MinLightEdit.Enabled := AdaptiveLightButton.Checked;
  MinLightComment.Enabled := AdaptiveLightButton.Checked;

end;


procedure TEdit_Plant.DataSource3DataChange(Sender: TObject;
  Field: TField);
begin
   PlantTypeBoxchange(Sender);
   AdaptiveLightButtonClick(nil);
end;

procedure TEdit_Plant.LoadButtonClick(Sender: TObject);
begin
  Application.CreateForm(TDb_GetEntry, Db_GetEntry);
  If Db_GetEntry.LoadToUnderlyingData('Plant',Table3) then Changed := True;
  DB_GetEntry.Free;
end;

procedure TEdit_Plant.savelibClick(Sender: TObject);
Var S: ShortString;
    RI: Integer;
begin
  RI := IndexByName(Table3,Table3.Fields[0].AsString);
  If Library_File.SaveToLibrary('Plant',Table3,S,RI) then
end;

(* SPECIAL CODE TO READ IN 2.61 LIBRARY FILE *)

(*
addcomment  $I translate.inc}

    Var RDir: ShortString;

    PP: PPlant;
    PC_FileN:  String;
    FileStream: TFileStream;
    Loop: AllVariables;
    ToxLoop: T_SVType;

begin

  PC_FileN:= 'c:\newtemp\fileupdateplant.aud';
  FileStream:=TFileStream.Create(PC_FileN,fmOpenRead);

  TRY
     PP := New(PPlant,Init(NullStateVar,StV,'',Nil,0,True));
     New(PP^.PAlgalRec);

  REPEAT


     With PP^ do
       Begin
         TranslateAlgalRec(TStream(FileStream),2.61,PAlgalRec^,nullstatevar);
       End;

     With Table3 do
       Begin
         Active:=False;
         DatabaseName:=program_dir;
         TableName:='PlntFORM.DB';
         EmptyTable;
         Active:=True;
         Append;
         Fields[0].AsString:=PP^.PAlgalRec^.PlantName;
         Post;
         Active:=False;
         PlantRecord_to_Dbase(Table3.DatabaseName,Table3.TableName,PP^.Palgalrec^.PlantName,PP^.Palgalrec^);
         Active := True;
       End;

  Library_File.SaveToLibrary('Plant',Table3,RDir);

  Until FALSE;

  EXCEPT
    PP^.Done;
    FileStream.Destroy;
  END;

End; *)



procedure TEdit_Plant.HelpButtonClick(Sender: TObject);
begin
    HTMLHelpContext('Topic21.htm');
end;

procedure TEdit_Plant.TaxonomicTypeBoxExit(Sender: TObject);
begin
  Changed := True;
end;

procedure TEdit_Plant.DBEdit39Exit(Sender: TObject);
Var PctRun, PctRiffle,PctPool: Double;
begin
  Grid.BringToFront;
  If not SortedGrid then
    Begin
      Grid.Columns[39].Index := 1;
      Grid.Columns[43].Index := 1;
      Grid.Columns[77].Index := 1;  {move sci name up front}
      SortedGrid := True;
    End;

  PctRiffle:=Table3.FieldByName('PctRiffle').AsFloat;
  PctPool:=Table3.FieldByName('PctPool').AsFloat;
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

procedure TEdit_Plant.SpeciesDataButtonClick(Sender: TObject);
begin
    Application.CreateForm(TSpeciesDialog, SpeciesDialog);
  Try
    SpeciesDialog.IsPlantspec := True;
    SpeciesDialog.SVPtr   := Edit_Plant.SVPtr;
    SpeciesDialog.SpecPtr := Edit_Plant.SpecPtr;
    SpeciesDialog.EditSpecies(Table3.Fields[0].AsString);
  Finally
    SpeciesDialog.Free;
  End;

end;

procedure TEdit_Plant.FormShow(Sender: TObject);
begin
  Parmwarning.Visible := LibraryMode;
  DBEdit39Exit(nil);
end;

procedure TEdit_Plant.GridButtClick(Sender: TObject);
var i: Integer;
begin
  Grid.Columns.Items[0].Width := 180;
  For i := 0 to Grid.Columns.Count - 1 do
    if Grid.Columns.Items[i].Width > 180 then Grid.Columns.Items[i].Width := 180;

  Grid.Visible := not Grid.Visible;
  PrintButton.Enabled := not Grid.Visible;
  Scrollbox1.Visible := not Scrollbox1.Visible;
end;

procedure TEdit_Plant.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Shift = [ssCtrl]) and (Key = VK_DELETE) and (Not LibraryMode) then
     Key := 0; {ignore}
end;

procedure TEdit_Plant.EditAllLinksClick(Sender: TObject);
Var RI,i : Integer;
    TP: TPlant;
    SVLoop: AllVariables;
Begin
   If LibraryMode then Exit;

    RI := IndexByName(Table3,Table3.Fields[0].AsString);

    Application.CreateForm(TToxLinksEdit, ToxLinksEdit);
    ToxLinksEdit.EditAllLinks(TStateVariable(SVPtr).AllStates);

    If ToxLinksEdit.Changed then
     Begin
       Table3.First;
       For SVLoop := FirstPlant to LastPlant do
         Begin
            Table3.Edit;
            TP := TStateVariable(SVPtr).GetStatePointer(SVLoop,STV,WaterCol);
            If TP<>nil then Begin
                              Table3.FieldByName('Toxicity Record').AsString := TP.PAlgalRec^.ToxicityRecord;
                              Table3.Next;
                            End;
         End; {SVLoop}
       ToxChanged := True;
     End;

    If RI>0 then
      Begin
        Table3.First;
        For i := 2 to RI do
          Table3.Next;
      End;

    ToxLinksEdit.Free;
end;

procedure TEdit_Plant.EditPlantLinks2Click(Sender: TObject);
begin
    Application.CreateForm(TPlantLinksEdit, PlantLinksEdit);
    PlantLinksEdit.EditAllLinks(TStateVariable(SVPtr).AllStates);
    If PlantLinksEdit.Changed then
      Begin       
        PlantLinkChanged := True;
        PAllVariables(Specptr)^ := TPlant(SVPtr).PSameSpecies^;
      End;

    PlantLinksEdit.Free;
end;


procedure TEdit_Plant.ExportExcelClick(Sender: TObject);
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
      qry := TQuery(TDataSource(dbgrd.DataSource).DataSet);

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

end.
