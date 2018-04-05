unit cPredictLGM;

interface

uses
  db, classes, fShowResult, SysUtils, Dialogs, Math, uDefinitions, uMethods;

type
  TPredictLGM = class(TObject)
  private
    fInitialPhotoperiod: double;
    fFinalPhotoperiod: double;
    fAgeAtChange: integer;
    fMeanBodyWeightAt20Weeks: double;
    fPPIsConstant: Boolean;
    fZValues: TZValues;
    fReport: TStrings;
    fEarlyMean, fEarlyStdDev, fEarlyFraction: double;
    fLateMean, fLateStdDev, fLateFraction: double;
    function CalcAForPPBetween10And13(aPhotoperiod, aBodyWeight: double): double;
    function CalcAForPPGE13(aPhotoperiod, aBodyWeight: double): double;
    function CalcAForPPLE10(aPhotoperiod, aBodyWeight: double): double;
    procedure CalcForConstantPP;
    procedure CalcForChangingPP;
    procedure SetZValues;
    function CalculateAFE(aPhotoperiod: double): double;
    function StandardDeviationForAFE(aAFE: double): double;
    procedure WriteDistributionsToReport;
    procedure WriteItemsToReport;
    //fDefaultAFE: double;   //for selected genotype
    //fSensitivityToPPC: double;  //Sensitivity of genotype to change in photoperiod
    //fExperimentName: string;
  public
    constructor Create(aInitialPhotoperiod,
      aFinalPhotoperiod, aMeanBodyWeightAt20Weeks: double;
      aAgeAtChange: integer; aPPIsConstant: Boolean);
    destructor Destroy; override;
    procedure Calculate;

    property ZValues: TZValues  read fZValues;
    property ReportStrings: TStrings  read fReport;
  end;

implementation

{ TPredictLGM }

constructor TPredictLGM.Create(aInitialPhotoperiod, aFinalPhotoperiod,
  aMeanBodyWeightAt20Weeks: double; aAgeAtChange: integer;
  aPPIsConstant: Boolean);
begin
  fInitialPhotoperiod := aInitialPhotoperiod;
  fFinalPhotoperiod := aFinalPhotoperiod;
  fAgeAtChange := aAgeAtChange;
  fMeanBodyWeightAt20Weeks := aMeanBodyWeightAt20Weeks;
  fPPIsConstant := aPPIsConstant;

  fReport := TStringList.Create;
  fReport.Add('The Lewis-Gous-Morris Model for predicting mean age at 50% rate of lay and at first egg ...:');
  fReport.Add('');
end;

destructor TPredictLGM.Destroy;
begin
  fReport.Free;
  inherited;
end;


procedure TPredictLGM.Calculate;
begin
  try
    if fPPIsConstant then
      CalcForConstantPP
    else
      CalcForChangingPP;

    SetZValues;
    WriteItemsToReport;
    WriteDistributionsToReport;
  except
    on E:Exception do
    begin
      ShowMessage('Error in calculation: ' + E.Message);
    end;
  end;
end;

procedure TPredictLGM.CalcForConstantPP;
var
  lAFE: double;
begin
  lAFE := CalculateAFE(fInitialPhotoperiod);
  fEarlyFraction := 1;
  fEarlyMean   := lAFE;
  fEarlyStdDev := StandardDeviationForAFE(lAFE);
  fLateFraction := 0;
  fLateMean    := 0;
  fLateStdDev  := 1;
end;

function TPredictLGM.CalculateAFE(aPhotoperiod: double): double;
begin
  if aPhotoperiod <= 10 then
    Result := CalcAForPPLE10(aPhotoperiod, fMeanBodyWeightAt20Weeks)
  else if aPhotoperiod >= 13 then
    Result := CalcAForPPGE13(aPhotoperiod, fMeanBodyWeightAt20Weeks)
  else
    Result := CalcAForPPBetween10And13(aPhotoperiod, fMeanBodyWeightAt20Weeks);
end;

function TPredictLGM.CalcAForPPLE10(aPhotoperiod, aBodyWeight: double): double;
begin
  Result := 208.6 - (1.18 * aPhotoperiod) - (20 * (aBodyWeight - 2.1));
end;

function TPredictLGM.CalcAForPPGE13(aPhotoperiod, aBodyWeight: double): double;
begin
  Result := 231.4 - (0.78 * aPhotoperiod) - (20 * (aBodyWeight - 2.1));
end;

function TPredictLGM.CalcAForPPBetween10And13(aPhotoperiod, aBodyWeight: double): double;
const
  lcMean = 11.5;
  lcStdDev = 0.43;
begin
  Result := CalcAForPPLE10(10, aBodyWeight) +
    (NormalDistP(lcMean, lcStdDev, aPhotoperiod) *
     (CalcAForPPGE13(13, aBodyWeight) - CalcAForPPLE10(10, aBodyWeight)));
end;

procedure TPredictLGM.CalcForChangingPP;
var
  lMeanPP, lVar_C: double;
  lMean, lStdDev, lDeviate: double;
  lVar_k, lVar_b, lVar_p, lVar_m, lOrdinate, lAFE_1, lAFE_2, lAFE_3,
  lAFE_4, lAFE_5: double;
begin
  lAFE_2 := CalculateAFE(fFinalPhotoperiod);

  lMeanPP := (fInitialPhotoperiod + fFinalPhotoperiod) / 2;  {7}
  lVar_C := Abs(fInitialPhotoperiod - fFinalPhotoperiod);  {8}
  lVar_k := -0.449 + (0.155 * fFinalPhotoperiod) -
            0.00547 * Sqr(fFinalPhotoperiod);  {9}

  { Compute b, the slope coefficient for the regresseion of age at first egg ...}
  lVar_b := lVar_k * (0.1338 - 0.22396 * lMeanPP +
    0.05028 * Sqr(lMeanPP) - 0.00365 * Power(lMeanPP, 3) + 0.00008216 * Power(lMeanPP, 4) +
    0.1496 * lVar_C - 0.01884 * Sqr(lVar_C) + 0.0009683 * Power(lVar_C, 3) -
    0.00001941 * Power(lVar_C, 4));  {10}
  { Ensure that b is greater than zero }
  lVar_b := Max(0, lVar_b);

  { Compute the proportion p2 of the flock sensitive to an increase in photoperiod... }
  lMean := 141.3 - 20.2 * fMeanBodyWeightAt20Weeks;
  lStdDev := 21.3 - 3.88 * fMeanBodyWeightAt20Weeks;
  lVar_p := NormalDistP(lMean, lStdDev, fAgeAtChange);  {11}

  { Compute the proportion m2 which will mature under the influence of the initial photoperiod, ... }
  lAFE_1 := CalculateAFE(fInitialPhotoperiod);
  lStdDev := StandardDeviationForAFE(lAFE_1);
  lVar_m := NormalDistP(lAFE_1 - 10, lStdDev, fAgeAtChange);  {12}

  lDeviate := (fAgeAtChange - lAFE_1 + 10) / (StandardDeviationForAFE(lAFE_1));
  lOrdinate := NormalZ(lDeviate);  {13}

  lAFE_3 := 0;  //HS: Added for initialisation
  lAFE_4 := 0;
  lAFE_5 := 0;  //HS: Added for initialisation

  if ((lVar_p < 0.02) or (lVar_p > 0.98)) and
     ((lVar_m < 0.02) or (lVar_m > 0.98)) then
  begin
    lAFE_3 := lAFE_1 - (lVar_b * (lAFE_1 - fAgeAtChange));
    if lVar_m < 0.0005 then  //HS: Added according to spread sheet
      lAFE_4 := lAFE_2
    else
      lAFE_4 := (1 - (0.059 * lOrdinate/lVar_m)) * lAFE_1;
    lAFE_5 := (1 - lVar_p) * lAFE_2 +
             lVar_p * (1 - lVar_m) *
             ((lAFE_1 - (lVar_b * (lAFE_1 - fAgeAtChange))) +
              (lVar_p * lVar_m * lAFE_1));  //equation 17a; Lydia 2018 added parenthesis in last 2 lines
  end
  else if (lVar_p > 0.02) and (lVar_p < 0.98) then
  begin
    lAFE_3 := lAFE_1 - (lVar_b * (lAFE_1 - fAgeAtChange));
    lAFE_4 := lAfE_2;
    lAFE_5 := (lAFE_3 * lVar_p) + lAFE_4 * (1 - lVar_p);

  end
  else if (lVar_m > 0.02) and (lVar_m < 0.98) then
  begin
    lAFE_3 := (1 + (0.059 * lOrdinate/(1 - lVar_m))) * lAFE_1 -
              (lVar_b * (lAFE_1 - fAgeAtChange));
    lAFE_4 := (1 - (0.059 * lOrdinate/lVar_m)) * lAFE_1;
    lAFE_5 := (lVar_m * lAFE_4) + (1 - lVar_m) * lAFE_3;
  end;

  { Calculate the distribution of ages }
  if ((lVar_p < 0.02) or (lVar_p > 0.98)) and
     ((lVar_m < 0.02) or (lVar_m > 0.98)) then
  begin  //no bimodal distribution
// following lines changed by Lydia 2018; previous values in comments
    fEarlyFraction := 1; //0
    fEarlyMean   := lAFE_1 - lVar_b * (lAFE_1 - fAgeAtChange);//0
    fEarlyStdDev := StandardDeviationForAFE(fEarlyMean); //1
    fLateFraction := 0; //1
    fLateMean    := 0; //lAFE_2
    fLateStdDev  := 1; //StandardDeviationForAFE(lAFE_1)
  end
  else if (lVar_p > 0.02) and (lVar_p < 0.98) then
  begin  //There is a bimodal distribution.   Early = Responders; Late = Non-responders
    fEarlyFraction := lVar_p;
    fEarlyMean   := lAFE_1 - lVar_b * (lAFE_1 - fAgeAtChange);
    fEarlyStdDev := StandardDeviationForAFE(fEarlyMean);
    fLateFraction := 1 - fEarlyFraction;
    fLateMean    := lAFE_2;
    fLateStdDev  := StandardDeviationForAFE(lAFE_2);
  end
  else if (lVar_m > 0.02) and (lVar_m < 0.98) then
  begin
    fEarlyFraction := 1 - lVar_m;
    fEarlyMean   := (1 + (0.059 * lOrdinate / (1 - lVar_m))) *
      lAFE_1 - lVar_b * (lAFE_1 - fAgeAtChange);  //=lAFE_4
    fEarlyStdDev := StandardDeviationForAFE(fEarlyMean);
    fLateFraction := lVar_m;
    fLateMean    := (1 - (0.059 * lOrdinate / lVar_m)) * lAFE_1;  //=lAFE_3
    fLateStdDev := StandardDeviationForAFE(fLateMean);
  end;

  { Report meta results }
  fReport.Add(Format('%6s %6s %6s %6s %9s %8s %8s %8s %8s %8s', ['k', 'b', 'p2', 'm2',
    'Ordinate', 'A1', 'A2', 'A3', 'A4', 'A5']));
  fReport.Add(Format('%6.3f %6.3f %6.3f %6.3f %9.3f %8.3f %8.3f %8.3f %8.3f %8.3f',
    [lVar_k, lVar_b, lVar_p, lVar_m, lOrdinate, lAFE_1, lAFE_2, lAFE_3, lAFE_4, lAFE_5]));

end;

procedure TPredictLGM.SetZValues;
var
  lDay: integer;
begin
  for lDay := 1 to 300 do
  begin
    fZValues[lDay] := ((NormalDistP(fEarlyMean, fEarlyStdDev, lDay) * fEarlyFraction) +
      (NormalDistP(fLateMean, fLateStdDev, lDay) * fLateFraction)) * 100;
  end;
end;

function TPredictLGM.StandardDeviationForAFE(aAFE: double): double;
begin
  Result := 0.059 * aAFE;  //equation 6
end;

procedure TPredictLGM.WriteItemsToReport;
begin
  fReport.Add('Input:');
  fReport.Add(Format('Initial Photo Period: %7.1f [h]', [fInitialPhotoperiod]));
  fReport.Add(Format('Mean Body Weight at 20 weeks: %7.1f [kg]', [fMeanBodyWeightAt20Weeks]));
  if not fPPIsConstant then
  begin
    fReport.Add(Format('Final photo period: %7.1f [h]', [fFinalPhotoperiod]));
    fReport.Add(Format('Age at change to new photoperiod: %3d [d]', [fAgeAtChange]));
  end;
  fReport.Add('');
end;

procedure TPredictLGM.WriteDistributionsToReport;
begin
  with fReport do
  begin
    Add('');
    Add('--- Distributions ---');
    if fEarlyFraction > 0.98 then // was >0.999 changed by Lydia 15/2/2018
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
    if fLateFraction > 0.02 then //was >0.01 changed by Lydia 15/2/2018
    begin
      Add(Format('Non-responder fraction : %8.3f', [fLateFraction]));
      Add(Format('Non-responder mean     : %8.3f', [fLateMean]));
      Add(Format('Non-responder StdDev   : %8.3f', [fLateStdDev]));
    end;
  end;
end;

end.
