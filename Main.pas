unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, CmdTabSheet;

type
  TfrmCmdRunner = class(TForm)
    pnlTop: TPanel;
    btnOpen: TBitBtn;
    PageControl1: TPageControl;
    btnClose: TBitBtn;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure ShowBtnHint(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmCmdRunner: TfrmCmdRunner;

implementation

{$R *.dfm}

procedure TfrmCmdRunner.FormCreate(Sender: TObject);
begin
  Application.OnHint := ShowBtnHint;
  ShowHint := True;
end;

procedure TfrmCmdRunner.btnOpenClick(Sender: TObject);
begin
  TCmdTabSheet.Create(PageControl1);
end;

procedure TfrmCmdRunner.btnCloseClick(Sender: TObject);
begin
  if PageControl1.ActivePage <> nil then
    TCmdTabSheet(PageControl1.ActivePage).Close;
end;

procedure TfrmCmdRunner.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  for I := PageControl1.PageCount-1 downto 0 do
     TCmdTabSheet(PageControl1.Pages[I]).Close;
end;

procedure TfrmCmdRunner.ShowBtnHint(Sender: TObject);
begin
  StatusBar1.SimpleText := Application.Hint;
end;

end.
