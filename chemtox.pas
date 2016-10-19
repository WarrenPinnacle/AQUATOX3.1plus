//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
unit ChemTox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, DB,  DBTables, StdCtrls, ExtCtrls, Buttons, Global, Librarys,
  Grid2Excel, AQBaseForm, hh;

type
  TChemToxForm = class(TAQBase)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    LabelC: TLabel;
    Label1: TLabel;
    DataSource1: TDataSource;
    Table1: TTable;
    DataSource2: TDataSource;
    Table2: TTable;
    AnimFNF: TPanel;
    PlantFNF: TPanel;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    FishRegrButton: TButton;
    AnimalEC50Button: TButton;
    PlantLC50Button: TButton;
    CreateAnimTox: TButton;
    CreatePlantTox: TButton;
    CancelBtn: TBitBtn;
    AddAnimal: TButton;
    AddPlant: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    HelpButton: TButton;
    AnimOptions: TPanel;
    AnimDefault: TRadioButton;
    AnimBCFCalc: TRadioButton;
    PlantOptions: TPanel;
    AnimK2Calc: TRadioButton;
    AnimK1Calc: TRadioButton;
    PlantDefault: TRadioButton;
    PlantCalcBCF: TRadioButton;
    PlantCalcK2: TRadioButton;
    PlantCalcK1: TRadioButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    AnimalElimButton: TButton;
    PlantElimButton: TButton;
    ExtToxLabel: TLabel;
    AnimPrintButton: TButton;
    PlantExportButt: TButton;
    AnimPFAPanel: TPanel;
    procedure OKBtnClick(Sender: TObject);
    procedure CreateAnimToxClick(Sender: TObject);
    procedure CreatePlantToxClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FishRegrButtonClick(Sender: TObject);
    procedure ElimButtonClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure PlantLC50ButtonClick(Sender: TObject);
    procedure AnimalEC50ButtonClick(Sender: TObject);
    procedure AddAnimalClick(Sender: TObject);
    procedure AddPlantClick(Sender: TObject);
    procedure dbgridKeyPress(Sender: TObject; var Key: Char);
    procedure HelpButtonClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure AnimDefaultExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Table1AfterPost(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure dbgridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure PlantDefaultClick(Sender: TObject);
    procedure Table2AfterPost(DataSet: TDataSet);
    procedure AnimPrintButtonClick(Sender: TObject);
    procedure PlantExportButtClick(Sender: TObject);
  private
    { Private declarations }
    FirstShow: Boolean;
  public
    LogKOW, NonDissoc: Double;
    ChemicalName: String;
    Is_PFA, IsSulfonate, Changed: Boolean;  
    ChainLength: Double;
    AnimalMeth, PlantMeth: UptakeCalcMethodType;
    procedure updatescreen;
    { Public declarations }
  end;

var
  ChemToxForm: TChemToxForm;

  UpdateButtons: Boolean;

implementation

uses EstKPSed, ec50lc50, regress, math, PFAK2s;

{$R *.DFM}

procedure TChemToxForm.OKBtnClick(Sender: TObject);
begin
  If Table1.state in [dsedit,dsinsert] then Table1.Post;
  If Table2.state in [dsedit,dsinsert] then Table2.Post;

end;

procedure TChemToxForm.CreateAnimToxClick(Sender: TObject);
Var NewName: String;
begin
   NewName:=Table1.DatabaseName+'\'+Table1.TableName;
   AQTCopyFile(Program_Dir+'\AnimToxForm.DB' , NewName);
   Table1.EmptyTable;
   Table1.Active:=True;
   AnimFNF.Visible:=False;
   Update;
end;



procedure TChemToxForm.CreatePlantToxClick(Sender: TObject);
Var NewName: String;
begin
   NewName:=Table2.DatabaseName+'\'+Table2.TableName;
   AQTCopyFile(Program_Dir+'\PlantToxForm.DB' , NewName);
   Table2.EmptyTable;
   Table2.Active:=True;
   PlantFNF.Visible:=False;
   Update;
end;

procedure TChemToxForm.FormResize(Sender: TObject);
{Var PW: Integer; }
begin
  If Sender=nil then
    Begin
      Width  := Screen.Width;
      Height := Screen.WorkareaHeight-40;
    End;
end;


procedure TChemToxForm.ElimButtonClick(Sender: TObject);

Var KOW, K1, BCF : Double;
    WetWt, LFrac: Double;
    K2: Double;
    Loop: Integer;
    TypeStr, NameStr: String;
    ThisField: TField;
    ThisK2: Double;
    DissocFactor: Double;

      Procedure PFA_K1K2s;
      Var Loop: Integer;
          SizeCorr, ChainL: Double;
          CalcK1s: Boolean;
          Local_K1 : Double;
      Const OneOverSizeRef = 1.3797;  {reciprocal of reference wt 5^-0.2}
            WetToDry = 5;
      Begin
        CalcK1s := (TypeStr= 'Plant');  //borrowing plant button for PFA K1s

        If CalcK1s then PFAK2Form.Label3.Caption := '             Uptake Rate Coefficients will be overwritten using the chemical''s chain length,'+
                   ' the organism''s mean wet weight,  and the PFA type (sulfonate vs. carbonate).  See equations (398) to (402) in'+
                   ' the Tech Doc.  K1 values may be modified following this estimation procedure.'
                   else PFAK2Form.Label3.Caption := '             Elimination Rate Coefficients will be overwritten using the chemical''s chain length,'+
                   ' the organism''s mean wet weight,  and the PFA type (sulfonate vs. carbonate).  See equations (405) and (406) in'+
                   ' the Tech Doc.  K2 values may be modified following this estimation procedure.';

        If PFAK2Form.ShowModal = mrCancel then Exit;
        If Table1.RecordCount>0 then
          Begin
            If CalcK1s then ThisField := Table1.FieldbyName('K1 Uptake const (L/kg d)')
                       else ThisField := Table1.FieldbyName('K2 Elim. rate const (1/d)');

            TFloatField(ThisField).DisplayFormat := '0.####';

            Table1.First;
            With Table1 do
             For Loop:=1 to RecordCount do
              begin
                Edit;
                WetWt:=FieldByName('Ave. wet wt. (g)').AsFloat;

                If (WetWt > 5.0)   {if 5 g or less assume invertebrate}
                  then SizeCorr := POWER(WetWt, -0.2)  * OneoverSizeRef  // for fish
                  else SizeCorr := POWER(WetWt, -0.25) * OneoverSizeRef;  {Change 9/25/2011 invertebrates, Maloney and Field 1989}

                If CalcK1s then
                  Begin
                    ChainL := Min(ChainLength,11);
                    If Not IsSulfonate then {carboxylate} Local_K1 := POWER(10,-5.7213+0.7764*ChainL)   // JSC Removed WetToDry 2/20/2012  Eqn (398)
                                       else {sulfonate}   Local_K1 := POWER(10,-5.85+0.966*ChainL);     // JSC Removed WetToDry 2/20/2012  Eqn (401)
                    Local_K1 := Local_K1 * SizeCorr; {correct for size similar to depuration}
                    {L/kg-d      L/kg-d     unitless}

                    ThisField.AsFloat:=Local_K1;
                    If (Local_K1 >= 10000) or (Local_K1<0.0001)
                      Then TFloatField(ThisField).DisplayFormat := '#.###E+00';

                  End
                else
                  Begin
                    If Not IsSulfonate
                        then ThisK2 :=  POWER(10, -0.0873 - 0.1207 * ChainLength) * SizeCorr  {carboxylate}
                        else ThisK2 :=  POWER(10, -0.733  - 0.07   * ChainLength) * SizeCorr; {sulfonate}

                    If (ThisK2 >= 10000) or (ThisK2<0.0001)
                      Then TFloatField(ThisField).DisplayFormat := '#.###E+00';
                    ThisField.AsFloat:=ThisK2;
                  End;

                If Loop<RecordCount then next;
              end;
            Table1.Post;
            Table1.First;
          End;
      End;

      Function CalcAnimal_K2: Double;
      Var LogK2: Double;
          RB   : Double;
          C_Val: Double;
      {   BCF  : Double; }
      Begin
   {     The estimation procedure is based on a slope related to log Kow and an intercept that
         is a direct function of respiration, assuming an allometric relationship between
         respiration and the weight of the animal (Thomann 1989), and an inverse function of
         the lipid content.  1-29-02  }

        If LFrac<Tiny then Begin Result:=0; exit; End;

        If KPSedConfirm.Rashleigh.Checked then
          Begin
            If (WetWt <= 5.0)   {if 5 g or less assume invertebrate}
              then C_Val := 890
              else C_Val := 445;  {fish}

              CalcAnimal_K2 := (C_Val * POWER(WetWt, -0.197)) / (LFrac * KOW);
          End
        Else
          Begin
            RB := -0.2;
            If (WetWt < 0.2) then RB := -0.16;  {Assume zooplankton}

            If (WetWt <= 5.0)
               then LogK2 := -0.536 * LogKOW - Log10(Nondissoc) + 0.065 * POWER(WetWt,RB)/LFrac
                  {if 5 g or less assume invertebrate}
               else LogK2 := -0.536 * LogKOW - Log10(Nondissoc) + 0.116 * POWER(WetWt,RB)/LFrac;
                  {otherwise use fish calculation}            {g}                     {g lipid / g organism, wet weight}

            CalcAnimal_K2 := POWER(10,LogK2);
         End;

(*      (Old estimation procedure below)

        LogK2 := -0.536 * LogKow + (0.116 * (POWER(WetWt,-0.2)/ LFrac));
                                                   {g}          {g lipid / g organism, wet weight}

        CalcAnimal_K2 := POWER(10,LogK2);

        BCF := LFrac * 5 {WetToDry} * KOW * (Nondissoc+0.1);
        If Abs(BCF) < tiny
          then CalcAnimal_K2 := 0
          else CalcAnimal_K2:= (1000 * (POWER(WetWt,-0.2))      * WeffTox)/BCF;
                  {1/d}                       {g} {g lipid/g org} {unitless}  *)
      End;

begin
  If TButton(Sender).Name[1] = 'A' then TypeStr := 'Animal'
                                   else TypeStr := 'Plant';

{  If IS_PFA and (TypeStr='Plant') then
       Begin
         MessageDlg('K2 estimations for Plants are not available for PFAs.',mterror,[mbok],0);
         Exit;
       End;  }

  If ((TypeStr='Animal') and AnimK2Calc.Checked) or
     ((TypeStr='Plant') and PlantCalcK2.Checked) then
       Begin
         MessageDlg('You have selected to calculate K2s based on K1 and BCF for those organisms.',mterror,[mbok],0);
         Exit;
       End;

  If Is_PFA then Begin PFA_K1K2s; Exit; End;

  KPSedConfirm.TypeLabel.Caption := TypeStr;

  KPSedConfirm.LogKOWLabel.Caption:=FloatToStr(RoundDec(3,LogKOW));
  KPSedConfirm.AnimalPanel.Visible := (TypeStr='Animal');
  If KPSedConfirm.ShowModal = mrCancel then Exit;

  KOW    := POWER(10,LogKow);
  if Nondissoc < 0.2 then
    DissocFactor := 0.2         {11/24/03}
  else
    DissocFactor := Nondissoc;

  UpdateButtons := False;

  If TypeStr = 'Animal' then
   {Animals}
    If Table1.RecordCount>0 then
      Begin
        ThisField := Table1.FieldbyName('K2 Elim. rate const (1/d)');
        TFloatField(ThisField).DisplayFormat := '0.####';

        Table1.First;
        With Table1 do
         For Loop:=1 to RecordCount do
          begin
            Edit;
            WetWt:=FieldByName('Ave. wet wt. (g)').AsFloat;
            LFrac:=FieldByName('Lipid Frac').AsFloat;
            ThisK2 := CalcAnimal_K2;
            If (ThisK2 >= 10000) or (ThisK2<0.0001)
              Then TFloatField(ThisField).DisplayFormat := '#.###E+00';
            ThisField.AsFloat:=ThisK2;
            If Loop<RecordCount then next;
          end;
        Table1.Post;
        Table1.First;
      End;


  If TypeStr = 'Plant' then
   BEGIN
    {Plants Calculation}
    Table2.First;
    With Table2 do
     For Loop:=1 to RecordCount do
      begin
        Edit;
        Namestr := LowerCase(FieldByName('Plant name').AsString);
        If Pos('macroph',NameStr)>0 then
           begin
             {Macrophytes}
             K2 := 1/(1.58 + 0.000015 * KOW * (DissocFactor));
             FieldbyName('K2 Elim. rate const (1/d)').AsFloat:=K2;
             If (K2 >= 10000) or (K2<0.0001)
                Then TFloatField(FieldbyName('K2 Elim. rate const (1/d)')).DisplayFormat := '#.###E+00';
           end
        else
           begin
             {Algae}
             If NonDissoc < 0.2 then DissocFactor := 0.2
                                else DissocFactor := NonDissoc;
             BCF := Nondissoc * 2.57 * POWER(KOW,(0.93)) + (1-Nondissoc) * 0.257 * POWER(KOW,(0.93));
             {BCF Eqn. Mirrored from ANIMAL.INC.  Any change here needs to be made there as well}

             {If Pos('peri',NameStr)>0 then BCF := BCF / 10; }
             LFrac:=FieldByName('Lipid Frac').AsFloat;

             If LFrac>Tiny then
               Begin
                 K1 := 1/(1.8e-6 + 1/(KOW * DissocFactor  {(Nondissoc + 0.01)}));      {JSC, Use Algal K1, Feb 22, 2005}
                 {fit to Sijm et al.1998 data for PCBs}
                 {K1 Eqn. Mirrored from TOXPROCS.INC.  Any change here needs to be made there as well}

                 If DissocFactor < 0.8
                    then K2 := K1 / BCF  {for ionized compounds}
                    else K2 := 2.4E+5/(KOW * DissocFactor * LFrac * 5 {WetToDry});

                 FieldbyName('K2 Elim. rate const (1/d)').AsFloat:=K2;
                 If (K2 >= 10000) or (K2<0.0001)
                    Then TFloatField(FieldbyName('K2 Elim. rate const (1/d)')).DisplayFormat := '#.###E+00';
               End;
           end;

        If Loop<RecordCount then next;
      end;
    If Table2.RecordCount>0 then
      Begin
        Table2.Post;
        Table2.First;
      End;
  END; {plant code}

  UpdateButtons := True;
  UpdateScreen;

    Changed := True;
end;

procedure TChemToxForm.CancelBtnClick(Sender: TObject);
begin
  If MessageDlg('Discard all edits to toxicity data?',mtConfirmation,mbOKCancel,0)=mrOK then
    ChemToxForm.ModalResult:=MRCancel;
end;

procedure TChemToxForm.PlantLC50ButtonClick(Sender: TObject);
begin
  EC50LC50dialog.EstimatePlants(Table2);
  If EC50LC50dialog.Changed then Changed := True;
end;

procedure TChemToxForm.AnimalEC50ButtonClick(Sender: TObject);
begin
  EC50LC50dialog.EstimateAnimals(Table1);
  If EC50LC50dialog.Changed then Changed := True;
end;

procedure TChemToxForm.FishRegrButtonClick(Sender: TObject);
begin
  RegrDialog.Regress(Table1,Table2);
  If RegrDialog.Changed then Changed := True;
end;

procedure TChemToxForm.AddAnimalClick(Sender: TObject);
begin
  Table1.Insert;
end;

procedure TChemToxForm.AddPlantClick(Sender: TObject);
begin
  Table2.Insert;
end;

procedure TChemToxForm.dbgridKeyPress(Sender: TObject; var Key: Char);
begin
  If not (Word(Key) in [VK_Return,VK_Tab,VK_Up,VK_Down]) then
    Begin
      Changed := True;
      exit;
    End;
end;

procedure TChemToxForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic40.htm');
end;



procedure TChemToxForm.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
Var Grayed: Boolean;
begin
  If (not IS_PFA) and (not animoptions.visible) then
    Begin
      dbgrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
      exit; {not relevant in library mode}
    End;

  Grayed := False;
  If (AnimalMeth = Default_Meth) then grayed := (DataCol=5) or (DataCol=6);
  If (AnimalMeth = CalcBCF) then grayed := (DataCol=6);
  If (AnimalMeth = CalcK1)  then grayed := (DataCol=5);
  If (AnimalMeth = CalcK2)  then grayed := (DataCol=4);

  If IS_PFA then grayed := DataCol = 6;   // in [5..6];  2-13-2012

  { if the cell is focused, we change its color to a special one }
  if Grayed
    then
      with (Sender as TDBGrid).Canvas do
        begin
          {Column.ReadOnly := True; }
          If (AnimalMeth = Default_Meth) then Brush.Color := clgray
                                         else Brush.Color := clsilver;
          Font.color :=clGray;
          Font.style :=[fsbold];

       end
    else Column.ReadOnly := False;


  { Default Procedure for drawing lines  }
  dbgrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);

end;


(*procedure TChemToxForm.DBGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
 Var gc: TGridCoord;
    text: String;

  procedure ActivateRow(GridObject: TDBGrid;  RowIndex: Integer);
  begin
    GridObject.DataSource.DataSet.First();
    GridObject.DataSource.DataSet.MoveBy(RowIndex);
  end;

	function GetCell(GridObject: TDBGrid; Row, Col: Integer): String;
 	var
 	  Fld : TField;
    FldName: WideString;
	begin
	  FldName := GridObject.Columns.Items[Col].FieldName;
	  ActivateRow(GridObject, Row);
	  Fld := GridObject.DataSource.DataSet.FieldByName(FldName);
	  Result := Fld.AsString;
	end;

begin
  gc := DBGrid1.MouseCoord(x, y) ;
  Text := '';
  If (gc.x>0) and (gc.y>0) then text := GetCell(DBGrid1,GC.Y-1,GC.X-1);
  Label7.Caption := 'X '+IntToSTr(GC.X)+'   Y '+IntToSTr(GC.Y);
  If Length(text) > 12 then
   Begin
     DBGrid1.ShowHint := True;
     DBGrid1.Hint := Text;
   End;

end; *)

procedure TChemToxForm.dbgridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
Var Grayed: Boolean;
begin
  If not animoptions.visible then
    Begin
      dbgrid2.DefaultDrawColumnCell(Rect, DataCol, Column, State);
      exit; {not relevant in library mode}
    End;

  Grayed := False;
  If (PlantMeth = Default_Meth) then grayed := (DataCol=6) or (DataCol=7);
  If (PlantMeth = CalcBCF) then grayed := (DataCol=7);
  If (PlantMeth = CalcK1)  then grayed := (DataCol=6);
  If (PlantMeth = CalcK2)  then grayed := (DataCol=5);

  { if the line is focused, we change his color to a special one }
  if Grayed
    then
      with (Sender as TDBGrid).Canvas do
        begin
          {Column.ReadOnly := True; }
          If (PlantMeth = Default_Meth) then Brush.Color := clgray
                                        else Brush.Color := clsilver;
          Font.color :=clGray;
          Font.style :=[fsbold];

       end
    else Column.ReadOnly := False;


  { Default Procedure for drawing lines  }
  dbgrid2.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;


procedure TChemToxForm.AnimDefaultExit(Sender: TObject);
Var tstr: String;
begin

  If (AnimDefault.Checked and (AnimalMeth <> Default_Meth))
  Or (AnimBCFCalc.Checked and (AnimalMeth <> CalcBCF))
  Or (AnimK1Calc.Checked  and (AnimalMeth <> CalcK1))
  Or (AnimK2Calc.Checked  and (AnimalMeth <> CalcK2)) then
    Begin
      tstr := '';
      If AnimBCFCalc.Checked then tstr := 'BCFs';
      If AnimK1Calc.Checked then tstr := 'K1s';
      If AnimK2Calc.Checked then tstr := 'K2s';
      If tstr <> '' then
        If MessageDlg('By selecting this option, all Animal '+tstr+
          ' will be replaced with calculated values',mtconfirmation,[mbok,mbcancel],0)
          = mrcancel then
              Begin
                UpdateScreen;
                Exit;
              End;
      Changed := True;
    End;

  If UpdateButtons then
    Begin
      If AnimDefault.Checked then AnimalMeth := Default_Meth;
      If AnimBCFCalc.Checked then AnimalMeth := CalcBCF;
      If AnimK1Calc.Checked  then AnimalMeth := CalcK1;
      If AnimK2Calc.Checked  then AnimalMeth := CalcK2;
    End;

  UpdateScreen;
end;


procedure TChemToxForm.AnimPrintButtonClick(Sender: TObject);
begin
  DBGrid2Excel(DBGrid1, Output_Dir + ChemicalName +  '_AnimTox.xls',False)
end;

procedure TChemToxForm.PlantDefaultClick(Sender: TObject);
Var tstr: String;
begin
  If (PlantDefault.Checked and (PlantMeth <> Default_Meth))
  Or (PlantCalcBCF.Checked and (PlantMeth <> CalcBCF))
  Or (PlantCalcK1.Checked  and (PlantMeth <> CalcK1))
  Or (PlantCalcK2.Checked  and (PlantMeth <> CalcK2)) then
    Begin
      tstr := '';
      If PlantCalcBCF.Checked then tstr := 'BCFs';
      If PlantCalcK1.Checked then tstr := 'K1s';
      If PlantCalcK2.Checked then tstr := 'K2s';
      If TSTr <> '' then
        If MessageDlg('By selecting this option, all plant '+tstr+
          ' will be replaced with calculated values',mtconfirmation,[mbok,mbcancel],0)
          = mrcancel then
              Begin
                UpdateScreen;
                Exit;
              End;
      Changed := True;
    End;

  If UpdateButtons then
    Begin
      If PlantDefault.Checked then PlantMeth := Default_Meth;
      If PlantCalcBCF.Checked then PlantMeth := CalcBCF;
      If PlantCalcK1.Checked  then PlantMeth := CalcK1;
      If PlantCalcK2.Checked  then PlantMeth := CalcK2;
    End;

  UpdateScreen;
end;


procedure TChemToxForm.PlantExportButtClick(Sender: TObject);
begin
  DBGrid2Excel(DBGrid2, Output_Dir + ChemicalName +  '_PlantTox.xls',False)
end;

Procedure TChemToxForm.UpdateScreen;
Var Loop, i: Integer;
    K1,K2,BCF: Double;

Begin

  If FirstShow then
    Begin
       For i := 0 to DbGrid1.Columns.Count - 1 do
        if DBGrid1.Columns.Items[i].Width > 180 then DBGrid1.Columns.Items[i].Width := 180;
       For i := 0 to DbGrid2.Columns.Count - 1 do
        if DBGrid2.Columns.Items[i].Width > 180 then DBGrid2.Columns.Items[i].Width := 180;
    End;

  FirstShow := False;

  If not animoptions.visible then exit; {not relevant in library mode}

  If IS_PFA then animoptions.visible := False;
  If IS_PFA then animPFApanel.visible := True;
  If IS_PFA then AnimalElimButton.caption := 'Estimate PFA Animal K2s'
            else AnimalElimButton.caption := 'Estimate Animal K2s using Kow';

  If IS_PFA then PlantElimButton.caption := 'Estimate PFA Animal K1s'
            else PlantElimButton.caption := 'Estimate Plant K2s using Kow';

  UpdateButtons := False;

  If AnimalMeth = Default_Meth then AnimDefault.Checked:= True;
  If AnimalMeth = CalcBCF then AnimBCFCalc.Checked:= True;
  If AnimalMeth = CalcK1 then AnimK1Calc.Checked:= True;
  If AnimalMeth = CalcK2 then AnimK2Calc.Checked:= True;

  If PlantMeth = Default_Meth then PlantDefault.Checked:= True;
  If PlantMeth = CalcBCF then PlantCalcBCF.Checked:= True;
  If PlantMeth = CalcK1 then PlantCalcK1.Checked:= True;
  If PlantMeth = CalcK2 then PlantCalcK2.Checked:= True;

  If AnimalMeth = CalcBCF then
    Begin
      Table1.First;
      With Table1 do
       For Loop:=1 to RecordCount do
        begin
          Edit;
          K2:=Fields[4].AsFloat;
          K1:=Fields[5].AsFloat;
          If K2>0 then BCF:=RoundDec(2,K1/K2)
                  else BCF:=0;
          Fields[6].AsFloat:=BCF;
          If Loop<RecordCount then next;
        end;
      Table1.Post;
      Table1.First;
    End;

  If AnimalMeth = CalcK1 then
    Begin
      Table1.First;
      With Table1 do
       For Loop:=1 to RecordCount do
        begin
          Edit;
          K2:=Fields[4].AsFloat;
          BCF:=Fields[6].AsFloat;
          K1 := RoundDec(3,BCF * K2);
          Fields[5].AsFloat:=K1;
          If Loop<RecordCount then next;
        end;
      Table1.Post;
      Table1.First;
    End;

  If AnimalMeth = CalcK2 then
    Begin
      Table1.First;
      With Table1 do
       For Loop:=1 to RecordCount do
        begin
          Edit;
          K1:=Fields[5].AsFloat;
          BCF:=Fields[6].AsFloat;
          If BCF>0 then K2 := RoundDec(2,K1 / BCF)
                   else K2 := 0;
          Fields[4].AsFloat:=K2;
          If Loop<RecordCount then next;
        end;
      Table1.Post;
      Table1.First;
    End;


  If PlantMeth = CalcBCF then
    Begin
      Table2.First;
      With Table2 do
       For Loop:=1 to RecordCount do
        begin
          Edit;
          K2:=Fields[5].AsFloat;
          K1:=Fields[6].AsFloat;
          If K2>0 then BCF:=RoundDec(2,K1/K2)
                  else BCF:=0;
          Fields[7].AsFloat:=BCF;
          If Loop<RecordCount then next;
        end;
      Table2.Post;
      Table2.First;
    End;

  If PlantMeth = CalcK1 then
    Begin
      Table2.First;
      With Table2 do
       For Loop:=1 to RecordCount do
        begin
          Edit;
          K2:=Fields[5].AsFloat;
          BCF:=Fields[7].AsFloat;
          K1 := RoundDec(3,BCF * K2);
          Fields[6].AsFloat:=K1;
          If Loop<RecordCount then next;
        end;
      Table2.Post;
      Table2.First;
    End;

  If PlantMeth = CalcK2 then
    Begin
      Table2.First;
      With Table2 do
       For Loop:=1 to RecordCount do
        begin
          Edit;
          K1:=Fields[6].AsFloat;
          BCF:=Fields[7].AsFloat;
          If BCF>0 then K2 := RoundDec(2,K1 / BCF)
                   else K2 := 0;
          Fields[5].AsFloat:=K2;
          If Loop<RecordCount then next;
        end;
      Table2.Post;
      Table2.First;
    End;

  DBGrid1.Repaint;
  dbgrid2.Repaint;
  Invalidate;

  UpdateButtons := True;

End;

procedure TChemToxForm.FormCreate(Sender: TObject);
begin
  UpdateButtons := True;

end;

procedure TChemToxForm.Table1AfterPost(DataSet: TDataSet);
begin
  If UpdateButtons then UpdateScreen;
end;

procedure TChemToxForm.Table2AfterPost(DataSet: TDataSet);
begin
  If UpdateButtons then UpdateScreen;
end;


procedure TChemToxForm.FormShow(Sender: TObject);
Begin
  FirstShow := True;
  UpdateScreen;
  FormResize(nil);
end;



end.

