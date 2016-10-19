//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Unit Chartprop;

Interface

Uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, hh,
  Buttons, ExtCtrls, TeeProcs, TeEngine, Chart, Dialogs, Series, AQBaseForm,
  ComCtrls;

Type
  TChartProperties = class(TAQBase)
    OKBtn: TButton;
    CancelBtn: TButton;
    FontDialog1: TFontDialog;
    Panel1: TPanel;
    T1: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    t2: TEdit;
    Label6: TLabel;
    xa: TEdit;
    Label7: TLabel;
    y1a: TEdit;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Panel3: TPanel;
    Label1: TLabel;
    MinY: TEdit;
    Label2: TLabel;
    MaxY: TEdit;
    Label8: TLabel;
    AutoScale: TRadioButton;
    RadioButton2: TRadioButton;
    Panel4: TPanel;
    Label9: TLabel;
    ListBox1: TListBox;
    ColorDialog1: TColorDialog;
    Label11: TLabel;
    Button2: TButton;
    Shape1: TShape;
    ComboBox1: TComboBox;
    Label12: TLabel;
    Label13: TLabel;
    y2a: TEdit;
    Button5: TButton;
    Panel2: TPanel;
    Label10: TLabel;
    Chart3DBox: TCheckBox;
    VertGLines: TCheckBox;
    Y1Lines: TCheckBox;
    Y2Lines: TCheckBox;
    HelpButton: TButton;
    Label14: TLabel;
    LineThickEdit: TEdit;
    LineThickUpdown: TUpDown;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure MinYChange(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure LineThickEditChange(Sender: TObject);
  private
    Function ListBoxAdjIndex: Integer;
  public
    Procedure ChangeProp(Var Chart: TChart);
  end;

Const MaxSeries=20;

var
  UpdatingScreen, WritingYData: Boolean;
  BlankSpot: Integer;
  ChartProperties: TChartProperties;
  Colors: Array [0..MaxSeries] of TColor;
  Symbols: Array [0..MaxSeries] of TSeriesPointerStyle;
  Thickness: Array [0..MaxSeries] of Integer;


implementation

Uses TeCanvas;

Var  TiFont,XAFont,Y1AFont,Y2AFont: TFont;

Procedure TChartProperties.ChangeProp(Var Chart: TChart);
Var Loop: Integer;
    SensGraph: Boolean;
Begin
  If Chart.SeriesCount =0 then exit;
  If not Chart.Visible then exit;

  VertGLines.Checked := Chart.BottomAxis.grid.Visible;
  Y1Lines.Checked    := Chart.LeftAxis.grid.Visible;
  Y2Lines.Checked    := Chart.RightAxis.grid.Visible;

  Chart3DBox.Checked := Chart.View3D;
  T1.Text:= Chart.Title.Text.Strings[0];
  T2.Text:= Chart.Title.Text.Strings[1];
  XA.Text:= Chart.BottomAxis.Title.Caption;
  Y1A.Text:= Chart.LeftAxis.Title.Caption;
  Y2A.Text:= Chart.RightAxis.Title.Caption;

  TiFont := Chart.Title.Font;
  XAFont := Chart.BottomAxis.Title.Font;
  Y1AFont := Chart.LeftAxis.Title.Font;
  Y2AFont := Chart.RightAxis.Title.Font;

  SensGraph:= (Chart.Series[1] is THorizBarSeries);

  If (Chart.Name='Chart4') and (not SensGraph)
    then
      Begin
        WritingYData := True;
        AutoScale.Checked:=Chart.LeftAxis.Automatic;
        MinY.Text := Floattostrf(Chart.LeftAxis.Minimum,ffGeneral,6,3);
        MaxY.Text := Floattostrf(Chart.LeftAxis.Maximum,ffGeneral,6,3);
        WritingYData := False;
        Panel3.Visible := True;
        Height := 522;
      End
    else
      Begin
        Panel3.Visible := False;
        Height := 408;
      End;

  BlankSpot := 1000;
  ListBox1.Clear;
  Thickness[0] := 1;
  For Loop:=0 to Chart.SeriesCount-1 do
    Begin
      IF loop>MaxSeries then Break;
      If (Chart.Series[Loop].Title <> '  ') then
        Begin
          ListBox1.Items.Add(Chart.Series[Loop].Title);
          Colors[loop]:=Chart.Series[Loop].SeriesColor;

          If Chart.Series[Loop] is TLineSeries
            then Begin
                   Symbols[loop]   := TLineSeries(Chart.Series[Loop]).Pointer.Style;
                   Thickness[loop] := TLineSeries(Chart.Series[Loop]).Pen.Width;
                 End
            else ComboBox1.Enabled := False;
        End
       else BlankSpot := Loop;
    End;
  ListBox1.ItemIndex:=0;
  UpdatingScreen := True;
  ListBox1Click(nil);
  Invalidate;       //still setting thickness[0] to 1.  3/22/2010
  UpdatingScreen := False;

  If ShowModal=MRCancel then exit;

  Chart.View3D := Chart3DBox.Checked;
  Chart.BottomAxis.grid.Visible := VertGLines.Checked;
  Chart.LeftAxis.grid.Visible   := Y1Lines.Checked;
  Chart.RightAxis.grid.Visible   := Y2Lines.Checked;

  Chart.Title.Text.Clear;
  Chart.Title.Text.Add(T1.Text);
  Chart.Title.Text.Add(T2.Text);
  Chart.BottomAxis.Title.Caption := XA.Text;
  Chart.LeftAxis.Title.Caption   := Y1A.Text;
  Chart.RightAxis.Title.Caption   := Y2A.Text;

  Chart.Title.Font            := TTeeFont(TiFont);
  Chart.BottomAxis.Title.Font := TTeeFont(XAFont);
  Chart.LeftAxis.Title.Font   := TTeeFont(Y1AFont);
  Chart.RightAxis.Title.Font   := TTeeFont(Y2AFont);

  If Chart.Name='Chart4' then
    Begin
      Chart.LeftAxis.Automatic := AutoScale.Checked;
      If (not AutoScale.Checked) then Chart.LeftAxis.Minimum:=StrToFloat(MinY.Text);
      If (not AutoScale.Checked) then Chart.LeftAxis.Maximum:=StrToFloat(MaxY.Text);

      If Chart.LeftAxis.Maximum-Chart.LeftAxis.Minimum < 0.02
             then Chart.LeftAxis.AxisValuesFormat := '0.00E+00'
             else Chart.LeftAxis.AxisValuesFormat := '###0.0##';

    End;


  For Loop:=0 to Chart.SeriesCount-1 do
    Begin
      IF loop>MaxSeries then Break;
      If Loop<>BlankSpot then
        Begin
          Chart.Series[Loop].SeriesColor:=Colors[loop];
          If Chart.Series[Loop] is TLineSeries then
            Begin
              TLineSeries(Chart.Series[Loop]).Pointer.Style:=Symbols[loop];
              TLineSeries(Chart.Series[Loop]).Pen.Width:=Thickness[loop];
            End;
        End;
    End;

End;

{$R *.DFM}

procedure TChartProperties.Button1Click(Sender: TObject);
begin
  FontDialog1.Font:=TiFont;
  FontDialog1.Execute;
  TiFont:=FontDialog1.Font;
end;

procedure TChartProperties.Button3Click(Sender: TObject);
begin
  FontDialog1.Font:=xaFont;
  FontDialog1.Execute;
  xaFont:=FontDialog1.Font;
end;

procedure TChartProperties.Button4Click(Sender: TObject);
begin
  FontDialog1.Font:=y1aFont;
  FontDialog1.Execute;
  y1aFont:=FontDialog1.Font;
end;


procedure TChartProperties.Button5Click(Sender: TObject);
begin
  FontDialog1.Font:=y2aFont;
  FontDialog1.Execute;
  y2aFont:=FontDialog1.Font;
end;



procedure TChartProperties.OKBtnClick(Sender: TObject);
Var TestMin,TestMax: Double;
begin
  If Autoscale.Checked
    then ModalResult:=MROK
    else Begin
           TestMin:=StrToFloat(MinY.Text);
           TestMax:=StrToFloat(MaxY.Text);
           If TestMax<=TestMin then MessageDlg('Min must be less than max',mterror,[mbok],0)
                               else ModalResult:=MROK;
         End;
end;

Function TChartProperties.ListBoxAdjIndex: Integer;
Begin
  ListBoxAdjIndex :=ListBox1.ItemIndex;
  If Result >= BlankSpot then Inc(Result);
End;


procedure TChartProperties.LineThickEditChange(Sender: TObject);
Var
Conv: Double;
Result: Integer;

begin
    If UpdatingScreen or (ListBox1.Items.Count = 0) then exit;
    Val(Trim(TEdit(Sender).Text),Conv,Result);
    Conv:=Abs(Conv);
    If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else   case TEdit(Sender).Name[1] of
                            'L': Thickness[ListBoxAdjIndex]:=Trunc(Conv);
                         end;

end;

procedure TChartProperties.ListBox1Click(Sender: TObject);
begin
  UpdatingScreen := True;
  Shape1.Brush.Color:=Colors[ListBoxAdjIndex];
  ComboBox1.Itemindex := Ord(Symbols[ListBoxAdjIndex]);
  LineThickEdit.Text := IntToStr(Thickness[ListBoxAdjIndex]);
  LineThickUpDown.Position:=Thickness[ListBoxAdjIndex];
  UpdatingScreen := False;

end;


procedure TChartProperties.ComboBox1Change(Sender: TObject);
begin
  Symbols[ListBoxAdjIndex]:=TSeriesPointerStyle(ComboBox1.ItemIndex);
end;

procedure TChartProperties.Button2Click(Sender: TObject);
begin
  ColorDialog1.Color:=Colors[ListBoxAdjIndex];
  ColorDialog1.Execute;
  Colors[ListBoxAdjIndex]:=ColorDialog1.Color;
  Shape1.Brush.Color:=Colors[ListBoxAdjIndex];
end;

procedure TChartProperties.MinYChange(Sender: TObject);
begin
  If Not WritingYData then
   RadioButton2.Checked:=True;
end;


procedure TChartProperties.FormCreate(Sender: TObject);
begin
  inherited;
  WritingYData := False;
  UpdatingScreen := False;
end;

procedure TChartProperties.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic71.htm');
end;

end.
