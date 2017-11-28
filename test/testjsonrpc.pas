
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
    procedure TestParseErrorWithDataObjOK;
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
  testMsg = '{ jsonrpc: "2.0", id:1, error: { code: -32600, message: "'
    + PRC_ERR_INVALID_REQUEST + '", data: "blabla" } }';
var
  expected, actual: IJsonRpcParsed;
begin
  expected := TJsonRpcParsed.Create(jotError,
    TJsonRpcErrorObject.Create(1, TJsonRpcError.Create(-32600,
    PRC_ERR_INVALID_REQUEST, 'blabla')));
  actual := TJsonRpcMessage.Parse(testMsg);
  CheckEquals(expected.GetMessagePayload.AsJSon,
    actual.GetMessagePayload.AsJSon());
  CheckEquals(GetMessageTypeName(expected.GetMessageType),
    GetMessageTypeName(actual.GetMessageType));
end;

procedure TTestJsonRpc.TestParseErrorWithDataObjOK;
const
  testMsg = '{ jsonrpc: "2.0", id:1, error: { code: -32600, message: "'
    + PRC_ERR_INVALID_REQUEST + '", '
    + 'data: {"method":"AUTH","params":{'
    + '"secretWord":"D4A0999956449F3A5DEA3EE29BA8AEBD", "appId":100},'
    + '"id":1,'
    + '"jsonrpc":"2.0"}'
    + ' } }';
var
  expected, actual: IJsonRpcParsed;
begin
  expected := TJsonRpcParsed.Create(jotError,
    TJsonRpcErrorObject.Create(1, TJsonRpcError.Create(-32600,
    PRC_ERR_INVALID_REQUEST,
    SO('{"method":"AUTH","params":{'
    + '"secretWord":"D4A0999956449F3A5DEA3EE29BA8AEBD", "appId":100},'
    + '"id":1,"jsonrpc":"2.0"}'))));
  actual := TJsonRpcMessage.Parse(testMsg);
  CheckEquals(expected.GetMessagePayload.AsJSon,
    actual.GetMessagePayload.AsJSon());
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
    TJsonRpcErrorObject.Create(TJsonRpcError.InvalidRequest(ERROR_NO_JSONRPC_FIELD)));
  actual := TJsonRpcMessage.Parse(testMsg);
  CheckEquals(expected.GetMessagePayload.AsJSon,
    actual.GetMessagePayload.AsJSon());
  CheckEquals(GetMessageTypeName(expected.GetMessageType),
    GetMessageTypeName(actual.GetMessageType));

end;

procedure TTestJsonRpc.TestParseNotifyWithParamJsonOK;
const
  testMsg = '{"method":"ALARM",'
    + '"params":{'
    + '  "alarmTime":"2016-08-24T02:05:09.036Z",'
    + '  "alarmId":3,'
    + '  "alarmObject":2,'
    + '  "alarmSeqNo":0'
    + '},'
    + '"jsonrpc":"2.0"}';
var
  expected, actual: IJsonRpcParsed;
begin
  expected := TJsonRpcParsed.Create(jotNotification,
    TJsonRpcNotificationObject.Create('ALARM', SO('{'
    + '  "alarmTime":"2016-08-24T02:05:09.036Z",'
    + '  "alarmId":3,'
    + '  "alarmObject":2,'
    + '  "alarmSeqNo":0'
    + '}')));
  actual := TJsonRpcMessage.Parse(testMsg);
  CheckEquals(expected.GetMessagePayload.AsJSon,
    actual.GetMessagePayload.AsJSon());
  CheckEquals(GetMessageTypeName(expected.GetMessageType),
    GetMessageTypeName(actual.GetMessageType));
end;

procedure TTestJsonRpc.TestParseRequestOK;
const
  testMsg =
    '{"jsonrpc":"2.0",'
    + '"id":1491225202566,'
    + '"method":"AUTH",'
    + '"params":{'
    + '  "appId":901,'
    + '  "secretWord":"D4A0999956449F3A5DEA3EE29BA8AEBD"'
    + ' }'
    + '}';
var
  expected, actual: IJsonRpcParsed;
begin
  expected := TJsonRpcParsed.Create(jotRequest,
    TJsonRpcRequestObject.Create(1491225202566, 'AUTH',
    SO('{"secretWord":"D4A0999956449F3A5DEA3EE29BA8AEBD","appId":901}')));
  actual := TJsonRpcMessage.Parse(testMsg);
  CheckEquals(expected.GetMessagePayload.AsJSon,
    actual.GetMessagePayload.AsJSon());
  CheckEquals(GetMessageTypeName(expected.GetMessageType),
    GetMessageTypeName(actual.GetMessageType));
end;

procedure TTestJsonRpc.TestParseSuccessStrResultOK;
const
  alarmsJsonStr = '[{"id":503,"alarmId":3,"alarmObject":2,'
    + '"alarmTime":"2016-08-24T02:05:09.036Z"},{"id":2,"alarmId":2,'
    + '"alarmObject":1,"alarmTime":"2016-08-24T05:24:17.017Z"},'
    + '{"id":3,"alarmId":9,"alarmObject":3,'
    + '"alarmTime":"2016-08-24T08:07:22.115Z"}]';
  testMsg = '{"jsonrpc":"2.0","id":503,'
    + '"result":' + alarmsJsonStr + '}';
var
  expected, actual: IJsonRpcParsed;
begin
  expected := TJsonRpcParsed.Create(jotSuccess,
    TJsonRpcSuccessObject.Create(503, SO(alarmsJsonStr)));
  actual := TJsonRpcMessage.Parse(testMsg);
  CheckEquals(expected.GetMessagePayload.AsJSon,
    actual.GetMessagePayload.AsJSon());
  CheckEquals(GetMessageTypeName(expected.GetMessageType),
    GetMessageTypeName(actual.GetMessageType));
end;

initialization
  TestFramework.RegisterTest(TTestJsonRpc.Suite);

end.

 