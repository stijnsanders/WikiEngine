program WikiEdit;

uses
  Vcl.Forms,
  we1 in 'we1.pas' {fWikiEdit},
  we2 in '..\WikiEng2\we2.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfWikiEdit, fWikiEdit);
  Application.Run;
end.
