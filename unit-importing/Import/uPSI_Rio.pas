unit uPSI_Rio;
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
  TPSImport_Rio = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRIO(CL: TPSPascalCompiler);
procedure SIRegister_IRIOAccess(CL: TPSPascalCompiler);
procedure SIRegister_Rio(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TRIO(CL: TPSRuntimeClassImporter);
procedure RIRegister_Rio(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Rio
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Rio]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRIO(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TRIO') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TRIO') do
  begin
    RegisterProperty('RefCount', 'Integer', iptr);
    RegisterProperty('Converter', 'IOPConvert', iptrw);
    RegisterProperty('WebNode', 'IWebNode', iptrw);
    RegisterProperty('SOAPHeaders', 'TSOAPHeaders', iptr);
    RegisterProperty('OnAfterExecute', 'TAfterExecuteEvent', iptrw);
    RegisterProperty('OnBeforeExecute', 'TBeforeExecuteEvent', iptrw);
    RegisterProperty('OnSendAttachment', 'TOnSendAttachmentEvent', iptrw);
    RegisterProperty('OnGetAttachment', 'TOnGetAttachmentEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IRIOAccess(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IRIOAccess') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IRIOAccess, 'IRIOAccess') do
  begin
    RegisterMethod('Function GetRIO : TRIO', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Rio(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TRIO');
  SIRegister_IRIOAccess(CL);
  CL.AddTypeS('TBeforeExecuteEvent', 'Procedure ( const MethodName : string; SO'
   +'APRequest : TStream)');
  CL.AddTypeS('TAfterExecuteEvent', 'Procedure ( const MethodName : string; SOA'
   +'PResponse : TStream)');
  SIRegister_TRIO(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRIOOnGetAttachment_W(Self: TRIO; const T: TOnGetAttachmentEvent);
begin Self.OnGetAttachment := T; end;

(*----------------------------------------------------------------------------*)
procedure TRIOOnGetAttachment_R(Self: TRIO; var T: TOnGetAttachmentEvent);
begin T := Self.OnGetAttachment; end;

(*----------------------------------------------------------------------------*)
procedure TRIOOnSendAttachment_W(Self: TRIO; const T: TOnSendAttachmentEvent);
begin Self.OnSendAttachment := T; end;

(*----------------------------------------------------------------------------*)
procedure TRIOOnSendAttachment_R(Self: TRIO; var T: TOnSendAttachmentEvent);
begin T := Self.OnSendAttachment; end;

(*----------------------------------------------------------------------------*)
procedure TRIOOnBeforeExecute_W(Self: TRIO; const T: TBeforeExecuteEvent);
begin Self.OnBeforeExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TRIOOnBeforeExecute_R(Self: TRIO; var T: TBeforeExecuteEvent);
begin T := Self.OnBeforeExecute; end;

(*----------------------------------------------------------------------------*)
procedure TRIOOnAfterExecute_W(Self: TRIO; const T: TAfterExecuteEvent);
begin Self.OnAfterExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TRIOOnAfterExecute_R(Self: TRIO; var T: TAfterExecuteEvent);
begin T := Self.OnAfterExecute; end;

(*----------------------------------------------------------------------------*)
procedure TRIOSOAPHeaders_R(Self: TRIO; var T: TSOAPHeaders);
begin T := Self.SOAPHeaders; end;

(*----------------------------------------------------------------------------*)
procedure TRIOWebNode_W(Self: TRIO; const T: IWebNode);
begin Self.WebNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TRIOWebNode_R(Self: TRIO; var T: IWebNode);
begin T := Self.WebNode; end;

(*----------------------------------------------------------------------------*)
procedure TRIOConverter_W(Self: TRIO; const T: IOPConvert);
begin Self.Converter := T; end;

(*----------------------------------------------------------------------------*)
procedure TRIOConverter_R(Self: TRIO; var T: IOPConvert);
begin T := Self.Converter; end;

(*----------------------------------------------------------------------------*)
procedure TRIORefCount_R(Self: TRIO; var T: Integer);
begin T := Self.RefCount; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRIO(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRIO) do
  begin
    RegisterPropertyHelper(@TRIORefCount_R,nil,'RefCount');
    RegisterPropertyHelper(@TRIOConverter_R,@TRIOConverter_W,'Converter');
    RegisterPropertyHelper(@TRIOWebNode_R,@TRIOWebNode_W,'WebNode');
    RegisterPropertyHelper(@TRIOSOAPHeaders_R,nil,'SOAPHeaders');
    RegisterPropertyHelper(@TRIOOnAfterExecute_R,@TRIOOnAfterExecute_W,'OnAfterExecute');
    RegisterPropertyHelper(@TRIOOnBeforeExecute_R,@TRIOOnBeforeExecute_W,'OnBeforeExecute');
    RegisterPropertyHelper(@TRIOOnSendAttachment_R,@TRIOOnSendAttachment_W,'OnSendAttachment');
    RegisterPropertyHelper(@TRIOOnGetAttachment_R,@TRIOOnGetAttachment_W,'OnGetAttachment');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Rio(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRIO) do
  RIRegister_TRIO(CL);
end;

 
 
{ TPSImport_Rio }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Rio.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Rio(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Rio.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Rio(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
