//
// Author: Dmitriy S. Sinyavskiy, 2016
//
unit utestcustomerrors;

interface

uses
  Windows, SysUtils, Classes, TestFramework, TestExtensions;

type
  TTestCustomErrors = class(TTestCase)
  published
    procedure TestProcedureExceptionWithDataStr;
    procedure TestProcedureExceptionWithDataObj;
    procedure TestAuthErrorWithDataStr;
    procedure TestAuthErrorWithDataObj;
  end;

implementation

uses
  ujsonrpccustomerrors, ujsonrpc, superobject;

procedure TTestCustomErrors.TestAuthErrorWithDataObj;
var
  expected, actual: TJsonRpcError;
begin
  expected := TJsonRpcError.Create(-32201, 'Authentication Error',
    SO('blabla'));
  actual := TJsonRpcCustomError.AuthError(SO('blabla'));
  CheckEquals(expected.AsJSon(), actual.AsJSon());
end;

procedure TTestCustomErrors.TestAuthErrorWithDataStr;
var
  expected, actual: TJsonRpcError;
begin
  expected := TJsonRpcError.Create(-32201, 'Authentication Error', 'blabla');
  actual := TJsonRpcCustomError.AuthError('blabla');
  CheckEquals(expected.AsJSon(), actual.AsJSon());
end;

procedure TTestCustomErrors.TestProcedureExceptionWithDataObj;
var
  expected, actual: TJsonRpcError;
begin
  expected := TJsonRpcError.Create(-32200, 'Procedure Exception', SO('blabla'));
  actual := TJsonRpcCustomError.ProcedureException(SO('blabla'));
  CheckEquals(expected.AsJSon(), actual.AsJSon());
end;

procedure TTestCustomErrors.TestProcedureExceptionWithDataStr;
var
  expected, actual: TJsonRpcError;
begin
  expected := TJsonRpcError.Create(-32200, 'Procedure Exception', 'blabla');
  actual := TJsonRpcCustomError.ProcedureException('blabla');
  CheckEquals(expected.AsJSon(), actual.AsJSon());
end;

initialization
  TestFramework.RegisterTest(TTestCustomErrors.Suite);

end.
