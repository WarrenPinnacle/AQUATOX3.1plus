//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Uncert;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, RandNum,
  ComCtrls, ExtCtrls, OleCtrls, StdCtrls, Buttons, TCollect, Global, MatrixMath,
  TeEngine, Series, TeeProcs, Chart, CalcDist, DB, DBTables, AQBaseForm, hh;

type
namestring = String[60];

TDistribution=Class(BaseClass)
  Name: namestring;      {text associated with distribution}
  DistNum: integer;      {reference number of this distribution}
  SVID: SV_ID;           {Associated State Var, if relevant}
  ToxRec: String[20];    {Associated ToxRec if relevant}
  DistType: TDistType;   {type of distribution, triangle, uniform, norm, lognorm}
  UseDist: Boolean;      {Use distribution if true, or if false, point estimate}
  Parm: Array[1..4] of Double;
                         {Parameters that describe the distribution}
  DisplayCDF: Boolean;   {Is distribution displayed as CDF?}

  PointEstimate: Double; {The point estimate associated with this distrib, doesn't need saving}
  Draws        : TCollection; {Stores the all the variable draws for this distribution, doesn't need saving}
  DynLoadings  : Pointer; {Stores the old dynamic loadings, relevant for constload only, don't save}
  LoadsCopied  : Boolean; {Stores old loadings settings, relevant for constload only, don't save}
  UseforSens   : Boolean; {Used for a sensitivity analysis?  Saved}
  Constructor Init(Nm : namestring; DN: Integer; ID:SV_ID; Mean: Double);
  Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
  Procedure   FillDraws(NumSteps: Integer; RandomSample:Boolean);
  Destructor  Done; Virtual;
  Procedure   Store(IsTemp: Boolean; Var st: Tstream); Override;
  Function    ObjectID: SmallInt; Override;

End;

TCorrelation = Record
                 DistNum1, DistNum2: Integer; {Two Dist Nums correlated}
                 SVID1,SVID2 : SV_ID;       {Two SVIDs correlated}
                 TxRc1,TxRc2: String[20];     {Two TxRcs correlated}
                 Correl: Double;
               End; {TCorrelation}

TCorrelations = Array of TCorrelation;


TDistributionList=class(TSortedCollection)
   NumCorrelations: Integer;            {number of saved correlations}
   Correlations  : TCorrelations;       {correlations of above: if template-global; if segment- seg.data}
   constructor Init(ALimit, ADelta: Integer);
   procedure updatecorrelations;        {remove extraneous correlations}
   procedure RemoveCorr(Index: Integer);
   procedure MakeCMatrix(Var CM: TSquareMatrix);
   procedure MakeFillsMatrix(Var DM: TMatrix; NumDraws: Integer);
   function FindDistrib(Num: Integer; ID: SV_ID; TxRec: String; Var Index:Integer): Boolean;
   procedure FillVariableDraws(NumSteps: Integer;  RandomSample: Boolean);  {uncertainty sampling}
   procedure CorrelateDraws(NumSteps: Integer);     {implement correlation}
   function KeyOf(Item: Pointer): Pointer; override;
   function Compare(Key1, Key2: Pointer): Integer; override;
   constructor load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
   Procedure   Store(IsTemp: Boolean; Var st: Tstream); override;
End;

type
  TDistributionForm = class(TAQBase)
    Panel1: TPanel;
    Label1: TLabel;
    UseDistButton: TRadioButton;
    UsePointButton: TRadioButton;
    Label2: TLabel;
    TriButton: TRadioButton;
    UniButton: TRadioButton;
    panel2: TPanel;
    NormButton: TRadioButton;
    LogNormButton: TRadioButton;
    CancelBtn: TBitBtn;
    Panel3: TPanel;
    ProbButton: TRadioButton;
    CumuButton: TRadioButton;
    Header: TLabel;
    Panel4: TPanel;
    Label3: TLabel;
    p1label: TLabel;
    p2label: TLabel;
    p3label: TLabel;
    Parm1Edit: TEdit;
    Parm2Edit: TEdit;
    Parm3Edit: TEdit;
    p4label: TLabel;
    Parm4Edit: TEdit;
    ErrorPanel: TPanel;
    Panel5: TPanel;
    Label5: TLabel;
    Label4: TLabel;
    OKBtn: TBitBtn;
    WarningLabel: TLabel;
    Chart1: TChart;
    Series1: TAreaSeries;
    HelpButton: TButton;
    CopyGraph: TButton;
    procedure VerifyNumber(Sender: TObject);
    procedure RetHandleClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure Parm4EditKeyPress(Sender: TObject; var Key: Char);
    procedure HelpButtonClick(Sender: TObject);
    procedure UseDistButtonClick(Sender: TObject);
    procedure TriButtonClick(Sender: TObject);
    procedure CumuButtonClick(Sender: TObject);
    procedure CopyGraphClick(Sender: TObject);
  private
    procedure updatescreen;
    { Private declarations }
  public
    Distribs : TDistributionList;
    Changed: Boolean;
    procedure ChangeUData(Num: Integer; ID:SV_ID; ToxRec: String);
    function haschanged: Boolean;
    { Public declarations }
  end;

var
  DistributionForm: TDistributionForm;
  TempDist: TDistribution;
  DistData  : TDistribution;


implementation

Uses CopyClip;


{$R *.DFM}

Function TDistributionForm.HasChanged:Boolean;
Begin
  With TempDist do
    HasChanged :=
      (ToxRec     <> DistData.ToxRec)  or
      (DistType   <> DistData.DistType)or
      (UseDist    <> DistData.UseDist) or
      (Parm[1]    <> DistData.Parm[1]) or
      (Parm[2]    <> DistData.Parm[2]) or
      (Parm[3]    <> DistData.Parm[3]) or
      (Parm[4]    <> DistData.Parm[4]) or
      (DisplayCDF <> DistData.DisplayCDF)
End;


procedure TDistributionForm.ChangeUData(Num: Integer; ID: SV_ID; Toxrec: String);
Var Index     : Integer;

        Procedure CopyToTemp;
           Begin
           TempDist:=TDistribution.Init(DistData.Name,Num,ID,1);
           With TempDist do
             Begin
               ToxRec     := DistData.ToxRec;
               DistType   := DistData.DistType;
               UseDist    := DistData.UseDist;
               Parm       := DistData.Parm;
               DisplayCDF := DistData.DisplayCDF;
             End;
           End;

        Procedure CopyFromTemp;
           Begin
             Changed := HasChanged;
             With DistData do
               Begin
                 ToxRec     := TempDist.ToxRec;
                 DistType   := TempDist.DistType;
                 UseDist    := TempDist.UseDist;
                 Parm       := TempDist.Parm;
                 DisplayCDF := TempDist.DisplayCDF;
               End;
           End;

begin
  Changed :=False;

  If (not Distribs.FindDistrib(Num,ID,ToxRec,Index))
     then Raise EAquatoxError.Create('Cannot Find Distribution Data.');

  DistData:=Distribs.At(Index);

  CopyToTemp;
  UpdateScreen;
  If ShowModal<>MrCancel then CopyFromTemp
                         else Changed:=False;

  TempDist.Free;
end;

procedure TDistributionForm.CopyGraphClick(Sender: TObject);
Var WorkingChart: TChart;
begin
  Application.CreateForm(TCopyClipbd, CopyClipbd);
  Try
  If CopyClipBd.Showmodal=mrcancel then exit;

  WorkingChart:=Chart1;

  If CopyClipBd.BmpButt.Checked then WorkingChart.CopytoClipBoardBitmap
                                else WorkingChart.CopytoClipBoardMetaFile(True);

  Finally
    CopyClipbd.Free;
  End;
end;

constructor TDistribution.Init(Nm:namestring; DN: Integer; ID : SV_ID; Mean: Double);
begin
  Name := Nm;
  DistNum:=DN;
  SVID:=ID;
  ToxRec:='';
  If DN=ConstLoad_RegDist_Index then DistType:=LogNormal
                                else DistType:=Normal;
  UseDist:= False;
  Parm[1] := Abs(Mean);
 {Based on a comment by Russ at our meeting a couple weeks ago, the
  default Std. Dev. for loading distributions should be 0.6 * Mean}
  Parm[2] := Parm[1]*0.6;
  Parm[3] := 1.5 * Parm[1];
  Parm[4] := 0;
  DisplayCDF := False;
  UseForSens := False;
  PointEstimate:=-1;
  Draws:=nil;
end;


Destructor TDistribution.Done;
Begin
  If Draws<>nil then Draws.Free;
End;

Constructor TDistribution.Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Begin
  st.Read(Name, Sizeof(Name));
  St.Read(DistNum, Sizeof(DistNum));

  If ReadVersionNum < 2.999
    then
       Begin
         St.Read(SVID,2);
         SVID.Layer:=WaterCol;
       End
     else St.Read(SVID,Sizeof(SVID));

  St.Read(ToxRec, Sizeof(ToxRec));
  St.Read(DistType, Sizeof(DistType));

  St.Read(UseDist, Sizeof(UseDist));
  If ReadVersionNum<2.00 then UseDist:=False;  {kill these distributions}

  St.Read(Parm, Sizeof(Parm));
  St.Read(DisplayCDF, Sizeof(DisplayCDF));

  If (ReadVersionNum > 3.199) or ((ReadVersionNum>2.79) and (ReadVersionNum<2.81))
    then St.Read(UseforSens, Sizeof(UseforSens))
    else UseforSens := False;

  PointEstimate:=-1;
  Draws:=nil;
End;

Procedure TDistribution.Store(IsTemp: Boolean; Var st: Tstream);
Begin
  St.write(Name, Sizeof(Name));
  St.write(DistNum, Sizeof(DistNum));
  St.write(SVID, Sizeof(SVID));
  St.write(ToxRec, Sizeof(ToxRec));
  St.write(DistType, Sizeof(DistType));
  St.write(UseDist, Sizeof(UseDist));
  St.write(Parm, Sizeof(Parm));
  St.write(DisplayCDF, Sizeof(DisplayCDF));
  St.write(UseforSens, Sizeof(UseforSens));
End;

Function TDistribution.ObjectID:SmallInt;      Begin  ObjectID:=1035;  End;

constructor TDistributionList.Init(ALimit, ADelta: Integer);

begin
   Inherited Init(ALimit, ADelta); {TSortedCollection}
   Duplicates:=true;
   Correlations := nil;
   NumCorrelations := 0;
End;

constructor TDistributionList.load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double);
Var i: Integer;
Begin
  Inherited Load(IsTemp,st,ReadVersionNum); {TSortedCollection}
  If (ReadVersionNum < 3.199) and ((ReadVersionNum<2.79) or (ReadVersionNum>2.81))
    then NumCorrelations := 0
    else st.Read(NumCorrelations,Sizeof(NumCorrelations));

  If NumCorrelations>0 then
    Begin
      SetLength(Correlations,NumCorrelations+5);
      For i := 0 to NumCorrelations-1 do
        St.Read(Correlations[i],Sizeof(TCorrelation));

    End;
End;

{-----------------------------------------------------------------------------}
Procedure TDistribution.FillDraws(NumSteps: Integer; RandomSample:Boolean);

   {This Procedure fills the PCollection associated with each used
    distribution with NumSteps (number of iterations) UncertDraw objects
    each which has the numbered interval and the calculated draw from
    the Function CalculateDraw}

    {In order to calculate the rank order of each parameter's draw
    (ensures non-repeatability and tells which interval to sample from),
    the Procedure calculates a random number for each draw and then ranks
    them.  Optimized Feb 10, 97, JSC}

    {Converted to method, 9-2006}


   {------------------------------------------------------------------}
    Function ICDF(Prob:Double): Double;
    Var Res: Double;
    Begin
     Res := Error_Value;
        Case Disttype of
          Normal       : Res:=ICdfNormal(Prob,Parm[1],Parm[2]);
          Triangular   : Res:=ICdfTriangular(Prob,Parm[2],Parm[3],Parm[1]);
          LogNormal    : Res:=ICdfLogNormal(Prob,exp(Parm[1]),exp(Parm[2]));
          Uniform      : Res:=ICdfuniform(Prob,Parm[1],Parm[2]);
        end;
     If Res = Error_Value then Raise EAQUATOXError.Create('Distribution Error!  ICDF Called with Invalid Parameters.');
     ICDF:=Res;
    End;
   {------------------------------------------------------------------}
    Function CDF(XVal:Double): Double;
    Var Res: Double;
    Begin
     Res := Error_Value;
         Case Disttype of
               Triangular: Res:=cdfTriangular(XVal,Parm[2],Parm[3],Parm[1]);
               Normal:     Res:=cdfNormal(XVal,Parm[1],Parm[2]);
               LogNormal:  Res:=cdfLogNormal(XVal,exp(Parm[1]),exp(Parm[2]));
               Uniform:    Res:=cdfuniform(XVal,Parm[1],Parm[2]);
          end;
     If Res = Error_Value then Raise EAQUATOXError.Create('Distribution Error!  CDF Called with Invalid Parameters.');
     CDF:=Res;
    End;

   {------------------------------------------------------------------}
    Function CalculateDraw(Interval: Integer): Double;
   {This Procedure calculates the x value of the distribution
    given the interval in [1..NumIterations]}

    Var ProbLow,ProbHigh: Double;
        Width, Where: Double; {Describe Cum Probability Interval}
        RandProb: Double;     {Random Prob within Interval}
        WideSample: Boolean;  {sample min and max and points in-between}
    Begin
      ProbHigh:=1.0;
      {Current implementation does not have truncated distributions
       so ProbHigh = 1.0 rather than CDF(Xmax)}

      {Other than Distribution number 1 (LogKOW), Xmin should be zero}
      {triangular and uniform already are subject to Xmin of zero through
       the entry screen}
      ProbLow:=0.0;
      If (DistNum=LogKow_RegDist_Index) and (DistType in [normal,lognormal])
         then ProbLow:=CDF(0);

      {Width is the width of the probability interval, where is the upper
       bounds of the probability interval, RandProb is the random value
       within the probability interval (From LATIN.FOR)}
{      Width:=(ProbHigh-ProbLow)/NumSteps;
      Where:=(Width*Interval) + Problow;
      RandProb:=Where - Width*RandUniform;  Pre Sensitivity Mode 3/12/2010}

      WideSample := (Not RandomSample) and (not (DistType in [normal,lognormal]));

      If WideSample
        then Width:=(ProbHigh-ProbLow)/(NumSteps-1)
        else Width:=(ProbHigh-ProbLow)/(NumSteps);

      If WideSample
        then Where:=(Width*(Interval-1)) + Problow
        else If RandomSample then Where:=  (Width*Interval) + Problow
                             else Where:= ((Width*Interval) + Problow)-(0.5*Width);  //Normal or LogNormal, Not RandomSample

      IF Not RandomSample
        then RandProb:=Where
        else RandProb:=Where - Width*RandUniform;

      CalculateDraw:=ICDF(RandProb);
    End;

   {------------------------------------------------------------------}

    Var IterationLoop: Integer;
        FindSlotLoop : Integer;
        LowValue     : Double;
        LowValIndex  : Integer;
        NewDraw      : TUncertDraw;

    Begin  {FillDraws}
      Draws:=TCollection.Init(100,50);

      {insert correct number of draws with random number that will
       then be ranked to get the Latin Hypercube Interval}
      For IterationLoop:=1 to NumSteps do
        begin
          NewDraw:=TUncertDraw.Init(0,RandUniform,0);
          Draws.Insert(NewDraw);
        end;

      For IterationLoop:=1 to NumSteps do
        Begin
          LowValue:=99;
          LowValIndex:=0;
          For FindSlotLoop:=0 to NumSteps-1 do
              If TUncertDraw(Draws.At(FindSlotLoop)).RandomDraw<=LowValue
                then
                  Begin
                    LowValIndex:=FindSlotLoop;
                    LowValue:=TUncertDraw(Draws.At(FindSlotLoop)).RandomDraw;
                  End;
          NewDraw:=Draws.At(LowValIndex);
          NewDraw.RandomDraw:=99;
          NewDraw.IntervalNum:=IterationLoop;
          NewDraw.Value:=CalculateDraw(IterationLoop)
        End;
    End;

   {------------------------------------------------------------------}




Procedure TDistributionList.Store(IsTemp: Boolean; Var st: Tstream);
Var i: Integer;
Begin
  inherited;
{  TSortedCollection.Store(IsTemp,st); }
  st.Write(NumCorrelations,Sizeof(NumCorrelations));

  If NumCorrelations>0 then
   For i := 0 to NumCorrelations-1 do
     St.Write(Correlations[i],Sizeof(TCorrelation));

End;


Function TDistributionList.Keyof(Item: Pointer): Pointer;

begin
     Keyof:=@TDistribution(Item).DistNum;
end;

Function TDistributionList.Compare(key1,key2: pointer):integer;
begin
     if  PInteger(key1)^ > PInteger(key2)^ then compare:=1
     else if PInteger(key1)^ < PInteger(key2)^ then compare:=-1
     else compare:=0;
end;

procedure TDistributionList.RemoveCorr(index: integer);
var i: integer;
Begin
  Dec(NumCorrelations);
  For i := index to NumCorrelations do
   Correlations[i] := Correlations[i+1];
End;

{---------------------------------------------------------------------------}

Procedure TDistributionList.CorrelateDraws(NumSteps: Integer);
Var RankMatrix,SortMatrix,CDraws: TMatrix;

        {--------------------------------------------------------------------}
        Procedure ProduceCDraws;
        Var P, CM, S, InvQ,Q, S_Prime, T: TSquareMatrix;
            DrawsM: TMatrix;
        Begin
          MakeCMatrix(CM);

          P := TSquareMatrix.Create(CM.MSize);
          T := TSquareMatrix.Create(CM.MSize);
          Q := TSquareMatrix.Create(CM.MSize);
          S := TSquareMatrix.Create(CM.MSize);

          choldc(CM,P);  {Perform a Cholesky decomposition of the covariance matrix}
          MakeFillsMatrix(DrawsM,NumSteps);
          Correl(DrawsM,T);

          Try
            choldc(T,Q);
          Except
            Raise EAQUATOXError.Create('ERROR: Cannot induce rank correlation with that number of uncertainty iterations.  '+
                                       'Try increasing the number of uncertainty iterations.');
          End;

          InvQ := TSquareMatrix.CopyMatrix(Q);
          InvertMat(InvQ);  {invert with LU decomposition}
          SqrMatMult(P,INVQ,S);
          S_Prime := TSquareMatrix.CopyMatrix(S);
          TransposeMat(S_Prime);
          CDraws := TMatrix.Create(DrawsM.MWidth,DrawsM.MLength);
          MatMult(DrawsM,S_prime,CDraws);

          {Correl(CorrDraws,T); }

          P.Free;
          CM.Free;
          S.Free; S_Prime.Free;
          Q.Free; InvQ.Free;
          T.Free;
          DrawsM.Free;
        End;
        {--------------------------------------------------------------------}
          Procedure QuickSortCol(Col: Integer; iLo, iHi: Integer);
          Var
            Lo, Hi : Integer;
            T, Mid : Double;
          Begin
            Lo := iLo;
            Hi := iHi;
            Mid := SortMatrix.Matrix[(Lo + Hi) div 2,Col];
            repeat
              while SortMatrix.Matrix[Lo,Col] < Mid do Inc(Lo);
              while SortMatrix.Matrix[Hi,Col] > Mid do Dec(Hi);
              if Lo <= Hi then
              begin
                T := SortMatrix.Matrix[Lo,Col];
                SortMatrix.Matrix[Lo,Col] := SortMatrix.Matrix[Hi,Col];
                SortMatrix.Matrix[Hi,Col] := T;
                Inc(Lo);
                Dec(Hi);
              end;
            until Lo > Hi;
            if Hi > iLo then QuickSortCol(Col, iLo, Hi);
            if Lo < iHi then QuickSortCol(Col, Lo, iHi);
          End;
        {--------------------------------------------------------------------}
          Procedure RankCol(Col: Integer);
          Var j,k: Integer;
              Val: Double;
          Begin
            For j := 1 to CDraws.MLength do
             Begin
              Val := CDraws.Matrix[j,col];
              For k := 1 to CDraws.MLength do
                If SortMatrix.Matrix[k,col] = Val then
                  Begin
                    RankMatrix.Matrix[j,col] := k;
                    Break;
                  End;
             End;
          End;
        {--------------------------------------------------------------------}
         Procedure RankDist(Col:Integer; PD: TDistribution);
         Begin
           QuickSortCol(Col,1,SortMatrix.MLength);
           RankCol(Col);

         End;
        {--------------------------------------------------------------------}

Var Dist: TDistribution;
    NumUsed,DistribLoop: Integer;
    OrigDraws: TCollection;
    i,j,NewRank  : Integer;
    PDraw : TUncertDraw;

Begin

  ProduceCDraws;
  SortMatrix := TMatrix.CopyMatrix(CDraws);
  RankMatrix := TMatrix.Create(SortMatrix.MWidth, SortMatrix.MLength);

  NumUsed := 0;
  For DistribLoop:=0 to Count-1 do
     Begin
       Dist:=At(DistribLoop);
       With Dist do
         If UseDist then
           Begin
             Inc(NumUsed);
             RankDist(NumUsed,Dist);
             OrigDraws := Dist.Draws;
             Dist.Draws :=  TCollection.Init(OrigDraws.Count+1,50);
             For i := 0 to OrigDraws.Count - 1 do
               Begin
                 NewRank := Trunc(RankMatrix.Matrix[i+1,NumUsed]);
                 For j := 0 to OrigDraws.Count - 1 do
                   Begin
                     PDraw := OrigDraws.at(j);
                     If PDraw <> nil then
                       If PDraw.IntervalNum = NewRank
                         then Begin
                                Dist.Draws.Insert(PDraw);
                                Break;
                              End;
                   End;
               End;

             OrigDraws.SavePointers;  {Destroy collection array but save pointers}
           End;
     End;

  CDraws.Free;
  SortMatrix.Free;
  RankMatrix.Free;
End;

{---------------------------------------------------------------------------}

Procedure TDistributionList.FillVariableDraws(NumSteps: Integer; RandomSample: Boolean);
Var Dist: TDistribution;
    DistribLoop: Integer;
Begin
  For DistribLoop:=0 to Count-1 do
     Begin
       Dist:=At(DistribLoop);
       With Dist do
         If UseDist then Dist.FillDraws(NumSteps,RandomSample);
     End;
End;

{---------------------------------------------------------------------------}

procedure TDistributionList.UpdateCorrelations;       {remove extraneous correlations}
Var i: Integer;

   Function ValidCorr(index: integer):Boolean;
   Var PD: TDistribution;
       i: Integer;
   Begin
     ValidCorr := False;

     With Correlations[index] do
      If Not FindDistrib(DistNum1, SVID1, TxRc1,i) then Exit;
     PD := At(i);
     If Not PD.UseDist then Exit;

     With Correlations[index] do
      If Not FindDistrib(DistNum2, SVID2, TxRc2,i) then Exit;
     PD := At(i);
     If Not PD.UseDist then Exit;

     For i := 0 to NumCorrelations -1 do
       If i <> index then
         If (Correlations[i].DistNum1 = Correlations[index].DistNum1) and
            (Correlations[i].DistNum2 = Correlations[index].DistNum2) and
            (Correlations[i].SVID1.SVType = Correlations[index].SVID1.SVType) and
            (Correlations[i].SVID1.NState = Correlations[index].SVID1.NState) and
            (Correlations[i].SVID2.SVType = Correlations[index].SVID2.SVType) and
            (Correlations[i].SVID2.NState = Correlations[index].SVID2.NState) and
            (Correlations[i].TxRc1 = Correlations[index].TxRc1) and
            (Correlations[i].TxRc2 = Correlations[index].TxRc2)
           then Exit;

     ValidCorr := True;
   End;

Begin
  For i:=NumCorrelations-1 downto 0 do
    If Not ValidCorr(i) then
      RemoveCorr(i);
End;

Function TDistributionList.FindDistrib(Num: Integer; ID:SV_ID; TxRec: String; Var Index: Integer): Boolean;
Var IndexFound,NstateFound: Boolean;
    DistID  : SV_ID;
    DistNum : Integer;
    DistStr : String;

Begin
  NStateFound:=False;
  IndexFound:=Search(@Num,Index);

  If IndexFound then
      While (not NStateFound) and (index<count) do
         Begin
           DistID := TDistribution(At(index)).SVID;
           DistNum:= TDistribution(At(index)).DistNum;
           DistStr:= TDistribution(At(index)).ToxRec;
           If (DistID.NState=ID.NState) and (DistNum=Num) and
              (DistID.SVTYPE=ID.SVTYPE) and (DistStr=TxRec)
                then NStateFound:=True
                else inc(index);
         End;

  FindDistrib:=NStateFound;
End;

{----------------------------------------------------------------------}

procedure TDistributionList.MakeFillsMatrix(Var DM: TMatrix; NumDraws: Integer);
Var IndexArray: Array of Integer;
    PDist: TDistribution;
    i,j, numUsed: Integer;
Begin
                                 
  SetLength(IndexArray,10);

  NumUsed := 0;
  For i:=0 to count-1 do
   If TDistribution(at(i)).UseDist then
     Begin
       Inc(NumUsed);
       If NumUsed > Length(IndexArray) then SetLength(IndexArray,Length(IndexArray)+20);
       IndexArray[NumUsed-1] := i;
     End;

  DM := TMatrix.Create(NumUsed,NumDraws);

  For i:=1 to NumUsed do
    Begin
      PDist := TDistribution(At(IndexArray[i-1]));
      For j := 1 to NumDraws do
        DM.Matrix[j,i] := TUncertDraw(PDist.Draws.At(j-1)).IntervalNum;
    End;

  IndexArray := nil;
End;


{----------------------------------------------------------------------}
(*
procedure TDistributionList.ShiftCMatrix(Var CM: TSquareMatrix);
Var NM: TSquareMatrix;
    i,j: Integer;
    Indices: Array of Integer;
    IDraws: Array of Double;


Begin
  SetLength(Indices,CM.MSize);
  SetLength(IDraws,CM.MSize);
  For i := 0 to CM.MSize-1 do
    Begin
      IDraws[i] := Random;
      Indices[i] := 0;
    End;

  For i := 0 to CM.MSize-1 do
    For j := 0 to CM.MSize-1 do
      If IDraws[j] <= Idraws[i] then Inc(Indices[j]);

  NM := TSquareMatrix.CopyMatrix(CM);
  For i := 1 to NM.MSize do
   For j := 1 to NM.MSize do
    Begin
      CM.Matrix[i,j] := NM.Matrix[Indices[i-1],Indices[j-1]]

{     Newi := i+1;
      Newj := j+1;
      If newi > NM.MSize then newi := 1;
      If newj > NM.MSize then newj := 1;
      CM.Matrix[i,j] := NM.Matrix[newi,newj]  }



    End;
End;  *)


procedure TDistributionList.MakeCMatrix(Var CM: TSquareMatrix);
Var IndexArray: Array of Integer;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  Function FindCorr(i,j,k: Integer): Double;
  Var D1,D2: TDistribution;

      Function AMatch(TC: TCorrelation;D1,D2:TDistribution): Boolean;
      Begin
        With TC do
         AMatch := (DistNum1 = D1.DistNum) and
                   (DistNum2 = D2.DistNum) and
                   (SVID1.SVType = D1.SVID.SVType) and
                   (SVID1.NState = D1.SVID.NState) and
                   (SVID2.SVType = D2.SVID.SVType) and
                   (SVID2.NState = D2.SVID.NState) and
                   (TxRc1 = D1.ToxRec) and
                   (TxRc2 = D2.ToxRec);
      End;

  Begin
    FindCorr:=-99;
    D1 := At(IndexArray[i-1]);
    D2 := At(IndexArray[j-1]);
    If D1=D2
      then FindCorr := 1
      else If AMatch(Correlations[k],D1,D2) or
              AMatch(Correlations[k],D2,D1)
                then FindCorr := Correlations[k].Correl;

  End;
  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

Var i,j,k, numUsed: Integer;
    Corr, Rs: Double;
Begin

  SetLength(IndexArray,10);

  NumUsed := 0;
  For i:=0 to count-1 do
   If TDistribution(at(i)).UseDist then
     Begin
       Inc(NumUsed);
       If NumUsed > Length(IndexArray) then SetLength(IndexArray,Length(IndexArray)+20);
       IndexArray[NumUsed-1] := i;
     End;

  CM := TSquareMatrix.Create(NumUsed);

  For i:=1 to NumUsed do
   For j:= 1 to NumUsed do
    Begin
      Corr := 0;
      If i=j
        then Corr := 1.0
        else
          For k:=NumCorrelations-1 downto 0 do
            Begin
              Rs :=FindCorr(i,j,k);
              If Rs > -99 then
                Begin
                  Corr := Rs;
                  Break;
                End;
            End;
      CM.Matrix[i,j] := Corr;
    End;

  IndexArray := nil;

End;

{----------------------------------------------------------------------}

procedure TDistributionForm.UpdateScreen;
Var Loop: Integer;
    LastVal,TempVal,Val : Double;
    Xmin,Xmax,XVal: Double;
{   Big: Double; }
    NumValues: Integer;
    GraphError: Boolean;
    NewSeries: TChartSeries;
Begin
 With TempDist do
  begin
    Header.Caption:=Name;
    Case DistType of
      Triangular: begin
                    TriButton.Checked:=True;
                    P1Label.Caption:='Most Likely';
                    P2Label.Caption:='Minimum';
                    P3Label.Caption:='Maximum';
                    P4Label.Caption:='<unused>';
                  end;
      Normal    : begin
                    NormButton.Checked:=True;
                    P1Label.Caption:='Mean';
                    P2Label.Caption:='Std. Deviation';
                    P3Label.Caption:='<unused>';
                    P4Label.Caption:='<unused>';
                  end;
      LogNormal : begin
                    LogNormButton.Checked:=True;
                    P1Label.Caption:='Mean';
                    P2Label.Caption:='Std. Deviation';
                    P3Label.Caption:='<unused>';
                    P4Label.Caption:='<unused>';
                  end;
      Uniform   : begin
                    UniButton.Checked:=True;
                    P1Label.Caption:='Minimum';
                    P2Label.Caption:='Maximum';
                    P3Label.Caption:='<unused>';
                    P4Label.Caption:='<unused>';

                  end;
    End;

    If not (DistType=Triangular) then
                  begin
                    P3Label.Visible:=False;
                    Parm3Edit.Visible:=False;
                  end
             else begin
                    P3Label.Visible:=True;
                    Parm3Edit.Visible:=True;
                  end;

    P4Label.Visible:=False;
    Parm4Edit.Visible:=False;

   If UseDist then
     begin
       Usedistbutton.Checked:=True;
       Panel2.Enabled := true;
       Panel2.Color := clBtnFace;
       Panel3.Enabled := true;
       Panel3.Color := clBtnFace;
       Panel4.Enabled := true;
       ErrorPanel.Color   := ClBtnFace;
       Panel5.BevelOuter := BvRaised;
       Panel4.Color := clBtnFace;
       Chart1.Color := clBtnFace;
     end
  else
     begin
       UsePointButton.Checked:=True;
       Panel2.Enabled := False;
       Panel2.Color := ClGray;
       Panel3.Enabled := False;
       Panel3.Color := ClGray;
       ErrorPanel.Color := ClGray;
       Panel5.BevelOuter := BvNone;
       Panel4.Enabled := False;
       Chart1.Color := ClGray;
       Panel4.Color := ClGray;
     end;

    UseDistButton.Checked:=UseDist;
    CumuButton.Checked:=DisplayCDF;

    Parm1Edit.Text:=' '+FloatToStrF(Parm[1],ffGeneral,9,4);
    Parm2Edit.Text:=' '+FloatToStrF(Parm[2],ffGeneral,9,4);
    Parm3Edit.Text:=' '+FloatToStrF(Parm[3],ffGeneral,9,4);
    Parm4Edit.Text:=' '+FloatToStrF(Parm[4],ffGeneral,9,4);

    WarningLabel.Visible:=(DistNum=ConstLoad_RegDist_Index);   

  TRY
    With Chart1 do
    begin
      NumValues:=40;

      While Chart1.SeriesCount>0 do Chart1.Series[0].Free;

      Xmin:=0; XMax:=1;
      Case DistType of
        Triangular:
                begin
                  XMin:=Parm[2];
                  XMax:=Parm[3];
                end;
        Uniform:
                begin
                  XMin:=Parm[1];
                  XMax:=Parm[2];
                end;
        Normal: begin
                  XMin:=icdfnormal(0.01,Parm[1],Parm[2]);
                  XMax:=icdfnormal(0.99,Parm[1],Parm[2]);
                end;
        LogNormal:
                begin
                  XMin:=icdfLognormal(0.01,exp(Parm[1]),exp(Parm[2]));
                  XMax:=icdfLognormal(0.99,exp(Parm[1]),exp(Parm[2]));
                end;
       end; {case}

       If (XMin < 0) and (DistNum <> LogKow_RegDist_Index) then XMin:=0;

      XVal:=(((XMax-XMin)/NumValues)*-1)+XMin;
      LastVal:=0;
      Case Disttype of
           Normal:     LastVal:=cdfNormal(XVal,Parm[1],Parm[2]);
           LogNormal:  LastVal:=cdfLogNormal(XVal,exp(Parm[1]),exp(Parm[2]));
      End; {Case}
      If LastVal=Error_Value then LastVal:=0;
{      Big:=0; }

      NewSeries := TAreaSeries.Create(Chart1);
      NewSeries.SeriesColor := ClNavy;

      GraphError:=False;
      For Loop:=0 to NumValues do
        begin
          XVal:=(((XMax-XMin)/NumValues)*loop)+XMin;

          Val:=0;
          Case Disttype of
               Triangular: Val:=cdfTriangular(XVal,Parm[2],Parm[3],Parm[1]);
               Normal:     Val:=cdfNormal(XVal,Parm[1],Parm[2]);
               LogNormal:  Val:=cdfLogNormal(XVal,exp(Parm[1]),exp(Parm[2]));
               Uniform:    Val:=cdfuniform(XVal,Parm[1],Parm[2]);
          end;

          TempVal:=Val;
          If (Not (Val=Error_value)) and (not DisplayCDF) then Val:=Val-LastVal;
          LastVal:=TempVal;

          If Val=error_value
            then GraphError:=True
            else If (DistType=Uniform) and (not DisplayCDF)
               then NewSeries.AddXY(XVal,1/NumValues,'',clteecolor)
               else NewSeries.AddXY(XVal,Val,'',clteecolor);

        end;

      ErrorPanel.Visible:=GraphError;

      Chart1.AddSeries(NewSeries);

    End; {With Chart1}

  EXCEPT
   ErrorPanel.Visible:=True;
  End;

  End;{with TempDist}
  update;
End;


procedure TDistributionForm.VerifyNumber(Sender: TObject);
{ Convert Text Edit into Number, raise error if wrong number,
  assign number to correct variable and update screen}
Var
Conv: Double;
Result: Integer;

begin
    Val(Trim(TEdit(Sender).Text),Conv,Result);
    If Result<>0 then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
                 else begin
                        case TEdit(Sender).Name[5] of
                           '1': TempDist.Parm[1]:=Abs(Conv);
                           '2': TempDist.Parm[2]:=Abs(Conv);
                           '3': TempDist.Parm[3]:=Abs(Conv);
                           '4': TempDist.Parm[4]:=Abs(Conv);
                         end; {case}
                       end;
    UpdateScreen;
end;

procedure TDistributionForm.RetHandleClick(Sender: TObject);
begin
  UpdateScreen;
end;

procedure TDistributionForm.OKBtnClick(Sender: TObject);
begin
  OKBtn.SetFocus;
  ModalResult:=MrOK;
end;

procedure TDistributionForm.CancelBtnClick(Sender: TObject);
begin
  if not haschanged then ModalResult:=MrCancel
  else if MessageDlg('Cancel Changes to Distribution?',mtConfirmation,[mbOK,MbCancel],0)
          = MrOK then ModalResult:=MrCancel;

end;

procedure TDistributionForm.Parm4EditKeyPress(Sender: TObject;
  var Key: Char);
begin
   If (Key=#13) then VerifyNumber(sender);
end;

procedure TDistributionForm.HelpButtonClick(Sender: TObject);
begin
  HTMLHelpContext('Topic69.htm');
end;

procedure TDistributionForm.UseDistButtonClick(Sender: TObject);
begin
  If UseDistButton.Checked then TempDist.UseDist := True
                           else TempDist.UseDist := False;
  updatescreen;


end;

procedure TDistributionForm.TriButtonClick(Sender: TObject);
begin
  With TempDist do
    If      TriButton.Checked  then DistType:=Triangular
    else if NormButton.Checked then DistType:=Normal
    else if UniButton.Checked  then DistType:=Uniform
    else                            DistType:=Lognormal;
  UpdateScreen;
end;

procedure TDistributionForm.CumuButtonClick(Sender: TObject);
begin
  If ProbButton.Checked then TempDist.DisplayCDF:=False
                        else TempDist.DisplayCDF:=True;
  UpdateScreen;

end;

end.
