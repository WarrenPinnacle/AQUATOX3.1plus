//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit EditForm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,Printfrm,Printing,
  Forms, Dialogs, StdCtrls, DBCtrls, ExtCtrls, Mask, DB, DBTables, Finddlg, Global, RegrLC50;

type
  TEditForm = class(TPrintingForm)
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    ScrollBox1: TScrollBox;
    LabelC: TLabel;
    DBEdit1: TDBEdit;
    DBText1: TDBText;
    Button3: TButton;
    Bevel2: TBevel;
    Button1: TButton;
    Button2: TButton;
    SaveButton: TButton;
    CancelButton: TButton;
    PrintButton: TButton;
    procedure FormResize(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Calc_Eq_Days(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
    procedure LC50Change(Sender: TObject);
    procedure Return_Posts(Sender: TObject; var Key: Char);
    procedure PhytoEC50Change(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    ShowTop: Boolean;
    EditName: ShortString;
    ScrollHeight: Integer;
    { Public declarations }
  end;

var
  EditForm: TEditForm;
  retpress: boolean;

implementation

{$R *.DFM}

procedure TEditForm.FormResize(Sender: TObject);
begin
    ScrollBox1.Height:=editform.ClientHeight-49;
    ScrollBox1.Width:=editform.ClientWidth-2;
end;

procedure TEditForm.DBNavigator1Click(Sender: TObject;
  Button: TNavigateBtn);
  {Come back to top of scroll box when navigator is utilized}
begin
    Scrollbox1.VertScrollBar.Position:=0;
end;


procedure TEditForm.Button1Click(Sender: TObject);
{Handle the Find Button}
begin
    BtnBottomDlg.Label3.caption:=EditName;
    BtnBottomDlg.ActiveControl:=BtnBottomDlg.Edit1;
    BtnBottomDlg.Edit1.SelectAll;
    BtnBottomDlg.ShowModal;
    If not ((ReturnString='cancel') or (ReturnString=''))
       then with Table1 do
       begin
         SetKey;
         Fields[0].AsString := ReturnString;
         GotoNearest;
       end;
end;



procedure TEditForm.Button2Click(Sender: TObject);
{the New Button}
Var Counter: Integer;
    name   : ShortString;

begin
  Counter:=0;
  name:='';
  Repeat         {Protect against multiple names}
     Counter:=Counter+1;
     If Counter>1 then Str(Counter,Name);
     name:='New'+EditName+name;
  until not Table1.FindKey([name]);

  Table1.InsertRecord([name]);  {Insert the new Record}
  DBEdit1.SetFocus;
  DBEdit1.Selectall;
end;


procedure TEditForm.FormCreate(Sender: TObject);
{Enable Exception Handling}
begin
   RetPress:=False;
   Application.OnException:=AppException;
end;

procedure TEditForm.AppException(Sender: TObject; E: Exception);
begin
   If E.Message='Key violation' then  {multiple name error message}
      MessageDlg('A Chemical of that Name Already Exists, Please Give Your Entry a New Name',mtError,[mbOK],0)
   else
   Application.ShowException(E);      {mainly handles invalid # format}
end;




procedure TEditForm.SaveButtonClick(Sender: TObject);
begin
   if table1.State in [dsedit,dsinsert] then Table1.Post;
   If MessageDlg('Save database changes and exit?',mtConfirmation,mbOKCancel,0)=mrOK then
      editform.ModalResult:=MROK;
end;

procedure TEditForm.CancelButtonClick(Sender: TObject);
begin
      If MessageDlg('Throw out all edits?',mtConfirmation,mbOKCancel,0)=mrOK then
         editform.ModalResult:=MRCancel;
end;

procedure TEditForm.PrintButtonClick(Sender: TObject);
{PRINT PROCEDURE THAT WORKS, BUT IS SOMEWHAT UGLY IN NATURE, EACH FORM
REQUIRES A SEPERATE PROCEDURE DUE ONLY TO ITS HEIGHT.  A MORE GENERAL PRINT
COULD BE CREATED IN THE FUTURE}

var old_win_height,old_win_top,old_win_left,old_win_width,
    old_sb_height,old_sb_top,old_sb_left,old_sb_width,
    old_sb_vsb_position: longint;

begin
    If Not PrintDialog1.Execute then exit;

    Application.CreateForm(TPrintCoverForm, PrintCoverForm);
    PrintCoverForm.Gauge1.Progress:=0;
    PrintCoverForm.Show;
    {Save Window Position}
    old_win_height:=height;
    old_win_top:=top;
    old_win_left:=Left;
    old_win_width:=Width;
    old_sb_height:=Scrollbox1.Height;
    old_sb_top:=Scrollbox1.Top;
    old_sb_left:=Scrollbox1.Left;
    old_sb_width:=Scrollbox1.Width;
    old_sb_vsb_position:=Scrollbox1.VertScrollBar.Position;

    {Set up Screen for Printing}
    Scrollbox1.Align:=alNone;

    {Hide Upper Buttons}
    PrintButton.Visible:=False;
    DBNAVIGATOR1.VISIBLE:=False;
    SAVEBUTTON.VISIBLE:=False;
    CancelButton.VISIBLE:=False;

    Top:=0;
    Left:=0;
    Width:=634;
    ClientHeight:=ScrollHeight div 3;
    Scrollbox1.Borderstyle:=bsNone;
    Scrollbox1.Top:=0;
    Scrollbox1.Left:=0;
    Scrollbox1.Width:=634;
    Scrollbox1.Height:=ScrollHeight div 3;

    Scrollbox1.HorzScrollBar.Visible:=False;
    Scrollbox1.VertScrollBar.Position:=0;

    update;

    PrintCoverForm.Gauge1.Progress:=3;
    PrintCoverForm.Update;

    PrintAQF(1);

   Scrollbox1.VertScrollBar.Position:=ScrollHeight div 3;
   update;
   PrintCoverForm.Gauge1.Progress:=20;
   PrintCoverForm.Update;
   PrintAQF(2);
   Scrollbox1.Vertscrollbar.Position:=ScrollHeight;
   update;
   PrintCoverForm.Gauge1.Progress:=35;
   PrintCoverForm.Update;
   PrintAQF(3);

    {Restore Window Position}
    Scrollbox1.Borderstyle:=bsSingle;
    Scrollbox1.HorzScrollBar.Visible:=True;
    Scrollbox1.Align:=alNone;

    PrintButton.Visible:=true;
    DBNAVIGATOR1.VISIBLE:=true;
    SAVEBUTTON.VISIBLE:=true;
    CancelButton.VISIBLE:=true;

    height:=old_win_height;
    top:=old_win_top;
    Left:=old_win_left;
    Width:=old_win_width;
    Scrollbox1.Height:=old_sb_height;
    Scrollbox1.Top:=old_sb_top;
    Scrollbox1.Left:=old_sb_left;
    Scrollbox1.Width:=old_sb_width;
    Scrollbox1.VertScrollBar.Position:=old_sb_vsb_position;
    Update;
    Show;
    PrintCoverForm.Hide;
    PrintCoverForm.Free;

end;

end.

