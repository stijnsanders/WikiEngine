program WikiLocalDB;

uses
  Forms,
  wldb1 in 'wldb1.pas' {frmWikiLocalDB},
  WikiLocal_TLB in '..\..\WikiLocal\WikiLocal_TLB.pas',
  wldbADOX in 'wldbADOX.pas',
  ADODB_TLB in 'ADODB_TLB.pas',
  wldbSQLDMO in 'wldbSQLDMO.pas',
  wldbSQLsys in 'wldbSQLsys.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmWikiLocalDB, frmWikiLocalDB);
  Application.Run;
end.
