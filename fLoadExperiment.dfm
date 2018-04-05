object frmLoadExperiment: TfrmLoadExperiment
  Left = 364
  Top = 241
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Load Prediction'
  ClientHeight = 429
  ClientWidth = 763
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object grdExperiments: TcxGrid
    Left = 0
    Top = 0
    Width = 763
    Height = 388
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    object grdExperimentsTV: TcxGridDBTableView
      OnDblClick = grdExperimentsTVDblClick
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dtmAgeFirstEgg.dsrExperiments
      DataController.Filter.MaxValueListCount = 1000
      DataController.KeyFieldNames = 'Name'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Filtering.ColumnPopup.MaxDropDownItemCount = 12
      OptionsBehavior.FocusCellOnTab = True
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsSelection.HideFocusRectOnExit = False
      OptionsSelection.InvertSelect = False
      OptionsView.GroupByBox = False
      OptionsView.GroupFooters = gfVisibleWhenExpanded
      Preview.AutoHeight = False
      Preview.MaxLineCount = 2
      object grdExperimentsTVName1: TcxGridDBColumn
        DataBinding.FieldName = 'Name'
        PropertiesClassName = 'TcxMaskEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.MaxLength = 0
        Properties.ReadOnly = True
        Options.Filtering = False
        Width = 304
      end
      object grdExperimentsTVDate1: TcxGridDBColumn
        DataBinding.FieldName = 'Date'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.DateButtons = [btnClear, btnToday]
        Properties.DateOnError = deToday
        Properties.InputKind = ikRegExpr
        Options.Filtering = False
        SortIndex = 0
        SortOrder = soAscending
        Width = 135
      end
      object grdExperimentsTVGtName1: TcxGridDBColumn
        DataBinding.FieldName = 'GtName'
        PropertiesClassName = 'TcxMaskEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.MaxLength = 0
        Properties.ReadOnly = True
        Options.Filtering = False
        Width = 304
      end
      object grdExperimentsTVGtMeanAFE1: TcxGridDBColumn
        DataBinding.FieldName = 'GtMeanAFE'
        PropertiesClassName = 'TcxMaskEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.MaxLength = 0
        Properties.ReadOnly = True
        Options.Filtering = False
      end
      object grdExperimentsTVGtSensitivity1: TcxGridDBColumn
        DataBinding.FieldName = 'GtSensitivity'
        PropertiesClassName = 'TcxMaskEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.MaxLength = 0
        Properties.ReadOnly = True
        Options.Filtering = False
      end
      object grdExperimentsTVPhotoperiods1: TcxGridDBColumn
        DataBinding.FieldName = 'Photoperiods'
        PropertiesClassName = 'TcxMaskEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.MaxLength = 0
        Properties.ReadOnly = True
        Options.Filtering = False
        Width = 604
      end
    end
    object grdExperimentsLevel1: TcxGridLevel
      GridView = grdExperimentsTV
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 388
    Width = 763
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      763
      41)
    object btnLoad: TButton
      Left = 12
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Load'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnDelete: TButton
      Left = 196
      Top = 8
      Width = 101
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Delete Prediction'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
  end
end
