# Pascal JSON-RPC lite

Parse and Serialize JSON-RPC2 messages in free-pascal or Delphi application.
Git Repository: https://github.com/r3code/pascal-json-rpc-lite

Inspired by https://github.com/teambition/jsonrpc-lite.

**A implementation of [JSON-RPC 2.0 specifications](http://jsonrpc.org/specification)**

## Install

1. Download.
2. Extract.
3. Add ujsonrpc.pas to your project or add path to ujsonrpc.pas to Lib Path.
4. ```pascal
uses ujsonrpc;
```

## API

### Interface: IJsonRpcMessage
  
#### Method: IJsonRpcMessage.AsJsonObject
Returns object as ISuperObject clonned form internal JSON-object.    

#### Method: IJsonRpcMessage.AsJSon(indent: boolean = false; escape: boolean = true): string;
Returns a JSON string object representation.     

- `indent`: {boolean} indent resulting JSON
- `escape`: {boolean} escape special chars

### Class: TJsonRpcMessage

##### Class Method: TJsonRpcMessage.Request(id, method, params)
Creates a JSON-RPC 2.0 request object, return IJsonRpcMessage object.
Realizes IJsonRpcMessage.

- `id`: {String|Integer}
- `method`: {String}
- `params`:  {IJsonRpcMessage}

```pascal
var requestObj: TJsonRpcMessage; 
requestObj := TJsonRpcMessage.Request('123', 'update', SO('{list: [1, 2, 3]}'));
writeln(requestObj.asString);
// {
//   jsonrpc: '2.0',
//   id: '123',
//   method: 'update',
//   params: {list: [1, 2, 3]}
// }
```

##### Class Method: TJsonRpcMessage.Notification(method, params)
Creates a JSON-RPC 2.0 notification object, return IJsonRpcMessage object.

- `method`: {String}
- `params`:  {IJsonRpcMessage}

```pascal
var notificationObj: TJsonRpcMessage;
notificationObj := TJsonRpcMessage.notification('update', SO('{list: [1, 2, 3]}'));
writeln(notificationObj.asString);
// {
//   jsonrpc: '2.0',
//   method: 'update',
//   params: {list: [1, 2, 3]}
// }
```

#### Class Method: TJsonRpcMessage.Success(id, result)
Creates a JSON-RPC 2.0 success response object, return IJsonRpcMessage object.

- `id`: {String|Integer}
- `result`:  {IJsonRpcMessage} 

```pascal
var msg: TJsonRpcMessage;
msg := TJsonRpcMessage.success('123', 'OK');
writeln(msg.asString);
// {
//   jsonrpc: '2.0',
//   id: '123',
//   result: 'OK',
// }
```

#### Class Method: TJsonRpcMessage.Error(id, error)
Creates a JSON-RPC 2.0 error response object, return IJsonRpcMessage object.

- `id`: {String|Integer}
- `error`: {IJsonRpcMessage} use TJsonRpcError or it's siblings 

```pascal
var msg: TJsonRpcMessage;
msg := TJsonRpcMessage.Error('123', TJsonRpcError.Create(-32000, 'some error', 'blabla'));
writeln(msg.asString);
// {
//   jsonrpc: '2.0',
//   id: '123',
//   error: {code: -32000, 'message': 'some error', data: 'blabla'},
// }
```

#### Class Method: TJsonRpcMessage.Parse(s)
Takes a JSON-RPC 2.0 payload (string) and tries to parse it into a JSON. 
If successful, determine what object is it (response, notification, success, 
error, or invalid), and return it's type and properly formatted object.

- `s`: {String}

returns an object of IJsonRpcParsed.

### Enum: TJsonRpcObjectType
Shows the type of message detected during Parse.
Types: jotInvalid, jotRequest, jotNotification, jotSuccess, jotError.

### Interface: IJsonRpcParsed

#### Method: IJsonRpcParsed.GetMessageType
Returns one of TJsonRpcObjectType.

#### Method: IJsonRpcParsed.GetMessagePayload
Returns stored ref to IJsonRpcMessage.


### Class: TJsonRpcParsed
Realizes interface IJsonRpcParsed.

#### Constructor: TJsonRpcParsed.Create(objType, payload)

Create a TJsonRpcParsed instance.

- `objType`:  {TJsonRpcObjectType} message format type
- `payload`:  {IJsonRpcMessage} message body


### Class: TJsonRpcError
Realizes interface IJsonRpcMessage.

#### Constructor: TJsonRpcError.Create(code,message[,data])

Create a TJsonRpcError instance.

- `code`:  {Integer}
- `message`:  {String}
- `data`: {String|ISuperObject|nil} optional

```pascal
var error: TJsonRpcError;
error =  TJsonRpcError.Create(-32651, 'some error', 'some data');
```
or
```pascal
var error: TJsonRpcError;
error =  TJsonRpcError.Create(-32651, 'some error', SO('{ a: 1, extra: "some data"}'));
```

#### Class Method: TJsonRpcError.InvalidRequest(data)
#### Class Method: TJsonRpcError.MethodNotFound(data)
#### Class Method: TJsonRpcError.InvalidParams(data)
#### Class Method: TJsonRpcError.InternalError(data)
- `data`: {String|ISuperObject|nil}

#### Class Method: TJsonRpcError.ParseError(s)
- `s`: {String}
