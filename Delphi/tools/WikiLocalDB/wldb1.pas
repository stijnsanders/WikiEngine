unit wldb1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TfrmWikiLocalDB = class(TForm)
    Label1: TLabel;
    txtWikiGroup: TEdit;
    Label2: TLabel;
    txtTitlePrefix: TEdit;
    txtFieldLine: TEdit;
    Label3: TLabel;
    btnGo: TButton;
    ProgressBar1: TProgressBar;
    rgMethod: TRadioGroup;
    Label4: TLabel;
    txtTableSuffix: TMemo;
    Label5: TLabel;
    txtPageFooter: TEdit;
    cbCloseWhenDone: TCheckBox;
    cbIncludeSchema: TCheckBox;
    procedure btnGoClick(Sender: TObject);
  protected
    procedure DoShow; override;
    procedure DoClose(var Action: TCloseAction); override;
  end;

var
  frmWikiLocalDB: TfrmWikiLocalDB;

implementation

uses
  wldbADOX, wldbSQLDMO, wldbSQLsys;

{$R *.dfm}

{ TfrmWikiLocalDB }

procedure TfrmWikiLocalDB.DoShow;
var
  sl:TStringList;
begin
  inherited;
  sl:=TStringList.Create;
  try
    try
      sl.LoadFromFile('WikiLocalDB.ini');
      txtWikiGroup.Text:=sl.Values['WikiGroup'];
      txtTitlePrefix.Text:=sl.Values['TitlePrefix'];
      txtTableSuffix.Text:=
        StringReplace(
        StringReplace(
          sl.Values['TitleSuffix'],
          '|||',#13#10,[rfReplaceAll]),
          '|_|','|',[rfReplaceAll]);
      txtFieldLine.Text:=sl.Values['FieldLine'];
      txtPageFooter.Text:=sl.Values['PageFooter'];
      rgMethod.ItemIndex:=StrToInt(sl.Values['Method']);
      cbCloseWhenDone.Checked:=sl.Values['CloseWhenDone']='1';
      //cbIncludeOwner.Checked:=sl.Values['IncludeOwner']='1';
      cbIncludeSchema.Checked:=sl.Values['IncludeSchema']='1';
    except
      //silent
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmWikiLocalDB.DoClose(var Action: TCloseAction);
var
  sl:TStringList;
const
  boolstr:array[boolean] of string=('0','1');
begin
  inherited;
  sl:=TStringList.Create;
  try
    try
      sl.Values['WikiGroup']:=txtWikiGroup.Text;
      sl.Values['TitlePrefix']:=txtTitlePrefix.Text;
      sl.Values['TitleSuffix']:=
        StringReplace(
        StringReplace(
          txtTableSuffix.Text,
          '|','|_|',[rfReplaceAll]),
          #13#10,'|||',[rfReplaceAll]);
      sl.Values['FieldLine']:=txtFieldLine.Text;
      sl.Values['PageFooter']:=txtPageFooter.Text;
      sl.Values['Method']:=IntToStr(rgMethod.ItemIndex);
      sl.Values['CloseWhenDone']:=boolstr[cbCloseWhenDone.Checked];
      //sl.Values['IncludeOwner']:=boolstr[cbIncludeOwner.Checked];
      sl.Values['IncludeSchema']:=boolstr[cbIncludeSchema.Checked];
      sl.SaveToFile('WikiLocalDB.ini');
    except
      //silent
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmWikiLocalDB.btnGoClick(Sender: TObject);
begin
  btnGo.Enabled:=false;
  Screen.Cursor:=crHourGlass;
  try

    case rgMethod.ItemIndex of
      0:PerformADOX;
      1:PerformSQLDMO;//(cbIncludeSchema.Checked);?
      2:PerformSQLsys(cbIncludeSchema.Checked);
    end;
    if cbCloseWhenDone.Checked then Close;

  finally
    btnGo.Enabled:=true;
    Screen.Cursor:=crHourGlass;
  end;
end;

end.
