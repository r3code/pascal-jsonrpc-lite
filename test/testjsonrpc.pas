
unit testjsonrpc;

interface

uses
  Windows, SysUtils, Classes, TestFramework, TestExtensions;

type
  TTestJsonRpc = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;

  published
    procedure Test;
  end;

implementation

procedure TTestJsonRpc.Setup;
begin

end;

procedure TTestJsonRpc.TearDown;
begin

end;

procedure TTestJsonRpc.Test;
begin

end;

initialization
  TestFramework.RegisterTest(TTestJsonRpc.Suite);

end.

 