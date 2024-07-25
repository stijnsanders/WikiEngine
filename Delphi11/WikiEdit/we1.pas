unit we1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls,
  HTMLUn2, HtmlView, Vcl.AppEvnts, we2, System.Actions, Vcl.ActnList;

type
  TfWikiEdit = class(TForm)
    HtmlViewer1: THtmlViewer;
    Memo1: TMemo;
    Splitter1: TSplitter;
    odWikiRuleSet: TOpenDialog;
    ApplicationEvents1: TApplicationEvents;
    Panel1: TPanel;
    ListBox1: TListBox;
    ActionList1: TActionList;
    aSelectAll: TAction;
    aRefresh: TAction;
    aViewHTML: TAction;
    aToggleWrap: TAction;
    aCopyAll: TAction;
    aCutAll: TAction;
    aLoad: TAction;
    aSave: TAction;
    aParseChange: TAction;
    MainMenu1: TMainMenu;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure Exit1Click(Sender: TObject);
    procedure HtmlViewer1Link(Sender: TObject; const Rel, Rev, Href: string);
    procedure HtmlViewer1RightClick(Sender: TObject;
      Parameters: TRightClickParameters);
    procedure HtmlViewer1HotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure aSelectAllExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aViewHTMLExecute(Sender: TObject);
    procedure aToggleWrapExecute(Sender: TObject);
    procedure aCopyAllExecute(Sender: TObject);
    procedure aCutAllExecute(Sender: TObject);
    procedure aLoadExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aParseChangeExecute(Sender: TObject);
    procedure HtmlViewer1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FPath,FWRS,FHeader:string;
    FEngine:TWikiEngine;
  protected
    procedure DoShow; override;
    procedure DoClose(var Action: TCloseAction); override;
    procedure DoDestroy; override;
  end;

var
  fWikiEdit: TfWikiEdit;

implementation

{$R *.dfm}

function HTMLEncode(const x:string):string;
begin
  Result:=
    StringReplace(
    StringReplace(
    StringReplace(
    StringReplace(
      x
      ,'&','&amp;',[rfReplaceAll])
      ,'<','&lt;',[rfReplaceAll])
      ,'>','&gt;',[rfReplaceAll])
      ,#13#10,'<br />',[rfReplaceAll])
      ;
end;

procedure TfWikiEdit.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
var
  key,val:string;
begin
  if Memo1.Modified then
   begin

    try
      FEngine.ParseWiki(Memo1.Text);

      HtmlViewer1.LoadFromString(FHeader+FEngine.WikiOutput);
      ListBox1.Items.BeginUpdate;
      try
        ListBox1.Items.Clear;
        while FEngine.GetWikiModification(key,val) do
          ListBox1.Items.Add('['+key+']'+val);
      finally
        ListBox1.Items.EndUpdate;
      end;
      ListBox1.Visible:=ListBox1.Items.Count<>0;

      if Memo1.SelStart=Length(Memo1.Text) then
        if HtmlViewer1.VScrollBarRange>0 then
          HtmlViewer1.VScrollBarPosition:=HtmlViewer1.VScrollBarRange;
    except
      on e:Exception do
       begin
        HtmlViewer1.LoadFromString(
          '<div style="font-weight:bold;color:red;border:1px solid black;padding:0.2em;">'
          +HTMLEncode('{'+e.ClassName+'}'+e.Message)+'</div>');
        ListBox1.Visible:=false;
       end;
    end;

    //StatusBar1.Panels[1].Text:=IntToStr(Engine.LastCallTime)+'ms';

    Memo1.Modified:=false;
   end;
end;

procedure TfWikiEdit.DoShow;
var
  sl:TStringList;
begin
  inherited;
  FPath:=ExtractFilePath(Application.ExeName);

  if FileExists(FPath+'WikiEdit.ini') then
   begin
    sl:=TStringList.Create;
    try
      sl.LoadFromFile(FPath+'WikiEdit.ini');

      if sl.Values['Maximized']='1' then WindowState:=wsMaximized else
        BoundsRect:=Rect(
          StrToInt(sl.Values['Left']),
          StrToInt(sl.Values['Top']),
          StrToInt(sl.Values['Right']),
          StrToInt(sl.Values['Bottom']));

      HtmlViewer1.Height:=StrToInt(sl.Values['Preview']);
      //StatusBar1.Top:=ClientHeight;

    except
      //silent!
    end;
    sl.Free;
   end;

  FHeader:='';//default
  if FileExists(FPath+'WikiEdit.html') then
   begin
    sl:=TStringList.Create;
    try
      sl.LoadFromFile(FPath+'WikiEdit.html');
      FHeader:=sl.Text+#13#10#13#10;
    finally
      sl.Free;
    end;
   end;

  if ParamCount=0 then
    if odWikiRuleSet.Execute then
      FWRS:=odWikiRuleSet.FileName
    else
      FWRS:=FPath+'WikiEdit.wrs'
  else
    FWRS:=ParamStr(1);
  Caption:=FWRS;//?

  FEngine:=TWikiEngine.Create;

  //FEngine.Groups:=true;
  FEngine.LoadWikiParse(FWRS);
  //StatusBar1.Panels[0].Text:=IntToStr(Engine.WikiParseXMLLoadTime)+'ms';

  if ParamCount=2 then
    Memo1.Lines.LoadFromFile(ParamStr(2));

end;

procedure TfWikiEdit.DoClose(var Action: TCloseAction);
var
  sl:TStringList;
begin
  inherited;
  sl:=TStringList.Create;
  try

    sl.Values['Left']:=IntToStr(Left);
    sl.Values['Top']:=IntToStr(Top);
    sl.Values['Right']:=IntToStr(Left+Width);
    sl.Values['Bottom']:=IntToStr(Top+Height);

    if WindowState=wsMaximized then sl.Values['Maximized']:='1';

    sl.Values['Preview']:=IntToStr(HtmlViewer1.Height);

    sl.SaveToFile(FPath+'WikiEdit.ini');
  finally
    sl.Free;
  end;
end;

procedure TfWikiEdit.DoDestroy;
begin
  FEngine.Free;
  inherited;
end;

procedure TfWikiEdit.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfWikiEdit.HtmlViewer1HotSpotClick(Sender: TObject; const SRC: string;
  var Handled: Boolean);
begin
  //
  Caption:='HS:'+SRC;
  Handled:=true;
end;

procedure TfWikiEdit.HtmlViewer1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=$43) and (Shift=[ssCtrl]) then
    HtmlViewer1.CopyToClipboard;
end;

procedure TfWikiEdit.HtmlViewer1Link(Sender: TObject; const Rel, Rev,
  Href: string);
begin
  //
  Caption:=Rel+'::'+Rev+'::'+Href;
end;

procedure TfWikiEdit.HtmlViewer1RightClick(Sender: TObject;
  Parameters: TRightClickParameters);
begin
  //
  Caption:='RC';
end;

procedure TfWikiEdit.aRefreshExecute(Sender: TObject);
begin
  //WebBrowser1.Navigate('file:'+LPath+'WikiEdit.html');
  FEngine.LoadWikiParse(FWRS);
  //StatusBar1.Panels[0].Text:=IntToStr(Engine.WikiParseXMLLoadTime)+'ms';
  Memo1.Modified:=true;
end;

procedure TfWikiEdit.aSelectAllExecute(Sender: TObject);
begin
  Memo1.SelectAll;
end;

procedure TfWikiEdit.aToggleWrapExecute(Sender: TObject);
begin
  if Memo1.ScrollBars=ssBoth then
   begin
    Memo1.ScrollBars:=ssVertical;
    Memo1.WordWrap:=true;
   end
  else
   begin
    Memo1.ScrollBars:=ssBoth;
    Memo1.WordWrap:=false;
   end;
end;

procedure TfWikiEdit.aViewHTMLExecute(Sender: TObject);
begin
  //FEngine.ParseWiki(Memo1.Text);
  HtmlViewer1.LoadFromString(HTMLEncode(FEngine.WikiOutput));
end;

procedure TfWikiEdit.aCopyAllExecute(Sender: TObject);
begin
  Memo1.SelectAll;
  Memo1.CopyToClipboard;
end;

procedure TfWikiEdit.aCutAllExecute(Sender: TObject);
begin
  Memo1.SelectAll;
  Memo1.CopyToClipboard;
  Memo1.Text:='';
end;

procedure TfWikiEdit.aLoadExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfWikiEdit.aParseChangeExecute(Sender: TObject);
begin
  odWikiRuleSet.FileName:=FWRS;
  if odWikiRuleSet.Execute then
   begin
    FWRS:=odWikiRuleSet.FileName;
    FEngine.LoadWikiParse(FWRS);
    //StatusBar1.Panels[0].Text:=IntToStr(Engine.WikiParseXMLLoadTime)+'ms';
    Caption:=FWRS;
    Memo1.Modified:=true;
   end;
end;

procedure TfWikiEdit.aSaveExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then Memo1.Lines.SaveToFile(SaveDialog1.FileName);
end;

end.
