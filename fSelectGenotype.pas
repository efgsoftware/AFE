unit fSelectGenotype;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxMaskEdit, cxButtonEdit, cxTextEdit, ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxControls, cxGridCustomView, cxGrid, StdCtrls,
  dmAgeFirstEgg, fDefineGT;

type
  TfrmSelectGenotype = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    grdGenotypes: TcxGrid;
    grdGenotypesTV: TcxGridDBTableView;
    grdGenotypesTVGenotype: TcxGridDBColumn;
    grdGenotypesTVMeanAFE: TcxGridDBColumn;
    grdGenotypesTVSensitivity: TcxGridDBColumn;
    grdGenotypesLevel1: TcxGridLevel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdGenotypesTVMeanAFEPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
    function GetGenotypeName: string;
    function GetMeanAFE: double;
    function GetSensitivity: double;
  public
    { Public declarations }
    property GT_Name: string read GetGenotypeName;
    property GT_MeanAFE: double  read GetMeanAFE;
    property GT_Sensitivity: double  read GetSensitivity;
  end;

var
  frmSelectGenotype: TfrmSelectGenotype;

implementation

{$R *.dfm}

{ TfrmSelectGenotype }

procedure TfrmSelectGenotype.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  with grdGenotypesTV.DataController.DataSource do
  begin
    if DataSet.State in [dsEdit, dsInsert] then
      DataSet.Post;
  end;
end;

function TfrmSelectGenotype.GetGenotypeName: string;
begin
  Result := grdGenotypesTV.DataController.DataSource.DataSet.FieldByName('Genotype').AsString;
end;

function TfrmSelectGenotype.GetMeanAFE: double;
begin
  Result := grdGenotypesTV.DataController.DataSource.DataSet.FieldByName('MeanAFE').AsFloat;
end;

function TfrmSelectGenotype.GetSensitivity: double;
begin
  Result := grdGenotypesTV.DataController.DataSource.DataSet.FieldByName('Sensitivity').AsFloat;
end;

procedure TfrmSelectGenotype.grdGenotypesTVMeanAFEPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  with TfrmDefineGT.Create(Self) do
  try
    ShowModal;
  finally
    Release;
  end;
end;

end.
