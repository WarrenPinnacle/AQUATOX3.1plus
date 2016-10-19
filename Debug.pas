//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Debug;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, TCollect, AQUAOBJ, Global;

type
  TDebugScreen = class(TForm)
    Panel1: TPanel;
    RefreshButton: TButton;
    HideButton: TButton;
    SegBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    EpiVol: TLabel;
    EpiThick: TLabel;
    HypVol: TLabel;
    HypThick: TLabel;
    ZMix: TLabel;
    AnnMeanDisch: TLabel;
    VertDisp: TLabel;
    ZEuphotic: TLabel;
    InflowH2O: TLabel;
    ThermoclArea: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    timestamp: TLabel;
    NilPanel: TPanel;
    Label7: TLabel;
    ZMax: TLabel;
    Label19: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RefreshButtonClick(Sender: TObject);
    procedure HideButtonClick(Sender: TObject);
  private
    Procedure UpdateVars;
  public
    PTStatesArray : Array of PPStates;
    NumSegs: Integer;
  end;

var
  DebugScreen: TDebugScreen;

implementation

{$R *.DFM}

Procedure TDebugScreen.UpdateVars;
Var PS: TStates;
Begin
  PS := PTStatesArray[SegBox.ItemIndex]^;

  TimeStamp.Caption := DateTimeToStr(PS.TPresent);

  If PS=nil then
    Begin
      NilPanel.Visible := True;
      Exit;
    End;  

  NilPanel.Visible     := False;
  EpiVol.Caption       := FloatToStrF(PS.Location.Morph.SegVolum[Epilimnion],ffexponent,4,2);
  HypVol.Caption       := FloatToStrF(PS.Location.Morph.SegVolum[Hypolimnion],ffexponent,4,2);
  EpiThick.Caption     := FloatToStrF(PS.Location.MeanThick[Epilimnion],ffexponent,4,2);
  HypThick.Caption     := FloatToStrF(PS.Location.MeanThick[Hypolimnion],ffexponent,4,2);
  ZMax.Caption         := FloatToStrF(PS.Location.Locale.ZMax,ffexponent,4,2);
  ZMix.Caption         := FloatToStrF(PS.MaxEpiThick,ffexponent,4,2);
  AnnMeanDisch.Caption := FloatToStrF(PS.MeanDischarge,ffexponent,4,2);
  ZEuphotic.Caption    := FloatToStrF(PS.ZEuphotic,ffexponent,4,2);
  ThermoclArea.Caption := FloatToStrF(PS.ThermoclArea,ffexponent,4,2);
  InflowH2O.Caption    := FloatToStrF(PS.Location.Morph.InflowH2O[PS.VSeg],ffexponent,4,2);

(*  If AllStates^.LinkedMode then VertDisp.Caption := 'N / A'
                else VertDisp.Caption     := FloatToStrF(PS.OldVertDispersionVal,ffexponent,4,2); *)

  Update;
End;

procedure TDebugScreen.FormDestroy(Sender: TObject);
begin
   Finalize(PTStatesArray);
end;

procedure TDebugScreen.FormShow(Sender: TObject);
begin
  UpdateVars;
end;

procedure TDebugScreen.RefreshButtonClick(Sender: TObject);
begin
  UpdateVars;
end;

procedure TDebugScreen.HideButtonClick(Sender: TObject);
begin
  Hide;
end;

end.

