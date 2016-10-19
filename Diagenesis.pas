//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
unit Diagenesis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AQBaseForm, Global, StdCtrls, Grids, hh;

type
  PParameter=^TParameter;
  TParameter = Packed Record
    Val: Double;
    Symbol: UnitString;
    Name : XLRefString;
    Comment: XLRefString;
    Units: UnitString;
  End;

  PDiagenesis_Rec = ^Diagenesis_Rec;
  Diagenesis_Rec = Packed Record
    m1 : TParameter;  // = 0.5;           //(kg/L) solids concentration in layer 1
    m2 : TParameter;  // = 0.5;           //(kg/L) solids concentration in layer 2
    H1 : TParameter;  // = 0.001;         // meters, 1 mm aerobic layer
    Dd : TParameter;  // = 0.001;         //(m^2/d) pore water diffusion coefficient
    w2 : TParameter;  // = 0.0003;        //(m/d) deep burial velocity (Q2K uses 0.000005)
    H2 : TParameter;  // = 0.1;           //(m) thickness of sediment anaerobic layer 2
    KappaNH3f : TParameter;  // = 0.131;  //(m/d) freshwater nitrification velocity
    KappaNH3s : TParameter;  // = 0.131;  //(m/d) saltwater nitrification velocity
    KappaNO3_1f : TParameter;  // = 0.1;  //(m/d) freshwater denitrification velocity
    KappaNO3_1s : TParameter;  // = 0.1;  //(m/d) saltwater denitrification velocity
    KappaNO3_2 : TParameter;  // = 0.25;  //(m/d) denitrification in the anaerobic layer 2
    KappaCH4 : TParameter;  // = 0.7;     //(m/d) methane oxidation in the aerobic sedliment layer 1
    KM_NH3 : TParameter;  // = 0.728;     //(mgN/L) nitrification half-saturation constant for NH4N
    KM_O2_NH3 : TParameter;  // = 0.37;   //(mgO2/L) nitrification half-saturation constant for O2 (DiToro suggests 0.74)
    KdNH3 : TParameter;  // = 1;          //(L/kg) partition coefficient for ammonium in layer 1 and 2
    KdPO42 : TParameter;  // = 20;        //(L/kg) partition coefficient for inorganic P in anaerobic layer 2
    dKDPO41f : TParameter;  // = 20;      //(unitless) freshwater factor that increases the aerobic layer partition coefficient of inorganic P relative to the anaerobic partition coefficient   //gp
    dKDPO41s : TParameter;  // = 20;      //(unitless) saltwater factor that increases the aerobic layer partition coefficient of inorganic P relative to the anaerobic partition coefficient    //gp
    O2critPO4 : TParameter;  // = 2;      //(mgO2/L) critical O2 concentration for adjustment of partition coefficient for inorganic P
    Unused_ThtaDp : TParameter;  // = 1.117;     //for bioturbation particle mixing between layers 1-2
    ThtaDd : TParameter;  // = 1.08;      //for pore water diffusion between layers 1-2
    ThtaNH3 : TParameter;  // = 1.123;    //for nitrification
    ThtaNO3 : TParameter;  // = 1.08;     //for denitrification
    ThtaCH4 : TParameter;  // = 1.079;    //for methane oxidation
    SALTSW : TParameter;  // = 1;         //(ppt) salinity above which sulfide rather than methane is produced from C diagenesis
    SALTND : TParameter;  // = 1;         //(ppt) salinity above which saltwater nitrification/denitrification rates are used for aerobic layer
    KappaH2Sd1 : TParameter;  // = 0.2;   //(m/d) aerobic layer reaction velocity for dissolved sulfide oxidation
    KappaH2Sp1 : TParameter;  // = 0.4;   //(m/d) aerobic layer reaction velocity for particulate sulfide oxidation
    ThtaH2S : TParameter;  // = 1.08;     //(unitless) temperature coefficient for sulfide oxidation
    KMHSO2 : TParameter;  // = 4;         //(mgO2/L) sulfide oxidation normalization constant for O2
    KdH2S1 : TParameter;  // = 100;       //(L/kg) partition coefficient for sulfide in aerobic layer 1
    KdH2S2 : TParameter;  // = 100;       //(L/kg) partition coefficient for sulfide in anaerobic layer 2
    Unused_frpon1 : TParameter;  // = 0.65;      //fraction of class 1 pon
    Unused_frpon2 : TParameter;  // = 0.25;      //fraction of class 2 pon
    Unused_frpoc1 : TParameter;  // = 0.65;      //fraction of class 1 poc
    Unused_frpoc2 : TParameter;  // = 0.2 ;      //fraction of class 2 poc
    Unused_frpop1 : TParameter;  // = 0.65;      //fraction of class 1 pop
    Unused_frpop2 : TParameter;  // = 0.2 ;      //fraction of class 2 pop
    kpon1 : TParameter;  // = 0.035;      //(1/d) G class 1 pon mineralization
    kpon2 : TParameter;  // = 0.0018;     //(1/d) G class 2 pon mineralization
    kpon3 : TParameter;  // = 0;          //(1/d) G class 2 pon mineralization
    kpoc1 : TParameter;  // = 0.035;      //(1/d) G class 1 poc mineralization
    kpoc2 : TParameter;  // = 0.0018;     //(1/d) G class 2 poc mineralization
    kpoc3 : TParameter;  // = 0;          //(1/d) G class 2 poc mineralization
    kpop1 : TParameter;  // = 0.035;      //(1/d) G class 1 pop mineralization
    kpop2 : TParameter;  // = 0.0018;     //(1/d) G class 2 pop mineralization
    kpop3 : TParameter;  // = 0;          //(1/d) G class 2 pop mineralization
    ThtaPON1 : TParameter;  // = 1.1;     //for G class 1 pon
    ThtaPON2 : TParameter;  // = 1.15;    //for G class 2 pon
    ThtaPON3 : TParameter;  // = 1.17;    //for G class 3 pon
    ThtaPOC1 : TParameter;  // = 1.1 ;    //for G class 1 pon
    ThtaPOC2 : TParameter;  // = 1.15;    //for G class 2 pon
    ThtaPOC3 : TParameter;  // = 1.17;    //for G class 3 pon
    ThtaPOP1 : TParameter;  // = 1.1 ;    //for G class 1 pon
    ThtaPOP2 : TParameter;  // = 1.15;    //for G class 2 pon
    ThtaPOP3 : TParameter;  // = 1.17;    //for G class 3 pon
    Unused_POC1R : TParameter;// = 0.1;   //reference G1 at which w12base = Dp / H2 at 20 degC for DiToro eqn 13.1
    kBEN_STR : TParameter;  // = 0.03;    //first-order decay rate constant for benthic stress (1/d) for DiToro eqn 13.3
    Unused_KM_O2_Dp : TParameter;  // = 4;

    {add ons here, Size 13688 to this point}

    ksi : TParameter;   // First order dissolution rate for particulate biogenic silica (PSi) at 20 degC in layer 2 (1/day)
    ThtaSi: TParameter; // Constant for temperature adjustment of KSi (unitless)
    KMPSi : TParameter; // Silica dissolution half-saturation constant for PSi (g Si/m^3)
    SiSat : TParameter; //  Saturation concentration of silica in pore water (g Si/m^3)
    KDSi2 : TParameter; //  Partition coefficient for Si in Layer 2, controls sorption of dissolved silica to solids (L/Kg d)
    DKDSi1 : TParameter; //  factor that enhances sorption of silica in layer 1 when D.O. exceeds DOcSi (unitless)
    O2critSi : TParameter; // Critical dissolved oxygen for silica sorption in layer 1 (mg/L)
    LigninDetr: TParameter; // Fraction of suspended detritus that is non-reactive (frac.)
//    Unused_Dp : TParameter;   = 0.00012;       //(m^2/d) bioturbation particle mixing diffusion coefficient

    Si_Diatom: TParameter; //

    W12,KL12: Double; {global calculations made in state.inc}  {size to here 15792}

  End;

Procedure SetDefaultDiagenesis(Var DR:Diagenesis_Rec; NamesOnly: Boolean);

type
  TDiagenesisForm = class(TAQBase)
    StringGrid1: TStringGrid;
    HelpButton: TButton;
    CancelBtn: TButton;
    OKBtn: TButton;
    CSaveExcel: TButton;
    CopyToAll: TButton;
    Label1: TLabel;
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure StringGrid1Exit(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure CSaveExcelClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure CopyToAllClick(Sender: TObject);
  private
    ValStr  : XLRefString;
    EditRow, EditCol: Integer;
    PAQS: Pointer;
    TempRec: Diagenesis_Rec;
    Procedure UpdateScreen;
  public
    Changed: Boolean;
    Procedure EditDiagenesisParams(Var PS: Pointer); // Var DR: Diagenesis_Rec);
    { Public declarations }
  end;

var
  DiagenesisForm: TDiagenesisForm;

implementation

uses WAIT, ExcelFuncs,Aquaobj, AQStudy;

procedure TDiagenesisForm.StringGrid1Exit(Sender: TObject);
Var R,R2,C,i: Integer;
    V: String;
    Value: Double;
    PParam: PParameter;

begin
  IF EditRow < 0 then exit;
  If (Trim(ValStr) = '~') then exit;
  R := EditRow; C := EditCol; V := ValStr;
  EditRow := -1; EditCol := -1; ValStr := '~';
  Changed := True;

  R2 := 0;
  For i := 1 to R do
    Begin
      Inc(R2);
      PParam := PParameter(Integer(@TempRec) + (R2-1)*Sizeof(TParameter));
      While (PParam^.Symbol= 'unused') do
        Begin
          inc(R2); {bypass 'unused'}
          PParam := PParameter(Integer(@TempRec) + (R2-1)*Sizeof(TParameter));
        End;
    End;

  R := R2;
  PParam := PParameter(Integer(@TempRec) + (R-1)*Sizeof(TParameter));

  If (C=4)
    then PParam.Comment := V
    else Begin
           If Trim(V)='' then Value := 0
                         else Value := StrToFloat(V);
           PParam.Val := Value;
         End;
   UpdateScreen;

end;

procedure TDiagenesisForm.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  CanSelect := (ACol = 1) or (ACol = 4);
  StringGrid1Exit(nil);
end;

procedure TDiagenesisForm.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  ValStr  := Value;
  EditRow := ARow;
  EditCol := ACol;
end;

Procedure TDiagenesisForm.UpdateScreen;
Var NumParms, i, j: Integer;
    PParam: PParameter;

begin
  NumParms := Sizeof(TempRec) div Sizeof(TParameter);
  With StringGrid1 do
    Begin
      For i := 0 to RowCount-1 do
        StringGrid1.Rows[i].Clear;     
      RowCount := NumParms+1 - 9;  {9 'unused'}
      ColCount := 5;
      FixedRows := 1;
      Rows[0].Add('Symbol');
      Rows[0].Add('Value');
      Rows[0].Add('Units');
      Rows[0].Add('Description');
      Rows[0].Add('Comment');

      j := 0;
      For i := 1 to NumParms do
        Begin
          PParam := PParameter(Integer(@TempRec) + (i-1)*Sizeof(TParameter));
          If PParam^.Symbol <> 'unused' then
            Begin
              inc (j);
              Rows[j].Add(PParam^.Symbol);
              Rows[j].Add(FloatToStrF(PParam^.Val,ffgeneral,12,5));
              Rows[j].Add(PParam^.Units);
              Rows[j].Add(PParam^.Name);
              Rows[j].Add(PParam^.Comment);
            End;
         End;
    End;
end;

procedure TDiagenesisForm.CancelBtnClick(Sender: TObject);
begin
  If Changed then If messagedlg('Discard any edits?',mtconfirmation,[mbok,mbcancel],0)
                      = mrcancel then exit;
  ModalResult := MRCancel;
end;


procedure TDiagenesisForm.CopyToAllClick(Sender: TObject);
Var WorkingStudy, AQTStudy : TAQUATOXSegment;
    istempl: Boolean;
    i: Integer;
begin
  AQTStudy := PAQS;
  If Not AQTStudy.SV.LinkedMode then Begin CopyToAll.Enabled := False; Exit; End;

  If MessageDlg('Copy current diagenesis parameters to all segments? (cannot undo)',mtconfirmation,[mbok,mbcancel],0)
    = mrcancel then exit;

  For i := -1 to AQTStudy.AllOtherSegs.Count-1 do
     Begin
       IsTempl := (i=-1);
       If IsTempl then WorkingStudy := AQTStudy.TemplateSeg
                  else WorkingStudy := AQTStudy.AllOtherSegs.At(i);

       WorkingStudy.SV.Diagenesis_Params^ := TempRec;
    End;
end;

procedure TDiagenesisForm.CSaveExcelClick(Sender: TObject);
var
      TEx: TExcelOutput;
      SGrd: TStringGrid;
      intRow,       // index for query rows
      intCol  : Integer ; // index for query columns
      CurrentColumns : Variant ;   // Sheets to AutoFit
      BaseName: String;

begin
   SGrd := StringGrid1;

   TEx := TExcelOutput.Create(False);

   try
       BaseName := {Output_Dir +} 'Diagenesis_Params.xls';

      // Execute save dialog
      If TEx.GetSaveName(BaseName,'Please Specify an Excel File into which to Save this Table:') then
      begin

       WaitDlg.Setup('Please Wait, Writing Table to Excel File');

       // Insert data into sheet
         for intRow := 0 to SGrd.RowCount do
          begin
            WaitDlg.Tease;
            for intCol := 0 to SGrd.ColCount do
            begin
               TEx.WS.Cells.Item[intRow+1,intCol+1].Value := SGrd.Cells[intCol,intRow];
               If (IntRow=0) or (IntCol=0) then
                 begin
                   WaitDlg.Tease;
                   TEx.WS.Cells.Item[intRow+1,intCol+1].Font.FontStyle := 'Bold';
                 end;
            end;
          end;

         CurrentColumns := TEx.WS.Columns;
         CurrentColumns.AutoFit;

         TEx.WS.Cells.Item[2,2].Select;
         TEx.Excel.ActiveWindow.FreezePanes := True;

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

         WaitDlg.Hide;
         // Status user
         MessageDLG('Save Failed: '+E.Message,   mtError,[mbOK],0) ;
      end ;
   end ;
end;

Procedure TDiagenesisForm.EditDiagenesisParams(Var PS: Pointer);

begin
  Changed := False;
  PAQS := PS;
  CopyToAll.Enabled := TAQUATOXSegment(PS).SV.LinkedMode;

  TempRec := TAQUATOXSegment(PS).SV.Diagenesis_Params^;
  EditRow := -1;
  EditCol := -1;
  ValStr := '~';

  With StringGrid1 do
    Begin
      Colwidths[0] := 90;
      Colwidths[1] := 70;
      Colwidths[2] := 70;
      Colwidths[3] := 430;
      Colwidths[4] := 320;
    End;

  UpdateScreen;

  If ShowModal = MROK
    then TAQUATOXSegment(PS).SV.Diagenesis_Params^ := TempRec
    else Changed := False;
end;


procedure TDiagenesisForm.HelpButtonClick(Sender: TObject);
begin
    HTMLHelpContext('Sediment_Diagenesis.htm');
end;

Procedure SetDefaultDiagenesis(Var DR:Diagenesis_Rec; NamesOnly: Boolean);

    Procedure SetUnUsed(Var TP:TParameter);
    Begin
     With TP do
      Begin
        Val := 0;
        Units := '';  name := 'unused';
        Comment := '';
        Symbol := 'unused';
      End;
    End;

Begin

 With DR do
  Begin
    with m1 do
      name := 'Solids concentration in layer 1';
    with m2 do
      name := 'Solids concentration in layer 2';
    with H1 do
      name := 'Thickness of sediment aerobic layer 1';
    with w2 do
      name := 'Deep burial velocity';
    with H2 do
      name := 'Thickness of sediment anaerobic layer 2';
    with KappaNH3f do
      name := 'Freshwater nitrification velocity';
    with KappaNH3s do
      name := 'Saltwater nitrification velocity';
    with KappaNO3_1f do
      name := 'Freshwater denitrification velocity';
    with KappaNO3_1s do
      name := 'Saltwater denitrification velocity';
    with KappaNO3_2 do
      name := 'Denitrification in the anaerobic layer 2';
    with KappaCH4 do
      name := 'Methane oxidation in the aerobic sedliment layer 1';
    with KM_NH3 do
      name := 'Nitrification half-saturation constant for NH4N';
    with KM_O2_NH3 do
      name := 'Nitrification half-saturation constant for O2';
    with KdNH3 do
      name := 'Partition coefficient for ammonium in layer 1 and 2';
    with KdPO42 do
      name := 'Partition coefficient for inorganic P in anaerobic layer 2';
    with dKDPO41f do
      name := 'Freshwater factor, incr. aerobic partition coeff. of inorg. P relative to the anaerobic';
    with dKDPO41s do
      name := 'Saltwater factor, incr. aerobic partition coeff. of inorg. P relative to the anaerobic';
    with O2critPO4 do
      name := 'Critical O2 conc. for adjustment of partition coefficient for inorganic P';
    with ThtaDd do
      name := 'Theta for pore water diffusion between layers 1-2';
    with ThtaNH3 do
      name := 'Theta for nitrification';
    with ThtaNO3 do
      name := 'Theta for denitrification';
    with ThtaCH4 do
      name := 'Theta for methane oxidation';
    with SALTSW do
      name := 'Salinity above which sulfide rather than methane is produced from C diagenesis';
    with SALTND do
      name := 'Salinity above which saltwater nitr./denitrification rates are used for aerobic layer';
    with KappaH2Sd1 do
        name := 'Aerobic layer reaction velocity for dissolved sulfide oxidation';
    with KappaH2Sp1 do
        name := 'Aerobic layer reaction velocity for particulate sulfide oxidation';
    with ThtaH2S do
        name := 'Theta for sulfide oxidation';
    with KMHSO2 do
        name := 'Sulfide oxidation normalization constant for O2';
    with KdH2S1 do
        name := 'Partition coefficient for sulfide in aerobic layer 1';
    with KdH2S2 do
        name := 'Partition coefficient for sulfide in anaerobic layer 2';
    with kpon1 do
        name := 'G class 1 pon mineralization';
    with kpon2 do
        name := 'G class 2 pon mineralization';
    with kpon3 do
      Begin
        name := 'G class 3 pon mineralization';
        Units := '1/d';
      End;
    with kpoc1 do
        name := 'G class 1 poc mineralization';
    with kpoc2 do
        name := 'G class 2 poc mineralization';
    with kpoc3 do
        name := 'G class 2 poc mineralization';
    with kpop1 do
        name := 'G class 1 pop mineralization';
    with kpop2 do
        name := 'G class 2 pop mineralization';
    with kpop3 do
        name := 'G class 2 pop mineralization';
    with ThtaPON1 do
        name := 'Theta for G class 1 PON';
    with ThtaPON2 do
        name := 'Theta for G class 2 PON';
    with ThtaPON3 do
        name := 'Theta for G class 3 PON';
    with ThtaPOC1 do
        name := 'Theta for G class 1 POC';
    with ThtaPOC2 do
        name := 'Theta for G class 2 POC';
    with ThtaPOC3 do
        name := 'Theta for G class 3 POC';
    with ThtaPOP1 do
        name := 'Theta for G class 1 POP';
    with ThtaPOP2 do
        name := 'Theta for G class 2 POP';
    with ThtaPOP3 do
        name := 'Theta for G class 3 POP';
    with kBEN_STR do
        name := 'First-order decay rate constant for benthic stress for DiToro eqn 13.3';
    with Ksi do
        name := 'First order dissolution rate for particulate biogenic silica (PSi) at 20 degC in layer 2';
    with Thtasi do
        name := 'Constant for temperature adjustment of KSi';
    with KMPSi do
        name := 'Silica dissolution half-saturation constant for PSi';
    with SiSat do
        name := 'Saturation concentration of silica in pore water';
    with KDSi2 do
        name := 'Partition coefficient for Si in Layer 2, controls sorption of dissolved silica to solids';
    with DKDSi1 do
        name := 'Factor that enhances sorption of silica in layer 1 when D.O. exceeds DOcSi';
    with O2critSi do
        name := 'Critical dissolved oxygen for silica sorption in layer 1';
    with LigninDetr do
        name := 'Fraction of suspended detritus that is non-reactive';
    with Si_Diatom do
        name := 'Fraction of silica in diatoms (dry)';
  End; {With DR}

 If NamesOnly then Exit;

 With DR do
  Begin
    with m1 do
      Begin
        Val :=  0.5;
        Units := 'kg/L';
        comment := '';
        symbol := 'm1';
      End;
    with m2 do
      Begin
        Val :=  0.5;
        Units := 'kg/L';
        Comment := '';
        Symbol := 'm2';
      End;

    with H1 do
      Begin
        Val :=  0.001;
        Units := 'm';  
        Comment := '1 mm default, may be increased to speed computation time';
        Symbol := 'H1';
      End;

{    SetUnused(Unused_Dp);
{    with Dp do
      Begin
        Val :=  0.00012;
        Units := 'm2/d';  name := 'bioturbation particle mixing diffusion coefficient';
        Comment := '';
        Symbol := 'Dp';
      End;     }
    with Dd do
      Begin
        Val :=  0.001;
        Units := 'm2/d';  
        Comment := '';
        Symbol := 'Dd';
      End;
    with w2 do
      Begin
        Val :=  0.0003;
        Units := 'm/d';  
        Comment :='(Q2K uses 0.000005)';
        Symbol := 'w2';
      End;
    with H2 do
      Begin
        Val :=  0.1;
        Units := 'm';  
        Comment := '';
        Symbol := 'H2';
      End;
    with KappaNH3f do
      Begin
        Val :=  0.131;
        Units := 'm/d';  
        Comment :=  '(Cerco and Cole suggest value of 0.2 m/d for freshwater)';
        Symbol := 'KappaNH3f';
      End;
    with KappaNH3s do
      Begin
        Val :=  0.131;
        Units := 'm/d';  
        Comment := '';
        Symbol := 'KappaNH3s';
      End;
    with KappaNO3_1f do
      Begin
        Val :=  0.1;
        Units := 'm/d';  
        Comment := '(Cerco and Cole suggest value of 0.3 m/d for freshwater)';
        Symbol := 'KappaNO3_1f';
      End;
    with KappaNO3_1s do
      Begin
        Val :=  0.1;
        Units := 'm/d';  
        Comment := '';
        Symbol := 'KappaNO3_1s';
      End;
    with KappaNO3_2 do
      Begin
        Val :=  0.25;
        Units := 'm/d';  
        Comment := '';
        Symbol := 'KappaNO3_2';
      End;
    with KappaCH4 do
      Begin
        Val :=  0.7;
        Units := 'm/d';  
        Comment := '';
        Symbol := 'KappaCH4';
      End;
    with KM_NH3 do
      Begin
        Val :=  0.728;
        Units := 'mgN/L';  
        Comment := '';
        Symbol := 'KM_NH3';
      End;
    with KM_O2_NH3 do
      Begin
        Val :=  0.37;
        Units := 'mgO2/L';  
        Comment := '(DiToro suggests 0.74)';
        Symbol := 'KM_O2_NH3';
      End;
    with KdNH3 do
      Begin
        Val :=  1.0;
        Units := 'L/kg';  
        Comment := '';
        Symbol := 'KdNH3';
      End;
    with KdPO42 do
      Begin
        Val :=  100.0;
        Units := 'L/kg';  
        Comment := '(DiToro 2001 suggests value KdPO42=100 L/Kg)';
        Symbol := 'KdPO42';
      End;
    with dKDPO41f do
      Begin
        Val :=  20.0;
        Units := 'unitless';
        Comment := '(Cerco and Cole 1995 suggest value dKdPO41f=3000)';
        Symbol := 'dKDPO41f';
      End;
    with dKDPO41s do
      Begin
        Val :=  300.0;
        Units := 'unitless';  
        Comment := '(DiToro 2001 suggests value dKdPO41s=300)';
        Symbol := 'dKDPO41s';
      End;
    with O2critPO4 do
      Begin
        Val :=  2.0;
        Units := 'mgO2/L';  
        Comment := '';
        Symbol := 'O2critPO4';
      End;

    SetUnused(Unused_ThtaDp);
{    with ThtaDp do
      Begin
        Val :=  1.117;
        Units := ''; name := 'for bioturbation particle mixing between layers 1-2';
        Comment := '';
        Symbol := 'ThtaDp';
      End; }
    with ThtaDd do
      Begin
        Val :=  1.08;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaDd';
      End;
    with ThtaNH3 do
      Begin
        Val :=  1.123;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaNH3';
      End;
    with ThtaNO3 do
      Begin
        Val :=  1.08;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaNO3';
      End;
    with ThtaCH4 do
      Begin
        Val :=  1.079;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaCH4';
      End;
    with SALTSW do
      Begin
        Val :=  1.0;
        Units := 'ppt';  
        Comment := '';
        Symbol := 'SALTSW';
      End;
    with SALTND do
      Begin
        Val :=  1.0;
        Units := 'ppt';  
        Comment := '';
        Symbol := 'SALTND';
      End;
    with KappaH2Sd1 do
      Begin
        Val :=  0.2;
        Units := 'm/d';  
        Comment := '';
        Symbol := 'KappaH2Sd1';
      End;
    with KappaH2Sp1 do
      Begin
        Val :=  0.4;
        Units := 'm/d';  
        Comment := '';
        Symbol := 'KappaH2Sp1';
      End;
    with ThtaH2S do
      Begin
        Val :=  1.08;
        Units := 'unitless';  
        Comment := '';
        Symbol := 'ThtaH2S';
      End;
    with KMHSO2 do
      Begin
        Val :=  4.0;
        Units := 'mgO2/L';  
        Comment := '';
        Symbol := 'KMHSO2';
      End;
    with KdH2S1 do
      Begin
        Val :=  100.0;
        Units := 'L/kg';  
        Comment := '';
        Symbol := 'KdH2S1';
      End;
    with KdH2S2 do
      Begin
        Val :=  100.0;
        Units := 'L/kg';  
        Comment := '';
        Symbol := 'KdH2S2';
      End;

     SetUnused(Unused_frpon1);
     SetUnused(Unused_frpon2);
     SetUnused(Unused_frpoc1);
     SetUnused(Unused_frpoc2);
     SetUnused(Unused_frpop1);
     SetUnused(Unused_frpop2);

    with kpon1 do
      Begin
        Val :=  0.035;
        Units := '1/d';
        Comment := '';
        Symbol := 'kpon1';
      End;
    with kpon2 do
      Begin
        Val :=  0.0018;
        Units := '1/d';  
        Comment := '';
        Symbol := 'kpon2';
      End;
    with kpon3 do
      Begin
        Val :=  0;
        Units := '1/d';
        Comment := '';
        Symbol := 'kpon3';
      End;
    with kpoc1 do
      Begin
        Val :=  0.035;
        Units := '1/d';  
        Comment := '';
        Symbol := 'kpoc1';
      End;
    with kpoc2 do
      Begin
        Val :=  0.0018;
        Units := '1/d';  
        Comment := '';
        Symbol := 'kpoc2';
      End;
    with kpoc3 do
      Begin
        Val :=  0.0;
        Units := '1/d';  
        Comment := '';
        Symbol := 'kpoc3';
      End;
    with kpop1 do
      Begin
        Val :=  0.035;
        Units := '1/d';  
        Comment := '';
        Symbol := 'kpop1';
      End;
    with kpop2 do
      Begin
        Val :=  0.0018;
        Units := '1/d';  
        Comment := '';
        Symbol := 'kpop2';
      End;
    with kpop3 do
      Begin
        Val :=  0.0;
        Units := '1/d';  
        Comment := '';
        Symbol := 'kpop3';
      End;
    with ThtaPON1 do
      Begin
        Val :=  1.1;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaPON1';
      End;
    with ThtaPON2 do
      Begin
        Val :=  1.15;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaPON2';
      End;
    with ThtaPON3 do
      Begin
        Val :=  1.17;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaPON3';
      End;
    with ThtaPOC1 do
      Begin
        Val :=  1.1 ;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaPOC1';
      End;
    with ThtaPOC2 do
      Begin
        Val :=  1.15;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaPOC2';
      End;
    with ThtaPOC3 do
      Begin
        Val :=  1.17;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaPOC3';
      End;
    with ThtaPOP1 do
      Begin
        Val :=  1.1 ;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaPOP1';
      End;
    with ThtaPOP2 do
      Begin
        Val :=  1.15;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaPOP2';
      End;
    with ThtaPOP3 do
      Begin
        Val :=  1.17;
        Units := ''; 
        Comment := '';
        Symbol := 'ThtaPOP3';
      End;

    SetUnused(Unused_POC1R);
{    with POC1R do
      Begin
        Val :=  0.1;
        Units := 'gC/m3'; name := 'reference G1 at which w12base = Dp/H2 at 20 degC for DiToro eqn 13.1';
        Comment := '';
        Symbol := 'POC1R';
      End; }

    with kBEN_STR do
      Begin
        Val :=  0.03;
        Units := '1/day'; 
        Comment := '';
        Symbol := 'kBEN_STR';
      End;

    SetUnused(Unused_KM_O2_Dp);
 {  with KM_O2_Dp do
      Begin
        Val :=  4.0;
        Units := 'mgO2/L';  name := 'particle mixing half-saturation constant for O2';
        Comment := '';
        Symbol := 'KM_O2_Dp';
      End;  }
    with Ksi do
      Begin
        Val :=  0.5;
        Units := '1/day';  
        Comment := '';
        Symbol := 'Ksi';
      End;
    with Thtasi do
      Begin
        Val :=  1.1;
        Units := 'unitless';  
        Comment := '';
        Symbol := 'Thta_si';
      End;
    with KMPSi do
      Begin
        Val :=  50000;
        Units := 'g Si/m^3';  
        Comment := '';
        Symbol := 'KMPSi';
      End;

    with SiSat do
      Begin
        Val := 40 ;
        Units := 'g Si/m^3';  
        Comment := '';
        Symbol := 'SiSat';
      End;
    with KDSi2 do
      Begin
        Val := 100 ;
        Units := 'L/Kg';  
        Comment := '';
        Symbol := 'KDSi2';
      End;
    with DKDSi1 do
      Begin
        Val :=  10;
        Units := 'unitless';  
        Comment := '';
        Symbol := 'DKDSi1';
      End;
    with O2critSi do
      Begin
        Val :=  1;
        Units := 'mg/L';  
        Comment := '';
        Symbol := 'O2critSi';
      End;

    with LigninDetr do
      Begin
        Val := 0.01;
        Units := 'unitless';  
        Comment := 'default';
        Symbol := 'LigninDetr';
      End;

    with Si_Diatom do
      Begin
        Val := 0.425;
        Units := 'g/g dry';  
        Comment := 'Horne (1994) states that silica makes up 25 to 60% of the dry weight of diatoms.';
        Symbol := 'Si_Diatom';
      End;

{    with  do
      Begin
        Val :=  ;
        Units := '';  name := '';
        Comment := '';
        Symbol := '';
      End; }


  End;
End;

{$R *.dfm}

end.

