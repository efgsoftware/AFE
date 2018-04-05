object frmShowResult: TfrmShowResult
  Left = 290
  Top = 115
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Result'
  ClientHeight = 558
  ClientWidth = 707
  Color = clBtnFace
  Constraints.MinHeight = 500
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    707
    558)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 4
    Top = 4
    Width = 698
    Height = 523
    Anchors = [akLeft, akTop, akRight, akBottom]
    Shape = bsFrame
  end
  object chartND: TChart
    Left = 13
    Top = 12
    Width = 681
    Height = 273
    Legend.LegendStyle = lsSeries
    Legend.Visible = False
    Title.Text.Strings = (
      'Distribution of ages at first egg')
    BottomAxis.Automatic = False
    BottomAxis.AutomaticMaximum = False
    BottomAxis.AutomaticMinimum = False
    BottomAxis.Maximum = 200.000000000000000000
    BottomAxis.Title.Caption = 'Age in days'
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.Title.Caption = 'Percentage'
    TopAxis.Automatic = False
    TopAxis.AutomaticMinimum = False
    TopAxis.Title.Caption = 'Probability'
    View3D = False
    PopupMenu = popChart
    TabOrder = 1
    Anchors = [akLeft, akTop, akRight]
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      33
      15
      33)
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
    Left = 12
    Top = 284
    Width = 681
    Height = 235
    Anchors = [akLeft, akTop, akRight, akBottom]
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
  object btnClose: TButton
    Left = 13
    Top = 530
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Close'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btnSaveText: TButton
    Left = 100
    Top = 530
    Width = 91
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Export to Excel'
    TabOrder = 3
    OnClick = btnSaveTextClick
  end
  object Button1: TButton
    Left = 495
    Top = 530
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Edit graph'
    TabOrder = 4
    OnClick = Button1Click
  end
  object dlgSaveFile: TSaveDialog
    DefaultExt = '.xls'
    Filter = 'Excel files (*.xls)|*.xls'
    Title = 'Save as Excel file'
    Left = 232
    Top = 512
  end
  object ExcelApp: TExcelApplication
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    AutoQuit = False
    Left = 288
    Top = 512
  end
  object ExcelWorkbook: TExcelWorkbook
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    Left = 360
    Top = 512
  end
  object popChart: TPopupMenu
    Left = 444
    Top = 512
    object mnuCopytoClipboard: TMenuItem
      Caption = 'Copy Graph to Clipboard'
      OnClick = mnuCopytoClipboardClick
    end
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
