//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Wiz_8;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  wizardbase, StdCtrls, ExtCtrls, WizGlobal, Global, DBCtrls;

type
  TWizBase8 = class(TWizBase)
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    NameEdit: TEdit;
    LengthEdit: TEdit;
    AreaEdit: TEdit;
    DepthEdit: TEdit;
    MaxDepthEdit: TEdit;
    Label1: TLabel;
    Label13: TLabel;
    EvapEdit: TEdit;
    Label3: TLabel;
    Limnopanel: TPanel;
    Label14: TLabel;
    WallAreaEdit: TEdit;
    Label12: TLabel;
    Label15: TLabel;
    Bevel1: TBevel;
    StreamPanel: TPanel;
    Label16: TLabel;
    Label19: TLabel;
    C: TLabel;
    manninglabel: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    SlopeEdit: TEdit;
    ZManningEdit: TEdit;
    MoreLabel: TLabel;
    Label17: TLabel;
    Label22: TLabel;
    EstimateManningButt: TRadioButton;
    EnterManningButt: TRadioButton;
    StreamTypeLabel: TLabel;
    StreamBox: TComboBox;
    Label18: TLabel;
    Label20: TLabel;
    XLatEdit: TEdit;
    Label21: TLabel;
    Bevel2: TBevel;
    Label23: TLabel;
    RiffleEdit: TEdit;
    Label24: TLabel;
    Bevel3: TBevel;
    PoolEdit: TEdit;
    Label25: TLabel;
    Label26: TLabel;
    PRunLabel: TLabel;
    ConvertButton: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure ConvNumb(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure EstimateManningButtClick(Sender: TObject);
    procedure EnterManningButtClick(Sender: TObject);
    procedure StreamTypeBoxChange(Sender: TObject);
    procedure ConvertButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    Function  ExecuteScreen: WizOutput; override;
    Procedure UpdateScreen;
    Function  DataFinished: Boolean;
    { Public declarations }
  end;



var
  WizBase8: TWizBase8;

implementation

uses Convert;

{$R *.DFM}

Function TWizBase8.DataFinished: Boolean;
Var Loop: Integer;
Begin
  If WizStudy.Location.SiteType<>Enclosure
    then W8_FieldEdited[7] := True;
  If WizStudy.Location.SiteType<>Stream then
    Begin
      W8_FieldEdited[8] := True;
      W8_FieldEdited[9] := True;
      W8_FieldEdited[11]:=True; // Added by ma jinfeng
      W8_FieldEdited[12]:=True; // Added by ma jinfeng
    End;

  DataFinished := True;
  For Loop := 1 to W8_NumFields do
    If not W8_FieldEdited[Loop] then DataFinished := False;
End;


Procedure TWizBase8.UpdateScreen;
Var PPool, PRif, Val: Double;
    SiteName: String;
    ST: String;
Begin
 StreamPanel.Visible := W8_Screen=1;
 MainPanel.Visible   := W8_Screen=0;

 If W8_Screen=0 then
   Begin
     Case WizStudy.Location.SiteType of
       Pond: Sitename := 'pond';
       Stream: Sitename := 'stream';
       Reservr1D: Sitename := 'reservoir';
       Lake: Sitename := 'lake';
       Estuary: Sitename := 'estuary';
       Else Sitename := 'Enclosure';
       End; {Case}
     Explanation.Caption := 'Please fill in appropriate data for your '+SiteName+' below:';

     Limnopanel.Visible := (SiteName='Enclosure');

     With WizStudy.Location.Locale do
       Begin
         If (WizStatus<>0) or W8_FieldEdited[1]
           then NameEdit.Text := SiteName
           else NameEdit.Text := '';

         Val := SiteLength;
         If (WizStatus<>0) or W8_FieldEdited[2]
           then LengthEdit.Text := FloatToStrF(Val,ffGeneral,10,4)
           else LengthEdit.Text := '';

         Val := SurfArea;
         If (WizStatus<>0) or W8_FieldEdited[3]
           then AreaEdit.Text := FloatToStrF(Val,ffGeneral,10,4)
           else AreaEdit.Text := '';

         Val := ICZMean;
         If (WizStatus<>0) or W8_FieldEdited[4]
           then DepthEdit.Text := FloatToStrF(Val,ffGeneral,10,4)
           else DepthEdit.Text := '';

         Val := ZMax;
         If (WizStatus<>0) or W8_FieldEdited[5]
           then MaxDepthEdit.Text := FloatToStrF(Val,ffGeneral,10,4)
           else MaxDepthEdit.Text := '';

         Val := MeanEvap;
         If (WizStatus<>0) or W8_FieldEdited[6]
           then EvapEdit.Text := FloatToStrF(Val,ffGeneral,10,4)
           else EvapEdit.Text := '';

         Val := Latitude;
         If (WizStatus<>0) or W8_FieldEdited[10]
           then XLatEdit.Text := FloatToStrF(Val,ffGeneral,10,4)
           else XLatEdit.Text := '';

         Val := EnclWallArea;
         If (WizStatus<>0) or W8_FieldEdited[7]
           then WallAreaEdit.Text := FloatToStrF(Val,ffGeneral,10,4)
           else WallAreaEdit.Text := '';
       End; {with}
     MoreLabel.Visible := WizStudy.Location.SiteType = Stream;
   End;

 If W8_Screen=1 then
   Begin
     With WizStudy.Location.Locale do
       Begin
         Val := Channel_Slope;
         If (WizStatus<>0) or W8_FieldEdited[8]
           then SlopeEdit.Text := FloatToStrF(Val,ffGeneral,10,4)
           else SlopeEdit.Text := '';

         If ((WizStatus=0) and (Not W8_FieldEdited[9]))
           then
             Begin
               EstimateManningButt.Checked := False;
               EnterManningButt.Checked := False;
             End
           else
             Begin
               EstimateManningButt.Checked := Not UseEnteredManning;
               EnterManningButt.Checked := UseEnteredManning;
             End;

         StreamBox.Enabled    := EstimateManningButt.Checked;
         StreamTypeLabel.Enabled := EstimateManningButt.Checked;
         ManningLabel.Enabled := EnterManningButt.Checked;
         ZManningEdit.Enabled := EnterManningButt.Checked;

         ST := WizStudy.Location.Locale.StreamType;
         If ST='natural stream' then StreamBox.ItemIndex := 0
           else if ST='concrete channel' then StreamBox.ItemIndex := 1
             else if ST='dredged channel' then StreamBox.ItemIndex := 2
              else StreamBox.ItemIndex := -1;
         Val := WizStudy.Location.Locale.EnteredManning;
         ZManningEdit.Text := FloatToStrF(Val,ffGeneral,10,4);

         PRif := PctRiffle;
         If (WizStatus<>0) or W8_FieldEdited[11]
           then RiffleEdit.Text := FloatToStrF(PRif,ffGeneral,10,4)
           else RiffleEdit.Text := '';

         PPool := PctPool;
         If (WizStatus<>0) or W8_FieldEdited[12]
           then PoolEdit.Text := FloatToStrF(PPool,ffGeneral,10,4)
           else PoolEdit.Text := '';


         If (WizStatus<>0) or (W8_FieldEdited[11] and W8_FieldEdited[12])
           then
             Begin
                Val := 100 - PPool - PRif;
                If (Val>100) or (Val<0)
                   then PRunLabel.Caption := 'Error'
                   else PRunLabel.Caption := FloatToStrF(Val,ffGeneral,10,4);
             End
           else PRunLabel.Caption := '';
       End; {With}
   End;


End;

Function TWizBase8.ExecuteScreen: WizOutput;
Var Loop: Integer;
Begin
  If FirstVisit then
   For Loop := 1 to W8_NumFields do
    W8_FieldEdited[Loop] := False;

  If (JumpIn = WzBack) and (WizStudy.Location.SiteType = Stream)
    then W8_Screen := 1
    else W8_Screen := 0;

  UpdateScreen;
  ExecuteScreen := Inherited ExecuteScreen;
  If (WizStatus=0) and (DataFinished) then WizStatus := 2;
  For Loop := 1 to W8_NumFields do
    If (WizStatus=1) and (W8_FieldEdited[Loop]) then WizStatus := 2;
End;


procedure TWizBase8.ConvertButtonClick(Sender: TObject);
begin
  Application.CreateForm(TConvertForm,ConvertForm);
  If Sender = ConvertButton then ConvertForm.ConvertNumber(LengthEdit,CTLength);
  If Sender = Button1       then ConvertForm.ConvertNumber(AreaEdit,CTSurfArea);
  If Sender = Button2       then ConvertForm.ConvertNumber(DepthEdit,CTDepth);
  If Sender = Button3       then ConvertForm.ConvertNumber(MaxDepthEdit,CTDepth);
  If Sender = Button4       then ConvertForm.ConvertNumber(WallAreaEdit,CTSurfArea);

  ConvertForm.Free;
end;

procedure TWizBase8.ConvNumb(Sender: TObject);
Var Conv  : Double;
    Result: Integer;
    Txt: String;
Begin                                                      
  Txt :=Tedit(Sender).Text;
  If Trim(Txt)='' then exit;

  If TEdit(Sender).Name[1] = 'N' then
   With WizStudy.Location.Locale do
    Begin
      If (Txt<>SiteName) or (WizStatus=0) then W8_FieldEdited[1]:=True;
      SiteName := Txt;
      Exit;
    End;

  Val(Txt,Conv,Result);
  If TEdit(Sender).Name[1]<>'X' then
    Conv:=Abs(Conv);
  If (Result<>0)
       then MessageDlg('Incorrect Numerical Format Entered',mterror,[mbOK],0)
       else With WizStudy.Location.Locale do
            Begin
              case TEdit(Sender).Name[1] of
                'L': Begin
                       If (SiteLength<>Conv) or (WizStatus=0) then W8_FieldEdited[2]:=True;
                       SiteLength :=Conv;
                       XLength := '';
                     End;
                'A': Begin
                       If (SurfArea<>Conv) or (WizStatus=0) then W8_FieldEdited[3]:=True;
                       SurfArea :=Conv;
                       XSurfArea := '';
                     End;
                'D': Begin
                       If (ICZMean<>Conv) or (WizStatus=0) then W8_FieldEdited[4]:=True;
                       ICZMean :=Conv;
                       XZMean := '';
                     End;
                'M': Begin
                       If (ZMax<>Conv) or (WizStatus=0) then W8_FieldEdited[5]:=True;
                       ZMax :=Conv;
                       XZMax := '';
                     End;
                'E': Begin
                       If (MeanEvap<>Conv) or (WizStatus=0) then W8_FieldEdited[6]:=True;
                       MeanEvap :=Conv;
                       XMeanEvap := '';
                     End;
                'W': Begin
                       If (EnclWallArea<>Conv) or (WizStatus=0) then W8_FieldEdited[7]:=True;
                       EnclWallArea :=Conv;
                       XEnclWallArea := '';
                     End;
                'S':  Begin
                       If (Channel_Slope<>Conv) or (WizStatus=0) then W8_FieldEdited[8]:=True;
                       Channel_Slope :=Conv;
                       XChannel_Slope := '';
                     End;
                'X':  Begin
                       If (Latitude<>Conv) or (WizStatus=0) then W8_FieldEdited[10]:=True;
                       Latitude := Conv;
                       XLatitude := '';
                      End;
                'R':  Begin
                       If (PctRiffle<>Conv) or (WizStatus=0) then W8_FieldEdited[11]:=True;
                       PctRiffle := Conv;
                       XPctRiffle := '';
                      End;
                'P':  Begin
                       If (PctPool<>Conv) or (WizStatus=0) then W8_FieldEdited[12]:=True;
                       PctPool := Conv;
                       XPctPool := '';
                      End;
                'Z':  Begin
                       EnteredManning :=Conv;
                      End;
              End; {case}
            End; {else}
  UpdateScreen;
End;

procedure TWizBase8.NextButtonClick(Sender: TObject);
begin
  If (W8_Screen=1) or (WizStudy.Location.SiteType<>Stream)
    then inherited
    else
      Begin
        Inc(W8_Screen);
        UpdateScreen;
      End;
end;

procedure TWizBase8.BackButtonClick(Sender: TObject);
begin
  If W8_Screen>0
    then
      Begin
        Dec(W8_Screen);
        UpdateScreen;
      End
    else inherited;
end;


procedure TWizBase8.EstimateManningButtClick(Sender: TObject);
begin
  With Sender as TRadioButton do
    WizStudy.Location.Locale.UseEnteredManning := not Checked;
  W8_FieldEdited[9] := True;
  UpdateScreen;
end;

procedure TWizBase8.EnterManningButtClick(Sender: TObject);
begin
  With Sender as TRadioButton do
    WizStudy.Location.Locale.UseEnteredManning := Checked;
  W8_FieldEdited[9] := True;
  UpdateScreen;
end;

procedure TWizBase8.StreamTypeBoxChange(Sender: TObject);
begin
  WizStudy.Location.Locale.StreamType  := StreamBox.Text;
  UpdateScreen;
end;

end.
