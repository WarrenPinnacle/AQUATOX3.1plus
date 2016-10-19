(***********************************************  **************************
Copyright (c) 1992-2007 The University of Tennessee. All rights reserved.

Contributors:
    * Sergey Bochkanov (ALGLIB project). Translation from FORTRAN to
      pseudocode.
    * Jonathan Clough, AQUATOX, modification to work with TSquareMatrix Class
      for use with AQUATOX.  Validated against non open-source Numerical Recipes Code

See subroutines comments for additional copyrights.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

- Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.

- Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer listed
  in this license in the documentation and/or other materials
  provided with the distribution.

- Neither the name of the copyright holders nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*************************************************************************)
unit MatrixLu;
interface
uses Math, Sysutils, MatrixAp, MatrixMath;

procedure LUDecomposition(var A : TSquareMatrix;
     M : Integer;
     N : Integer;
     var Pivots : IVect);
procedure LUDecompositionUnpacked(A : TSquareMatrix;
     M : Integer;
     N : Integer;
     var L : TSquareMatrix;
     var U : TSquareMatrix;
     var Pivots : IVect);

implementation

const
    LUNB = 8;

procedure RMatrixLU2(var A : TSquareMatrix;
     M : Integer;
     N : Integer;
     var Pivots : IVect);forward;


(*************************************************************************
LU decomposition of a general matrix of size MxN

The subroutine calculates the LU decomposition of a rectangular general
matrix with partial pivoting (with row permutations).

Input parameters:
    A   -   matrix A whose indexes range within [0..M-1, 0..N-1].
    M   -   number of rows in matrix A.
    N   -   number of columns in matrix A.

Output parameters:
    A   -   matrices L and U in compact form (see below).
            Array whose indexes range within [0..M-1, 0..N-1].
    Pivots - permutation matrix in compact form (see below).
            Array whose index ranges within [0..Min(M-1,N-1)].

Matrix A is represented as A = P * L * U, where P is a permutation matrix,
matrix L - lower triangular (or lower trapezoid, if M>N) matrix,
U - upper triangular (or upper trapezoid, if M<N) matrix.

Let M be equal to 4 and N be equal to 3:

                   (  1          )    ( U11 U12 U13  )
A = P1 * P2 * P3 * ( L21  1      )  * (     U22 U23  )
                   ( L31 L32  1  )    (         U33  )
                   ( L41 L42 L43 )

Matrix L has size MxMin(M,N), matrix U has size Min(M,N)xN, matrix P(i) is
a permutation of the identity matrix of size MxM with numbers I and Pivots[I].

The algorithm returns array Pivots and the following matrix which replaces
matrix A and contains matrices L and U in compact form (the example applies
to M=4, N=3).

 ( U11 U12 U13 )
 ( L21 U22 U23 )
 ( L31 L32 U33 )
 ( L41 L42 L43 )

As we can see, the unit diagonal isn't stored.

  -- LAPACK routine (version 3.0) --
     Univ. of Tennessee, Univ. of California Berkeley, NAG Ltd.,
     Courant Institute, Argonne National Lab, and Rice University
     June 30, 1992
*************************************************************************)

(*************************************************************************
Obsolete 1-based subroutine. Left for backward compatibility.
See RMatrixLU for 0-based replacement.
*************************************************************************)
procedure LUDecomposition(var A : TSquareMatrix;
     M : Integer;
     N : Integer;
     var Pivots : IVect);
var
    I : Integer;
    J : Integer;
    JP : Integer;
    T1 : IVect;
    s : Double;
    i_ : Integer;
begin
    SetLength(Pivots, Min(M, N)+1);
    SetLength(T1, Max(M, N)+1);
    Assert((M>=0) and (N>=0), 'Error in LUDecomposition: incorrect function arguments');
    
    //
    // Quick return if possible
    //
    if (M=0) or (N=0) then
    begin
        T1 := nil;  {JSC}
        Exit;
    end;
    J:=1;
    while J<=Min(M, N) do
    begin

        //
        // Find pivot and test for singularity.
        //
        JP := J;
        I:=J+1;
        while I<=M do
        begin
            if Abs(A.Matrix[I,J])>Abs(A.Matrix[JP,J]) then
            begin
                JP := I;
            end;
            Inc(I);
        end;
        Pivots[J] := JP;
        if A.Matrix[JP,J]<>0 then
        begin
            
            //
            //Apply the interchange to rows
            //
            if JP<>J then
            begin
                APVMove(@T1[0], 1, N, @A.Matrix[J][0], 1, N);
                APVMove(@A.Matrix[J][0], 1, N, @A.Matrix[JP][0], 1, N);
                APVMove(@A.Matrix[JP][0], 1, N, @T1[0], 1, N);
            end;
            
            //
            //Compute elements J+1:M of J-th column.
            //
            if J<M then
            begin
                
                //
                // CALL DSCAL( M-J, ONE / A( J, J ), A( J+1, J ), 1 )
                //
                JP := J+1;
                S := 1/A.Matrix[J,J];
                for i_ := JP to M do
                begin
                    A.Matrix[i_,J] := S*A.Matrix[i_,J];
                end;
            end;
        end;
        if J<Min(M, N) then
        begin
            
            //
            //Update trailing submatrix.
            //CALL DGER( M-J, N-J, -ONE, A( J+1, J ), 1, A( J, J+1 ), LDA,A( J+1, J+1 ), LDA )
            //
            JP := J+1;
            I:=J+1;
            while I<=M do
            begin
                S := A.Matrix[I,J];
                APVSub(@A.Matrix[I][0], JP, N, @A.Matrix[J][0], JP, N, S);
                Inc(I);
            end;
        end;
        Inc(J);
    end;
    T1 := nil;  {JSC}
end;


(*************************************************************************
Obsolete 1-based subroutine. Left for backward compatibility.
*************************************************************************)
procedure LUDecompositionUnpacked(A : TSquareMatrix;
     M : Integer;
     N : Integer;
     var L : TSquareMatrix;
     var U : TSquareMatrix;
     var Pivots : IVect);
var
    I : Integer;
    J : Integer;
    MinMN : Integer;
begin
{    A := DynamicArrayCopy(A); }
    if (M=0) or (N=0) then
    begin
        Exit;
    end;
    MinMN := Min(M, N);
    SetLength(L.Matrix, M+1, MinMN+1);
    SetLength(U.Matrix, MinMN+1, N+1);
    LUDecomposition(A, M, N, Pivots);
    I:=1;
    while I<=M do
    begin
        J:=1;
        while J<=MinMN do
        begin
            if J>I then
            begin
                L.Matrix[I,J] := 0;
            end;
            if J=I then
            begin
                L.Matrix[I,J] := 1;
            end;
            if J<I then
            begin
                L.Matrix[I,J] := A.Matrix[I,J];
            end;
            Inc(J);
        end;
        Inc(I);
    end;
    I:=1;
    while I<=MinMN do
    begin
        J:=1;
        while J<=N do
        begin
            if J<I then
            begin
                U.Matrix[I,J] := 0;
            end;
            if J>=I then
            begin
                U.Matrix[I,J] := A.Matrix[I,J];
            end;
            Inc(J);
        end;
        Inc(I);
    end;
end;


(*************************************************************************
Level 2 BLAS version of RMatrixLU

  -- LAPACK routine (version 3.0) --
     Univ. of Tennessee, Univ. of California Berkeley, NAG Ltd.,
     Courant Institute, Argonne National Lab, and Rice University
     June 30, 1992
*************************************************************************)
procedure RMatrixLU2(var A : TSquareMatrix;
     M : Integer;
     N : Integer;
     var Pivots : IVect);
var
    I : Integer;
    J : Integer;
    JP : Integer;
    T1 : IVect;
    s : Double;
    i_ : Integer;
begin
    SetLength(Pivots, Min(M-1, N-1)+1);
    SetLength(T1, Max(M-1, N-1)+1);
    Assert((M>=0) and (N>=0), 'Error in LUDecomposition: incorrect function arguments');
    
    //
    // Quick return if possible
    //
    if (M=0) or (N=0) then
    begin
        Exit;
    end;
    J:=0;
    while J<=Min(M-1, N-1) do
    begin
        
        //
        // Find pivot and test for singularity.
        //
        JP := J;
        I:=J+1;
        while I<=M-1 do
        begin
            if AbsReal(A.Matrix[I,J])>AbsReal(A.Matrix[JP,J]) then
            begin
                JP := I;
            end;
            Inc(I);
        end;
        Pivots[J] := JP;
        if A.Matrix[JP,J]<>0 then
        begin
            
            //
            //Apply the interchange to rows
            //
            if JP<>J then
            begin
                APVMove(@T1[0], 0, N-1, @A.Matrix[J][0], 0, N-1);
                APVMove(@A.Matrix[J][0], 0, N-1, @A.Matrix[JP][0], 0, N-1);
                APVMove(@A.Matrix[JP][0], 0, N-1, @T1[0], 0, N-1);
            end;
            
            //
            //Compute elements J+1:M of J-th column.
            //
            if J<M then
            begin
                JP := J+1;
                S := 1/A.Matrix[J,J];
                for i_ := JP to M-1 do
                begin
                    A.Matrix[i_,J] := S*A.Matrix[i_,J];
                end;
            end;
        end;
        if J<Min(M, N)-1 then
        begin
            
            //
            //Update trailing submatrix.
            //
            JP := J+1;
            I:=J+1;
            while I<=M-1 do
            begin
                S := A.Matrix[I,J];
                APVSub(@A.Matrix[I][0], JP, N-1, @A.Matrix[J][0], JP, N-1, S);
                Inc(I);
            end;
        end;
        Inc(J);
    end;
end;


end.