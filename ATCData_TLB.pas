unit ATCData_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 8291 $
// File generated on 2/5/2010 2:54:37 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINDOWS.0\system32\ATCData.dll (1)
// LIBID: {653D928A-80CE-11D3-913A-00A024C11E04}
// LCID: 0
// Helpfile: 
// HelpString: Aqua Terra  Defined Data Types
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS.0\system32\stdole2.tlb)
//   (2) v6.0 VBA, (C:\WINDOWS.0\system32\msvbvm60.dll)
//   (3) v1.10 ATCoCtl, (C:\WINDOWS.0\system32\ATCoCtl.ocx)
// Errors:
//   Hint: Member 'File' of '_ATCclsTserData' changed to 'File_'
//   Hint: Member 'File' of '_ATCclsTserDate' changed to 'File_'
//   Hint: Member 'Label' of '_ATCclsTserFile' changed to 'Label_'
//   Hint: Member 'Label' of 'ATCdetailEXEtype' changed to 'Label_'
//   Hint: Member 'Label' of 'ATCexternalEXEtype' changed to 'Label_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Symbol 'ClassName' renamed to '_className'
//   Hint: Member 'Label' of 'ATCPlugIn' changed to 'Label_'
//   Error creating palette bitmap of (TATCDataTypes) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TATCPlugInTypes) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TATCPlugInManager) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TATCclsCatalog) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TATCclsTserData) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TATCclsTserDate) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TATCclsTserFile) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TATCclsCriterion) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TATTimSerDataHeader) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TATCclsParm) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TATCclsParmDef) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TATCclsAttributeDefinition) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TCollString) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TCollTserData) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
//   Error creating palette bitmap of (TATCclsAnalysis) : Server C:\WINDOWS.0\system32\ATCData.dll contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, ATCoCtl_TLB, Classes, Graphics, OleServer, StdVCL, Variants, 
VBA_TLB;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ATCDataMajorVersion = 2;
  ATCDataMinorVersion = 11;

  LIBID_ATCData: TGUID = '{653D928A-80CE-11D3-913A-00A024C11E04}';

  IID__ATCDataTypes: TGUID = '{43D49467-80D7-11D3-913A-00A024C11E04}';
  CLASS_ATCDataTypes: TGUID = '{43D49468-80D7-11D3-913A-00A024C11E04}';
  IID__ATCPlugInTypes: TGUID = '{335A151B-3323-11D4-9D23-00A0C9768F70}';
  CLASS_ATCPlugInTypes: TGUID = '{335A151C-3323-11D4-9D23-00A0C9768F70}';
  IID__ATCPlugInManager: TGUID = '{335A151E-3323-11D4-9D23-00A0C9768F70}';
  CLASS_ATCPlugInManager: TGUID = '{335A151F-3323-11D4-9D23-00A0C9768F70}';
  IID__ATCclsCatalog: TGUID = '{335A1520-3323-11D4-9D23-00A0C9768F70}';
  CLASS_ATCclsCatalog: TGUID = '{335A1521-3323-11D4-9D23-00A0C9768F70}';
  IID__ATCclsTserData: TGUID = '{014F3C6B-314F-4EFC-93FE-320FF0D61056}';
  CLASS_ATCclsTserData: TGUID = '{335A1529-3323-11D4-9D23-00A0C9768F70}';
  IID__ATCclsTserDate: TGUID = '{F7BBB3D6-22E9-45F0-BD24-7CC1B7B94FA5}';
  CLASS_ATCclsTserDate: TGUID = '{335A1527-3323-11D4-9D23-00A0C9768F70}';
  IID__ATCclsTserFile: TGUID = '{5E6F5092-091B-11D5-983A-00A024C11E04}';
  CLASS_ATCclsTserFile: TGUID = '{335A1525-3323-11D4-9D23-00A0C9768F70}';
  IID__ATCclsCriterion: TGUID = '{335A152B-3323-11D4-9D23-00A0C9768F70}';
  CLASS_ATCclsCriterion: TGUID = '{335A152C-3323-11D4-9D23-00A0C9768F70}';
  IID__ATTimSerDataHeader: TGUID = '{62CCA97A-7201-11D4-9D23-00A0C9768F70}';
  CLASS_ATTimSerDataHeader: TGUID = '{335A1523-3323-11D4-9D23-00A0C9768F70}';
  IID__ATCclsParm: TGUID = '{335A1532-3323-11D4-9D23-00A0C9768F70}';
  CLASS_ATCclsParm: TGUID = '{335A1533-3323-11D4-9D23-00A0C9768F70}';
  IID__ATCclsParmDef: TGUID = '{335A1530-3323-11D4-9D23-00A0C9768F70}';
  CLASS_ATCclsParmDef: TGUID = '{335A1531-3323-11D4-9D23-00A0C9768F70}';
  IID__ATCclsAttributeDefinition: TGUID = '{A7CE20A6-8C27-41BF-860D-B3702A0CABD2}';
  CLASS_ATCclsAttributeDefinition: TGUID = '{335A1514-3323-11D4-9D23-00A0C9768F70}';
  IID__CollString: TGUID = '{4AED0D14-8E55-11D4-9D23-00A0C9768F70}';
  CLASS_CollString: TGUID = '{4AED0D15-8E55-11D4-9D23-00A0C9768F70}';
  IID__CollTserData: TGUID = '{4AED0D16-8E55-11D4-9D23-00A0C9768F70}';
  CLASS_CollTserData: TGUID = '{4AED0D17-8E55-11D4-9D23-00A0C9768F70}';
  IID__ATCclsAnalysis: TGUID = '{64C7B902-315B-4D24-B4C2-AE9FDAF77EA9}';
  CLASS_ATCclsAnalysis: TGUID = '{4F06F0D8-9C9F-4053-9807-FFACCE22014E}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum ATCTimeUnit
type
  ATCTimeUnit = TOleEnum;
const
  TUSecond = $00000001;
  TUMinute = $00000002;
  TUHour = $00000003;
  TUDay = $00000004;
  TUMonth = $00000005;
  TUYear = $00000006;
  TUCentury = $00000007;

// Constants for enum ATCTran
type
  ATCTran = TOleEnum;
const
  TranAverSame = $00000000;
  TranSumDiv = $00000001;
  TranMax = $00000002;
  TranMin = $00000003;
  TranNative = $00000004;

// Constants for enum ATCCompare
type
  ATCCompare = TOleEnum;
const
  atEQ = $00000000;
  atLT = $00000001;
  atGT = $00000002;
  atLE = $00000003;
  atGE = $00000004;
  atNE = $00000005;

// Constants for enum ATCTsIdExistAction
type
  ATCTsIdExistAction = TOleEnum;
const
  TsIdNoAction = $00000000;
  TsIdRepl = $00000001;
  TsIdAppend = $00000002;
  TsIdRenum = $00000004;
  TsIdReplAsk = $00000008;
  TsIdAppendAsk = $00000010;
  TsIdRenumAsk = $00000020;

// Constants for enum ATCOperatorType
type
  ATCOperatorType = TOleEnum;
const
  ATCAdd = $00000000;
  ATCSubtract = $00000001;
  ATCMultiply = $00000002;
  ATCDivide = $00000003;
  ATCCummDiff = $00000004;
  ATCAve = $00000005;
  ATCWeight = $00000006;
  ATCTSPowC = $00000007;
  ATCCPowTS = $00000008;
  ATCTSPowTS = $00000009;
  ATCExp = $0000000A;
  ATCLog = $0000000B;
  ATCLn = $0000000C;
  ATCAbs = $0000000D;
  ATCTSltC = $0000000E;
  ATCTSgtC = $0000000F;
  ATCMin = $00000010;
  ATCMax = $00000011;
  NONE = $FFFFFC19;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _ATCDataTypes = interface;
  _ATCDataTypesDisp = dispinterface;
  _ATCPlugInTypes = interface;
  _ATCPlugInTypesDisp = dispinterface;
  _ATCPlugInManager = interface;
  _ATCPlugInManagerDisp = dispinterface;
  _ATCclsCatalog = interface;
  _ATCclsCatalogDisp = dispinterface;
  _ATCclsTserData = interface;
  _ATCclsTserDataDisp = dispinterface;
  _ATCclsTserDate = interface;
  _ATCclsTserDateDisp = dispinterface;
  _ATCclsTserFile = interface;
  _ATCclsTserFileDisp = dispinterface;
  _ATCclsCriterion = interface;
  _ATCclsCriterionDisp = dispinterface;
  _ATTimSerDataHeader = interface;
  _ATTimSerDataHeaderDisp = dispinterface;
  _ATCclsParm = interface;
  _ATCclsParmDisp = dispinterface;
  _ATCclsParmDef = interface;
  _ATCclsParmDefDisp = dispinterface;
  _ATCclsAttributeDefinition = interface;
  _ATCclsAttributeDefinitionDisp = dispinterface;
  _CollString = interface;
  _CollStringDisp = dispinterface;
  _CollTserData = interface;
  _CollTserDataDisp = dispinterface;
  _ATCclsAnalysis = interface;
  _ATCclsAnalysisDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ATCDataTypes = _ATCDataTypes;
  ATCPlugInTypes = _ATCPlugInTypes;
  ATCPlugInManager = _ATCPlugInManager;
  ATCclsCatalog = _ATCclsCatalog;
  ATCclsTserData = _ATCclsTserData;
  ATCclsTserDate = _ATCclsTserDate;
  ATCclsTserFile = _ATCclsTserFile;
  ATCclsCriterion = _ATCclsCriterion;
  ATTimSerDataHeader = _ATTimSerDataHeader;
  ATCclsParm = _ATCclsParm;
  ATCclsParmDef = _ATCclsParmDef;
  ATCclsAttributeDefinition = _ATCclsAttributeDefinition;
  CollString = _CollString;
  CollTserData = _CollTserData;
  ATCclsAnalysis = _ATCclsAnalysis;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//

  ATCclsTserData___v0 = _ATCclsTserData; 
  ATCclsTserData___v1 = _ATCclsTserData; 
  ATCclsTserData___v2 = _ATCclsTserData; 
  ATCclsTserData___v3 = _ATCclsTserData; 
  ATCclsTserData___v4 = _ATCclsTserData; 
  ATCclsTserData___v5 = _ATCclsTserData; 
  ATCclsTserDate___v0 = _ATCclsTserDate; 
  ATCclsTserFile___v0 = _ATCclsTserFile; 
  ATCclsTserFile___v1 = _ATCclsTserFile; 
  ATTimSerDataHeader___v0 = _ATTimSerDataHeader; 
  ATCclsAttributeDefinition___v0 = _ATCclsAttributeDefinition; 
  ATCclsAttributeDefinition___v1 = _ATCclsAttributeDefinition; 

  ATTimSerDateSummary = packed record
    NVALS: Integer;
    CIntvl: Longbool {JSC};
    Intvl: Double;
    ts: Integer;
    Tu: ATCTimeUnit;
    SJDay: Double;
    EJDay: Double;
  end;

  ATTimSerAttribute = packed record
    Name: WideString;
    Value: WideString;
    Definition: _ATCclsAttributeDefinition;
  end;

  ATCdetailEXEtype = packed record
    Label_: WideString;
    Value: WideString;
    filter: WideString;
    isFile: Longbool {JSC};
    isOutput: Longbool {JSC};
    isOnCommandline: Longbool {JSC};
  end;

  ATCexternalEXEtype = packed record
    Label_: WideString;
    path: WideString;
    Details: _Collection;
  end;

  ATTimSerAttributes = packed record
    Name: WideString;
    Value: WideString;
  end;

  ATTimSerJDateVals = packed record
    JDate: Double;
    IntvlFg: Smallint;
  end;

  ATTimSerJDate = packed record
    NVALS: Integer;
    CIntvl: Longbool {JSC};
    Intvl: Double;
    j: PSafeArray;
  end;

  ATTimSerDataValues = packed record
    Vals: Single;
    ValFg: Smallint;
  end;

  ATTimSerDataSummary = packed record
    spos: Integer;
    NVal: Integer;
    CIntvl: Longbool {JSC};
    JDIndex: Smallint;
    ts: Integer;
    Tu: Integer;
    Dtran: Integer;
    SJDay: Double;
    EJDay: Double;
    Min: Single;
    Max: Single;
  end;

  ATTimSerDetail = packed record
    type_: WideString;
    FilIndex: Integer;
    FileName: WideString;
    Stanam: WideString;
    id: Double;
    Sen: WideString;
    Loc: WideString;
    Con: WideString;
    s: ATTimSerDataSummary;
    V: PSafeArray;
    Attrib: PSafeArray;
  end;

  ATTimSer = packed record
    t: PSafeArray;
    jd: PSafeArray;
  end;

  ATCPlugIn = packed record
    PluginName: WideString;
    _className: WideString;
    Version: WideString;
    Label_: WideString;
    PluginType: WideString;
    id: Integer;
    obj: IDispatch;
  end;


// *********************************************************************//
// Interface: _ATCDataTypes
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {43D49467-80D7-11D3-913A-00A024C11E04}
// *********************************************************************//
  _ATCDataTypes = interface(IDispatch)
    ['{43D49467-80D7-11D3-913A-00A024C11E04}']
  end;

// *********************************************************************//
// DispIntf:  _ATCDataTypesDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {43D49467-80D7-11D3-913A-00A024C11E04}
// *********************************************************************//
  _ATCDataTypesDisp = dispinterface
    ['{43D49467-80D7-11D3-913A-00A024C11E04}']
  end;

// *********************************************************************//
// Interface: _ATCPlugInTypes
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {335A151B-3323-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATCPlugInTypes = interface(IDispatch)
    ['{335A151B-3323-11D4-9D23-00A0C9768F70}']
  end;

// *********************************************************************//
// DispIntf:  _ATCPlugInTypesDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {335A151B-3323-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATCPlugInTypesDisp = dispinterface
    ['{335A151B-3323-11D4-9D23-00A0C9768F70}']
  end;

// *********************************************************************//
// Interface: _ATCPlugInManager
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {335A151E-3323-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATCPlugInManager = interface(IDispatch)
    ['{335A151E-3323-11D4-9D23-00A0C9768F70}']
    function Get_ErrorDescription: WideString; safecall;
    procedure Clear; safecall;
    function Get_Avail: _Collection; safecall;
    function Get_Active: _Collection; safecall;
    function Get_CurrentActive: ATCPlugIn; safecall;
    procedure Set_CurrentActiveIndex(Param1: Integer); safecall;
    function Get_CurrentActiveIndex: Integer; safecall;
    function AvailIndexByName(var PluginName: WideString): Integer; safecall;
    function ActiveIndexByName(var PluginName: WideString): Integer; safecall;
    procedure Create(var AvailIndex: Integer); safecall;
    procedure Delete(var ActiveIndex: Integer); safecall;
    function QueryType(var PluginName: WideString): WideString; safecall;
    function Load(var PluginName: WideString): WordBool; safecall;
    property ErrorDescription: WideString read Get_ErrorDescription;
    property Avail: _Collection read Get_Avail;
    property Active: _Collection read Get_Active;
    property CurrentActive: ATCPlugIn read Get_CurrentActive;
    property CurrentActiveIndex: Integer read Get_CurrentActiveIndex write Set_CurrentActiveIndex;
  end;

// *********************************************************************//
// DispIntf:  _ATCPlugInManagerDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {335A151E-3323-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATCPlugInManagerDisp = dispinterface
    ['{335A151E-3323-11D4-9D23-00A0C9768F70}']
    property ErrorDescription: WideString readonly dispid 1745027076;
    procedure Clear; dispid 1610809350;
    property Avail: _Collection readonly dispid 1745027075;
    property Active: _Collection readonly dispid 1745027074;
    property CurrentActive: {??ATCPlugIn}OleVariant readonly dispid 1745027073;
    property CurrentActiveIndex: Integer dispid 1745027072;
    function AvailIndexByName(var PluginName: WideString): Integer; dispid 1610809351;
    function ActiveIndexByName(var PluginName: WideString): Integer; dispid 1610809352;
    procedure Create(var AvailIndex: Integer); dispid 1610809353;
    procedure Delete(var ActiveIndex: Integer); dispid 1610809354;
    function QueryType(var PluginName: WideString): WideString; dispid 1610809355;
    function Load(var PluginName: WideString): WordBool; dispid 1610809356;
  end;

// *********************************************************************//
// Interface: _ATCclsCatalog
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {335A1520-3323-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATCclsCatalog = interface(IDispatch)
    ['{335A1520-3323-11D4-9D23-00A0C9768F70}']
    function Get_Plugins: _Collection; safecall;
    property Plugins: _Collection read Get_Plugins;
  end;

// *********************************************************************//
// DispIntf:  _ATCclsCatalogDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {335A1520-3323-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATCclsCatalogDisp = dispinterface
    ['{335A1520-3323-11D4-9D23-00A0C9768F70}']
    property Plugins: _Collection readonly dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _ATCclsTserData
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {014F3C6B-314F-4EFC-93FE-320FF0D61056}
// *********************************************************************//
  _ATCclsTserData = interface(IDispatch)
    ['{014F3C6B-314F-4EFC-93FE-320FF0D61056}']
    procedure AttribSet(var AttrName: WideString; var AttrValue: WideString; 
                        var AttrDef: _ATCclsAttributeDefinition); safecall;
    function Get_Attrib(var AttrName: WideString; var AttrDefault: WideString): WideString; safecall;
    function Get_AttribNumeric(var AttrName: WideString; var AttrDefault: Integer): Double; safecall;
    procedure _Set_Attribs(var Param1: _Collection); safecall;
    function Get_Attribs: _Collection; safecall;
    procedure calcSummary; safecall;
    procedure _Set_Dates(var Param1: _ATCclsTserDate); safecall;
    function Get_Dates: _ATCclsTserDate; safecall;
    procedure Set_ErrorDescription(var Param1: WideString); safecall;
    function Get_ErrorDescription: WideString; safecall;
    procedure _Set_File_(var Param1: _ATCclsTserFile); safecall;
    function Get_File_: _ATCclsTserFile; safecall;
    function Get_Flag(var index: Integer): Integer; safecall;
    procedure Set_flags(var Param1: PSafeArray); safecall;
    function Get_flags: PSafeArray; safecall;
    procedure _Set_Header(var Param1: _ATTimSerDataHeader); safecall;
    function Get_Header: _ATTimSerDataHeader; safecall;
    function Get_Serial: Integer; safecall;
    procedure Set_Dtran(var Param1: Integer); safecall;
    function Get_Dtran: Integer; safecall;
    procedure Set_Min(var Param1: Single); safecall;
    function Get_Min: Single; safecall;
    procedure Set_Max(var Param1: Single); safecall;
    function Get_Max: Single; safecall;
    function Get_Value(var index: Integer): Single; safecall;
    procedure Set_Values(var Param1: PSafeArray); safecall;
    function Get_Values: PSafeArray; safecall;
    function SubSetByDate(var s: Double; var e: Double): _ATCclsTserData; safecall;
    function doMath(var oper: ATCOperatorType; var ts2: _ATCclsTserData; var x: Double; 
                    var X2: Double): _ATCclsTserData; safecall;
    function Copy: _ATCclsTserData; safecall;
    function doDateCheck(var d1: _ATCclsTserDate; var d2: _ATCclsTserDate): WordBool; safecall;
    function Interpolate(var ds: _ATCclsTserDate): _ATCclsTserData; safecall;
    function Aggregate(var ds: _ATCclsTserDate; var Tran: ATCTran): _ATCclsTserData; safecall;
    function FillValues(ts: Integer; Tu: ATCTimeUnit; FillVal: Single; MissingVal: Single; 
                        var AccumVal: Single): _ATCclsTserData; safecall;
    function Compare(var nTs: _ATCclsTserData): WordBool; safecall;
    procedure Set_Value(var index: Integer; const Param2: Single); safecall;
    function doTable(var rangeTop: PSafeArray; var newValue: PSafeArray; var Interpolate: WordBool): _ATCclsTserData; safecall;
    function Get_AttribNames: _Collection; safecall;
    function FillMissing(var FillMethod: WideString; var MaxNMis: Integer; var MVal: Single): _ATCclsTserData; safecall;
    procedure Dump(var l: Integer); safecall;
    procedure Set_Mean(var Param1: Single); safecall;
    function Get_Mean: Single; safecall;
    procedure Set_Sum(var Param1: Single); safecall;
    function Get_Sum: Single; safecall;
    procedure Set_Variance(var Param1: Single); safecall;
    function Get_Variance: Single; safecall;
    procedure Set_StdDeviation(var Param1: Single); safecall;
    function Get_StdDeviation: Single; safecall;
    procedure Set_GeometricMean(var Param1: Single); safecall;
    function Get_GeometricMean: Single; safecall;
    function AddRemoveDates(var sjdate: Double; var ejdate: Double; var NewValueOption: Integer; 
                            var newValue: Single): _ATCclsTserData; safecall;
    property Attrib[var AttrName: WideString; var AttrDefault: WideString]: WideString read Get_Attrib;
    property AttribNumeric[var AttrName: WideString; var AttrDefault: Integer]: Double read Get_AttribNumeric;
    property Attribs: _Collection read Get_Attribs;
    property Dates: _ATCclsTserDate read Get_Dates;
    property ErrorDescription: WideString read Get_ErrorDescription write Set_ErrorDescription;
    property File_: _ATCclsTserFile read Get_File_;
    property Flag[var index: Integer]: Integer read Get_Flag;
    property flags: PSafeArray read Get_flags write Set_flags;
    property Header: _ATTimSerDataHeader read Get_Header;
    property Serial: Integer read Get_Serial;
    property Dtran: Integer read Get_Dtran write Set_Dtran;
    property Min: Single read Get_Min write Set_Min;
    property Max: Single read Get_Max write Set_Max;
    property Value[var index: Integer]: Single read Get_Value write Set_Value;
    property Values: PSafeArray read Get_Values write Set_Values;
    property AttribNames: _Collection read Get_AttribNames;
    property Mean: Single read Get_Mean write Set_Mean;
    property Sum: Single read Get_Sum write Set_Sum;
    property Variance: Single read Get_Variance write Set_Variance;
    property StdDeviation: Single read Get_StdDeviation write Set_StdDeviation;
    property GeometricMean: Single read Get_GeometricMean write Set_GeometricMean;
  end;

// *********************************************************************//
// DispIntf:  _ATCclsTserDataDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {014F3C6B-314F-4EFC-93FE-320FF0D61056}
// *********************************************************************//
  _ATCclsTserDataDisp = dispinterface
    ['{014F3C6B-314F-4EFC-93FE-320FF0D61056}']
    procedure AttribSet(var AttrName: WideString; var AttrValue: WideString; 
                        var AttrDef: _ATCclsAttributeDefinition); dispid 1610809359;
    property Attrib[var AttrName: WideString; var AttrDefault: WideString]: WideString readonly dispid 1745027086;
    property AttribNumeric[var AttrName: WideString; var AttrDefault: Integer]: Double readonly dispid 1745027085;
    property Attribs: _Collection dispid 1745027084;
    procedure calcSummary; dispid 1610809360;
    property Dates: _ATCclsTserDate dispid 1745027083;
    property ErrorDescription: WideString dispid 1745027082;
    property File_: _ATCclsTserFile dispid 1745027081;
    property Flag[var index: Integer]: Integer readonly dispid 1745027080;
    property flags: {??PSafeArray}OleVariant dispid 1745027079;
    property Header: _ATTimSerDataHeader dispid 1745027078;
    property Serial: Integer readonly dispid 1745027077;
    property Dtran: Integer dispid 1745027076;
    property Min: Single dispid 1745027075;
    property Max: Single dispid 1745027074;
    property Value[var index: Integer]: Single dispid 1745027073;
    property Values: {??PSafeArray}OleVariant dispid 1745027072;
    function SubSetByDate(var s: Double; var e: Double): _ATCclsTserData; dispid 1610809361;
    function doMath(var oper: ATCOperatorType; var ts2: _ATCclsTserData; var x: Double; 
                    var X2: Double): _ATCclsTserData; dispid 1610809362;
    function Copy: _ATCclsTserData; dispid 1610809363;
    function doDateCheck(var d1: _ATCclsTserDate; var d2: _ATCclsTserDate): WordBool; dispid 1610809364;
    function Interpolate(var ds: _ATCclsTserDate): _ATCclsTserData; dispid 1610809365;
    function Aggregate(var ds: _ATCclsTserDate; var Tran: ATCTran): _ATCclsTserData; dispid 1610809366;
    function FillValues(ts: Integer; Tu: ATCTimeUnit; FillVal: Single; MissingVal: Single; 
                        var AccumVal: Single): _ATCclsTserData; dispid 1610809367;
    function Compare(var nTs: _ATCclsTserData): WordBool; dispid 1610809368;
    function doTable(var rangeTop: {??PSafeArray}OleVariant; 
                     var newValue: {??PSafeArray}OleVariant; var Interpolate: WordBool): _ATCclsTserData; dispid 1610809369;
    property AttribNames: _Collection readonly dispid 1745027098;
    function FillMissing(var FillMethod: WideString; var MaxNMis: Integer; var MVal: Single): _ATCclsTserData; dispid 1610809371;
    procedure Dump(var l: Integer); dispid 1610809376;
    property Mean: Single dispid 1745027103;
    property Sum: Single dispid 1745027102;
    property Variance: Single dispid 1745027101;
    property StdDeviation: Single dispid 1745027100;
    property GeometricMean: Single dispid 1745027105;
    function AddRemoveDates(var sjdate: Double; var ejdate: Double; var NewValueOption: Integer; 
                            var newValue: Single): _ATCclsTserData; dispid 1610809378;
  end;

// *********************************************************************//
// Interface: _ATCclsTserDate
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {F7BBB3D6-22E9-45F0-BD24-7CC1B7B94FA5}
// *********************************************************************//
  _ATCclsTserDate = interface(IDispatch)
    ['{F7BBB3D6-22E9-45F0-BD24-7CC1B7B94FA5}']
    function IndexAtOrAfter(var targetDate: Double): Integer; safecall;
    function IndexAtOrBefore(var targetDate: Double): Integer; safecall;
    function SubSetByDate(var s: Double; var e: Double; var StartFrom: Integer): _ATCclsTserDate; safecall;
    function GetCommonDates(var cod: _Collection): _ATCclsTserDate; safecall;
    procedure _Set_File_(var Param1: _ATCclsTserFile); safecall;
    function Get_File_: _ATCclsTserFile; safecall;
    function Get_Flag(var index: Integer): Integer; safecall;
    procedure Set_flags(var Param1: PSafeArray); safecall;
    function Get_flags: PSafeArray; safecall;
    function Get_Serial: Integer; safecall;
    procedure Set_Summary(var Param1: ATTimSerDateSummary); safecall;
    function Get_Summary: ATTimSerDateSummary; safecall;
    function Get_Value(var index: Integer): Double; safecall;
    procedure Set_Values(var Param1: PSafeArray); safecall;
    function Get_Values: PSafeArray; safecall;
    procedure calcSummary(var PointFlg: WordBool); safecall;
    function Copy: _ATCclsTserDate; safecall;
    procedure Set_Value(var index: Integer; Const Param2: Double); safecall;
    property File_: _ATCclsTserFile read Get_File_;
    property Flag[var index: Integer]: Integer read Get_Flag;
    property flags: PSafeArray read Get_flags write Set_flags;
    property Serial: Integer read Get_Serial;
    property Summary: ATTimSerDateSummary read Get_Summary write Set_Summary;
    property Value[var index: Integer]: Double read Get_Value write Set_Value;
    property Values: PSafeArray read Get_Values write Set_Values;
  end;

// *********************************************************************//
// DispIntf:  _ATCclsTserDateDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {F7BBB3D6-22E9-45F0-BD24-7CC1B7B94FA5}
// *********************************************************************//
  _ATCclsTserDateDisp = dispinterface
    ['{F7BBB3D6-22E9-45F0-BD24-7CC1B7B94FA5}']
    function IndexAtOrAfter(var targetDate: Double): Integer; dispid 1610809351;
    function IndexAtOrBefore(var targetDate: Double): Integer; dispid 1610809352;
    function SubSetByDate(var s: Double; var e: Double; var StartFrom: Integer): _ATCclsTserDate; dispid 1610809353;
    function GetCommonDates(var cod: _Collection): _ATCclsTserDate; dispid 1610809354;
    property File_: _ATCclsTserFile dispid 1745027078;
    property Flag[var index: Integer]: Integer readonly dispid 1745027077;
    property flags: {??PSafeArray}OleVariant dispid 1745027076;
    property Serial: Integer readonly dispid 1745027075;
    property Summary: {??ATTimSerDateSummary}OleVariant dispid 1745027074;
    property Value[var index: Integer]: Double dispid 1745027073;
    property Values: {??PSafeArray}OleVariant dispid 1745027072;
    procedure calcSummary(var PointFlg: WordBool); dispid 1610809355;
    function Copy: _ATCclsTserDate; dispid 1610809359;
  end;

// *********************************************************************//
// Interface: _ATCclsTserFile
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5E6F5092-091B-11D5-983A-00A024C11E04}
// *********************************************************************//
  _ATCclsTserFile = interface(IDispatch)
    ['{5E6F5092-091B-11D5-983A-00A024C11E04}']
    procedure _Set_Monitor(const Param1: IDispatch); safecall;
    function Get_ErrorDescription: WideString; safecall;
    function Get_FileExtension: WideString; safecall;
    function Get_Label_: WideString; safecall;
    function Get_FileName: WideString; safecall;
    procedure Set_FileName(const Param1: WideString); safecall;
    function Get_FileUnit: Integer; safecall;
    function Get_Description: WideString; safecall;
    function Get_AvailableAttributes: _Collection; safecall;
    function Get_Data(var index: Integer): _ATCclsTserData; safecall;
    function Get_DataCount: Integer; safecall;
    procedure readData(var dataObject: _ATCclsTserData); safecall;
    procedure Clear; safecall;
    procedure refresh; safecall;
    function WriteDataHeader(var dataObject: _ATCclsTserData; var oldHeader: _ATTimSerDataHeader): WordBool; safecall;
    function AddTimSer(var t: _ATCclsTserData; var ExistAction: Integer): WordBool; safecall;
    function RemoveTimSer(var t: _ATCclsTserData): WordBool; safecall;
    function RewriteTimSer(var t: _ATCclsTserData): WordBool; safecall;
    function SaveAs(var FileName: WideString): WordBool; safecall;
    function Get_DataCollection: _Collection; safecall;
    procedure Set_HelpFilename(const Param1: WideString); safecall;
    property ErrorDescription: WideString read Get_ErrorDescription;
    property FileExtension: WideString read Get_FileExtension;
    property Label_: WideString read Get_Label_;
    property FileName: WideString read Get_FileName write Set_FileName;
    property FileUnit: Integer read Get_FileUnit;
    property Description: WideString read Get_Description;
    property AvailableAttributes: _Collection read Get_AvailableAttributes;
    property Data[var index: Integer]: _ATCclsTserData read Get_Data;
    property DataCount: Integer read Get_DataCount;
    property DataCollection: _Collection read Get_DataCollection;
    property HelpFilename: WideString write Set_HelpFilename;
  end;

// *********************************************************************//
// DispIntf:  _ATCclsTserFileDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5E6F5092-091B-11D5-983A-00A024C11E04}
// *********************************************************************//
  _ATCclsTserFileDisp = dispinterface
    ['{5E6F5092-091B-11D5-983A-00A024C11E04}']
    property ErrorDescription: WideString readonly dispid 1745027080;
    property FileExtension: WideString readonly dispid 1745027079;
    property Label_: WideString readonly dispid 1745027078;
    property FileName: WideString dispid 1745027077;
    property FileUnit: Integer readonly dispid 1745027076;
    property Description: WideString readonly dispid 1745027075;
    property AvailableAttributes: _Collection readonly dispid 1745027074;
    property Data[var index: Integer]: _ATCclsTserData readonly dispid 1745027073;
    property DataCount: Integer readonly dispid 1745027072;
    procedure readData(var dataObject: _ATCclsTserData); dispid 1610809354;
    procedure Clear; dispid 1610809355;
    procedure refresh; dispid 1610809356;
    function WriteDataHeader(var dataObject: _ATCclsTserData; var oldHeader: _ATTimSerDataHeader): WordBool; dispid 1610809357;
    function AddTimSer(var t: _ATCclsTserData; var ExistAction: Integer): WordBool; dispid 1610809358;
    function RemoveTimSer(var t: _ATCclsTserData): WordBool; dispid 1610809359;
    function RewriteTimSer(var t: _ATCclsTserData): WordBool; dispid 1610809360;
    function SaveAs(var FileName: WideString): WordBool; dispid 1610809361;
    property DataCollection: _Collection readonly dispid 1745027090;
    property HelpFilename: WideString writeonly dispid 1745027091;
  end;

// *********************************************************************//
// Interface: _ATCclsCriterion
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {335A152B-3323-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATCclsCriterion = interface(IDispatch)
    ['{335A152B-3323-11D4-9D23-00A0C9768F70}']
    function Match(var testValue: OleVariant): WordBool; safecall;
    function MatchField(var obj: OleVariant): WordBool; safecall;
    function Get_Field: WideString; safecall;
    procedure Set_Field(var Param1: WideString); safecall;
    function Get_Operation: ATCCompare; safecall;
    procedure Set_Operation(var Param1: ATCCompare); safecall;
    function Get_Values: _Collection; safecall;
    procedure Set_Values(var Param1: _Collection); safecall;
    property Field: WideString read Get_Field write Set_Field;
    property Operation: ATCCompare read Get_Operation write Set_Operation;
    property Values: _Collection read Get_Values write Set_Values;
  end;

// *********************************************************************//
// DispIntf:  _ATCclsCriterionDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {335A152B-3323-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATCclsCriterionDisp = dispinterface
    ['{335A152B-3323-11D4-9D23-00A0C9768F70}']
    function Match(var testValue: OleVariant): WordBool; dispid 1610809347;
    function MatchField(var obj: OleVariant): WordBool; dispid 1610809348;
    property Field: WideString dispid 1745027074;
    property Operation: ATCCompare dispid 1745027073;
    property Values: _Collection dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _ATTimSerDataHeader
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {62CCA97A-7201-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATTimSerDataHeader = interface(IDispatch)
    ['{62CCA97A-7201-11D4-9D23-00A0C9768F70}']
    function Get_Desc: WideString; safecall;
    procedure Set_Desc(var Param1: WideString); safecall;
    function Get_id: Double; safecall;
    procedure Set_id(var Param1: Double); safecall;
    function Get_Sen: WideString; safecall;
    procedure Set_Sen(var Param1: WideString); safecall;
    function Get_Loc: WideString; safecall;
    procedure Set_Loc(var Param1: WideString); safecall;
    function Get_Con: WideString; safecall;
    procedure Set_Con(var Param1: WideString); safecall;
    function Copy: _ATTimSerDataHeader; safecall;
    function Compare(var nTsHeader: _ATTimSerDataHeader): WordBool; safecall;
    property Desc: WideString read Get_Desc write Set_Desc;
    property id: Double read Get_id write Set_id;
    property Sen: WideString read Get_Sen write Set_Sen;
    property Loc: WideString read Get_Loc write Set_Loc;
    property Con: WideString read Get_Con write Set_Con;
  end;

// *********************************************************************//
// DispIntf:  _ATTimSerDataHeaderDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {62CCA97A-7201-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATTimSerDataHeaderDisp = dispinterface
    ['{62CCA97A-7201-11D4-9D23-00A0C9768F70}']
    property Desc: WideString dispid 1745027076;
    property id: Double dispid 1745027075;
    property Sen: WideString dispid 1745027074;
    property Loc: WideString dispid 1745027073;
    property Con: WideString dispid 1745027072;
    function Copy: _ATTimSerDataHeader; dispid 1610809349;
    function Compare(var nTsHeader: _ATTimSerDataHeader): WordBool; dispid 1610809350;
  end;

// *********************************************************************//
// Interface: _ATCclsParm
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {335A1532-3323-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATCclsParm = interface(IDispatch)
    ['{335A1532-3323-11D4-9D23-00A0C9768F70}']
    function Get_Value: WideString; safecall;
    procedure Set_Value(var Param1: WideString); safecall;
    function Get_Def: _ATCclsParmDef; safecall;
    procedure _Set_Def(var Param1: _ATCclsParmDef); safecall;
    function Get_Parent: IDispatch; safecall;
    procedure _Set_Parent(var Param1: IDispatch); safecall;
    function Get_Name: WideString; safecall;
    property Value: WideString read Get_Value write Set_Value;
    property Def: _ATCclsParmDef read Get_Def;
    property Parent: IDispatch read Get_Parent;
    property Name: WideString read Get_Name;
  end;

// *********************************************************************//
// DispIntf:  _ATCclsParmDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {335A1532-3323-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATCclsParmDisp = dispinterface
    ['{335A1532-3323-11D4-9D23-00A0C9768F70}']
    property Value: WideString dispid 0;
    property Def: _ATCclsParmDef dispid 1745027074;
    property Parent: IDispatch dispid 1745027073;
    property Name: WideString readonly dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _ATCclsParmDef
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {335A1530-3323-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATCclsParmDef = interface(IDispatch)
    ['{335A1530-3323-11D4-9D23-00A0C9768F70}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_Typ: Integer; safecall;
    procedure Set_Typ(var Param1: Integer); safecall;
    function Get_Min: Double; safecall;
    procedure Set_Min(var Param1: Double); safecall;
    function Get_Max: Double; safecall;
    procedure Set_Max(var Param1: Double); safecall;
    function Get_Default: WideString; safecall;
    procedure Set_Default(var Param1: WideString); safecall;
    function Get_SoftMin: Double; safecall;
    procedure Set_SoftMin(var Param1: Double); safecall;
    function Get_SoftMax: Double; safecall;
    procedure Set_SoftMax(var Param1: Double); safecall;
    function Get_Define: WideString; safecall;
    procedure Set_Define(var Param1: WideString); safecall;
    function Get_Parent: IDispatch; safecall;
    procedure _Set_Parent(var Param1: IDispatch); safecall;
    function Get_Other: WideString; safecall;
    procedure Set_Other(var Param1: WideString); safecall;
    function Get_StartCol: Integer; safecall;
    procedure Set_StartCol(var Param1: Integer); safecall;
    function Get_Length: Integer; safecall;
    procedure Set_Length(var Param1: Integer); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Typ: Integer read Get_Typ write Set_Typ;
    property Min: Double read Get_Min write Set_Min;
    property Max: Double read Get_Max write Set_Max;
    property Default: WideString read Get_Default write Set_Default;
    property SoftMin: Double read Get_SoftMin write Set_SoftMin;
    property SoftMax: Double read Get_SoftMax write Set_SoftMax;
    property Define: WideString read Get_Define write Set_Define;
    property Parent: IDispatch read Get_Parent;
    property Other: WideString read Get_Other write Set_Other;
    property StartCol: Integer read Get_StartCol write Set_StartCol;
    property Length: Integer read Get_Length write Set_Length;
  end;

// *********************************************************************//
// DispIntf:  _ATCclsParmDefDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {335A1530-3323-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _ATCclsParmDefDisp = dispinterface
    ['{335A1530-3323-11D4-9D23-00A0C9768F70}']
    property Name: WideString dispid 1745027083;
    property Typ: Integer dispid 1745027082;
    property Min: Double dispid 1745027081;
    property Max: Double dispid 1745027080;
    property Default: WideString dispid 1745027079;
    property SoftMin: Double dispid 1745027078;
    property SoftMax: Double dispid 1745027077;
    property Define: WideString dispid 1745027076;
    property Parent: IDispatch dispid 1745027075;
    property Other: WideString dispid 1745027074;
    property StartCol: Integer dispid 1745027073;
    property Length: Integer dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _ATCclsAttributeDefinition
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {A7CE20A6-8C27-41BF-860D-B3702A0CABD2}
// *********************************************************************//
  _ATCclsAttributeDefinition = interface(IDispatch)
    ['{A7CE20A6-8C27-41BF-860D-B3702A0CABD2}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_Description: WideString; safecall;
    procedure Set_Description(var Param1: WideString); safecall;
    function Get_DataType: ATCoDataType; safecall;
    procedure Set_DataType(var Param1: ATCoDataType); safecall;
    function Get_Min: Single; safecall;
    procedure Set_Min(var Param1: Single); safecall;
    function Get_Max: Single; safecall;
    procedure Set_Max(var Param1: Single); safecall;
    function Get_ValidValues: WideString; safecall;
    procedure Set_ValidValues(var Param1: WideString); safecall;
    function Get_Default: Single; safecall;
    procedure Set_Default(var Param1: Single); safecall;
    function Dump: WideString; safecall;
    function Get_Editable: WordBool; safecall;
    procedure Set_Editable(var Param1: WordBool); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Description: WideString read Get_Description write Set_Description;
    property DataType: ATCoDataType read Get_DataType write Set_DataType;
    property Min: Single read Get_Min write Set_Min;
    property Max: Single read Get_Max write Set_Max;
    property ValidValues: WideString read Get_ValidValues write Set_ValidValues;
    property Default: Single read Get_Default write Set_Default;
    property Editable: WordBool read Get_Editable write Set_Editable;
  end;

// *********************************************************************//
// DispIntf:  _ATCclsAttributeDefinitionDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {A7CE20A6-8C27-41BF-860D-B3702A0CABD2}
// *********************************************************************//
  _ATCclsAttributeDefinitionDisp = dispinterface
    ['{A7CE20A6-8C27-41BF-860D-B3702A0CABD2}']
    property Name: WideString dispid 1745027078;
    property Description: WideString dispid 1745027077;
    property DataType: ATCoDataType dispid 1745027076;
    property Min: Single dispid 1745027075;
    property Max: Single dispid 1745027074;
    property ValidValues: WideString dispid 1745027073;
    property Default: Single dispid 1745027072;
    function Dump: WideString; dispid 1610809351;
    property Editable: WordBool dispid 1745027080;
  end;

// *********************************************************************//
// Interface: _CollString
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4AED0D14-8E55-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _CollString = interface(IDispatch)
    ['{4AED0D14-8E55-11D4-9D23-00A0C9768F70}']
    function Add(const newValue: WideString; const key: WideString): WideString; safecall;
    procedure Clear; safecall;
    function Get_coll: _Collection; safecall;
    procedure _Set_coll(var Param1: _Collection); safecall;
    function Count: Integer; safecall;
    function Get_Keys: _Collection; safecall;
    procedure Remove(key: OleVariant); safecall;
    function Item(key: OleVariant): WideString; safecall;
    function NewEnum: IUnknown; safecall;
    property coll: _Collection read Get_coll;
    property Keys: _Collection read Get_Keys;
  end;

// *********************************************************************//
// DispIntf:  _CollStringDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4AED0D14-8E55-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _CollStringDisp = dispinterface
    ['{4AED0D14-8E55-11D4-9D23-00A0C9768F70}']
    function Add(const newValue: WideString; const key: WideString): WideString; dispid 1610809346;
    procedure Clear; dispid 1610809347;
    property coll: _Collection dispid 1745027073;
    function Count: Integer; dispid 1610809348;
    property Keys: _Collection readonly dispid 1745027072;
    procedure Remove(key: OleVariant); dispid 1610809349;
    function Item(key: OleVariant): WideString; dispid 0;
    function NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: _CollTserData
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4AED0D16-8E55-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _CollTserData = interface(IDispatch)
    ['{4AED0D16-8E55-11D4-9D23-00A0C9768F70}']
    function Add(const newValue: _ATCclsTserData; const key: WideString): WideString; safecall;
    procedure Clear; safecall;
    function Get_coll: _Collection; safecall;
    procedure _Set_coll(var Param1: _Collection); safecall;
    function Count: Integer; safecall;
    function Get_Keys: _Collection; safecall;
    procedure Remove(key: OleVariant); safecall;
    function Item(key: OleVariant): _ATCclsTserData; safecall;
    function NewEnum: IUnknown; safecall;
    property coll: _Collection read Get_coll;
    property Keys: _Collection read Get_Keys;
  end;

// *********************************************************************//
// DispIntf:  _CollTserDataDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4AED0D16-8E55-11D4-9D23-00A0C9768F70}
// *********************************************************************//
  _CollTserDataDisp = dispinterface
    ['{4AED0D16-8E55-11D4-9D23-00A0C9768F70}']
    function Add(const newValue: _ATCclsTserData; const key: WideString): WideString; dispid 1610809346;
    procedure Clear; dispid 1610809347;
    property coll: _Collection dispid 1745027073;
    function Count: Integer; dispid 1610809348;
    property Keys: _Collection readonly dispid 1745027072;
    procedure Remove(key: OleVariant); dispid 1610809349;
    function Item(key: OleVariant): _ATCclsTserData; dispid 1610809350;
    function NewEnum: IUnknown; dispid 1610809351;
  end;

// *********************************************************************//
// Interface: _ATCclsAnalysis
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {64C7B902-315B-4D24-B4C2-AE9FDAF77EA9}
// *********************************************************************//
  _ATCclsAnalysis = interface(IDispatch)
    ['{64C7B902-315B-4D24-B4C2-AE9FDAF77EA9}']
    procedure _Set_Monitor(const Param1: IDispatch); safecall;
    function Get_ErrorDescription: WideString; safecall;
    function Get_Description: WideString; safecall;
    procedure _Set_DataCollection(var Param1: _Collection); safecall;
    procedure Go; safecall;
    function EditSpecification: WordBool; safecall;
    function Get_Specification: WideString; safecall;
    procedure Set_Specification(var Param1: WideString); safecall;
    property ErrorDescription: WideString read Get_ErrorDescription;
    property Description: WideString read Get_Description;
    property Specification: WideString read Get_Specification write Set_Specification;
  end;

// *********************************************************************//
// DispIntf:  _ATCclsAnalysisDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {64C7B902-315B-4D24-B4C2-AE9FDAF77EA9}
// *********************************************************************//
  _ATCclsAnalysisDisp = dispinterface
    ['{64C7B902-315B-4D24-B4C2-AE9FDAF77EA9}']
    property ErrorDescription: WideString readonly dispid 1745027075;
    property Description: WideString readonly dispid 1745027074;
    procedure Go; dispid 1610809349;
    function EditSpecification: WordBool; dispid 1610809350;
    property Specification: WideString dispid 1745027072;
  end;

// *********************************************************************//
// The Class CoATCDataTypes provides a Create and CreateRemote method to          
// create instances of the default interface _ATCDataTypes exposed by              
// the CoClass ATCDataTypes. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCDataTypes = class
    class function Create: _ATCDataTypes;
    class function CreateRemote(const MachineName: string): _ATCDataTypes;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATCDataTypes
// Help String      : 
// Default Interface: _ATCDataTypes
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATCDataTypesProperties= class;
{$ENDIF}
  TATCDataTypes = class(TOleServer)
  private
    FIntf: _ATCDataTypes;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATCDataTypesProperties;
    function GetServerProperties: TATCDataTypesProperties;
{$ENDIF}
    function GetDefaultInterface: _ATCDataTypes;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATCDataTypes);
    procedure Disconnect; override;
    property DefaultInterface: _ATCDataTypes read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATCDataTypesProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATCDataTypes
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATCDataTypesProperties = class(TPersistent)
  private
    FServer:    TATCDataTypes;
    function    GetDefaultInterface: _ATCDataTypes;
    constructor Create(AServer: TATCDataTypes);
  protected
  public
    property DefaultInterface: _ATCDataTypes read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoATCPlugInTypes provides a Create and CreateRemote method to          
// create instances of the default interface _ATCPlugInTypes exposed by              
// the CoClass ATCPlugInTypes. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCPlugInTypes = class
    class function Create: _ATCPlugInTypes;
    class function CreateRemote(const MachineName: string): _ATCPlugInTypes;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATCPlugInTypes
// Help String      : 
// Default Interface: _ATCPlugInTypes
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATCPlugInTypesProperties= class;
{$ENDIF}
  TATCPlugInTypes = class(TOleServer)
  private
    FIntf: _ATCPlugInTypes;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATCPlugInTypesProperties;
    function GetServerProperties: TATCPlugInTypesProperties;
{$ENDIF}
    function GetDefaultInterface: _ATCPlugInTypes;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATCPlugInTypes);
    procedure Disconnect; override;
    property DefaultInterface: _ATCPlugInTypes read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATCPlugInTypesProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATCPlugInTypes
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATCPlugInTypesProperties = class(TPersistent)
  private
    FServer:    TATCPlugInTypes;
    function    GetDefaultInterface: _ATCPlugInTypes;
    constructor Create(AServer: TATCPlugInTypes);
  protected
  public
    property DefaultInterface: _ATCPlugInTypes read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoATCPlugInManager provides a Create and CreateRemote method to          
// create instances of the default interface _ATCPlugInManager exposed by              
// the CoClass ATCPlugInManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCPlugInManager = class
    class function Create: _ATCPlugInManager;
    class function CreateRemote(const MachineName: string): _ATCPlugInManager;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATCPlugInManager
// Help String      : 
// Default Interface: _ATCPlugInManager
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATCPlugInManagerProperties= class;
{$ENDIF}
  TATCPlugInManager = class(TOleServer)
  private
    FIntf: _ATCPlugInManager;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATCPlugInManagerProperties;
    function GetServerProperties: TATCPlugInManagerProperties;
{$ENDIF}
    function GetDefaultInterface: _ATCPlugInManager;
  protected
    procedure InitServerData; override;
    function Get_ErrorDescription: WideString;
    function Get_Avail: _Collection;
    function Get_Active: _Collection;
    function Get_CurrentActive: ATCPlugIn;
    procedure Set_CurrentActiveIndex(Param1: Integer);
    function Get_CurrentActiveIndex: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATCPlugInManager);
    procedure Disconnect; override;
    procedure Clear;
    function AvailIndexByName(var PluginName: WideString): Integer;
    function ActiveIndexByName(var PluginName: WideString): Integer;
    procedure Create1(var AvailIndex: Integer);
    procedure Delete(var ActiveIndex: Integer);
    function QueryType(var PluginName: WideString): WideString;
    function Load(var PluginName: WideString): WordBool;
    property DefaultInterface: _ATCPlugInManager read GetDefaultInterface;
    property ErrorDescription: WideString read Get_ErrorDescription;
    property Avail: _Collection read Get_Avail;
    property Active: _Collection read Get_Active;
    property CurrentActive: ATCPlugIn read Get_CurrentActive;
    property CurrentActiveIndex: Integer read Get_CurrentActiveIndex write Set_CurrentActiveIndex;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATCPlugInManagerProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATCPlugInManager
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATCPlugInManagerProperties = class(TPersistent)
  private
    FServer:    TATCPlugInManager;
    function    GetDefaultInterface: _ATCPlugInManager;
    constructor Create(AServer: TATCPlugInManager);
  protected
    function Get_ErrorDescription: WideString;
    function Get_Avail: _Collection;
    function Get_Active: _Collection;
    function Get_CurrentActive: ATCPlugIn;
    procedure Set_CurrentActiveIndex(Param1: Integer);
    function Get_CurrentActiveIndex: Integer;
  public
    property DefaultInterface: _ATCPlugInManager read GetDefaultInterface;
  published
    property CurrentActiveIndex: Integer read Get_CurrentActiveIndex write Set_CurrentActiveIndex;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoATCclsCatalog provides a Create and CreateRemote method to          
// create instances of the default interface _ATCclsCatalog exposed by              
// the CoClass ATCclsCatalog. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCclsCatalog = class
    class function Create: _ATCclsCatalog;
    class function CreateRemote(const MachineName: string): _ATCclsCatalog;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATCclsCatalog
// Help String      : 
// Default Interface: _ATCclsCatalog
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATCclsCatalogProperties= class;
{$ENDIF}
  TATCclsCatalog = class(TOleServer)
  private
    FIntf: _ATCclsCatalog;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATCclsCatalogProperties;
    function GetServerProperties: TATCclsCatalogProperties;
{$ENDIF}
    function GetDefaultInterface: _ATCclsCatalog;
  protected
    procedure InitServerData; override;
    function Get_Plugins: _Collection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATCclsCatalog);
    procedure Disconnect; override;
    property DefaultInterface: _ATCclsCatalog read GetDefaultInterface;
    property Plugins: _Collection read Get_Plugins;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATCclsCatalogProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATCclsCatalog
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATCclsCatalogProperties = class(TPersistent)
  private
    FServer:    TATCclsCatalog;
    function    GetDefaultInterface: _ATCclsCatalog;
    constructor Create(AServer: TATCclsCatalog);
  protected
    function Get_Plugins: _Collection;
  public
    property DefaultInterface: _ATCclsCatalog read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoATCclsTserData provides a Create and CreateRemote method to          
// create instances of the default interface _ATCclsTserData exposed by              
// the CoClass ATCclsTserData. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCclsTserData = class
    class function Create: _ATCclsTserData;
    class function CreateRemote(const MachineName: string): _ATCclsTserData;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATCclsTserData
// Help String      : 
// Default Interface: _ATCclsTserData
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATCclsTserDataProperties= class;
{$ENDIF}
  TATCclsTserData = class(TOleServer)
  private
    FIntf: _ATCclsTserData;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATCclsTserDataProperties;
    function GetServerProperties: TATCclsTserDataProperties;
{$ENDIF}
    function GetDefaultInterface: _ATCclsTserData;
  protected
    procedure InitServerData; override;
    function Get_Attrib(var AttrName: WideString; var AttrDefault: WideString): WideString;
    function Get_AttribNumeric(var AttrName: WideString; var AttrDefault: Integer): Double;
    procedure _Set_Attribs(var Param1: _Collection);
    function Get_Attribs: _Collection;
    procedure _Set_Dates(var Param1: _ATCclsTserDate);
    function Get_Dates: _ATCclsTserDate;
    procedure Set_ErrorDescription(var Param1: WideString);
    function Get_ErrorDescription: WideString;
    procedure _Set_File_(var Param1: _ATCclsTserFile);
    function Get_File_: _ATCclsTserFile;
    function Get_Flag(var index: Integer): Integer;
    procedure Set_flags(var Param1: PSafeArray);
    function Get_flags: PSafeArray;
    procedure _Set_Header(var Param1: _ATTimSerDataHeader);
    function Get_Header: _ATTimSerDataHeader;
    function Get_Serial: Integer;
    procedure Set_Dtran(var Param1: Integer);
    function Get_Dtran: Integer;
    procedure Set_Min(var Param1: Single);
    function Get_Min: Single;
    procedure Set_Max(var Param1: Single);
    function Get_Max: Single;
    function Get_Value(var index: Integer): Single;
    procedure Set_Values(var Param1: PSafeArray);
    function Get_Values: PSafeArray;
    procedure Set_Value(var index: Integer; const Param2: Single);
    function Get_AttribNames: _Collection;
    procedure Set_Mean(var Param1: Single);
    function Get_Mean: Single;
    procedure Set_Sum(var Param1: Single);
    function Get_Sum: Single;
    procedure Set_Variance(var Param1: Single);
    function Get_Variance: Single;
    procedure Set_StdDeviation(var Param1: Single);
    function Get_StdDeviation: Single;
    procedure Set_GeometricMean(var Param1: Single);
    function Get_GeometricMean: Single;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATCclsTserData);
    procedure Disconnect; override;
    procedure AttribSet(var AttrName: WideString; var AttrValue: WideString; 
                        var AttrDef: _ATCclsAttributeDefinition);
    procedure calcSummary;
    function SubSetByDate(var s: Double; var e: Double): _ATCclsTserData;
    function doMath(var oper: ATCOperatorType; var ts2: _ATCclsTserData; var x: Double; 
                    var X2: Double): _ATCclsTserData;
    function Copy: _ATCclsTserData;
    function doDateCheck(var d1: _ATCclsTserDate; var d2: _ATCclsTserDate): WordBool;
    function Interpolate(var ds: _ATCclsTserDate): _ATCclsTserData;
    function Aggregate(var ds: _ATCclsTserDate; var Tran: ATCTran): _ATCclsTserData;
    function FillValues(ts: Integer; Tu: ATCTimeUnit; FillVal: Single; MissingVal: Single; 
                        var AccumVal: Single): _ATCclsTserData;
    function Compare(var nTs: _ATCclsTserData): WordBool;
    function doTable(var rangeTop: PSafeArray; var newValue: PSafeArray; var Interpolate: WordBool): _ATCclsTserData;
    function FillMissing(var FillMethod: WideString; var MaxNMis: Integer; var MVal: Single): _ATCclsTserData;
    procedure Dump(var l: Integer);
    function AddRemoveDates(var sjdate: Double; var ejdate: Double; var NewValueOption: Integer; 
                            var newValue: Single): _ATCclsTserData;
    property DefaultInterface: _ATCclsTserData read GetDefaultInterface;
    property Attrib[var AttrName: WideString; var AttrDefault: WideString]: WideString read Get_Attrib;
    property AttribNumeric[var AttrName: WideString; var AttrDefault: Integer]: Double read Get_AttribNumeric;
    property Attribs: _Collection read Get_Attribs write _Set_Attribs;
    property Dates: _ATCclsTserDate read Get_Dates write _Set_Dates;
    property File_: _ATCclsTserFile read Get_File_ write _Set_File_;
    property Flag[var index: Integer]: Integer read Get_Flag;
    property Header: _ATTimSerDataHeader read Get_Header write _Set_Header;
    property Serial: Integer read Get_Serial;
    property Value[var index: Integer]: Single read Get_Value write Set_Value;
    property AttribNames: _Collection read Get_AttribNames;
    property ErrorDescription: WideString read Get_ErrorDescription write Set_ErrorDescription;
    property flags: PSafeArray read Get_flags write Set_flags;
    property Dtran: Integer read Get_Dtran write Set_Dtran;
    property Min: Single read Get_Min write Set_Min;
    property Max: Single read Get_Max write Set_Max;
    property Values: PSafeArray read Get_Values write Set_Values;
    property Mean: Single read Get_Mean write Set_Mean;
    property Sum: Single read Get_Sum write Set_Sum;
    property Variance: Single read Get_Variance write Set_Variance;
    property StdDeviation: Single read Get_StdDeviation write Set_StdDeviation;
    property GeometricMean: Single read Get_GeometricMean write Set_GeometricMean;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATCclsTserDataProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATCclsTserData
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATCclsTserDataProperties = class(TPersistent)
  private
    FServer:    TATCclsTserData;
    function    GetDefaultInterface: _ATCclsTserData;
    constructor Create(AServer: TATCclsTserData);
  protected
    function Get_Attrib(var AttrName: WideString; var AttrDefault: WideString): WideString;
    function Get_AttribNumeric(var AttrName: WideString; var AttrDefault: Integer): Double;
    procedure _Set_Attribs(var Param1: _Collection);
    function Get_Attribs: _Collection;
    procedure _Set_Dates(var Param1: _ATCclsTserDate);
    function Get_Dates: _ATCclsTserDate;
    procedure Set_ErrorDescription(var Param1: WideString);
    function Get_ErrorDescription: WideString;
    procedure _Set_File_(var Param1: _ATCclsTserFile);
    function Get_File_: _ATCclsTserFile;
    function Get_Flag(var index: Integer): Integer;
    procedure Set_flags(var Param1: PSafeArray);
    function Get_flags: PSafeArray;
    procedure _Set_Header(var Param1: _ATTimSerDataHeader);
    function Get_Header: _ATTimSerDataHeader;
    function Get_Serial: Integer;
    procedure Set_Dtran(var Param1: Integer);
    function Get_Dtran: Integer;
    procedure Set_Min(var Param1: Single);
    function Get_Min: Single;
    procedure Set_Max(var Param1: Single);
    function Get_Max: Single;
    function Get_Value(var index: Integer): Single;
    procedure Set_Values(var Param1: PSafeArray);
    function Get_Values: PSafeArray;
    procedure Set_Value(var index: Integer; var Param2: Single);
    function Get_AttribNames: _Collection;
    procedure Set_Mean(var Param1: Single);
    function Get_Mean: Single;
    procedure Set_Sum(var Param1: Single);
    function Get_Sum: Single;
    procedure Set_Variance(var Param1: Single);
    function Get_Variance: Single;
    procedure Set_StdDeviation(var Param1: Single);
    function Get_StdDeviation: Single;
    procedure Set_GeometricMean(var Param1: Single);
    function Get_GeometricMean: Single;
  public
    property DefaultInterface: _ATCclsTserData read GetDefaultInterface;
  published
    property ErrorDescription: WideString read Get_ErrorDescription write Set_ErrorDescription;
    property flags: PSafeArray read Get_flags write Set_flags;
    property Dtran: Integer read Get_Dtran write Set_Dtran;
    property Min: Single read Get_Min write Set_Min;
    property Max: Single read Get_Max write Set_Max;
    property Values: PSafeArray read Get_Values write Set_Values;
    property Mean: Single read Get_Mean write Set_Mean;
    property Sum: Single read Get_Sum write Set_Sum;
    property Variance: Single read Get_Variance write Set_Variance;
    property StdDeviation: Single read Get_StdDeviation write Set_StdDeviation;
    property GeometricMean: Single read Get_GeometricMean write Set_GeometricMean;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoATCclsTserDate provides a Create and CreateRemote method to          
// create instances of the default interface _ATCclsTserDate exposed by              
// the CoClass ATCclsTserDate. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCclsTserDate = class
    class function Create: _ATCclsTserDate;
    class function CreateRemote(const MachineName: string): _ATCclsTserDate;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATCclsTserDate
// Help String      : 
// Default Interface: _ATCclsTserDate
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATCclsTserDateProperties= class;
{$ENDIF}
  TATCclsTserDate = class(TOleServer)
  private
    FIntf: _ATCclsTserDate;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATCclsTserDateProperties;
    function GetServerProperties: TATCclsTserDateProperties;
{$ENDIF}
    function GetDefaultInterface: _ATCclsTserDate;
  protected
    procedure InitServerData; override;
    procedure _Set_File_(var Param1: _ATCclsTserFile);
    function Get_File_: _ATCclsTserFile;
    function Get_Flag(var index: Integer): Integer;
    procedure Set_flags(var Param1: PSafeArray);
    function Get_flags: PSafeArray;
    function Get_Serial: Integer;
    procedure Set_Summary(var Param1: ATTimSerDateSummary);
    function Get_Summary: ATTimSerDateSummary;
    function Get_Value(var index: Integer): Double;
    procedure Set_Values(var Param1: PSafeArray);
    function Get_Values: PSafeArray;
    procedure Set_Value(var index: Integer; const Param2: Double);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATCclsTserDate);
    procedure Disconnect; override;
    function IndexAtOrAfter(var targetDate: Double): Integer;
    function IndexAtOrBefore(var targetDate: Double): Integer;
    function SubSetByDate(var s: Double; var e: Double; var StartFrom: Integer): _ATCclsTserDate;
    function GetCommonDates(var cod: _Collection): _ATCclsTserDate;
    procedure calcSummary(var PointFlg: WordBool);
    function Copy: _ATCclsTserDate;
    property DefaultInterface: _ATCclsTserDate read GetDefaultInterface;
    property File_: _ATCclsTserFile read Get_File_ write _Set_File_;
    property Flag[var index: Integer]: Integer read Get_Flag;
    property Serial: Integer read Get_Serial;
    property Value[var index: Integer]: Double read Get_Value write Set_Value;
    property flags: PSafeArray read Get_flags write Set_flags;
    property Summary: ATTimSerDateSummary read Get_Summary write Set_Summary;
    property Values: PSafeArray read Get_Values write Set_Values;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATCclsTserDateProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATCclsTserDate
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATCclsTserDateProperties = class(TPersistent)
  private
    FServer:    TATCclsTserDate;
    function    GetDefaultInterface: _ATCclsTserDate;
    constructor Create(AServer: TATCclsTserDate);
  protected
    procedure _Set_File_(var Param1: _ATCclsTserFile);
    function Get_File_: _ATCclsTserFile;
    function Get_Flag(var index: Integer): Integer;
    procedure Set_flags(var Param1: PSafeArray);
    function Get_flags: PSafeArray;
    function Get_Serial: Integer;
    procedure Set_Summary(var Param1: ATTimSerDateSummary);
    function Get_Summary: ATTimSerDateSummary;
    function Get_Value(var index: Integer): Double;
    procedure Set_Values(var Param1: PSafeArray);
    function Get_Values: PSafeArray;
    procedure Set_Value(var index: Integer; var Param2: Double);
  public
    property DefaultInterface: _ATCclsTserDate read GetDefaultInterface;
  published
    property flags: PSafeArray read Get_flags write Set_flags;
    property Summary: ATTimSerDateSummary read Get_Summary write Set_Summary;
    property Values: PSafeArray read Get_Values write Set_Values;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoATCclsTserFile provides a Create and CreateRemote method to          
// create instances of the default interface _ATCclsTserFile exposed by              
// the CoClass ATCclsTserFile. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCclsTserFile = class
    class function Create: _ATCclsTserFile;
    class function CreateRemote(const MachineName: string): _ATCclsTserFile;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATCclsTserFile
// Help String      : 
// Default Interface: _ATCclsTserFile
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATCclsTserFileProperties= class;
{$ENDIF}
  TATCclsTserFile = class(TOleServer)
  private
    FIntf: _ATCclsTserFile;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATCclsTserFileProperties;
    function GetServerProperties: TATCclsTserFileProperties;
{$ENDIF}
    function GetDefaultInterface: _ATCclsTserFile;
  protected
    procedure InitServerData; override;
    procedure _Set_Monitor(const Param1: IDispatch);
    function Get_ErrorDescription: WideString;
    function Get_FileExtension: WideString;
    function Get_Label_: WideString;
    function Get_FileName: WideString;
    procedure Set_FileName(const Param1: WideString);
    function Get_FileUnit: Integer;
    function Get_Description: WideString;
    function Get_AvailableAttributes: _Collection;
    function Get_Data(var index: Integer): _ATCclsTserData;
    function Get_DataCount: Integer;
    function Get_DataCollection: _Collection;
    procedure Set_HelpFilename(const Param1: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATCclsTserFile);
    procedure Disconnect; override;
    procedure readData(var dataObject: _ATCclsTserData);
    procedure Clear;
    procedure refresh;
    function WriteDataHeader(var dataObject: _ATCclsTserData; var oldHeader: _ATTimSerDataHeader): WordBool;
    function AddTimSer(var t: _ATCclsTserData; var ExistAction: Integer): WordBool;
    function RemoveTimSer(var t: _ATCclsTserData): WordBool;
    function RewriteTimSer(var t: _ATCclsTserData): WordBool;
    function SaveAs(var FileName: WideString): WordBool;
    property DefaultInterface: _ATCclsTserFile read GetDefaultInterface;
    property Monitor: IDispatch write _Set_Monitor;
    property ErrorDescription: WideString read Get_ErrorDescription;
    property FileExtension: WideString read Get_FileExtension;
    property Label_: WideString read Get_Label_;
    property FileUnit: Integer read Get_FileUnit;
    property Description: WideString read Get_Description;
    property AvailableAttributes: _Collection read Get_AvailableAttributes;
    property Data[var index: Integer]: _ATCclsTserData read Get_Data;
    property DataCount: Integer read Get_DataCount;
    property DataCollection: _Collection read Get_DataCollection;
    property HelpFilename: WideString write Set_HelpFilename;
    property FileName: WideString read Get_FileName write Set_FileName;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATCclsTserFileProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATCclsTserFile
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATCclsTserFileProperties = class(TPersistent)
  private
    FServer:    TATCclsTserFile;
    function    GetDefaultInterface: _ATCclsTserFile;
    constructor Create(AServer: TATCclsTserFile);
  protected
    procedure _Set_Monitor(const Param1: IDispatch);
    function Get_ErrorDescription: WideString;
    function Get_FileExtension: WideString;
    function Get_Label_: WideString;
    function Get_FileName: WideString;
    procedure Set_FileName(const Param1: WideString);
    function Get_FileUnit: Integer;
    function Get_Description: WideString;
    function Get_AvailableAttributes: _Collection;
    function Get_Data(var index: Integer): _ATCclsTserData;
    function Get_DataCount: Integer;
    function Get_DataCollection: _Collection;
    procedure Set_HelpFilename(const Param1: WideString);
  public
    property DefaultInterface: _ATCclsTserFile read GetDefaultInterface;
  published
    property FileName: WideString read Get_FileName write Set_FileName;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoATCclsCriterion provides a Create and CreateRemote method to          
// create instances of the default interface _ATCclsCriterion exposed by              
// the CoClass ATCclsCriterion. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCclsCriterion = class
    class function Create: _ATCclsCriterion;
    class function CreateRemote(const MachineName: string): _ATCclsCriterion;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATCclsCriterion
// Help String      : 
// Default Interface: _ATCclsCriterion
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATCclsCriterionProperties= class;
{$ENDIF}
  TATCclsCriterion = class(TOleServer)
  private
    FIntf: _ATCclsCriterion;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATCclsCriterionProperties;
    function GetServerProperties: TATCclsCriterionProperties;
{$ENDIF}
    function GetDefaultInterface: _ATCclsCriterion;
  protected
    procedure InitServerData; override;
    function Get_Field: WideString;
    procedure Set_Field(var Param1: WideString);
    function Get_Operation: ATCCompare;
    procedure Set_Operation(var Param1: ATCCompare);
    function Get_Values: _Collection;
    procedure Set_Values(var Param1: _Collection);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATCclsCriterion);
    procedure Disconnect; override;
    function Match(var testValue: OleVariant): WordBool;
    function MatchField(var obj: OleVariant): WordBool;
    property DefaultInterface: _ATCclsCriterion read GetDefaultInterface;
    property Field: WideString read Get_Field write Set_Field;
    property Operation: ATCCompare read Get_Operation write Set_Operation;
    property Values: _Collection read Get_Values write Set_Values;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATCclsCriterionProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATCclsCriterion
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATCclsCriterionProperties = class(TPersistent)
  private
    FServer:    TATCclsCriterion;
    function    GetDefaultInterface: _ATCclsCriterion;
    constructor Create(AServer: TATCclsCriterion);
  protected
    function Get_Field: WideString;
    procedure Set_Field(var Param1: WideString);
    function Get_Operation: ATCCompare;
    procedure Set_Operation(var Param1: ATCCompare);
    function Get_Values: _Collection;
    procedure Set_Values(var Param1: _Collection);
  public
    property DefaultInterface: _ATCclsCriterion read GetDefaultInterface;
  published
    property Field: WideString read Get_Field write Set_Field;
    property Operation: ATCCompare read Get_Operation write Set_Operation;
    property Values: _Collection read Get_Values write Set_Values;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoATTimSerDataHeader provides a Create and CreateRemote method to          
// create instances of the default interface _ATTimSerDataHeader exposed by              
// the CoClass ATTimSerDataHeader. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATTimSerDataHeader = class
    class function Create: _ATTimSerDataHeader;
    class function CreateRemote(const MachineName: string): _ATTimSerDataHeader;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATTimSerDataHeader
// Help String      : 
// Default Interface: _ATTimSerDataHeader
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATTimSerDataHeaderProperties= class;
{$ENDIF}
  TATTimSerDataHeader = class(TOleServer)
  private
    FIntf: _ATTimSerDataHeader;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATTimSerDataHeaderProperties;
    function GetServerProperties: TATTimSerDataHeaderProperties;
{$ENDIF}
    function GetDefaultInterface: _ATTimSerDataHeader;
  protected
    procedure InitServerData; override;
    function Get_Desc: WideString;
    procedure Set_Desc(var Param1: WideString);
    function Get_id: Double;
    procedure Set_id(var Param1: Double);
    function Get_Sen: WideString;
    procedure Set_Sen(var Param1: WideString);
    function Get_Loc: WideString;
    procedure Set_Loc(var Param1: WideString);
    function Get_Con: WideString;
    procedure Set_Con(var Param1: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATTimSerDataHeader);
    procedure Disconnect; override;
    function Copy: _ATTimSerDataHeader;
    function Compare(var nTsHeader: _ATTimSerDataHeader): WordBool;
    property DefaultInterface: _ATTimSerDataHeader read GetDefaultInterface;
    property Desc: WideString read Get_Desc write Set_Desc;
    property id: Double read Get_id write Set_id;
    property Sen: WideString read Get_Sen write Set_Sen;
    property Loc: WideString read Get_Loc write Set_Loc;
    property Con: WideString read Get_Con write Set_Con;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATTimSerDataHeaderProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATTimSerDataHeader
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATTimSerDataHeaderProperties = class(TPersistent)
  private
    FServer:    TATTimSerDataHeader;
    function    GetDefaultInterface: _ATTimSerDataHeader;
    constructor Create(AServer: TATTimSerDataHeader);
  protected
    function Get_Desc: WideString;
    procedure Set_Desc(var Param1: WideString);
    function Get_id: Double;
    procedure Set_id(var Param1: Double);
    function Get_Sen: WideString;
    procedure Set_Sen(var Param1: WideString);
    function Get_Loc: WideString;
    procedure Set_Loc(var Param1: WideString);
    function Get_Con: WideString;
    procedure Set_Con(var Param1: WideString);
  public
    property DefaultInterface: _ATTimSerDataHeader read GetDefaultInterface;
  published
    property Desc: WideString read Get_Desc write Set_Desc;
    property id: Double read Get_id write Set_id;
    property Sen: WideString read Get_Sen write Set_Sen;
    property Loc: WideString read Get_Loc write Set_Loc;
    property Con: WideString read Get_Con write Set_Con;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoATCclsParm provides a Create and CreateRemote method to          
// create instances of the default interface _ATCclsParm exposed by              
// the CoClass ATCclsParm. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCclsParm = class
    class function Create: _ATCclsParm;
    class function CreateRemote(const MachineName: string): _ATCclsParm;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATCclsParm
// Help String      : 
// Default Interface: _ATCclsParm
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATCclsParmProperties= class;
{$ENDIF}
  TATCclsParm = class(TOleServer)
  private
    FIntf: _ATCclsParm;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATCclsParmProperties;
    function GetServerProperties: TATCclsParmProperties;
{$ENDIF}
    function GetDefaultInterface: _ATCclsParm;
  protected
    procedure InitServerData; override;
    function Get_Value: WideString;
    procedure Set_Value(var Param1: WideString);
    function Get_Def: _ATCclsParmDef;
    procedure _Set_Def(var Param1: _ATCclsParmDef);
    function Get_Parent: IDispatch;
    procedure _Set_Parent(var Param1: IDispatch);
    function Get_Name: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATCclsParm);
    procedure Disconnect; override;
    property DefaultInterface: _ATCclsParm read GetDefaultInterface;
    property Def: _ATCclsParmDef read Get_Def write _Set_Def;
    property Parent: IDispatch read Get_Parent write _Set_Parent;
    property Name: WideString read Get_Name;
    property Value: WideString read Get_Value write Set_Value;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATCclsParmProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATCclsParm
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATCclsParmProperties = class(TPersistent)
  private
    FServer:    TATCclsParm;
    function    GetDefaultInterface: _ATCclsParm;
    constructor Create(AServer: TATCclsParm);
  protected
    function Get_Value: WideString;
    procedure Set_Value(var Param1: WideString);
    function Get_Def: _ATCclsParmDef;
    procedure _Set_Def(var Param1: _ATCclsParmDef);
    function Get_Parent: IDispatch;
    procedure _Set_Parent(var Param1: IDispatch);
    function Get_Name: WideString;
  public
    property DefaultInterface: _ATCclsParm read GetDefaultInterface;
  published
    property Value: WideString read Get_Value write Set_Value;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoATCclsParmDef provides a Create and CreateRemote method to          
// create instances of the default interface _ATCclsParmDef exposed by              
// the CoClass ATCclsParmDef. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCclsParmDef = class
    class function Create: _ATCclsParmDef;
    class function CreateRemote(const MachineName: string): _ATCclsParmDef;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATCclsParmDef
// Help String      : 
// Default Interface: _ATCclsParmDef
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATCclsParmDefProperties= class;
{$ENDIF}
  TATCclsParmDef = class(TOleServer)
  private
    FIntf: _ATCclsParmDef;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATCclsParmDefProperties;
    function GetServerProperties: TATCclsParmDefProperties;
{$ENDIF}
    function GetDefaultInterface: _ATCclsParmDef;
  protected
    procedure InitServerData; override;
    function Get_Name: WideString;
    procedure Set_Name(var Param1: WideString);
    function Get_Typ: Integer;
    procedure Set_Typ(var Param1: Integer);
    function Get_Min: Double;
    procedure Set_Min(var Param1: Double);
    function Get_Max: Double;
    procedure Set_Max(var Param1: Double);
    function Get_Default: WideString;
    procedure Set_Default(var Param1: WideString);
    function Get_SoftMin: Double;
    procedure Set_SoftMin(var Param1: Double);
    function Get_SoftMax: Double;
    procedure Set_SoftMax(var Param1: Double);
    function Get_Define: WideString;
    procedure Set_Define(var Param1: WideString);
    function Get_Parent: IDispatch;
    procedure _Set_Parent(var Param1: IDispatch);
    function Get_Other: WideString;
    procedure Set_Other(var Param1: WideString);
    function Get_StartCol: Integer;
    procedure Set_StartCol(var Param1: Integer);
    function Get_Length: Integer;
    procedure Set_Length(var Param1: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATCclsParmDef);
    procedure Disconnect; override;
    property DefaultInterface: _ATCclsParmDef read GetDefaultInterface;
    property Parent: IDispatch read Get_Parent write _Set_Parent;
    property Name: WideString read Get_Name write Set_Name;
    property Typ: Integer read Get_Typ write Set_Typ;
    property Min: Double read Get_Min write Set_Min;
    property Max: Double read Get_Max write Set_Max;
    property Default: WideString read Get_Default write Set_Default;
    property SoftMin: Double read Get_SoftMin write Set_SoftMin;
    property SoftMax: Double read Get_SoftMax write Set_SoftMax;
    property Define: WideString read Get_Define write Set_Define;
    property Other: WideString read Get_Other write Set_Other;
    property StartCol: Integer read Get_StartCol write Set_StartCol;
    property Length: Integer read Get_Length write Set_Length;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATCclsParmDefProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATCclsParmDef
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATCclsParmDefProperties = class(TPersistent)
  private
    FServer:    TATCclsParmDef;
    function    GetDefaultInterface: _ATCclsParmDef;
    constructor Create(AServer: TATCclsParmDef);
  protected
    function Get_Name: WideString;
    procedure Set_Name(var Param1: WideString);
    function Get_Typ: Integer;
    procedure Set_Typ(var Param1: Integer);
    function Get_Min: Double;
    procedure Set_Min(var Param1: Double);
    function Get_Max: Double;
    procedure Set_Max(var Param1: Double);
    function Get_Default: WideString;
    procedure Set_Default(var Param1: WideString);
    function Get_SoftMin: Double;
    procedure Set_SoftMin(var Param1: Double);
    function Get_SoftMax: Double;
    procedure Set_SoftMax(var Param1: Double);
    function Get_Define: WideString;
    procedure Set_Define(var Param1: WideString);
    function Get_Parent: IDispatch;
    procedure _Set_Parent(var Param1: IDispatch);
    function Get_Other: WideString;
    procedure Set_Other(var Param1: WideString);
    function Get_StartCol: Integer;
    procedure Set_StartCol(var Param1: Integer);
    function Get_Length: Integer;
    procedure Set_Length(var Param1: Integer);
  public
    property DefaultInterface: _ATCclsParmDef read GetDefaultInterface;
  published
    property Name: WideString read Get_Name write Set_Name;
    property Typ: Integer read Get_Typ write Set_Typ;
    property Min: Double read Get_Min write Set_Min;
    property Max: Double read Get_Max write Set_Max;
    property Default: WideString read Get_Default write Set_Default;
    property SoftMin: Double read Get_SoftMin write Set_SoftMin;
    property SoftMax: Double read Get_SoftMax write Set_SoftMax;
    property Define: WideString read Get_Define write Set_Define;
    property Other: WideString read Get_Other write Set_Other;
    property StartCol: Integer read Get_StartCol write Set_StartCol;
    property Length: Integer read Get_Length write Set_Length;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoATCclsAttributeDefinition provides a Create and CreateRemote method to          
// create instances of the default interface _ATCclsAttributeDefinition exposed by              
// the CoClass ATCclsAttributeDefinition. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCclsAttributeDefinition = class
    class function Create: _ATCclsAttributeDefinition;
    class function CreateRemote(const MachineName: string): _ATCclsAttributeDefinition;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATCclsAttributeDefinition
// Help String      : 
// Default Interface: _ATCclsAttributeDefinition
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATCclsAttributeDefinitionProperties= class;
{$ENDIF}
  TATCclsAttributeDefinition = class(TOleServer)
  private
    FIntf: _ATCclsAttributeDefinition;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATCclsAttributeDefinitionProperties;
    function GetServerProperties: TATCclsAttributeDefinitionProperties;
{$ENDIF}
    function GetDefaultInterface: _ATCclsAttributeDefinition;
  protected
    procedure InitServerData; override;
    function Get_Name: WideString;
    procedure Set_Name(var Param1: WideString);
    function Get_Description: WideString;
    procedure Set_Description(var Param1: WideString);
    function Get_DataType: ATCoDataType;
    procedure Set_DataType(var Param1: ATCoDataType);
    function Get_Min: Single;
    procedure Set_Min(var Param1: Single);
    function Get_Max: Single;
    procedure Set_Max(var Param1: Single);
    function Get_ValidValues: WideString;
    procedure Set_ValidValues(var Param1: WideString);
    function Get_Default: Single;
    procedure Set_Default(var Param1: Single);
    function Get_Editable: WordBool;
    procedure Set_Editable(var Param1: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATCclsAttributeDefinition);
    procedure Disconnect; override;
    function Dump: WideString;
    property DefaultInterface: _ATCclsAttributeDefinition read GetDefaultInterface;
    property Name: WideString read Get_Name write Set_Name;
    property Description: WideString read Get_Description write Set_Description;
    property DataType: ATCoDataType read Get_DataType write Set_DataType;
    property Min: Single read Get_Min write Set_Min;
    property Max: Single read Get_Max write Set_Max;
    property ValidValues: WideString read Get_ValidValues write Set_ValidValues;
    property Default: Single read Get_Default write Set_Default;
    property Editable: WordBool read Get_Editable write Set_Editable;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATCclsAttributeDefinitionProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATCclsAttributeDefinition
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATCclsAttributeDefinitionProperties = class(TPersistent)
  private
    FServer:    TATCclsAttributeDefinition;
    function    GetDefaultInterface: _ATCclsAttributeDefinition;
    constructor Create(AServer: TATCclsAttributeDefinition);
  protected
    function Get_Name: WideString;
    procedure Set_Name(var Param1: WideString);
    function Get_Description: WideString;
    procedure Set_Description(var Param1: WideString);
    function Get_DataType: ATCoDataType;
    procedure Set_DataType(var Param1: ATCoDataType);
    function Get_Min: Single;
    procedure Set_Min(var Param1: Single);
    function Get_Max: Single;
    procedure Set_Max(var Param1: Single);
    function Get_ValidValues: WideString;
    procedure Set_ValidValues(var Param1: WideString);
    function Get_Default: Single;
    procedure Set_Default(var Param1: Single);
    function Get_Editable: WordBool;
    procedure Set_Editable(var Param1: WordBool);
  public
    property DefaultInterface: _ATCclsAttributeDefinition read GetDefaultInterface;
  published
    property Name: WideString read Get_Name write Set_Name;
    property Description: WideString read Get_Description write Set_Description;
    property DataType: ATCoDataType read Get_DataType write Set_DataType;
    property Min: Single read Get_Min write Set_Min;
    property Max: Single read Get_Max write Set_Max;
    property ValidValues: WideString read Get_ValidValues write Set_ValidValues;
    property Default: Single read Get_Default write Set_Default;
    property Editable: WordBool read Get_Editable write Set_Editable;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoCollString provides a Create and CreateRemote method to          
// create instances of the default interface _CollString exposed by              
// the CoClass CollString. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCollString = class
    class function Create: _CollString;
    class function CreateRemote(const MachineName: string): _CollString;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TCollString
// Help String      : 
// Default Interface: _CollString
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TCollStringProperties= class;
{$ENDIF}
  TCollString = class(TOleServer)
  private
    FIntf: _CollString;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TCollStringProperties;
    function GetServerProperties: TCollStringProperties;
{$ENDIF}
    function GetDefaultInterface: _CollString;
  protected
    procedure InitServerData; override;
    function Get_coll: _Collection;
    procedure _Set_coll(var Param1: _Collection);
    function Get_Keys: _Collection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _CollString);
    procedure Disconnect; override;
    function Add(const newValue: WideString; const key: WideString): WideString;
    procedure Clear;
    function Count: Integer;
    procedure Remove(key: OleVariant);
    function Item(key: OleVariant): WideString;
    function NewEnum: IUnknown;
    property DefaultInterface: _CollString read GetDefaultInterface;
    property coll: _Collection read Get_coll write _Set_coll;
    property Keys: _Collection read Get_Keys;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TCollStringProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TCollString
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TCollStringProperties = class(TPersistent)
  private
    FServer:    TCollString;
    function    GetDefaultInterface: _CollString;
    constructor Create(AServer: TCollString);
  protected
    function Get_coll: _Collection;
    procedure _Set_coll(var Param1: _Collection);
    function Get_Keys: _Collection;
  public
    property DefaultInterface: _CollString read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoCollTserData provides a Create and CreateRemote method to          
// create instances of the default interface _CollTserData exposed by              
// the CoClass CollTserData. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCollTserData = class
    class function Create: _CollTserData;
    class function CreateRemote(const MachineName: string): _CollTserData;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TCollTserData
// Help String      : 
// Default Interface: _CollTserData
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TCollTserDataProperties= class;
{$ENDIF}
  TCollTserData = class(TOleServer)
  private
    FIntf: _CollTserData;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TCollTserDataProperties;
    function GetServerProperties: TCollTserDataProperties;
{$ENDIF}
    function GetDefaultInterface: _CollTserData;
  protected
    procedure InitServerData; override;
    function Get_coll: _Collection;
    procedure _Set_coll(var Param1: _Collection);
    function Get_Keys: _Collection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _CollTserData);
    procedure Disconnect; override;
    function Add(const newValue: _ATCclsTserData; const key: WideString): WideString;
    procedure Clear;
    function Count: Integer;
    procedure Remove(key: OleVariant);
    function Item(key: OleVariant): _ATCclsTserData;
    function NewEnum: IUnknown;
    property DefaultInterface: _CollTserData read GetDefaultInterface;
    property coll: _Collection read Get_coll write _Set_coll;
    property Keys: _Collection read Get_Keys;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TCollTserDataProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TCollTserData
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TCollTserDataProperties = class(TPersistent)
  private
    FServer:    TCollTserData;
    function    GetDefaultInterface: _CollTserData;
    constructor Create(AServer: TCollTserData);
  protected
    function Get_coll: _Collection;
    procedure _Set_coll(var Param1: _Collection);
    function Get_Keys: _Collection;
  public
    property DefaultInterface: _CollTserData read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoATCclsAnalysis provides a Create and CreateRemote method to          
// create instances of the default interface _ATCclsAnalysis exposed by              
// the CoClass ATCclsAnalysis. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCclsAnalysis = class
    class function Create: _ATCclsAnalysis;
    class function CreateRemote(const MachineName: string): _ATCclsAnalysis;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TATCclsAnalysis
// Help String      : 
// Default Interface: _ATCclsAnalysis
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TATCclsAnalysisProperties= class;
{$ENDIF}
  TATCclsAnalysis = class(TOleServer)
  private
    FIntf: _ATCclsAnalysis;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TATCclsAnalysisProperties;
    function GetServerProperties: TATCclsAnalysisProperties;
{$ENDIF}
    function GetDefaultInterface: _ATCclsAnalysis;
  protected
    procedure InitServerData; override;
    procedure _Set_Monitor(const Param1: IDispatch);
    function Get_ErrorDescription: WideString;
    function Get_Description: WideString;
    procedure _Set_DataCollection(var Param1: _Collection);
    function Get_Specification: WideString;
    procedure Set_Specification(var Param1: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: _ATCclsAnalysis);
    procedure Disconnect; override;
    procedure Go;
    function EditSpecification: WordBool;
    property DefaultInterface: _ATCclsAnalysis read GetDefaultInterface;
    property Monitor: IDispatch write _Set_Monitor;
    property ErrorDescription: WideString read Get_ErrorDescription;
    property Description: WideString read Get_Description;
    property DataCollection: _Collection write _Set_DataCollection;
    property Specification: WideString read Get_Specification write Set_Specification;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TATCclsAnalysisProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TATCclsAnalysis
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TATCclsAnalysisProperties = class(TPersistent)
  private
    FServer:    TATCclsAnalysis;
    function    GetDefaultInterface: _ATCclsAnalysis;
    constructor Create(AServer: TATCclsAnalysis);
  protected
    procedure _Set_Monitor(const Param1: IDispatch);
    function Get_ErrorDescription: WideString;
    function Get_Description: WideString;
    procedure _Set_DataCollection(var Param1: _Collection);
    function Get_Specification: WideString;
    procedure Set_Specification(var Param1: WideString);
  public
    property DefaultInterface: _ATCclsAnalysis read GetDefaultInterface;
  published
    property Specification: WideString read Get_Specification write Set_Specification;
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'Standard';

  dtlOcxPage = 'Standard';

implementation

uses ComObj;

class function CoATCDataTypes.Create: _ATCDataTypes;
begin
  Result := CreateComObject(CLASS_ATCDataTypes) as _ATCDataTypes;
end;

class function CoATCDataTypes.CreateRemote(const MachineName: string): _ATCDataTypes;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCDataTypes) as _ATCDataTypes;
end;

procedure TATCDataTypes.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{43D49468-80D7-11D3-913A-00A024C11E04}';
    IntfIID:   '{43D49467-80D7-11D3-913A-00A024C11E04}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATCDataTypes.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATCDataTypes;
  end;
end;

procedure TATCDataTypes.ConnectTo(svrIntf: _ATCDataTypes);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATCDataTypes.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATCDataTypes.GetDefaultInterface: _ATCDataTypes;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATCDataTypes.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATCDataTypesProperties.Create(Self);
{$ENDIF}
end;

destructor TATCDataTypes.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATCDataTypes.GetServerProperties: TATCDataTypesProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATCDataTypesProperties.Create(AServer: TATCDataTypes);
begin
  inherited Create;
  FServer := AServer;
end;

function TATCDataTypesProperties.GetDefaultInterface: _ATCDataTypes;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoATCPlugInTypes.Create: _ATCPlugInTypes;
begin
  Result := CreateComObject(CLASS_ATCPlugInTypes) as _ATCPlugInTypes;
end;

class function CoATCPlugInTypes.CreateRemote(const MachineName: string): _ATCPlugInTypes;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCPlugInTypes) as _ATCPlugInTypes;
end;

procedure TATCPlugInTypes.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{335A151C-3323-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{335A151B-3323-11D4-9D23-00A0C9768F70}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATCPlugInTypes.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATCPlugInTypes;
  end;
end;

procedure TATCPlugInTypes.ConnectTo(svrIntf: _ATCPlugInTypes);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATCPlugInTypes.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATCPlugInTypes.GetDefaultInterface: _ATCPlugInTypes;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATCPlugInTypes.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATCPlugInTypesProperties.Create(Self);
{$ENDIF}
end;

destructor TATCPlugInTypes.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATCPlugInTypes.GetServerProperties: TATCPlugInTypesProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATCPlugInTypesProperties.Create(AServer: TATCPlugInTypes);
begin
  inherited Create;
  FServer := AServer;
end;

function TATCPlugInTypesProperties.GetDefaultInterface: _ATCPlugInTypes;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoATCPlugInManager.Create: _ATCPlugInManager;
begin
  Result := CreateComObject(CLASS_ATCPlugInManager) as _ATCPlugInManager;
end;

class function CoATCPlugInManager.CreateRemote(const MachineName: string): _ATCPlugInManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCPlugInManager) as _ATCPlugInManager;
end;

procedure TATCPlugInManager.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{335A151F-3323-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{335A151E-3323-11D4-9D23-00A0C9768F70}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATCPlugInManager.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATCPlugInManager;
  end;
end;

procedure TATCPlugInManager.ConnectTo(svrIntf: _ATCPlugInManager);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATCPlugInManager.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATCPlugInManager.GetDefaultInterface: _ATCPlugInManager;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATCPlugInManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATCPlugInManagerProperties.Create(Self);
{$ENDIF}
end;

destructor TATCPlugInManager.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATCPlugInManager.GetServerProperties: TATCPlugInManagerProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TATCPlugInManager.Get_ErrorDescription: WideString;
begin
    Result := DefaultInterface.ErrorDescription;
end;

function TATCPlugInManager.Get_Avail: _Collection;
begin
    Result := DefaultInterface.Avail;
end;

function TATCPlugInManager.Get_Active: _Collection;
begin
    Result := DefaultInterface.Active;
end;

function TATCPlugInManager.Get_CurrentActive: ATCPlugIn;
begin
    Result := DefaultInterface.CurrentActive;
end;

procedure TATCPlugInManager.Set_CurrentActiveIndex(Param1: Integer);
begin
  DefaultInterface.Set_CurrentActiveIndex(Param1);
end;

function TATCPlugInManager.Get_CurrentActiveIndex: Integer;
begin
    Result := DefaultInterface.CurrentActiveIndex;
end;

procedure TATCPlugInManager.Clear;
begin
  DefaultInterface.Clear;
end;

function TATCPlugInManager.AvailIndexByName(var PluginName: WideString): Integer;
begin
  Result := DefaultInterface.AvailIndexByName(PluginName);
end;

function TATCPlugInManager.ActiveIndexByName(var PluginName: WideString): Integer;
begin
  Result := DefaultInterface.ActiveIndexByName(PluginName);
end;

procedure TATCPlugInManager.Create1(var AvailIndex: Integer);
begin
  DefaultInterface.Create(AvailIndex);
end;

procedure TATCPlugInManager.Delete(var ActiveIndex: Integer);
begin
  DefaultInterface.Delete(ActiveIndex);
end;

function TATCPlugInManager.QueryType(var PluginName: WideString): WideString;
begin
  Result := DefaultInterface.QueryType(PluginName);
end;

function TATCPlugInManager.Load(var PluginName: WideString): WordBool;
begin
  Result := DefaultInterface.Load(PluginName);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATCPlugInManagerProperties.Create(AServer: TATCPlugInManager);
begin
  inherited Create;
  FServer := AServer;
end;

function TATCPlugInManagerProperties.GetDefaultInterface: _ATCPlugInManager;
begin
  Result := FServer.DefaultInterface;
end;

function TATCPlugInManagerProperties.Get_ErrorDescription: WideString;
begin
    Result := DefaultInterface.ErrorDescription;
end;

function TATCPlugInManagerProperties.Get_Avail: _Collection;
begin
    Result := DefaultInterface.Avail;
end;

function TATCPlugInManagerProperties.Get_Active: _Collection;
begin
    Result := DefaultInterface.Active;
end;

function TATCPlugInManagerProperties.Get_CurrentActive: ATCPlugIn;
begin
    Result := DefaultInterface.CurrentActive;
end;

procedure TATCPlugInManagerProperties.Set_CurrentActiveIndex(Param1: Integer);
begin
  DefaultInterface.Set_CurrentActiveIndex(Param1);
end;

function TATCPlugInManagerProperties.Get_CurrentActiveIndex: Integer;
begin
    Result := DefaultInterface.CurrentActiveIndex;
end;

{$ENDIF}

class function CoATCclsCatalog.Create: _ATCclsCatalog;
begin
  Result := CreateComObject(CLASS_ATCclsCatalog) as _ATCclsCatalog;
end;

class function CoATCclsCatalog.CreateRemote(const MachineName: string): _ATCclsCatalog;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCclsCatalog) as _ATCclsCatalog;
end;

procedure TATCclsCatalog.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{335A1521-3323-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{335A1520-3323-11D4-9D23-00A0C9768F70}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATCclsCatalog.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATCclsCatalog;
  end;
end;

procedure TATCclsCatalog.ConnectTo(svrIntf: _ATCclsCatalog);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATCclsCatalog.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATCclsCatalog.GetDefaultInterface: _ATCclsCatalog;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATCclsCatalog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATCclsCatalogProperties.Create(Self);
{$ENDIF}
end;

destructor TATCclsCatalog.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATCclsCatalog.GetServerProperties: TATCclsCatalogProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TATCclsCatalog.Get_Plugins: _Collection;
begin
    Result := DefaultInterface.Plugins;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATCclsCatalogProperties.Create(AServer: TATCclsCatalog);
begin
  inherited Create;
  FServer := AServer;
end;

function TATCclsCatalogProperties.GetDefaultInterface: _ATCclsCatalog;
begin
  Result := FServer.DefaultInterface;
end;

function TATCclsCatalogProperties.Get_Plugins: _Collection;
begin
    Result := DefaultInterface.Plugins;
end;

{$ENDIF}

class function CoATCclsTserData.Create: _ATCclsTserData;
begin
  Result := CreateComObject(CLASS_ATCclsTserData) as _ATCclsTserData;
end;

class function CoATCclsTserData.CreateRemote(const MachineName: string): _ATCclsTserData;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCclsTserData) as _ATCclsTserData;
end;

procedure TATCclsTserData.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{335A1529-3323-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{014F3C6B-314F-4EFC-93FE-320FF0D61056}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATCclsTserData.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATCclsTserData;
  end;
end;

procedure TATCclsTserData.ConnectTo(svrIntf: _ATCclsTserData);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATCclsTserData.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATCclsTserData.GetDefaultInterface: _ATCclsTserData;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATCclsTserData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATCclsTserDataProperties.Create(Self);
{$ENDIF}
end;

destructor TATCclsTserData.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATCclsTserData.GetServerProperties: TATCclsTserDataProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TATCclsTserData.Get_Attrib(var AttrName: WideString; var AttrDefault: WideString): WideString;
begin
    Result := DefaultInterface.Attrib[AttrName, AttrDefault];
end;

function TATCclsTserData.Get_AttribNumeric(var AttrName: WideString; var AttrDefault: Integer): Double;
begin
    Result := DefaultInterface.AttribNumeric[AttrName, AttrDefault];
end;

procedure TATCclsTserData._Set_Attribs(var Param1: _Collection);
  { Warning: The property Attribs has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Attribs := Param1;
end;

function TATCclsTserData.Get_Attribs: _Collection;
begin
    Result := DefaultInterface.Attribs;
end;

procedure TATCclsTserData._Set_Dates(var Param1: _ATCclsTserDate);
  { Warning: The property Dates has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Dates := Param1;
end;

function TATCclsTserData.Get_Dates: _ATCclsTserDate;
begin
    Result := DefaultInterface.Dates;
end;

procedure TATCclsTserData.Set_ErrorDescription(var Param1: WideString);
  { Warning: The property ErrorDescription has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ErrorDescription := Param1;
end;

function TATCclsTserData.Get_ErrorDescription: WideString;
begin
    Result := DefaultInterface.ErrorDescription;
end;

procedure TATCclsTserData._Set_File_(var Param1: _ATCclsTserFile);
  { Warning: The property File_ has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.File_ := Param1;
end;

function TATCclsTserData.Get_File_: _ATCclsTserFile;
begin
    Result := DefaultInterface.File_;
end;

function TATCclsTserData.Get_Flag(var index: Integer): Integer;
begin
    Result := DefaultInterface.Flag[index];
end;

procedure TATCclsTserData.Set_flags(var Param1: PSafeArray);
begin
  DefaultInterface.Set_flags(Param1);
end;

function TATCclsTserData.Get_flags: PSafeArray;
begin
    Result := DefaultInterface.flags;
end;

procedure TATCclsTserData._Set_Header(var Param1: _ATTimSerDataHeader);
  { Warning: The property Header has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Header := Param1;
end;

function TATCclsTserData.Get_Header: _ATTimSerDataHeader;
begin
    Result := DefaultInterface.Header;
end;

function TATCclsTserData.Get_Serial: Integer;
begin
    Result := DefaultInterface.Serial;
end;

procedure TATCclsTserData.Set_Dtran(var Param1: Integer);
begin
  DefaultInterface.Set_Dtran(Param1);
end;

function TATCclsTserData.Get_Dtran: Integer;
begin
    Result := DefaultInterface.Dtran;
end;

procedure TATCclsTserData.Set_Min(var Param1: Single);
begin
  DefaultInterface.Set_Min(Param1);
end;

function TATCclsTserData.Get_Min: Single;
begin
    Result := DefaultInterface.Min;
end;

procedure TATCclsTserData.Set_Max(var Param1: Single);
begin
  DefaultInterface.Set_Max(Param1);
end;

function TATCclsTserData.Get_Max: Single;
begin
    Result := DefaultInterface.Max;
end;

function TATCclsTserData.Get_Value(var index: Integer): Single;
begin
    Result := DefaultInterface.Value[index];
end;

procedure TATCclsTserData.Set_Values(var Param1: PSafeArray);
begin
  DefaultInterface.Set_Values(Param1);
end;

function TATCclsTserData.Get_Values: PSafeArray;
begin
    Result := DefaultInterface.Values;
end;

procedure TATCclsTserData.Set_Value(var index: Integer; const Param2: Single);
begin
  DefaultInterface.Value[index] := Param2;
end;

function TATCclsTserData.Get_AttribNames: _Collection;
begin
    Result := DefaultInterface.AttribNames;
end;

procedure TATCclsTserData.Set_Mean(var Param1: Single);
begin
  DefaultInterface.Set_Mean(Param1);
end;

function TATCclsTserData.Get_Mean: Single;
begin
    Result := DefaultInterface.Mean;
end;

procedure TATCclsTserData.Set_Sum(var Param1: Single);
begin
  DefaultInterface.Set_Sum(Param1);
end;

function TATCclsTserData.Get_Sum: Single;
begin
    Result := DefaultInterface.Sum;
end;

procedure TATCclsTserData.Set_Variance(var Param1: Single);
begin
  DefaultInterface.Set_Variance(Param1);
end;

function TATCclsTserData.Get_Variance: Single;
begin
    Result := DefaultInterface.Variance;
end;

procedure TATCclsTserData.Set_StdDeviation(var Param1: Single);
begin
  DefaultInterface.Set_StdDeviation(Param1);
end;

function TATCclsTserData.Get_StdDeviation: Single;
begin
    Result := DefaultInterface.StdDeviation;
end;

procedure TATCclsTserData.Set_GeometricMean(var Param1: Single);
begin
  DefaultInterface.Set_GeometricMean(Param1);
end;

function TATCclsTserData.Get_GeometricMean: Single;
begin
    Result := DefaultInterface.GeometricMean;
end;

procedure TATCclsTserData.AttribSet(var AttrName: WideString; var AttrValue: WideString; 
                                    var AttrDef: _ATCclsAttributeDefinition);
begin
  DefaultInterface.AttribSet(AttrName, AttrValue, AttrDef);
end;

procedure TATCclsTserData.calcSummary;
begin
  DefaultInterface.calcSummary;
end;

function TATCclsTserData.SubSetByDate(var s: Double; var e: Double): _ATCclsTserData;
begin
  Result := DefaultInterface.SubSetByDate(s, e);
end;

function TATCclsTserData.doMath(var oper: ATCOperatorType; var ts2: _ATCclsTserData; var x: Double; 
                                var X2: Double): _ATCclsTserData;
begin
  Result := DefaultInterface.doMath(oper, ts2, x, X2);
end;

function TATCclsTserData.Copy: _ATCclsTserData;
begin
  Result := DefaultInterface.Copy;
end;

function TATCclsTserData.doDateCheck(var d1: _ATCclsTserDate; var d2: _ATCclsTserDate): WordBool;
begin
  Result := DefaultInterface.doDateCheck(d1, d2);
end;

function TATCclsTserData.Interpolate(var ds: _ATCclsTserDate): _ATCclsTserData;
begin
  Result := DefaultInterface.Interpolate(ds);
end;

function TATCclsTserData.Aggregate(var ds: _ATCclsTserDate; var Tran: ATCTran): _ATCclsTserData;
begin
  Result := DefaultInterface.Aggregate(ds, Tran);
end;

function TATCclsTserData.FillValues(ts: Integer; Tu: ATCTimeUnit; FillVal: Single; 
                                    MissingVal: Single; var AccumVal: Single): _ATCclsTserData;
begin
  Result := DefaultInterface.FillValues(ts, Tu, FillVal, MissingVal, AccumVal);
end;

function TATCclsTserData.Compare(var nTs: _ATCclsTserData): WordBool;
begin
  Result := DefaultInterface.Compare(nTs);
end;

function TATCclsTserData.doTable(var rangeTop: PSafeArray; var newValue: PSafeArray; 
                                 var Interpolate: WordBool): _ATCclsTserData;
begin
  Result := DefaultInterface.doTable(rangeTop, newValue, Interpolate);
end;

function TATCclsTserData.FillMissing(var FillMethod: WideString; var MaxNMis: Integer; 
                                     var MVal: Single): _ATCclsTserData;
begin
  Result := DefaultInterface.FillMissing(FillMethod, MaxNMis, MVal);
end;

procedure TATCclsTserData.Dump(var l: Integer);
begin
  DefaultInterface.Dump(l);
end;

function TATCclsTserData.AddRemoveDates(var sjdate: Double; var ejdate: Double; 
                                        var NewValueOption: Integer; var newValue: Single): _ATCclsTserData;
begin
  Result := DefaultInterface.AddRemoveDates(sjdate, ejdate, NewValueOption, newValue);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATCclsTserDataProperties.Create(AServer: TATCclsTserData);
begin
  inherited Create;
  FServer := AServer;
end;

function TATCclsTserDataProperties.GetDefaultInterface: _ATCclsTserData;
begin
  Result := FServer.DefaultInterface;
end;

function TATCclsTserDataProperties.Get_Attrib(var AttrName: WideString; var AttrDefault: WideString): WideString;
begin
    Result := DefaultInterface.Attrib[AttrName, AttrDefault];
end;

function TATCclsTserDataProperties.Get_AttribNumeric(var AttrName: WideString; 
                                                     var AttrDefault: Integer): Double;
begin
    Result := DefaultInterface.AttribNumeric[AttrName, AttrDefault];
end;

procedure TATCclsTserDataProperties._Set_Attribs(var Param1: _Collection);
  { Warning: The property Attribs has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Attribs := Param1;
end;

function TATCclsTserDataProperties.Get_Attribs: _Collection;
begin
    Result := DefaultInterface.Attribs;
end;

procedure TATCclsTserDataProperties._Set_Dates(var Param1: _ATCclsTserDate);
  { Warning: The property Dates has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Dates := Param1;
end;

function TATCclsTserDataProperties.Get_Dates: _ATCclsTserDate;
begin
    Result := DefaultInterface.Dates;
end;

procedure TATCclsTserDataProperties.Set_ErrorDescription(var Param1: WideString);
  { Warning: The property ErrorDescription has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ErrorDescription := Param1;
end;

function TATCclsTserDataProperties.Get_ErrorDescription: WideString;
begin
    Result := DefaultInterface.ErrorDescription;
end;

procedure TATCclsTserDataProperties._Set_File_(var Param1: _ATCclsTserFile);
  { Warning: The property File_ has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.File_ := Param1;
end;

function TATCclsTserDataProperties.Get_File_: _ATCclsTserFile;
begin
    Result := DefaultInterface.File_;
end;

function TATCclsTserDataProperties.Get_Flag(var index: Integer): Integer;
begin
    Result := DefaultInterface.Flag[index];
end;

procedure TATCclsTserDataProperties.Set_flags(var Param1: PSafeArray);
begin
  DefaultInterface.Set_flags(Param1);
end;

function TATCclsTserDataProperties.Get_flags: PSafeArray;
begin
    Result := DefaultInterface.flags;
end;

procedure TATCclsTserDataProperties._Set_Header(var Param1: _ATTimSerDataHeader);
  { Warning: The property Header has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Header := Param1;
end;

function TATCclsTserDataProperties.Get_Header: _ATTimSerDataHeader;
begin
    Result := DefaultInterface.Header;
end;

function TATCclsTserDataProperties.Get_Serial: Integer;
begin
    Result := DefaultInterface.Serial;
end;

procedure TATCclsTserDataProperties.Set_Dtran(var Param1: Integer);
begin
  DefaultInterface.Set_Dtran(Param1);
end;

function TATCclsTserDataProperties.Get_Dtran: Integer;
begin
    Result := DefaultInterface.Dtran;
end;

procedure TATCclsTserDataProperties.Set_Min(var Param1: Single);
begin
  DefaultInterface.Set_Min(Param1);
end;

function TATCclsTserDataProperties.Get_Min: Single;
begin
    Result := DefaultInterface.Min;
end;

procedure TATCclsTserDataProperties.Set_Max(var Param1: Single);
begin
  DefaultInterface.Set_Max(Param1);
end;

function TATCclsTserDataProperties.Get_Max: Single;
begin
    Result := DefaultInterface.Max;
end;

function TATCclsTserDataProperties.Get_Value(var index: Integer): Single;
begin
    Result := DefaultInterface.Value[index];
end;

procedure TATCclsTserDataProperties.Set_Values(var Param1: PSafeArray);
begin
  DefaultInterface.Set_Values(Param1);
end;

function TATCclsTserDataProperties.Get_Values: PSafeArray;
begin
    Result := DefaultInterface.Values;
end;

procedure TATCclsTserDataProperties.Set_Value(var index: Integer; var Param2: Single);
begin
  DefaultInterface.Value[index] := Param2;
end;

function TATCclsTserDataProperties.Get_AttribNames: _Collection;
begin
    Result := DefaultInterface.AttribNames;
end;

procedure TATCclsTserDataProperties.Set_Mean(var Param1: Single);
begin
  DefaultInterface.Set_Mean(Param1);
end;

function TATCclsTserDataProperties.Get_Mean: Single;
begin
    Result := DefaultInterface.Mean;
end;

procedure TATCclsTserDataProperties.Set_Sum(var Param1: Single);
begin
  DefaultInterface.Set_Sum(Param1);
end;

function TATCclsTserDataProperties.Get_Sum: Single;
begin
    Result := DefaultInterface.Sum;
end;

procedure TATCclsTserDataProperties.Set_Variance(var Param1: Single);
begin
  DefaultInterface.Set_Variance(Param1);
end;

function TATCclsTserDataProperties.Get_Variance: Single;
begin
    Result := DefaultInterface.Variance;
end;

procedure TATCclsTserDataProperties.Set_StdDeviation(var Param1: Single);
begin
  DefaultInterface.Set_StdDeviation(Param1);
end;

function TATCclsTserDataProperties.Get_StdDeviation: Single;
begin
    Result := DefaultInterface.StdDeviation;
end;

procedure TATCclsTserDataProperties.Set_GeometricMean(var Param1: Single);
begin
  DefaultInterface.Set_GeometricMean(Param1);
end;

function TATCclsTserDataProperties.Get_GeometricMean: Single;
begin
    Result := DefaultInterface.GeometricMean;
end;

{$ENDIF}

class function CoATCclsTserDate.Create: _ATCclsTserDate;
begin
  Result := CreateComObject(CLASS_ATCclsTserDate) as _ATCclsTserDate;
end;

class function CoATCclsTserDate.CreateRemote(const MachineName: string): _ATCclsTserDate;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCclsTserDate) as _ATCclsTserDate;
end;

procedure TATCclsTserDate.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{335A1527-3323-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{F7BBB3D6-22E9-45F0-BD24-7CC1B7B94FA5}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATCclsTserDate.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATCclsTserDate;
  end;
end;

procedure TATCclsTserDate.ConnectTo(svrIntf: _ATCclsTserDate);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATCclsTserDate.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATCclsTserDate.GetDefaultInterface: _ATCclsTserDate;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATCclsTserDate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATCclsTserDateProperties.Create(Self);
{$ENDIF}
end;

destructor TATCclsTserDate.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATCclsTserDate.GetServerProperties: TATCclsTserDateProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TATCclsTserDate._Set_File_(var Param1: _ATCclsTserFile);
  { Warning: The property File_ has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.File_ := Param1;
end;

function TATCclsTserDate.Get_File_: _ATCclsTserFile;
begin
    Result := DefaultInterface.File_;
end;

function TATCclsTserDate.Get_Flag(var index: Integer): Integer;
begin
    Result := DefaultInterface.Flag[index];
end;

procedure TATCclsTserDate.Set_flags(var Param1: PSafeArray);
begin
  DefaultInterface.Set_flags(Param1);
end;

function TATCclsTserDate.Get_flags: PSafeArray;
begin
    Result := DefaultInterface.flags;
end;

function TATCclsTserDate.Get_Serial: Integer;
begin
    Result := DefaultInterface.Serial;
end;

procedure TATCclsTserDate.Set_Summary(var Param1: ATTimSerDateSummary);
begin
  DefaultInterface.Set_Summary(Param1);
end;

function TATCclsTserDate.Get_Summary: ATTimSerDateSummary;
begin
    Result := DefaultInterface.Summary;
end;

function TATCclsTserDate.Get_Value(var index: Integer): Double;
begin
    Result := DefaultInterface.Value[index];
end;

procedure TATCclsTserDate.Set_Values(var Param1: PSafeArray);
begin
  DefaultInterface.Set_Values(Param1);
end;

function TATCclsTserDate.Get_Values: PSafeArray;
begin
    Result := DefaultInterface.Values;
end;

procedure TATCclsTserDate.Set_Value(var index: Integer; const Param2: Double);
begin
  DefaultInterface.Value[index] := Param2;
end;

function TATCclsTserDate.IndexAtOrAfter(var targetDate: Double): Integer;
begin
  Result := DefaultInterface.IndexAtOrAfter(targetDate);
end;

function TATCclsTserDate.IndexAtOrBefore(var targetDate: Double): Integer;
begin
  Result := DefaultInterface.IndexAtOrBefore(targetDate);
end;

function TATCclsTserDate.SubSetByDate(var s: Double; var e: Double; var StartFrom: Integer): _ATCclsTserDate;
begin
  Result := DefaultInterface.SubSetByDate(s, e, StartFrom);
end;

function TATCclsTserDate.GetCommonDates(var cod: _Collection): _ATCclsTserDate;
begin
  Result := DefaultInterface.GetCommonDates(cod);
end;

procedure TATCclsTserDate.calcSummary(var PointFlg: WordBool);
begin
  DefaultInterface.calcSummary(PointFlg);
end;

function TATCclsTserDate.Copy: _ATCclsTserDate;
begin
  Result := DefaultInterface.Copy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATCclsTserDateProperties.Create(AServer: TATCclsTserDate);
begin
  inherited Create;
  FServer := AServer;
end;

function TATCclsTserDateProperties.GetDefaultInterface: _ATCclsTserDate;
begin
  Result := FServer.DefaultInterface;
end;

procedure TATCclsTserDateProperties._Set_File_(var Param1: _ATCclsTserFile);
  { Warning: The property File_ has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.File_ := Param1;
end;

function TATCclsTserDateProperties.Get_File_: _ATCclsTserFile;
begin
    Result := DefaultInterface.File_;
end;

function TATCclsTserDateProperties.Get_Flag(var index: Integer): Integer;
begin
    Result := DefaultInterface.Flag[index];
end;

procedure TATCclsTserDateProperties.Set_flags(var Param1: PSafeArray);
begin
  DefaultInterface.Set_flags(Param1);
end;

function TATCclsTserDateProperties.Get_flags: PSafeArray;
begin
    Result := DefaultInterface.flags;
end;

function TATCclsTserDateProperties.Get_Serial: Integer;
begin
    Result := DefaultInterface.Serial;
end;

procedure TATCclsTserDateProperties.Set_Summary(var Param1: ATTimSerDateSummary);
begin
  DefaultInterface.Set_Summary(Param1);
end;

function TATCclsTserDateProperties.Get_Summary: ATTimSerDateSummary;
begin
    Result := DefaultInterface.Summary;
end;

function TATCclsTserDateProperties.Get_Value(var index: Integer): Double;
begin
    Result := DefaultInterface.Value[index];
end;

procedure TATCclsTserDateProperties.Set_Values(var Param1: PSafeArray);
begin
  DefaultInterface.Set_Values(Param1);
end;

function TATCclsTserDateProperties.Get_Values: PSafeArray;
begin
    Result := DefaultInterface.Values;
end;

procedure TATCclsTserDateProperties.Set_Value(var index: Integer; var Param2: Double);
begin
  DefaultInterface.Value[index] := Param2;
end;

{$ENDIF}

class function CoATCclsTserFile.Create: _ATCclsTserFile;
begin
  Result := CreateComObject(CLASS_ATCclsTserFile) as _ATCclsTserFile;
end;

class function CoATCclsTserFile.CreateRemote(const MachineName: string): _ATCclsTserFile;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCclsTserFile) as _ATCclsTserFile;
end;

procedure TATCclsTserFile.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{335A1525-3323-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{5E6F5092-091B-11D5-983A-00A024C11E04}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATCclsTserFile.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATCclsTserFile;
  end;
end;

procedure TATCclsTserFile.ConnectTo(svrIntf: _ATCclsTserFile);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATCclsTserFile.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATCclsTserFile.GetDefaultInterface: _ATCclsTserFile;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATCclsTserFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATCclsTserFileProperties.Create(Self);
{$ENDIF}
end;

destructor TATCclsTserFile.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATCclsTserFile.GetServerProperties: TATCclsTserFileProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TATCclsTserFile._Set_Monitor(const Param1: IDispatch);
  { Warning: The property Monitor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Monitor := Param1;
end;

function TATCclsTserFile.Get_ErrorDescription: WideString;
begin
    Result := DefaultInterface.ErrorDescription;
end;

function TATCclsTserFile.Get_FileExtension: WideString;
begin
    Result := DefaultInterface.FileExtension;
end;

function TATCclsTserFile.Get_Label_: WideString;
begin
    Result := DefaultInterface.Label_;
end;

function TATCclsTserFile.Get_FileName: WideString;
begin
    Result := DefaultInterface.FileName;
end;

procedure TATCclsTserFile.Set_FileName(const Param1: WideString);
  { Warning: The property FileName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FileName := Param1;
end;

function TATCclsTserFile.Get_FileUnit: Integer;
begin
    Result := DefaultInterface.FileUnit;
end;

function TATCclsTserFile.Get_Description: WideString;
begin
    Result := DefaultInterface.Description;
end;

function TATCclsTserFile.Get_AvailableAttributes: _Collection;
begin
    Result := DefaultInterface.AvailableAttributes;
end;

function TATCclsTserFile.Get_Data(var index: Integer): _ATCclsTserData;
begin
    Result := DefaultInterface.Data[index];
end;

function TATCclsTserFile.Get_DataCount: Integer;
begin
    Result := DefaultInterface.DataCount;
end;

function TATCclsTserFile.Get_DataCollection: _Collection;
begin
    Result := DefaultInterface.DataCollection;
end;

procedure TATCclsTserFile.Set_HelpFilename(const Param1: WideString);
  { Warning: The property HelpFilename has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.HelpFilename := Param1;
end;

procedure TATCclsTserFile.readData(var dataObject: _ATCclsTserData);
begin
  DefaultInterface.readData(dataObject);
end;

procedure TATCclsTserFile.Clear;
begin
  DefaultInterface.Clear;
end;

procedure TATCclsTserFile.refresh;
begin
  DefaultInterface.refresh;
end;

function TATCclsTserFile.WriteDataHeader(var dataObject: _ATCclsTserData; 
                                         var oldHeader: _ATTimSerDataHeader): WordBool;
begin
  Result := DefaultInterface.WriteDataHeader(dataObject, oldHeader);
end;

function TATCclsTserFile.AddTimSer(var t: _ATCclsTserData; var ExistAction: Integer): WordBool;
begin
  Result := DefaultInterface.AddTimSer(t, ExistAction);
end;

function TATCclsTserFile.RemoveTimSer(var t: _ATCclsTserData): WordBool;
begin
  Result := DefaultInterface.RemoveTimSer(t);
end;

function TATCclsTserFile.RewriteTimSer(var t: _ATCclsTserData): WordBool;
begin
  Result := DefaultInterface.RewriteTimSer(t);
end;

function TATCclsTserFile.SaveAs(var FileName: WideString): WordBool;
begin
  Result := DefaultInterface.SaveAs(FileName);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATCclsTserFileProperties.Create(AServer: TATCclsTserFile);
begin
  inherited Create;
  FServer := AServer;
end;

function TATCclsTserFileProperties.GetDefaultInterface: _ATCclsTserFile;
begin
  Result := FServer.DefaultInterface;
end;

procedure TATCclsTserFileProperties._Set_Monitor(const Param1: IDispatch);
  { Warning: The property Monitor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Monitor := Param1;
end;

function TATCclsTserFileProperties.Get_ErrorDescription: WideString;
begin
    Result := DefaultInterface.ErrorDescription;
end;

function TATCclsTserFileProperties.Get_FileExtension: WideString;
begin
    Result := DefaultInterface.FileExtension;
end;

function TATCclsTserFileProperties.Get_Label_: WideString;
begin
    Result := DefaultInterface.Label_;
end;

function TATCclsTserFileProperties.Get_FileName: WideString;
begin
    Result := DefaultInterface.FileName;
end;

procedure TATCclsTserFileProperties.Set_FileName(const Param1: WideString);
  { Warning: The property FileName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FileName := Param1;
end;

function TATCclsTserFileProperties.Get_FileUnit: Integer;
begin
    Result := DefaultInterface.FileUnit;
end;

function TATCclsTserFileProperties.Get_Description: WideString;
begin
    Result := DefaultInterface.Description;
end;

function TATCclsTserFileProperties.Get_AvailableAttributes: _Collection;
begin
    Result := DefaultInterface.AvailableAttributes;
end;

function TATCclsTserFileProperties.Get_Data(var index: Integer): _ATCclsTserData;
begin
    Result := DefaultInterface.Data[index];
end;

function TATCclsTserFileProperties.Get_DataCount: Integer;
begin
    Result := DefaultInterface.DataCount;
end;

function TATCclsTserFileProperties.Get_DataCollection: _Collection;
begin
    Result := DefaultInterface.DataCollection;
end;

procedure TATCclsTserFileProperties.Set_HelpFilename(const Param1: WideString);
  { Warning: The property HelpFilename has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.HelpFilename := Param1;
end;

{$ENDIF}

class function CoATCclsCriterion.Create: _ATCclsCriterion;
begin
  Result := CreateComObject(CLASS_ATCclsCriterion) as _ATCclsCriterion;
end;

class function CoATCclsCriterion.CreateRemote(const MachineName: string): _ATCclsCriterion;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCclsCriterion) as _ATCclsCriterion;
end;

procedure TATCclsCriterion.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{335A152C-3323-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{335A152B-3323-11D4-9D23-00A0C9768F70}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATCclsCriterion.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATCclsCriterion;
  end;
end;

procedure TATCclsCriterion.ConnectTo(svrIntf: _ATCclsCriterion);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATCclsCriterion.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATCclsCriterion.GetDefaultInterface: _ATCclsCriterion;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATCclsCriterion.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATCclsCriterionProperties.Create(Self);
{$ENDIF}
end;

destructor TATCclsCriterion.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATCclsCriterion.GetServerProperties: TATCclsCriterionProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TATCclsCriterion.Get_Field: WideString;
begin
    Result := DefaultInterface.Field;
end;

procedure TATCclsCriterion.Set_Field(var Param1: WideString);
  { Warning: The property Field has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Field := Param1;
end;

function TATCclsCriterion.Get_Operation: ATCCompare;
begin
    Result := DefaultInterface.Operation;
end;

procedure TATCclsCriterion.Set_Operation(var Param1: ATCCompare);
begin
  DefaultInterface.Set_Operation(Param1);
end;

function TATCclsCriterion.Get_Values: _Collection;
begin
    Result := DefaultInterface.Values;
end;

procedure TATCclsCriterion.Set_Values(var Param1: _Collection);
begin
  DefaultInterface.Set_Values(Param1);
end;

function TATCclsCriterion.Match(var testValue: OleVariant): WordBool;
begin
  Result := DefaultInterface.Match(testValue);
end;

function TATCclsCriterion.MatchField(var obj: OleVariant): WordBool;
begin
  Result := DefaultInterface.MatchField(obj);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATCclsCriterionProperties.Create(AServer: TATCclsCriterion);
begin
  inherited Create;
  FServer := AServer;
end;

function TATCclsCriterionProperties.GetDefaultInterface: _ATCclsCriterion;
begin
  Result := FServer.DefaultInterface;
end;

function TATCclsCriterionProperties.Get_Field: WideString;
begin
    Result := DefaultInterface.Field;
end;

procedure TATCclsCriterionProperties.Set_Field(var Param1: WideString);
  { Warning: The property Field has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Field := Param1;
end;

function TATCclsCriterionProperties.Get_Operation: ATCCompare;
begin
    Result := DefaultInterface.Operation;
end;

procedure TATCclsCriterionProperties.Set_Operation(var Param1: ATCCompare);
begin
  DefaultInterface.Set_Operation(Param1);
end;

function TATCclsCriterionProperties.Get_Values: _Collection;
begin
    Result := DefaultInterface.Values;
end;

procedure TATCclsCriterionProperties.Set_Values(var Param1: _Collection);
begin
  DefaultInterface.Set_Values(Param1);
end;

{$ENDIF}

class function CoATTimSerDataHeader.Create: _ATTimSerDataHeader;
begin
  Result := CreateComObject(CLASS_ATTimSerDataHeader) as _ATTimSerDataHeader;
end;

class function CoATTimSerDataHeader.CreateRemote(const MachineName: string): _ATTimSerDataHeader;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATTimSerDataHeader) as _ATTimSerDataHeader;
end;

procedure TATTimSerDataHeader.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{335A1523-3323-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{62CCA97A-7201-11D4-9D23-00A0C9768F70}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATTimSerDataHeader.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATTimSerDataHeader;
  end;
end;

procedure TATTimSerDataHeader.ConnectTo(svrIntf: _ATTimSerDataHeader);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATTimSerDataHeader.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATTimSerDataHeader.GetDefaultInterface: _ATTimSerDataHeader;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATTimSerDataHeader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATTimSerDataHeaderProperties.Create(Self);
{$ENDIF}
end;

destructor TATTimSerDataHeader.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATTimSerDataHeader.GetServerProperties: TATTimSerDataHeaderProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TATTimSerDataHeader.Get_Desc: WideString;
begin
    Result := DefaultInterface.Desc;
end;

procedure TATTimSerDataHeader.Set_Desc(var Param1: WideString);
  { Warning: The property Desc has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Desc := Param1;
end;

function TATTimSerDataHeader.Get_id: Double;
begin
    Result := DefaultInterface.id;
end;

procedure TATTimSerDataHeader.Set_id(var Param1: Double);
begin
  DefaultInterface.Set_id(Param1);
end;

function TATTimSerDataHeader.Get_Sen: WideString;
begin
    Result := DefaultInterface.Sen;
end;

procedure TATTimSerDataHeader.Set_Sen(var Param1: WideString);
  { Warning: The property Sen has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Sen := Param1;
end;

function TATTimSerDataHeader.Get_Loc: WideString;
begin
    Result := DefaultInterface.Loc;
end;

procedure TATTimSerDataHeader.Set_Loc(var Param1: WideString);
  { Warning: The property Loc has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Loc := Param1;
end;

function TATTimSerDataHeader.Get_Con: WideString;
begin
    Result := DefaultInterface.Con;
end;

procedure TATTimSerDataHeader.Set_Con(var Param1: WideString);
  { Warning: The property Con has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Con := Param1;
end;

function TATTimSerDataHeader.Copy: _ATTimSerDataHeader;
begin
  Result := DefaultInterface.Copy;
end;

function TATTimSerDataHeader.Compare(var nTsHeader: _ATTimSerDataHeader): WordBool;
begin
  Result := DefaultInterface.Compare(nTsHeader);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATTimSerDataHeaderProperties.Create(AServer: TATTimSerDataHeader);
begin
  inherited Create;
  FServer := AServer;
end;

function TATTimSerDataHeaderProperties.GetDefaultInterface: _ATTimSerDataHeader;
begin
  Result := FServer.DefaultInterface;
end;

function TATTimSerDataHeaderProperties.Get_Desc: WideString;
begin
    Result := DefaultInterface.Desc;
end;

procedure TATTimSerDataHeaderProperties.Set_Desc(var Param1: WideString);
  { Warning: The property Desc has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Desc := Param1;
end;

function TATTimSerDataHeaderProperties.Get_id: Double;
begin
    Result := DefaultInterface.id;
end;

procedure TATTimSerDataHeaderProperties.Set_id(var Param1: Double);
begin
  DefaultInterface.Set_id(Param1);
end;

function TATTimSerDataHeaderProperties.Get_Sen: WideString;
begin
    Result := DefaultInterface.Sen;
end;

procedure TATTimSerDataHeaderProperties.Set_Sen(var Param1: WideString);
  { Warning: The property Sen has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Sen := Param1;
end;

function TATTimSerDataHeaderProperties.Get_Loc: WideString;
begin
    Result := DefaultInterface.Loc;
end;

procedure TATTimSerDataHeaderProperties.Set_Loc(var Param1: WideString);
  { Warning: The property Loc has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Loc := Param1;
end;

function TATTimSerDataHeaderProperties.Get_Con: WideString;
begin
    Result := DefaultInterface.Con;
end;

procedure TATTimSerDataHeaderProperties.Set_Con(var Param1: WideString);
  { Warning: The property Con has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Con := Param1;
end;

{$ENDIF}

class function CoATCclsParm.Create: _ATCclsParm;
begin
  Result := CreateComObject(CLASS_ATCclsParm) as _ATCclsParm;
end;

class function CoATCclsParm.CreateRemote(const MachineName: string): _ATCclsParm;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCclsParm) as _ATCclsParm;
end;

procedure TATCclsParm.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{335A1533-3323-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{335A1532-3323-11D4-9D23-00A0C9768F70}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATCclsParm.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATCclsParm;
  end;
end;

procedure TATCclsParm.ConnectTo(svrIntf: _ATCclsParm);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATCclsParm.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATCclsParm.GetDefaultInterface: _ATCclsParm;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATCclsParm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATCclsParmProperties.Create(Self);
{$ENDIF}
end;

destructor TATCclsParm.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATCclsParm.GetServerProperties: TATCclsParmProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TATCclsParm.Get_Value: WideString;
begin
    Result := DefaultInterface.Value;
end;

procedure TATCclsParm.Set_Value(var Param1: WideString);
  { Warning: The property Value has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Value := Param1;
end;

function TATCclsParm.Get_Def: _ATCclsParmDef;
begin
    Result := DefaultInterface.Def;
end;

procedure TATCclsParm._Set_Def(var Param1: _ATCclsParmDef);
  { Warning: The property Def has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Def := Param1;
end;

function TATCclsParm.Get_Parent: IDispatch;
begin
    Result := DefaultInterface.Parent;
end;

procedure TATCclsParm._Set_Parent(var Param1: IDispatch);
  { Warning: The property Parent has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Parent := Param1;
end;

function TATCclsParm.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATCclsParmProperties.Create(AServer: TATCclsParm);
begin
  inherited Create;
  FServer := AServer;
end;

function TATCclsParmProperties.GetDefaultInterface: _ATCclsParm;
begin
  Result := FServer.DefaultInterface;
end;

function TATCclsParmProperties.Get_Value: WideString;
begin
    Result := DefaultInterface.Value;
end;

procedure TATCclsParmProperties.Set_Value(var Param1: WideString);
  { Warning: The property Value has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Value := Param1;
end;

function TATCclsParmProperties.Get_Def: _ATCclsParmDef;
begin
    Result := DefaultInterface.Def;
end;

procedure TATCclsParmProperties._Set_Def(var Param1: _ATCclsParmDef);
  { Warning: The property Def has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Def := Param1;
end;

function TATCclsParmProperties.Get_Parent: IDispatch;
begin
    Result := DefaultInterface.Parent;
end;

procedure TATCclsParmProperties._Set_Parent(var Param1: IDispatch);
  { Warning: The property Parent has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Parent := Param1;
end;

function TATCclsParmProperties.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

{$ENDIF}

class function CoATCclsParmDef.Create: _ATCclsParmDef;
begin
  Result := CreateComObject(CLASS_ATCclsParmDef) as _ATCclsParmDef;
end;

class function CoATCclsParmDef.CreateRemote(const MachineName: string): _ATCclsParmDef;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCclsParmDef) as _ATCclsParmDef;
end;

procedure TATCclsParmDef.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{335A1531-3323-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{335A1530-3323-11D4-9D23-00A0C9768F70}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATCclsParmDef.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATCclsParmDef;
  end;
end;

procedure TATCclsParmDef.ConnectTo(svrIntf: _ATCclsParmDef);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATCclsParmDef.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATCclsParmDef.GetDefaultInterface: _ATCclsParmDef;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATCclsParmDef.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATCclsParmDefProperties.Create(Self);
{$ENDIF}
end;

destructor TATCclsParmDef.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATCclsParmDef.GetServerProperties: TATCclsParmDefProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TATCclsParmDef.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TATCclsParmDef.Set_Name(var Param1: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := Param1;
end;

function TATCclsParmDef.Get_Typ: Integer;
begin
    Result := DefaultInterface.Typ;
end;

procedure TATCclsParmDef.Set_Typ(var Param1: Integer);
begin
  DefaultInterface.Set_Typ(Param1);
end;

function TATCclsParmDef.Get_Min: Double;
begin
    Result := DefaultInterface.Min;
end;

procedure TATCclsParmDef.Set_Min(var Param1: Double);
begin
  DefaultInterface.Set_Min(Param1);
end;

function TATCclsParmDef.Get_Max: Double;
begin
    Result := DefaultInterface.Max;
end;

procedure TATCclsParmDef.Set_Max(var Param1: Double);
begin
  DefaultInterface.Set_Max(Param1);
end;

function TATCclsParmDef.Get_Default: WideString;
begin
    Result := DefaultInterface.Default;
end;

procedure TATCclsParmDef.Set_Default(var Param1: WideString);
  { Warning: The property Default has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Default := Param1;
end;

function TATCclsParmDef.Get_SoftMin: Double;
begin
    Result := DefaultInterface.SoftMin;
end;

procedure TATCclsParmDef.Set_SoftMin(var Param1: Double);
begin
  DefaultInterface.Set_SoftMin(Param1);
end;

function TATCclsParmDef.Get_SoftMax: Double;
begin
    Result := DefaultInterface.SoftMax;
end;

procedure TATCclsParmDef.Set_SoftMax(var Param1: Double);
begin
  DefaultInterface.Set_SoftMax(Param1);
end;

function TATCclsParmDef.Get_Define: WideString;
begin
    Result := DefaultInterface.Define;
end;

procedure TATCclsParmDef.Set_Define(var Param1: WideString);
  { Warning: The property Define has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Define := Param1;
end;

function TATCclsParmDef.Get_Parent: IDispatch;
begin
    Result := DefaultInterface.Parent;
end;

procedure TATCclsParmDef._Set_Parent(var Param1: IDispatch);
  { Warning: The property Parent has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Parent := Param1;
end;

function TATCclsParmDef.Get_Other: WideString;
begin
    Result := DefaultInterface.Other;
end;

procedure TATCclsParmDef.Set_Other(var Param1: WideString);
  { Warning: The property Other has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Other := Param1;
end;

function TATCclsParmDef.Get_StartCol: Integer;
begin
    Result := DefaultInterface.StartCol;
end;

procedure TATCclsParmDef.Set_StartCol(var Param1: Integer);
begin
  DefaultInterface.Set_StartCol(Param1);
end;

function TATCclsParmDef.Get_Length: Integer;
begin
    Result := DefaultInterface.Length;
end;

procedure TATCclsParmDef.Set_Length(var Param1: Integer);
begin
  DefaultInterface.Set_Length(Param1);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATCclsParmDefProperties.Create(AServer: TATCclsParmDef);
begin
  inherited Create;
  FServer := AServer;
end;

function TATCclsParmDefProperties.GetDefaultInterface: _ATCclsParmDef;
begin
  Result := FServer.DefaultInterface;
end;

function TATCclsParmDefProperties.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TATCclsParmDefProperties.Set_Name(var Param1: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := Param1;
end;

function TATCclsParmDefProperties.Get_Typ: Integer;
begin
    Result := DefaultInterface.Typ;
end;

procedure TATCclsParmDefProperties.Set_Typ(var Param1: Integer);
begin
  DefaultInterface.Set_Typ(Param1);
end;

function TATCclsParmDefProperties.Get_Min: Double;
begin
    Result := DefaultInterface.Min;
end;

procedure TATCclsParmDefProperties.Set_Min(var Param1: Double);
begin
  DefaultInterface.Set_Min(Param1);
end;

function TATCclsParmDefProperties.Get_Max: Double;
begin
    Result := DefaultInterface.Max;
end;

procedure TATCclsParmDefProperties.Set_Max(var Param1: Double);
begin
  DefaultInterface.Set_Max(Param1);
end;

function TATCclsParmDefProperties.Get_Default: WideString;
begin
    Result := DefaultInterface.Default;
end;

procedure TATCclsParmDefProperties.Set_Default(var Param1: WideString);
  { Warning: The property Default has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Default := Param1;
end;

function TATCclsParmDefProperties.Get_SoftMin: Double;
begin
    Result := DefaultInterface.SoftMin;
end;

procedure TATCclsParmDefProperties.Set_SoftMin(var Param1: Double);
begin
  DefaultInterface.Set_SoftMin(Param1);
end;

function TATCclsParmDefProperties.Get_SoftMax: Double;
begin
    Result := DefaultInterface.SoftMax;
end;

procedure TATCclsParmDefProperties.Set_SoftMax(var Param1: Double);
begin
  DefaultInterface.Set_SoftMax(Param1);
end;

function TATCclsParmDefProperties.Get_Define: WideString;
begin
    Result := DefaultInterface.Define;
end;

procedure TATCclsParmDefProperties.Set_Define(var Param1: WideString);
  { Warning: The property Define has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Define := Param1;
end;

function TATCclsParmDefProperties.Get_Parent: IDispatch;
begin
    Result := DefaultInterface.Parent;
end;

procedure TATCclsParmDefProperties._Set_Parent(var Param1: IDispatch);
  { Warning: The property Parent has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Parent := Param1;
end;

function TATCclsParmDefProperties.Get_Other: WideString;
begin
    Result := DefaultInterface.Other;
end;

procedure TATCclsParmDefProperties.Set_Other(var Param1: WideString);
  { Warning: The property Other has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Other := Param1;
end;

function TATCclsParmDefProperties.Get_StartCol: Integer;
begin
    Result := DefaultInterface.StartCol;
end;

procedure TATCclsParmDefProperties.Set_StartCol(var Param1: Integer);
begin
  DefaultInterface.Set_StartCol(Param1);
end;

function TATCclsParmDefProperties.Get_Length: Integer;
begin
    Result := DefaultInterface.Length;
end;

procedure TATCclsParmDefProperties.Set_Length(var Param1: Integer);
begin
  DefaultInterface.Set_Length(Param1);
end;

{$ENDIF}

class function CoATCclsAttributeDefinition.Create: _ATCclsAttributeDefinition;
begin
  Result := CreateComObject(CLASS_ATCclsAttributeDefinition) as _ATCclsAttributeDefinition;
end;

class function CoATCclsAttributeDefinition.CreateRemote(const MachineName: string): _ATCclsAttributeDefinition;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCclsAttributeDefinition) as _ATCclsAttributeDefinition;
end;

procedure TATCclsAttributeDefinition.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{335A1514-3323-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{A7CE20A6-8C27-41BF-860D-B3702A0CABD2}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATCclsAttributeDefinition.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATCclsAttributeDefinition;
  end;
end;

procedure TATCclsAttributeDefinition.ConnectTo(svrIntf: _ATCclsAttributeDefinition);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATCclsAttributeDefinition.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATCclsAttributeDefinition.GetDefaultInterface: _ATCclsAttributeDefinition;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATCclsAttributeDefinition.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATCclsAttributeDefinitionProperties.Create(Self);
{$ENDIF}
end;

destructor TATCclsAttributeDefinition.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATCclsAttributeDefinition.GetServerProperties: TATCclsAttributeDefinitionProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TATCclsAttributeDefinition.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TATCclsAttributeDefinition.Set_Name(var Param1: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := Param1;
end;

function TATCclsAttributeDefinition.Get_Description: WideString;
begin
    Result := DefaultInterface.Description;
end;

procedure TATCclsAttributeDefinition.Set_Description(var Param1: WideString);
  { Warning: The property Description has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Description := Param1;
end;

function TATCclsAttributeDefinition.Get_DataType: ATCoDataType;
begin
    Result := DefaultInterface.DataType;
end;

procedure TATCclsAttributeDefinition.Set_DataType(var Param1: ATCoDataType);
begin
  DefaultInterface.Set_DataType(Param1);
end;

function TATCclsAttributeDefinition.Get_Min: Single;
begin
    Result := DefaultInterface.Min;
end;

procedure TATCclsAttributeDefinition.Set_Min(var Param1: Single);
begin
  DefaultInterface.Set_Min(Param1);
end;

function TATCclsAttributeDefinition.Get_Max: Single;
begin
    Result := DefaultInterface.Max;
end;

procedure TATCclsAttributeDefinition.Set_Max(var Param1: Single);
begin
  DefaultInterface.Set_Max(Param1);
end;

function TATCclsAttributeDefinition.Get_ValidValues: WideString;
begin
    Result := DefaultInterface.ValidValues;
end;

procedure TATCclsAttributeDefinition.Set_ValidValues(var Param1: WideString);
  { Warning: The property ValidValues has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ValidValues := Param1;
end;

function TATCclsAttributeDefinition.Get_Default: Single;
begin
    Result := DefaultInterface.Default;
end;

procedure TATCclsAttributeDefinition.Set_Default(var Param1: Single);
begin
  DefaultInterface.Set_Default(Param1);
end;

function TATCclsAttributeDefinition.Get_Editable: WordBool;
begin
    Result := DefaultInterface.Editable;
end;

procedure TATCclsAttributeDefinition.Set_Editable(var Param1: WordBool);
begin
  DefaultInterface.Set_Editable(Param1);
end;

function TATCclsAttributeDefinition.Dump: WideString;
begin
  Result := DefaultInterface.Dump;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATCclsAttributeDefinitionProperties.Create(AServer: TATCclsAttributeDefinition);
begin
  inherited Create;
  FServer := AServer;
end;

function TATCclsAttributeDefinitionProperties.GetDefaultInterface: _ATCclsAttributeDefinition;
begin
  Result := FServer.DefaultInterface;
end;

function TATCclsAttributeDefinitionProperties.Get_Name: WideString;
begin
    Result := DefaultInterface.Name;
end;

procedure TATCclsAttributeDefinitionProperties.Set_Name(var Param1: WideString);
  { Warning: The property Name has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Name := Param1;
end;

function TATCclsAttributeDefinitionProperties.Get_Description: WideString;
begin
    Result := DefaultInterface.Description;
end;

procedure TATCclsAttributeDefinitionProperties.Set_Description(var Param1: WideString);
  { Warning: The property Description has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Description := Param1;
end;

function TATCclsAttributeDefinitionProperties.Get_DataType: ATCoDataType;
begin
    Result := DefaultInterface.DataType;
end;

procedure TATCclsAttributeDefinitionProperties.Set_DataType(var Param1: ATCoDataType);
begin
  DefaultInterface.Set_DataType(Param1);
end;

function TATCclsAttributeDefinitionProperties.Get_Min: Single;
begin
    Result := DefaultInterface.Min;
end;

procedure TATCclsAttributeDefinitionProperties.Set_Min(var Param1: Single);
begin
  DefaultInterface.Set_Min(Param1);
end;

function TATCclsAttributeDefinitionProperties.Get_Max: Single;
begin
    Result := DefaultInterface.Max;
end;

procedure TATCclsAttributeDefinitionProperties.Set_Max(var Param1: Single);
begin
  DefaultInterface.Set_Max(Param1);
end;

function TATCclsAttributeDefinitionProperties.Get_ValidValues: WideString;
begin
    Result := DefaultInterface.ValidValues;
end;

procedure TATCclsAttributeDefinitionProperties.Set_ValidValues(var Param1: WideString);
  { Warning: The property ValidValues has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ValidValues := Param1;
end;

function TATCclsAttributeDefinitionProperties.Get_Default: Single;
begin
    Result := DefaultInterface.Default;
end;

procedure TATCclsAttributeDefinitionProperties.Set_Default(var Param1: Single);
begin
  DefaultInterface.Set_Default(Param1);
end;

function TATCclsAttributeDefinitionProperties.Get_Editable: WordBool;
begin
    Result := DefaultInterface.Editable;
end;

procedure TATCclsAttributeDefinitionProperties.Set_Editable(var Param1: WordBool);
begin
  DefaultInterface.Set_Editable(Param1);
end;

{$ENDIF}

class function CoCollString.Create: _CollString;
begin
  Result := CreateComObject(CLASS_CollString) as _CollString;
end;

class function CoCollString.CreateRemote(const MachineName: string): _CollString;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CollString) as _CollString;
end;

procedure TCollString.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{4AED0D15-8E55-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{4AED0D14-8E55-11D4-9D23-00A0C9768F70}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCollString.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _CollString;
  end;
end;

procedure TCollString.ConnectTo(svrIntf: _CollString);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCollString.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCollString.GetDefaultInterface: _CollString;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TCollString.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TCollStringProperties.Create(Self);
{$ENDIF}
end;

destructor TCollString.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TCollString.GetServerProperties: TCollStringProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TCollString.Get_coll: _Collection;
begin
    Result := DefaultInterface.coll;
end;

procedure TCollString._Set_coll(var Param1: _Collection);
  { Warning: The property coll has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.coll := Param1;
end;

function TCollString.Get_Keys: _Collection;
begin
    Result := DefaultInterface.Keys;
end;

function TCollString.Add(const newValue: WideString; const key: WideString): WideString;
begin
  Result := DefaultInterface.Add(newValue, key);
end;

procedure TCollString.Clear;
begin
  DefaultInterface.Clear;
end;

function TCollString.Count: Integer;
begin
  Result := DefaultInterface.Count;
end;

procedure TCollString.Remove(key: OleVariant);
begin
  DefaultInterface.Remove(key);
end;

function TCollString.Item(key: OleVariant): WideString;
begin
  Result := DefaultInterface.Item(key);
end;

function TCollString.NewEnum: IUnknown;
begin
  Result := DefaultInterface.NewEnum;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TCollStringProperties.Create(AServer: TCollString);
begin
  inherited Create;
  FServer := AServer;
end;

function TCollStringProperties.GetDefaultInterface: _CollString;
begin
  Result := FServer.DefaultInterface;
end;

function TCollStringProperties.Get_coll: _Collection;
begin
    Result := DefaultInterface.coll;
end;

procedure TCollStringProperties._Set_coll(var Param1: _Collection);
  { Warning: The property coll has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.coll := Param1;
end;

function TCollStringProperties.Get_Keys: _Collection;
begin
    Result := DefaultInterface.Keys;
end;

{$ENDIF}

class function CoCollTserData.Create: _CollTserData;
begin
  Result := CreateComObject(CLASS_CollTserData) as _CollTserData;
end;

class function CoCollTserData.CreateRemote(const MachineName: string): _CollTserData;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CollTserData) as _CollTserData;
end;

procedure TCollTserData.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{4AED0D17-8E55-11D4-9D23-00A0C9768F70}';
    IntfIID:   '{4AED0D16-8E55-11D4-9D23-00A0C9768F70}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCollTserData.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _CollTserData;
  end;
end;

procedure TCollTserData.ConnectTo(svrIntf: _CollTserData);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCollTserData.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCollTserData.GetDefaultInterface: _CollTserData;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TCollTserData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TCollTserDataProperties.Create(Self);
{$ENDIF}
end;

destructor TCollTserData.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TCollTserData.GetServerProperties: TCollTserDataProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TCollTserData.Get_coll: _Collection;
begin
    Result := DefaultInterface.coll;
end;

procedure TCollTserData._Set_coll(var Param1: _Collection);
  { Warning: The property coll has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.coll := Param1;
end;

function TCollTserData.Get_Keys: _Collection;
begin
    Result := DefaultInterface.Keys;
end;

function TCollTserData.Add(const newValue: _ATCclsTserData; const key: WideString): WideString;
begin
  Result := DefaultInterface.Add(newValue, key);
end;

procedure TCollTserData.Clear;
begin
  DefaultInterface.Clear;
end;

function TCollTserData.Count: Integer;
begin
  Result := DefaultInterface.Count;
end;

procedure TCollTserData.Remove(key: OleVariant);
begin
  DefaultInterface.Remove(key);
end;

function TCollTserData.Item(key: OleVariant): _ATCclsTserData;
begin
  Result := DefaultInterface.Item(key);
end;

function TCollTserData.NewEnum: IUnknown;
begin
  Result := DefaultInterface.NewEnum;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TCollTserDataProperties.Create(AServer: TCollTserData);
begin
  inherited Create;
  FServer := AServer;
end;

function TCollTserDataProperties.GetDefaultInterface: _CollTserData;
begin
  Result := FServer.DefaultInterface;
end;

function TCollTserDataProperties.Get_coll: _Collection;
begin
    Result := DefaultInterface.coll;
end;

procedure TCollTserDataProperties._Set_coll(var Param1: _Collection);
  { Warning: The property coll has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.coll := Param1;
end;

function TCollTserDataProperties.Get_Keys: _Collection;
begin
    Result := DefaultInterface.Keys;
end;

{$ENDIF}

class function CoATCclsAnalysis.Create: _ATCclsAnalysis;
begin
  Result := CreateComObject(CLASS_ATCclsAnalysis) as _ATCclsAnalysis;
end;

class function CoATCclsAnalysis.CreateRemote(const MachineName: string): _ATCclsAnalysis;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCclsAnalysis) as _ATCclsAnalysis;
end;

procedure TATCclsAnalysis.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{4F06F0D8-9C9F-4053-9807-FFACCE22014E}';
    IntfIID:   '{64C7B902-315B-4D24-B4C2-AE9FDAF77EA9}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TATCclsAnalysis.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as _ATCclsAnalysis;
  end;
end;

procedure TATCclsAnalysis.ConnectTo(svrIntf: _ATCclsAnalysis);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TATCclsAnalysis.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TATCclsAnalysis.GetDefaultInterface: _ATCclsAnalysis;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TATCclsAnalysis.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TATCclsAnalysisProperties.Create(Self);
{$ENDIF}
end;

destructor TATCclsAnalysis.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TATCclsAnalysis.GetServerProperties: TATCclsAnalysisProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TATCclsAnalysis._Set_Monitor(const Param1: IDispatch);
  { Warning: The property Monitor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Monitor := Param1;
end;

function TATCclsAnalysis.Get_ErrorDescription: WideString;
begin
    Result := DefaultInterface.ErrorDescription;
end;

function TATCclsAnalysis.Get_Description: WideString;
begin
    Result := DefaultInterface.Description;
end;

procedure TATCclsAnalysis._Set_DataCollection(var Param1: _Collection);
  { Warning: The property DataCollection has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DataCollection := Param1;
end;

function TATCclsAnalysis.Get_Specification: WideString;
begin
    Result := DefaultInterface.Specification;
end;

procedure TATCclsAnalysis.Set_Specification(var Param1: WideString);
  { Warning: The property Specification has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Specification := Param1;
end;

procedure TATCclsAnalysis.Go;
begin
  DefaultInterface.Go;
end;

function TATCclsAnalysis.EditSpecification: WordBool;
begin
  Result := DefaultInterface.EditSpecification;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TATCclsAnalysisProperties.Create(AServer: TATCclsAnalysis);
begin
  inherited Create;
  FServer := AServer;
end;

function TATCclsAnalysisProperties.GetDefaultInterface: _ATCclsAnalysis;
begin
  Result := FServer.DefaultInterface;
end;

procedure TATCclsAnalysisProperties._Set_Monitor(const Param1: IDispatch);
  { Warning: The property Monitor has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Monitor := Param1;
end;

function TATCclsAnalysisProperties.Get_ErrorDescription: WideString;
begin
    Result := DefaultInterface.ErrorDescription;
end;

function TATCclsAnalysisProperties.Get_Description: WideString;
begin
    Result := DefaultInterface.Description;
end;

procedure TATCclsAnalysisProperties._Set_DataCollection(var Param1: _Collection);
  { Warning: The property DataCollection has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DataCollection := Param1;
end;

function TATCclsAnalysisProperties.Get_Specification: WideString;
begin
    Result := DefaultInterface.Specification;
end;

procedure TATCclsAnalysisProperties.Set_Specification(var Param1: WideString);
  { Warning: The property Specification has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Specification := Param1;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TATCDataTypes, TATCPlugInTypes, TATCPlugInManager, TATCclsCatalog, 
    TATCclsTserData, TATCclsTserDate, TATCclsTserFile, TATCclsCriterion, TATTimSerDataHeader, 
    TATCclsParm, TATCclsParmDef, TATCclsAttributeDefinition, TCollString, TCollTserData, 
    TATCclsAnalysis]);
end;

end.
