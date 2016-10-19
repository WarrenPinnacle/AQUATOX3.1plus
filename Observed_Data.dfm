object Edit_Data_Form: TEdit_Data_Form
  Left = 0
  Top = 0
  ActiveControl = DriveComboBox1
  Caption = 'Attached Observed Data'
  ClientHeight = 589
  ClientWidth = 824
  Color = clGray
  Constraints.MinHeight = 583
  Constraints.MinWidth = 777
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  DesignSize = (
    824
    589)
  PixelsPerInch = 96
  TextHeight = 13
  object Label9: TLabel
    Left = 331
    Top = 513
    Width = 344
    Height = 19
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 
      'To delete a record, press <Ctrl> <Del>   To insert, press <Ctrl>' +
      '<Ins>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    ExplicitTop = 473
  end
  object GridPanel: TPanel
    Left = 328
    Top = 8
    Width = 488
    Height = 502
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'No Series Attached'
    ParentBackground = False
    TabOrder = 4
    DesignSize = (
      488
      502)
    object StringGrid1: TStringGrid
      Left = 2
      Top = 2
      Width = 483
      Height = 498
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = 14347226
      DefaultColWidth = 80
      FixedCols = 0
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing]
      ParentFont = False
      TabOrder = 0
      OnExit = StringGrid1Exit
      OnKeyDown = StringGrid1KeyDown
      OnKeyPress = StringGrid1KeyPress
      OnSelectCell = StringGrid1SelectCell
      OnSetEditText = StringGrid1SetEditText
      ExplicitWidth = 428
      ExplicitHeight = 458
      RowHeights = (
        24
        24
        24
        27
        24)
    end
  end
  object ImportNDBox: TCheckBox
    Left = 714
    Top = 384
    Width = 103
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Import NDs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    ExplicitLeft = 659
  end
  object ImportErrBox: TCheckBox
    Left = 713
    Top = 406
    Width = 105
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Import Err Bars'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    ExplicitLeft = 658
  end
  object ExcelOptPanel: TPanel
    Left = 327
    Top = 375
    Width = 481
    Height = 33
    Anchors = [akLeft, akRight, akBottom]
    ParentBackground = False
    TabOrder = 10
    DesignSize = (
      481
      33)
    object Label16: TLabel
      Left = 4
      Top = 8
      Width = 45
      Height = 16
      Caption = 'Sheet #'
      FocusControl = DirectoryListBox1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 185
      Top = 8
      Width = 54
      Height = 16
      Caption = 'Date Col.'
      FocusControl = DirectoryListBox1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label18: TLabel
      Left = 273
      Top = 8
      Width = 49
      Height = 16
      Caption = 'Val. Col.'
      FocusControl = DirectoryListBox1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label19: TLabel
      Left = 84
      Top = 8
      Width = 61
      Height = 16
      Caption = 'Start Row:'
      FocusControl = DirectoryListBox1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 411
      Top = 1
      Width = 67
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'NDs, ErrBars in next 3 cols.'
      FocusControl = DirectoryListBox1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitLeft = 356
    end
    object SheetEdit: TEdit
      Left = 55
      Top = 5
      Width = 21
      Height = 22
      Color = 14347226
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      Text = '1'
    end
    object RowEdit: TEdit
      Left = 149
      Top = 5
      Width = 28
      Height = 22
      Color = 14347226
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      Text = '1'
    end
    object DCEdit: TEdit
      Left = 243
      Top = 5
      Width = 23
      Height = 22
      CharCase = ecUpperCase
      Color = 14347226
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
      Text = 'A'
    end
    object VCEdit: TEdit
      Left = 327
      Top = 5
      Width = 23
      Height = 22
      CharCase = ecUpperCase
      Color = 14347226
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 3
      Text = 'B'
    end
  end
  object Panel1: TPanel
    Left = 332
    Top = 11
    Width = 481
    Height = 358
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvNone
    Constraints.MinHeight = 317
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      481
      358)
    object Label2: TLabel
      Left = 16
      Top = 5
      Width = 69
      Height = 16
      Caption = 'File &Name:'
      FocusControl = FileEdit
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 284
      Top = 5
      Width = 72
      Height = 16
      Anchors = [akTop, akRight]
      Caption = '&Directories:'
      FocusControl = DirectoryListBox1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 229
    end
    object PathLabel: TLabel
      Left = 282
      Top = 30
      Width = 101
      Height = 16
      Anchors = [akTop, akRight]
      Caption = 'C:\Windows\system32'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial Narrow'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 227
    end
    object Label1: TLabel
      Left = 17
      Top = 301
      Width = 116
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = 'List Files of &Type:'
      FocusControl = FCB1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitTop = 290
    end
    object Label4: TLabel
      Left = 280
      Top = 301
      Width = 47
      Height = 16
      Anchors = [akRight, akBottom]
      Caption = 'Dri&ves:'
      FocusControl = DriveComboBox1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 226
      ExplicitTop = 290
    end
    object FileEdit: TEdit
      Left = 16
      Top = 25
      Width = 249
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      Color = 14347226
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = '*.xls'
      OnChange = FileEditChange
    end
    object FileListBox1: TFileListBox
      Left = 16
      Top = 67
      Width = 251
      Height = 164
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = 14347226
      FileEdit = FileEdit
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      IntegralHeight = True
      ItemHeight = 16
      Mask = '*.xls'
      ParentFont = False
      ShowGlyphs = True
      TabOrder = 1
    end
    object DirectoryListBox1: TDirectoryListBox
      Left = 280
      Top = 67
      Width = 189
      Height = 164
      Anchors = [akTop, akRight, akBottom]
      Color = 14347226
      DirLabel = PathLabel
      FileList = FileListBox1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      IntegralHeight = True
      ItemHeight = 16
      ParentFont = False
      TabOrder = 2
      ExplicitLeft = 225
      ExplicitHeight = 132
    end
    object FCB1: TFilterComboBox
      Left = 19
      Top = 323
      Width = 199
      Height = 23
      Anchors = [akLeft, akBottom]
      Color = 14347226
      FileList = FileListBox1
      Filter = 
        'Excel (*.xls)|*.xls|Tab Delimited Text (*.txt)|*.txt|DBase File ' +
        '(*.dbf)|*.dbf|Paradox File (*.db)|*.db|Comma Delim. Text (*.csv)' +
        '|*.csv'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnChange = FCB1Change
      ExplicitTop = 283
    end
    object DriveComboBox1: TDriveComboBox
      Left = 279
      Top = 323
      Width = 164
      Height = 21
      Anchors = [akRight, akBottom]
      Color = 14347226
      DirList = DirectoryListBox1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      ExplicitLeft = 224
      ExplicitTop = 283
    end
  end
  object CancelImport: TButton
    Left = 738
    Top = 482
    Width = 78
    Height = 29
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = CancelImportClick
    ExplicitLeft = 683
    ExplicitTop = 442
  end
  object NoteBox: TListBox
    Left = 329
    Top = 414
    Width = 378
    Height = 153
    TabStop = False
    Anchors = [akLeft, akRight, akBottom]
    Color = clBtnFace
    ExtendedSelect = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    Items.Strings = (
      '  '
      '    Comma Delimited Text'
      ''
      '    Each line of the text file must '
      '    have a date entry in the form  '
      '    mm/dd/yy followed by a '
      '    comma and then a loadings '
      '    entry in the appropriate units.')
    ParentFont = False
    TabOrder = 1
    Visible = False
  end
  object Panel2: TPanel
    Left = 8
    Top = 8
    Width = 308
    Height = 220
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'Panel2'
    ParentBackground = False
    TabOrder = 2
    DesignSize = (
      308
      220)
    object ODLaBEL: TLabel
      Left = 24
      Top = 11
      Width = 259
      Height = 16
      Caption = 'Observed Data Series Currently Attached'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ObsSeriesList: TListBox
      Left = 24
      Top = 33
      Width = 259
      Height = 139
      Anchors = [akLeft, akTop, akBottom]
      Color = 14347226
      ItemHeight = 13
      TabOrder = 0
      OnClick = ObsSeriesListClick
    end
    object AddButton: TButton
      Left = 34
      Top = 183
      Width = 60
      Height = 26
      Hint = 'Add state variables'
      Anchors = [akLeft, akBottom]
      Caption = '&Add'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = False
      OnClick = AddButtonClick
      ExplicitTop = 204
    end
    object DeleteButton: TButton
      Left = 113
      Top = 183
      Width = 61
      Height = 26
      Hint = 'Delete state variables'
      Anchors = [akLeft, akBottom]
      Caption = '&Delete'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      TabStop = False
      OnClick = DeleteButtonClick
    end
    object SaveAllButton: TButton
      Left = 194
      Top = 174
      Width = 92
      Height = 19
      Hint = 'Add state variables'
      Anchors = [akLeft, akBottom]
      Caption = 'Save All'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      TabStop = False
      OnClick = SaveAllButtonClick
    end
    object LoadAllButton: TButton
      Left = 194
      Top = 196
      Width = 92
      Height = 19
      Hint = 'Add state variables'
      Anchors = [akLeft, akBottom]
      Caption = 'Add From File'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      TabStop = False
      OnClick = LoadAllButtonClick
    end
  end
  object Panel3: TPanel
    Left = 8
    Top = 240
    Width = 308
    Height = 327
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    BorderStyle = bsSingle
    ParentBackground = False
    TabOrder = 3
    DesignSize = (
      304
      323)
    object Label5: TLabel
      Left = 75
      Top = 7
      Width = 137
      Height = 16
      Caption = 'Series Characteristics'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 100
      Top = 31
      Width = 73
      Height = 15
      Alignment = taRightJustify
      Caption = 'Series Name'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 83
      Top = 174
      Width = 121
      Height = 15
      Caption = 'Series in Hypolimnion'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 105
      Top = 74
      Width = 68
      Height = 15
      Alignment = taRightJustify
      Caption = 'Series Units'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label11: TLabel
      Left = 46
      Top = 151
      Width = 158
      Height = 15
      Caption = 'Series includes Non-Detects'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 59
      Top = 130
      Width = 145
      Height = 15
      Caption = 'Series includes Error Bars'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 78
      Top = 211
      Width = 118
      Height = 15
      Alignment = taRightJustify
      Caption = 'Reference, Comment'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object SeriesNameEdit: TEdit
      Left = 27
      Top = 49
      Width = 151
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = 14347226
      TabOrder = 0
      OnChange = SeriesNameEditChange
      ExplicitWidth = 163
    end
    object HypCB: TCheckBox
      Left = 219
      Top = 173
      Width = 15
      Height = 17
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = HypCBClick
    end
    object SeriesUnitEdit: TEdit
      Left = 27
      Top = 92
      Width = 151
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Color = 14347226
      TabOrder = 1
      OnChange = SeriesUnitEditChange
      ExplicitWidth = 163
    end
    object NDCB: TCheckBox
      Left = 219
      Top = 152
      Width = 15
      Height = 17
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = NDCBClick
    end
    object ErrorBarCB: TCheckBox
      Left = 219
      Top = 131
      Width = 15
      Height = 17
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = ErrorBarCBClick
    end
    object CommentEdit: TMemo
      Left = 27
      Top = 228
      Width = 151
      Height = 51
      Anchors = [akLeft, akTop, akRight]
      Color = 14347226
      MaxLength = 90
      TabOrder = 5
      OnChange = CommentEditChange
      ExplicitWidth = 163
    end
    object ImportButt: TButton
      Left = 98
      Top = 290
      Width = 113
      Height = 27
      Hint = 'Edit initial conditions, loadings, & parameters'
      Caption = 'Import Data'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Pitch = fpFixed
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      TabStop = False
      OnClick = ImportButtClick
    end
  end
  object ImportButton: TButton
    Left = 738
    Top = 518
    Width = 78
    Height = 26
    Anchors = [akRight, akBottom]
    Caption = 'Import'
    Default = True
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    Visible = False
    OnClick = ImportButtonClick
    ExplicitLeft = 683
    ExplicitTop = 478
  end
  object HelpButton: TButton
    Left = 476
    Top = 536
    Width = 78
    Height = 26
    Anchors = [akRight, akBottom]
    Caption = 'Help'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = HelpButtonClick
    ExplicitLeft = 421
    ExplicitTop = 496
  end
  object CancelBtn: TButton
    Left = 569
    Top = 536
    Width = 78
    Height = 26
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = CancelBtnClick
    ExplicitLeft = 514
    ExplicitTop = 496
  end
  object OKBtn: TButton
    Left = 665
    Top = 536
    Width = 78
    Height = 26
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 8
    ExplicitLeft = 610
    ExplicitTop = 496
  end
  object ImpTable: TTable
    TableName = 'Load7.db'
    Left = 726
    Top = 65
  end
  object DataSource1: TDataSource
    DataSet = ImpTable
    Left = 726
    Top = 94
  end
end
