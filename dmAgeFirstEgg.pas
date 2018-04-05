unit dmAgeFirstEgg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBClient, uMethods, Variants;//, MidasLib;

const
  FLD_PHOTO_PERIOD = 'Photoperiod';
  FLD_START_AT_DAY = 'StartAtDay';
  FIRST_START_DAY = 0;
  MIN_PHOTOPERIOD = 4;
  MAX_PHOTOPERIOD = 24;

type
  TdtmAgeFirstEgg = class(TDataModule)
    cdsGenotypes: TClientDataSet;
    dsrGenotypes: TDataSource;
    cdsPhotoperiods: TClientDataSet;
    dsrPhotoperiods: TDataSource;
    cdsExperiments: TClientDataSet;
    dsrExperiments: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    fAppPath: string;
    function PPAndStartDayHaveValidRange(aPhotoperiod: double;
      aStartDay: integer): Boolean;
    function PhotoperiodDoesNotChange(aPhotoperiod: double;
      aStartDay: integer): Boolean;
  public
    { Public declarations }
    function SelectLastExperiment: Boolean;
    function AddPhotoPeriod(aPhotoperiod: double; aStartDay: integer): Boolean;
    function ModifyPhotoPeriod(aOldPhotoperiod, aNewPhotoperiod: double;
      aOldStartDay, aNewStartDay: integer): Boolean;
    procedure DeleteCurrentPhotoperiod;
    procedure CheckModifiedPhotoperiod(aPhotoPeriod: double; aStartDay: integer);
    procedure AddExperiment(const aName, aGtName, aPhotoperiods: string; aGtMeanAFE,
      aGtSensitivity: double);
    procedure LoadSelectedExperiment(out aExpName, aGTName: string;
      out aGTMeanAFE, aGTSensitivity: double);
    procedure ResetPhotoperiods;
  end;

var
  dtmAgeFirstEgg: TdtmAgeFirstEgg;

implementation

{$R *.DFM}

procedure TdtmAgeFirstEgg.DataModuleCreate(Sender: TObject);
begin
  fAppPath := ExtractFilePath(Application.ExeName);
  with cdsPhotoperiods do
  begin
    Active := False;
    CreateDataSet;
    AppendRecord([FIRST_START_DAY, 12]);
  end;
  {Load or create the dataset Experiments.}
  with cdsExperiments do
  begin
    Active := False;
    FileName := fAppPath + 'Experiments.cds';
    if FileExists(FileName) then
      LoadFromFile
    else
      CreateDataSet;
  end;
  with cdsGenotypes do
  begin
    Active := False;
    FileName := fAppPath + 'Genotypes.cds';
    if FileExists(FileName) then
      LoadFromFile
    else
    begin
      CreateDataSet;
      AppendRecord(['Default', 150, 1]);
    end;
  end;
end;

procedure TdtmAgeFirstEgg.ResetPhotoperiods;
begin
  with cdsPhotoperiods do
  begin
    EmptyDataSet;
    AppendRecord([FIRST_START_DAY, 12]);
  end;
end;


procedure TdtmAgeFirstEgg.AddExperiment(const aName, aGtName, aPhotoperiods: string;
  aGtMeanAFE, aGtSensitivity: double);
begin
  with cdsExperiments do
  begin
    AppendRecord([aName, Now, aGtName, aGtMeanAFE, aGtSensitivity, aPhotoperiods]);
    SaveToFile;
  end;
end;

(*var
  lBookmark: TBookmark;
begin
  lBookmark := DataSet.GetBookmark;
  try
    DataSet.Last;
    fLastStartDay := DataSet.FieldByName(FLD_START_AT_DAY).AsInteger;
    DataSet.GotoBookmark(lBookmark);
  finally
    DataSet.FreeBookmark(lBookmark);
  end;
end;*)

function TdtmAgeFirstEgg.PhotoperiodDoesNotChange(aPhotoperiod: double; aStartDay: integer): Boolean;
var
  lPreviousPP, lNextPP: integer;
begin
  with cdsPhotoperiods do
  try
    DisableControls;
    First;
    if RecordCount = 1 then
    begin
      lPreviousPP := FieldByName(FLD_PHOTO_PERIOD).AsInteger;
      lNextPP := -1;  //impossible value for comparison
    end
    else
    begin
      while not EOF and (FieldByName(FLD_START_AT_DAY).AsInteger < aStartDay) do
      begin
        Next;
      end;
      if EOF then
      begin
        lPreviousPP := FieldByName(FLD_PHOTO_PERIOD).AsInteger;
        lNextPP := -1;  //impossible value for comparison
      end
      else
      begin
        lNextPP := FieldByName(FLD_PHOTO_PERIOD).AsInteger;
        Prior;
        lPreviousPP := FieldByName(FLD_PHOTO_PERIOD).AsInteger;
      end;
    end;  //if RecordCount...
    Result := (aPhotoperiod = lPreviousPP) or (aPhotoperiod = lNextPP);
  finally
    EnableControls;
  end;
end;

function TdtmAgeFirstEgg.AddPhotoPeriod(aPhotoperiod: double; aStartDay: integer): Boolean;
begin
  Result := PPAndStartDayHaveValidRange(aPhotoperiod, aStartDay);
  if not Result then
    Exit;

  if cdsPhotoperiods.Locate(FLD_START_AT_DAY, aStartDay, []) then
  begin
    MessageDlg('Please choose an unique start day.', mtWarning, [mbOK], 0);
    Result := False;
  end
  else if PhotoperiodDoesNotChange(aPhotoperiod, aStartDay) then
  begin
    MessageDlg('Photoperiod does not change for immediate neighbor-record(s).', mtWarning, [mbOK], 0);
    Result := False;
  end
  else
  with cdsPhotoperiods do
  begin
    Append;
    FieldByName(FLD_PHOTO_PERIOD).AsFloat := aPhotoperiod;
    FieldByName(FLD_START_AT_DAY).AsInteger := aStartDay;
    Post;
  end;
end;

function TdtmAgeFirstEgg.ModifyPhotoPeriod(aOldPhotoperiod, aNewPhotoperiod: double;
  aOldStartDay, aNewStartDay: integer): Boolean;
begin
  Result := PPAndStartDayHaveValidRange(aNewPhotoperiod, aNewStartDay);
  if not Result then
    Exit;

  if (aOldStartDay <> aNewStartDay) and
     cdsPhotoperiods.Locate(FLD_START_AT_DAY, aNewStartDay, []) then
  begin
    MessageDlg('Please change to unique start day.', mtWarning, [mbOK], 0);
    Result := False;
  end
  else
  with cdsPhotoperiods do
  begin
    Edit;
    FieldByName(FLD_PHOTO_PERIOD).AsFloat := aNewPhotoperiod;
    FieldByName(FLD_START_AT_DAY).AsInteger := aNewStartDay;
    Post;
  end;
end;

procedure TdtmAgeFirstEgg.DeleteCurrentPhotoperiod;
begin
  if (cdsPhotoperiods.FieldByName(FLD_START_AT_DAY).AsInteger <> FIRST_START_DAY) then
    dtmAgeFirstEgg.cdsPhotoperiods.Delete
  else
    MessageDlg('First record must stay.', mtWarning, [mbOK], 0);
end;

function TdtmAgeFirstEgg.PPAndStartDayHaveValidRange(aPhotoperiod: double;
  aStartDay: integer): Boolean;
begin
  Result := True;
  if (aPhotoperiod < 1) or (aPhotoperiod > 24) then
  begin
    MessageDlg('Photoperiod must be from 1 to 24 hours.', mtWarning, [mbOK], 0);
    Result := False;
  end
  else if (aStartDay < FIRST_START_DAY) or (aStartDay > 200) then
  begin
    MessageDlg('Start day for intermediate photoperiods must be from 1 to 200 hours.', mtWarning, [mbOK], 0);
    Result := False;
  end
end;

procedure TdtmAgeFirstEgg.CheckModifiedPhotoperiod(aPhotoPeriod: double; aStartDay: integer);
var
  lPreviousPP, lNextPP: double;
begin
  with cdsPhotoperiods do
  begin
    if RecordCount = 1 then
      Exit;  //no need to check something;
    DisableControls;
    try
      Locate(Format('%s;%s', [FLD_START_AT_DAY, FLD_PHOTO_PERIOD]),
        VarArrayOf([aStartDay, aPhotoPeriod]), []);
      {move the cursor in order to get the prior and next record.}
      if aStartDay = FIRST_START_DAY then
      begin
        lPreviousPP := -1;
        Next;
        lNextPP := FieldByName(FLD_PHOTO_PERIOD).AsFloat;
        Prior;
      end
      else
      begin
        {Test for Eof}
        Prior;  //should always work at the current record is at least the second one.
        lPreviousPP := FieldByName(FLD_PHOTO_PERIOD).AsInteger;
        MoveBy(2);
        if Eof then
        begin
          lNextPP := -1;
          //Next;
        end
        else
        begin
          lNextPP := FieldByName(FLD_PHOTO_PERIOD).AsFloat;
          Prior;
        end;
      end;

      if (aPhotoperiod = lPreviousPP) or (aPhotoperiod = lNextPP) then
      begin
        MessageDlg('The photoperiod of the modified record is the same as one of the neighbors.',
          mtWarning, [mbOK], 0);
      end;
    finally
      EnableControls;
    end;
  end;  //with cdsPhotoperiods...
end;

procedure TdtmAgeFirstEgg.LoadSelectedExperiment(out aExpName, aGTName: string;
  out aGTMeanAFE, aGTSensitivity: double);
var
  i: integer;
  lStrings: TStrings;
  lPhotoperiods: string;
begin
  cdsPhotoperiods.EmptyDataSet;
  aExpName := cdsExperiments.FieldByName('Name').AsString;
  aGtName := cdsExperiments.FieldByName('GtName').AsString;
  aGtMeanAFE := cdsExperiments.FieldByName('GtMeanAFE').AsFloat;
  aGtSensitivity := cdsExperiments.FieldByName('GtSensitivity').AsFloat;

  cdsPhotoperiods.EmptyDataSet;
  lPhotoperiods := cdsExperiments.FieldByName('Photoperiods').AsString;
  lStrings := TStringList.Create;
  try
    SplitString(lPhotoperiods, '#', lStrings);
    for i := 0 to (lStrings.Count - 1) do
    begin
      if i mod 2 = 0 then
        cdsPhotoperiods.AppendRecord([lStrings[i], lStrings[i+1]]);
    end;
  finally
    lStrings.Free;
  end;
end;

function TdtmAgeFirstEgg.SelectLastExperiment: Boolean;
begin
  with cdsExperiments do
  begin
    Result := not IsEmpty;
    if Result then
    begin
      Last;
    end;
  end;
end;

end.
