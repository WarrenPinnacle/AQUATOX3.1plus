//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Unit GraphSetup;

Interface

Uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Observed_Data,
  Buttons, ExtCtrls, TeeProcs, TeEngine, Chart, Dialogs, Series, AQBaseForm,
  ComCtrls, hh;

Type
  TGraphSetupScreen = class(TAQBase)
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
    Panel4: TPanel;
    Label9: TLabel;
    ListBox1: TListBox;
    ColorDialog1: TColorDialog;
    Label11: TLabel;
    ColorButt: TButton;
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
    DTCB: TCheckBox;
    DXCB: TCheckBox;
    DY1CB: TCheckBox;
    DY2CB: TCheckBox;
    LineThickUpdown: TUpDown;
    Label1: TLabel;
    Label2: TLabel;
    LineThickEdit: TEdit;
    SymbolSizeEdit: TEdit;
    SymbolSizeUpDown: TUpDown;
    SuppressBox: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ColorButtClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure DTCBClick(Sender: TObject);
    procedure DXCBClick(Sender: TObject);
    procedure DY1CBClick(Sender: TObject);
    procedure DY2CBClick(Sender: TObject);
    procedure LineThickEditChange(Sender: TObject);
    procedure SuppressBoxClick(Sender: TObject);
  private
    UpdatingScreen: Boolean;
    Function ListBoxAdjIndex: Integer;
  public
    Linked: Boolean;
    NSegs: integer;
    Procedure EditProp(Var Chart: TChart; Var GSR: TGraphSetup; IsDiff: Boolean);
  end;

Const MaxSeries=400;

var
  WritingYData: Boolean;
  GraphSetupScreen: TGraphSetupScreen;
  SvColors: Array [0..MaxSeries] of TColor;
  ChangedColors: Array [0..MaxSeries] of Boolean;
  SvSymbols: Array [0..MaxSeries] of TSeriesPointerStyle;
  SvLineThick, SvSize, SvIndex: Array [0..MaxSeries] of Word;
  SvY1, SvSuppress: Array [0..MaxSeries] of Boolean;


implementation

Var  TiFont,XAFont,Y1AFont,Y2AFont: TFont;

Procedure TGraphSetupScreen.EditProp(Var Chart: TChart; Var GSR: TGraphSetup; IsDiff: Boolean);
Var ItemIndex, Loop: Integer;
    Seg, YIndex: Integer;
    Y1: Boolean;
Begin
UpdatingScreen := True;
With GSR.Data do
 Begin
  VertGLines.Checked := VertGL;
  Y1Lines.Checked    := Y1GL;
  Y2Lines.Checked    := Y2GL;
  Chart3DBox.Checked := Graph3D;

  If DefaultTitle then T1.Text:= Chart.Title.Text.Strings[0]
                  else T1.Text:= GraphTitle1;
  If DefaultTitle then T2.Text:= Chart.Title.Text.Strings[1]
                  else T2.Text:= GraphTitle2;
  DTCB.Checked := DefaultTitle;
  T1.Enabled := Not DefaultTitle;
  T2.Enabled := Not DefaultTitle;

  If DefaultX then XA.Text:= Chart.BottomAxis.Title.Caption
              else XA.Text:= XLabel;
  DXCB.Checked := DefaultX;
  XA.Enabled := Not DefaultX;

  If DefaultY1 then Y1A.Text:= Chart.LeftAxis.Title.Caption
               else Y1A.Text:= Y1Label;
  DY1CB.Checked := DefaultY1;
  Y1A.Enabled := Not DefaultY1;

  If DefaultY2 then Y2A.Text:= Chart.LeftAxis.Title.Caption
               else Y2A.Text:= Y2Label;
  DY2CB.Checked := DefaultY2;
  Y2A.Enabled := Not DefaultY2;

  TiFont := TFont.Create;
  XAFont := TFont.Create;
  Y1AFont := TFont.Create;
  Y2AFont := TFont.Create;

  TiFont.Assign(GSR.SaveFont1.Font);
  XAFont.Assign(GSR.SaveFont2.Font);
  Y1AFont.Assign(GSR.SaveFont3.Font);
  Y2AFont.Assign(GSR.SaveFont4.Font);
 End;

  ItemIndex := -1;
  Loop := -1;
  ListBox1.Clear;
  For Y1 := True downto False do
    For YIndex := 1 to 20 do
      If GSR.Data.IsShowing[Y1,YIndex] and
         ((Not IsDiff) or (GSR.data.YItems[Y1,YIndex]>-1)) then
        Begin
          Repeat Inc(Loop) Until (Chart.Series[Loop].ShowInLegend) and (Trim(Chart.Series[Loop].Title) <> ''); // minor bug fix 3/12/2012 deal with multiple blank series

          If ItemIndex>MaxSeries-1 then Break;

          If Linked then
            For Seg:= 0 to NSegs-1 do
              Begin
                If (Seg>0) and (GSR.data.YItems[Y1,YIndex]<0) then break;
                Inc(ItemIndex);
                If ItemIndex>MaxSeries then Break;

                If Seg>0 then Inc(Loop);
                If Loop > Chart.SeriesCount-1 then Break;

                ListBox1.Items.Add(Chart.Series[Loop].Title);

                With GSR.LinkedGSR.GSRs[ItemIndex] do
                  Begin
                    SvColors[ItemIndex]:= Color;
                    If Not Suppress then SvColors[ItemIndex]:=TLineSeries(Chart.Series[Loop]).SeriesColor;

                    ChangedColors[ItemIndex] := False;
                    SvSymbols[ItemIndex]:= Shape;
                    SvLineThick[ItemIndex]:= LineThick;
                    SvSize[ItemIndex]:= Size;
                    SvIndex[ItemIndex] := ItemIndex;
                    SvY1[ItemIndex] := Y1;
                    SvSuppress[ItemIndex] := Suppress;
                  End;

              End
          else  //single segiment
            Begin
              Inc(ItemIndex);
              If ItemIndex>MaxSeries then Break;
              ListBox1.Items.Add(Chart.Series[Loop].Title);
              SvColors[ItemIndex]:=TLineSeries(Chart.Series[Loop]).SeriesColor;
              ChangedColors[ItemIndex] := False;
              SvSymbols[ItemIndex]:=TLineSeries(Chart.Series[Loop]).Pointer.Style;
              SvLineThick[ItemIndex]:=TLineSeries(Chart.Series[Loop]).LinePen.Width;
              SvSize[ItemIndex]:=TLineSeries(Chart.Series[Loop]).Pointer.VertSize;
              SvIndex[ItemIndex] := YIndex;
              SvY1[ItemIndex] := Y1;
            End;
        End;

  ListBox1.ItemIndex:=0;
  ListBox1Click(nil);

  UpdatingScreen := False;

  If ShowModal=MRCancel then
      exit;

With GSR.Data do
 Begin
  VertGL := VertGLines.Checked;
  Y1GL := Y1Lines.Checked;
  Y2GL := Y2Lines.Checked;
  Graph3D := Chart3DBox.Checked;

  DefaultTitle := DTCB.Checked;
  If not DefaultTitle then
    Begin
      GraphTitle1 := T1.Text;
      GraphTitle2 := T2.Text;
    End;

  DefaultX := DXCB.Checked;
  DefaultY1 := DY1CB.Checked;
  DefaultY2 := DY2CB.Checked;

  If not DefaultX  then XLabel := XA.Text;
  If not DefaultY1 then Y1Label := Y1A.Text;
  If not DefaultY2 then Y2Label := Y2A.Text;
 End; {with}

    For ItemIndex:=0 to ListBox1.Items.Count-1 do
      Begin
        IF ItemIndex>MaxSeries then Break;
        If Linked then with GSR.LinkedGSR do
          Begin
            If ChangedColors[ItemIndex] then GSRs[SvIndex[ItemIndex]].Color := SvColors[ItemIndex];
            GSRs[SvIndex[ItemIndex]].Shape := SvSymbols[ItemIndex];
            GSRs[SvIndex[ItemIndex]].LineThick := SvLineThick[ItemIndex];
            GSRs[SvIndex[ItemIndex]].Size :=  SvSize[ItemIndex];
            GSRs[SvIndex[ItemIndex]].Suppress :=  SvSuppress[ItemIndex];
          End
        else
          Begin
            If ChangedColors[ItemIndex] then GSR.Data.Colors[SvY1[ItemIndex],SvIndex[ItemIndex]] := SvColors[ItemIndex];
            GSR.Data.Shapes[SvY1[ItemIndex],SvIndex[ItemIndex]] := SvSymbols[ItemIndex];
            GSR.Data.LineThick[SvY1[ItemIndex],SvIndex[ItemIndex]] := SvLineThick[ItemIndex];
            GSR.Data.Size[SvY1[ItemIndex],SvIndex[ItemIndex]] :=  SvSize[ItemIndex];
          End;
      End;

  GSR.SaveFont1.Font.Assign(TiFont);
  GSR.SaveFont2.Font.Assign(XAFont);
  GSR.SaveFont3.Font.Assign(Y1AFont);
  GSR.SaveFont4.Font.Assign(Y2AFont);

End;

{$R *.DFM}

procedure TGraphSetupScreen.Button1Click(Sender: TObject);
begin
  FontDialog1.Font.Assign(TiFont);
  FontDialog1.Execute;
  TiFont.Assign(FontDialog1.Font);
end;

procedure TGraphSetupScreen.Button3Click(Sender: TObject);
begin
  FontDialog1.Font.Assign(xaFont);
  FontDialog1.Execute;
  xaFont.Assign(FontDialog1.Font);
end;

procedure TGraphSetupScreen.Button4Click(Sender: TObject);
begin
  FontDialog1.Font.Assign(y1aFont);
  FontDialog1.Execute;
  y1aFont.Assign(FontDialog1.Font);
end;


procedure TGraphSetupScreen.Button5Click(Sender: TObject);
begin
  FontDialog1.Font.Assign(y2aFont);
  FontDialog1.Execute;
  y2aFont.Assign(FontDialog1.Font);
end;



procedure TGraphSetupScreen.OKBtnClick(Sender: TObject);
begin
  ModalResult:=MROK
end;

procedure TGraphSetupScreen.SuppressBoxClick(Sender: TObject);
begin
  If ListBox1.Items.Count = 0 then exit;
  If UpdatingScreen then Exit;
  SvSuppress[ListBoxAdjIndex]:=SuppressBox.Checked;
end;

Function TGraphSetupScreen.ListBoxAdjIndex: Integer;
Begin
  ListBoxAdjIndex :=ListBox1.ItemIndex;
End;


procedure TGraphSetupScreen.LineThickEditChange(Sender: TObject);
Var
Conv: Double;
Result: Integer;

begin
    If UpdatingScreen then Exit;
    If ListBox1.Items.Count = 0 then exit;
    Val(Trim(TEdit(Sender).Text),Conv,Result);
    Conv:=Abs(Conv);
    If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else   case TEdit(Sender).Name[1] of
                            'L': SvLineThick[ListBoxAdjIndex]:=Trunc(Conv);
                            'S': SvSize[ListBoxAdjIndex]:=Trunc(Conv);
                         end;

end;

procedure TGraphSetupScreen.ListBox1Click(Sender: TObject);
begin
  If ListBox1.Items.Count = 0 then exit;
  Shape1.Brush.Color:=SvColors[ListBoxAdjIndex];
  LineThickEdit.Text := IntToStr(SvLineThick[ListBoxAdjIndex]);
  LineThickUpDown.Position := SvLineThick[ListBoxAdjIndex];
  SymbolSizeEdit.Text := IntToStr(SvSize[ListBoxAdjIndex]);
  SymbolSizeUpDown.Position := SvSize[ListBoxAdjIndex];

  ComboBox1.Itemindex := Ord(SVSymbols[ListBoxAdjIndex]);
  SuppressBox.Visible :=  Linked;
  SuppressBox.Checked := SvSuppress[ListBoxAdjIndex];

end;


procedure TGraphSetupScreen.ComboBox1Change(Sender: TObject);
begin
  If ListBox1.Items.Count = 0 then exit;
  If UpdatingScreen then Exit;
  SvSymbols[ListBoxAdjIndex]:=TSeriesPointerStyle(ComboBox1.ItemIndex);
end;

procedure TGraphSetupScreen.DTCBClick(Sender: TObject);
begin
  T1.Enabled := Not DTCB.Checked;
  T2.Enabled := Not DTCB.Checked;
end;

procedure TGraphSetupScreen.DXCBClick(Sender: TObject);
begin
  Xa.Enabled := Not DXCB.Checked;
end;

procedure TGraphSetupScreen.DY1CBClick(Sender: TObject);
begin
  Y1a.Enabled := Not DY1CB.Checked;
end;

procedure TGraphSetupScreen.DY2CBClick(Sender: TObject);
begin
  Y2a.Enabled := Not DY2CB.Checked;

end;

procedure TGraphSetupScreen.ColorButtClick(Sender: TObject);
begin
  If ListBox1.Items.Count = 0 then exit;
  ColorDialog1.Color:=SVColors[ListBoxAdjIndex];
  ColorDialog1.Execute;
  If  SvColors[ListBoxAdjIndex]<> ColorDialog1.Color then
    Begin
      SvColors[ListBoxAdjIndex] := ColorDialog1.Color;
      ChangedColors[ListBoxAdjIndex] := True;
    End;
  Shape1.Brush.Color:=SvColors[ListBoxAdjIndex];
end;

procedure TGraphSetupScreen.FormCreate(Sender: TObject);
begin
  inherited;
  WritingYData := False;
end;

procedure TGraphSetupScreen.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic71.htm');
end;

end.
