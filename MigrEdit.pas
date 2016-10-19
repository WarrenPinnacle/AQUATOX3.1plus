//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit MigrEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, ExtCtrls, DBCtrls, Buttons, AQUAOBJ, Global,
  Db, DBTables, Loadings, LinkedSegs, AQStudy;

type
  TMigrForm = class(TForm)
    OKBtn: TBitBtn;
    Label5: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    LengthLabel: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ToBox1: TComboBox;
    f1: TEdit;
    m1: TEdit;
    d1: TEdit;
    m2: TEdit;
    d2: TEdit;
    f2: TEdit;
    ToBox2: TComboBox;
    m3: TEdit;
    d3: TEdit;
    f3: TEdit;
    ToBox3: TComboBox;
    m4: TEdit;
    d4: TEdit;
    f4: TEdit;
    ToBox4: TComboBox;
    m5: TEdit;
    d5: TEdit;
    f5: TEdit;
    ToBox5: TComboBox;
    procedure EditBoxExit(Sender: TObject);
    procedure ToBoxChange(Sender: TObject);
    procedure MonthExit(Sender: TObject);
    procedure DayExit(Sender: TObject);
  private
    { Private declarations }
  public
    LinkedSegmts : TLinkedSegs;
    ThisAQTS  : TAQUATOXSegment;    
    TheIDs    : TListBoxIDs;
    MigrTemp  : MigrInputType;       {animal screen only}
    Function  EditMigr(LS,TAQTS: Pointer): Boolean;
    Procedure UpdateScreen;

    { Public declarations }
  end;

var
  MigrForm: TMigrForm;

implementation

uses imp_load;

Procedure TMigrForm.UpdateScreen;
Var Loop, Index: Integer;
Begin

  Index:=-1;
  For Loop:=0 to ToBox1.Items.Count-1 do
    If MigrTemp[1].ToSeg = TheIDs[Loop] then Index:=Loop;
  ToBox1.ItemIndex := Index;

  Index:=-1;
  For Loop:=0 to ToBox2.Items.Count-1 do
    If MigrTemp[2].ToSeg = TheIDs[Loop] then Index:=Loop;
  ToBox2.ItemIndex := Index;

  Index:=-1;
  For Loop:=0 to ToBox3.Items.Count-1 do
    If MigrTemp[3].ToSeg = TheIDs[Loop] then Index:=Loop;
  ToBox3.ItemIndex := Index;

  Index:=-1;
  For Loop:=0 to ToBox4.Items.Count-1 do
    If MigrTemp[4].ToSeg = TheIDs[Loop] then Index:=Loop;
  ToBox4.ItemIndex := Index;

  Index:=-1;
  For Loop:=0 to ToBox5.Items.Count-1 do
    If MigrTemp[5].ToSeg = TheIDs[Loop] then Index:=Loop;
  ToBox5.ItemIndex := Index;


  M1.Text:=IntToStr(MigrTemp[1].MM);
  M2.Text:=IntToStr(MigrTemp[2].MM);
  M3.Text:=IntToStr(MigrTemp[3].MM);
  M4.Text:=IntToStr(MigrTemp[4].MM);
  M5.Text:=IntToStr(MigrTemp[5].MM);

  D1.Text:=IntToStr(MigrTemp[1].DD);
  D2.Text:=IntToStr(MigrTemp[2].DD);
  D3.Text:=IntToStr(MigrTemp[3].DD);
  D4.Text:=IntToStr(MigrTemp[4].DD);
  D5.Text:=IntToStr(MigrTemp[5].DD);

  F1.Text:=FloatToStrF(MigrTemp[1].FracMigr,ffgeneral,15,4);
  F2.Text:=FloatToStrF(MigrTemp[2].FracMigr,ffgeneral,15,4);
  F3.Text:=FloatToStrF(MigrTemp[3].FracMigr,ffgeneral,15,4);
  F4.Text:=FloatToStrF(MigrTemp[4].FracMigr,ffgeneral,15,4);
  F5.Text:=FloatToStrF(MigrTemp[5].FracMigr,ffgeneral,15,4);

End;


Function TMigrForm.EditMigr(LS,TAQTS: Pointer): Boolean;
Var Loop2: Integer;
    PATS: TAQUATOXSegment;
    MigrIDIndx: Integer;
Begin
  ThisAQTS := TAQTS;
  LinkedSegmts := LS;                               

  MigrIDIndx:=0;

  MigrForm.ToBox1.Items.Clear;  {set up the migration form}
      With LinkedSegmts do
        For Loop2 := 0 to SegmentColl.Count - 1 do
          Begin
            PATS := SegmentColl.At(Loop2);
            If PATS.SegNumber <> THisAQTS.SegNumber  {can't migrate to itself}
              then
                Begin
                  MigrForm.ToBox1.Items.Add('['+ PATS.SegNumber + ']: '+PATS.StudyName);
                  MigrForm.TheIDs[MigrIdIndx] := PATS.SegNumber;
                  Inc(MigrIDIndx);
                End;
          End;

  EditMigr := False;
  ToBox2.Items := ToBox1.Items;
  ToBox3.Items := ToBox1.Items;
  ToBox4.Items := ToBox1.Items;
  ToBox5.Items := ToBox1.Items;
  UpdateScreen;

  If ShowModal=MROK then
    Begin
      EditMigr := True;
    End;
End;

{$R *.DFM}

procedure TMigrForm.EditBoxExit(Sender: TObject);
Var Conv: Double;
    Result: Integer;

Begin
  Val(Trim(TEdit(Sender).Text),Conv,Result);
  Conv:=Abs(Conv);
  If (Result<>0) or (Conv>1.0)
    then MessageDlg('Incorrect Numerical Format Entered; Enter a Fraction Between 0 and 1',mterror,[mbOK],0)
    else Case TComponent(Sender).Name[2] of
      '1': MigrTemp[1].FracMigr := Conv;
      '2': MigrTemp[2].FracMigr := Conv;
      '3': MigrTemp[3].FracMigr := Conv;
      '4': MigrTemp[4].FracMigr := Conv;
      '5': MigrTemp[5].FracMigr := Conv;
     end; {case}

  UpdateScreen;
End;




procedure TMigrForm.ToBoxChange(Sender: TObject);
Var CharID: Char;
    IntID: Integer;
    ThisBox: TComboBox;
Begin
   CharID := TComponent(Sender).Name[6];
   IntID := StrToInt(CharID);
   Case CharID of
        '1': ThisBox := ToBox1;
        '2': ThisBox := ToBox2;
        '3': ThisBox := ToBox3;
        '4': ThisBox := ToBox4;
        else ThisBox := ToBox5;
      end; {case}

   If ThisBox.ItemIndex<0
     then MigrTemp[IntID].ToSeg := ''
     else MigrTemp[IntID].ToSeg := TheIDs[ThisBox.ItemIndex];
   UpdateScreen;
End;

procedure TMigrForm.MonthExit(Sender: TObject);
Var Conv: Double;
    ConvInt: Integer;
    Result: Integer;
Begin
  Val(Trim(TEdit(Sender).Text),Conv,Result);
  ConvInt:=Trunc(Abs(Conv));
  If (Result<>0) or (Conv<0) or (Conv>12)
    then MessageDlg('To input a month, enter an integer from "1" to "12" or "0" to indicate no migration.',mterror,[mbOK],0)
    else Case TComponent(Sender).Name[2] of
      '1': MigrTemp[1].MM := ConvInt;
      '2': MigrTemp[2].MM := ConvInt;
      '3': MigrTemp[3].MM := ConvInt;
      '4': MigrTemp[4].MM := ConvInt;
      '5': MigrTemp[5].MM := ConvInt;
     end; {case}
  UpdateScreen;
end;

procedure TMigrForm.DayExit(Sender: TObject);
Var Conv: Double;
    ConvInt: Integer;
    Result: Integer;
Begin
  Val(Trim(TEdit(Sender).Text),Conv,Result);
  ConvInt:=Trunc(Abs(Conv));
  If (Result<>0) or (Conv<0) or (Conv>31)
    then MessageDlg('To input a day, enter an integer from "1" to "31" or "0" to indicate no migration.',mterror,[mbOK],0)
    else Case TComponent(Sender).Name[2] of
      '1': MigrTemp[1].DD := ConvInt;
      '2': MigrTemp[2].DD := ConvInt;
      '3': MigrTemp[3].DD := ConvInt;
      '4': MigrTemp[4].DD := ConvInt;
      '5': MigrTemp[5].DD := ConvInt;
     end; {case}
  UpdateScreen;
end;

end.
