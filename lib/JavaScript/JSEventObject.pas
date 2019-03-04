unit JSEventObject;

// Eventin geri dondugu kaynak elementi bulmak icin asagidaki komutu kullan
// element := htmlDoc.parentWindow.event.srcElement;

{
	Sample usage:
	El := (doc.forms.item(I, null) as IHTMLFormElement);
    El.onsubmit := (TEventObject.Create(FormSubmitEvent) as IDispatch);
}

interface

uses Windows, ComCtrls, ActiveX ;

type
  PProcedure = ^TProcedure;

  TProcedure = procedure of object;

  TEventObject = class(TInterfacedObject, IDispatch)
  private
    FOnEvent: TProcedure;
  protected
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  public
    constructor Create(const OnEvent: TProcedure);
    property OnEvent: TProcedure read FOnEvent write FOnEvent;
  end;

implementation


{ TEventObject }

constructor TEventObject.Create(const OnEvent: TProcedure);
begin
  inherited Create;
  FOnEvent := OnEvent;
end;

function TEventObject.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TEventObject.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
  Result := E_NOTIMPL;
end;

function TEventObject.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TEventObject.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
begin
  if (Dispid = DISPID_VALUE) then
  begin
    if Assigned(FOnEvent) then
      FOnEvent;
    Result := S_OK;
  end
  else Result := E_NOTIMPL;
end;

end.
