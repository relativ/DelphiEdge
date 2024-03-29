unit uPSI_TypInfo;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

}
interface
 

 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_TypInfo = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TypInfo(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TypInfo_Routines(S: TPSExec);

procedure Register;

implementation


uses
   TypInfo
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TypInfo]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TypInfo(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTypeKind', '( tkUnknown, tkInteger, tkChar, tkEnumeration, tkFl'
   +'oat, tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString, tk'
   +'Variant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray, tkUString, t'
   +'kClassRef, tkPointer, tkProcedure )');
  CL.AddTypeS('TTypeInfo', 'record Kind : TTypeKind; Name : string; end');
 CL.AddDelphiFunction('Function PropType( Instance : TObject; const PropName : string) : TTypeKind');
 CL.AddDelphiFunction('Function PropIsType( Instance : TObject; const PropName : string; TypeKind : TTypeKind) : Boolean');
 CL.AddDelphiFunction('Function IsPublishedProp( Instance : TObject; const PropName : string) : Boolean');
 CL.AddDelphiFunction('Function GetOrdProp( Instance : TObject; const PropName : string) : NativeInt');
 CL.AddDelphiFunction('Procedure SetOrdProp( Instance : TObject; const PropName : string; Value : NativeInt)');
 CL.AddDelphiFunction('Function GetEnumProp( Instance : TObject; const PropName : string) : string');
 CL.AddDelphiFunction('Procedure SetEnumProp( Instance : TObject; const PropName : string; const Value : string)');
 CL.AddDelphiFunction('Function GetSetProp( Instance : TObject; const PropName : string; Brackets : Boolean) : string');
 CL.AddDelphiFunction('Procedure SetSetProp( Instance : TObject; const PropName : string; const Value : string)');
 CL.AddDelphiFunction('Function GetObjectProp( Instance : TObject; const PropName : string; MinClass : TClass) : TObject');
 CL.AddDelphiFunction('Procedure SetObjectProp( Instance : TObject; const PropName : string; Value : TObject)');
 CL.AddDelphiFunction('Function GetObjectPropClass( Instance : TObject; const PropName : string) : TClass');
 CL.AddDelphiFunction('Function GetStrProp( Instance : TObject; const PropName : string) : string');
 CL.AddDelphiFunction('Procedure SetStrProp( Instance : TObject; const PropName : string; const Value : string)');
 CL.AddDelphiFunction('Function GetAnsiStrProp( Instance : TObject; const PropName : string) : AnsiString');
 CL.AddDelphiFunction('Procedure SetAnsiStrProp( Instance : TObject; const PropName : string; const Value : AnsiString)');
 CL.AddDelphiFunction('Function GetWideStrProp( Instance : TObject; const PropName : string) : WideString');
 CL.AddDelphiFunction('Procedure SetWideStrProp( Instance : TObject; const PropName : string; const Value : WideString)');
 CL.AddDelphiFunction('Function GetUnicodeStrProp( Instance : TObject; const PropName : string) : UnicodeString');
 CL.AddDelphiFunction('Procedure SetUnicodeStrProp( Instance : TObject; const PropName : string; const Value : UnicodeString)');
 CL.AddDelphiFunction('Function GetFloatProp( Instance : TObject; const PropName : string) : Extended');
 CL.AddDelphiFunction('Procedure SetFloatProp( Instance : TObject; const PropName : string; const Value : Extended)');
 CL.AddDelphiFunction('Function GetVariantProp( Instance : TObject; const PropName : string) : Variant');
 CL.AddDelphiFunction('Procedure SetVariantProp( Instance : TObject; const PropName : string; const Value : Variant)');
 CL.AddDelphiFunction('Function GetMethodProp( Instance : TObject; const PropName : string) : TMethod');
 CL.AddDelphiFunction('Procedure SetMethodProp( Instance : TObject; const PropName : string; const Value : TMethod)');
 CL.AddDelphiFunction('Function GetInt64Prop( Instance : TObject; const PropName : string) : Int64');
 CL.AddDelphiFunction('Procedure SetInt64Prop( Instance : TObject; const PropName : string; const Value : Int64)');
 CL.AddDelphiFunction('Function GetInterfaceProp( Instance : TObject; const PropName : string) : IInterface');
 CL.AddDelphiFunction('Procedure SetInterfaceProp( Instance : TObject; const PropName : string; const Value : IInterface)');
 CL.AddDelphiFunction('Function GetDynArrayProp( Instance : TObject; const PropName : string) : Pointer');
 CL.AddDelphiFunction('Procedure SetDynArrayProp( Instance : TObject; const PropName : string; const Value : Pointer)');
 CL.AddDelphiFunction('Function GetPropValue( Instance : TObject; const PropName : string; PreferStrings : Boolean) : Variant');
 CL.AddDelphiFunction('Procedure SetPropValue( Instance : TObject; const PropName : string; const Value : Variant)');
 CL.AddDelphiFunction('Procedure FreeAndNilProperties( AObject : TObject)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TypInfo_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PropType, 'PropType', cdRegister);
 S.RegisterDelphiFunction(@PropIsType, 'PropIsType', cdRegister);
 S.RegisterDelphiFunction(@IsPublishedProp, 'IsPublishedProp', cdRegister);
 S.RegisterDelphiFunction(@GetOrdProp, 'GetOrdProp', cdRegister);
 S.RegisterDelphiFunction(@SetOrdProp, 'SetOrdProp', cdRegister);
 S.RegisterDelphiFunction(@GetEnumProp, 'GetEnumProp', cdRegister);
 S.RegisterDelphiFunction(@SetEnumProp, 'SetEnumProp', cdRegister);
 S.RegisterDelphiFunction(@GetSetProp, 'GetSetProp', cdRegister);
 S.RegisterDelphiFunction(@SetSetProp, 'SetSetProp', cdRegister);
 S.RegisterDelphiFunction(@GetObjectProp, 'GetObjectProp', cdRegister);
 S.RegisterDelphiFunction(@SetObjectProp, 'SetObjectProp', cdRegister);
 S.RegisterDelphiFunction(@GetObjectPropClass, 'GetObjectPropClass', cdRegister);
 S.RegisterDelphiFunction(@GetStrProp, 'GetStrProp', cdRegister);
 S.RegisterDelphiFunction(@SetStrProp, 'SetStrProp', cdRegister);
 S.RegisterDelphiFunction(@GetAnsiStrProp, 'GetAnsiStrProp', cdRegister);
 S.RegisterDelphiFunction(@SetAnsiStrProp, 'SetAnsiStrProp', cdRegister);
 S.RegisterDelphiFunction(@GetWideStrProp, 'GetWideStrProp', cdRegister);
 S.RegisterDelphiFunction(@SetWideStrProp, 'SetWideStrProp', cdRegister);
 S.RegisterDelphiFunction(@GetUnicodeStrProp, 'GetUnicodeStrProp', cdRegister);
 S.RegisterDelphiFunction(@SetUnicodeStrProp, 'SetUnicodeStrProp', cdRegister);
 S.RegisterDelphiFunction(@GetFloatProp, 'GetFloatProp', cdRegister);
 S.RegisterDelphiFunction(@SetFloatProp, 'SetFloatProp', cdRegister);
 S.RegisterDelphiFunction(@GetVariantProp, 'GetVariantProp', cdRegister);
 S.RegisterDelphiFunction(@SetVariantProp, 'SetVariantProp', cdRegister);
 S.RegisterDelphiFunction(@GetMethodProp, 'GetMethodProp', cdRegister);
 S.RegisterDelphiFunction(@SetMethodProp, 'SetMethodProp', cdRegister);
 S.RegisterDelphiFunction(@GetInt64Prop, 'GetInt64Prop', cdRegister);
 S.RegisterDelphiFunction(@SetInt64Prop, 'SetInt64Prop', cdRegister);
 S.RegisterDelphiFunction(@GetInterfaceProp, 'GetInterfaceProp', cdRegister);
 S.RegisterDelphiFunction(@SetInterfaceProp, 'SetInterfaceProp', cdRegister);
 S.RegisterDelphiFunction(@GetDynArrayProp, 'GetDynArrayProp', cdRegister);
 S.RegisterDelphiFunction(@SetDynArrayProp, 'SetDynArrayProp', cdRegister);
 S.RegisterDelphiFunction(@GetPropValue, 'GetPropValue', cdRegister);
 S.RegisterDelphiFunction(@SetPropValue, 'SetPropValue', cdRegister);
 S.RegisterDelphiFunction(@FreeAndNilProperties, 'FreeAndNilProperties', cdRegister);
end;

 
 
{ TPSImport_TypInfo }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TypInfo.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TypInfo(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TypInfo.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TypInfo_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
