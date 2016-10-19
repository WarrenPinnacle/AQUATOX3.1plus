//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Notesdlg;
{BRINGS UP A LIST BOX IN WHICH THE USER CAN ENTER NOTES WHICH GET STORED
 IN A 255 CHARACTER STRING, RATHER THAN A TSTRINGS.

 This data structure is necessary because the string will be stored in
 a collection and
   A. Needs to be stored to disk and should not be a dynamic class
   B. Classes and old-type objects should not be mixed.  JonC}

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, jpeg, ExtCtrls;

type
  TNotesDialog = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    NotesMemo: TMemo;
    NotesDlgBackdrop: TImage;
  private
    { Private declarations }
  public
     Changed: Boolean;
     Procedure DisplayNotes(Var TS:TStringList);
    { Public declarations }
  end;

var
  NotesDialog: TNotesDialog;

implementation

uses sysutils;

Procedure TNotesDialog.DisplayNotes(Var TS:TStringList);

Var tempstr: ShortString;
    easteregg: boolean;


begin
     changed:=false;
     tempstr:='';

     Notesmemo.lines.assign(TS);

     easteregg := False;
     If NotesMemo.Lines.Count > 0 then
       easteregg := Lowercase(NotesMemo.Lines[0])='don''t forget you''re here forever';

     NotesMemo.Visible := not easteregg;
     NotesDlgBackdrop.Visible := easteregg;
     If easteregg then NotesMemo.Lines[0] := 'do it for her';

     If ShowModal = MrCancel then exit;

     changed:=true;
     TS.Assign(NotesMemo.Lines);
end;
{$R *.DFM}

end.
