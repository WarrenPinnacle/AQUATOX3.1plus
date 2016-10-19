//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit ATCTSfile_TLB;

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

// PASTLWTR : 1.2
// File generated on 11/8/2006 2:12:47 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINDOWS\system32\ATCTSfile.dll (1)
// LIBID: {6EEEC479-3323-11D4-9D23-00A0C9768F70}
// LCID: 0
// Helpfile: 
// HelpString: Aqua Terra Consultants Timeseries Data File I/O
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v2.11 ATCData, (C:\WINDOWS\system32\ATCData.dll)
//   (3) v6.0 VBA, (C:\WINDOWS\system32\MSVBVM60.dll)
//   (4) v1.10 ATCoCtl, (C:\WINDOWS\system32\ATCoCtl.ocx)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, ATCData_TLB, ATCoCtl_TLB, Classes, Graphics, OleServer, StdVCL, 
Variants, VBA_TLB;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ATCTSfileMajorVersion = 3;
  ATCTSfileMinorVersion = 2;

  LIBID_ATCTSfile: TGUID = '{6EEEC479-3323-11D4-9D23-00A0C9768F70}';

  IID__ATComponentCatalog: TGUID = '{2B7BFF7A-D483-46D8-BB2B-91C5E0169F8F}';
  CLASS_ATComponentCatalog: TGUID = '{6EEEC47B-3323-11D4-9D23-00A0C9768F70}';
  IID__clsTSerMemory: TGUID = '{76009B55-97DE-4452-BFB3-0D48EB6CBF08}';
  CLASS_clsTSerMemory: TGUID = '{6EEEC484-3323-11D4-9D23-00A0C9768F70}';
  IID__clsTSerPltgen: TGUID = '{90C8E6C5-FA5C-40B3-9A11-F4E4229554B3}';
  CLASS_clsTSerPltgen: TGUID = '{6EEEC48B-3323-11D4-9D23-00A0C9768F70}';
  IID__clsTSerSWATDbf: TGUID = '{9A7CD237-994A-45DD-B2D9-9B0E2BD09723}';
  CLASS_clsTSerSWATDbf: TGUID = '{6EEEC48D-3323-11D4-9D23-00A0C9768F70}';
  IID__clsTSerBasObsWQ: TGUID = '{199268F7-1711-41E1-9641-9D2E62D7FB51}';
  CLASS_clsTSerBasObsWQ: TGUID = '{6EEEC48F-3323-11D4-9D23-00A0C9768F70}';
  IID__clsTSerFEO: TGUID = '{E0ADDEDD-D6AD-4287-BED8-DBF27E0DAF82}';
  CLASS_clsTSerFEO: TGUID = '{6EEEC491-3323-11D4-9D23-00A0C9768F70}';
  IID__clsTSerRDB: TGUID = '{4F75C6B7-DE05-4DA2-8BF5-F600793AF283}';
  CLASS_clsTSerRDB: TGUID = '{6EEEC493-3323-11D4-9D23-00A0C9768F70}';
  IID__clsTSerWDM: TGUID = '{F8620F3D-0C75-4D4F-B1F5-2807415565E4}';
  CLASS_clsTSerWDM: TGUID = '{6EEEC497-3323-11D4-9D23-00A0C9768F70}';
  IID__clsATCscriptExpression: TGUID = '{0C86C872-858F-4CFC-895E-3873ADD3E99D}';
  CLASS_clsATCscriptExpression: TGUID = '{6EEEC49D-3323-11D4-9D23-00A0C9768F70}';
  IID__ATCoMsgWDM: TGUID = '{9DA0EB90-6620-472B-AD8A-66AFBB5FD491}';
  CLASS_ATCoMsgWDM: TGUID = '{6EEEC495-3323-11D4-9D23-00A0C9768F70}';
  IID__clsAttributeWDM: TGUID = '{C341FCE6-8625-44DF-9E03-D9A84BAB3B4E}';
  CLASS_clsAttributeWDM: TGUID = '{6EEEC4A3-3323-11D4-9D23-00A0C9768F70}';
  IID__clsTSerSWMM: TGUID = '{D1B8E967-0207-46D6-A799-EEA5D2B65977}';
  CLASS_clsTSerSWMM: TGUID = '{481C1FC4-B4B1-11D4-9D23-000102CAA85C}';
  IID__clsTSerEFDC: TGUID = '{4622EB11-1718-43F7-A015-06FAB5C46981}';
  CLASS_clsTSerEFDC: TGUID = '{8C5F83C3-4AEA-11D5-9846-00A024C11E04}';
  IID__ATCclsAnalysis: TGUID = '{C7E62228-B5DF-4F3A-A008-1EED7EBF509F}';
  CLASS_ATCclsAnalysis: TGUID = '{6D6BAFE7-3442-47C4-BEE0-1C0AC590AC1E}';
  IID__clsATCTable: TGUID = '{00223690-530F-475F-91E5-1B7C9879AF34}';
  CLASS_clsATCTable: TGUID = '{AB115A1E-D7F5-4CD9-BBCE-E9FBCECF6CBC}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum ATCsToken
type
  ATCsToken = TOleEnum;
const
  tok_Unknown = $00000000;
  tok_And = $00000001;
  tok_ATCScript = $00000002;
  tok_Attribute = $00000003;
  tok_ColumnFormat = $00000004;
  tok_Comment = $00000005;
  tok_Dataset = $00000006;
  tok_Date = $00000007;
  tok_FatalError = $00000008;
  tok_Fill = $00000009;
  tok_Flag = $0000000A;
  tok_For = $0000000B;
  tok_If = $0000000C;
  tok_In = $0000000D;
  tok_Increment = $0000000E;
  tok_Instr = $0000000F;
  tok_IsNumeric = $00000010;
  tok_LineEnd = $00000011;
  tok_Literal = $00000012;
  tok_MathAdd = $00000013;
  tok_MathDivide = $00000014;
  tok_MathMultiply = $00000015;
  tok_MathPower = $00000016;
  tok_MathSubtract = $00000017;
  tok_Mid = $00000018;
  tok_NextLine = $00000019;
  tok_Not = $0000001A;
  tok_Or = $0000001B;
  tok_Set = $0000001C;
  tok_Test = $0000001D;
  tok_Trim = $0000001E;
  tok_Unset = $0000001F;
  tok_Value = $00000020;
  tok_Variable = $00000021;
  tok_Warn = $00000022;
  tok_While = $00000023;
  tok_GT = $00000024;
  tok_GE = $00000025;
  tok_LT = $00000026;
  tok_LE = $00000027;
  tok_NE = $00000028;
  tok_EQ = $00000029;
  tok_Last = $0000002A;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _ATComponentCatalog = interface;
  _ATComponentCatalogDisp = dispinterface;
  _clsTSerMemory = interface;
  _clsTSerMemoryDisp = dispinterface;
  _clsTSerPltgen = interface;
  _clsTSerPltgenDisp = dispinterface;
  _clsTSerSWATDbf = interface;
  _clsTSerSWATDbfDisp = dispinterface;
  _clsTSerBasObsWQ = interface;
  _clsTSerBasObsWQDisp = dispinterface;
  _clsTSerFEO = interface;
  _clsTSerFEODisp = dispinterface;
  _clsTSerRDB = interface;
  _clsTSerRDBDisp = dispinterface;
  _clsTSerWDM = interface;
  _clsTSerWDMDisp = dispinterface;
  _clsATCscriptExpression = interface;
  _clsATCscriptExpressionDisp = dispinterface;
  _ATCoMsgWDM = interface;
  _ATCoMsgWDMDisp = dispinterface;
  _clsAttributeWDM = interface;
  _clsAttributeWDMDisp = dispinterface;
  _clsTSerSWMM = interface;
  _clsTSerSWMMDisp = dispinterface;
  _clsTSerEFDC = interface;
  _clsTSerEFDCDisp = dispinterface;
  _ATCclsAnalysis = interface;
  _ATCclsAnalysisDisp = dispinterface;
  _clsATCTable = interface;
  _clsATCTableDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ATComponentCatalog = _ATComponentCatalog;
  clsTSerMemory = _clsTSerMemory;
  clsTSerPltgen = _clsTSerPltgen;
  clsTSerSWATDbf = _clsTSerSWATDbf;
  clsTSerBasObsWQ = _clsTSerBasObsWQ;
  clsTSerFEO = _clsTSerFEO;
  clsTSerRDB = _clsTSerRDB;
  clsTSerWDM = _clsTSerWDM;
  clsATCscriptExpression = _clsATCscriptExpression;
  ATCoMsgWDM = _ATCoMsgWDM;
  clsAttributeWDM = _clsAttributeWDM;
  clsTSerSWMM = _clsTSerSWMM;
  clsTSerEFDC = _clsTSerEFDC;
  ATCclsAnalysis = _ATCclsAnalysis;
  clsATCTable = _clsATCTable;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//

  clsAttributeWDM___v0 = _clsAttributeWDM; 

  BasinsInfo = packed record
    desc: WideString;
    Nam: WideString;
    Elev: Single;
    sdat: array[0..3] of Integer;
    edat: array[0..3] of Integer;
    EvapCoef: Single;
    dsn: array[0..7] of Integer;
  end;

  ColDef = packed record
    Name: WideString;
    StartCol: Integer;
    ColWidth: Integer;
  end;


// *********************************************************************//
// Interface: _ATComponentCatalog
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2B7BFF7A-D483-46D8-BB2B-91C5E0169F8F}
// *********************************************************************//
  _ATComponentCatalog = interface(IDispatch)
    ['{2B7BFF7A-D483-46D8-BB2B-91C5E0169F8F}']
  end;

// *********************************************************************//
// DispIntf:  _ATComponentCatalogDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2B7BFF7A-D483-46D8-BB2B-91C5E0169F8F}
// *********************************************************************//
  _ATComponentCatalogDisp = dispinterface
    ['{2B7BFF7A-D483-46D8-BB2B-91C5E0169F8F}']
  end;

// *********************************************************************//
// Interface: _clsTSerMemory
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {76009B55-97DE-4452-BFB3-0D48EB6CBF08}
// *********************************************************************//
  _clsTSerMemory = interface(IDispatch)
    ['{76009B55-97DE-4452-BFB3-0D48EB6CBF08}']
    procedure GhostMethod__clsTSerMemory_28_1; safecall;
    procedure GhostMethod__clsTSerMemory_32_2; safecall;
    procedure GhostMethod__clsTSerMemory_36_3; safecall;
    function Get_ATCclsTserFile_Description: WideString; safecall;
    property ATCclsTserFile_Description: WideString read Get_ATCclsTserFile_Description;
  end;

// *********************************************************************//
// DispIntf:  _clsTSerMemoryDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {76009B55-97DE-4452-BFB3-0D48EB6CBF08}
// *********************************************************************//
  _clsTSerMemoryDisp = dispinterface
    ['{76009B55-97DE-4452-BFB3-0D48EB6CBF08}']
    procedure GhostMethod__clsTSerMemory_28_1; dispid 1610743808;
    procedure GhostMethod__clsTSerMemory_32_2; dispid 1610743809;
    procedure GhostMethod__clsTSerMemory_36_3; dispid 1610743810;
    property ATCclsTserFile_Description: WideString readonly dispid 1745027073;
  end;

// *********************************************************************//
// Interface: _clsTSerPltgen
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {90C8E6C5-FA5C-40B3-9A11-F4E4229554B3}
// *********************************************************************//
  _clsTSerPltgen = interface(IDispatch)
    ['{90C8E6C5-FA5C-40B3-9A11-F4E4229554B3}']
  end;

// *********************************************************************//
// DispIntf:  _clsTSerPltgenDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {90C8E6C5-FA5C-40B3-9A11-F4E4229554B3}
// *********************************************************************//
  _clsTSerPltgenDisp = dispinterface
    ['{90C8E6C5-FA5C-40B3-9A11-F4E4229554B3}']
  end;

// *********************************************************************//
// Interface: _clsTSerSWATDbf
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {9A7CD237-994A-45DD-B2D9-9B0E2BD09723}
// *********************************************************************//
  _clsTSerSWATDbf = interface(IDispatch)
    ['{9A7CD237-994A-45DD-B2D9-9B0E2BD09723}']
  end;

// *********************************************************************//
// DispIntf:  _clsTSerSWATDbfDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {9A7CD237-994A-45DD-B2D9-9B0E2BD09723}
// *********************************************************************//
  _clsTSerSWATDbfDisp = dispinterface
    ['{9A7CD237-994A-45DD-B2D9-9B0E2BD09723}']
  end;

// *********************************************************************//
// Interface: _clsTSerBasObsWQ
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {199268F7-1711-41E1-9641-9D2E62D7FB51}
// *********************************************************************//
  _clsTSerBasObsWQ = interface(IDispatch)
    ['{199268F7-1711-41E1-9641-9D2E62D7FB51}']
  end;

// *********************************************************************//
// DispIntf:  _clsTSerBasObsWQDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {199268F7-1711-41E1-9641-9D2E62D7FB51}
// *********************************************************************//
  _clsTSerBasObsWQDisp = dispinterface
    ['{199268F7-1711-41E1-9641-9D2E62D7FB51}']
  end;

// *********************************************************************//
// Interface: _clsTSerFEO
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {E0ADDEDD-D6AD-4287-BED8-DBF27E0DAF82}
// *********************************************************************//
  _clsTSerFEO = interface(IDispatch)
    ['{E0ADDEDD-D6AD-4287-BED8-DBF27E0DAF82}']
  end;

// *********************************************************************//
// DispIntf:  _clsTSerFEODisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {E0ADDEDD-D6AD-4287-BED8-DBF27E0DAF82}
// *********************************************************************//
  _clsTSerFEODisp = dispinterface
    ['{E0ADDEDD-D6AD-4287-BED8-DBF27E0DAF82}']
  end;

// *********************************************************************//
// Interface: _clsTSerRDB
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4F75C6B7-DE05-4DA2-8BF5-F600793AF283}
// *********************************************************************//
  _clsTSerRDB = interface(IDispatch)
    ['{4F75C6B7-DE05-4DA2-8BF5-F600793AF283}']
  end;

// *********************************************************************//
// DispIntf:  _clsTSerRDBDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4F75C6B7-DE05-4DA2-8BF5-F600793AF283}
// *********************************************************************//
  _clsTSerRDBDisp = dispinterface
    ['{4F75C6B7-DE05-4DA2-8BF5-F600793AF283}']
  end;

// *********************************************************************//
// Interface: _clsTSerWDM
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {F8620F3D-0C75-4D4F-B1F5-2807415565E4}
// *********************************************************************//
  _clsTSerWDM = interface(IDispatch)
    ['{F8620F3D-0C75-4D4F-B1F5-2807415565E4}']
    procedure GhostMethod__clsTSerWDM_28_1; safecall;
    procedure GhostMethod__clsTSerWDM_32_2; safecall;
    procedure GhostMethod__clsTSerWDM_36_3; safecall;
    function Get_MsgUnit: Integer; safecall;
    procedure Set_MsgUnit(var Param1: Integer); safecall;
    procedure ATCclsTserFile_refresh; safecall;
    function GetDataSetFromDsn(var lDsn: Integer): _ATCclsTserData; safecall;
    procedure RefreshDsn(var dsn: Integer); safecall;
    function ReadBasInf: WordBool; safecall;
    property MsgUnit: Integer read Get_MsgUnit write Set_MsgUnit;
  end;

// *********************************************************************//
// DispIntf:  _clsTSerWDMDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {F8620F3D-0C75-4D4F-B1F5-2807415565E4}
// *********************************************************************//
  _clsTSerWDMDisp = dispinterface
    ['{F8620F3D-0C75-4D4F-B1F5-2807415565E4}']
    procedure GhostMethod__clsTSerWDM_28_1; dispid 1610743808;
    procedure GhostMethod__clsTSerWDM_32_2; dispid 1610743809;
    procedure GhostMethod__clsTSerWDM_36_3; dispid 1610743810;
    property MsgUnit: Integer dispid 1745027118;
    procedure ATCclsTserFile_refresh; dispid 1610809405;
    function GetDataSetFromDsn(var lDsn: Integer): _ATCclsTserData; dispid 1610809406;
    procedure RefreshDsn(var dsn: Integer); dispid 1610809407;
    function ReadBasInf: WordBool; dispid 1610809419;
  end;

// *********************************************************************//
// Interface: _clsATCscriptExpression
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {0C86C872-858F-4CFC-895E-3873ADD3E99D}
// *********************************************************************//
  _clsATCscriptExpression = interface(IDispatch)
    ['{0C86C872-858F-4CFC-895E-3873ADD3E99D}']
    procedure GhostMethod__clsATCscriptExpression_28_1; safecall;
    procedure GhostMethod__clsATCscriptExpression_32_2; safecall;
    procedure GhostMethod__clsATCscriptExpression_36_3; safecall;
    procedure GhostMethod__clsATCscriptExpression_40_4; safecall;
    procedure GhostMethod__clsATCscriptExpression_44_5; safecall;
    procedure GhostMethod__clsATCscriptExpression_48_6; safecall;
    procedure GhostMethod__clsATCscriptExpression_52_7; safecall;
    procedure GhostMethod__clsATCscriptExpression_56_8; safecall;
    procedure GhostMethod__clsATCscriptExpression_60_9; safecall;
    procedure GhostMethod__clsATCscriptExpression_64_10; safecall;
    procedure GhostMethod__clsATCscriptExpression_68_11; safecall;
    procedure GhostMethod__clsATCscriptExpression_72_12; safecall;
    function Get_Line: Integer; safecall;
    procedure Set_Line(var Param1: Integer); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_Token: ATCsToken; safecall;
    procedure Set_Token(var Param1: ATCsToken); safecall;
    function Get_SubExpressionCount: Integer; safecall;
    function Get_SubExpression(var index: Integer): _clsATCscriptExpression; safecall;
    function TokenFromString(var str: WideString): Integer; safecall;
    function Printable(var indent: WideString; var indentIncrement: WideString): WideString; safecall;
    procedure ParseExpression(var buf: WideString); safecall;
    function Evaluate: WideString; safecall;
    property Line: Integer read Get_Line write Set_Line;
    property Name: WideString read Get_Name write Set_Name;
    property Token: ATCsToken read Get_Token write Set_Token;
    property SubExpressionCount: Integer read Get_SubExpressionCount;
    property SubExpression[var index: Integer]: _clsATCscriptExpression read Get_SubExpression;
  end;

// *********************************************************************//
// DispIntf:  _clsATCscriptExpressionDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {0C86C872-858F-4CFC-895E-3873ADD3E99D}
// *********************************************************************//
  _clsATCscriptExpressionDisp = dispinterface
    ['{0C86C872-858F-4CFC-895E-3873ADD3E99D}']
    procedure GhostMethod__clsATCscriptExpression_28_1; dispid 1610743808;
    procedure GhostMethod__clsATCscriptExpression_32_2; dispid 1610743809;
    procedure GhostMethod__clsATCscriptExpression_36_3; dispid 1610743810;
    procedure GhostMethod__clsATCscriptExpression_40_4; dispid 1610743811;
    procedure GhostMethod__clsATCscriptExpression_44_5; dispid 1610743812;
    procedure GhostMethod__clsATCscriptExpression_48_6; dispid 1610743813;
    procedure GhostMethod__clsATCscriptExpression_52_7; dispid 1610743814;
    procedure GhostMethod__clsATCscriptExpression_56_8; dispid 1610743815;
    procedure GhostMethod__clsATCscriptExpression_60_9; dispid 1610743816;
    procedure GhostMethod__clsATCscriptExpression_64_10; dispid 1610743817;
    procedure GhostMethod__clsATCscriptExpression_68_11; dispid 1610743818;
    procedure GhostMethod__clsATCscriptExpression_72_12; dispid 1610743819;
    property Line: Integer dispid 1745027110;
    property Name: WideString dispid 1745027109;
    property Token: ATCsToken dispid 1745027108;
    property SubExpressionCount: Integer readonly dispid 1745027107;
    property SubExpression[var index: Integer]: _clsATCscriptExpression readonly dispid 1745027106;
    function TokenFromString(var str: WideString): Integer; dispid 1610809384;
    function Printable(var indent: WideString; var indentIncrement: WideString): WideString; dispid 1610809385;
    procedure ParseExpression(var buf: WideString); dispid 1610809390;
    function Evaluate: WideString; dispid 1610809394;
  end;

// *********************************************************************//
// Interface: _ATCoMsgWDM
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {9DA0EB90-6620-472B-AD8A-66AFBB5FD491}
// *********************************************************************//
  _ATCoMsgWDM = interface(IDispatch)
    ['{9DA0EB90-6620-472B-AD8A-66AFBB5FD491}']
    procedure Set_MsgUnit(var Param1: Integer); safecall;
    function Get_Attrib(var AttrName: WideString): _clsAttributeWDM; safecall;
    function Get_Attributes: _Collection; safecall;
    property MsgUnit: Integer write Set_MsgUnit;
    property Attrib[var AttrName: WideString]: _clsAttributeWDM read Get_Attrib;
    property Attributes: _Collection read Get_Attributes;
  end;

// *********************************************************************//
// DispIntf:  _ATCoMsgWDMDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {9DA0EB90-6620-472B-AD8A-66AFBB5FD491}
// *********************************************************************//
  _ATCoMsgWDMDisp = dispinterface
    ['{9DA0EB90-6620-472B-AD8A-66AFBB5FD491}']
    property MsgUnit: Integer writeonly dispid 1745027079;
    property Attrib[var AttrName: WideString]: _clsAttributeWDM readonly dispid 1745027078;
    property Attributes: _Collection readonly dispid 1745027077;
  end;

// *********************************************************************//
// Interface: _clsAttributeWDM
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C341FCE6-8625-44DF-9E03-D9A84BAB3B4E}
// *********************************************************************//
  _clsAttributeWDM = interface(IDispatch)
    ['{C341FCE6-8625-44DF-9E03-D9A84BAB3B4E}']
    procedure GhostMethod__clsAttributeWDM_28_1; safecall;
    procedure GhostMethod__clsAttributeWDM_32_2; safecall;
    procedure GhostMethod__clsAttributeWDM_36_3; safecall;
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
    function Get_Ind: Integer; safecall;
    procedure Set_Ind(var Param1: Integer); safecall;
    function Get_ilen: Integer; safecall;
    procedure Set_ilen(var Param1: Integer); safecall;
    function Get_hlen: Integer; safecall;
    procedure Set_hlen(var Param1: Integer); safecall;
    function Get_hrec: Integer; safecall;
    procedure Set_hrec(var Param1: Integer); safecall;
    function Get_hpos: Integer; safecall;
    procedure Set_hpos(var Param1: Integer); safecall;
    function Get_vlen: Integer; safecall;
    procedure Set_vlen(var Param1: Integer); safecall;
    procedure GhostMethod__clsAttributeWDM_144_4; safecall;
    procedure GhostMethod__clsAttributeWDM_148_5; safecall;
    procedure GhostMethod__clsAttributeWDM_152_6; safecall;
    function Get_ATCclsAttributeDefinition_Editable: WordBool; safecall;
    procedure Set_ATCclsAttributeDefinition_Editable(var Param1: WordBool); safecall;
    function Get_Editable: WordBool; safecall;
    procedure Set_Editable(var Param1: WordBool); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Description: WideString read Get_Description write Set_Description;
    property DataType: ATCoDataType read Get_DataType write Set_DataType;
    property Min: Single read Get_Min write Set_Min;
    property Max: Single read Get_Max write Set_Max;
    property ValidValues: WideString read Get_ValidValues write Set_ValidValues;
    property Default: Single read Get_Default write Set_Default;
    property Ind: Integer read Get_Ind write Set_Ind;
    property ilen: Integer read Get_ilen write Set_ilen;
    property hlen: Integer read Get_hlen write Set_hlen;
    property hrec: Integer read Get_hrec write Set_hrec;
    property hpos: Integer read Get_hpos write Set_hpos;
    property vlen: Integer read Get_vlen write Set_vlen;
    property ATCclsAttributeDefinition_Editable: WordBool read Get_ATCclsAttributeDefinition_Editable write Set_ATCclsAttributeDefinition_Editable;
    property Editable: WordBool read Get_Editable write Set_Editable;
  end;

// *********************************************************************//
// DispIntf:  _clsAttributeWDMDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C341FCE6-8625-44DF-9E03-D9A84BAB3B4E}
// *********************************************************************//
  _clsAttributeWDMDisp = dispinterface
    ['{C341FCE6-8625-44DF-9E03-D9A84BAB3B4E}']
    procedure GhostMethod__clsAttributeWDM_28_1; dispid 1610743808;
    procedure GhostMethod__clsAttributeWDM_32_2; dispid 1610743809;
    procedure GhostMethod__clsAttributeWDM_36_3; dispid 1610743810;
    property Name: WideString dispid 1745027110;
    property Description: WideString dispid 1745027109;
    property DataType: ATCoDataType dispid 1745027108;
    property Min: Single dispid 1745027107;
    property Max: Single dispid 1745027106;
    property ValidValues: WideString dispid 1745027105;
    property Default: Single dispid 1745027104;
    property Ind: Integer dispid 1745027103;
    property ilen: Integer dispid 1745027102;
    property hlen: Integer dispid 1745027101;
    property hrec: Integer dispid 1745027100;
    property hpos: Integer dispid 1745027099;
    property vlen: Integer dispid 1745027098;
    procedure GhostMethod__clsAttributeWDM_144_4; dispid 1610743837;
    procedure GhostMethod__clsAttributeWDM_148_5; dispid 1610743838;
    procedure GhostMethod__clsAttributeWDM_152_6; dispid 1610743839;
    property ATCclsAttributeDefinition_Editable: WordBool dispid 1745027116;
    property Editable: WordBool dispid 1745027111;
  end;

// *********************************************************************//
// Interface: _clsTSerSWMM
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {D1B8E967-0207-46D6-A799-EEA5D2B65977}
// *********************************************************************//
  _clsTSerSWMM = interface(IDispatch)
    ['{D1B8E967-0207-46D6-A799-EEA5D2B65977}']
    procedure GhostMethod__clsTSerSWMM_28_1; safecall;
    procedure GhostMethod__clsTSerSWMM_32_2; safecall;
    procedure GhostMethod__clsTSerSWMM_36_3; safecall;
    procedure SwmmRead; safecall;
  end;

// *********************************************************************//
// DispIntf:  _clsTSerSWMMDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {D1B8E967-0207-46D6-A799-EEA5D2B65977}
// *********************************************************************//
  _clsTSerSWMMDisp = dispinterface
    ['{D1B8E967-0207-46D6-A799-EEA5D2B65977}']
    procedure GhostMethod__clsTSerSWMM_28_1; dispid 1610743808;
    procedure GhostMethod__clsTSerSWMM_32_2; dispid 1610743809;
    procedure GhostMethod__clsTSerSWMM_36_3; dispid 1610743810;
    procedure SwmmRead; dispid 1610809394;
  end;

// *********************************************************************//
// Interface: _clsTSerEFDC
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4622EB11-1718-43F7-A015-06FAB5C46981}
// *********************************************************************//
  _clsTSerEFDC = interface(IDispatch)
    ['{4622EB11-1718-43F7-A015-06FAB5C46981}']
  end;

// *********************************************************************//
// DispIntf:  _clsTSerEFDCDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4622EB11-1718-43F7-A015-06FAB5C46981}
// *********************************************************************//
  _clsTSerEFDCDisp = dispinterface
    ['{4622EB11-1718-43F7-A015-06FAB5C46981}']
  end;

// *********************************************************************//
// Interface: _ATCclsAnalysis
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C7E62228-B5DF-4F3A-A008-1EED7EBF509F}
// *********************************************************************//
  _ATCclsAnalysis = interface(IDispatch)
    ['{C7E62228-B5DF-4F3A-A008-1EED7EBF509F}']
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
// GUID:      {C7E62228-B5DF-4F3A-A008-1EED7EBF509F}
// *********************************************************************//
  _ATCclsAnalysisDisp = dispinterface
    ['{C7E62228-B5DF-4F3A-A008-1EED7EBF509F}']
    property ErrorDescription: WideString readonly dispid 1745027075;
    property Description: WideString readonly dispid 1745027074;
    procedure Go; dispid 1610809349;
    function EditSpecification: WordBool; dispid 1610809350;
    property Specification: WideString dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _clsATCTable
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {00223690-530F-475F-91E5-1B7C9879AF34}
// *********************************************************************//
  _clsATCTable = interface(IDispatch)
    ['{00223690-530F-475F-91E5-1B7C9879AF34}']
    function OpenFile(const filename: WideString): _clsATCTable; safecall;
    procedure WriteFile(const filename: WideString); safecall;
    procedure ClearData; safecall;
    procedure Clear; safecall;
    function Get_NumRecords: Integer; safecall;
    procedure Set_NumRecords(Param1: Integer); safecall;
    function Get_NumFields: Integer; safecall;
    procedure Set_NumFields(Param1: Integer); safecall;
    function Get_CurrentRecord: Integer; safecall;
    procedure Set_CurrentRecord(Param1: Integer); safecall;
    function Get_Value(aFieldNumber: Integer): WideString; safecall;
    procedure Set_Value(aFieldNumber: Integer; const Param2: WideString); safecall;
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    procedure MoveFirst; safecall;
    procedure MoveLast; safecall;
    procedure MoveNext; safecall;
    procedure MovePrevious; safecall;
    function Summary(var aFormat: WideString): WideString; safecall;
    function SummaryFile(var aFormat: WideString): WideString; safecall;
    function SummaryFields(var aFormat: WideString): WideString; safecall;
    function CreationCode: WideString; safecall;
    function Cousin: _clsATCTable; safecall;
    function Get_FieldName(aFieldNumber: Integer): WideString; safecall;
    procedure Set_FieldName(aFieldNumber: Integer; const Param2: WideString); safecall;
    function FieldNumber(const aFieldName: WideString): Integer; safecall;
    function Get_FieldLength(aFieldNumber: Integer): Integer; safecall;
    procedure Set_FieldLength(aFieldNumber: Integer; Param2: Integer); safecall;
    function Get_FieldType(aFieldNumber: Integer): WideString; safecall;
    procedure Set_FieldType(aFieldNumber: Integer; const Param2: WideString); safecall;
    function Get_filename: WideString; safecall;
    function FindFirst(aFieldNumber: Integer; var aFindValue: WideString; aStartRecord: Integer; 
                       aEndRecord: Integer): WordBool; safecall;
    function FindNext(aFieldNumber: Integer; var aFindValue: WideString): WordBool; safecall;
    property NumRecords: Integer read Get_NumRecords write Set_NumRecords;
    property NumFields: Integer read Get_NumFields write Set_NumFields;
    property CurrentRecord: Integer read Get_CurrentRecord write Set_CurrentRecord;
    property Value[aFieldNumber: Integer]: WideString read Get_Value write Set_Value;
    property FieldName[aFieldNumber: Integer]: WideString read Get_FieldName write Set_FieldName;
    property FieldLength[aFieldNumber: Integer]: Integer read Get_FieldLength write Set_FieldLength;
    property FieldType[aFieldNumber: Integer]: WideString read Get_FieldType write Set_FieldType;
    property filename: WideString read Get_filename;
  end;

// *********************************************************************//
// DispIntf:  _clsATCTableDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {00223690-530F-475F-91E5-1B7C9879AF34}
// *********************************************************************//
  _clsATCTableDisp = dispinterface
    ['{00223690-530F-475F-91E5-1B7C9879AF34}']
    function OpenFile(const filename: WideString): _clsATCTable; dispid 1610809352;
    procedure WriteFile(const filename: WideString); dispid 1610809353;
    procedure ClearData; dispid 1610809354;
    procedure Clear; dispid 1610809355;
    property NumRecords: Integer dispid 1745027079;
    property NumFields: Integer dispid 1745027078;
    property CurrentRecord: Integer dispid 1745027077;
    property Value[aFieldNumber: Integer]: WideString dispid 1745027076;
    function BOF: WordBool; dispid 1610809356;
    function EOF: WordBool; dispid 1610809357;
    procedure MoveFirst; dispid 1610809358;
    procedure MoveLast; dispid 1610809359;
    procedure MoveNext; dispid 1610809360;
    procedure MovePrevious; dispid 1610809361;
    function Summary(var aFormat: WideString): WideString; dispid 1610809362;
    function SummaryFile(var aFormat: WideString): WideString; dispid 1610809363;
    function SummaryFields(var aFormat: WideString): WideString; dispid 1610809364;
    function CreationCode: WideString; dispid 1610809365;
    function Cousin: _clsATCTable; dispid 1610809366;
    property FieldName[aFieldNumber: Integer]: WideString dispid 1745027075;
    function FieldNumber(const aFieldName: WideString): Integer; dispid 1610809367;
    property FieldLength[aFieldNumber: Integer]: Integer dispid 1745027074;
    property FieldType[aFieldNumber: Integer]: WideString dispid 1745027073;
    property filename: WideString readonly dispid 1745027072;
    function FindFirst(aFieldNumber: Integer; var aFindValue: WideString; aStartRecord: Integer; 
                       aEndRecord: Integer): WordBool; dispid 1610809369;
    function FindNext(aFieldNumber: Integer; var aFindValue: WideString): WordBool; dispid 1610809370;
  end;

// *********************************************************************//
// The Class CoATComponentCatalog provides a Create and CreateRemote method to          
// create instances of the default interface _ATComponentCatalog exposed by              
// the CoClass ATComponentCatalog. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATComponentCatalog = class
    class function Create: _ATComponentCatalog;
    class function CreateRemote(const MachineName: string): _ATComponentCatalog;
  end;

// *********************************************************************//
// The Class CoclsTSerMemory provides a Create and CreateRemote method to          
// create instances of the default interface _clsTSerMemory exposed by              
// the CoClass clsTSerMemory. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoclsTSerMemory = class
    class function Create: _clsTSerMemory;
    class function CreateRemote(const MachineName: string): _clsTSerMemory;
  end;

// *********************************************************************//
// The Class CoclsTSerPltgen provides a Create and CreateRemote method to          
// create instances of the default interface _clsTSerPltgen exposed by              
// the CoClass clsTSerPltgen. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoclsTSerPltgen = class
    class function Create: _clsTSerPltgen;
    class function CreateRemote(const MachineName: string): _clsTSerPltgen;
  end;

// *********************************************************************//
// The Class CoclsTSerSWATDbf provides a Create and CreateRemote method to          
// create instances of the default interface _clsTSerSWATDbf exposed by              
// the CoClass clsTSerSWATDbf. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoclsTSerSWATDbf = class
    class function Create: _clsTSerSWATDbf;
    class function CreateRemote(const MachineName: string): _clsTSerSWATDbf;
  end;

// *********************************************************************//
// The Class CoclsTSerBasObsWQ provides a Create and CreateRemote method to          
// create instances of the default interface _clsTSerBasObsWQ exposed by              
// the CoClass clsTSerBasObsWQ. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoclsTSerBasObsWQ = class
    class function Create: _clsTSerBasObsWQ;
    class function CreateRemote(const MachineName: string): _clsTSerBasObsWQ;
  end;

// *********************************************************************//
// The Class CoclsTSerFEO provides a Create and CreateRemote method to          
// create instances of the default interface _clsTSerFEO exposed by              
// the CoClass clsTSerFEO. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoclsTSerFEO = class
    class function Create: _clsTSerFEO;
    class function CreateRemote(const MachineName: string): _clsTSerFEO;
  end;

// *********************************************************************//
// The Class CoclsTSerRDB provides a Create and CreateRemote method to          
// create instances of the default interface _clsTSerRDB exposed by              
// the CoClass clsTSerRDB. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoclsTSerRDB = class
    class function Create: _clsTSerRDB;
    class function CreateRemote(const MachineName: string): _clsTSerRDB;
  end;

// *********************************************************************//
// The Class CoclsTSerWDM provides a Create and CreateRemote method to          
// create instances of the default interface _clsTSerWDM exposed by              
// the CoClass clsTSerWDM. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoclsTSerWDM = class
    class function Create: _clsTSerWDM;
    class function CreateRemote(const MachineName: string): _clsTSerWDM;
  end;

// *********************************************************************//
// The Class CoclsATCscriptExpression provides a Create and CreateRemote method to          
// create instances of the default interface _clsATCscriptExpression exposed by              
// the CoClass clsATCscriptExpression. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoclsATCscriptExpression = class
    class function Create: _clsATCscriptExpression;
    class function CreateRemote(const MachineName: string): _clsATCscriptExpression;
  end;

// *********************************************************************//
// The Class CoATCoMsgWDM provides a Create and CreateRemote method to          
// create instances of the default interface _ATCoMsgWDM exposed by              
// the CoClass ATCoMsgWDM. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoATCoMsgWDM = class
    class function Create: _ATCoMsgWDM;
    class function CreateRemote(const MachineName: string): _ATCoMsgWDM;
  end;

// *********************************************************************//
// The Class CoclsAttributeWDM provides a Create and CreateRemote method to          
// create instances of the default interface _clsAttributeWDM exposed by              
// the CoClass clsAttributeWDM. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoclsAttributeWDM = class
    class function Create: _clsAttributeWDM;
    class function CreateRemote(const MachineName: string): _clsAttributeWDM;
  end;

// *********************************************************************//
// The Class CoclsTSerSWMM provides a Create and CreateRemote method to          
// create instances of the default interface _clsTSerSWMM exposed by              
// the CoClass clsTSerSWMM. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoclsTSerSWMM = class
    class function Create: _clsTSerSWMM;
    class function CreateRemote(const MachineName: string): _clsTSerSWMM;
  end;

// *********************************************************************//
// The Class CoclsTSerEFDC provides a Create and CreateRemote method to          
// create instances of the default interface _clsTSerEFDC exposed by              
// the CoClass clsTSerEFDC. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoclsTSerEFDC = class
    class function Create: _clsTSerEFDC;
    class function CreateRemote(const MachineName: string): _clsTSerEFDC;
  end;

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
// The Class CoclsATCTable provides a Create and CreateRemote method to          
// create instances of the default interface _clsATCTable exposed by              
// the CoClass clsATCTable. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoclsATCTable = class
    class function Create: _clsATCTable;
    class function CreateRemote(const MachineName: string): _clsATCTable;
  end;

implementation

uses ComObj;

class function CoATComponentCatalog.Create: _ATComponentCatalog;
begin
  Result := CreateComObject(CLASS_ATComponentCatalog) as _ATComponentCatalog;
end;

class function CoATComponentCatalog.CreateRemote(const MachineName: string): _ATComponentCatalog;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATComponentCatalog) as _ATComponentCatalog;
end;

class function CoclsTSerMemory.Create: _clsTSerMemory;
begin
  Result := CreateComObject(CLASS_clsTSerMemory) as _clsTSerMemory;
end;

class function CoclsTSerMemory.CreateRemote(const MachineName: string): _clsTSerMemory;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_clsTSerMemory) as _clsTSerMemory;
end;

class function CoclsTSerPltgen.Create: _clsTSerPltgen;
begin
  Result := CreateComObject(CLASS_clsTSerPltgen) as _clsTSerPltgen;
end;

class function CoclsTSerPltgen.CreateRemote(const MachineName: string): _clsTSerPltgen;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_clsTSerPltgen) as _clsTSerPltgen;
end;

class function CoclsTSerSWATDbf.Create: _clsTSerSWATDbf;
begin
  Result := CreateComObject(CLASS_clsTSerSWATDbf) as _clsTSerSWATDbf;
end;

class function CoclsTSerSWATDbf.CreateRemote(const MachineName: string): _clsTSerSWATDbf;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_clsTSerSWATDbf) as _clsTSerSWATDbf;
end;

class function CoclsTSerBasObsWQ.Create: _clsTSerBasObsWQ;
begin
  Result := CreateComObject(CLASS_clsTSerBasObsWQ) as _clsTSerBasObsWQ;
end;

class function CoclsTSerBasObsWQ.CreateRemote(const MachineName: string): _clsTSerBasObsWQ;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_clsTSerBasObsWQ) as _clsTSerBasObsWQ;
end;

class function CoclsTSerFEO.Create: _clsTSerFEO;
begin
  Result := CreateComObject(CLASS_clsTSerFEO) as _clsTSerFEO;
end;

class function CoclsTSerFEO.CreateRemote(const MachineName: string): _clsTSerFEO;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_clsTSerFEO) as _clsTSerFEO;
end;

class function CoclsTSerRDB.Create: _clsTSerRDB;
begin
  Result := CreateComObject(CLASS_clsTSerRDB) as _clsTSerRDB;
end;

class function CoclsTSerRDB.CreateRemote(const MachineName: string): _clsTSerRDB;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_clsTSerRDB) as _clsTSerRDB;
end;

class function CoclsTSerWDM.Create: _clsTSerWDM;
begin
  Result := CreateComObject(CLASS_clsTSerWDM) as _clsTSerWDM;
end;

class function CoclsTSerWDM.CreateRemote(const MachineName: string): _clsTSerWDM;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_clsTSerWDM) as _clsTSerWDM;
end;

class function CoclsATCscriptExpression.Create: _clsATCscriptExpression;
begin
  Result := CreateComObject(CLASS_clsATCscriptExpression) as _clsATCscriptExpression;
end;

class function CoclsATCscriptExpression.CreateRemote(const MachineName: string): _clsATCscriptExpression;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_clsATCscriptExpression) as _clsATCscriptExpression;
end;

class function CoATCoMsgWDM.Create: _ATCoMsgWDM;
begin
  Result := CreateComObject(CLASS_ATCoMsgWDM) as _ATCoMsgWDM;
end;

class function CoATCoMsgWDM.CreateRemote(const MachineName: string): _ATCoMsgWDM;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCoMsgWDM) as _ATCoMsgWDM;
end;

class function CoclsAttributeWDM.Create: _clsAttributeWDM;
begin
  Result := CreateComObject(CLASS_clsAttributeWDM) as _clsAttributeWDM;
end;

class function CoclsAttributeWDM.CreateRemote(const MachineName: string): _clsAttributeWDM;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_clsAttributeWDM) as _clsAttributeWDM;
end;

class function CoclsTSerSWMM.Create: _clsTSerSWMM;
begin
  Result := CreateComObject(CLASS_clsTSerSWMM) as _clsTSerSWMM;
end;

class function CoclsTSerSWMM.CreateRemote(const MachineName: string): _clsTSerSWMM;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_clsTSerSWMM) as _clsTSerSWMM;
end;

class function CoclsTSerEFDC.Create: _clsTSerEFDC;
begin
  Result := CreateComObject(CLASS_clsTSerEFDC) as _clsTSerEFDC;
end;

class function CoclsTSerEFDC.CreateRemote(const MachineName: string): _clsTSerEFDC;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_clsTSerEFDC) as _clsTSerEFDC;
end;

class function CoATCclsAnalysis.Create: _ATCclsAnalysis;
begin
  Result := CreateComObject(CLASS_ATCclsAnalysis) as _ATCclsAnalysis;
end;

class function CoATCclsAnalysis.CreateRemote(const MachineName: string): _ATCclsAnalysis;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ATCclsAnalysis) as _ATCclsAnalysis;
end;

class function CoclsATCTable.Create: _clsATCTable;
begin
  Result := CreateComObject(CLASS_clsATCTable) as _clsATCTable;
end;

class function CoclsATCTable.CreateRemote(const MachineName: string): _clsATCTable;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_clsATCTable) as _clsATCTable;
end;

end.
