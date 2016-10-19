//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit MercTemp;

interface
uses Global, Aquaobj;
  Type
    Mercury_Temp_Holder =  Record
    HgIIPointer: PStateVariable;
    HgII_Index : Integer;
    InitCond, HgII_InitCond,ConstLoad,HgIIConstLoad: Double;
    UseConst,HgIIUseconst: Boolean;
    MultLdg, HgIIMultLdg : Double;   {RAP, 11/7/95}
  End;

implementation

end.
