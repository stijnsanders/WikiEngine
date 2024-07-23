unit we1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, ExtCtrls, OleCtrls, SHDocVw, StdCtrls, WikiEngine_TLB,
  ComCtrls, ActnList, Menus;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    WebBrowser1: TWebBrowser;
    Splitter1: TSplitter;
    ApplicationEvents1: TApplicationEvents;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    aSelectAll: TAction;
    aRefresh: TAction;
    aViewHTML: TAction;
    aToggleWrap: TAction;
    aCopyAll: TAction;
    aCutAll: TAction;
    ListBox1: TListBox;
    ParseDialog1: TOpenDialog;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    aLoad: TAction;
    aSave: TAction;
    aParseChange: TAction;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WebBrowser1NewWindow2(Sender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure WebBrowser1BeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowser1StatusTextChange(Sender: TObject;
      const Text: WideString);
    procedure aSelectAllExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aViewHTMLExecute(Sender: TObject);
    procedure aToggleWrapExecute(Sender: TObject);
    procedure aCopyAllExecute(Sender: TObject);
    procedure aCutAllExecute(Sender: TObject);
    procedure aLoadExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure aParseChangeExecute(Sender: TObject);
  private
    LPath,LXmlPath:string;
    Engine:IEngine;
    LockNav,DocDone:boolean;
  public
  end;

var
  Form1: TForm1;

implementation

uses ComObj, ActiveX, MSHTML;

{$R *.dfm}

procedure TForm1.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
var
  x,y:WideString;
  body:IHTMLElement;
begin
  if Memo1.Modified then
   begin
    body:=(WebBrowser1.Document as IHTMLDocument2).body;

    try
      body.innerHTML:=Engine.Render(Memo1.Text,'CurrentGroup');

      ListBox1.Visible:=Engine.ModificationCount<>0;
      ListBox1.Items.Clear;
      while Engine.GetModification(x,y) do
        ListBox1.Items.Add('['+x+']'+y);

      if (Memo1.SelLength=0) and (Memo1.SelStart=Length(Memo1.Text)) then
        with body as IHTMLElement2 do scrollTop:=scrollHeight;

    except
      on e:Exception do
       begin
        body.innerText:='{'+e.ClassName+'}'+e.Message;
        ListBox1.Visible:=false;
       end;
    end;

    StatusBar1.Panels[1].Text:=IntToStr(Engine.LastCallTime)+'ms';

    Memo1.Modified:=false;
   end;
end;

procedure TForm1.FormShow(Sender: TObject);
type
  //TRegCall=function: HResult; stdcall;
  T_DGCO=function(const CLSID, IID: TGUID; var Obj): HResult; stdcall;//DllGetClassObject
var
  sl:TStringList;
  i:integer;
  p:T_DGCO;
  cf:IClassFactory;
begin
  LPath:=Application.ExeName;
  i:=Length(LPath);
  while (i>0) and (LPath[i]<>'\') do dec(i);
  SetLength(LPath,i);

  if FileExists(LPath+'WikiEdit.ini') then
   begin
    sl:=TStringList.Create;
    try
      sl.LoadFromFile(LPath+'WikiEdit.ini');

      if sl.Values['Maximized']='1' then WindowState:=wsMaximized else
        BoundsRect:=Rect(
          StrToInt(sl.Values['Left']),
          StrToInt(sl.Values['Top']),
          StrToInt(sl.Values['Right']),
          StrToInt(sl.Values['Bottom']));

      WebBrowser1.Height:=StrToInt(sl.Values['Preview']);
      StatusBar1.Top:=ClientHeight;

    except
      //silent!
    end;

    sl.Free;
   end;

  {
  try
    TRegCall(GetProcAddress(LoadLibrary(PChar(LPath+'WikiEngine.dll')),
      'DllRegisterServer'));
  except
    on e:EOleSysError do if e.ErrorCode<>TYPE_E_REGISTRYACCESS then raise;
  end;
  }
  p:=GetProcAddress(LoadLibrary(PChar(LPath+'WikiEngine.dll')),'DllGetClassObject');
  if (@p=nil) or (p(CLASS_Engine,IClassFactory,cf)<>S_OK) then
    RaiseLastOSError;
  //Engine:=CoEngine.Create;
  if cf.CreateInstance(nil,IEngine,Engine)<>S_OK then RaiseLastOSError;
  if ParamCount=0 then
   begin
    if ParseDialog1.Execute then
      LXmlPath:='file://'+ParseDialog1.FileName
    else
      LXmlPath:='file://'+LPath+'wikiparse_pmwiki.xml'
   end
  else
    LXmlPath:=ParamStr(1);

  if ParamCount=2 then
   begin
    Memo1.Lines.LoadFromFile(ParamStr(2));
    Memo1.Modified:=true;
   end;

  Engine.Groups:=true;

  if FileExists(LPath+'WikiEdit.udl') then
    Engine.ConnectionString:='File name='+LPath+'WikiEdit.udl';

  Engine.WikiParseXML:=LXmlPath;
  StatusBar1.Panels[0].Text:=IntToStr(Engine.WikiParseXMLLoadTime)+'ms';

  WebBrowser1.HandleNeeded;
  LockNav:=false;
  WebBrowser1.Navigate('file:'+LPath+'WikiEdit.html');

  Caption:=Engine.WikiParseXML;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  sl:TStringList;
begin
  Engine:=nil;

  sl:=TStringList.Create;

  sl.Values['Left']:=IntToStr(Left);
  sl.Values['Top']:=IntToStr(Top);
  sl.Values['Right']:=IntToStr(Left+Width);
  sl.Values['Bottom']:=IntToStr(Top+Height);

  if WindowState=wsMaximized then sl.Values['Maximized']:='1';

  sl.Values['Preview']:=IntToStr(WebBrowser1.Height);

  sl.SaveToFile(LPath+'WikiEdit.ini');
  sl.Free;

end;

procedure TForm1.WebBrowser1NewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
  Cancel:=true;
end;

procedure TForm1.WebBrowser1BeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  Cancel:=LockNav;
  LockNav:=Showing;
end;

procedure TForm1.WebBrowser1StatusTextChange(Sender: TObject;
  const Text: WideString);
begin
  StatusBar1.Panels[2].Text:=Text;
end;

procedure TForm1.aSelectAllExecute(Sender: TObject);
begin
  Memo1.SelectAll;
end;

procedure TForm1.aRefreshExecute(Sender: TObject);
begin
  LockNav:=false;
  DocDone:=false;
  WebBrowser1.Navigate('file:'+LPath+'WikiEdit.html');
  Engine.WikiParseXML:=LXmlPath;
  StatusBar1.Panels[0].Text:=IntToStr(Engine.WikiParseXMLLoadTime)+'ms';
  //while WebBrowser1.Busy do Application.ProcessMessages;
  while not(DocDone) do Application.ProcessMessages;
  Memo1.Modified:=true;
end;

procedure TForm1.aViewHTMLExecute(Sender: TObject);
begin
  //debug!
  (WebBrowser1.Document as IHTMLDocument2).body.innerText:=
    //(WebBrowser1.Document as IHTMLDocument2).body.innerHTML;
    Engine.Render(Memo1.Text,'CurrentGroup');
end;

procedure TForm1.aToggleWrapExecute(Sender: TObject);
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

procedure TForm1.aCopyAllExecute(Sender: TObject);
begin
  Memo1.SelectAll;
  Memo1.CopyToClipboard;
end;

procedure TForm1.aCutAllExecute(Sender: TObject);
begin
  Memo1.SelectAll;
  Memo1.CopyToClipboard;
  Memo1.Text:='';
end;

procedure TForm1.aLoadExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.aSaveExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then Memo1.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TForm1.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  DocDone:=true;
end;

procedure TForm1.aParseChangeExecute(Sender: TObject);
begin
  if ParseDialog1.Execute then
   begin
    LXmlPath:='file://'+ParseDialog1.FileName;
    Engine.WikiParseXML:=LXmlPath;
    StatusBar1.Panels[0].Text:=IntToStr(Engine.WikiParseXMLLoadTime)+'ms';
    Caption:=Engine.WikiParseXML;
    Memo1.Modified:=true;
   end;
end;

initialization
  OleInitialize(nil);
finalization
  //OleUninitialize;

end.
