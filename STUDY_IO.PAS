//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Study_io;

interface

uses WinTypes, WinProcs, Classes, StdCtrls, Dialogs, AQStudy, SysUtils, TCollect, Global;

Procedure SaveFile(AQTStudy: TAQUATOXSegment);
Procedure LoadFile(Var AQTStudy: TAQUATOXSegment; FileName:String);

implementation

uses Wait, Main, AQUAOBJ, BufferTStream;

Procedure SaveFile(AQTStudy: TAQUATOXSegment);

Var FileStream: TWriteCachedFileStream;
    PC_FileN:  String;
Begin
  If LowerCase(ExtractFileExt(AQTStudy.FileName)) <> '.aps' then
     AQTStudy.FileName := AQTStudy.FileName + '.aps';

  PC_FileN:=AQTStudy.DirName+AQTStudy.FileName;
  FileStream:=TWriteCachedFileStream.Create(PC_FileN,fmCreate);

  TRY

(*  AQTStudy.SV.ControlResults[Epilimnion].Store(True,TStream(FileStream));  //save control results only
  StoreCollectionitems(True, TStream(FileStream),AQTStudy.SV.ControlResults[Epilimnion]);  *)

  AQTStudy.Store(True,TStream(FileStream));
  AQTStudy.TimeLoaded := Now;
  AQTStudy.LastChange := AQTStudy.TimeLoaded;

  Finally

  FileStream.Destroy;

  End;
End;

Procedure LoadFile(Var AQTStudy: TAQUATOXSegment;FileName: String);

Var FileStream : TReadOnlyCachedFileStream;
    PC_FileN    :  Array[0..255] of char;
    VersionCheck : String[10];
    ReadVers: Double;

Begin
  If AQTStudy<>nil then AQTStudy.Destroy;

  StrPCopy(PC_FileN,FileName);

  Try

    FileStream:=TReadOnlyCachedFileStream.Create(PC_FileN,fmOpenRead);
  Except
    MessageDlg(Exception(ExceptObject).Message,mterror,[mbOK],0);
    AQTStudy:=nil;
    Exit;
  End; {Try Except}

  {Check Version #}
  FileStream.Read(VersionCheck,Sizeof(VersionCheck));
  Try
    VersionNum:=0;
    ReadVers:=strToFloat(AbbrString(VersionCheck,' '));
    VersionNum:=StrToFloat(AbbrString(VersionStr,' '));
  Except
    MessageDlg('File version unreadable: File predates Version 1.03, or other error',mterror,[mbOK],0);
    AQTStudy:=nil;
    FileStream.Destroy;
    Exit;
  End; {Try Except}

  If ReadVers<VersionNum then
     MessageDlg('Converting from '+Trim(VersionCheck)+' to '+Trim (VersionStr),MTInformation,[MbOK],0);

  If ReadVers<1.999
    then MessageDlg('File versions pre 2.00 are not supported by Version 3.00 and above.  (You may access your file by loading it into Release 2 and then saving as version 2.00 or higher)',mterror,[mbOK],0)
   { else If ((ReadVers > 2.7999) and (ReadVers < 2.8999)) then MessageDlg('CANNOT READ RELEASE 2.2 "PLUS" INTO REL3 AT THIS TIME',mterror,[mbOK],0) }
    else If ReadVers>VersionNum
      then
         Begin
            MessageDlg('File Version ('+VersionCheck+') is Greater than Executable Version: Unreadable.',mterror,[mbOK],0);
            AQTStudy:=nil;
         End
      else
         Try
           AQTStudy:=TAQUATOXSegment.Load(False,True,TStream(FileStream),ReadVers,True,True); {Call Load Method}
           AQTStudy.FileName:=ExtractFileName(FileName);
           AQTStudy.DirName:=ExtractFilePath(FileName);
           AQTStudy.TimeLoaded := Now;
           AQTStudy.LastChange := AQTStudy.TimeLoaded;
         Except
           FileStream.Destroy;
           MessageDlg(Exception(ExceptObject).Message,mterror,[mbOK],0);
           Try
             If AQTStudy<> nil then AQTStudy.Destroy;
           Except
             AQTStudy := nil;
           End;
         End;

  FileStream.Destroy;
End;

end.
