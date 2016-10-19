//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit MSDATASRC_TLB;

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
// Type Lib: C:\WINDOWS\system32\msdatsrc.tlb (1)
// LIBID: {7C0FFAB0-CD84-11D0-949A-00A0C91110ED}
// LCID: 0
// Helpfile: 
// HelpString: Microsoft Data Source Interfaces
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Parent TypeLibrary:
//   (0) v3.2 ATCTSfile, (C:\WINDOWS\system32\ATCTSfile.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  MSDATASRCMajorVersion = 1;
  MSDATASRCMinorVersion = 0;

  LIBID_MSDATASRC: TGUID = '{7C0FFAB0-CD84-11D0-949A-00A0C91110ED}';

  IID_DataSourceListener: TGUID = '{7C0FFAB2-CD84-11D0-949A-00A0C91110ED}';
  IID_DataSource: TGUID = '{7C0FFAB3-CD84-11D0-949A-00A0C91110ED}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  DataSourceListener = interface;
  DataSource = interface;

// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PUserType1 = ^TGUID; {*}

  DataMember = WideString; 

// *********************************************************************//
// Interface: DataSourceListener
// Flags:     (272) Hidden OleAutomation
// GUID:      {7C0FFAB2-CD84-11D0-949A-00A0C91110ED}
// *********************************************************************//
  DataSourceListener = interface(IUnknown)
    ['{7C0FFAB2-CD84-11D0-949A-00A0C91110ED}']
    function dataMemberChanged(const bstrDM: DataMember): HResult; stdcall;
    function dataMemberAdded(const bstrDM: DataMember): HResult; stdcall;
    function dataMemberRemoved(const bstrDM: DataMember): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DataSource
// Flags:     (256) OleAutomation
// GUID:      {7C0FFAB3-CD84-11D0-949A-00A0C91110ED}
// *********************************************************************//
  DataSource = interface(IUnknown)
    ['{7C0FFAB3-CD84-11D0-949A-00A0C91110ED}']
    function getDataMember(const bstrDM: DataMember; var riid: TGUID; out ppunk: IUnknown): HResult; stdcall;
    function getDataMemberName(lIndex: Integer; out pbstrDM: DataMember): HResult; stdcall;
    function getDataMemberCount(out plCount: Integer): HResult; stdcall;
    function addDataSourceListener(const pDSL: DataSourceListener): HResult; stdcall;
    function removeDataSourceListener(const pDSL: DataSourceListener): HResult; stdcall;
  end;

implementation

uses ComObj;

end.
