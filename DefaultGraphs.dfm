object DefaultGraphForm: TDefaultGraphForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Select a Graph to Create'
  ClientHeight = 356
  ClientWidth = 478
  Color = clGray
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  DesignSize = (
    478
    356)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 19
    Width = 309
    Height = 18
    AutoSize = False
    Caption = 'Create Graph using State Variables in Scenario:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 11
    Top = 50
    Width = 445
    Height = 254
    BorderStyle = bsSingle
    ParentBackground = False
    TabOrder = 2
    object ChemLabel: TLabel
      Left = 207
      Top = 164
      Width = 57
      Height = 18
      AutoSize = False
      Caption = 'Chemical:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object RadioButton1: TRadioButton
      Left = 24
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Custom Graph'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 24
      Top = 49
      Width = 113
      Height = 17
      Caption = 'All Animals'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = RadioButton1Click
    end
    object RadioButton3: TRadioButton
      Left = 24
      Top = 83
      Width = 113
      Height = 17
      Caption = 'All Plants'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = RadioButton1Click
    end
    object RadioButton4: TRadioButton
      Left = 24
      Top = 116
      Width = 113
      Height = 17
      Caption = 'Nutrients'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = RadioButton1Click
    end
    object RadioButton5: TRadioButton
      Left = 24
      Top = 148
      Width = 201
      Height = 17
      Caption = 'Chem. PPB in Animals'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = RadioButton1Click
    end
    object RadioButton6: TRadioButton
      Left = 24
      Top = 181
      Width = 201
      Height = 17
      Caption = 'Chem. PPB in Plants'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = RadioButton1Click
    end
    object RadioButton7: TRadioButton
      Left = 24
      Top = 218
      Width = 201
      Height = 17
      Caption = 'Other -->'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = RadioButton1Click
    end
    object GraphMenu: TComboBox
      Left = 106
      Top = 214
      Width = 227
      Height = 23
      Style = csDropDownList
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 15
      ParentFont = False
      TabOrder = 7
      Items.Strings = (
        'Stationary Plants'
        'Phytoplankton Summary'
        'Invertebrates'
        'Fish'
        'Detritus'
        'Temperature'
        'Chlorophyll a'
        'Water Volume')
    end
    object ToxComboBox: TComboBox
      Left = 270
      Top = 160
      Width = 145
      Height = 24
      Style = csDropDownList
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemHeight = 0
      ParentFont = False
      TabOrder = 8
      Visible = False
      OnChange = ToxComboBoxChange
    end
  end
  object OKBtn: TBitBtn
    Left = 381
    Top = 319
    Width = 77
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    IsControl = True
  end
  object CancelBtn: TBitBtn
    Left = 277
    Top = 319
    Width = 84
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Kind = bkCancel
    Margin = 2
    Spacing = -1
    IsControl = True
  end
  object ScenarioBox: TComboBox
    Left = 330
    Top = 15
    Width = 127
    Height = 23
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 15
    ParentFont = False
    TabOrder = 3
    OnChange = ScenarioBoxChange
    Items.Strings = (
      'Control'
      'Perturbed')
  end
  object HelpButton: TButton
    Left = 177
    Top = 319
    Width = 77
    Height = 24
    Caption = 'Help'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = HelpButtonClick
  end
end
