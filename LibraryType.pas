//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit LibraryType;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TLibTypeForm = class(TForm)
    AnimalButton: TRadioButton;
    PlantButton: TRadioButton;
    SiteButton: TRadioButton;
    ReminButton: TRadioButton;
    ChemButton: TRadioButton;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LibTypeForm: TLibTypeForm;

implementation

{$R *.DFM}

end.
