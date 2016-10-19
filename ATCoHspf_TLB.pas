//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit ATCoHspf_TLB;

// ************************************************************************ //
// WARNING                                                                  //
// -------                                                                  //
// The types declared in this file were generated from data read from a     //
// Type Library. If this type library is explicitly or indirectly (via      //
// another type library referring to this type library) re-imported, or the //
// 'Refresh' command of the Type Library Editor activated while editing the //
// Type Library, the contents of this file will be regenerated and all      //
// manual modifications will be lost.                                       //
// ************************************************************************ //

// PASTLWTR : $Revision:   1.11.1.75  $
// File generated on 11/26/2001 3:19:17 PM from Type Library described below.

// ************************************************************************ //
// Type Lib: D:\WINNT\system32\ATCoHspf.dll
// IID\LCID: {5CD33FEB-1E30-11D5-983F-00A024C11E04}\0
// Helpfile: 
// HelpString: 
// Version:    1.0
// ************************************************************************ //

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL, 
  VBA_TLB, ATCData_TLB;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:      //
//   Type Libraries     : LIBID_xxxx                                    //
//   CoClasses          : CLASS_xxxx                                    //
//   DISPInterfaces     : DIID_xxxx                                     //
//   Non-DISP interfaces: IID_xxxx                                      //
// *********************************************************************//
const
  LIBID_ATCoHspf: TGUID = '{5CD33FEB-1E30-11D5-983F-00A024C11E04}';
  IID__HspfUci: TGUID = '{5CD34019-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfUci: TGUID = '{5CD3401A-1E30-11D5-983F-00A024C11E04}';
  IID__HspfData: TGUID = '{5CD33FF6-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfData: TGUID = '{5CD33FF7-1E30-11D5-983F-00A024C11E04}';
  IID__HspfGlobalBlk: TGUID = '{5CD33FF4-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfGlobalBlk: TGUID = '{5CD33FF5-1E30-11D5-983F-00A024C11E04}';
  IID__HspfFilesBlk: TGUID = '{5CD33FFB-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfFilesBlk: TGUID = '{5CD33FFC-1E30-11D5-983F-00A024C11E04}';
  IID__HspfOpnSeqBlk: TGUID = '{5CD34013-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfOpnSeqBlk: TGUID = '{5CD34014-1E30-11D5-983F-00A024C11E04}';
  IID__HspfOperation: TGUID = '{5CD34011-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfOperation: TGUID = '{5CD34012-1E30-11D5-983F-00A024C11E04}';
  IID__HspfTableDef: TGUID = '{5CD33FF0-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfTableDef: TGUID = '{5CD33FF1-1E30-11D5-983F-00A024C11E04}';
  IID__HspfBlockDef: TGUID = '{5CD33FEC-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfBlockDef: TGUID = '{5CD33FED-1E30-11D5-983F-00A024C11E04}';
  IID__HspfMsg: TGUID = '{5CD33FF2-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfMsg: TGUID = '{5CD33FF3-1E30-11D5-983F-00A024C11E04}';
  IID__HspfSectionDef: TGUID = '{5CD33FEE-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfSectionDef: TGUID = '{5CD33FEF-1E30-11D5-983F-00A024C11E04}';
  IID__HspfTable: TGUID = '{5CD34029-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfTable: TGUID = '{5CD3402A-1E30-11D5-983F-00A024C11E04}';
  IID__HspfOpnBlk: TGUID = '{5CD34006-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfOpnBlk: TGUID = '{5CD34007-1E30-11D5-983F-00A024C11E04}';
  IID__HspfFtable: TGUID = '{5CD34008-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfFtable: TGUID = '{5CD34009-1E30-11D5-983F-00A024C11E04}';
  IID__HspfConnection: TGUID = '{5CD33FFF-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfConnection: TGUID = '{5CD34000-1E30-11D5-983F-00A024C11E04}';
  IID__HspfSrcTar: TGUID = '{5CD33FFD-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfSrcTar: TGUID = '{5CD33FFE-1E30-11D5-983F-00A024C11E04}';
  IID__HspfMassLink: TGUID = '{5CD34031-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfMassLink: TGUID = '{5CD34032-1E30-11D5-983F-00A024C11E04}';
  IID__HspfMetSeg: TGUID = '{5CD3400D-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfMetSeg: TGUID = '{5CD3400E-1E30-11D5-983F-00A024C11E04}';
  IID__HspfMetSegRecord: TGUID = '{5CD3400A-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfMetSegRecord: TGUID = '{5CD3400B-1E30-11D5-983F-00A024C11E04}';
  IID__HspfPoint: TGUID = '{5CD3400F-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfPoint: TGUID = '{5CD34010-1E30-11D5-983F-00A024C11E04}';
  IID__HspfTSGroupDef: TGUID = '{5CD34052-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfTSGroupDef: TGUID = '{5CD34053-1E30-11D5-983F-00A024C11E04}';
  IID__HspfTSMemberDef: TGUID = '{5CD34054-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfTSMemberDef: TGUID = '{5CD34055-1E30-11D5-983F-00A024C11E04}';
  IID__HspfMonthData: TGUID = '{5CD34015-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfMonthData: TGUID = '{5CD34016-1E30-11D5-983F-00A024C11E04}';
  IID__HspfMonthDataTable: TGUID = '{5CD34058-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfMonthDataTable: TGUID = '{5CD34059-1E30-11D5-983F-00A024C11E04}';
  IID__HspfStatus: TGUID = '{5CD34001-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfStatus: TGUID = '{5CD34002-1E30-11D5-983F-00A024C11E04}';
  IID__HspfStatusType: TGUID = '{5CD3405D-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfStatusType: TGUID = '{5CD3405E-1E30-11D5-983F-00A024C11E04}';
  IID__HspfSpecialActionBlk: TGUID = '{5CD34017-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfSpecialActionBlk: TGUID = '{5CD34018-1E30-11D5-983F-00A024C11E04}';
  IID__HspfSpecialRecord: TGUID = '{5CD34062-1E30-11D5-983F-00A024C11E04}';
  CLASS_HspfSpecialRecord: TGUID = '{5CD34063-1E30-11D5-983F-00A024C11E04}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                  //
// *********************************************************************//
// HspfOperType constants
type
  HspfOperType = TOleEnum;
const
  hPerlnd = $00000001;
  hImplnd = $00000002;
  hRchres = $00000003;
  hCopy = $00000004;
  hPltgen = $00000005;
  hDisply = $00000006;
  hDuranl = $00000007;
  hGener = $00000008;
  hMutsin = $00000009;
  hBmprac = $0000000A;
  hReport = $0000000B;

// HspfSpecialRecordType constants
type
  HspfSpecialRecordType = TOleEnum;
const
  hAction = $00000001;
  hDistribute = $00000002;
  hUserDefineName = $00000003;
  hUserDefineQuan = $00000004;
  hCondition = $00000005;
  hComment = $00000006;

// MetSegRecordType constants
type
  MetSegRecordType = TOleEnum;
const
  msrUNK = $00000000;
  msrPREC = $00000001;
  msrGATMP = $00000002;
  msrDTMPG = $00000003;
  msrWINMOV = $00000004;
  msrSOLRAD = $00000005;
  msrCLOUD = $00000006;
  msrPETINP = $00000007;
  msrPOTEV = $00000008;

// HspfStatusReqOptUnnEnum constants
type
  HspfStatusReqOptUnnEnum = TOleEnum;
const
  HspfStatusRequired = $00000001;
  HspfStatusOptional = $00000002;
  HspfStatusUnneeded = $00000004;

// HspfStatusPresentMissingEnum constants
type
  HspfStatusPresentMissingEnum = TOleEnum;
const
  HspfStatusPresent = $FFFFFFFF;
  HspfStatusMissing = $00000000;
  HspfStatusAny = $00000002;

// HspfStatusTypes constants
type
  HspfStatusTypes = TOleEnum;
const
  HspfTable_ = $00000001;
  HspfInputTimeseries = $00000002;
  HspfOutputTimeseries = $00000003;

type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  _HspfUci = interface;
  _HspfUciDisp = dispinterface;
  _HspfData = interface;
  _HspfDataDisp = dispinterface;
  _HspfGlobalBlk = interface;
  _HspfGlobalBlkDisp = dispinterface;
  _HspfFilesBlk = interface;
  _HspfFilesBlkDisp = dispinterface;
  _HspfOpnSeqBlk = interface;
  _HspfOpnSeqBlkDisp = dispinterface;
  _HspfOperation = interface;
  _HspfOperationDisp = dispinterface;
  _HspfTableDef = interface;
  _HspfTableDefDisp = dispinterface;
  _HspfBlockDef = interface;
  _HspfBlockDefDisp = dispinterface;
  _HspfMsg = interface;
  _HspfMsgDisp = dispinterface;
  _HspfSectionDef = interface;
  _HspfSectionDefDisp = dispinterface;
  _HspfTable = interface;
  _HspfTableDisp = dispinterface;
  _HspfOpnBlk = interface;
  _HspfOpnBlkDisp = dispinterface;
  _HspfFtable = interface;
  _HspfFtableDisp = dispinterface;
  _HspfConnection = interface;
  _HspfConnectionDisp = dispinterface;
  _HspfSrcTar = interface;
  _HspfSrcTarDisp = dispinterface;
  _HspfMassLink = interface;
  _HspfMassLinkDisp = dispinterface;
  _HspfMetSeg = interface;
  _HspfMetSegDisp = dispinterface;
  _HspfMetSegRecord = interface;
  _HspfMetSegRecordDisp = dispinterface;
  _HspfPoint = interface;
  _HspfPointDisp = dispinterface;
  _HspfTSGroupDef = interface;
  _HspfTSGroupDefDisp = dispinterface;
  _HspfTSMemberDef = interface;
  _HspfTSMemberDefDisp = dispinterface;
  _HspfMonthData = interface;
  _HspfMonthDataDisp = dispinterface;
  _HspfMonthDataTable = interface;
  _HspfMonthDataTableDisp = dispinterface;
  _HspfStatus = interface;
  _HspfStatusDisp = dispinterface;
  _HspfStatusType = interface;
  _HspfStatusTypeDisp = dispinterface;
  _HspfSpecialActionBlk = interface;
  _HspfSpecialActionBlkDisp = dispinterface;
  _HspfSpecialRecord = interface;
  _HspfSpecialRecordDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  HspfUci = _HspfUci;
  HspfData = _HspfData;
  HspfGlobalBlk = _HspfGlobalBlk;
  HspfFilesBlk = _HspfFilesBlk;
  HspfOpnSeqBlk = _HspfOpnSeqBlk;
  HspfOperation = _HspfOperation;
  HspfTableDef = _HspfTableDef;
  HspfBlockDef = _HspfBlockDef;
  HspfMsg = _HspfMsg;
  HspfSectionDef = _HspfSectionDef;
  HspfTable = _HspfTable;
  HspfOpnBlk = _HspfOpnBlk;
  HspfFtable = _HspfFtable;
  HspfConnection = _HspfConnection;
  HspfSrcTar = _HspfSrcTar;
  HspfMassLink = _HspfMassLink;
  HspfMetSeg = _HspfMetSeg;
  HspfMetSegRecord = _HspfMetSegRecord;
  HspfPoint = _HspfPoint;
  HspfTSGroupDef = _HspfTSGroupDef;
  HspfTSMemberDef = _HspfTSMemberDef;
  HspfMonthData = _HspfMonthData;
  HspfMonthDataTable = _HspfMonthDataTable;
  HspfStatus = _HspfStatus;
  HspfStatusType = _HspfStatusType;
  HspfSpecialActionBlk = _HspfSpecialActionBlk;
  HspfSpecialRecord = _HspfSpecialRecord;


// *********************************************************************//
// Declaration of structures, unions and aliases.                       //
// *********************************************************************//
  HspfFile = packed record
    typ: WideString;
    Unit_: Integer;
    Name: WideString;
    Comment: WideString;
  end;


// *********************************************************************//
// Interface: _HspfUci
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34019-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfUci = interface(IDispatch)
    ['{5CD34019-1E30-11D5-983F-00A024C11E04}']
    procedure Set_Monitor(const Param1: IDispatch); safecall;
    procedure Set_HelpFile(var Param1: WideString); safecall;
    function Get_Edited: WordBool; safecall;
    procedure Set_Edited(var Param1: WordBool); safecall;
    procedure Set_Initialized(var Param1: WordBool); safecall;
    function Get_Msg: _HspfMsg; safecall;
    procedure Set_Msg(var Param1: _HspfMsg); safecall;
    procedure Set_StatusIn(var Param1: Integer); safecall;
    procedure Set_StatusOut(var Param1: Integer); safecall;
    function Get_icon: IPictureDisp; safecall;
    procedure Set_icon(var Param1: IPictureDisp); safecall;
    function Get_ErrorDescription: WideString; safecall;
    procedure Set_ErrorDescription(var Param1: WideString); safecall;
    function Get_GlobalBlock: _HspfGlobalBlk; safecall;
    procedure Set_GlobalBlock(var Param1: _HspfGlobalBlk); safecall;
    function Get_FilesBlock: _HspfFilesBlk; safecall;
    procedure Set_FilesBlock(var Param1: _HspfFilesBlk); safecall;
    function Get_MonthData: _HspfMonthData; safecall;
    function Get_OpnSeqBlock: _HspfOpnSeqBlk; safecall;
    procedure Set_OpnSeqBlock(var Param1: _HspfOpnSeqBlk); safecall;
    function Get_Connections: _Collection; safecall;
    procedure Set_Connections(var Param1: _Collection); safecall;
    function Get_MetSegs: _Collection; safecall;
    function Get_PointSources: _Collection; safecall;
    function Get_MassLinks: _Collection; safecall;
    procedure Set_MassLinks(var Param1: _Collection); safecall;
    function Get_OpnBlks: _Collection; safecall;
    procedure Set_OpnBlks(var Param1: _Collection); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_SpecialActionBlk: _HspfSpecialActionBlk; safecall;
    procedure Save; safecall;
    procedure SaveAs(var oldname: WideString; var newName: WideString; var basedsn: Integer; 
                     var relabs: Integer); safecall;
    procedure SetMessageUnit; safecall;
    procedure CreateUci(var M: _HspfMsg; var newName: WideString; var outputwdm: WideString; 
                        var metwdms: PSafeArray; var wdmids: PSafeArray; 
                        var MetDataDetails: WideString; var oneseg: WordBool; 
                        var PollutantList: _Collection); safecall;
    procedure ReadUci(var M: _HspfMsg; var newName: WideString; var fullfg: Integer; 
                      var FilesOK: WordBool); safecall;
    function Get_MaxAreaByLand2Stream: Double; safecall;
    procedure CalcMaxAreaByLand2Stream; safecall;
    procedure Source2MetSeg; safecall;
    procedure Source2Point; safecall;
    procedure Point2Source; safecall;
    procedure MetSeg2Source; safecall;
    procedure RunUci(var retcod: Integer); safecall;
    procedure DeleteOperation(var delname: WideString; var delid: Integer); safecall;
    procedure OpenWDM(var OpenOrCreate: Integer; var fname: WideString; var fun: Integer; 
                      var wid: WideString); safecall;
    procedure InitWDMArray(var msgwdmname: WideString); safecall;
    procedure GetMetSegNames(var fun: Integer; var numMetSeg: Integer; 
                             var arrayMetSegs: PSafeArray; var lMetDetails: PSafeArray; 
                             var lMetDescs: PSafeArray); safecall;
    procedure AddExpertDsns(var Id: Integer; var clocn: WideString; var basedsn: Integer; 
                            var adsn: PSafeArray; var ostr: PSafeArray); safecall;
    procedure AddExpertExtTargets(var reachid: Integer; var copyid: Integer; 
                                  var ContribArea: Single; var adsn: PSafeArray; 
                                  var ostr: PSafeArray); safecall;
    procedure AddExpertSchematic(var reachid: Integer; var copyid: Integer); safecall;
    procedure AddExtTarget(var sname: WideString; var sid: Integer; var sgroup: WideString; 
                           var Smember: WideString; var Smem1: Integer; var Smem2: Integer; 
                           var MFact: Single; var Tran: WideString; var tname: WideString; 
                           var Tid: Integer; var tmember: WideString; var Tsub1: Integer; 
                           var System_: WideString; var gap: WideString; var amd: WideString); safecall;
    procedure AddOutputWDMDataSet(var clocn: WideString; var ccons: WideString; 
                                  var basedsn: Integer; var wdmid: Integer; var adsn: Integer); safecall;
    procedure DeleteWDMDataSet(var wdmid: WideString; var adsn: Integer); safecall;
    procedure AddWDMFile(var Name: WideString; var FileOk: WordBool); safecall;
    procedure SetWDMFiles; safecall;
    function GetWDMAttr(var wdmid: WideString; var idsn: Integer; var attr: WideString): WideString; safecall;
    function GetDataSetFromDsn(var lWdmInd: Integer; var lDsn: Integer): _ATCclsTserData; safecall;
    function GetWDMObj(var Index: Integer): _ATCclsTserFile; safecall;
    procedure FindTimSer(var sen: WideString; var loc: WideString; var Con: WideString; 
                         var lts: _Collection); safecall;
    procedure EditActivityAll; safecall;
    function UpstreamArea(var RCHId: Integer): Single; safecall;
    procedure AddOperation(var opname: WideString; var opid: Integer); safecall;
    procedure AddTable(var opname: WideString; var opid: Integer; var tabname: WideString); safecall;
    procedure RemoveTable(var opname: WideString; var opid: Integer; var tabname: WideString); safecall;
    function AddWDMDataSet(var wdmid: Integer; var dsn: Integer; var scen: WideString; 
                           var locn: WideString; var cons: WideString; var Tu: Integer; 
                           var ts: Integer): WordBool; safecall;
    procedure AddPointSourceDataSet(var sen: WideString; var loc: WideString; var Con: WideString; 
                                    var stanam: WideString; var tstype: WideString; 
                                    var ndates: Integer; var jdates: PSafeArray; 
                                    var Load: PSafeArray; var newwdmid: WideString; 
                                    var newdsn: Integer); safecall;
    procedure AddPoint(var wdmid: WideString; var wdmdsn: Integer; var tarid: Integer; 
                       var srcname: WideString; var targroup: WideString; 
                       var tarmember: WideString; var Sub1: Integer; var Sub2: Integer); safecall;
    procedure RemovePoint(var wdmid: WideString; var wdmdsn: Integer; var tarid: Integer); safecall;
    procedure GetWDMUnits(var nwdm: Integer; var aunits: PSafeArray); safecall;
    property Monitor: IDispatch write Set_Monitor;
    property HelpFile: WideString write Set_HelpFile;
    property Edited: WordBool read Get_Edited write Set_Edited;
    property Initialized: WordBool write Set_Initialized;
    property Msg: _HspfMsg read Get_Msg write Set_Msg;
    property StatusIn: Integer write Set_StatusIn;
    property StatusOut: Integer write Set_StatusOut;
    property icon: IPictureDisp read Get_icon write Set_icon;
    property ErrorDescription: WideString read Get_ErrorDescription write Set_ErrorDescription;
    property GlobalBlock: _HspfGlobalBlk read Get_GlobalBlock write Set_GlobalBlock;
    property FilesBlock: _HspfFilesBlk read Get_FilesBlock write Set_FilesBlock;
    property MonthData: _HspfMonthData read Get_MonthData;
    property OpnSeqBlock: _HspfOpnSeqBlk read Get_OpnSeqBlock write Set_OpnSeqBlock;
    property Connections: _Collection read Get_Connections write Set_Connections;
    property MetSegs: _Collection read Get_MetSegs;
    property PointSources: _Collection read Get_PointSources;
    property MassLinks: _Collection read Get_MassLinks write Set_MassLinks;
    property OpnBlks: _Collection read Get_OpnBlks write Set_OpnBlks;
    property Name: WideString read Get_Name write Set_Name;
    property SpecialActionBlk: _HspfSpecialActionBlk read Get_SpecialActionBlk;
    property MaxAreaByLand2Stream: Double read Get_MaxAreaByLand2Stream;
  end;

// *********************************************************************//
// DispIntf:  _HspfUciDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34019-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfUciDisp = dispinterface
    ['{5CD34019-1E30-11D5-983F-00A024C11E04}']
    property Monitor: IDispatch writeonly dispid 1745027092;
    property HelpFile: WideString writeonly dispid 1745027091;
    property Edited: WordBool dispid 1745027090;
    property Initialized: WordBool writeonly dispid 1745027089;
    property Msg: _HspfMsg dispid 1745027088;
    property StatusIn: Integer writeonly dispid 1745027087;
    property StatusOut: Integer writeonly dispid 1745027086;
    property icon: IPictureDisp dispid 1745027085;
    property ErrorDescription: WideString dispid 1745027084;
    property GlobalBlock: _HspfGlobalBlk dispid 1745027083;
    property FilesBlock: _HspfFilesBlk dispid 1745027082;
    property MonthData: _HspfMonthData readonly dispid 1745027081;
    property OpnSeqBlock: _HspfOpnSeqBlk dispid 1745027080;
    property Connections: _Collection dispid 1745027079;
    property MetSegs: _Collection readonly dispid 1745027078;
    property PointSources: _Collection readonly dispid 1745027077;
    property MassLinks: _Collection dispid 1745027076;
    property OpnBlks: _Collection dispid 1745027075;
    property Name: WideString dispid 1745027074;
    property SpecialActionBlk: _HspfSpecialActionBlk readonly dispid 1745027073;
    procedure Save; dispid 1610809365;
    procedure SaveAs(var oldname: WideString; var newName: WideString; var basedsn: Integer; 
                     var relabs: Integer); dispid 1610809366;
    procedure SetMessageUnit; dispid 1610809368;
    procedure CreateUci(var M: _HspfMsg; var newName: WideString; var outputwdm: WideString; 
                        var metwdms: {??PSafeArray} OleVariant; 
                        var wdmids: {??PSafeArray} OleVariant; var MetDataDetails: WideString; 
                        var oneseg: WordBool; var PollutantList: _Collection); dispid 1610809369;
    procedure ReadUci(var M: _HspfMsg; var newName: WideString; var fullfg: Integer; 
                      var FilesOK: WordBool); dispid 1610809370;
    property MaxAreaByLand2Stream: Double readonly dispid 1745027072;
    procedure CalcMaxAreaByLand2Stream; dispid 1610809371;
    procedure Source2MetSeg; dispid 1610809372;
    procedure Source2Point; dispid 1610809373;
    procedure Point2Source; dispid 1610809374;
    procedure MetSeg2Source; dispid 1610809375;
    procedure RunUci(var retcod: Integer); dispid 1610809376;
    procedure DeleteOperation(var delname: WideString; var delid: Integer); dispid 1610809377;
    procedure OpenWDM(var OpenOrCreate: Integer; var fname: WideString; var fun: Integer; 
                      var wid: WideString); dispid 1610809378;
    procedure InitWDMArray(var msgwdmname: WideString); dispid 1610809379;
    procedure GetMetSegNames(var fun: Integer; var numMetSeg: Integer; 
                             var arrayMetSegs: {??PSafeArray} OleVariant; 
                             var lMetDetails: {??PSafeArray} OleVariant; 
                             var lMetDescs: {??PSafeArray} OleVariant); dispid 1610809380;
    procedure AddExpertDsns(var Id: Integer; var clocn: WideString; var basedsn: Integer; 
                            var adsn: {??PSafeArray} OleVariant; var ostr: {??PSafeArray} OleVariant); dispid 1610809381;
    procedure AddExpertExtTargets(var reachid: Integer; var copyid: Integer; 
                                  var ContribArea: Single; var adsn: {??PSafeArray} OleVariant; 
                                  var ostr: {??PSafeArray} OleVariant); dispid 1610809382;
    procedure AddExpertSchematic(var reachid: Integer; var copyid: Integer); dispid 1610809383;
    procedure AddExtTarget(var sname: WideString; var sid: Integer; var sgroup: WideString; 
                           var Smember: WideString; var Smem1: Integer; var Smem2: Integer; 
                           var MFact: Single; var Tran: WideString; var tname: WideString; 
                           var Tid: Integer; var tmember: WideString; var Tsub1: Integer; 
                           var System_: WideString; var gap: WideString; var amd: WideString); dispid 1610809384;
    procedure AddOutputWDMDataSet(var clocn: WideString; var ccons: WideString; 
                                  var basedsn: Integer; var wdmid: Integer; var adsn: Integer); dispid 1610809385;
    procedure DeleteWDMDataSet(var wdmid: WideString; var adsn: Integer); dispid 1610809386;
    procedure AddWDMFile(var Name: WideString; var FileOk: WordBool); dispid 1610809387;
    procedure SetWDMFiles; dispid 1610809389;
    function GetWDMAttr(var wdmid: WideString; var idsn: Integer; var attr: WideString): WideString; dispid 1610809390;
    function GetDataSetFromDsn(var lWdmInd: Integer; var lDsn: Integer): _ATCclsTserData; dispid 1610809391;
    function GetWDMObj(var Index: Integer): _ATCclsTserFile; dispid 1610809392;
    procedure FindTimSer(var sen: WideString; var loc: WideString; var Con: WideString; 
                         var lts: _Collection); dispid 1610809393;
    procedure EditActivityAll; dispid 1610809394;
    function UpstreamArea(var RCHId: Integer): Single; dispid 1610809395;
    procedure AddOperation(var opname: WideString; var opid: Integer); dispid 1610809399;
    procedure AddTable(var opname: WideString; var opid: Integer; var tabname: WideString); dispid 1610809400;
    procedure RemoveTable(var opname: WideString; var opid: Integer; var tabname: WideString); dispid 1610809401;
    function AddWDMDataSet(var wdmid: Integer; var dsn: Integer; var scen: WideString; 
                           var locn: WideString; var cons: WideString; var Tu: Integer; 
                           var ts: Integer): WordBool; dispid 1610809403;
    procedure AddPointSourceDataSet(var sen: WideString; var loc: WideString; var Con: WideString; 
                                    var stanam: WideString; var tstype: WideString; 
                                    var ndates: Integer; var jdates: {??PSafeArray} OleVariant; 
                                    var Load: {??PSafeArray} OleVariant; var newwdmid: WideString; 
                                    var newdsn: Integer); dispid 1610809404;
    procedure AddPoint(var wdmid: WideString; var wdmdsn: Integer; var tarid: Integer; 
                       var srcname: WideString; var targroup: WideString; 
                       var tarmember: WideString; var Sub1: Integer; var Sub2: Integer); dispid 1610809405;
    procedure RemovePoint(var wdmid: WideString; var wdmdsn: Integer; var tarid: Integer); dispid 1610809406;
    procedure GetWDMUnits(var nwdm: Integer; var aunits: {??PSafeArray} OleVariant); dispid 1610809407;
  end;

// *********************************************************************//
// Interface: _HspfData
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FF6-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfData = interface(IDispatch)
    ['{5CD33FF6-1E30-11D5-983F-00A024C11E04}']
  end;

// *********************************************************************//
// DispIntf:  _HspfDataDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FF6-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfDataDisp = dispinterface
    ['{5CD33FF6-1E30-11D5-983F-00A024C11E04}']
  end;

// *********************************************************************//
// Interface: _HspfGlobalBlk
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FF4-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfGlobalBlk = interface(IDispatch)
    ['{5CD33FF4-1E30-11D5-983F-00A024C11E04}']
    function Get_Edited: WordBool; safecall;
    procedure Set_Edited(var Param1: WordBool); safecall;
    function Get_Uci: _HspfUci; safecall;
    procedure Set_Uci(var Param1: _HspfUci); safecall;
    function Get_Caption: WideString; safecall;
    function Get_EditControlName: WideString; safecall;
    function Get_RunInf: _ATCclsParm; safecall;
    procedure Set_RunInf(var Param1: _ATCclsParm); safecall;
    function Get_SDate(var Index: Integer): Integer; safecall;
    procedure Set_SDate(var Index: Integer; var Param2: Integer); safecall;
    function Get_EDate(var Index: Integer): Integer; safecall;
    procedure Set_EDate(var Index: Integer; var Param2: Integer); safecall;
    function Get_outlev: _ATCclsParm; safecall;
    procedure Set_outlev(var Param1: _ATCclsParm); safecall;
    function Get_spout: Integer; safecall;
    procedure Set_spout(var Param1: Integer); safecall;
    function Get_runfg: Integer; safecall;
    procedure Set_runfg(var Param1: Integer); safecall;
    function Get_emfg: Integer; safecall;
    procedure Set_emfg(var Param1: Integer); safecall;
    procedure Edit; safecall;
    procedure ReadUciFile; safecall;
    procedure WriteUciFile(var f: Smallint); safecall;
    function Check: WideString; safecall;
    property Edited: WordBool read Get_Edited write Set_Edited;
    property Uci: _HspfUci read Get_Uci write Set_Uci;
    property Caption: WideString read Get_Caption;
    property EditControlName: WideString read Get_EditControlName;
    property RunInf: _ATCclsParm read Get_RunInf write Set_RunInf;
    property SDate[var Index: Integer]: Integer read Get_SDate write Set_SDate;
    property EDate[var Index: Integer]: Integer read Get_EDate write Set_EDate;
    property outlev: _ATCclsParm read Get_outlev write Set_outlev;
    property spout: Integer read Get_spout write Set_spout;
    property runfg: Integer read Get_runfg write Set_runfg;
    property emfg: Integer read Get_emfg write Set_emfg;
  end;

// *********************************************************************//
// DispIntf:  _HspfGlobalBlkDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FF4-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfGlobalBlkDisp = dispinterface
    ['{5CD33FF4-1E30-11D5-983F-00A024C11E04}']
    property Edited: WordBool dispid 1745027082;
    property Uci: _HspfUci dispid 1745027081;
    property Caption: WideString readonly dispid 1745027080;
    property EditControlName: WideString readonly dispid 1745027079;
    property RunInf: _ATCclsParm dispid 1745027078;
    property SDate[var Index: Integer]: Integer dispid 1745027077;
    property EDate[var Index: Integer]: Integer dispid 1745027076;
    property outlev: _ATCclsParm dispid 1745027075;
    property spout: Integer dispid 1745027074;
    property runfg: Integer dispid 1745027073;
    property emfg: Integer dispid 1745027072;
    procedure Edit; dispid 1610809355;
    procedure ReadUciFile; dispid 1610809356;
    procedure WriteUciFile(var f: Smallint); dispid 1610809357;
    function Check: WideString; dispid 1610809359;
  end;

// *********************************************************************//
// Interface: _HspfFilesBlk
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FFB-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfFilesBlk = interface(IDispatch)
    ['{5CD33FFB-1E30-11D5-983F-00A024C11E04}']
    function Get_Caption: WideString; safecall;
    function Get_EditControlName: WideString; safecall;
    procedure Clear; safecall;
    function Get_Count: Integer; safecall;
    procedure Add(var newValue: HspfFile); safecall;
    procedure Remove(var Index: Integer); safecall;
    function Get_Value(var Index: Integer): HspfFile; safecall;
    procedure Set_Value(var Index: Integer; var Param2: HspfFile); safecall;
    procedure Edit; safecall;
    function Check: WideString; safecall;
    procedure newName(var oldn: WideString; var newn: WideString); safecall;
    property Caption: WideString read Get_Caption;
    property EditControlName: WideString read Get_EditControlName;
    property Count: Integer read Get_Count;
    property Value[var Index: Integer]: HspfFile read Get_Value write Set_Value;
  end;

// *********************************************************************//
// DispIntf:  _HspfFilesBlkDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FFB-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfFilesBlkDisp = dispinterface
    ['{5CD33FFB-1E30-11D5-983F-00A024C11E04}']
    property Caption: WideString readonly dispid 1745027075;
    property EditControlName: WideString readonly dispid 1745027074;
    procedure Clear; dispid 1610809349;
    property Count: Integer readonly dispid 1745027073;
    procedure Add(var newValue: {??HspfFile} OleVariant); dispid 1610809350;
    procedure Remove(var Index: Integer); dispid 1610809351;
    property Value[var Index: Integer]: {??HspfFile} OleVariant dispid 1745027072;
    procedure Edit; dispid 1610809352;
    function Check: WideString; dispid 1610809355;
    procedure newName(var oldn: WideString; var newn: WideString); dispid 1610809358;
  end;

// *********************************************************************//
// Interface: _HspfOpnSeqBlk
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34013-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfOpnSeqBlk = interface(IDispatch)
    ['{5CD34013-1E30-11D5-983F-00A024C11E04}']
    function Get_Uci: _HspfUci; safecall;
    procedure Set_Uci(var Param1: _HspfUci); safecall;
    function Get_Caption: WideString; safecall;
    function Get_EditControlName: WideString; safecall;
    function Get_Opns: OleVariant; safecall;
    function Get_Opn(var Index: Integer): _HspfOperation; safecall;
    function Get_Delt: Integer; safecall;
    procedure Set_Delt(var Param1: Integer); safecall;
    procedure Add(var newOpn: _HspfOperation); safecall;
    procedure Delete(var Index: Integer); safecall;
    procedure AddAfter(var newOpn: _HspfOperation; var afterid: Integer); safecall;
    procedure AddBefore(var newOpn: _HspfOperation; var beforeid: Integer); safecall;
    procedure Edit; safecall;
    procedure ReadUciFile; safecall;
    procedure WriteUciFile(var f: Smallint); safecall;
    property Uci: _HspfUci read Get_Uci write Set_Uci;
    property Caption: WideString read Get_Caption;
    property EditControlName: WideString read Get_EditControlName;
    property Opns: OleVariant read Get_Opns;
    property Opn[var Index: Integer]: _HspfOperation read Get_Opn;
    property Delt: Integer read Get_Delt write Set_Delt;
  end;

// *********************************************************************//
// DispIntf:  _HspfOpnSeqBlkDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34013-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfOpnSeqBlkDisp = dispinterface
    ['{5CD34013-1E30-11D5-983F-00A024C11E04}']
    property Uci: _HspfUci dispid 1745027077;
    property Caption: WideString readonly dispid 1745027076;
    property EditControlName: WideString readonly dispid 1745027075;
    property Opns: OleVariant readonly dispid 1745027074;
    property Opn[var Index: Integer]: _HspfOperation readonly dispid 1745027073;
    property Delt: Integer dispid 1745027072;
    procedure Add(var newOpn: _HspfOperation); dispid 1610809350;
    procedure Delete(var Index: Integer); dispid 1610809351;
    procedure AddAfter(var newOpn: _HspfOperation; var afterid: Integer); dispid 1610809352;
    procedure AddBefore(var newOpn: _HspfOperation; var beforeid: Integer); dispid 1610809353;
    procedure Edit; dispid 1610809354;
    procedure ReadUciFile; dispid 1610809356;
    procedure WriteUciFile(var f: Smallint); dispid 1610809357;
  end;

// *********************************************************************//
// Interface: _HspfOperation
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34011-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfOperation = interface(IDispatch)
    ['{5CD34011-1E30-11D5-983F-00A024C11E04}']
    function Get_EditControlName: WideString; safecall;
    procedure Edit; safecall;
    function Get_Caption: WideString; safecall;
    function Get_Comment: WideString; safecall;
    procedure Set_Comment(var Param1: WideString); safecall;
    function Get_Edited: WordBool; safecall;
    procedure Set_Edited(var Param1: WordBool); safecall;
    function Get_optyp: HspfOperType; safecall;
    procedure Set_optyp(var Param1: HspfOperType); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_Id: Integer; safecall;
    procedure Set_Id(var Param1: Integer); safecall;
    function Get_Serial: Integer; safecall;
    function Get_Description: WideString; safecall;
    procedure Set_Description(var Param1: WideString); safecall;
    function Get_OpnBlk: _HspfOpnBlk; safecall;
    procedure Set_OpnBlk(var Param1: _HspfOpnBlk); safecall;
    function Get_FTable: _HspfFtable; safecall;
    procedure Set_FTable(var Param1: _HspfFtable); safecall;
    function Get_MetSeg: _HspfMetSeg; safecall;
    procedure Set_MetSeg(var Param1: _HspfMetSeg); safecall;
    function Get_TableStatus: _HspfStatus; safecall;
    function Get_InputTimeseriesStatus: _HspfStatus; safecall;
    function Get_OutputTimeseriesStatus: _HspfStatus; safecall;
    function Get_PointSources: _Collection; safecall;
    procedure Set_PointSources(var Param1: _HspfPoint); safecall;
    function Get_Tables: _Collection; safecall;
    function TableExists(var Name: WideString): WordBool; safecall;
    function Get_Sources: _Collection; safecall;
    function Get_Targets: _Collection; safecall;
    procedure Set_Uci(var Param1: _HspfUci); safecall;
    function Get_Uci: OleVariant; safecall;
    procedure setTimSerConnections; safecall;
    procedure setTimSerConnectionsSources; safecall;
    procedure setTimSerConnectionsTargets; safecall;
    function DownOper(var OpType: WideString): Integer; safecall;
    procedure setPicture(var O: IDispatch; var ColorMap: _Collection; var CurrentLegend: Integer; 
                         var LegendOrder: _Collection); safecall;
    property EditControlName: WideString read Get_EditControlName;
    property Caption: WideString read Get_Caption;
    property Comment: WideString read Get_Comment write Set_Comment;
    property Edited: WordBool read Get_Edited write Set_Edited;
    property optyp: HspfOperType read Get_optyp write Set_optyp;
    property Name: WideString read Get_Name write Set_Name;
    property Id: Integer read Get_Id write Set_Id;
    property Serial: Integer read Get_Serial;
    property Description: WideString read Get_Description write Set_Description;
    property OpnBlk: _HspfOpnBlk read Get_OpnBlk write Set_OpnBlk;
    property FTable: _HspfFtable read Get_FTable write Set_FTable;
    property MetSeg: _HspfMetSeg read Get_MetSeg write Set_MetSeg;
    property TableStatus: _HspfStatus read Get_TableStatus;
    property InputTimeseriesStatus: _HspfStatus read Get_InputTimeseriesStatus;
    property OutputTimeseriesStatus: _HspfStatus read Get_OutputTimeseriesStatus;
    property Tables: _Collection read Get_Tables;
    property Sources: _Collection read Get_Sources;
    property Targets: _Collection read Get_Targets;
  end;

// *********************************************************************//
// DispIntf:  _HspfOperationDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34011-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfOperationDisp = dispinterface
    ['{5CD34011-1E30-11D5-983F-00A024C11E04}']
    property EditControlName: WideString readonly dispid 1745027091;
    procedure Edit; dispid 1610809364;
    property Caption: WideString readonly dispid 1745027090;
    property Comment: WideString dispid 1745027089;
    property Edited: WordBool dispid 1745027088;
    property optyp: HspfOperType dispid 1745027087;
    property Name: WideString dispid 1745027086;
    property Id: Integer dispid 1745027085;
    property Serial: Integer readonly dispid 1745027084;
    property Description: WideString dispid 1745027083;
    property OpnBlk: _HspfOpnBlk dispid 1745027082;
    property FTable: _HspfFtable dispid 1745027081;
    property MetSeg: _HspfMetSeg dispid 1745027080;
    property TableStatus: _HspfStatus readonly dispid 1745027079;
    property InputTimeseriesStatus: _HspfStatus readonly dispid 1745027078;
    property OutputTimeseriesStatus: _HspfStatus readonly dispid 1745027077;
    function PointSources: _Collection; dispid 1745027076;
    property Tables: _Collection readonly dispid 1745027075;
    function TableExists(var Name: WideString): WordBool; dispid 1610809365;
    property Sources: _Collection readonly dispid 1745027074;
    property Targets: _Collection readonly dispid 1745027073;
    function Uci: _HspfUci; dispid 1745027072;
    procedure setTimSerConnections; dispid 1610809366;
    procedure setTimSerConnectionsSources; dispid 1610809367;
    procedure setTimSerConnectionsTargets; dispid 1610809368;
    function DownOper(var OpType: WideString): Integer; dispid 1610809369;
    procedure setPicture(var O: IDispatch; var ColorMap: _Collection; var CurrentLegend: Integer; 
                         var LegendOrder: _Collection); dispid 1610809370;
  end;

// *********************************************************************//
// Interface: _HspfTableDef
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FF0-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfTableDef = interface(IDispatch)
    ['{5CD33FF0-1E30-11D5-983F-00A024C11E04}']
    function Get_Define: WideString; safecall;
    procedure Set_Define(var Param1: WideString); safecall;
    function Get_HeaderM: WideString; safecall;
    procedure Set_HeaderM(var Param1: WideString); safecall;
    function Get_HeaderE: WideString; safecall;
    procedure Set_HeaderE(var Param1: WideString); safecall;
    function Get_Id: Integer; safecall;
    procedure Set_Id(var Param1: Integer); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_NumOccur: Integer; safecall;
    procedure Set_NumOccur(var Param1: Integer); safecall;
    function Get_Parent: _HspfSectionDef; safecall;
    procedure Set_Parent(var Param1: _HspfSectionDef); safecall;
    function Get_ParmDefs: _Collection; safecall;
    procedure Set_ParmDefs(var Param1: _Collection); safecall;
    function Get_SGRP: Integer; safecall;
    procedure Set_SGRP(var Param1: Integer); safecall;
    property Define: WideString read Get_Define write Set_Define;
    property HeaderM: WideString read Get_HeaderM write Set_HeaderM;
    property HeaderE: WideString read Get_HeaderE write Set_HeaderE;
    property Id: Integer read Get_Id write Set_Id;
    property Name: WideString read Get_Name write Set_Name;
    property NumOccur: Integer read Get_NumOccur write Set_NumOccur;
    property Parent: _HspfSectionDef read Get_Parent write Set_Parent;
    property ParmDefs: _Collection read Get_ParmDefs write Set_ParmDefs;
    property SGRP: Integer read Get_SGRP write Set_SGRP;
  end;

// *********************************************************************//
// DispIntf:  _HspfTableDefDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FF0-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfTableDefDisp = dispinterface
    ['{5CD33FF0-1E30-11D5-983F-00A024C11E04}']
    property Define: WideString dispid 1745027080;
    property HeaderM: WideString dispid 1745027079;
    property HeaderE: WideString dispid 1745027078;
    property Id: Integer dispid 1745027077;
    property Name: WideString dispid 1745027076;
    property NumOccur: Integer dispid 1745027075;
    property Parent: _HspfSectionDef dispid 1745027074;
    property ParmDefs: _Collection dispid 1745027073;
    property SGRP: Integer dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _HspfBlockDef
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FEC-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfBlockDef = interface(IDispatch)
    ['{5CD33FEC-1E30-11D5-983F-00A024C11E04}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_Id: Integer; safecall;
    procedure Set_Id(var Param1: Integer); safecall;
    function Get_SectionDefs: _Collection; safecall;
    procedure Set_SectionDefs(var Param1: _Collection); safecall;
    function Get_TableDefs: _Collection; safecall;
    procedure Set_TableDefs(var Param1: _Collection); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Id: Integer read Get_Id write Set_Id;
    property SectionDefs: _Collection read Get_SectionDefs write Set_SectionDefs;
    property TableDefs: _Collection read Get_TableDefs write Set_TableDefs;
  end;

// *********************************************************************//
// DispIntf:  _HspfBlockDefDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FEC-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfBlockDefDisp = dispinterface
    ['{5CD33FEC-1E30-11D5-983F-00A024C11E04}']
    property Name: WideString dispid 1745027075;
    property Id: Integer dispid 1745027074;
    property SectionDefs: _Collection dispid 1745027073;
    property TableDefs: _Collection dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _HspfMsg
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FF2-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfMsg = interface(IDispatch)
    ['{5CD33FF2-1E30-11D5-983F-00A024C11E04}']
    procedure Set_Monitor(const Param1: IDispatch); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_BlockDefs: _Collection; safecall;
    function Get_TSGroupDefs: _Collection; safecall;
    function Get_ErrorDescription: WideString; safecall;
    property Monitor: IDispatch write Set_Monitor;
    property Name: WideString read Get_Name write Set_Name;
    property BlockDefs: _Collection read Get_BlockDefs;
    property TSGroupDefs: _Collection read Get_TSGroupDefs;
    property ErrorDescription: WideString read Get_ErrorDescription;
  end;

// *********************************************************************//
// DispIntf:  _HspfMsgDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FF2-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfMsgDisp = dispinterface
    ['{5CD33FF2-1E30-11D5-983F-00A024C11E04}']
    property Monitor: IDispatch writeonly dispid 1745027076;
    property Name: WideString dispid 1745027075;
    property BlockDefs: _Collection readonly dispid 1745027074;
    property TSGroupDefs: _Collection readonly dispid 1745027073;
    property ErrorDescription: WideString readonly dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _HspfSectionDef
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FEE-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfSectionDef = interface(IDispatch)
    ['{5CD33FEE-1E30-11D5-983F-00A024C11E04}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_Id: Integer; safecall;
    procedure Set_Id(var Param1: Integer); safecall;
    function Get_TableDefs: _Collection; safecall;
    procedure Set_TableDefs(var Param1: _Collection); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Id: Integer read Get_Id write Set_Id;
    property TableDefs: _Collection read Get_TableDefs write Set_TableDefs;
  end;

// *********************************************************************//
// DispIntf:  _HspfSectionDefDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FEE-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfSectionDefDisp = dispinterface
    ['{5CD33FEE-1E30-11D5-983F-00A024C11E04}']
    property Name: WideString dispid 1745027074;
    property Id: Integer dispid 1745027073;
    property TableDefs: _Collection dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _HspfTable
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34029-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfTable = interface(IDispatch)
    ['{5CD34029-1E30-11D5-983F-00A024C11E04}']
    procedure Set_OccurCount(var Param1: Integer); safecall;
    function Get_OccurCount: Integer; safecall;
    procedure Set_OccurNum(var Param1: Integer); safecall;
    function Get_OccurNum: Integer; safecall;
    function Get_Def: _HspfTableDef; safecall;
    procedure Set_Def(var Param1: _HspfTableDef); safecall;
    function Get_Comment: WideString; safecall;
    procedure Set_Comment(var Param1: WideString); safecall;
    function Get_Name: WideString; safecall;
    function Get_Parms: _Collection; safecall;
    function Get_Opn: _HspfOperation; safecall;
    procedure Set_Opn(var Param1: _HspfOperation); safecall;
    function Get_Edited: WordBool; safecall;
    procedure Set_Edited(var Param1: WordBool); safecall;
    function Get_EditControlName: WideString; safecall;
    function Get_EditAllSimilar: WordBool; safecall;
    function EditAllSimilarChange(var newEditAllSimilar: WordBool): OleVariant; safecall;
    function Get_Caption: OleVariant; safecall;
    procedure initTable(var s: WideString); safecall;
    procedure Edit; safecall;
    procedure WriteUciFile(var f: Smallint); safecall;
    property OccurCount: Integer read Get_OccurCount write Set_OccurCount;
    property OccurNum: Integer read Get_OccurNum write Set_OccurNum;
    property Def: _HspfTableDef read Get_Def write Set_Def;
    property Comment: WideString read Get_Comment write Set_Comment;
    property Name: WideString read Get_Name;
    property Parms: _Collection read Get_Parms;
    property Opn: _HspfOperation read Get_Opn write Set_Opn;
    property Edited: WordBool read Get_Edited write Set_Edited;
    property EditControlName: WideString read Get_EditControlName;
    property EditAllSimilar: WordBool read Get_EditAllSimilar;
    property Caption: OleVariant read Get_Caption;
  end;

// *********************************************************************//
// DispIntf:  _HspfTableDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34029-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfTableDisp = dispinterface
    ['{5CD34029-1E30-11D5-983F-00A024C11E04}']
    property OccurCount: Integer dispid 1745027082;
    property OccurNum: Integer dispid 1745027081;
    property Def: _HspfTableDef dispid 1745027080;
    property Comment: WideString dispid 1745027079;
    property Name: WideString readonly dispid 1745027078;
    property Parms: _Collection readonly dispid 1745027077;
    property Opn: _HspfOperation dispid 1745027076;
    property Edited: WordBool dispid 1745027075;
    property EditControlName: WideString readonly dispid 1745027074;
    property EditAllSimilar: WordBool readonly dispid 1745027073;
    function EditAllSimilarChange(var newEditAllSimilar: WordBool): OleVariant; dispid 1610809355;
    property Caption: OleVariant readonly dispid 1745027072;
    procedure initTable(var s: WideString); dispid 1610809356;
    procedure Edit; dispid 1610809357;
    procedure WriteUciFile(var f: Smallint); dispid 1610809358;
  end;

// *********************************************************************//
// Interface: _HspfOpnBlk
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34006-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfOpnBlk = interface(IDispatch)
    ['{5CD34006-1E30-11D5-983F-00A024C11E04}']
    function Get_Edited: WordBool; safecall;
    procedure Set_Edited(var Param1: WordBool); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_Ids: _Collection; safecall;
    function OperFromID(var Id: Integer): _HspfOperation; safecall;
    function NthOper(var nth: Integer): _HspfOperation; safecall;
    function Count: Integer; safecall;
    function Get_Uci: _HspfUci; safecall;
    procedure Set_Uci(var Param1: _HspfUci); safecall;
    function Get_Tables: _Collection; safecall;
    function TableExists(var Name: WideString): WordBool; safecall;
    procedure setTableValues(var blk: _HspfBlockDef); safecall;
    procedure createTables(var blk: _HspfBlockDef); safecall;
    procedure AddTable(var opid: Integer; var tabname: WideString; var blk: _HspfBlockDef); safecall;
    procedure AddTableForAll(var tabname: WideString; var opname: WideString); safecall;
    procedure RemoveTable(var opid: Integer; var tabname: WideString); safecall;
    procedure WriteUciFile(var f: Smallint; var M: _HspfMsg); safecall;
    function OperByDesc(var Desc: WideString): _HspfOperation; safecall;
    property Edited: WordBool read Get_Edited write Set_Edited;
    property Name: WideString read Get_Name write Set_Name;
    property Ids: _Collection read Get_Ids;
    property Uci: _HspfUci read Get_Uci write Set_Uci;
    property Tables: _Collection read Get_Tables;
  end;

// *********************************************************************//
// DispIntf:  _HspfOpnBlkDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34006-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfOpnBlkDisp = dispinterface
    ['{5CD34006-1E30-11D5-983F-00A024C11E04}']
    property Edited: WordBool dispid 1745027076;
    property Name: WideString dispid 1745027075;
    property Ids: _Collection readonly dispid 1745027074;
    function OperFromID(var Id: Integer): _HspfOperation; dispid 1610809349;
    function NthOper(var nth: Integer): _HspfOperation; dispid 1610809350;
    function Count: Integer; dispid 1610809351;
    property Uci: _HspfUci dispid 1745027073;
    property Tables: _Collection readonly dispid 1745027072;
    function TableExists(var Name: WideString): WordBool; dispid 1610809353;
    procedure setTableValues(var blk: _HspfBlockDef); dispid 1610809354;
    procedure createTables(var blk: _HspfBlockDef); dispid 1610809357;
    procedure AddTable(var opid: Integer; var tabname: WideString; var blk: _HspfBlockDef); dispid 1610809358;
    procedure AddTableForAll(var tabname: WideString; var opname: WideString); dispid 1610809359;
    procedure RemoveTable(var opid: Integer; var tabname: WideString); dispid 1610809360;
    procedure WriteUciFile(var f: Smallint; var M: _HspfMsg); dispid 1610809361;
    function OperByDesc(var Desc: WideString): _HspfOperation; dispid 1610809362;
  end;

// *********************************************************************//
// Interface: _HspfFtable
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34008-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfFtable = interface(IDispatch)
    ['{5CD34008-1E30-11D5-983F-00A024C11E04}']
    function Get_Depth(var row: Integer): Double; safecall;
    procedure Set_Depth(var row: Integer; var Param2: Double); safecall;
    function Get_Area(var row: Integer): Double; safecall;
    procedure Set_Area(var row: Integer; var Param2: Double); safecall;
    function Get_Volume(var row: Integer): Double; safecall;
    procedure Set_Volume(var row: Integer; var Param2: Double); safecall;
    function Get_Outflow1(var row: Integer): Double; safecall;
    procedure Set_Outflow1(var row: Integer; var Param2: Double); safecall;
    function Get_Outflow2(var row: Integer): Double; safecall;
    procedure Set_Outflow2(var row: Integer; var Param2: Double); safecall;
    function Get_Outflow3(var row: Integer): Double; safecall;
    procedure Set_Outflow3(var row: Integer; var Param2: Double); safecall;
    function Get_Outflow4(var row: Integer): Double; safecall;
    procedure Set_Outflow4(var row: Integer; var Param2: Double); safecall;
    function Get_Outflow5(var row: Integer): Double; safecall;
    procedure Set_Outflow5(var row: Integer; var Param2: Double); safecall;
    procedure Edited; safecall;
    function Get_Id: Integer; safecall;
    procedure Set_Id(var Param1: Integer); safecall;
    function Get_Nrows: Integer; safecall;
    procedure Set_Nrows(var Param1: Integer); safecall;
    function Get_Ncols: Integer; safecall;
    procedure Set_Ncols(var Param1: Integer); safecall;
    function Get_Operation: _HspfOperation; safecall;
    procedure Set_Operation(var Param1: _HspfOperation); safecall;
    procedure ReadUciFile; safecall;
    procedure WriteUciFile(var f: Integer); safecall;
    procedure Edit; safecall;
    function Get_EditControlName: WideString; safecall;
    function Get_Caption: WideString; safecall;
    procedure FTableFromCrossSect(var dL: Single; var dYm: Single; var dWm: Single; var dN: Single; 
                                  var dS: Single; var dM11: Single; var dM12: Single; 
                                  var dYc: Single; var dM21: Single; var dM22: Single; 
                                  var dYt1: Single; var dYt2: Single; var dM31: Single; 
                                  var dM32: Single; var dW11: Single; var dW12: Single); safecall;
    property Depth[var row: Integer]: Double read Get_Depth write Set_Depth;
    property Area[var row: Integer]: Double read Get_Area write Set_Area;
    property Volume[var row: Integer]: Double read Get_Volume write Set_Volume;
    property Outflow1[var row: Integer]: Double read Get_Outflow1 write Set_Outflow1;
    property Outflow2[var row: Integer]: Double read Get_Outflow2 write Set_Outflow2;
    property Outflow3[var row: Integer]: Double read Get_Outflow3 write Set_Outflow3;
    property Outflow4[var row: Integer]: Double read Get_Outflow4 write Set_Outflow4;
    property Outflow5[var row: Integer]: Double read Get_Outflow5 write Set_Outflow5;
    property Id: Integer read Get_Id write Set_Id;
    property Nrows: Integer read Get_Nrows write Set_Nrows;
    property Ncols: Integer read Get_Ncols write Set_Ncols;
    property Operation: _HspfOperation read Get_Operation write Set_Operation;
    property EditControlName: WideString read Get_EditControlName;
    property Caption: WideString read Get_Caption;
  end;

// *********************************************************************//
// DispIntf:  _HspfFtableDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34008-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfFtableDisp = dispinterface
    ['{5CD34008-1E30-11D5-983F-00A024C11E04}']
    property Depth[var row: Integer]: Double dispid 1745027085;
    property Area[var row: Integer]: Double dispid 1745027084;
    property Volume[var row: Integer]: Double dispid 1745027083;
    property Outflow1[var row: Integer]: Double dispid 1745027082;
    property Outflow2[var row: Integer]: Double dispid 1745027081;
    property Outflow3[var row: Integer]: Double dispid 1745027080;
    property Outflow4[var row: Integer]: Double dispid 1745027079;
    property Outflow5[var row: Integer]: Double dispid 1745027078;
    procedure Edited; dispid 1610809358;
    property Id: Integer dispid 1745027077;
    property Nrows: Integer dispid 1745027076;
    property Ncols: Integer dispid 1745027075;
    property Operation: _HspfOperation dispid 1745027074;
    procedure ReadUciFile; dispid 1610809360;
    procedure WriteUciFile(var f: Integer); dispid 1610809361;
    procedure Edit; dispid 1610809362;
    property EditControlName: WideString readonly dispid 1745027073;
    property Caption: WideString readonly dispid 1745027072;
    procedure FTableFromCrossSect(var dL: Single; var dYm: Single; var dWm: Single; var dN: Single; 
                                  var dS: Single; var dM11: Single; var dM12: Single; 
                                  var dYc: Single; var dM21: Single; var dM22: Single; 
                                  var dYt1: Single; var dYt2: Single; var dM31: Single; 
                                  var dM32: Single; var dW11: Single; var dW12: Single); dispid 1610809364;
  end;

// *********************************************************************//
// Interface: _HspfConnection
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FFF-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfConnection = interface(IDispatch)
    ['{5CD33FFF-1E30-11D5-983F-00A024C11E04}']
    function Get_MFact: Double; safecall;
    procedure Set_MFact(var Param1: Double); safecall;
    function Get_Uci: _HspfUci; safecall;
    procedure Set_Uci(var Param1: _HspfUci); safecall;
    function Get_Source: _HspfSrcTar; safecall;
    procedure Set_Source(var Param1: _HspfSrcTar); safecall;
    function Get_Target: _HspfSrcTar; safecall;
    procedure Set_Target(var Param1: _HspfSrcTar); safecall;
    function Get_Tran: WideString; safecall;
    procedure Set_Tran(var Param1: WideString); safecall;
    function Get_Comment: WideString; safecall;
    procedure Set_Comment(var Param1: WideString); safecall;
    function Get_Ssystem: WideString; safecall;
    procedure Set_Ssystem(var Param1: WideString); safecall;
    function Get_Sgapstrg: WideString; safecall;
    procedure Set_Sgapstrg(var Param1: WideString); safecall;
    function Get_Amdstrg: WideString; safecall;
    procedure Set_Amdstrg(var Param1: WideString); safecall;
    function Get_typ: Integer; safecall;
    procedure Set_typ(var Param1: Integer); safecall;
    function Get_MassLink: Integer; safecall;
    procedure Set_MassLink(var Param1: Integer); safecall;
    procedure readTimSer(var myUci: _HspfUci); safecall;
    function Get_EditControlName: WideString; safecall;
    procedure EditExtSrc; safecall;
    procedure EditExtTar; safecall;
    procedure EditNetwork; safecall;
    procedure EditSchematic; safecall;
    function Get_DesiredRecordType: WideString; safecall;
    function Get_Caption: WideString; safecall;
    procedure WriteUciFile(var f: Smallint; var M: _HspfMsg); safecall;
    property MFact: Double read Get_MFact write Set_MFact;
    property Uci: _HspfUci read Get_Uci write Set_Uci;
    property Source: _HspfSrcTar read Get_Source write Set_Source;
    property Target: _HspfSrcTar read Get_Target write Set_Target;
    property Tran: WideString read Get_Tran write Set_Tran;
    property Comment: WideString read Get_Comment write Set_Comment;
    property Ssystem: WideString read Get_Ssystem write Set_Ssystem;
    property Sgapstrg: WideString read Get_Sgapstrg write Set_Sgapstrg;
    property Amdstrg: WideString read Get_Amdstrg write Set_Amdstrg;
    property typ: Integer read Get_typ write Set_typ;
    property MassLink: Integer read Get_MassLink write Set_MassLink;
    property EditControlName: WideString read Get_EditControlName;
    property DesiredRecordType: WideString read Get_DesiredRecordType;
    property Caption: WideString read Get_Caption;
  end;

// *********************************************************************//
// DispIntf:  _HspfConnectionDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FFF-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfConnectionDisp = dispinterface
    ['{5CD33FFF-1E30-11D5-983F-00A024C11E04}']
    property MFact: Double dispid 1745027085;
    property Uci: _HspfUci dispid 1745027084;
    property Source: _HspfSrcTar dispid 1745027083;
    property Target: _HspfSrcTar dispid 1745027082;
    property Tran: WideString dispid 1745027081;
    property Comment: WideString dispid 1745027080;
    property Ssystem: WideString dispid 1745027079;
    property Sgapstrg: WideString dispid 1745027078;
    property Amdstrg: WideString dispid 1745027077;
    property typ: Integer dispid 1745027076;
    property MassLink: Integer dispid 1745027075;
    procedure readTimSer(var myUci: _HspfUci); dispid 1610809358;
    property EditControlName: WideString readonly dispid 1745027074;
    procedure EditExtSrc; dispid 1610809360;
    procedure EditExtTar; dispid 1610809361;
    procedure EditNetwork; dispid 1610809362;
    procedure EditSchematic; dispid 1610809363;
    property DesiredRecordType: WideString readonly dispid 1745027073;
    property Caption: WideString readonly dispid 1745027072;
    procedure WriteUciFile(var f: Smallint; var M: _HspfMsg); dispid 1610809364;
  end;

// *********************************************************************//
// Interface: _HspfSrcTar
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FFD-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfSrcTar = interface(IDispatch)
    ['{5CD33FFD-1E30-11D5-983F-00A024C11E04}']
    function Get_Group: WideString; safecall;
    procedure Set_Group(var Param1: WideString); safecall;
    function Get_Member: WideString; safecall;
    procedure Set_Member(var Param1: WideString); safecall;
    function Get_MemSub1: Integer; safecall;
    procedure Set_MemSub1(var Param1: Integer); safecall;
    function Get_MemSub2: Integer; safecall;
    procedure Set_MemSub2(var Param1: Integer); safecall;
    function Get_VolName: WideString; safecall;
    procedure Set_VolName(var Param1: WideString); safecall;
    function Get_VolId: Integer; safecall;
    procedure Set_VolId(var Param1: Integer); safecall;
    function Get_Opn: _HspfOperation; safecall;
    procedure Set_Opn(var Param1: _HspfOperation); safecall;
    function Get_VolIdL: Integer; safecall;
    procedure Set_VolIdL(var Param1: Integer); safecall;
    property Group: WideString read Get_Group write Set_Group;
    property Member: WideString read Get_Member write Set_Member;
    property MemSub1: Integer read Get_MemSub1 write Set_MemSub1;
    property MemSub2: Integer read Get_MemSub2 write Set_MemSub2;
    property VolName: WideString read Get_VolName write Set_VolName;
    property VolId: Integer read Get_VolId write Set_VolId;
    property Opn: _HspfOperation read Get_Opn write Set_Opn;
    property VolIdL: Integer read Get_VolIdL write Set_VolIdL;
  end;

// *********************************************************************//
// DispIntf:  _HspfSrcTarDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD33FFD-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfSrcTarDisp = dispinterface
    ['{5CD33FFD-1E30-11D5-983F-00A024C11E04}']
    property Group: WideString dispid 1745027079;
    property Member: WideString dispid 1745027078;
    property MemSub1: Integer dispid 1745027077;
    property MemSub2: Integer dispid 1745027076;
    property VolName: WideString dispid 1745027075;
    property VolId: Integer dispid 1745027074;
    property Opn: _HspfOperation dispid 1745027073;
    property VolIdL: Integer dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _HspfMassLink
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34031-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfMassLink = interface(IDispatch)
    ['{5CD34031-1E30-11D5-983F-00A024C11E04}']
    function Get_MFact: Double; safecall;
    procedure Set_MFact(var Param1: Double); safecall;
    function Get_Tran: WideString; safecall;
    procedure Set_Tran(var Param1: WideString); safecall;
    function Get_Comment: WideString; safecall;
    procedure Set_Comment(var Param1: WideString); safecall;
    function Get_Uci: _HspfUci; safecall;
    procedure Set_Uci(var Param1: _HspfUci); safecall;
    function Get_Source: _HspfSrcTar; safecall;
    procedure Set_Source(var Param1: _HspfSrcTar); safecall;
    function Get_Target: _HspfSrcTar; safecall;
    procedure Set_Target(var Param1: _HspfSrcTar); safecall;
    function Get_MassLinkID: Integer; safecall;
    procedure Set_MassLinkID(var Param1: Integer); safecall;
    procedure readMassLinks(var myUci: _HspfUci); safecall;
    function Get_EditControlName: WideString; safecall;
    procedure Edit; safecall;
    function Get_Caption: WideString; safecall;
    procedure writeMassLinks(var f: Smallint; var M: _HspfMsg); safecall;
    function FindMassLinkID(var sname: WideString; var tname: WideString): OleVariant; safecall;
    property MFact: Double read Get_MFact write Set_MFact;
    property Tran: WideString read Get_Tran write Set_Tran;
    property Comment: WideString read Get_Comment write Set_Comment;
    property Uci: _HspfUci read Get_Uci write Set_Uci;
    property Source: _HspfSrcTar read Get_Source write Set_Source;
    property Target: _HspfSrcTar read Get_Target write Set_Target;
    property MassLinkID: Integer read Get_MassLinkID write Set_MassLinkID;
    property EditControlName: WideString read Get_EditControlName;
    property Caption: WideString read Get_Caption;
  end;

// *********************************************************************//
// DispIntf:  _HspfMassLinkDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34031-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfMassLinkDisp = dispinterface
    ['{5CD34031-1E30-11D5-983F-00A024C11E04}']
    property MFact: Double dispid 1745027080;
    property Tran: WideString dispid 1745027079;
    property Comment: WideString dispid 1745027078;
    property Uci: _HspfUci dispid 1745027077;
    property Source: _HspfSrcTar dispid 1745027076;
    property Target: _HspfSrcTar dispid 1745027075;
    property MassLinkID: Integer dispid 1745027074;
    procedure readMassLinks(var myUci: _HspfUci); dispid 1610809353;
    property EditControlName: WideString readonly dispid 1745027073;
    procedure Edit; dispid 1610809355;
    property Caption: WideString readonly dispid 1745027072;
    procedure writeMassLinks(var f: Smallint; var M: _HspfMsg); dispid 1610809356;
    function FindMassLinkID(var sname: WideString; var tname: WideString): OleVariant; dispid 1610809357;
  end;

// *********************************************************************//
// Interface: _HspfMetSeg
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD3400D-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfMetSeg = interface(IDispatch)
    ['{5CD3400D-1E30-11D5-983F-00A024C11E04}']
    function Get_MetSegRecs: PSafeArray; safecall;
    function Get_MetSegRec(var msr: MetSegRecordType): _HspfMetSegRecord; safecall;
    procedure Set_MetSegRecs(var Param1: PSafeArray); safecall;
    function Get_Id: Integer; safecall;
    procedure Set_Id(var Param1: Integer); safecall;
    function Get_AirType: Integer; safecall;
    procedure Set_AirType(var Param1: Integer); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Add(var newConn: _HspfConnection): WordBool; safecall;
    function Compare(var newMetSeg: _HspfMetSeg; var opname: WideString): WordBool; safecall;
    procedure UpdateMetSeg(var newMetSeg: _HspfMetSeg); safecall;
    procedure ExpandMetSegName(var wdmid: WideString; var idsn: Integer); safecall;
    procedure Set_Uci(var Param1: _HspfUci); safecall;
    function Get_Uci: OleVariant; safecall;
    procedure WriteUciFile(var optyp: WideString; var icol: PSafeArray; var ilen: PSafeArray; 
                           var f: OleVariant); safecall;
    procedure WriteRecs(var optyp: WideString; var firstid: Integer; var lastid: Integer; 
                        var icol: PSafeArray; var ilen: PSafeArray; var f: OleVariant); safecall;
    property MetSegRecs: PSafeArray read Get_MetSegRecs write Set_MetSegRecs;
    property MetSegRec[var msr: MetSegRecordType]: _HspfMetSegRecord read Get_MetSegRec;
    property Id: Integer read Get_Id write Set_Id;
    property AirType: Integer read Get_AirType write Set_AirType;
    property Name: WideString read Get_Name write Set_Name;
  end;

// *********************************************************************//
// DispIntf:  _HspfMetSegDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD3400D-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfMetSegDisp = dispinterface
    ['{5CD3400D-1E30-11D5-983F-00A024C11E04}']
    property MetSegRecs: {??PSafeArray} OleVariant dispid 1745027077;
    property MetSegRec[var msr: MetSegRecordType]: _HspfMetSegRecord readonly dispid 1745027076;
    property Id: Integer dispid 1745027075;
    property AirType: Integer dispid 1745027074;
    property Name: WideString dispid 1745027073;
    function Add(var newConn: _HspfConnection): WordBool; dispid 1610809350;
    function Compare(var newMetSeg: _HspfMetSeg; var opname: WideString): WordBool; dispid 1610809352;
    procedure UpdateMetSeg(var newMetSeg: _HspfMetSeg); dispid 1610809353;
    procedure ExpandMetSegName(var wdmid: WideString; var idsn: Integer); dispid 1610809355;
    function Uci: _HspfUci; dispid 1745027072;
    procedure WriteUciFile(var optyp: WideString; var icol: {??PSafeArray} OleVariant; 
                           var ilen: {??PSafeArray} OleVariant; var f: OleVariant); dispid 1610809356;
    procedure WriteRecs(var optyp: WideString; var firstid: Integer; var lastid: Integer; 
                        var icol: {??PSafeArray} OleVariant; var ilen: {??PSafeArray} OleVariant; 
                        var f: OleVariant); dispid 1610809357;
  end;

// *********************************************************************//
// Interface: _HspfMetSegRecord
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD3400A-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfMetSegRecord = interface(IDispatch)
    ['{5CD3400A-1E30-11D5-983F-00A024C11E04}']
    function Get_MFactP: Double; safecall;
    procedure Set_MFactP(var Param1: Double); safecall;
    function Get_MFactR: Double; safecall;
    procedure Set_MFactR(var Param1: Double); safecall;
    function Get_Ssystem: WideString; safecall;
    procedure Set_Ssystem(var Param1: WideString); safecall;
    function Get_Sgapstrg: WideString; safecall;
    procedure Set_Sgapstrg(var Param1: WideString); safecall;
    function Get_Source: _HspfSrcTar; safecall;
    procedure Set_Source(var Param1: _HspfSrcTar); safecall;
    function Get_Tran: WideString; safecall;
    procedure Set_Tran(var Param1: WideString); safecall;
    function Get_typ: Integer; safecall;
    procedure Set_typ(var Param1: Integer); safecall;
    function Compare(var tMetSegRecord: _HspfMetSegRecord; var opname: WideString): WordBool; safecall;
    property MFactP: Double read Get_MFactP write Set_MFactP;
    property MFactR: Double read Get_MFactR write Set_MFactR;
    property Ssystem: WideString read Get_Ssystem write Set_Ssystem;
    property Sgapstrg: WideString read Get_Sgapstrg write Set_Sgapstrg;
    property Source: _HspfSrcTar read Get_Source write Set_Source;
    property Tran: WideString read Get_Tran write Set_Tran;
    property typ: Integer read Get_typ write Set_typ;
  end;

// *********************************************************************//
// DispIntf:  _HspfMetSegRecordDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD3400A-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfMetSegRecordDisp = dispinterface
    ['{5CD3400A-1E30-11D5-983F-00A024C11E04}']
    property MFactP: Double dispid 1745027078;
    property MFactR: Double dispid 1745027077;
    property Ssystem: WideString dispid 1745027076;
    property Sgapstrg: WideString dispid 1745027075;
    property Source: _HspfSrcTar dispid 1745027074;
    property Tran: WideString dispid 1745027073;
    property typ: Integer dispid 1745027072;
    function Compare(var tMetSegRecord: _HspfMetSegRecord; var opname: WideString): WordBool; dispid 1610809351;
  end;

// *********************************************************************//
// Interface: _HspfPoint
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD3400F-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfPoint = interface(IDispatch)
    ['{5CD3400F-1E30-11D5-983F-00A024C11E04}']
    function Get_Id: Integer; safecall;
    procedure Set_Id(var Param1: Integer); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_Con: WideString; safecall;
    procedure Set_Con(var Param1: WideString); safecall;
    function Get_MFact: Double; safecall;
    procedure Set_MFact(var Param1: Double); safecall;
    function Get_Ssystem: WideString; safecall;
    procedure Set_Ssystem(var Param1: WideString); safecall;
    function Get_Sgapstrg: WideString; safecall;
    procedure Set_Sgapstrg(var Param1: WideString); safecall;
    function Get_Source: _HspfSrcTar; safecall;
    procedure Set_Source(var Param1: _HspfSrcTar); safecall;
    function Get_Target: _HspfSrcTar; safecall;
    procedure Set_Target(var Param1: _HspfSrcTar); safecall;
    function Get_Tran: WideString; safecall;
    procedure Set_Tran(var Param1: WideString); safecall;
    procedure WriteUciFile(var icol: PSafeArray; var ilen: PSafeArray; var f: OleVariant); safecall;
    property Id: Integer read Get_Id write Set_Id;
    property Name: WideString read Get_Name write Set_Name;
    property Con: WideString read Get_Con write Set_Con;
    property MFact: Double read Get_MFact write Set_MFact;
    property Ssystem: WideString read Get_Ssystem write Set_Ssystem;
    property Sgapstrg: WideString read Get_Sgapstrg write Set_Sgapstrg;
    property Source: _HspfSrcTar read Get_Source write Set_Source;
    property Target: _HspfSrcTar read Get_Target write Set_Target;
    property Tran: WideString read Get_Tran write Set_Tran;
  end;

// *********************************************************************//
// DispIntf:  _HspfPointDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD3400F-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfPointDisp = dispinterface
    ['{5CD3400F-1E30-11D5-983F-00A024C11E04}']
    property Id: Integer dispid 1745027080;
    property Name: WideString dispid 1745027079;
    property Con: WideString dispid 1745027078;
    property MFact: Double dispid 1745027077;
    property Ssystem: WideString dispid 1745027076;
    property Sgapstrg: WideString dispid 1745027075;
    property Source: _HspfSrcTar dispid 1745027074;
    property Target: _HspfSrcTar dispid 1745027073;
    property Tran: WideString dispid 1745027072;
    procedure WriteUciFile(var icol: {??PSafeArray} OleVariant; 
                           var ilen: {??PSafeArray} OleVariant; var f: OleVariant); dispid 1610809354;
  end;

// *********************************************************************//
// Interface: _HspfTSGroupDef
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34052-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfTSGroupDef = interface(IDispatch)
    ['{5CD34052-1E30-11D5-983F-00A024C11E04}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_Id: Integer; safecall;
    procedure Set_Id(var Param1: Integer); safecall;
    function Get_BlockId: Integer; safecall;
    procedure Set_BlockId(var Param1: Integer); safecall;
    function Get_MemberDefs: _Collection; safecall;
    procedure Set_MemberDefs(var Param1: _Collection); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Id: Integer read Get_Id write Set_Id;
    property BlockId: Integer read Get_BlockId write Set_BlockId;
    property MemberDefs: _Collection read Get_MemberDefs write Set_MemberDefs;
  end;

// *********************************************************************//
// DispIntf:  _HspfTSGroupDefDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34052-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfTSGroupDefDisp = dispinterface
    ['{5CD34052-1E30-11D5-983F-00A024C11E04}']
    property Name: WideString dispid 1745027075;
    property Id: Integer dispid 1745027074;
    property BlockId: Integer dispid 1745027073;
    property MemberDefs: _Collection dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _HspfTSMemberDef
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34054-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfTSMemberDef = interface(IDispatch)
    ['{5CD34054-1E30-11D5-983F-00A024C11E04}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_Id: Integer; safecall;
    procedure Set_Id(var Param1: Integer); safecall;
    function Get_TSGroupId: Integer; safecall;
    procedure Set_TSGroupId(var Param1: Integer); safecall;
    function Get_Parent: _HspfTSGroupDef; safecall;
    procedure Set_Parent(var Param1: _HspfTSGroupDef); safecall;
    function Get_SCLU: Integer; safecall;
    procedure Set_SCLU(var Param1: Integer); safecall;
    function Get_SGRP: Integer; safecall;
    procedure Set_SGRP(var Param1: Integer); safecall;
    function Get_mdim1: Integer; safecall;
    procedure Set_mdim1(var Param1: Integer); safecall;
    function Get_mdim2: Integer; safecall;
    procedure Set_mdim2(var Param1: Integer); safecall;
    function Get_maxsb1: Integer; safecall;
    procedure Set_maxsb1(var Param1: Integer); safecall;
    function Get_maxsb2: Integer; safecall;
    procedure Set_maxsb2(var Param1: Integer); safecall;
    function Get_mkind: Integer; safecall;
    procedure Set_mkind(var Param1: Integer); safecall;
    function Get_sptrn: Integer; safecall;
    procedure Set_sptrn(var Param1: Integer); safecall;
    function Get_msect: Integer; safecall;
    procedure Set_msect(var Param1: Integer); safecall;
    function Get_mio: Integer; safecall;
    procedure Set_mio(var Param1: Integer); safecall;
    function Get_osvbas: Integer; safecall;
    procedure Set_osvbas(var Param1: Integer); safecall;
    function Get_osvoff: Integer; safecall;
    procedure Set_osvoff(var Param1: Integer); safecall;
    function Get_eunits: WideString; safecall;
    procedure Set_eunits(var Param1: WideString); safecall;
    function Get_ltval1: Single; safecall;
    procedure Set_ltval1(var Param1: Single); safecall;
    function Get_ltval2: Single; safecall;
    procedure Set_ltval2(var Param1: Single); safecall;
    function Get_ltval3: Single; safecall;
    procedure Set_ltval3(var Param1: Single); safecall;
    function Get_ltval4: Single; safecall;
    procedure Set_ltval4(var Param1: Single); safecall;
    function Get_Defn: WideString; safecall;
    procedure Set_Defn(var Param1: WideString); safecall;
    function Get_munits: WideString; safecall;
    procedure Set_munits(var Param1: WideString); safecall;
    function Get_ltval5: Single; safecall;
    procedure Set_ltval5(var Param1: Single); safecall;
    function Get_ltval6: Single; safecall;
    procedure Set_ltval6(var Param1: Single); safecall;
    function Get_ltval7: Single; safecall;
    procedure Set_ltval7(var Param1: Single); safecall;
    function Get_ltval8: Single; safecall;
    procedure Set_ltval8(var Param1: Single); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Id: Integer read Get_Id write Set_Id;
    property TSGroupId: Integer read Get_TSGroupId write Set_TSGroupId;
    property Parent: _HspfTSGroupDef read Get_Parent write Set_Parent;
    property SCLU: Integer read Get_SCLU write Set_SCLU;
    property SGRP: Integer read Get_SGRP write Set_SGRP;
    property mdim1: Integer read Get_mdim1 write Set_mdim1;
    property mdim2: Integer read Get_mdim2 write Set_mdim2;
    property maxsb1: Integer read Get_maxsb1 write Set_maxsb1;
    property maxsb2: Integer read Get_maxsb2 write Set_maxsb2;
    property mkind: Integer read Get_mkind write Set_mkind;
    property sptrn: Integer read Get_sptrn write Set_sptrn;
    property msect: Integer read Get_msect write Set_msect;
    property mio: Integer read Get_mio write Set_mio;
    property osvbas: Integer read Get_osvbas write Set_osvbas;
    property osvoff: Integer read Get_osvoff write Set_osvoff;
    property eunits: WideString read Get_eunits write Set_eunits;
    property ltval1: Single read Get_ltval1 write Set_ltval1;
    property ltval2: Single read Get_ltval2 write Set_ltval2;
    property ltval3: Single read Get_ltval3 write Set_ltval3;
    property ltval4: Single read Get_ltval4 write Set_ltval4;
    property Defn: WideString read Get_Defn write Set_Defn;
    property munits: WideString read Get_munits write Set_munits;
    property ltval5: Single read Get_ltval5 write Set_ltval5;
    property ltval6: Single read Get_ltval6 write Set_ltval6;
    property ltval7: Single read Get_ltval7 write Set_ltval7;
    property ltval8: Single read Get_ltval8 write Set_ltval8;
  end;

// *********************************************************************//
// DispIntf:  _HspfTSMemberDefDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34054-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfTSMemberDefDisp = dispinterface
    ['{5CD34054-1E30-11D5-983F-00A024C11E04}']
    property Name: WideString dispid 1745027098;
    property Id: Integer dispid 1745027097;
    property TSGroupId: Integer dispid 1745027096;
    property Parent: _HspfTSGroupDef dispid 1745027095;
    property SCLU: Integer dispid 1745027094;
    property SGRP: Integer dispid 1745027093;
    property mdim1: Integer dispid 1745027092;
    property mdim2: Integer dispid 1745027091;
    property maxsb1: Integer dispid 1745027090;
    property maxsb2: Integer dispid 1745027089;
    property mkind: Integer dispid 1745027088;
    property sptrn: Integer dispid 1745027087;
    property msect: Integer dispid 1745027086;
    property mio: Integer dispid 1745027085;
    property osvbas: Integer dispid 1745027084;
    property osvoff: Integer dispid 1745027083;
    property eunits: WideString dispid 1745027082;
    property ltval1: Single dispid 1745027081;
    property ltval2: Single dispid 1745027080;
    property ltval3: Single dispid 1745027079;
    property ltval4: Single dispid 1745027078;
    property Defn: WideString dispid 1745027077;
    property munits: WideString dispid 1745027076;
    property ltval5: Single dispid 1745027075;
    property ltval6: Single dispid 1745027074;
    property ltval7: Single dispid 1745027073;
    property ltval8: Single dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _HspfMonthData
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34015-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfMonthData = interface(IDispatch)
    ['{5CD34015-1E30-11D5-983F-00A024C11E04}']
    function Get_Caption: WideString; safecall;
    function Get_Uci: _HspfUci; safecall;
    procedure Set_Uci(var Param1: _HspfUci); safecall;
    function Get_MonthDataTables: _Collection; safecall;
    procedure Edit; safecall;
    function Get_EditControlName: WideString; safecall;
    procedure ReadUciFile; safecall;
    procedure WriteUciFile(var f: Integer); safecall;
    property Caption: WideString read Get_Caption;
    property Uci: _HspfUci read Get_Uci write Set_Uci;
    property MonthDataTables: _Collection read Get_MonthDataTables;
    property EditControlName: WideString read Get_EditControlName;
  end;

// *********************************************************************//
// DispIntf:  _HspfMonthDataDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34015-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfMonthDataDisp = dispinterface
    ['{5CD34015-1E30-11D5-983F-00A024C11E04}']
    property Caption: WideString readonly dispid 1745027075;
    property Uci: _HspfUci dispid 1745027074;
    property MonthDataTables: _Collection readonly dispid 1745027073;
    procedure Edit; dispid 1610809348;
    property EditControlName: WideString readonly dispid 1745027072;
    procedure ReadUciFile; dispid 1610809350;
    procedure WriteUciFile(var f: Integer); dispid 1610809351;
  end;

// *********************************************************************//
// Interface: _HspfMonthDataTable
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34058-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfMonthDataTable = interface(IDispatch)
    ['{5CD34058-1E30-11D5-983F-00A024C11E04}']
    function Get_Id: Integer; safecall;
    procedure Set_Id(var Param1: Integer); safecall;
    function Get_Block: _HspfMonthData; safecall;
    procedure Set_Block(var Param1: _HspfMonthData); safecall;
    function Get_MonthValue(var Month: Integer): Single; safecall;
    procedure Set_MonthValue(var Month: Integer; var Param2: Single); safecall;
    function Get_ReferencedBy: _Collection; safecall;
    property Id: Integer read Get_Id write Set_Id;
    property Block: _HspfMonthData read Get_Block write Set_Block;
    property MonthValue[var Month: Integer]: Single read Get_MonthValue write Set_MonthValue;
    property ReferencedBy: _Collection read Get_ReferencedBy;
  end;

// *********************************************************************//
// DispIntf:  _HspfMonthDataTableDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34058-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfMonthDataTableDisp = dispinterface
    ['{5CD34058-1E30-11D5-983F-00A024C11E04}']
    property Id: Integer dispid 1745027075;
    property Block: _HspfMonthData dispid 1745027074;
    property MonthValue[var Month: Integer]: Single dispid 1745027073;
    property ReferencedBy: _Collection readonly dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _HspfStatus
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34001-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfStatus = interface(IDispatch)
    ['{5CD34001-1E30-11D5-983F-00A024C11E04}']
    function Get_StatusType: HspfStatusTypes; safecall;
    procedure Set_StatusType(var Param1: HspfStatusTypes); safecall;
    function Get_TotalPossible: OleVariant; safecall;
    procedure Change(var Name: WideString; var Occur: Integer; var Status: Integer); safecall;
    procedure Change2(var Name: WideString; var Occur1: Integer; var Occur2: Integer; 
                      var Status: Integer); safecall;
    procedure Update; safecall;
    procedure UpdateExtTargetsOutputs; safecall;
    function GetInfo(var filterRON: Integer; var filterPresent: Integer): _Collection; safecall;
    function GetOutputInfo(var filterRON: Integer; var filterPresent: Integer): _Collection; safecall;
    procedure init(var newOper: _HspfOperation); safecall;
    property StatusType: HspfStatusTypes read Get_StatusType write Set_StatusType;
    property TotalPossible: OleVariant read Get_TotalPossible;
  end;

// *********************************************************************//
// DispIntf:  _HspfStatusDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34001-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfStatusDisp = dispinterface
    ['{5CD34001-1E30-11D5-983F-00A024C11E04}']
    property StatusType: HspfStatusTypes dispid 1745027073;
    property TotalPossible: OleVariant readonly dispid 1745027072;
    procedure Change(var Name: WideString; var Occur: Integer; var Status: Integer); dispid 1610809346;
    procedure Change2(var Name: WideString; var Occur1: Integer; var Occur2: Integer; 
                      var Status: Integer); dispid 1610809347;
    procedure Update; dispid 1610809348;
    procedure UpdateExtTargetsOutputs; dispid 1610809349;
    function GetInfo(var filterRON: Integer; var filterPresent: Integer): _Collection; dispid 1610809352;
    function GetOutputInfo(var filterRON: Integer; var filterPresent: Integer): _Collection; dispid 1610809353;
    procedure init(var newOper: _HspfOperation); dispid 1610809354;
  end;

// *********************************************************************//
// Interface: _HspfStatusType
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD3405D-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfStatusType = interface(IDispatch)
    ['{5CD3405D-1E30-11D5-983F-00A024C11E04}']
    procedure Set_Name(var Param1: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Occur(var Param1: Integer); safecall;
    function Get_Occur: Integer; safecall;
    procedure Set_Max(var Param1: Integer); safecall;
    function Get_Max: Integer; safecall;
    procedure Set_ReqOptUnn(var Param1: Integer); safecall;
    function Get_ReqOptUnn: Integer; safecall;
    procedure Set_Present(var Param1: WordBool); safecall;
    function Get_Present: WordBool; safecall;
    procedure Set_Tag(var Param1: WideString); safecall;
    function Get_Tag: WideString; safecall;
    procedure Set_Defn(var Param1: IDispatch); safecall;
    function Get_Defn: IDispatch; safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Occur: Integer read Get_Occur write Set_Occur;
    property Max: Integer read Get_Max write Set_Max;
    property ReqOptUnn: Integer read Get_ReqOptUnn write Set_ReqOptUnn;
    property Present: WordBool read Get_Present write Set_Present;
    property Tag: WideString read Get_Tag write Set_Tag;
    property Defn: IDispatch read Get_Defn write Set_Defn;
  end;

// *********************************************************************//
// DispIntf:  _HspfStatusTypeDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD3405D-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfStatusTypeDisp = dispinterface
    ['{5CD3405D-1E30-11D5-983F-00A024C11E04}']
    property Name: WideString dispid 1745027078;
    property Occur: Integer dispid 1745027077;
    property Max: Integer dispid 1745027076;
    property ReqOptUnn: Integer dispid 1745027075;
    property Present: WordBool dispid 1745027074;
    property Tag: WideString dispid 1745027073;
    property Defn: IDispatch dispid 1745027072;
  end;

// *********************************************************************//
// Interface: _HspfSpecialActionBlk
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34017-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfSpecialActionBlk = interface(IDispatch)
    ['{5CD34017-1E30-11D5-983F-00A024C11E04}']
    function Get_Caption: WideString; safecall;
    function Get_EditControlName: WideString; safecall;
    function Get_Actions: _Collection; safecall;
    function Get_Distributes: _Collection; safecall;
    function Get_UserDefineNames: _Collection; safecall;
    function Get_UserDefineQuans: _Collection; safecall;
    function Get_Conditions: _Collection; safecall;
    function Get_Records: _Collection; safecall;
    procedure Edit; safecall;
    procedure ReadUciFile; safecall;
    procedure WriteUciFile(var f: Integer); safecall;
    property Caption: WideString read Get_Caption;
    property EditControlName: WideString read Get_EditControlName;
    property Actions: _Collection read Get_Actions;
    property Distributes: _Collection read Get_Distributes;
    property UserDefineNames: _Collection read Get_UserDefineNames;
    property UserDefineQuans: _Collection read Get_UserDefineQuans;
    property Conditions: _Collection read Get_Conditions;
    property Records: _Collection read Get_Records;
  end;

// *********************************************************************//
// DispIntf:  _HspfSpecialActionBlkDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34017-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfSpecialActionBlkDisp = dispinterface
    ['{5CD34017-1E30-11D5-983F-00A024C11E04}']
    property Caption: WideString readonly dispid 1745027079;
    property EditControlName: WideString readonly dispid 1745027078;
    property Actions: _Collection readonly dispid 1745027077;
    property Distributes: _Collection readonly dispid 1745027076;
    property UserDefineNames: _Collection readonly dispid 1745027075;
    property UserDefineQuans: _Collection readonly dispid 1745027074;
    property Conditions: _Collection readonly dispid 1745027073;
    property Records: _Collection readonly dispid 1745027072;
    procedure Edit; dispid 1610809353;
    procedure ReadUciFile; dispid 1610809354;
    procedure WriteUciFile(var f: Integer); dispid 1610809355;
  end;

// *********************************************************************//
// Interface: _HspfSpecialRecord
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34062-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfSpecialRecord = interface(IDispatch)
    ['{5CD34062-1E30-11D5-983F-00A024C11E04}']
    function Get_Text: WideString; safecall;
    procedure Set_Text(var Param1: WideString); safecall;
    function Get_SpecType: HspfSpecialRecordType; safecall;
    procedure Set_SpecType(var Param1: HspfSpecialRecordType); safecall;
    property Text: WideString read Get_Text write Set_Text;
    property SpecType: HspfSpecialRecordType read Get_SpecType write Set_SpecType;
  end;

// *********************************************************************//
// DispIntf:  _HspfSpecialRecordDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5CD34062-1E30-11D5-983F-00A024C11E04}
// *********************************************************************//
  _HspfSpecialRecordDisp = dispinterface
    ['{5CD34062-1E30-11D5-983F-00A024C11E04}']
    property Text: WideString dispid 1745027073;
    property SpecType: HspfSpecialRecordType dispid 1745027072;
  end;

  CoHspfUci = class
    class function Create: _HspfUci;
    class function CreateRemote(const MachineName: string): _HspfUci;
  end;

  CoHspfData = class
    class function Create: _HspfData;
    class function CreateRemote(const MachineName: string): _HspfData;
  end;

  CoHspfGlobalBlk = class
    class function Create: _HspfGlobalBlk;
    class function CreateRemote(const MachineName: string): _HspfGlobalBlk;
  end;

  CoHspfFilesBlk = class
    class function Create: _HspfFilesBlk;
    class function CreateRemote(const MachineName: string): _HspfFilesBlk;
  end;

  CoHspfOpnSeqBlk = class
    class function Create: _HspfOpnSeqBlk;
    class function CreateRemote(const MachineName: string): _HspfOpnSeqBlk;
  end;

  CoHspfOperation = class
    class function Create: _HspfOperation;
    class function CreateRemote(const MachineName: string): _HspfOperation;
  end;

  CoHspfTableDef = class
    class function Create: _HspfTableDef;
    class function CreateRemote(const MachineName: string): _HspfTableDef;
  end;

  CoHspfBlockDef = class
    class function Create: _HspfBlockDef;
    class function CreateRemote(const MachineName: string): _HspfBlockDef;
  end;

  CoHspfMsg = class
    class function Create: _HspfMsg;
    class function CreateRemote(const MachineName: string): _HspfMsg;
  end;

  CoHspfSectionDef = class
    class function Create: _HspfSectionDef;
    class function CreateRemote(const MachineName: string): _HspfSectionDef;
  end;

  CoHspfTable = class
    class function Create: _HspfTable;
    class function CreateRemote(const MachineName: string): _HspfTable;
  end;

  CoHspfOpnBlk = class
    class function Create: _HspfOpnBlk;
    class function CreateRemote(const MachineName: string): _HspfOpnBlk;
  end;

  CoHspfFtable = class
    class function Create: _HspfFtable;
    class function CreateRemote(const MachineName: string): _HspfFtable;
  end;

  CoHspfConnection = class
    class function Create: _HspfConnection;
    class function CreateRemote(const MachineName: string): _HspfConnection;
  end;

  CoHspfSrcTar = class
    class function Create: _HspfSrcTar;
    class function CreateRemote(const MachineName: string): _HspfSrcTar;
  end;

  CoHspfMassLink = class
    class function Create: _HspfMassLink;
    class function CreateRemote(const MachineName: string): _HspfMassLink;
  end;

  CoHspfMetSeg = class
    class function Create: _HspfMetSeg;
    class function CreateRemote(const MachineName: string): _HspfMetSeg;
  end;

  CoHspfMetSegRecord = class
    class function Create: _HspfMetSegRecord;
    class function CreateRemote(const MachineName: string): _HspfMetSegRecord;
  end;

  CoHspfPoint = class
    class function Create: _HspfPoint;
    class function CreateRemote(const MachineName: string): _HspfPoint;
  end;

  CoHspfTSGroupDef = class
    class function Create: _HspfTSGroupDef;
    class function CreateRemote(const MachineName: string): _HspfTSGroupDef;
  end;

  CoHspfTSMemberDef = class
    class function Create: _HspfTSMemberDef;
    class function CreateRemote(const MachineName: string): _HspfTSMemberDef;
  end;

  CoHspfMonthData = class
    class function Create: _HspfMonthData;
    class function CreateRemote(const MachineName: string): _HspfMonthData;
  end;

  CoHspfMonthDataTable = class
    class function Create: _HspfMonthDataTable;
    class function CreateRemote(const MachineName: string): _HspfMonthDataTable;
  end;

  CoHspfStatus = class
    class function Create: _HspfStatus;
    class function CreateRemote(const MachineName: string): _HspfStatus;
  end;

  CoHspfStatusType = class
    class function Create: _HspfStatusType;
    class function CreateRemote(const MachineName: string): _HspfStatusType;
  end;

  CoHspfSpecialActionBlk = class
    class function Create: _HspfSpecialActionBlk;
    class function CreateRemote(const MachineName: string): _HspfSpecialActionBlk;
  end;

  CoHspfSpecialRecord = class
    class function Create: _HspfSpecialRecord;
    class function CreateRemote(const MachineName: string): _HspfSpecialRecord;
  end;

implementation

uses ComObj;

class function CoHspfUci.Create: _HspfUci;
begin
  Result := CreateComObject(CLASS_HspfUci) as _HspfUci;
end;

class function CoHspfUci.CreateRemote(const MachineName: string): _HspfUci;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfUci) as _HspfUci;
end;

class function CoHspfData.Create: _HspfData;
begin
  Result := CreateComObject(CLASS_HspfData) as _HspfData;
end;

class function CoHspfData.CreateRemote(const MachineName: string): _HspfData;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfData) as _HspfData;
end;

class function CoHspfGlobalBlk.Create: _HspfGlobalBlk;
begin
  Result := CreateComObject(CLASS_HspfGlobalBlk) as _HspfGlobalBlk;
end;

class function CoHspfGlobalBlk.CreateRemote(const MachineName: string): _HspfGlobalBlk;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfGlobalBlk) as _HspfGlobalBlk;
end;

class function CoHspfFilesBlk.Create: _HspfFilesBlk;
begin
  Result := CreateComObject(CLASS_HspfFilesBlk) as _HspfFilesBlk;
end;

class function CoHspfFilesBlk.CreateRemote(const MachineName: string): _HspfFilesBlk;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfFilesBlk) as _HspfFilesBlk;
end;

class function CoHspfOpnSeqBlk.Create: _HspfOpnSeqBlk;
begin
  Result := CreateComObject(CLASS_HspfOpnSeqBlk) as _HspfOpnSeqBlk;
end;

class function CoHspfOpnSeqBlk.CreateRemote(const MachineName: string): _HspfOpnSeqBlk;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfOpnSeqBlk) as _HspfOpnSeqBlk;
end;

class function CoHspfOperation.Create: _HspfOperation;
begin
  Result := CreateComObject(CLASS_HspfOperation) as _HspfOperation;
end;

class function CoHspfOperation.CreateRemote(const MachineName: string): _HspfOperation;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfOperation) as _HspfOperation;
end;

class function CoHspfTableDef.Create: _HspfTableDef;
begin
  Result := CreateComObject(CLASS_HspfTableDef) as _HspfTableDef;
end;

class function CoHspfTableDef.CreateRemote(const MachineName: string): _HspfTableDef;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfTableDef) as _HspfTableDef;
end;

class function CoHspfBlockDef.Create: _HspfBlockDef;
begin
  Result := CreateComObject(CLASS_HspfBlockDef) as _HspfBlockDef;
end;

class function CoHspfBlockDef.CreateRemote(const MachineName: string): _HspfBlockDef;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfBlockDef) as _HspfBlockDef;
end;

class function CoHspfMsg.Create: _HspfMsg;
begin
  Result := CreateComObject(CLASS_HspfMsg) as _HspfMsg;
end;

class function CoHspfMsg.CreateRemote(const MachineName: string): _HspfMsg;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfMsg) as _HspfMsg;
end;

class function CoHspfSectionDef.Create: _HspfSectionDef;
begin
  Result := CreateComObject(CLASS_HspfSectionDef) as _HspfSectionDef;
end;

class function CoHspfSectionDef.CreateRemote(const MachineName: string): _HspfSectionDef;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfSectionDef) as _HspfSectionDef;
end;

class function CoHspfTable.Create: _HspfTable;
begin
  Result := CreateComObject(CLASS_HspfTable) as _HspfTable;
end;

class function CoHspfTable.CreateRemote(const MachineName: string): _HspfTable;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfTable) as _HspfTable;
end;

class function CoHspfOpnBlk.Create: _HspfOpnBlk;
begin
  Result := CreateComObject(CLASS_HspfOpnBlk) as _HspfOpnBlk;
end;

class function CoHspfOpnBlk.CreateRemote(const MachineName: string): _HspfOpnBlk;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfOpnBlk) as _HspfOpnBlk;
end;

class function CoHspfFtable.Create: _HspfFtable;
begin
  Result := CreateComObject(CLASS_HspfFtable) as _HspfFtable;
end;

class function CoHspfFtable.CreateRemote(const MachineName: string): _HspfFtable;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfFtable) as _HspfFtable;
end;

class function CoHspfConnection.Create: _HspfConnection;
begin
  Result := CreateComObject(CLASS_HspfConnection) as _HspfConnection;
end;

class function CoHspfConnection.CreateRemote(const MachineName: string): _HspfConnection;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfConnection) as _HspfConnection;
end;

class function CoHspfSrcTar.Create: _HspfSrcTar;
begin
  Result := CreateComObject(CLASS_HspfSrcTar) as _HspfSrcTar;
end;

class function CoHspfSrcTar.CreateRemote(const MachineName: string): _HspfSrcTar;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfSrcTar) as _HspfSrcTar;
end;

class function CoHspfMassLink.Create: _HspfMassLink;
begin
  Result := CreateComObject(CLASS_HspfMassLink) as _HspfMassLink;
end;

class function CoHspfMassLink.CreateRemote(const MachineName: string): _HspfMassLink;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfMassLink) as _HspfMassLink;
end;

class function CoHspfMetSeg.Create: _HspfMetSeg;
begin
  Result := CreateComObject(CLASS_HspfMetSeg) as _HspfMetSeg;
end;

class function CoHspfMetSeg.CreateRemote(const MachineName: string): _HspfMetSeg;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfMetSeg) as _HspfMetSeg;
end;

class function CoHspfMetSegRecord.Create: _HspfMetSegRecord;
begin
  Result := CreateComObject(CLASS_HspfMetSegRecord) as _HspfMetSegRecord;
end;

class function CoHspfMetSegRecord.CreateRemote(const MachineName: string): _HspfMetSegRecord;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfMetSegRecord) as _HspfMetSegRecord;
end;

class function CoHspfPoint.Create: _HspfPoint;
begin
  Result := CreateComObject(CLASS_HspfPoint) as _HspfPoint;
end;

class function CoHspfPoint.CreateRemote(const MachineName: string): _HspfPoint;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfPoint) as _HspfPoint;
end;

class function CoHspfTSGroupDef.Create: _HspfTSGroupDef;
begin
  Result := CreateComObject(CLASS_HspfTSGroupDef) as _HspfTSGroupDef;
end;

class function CoHspfTSGroupDef.CreateRemote(const MachineName: string): _HspfTSGroupDef;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfTSGroupDef) as _HspfTSGroupDef;
end;

class function CoHspfTSMemberDef.Create: _HspfTSMemberDef;
begin
  Result := CreateComObject(CLASS_HspfTSMemberDef) as _HspfTSMemberDef;
end;

class function CoHspfTSMemberDef.CreateRemote(const MachineName: string): _HspfTSMemberDef;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfTSMemberDef) as _HspfTSMemberDef;
end;

class function CoHspfMonthData.Create: _HspfMonthData;
begin
  Result := CreateComObject(CLASS_HspfMonthData) as _HspfMonthData;
end;

class function CoHspfMonthData.CreateRemote(const MachineName: string): _HspfMonthData;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfMonthData) as _HspfMonthData;
end;

class function CoHspfMonthDataTable.Create: _HspfMonthDataTable;
begin
  Result := CreateComObject(CLASS_HspfMonthDataTable) as _HspfMonthDataTable;
end;

class function CoHspfMonthDataTable.CreateRemote(const MachineName: string): _HspfMonthDataTable;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfMonthDataTable) as _HspfMonthDataTable;
end;

class function CoHspfStatus.Create: _HspfStatus;
begin
  Result := CreateComObject(CLASS_HspfStatus) as _HspfStatus;
end;

class function CoHspfStatus.CreateRemote(const MachineName: string): _HspfStatus;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfStatus) as _HspfStatus;
end;

class function CoHspfStatusType.Create: _HspfStatusType;
begin
  Result := CreateComObject(CLASS_HspfStatusType) as _HspfStatusType;
end;

class function CoHspfStatusType.CreateRemote(const MachineName: string): _HspfStatusType;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfStatusType) as _HspfStatusType;
end;

class function CoHspfSpecialActionBlk.Create: _HspfSpecialActionBlk;
begin
  Result := CreateComObject(CLASS_HspfSpecialActionBlk) as _HspfSpecialActionBlk;
end;

class function CoHspfSpecialActionBlk.CreateRemote(const MachineName: string): _HspfSpecialActionBlk;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfSpecialActionBlk) as _HspfSpecialActionBlk;
end;

class function CoHspfSpecialRecord.Create: _HspfSpecialRecord;
begin
  Result := CreateComObject(CLASS_HspfSpecialRecord) as _HspfSpecialRecord;
end;

class function CoHspfSpecialRecord.CreateRemote(const MachineName: string): _HspfSpecialRecord;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_HspfSpecialRecord) as _HspfSpecialRecord;
end;

end.
