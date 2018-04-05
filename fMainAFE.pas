unit fMainAFE;

{ V1.2 introduced on 05 May 2006, based on Peter's request. }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ImgList, Menus, ComCtrls, StdCtrls, TeEngine, Series, ExtCtrls,
  TeeProcs, Chart, Buttons, dbClient, //MidasLib,
  fNewPhotoperiod, fDefineGT, fLoadExperiment, cCalculation, fAbout,
  uMethods, ToolWin, ShellApi, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxControls, cxGridCustomView, cxClasses, cxGridLevel,
  cxGrid, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxMaskEdit, cxCurrencyEdit, cxButtonEdit, cxTextEdit,
  cxContainer, fSelectGenotype, cxLookAndFeelPainters, cxButtons, fLGMModel,
  cxLookAndFeels, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxNavigator, VclTee.TeeGDIPlus,
  VCLTee.TeeEdit, System.Actions;

type
  TfrmMainAFE = class(TForm)
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuNewPrediction: TMenuItem;
    mnuLoadPrediction: TMenuItem;
    mnuSavePrediction: TMenuItem;
    N1: TMenuItem;
    mnuDefineGT: TMenuItem;
    N2: TMenuItem;
    mnuExit: TMenuItem;
    imgToolbar: TImageList;
    ActionList: TActionList;
    actExit: TAction;
    actDefineGT: TAction;
    actSavePrediction: TAction;
    actNewPrediction: TAction;
    actLoadPrediction: TAction;
    actHelp: TAction;
    actAbout: TAction;
    StatusBar: TStatusBar;
    Help1: TMenuItem;
    mnuAbout: TMenuItem;
    mnuModelHelp: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    actAddPhotoperiod: TAction;
    actShowHints: TAction;
    mnuShowHints: TMenuItem;
    N3: TMenuItem;
    pnlTop: TPanel;
    Label1: TLabel;
    grpPPInput: TGroupBox;
    btnAddPP: TSpeedButton;
    btnDeletePP: TSpeedButton;
    btnModifyPP: TSpeedButton;
    edtExpName: TEdit;
    pnlBottom: TPanel;
    chartExperiment: TChart;
    Series3: TLineSeries;
    btnCalculate: TButton;
    Splitter1: TSplitter;
    grdPhotoperiods: TcxGrid;
    grdPhotoperiodsLevel1: TcxGridLevel;
    grdPhotoperiodsTV: TcxGridDBTableView;
    grdPhotoperiodsTVStartAtDay1: TcxGridDBColumn;
    grdPhotoperiodsTVPhotoPeriod1: TcxGridDBColumn;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    PopMenuPhotoPeriods: TPopupMenu;
    AddPhotoperiod1: TMenuItem;
    actModifyPhotoPeriod: TAction;
    ModifyPhotoPeriod1: TMenuItem;
    actDeletePP: TAction;
    DeletePhotoPeriod1: TMenuItem;
    grpGenotype: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtMeanAFE: TcxCurrencyEdit;
    edtSensitivity: TcxCurrencyEdit;
    btnLookupGenotype: TcxButton;
    edtNameOfGenotype: TEdit;
    actSimpleModel: TAction;
    LGMModel1: TMenuItem;
    ChangetoLGMModel1: TMenuItem;
    actChangeToLgmModel: TAction;
    ChartEditor1: TChartEditor;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actDefineGTExecute(Sender: TObject);
    procedure actSavePredictionExecute(Sender: TObject);
    procedure actNewPredictionExecute(Sender: TObject);
    procedure actLoadPredictionExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure btnCalculateClick(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
    procedure actAddPhotoperiodExecute(Sender: TObject);
    procedure actShowHintsExecute(Sender: TObject);
    procedure grdPhotoperiodsTVDblClick(Sender: TObject);
    procedure actModifyPhotoPeriodExecute(Sender: TObject);
    procedure actDeletePPExecute(Sender: TObject);
    procedure btnLookupGenotypeClick(Sender: TObject);
    procedure actSimpleModelExecute(Sender: TObject);
    procedure actChangeToLgmModelExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateGraph;
    procedure AddOrModifyPhotoperiod(aAction: TPPAction);
    procedure SaveExperiment;
    procedure LoadExperiment;
    procedure ClearExperiment;
    procedure DisplayHint(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmMainAFE: TfrmMainAFE;

implementation

uses dmAgeFirstEgg;

{$R *.DFM}

procedure TfrmMainAFE.FormCreate(Sender: TObject);
begin
  Application.OnHint := DisplayHint;
end;

procedure TfrmMainAFE.FormShow(Sender: TObject);
var
  lExpName, lGTName: string;
  lGTMeanAFE, lGTSensitivity: double;
begin
  if dtmAgeFirstEgg.SelectLastExperiment then
  begin
    dtmAgeFirstEgg.LoadSelectedExperiment(lExpName, lGTName, lGTMeanAFE, lGTSensitivity);
    edtExpName.Text := lExpName;
    edtNameOfGenotype.Text := lGTName;
    edtMeanAFE.Value := lGTMeanAFE;
    edtSensitivity.Value := lGTSensitivity;
  end;
  UpdateGraph;
  btnAddPP.Caption := '';
  btnModifyPP.Caption := '';
  btnDeletePP.Caption := '';
end;

procedure TfrmMainAFE.DisplayHint(Sender: TObject);
begin
  StatusBar.SimpleText := GetLongHint(Application.Hint);
end;

procedure TfrmMainAFE.UpdateGraph;
var
  i: integer;
  lPhotoperiod: double;
  lDataSet: TClientDataSet;
begin
  lPhotoperiod := 12.0;  //default
  lDataSet := dtmAgeFirstEgg.cdsPhotoperiods;
  lDataSet.DisableControls;
  with chartExperiment.SeriesList.Items[0] do  //style is "steps"
  try
    Clear;
    for i := FIRST_START_DAY to 200 do
    begin
      if lDataSet.Locate('StartAtDay', i, []) then
        lPhotoperiod := lDataSet.FieldByName(FLD_PHOTO_PERIOD).AsFloat;

      if i mod 5 = 0 then
        Add(lPhotoperiod, IntToStr(i))
      else
        Add(lPhotoperiod, '');
    end;
  finally
    lDataSet.EnableControls;
  end;
end;

procedure TfrmMainAFE.actAddPhotoperiodExecute(Sender: TObject);
begin
  AddOrModifyPhotoperiod(ppaNew);
end;


procedure TfrmMainAFE.actChangeToLgmModelExecute(Sender: TObject);
begin
  with TfrmLGMModel.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;;
end;

procedure TfrmMainAFE.actModifyPhotoPeriodExecute(Sender: TObject);
begin
  AddOrModifyPhotoperiod(ppaModify);
end;

procedure TfrmMainAFE.grdPhotoperiodsTVDblClick(Sender: TObject);
begin
  AddOrModifyPhotoperiod(ppaModify);
end;

procedure TfrmMainAFE.AddOrModifyPhotoperiod(aAction: TPPAction);
begin
  with TfrmNewPhotoPeriod.Create(Self) do
  try
    PPAction := aAction;
    if aAction = ppaModify then
    with dtmAgeFirstEgg.cdsPhotoperiods do
    begin
      NewPhotoPeriod := FieldByName(FLD_PHOTO_PERIOD).AsFloat;
      IntroductionDay := FieldByName(FLD_START_AT_DAY).AsInteger;
    end;
    ShowModal;
    if ModalResult = mrOK then
    begin
      UpdateGraph;
      if aAction = ppaModify then
        dtmAgeFirstEgg.CheckModifiedPhotoperiod(NewPhotoPeriod, IntroductionDay);
    end;
  finally
    Release;
  end;
end;

procedure TfrmMainAFE.btnCalculateClick(Sender: TObject);
var
  lMeanAgeFirstEgg: double;  //specific for a genotype
  lSensitivityToPPC: double;  //specific for a genotype
begin
  if (Trim(edtMeanAFE.Text) = '') or (Trim(edtSensitivity.Text) = '') then
  begin
    ShowMessage('Please enter a value for Mean AFE and Sensitivity');
    Exit;
  end;

  try
    lMeanAgeFirstEgg := edtMeanAFE.Value;
    lSensitivityToPPC := edtSensitivity.Value;
  except
    on E: Exception do
      raise Exception.Create('Please look at your input for Mean AFE and Sensitivity' +
        #13 + e.Message);
  end;

  with TPrediction.Create(grdPhotoperiodsTV.DataController.DataSource.DataSet,
    lMeanAgeFirstEgg, lSensitivityToPPC, edtExpName.Text) do
  try
    Calculate;
  finally
    Free;
  end;
end;

procedure TfrmMainAFE.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMainAFE.actDefineGTExecute(Sender: TObject);
begin
  with TfrmDefineGT.Create(Self) do
  try
    ShowModal;
  finally
    Release;
  end;
end;

procedure TfrmMainAFE.actSavePredictionExecute(Sender: TObject);
begin
  SaveExperiment;
end;

procedure TfrmMainAFE.SaveExperiment;
var
  lGenotypeName: string;
  lMeanAFE, lSensitivity: double;
  lPhotoperiods: string;
begin
  if Trim(edtExpName.Text) = '' then
  begin
    MessageDlg('Please enter a name for the experiment.', mtWarning, [mbOK], 0);
    edtExpName.SetFocus;
    Exit;
  end;
  lGenotypeName := edtNameOfGenotype.Text;
  lMeanAFE  := edtMeanAFE.Value;
  lSensitivity  := edtSensitivity.Value;
  lPhotoperiods := DataSetToString(grdPhotoperiodsTV.DataController.DataSource.DataSet);
  dtmAgeFirstEgg.AddExperiment(edtExpName.Text, lGenotypeName, lPhotoperiods,
    lMeanAFE, lSensitivity);
end;

procedure TfrmMainAFE.actLoadPredictionExecute(Sender: TObject);
begin
  LoadExperiment;
end;

procedure TfrmMainAFE.LoadExperiment;
var
  lLoadSelectedExp: Boolean;
  lExperimentName, lGTName: string;
  lGTMeanAFE, lGTSensitivity: double;
begin
  if dtmAgeFirstEgg.cdsExperiments.IsEmpty then
  begin
    MessageDlg('No data to load.', mtInformation, [mbOK], 0);
    Exit;
  end;
  with TfrmLoadExperiment.Create(Self) do
  try
    ShowModal;
    lLoadSelectedExp := ModalResult = mrOK;
  finally
    Release;
  end;
  if lLoadSelectedExp then
  begin
    dtmAgeFirstEgg.LoadSelectedExperiment(lExperimentName, lGTName, lGTMeanAFE, lGTSensitivity);
    edtExpName.Text := lExperimentName;
    edtNameOfGenotype.Text := lGTName;
    edtMeanAFE.Value := lGTMeanAFE;
    edtSensitivity.Value := lGTSensitivity;

    UpdateGraph;
  end;
end;

procedure TfrmMainAFE.actNewPredictionExecute(Sender: TObject);
begin
  ClearExperiment;
end;

procedure TfrmMainAFE.ClearExperiment;
begin
  edtExpName.Clear;
  dtmAgeFirstEgg.ResetPhotoperiods;
  UpdateGraph;
end;

procedure TfrmMainAFE.btnLookupGenotypeClick(Sender: TObject);
begin
  with TfrmSelectGenotype.Create(nil) do
  try
    ShowModal;
    if ModalResult = mrOk then
    begin
      edtNameOfGenotype.Text := GT_Name;
      edtMeanAFE.Value := GT_MeanAFE;
      edtSensitivity.Value := GT_Sensitivity;
    end;
  finally
    Release;
  end;
end;

procedure TfrmMainAFE.Button1Click(Sender: TObject);
begin
  ChartEditor1.Execute;
end;

procedure TfrmMainAFE.actAboutExecute(Sender: TObject);
begin
  with TfrmAbout.Create(Self) do
  try
    ShowModal;
  finally
    Release;
  end;
end;

procedure TfrmMainAFE.actHelpExecute(Sender: TObject);
begin
  if FileExists('ModelHelp.doc') then
    ShellExecute(Handle, 'Open', 'ModelHelp.doc', nil, nil, SW_SHOW)
  else
    MessageDlg('Please copy the help document in the same folder as the ' +
      'executable and rename it "ModelHelp.doc".', mtWarning, [mbOK], 0);
end;

procedure TfrmMainAFE.actShowHintsExecute(Sender: TObject);
begin
  Self.ShowHint := not Self.ShowHint;
end;

procedure TfrmMainAFE.actSimpleModelExecute(Sender: TObject);
begin
  //
end;

procedure TfrmMainAFE.actDeletePPExecute(Sender: TObject);
begin
  dtmAgeFirstEgg.DeleteCurrentPhotoperiod;
  UpdateGraph;
end;

end.
