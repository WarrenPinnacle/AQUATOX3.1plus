//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
unit Stat_Calc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, AQStudy,
  StdCtrls, AQBaseForm, DBCtrls, AQUAOBJ, ExtCtrls, Observed_Data, LinkedSegs, Excel2000, ExcelFuncs;

type
  TStatistic_Form = class(TAQBase)
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
    Label5: TLabel;
    Panel1: TPanel;
    MinBox: TCheckBox;
    MaxBox: TCheckBox;
    MeanBox: TCheckBox;
    MedianBox: TCheckBox;
    DigNumber: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    VarianceBox: TCheckBox;
    SDBox: TCheckBox;
    NinetyFifthBox: TCheckBox;
    FifthBox: TCheckBox;
    ExcelExport: TButton;
    Label8: TLabel;
    NameWid: TEdit;
    Label9: TLabel;
    HelpButton: TButton;
    RepeatPeriodBox: TCheckBox;
    AvgPeriodLabel: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure ADateMinExit(Sender: TObject);
    procedure ADateMinKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure ScenBoxChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DigNumberExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MeanBoxClick(Sender: TObject);
    procedure ExcelExportClick(Sender: TObject);
    procedure NameWidChange(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure RepeatPeriodBoxClick(Sender: TObject);
  private
    XMin, XMax : Double;
    Res, ContRes: ResultsType;
    GSR: TGraphSetup;
    TEx: TExcelOutput;
    Procedure UpdateCalcs(ToExcel: Boolean);
  public
    ALL_SEGS: Boolean;
    LinkedS : TLinkedSegs;
    OutputStudy: TAQUATOXSegment;
    OSPtr        : Pointer;
    Digits,NAMEWIDTH : Integer;
    Procedure CalculateStatistics(Control: Boolean; inGSR: TGraphSetup; R,CR: ResultsType);
  end;

var
  Statistic_Form: TStatistic_Form;

implementation

{$R *.DFM}

Uses Global, results, Output, WAIT, HH;

Function FixIntToStr(I: Integer; L: Integer): String;
Var SubStr : String;
    Loop: Integer;
Begin
  SubStr := IntToStr(I);
  For Loop := Length(SubStr) to L do
    SubStr := ' '+SubStr;
  Result := SubStr;  
End;

Function FixFloattoStr(F: Double;L: Integer): String;
Var SubStr : String;
    Loop: Integer;
Begin
  L := L + 1;
  SubStr := FloatToStrF(F,ffGeneral,L-2,3);
  If Pos('.',SubStr)=0 then SubStr := SubStr+'.';
  If Length(SubStr)>=L then SubStr := FloatToStrF(F,ffExponent,L-5,1);
  If Pos('.',SubStr)=0 then SubStr := SubStr+'.';
  If Length(SubStr)>=L then SubStr := FloatToStrF(F,ffExponent,L-6,1);
{  If Length(SubStr)>=L then
    Begin
       Raise EConvertError.Create('Error, FixFloat too Large');
    End; }
  For Loop := Length(SubStr)+1 to L do
    SubStr := ' '+SubStr;
  FixFloatToStr := SubStr;
End;


procedure TStatistic_Form.OKButtonClick(Sender: TObject);
begin
  OKButton.SetFocus;
end;


procedure TStatistic_Form.RepeatPeriodBoxClick(Sender: TObject);
begin
  UpdateCalcs(False);
end;

procedure TStatistic_Form.ScenBoxChange(Sender: TObject);
begin
  UpdateCalcs(False);
end;

Procedure TStatistic_Form.UpdateCalcs(ToExcel: Boolean);
Var i,j: Integer;
    IsY1: Boolean;
    Loop, SegLoop, NumSegs: Integer;
    CtrRes, Found: Boolean;
    ResultID: Integer;
    WorkingSeg            : TAQUATOXSegment;
    Results               : TResultsCollection;
    Seg                   : VerticalSegments;
    NumValues             : Integer;
    L, InnerLoop    : Integer;
    PH                    : TResHeader;
    CurrResults           : TResults;
    VarName               : String;
    Number, Sum_e2        : Double;
    n, ColIndex, RowIndex : Integer;
    mean, median, min, max, sum ,Sum2 : Double;
    Variance, SD, Fifth, NinetyFifth : Double;
    Rank5, Rank95         : Double;
    SortArr               : Array of Double;
    AddStr                : String;
    XMin2, XMax2          : Double;  // for annual averaging
    Dy, Mo, Yr, Dy2, Mo2, Yr2: Word;

            Procedure AddName(Str: String);
            Var i: Integer;
            Begin
               AddStr := AddStr + ', ';
               For i := Length(Str) to Digits do
                 AddStr := AddStr + ' ';
               AddStr := AddStr + Str;

               If ToExcel then
                 Begin
                   TEx.WS.Cells.Item[1,ColIndex].Value := Str;
                   TEx.WS.Cells.Item[1,ColIndex].Font.FontStyle := 'Bold';
                   Inc(ColIndex)
                 End;
            End;

          Procedure AddNum(Num: Double);
          Begin
            AddStr := AddStr + ', '+ FixFloatToStr(Num,Digits);
            If ToExcel then
              Begin
               TEx.WS.Cells.Item[RowIndex,ColIndex].Value2 := Num;
               Inc(ColIndex);
              End;
          End;

          Function LinearInterp(X1,X2,Y1,Y2,XRes:Double): Double;
          Var m: Double;
          Begin
            m:=(y2-y1)/(x2-x1); {slope}
            Result := m*(XRes-x1)+y1;
           End;


Begin
  SortArr := nil;

  If (ContRes[Epilimnion].Count = 0) and (Res[Epilimnion].Count = 0) then exit;
  ScenBox.Enabled := (ContRes[Epilimnion].Count > 0) and (Res[Epilimnion].Count > 0);
  If Not ScenBox.Enabled then
    Begin  If ContRes[Epilimnion].Count > 0 then ScenBox.ItemIndex := 0
                                            else ScenBox.ItemIndex := 1;
    End;

  CtrRes := (ScenBox.ItemIndex=0);

  If CtrRes then SegmentBox.Enabled := ContRes[Hypolimnion].Count > 0
            else SegmentBox.Enabled := Res[Hypolimnion].Count > 0;
  If Not SegmentBox.Enabled then SegmentBox.ItemIndex := 0;
  If SegmentBox.ItemIndex=0 then Seg := Epilimnion
                            else Seg := Hypolimnion;

  If All_Segs then NumSegs := LinkedS.SegmentColl.Count
              else NumSegs := 1;

  Memo1.Clear;
  AddStr := 'Variable Name, ';
  For i := 16 to NameWidth do
     AddStr := AddStr + ' ';
  AddStr := AddStr + '    n';
  If ToExcel then
     Begin
       TEx.WS.Cells.Item[1,1].Value := 'Variable Name';
       TEx.WS.Cells.Item[1,1].Font.FontStyle := 'Bold';
       TEx.WS.Cells.Item[1,2].Value := 'n';
       TEx.WS.Cells.Item[1,2].Font.FontStyle := 'Bold';
       ColIndex := 3;
       WaitDlg.Tease;
     End;

  If MeanBox.Checked then AddName('mean');
  If MedianBox.Checked then AddName('median');
  If MinBox.Checked then AddName('min');
  If MaxBox.Checked then AddName('max');
  If VarianceBox.Checked then AddName('var.');
  If SDBox.Checked then AddName('StDev');
  If FifthBox.Checked then AddName ('5th');
  If NinetyFifthBox.Checked then AddName ('95th');

  Memo1.Lines.Add(AddStr);

  RowIndex := 1;

   For IsY1 := True downto False do
    For Loop := 1 to 20 do
     For SegLoop := 1 to NumSegs do
       If (GSR.data.YItems[IsY1,Loop]<>-99) {and (NumValues>0) }
         then
          Begin
            WorkingSeg := nil;
            Found:=False;
            ResultID := GSR.data.YItems[IsY1,Loop];
            If All_Segs
              then
                Begin
                  WorkingSeg := LinkedS.SegmentColl.At(SegLoop-1);
                  If CtrRes then Results := WorkingSeg.SV.ControlResults[Epilimnion]
                            else Results := WorkingSeg.SV.Results[Epilimnion];
                  If WorkingSeg.SV.Location.SiteType = TribInput then Continue; {Output irrelevant for tributary-input segments}
                End
              else
                If CtrRes then Results := OutputStudy.SV.ControlResults[Seg]
                          else Results := OutputStudy.SV.Results[Seg];

            If XMin = 0 then  XMin := TResults(Results.at(0)).Date;
            If XMax = 0 then  XMax := TResults(Results.at(Results.Count-1)).Date;

            ADateMin.Text := DateToSTr(XMin);
            BDateMax.Text := DateToStr(XMax);

            NumValues := Results.Count;
            If Length(SortArr)< NumValues then SetLength(SortArr,NumValues);

            PH := nil;
            L := 0;
            For InnerLoop:=0 to Results.Headers.Count-1 do
              Begin
                 PH := Results.Headers.At(InnerLoop);
                 If ResultID = PH.SortIndex
                      then begin
                             Found:=true;
                             L := PH.PointIndex;
                             Break;
                           End;
               End; {InnerLoop}

            If Found then
              Begin
                Inc(RowIndex);
                VarName := PH.ListStr(False);
                If All_Segs then VarName :=  WorkingSeg.SegNumber+': '+ VarName;
                J := 0;
                n := 0;
                Sum := 0;
                Sum2 := 0;
                Min := 1e99;
                max := -1e99;


                while J <= NumValues -1 do
                  begin
                    CurrResults:= Results.At(j);

                    XMin2 := XMin;
                    Xmax2 := XMax;

                    If RepeatPeriodBox.Checked then      // 5/25/2011 Allow for seasonal averaging, JSC
                      Begin
                        DecodeDate(CurrResults.Date,Yr,Mo,Dy);
                        DecodeDate(XMin2,Yr2,Mo2,Dy2);
                        XMin2 := EncodeDate(Yr, Mo2,Dy2);
                        DecodeDate(XMax2,Yr2,Mo2,Dy2);
                        XMax2 := EncodeDate(Yr, Mo2,Dy2);
                      End;

                    If ((TRUNC(CurrResults.Date) >= XMin2) and
                        (TRUNC(CurrResults.Date) <= XMax2)) then
                        Begin
                          With GSR do
                            Number:= TDataPoint(CurrResults.DataPoints.At(L)).State;
                            SortArr[n] := number;
                            if Number < Min then Min := Number;
                            If Number > Max then Max := Number;
                            Sum := Sum + number;
                            Sum2 := Sum2 + Sqr(Number);
                            n := n + 1;
                        End;
                    J := J + 1;
                  end;

                if n=0 then Begin Memo1.Lines.Add('Error, No Valid DataPoints Selected'); Exit; End;

                TOutputScreen(OSptr).QuickSort(SortArr,0,n-1);
                If n Mod 2 = 0 then median := (SortArr[n Div 2] + SortArr[(n Div 2)-1]) / 2
                               else median := SortArr[n Div 2];

                Rank5 := (n /20) + 0.5 - 1;  {Formula for rank of 5th percentile in zero indexed array}
                Rank95 := (n*0.95) + 0.5 - 1;

                If (Rank5 <= 1) then
                             Begin
                               Fifth := Min;
                               NinetyFifth := Max;
                             End
                        else Begin
                               Fifth := LinearInterp(Trunc(Rank5),Trunc(Rank5)+1,SortArr[Trunc(Rank5)],SortArr[Trunc(Rank5)+1],Rank5);
                               NinetyFifth := LinearInterp(Trunc(Rank95),Trunc(Rank95)+1,SortArr[Trunc(Rank95)],SortArr[Trunc(Rank95)+1],Rank95);
                             End;

                Variance := 0; SD := 0; Sum_e2 := 0;
                mean := Sum/n;
                If VarianceBox.Checked or SDBox.Checked then
                 if (n>1) then
                  Begin
                    For j := 0 to n-1 do
                      Sum_e2 := Sum_e2 + Sqr(SortArr[j]-Mean);
                    Variance := Sum_e2/(n-1);
                    SD := SQRT(Variance);
                  End;

                VarName := VarName + ',                                                   ';
                SetLength(VarName,NAMEWIDTH);
                AddStr := Varname+ FixIntToStr(n,4);
                If ToExcel then
                  Begin
                    TEx.WS.Cells.Item[RowIndex,1].Value := VarName;
                    TEx.WS.Cells.Item[RowIndex,2].Value2 := n;
                    WaitDlg.Tease;
                    TEx.WS.Cells.Item[RowIndex,1].Font.FontStyle := 'Bold';
                  End;

                ColIndex := 3;

                If MeanBox.Checked then AddNum(Sum/n);
                If MedianBox.Checked then AddNum(median);
                If MinBox.Checked then AddNum(Min);
                If MaxBox.Checked then AddNum(Max);
                If VarianceBox.Checked then AddNum(Variance);
                If SDBox.Checked then AddNum(SD);
                If FifthBox.Checked then AddNum(Fifth);
                If NinetyFifthBox.Checked then AddNum(NinetyFifth);

                Memo1.Lines.Add(AddStr);

              End; {found}

//          If (SegLoop=1) and (Not Found) then AddObservedData(IsY1,Loop);  {segloop avoids multiple graphs for linked window}

         End; {If Items<>-99}{For Loop, SegLoop}{IsY1 Loop}

   If RepeatPeriodBox.Checked
     then
       Begin
          DecodeDate(XMin,Yr,Mo,Dy);
          DecodeDate(XMax,Yr2,Mo2,Dy2);
          AvgPeriodLabel.Caption := 'Averaged from '+ InttoStr(Mo)+'/'+ InttoStr(Dy)+ ' to ' +InttoStr(Mo2)+'/'+ InttoStr(Dy2) + ' of each year (n='+IntToStr(n)+')';
       End
     else AvgPeriodLabel.Caption := 'Averaged from '+ DatetoStr(XMin)+ ' to ' +DatetoStr(XMax) + ' (n='+IntToStr(n)+')';

   SortArr := nil;
End;

procedure TStatistic_Form.ADateMinExit(Sender: TObject);
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
    UpdateCalcs(False);
end;

procedure TStatistic_Form.ADateMinKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=Chr(13) then ADateMinExit(sender);
end;

procedure TStatistic_Form.Button1Click(Sender: TObject);
begin
   XMin := 0;
   XMax := 0;
   UpdateCalcs(False);
end;

procedure TStatistic_Form.Button2Click(Sender: TObject);
begin
  UpdateCalcs(False);
end;

Procedure TStatistic_Form.CalculateStatistics;
Begin
  XMin := InGSR.data.XMin;
  XMax := InGSR.data.XMax;

  Res  := R;
  ContRes := CR;
  GSR    := InGSR;
  If Control then ScenBox.ItemIndex := 0
             else ScenBox.ItemIndex := 1;
  If (GSR.data.VSeg = Epilimnion)
      then SegmentBox.ItemIndex := 0
      else SegmentBox.ItemIndex := 1;
  UpdateCalcs(False);
  ShowModal;
End;

procedure TStatistic_Form.DigNumberExit(Sender: TObject);
Var NewDig: Integer;
begin
  Try
    NewDig := StrToInt(DigNumber.Text);
  Except
    DigNumber.Text := IntToStr(Digits);
    Exit;
  End;

  If (NewDig <= 12) and (NewDig >= 4) then Digits := NewDig;
  DigNumber.Text := IntToStr(Digits);
  UpdateCalcs(False);
end;

procedure TStatistic_Form.NameWidChange(Sender: TObject);
Var NewNW: Integer;
begin
  Try
    NewNW := StrToInt(NameWid.Text);
  Except
    NameWid.Text := IntToStr(NameWidth);
    Exit;
  End;

  If (NewNW <= 50) and (NewNW >= 15) then NameWidth := NewNW;
  NameWid.Text := IntToStr(NameWidth);
  UpdateCalcs(False);

end;

procedure TStatistic_Form.ExcelExportClick(Sender: TObject);
 var
      CurrentColumns : Variant ;   // Sheets to AutoFit
      BaseName: String;

begin
   TEx := TExcelOutput.Create(False);

   try

 //    Delete(BaseName,Length(BaseName)-3,4);

    BaseName := {Output_Dir  +} 'GraphStats.xls';

   // Execute save dialog
    If TEx.GetSaveName(BaseName,'Please Specify an Excel File into which to Save this Table:') then
      begin

       WaitDlg.Setup('Please Wait, Writing Table to Excel File');

       UpdateCalcs(True);

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

procedure TStatistic_Form.FormCreate(Sender: TObject);
begin
  Digits := 6;
  NameWidth := 25;
end;

procedure TStatistic_Form.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('OutputStatistics.htm');  {} 
end;

procedure TStatistic_Form.MeanBoxClick(Sender: TObject);
begin
  UpdateCalcs(False);
end;

end.
