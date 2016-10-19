//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
unit Basins;

{ HSPF none "c:\work\aquatox\documents\workingdocs\nutrients\hspf\BLUE.WDM" REVATC RCH73 SUM }
{ UNKNOWN GISBASEFILEN }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ATCData_TLB, ATCTSfile_TLB, Registry, AQStudy, Global, Loadings, AQUAOBJ,
  ShellAPI, SWAT_basin, AQBaseForm, Basins_BOD, Basins_TOC, LinkedSegs;

Type
  TF90_WDBOPN = Function (Var a: LongInt; b: PChar; c: integer ): LongInt  stdcall;
  TF90_W99OPN = Procedure;
  TF90_W99CLO = Procedure;

type
  TLBasinsInfo = class(TAQBase)
    HSPFPanel: TPanel;
    ContinueButton: TButton;
    BypassButton: TButton;
    Label1: TLabel;
    
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Button3: TButton;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    GISPanel: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Button4: TButton;
    Label32: TLabel;
    SWATPanel: TPanel;
    Label21: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Button5: TButton;
    Label34: TLabel;
    Label37: TLabel;
    Label46: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label47: TLabel;
    Label33: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    procedure Button3Click(Sender: TObject);
  private
    Function ReadColumn(Line,Col: Integer): String;
    Function ReadFixed(Line,ColS,ColF: Integer): String;
    Procedure GetLinkStudy(Var LinkStudy: TAQUATOXSegment; DName: String);
    { Private declarations }
  public
     ReadFl: TextFile;
     LogF : TextFile;
     LogFName: String;
     GISBaseFile, WDMFile, Scenario, Location, AvgStr: String;
     AvDepRead: Boolean;
     _F90_WDBOPN: TF90_WDBOPN;
     _F90_W99OPN: TF90_W99OPN;
     _F90_W99CLO: TF90_W99CLO;
    Procedure Get_HSPF_Linkage(Var LinkStudy: TAQUATOXSegment; FromParams: Boolean);
    Procedure Get_BASINS_Linkage(Var LinkStudy: TAQUATOXSegment; HSPF: Boolean);
    Procedure Get_SWAT_Linkage(SWATFile: String; Var LinkStudy: TAQUATOXSegment);
    Procedure ExportGenScn(Linked: Boolean; ExportSeg: TAQUATOXSegment; ExportLinked: TLinkedSegs);
    Procedure GetParams;
    { Public declarations }
  end;

Var
    LBasinsInfo: TLBasinsInfo;

implementation

uses Wait, Basins_PS, Basins_BaseStudy, Study_io, HSPF_Date, Basins_Phosphate, AQTOpenDialog, Observed_Data;

{Declare Function F90_WDBOPN Lib "hass_ent.dll" (l&, ByVal s$, ByVal i%) As Long'adwdm:ztwdmf}

(*Function F90_WDBOPN(Var a: LongInt; b: PChar; c: integer ): LongInt  stdcall; external 'hass_ent.dll';
Procedure F90_W99OPN; external 'hass_ent.dll';
Procedure F90_W99CLO; external 'hass_ent.dll'; *)

function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..254] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;



{-------------------------------------------------------------------------------}
                               { UTILITIES }
{-------------------------------------------------------------------------------}
Function TLBasinsInfo.ReadFixed(Line,ColS,ColF: Integer): String;
Var StrLen,LRead,CRead: Integer;
   InChar: Char;
   ThisStr: String;
Begin
 ReadFixed := '';
 ThisStr:='';
 Reset(ReadFl);
 For LRead := 1 to Line-1 do
   Begin
     Readln(ReadFl);
     If Eof(ReadFl) then Exit;
   End;

 InChar := ' ';
 For CRead := 1 to ColS-1 do
     Read(ReadFl,InChar);
 If Inchar = #0 then exit;

 StrLen := 0;
 If Eoln(ReadFl) then Exit;

 For CRead := ColS to ColF do
   Begin
     Read(ReadFl,InChar);
     Inc(StrLen);
     SetLength(ThisStr,StrLen);
     ThisStr[StrLen] := InChar;
   End;

 ReadFixed := ThisStr;
End;

Procedure TLBasinsInfo.GetLinkStudy;
Var Dir,FileN,BaseName: String;
    NameIndex: Integer;
    openDialog : TAQTOpenDialog;    // Open dialog variable
Begin
 Application.CreateForm(TUseBlank, UseBlank);
 Try
 If (UseBlank.ShowModal = mryes)
  then
    Begin
      LinkStudy:= TAQUATOXSegment.Init(DName,nil);
      LinkStudy.Load_Blank_Study(Stream);
      Writeln(LogF,'Creating new simulation with linkage data and an empty simulation.');
    End
  else
    Begin
      openDialog := TAQTOpenDialog.Create(self);
      openDialog.InitialDir := GetCurrentDir;
      openDialog.Options := [ofFileMustExist, ofEnableSizing];
      openDialog.Filter := 'AQUATOX Study Files|*.aps|All Files|*.*';
      openDialog.FilterIndex := 1;
      if not openDialog.Execute then
          Begin
            MessageDlg('No Simulation Loaded.  AQUATOX will use a "Blank" Simulation.',mtinformation,[mbok],0);
            LinkStudy:= TAQUATOXSegment.Init('GISLink',nil);
            LinkStudy.Load_Blank_Study(Stream);
            Writeln(LogF,'Creating new simulation with linkage data and an empty simulation.');
            openDialog.Free;
            Exit;
          End;
        {Load the File}

        Try
          LoadFile(LinkStudy, OpenDialog.FileName);

          Writeln(LogF,'Overwriting Relevant Parameters in simulation '+LinkStudy.FileName);

          BaseName := LinkStudy.Filename;
          Delete(BaseName,Length(BaseName)-Length(ExtractFileExt(BaseName))+1,10);

          NameIndex := 1;
          LinkStudy.Filename := BaseName + '_MOD.aps';
          Dir := LinkStudy.DirName;
          FileN := LinkStudy.FileName;

          While FileExists(Dir+'/'+FileN) or FileExists(Dir+FileN) do
            Begin
              Inc(NameIndex);
              LinkStudy.Filename := BaseName + '_MOD'+InttoStr(NameIndex)+'.aps';
              FileN := LinkStudy.FileName;
            End;

          Writeln(LogF,'Simulation renamed '+LinkStudy.FileName);

        Except
          LinkStudy:=nil;
          opendialog.Free;
{          WaitDlg.Hide; }
          Raise;
          Exit;
        End;
      openDialog.Free;
 {        WaitDlg.Hide; }
    End;

   Finally
     UseBlank.Free;
   End;

   LinkStudy.TimeLoaded := 0;
   LinkStudy.LastChange := NOW;
   Writeln(LogF);

End;

Function TLBasinsInfo.ReadColumn(Line,Col: Integer): String;
Var StrLen,LRead,CRead: Integer;
   InChar: Char;
   WaitQuote: Boolean;
   ThisStr: String;
Begin
 ReadColumn := '';
 ThisStr:='';
 Reset(ReadFl);
 For LRead := 1 to Line-1 do
   Begin
     Readln(ReadFl);
     If Eof(ReadFl) then Exit;
   End;

 WaitQuote := False;
 For CRead := 1 to Col-1 do
   Repeat
     Read(ReadFl,InChar);
     If InChar='"' then WaitQuote := not WaitQuote;
   Until ((InChar=' ') and Not WaitQuote) or Eoln(ReadFl);

 StrLen := 0;
 If Eoln(ReadFl) then Exit;

 WaitQuote := False;
 Repeat
   Read(ReadFl,InChar);
   If InChar='"' then WaitQuote := not WaitQuote;
   If (InChar<>'"') and ((InChar<>' ') or WaitQuote) then
     Begin
       Inc(StrLen);
       SetLength(ThisStr,StrLen);
       ThisStr[StrLen] := InChar;
     End;
 Until ((InChar=' ') and Not WaitQuote) or Eoln(ReadFl);

 ReadColumn := ThisStr;
End;


                 {-------------------------------------------------------------------------------}
                 {--                        BASINS(GENSCN) LINKAGE                            --}
                 {-------------------------------------------------------------------------------}


Procedure TLBasinsInfo.ExportGenScn(Linked: Boolean; ExportSeg: TAQUATOXSegment; ExportLinked: TLinkedSegs);
Var Extension,OutFile,STAFlnm     : ShortString;
    FileLoop, Loop, NumFields, CurrentHeader, TopIndex,
    OuterLoop, Num_To_Write, BottomHeader : Integer;
    OutResults : ResultsType;
    PR         : TResults;
    DP         : TDataPoint;
    SegLoop    : VerticalSegments;
    PH         : TResHeader;
    ControlResults: Boolean;
    STAFile, RDBFile    : TextFile;
    MaxFields  : Integer;
    WorkingSeg: TAQUATOXSegment;

            {-------------------------------------------------------------------------------}
            Procedure SetupFiles(Nm: ShortString);

            Begin
               Writeln(STAFile,'RDB '+Nm);
               ASSIGNFILE(RDBFile,Nm);
               Rewrite(RDBFile);
               Exit;
            End; {SetupFiles}
            {-------------------------------------------------------------------------------}
            Procedure SetupOutputFile(OFExt: String);
            Var NmLoop: Integer;
                FileBase: String;
            Begin
              Extension := LowerCase(ExtractFileExt(WorkingSeg.FileName));

              With WorkingSeg do
                If AllOtherSegs<>nil then FileBase := LegalFileName(StudyName)
                                     else FileBase := FileName;

              If SegLoop=Hypolimnion then FileBase:='Hyp_'+FileBase;
              FileBase := Output_Dir+'\'+FileBase;

              Delete(FileBase,Pos(Extension,Lowercase(FileBase)),Length(Extension));
              OutFile := FileBase + OFExt;

              NmLoop:=1;
              While FileExists(OutFile) do
                Begin
                  Inc(NmLoop);
                  OutFile := FileBase + IntToStr(NmLoop)+OFExt;
                End;

              MAXFIELDS:=100;

              WaitDlg.Update;

            End;
            {-------------------------------------------------------------------------------}
            Procedure KillSpaces(Var S: String);
            Begin
              While Pos(' ',S)>0 do
                S[Pos(' ',S)] := '_';
            End;
            {-------------------------------------------------------------------------------}
            Procedure MakeExportEntry(N: Integer; RC: TResultsCollection; FL: Integer);
            Var PH2 : TResHeader;
                LocStr, ConStr, ScenStr: String;
            Begin
              PH2 :=RC.Headers.At(N);

              If ControlResults then ScenStr := 'Control'
                                else ScenStr := 'Perturbed';
              If SegLoop=Hypolimnion then ScenStr:='Hyp_'+ScenStr;

              Writeln(RDBFile, '# Scenario: '+IntToStr(FL)+' '+ScenStr);

              LocStr := WorkingSeg.StudyName;
              KillSpaces(LocStr);
              Writeln(RDBFile, '# Location: '+IntToStr(FL)+' '+LocStr);

              ConStr:=PH2.ListStr(False);
              KillSpaces(ConStr);
              Writeln(RDBFile, '# Constituent: '+IntToStr(FL)+' '+ConStr);
            End;
            {-------------------------------------------------------------------------------}

Var Yr,Mo,Dy: Word;
    Mostr,DyStr: String;
    LinkLoop: Integer;
    EndRepeat: Boolean;

Begin
  WorkingSeg := ExportSeg;
  SetupOutputFile('.STA');
  STAFlNm := OutFile;
  ASSIGNFILE(STAFile,STAFlNm);
  Rewrite(STAFile);
  Writeln(STAFile,'MES '+ExtractFilePath(GenScnPath)+'hspfmsg.wdm');

  TeaseInc:=1;
  MAXFIELDS := 100;

  WaitDlg.Setup('Please Wait One Moment, Exporting Data');

TRY
   LinkLoop := -1;
   Repeat
    Inc(LinkLoop);
    If Linked then WorkingSeg := TAQUATOXSegment(ExportLinked.SegmentColl.At(LinkLoop))
              else WorkingSeg := ExportSeg;


       For ControlResults := False to True do
        FOR SegLoop:=Epilimnion TO Hypolimnion DO
          Begin
            BottomHeader := 0;

            If ControlResults then OutResults:=WorkingSeg.SV.ControlResults
                              else OutResults:=WorkingSeg.SV.Results;

            NumFields := OutResults[SegLoop].Headers.Count{-1};
            If (NumFields  > 0) then
              Begin
                For FileLoop:=1 to (((NumFields-1) div (MAXFIELDS-1))+1) do
                  Begin
                    SetupOutputFile('.RDB');
                    SetupFiles(OutFile);

                    {Calculate Top Field for this File}
                    If NumFields < (FileLoop*(MAXFIELDS-1))
                       then TopIndex :=(NumFields mod (MAXFIELDS-1))
                       else TopIndex := MAXFIELDS-1;

                    {Create Appropriate Fields to Export}
                    CurrentHeader:=BottomHeader-1;
                    For Loop := 1 to TopIndex do
                      Begin
                        Inc(CurrentHeader);
                        MakeExportEntry(CurrentHeader,OutResults[SegLoop],Loop+1);
                      End;

                    Write(RDBFile,'Date'+CHR(009));
                    For Loop := 1 to TopIndex do
                      Write(RDBFile,'Discharge'+CHR(009));
                    Writeln(RDBFile);
                    Write(RDBFile,'10s'+CHR(009));
                    For Loop := 1 to TopIndex do
                      Write(RDBFile,'11n'+CHR(009));
                    Writeln(RDBFile);

                    Num_to_Write := OutResults[SegLoop].Count-1;

                    For OuterLoop:=0 to Num_to_Write do
                      Begin
                        PR  :=OutResults[SegLoop].At(OuterLoop);
                        DecodeDate(PR.Date,Yr,Mo,Dy);
                        MoStr := IntToStr(Mo);
                        If Length(MoStr)=1 then MoStr := '0'+MoStr;
                        DyStr := IntToStr(Dy);
                        If Length(DyStr)=1 then DyStr := '0'+DyStr;

                        Write(RDBFile,IntToStr(yr)+'.'+MoStr+'.'+DyStr);

                        CurrentHeader:=BottomHeader-1;
                        For Loop := 1 to TopIndex do
                          Begin
                            Inc(CurrentHeader);
                            PH := OutResults[Epilimnion].Headers.At(CurrentHeader);
                            DP := PR.DataPoints.At(PH.PointIndex);
                            Write(RDBFile,CHR(009)+ FloatToStrF(DP.State,{fffixed,4,4}ffExponent,5,2));
                          End;

                          Writeln(RDBFile);

                        Inc(TeaseInc);
                        If TeaseInc=11 then Begin WaitDlg.Tease; TeaseInc:=1; End;
                      End; {outerloop}


                    CloseFile(RDBFile);

                    BottomHeader:=CurrentHeader+1;  {For next File}

                 End; {FileLoop}

             END; {If Not NoResults}
        END; {For SegLoop:=Epilimnion to Hypolimnion}

    If Linked then EndRepeat := (LinkLoop = ExportLinked.SegmentColl.Count-1)
              else EndRepeat := True;
  Until EndRepeat;

    WaitDlg.Hide;
    CloseFile(STAFile);

    ExecuteFile(GenScnPath,STAFlNm,'',SW_SHOW);

  EXCEPT
    WaitDlg.Hide;
    Try
      CloseFile(RDBFile);
    Except
    End;
    Try
      CloseFile(STAFile);
    Except
    End;
  END;

End;



Procedure TLBasinsInfo.GetParams;
var ThisDir: String;
Begin
 GetDir(0,Thisdir);
 GISBaseFile := ParamStr(2);
 If GISBASEFILE[2] <> ':' then GISBaseFile := ThisDir[1]+ThisDir[2]+GISBASEFILE;
 WDMFile     := ParamStr(3);
 Scenario    := ParamStr(4);
 Location    := ParamStr(5);
 AvgStr      := ParamStr(6);

End;  


                 {-------------------------------------------------------------------------------}
                 {--                        BASINS(ARCVIEW) LINKAGE                            --}
                 {-------------------------------------------------------------------------------}



Procedure TLBasinsInfo.Get_BASINS_Linkage(Var LinkStudy: TAQUATOXSegment; HSPF: Boolean);
Var FlLine: Integer;
    ReachNum: String;

         {-------------------------------------------------------------------------------}
         Function Find_Basins_Files: Boolean;
         Var i: Integer;
             AddOn: String;
             Ch: Char;
         Begin
          Find_Basins_Files := True;

          If (Not FileExists(GISBaseFile+'.rch')) then
            Begin
              AddOn := '';
              For i := length(GISBaseFile) downto 1 do
                Begin
                  Ch := GISBasefile[i];
                  If not (Ch in ['/','\',':'])
                    Then AddOn := Ch + AddOn
                    else Break;
                End;
              GISBaseFile := GISBaseFile + '\'+AddOn
            End;

          If (Not FileExists(GISBaseFile+'.rch')) or
             (Not FileExists(GISBaseFile+'.ptf')) or
             (Not FileExists(GISBaseFile+'.psr')) then
                   Begin
                     If Not HSPF

                       then MessageDlg('Error finding BASINS GIS files, e.g. "'+GISBaseFile+'.rch".  No GIS data will be read.', mterror,[mbok],0)
                       else
                         Begin
                           MessageDlg('No BASINS GIS Files are associated with this HSPF simulation.  Channel Geometry data will not be read.  See log file for more information.', mtinformation,[mbok],0);
                           Writeln(LogF);
                           Writeln(LogF,'No BASINS GIS Files were found associated with HSPF simulation.');
                           Writeln(LogF,'   Note: Channel Length, Channel Slope, Channel Depth, and Maximum Depth data were not read from GIS files.');
                         End;
                       Find_Basins_Files := False;
                   End;
         End;
         {-------------------------------------------------------------------------------}
         Procedure OpenLogFile;
         Var BaseName: String;
             Indx: Integer;
         Begin
           LogFName := OUTPUT_DIR+'\'+'AQT_LINK_LOG_GIS';
           BaseName := LogFName;
           Indx := 1;
           While FileExists(LogFName+'.txt') do
             Begin
               Inc(Indx);
               LogFName := BaseName + '_'+IntToStr(Indx);
             End;

           AssignFile(LogF,LogFName+'.txt');

           Rewrite(LogF);
           Writeln(LogF,'GIS LAYER - AQUATOX: BASINS Linkage Log');
           Writeln(LogF);
           Writeln(LogF,'Linkage Time:   '+ DateTimeToStr(Now));
         End;
         {-------------------------------------------------------------------------------}
         Function FindLine(LineStart,ColNum:Integer;MatchStr: String): Integer;
         Var FoundNum,LineNum: Integer;
             ReadStr: String;
         Begin
           FoundNum := -1;
           LineNum := LineStart-1;
           Repeat
             Inc(LineNum);
             ReadStr := ReadColumn(LineNum,ColNum);
             If (ReadStr=MatchStr) then FoundNum := LineNum;
           Until (ReadStr=MatchStr) or (ReadStr='');
           FindLine := FoundNum;
         End;
         {-------------------------------------------------------------------------------}
         Procedure Read_Reach_File;
         Var RchErr: Boolean;
             ReadStr,ReachName: String;
         Begin
            Try
              RCHErr := False;
              AssignFile(ReadFl,GISBaseFile+'.rch');
              Reset(ReadFl);
            Except
              RCHErr := True;
              Writeln(LogF, 'Error Attempting to Read Reach File '+GISBaseFile+'.rch');
            End;

            If not RchErr then
              If HSPF
                then
                  Begin
                    ReachNum := Location[4];
                    FlLine := FindLine(2,1,ReachNum) ;
                    If FlLine=-1 then
                      Begin
                        Writeln(LogF, 'Error Reading Reach File:  Reach Number '+ReachNum+' not Found.');
                        RchErr := True;
                        CloseFile(ReadFl);
                      End;
                  End
                else FlLine := 2;

            If not RchErr then
              TRY
                {Reach Name}
                ReachName := ReadColumn(FlLine,2);
                If ReachName<>'' then
                  Begin
                    If HSPF then LinkStudy.StudyName := Scenario+': '+ReachName
                            else LinkStudy.StudyName := ReachName;
                    LinkStudy.Location.Locale.SiteName := ReachName;
                    Writeln(LogF, 'Reach Name Identified as '+ReachName);
                  End;

                {Reach Num}
                If Not HSPF then
                  Begin
                    ReachNum := ReadColumn(FlLine,1);
                    Writeln(LogF, 'Reach Number Identified as '+ReachNum);
                  End;

                {Site Type}
                ReadStr := ReadColumn(FlLine,7);
                If (ReadStr[1]='R') or (ReadStr[1]='r')
                  then
                    Begin
                      LinkStudy.Location.SiteType := Reservr1D;
                      Writeln(LogF, 'Reach Type Identified as RESERVOIR');
                    End
                  else
                    Begin
                      LinkStudy.Location.SiteType := Stream;
                      Writeln(LogF, 'Reach Type Identified as STREAM');
                    End;

                CloseFile(ReadFl);
              EXCEPT
                TRY
                CloseFile(ReadFl);
                EXCEPT
                END;
              END;
          End; {Read_Reach_File}
         {-------------------------------------------------------------------------------}
         Function ReadVal(Col:Integer;Var Conv: Double;FieldNm:String):Boolean;
         Var ReadStr: String;
             Reslt: Integer;
         Begin
            ReadVal := False;
            ReadStr := ReadColumn(FlLine,Col);
            Conv := 0;
            If (ReadStr<>'') then Val(Trim(ReadStr),Conv,Reslt);
            If (ReadStr = '') or (Reslt <> 0)
              then Writeln(LogF, 'Incorrect Numerical Format when Reading "'+FieldNm+'".')
              else if Conv<=0
                then Writeln(LogF, 'Zero or negative value encountered when Reading "'+FieldNm+'".  Value ignored.')
                else ReadVal := True;
         End;
         {-------------------------------------------------------------------------------}
         Procedure Read_Geo_File;
         Const Feet_to_M : Double = 0.3048;
         Var GeoErr: Boolean;
             Conv: Double;
             GeoNum: String;

         Begin
            Try
              GeoErr := False;
              AssignFile(ReadFl,GISBaseFile+'.ptf');
              Reset(ReadFl);
            Except
              GeoErr := True;
              Writeln(LogF, 'Error Attempting to Read Channel Geometry File '+GISBaseFile+'.ptf');
            End;

            If not GeoErr then
              If HSPF
                then
                  Begin
                    GeoNum := Location[4];
                    FlLine := FindLine(2,1,GeoNum) ;
                    If FlLine=-1 then
                      Begin
                        Writeln(LogF, 'Error Reading Geometry File:  Reach Number '+GeoNum+' not Found.');
                        GeoErr := True;
                        CloseFile(ReadFl);
                      End;
                  End
                else FlLine := 2;

            If not GeoErr then
              TRY
                {Channel Length}
                If ReadVal(2,Conv,'Length(ft)')
                  then Begin
                         Conv := RoundDec(5,Conv * Feet_to_M * 1e-3);
                         {KM}               {ft}    {M / ft}  {KM/M}
                         LinkStudy.Location.Locale.SiteLength := Conv;
                         LinkStudy.Location.Locale.XLength := 'BASINS Channel Geometry File';
                         Writeln(LogF, 'Channel Length Read As '+ FloatToStrF(Conv,ffexponent,4,4)+' KM.')
                       End;

                {Mean Depth}
                If HSPF and AvDepRead
                  then Writeln(LogF, 'Mean Depth data from HSPF used rather than from Channel Geometry File.')
                  else
                    Begin
                      If ReadVal(3,Conv,'Mean Depth(ft)')
                        then Begin
                                Conv := RoundDec(5,Conv * Feet_to_M);
                                {M}               {ft}    {M / ft}
                                LinkStudy.Location.Locale.ICZMean := Conv;
                                LinkStudy.Location.Locale.XZMean := 'BASINS Channel Geometry File';
                                Writeln(LogF, 'Mean Depth Read As '+ FloatToStrF(Conv,ffexponent,4,4)+' M.')
                              End;
                    End;

             (*   {Channel Width Not Currently an AQUATOX Parameter}
                If ReadVal(4,Conv,'Mean Width(ft)')
                  then Begin
                         Conv := RoundDec(5,Conv * Feet_to_M);
                         {M}               {ft}    {M / ft}
                         {LinkStudy.Location.Locale. := Conv; }
                         Writeln(LogF, 'Channel Width Read As '+ FloatToStrF(Conv,ffexponent,4,4)+' M.')
                       End;  *)

(*                {Manning's Coeff is currently hard-wired into GIS files}
                If ReadVal(5,Conv,'Mannings Coeff.')
                  then Begin
                         LinkStudy.Location.Locale.UseEnteredManning := True;
                         LinkStudy.Location.Locale.EnteredManning := Conv;
                         Writeln(LogF, 'Mannings Coeff. Read As '+ FloatToStrF(Conv,ffexponent,4,4)+' s/m(1/3).')
                       End; *)

                {Channel Slope}
                If ReadVal(6,Conv,'Long. Slope')
                  then Begin
                         LinkStudy.Location.Locale.Channel_Slope := Conv;
                         LinkStudy.Location.Locale.XChannel_Slope := 'BASINS Geometry File';
                         Writeln(LogF, 'Channel Slope Read As '+ FloatToStrF(Conv,ffexponent,4,4)+' m/m.')
                       End;

                {Channel Depth}
                If ReadVal(16,Conv,'Channel Depth(ft)')
                  then Begin
                         Conv := RoundDec(5,Conv * Feet_to_M);
                         {M}               {ft}    {M / ft}
                         LinkStudy.Location.Locale.Max_Chan_Depth := Conv;
                         LinkStudy.Location.Locale.XMax_Chan_Depth := 'BASINS Channel Geometry File';
                         Writeln(LogF, 'Channel Depth Read As '+ FloatToStrF(Conv,ffexponent,4,4)+' M.')
                       End;

                {Maximum Depth}
                With LinkStudy.Location.Locale do
                   Begin
                     ZMax := ICZMean * 1.7;
                     XZMax := 'Assumed 1.7 times Mean Depth';
                     Writeln(LogF, 'Maximum Depth Assumed to be 1.7 times Mean Depth: '+ FloatToStrF(ZMax,ffexponent,4,4)+' M.')
                   End;

                CloseFile(ReadFl);
              EXCEPT
                TRY
                CloseFile(ReadFl);
                EXCEPT
                END;
              END;
          End; {Read_Geo_File}
         {-------------------------------------------------------------------------------}
         Procedure Read_PtSrc_File;
         Const Feet_to_M : Double = 0.3048;
         Var PtsrcErr: Boolean;
             Conv: Double;
             NumFacStr: String;
             Rslt,Rdln, NumFac, FacLoop, NumPts: Integer;
             InRch: Array of Boolean;
             FacNm: Array of String;
             PtSrc: Array of Double;
             AddTxt: String;
             FoundAny: Boolean;
             ReadLdNm, ReadPts,ReadStr: String;
             longest : LongInt;
         Begin
            Try
              If HSPF then ReachNum := Location[4];
              PtsrcErr := False;
              AssignFile(ReadFl,GISBaseFile+'.psr');
              Reset(ReadFl);
            Except
              PtsrcErr := True;
              Writeln(LogF, 'Error Attempting to Read GIS Point-Source File '+GISBaseFile+'.psr');
            End;

           NumFac := 0;
           If not PtSrcErr then
              Try
                Readln(ReadFl,NumFacStr);
                NumFac := StrToInt(NumFacStr);
              Except
                Writeln(LogF, 'Error Attempting to Read Number of Facilities in GIS Point-Source File.');
                PtsrcErr := True;
              End;

           If not PtSrcErr then
              TRY
                FoundAny := False;
                SetLength(InRch,NumFac);
                SetLength(FacNm,NumFac);

                For FacLoop := 1 to NumFac do
                  Begin
                    ReadStr := ReadColumn(3+FacLoop,3) ;
                    InRch[FacLoop-1] := ReadStr=ReachNum;
                    If ReadStr=ReachNum then
                      Begin
                        FoundAny := True;
                        FacNm[FacLoop-1] := ReadColumn(3+FacLoop,1);
                      End;
                  End;

                longest := 0;  {in case horz scrollbar necc for tlistbox}
                If Not FoundAny
                  then Writeln(LogF, 'No Facilities within the GIS Point-Source File are within the Selected Reach.')
                  else
                    Begin
                      Application.CreateForm(TImport_PS, Import_PS);
                      Try
                        RdLn := 6+NumFac;
                        NumPts := 0;
                        Repeat
                          ReadStr := ReadColumn(RdLn,1);
                          ReadLdNm := ReadColumn(RdLn,2);
                          If (ReadStr<>'') and (Lowercase(ReadLdNm)<>'flow') then
                            If InRch[StrToInt(ReadStr)] then
                              Begin
                                Inc(NumPts);
                                SetLength(PtSrc,NumPts);
                                ReadPts := ReadColumn(RdLn,3);
                                Val(Trim(ReadPts),Conv,Rslt);
                                     If (ReadPts = '') or (Rslt <> 0)
                                        then Begin
                                               Writeln(LogF, 'Error, Incorrect Numerical Format when Reading Point Source File on Line '+IntToStr(RdLn));
                                               Conv := 0;
                                             End;
                                PtSrc[NumPts-1] := Conv;

                                AddTxt := FacNm[StrToInt(ReadStr)] +': '+ReadLdNm;
                                Import_PS.BasinsPsBox.Items.Add(AddTxt);
                                If Import_PS.BasinsPsBox.Canvas.TextWidth(addTxt) > longest then
                                   longest := Import_PS.BasinsPsBox.Canvas.TextWidth(addTxt);
                              End;
                          Inc(RdLn);
                        Until ReadStr = '';

                        If NumPts<1
                          then Writeln(LogF, 'No relevant point source data in GIS point-source file (flow data only).')
                          else
                            Begin
                              SendMessage(Import_PS.BasinsPsBox.Handle, lb_SetHorizontalExtent, longest + 20, 0); {in case horz scrollbar necc for tlistbox}
                              Import_PS.PLogF := @LogF;
                              Import_PS.Import(LinkStudy,PtSrc);
                            End;

                      Finally
                        Import_PS.Hide;
                        Import_PS.Free;
                      End;
                    End;

                InRch := nil;
                FacNm := nil;
                CloseFile(ReadFl);
              EXCEPT
                TRY
                InRch := nil;
                FacNm := nil;
                CloseFile(ReadFl);
                EXCEPT
                END;
              END;

         End;
         {-------------------------------------------------------------------------------}

Begin
  GetParams;
  If Not Find_Basins_Files then
    Begin
      If HSPF then Try CloseFile(LogF); Except End;
      If HSPF then LinkStudy.NewNotes.Add('Simulation created from BASINS HSPF Linkage.  LogFile:~'+LogFName);
      exit;
    End;

  If Not HSPF then OpenLogFile; {otherwise already opened}

  If LinkStudy=nil then
  Begin
    GetLinkStudy(LinkStudy,'GISLink');
    LinkStudy.Location.Locale.SiteComment := 'BASINS GIS Linkage';
  End;

  Writeln(LogF);
  Writeln(LogF, 'Base GIS File Name: '+GISBaseFile);

  Read_Reach_File;
  Read_Geo_File;

{  If Not HSPF
    then Read_PtSrc_File
    else Writeln(LogF, 'Point Source Data already gathered from HSPF linkage.  Will not read '+GISBaseFile+'.PSR file.'); }

  If HSPF then LinkStudy.NewNotes.Add('Simulation created from BASINS HSPF Linkage.  LogFile:~'+LogFName)
          else LinkStudy.NewNotes.Add('Simulation created from BASINS GIS Linkage.  LogFile:~'+LogFName);

  TRY
    CloseFile(LogF);
  EXCEPT
  END;
End;

                 {-------------------------------------------------------------------------------}
                 {--                            HSPF LINKAGE                                   --}
                 {-------------------------------------------------------------------------------}

Procedure TLBasinsInfo.Get_HSPF_Linkage(Var LinkStudy: TAQUATOXSegment; FromParams: Boolean);

Var TserFiles: ATCPlugInManager;
    LinkStr: String;
    hHassEnt: THandle;
    ProjectWDMFile: _clsTSerWDMDisp;
    ProjTSRFile: _ATCclsTserFileDisp;
    ATCData1,ATCData2,ATCData3 : _ATCclsTserDataDisp;
    Pct_Particulate, Pct_Refr: Double;
    LoadingsPtr: PLoadingsRecord;
    PVol,PSV   : TStateVariable;
    PD         : TDissRefrDetr;
    VolumeReadOK : Boolean;
    Indx2      : LongInt;
    LastTease  : TDateTime;
    Multiplier : Double;
    AddPO4,AddPPO4,AddTORP,AddTotP, IsTotP: Boolean;
    PFracAvail: Double;


                 {-------------------------------------------------------------------------------}
                 Function FindWDMFile: Boolean;
                 Begin
                   FindWDMFile := True;

                   If (Not FileExists(WDMFile)) then
                     Begin
                       MessageDlg('Error, can''t find WDM file '+WDMFile+'.  Linkage will not continue.',
                                   mterror,[mbok],0);
                       FindWDMFile := False;
                     End;
                 End;
                 {-------------------------------------------------------------------------------}
                 Function Ensure_HassEnt_Installed: Boolean;
                 Begin
                    hHassEnt := LoadLibrary('hass_ent.dll');
                    if (hHassEnt < 32)
                      then
                        begin
                          Result := False;
                          Exit;
                        end;

                    Result := True;

                    @_F90_WDBOPN  := GetProcAddress(hHassEnt, 'F90_WDBOPN');
                    If @_F90_WDBOPN = nil then Result := False;

                    @_F90_W99OPN  := GetProcAddress(hHassEnt, 'F90_W99OPN');
                    If @_F90_W99OPN = nil then Result := False;

                    @_F90_W99CLO  := GetProcAddress(hHassEnt, 'F90_W99CLO');
                    If @_F90_W99CLO = nil then Result := False;
                 End;
                 {-------------------------------------------------------------------------------}

                 Function OpenWDMForRead: Boolean;
                 Var WS : Widestring;
                     TserIndex, Ln: Integer;
                     Found: Boolean;
                     Name: PChar;
                     DataIndex: Integer;
                     Buff : Array[0..255] of char;
                     li: LongInt;
                     HspfMsgUnit, NumDataSets: Integer;
                     Reg: TRegistry;
                     ErrStr,HSPFDir,ReadScen,ReadLoc: String;

                     {-------------------------------------------------------------------------------}
                     Function SelectScenandLoc: Boolean;
                     Var NewDataIndex: Integer;
                     Begin
                        Result := False;
                        Application.CreateForm(TSWATbasin, SWATbasin);
                        With SwatBasin do
                          Begin

                            SwatBasin.Caption := 'Select Location within WDM File';
                            SwatBasin.Label1.Caption := 'Please select a Location within the Specified WDM File';

                            Combobox1.Items.Clear;
                            NewDataIndex:= DataIndex;

                             Repeat
                               Dec(NewDataIndex);
                               ATCData1 := ProjTSRFile.Data[NewDataIndex] as _ATCclsTserDataDisp;
                               { Read 'scenario, location', compare to passed parameters}
                               ReadScen  := ATCData1.Header.Sen;
                               ReadLoc   := ATCData1.Header.Loc;

                               If ComboBox1.Items.Indexof(ReadLoc) = -1 then
                                 ComboBox1.Items.Add(ReadLoc);

                             Until (NewDataIndex = 1);
                            Combobox1.ItemIndex := 0;

                            If ShowModal = MRCancel then Exit;
                            Location := ComboBox1.Text;

                            SwatBasin.Caption := 'Select Scenario';
                            SwatBasin.Label1.Caption := 'Please select Scenario for that Location';

                            Combobox1.Items.Clear;
                            NewDataIndex:= DataIndex;
                             Repeat
                               Dec(NewDataIndex);
                               ATCData1 := ProjTSRFile.Data[NewDataIndex] as _ATCclsTserDataDisp;
                               { Read 'scenario, location', compare to passed parameters}
                               ReadScen  := ATCData1.Header.Sen;
                               ReadLoc   := ATCData1.Header.Loc;

                               If (ReadLoc = Location) and (ComboBox1.Items.Indexof(ReadScen) = -1) then
                                 ComboBox1.Items.Add(ReadScen);

                             Until (NewDataIndex = 1);
                            Combobox1.ItemIndex := 0;

                            If ShowModal = MRCancel then Exit;
                            Scenario := ComboBox1.Text;

                            Result := True;
                          End;
                     End;
                     {-------------------------------------------------------------------------------}


                 Begin
                    OpenWDMForRead := True;
                  {'open unit 99 for messages   }
                    If Not Ensure_HassEnt_Installed then
                       Raise EAQUATOXERROR.Create ('Can''t perform BASINS linkage, HASS_ENT.DLL not installed.  Check BASINS installation.');

                    _F90_W99OPN;

                  {'open the wdm file
                    Set TserFiles = New ATCData.ATCPlugInManager }

                    TserFiles := coATCPlugInManager.create;
                    WS := 'ATCTSfile';
                    TserFiles.Load(WS);
                    WS := 'clsTSerWDM';
                    TserIndex := TserFiles.AvailIndexByName(WS);
                    TserFiles.Create(TserIndex);
                    ProjectWDMFile := TserFiles.CurrentActive.obj as _clsTSerWDMDisp;
                    ProjTSRFile := TserFiles.CurrentActive.obj as _ATCclsTserFileDisp;

                    Reg := TRegistry.Create;
                    with Reg do
                      begin
                        RootKey := HKEY_LOCAL_MACHINE;
                        If OpenKey('SOFTWARE\AQUA TERRA Consultants\GenScn\ExePath', false)
                          then HSPFDir := ReadString('')
                          else
                            Begin
                              OpenWDMForRead := False;
                              MessageDlg('Error, can''t locate HSPF using Windows Registry.  Linkage will not continue.',
                                            mterror,[mbok],0);
                              Reg.Free;
                              Exit;
                            End;
                        Free;
                      end; {with Reg}

                    HSPFDir := HSPFDir + '\hspfmsg.wdm';
                    Ln := Length(HSPFDir);
                    Name := Buff;
                    StrPCopy(Name,HSPFDir);

                    Li := 1;
                    HspfMsgUnit := _F90_WDBOPN(Li, Name, Ln);
                    ProjectWDMFile.MsgUnit := HSPFMsgUnit;
                    ProjTSRFile.Filename := WDMFile;

                    ErrStr := ProjTSRFile.ErrorDescription;
                    If Length(ErrStr) > 0 Then
                       Begin
                         MessageDlg('Error "'+ErrStr+'" encountered when opening WDM file.'+
                            '  Linkage will not continue.', mterror,[mbok],0);
                         OpenWDMForRead := False;
                         Exit;
                       End;

                    NumDataSets := ProjTSRFile.DataCount;
                    DataIndex := NumDataSets+1;

                    If NumDataSets=0 then
                      Begin
                         MessageDlg('Error: There are no data series in HSPF file.'+
                                    '  Linkage will not continue.', mterror,[mbok],0);
                         OpenWDMForRead := False;
                         Exit;
                      End;

                    If Scenario = ''
                      then If Not SelectScenandLoc then Begin OpenWDMForRead := False; exit; End;  //set scenario and location string variables

                    Repeat
                      Dec(DataIndex);
                      ATCData1 := ProjTSRFile.Data[DataIndex] as _ATCclsTserDataDisp;

                      { Read 'scenario, location', compare to passed parameters}
                      ReadScen  := ATCData1.Header.Sen;
                      ReadLoc   := ATCData1.Header.Loc;

                      Found := (Scenario=ReadScen) and (Location=ReadLoc);
                    Until Found or (DataIndex = 1);

                    If Not Found then
                      Begin
                         MessageDlg('Can''t find appropriate Scenario/Location within the WDM file. '+
                            '  Scenario '+Scenario+'; Location '+Location +'. '+
                            '  Linkage will not continue.', mterror,[mbok],0);
                         OpenWDMForRead := False;
                         Exit;
                      End;

                {    MessageDlg( GISBaseFile + ' '+WDMFile+ ' '+ Scenario+ ' '+ Location,mtinformation,[mbok],0); }


                 End;
                 {-------------------------------------------------------------------------------}
                 Function Find_Time_Series(FindConst: String; Var ReturnData: _ATCclsTserDataDisp): Boolean;
                 Var  ReadScen,ReadLoc,ReadConst: String;
                      Found: Boolean;
                      D1,D2: Double;
                      Tmp:_ATCclsTserDataDisp;
                      DataIndex, NumDataSets: Integer;
                      DS :  ATTimSerDateSummary;

                 Begin
                    NumDataSets := ProjTSRFile.DataCount;
                    DataIndex := NumDataSets+1;

                    If NumDataSets=0 then Raise EAQUATOXERROR.Create('DataCount in HSPF File equals zero.');

                    Repeat
                      Dec(DataIndex);

                      D1 :=  LinkStudy.PSetup.FirstDay + 15019-1; {15019 moves between HSPF and Delphi Date Units}
                      D2 :=  LinkStudy.PSetup.LastDay  + 15019;   {15019 moves between HSPF and Delphi Date Units}

                      Tmp := ProjTSRFile.Data[DataIndex] as _ATCclsTserDataDisp;

                      { Read 'scenario, location', compare to passed parameters}
                      ReadScen  := Tmp.Header.Sen;
                      ReadLoc   := Tmp.Header.Loc;
                      ReadConst := Tmp.Header.Con;

                      Found := (Scenario=ReadScen) and (Location=ReadLoc) and (ReadConst=FindConst);
                    Until Found or (DataIndex = 1);
                    Find_Time_Series := Found;
                    If Found then ReturnData := Tmp.SubSetByDate(D1,D2) as _ATCclsTserDataDisp;

                    If (Now - LastTease) > 1.16e-5 {one second}
                      then
                        Begin
                          LastTease := Now;
                          WaitDlg.Tease;
                        End;

                   If Found then
                     Begin
                       DS := ReturnData.Dates.Summary;
                       if (DS.Tu<>4) and (DS.Tu<>3) then
                          Begin
                             Writeln(LogF,'"'+FindConst+'" Error: HSPF-AQUATOX Linkage currently requires daily or hourly units within HSPF.');
                             Result := False;
                          End;
                     End;

                 End;
                 {-------------------------------------------------------------------------------}
                 Function Get_IC_From_Time_Series(HSPFConst: String; Var OutVal: Double): Boolean;
                 Var Indx : LongInt;
                 Begin
                    Get_IC_From_Time_Series := False;
                    OutVal := 0;
                    If Find_Time_Series(HSPFConst,ATCData1)
                      then
                        If ATCData1.Dates.Summary.NVALS>0 then
                          Begin
                            Indx := 1;
                            OutVal := ATCData1.Value[Indx];
                            If OutVal<0 then OutVal := 0;
                            Get_IC_From_Time_Series := True;
                          End;
                 End;
                 {-------------------------------------------------------------------------------}
                 Function Get_Avg_Val_From_Time_Series(HSPFConst: String; Var OutVal: Double): Boolean;
                 Var Indx: LongInt;
                     NumVals: Integer;
                     Val,SumVals: Double;
                 Begin
                    Get_Avg_Val_From_Time_Series := False;
                    SumVals :=0;
                    Indx := 0;
                    If Find_Time_Series(HSPFConst,ATCData1)
                      then
                        If ATCData1.Dates.Summary.NVALS>0
                          then
                            Begin
                              NumVals := ATCData1.Dates.Summary.NVALS;
                              Repeat
                                Inc(Indx);
                                Val := ATCData1.Value[Indx];
                                If Val>0 then SumVals := SumVals + Val;
                              Until Indx=NumVals;
                              OutVal := SumVals / NumVals;
                              Get_Avg_Val_From_Time_Series := True;
                            End
                 End;

                 {-------------------------------------------------------------------------------}
                 Function GetUnits: String;
                 Var UnitName, UnitDefault: WideString;
                 Begin
                    UnitName := 'Units';
                    UnitDefault := 'Unknown';
                    Result := ATCData1.Attrib[UnitName,UnitDefault];
                 End;
                 {-------------------------------------------------------------------------------}
                 Function CheckUnits(Var Expected: Boolean; ExpectUnits, SeriesName: String): Boolean;
                 Var
                     UnitStr: String;
                 Begin
                    Result := True;
                    Expected := (Not FromParams) and (Not VolumeReadOK);
                    If Expected then
                      Begin  {check units}
                        UnitStr := GetUnits;
                        If lowercase(UnitStr) <> lowercase(ExpectUnits) then
                          Begin
                            If lowercase(UnitStr) <> 'unknown'
                              then if MessageDlg('Expecting Units "ExpectUnits" but received units "'+UnitStr+
                                                  '".  Continue with linkage?',mtconfirmation,[mbyes,mbno],0) = mrno
                                then
                                  Begin
                                    Writeln(LogF,SeriesName+' timeseries could not be read-- Expecting Units "ExpectUnits" but received units "'+UnitStr);
                                    Result := False;
                                    Exit;
                                  End;

                            Writeln(LogF,SeriesName+' units are '+UnitStr+' assuming "'+ExpectUnits+'."');
                          End;
                      End; {MGperL}
                 End;

                 {-------------------------------------------------------------------------------}

                  Procedure ReadObserved(HSPFConst: String);
                  Var ActStr: String;
                      ReadName : String[40];
                      PSeg: TAQUATOXSegment;
                      TOS: TObservedSeries;
                      OD : TObservedData;
                      Indx: LongInt;
                      HourlyData: Boolean;
                      ThisTime: TDateTime;
                      i, j, NumVals,NumInDay: Integer;
                      Value, AvgVal: Double;
                  Begin
                    If not Find_Time_Series(HSPFConst,ATCData1) then Exit;
                    PSeg:=LinkStudy;

                    HourlyData :=  ATCData1.Dates.Summary.Tu<>4;
                    NumVals := ATCData1.Dates.Summary.NVALS;

                    TOS := nil;
                    ActStr := 'Overwrote';
                    OD := PSeg.SV.ObservedData;
                    ReadName := HSPFConst;
                    For j := 0 to OD.NumSeries-1 do
                      If lowercase(OD.OSeries[j].NameStr) = lowercase(ReadName)
                        then TOS := OD.OSeries[j];

                    If TOS=nil then
                      Begin
                        ActStr := 'Added';
                        Inc(OD.NumSeries);
                        Dec(OD.CurrentIndex);
                        If (OD.NumSeries > Length(OD.OSeries)) then
                          SetLength(OD.OSeries,Length(OD.OSeries)+5);
                        OD.OSeries[OD.NumSeries-1] := TObservedSeries.Create(OD.CurrentIndex);
                        TOS := OD.OSeries[OD.NumSeries-1];
                      End;

                    TOS.InitLength(100);
                    TOS.NameStr := ReadName;
                    TOS.UnitStr := GetUnits;
                    TOS.Comment := LinkStr;
                    TOS.HasNDs := False;

                    i := 0;
                    AvgVal := 0;
                    Indx :=  0;
                    NumInDay := 0;
                    Repeat
                      Inc(Indx);
                      Inc(NumInDay);
                      Value := ATCData1.Value[Indx];

                      ThisTime := ATCData1.Dates.Value[Indx] - 15019; {move between HSPF and Delphi Date Units}
                      If HourlyData then ThisTime := ThisTime + 23/24; {correct apparent lag}

                      If (not HourlyData)
                        then
                          Begin
                            Inc(i);
                            If i>Length(TOS.ObsDates) then TOS.AddLength;
                            TOS.NumRecs := i;
                            TOS.ObsDates[i-1] := ThisTime;
                            TOS.ObsVals[i-1] :=  Value;
                          End
                        Else {HourlyData}
                          Begin
                            AvgVal := AvgVal + Value;
                            If (Round(ThisTime*24) mod 24)= 23 then {11pm}
                              Begin
                                AvgVal := AvgVal/NumInDay;
                                Inc(i);
                                If i>Length(TOS.ObsDates) then TOS.AddLength;
                                TOS.NumRecs := i;
                                TOS.ObsDates[i-1] := Trunc(ThisTime);
                                TOS.ObsVals[i-1] :=  AvgVal;
                                NumInDay := 0;
                                AvgVal := 0;
                              End;
                          End;
                    Until (Indx=NumVals);

                    Writeln(LogF,(ActStr + ' Observed Data: ' + TOS.NameStr+' ('+TOS.UnitStr+')'));


                  End;

                 {-------------------------------------------------------------------------------}

                 Procedure Import_Time_Series(SeriesName,HSPFConst: String; Var ILoad: PLoadingsRecord; MultFactor: Double; TSV: TStateVariable);
                 Var ThisTime: TDateTime;
                     Indx: LongInt;
                     NumVals,NumInDay: Integer;
                     Value: Double;
                     HourlyData, IsVolume: Boolean;
                     NewLoad:     TLoad;
                     AvgVal: Double;
                     DegF : Boolean;
                 Begin
                    If Find_Time_Series(HSPFConst,ATCData1)
                      then
                        Begin
                          HourlyData :=  ATCData1.Dates.Summary.Tu<>4;
                          NumVals := ATCData1.Dates.Summary.NVALS;
                          IsVolume := (HSPFConst='VOL') { or (HSPFConst='VOLUME') };

                          If NumVals=0 then
                            Begin
                              Writeln(LogF,SeriesName+' timeseries could not be read,"'+HSPFConst+'" timeseries has zero datapoints');
                              Exit;
                            End;

                          DegF := False;
                          If HSPFConst = 'TW' then If (Pos('f',(Lowercase(GetUnits)))>0) then DegF := True;


                          ILoad.Loadings.Destroy;
                          ILoad.Loadings:=TLoadings.Init(Numvals,50);

                          ILoad.UseConstant := False;
                          ILoad.MultLdg := 1;

                          If HSPFConst='SSD1' then
                            Begin
                              Find_Time_Series('SSD2',ATCData2);
                              Find_Time_Series('SSD3',ATCData3);
                            End;

                          AvgVal := 0;
                          Indx :=  0;
                          NumInDay := 0;
                          Repeat
                            Inc(Indx);
                            Inc(NumInDay);
                            Value := ATCData1.Value[Indx] * MultFactor;

                            If DegF then Value := (Value - 32) * 5/9;

                            If HSPFConst='SSD1' then
                              Value := (ATCData1.Value[Indx] + ATCData2.Value[Indx] + ATCData3.Value[Indx]) * MultFactor;
                                               {SSD1}                   {SSD2}                    {SSD3}

                            If Value<0 then Value := 0;
                            ThisTime := ATCData1.Dates.Value[Indx] - 15019; {move between HSPF and Delphi Date Units}
                            If HourlyData then ThisTime := ThisTime + 23/24; {correct apparent lag}

                            If (Not IsVolume) and (not HourlyData)
                              then
                                Begin
                                  NewLoad:= TLoad.Init(ThisTime,Value);
                                  ILoad.Loadings.Insert(NewLoad);
                                End
                              Else {IsVol or HourlyData}
                                Begin
                                  AvgVal := AvgVal + Value;
                                  If (Round(ThisTime*24) mod 24)= 23 then {11pm}
                                    Begin
                                      AvgVal := AvgVal/NumInDay;
                                      NewLoad:= TLoad.Init(Trunc(ThisTime),AvgVal);
                                      ILoad.Loadings.Insert(NewLoad);
                                      NumInDay := 0;
                                      AvgVal := 0;
                                    End;
                                End;
                          Until (Indx=NumVals);


                          Writeln(LogF,SeriesName+' timeseries read into AQUATOX.');
                          If HSPFConst='SSD1' then
                            Begin
                              Writeln(LogF,'   Note:  TSS is calculated as the sum of Sand, Silt, and Clay concentrations in the water column');
                              TSV.LoadNotes1 :=  LinkStr;
                            End;
                          If IsVolume or HourlyData then
                              Writeln(LogF,'   Note:  Hourly data are averaged to get daily data.');
                          If DegF then
                              Writeln(LogF,'   Note:  "TW" data converted from F to C.');
                        End
                      else Writeln(LogF,SeriesName+' timeseries could not be read, no "'+HSPFConst+'" data found');
                 End;
                 {-------------------------------------------------------------------------------}
                 Function Import_DynLoad(SeriesName,HSPFConst: String; Var TLoadg: TLoadings; MultFactor: Double): Boolean;
                 Var ThisTime: TDateTime;
                     Indx    : LongInt;
                     NumVals, NumInDay : Integer;
                     AvgVal, Value   : Double;
                     NewLoad :  TLoad;
                     FtUnits, Found, HourlyData: Boolean;
                 Begin
                    Import_DynLoad := False;
                    FtUnits := False;
                    Found := Find_Time_Series(HSPFConst,ATCData1);
                    If Not Found then
                      Begin
                        If HSPFConst = 'AVDP' then HSPFConst  := 'AVDEP';
                        Found := Find_Time_Series(HSPFConst,ATCData1);
                        If Not Found
                          then HSPFConst := 'AVDP'
                          else Begin
                                 If Not CheckUnits(FtUnits,'ft',SeriesName) then exit;
                                 MultFactor := 0.3048;
                               End;
                      End;

                    If Found
                      then
                        Begin
                          NumVals := ATCData1.Dates.Summary.NVALS;
                          HourlyData :=  ATCData1.Dates.Summary.Tu<>4;

                          If NumVals=0 then
                            Begin
                              Writeln(LogF,SeriesName+' timeseries could not be read,"'+HSPFConst+'" timeseries has zero datapoints');
                              Exit;
                            End;

                          TLoadg.Destroy;
                          TLoadg:=TLoadings.Init(Numvals,50);

                          AvgVal := 0;
                          Indx :=  0;
                          NumInDay := 0;
                          Repeat
                            Inc(Indx);
                            Inc(NumInDay);
                            Value := ATCData1.Value[Indx] * MultFactor;

                            ThisTime := ATCData1.Dates.Value[Indx] - 15019; {move between HSPF and Delphi Date Units}
                            If HourlyData then ThisTime := ThisTime + 23/24; {correct apparent lag}

                            If Value<0 then Value := 0;

                            If (not HourlyData)
                              then
                                Begin
                                  NewLoad:= TLoad.Init(ThisTime,Value);
                                  TLoadg.Insert(NewLoad);
                                End
                              Else {HourlyData}
                                Begin
                                  AvgVal := AvgVal + Value;
                                  If (Round(ThisTime*24) mod 24)= 23 then {11pm}
                                    Begin
                                      AvgVal := AvgVal / NumInDay;
                                      NewLoad:= TLoad.Init(Trunc(ThisTime),AvgVal);
                                      TLoadg.Insert(NewLoad);
                                      AvgVal := 0;
                                      NumInDay := 0;
                                    End;
                                End;

                          Until (Indx=NumVals);

                          Import_DynLoad := True;
                          Writeln(LogF,SeriesName+' timeseries read into AQUATOX.');
                          If HourlyData then
                              Writeln(LogF,'   Note:  Hourly data are averaged to get daily data.');
                          If FtUnits then
                              Writeln(LogF,'   Note:  "AVDEP" data converted from ft to M');

                         End
                      else Writeln(LogF,SeriesName+' timeseries could not be read, no "'+HSPFConst+'" data found');
                 End;
                 {-------------------------------------------------------------------------------}
                 Procedure Import_Alt_Time_Series(SeriesName,HSPFConst: String; Var ILoad: PLoadingsRecord; MultFactor: Double; Alt_Type:Alt_LoadingsType; TSV: TStateVariable);
                 Var ThisTime: TDateTime;
                     I2,Index: LongInt;
                     NumVals, NumInDay: Integer;
                     AvgVal, Value   : Double;
                     NewLoad :  TLoad;
                     HourlyData: Boolean;
                     CFSUnits,AdjustInflow: Boolean;
                 Begin
                    If Find_Time_Series(HSPFConst,ATCData1)
                      then
                        Begin
                          NumVals := ATCData1.Dates.Summary.NVALS;
                          HourlyData :=  ATCData1.Dates.Summary.Tu<>4;

                          If (HSPFConst='FLOW') then If Not CheckUnits(CFSUnits,'cfs',SeriesName) then exit;

                          If NumVals=0 then
                            Begin
                              Writeln(LogF,SeriesName+' timeseries could not be read,"'+HSPFConst+'" timeseries has zero datapoints');
                              If HSPFConst = 'IVOL' then VolumeReadOK := False;
                              Exit;
                            End;

                          ILoad.Alt_UseConstant[Alt_Type] := False;
                          ILoad.Alt_MultLdg[Alt_Type] := 1;
                          If ILOAD.Alt_Loadings[Alt_Type].Count>0 then
                            Begin
                              ILoad.Alt_Loadings[Alt_Type].Destroy;
                              ILoad.Alt_Loadings[Alt_Type]:=TLoadings.Init(NumVals,20);
                            End;

                          I2 := 1;
                          AdjustInflow := False;
                          If HSPFConst = 'IVOL' then
                            If Find_Time_Series('PSUP',ATCData2) and
                               Find_Time_Series('VEVP',ATCData3) then
                                 try
                                   If ATCData3.Value[I2]>-999 then AdjustInflow := True;
                                 except
                                 end;

                          Index := 0;
                          AvgVal := 0;
                          NumInDay := 0;
                          Repeat
                            Inc(Index);
                            Inc(NumInDay);
                            Value := ATCData1.Value[Index] * MultFactor;
                            If AdjustInflow then
                              Value := (ATCData1.Value[Index] + ATCData2.Value[Index] - ATCData3.Value[Index]) * MultFactor;
                             {AdjInflow  =  INFLOW            +  PRECIPITATION        - EVAPORATION          }  {1e6 * h/d}

                            If Value<0 then Value := 0;
                            ThisTime := ATCData1.Dates.Value[Index] - 15019; {15019 moves between HSPF and Delphi Date Units}
                            If HourlyData then ThisTime := ThisTime + 23/24; {correct apparent lag}

                            If (not HourlyData)
                              then
                                Begin
                                  NewLoad:= TLoad.Init(ThisTime,Value);
                                  ILoad.Alt_Loadings[Alt_Type].Insert(NewLoad);
                                End
                              Else {HourlyData}
                                Begin
                                  AvgVal := AvgVal + Value;
                                  If (Round(ThisTime*24) mod 24)= 23 then {11pm}
                                    Begin
                                      If (HSPFCOnst = 'RO') or (HSPFConst = 'FLOW') then AvgVal := AvgVal / NumInDay;
                                      NewLoad:= TLoad.Init(Trunc(ThisTime),AvgVal);
                                      ILoad.Alt_Loadings[Alt_Type].Insert(NewLoad);
                                      AvgVal := 0;
                                      NumInDay := 0;
                                    End;
                                End;

                          Until Index=NumVals;
                          Writeln(LogF,SeriesName+' timeseries read into AQUATOX.');
                          If HourlyData then
                              Writeln(LogF,'   Note:  Hourly data are averaged to get daily data.');
                          If CFSUnits then
                              Writeln(LogF,'   Note:  Data converted from CFS to m3/d.');

                          If AdjustInflow then Writeln(LogF,'   Note:  Inflow of water adjusted to include PRECIP and EVAP so that water calculations balance between AQUATOX and HSPF.');
                          If HSPFConst = 'IVOL' then VolumeReadOK := True;
                          TSV.LoadNotes1 :=  LinkStr;
                        End
                      else
                        Begin
                          Writeln(LogF,SeriesName+' timeseries could not be read, no "'+HSPFConst+'" data found');
                          If HSPFConst = 'IVOL' then VolumeReadOK := False;
                        End;
                 End;
                 {-------------------------------------------------------------------------------}
                 Function Import_Nutrient_Time_Series(SeriesName,HSPFConst: String; Var ILoad: PLoadingsRecord; TSV: TStateVariable): Boolean;
                 Var ThisTime: TDateTime;
                     Index, I2: LongInt;
                     Avg_n, NumVals: Integer;
                     PStr: String;
                     AddNO2, HourlyData, MGperL : Boolean;
                     No3Val, NO2Val: Double;
                     AvgVal, ThisVol,Value: Double;
                     NewLoad:     TLoad;
                     OldHSPFConst, ConvStr: String;
                     Found: Boolean;
                 Begin
                    Index := 0;
                    Import_Nutrient_Time_Series := False;

                    If (not VolumeReadOK) and FromParams then
                      Begin
                        Writeln(LogF,SeriesName+' BASINS timeseries could not be read, because INFLOW WATER data is not available');
                        Exit;
                      End;

                    OldHSPFConst := HSPFConst;
                    Found := Find_Time_Series(HSPFConst,ATCData1);
                    If Not Found then
                      Begin
                         If HSPFConst = 'NH3' then HSPFConst  := 'NH4-N';
                         If HSPFConst = 'NO3' then HSPFConst  := 'NO3-N';
                         If HSPFConst = 'PO4' then HSPFConst  := 'PO4-P';
                         If HSPFConst = 'TTP' then HSPFConst  := 'TOTP';
                         If HSPFConst = 'TTN' then HSPFConst  := 'TOTN';

                         Found := Find_Time_Series(HSPFConst,ATCData1);
                         If Not Found then HSPFConst := OldHSPFConst;
                      End;

                    If Not Found and (HSPFConst = 'PO4') then
                      Begin
                         HSPFConst  := 'TORP';
                         Found := Find_Time_Series(HSPFConst,ATCData1);
                         If Not Found then HSPFConst := OldHSPFConst;
                      End;

                    If Found then
                        Begin
                          NumVals := ATCData1.Dates.Summary.NVALS;
                          HourlyData :=  ATCData1.Dates.Summary.Tu<>4;

                          If Not CheckUnits(MGperL,'mg/L',SeriesName) then exit;

                          If NumVals=0 then
                            Begin
                              Writeln(LogF,SeriesName+' timeseries could not be read,"'+HSPFConst+'" timeseries has zero datapoints');
                              Exit;
                            End;

                          ILoad.UseConstant:= False;
                          ILoad.MultLdg:= 1;
                          If ILOAD.Loadings.Count>0 then
                            Begin
                              ILoad.Loadings.Destroy;
                              ILoad.Loadings:=TLoadings.Init(NumVals,50);
                            End;
                          If (HourlyData and (TSV.nstate in HOURLYLIST)) then ILoad.Loadings.Hourly := True;

                          I2 := 1;
                          AddNO2 := False;
                          If HSPFConst = 'NO3' then
                            If Find_Time_Series('NO2',ATCData3) then
                              try
                               If ATCData3.Value[I2]>-999 then AddNO2 := True;
                              except
                              end;

                          If (HSPFCONST='PO4') or (HSPFCONST='PO4-P') or (HSPFCONST='TORP') then
                            Begin
                              If AddPPO4 then Begin
                                                AddPPO4 := Find_Time_Series('PPO4',ATCData2);
                                                If Not AddPPO4 then AddPPO4 := Find_Time_Series('PPO4-P',ATCData2);
                                              End;
                              If AddTORP then AddTORP := Find_Time_Series('TORP',ATCData3);
                            End;

                          AvgVal := 0;
                          Avg_n  := 0;

                          Repeat
                            Inc(Index);
                            ThisTime := ATCData1.Dates.Value[Index] - 15019; {15019 moves between HSPF and Delphi Date Units}
                            If HourlyData then ThisTime := ThisTime + 23/24; {correct apparent lag}

                            ThisVol := 0;
                            If MGperL
                              then
                                Begin
                                   If (HSPFCONST='PO4') and (not AddPO4)
                                     then Value := 0
                                     else Value := (ATCData1.Value[Index]);
                                End       {mg/L}             {mg/L}
                              else
                                Begin
                                  ThisVol := PVOL.LoadsRec.Alt_Loadings[pointsource].GetLoad(Trunc(ThisTime+0.0001),True);
                                  {m3/d}                                                                {m3/d}
                                  If (ThisVol<tiny) or ((HSPFCONST='PO4') and (not AddPO4))
                                    then Value := 0
                                    else Value := (ATCData1.Value[Index] * Multiplier * 1e6) / (ThisVol * 1e3 );
                                        {mg/L}         {kg/unit}         {h/d if req}  {mg/kg}  {m3/d}  {L/m3}
                                End;

                            If AddNo2 then
                              Begin
                                 NO3Val := ATCData1.Value[Index];
                                 NO2Val := ATCData3.Value[Index];
                                 Value := (No3Val+NO2Val);
                                 If Not MGperL then
                                     Value := (Value * Multiplier * 1e6) / ( ThisVol * 1e3 );
                                      {mg/L}{kg/unit}  {h/d if req}{mg/kg}   {m3/d}   {L/m3}
                              End;
                            If Value < 0 then Value := 0;

                          If (HSPFCONST='PO4') or (HSPFCONST='PO4-P') then
                            Begin
                              If AddPPO4
                                then if not MgPerL then Value := Value + (ATCData2.Value[Index] * Multiplier * 1e6) / (ThisVol * 1e3 )
                                                        {mg/L}   {mg/L}       {kg/unit}         {h/d if req}  {mg/kg}  {m3/d}  {L/m3}
                                                   else Value := Value + (ATCData2.Value[Index]);
                                                        {mg/L}   {mg/L}            {mg/L}
                              If AddTORP
                                then if not MgPerL then  Value := Value + (ATCData3.Value[Index] * Multiplier * 1e6) / (ThisVol * 1e3 )
                                                        {mg/L}   {mg/L}       {kg/unit}         {h/d if req}  {mg/kg}  {m3/d}  {L/m3}
                                                   else Value := Value + (ATCData3.Value[Index]);
                                                        {mg/L}   {mg/L}            {mg/L}
                            End;

                            If (not HourlyData) or (HourlyData and (TSV.nstate in HOURLYLIST))
                              then
                                Begin
                                  NewLoad:= TLoad.Init(ThisTime,Value);
                                  ILoad.Loadings.Insert(NewLoad);
                                End
                              Else {HourlyData}
                                Begin
                                  AvgVal := AvgVal + Value;
                                  Inc(Avg_n);
                                  If (Round(ThisTime*24) mod 24)= 23 then {11pm}
                                    Begin
                                      If MGperL then AvgVal := AvgVal / Avg_n;
                                      NewLoad:= TLoad.Init(Trunc(ThisTime),AvgVal);
                                      ILoad.Loadings.Insert(NewLoad);
                                      AvgVal := 0;
                                      Avg_n  := 0;
                                    End;
                                End;

                          Until Index=NumVals;
                          Import_Nutrient_Time_Series := True;

                          If MgPerL then ConvStr := ' read as '
                                    else ConvStr := ' converted to ';
                          If (HSPFConst <> 'PO4') and (HSPFConst <> 'PO4-P') then Writeln(LogF,SeriesName+' timeseries'+ConvStr+'an inflow loading with units of mg/L of inflow water.');
                          If HSPFConst = 'NO3' then
                            Begin
                              If AddNo2 then Writeln(LogF,'   Note:  the NO3 and NO2 timeseries were added together to get nitrate value.')
                                        else Writeln(LogF,'   Note:  the NO3 timeseries is assumed to include NO3 and NO2 simulated together.');
                            End;

                          If HourlyData and not (TSV.nstate in HOURLYLIST) then
                              Writeln(LogF,'   Note:  Hourly data are averaged to get daily data.');

                          If (HSPFConst = 'PO4') or (HSPFConst = 'PO4-P') then
                            Begin
                              PStr := '';
                              If AddPO4 then PStr := 'orthophosphate, ';
                              If AddPPO4 then PStr := PStr + 'adsorbed PO4, ';
                              If AddTORP then PStr := PStr + 'organic phosphate, ';
                              TSV.LoadNotes2 :=  'HSPF '+PSTR;
                              Writeln(LogF,'INFLOW PHOSPHATE read as ['+PSTR+ '] and'+ConvStr+'units of mg/L.');
                              If IsTotP then PStr := 'Total P' else PStr := 'Total Soluble P';
                              Writeln(LogF,'   Note:  INFLOW PHOSPHATE assumed to represent '+PSTR);
                              Writeln(LogF,'   Note:  INFLOW PHOSPHATE bioavailable fraction set to '+FloattoStrF(PFracAvail,ffgeneral,3,3));
                            End;

                          TSV.LoadNotes1 :=  LinkStr;

                        End
                      else Writeln(LogF,SeriesName+' timeseries could not be read, no "'+HSPFConst+'" data found');

                 End;
                 {-------------------------------------------------------------------------------}
                 Procedure Import_BOD_And_ORC;
                 Var ThisTime: TDateTime;
                     Indx: LongInt;
                     NumVals: Integer;
                     BODVal, ORCVal: Double;
                     ThisVol,Value, AvgVal: Double;
                     LabMass, RefrMass: Double;
                     HourlyData: Boolean;
                     NewLoad:     TLoad;
                     PctRefr: Double;
                 Begin
                    If not VolumeReadOK then
                      Begin
                        Writeln(LogF,'CBOD & ORC timeseries could not be read, because INFLOW WATER data is not available');
                        Exit;
                      End;

                    Indx := 0;
                    Find_Time_Series('BOD',ATCData1);
                    Find_Time_Series('ORC',ATCData2);

                    NumVals := ATCData1.Dates.Summary.NVALS;
                    HourlyData :=  ATCData1.Dates.Summary.Tu<>4;

                    If NumVals=0 then
                        Begin
                          Writeln(LogF,'Organic Matter timeseries could not be read,"BOD" timeseries has zero datapoints');
                          Exit;
                        End;

                    With PD.InputRecord.Load do
                      Begin
                        UseConstant := False;
                        If Loadings.Count>0 then
                          Begin
                            Loadings.Destroy;
                            Loadings:=TLoadings.Init(NumVals,20);
                          End;
                        MultLdg := 1;
                      End;

                    With PD.InputRecord.Percent_Refr do
                      Begin
                        UseConstant := False;
                        If Loadings.Count>0 then
                          Begin
                            Loadings.Destroy;
                            Loadings:=TLoadings.Init(NumVals,20);
                          End;
                        MultLdg := 1;
                      End;

                    AvgVal := 0;
                    Repeat
                      Inc(Indx);
                      BODVal := ATCData1.Value[Indx] * LinkStudy.Location.Conv_CBOD5_to_OM(PCT_Refr);
                      ORCVal := ATCData2.Value[Indx] * 1.90;
                               {kg org. matter/h}

                      ThisTime := ATCData1.Dates.Value[Indx] - 15019; {move between HSPF and Delphi Date Units}
                      If HourlyData then ThisTime := ThisTime + 23/24; {correct apparent lag}

                      ThisVol := PVOL.LoadsRec.Alt_Loadings[pointsource].GetLoad(Trunc(ThisTime+0.0001),True);
                      {m3/d}                                                             {m3/d}

                      If (BODVal>0) and (ORCVal>0) then
                        Begin
                          LabMass  := (1 -(PCT_Refr /100)) * BODVal;
                          RefrMass := ((PCT_Refr /100)*BODVal) + ORCVal;
                          If (RefrMass + LabMass) > 0
                             then PctRefr := RoundDec(2, 100*(RefrMass/(Refrmass+LabMass)) ) {JSC 2-8-05}
                             else PctRefr := 10;
                          If not Hourlydata
                            then Begin
                                   NewLoad:= TLoad.Init(ThisTime,PctRefr);        {JSC 2-8-05}
                                   PD.InputRecord.Percent_Refr.Loadings.Insert(NewLoad);   {JSC 2-8-05}
                                 End
                            else If (Round(ThisTime*24) mod 24)= 23  {11pm}
                              then
                                Begin
                                   NewLoad:= TLoad.Init(Trunc(ThisTime),PctRefr);  {Eventually update to, avg each day}
                                   PD.InputRecord.Percent_Refr.Loadings.Insert(NewLoad);   {JSC 2-8-05}
                                End;

                        End;

                      If ThisVol>Tiny
                        then  Value := ((BODVal + ORCVal) * Multiplier *  1e6) / (ThisVol * 1e3 )
                              {mg/L}    {    kg/unit    }  {h/d if req} {mg/kg}   {m3/d}  {L/m3}
                        else  Value := 0;
                      If Value<0 then Value := 0;

                      If (not HourlyData)
                        Then
                          Begin
                            NewLoad:= TLoad.Init(ThisTime,Value);
                            PD.InputRecord.Load.Loadings.Insert(NewLoad);
                          End
                        Else {HourlyData}
                          Begin
                            AvgVal := AvgVal + Value;
                            If (Round(ThisTime*24) mod 24)= 23 then {11pm}
                              Begin
                                NewLoad:= TLoad.Init(Trunc(ThisTime),AvgVal);
                                PD.InputRecord.Load.Loadings.Insert(NewLoad);
                                AvgVal := 0;
                              End;
                          End;

                   Until Indx=NumVals;

                   PD.LoadNotes1 :=  LinkStr;
                   Writeln(LogF,'BOD & ORC timeseries summed and read into AQUATOX as Organic Matter Loadings.');
                   Writeln(LogF,'Percent Refractory input as a daily time-series based on daily proportion of BOD and ORC.');
                 End;
                 {-------------------------------------------------------------------------------}
                 Procedure OpenLogFile;
                 Var BaseName: String;
                     Indx: Integer;
                 Begin
                   LogFName := OUTPUT_DIR+'\'+'AQT_LINK_LOG_'+Location;
                   BaseName := LogFName;
                   Indx := 1;
                   While FileExists(LogFName+'.txt') do
                     Begin
                       Inc(Indx);
                       LogFName := BaseName + '_'+IntToStr(Indx);
                     End;

                   AssignFile(LogF,LogFName+'.txt');
                   Rewrite(LogF);
                   Writeln(LogF,'HSPF - AQUATOX: BASINS Linkage Log');
                   Writeln(LogF);
                   Writeln(LogF,'HSPF File:      ' + WDMFile);
                   Writeln(LogF,'HSPF Scenario:  ' + Scenario);
                   Writeln(LogF,'HSPF Location:  ' + Location);
                   Writeln(LogF,'Linkage Time:   ' + DateTimeToStr(Now));
                   Writeln(LogF);
                 End;
                 {-------------------------------------------------------------------------------}

Var Tm: TDateTime;
    ReadVal: Double;
    BOD_In, ORC_In, TPRead, SFound: Boolean;
    SARAStr: String;

Begin  {Get_HSPF_Linkage}
  AvDepRead := False;

  ProjTsrFile := nil;
  LastTease := 0;
  If FromParams then GetParams;

  Multiplier := 1.0;
  If AvgStr <> 'SUM' then
       Multiplier := 24;

  If not FindWDMFile then Exit;
  If not OpenWDMforRead then
    Begin
      If ProjTsrFile <> nil then ProjTSRFile.Clear;
      _F90_W99CLO;
      Exit;
    End;

  If FromParams then LinkStr := 'Data from BASINS: HSPF Linkage'
                else LinkStr := 'Data from '+ExtractFileName(WDMFile)+ ' '+Location;

  WaitDlg.Setup('Please Wait, Loading HSPF Linkage Data');

  TRY
  OpenLogFile;
  If FromParams then
    Begin
      GetLinkStudy(LinkStudy,Scenario+': '+Location);
      LinkStudy.Location.Locale.SiteName := Location;
      LinkStudy.Location.Locale.SiteComment := 'BASINS HSPF & GIS Linkage';
    End;

  With LinkStudy.SV do
    Begin
      {Set Simulation Start / End}
      Indx2 := 1;
      Tm := ATCData1.Dates.Value[Indx2] - 15019; {15019 moves between HSPF and Delphi Date Units}
      LinkStudy.PSetup.FirstDay := Tm;
      Writeln(LogF,'FirstDay of HSPF Loadings Read: '+DateToStr(Tm));
      Indx2 := ATCData1.Dates.Summary.NVALS;
      Tm := ATCData1.Dates.Value[Indx2] - 15019; {15019 moves between HSPF and Delphi Date Units}
      LinkStudy.PSetup.LastDay := Tm;
      Writeln(LogF,'LastDay of HSPF Loadings Read: '+DateToStr(Tm));

      If LinkStudy.PSetup.firstday >= LinkStudy.PSetup.lastday then
        Begin
          MessageDlg('Error reading HSPF dates from WDM files; set of time-series may be empty.',mterror,[mbok],0);
          Writeln(LogF,'Error Reading HSPF Dates.  Is Time-series empty?');
          FreeLibrary(hHassEnt);
          WaitDlg.Hide;
          ProjTsrFile.Clear;
          Exit;
        End;

      Application.CreateForm(THSPFDate, HSPFDate);
      Try
        HSPFDate.SelectRange(LinkStudy.PSetup.FirstDay,LinkStudy.PSetup.LastDay);
      Finally
        HSPFDate.Free;
      End;

      Writeln(LogF,'Loadings will be imported from '+DateToStr(LinkStudy.PSetup.FirstDay)+' to '+DateToStr(LinkStudy.PSetup.LastDay));

      {Gather Volume Data}

      PVOL :=TStateVariable(LinkStudy.SV.GetStatePointer(Volume,StV,WaterCol));
      If Get_IC_From_Time_Series('VOL', ReadVal)
        then
          Begin
            Writeln(LogF,'VOLUME Initial Condition read as '+FloatToStrF(ReadVal*1e6,ffexponent,5,5)+' m3');
            PVOL.InitialCond := ReadVal * 1e6;
            PVOL.Location.Locale.StaticVolume := ReadVal * 1e6;
            PVOL.Location.Locale.XVolume := LinkStr;
          End
        else
{         If Get_IC_From_Time_Series('VOLUME', ReadVal)
          then
            Begin
              Writeln(LogF,'VOLUME Initial Condition read as '+FloatToStrF(ReadVal*1e6,ffexponent,5,5)+' m3');
              PVOL.InitialCond := ReadVal * 1e6;
              PVOL.Location.Locale.StaticVolume := ReadVal * 1e6;
              PVOL.Location.Locale.XVolume := LinkStr;
            End
          else  } Writeln(LogF,'Initial Condition Volume could not be read, no "VOL" data found');

      VolumeReadOK := Find_Time_series('IVOL',ATCData1);
      If VolumeReadOK and not FromParams then
            Writeln(LogF,'NOTE:  "IVOL" found, Linkage assumes data were derived from HSPF BASINS Linkage and units were set accordingly. ');

      If VolumeReadOK then
        Begin
          LoadingsPtr := @(PVOL.LoadsRec);
          Import_Alt_Time_Series('INFLOW WATER','IVOL',LoadingsPtr,1e6*Multiplier,PointSource,PVol);  {PointSource = Inflow Load in TVOLUME obj}
          Import_Alt_Time_Series('OUTFLOW WATER','RO',LoadingsPtr,86400 {s/d},DirectPrecip,PVol);     {DirectPrecip = Discharge Load in TVOLUME obj}
          Import_Time_Series('WATER VOLUME','VOL',LoadingsPtr,1e6,PVol);
          Indx2 := 1;
          TVolume(PVOL).Calc_Method := KnownVal;
          PVol.LoadNotes1 := LinkStr;
        End
          else
            Begin
              LoadingsPtr := @(PVOL.LoadsRec);
              Import_Alt_Time_Series('OUTFLOW WATER','FLOW',LoadingsPtr,2446.576 ,DirectPrecip,PVol);     {DirectPrecip = Discharge Load in TVOLUME obj}
            End;                                                        {m3d/cfs}


      {Surface Area}
      SARAStr := 'SARA';
      SFound := Get_Avg_Val_From_Time_Series(SARAStr,ReadVal);
{      If Not SFound then
        Begin
          SARAStr := 'SAREA';
          SFound := Get_Avg_Val_From_Time_Series(SARAStr,ReadVal);
        End; }

     If SFound
        then
          Begin
            Writeln(LogF,'Constant SURFACE AREA read as the average of time-series "'+SaraStr+'": '+FloatToStrF(ReadVal*1e4,ffexponent,5,5)+' sq.m');
            PVOL.Location.Locale.SurfArea := ReadVal * 1e4;
                                                       {sq m / ha}
            PVol.Location.Locale.XSurfArea := LinkStr;
          End
        else Writeln(LogF,'SURFACE AREA could not be read, no "SARA" timeseries found');


      If Import_DynLoad('Average Depth','AVDP',LinkStudy.SV.DynZMean,1)
        Then Begin
               LinkStudy.SV.UseConstZMean := False;
               If Not Get_IC_From_Time_Series('AVDP',Linkstudy.Location.Locale.ICZMean) then
                 Begin
                   Get_IC_From_Time_Series('AVDEP',Linkstudy.Location.Locale.ICZMean);
                   Linkstudy.Location.Locale.ICZMean := Linkstudy.Location.Locale.ICZMean * 0.3048;
                 End;
             End;

      {Water Temp}
      PSV :=TStateVariable(LinkStudy.SV.GetStatePointer(Temperature,StV,WaterCol));
      LoadingsPtr := @(PSV.LoadsRec);

      Import_Time_Series('WATER TEMPERATURE','TW',LoadingsPtr,1,PSV);
      PSV.LoadsRec.UseConstant := False;
      If Get_IC_From_Time_Series('TW', ReadVal) then
        Begin
          If (Pos('f',(Lowercase(GetUnits)))>0)
            then PSV.InitialCond := (ReadVal-32) * (5/9)
            else PSV.InitialCond := ReadVal;
            
          PSV.Loadsrec.NoUserLoad := False;
          PSV.Location.Locale.XTempMean[Epilimnion]  := 'not used, HSPF time-series used.';
          PSV.Location.Locale.XTempRange[Epilimnion] := 'not used, HSPF time-series used.';
          PSV.Location.Locale.XTempMean[Hypolimnion]  := 'not used, HSPF time-series used.';
          PSV.Location.Locale.XTempRange[Hypolimnion] := 'not used, HSPF time-series used.';
        End;

      {Ammonia}
      PSV := TStateVariable(LinkStudy.SV.GetStatePointer(Ammonia,StV,WaterCol));
      LoadingsPtr := @(PSV.LoadsRec);
      Import_Nutrient_Time_Series('AMMONIA LOADING','NH3',LoadingsPtr,PSV);


      PSV := TStateVariable(LinkStudy.SV.GetStatePointer(Phosphate,StV,WaterCol));
      LoadingsPtr := @(PSV.LoadsRec);
      If Find_Time_Series('TORP',ATCData3)
       then  {New Phosphate Interface 8-3-05}
        BEGIN
           Application.CreateForm(TPHOSPHATE_Form, Phosphate_Form);
            Try
              AddTotP := Find_Time_Series('TTP',ATCData3);
              If Not AddTotP then AddTotP := Find_Time_Series('TOTP',ATCData3);
              AddPO4 := Find_Time_Series('PO4',ATCData3);
              If Not AddPO4 then AddPO4 := Find_Time_Series('PO4-P',ATCData3);
              AddPPO4 := Find_Time_Series('PPO4',ATCData3);
              If Not AddPPO4 then AddPPO4 := Find_Time_Series('PPO4-P',ATCData3);
              AddTORP := Find_Time_Series('TORP',ATCData3);

              Phosphate_FORM.GetPData(AddPO4,AddPPO4,AddTORP,AddTotP, IsTotP,PFracAvail);
              TPo4obj(PSV).TP_Inflow := IsTotP;
              TPo4obj(PSV).TP_IC := IsTotP;
              TPo4obj(PSV).FracAvail := PFracAvail;

              If AddTotP then Import_Nutrient_Time_Series('TOTAL PHOSPHATE LOADING','TTP',LoadingsPtr,PSV)
                         else Import_Nutrient_Time_Series('PHOSPHATE INFLOW','PO4',LoadingsPtr,PSV);
            Finally
              Phosphate_Form.Free;
            End;
        END
       else
        BEGIN {fallback to old phosphate interface for backwards compatibility}
          {Phosphate}
          TPRead := Import_Nutrient_Time_Series('TOTAL PHOSPHATE LOADING','TTP',LoadingsPtr,PSV);
          TPo4obj(PSV).TP_Inflow := True;
          TPo4obj(PSV).TP_IC := True;

          If not TPRead then
            Begin
              {Old Phosphate Interface: }
              If Import_Nutrient_Time_Series('PHOSPHATE LOADING','PO4',LoadingsPtr,PSV) then
                Writeln(LogF,'NOTE: Phosphate loadings passed as dissolved PO4');
              TPo4obj(PSV).TP_Inflow := False;
            End;
        END;

      {DO}
      PSV := TStateVariable(LinkStudy.SV.GetStatePointer(Oxygen,StV,WaterCol));
      LoadingsPtr := @(PSV.LoadsRec);
      Import_Nutrient_Time_Series('OXYGEN LOADING','DO',LoadingsPtr,PSV);

      {CO2}
      PSV := TStateVariable(LinkStudy.SV.GetStatePointer(CO2,StV,WaterCol));
      LoadingsPtr := @(PSV.LoadsRec);
      PSV.InitialCond := 0.7;
      LoadingsPtr.ConstLoad := 0.7;
      LoadingsPtr.UseConstant := True;
      Writeln(LogF,'CO2 is set to default value of 0.7 mg/L');
      PSV.LoadNotes1 := 'Default Value and loading (not from HSPF)';

      {NO3}
      PSV := TStateVariable(LinkStudy.SV.GetStatePointer(Nitrate,StV,WaterCol));
      LoadingsPtr := @(PSV.LoadsRec);
      Import_Nutrient_Time_Series('NITRATE LOADING','NO3',LoadingsPtr,PSV);
      TNo3obj(PSV).TN_Inflow := False;
      TNo3obj(PSV).TN_IC := False;

      If Find_Time_Series('TOC',ATCData3) then
        Begin
          {TOC}
          Pct_Refr := 20;
          Pct_Particulate := 10;

          Application.CreateForm(TTOC_Form, TOC_Form);
            Try
              TOC_Form.GetOrgData(Pct_Refr,Pct_Particulate);
            Finally
              TOC_Form.Free;
            End;

          PD := LinkStudy.SV.GetStatePointer(DissRefrDetr,StV,WaterCol);
          PD.InputRecord.Percent_Part.UseConstant := True;
          PD.InputRecord.Percent_Part.MultLdg := 1.0;
          PD.InputRecord.Percent_Part.ConstLoad := Pct_Particulate;
          PD.InputRecord.DataType:=Org_Carb;
          PD.InputRecord.Percent_Refr.UseConstant := True;
          PD.InputRecord.Percent_Refr.ConstLoad := PCT_Refr;
          LoadingsPtr := @(PD.InputRecord.Load);
          Import_Nutrient_Time_Series('TOC LOADING','TOC',LoadingsPtr, PD);      // TESTME

        End
      else
        Begin
          {CBOD}
          Pct_Refr := 10;
          Pct_Particulate := 10;
          BOD_In := Find_Time_Series('BOD',ATCData1);
          ORC_In := Find_Time_Series('ORC',ATCData1);

          Application.CreateForm(TBOD_Form, BOD_Form);
            Try
              BOD_FORM.ModelLabel.Caption := 'HSPF';
              If BOD_In then BOD_FORM.GetOrgData(ORC_In, Pct_Refr,Pct_Particulate);
            Finally
              BOD_Form.Free;
            End;

          PD := LinkStudy.SV.GetStatePointer(DissRefrDetr,StV,WaterCol);
          PD.InputRecord.Percent_Part.UseConstant := True;
          PD.InputRecord.Percent_Part.MultLdg := 1.0;
          PD.InputRecord.Percent_Part.ConstLoad := Pct_Particulate;

          If not BOD_In
            Then Writeln(LogF,'ORGANIC MATTER LOADINGS timeseries could not be read, no "BOD" data found')
            Else
              Begin
                If ORC_In
                   Then
                     Begin
                       PD.InputRecord.DataType:=Org_Matt;
                       Import_BOD_And_ORC;
                     End
                   Else  {not ORC_In, no refractory carbon in linked WDM}
                     Begin
                       PD.InputRecord.Percent_Refr.UseConstant := True;
                       PD.InputRecord.Percent_Refr.ConstLoad := PCT_Refr;
                       PD.InputRecord.Percent_Part.MultLdg := 1.0;
                       PD.InputRecord.DataType:=CBOD;
                       LoadingsPtr := @(PD.InputRecord.Load);
                       Import_Nutrient_Time_Series('BOD LOADING','BOD',LoadingsPtr, PD);
                     End;
             End;
        End;

     {Plankton} {
      If not Find_Time_Series('PHYT',ATCData1)
        Then Writeln(LogF,'PHYTOPLANKTON timeseries could not be read, no "PHYT" data found')
        Else
          Begin
            If GetStatePointer(Diatoms1,StV,WaterCol) = nil then LinkStudy.AddStateVariable(Diatoms1,WaterCol,0,True);
            LinkStudy.StateDataFromDBase(Diatoms1,StV,Default_Dir,'Plant.PDB','Phyto, Green');
            PSV := TStateVariable(LinkStudy.SV.GetStatePointer(Diatoms1,StV,WaterCol));
            LoadingsPtr := @(PSV.LoadsRec);
            Import_Nutrient_Time_Series('PHYTOPLANKTON (Diatoms1)','PHYT',LoadingsPtr,PSV);
          End; }

      {TSS}
      If not Find_Time_Series('SSD1',ATCData1) or
         not Find_Time_Series('SSD2',ATCData1) or
         not Find_Time_Series('SSD3',ATCData3)
        Then Begin
                If not Find_Time_Series('TSS',ATCData1)
                  then Writeln(LogF,'TSS timeseries could not be read, "SSD1-3" or "TSS" data is missing')
                  else
                    Begin
                      PSV := TStateVariable(LinkStudy.SV.GetStatePointer(TSS,StV,WaterCol));
                      LoadingsPtr := @(PSV.LoadsRec);
                      Import_Time_Series('TSS CONCENTRATION','TSS',LoadingsPtr,1,PSV);
                    End;
             End
        Else
          Begin
            If GetStatePointer(TSS,StV,WaterCol) = nil then LinkStudy.AddStateVariable(TSS,WaterCol,0,True);
            PSV := TStateVariable(LinkStudy.SV.GetStatePointer(TSS,StV,WaterCol));
            LoadingsPtr := @(PSV.LoadsRec);
            Import_Time_Series('TSS CONCENTRATION','SSD1',LoadingsPtr,1,PSV);
          End;

      If Find_Time_Series('TIQ1',ATCData1) or
         Find_Time_Series('TIQ2',ATCData1) or
         Find_Time_Series('TIQ3',ATCData1) then
           MessageDlg('You are linking information about Organic Toxicants from HSPF to AQUATOX.  You may now '+
                      'choose your organic toxicant(s) from the list of available Organic Toxicants within the '+
                      'AQUATOX database.  If your toxicant is not present on this list you may select cancel but '+
                      'you must then Edit Underlying Data within that chemical''s screen to specify the full set of '+
                      'chemical parameters.',mtinformation,[mbok],0);

      {ORG CHEMS}
      If Find_Time_Series('TIQ1',ATCData1) then
        Begin
           If (LinkStudy.SV.GetStatePointer(H2oTox1,StV,WaterCol) <> nil) then
                 LinkStudy.Remove_OrgTox_SVs(H2oTox1);
           LinkStudy.Add_OrgTox_SVs(H2OTox1,'QUAL 1');
           PSV := TStateVariable(LinkStudy.SV.GetStatePointer(H2OTox1,StV,WaterCol));
           LoadingsPtr := @(PSV.LoadsRec);
           Import_Nutrient_Time_Series('CHEMICAL 1','TIQ1',LoadingsPtr,PSV);
           Writeln(LogF,'   Note:  Chemical 1 required to have units of KG within HSPF.')
        End;

      If Find_Time_Series('TIQ2',ATCData1) then
        Begin
           If (LinkStudy.SV.GetStatePointer(H2oTox2,StV,WaterCol) <> nil) then
               LinkStudy.Remove_OrgTox_SVs(H2oTox2);
           LinkStudy.Add_OrgTox_SVs(H2OTox2,'QUAL 2');
           PSV := TStateVariable(LinkStudy.SV.GetStatePointer(H2OTox2,StV,WaterCol));
           LoadingsPtr := @(PSV.LoadsRec);
           Import_Nutrient_Time_Series('CHEMICAL 2','TIQ2',LoadingsPtr,PSV);
           Writeln(LogF,'   Note:  Chemical 2 required to have units of KG within HSPF.')

        End;

      If Find_Time_Series('TIQ3',ATCData1) then
        Begin
           If (LinkStudy.SV.GetStatePointer(H2oTox3,StV,WaterCol) <> nil) then
               LinkStudy.Remove_OrgTox_SVs(H2oTox3);
           LinkStudy.Add_OrgTox_SVs(H2OTox3,'QUAL 3');
           PSV := TStateVariable(LinkStudy.SV.GetStatePointer(H2OTox3,StV,WaterCol));
           LoadingsPtr := @(PSV.LoadsRec);
           Import_Nutrient_Time_Series('CHEMICAL 3','TIQ3',LoadingsPtr,PSV);
           Writeln(LogF,'   Note:  Chemical 3 required to have units of KG within HSPF.')
        End;
    End;

    ReadObserved('BOD');
    ReadObserved('PCHLA');
    ReadObserved('BCHLA');

  EXCEPT
  END;

  If Not FromParams then
    Begin
      Closefile(LogF);
      HSPFPanel.Visible := True;
      GISPanel.Visible  := False;
      SwatPanel.Visible := False;
      BypassButton.Visible := False;
      ContinueButton.Caption := '&OK';
      ShowModal;
    End;


  FreeLibrary(hHassEnt);
  WaitDlg.Hide;
  //ProjTsrFile.Clear;

  _F90_W99CLO;
End;
{$R *.DFM}


procedure TLBasinsInfo.Button3Click(Sender: TObject);
begin
  ExecuteFile('NOTEPAD.EXE',LogFName,'',SW_SHOW);
end;


                 {-------------------------------------------------------------------------------}
                 {--                              SWAT LINKAGE                                 --}
                 {-------------------------------------------------------------------------------}



Procedure TLBasinsInfo.Get_SWAT_Linkage(SWATFile: String; Var LinkStudy: TAQUATOXSegment);
Var FigFile,CODFile, RTEFile, RCHFile: String;
    BasinNum: Integer;
    DailyOutput: Boolean;
    PVol: TVolume;
    Num_Vals_In_Series: Integer;
    First_Sim_Year, HYD_STOR: Integer;

         {-------------------------------------------------------------------------------}
         Procedure OpenLogFile;
         Var BaseName: String;
             Indx: Integer;
         Begin
           LogFName := OUTPUT_DIR+'\'+'SWAT_LINK_LOG';
           BaseName := LogFName;
           Indx := 1;
           While FileExists(LogFName+'.txt') do
             Begin
               Inc(Indx);
               LogFName := BaseName + '_'+IntToStr(Indx);
             End;

           AssignFile(LogF,LogFName+'.txt');

           Rewrite(LogF);
           Writeln(LogF,'SWAT - AQUATOX: BASINS Linkage Log');
           Writeln(LogF);
           Writeln(LogF,'Linkage Time:   '+ DateTimeToStr(Now));
           Writeln(LogF);
           Writeln(LogF,'SWAT CIO File: '+SWATFILE);
           Writeln(LogF,'Linking Data from BASIN #'+IntToStr(BasinNum));
           Writeln(LogF);
         End;
         {-------------------------------------------------------------------------------}
         Function Read_CIO_File: Boolean;
         Var CIOErr: Boolean;
             ReadStr: String;
             LinetoRead: Integer;
             BNums: Array of Integer;
             BaseName: String;
         Begin
            Read_CIO_File := True;

            Try
              CIOErr := False;
              AssignFile(ReadFl,SWATFile);
              Reset(ReadFl);
            Except
              CIOErr := True;
              MessageDlg('Error Attempting to Read CIO File: '+SWATFILE,mterror,[mbok],0);
            End;

            Application.CreateForm(TSWATbasin, SWATbasin);

            Try

            If not CIOErr then
              Begin
                SwatBasin.Combobox1.Items.Clear;
                LineToRead := 0;
                Repeat
                  Inc(LineToRead);
                  ReadStr := ReadColumn(13 + (LineToRead*2),1);
                  If ReadStr<>'' then
                    Begin
                      SetLength(BNums,LineToRead);
                      Try BasinNum := StrToInt(ReadStr); Except BasinNum := 0 End;
                      BNums[LineToRead-1] := BasinNum;
                      SwatBasin.Combobox1.Items.Add('SubBasin '+IntToStr(BasinNum));
                    End;

                Until ReadStr='';

                SwatBasin.Combobox1.ItemIndex := 0;
                If SwatBasin.ShowModal = MRCancel then
                  Begin
                    Result := False;
                    Exit;
                  End;

                With SwatBasin.Combobox1 do
                  BasinNum := BNums[ItemIndex];
                BNums := nil;


                BaseName := ExtractFilePath(SWATFILE);

                {I.D. COD FILE from CIO FILE}
                CODFile := Trim(ReadFixed(5,40,52));
                If CODFile = '' then
                  Begin
                    MessageDlg('Error Attempting to Read CIO File.  File '+SWATFILE+'appears to be of incorrect format.',mterror,[mbok],0);
                    Result := False;
                    Exit;
                  End;
                CODFile := BaseName + CODFile;

                {I.D. RCH FILE from CIO FILE}
                RCHFile := Trim(ReadFixed(4,27,39));
                RCHFile := BaseName + RCHFile;

                {I.D. RTE FILE from CIO FILE}
                RTEFile := Trim(ReadFixed(13+(2*BasinNum),21,33));
                RTEFile := BaseName + RTEFile;

                {I.D. FIG FILE from CIO FILE}
                FIGFile := Trim(ReadFixed(5,27,39));
                FIGFile := BaseName + FIGFile;

                Scenario := 'SWAT';

                CloseFile(ReadFl);

              End; {If not CIOErr}

            Finally
              SwatBasin.Free;
            End;

         End;

         {-------------------------------------------------------------------------------}
         Function ReadFree(LN: Integer): Extended;
         Var ThisStr: String;
             LRead: Integer;
             ReadCh: Char;
             NumStarted, Numeric: Boolean;
         Begin
           ReadFree := -1;
           ThisStr:='';
           Reset(ReadFl);
           For LRead := 1 to LN-1 do
             Begin
               Readln(ReadFl);
               If Eof(ReadFl) then Exit;
             End;

           ThisStr := '';
           NumStarted := False;
           Repeat
             Read(ReadFl,ReadCh);
             Numeric := ReadCh in ['.','0'..'9'];
             If Numeric then NumStarted:=True;
             If Numeric then ThisStr:=ThisStr+ReadCh;
           Until NumStarted and (Not Numeric);

           Try ReadFree := StrtoFloat(ThisStr); Except End;

         End;
         {-------------------------------------------------------------------------------}
         Procedure ReadCODFile;
         Var NBYR, IYR, IDAF, IDAL, IPD, NYSkip: Integer;
             Tm: TDateTime;
         Begin
           Writeln(LogF,'Reading SWAT Input Control Code File : '+CODFile);

           Try
             AssignFile(ReadFl,CODFile);
             Reset(ReadFl);
           Except
             Writeln(LogF,'Error Attempting to Read COD File');
             Exit;
           End;

           NBYR := Trunc(ReadFree(2));
           IYR := Trunc(ReadFree(3));
           IDAF := Trunc(ReadFree(4));
           If IDAF<1 then IDAF := 1;
           IDAL := Trunc(ReadFree(5));
           If IDAL<1 then If IsLeapYear(IYR+NBYR) then IDAL := 366
                                                  else IDAL := 365;
           IPD  := Trunc(ReadFree(6));
           If (IPD<0) or (IPD=2) then Raise EAQUATOXError.Create('Error: SWAT Simulation cannot be run with annual output.  Daily or Monthly output required for AQUATOX linkage.');
           DailyOutput := (IPD=1);
           If DailyOutput then Writeln(LogF,'SWAT output stored in Daily Timesteps')
                          else Writeln(LogF,'SWAT output stored in Monthly Timesteps');

           NYSkip := Trunc(ABS(ReadFree(7)));
           If NYSkip > 0 then Writeln(LogF,'First '+InttoStr(NYSkip)+' years of output are skipped.  AQUATOX simluation can not include these years.');

           First_Sim_Year := IYR+NYSKIP;

           Tm := EncodeDate((IYr+NYSkip),1,1);
           Tm := Tm + IDAF - 1;
           LinkStudy.PSetup.FirstDay := Tm;
           Writeln(LogF,'SWAT Simulation First Day Read as: '+DateToStr(Tm));

           Tm := EncodeDate((IYr+NBYR),1,1);
           Tm := Tm + IDAL - 1;
           LinkStudy.PSetup.LastDay := Tm;
           Writeln(LogF,'SWAT Simulation Last Day Read as: '+DateToStr(Tm));
           Writeln(LogF);

           {reduce number of years run here?}

           CloseFile(ReadFl);
         End;
         {-------------------------------------------------------------------------------}
         Procedure ReadRTEFile;
         Var VolEst, SurfAreaEst, CH_W2, CH_D, CH_S2, CH_L2, CH_N2: Double;
         Begin
           Writeln(LogF,'Reading SWAT Main Channel Input File : '+RTEFile);

           Try
             AssignFile(ReadFl,RTEFile);
             Reset(ReadFl);
           Except
             Writeln(LogF,'Error Attempting to Read RTE File');
             Exit;
           End;

           With LinkStudy.Location.Locale do
             Begin
               ICZMean := 0;
               XZMean := '';
               Channel_Slope := 0;
               XChannel_Slope := '';
               SiteLength := 0;
               XLength := '';
               UseEnteredManning := False;
               EnteredManning := 0;
               SurfArea := 0;
               XSurfArea := '';
             End;

           CH_D := ReadFree(3);
           If CH_D>0
            then
              Begin
                LinkStudy.Location.Locale.ICZMean := CH_D;
                LinkStudy.Location.Locale.XZMean := 'SWAT RTE File';
                Writeln(LogF,'Channel Depth Read as '+FloatToStrF(CH_D,ffexponent,4,4)+' Meters');
              End
            else Writeln(LogF,'Error Reading Channel Depth CH_D');

            {Maximum Depth}
            With LinkStudy.Location.Locale do
               Begin
                 ZMax := ICZMean * 1.7;
                 XZMax := 'Assumed 1.7 times Mean Depth';
                 Writeln(LogF, 'Maximum Depth Assumed to be 1.7 times Mean Depth: '+ FloatToStrF(ZMax,ffexponent,4,4)+' M.')
               End;

           CH_S2 := ReadFree(4);
           If CH_S2>0
            then
              Begin
                LinkStudy.Location.Locale.Channel_Slope := CH_S2;
                LinkStudy.Location.Locale.XChannel_Slope := 'SWAT RTE File';
                Writeln(LogF,'Average Slope Read as '+FloatToStrF(CH_S2,ffexponent,4,4)+' M/M');
              End
            else Writeln(LogF,'Error Reading Channel Slope CH_S(2)');

           CH_L2 := ReadFree(5);
           If CH_L2>0
            then
              Begin
                LinkStudy.Location.Locale.SiteLength := CH_L2;
                LinkStudy.Location.Locale.XLength := 'SWAT RTE File';
                Writeln(LogF,'Channel Length Read as '+FloatToStrF(CH_L2,ffexponent,4,4)+' KM');
              End
            else
              Begin
                LinkStudy.Location.Locale.SiteLength := 0.001;
                LinkStudy.Location.Locale.XLength := 'SWAT Default';
                Writeln(LogF,'Lacking data, Channel Length set to 0.001 km');
              End;


           CH_W2 := ReadFree(2);
           If CH_W2>0
            then
              Begin
                SurfAreaEst := CH_W2 * (CH_L2 * 1000);
                 {m2}        {m}      {km}  {m/km}
                LinkStudy.Location.Locale.SurfArea := SurfAreaEst;
                LinkStudy.Location.Locale.XSurfArea := 'SWAT Length * Avg. Width';
                Writeln(LogF,'Average Width read as '+ FloatToStrF(CH_W2,ffexponent,4,4)+' M');
                Writeln(LogF,'Surface Area calculated as '+ FloatToStrF(SurfAreaEst,ffexponent,4,4)+' Sq.M.  (length * avg width)');

                VolEst := SurfAreaEst * CH_D;
                 {m3}      {m2}          {m}
                Writeln(LogF,'Init Cond Volume estimated as Surface Area times Channel Depth: '+FloatToStrF(VolEst,ffexponent,4,4)+' Cubic Meters');

                PVOL :=LinkStudy.SV.GetStatePointer(Volume,StV,WaterCol);
                PVOL.InitialCond := VolEst;
              End
            else Writeln(LogF,'Error Reading Channel Width CH_W(2).  Surface Area & Volume cannot be calculated.');


           CH_N2 := ReadFree(6);
           If CH_N2>0
            then
              Begin
                LinkStudy.Location.Locale.UseEnteredManning := True;
                LinkStudy.Location.Locale.EnteredManning := CH_N2;
                Writeln(LogF, 'Mannings "n" value Read As '+ FloatToStrF(CH_N2,ffexponent,4,4)+' s/m(1/3).')
              End
            else Writeln(LogF,'Error Reading Manning''s "n" CH_N(2).');

           Writeln(LogF);
           CloseFile(ReadFl);
         End;
         {-------------------------------------------------------------------------------}
         Procedure Get_HYD_STOR_From_FIG;
         Var line: integer;
             found: boolean;
             ReadSubNum: Integer;
         Begin
           Try   {READ HYD_STOR NUMBER FROM FIG FILE}
             AssignFile(ReadFl,FIGFile);
             Reset(ReadFl);

             Found := False;
             Line := 0;

             Repeat
               Inc(line);
               ReadSubNum := StrToInt(Trim(ReadFixed(line,23,28)));
               If ReadSubNum = BasinNum then
                 Begin
                   HYD_STOR := StrToInt (Trim(ReadFixed(line,17,22)));
                   Found := True;
                 End;
             Until Found;

             Writeln(LogF,'The hydrograph storage location number is '+IntToStr(HYD_STOR)+ ' (from the SWAT *.FIG file)');
             Writeln(LogF);
             CloseFile(ReadFl);
           Except
             Writeln(LogF,'Error Attempting to Read FIG File');
             Writeln(LogF,'The hydrograph storage location number is assumed to equal the Basin Number');
             Writeln(LogF);
             HYD_STOR := BasinNum;
             CloseFile(ReadFl);
           End;
         End;

         {-------------------------------------------------------------------------------}
(*         Procedure GetColNum(SName: String; ILoad: TLoadings; MultFactor: Double; IsInflow: Boolean);
         Var ColStart,ColEnd: Integer;
         Begin
          { Read_RCH_Series(SName,ILoad,MultFactor,ColStart,ColEnd,IsInflow); }
         End;
         *)
         {-------------------------------------------------------------------------------}

         Procedure Read_RCH_Series(SName: String; Var ILoad: TLoadings; MultFactor: Double; ColStart,ColEnd: Integer; IsInflow: Boolean);
         Var LnIndex,ChIndex, MON: Integer;
             ReadVal, ReadHS, ReadMON: String;
             FirstRead: Boolean;
             ReadCh: Char;
             ThisVol, Val: Double;
             YrsRead: Integer;
             ReadDate: TDateTime;
             NewLoad:     TLoad;

                {-------------------------------------------------------------------------------}
                Function GetOutflowVal: Double;
                Var ChIndx: Integer;
                    Vl : Double;
                Begin
                  Vl := StrtoFloat(ReadVal); {outflow of water itself  m3/s}

                  {Add EVAP}
                  ReadVal := '';
                  For ChIndx := 62 to 73 do
                    Begin
                      Read(ReadFl,ReadCh);
                      ReadVal := ReadVal + ReadCh;
                    End;
                  Vl := Vl + StrtoFloat(ReadVal);

                  {ADD TLOSS}
                  ReadVal := '';
                  For ChIndx := 74 to 85 do
                    Begin
                      Read(ReadFl,ReadCh);
                      ReadVal := ReadVal + ReadCh;
                    End;
                  Vl := Vl + StrtoFloat(ReadVal);

                  GetOutflowVal := Vl * MultFactor;
                End;
                {-------------------------------------------------------------------------------}
                Function GetNitrateVal: Double;
                Var ChIndx: Integer;
                    Vl : Double;
                Begin
                  GetNitrateVal := 0;
                  Vl := StrtoFloat(ReadVal); {outflow of water itself  m3/s}

                  For ChIndx := 182 to 217 do
                    If not EOF(ReadFl) then Read(ReadFl,ReadCh);
                  If ReadCh=#0 then exit;

                  {ADD NO2}
                  ReadVal := '';
                  For ChIndx := 218 to 229 do
                    Begin
                      Read(ReadFl,ReadCh);
                      ReadVal := ReadVal + ReadCh;
                    End;
                  Vl := Vl + StrtoFloat(ReadVal);

                  GetNitrateVal :=  Vl;
                                   {kg/timestep}
                End;
                {-------------------------------------------------------------------------------}
                Function GetPhosphateVal: Double;
                Var ChIndx: Integer;
                    Vl : Double;
                Begin
                  GetPhosphateVal := 0;
                  Vl := StrtoFloat(ReadVal); {outflow of water itself  m3/s}

                  For ChIndx := 158 to 241 do
                    If not EOF(ReadFl) then Read(ReadFl,ReadCh);
                  If ReadCh=#0 then exit;

                  {ADD MINP}
                  ReadVal := '';
                  For ChIndx := 242 to 253 do
                    Begin
                      Read(ReadFl,ReadCh);
                      ReadVal := ReadVal + ReadCh;
                    End;
                  Vl := Vl + StrtoFloat(ReadVal);

                  GetPhosphateVal :=  Vl;
                                   {kg/timestep}
                End;
                {-------------------------------------------------------------------------------}
                Function GetPestVal: Double;
                Var ChIndx: Integer;
                    Vl : Double;
                Begin
                  GetPestVal := 0;
                  Vl := StrtoFloat(ReadVal); {outflow of water itself  m3/s}

                  For ChIndx := 350 to 361 do
                    If not EOF(ReadFl) then Read(ReadFl,ReadCh);
                  If ReadCh=#0 then exit;

                  {ADD MINP}
                  ReadVal := '';
                  For ChIndx := 362 to 373 do
                    Begin
                      Read(ReadFl,ReadCh);
                      ReadVal := ReadVal + ReadCh;
                    End;
                  Vl := Vl + StrtoFloat(ReadVal);

                  GetPestVal :=  Vl / 1000;
                                 {g/timestep}
                End;
                {-------------------------------------------------------------------------------}

         Var CountVals: Integer;
         Begin
             WaitDlg.Tease;

           TRY
             Reset(ReadFl);
             FirstRead := True;
             For LnIndex := 1 to 9 do
             Readln(ReadFl);

             YrsRead := 0;

             ILoad.Destroy;
             If Num_Vals_In_Series=0 then ILoad :=TLoadings.Init(100,20)
                                     else ILoad :=TLoadings.Init(Num_Vals_In_Series,20);

             CountVals := 0;
             Repeat
               WaitDlg.Tease;
               ReadCh := ' ';
               For ChIndex := 1 to 6 do
                 If not EOF(ReadFl) then Read(ReadFl,ReadCh);
               If ReadCh=#0 then exit;

               ReadHS := '';
               For ChIndex := 7 to 10 do
                 Begin
                   Read(ReadFl,ReadCh);
                   ReadHS := ReadHS + ReadCh;
                 End;

               If StrToInt(Trim(ReadHS))= HYD_STOR then
                 Begin
                   For ChIndex := 11 to 20 do
                     Read(ReadFl,ReadCh);
                   If ReadCh=#0 then exit;

                   ReadMon := '';
                   For ChIndex := 21 to 25 do
                     Begin
                       Read(ReadFl,ReadCh);
                       ReadMon := ReadMon + ReadCh;
                     End;

                   If Pos('.',ReadMon)>0
                     then MON := 99999
                     else MON := StrToInt(ReadMon);

                   If (not FirstRead) and (MON=1) then Inc(YrsRead);
                   If (MON<367) then  {otherwise ignore monthly or annual summary data}
                     Begin
                       FirstRead := False;

                       For ChIndex := 26 to ColStart-1 do
                         Read(ReadFl,ReadCh);
                       If ReadCh=#0 then exit;

                       ReadVal := '';
                       For ChIndex := ColStart to ColEnd do
                         Begin
                           Read(ReadFl,ReadCh);
                           ReadVal := ReadVal + ReadCh;
                         End;

                       If  SNAME = 'FLOW_OUT'
                         then Val := GetOutflowVal
                         else If SNAME = 'NO3_IN + NO2_IN'
                           then Val := GetNitrateVal
                           else If SNAME = 'MINP + ORGP'
                             then Val := GetPhosphateVal
                             else If SNAME ='SOLPST_IN + SORPST_IN'
                               then Val := GetPestVal
                               else Val := StrtoFloat(ReadVal) * MultFactor;


                       If DailyOutput
                         then ReadDate := EncodeDate(First_Sim_Year+YrsRead,1,1) + MON - 1
                         else ReadDate := EncodeDate(First_Sim_Year+YrsRead,MON,1);

                       If IsInflow then
                         Begin
                           If not DailyOutput then Val :=   Val     / (IncMonth(ReadDate,1)-ReadDate);
                                                 {kg/d}  {kg/month}   {        Days per Month       }

                           ThisVol := PVOL.LoadsRec.Alt_Loadings[pointsource].GetLoad(ReadDate,True);
                           {m3/d}                                                       {m3/d}
                           If ThisVol<tiny
                             then Val := 0
                             else Val := ( Val  * 1e6) / (ThisVol * 1e3 );
             {nutrient units}    {mg/L}  {kg/d} {mg/kg}    {m3/d}  {L/m3}
             {toxicant units}    {ug/L}   {g/d} {ug/g}     {m3/d}  {L/m3}
                         End;

                       NewLoad:= TLoad.Init(ReadDate,Val);
                       ILoad.Insert(NewLoad);
                       Inc(CountVals);

                       If not DailyOutput then
                         Begin
                           ReadDate := IncMonth(ReadDate,1)-1;
                           NewLoad:= TLoad.Init(ReadDate,Val);
                           ILoad.Insert(NewLoad);
                           Inc(CountVals);
                         End;
                     End
                 End;

               If not EOF(ReadFl) then ReadLn(ReadFl);
             Until EOF(ReadFl);

             Num_Vals_In_Series := CountVals;

             If  SNAME = 'FLOW_OUT'
               then Writeln(LogF,'Outflow Water Volume timeseries loaded as FLOW_OUT + EVAP + TLOSS.')
               else If IsInflow
                then
                  Begin
                    If SNAME ='SOLPST_IN + SORPST_IN'
                      then Writeln(LogF,SNAME+' timeseries converted into AQUATOX inflow load in units of ug/L')
                      else Writeln(LogF,SNAME+' timeseries converted into AQUATOX inflow load in units of mg/L')
                  End
                else Writeln(LogF,'Successfully loaded '+SNAME+' timeseries into AQUATOX');

           EXCEPT
             Writeln(LogF,'Error Attempting to Read '+SNAME+' within RCH File');
           END;
         End;
         {-------------------------------------------------------------------------------}
         Procedure ReadRCHFile;
         Var PSV: TStateVariable;
             PD : TDissRefrDetr;
             Pct_Particulate, BOD_Pct_Refr: Double;
         Begin
           Get_HYD_STOR_From_FIG;

           Writeln(LogF,'Reading SWAT Main Channel Output File : '+RCHFile);

           Try
             AssignFile(ReadFl,RCHFile);
             Reset(ReadFl);
           Except
             Writeln(LogF,'Error Attempting to Read RCH File');
             Exit;
           End;

           PVOL :=LinkStudy.SV.GetStatePointer(Volume,StV,WaterCol);
           PVOL.Calc_Method := Dynam;
           PVol.LoadNotes1 := 'Data from BASINS: SWAT Linkage';
           Read_RCH_Series('FLOW_IN', PVOL.LoadsRec.Alt_Loadings[pointsource],SecsPerDay,38,49,False);
           PVOL.LoadsRec.Alt_UseConstant[pointsource] := False;
           Read_RCH_Series('FLOW_OUT', PVOL.LoadsRec.Alt_Loadings[DirectPrecip],SecsPerDay,50,61,False);
           PVOL.LoadsRec.Alt_UseConstant[DirectPrecip] := False;

           {PVOL.InitCond = }

           PSV := LinkStudy.SV.GetStatePointer(Nitrate,StV,WaterCol);
           Read_RCH_Series('NO3_IN + NO2_IN', PSV.LoadsRec.Loadings,1,170,181,TRUE);
           PSV.LoadsRec.UseConstant := False;
           PSV.LoadNotes1 := 'Loading from SWAT Linkage';

           PSV := LinkStudy.SV.GetStatePointer(Phosphate,StV,WaterCol);
           Read_RCH_Series('MINP + ORGP', PSV.LoadsRec.Loadings,1,146,157,TRUE);
           PSV.LoadsRec.UseConstant := False;
           PSV.LoadNotes1 := 'Loading from SWAT Linkage';

           PSV := LinkStudy.SV.GetStatePointer(Ammonia,StV,WaterCol);
           Read_RCH_Series('NH4_IN', PSV.LoadsRec.Loadings,1,194,205,TRUE);
           PSV.LoadsRec.UseConstant := False;
           PSV.LoadNotes1 := 'Loading from SWAT Linkage';

           PSV := LinkStudy.SV.GetStatePointer(Oxygen,StV,WaterCol);
           PSV.InitialCond := 7.5;
           PSV.LoadsRec.ConstLoad := 7.5;
           PSV.LoadsRec.UseConstant := True;
           Writeln(LogF,'Oxygen is set to default value of 7.5 mg/L');
           PSV.LoadNotes1 := 'Default Value and loading (not from SWAT)';
           PSV.LoadNotes2 := 'Approximate O2 saturation at 30 degrees C';

           {CO2}
           PSV := TStateVariable(LinkStudy.SV.GetStatePointer(CO2,StV,WaterCol));
           PSV.InitialCond := 0.7;
           PSV.LoadsRec.ConstLoad := 0.7;
           PSV.LoadsRec.UseConstant := True;
           Writeln(LogF,'CO2 is set to default value of 0.7 mg/L');
           PSV.LoadNotes1 := 'Default Value and loading (not from SWAT)';

           {BOD}
           BOD_Pct_Refr := 10;

           Pct_Particulate := 10;

           Application.CreateForm(TBOD_Form, BOD_Form);
           Try
             BOD_FORM.ModelLabel.Caption := 'SWAT';
             BOD_FORM.GetOrgData(False, BOD_Pct_Refr,Pct_Particulate);
           Finally
             BOD_Form.Free;
           End;

           PD := LinkStudy.SV.GetStatePointer(DissRefrDetr,StV,WaterCol);

           PD.InputRecord.Percent_Part.UseConstant := True;
           PD.InputRecord.Percent_Part.MultLdg := 1.0;
           PD.InputRecord.Percent_Part.ConstLoad := Pct_Particulate;

           PD.InputRecord.Percent_Refr.UseConstant := True;
           PD.InputRecord.Percent_Refr.ConstLoad := BOD_Pct_Refr;
           PD.InputRecord.Percent_Part.MultLdg := 1.0;
           PD.InputRecord.DataType:=CBOD;

           PD.InputRecord.Load.UseConstant := False;
           PD.LoadNotes1 := 'Loadings converted from SWAT BOD';
           Read_RCH_Series('CBOD_IN', PD.InputRecord.Load.Loadings,1,290,301,TRUE);

           If LinkStudy.SV.GetStatePointer(TSS,StV,WaterCol) = nil then LinkStudy.AddStateVariable(TSS,WaterCol,0,True);
           PSV := TStateVariable(LinkStudy.SV.GetStatePointer(TSS,StV,WaterCol));
           Read_RCH_Series('SED_CONC', PSV.LoadsRec.Loadings,1,110,121,FALSE);
           PSV.LoadsRec.UseConstant := False;
           PSV.LoadNotes1 := 'Loading from SWAT Linkage';


           {ORG CHEMS}
           If MessageDlg('Is a pesticide tracked within this reach? ',mtconfirmation,[mbyes,mbno],0) = mryes
             Then
               Begin
                  MessageDlg('You are linking information about an Organic Toxicant from SWAT to AQUATOX.  You may now '+
                             'choose your organic toxicant from the list of available Organic Toxicants within the '+
                             'AQUATOX database.  If your toxicant is not present on this list you may select cancel but '+
                             'you must then Edit Underlying Data within that chemical''s screen to specify the full set of '+
                             'chemical parameters.',mtinformation,[mbok],0);

                 If (LinkStudy.SV.GetStatePointer(H2oTox1,StV,WaterCol) <> nil) then
                     LinkStudy.Remove_OrgTox_SVs(H2oTox1);

                 LinkStudy.Add_OrgTox_SVs(H2OTox1,'Pesticide');
                 PSV := TStateVariable(LinkStudy.SV.GetStatePointer(H2OTox1,StV,WaterCol));
                 PSV.LoadsRec.UseConstant := False;
                 PSV.LoadNotes1 := 'Loading from SWAT Linkage';
                 Read_RCH_Series('SOLPST_IN + SORPST_IN',PSV.LoadsRec.Loadings,1,338,349,TRUE);
               End;

           CloseFile(ReadFl);
         End;
         {-------------------------------------------------------------------------------}


Begin
  Num_Vals_in_Series := 0;
  LinkStudy := nil;

  TRY

  If Not READ_CIO_FILE then Exit;

  WaitDlg.Setup('Please Wait, Loading SWAT Linkage Data');

  OpenLogFile;

  GetLinkStudy(LinkStudy,Scenario+': BASIN '+IntToStr(BasinNum));
  LinkStudy.Location.Locale.SiteComment := 'SWAT Linkage Data';
  LinkStudy.Location.SiteType := Stream;

  LinkStudy.NewNotes.Add('Simulation created from SWAT-AQUATOX Linkage.  LogFile:~'+LogFName);

  ReadCODFile;
  ReadRTEFile;
  ReadRCHFile;

  WaitDlg.Hide;
  CloseFile(LogF);

  EXCEPT
    WaitDlg.Hide;
    Try
      CloseFile(LogF);
      CloseFile(ReadFl);
    Except
    End;
    Raise;
  END;

End;


end.
 