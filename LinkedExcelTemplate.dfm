object LinkedExcelForm: TLinkedExcelForm
  Left = 0
  Top = 0
  Caption = 'LinkedExcelForm'
  ClientHeight = 462
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    550
    462)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 27
    Top = 8
    Width = 492
    Height = 402
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 439
    Top = 423
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Done'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 183
    Top = 423
    Width = 118
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Copy to Clipboard'
    TabOrder = 2
    OnClick = Button2Click
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.xls*|*.xls*|*.*|*.*'
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 37
    Top = 12
  end
end
