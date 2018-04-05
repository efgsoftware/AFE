object frmLGMModel: TfrmLGMModel
  Left = 0
  Top = 0
  Caption = 'Lewis-Gous-Morris Model'
  ClientHeight = 632
  ClientWidth = 637
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 426
    Width = 637
    Height = 6
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 477
    ExplicitWidth = 648
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 637
    Height = 153
    Align = alTop
    Caption = 'Inputs'
    TabOrder = 0
    DesignSize = (
      637
      153)
    object Label1: TLabel
      Left = 112
      Top = 19
      Width = 91
      Height = 13
      Caption = 'Initial Photoperiod:'
    end
    object lblFinalPhotoperiod: TLabel
      Left = 116
      Top = 101
      Width = 87
      Height = 13
      Caption = 'Final Photoperiod:'
      Enabled = False
    end
    object Label3: TLabel
      Left = 50
      Top = 42
      Width = 153
      Height = 13
      Caption = 'Mean body weight at 20 weeks:'
    end
    object lblAgeAtChange: TLabel
      Left = 32
      Top = 125
      Width = 171
      Height = 13
      Caption = 'Age at change to final photoperiod:'
      Enabled = False
    end
    object Bevel1: TBevel
      Left = 3
      Top = 66
      Width = 402
      Height = 9
      Shape = bsTopLine
    end
    object Label2: TLabel
      Left = 266
      Top = 19
      Width = 14
      Height = 13
      Caption = '[h]'
    end
    object Label4: TLabel
      Left = 266
      Top = 42
      Width = 19
      Height = 13
      Caption = '[kg]'
    end
    object lblFPHours: TLabel
      Left = 266
      Top = 101
      Width = 14
      Height = 13
      Caption = '[h]'
    end
    object lblAgeHours: TLabel
      Left = 266
      Top = 125
      Width = 14
      Height = 13
      Caption = '[d]'
    end
    object btnIncMBW: TSpeedButton
      Left = 300
      Top = 39
      Width = 21
      Height = 21
      Hint = 'Increment'
      Caption = '+'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = btnIncMBWMouseDown
      OnMouseUp = btnIncPP1MouseUp
    end
    object btnDecMBW: TSpeedButton
      Left = 325
      Top = 39
      Width = 21
      Height = 21
      Hint = 'Decrement'
      Caption = '-'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = btnDecMBWMouseDown
      OnMouseUp = btnIncPP1MouseUp
    end
    object btnIncPP1: TSpeedButton
      Left = 300
      Top = 16
      Width = 21
      Height = 21
      Hint = 'Increment photo period (Keep pressed!)'
      Caption = '+'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = btnIncPP1MouseDown
      OnMouseUp = btnIncPP1MouseUp
    end
    object btnDecPP1: TSpeedButton
      Left = 325
      Top = 16
      Width = 21
      Height = 21
      Hint = 'Decrement photo period (Keep pressed!)'
      Caption = '-'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = btnDecPP1MouseDown
      OnMouseUp = btnIncPP1MouseUp
    end
    object btnIncPP2: TSpeedButton
      Left = 300
      Top = 98
      Width = 21
      Height = 21
      Hint = 'Increment'
      Caption = '+'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = btnIncPP2MouseDown
      OnMouseUp = btnIncPP1MouseUp
    end
    object btnDecPP2: TSpeedButton
      Left = 324
      Top = 98
      Width = 21
      Height = 21
      Hint = 'Decrement'
      Caption = '-'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = btnDecPP2MouseDown
      OnMouseUp = btnIncPP1MouseUp
    end
    object btnDecDay: TSpeedButton
      Left = 324
      Top = 122
      Width = 21
      Height = 21
      Hint = 'Decrement'
      Caption = '-'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = btnDecDayMouseDown
      OnMouseUp = btnIncPP1MouseUp
    end
    object btnIncDay: TSpeedButton
      Left = 300
      Top = 122
      Width = 21
      Height = 21
      Hint = 'Increment'
      Caption = '+'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = btnIncDayMouseDown
      OnMouseUp = btnIncPP1MouseUp
    end
    object edtInitalPP: TcxCurrencyEdit
      Left = 209
      Top = 16
      EditValue = 8.000000000000000000
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 1
      Properties.DisplayFormat = '0.0'
      TabOrder = 0
      Width = 51
    end
    object edtFinalPP: TcxCurrencyEdit
      Left = 209
      Top = 98
      EditValue = 16.000000000000000000
      Enabled = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 1
      Properties.DisplayFormat = '0.0'
      TabOrder = 3
      Width = 51
    end
    object edtAgeAtChange: TcxCurrencyEdit
      Left = 209
      Top = 122
      EditValue = '140'
      Enabled = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      TabOrder = 4
      Width = 51
    end
    object edtMeanBodyWeight: TcxCurrencyEdit
      Left = 209
      Top = 39
      EditValue = 2.100000000000000000
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 1
      Properties.DisplayFormat = '0.0'
      TabOrder = 1
      Width = 51
    end
    object chkPPChange: TCheckBox
      Left = 82
      Top = 75
      Width = 126
      Height = 17
      Caption = 'Photoperiod changes'
      TabOrder = 2
      OnClick = chkPPChangeClick
    end
    object btnCalc: TButton
      Left = 551
      Top = 14
      Width = 75
      Height = 25
      Action = actCalculate
      Default = True
      TabOrder = 5
    end
    object btnClose: TButton
      Left = 551
      Top = 45
      Width = 75
      Height = 25
      Caption = '&Close'
      ModalResult = 1
      TabOrder = 6
    end
    object edtStepForPP1: TcxCurrencyEdit
      Left = 352
      Top = 16
      Hint = 'Increment/Decrement step'
      EditValue = 0.100000000000000000
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 1
      Properties.DisplayFormat = '0.0'
      ShowHint = True
      TabOrder = 7
      Width = 37
    end
    object edtStepForMBW: TcxCurrencyEdit
      Left = 352
      Top = 39
      Hint = 'Increment/Decrement step'
      EditValue = 0.100000000000000000
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 1
      Properties.DisplayFormat = '0.0'
      ShowHint = True
      TabOrder = 8
      Width = 37
    end
    object edtStepForPP2: TcxCurrencyEdit
      Left = 351
      Top = 98
      Hint = 'Increment/Decrement step'
      EditValue = 0.100000000000000000
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 1
      Properties.DisplayFormat = '0.0'
      ShowHint = True
      TabOrder = 9
      Width = 37
    end
    object edtStepForDay: TcxCurrencyEdit
      Left = 351
      Top = 122
      Hint = 'Increment/Decrement step'
      EditValue = 1.000000000000000000
      ParentShowHint = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      ShowHint = True
      TabOrder = 10
      Width = 37
    end
    object btnSaveChart: TButton
      Left = 551
      Top = 80
      Width = 75
      Height = 25
      Caption = 'Save Chart'
      TabOrder = 11
      OnClick = btnSaveChartClick
    end
    object Button1: TButton
      Left = 551
      Top = 111
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Edit graph'
      TabOrder = 12
      OnClick = Button1Click
    end
  end
  object chartND: TChart
    Left = 0
    Top = 153
    Width = 637
    Height = 273
    BackWall.Brush.Style = bsClear
    Legend.LegendStyle = lsSeries
    Legend.Visible = False
    Title.Text.Strings = (
      'Distribution of ages at first egg')
    BottomAxis.Automatic = False
    BottomAxis.AutomaticMaximum = False
    BottomAxis.AutomaticMinimum = False
    BottomAxis.Maximum = 300.000000000000000000
    BottomAxis.Title.Caption = 'Age in days'
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.Title.Caption = 'Percentage'
    TopAxis.Automatic = False
    TopAxis.AutomaticMinimum = False
    TopAxis.Title.Caption = 'Probability'
    View3D = False
    Align = alTop
    TabOrder = 1
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 0
    object Series1: TLineSeries
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object mmoResult: TMemo
    Left = 0
    Top = 432
    Width = 637
    Height = 200
    Align = alClient
    Constraints.MinHeight = 200
    Constraints.MinWidth = 600
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object ActionList: TActionList
    Left = 476
    Top = 12
    object actCalculate: TAction
      Caption = 'Calculate'
      OnExecute = actCalculateExecute
    end
  end
  object tmrIncDecrement: TTimer
    Enabled = False
    Interval = 250
    OnTimer = tmrIncDecrementTimer
    Left = 476
    Top = 64
  end
  object dlgSavePicture: TSavePictureDialog
    DefaultExt = '*.jpg'
    Title = 'LGM Graph'
    Left = 476
    Top = 112
  end
  object ChartEditor1: TChartEditor
    Chart = chartND
    GalleryHeight = 0
    GalleryWidth = 0
    Height = 0
    Width = 0
    Left = 272
    Top = 367
  end
end
