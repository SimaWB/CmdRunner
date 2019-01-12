program CmdRunner;

uses
  Forms,
  Main in 'Main.pas' {frmCmdRunner},
  CmdTabSheet in 'CmdTabSheet.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCmdRunner, frmCmdRunner);
  Application.Run;
end.
