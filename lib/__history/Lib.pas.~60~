unit Lib;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Dialogs, JavascriptObject;


type
  TLib = class
    class procedure ShowMessage(Value: string);
    class function JSDecode(Value: Variant): TJSObject;
  end;

implementation

class procedure TLib.ShowMessage(Value: string);
begin
  Vcl.Dialogs.ShowMessage(Value);
end;

class function TLib.JSDecode(Value: Variant): TJSObject;
var
  JS: TJSObject;
begin
  JS:= TJSObject.Create();
  JS.ActualJSPoint := Value;
  Result := JS;
end;

end.
