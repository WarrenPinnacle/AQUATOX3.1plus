//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_DBEntry;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Db, DBTables, Global, notused, aqbaseform;

type
  TWiz_GetEntry = class(TAQBase)
    EntryList: TListBox;
    Header: TLabel;
    Table1: TTable;
    OKBtn: TButton;
    Bevel1: TBevel;
    procedure HelpBtnClick(Sender: TObject);
    procedure EntryListClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations } 
  public
    Entry: String;
    Function GetEntry(FC: Word): Boolean;
    Procedure UpdateScreen;
    { Public declarations }
  end;

Var
  FishClass: Word;
 {FishClass=0: forage, FC=1: bottom, FC=2: game, FC=3: all}

  Wiz_GetEntry: TWiz_GetEntry;

implementation

{$R *.DFM}

Procedure TWiz_GetEntry.UpdateScreen;
Var RecNum, Loop: Integer;
    Holder: String;
    IncludeFish: Boolean;
Begin
   EntryList.Items.Clear;
   If not RenameFile(Default_dir+'\Animal.ADB',Default_dir+'\Animal.DB') then Exit;
   Table1.DataBaseName:=Default_Dir;
   Table1.TableName:='Animal.DB';

  Try
     Table1.Active:=True;
     With Table1 do begin
        First;
        RecNum:=RecordCount;
        If RecNum>0 then
           For loop:=1 to RecNum do
               begin
                 Holder:=Fields[0].AsString;
                 Case FishClass of
                   0: {forage} IncludeFish := (FieldByName('GuildTaxa').AsString = 'Forage Fish');
                   1: {bottom} IncludeFish := (FieldByName('GuildTaxa').AsString = 'Bottom Fish');
                   2: {game  } IncludeFish := (FieldByName('GuildTaxa').AsString = 'Game Fish');
                   else {all } IncludeFish := (Pos('Fish',FieldByName('GuildTaxa').AsString)>0);
                 End; {Case}
                 If IncludeFish then EntryList.Items.Add(Holder);
                 Next;
               end; {for do loop}
        EntryList.Update;
     end; {with}
  Except
  End;
  Table1.Active:=False;

  RenameFile(Default_dir+'\Animal.DB',Default_dir+'\Animal.ADB');

End;

Function TWiz_GetEntry.GetEntry(FC: Word): Boolean;
 {FC=0: forage, FC=1: bottom, FC=2: game, FC=3: all}

Begin
   FishClass := FC;
   OKBtn.Enabled := False;
   EntryList.ItemIndex := -1;
   GetEntry:=False;
   UpdateScreen;
   If Showmodal = Mrok then GetEntry:=True;
End;


procedure TWiz_GetEntry.HelpBtnClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TWiz_GetEntry.EntryListClick(Sender: TObject);
begin
   If (EntryList.ItemIndex=-1)
     then OKBtn.Enabled:=False
     else OkBtn.Enabled:=EntryList.Items.Strings[EntryList.ItemIndex]<>'';
end;

procedure TWiz_GetEntry.OKBtnClick(Sender: TObject);
begin
  Entry:=EntryList.Items.Strings[EntryList.ItemIndex];
end;

end.

