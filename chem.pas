//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Chem;


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,Printfrm,
  Printing, SV_IO, ChemTox, Forms, Dialogs, StdCtrls, DBCtrls, ExtCtrls, Mask,
  DB, DBTables, Finddlg, Global, DbEntry, Librarys, Aquaobj,PFA_form,
  Grids, DBGrids, dbgrids2, hh;

type
  TEdit_Chemical = class(TPrintingForm)
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    ScrollBox1: TScrollBox;
    LabelC:   TLabel;
    Label1:   TLabel;
    Label2:   TLabel;
    kowl1: TLabel;
    Label8:   TLabel;
    Label6:   TLabel;
    Label14:  TLabel;
    Label15:  TLabel;
    Label16:  TLabel;
    Label19:  TLabel;
    DBEdit1:  TDBEdit;
    DBEdit2:  TDBEdit;
    DBEdit3:  TDBEdit;
    DBEdit5:  TDBEdit;
    DBEdit6:  TDBEdit;
    DBEdit7:  TDBEdit;
    KowE1: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit25: TDBEdit;
    DBEdit10: TDBEdit;
    Label5:   TLabel;
    HenryLawEdit: TDBEdit;
    Label20:  TLabel;
    DCE1: TDBEdit;
    DCL2: TLabel;
    Label22:  TLabel;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit26: TDBEdit;
    KowE2: TDBEdit;
    DBEdit28: TDBEdit;
    DBEdit29: TDBEdit;
    DBEdit30: TDBEdit;
    DBEdit33: TDBEdit;
    DBEdit34: TDBEdit;
    DBEdit38: TDBEdit;
    DBEdit41: TDBEdit;
    Label24:  TLabel;
    Label25:  TLabel;
    Label26:  TLabel;
    Label29:  TLabel;
    KowL2: TLabel;
    Label31:  TLabel;
    Label32:  TLabel;
    F: TLabel;
    DBEdit9:  TDBEdit;
    DBEdit31: TDBEdit;
    Label33:  TLabel;
    Label4:   TLabel;
    Label11:  TLabel;
    Label12:  TLabel;
    Label13:  TLabel;
    Label9:   TLabel;
    DBText1:  TDBText;
    ToxButton: TButton;
    Label18:  TLabel;
    Bevel2:   TBevel;
    FindButton: TButton;
    NewButton: TButton;
    SaveButton: TButton;
    Table1: TTable;
    CancelButton: TButton;
    PrintButton: TButton;
    PrintDialog1: TPrintDialog;
    DCL1: TLabel;
    DBEdit20: TDBEdit;
    Label23: TLabel;
    Label3: TLabel;
    Label36: TLabel;
    KPSedEdit: TDBEdit;
    KPSedComment: TDBEdit;
    DBEdit65: TDBEdit;
    DBEdit66: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    L1: TLabel;
    EquilLabel: TLabel;
    L2: TLabel;
    Label10: TLabel;
    EraseTable: TTable;
    savelib: TButton;
    KPSedUnit: TLabel;
    KPSedCheckBox: TDBCheckBox;
    Bevel1: TBevel;
    Label17: TLabel;
    KPSedLabel: TLabel;
    Label28: TLabel;
    Label38: TLabel;
    SICaption: TLabel;
    Bevel3: TBevel;
    Label35: TLabel;
    SICLabel: TLabel;
    SINCLabel: TLabel;
    SINC2Label: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    SICEdit1: TDBEdit;
    SINCEdit1: TDBEdit;
    SINC2Edit1: TDBEdit;
    SICEdit2: TDBEdit;
    SINCEdit2: TDBEdit;
    SINC2Edit2: TDBEdit;
    SICEdit3: TDBEdit;
    SINCEdit3: TDBEdit;
    SINC3Edit3: TDBEdit;
    SICEdit4: TDBEdit;
    SINCEdit4: TDBEdit;
    SINC4Edit4: TDBEdit;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label56: TLabel;
    PFAPanel1: TPanel;
    PFAPanel2: TPanel;
    PFAbutton: TButton;
    PFAPanel3: TPanel;
    Label7: TLabel;
    DBEdit8: TDBEdit;
    DBEdit12: TDBEdit;
    parmwarning: TLabel;
    GridButt: TButton;
    Grid: tdbgrid2;
    Button1: TButton;
    HelpButton: TButton;
    Label21: TLabel;
    KOMRefrDOMUnit: TLabel;
    Label34: TLabel;
    KOMRefrDOMLabel: TLabel;
    Label55: TLabel;
    KOMRefrDOMEdit: TDBEdit;
    XKOMREFRDOMEdit: TDBEdit;
    DBCheckBox2: TDBCheckBox;
    Label57: TLabel;
    Label58: TLabel;
    ExportExcel: TButton;
    Label27: TLabel;
    Label30: TLabel;
    DBEdit4: TDBEdit;
    Label37: TLabel;
    DBEdit11: TDBEdit;
    Procedure FormResize(Sender: TObject);
    Procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    Procedure ToxButtonClick(Sender: TObject);
    Procedure FindButtonClick(Sender: TObject);
    Procedure Calc_Eq_Days(Sender: TObject);
    Procedure NewButtonClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure AppException(Sender: TObject; E: Exception);
    Procedure Return_Posts(Sender: TObject; var Key: Char);
    Procedure SaveButtonClick(Sender: TObject);
    Procedure CancelButtonClick(Sender: TObject);
    Procedure PrintButtonClick(Sender: TObject);
    Procedure LoadButtonClick(Sender: TObject);
    Procedure CalcKSed(Sender: TObject);
    Procedure savelibClick(Sender: TObject);
    procedure KPSedCheckBoxClick(Sender: TObject);
    procedure Table1AfterOpen(DataSet: TDataSet);
    procedure PFAbuttonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DBCheckBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure GridButtClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure DBCheckBox2Click(Sender: TObject);
    procedure ExportExcelClick(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Table1AfterScroll(DataSet: TDataSet);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
  public
    LibraryMode, Changed: Boolean;
    ExtTox: Boolean;
    MultiLayerOn: Boolean;
    PLipidModified: PBoolean;
    Procedure PFAenabledisable;
    { Public declarations }
  end;

var
  Edit_Chemical: TEdit_Chemical;
  retpress: boolean;

implementation

uses Convert, Math, ExcelFuncs, Excel2000, WAIT;

{$R *.DFM}

Procedure TEdit_Chemical.FormResize(Sender: TObject);
begin
    ScrollBox1.Height:=edit_chemical.ClientHeight-59;
    ScrollBox1.Width:=edit_chemical.ClientWidth-2;
   Grid.Height:=edit_chemical.ClientHeight-59;
   Grid.Width:=edit_chemical.ClientWidth+2;

end;

Procedure TEdit_Chemical.DBNavigator1Click(Sender: TObject;
  Button: TNavigateBtn);
  {Come back to top of scroll box when navigator is utilized}
begin
    Scrollbox1.VertScrollBar.Position:=0;
    PFAEnableDisable;
end;

procedure TEdit_Chemical.ExportExcelClick(Sender: TObject);
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

Procedure TEdit_Chemical.ToxButtonClick(Sender: TObject);
Var ToxName: String;
    pKA,ph_Val,NonDissocCalc: Double;
    ModalR: TModalResult;
    FileN: array[0..300] of Char;
    ThisField: TField;
    AnimLipid,PlantLipid: Array of Double;
    Loop: INteger;

begin
 AnimLipid := nil; PlantLipid:=nil;


 {Send Values to the CHEMTOX form for calculations}
 ChemToxForm.Is_PFA :=  Table1.FieldbyName('ISPFA').AsBoolean;
 ChemToxForm.IsSulfonate :=  Lowercase(Table1.FieldbyName('PFAType').AsString) = 'sulfonate';
 ChemToxForm.ChainLength :=  Table1.FieldbyName('PFAChainLength').AsFloat;

 ChemToxForm.LogKOW :=  Table1.FieldbyName('Octanol Water Coeff').AsFloat;
 ChemToxForm.ChemicalName := Table1.Fields[0].AsString;
 ChemToxForm.Caption := 'Chemical Toxicity Parameters -- '+Table1.Fields[0].AsString;

 pKA    := Table1.FieldbyName('Pka').AsFloat;
 pH_Val := 7;  {Assume neutral pH for NondissocCalc calculation}
 If pKa=0
   then NondissocCalc := 1
   else If pKa<0
     then NondissocCalc := 1 /(1+POWER(10,pKa-pH_Val))
     else NondissocCalc := 1 /(1+POWER(10,pH_Val-pKa));

 ChemToxForm.NonDissoc:=NondissocCalc;

 {Setup and Show the CHEMTOX form}

  With ChemToxForm do
  Begin
    If LibraryMode then AnimOptions.Visible := False;
    If LibraryMode then PlantOptions.Visible := False;
    If LibraryMode then ExtToxLabel.Visible := False
                   else ExtToxLabel.Visible := ExtTox;
  End;

 ToxName :=  Table1.Fields[0].AsString;
 With ChemToxForm do
  Begin

   If LibraryMode then
       Begin  {Create temporary files so "Cancel" is possible}
        If FileExists(Default_Dir+'ChemToxDBs\'+ToxName+'_Animal_Tox.DB')
          then AQTCopyFile(Default_Dir+'ChemToxDBs\'+ToxName+'_Animal_Tox.DB',
                           Default_Dir+'ChemToxDBs\'+ToxName+'_Animal_Tox_BAK.DB');

         Table1.TableName:=Edit_Chemical.Table1.Fields[0].AsString+'_Animal_Tox_BAK.DB';
         Table1.DatabaseName := Default_Dir+'ChemToxDBs\';
       End
     Else
       Begin
         Table1.TableName := 'AnimToxForm.DB';
         Table1.DatabaseName := Program_Dir;
       End;

    If FileExists (Table1.DatabaseName+Table1.TableName) then
      Begin
        Table1.Active:=True;
        AnimFNF.Visible:=False;

        Table1.First;
        SetLength(AnimLipid,Table1.RecordCount);
          For Loop := 1 to Length(AnimLipid) do
            Begin
              AnimLipid[Loop-1] := Table1.FieldByName('Lipid Frac').AsFloat;
              Table1.Next;
            End;
        Table1.First;

      End
    else Begin
           AnimFNF.Caption:='File Not Found : '+Table1.DatabaseName+Table1.TableName;
           AnimFNF.Visible:=True;
         End;

  If LibraryMode then
       Begin
          If FileExists(Table1.DatabaseName+ToxName+'_Plant_Tox.DB')
          then AQTCopyFile(Table1.DatabaseName+ToxName+'_Plant_Tox.DB',
                           Table1.DatabaseName+ToxName+'_Plant_Tox_BAK.DB');

         Table2.TableName:=Edit_Chemical.Table1.Fields[0].AsString+'_Plant_Tox_BAK.DB';
         Table2.DatabaseName := Default_Dir+'ChemToxDBs\';
       End
     Else
       Begin
         Table2.TableName := 'PlantToxForm.DB';
         Table2.DatabaseName := Program_Dir;
       End;

    If FileExists(Table2.DatabaseName+Table2.TableName)then
      Begin
        Table2.Active:=True;
        PlantFNF.Visible:=False;

        Table2.First;
        SetLength(PlantLipid,Table2.RecordCount);
          For Loop := 1 to Length(PlantLipid) do
            Begin
              PlantLipid[Loop-1] := Table2.FieldByName('Lipid Frac').AsFloat;
              Table2.Next;
            End;
        Table2.First;

      End
    else Begin
           PlantFNF.Caption:='File Not Found : '+Table2.DatabaseName+Table2.TableName;
           PlantFNF.Visible:=True;
         End;

   CancelBtn.Visible := LibraryMode;

   If Table1.Active then
     Begin
       ThisField := Table1.FieldbyName('K2 Elim. rate const (1/d)');
       TFloatField(ThisField).DisplayFormat := '#.###E+00';
       ThisField := Table1.FieldbyName('LC50 (ug/L)');
       TFloatField(ThisField).DisplayFormat := '0.###';
       ThisField := Table1.FieldbyName('EC50 growth (ug/L)');
       TFloatField(ThisField).DisplayFormat := '0.####';
       ThisField := Table1.FieldbyName('EC50 repro (ug/L)');
       TFloatField(ThisField).DisplayFormat := '0.####';
     End;

   If Table2.Active then
     Begin
       ThisField := Table2.FieldbyName('K2 Elim. rate const (1/d)');
       TFloatField(ThisField).DisplayFormat := '0.####';
     End;


   ModalR := ShowModal;
   If ChemToxForm.Changed then Edit_Chemical.Changed := True;

   If (not LibraryMode) and (ModalR=mrOK) then
     Begin
       Table1.First;
       If Length(AnimLipid)<>Table1.RecordCount
         then PLipidModified^ := True
         else
           For Loop := 1 to Length(AnimLipid) do
             Begin
               If AnimLipid[Loop-1] <> Table1.FieldByName('Lipid Frac').AsFloat then PLipidModified^ := True;
               Table1.Next;
             End;

       Table2.First;
       If Length(AnimLipid)<>Table1.RecordCount
         then PLipidModified^ := True
         else
           For Loop := 1 to Length(PlantLipid) do
             Begin
               If PlantLipid[Loop-1] <> Table2.FieldByName('Lipid Frac').AsFloat then PLipidModified^ := True;
               Table2.Next;
             End;
     End;


   Table1.Active:=False;
   Table2.Active:=False;

   If LibraryMode and (ModalR=mrOK) then
     Begin  {Copy temporary files over the actual databases}
        If FileExists(Table1.DatabaseName+ToxName+'_Animal_Tox_BAK.DB')
          then AQTCopyFile(Table1.DatabaseName+ToxName+'_Animal_Tox_BAK.DB',
                           Table1.DatabaseName+ToxName+'_Animal_Tox.DB');
        If FileExists(Table1.DatabaseName+ToxName+'_Plant_Tox_BAK.DB')
          then AQTCopyFile(Table1.DatabaseName+ToxName+'_Plant_Tox_BAK.DB',
                           Table1.DatabaseName+ToxName+'_Plant_Tox.DB');
      End;

   If LibraryMode then
     Begin  {Delete temporary files}
        If FileExists(Table1.DatabaseName+ToxName+'_Animal_Tox_BAK.DB')
          then Begin
                 StrPCopy(FileN,Table1.DatabaseName+ToxName+'_Animal_Tox_BAK.DB');
                 DeleteFile(FileN);
               End;

        If FileExists(Table1.DatabaseName+ToxName+'_Plant_Tox_BAK.DB')
          then Begin
                 StrPCopy(FileN,Table1.DatabaseName+ToxName+'_Plant_Tox_BAK.DB');
                 DeleteFile(FileN);
               End;
     End;

  End; {with form}

  AnimLipid := nil;
  PlantLipid := nil;
end;   {TOXBUTTONCLICK}

Procedure TEdit_Chemical.FindButtonClick(Sender: TObject);
{Handle the Find Button}
begin
    Application.CreateForm(TSearchDialog, SearchDialog);
    SearchDialog.Searchtype.caption := 'chemical';
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
   PFAEnableDisable;
end;

Procedure TEdit_Chemical.Calc_Eq_Days(Sender: TObject);
{Calculate Days to Equilibrium from Log P}

Var LogKOW: Double;
    S   : ShortString;

begin
    LogKOW := Table1.FieldbyName('Octanol Water Coeff').AsFloat;
    If (LogKOW>0) and (LogKOW<50) then
                   begin
                     Str(4.605/8.8*POWER(POWER(10.0,LogKOW), 0.663)/24.0:4:2,S);
                     EquilLabel.Caption:=S;
                   end
       else if LogKOW>=50 then EquilLabel.Caption:='** Too Big **'
       else EquilLabel.Caption:='(Uncalculable)';
end;

procedure TEdit_Chemical.Button1Click(Sender: TObject);
begin
  Application.CreateForm(TConvertform,ConvertForm);
  ConvertForm.ConvertNumber(HenryLawEdit,CTHenry);
  ConvertForm.Free;

end;

Procedure TEdit_Chemical.CalcKSed(Sender: TObject);
Var pKA, pH_Val, Nondissoc, LogKOW: Double;
    KPSed, KOM, KOW, IonCorr, KOMRefrDOM: Double;
    ChemIsBase: Boolean;
{const  KSA = 26300;}

begin

With Table1 do
begin
  {Get and Calculate Intermediate Values}
  LogKOW := FieldbyName('Octanol Water Coeff').AsFloat;
  KOW    := POWER(10,LogKow);
  pKA    := FieldbyName('Pka').AsFloat;
  ChemIsBase := DBCHeckBox1.Checked;

  pH_Val := 7;  {Assume neutral pH for nondissoc calculation}
                {However, if the user does not change the KPSED value, KPSED is
                 calculated dynamically in the CalculateKPSED function in Toxprocs.Inc}
  If pKa=0
    then Nondissoc := 1
    else If pKa<0
      then Nondissoc := 1 /(1+POWER(10,pKa-pH_Val))
      else Nondissoc := 1 /(1+POWER(10,(pH_Val-1)-pKa));  {charged particle}

  {THESE EQUATIONS ARE MIRRORED IN Function CalculateKPSed in TOXPROCS.INC
   CHANGES IN THESE EQUATIONS SHOULD BE MADE THERE}

  If ChemIsBase then IonCorr := 0.01
                else IonCorr := 0.1;

  {Calculate KPSed}
  If (LogKOW > 14) or (LogKOW<=0)
     then KOM := 0
     else KOM := (NonDissoc *  1.38 * POWER(KOW,0.82) + (1-NonDissoc) * IonCorr *  1.38 * POWER(KOW,0.82));
       {generalized from Schwarzenbach et al. 1993, p. 275 and Smejtek and Wang, 1993, for ionized compound}

  KPSed  :=  KOM     /  0.526;
 {L/kg OC} {L/kg OM} {g OC / g OM}

  KOMRefrDOM := (NonDissoc *  2.88 * POWER(KOW,0.67) + (1-NonDissoc) * IonCorr *  2.88 * POWER(KOW,0.67)) * 0.526;

     {Added 3/13/2009}

  If (LogKOW <= 14) and (LogKOW > 0)
    then Begin
           KPSedLabel.Caption := FloatToStrF(KPSed,ffExponent,4,4);
           KOMRefrDOMLabel.Caption := FloatToStrF(KOMRefrDOM,ffExponent,4,4);
         End
    else Begin
           KPSedLabel.Caption := '(Uncalculable)';
           KOMRefrDOMLabel.Caption := '(Uncalculable)';
         End;


 end; {with}
end;  {CALCKSED}


Procedure TEdit_Chemical.NewButtonClick(Sender: TObject);
{the New Button}
Var Counter: Integer;
    name   : ShortString;

begin
  Counter:=0;
  name:='';
  Repeat         {Protect against multiple names}
     Counter:=Counter+1;
     If Counter>1 then Str(Counter,Name);
     name:='NewChemical'+name;
  until not Table1.FindKey([name]);

  Table1.InsertRecord([name]);  {Insert the new Record}
  DBEdit1.SetFocus;
  DBEdit1.Selectall;
end;


Procedure TEdit_Chemical.FormCreate(Sender: TObject);
{Enable Exception Handling}
begin
   inherited;
   Changed := False;
   RetPress:=False;
   Application.OnException:=AppException;


end;

procedure TEdit_Chemical.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  If Grid.Visible then Grid.Perform(WM_VSCROLL,1,0)
                  else Scrollbox1.Perform(WM_VSCROLL,1,0);
end;

procedure TEdit_Chemical.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  If Grid.Visible then Grid.Perform(WM_VSCROLL,0,0)
                  else ScrollBox1.Perform(WM_VSCROLL,0,0);
end;

Procedure TEdit_Chemical.AppException(Sender: TObject; E: Exception);
begin
   If E.Message='Key violation' then  {multiple name error message}
      MessageDlg('A Chemical of that Name Already Exists, Please Give Your Entry a New Name',mtError,[mbOK],0)
   else
   Application.ShowException(E);      {mainly handles invalid # format}
end;


{THE FOLLOWING Procedure HANDLES THE EVENT WHEN THE USER PRESSES RETURN.
 The program used to just beep which was quite annoying to this user.
 It would be nice if it tabbed to the next field, but I couldn't figure
 out how to do that. jonc}

Procedure TEdit_Chemical.Return_Posts(Sender: TObject; var Key: Char);
begin
  Changed := True;
  If Key=#13 then if Table1.State in [dsedit,dsinsert] then
   begin      {enables return key}
     retpress:=true;
     Tdbedit(sender).enabled:=false;
     Tdbedit(sender).enabled:=true;
     Table1.Post;
     retpress:=false;
   end; {if}
end;

Procedure TEdit_Chemical.SaveButtonClick(Sender: TObject);
begin
   if table1.State in [dsedit,dsinsert] then Table1.Post;
   If not LibraryMode then Edit_Chemical.ModalResult:=MROK
      else if MessageDlg('Save changes and exit?',mtConfirmation,mbOKCancel,0)=mrOK
           then Edit_Chemical.ModalResult:=MROK;
end;

Procedure TEdit_Chemical.CancelButtonClick(Sender: TObject);
begin
      If MessageDlg('Discard all edits?',mtConfirmation,mbOKCancel,0)=mrOK then
         Edit_Chemical.ModalResult:=MRCancel;
end;

Procedure TEdit_Chemical.PrintButtonClick(Sender: TObject);
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
  GridButt.Visible:=False;
  ExportExcel.Visible:=False;

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
  GridButt.Visible:=not LBV;
  ExportExcel.Visible:=not LBV;

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

Procedure TEdit_Chemical.LoadButtonClick(Sender: TObject);
{setup DB_GetEntry Dialog and call it modally... Then load the
 selected data if appropriate}
Begin

  Application.CreateForm(TDb_GetEntry, Db_GetEntry);

  With Db_GetEntry do
  begin
    If not LoadToUnderlyingData('Chemical',Edit_Chemical.Table1) then
      Begin
        Db_GetEntry.Free;
        exit;
      End;
    Changed := True;

             (*   HANDLE ASSOCIATED ANIMAL AND PLANT TOXICITY DATABASES  *)

             If not FileExists(FileDir+'\ChemToxDBs\'+Entry+'_Animal_Tox.DB')
               Then Begin
                      MessageDlg('Associated Animal Toxicity file '+FileDir+'\ChemToxDBs\'+Entry+'_Animal_Tox.DB does'+
                                 'not exist.  Emptying Tox Record.',mterror,[mbOK],0);
                      EraseTable.DatabaseName:=Program_Dir; EraseTable.TableName:='AnimToxForm.DB';
                      EraseTable.EmptyTable;
                    End
               Else AQTCopyFile(FileDir+'\ChemToxDBs\'+Entry+'_Animal_Tox.DB',Program_Dir+'AnimToxForm.DB' );

             If not FileExists(FileDir+'\ChemToxDBs\'+Entry+'_Plant_Tox.DB')
               Then Begin
                      MessageDlg('Associated Plant Toxicity file '+FileDir+'\ChemToxDBs\'+Entry+'_Plant_Tox.DB does'+
                                 'not exist.  Emptying Tox Record.',mterror,[mbOK],0);
                      EraseTable.DatabaseName:=Program_Dir; EraseTable.TableName:='PlantToxForm.DB';
                      EraseTable.EmptyTable;
                    End
               Else AQTCopyFile(FileDir+'\ChemToxDBs\'+Entry+'_Plant_Tox.DB',Program_Dir+'\PlantToxForm.DB' );


  end; {with} 
  DB_GetEntry.Free;
End; {Procedure}



Procedure TEdit_Chemical.savelibClick(Sender: TObject);
Var Ent: String;
    RDir: ShortString;
    RI: Integer;
Begin
  RI := IndexByName(Table1,Table1.Fields[0].AsString);
  If Library_File.SaveToLibrary('Chemical',Table1,RDir,RI) then
    Begin
     { HANDLE ASSOCIATED ANIMAL AND PLANT TOXICITY DATABASES }
       Ent := Table1.Fields[0].AsString;

       AQTCopyFile(Program_Dir+'\AnimToxForm.DB',RDir+'\ChemToxDBs\'+Ent+'_Animal_Tox.DB');
       AQTCopyFile(Program_Dir+'\PlantToxForm.DB',RDir+'\ChemToxDBs\'+Ent+'_Plant_Tox.DB');

       MessageDlg('Toxicity Databases also written successfully.',MtInformation,[mbOK],0);
    End;
End;

(* Procedure TEdit_Chemical.ModifyToxClick(Sender: TObject);
Var  ToxName: String;
     TC: PChemical;
Begin
  TC := New(PChemical,Init());
  ToxName :=  Table1.Fields[0].AsString;
  TC.DBase_to_AnimToxColl(Default_Dir,ToxName+'_Animal_Tox.DB'); {modifications here}
  TC.AnimToxColl_To_DBase(Program_Dir,'AnimToxForm.DB');
  AQTCopyFile(Program_Dir+'\AnimToxForm.DB',Default_Dir+'\'+ToxName+'_Animal_Tox.DB');

  TC := New(PChemical,Init());
  ToxName :=  Table1.Fields[0].AsString;
  TC.DBase_to_PlantToxColl(Default_Dir,ToxName+'_Plant_Tox.DB'); {modifications here}
  TC.PlantToxColl_To_DBase(Program_Dir,'PlantToxForm.DB');
  AQTCopyFile(Program_Dir+'\PlantToxForm.DB',Default_Dir+'\'+ToxName+'_Plant_Tox.DB');
End;

*)

procedure TEdit_Chemical.KPSedCheckBoxClick(Sender: TObject);
Var CalcKPSed: Boolean;
begin
  CalcKPSed := KPSedCheckBox.Checked or Table1.FieldbyName('IsPFA').AsBoolean;
  KPSedEdit.Enabled := not CalcKPSed;
  KPSedComment.Enabled := not CalcKPSed;
  KPSedUnit.Enabled := not CalcKPSed;

end;

procedure TEdit_Chemical.Table1AfterOpen(DataSet: TDataSet);
begin
  CalcKSed(nil);
end;

procedure TEdit_Chemical.Table1AfterScroll(DataSet: TDataSet);
begin
    If Visible and (Not LibraryMode) then
    Begin
      ToxButton.Enabled := False;
    End;
end;

procedure TEdit_Chemical.PFAbuttonClick(Sender: TObject);
Var St: String;
    TBE: Boolean;
begin
  Application.CreateForm(TPFAForm, PFAForm);
  PFAForm.PFATitle.Caption := 'PFA Parameters for '+DBText1.Caption;

  if Table1.State in [dsedit,dsinsert] then Table1.Post;
  St:= Table1.Fields[0].AsString;
  Table1.Active:=False;

  With PFAForm.Table1 do
    begin
      TableName:=Table1.TableName;
      DatabaseName:=Table1.DatabaseName;
      Active := True;
      First;
      While Fields[0].AsString <> St do
        Next;
    end;

  PFAForm.Caption := 'PFA Specific Parameters -- '+St;
  PFAForm.Showmodal;
  If PFAForm.Table1.State in [dsedit,dsinsert] then PFAForm.Table1.Post;
  PFAForm.Table1.Active:=False;

  TBE := ToxButton.Enabled;
  Table1.Active:=True;
  With Table1 do
    Begin
      First;
      While Fields[0].AsString <> St do
        Next;
    End;
  ToxButton.Enabled := TBE;

  FormResize(nil);
  PFAForm.Free;
  PFAEnableDisable;
End;


procedure TEdit_Chemical.PFAenabledisable;
Var IsPFA: Boolean;
Begin
  IsPFA := Table1.FieldbyName('ISPFA').AsBoolean;
  KowL1.Enabled := Not IsPFA;
  KowL2.Enabled := Not IsPFA;
  KowE1.Enabled := Not IsPFA;
  KowE2.Enabled := Not IsPFA;
  PFAPanel1.Visible := IsPFA;
  DCL1.Enabled := Not IsPFA;
  DCL2.Enabled := Not IsPFA;
  DCE1.Enabled := Not IsPFA;
  PFAPanel2.Visible := IsPFA;
  If IsPFA then PFAPanel3.BringToFront;
  PFAPanel3.Visible := IsPFA;
  L1.Visible        := Not IsPFA;
  L2.Visible        := Not IsPFA;
  EquilLabel.Visible := Not IsPFA;
End;


procedure TEdit_Chemical.FormActivate(Sender: TObject);
begin
  PFAEnableDisable;
  FormResize(nil);
end;

procedure TEdit_Chemical.DBCheckBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Changed := True;     CalcKSed(nil)
end;

procedure TEdit_Chemical.DBCheckBox2Click(Sender: TObject);
Var CalcKOMRefrDOM: Boolean;
begin
  CalcKOMRefrDOM := DBCheckBox2.Checked or Table1.FieldbyName('IsPFA').AsBoolean;
  KOMRefrDOMEdit.Enabled := not CalcKOMRefrDOM;
  XKOMRefrDOMEdit.Enabled := not CalcKOMRefrDOM;
  KOMRefrDOMUnit.Enabled := not CalcKOMRefrDOM;  
end;

procedure TEdit_Chemical.FormShow(Sender: TObject);
Var NCShow: Boolean;
begin
  Parmwarning.Visible := LibraryMode;
  GridButt.Visible := DBNavigator1.Visible;
  ExportExcel.Visible := DBNavigator1.Visible;

  Grid.BringToFront;
  Grid.Columns[34].Index := 29;
  Grid.Columns[7].Title.Caption := 'Dissociation Const.(Pka)';
  Grid.Columns[7].Index := 6;
  Grid.Columns[8].Index := 1;

  NCShow := LibraryMode or MultiLayerOn;
  SICaption.Enabled := NCShow;
  SICLabel.Enabled := NCShow;
  SINCLabel.Enabled := NCShow;
  SINC2Label.Enabled := NCShow;
  Label42.Enabled := NCShow;
  Label43.Enabled := NCShow;
  Label44.Enabled := NCShow;
  Label45.Enabled := NCShow;
  Label46.Enabled := NCShow;
  Label47.Enabled := NCShow;
  Label48.Enabled := NCShow;
  Label49.Enabled := NCShow;
  Label50.Enabled := NCShow;
  SICEdit1.Enabled := NCShow;
  SINCEdit1.Enabled := NCShow;
  SINC2Edit1.Enabled := NCShow;
  SICEdit2.Enabled := NCShow;
  SINCEdit2.Enabled := NCShow;
  SINC2Edit2.Enabled := NCShow;
  SICEdit3.Enabled := NCShow;
  SINCEdit3.Enabled := NCShow;
  SINC3Edit3.Enabled := NCShow;
  SICEdit4.Enabled := NCShow;
  SINCEdit4.Enabled := NCShow;
  SINC4Edit4.Enabled := NCShow;

end;

procedure TEdit_Chemical.GridButtClick(Sender: TObject);
var i: Integer;
begin
  Grid.Columns.Items[0].Width := 180;
  For i := 0 to Grid.Columns.Count - 1 do
    if Grid.Columns.Items[i].Width > 180 then Grid.Columns.Items[i].Width := 180;

  Grid.Visible := not Grid.Visible;
  PrintButton.Enabled := not Grid.Visible;
  Scrollbox1.Visible := not Scrollbox1.Visible;
end;

procedure TEdit_Chemical.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (Shift = [ssCtrl]) and (Key = VK_DELETE) and (Not LibraryMode) then
     Key := 0; {ignore}
end;

procedure TEdit_Chemical.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic22.htm');
end;

End.





