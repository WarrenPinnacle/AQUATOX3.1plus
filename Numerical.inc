Procedure TAQUATOXSegment.Derivs(X : double; Step : word);
   {-------------------------------------------------}
   Procedure ZeroDerivative(P : TStateVariable);
   var j: Integer;
   Begin
      For j := 1 to 6 do
        P.StepRes[j] := 0;
      If P.NState<>Volume then
        Begin
          P.ClearRate;
          P.SaveRate('State',P.State);
        End;
   end;
   {-------------------------------------------------}
   Procedure TakeDerivative(P : TStateVariable);
   Var db: Double;
   Begin
     If (P.Location.SiteType=TribInput) then Begin ZeroDerivative(P); Exit; End;
     If (P.AllStates.WaterVolZero) and (P.NSTATE<>Volume) then Exit;
     P.Derivative(db);
     P.StepRes[Step] :=db;
   end;
  {-------------------------------------------------}

Var i,SegLoop: Integer;
    EndRepeat: Boolean;
    WorkingTStates: TStates;
    j: double;
Begin
  SegLoop := -1;
  Repeat
    Inc(SegLoop);
    If (SV.LinkedMode and SV.CascadeRunning) then WorkingTStates := SV
      Else  If SV.LinkedMode then WorkingTStates := TAQUATOXSegment(OtherFBSegs.AT(Segloop)).SV
        Else If SegLoop=0 then WorkingTStates := SV
                          else WorkingTStates := SV.HypoSegment;

    With WorkingTStates do
      Begin
       TPresent:=x;

       Application.ProcessMessages;
       IF Step<3 then
           ClearMBData(Step);  {clear before step 1 and each attempt at step 2}
       DerivStep:=Step;
       Zero_Utility_Variables;

       If Step=1 then CalculateSOD; {If Sed Diagenesis Model is attached, calculate SOD First}

       CalculateAllLoads(TPresent);  {Calculate loads and ensure Morphometry is up-to-date}
       If WaterVolZero
         then
           Begin
             DerivStep:=Step;
             ClearMBData(Step);
             For i:=0 to Count -1 do
                 ZeroDerivative(At(i));
             TakeDerivative(GetStatePointer(Volume,StV,WaterCol)); {derive volume only until water vol > 0}
             Application.ProcessMessages;
           End
         else {water volume > 0}
           Begin
             CalculateAllLoads(TPresent);  {Calculate loads and ensure Morphometry is up-to-date}
             CalculateSumPrey;
             NormDiff(Step);
             DerivStep:=Step;
             TVolume(GetStatePointer(Volume,StV,WaterCol)).Derivative(j); {initialize volume variables}
           End; {WV >0}
      End; {With}

    If SV.LinkedMode then EndRepeat := (SegLoop = OtherFBSegs.Count-1) or SV.CascadeRunning
                     else EndRepeat := (SegLoop=1) or (not SV.Stratified);
  Until EndRepeat;

  For i:=0 to AllSVs.Count -1 do
    Begin
      TakeDerivative(AllSVs.AT(i));
      Application.ProcessMessages;
    End;
End;

Function TAQUATOXSegment.GetOffendingRate(ErrVar: TStateVariable): String;

Var i     : Integer;
    MaxVal: Double;
    MaxStr: String;
    Rt    : TRate;

Begin
  MaxVal:=0;
  MaxStr:='';
  For i := 1 to ErrVar.RateColl.Count-1 do
      Begin
        Rt := ErrVar.RateColl.AT(i);
        If (Abs(Rt.GetRate) >= MaxVal) and
           (Pos('_LIM',Rt.Name)<=0) then
          Begin
            MaxVal:=Abs(Rt.GetRate);
            MaxStr:=Rt.Name;
          End;
      End;

  If SV.LinkedMode then MaxStr := ErrVar.AllStates.PSegID^+': '+MaxStr;
  If MaxVal=0 then MaxStr := 'No Error';
  GetOffendingRate:=MaxStr;
End;


{-------------------------------------------------------------------------}
{ Cash-Karp RungeKutta with adaptive stepsize.                            }
{                                                                         }
{ Source, Cash, Karp, "A Variable Order Runge-Kutta Method for Initial    }
{ value problems with rapidly varying right-hand sides" ACM Transactions  }
{   on Mathematical Software 16: 201-222, 1990. doi:10.1145/79505.79507   }
{                                                                         }
{ Uses Nested Loops to determine fourth and fifth-order accurate solutions}
{                                                                         }
{ See also: http://en.wikipedia.org/wiki/Cash-Karp                        }
{           http://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_method       }
{                                                                         }
{-------------------------------------------------------------------------}
Procedure TAQUATOXSegment.TryRKStep(x,h : double);

const
   A : Array[1..6] of Double = (0,0.2,0.3,0.6,1,0.875);
   B5 : Array[1..6] of Double = (37/378,     0, 250/621,125/594,0,512/1771);
   B4 : Array[1..6] of Double = (2825/27648, 0, 18575/48384, 13525/55296, 277/14336, 0.25);
   Tableau : Array[1..5,1..5] of Double = {Butcher Tableau}
                  ((0.2 ,       0,      0,      0,   0),
                   (3/40,    9/40,      0,      0,   0),
                   (3/10,   -9/10,    6/5,      0,   0),
                 (-11/54,     5/2, -70/27,  35/27,   0),
                  (1631/55296, 175/512, 575/13824, 44275/110592, 253/4096));

var P : TStateVariable;
    i : integer;

    Procedure CheckZeroState(p:TStateVariable);
    Begin
      If P.state < Tiny then
        Begin
          P.state := 0.0;
          If ((P.NState in [FirstOrgTox..LastOrgTox]) or
              (P.SVType in [FirstOrgTxTyp..LastOrgTxTyp]))
             then TToxics(P).PPB:=0;
        End;
    End;

    Procedure CheckZeroStateAllSVs;
    Var j : integer;
    Begin
      For j:=0 to AllSVs.count-1 do
            CheckZeroState(AllSVs.AT(j));
    End;

    Procedure RestoreStates_From_Holder;
    Var j: integer;
        TSV: TStateVariable;   
    begin
      For j:=0 to AllSVs.count-1 do
        Begin
          TSV := AllSVs.AT(j);
          TSV.State := TSV.YHold
        End;
    end;

    Procedure SaveStates_to_Holder;
    Var j: integer;
        TSV: TStateVariable;
    begin
      For j:=0 to AllSVs.count-1 do
        Begin
          TSV := AllSVs.AT(j);
          TSV.yHold  := TSV.State
      End;
    end;

Var Steps,SubStep: Integer;
    YFourth: Double;
Begin
  SaveStates_to_Holder;

  With AllSVs do
    Begin
      For Steps := 1 to 6 do
        Begin
          If Steps > 1 then
            Begin  {First step derivative already completed}
              CheckZeroStateAllSVs;
              Derivs(x+A[Steps]*h,Steps);
              RestoreStates_From_Holder;
            End;

          If Steps<6 then
            For i:=0 to count-1 do
              begin
                p:=At(i);
                For SubStep := 1 to Steps do
                  P.state:=P.state + h*Tableau[Steps,SubStep]*P.StepRes[SubStep];
              end;
          end;  {6 steps of integration}

      For i:=0 to count-1 do
        begin
          p:=At(i);
          P.YHold := P.State;
          YFourth := P.State;
          For Steps := 1 to 6 do
           If Steps<>2 {zero weights for both solutions} then
            Begin
              P.YHold := P.YHold + h*(B5[Steps]*P.StepRes[Steps]); {Fifth Order Accurate Soln}
              YFourth := YFourth + h*(B4[Steps]*P.StepRes[Steps]); {Fourth Order Accurate Soln}
            End;
          P.YError := YFourth-P.YHold;   {Error is taken to be the difference between the fourth and fith-order accurate solutions}
        end;

    End;
End;

{-------------------------------------------------------------------------}
{ Cash-Karp RungeKutta with adaptive stepsize.                            }
{                                                                         }
{ Adaptive Stepsize Adjustment Source Dr. Michael Thomas Flanagan         }
{      www.ee.ucl.ac.uk/~mflanaga                                         }
{                                                                         }
{-------------------------------------------------------------------------}
Procedure TAQUATOXSegment.AdaptiveStep(var x: double; hstart,RelError: double; var h_taken,hnext: double);

Const SAFETY = 0.9;

var
   i : integer;
   p : TStateVariable;
   h : double;
   Delta: Double;
   ErrVar: TStateVariable;
   MaxError, MaxStep: Double;
   ErrText   : String;

Begin
   IF SV.PModelTimeStep^=TSDaily
      THEN MaxStep := 1.0
      ELSE MaxStep := 1/24; {Hourly}

   If PSetup^.UseFixStepSize
      then
        Begin
           h:= PSetup^.FixStepSize;   // 2/21/2012 new option
           If (x+h > PSetup^.LastDay)
               then h:=PSetup^.LastDay-x    {if stepsize can overshoot, decrease}
        End
      else h:=hstart;


   REPEAT
      TryRKStep(x,h);  {calculate RKQS 4th and 5th order solutions and estimate error based on their difference}

      MaxError:=0;
      ErrVar := nil;

      If Not PSetup^.UseFixStepSize then
        for i := 0 to AllSVs.Count-1 do
          begin
            p:=AllSVs.AT(i);
            If (ABS(P.YScale) > VSmall)
             then if (abs(P.YError/P.YScale) > MaxError) then
               begin
                 If not ((P.YHold<0) and (P.state<VSmall)) then {no need to track error, state variable constrained to zero}
                   Begin
                     MaxError := abs(P.YError/P.YScale);   {maximum error of all differential equations evaluated}
                     errVar   := P;                        {save error variable for later use in screen display}
                   End;
               end;
          end;

     If Not PSetup^.UseFixStepSize then
      If (MaxError >= RelError) then  {Step has failed, reduce step-size and try again}
       begin
         If PSetup^.ShowIntegration then  {display error results}
           Begin
             ErrText := OutputText(ErrVar.NState,ErrVar.SVType,ErrVar.Layer,'',False,False,0);
             If (ErrVar.AllStates.Vseg=Hypolimnion) then ErrText :=  'Hyp: '+ErrText ;
             SV.ProgData.ErrVar:= ErrText;
             If MaxError>1e5 then SV.ProgData.ErrValue:='LARGE!'
                             else SV.ProgData.ErrValue:=FloatToStr(Round(MaxError*10)/10);
             SV.ProgData.ErrRate:=GetOffendingRate(ErrVar);
           End;

          {Adaptive Stepsize Adjustment Source ("Delta" Code) Dr. Michael Thomas Flanagan
           www.ee.ucl.ac.uk/~mflanaga

           Permission to use, copy and modify this software and its documentation for
           NON-COMMERCIAL purposes is granted, without fee, provided that an acknowledgement
           to the author, Dr Michael Thomas Flanagan at www.ee.ucl.ac.uk/~mflanaga, appears in all copies.
           Dr Michael Thomas Flanagan makes no representations about the suitability or fitness
           of the software for any or for a particular purpose. Dr Michael Thomas Flanagan shall
           not be liable for any damages suffered as a result of using, modifying or distributing
           this software or its derivatives.}

           Delta := SAFETY* POWER(MaxError/RelError,-0.25);
           If (delta < 0.1) then h := h * 0.1
                    	     	else h := h * delta;
       end;

  UNTIL (MaxError<RelError) OR (h<minimum_stepsize) {no warning at this time} OR (PSetup^.UseFixStepSize);

{  If (MaxError>1) and (not StepSizeWarned) then
    Begin
      StepSizeWarned := True;
      MessageStr := 'Warning, the differential equation solver time-step has been forced below the minimum';
      If ShowDebug then MessageStr := MessageStr + ' due to the "' +ProgData.ErrVar + '" state variable';
      MessageStr := MessageStr + '.  Continuing to step forward using minimum step-size.';
      MessageErr := True;
      TSMessage;
    End; }

  If  (PSetup^.SaveBRates) and (not SV.PRateInfo^.WriteDaily) and (not SV.PRateInfo^.WriteToMemory) then
       WriteRatesToDB(X,True,h_taken);

   If PSetup^.UseFixStepSize
     then hnext := h
     else
       If (MaxError < RelError) then
         Begin
          {Adaptive Stepsize Adjustment Source ("Delta" code) Dr. Michael Thomas Flanagan www.ee.ucl.ac.uk/~mflanaga, see terms above}
           If MaxError = 0 then delta := 4.0
                           else delta := SAFETY*POWER(MaxError/RelError ,-0.2);
           If (delta>4.0) then Delta := 4.0;
           If (Delta<1.0) then Delta := 1.0;
           hnext := h*delta;
         End;

  h_taken:=h;
  IF hnext>MaxStep then hnext:=MaxStep;
  IF h>MaxStep then h:=MaxStep;
  x:=x+h;

  for i := 0 to AllSVs.Count-1 do   {reasonable error, so copy results of differentiation saved in YHolders}
    begin
      p:=AllSVs.AT(i);
      P.state:=P.YHold;
    end;

  Perform_Dilute_or_Concentrate(x);
End;

{------------------------------------------------------------------------}
{ Cash-Karp RungeKutta with adaptive stepsize.                           }
{                                                                        }
{ The Integrate function steps from the beginning to the end of the      }
{ time period and handles bookkeeping at the start and between steps     }
{------------------------------------------------------------------------}

Procedure TAQUATOXSegment.Integrate(TStart,          { Starting Point of Integral }
                                    TEnd,            { Ending Point of Integral   }
                                    RelError,        { Requested Accuracy of Results  }
                                    h_minimum,       { Smallest Step Size         }
                                    dxsav: double);  { Store Result Interval      }

var i, SegLoop: Integer;
    rk_has_executed: Boolean;
    rk_hypo_has_executed: Boolean;
    xsav, x, hnext   : Double;
    simulation_done  : Boolean;
    EndRepeat        : Boolean;
    FinishPoint      : Boolean;
    WorkingStudy     : TAQUATOXSegment;
    MaxStep          : Double;
    h_taken, h       : Double ;

    Procedure SetYScale(p:TStateVariable);
    Begin
      if P.State=0 then P.YScale:=0
                   else P.YScale:= abs(P.state) + abs(P.StepRes[1]*h) +tiny;
                        {Scale of state variable used to assess relative error, 12/24/96}
    End;

    Procedure CheckZeroState(p:TStateVariable);
    Begin
      If P.state < 0 {tiny}
        then begin
               P.state := 0.0;
               if (P.NState in [FirstOrgTox..LastOrgTox]) or
                  (P.SVType in [FirstOrgTxTyp..LastOrgTxTyp])
                  then TToxics(P).PPB:=0;
             end;
    End;

    Procedure CheckZeroStateAllSVs;
    var j : integer;
    Begin
      For j:=0 to AllSVs.count-1 do
            CheckZeroState(AllSVs.AT(j));
    End;

 {   numsteps         : integer;
    sumsteps, avgstep: double; }

begin
(*  numsteps := 0;  {debug code}
    sumsteps := 0;  {debug code} *)

  rk_has_executed := False;
  rk_hypo_has_executed := False;
  Simulation_Done := False;

  if dxsav<0.01 then dxsav:=1; {ensure dxsave <> 0, which causes crash}

 (**  Initialize variables........*)
  x := TStart;
  xsav:= x - dxsav * 2.0;

  IF SV.PModelTimeStep^=TSDaily
     THEN MaxStep := 1.0
     ELSE MaxStep := 1/24; {Hourly}
  h := MaxStep;

  SegLoop := -1;
  Repeat
    Inc(SegLoop);
    If SV.LinkedMode and (not SV.CascadeRunning)
       then WorkingStudy := OtherFBSegs.AT(Segloop)
       else WorkingStudy := Self;

    With WorkingStudy.SV do
      Begin
        ModelStartTime:=TStart;
        TPreviousStep:=TStart;
        TPresent:=TStart;

        ChangeData;
        NormDiff(h);
        ClearMBData(0);
        CalcHRadius(False);
        If EstuarySegment then SV.Check_Stratification;

        Derivs(x,1);  {write rates output}
        {Write Initial Conditions as the first data Point}
        WriteResults(TStart,dxsav,false,0);
        CalcPPB;
        If LinkedMode then WriteCascadeWashout(X, 0);
(*      If LinkedMode then Add_Cascade_Washin(x); *)
      End; {With}

    If SV.LinkedMode and (not SV.CascadeRunning)
       then EndRepeat := SegLoop = OtherFBSegs.Count-1
       else EndRepeat := True;
  Until EndRepeat;

 (**  Start stepping the RungeKutta.....**)

  while not Simulation_Done {nstp<=maxstp} do
     begin
       If Not SV.LinkedMode then SV.Check_Stratification;
       CheckZeroStateAllSVs;

       Derivs(x,1);

       For i:=0 to AllSVs.Count-1 do
           SetYScale(AllSVs.AT(i));

       FinishPoint := (Int(X * (1/dxsav)) > Int (XSav * (1/dxsav)));

       SegLoop := -1;
       Repeat
         Inc(SegLoop);
         If SV.LinkedMode and (not SV.CascadeRunning)
            then WorkingStudy := OtherFBSegs.AT(Segloop)
            else WorkingStudy := Self;

         With WorkingStudy.SV do
           Begin
             CalcPPB;
             If (Not LinkedMode) and Stratified then HypoSegment.CalcPPB;

             {Write output to Results Collection}
             WriteResults(X,dxsav,False,h_taken);
             If (Not LinkedMode) and Stratified then HypoSegment.WriteResults(X,dxsav,False,h_taken);

           End; {with WorkingStudy}

         If SV.LinkedMode and (not SV.CascadeRunning)
           then EndRepeat := SegLoop = OtherFBSegs.Count-1
           else EndRepeat := True;
       Until EndRepeat;

       If FinishPoint then {if it is time to write rates}
         Begin
           XSav := X;
           If (SV.SetupRec^.SaveBRates) and (not SV.PRateInfo^.WriteToMemory) and
              (SV.PRateInfo^.WriteDaily) and (rk_has_executed) then
                   WriteRatesToDB(X,rk_hypo_has_executed,dxsav);
         End;

       If (((x+h-TEnd)*(x+h-TStart)) > 0.0)
           then h:=TEnd-x    {if stepsize can overshoot, decrease}
           else If SV.LinkedMode and ((x+h)>int(x+1))
              then h := (int(x+h)-x);
             {force steps to stop on even one-day increments.}
             {This is required for cascade segments to preserve mass balance (given output avg.)}

       AdaptiveStep(x, h, RelError, h_taken, hnext);
       rk_has_executed := True;
       If SV.Stratified then rk_hypo_has_executed := True;

       SegLoop := -1;
       Repeat {Update PPB numbers and execute DoThisEveryStep for all segments}
         Inc(SegLoop);
         If SV.LinkedMode and (not SV.CascadeRunning)
            then WorkingStudy := OtherFBSegs.AT(Segloop)
            else WorkingStudy := Self;

         With WorkingStudy.SV do
           Begin
             If LinkedMode then WriteCascadeWashout(X, h_taken);
(*             If LinkedMode then Add_Cascade_Washin(X);  *)
             ProcessMBData(h_taken);

             TPresent:=x;
             DoThisEveryStep(h_taken);
             CalcPPB;
             If (Not LinkedMode) and Stratified then
               Begin
                 HypoSegment.ProcessMBData(h_taken);
                 HypoSegment.DoThisEveryStep(h_taken);
                 HypoSegment.CalcPPB;
               End;
             TPreviousStep := TPresent;

             If LinkedMode and (not CascadeRunning) then EndRepeat := SegLoop = OtherFBSegs.Count-1
                                                    else EndRepeat := True;
           End;
       Until EndRepeat;


       if (((x-TEnd)*(TEnd-TStart)) >= 0.0)
         then Simulation_Done := True {are we done?}
         else
           if (abs(hnext) < h_minimum)
             then begin
                    SV.ProgData.StepSizeVis:=True;
                    h:=h_minimum; { attempt to control min. timestep}
                  end
             else begin
                    h:=hnext;
                    SV.ProgData.StepSizeVis:=False;
                  end;

       {Update Progress Gauge}
       With SV do
         Begin
           ProgData.ProgInt := Round(100*((X-TStart)/(TEnd-TStart)));
           ProgData.DateStr := '('+DateToStr(X)+')';
           If PSetup^.ShowIntegration then
              Begin
                ProgData.Gauge2Int :=Round(100*(h/MaxStep));
                ProgData.PercStepCaption:=FloatToStr(Round(1000*(h/MaxStep))/10)+' %';

              End;
           UpdateProg;
         End;

       Application.ProcessMessages;

       {Handle Cancel Button Press}
       If SV.ProgData.ProgCancel then with SV do
         Begin
           If (not LinkedMode) then WriteResults(X,dxsav,True,h_taken);     {Write Final Step to Results File}
           If (not LinkedMode) and Stratified then HypoSegment.WriteResults(X,dxsav,True,h_taken);
           exit;
         End;

{       nstp:=nstp+1; }
     end; {while not simulation done}

  CheckZeroStateAllSVs;

  SegLoop := -1;
  Repeat
    Inc(SegLoop);
    If SV.LinkedMode and (not SV.CascadeRunning)
        then WorkingStudy := OtherFBSegs.AT(Segloop)
        else WorkingStudy := Self;

    With WorkingStudy.SV do
      Begin
        DoThisEveryStep(h_taken);
        If (not LinkedMode) and Stratified then HypoSegment.DoThisEveryStep(h_taken);

        CalcPPB;
        If (not LinkedMode) and Stratified then HypoSegment.CalcPPB;

        WriteResults(X,dxsav,True,h_taken);        {Write Final Step to Results File}
        If (not LinkedMode) and Stratified then HypoSegment.WriteResults(X,dxsav,True,h_taken);
        If (not LinkedMode) and Stratified then Overturn(True);
      End;

    If SV.LinkedMode and (not SV.CascadeRunning)
        then EndRepeat := SegLoop = OtherFBSegs.Count-1
        else EndRepeat := True;

  Until EndRepeat;

End; {of Procedure Integrate}

{_____________________________________________________________________________}
