object frmDefineGT: TfrmDefineGT
  Left = 363
  Top = 207
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Define Genotype'
  ClientHeight = 399
  ClientWidth = 523
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 4
    Top = 4
    Width = 513
    Height = 353
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 40
    Top = 196
    Width = 106
    Height = 13
    Caption = 'Mean age at first egg :'
  end
  object Label2: TLabel
    Left = 40
    Top = 228
    Width = 105
    Height = 13
    Caption = 'Constant Photoperiod:'
  end
  object Label3: TLabel
    Left = 40
    Top = 300
    Width = 171
    Height = 13
    Caption = 'Mean age at first egg  for a 10h day:'
  end
  object Label4: TLabel
    Left = 296
    Top = 300
    Width = 22
    Height = 13
    Caption = 'days'
  end
  object Label5: TLabel
    Left = 292
    Top = 196
    Width = 22
    Height = 13
    Caption = 'days'
  end
  object Label6: TLabel
    Left = 292
    Top = 228
    Width = 26
    Height = 13
    Caption = 'hours'
  end
  object btnClose: TButton
    Left = 440
    Top = 368
    Width = 75
    Height = 25
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 12
    Top = 12
    Width = 501
    Height = 161
    TabStop = False
    Color = clBtnFace
    Lines.Strings = (
      
        'If you know the age at first egg for your genotype when reared o' +
        'n a constant photoperiod, but not for a '
      
        '10h day, enter the constant photoperiod for which you do have da' +
        'ta and the resulting mean age at '
      
        'first egg.  Age at 50% lay can serve as an estimate of mean age ' +
        'at first egg.'
      
        'Enter the computed age at first egg for this genotype in the tab' +
        'le. (To insert a new record press "Insert".)'
      ''
      
        'If you have no idea how your genotype matures when reared on a c' +
        'onstant photoperiod, enter a default '
      
        'value of 130 days.  The program cannot then give accurate result' +
        's for mean age at first egg, but can '
      
        'predict expected differences in maturity for two or more contras' +
        'ting lighting programmes.'
      ''
      
        'If you don'#39't know the sensitivity of this genotype to changes in' +
        ' photoperiod (relative to ISABROWN), '
      'enter a default value of 1. ')
    ReadOnly = True
    TabOrder = 3
  end
  object edtMeanAFE: TcxMaskEdit
    Left = 220
    Top = 192
    Properties.Alignment.Horz = taRightJustify
    Properties.MaskKind = emkRegExpr
    Properties.EditMask = '\d+'
    Properties.MaxLength = 0
    TabOrder = 2
    Text = '130'
    Width = 65
  end
  object edtMeanAFE_10: TcxTextEdit
    Left = 220
    Top = 296
    Properties.Alignment.Horz = taRightJustify
    Properties.ReadOnly = True
    Style.Color = clBtnFace
    TabOrder = 0
    Text = '0'
    Width = 65
  end
  object edtPhotoperiod: TcxCurrencyEdit
    Left = 220
    Top = 224
    EditValue = '10'
    Properties.Alignment.Horz = taRightJustify
    Properties.DecimalPlaces = 1
    Properties.DisplayFormat = '0.0'
    TabOrder = 4
    Width = 65
  end
  object btnCompute: TcxButton
    Left = 40
    Top = 260
    Width = 75
    Height = 25
    Caption = 'Compute'
    TabOrder = 5
    OnClick = btnComputeClick
  end
end
