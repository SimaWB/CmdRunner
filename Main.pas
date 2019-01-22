unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, CmdTabSheet, ImgList, Menus;

type
  TfrmCmdRunner = class(TForm)
    pnlTop: TPanel;
    PageControl1: TPageControl;
    btnClose: TBitBtn;
    StatusBar1: TStatusBar;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    Deneme1: TMenuItem;
    MyDocuments1: TMenuItem;
    btnOpen: TButton;
    AppData1: TMenuItem;
    Windows1: TMenuItem;
    System1: TMenuItem;
    N1: TMenuItem;
    SelectFolder1: TMenuItem;
    ProgramFles1: TMenuItem;
    FileOpenDialog1: TFileOpenDialog;
    clrBackground: TColorBox;
    Label1: TLabel;
    Label2: TLabel;
    clrForeground: TColorBox;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure btnOpenMenuClick(Sender: TObject);
    procedure SelectFolder1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ShowBtnHint(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmCmdRunner: TfrmCmdRunner;

implementation

uses SHFolder;

{$R *.dfm}

function GetSpecialFolderPath(FolderId: Integer): string;
var
  aPath: array[0..MAX_PATH] of Char;
begin
  SHGetFolderPath(0, FolderId, 0, 0, aPath);
  Result := aPath;
end;

procedure TfrmCmdRunner.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  Application.OnHint := ShowBtnHint;
  ShowHint := True;

  for I := Low(COLORS) to High(COLORS) do
  begin
    clrBackground.AddItem('', TObject(StrToInt(COLORS[I][0])));
    clrForeground.AddItem('', TObject(StrToInt(COLORS[I][0])));
  end;
  clrBackground.ItemIndex := Low(COLORS);
  clrForeground.ItemIndex := High(COLORS);
end;

procedure TfrmCmdRunner.btnCloseClick(Sender: TObject);
begin
  if PageControl1.ActivePage <> nil then
    TCmdTabSheet(PageControl1.ActivePage).Destroy;
end;

procedure TfrmCmdRunner.btnOpenClick(Sender: TObject);
begin
  TCmdTabSheet.Create(PageControl1, clrForeground.ItemIndex, clrBackground.ItemIndex);
end;

procedure TfrmCmdRunner.btnOpenMenuClick(Sender: TObject);
begin
  TCmdTabSheet.Create(PageControl1, clrForeground.ItemIndex, clrBackground.ItemIndex, GetSpecialFolderPath(TMenuItem(Sender).Tag));
end;

procedure TfrmCmdRunner.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  for I := PageControl1.PageCount-1 downto 0 do
    TCmdTabSheet(PageControl1.Pages[I]).Destroy
end;

procedure TfrmCmdRunner.SelectFolder1Click(Sender: TObject);
begin
  if FileOpenDialog1.Execute then
    TCmdTabSheet.Create(PageControl1, clrForeground.ItemIndex, clrBackground.ItemIndex, FileOpenDialog1.FileName);
end;

procedure TfrmCmdRunner.ShowBtnHint(Sender: TObject);
begin
  StatusBar1.SimpleText := Application.Hint;
end;

end.
