(*************************************************************************
Copyright (c) 1992-2007 The University of Tennessee.  All rights reserved.

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
unit MatrixTInv;
interface
uses Math, MatrixAp, Sysutils, MatrixMath;

function RMatrixTRInverse(var A : TSquareMatrix;
     N : Integer;
     IsUpper : Boolean;
     IsUnitTriangular : Boolean):Boolean;
function InvTriangular(var A : TSquareMatrix;
     N : Integer;
     IsUpper : Boolean;
     IsUnitTriangular : Boolean):Boolean;

implementation

(*************************************************************************
Triangular matrix inversion

The subroutine inverts the following types of matrices:
    * upper triangular
    * upper triangular with unit diagonal
    * lower triangular
    * lower triangular with unit diagonal

In case of an upper (lower) triangular matrix,  the  inverse  matrix  will
also be upper (lower) triangular, and after the end of the algorithm,  the
inverse matrix replaces the source matrix. The elements  below (above) the
main diagonal are not changed by the algorithm.

If  the matrix  has a unit diagonal, the inverse matrix also  has  a  unit
diagonal, and the diagonal elements are not passed to the algorithm.

Input parameters:
    A       -   matrix.
                Array whose indexes range within [0..N-1, 0..N-1].
    N       -   size of matrix A.
    IsUpper -   True, if the matrix is upper triangular.
    IsUnitTriangular
            -   True, if the matrix has a unit diagonal.

Output parameters:
    A       -   inverse matrix (if the problem is not degenerate).

Result:
    True, if the matrix is not singular.
    False, if the matrix is singular.

  -- LAPACK routine (version 3.0) --
     Univ. of Tennessee, Univ. of California Berkeley, NAG Ltd.,
     Courant Institute, Argonne National Lab, and Rice University
     February 29, 1992
*************************************************************************)
function RMatrixTRInverse(var A : TSquareMatrix;
     N : Integer;
     IsUpper : Boolean;
     IsUnitTriangular : Boolean):Boolean;
var
    NOUNIT : Boolean;
    I : Integer;
    J : Integer;
    V : Double;
    AJJ : Double;
    T : TReal1DArray;
    i_ : Integer;
begin
    Result := True;
    SetLength(T, N-1+1);
    
    //
    // Test the input parameters.
    //
    NOUNIT :=  not IsUnitTriangular;
    if IsUpper then
    begin
        
        //
        // Compute inverse of upper triangular matrix.
        //
        J:=0;
        while J<=N-1 do
        begin
            if NOUNIT then
            begin
                if A.Matrix[J,J]=0 then
                begin
                    Result := False;
                    Exit;
                end;
                A.Matrix[J,J] := 1/A.Matrix[J,J];
                AJJ := -A.Matrix[J,J];
            end
            else
            begin
                AJJ := -1;
            end;
            
            //
            // Compute elements 1:j-1 of j-th column.
            //
            if J>0 then
            begin
                for i_ := 0 to J-1 do
                begin
                    T[i_] := A.Matrix[i_,J];
                end;
                I:=0;
                while I<=J-1 do
                begin
                    if I<J-1 then
                    begin
                        V := APVDotProduct(@A.Matrix[I][0], I+1, J-1, @T[0], I+1, J-1);
                    end
                    else
                    begin
                        V := 0;
                    end;
                    if NOUNIT then
                    begin
                        A.Matrix[I,J] := V+A.Matrix[I,I]*T[I];
                    end
                    else
                    begin
                        A.Matrix[I,J] := V+T[I];
                    end;
                    Inc(I);
                end;
                for i_ := 0 to J-1 do
                begin
                    A.Matrix[i_,J] := AJJ*A.Matrix[i_,J];
                end;
            end;
            Inc(J);
        end;
    end
    else
    begin
        
        //
        // Compute inverse of lower triangular matrix.
        //
        J:=N-1;
        while J>=0 do
        begin
            if NOUNIT then
            begin
                if A.Matrix[J,J]=0 then
                begin
                    Result := False;
                    Exit;
                end;
                A.Matrix[J,J] := 1/A.Matrix[J,J];
                AJJ := -A.Matrix[J,J];
            end
            else
            begin
                AJJ := -1;
            end;
            if J<N-1 then
            begin
                
                //
                // Compute elements j+1:n of j-th column.
                //
                for i_ := J+1 to N-1 do
                begin
                    T[i_] := A.Matrix[i_,J];
                end;
                I:=J+1;
                while I<=N-1 do
                begin
                    if I>J+1 then
                    begin
                        V := APVDotProduct(@A.Matrix[I][0], J+1, I-1, @T[0], J+1, I-1);
                    end
                    else
                    begin
                        V := 0;
                    end;
                    if NOUNIT then
                    begin
                        A.Matrix[I,J] := V+A.Matrix[I,I]*T[I];
                    end
                    else
                    begin
                        A.Matrix[I,J] := V+T[I];
                    end;
                    Inc(I);
                end;
                for i_ := J+1 to N-1 do
                begin
                    A.Matrix[i_,J] := AJJ*A.Matrix[i_,J];
                end;
            end;
            Dec(J);
        end;
    end;
end;


(*************************************************************************
Obsolete 1-based subroutine.
See RMatrixTRInverse for 0-based replacement.
*************************************************************************)
function InvTriangular(var A : TSquareMatrix;
     N : Integer;
     IsUpper : Boolean;
     IsUnitTriangular : Boolean):Boolean;
var
    NOUNIT : Boolean;
    I : Integer;
    J : Integer;
{    NMJ : Integer; }
    JM1 : Integer;
    JP1 : Integer;
    V : Double;
    AJJ : Double;
    T : TReal1DArray;
    i_ : Integer;
begin
    Result := True;
    SetLength(T, N+1);
    
    //
    // Test the input parameters.
    //
    NOUNIT :=  not IsUnitTriangular;
    if IsUpper then
    begin
        
        //
        // Compute inverse of upper triangular matrix.
        //
        J:=1;
        while J<=N do
        begin
            if NOUNIT then
            begin
                if A.Matrix[J,J]=0 then
                begin
                    Result := False;
                    Exit;
                end;
                A.Matrix[J,J] := 1/A.Matrix[J,J];
                AJJ := -A.Matrix[J,J];
            end
            else
            begin
                AJJ := -1;
            end;

            //
            // Compute elements 1:j-1 of j-th column.
            //
            if J>1 then
            begin
                JM1 := J-1;
                for i_ := 1 to JM1 do
                begin
                    T[i_] := A.Matrix[i_,J];
                end;
                I:=1;
                while I<=J-1 do
                begin
                    if I<J-1 then
                    begin
                        V := APVDotProduct(@A.Matrix[I][0], I+1, JM1, @T[0], I+1, JM1);
                    end
                    else
                    begin
                        V := 0;
                    end;
                    if NOUNIT then
                    begin
                        A.Matrix[I,J] := V+A.Matrix[I,I]*T[I];
                    end
                    else
                    begin
                        A.Matrix[I,J] := V+T[I];
                    end;
                    Inc(I);
                end;
                for i_ := 1 to JM1 do
                begin
                    A.Matrix[i_,J] := AJJ*A.Matrix[i_,J];
                end;
            end;
            Inc(J);
        end;
    end
    else
    begin
        
        //
        // Compute inverse of lower triangular matrix.
        //
        J:=N;
        while J>=1 do
        begin
            if NOUNIT then
            begin
                if A.Matrix[J,J]=0 then
                begin
                    Result := False;
                    Exit;
                end;
                A.Matrix[J,J] := 1/A.Matrix[J,J];
                AJJ := -A.Matrix[J,J];
            end
            else
            begin
                AJJ := -1;
            end;
            if J<N then
            begin
                
                //
                // Compute elements j+1:n of j-th column.
                //
{                NMJ := N-J; }
                JP1 := J+1;
                for i_ := JP1 to N do
                begin
                    T[i_] := A.Matrix[i_,J];
                end;
                I:=J+1;
                while I<=N do
                begin
                    if I>J+1 then
                    begin
                        V := APVDotProduct(@A.Matrix[I][0], JP1, I-1, @T[0], JP1, I-1);
                    end
                    else
                    begin
                        V := 0;
                    end;
                    if NOUNIT then
                    begin
                        A.Matrix[I,J] := V+A.Matrix[I,I]*T[I];
                    end
                    else
                    begin
                        A.Matrix[I,J] := V+T[I];
                    end;
                    Inc(I);
                end;
                for i_ := JP1 to N do
                begin
                    A.Matrix[i_,J] := AJJ*A.Matrix[i_,J];
                end;
            end;
            Dec(J);
        end;
    end;
end;


end.