program WikiLocal;

uses
  Vcl.Forms,
  wl1 in 'wl1.pas' {frmWikiLocal},
  we2 in '..\WikiEng2\we2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmWikiLocal, frmWikiLocal);
  Application.Run;
end.
