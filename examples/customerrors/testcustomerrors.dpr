//{$DEFINE DUNIT_CONSOLE_MODE}

program testcustomerrors;

uses
  SysUtils,
  TestFramework,
  TestExtensions,
  GUITestRunner,
  TextTestRunner,
  ujsonrpc in '..\..\source\ujsonrpc.pas',
  ujsonrpccustomerrors in 'ujsonrpccustomerrors.pas',
  utestcustomerrors in 'utestcustomerrors.pas';

{$IFDEF DUNIT_CONSOLE_MODE}
  {$APPTYPE CONSOLE}
{$ELSE}
  {$R *.RES}
{$ENDIF}

begin
{$IFDEF DUNIT_CONSOLE_MODE}
  if not FindCmdLineSwitch('Graphic', ['-','/'], True) then
    TextTestRunner.RunRegisteredTests(rxbHaltOnFailures)
  else
{$ENDIF}
    GUITestRunner.RunRegisteredTests;
end.
