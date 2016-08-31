
unit testjsonrpc;

interface

uses
  Windows, SysUtils, Classes, TestFramework, TestExtensions, ujsonrpc;

type
  TTestJsonRpc = class(TTestCase)
  private
    function GetMessageTypeName(t: TJsonRpcObjectType): string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;

  published
    procedure TestParseRequestOK;
    procedure TestParseNotifyWithParamJsonOK;
    procedure TestParseSuccessStrResultOK;
    procedure TestParseErrorOK;
    procedure TestParseNoJsonrpcField;
  end;

implementation

uses
  superobject, TypInfo;

function TTestJsonRpc.GetMessageTypeName(t: TJsonRpcObjectType): string;
begin
  Result := GetEnumName(TypeInfo(TJsonRpcObjectType), Integer(t));
end;

procedure TTestJsonRpc.Setup;
begin
  Self.FailsOnMemoryLeak := true;
end;

procedure TTestJsonRpc.TearDown;
begin

end;

procedure TTestJsonRpc.TestParseErrorOK;
const
  testMsg = '{ jsonrpc: "2.0", id:1, error: { code: -32600, message: "Invalid Request", data: "blabla" } }';
var
  expected, actual: IJsonRpcParsed;
begin
  expected := TJsonRpcParsed.Create(jotError,
    TJsonRpcErrorObject.Create(1, TJsonRpcError.Create(-32600,
      'Invalid Request', 'blabla')));
  actual := TJsonRpcMessage.Parse(testMsg);
  CheckEquals(expected.GetMessagePayload.AsJSon, actual.GetMessagePayload.AsJSon());
  CheckEquals(GetMessageTypeName(expected.GetMessageType),
    GetMessageTypeName(actual.GetMessageType));  
end;

procedure TTestJsonRpc.TestParseNoJsonrpcField;
const
  testMsg = '{ method: "alarm_notify", params: { object: 102 } }';
var
  expected, actual: IJsonRpcParsed;
begin
  expected := TJsonRpcParsed.Create(jotInvalid,
    TJsonRpcErrorObject.Create(TJsonRpcError.InvalidRequest('No jsonrpc field')));
  actual := TJsonRpcMessage.Parse(testMsg);
  CheckEquals(expected.GetMessagePayload.AsJSon, actual.GetMessagePayload.AsJSon());
    CheckEquals(GetMessageTypeName(expected.GetMessageType),
      GetMessageTypeName(actual.GetMessageType));

end;

procedure TTestJsonRpc.TestParseNotifyWithParamJsonOK;
const
  testMsg = '{ jsonrpc: "2.0", method: "alarm_notify", params: { object: 102 } }';
var
  expected, actual: IJsonRpcParsed;
begin
  expected := TJsonRpcParsed.Create(jotNotification,
    TJsonRpcNotificationObject.Create('alarm_notify',SO('{ object: 102 }')));
  actual := TJsonRpcMessage.Parse(testMsg);
  CheckEquals(expected.GetMessagePayload.AsJSon, actual.GetMessagePayload.AsJSon());
    CheckEquals(GetMessageTypeName(expected.GetMessageType),
      GetMessageTypeName(actual.GetMessageType));  
end;

procedure TTestJsonRpc.TestParseRequestOK;
const
  testMsg = '{ jsonrpc: "2.0", id:1, method: "check", params: { a:2 } }';
var
  expected, actual: IJsonRpcParsed;
begin
  expected := TJsonRpcParsed.Create(jotRequest,
    TJsonRpcRequestObject.Create(1,'check',SO('{a: 2}')));
  actual := TJsonRpcMessage.Parse(testMsg);
  CheckEquals(expected.GetMessagePayload.AsJSon, actual.GetMessagePayload.AsJSon());
    CheckEquals(GetMessageTypeName(expected.GetMessageType), GetMessageTypeName(actual.GetMessageType));  
end;

procedure TTestJsonRpc.TestParseSuccessStrResultOK;
const
  testMsg = '{ jsonrpc: "2.0", id:1, result: "success" }';
var
  expected, actual: IJsonRpcParsed;
begin
  expected := TJsonRpcParsed.Create(jotSuccess,
    TJsonRpcSuccessObject.Create(1,'success'));
  actual := TJsonRpcMessage.Parse(testMsg);
  CheckEquals(expected.GetMessagePayload.AsJSon, actual.GetMessagePayload.AsJSon());
  CheckEquals(GetMessageTypeName(expected.GetMessageType), GetMessageTypeName(actual.GetMessageType));  
end;

initialization
  TestFramework.RegisterTest(TTestJsonRpc.Suite);

end.

 