//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit morphedit;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Loadings,
  Db, DBTables, Buttons, ExtCtrls, DBCtrls, Grids, DBGrids, TCollect, Global;

type
  TMorphDlg = class(TForm)
    BitBtn1: TBitBtn;
    Panel3: TPanel;
    XSLabel1: TLabel;
    XSGrid: TDBGrid;
    XSImport: TButton;
    XSNav: TDBNavigator;
    AutoCalcXSButton: TRadioButton;
    EnterXSButton: TRadioButton;
    OKBtn: TBitBtn;
    XSLabel2: TLabel;
    XSLabel3: TLabel;
    XSecTable: TTable;
    XSecDataSource: TDataSource;
    procedure RadioButtonClick(Sender: TObject);
    procedure ImportClick(Sender: TObject);
  private
    { Private declarations }
  public
    Procedure MorphEdit(Var XSecCalc : Boolean; Var XSecDat: TLoadings);
  end;

var
  MorphDlg: TMorphDlg;

implementation

uses Imp_Load, Convert;

{$R *.DFM}

Procedure TMorphDlg.MorphEdit(Var XSecCalc : Boolean; Var XSecDat: TLoadings);
Var TableIn: TTable;
         {-----------------------------------------------------}
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
         {-----------------------------------------------------}
         Procedure LoadingsFromTable(Table: TTable; Var LColl: TLoadings);
         {Copies loadings data from the table to the Collection}
         Var loop,recnum: Integer;
             NewLoad:     TLoad;
         Begin
             If LColl<>nil then LColl.Destroy;
             With Table do begin
               First;
               RecNum:=RecordCount;
               LColl:=TLoadings.Init(RecNum,10);
                  For loop:=1 to RecNum do
                       begin
                            NewLoad:= TLoad.Init(Fields[0].AsDateTime,Fields[1].AsFloat);
                            LColl.Insert(NewLoad);
                            Next;
                       end; {for do}
             end; {with}

         End; {LoadingsFromTable}
         {----------------------------------------------------------}
Var i: Integer;
Begin
  {Ready the Database Files for the Loadings Data}
(*  ThickTable.DatabaseName:=Program_Dir;
  ThickTable.Active:=False;
  ThickTable.EmptyTable;
  ThickTable.Active:=True;
  {Load the Database Data into the Files}
  TableIn:=ThickTable;
  With ThickDat do
    For i:=0 to count-1 do
      PutInDbase(at(i));

  {Ready the Database Files for the Loadings Data}
  SurfaceAreaTable.DatabaseName:=Program_Dir;
  SurfaceAreaTable.Active:=False;
  SurfaceAreaTable.EmptyTable;
  SurfaceAreaTable.Active:=True;
  {Load the Database Data into the Files}
  TableIn:=SurfaceAreaTable;
  With SADat do
    For i:=0 to count-1 do
      PutInDbase(at(i)); *)

  {Ready the Database Files for the Loadings Data}
  XSecTable.DatabaseName:=Program_Dir;
  XSecTable.Active:=False;
  XSecTable.EmptyTable;
  XSecTable.Active:=True;
  {Load the Database Data into the Files}
  TableIn:=XSecTable;
  With XSecDat do
    For i:=0 to count-1 do
      PutInDbase(at(i));


(*  AutoCalcThickButton.Checked := ThickCalc;
  EnterThickButton.Checked   := Not ThickCalc;

  UseSiteSAButton.Checked   := SAUseSite;
  EnterSAButton.Checked    := Not SAUseSite; *)

  AutoCalcXSButton.Checked := XSecCalc;
  EnterXSButton.Checked    := Not XSecCalc;

  RadioButtonClick(nil);

  If ShowModal = MRCancel then exit;

(*  ThickCalc := AutoCalcThickButton.Checked;
  SAUseSite := UseSiteSAButton.Checked;  *)
  XSecCalc  := AutoCalcXSButton.Checked;

  {Copy the Database Data into the SVs in memory}
(*  LoadingsFromTable(ThickTable,ThickDat);
  LoadingsFromTable(SurfaceAreaTable,SADat); *)
  LoadingsFromTable(XSecTable,XSecDat);

End;

procedure TMorphDlg.RadioButtonClick(Sender: TObject);
begin
(*  ThickLabel.Enabled  := EnterThickButton.Checked;
  ThickUnit.Enabled   := EnterThickButton.Checked;
  ThickGrid.Enabled   := EnterThickButton.Checked;
  ThickNav.Enabled    := EnterThickButton.Checked;
  ThickImport.Enabled := EnterThickButton.Checked;
  If EnterThickButton.Checked then ThickGrid.Color := ClWhite
                              else ThickGrid.Color := ClGray;

  SALabel1.Enabled   := EnterSAButton.Checked;
  SALabel2.Enabled   := EnterSAButton.Checked;
  SALabel3.Enabled   := EnterSAButton.Checked;
  SAGrid.Enabled     := EnterSAButton.Checked;
  SANav.Enabled      := EnterSAButton.Checked;
  SAImport.Enabled   := EnterSAButton.Checked;
  If EnterSAButton.Checked then SAGrid.Color := ClWhite
                           else SAGrid.Color := ClGray;*)

  XSLabel1.Enabled   := EnterXSButton.Checked;
  XSLabel2.Enabled   := EnterXSButton.Checked;
  XSLabel3.Enabled   := EnterXSButton.Checked;
  XSGrid.Enabled     := EnterXSButton.Checked;
  XSNav.Enabled      := EnterXSButton.Checked;
  XSImport.Enabled   := EnterXSButton.Checked;
  If EnterXSButton.Checked then XSGrid.Color := ClWhite
                           else XSGrid.Color := ClGray;

end;

procedure TMorphDlg.ImportClick(Sender: TObject);
Var WorkingTable: TTable;
    ImportStr   : String;
begin
  Case TButton(Sender).Name[1] of
{     'T' : WorkingTable := ThickTable; }
     'X' : WorkingTable := XSecTable;
{     'S' : WorkingTable := SurfaceAreaTable; }
  End;

  Case TButton(Sender).Name[1] of
{     'T' : ImportStr := 'Segment Thickness (m)';}
     'X' : ImportStr := 'Cross Section Area (m2)';
{     'S' : ImportStr := 'Surface Area (m2)'; }
  End;

  WorkingTable.Active:=False;
  ImportForm.ChangeLoading(ImportStr,WorkingTable,False,False,CTSurfArea);
  WorkingTable.Active:=True;

  Update;
end;


end.
