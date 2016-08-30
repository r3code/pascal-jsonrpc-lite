//{$DEFINE DUNIT_CONSOLE_MODE}

program testjsonrpclite;

{$I FastMM4Options.inc}

uses
  FastMM4,
  SysUtils,
  TestFramework,
  TestExtensions,
  GUITestRunner,
  TextTestRunner,
  testjsonrpc in '..\test\testjsonrpc.pas',
  ujsonrpc in '..\source\ujsonrpc.pas',
  testjsonrpcerrors in '..\test\testjsonrpcerrors.pas';

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
