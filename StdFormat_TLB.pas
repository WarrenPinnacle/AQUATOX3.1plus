//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit StdFormat_TLB;

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
// Type Lib: C:\WINDOWS\system32\MSSTDFMT.DLL (1)
// LIBID: {6B263850-900B-11D0-9484-00A0C91110ED}
// LCID: 0
// Helpfile: C:\WINDOWS\system32\vb98.chm
// HelpString: Microsoft Data Formatting Object Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Parent TypeLibrary:
//   (0) v3.2 ATCTSfile, (C:\WINDOWS\system32\ATCTSfile.dll)
// Errors:
//   Hint: Parameter 'Object' of IStdDataValueDisp.TargetObject changed to 'Object_'
//   Hint: Parameter 'Object' of IStdDataValueDisp.TargetObject changed to 'Object_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Symbol 'Type' renamed to 'type_'
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
  StdFormatMajorVersion = 1;
  StdFormatMinorVersion = 0;

  LIBID_StdFormat: TGUID = '{6B263850-900B-11D0-9484-00A0C91110ED}';

  IID_IDataFormatDisp: TGUID = '{E675F3F0-91B5-11D0-9484-00A0C91110ED}';
  IID_IStdDataValueDisp: TGUID = '{5DE7A180-91B1-11D0-9484-00A0C91110ED}';
  CLASS_StdDataValue: TGUID = '{2B11E9B0-9F09-11D0-9484-00A0C91110ED}';
  DIID_IStdDataFormatEvents: TGUID = '{C2F13ED0-91B0-11D0-9484-00A0C91110ED}';
  IID_IStdDataFormatDisp: TGUID = '{6C51B910-900B-11D0-9484-00A0C91110ED}';
  CLASS_StdDataFormat: TGUID = '{6D835690-900B-11D0-9484-00A0C91110ED}';
  IID_IDataFormatsDisp: TGUID = '{A1741EF6-FFC6-11D0-BD02-00C04FC2FB86}';
  IID_IStdDataFormatsDisp: TGUID = '{99FF4676-FFC3-11D0-BD02-00C04FC2FB86}';
  CLASS_StdDataFormats: TGUID = '{99FF4677-FFC3-11D0-BD02-00C04FC2FB86}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum FormatType
type
  FormatType = TOleEnum;
const
  fmtGeneral = $00000000;
  fmtCustom = $00000001;
  fmtPicture = $00000002;
  fmtObject = $00000003;
  fmtCheckbox = $00000004;
  fmtBoolean = $00000005;
  fmtBytes = $00000006;

// Constants for enum FirstDayOfWeek
type
  FirstDayOfWeek = TOleEnum;
const
  fmtDayUseSystem = $00000000;
  fmtSunday = $00000001;
  fmtMonday = $00000002;
  fmtTuesday = $00000003;
  fmtWednesday = $00000004;
  fmtThursday = $00000005;
  fmtFriday = $00000006;
  fmtSaturday = $00000007;

// Constants for enum FirstWeekOfYear
type
  FirstWeekOfYear = TOleEnum;
const
  fmtWeekUseSystem = $00000000;
  fmtFirstJan1 = $00000001;
  fmtFirstFourDays = $00000002;
  fmtFirstFullWeek = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDataFormatDisp = interface;
  IDataFormatDispDisp = dispinterface;
  IStdDataValueDisp = interface;
  IStdDataValueDispDisp = dispinterface;
  IStdDataFormatEvents = dispinterface;
  IStdDataFormatDisp = interface;
  IStdDataFormatDispDisp = dispinterface;
  IDataFormatsDisp = interface;
  IDataFormatsDispDisp = dispinterface;
  IStdDataFormatsDisp = interface;
  IStdDataFormatsDispDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  StdDataValue = IStdDataValueDisp;
  StdDataFormat = IStdDataFormatDisp;
  StdDataFormats = IStdDataFormatsDisp;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}

  DataFormat = IDataFormatDisp; 
  DataFormats = IDataFormatsDisp; 

// *********************************************************************//
// Interface: IDataFormatDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {E675F3F0-91B5-11D0-9484-00A0C91110ED}
// *********************************************************************//
  IDataFormatDisp = interface(IDispatch)
    ['{E675F3F0-91B5-11D0-9484-00A0C91110ED}']
  end;

// *********************************************************************//
// DispIntf:  IDataFormatDispDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {E675F3F0-91B5-11D0-9484-00A0C91110ED}
// *********************************************************************//
  IDataFormatDispDisp = dispinterface
    ['{E675F3F0-91B5-11D0-9484-00A0C91110ED}']
  end;

// *********************************************************************//
// Interface: IStdDataValueDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5DE7A180-91B1-11D0-9484-00A0C91110ED}
// *********************************************************************//
  IStdDataValueDisp = interface(IDispatch)
    ['{5DE7A180-91B1-11D0-9484-00A0C91110ED}']
    procedure Set_Value(var pvar: OleVariant); safecall;
    function Get_Value: OleVariant; safecall;
    procedure _Set_TargetObject(const Object_: IDispatch); safecall;
    function Get_TargetObject: IDispatch; safecall;
    property TargetObject: IDispatch read Get_TargetObject write _Set_TargetObject;
  end;

// *********************************************************************//
// DispIntf:  IStdDataValueDispDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5DE7A180-91B1-11D0-9484-00A0C91110ED}
// *********************************************************************//
  IStdDataValueDispDisp = dispinterface
    ['{5DE7A180-91B1-11D0-9484-00A0C91110ED}']
    function Value: {??POleVariant1}OleVariant; dispid 0;
    property TargetObject: IDispatch dispid 1;
  end;

// *********************************************************************//
// DispIntf:  IStdDataFormatEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {C2F13ED0-91B0-11D0-9484-00A0C91110ED}
// *********************************************************************//
  IStdDataFormatEvents = dispinterface
    ['{C2F13ED0-91B0-11D0-9484-00A0C91110ED}']
    procedure Format(const DataValue: StdDataValue); dispid 1;
    procedure UnFormat(const DataValue: StdDataValue); dispid 2;
    procedure Changed; dispid 3;
  end;

// *********************************************************************//
// Interface: IStdDataFormatDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {6C51B910-900B-11D0-9484-00A0C91110ED}
// *********************************************************************//
  IStdDataFormatDisp = interface(IDataFormatDisp)
    ['{6C51B910-900B-11D0-9484-00A0C91110ED}']
    function Get_type_: FormatType; safecall;
    procedure Set_type_(ptype: FormatType); safecall;
    function Get_Format: WideString; safecall;
    procedure Set_Format(const pbstr: WideString); safecall;
    function Get_TrueValue: OleVariant; safecall;
    procedure Set_TrueValue(var pvar: OleVariant); safecall;
    function Get_FalseValue: OleVariant; safecall;
    procedure Set_FalseValue(var pvar: OleVariant); safecall;
    function Get_NullValue: OleVariant; safecall;
    procedure Set_NullValue(var pvar: OleVariant); safecall;
    function Get_FirstDayOfWeek: FirstDayOfWeek; safecall;
    procedure Set_FirstDayOfWeek(pl: FirstDayOfWeek); safecall;
    function Get_FirstWeekOfYear: FirstWeekOfYear; safecall;
    procedure Set_FirstWeekOfYear(pl: FirstWeekOfYear); safecall;
    property type_: FormatType read Get_type_ write Set_type_;
    property Format: WideString read Get_Format write Set_Format;
    property FirstDayOfWeek: FirstDayOfWeek read Get_FirstDayOfWeek write Set_FirstDayOfWeek;
    property FirstWeekOfYear: FirstWeekOfYear read Get_FirstWeekOfYear write Set_FirstWeekOfYear;
  end;

// *********************************************************************//
// DispIntf:  IStdDataFormatDispDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {6C51B910-900B-11D0-9484-00A0C91110ED}
// *********************************************************************//
  IStdDataFormatDispDisp = dispinterface
    ['{6C51B910-900B-11D0-9484-00A0C91110ED}']
    property type_: FormatType dispid 1;
    property Format: WideString dispid 2;
    function TrueValue: OleVariant; dispid 3;
    function FalseValue: OleVariant; dispid 4;
    function NullValue: OleVariant; dispid 5;
    property FirstDayOfWeek: FirstDayOfWeek dispid 6;
    property FirstWeekOfYear: FirstWeekOfYear dispid 7;
  end;

// *********************************************************************//
// Interface: IDataFormatsDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {A1741EF6-FFC6-11D0-BD02-00C04FC2FB86}
// *********************************************************************//
  IDataFormatsDisp = interface(IDispatch)
    ['{A1741EF6-FFC6-11D0-BD02-00C04FC2FB86}']
  end;

// *********************************************************************//
// DispIntf:  IDataFormatsDispDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {A1741EF6-FFC6-11D0-BD02-00C04FC2FB86}
// *********************************************************************//
  IDataFormatsDispDisp = dispinterface
    ['{A1741EF6-FFC6-11D0-BD02-00C04FC2FB86}']
  end;

// *********************************************************************//
// Interface: IStdDataFormatsDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {99FF4676-FFC3-11D0-BD02-00C04FC2FB86}
// *********************************************************************//
  IStdDataFormatsDisp = interface(IDataFormatsDisp)
    ['{99FF4676-FFC3-11D0-BD02-00C04FC2FB86}']
    function Get_Count: Integer; safecall;
    function _NewEnum: IUnknown; safecall;
    function Get_Item(Index: OleVariant): DataFormat; safecall;
    function _ItemField(Field: OleVariant): WideString; safecall;
    procedure Add(const pFormat: DataFormat; Index: OleVariant); safecall;
    procedure Remove(Index: OleVariant); safecall;
    procedure Clear; safecall;
    property Count: Integer read Get_Count;
    property Item[Index: OleVariant]: DataFormat read Get_Item; default;
  end;

// *********************************************************************//
// DispIntf:  IStdDataFormatsDispDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {99FF4676-FFC3-11D0-BD02-00C04FC2FB86}
// *********************************************************************//
  IStdDataFormatsDispDisp = dispinterface
    ['{99FF4676-FFC3-11D0-BD02-00C04FC2FB86}']
    property Count: Integer readonly dispid 1;
    function _NewEnum: IUnknown; dispid -4;
    property Item[Index: OleVariant]: DataFormat readonly dispid 0; default;
    function _ItemField(Field: OleVariant): WideString; dispid 5;
    procedure Add(const pFormat: DataFormat; Index: OleVariant); dispid 2;
    procedure Remove(Index: OleVariant); dispid 3;
    procedure Clear; dispid 4;
  end;

// *********************************************************************//
// The Class CoStdDataValue provides a Create and CreateRemote method to          
// create instances of the default interface IStdDataValueDisp exposed by              
// the CoClass StdDataValue. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoStdDataValue = class
    class function Create: IStdDataValueDisp;
    class function CreateRemote(const MachineName: string): IStdDataValueDisp;
  end;

// *********************************************************************//
// The Class CoStdDataFormat provides a Create and CreateRemote method to          
// create instances of the default interface IStdDataFormatDisp exposed by              
// the CoClass StdDataFormat. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoStdDataFormat = class
    class function Create: IStdDataFormatDisp;
    class function CreateRemote(const MachineName: string): IStdDataFormatDisp;
  end;

// *********************************************************************//
// The Class CoStdDataFormats provides a Create and CreateRemote method to          
// create instances of the default interface IStdDataFormatsDisp exposed by              
// the CoClass StdDataFormats. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoStdDataFormats = class
    class function Create: IStdDataFormatsDisp;
    class function CreateRemote(const MachineName: string): IStdDataFormatsDisp;
  end;

implementation

uses ComObj;

class function CoStdDataValue.Create: IStdDataValueDisp;
begin
  Result := CreateComObject(CLASS_StdDataValue) as IStdDataValueDisp;
end;

class function CoStdDataValue.CreateRemote(const MachineName: string): IStdDataValueDisp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_StdDataValue) as IStdDataValueDisp;
end;

class function CoStdDataFormat.Create: IStdDataFormatDisp;
begin
  Result := CreateComObject(CLASS_StdDataFormat) as IStdDataFormatDisp;
end;

class function CoStdDataFormat.CreateRemote(const MachineName: string): IStdDataFormatDisp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_StdDataFormat) as IStdDataFormatDisp;
end;

class function CoStdDataFormats.Create: IStdDataFormatsDisp;
begin
  Result := CreateComObject(CLASS_StdDataFormats) as IStdDataFormatsDisp;
end;

class function CoStdDataFormats.CreateRemote(const MachineName: string): IStdDataFormatsDisp;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_StdDataFormats) as IStdDataFormatsDisp;
end;

end.
