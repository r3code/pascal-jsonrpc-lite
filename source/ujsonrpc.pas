unit ujsonrpc;
//{$mode objfpc}
interface
uses
  Classes,
  SysUtils,
  superobject;
type
  TJsonRpcParsed = class;
  TJsonRpcError = class;

  IJsonRpcMessage = interface
    ['{8D772760-D6B8-483D-A734-F6D60D845AA5}']
    function AsJSon(indent: boolean = false; escape: boolean = true): string;
    function asJsonObject: ISuperObject;
  end;

  { TJsonRpcMessage }

  TJsonRpcMessage = class(TInterfacedObject, IJsonRpcMessage)
    class function Request(const id: integer; const method: string;
      params: ISuperObject): IJsonRpcMessage; overload;
    class function Request(const id: string; const method: string;
      params: ISuperObject): IJsonRpcMessage; overload;
    class function Notification(const method: string;
      params: ISuperObject): IJsonRpcMessage; overload;
    class function Notification(const method: string): IJsonRpcMessage; overload;
    class function Success(const id: integer;
      requestResult: ISuperObject): IJsonRpcMessage; overload;
    class function Success(const id: integer;
      requestResult: string): IJsonRpcMessage; overload;
    class function Success(const id: string;
      requestResult: ISuperObject): IJsonRpcMessage; overload;
    class function Success(const id: string;
      requestResult: string): IJsonRpcMessage; overload;
    class function Error(const id: integer;
      error: IJsonRpcMessage): IJsonRpcMessage; overload;
    class function Error(const id: string;
      error: IJsonRpcMessage): IJsonRpcMessage; overload;
    class function Error(error: IJsonRpcMessage): IJsonRpcMessage; overload;
    class function Parse(const s: string): TJsonRpcParsed;
    // данные о разборе
  protected
    FJsonObj: ISuperObject;
  public
    constructor Create();
    function AsJSon(indent: boolean = false; escape: boolean = true): string; virtual;
    function asJsonObject: ISuperObject; virtual;
  end;
  { TJsonRpcRequestObject }
  TJsonRpcRequestObject = class(TJsonRpcMessage, IJsonRpcMessage)
    constructor Create(const id: integer; const method: string; params:
      ISuperObject); overload;
    constructor Create(const id: string; const method: string; params:
      ISuperObject); overload;
  end;
  { TJsonRpcNotificationObject }
  TJsonRpcNotificationObject = class(TJsonRpcMessage, IJsonRpcMessage)
    constructor Create(const method: string; params: ISuperObject); overload;
    constructor Create(const method: string); overload;
  end;
  { TJsonRpcSuccess }
  TJsonRpcSuccessObject = class(TJsonRpcMessage, IJsonRpcMessage)
    constructor Create(const id: integer; result: ISuperObject); overload;
    constructor Create(const id: integer; result: string); overload;
    constructor Create(const id: string; result: ISuperObject); overload;
    constructor Create(const id: string; result: string); overload;
  end;
  { TJsonRpcErrorObject }
  TJsonRpcErrorObject = class(TJsonRpcMessage, IJsonRpcMessage)
    constructor Create(error: IJsonRpcMessage); overload;
    constructor Create(const id: integer; error: IJsonRpcMessage); overload;
    constructor Create(const id: string; error: IJsonRpcMessage); overload;
  end;

  { TJsonRpcObjectType }

  TJsonRpcObjectType = (jotInvalid, jotRequest, jotNotification, jotSuccess,
    jotError);

  { IJsonRpcParsed }

  IJsonRpcParsed = interface
    ['{21269C35-6E3D-4FDF-A5F5-9F4FB9EFC042}']
    function GetMessageType: TJsonRpcObjectType;
    function GetMessagePayload: IJsonRpcMessage;
  end;

  { TJsonRpcParsed }

  TJsonRpcParsed = class(TInterfacedObject, IJsonRpcParsed)
  private
    FObjType: TJsonRpcObjectType;
    FPayload: IJsonRpcMessage;
  public
    constructor Create(const objType: TJsonRpcObjectType;
      Payload: IJsonRpcMessage);
    function GetMessageType: TJsonRpcObjectType;
    function GetMessagePayload: IJsonRpcMessage;
  end;

  { TJsonRpcError }

  TJsonRpcError = class(TInterfacedObject, IJsonRpcMessage)
  class function Error(const code: integer; const message: string; data:
      ISuperObject): TJsonRpcError; overload;
  class function Error(const code: integer; const message: string; dataStr:
    string): TJsonRpcError; overload;
  class function ParseError(data: string): TJsonRpcError;
  class function InvalidRequest(data: ISuperObject): TJsonRpcError; overload;
  class function InvalidRequest(data: string): TJsonRpcError; overload;
  class function MethodNotFound(data: ISuperObject): TJsonRpcError; overload;
  class function MethodNotFound(data: string): TJsonRpcError; overload;
  class function InvalidParams(data: ISuperObject): TJsonRpcError; overload;
  class function InvalidParams(data: string): TJsonRpcError; overload;
  class function InternalError(data: ISuperObject): TJsonRpcError; overload;
  class function InternalError(data: string): TJsonRpcError; overload;
  private
    FJsonObj: ISuperObject;
  public
    constructor Create(const code: integer; const message: string; data:
      ISuperObject); overload;
    constructor Create(const code: integer; const message: string; data:
      string); overload;
    function asJsonObject: ISuperObject;
    function AsJSon(indent: boolean = false; escape: boolean = true): string;
  end;
  
implementation
{ TJsonRpcSuccessObject }

constructor TJsonRpcSuccessObject.Create(const id: integer; result:
  ISuperObject);
begin
  inherited Create();
  FJsonObj.I['id'] := id;
  FJsonObj.O['result'] := result;
end;

constructor TJsonRpcSuccessObject.Create(const id: integer; result: string);
begin
  inherited Create();
  FJsonObj.I['id'] := id;
  FJsonObj.S['result'] := result;
end;

constructor TJsonRpcSuccessObject.Create(const id: string; result:
  ISuperObject);
begin
  inherited Create();
  FJsonObj.S['id'] := id;
  FJsonObj.O['result'] := result;
end;

constructor TJsonRpcSuccessObject.Create(const id: string; result: string);
begin
  inherited Create();
  FJsonObj.S['id'] := id;
  FJsonObj.S['result'] := result;
end;
{ TJsonRpcErrorObject }

constructor TJsonRpcErrorObject.Create(error: IJsonRpcMessage);
begin
  inherited Create();
  FJsonObj.N['id'] := nil;
  FJsonObj.O['error'] := error.asJsonObject;
end;

constructor TJsonRpcErrorObject.Create(const id: integer; error: IJsonRpcMessage);
begin
  inherited Create();
  FJsonObj.I['id'] := id;
  FJsonObj.O['error'] := error.asJsonObject;
end;

constructor TJsonRpcErrorObject.Create(const id: string; error: IJsonRpcMessage);
begin
  inherited Create();
  FJsonObj.S['id'] := id;
  FJsonObj.O['error'] := error.asJsonObject;
end;
{ TJsonRpcParsed }

constructor TJsonRpcParsed.Create(const objType: TJsonRpcObjectType;
  Payload: IJsonRpcMessage);
begin
  inherited Create();
  FObjType := objType;
  FPayload := Payload;
end;

function TJsonRpcParsed.GetMessageType: TJsonRpcObjectType;
begin
  result := FObjType;
end;

function TJsonRpcParsed.GetMessagePayload: IJsonRpcMessage;
begin
  result := FPayload;
end;
{ TJsonRpcNotificationObject }

constructor TJsonRpcNotificationObject.Create(const method: string;
  params: ISuperObject);
begin
  inherited Create();
  FJsonObj.N['id'] := nil;
  FJsonObj.S['method'] := method;
  FJsonObj.N['params'] := params;
end;

constructor TJsonRpcNotificationObject.Create(const method: string);
begin
  Create(method, nil);
end;

{ TJsonRpcRequestObject }

constructor TJsonRpcRequestObject.Create(const id: integer; const method:
  string;
  params: ISuperObject);
begin
  inherited Create();
  FJsonObj.I['id'] := id;
  FJsonObj.S['method'] := method;
  FJsonObj.O['params'] := params;
end;

constructor TJsonRpcRequestObject.Create(const id: string; const method: string;
  params: ISuperObject);
begin
  inherited Create();
  FJsonObj.s['id'] := id;
  FJsonObj.S['method'] := method;
  FJsonObj.O['params'] := params;
end;
{ TJsonRpcMessage }

// Создает JSON-RPC 2.0 объект-request
// @param  {Integer} id
// @param  {String} method
// @param  {ISuperObject} [params]: optional
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Request(const id: integer;
  const method: string; params: ISuperObject): IJsonRpcMessage;
begin
  result := TJsonRpcRequestObject.Create(id, method, params);
end;
// Создает JSON-RPC 2.0 объект-request
// @param  {String} id
// @param  {String} method
// @param  {ISuperObject} [params]: optional
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Request(const id: string;
  const method: string; params: ISuperObject): IJsonRpcMessage;
begin
  result := TJsonRpcRequestObject.Create(id, method, params);
end;
// Создает JSON-RPC 2.0 объект-notification
// @param  {String} method
// @param  {ISuperObject} [params]: optional
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Notification(const method: string;
  params: ISuperObject): IJsonRpcMessage;
begin
  Result := TJsonRpcNotificationObject.Create(method, params);
end;

class function TJsonRpcMessage.Notification(const method: string): IJsonRpcMessage;
begin
  result := TJsonRpcMessage.Notification(method, nil);
end;

// Создает JSON-RPC 2.0 объект-success
// @param  {Integer} id
// @param  {ISuperObject} requestResult
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Success(const id: integer;
  requestResult: ISuperObject): IJsonRpcMessage;
begin
  result := TJsonRpcSuccessObject.Create(id, requestResult);
end;
// Создает JSON-RPC 2.0 объект-success
// @param  {Integer} id
// @param  {string} requestResult
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Success(const id: integer;
  requestResult: string): IJsonRpcMessage;
begin
  result := TJsonRpcSuccessObject.Create(id, requestResult);
end;

class function TJsonRpcMessage.Success(const id: string;
  requestResult: ISuperObject): IJsonRpcMessage;
begin
  result := TJsonRpcSuccessObject.Create(id, requestResult);
end;

class function TJsonRpcMessage.Success(const id: string;
  requestResult: string): IJsonRpcMessage;
begin
  result := TJsonRpcSuccessObject.Create(id, requestResult);
end;


// Создает JSON-RPC 2.0 объект-error
// @param  {integer} id
// @param  {ISuperObject} error
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Error(const id: integer;
  error: IJsonRpcMessage): IJsonRpcMessage;
begin
  result := TJsonRpcErrorObject.Create(id, error);
end;
// Создает JSON-RPC 2.0 объект-error
// @param  {string} id
// @param  {ISuperObject} error
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Error(const id: string;
  error: IJsonRpcMessage): IJsonRpcMessage;
begin
  result := TJsonRpcErrorObject.Create(id, error);
end;

// Создает JSON-RPC 2.0 объект-error
// @param  {ISuperObject} error
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Error(error: IJsonRpcMessage): IJsonRpcMessage;
begin
  result := TJsonRpcErrorObject.Create(error);
end;
//
// @return TJsonRpcParsed
//

class function TJsonRpcMessage.Parse(const s: string): TJsonRpcParsed;
  function SubCheckHeader(AJsonObj: ISuperObject;
    var FoundError: TJsonRpcParsed): boolean;
  var errData: TJsonRpcError;
  begin
    result := False;
    if not AJsonObj.AsObject.Exists('jsonrpc') then
    begin
      errData := TJsonRpcError.InvalidRequest(SO('No jsonrpc field'));
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(errData));
      Exit;
    end;
    if AJsonObj.S['jsonrpc'] <> '2.0' then
    begin
      errData := TJsonRpcError.invalidRequest(SO('Invalid JsonRpc Version'));
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(errData));
      Exit;
    end;
    result := True;
  end;

  function SubIdPresentAndNotNull(AJsonObj: ISuperObject): boolean;
  begin
    result := AJsonObj.AsObject.Exists('id')
      and not ((AJsonObj.O['id'].DataType = stNull) and (AJsonObj.N['id'] = nil))
      and (
      ((AJsonObj.O['id'].DataType = stString) and (AJsonObj.S['id'] <> ''))
      or
      (AJsonObj.O['id'].DataType = stInt)
      );
  end;

  function SubCheckMethod(AJsonObj: ISuperObject; var FoundError: TJsonRpcParsed;
    var FoundMethod: string): boolean;
  var
    errData: TJsonRpcError;
  begin
    result := False;
    if not AJsonObj.AsObject.Exists('method') then
    begin
      errData := TJsonRpcError.invalidRequest(SO('No Method field'));
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(errData));
      Exit;
    end;
    FoundMethod := AJsonObj.S['method'];
    if length(FoundMethod) = 0 then
    begin
      errData := TJsonRpcError.methodNotFound(SO('Empty Method field'));
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(errData));
        Exit;
    end;
    result := True;
  end;

  function SubCheckResult(AJsonObj: ISuperObject;
    var FoundError: TJsonRpcParsed): boolean;
  var errData: TJsonRpcError;
  begin
    Result := false;
    if not AJsonObj.AsObject.Exists('result') then
    begin
      errData := TJsonRpcError.invalidRequest(SO('No Result field'));
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(AJsonObj.S['id'], errData));
      Exit;
    end;
    if not (AJsonObj.O['result'].DataType in [stInt, stString, stObject]) then
    begin
      errData := TJsonRpcError.InvalidRequest(SO('Invalid Result type'));
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(AJsonObj.S['id'], errData));
      Exit;
    end;
    Result := True;
  end;

  function SubCheckError(AJsonObj: ISuperObject;
    var FoundError: TJsonRpcParsed): boolean;
  var
    errObj: ISuperObject;
  begin
    Result := false;
    if not AJsonObj.AsObject.Exists('error') then
    begin
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(AJsonObj.S['id'],
        TJsonRpcError.InvalidParams(SO('No Error field'))));
      Exit;
    end;
    errObj := AJsonObj.O['error'];
    if not (
      (errObj.DataType = stObject)
      and errObj.AsObject.Exists('code') and (errObj.O['code'].DataType = stInt)
      and errObj.AsObject.Exists('message')
      and (errObj.O['message'].DataType = stString)
      ) then
    begin
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(AJsonObj.S['id'],
        TJsonRpcError.InvalidParams(SO('Invalid Error Object'))));
      Exit;
    end;
    Result := True;
  end;

  function SubParseObject(AJsonObj: ISuperObject): TJsonRpcParsed;
  var
    idStr: string;
    method: string;
    params: ISuperObject;
    errorObj: ISuperObject;
  begin
    if not (SubCheckHeader(AJsonObj, Result)) then
      Exit;

    params := SO([]);
    if AJsonObj.AsObject.Exists('params') then
      params := AJsonObj.O['params'];

    // Если уведомление id - нет или null, method - обязательно,
    // params - json-объект может быть пропущено.
    if not SubIdPresentAndNotNull(AJsonObj) then
    begin
      if not SubCheckMethod(AJsonObj, result, method) then
        Exit;
      result := TJsonRpcParsed.Create(jotNotification,
        TJsonRpcMessage.Notification(method, params));
      Exit;
    end;
    // Имеем Id - String или Int
    // Наверное это: запрос или ответ или ошибка
    if SubCheckMethod(AJsonObj, result, method) then
    begin
      idStr := AJsonObj.S['id'];
      result := TJsonRpcParsed.Create(jotRequest,
        TJsonRpcMessage.Request(idStr, method, params));
      Exit;
    end
    else
    begin
      if Assigned(result) then // eeror inside
        Exit;
      // Это success MESSAGE
      if AJsonObj.AsObject.Exists('result') then
      begin
        if not SubCheckResult(AJsonObj, result) then
          Exit;
        result := TJsonRpcParsed.Create(jotSuccess,
          TJsonRpcMessage.Success(idStr, AJsonObj.O['result']));
        Exit;
      end;
      // ERROR MESSAGE
      if AJsonObj.AsObject.Exists('error') then
      begin
        if not SubCheckError(AJsonObj, result) then
          Exit;
        errorObj := AJsonObj.O['error'];

        result := TJsonRpcParsed.Create(jotError,
          TJsonRpcMessage.Error(idStr, TJsonRpcError.Create(
            errorObj.I['code'], errorObj.S['message'], errorObj.N['data'])));
        Exit;
      end;
      result := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcError.InternalError(AJsonObj));
      Exit;
    end;
    result := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcError.InternalError(AJsonObj));
  end;
var
  parsedObj: ISuperObject;
begin
  parsedObj := SO(s);
  if not Assigned(parsedObj) then
  begin
    Result := TJsonRpcParsed.Create(jotInvalid,
      TJsonRpcErrorObject.Create(TJsonRpcError.ParseError(s)));
    Exit;
  end;
  Result := SubParseObject(parsedObj);
end;

constructor TJsonRpcMessage.Create;
begin
  FJsonObj := SO();
  FJsonObj.S['version'] := '2.0';
end;

{ TJsonRpcError }

class function TJsonRpcError.Error(const code: integer; const message: string;
  data: ISuperObject): TJsonRpcError;
begin
  Result := TJsonRpcError.Create(code, message, data);
end;

class function TJsonRpcError.Error(const code: integer; const message: string;
  dataStr: string): TJsonRpcError;
begin
  result := TJsonRpcError.Create(code, message, dataStr);
end;

class function TJsonRpcError.ParseError(data: string): TJsonRpcError;
begin
  result := TJsonRpcError.Create(-32700, 'Parse Error', data);
end;

class function TJsonRpcError.InvalidRequest(data: ISuperObject): TJsonRpcError;
begin
  result := TJsonRpcError.Create(-32600, 'Invalid Request', data);
end;

class function TJsonRpcError.InvalidRequest(data: string): TJsonRpcError;
begin
  result := TJsonRpcError.Create(-32600, 'Invalid Request', data);
end;

class function TJsonRpcError.MethodNotFound(data: ISuperObject): TJsonRpcError;
begin
  result := TJsonRpcError.Create(-32601, 'Method Not Found', data);
end;

class function TJsonRpcError.MethodNotFound(data: string): TJsonRpcError;
begin
  result := TJsonRpcError.Create(-32601, 'Method Not Found', data);
end;

class function TJsonRpcError.InvalidParams(data: ISuperObject): TJsonRpcError;
begin
  result := TJsonRpcError.Create(-32602, 'Invalid Params', data);
end;

class function TJsonRpcError.InvalidParams(data: string): TJsonRpcError;
begin
  result := TJsonRpcError.Create(-32602, 'Invalid Params', data);
end;

class function TJsonRpcError.InternalError(data: ISuperObject): TJsonRpcError;
begin
  result := TJsonRpcError.Create(-32603, 'Internal Error', data);
end;

class function TJsonRpcError.InternalError(data: string): TJsonRpcError;
begin
  result := TJsonRpcError.Create(-32603, 'Internal Error', data);
end;

function TJsonRpcError.asJsonObject: ISuperObject;
begin
  Result := FJsonObj.Clone;
end;

function TJsonRpcError.AsJSon(indent: boolean = false; escape: boolean = true): string;
begin
  Result := FJsonObj.AsJSon(indent, escape);
end;

{ TJsonRpcError }

constructor TJsonRpcError.Create(const code: integer;
  const message: string; data: ISuperObject);
begin
  FJsonObj := SO();
  FJsonObj.I['code'] := code;
  FJsonObj.S['message'] := message;
  FJsonObj.N['data'] := data;
end;

constructor TJsonRpcError.Create(const code: integer;
  const message: string; data: string);
begin
  FJsonObj := SO();
  FJsonObj.I['code'] := code;
  FJsonObj.S['message'] := message;
  FJsonObj.S['data'] := data;
end;

function TJsonRpcMessage.AsJSon(indent: boolean = false; escape: boolean = true): string;
begin
  Result := FJsonObj.AsJSon(indent, escape);
end;


function TJsonRpcMessage.asJsonObject: ISuperObject;
begin
  Result := FJsonObj.Clone;
end;

end.
