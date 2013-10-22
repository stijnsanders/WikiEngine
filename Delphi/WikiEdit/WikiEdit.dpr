program WikiEdit;

uses
  Forms,
  we1 in 'we1.pas' {Form1},
  WikiEngine_TLB in 'WikiEngine_TLB.pas',
  comFixW6 in '..\comFixW6.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
