//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit AQTOpenDialog;

interface

Uses Dialogs, Windows, Messages;

Type TAQTOpenDialog = class(TOpenDialog)
    Public
    FolderChanged: Boolean;
    Procedure FolderChange(Sender: TObject);
    Procedure WhenCreated(Sender: TObject);
  End;

implementation

Procedure TAQTOpenDialog.WhenCreated(Sender: TObject);
Begin
  FolderChanged := False;
End;

Procedure TAQTOpenDialog.FolderChange(Sender: TObject);
var
  H, H2: THandle;
begin
  If FolderChanged then Exit;
  H := FindWindowEx(GetParent(TOpenDialog(Sender).Handle), 0, PChar('SHELLDLL_DefView'), nil);
  H2 := FindWindowEx(H, 0, PChar('SysListView32'), nil);
  if (H <> 0) and (H2 <> 0) then
  begin
    SendMessage(H, WM_COMMAND, $702C, 0);
    Windows.SetFocus(H2);
    PostMessage(H2, WM_KEYDOWN, VK_SPACE, 0);
    FolderChanged := True;
  end;
end;


end.
