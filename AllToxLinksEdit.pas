//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit AllToxLinksEdit;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, jpeg, ExtCtrls, AQBaseForm, AQUAOBJ, Global, TCollect, SysUtils;

type
  TToxLinksEdit = class(TAQBase)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    procedure ComboBox1Change(Sender: TObject);

  private
    { Private declarations }
  public
     Changed: Boolean;
     Procedure EditAllLinks(Var PS: TStates);
    { Public declarations }
  end;

var
  ToxLinksEdit: TToxLinksEdit;
  ToxRecs: Array of String[15];

implementation

{$R *.DFM}


Procedure TToxLinksEdit.EditAllLinks(Var PS: TStates);

Var i, entries: Integer;
    PSV: TStateVariable;
    TL : TLabel;
    TCB: TComboBox;
    AStrings, PStrings: TStringList;

                    {-------------------------------------------------------------------}
                    Procedure GetToxRecords;
                    Var ToxLoop: T_SVType;
                        Loop, Loop2: Integer;
                        PC: TCollection;
                        ItemFound: Boolean;
                        PAT: TAnimalToxRecord;
                        PPT: TPlantToxRecord;
                    Begin
                      AStrings := TStringList.Create;
                      PStrings := TStringList.Create;
                      For ToxLoop := FirstOrgTxTyp to LastOrgTxTyp do
                       {Add additional toxicity fields to Edit_Animal ToxComboBox items}
                       If PS.GetStatePointer(AssocToxSV(ToxLoop),StV,WaterCol)<>nil then
                        Begin
                          {If FirstEntry then Edit_Animal.ToxComboBox.Items.Clear;
                          FirstEntry := False; }
                          PC := PS.ChemPtrs^[ToxLoop].Anim_Tox;

                          For loop := 0 to PC.Count-1 do
                            Begin
                              ItemFound:=False;
                              PAT := PC.At(loop);
                              For loop2 := 0 to AStrings.Count-1 do
                                If Lowercase(AStrings[loop2]) =
                                   Lowercase(PAT.Animal_Name) then ItemFound:=True;
                              If Not ItemFound then AStrings.Append(PAT.Animal_Name);
                            End;

                        PC := PS.ChemPtrs^[ToxLoop].Plant_Tox;
                        For loop := 0 to PC.Count-1 do
                          Begin
                            ItemFound:=False;
                            PPT := PC.At(loop);
                            For loop2 := 0 to PStrings.Count-1 do
                              If Lowercase(PStrings.Strings[loop2]) =
                                 Lowercase(PPT.Plant_Name) then ItemFound:=True;
                            If Not ItemFound then PStrings.Append(PPT.Plant_Name);
                          End;

                        End;


                    End;
                    {-------------------------------------------------------------------}

begin
  SetLength(ToxRecs,50);
  GetToxRecords;
  Entries := 0;
  For i := 0 to PS.Count -1 do
    Begin
      PSV := PS.At(i);

      If PSV.IsPlantorAnimal then
        Begin
          Inc(Entries);
          If Entries = 1
            then Begin TL := Label1; TCB := ComboBox1; End
            Else
              Begin
                TL := TLabel.Create(ToxLinksEdit);
                TL.Parent := ScrollBox1;
                TL.Font := Label1.Font;
                TL.Left := Label1.Left;
                TL.Top := 16 + 32*(Entries-1);
                TL.Width := Label1.Width;
                TL.Alignment := Label1.Alignment;

                TCB := TComboBox.Create(ToxLinksEdit);
                TCB.Parent := ScrollBox1;
                TCB.Font := ComboBox1.Font;
                TCB.Left := ComboBox1.Left;
                TCB.Top := 16 + 32*(Entries-1);
                TCB.Width := ComboBox1.Width;
                TCB.OnChange := ComboBox1.OnChange;
              End;

            If PSV.IsPlant
              then
                Begin
                  TCB.Items.Assign(PStrings);
                  TCB.Text := TPlant(PSV).PAlgalRec^.ToxicityRecord;
                End
              else
                Begin
                  TCB.Items.Assign(AStrings);
                  TCB.Text := TAnimal(PSV).PAnimalData^.ToxicityRecord;
                End;

            If Entries>Length(ToxRecs) then SetLength(ToxRecs,Entries+50);
            ToxRecs[Entries-1] := TCB.Text;
            TCB.Tag := Entries;

            TL.Caption := PSV.PName^;
            If TL.Caption = 'Undisplayed' then Tl.Caption := OutputText(PSV.NState,PSV.SVType,Watercol,'',False,False,0);
            TL.Visible := True;

        End;

    End;

  ScrollBox1.VertScrollBar.Range := ScrollBox1.VertScrollBar.Range + 16;

  Changed := False;
  If ShowModal = mrCancel then exit;

  Entries := 0;
  For i := 0 to PS.Count -1 do
    Begin
      PSV := PS.At(i);

      If PSV.IsPlantorAnimal then
        Begin
          Inc(Entries);
          If PSV.IsPlant
            then
              Begin
                if TPlant(PSV).PAlgalRec^.ToxicityRecord <> ToxRecs[Entries-1] then
                  Begin
                    Changed := True;
                    TPlant(PSV).PAlgalRec^.ToxicityRecord := ToxRecs[Entries-1];
                  End;
              End
            else
              Begin
                if TAnimal(PSV).PAnimalData^.ToxicityRecord <> ToxRecs[Entries-1] then
                  Begin
                    Changed := True;
                    TAnimal(PSV).PAnimalData^.ToxicityRecord := ToxRecs[Entries-1];
                  End;
              End;
        End;
    End;


end;


procedure TToxLinksEdit.ComboBox1Change(Sender: TObject);
begin
  With TComboBox(Sender) do
    ToxRecs[Tag-1] := Text;
end;

end.

