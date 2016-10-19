//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit SiteScre;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons, Loadings, hh,
     StdCtrls, ExtCtrls, Global, SysUtils, Aquaobj, AQStudy,Dialogs, Site, Remin,
     SV_IO, DBEntry, AQSite, Db, DBTables, DBCtrls, Grids, DBGrids, AQBaseForm;

type
   TTempSite= Record
    SiteRec: SiteRecord;
    ReminRec: ReminRecord;
    TempSiteType: SiteTypes;
  End;

  TSiteDialog = class(TAQBase)
    OKBtn: TBitBtn;
    Panel1: TPanel;
    LoadButton: TButton;
    EditButton: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    Stream_Button: TRadioButton;
    Res_Button: TRadioButton;
    Pond_Button: TRadioButton;
    Lake_Button: TRadioButton;
    Label5: TLabel;
    ReminButton: TButton;
    ReloadReminBut: TButton;
    Limno_Button: TRadioButton;
    Bevel2: TBevel;
    Label7: TLabel;
    ShadeLabel: TLabel;
    ShadeGrid: TDBGrid;
    ShadeNav: TDBNavigator;
    ShadeImportButt: TButton;
    Panel3: TPanel;
    Unit3: TLabel;
    UseConstShadeButton: TRadioButton;
    ConstShadeEdit: TEdit;
    UseDynamShadeButton: TRadioButton;
    ShadeTable: TTable;
    DataSource1: TDataSource;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    VelGrid: TDBGrid;
    VelNav: TDBNavigator;
    VelImport: TButton;
    Panel4: TPanel;
    CalcVelButt: TRadioButton;
    ImpVelButt: TRadioButton;
    Label4: TLabel;
    VelTable: TTable;
    DataSource2: TDataSource;
    HelpButton: TButton;
    EstuaryButton: TRadioButton;
    MeanDepthToggle: TButton;
    MeanDepthPanel: TPanel;
    Label6: TLabel;
    ZMeanGrid: TDBGrid;
    ZMeanImport: TButton;
    ZMeanNav: TDBNavigator;
    Panel5: TPanel;
    Label8: TLabel;
    ConstZMean: TRadioButton;
    DynZMeanButt: TRadioButton;
    ZMeanTable: TTable;
    DataSource3: TDataSource;
    Label9: TLabel;
    Label10: TLabel;
    Bevel3: TBevel;
    TribInputButton: TRadioButton;
    VolButton2: TButton;
    BathyLabel: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Bevel4: TBevel;
    EvapGrid: TDBGrid;
    EvapImport: TButton;
    EvapNav: TDBNavigator;
    Panel6: TPanel;
    Label13: TLabel;
    ConstEvap: TRadioButton;
    DynEvap: TRadioButton;
    DataSource4: TDataSource;
    EvapTable: TTable;
    Label14: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
    procedure EditButtonClick(Sender: TObject);
    procedure Pond_ButtonClick(Sender: TObject);
    procedure Lake_ButtonClick(Sender: TObject);
    procedure Stream_ButtonClick(Sender: TObject);
    procedure Res_ButtonClick(Sender: TObject);
    procedure ReminButtonClick(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure ReloadReminButClick(Sender: TObject);
    procedure Limno_ButtonClick(Sender: TObject);
    procedure UseConstShadeButtonClick(Sender: TObject);
    procedure ConstShadeEditExit(Sender: TObject);
    procedure ShadeImportButtClick(Sender: TObject);
    procedure VelImportClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure EstuaryButtonClick(Sender: TObject);
    procedure MeanDepthToggleClick(Sender: TObject);
    procedure ZMeanImportClick(Sender: TObject);
    procedure TribInputButtonClick(Sender: TObject);
    procedure VolButton2Click(Sender: TObject);
    procedure EvapImportClick(Sender: TObject);

  private
    TempSite: TTempSite;  {Holds temp info about State Var so user
                                  can cancel if he/she wants to}
    { Private declarations }
  public
    Changed: Boolean;
    LinkedMode: Boolean;
    Procedure EditSite(Var AQTS: TAQUATOXSegment);
    Procedure CopyToTemp;
    Procedure CopyFromTemp;
    Procedure UpdateScreen;
    { Public declarations }
  end;

var
  SiteDialog: TSiteDialog;
  SitePointer: TAQTSite;             {Holds the Pointer to the Site Var itself}
  DynEvapPointer, DynZMeanPointer : PPLoadings;
  PConstEvap, PConstZMean: PBoolean;
  ShadePointer: PLoadingsRecord;
  VelPointer : PPLoadings;
  LinkedMod: Boolean;
  CalcVel: PBoolean;
  PSt: TStates;
  NoEnableDisable: Boolean;
  
implementation

uses StreamFrm, edstatev, Imp_Load, Convert, StratFlow;
{$R *.DFM}

{**********************}
procedure TSiteDialog.AppException(Sender: TObject; E: Exception);
begin
   Application.ShowException(E);
end;

Procedure TSiteDialog.EditSite;

Begin
  With AQTS do with SV Do
    Begin
      LinkedMod := LinkedMode;
      NoEnableDisable := False;
      Changed:=False;
      SitePointer:=Location;
      DynZMeanPointer := @DynZMean;
      PConstZMean := @UseConstZMean;
      DynEvapPointer := @DynEvap;
      PConstEvap := @UseConstEvap;
      ShadePointer := @Shade;
      VelPointer := @DynVelocity;
      CalcVel :=   @(CalcVelocity);
      PSt := SV;
    End;

   CopyToTemp;
   UpdateScreen;
   ShowModal;
   CopyFromTemp;
End;

{**********************}

Procedure TSiteDialog.CopyToTemp;
{This procedure copies data into temp Site}
Var TableIn: TTable;
    i: Integer;

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

Begin
  {Find SiteType and Show on Screen}
  With tempsite do
  begin
    TempSiteType:=sitepointer.SiteType;
    SiteRec:=sitepointer.Locale;
    ReminRec:=sitepointer.Remin;
  End; {with}

  ShadeTable.DatabaseName:=Program_Dir;
  ShadeTable.Active:=False;
  ShadeTable.EmptyTable;
  ShadeTable.Active:=True;

  {Load the Database Data into the Files}
  TableIn:=ShadeTable;
  TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
  With ShadePointer.Loadings do For i:=0 to count-1 do
                                    PutInDbase(at(i));

  VelTable.DatabaseName:=Program_Dir;
  VelTable.Active:=False;
  VelTable.EmptyTable;
  VelTable.Active:=True;

  {Load the Database Data into the Files}
  TableIn:=VelTable;
  TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.##';
  With VelPointer^ do For i:=0 to count-1 do
                                   PutInDbase(at(i));

  ZMeanTable.DatabaseName:=Program_Dir;
  ZMeanTable.Active:=False;
  ZMeanTable.EmptyTable;
  ZMeanTable.Active:=True;

  {Load the Database Data into the Files}
  TableIn:=ZMeanTable;
  TFloatField(TableIn.Fields[1]).DisplayFormat:='###0.####';
  With DynZMeanPointer^ do For i:=0 to count-1 do
                                   PutInDbase(at(i));


  EvapTable.DatabaseName:=Program_Dir;
  EvapTable.Active:=False;
  EvapTable.EmptyTable;
  EvapTable.Active:=True;

  {Load the Database Data into the Files}
  TableIn:=EvapTable;
  TFloatField(TableIn.Fields[1]).DisplayFormat:='#####0.#';
  With DynEvapPointer^ do For i:=0 to count-1 do
                                   PutInDbase(at(i));


End;  {Copy_To_Temp}

{*********************************************************************}

Procedure TSiteDialog.CopyFromTemp;
{This procedure copies data from tempSV back into the State Variable}

Begin
  {Find SiteType and Show on Screen}
  With tempsite do
  begin
    If Sitepointer.SiteType<>TempSiteType then Changed:=True;
    sitepointer.SiteType:=TempSiteType;
    sitepointer.Locale:=SiteRec;
    sitepointer.Remin:=ReminRec;
    sitepointer.ChangeData(SiteRec.ICZMean);
  End; {with}

  StateVarDialog.LoadingsFromTable(VelTable,VelPointer^);
  StateVarDialog.LoadingsFromTable(ZMeanTable,DynZMeanPointer^);
  StateVarDialog.LoadingsFromTable(EvapTable,DynEvapPointer^);
  StateVarDialog.LoadingsFromTable(ShadeTable,ShadePointer.Loadings);


End;  {Copy_From_Temp}



{*********************************************************************}

Procedure TSiteDialog.UpdateScreen;

Begin
   {Write in Names}
   Label5.Caption:='Site: '+ TempSite.SiteRec.SiteName;


   If LinkedMode then EstuaryButton.Enabled := False;
   If not LinkedMode then TribInputButton.Visible := False;
   If LinkedMode and (TempSite.TempSiteType=Estuary) then TempSite.TempSiteType := Pond;
   If not LinkedMode and (TempSite.TempSiteType=TribInput) then TempSite.TempSiteType := Pond;

   VolButton2.Visible  := Not LinkedMode and (TempSite.TempSiteType in [Reservr1D,Pond,Lake]);

   {Get Radio Buttons to their Correct State}
    Case TempSite.TempSiteType of
       Pond: Pond_Button.Checked:=True;
       Stream: Stream_Button.Checked:=True;
       Reservr1D: Res_Button.Checked:=True;
       Lake: Lake_Button.Checked:=True;
       Enclosure: Limno_Button.Checked:=True;
       Estuary: EstuaryButton.Checked:=True;
       TribInput: TribInputButton.Checked := True;
    End; {Case}

  ConstShadeEdit.Text := FloatToStrF(ShadePointer.ConstLoad,ffGeneral,15,4);
  NoEnableDisable     := True;

  ConstZMean.Checked := PConstZMean^;
  ConstEvap.Checked := PConstEvap^;

  DynZMeanButt.Checked  := Not PConstZMean^;
  DynEvap.Checked  := Not PConstEvap^;

  UseConstShadeButton.Checked := ShadePointer.UseConstant;
  UseDynamShadeButton.Checked := not ShadePointer.UseConstant;
  CalcVelButt.Checked := CalcVel^;
  ImpVelButt.Checked  := Not CalcVel^;
  NoEnableDisable := False;
  UseConstShadeButtonClick(nil);
End;

{*********************************************************}

procedure TSiteDialog.CancelBtnClick(Sender: TObject);
Begin
  SiteDialog.ModalResult:=MRCancel;
end;



procedure TSiteDialog.EditButtonClick(Sender: TObject);
{Procedure Loads Record into Database for editing in the site entry
screen, creates the entry forms, changes them to reflect the appropriate
type of editing, shows them modally, and returns the data to the temporary record}

var
   ModalResult: Integer;
   RecordName: ShortString;

begin
Application.CreateForm(TEdit_Site, Edit_Site);
Application.CreateForm(TStreamForm,StreamForm);
Edit_Site.LinkedMod := LinkedMod;
   With edit_site.Table2 do
                Begin
                    Active:=False;
                    DatabaseName:=program_dir;
                    TableName:='SITEFORM.DB';
                    EmptyTable;
                    Active:=True;

                   {Enable Linked Grid Mode?}
                   
                    Append;
                    Fields[0].AsString:='Holder';
                    Post;
                    Active:=False;
                    If not SiteRecord_to_Dbase(program_dir,'SITEFORM.DB','Holder',TempSite.SiteRec) then
                           Begin
                              MessageDlg('AQUATOX ERROR- Site Record Not Loading',mterror,[mbOK],0);
                              Edit_Site.Free;
                              Exit;
                           End;
                    edit_site.DbNavigator1.Visible:=False;
                    edit_site.FindButton.Visible:=False;
                    edit_site.NewButton.Visible:=False;
                    edit_site.LoadButton.Visible:=True;
                    edit_site.SaveLib.Visible:=True;
                    edit_Site.CancelButton.Visible:=False;
                    If Limno_Button.Checked=True then Edit_Site.StreamButton.Enabled:=False;
                    edit_site.SaveButton.Caption:='&OK';
                    Edit_Site.LoadButton.Visible:=True;
                    Edit_Site.LibMode := False;
                    Edit_Site.SType := TempSite.TempSiteType;
                    Active:=True;
                    ModalResult:=edit_site.ShowModal;
                    RecordName:=Fields[0].AsString;
                End; {with}
              StreamForm.Free;
              If ModalResult<>MrCancel then
                   begin
                     Dbase_to_SiteRecord(program_dir,'SiteFORM.DB',RecordName,TempSite.SiteRec);
                     If Edit_Site.Changed or StreamForm.Changed then Changed:=True;
                   end;
      edit_site.Hide;
      edit_site.Free;
      UpdateScreen;
      Application.OnException:=AppException;  {Reset Application to this Form's Error Handler}
end;


{RADIO BUTTON CLICKS:  Assign the correct site type to TEMPSITE}
procedure TSiteDialog.TribInputButtonClick(Sender: TObject);
begin
TempSite.TempSiteType:=TribInput;
end;

procedure TSiteDialog.Pond_ButtonClick(Sender: TObject);
begin   TempSite.TempSiteType:=Pond;  end;

procedure TSiteDialog.Lake_ButtonClick(Sender: TObject);
begin   TempSite.TempSiteType:=Lake;  end;

procedure TSiteDialog.Stream_ButtonClick(Sender: TObject);
begin   TempSite.TempSiteType:=Stream; end;

procedure TSiteDialog.Res_ButtonClick(Sender: TObject);
begin   TempSite.TempSiteType:=Reservr1D;  end;

procedure TSiteDialog.Limno_ButtonClick(Sender: TObject);
begin   TempSite.TempSiteType:=Enclosure;  end;

procedure TSiteDialog.EstuaryButtonClick(Sender: TObject);
begin  TempSite.TempSiteType:=Estuary; end;


procedure TSiteDialog.ReminButtonClick(Sender: TObject);
{Procedure Loads Record into Database for editing in the Remin entry
screen shows the screen modally, and returns the data to the temporary
record}

var
   ModalResult: Integer;
   RecordName: ShortString;

begin
   Application.CreateForm(TRemineralization, Remineralization);
   With Remineralization.table1 do
            begin
              Active:=False;
              DatabaseName:=program_dir;
              TableName:='REMNFORM.DB';
                    EmptyTable;
                    Active:=True;
                    Append;
                    Fields[0].AsString:='Holder';
                    Post;
                    Active:=False;
                    If not ReminRecord_to_Dbase(program_dir,'REMNFORM.DB','Holder',TempSite.ReminRec) then
                           Begin
                              MessageDlg('AQUATOX ERROR- Remin Record Not Loading',mterror,[mbOK],0);
                              Remineralization.Free;
                              Exit;
                           End;
                    Remineralization.DbNavigator1.Visible:=False;
                    Remineralization.FindButton.Visible:=False;
                    Remineralization.NewButton.Visible:=False;
                    Remineralization.LoadButton.Visible:=True;
                    Remineralization.SaveLib.Visible:=True;
                    Remineralization.CancelButton.Visible:=False;
                    Remineralization.SaveButton.Caption:='&OK';
                    Remineralization.LoadButton.Visible:=True;
                    Active:=True;
                    ModalResult:=Remineralization.ShowModal;
                    RecordName:=Fields[0].AsString;
                End; {with}
              If ModalResult<>MrCancel then
                 begin
                    Dbase_to_ReminRecord(program_dir,'RemnFORM.DB',RecordName,TempSite.ReminRec);
                    If Remineralization.Changed Then Changed:=True;
         end;
     Remineralization.Hide;
     Remineralization.Free;
     Application.OnException:=AppException;  {Reset Application to this Form's Error Handler}
end;


procedure TSiteDialog.LoadButtonClick(Sender: TObject);
Var LoadOK: Boolean;

begin
  Application.CreateForm(TDb_GetEntry, Db_GetEntry);
  With Db_GetEntry do
  begin
    HeadString:='Select Site Entry to Load:';
    Filter:='Site DBs (*.sdb)|*.SDB|';
    DefaultDbName:='Site.SDB';
  If Not GetEntry Then
    Begin
      DB_GetEntry.Free;
      Exit;
    End;

  Changed:=True;
  LoadOK:=Dbase_to_SiteRecord(FileDir,FileName,Entry,TempSite.SiteRec);

End; {With};

DB_GetEntry.Free;
UpdateScreen;
If Not LoadOK then MessageDlg('Load Error: Press Cancel From This Screen To Restore Original Values.',mterror,[mbOK],0)

end;

procedure TSiteDialog.ReloadReminButClick(Sender: TObject);
Var LoadOK: Boolean;
begin
  If MessageDlg('Overwrite Remineralization Record with Default in Database?',mtconfirmation,[mbOK,MbCancel],0) = MrCancel
     then exit;

  LoadOK:=DBase_To_ReminRecord(Default_Dir,'Remin.RDB','Default Remin Record',TempSite.ReminRec);

  If Not LoadOK then MessageDlg('Load Error: Press Cancel From This Screen To Restore Original Values.',mterror,[mbOK],0)
                else MessageDlg('Remin Record Overwritten',MTInformation,[MBOK],0);
  Changed := True;
end;


procedure TSiteDialog.UseConstShadeButtonClick(Sender: TObject);
begin
 If NoEnableDisable then Exit;

 PConstEvap^ := ConstEvap.Checked;
 If ConstEvap.Checked then begin
                               EvapGrid.Enabled:=False;
                               EvapGrid.Color:=ClGray;
                               EvapNav.Enabled:=False;
                             end
                        else begin
                               EvapGrid.Enabled:=True;
                               EvapGrid.Color:=EditColor;
                               EvapNav.Enabled:=True;
                             end;


 PConstZMean^ := ConstZMean.Checked;
 If ConstZMean.Checked then begin
                               ZMeanGrid.Enabled:=False;
                               ZMeanGrid.Color:=ClGray;
                               ZMeanNav.Enabled:=False;
                             end
                        else begin
                               ZMeanGrid.Enabled:=True;
                               ZMeanGrid.Color:=EditColor;
                               ZMeanNav.Enabled:=True;
                             end;

 ShadePointer.UseConstant := UseConstShadeButton.Checked;
 If UseConstShadeButton.Checked then begin
                                       ConstShadeEdit.Enabled:=True;
                                       ShadeGrid.Enabled:=False;
                                       ShadeGrid.Color:=ClGray;
                                       ShadeNav.Enabled:=False;
                                     end
                                else begin
                                       ConstShadeEdit.Enabled:=False;
                                       ShadeGrid.Enabled:=True;
                                       ShadeGrid.Color:=EditColor;
                                       ShadeNav.Enabled:=True;
                                     end;

 CalcVel^ := CalcVelButt.Checked;
 If CalcVelButt.Checked then begin
                               VelGrid.Enabled:=False;
                               VelGrid.Color:=ClGray;
                               VelNav.Enabled:=False;
                             end
                        else begin
                               VelGrid.Enabled:=True;
                               VelGrid.Color:=EditColor;
                               VelNav.Enabled:=True;
                             end;
end;

procedure TSiteDialog.ConstShadeEditExit(Sender: TObject);
Var Conv   : Double;
    Result : Integer;
Begin

  Val(Trim(TEdit(Sender).Text),Conv,Result);
  Conv:=Abs(Conv);
  If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
               else ShadePointer.ConstLoad := Conv;

  UpdateScreen;
End;

procedure TSiteDialog.ShadeImportButtClick(Sender: TObject);
Var Nm: String;
begin
  Nm := 'Fraction of Site Shaded (frac)';

  ShadeTable.Active:=False;
  ImportForm.ChangeLoading(Nm,ShadeTable,False,False,CTNone);
  ShadeTable.Active:=True;

  TFloatField(ShadeTable.Fields[1]).DisplayFormat:='###0.###';
  Update;
End;

procedure TSiteDialog.EvapImportClick(Sender: TObject);
Var Nm: String;
begin
  Nm := 'Evaporation (m3/d)';

  EvapTable.Active:=False;
  ImportForm.ChangeLoading(Nm,EvapTable,False,False,CTFlow);
  EvapTable.Active:=True;

  TFloatField(EvapTable.Fields[1]).DisplayFormat:='#####0.#';
  Update;
end;


procedure TSiteDialog.VelImportClick(Sender: TObject);
Var Nm: String;
begin
  Nm := 'Water Velocity (cm/s)';

  VelTable.Active:=False;
  ImportForm.ChangeLoading(Nm,VelTable,False,False,CTNone);
  VelTable.Active:=True;

  TFloatField(VelTable.Fields[1]).DisplayFormat:='###0.##';
  Update;
end;

procedure TSiteDialog.ZMeanImportClick(Sender: TObject);
Var Nm: String;
begin
  Nm := 'Mean Depth (m)';

  ZMeanTable.Active:=False;
  ImportForm.ChangeLoading(Nm,ZMeanTable,False,False,CTDepth);
  ZMeanTable.Active:=True;

  TFloatField(ZMeanTable.Fields[1]).DisplayFormat:='###0.####';
  Update;
end;


procedure TSiteDialog.VolButton2Click(Sender: TObject);
begin
  Application.CreateForm(TStratFlowForm,StratFlowForm);

  StratflowForm.EditStratInfo(PSt.GetStatePointer(Volume,StV,WaterCol),@(PSt.Z_Thermocline));

  StratFlowForm.Free;
end;

procedure TSiteDialog.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic73.htm');
end;


procedure TSiteDialog.MeanDepthToggleClick(Sender: TObject);
begin
  If MeanDepthToggle.Caption = 'Show Mean Depth / Evaporation'
     then Begin
            MeanDepthToggle.Caption := 'Show Shading / Velocity';
            BathyLabel.Visible := True;
            MeanDepthPanel.Visible := True;
          End
     else Begin
            MeanDepthToggle.Caption := 'Show Mean Depth / Evaporation';
            BathyLabel.Visible := False;
            MeanDepthPanel.Visible := False;
          End;
end;


end.
