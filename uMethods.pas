unit uMethods;

interface

uses
  SysUtils, Math, Controls, Graphics, db, classes;

function NormalZ (const X: Extended): Extended;
function NormalDistP(const aMean, aStdDev, AVal: Extended): Single;
function DataSetToString(const aDataSet: TDataSet): string;
procedure SplitString(aString, aSeparator: string; out aStringList: TStrings);

implementation

{------------------------------------------------------------------------------}
function NormalZ (const X: Extended): Extended;
{ Returns Z(X) for the Standard Normal Distribution as defined by
  Abramowitz & Stegun. This is the function that defines the Standard
  Normal Distribution Curve.
  Full Accuracy of FPU }
begin
  Result := Exp (- Sqr (X) / 2.0)/Sqrt (2 * Pi);
end;

{------------------------------------------------------------------------------}
function NormalP (const A: Extended): Single;
{Returns P(A) for the Standard Normal Distribution as defined by
  Abramowitz & Stegun. This is the Probability that a value is less
  than A, i.e. Area under the curve defined by NormalZ to the left
  of A.
  Only handles values A >= 0 otherwise exception raised.
  Accuracy: Absolute Error < 7.5e-8 }
const
  B1: Extended = 0.319381530;
  B2: Extended = -0.356563782;
  B3: Extended = 1.781477937;
  B4: Extended = -1.821255978;
  B5: Extended = 1.330274429;
var
  T: Extended;
  T2: Extended;
  T4: Extended;
begin
  if (A < 0) then
    raise EMathError.Create ('Value must be Non-Negative')
  else
  begin
    T := 1 / (1 + 0.2316419 * A);
    T2 := Sqr (T);
    T4 := Sqr (T2);
    Result := 1.0 - NormalZ (A) * (B1 * T + B2 * T2 + B3 * T * T2 + B4 * T4 + B5 * T * T4);
  end;
end;

{------------------------------------------------------------------------------}
function NormalDistP(const aMean, aStdDev, AVal: Extended): Single;
{Returns the Probability of (X < AVal) for a Normal Distribution
  with given aMean and Standard Deviation.
  Standard Deviation must be > 0 or function will result in an exception.
  Accuracy: Absolute Error < 7.5e-8 }
var
  Z: Extended;
  lIsLower: Boolean;
begin
  if (aStdDev < 0.00001) then
    raise EMathError.Create ('Standard Deviation must be positive')
  else
  begin
    Z := (AVal - aMean) / aStdDev; // Convert to Standard (z) value
    lIsLower := Z < 0; // If Negative use Symmetry to calculate
    if lIsLower then
      Z := (aMean - AVal) / aStdDev;
    Result := NormalP (Z); // Access function
    if lIsLower then // If Negative use Symmetry to calculate
      Result := 1.0 - Result;
  end;
end;

{------------------------------------------------------------------------------}
function NormalDistA (const aMean, aStdDev, AVal, BVal: Extended): Single;
{ Returns the Probability of (AVal < X < BVal) for a Normal Distribution
  with given aMean and Standard Deviation.
  Standard Deviation must be > 0 or function will result in an
  exception.
  Accuracy: Absolute Error < 7.5e-8 }
begin
  if AVal = BVal then
    Result := 0
  else
  begin
    Result := NormalDistP (aMean, aStdDev, BVal) -
      NormalDistP (aMean, aStdDev, AVal);
    if BVal < AVal then
      Result := -1 * Result;
  end;
end;

{------------------------------------------------------------------------------}
function DataSetToString(const aDataSet: TDataSet): string;
var
  i, lFieldCount: integer;
begin
  with aDataSet do
  begin
    lFieldCount := FieldCount;
    First;
    while not Eof do
    begin
      for i := 0 to lFieldCount - 1 do
      begin
        Result := Result + '#' + {Fields.}Fields[i].AsString;
      end;
      Next;
    end;
  end;
  {Delete the first separator}
  Delete(Result, 1, 1);
end;

procedure SplitString(aString, aSeparator: string; out aStringList: TStrings);
var
  i: integer;
begin
  aString := aString + aSeparator;  //add a separator for the logic
  while Length(aString) > 0 do
  begin
    i := Pos(aSeparator, aString);
    aStringList.Add(Copy(aString, 1, i - 1));
    Delete(aString, 1, i);
  end;
end;

end.
