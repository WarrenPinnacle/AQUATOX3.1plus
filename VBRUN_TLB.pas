//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit VBRUN_TLB;

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
// Type Lib: C:\WINDOWS\system32\MSVBVM60.dll\3 (1)
// LIBID: {EA544A21-C82D-11D1-A3E4-00A0C90AEA82}
// LCID: 9
// Helpfile: C:\WINDOWS\system32\VB98.CHM
// HelpString: Visual Basic runtime objects and procedures
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v1.0 MSDATASRC, (C:\WINDOWS\system32\msdatsrc.tlb)
//   (3) v1.0 StdFormat, (C:\WINDOWS\system32\MSSTDFMT.DLL)
// Parent TypeLibrary:
//   (0) v3.2 ATCTSfile, (C:\WINDOWS\system32\ATCTSfile.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, MSDATASRC_TLB, OleServer, StdFormat_TLB, StdVCL, 
Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  VBRUNMajorVersion = 6;
  VBRUNMinorVersion = 0;

  LIBID_VBRUN: TGUID = '{EA544A21-C82D-11D1-A3E4-00A0C90AEA82}';

  IID_PropertyBag_VB5: TGUID = '{45046D60-08CA-11CF-A90F-00AA0062BB4C}';
  IID__PropertyBag: TGUID = '{4495AD01-C993-11D1-A3E4-00A0C90AEA82}';
  CLASS_PropertyBag: TGUID = '{D5DE8D20-5BB8-11D1-A1E3-00A0C90F2731}';
  IID_DataObjectFiles: TGUID = '{41A7D761-6018-11CF-9016-00AA0068841E}';
  IID_DataObject: TGUID = '{41A7D760-6018-11CF-9016-00AA0068841E}';
  IID_AmbientProperties: TGUID = '{B28FA150-0FF0-11CF-A911-00AA0062BB4C}';
  IID_SelectedControls: TGUID = '{2CE46480-1A08-11CF-AD63-00AA00614F3E}';
  IID_ParentControls: TGUID = '{BE8F9800-2AAA-11CF-AD67-00AA00614F3E}';
  IID_ContainedControls: TGUID = '{C0324960-2AAA-11CF-AD67-00AA00614F3E}';
  IID_DataBindings: TGUID = '{D4E0F020-720A-11CF-8136-00AA00C14959}';
  IID_DataBinding: TGUID = '{7500A6BA-EB65-11D1-938D-0000F87557C9}';
  IID_EventParameter: TGUID = '{C4D651F0-7697-11D1-A1E9-00A0C90F2731}';
  IID_EventParameters: TGUID = '{C4D651F1-7697-11D1-A1E9-00A0C90F2731}';
  IID_EventInfo: TGUID = '{C4D651F2-7697-11D1-A1E9-00A0C90F2731}';
  IID_Hyperlink: TGUID = '{888A5A60-B283-11CF-8AD5-00A0C90AEA82}';
  IID_AsyncProperty_VB5: TGUID = '{14E469E0-BF61-11CF-8385-8F69D8F1350B}';
  IID_AsyncProperty: TGUID = '{CBB76011-C508-11D1-A3E3-00A0C90AEA82}';
  IID_DataMembers: TGUID = '{83C49FF0-B294-11D0-9488-00A0C91110ED}';
  IID_IClassModuleEvt: TGUID = '{FCFB3D21-A0FA-1068-A738-08002B3371B5}';
  IID_IDataSourceClassEvt: TGUID = '{6B121A01-45DF-11D1-8907-00A0C9110049}';
  IID_IPersistableClassEvt: TGUID = '{6B121A02-45DF-11D1-8907-00A0C9110049}';
  IID_IPersistableDataSourceClassEvt: TGUID = '{6B121A03-45DF-11D1-8907-00A0C9110049}';
  IID_IDataProviderClassEvt: TGUID = '{6B121A04-45DF-11D1-8907-00A0C9110049}';
  IID_IPersistableDataProviderClassEvt: TGUID = '{6B121A05-45DF-11D1-8907-00A0C9110049}';
  DIID__DClass: TGUID = '{FCFB3D2B-A0FA-1068-A738-08002B3371B5}';
  DIID__DDataBoundClass: TGUID = '{EB41E8C1-4442-11D1-8906-00A0C9110049}';
  DIID__DDataSourceClass: TGUID = '{EB41E8C2-4442-11D1-8906-00A0C9110049}';
  DIID__DDataBoundAndDataSourceClass: TGUID = '{EB41E8C3-4442-11D1-8906-00A0C9110049}';
  DIID__DPersistableClass: TGUID = '{EB41E8C4-4442-11D1-8906-00A0C9110049}';
  DIID__DPersistableDataSourceClass: TGUID = '{EB41E8C5-4442-11D1-8906-00A0C9110049}';
  IID_LicenseInfo: TGUID = '{8284B8A2-A8A8-11D1-A3D2-00A0C90AEA82}';
  IID_Licenses: TGUID = '{737361EC-467F-11D1-810F-0000F87557AA}';
  IID_IProjectControl: TGUID = '{27F56410-6161-11D1-946E-00A0C90F26F1}';
  IID_IVbeRuntimeHost: TGUID = '{E43FD401-8715-11D1-98E7-00A0C9702442}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum PaletteModeConstants
type
  PaletteModeConstants = TOleEnum;
const
  vbPaletteModeHalftone = $00000000;
  vbPaletteModeUseZOrder = $00000001;
  vbPaletteModeCustom = $00000002;
  vbPaletteModeContainer = $00000003;
  vbPaletteModeNone = $00000004;
  vbPaletteModeObject = $00000005;

// Constants for enum AsyncTypeConstants
type
  AsyncTypeConstants = TOleEnum;
const
  vbAsyncTypePicture = $00000000;
  vbAsyncTypeFile = $00000001;
  vbAsyncTypeByteArray = $00000002;

// Constants for enum AsyncReadConstants
type
  AsyncReadConstants = TOleEnum;
const
  vbAsyncReadSynchronousDownload = $00000001;
  vbAsyncReadOfflineOperation = $00000008;
  vbAsyncReadForceUpdate = $00000010;
  vbAsyncReadResynchronize = $00000200;
  vbAsyncReadGetFromCacheIfNetFail = $00080000;

// Constants for enum AsyncStatusCodeConstants
type
  AsyncStatusCodeConstants = TOleEnum;
const
  vbAsyncStatusCodeError = $00000000;
  vbAsyncStatusCodeFindingResource = $00000001;
  vbAsyncStatusCodeConnecting = $00000002;
  vbAsyncStatusCodeRedirecting = $00000003;
  vbAsyncStatusCodeBeginDownloadData = $00000004;
  vbAsyncStatusCodeDownloadingData = $00000005;
  vbAsyncStatusCodeEndDownloadData = $00000006;
  vbAsyncStatusCodeUsingCachedCopy = $0000000A;
  vbAsyncStatusCodeSendingRequest = $0000000B;
  vbAsyncStatusCodeMIMETypeAvailable = $0000000D;
  vbAsyncStatusCodeCacheFileNameAvailable = $0000000E;
  vbAsyncStatusCodeBeginSyncOperation = $0000000F;
  vbAsyncStatusCodeEndSyncOperation = $00000010;

// Constants for enum LogEventTypeConstants
type
  LogEventTypeConstants = TOleEnum;
const
  vbLogEventTypeError = $00000001;
  vbLogEventTypeWarning = $00000002;
  vbLogEventTypeInformation = $00000004;

// Constants for enum QueryUnloadConstants
type
  QueryUnloadConstants = TOleEnum;
const
  vbFormControlMenu = $00000000;
  vbFormCode = $00000001;
  vbAppWindows = $00000002;
  vbAppTaskManager = $00000003;
  vbFormMDIForm = $00000004;
  vbFormOwner = $00000005;

// Constants for enum ZOrderConstants
type
  ZOrderConstants = TOleEnum;
const
  vbBringToFront = $00000000;
  vbSendToBack = $00000001;

// Constants for enum ShiftConstants
type
  ShiftConstants = TOleEnum;
const
  vbShiftMask = $00000001;
  vbCtrlMask = $00000002;
  vbAltMask = $00000004;

// Constants for enum MouseButtonConstants
type
  MouseButtonConstants = TOleEnum;
const
  vbLeftButton = $00000001;
  vbRightButton = $00000002;
  vbMiddleButton = $00000004;

// Constants for enum ApplicationStartConstants
type
  ApplicationStartConstants = TOleEnum;
const
  vbSModeStandalone = $00000000;
  vbSModeAutomation = $00000001;

// Constants for enum ScrollBarConstants
type
  ScrollBarConstants = TOleEnum;
const
  vbSBNone = $00000000;
  vbHorizontal = $00000001;
  vbVertical = $00000002;
  vbBoth = $00000003;

// Constants for enum ShapeConstants
type
  ShapeConstants = TOleEnum;
const
  vbShapeRectangle = $00000000;
  vbShapeSquare = $00000001;
  vbShapeOval = $00000002;
  vbShapeCircle = $00000003;
  vbShapeRoundedRectangle = $00000004;
  vbShapeRoundedSquare = $00000005;

// Constants for enum PictureTypeConstants
type
  PictureTypeConstants = TOleEnum;
const
  vbPicTypeNone = $00000000;
  vbPicTypeBitmap = $00000001;
  vbPicTypeMetafile = $00000002;
  vbPicTypeIcon = $00000003;
  vbPicTypeEMetafile = $00000004;

// Constants for enum ComboBoxConstants
type
  ComboBoxConstants = TOleEnum;
const
  vbComboDropdown = $00000000;
  vbComboSimple = $00000001;
  vbComboDropdownList = $00000002;

// Constants for enum MultiSelectConstants
type
  MultiSelectConstants = TOleEnum;
const
  vbMultiSelectNone = $00000000;
  vbMultiSelectSimple = $00000001;
  vbMultiSelectExtended = $00000002;

// Constants for enum DataErrorConstants
type
  DataErrorConstants = TOleEnum;
const
  vbDataErrContinue = $00000000;
  vbDataErrDisplay = $00000001;

// Constants for enum DataValidateConstants
type
  DataValidateConstants = TOleEnum;
const
  vbDataActionCancel = $00000000;
  vbDataActionMoveFirst = $00000001;
  vbDataActionMovePrevious = $00000002;
  vbDataActionMoveNext = $00000003;
  vbDataActionMoveLast = $00000004;
  vbDataActionAddNew = $00000005;
  vbDataActionUpdate = $00000006;
  vbDataActionDelete = $00000007;
  vbDataActionFind = $00000008;
  vbDataActionBookmark = $00000009;
  vbDataActionClose = $0000000A;
  vbDataActionUnload = $0000000B;

// Constants for enum DataBOFconstants
type
  DataBOFconstants = TOleEnum;
const
  vbMoveFirst = $00000000;
  vbBOF = $00000001;

// Constants for enum DataEOFConstants
type
  DataEOFConstants = TOleEnum;
const
  vbMoveLast = $00000000;
  vbEOF = $00000001;
  vbAddNew = $00000002;

// Constants for enum DefaultCursorTypeConstants
type
  DefaultCursorTypeConstants = TOleEnum;
const
  vbUseDefaultCursor = $00000000;
  vbUseODBCCursor = $00000001;
  vbUseServersideCursor = $00000002;

// Constants for enum VariantTypeConstants
type
  VariantTypeConstants = TOleEnum;
const
  vbVEmpty = $00000000;
  vbVNull = $00000001;
  vbVInteger = $00000002;
  vbVLong = $00000003;
  vbVSingle = $00000004;
  vbVDouble = $00000005;
  vbVCurrency = $00000006;
  vbVDate = $00000007;
  vbVString = $00000008;

// Constants for enum LinkErrorConstants
type
  LinkErrorConstants = TOleEnum;
const
  vbWrongFormat = $00000001;
  vbDDESourceClosed = $00000006;
  vbTooManyLinks = $00000007;
  vbDataTransferFailed = $00000008;

// Constants for enum LinkModeConstants
type
  LinkModeConstants = TOleEnum;
const
  vbLinkNone = $00000000;
  vbLinkSource = $00000001;
  vbLinkAutomatic = $00000001;
  vbLinkManual = $00000002;
  vbLinkNotify = $00000003;

// Constants for enum OldLinkModeConstants
type
  OldLinkModeConstants = TOleEnum;
const
  vbHot = $00000001;
  vbServer = $00000001;
  vbCold = $00000002;

// Constants for enum ClipBoardConstants
type
  ClipBoardConstants = TOleEnum;
const
  vbCFLink = $FFFFBF00;
  vbCFText = $00000001;
  vbCFBitmap = $00000002;
  vbCFMetafile = $00000003;
  vbCFDIB = $00000008;
  vbCFPalette = $00000009;
  vbCFEMetafile = $0000000E;
  vbCFFiles = $0000000F;
  vbCFRTF = $FFFFBF01;

// Constants for enum DragOverConstants
type
  DragOverConstants = TOleEnum;
const
  vbEnter = $00000000;
  vbLeave = $00000001;
  vbOver = $00000002;

// Constants for enum DragConstants
type
  DragConstants = TOleEnum;
const
  vbCancel = $00000000;
  vbBeginDrag = $00000001;
  vbEndDrag = $00000002;

// Constants for enum DragModeConstants
type
  DragModeConstants = TOleEnum;
const
  vbManual = $00000000;
  vbAutomatic = $00000001;

// Constants for enum OLEDropEffectConstants
type
  OLEDropEffectConstants = TOleEnum;
const
  vbDropEffectNone = $00000000;
  vbDropEffectCopy = $00000001;
  vbDropEffectMove = $00000002;
  vbDropEffectScroll = $80000000;

// Constants for enum OLEDragConstants
type
  OLEDragConstants = TOleEnum;
const
  vbOLEDragManual = $00000000;
  vbOLEDragAutomatic = $00000001;

// Constants for enum OLEDropConstants
type
  OLEDropConstants = TOleEnum;
const
  vbOLEDropNone = $00000000;
  vbOLEDropManual = $00000001;
  vbOLEDropAutomatic = $00000002;

// Constants for enum FormShowConstants
type
  FormShowConstants = TOleEnum;
const
  vbModeless = $00000000;
  vbModal = $00000001;

// Constants for enum FormArrangeConstants
type
  FormArrangeConstants = TOleEnum;
const
  vbCascade = $00000000;
  vbTileHorizontal = $00000001;
  vbTileVertical = $00000002;
  vbArrangeIcons = $00000003;

// Constants for enum FormWindowStateConstants
type
  FormWindowStateConstants = TOleEnum;
const
  vbNormal = $00000000;
  vbMinimized = $00000001;
  vbMaximized = $00000002;

// Constants for enum KeyCodeConstants
type
  KeyCodeConstants = TOleEnum;
const
  vbKeyLButton = $00000001;
  vbKeyRButton = $00000002;
  vbKeyCancel = $00000003;
  vbKeyMButton = $00000004;
  vbKeyBack = $00000008;
  vbKeyTab = $00000009;
  vbKeyClear = $0000000C;
  vbKeyReturn = $0000000D;
  vbKeyShift = $00000010;
  vbKeyControl = $00000011;
  vbKeyMenu = $00000012;
  vbKeyPause = $00000013;
  vbKeyCapital = $00000014;
  vbKeyEscape = $0000001B;
  vbKeySpace = $00000020;
  vbKeyPageUp = $00000021;
  vbKeyPageDown = $00000022;
  vbKeyEnd = $00000023;
  vbKeyHome = $00000024;
  vbKeyLeft = $00000025;
  vbKeyUp = $00000026;
  vbKeyRight = $00000027;
  vbKeyDown = $00000028;
  vbKeySelect = $00000029;
  vbKeyPrint = $0000002A;
  vbKeyExecute = $0000002B;
  vbKeySnapshot = $0000002C;
  vbKeyInsert = $0000002D;
  vbKeyDelete = $0000002E;
  vbKeyHelp = $0000002F;
  vbKeyNumlock = $00000090;
  vbKeyScrollLock = $00000091;
  vbKeyA = $00000041;
  vbKeyB = $00000042;
  vbKeyC = $00000043;
  vbKeyD = $00000044;
  vbKeyE = $00000045;
  vbKeyF = $00000046;
  vbKeyG = $00000047;
  vbKeyH = $00000048;
  vbKeyI = $00000049;
  vbKeyJ = $0000004A;
  vbKeyK = $0000004B;
  vbKeyL = $0000004C;
  vbKeyM = $0000004D;
  vbKeyN = $0000004E;
  vbKeyO = $0000004F;
  vbKeyP = $00000050;
  vbKeyQ = $00000051;
  vbKeyR = $00000052;
  vbKeyS = $00000053;
  vbKeyT = $00000054;
  vbKeyU = $00000055;
  vbKeyV = $00000056;
  vbKeyW = $00000057;
  vbKeyX = $00000058;
  vbKeyY = $00000059;
  vbKeyZ = $0000005A;
  vbKey0 = $00000030;
  vbKey1 = $00000031;
  vbKey2 = $00000032;
  vbKey3 = $00000033;
  vbKey4 = $00000034;
  vbKey5 = $00000035;
  vbKey6 = $00000036;
  vbKey7 = $00000037;
  vbKey8 = $00000038;
  vbKey9 = $00000039;
  vbKeyNumpad0 = $00000060;
  vbKeyNumpad1 = $00000061;
  vbKeyNumpad2 = $00000062;
  vbKeyNumpad3 = $00000063;
  vbKeyNumpad4 = $00000064;
  vbKeyNumpad5 = $00000065;
  vbKeyNumpad6 = $00000066;
  vbKeyNumpad7 = $00000067;
  vbKeyNumpad8 = $00000068;
  vbKeyNumpad9 = $00000069;
  vbKeyMultiply = $0000006A;
  vbKeyAdd = $0000006B;
  vbKeySeparator = $0000006C;
  vbKeySubtract = $0000006D;
  vbKeyDecimal = $0000006E;
  vbKeyDivide = $0000006F;
  vbKeyF1 = $00000070;
  vbKeyF2 = $00000071;
  vbKeyF3 = $00000072;
  vbKeyF4 = $00000073;
  vbKeyF5 = $00000074;
  vbKeyF6 = $00000075;
  vbKeyF7 = $00000076;
  vbKeyF8 = $00000077;
  vbKeyF9 = $00000078;
  vbKeyF10 = $00000079;
  vbKeyF11 = $0000007A;
  vbKeyF12 = $0000007B;
  vbKeyF13 = $0000007C;
  vbKeyF14 = $0000007D;
  vbKeyF15 = $0000007E;
  vbKeyF16 = $0000007F;

// Constants for enum MenuAccelConstants
type
  MenuAccelConstants = TOleEnum;
const
  vbMenuAccelCtrlA = $00000001;
  vbMenuAccelCtrlB = $00000002;
  vbMenuAccelCtrlC = $00000003;
  vbMenuAccelCtrlD = $00000004;
  vbMenuAccelCtrlE = $00000005;
  vbMenuAccelCtrlF = $00000006;
  vbMenuAccelCtrlG = $00000007;
  vbMenuAccelCtrlH = $00000008;
  vbMenuAccelCtrlI = $00000009;
  vbMenuAccelCtrlJ = $0000000A;
  vbMenuAccelCtrlK = $0000000B;
  vbMenuAccelCtrlL = $0000000C;
  vbMenuAccelCtrlM = $0000000D;
  vbMenuAccelCtrlN = $0000000E;
  vbMenuAccelCtrlO = $0000000F;
  vbMenuAccelCtrlP = $00000010;
  vbMenuAccelCtrlQ = $00000011;
  vbMenuAccelCtrlR = $00000012;
  vbMenuAccelCtrlS = $00000013;
  vbMenuAccelCtrlT = $00000014;
  vbMenuAccelCtrlU = $00000015;
  vbMenuAccelCtrlV = $00000016;
  vbMenuAccelCtrlW = $00000017;
  vbMenuAccelCtrlX = $00000018;
  vbMenuAccelCtrlY = $00000019;
  vbMenuAccelCtrlZ = $0000001A;
  vbMenuAccelF1 = $0000001B;
  vbMenuAccelF2 = $0000001C;
  vbMenuAccelF3 = $0000001D;
  vbMenuAccelF4 = $0000001E;
  vbMenuAccelF5 = $0000001F;
  vbMenuAccelF6 = $00000020;
  vbMenuAccelF7 = $00000021;
  vbMenuAccelF8 = $00000022;
  vbMenuAccelF9 = $00000023;
  vbMenuAccelF11 = $00000024;
  vbMenuAccelF12 = $00000025;
  vbMenuAccelCtrlF1 = $00000026;
  vbMenuAccelCtrlF2 = $00000027;
  vbMenuAccelCtrlF3 = $00000028;
  vbMenuAccelCtrlF4 = $00000029;
  vbMenuAccelCtrlF5 = $0000002A;
  vbMenuAccelCtrlF6 = $0000002B;
  vbMenuAccelCtrlF7 = $0000002C;
  vbMenuAccelCtrlF8 = $0000002D;
  vbMenuAccelCtrlF9 = $0000002E;
  vbMenuAccelCtrlF11 = $0000002F;
  vbMenuAccelCtrlF12 = $00000030;
  vbMenuAccelShiftF1 = $00000031;
  vbMenuAccelShfitF2 = $00000032;
  vbMenuAccelShiftF3 = $00000033;
  vbMenuAccelShiftF4 = $00000034;
  vbMenuAccelShiftF5 = $00000035;
  vbMenuAccelShiftF6 = $00000036;
  vbMenuAccelShiftF7 = $00000037;
  vbMenuAccelShiftF8 = $00000038;
  vbMenuAccelShiftF9 = $00000039;
  vbMenuAccelShiftF11 = $0000003A;
  vbMenuAccelShiftF12 = $0000003B;
  vbMenuAccelShiftCtrlF1 = $0000003C;
  vbMenuAccelShiftCtrlF2 = $0000003D;
  vbMenuAccelShiftCtrlF3 = $0000003E;
  vbMenuAccelShiftCtrlF4 = $0000003F;
  vbMenuAccelShiftCtrlF5 = $00000040;
  vbMenuAccelShiftCtrlF6 = $00000041;
  vbMenuAccelShiftCtrlF7 = $00000042;
  vbMenuAccelShiftCtrlF8 = $00000043;
  vbMenuAccelShiftCtrlF9 = $00000044;
  vbMenuAccelShiftCtrlF11 = $00000045;
  vbMenuAccelShiftCtrlF12 = $00000046;
  vbMenuAccelCtrlIns = $00000047;
  vbMenuAccelShiftIns = $00000048;
  vbMenuAccelDel = $00000049;
  vbMenuAccelShiftDel = $0000004A;
  vbMenuAccelAltBksp = $0000004B;

// Constants for enum ColorConstants
type
  ColorConstants = TOleEnum;
const
  vbBlack = $00000000;
  vbRed = $000000FF;
  vbGreen = $0000FF00;
  vbYellow = $0000FFFF;
  vbBlue = $00FF0000;
  vbMagenta = $00FF00FF;
  vbCyan = $00FFFF00;
  vbWhite = $00FFFFFF;

// Constants for enum SystemColorConstants
type
  SystemColorConstants = TOleEnum;
const
  vbScrollBars = $80000000;
  vbDesktop = $80000001;
  vbActiveTitleBar = $80000002;
  vbInactiveTitleBar = $80000003;
  vbMenuBar = $80000004;
  vbWindowBackground = $80000005;
  vbWindowFrame = $80000006;
  vbMenuText = $80000007;
  vbWindowText = $80000008;
  vbTitleBarText = $80000009;
  vbActiveBorder = $8000000A;
  vbInactiveBorder = $8000000B;
  vbApplicationWorkspace = $8000000C;
  vbHighlight = $8000000D;
  vbHighlightText = $8000000E;
  vbButtonFace = $8000000F;
  vbButtonShadow = $80000010;
  vbGrayText = $80000011;
  vbButtonText = $80000012;
  vbActiveTitleBarText = $80000009;
  vbInactiveTitleBarText = $80000013;
  vbInactiveCaptionText = $80000013;
  vb3DHighlight = $80000014;
  vb3DFace = $8000000F;
  vb3DShadow = $80000010;
  vb3DDKShadow = $80000015;
  vb3DLight = $80000016;
  vbInfoText = $80000017;
  vbInfoBackground = $80000018;

// Constants for enum AlignConstants
type
  AlignConstants = TOleEnum;
const
  vbAlignNone = $00000000;
  vbAlignTop = $00000001;
  vbAlignBottom = $00000002;
  vbAlignLeft = $00000003;
  vbAlignRight = $00000004;

// Constants for enum AlignmentConstants
type
  AlignmentConstants = TOleEnum;
const
  vbLeftJustify = $00000000;
  vbRightJustify = $00000001;
  vbCenter = $00000002;

// Constants for enum FormBorderStyleConstants
type
  FormBorderStyleConstants = TOleEnum;
const
  vbBSNone = $00000000;
  vbFixedSingle = $00000001;
  vbSizable = $00000002;
  vbFixedDouble = $00000003;
  vbFixedDialog = $00000003;
  vbFixedToolWindow = $00000004;
  vbSizableToolWindow = $00000005;

// Constants for enum BorderStyleConstants
type
  BorderStyleConstants = TOleEnum;
const
  vbTransparent = $00000000;
  vbBSSolid = $00000001;
  vbBSDash = $00000002;
  vbBSDot = $00000003;
  vbBSDashDot = $00000004;
  vbBSDashDotDot = $00000005;
  vbBSInsideSolid = $00000006;

// Constants for enum MousePointerConstants
type
  MousePointerConstants = TOleEnum;
const
  vbDefault = $00000000;
  vbArrow = $00000001;
  vbCrosshair = $00000002;
  vbIbeam = $00000003;
  vbIconPointer = $00000004;
  vbSizePointer = $00000005;
  vbSizeNESW = $00000006;
  vbSizeNS = $00000007;
  vbSizeNWSE = $00000008;
  vbSizeWE = $00000009;
  vbUpArrow = $0000000A;
  vbHourglass = $0000000B;
  vbNoDrop = $0000000C;
  vbArrowHourglass = $0000000D;
  vbArrowQuestion = $0000000E;
  vbSizeAll = $0000000F;
  vbCustom = $00000063;

// Constants for enum DrawModeConstants
type
  DrawModeConstants = TOleEnum;
const
  vbBlackness = $00000001;
  vbNotMergePen = $00000002;
  vbMaskNotPen = $00000003;
  vbNotCopyPen = $00000004;
  vbMaskPenNot = $00000005;
  vbInvert = $00000006;
  vbXorPen = $00000007;
  vbNotMaskPen = $00000008;
  vbMaskPen = $00000009;
  vbNotXorPen = $0000000A;
  vbNop = $0000000B;
  vbMergeNotPen = $0000000C;
  vbCopyPen = $0000000D;
  vbMergePenNot = $0000000E;
  vbMergePen = $0000000F;
  vbWhiteness = $00000010;

// Constants for enum StartUpPositionConstants
type
  StartUpPositionConstants = TOleEnum;
const
  vbStartUpManual = $00000000;
  vbStartUpOwner = $00000001;
  vbStartUpScreen = $00000002;
  vbStartUpWindowsDefault = $00000003;

// Constants for enum DrawStyleConstants
type
  DrawStyleConstants = TOleEnum;
const
  vbSolid = $00000000;
  vbDash = $00000001;
  vbDot = $00000002;
  vbDashDot = $00000003;
  vbDashDotDot = $00000004;
  vbInvisible = $00000005;
  vbInsideSolid = $00000006;

// Constants for enum FillStyleConstants
type
  FillStyleConstants = TOleEnum;
const
  vbFSSolid = $00000000;
  vbFSTransparent = $00000001;
  vbHorizontalLine = $00000002;
  vbVerticalLine = $00000003;
  vbUpwardDiagonal = $00000004;
  vbDownwardDiagonal = $00000005;
  vbCross = $00000006;
  vbDiagonalCross = $00000007;

// Constants for enum ScaleModeConstants
type
  ScaleModeConstants = TOleEnum;
const
  vbUser = $00000000;
  vbTwips = $00000001;
  vbPoints = $00000002;
  vbPixels = $00000003;
  vbCharacters = $00000004;
  vbInches = $00000005;
  vbMillimeters = $00000006;
  vbCentimeters = $00000007;
  vbHimetric = $00000008;
  vbContainerPosition = $00000009;
  vbContainerSize = $0000000A;

// Constants for enum OLEContainerConstants
type
  OLEContainerConstants = TOleEnum;
const
  vbOLELinked = $00000000;
  vbOLEEmbedded = $00000001;
  vbOLENone = $00000003;
  vbOLEEither = $00000002;
  vbOLEAutomatic = $00000000;
  vbOLEFrozen = $00000001;
  vbOLEManual = $00000002;
  vbOLEActivateManual = $00000000;
  vbOLEActivateGetFocus = $00000001;
  vbOLEActivateDoubleclick = $00000002;
  vbOLEActivateAuto = $00000003;
  vbOLESizeClip = $00000000;
  vbOLESizeStretch = $00000001;
  vbOLESizeAutoSize = $00000002;
  vbOLESizeZoom = $00000003;
  vbOLEDisplayContent = $00000000;
  vbOLEDisplayIcon = $00000001;
  vbOLEChanged = $00000000;
  vbOLESaved = $00000001;
  vbOLEClosed = $00000002;
  vbOLERenamed = $00000003;
  vbOLEPrimary = $00000000;
  vbOLEShow = $FFFFFFFF;
  vbOLEOpen = $FFFFFFFE;
  vbOLEHide = $FFFFFFFD;
  vbOLEUIActivate = $FFFFFFFC;
  vbOLEInPlaceActivate = $FFFFFFFB;
  vbOLEDiscardUndoState = $FFFFFFFA;
  vbOLEFlagGrayed = $00000001;
  vbOLEFlagDisabled = $00000002;
  vbOLEFlagChecked = $00000008;
  vbOLEFlagSeparator = $00000800;
  vbOLEMiscFlagMemStorage = $00000001;
  vbOLEMiscFlagDisableInPlace = $00000002;

// Constants for enum MenuControlConstants
type
  MenuControlConstants = TOleEnum;
const
  vbPopupMenuLeftAlign = $00000000;
  vbPopupMenuCenterAlign = $00000004;
  vbPopupMenuRightAlign = $00000008;
  vbPopupMenuLeftButton = $00000000;
  vbPopupMenuRightButton = $00000002;

// Constants for enum PrinterObjectConstants
type
  PrinterObjectConstants = TOleEnum;
const
  vbPRCMMonochrome = $00000001;
  vbPRCMColor = $00000002;
  vbPRDPSimplex = $00000001;
  vbPRDPHorizontal = $00000002;
  vbPRDPVertical = $00000003;
  vbPRORPortrait = $00000001;
  vbPRORLandscape = $00000002;
  vbPRPQDraft = $FFFFFFFF;
  vbPRPQLow = $FFFFFFFE;
  vbPRPQMedium = $FFFFFFFD;
  vbPRPQHigh = $FFFFFFFC;
  vbPRBNUpper = $00000001;
  vbPRBNLower = $00000002;
  vbPRBNMiddle = $00000003;
  vbPRBNManual = $00000004;
  vbPRBNEnvelope = $00000005;
  vbPRBNEnvManual = $00000006;
  vbPRBNAuto = $00000007;
  vbPRBNTractor = $00000008;
  vbPRBNSmallFmt = $00000009;
  vbPRBNLargeFmt = $0000000A;
  vbPRBNLargeCapacity = $0000000B;
  vbPRBNCassette = $0000000E;
  vbPRPSLetter = $00000001;
  vbPRPSLetterSmall = $00000002;
  vbPRPSTabloid = $00000003;
  vbPRPSLedger = $00000004;
  vbPRPSLegal = $00000005;
  vbPRPSStatement = $00000006;
  vbPRPSExecutive = $00000007;
  vbPRPSA3 = $00000008;
  vbPRPSA4 = $00000009;
  vbPRPSA4Small = $0000000A;
  vbPRPSA5 = $0000000B;
  vbPRPSB4 = $0000000C;
  vbPRPSB5 = $0000000D;
  vbPRPSFolio = $0000000E;
  vbPRPSQuarto = $0000000F;
  vbPRPS10x14 = $00000010;
  vbPRPS11x17 = $00000011;
  vbPRPSNote = $00000012;
  vbPRPSEnv9 = $00000013;
  vbPRPSEnv10 = $00000014;
  vbPRPSEnv11 = $00000015;
  vbPRPSEnv12 = $00000016;
  vbPRPSEnv14 = $00000017;
  vbPRPSCSheet = $00000018;
  vbPRPSDSheet = $00000019;
  vbPRPSESheet = $0000001A;
  vbPRPSEnvDL = $0000001B;
  vbPRPSEnvC3 = $0000001D;
  vbPRPSEnvC4 = $0000001E;
  vbPRPSEnvC5 = $0000001C;
  vbPRPSEnvC6 = $0000001F;
  vbPRPSEnvC65 = $00000020;
  vbPRPSEnvB4 = $00000021;
  vbPRPSEnvB5 = $00000022;
  vbPRPSEnvB6 = $00000023;
  vbPRPSEnvItaly = $00000024;
  vbPRPSEnvMonarch = $00000025;
  vbPRPSEnvPersonal = $00000026;
  vbPRPSFanfoldUS = $00000027;
  vbPRPSFanfoldStdGerman = $00000028;
  vbPRPSFanfoldLglGerman = $00000029;
  vbPRPSUser = $00000100;

// Constants for enum RasterOpConstants
type
  RasterOpConstants = TOleEnum;
const
  vbDstInvert = $00550009;
  vbMergeCopy = $00C000CA;
  vbMergePaint = $00BB0226;
  vbNotSrcCopy = $00330008;
  vbNotSrcErase = $001100A6;
  vbSrcAnd = $008800C6;
  vbSrcCopy = $00CC0020;
  vbSrcErase = $00440328;
  vbSrcInvert = $00660046;
  vbSrcPaint = $00EE0086;
  vbPatCopy = $00F00021;
  vbPatPaint = $00FB0A09;
  vbPatInvert = $005A0049;

// Constants for enum CheckBoxConstants
type
  CheckBoxConstants = TOleEnum;
const
  vbUnchecked = $00000000;
  vbChecked = $00000001;
  vbGrayed = $00000002;

// Constants for enum LoadResConstants
type
  LoadResConstants = TOleEnum;
const
  vbResBitmap = $00000000;
  vbResIcon = $00000001;
  vbResCursor = $00000002;

// Constants for enum ButtonConstants
type
  ButtonConstants = TOleEnum;
const
  vbButtonStandard = $00000000;
  vbButtonGraphical = $00000001;

// Constants for enum ListBoxConstants
type
  ListBoxConstants = TOleEnum;
const
  vbListBoxStandard = $00000000;
  vbListBoxCheckbox = $00000001;

// Constants for enum ParentControlsType
type
  ParentControlsType = TOleEnum;
const
  vbNoExtender = $00000000;
  vbExtender = $00000001;

// Constants for enum LoadPictureSizeConstants
type
  LoadPictureSizeConstants = TOleEnum;
const
  vbLPSmall = $00000000;
  vbLPLarge = $00000001;
  vbLPSmallShell = $00000002;
  vbLPLargeShell = $00000003;
  vbLPCustom = $00000004;

// Constants for enum LoadPictureColorConstants
type
  LoadPictureColorConstants = TOleEnum;
const
  vbLPDefault = $00000000;
  vbLPMonochrome = $00000001;
  vbLPVGAColor = $00000002;
  vbLPColor = $00000003;

// Constants for enum HitResultConstants
type
  HitResultConstants = TOleEnum;
const
  vbHitResultOutside = $00000000;
  vbHitResultTransparent = $00000001;
  vbHitResultClose = $00000002;
  vbHitResultHit = $00000003;

// Constants for enum LogModeConstants
type
  LogModeConstants = TOleEnum;
const
  vbLogAuto = $00000000;
  vbLogOff = $00000001;
  vbLogToFile = $00000002;
  vbLogToNT = $00000003;
  vbLogOverwrite = $00000010;
  vbLogThreadID = $00000020;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  PropertyBag_VB5 = interface;
  PropertyBag_VB5Disp = dispinterface;
  _PropertyBag = interface;
  _PropertyBagDisp = dispinterface;
  DataObjectFiles = interface;
  DataObjectFilesDisp = dispinterface;
  DataObject = interface;
  DataObjectDisp = dispinterface;
  AmbientProperties = interface;
  AmbientPropertiesDisp = dispinterface;
  SelectedControls = interface;
  SelectedControlsDisp = dispinterface;
  ParentControls = interface;
  ParentControlsDisp = dispinterface;
  ContainedControls = interface;
  ContainedControlsDisp = dispinterface;
  DataBindings = interface;
  DataBindingsDisp = dispinterface;
  DataBinding = interface;
  DataBindingDisp = dispinterface;
  EventParameter = interface;
  EventParameterDisp = dispinterface;
  EventParameters = interface;
  EventParametersDisp = dispinterface;
  EventInfo = interface;
  EventInfoDisp = dispinterface;
  Hyperlink = interface;
  HyperlinkDisp = dispinterface;
  AsyncProperty_VB5 = interface;
  AsyncProperty_VB5Disp = dispinterface;
  AsyncProperty = interface;
  AsyncPropertyDisp = dispinterface;
  DataMembers = interface;
  DataMembersDisp = dispinterface;
  IClassModuleEvt = interface;
  IDataSourceClassEvt = interface;
  IPersistableClassEvt = interface;
  IPersistableDataSourceClassEvt = interface;
  IDataProviderClassEvt = interface;
  IPersistableDataProviderClassEvt = interface;
  _DClass = dispinterface;
  _DDataBoundClass = dispinterface;
  _DDataSourceClass = dispinterface;
  _DDataBoundAndDataSourceClass = dispinterface;
  _DPersistableClass = dispinterface;
  _DPersistableDataSourceClass = dispinterface;
  LicenseInfo = interface;
  LicenseInfoDisp = dispinterface;
  Licenses = interface;
  LicensesDisp = dispinterface;
  IProjectControl = interface;
  IVbeRuntimeHost = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  PropertyBag = _PropertyBag;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PWideString1 = ^WideString; {*}
  PUserType1 = ^TGUID; {*}


// *********************************************************************//
// Interface: PropertyBag_VB5
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {45046D60-08CA-11CF-A90F-00AA0062BB4C}
// *********************************************************************//
  PropertyBag_VB5 = interface(IDispatch)
    ['{45046D60-08CA-11CF-A90F-00AA0062BB4C}']
    function ReadProperty(const Name: WideString; DefaultValue: OleVariant): OleVariant; safecall;
    procedure WriteProperty(const Name: WideString; Value: OleVariant; DefaultValue: OleVariant); safecall;
  end;

// *********************************************************************//
// DispIntf:  PropertyBag_VB5Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {45046D60-08CA-11CF-A90F-00AA0062BB4C}
// *********************************************************************//
  PropertyBag_VB5Disp = dispinterface
    ['{45046D60-08CA-11CF-A90F-00AA0062BB4C}']
    function ReadProperty(const Name: WideString; DefaultValue: OleVariant): OleVariant; dispid 1;
    procedure WriteProperty(const Name: WideString; Value: OleVariant; DefaultValue: OleVariant); dispid 2;
  end;

// *********************************************************************//
// Interface: _PropertyBag
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4495AD01-C993-11D1-A3E4-00A0C90AEA82}
// *********************************************************************//
  _PropertyBag = interface(IDispatch)
    ['{4495AD01-C993-11D1-A3E4-00A0C90AEA82}']
    function ReadProperty(const Name: WideString; DefaultValue: OleVariant): OleVariant; safecall;
    procedure WriteProperty(const Name: WideString; Value: OleVariant; DefaultValue: OleVariant); safecall;
    function Get_Contents: OleVariant; safecall;
    procedure Set_Contents(retval: OleVariant); safecall;
    property Contents: OleVariant read Get_Contents write Set_Contents;
  end;

// *********************************************************************//
// DispIntf:  _PropertyBagDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {4495AD01-C993-11D1-A3E4-00A0C90AEA82}
// *********************************************************************//
  _PropertyBagDisp = dispinterface
    ['{4495AD01-C993-11D1-A3E4-00A0C90AEA82}']
    function ReadProperty(const Name: WideString; DefaultValue: OleVariant): OleVariant; dispid 1;
    procedure WriteProperty(const Name: WideString; Value: OleVariant; DefaultValue: OleVariant); dispid 2;
    property Contents: OleVariant dispid 3;
  end;

// *********************************************************************//
// Interface: DataObjectFiles
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {41A7D761-6018-11CF-9016-00AA0068841E}
// *********************************************************************//
  DataObjectFiles = interface(IDispatch)
    ['{41A7D761-6018-11CF-9016-00AA0068841E}']
    function Get_Item(index: Integer): WideString; safecall;
    function Get_Count: Integer; safecall;
    procedure Add(const Filename: WideString; index: OleVariant); safecall;
    procedure Clear; safecall;
    procedure Remove(index: OleVariant); safecall;
    function _NewEnum: IUnknown; safecall;
    property Item[index: Integer]: WideString read Get_Item; default;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  DataObjectFilesDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {41A7D761-6018-11CF-9016-00AA0068841E}
// *********************************************************************//
  DataObjectFilesDisp = dispinterface
    ['{41A7D761-6018-11CF-9016-00AA0068841E}']
    property Item[index: Integer]: WideString readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    procedure Add(const Filename: WideString; index: OleVariant); dispid 2;
    procedure Clear; dispid 3;
    procedure Remove(index: OleVariant); dispid 4;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: DataObject
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {41A7D760-6018-11CF-9016-00AA0068841E}
// *********************************************************************//
  DataObject = interface(IDispatch)
    ['{41A7D760-6018-11CF-9016-00AA0068841E}']
    procedure Clear; safecall;
    procedure SetData(Value: OleVariant; Format: OleVariant); safecall;
    function GetData(Format: Smallint): OleVariant; safecall;
    function GetFormat(Format: Smallint): WordBool; safecall;
    function Get_Files: DataObjectFiles; safecall;
    property Files: DataObjectFiles read Get_Files;
  end;

// *********************************************************************//
// DispIntf:  DataObjectDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {41A7D760-6018-11CF-9016-00AA0068841E}
// *********************************************************************//
  DataObjectDisp = dispinterface
    ['{41A7D760-6018-11CF-9016-00AA0068841E}']
    procedure Clear; dispid 1;
    procedure SetData(Value: OleVariant; Format: OleVariant); dispid 2;
    function GetData(Format: Smallint): OleVariant; dispid 3;
    function GetFormat(Format: Smallint): WordBool; dispid 4;
    property Files: DataObjectFiles readonly dispid 5;
  end;

// *********************************************************************//
// Interface: AmbientProperties
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B28FA150-0FF0-11CF-A911-00AA0062BB4C}
// *********************************************************************//
  AmbientProperties = interface(IDispatch)
    ['{B28FA150-0FF0-11CF-A911-00AA0062BB4C}']
    function Get_BackColor: OLE_COLOR; safecall;
    function Get_DisplayName: WideString; safecall;
    function Get_Font: IFontDisp; safecall;
    function Get_ForeColor: OLE_COLOR; safecall;
    function Get_LocaleID: Integer; safecall;
    function Get_MessageReflect: WordBool; safecall;
    function Get_ScaleUnits: WideString; safecall;
    function Get_TextAlign: Smallint; safecall;
    function Get_UserMode: WordBool; safecall;
    function Get_UIDead: WordBool; safecall;
    function Get_ShowGrabHandles: WordBool; safecall;
    function Get_ShowHatching: WordBool; safecall;
    function Get_DisplayAsDefault: WordBool; safecall;
    function Get_SupportsMnemonics: WordBool; safecall;
    function Get_Palette: IPictureDisp; safecall;
    function Get_RightToLeft: WordBool; safecall;
    property BackColor: OLE_COLOR read Get_BackColor;
    property DisplayName: WideString read Get_DisplayName;
    property Font: IFontDisp read Get_Font;
    property ForeColor: OLE_COLOR read Get_ForeColor;
    property LocaleID: Integer read Get_LocaleID;
    property MessageReflect: WordBool read Get_MessageReflect;
    property ScaleUnits: WideString read Get_ScaleUnits;
    property TextAlign: Smallint read Get_TextAlign;
    property UserMode: WordBool read Get_UserMode;
    property UIDead: WordBool read Get_UIDead;
    property ShowGrabHandles: WordBool read Get_ShowGrabHandles;
    property ShowHatching: WordBool read Get_ShowHatching;
    property DisplayAsDefault: WordBool read Get_DisplayAsDefault;
    property SupportsMnemonics: WordBool read Get_SupportsMnemonics;
    property Palette: IPictureDisp read Get_Palette;
    property RightToLeft: WordBool read Get_RightToLeft;
  end;

// *********************************************************************//
// DispIntf:  AmbientPropertiesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B28FA150-0FF0-11CF-A911-00AA0062BB4C}
// *********************************************************************//
  AmbientPropertiesDisp = dispinterface
    ['{B28FA150-0FF0-11CF-A911-00AA0062BB4C}']
    property BackColor: OLE_COLOR readonly dispid -701;
    property DisplayName: WideString readonly dispid -702;
    property Font: IFontDisp readonly dispid -703;
    property ForeColor: OLE_COLOR readonly dispid -704;
    property LocaleID: Integer readonly dispid -705;
    property MessageReflect: WordBool readonly dispid -706;
    property ScaleUnits: WideString readonly dispid -707;
    property TextAlign: Smallint readonly dispid -708;
    property UserMode: WordBool readonly dispid -709;
    property UIDead: WordBool readonly dispid -710;
    property ShowGrabHandles: WordBool readonly dispid -711;
    property ShowHatching: WordBool readonly dispid -712;
    property DisplayAsDefault: WordBool readonly dispid -713;
    property SupportsMnemonics: WordBool readonly dispid -714;
    property Palette: IPictureDisp readonly dispid -726;
    property RightToLeft: WordBool readonly dispid -732;
  end;

// *********************************************************************//
// Interface: SelectedControls
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2CE46480-1A08-11CF-AD63-00AA00614F3E}
// *********************************************************************//
  SelectedControls = interface(IDispatch)
    ['{2CE46480-1A08-11CF-AD63-00AA00614F3E}']
    function Get_Count: Integer; safecall;
    function Get_Item(index: Integer): IDispatch; safecall;
    function _NewEnum: IUnknown; safecall;
    property Count: Integer read Get_Count;
    property Item[index: Integer]: IDispatch read Get_Item; default;
  end;

// *********************************************************************//
// DispIntf:  SelectedControlsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2CE46480-1A08-11CF-AD63-00AA00614F3E}
// *********************************************************************//
  SelectedControlsDisp = dispinterface
    ['{2CE46480-1A08-11CF-AD63-00AA00614F3E}']
    property Count: Integer readonly dispid 1;
    property Item[index: Integer]: IDispatch readonly dispid 0; default;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: ParentControls
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {BE8F9800-2AAA-11CF-AD67-00AA00614F3E}
// *********************************************************************//
  ParentControls = interface(IDispatch)
    ['{BE8F9800-2AAA-11CF-AD67-00AA00614F3E}']
    function Get_Count: Integer; safecall;
    function Get_Item(index: Integer): IDispatch; safecall;
    function _NewEnum: IUnknown; safecall;
    function Get_ParentControlsType: ParentControlsType; safecall;
    procedure Set_ParentControlsType(Return: ParentControlsType); safecall;
    property Count: Integer read Get_Count;
    property Item[index: Integer]: IDispatch read Get_Item; default;
    property ParentControlsType: ParentControlsType read Get_ParentControlsType write Set_ParentControlsType;
  end;

// *********************************************************************//
// DispIntf:  ParentControlsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {BE8F9800-2AAA-11CF-AD67-00AA00614F3E}
// *********************************************************************//
  ParentControlsDisp = dispinterface
    ['{BE8F9800-2AAA-11CF-AD67-00AA00614F3E}']
    property Count: Integer readonly dispid 1;
    property Item[index: Integer]: IDispatch readonly dispid 0; default;
    function _NewEnum: IUnknown; dispid -4;
    property ParentControlsType: ParentControlsType dispid 2;
  end;

// *********************************************************************//
// Interface: ContainedControls
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C0324960-2AAA-11CF-AD67-00AA00614F3E}
// *********************************************************************//
  ContainedControls = interface(IDispatch)
    ['{C0324960-2AAA-11CF-AD67-00AA00614F3E}']
    function Get_Count: Integer; safecall;
    function Get_Item(index: Integer): IDispatch; safecall;
    function _NewEnum: IUnknown; safecall;
    property Count: Integer read Get_Count;
    property Item[index: Integer]: IDispatch read Get_Item; default;
  end;

// *********************************************************************//
// DispIntf:  ContainedControlsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C0324960-2AAA-11CF-AD67-00AA00614F3E}
// *********************************************************************//
  ContainedControlsDisp = dispinterface
    ['{C0324960-2AAA-11CF-AD67-00AA00614F3E}']
    property Count: Integer readonly dispid 1;
    property Item[index: Integer]: IDispatch readonly dispid 0; default;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: DataBindings
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {D4E0F020-720A-11CF-8136-00AA00C14959}
// *********************************************************************//
  DataBindings = interface(IDispatch)
    ['{D4E0F020-720A-11CF-8136-00AA00C14959}']
    function Get_Count: Integer; safecall;
    function Get_Item(_Index: OleVariant): IDispatch; safecall;
    function _NewEnum: IUnknown; safecall;
    property Count: Integer read Get_Count;
    property Item[_Index: OleVariant]: IDispatch read Get_Item; default;
  end;

// *********************************************************************//
// DispIntf:  DataBindingsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {D4E0F020-720A-11CF-8136-00AA00C14959}
// *********************************************************************//
  DataBindingsDisp = dispinterface
    ['{D4E0F020-720A-11CF-8136-00AA00C14959}']
    property Count: Integer readonly dispid 1;
    property Item[_Index: OleVariant]: IDispatch readonly dispid 0; default;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: DataBinding
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {7500A6BA-EB65-11D1-938D-0000F87557C9}
// *********************************************************************//
  DataBinding = interface(IDispatch)
    ['{7500A6BA-EB65-11D1-938D-0000F87557C9}']
    function Get_PropertyName: WideString; safecall;
    function Get_DataField: WideString; safecall;
    procedure Set_DataField(const Return: WideString); safecall;
    function Get_DataChanged: WordBool; safecall;
    procedure Set_DataChanged(Return: WordBool); safecall;
    function Get_DataSourceName: WideString; safecall;
    procedure Set_DataSourceName(const Return: WideString); safecall;
    function Get_IsDataSource: WordBool; safecall;
    function Get_IsBindable: WordBool; safecall;
    function Get_DataMember: DataMember; safecall;
    procedure Set_DataMember(const Return: DataMember); safecall;
    function Get_DataFormat: DataFormat; safecall;
    procedure _Set_DataFormat(const Return: DataFormat); safecall;
    function Get_DataSource: DataSource; safecall;
    procedure _Set_DataSource(const Return: DataSource); safecall;
    property PropertyName: WideString read Get_PropertyName;
    property DataField: WideString read Get_DataField write Set_DataField;
    property DataChanged: WordBool read Get_DataChanged write Set_DataChanged;
    property DataSourceName: WideString read Get_DataSourceName write Set_DataSourceName;
    property IsDataSource: WordBool read Get_IsDataSource;
    property IsBindable: WordBool read Get_IsBindable;
    property DataMember: DataMember read Get_DataMember write Set_DataMember;
    property DataFormat: DataFormat read Get_DataFormat write _Set_DataFormat;
    property DataSource: DataSource read Get_DataSource write _Set_DataSource;
  end;

// *********************************************************************//
// DispIntf:  DataBindingDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {7500A6BA-EB65-11D1-938D-0000F87557C9}
// *********************************************************************//
  DataBindingDisp = dispinterface
    ['{7500A6BA-EB65-11D1-938D-0000F87557C9}']
    property PropertyName: WideString readonly dispid 5;
    property DataField: WideString dispid 0;
    property DataChanged: WordBool dispid 1;
    property DataSourceName: WideString dispid 2;
    property IsDataSource: WordBool readonly dispid 3;
    property IsBindable: WordBool readonly dispid 4;
    property DataMember: DataMember dispid 6;
    property DataFormat: DataFormat dispid 7;
    property DataSource: DataSource dispid 8;
  end;

// *********************************************************************//
// Interface: EventParameter
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C4D651F0-7697-11D1-A1E9-00A0C90F2731}
// *********************************************************************//
  EventParameter = interface(IDispatch)
    ['{C4D651F0-7697-11D1-A1E9-00A0C90F2731}']
    function Get_Value: OleVariant; safecall;
    procedure Set_Value(Return: OleVariant); safecall;
    function Get_Name: WideString; safecall;
    property Value: OleVariant read Get_Value write Set_Value;
    property Name: WideString read Get_Name;
  end;

// *********************************************************************//
// DispIntf:  EventParameterDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C4D651F0-7697-11D1-A1E9-00A0C90F2731}
// *********************************************************************//
  EventParameterDisp = dispinterface
    ['{C4D651F0-7697-11D1-A1E9-00A0C90F2731}']
    property Value: OleVariant dispid 0;
    property Name: WideString readonly dispid 1;
  end;

// *********************************************************************//
// Interface: EventParameters
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C4D651F1-7697-11D1-A1E9-00A0C90F2731}
// *********************************************************************//
  EventParameters = interface(IDispatch)
    ['{C4D651F1-7697-11D1-A1E9-00A0C90F2731}']
    function Get_Item(index: OleVariant): EventParameter; safecall;
    function Get_Count: Integer; safecall;
    function _NewEnum: IUnknown; safecall;
    property Item[index: OleVariant]: EventParameter read Get_Item; default;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  EventParametersDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C4D651F1-7697-11D1-A1E9-00A0C90F2731}
// *********************************************************************//
  EventParametersDisp = dispinterface
    ['{C4D651F1-7697-11D1-A1E9-00A0C90F2731}']
    property Item[index: OleVariant]: EventParameter readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: EventInfo
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C4D651F2-7697-11D1-A1E9-00A0C90F2731}
// *********************************************************************//
  EventInfo = interface(IDispatch)
    ['{C4D651F2-7697-11D1-A1E9-00A0C90F2731}']
    function Get_Name: WideString; safecall;
    function Get_EventParameters: EventParameters; safecall;
    property Name: WideString read Get_Name;
    property EventParameters: EventParameters read Get_EventParameters;
  end;

// *********************************************************************//
// DispIntf:  EventInfoDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C4D651F2-7697-11D1-A1E9-00A0C90F2731}
// *********************************************************************//
  EventInfoDisp = dispinterface
    ['{C4D651F2-7697-11D1-A1E9-00A0C90F2731}']
    property Name: WideString readonly dispid 0;
    property EventParameters: EventParameters readonly dispid 1;
  end;

// *********************************************************************//
// Interface: Hyperlink
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {888A5A60-B283-11CF-8AD5-00A0C90AEA82}
// *********************************************************************//
  Hyperlink = interface(IDispatch)
    ['{888A5A60-B283-11CF-8AD5-00A0C90AEA82}']
    procedure GoForward; safecall;
    procedure GoBack; safecall;
    procedure NavigateTo(const Target: WideString; const Location: WideString; 
                         const FrameName: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  HyperlinkDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {888A5A60-B283-11CF-8AD5-00A0C90AEA82}
// *********************************************************************//
  HyperlinkDisp = dispinterface
    ['{888A5A60-B283-11CF-8AD5-00A0C90AEA82}']
    procedure GoForward; dispid 3;
    procedure GoBack; dispid 4;
    procedure NavigateTo(const Target: WideString; const Location: WideString; 
                         const FrameName: WideString); dispid 5;
  end;

// *********************************************************************//
// Interface: AsyncProperty_VB5
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {14E469E0-BF61-11CF-8385-8F69D8F1350B}
// *********************************************************************//
  AsyncProperty_VB5 = interface(IDispatch)
    ['{14E469E0-BF61-11CF-8385-8F69D8F1350B}']
    function Get_Value: OleVariant; safecall;
    function Get_AsyncType: AsyncTypeConstants; safecall;
    function Get_PropertyName: WideString; safecall;
    property Value: OleVariant read Get_Value;
    property AsyncType: AsyncTypeConstants read Get_AsyncType;
    property PropertyName: WideString read Get_PropertyName;
  end;

// *********************************************************************//
// DispIntf:  AsyncProperty_VB5Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {14E469E0-BF61-11CF-8385-8F69D8F1350B}
// *********************************************************************//
  AsyncProperty_VB5Disp = dispinterface
    ['{14E469E0-BF61-11CF-8385-8F69D8F1350B}']
    property Value: OleVariant readonly dispid 1;
    property AsyncType: AsyncTypeConstants readonly dispid 2;
    property PropertyName: WideString readonly dispid 3;
  end;

// *********************************************************************//
// Interface: AsyncProperty
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CBB76011-C508-11D1-A3E3-00A0C90AEA82}
// *********************************************************************//
  AsyncProperty = interface(IDispatch)
    ['{CBB76011-C508-11D1-A3E3-00A0C90AEA82}']
    function Get_Value: OleVariant; safecall;
    function Get_AsyncType: AsyncTypeConstants; safecall;
    function Get_PropertyName: WideString; safecall;
    function Get_Target: WideString; safecall;
    function Get_BytesRead: Integer; safecall;
    function Get_BytesMax: Integer; safecall;
    function Get_Status: WideString; safecall;
    function Get_StatusCode: AsyncStatusCodeConstants; safecall;
    property Value: OleVariant read Get_Value;
    property AsyncType: AsyncTypeConstants read Get_AsyncType;
    property PropertyName: WideString read Get_PropertyName;
    property Target: WideString read Get_Target;
    property BytesRead: Integer read Get_BytesRead;
    property BytesMax: Integer read Get_BytesMax;
    property Status: WideString read Get_Status;
    property StatusCode: AsyncStatusCodeConstants read Get_StatusCode;
  end;

// *********************************************************************//
// DispIntf:  AsyncPropertyDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CBB76011-C508-11D1-A3E3-00A0C90AEA82}
// *********************************************************************//
  AsyncPropertyDisp = dispinterface
    ['{CBB76011-C508-11D1-A3E3-00A0C90AEA82}']
    property Value: OleVariant readonly dispid 1;
    property AsyncType: AsyncTypeConstants readonly dispid 2;
    property PropertyName: WideString readonly dispid 3;
    property Target: WideString readonly dispid 4;
    property BytesRead: Integer readonly dispid 5;
    property BytesMax: Integer readonly dispid 6;
    property Status: WideString readonly dispid 7;
    property StatusCode: AsyncStatusCodeConstants readonly dispid 8;
  end;

// *********************************************************************//
// Interface: DataMembers
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {83C49FF0-B294-11D0-9488-00A0C91110ED}
// *********************************************************************//
  DataMembers = interface(IDispatch)
    ['{83C49FF0-B294-11D0-9488-00A0C91110ED}']
    function Get_Item(index: Integer): DataMember; safecall;
    function Get_Count: Integer; safecall;
    procedure Add(const DataMember: DataMember); safecall;
    procedure Clear; safecall;
    procedure Remove(index: OleVariant); safecall;
    function _NewEnum: IUnknown; safecall;
    property Item[index: Integer]: DataMember read Get_Item; default;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  DataMembersDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {83C49FF0-B294-11D0-9488-00A0C91110ED}
// *********************************************************************//
  DataMembersDisp = dispinterface
    ['{83C49FF0-B294-11D0-9488-00A0C91110ED}']
    property Item[index: Integer]: DataMember readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    procedure Add(const DataMember: DataMember); dispid 2;
    procedure Clear; dispid 3;
    procedure Remove(index: OleVariant); dispid 4;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: IClassModuleEvt
// Flags:     (16) Hidden
// GUID:      {FCFB3D21-A0FA-1068-A738-08002B3371B5}
// *********************************************************************//
  IClassModuleEvt = interface(IUnknown)
    ['{FCFB3D21-A0FA-1068-A738-08002B3371B5}']
    function Initialize: HResult; stdcall;
    function Terminate: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDataSourceClassEvt
// Flags:     (16) Hidden
// GUID:      {6B121A01-45DF-11D1-8907-00A0C9110049}
// *********************************************************************//
  IDataSourceClassEvt = interface(IUnknown)
    ['{6B121A01-45DF-11D1-8907-00A0C9110049}']
    function Initialize: HResult; stdcall;
    function Terminate: HResult; stdcall;
    function GetDataMember(var DataMember: WideString; out Data: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IPersistableClassEvt
// Flags:     (16) Hidden
// GUID:      {6B121A02-45DF-11D1-8907-00A0C9110049}
// *********************************************************************//
  IPersistableClassEvt = interface(IUnknown)
    ['{6B121A02-45DF-11D1-8907-00A0C9110049}']
    function Initialize: HResult; stdcall;
    function Terminate: HResult; stdcall;
    function InitProperties: HResult; stdcall;
    function ReadProperties(var PropBag: _PropertyBag): HResult; stdcall;
    function WriteProperties(var PropBag: _PropertyBag): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IPersistableDataSourceClassEvt
// Flags:     (16) Hidden
// GUID:      {6B121A03-45DF-11D1-8907-00A0C9110049}
// *********************************************************************//
  IPersistableDataSourceClassEvt = interface(IUnknown)
    ['{6B121A03-45DF-11D1-8907-00A0C9110049}']
    function Initialize: HResult; stdcall;
    function Terminate: HResult; stdcall;
    function GetDataMember(var DataMember: WideString; out Data: IDispatch): HResult; stdcall;
    function InitProperties: HResult; stdcall;
    function ReadProperties(var PropBag: _PropertyBag): HResult; stdcall;
    function WriteProperties(var PropBag: _PropertyBag): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDataProviderClassEvt
// Flags:     (16) Hidden
// GUID:      {6B121A04-45DF-11D1-8907-00A0C9110049}
// *********************************************************************//
  IDataProviderClassEvt = interface(IUnknown)
    ['{6B121A04-45DF-11D1-8907-00A0C9110049}']
    function Initialize: HResult; stdcall;
    function Terminate: HResult; stdcall;
    function GetDataMember(var DataMember: WideString; out Data: IDispatch): HResult; stdcall;
    function DataConnection(var ConnectionString: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IPersistableDataProviderClassEvt
// Flags:     (16) Hidden
// GUID:      {6B121A05-45DF-11D1-8907-00A0C9110049}
// *********************************************************************//
  IPersistableDataProviderClassEvt = interface(IUnknown)
    ['{6B121A05-45DF-11D1-8907-00A0C9110049}']
    function Initialize: HResult; stdcall;
    function Terminate: HResult; stdcall;
    function GetDataMember(var DataMember: WideString; out Data: IDispatch): HResult; stdcall;
    function DataConnection(const ConnectionString: WideString): HResult; stdcall;
    function InitProperties: HResult; stdcall;
    function ReadProperties(var PropBag: _PropertyBag): HResult; stdcall;
    function WriteProperties(var PropBag: _PropertyBag): HResult; stdcall;
  end;

// *********************************************************************//
// DispIntf:  _DClass
// Flags:     (4240) Hidden NonExtensible Dispatchable
// GUID:      {FCFB3D2B-A0FA-1068-A738-08002B3371B5}
// *********************************************************************//
  _DClass = dispinterface
    ['{FCFB3D2B-A0FA-1068-A738-08002B3371B5}']
  end;

// *********************************************************************//
// DispIntf:  _DDataBoundClass
// Flags:     (4240) Hidden NonExtensible Dispatchable
// GUID:      {EB41E8C1-4442-11D1-8906-00A0C9110049}
// *********************************************************************//
  _DDataBoundClass = dispinterface
    ['{EB41E8C1-4442-11D1-8906-00A0C9110049}']
    procedure PropertyChanged(const PropertyName: WideString); dispid 1;
    function CanPropertyChange(const PropertyName: WideString): WordBool; dispid 2;
  end;

// *********************************************************************//
// DispIntf:  _DDataSourceClass
// Flags:     (4240) Hidden NonExtensible Dispatchable
// GUID:      {EB41E8C2-4442-11D1-8906-00A0C9110049}
// *********************************************************************//
  _DDataSourceClass = dispinterface
    ['{EB41E8C2-4442-11D1-8906-00A0C9110049}']
    procedure DataMemberChanged(const DataMember: DataMember); dispid 3;
    property DataMembers: DataMembers readonly dispid 4;
  end;

// *********************************************************************//
// DispIntf:  _DDataBoundAndDataSourceClass
// Flags:     (4240) Hidden NonExtensible Dispatchable
// GUID:      {EB41E8C3-4442-11D1-8906-00A0C9110049}
// *********************************************************************//
  _DDataBoundAndDataSourceClass = dispinterface
    ['{EB41E8C3-4442-11D1-8906-00A0C9110049}']
    procedure PropertyChanged(const PropertyName: WideString); dispid 1;
    function CanPropertyChange(const PropertyName: WideString): WordBool; dispid 2;
    procedure DataMemberChanged(const DataMember: DataMember); dispid 3;
    property DataMembers: DataMembers readonly dispid 4;
  end;

// *********************************************************************//
// DispIntf:  _DPersistableClass
// Flags:     (4240) Hidden NonExtensible Dispatchable
// GUID:      {EB41E8C4-4442-11D1-8906-00A0C9110049}
// *********************************************************************//
  _DPersistableClass = dispinterface
    ['{EB41E8C4-4442-11D1-8906-00A0C9110049}']
    procedure PropertyChanged(const PropertyName: WideString); dispid 1;
  end;

// *********************************************************************//
// DispIntf:  _DPersistableDataSourceClass
// Flags:     (4240) Hidden NonExtensible Dispatchable
// GUID:      {EB41E8C5-4442-11D1-8906-00A0C9110049}
// *********************************************************************//
  _DPersistableDataSourceClass = dispinterface
    ['{EB41E8C5-4442-11D1-8906-00A0C9110049}']
    procedure PropertyChanged(const PropertyName: WideString); dispid 1;
    procedure DataMemberChanged(const DataMember: DataMember); dispid 3;
    property DataMembers: DataMembers readonly dispid 4;
  end;

// *********************************************************************//
// Interface: LicenseInfo
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {8284B8A2-A8A8-11D1-A3D2-00A0C90AEA82}
// *********************************************************************//
  LicenseInfo = interface(IDispatch)
    ['{8284B8A2-A8A8-11D1-A3D2-00A0C90AEA82}']
    function Get_ProgId: WideString; safecall;
    function Get_LicenseKey: WideString; safecall;
    property ProgId: WideString read Get_ProgId;
    property LicenseKey: WideString read Get_LicenseKey;
  end;

// *********************************************************************//
// DispIntf:  LicenseInfoDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {8284B8A2-A8A8-11D1-A3D2-00A0C90AEA82}
// *********************************************************************//
  LicenseInfoDisp = dispinterface
    ['{8284B8A2-A8A8-11D1-A3D2-00A0C90AEA82}']
    property ProgId: WideString readonly dispid 0;
    property LicenseKey: WideString readonly dispid 1;
  end;

// *********************************************************************//
// Interface: Licenses
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {737361EC-467F-11D1-810F-0000F87557AA}
// *********************************************************************//
  Licenses = interface(IDispatch)
    ['{737361EC-467F-11D1-810F-0000F87557AA}']
    function Get_Item(index: OleVariant): LicenseInfo; safecall;
    function Get_Count: Integer; safecall;
    function Add(const ProgId: WideString; const LicenseKey: WideString): WideString; safecall;
    procedure Clear; safecall;
    procedure Remove(index: OleVariant); safecall;
    function _NewEnum: IUnknown; safecall;
    property Item[index: OleVariant]: LicenseInfo read Get_Item; default;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  LicensesDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {737361EC-467F-11D1-810F-0000F87557AA}
// *********************************************************************//
  LicensesDisp = dispinterface
    ['{737361EC-467F-11D1-810F-0000F87557AA}']
    property Item[index: OleVariant]: LicenseInfo readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    function Add(const ProgId: WideString; const LicenseKey: WideString): WideString; dispid 2;
    procedure Clear; dispid 3;
    procedure Remove(index: OleVariant); dispid 4;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// Interface: IProjectControl
// Flags:     (16) Hidden
// GUID:      {27F56410-6161-11D1-946E-00A0C90F26F1}
// *********************************************************************//
  IProjectControl = interface(IUnknown)
    ['{27F56410-6161-11D1-946E-00A0C90F26F1}']
    function RetainProject: HResult; stdcall;
    function UnloadProject: HResult; stdcall;
    function IsRetained(out Return: WordBool): HResult; stdcall;
    function IsPermanent(out Return: WordBool): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IVbeRuntimeHost
// Flags:     (272) Hidden OleAutomation
// GUID:      {E43FD401-8715-11D1-98E7-00A0C9702442}
// *********************************************************************//
  IVbeRuntimeHost = interface(IUnknown)
    ['{E43FD401-8715-11D1-98E7-00A0C9702442}']
    function get_AppObject(var pguidTypeInfo: TGUID; out ppdispAppObject: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoPropertyBag provides a Create and CreateRemote method to          
// create instances of the default interface _PropertyBag exposed by              
// the CoClass PropertyBag. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPropertyBag = class
    class function Create: _PropertyBag;
    class function CreateRemote(const MachineName: string): _PropertyBag;
  end;

implementation

uses ComObj;

class function CoPropertyBag.Create: _PropertyBag;
begin
  Result := CreateComObject(CLASS_PropertyBag) as _PropertyBag;
end;

class function CoPropertyBag.CreateRemote(const MachineName: string): _PropertyBag;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PropertyBag) as _PropertyBag;
end;

end.
