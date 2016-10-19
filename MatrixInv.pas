(*************************************************************************
Copyright (c) 1992-2007 The University of Tennessee. All rights reserved.

Contributors:
    * Sergey Bochkanov (ALGLIB project). Translation from FORTRAN to
      pseudocode.
    * Jonathan Clough, AQUATOX, modification to work with TSquareMatrix Class
      for use with AQUATOX.  Tested against non open-source Numerical Recipes Code

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

unit MatrixInv;
interface
uses Math, Sysutils, MatrixAp, Matrixlu, MatrixTInv, MatrixMath;

Type
    TReal1DArray        = array of Double;

function InverseLU(var A : TSquareMatrix;
     const Pivots : IVect;
     N : Integer):Boolean;

implementation

(*************************************************************************
Inversion of a matrix given by its LU decomposition.

Input parameters:
    A       -   LU decomposition of the matrix (output of RMatrixLU subroutine).
    Pivots  -   table of permutations which were made during the LU decomposition
                (the output of RMatrixLU subroutine).
    N       -   size of matrix A.

Output parameters:
    A       -   inverse of matrix A.
                Array whose indexes range within [0..N-1, 0..N-1].

Result:
    True, if the matrix is not singular.
    False, if the matrix is singular.

  -- LAPACK routine (version 3.0) --
     Univ. of Tennessee, Univ. of California Berkeley, NAG Ltd.,
     Courant Institute, Argonne National Lab, and Rice University
     February 29, 1992
*************************************************************************)

    //
    // Solve the equation inv(A)*L = inv(U) for inv(A).
    //

(*************************************************************************
Obsolete 1-based subroutine.  {JSC, Utilized as AQUATOX TSqureMatrix is 1-based}

See RMatrixLUInverse for 0-based replacement.
*************************************************************************)
function InverseLU(var A : TSquareMatrix;
     const Pivots : IVect;
     N : Integer):Boolean;
var
    WORK : TReal1DArray;
    I : Integer;
{    IWS : Integer; }
    J : Integer;
{    JB : Integer;
    JJ : Integer; }
    JP : Integer;
    JP1 : Integer;
    V : Double;
    i_ : Integer;
begin
    Result := True;

    //
    // Quick return if possible
    //
    if N=0 then
    begin
        Exit;
    end;
    SetLength(WORK, N+1);
    
    //
    // Form inv(U)
    //
    if  not InvTriangular(A, N, True, False) then
    begin
        Result := False;
        Exit;
    end;
    
    //
    // Solve the equation inv(A)*L = inv(U) for inv(A).
    //
    J:=N;
    while J>=1 do
    begin
        
        //
        // Copy current column of L to WORK and replace with zeros.
        //
        I:=J+1;
        while I<=N do
        begin
            WORK[I] := A.Matrix[I,J];
            A.Matrix[I,J] := 0;
            Inc(I);
        end;
        
        //
        // Compute current column of inv(A).
        //
        if J<N then
        begin
            JP1 := J+1;
            I:=1;
            while I<=N do
            begin
                V := APVDotProduct(@A.Matrix[I][0], JP1, N, @WORK[0], JP1, N);
                A.Matrix[I,J] := A.Matrix[I,J]-V;
                Inc(I);
            end;
        end;
        Dec(J);
    end;
    
    //
    // Apply column interchanges.
    //
    J:=N-1;
    while J>=1 do
    begin
        JP := Pivots[J];
        if JP<>J then
        begin
            for i_ := 1 to N do
            begin
                WORK[i_] := A.Matrix[i_,J];
            end;
            for i_ := 1 to N do
            begin
                A.Matrix[i_,J] := A.Matrix[i_,JP];
            end;
            for i_ := 1 to N do
            begin
                A.Matrix[i_,JP] := WORK[i_];
            end;
        end;
        Dec(J);
    end;
end;



end.