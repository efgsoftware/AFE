unit fLoadExperiment;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dmAgeFirstEgg, StdCtrls, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxControls, cxGridCustomView, cxClasses, cxGridLevel,
  cxGrid, ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
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
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, cxMaskEdit, cxCalendar;

type
  TfrmLoadExperiment = class(TForm)
    grdExperiments: TcxGrid;
    grdExperimentsLevel1: TcxGridLevel;
    grdExperimentsTV: TcxGridDBTableView;
    grdExperimentsTVName1: TcxGridDBColumn;
    grdExperimentsTVDate1: TcxGridDBColumn;
    grdExperimentsTVGtName1: TcxGridDBColumn;
    grdExperimentsTVGtMeanAFE1: TcxGridDBColumn;
    grdExperimentsTVGtSensitivity1: TcxGridDBColumn;
    grdExperimentsTVPhotoperiods1: TcxGridDBColumn;
    Panel1: TPanel;
    btnLoad: TButton;
    btnCancel: TButton;
    btnDelete: TButton;
    procedure btnDeleteClick(Sender: TObject);
    procedure grdExperimentsTVDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLoadExperiment: TfrmLoadExperiment;

implementation

{$R *.DFM}

procedure TfrmLoadExperiment.btnDeleteClick(Sender: TObject);
begin
  with grdExperimentsTV.DataController.DataSource.DataSet do
  begin
    Delete;
    if IsEmpty then
      ModalResult := mrCancel;
  end;
end;

procedure TfrmLoadExperiment.grdExperimentsTVDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
