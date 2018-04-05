program AgeFirstEgg;

uses
  Forms,
  uMethods in 'uMethods.pas',
  dmAgeFirstEgg in 'dmAgeFirstEgg.pas' {dtmAgeFirstEgg: TDataModule},
  fShowResult in 'fShowResult.pas' {frmShowResult},
  fNewPhotoperiod in 'fNewPhotoperiod.pas' {frmNewPhotoPeriod},
  fDefineGT in 'fDefineGT.pas' {frmDefineGT},
  fLoadExperiment in 'fLoadExperiment.pas' {frmLoadExperiment},
  cCalculation in 'cCalculation.pas',
  fAbout in 'fAbout.pas' {frmAbout},
  fMainAFE in 'fMainAFE.pas' {frmMainAFE},
  uDefinitions in 'uDefinitions.pas',
  fSelectGenotype in 'fSelectGenotype.pas' {frmSelectGenotype},
  fLGMModel in 'fLGMModel.pas' {frmLGMModel},
  cPredictLGM in 'cPredictLGM.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Age at first egg';
  Application.CreateForm(TdtmAgeFirstEgg, dtmAgeFirstEgg);
  Application.CreateForm(TfrmMainAFE, frmMainAFE);
  Application.Run;
end.
