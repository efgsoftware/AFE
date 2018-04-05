unit fDefineGT;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls, cxTextEdit, cxControls, cxContainer,
  cxEdit, cxMaskEdit, cxCurrencyEdit, Menus, cxLookAndFeelPainters, cxButtons;

type
  TfrmDefineGT = class(TForm)
    btnClose: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtMeanAFE: TcxMaskEdit;
    edtMeanAFE_10: TcxTextEdit;
    edtPhotoperiod: TcxCurrencyEdit;
    btnCompute: TcxButton;
    procedure btnComputeClick(Sender: TObject);
  private
    procedure CalculateMeanAFE;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDefineGT: TfrmDefineGT;

implementation

{$R *.DFM}

procedure TfrmDefineGT.btnComputeClick(Sender: TObject);
begin
  CalculateMeanAFE;
end;

procedure TfrmDefineGT.CalculateMeanAFE;
var
  lMeanAFE: integer;
  lPhotoPeriod: double;
begin
  lMeanAFE := StrToInt(edtMeanAFE.Text);
  lPhotoPeriod := edtPhotoperiod.Value;
  if lPhotoperiod <= 10 then
    {Equation 1}
    edtMeanAFE_10.Text := Format('%8.3f', [lMeanAFE - (4.222 * (10 - lPhotoperiod))])
  else
    {Equation 2}
    edtMeanAFE_10.Text := Format('%8.3f', [lMeanAFE - (0.285 * (lPhotoperiod - 10))]);
end;

end.
