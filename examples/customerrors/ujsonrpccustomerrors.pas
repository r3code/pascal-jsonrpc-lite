unit ujsonrpccustomerrors;

{$IFDEF FPC}
 {$mode objfpc} 
{$ENDIF}

interface

uses
  Classes, SysUtils, superobject, ujsonrpc;

type

  { TJsonRpcCustomError }

  TJsonRpcCustomError = class
    class function ProcedureException(data: ISuperObject): TJsonRpcError; overload;
    class function ProcedureException(data: string): TJsonRpcError; overload;
    class function AuthError(data: ISuperObject): TJsonRpcError; overload;
    class function AuthError(data: string): TJsonRpcError; overload;
  end;

implementation

const
  errorProcedureException = 'Procedure Exception';
  codeProcedureException = -32200;
  errorAuthError = 'Authentication Error';
  codeAuthError = -32201;
  
{ TJsonRpcCustomError }

class function TJsonRpcCustomError.ProcedureException(data: ISuperObject
  ): TJsonRpcError;
begin
  result := TJsonRpcError.Error(codeProcedureException, errorProcedureException, data);
end;

class function TJsonRpcCustomError.ProcedureException(
  data: string): TJsonRpcError; 
begin
  result := TJsonRpcError.Error(codeProcedureException, errorProcedureException, data);
end;

class function TJsonRpcCustomError.AuthError(data: ISuperObject): TJsonRpcError;
begin
  result := TJsonRpcError.Error(codeAuthError, errorAuthError, data);
end;

class function TJsonRpcCustomError.AuthError(data: string): TJsonRpcError;
begin
  result := TJsonRpcError.Error(codeAuthError, errorAuthError, data);
end;

end.
