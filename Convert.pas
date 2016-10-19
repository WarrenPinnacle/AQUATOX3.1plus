//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Convert;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AQBaseForm, DBCtrls;

Type
  ConvertType = (CTNone, CTLight, CTFlow, CTVolume, CTHenry, CTLength,
                 CTSurfArea, CTDepth, CTAlkalinity, CTTemp, CTWind, CTPollutant, CTFracPerDay);

Const
  LastConvertType = CTFracPerDay;

  ConvertNames : Array[CTLight..LastConvertType] of String =
                ('Light','Flow','Volume','Henry''s Law','Length',
                 'Surface Area', 'Depth', 'Alkalinity', 'Temperature','Wind Speed','Loading','Fishing');

  MaxConversions = 5;
  ConvertTo : Array[CtLight..LastConvertType] of String =
{CTLight} ('Ly/d',   {implemented & tested in light input, wizard step 12, and site and plant underlying data screens}
{CTFlow}   'cu.m/d', {implemented & tested in volume input, wizard step 9, Site Underlying Data }
{CTVolume} 'cu.m',   {implemented & tested in volume input, wizard step 9, Site Underlying Data }
{CTHenry}  'atm. m3/mol', {implemented & tested in chem underlying data}
{CTLength}  'km',     {implemented & tested in Site Underlying Data, Wizard Step 8 }
{CTSurfArea} 'm2',      {implemented & tested in Edit multi-Seg link screen, Site Underlying Data, Wizard Step 8 }
{CTDepth}    'meters',  {implemented & tested in Edit multi-Seg link screen, Site Underlying Data, Wizard Step 8 }
{CTAlkalinity} 'ueq CaCO3/L', {implemented & tested in pH Entry screen}
{CTTemp}       'deg.C',  {Site Underlying Data, Wizard Step 10, Temperature Entry Screen }
{CTWind}       'm/s',    {Wind speed}
{CTPollutant}  'g/d',    {pollutant loadings, Point source or NPS.}
{CTFracperDay}  'frac/d');    {Fishing Pressure, Frac per day.}


  ConvertFrom : Array[CtLight..LastConvertType, 1..5] of String =
{CTLight}      (('uEin./m2 s','Kwh/m2 d','','',''),
{CTFlow}        ('cu.f/d','L/S','mgd','',''),
{CTVolume}      ('cu.feet','acre feet','Liters','',''),
{CTHenry}       ('Pa m3/mol','dimensionless (conc/conc)','','',''),
{CTLength}      ('miles','','','',''),
{CTSurfArea}    ('acres','sq. feet','sq. miles','hectares',''),
{CTDepth}       ('feet','inches','','',''),
{CTAlkalinity}  ('meq/L','','','',''),
{CTTemp}        ('deg. f','','','',''),
{CTWind}        ('mile/hr','','','',''),
{CTPollutant}   ('lb/day','','','',''),
{CTFracPerDay}  ('frac/year','','','',''));


  Conversions : Array[CtLight..LastConvertType, 1..5] of Double =
{ User input * Conversions = Native AQUATOX Units-- temperature requires addition as well}
{CTLight Ly/d}        ((0.9029{uEinstein/m2 s} ,86{Kwh/m2 d },0{},0{},0{}),
{CTFlow cu.m/d}       (2446.576{cu.fps} ,86.4{L/S}, 3785.412{mgd},0{},0{}),
{CTVolume cu.m}       (0.02831685{cu.feet},1233.5019{acre feet} ,0.001{Liters},0{},0{}),
{CTHenry atm. m3/mol} (9.9e-6{Pa m3/mol}, 0.024{dimensionless},0{},0{},0{}),
{CTLength km}         (1.609344{miles}  ,0{},0{},0{},0{}),
{CTSurfArea m2}       (4046.825{acres}  ,0.09290304{sq. feet},2.59e6{sq. mi},10000{hectares},0{}),
{CTDepth m}           (0.3048{feet}     ,0.0254{inches},0{},0{},0{}),
{CTAlkalinity }       (50{meq/L}          ,0{},0{},0{},0{}),
{CTTemp}              (0.555556{deg f.}  ,0{},0{},0{},0{}),
{CTWind}              (0.44704 {mile/hr} ,0{},0{},0{},0{}),
{CTPollutant}         (453.5924{lb/day}  ,0{},0{},0{},0{}),
{CTFracPerDay}        (1 {Special code required}  ,0{},0{},0{},0{}));


type
  TConvertForm = class(TAQBase)
    EditBox: TEdit;
    SegIDLabel: TLabel;
    OKButton: TButton;
    Button2: TButton;
    AnswerLabel: TLabel;
    UnitsBox: TComboBox;
    procedure EditBoxExit(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    Function GetConversion(TEB: TCustomEdit): Boolean;
  public
    Procedure ConvertNumber(TE:TEdit; CT: ConvertType);     overload;
    Procedure ConvertNumber(TDBE: TDBEdit; CT: ConvertType); overload;

  end;

var
  CType: ConvertType;
  ConvertForm: TConvertForm;
  Answer     : Double;

implementation

{$R *.DFM}

procedure TConvertForm.OKButtonClick(Sender: TObject);
begin
  OKButton.SetFocus;
end;

Function TConvertForm.GetConversion(TEB: TCustomEdit): Boolean;
Var i: integer;
Begin
  ConvertForm.Caption := 'Convert to '+ConvertTo[CType];
  UnitsBox.Items.Clear;
  For i := 1 to MaxConversions do
    Begin
      If ConvertFrom[CType,i] <> '' then
        UnitsBox.Items.Add(ConvertFrom[CType,i]);
    End;
  UnitsBox.ItemIndex := 0;
  EditBox.Text := TEB.Text;
  EditBoxExit(EditBox);

  Top  := TEB.Parent.ClientToScreen(point(TEB.Left,TEB.Top)).Y + 30;
  Left := TEB.Parent.ClientToScreen(point(TEB.Left,TEB.Top)).X - 30;
  If Left + Width > Screen.Width then Left := Left - (Left+Width-Screen.Width);
  If Top + Height > Screen.Height then Top := Top - (Top+Height-Screen.Height);

  GetConversion := (ShowModal = MROK);
End;

procedure TConvertForm.ConvertNumber(TE: TEdit; CT: ConvertType);
Var IsEnab: Boolean;
begin
  CType := CT;
  IF GetConversion(TE) then TE.Text := FloatToStrF(Answer,ffgeneral,9,4);
  IsEnab := TE.Enabled;
  TE.Enabled := True;
  TE.SetFocus;
  TE.Parent.SetFocus;
  TE.Enabled := IsEnab;
end;

procedure TConvertForm.ConvertNumber(TDBE: TDBEdit; CT: ConvertType);
begin
  CType := CT;
  IF GetConversion(TDBE) then
    Begin
      TDBE.DataSource.Edit;
      TDBE.Field.AsFloat := Answer;
      TDBE.Update;
    End;  
end;

procedure TConvertForm.EditBoxExit(Sender: TObject);
Var
Conv: Double;
Result: Integer;

begin
    If Trim(EditBox.Text) = '' then EditBox.Text := '0';
    Val(Trim(EditBox.Text),Conv,Result);
    Conv:=Abs(Conv);
    If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else Answer := Conv * Conversions[CType,UnitsBox.ItemIndex+1];
    If CType = CTTemp then Answer := (Conv-32) * Conversions[CType,UnitsBox.ItemIndex+1];
    If CType = CTFracPerDay then Answer := LN(1-Conv)/-365;

    AnswerLabel.Caption := 'Answer = '+FloatToStrF(Answer,ffgeneral,9,4)+ ' '+ConvertTo[CType];
end; {EditBoxExit}

end.
