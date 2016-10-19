//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit TSI_Calc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AQBaseForm, DBCtrls, AQUAOBJ, ExtCtrls;

type
  TTSI_Form = class(TAQBase)
    OKButton: TButton;
    Button2: TButton;
    SegmentBox: TComboBox;
    Memo1: TMemo;
    Panel5: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    tolabel: TLabel;
    Label3: TLabel;
    ADateMin: TEdit;
    BDateMax: TEdit;
    Button1: TButton;
    ScenBox: TComboBox;
    ScenLabel: TLabel;
    SegLabel: TLabel;
    Label4: TLabel;
    RepeatPeriodBox: TCheckBox;
    procedure OKButtonClick(Sender: TObject);
    procedure ADateMinExit(Sender: TObject);
    procedure ADateMinKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure ScenBoxChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RepeatPeriodBoxClick(Sender: TObject);
  private
    XMin, XMax : Double;
    Res, ContRes: ResultsType;
    Procedure UpdateCalcs;
  public
    CtrlDate, PertDate: TDateTime;
    StudyName: String;
    Procedure CalculateTSIs(Control, Epi: Boolean; R,CR: ResultsType );
  end;

var
  TSI_Form: TTSI_Form;

implementation

{$R *.DFM}

Uses Global;

procedure TTSI_Form.OKButtonClick(Sender: TObject);
begin
  OKButton.SetFocus;
end;


procedure TTSI_Form.RepeatPeriodBoxClick(Sender: TObject);
begin
  UpdateCalcs;
end;

procedure TTSI_Form.ScenBoxChange(Sender: TObject);
begin
//  XMin := 0;
//  XMax := 0;
  UpdateCalcs;
end;

Procedure TTSI_Form.UpdateCalcs;
Var TR: ResultsType;
    TRC: TResultsCollection;
    TRes: TResults;
    i,j,n: Integer;
    TSI, SD, CHL, TotP, TotN: Double;
    GPP1, CommR, BtoP1, PtoR1 : Double;
    XMin2, XMax2: Double;  // for annual averaging
    Dy, Mo, Yr, Dy2, Mo2, Yr2: Word;
    RunDate: TDateTime;
    LastRunStr: String;

Begin
  If (ContRes[Epilimnion].Count = 0) and (Res[Epilimnion].Count = 0) then exit;

  ScenBox.Enabled := (ContRes[Epilimnion].Count > 0) and (Res[Epilimnion].Count > 0);

  If ScenBox.ItemIndex=0 then TR := ContRes else TR:= Res;
  SegmentBox.Enabled := TR[Hypolimnion].Count > 0;
  If Not SegmentBox.Enabled then SegmentBox.ItemIndex := 0;

  If SegmentBox.ItemIndex = 0 then TRC := TR[Epilimnion]
                              else TRC := TR[Hypolimnion];

  If XMin = 0 then  XMin := TResults(TRC.at(0)).Date;
  If XMax = 0 then  XMax := TResults(TRC.at(TRC.Count-1)).Date;

  ADateMin.Text := DatetoStr(XMin);
  BDateMax.Text := DatetoStr(XMax);

  n := 0;
  TotN := 0;
  TotP := 0;
  SD := 0;
  CHL := 0;

  GPP1  := 0;
  CommR := 0;
  BtoP1 := 0;
  PtoR1 := 0;

  For i := 0 to TRC.Count -1 do
    Begin
      TRes := TRC.at(i);

      XMin2 := XMin;
      Xmax2 := XMax;

      If RepeatPeriodBox.Checked then      // 5/25/2011 Allow for seasonal averaging, JSC
        Begin
          DecodeDate(TRes.Date,Yr,Mo,Dy);
          DecodeDate(XMin2,Yr2,Mo2,Dy2);
          XMin2 := EncodeDate(Yr, Mo2,Dy2);
          DecodeDate(XMax2,Yr2,Mo2,Dy2);
          XMax2 := EncodeDate(Yr, Mo2,Dy2);
        End;

      If (Trunc(TRes.Date) >= Trunc(XMin2)) and
         (Trunc(TRes.Date) <= Trunc(XMax2)) then
          Begin
            inc(n);
            j := TRes.GetIndex(AllVariables(TN),OtherOutput,WaterCol,False,False,False,0,0,TRC);
            TotN := TotN + TDataPoint(TRes.DataPoints.At(j)).State;

            j := TRes.GetIndex(AllVariables(TP),OtherOutput,WaterCol,False,False,False,0,0,TRC);
            TotP := TotP + TDataPoint(TRes.DataPoints.At(j)).State;

            j := TRes.GetIndex(AllVariables(Secchi),OtherOutput,WaterCol,False,False,False,0,0,TRC);
            SD := SD + TDataPoint(TRes.DataPoints.At(j)).State;

            j := TRes.GetIndex(AllVariables(Chla),OtherOutput,WaterCol,False,False,False,0,0,TRC);
            CHL := CHL + TDataPoint(TRes.DataPoints.At(j)).State;

            j := TRes.GetIndex(AllVariables(GPP_Out),OtherOutput,WaterCol,False,False,False,0,0,TRC);
            If j>=0 then GPP1 := GPP1 + TDataPoint(TRes.DataPoints.At(j)).State;

            j := TRes.GetIndex(AllVariables(CommResp_Out),OtherOutput,WaterCol,False,False,False,0,0,TRC);
            If j>=0 then CommR := CommR + TDataPoint(TRes.DataPoints.At(j)).State;

            j := TRes.GetIndex(AllVariables(BtoP_Out),OtherOutput,WaterCol,False,False,False,0,0,TRC);
            If j>=0 then BtoP1 := BtoP1 + TDataPoint(TRes.DataPoints.At(j)).State;

            j := TRes.GetIndex(AllVariables(PtoR_Out),OtherOutput,WaterCol,False,False,False,0,0,TRC);
            If j>=0 then PtoR1 := PtoR1 + TDataPoint(TRes.DataPoints.At(j)).State;

          End;
    End;

   Memo1.Clear;

   if n=0 then Begin Memo1.Lines.Add('Error, No Valid DataPoints Selected'); Exit; End;

   Memo1.Lines.Add('Trophic State Indices');
   Memo1.Lines.Add('');

   Memo1.Lines.Add(StudyName);

   If ScenBox.ItemIndex=0 then RunDate := CtrlDate else RunDate := PertDate;

   If RunDate = -1 then LastRunStr:='No Results Attached'
        else If RunDate = -2 then LastRunStr:='Partial Run Only'
        else begin
               DateTimeToString(LastRunStr,'mm-d-y t',RunDate);
               LastRunStr := 'Run on '+LastRunStr;
             end; {if}

   If ScenBox.ItemIndex=0 then Memo1.Lines.Add('Control Run, '+LastRunStr)
                          else Memo1.Lines.Add('Perturbed Run, '+LastRunStr);
   Memo1.Lines.Add('');

   TotN := TotN / n;
   TotP := TotP / n;
   SD := SD / n;
   CHL := CHL / n;
   GPP1 := GPP1 / n;
   CommR :=  CommR/ n;
   BtoP1 :=  BtoP1/ n;
   PtoR1 := PtoR1 / n;


   TotP := TotP * 1000;
   {ug/L}  {mg/L} {ug/mg}

   TSI := 54.45 + 14.43 * ln(TotN);
   Memo1.Lines.Add('TSI(TN) =  '+FloatToStrF(TSI,ffgeneral,4,4)+ '   based on avg. TN of '+ FloatToStrF(TotN,ffgeneral,4,4)+' mg/L.');

   TSI := 60 - 14.41 * ln(SD);
   Memo1.Lines.Add('TSI(SD) =  '+FloatToStrF(TSI,ffgeneral,4,4)+ '   based on avg. Secchi Depth of '+ FloatToStrF(SD,ffgeneral,4,4)+' m');

   If CHL > tiny then
     Begin
       TSI :=  9.81* ln(CHL) + 30.6;
       Memo1.Lines.Add('TSI(CHL) = '+FloatToStrF(TSI,ffgeneral,4,4)+ '   based on avg. CHLA of '+ FloatToStrF(CHL,ffgeneral,4,4)+' ug/L.');
     End
        Else Memo1.Lines.Add('TSI(CHL) is not calculable as CHLA = 0 ');

   TSI := 14.42 *ln(TotP) + 4.15;
   Memo1.Lines.Add('TSI(TP)  =  '+FloatToStrF(TSI,ffgeneral,4,4)+ '   based on avg. TP of '+ FloatToStrF(TotP,ffgeneral,4,4)+' ug/L.');
   Memo1.Lines.Add('');
   Memo1.Lines.Add('TSI <40 oligotrophic; 40-50 mesotrophic; 50-60 eutrophic; >60 hypereutrophic.');
   Memo1.Lines.Add('');
   Memo1.Lines.Add('Other Ecological Indicators');
   Memo1.Lines.Add('     GPP (Gross Primary Productivity) =  '+FloatToStrF(GPP1,ffgeneral,4,4)+ '  g O2/m2 d');
   Memo1.Lines.Add('     Community Respiration =  '+FloatToStrF(CommR,ffgeneral,4,4)+ '  g O2/m2 d');
   Memo1.Lines.Add('     Turnover (B/P) =  '+FloatToStrF(BtoP1,ffgeneral,4,4)+ '  days');
   Memo1.Lines.Add('     Photo/Resp. (P/R) =  '+FloatToStrF(PtoR1,ffgeneral,4,4)+ '  fraction');
   Memo1.Lines.Add('');

   If RepeatPeriodBox.Checked
     then
       Begin
          DecodeDate(XMin,Yr,Mo,Dy);
          DecodeDate(XMax,Yr2,Mo2,Dy2);
          Memo1.Lines.Add('Averaged from '+ InttoStr(Mo)+'/'+ InttoStr(Dy)+ ' to ' +InttoStr(Mo2)+'/'+ InttoStr(Dy2) + ' of each year (n='+IntToStr(n)+')');
       End
     else Memo1.Lines.Add('Averaged from '+ DatetoStr(XMin)+ ' to ' +DatetoStr(XMax) + ' (n='+IntToStr(n)+')');


   Memo1.Lines.Add('');
   Memo1.Lines.Add('TSIs Calculated using EPA Nutrient Criteria Technical Guidance Manual');
   Memo1.Lines.Add('First Edition, April 2000, EPA-822-B00-001');

{TSI (CHL) = TSI(CHL) = TSI(SD) Algae dominate light attenuation
TSI(CHL) > TSI(SD) Large particulates, such as Aphanizomenon flakes, dominate
TSI(TP) = TSI(SD) > TSI(CHL) Nonalgal particulates or color dominate light attenuation
TSI(SD) = TSI(CHL) > TSI(TP) Phosphorus limits algal biomass (TN/TP ratio greater than 33:1)
TSI(TP) > TSI(CHL) = TSI(SD) Zooplankton grazing, nitrogen, or some factor other than phosphorus limits algal biomass
 }

End;

procedure TTSI_Form.ADateMinExit(Sender: TObject);
Var
  Conv: TDateTime;
begin
    Try
       Conv := StrToDate(TEdit(Sender).Text);
       case TEdit(Sender).Name[1] of
                      'A': XMin:=Conv;
                      'B': XMax:=Conv;
                      end; {case}
    Except
       on EconvertError do MessageDlg('Incorrect Date Format Entered: Must be '+ShortDateFormat,mterror,[mbOK],0)
    End; {try Except}
    UpdateCalcs;
end;

procedure TTSI_Form.ADateMinKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=Chr(13) then ADateMinExit(sender);
end;

procedure TTSI_Form.Button1Click(Sender: TObject);
begin
   XMin := 0;
   XMax := 0;
   UpdateCalcs;
end;

procedure TTSI_Form.Button2Click(Sender: TObject);
begin
  UpdateCalcs;
end;

Procedure TTSI_Form.CalculateTSIs(Control, Epi: Boolean; R,CR: ResultsType );
Begin
  XMin := 0;
  XMax := 0;
  Res  := R;
  ContRes := CR;
  If Control then ScenBox.ItemIndex := 0
             else ScenBox.ItemIndex := 1;
  If Epi then SegmentBox.ItemIndex := 0
         else SegmentBox.ItemIndex := 1;
  UpdateCalcs;
  ShowModal;
End;

end.
