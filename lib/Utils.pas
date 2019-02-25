unit Utils;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes;


  function Implode(const Strings: TStringList; const separator: string): String;
  function Explode(const str: string; const separator: string): TStringList;
  function TrimChar(const Str: string; Ch: Char): string;

implementation

function TrimChar(const Str: string; Ch: Char): string;
var
  S, E: integer;
begin
  S:=1;
  while (S <= Length(Str)) and (Str[S]=Ch) do Inc(S);
  E:=Length(Str);
  while (E >= 1) and (Str[E]=Ch) do Dec(E);
  SetString(Result, PChar(@Str[S]), E - S + 1);
end;

function Explode(const str: string; const separator: string): TStringList;
var
  n: integer;
  p, q, s: PChar;
  item: string;
begin
  Result := TStringList.Create;
  try
    p := PChar(str);
    s := PChar(separator);
    n := Length(separator);
    repeat
      q := StrPos(p, s);
      if q = nil then q := StrScan(p, #0);
      SetString(item, p, q - p);
      Result.Add(item);
      p := q + n;
    until q^ = #0;
  except
    item := '';
    Result.Free;
    raise;
  end;
end;

function Implode(const Strings: TStringList; const separator: string): String;
var
  i: Integer;
begin
  Result := Strings[0];
  for i := 1 to Strings.Count - 1 do
    Result := Result + separator + Strings[i];
end;

end.
