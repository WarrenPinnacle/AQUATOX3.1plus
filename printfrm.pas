//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit PrintFrm;

interface

uses printers,classes,forms, WinTypes, WinProcs, Messages, SysUtils, Graphics, Menus,
  Controls, AQBaseform;
Type

TPrintingForm=class(TAQBase)
    procedure PrintAQF(Iteration,Tot: integer);
    Procedure FormCreate(Sender: TObject);
end;

implementation

(*procedure TForm.Print;
var
  FormImage: TBitmap;
  Info: PBitmapInfo;
  InfoSize: Integer;
  Image: Pointer;
  ImageSize: DWORD;
  Bits: HBITMAP;
  DIBWidth, DIBHeight: Longint;
  PrintWidth, PrintHeight: Longint;
      XTAB: Integer;
{}  FormImage: TBitmap;
{}  Info: PBitmapInfo;
{}  InfoSize: Integer;
{}  Image: Pointer;
{}  ImageSize: Longint;
{}  Bits: HBITMAP;
{}  DIBWidth, DIBHeight, Single_DIBHeight: Longint;
{}  PrintWidth, PrintHeight: Longint;

begin
  Printer.BeginDoc;
  try
    FormImage := GetFormImage;
    try
      { Paint bitmap to the printer }
      with Printer, Canvas do
      begin
        Bits := FormImage.Handle;
        GetDIBSizes(Bits, InfoSize, ImageSize);
        Info := AllocMem(InfoSize);
        try
          Image := AllocMem(ImageSize);
          try
            GetDIB(Bits, 0, Info^, Image^);
            with Info^.bmiHeader do
            begin
              DIBWidth := biWidth;
              DIBHeight := biHeight;
            end;
            case PrintScale of
              poProportional:
                begin
                  PrintWidth := MulDiv(DIBWidth, GetDeviceCaps(Handle,
                    LOGPIXELSX), PixelsPerInch);
                  PrintHeight := MulDiv(DIBHeight, GetDeviceCaps(Handle,
                    LOGPIXELSY), PixelsPerInch);
                end;
              poPrintToFit:
                begin
                  PrintWidth := MulDiv(DIBWidth, PageHeight, DIBHeight);
                  if PrintWidth < PageWidth then
                    PrintHeight := PageHeight
                  else
                  begin
                    PrintWidth := PageWidth;
                    PrintHeight := MulDiv(DIBHeight, PageWidth, DIBWidth);
                  end;
                end;
            else
              PrintWidth := DIBWidth;
              PrintHeight := DIBHeight;
            end;
            StretchDIBits(Canvas.Handle, 0, 0, PrintWidth, PrintHeight, 0, 0,
              DIBWidth, DIBHeight, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
          finally
            FreeMem(Image, ImageSize);
          end;
        finally
          FreeMem(Info, InfoSize);
        end;
      end;
    finally
      FormImage.Free;
    end;
  finally
    Printer.EndDoc;
  end;
end;
  *)
procedure TPrintingForm.PrintAQF(Iteration,Tot: integer);
{}var
    XTAB: Integer;
{}  FormImage: TBitmap;
{}  Info: PBitmapInfo;
{}  InfoSize: DWord;
{}  Image: Pointer;
{}  ImageSize: DWORD;
{}  Bits: HBITMAP;
{}  DIBWidth, DIBHeight, Single_DIBHeight: Longint;
{}  PrintWidth, PrintHeight: Longint;
{}begin
{}If Iteration=1 then Printer.BeginDoc;
{}  try
{}    FormImage := GetFormImage;
{}    try
{}      { Paint bitmap to the printer }
{}      with Printer, Canvas do
{}      begin
{}        Bits := FormImage.Handle;
{}        GetDIBSizes(Bits, InfoSize, ImageSize);
{}        GetMem(Info,InfoSize);
{}        try
{}          GetMem(Image,ImageSize);
{}          try
{}            GetDIB(Bits, 0, Info^, Image^);
{}            with Info^.bmiHeader do
{}            begin
{}              DIBWidth := biWidth;           {The width of the screen}
{}              Single_DIBHeight := biHeight;  {The Height of the Screen}
{}              DIBHEIGHT := biHeight*Tot;       {The Height of the Full Form}
{}            end;
              {PRINT PROPORTIONALLY}
{}                begin
{}                  PrintWidth := MulDiv(DIBWidth, PageHeight, DIBHeight);
{}                  if PrintWidth < PageWidth then
{}                    PrintHeight := PageHeight
{}                  else
{}                  begin
{}                    PrintWidth := PageWidth;
{}                    PrintHeight := MulDiv(DIBHeight, PageWidth, DIBWidth);
{}                  end;
{}                end;
                  XTab:=(PageWidth-PrintWidth) div 2;
              Repeat Inc(PrintHeight) until (PrintHeight Mod Tot) = 0;
{}            StretchDIBits(Canvas.Handle,XTab,(PrintHeight div Tot)*(iteration-1), PrintWidth, PrintHeight div Tot, 0, 0,
{}              DIBWidth, Single_DIBHeight, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
{}          finally
{}            FreeMem(Image, ImageSize);
{}          end;
{}        finally
{}          FreeMem(Info, InfoSize);
{}        end;
{}      end;
{}    finally
{}      FormImage.Free;
{}    end;
{}  finally
{}    If Iteration=Tot then Printer.EndDoc;
{}  end;
{}end;

Procedure TPrintingForm.FormCreate;
Begin
 inherited;
end;

end.
