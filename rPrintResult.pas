unit rPrintResult;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls, TeEngine, Series, StatChar,
  TeeProcs, Chart, DBChart, QrTee;

type
  TrptPrintResult = class(TQuickRep)
    QRDBChart1: TQRDBChart;
    chartDistribution: TQRChart;
    Series1: THistogramSeries;
    MmoResult: TQRMemo;
    QRLabel1: TQRLabel;
    procedure QuickRepBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private

  public
  
  end;

var
  rptPrintResult: TrptPrintResult;

implementation

{$R *.DFM}

procedure TrptPrintResult.QuickRepBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  with mmoResult.Lines do
  begin
    Clear;
    if FileExists('Results.txt') then
      LoadFromFile('Results.txt');
  end;
end;

end.
