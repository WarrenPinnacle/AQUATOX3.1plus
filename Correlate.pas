//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
{ Form Template - Source and Destination Choices Lists }
unit Correlate;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons, MatrixMath,
  StdCtrls, ExtCtrls, Uncert, Global, SysUtils, Dialogs, AQBaseForm, RandNum, hh;

type
  TCorrelateForm = class(TAQBase)
    OKBtn: TBitBtn;
    Panel1: TPanel;
    SrcLabel: TLabel;
    CorrList: TListBox;
    HelpButton: TButton;
    DistList: TListBox;
    Label1: TLabel;
    RemCorr: TButton;
    SummarizeButt: TButton;
    RemoveCorrB: TButton;
    EditCorr: TButton;
    AddCorr: TButton;
    Memo1: TMemo;
    procedure HelpButtonClick(Sender: TObject);
    procedure RemoveCorrBClick(Sender: TObject);
    procedure AddCorrClick(Sender: TObject);
    procedure RemCorrClick(Sender: TObject);
    procedure EditCorrClick(Sender: TObject);
    procedure CorrListClick(Sender: TObject);
    procedure DistListClick(Sender: TObject);
    procedure CorrListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CorrListDblClick(Sender: TObject);
    procedure SummarizeButtClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    IndexArray: Array of Integer;
    NumDists: Integer;
    TDist: TDistributionList;
    Function ScreenDist(j: Integer): Integer;
    Procedure UpdateScreen;
  public
    Changed: Boolean;
    PUncertainty: PUncertainty_Setup_Record;
    Procedure CorrelateSetup(TDists: TDistributionList);
  end;

var
  CorrelateForm: TCorrelateForm;

implementation

uses Corr_Edit;

{$R *.DFM}



Procedure TCorrelateForm.UpdateScreen;

  {------------------------------------------------------------------------------}
   Function AddToCorrList(Var TC: TCorrelation): Boolean;
   Var N1Str,N2Str: String;
       Indx: Integer;
       PD: TDistribution;
   Begin
     AddToCorrList := False;

     With TC do
      If Not TDist.FindDistrib(DistNum1, SVID1, TxRc1,Indx) then Exit;
     PD := TDist.At(Indx);
     If Not PD.UseDist then Exit;
     N1Str := IntToStr(ScreenDist(Indx)+1)+'. '+PD.Name;

     With TC do
      If Not TDist.FindDistrib(DistNum2, SVID2, TxRc2,Indx) then Exit;
     PD := TDist.At(Indx);
     If Not PD.UseDist then Exit;
     N2Str := IntToStr(ScreenDist(Indx)+1)+'. '+PD.Name;

     AddToCorrList := True;
     CorrList.Items.Add(N1Str + '   TO   ' + N2Str + ' : '+FloatToStrF(TC.Correl,ffgeneral,4,4));

   End;

  {------------------------------------------------------------------------------}
Var i: Integer;
Begin
  CorrList.Clear;

  For i := 0 to TDist.NumCorrelations-1 do
    If Not AddToCorrList(TDist.Correlations[i]) then TDist.RemoveCorr(i);

  CorrListClick(nil);
  Update;
End;

Function TCorrelateForm.ScreenDist(j: Integer): Integer;
Var i: Integer;
Begin
  ScreenDist := -1;
  For i := 0 to NumDists-1 do
    If j = IndexArray[i] then ScreenDist := i;
End;

Procedure TCorrelateForm.CorrelateSetup(TDists: TDistributionList);

  {------------------------------------------------------------------------------}
  Procedure AddToDistList(P: TDistribution);
  Var NStr, DStr:String;
    Begin
      NStr := IntToStr(NumDists)+'. '+P.Name;

       Case P.DistType of
            Triangular: DStr := DStr + 'Triangular';
            Normal    : DStr := DStr + 'Normal';
            LogNormal : DStr := DStr + 'LogNormal';
            Uniform   : DStr := DStr + 'Uniform';
          end; {case}

       DStr := ':    ('+DStr + ' Distribution, ';

       Case P.DistType of
          Triangular: begin
                        DStr := DStr + 'Most Likely = '+FloatToStrF(P.Parm[1],ffgeneral,9,4);
                        DStr := DStr + ', Min = '+FloatToStrF(P.Parm[2],ffgeneral,9,4);
                        DStr := DStr + ', Max = '+FloatToStrF(P.Parm[3],ffgeneral,9,4)+')';
                      end;
          Normal, LogNormal    : begin
                        DStr := DStr + 'Mean = '+FloatToStrF(P.Parm[1],ffgeneral,9,4);
                        DStr := DStr + ', Std. Dev. = '+FloatToStrF(P.Parm[2],ffgeneral,9,4)+')';
                      end;
          Uniform   : begin
                        DStr := DStr + 'Min = '+FloatToStrF(P.Parm[1],ffgeneral,9,4);
                        DStr := DStr + ', Max = '+FloatToStrF(P.Parm[2],ffgeneral,9,4)+')';
                      end;
        End; {Case}

      DistList.Items.Add(NStr + DStr);

    End;
  {------------------------------------------------------------------------------}
Var i: Integer;
Begin
  TDist := TDists;

  NumDists := 0;
  SetLength(IndexArray,TDist.Count);

  With TDist do For i:=0 to count-1 do
   If TDistribution(at(i)).UseDist then
     Begin
       Inc(NumDists);
       AddToDistList(at(i));
       IndexArray[NumDists-1] := i;
     End;

  CorrListClick(nil);
  Changed := False;

  UpdateScreen;
  ShowModal;
  IndexArray := nil;
End;

{-------------------------------------------------------------------------}

procedure TCorrelateForm.HelpButtonClick(Sender: TObject);
begin
   HTMLHelpContext('Correlations.html');
end;

procedure TCorrelateForm.RemoveCorrBClick(Sender: TObject);
begin
  If CorrList.ItemIndex = -1 then RemoveCorrB.Enabled := False
                             else TDist.RemoveCorr(CorrList.ItemIndex);
  UpdateScreen;
end;

procedure TCorrelateForm.AddCorrClick(Sender: TObject);
Var NC: Integer;
begin
  With TDist do
    Begin
      Inc(NumCorrelations);
      If Length(Correlations) < NumCorrelations then
        SetLength(Correlations, NumCorrelations + 7);
      With Correlations[NumCorrelations-1] do
        Begin
          DistNum1 := -1;
          DistNum2 := -1;
          Correl := 0;
        End;

      If not EditCorrForm.EditCorr(TDist,NumCorrelations-1,@IndexArray,DistList.Items,-1,-1)
         then Dec(NumCorrelations)
         else Changed := True;
    End;

  NC := TDist.NumCorrelations;
  TDist.updatecorrelations;
  If NC <> TDist.NumCorrelations then
     MessageDlg('That is dupliate to an existing correlation.  It has been deleted.',mtinformation,[mbok],0);

  UpdateScreen;
end;

procedure TCorrelateForm.RemCorrClick(Sender: TObject);
Var i: Integer;
begin
  If TDist.NumCorrelations = 0 then exit;
  If MessageDlg('Remove All Correlations from Selected Study?',mtconfirmation,
                 [mbok,mbcancel],0) = mrcancel then exit;
  For i := TDist.NumCorrelations-1 downto 0 do
    TDist.RemoveCorr(i);

  Changed := True;
  UpdateScreen;  

end;

procedure TCorrelateForm.EditCorrClick(Sender: TObject);
Var I1, I2: Integer;
begin
  If CorrList.ItemIndex = -1
    then begin EditCorr.Enabled := False; exit; end;

  With TDist.Correlations[CorrList.ItemIndex] do
    Begin
      TDist.FindDistrib(DistNum1,SVID1,TxRc1,I1);
      TDist.FindDistrib(DistNum2,SVID2,TxRc2,I2);
    End;

  i1 := ScreenDist(i1);
  i2 := ScreenDist(i2);

  If EditCorrForm.EditCorr(TDist,CorrList.ItemIndex,@IndexArray,DistList.Items,I1,I2) then Changed := True;

  UpdateScreen;
end;

procedure TCorrelateForm.CorrListClick(Sender: TObject);
begin
  EditCorr.Enabled :=  (CorrList.ItemIndex > -1);
  RemoveCorrB.Enabled := (CorrList.ItemIndex > -1);
end;

procedure TCorrelateForm.DistListClick(Sender: TObject);
begin
 DistList.ItemIndex := -1;
end;

procedure TCorrelateForm.CorrListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   If Key=VK_DELETE then RemoveCorrBClick(Sender);
   If Key=VK_INSERT then AddCorrClick(Sender);
   If Key=VK_RETURN then EditCorrClick(Sender);
end;

procedure TCorrelateForm.CorrListDblClick(Sender: TObject);
begin
  EditCorrClick(sender);
end;

procedure TCorrelateForm.SummarizeButtClick(Sender: TObject);

    {--------------------------------------------------------------------------}
    Function FixFloattoStr(F: Double;L: Integer): String;
    Var SubStr : String;
        Loop: Integer;
    Begin
      SubStr := FloatToStrF(F,ffGeneral,L-4,3);
      If (Pos('.',SubStr)=0) and (Pos('E',SubStr)=0) then SubStr := SubStr+'.';
      If Length(SubStr)>=L then SubStr := FloatToStrF(F,ffExponent,L-5,1);
      If (Pos('.',SubStr)=0) and (Pos('E',SubStr)=0) then SubStr := SubStr+'.';
      If Length(SubStr)>=L then SubStr := FloatToStrF(F,ffExponent,L-6,1);
{      If Length(SubStr)>=L then
        Begin
           Raise EConvertError.Create('Error, FixFloat too Large');
        End;                                                        }
      For Loop := Length(SubStr)+1 to L do
        SubStr := ' '+SubStr;
      FixFloatToStr := SubStr;
    End;
    {--------------------------------------------------------------------------}
    Procedure WriteSqMatrix(SM:TSquareMatrix; Title: String);
    Var AddStr: String;
        i,j: Integer;
    Begin
      Memo1.Lines.Add('');
      AddStr := '';
      For i := 1 to SM.MSize do
        If (i=(SM.MSize div 2)) then AddStr := AddStr +' '+Title+' '
        else AddStr := AddStr+ '--------';
      Memo1.Lines.Add(AddStr);
      Memo1.Lines.Add('');


      For i := 1 to SM.MSize do
        Begin
          AddStr := '';
          For j := 1 to SM.MSize do
            AddStr := AddStr + FixFloatToStr(SM.Matrix[i,j],7) + ' ';
          Memo1.Lines.Add(AddStr);
          Memo1.Lines.Add('');
        End;

    End;
    {--------------------------------------------------------------------------}
    Procedure WriteMatrix(M:TMatrix; Title: String);

    Var AddStr: String;
        i,j: Integer;
    Begin
      Memo1.Lines.Add('');
      AddStr := '';
      For i := 1 to M.MWidth do
        If (i=(M.MWidth div 2)) then AddStr := AddStr +' '+Title+' '
        else AddStr := AddStr+ '--------';
      Memo1.Lines.Add(AddStr);
      Memo1.Lines.Add('');

      For i := 1 to M.MLength do
        Begin
          AddStr := '';
          For j := 1 to M.MWidth do
            AddStr := AddStr + FixFloatToStr(M.Matrix[i,j],7) + ' ';
          Memo1.Lines.Add(AddStr);
          Memo1.Lines.Add('');
        End;

    End;
    {--------------------------------------------------------------------------}
Var P, CM, S, InvQ,Q, S_Prime, T: TSquareMatrix;
    CorrDraws, DrawsM: TMatrix;
    i: Integer;
begin
  If Memo1.Visible then
    Begin
      Memo1.Visible := False;
      SummarizeButt.Caption := 'Summarize Correlation Matrix';
      Exit;
    End;

  SummarizeButt.Caption := 'Hide Matrix Summary';
  If TDist.NumCorrelations = 0 then exit;
  Memo1.Visible := True;
  Memo1.BringToFront;
  Memo1.Lines.Clear;

  CM := nil;
  TDist.MakeCMatrix(CM);
  WriteSqMatrix(CM, ' Correlation ');

{  NumTries := 0;
  Repeat  }

  P := TSquareMatrix.Create(CM.MSize);
  Try
{   NoError := True; }
    choldc(CM,P);  {Perform a Cholesky decomposition of the covariance matrix}
  Except
    Memo1.Lines.Add('ERROR:  MATRIX IS NOT POSITIVE DEFINITE, IMAN CONOVER METHOD NOT POSSIBLE');
    P.Free;
    CM.Free;
    Exit;

{    NoError := False;
    TDist.ShiftCMatrix(CM);       It doesn't matter how the rows & columns are shuffled, once positive definite always positive definite,  jsc, 10-02-2006
    WriteSqMatrix(CM, ' Shift ');  Commented out code tested and discovered the above proposition.
    Inc(NumTries);                }

  End;

{  Until NoError or (NumTries > 10);
  If Not NoError
    Then
      Begin
       P.Free;
       CM.Free;
       Exit;
      End;                           }


  Memo1.Lines.Add('');
  Memo1.Lines.Add('ROW AND COLUMN ORDER:');
  For i:=0 to DistList.Items.Count -1 do
    Memo1.Lines.Add(DistList.Items[i]);

  If PUncertainty^.UseSeed then SetSeed(PUncertainty^.RandomSeed)
                           else SetSeed(-1);

  TDist.FillVariableDraws(PUncertainty^.NumSteps,PUncertainty^.RandomSampling);

  TDist.MakeFillsMatrix(DrawsM,PUncertainty^.NumSteps);
{  WriteMatrix(DrawsM, ' Intervals '); }

  T := TSquareMatrix.Create(CM.MSize);
  Q := TSquareMatrix.Create(CM.MSize);
  S := TSquareMatrix.Create(CM.MSize);

  If DrawsM.MLength <2 then
    Begin
      Memo1.Lines.Add('');
      Memo1.Lines.Add('ERROR:  You must specify more than one uncertainty iteration');
      Memo1.Lines.Add('to calculate the rank correlation of draws.');
      P.Free;
      CM.Free;
      T.Free;
      Q.Free;
      S.Free;

      Exit;
    End;

  Correl(DrawsM,T);
{  WriteSqMatrix(T,' Initial Correl. '); }

  Try
    choldc(T,Q);
  Except
    Memo1.Lines.Add('');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('ERROR:  Cannot induce rank correlation with that number of uncertainty iterations');
    Memo1.Lines.Add('Try increasing the number of uncertainty iterations.');
    P.Free;
    CM.Free;
    T.Free;
    Q.Free;
    S.Free;
    Exit;
  End;
  {WriteSqMatrix(Q,' Q '); }

  InvQ := TSquareMatrix.CopyMatrix(Q);
  InvertMat(InvQ);  {invert with LU decomposition}

  SqrMatMult(P,INVQ,S);

  S_Prime := TSquareMatrix.CopyMatrix(S);
  TransposeMat(S_Prime);

  CorrDraws := TMatrix.Create(DrawsM.MWidth,DrawsM.MLength);
  MatMult(DrawsM,S_prime,CorrDraws);
{  WriteMatrix(CorrDraws, ' Correlated Intervals '); }

  Spearman(CorrDraws,T);
  WriteSqMatrix(T,' Rank Correl. of Draws ');

  P.Free;
  CM.Free;
  S.Free; S_Prime.Free;
  Q.Free; InvQ.Free;
  T.Free;
  DrawsM.Free;
  CorrDraws.Free;

(*

{---------- TEST CODE BELOW --------------}
{  REPRODUCES IMAN & CONOVER 1982 }

Type TestM = Array[1..15,1..6] of double;
     TestSM = Array[1..6,1..6] of double;
Const AMatrix: TestSM =
      ((1,0,0, 0    , 0    ,0    ),
       (0,1,0, 0    , 0    ,0    ),
       (0,0,1, 0    , 0    ,0    ),
       (0,0,0, 1    , 0.75 ,-0.70),
       (0,0,0, 0.75 , 1    ,-0.95),
       (0,0,0,-0.70 ,-0.95 ,1    ));

Const Rnd: TestM =
    (( 1.534,   1.534,   -1.534,   -1.534,   0.489,   -0.319 ),
    (-0.887,   -0.489,   0.887,   -0.887,   -0.157,   0.674  ),
    (-0.489,   0.674,   -0.489,   1.150,   1.534,   -0.489   ),
    (0.887,   0.000,   -0.674,   0.319,   0.000,   -1.534    ),
    (1.150,   -0.319,   0.489,   0.674,   0.157,   1.150     ),
    (0.157,   -1.534,   -0.887,   -0.674,   -0.319,   0.157  ),
    (-1.150,   -0.674,   -0.157,   0.157,   -1.534,   -0.157 ),
    (0.000,   -0.887,   0.157,   -0.319,   -0.674,   0.887   ),
    (0.319,   -0.157,   0.674,   0.887,   0.674,   1.534     ),
    (-0.319,   0.157,   -0.319,   -1.150,   1.150,   -0.887  ),
    (-1.534,   0.887,   1.150,   1.534,   -0.489,   -1.150   ),
    (-0.157,   -1.150,   1.534,   -0.157,   -1.150,   -0.674 ),
    (0.489,   0.489,   -1.150,   0.489,   -0.887,   0.000    ),
    (0.674,   0.319,   0.319,   0.000,   0.887,   0.319      ),
    (-0.674,   1.150,   0.000,   -0.489,   0.319,   0.489    ));

Var P,P_prime,T,C,S,MB,S_prime,Q,InvQ,Identity: TSquareMatrix;
    RndMat, ResMat,ResMat2: TMatrix;
    i, J: Integer;

Begin

  If Memo1.Visible then
    Begin
      Memo1.Visible := False;
      SummarizeButt.Caption := 'Summarize Correlation Matrix';
      Exit;
    End;

  SummarizeButt.Caption := 'Hide Matrix Summary';
  If TDist.NumCorrelations = 0 then exit;
  Memo1.Visible := True;
  Memo1.BringToFront;
  Memo1.Lines.Clear;
    
  p := TSquareMatrix.Create(6);
  C := TSquareMatrix.Create(6);
  Q := TSquareMatrix.Create(6);
  S := TSquareMatrix.Create(6);
  T := TSquareMatrix.Create(6);
  MB := TSquareMatrix.Create(6);
  Identity := TSquareMatrix.Create(6);

  For i := 1 to 6 do
   For j := 1 to 6 do
    C.Matrix[i,j] := AMatrix[i,j];

  ResMat := TMatrix.Create(6,15);
  ResMat2 := TMatrix.Create(6,15);
  RndMat := TMatrix.Create(6,15);
  For i := 1 to 15 do
   For j := 1 to 6 do
    RndMat.Matrix[i,j] := Rnd[i,j];

  choldc(C,P);  {Perform a Cholesky decomposition of the covariance matrix}
  WriteSqMatrix(C,' C* ');
  WriteSqMatrix(P,' P ');

  P_prime := TSquareMatrix.CopyMatrix(P);
  TransposeMat(P_Prime);

  MatMult(RndMat,P_prime,ResMat);
  WriteMatrix(RndMat,' R ');

  Correl(RndMat,T);
  WriteSqMatrix(T,' T ');

  WriteMatrix(ResMat, ' R* ');
  Spearman(ResMat,MB);
  WriteSqMatrix(MB,' M ');

  choldc(T,Q);

  WriteSqMatrix(Q,' Q ');

  InvQ := TSquareMatrix.CopyMatrix(Q);
  InvertMat(InvQ);  {invert with LU decomposition}
  SqrMatMult(P,INVQ,S);

  WriteSqMatrix(S, ' S ');

  SqrMatMult(Q,InvQ,Identity);
  S_Prime := TSquareMatrix.CopyMatrix(S);

  TransposeMat(S_Prime);

  MatMult(RndMat,S_prime,ResMat2);
  WriteMatrix(ResMat2, ' RB* ');

  Spearman(ResMat2,MB);
  WriteSqMatrix(MB, ' MB* ');

  p.free;
  T.Free;
  C.free;
  S.free;
  MB.free;
  S_prime.free;
  Q.free;
  InvQ.free;
  Identity.free;
  RndMat.free;
  ResMat.free;
  ResMat2.free;

{ --- TEST CODE ABOVE  REPRODUCES IMAN & CONOVER 1982 ----- } *)

end;

procedure TCorrelateForm.OKBtnClick(Sender: TObject);
Var P,CM: TSquareMatrix;
begin
  If Changed then
    If TDist.NumCorrelations > 0 then
      Begin
        CM := nil;
        TDist.MakeCMatrix(CM);

        P := TSquareMatrix.Create(CM.MSize);
        Try
          choldc(CM,P);  {Perform a Cholesky decomposition of the covariance matrix}
          p.Free;
          Cm.Free;

        Except
          p.Free;
          Cm.Free;
          If MessageDlg('Error, the correlations you have described do not produce '+
             'a positive definite matrix.  Uncertainty will not run.',mterror,[mbok,mbcancel],0)=mrcancel then exit;
        End;
      End;

  ModalResult := MROK;
end;

end.
