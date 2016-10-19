//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit VBA_TLB;

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
// Type Lib: C:\WINDOWS\system32\MSVBVM60.dll (3)
// LIBID: {000204EF-0000-0000-C000-000000000046}
// LCID: 9
// Helpfile: C:\WINDOWS\system32\VBA.HLP
// HelpString: Visual Basic For Applications
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Parent TypeLibrary:
//   (0) v3.2 ATCTSfile, (C:\WINDOWS\system32\ATCTSfile.dll)
// Errors:
//   Hint: Member 'String' of '_HiddenInterface' changed to 'String_'
//   Hint: Member 'Raise' of '_ErrObject' changed to 'Raise_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  VBAMajorVersion = 6;
  VBAMinorVersion = 0;

  LIBID_VBA: TGUID = '{000204EF-0000-0000-C000-000000000046}';

  IID__HiddenInterface: TGUID = '{1E196B20-1F3C-1069-996B-00DD010EF676}';
  IID__ErrObject: TGUID = '{A4C466B8-499F-101B-BB78-00AA00383CBB}';
  CLASS_ErrObject: TGUID = '{A4C46654-499F-101B-BB78-00AA00383CBB}';
  IID__Collection: TGUID = '{A4C46780-499F-101B-BB78-00AA00383CBB}';
  CLASS_Collection: TGUID = '{A4C4671C-499F-101B-BB78-00AA00383CBB}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum VbVarType
type
  VbVarType = TOleEnum;
const
  vbEmpty = $00000000;
  vbNull = $00000001;
  vbInteger = $00000002;
  vbLong = $00000003;
  vbSingle = $00000004;
  vbDouble = $00000005;
  vbCurrency = $00000006;
  vbDate = $00000007;
  vbString = $00000008;
  vbObject = $00000009;
  vbError = $0000000A;
  vbBoolean = $0000000B;
  vbVariant = $0000000C;
  vbDataObject = $0000000D;
  vbDecimal = $0000000E;
  vbByte = $00000011;
  vbUserDefinedType = $00000024;
  vbArray = $00002000;

// Constants for enum VbMsgBoxStyle
type
  VbMsgBoxStyle = TOleEnum;
const
  vbOKOnly = $00000000;
  vbOKCancel = $00000001;
  vbAbortRetryIgnore = $00000002;
  vbYesNoCancel = $00000003;
  vbYesNo = $00000004;
  vbRetryCancel = $00000005;
  vbCritical = $00000010;
  vbQuestion = $00000020;
  vbExclamation = $00000030;
  vbInformation = $00000040;
  vbDefaultButton1 = $00000000;
  vbDefaultButton2 = $00000100;
  vbDefaultButton3 = $00000200;
  vbDefaultButton4 = $00000300;
  vbApplicationModal = $00000000;
  vbSystemModal = $00001000;
  vbMsgBoxHelpButton = $00004000;
  vbMsgBoxRight = $00080000;
  vbMsgBoxRtlReading = $00100000;
  vbMsgBoxSetForeground = $00010000;

// Constants for enum VbMsgBoxResult
type
  VbMsgBoxResult = TOleEnum;
const
  vbOK = $00000001;
  vbCancel = $00000002;
  vbAbort = $00000003;
  vbRetry = $00000004;
  vbIgnore = $00000005;
  vbYes = $00000006;
  vbNo = $00000007;

// Constants for enum VbFileAttribute
type
  VbFileAttribute = TOleEnum;
const
  vbNormal = $00000000;
  vbReadOnly = $00000001;
  vbHidden = $00000002;
  vbSystem = $00000004;
  vbVolume = $00000008;
  vbDirectory = $00000010;
  vbArchive = $00000020;
  vbAlias = $00000040;

// Constants for enum VbStrConv
type
  VbStrConv = TOleEnum;
const
  vbUpperCase = $00000001;
  vbLowerCase = $00000002;
  vbProperCase = $00000003;
  vbWide = $00000004;
  vbNarrow = $00000008;
  vbKatakana = $00000010;
  vbHiragana = $00000020;
  vbUnicode = $00000040;
  vbFromUnicode = $00000080;

// Constants for enum VbDayOfWeek
type
  VbDayOfWeek = TOleEnum;
const
  vbUseSystemDayOfWeek = $00000000;
  vbSunday = $00000001;
  vbMonday = $00000002;
  vbTuesday = $00000003;
  vbWednesday = $00000004;
  vbThursday = $00000005;
  vbFriday = $00000006;
  vbSaturday = $00000007;

// Constants for enum VbFirstWeekOfYear
type
  VbFirstWeekOfYear = TOleEnum;
const
  vbUseSystem = $00000000;
  vbFirstJan1 = $00000001;
  vbFirstFourDays = $00000002;
  vbFirstFullWeek = $00000003;

// Constants for enum VbIMEStatus
type
  VbIMEStatus = TOleEnum;
const
  vbIMENoOp = $00000000;
  vbIMEModeNoControl = $00000000;
  vbIMEOn = $00000001;
  vbIMEModeOn = $00000001;
  vbIMEOff = $00000002;
  vbIMEModeOff = $00000002;
  vbIMEDisable = $00000003;
  vbIMEModeDisable = $00000003;
  vbIMEHiragana = $00000004;
  vbIMEModeHiragana = $00000004;
  vbIMEKatakanaDbl = $00000005;
  vbIMEModeKatakana = $00000005;
  vbIMEKatakanaSng = $00000006;
  vbIMEModeKatakanaHalf = $00000006;
  vbIMEAlphaDbl = $00000007;
  vbIMEModeAlphaFull = $00000007;
  vbIMEAlphaSng = $00000008;
  vbIMEModeAlpha = $00000008;
  vbIMEModeHangulFull = $00000009;
  vbIMEModeHangul = $0000000A;

// Constants for enum VbAppWinStyle
type
  VbAppWinStyle = TOleEnum;
const
  vbHide = $00000000;
  vbNormalFocus = $00000001;
  vbMinimizedFocus = $00000002;
  vbMaximizedFocus = $00000003;
  vbNormalNoFocus = $00000004;
  vbMinimizedNoFocus = $00000006;

// Constants for enum VbCompareMethod
type
  VbCompareMethod = TOleEnum;
const
  vbBinaryCompare = $00000000;
  vbTextCompare = $00000001;
  vbDatabaseCompare = $00000002;

// Constants for enum VbCalendar
type
  VbCalendar = TOleEnum;
const
  vbCalGreg = $00000000;
  vbCalHijri = $00000001;

// Constants for enum VbDateTimeFormat
type
  VbDateTimeFormat = TOleEnum;
const
  vbGeneralDate = $00000000;
  vbLongDate = $00000001;
  vbShortDate = $00000002;
  vbLongTime = $00000003;
  vbShortTime = $00000004;

// Constants for enum VbTriState
type
  VbTriState = TOleEnum;
const
  vbUseDefault = $FFFFFFFE;
  vbTrue = $FFFFFFFF;
  vbFalse = $00000000;

// Constants for enum VbCallType
type
  VbCallType = TOleEnum;
const
  VbMethod = $00000001;
  VbGet = $00000002;
  VbLet = $00000004;
  VbSet = $00000008;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _HiddenInterface = interface;
  _ErrObject = interface;
  _ErrObjectDisp = dispinterface;
  _Collection = interface;
  _CollectionDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ErrObject = _ErrObject;
  Collection = _Collection;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}
  PPSafeArray1 = ^PSafeArray; {*}
  PPSafeArray2 = ^PSafeArray; {*}


// *********************************************************************//
// Interface: _HiddenInterface
// Flags:     (0)
// GUID:      {1E196B20-1F3C-1069-996B-00DD010EF676}
// *********************************************************************//
  _HiddenInterface = interface
    ['{1E196B20-1F3C-1069-996B-00DD010EF676}']
    procedure LCase; stdcall;
    procedure Left; stdcall;
    procedure LTrim; stdcall;
    procedure Right; stdcall;
    procedure RTrim; stdcall;
    procedure Space; stdcall;
    procedure Trim; stdcall;
    procedure String_; stdcall;
    procedure UCase; stdcall;
    procedure Str; stdcall;
    procedure Chr; stdcall;
    procedure Date; stdcall;
    procedure Time; stdcall;
    procedure Hex; stdcall;
    procedure Oct; stdcall;
    procedure LeftB; stdcall;
    procedure RightB; stdcall;
    procedure Mid; stdcall;
    procedure MidB; stdcall;
    procedure StrConv; stdcall;
    procedure Error; stdcall;
    procedure CurDir; stdcall;
    procedure Format; stdcall;
    procedure Environ; stdcall;
    procedure Command; stdcall;
    procedure ChrB; stdcall;
    procedure ChrW; stdcall;
  end;

// *********************************************************************//
// Interface: _ErrObject
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {A4C466B8-499F-101B-BB78-00AA00383CBB}
// *********************************************************************//
  _ErrObject = interface(IDispatch)
    ['{A4C466B8-499F-101B-BB78-00AA00383CBB}']
    function Get_Number: Integer; safecall;
    procedure Set_Number(pi4: Integer); safecall;
    function Get_Source: WideString; safecall;
    procedure Set_Source(const pbstr: WideString); safecall;
    function Get_Description: WideString; safecall;
    procedure Set_Description(const pbstr: WideString); safecall;
    function Get_HelpFile: WideString; safecall;
    procedure Set_HelpFile(const pbstr: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(pi4: Integer); safecall;
    procedure Raise_(Number: Integer; var Source: OleVariant; var Description: OleVariant; 
                     var HelpFile: OleVariant; var HelpContext: OleVariant); safecall;
    procedure Clear; stdcall;
    function Get_LastDllError: Integer; safecall;
    property Number: Integer read Get_Number write Set_Number;
    property Source: WideString read Get_Source write Set_Source;
    property Description: WideString read Get_Description write Set_Description;
    property HelpFile: WideString read Get_HelpFile write Set_HelpFile;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property LastDllError: Integer read Get_LastDllError;
  end;

// *********************************************************************//
// DispIntf:  _ErrObjectDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {A4C466B8-499F-101B-BB78-00AA00383CBB}
// *********************************************************************//
  _ErrObjectDisp = dispinterface
    ['{A4C466B8-499F-101B-BB78-00AA00383CBB}']
    property Number: Integer dispid 0;
    property Source: WideString dispid 1610743810;
    property Description: WideString dispid 1610743812;
    property HelpFile: WideString dispid 1610743814;
    property HelpContext: Integer dispid 1610743816;
    procedure Raise_(Number: Integer; var Source: OleVariant; var Description: OleVariant; 
                     var HelpFile: OleVariant; var HelpContext: OleVariant); dispid 1610743818;
    procedure Clear; dispid 1610743819;
    property LastDllError: Integer readonly dispid 1610743820;
  end;

// *********************************************************************//
// Interface: _Collection
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {A4C46780-499F-101B-BB78-00AA00383CBB}
// *********************************************************************//
  _Collection = interface(IDispatch)
    ['{A4C46780-499F-101B-BB78-00AA00383CBB}']
    function Item(var Index: OleVariant): OleVariant; safecall;
    procedure Add(var Item: OleVariant; var Key: OleVariant; var Before: OleVariant; 
                  var After: OleVariant); safecall;
    function Count: Integer; safecall;
    procedure Remove(var Index: OleVariant); safecall;
    function _NewEnum: IUnknown; safecall;
  end;

// *********************************************************************//
// DispIntf:  _CollectionDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {A4C46780-499F-101B-BB78-00AA00383CBB}
// *********************************************************************//
  _CollectionDisp = dispinterface
    ['{A4C46780-499F-101B-BB78-00AA00383CBB}']
    function Item(var Index: OleVariant): OleVariant; dispid 0;
    procedure Add(var Item: OleVariant; var Key: OleVariant; var Before: OleVariant; 
                  var After: OleVariant); dispid 1;
    function Count: Integer; dispid 2;
    procedure Remove(var Index: OleVariant); dispid 3;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// The Class CoErrObject provides a Create and CreateRemote method to          
// create instances of the default interface _ErrObject exposed by              
// the CoClass ErrObject. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoErrObject = class
    class function Create: _ErrObject;
    class function CreateRemote(const MachineName: string): _ErrObject;
  end;

// *********************************************************************//
// The Class CoCollection provides a Create and CreateRemote method to          
// create instances of the default interface _Collection exposed by              
// the CoClass Collection. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCollection = class
    class function Create: _Collection;
    class function CreateRemote(const MachineName: string): _Collection;
  end;

implementation

uses ComObj;

class function CoErrObject.Create: _ErrObject;
begin
  Result := CreateComObject(CLASS_ErrObject) as _ErrObject;
end;

class function CoErrObject.CreateRemote(const MachineName: string): _ErrObject;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ErrObject) as _ErrObject;
end;

class function CoCollection.Create: _Collection;
begin
  Result := CreateComObject(CLASS_Collection) as _Collection;
end;

class function CoCollection.CreateRemote(const MachineName: string): _Collection;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Collection) as _Collection;
end;

end.
