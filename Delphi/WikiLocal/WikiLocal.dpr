program WikiLocal;

uses
  Forms,
  WikiEngine_TLB in 'WikiEngine_TLB.pas',
  wl1 in 'wl1.pas' {frmWikiLocalMain},
  VBScript_RegExp_55_TLB in '..\WikiEngine\VBScript_RegExp_55_TLB.pas',
  WikiLocal_TLB in 'WikiLocal_TLB.pas',
  wlStore in 'wlStore.pas' {WikiLocalStore: CoClass},
  comFixW6 in '..\comFixW6.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmWikiLocalMain, frmWikiLocalMain);
  Application.Run;
end.
