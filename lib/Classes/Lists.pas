unit Lists;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes;

type
  TObjectList = class(TObject)
  private
    FList: TList;
  protected
    function Get(Index: Integer): TObject;
    procedure Put(Index: Integer; Item: TObject);
    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: TObject): Integer;
    procedure Clear; virtual;
    procedure Delete(Index: Integer);
    function Expand: TObjectList;
    function First: TObject; inline;
    function IndexOf(Item: TObject): Integer;
    procedure Insert(Index: Integer; Item: TObject);
    function Last: TObject;
    procedure Move(CurIndex, NewIndex: Integer);
    function Remove(Item: TObject): Integer; inline;
    procedure Pack;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TObject read Get write Put; default;

  end;

implementation

{ TObjectList }

function TObjectList.Add(Item: TObject): Integer;
begin
  FList.Add(@Item);
end;

procedure TObjectList.Clear;
begin
  FList.Clear;
end;

constructor TObjectList.Create;
begin
  FList := TList.Create;
end;

procedure TObjectList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TObjectList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TObjectList.Expand: TObjectList;
var
  FDataList: TObjectList;
begin
  FDataList:= TObjectList.Create;
  FDataList.FList := FList.Expand;
  Result := FDataList;
end;

function TObjectList.First: TObject;
begin
  Result := TObject(FList.First^);
end;

function TObjectList.Get(Index: Integer): TObject;
begin
    Result := TObject(FList[Index]^);
end;

function TObjectList.GetCount: integer;
begin
  Result := FList.Count;
end;

function TObjectList.IndexOf(Item: TObject): Integer;
begin
  Result := FList.IndexOf(@Item);
end;

procedure TObjectList.Insert(Index: Integer; Item: TObject);
begin
  FList.Insert(Index, @Item);
end;

function TObjectList.Last: TObject;
begin
  Result := TObject(FList.Last^);
end;

procedure TObjectList.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
end;

procedure TObjectList.Pack;
begin
  FList.Pack;
end;

procedure TObjectList.Put(Index: Integer; Item: TObject);
begin
  FList[Index] := @Item;
end;

function TObjectList.Remove(Item: TObject): Integer;
begin
  FList.Remove(@Item);
end;


end.
