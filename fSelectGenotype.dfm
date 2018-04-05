object frmSelectGenotype: TfrmSelectGenotype
  Left = 0
  Top = 0
  Caption = 'Genotypes'
  ClientHeight = 495
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 454
    Width = 520
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnOK: TButton
      Left = 21
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 105
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 520
    Height = 454
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    DesignSize = (
      520
      454)
    object Label1: TLabel
      Left = 13
      Top = 16
      Width = 125
      Height = 13
      Caption = 'Please select a Genotype!'
    end
    object Label2: TLabel
      Left = 13
      Top = 400
      Width = 389
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 
        'Press INSERT to add a new record or CTRL+DELETE to remove the se' +
        'lected one.'
    end
    object Label3: TLabel
      Left = 13
      Top = 419
      Width = 321
      Height = 13
      Caption = 
        'You can also edit a value by clicking in the cell and starting t' +
        'o type.'
    end
    object grdGenotypes: TcxGrid
      Left = 13
      Top = 35
      Width = 492
      Height = 350
      Hint = 
        'Select a genotype|Press "Insert" to add; press Ctrl+Del to remov' +
        'e a genotype.'
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      object grdGenotypesTV: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = dtmAgeFirstEgg.dsrGenotypes
        DataController.Filter.MaxValueListCount = 1000
        DataController.KeyFieldNames = 'Genotype'
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        Filtering.ColumnPopupMaxDropDownItemCount = 12
        OptionsBehavior.FocusCellOnTab = True
        OptionsCustomize.ColumnHorzSizing = False
        OptionsCustomize.ColumnMoving = False
        OptionsSelection.HideFocusRectOnExit = False
        OptionsSelection.InvertSelect = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.GroupFooters = gfVisibleWhenExpanded
        Preview.AutoHeight = False
        Preview.MaxLineCount = 2
        object grdGenotypesTVGenotype: TcxGridDBColumn
          DataBinding.FieldName = 'Genotype'
          PropertiesClassName = 'TcxMaskEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.MaxLength = 0
          Options.Filtering = False
          Width = 150
        end
        object grdGenotypesTVMeanAFE: TcxGridDBColumn
          DataBinding.FieldName = 'MeanAFE'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.OnButtonClick = grdGenotypesTVMeanAFEPropertiesButtonClick
          Options.Filtering = False
          Width = 60
        end
        object grdGenotypesTVSensitivity: TcxGridDBColumn
          DataBinding.FieldName = 'Sensitivity'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.MaxLength = 0
          Options.Filtering = False
          Width = 53
        end
      end
      object grdGenotypesLevel1: TcxGridLevel
        GridView = grdGenotypesTV
      end
    end
  end
end
