//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Species;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Global,
     Buttons, ExtCtrls,Aquaobj, AQBaseForm, HH;

Type PAV = ^AllVariables;

type
  TSpeciesDialog = class(TAQBase)
    OKBtn: TButton;
    CancelBtn: TButton;
    SVLabel: TLabel;
    Label1: TLabel;
    ListBox1: TListBox;
    HelpButton: TButton;
    procedure HelpButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    SVPtr: TStateVariable;
    SpecPtr: PAV;
    IsPlantSpec: Boolean;
    Procedure EditSpecies(nm: String);

    { Public declarations }
  end;

var
  SpeciesDialog: TSpeciesDialog;

implementation


Procedure TSpeciesDialog.EditSpecies(nm: String);
Var Loop,LowBound,UpBound: AllVariables;
    RelSV: TStateVariable;
    Index: Integer;
    IncludeMe: Boolean;
    ListBox: Array[0..20] of AllVariables;

Begin
  SVLabel.Caption := OutputText(SVPtr.NState,StV,WaterCol,'',False,False,0)+ ': [' +nm +']';
  ListBox1.Items.Clear;
  Case SVPtr.NState of
     SmGamefish1..SmGameFish4 :  Begin
                                   LowBound:=LgGameFish1;
                                   UpBound:=LgGameFish4;
                                 End;
     LgGameFish1..LgGameFish4 :  Begin
                                   LowBound:=SmGameFish1;
                                   UpBound:=SmGameFish4;
                                 End;
     SmForageFish1..SmForageFish2 :
                                 Begin
                                   LowBound:=LgForageFish1;
                                   UpBound:=LgForageFish2;
                                 End;
     LgForageFish1..LgForageFish2 :
                                 Begin
                                   LowBound:=SmForageFish1;
                                   UpBound:=SmForageFish2;
                                 End;
     SmBottomFish1..SmBottomFish2 :
                                 Begin
                                   LowBound:=LgBottomFish1;
                                   UpBound:=LgBottomFish2;
                                 End;
     LgBottomFish1..LgBottomFish2 :
                                 Begin
                                   LowBound:=SmBottomFish1;
                                   UpBound:=SmBottomFish2;
                                 End;
     FirstPlant..LastPlant       : Begin
                                     LowBound:=FirstPlant;
                                     UpBound :=LastPlant;
                                   End;
     Else Raise EAQUATOXError.Create('No Same Species Data Exists for this Compartment');
  End; {Case}

  Index:=0;
  For Loop:=LowBound to UpBound do
    Begin
      RelSV := SVPtr.GetStatePointer(Loop,StV,WaterCol);
      If RelSV<>Nil then
        Begin
          IncludeMe := True;
          If RelSV.nstate in [FirstPlant..LastPlant] then
            If TPlant(RelSV).PAlgalRec^.PlantType<>'Phytoplankton' then IncludeMe := False;
          If IncludeMe then
            Begin
              ListBox[Index]:=RelSV.Nstate;
              Inc(Index);
              ListBox1.Items.Add(RelSV.PName^);
            End;
        End;
    End;


  ListBox[Index]:=NullStateVar;

  If IsPlantSpec
    then ListBox1.Items.Add('** Scour to Detritus **')
    else ListBox1.Items.Add('** No other state variable **');

  Index:=-1;
  Repeat
    Inc(Index)
  Until (ListBox[Index]=SpecPtr^) or (Index= ListBox1.Items.count-1);

  If (ListBox[index]<>SpecPtr^) then SpecPtr^ := ListBox[index];

  ListBox1.Update;
  ListBox1.ItemIndex:=Index;
  ListBox1.Repaint;

  If ShowModal=mrCancel then exit;

  SpecPtr^ := ListBox[ListBox1.ItemIndex];

End;
{$R *.DFM}

procedure TSpeciesDialog.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic42.htm');
end;

end.
