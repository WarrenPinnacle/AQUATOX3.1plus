//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//
unit matrixmath;

interface

Uses Global;

Type pSqMat = ^TSquareMatrix;   {Square Matrix}
     TSquareMatrix = Class
         Matrix : Array of Array of Double;
         MSize : Integer;
         Constructor Create(Sz: Integer);
         Constructor CopyMatrix(CM: TSquareMatrix);
         Destructor Free;
       End; {Record}

     pRMat = ^TMatrix;         {Potentially Rectangular Matrix}
     TMatrix = Class
       Matrix : Array of Array of Double;  {[Length, Width]  [Row,Col]}
       MWidth, MLength : Integer;
       Constructor Create(Wd,Ln: Integer);
       Constructor CopyMatrix(CM: TMatrix);
       Destructor Free;
     End;

     pIVect = ^IVect;
     IVect = Array of Integer;

     pVec = ^Vec;
     VEC = Array of Double;

Procedure choldc1(Var a:TSquareMatrix; Var p:pVEC);
Procedure choldc(A:TSquareMatrix; aa:TSquareMatrix);
Procedure MATMULT(A: TMatrix; B:TSquareMatrix; C: TMatrix);
Procedure SqrMATMULT(A: TSquareMatrix; B:TSquareMatrix; C: TSquareMatrix);
Procedure InvertMat(iMat: TSquareMatrix);
Procedure TransposeMat(iMat: TSquareMatrix);
Procedure Correl(iM:TMatrix; oM:TSquareMatrix);
Procedure Spearman(iM:TMatrix; oM:TSquareMatrix);

implementation

Uses MatrixLu, MatrixInv;

Constructor TSquareMatrix.Create(Sz: Integer);
Var i: Integer;
Begin
  SetLength(Matrix,Sz+1);
  For i := 1 to Sz do
    SetLength(Matrix[i],Sz+1);
  MSize := Sz;
End;

Constructor TSquareMatrix.CopyMatrix(CM: TSquareMatrix);
Var i,j: Integer;
Begin
  Create(CM.MSize);
  For i := 1 to MSize do
   For j := 1 to MSize do
    Matrix[i,j] := CM.Matrix[i,j];
  MSize := CM.MSize;
End;


Destructor TSquareMatrix.Free;
Var i: integer;
Begin
  If Matrix = nil then exit;
  For i := 1 to MSize do
    Matrix[i] := nil;
  Matrix := nil;
End;

{------------------------------------------------------------}

Constructor TMatrix.Create(Wd,Ln: Integer);
Var i: Integer;
Begin
  SetLength(Matrix,Ln+1);
  For i := 1 to Ln  do
    SetLength(Matrix[i],Wd+1);
  MWidth := Wd; MLength := Ln;
End;

Destructor TMatrix.Free;
Var i: integer;
Begin
  If Matrix = nil then exit;
  For i := 1 to MLength  do
    Matrix[i] := nil;
  Matrix := nil;
End;

Constructor TMatrix.CopyMatrix(CM: TMatrix);
Var i,j: Integer;
Begin
  Create(CM.MWidth,CM.MLength);
  For i := 1 to MLength do
   For j := 1 to MWidth do
    Matrix[i,j] := CM.Matrix[i,j];
  MWidth := CM.MWidth;
  MLength := CM.MLength;

End;


{  ------------------------------------------------------------------------
      main method for Cholesky decomposition.
      http://perso.orange.fr/jean-pierre.moreau/p_matrices.html
      input:         n  MSize of matrix
      input/output:  a  Symmetric positive def. matrix
      output:        p  vector of resulting diag of a
      author:        Vadim Kutsyy <vadim@kutsyy.com>   http://kutsyy.com
      modified:      Jonathan Clough, Use Object Oriented Dynamic Matrices
   ------------------------------------------------------------------------- }

        Procedure choldc1(Var a:TSquareMatrix; Var p:pVEC);
        Var n, i,j,k:integer; sum:double;
        Begin
          n := a.MSize;

          for i := 1 to n do
                begin
                  for j := i to n do
                  begin
                    sum := a.Matrix[i,j];
                    for k := i - 1 Downto 1 do
                      sum := sum - a.Matrix[i,k] * a.Matrix[j,k];
                    if i = j then
                    begin
                      if sum <= 0 then Raise EAQUATOXError.Create(' Matrix Math Error: matrix not positive definite');
                      p^[i] := sqrt(sum);
              end
                    else
                      a.Matrix[j,i] := sum / p^[i]
            end
                end
        End;


        Procedure choldc(A:TSquareMatrix; aa:TSquareMatrix);
      	Var n,i,j:integer; p:pVEC;
        Begin
          n := A.MSize;
          new(p);
          SetLength(p^,n+1);
          for i := 1 to n do
          for j := 1 to n do
            aa.Matrix[i,j] := A.Matrix[i,j];

        	  choldc1(aa, p);

          for i := 1 to n do
          begin
            aa.Matrix[i,i] := p^[i];
            for j := i + 1 to n do aa.Matrix[i,j] := 0.0
          end;
          Dispose(p)
        End;

{------------------------------------------------------------}

        Procedure SqrMATMULT(A: TSquareMatrix; B:TSquareMatrix; C: TSquareMatrix);
        {author:     Vadim Kutsyy <vadim@kutsyy.com>   http://kutsyy.com
                     http://perso.orange.fr/jean-pierre.moreau/p_matrices.html
                     modified to use object oriented dynamic matrices jsc }

        VAR
            SUM : DOUBLE;
            bwid: Integer;
            al,bw, K : integer;
        BEGIN
          bwid := B.MSize;

          for al:=1 to bwid do
           for bw :=1 to bwid do
            begin
              SUM:= 0.0;
              for K:=1 to bwid do
                SUM:=SUM+A.Matrix[al,K]*B.Matrix[K,bw];
              C.Matrix[al,bw]:=SUM
            end
        END;

        Procedure MATMULT(A: TMatrix; B:TSquareMatrix; C: TMatrix);
        {author:      Vadim Kutsyy <vadim@kutsyy.com>   http://kutsyy.com
                      http://perso.orange.fr/jean-pierre.moreau/p_matrices.html
                      modified to not require square matrices for pA (j.clough, 9-2006)
                      modified to use object oriented dynamic matrices jsc }

        VAR
            SUM : DOUBLE;
            alen,awid,bwid: Integer;
            al,bw, K : integer;
        BEGIN
          bwid := B.MSize;
          alen := A.MLength;
          awid := A.MWidth;

          for al:=1 to alen do
           for bw :=1 to bwid do
            begin
              SUM:= 0.0;
              for K:=1 to awid do
                SUM:=SUM+A.Matrix[al,K]*B.Matrix[K,bw];
              C.Matrix[al,bw]:=SUM
            end
        END;

   {------------------------------------------------------------}

   Procedure InvertMat(iMat: TSquareMatrix);
   {Matrix Inversion Procedure utilized from ALGLIB as translated from LAPACK
    see http://www.alglib.net  http://www.netlib.org/lapack/
    BSD Copyright notice shown in MatrixInv.Pas, MatrixInv.Pas, and MatrixLu.pas }

   Var Pivots: IVect;
   Begin
    LUDecomposition(iMat,iMat.MSize,iMat.MSize,Pivots);

    If Not InverseLU(iMat, Pivots, iMat.MSize) then
       Raise EAQUATOXERROR.CREATE('Iman Conover Error, Matrix Singular.');
    Pivots := nil;
   End;
   {------------------------------------------------------------}


   Procedure TransposeMat(iMat: TSquareMatrix);
   Var tmp: TSquareMatrix;
       i,j: Integer;
   Begin
     tmp := TSquareMatrix.CopyMatrix(iMat);
     For i:=1 to tmp.MSize do
      For j:=1 to tmp.MSize do
       iMat.Matrix[i,j] := tmp.Matrix[j,i];
   End;

   {------------------------------------------------------------}


  Procedure Spearman(iM:TMatrix; oM:TSquareMatrix);
  {Calculate the spearman correlation coefficients for input matrix iM
   and store them in output matrix oM}  {Jonathan Clough, 9-2006}
  Var SortMatrix, RankMatrix: TMatrix;

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
            For j := 1 to iM.MLength do
             Begin
              Val := iM.Matrix[j,col];
              For k := 1 to iM.MLength do
                If SortMatrix.Matrix[k,col] = Val then
                  Begin
                    RankMatrix.Matrix[j,col] := k;
                    Break;
                  End;
             End;
          End;
        {--------------------------------------------------------------------}

  Var len, wid, il, ol, ow, i: LongInt;
      SumDSqr: Double;
  Begin           {not optimized!}
    SortMatrix := TMatrix.CopyMatrix(iM);
     For i := 1 to SortMatrix.MWidth do
      QuickSortCol(i,1,SortMatrix.MLength);

    RankMatrix := TMatrix.Create(iM.MWidth, im.MLength);
     For i := 1 to RankMatrix.MWidth do
      RankCol(i);

    len := im.MLength;
    wid := im.MWidth;
    for ol := 1 to wid do
     for ow := 1 to wid do
       Begin
         SumDSqr := 0;
         for il := 1 to len do
           SumDSqr := SumDSqr + SQR(RankMatrix.Matrix[il,ol]-RankMatrix.Matrix[il,ow]);
         oM.Matrix[ol,ow] := 1- (6*SumDSqr)/(len*(SQR(Len)-1));
       End;

   SortMatrix.Free;
   RankMatrix.Free;

  End;


        {--------------------------------------------------------------------}


  {Calculate the correlation coefficients for input matrix iM
   and store them in output matrix oM}  {Jonathan Clough, 9-2006}
  Procedure Correl(iM:TMatrix; oM:TSquareMatrix);
  Var ol,ow,il: integer;
      dena,denb,num,xmean,ymean: double;
      len, wid: Integer;
  Begin
    len := im.MLength;
    wid := im.MWidth;
    for ol := 1 to wid do
     for ow := 1 to wid do
       Begin
         xmean := 0;
         ymean := 0;
         for il := 1 to len do
           Begin
             xmean := xmean + iM.Matrix[il,ol];
             ymean := ymean + iM.Matrix[il,ow];
           End;
         xmean := xmean / len;
         ymean := ymean / len;

         num := 0; dena := 0; denb := 0;
         for il := 1 to len do
           Begin
             num := num + (iM.Matrix[il,ol]-Xmean)*(iM.Matrix[il,ow]-Ymean);
             dena := dena + sqr(iM.Matrix[il,ol]-Xmean);
             denb := denb + sqr(iM.Matrix[il,ow]-Ymean);
           End;

          oM.Matrix[ol,ow] := num/sqrt(dena*denb);
       End;
  End;



end.
