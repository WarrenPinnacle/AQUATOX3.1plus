//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit Librarys2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Chem,
  Site,Plant,Animal,Remin, StdCtrls, FileCtrl, Global, DB, AQBaseform,
  DBTables, librarys;

type
  TLibrary_File1 = class(TLibrary_File)
  private
    { Private declarations }
  public
     Procedure EditLibrary(LibString: ShortString);
     Function ReturnDBName(LibString:ShortString; Var DirNm,FileNm: ShortString): Boolean;
    { Public declarations }
  end;

var
  Library_File1: TLibrary_File1;


implementation

uses EstKPSed, ChemTox, ec50lc50, regress, StreamFrm, PFAK2s;


Function TLibrary_File1.ReturnDBName(LibString:ShortString; Var DirNm,FileNm: ShortString): Boolean;
Var  smallfilter: ShortString;
Begin
    Application.CreateForm(TLibrary_File, Library_File);

    {ENABLE DIALOG BOX TO FIND LOCATION OF LIBRARY FILE}
    With Library_File do
       begin
         FileListBox1.Directory:=Default_Dir;
         Caption:=LibString+' Library:';
         SmallFilter:=FilterComboBox1.Filter;
         FilterComboBox1.Filter:=LibString+' Library (*.'+Libstring[1]+'DB)|*.'+Libstring[1]+'DB|'+SmallFilter;
         RadioButton1.Caption:='Default: '+LibString+'.'+Libstring[1]+'DB';
         RadioButton1.Checked:=True;
         ShowModal;
         Hide;
         FilterComboBox1.Filter:=SmallFilter;
       end; {with}

    ReturnDBName := False;
    if FileN='Cancel' then exit;

    ReturnDBName := True;
    DirNm := Dir;  FileNm := FileN;
    If FileN='Default' then begin  DirNm:=Default_Dir;
                                   FileNm:=Libstring+'.'+Libstring[1]+'DB';
                            end;
End;


Procedure TLibrary_File1.EditLibrary(LibString: ShortString);
{This code provides the interface between the main program and the edit
library fields by asking the user to select the appropriate database and
calling the right form to modify that database}

Var modalresult: integer;
    smallfilter: ShortString;

Begin
    Application.CreateForm(TLibrary_File, Library_File);

    modalresult:=mrcancel;
    {ENABLE DIALOG BOX TO FIND LOCATION OF LIBRARY FILE}
    With Library_File do
       begin
         FileListBox1.Directory:=Default_Dir;
         Caption:=LibString+' Library:';
         SmallFilter:=FilterComboBox1.Filter;
         FilterComboBox1.Filter:=LibString+' Library (*.'+Libstring[1]+'DB)|*.'+Libstring[1]+'DB|'+SmallFilter;
         RadioButton1.Caption:='Default: '+LibString+'.'+Libstring[1]+'DB';
         RadioButton1.Checked:=True;
         ShowModal;
         Hide;
         FilterComboBox1.Filter:=SmallFilter;
       end; {with}

    if FileN='Cancel' then exit;
    If FileN='Default' then begin  Dir:=Default_Dir;
                                   FileN:=Libstring+'.'+Libstring[1]+'DB';
                            end;

    If not Library_File.Transfer_TempFile(LibString,Dir,FileN,True) then exit;
            {Transfer, if not successful, exit}

    Try
    Case LibString[1] of
         'C': Begin   {Chemical}
                Application.CreateForm(TEdit_Chemical, Edit_Chemical);
                Application.CreateForm(TKPSedConfirm, KPSedConfirm);
                Application.CreateForm(TPFAK2Form, PFAK2Form);
                Application.CreateForm(TChemToxForm, ChemToxForm);
                Application.CreateForm(TEC50LC50Dialog, EC50LC50Dialog);
                Application.CreateForm(TRegrDialog, RegrDialog);
                Edit_Chemical.PLipidModified := Nil;
                Edit_Chemical.Table1.Active:=False;
                Edit_Chemical.Table1.DatabaseName:=Program_Dir;
                Edit_Chemical.Table1.TableName:='TEMPEDIT.DB';
                Edit_Chemical.Table1.Active:=True;
                Edit_Chemical.LibraryMode := True;
                ModalResult:=Edit_Chemical.ShowModal;
                Edit_Chemical.Hide;
                Edit_Chemical.Free;
                KPSedConfirm.Free;
                PFAK2Form.Free;
                ChemToxForm.Free;
                EC50LC50Dialog.Free;
                RegrDialog.Free;
              End;
         'A': Begin  {Animal}
                Application.CreateForm(TEdit_Animal, Edit_Animal);
                Edit_Animal.Table2.Active:=False;
                Edit_Animal.Table2.DatabaseName:=Program_Dir;
                Edit_Animal.Table2.TableName:='TEMPEDIT.DB';
                Edit_Animal.Table2.Active:=True;
                Edit_Animal.OrigDBDir := Dir;
                Edit_Animal.MultiFish := False;
                Edit_Animal.YOYFish := False;
                Edit_Animal.LibraryMode := True;
                Edit_Animal.EditAllLinks.Visible := False;
                ModalResult:=Edit_Animal.ShowModal;
                Edit_Animal.Hide;
                Edit_Animal.Free;
              End;
         'P': Begin  {Plant}
                Application.CreateForm(TEdit_Plant, Edit_Plant);
                edit_plant.Table3.Active:=False;
                edit_plant.Table3.DatabaseName:=Program_Dir;
                edit_plant.Table3.TableName:='TEMPEDIT.DB';
                edit_plant.Table3.Active:=True;
                Edit_plant.LibraryMode := True;
                Edit_plant.EditAllLinks.Visible := False;
                ModalResult:=edit_plant.ShowModal;
                Edit_Plant.Hide;
                edit_plant.Free;
              End;
          'S': Begin    {Site}
                Application.CreateForm(TEdit_site, Edit_site);
                Application.CreateForm(TStreamform, Streamform);
                edit_site.Table2.Active:=False;
                edit_site.Table2.DatabaseName:=Program_Dir;
                edit_site.Table2.TableName:='TEMPEDIT.DB';
                edit_site.Table2.Active:=True;
                edit_site.Libmode := True;
                ModalResult:=edit_site.ShowModal;
                Edit_site.Hide;
                edit_site.Free;
                StreamForm.Free;
              End;
           'R': Begin    {Remineralization}
                Application.CreateForm(TRemineralization, Remineralization);
                Remineralization.Table1.Active:=False;
                Remineralization.Table1.DatabaseName:=Program_Dir;
                Remineralization.Table1.TableName:='TEMPEDIT.DB';
                Remineralization.Table1.Active:=True;
                ModalResult:=Remineralization.ShowModal;
                Remineralization.Hide;
                Remineralization.Free;
              End;
    End; {Case}

    Except
        MessageDlg('Invalid File Format',mterror,[mbOK],0)
    end;  {try Except}

 If ModalResult=MROK then Library_File.Transfer_TempFile(LibString,Dir,FileN,False);
 Library_File.Free

End;


{$R *.DFM}

end.
