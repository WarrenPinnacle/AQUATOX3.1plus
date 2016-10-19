//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit AllPlantLinksEdit;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons, hh,
  StdCtrls, jpeg, ExtCtrls, AQBaseForm, AQUAOBJ, Global, TCollect, SysUtils;

type
  TPlantLinksEdit = class(TAQBase)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    HelpButton: TButton;
    procedure ComboBox1Change(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);

  private
    { Private declarations }
  public
     Changed: Boolean;
     Procedure EditAllLinks(Var PS: TStates);
    { Public declarations }
  end;

var
  PlantLinksEdit: TPlantLinksEdit;
  PlantLinks: Array of AllVariables;
  ListBox: Array[0..20] of AllVariables;

implementation

{$R *.DFM}


Procedure TPlantLinksEdit.EditAllLinks(Var PS: TStates);

Var i,j, entries: Integer;
    PP: TPlant;
    TL : TLabel;
    TCB: TComboBox;
    PStrings: TStringList;

                    {-------------------------------------------------------------------}
                    Procedure GetPotentialLinkages;
                    Var Index: Integer;
                        Loop : AllVariables;
                        IncludeMe: Boolean;
                        RelSV: TStateVariable;
                    Begin
                      PStrings := TStringList.Create;
                      Index:=0;
                      For Loop:=FirstPlant to LastPlant do
                        Begin
                          RelSV := PS.GetStatePointer(Loop,StV,WaterCol);
                          If RelSV<>Nil then
                           If RelSV.IsPlant then
                            Begin
                              IncludeMe := True;
                              If TPlant(RelSV).PAlgalRec^.PlantType<>'Phytoplankton' then IncludeMe := False;
                              If IncludeMe then
                                Begin
                                  ListBox[Index]:=RelSV.Nstate;
                                  Inc(Index);
                                  PStrings.Add(RelSV.PName^);
                                End;
                            End;
                        End;

                      ListBox[Index]:=NullStateVar;

                      PStrings.Add('** Scour to Detritus **')

                    End;
                    {-------------------------------------------------------------------}

Begin
  SetLength(PlantLinks,50);
  GetPotentialLinkages;
  Entries := 0;
  For i := 0 to PS.Count -1 do
    Begin
      PP := PS.At(i);

      If PP.IsPlant then
       If PP.IsPeriphyton then
        Begin
          Inc(Entries);
          If Entries = 1
            then Begin TL := Label1; TCB := ComboBox1; End
            Else
              Begin
                TL := TLabel.Create(PlantLinksEdit);
                TL.Parent := ScrollBox1;
                TL.Font := Label1.Font;
                TL.Left := Label1.Left;
                TL.Top := 16 + 32*(Entries-1);
                TL.Width := Label1.Width;
                TL.Alignment := Label1.Alignment;

                TCB := TComboBox.Create(PlantLinksEdit);
                TCB.Parent := ScrollBox1;
                TCB.Font := ComboBox1.Font;
                TCB.Left := ComboBox1.Left;
                TCB.Top := 16 + 32*(Entries-1);
                TCB.Width := ComboBox1.Width;
                TCB.OnChange := ComboBox1.OnChange;
              End;

          TCB.Items.Assign(PStrings);

          j:=-1;
          Repeat
            Inc(j)
          Until(ListBox[j]=PP.PSameSpecies^) or (j = pstrings.count-1);

          If (ListBox[j]<>PP.PSameSpecies^) then PP.PSameSpecies^ := ListBox[j]; 
          TCB.Update;
          TCB.ItemIndex:=j;
          TCB.Repaint;

          If Entries>Length(PlantLinks) then SetLength(PlantLinks,Entries+50);
          PlantLinks[Entries-1] := PP.PSameSpecies^;
          TCB.Tag := Entries;

          TL.Caption := PP.PName^;
          If TL.Caption = 'Undisplayed' then Tl.Caption := OutputText(PP.NState,PP.SVType,Watercol,'',False,False,0);
          TL.Caption := TL.Caption + ' is linked to';
          TL.Visible := True;
        End;  {periphyton}
    End;

  ScrollBox1.VertScrollBar.Range := ScrollBox1.VertScrollBar.Range + 16;

  PStrings.Free;

  Changed := False;
  If ShowModal = mrCancel then exit;

  Entries := 0;
  For i := 0 to PS.Count -1 do
    Begin
      PP := PS.At(i);

      If PP.IsPlant then
       If PP.IsPeriphyton then
        Begin
          Inc(Entries);
          if PP.PSameSpecies^ <> PlantLinks[Entries-1] then
            Begin
              Changed := True;
              PP.PSameSpecies^ := PlantLinks[Entries-1];
            End;
        End;
    End;
End;


procedure TPlantLinksEdit.HelpButtonClick(Sender: TObject);
begin
    HTMLHelpContext('Plant_Linkages.htm');
end;

procedure TPlantLinksEdit.ComboBox1Change(Sender: TObject);
begin
  With TComboBox(Sender) do
    PlantLinks[Tag-1] := ListBox[itemindex] ;
end;

end.

