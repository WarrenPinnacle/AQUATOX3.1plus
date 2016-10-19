//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit ec50lc50;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, DB, DBTables, Global, Dialogs, AQBaseForm;

type
  Tec50lc50dialog = class(TAQBase)
    OKBtn: TButton;
    CancelBtn: TButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    fromlabel: TLabel;
    tolabel: TLabel;
    Label3: TLabel;
    RatioLabel: TLabel;
    Label5: TLabel;
    Bevel1: TBevel;
    AnimEC50panel: TPanel;
    ec50growthrb: TRadioButton;
    EC50reprorb: TRadioButton;
    procedure ListBox1Click(Sender: TObject);
    procedure ec50growthrbClick(Sender: TObject);
  private
    TheTable: TTable;
    { Private declarations }
  public
    Changed: Boolean;
    Procedure EstimatePlants(Var PT: TTable);
    Procedure EstimateAnimals(Var PT: TTable);
    { Public declarations }
  end;

var
  ec50lc50dialog: Tec50lc50dialog;
  ratio: Double;
  AnimEC50: String;
  AnimalScreen: Boolean;

implementation

Procedure TEC50LC50Dialog.EstimatePlants(Var PT: TTable);
Var loop: integer;
    Calc, ExpTime: Double;
Begin
  AnimalScreen := False;
  AnimEC50Panel.Visible := False;

  TheTable           := PT;
  Caption            := 'Estimate Plant LC50s using EC50 to LC50 ratio';
  RatioLabel.Caption := 'NA';
  OKBtn.Enabled      := False;
  FromLabel.Caption  := 'Using the EC50 to LC50 ratio of this toxicity record:';
  ToLabel.Caption    := 'Estimate LC50s for these toxicity records:';

  Listbox1.Items.Clear;
  Listbox2.Items.Clear;

  PT.First;
  With PT do
     For Loop:=1 to RecordCount do
      begin
        ListBox1.Items.Add(PT.Fields[0].AsString);
        ListBox2.Items.Add(PT.Fields[0].AsString);
        PT.Next;
      end;
  PT.First;

  Changed := False;
  If Showmodal = mrCancel then exit;

  If ListBox2.SelCount=0 then
    begin
      MessageDlg('No variables were selected to write LC50 data to.',mtInformation,[mbOK],0);
      exit;
    end;

  Changed := True;
  PT.First;
  With PT do
     For Loop:=1 to RecordCount do
       Begin
         If ListBox2.Selected[loop-1] then
           Begin
             Calc := PT.FieldByName('EC50 photo (ug/L)').AsFloat / Ratio;
             ExpTime := PT.FieldByName('EC50 exp. time (h)').AsFloat;
             PT.Edit;
             PT.FieldByName('LC50 (ug/L)').AsFloat := Calc;
             PT.FieldByName('LC50 exp. time (h)').AsFloat := ExpTime;
             PT.FieldByname('LC50 comment').AsString:='using '+ListBox1.Items.Strings[ListBox1.ItemIndex]+' LC50/EC50 ratio';
             PT.Post;
           End;
         PT.Next;
       End;

  PT.First;


End;


Procedure TEC50LC50Dialog.EstimateAnimals(Var PT: TTable);
Var loop: integer;
    ExpTime, Calc: Double;
    ExpString: String;
Begin
  AnimalScreen := True;
  AnimEC50Panel.Visible := True;
  EC50growthrb.checked:=True;
  AnimEC50 := 'growth';

  TheTable           := PT;
  Caption            := 'Estimate Animal EC50s using EC50 to LC50 ratio';
  RatioLabel.Caption := 'NA';
  OKBtn.Enabled      := False;
  FromLabel.Caption  := 'Using the EC50 to LC50 ratio of this toxicity record:';
  ToLabel.Caption    := 'Estimate EC50s for these toxicity records:';

  Listbox1.Items.Clear;
  Listbox2.Items.Clear;

  PT.First;
  With PT do
     For Loop:=1 to RecordCount do
      begin
        ListBox1.Items.Add(PT.Fields[0].AsString);
        ListBox2.Items.Add(PT.Fields[0].AsString);
        PT.Next;
      end;
  PT.First;

  Changed := False;
  If Showmodal = mrCancel then exit;

  If ListBox2.SelCount=0 then
    begin
      MessageDlg('No variables were selected to write EC50 data to.',mtInformation,[mbOK],0);
      exit;
    end;

  Changed := True;

  If AnimEC50 = 'growth' then ExpString := 'Growth exp. (h)'
                         else ExpString := 'Repro. exp. time(h)';

  PT.First;
  With PT do
     For Loop:=1 to RecordCount do
       Begin
         If ListBox2.Selected[loop-1] then
           Begin
             Calc := PT.FieldByName('LC50 (ug/L)').AsFloat * Ratio;
             PT.Edit;
             PT.FieldByName('EC50 '+AnimEC50+' (ug/L)').AsFloat := Calc;
             PT.FieldByname('EC50 comment').AsString:='using '+ListBox1.Items.Strings[ListBox1.ItemIndex]+' LC50/EC50 ratio';

             ExpTime := PT.FieldByName('LC50 exp. time (h)').AsFloat;
             PT.FieldByName(ExpString).AsFloat := ExpTime;

             PT.Post;
           End;
         PT.Next;
       End;

  PT.First;


End;


{$R *.DFM}

procedure Tec50lc50dialog.ListBox1Click(Sender: TObject);
Var FindString: String;
    LC50, EC50: Double;
begin
   If ListBox1.ItemIndex<0 then exit;
   FindString:=ListBox1.Items.Strings[ListBox1.ItemIndex];
   TheTable.First;
   While TheTable.Fields[0].AsString<>FindString do
     TheTable.Next;

   LC50 := TheTable.FieldByName('LC50 (ug/L)').AsFloat;

   If AnimalScreen then EC50 := TheTable.FieldByName('EC50 '+AnimEC50+' (ug/L)').AsFloat
                   else EC50 := TheTable.FieldByName('EC50 photo (ug/L)').AsFloat;

   If (LC50<=0) or (EC50<0)
     then
       begin
         RatioLabel.Caption := 'Error';
         OKBtn.Enabled:=False;
       end
     else
       begin
         Ratio := EC50/LC50;
         RatioLabel.Caption := FloatToStr(RoundDec(3,Ratio));
         OKBtn.Enabled:=True;
       end;
end;

procedure Tec50lc50dialog.ec50growthrbClick(Sender: TObject);
begin
   If EC50growthrb.checked then AnimEC50 := 'growth'
                           else AnimEC50 := 'repro';
   ListBox1Click(Sender);

end;

end.
