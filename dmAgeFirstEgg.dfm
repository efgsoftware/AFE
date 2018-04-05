object dtmAgeFirstEgg: TdtmAgeFirstEgg
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 598
  Width = 696
  object cdsGenotypes: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Genotype'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'MeanAFE'
        DataType = ftBCD
        Precision = 9
        Size = 1
      end
      item
        Name = 'Sensitivity'
        DataType = ftBCD
        Precision = 9
        Size = 3
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 40
    Top = 20
  end
  object dsrGenotypes: TDataSource
    DataSet = cdsGenotypes
    Left = 40
    Top = 72
  end
  object cdsPhotoperiods: TClientDataSet
    Aggregates = <>
    AutoCalcFields = False
    FieldDefs = <
      item
        Name = 'StartAtDay'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'PhotoPeriod'
        Attributes = [faRequired]
        DataType = ftFloat
      end>
    IndexDefs = <
      item
        Name = 'DEFAULT_ORDER'
      end
      item
        Name = 'CHANGEINDEX'
      end
      item
        Name = 'ixStartAtDay'
        Fields = 'StartAtDay'
        Options = [ixPrimary, ixUnique]
      end>
    IndexName = 'ixStartAtDay'
    Params = <>
    StoreDefs = True
    Left = 136
    Top = 20
  end
  object dsrPhotoperiods: TDataSource
    DataSet = cdsPhotoperiods
    Left = 136
    Top = 72
  end
  object cdsExperiments: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Name'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Date'
        DataType = ftDateTime
      end
      item
        Name = 'GtName'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'GtMeanAFE'
        DataType = ftFloat
      end
      item
        Name = 'GtSensitivity'
        DataType = ftFloat
      end
      item
        Name = 'Photoperiods'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 236
    Top = 20
  end
  object dsrExperiments: TDataSource
    DataSet = cdsExperiments
    Left = 236
    Top = 72
  end
end
