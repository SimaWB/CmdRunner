unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, CmdTabSheet;

type
  TfrmCmdRunner = class(TForm)
    pnlTop: TPanel;
    BitBtn1: TBitBtn;
    PageControl1: TPageControl;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCmdRunner: TfrmCmdRunner;

implementation

{$R *.dfm}

procedure TfrmCmdRunner.BitBtn1Click(Sender: TObject);
begin
  TCmdTabSheet.Create(PageControl1);
end;

procedure TfrmCmdRunner.BitBtn2Click(Sender: TObject);
begin
  if PageControl1.ActivePage <> nil then
    TCmdTabSheet(PageControl1.ActivePage).Close;
end;

end.
