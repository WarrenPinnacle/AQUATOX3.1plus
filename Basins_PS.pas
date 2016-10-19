//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Basins_PS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AQStudy, Global, Aquaobj, AQBaseForm;

type
  TImport_PS = class(TAQBase)
    Label1: TLabel;
    Label2: TLabel;
    AQTPSBox: TListBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BasinsPSBox: TListBox;
    continueButton: TButton;
    ImportButton: TButton;
    Label7: TLabel;
    procedure BasinsPSBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    PLogF: PTextFile;
    Procedure Import(PStudy: TAQUATOXsegment; Var BPSArray: Array of Double);
    Procedure UpdateScreen;
    { Public declarations }
  end;

var
  Import_PS: TImport_PS;
  Pst: TAQUATOXsegment;
  PSArray: Array[0..25] of AllVariables;
  NumOrgToxIn: Integer;

implementation

uses Basins_PSL;

Procedure TImport_PS.UpdateScreen;
Var ToxIndex: AllVariables;

Begin
  AQTPSBox.Items.Clear;
  AQTPSBox.Items.Add('Ammonia as N (g/d)');
  PSArray[0] := Ammonia;
  AQTPSBox.Items.Add('Nitrate as N (g/d)');
  PSArray[1] := Nitrate;
  AQTPSBox.Items.Add('Phosphate as N (g/d)');
  PSArray[2] := Phosphate;
  AQTPSBox.Items.Add('Organic Matter (g/d)');
  PSArray[3] := DissRefrDetr;

  NumOrgToxIn := 0;
  For ToxIndex := FirstOrgTox to LastOrgTox do
    If PSt.SV.GetStatePointer(ToxIndex,StV,WaterCol)<>nil then
      Begin
        AQTPSBox.Items.Add(TStateVariable(PSt.SV.GetStatePointer(ToxIndex,StV,WaterCol)).PName^ + ' (g/d)');
        Inc(NumOrgToxIn);
        PSArray[3+NumOrgToxIn] := ToxIndex;
      End;
  If NumOrgToxin=0 then AQTPSBox.Items.Add('Organic Toxicant (g/d)')
                   else if NumOrgToxin<20 then AQTPSBox.Items.Add('Other Organic Toxicant (g/d)');
  PSArray[4+NumOrgToxIn] := NullStateVar;
End;

Procedure TImport_PS.Import(PStudy: TAQUATOXsegment; Var BPSArray: Array of Double);
Var Mr: TModalResult;
    PSV: TStateVariable;
    LoadPointer: PDouble;
    CancelChosen: Boolean;
    PDRD: TDissRefrDetr;
    ToxIndex: AllVariables;

Begin
  PSt := PStudy;
  UpdateScreen;
  Repeat
    Mr :=ShowModal;
    If Mr=MrYes
      then
        Begin
          If PSArray[AQTPSBox.ItemIndex] = NullStateVar then
            Begin
              For ToxIndex := LastOrgTox downto FirstOrgTox do
               If PSt.SV.GetStatePointer(ToxIndex,StV,WaterCol)<>nil then
                 PSArray[AQTPSBox.ItemIndex] := ToxIndex;
              PSt.Add_OrgTox_SVs(PSArray[AQTPSBox.ItemIndex],'Point Source');
            End;
          PSV := PSt.SV.GetStatePointer(PSArray[AQTPSBox.ItemIndex],StV,WaterCol);
          If PSV.NState=DissRefrDetr
            then
              Begin
                PDRD := TDissRefrDetr(PSV);
                LoadPointer := @(PDRD.InputRecord.Load.Alt_ConstLoad[PointSource]);
              End
            else
              Begin
                PDRD := nil;
                LoadPointer := @(PSV.LoadsRec.Alt_ConstLoad[PointSource]);
              End;

          CancelChosen := False;
          If LoadPointer^ > 0 then
            Begin
              If (MessageDlg('You have already imported a P.S. loading into that AQUATOX loading compartment.  Would you like to '+
                            'add this loading to the previous import?  (As opposed to overwriting)',mtconfirmation,[mbyes,mbno],0)
                 = mrno) then
                 If (MessageDlg('Previous imported loading will be overwritten.',mTinformation,[mbok,mbcancel],0)
                   = mrOK) then LoadPointer^ := 0
                           else Cancelchosen := True;
            End;

          If not CancelChosen then
            Begin
               Application.CreateForm(TBasinsPSSpec, BasinsPSSpec);
               Try
                 BasinsPSSpec.PLogF := PLogF;
                 BasinsPSSpec.ImportPS(BPSArray[BasinsPSBox.ItemIndex],BasinsPSBox.Items[BasinsPSBox.ItemIndex],AQTPSBox.Items[AQTPSBox.ItemIndex],LoadPointer,PDRD);
               Finally
                 BasinsPSSpec.Free;
               End;  
            End;
        End;
    UpdateScreen;
    AQTPSBox.ItemIndex    := -1;
    BasinsPSBox.ItemIndex := -1;
    ImportButton.Enabled  := False;
  Until Mr = MrNo;

End;

{$R *.DFM}

procedure TImport_PS.BasinsPSBoxClick(Sender: TObject);
begin
  ImportButton.Enabled := (BasinsPSBox.ItemIndex>=0) and (AQTPSBox.ItemIndex>=0);
end;

end.
