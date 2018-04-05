unit fAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, jpeg, ShellAPI, cxControls, cxContainer, cxEdit,
  cxLabel;

type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    lblWebSite: TLabel;
    btnClose: TButton;
    lblVersion: TLabel;
    Image1: TImage;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    procedure FormCreate(Sender: TObject);
    procedure lblWebSiteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.DFM}

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  //Image1.Picture.LoadFromFile('Logo.emf');
end;

procedure TfrmAbout.lblWebSiteClick(Sender: TObject);
begin
  ShellExecute(Handle, 'Open', PChar(lblWebSite.Caption), nil, nil, SW_SHOWNORMAL);
end;

end.
