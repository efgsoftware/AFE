unit cCalculation;

interface

uses
  db, classes, fShowResult, SysUtils, Dialogs, Math, uDefinitions;

type
  TPrediction = class(TObject)
  private
    fPPCol: TCollection;   //Photoperiod collection
    fDefaultAFE: double;   //for selected genotype
    fSensitivityToPPC: double;  //Sensitivity of genotype to change in photoperiod
    fExperimentName: string;
    {output}
    fZValues: TZValues;
    fReport: TStrings;
    fPredictedAFE: double;
    fEarlyMean, fEarlyStdDev, fEarlyFraction: double;
    fLateMean, fLateStdDev, fLateFraction: double;
    function StandardDeviationForAFE(aAFE: double): double;
    procedure ConstantPhotoPeriodCalc;
    procedure ShowResult;
    procedure CalculateAFE_0;
    procedure SingleChangePhotoPeriodCalc;
    procedure MultipleChangesInPhotoperiodCalc;
    function PPItem(aIndex: integer): TPhotoperiod;
    procedure ComputeForPeriod(aPeriod: integer);
    procedure CalculateDistribution;
    procedure WritePPItemsToReport;
    procedure WriteDistributionsToReport;
    procedure SetZValues;
  public
    constructor Create(const aPPDataSet: TDataSet; aDefaultAgeFirstEgg,
      aSensitivityToPPC: double; const aExperimentName: string);
    destructor Destroy; override;
    procedure Calculate;
  end;

implementation

uses
  dmAgeFirstEgg, uMethods;

{ TPrediction }

constructor TPrediction.Create(const aPPDataSet: TDataSet; aDefaultAgeFirstEgg,
  aSensitivityToPPC: double; const aExperimentName: string);
var
  lPhotoperiod: TPhotoperiod;
begin
  fPPCol := TCollection.Create(TPhotoperiod);
  {Populate the collection.}
  with aPPDataSet do
  begin
    First;
    while not Eof do
    begin
      lPhotoperiod := TPhotoperiod.Create(fPPCol);
      lPhotoperiod.fStartAtDay := FieldByName(FLD_START_AT_DAY).AsInteger;
      {17112003: Limit photoperiod to [4..18] hours due to algorithm problems otherwise.}
      lPhotoperiod.fPhotoperiod := Min(MAX_PHOTOPERIOD,
        Max(MIN_PHOTOPERIOD, FieldByName(FLD_PHOTO_PERIOD).AsFloat));
      Next;
    end;
  end;
  fDefaultAFE := aDefaultAgeFirstEgg;
  fSensitivityToPPC := aSensitivityToPPC;
  fExperimentName := aExperimentName;
end;

destructor TPrediction.Destroy;
begin
  fPPCol.Destroy;
  inherited;
end;

function TPrediction.StandardDeviationForAFE(aAFE: double): double;
begin
  Result := 0.0623 *  aAFE;  //Trevor 20.03.2004
end;

procedure TPrediction.CalculateAFE_0;
var
  loPhotoperiod: TPhotoperiod;
begin
  loPhotoperiod := TPhotoperiod(fPPCol.Items[0]);
  if loPhotoperiod.fPhotoperiod <= 10 then
    {Equation 1a}
    loPhotoperiod.fAgeFirstEgg := fDefaultAFE + 4.222 * (10 - loPhotoPeriod.fPhotoperiod)
  else
    {Equation 2a}
    loPhotoperiod.fAgeFirstEgg := fDefaultAFE + 0.285 * (loPhotoPeriod.fPhotoperiod - 10);
end;

function TPrediction.PPItem(aIndex: integer): TPhotoperiod;
begin
  Result := TPhotoperiod(fPPCol.Items[aIndex]);
end;

{------------------------------------------------------------------------------}
procedure TPrediction.Calculate;
begin
  fReport := TStringList.Create;
  with fReport do
  begin
    Add('The Lewis-Morris Model for predicting mean age first egg...:');
    Add('Prediction reference                      : ' + fExperimentName);
    Add(Format('Mean age first egg for selected genotype on constant 10-h photoperiods: %4.1f [days]', [fDefaultAFE]));
    Add(Format('Sensitivity to change in photoperiod (k value): %4.2f', [fSensitivityToPPC]));
    Add('');
  end;
  try
    if fPPCol.Count = 1 then
      ConstantPhotoPeriodCalc
    else if fPPCol.Count = 2 then
      SingleChangePhotoPeriodCalc
    else
      MultipleChangesInPhotoperiodCalc;

    WritePPItemsToReport;
    WriteDistributionsToReport;
    fReport.SaveToFile('Results.txt');
    SetZValues;
    ShowResult
  finally
    fReport.Free;
  end;
end;

procedure TPrediction.SetZValues;
var
  lDay: integer;
begin
  for lDay := 1 to 200 do
  begin
    fZValues[lDay] := ((NormalDistP(fEarlyMean, fEarlyStdDev, lDay) * fEarlyFraction) +
      (NormalDistP(fLateMean, fLateStdDev, lDay) * fLateFraction)) * 100;
  end;
end;

procedure TPrediction.ComputeForPeriod(aPeriod: integer);
var
  lCurr, lPrev, lIndex: integer;
  lStdDev: double;
  lStartAtDay: Extended;
  lVarC, lVarM: Extended;
begin
  lCurr := aPeriod;
  lPrev := aPeriod - 1;
  {For single PP changes the variables M0, C0 and b0 are set.
   For multiple changes, the index starts with 1.}
  if fPPCol.Count = 2 then
    lIndex := lPrev //should by zero
  else
    lIndex := lCurr;
  PPItem(lIndex).fMeanPP := (PPItem(lCurr).fPhotoperiod + PPItem(lPrev).fPhotoperiod) / 2;
  PPItem(lIndex).fChangeInPP := Abs(PPItem(lCurr).fPhotoperiod - PPItem(lPrev).fPhotoperiod);

  lVarC := PPItem(lIndex).fChangeInPP;
  lVarM := PPItem(lIndex).fMeanPP;
  PPItem(lIndex).fSlopeCoeff := fSensitivityToPPC * (0.1338 - 0.22396 * lVarM +
    0.05028 * Sqr(lVarM) - 0.00365 * Power(lVarM, 3) + 0.00008216 * Power(lVarM, 4) +
    0.1496 * lVarC - 0.01884 * Sqr(lVarC) + 0.0009683 * Power(lVarC, 3) -
    0.00001941 * Power(lVarC, 4));
  {The slope coefficient must not be below zero.}
  PPItem(lIndex).fSlopeCoeff := Max(0, PPItem(lIndex).fSlopeCoeff);

  {Compute the physiological age at which the current photoperiod (i>1) was introduced.}
  if lCurr = 1 then
    lStartAtDay := PPItem(lCurr).fStartAtDay
  else
  begin
    lStartAtDay := PPItem(lCurr).fStartAtDay - PPItem(lPrev).fAgeFirstEgg +
      PPItem(lPrev - 1).fAgeFirstEgg;
    PPItem(lCurr).fVar_f := lStartAtDay;
  end;

  {Compute the portion p2 of the flock sensitive to an increase in photoperiod...}
  PPItem(lCurr).fVar_p := NormalDistP(50, 7.4, lStartAtDay);

  {Compute the proportion m2 which will mature under the influence of the initial photoperiod...}
  lStdDev := 9;  //StandardDeviationForAFE(PPItem(lPrev).fAgeFirstEgg);  //V1.2
  {V1.1: introduced a lag of 10 days. V1.2: Modified formula}
  PPItem(lCurr).fVar_m := NormalDistP(PPItem(lPrev).fAgeFirstEgg - 10, lStdDev, lStartAtDay);
  PPItem(lCurr).fOrdinate := NormalZ((lStartAtDay - PPItem(lPrev).fAgeFirstEgg + 10) / 9); //equation 8

  {Compute AFE for this period.}
  if PPItem(lCurr).fPhotoperiod > PPItem(lPrev).fPhotoperiod then  //single increase in PP
    PPItem(lCurr).fAgeFirstEgg := (1 - PPItem(lCurr).fVar_p) * PPItem(lPrev).fAgeFirstEgg +
      PPItem(lCurr).fVar_p * (1 - PPItem(lCurr).fVar_m) * (PPItem(lPrev).fAgeFirstEgg -
        PPItem(lIndex).fSlopeCoeff * (PPItem(lPrev).fAgeFirstEgg - lStartAtDay)) +
      (PPItem(lCurr).fVar_p * PPItem(lCurr).fVar_m * PPItem(lPrev).fAgeFirstEgg)  //equation 9
  else  //single decrease in PP
    PPItem(lCurr).fAgeFirstEgg := (1 - PPItem(lCurr).fVar_m) * (PPItem(lPrev).fAgeFirstEgg +
        PPItem(lIndex).fSlopeCoeff * lStartAtDay) +
      (PPItem(lCurr).fVar_m * PPItem(lPrev).fAgeFirstEgg);  //equation 10
end;


procedure TPrediction.ConstantPhotoPeriodCalc;
begin
  CalculateAFE_0;
  fPredictedAFE := PPItem(0).fAgeFirstEgg;
  fEarlyFraction := 1;
  fEarlyMean := fPredictedAFE;
  fEarlyStdDev := StandardDeviationForAFE(fPredictedAFE);
  fLateFraction := 0;
  fLateMean := 0;
  fLateStdDev := 1;
end;

procedure TPrediction.SingleChangePhotoPeriodCalc;
begin
  CalculateAFE_0;
  ComputeForPeriod(1);
  fPredictedAFE := PPItem(1).fAgeFirstEgg;
  CalculateDistribution;
end;

procedure TPrediction.MultipleChangesInPhotoperiodCalc;
var
  i, lLastIndex: integer;
begin
  lLastIndex := fPPCol.Count - 1;
  CalculateAFE_0;
  for i := 1 to lLastIndex do
    ComputeForPeriod(i);
  fPredictedAFE := PPItem(lLastIndex).fAgeFirstEgg;
  CalculateDistribution;
end;

procedure TPrediction.CalculateDistribution;
var
  i: integer;
  lStartAtDay: double;
begin
  i := fPPCol.Count - 1;
  if i = 1 then
    lStartAtDay := PPItem(i).fStartAtDay
  else
    lStartAtDay := PPItem(i).fVar_f;

  if PPItem(i).fPhotoperiod > PPItem(i-1).fPhotoperiod then  //[C2]
  begin  //increase in following photoperiod
    {Check whether a bimodal distribution exists.}
    if ((PPItem(i).fVar_p < 0.02) or (PPItem(i).fVar_p > 0.98)) and
       ((PPItem(i).fVar_m < 0.02) or (PPItem(i).fVar_m > 0.98)) then
    begin  //no bimodal distribution
      fEarlyFraction := 1;
      fEarlyMean   := PPItem(i).fAgeFirstEgg;  //05032004: changed index from i-1 to i only;
      fEarlyStdDev := StandardDeviationForAFE(PPItem(i).fAgeFirstEgg); //05032004: same as above
      fLateFraction := 0;
      fLateMean    := 0;
      fLateStdDev  := 1;
    end
    else if (PPItem(i).fVar_p > 0.02) and (PPItem(i).fVar_p < 0.98) then  //{equation 13}
    begin  //There is a bimodal distribution.
      fEarlyFraction := PPItem(i).fVar_p;
      fEarlyMean   := PPItem(i-1).fAgeFirstEgg - PPItem(i-1).fSlopeCoeff *
        (PPItem(i-1).fAgeFirstEgg - lStartAtDay);
      fEarlyStdDev := StandardDeviationForAFE(fEarlyMean);
      fLateFraction := 1 - fEarlyFraction;
      fLateMean    := PPItem(i-1).fAgeFirstEgg;
      fLateStdDev  := StandardDeviationForAFE(PPItem(i-1).fAgeFirstEgg);
    end
    else if (PPItem(i).fVar_m > 0.02) and (PPItem(i).fVar_m < 0.98) then  //{equation 15}
    begin
      fEarlyFraction := 1- PPItem(i).fVar_m;
      fEarlyMean   := (1 + (0.0623 * PPItem(i).fOrdinate / (1 - PPItem(i).fVar_m))) *
        PPItem(i-1).fAgeFirstEgg -
        PPItem(i-1).fSlopeCoeff * (PPItem(i-1).fAgeFirstEgg - lStartAtDay);
      fEarlyStdDev := StandardDeviationForAFE(fEarlyMean);
      fLateFraction := 1 - fEarlyFraction;
      fLateMean    := (1 - (0.0623 * PPItem(i).fOrdinate / PPItem(i).fVar_m)) *
        PPItem(i-1).fAgeFirstEgg;
      fLateStdDev := StandardDeviationForAFE(fLateMean);
    end;
  end
  else
  begin  //reduction in following photoperiod  [C1]
    if (PPItem(i).fVar_m < 0.02) or (PPItem(i).fVar_m > 0.98) then
    begin  //simple distribution
      fEarlyFraction := 1;
      fEarlyMean   := PPItem(i).fAgeFirstEgg;
      fEarlyStdDev := StandardDeviationForAFE(PPItem(i).fAgeFirstEgg);
      fLateFraction := 0 ;
      fLateMean    := 0;
      fLateStdDev  := 1;
    end
    else
    begin  //There is a bimodal distribution. {equation 11n}
      fEarlyFraction := PPItem(i).fVar_m;
      fEarlyMean   := (1 - (0.09 * PPItem(i).fOrdinate / PPItem(i).fVar_m)) *
        PPItem(i-1).fAgeFirstEgg;
      fEarlyStdDev := StandardDeviationForAFE(fEarlyMean);
      fLateFraction := 1 - fEarlyFraction;
      fLateMean    := (1 + (0.09 * PPItem(i).fOrdinate / (1 - PPItem(i).fVar_m))) *
        PPItem(i-1).fAgeFirstEgg + (PPItem(i-1).fSlopeCoeff * lStartAtDay);
      fLateStdDev  := StandardDeviationForAFE(fLateMean);
    end;
  end;
end;

procedure TPrediction.ShowResult;
begin
  with TfrmShowResult.Create(nil) do
  try
    GraphTitle := 'Distribution of ages at first egg  -  ' + fExperimentName;
    PredictionName := fExperimentName;
    DefaultAFE := fDefaultAFE;
    SensitivityToPPC := fSensitivityToPPC;
    ZValues := fZValues;
    PhotoperiodCol := fPPCol;
    StandardDeviation_1 := fEarlyStdDev;
    MeanValue_1 := fEarlyMean;
    Fraction_1 := fEarlyFraction;
    StandardDeviation_2 := fLateStdDev;
    MeanValue_2 := fLateMean;
    Fraction_2 := fLateFraction;
    ShowModal;
  finally
    Release;
  end;
end;

procedure TPrediction.WritePPItemsToReport;
var
  i: integer;
begin
  fReport.Add('Index  Day   PP      AFE       p       m       b  MeanPP  Change      f  Ordinate');
  for i := 0 to fPPCol.Count - 1 do
  with PPItem(i) do
  begin
    fReport.Add(Format('%5d %4d %5.1f %8.1f %7.3f %7.3f %7.3f %7.1f %7.1f %6.1f %7.3f',
      [i + 1, fStartAtDay, fPhotoperiod,
       fAgeFirstEgg, fVar_p, fVar_m,
       fSlopeCoeff, fMeanPP, fChangeInPP, fVar_f, fOrdinate]));
  end;
end;

procedure TPrediction.WriteDistributionsToReport;
begin
  with fReport do
  begin
    Add('');
    Add('--- Distributions ---');
    if fEarlyFraction > 0.999 then
    begin
      Add(Format('Mean   : %8.3f', [fEarlyMean]));
      Add(Format('StdDev : %8.3f', [fEarlyStdDev]));
    end
    else
    begin
      Add(Format('Responder fraction     : %8.3f', [fEarlyFraction]));
      Add(Format('Responder mean         : %8.3f', [fEarlyMean]));
      Add(Format('Responder StdDev       : %8.3f', [fEarlyStdDev]));
    end;
    if fLateFraction > 0.01 then
    begin
      Add(Format('Non-responder fraction : %8.3f', [fLateFraction]));
      Add(Format('Non-responder mean     : %8.3f', [fLateMean]));
      Add(Format('Non-responder StdDev   : %8.3f', [fLateStdDev]));
    end;
  end;
end;

end.
