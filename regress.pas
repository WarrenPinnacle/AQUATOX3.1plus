//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit regress;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Db, DBTables, Dialogs, Global, AQBaseForm, TeeProcs,
  TeEngine, Chart, Series, Math, CalcDist, hh;

Type RegressionRec= Record
        Surrogate: String;
        Predicted: String;
        SampleSize: Integer;
        Intercept : Double;
        Slope     : Double;
        AveX      : Double;
        MSE       : Double;
        SEB       : Double;
        R2        : Double;
        ProbNot0  : String;
        xmin,xmax : Double;
      End;

type
  Tregrdialog = class(TAQBase)
    OKBtn: TButton;
    CancelBtn: TButton;
    Panel1: TPanel;
    Label2: TLabel;
    Label4: TLabel;
    ComboBox1: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    SurrogateBox: TListBox;
    PredictedBox: TListBox;
    Label1: TLabel;
    Panel2: TPanel;
    Label7: TLabel;
    SurrogateLabel: TLabel;
    Label8: TLabel;
    PredictedLabel: TLabel;
    nlabel: TLabel;
    Label10: TLabel;
    alabel: TLabel;
    Label12: TLabel;
    blabel: TLabel;
    Label14: TLabel;
    emslabel: TLabel;
    Label18: TLabel;
    seblabel: TLabel;
    Label20: TLabel;
    corrlabel: TLabel;
    Label22: TLabel;
    prlabel: TLabel;
    Label24: TLabel;
    Chart1: TChart;
    Label3: TLabel;
    LogScale: TCheckBox;
    HelpButton: TButton;
    Panel3: TPanel;
    Label9: TLabel;
    CorrelationWarning: TLabel;
    Label11: TLabel;
    SurrogateLabel2: TLabel;
    Label13: TLabel;
    PredictedLabel2: TLabel;
    Label15: TLabel;
    ComboBox2: TComboBox;
    Label17: TLabel;
    ComboBox3: TComboBox;
    ModelPanel: TPanel;
    Label19: TLabel;
    ExecuteModel: TButton;
    ModelSpec1: TLabel;
    ModelSpec2: TLabel;
    XMaxEdit: TEdit;
    Label23: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label21: TLabel;
    XMinEdit: TEdit;
    Label27: TLabel;
    CIEdit: TEdit;
    Label31: TLabel;
    WebIceButt: TButton;
    Label32: TLabel;
    ConfiLabel: TLabel;
    ShowAllSurrogate: TButton;
    ShowAllPredicted: TButton;
    avglabel: TLabel;
    Label16: TLabel;
    Label28: TLabel;
    XMinMaxLabel: TLabel;
    XRangeWarning: TLabel;
    procedure ComboBox1Change(Sender: TObject);
    procedure SurrogateBoxClick(Sender: TObject);
    procedure SurrogateBoxKeyPress(Sender: TObject; var Key: Char);
    procedure PredictedBoxClick(Sender: TObject);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure LogScaleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ExecuteModelClick(Sender: TObject);
    procedure XMinEditExit(Sender: TObject);
    procedure XMaxEditExit(Sender: TObject);
    procedure XMaxEditKeyPress(Sender: TObject; var Key: Char);
    procedure CIEditExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WebIceButtClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure ShowAllSurrogateClick(Sender: TObject);
    procedure ShowAllPredictedClick(Sender: TObject);
  private
    NumRegr, SurrogateItem, PredictedItem, SelectedRegr : Integer;
    { Private declarations }
  public
     Changed: Boolean;
     FirstVisit: Boolean;
     ShowAll: Boolean;
     SurrogateFirst: Boolean;
     Function Confidence(Adj,X1,X2: Double): Double;
     Procedure UpdateChoices(SRC: Integer);
     Procedure Regress(Var AT,PT: TTable);
     Procedure UpdateRegrInfo;
     Procedure UpdateChart;

    { Public declarations }
  end;

var
  regrdialog: TRegrdialog;
  DBNames: Array [0..30] of String;
  Regressions: Array of RegressionRec;
  AQTToxValues: Array of Double;
  AQTExpTimes:  Array of Double;
  AQTToxComments: Array of String;
  PlantStart  : Integer;
  ModelResult : Double;
  Confi, XMin, XMax  : Double;


implementation

Uses ShellAPI;

{$R *.DFM}


   {---------------------------------------------------------------------------}
    Function HillsInvT(df:Double): Double;
    // Hill's approx. inverse t-dist.: Comm. of A.C.M Vol.13 No.10 1970 pg 620.
    // Calculates t given df and two-tail probability.
    var Conf2, a, b, c, d, t, x, y: Double;

    Begin
        Conf2 := Confi;
        if      (df = 1) then t := sin(Conf2*Pi/2)/cos(Conf2*Pi/2)          //fix 3/16/2010  was inverted
        else if (df = 2) then t := sqrt(2/((1-Conf2)*(2 - (1-Conf2))) - 2)  //fix 3/16/2010  1-Conf2
        else
          Begin
            a := 1/(df - 0.5);
            b := 48/(a*a);
            c := ((20700*a/b - 98)*a - 16)*a + 96.36;
            d := ((94.5/(b + c) - 3)/b + 1)*sqrt(a*Pi*0.5)*df;
            x := d*Conf2;
            y := Power(x, 2/df);
            if (y > 0.05 + a) then
              Begin
                x := ICDFNormal(0.5*(1 - Conf2),0,1);
                y := x*x;
                if (df < 5) then c := c + 0.3*(df - 4.5)*(x + 0.6);
                c := (((0.05*d*x - 5)*x - 7)*x - 2)*x + b + c;
                y := (((((0.4*y + 6.3)*y + 36)*y + 94.5)/c - y - 3)/b + 1)*x;
                y := a*y*y;
                if (y > 0.002) then y := exp(y) - 1
                               else y := 0.5*y*y + y;
                t := sqrt(df*y)
              End
            else
              Begin
                y := ((1/(((df + 6)/(df*y) - 0.089*d - 0.822)*(df + 2)*3)
                    + 0.5/(df + 4))*y - 1)*(df + 1)/(df + 2) + 1/y;
                t := sqrt(df*y)
             End;
         End;
      HillsInvT :=  t;
    End;
 {---------------------------------------------------------------------------}
 Function TRegrDialog.Confidence(Adj,X1,X2: Double): Double;
 Var {avgx} dof, SXX, InvT,Sepred: Double;
 Begin
 With Regressions[SelectedRegr] do
  Begin
    Result := -99;
    If (AveX=-99) or (MSE=-99) or (SEB=-99) then exit;

{    AvgX := (AvePred-Intercept)/Slope; }
    dof  :=SampleSize-2;
    SXX  := MSE/(SQR(SEB));
    InvT := HillsInvT(dof);
    SEPRED := SQRT(MSE*((1/SampleSize)+(SQR(X1-AveX)/SXX)));
    Confidence := X2 + Adj * SEPRED * InvT;
  End;
 End;
 {---------------------------------------------------------------------------}


Procedure TRegrDialog.UpdateChart;
Var  NewSeries             : TLineSeries;
     i,j                   : Integer;
     X1, X2                : Double;
Const NUM_POINTS=300;

Begin
  If SelectedRegr < 0 then Exit;
   With Chart1 do
     Begin
       {Clear the graph}
        While SeriesCount>0 do Series[0].Free;

        For i := 1 to 3 do
          Begin

             {Set the data on the graph}
             NewSeries := TLineSeries.Create(Chart1);
             NewSeries.Pointer.visible:=True;
             NewSeries.Pointer.Style:=psSmallDot;
             NewSeries.Pointer.VertSize := 4;
             NewSeries.Pointer.HorizSize := 4;

             For j := 0 to NUM_POINTS do
               Begin
                 X1 := XMin + (XMax-XMin)*j/NUM_POINTS;
                 With Regressions[SelectedRegr] do
                     X2 := Slope * X1 + Intercept;

                 If i=2 then X2 := Confidence(+1,X1,X2);
                 If i=3 then X2 := Confidence(-1,X1,X2);

                 If X2<>-99 then
                   Begin
                     If not LogScale.Checked then
                       Begin
                         X1 := Power(10,X1);
                         X2 := Power(10,X2);
                       End;

                     If i=1 then NewSeries.AddXY(X1,X2,'',clNavy)
                            else NewSeries.AddXY(X1,X2,'',clMaroon);
                   End;
               End;

             AddSeries(NewSeries);
             If i=1 then
               Begin
                 NewSeries.SeriesColor:=clNavy;
                 NewSeries.LinePen.Width := 3;
                 NewSeries.Title := 'Regression';
               End
             else
               Begin
                 NewSeries.SeriesColor:=clMaroon;
                 NewSeries.LinePen.Width := 2;
                 NewSeries.Title := 'Confi';
               End

          End;

       If not LogScale.Checked
        then
         Begin
          LeftAxis.Title.Caption := 'Acute EC/LC50, Predicted';
          BottomAxis.Title.Caption := 'Acute EC/LC50, Surrogate';
         End
        else
         Begin
          LeftAxis.Title.Caption := 'Log (base 10) Acute EC/LC50, Predicted';
          BottomAxis.Title.Caption := 'Log (base 10) Acute EC/LC50, Surrogate';
         End;
       Refresh;
       Repaint;

     End;

End;


Procedure TRegrDialog.UpdateRegrInfo;
Begin
 If SelectedRegr < 0 then exit;

  With Regressions[SelectedRegr] do
    Begin
      SurrogateLabel.Caption := Surrogate;
      SurrogateLabel2.Caption := Surrogate;

      PredictedLabel.Caption  := Predicted;
      PredictedLabel2.Caption  := Predicted;

      If SampleSize <> -99
        then nLabel.Caption  := IntToStr(SampleSize)
        else nLabel.Caption  := 'Not Available';
      aLabel.Caption  := FloatToStrF(Intercept,ffgeneral,8,8);
      bLabel.Caption  := FloatToStrF(Slope,ffgeneral,8,8);

      If AveX <> -99
        then AvgLabel.Caption  := FloatToStrF(AveX,ffgeneral,8,8)
        else AvgLabel.Caption  := 'Not Available';

      If (XMin <> -99) and (XMax <> -99)
        then XMinMaxLabel.Caption  := FloatToStrF(XMin,ffgeneral,6,4) + ' .. ' + FloatToStrF(XMax,ffgeneral,6,4)
        else XMinMaxLabel.Caption  := 'Not Available';

      If MSE <> -99
        then EMSLabel.Caption  := FloatToStrF(MSE,ffgeneral,8,8)
        else EMSLabel.Caption  := 'Not Available';

      If SEB <> -99
        then SEBLabel.Caption  := FloatToStrF(SEB,ffgeneral,8,8)
        else SEBLabel.Caption  := 'Not Available';

      If R2 <> -99
        then CorrLabel.Caption  := FloatToStrF(R2,ffgeneral,8,8)
        else CorrLabel.Caption  := 'Not Available';

      CorrelationWarning.Visible := (R2<>-99) and (R2<0.6);

      PrLabel.Caption  := ProbNot0;

      XMinEdit.Text := FloatToStrF(XMin,ffgeneral,6,4);
      XMaxEdit.Text := FloatToStrF(XMax,ffgeneral,6,4);
      XMinEditExit(nil);
      XMaxEditExit(nil);

    End;

    UpdateChart;

End;

procedure Tregrdialog.WebIceButtClick(Sender: TObject);
begin
   ShellExecute(self.WindowHandle,'open','http://www.epa.gov/ceampubl/fchain/webice/index.htm',nil,nil, SW_SHOWNORMAL);
end;

Procedure TRegrDialog.Regress(Var AT,PT: TTable);
Var DBDir: String;
    NumDBs: Integer;


          {--------------------------------------------------------}
          procedure ReadFileNames(Filt: String; Ice: Boolean);
          var SearchRec: TSearchRec;
              Desc: String;
          begin
            If FindFirst(DBDir+Filt, faAnyFile, SearchRec) = 0 then
              Repeat
                if SearchRec.Size > 0 then
                  Begin

                    DBNames[NumDbs] := SearchRec.Name;
                    If Ice then Desc := 'ICE ' + SearchRec.Name
                           else Desc := 'AQUATOX Database';
                    If Ice then SetLength(Desc,Length(Desc)-3);
    {               If Filt='*.sn' then Desc := Desc + ' Scientific Names';
                    If Filt='*.cn' then Desc := Desc + ' Common Names'; }

                   ComboBox1.Items.Add(Desc);
                   Inc(NumDbs);
                  End;
              Until FindNext(SearchRec) <> 0;
            FindClose(SearchRec);
          end;


          {--------------------------------------------------------}
          Procedure FindDBNames;
          Begin
            NumDBs :=0;
            DBDir := Default_Dir + 'Interspecies\';
{            ReadFileNames('*.sn',true); }
            ReadFileNames('*.cn',true);
{            ReadFileNames('*.aqn',false); }

            Combobox1.ItemIndex := ComboBox1.Items.Count-1;

          End;
          {--------------------------------------------------------}
          Procedure ReadToxTables;
            {------------------------------------------------------}
            Procedure ReadTable(TB: TTable);
            Var Loop, NumItems: Integer;
            Begin
              TB.First;
              With TB do
                For Loop:=1 to RecordCount do
                  begin
                   ComboBox2.Items.Add(Fields[0].AsString);
                   ComboBox3.Items.Add(Fields[0].AsString);

                   NumItems := ComboBox2.Items.Count;
                   If NumItems>Length(AQTToxValues) then SetLength(AQTToxValues,Length(AQTToxValues)+10);
                   AQTToxValues[NumItems-1] := FieldByName('LC50 (ug/L)').AsFloat;

                   If NumItems>Length(AQTExpTimes) then SetLength(AQTExpTimes,Length(AQTExpTimes)+10);
                   AQTExpTimes[NumItems-1] := FieldByName('LC50 exp. time (h)').AsFloat;

                   If NumItems>Length(AQTToxComments) then SetLength(AQTToxComments,Length(AQTToxComments)+10);
                   AQTToxComments[NumItems-1] := FieldByName('LC50 comment').AsString;

                   Next;
                  end;
              TB.First;
            End;
            {------------------------------------------------------}

          Begin
            ComboBox2.Items.Clear;
            ComboBox3.Items.Clear;
            AQTExpTimes := nil;
            AQTToxValues := nil;
            AQTToxComments := nil;

            SetLength(AQTToxValues,20);
            SetLength(AQTExpTimes,20);
            SetLength(AQTToxComments,20);

            ReadTable(AT);
            ReadTable(PT);
          End;
          {--------------------------------------------------------}
          Procedure WriteToxTables;
          Var ItemCount: Integer;
            {------------------------------------------------------}
            Procedure WriteTable(TB: TTable);
            Var Loop: Integer;
            Begin
              TB.First;
              With TB do
                For Loop:=1 to RecordCount do
                  Begin
                    TB.Edit;
                    FieldByName('LC50 (ug/L)').AsFloat := AQTToxValues[ItemCount];
                    FieldByName('LC50 exp. time (h)').AsFloat := AQTExpTimes[ItemCount];
                    FieldByName('LC50 comment').AsString := AQTToxComments[ItemCount];
                    TB.Next;
                    Inc(ItemCount);
                  End;
              TB.First;
            End;
            {------------------------------------------------------}

          Begin
            ItemCount := 0;

            WriteTable(AT);
            WriteTable(PT);
          End;
          {--------------------------------------------------------}


Begin
  XMin := -2; XMax := 6; Confi := 0.95;

  If FirstVisit then
    Begin
      ComboBox1.Items.Clear;
      FindDBNames;
      ComboBox1Change(nil);
    End;

  ReadToxTables;

  Changed := False;
  ModelPanel.Visible := False;
  ComboBox2.Text :='';
  ComboBox3.Text :='';
  UpdateChart;

  If (ShowModal=MROK) and Changed
     then WriteToxTables;
End;

procedure TRegrdialog.ComboBox1Change(Sender: TObject);
Var InStr, DBName: String;
    DBFile: TextFile;
    Col: Integer;

    Function ReadStr: String;
    Var Str: String; Ch: Char;
    Begin
      Str := '';

      Repeat
        Ch := InStr[Col];
        If (Ch<>',')
          Then Str := Str+Ch;
        Inc(Col);

      Until (Ch=',') or (Col>Length(InStr));

      ReadStr := Str;
    End;

    Function ReadFloat: Double;
    Var Str: String;
    Begin
      Str := ReadStr;
      If Str='' then ReadFLoat := -99
                else ReadFloat := StrToFloat(Str);
    End;

begin
  DBName := Default_Dir + 'Interspecies\'+DBNames[ComboBox1.ItemIndex];
  AssignFile(DBFile,DBName);
  Reset(DBFile);
  Regressions := nil;
  SetLength(Regressions,10);

  NumRegr :=0;
  While not EOF(DBFile) do
     Begin
       Readln(DBFile,InStr);
       Col := 1;
       Inc(NumRegr);
       If NumRegr>length(Regressions) then SetLength(Regressions,Length(Regressions)+10);
       With Regressions[NumRegr-1] do
       Try
         Surrogate  := ReadStr;
         Predicted  := ReadStr;
         SampleSize := Trunc(ReadFloat);
         Intercept  := ReadFloat;
         Slope      := ReadFloat;
         AveX    := ReadFloat;
         MSE        := ReadFloat;
         SEB        := ReadFloat;
         R2         := ReadFloat;
         ProbNot0   := ReadStr;
         {Junk       := } ReadFloat; //r
         {Junk       := } ReadFloat; //df
         XMin       := ReadFloat;
         XMax       := ReadFloat;

       Except
           CloseFile(DBFile);
           Raise EAQUATOXError.create(Exception(ExceptObject).Message);
       End; {try}
     End;

  CloseFile(DBFile);

  ShowAll := True;
  UpdateChoices(0);

  {}
end;


Procedure TRegrDialog.UpdateChoices(SRC: Integer);  {SRC 0: generic, 1, Surrogate Butt, 2, Pred Butt}
Var LastAdd: String;
    Indx,Loop: Integer;
    SurrogateStr: String;
    PredictedStr: String;
    Found: Boolean;
    TSL: TStringList;

Begin

  If ShowAll then
    Begin
      SurrogateBox.Clear;
      If NumRegr=0 then exit;
      LastAdd :=Regressions[0].Surrogate;
      SurrogateBox.Items.Add(LastAdd);

      For loop := 2 to NumRegr do
        Begin
          If Regressions[Loop-1].Surrogate <> LastAdd then
            Begin
              LastAdd :=Regressions[Loop-1].Surrogate;
              SurrogateBox.Items.Add(LastAdd);
            End;
        End;

      SurrogateBox.ItemIndex := 0;
      SurrogateItem := -1;

      PredictedBox.Clear;
      If NumRegr=0 then exit;

      TSL := TStringList.Create;
      TSL.Sorted := True;
      For loop := 1 to NumRegr do
        If not TSL.Find(Regressions[Loop-1].Predicted,indx) then
          Begin
            PredictedBox.Items.Add(Regressions[Loop-1].Predicted);
            TSL.Add(Regressions[Loop-1].Predicted);
          End;
      TSL.Free;

      PredictedBox.ItemIndex := 0;
      PredictedItem := -1;

    End; {ShowAll}

  If Not ShowAll and SurrogateFirst and (SRC <> 2) then
    Begin {Update items in predicted box given surrogate click}
      If SurrogateBox.ItemIndex <> SurrogateItem then
        Begin
          PredictedBox.Clear;
          SurrogateItem := SurrogateBox.ItemIndex;
          SurrogateStr  := SurrogateBox.Items[SurrogateItem];
          For Loop := 0 to (NumRegr-1) do
            If Regressions[Loop].Surrogate = SurrogateStr then
              PredictedBox.Items.Add(Regressions[Loop].Predicted);
          PredictedBox.ItemIndex := 0;
          PredictedItem := -1;
        End;
    End;

  If not ShowAll and not SurrogateFirst and (SRC <> 1) then
    Begin  {Update items in surrogate box given predicted click}
      If PredictedBox.ItemIndex <> PredictedItem then
       Begin
          SurrogateBox.Clear;
          PredictedItem := PredictedBox.ItemIndex;
          PredictedStr  := PredictedBox.Items[PredictedItem];
          For Loop := 0 to (NumRegr-1) do
           If Regressions[Loop].Predicted = PredictedStr then
              SurrogateBox.Items.Add(Regressions[Loop].Surrogate);
          SurrogateBox.ItemIndex := 0;
          SurrogateItem := -1;
       End;
    End;


    If (SurrogateBox.ItemIndex <> SurrogateItem) or
       (PredictedBox.ItemIndex <> PredictedItem) then
       If (SurrogateBox.ItemIndex > -1) and (PredictedBox.ItemIndex > -1) then
        Begin
          SurrogateItem := SurrogateBox.ItemIndex;
          SurrogateStr  := SurrogateBox.Items[SurrogateItem];
          PredictedItem := PredictedBox.ItemIndex;
          PredictedStr  := PredictedBox.Items[PredictedItem];
          Loop := 0;
          Repeat
            Found := False;
              If (Regressions[Loop].Surrogate = SurrogateStr) and
                 (Regressions[Loop].Predicted = PredictedStr)
                  then
                    Begin
                      Found := True;
                      SelectedRegr := Loop;
                    End;
            Inc(Loop);
          Until (Found) or (Loop=NumRegr);
          If Not Found then SelectedRegr := -1;
        End;

  UpdateRegrInfo;
  ComboBox2Change(nil);

End;

procedure Tregrdialog.ShowAllPredictedClick(Sender: TObject);
begin
  ShowAll := True;
  UpdateChoices(0);

end;

procedure Tregrdialog.ShowAllSurrogateClick(Sender: TObject);
begin
  ShowAll := True;
  UpdateChoices(0);
end;

procedure TRegrdialog.SurrogateBoxClick(Sender: TObject);
begin
  If ShowAll then Begin
                    SurrogateFirst := True;
                    ShowAll := False;
                  End;

  UpdateChoices(1);
end;

procedure Tregrdialog.SurrogateBoxKeyPress(Sender: TObject; var Key: Char);
begin
  SurrogateBoxClick(nil);
end;

procedure Tregrdialog.PredictedBoxClick(Sender: TObject);
begin
  If ShowAll then Begin
                    SurrogateFirst := False;
                    ShowAll := False;
                  End;

  UpdateChoices(2);

end;



procedure Tregrdialog.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var xval, yval: Double;
    Str: String;
begin
   If Series.Title<>'Regression' then exit;

   Xval := Series.XValue[valueindex];
   Yval := Series.YValue[valueindex];
   If Not LogScale.Checked then XVal := Log10(XVal);
   If Not LogScale.Checked then Yval := Log10(Yval);

   With Regressions[SelectedRegr] do
   Str := Surrogate+' LC50: '+Floattostrf(Power(10,XVal),ffGeneral,4,3)+ ';  Predicted '+Predicted+' LC50: ' +
      Floattostrf(Power(10,YVal),ffGeneral,4,3)+'.  ';
   If Confidence(-1,Xval,YVal) <> -99 then Str := Str + CIEdit.Text+' confidence interval is ['+
      Floattostrf(Power(10,Confidence(-1,Xval,YVal)),ffGeneral,4,3) + ',' +
      Floattostrf(Power(10,Confidence(+1,Xval,YVal)),ffGeneral,4,3)+']';

      ShowMessage(Str);
end;

procedure Tregrdialog.LogScaleClick(Sender: TObject);
begin
  UpdateChart;
end;

procedure Tregrdialog.FormShow(Sender: TObject);
begin
{  Width := Screen.Width;
  Height := Screen.Height-50; }
  FirstVisit := False;

end;

procedure Tregrdialog.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Using_Ice.htm');
end;

procedure Tregrdialog.CancelBtnClick(Sender: TObject);
begin
  If Changed then
    if MessageDlg('This will cancel any executed models.  Do you wish to cancel?',
                   mtconfirmation,[mbyes,mbno],0) = mrno then exit;

  ModalResult:=MRCancel;
end;

procedure Tregrdialog.ComboBox2Change(Sender: TObject);
Var ModelInput: Double;
begin

  XRangeWarning.Visible := False;
  ModelPanel.Visible := False;
  If (ComboBox2.ItemIndex > -1) and
     (ComboBox3.ItemIndex > -1) and
     (SelectedRegr > -1) then
       Begin
         ModelPanel.Visible := True;
         ModelInput := AQTToxValues[ComboBox2.ItemIndex];
         ModelSpec1.Caption := 'Based on '+ComboBox2.Text+' with LC50 of '+
           FloatToStrF(ModelInput,ffgeneral,6,6) + ' ug/L  (exp. time = ' +
           FloatToStrF(AQTExpTimes[ComboBox2.ItemIndex],ffgeneral,3,3) + ' hours)';

         If ((Log10(ModelInput)<XMin) or (Log10(ModelInput)>XMax)) then
           XRangeWarning.Visible := True;

         With Regressions[SelectedRegr] do
           ModelResult := POWER(10,(Log10(ModelInput)*Slope + Intercept));

         ModelSpec2.Caption := ComboBox3.Text+' LC50 will be set to '+
           FloatToStrF(ModelResult,ffgeneral,6,6) + ' ug/L  (exp. time = ' +
           FloatToStrF(AQTExpTimes[ComboBox2.ItemIndex],ffgeneral,3,3) + ' hours)';

         If Confidence(-1,Log10(ModelInput),Log10(ModelResult)) <> -99
           then ConfiLabel.Caption := CIEdit.Text+' confidence interval is ['+
            Floattostrf(Power(10,Confidence(-1,Log10(ModelInput),Log10(ModelResult))),ffGeneral,4,3) + ',' +
            Floattostrf(Power(10,Confidence(+1,Log10(ModelInput),Log10(ModelResult))),ffGeneral,4,3)+']'
           else ConfiLabel.Caption := ''

       End;

end;


procedure Tregrdialog.ExecuteModelClick(Sender: TObject);
begin
  AQTToxValues [ComboBox3.ItemIndex] := ModelResult;
  AQTExpTimes  [ComboBox3.ItemIndex] := AQTExpTimes[ComboBox2.ItemIndex];

  AQTToxComments[ComboBox3.ItemIndex] := 'ICE Regr. on '+ComboBox2.Text+ '. n=' + nLabel.Caption +
        '; r2 ='+CorrLabel.Caption +' Surrogate = '+SurrogateBox.Items.Strings[SurrogateBox.ItemIndex]+';'
        + ' MSE= '+EMSLabel.Caption+'; '+ConfiLabel.Caption;

  Changed := True;
  MessageDlg(ComboBox3.Text+' LC50 has been set to '+
              FloatToStrF(ModelResult,ffgeneral,6,6) + ' ug/L',
              mtInformation,[mbok],0);

end;

procedure Tregrdialog.XMinEditExit(Sender: TObject);
Var Conv: Double;
    Res: Integer;

begin
    Val(Trim(XMinEdit.Text),Conv,Res);
    If Res<>0 then MessageDlg('Incorrect Numerical Format Entered for XMin',mterror,[mbOK],0)
      Else If (XMax<=Conv) and (Sender<>nil)
        Then MessageDlg('XMin must be less than XMax',mterror,[mbOK],0)
        Else XMin := Conv;

    XMinEdit.Text := FloatToStrF(XMin,ffgeneral,3,3);
    If (Sender<> nil) then UpdateChart;

 {}
end;

procedure Tregrdialog.XMaxEditExit(Sender: TObject);
Var Conv: Double;
    Res: Integer;

begin
    Val(Trim(XMaxEdit.Text),Conv,Res);
    If Res<>0
      Then MessageDlg('Incorrect Numerical Format Entered for XMax',mterror,[mbOK],0)
      Else If (Conv<=XMin) and (Sender<>nil)
        Then MessageDlg('XMax must Exceed XMin',mterror,[mbOK],0)
        Else XMax := Conv;

    XMaxEdit.Text := FloatToStrF(XMax,ffgeneral,3,3);
    If (Sender<>nil) then UpdateChart;
end;

procedure Tregrdialog.XMaxEditKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#13 then Chart1.SetFocus;
end;

procedure Tregrdialog.CIEditExit(Sender: TObject);
Var Conv: Double;
    Res: Integer;

begin
    Val(Trim(TEdit(Sender).Text),Conv,Res);
    If Res<>0
      Then MessageDlg('Incorrect Numerical Format Entered for Confidence Interval',mterror,[mbOK],0)
      Else If (Conv<=0.5) or (Conv>=1.0)
        Then MessageDlg('Confidence Interval must be Less than 1 and Greater than 0.5',mterror,[mbOK],0)
        Else Confi := Conv;

    CIEdit.Text := FloatToStrF(Confi,ffgeneral,3,3);
    UpdateChart;
end;

procedure Tregrdialog.FormCreate(Sender: TObject);
begin
  ShowAll := True;
  FirstVisit := True;
end;

end.
