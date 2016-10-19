//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
Unit SedLayers;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, AQUAOBJ, AQStudy, Global, Db, DBTables,
  DBCtrls, Grids, DBGrids, Loadings, hh;

Type
  TEditSedForm = class(TForm)
    NumLayersLabel: TLabel;
    OKBtn: TBitBtn;
    MainPanel: TPanel;
    ElementBox: TComboBox;
    LayerBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    AddSedLayerButton: TButton;
    RemoveSedLayerButton: TButton;
    Unit1: TLabel;
    NPSUnit2: TLabel;
    UseDynamScourButt: TRadioButton;
    UseConstScourButt: TRadioButton;
    ConstScourEdit: TEdit;
    ScourGrid: TDBGrid;
    ScourNav: TDBNavigator;
    ScourImportButt: TButton;
    Bevel1: TBevel;
    Unit2: TLabel;
    ScourLabel: TLabel;
    ScourTable: TTable;
    DataSource: TDataSource;
    DetrHide: TPanel;
    Bevel2: TBevel;
    Unit4: TLabel;
    DepLabel: TLabel;
    DepGrid: TDBGrid;
    DepNav: TDBNavigator;
    DepImportButt: TButton;
    DepTable: TTable;
    DataSource1: TDataSource;
    Panel1: TPanel;
    UseConstDepButton: TRadioButton;
    DConstDepEdit: TEdit;
    Unit3: TLabel;
    UseDynamDepButton: TRadioButton;
    LayerParms: TPanel;
    Bevel3: TBevel;
    Label5: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Panel2: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    UEdit: TEdit;
    DepthEdit: TEdit;
    Label28: TLabel;
    MaxEdit: TEdit;
    CohesivePanel: TPanel;
    ScourDepButt: TRadioButton;
    VelocityButt: TRadioButton;
    Label19: TLabel;
    Label11: TLabel;
    NMinEdit: TEdit;
    Label12: TLabel;
    VEdit: TEdit;
    WEdit: TEdit;
    YEdit: TEdit;
    ZEdit: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    YLabel: TLabel;
    ZLabel: TLabel;
    InitCondPanel: TPanel;
    ToxEdit: TEdit;
    ToxBox: TComboBox;
    Label3: TLabel;
    ICEdit: TEdit;
    InitCondLabel: TLabel;
    IC_Unit: TLabel;
    TUnit: TLabel;
    Label16: TLabel;
    UpdateCalc: TButton;
    CalcPoros: TLabel;
    Label20: TLabel;
    CalcDens: TLabel;
    MessagePanel: TPanel;
    Msg1: TLabel;
    Msg2: TLabel;
    HardBottomPanel: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    Label23: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    DynStratLabel: TLabel;
    DBGrid1: TDBGrid;
    FFusionImportButt: TButton;
    DBNavigator1: TDBNavigator;
    DiffTable: TTable;
    DataSource2: TDataSource;
    SedNonReactLabel: TLabel;
    HideRightLoad: TPanel;
    HideICPanel: TPanel;
    UseSSCBox: TCheckBox;
    UseSSCPanel: TPanel;
    Label21: TLabel;
    HelpButton: TButton;
    procedure AddSedLayerButtonClick(Sender: TObject);
    procedure RemoveSedLayerButtonClick(Sender: TObject);
    procedure ElementBoxChange(Sender: TObject);
    procedure ICEditExit(Sender: TObject);
    procedure ImportButtClick(Sender: TObject);
    procedure UseConstScourButtClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure UseConstDepButtonClick(Sender: TObject);
    procedure DepthEditExit(Sender: TObject);
    procedure VelocityButtClick(Sender: TObject);
    procedure UpdateCalcClick(Sender: TObject);
    procedure UseSSCBoxClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    CurrentStudy: TAQUATOXSegment;
    Procedure UpdateTable;
    Procedure SaveTable;
    Procedure EditSedLayers;
    Procedure ResetScreen;
    Procedure UpdateScreen;
  end;

Type SedLoadType =(TBedLoad,TScour,TDeposition);
Var
  EditSedForm: TEditSedForm;
  NSItems: Array[0..10] of AllVariables;
  ToxItems  : Array[0..25] of T_SVType;
  ThisNS:  AllVariables;
  ThisTox: T_SVType;
  ThisLyr: T_SVLayer;
  VelButtCheck: Boolean; 

implementation

uses Imp_Load, Convert, edstatev;

{$R *.DFM}

Procedure TEditSedForm.EditSedLayers;
Begin
  ResetScreen;
  ShowModal;
End;

Procedure TEditSedForm.ResetScreen;
Var SV: TStates;
    Loop, ElementIndex, ToxIndex: Integer;
    ToxLoop: T_SVType;
    SVLoop: AllVariables;
Begin
  SV := CurrentStudy.SV;

  LayerBox.Items.Clear;
  For Loop := 1 to SV.SedLayers do
    LayerBox.Items.Add('Layer '+IntToStr(Loop));

  ElementIndex := 0;
  ElementBox.Items.Clear;
  ElementBox.Items.Add('Sed Layer Data');
  NSItems[ElementIndex] := NullStateVar;
  Inc(ElementIndex);
  For SVLoop := PoreWater to SedmLabDetr do
    If ((SVLoop in [Sand..SedmLabDetr]) and (SV.GetStatePointer(SVLoop,StV,WaterCol) <> nil)
        or (SVLoop in [PoreWater..LaDOMPore]) and (SV.GetStatePointer(SVLoop,StV,SedLayer1) <> nil))
      then
       Begin
         ElementBox.Items.Add(OutputText(SVLoop,StV,WaterCol,'',false,false,0));
         NSItems[ElementIndex] := SVLoop;
         Inc(ElementIndex);
       End;

  ToxIndex := 0;
  ToxBox.Items.Clear;
  For ToxLoop := FirstToxTyp to LastToxTyp do
    If SV.GetStatePointer(PoreWater,ToxLoop,SedLayer1) <> nil
      then
       Begin
         ToxBox.Items.Add(SV.ChemPtrs^[ToxLoop].ChemRec.ChemName);
         ToxItems[ToxIndex] := ToxLoop;

         Inc(ToxIndex);
       End;

  ElementBox.ItemIndex := 0;
  LayerBox.ItemIndex := 0;
  ToxBox.ItemIndex := 0;

  UpdateTable;
End;

Procedure TEditSedForm.UpdateScreen;
Var  PS,PTox: TStateVariable;
     PBS : TBottomSediment;
     UnitStr: String;
     LayerInt: Integer;
     SLoad,DLoad: LoadingsRecord;
     SNR: Boolean;
Begin
  SNR := CurrentStudy.SV.SedNonReactive;

  DynStratLabel.Visible := not CurrentStudy.SV.LinkedMode;
  NumLayersLabel.Caption := '(Sediment Layers Modeled:  '+IntToStr(CurrentStudy.SV.SedLayers)+')';

  ThisNS := NSItems[ElementBox.ItemIndex];
  ThisLyr := T_SVLayer(LayerBox.ItemIndex+1);
  If ToxBox.ItemIndex=-1 then ThisTox := StV
                         else ThisTox := ToxItems[ToxBox.ItemIndex];
  VelButtCheck := VelocityButt.Checked;

  LayerParms.Visible := (ThisNS = NullStateVar);
  If (LayerParms.Visible) or (ThisNS=PoreWater) then UpdateCalcClick(nil);
  ICEdit.ReadOnly := (ThisNS=PoreWater);

  UseSSCPanel.Visible := (ThisLyr=SedLayer1) and (ThisNS in [Cohesives,NonCohesives,NonCohesives2]) and (Not SNR);
  CohesivePanel.Visible := (ThisLyr=SedLayer1) and (ThisNS=Cohesives) and (Not SNR);
  InitCondPanel.Enabled := Not LayerParms.Visible;

  MessagePanel.Visible := False;
  If (ThisLyr = SedLayer1) and (ThisNS in [sedmrefrdetr..sedmlabdetr]) then
    Begin
      MessagePanel.Visible := True;
      Msg1.Caption := 'This state variable can also be found in the state variable list,';
      Msg2.Caption := 'represented as "'+StateText(ThisNS,StV,WaterCol)+'"';
      ThisLyr := WaterCol;
    End;

  If (ThisNs=PoreWater) and (Not SNR) then
    Begin
      MessagePanel.Visible := True;
      Msg1.Caption := 'The Initial Condition for pore water is not editable.  It is autocalculated';
      Msg2.Caption := 'using sediment densities, initial conditions, and the layer''s thickness.';
    End;

  DetrHide.Visible := (SNR and not (ThisNS in [sedmrefrdetr..sedmlabdetr,porewater])) or
                      ((not SNR) and (Not ((ThisLyr = SedLayer1) and (ThisNS in [Cohesives..NonCohesives2]))));
  If not DetrHide.Visible
    then
      Begin
        InitCondPanel.Top := 88;
        InitCondPanel.Left := 20;
      End
    else
      Begin
        InitCondPanel.Top := 140;
        InitCondPanel.Left := 292;
      End;

  ConstScourEdit.Enabled := not DetrHide.Visible;
  DConstDepEdit.Enabled  := not DetrHide.Visible;

  PS := CurrentStudy.SV.GetStatePointer(ThisNs,StV,ThisLyr);
  PBS := TBottomSediment(PS);
  If (ThisTox=StV) then PTox := nil
                   else PTox := CurrentStudy.SV.GetStatePointer(ThisNs,ThisTox,ThisLyr);

  If PS<>nil then
    Begin

      ICEdit.Text     := FloatToStrF(PS.InitialCond,ffGeneral,5,4);

      IC_Unit.Caption := PS.StateUnit;
      ToxEdit.Enabled := PTox<>nil;
      TUnit.Enabled   := PTox<>nil;
      ToxBox.Enabled  := PTox<>nil;
      If PTox<>nil then
        Begin
          ToxEdit.Text  := FloatToStrF(PTox.InitialCond,ffGeneral,5,4);
          TUnit.Caption := PTox.StateUnit;
        End;

      If ((ThisLyr = SedLayer1) and (ThisNS in [Cohesives..NonCohesives2])) and (Not SNR) then
        Begin
          UseSSCBox.Checked := CurrentStudy.SV.UseSSC;
          DetrHide.Visible := UseSSCBox.Checked;

          If (CohesivePanel.Visible) and (VelocityButt.Checked)
            then
              Begin
                ScourLabel.Caption := 'Erosion Velocity of '+ElementBox.Text;
                DepLabel.Caption   := 'Deposition Velocity of '+ElementBox.Text;
                UnitStr := 'm / d';
                SLoad := TBottomCohesives(PBS).LErodVel;
                DLoad := TBottomCohesives(PBS).LDepVel;
              End
            else
              Begin
                ScourLabel.Caption := 'Daily Scour of '+ElementBox.Text;
                DepLabel.Caption   := 'Daily Deposition of '+ElementBox.Text;
                UnitStr := 'g / d';
                SLoad := PBS.LScour;
                DLoad := PBS.LDeposition;
              End;

          UseConstScourButt.Checked := SLoad.UseConstant;
          UseDynamScourButt.Checked := not SLoad.UseConstant;

          UseConstDepButton.Checked := DLoad.UseConstant;
          UseDynamDepButton.Checked := not DLoad.UseConstant;

          ConstScourEdit.Text := FloatToStrF(SLoad.ConstLoad,ffGeneral,5,4);
          DConstDepEdit.Text := FloatToStrF(DLoad.ConstLoad,ffGeneral,5,4);

          Unit1.Caption  := UnitStr;
          Unit2.Caption  := UnitStr;
          Unit3.Caption  := UnitStr;
          Unit4.Caption  := UnitStr;
        End;
    End;

  LayerInt := LayerBox.ItemIndex+1;
  With CurrentStudy.SV.SedData[LayerInt] do
    Begin
      DepthEdit.Text  := FloatToStrF(BedDepthIC,ffGeneral,5,4);
    End;

{  SedTEdit.Text := FloatToStrF(CurrentStudy.SV.SedTimeStep,ffGeneral,5,4); }
  With CurrentStudy.SV do
    Begin
      MaxEdit.Text := FloatToStrF(MaxUpperThick,ffGeneral,5,4);
      NMinEdit.Text := FloatToStrF(BioTurbThick,ffGeneral,5,4);
      UEdit.Text := FloatToStrF(Densities[Cohesives],ffGeneral,5,4);
      VEdit.Text := FloatToStrF(Densities[NonCohesives],ffGeneral,5,4);
      WEdit.Text := FloatToStrF(Densities[NonCohesives2],ffGeneral,5,4);
      YEdit.Text := FloatToStrF(Densities[SedmRefrDetr],ffGeneral,5,4);
      ZEdit.Text := FloatToStrF(Densities[SedmLabDetr],ffGeneral,5,4);
    End;

  HideRightLoad.Visible := SNR and (ThisNS=Porewater);
  If SNR and (ThisNS in [sedmRefrdetr..sedmlabdetr,porewater])
    then
      Begin
        HideICPanel.Visible := True;
        If ToxBox.Items.Count=0
          then ScourLabel.Caption := 'No Toxicants in Simulation'
          else ScourLabel.Caption := 'Exposure to '+Toxbox.Items[ToxBox.ItemIndex];


        ScourGrid.Enabled := ToxBox.Items.Count>0;
        If not ScourGrid.Enabled then ScourGrid.Color := ClGray
                                 else ScourGrid.Color := ClWhite;

        ScourNav.Enabled := ToxBox.Items.Count>0;
        ScourImportButt.Enabled := ToxBox.Items.Count>0;

        If ThisNS = porewater then Unit2.Caption := 'ug/L'
                              else Unit2.Caption := 'ug/g oc';

        UseConstScourButt.Visible := False;
        ConstScourEdit.Visible := False;
        Unit1.Visible := False;
        UseDynamScourButt.Visible := False;
        ScourGrid.Top := 107;
        ScourGrid.Height := 245;
        ScourNav.Top := 354;
        ScourImportButt.Top := 354;
        Bevel1.Height := 334;
      End
    else
      Begin
        HideICPanel.Visible := False;
        UseConstScourButt.Visible := True;
        ConstScourEdit.Visible := True;
        Unit1.Visible := True;
        UseDynamScourButt.Visible := True;
        ScourGrid.Top := 187;
        ScourGrid.Height := 205;
        ScourNav.Top := 394;
        ScourImportButt.Top := 394;
        Bevel1.Height := 374;
        ScourImportButt.Enabled := True;

      End;

  YEdit.Enabled  := True;
  YLabel.Enabled := True;
  ZEdit.Enabled  := True;
  ZLabel.Enabled := True;

  SedNonReactLabel.Visible := SNR;
  AddSedLayerbutton.Enabled := not SNR;
  RemoveSedLayerbutton.Enabled := not SNR;
  Panel2.Enabled := not SNR;
  DBGrid1.Enabled := not SNR;
  If SNR then DBGrid1.Color := CLGray
         else DBGrid1.Color := CLWhite;
  FFusionImportButt.Enabled := not SNR;
  dbnavigator1.Enabled := not SNR;

  DepthEdit.Enabled := not SNR;

  If SNR then Label7.Caption := '(PARAMETERS IRRELEVANT: NON REACTIVE)'
         else Label7.Caption := 'Global to this Segment:';

  ICEdit.Enabled := (not SNR) or (ThisNS in [sedmRefrdetr..sedmlabdetr]);
  HideRightLoad.Visible := (SNR) and (ThisNS in [sedmrefrdetr..sedmlabdetr,porewater]);

  Update;
End;


Procedure TEditSedForm.AddSedLayerButtonClick(Sender: TObject);
Var i: Integer;
    IsTempl: Boolean;
    WorkingStudy: TAQUATOXSegment;
Begin
  SaveTable;

  If CurrentStudy.SV.SedLayers >= Num_SVLayers
    Then Begin
           MessageDlg('This version of AQUATOX, cannot exceed '+IntToStr(Num_SVLayers)+' sediment layers.',
                       MTInformation, [MBOK],0);
           Exit;
         End;

  If (MessageDlg('Add a buried sediment layer? (below existing layers)',
                  MTConfirmation, [MbYes,MbCancel], 0) = MrCancel) then exit;

  If Not CurrentStudy.SV.LinkedMode
    then CurrentStudy.Add_Sediment_Layer
    else
      For i := -1 to CurrentStudy.AllOtherSegs.Count-1 do
       Begin
         IsTempl := (i=-1);
         If IsTempl then WorkingStudy := CurrentStudy.TemplateSeg
                    else WorkingStudy := CurrentStudy.AllOtherSegs.At(i);
         WorkingStudy.Add_Sediment_Layer;
       End;

   CurrentStudy.SV.Update_Distributions;
   ResetScreen;
End;

Procedure TEditSedForm.RemoveSedLayerButtonClick(Sender: TObject);
Var i: Integer;
    IsTempl: Boolean;
    WorkingStudy: TAQUATOXSegment;
Begin
  SaveTable;

  If CurrentStudy.SV.SedLayers <= 1
    Then Begin
           MessageDlg('You cannot remove the active layer without removing the entire Sediment Bed Model.',
                       MTInformation, [MBOK],0);
           Exit;
         End;

  If (MessageDlg('Remove the lowest buried sediment layer?',
                  MTConfirmation, [MbYes,MbCancel], 0) = MrCancel) then exit;

  If Not CurrentStudy.SV.LinkedMode
    then CurrentStudy.Remove_Sediment_Layer
    else
      For i := -1 to CurrentStudy.AllOtherSegs.Count-1 do
       Begin
         IsTempl := (i=-1);
         If IsTempl then WorkingStudy := CurrentStudy.TemplateSeg
                    else WorkingStudy := CurrentStudy.AllOtherSegs.At(i);
         WorkingStudy.Remove_Sediment_Layer;
       End;

   CurrentStudy.SV.Update_Distributions;
   ResetScreen;    {Update Screen}
End;


procedure TEditSedForm.UpdateTable;
Var TableIn  : TTable;
    PS, PTox: TStateVariable;
    PBS: TBottomSediment;
    PBC: TBottomCohesives;
    LayerInt: Integer;
    SNR: Boolean;

         Procedure PutInDbase(P: TLoad);
         {Used to put loadings data into TableIn}
         begin
            With TableIn do
               begin
                 Append;
                 Fields[0].AsDateTime:= P.Date;
                 Fields[1].AsFloat:=P.Loading;
                 Post;
               end;
         end;

         Var i: integer;
Begin
  SNR := CurrentStudy.SV.SedNonReactive;

  If ToxBox.ItemIndex=-1 then ThisTox := StV
                         else ThisTox := ToxItems[ToxBox.ItemIndex];

  ThisNS := NSItems[ElementBox.ItemIndex];
  ThisLyr := T_SVLayer(LayerBox.ItemIndex+1);
  If ToxBox.ItemIndex=-1 then ThisTox := StV
                         else ThisTox := ToxItems[ToxBox.ItemIndex];

  VelButtCheck := VelocityButt.Checked;

  If ThisNS=NullStateVar then
    Begin
      DiffTable.DatabaseName:=Program_Dir;
      DiffTable.Active:=False;
      DiffTable.EmptyTable;
      DiffTable.Active:=True;
      LayerInt := LayerBox.ItemIndex+1;

      {Load the Database Data into the Files}
      TableIn:=DiffTable;
      With TLoadings(CurrentStudy.SV.SedData[LayerInt].UpperDispCoeff) do
         For i:=0 to count-1 do
             PutInDbase(at(i));
    End;


  If ((not SNR) and ((ThisLyr > SedLayer1) or not (ThisNS in [Cohesives..NonCohesives2]))) or
     (SNR and not (ThisNS in [sedmrefrdetr..sedmlabdetr,porewater])) then
    Begin
      UpdateScreen;
      Exit;
    End;

  PS := CurrentStudy.SV.GetStatePointer(ThisNS,StV,ThisLyr);
  PBS := TBottomSediment(PS);

  ScourTable.DatabaseName:=Program_Dir;
  ScourTable.Active:=False;
  ScourTable.EmptyTable;
  ScourTable.Active:=True;

  DepTable.DatabaseName:=Program_Dir;
  DepTable.Active:=False;
  DepTable.EmptyTable;
  DepTable.Active:=True;

  If CurrentStudy.SV.SedNonReactive and (ThisTox<>StV) then
    Begin
      PTox := CurrentStudy.SV.GetStatePointer(ThisNs,ThisTox,ThisLyr);
      If ThisNS in [sedmrefrdetr..sedmlabdetr] then PTox := CurrentStudy.SV.GetStatePointer(ThisNs,ThisTox,WaterCol);
      TableIn:=ScourTable;
      With PTox.LoadsRec.Loadings do
        For i:=0 to count-1 do
          PutInDbase(at(i));
      UpdateScreen;
      Exit;
    End;

  If CurrentStudy.SV.SedNonReactive and (ThisTox=StV) then
     Begin
       UpdateScreen;
       exit;
     End;

  If (ThisNS = Cohesives) and
     (VelButtCheck) then
       Begin
        PBC := TBottomCohesives(PBS);
        {Load the Database Data into the Files}
        TableIn:=ScourTable;
        With PBC.LErodVel.Loadings do For i:=0 to count-1 do
                                      PutInDbase(at(i));
        TableIn:=DepTable;
        With PBC.LDepVel.Loadings do For i:=0 to count-1 do
                                      PutInDbase(at(i));
       End
    Else
      Begin
        {Load the Database Data into the Files}
        TableIn:=ScourTable;
        With PBS.LScour.Loadings do For i:=0 to count-1 do
                                      PutInDbase(at(i));
        TableIn:=DepTable;
        With PBS.LDeposition.Loadings do For i:=0 to count-1 do
                                      PutInDbase(at(i));
      End;

  Updatescreen;
End;

Procedure TEditSedForm.SaveTable;
Var PCS: TBottomCohesives;
    PTox: TStateVariable;
    LayerInt: Integer;
     SNR: Boolean;
Begin
  SNR := CurrentStudy.SV.SedNonReactive;
  LayerInt := ORD(ThisLyr);
  if ThisNS=NullStateVar then
      StateVarDialog.LoadingsFromTable(DiffTable,TLoadings(CurrentStudy.SV.SedData[LayerInt].UpperDispCoeff));

  If (SNR and not (ThisNS in [sedmrefrdetr..sedmlabdetr,porewater])) or
     ((not SNR) and (Not ((ThisLyr = SedLayer1) and (ThisNS in [Cohesives..NonCohesives2])))) then exit;

  PCS := CurrentStudy.SV.GetStatePointer(ThisNS,StV,ThisLyr);

  If CurrentStudy.SV.SedNonReactive
    then
      Begin
         If (ThisTox=StV) then PTox := nil
                          else PTox := CurrentStudy.SV.GetStatePointer(ThisNs,ThisTox,ThisLyr);
         If PTox=nil then exit;                 

         StateVarDialog.LoadingsFromTable(ScourTable,PTox.LoadsRec.Loadings);
         Exit;
      End;


  If (ThisNS = Cohesives) and
     (VelButtCheck)
     then
       Begin
         StateVarDialog.LoadingsFromTable(DepTable,PCS.LDepVel.Loadings);
         StateVarDialog.LoadingsFromTable(ScourTable,PCS.LErodVel.Loadings);
       End
     else
       Begin
         StateVarDialog.LoadingsFromTable(DepTable,PCS.LDeposition.Loadings);
         StateVarDialog.LoadingsFromTable(ScourTable,PCS.LScour.Loadings);
       End;
End;

procedure TEditSedForm.ElementBoxChange(Sender: TObject);
Begin
  UpdateCalcClick(nil);
  SaveTable;
  UpdateTable;
end;

procedure TEditSedForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Multi_Layer.htm');
end;

procedure TEditSedForm.ICEditExit(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update screen}
Var Conv   : Double;
    Result : Integer;
    PBS   : TBottomSediment;
    PCS   : TBottomCohesives;
Begin

  Val(Trim(TEdit(Sender).Text),Conv,Result);
  Conv:=Abs(Conv);
  If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
               else begin
                       case TEdit(Sender).Name[1] of
                            'I': Begin
                                   PBS := CurrentStudy.SV.GetStatePointer(ThisNs,StV,ThisLyr);
                                   PBS.InitialCond := Conv;
                                 End;
                            'T': Begin
                                   PBS := CurrentStudy.SV.GetStatePointer(ThisNs,ThisTox,ThisLyr);
                                   PBS.InitialCond := Conv;
                                 End;
                            'C': If (ThisNS=Cohesives) and VelocityButt.Checked
                                   then
                                     Begin
                                       PCS := CurrentStudy.SV.GetStatePointer(ThisNs,StV,ThisLyr);
                                       PCS.LErodVel.ConstLoad := Conv;
                                     End
                                   else
                                     Begin
                                       PBS := CurrentStudy.SV.GetStatePointer(ThisNs,StV,ThisLyr);
                                       PBS.LScour.ConstLoad := Conv;
                                     End;
                            'D': If (ThisNS=Cohesives) and VelocityButt.Checked
                                   then
                                     Begin
                                       PCS := CurrentStudy.SV.GetStatePointer(ThisNs,StV,ThisLyr);
                                       PCS.LDepVel.ConstLoad := Conv;
                                     End
                                   else
                                     Begin
                                       PBS := CurrentStudy.SV.GetStatePointer(ThisNs,StV,ThisLyr);
                                       PBS.LDeposition.ConstLoad := Conv;
                                     End;

                       End; {Case}
                    End;
  UpdateScreen;
End;

procedure TEditSedForm.ImportButtClick(Sender: TObject);
Var Nm: String;
    Table: TTable;
begin
  Case TButton(Sender).Name[1] of
    'D': Begin
           Table := DepTable;
           Nm := DepLabel.Caption+' ('+Unit2.Caption+')';
         End;
    'S': Begin
           Table := ScourTable;
           Nm := ScourLabel.Caption+' ('+Unit2.Caption+')';
         End;
    else Begin
           Table := DiffTable;
           Nm := 'Diff. Coeff (m2/d)';
         End;
  End; {Case}

  Table.Active:=False;
  ImportForm.ChangeLoading(Nm,Table,False,False,CTNone);
  Table.Active:=True;

  Update;
End;

procedure TEditSedForm.UseConstScourButtClick(Sender: TObject);
Var PBC: TBottomCohesives;
begin
  if CurrentStudy.SV.SedNonReactive then Exit;

  PBC := CurrentStudy.SV.GetStatePointer(ThisNs,StV,ThisLyr);

  If (ThisNS=Cohesives) and VelButtCheck
    then PBC.LErodVel.UseConstant := UseConstScourButt.Checked
    else PBC.LScour.UseConstant := UseConstScourButt.Checked;

  If UseConstScourButt.Checked
      then begin
             ConstScourEdit.Enabled:=True;
             ScourGrid.Enabled:=False;
             ScourGrid.Color:=ClGray;
             ScourNav.Enabled:=False;
           end
      else begin
             ConstScourEdit.Enabled:=False;
             ScourGrid.Enabled:=True;
             ScourGrid.Color:=ClWhite;
             ScourNav.Enabled:=True;
           end;
end;

procedure TEditSedForm.UseConstDepButtonClick(Sender: TObject);
Var PBC: TBottomCohesives;
begin
  PBC := CurrentStudy.SV.GetStatePointer(ThisNs,StV,ThisLyr);

  If (ThisNS=Cohesives) and VelButtCheck
    then PBC.LDepVel.UseConstant := UseConstDepButton.Checked
    else PBC.LDeposition.UseConstant := UseConstDepButton.Checked;

  If UseConstDepButton.Checked then begin
                                 DConstDepEdit.Enabled:=True;
                                 DepGrid.Enabled:=False;
                                 DepGrid.Color:=ClGray;
                                 DepNav.Enabled:=False;
                               end
                          else begin
                                 DConstDepEdit.Enabled:=False;
                                 DepGrid.Enabled:=True;
                                 DepGrid.Color:=ClWhite;
                                 DepNav.Enabled:=True;
                               end;
end;


procedure TEditSedForm.OKBtnClick(Sender: TObject);
begin
  UpdateCalcClick(nil);
  SaveTable;
end;


procedure TEditSedForm.DepthEditExit(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update screen}
Var Conv   : Double;
    Result : Integer;
    LayerInt: Integer;

Begin

LayerInt := LayerBox.ItemIndex+1;
With CurrentStudy.SV.SedData[LayerInt] do
  Begin

    Val(Trim(TEdit(Sender).Text),Conv,Result);
    Conv:=Abs(Conv);
    If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else begin
                         case TEdit(Sender).Name[1] of
                              'D': BedDepthIC := Conv;
                              'M': CurrentStudy.SV.MaxUpperThick := Conv;
                              'N': CurrentStudy.SV.BioTurbThick  := Conv;
                              'U': CurrentStudy.SV.Densities[Cohesives]  := Conv;
                              'V': CurrentStudy.SV.Densities[NonCohesives]  := Conv;
                              'W': CurrentStudy.SV.Densities[NonCohesives2] := Conv;
                              'Y': CurrentStudy.SV.Densities[SedmRefrDetr]  := Conv;
                              'Z': CurrentStudy.SV.Densities[SedmLabDetr]  := Conv;
                         End; {Case}
                      End;
    UpdateScreen;
  End; {With}
End;

procedure TEditSedForm.VelocityButtClick(Sender: TObject);
begin
  SaveTable;
  UpdateTable;
end;

procedure TEditSedForm.UpdateCalcClick(Sender: TObject);
Var LayerInt: Integer;
    SumSedMass : Double;
    PV: TVolume;
    CurrentLayer: T_SVLayer;
    SedVar: AllVariables;
    BedDens, SedDens, PoreWaterIC: Double;
    BedVolWithH2O,SurfArea : Double;
    ThisMass, SumVol, SumMass: Double;
    PPW: TPoreWater;
    BedVolNoWater, BedDepthNoWater: Double;
    ErrorFound: Boolean;

    Function GetSedVar: Double;
    {Returns State of SedVar in g/m2}
    Begin
      With CurrentStudy.SV do
      If (SedVar in [SedmRefrDetr..SedmLabDetr]) and (CurrentLayer=SedLayer1)
        then GetSedVar := GetState(SedVar,StV,WaterCol) * StaticZMean
                                    {g/m3}                      {g}
        else GetSedVar := GetState(SedVar,StV,CurrentLayer);
    End;                           {g/m2}


begin
  ErrorFound := False;
  LayerInt := LayerBox.ItemIndex+1;

  If CurrentStudy.SV.SedData[LayerInt].BedDepthIC<=0 then
    Begin
      HardBottomPanel.Visible := True;
      Exit;
    End;
  HardBottomPanel.Visible := False;

  Try
    With CurrentStudy.SV do
      Begin
        PV := GetStatePointer(Volume,StV,WaterCol);
        Volume_Last_Step := PV.InitialCond;

        Try
        SetStateToInitConds(false);
        Except
        End;

        CurrentLayer := T_SVLayer(LayerInt);

        SurfArea := Location.Locale.SurfArea;

        SumMass := 0; SumVol := 0;
        For SedVar := Cohesives to SedmLabDetr do  {Calculate Density with no water}
         If GetSedVar>0 then
           Begin
             ThisMass := GetSedVar * SurfArea;
             {g}          {g/m2}      {m2}
             SedDens := Densities[SedVar];
             If SedDens>0 then
               SumVol := SumVol + (ThisMass / (SedDens * 1.0E+06));
                {m3}      {m3}       {g}       {g/cm3}   {cm3/m3}
             SumMass := SuMMass + ThisMass;
               {g}        {g}       {g}
           End;

        If SumVol>0
          then BedDens := SumMass / SumVol  {Calculate bed density if there were no water}
                {g/m3}       {g}      {m3}
          else Begin
                 BedDens := 0;
                 ErrorFound := True;
               End;

        If Not ErrorFound then
          Begin
            SumSedMass := 0;
            For SedVar := Cohesives to SedmLabDetr do
              If GetSedVar>0 then
                  SumSedMass := SumSedMass + GetSedVar * SurfArea;
                    {g}           {g}          {g/m2}     {m2}

            BedVolNoWater    := SumSedMass / BedDens;
             {m3}                  {g}       {g/m3}
            BedDepthNoWater := BedVolNoWater / SurfArea;
             {m}                  {m3}           {m2}

            With SedData[Layerint] do
              Begin
                FracWater := 1 - BedDepthNoWater / BedDepthIC;

                BedVolWithH2O := (SurfArea * BedDepthIC);
                    {m3}            {m2}        {m}
                SumSedMass := SumSedMass +  FracWater * BedVolWithH2o * 1.0E+06;
                   {g}            {g}          {frac}     {m3}        {g/m3 H2O}
                SedData[Layerint].BedDensity := SumSedMass  / BedVolWithH2o;
                                   {g/m3}          {g}           {m3}
                If BedDepthNoWater > BedDepthIC
                  then CalcPoros.Caption := 'Error, thick too small'
                  else CalcPoros.Caption := FloatToStrF(FracWater,ffGeneral,5,4);
                CalcDens.Caption := FloatToStrF(BedDensity/1e6,ffGeneral,5,4)+' g/cm3' ;

                PoreWaterIC := (BedVolWithH2O-BedVolNoWater) / SurfArea;
                  {m3/m2}             {m3}                       {m2}
                PPW := GetStatePointer(PoreWater,StV,CurrentLayer);
                PPW.InitialCond := PoreWaterIC;

              End;
          End; {Not ErrorFound}
      End;
  Except
    CalcPoros.Caption := 'Uncalculable';
    CalcDens.Caption  := 'Uncalculable';
  End;

  If ErrorFound then
    Begin
      CalcPoros.Caption := 'Uncalculable';
      CalcDens.Caption  := 'Uncalculable';
    End;  


end;



procedure TEditSedForm.UseSSCBoxClick(Sender: TObject);
begin
  CurrentStudy.SV.UseSSC := UseSSCBox.Checked;
  UpdateScreen;
end;

end.

