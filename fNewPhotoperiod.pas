unit fNewPhotoperiod;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Mask, dmAgeFirstEgg, uMethods, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxSpinEdit, cxCurrencyEdit;

type
  TPPAction = (ppaNew, ppaModify);
  TfrmNewPhotoPeriod = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    edtPhotoperiod: TcxSpinEdit;
    edtChangeDay: TcxSpinEdit;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    fPPAction: TPPAction;
    fOldChangeDay: integer;
    fOldPhotoperiod: double;
    function GetNewPhotoperiod: double;
    function GetIntroDay: integer;
    procedure SetIntroDay(aValue: integer);
    procedure SetPhotoperiod(aValue: double);
  public
    { Public declarations }
    property PPAction: TPPAction write fPPAction;
    property NewPhotoPeriod: double  read GetNewPhotoperiod write SetPhotoperiod;
    property IntroductionDay: integer  read GetIntroDay write SetIntroDay;
  end;

var
  frmNewPhotoPeriod: TfrmNewPhotoPeriod;

implementation

{$R *.DFM}

{ TfrmNewPhotoPeriod }

procedure TfrmNewPhotoPeriod.FormShow(Sender: TObject);
begin
  if fPPAction = ppaNew then
    Caption := 'New photoperiod'
  else
    Caption := 'Modify photoperiod';

  with edtPhotoperiod do
  begin
    Properties.MinValue := MIN_PHOTOPERIOD;
    Properties.MaxValue := MAX_PHOTOPERIOD;
    Hint := Format('Minimum = %d, maximum = %d.', [MIN_PHOTOPERIOD, MAX_PHOTOPERIOD]);
  end;  
end;

function TfrmNewPhotoPeriod.GetIntroDay: integer;
begin
  Result := edtChangeDay.Value;
end;

function TfrmNewPhotoPeriod.GetNewPhotoperiod: double;
begin
  Result := edtPhotoperiod.Value;
end;

procedure TfrmNewPhotoPeriod.btnOKClick(Sender: TObject);
begin
  if fPPAction = ppaNew then
  begin
    if dtmAgeFirstEgg.AddPhotoPeriod(edtPhotoperiod.Value, edtChangeDay.Value) then
      ModalResult := mrOK;
  end
  else
  begin  //modify
    if dtmAgeFirstEgg.ModifyPhotoPeriod(fOldPhotoperiod, edtPhotoperiod.Value,
       fOldChangeDay, edtChangeDay.Value) then
      ModalResult := mrOK;
  end;
end;

procedure TfrmNewPhotoPeriod.SetIntroDay(aValue: integer);
begin
  fOldChangeDay := aValue;
  edtChangeDay.Value := aValue;
  edtChangeDay.Enabled := aValue <> FIRST_START_DAY;
  //HS: ENABLE THAT AGAIN !!!! EnableWinControl(edtChangeDay, aValue <> FIRST_START_DAY);  //"0" is the start day and must not be changed.
end;

procedure TfrmNewPhotoPeriod.SetPhotoperiod(aValue: double);
begin
  edtPhotoPeriod.Properties.OnChange := nil;
  fOldPhotoperiod := aValue;
  edtPhotoperiod.Value := aValue;
end;

end.
