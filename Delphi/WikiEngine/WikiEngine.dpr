library WikiEngine;

//$Rev: 7 $

uses
  ComServ,
  WikiEngine_TLB in 'WikiEngine_TLB.pas',
  weEngine in 'weEngine.pas' {Engine: CoClass},
  ADODB_TLB in 'ADODB_TLB.pas',
  VBScript_RegExp_55_TLB in 'VBScript_RegExp_55_TLB.pas',
  MSXML2_TLB in 'MSXML2_TLB.pas',
  weWikiParse in 'weWikiParse.pas',
  weWikiCommand in 'weWikiCommand.pas',
  weUtils in 'weUtils.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
