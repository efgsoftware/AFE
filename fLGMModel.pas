unit fLGMModel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, cxControls, cxContainer, cxEdit, cxTextEdit,
  cxCurrencyEdit, TeEngine, Series, TeeProcs, Chart, ComCtrls, uDefinitions,
  Buttons, ActnList, ExtDlgs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, VclTee.TeeGDIPlus, VCLTee.TeeEdit,
  System.Actions;

type
  TfrmLGMModel = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lblFinalPhotoperiod: TLabel;
    Label3: TLabel;
    lblAgeAtChange: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Label4: TLabel;
    lblFPHours: TLabel;
    lblAgeHours: TLabel;
    btnIncMBW: TSpeedButton;
    edtInitalPP: TcxCurrencyEdit;
    edtFinalPP: TcxCurrencyEdit;
    edtAgeAtChange: TcxCurrencyEdit;
    edtMeanBodyWeight: TcxCurrencyEdit;
    chkPPChange: TCheckBox;
    btnCalc: TButton;
    btnClose: TButton;
    chartND: TChart;
    Series1: TLineSeries;
    mmoResult: TMemo;
    Splitter1: TSplitter;
    btnDecMBW: TSpeedButton;
    btnIncPP1: TSpeedButton;
    btnDecPP1: TSpeedButton;
    btnIncPP2: TSpeedButton;
    btnDecPP2: TSpeedButton;
    btnDecDay: TSpeedButton;
    btnIncDay: TSpeedButton;
    ActionList: TActionList;
    actCalculate: TAction;
    edtStepForPP1: TcxCurrencyEdit;
    tmrIncDecrement: TTimer;
    edtStepForMBW: TcxCurrencyEdit;
    edtStepForPP2: TcxCurrencyEdit;
    edtStepForDay: TcxCurrencyEdit;
    btnSaveChart: TButton;
    dlgSavePicture: TSavePictureDialog;
    Button1: TButton;
    ChartEditor1: TChartEditor;
    procedure chkPPChangeClick(Sender: TObject);
    procedure actCalculateExecute(Sender: TObject);
    procedure tmrIncDecrementTimer(Sender: TObject);
    procedure btnIncPP1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnIncPP1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnDecPP1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnIncMBWMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnDecMBWMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnIncPP2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnDecPP2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnIncDayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnDecDayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnSaveChartClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fSelectedStepFunction: string;
    procedure EnablePPChangeInput(aEnable: Boolean);
    procedure ShowStandardDevGraph(aZValues: TZValues);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLGMModel: TfrmLGMModel;

implementation

{$R *.dfm}

uses
  cPredictLGM;

procedure TfrmLGMModel.actCalculateExecute(Sender: TObject);
var
  lInitialPhotoperiod, lFinalPhotoperiod: double;
  lAgeAtChange: integer;
  lMeanBodyWeightAt20Weeks: double;
  lZValues: TZValues;
begin
  lInitialPhotoperiod := edtInitalPP.Value;
  lFinalPhotoperiod := edtFinalPP.Value;
  lAgeAtChange := edtAgeAtChange.EditValue;
  lMeanBodyWeightAt20Weeks := edtMeanBodyWeight.Value;

  with TPredictLGM.Create(lInitialPhotoperiod, lFinalPhotoperiod,
    lMeanBodyWeightAt20Weeks, lAgeAtChange, not chkPPChange.Checked) do
  try
    Calculate;
    lZValues := ZValues;
    mmoResult.Lines := ReportStrings;
  finally
    Free;
  end;
  ShowStandardDevGraph(lZValues);
end;

procedure TfrmLGMModel.ShowStandardDevGraph(aZValues: TZValues);
var
  lDay: integer;
  lXAxisText: string;
begin
  with chartND.SeriesList do
  begin
    Items[0].Clear;
    for lDay := 1 to 300 do
    begin
      if lDay mod 10 = 0 then  //write a marker for every 10th day.
        lXAxisText := IntToStr(lDay)
      else
        lXAxisText := '';

      Items[0].Add(aZValues[lDay], lXAxisText);
    end;
  end;
end;

procedure TfrmLGMModel.tmrIncDecrementTimer(Sender: TObject);
begin
  if fSelectedStepFunction = 'IncPP1' then
  begin
    edtInitalPP.Text :=  Format('%7.1f', [edtInitalPP.Value + edtStepForPP1.Value]);
  end
  else if fSelectedStepFunction = 'DecPP1' then
  begin
    edtInitalPP.Text :=  Format('%7.1f', [edtInitalPP.Value - edtStepForPP1.Value]);
  end

  else if fSelectedStepFunction = 'IncPP2' then
  begin
    edtFinalPP.Text :=  Format('%7.1f', [edtFinalPP.Value + edtStepForPP2.Value]);
  end
  else if fSelectedStepFunction = 'DecPP2' then
  begin
    edtFinalPP.Text :=  Format('%7.1f', [edtFinalPP.Value - edtStepForPP2.Value]);
  end

  else if fSelectedStepFunction = 'IncMBW' then
  begin
    edtMeanBodyWeight.Text :=  Format('%7.1f', [edtMeanBodyWeight.Value + edtStepForMBW.Value]);
  end
  else if fSelectedStepFunction = 'DecMBW' then
  begin
    edtMeanBodyWeight.Text :=  Format('%7.1f', [edtMeanBodyWeight.Value - edtStepForMBW.Value]);
  end

  else if fSelectedStepFunction = 'IncDay' then
  begin
    edtAgeAtChange.Text :=  Format('%3d', [Round(edtAgeAtChange.Value + edtStepForDay.Value)]);
  end
  else if fSelectedStepFunction = 'DecDay' then
  begin
    edtAgeAtChange.Text :=  Format('%3d', [Round(edtAgeAtChange.Value - edtStepForDay.Value)]);
  end
  else
  begin
    tmrIncDecrement.Enabled := False;
    raise Exception.Create('No valid button for Auto Step pressed.');
  end;

  actCalculate.Execute;
end;

procedure TfrmLGMModel.btnIncDayMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fSelectedStepFunction := 'IncDay';
  tmrIncDecrement.Enabled := True;
end;

procedure TfrmLGMModel.btnIncMBWMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fSelectedStepFunction := 'IncMBW';
  tmrIncDecrement.Enabled := True;
end;

procedure TfrmLGMModel.btnIncPP1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fSelectedStepFunction := 'IncPP1';
  tmrIncDecrement.Enabled := True;
end;

procedure TfrmLGMModel.btnIncPP1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  tmrIncDecrement.Enabled := False;
end;

procedure TfrmLGMModel.btnIncPP2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fSelectedStepFunction := 'IncPP2';
  tmrIncDecrement.Enabled := True;
end;

procedure TfrmLGMModel.btnSaveChartClick(Sender: TObject);
begin
  if dlgSavePicture.Execute then
    chartND.SaveToMetafile(dlgSavePicture.FileName);
end;

procedure TfrmLGMModel.Button1Click(Sender: TObject);
begin
  ChartEditor1.Execute;
end;

procedure TfrmLGMModel.btnDecDayMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fSelectedStepFunction := 'DecDay';
  tmrIncDecrement.Enabled := True;
end;

procedure TfrmLGMModel.btnDecMBWMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fSelectedStepFunction := 'DecMBW';
  tmrIncDecrement.Enabled := True;
end;

procedure TfrmLGMModel.btnDecPP1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fSelectedStepFunction := 'DecPP1';
  tmrIncDecrement.Enabled := True;
end;

procedure TfrmLGMModel.btnDecPP2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fSelectedStepFunction := 'DecPP2';
  tmrIncDecrement.Enabled := True;
end;

procedure TfrmLGMModel.chkPPChangeClick(Sender: TObject);
begin
  EnablePPChangeInput(chkPPChange.Checked);
end;

procedure TfrmLGMModel.EnablePPChangeInput(aEnable: Boolean);
begin
  lblFinalPhotoperiod.Enabled := aEnable;
  lblAgeAtChange.Enabled := aEnable;
  edtFinalPP.Enabled := aEnable;
  edtAgeAtChange.Enabled := aEnable;
  lblFPHours.Enabled := aEnable;
  lblAgeHours.Enabled := aEnable;
  btnIncPP2.Enabled := aEnable;
  btnDecPP2.Enabled := aEnable;
  btnIncDay.Enabled := aEnable;
  btnDecDay.Enabled := aEnable;
end;


end.
