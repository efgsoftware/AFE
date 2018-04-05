unit fShowResult;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TeEngine, Series, ExtCtrls, TeeProcs, Chart, uMethods,
  uDefinitions, OleServer, Excel2000, ShellApi, ActiveX, Menus, ExcelXP,
  Variants, VclTee.TeeGDIPlus, VCLTee.TeeEdit;

type
  TfrmShowResult = class(TForm)
    chartND: TChart;
    Series1: TLineSeries;
    mmoResult: TMemo;
    btnClose: TButton;
    Bevel1: TBevel;
    btnSaveText: TButton;
    dlgSaveFile: TSaveDialog;
    ExcelApp: TExcelApplication;
    ExcelWorkbook: TExcelWorkbook;
    popChart: TPopupMenu;
    mnuCopytoClipboard: TMenuItem;
    Button1: TButton;
    ChartEditor1: TChartEditor;
    procedure FormShow(Sender: TObject);
    procedure btnSaveTextClick(Sender: TObject);
    procedure mnuCopyToClipboardClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fStdDev1, fStdDev2: double;
    fMeanValue1, fMeanValue2: double;
    fFraction1, fFraction2: double;
    fDefaultAFE: double;   //for selected genotype
    fSensitivityToPPC: double;  //Sensitivity of genotype to change in photoperiod
    fPredictionName: string;
    fZValues: TZValues;
    fPPCol: TCollection;
    fGraphTitle: string;
    procedure ShowStandardDevGraph;
    procedure ExportToExcel(const aFileName: string);
    { Private declarations }
  public
    { Public declarations }
    property GraphTitle: string  write fGraphTitle;
    property ZValues: TZValues  write fZValues;
    property PhotoperiodCol: TCollection  write fPPCol;
    property StandardDeviation_1: double  write fStdDev1;
    property MeanValue_1: double  read fMeanValue1 write fMeanValue1;
    property Fraction_1: double  read fFraction1 write fFraction1;
    property StandardDeviation_2: double  write fStdDev2;
    property MeanValue_2: double  read fMeanValue2 write fMeanValue2;
    property Fraction_2: double  read fFraction2 write fFraction2;
    property PredictionName: string  write fPredictionName;
    property SensitivityToPPC: double  write fSensitivityToPPC;
    property DefaultAFE: double  write fDefaultAFE;
  end;

var
  frmShowResult: TfrmShowResult;

implementation

{$R *.DFM}

procedure TfrmShowResult.FormShow(Sender: TObject);
begin
  ShowStandardDevGraph;
  with mmoResult.Lines do
  begin
    Clear;
    if FileExists('Results.txt') then
      LoadFromFile('Results.txt');
  end;
  chartND.Title.Text[0] := fGraphTitle;
end;

procedure TfrmShowResult.ShowStandardDevGraph;
var
  lDay: integer;
  lXAxisText: string;
begin
  with chartND.SeriesList do
  begin
    Items[0].Clear;
    for lDay := 1 to 200 do
    begin
      if lDay mod 5 = 0 then
        lXAxisText := IntToStr(lDay)
      else
        lXAxisText := '';
      Items[0].Add(fZValues[lDay], lXAxisText);
    end;
  end;
end;

procedure TfrmShowResult.btnSaveTextClick(Sender: TObject);
begin
  if dlgSaveFile.Execute then
  begin
    ExportToExcel(dlgSaveFile.FileName);
    if FileExists(dlgSaveFile.FileName) then
      MessageDlg('The export to the file ' + dlgSaveFile.FileName +
       ' is done.', mtInformation, [mbOK], 0);
//    if FileExists(dlgSaveFile.FileName) and (MessageDlg('The export to Excel is finished. ' +
//       'Do you want to open the file?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
//      ShellExecute(Handle, 'Open', PChar(dlgSaveFile.FileName), nil, nil, SW_SHOW);
    end;
end;

procedure TfrmShowResult.Button1Click(Sender: TObject);
begin
  ChartEditor1.Execute;
end;

procedure TfrmShowResult.ExportToExcel(const aFileName: string);
var
  i: integer;
  lTemplate, lFileName, lOleTrue: OleVariant;
  lWorkSheet: _WorkSheet;
begin
  Screen.Cursor := crHourGlass;
  lOleTrue := True;
  lFileName := aFileName;
  lTemplate := ExtractFilePath(Application.ExeName) + 'Result.xlt';
  if not FileExists(lTemplate) then
    raise Exception.Create('Template file "' + lTemplate + '" could not be found.');

  ExcelWorkbook.ConnectTo(ExcelApp.Workbooks.Add(lTemplate, 0));
  //ExcelApp.Visible[0] := TRUE;  //for debugging
  try
    {Write to the display sheet}
    lWorkSheet := ExcelWorkbook.Worksheets[1] as _WorkSheet;
    lWorkSheet.Select(EmptyParam, 0);
    with ExcelApp.Cells do
    begin
      Item[4, 4].Value := fPredictionName;
      Item[6, 8].Value := Format('%8.1f', [fDefaultAFE]);
      Item[7, 8].Value := Format('%8.3f', [fSensitivityToPPC]);
      Item[28, 6].Value := Format('%8.1f', [fFraction1 * 100]);
      Item[29, 6].Value := Format('%8.3f', [fMeanValue1]);
      Item[30, 6].Value := Format('%8.3f', [fStdDev1]);
      Item[32, 6].Value := Format('%8.1f', [fFraction2 * 100]);
      Item[33, 6].Value := Format('%8.3f', [fMeanValue2]);
      Item[34, 6].Value := Format('%8.3f', [fStdDev2]);
      {Write the matrix}
      for i := 0 to fPPCol.Count - 1 do
      with TPhotoperiod(fPPCol.Items[i]) do
      begin
        Item[38 + i, 1].Value := i + 1;
        Item[38 + i, 2].Value := fStartAtDay;
        Item[38 + i, 3].Value := fPhotoperiod;
        Item[38 + i, 4].Value := Format('%8.1f', [fAgeFirstEgg]);
        Item[38 + i, 5].Value := Format('%7.3f', [fVar_p]);
        Item[38 + i, 6].Value := Format('%7.3f', [fVar_m]);
        Item[38 + i, 7].Value := Format('%7.3f', [fSlopeCoeff]);
        Item[38 + i, 8].Value := Format('%7.1f', [fMeanPP]);
        Item[38 + i, 9].Value := Format('%7.1f', [fChangeInPP]);
        Item[38 + i,10].Value := Format('%7.1f', [fVar_f]);
      end;
    end;
    {Delete Non-responder cells}
    if fFraction2 = 0 then
    with ExcelApp.Cells do
    begin
      Item[32, 1].EntireRow.Delete;
      Item[32, 1].EntireRow.Delete;
      Item[32, 1].EntireRow.Delete;
      Item[32, 1].EntireRow.Delete;
      Item[28, 1].Value := 'Distribution details';
    end;

    {Write the data for the graph}
    lWorkSheet := ExcelWorkbook.Worksheets[2] as _WorkSheet;
    lWorkSheet.Select(EmptyParam, 0);
    for i := 1 to 200 do
    begin
      ExcelApp.Cells.Item[i+2, 2].Value := fZValues[i];
    end;
    {Reselect the first worksheet as this is shown when the file is opened.}
    lWorkSheet := ExcelWorkbook.Worksheets[1] as _WorkSheet;
    lWorkSheet.Select(EmptyParam, 0);
    {Save the worksheet as "lFileName".}
    if FileExists(lFileName) then
      DeleteFile(lFileName);   
    ExcelWorkbook.Close(lOleTrue, lFileName);
  finally
    ExcelWorkbook.Disconnect;
    ExcelApp.Disconnect;
    ExcelApp.Quit;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmShowResult.mnuCopyToClipboardClick(Sender: TObject);
begin
  chartND.CopyToClipboardMetafile(True);
end;

end.
