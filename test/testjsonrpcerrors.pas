unit testjsonrpcerrors;

interface

uses
  Windows, SysUtils, Classes, TestFramework, TestExtensions;

type
  TTestJsonRpcError = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;

  published
    procedure TestErrorHasDataJsonCreated;
    procedure TestErrorHasDataAsStringCreated;
    procedure TestParseErrorCreated;
    procedure TestInvalidRequestHasDataJsonCreated;
    procedure TestInvalidRequestHasDataAsStrCreated;
    procedure TestMethodNotFoundHasDataJsonCreated;
    procedure TestMethodNotFoundHasDataAsStrCreated;
    procedure TestInvalidParamsHasDataJsonCreated;
    procedure TestInvalidParamsHasDataAsStrCreated;
    procedure TestInternalErrorHasDataJsonCreated;
    procedure TestInternalErrorHasDataAsStrCreated;
  end;

implementation

uses
  superobject, ujsonrpc;

procedure TTestJsonRpcError.Setup;
begin

end;

procedure TTestJsonRpcError.TearDown;
begin

end;

procedure TTestJsonRpcError.TestErrorHasDataAsStringCreated;
var
  expected: ISuperObject;
  actual: IJsonRpcMessage;
begin
  expected := SO();
  expected.I['code'] := -32201;
  expected.S['message'] := 'Authentification error';
  expected.S['data'] := '901';
  actual := TJsonRpcError.Error(-32201, 'Authentification error', '901');
  CheckEquals(expected.AsJSon, actual.asJsonObject.AsJSon());
end;

procedure TTestJsonRpcError.TestErrorHasDataJsonCreated;
var
  expected: ISuperObject;
  actual: IJsonRpcMessage;
begin
  expected := SO();
  expected.I['code'] := -32201;
  expected.S['message'] := 'Authentification error';
  expected.O['data'] := SO('{appId:901}');
  actual := TJsonRpcError.Error(-32201, 'Authentification error',
    SO('{appId:901}'));
  CheckEquals(expected.AsJSon, actual.asJsonObject.AsJSon());
end;

procedure TTestJsonRpcError.TestInternalErrorHasDataAsStrCreated;
var
  expected: ISuperObject;
  actual: IJsonRpcMessage;
begin
  expected := SO();
  expected.I['code'] := -32603;
  expected.S['message'] := RPC_ERR_INTERNAL_ERROR;
  expected.S['data'] := 'abc';
  actual := TJsonRpcError.InternalError('abc');
  CheckEquals(expected.AsJSon, actual.asJsonObject.AsJSon());
end;

procedure TTestJsonRpcError.TestInternalErrorHasDataJsonCreated;
var
  expected: ISuperObject;
  actual: IJsonRpcMessage;
begin
  expected := SO();
  expected.I['code'] := -32603;
  expected.S['message'] := RPC_ERR_INTERNAL_ERROR;
  expected.O['data'] := SO('{a: 1}');
  actual := TJsonRpcError.InternalError(SO('{a: 1}'));
  CheckEquals(expected.AsJSon, actual.asJsonObject.AsJSon());
end;

procedure TTestJsonRpcError.TestInvalidParamsHasDataAsStrCreated;
var
  expected: ISuperObject;
  actual: IJsonRpcMessage;
begin
  expected := SO();
  expected.I['code'] := -32602;
  expected.S['message'] := RPC_ERR_INVALID_PARAMS;
  expected.S['data'] := 'abc';
  actual := TJsonRpcError.InvalidParams('abc');
  CheckEquals(expected.AsJSon, actual.asJsonObject.AsJSon());
end;

procedure TTestJsonRpcError.TestInvalidParamsHasDataJsonCreated;
var
  expected: ISuperObject;
  actual: IJsonRpcMessage;
begin
  expected := SO();
  expected.I['code'] := -32602;
  expected.S['message'] := RPC_ERR_INVALID_PARAMS;
  expected.O['data'] := SO('{a: 1}');
  actual := TJsonRpcError.InvalidParams(SO('{a: 1}'));
  CheckEquals(expected.AsJSon, actual.asJsonObject.AsJSon());
end;

procedure TTestJsonRpcError.TestInvalidRequestHasDataAsStrCreated;
var
  expected: ISuperObject;
  actual: IJsonRpcMessage;
begin
  expected := SO();
  expected.I['code'] := -32600;
  expected.S['message'] := PRC_ERR_INVALID_REQUEST;
  expected.S['data'] := 'abc';
  actual := TJsonRpcError.InvalidRequest('abc');
  CheckEquals(expected.AsJSon, actual.asJsonObject.AsJSon());
end;

procedure TTestJsonRpcError.TestInvalidRequestHasDataJsonCreated;
var
  expected: ISuperObject;
  actual: IJsonRpcMessage;
begin
  expected := SO();
  expected.I['code'] := -32600;
  expected.S['message'] := PRC_ERR_INVALID_REQUEST;
  expected.O['data'] := SO('{a: 1}');
  actual := TJsonRpcError.InvalidRequest(SO('{a: 1}'));
  CheckEquals(expected.AsJSon, actual.asJsonObject.AsJSon());
end;

procedure TTestJsonRpcError.TestMethodNotFoundHasDataAsStrCreated;
var
  expected: ISuperObject;
  actual: IJsonRpcMessage;
begin
  expected := SO();
  expected.I['code'] := -32601;
  expected.S['message'] := PRC_ERR_METHOD_NOT_FOUND;
  expected.S['data'] := 'test';
  actual := TJsonRpcError.MethodNotFound('test');
  CheckEquals(expected.AsJSon, actual.asJsonObject.AsJSon());
end;

procedure TTestJsonRpcError.TestMethodNotFoundHasDataJsonCreated;
var
  expected: ISuperObject;
  actual: IJsonRpcMessage;
begin
  expected := SO();
  expected.I['code'] := -32601;
  expected.S['message'] := PRC_ERR_METHOD_NOT_FOUND;
  expected.O['data'] := SO('{a: 1}');
  actual := TJsonRpcError.MethodNotFound(SO('{a: 1}'));
  CheckEquals(expected.AsJSon, actual.asJsonObject.AsJSon());
end;

procedure TTestJsonRpcError.TestParseErrorCreated;
var
  expected: ISuperObject;
  actual: IJsonRpcMessage;
begin
  expected := SO();
  expected.I['code'] := -32700;
  expected.S['message'] := RPC_ERR_PARSE_ERROR;
  expected.S['data'] := 'test';
  actual := TJsonRpcError.ParseError('test');
  CheckEquals(expected.AsJSon, actual.asJsonObject.AsJSon());
end;

initialization
  TestFramework.RegisterTest(TTestJsonRpcError.Suite);

end.

