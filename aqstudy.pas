unit AQSTUDY;

interface
uses  Classes, Global, TCollect, SV_IO, Dialogs, SysUtils, ComObj, Diagenesis,
      Progress, Forms, AQUAOBJ, AQSite, Loadings,  COMMDLG, variants, ActiveX,
      Uncert, RandNum, CalcDist, DB, DBTables, Graphics, Wiz_DBEntry, Diagenesis_Calcs,
      Windows, Messages, Controls, DbEntry, GetFishAge;

type
   TAQUATOXSegment = Class
     Filename     : FileNString;           {User supplied name for all data}
     Dirname      : DirString;             {Location of the Study File}
     LastChange  : TDateTime;              {Last time one of the study's parameters changed}
     TimeLoaded  : TDateTime;              {When the study was loaded}
     LastRun,
     ControlRun   : TDateTime;             {Date of Last Run}

     StudyName    : String[50];
     NewNotes     : TStringList;           {User Entered Notations}
     SV           : TStates;               {State Variables}
     PSetup       : PSetup_Record;         {Points to the Valid Setup_Rec either here or in template}
     PDiagenesis  : PDiagenesis_Rec;
     PUncertainty : PUncertainty_Setup_Record;
     Location     : TAQTSite;             {Site used for study}
     PChems       : PChemArray;            {Chemicals modeled}

     CONTROL_IS_RUNNING : Boolean;        {Is the non-perturbed run in progress?}
     RunIterations      : Boolean;        {Whether Uncertainty Iterations should be run}

     SimsRunning        : Integer;        {how many simulations are currently running?}

     Unc_Dir,Unc_File,Unc_Ext: ShortString;{ Data for output of uncertainty file, should not be saved / loaded }
     Sens_File               : String;     { Data for output of sensitivity file }

     SegNumber    : SegIDString;           {Identifying Number for use by multi-seg version}

     TemplateSeg  : TAQUATOXSegment;       {Segment in which underlying data is stored.  = self in single study run, no storload}
     AllOtherSegs : TCollection;           {Collection of other studies in the linked system  = nil in single study mode, no storload}
     OtherFBSegs  : TCollection;           {Collection of all the feedback segments in the linked system. no storload}
     AllSVs       : TCollection;           {Collection of all state variables in epilimnion or hypolimnion or all segments, no storload}


     constructor Init(AStudyName : ShortString; TemplStdy: TAQUATOXSegment);
     destructor Destroy;  override;
     Procedure Load_Blank_Study(Site: Sitetypes);
     Procedure DisplayNames(List:TStrings);

     procedure AddStateVariable(NS : StateVariables; Lyr: T_SVLayer; IC : double; IsTempl: Boolean);
     Function  RemoveStateVariable(NS : StateVariables; Typ: T_SVType; Lyr: T_SVLayer): Boolean;
     Procedure AddOrgToxStateVariable(NS: StateVariables; Lyr: T_SVLayer; ToxType :T_SVType; IsTempl: Boolean);
     Procedure AddInternalNutSVs(NS : StateVariables; IsTempl: Boolean);
     Procedure RemoveInternalNutSVs(NS : StateVariables);

     Procedure AddMultiAgeFish(WizardCall: Boolean);
     Procedure StateDataFromDBase(State: StateVariables; Typ: T_SVType; Dir, DBFileName, Entry: ShortString);

     Procedure Add_OrgTox_SVs(State: StateVariables;ChemNm: String);
     Procedure Remove_OrgTox_SVs(State: StateVariables);

     Procedure Add_Internal_Nutrients;
     Procedure Remove_Internal_Nutrients;
     Procedure Adjust_Internal_Nutrients;  // If internal nutrients are modeled, checks to see if plant-types have changed thus requiring a change in state variables (rooted macrophytes)

     Procedure Remove_Sediment_Model;
     Procedure Add_Sediment_Model;
     Procedure Remove_Sediment_Layer;
     Procedure Add_Sediment_Layer;
     Procedure Add_Diagenesis_Model;
     Procedure Remove_Diagenesis_Model;

     Procedure SetupControlRun(Var P: Pointer);
     Procedure RestoreStudyAfterControlRun(Var P:Pointer);

     procedure GetAllInsertableStates(P : TStrings);
     Function  Verify_Runnable(IsControl, SendMessage:Boolean): Boolean;
     Procedure ShowTemplate(Template: TAQUATOXSegment; Var ErrorMessage: String; Disp,CopyInit: Boolean);
     Procedure TakeParameters(InputStudy: TAQUATOXSegment; Var ErrorMessage: String; CopyInit: Boolean);     

     Procedure Store(IsTemp: Boolean; var st: Tstream);  virtual;
     Constructor Load(LinkedM,IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double; LoadResults, LoadDistribs:Boolean);
     Function SetupForRun: Boolean;
     procedure Run;
     Procedure LatinHypercubeRun;
     Procedure SensitivityRun;
     Procedure WriteRatesToDB(TimeIndex: TDateTime; RKQSHypo: Boolean; hdid: Double);    { Outputs rates to a database }
     Procedure ConvertRatesToXLS;
 
     Procedure Perform_Dilute_or_Concentrate(TimeIndex: Double);  {Modify db to Account for a changing volume}

     {Below functions in NUMERICAL.INC}
     Procedure TryRKStep(x,h : double);
     Procedure AdaptiveStep(var x: double; hstart,RelError: double; var h_taken,hnext: double);
     Procedure Integrate(TStart, TEnd, RelError, h_minimum, dxsav: double);
     Procedure Derivs(X : double; Step : word);
     Function GetOffendingRate(ErrVar: TStateVariable): String;   { Which rate appears to be causing the most error? }
     Procedure WriteText(Var LF: TextFile); virtual;
   end;

implementation

Uses ExcelFuncs, Excel2000, Math, ExportResults;

{$I AQSTUDY.inc}
{$I Numerical.inc}

end.
