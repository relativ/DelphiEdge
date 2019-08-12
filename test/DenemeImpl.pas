{ Invokable implementation File for TDeneme which implements IDeneme }

unit DenemeImpl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, DenemeIntf;

type

  { TDeneme }
  TDeneme = class(TInvokableClass, IDeneme)
  public
    function GetDeneme(s: string): string;
  end;

implementation


{ TDeneme }

function TDeneme.GetDeneme(s: string): string;
begin
  Result := s;
end;

initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TDeneme);
end.

