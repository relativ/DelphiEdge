{ Invokable interface IDeneme }

unit DenemeIntf;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns;

type

  { Invokable interfaces must derive from IInvokable }
  IDeneme = interface(IInvokable)
  ['{591E72C1-3889-49EE-9AEC-A382A0CD4CAD}']

    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }

    function GetDeneme(s: string): string;
  end;

implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IDeneme));

end.
