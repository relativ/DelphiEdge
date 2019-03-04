// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : https://svn.apache.org/repos/asf/juddi/trunk/juddi-client.net/example/WcfServiceLifeCycle/sample.wsdl
// (1.03.2019 20:52:09 - - $Rev: 76228 $)
// ************************************************************************ //

unit sample;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[]


  // ************************************************************************ //
  // Namespace : urn:examples:helloservice
  // soapAction: sayHello
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // use       : encoded
  // binding   : Hello_Binding
  // service   : Hello_Service
  // port      : Hello_Port
  // URL       : http://www.examples.com/SayHello/
  // ************************************************************************ //
  Hello_PortType = interface(IInvokable)
  ['{243CBD89-8766-F19D-38DF-427D7A02EAEE}']
    function  sayHello(const firstName: string): string; stdcall;
  end;

function GetHello_PortType(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): Hello_PortType;


implementation
  uses System.SysUtils;

function GetHello_PortType(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): Hello_PortType;
const
  defWSDL = 'https://svn.apache.org/repos/asf/juddi/trunk/juddi-client.net/example/WcfServiceLifeCycle/sample.wsdl';
  defURL  = 'http://www.examples.com/SayHello/';
  defSvc  = 'Hello_Service';
  defPrt  = 'Hello_Port';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as Hello_PortType);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  { Hello_PortType }
  InvRegistry.RegisterInterface(TypeInfo(Hello_PortType), 'urn:examples:helloservice', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(Hello_PortType), 'sayHello');

end.