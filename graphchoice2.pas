//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit graphchoice2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Observed_Data,
  graphchc, StdCtrls, Buttons, ExtCtrls, Global, AQUAOBJ, CheckLst, hh;

type
  TGraphChoiceDlg2 = class(TGraphChoiceDlg)
    Y2List: TListBox;
    Y2Caption: TLabel;
    ExcludeAll2: TSpeedButton;
    Exclude2: TSpeedButton;
    IncludeAll2: TSpeedButton;
    Include2: TSpeedButton;
    Y1Unit: TLabel;
    Y2Unit: TLabel;
    Y1ScalePanel: TPanel;
    Y1Label: TLabel;
    Min1: TLabel;
    Max1: TLabel;
    AMinY1: TEdit;
    BMaxY1: TEdit;
    AutoScaleY1: TRadioButton;
    UsebelowY1: TRadioButton;
    Y2ScalePanel: TPanel;
    Y2Label: TLabel;
    Min2: TLabel;
    Max2: TLabel;
    CMinY2: TEdit;
    DMaxY2: TEdit;
    AutoScaleY2: TRadioButton;
    UseBelowY2: TRadioButton;
    Panel5: TPanel;
    Label1: TLabel;
    ADateMin: TEdit;
    Label2: TLabel;
    BDateMax: TEdit;
    tolabel: TLabel;
    Label3: TLabel;
    Button1: TButton;
    AutoScaleAll: TCheckBox;
    Panel4: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    EpiButt: TRadioButton;
    HypButton: TRadioButton;
    UseTwoButt: TButton;
    Namepane: TPanel;
    GraphNameEdit: TEdit;
    Label10: TLabel;
    GraphTypePanel: TPanel;
    GraphTypeLab: TLabel;
    GraphTypeBox: TComboBox;
    ScatterPlotLabel: TLabel;
    LogBox: TCheckBox;
    RepeatPeriodBox: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure UseTwoButtClick(Sender: TObject);
    procedure AMinY1KeyPress(Sender: TObject; var Key: Char);
    procedure CMinY2KeyPress(Sender: TObject; var Key: Char);
    procedure AutoScaleY1Click(Sender: TObject);
    procedure AutoScaleY2Click(Sender: TObject);
    procedure AMinY1Exit(Sender: TObject);
    procedure SrcListClick(Sender: TObject);
    procedure IncludeBtnClick(Sender: TObject);
    procedure IncAllBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure ExcAllBtnClick(Sender: TObject);
    procedure HelpButtClick(Sender: TObject);
    procedure FilterButtClick(Sender: TObject);
    procedure SubStrEditChange(Sender: TObject);
    procedure ResetDatesClick(Sender: TObject);
    procedure ADateMinExit(Sender: TObject);
    procedure ADateMinKeyPress(Sender: TObject; var Key: Char);
    procedure GraphNameEditExit(Sender: TObject);
    procedure EpiButtClick(Sender: TObject);
    procedure GraphTypeBoxChange(Sender: TObject);
    procedure AutoScaleAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    CtrlGraph, DiffGraph: Boolean;
    ThisGSR: TGraphSetup;
    Function AddChoice(ChoiceIndex: LongInt; AddToY1:Boolean): Boolean;
    Procedure RemoveChoice(ChoiceIndex: LongInt; AddToY1:Boolean);
  public
    RC: TResultsCollection;
    TOD: TObservedData;
    HypExists,ScreenUpdating: Boolean;
    Function EditGraphChoices(Var GSR: TGraphSetup; Diff, Ctrl, Linked:Boolean): Boolean;
    Procedure UpdateScreen;
    Procedure UpdateButtons;
    { Public declarations }
  end;

var
  GraphChoiceDlg2: TGraphChoiceDlg2;
  Choices: Array of LongInt;
  Chosen: Array[False..True,0..40] of LongInt;

implementation

uses GraphSetup;

{$R *.DFM}

Function TGraphChoiceDlg2.EditGraphChoices(var gsr: TGraphSetup; Diff,Ctrl,Linked:Boolean): Boolean;
Var MR: TModalResult;
    OldGSR: TMemoryStream;
Begin
  CtrlGraph := Ctrl;
  DiffGraph := Diff;

  UseTwoButt.Visible  := Not Diff;

  OldGSR := TMemoryStream.Create;
  GSR.Store(True,TStream(OldGSR));

  ThisGSR := GSR;

  UpdateScreen;

  MR := ShowModal;

  EditGraphChoices := (MR<>MRCancel);
  If MR=MRCancel then Begin
                        OldGSR.Seek(0, soFromBeginning); {Go to beginning of stream}
                        GSR.Destroy;
                        GSR := TGraphSetup.CreateEmptyGraph(Linked);
                        GSR.Load(True,TStream(OldGSR),VersionNum);
                      End;
  OldGSR.Destroy;
End;

procedure TGraphChoiceDlg2.EpiButtClick(Sender: TObject);
begin
  If EpiButt.Checked then ThisGSR.Data.VSeg  := Epilimnion
                     else ThisGSR.Data.VSeg  := Hypolimnion;
end;

Procedure TGraphChoiceDlg2.UpdateScreen;
Var Loop, Loop2, Use2Gap: Integer;
    PH   : TResHeader;
    Use2, Y1, Found: Boolean;
    DstIndex,Y1Index,Y2Index: Integer;
    HeadStr,SubStr: String;
    WorkList: TListBox;

    Procedure AddToList;
    Begin
      SourceList.Items.Add(PH.ListStr(False));
      If Length(Choices) < SourceList.Items.Count
        then SetLength(Choices,SourceList.Items.Count*2);  {double length of dynamic array}
      Choices[SourceList.Items.Count-1] := PH.SortIndex;
    End;

    Procedure AddObserved;
    Begin
      With TOD.OSeries[Loop] do
        SourceList.Items.Add(NameStr  + ' (' + UnitStr + ')');
      If Length(Choices) < SourceList.Items.Count
        then SetLength(Choices,SourceList.Items.Count*2);  {double length of dynamic array}
      Choices[SourceList.Items.Count-1] := TOD.OSeries[Loop].UniqueIndex;
    End;

    procedure EnableDisableScales(Enab: Boolean);
    var
    i : integer;
    TWC : TWinControl;
    begin
       TWC := Y1ScalePanel as TWinControl;
       for i := 0 to TWC.ControlCount -1 do
          TEdit(TWC.Controls[i]).Enabled := Enab;
       TWC := Y2ScalePanel as TWinControl;
       for i := 0 to TWC.ControlCount -1 do
          TEdit(TWC.Controls[i]).Enabled := Enab;
    end;

Begin
   If not DiffGraph then EnableDisableScales(Not ThisGSR.data.AutoScaleAll);
   AutoScaleAll.Checked := ThisGSR.data.AutoScaleAll;
   LogBox.Checked       := ThisGSR.data.Logarithmic;
   If DiffGraph then GraphTypePanel.Visible := False;

   GraphNameEdit.Text := ThisGSR.data.GraphName;
   GraphTypeBox.ItemIndex := ThisGSR.data.GraphType;
   RepeatPeriodBox.Visible := (not DiffGraph) and (ThisGSR.data.GraphType in [1,2]);
   RepeatPeriodBox.Checked := ThisGSR.data.RepeatPeriods;
   
   DstIndex := SourceList.ItemIndex;
   Y2Index := Y2List.ItemIndex;
   y1Index := DstList.ItemIndex;

   EpiButt.Checked   := ThisGSR.Data.VSeg = Epilimnion;
   HypButton.Checked := ThisGSR.Data.VSeg = Hypolimnion;
   EpiButt.Enabled := HypExists;
   HypButton.Enabled := HypExists;

   DstList.Items.Clear;
   Y2List.Items.Clear;
   SourceList.Items.Clear;  SourceList.Items.BeginUpdate;
   If DiffGraph then Y1Unit.Caption := '(% Difference):'
                else Y1Unit.Caption := '(unit):';
   Y2Unit.Caption := '(unit):';
   ScatterplotLabel.Visible := (ThisGSR.data.GraphType=3);

   For Loop:= 0 to RC.Headers.Count-1 do
     Begin
       PH := RC.Headers.At(Loop);
       Found := False;
       For Loop2 := 1 to 20 do
         If ThisGSR.data.YItems[True,Loop2] = PH.SortIndex then
           Begin
             Found := True;
             If (DstList.Items.Count > 0) and (ThisGSR.data.GraphType=3)
               then
                 Begin
                   ThisGSR.data.YItems[True,Loop2] := -99;  {only one item on x axis for scatter plot}
                   Found := False;
                 End
               else
                 Begin
                   If Not DiffGraph then Y1Unit.Caption := '('+PH.UnitStr +'):';
                   DstList.Items.Add(PH.HeadStr);
                   Chosen[True,DstList.Items.Count-1] := PH.SortIndex;
                 End;
           End;

       If Not Found then
         For Loop2 := 1 to 20 do
           If ThisGSR.data.YItems[False,Loop2] = PH.SortIndex then
             Begin
               Found := True;
               Y2Unit.Caption := '('+PH.UnitStr +'):';
               If DiffGraph then DstList.Items.Add(PH.HeadStr)
                            else Y2List.Items.Add(PH.HeadStr);
               If DiffGraph then Chosen[False,DstList.Items.Count-1] := PH.SortIndex
                            else Chosen[False,Y2List.Items.Count-1] := PH.SortIndex;
             End;

       If Not Found then
         If ShowAllButt.Checked then AddToList
          else
             Begin
                SubStr := Uppercase(Trim(SubStrEdit.Text));
                If SubStr = ''
                  then AddToList
                  else
                    Begin
                      HeadStr := Uppercase(PH.ListStr(False));
                      If (ExcludeBox.Checked) then if (Pos(SubStr,HeadStr)=0) then AddToList;
                      If (not ExcludeBox.Checked) then if (Pos(SubStr,HeadStr)>0) then AddToList;
                    End;
             End;

     End;

   For Loop:= 0 to TOD.NumSeries -1   do  {OBSERVED DATA CODE}
     Begin
       Found := False;
       For Loop2 := 1 to 20 do
        For Y1 := False to True do
         If ThisGSR.data.YItems[Y1,Loop2] = TOD.OSeries[Loop].UniqueIndex then
          With TOD.OSeries[Loop] do
           Begin
             Found := True;
             If Y1 or DiffGraph then WorkList := DstList
                                else WorkList := Y2List;

             If (ThisGSR.data.GraphType=3)
               then
                 Begin
                   ThisGSR.data.YItems[Y1,Loop2] := -99;  {Scatter plots not enabled with observed data}
                   Found := False;
                 End
               else
                 Begin
                   If Y1 and (Not DiffGraph) then Y1Unit.Caption := '('+UnitStr +'):';
                   If (not Y1) and (Not DiffGraph) then Y2Unit.Caption := '('+UnitStr +'):';
                   WorkList.Items.Add(NameStr);
                   Chosen[Y1,WorkList.Items.Count-1] := UniqueIndex;
                 End;
           End;

       If Not Found then
         If ShowAllButt.Checked then AddObserved
          else
             Begin
                SubStr := Uppercase(Trim(SubStrEdit.Text));
                HeadStr := Uppercase(TOD.OSeries[Loop].NameStr);
                If SubStr = ''
                  then AddObserved
                  else If (ExcludeBox.Checked) and (Pos(SubStr,HeadStr)=0) then AddObserved
                  else If (not ExcludeBox.Checked) and (Pos(SubStr,HeadStr)>0) then AddObserved;
             End;
     End;

   SourceList.Items.EndUpdate;

   With ThisGSR.data do
     Begin
       If DiffGraph then Use2 := False
                    else Use2 := Use2Scales;
       UseTwoButt.Visible := Not DiffGraph;
       If Use2 then UseTwoButt.Caption := 'Use One Y Axis'
               else UseTwoButt.Caption := 'Use Two Y Axes';
       Include2.Visible    := Use2;
       IncludeAll2.Visible := Use2;
       Exclude2.Visible    := Use2;
       ExcludeAll2.Visible := Use2;
       Y2List.Visible      := Use2;
       Y2Caption.Visible   := Use2;
       Y2Unit.Visible      := Use2;
       Y2ScalePanel.Visible := Use2;

       If Use2 then Use2Gap := 0
               else Use2Gap := 175;

       DstList.Height := Panel3.Height - 255 + Use2Gap;
     End;

   With ThisGSR.data do
     Begin
       If DiffGraph then AMinY1.Text := FloatToStrF(DiffMin ,ffgeneral,9,4)
                    else AMinY1.Text := FloatToStrF(Y1Min ,ffgeneral,9,4);
       If DiffGraph then BMaxY1.Text := FloatToStrF(DiffMax ,ffgeneral,9,4)
                    else BMaxY1.Text := FloatToStrF(Y1Max ,ffgeneral,9,4);

       CMinY2.Text := FloatToStrF(Y2Min ,ffgeneral,9,4);
       DMaxY2.Text := FloatToStrF(Y2Max ,ffgeneral,9,4);

       If XMin = 0 then XMin := TResults(RC.at(0)).Date;
       If XMAX = 0 then XMAX := TResults(RC.at(RC.Count-1)).Date;

       ADateMin.Text := DatetoStr(XMin);
       BDateMax.Text := DatetoStr(XMax);

       If DiffGraph then AutoScaleY1.Checked := DiffAutoScale
                    else AutoScaleY1.Checked := Y1AutoScale;
       If DiffGraph then UseBelowY1.Checked := not DiffAutoScale
                    else UseBelowY1.Checked := not Y1AutoScale;

       AutoScaleY2.Checked := Y2AutoScale;
       UseBelowY2.Checked := not Y2AutoScale;
     End;

   If (DstIndex > -1) and (SourceList.Items.Count >=DstIndex+1)
      then SourceList.Selected[DstIndex] := True;
   If (Y2Index > -1) and (Y2List.Items.Count >=Y2Index+1)
      then Y2List.Selected[Y2Index] := True;
   If (Y1Index > -1) and (DstList.Items.Count >=Y1Index+1)
      then DstList.Selected[Y1Index] := True;

   If ThisGSR.data.GraphType = 3
     Then Begin
            DstLabel.Caption := 'X Axis Series';
            Y2Caption.Caption :=  'Results on Y Axis';
            UseTwoButt.Visible :=  False;
            AutoScaleAll.Visible := False;
            LogBox.Visible := False;
            Y1Label.Caption := 'X Axis Scale';
            Y2Label.Caption := 'Y Axis Scale';
          End
     Else Begin
            DstLabel.Caption := 'Results on Y1 Axis';
            Y2Caption.Caption :=  'Results on Y2 Axis';
            UseTwoButt.Visible :=  Not DiffGraph;
            AutoScaleAll.Visible := True;
            LogBox.Visible := True;
            Y1Label.Caption := 'Y1 Axis Scale';
            Y2Label.Caption := 'Y2 Axis Scale';
          End;

   UpdateButtons;
End;


Procedure TGraphChoiceDlg2.UpdateButtons;

Begin
   IncludeBtn.Enabled  := SourceList.Selcount>0;
   IncAllBtn.Enabled   := SourceList.Items.Count>0;
   Include2.Enabled    := SourceList.Selcount>0;
   IncludeAll2.Enabled := SourceList.Items.Count>0;

   ExcludeBtn.Enabled  := DstList.Selcount>0;
   ExAllBtn.Enabled    := DstList.Items.Count>0;

   Exclude2.Enabled    := Y2List.Selcount>0;
   ExcludeAll2.Enabled := Y2List.Items.Count>0;
End;

procedure TGraphChoiceDlg2.FormCreate(Sender: TObject);
begin
  SetLength(Choices,2000);
end;

procedure TGraphChoiceDlg2.FormDestroy(Sender: TObject);
begin
  Choices := nil;

end;

procedure TGraphChoiceDlg2.FormShow(Sender: TObject);
begin
   If GraphnameEdit.Text = 'New Graph' then GraphNameEdit.SetFocus;
end;

procedure TGraphChoiceDlg2.GraphNameEditExit(Sender: TObject);
begin
  ThisGSR.data.GraphName := GraphNameEdit.Text;
end;

procedure TGraphChoiceDlg2.GraphTypeBoxChange(Sender: TObject);
begin
  ThisGSR.data.GraphType := GraphTypeBox.ItemIndex;
  If ThisGSR.data.GraphType = 3 then ThisGSR.data.Use2Scales := True;
  UpdateScreen;
end;

procedure TGraphChoiceDlg2.OKBtnClick(Sender: TObject);
begin

  OKBtn.SetFocus;

  With ThisGSR.data do
    Begin
      If DiffGraph
        then
          Begin
            If not DiffAutoScale and (DiffMax <= DiffMin) then
              Begin
                MessageDlg('The entered Y Maximum must be greater than the Y Minimum.',mterror,[mbok],0);
                Exit;
              End
          End
        else
          If not Y1AutoScale and (Y1Max <= Y1Min) then
            Begin
              MessageDlg('The entered Y1 Maximum must be greater than the Y1 Minimum.',mterror,[mbok],0);
              Exit;
            End;

      If not Y2AutoScale and (Y2Max <= Y2Min) then
        Begin
          MessageDlg('The entered Y2 Maximum must be greater than the Y2 Minimum.',mterror,[mbok],0);
          Exit;
        End;

      If (XMin > XMax) then
        Begin
          MessageDlg('The date range you entered is invalid.',mterror,[mbok],0);
          Exit;
        End;
    End;

  ModalResult := MrOK;
end;

procedure TGraphChoiceDlg2.UseTwoButtClick(Sender: TObject);
Var Loop: Integer;
begin
  With ThisGSR.Data do
  Begin
    Use2Scales := Not Use2Scales;
    If not Use2Scales
      Then For Loop := 1 to 20 do
          YItems[False,Loop] := -99;
  End;

  UpdateScreen;

end;

procedure TGraphChoiceDlg2.AMinY1KeyPress(Sender: TObject; var Key: Char);
begin
  UseBelowY1.Checked := True;
  If Key=Chr(13) then AminY1Exit(sender)
end;

procedure TGraphChoiceDlg2.CMinY2KeyPress(Sender: TObject; var Key: Char);
begin
  UseBelowY2.Checked := True;
  If Key=Chr(13) then AminY1Exit(sender)
end;

procedure TGraphChoiceDlg2.AutoScaleAllClick(Sender: TObject);
begin
  If Sender = RepeatPeriodBox then ThisGSR.data.RepeatPeriods := RepeatPeriodBox.Checked;
  If Sender = AutoScaleAll then ThisGSR.data.AutoScaleAll := AutoScaleAll.Checked;
  If Sender = LogBox then ThisGSR.data.Logarithmic  := LogBox.Checked;
  UpdateScreen;
end;

procedure TGraphChoiceDlg2.AutoScaleY1Click(Sender: TObject);
begin
  If DiffGraph then ThisGSR.data.DiffAutoScale := AutoScaleY1.checked
               else ThisGSR.data.Y1AutoScale := AutoScaleY1.checked;
end;

procedure TGraphChoiceDlg2.AutoScaleY2Click(Sender: TObject);
begin
  ThisGSR.data.Y2AutoScale := AutoScaleY2.checked;
end;


procedure TGraphChoiceDlg2.AMinY1Exit(Sender: TObject);
Var
Conv: Double;
Result: Integer;

begin
  Val(Trim(Tedit(Sender).Text),Conv,Result);
  If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
    else   case TEdit(Sender).Name[1] of
              'A': If DiffGraph then ThisGSR.data.DiffMin :=Conv else ThisGSR.data.Y1Min :=Conv;
              'B': If DiffGraph then ThisGSR.data.DiffMax :=Conv else ThisGSR.data.Y1Max :=Conv;
              'C': ThisGSR.data.Y2Min :=Conv;
              'D': ThisGSR.data.Y2Max :=Conv;
           end; {case}
end;

procedure TGraphChoiceDlg2.SrcListClick(Sender: TObject);
begin
  UpdateButtons;
end;

Procedure TGraphChoiceDlg2.RemoveChoice(ChoiceIndex: LongInt; AddToY1:Boolean);
Var Loop: Integer;
    OtherVar: Boolean;
Begin
  OtherVar := False;
  For loop := 20 downto 1 do
   With ThisGSR.Data do
    Begin
      if YItems[AddToY1,Loop]=ChoiceIndex then
         YItems[AddToY1,Loop]:=-99;
      if YItems[AddToY1,Loop]<>-99 then OtherVar := True;
    End;

  If (Not OtherVar) and (Not DiffGraph) then
    If AddToY1 then Y1Unit.Caption := '(unit):'
               else Y2Unit.Caption := '(unit):';
End;

Function TGraphChoiceDlg2.AddChoice(ChoiceIndex: LongInt; AddToY1:Boolean): Boolean;
Var AxisUnit, UnitChosen: String;
    ThisHead: TResHeader;
    Loop: Integer;
    NewSlot: Integer;
Begin
  AddChoice := True;
  If AddToY1 then AxisUnit := Y1Unit.Caption
             else AxisUnit := Y2Unit.Caption;

  UnitChosen := '';
  If ChoiceIndex>-999
    then
        For Loop:= 0 to RC.Headers.Count-1 do
          Begin
            ThisHead := RC.Headers.At(Loop);
            If ThisHead.SortIndex = ChoiceIndex then
              Begin
                UnitChosen := ThisHead.UnitStr;
                break;
              End;
          End
    else
        For Loop := 0 to TOD.NumSeries-1 do
          Begin
            IF TOD.OSeries[Loop].UniqueIndex = ChoiceIndex then
              Begin
                UnitChosen := TOD.OSeries[Loop].UnitStr;
                break;
              End;
          End;

  If not DiffGraph and
     (AxisUnit <> '(unit):') and
     (AxisUnit <> '('+UnitChosen+'):') then
     Begin
       MessageDlg('All variables on one Y axis must have the same units.',mterror,[mbok],0);
       AddChoice := False;
       Exit;
     End;

  If not DiffGraph and (AxisUnit <> '('+UnitChosen+'):') then
    If AddToY1 then Y1Unit.Caption := '('+UnitChosen+'):'
               else Y2Unit.Caption := '('+UnitChosen+'):';

  NewSlot := 0;
  For loop := 20 downto 1 do
    If ThisGSR.data.YItems[AddToY1,Loop]=-99 then NewSlot := Loop;

  If NewSlot=0 then
     Begin
       MessageDlg('You can not plot over 20 variables on one Y axis.',mterror,[mbok],0);
       AddChoice := False;
       Exit;
     End;

  ThisGSR.data.YItems[AddToY1,NewSlot] := ChoiceIndex;

End;

procedure TGraphChoiceDlg2.IncludeBtnClick(Sender: TObject);
Var Loop: Integer;
    IsY1: Boolean;
begin
  IsY1 := (TButton(Sender).Name='IncludeBtn');

  {Multiple Item Selection Loop}
  For Loop:=0 to SourceList.Items.Count-1 do
   If SourceList.Selected[Loop] then
     If not AddChoice(Choices[Loop],IsY1) then Break;

  UpdateScreen;
end;

procedure TGraphChoiceDlg2.IncAllBtnClick(Sender: TObject);
Var Loop: Integer;
    IsY1: Boolean;
begin
  IsY1 := (TButton(Sender).Name='IncAllBtn');

  For Loop:=0 to SourceList.Items.Count-1 do
   If not AddChoice(Choices[Loop],IsY1) then Break;

  UpdateScreen;

end;




procedure TGraphChoiceDlg2.ExcludeBtnClick(Sender: TObject);
Var Loop: Integer;
    IsY1: Boolean;
    ThisList: TListBox;
begin
  IsY1 := (TButton(Sender).Name='ExcludeBtn');

  If IsY1 then ThisList := DstList
          else ThisList := Y2List;

  {Multiple Item Selection Loop}
  For Loop:=0 to ThisList.Items.Count-1 do
   If ThisList.Selected[Loop] then
     RemoveChoice(Chosen[IsY1,Loop],IsY1);

  UpdateScreen;
end;

procedure TGraphChoiceDlg2.ExcAllBtnClick(Sender: TObject);
Var Loop: Integer;
    IsY1: Boolean;
    ThisList: TListBox;
begin
  IsY1 := (TButton(Sender).Name='ExAllBtn');

  If IsY1 then ThisList := DstList
          else ThisList := Y2List;

  {Multiple Item Selection Loop}
  For Loop:=0 to ThisList.Items.Count-1 do
    RemoveChoice(Chosen[IsY1,Loop],IsY1);

  UpdateScreen;
end;


procedure TGraphChoiceDlg2.HelpButtClick(Sender: TObject);
begin
   HTMLHelpContext('Modifying_a_Graph.htm');
end;

procedure TGraphChoiceDlg2.FilterButtClick(Sender: TObject);
begin
  UpdateScreen;
end;

procedure TGraphChoiceDlg2.SubStrEditChange(Sender: TObject);
begin
  UpdateScreen;
  FilterButt.checked := True;
end;

procedure TGraphChoiceDlg2.ResetDatesClick(Sender: TObject);
begin
   ThisGSR.data.XMin := TResults(RC.at(0)).Date;
   ThisGSR.data.XMAX := TResults(RC.at(RC.Count-1)).Date;
   updatescreen;
end;

procedure TGraphChoiceDlg2.ADateMinExit(Sender: TObject);
Var
  Conv: TDateTime;
begin
    Try
       Conv := StrToDate(TEdit(Sender).Text);
       case TEdit(Sender).Name[1] of
                      'A': ThisGSR.data.XMin:=Conv;
                      'B': ThisGSR.data.XMax:=Conv;
                      end; {case}
    Except
       on EconvertError do MessageDlg('Incorrect Date Format Entered: Must be '+ShortDateFormat,mterror,[mbOK],0)
    End; {try Except}
    UpdateScreen;
end;


procedure TGraphChoiceDlg2.ADateMinKeyPress(Sender: TObject;
  var Key: Char);
begin
  If Key=Chr(13) then ADateMinExit(sender);
end;

end.
