//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit PrintP;     {1.1}

interface
uses
  SysUtils, WinTypes, WinProcs, Classes, Graphics, Controls,
  Forms, Grids, Printers, StdCtrls, ExtCtrls, Mask, DBLookup
  ,Chart2FX, ChartFx;

const DesignPixelsPerInch : integer = 96; {New Golbal Constant, change as needed}

function PrintPage(APage : TScrollingWinControl; ATag : Longint): integer;


implementation
var ScaleX, ScaleY, Co, Count : integer;
    PDC : HDC;
    SW : TScrollingWinControl;

  function ScaleToPrinter(R:TRect):TRect;
  begin
    R.Top := (R.Top + SW.VertScrollBar.Position) * ScaleY;
    R.Left := (R.Left + SW.HorzScrollBar.Position) * ScaleX;
    R.Bottom := (R.Bottom + SW.VertScrollBar.Position) * ScaleY;
    R.Right := (R.Right + SW.HorzScrollBar.Position) * ScaleX;
    Result := R;
  end;

procedure PrintLabel(La: TLabel);
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
var C : array[0..255] of char;
    CLen : integer;
    Format : Word;
    R: TRect;
begin
  Printer.Canvas.Font := La.Font;
  PDC := Printer.Canvas.Handle; {so DrawText knows about font}
  R := ScaleToPrinter(La.BoundsRect);
  R.Right := R.Right + ScaleX;
  Format := DT_EXPANDTABS or DT_WORDBREAK or Alignments[La.Alignment];
  CLen := La.GetTextBuf(C,255);
  WinProcs.DrawText(PDC, C, CLen, R, Format);
  inc(Count);
end;

procedure PrintMemo(Memo: TMemo);
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
var C : array[0..255] of char;
    CLen : integer;
    Format : Word;
    R: TRect;
begin
  Printer.Canvas.Font := Memo.Font;
  PDC := Printer.Canvas.Handle; {so DrawText knows about font}
  R := ScaleToPrinter(Memo.BoundsRect);
  if Memo.BorderStyle = bsSingle then
    begin
      Printer.Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
      R.Left := R.Left + ScaleX + ScaleX;
      R.Right := R.Right - ScaleX - ScaleX;
    end;
  R.Bottom := R.Bottom + Printer.Canvas.Font.Height;
  Format := DT_EXPANDTABS;
  if Memo.WordWrap then Format := Format or DT_WORDBREAK;
  Format := Format or Alignments[Memo.Alignment];
  CLen := Memo.GetTextBuf(C,255);
  WinProcs.DrawText(PDC, C, CLen, R, Format);
  inc(Count);
end;

procedure PrintEdit(Ed: TEdit);
var C : array[0..255] of char;
    CLen : integer;
    Format : Word;
    R: TRect;
begin
  Printer.Canvas.Font := Ed.Font;
  PDC := Printer.Canvas.Handle; {so DrawText knows about font}
  R := ScaleToPrinter(Ed.BoundsRect);
  if Ed.BorderStyle = bsSingle then
    Printer.Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
  R.Left := R.Left + ScaleX + ScaleX;
  Format := DT_SINGLELINE or DT_VCENTER;
  CLen := Ed.GetTextBuf(C,255);
  WinProcs.DrawText(PDC, C, CLen, R, Format);
  inc(Count);
end;

procedure PrintComboBox(Combo: TComboBox);
var C : array[0..255] of char;
    CLen : integer;
    Format : Word;
    R: TRect;
begin
  Printer.Canvas.Font := Combo.Font;
  PDC := Printer.Canvas.Handle; {so DrawText knows about font}
  R := ScaleToPrinter(Combo.BoundsRect);
  Printer.Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
  R.Left := R.Left + ScaleX + ScaleX;
  Format := DT_SINGLELINE or DT_VCENTER;
  CLen := Combo.GetTextBuf(C,255);
  WinProcs.DrawText(PDC, C, CLen, R, Format);
  inc(Count);
end;

procedure PrintLCombo(Combo: TDBLookupCombo);
var C : array[0..255] of char;
    CLen : integer;
    Format : Word;
    R: TRect;
begin
  Printer.Canvas.Font := Combo.Font;
  PDC := Printer.Canvas.Handle; {so DrawText knows about font}
  R := ScaleToPrinter(Combo.BoundsRect);
  Printer.Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
  R.Left := R.Left + ScaleX + ScaleX;
  Format := DT_SINGLELINE or DT_VCENTER;
  CLen := Combo.GetTextBuf(C,255);
  WinProcs.DrawText(PDC, C, CLen, R, Format);
  inc(Count);
end;

procedure PrintShape(SC:TShape);
  var H, W, S : integer;
      R : TRect;
  begin  {PrintShape}
    Printer.Canvas.Pen := SC.Pen;
    Printer.Canvas.Pen.Width :=  Printer.Canvas.Pen.Width * ScaleX;
    Printer.Canvas.Brush := SC.Brush;
    R := ScaleToPrinter(SC.BoundsRect);
    W := R.Right - R.Left; H := R.Bottom - R.Top;
    if W < H then S := W else S := H;
    if SC.Shape in [stSquare, stRoundSquare, stCircle] then
    begin
      Inc(R.Left, (W - S) div 2);
      Inc(R.Top, (H - S) div 2);
      W := S;
      H := S;
    end;
    case SC.Shape of
      stRectangle, stSquare:
        Printer.Canvas.Rectangle(R.Left, R.Top, R.Left + W, R.Top + H);
      stRoundRect, stRoundSquare:
        Printer.Canvas.RoundRect(R.Left, R.Top, R.Left + W, R.Top + H, S div 4, S div 4);
      stCircle, stEllipse:
        Printer.Canvas.Ellipse(R.Left, R.Top, R.Left + W, R.Top + H);
    end;
    inc(Count);
  end; {PrintShape}

  procedure PrintStringGrid(SGC:TStringGrid);
  var J, K : integer;
      Q, R : TRect;
      Format : Word;
     C : array[0..255] of char;
     CLen : integer;
  begin
    Printer.Canvas.Font := SGC.Font;
    PDC := Printer.Canvas.Handle; {so DrawText knows about font}
    Format := DT_SINGLELINE or DT_VCENTER;
    Q := SGC.BoundsRect;
    Printer.Canvas.Pen.Width := SGC.GridLineWidth * ScaleX;
    for J := 0 to SGC.ColCount - 1 do
      for K:= 0 to SGC.RowCount - 1 do
      begin
        R := SGC.CellRect(J, K);
        if R.Right > R.Left then
        begin
          R.Left := R.Left + Q.Left;
          R.Right := R.Right + Q.Left + SGC.GridLineWidth;
          R.Top := R.Top + Q.Top;
          R.Bottom := R.Bottom + Q.Top + SGC.GridLineWidth;
          R := ScaleToPrinter(R);
          if (J < SGC.FixedCols) or (K < SGC.FixedRows) then
            Printer.Canvas.Brush.Color := SGC.FixedColor
          else
            Printer.Canvas.Brush.Style := bsClear;
          if SGC.GridLineWidth > 0 then  {print grid lines or not}
            Printer.Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
          StrPCopy(C, SGC.Cells[J,K]);
          R.Left := R.Left + ScaleX + ScaleX;
          WinProcs.DrawText(PDC, C, StrLen(C), R, Format);
        end;
      end;
    inc(Count);
  end;

  procedure PrintChart(Chart: TChartFX);
  var R : TRect;
  begin
    R := ScaleToPrinter(Chart.BoundsRect);
    if Chart.BorderStyle > 0 then
      Printer.Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
    ChartFX.chart_Paint(Chart.Handle, PDC, R.Left, R.Top, R.Right, R.Bottom, 1, 0);
    inc(Count);
  end;

  procedure PrintCheckBox(CB: TCheckBox);
  var R, BR : TRect;
      W, H : integer;
      C : array[0..255] of char;
      CLen : integer;
      Format : Word;
  begin
    Printer.Canvas.Font := CB.Font;
    PDC := Printer.Canvas.Handle; {so DrawText knows about font}
    W := 12 * ScaleX; H := 12 * ScaleY;
    R := ScaleToPrinter(CB.BoundsRect);
    BR := R;
    BR.Top := R.Top + ((R.Bottom - R.Top) div 2) - (H div 2);
    BR.Bottom := BR.Top + H;
    if (not CB.Ctl3d) and (CB.Alignment = taLeftJustify) then
      begin
        BR.Right := R.Right; BR.Left := R.Right - W;
        R.Right := R.Right - W - ScaleX - ScaleX;
      end
      else
      begin
        BR.Right := R.Left + w; BR.Left := R.Left;
        R.Left := R.Left + W + ScaleX + ScaleX;
      end;
    Printer.Canvas.Rectangle(BR.Left, BR.Top, BR.Right, BR.Bottom);
    if CB.Checked then with Printer.Canvas do
    begin
      Printer.Canvas.Pen.Width := Printer.Canvas.Pen.Width - 1;
      MoveTo(BR.Left, BR.Top); LineTo(BR.Right, BR.Bottom);
      MoveTo(BR.Right, BR.Top); LineTo(BR.Left, BR.Bottom);
    end;
    Format := DT_SINGLELINE or DT_VCENTER;
    CLen := CB.GetTextBuf(C,255);
    WinProcs.DrawText(PDC, C, CLen, R, Format);
    inc(Count);
  end;

  procedure PrintImage(IC: TImage);
  var R : TRect;
  begin
    R := ScaleToPrinter(IC.BoundsRect);
    Printer.Canvas.StretchDraw(R, IC.Picture.Graphic);
    inc(Count);
  end;

function PrintPage(APage : TScrollingWinControl; ATag : Longint): integer;
begin  {PrintPage}
  Count := 0;
  SW := APage;
  Printer.BeginDoc;
  try
    PDC := Printer.Canvas.Handle;
    ScaleX := WinProcs.GetDeviceCaps(PDC, LOGPIXELSX) div DesignPixelsPerInch;
    ScaleY := WinProcs.GetDeviceCaps(PDC, LOGPIXELSY) div DesignPixelsPerInch;
    for Co := 0 to SW.ControlCount-1 do
    if SW.Controls[Co].Visible then
      if (ATag = 0) or (SW.Controls[Co].Tag and ATag = ATag) then
    begin
      Printer.Canvas.Pen.Width := ScaleX;
      Printer.Canvas.Pen.Color := clBlack;
      Printer.Canvas.Pen.Style := psSolid;
      Printer.Canvas.Brush.Style := bsClear;
      if (SW.Controls[Co] is TCustomLabel) then
        PrintLabel(TLabel(SW.Controls[Co]));
      if (SW.Controls[Co] is TCustomMemo) then
        PrintMemo(TMemo(SW.Controls[Co]));
      if (SW.Controls[Co] is TCustomMaskEdit) or
          (SW.Controls[Co] is TEdit) then
        PrintEdit(TEdit(SW.Controls[Co]));
      if (SW.Controls[Co] is TCustomComboBox) then
        PrintComboBox(TComboBox(SW.Controls[Co]));
      if (SW.Controls[Co] is TDBLookupCombo) then
        PrintLCombo(TDBLookupCombo(SW.Controls[Co]));
      if (SW.Controls[Co] is TShape) then
        PrintShape(TShape(SW.Controls[Co]));
      if (SW.Controls[Co] is TStringGrid) then
        PrintStringGrid(TStringGrid(SW.Controls[Co]));
      if (SW.Controls[Co] is TChartFX) then
        PrintChart(TChartFX(SW.Controls[Co]));
      if (SW.Controls[Co] is TCustomCheckBox) then
        PrintCheckBox(TCheckBox(SW.Controls[Co]));
      if (SW.Controls[Co] is TImage) then
        PrintImage(TImage(SW.Controls[Co]));
    end;
  finally
  {AbortDoc(Printer.Canvas.Handle);
  Printer.Abort;}
  Printer.EndDoc;
  Result := Count;
  end;
end;   {PrintPage}

end.
