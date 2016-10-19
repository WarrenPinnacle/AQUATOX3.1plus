//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit LinkEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, hh,
  StdCtrls, Grids, DBGrids, ExtCtrls, DBCtrls, Buttons, AQUAOBJ, Global,
  Db, DBTables, Loadings;

Type TempLink_Record= Record
     Name         : RefString;
     FromID, ToID : SegIDString;
     LinkType     : TLinkType;
     CharLength   : Double;
    End;

type
  TLinkForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ToggleButt: TButton;
    BedLoadPanel: TPanel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Import1: TButton;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Import2: TButton;
    DBNavigator2: TDBNavigator;
    DBGrid3: TDBGrid;
    DBNavigator3: TDBNavigator;
    Import3: TButton;
    Label12: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CascadeButton: TRadioButton;
    FeedbackButton: TRadioButton;
    NameEdit: TEdit;
    FromBox: TComboBox;
    ToBox: TComboBox;
    Panel2: TPanel;
    LengthLabel: TLabel;
    LengthEdit: TEdit;
    lengthunit: TLabel;
    ConvertLight1: TButton;
    flowpanel: TPanel;
    NPSUnit2: TLabel;
    Label7: TLabel;
    DiffusionLabel: TLabel;
    XSecLabel: TLabel;
    XSecUnit: TLabel;
    DiffusionUnit: TLabel;
    Label5: TLabel;
    WaterFlowImport: TButton;
    WaterFlowNav: TDBNavigator;
    WaterFlowGrid: TDBGrid;
    DiffusionGrid: TDBGrid;
    DiffusionImport: TButton;
    DiffusionNav: TDBNavigator;
    XSecGrid: TDBGrid;
    XSecNav: TDBNavigator;
    XSecImport: TButton;
    WaterFlowTable: TTable;
    WaterFlowDS: TDataSource;
    DiffusionTable: TTable;
    DiffusionDS: TDataSource;
    XSecTable: TTable;
    XSecDS: TDataSource;
    Table1: TTable;
    DataSource1: TDataSource;
    Table2: TTable;
    DataSource2: TDataSource;
    Table3: TTable;
    DataSource3: TDataSource;
    HelpButton: TButton;
    procedure CascadeButtonClick(Sender: TObject);
    procedure NameEditExit(Sender: TObject);
    procedure LengthExit(Sender: TObject);
    procedure FromBoxChange(Sender: TObject);
    procedure ToBoxChange(Sender: TObject);
    procedure WaterFlowImportClick(Sender: TObject);
    procedure DiffusionImportClick(Sender: TObject);
    procedure XSecImportClick(Sender: TObject);
    procedure ToggleButtClick(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure Import2Click(Sender: TObject);
    procedure Import3Click(Sender: TObject);
    procedure ConvertLight1Click(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
  private
    TheIDs: PListBoxIDs;
    TheLink: TSegmentLink;
    TempLink: TempLink_Record;     {Holds temp info about State Var so user can cancel if he/she wants to}
    Procedure CopyToTemp;
    Procedure CopyFromTemp;
    { Private declarations }
  public
    SedModelIncluded: Boolean;
    Function  EditLink(Var Incoming: TSegmentLink; PIDs: PListBoxIDs): Boolean;
    Procedure UpdateScreen;
    Procedure ChangeLoad(Var Tab: TTable; Name: String);

    { Public declarations }
  end;

var
  LinkForm: TLinkForm;
  ShowingBedLoad: Boolean;

implementation

uses Imp_Load, Convert;

Procedure TLinkForm.UpdateScreen;
Var Loop, Index: Integer;
    TempSt: String;
Begin


  BedLoadPanel.Visible := ShowingBedLoad;
  FlowPanel.Visible := not ShowingBedLoad;
  If ShowingBedLoad then ToggleButt.Caption := 'Edit Flow etc.'
                    else ToggleButt.Caption := 'Edit Bed Loads';

  NameEdit.Text := TempLink.Name;

  Index:=-1;
  For Loop:=0 to ToBox.Items.Count-1 do
    If TempLink.ToID = TheIDs^[Loop] then Index:=Loop;
  ToBox.ItemIndex := Index;

  Index:=-1;
  For Loop:=0 to FromBox.Items.Count-1 do
    If TempLink.FromID = TheIDs^[Loop] then Index:=Loop;
  FromBox.ItemIndex := Index;

  CascadeButton.Checked := (TempLink.LinkType=CascadeLnk);
  FeedbackButton.Checked := (TempLink.LinkType=FeedbackLnk);

  LengthLabel.Enabled     := FeedbackButton.Checked;
  LengthEdit.Enabled      := FeedbackButton.Checked;
  LengthUnit.Enabled      := FeedbackButton.Checked;
  DiffusionLabel.Enabled  := FeedbackButton.Checked;
  DiffusionUnit.Enabled   := FeedbackButton.Checked;
  DiffusionGrid.Enabled   := FeedbackButton.Checked;
  DiffusionNav.Enabled    := FeedbackButton.Checked;
  DiffusionImport.Enabled := FeedbackButton.Checked;
  XSecLabel.Enabled       := FeedbackButton.Checked;
  XSecUnit.Enabled        := FeedbackButton.Checked;
  XSecGrid.Enabled        := FeedbackButton.Checked;
  XSecNav.Enabled         := FeedbackButton.Checked;
  XSecImport.Enabled      := FeedbackButton.Checked;

  OKBtn.Enabled := Not ((ToBox.ItemIndex=-1) or (FromBox.ItemIndex=-1) or
                       (ToBox.ItemIndex=FromBox.ItemIndex));

  Str(TempLink.CharLength:6:3,TempSt);  LengthEdit.Text :=TempSt;
End;


Function TLinkForm.EditLink(Var Incoming: TSegmentLink; PIDs: PListBoxIDs): Boolean;
Begin
  TheIDs := PIDs;
  TheLink := Incoming;
  CopyToTemp;
    UpdateScreen;
  EditLink := False;

  ToggleButt.Enabled :=  SedModelIncluded;

  If ShowModal=MROK then
    Begin
      EditLink := True;
      CopyFromTemp;
    End;

   WaterFlowTable.Active:=False;
   DiffusionTable.Active:=False;
   XSecTable.Active := False;
   Table1.Active := False;
   Table2.Active := False;
   Table3.Active := False;
End;

Procedure TLinkForm.CopyToTemp;
Var TableIn: TTable;
    i: Integer;
         {-----------------------------------------------------}
         Procedure PutInDbase(P: TLoad; SciMode: Boolean);
         {Used to put loadings data into TableIn}
         begin
            With TableIn do
               begin
                 Append;
                 Fields[0].AsDateTime:= P.Date;
                 Fields[1].AsFloat:=P.Loading;
                 If SciMode then TFloatField(Fields[1]).DisplayFormat:='0.0000e-00';
                 Post;
               end;
         end;
         {-----------------------------------------------------}
Begin
  TempLink.Name := TheLink.Name;
  TempLink.FromID := TheLink.FromID;
  TempLink.ToID := TheLink.ToID;
  TempLink.LinkType := TheLink.LinkType;
  TempLink.CharLength := TheLink.CharLength;

  {Ready the Database Files for the Loadings Data}
  WaterFlowTable.DatabaseName:=Program_Dir;
  WaterFlowTable.Active:=False;
  WaterFlowTable.EmptyTable;
  WaterFlowTable.Active:=True;

  DiffusionTable.DatabaseName:=Program_Dir;
  DiffusionTable.Active:=False;
  DiffusionTable.EmptyTable;
  DiffusionTable.Active:=True;

  XSecTable.DatabaseName:=Program_Dir;
  XSecTable.Active:=False;
  XSecTable.EmptyTable;
  XSecTable.Active:=True;

  Table1.DatabaseName:=Program_Dir;
  Table1.Active:=False;
  Table1.EmptyTable;
  Table1.Active:=True;

  Table2.DatabaseName:=Program_Dir;
  Table2.Active:=False;
  Table2.EmptyTable;
  Table2.Active:=True;

  Table3.DatabaseName:=Program_Dir;
  Table3.Active:=False;
  Table3.EmptyTable;
  Table3.Active:=True;

  {Load the Database Data into the Files}
  TableIn:=WaterFlowTable;
     With TheLink.WaterFlowData do For i:=0 to count-1 do
                                PutInDbase(at(i),False);

  TableIn:=DiffusionTable;
     With TheLink.DiffusionData do For i:=0 to count-1 do
                                PutInDbase(at(i),False);

  TableIn:=XSecTable;
     With TheLink.XSectionData do For i:=0 to count-1 do
                                PutInDbase(at(i),False);

  TableIn:=Table1;
     With TheLink.Bedload[Cohesives] do For i:=0 to count-1 do
                                PutInDbase(at(i),True);

  TableIn:=Table2;
     With TheLink.Bedload[NonCohesives] do For i:=0 to count-1 do
                                PutInDbase(at(i),True);

  TableIn:=Table3;
     With TheLink.Bedload[NonCohesives2] do For i:=0 to count-1 do
                                PutInDbase(at(i),True);


  TFloatField(WaterFlowTable.Fields[1]).DisplayFormat:='0.0000e-00';
  TFloatField(WaterFlowTable.Fields[1]).DisplayWidth := 10;
  WaterFlowGrid.Columns.Items[1].Width := 90;

  DiffusionGrid.Columns.Items[1].Width := 90;

  TFloatField(XSecTable.Fields[1]).DisplayFormat:='0.0000e-00';
  TFloatField(XSecTable.Fields[1]).DisplayWidth := 10;
  XSecGrid.Columns.Items[1].Width := 90;

End;

procedure TLinkForm.ConvertLight1Click(Sender: TObject);
begin
  Application.CreateForm(TConvertForm,ConvertForm);
  ConvertForm.ConvertNumber(LengthEdit,CTDepth);
  ConvertForm.Free;
end;

Procedure TLinkForm.CopyFromTemp;
        {----------------------------------------------------------}
        Procedure LoadingsFromTable(Table: TTable; Var LColl: TLoadings);
        {Copies loadings data from the table to the Collection}
        Var loop,recnum: Integer;
            NewLoad:     TLoad;
        Begin
            If LColl<>nil then LColl.Destroy;
            With Table do begin
              First;
              RecNum:=RecordCount;
              LColl:=TLoadings.Init(20,100);
                 For loop:=1 to RecNum do
                      begin
                           NewLoad:= TLoad.Init(Fields[0].AsDateTime,Fields[1].AsFloat);
                           LColl.Insert(NewLoad);
                           Next;
                      end; {for do}
            end; {with}

        End; {LoadingsFromTable}
        {----------------------------------------------------------}
Begin
  TheLink.Name := TempLink.Name;
  TheLink.FromID := TempLink.FromID;
  TheLink.ToID := TempLink.ToID;
  TheLink.LinkType := TempLink.LinkType;
  TheLink.CharLength := TempLink.CharLength;

  {Copy the Database Data into the collections in memory}
  LoadingsFromTable(WaterFlowTable,TheLink.WaterFlowData);
  LoadingsFromTable(DiffusionTable,TheLink.DiffusionData);
  LoadingsFromTable(XSecTable,TheLink.XSectionData);
  LoadingsFromTable(Table1,TheLink.BedLoad[Cohesives]);
  LoadingsFromTable(Table2,TheLink.BedLoad[NonCohesives]);
  LoadingsFromTable(Table3,TheLink.BedLoad[NonCohesives2]);
End;
{$R *.DFM}

procedure TLinkForm.CascadeButtonClick(Sender: TObject);
begin
  If CascadeButton.Checked then TempLink.LinkType := CascadeLnk
                           else TempLink.LinkType := FeedbackLnk;
  UpdateScreen;
end;

procedure TLinkForm.NameEditExit(Sender: TObject);
begin
  TempLink.Name := NameEdit.Text;
end;

procedure TLinkForm.LengthExit(Sender: TObject);
Var Conv: Double;
    Result: Integer;

begin
  Val(Trim(TEdit(Sender).Text),Conv,Result);
  Conv:=Abs(Conv);
  If Result<>0
    then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
    else TempLink.CharLength := Conv;
  UpdateScreen;
end;

procedure TLinkForm.FromBoxChange(Sender: TObject);
begin
   If FromBox.ItemIndex<0 then exit;
   TempLink.FromID := TheIDs[FromBox.ItemIndex];
   UpdateScreen;
end;

procedure TLinkForm.HelpButtonClick(Sender: TObject);
begin
   HTMLHelpContext('ViewingLinkages.htm');
end;

procedure TLinkForm.ToBoxChange(Sender: TObject);
begin
   If ToBox.ItemIndex<0 then exit;
   TempLink.ToID := TheIDs^[ToBox.ItemIndex];
   UpdateScreen;
end;

procedure TLinkForm.WaterFlowImportClick(Sender: TObject);
begin
  ChangeLoad(WaterFlowTable,NameEdit.Text+': Water Flow (cu.m/d)');
end;

procedure TLinkForm.DiffusionImportClick(Sender: TObject);
begin
  ChangeLoad(DiffusionTable,NameEdit.Text+': Diffusion (sq.m/d)');
end;


procedure TLinkForm.XSecImportClick(Sender: TObject);
begin
  ChangeLoad(XSecTable,NameEdit.Text+': XSection (sq.m)');
end;

procedure TLinkForm.ToggleButtClick(Sender: TObject);
begin
  ShowingBedLoad := Not ShowingBedLoad;
  UpdateScreen;
end;

procedure TLinkForm.Import1Click(Sender: TObject);
begin
  ChangeLoad(Table1,NameEdit.Text+': Bed Load Cohesives(<63) (g/d)')
end;

procedure TLinkForm.Import2Click(Sender: TObject);
begin
  ChangeLoad(Table2,NameEdit.Text+': Bed Load Non Cohesives(63-250) (g/d)');
end;

procedure TLinkForm.Import3Click(Sender: TObject);
begin
  ChangeLoad(Table3,NameEdit.Text+': Bed Load Non Cohesives(>250) (g/d)');
end;

Procedure TLinkForm.ChangeLoad(Var Tab: TTable; Name: String);
Var Fmt: String;
Begin
  Fmt := TFloatField(Tab.Fields[1]).DisplayFormat;
  Tab.Active := False;
  If Tab= WaterFlowTable then ImportForm.ChangeLoading(Name,Tab,False,False,CTFlow) else
       If Tab= XSecTable then ImportForm.ChangeLoading(Name,Tab,False,False,CTSurfArea)
                         else ImportForm.ChangeLoading(Name,Tab,False,False,CTNone);
  Tab.Active := True;
  TFloatField(Tab.Fields[1]).DisplayFormat := Fmt ;
  Update
End;

end.
 