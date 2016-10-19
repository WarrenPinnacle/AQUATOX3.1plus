//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Loadings;

interface

Uses Classes, Global, TCollect, SV_IO, Dialogs, SysUtils,
     Progress, Forms;

Type
  Swap = (Save,Restore);
  EatOrEgest = (Eat,Egest);
  TextBuf = array[0..255] of char;

  TMemLocRec = Record
                   Ptr :  Array [FirstState..LastState,StV..PIntrnl,WaterCol..SedLayer10] of pointer;
                   Indx:  Array [FirstState..LastState,StV..PIntrnl,WaterCol..SedLayer10] of integer;
               End;
   {These arrays are utilized to speed up the finding of the state variable
   object in memory}

   TLoad=class(BaseClass)
      Date    : TDateTime;
      Loading : Double;
      constructor init(aD : TDateTime; aL : double);
      Procedure Store(IsTemp: Boolean; Var st: TStream); override;
      Constructor Load(IsTemp: Boolean; st: Tstream; ReadVersionNum: Double);
      Function ObjectID: SmallInt; Override;
      Procedure WriteText(Var LF: TextFile); Override;
   end;

   PPloadings= ^TLoadings;
   TLoadings=class(TSortedCollection)
      Hourly : Boolean;
      Procedure Store(IsTemp: Boolean; Var st: TStream); override;
      Constructor Load(IsTemp: Boolean; st: Tstream; ReadVersionNum: Double);
      Function GetDateIndex(TimeIndex : Double) : integer;
      Function GetLoad(TimeIndex : double; Interp: Boolean) : double;
      Function SubtractOneYear(InDate: Double):Double;
      Function AddOneYear(InDate: Double):Double;
      function KeyOf(Item: Pointer): Pointer; Override;
      Function Compare(key1,key2: pointer):integer; Override;            
      Function ObjectID: SmallInt; Override;
   end;

  PLoadingsRecord = ^LoadingsRecord; 
  LoadingsRecord = Packed Record
      Loadings    : TLoadings;  {Time series loading}
      ConstLoad   : Double;     {User Input constant load}
      UseConstant : Boolean;    {Flag for using constant load}
      NoUserLoad  : Boolean;    {Flag for using user input load, or ignoring
                                the load and using annual ranges and means.
                                Relevant to Temp, Light, pH, and Nutrients}
           f1,f2  : Byte; {d4-2006}

      MultLdg     : Double;     {to perturb loading}

     {Alt_Loadings is reserved for point source, non pont source and
              direct precipitation loadings; these vars are relevant only for
              nstate in [H2OTox,MeHg,HgII,Hg0,Phosphate,Ammonia,Nitrate,All SuspDetr]
              Has_Alt_Loadings(nstate) is a boolean function in GLOBAL.PAS...}
      Alt_Loadings    : Array [PointSource..NonPointSource] of TLoadings;  {Time series loading}
      Alt_ConstLoad   : Array [PointSource..NonPointSource] of Double;     {User Input constant load}
      Alt_UseConstant : Array [PointSource..NonPointSource] of Boolean;    {Flag for using constant load}
            f3: Byte; {D4-2006}
      Alt_MultLdg     : Array [PointSource..NonPointSource] of Double;     {to perturb loading}
   end;

Function ReturnAltLoad(TimeIndex: Double; Ld: LoadingsRecord; AltLdg: Alt_LoadingsType) : Double;
Function ReturnLoad(TimeIndex: Double; Ld: LoadingsRecord) : Double;
Procedure LoadingsRectoText(Var LF: TextFile; Ld: LoadingsRecord; HasAlt: Boolean);

Implementation

{$I Loading.inc}

Function TLoad.ObjectID:SmallInt; Begin  ObjectID:=1003;  End;
Function TLoadings.ObjectID:SmallInt; Begin  ObjectID:=1004;  End;


end.
