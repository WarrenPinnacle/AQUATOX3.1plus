//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
unit Diag_InitCond;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons, Dialogs, hh,
  StdCtrls, jpeg, ExtCtrls, AQBaseForm, AQUAOBJ, Global, TCollect, SysUtils, AQStudy;

type
  TDiag_Init_Cond_Form = class(TAQBase)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Unit1: TLabel;
    Edit1: TEdit;
    EditButton: TButton;
    Label2: TLabel;
    HelpButton: TButton;
    CopyToAll: TButton;
    Label3: TLabel;
    Panel1: TPanel;
    SteadyStateBox: TCheckBox;
    Label4: TLabel;
    procedure Edit1Exit(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure CopyToAllClick(Sender: TObject);

  private
    { Private declarations }
     PAQS: TAQUATOXSegment;
  public
     DiaChanged, Changed: Boolean;
     Procedure EditDiagenesis(Var PS: TAQUATOXSegment);
    { Public declarations }
  end;

var
  Diag_Init_Cond_Form: TDiag_Init_Cond_Form;
  InitConds: Array of Double;

implementation

Uses Diagenesis, ExcelFuncs, WAIT;

{$R *.DFM}


procedure TDiag_Init_Cond_Form.EditButtonClick(Sender: TObject);
begin

   DiagenesisForm := TDiagenesisForm.Create(self);
   DiagenesisForm.EditDiagenesisParams(Pointer(PAQS));
   DiaChanged := DiagenesisForm.Changed;
   DiagenesisForm.Free;
end;

Procedure TDiag_Init_Cond_Form.EditDiagenesis(Var PS: TAQUATOXSegment);

Var i, entries: Integer;
    PSV: TStateVariable;
    TL,TU : TLabel;
    TE: TEdit;

begin
  Edit1.Color := EditColor;
  PAQS := PS;
  CopyToAll.Enabled := TAQUATOXSegment(PS).SV.LinkedMode;

  SteadyStateBox.Checked := PAQS.SV.Diagenesis_Steady_State;
  SetLength(InitConds,100);
  Entries := 0;
  For i := 0 to PS.SV.Count -1 do
    Begin
      PSV := PS.SV.At(i);
      If (PSV.Layer > WaterCol) then
        Begin
          Inc(Entries);
          If Entries = 1
            then Begin TL := Label1; TE := Edit1; TU := Unit1; End
            Else
              Begin
                TL := TLabel.Create(Diag_Init_Cond_Form);
                TL.Parent := ScrollBox1;
                TL.Font := Label1.Font;
                TL.Left := Label1.Left;
                TL.Top := 52 + 32*(Entries-1);
                TL.Width := Label1.Width;
                TL.Alignment := Label1.Alignment;

                TE := TEdit.Create(Diag_Init_Cond_Form);
                TE.Parent := ScrollBox1;
                TE.Font := Edit1.Font;
                TE.Color := EditColor;
                TE.Left := Edit1.Left;
                TE.Top := 52 + 32*(Entries-1);
                TE.Width := Edit1.Width;
                TE.OnExit := Edit1.OnExit;
                TE.Tag := Entries-1;
                TE.Ctl3d := Edit1.Ctl3d;

                TU := TLabel.Create(Diag_Init_Cond_Form);
                TU.Parent := ScrollBox1;
                TU.Font := Unit1.Font;
                TU.Left := Unit1.Left;
                TU.Top := 52 + 32*(Entries-1);
                TU.Width := Unit1.Width;
                TU.Alignment := Unit1.Alignment;
              End;

            TE.Text := FloatToStrF(PSV.InitialCond,ffgeneral,7,4);
            InitConds[Entries-1] := PSV.InitialCond;
            TL.Caption := OutputText(PSV.NState,PSV.SVType,PSV.Layer,'',False,False,0);
            TU.Caption := PSV.StateUnit;
            TL.Visible := True;
            TU.Visible := True;
            ScrollBox1.VertScrollBar.Range := ScrollBox1.VertScrollBar.Range + 32;
        End;

    End;

  Changed := False;
  DiaChanged := False;
  If ShowModal = mrCancel then exit;

  PAQS.SV.Diagenesis_Steady_State := SteadyStateBox.Checked;
  Entries := 0;
  For i := 0 to PS.SV.Count -1 do
    Begin
      PSV := PS.SV.At(i);

      If (PSV.Layer > WaterCol) then
        Begin
          Inc(Entries);
          If PSV.InitialCond <> InitConds[Entries-1] then
                  Begin
                    Changed := True;
                    PSV.InitialCond := InitConds[Entries-1];
                  End;
        End;
    End;


end;


procedure TDiag_Init_Cond_Form.HelpButtonClick(Sender: TObject);
begin
    HTMLHelpContext('Sediment_Diagenesis.htm');
end;

procedure TDiag_Init_Cond_Form.CopyToAllClick(Sender: TObject);
Var WorkingStudy, AQTStudy : TAQUATOXSegment;
    istempl: Boolean;
    i,j,entries: Integer;
    PSV: TStateVariable;
begin
  AQTStudy := PAQS;
  If Not AQTStudy.SV.LinkedMode then Begin CopyToAll.Enabled := False; Exit; End;
  If MessageDlg('Copy current initial conditions to all segments? (cannot undo)',mtconfirmation,[mbok,mbcancel],0)
    = mrcancel then exit;

  For i := -1 to AQTStudy.AllOtherSegs.Count-1 do
     Begin
       IsTempl := (i=-1);
       If IsTempl then WorkingStudy := AQTStudy.TemplateSeg
                  else WorkingStudy := AQTStudy.AllOtherSegs.At(i);

       Entries := 0;
       For j := 0 to WorkingStudy.SV.Count -1 do
          Begin
            PSV := WorkingStudy.SV.At(j);

            If (PSV.Layer > WaterCol) then
              Begin
                Inc(Entries);
                If PSV.InitialCond <> InitConds[Entries-1] then
                        Begin
                          Changed := True;
                          PSV.InitialCond := InitConds[Entries-1];
                        End;
              End;
          End;
    End;
end;

procedure TDiag_Init_Cond_Form.Edit1Exit(Sender: TObject);
Var Result: Integer;
    Conv: Double;
begin
    Val(Trim(TEdit(Sender).Text),Conv,Result);
    Conv:=Abs(Conv);
    If Result<>0
      then
        Begin
          MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0);
          TEdit(Sender).Text := FloatToStrF(InitConds[TEdit(Sender).Tag],ffgeneral,12,4);
        End
     else InitConds[TEdit(Sender).Tag] := Conv;
end;

end.

