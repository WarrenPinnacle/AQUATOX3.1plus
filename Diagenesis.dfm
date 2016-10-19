object DiagenesisForm: TDiagenesisForm
  Left = 0
  Top = 0
  Caption = 'Edit Sediment Diagenesis Parameters'
  ClientHeight = 612
  ClientWidth = 898
  Color = clGray
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  WindowState = wsMaximized
  DesignSize = (
    898
    612)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 108
    Top = 589
    Width = 140
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Copy Diagenesis Parameters '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitLeft = 111
    ExplicitTop = 605
  end
  object StringGrid1: TStringGrid
    Left = 23
    Top = 15
    Width = 845
    Height = 532
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = 14347226
    DefaultColWidth = 80
    FixedCols = 0
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing]
    ParentFont = False
    TabOrder = 0
    OnExit = StringGrid1Exit
    OnSelectCell = StringGrid1SelectCell
    OnSetEditText = StringGrid1SetEditText
    ExplicitWidth = 848
    ExplicitHeight = 548
    RowHeights = (
      24
      24
      24
      27
      24)
  end
  object HelpButton: TButton
    Left = 597
    Top = 560
    Width = 78
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = HelpButtonClick
    ExplicitLeft = 600
    ExplicitTop = 576
  end
  object CancelBtn: TButton
    Left = 690
    Top = 560
    Width = 78
    Height = 29
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = CancelBtnClick
    ExplicitLeft = 693
    ExplicitTop = 576
  end
  object OKBtn: TButton
    Left = 786
    Top = 560
    Width = 78
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 3
    ExplicitLeft = 789
    ExplicitTop = 576
  end
  object CSaveExcel: TButton
    Left = 350
    Top = 559
    Width = 167
    Height = 31
    Anchors = [akRight, akBottom]
    Caption = '&Save Table to Excel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = CSaveExcelClick
  end
  object CopyToAll: TButton
    Left = 93
    Top = 560
    Width = 171
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = 'Copy to All Segments'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = CopyToAllClick
    ExplicitLeft = 96
    ExplicitTop = 576
  end
end
