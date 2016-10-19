//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit U_Setup;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Corr_Edit,
  DB, DBTables, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, Uncert, Global, LinkedSegs,
  ComCtrls, ImgList, AQUAOBJ, AQStudy, AQBaseForm, GraphChc, Correlate, hh;

type
  TUSetupForm = class(TAQBase)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    UncertPanel: TPanel;
    Label1: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    NumIterationsEdit: TEdit;
    RandSeedEdit: TEdit;
    Label8: TLabel;
    UseSeedBox: TCheckBox;
    Panel3: TPanel;
    HelpButton: TButton;
    Panel1: TPanel;
    TreeView1: TTreeView;
    ImageList1: TImageList;
    Panel4: TPanel;
    Label5: TLabel;
    UncertButt: TRadioButton;
    SensButt: TRadioButton;
    DetermButt: TRadioButton;
    SensPanel: TPanel;
    Label2: TLabel;
    Label4: TLabel;
    PctEdit: TEdit;
    Panel5: TPanel;
    SelectLabel: TLabel;
    TrackXXLabel: TLabel;
    TrackOutButton: TButton;
    LinkPP: TCheckBox;
    CorrelationButton: TButton;
    CorrelationLabel: TLabel;
    SensLabel: TLabel;
    IterCap: TLabel;
    SaveEachIteration: TCheckBox;
    RandomSampleBox: TCheckBox;
    SegBox: TComboBox;
    procedure ConvInt(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure UseSeedBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UncertButtClick(Sender: TObject);
    procedure TrackOutButtonClick(Sender: TObject);
    procedure LinkPPMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CorrelationButtonClick(Sender: TObject);
    procedure TreeView1KeyPress(Sender: TObject; var Key: Char);
    procedure SaveEachIterationMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RandomSampleBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SegBoxChange(Sender: TObject);
  private
     ListBoxIDs: TListBoxIDs;
    { Private declarations }
    Procedure UpdateScreen;
    Procedure UpdateGrid;
    Procedure UpdateDistName(Var TN: TTreeNode; P: TDistribution; SegIndex:Integer);
    Procedure UpdateNodes(TN: TTreeNode; Nm: String; PD: TDistribution; Indx: Integer);

  public
    TempDists : Array of TDistributionList;
    TDIndex : Integer;
    UsedNode    : TTreeNode;
    SV          : TStates;
    All_Segs    : Boolean;
    LAQTS       : TLinkedSegs;
    AQTS        : TAQUATOXSegment;
    OrigRecord  : PUncertainty_Setup_Record;
    TempRecord  : Uncertainty_Setup_Record;
    Changed     : Boolean;
    OVChanged, DistChanged : Boolean;
    Procedure Edit_USetup;
    Function HasChanged:Boolean;
    Procedure PassVars(OrigRecord: PUncertainty_Setup_record; SV: TStates; AQTS:TAQUATOXSegment;LAQTS:TLinkedSegs; AllSegs: Boolean);
    { Public declarations }
  end;

var
  USetupForm: TUSetupForm;

implementation

uses TCollect;

{$R *.DFM}


Procedure TUsetupForm.PassVars(OrigRecord: PUncertainty_Setup_record; SV: TStates; AQTS:TAQUATOXSegment;LAQTS:TLinkedSegs; AllSegs: Boolean);
Begin
  USetupForm.OrigRecord :=OrigRecord;
  USetupForm.SV := SV;
  USetupForm.AQTS := AQTS;
  USetupForm.LAQTS := LAQTS;
  USetupForm.All_Segs := AllSegs;
  DistributionForm.Changed:=False;
End;

Procedure TUsetupForm.UpdateDistName(Var TN: TTreeNode;P: TDistribution; SegIndex:Integer);
Var DStr: String;
Begin
  DStr := '';
  If ALL_SEGS and (SegIndex>0) then DStr := '['+ TAQUATOXSegment(LAQTS.SegmentColl.At(SegIndex-1)).SegNumber+'] ';
  DStr := DStr+P.Name;
  TN.Text := DStr;

  If SensButt.Checked then
     Begin
        If P.UseForSens then TN.ImageIndex := 1
                         else TN.ImageIndex := 0;

        If P.UseForSens then TN.SELECTEDIndex := 2
                         else TN.SELECTEDIndex := 0;

       Exit;
     End;

  If P.UseDist then TN.ImageIndex := 1
                else TN.ImageIndex := 0;

  If P.UseDist then TN.SELECTEDIndex := 2
                else TN.SELECTEDIndex := 0;


  If P.UseDist then
     Begin
       Case P.DistType of
            Triangular: DStr := 'Triangular';
            Normal    : DStr := 'Normal';
            LogNormal : DStr := 'LogNormal';
            Uniform   : DStr := 'Uniform';
          end; {case}

       DStr := ':    ('+DStr + ' Distribution, ';

       Case P.DistType of
          Triangular: begin
                        DStr := DStr + 'Most Likely = '+FloatToStrF(P.Parm[1],ffgeneral,9,4);
                        DStr := DStr + ', Min = '+FloatToStrF(P.Parm[2],ffgeneral,9,4);
                        DStr := DStr + ', Max = '+FloatToStrF(P.Parm[3],ffgeneral,9,4)+')';
                      end;
          Normal, LogNormal    : begin
                        DStr := DStr + 'Mean = '+FloatToStrF(P.Parm[1],ffgeneral,9,4);
                        DStr := DStr + ', Std. Dev. = '+FloatToStrF(P.Parm[2],ffgeneral,9,4)+')';
                      end;
          Uniform   : begin
                        DStr := DStr + 'Min = '+FloatToStrF(P.Parm[1],ffgeneral,9,4);
                        DStr := DStr + ', Max = '+FloatToStrF(P.Parm[2],ffgeneral,9,4)+')';
                      end;
        End; {Case}

        TN.Text := TN.Text + DStr;
    End;
End;



Procedure TUsetupForm.UpdateNodes(TN: TTreeNode; Nm: String; PD: TDistribution; Indx: Integer);
Var i: Integer;
    ThisNm: String;
Begin
  If TN.Count>0 then exit;

  ThisNm := TN.Text;

  i := Pos(':    (',ThisNm);
  If i>0 then                                             
    Delete(ThisNm,i,Length(ThisNm)-i+1);

  If ThisNm = Nm then UpdateDistName(TN,PD,Indx);

End;


Procedure TUsetupForm.UpdateGrid;
Var RootNode, ChemNode, ThisNode  : TTreeNode;
    OldCursor: TCursor;
    SVLoop: AllVariables;
    Name: String;

         Procedure PutInTree(P: TDistribution);
         var NewNode: TTreeNode;
         {Used to put loadings data into TableIn}
         begin
           NewNode := Treeview1.Items.AddChild(ThisNode,P.Name);
           UpdateDistName(NewNode,P,TDIndex);
         end;

         Function GetDistName(P: TDistribution):String;
         var RD:Registered_Distribution;
             Nm: String;
         {Used to put loadings data into TableIn}
         begin
           RD := SV.Return_Registered_Dist(P.DistNum);
           Nm := RD.RDName;
           If Nm[1] = ':' then Delete(Nm,1,2);
           If Nm[1] = ' ' then Delete(Nm,1,1);
           GetDistName := Nm;
         end;

Var i, LastDNum, DNum, Index, FindIndex, TopIndex: Integer;
    SensMode: Boolean;
    ID: SV_ID;
    NewNode: TTreeNode;
begin
  TreeView1.Visible := not DetermButt.Checked;
  If DetermButt.Checked then exit;

  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  SensMode := SensButt.Checked;

  Treeview1.Items.BeginUpdate;
  Treeview1.Items.Clear;

  {All Distributions}
  ThisNode := Treeview1.Items.Add(nil,'All Distributions');
  ThisNode.SelectedIndex := 3;
  ThisNode.ImageIndex := 3;
  With TempDists[TDIndex] do For i:=0 to count-1 do
                   PutInTree(at(i));

  {Distributions by Parameter}
  RootNode := Treeview1.Items.Add(nil,'Distributions by Parameter');
  RootNode.SelectedIndex := 3;
  RootNode.ImageIndex := 3;
  i := 0;
  With TempDists[TDIndex] do
  Repeat
    Name := GetDistName(at(i));
    ThisNode := Treeview1.Items.AddChild(RootNode,Name);
    ThisNode.SelectedIndex := 3;
    ThisNode.ImageIndex := 3;
    LastDNum := TDistribution(at(i)).DistNum;

    Repeat
      PutInTree(at(i));
      inc(i);
      if i<count then DNum := TDistribution(at(i)).DistNum
                 else DNum := 0;
    Until DNum<>LastDNum;

  Until i=count;

  {Distributions by State Variable}
  RootNode := Treeview1.Items.Add(nil,'Distributions by State Variable');
  RootNode.SelectedIndex := 3;
  RootNode.ImageIndex := 3;
  SV.SetMemLocRec;
  For SvLoop := FirstState to LastState do
     Begin
       Index:=SV.GetIndex(SvLoop,STV,WaterCol);
       If Index > -1 then
           begin
             Name:= TStateVariable(SV.At(index)).PName^;
             If Name = 'Undisplayed' then Index:=-1;
           end;
       If Index>-1 then
         Begin
           ThisNode := Treeview1.Items.AddChild(RootNode,Name);
           ThisNode.SelectedIndex := 3;
           ThisNode.ImageIndex := 3;
           ChemNode := nil;
           If SVLoop in [FirstOrgTox..LastOrgTox] then
             Begin
               ChemNode := ThisNode;
               ThisNode := Treeview1.Items.AddChild(ThisNode,'Chemical Parameters');
               ThisNode.SelectedIndex := 3;
               ThisNode.ImageIndex := 3;
             End;

           With TempDists[TDIndex] do For i:=0 to count-1 do
             Begin
               ID := TDistribution(at(i)).SVID;
               If (ID.nstate = SVLoop)
                  then PutInTree(at(i));
             End;

           If ChemNode <> nil then
             Begin
               ThisNode := Treeview1.Items.AddChild(ChemNode,'Toxicity Parameters');
               ThisNode.SelectedIndex := 3;
               ThisNode.ImageIndex := 3;
               With TempDists[TDIndex] do For i:=0 to count-1 do
                 Begin
                     ID := TDistribution(at(i)).SVID;
                     If (ID.nstate = NullStateVar) and (ID.SVType<>STV)
                     then If (AssocToxSV(ID.SvType) = SVLoop)
                       then PutInTree(at(i));
                 End;
             End;
         End;
    End;
    ThisNode := Treeview1.Items.AddChild(RootNode,'Other');
    ThisNode.SelectedIndex := 3;
    ThisNode.ImageIndex := 3;
    With TempDists[TDIndex] do For i:=0 to count-1 do
       Begin
         ID := TDistribution(at(i)).SVID;
         If (ID.nstate = NullStateVar) and (ID.SVType=STV)
             then PutInTree(at(i));
       End;

  {Distributions to be Used}
  If SensMode then ThisNode := Treeview1.Items.Add(nil,'Selected Parameters for Nominal Sensitivity Test')
              else ThisNode := Treeview1.Items.Add(nil,'Selected Distributions for Uncertainty Run');


  ThisNode.SelectedIndex := 3;
  ThisNode.ImageIndex := 3;
  UsedNode := ThisNode;


  If ALL_Segs then TopIndex := LAQTS.SegmentColl.Count else TopIndex := 0;
  For FindIndex := 0 to TopIndex do
  With TempDists[FindIndex] do For i:=0 to count-1 do
   With TDistribution(At(i)) do
    If ((Not SensMode) and UseDist) or (SensMode and UseForSens) then
      Begin
         NewNode := Treeview1.Items.AddChild(UsedNode,Name);
         UpdateDistName(NewNode,at(i),FindIndex);
      End;


  If SensMode
   then IterCap.Caption := IntToStr(UsedNode.Count)+' Parameters set to be tested or '+
                           IntToStr(UsedNode.Count*2)+' iterations.'
   else IterCap.Caption := '';

  Treeview1.refresh;
  Treeview1.Items.EndUpdate;
  Screen.Cursor := OldCursor;

end;

Procedure TUSetupForm.UpdateScreen;
Begin
 With TempRecord do
 Begin
   UncertButt.Checked := Run_Uncertainty;
   UncertPanel.Visible := Run_Uncertainty;
   CorrelationButton.Visible := Run_Uncertainty;
   SensButt.Checked := Run_Sensitivity;
   SegBox.Visible := All_Segs and (Run_Uncertainty or Run_Sensitivity);

   SelectLabel.Visible := Run_Uncertainty or Run_Sensitivity;
   SensLabel.Visible := Run_Sensitivity;

   If SV.LinkedMode then
     Begin
       CorrelationButton.Enabled := False;
//       SensButt.Enabled := False;
//       Run_Sensitivity := False;
     End;

   CorrelationLabel.Visible := (TempDists[TDIndex].NumCorrelations > 0);
   SensPanel.Visible := Run_Sensitivity;
   DetermButt.Checked := Not (Run_Uncertainty or Run_Sensitivity);
   UseSeedBox.Checked  := UseSeed;
   SaveEachIteration.Checked := SavetoCSV;
   RandomSampleBox.Checked := RandomSampling;
   NumIterationsEdit.Text :=IntToStr(NumSteps);
   RandSeedEdit.Text      :=IntToStr(RandomSeed);
   PctEdit.Text := FloatToStrF(NominalPercent,ffgeneral,9,4);
   LinkPP.Checked := LinkPeriPhyto;
   TrackXXLabel.Caption := 'Track '+IntToStr(NumSens)+' Output Variables';
 End; {with}

 Treeview1.refresh;
 Update;
End;

Function TUSetupForm.HasChanged:Boolean;
Begin
  With OrigRecord^ do
    HasChanged := OVChanged or DistChanged or
      (Run_Uncertainty <> TempRecord.Run_Uncertainty) or
      (Run_Sensitivity <> TempRecord.Run_Sensitivity) or
      (NumSteps <> TempRecord.NumSteps) or
      (RandomSeed <> TempRecord.RandomSeed) or
      (NominalPercent <> TempRecord.NominalPercent) or
      (LinkPeriPhyto <> TempRecord.LinkPeriPhyto) or
      (NumSens <> TempRecord.NumSens) or
      (UseSeed <> TempRecord.UseSeed) or
      (SaveToCSV <> TempRecord.SavetoCSV) or
      (RandomSampling <> TempRecord.RandomSampling);

End;

Procedure TUSetupForm.Edit_USetup;
Var MemStream: TMemoryStream;
    Loop: Integer;
    PATS: TAQUATOXSegment;
Begin
  Changed      := False;
  DistChanged  := False;
  OVChanged    := False;
  TempRecord   := OrigRecord^;

  SegBox.Visible := False;
  If ALL_Segs then
    Begin
      MemStream:=TMemoryStream.Create;
      SetLength(TempDists,LAQTS.SegmentColl.Count+1);

      SegBox.Visible := True;
      SegBox.Items.Clear;
      SegBox.Items.Add('** All Segments **');

      For Loop := -1 to LAQTS.SegmentColl.Count - 1 do
        Begin
          If loop=-1 then PATS := LAQTS.TemplateSeg
                     else PATS := LAQTS.SegmentColl.At(Loop);

          If (Loop>-1) and (PATS.SV.Location.SiteType<>TribInput) then
            Begin
              SegBox.Items.Add('['+ PATS.SegNumber + ']: '+PATS.StudyName);
              ListBoxIDs[SegBox.Items.Count-1] := PATS.SegNumber;
            End;
          MemStream.Clear;
          PATS.SV.Distributions.Store(True,TStream(MemStream));
          StoreCollectionitems(True, TStream(MemStream),PATS.SV.Distributions);
          MemStream.Seek(0, soFromBeginning); {Go to beginning of stream}
          TempDists[Loop+1] := TDistributionList.Load(True,TStream(MemStream),3.2);
          TempDists[Loop+1].Duplicates:=True;
          LoadCollectionitems(True, Tstream(MemStream),TempDists[Loop+1],False,3.2);
        End;
      SegBox.ItemIndex := 0;
      TDIndex := 0;
      MemStream.Destroy;  {Finished copy}
    End
   else
     Begin
       MemStream:=TMemoryStream.Create;
       SetLength(TempDists,1);
       TDIndex := 0;
       SV.Distributions.Store(True,TStream(MemStream));
       StoreCollectionitems(True, TStream(MemStream),SV.Distributions);
       MemStream.Seek(0, soFromBeginning); {Go to beginning of stream}
       TempDists[0] := TDistributionList.Load(True,TStream(MemStream),3.2);
       TempDists[0].Duplicates:=True;
       LoadCollectionitems(True, Tstream(MemStream),TempDists[0],False,3.2);
       MemStream.Destroy;  {Finished copy}
     End;


  UpdateScreen;
  UpdateGrid;

  If ShowModal<>MrCancel then Begin {OK}
                                Changed := HasChanged;
                                OrigRecord^:=TempRecord;
                                If ALL_Segs
                                  then For Loop := -1 to LAQTS.SegmentColl.Count - 1 do
                                         Begin
                                           If loop=-1 then PATS := LAQTS.TemplateSeg
                                                      else PATS := LAQTS.SegmentColl.At(Loop);
                                           PATS.SV.Distributions.Free;
                                           PATS.SV.Distributions := TempDists[Loop+1]
                                         End
                                  else Begin
                                         SV.Distributions.Free;
                                         SV.Distributions := TempDists[0];
                                       End;
                              End
                         else Begin
                                For Loop:=0 to Length(TempDists)-1 do
                                  TempDists[Loop].Free;
                                Changed:=False;
                              End;

   TempDists := nil;
End;

procedure TUSetupForm.ConvInt(Sender: TObject);

Var Conv: Double;
  Result: Integer;

begin
    Val(Trim(TEdit(Sender).Text),Conv,Result);
    If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else begin
                        Conv:=Abs(Conv);
                        case TEdit(Sender).Name[1] of
                           'N': Begin
                                  TempRecord.NumSteps:=Trunc(Conv);
                                  If TempRecord.NumSteps = 0 then TempRecord.NumSteps := 1;
                                End;
                           'R': Begin
                                  TempRecord.RandomSeed:=Trunc(Conv);
                                  If TempRecord.RandomSeed = 0 then TempRecord.RandomSeed := 1;
                                End;
                           'P': TempRecord.NominalPercent := Conv; 
                         end; {case}
                       end;
    UpdateScreen;
end;


procedure TUSetupForm.OKBtnClick(Sender: TObject);
begin
   OKBtn.SetFocus;

   If Not HasChanged then ModalResult:=MROK else
   if MessageDlg('Save Changes to Uncertainty / Sensitivity Setup?',mtConfirmation,[mbOK,MbCancel],0)
    = MrOK then ModalResult:=MrOK;
end;

procedure TUSetupForm.RandomSampleBoxMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TempRecord.RandomSampling := RandomSampleBox.Checked;
  UpdateScreen;
end;

procedure TUSetupForm.SaveEachIterationMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TempRecord.SavetoCSV := SaveEachIteration.Checked;
  UpdateScreen;
end;

procedure TUSetupForm.SegBoxChange(Sender: TObject);
begin
  TDIndex := SegBox.ItemIndex;
  UpdateScreen;
  UpdateGrid;
end;

procedure TUSetupForm.CancelBtnClick(Sender: TObject);
begin
  If Not HasChanged  then ModalResult:=MRCancel
  else if MessageDlg('Cancel Changes to Uncertainty / Sensitivity Setup?',mtConfirmation,[mbOK,MbCancel],0)
            = MrOK then ModalResult:=MrCancel;

end;

procedure TUSetupForm.UseSeedBoxMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TempRecord.UseSeed:=UseSeedBox.Checked;
  UpdateScreen;
end;

procedure TUSetupForm.HelpButtonClick(Sender: TObject);
begin
   HTMLHelpContext('Topic34.htm');
end;

procedure TUSetupForm.FormCreate(Sender: TObject);
begin
   inherited;
   TreeView1.Images := ImageList1;
   IterCap.Caption := '';
end;

procedure TUSetupForm.TreeView1DblClick(Sender: TObject);
Var j, i,DistribIndex,FindIndex,TopIndex: Integer;
    PD: TDistribution;
    NewNode, ClickedNode: TTreeNode;
    FindName, ClickName: String;
    OldCursor: TCursor;
    TTN : TTreeNode;

    Procedure ParseFindName;
    Var SegID: String;
        CheckIndex: Integer;
    Begin
      If FindName[1] <>'[' then exit; 
      SegID := AbbrString(FindName,']');
      For CheckIndex := 1 to LAQTS.SegmentColl.Count do
        If SegID = '['+ TAQUATOXSegment(LAQTS.SegmentColl.At(CheckIndex-1)).SegNumber then
          Begin
            FindIndex := CheckIndex;
            Break;
          End;
      Delete(FindName,1,Length(SegID)+2)
    End;


begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  Treeview1.Items.BeginUpdate;

   For j:= Treeview1.Items.Count-1 downto 0 do {5-17-09}
    If Treeview1.Items[j].Selected then
     Begin
        ClickedNode := Treeview1.Items[j];

        If ClickedNode.Count>0 then Continue; {titles don't affect results}
        If (ClickedNode.Text = 'Selected Distributions for Uncertainty Run') or
           (ClickedNode.Text = 'Selected Parameters for Nominal Sensitivity Test') then Continue;

        ClickName := ClickedNode.Text;
        i := Pos(':    (',ClickName);
          If i>0 then Delete(ClickName,i,Length(ClickName)-i+1);

        FindName := ClickName;
        FindIndex := TDIndex;
        If ALL_Segs then ParseFindName;

        DistribIndex:=-1;
        With TempDists[FindIndex] do For i:=0 to count-1 do
            If (FindName=TDistribution(TempDists[FindIndex].At(i)).Name) then DistribIndex:=i;
        If DistribIndex=-1 then
          Begin
            MessageDlg('No Relevant Distributions for "'+FindName+'"',mtinformation,[mbok],0);
            Continue;
          End;

        PD:=TempDists[FindIndex].At(DistribIndex);

        If UncertButt.Checked
          then
            Begin
              DistributionForm.Distribs := TempDists[FindIndex];
              DistributionForm.ChangeUData(PD.DistNum,PD.SVID,PD.ToxRec);
              If DistributionForm.Changed then DistChanged:=True;
            End
          else Begin
                 PD.UseforSens := not PD.UseforSens;
                 DistChanged := True;
               End;

        UpdateDistName(ClickedNode,PD,FindIndex);

      TTN := Treeview1.Items[0];
        For i:=0 to Treeview1.Items.Count-1 do      {TTreeView is Very Slow.  This needs optimization.}
         Begin
           UpdateNodes(Treeview1.Items[i],ClickName,PD,FindIndex);
           TTN := TTN.GetNext;
         End; 

     End;   {for j multi-selection loop}

  UsedNode.DeleteChildren;
  If ALL_Segs then TopIndex := LAQTS.SegmentColl.Count else TopIndex := 0;
  For FindIndex := 0 to TopIndex do
  With TempDists[FindIndex] do For i:=0 to count-1 do
   With TDistribution(At(i)) do
    If (UncertButt.Checked and UseDist) or (SensButt.Checked and UseForSens) then
      Begin
         NewNode := Treeview1.Items.AddChild(UsedNode,Name);
         UpdateDistName(NewNode,at(i),FindIndex);
      End;

   If SensButt.Checked then
     IterCap.Caption := IntToStr(Self.UsedNode.Count)+' Parameters set to be tested or '+
                        IntToStr(Self.UsedNode.Count*2)+' iterations.'
                       else IterCap.Caption := '';

  Screen.Cursor := OldCursor;
  Treeview1.Items.EndUpdate;
  UpdateScreen;
end;


procedure TUSetupForm.TreeView1KeyPress(Sender: TObject; var Key: Char);
begin
   If Key = #13 then Begin Key := #0; TreeView1DblClick(Sender); End;
   If Key = ' ' then Begin Key := #0; TreeView1DblClick(Sender); End;
end;

procedure TUSetupForm.FormShow(Sender: TObject);
begin
  Windowstate := wsMaximized;
end;

procedure TUSetupForm.UncertButtClick(Sender: TObject);
Var UpGrid: Boolean;
begin
  UpGrid := (not (TempRecord.Run_Uncertainty) and UncertButt.Checked) or
            (not (TempRecord.Run_Sensitivity) and SensButt.Checked);
  TempRecord.Run_Uncertainty:=UncertButt.Checked;
  TempRecord.Run_Sensitivity:=SensButt.Checked;
  UpdateScreen;
  If DetermButt.Checked or UpGrid then UpdateGrid;

end;

procedure TUSetupForm.TrackOutButtonClick(Sender: TObject);
Var TrackResults, TempResults:  ResultsType;
    VLoop: VerticalSegments;
    ResultsSV: TStates;
    TestStr: String;

    Procedure SetupGraphChoice;
    Var I,J: Integer;
        PH: TResHeader;
    Begin
      Application.CreateForm(TGraphChoiceDlg, GraphChoiceDlg);
      GraphChoiceDlg.Caption := 'AQUATOX-- Select Output Results to Track';
      GraphChoiceDlg.DstLabel.Caption := 'Results to Track:';
      GraphChoiceDlg.GenScnButton.Visible := False;
      {Clear the graphing choice dialog}
      GraphChoiceDlg.SourceList.Clear;
      GraphChoiceDlg.DstList.Clear;

      For I := 0 to TrackResults[Epilimnion].Headers.Count-1 do
        Begin
          PH := TrackResults[Epilimnion].Headers.At(I);

          For J := 1 to TempRecord.NumSens do
            If TempRecord.SensTrack[J] = PH.SortIndex then
                GraphChoiceDlg.DstList.Items.Add(PH.ListStr(False));

          GraphChoiceDlg.MasterList.Add(PH.ListStr(False));
        End;

      If GraphChoiceDlg.ShowModal = MRCancel then exit;

      OVChanged := True;

      TempRecord.NumSens := 0;
      With TempRecord do with GraphChoiceDlg do
       For i := 0 to TrackResults[Epilimnion].Headers.Count-1 do
        Begin
          PH := TrackResults[Epilimnion].Headers.At(I);
          TestStr := PH.ListStr(False);
          For J := 0 to DstList.Items.Count-1 do
            If DstList.Items[j] = TestStr then
              Begin
                Inc(NumSens);
                If NumSens > MAX_SENS_OUTPUTS  then
                  Begin
                    NumSens := MAX_SENS_OUTPUTS;
                    Messagedlg('Only '+IntToStr(MAX_SENS_OUTPUTS)+' output variables may be tracked',mtinformation,[mbok],0);
                    GraphChoiceDlg.Free;
                    Exit;
                  End;
                SensTrack[NumSens] := PH.SortIndex;
              End;
        End;

      GraphChoiceDlg.Free;

    End;

begin
  If not All_Segs then ResultsSV := SV
                  else ResultsSV := AQTS.SV;  //LAQTS.SegmentColl.At(0);  Fix JSC 7/18/2012

  TRY
    TempResults := ResultsSV.Results;
    For VLoop:=Epilimnion to Hypolimnion do
      ResultsSV.Results[Vloop]:=TResultsCollection.Init;

    With ResultsSV do
      Begin
        AQTS.AllSVs := ResultsSV;

        If ALL_Segs
          then
            Begin
              ResultsSV.PAllSVsColl := @AQTS.AllSVs;
              AQTS.OtherFBSegs := TCollection.Init(1,1);
              ResultsSV.In_FB_Links := TCollection.Init(2,2);
              ResultsSV.Out_FB_Links := TCollection.Init(2,2);
              ResultsSV.In_Cs_Links := TCollection.Init(2,2);
              ResultsSV.Out_Cs_Links := TCollection.Init(2,2);
            End;

        If not AQTS.SetupforRun then exit;
        Zero_Utility_Variables;

        AQTS.SV := ResultsSV;
        ResultsSV.PAllSVsColl := @(AQTS.AllSVs);

        SetMemLocRec;                   {Set up array of pointers to memory}
        SetStateToInitConds(true);      {Set up State Variables}

        ChangeData;
        NormDiff(-1);
        ClearMBData(0);
        CalcHRadius(False);

        If EstuarySegment then ResultsSV.Check_Stratification;

        {Write Initial Conditions as the first data Point}
        If ALL_Segs
          then
            Begin
              ResultsSV.CascadeRunning := True;
              AQTS.Derivs(ResultsSV.SetupRec.FirstDay,1);  {write rates output}
              WriteResults(ResultsSV.SetupRec.FirstDay,1,False,1);
            End
          else
            Begin
              AQTS.Derivs(AQTS.SV.SetupRec.FirstDay,1);  {write rates output}
              WriteResults(AQTS.SV.SetupRec.FirstDay,1,False,1);
            End
      End;

  EXCEPT
     ResultsSV.Results := TempResults;
     MessageDlg('Simulation Error Encountered While Gathering List of Output Variables.  (A valid simulation must be used)',mterror,[mbok],0);
     Raise;
  END;

  TrackResults := ResultsSV.Results;
  ResultsSV.Results := TempResults;

  SetupGraphChoice;
  UpdateScreen;
  {}
end;

procedure TUSetupForm.LinkPPMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  TempRecord.LinkPeriPhyto:=LinkPP.Checked;
  UpdateScreen;
end;

procedure TUSetupForm.CorrelationButtonClick(Sender: TObject);
Begin
  If UsedNode.Count < 2 then
    Begin
       MessageDlg('You must have set up an uncertainty analysis with at least two distributions'+
       ' for correlations to be relevant.', mterror,[mbok],0);
       exit;
    End;

  TempDists[TDIndex].updatecorrelations;
  Application.CreateForm(TCorrelateForm,CorrelateForm);
  Application.CreateForm(TEditCorrForm,EditCorrForm);

  CorrelateForm.PUncertainty := @TempRecord;

  CorrelateForm.CorrelateSetup(TempDists[TDIndex]);
  If CorrelateForm.Changed then DistChanged := true;
  
  EditCorrForm.Free;
  CorrelateForm.Free;

  UpdateScreen;
end;

end.

