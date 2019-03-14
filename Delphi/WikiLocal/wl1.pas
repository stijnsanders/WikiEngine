unit wl1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, ExtCtrls, ComCtrls, AppEvnts,
  WikiEngine_TLB, Menus, ActnList, System.Actions;

type
  TWikiLocalCheckHandler=function(var Name:string):boolean of object;
  TWikiLocalCheck=class(TInterfacedObject, IWikiPageCheck)
  private
    LHandler:TWikiLocalCheckHandler;
  public
    Links:TStringList;
    constructor Create(Handler:TWikiLocalCheckHandler);
    destructor Destroy; override;
    function CheckPage(var Name: WideString;
      const CurrentGroup: WideString): WordBool; safecall;
  end;
  TGetFileForName=function(Name:string):string of object;

  TfrmWikiLocalMain = class(TForm)
    panPage: TPanel;
    StatusBar1: TStatusBar;
    panSidebar: TPanel;
    Splitter1: TSplitter;
    panMain: TPanel;
    WebSidebar: TWebBrowser;
    panEdit: TPanel;
    Splitter2: TSplitter;
    panView: TPanel;
    WebMain: TWebBrowser;
    lbModifications: TListBox;
    txtEdit: TMemo;
    panCommands: TPanel;
    btnSave: TButton;
    btnReset: TButton;
    btnCancel: TButton;
    ApplicationEvents1: TApplicationEvents;
    btnEdit: TButton;
    btnGo: TButton;
    cbPage: TComboBox;
    panPageInfo: TPanel;
    pmPage: TPopupMenu;
    Edit1: TMenuItem;
    N1: TMenuItem;
    Links1: TMenuItem;
    BackLinks1: TMenuItem;
    N2: TMenuItem;
    HomePage1: TMenuItem;
    MainHomePage1: TMenuItem;
    N3: TMenuItem;
    importPMWiki1: TMenuItem;
    pmRedirect: TPopupMenu;
    RedirectItem1: TMenuItem;
    panPageName: TPanel;
    panGroupName: TPanel;
    pmSideBar: TPopupMenu;
    EditSidebar1: TMenuItem;
    N4: TMenuItem;
    Links2: TMenuItem;
    Backlinks2: TMenuItem;
    btnBack: TButton;
    btnForward: TButton;
    Search1: TMenuItem;
    ActionList1: TActionList;
    actEdit: TAction;
    actSearch: TAction;
    actHomePage: TAction;
    actMainHomePage: TAction;
    actLinks: TAction;
    actBackLinks: TAction;
    actSidebarLinks: TAction;
    actSidebarBackLinks: TAction;
    actBack: TAction;
    actForward: TAction;
    actEditSidebar: TAction;
    actFocusPageBar: TAction;
    redolinks1: TMenuItem;
    actSave: TAction;
    fix1: TAction;
    pmLink: TPopupMenu;
    miLinkEdit: TMenuItem;
    miLinkFollow: TMenuItem;
    N5: TMenuItem;
    Links3: TMenuItem;
    Backlinks3: TMenuItem;
    miLinkBack: TMenuItem;
    panSearch: TPanel;
    panSideView: TPanel;
    txtSearchText: TEdit;
    cbRegEx: TCheckBox;
    cbCaseSensitive: TCheckBox;
    btnSearch: TButton;
    tvSideList: TTreeView;
    lblMatchCount: TLabel;
    btnCloseSideList: TButton;
    actCloseSideList: TAction;
    Search2: TMenuItem;
    procedure cbPageKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WebSidebarNewWindow2(Sender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure WebMainNewWindow2(Sender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure WebSidebarBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebMainBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebMainStatusTextChange(Sender: TObject;
      const Text: WideString);
    procedure FormCreate(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure cbPageClick(Sender: TObject);
    procedure cbPageDblClick(Sender: TObject);
    procedure HomePage1Click(Sender: TObject);
    procedure MainHomePage1Click(Sender: TObject);
    procedure actLinksClick(Sender: TObject);
    procedure actBackLinksClick(Sender: TObject);
    procedure importPMWiki1Click(Sender: TObject);
    procedure panPageInfoDblClick(Sender: TObject);
    procedure RedirectItem1Click(Sender: TObject);
    procedure panPageInfoContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Splitter1Moved(Sender: TObject);
    procedure actEditSideBarClick(Sender: TObject);
    procedure actSidebarLinksClick(Sender: TObject);
    procedure actSidebarBackLinksClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnForwardClick(Sender: TObject);
    procedure actSearchClick(Sender: TObject);
    procedure actFocusPageBarExecute(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure pmPagePopup(Sender: TObject);
    procedure redolinks1Click(Sender: TObject);
    procedure fix1Execute(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure miLinkFollowClick(Sender: TObject);
    procedure miLinkEditClick(Sender: TObject);
    procedure Links3Click(Sender: TObject);
    procedure Backlinks3Click(Sender: TObject);
    procedure txtSearchTextEnter(Sender: TObject);
    procedure txtSearchTextExit(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnCloseSideListClick(Sender: TObject);
    procedure tvSideListChange(Sender: TObject; Node: TTreeNode);
    procedure tvSideListExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvSideListContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    FIsEditing, FPageModified: boolean;
    FWikiPage, FWikiGroup, FGroupDelim, FPagePath, FContextLink: string;
    FWikiPageAge, FWikiSideBarAge: TDateTime;
    procedure SetIsEditing(const Value: boolean);
    procedure SetWikiPage(const Value: string);
    function CheckEditing: boolean;
    function FileNameSafe(AWikiGroup,AWikiPage,Ext:string):string;
    procedure SaveLinks(AWikiGroup,AWikiPage:string);
    procedure OpenLink(URL:WideString);
    function SideBarIsLinking: boolean;
    procedure ShowBackLinks(w: string);
    procedure ShowLinks(w: string);
    procedure SideLoadItems(Page,Ext:string);
    procedure SideLoadBranch(np:TTreeNode;sl:TStringList);
  private
    WikiData,LPath,LData,LSideExt:string;
    WebSidebarLock,WebMainLock,WebMainWindowLock,
    DoSidebar,DoMain,DoMainEdit,DoSaveLinks,DoSaveLinksDelete:boolean;
    Engine:IEngine;
    WikiPageCheck:TWikiLocalCheck;
    WikiLinks,RedirectTrail:TStringList;
    property IsEditing:boolean read FIsEditing write SetIsEditing;
    property WikiPage:string read FWikiPage write SetWikiPage;
    function CheckWiki(var Name:string):boolean;
    procedure OpenPage(Page:string);
  public
    function SplitWikiName(const Name, Ext:string;
      var Group,Wiki,FilePath:string): boolean;
    function GetWikiData(const AWikiGroup,AWikiPage:string;
      var PageData:string;var PageAge:TDateTime):boolean;
    procedure SetWikiData(const AWikiGroup,AWikiPage,APageData:string;
      ADoLinksNow:boolean);
  end;

var
  frmWikiLocalMain: TfrmWikiLocalMain;

const
  WikiSideBar='SideBar';
  WikiHomePage='HomePage';
  WikiGroupMain='Main';
  ExtWikiData='wx';
  ExtWikiLinks='wxa';
  ExtWikiBackLinks='wxb';

implementation

uses MSHTML, ComObj, ActiveX, VBScript_RegExp_55_TLB;

{$R *.dfm}

{ TWikiLocalCheck }

constructor TWikiLocalCheck.Create(Handler:TWikiLocalCheckHandler);
begin
  LHandler:=Handler;
  Links:=TStringList.Create;
  Links.Duplicates:=dupIgnore;
  Links.Sorted:=true;
end;

destructor TWikiLocalCheck.Destroy;
begin
  Links.Free;
  inherited;
end;

function TWikiLocalCheck.CheckPage(var Name: WideString;
  const CurrentGroup: WideString): WordBool;
var
  s:string;
begin
  s:=Name;
  Result:=LHandler(s);
  Name:=s;
  Links.Add(Name);
end;

{ TfrmWikiLocalMain }

procedure TfrmWikiLocalMain.FormCreate(Sender: TObject);
begin
  OleInitialize(nil);
  panGroupName.Caption:='...';
  panPageName.Caption:='Loading...';
  FWikiPageAge:=0.0;
  FWikiSideBarAge:=0.0;
  FIsEditing:=false;
  FPageModified:=false;
  WebSidebar.Align:=alClient;
  tvSideList.Align:=alClient;
end;

procedure TfrmWikiLocalMain.FormShow(Sender: TObject);
type
  TRegCall=function: HResult; stdcall;
var
  sl:TStringList;
  s:string;
  i:integer;
  f:TFileStream;
  wp:TWindowPlacement;
begin
  LPath:=ExtractFilePath(Application.ExeName);
  FGroupDelim:='.';
  FPagePath:='';

  if FileExists(LPath+'WikiLocal.ini') then
   begin
    sl:=TStringList.Create;
    try
      sl.LoadFromFile(LPath+'WikiLocal.ini');

      panSideBar.Width:=StrToInt(sl.Values['SideBar']);
      if panSideBar.Width=0 then panSideBar.Width:=1;
      panSideBar.Left:=0;
      panEdit.Height:=StrToInt(sl.Values['EditBar']);
      if panEdit.Height=0 then panEdit.Height:=1;
      panEdit.Top:=0;
      StatusBar1.Top:=ClientHeight;

      s:=sl.Values['Font1'];
      if s<>'' then Font.Name:=s;
      if TryStrToInt(sl.Values['FontSize'],i) then Font.Size:=i;
      s:=sl.Values['Font2'];
      if s<>'' then
       begin
        panGroupName.Font.Name:=s;
        panPageName.Font.Name:=s;
       end;
      s:=sl.Values['Font3'];
      if s<>'' then
        txtEdit.Font.Name:=s;

    except
      //silent!
    end;
    sl.Free;
   end;
  if FileExists(LPath+'WikiLocal.dsk') then
   begin
    try
      f:=TFileStream.Create(LPath+'WikiLocal.dsk',fmOpenRead or fmShareDenyWrite);
      try
        ZeroMemory(@wp,SizeOf(TWindowPlacement));
        f.Read(wp,SizeOf(TWindowPlacement));
        SetWindowPlacement(Handle,@wp);
      finally
        f.Free;
      end;
    except
      //silent!
    end;
   end;

  try
    TRegCall(GetProcAddress(LoadLibrary(PChar(LPath+'WikiEngine.dll')),
      'DllRegisterServer'));
  except
    //ignore registry access warnings on Windows 6
    on e:EOleSysError do if e.ErrorCode<>TYPE_E_REGISTRYACCESS then raise;
  end;

  LData:=LPath+'WikiLocal'+PathDelim;
  ForceDirectories(LData);

  Engine:=CoEngine.Create;
  Engine.Groups:=true;//?
  Engine.WikiParseXML:='file://'+LPath+'WikiLocal.xml';
  StatusBar1.Panels[0].Text:=IntToStr(Engine.WikiParseXMLLoadTime)+'ms';
  WikiPageCheck:=TWikiLocalCheck.Create(CheckWiki);
  Engine.WikiPageCheck:=WikiPageCheck;
  WikiLinks:=TStringList.Create;
  WikiLinks.Duplicates:=dupIgnore;
  WikiLinks.Sorted:=true;
  RedirectTrail:=TStringList.Create; //not sorted! duplicates!

  s:='file://'+LPath+'WikiLocal.html';

  WebSidebar.HandleNeeded;
  WebSidebarLock:=false;
  WebSidebar.Navigate(s);

  WebMain.HandleNeeded;
  WebMainLock:=false;
  WebMainWindowLock:=true;
  WebMain.Navigate(s);

  WikiPage:=WikiGroupMain+FGroupDelim+WikiHomePage;//setting homepage?
  DoSidebar:=true;
  DoMain:=true;
  DoMainEdit:=false;
  DoSaveLinks:=false;
  DoSaveLinksDelete:=false;
end;

function TfrmWikiLocalMain.CheckEditing:boolean;
begin
  Result:=true;
  if IsEditing then
    if txtEdit.Modified or FPageModified then
     begin
      case Application.MessageBox('Save changes first?','WikiLocal edit page',MB_YESNOCANCEL or MB_ICONEXCLAMATION) of
        idYes:btnSave.Click;
        idNo:IsEditing:=false;
        idCancel:Result:=false;
      end;
     end
    else
      IsEditing:=false;
end;

procedure TfrmWikiLocalMain.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  sl:TStringList;
  wp:TWindowPlacement;
  f:TFileStream;
begin
  if not(CheckEditing) then Action:=caNone;

  if Action<>caNone then
   begin
    Engine:=nil;
    //WikiPageCheck.Free;//freed by Engine dispose?
    WikiLinks.Free;
    RedirectTrail.Free;

    sl:=TStringList.Create;
    try
      if FileExists(LPath+'WikiLocal.ini') then
        sl.LoadFromFile(LPath+'WikiLocal.ini');

      sl.Values['SideBar']:=IntToStr(panSideBar.Width);
      sl.Values['EditBar']:=IntToStr(panEdit.Height);

      sl.SaveToFile(LPath+'WikiLocal.ini');
    finally
      sl.Free;
    end;

    if GetWindowPlacement(Handle,@wp) then
     begin
       f:=TFileStream.Create(LPath+'WikiLocal.dsk',fmCreate);
       try
         f.Write(wp,SizeOf(TWindowPlacement));
       finally
         f.Free;
       end;
     end;

   end;
end;

procedure TfrmWikiLocalMain.WebSidebarNewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
  Cancel:=true;
end;

procedure TfrmWikiLocalMain.WebMainNewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
  Cancel:=WebMainWindowLock;
  WebMainWindowLock:=true;
end;

procedure TfrmWikiLocalMain.WebSidebarBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
  s,t:string;
  i:integer;
begin
  if WebSidebarLock and CheckEditing then
   begin
    s:=StringReplace(URL,'\','/',[rfReplaceAll]);
    i:=Length(s);
    t:=Copy(s,i-6,5);
    while (i<>0) and not((t='edit/') or (t='view/')) do
     begin
      t:=Copy(s,i-6,5);
      dec(i);
     end;
    if i<>0 then
     begin
      s:=Copy(s,i,Length(s)-i+1);
      WikiPage:=s;
      DoMain:=true;
      //DoMainEdit:=t='edit/';
     end;
   end;

  if WebSidebarLock and not(DoMain) then
   begin
    s:=URL;
    if Copy(s,1,10)<>'wikilocal:' then OpenLink(URL);
   end;
  Cancel:=WebSidebarLock;
  WebSidebarLock:=Showing;
end;

procedure TfrmWikiLocalMain.WebMainBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
  s,t:string;
  i:integer;
begin
  if WebMainLock and CheckEditing then
   begin
    s:=StringReplace(URL,'\','/',[rfReplaceAll]);
    i:=Length(s);
    t:=Copy(s,i-6,5);
    while (i<>0) and not((t='edit/') or (t='view/')) do
     begin
      t:=Copy(s,i-6,5);
      dec(i);
     end;
    if i<>0 then
     begin
      s:=Copy(s,i,Length(s)-i+1);
      WikiPage:=s;
      DoMain:=true;
      DoMainEdit:=t='edit/';
     end;
   end;

  if WebMainLock and not(DoMain) then
   begin
    s:=URL;
    if Copy(s,1,10)<>'wikilocal:' then OpenLink(URL);
   end;
  Cancel:=WebMainLock;
  WebMainLock:=Showing;
end;

procedure TfrmWikiLocalMain.WebMainStatusTextChange(Sender: TObject;
  const Text: WideString);
var
  i:integer;
  s:string;
begin
  s:=Text;
  if (FPagePath='') and (WebMain.Document<>nil) then
   begin
    FPagePath:=(WebMain.Document as IHTMLDocument2).location.href;
    i:=Length(FPagePath);
    while (i<>0) and (FPagePath[i]<>'/') do dec(i);
    SetLength(FPagePath,i);
   end
  else
    i:=Length(FPagePath);
  if Copy(s,1,i)=FPagePath then s:='wikilocal://'+Copy(s,i,Length(s)-i+1);
  StatusBar1.Panels[3].Text:=s;
end;

procedure TfrmWikiLocalMain.SetIsEditing(const Value: boolean);
begin
  FIsEditing := Value;
  Splitter2.Top:=panPageName.Height;
  Splitter2.Visible:=FIsEditing;
  panEdit.Top:=panPageName.Height;
  panEdit.Visible:=FIsEditing;
  panPageInfo.Visible:=false;
  lbModifications.Visible:=false;//render?
  if FIsEditing then WikiLinks.Assign(WikiPageCheck.Links);
end;

procedure TfrmWikiLocalMain.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
var
  x,y:WideString;
  body:IHTMLElement;
  s,g,w,RedirectTo:string;
  Loaded,Found,LoopFound,Redirect:boolean;
  i,sp1:integer;
  sp:real;
begin
  if DoSidebar or DoMain then
   begin
    Screen.Cursor:=crHourGlass;
    try

      if DoSidebar then
       begin
        GetWikiData(FWikiGroup,WikiSideBar,s,FWikiSideBarAge);
        if btnCloseSideList.Visible=false then panGroupName.Caption:=FWikiGroup;
        body:=(WebSidebar.Document as IHTMLDocument2).body;
        try
          body.innerHTML:=Engine.Render(s,FWikiGroup);
          //while Engine.GetModification(x,y) do?
        except
          on e:Exception do
            body.innerText:='{'+e.ClassName+'}'+e.Message;
        end;
        DoSidebar:=false;
       end;

      if DoMain then
       begin
        DoMain:=false;
        body:=(WebMain.Document as IHTMLDocument2).body;
        panPageInfo.Visible:=false;
        Loaded:=false;
        Found:=false;
        LoopFound:=false;
        RedirectTrail.Clear;

        try
          while not(Loaded) do
           begin
            s:=FWikiGroup+FGroupDelim+WikiPage;
            panPageName.Caption:=s;
            panPageName.Hint:=s;
            Caption:=s+' - WikiLocal';
            Application.Title:=Caption;
            i:=cbPage.Items.IndexOf(s);
            if (cbPage.Text<>s) or (i=-1) then
             begin
              if i<>-1 then cbPage.Items.Delete(i);
              cbPage.Items.Insert(0,s);
              if cbPage.Text<>s then cbPage.ItemIndex:=0;
              //cbPage.Modified:=false;
             end;
            actBack.Enabled:=(cbPage.ItemIndex<>-1) and (cbPage.ItemIndex<cbPage.Items.Count-1);
            actForward.Enabled:=cbPage.ItemIndex>0;

            Found:=GetWikiData(FWikiGroup,WikiPage,WikiData,FWikiPageAge);
            WikiPageCheck.Links.Clear;
            body.innerHTML:=Engine.Render(WikiData,FWikiGroup);
            Loaded:=true;
            Redirect:=false;

            while Engine.GetModification(x,y) do
             begin

              if (x='redirect') and not(DoMainEdit) then
               begin
                Redirect:=true;
                g:=FWikiGroup;
                SplitWikiName(y,ExtWikiData,g,w,s);
                RedirectTo:=g+FGroupDelim+w;
                WikiPageCheck.Links.Add(RedirectTo);//add as prio link?
               end;

              //more?

             end;

            if DoSaveLinksDelete then
             begin
              DoSaveLinksDelete:=false;
              WikiPageCheck.Links.Clear;
             end;
            if DoSaveLinks then
             begin
              DoSaveLinks:=false;
              SaveLinks(FWikiGroup,WikiPage);
             end;

            if Redirect then
             begin
              if RedirectTrail.IndexOf(RedirectTo)=-1 then
               begin
                RedirectTrail.Add(FWikiGroup+FGroupDelim+FWikiPage);
                WikiPage:=RedirectTo;
                Loaded:=false;
               end
              else
                LoopFound:=true;//!!
             end;
           end;

        except
          on e:Exception do
           begin
            panPageInfo.Visible:=true;
            panPageInfo.Caption:=e.ClassName;
            body.innerText:=e.Message;
           end;
        end;

        if RedirectTrail.Count<>0 then
         begin
          panPageInfo.Visible:=true;
          if LoopFound then s:='!!! Redirect loop detected !!! ' else s:='Redirected by ';
          for i:=0 to RedirectTrail.Count-1 do
           begin
            if i<>0 then s:=s+' > ';
            s:=s+RedirectTrail[i];
           end;
          panPageInfo.Caption:=s;
         end;

        StatusBar1.Panels[1].Text:=IntToStr(Engine.LastCallTime)+'ms';
        if FWikiPageAge=0.0 then
          StatusBar1.Panels[2].Text:=''
        else
          StatusBar1.Panels[2].Text:=DateTimeToStr(FWikiPageAge);

        if DoMainEdit then
         begin
          DoMainEdit:=false;
          txtEdit.Text:=WikiData;
          FPageModified:=false;
          txtEdit.Modified:=false;
          IsEditing:=true;
          txtEdit.SetFocus;
          if Found then txtEdit.SelStart:=Length(WikiData) else txtEdit.SelectAll;
         end;

       end;
      //else?
    finally
      Screen.Cursor:=crDefault;
    end;
   end;

  if IsEditing and txtEdit.Modified then
   begin
    FPageModified:=true;
    txtEdit.Modified:=false;
    body:=(WebMain.Document as IHTMLDocument2).body;
    try
      with body as IHTMLElement2 do
       begin
        sp1:=scrollHeight;
        sp:=(scrollTop)/(sp1-clientHeight);
       end;
      body.innerHTML:=Engine.Render(txtEdit.Text,FWikiGroup);

      lbModifications.Visible:=Engine.ModificationCount<>0;
      lbModifications.Items.Clear;
      while Engine.GetModification(x,y) do
        lbModifications.Items.Add('['+x+']'+y);

      if (txtEdit.SelLength=0) and (txtEdit.SelStart=Length(txtEdit.Text)) then
        with body as IHTMLElement2 do scrollTop:=scrollHeight
      else
        with body as IHTMLElement2 do
          if scrollHeight<>sp1 then
            scrollTop:=Round((scrollHeight-clientHeight)*sp);

    except
      on e:Exception do
       begin
        body.innerText:='{'+e.ClassName+'}'+e.Message;
        lbModifications.Visible:=false;
       end;
    end;
    StatusBar1.Panels[1].Text:=IntToStr(Engine.LastCallTime)+'ms';
   end;
end;

function TfrmWikiLocalMain.GetWikiData(const AWikiGroup,AWikiPage:string;
  var PageData:string; var PageAge:TDateTime):boolean;
var
  fn:string;
  f:TFileStream;
  fi:TByHandleFileInformation;
  st:TSystemTime;
  s:AnsiString;
  l:Int64;
begin
  fn:=LData+FileNameSafe(AWikiGroup,AWikiPage,ExtWikiData);
  Result:=FileExists(fn);
  if Result then
   begin
    //var AWikiGroup/AWikiPAge and ajust to filesystem case?
    f:=TFileStream.Create(fn,fmOpenRead);
    try
      l:=f.Size;
      SetLength(s,l);
      f.Read(s[1],l);
      PageData:=string(s);
      GetFileInformationByHandle(f.Handle,fi);
      if FileTimeToSystemTime(fi.ftLastWriteTime,st) then
        PageAge:=SystemTimeToDateTime(st) else PageAge:=0.0;
    finally
      f.Free;
    end;
   end
  else
   begin
    //templates? Engine.Templates?
    PageData:='Describe [['+AWikiGroup+FGroupDelim+AWikiPage+']] here.';
    PageAge:=0.0;
   end;
end;

procedure TfrmWikiLocalMain.btnGoClick(Sender: TObject);
begin
  if CheckEditing then
   begin
    WikiPage:=cbPage.Text;
    DoMain:=true;
    cbPage.SelectAll;
   end;
end;

procedure TfrmWikiLocalMain.cbPageKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then btnGo.Click;
end;

procedure TfrmWikiLocalMain.cbPageClick(Sender: TObject);
begin
  if (cbPage.ItemIndex<>-1) and CheckEditing then
   begin
    WikiPage:=cbPage.Text;
    DoMain:=true;
   end;
end;

procedure TfrmWikiLocalMain.cbPageDblClick(Sender: TObject);
begin
  cbPage.DroppedDown:=true;
end;

procedure TfrmWikiLocalMain.btnEditClick(Sender: TObject);
begin
  if not(IsEditing) then
   begin
    WikiPage:=cbPage.Text;
    DoMain:=true;
    DoMainEdit:=true;
   end;
end;

procedure TfrmWikiLocalMain.btnCancelClick(Sender: TObject);
begin
  //verif?
  IsEditing:=false;
  DoMain:=true;
end;

procedure TfrmWikiLocalMain.SetWikiData(const AWikiGroup,AWikiPage,
  APageData:string;ADoLinksNow:boolean);
var
  f:TFileStream;
  fn:string;
  s:AnsiString;
  l:Int64;
begin
  fn:=LData+FileNameSafe(AWikiGroup,AWikiPage,ExtWikiData);

  //check changed externally
  if (AWikiPage=FWikiPage) and FileExists(fn) then
   begin
    f:=TFileStream.Create(fn,fmOpenReadWrite);
    try
      l:=f.Size;
      SetLength(s,l);
      f.Read(s[1],l);
    finally
      f.Free;
    end;
    if string(s)<>WikiData then
      raise Exception.Create('WikiPage edited externally, please refresh page and repeat changes.');
   end;

  s:=AnsiString(APageData);
  if (s='') or (s='delete') then
   begin
    //verif?
    DeleteFile(fn);
    DeleteFile(LData+FileNameSafe(AWikiGroup,AWikiPage,ExtWikiLinks));
    DoSaveLinksDelete:=true;
   end
  else
   begin
    f:=TFileStream.Create(fn,fmCreate);
    try
      f.Write(s[1],Length(s));
    finally
      f.Free;
    end;
   end;
  if ADoLinksNow then
   begin
    fn:=LData+FileNameSafe(AWikiGroup,AWikiPage,ExtWikiLinks);
    if FileExists(fn) then WikiLinks.LoadFromFile(fn) else WikiLinks.Clear;
    WikiPageCheck.Links.Clear;
    Engine.Render(APageData,AWikiGroup);
    if DoSaveLinksDelete then
     begin
      WikiPageCheck.Links.Clear;
      DoSaveLinksDelete:=false;
     end;
    SaveLinks(AWikiGroup,AWikiPage);
   end
  else
    DoSaveLinks:=true;
end;

procedure TfrmWikiLocalMain.btnSaveClick(Sender: TObject);
begin
  SetWikiData(FWikiGroup,WikiPage,txtEdit.Text,false);
  IsEditing:=false;
  DoMain:=true;
  if (WikiPage=WikiSideBar) or SideBarIsLinking then DoSideBar:=true;
end;

function TfrmWikiLocalMain.SideBarIsLinking:boolean;
var
  fn:string;
  sl:TStringList;
begin
  fn:=LData+FileNameSafe(FWikiGroup,WikiPage,ExtWikiBackLinks);
  if FileExists(fn) then
   begin
    //try except silent?
    sl:=TStringList.Create;
    try
      sl.LoadFromFile(fn);
      Result:=sl.IndexOf(FWikiGroup+FGroupDelim+WikiSideBar)<>-1;
    finally
      sl.Free;
    end;
   end
  else
    Result:=false;
end;

procedure TfrmWikiLocalMain.btnResetClick(Sender: TObject);
begin
  DoMain:=true;
  DoMainEdit:=true;
end;

function TfrmWikiLocalMain.SplitWikiName(const Name, Ext:string;
  var Group, Wiki, FilePath: string):boolean;
var
  i,p:integer;
begin
  if (Group<>'') and (Name<>'') then
    FilePath:=LData+FileNameSafe(Group,Name,Ext);
  if (Group<>'') and (Name<>'') and FileExists(FilePath) then
   begin
    Wiki:=Name;
    Result:=true;
   end
  else
   begin
    //FindGroupDelim
    i:=1;
    p:=0;
    while (i<=Length(Name)) and (p=0) do
     begin
      p:=1;
      while (p<=Length(FGroupDelim)) and ((i+p)<Length(Name)) and
        (Name[i+p-1]=FGroupDelim[p]) do inc(p);
      if (p<=Length(FGroupDelim)) then
       begin
        inc(i);
        p:=0;
       end;
     end;
    if (i>Length(Name)) then
     begin
      //Group:='';//leave as is?
      Wiki:=Name;
     end
    else
     begin
      Group:=Copy(Name,1,i-1);
      inc(i,Length(FGroupDelim));
      Wiki:=Copy(Name,i,Length(Name)-i+1);
     end;
    FilePath:=LData+FileNameSafe(Group,Wiki,Ext);
    Result:=FileExists(FilePath);
   end;
end;

procedure TfrmWikiLocalMain.SetWikiPage(const Value: string);
var
  g,fn:string;
begin
  g:=FWikiGroup;
  SplitWikiName(Value,ExtWikiData,FWikiGroup,FWikiPage,fn);
  if g<>FWikiGroup then DoSidebar:=true;
end;

function TfrmWikiLocalMain.FileNameSafe(AWikiGroup,AWikiPage,Ext:string): string;
var
  i:integer;
begin
  Result:=AWikiGroup+'.'+AWikiPage+'.'+Ext;
  for i:=1 to Length(Result) do
    if AnsiChar(Result[i]) in ['\','/',':','*','?','"','<','>','|'] then
      Result[i]:='_';
end;

function TfrmWikiLocalMain.CheckWiki(var Name: string): boolean;
var
  w,g,fn:string;
begin
  w:=FWikiPage;
  g:=FWikiGroup;
  Result:=SplitWikiName(Name,ExtWikiData,g,w,fn);
  Name:=g+FGroupDelim+w;
end;

procedure TfrmWikiLocalMain.SaveLinks(AWikiGroup,AWikiPage:string);
//attention! when FWikiPage<>AWikiPage then prepare WikiLinks (before) and WikiPageCheck.Links (after)
var
  a,b,c,i:integer;
  sla,slb,sl:TStringList;
  g,w,w1,fn:string;
  f:TFileStream;
begin
  fn:=LData+FileNameSafe(AWikiGroup,AWikiPage,ExtWikiLinks);
  if WikiPageCheck.Links.Count=0 then DeleteFile(fn) else
    WikiPageCheck.Links.SaveToFile(fn);

  //if setting save backlinks?
  sl:=TStringList.Create;
  try
    sl.Duplicates:=dupIgnore;
    sl.Sorted:=true;
    w1:=AWikiGroup+FGroupDelim+AWikiPage;
    //assert all stringlists sorted and duplicates=ignore
    sla:=WikiLinks;
    slb:=WikiPageCheck.Links;
    a:=0;
    b:=0;

    while not((a>=sla.Count) and (b>=slb.Count)) do
     begin

      if (a>=sla.Count) then c:=1 else
        if (b>=slb.Count) then c:=-1 else
          c:=CompareText(sla[a],slb[b]);//CompareStr?

      if c=0 then
       begin
        //nothing, leave as is
        inc(a);
        inc(b);
       end;
      if c<0 then
       begin
        //gone from list, remove
        if SplitWikiName(sla[a],ExtWikiBackLinks,g,w,fn) then
         begin
          f:=TFileStream.Create(fn,fmOpenReadWrite);
          sl.LoadFromStream(f);
          f.Position:=0;
         end
        else
         begin
          f:=TFileStream.Create(fn,fmCreate);
          sl.Clear;
         end;
        try
          i:=sl.IndexOf(w1);
          if i<>-1 then sl.Delete(i);
          sl.SaveToStream(f);
          f.Size:=f.Position;
        finally
          f.Free;
        end;
        if sl.Count=0 then DeleteFile(fn);
        inc(a);
       end;
      if c>0 then
       begin
        //new to list, add
        if SplitWikiName(slb[b],ExtWikiBackLinks,g,w,fn) then
         begin
          f:=TFileStream.Create(fn,fmOpenReadWrite);
          sl.LoadFromStream(f);
          f.Position:=0;
         end
        else
         begin
          f:=TFileStream.Create(fn,fmCreate);
          sl.Clear;
         end;
        try
          sl.Add(w1);
          sl.SaveToStream(f);
        finally
          f.Free;
        end;
        inc(b);
       end;

     end;
  finally
    sl.Free;
  end;

end;

procedure TfrmWikiLocalMain.OpenLink(URL: WideString);
var
  v1,v2,v3:OleVariant;
begin
  v1:=URL;
  v2:=0;
  v3:='WikiLocalExternalLink';
  WebMainWindowLock:=false;
  WebMain.Navigate2(v1,v2,v3);
end;

procedure TfrmWikiLocalMain.HomePage1Click(Sender: TObject);
begin
  OpenPage(FWikiGroup+FGroupDelim+WikiHomePage);
end;

procedure TfrmWikiLocalMain.MainHomePage1Click(Sender: TObject);
begin
  OpenPage(WikiGroupMain+FGroupDelim+WikiHomePage);
end;

procedure TfrmWikiLocalMain.actLinksClick(Sender: TObject);
begin
  ShowLinks(FWikiGroup+FGroupDelim+WikiPage);
end;

procedure TfrmWikiLocalMain.ShowLinks(w:string);
var
  s:string;
begin
  WebSidebar.Visible:=false;
  panSearch.Visible:=false;
  tvSideList.Visible:=true;
  btnCloseSideList.Visible:=true;
  s:='"'+w+'" Links';
  panGroupName.Caption:=s;
  panGroupName.Hint:=s;
  SideLoadItems(w,ExtWikiLinks);
end;

procedure TfrmWikiLocalMain.actBackLinksClick(Sender: TObject);
begin
  ShowBackLinks(FWikiGroup+FGroupDelim+WikiPage);
end;

procedure TfrmWikiLocalMain.ShowBackLinks(w:string);
var
  s:string;
begin
  WebSidebar.Visible:=false;
  panSearch.Visible:=false;
  tvSideList.Visible:=true;
  btnCloseSideList.Visible:=true;
  s:='"'+w+'" Backlinks';
  panGroupName.Caption:=s;
  panGroupName.Hint:=s;
  SideLoadItems(w,ExtWikiBackLinks);
end;

procedure TfrmWikiLocalMain.importPMWiki1Click(Sender: TObject);
var
  body:IHTMLElement;
  f:TFileStream;
  fn,d:string;
  s:AnsiString;
  fd:TWin32FindData;
  fh:THandle;
  sl:TStringList;
begin
  if ParamCount=0 then raise Exception.Create('Provide PMWiki data directory as command line parameter.');
  d:=IncludeTrailingPathDelimiter(ParamStr(1));
  body:=(WebMain.Document as IHTMLDocument2).body;
  sl:=TStringList.Create;
  try
    fh:=FindFirstFile(PChar(d+'*.*'),fd);
    if fh<>0 then
     begin
      repeat
        if not(AnsiChar(fd.cFileName[0]) in ['.','_']) then
         begin
          WikiPage:=fd.cFileName;
          sl.LoadFromFile(d+fd.cFileName);
          WikiData:=StringReplace(sl.Values['text'],sl.Values['newline'],#13#10,[rfReplaceAll]);
          if WikiData<>'' then
           begin
            fn:=LData+FileNameSafe(FWikiGroup,WikiPage,ExtWikiData);
            s:=AnsiString(WikiData);
            f:=TFileStream.Create(fn,fmCreate);
            try
              f.Write(s[1],Length(s));
            finally
              f.Free;
            end;
            WikiLinks.Clear;//don't load, force rebuild list
            WikiPageCheck.Links.Clear;
            try
              body.innerHTML:=Engine.Render(WikiData,FWikiGroup);
              SaveLinks(FWikiGroup,WikiPage);
            except
              //silent
              on e:Exception do
               begin
                s:=AnsiString('{'+e.ClassName+'}'+e.Message);
                f:=TFileStream.Create(LData+FileNameSafe(FWikiGroup,WikiPage,'log'),fmCreate);
                try
                  f.Write(s[1],Length(s));
                finally
                  f.Free;
                end;
               end;
            end;
           end;
         end;
      until not(FindNextFile(fh,fd));
      Windows.FindClose(fh);
     end;
  finally
    sl.Free;
  end;
  WikiPage:=WikiGroupMain+FGroupDelim+WikiHomePage;
  DoMain:=true;
end;

procedure TfrmWikiLocalMain.panPageInfoDblClick(Sender: TObject);
begin
  //assert not RedirectTrail.Count=0
  //assert IsEditing=false? maar voor de zekerheid:
  if CheckEditing then
   begin
    WikiPage:=RedirectTrail[RedirectTrail.Count-1];
    DoMain:=true;
    DoMainEdit:=true;
   end;
end;

procedure TfrmWikiLocalMain.RedirectItem1Click(Sender: TObject);
begin
  //assert IsEditing=false? maar voor de zekerheid:
  if CheckEditing then
   begin
    WikiPage:=(Sender as TMenuItem).Caption;
    DoMain:=true;
    DoMainEdit:=true;
   end;
end;

procedure TfrmWikiLocalMain.panPageInfoContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  mi:TMenuItem;
  i:integer;
begin
  pmRedirect.Items.Clear;
  for i:=0 to RedirectTrail.Count-1 do
   begin
    mi:=TMenuItem.Create(pmRedirect);
    mi.Caption:=RedirectTrail[i];
    mi.OnClick:=RedirectItem1Click;
    pmRedirect.Items.Add(mi);
   end;
end;

procedure TfrmWikiLocalMain.OpenPage(Page: string);
begin
  if CheckEditing then
   begin
    WikiPage:=Page;
    DoMain:=true;
   end;
end;

procedure TfrmWikiLocalMain.Splitter1Moved(Sender: TObject);
begin
 if Left=0 then
  begin
   panSideBar.Width:=1;
   panSideBar.Left:=0;
  end;
end;

procedure TfrmWikiLocalMain.actEditSideBarClick(Sender: TObject);
begin
  if CheckEditing then
   begin
    WikiPage:=FWikiGroup+FGroupDelim+WikiSideBar;
    DoMain:=true;
    DoMainEdit:=true;
   end;
end;

procedure TfrmWikiLocalMain.actSidebarLinksClick(Sender: TObject);
begin
  ShowLinks(FWikiGroup+FGroupDelim+WikiSideBar);
end;

procedure TfrmWikiLocalMain.actSidebarBackLinksClick(Sender: TObject);
begin
  ShowBackLinks(FWikiGroup+FGroupDelim+WikiSideBar);
end;

procedure TfrmWikiLocalMain.btnBackClick(Sender: TObject);
var
  i:integer;
begin
  i:=cbPage.ItemIndex+1;
  while (i>0) and (RedirectTrail.IndexOf(cbPage.Items[i])<>-1) do inc(i);
  cbPage.ItemIndex:=i;
  cbPageClick(Sender);
end;

procedure TfrmWikiLocalMain.btnForwardClick(Sender: TObject);
begin
  cbPage.ItemIndex:=cbPage.ItemIndex-1;
  cbPageClick(Sender);
end;

procedure TfrmWikiLocalMain.actSearchClick(Sender: TObject);
begin
  WebSidebar.Visible:=false;
  panSearch.Visible:=true;
  tvSideList.Visible:=true;
  btnCloseSideList.Visible:=true;
  panGroupName.Caption:='Search';
  panGroupName.Hint:='Search';
  txtSearchText.SelectAll;
  txtSearchText.SetFocus;
end;

procedure TfrmWikiLocalMain.actFocusPageBarExecute(Sender: TObject);
begin
  cbPage.SetFocus;
  cbPage.DroppedDown:=true;
end;

procedure TfrmWikiLocalMain.ApplicationEvents1Activate(Sender: TObject);
var
  fn:string;
  fi:TWin32FileAttributeData;
  st:TSystemTime;
begin
  if FWikiSideBarAge<>0.0 then
   begin
    fn:=LData+FileNameSafe(FWikiGroup,WikiSideBar,ExtWikiData);
    if GetFileAttributesEx(PChar(fn),GetFileExInfoStandard,@fi) then
      if FileTimeToSystemTime(fi.ftLastWriteTime,st) then
        if SystemTimeToDateTime(st)<>FWikiSideBarAge then
          DoSidebar:=true;//refresh;
   end;
  if FWikiPageAge<>0.0 then
   begin
    fn:=LData+FileNameSafe(FWikiGroup,WikiPage,ExtWikiData);
    if GetFileAttributesEx(PChar(fn),GetFileExInfoStandard,@fi) then
      if FileTimeToSystemTime(fi.ftLastWriteTime,st) then
        if SystemTimeToDateTime(st)<>FWikiPageAge then
          if IsEditing then
            if Application.MessageBox('The page has been changed outside of this editor. Discard changes and reload page?','WikiLocal edit page',MB_OKCANCEL or MB_ICONEXCLAMATION)=idOk then
             begin
              IsEditing:=false;
              DoMain:=true;
             end
            else
              FWikiPageAge:=0.0//suppress further warnings
          else
            DoMain:=true;//refresh;
   end;
end;

procedure TfrmWikiLocalMain.pmPagePopup(Sender: TObject);
var
  i:integer;
begin
  if (GetKeyState(VK_CONTROL) and $80)=$80 then
    for i:=0 to pmPage.Items.Count-1 do pmPage.Items[i].Visible:=true;
end;

procedure TfrmWikiLocalMain.redolinks1Click(Sender: TObject);
var
  f:TFileStream;
  l:int64;
  fn,g,w:string;
  fd:TWin32FindData;
  fh:THandle;
  s:AnsiString;
  i,c:integer;
  x,y:WideString;
begin
  if MessageBox(Handle,'Re-do all links and backlinks?','WikiLocal',MB_OKCANCEL or MB_ICONWARNING)=idOk then
   begin
    Screen.Cursor:=crHourGlass;
    try
      fh:=FindFirstFile(PChar(LData+'*.'+ExtWikiLinks),fd);
      if fh<>0 then
       begin
        repeat
          DeleteFile(LData+fd.cFileName);
        until not(FindNextFile(fh,fd));
        Windows.FindClose(fh);
       end;
      fh:=FindFirstFile(PChar(LData+'*.'+ExtWikiBackLinks),fd);
      if fh<>0 then
       begin
        repeat
          DeleteFile(LData+fd.cFileName);
        until not(FindNextFile(fh,fd));
        Windows.FindClose(fh);
       end;

      c:=0;
      fh:=FindFirstFile(PChar(LData+'*.'+ExtWikiData),fd);
      if fh<>0 then
       begin
        repeat
          fn:=fd.cFileName;
          f:=TFileStream.Create(LData+fn,fmOpenRead);
          try
            l:=f.Size;
            SetLength(s,l);
            f.Read(s[1],l);
            WikiData:=string(s);
          finally
            f.Free;
          end;
          i:=Length(fn);
          while (i<>0) and (fn[i]<>'.') do dec(i);
          SplitWikiName(Copy(fn,1,i-1),ExtWikiData,FWikiGroup,FWikiPage,fn);
          WikiLinks.Clear;
          WikiPageCheck.Links.Clear;
          Engine.Render(WikiData,FWikiGroup);
          while Engine.GetModification(x,y) do
           begin
            if (x='redirect') then
             begin
              g:=FWikiGroup;
              SplitWikiName(y,ExtWikiData,g,w,fn);
              WikiPageCheck.Links.Add(g+FGroupDelim+w);
             end;
            //more?
           end;
          SaveLinks(FWikiGroup,WikiPage);
          inc(c);
        until not(FindNextFile(fh,fd));
        Windows.FindClose(fh);
       end;
    finally
      Screen.Cursor:=crDefault;
    end;
    MessageBox(Handle,PChar('Links and backlinks re-done for '+IntToStr(c)+' pages'),'WikiLocal',MB_OK or MB_ICONINFORMATION);
   end;
  WikiPage:=WikiGroupMain+FGroupDelim+WikiHomePage;
  DoMain:=true;
end;

procedure TfrmWikiLocalMain.fix1Execute(Sender: TObject);
var
  i:integer;
begin
  if txtEdit.Focused then
   begin
    i:=txtEdit.SelStart;//cursor position
    //assert Ctrl is down (since this event handler is handling Ctrl+Backspace)
    txtEdit.Perform(WM_KEYDOWN,VK_LEFT,0);
    txtEdit.Perform(WM_KEYUP,VK_LEFT,0);
    txtEdit.SelLength:=i-txtEdit.SelStart;
    txtEdit.ClearSelection;
   end;
end;

procedure TfrmWikiLocalMain.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  e:IHTMLElement;
  ea:IHTMLAnchorElement;
  i:integer;
begin
  if (Msg.message=WM_RBUTTONDOWN) and ((Msg.wParam and MK_CONTROL)=0) then
   begin
    e:=nil;
    if IsChild(WebMain.Handle,Msg.hwnd) then
     begin
      FContextLink:='';//default
      e:=(WebMain.Document as IHTMLDocument2).elementFromPoint(LoWord(Msg.lParam),HiWord(Msg.lParam));
     end;
    if IsChild(WebSidebar.Handle,Msg.hwnd) then
     begin
      FContextLink:='wikilocal:///view/'+FWikiGroup+FGroupDelim+WikiSideBar;//default page (for edit)
      e:=(WebSidebar.Document as IHTMLDocument2).elementFromPoint(LoWord(Msg.lParam),HiWord(Msg.lParam));
     end;
    if e<>nil then
     begin
      try
        ea:=e as IHTMLAnchorElement;
        FContextLink:=ea.href;
        if FPagePath='' then
         begin
          FPagePath:=(WebMain.Document as IHTMLDocument2).location.href;
          i:=Length(FPagePath);
          while (i<>0) and (FPagePath[i]<>'/') do dec(i);
          SetLength(FPagePath,i);
         end
        else
          i:=Length(FPagePath);
        if Copy(FContextLink,1,i)=FPagePath then FContextLink:='wikilocal://'+
          Copy(FContextLink,i,Length(FContextLink)-i+1);
        miLinkFollow.Enabled:=Copy(FContextLink,1,18)='wikilocal:///view/';
      except
        on e:EIntfCastError do
          miLinkFollow.Enabled:=false;
      end;
      if (FContextLink='') or (Copy(FContextLink,1,11)='wikilocal:/') then
       begin
        pmLink.Popup(Msg.pt.X,Msg.pt.Y);
        Handled:=true;
       end;
     end;
   end;
end;

procedure TfrmWikiLocalMain.miLinkFollowClick(Sender: TObject);
begin
  if CheckEditing then
   begin
    //skip 'wikilocal:///view/'
    WikiPage:=Copy(FContextLink,19,Length(FContextLink)-18);
    DoMain:=true;
    DoMainEdit:=copy(FContextLink,14,4)='edit';
   end;
end;

procedure TfrmWikiLocalMain.miLinkEditClick(Sender: TObject);
begin
  if FContextLink='' then actEdit.Execute else
    if CheckEditing then
     begin
      //skip 'wikilocal:///edit/'
      WikiPage:=Copy(FContextLink,19,Length(FContextLink)-18);
      DoMain:=true;
      DoMainEdit:=true;
     end;
end;

procedure TfrmWikiLocalMain.Links3Click(Sender: TObject);
begin
  if FContextLink='' then actLinks.Execute else
    ShowLinks(Copy(FContextLink,19,Length(FContextLink)-18));
end;

procedure TfrmWikiLocalMain.Backlinks3Click(Sender: TObject);
begin
  if FContextLink='' then actBackLinks.Execute else
    ShowBackLinks(Copy(FContextLink,19,Length(FContextLink)-18));
end;

procedure TfrmWikiLocalMain.txtSearchTextEnter(Sender: TObject);
begin
  btnSearch.Default:=true;
end;

procedure TfrmWikiLocalMain.txtSearchTextExit(Sender: TObject);
begin
  btnSearch.Default:=false;
end;

function ToRegEx(x:string):string;
var
  i,j:integer;
begin
  SetLength(Result,Length(x)*2);
  j:=1;
  for i:=1 to Length(x) do
   begin
    if AnsiChar(x[i]) in ['*','$','|','\','(',')','[',']','^','+','.','?'] then
     begin
      Result[j]:='\';
      inc(j);
     end;
    Result[j]:=x[i];
    inc(j);
   end;
  SetLength(Result,j-1);
end;

procedure TfrmWikiLocalMain.btnSearchClick(Sender: TObject);
var
  re:IRegExp2;
  f:TFileStream;
  s:AnsiString;
  t:string;
  fd:TWin32FindData;
  fh:THandle;
  i,c:integer;
  sl:TStringList;
begin
  lblMatchCount.Caption:='...';
  re:=CoRegExp.Create;
  re.Global:=false;//?since not replacing
  re.Multiline:=true;
  re.IgnoreCase:=not(cbCaseSensitive.Checked);
  if cbRegEx.Checked then
    re.Pattern:=txtSearchText.Text
  else
    re.Pattern:=ToRegEx(txtSearchText.Text);
  c:=0;
  sl:=TStringList.Create;
  Screen.Cursor:=crHourGlass;
  tvSideList.Items.BeginUpdate;
  try
    tvSideList.Items.Clear;
    LSideExt:=ExtWikiLinks;
    sl.Sorted:=true;//?
    fh:=FindFirstFile(PChar(LData+'*.'+ExtWikiData),fd);
    if fh<>0 then
     begin
      repeat
        if not(AnsiChar(fd.cFileName[0]) in ['.','_']) then
         begin
          f:=TFileStream.Create(LData+fd.cFileName,fmOpenRead);
          try
            SetLength(s,f.Size);
            f.Read(s[1],f.Size);
          finally
            f.Free;
          end;
          if re.Test(WideString(s)) then
           begin
            t:=fd.cFileName;
            i:=Length(t);
            while (i<>0) and (t[i]<>'.') do dec(i);
            sl.Add(Copy(t,1,i-1));
            inc(c);
           end;
         end;
      until not(FindNextFile(fh,fd));
      Windows.FindClose(fh);
     end;
    SideLoadBranch(nil,sl);
    lblMatchCount.Caption:=IntToStr(c)+' pages found';
  finally
    tvSideList.Items.EndUpdate;
    Screen.Cursor:=crDefault;
    sl.Free;
    re:=nil;
  end;
  //if c=0 then
  // begin
    txtSearchText.SetFocus;
    txtSearchText.SelectAll;
  // end
  //else
  //  tvSideList.SetFocus;
end;

procedure TfrmWikiLocalMain.btnCloseSideListClick(Sender: TObject);
begin
  panSearch.Visible:=false;
  tvSideList.Visible:=false;
  WebSidebar.Visible:=false;
  btnCloseSideList.Visible:=false;
  panGroupName.Caption:=FWikiGroup;
  panGroupName.Hint:=FWikiGroup;
end;

procedure TfrmWikiLocalMain.tvSideListChange(Sender: TObject; Node: TTreeNode);
begin
  if (Node<>nil) and CheckEditing then
   begin
    WikiPage:=Node.Text;
    DoMain:=true;
    //TODO: on search: highlight matches in content
   end;
end;

procedure TfrmWikiLocalMain.SideLoadItems(Page, Ext: string);
var
  fn,g,w:string;
  sl:TStringList;
begin
  LSideExt:=Ext;
  sl:=TStringList.Create;
  Screen.Cursor:=crHourGlass;
  tvSideList.Items.BeginUpdate;
  try
    tvSideList.Items.Clear;
    if SplitWikiName(Page,LSideExt,g,w,fn) then
      sl.LoadFromFile(fn); //else sl.Clear;?
    SideLoadBranch(nil,sl);
  finally
    tvSideList.Items.EndUpdate;
    Screen.Cursor:=crDefault;
    sl.Free;
  end;
  //tvSideList.SetFocus;
end;

procedure TfrmWikiLocalMain.SideLoadBranch(np:TTreeNode;sl:TStringList);
var
  i:integer;
  n:TTreeNode;
  sp:TStringList;
  g,w,fn:string;
begin
  //assert caller does tvSideList.Items.BeginUpdate/EndUpdate
  //assert caller does n.DeleteChildren
  sp:=TStringList.Create;
  try
    sp.Duplicates:=dupIgnore;
    //build path first for loop check
    n:=np;
    while n<>nil do
     begin
      sp.Add(n.Text);
      n:=n.Parent;
     end;
    for i:=0 to sl.Count-1 do
     begin
      n:=tvSideList.Items.AddChild(np,sl[i]);
      //show looping but not expandible?
      if (sp.IndexOf(sl[i])=-1) then
       begin
        if SplitWikiName(sl[i],LSideExt,g,w,fn) then
          n.HasChildren:=true;
       end;
     end;
  finally
    sp.Free;
  end;
end;
procedure TfrmWikiLocalMain.tvSideListExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var
  fn,g,w:string;
  sl:TStringList;
begin
  if Node.Data=nil then
   begin
    Node.Data:=Self;
    sl:=TStringList.Create;
    Screen.Cursor:=crHourGlass;
    tvSideList.Items.BeginUpdate;
    try
      //Node.DeleteChildren;??
      Node.HasChildren:=false;
      if SplitWikiName(Node.Text,LSideExt,g,w,fn) then
        sl.LoadFromFile(fn); //else?
      SideLoadBranch(Node,sl);
    finally
      tvSideList.Items.EndUpdate;
      Screen.Cursor:=crDefault;
      sl.Free;
    end;
   end;
end;

procedure TfrmWikiLocalMain.tvSideListContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  if tvSideList.Selected=nil then
    FContextLink:=''
  else
    FContextLink:='wikilocal:///view/'+tvSideList.Selected.Text;
end;

end.
