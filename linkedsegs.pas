//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit LinkedSegs;

interface

Uses AQStudy, Classes, TCollect, Global,  AQUAOBJ, Progress, Graphics, ExtCtrls;

type
   TLinkedSegs = Class(BaseClass)
      Filename    : FileNString;           {User supplied name for all data}
      Dirname     : DirString;             {Location of the Study File}
      LastRun,
      ControlRun  : TDateTime;             {Date of Last Run}
      LastChange  : TDateTime;             {Last time one of the study's parameter's changed}
      TimeLoaded  : TDateTime;             {When the study was loaded}
      SystemName  : String[20];
      TemplateSeg : TAQUATOXSegment;       {Holds all the global underlying data}
      SegmentColl : TCollection;           {Collection of AQUATOXSegment}
      Chemical    : ChemArray;
      Links       : TCollection;           {Describes the Links between Segments}
      Notes       : String[255];           {User Entered Notations}
      Setup       : Setup_Record;
      LUnc_Dir,LUnc_File,LUnc_Ext: ShortString;
      StudyProgress : TProgressDialog;
      ImagePtr      : Pointer;
      SimsRunning   : Integer;             {how many Linked simulations are currently running?}

      Upper_Cascade_Coll,          {Cascade Segments run before the feedback segments}
      Lower_Cascade_Coll,          {Cascade Segments run after the feedback segments}
      Feedback_Coll: TCollection;  {The feedback segments : nosave these three collections}
      constructor Init(ASystemName : ShortString);
      destructor Destroy;  override;
      Procedure StoreLS(IsTemp: Boolean; var st: Tstream; StoreRes,StoreDist: Boolean);
      Constructor Load(IsTemp: Boolean; Var st: Tstream; ReadVersionNum: Double; LoadResults,LoadDistribs: Boolean);
      procedure SaveToFile(Img: TImage);
      Procedure ClearAllResults(ClearMode: Integer);
      Procedure Update_Distributions;
      Function  Verify_Runnable(ShowMsg: Boolean): Boolean;
      Procedure Add_Internal_Nutrients;
      Procedure Remove_Internal_Nutrients;
      Function  SegIndexByID(ID: SegIDString): Integer;
      Function  SegmentByID(ID: SegIDString) : TAQUATOXSegment;
      Procedure LatinHyperCubeRun;
      Procedure SensitivityRun;
      Procedure Run(Unc_Sens_InProg: Boolean);
      Procedure WriteText(Var LF: TextFile); OverRide;
   End;  {TLinkedSegs}

implementation

Uses Windows, Dialogs, Forms, ExportResults, ExcelFuncs, Excel2000,ActiveX, Variants,
     SysUtils, Controls, Uncert, DB, DBTables, CalcDist, RandNum, SV_IO, Loadings, BufferTStream;

{$I LinkedSegs.inc}

end.
