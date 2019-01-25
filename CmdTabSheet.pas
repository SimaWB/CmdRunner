unit CmdTabSheet;

interface

uses
  Windows, Classes, Messages, ComCtrls, ShellAPI, SysUtils, ExtCtrls;

type
  TCmdTabSheet = class(TTabSheet)
  protected
    procedure Resize; override;
    procedure DoShow; override;
  private
    ConsoleHandle: HWND;
    ConsolePID: DWORD;
    Timer: TTimer;
    fFColor, fBColor: Integer;

    procedure RunCmd(CurDir: String = '');
    procedure TimerOnTimer(Sender: TObject);
    function IsCmdRunning: Boolean;
    function GetCaption(const Ind: Integer): String;
    function GetCommandPrompt: String;

  public
    constructor Create(PageCtrl: TPageControl; FColor, BColor: Integer; CurDir: String=''); reintroduce;
    destructor Destroy; override;

    procedure SetForegroundConsole;
  end;

  function GetConsoleWindow: HWND; stdcall; external kernel32 name 'GetConsoleWindow';
  function AttachConsole(dwProcessId: DWORD): BOOL; stdcall; external kernel32 name 'AttachConsole';

const
  COLORS: array[0..15, 0..1] of String = (
    ('$000000', 'Black'),
    ('$800000', 'Dark Blue'),
    ('$008000', 'Dark Green'),
    ('$808000', 'Dark Cyan'),
    ('$000080', 'Dark Red'),
    ('$800080', 'Dark Magenta'),
    ('$008080', 'Dark Yellow'),
    ('$C0C0C0', 'Light Grey'),
    ('$A4A0A0', 'Dark Grey'),
    ('$FF0000', 'Blue'),
    ('$00FF00', 'Green'),
    ('$FFFF00', 'Cyan'),
    ('$0000FF', 'Red'),
    ('$FF00FF', 'Magenta'),
    ('$00FFFF', 'Yellow'),
    ('$FFFFFF', 'White')
  );

implementation

uses TlHelp32;

{ TCmdTabSheet }

constructor TCmdTabSheet.Create(PageCtrl: TPageControl; FColor, BColor: Integer; CurDir: String='');
var
  Style: Longint;
begin
  ConsoleHandle := 0;
  ConsolePID := 0;
  inherited Create(PageCtrl);
  PageControl := PageCtrl;
  Caption := GetCaption(0);
  PageCtrl.ActivePage := Self;
  fFColor := FColor;
  fBColor := BColor;

  Timer := TTimer.Create(Self);
  Timer.Interval := 250;
  Timer.OnTimer := TimerOnTimer;
  Timer.Enabled := False;

  ImageIndex := 0;
  RunCmd(CurDir);

  if ConsoleHandle <> 0 then
  begin
    Windows.SetParent(ConsoleHandle, Handle);
    PostMessage(ConsoleHandle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);

    Style := GetWindowLong(ConsoleHandle, GWL_STYLE);
    SetWindowLong(ConsoleHandle, GWL_STYLE, Style and not WS_BORDER and not WS_SIZEBOX and not WS_DLGFRAME );
  end;

  if ConsolePID <> 0 then
    Timer.Enabled := True;
end;

destructor TCmdTabSheet.Destroy;
begin
  Timer.Enabled := False;
  if ConsoleHandle <> 0 then
    SendMessage(ConsoleHandle, WM_CLOSE,0,0);
  inherited Destroy;
end;

procedure TCmdTabSheet.DoShow;
begin
  SetForegroundConsole;
  inherited;
end;

function TCmdTabSheet.GetCaption(const Ind: Integer): String;
var
  I: Integer;
begin
  Result := Format('(%d)', [Ind]);
  for I := 0 to PageControl.PageCount-1 do
     if PageControl.Pages[I].Caption = Result then
       Result := GetCaption(I+1)
end;

function TCmdTabSheet.GetCommandPrompt: String;
var
  PathName: PChar;
  Buffer: array[0..255] of char;
begin
  PathName := PChar('COMSPEC');
  GetEnvironmentVariable(PathName, @Buffer, Sizeof(Buffer));
  Result := String(Buffer);
end;

function TCmdTabSheet.IsCmdRunning: Boolean;
var
  hSnapshot: THandle;
  EntryParentProc: TProcessEntry32;
begin
  Result := False;
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if hSnapshot = INVALID_HANDLE_VALUE then
    Exit;

  try
    EntryParentProc.dwSize := SizeOf(EntryParentProc);
    if Process32First(hSnapshot, EntryParentProc) then
      repeat
        if EntryParentProc.th32ProcessID = ConsolePID then
        begin
          Result := True;
          Break;
        end;
      until not Process32Next(hSnapshot, EntryParentProc);
  finally
    CloseHandle(hSnapshot);
  end;
end;

procedure TCmdTabSheet.Resize;
begin
  inherited Resize;
  if IsWindow(ConsoleHandle) then
    SetWindowPos(ConsoleHandle, 0, 0, 0, Width, Height, SWP_ASYNCWINDOWPOS); //SWP_NOSIZE
end;

procedure TCmdTabSheet.RunCmd(CurDir: String = '');
var
  CmdLine: string;
  Attempt: Integer;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  Dir: PWideChar;
begin
  ConsoleHandle := 0;
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  FillChar(ProcessInfo, SizeOf(TProcessInformation), 0);
  StartupInfo.cb := SizeOf(TStartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW OR STARTF_USEFILLATTRIBUTE;
  StartupInfo.wShowWindow := SW_HIDE;
  StartupInfo.dwFillAttribute := DWORD(fFColor) or (DWORD(fBColor) shl 4);

  if CurDir = '' then
    Dir := nil
  else
    Dir := PWideChar(CurDir);
  CmdLine := GetCommandPrompt;
  UniqueString(CmdLine);

  if CreateProcess(nil, PWideChar(CmdLine), nil, nil, False,
    CREATE_NEW_CONSOLE, nil, Dir, StartupInfo, ProcessInfo) then
  begin
    Attempt := 100;
    while (Attempt > 0) do
    begin
      if AttachConsole(ProcessInfo.dwProcessId) then
      begin
        ConsoleHandle := GetConsoleWindow;
        ConsolePID := ProcessInfo.dwProcessId;
        FreeConsole;
        Break;
      end;
      Sleep(10);
      Dec(Attempt);
    end;
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ProcessInfo.hProcess);
  end;
end;

procedure TCmdTabSheet.SetForegroundConsole;
begin
  if ConsoleHandle <> 0 then
    SetForegroundWindow(ConsoleHandle);
end;

procedure TCmdTabSheet.TimerOnTimer(Sender: TObject);
begin
  if ConsolePID = 0 then
    Exit;
  if not IsCmdRunning then
  begin
    Timer.Enabled := False;
    Destroy;
  end;
end;

end.
