//
// Author: Dmitriy S. Sinyavskiy, 2016
//
unit ujsonrpc;
{$IFDEF FPC}
{$MODE objfpc}
{$H+} // make string type AnsiString
{$ENDIF}

interface

uses
  Classes,
  SysUtils,
  superobject;

type
  TJsonRpcParsed = class;
  TJsonRpcError = class;
  IJsonRpcParsed = interface;

  IJsonRpcMessage = interface
    ['{8D772760-D6B8-483D-A734-F6D60D845AA5}']
    function AsJSon(indent: boolean = false; escape: boolean = true): string;
    function AsJsonObject: ISuperObject;
  end;

  { TJsonRpcMessage }

  TJsonRpcMessage = class(TInterfacedObject, IJsonRpcMessage)
    class function Request(const id: Int64; const method: string;
      params: ISuperObject): IJsonRpcMessage; overload;
    class function Request(const id: string; const method: string;
      params: ISuperObject): IJsonRpcMessage; overload;
    class function Notification(const method: string;
      params: ISuperObject): IJsonRpcMessage; overload;
    class function Notification(const method: string): IJsonRpcMessage;
      overload;
    class function Success(const id: Int64;
      requestResult: ISuperObject): IJsonRpcMessage; overload;
    class function Success(const id: Int64;
      requestResult: string): IJsonRpcMessage; overload;
    class function Success(const id: string;
      requestResult: ISuperObject): IJsonRpcMessage; overload;
    class function Success(const id: string;
      requestResult: string): IJsonRpcMessage; overload;
    class function Error(const id: Int64;
      errorMsg: IJsonRpcMessage): IJsonRpcMessage; overload;
    class function Error(const id: string;
      errorMsg: IJsonRpcMessage): IJsonRpcMessage; overload;
    class function Error(errorMsg: IJsonRpcMessage): IJsonRpcMessage; overload;
    class function Parse(const s: string): IJsonRpcParsed;
  protected
    FJsonObj: ISuperObject;
  public
    constructor Create();
    function AsJSon(indent: boolean = false; escape: boolean = true):
      string; virtual;
    function AsJsonObject: ISuperObject; virtual;
  end;

  { TJsonRpcRequestObject }

  TJsonRpcRequestObject = class(TJsonRpcMessage, IJsonRpcMessage)
    constructor Create(const id: Int64; const method: string; params:
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
    constructor Create(const id: Int64; result: ISuperObject); overload;
    constructor Create(const id: Int64; result: string); overload;
    constructor Create(const id: string; result: ISuperObject); overload;
    constructor Create(const id: string; result: string); overload;
  end;

  { TJsonRpcErrorObject }

  TJsonRpcErrorObject = class(TJsonRpcMessage, IJsonRpcMessage)
    constructor Create(errorMsg: IJsonRpcMessage); overload;
    constructor Create(const id: Int64; errorMsg: IJsonRpcMessage); overload;
    constructor Create(const id: string; errorMsg: IJsonRpcMessage); overload;
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
    constructor Create(const code: integer; const message: string); overload;
    constructor Create(const code: integer; const message: string;
      data: ISuperObject); overload;
    constructor Create(const code: integer; const message: string;
      data: string); overload;
    function AsJsonObject: ISuperObject;
    function AsJSon(indent: boolean = false; escape: boolean = true): string;
  end;

const
  JSON_RPC_VERSION_2 = '2.0';

  FIELD_JSONRPC = 'jsonrpc';
  FIELD_ID = 'id';
  FIELD_METHOD = 'method';
  FIELD_PARAMS = 'params';
  FIELD_RESULT = 'result';
  FIELD_ERROR = 'error';
  FIELD_ERROR_CODE = 'code';
  FIELD_ERROR_MSG = 'message';
  FIELD_ERROR_DATA = 'data';

  ERROR_INVALID_JSONRPC_VER =
    'Invalid JSON-RPC Version. Supported JSON-RPC 2.0 only';
  ERROR_NO_JSONRPC_FIELD = 'No ''jsonrpc'' field present';
  ERROR_NO_METHOD_FIELD = 'No ''method'' field present';
  ERROR_NO_RESULT_FIELD = 'No ''result'' field present';
  ERROR_NO_ERROR_FIELD = 'No ''error'' field present';
  ERROR_EMPTY_METHOD_FIELD = 'Empty ''method'' field';
  ERROR_INVALID_RESULT_TYPE = 'Invalid ''result'' type';
  ERROR_INVALID_ERROR_OBJ = 'Invalid ''error'' object';

  PRC_ERR_INVALID_REQUEST = 'Invalid Request';
  PRC_ERR_METHOD_NOT_FOUND = 'Method Not Found';
  RPC_ERR_INVALID_PARAMS = 'Invalid Params';
  RPC_ERR_INTERNAL_ERROR = 'Internal Error';
  RPC_ERR_PARSE_ERROR = 'Parse Error';

  CODE_INVALID_REQUEST = -32600;
  CODE_METHOD_NOT_FOUND = -32601;
  CODE_INVALID_PARAMS = -32602;
  CODE_INTERNAL_ERROR = -32603;
  CODE_PARSE_ERROR = -32700;

implementation

const
  S_EMPTY_STR = '';

{ TJsonRpcMessage }

// Creates JSON-RPC 2.0 request
// @param  {Integer} id
// @param  {String} method
// @param  {ISuperObject} [params]: optional
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Request(const id: Int64;
  const method: string; params: ISuperObject): IJsonRpcMessage;
begin
  result := TJsonRpcRequestObject.Create(id, method, params);
end;

// Creates JSON-RPC 2.0 request object
// @param  {String} id
// @param  {String} method
// @param  {ISuperObject} [params]: optional
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Request(const id: string;
  const method: string; params: ISuperObject): IJsonRpcMessage;
begin
  result := TJsonRpcRequestObject.Create(id, method, params);
end;

// Creates JSON-RPC 2.0 notification object
// @param  {String} method
// @param  {ISuperObject} [params]: optional
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Notification(const method: string;
  params: ISuperObject): IJsonRpcMessage;
begin
  Result := TJsonRpcNotificationObject.Create(method, params);
end;

class function TJsonRpcMessage.Notification(const method: string):
  IJsonRpcMessage;
begin
  result := TJsonRpcMessage.Notification(method, nil);
end;

// Creates JSON-RPC 2.0 success object
// @param  {Integer} id
// @param  {ISuperObject} requestResult
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Success(const id: Int64;
  requestResult: ISuperObject): IJsonRpcMessage;
begin
  result := TJsonRpcSuccessObject.Create(id, requestResult);
end;

// Creates JSON-RPC 2.0 success object
// @param  {Integer} id
// @param  {string} requestResult
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Success(const id: Int64;
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

// Creates JSON-RPC 2.0 error object
// @param  {integer} id
// @param  {ISuperObject} error
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Error(const id: Int64;
  errorMsg: IJsonRpcMessage): IJsonRpcMessage;
begin
  result := TJsonRpcErrorObject.Create(id, errorMsg);
end;
// Creates JSON-RPC 2.0 error object
// @param  {string} id
// @param  {ISuperObject} error
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Error(const id: string;
  errorMsg: IJsonRpcMessage): IJsonRpcMessage;
begin
  result := TJsonRpcErrorObject.Create(id, errorMsg);
end;

// Creates JSON-RPC 2.0 error object
// @param  {ISuperObject} error
// @return {ISuperObject} JsonRpc object

class function TJsonRpcMessage.Error(errorMsg: IJsonRpcMessage):
  IJsonRpcMessage;
begin
  result := TJsonRpcErrorObject.Create(errorMsg);
end;

//
// @return TJsonRpcParsed
//

class function TJsonRpcMessage.Parse(const s: string): IJsonRpcParsed;

  function SubCheckHeader(AJsonObj: ISuperObject;
    var FoundError: IJsonRpcParsed): boolean;
  var
    errData: TJsonRpcError;
  begin
    result := False;
    if not AJsonObj.AsObject.Exists(FIELD_JSONRPC) then
    begin
      errData := TJsonRpcError.InvalidRequest(SO(ERROR_NO_JSONRPC_FIELD));
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(errData));
      Exit;
    end;
    if AJsonObj.S[FIELD_JSONRPC] <> JSON_RPC_VERSION_2 then
    begin
      errData := TJsonRpcError.invalidRequest(SO(ERROR_INVALID_JSONRPC_VER));
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(errData));
      Exit;
    end;
    result := True;
  end;

  function SubIdPresentAndNotNull(AJsonObj: ISuperObject): boolean;
  begin
    result := AJsonObj.AsObject.Exists(FIELD_ID)
      and not ((AJsonObj.O[FIELD_ID].DataType = stNull)
      and (AJsonObj.N[FIELD_ID] = nil))
      and (
      ((AJsonObj.O[FIELD_ID].DataType = stString)
      and (AJsonObj.S[FIELD_ID] <> S_EMPTY_STR))
      or
      (AJsonObj.O[FIELD_ID].DataType = stInt)
      );
  end;

  function SubCheckMethod(AJsonObj: ISuperObject; var FoundError:
    IJsonRpcParsed;
    var FoundMethod: string): boolean;
  var
    errData: TJsonRpcError;
  begin
    result := False;
    if not AJsonObj.AsObject.Exists(FIELD_METHOD) then
    begin
      errData := TJsonRpcError.InvalidRequest(ERROR_NO_METHOD_FIELD);
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(errData));
      Exit;
    end;
    FoundMethod := AJsonObj.S[FIELD_METHOD];
    if length(FoundMethod) = 0 then
    begin
      errData := TJsonRpcError.methodNotFound(ERROR_EMPTY_METHOD_FIELD);
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(errData));
      Exit;
    end;
    result := True;
  end;

  function SubCheckResult(AJsonObj: ISuperObject;
    var FoundError: IJsonRpcParsed): boolean;
  const
    ValidDataTypes = [stInt, stString, stObject, stArray];
  var
    errData: TJsonRpcError;
  begin
    Result := false;
    if not AJsonObj.AsObject.Exists(FIELD_RESULT) then
    begin
      errData := TJsonRpcError.invalidRequest(SO(ERROR_NO_RESULT_FIELD));
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(AJsonObj.S[FIELD_ID], errData));
      Exit;
    end;
    if not (AJsonObj.O[FIELD_RESULT].DataType in ValidDataTypes) then
    begin
      errData := TJsonRpcError.InvalidRequest(SO(ERROR_INVALID_RESULT_TYPE));
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(AJsonObj.S[FIELD_ID], errData));
      Exit;
    end;
    Result := True;
  end;

  function SubCheckError(AJsonObj: ISuperObject;
    var FoundError: IJsonRpcParsed): boolean;
  var
    errObj: ISuperObject;
  begin
    Result := false;
    if not AJsonObj.AsObject.Exists(FIELD_ERROR) then
    begin
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(AJsonObj.S[FIELD_ID],
        TJsonRpcError.InvalidParams(SO(ERROR_NO_ERROR_FIELD))));
      Exit;
    end;
    errObj := AJsonObj.O[FIELD_ERROR];
    if not (
      (errObj.DataType = stObject)
      and errObj.AsObject.Exists(FIELD_ERROR_CODE)
      and (errObj.O[FIELD_ERROR_CODE].DataType = stInt)
      and errObj.AsObject.Exists(FIELD_ERROR_MSG)
      and (errObj.O[FIELD_ERROR_MSG].DataType = stString)
      ) then
    begin
      FoundError := TJsonRpcParsed.Create(jotInvalid,
        TJsonRpcErrorObject.Create(AJsonObj.S[FIELD_ID],
        TJsonRpcError.InvalidParams(SO(ERROR_INVALID_ERROR_OBJ))));
      Exit;
    end;
    Result := True;
  end;

  function SubParseObject(AJsonObj: ISuperObject): IJsonRpcParsed;
  var
    method: string;
    params: ISuperObject;
    errorObj: ISuperObject;
  begin
    if not (SubCheckHeader(AJsonObj, Result)) then
      Exit;

    params := SO([]);
    if AJsonObj.AsObject.Exists(FIELD_PARAMS) then
      params := AJsonObj.O[FIELD_PARAMS];

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
      case AJsonObj.O[FIELD_ID].DataType of
        stInt:
          result := TJsonRpcParsed.Create(jotRequest,
            TJsonRpcMessage.Request(AJsonObj.I[FIELD_ID], method, params));
        stString:
          result := TJsonRpcParsed.Create(jotRequest,
            TJsonRpcMessage.Request(AJsonObj.S[FIELD_ID], method, params));
      end;
      Exit;
    end
    else
    begin // когда нет поля METHOD
      // check for success MESSAGE (id, result)
      if AJsonObj.AsObject.Exists(FIELD_RESULT) then
      begin
        if not SubCheckResult(AJsonObj, result) then
          Exit;
        case AJsonObj.O[FIELD_ID].DataType of
          stInt:
            result := TJsonRpcParsed.Create(jotSuccess,
              TJsonRpcMessage.Success(AJsonObj.I[FIELD_ID],
              AJsonObj.O[FIELD_RESULT]));
          stString:
            result := TJsonRpcParsed.Create(jotSuccess,
              TJsonRpcMessage.Success(AJsonObj.S[FIELD_ID],
              AJsonObj.O[FIELD_RESULT]));
        end;
        Exit;
      end;

      // check for ERROR MESSAGE (id, error)
      if AJsonObj.AsObject.Exists(FIELD_ERROR) then
      begin
        if not SubCheckError(AJsonObj, result) then
          Exit;
        errorObj := AJsonObj.O[FIELD_ERROR];

        case AJsonObj.O[FIELD_ID].DataType of
          stInt:
            result := TJsonRpcParsed.Create(jotError,
              TJsonRpcMessage.Error(AJsonObj.I[FIELD_ID], TJsonRpcError.Create(
              errorObj.I[FIELD_ERROR_CODE],
              errorObj.S[FIELD_ERROR_MSG],
              errorObj.N[FIELD_ERROR_DATA])));
          stString:
            result := TJsonRpcParsed.Create(jotError,
              TJsonRpcMessage.Error(AJsonObj.S[FIELD_ID], TJsonRpcError.Create(
              errorObj.I[FIELD_ERROR_CODE],
              errorObj.S[FIELD_ERROR_MSG],
              errorObj.N[FIELD_ERROR_DATA])));
        end;
        Exit;
      end;

      // not found: result or error -> corrupted request, if it has the ID!
      // Have: id
      if Assigned(result) then // error inside
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
  FJsonObj.S[FIELD_JSONRPC] := JSON_RPC_VERSION_2;
end;

{ TJsonRpcSuccessObject }

constructor TJsonRpcSuccessObject.Create(const id: Int64; result:
  ISuperObject);
begin
  inherited Create();
  FJsonObj.I[FIELD_ID] := id;
  FJsonObj.O[FIELD_RESULT] := result;
end;

constructor TJsonRpcSuccessObject.Create(const id: Int64; result: string);
begin
  inherited Create();
  FJsonObj.I[FIELD_ID] := id;
  FJsonObj.S[FIELD_RESULT] := result;
end;

constructor TJsonRpcSuccessObject.Create(const id: string; result:
  ISuperObject);
begin
  inherited Create();
  FJsonObj.S[FIELD_ID] := id;
  FJsonObj.O[FIELD_RESULT] := result;
end;

constructor TJsonRpcSuccessObject.Create(const id: string; result: string);
begin
  inherited Create();
  FJsonObj.S[FIELD_ID] := id;
  FJsonObj.S[FIELD_RESULT] := result;
end;

{ TJsonRpcErrorObject }

constructor TJsonRpcErrorObject.Create(errorMsg: IJsonRpcMessage);
begin
  inherited Create();
  FJsonObj.N[FIELD_ID] := nil;
  FJsonObj.O[FIELD_ERROR] := errorMsg.AsJsonObject;
end;

constructor TJsonRpcErrorObject.Create(const id: Int64; errorMsg:
  IJsonRpcMessage);
begin
  inherited Create();
  FJsonObj.I[FIELD_ID] := id;
  FJsonObj.O[FIELD_ERROR] := errorMsg.AsJsonObject;
end;

constructor TJsonRpcErrorObject.Create(const id: string; errorMsg:
  IJsonRpcMessage);
begin
  inherited Create();
  FJsonObj.S[FIELD_ID] := id;
  FJsonObj.O[FIELD_ERROR] := errorMsg.AsJsonObject;
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
  FJsonObj.S[FIELD_METHOD] := method;
  FJsonObj.N[FIELD_PARAMS] := params;
end;

constructor TJsonRpcNotificationObject.Create(const method: string);
begin
  Create(method, nil);
end;

{ TJsonRpcRequestObject }

constructor TJsonRpcRequestObject.Create(const id: Int64; const method:
  string;
  params: ISuperObject);
begin
  inherited Create();
  FJsonObj.I[FIELD_ID] := id;
  FJsonObj.S[FIELD_METHOD] := method;
  FJsonObj.O[FIELD_PARAMS] := params;
end;

constructor TJsonRpcRequestObject.Create(const id: string; const method: string;
  params: ISuperObject);
begin
  inherited Create();
  FJsonObj.s[FIELD_ID] := id;
  FJsonObj.S[FIELD_METHOD] := method;
  FJsonObj.O[FIELD_PARAMS] := params;
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
  result := TJsonRpcError.Create(CODE_PARSE_ERROR, RPC_ERR_PARSE_ERROR, data);
end;

class function TJsonRpcError.InvalidRequest(data: ISuperObject): TJsonRpcError;
begin
  result := TJsonRpcError.Create(CODE_INVALID_REQUEST, PRC_ERR_INVALID_REQUEST,
    data);
end;

class function TJsonRpcError.InvalidRequest(data: string): TJsonRpcError;
begin
  result := TJsonRpcError.Create(CODE_INVALID_REQUEST, PRC_ERR_INVALID_REQUEST,
    data);
end;

class function TJsonRpcError.MethodNotFound(data: ISuperObject): TJsonRpcError;
begin
  result := TJsonRpcError.Create(CODE_METHOD_NOT_FOUND,
    PRC_ERR_METHOD_NOT_FOUND, data);
end;

class function TJsonRpcError.MethodNotFound(data: string): TJsonRpcError;
begin
  result := TJsonRpcError.Create(CODE_METHOD_NOT_FOUND,
    PRC_ERR_METHOD_NOT_FOUND, data);
end;

class function TJsonRpcError.InvalidParams(data: ISuperObject): TJsonRpcError;
begin
  result := TJsonRpcError.Create(CODE_INVALID_PARAMS, RPC_ERR_INVALID_PARAMS,
    data);
end;

class function TJsonRpcError.InvalidParams(data: string): TJsonRpcError;
begin
  result := TJsonRpcError.Create(CODE_INVALID_PARAMS, RPC_ERR_INVALID_PARAMS,
    data);
end;

class function TJsonRpcError.InternalError(data: ISuperObject): TJsonRpcError;
begin
  result := TJsonRpcError.Create(CODE_INTERNAL_ERROR, RPC_ERR_INTERNAL_ERROR,
    data);
end;

class function TJsonRpcError.InternalError(data: string): TJsonRpcError;
begin
  result := TJsonRpcError.Create(CODE_INTERNAL_ERROR, RPC_ERR_INTERNAL_ERROR,
    data);
end;

function TJsonRpcError.AsJsonObject: ISuperObject;
begin
  Result := FJsonObj.Clone;
end;

function TJsonRpcError.AsJSon(indent: boolean = false; escape: boolean = true):
  string;
begin
  Result := FJsonObj.AsJSon(indent, escape);
end;

constructor TJsonRpcError.Create(const code: integer;
  const message: string);
begin
  FJsonObj := SO();
  FJsonObj.I[FIELD_ERROR_CODE] := code;
  FJsonObj.S[FIELD_ERROR_MSG] := message;
end;

{ TJsonRpcError }

constructor TJsonRpcError.Create(const code: integer;
  const message: string; data: ISuperObject);
begin
  Create(code, message);
  FJsonObj.N[FIELD_ERROR_DATA] := data;
end;

constructor TJsonRpcError.Create(const code: integer;
  const message: string; data: string);
begin
  Create(code, message);
  FJsonObj.S[FIELD_ERROR_DATA] := data;
end;

function TJsonRpcMessage.AsJSon(indent: boolean = false;
  escape: boolean = true): string;
begin
  Result := FJsonObj.AsJSon(indent, escape);
end;

function TJsonRpcMessage.AsJsonObject: ISuperObject;
begin
  Result := FJsonObj.Clone;
end;

end.
