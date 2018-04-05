unit uDefinitions;

interface

uses
  classes;

type
  TZValues = array[1..300] of Extended;

  TPhotoperiod = class(TCollectionItem)
  public
    fStartAtDay: integer;  //t1, t2, ...
    fPhotoperiod: double;  //P1, P2, ...
    fAgeFirstEgg: double;  //age at first egg for this photoperiod.  A1, A2, ...
    fVar_p: double;  //proportion which is sensitive to an increase in photoperiod. p1, p2, ...
    fVar_m: double;  //proportion which will mature under the influence of the initial photoperiod. m1, m2, ...
    fSlopeCoeff: double;  //b, b1, b2
    fMeanPP: double;  //mean photoperiod; M, M2, M3, ...
    fChangeInPP: double;  //change in photoperiod; C, C, C3, ...
    fVar_f: double;  //physiological age
    fOrdinate: double;
  end;


implementation

end.
