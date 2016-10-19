//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Basins_PSL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Global, AQUAOBJ, AQBaseForm;

type
  TBasinsPSSpec = class(TAQBase)
    MultEdit: TEdit;
    Label1: TLabel;
    AQTXLoadEdit: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label6: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    SolutionLabel: TLabel;
    Label13: TLabel;
    BasinsLoadLabel: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    MultFactLabel: TLabel;
    Label19: TLabel;
    AddFactLabel: TLabel;
    Label20: TLabel;
    AddEdit: TEdit;
    Label21: TLabel;
    Bevel1: TBevel;
    Button3: TButton;
    Label22: TLabel;
    Label23: TLabel;
    OrgmattPanel: TPanel;
    Label24: TLabel;
    PrevLoadLabel: TLabel;
    PLL4: TLabel;
    PrevLoadLabel2: TLabel;
    PLL3: TLabel;
    Label25: TLabel;
    RefrEdit: TEdit;
    Label26: TLabel;
    PartEdit: TEdit;
    HeadLabel: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure MultEditExit(Sender: TObject);
    procedure Conv(Sender: TObject);
  private
    { Private declarations }
  public
    PLogF: PTextFile;
    Procedure ImportPS(BL: Double; n1,n2: String; PSL: PDouble; PDRD: TDissRefrDetr);
    Procedure UpdateScreen;
    { Public declarations }
  end;

var
  PrevLoad: Double;
  BasinsPSSpec: TBasinsPSSpec;
  MultFactor,AddFactor: Double;
  PctRefr, PctPart: Double;
  BasinsLoad, Solution: Double;
  AQTName: String;

implementation

Procedure TBasinsPSSpec.UpdateScreen;
Var IsPrevLoad: Boolean;
Begin
   Solution := Abs(BasinsLoad * 24 * 453.59 * MultFactor) + AddFactor + PrevLoad;

   IsPrevLoad := PrevLoad <> 0;
   PrevLoadLabel.Visible := IsPrevLoad;
   PrevLoadLabel2.Visible := IsPrevLoad;
   PLL3.Visible := IsPrevLoad;
   PLL4.Visible := IsPrevLoad;
   PrevLoadLabel.Caption := FloatToStrF(PrevLoad,ffExponent,5,5);
   SolutionLabel.Caption := FloattoStrF(Solution,ffExponent,5,5);
   BasinsLoadLabel.Caption := FloattoStrF(BasinsLoad,ffgeneral,9,4);
   MultFactLabel.Caption :=FloatToStrF(MultFactor,ffFixed,5,3);
   AddFactLabel.Caption := FloatToStrF(AddFactor,ffFixed,5,3);

   PartEdit.Text:=FloatToStrF(PctPart,ffgeneral,9,4);
   RefrEdit.Text:=FloatToStrF(PctRefr,ffgeneral,9,4);
   MultEdit.Text:=FloatToStrF(MultFactor,ffgeneral,9,4);
   AddEdit.Text:=FloatToStrF(AddFactor,ffgeneral,9,4);
End;

Procedure TBasinsPSSpec.ImportPS(BL: Double; n1,n2: String; PSL: PDouble; PDRD: TDissRefrDetr);
Begin
  OrgMattPanel.Visible := (PDRD<>nil);
  PrevLoad := PSL^;
  BasinsLoad := BL;
  If PDRD<>nil then
    Begin
      PctRefr := PDRD.InputRecord.Percent_Refr.Alt_ConstLoad[PointSource];
      PctPart := PDRD.InputRecord.Percent_Part.Alt_ConstLoad[PointSource];
    End;
  MultFactor := 1;
  AddFactor := 0;
  AQTName := N2;
  UpdateScreen;
  HeadLabel.Caption := 'You have selected to load "'+N1+ '" into "'+N2+'"';
  If ShowModal = MrOK then
    Begin
      PSL^ := Solution;
      If PDRD<>nil then
        Begin
          PDRD.InputRecord.Percent_Refr.Alt_ConstLoad[PointSource] := PctRefr;
          PDRD.InputRecord.Percent_Refr.Alt_UseConstant[PointSource] := True;
          PDRD.InputRecord.Percent_Part.Alt_ConstLoad[PointSource] := PctPart;
          PDRD.InputRecord.Percent_Part.Alt_UseConstant[PointSource] := True;
        End;
      Writeln(PLogF^,'The Point Source Loading of '+AQTName+' was set to '+SolutionLabel.Caption);
    End;

End;


{$R *.DFM}

procedure TBasinsPSSpec.Button1Click(Sender: TObject);
begin
  UpdateScreen;
  If MessageDlg('The Point Source Loading of '+AQTName+' will be set to '+SolutionLabel.Caption,mtconfirmation,[mbok,mbcancel],0) =
     MROK then ModalResult := MrOK;
end;

procedure TBasinsPSSpec.MultEditExit(Sender: TObject);
begin
  UpdateScreen;
end;

procedure TBasinsPSSpec.Conv(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update screen}
Var
Conv: Double;
Result: Integer;

Begin
    Val(Trim(Tedit(Sender).Text),Conv,Result);
    If (Result<>0) Or
    ((TEdit(Sender).Name[1] in ['P','R']) and ((Conv>100) or (Conv<0)))
                 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else begin
                         case TEdit(Sender).Name[1] of
                            'P': PctPart:=Abs(Conv);
                            'R': PctRefr:=Abs(Conv);
                            'M': MultFactor:=Abs(Conv);
                            'A': AddFactor := Conv;
                         end; {case}
                      end; {else}
    UpdateScreen;
end; {DetrVerify}

end.
