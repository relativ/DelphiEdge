unit JavascriptObject;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Winapi.ActiveX, System.Win.ComObj, MSHTML;


type

  TDispatchExSubclass = class;
  PJSObject = ^TJSObject;

  TJSObject = class(TInterfacedObject, IDispatch, ISupportErrorInfo, IDispatchEx)
  private
    FDispTypeInfo: ITypeInfo;
    FDispIntfEntry: PInterfaceEntry;
    FDispIID: TGUID;
    FName: string;
    FActualJSPoint: OleVariant;
  protected
    FMetadata: TDispatchExSubclass;
    procedure GetMetadata;

    destructor Destroy; override;

    { IDispatch }
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
    { ISupportErrorInfo }
    function InterfaceSupportsErrorInfo(const iid: TIID): HResult; stdcall;
  public
    constructor Create(const TypeLib: ITypeLib; const DispIntf: TGUID);
{$IFDEF MSWINDOWS}
    function SafeCallException(ExceptObject: TObject;
      ExceptAddr: Pointer): HResult; override;
{$ENDIF}
    property DispIntfEntry: PInterfaceEntry read FDispIntfEntry;
    property DispTypeInfo: ITypeInfo read FDispTypeInfo;
    property DispIID: TGUID read FDispIID;
    property Name: string read FName write FName;
    property ActualJSPoint: OleVariant read FActualJSPoint write FActualJSPoint;


    function GetDispID(const bstrName: TBSTR; const grfdex: DWORD; out id: TDispID): HResult; stdcall;
    function InvokeEx(const id: TDispID; const lcid: LCID; const wflags: WORD; const pdp: PDispParams; out varRes: OleVariant; out pei: TExcepInfo; const pspCaller: PServiceProvider): HResult; stdcall;
    function DeleteMemberByName(const bstr: TBSTR; const grfdex: DWORD): HResult; stdcall;
    function DeleteMemberByDispID(const id: TDispID): HResult; stdcall;
    function GetMemberProperties(const id: TDispID; const grfdexFetch: DWORD; out grfdex: DWORD): HResult; stdcall;
    function GetMemberName(const id: TDispID; out bstrName: TBSTR): HResult; stdcall;
    function GetNextDispID(const grfdex: DWORD; const id: TDispID; out nid: TDispID): HResult; stdcall;
    function GetNameSpaceParent(out unk: IUnknown): HResult; stdcall;

    function GetObject(PropertyNameStr: string): TJSObject;
    function GetString(PropertyNameStr: string): string;
    procedure SetValue(PropertyName: string; Value: string);
  end;



  TDispatchExSubclass = class
  protected
    DispIDCache: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TDispatchExMetadataCache = class
  protected
    SubclassCache: TStringList;
    class function FormatInt(i: integer): string;
    class function UnformatInt(i: string): integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(subclass: TJSObject): TDispatchExSubclass; overload;
    {$ifdef HAS_RTTI}
    function Add(subclass: TObjectDispatchEx): TDispatchExSubclass; overload;
    {$endif}
  end;

implementation

uses Main;

var
  DispatchEx_MetadataCache: TDispatchExMetadataCache;

{ TDispatchExMetadataCache }

class function TDispatchExMetadataCache.FormatInt(i: integer): string;
begin
  Result := IntToHex(i, 8);
end;

class function TDispatchExMetadataCache.UnformatInt(i: string): integer;
begin
  Result := StrToInt('$'+i);
end;

constructor TDispatchExMetadataCache.Create;
begin
  inherited;
  SubclassCache := TStringList.Create; // use TObjectDictionary<string,TDispatchExSubclass> in modern Delphi
  SubclassCache.Sorted := true; // activate binary search
end;

destructor TDispatchExMetadataCache.Destroy;
var
  i: integer;
begin
  for i := 0 to SubclassCache.Count - 1 do
    SubclassCache.Objects[i].Free;
  SubclassCache.Free;
  inherited;
end;

function TDispatchExMetadataCache.Add(subclass: TJSObject): TDispatchExSubclass;
var
  i, f, cnt: integer;
  pta: PTypeAttr;
  pfd: PFuncDesc;
  bstr: TBStr;
  name: PString;
begin
  i := SubclassCache.IndexOf(subclass.ClassName);

  if i >= 0 then
    Result := TDispatchExSubclass(SubclassCache.Objects[i])
  else begin
    Result := TDispatchExSubclass.Create;

    SubclassCache.AddObject(subclass.ClassName, Result);

    OleCheck(subclass.DispTypeInfo.GetTypeAttr(pta));
    try
      for f := 0 to pta^.cFuncs - 1 do begin
        OleCheck(subclass.DispTypeInfo.GetFuncDesc(f, pfd));
        try
          if pfd.wFuncFlags and FUNCFLAG_FRESTRICTED = 0 then begin // exclude system-level methods
            OleCheck(subclass.DispTypeInfo.GetNames(pfd.memid, @bstr, 1, cnt));
            New(name);
            name^ := bstr;
            SysFreeString(bstr);
            Result.DispIDCache.AddObject(FormatInt(pfd.memid), TObject(name));
          end;
        finally
          subclass.DispTypeInfo.ReleaseFuncDesc(pfd);
        end;
      end;
    finally
      subclass.DispTypeInfo.ReleaseTypeAttr(pta);
    end;
  end;
end;

{$ifdef HAS_RTTI}
function GetNonSystemMethods(aType: TRttiType; aStopType: TRttiType): TArray<TRttiMethod>;
  function Flatten(const Args: array of TArray<TRttiMethod>): TArray<TRttiMethod>;
  var
    i, j, r, len: Integer;
  begin
    len := 0;
    for i := 0 to High(Args) do
      len := len + Length(Args[i]);
    SetLength(Result, len);
    r := 0;
    for i := 0 to High(Args) do begin
      for j := 0 to High(Args[i]) do begin
        Result[r] := Args[i][j];
        Inc(r);
      end;
    end;
  end;
var
  nestedMethods: TArray<TArray<TRttiMethod>>;
  t: TRttiType;
  depth: Integer;
begin
  t := aType;
  depth := 0;
  while (t <> nil) and (t <> aStopType) do begin
    Inc(depth);
    t := t.BaseType;
  end;

  SetLength(nestedMethods, depth);

  t := aType;
  depth := 0;
  while (t <> nil) and (t <> aStopType) do begin
    nestedMethods[depth] := t.GetDeclaredMethods;
    Inc(depth);
    t := t.BaseType;
  end;

  Result := Flatten(nestedMethods);
end;

function TDispatchExMetadataCache.Add(subclass: TObjectDispatchEx): TDispatchExSubclass;
var
  obj: TObject;
  i: integer;
  ctx: TRttiContext;
  t: TRttiType;
  method: TRttiMethod;
  name: PString;
begin
  obj := subclass.Instance; // the real object inside the TObjectDispatch

  i := SubclassCache.IndexOf(obj.ClassName);

  if i >= 0 then
    Result := TDispatchExSubclass(SubclassCache.Objects[i])
  else begin
    Result := TDispatchExSubclass.Create;

    SubclassCache.AddObject(obj.ClassName, Result);

    t := ctx.GetType(obj.ClassType);

    for method in GetNonSystemMethods(t, ctx.GetType(TObject)) do begin // exclude system-level methods
      New(name);
      name^ := method.Name;
      subclass.GetIDsOfNames(GUID_NULL, name, 1, 0, @i);
      Result.DispIDCache.AddObject(FormatInt(i), TObject(name));
    end;
  end;
end;
{$endif}

{ TDispatchExSubclass }

constructor TDispatchExSubclass.Create;
begin
  inherited;
  DispIDCache := TStringList.Create;
  DispIDCache.Sorted := true; // activate binary search
end;

destructor TDispatchExSubclass.Destroy;
var
  i: integer;
begin
  for i := 0 to DispIDCache.Count - 1 do
    Dispose(PString(DispIDCache.Objects[i]));
  DispIDCache.Free;
  inherited;
end;

{ TJSObject }

constructor TJSObject.Create(const TypeLib: ITypeLib; const DispIntf: TGUID);
begin
  inherited Create;
  OleCheck(TypeLib.GetTypeInfoOfGuid(DispIntf, FDispTypeInfo));
  FDispIntfEntry := GetInterfaceEntry(DispIntf);
  FDispIID := DispIntf;
end;

{ TAutoIntfObject.IDispatch }

function TJSObject.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
{$IFDEF MSWINDOWS}
  Result := DispGetIDsOfNames(FDispTypeInfo, Names, NameCount, DispIDs);
{$ENDIF}
{$IFDEF LINUX}
  Result := E_NOTIMPL;
{$ENDIF}
end;

function TJSObject.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
  Pointer(TypeInfo) := nil;
  if Index <> 0 then
  begin
    Result := DISP_E_BADINDEX;
    Exit;
  end;
  ITypeInfo(TypeInfo) := FDispTypeInfo;
  Result := S_OK;
end;

function TJSObject.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Count := 1;
  Result := S_OK;
end;

function TJSObject.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
const
  INVOKE_PROPERTYSET = INVOKE_PROPERTYPUT or INVOKE_PROPERTYPUTREF;
begin
  if Flags and INVOKE_PROPERTYSET <> 0 then Flags := INVOKE_PROPERTYSET;
  Result := FDispTypeInfo.Invoke(Pointer(PByte(Self) +
    FDispIntfEntry.IOffset), DispID, Flags, TDispParams(Params), VarResult,
    ExcepInfo, ArgErr);
end;

function TJSObject.InterfaceSupportsErrorInfo(const iid: TIID): HResult;
begin
  if IsEqualGUID(DispIID, iid) then
    Result := S_OK else
    Result := S_FALSE;
end;

{$IFDEF MSWINDOWS}
function TJSObject.SafeCallException(ExceptObject: TObject;
  ExceptAddr: Pointer): HResult;
begin
  Result := HandleSafeCallException(ExceptObject, ExceptAddr, DispIID, '', '');
end;




{$ENDIF}

destructor TJSObject.Destroy;
begin
  inherited;
end;

function TJSObject.GetObject(PropertyNameStr: string): TJSObject;
var
  ValueEx: IDispatchEx;
  vPropertyValue: OleVariant;
  basicType  : Integer;
  DispatchIdOfProperty: integer;
  Temp: TExcepInfo;
  Params:TDispParams;
  Window: IHTMLWindow2;
  sIDList: TStringList;
  I: Integer;
  JSObject: TJSObject;
begin
  if Trim(Self.Name) <> '' then
  begin
    sIDList:= TStringList.Create;
    sIDList.Text := StringReplace(Self.Name + '|' + PropertyNameStr, '|', #13, [rfReplaceAll]);

    Window:= (MainForm.Browser.ControlInterface.Document as IHTMLDocument2).parentWindow;
    Assert(Assigned(Window));

    vPropertyValue := Window;
    for I := 0 to sIDList.Count -1 do
    begin
      Supports( IDispatch(vPropertyValue), IDispatchEx, ValueEx );
      ValueEx.GetDispID(PWideChar(sIDList[I]), fdexNameCaseSensitive, DispatchIdOfProperty);
      ValueEx.InvokeEx(DispatchIdOfProperty, LOCALE_USER_DEFAULT, DISPATCH_PROPERTYGET, @Params, vPropertyValue, Temp, nil);

    end;
  end else begin
    Supports( IDispatch(Self.ActualJSPoint), IDispatchEx, ValueEx );
    ValueEx.GetDispID(PWideChar(PropertyNameStr), fdexNameCaseSensitive, DispatchIdOfProperty);
    ValueEx.InvokeEx(DispatchIdOfProperty, LOCALE_USER_DEFAULT, DISPATCH_PROPERTYGET, @Params, vPropertyValue, Temp, nil);
  end;

  //vPropertyValue := GetDispatchPropValue((ValueEx as IDispatchEx), PropertyName);
  basicType := VarType(vPropertyValue) and VarTypeMask;

  // Set a string to match the type
  case basicType of
    varDispatch : begin
      Supports( IDispatch(vPropertyValue), IDispatchEx, ValueEx );
      JSObject := TJSObject(PJSObject(@ValueEx)^);
      JSObject.ActualJSPoint := vPropertyValue;
      if Trim(Self.Name) <> '' then
        JSObject.Name := Self.Name + '|' + PropertyNameStr;
      Result := JSObject;

    end
    else Result := nil;
  end;

 // sIDList.Free;

end;

function TJSObject.GetString(PropertyNameStr: string): string;
var
  ValueEx: IDispatchEx;
  vPropertyValue: OleVariant;
  basicType  : Integer;
  DispatchIdOfProperty: integer;
  Temp: TExcepInfo;
  Params:TDispParams;
  Window: IHTMLWindow2;
  sIDList: TStringList;
  I: Integer;
begin
  if Trim(Self.Name) <> '' then
  begin
    sIDList:= TStringList.Create;
    sIDList.Text := StringReplace(Self.Name + '|' + PropertyNameStr, '|', #13, [rfReplaceAll]);

    Window:= (MainForm.Browser.ControlInterface.Document as IHTMLDocument2).parentWindow;
    Assert(Assigned(Window));

    vPropertyValue := Window;
    for I := 0 to sIDList.Count -1 do
    begin
      Supports( IDispatch(vPropertyValue), IDispatchEx, ValueEx );
      ValueEx.GetDispID(PWideChar(sIDList[I]), fdexNameCaseSensitive, DispatchIdOfProperty);
      ValueEx.InvokeEx(DispatchIdOfProperty, LOCALE_USER_DEFAULT, DISPATCH_PROPERTYGET, @Params, vPropertyValue, Temp, nil);

    end;
  end else begin

    Supports( IDispatch(Self.ActualJSPoint), IDispatchEx, ValueEx );

    ValueEx.GetDispID(PWideChar(PropertyNameStr), fdexNameCaseSensitive, DispatchIdOfProperty);
    ValueEx.InvokeEx(DispatchIdOfProperty, LOCALE_USER_DEFAULT, DISPATCH_PROPERTYGET, @Params, vPropertyValue, Temp, nil);

  end;
  //vPropertyValue := GetDispatchPropValue((ValueEx as IDispatchEx), PropertyName);
  basicType := VarType(vPropertyValue) and VarTypeMask;

  // Set a string to match the type
  case basicType of
    varDispatch : Result := '[object]';
    else Result := vPropertyValue;
  end;

  sIDList.Free;

end;

procedure TJSObject.SetValue(PropertyName: string; Value: string);
var
  sPath, sValue : string;
begin
  sValue := StringReplace(Value, '"', '\"', [rfReplaceAll]);
  sPath := StringReplace(Self.Name, '|', '.', [rfReplaceAll]);
  (MainForm.Browser.ControlInterface.Document as IHTMLDocument2).parentWindow.execScript(sPath + '.'+PropertyName + '="'+sValue+'"', 'JavaScript')
end;

procedure TJSObject.GetMetadata;
begin
  if FMetadata = nil then
    FMetadata := DispatchEx_MetadataCache.Add(self);
end;

function TJSObject.DeleteMemberByDispID(const id: TDispID): HResult;
begin
  Result := E_NOTIMPL;
end;

function TJSObject.DeleteMemberByName(const bstr: TBSTR; const grfdex: DWORD): HResult;
begin
  Result := E_NOTIMPL;
end;

function TJSObject.GetDispID(const bstrName: TBSTR; const grfdex: DWORD; out id: TDispID): HResult;
begin
  // TO-DO: implement support for fdexNameEnsure and fdexNameImplicit if desired
  Result := GetIDsOfNames(GUID_NULL, @bstrName, 1, 0, @id);
end;

function TJSObject.GetMemberName(const id: TDispID; out bstrName: TBSTR): HResult;
var
  i: integer;
begin
  GetMetadata;

  i := FMetadata.DispIDCache.IndexOf(TDispatchExMetadataCache.FormatInt(id));
  if i >= 0 then begin
    bstrName := SysAllocString(PWideChar(WideString(PString(FMetadata.DispIDCache.Objects[i])^)));
    Result := S_OK;
  end
  else
    Result := DISP_E_UNKNOWNNAME;
end;

function TJSObject.GetMemberProperties(const id: TDispID; const grfdexFetch: DWORD; out grfdex: DWORD): HResult;
begin
  Result := E_NOTIMPL;
end;

function TJSObject.GetNameSpaceParent(out unk: IUnknown): HResult;
begin
  Result := E_NOTIMPL;
end;

function TJSObject.GetNextDispID(const grfdex: DWORD; const id: TDispID; out nid: TDispID): HResult;
var
  i: integer;
begin
  Result := S_FALSE;

  GetMetadata;

  if id = DISPID_STARTENUM then begin
    if FMetadata.DispIDCache.Count > 0 then begin
      nid := TDispatchExMetadataCache.UnformatInt(FMetadata.DispIDCache[0]);
      Result := S_OK;
    end;
  end
  else begin
    i := FMetadata.DispIDCache.IndexOf(TDispatchExMetadataCache.FormatInt(id));
    if (i >= 0) and (i < FMetadata.DispIDCache.Count - 1) then begin
      nid := TDispatchExMetadataCache.UnformatInt(FMetadata.DispIDCache[i+1]);
      Result := S_OK;
    end;
  end;
end;

function TJSObject.InvokeEx(const id: TDispID; const lcid: LCID; const wflags: WORD; const pdp: PDispParams; out varRes: OleVariant; out pei: TExcepInfo; const pspCaller: PServiceProvider): HResult;
begin
  if wflags = DISPATCH_CONSTRUCT then // TO-DO: implement constructor semantics if desired
    Result := DISP_E_MEMBERNOTFOUND
  else begin
    { TO-DO: support "this" parameter if desired.
      From MSDN:
        When DISPATCH_METHOD is set in wFlags, there may be a "named parameter" for the "this" value.
        The DISPID will be DISPID_THIS and it must be the first named parameter.
    }
    Result := Invoke(id, GUID_NULL, lcid, wflags, pdp^, @varRes, @pei, nil);
  end;
end;

end.
