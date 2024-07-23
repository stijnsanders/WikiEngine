unit wl1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.AppEvnts,
  HTMLUn2, HtmlView, we2, System.Actions, Vcl.ActnList;

type
  TfrmWikiLocal = class(TForm)
    splEditPage: TSplitter;
    hvMainView: THtmlViewer;
    panEdit: TPanel;
    txtEdit: TMemo;
    lbMods: TListBox;
    ApplicationEvents1: TApplicationEvents;
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    panNavigation: TPanel;
    btnNavPrev: TButton;
    btnNavNext: TButton;
    cbPageName: TComboBox;
    btnGo: TButton;
    btnEdit: TButton;
    panSideBar: TPanel;
    splSideBar: TSplitter;
    panMainView: TPanel;
    panSearch: TPanel;
    lblMatchCount: TLabel;
    txtSearchText: TEdit;
    cbRegEx: TCheckBox;
    cbCaseSensitive: TCheckBox;
    btnSearch: TButton;
    tvSideList: TTreeView;
    hvSideBar: THtmlViewer;
    panGroupName: TPanel;
    panPageName: TPanel;
    btnSideBarClose: TButton;
    panEditCmds: TPanel;
    btnSave: TButton;
    btnReset: TButton;
    btnCancel: TButton;
    panPageInfo: TPanel;
    pmPage: TPopupMenu;
    Edit1: TMenuItem;
    Search1: TMenuItem;
    N2: TMenuItem;
    HomePage1: TMenuItem;
    MainHomePage1: TMenuItem;
    N1: TMenuItem;
    Links1: TMenuItem;
    BackLinks1: TMenuItem;
    N3: TMenuItem;
    importPMWiki1: TMenuItem;
    redolinks1: TMenuItem;
    pmSideBar: TPopupMenu;
    EditSidebar1: TMenuItem;
    Search2: TMenuItem;
    N4: TMenuItem;
    Links2: TMenuItem;
    Backlinks2: TMenuItem;
    pmRedirect: TPopupMenu;
    pmLink: TPopupMenu;
    miLinkBack: TMenuItem;
    miLinkFollow: TMenuItem;
    miLinkEdit: TMenuItem;
    N5: TMenuItem;
    miLinkLinks: TMenuItem;
    miLinkBackLinks: TMenuItem;
    actNavPrev: TAction;
    actNavNext: TAction;
    StatusBar1: TStatusBar;
    actEdit: TAction;
    actSearch: TAction;
    actHomePage: TAction;
    actMainHomePage: TAction;
    actLinks: TAction;
    actBackLinks: TAction;
    actEditSideBar: TAction;
    actSideBarLinks: TAction;
    actSideBarBackLinks: TAction;
    actFocusPageBar: TAction;
    actViewHTML: TAction;
    miLinkCopy: TMenuItem;
    procedure hvRightClick(Sender: TObject;
      Parameters: TRightClickParameters);
    procedure hvMainViewHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure cbPageNameClick(Sender: TObject);
    procedure cbPageNameDblClick(Sender: TObject);
    procedure cbPageNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnGoClick(Sender: TObject);
    procedure actNavPrevExecute(Sender: TObject);
    procedure actNavNextExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure actHomePageExecute(Sender: TObject);
    procedure actMainHomePageExecute(Sender: TObject);
    procedure actLinksExecute(Sender: TObject);
    procedure actBackLinksExecute(Sender: TObject);
    procedure tvSideListExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure splSideBarMoved(Sender: TObject);
    procedure panPageInfoDblClick(Sender: TObject);
    procedure TrailItemClick(Sender: TObject);
    procedure panPageInfoContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure actEditSideBarExecute(Sender: TObject);
    procedure actSideBarLinksExecute(Sender: TObject);
    procedure actSideBarBackLinksExecute(Sender: TObject);
    procedure actFocusPageBarExecute(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure pmPagePopup(Sender: TObject);
    procedure miLinkFollowClick(Sender: TObject);
    procedure miLinkEditClick(Sender: TObject);
    procedure miLinkLinksClick(Sender: TObject);
    procedure miLinkBackLinksClick(Sender: TObject);
    procedure hvMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnSideBarCloseClick(Sender: TObject);
    procedure tvSideListChange(Sender: TObject; Node: TTreeNode);
    procedure tvSideListContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure actViewHTMLExecute(Sender: TObject);
    procedure txtSearchTextEnter(Sender: TObject);
    procedure txtSearchTextExit(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure miLinkCopyClick(Sender: TObject);
    procedure redolinks1Click(Sender: TObject);
    procedure importPMWiki1Click(Sender: TObject);
    procedure hvMainViewHotSpotCovered(Sender: TObject; const SRC: string);
  private
    FPath,FPagePath,FHeader:string;
    FEngine:TWikiEngine;
    FEncoding:TEncoding;
    FLinks,FTrail,FLinksPreEdit:TStringList;
    FWikiPage,FWikiGroup,FWikiData,FSideExt,FContextLink:string;
    FWikiPageAge,FWikiSideBarAge:TDateTime;
    FIsEditing,FPageModified:boolean;
    FContextPoint:TPoint;
    qpf:int64;

    //see ApplicationEvents1Idle
    DoSidebar,DoMain,DoMainEdit,DoSaveLinks,DoSaveLinksDelete:boolean;

    function WikiPageCheck(Sender: TObject; var Name: string;
      const CurrentGroup: string): boolean;

    function CheckEditing: boolean;
    procedure SetWikiPage(const Value: string);
    procedure SetIsEditing(const Value: boolean);
    procedure SaveLinks(const AWikiGroup,AWikiPage:string);
    function SideBarIsLinking: boolean;
    procedure ShowLinks(const w: string);
    procedure ShowBackLinks(const w: string);
    procedure SideLoadItems(const Page,Ext:string);
    procedure SideLoadBranch(np:TTreeNode;sl:TStringList);
  protected
    procedure DoShow; override;
    procedure DoClose(var Action: TCloseAction); override;
    procedure DoDestroy; override;
    property WikiPage:string read FWikiPage write SetWikiPage;
    property IsEditing:boolean read FIsEditing write SetIsEditing;
  public
    function SplitWikiName(const Name, Ext:string;
      var Group,Wiki,FilePath:string): boolean;
    function GetWikiData(const AWikiGroup,AWikiPage:string;
      var PageData:string;var PageAge:TDateTime):boolean;
    procedure SetWikiData(const AWikiGroup,AWikiPage,APageData:string;
      ADoLinksNow:boolean);
  end;

function ShellExecute(hWnd: HWND; Operation, FileName, Parameters,
  Directory: LPWSTR; ShowCmd: Integer): HINST; stdcall;

var
  frmWikiLocal: TfrmWikiLocal;

implementation

uses System.RegularExpressions, Vcl.ClipBrd;

{$R *.dfm}

const
  WikiSideBar='SideBar';
  WikiHomePage='HomePage';
  WikiGroupMain='Main';
  ExtWikiData='wx';
  ExtWikiLinks='wxa';
  ExtWikiBackLinks='wxb';

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

function FileNameSafe(const Name:string): string;
var
  i:integer;
begin
  Result:=Name;
  for i:=1 to Length(Result) do
    if AnsiChar(Result[i]) in ['\','/',':','*','?','"','<','>','|'] then
      Result[i]:='_';
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

{ TfrmWikiLocal }

procedure TfrmWikiLocal.DoShow;
var
  sl:TStringList;
  s:string;
  i:integer;
  wp:TWindowPlacement;
  f:TFileStream;
  qp1,qp2:int64;
begin
  inherited;

  //defaults
  FPath:=ExtractFilePath(Application.ExeName);
  //FPagePath:=//see below
  FEncoding:=TEncoding.UTF8;//see UTF8=0 below

  FWikiPageAge:=0.0;
  FWikiSideBarAge:=0.0;
  FIsEditing:=false;
  FPageModified:=false;

  if not(QueryPerformanceFrequency(qpf)) then qpf:=0;

  panGroupName.Caption:='...';
  panPageName.Caption:='Loading...';

  hvSideBar.Align:=alClient;
  tvSideList.Align:=alClient;


  //load settings
  if FileExists(FPath+'WikiLocal.ini') then
   begin
    sl:=TStringList.Create;
    try
      sl.LoadFromFile(FPath+'WikiLocal.ini');

      if sl.Values['UTF8']='0' then FEncoding:=TEncoding.Default;//ANSI

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

  if FileExists(FPath+'WikiLocal.dsk') then
   begin
    try
      f:=TFileStream.Create(FPath+'WikiLocal.dsk',fmOpenRead or fmShareDenyWrite);
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

  FHeader:='';//default
  if FileExists(FPath+'WikiLocal.html') then
   begin
    sl:=TStringList.Create;
    try
      sl.LoadFromFile(FPath+'WikiLocal.html');
      FHeader:=sl.Text+#13#10#13#10;
    finally
      sl.Free;
    end;
   end;

  //TODO: from config, args?
  FPagePath:=FPath+'WikiLocal'+PathDelim;
  ForceDirectories(FPagePath);

  FEngine:=TWikiEngine.Create;
  FEngine.Groups:=true;
  //FEngine.GroupDelim:='.';//from ini?
  FEngine.PageCheck:=WikiPageCheck;

  if qpf=0 then qp1:=GetTickCount*1000 else QueryPerformanceCounter(qp1);
  FEngine.LoadWikiParse(FPath+'WikiLocal.wrs');
  if qpf=0 then qp2:=GetTickCount*1000 else QueryPerformanceCounter(qp2);
  StatusBar1.Panels[0].Text:=IntToStr(int64(qp2-qp1)*1000 div qpf)+'ms';

  FLinks:=TStringList.Create(dupIgnore,true,false);
  FTrail:=TStringList.Create;//(dupError,?,?);//see ApplicationEvents1Idle
  FLinksPreEdit:=TStringList.Create(dupIgnore,true,false);

  //setting homepage?
  FWikiGroup:=WikiGroupMain;
  FWikiPage:=WikiHomePage;
  //if ParamCount>0 then SplitWikiName(ParamStr(1),;

  //see ApplicationEvents1Idle
  DoSidebar:=true;
  DoMain:=true;
  DoMainEdit:=false;
  DoSaveLinks:=false;
  DoSaveLinksDelete:=false;
end;

procedure TfrmWikiLocal.DoClose(var Action: TCloseAction);
var
  sl:TStringList;
  wp:TWindowPlacement;
  f:TFileStream;
begin
  inherited;
  sl:=TStringList.Create;
  try
    sl.Values['SideBar']:=IntToStr(panSideBar.Width);
    sl.Values['EditBar']:=IntToStr(panEdit.Height);

    sl.SaveToFile(FPath+'WikiLocal.ini');
  finally
    sl.Free;
  end;

  if GetWindowPlacement(Handle,@wp) then
   begin
     f:=TFileStream.Create(FPath+'WikiLocal.dsk',fmCreate);
     try
       f.Write(wp,SizeOf(TWindowPlacement));
     finally
       f.Free;
     end;
   end;

end;

procedure TfrmWikiLocal.DoDestroy;
begin
  FEngine.Free;
  FLinks.Free;
  FTrail.Free;
  FLinksPreEdit.Free;
  inherited;
end;

function TfrmWikiLocal.WikiPageCheck(Sender: TObject; var Name: string;
  const CurrentGroup: string): boolean;
var
  w,g,fn:string;
begin
  w:=FWikiPage;
  g:=FWikiGroup;
  Result:=SplitWikiName(Name,ExtWikiData,g,w,fn);
  Name:=g+FEngine.GroupDelim+w;
  FLinks.Add(Name);
end;

function TfrmWikiLocal.SplitWikiName(const Name, Ext: string; var Group, Wiki,
  FilePath: string): boolean;
var
  i,p:integer;
begin
  if (Group<>'') and (Name<>'') then
    FilePath:=FPagePath+FileNameSafe(Group+'.'+Name+'.'+Ext);
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
      while (p<=Length(FEngine.GroupDelim)) and ((i+p)<Length(Name)) and
        (Name[i+p-1]=FEngine.GroupDelim[p]) do inc(p);
      if (p<=Length(FEngine.GroupDelim)) then
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
      inc(i,Length(FEngine.GroupDelim));
      Wiki:=Copy(Name,i,Length(Name)-i+1);
     end;
    FilePath:=FPagePath+FileNameSafe(Group+'.'+Wiki+'.'+Ext);
    Result:=FileExists(FilePath);
   end;
end;

procedure TfrmWikiLocal.ApplicationEvents1Activate(Sender: TObject);
var
  fn:string;
  fi:TWin32FileAttributeData;
  st:TSystemTime;
begin
  if FWikiSideBarAge<>0.0 then
   begin
    fn:=FPagePath+FileNameSafe(FWikiGroup+'.'+WikiSideBar+'.'+ExtWikiData);
    if GetFileAttributesEx(PChar(fn),GetFileExInfoStandard,@fi) then
      if FileTimeToSystemTime(fi.ftLastWriteTime,st) then
        if SystemTimeToDateTime(st)<>FWikiSideBarAge then
          DoSidebar:=true;//refresh;
   end;
  if FWikiPageAge<>0.0 then
   begin
    fn:=FPagePath+FileNameSafe(FWikiGroup+'.'+WikiPage+'.'+ExtWikiData);
    if GetFileAttributesEx(PChar(fn),GetFileExInfoStandard,@fi) then
      if FileTimeToSystemTime(fi.ftLastWriteTime,st) then
        if SystemTimeToDateTime(st)<>FWikiPageAge then
          if IsEditing then
            if Application.MessageBox(
              'The page has been changed outside of this editor.'+
              #13#10'Discard changes and reload page?','WikiLocal edit page',
              MB_OKCANCEL or MB_ICONEXCLAMATION)=idOk then
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

procedure TfrmWikiLocal.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
var
  Loaded,Found,LoopFound,Redirect:boolean;
  s,g,w,key,val,RedirectTo:string;
  i:integer;
  qp1,qp2:int64;
  sp1:integer;
  sp:double;
begin
  if DoSidebar or DoMain then
   begin
    Screen.Cursor:=crHourGlass;
    try

      if DoSidebar then
       begin
        DoSidebar:=false;
        try
          GetWikiData(FWikiGroup,WikiSideBar,s,FWikiSideBarAge);
          if btnSideBarClose.Visible=false then panGroupName.Caption:=FWikiGroup;

          FEngine.CurrentGroup:=FWikiGroup;
          FEngine.ParseWiki(s);
          hvSideBar.LoadFromString(FHeader+FEngine.WikiOutput);
          //while FEngine.GetWikiModification(key,val) do ?
        except
          on e:Exception do
            hvSideBar.LoadFromString(
              '<div style="font-weight:bold;color:red;border:1px solid black;padding:0.2em;">'
              +HTMLEncode('{'+e.ClassName+'}'+e.Message)+'</div>');
        end;
       end;

      if DoMain then
       begin
        DoMain:=false;

        panPageInfo.Visible:=false;
        Loaded:=false;
        Found:=false;
        LoopFound:=false;
        FTrail.Clear;

        try
          while not(Loaded) do
           begin
            s:=FWikiGroup+FEngine.GroupDelim+FWikiPage;
            panPageName.Caption:=s;
            panPageName.Hint:=s;
            Caption:=s+' - WikiLocal';
            Application.Title:=Caption;
            i:=cbPageName.Items.IndexOf(s);
            if (cbPageName.Text<>s) or (i=-1) then
             begin
              if i<>-1 then cbPageName.Items.Delete(i);
              cbPageName.Items.Insert(0,s);
              if cbPageName.Text<>s then cbPageName.ItemIndex:=0;
              //cbPageName.Modified:=false;
             end;
            actNavPrev.Enabled:=(cbPageName.ItemIndex<>-1)
              and (cbPageName.ItemIndex<cbPageName.Items.Count-1);
            actNavNext.Enabled:=(cbPageName.ItemIndex>0);

            Found:=GetWikiData(FWikiGroup,FWikiPage,FWikiData,FWikiPageAge);
            FLinks.Clear;

            if qpf=0 then qp1:=GetTickCount*1000 else QueryPerformanceCounter(qp1);
            FEngine.CurrentGroup:=FWikiGroup;
            FEngine.ParseWiki(FWikiData);
            if qpf=0 then qp2:=GetTickCount*1000 else QueryPerformanceCounter(qp2);

            hvMainView.LoadFromString(FHeader+FEngine.WikiOutput);
            Loaded:=true;
            Redirect:=false;

            lbMods.Items.BeginUpdate;
            try
              lbMods.Items.Clear;
              while FEngine.GetWikiModification(key,val) do
               begin
                lbMods.Items.Add('['+key+']'+val);

                if (key='redirect') and not(DoMainEdit) then
                 begin
                  Redirect:=true;
                  g:=FWikiGroup;
                  SplitWikiName(val,ExtWikiData,g,w,s);
                  RedirectTo:=g+FEngine.GroupDelim+w;
                  FLinks.Add(RedirectTo);//add as prio link?
                 end;

                //more?

               end;
            finally
              lbMods.Items.EndUpdate;
            end;
            lbMods.Visible:=lbMods.Items.Count<>0;

            if txtEdit.SelStart=Length(txtEdit.Text) then
              if hvMainView.VScrollBarRange>0 then
                hvMainView.VScrollBarPosition:=hvMainView.VScrollBarRange;

            if DoSaveLinksDelete then
             begin
              DoSaveLinksDelete:=false;
              FLinks.Clear;
             end;
            if DoSaveLinks then
             begin
              DoSaveLinks:=false;
              SaveLinks(FWikiGroup,FWikiPage);
             end;

            if Redirect then
             begin
              if FTrail.IndexOf(RedirectTo)=-1 then
               begin
                FTrail.Add(FWikiGroup+FEngine.GroupDelim+FWikiPage);
                FWikiPage:=RedirectTo;
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
            lbMods.Visible:=false;
            hvMainView.LoadFromString(
              '<div style="font-weight:bold;color:red;border:1px solid black;padding:0.2em;">'
              +HTMLEncode('{'+e.ClassName+'}'+e.Message)+'</div>');
           end;
        end;

        if FTrail.Count<>0 then
         begin
          panPageInfo.Visible:=true;
          if LoopFound then s:='!!! Redirect loop detected !!! ' else s:='Redirected by ';
          for i:=0 to FTrail.Count-1 do
           begin
            if i<>0 then s:=s+' > ';
            s:=s+FTrail[i];
           end;
          panPageInfo.Caption:=s;
         end;

        StatusBar1.Panels[1].Text:=IntToStr(int64(qp2-qp1)*1000 div qpf)+'ms';
        if FWikiPageAge=0.0 then
          StatusBar1.Panels[2].Text:=''
        else
          StatusBar1.Panels[2].Text:=DateTimeToStr(FWikiPageAge);

        if DoMainEdit then
         begin
          DoMainEdit:=false;
          txtEdit.Text:=FWikiData;
          FPageModified:=false;
          txtEdit.Modified:=false;
          IsEditing:=true;
          txtEdit.SetFocus;
          if Found then txtEdit.SelStart:=Length(FWikiData) else txtEdit.SelectAll;
         end;

       end;

    finally
      Screen.Cursor:=crDefault;
    end;
   end;

  if IsEditing and txtEdit.Modified then
   begin
    FPageModified:=true;
    txtEdit.Modified:=false;
    try
      sp1:=hvMainView.VScrollBarRange;
      sp:=hvMainView.VScrollBarPosition/(sp1-hvMainView.ClientHeight);

      if qpf=0 then qp1:=GetTickCount*1000 else QueryPerformanceCounter(qp1);
      FEngine.CurrentGroup:=FWikiGroup;
      FEngine.ParseWiki(txtEdit.Text);
      if qpf=0 then qp2:=GetTickCount*1000 else QueryPerformanceCounter(qp2);

      hvMainView.LoadFromString(FHeader+FEngine.WikiOutput);

      lbMods.Items.BeginUpdate;
      try
        lbMods.Items.Clear;
        while FEngine.GetWikiModification(key,val) do
          lbMods.Items.Add('['+key+']'+val);
      finally
        lbMods.Items.EndUpdate;
      end;
      lbMods.Visible:=lbMods.Items.Count<>0;

      if txtEdit.SelStart=Length(txtEdit.Text) then
       begin
        if hvMainView.VScrollBarRange>0 then
          hvMainView.VScrollBarPosition:=hvMainView.VScrollBarRange;
       end
      else
        if hvMainView.VScrollBarRange<>sp1 then
          hvMainView.VScrollBarPosition:=Round(
            (hvMainView.VScrollBarRange-hvMainView.ClientHeight)*sp);

    except
      on e:Exception do
       begin
        panPageInfo.Visible:=true;
        panPageInfo.Caption:=e.ClassName;
        lbMods.Visible:=false;
        hvMainView.LoadFromString(
          '<div style="font-weight:bold;color:red;border:1px solid black;padding:0.2em;">'
          +HTMLEncode('{'+e.ClassName+'}'+e.Message)+'</div>');
       end;
    end;
    StatusBar1.Panels[1].Text:=IntToStr(int64(qp2-qp1)*1000 div qpf)+'ms';
   end;

end;

function TfrmWikiLocal.CheckEditing:boolean;
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

procedure TfrmWikiLocal.miLinkCopyClick(Sender: TObject);
begin
  Clipboard.AsText:=FContextLink;
end;

function TfrmWikiLocal.GetWikiData(const AWikiGroup, AWikiPage: string;
  var PageData: string; var PageAge: TDateTime): boolean;
var
  fn:string;
  f:TFileStream;
  fi:TByHandleFileInformation;
  st:TSystemTime;
  d:TBytes;
  l:Int64;
begin
  fn:=FPagePath+FileNameSafe(AWikiGroup+'.'+AWikiPage+'.'+ExtWikiData);
  Result:=FileExists(fn);
  if Result then
   begin
    //var AWikiGroup/AWikiPAge and ajust to filesystem case?
    f:=TFileStream.Create(fn,fmOpenRead);
    try
      l:=f.Size;
      SetLength(d,l);
      if f.Read(d[0],l)<>l then RaiseLastOSError;
      GetFileInformationByHandle(f.Handle,fi);
      if FileTimeToSystemTime(fi.ftLastWriteTime,st) then
        PageAge:=SystemTimeToDateTime(st) else PageAge:=0.0;
    finally
      f.Free;
    end;
    PageData:=FEncoding.GetString(d);
   end
  else
   begin
    //templates? Engine.Templates?
    PageData:='Describe [['+AWikiGroup+FEngine.GroupDelim+AWikiPage+']] here.';
    PageAge:=0.0;
   end;
end;

procedure TfrmWikiLocal.SetWikiPage(const Value: string);
var
  g,fn:string;
begin
  g:=FWikiGroup;
  SplitWikiName(Value,ExtWikiData,FWikiGroup,FWikiPage,fn);
  if g<>FWikiGroup then DoSidebar:=true;
  DoMain:=true;
end;

procedure TfrmWikiLocal.SetIsEditing(const Value: boolean);
begin
  FIsEditing:=Value;
  splEditPage.Top:=panPageName.Height;
  splEditPage.Visible:=FIsEditing;
  panEdit.Top:=panPageName.Height;
  panEdit.Visible:=FIsEditing;
  panPageInfo.Visible:=false;
  lbMods.Visible:=false;//render?
  if FIsEditing then FLinksPreEdit.Assign(FLinks);
end;

procedure TfrmWikiLocal.SetWikiData(const AWikiGroup, AWikiPage,
  APageData: string; ADoLinksNow: boolean);
var
  f:TFileStream;
  fn:string;
  d:TBytes;
  s:string;
  l:Int64;
begin
  fn:=FPagePath+FileNameSafe(AWikiGroup+'.'+AWikiPage+'.'+ExtWikiData);

  //check changed externally
  if (AWikiPage=FWikiPage) and FileExists(fn) then
   begin
    f:=TFileStream.Create(fn,fmOpenReadWrite);
    try
      l:=f.Size;
      SetLength(d,l);
      if f.Read(d[0],l)<>l then RaiseLastOSError;
    finally
      f.Free;
    end;
    s:=FEncoding.GetString(d);
    if s<>FWikiData then
      raise Exception.Create('WikiPage edited externally, please refresh page and repeat changes.');
   end;

  if (APageData='') or (APageData='delete') then
   begin
    //verif?
    DeleteFile(fn);
    DeleteFile(FPagePath+FileNameSafe(AWikiGroup+'.'+AWikiPage+'.'+ExtWikiLinks));
    DoSaveLinksDelete:=true;
   end
  else
   begin
    d:=FEncoding.GetBytes(APageData);
    l:=Length(d);
    f:=TFileStream.Create(fn,fmCreate);
    try
      if f.Write(d[0],l)<>l then RaiseLastOSError;
    finally
      f.Free;
    end;
   end;
  if ADoLinksNow then
   begin
    fn:=FPagePath+FileNameSafe(AWikiGroup+'.'+AWikiPage+'.'+ExtWikiLinks);
    if FileExists(fn) then FLinks.LoadFromFile(fn) else FLinks.Clear;
    FLinksPreEdit.Clear;
    FEngine.CurrentGroup:=AWikiGroup;
    FEngine.ParseWiki(APageData);
    if DoSaveLinksDelete then
     begin
      FLinks.Clear;
      DoSaveLinksDelete:=false;
     end;
    SaveLinks(AWikiGroup,AWikiPage);
   end
  else
    DoSaveLinks:=true;
end;

procedure TfrmWikiLocal.SaveLinks(const AWikiGroup,AWikiPage:string);
//ATTENTION! when FWikiPage<>AWikiPage then prepare FLinksPreEdit (before) and FLinks (after)
var
  a,b,c,i:integer;
  sla,slb,sl:TStringList;
  g,w,w1,fn:string;
  f:TFileStream;
begin
  fn:=FPagePath+FileNameSafe(AWikiGroup+'.'+AWikiPage+'.'+ExtWikiLinks);
  if FLinks.Count=0 then DeleteFile(fn) else
    FLinks.SaveToFile(fn);

  //if setting save backlinks?
  sl:=TStringList.Create(dupIgnore,true,false);
  try
    w1:=AWikiGroup+FEngine.GroupDelim+AWikiPage;
    //assert all stringlists sorted and duplicates=ignore
    sla:=FLinksPreEdit;
    slb:=FLinks;
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
          sl.LoadFromStream(f);//,FEncoding);
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
          sl.SaveToStream(f,FEncoding);
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
          sl.LoadFromStream(f);//,FEncoding);
          f.Position:=0;
         end
        else
         begin
          f:=TFileStream.Create(fn,fmCreate);
          sl.Clear;
         end;
        try
          sl.Add(w1);
          sl.SaveToStream(f,FEncoding);
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

procedure TfrmWikiLocal.btnGoClick(Sender: TObject);
begin
  if CheckEditing then
   begin
    WikiPage:=cbPageName.Text;
    cbPageName.SelectAll;
   end;
end;

procedure TfrmWikiLocal.actNavPrevExecute(Sender: TObject);
var
  i:integer;
begin
  i:=cbPageName.ItemIndex+1;
  while (i>0) and (FTrail.IndexOf(cbPageName.Items[i])<>-1) do inc(i);
  cbPageName.ItemIndex:=i;
  cbPageNameClick(Sender);
end;

procedure TfrmWikiLocal.actNavNextExecute(Sender: TObject);
begin
  cbPageName.ItemIndex:=cbPageName.ItemIndex-1;
  cbPageNameClick(Sender);
end;

const
  shell32 = 'shell32.dll';

function ShellExecute; external shell32 name 'ShellExecuteW';

procedure TfrmWikiLocal.hvMainViewHotSpotClick(Sender: TObject; const SRC: string;
  var Handled: Boolean);
var
  s:string;
begin
  s:=Copy(SRC,1,5);
  if (s='view/') or (s='edit/') then
   begin
    if CheckEditing then
     begin
      WikiPage:=Copy(SRC,6,Length(SRC)-5);
      DoMainEdit:=s='edit/';
     end;
   end
  else
  if (s='http:') or (s='https') then
   begin
    //URLDecode?
    ShellExecute(Handle,nil,PChar(
      StringReplace(SRC,'%','%%',[rfReplaceAll])),nil,nil,SW_NORMAL);//?
   end
  else
    raise Exception.Create('Unknown URL type "'+SRC+'"');
  Handled:=true;
end;

procedure TfrmWikiLocal.hvMainViewHotSpotCovered(Sender: TObject;
  const SRC: string);
begin
  StatusBar1.Panels[3].Text:=SRC;
end;

procedure TfrmWikiLocal.hvMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p:TPoint;
begin
  p.X:=X;
  p.Y:=Y;
  FContextPoint:=(Sender as TWinControl).ClientToScreen(p);
end;

procedure TfrmWikiLocal.hvRightClick(Sender: TObject;
  Parameters: TRightClickParameters);
var
  b:boolean;
begin
  FContextLink:=Parameters.URL;
  b:=FContextLink<>'';

  miLinkFollow.Enabled:=b;
  miLinkLinks.Enabled:=b;
  miLinkBackLinks.Enabled:=b;
  miLinkCopy.Enabled:=b;

  pmLink.Popup(FContextPoint.X,FContextPoint.Y);

end;

procedure TfrmWikiLocal.miLinkFollowClick(Sender: TObject);
begin
  if CheckEditing then
   begin
    //assert Copy(WikiPage,1,5)='edit/' or 'view/'
    WikiPage:=Copy(FContextLink,6,Length(FContextLink)-5);
    DoMainEdit:=copy(FContextLink,1,4)='edit';
   end;
end;

procedure TfrmWikiLocal.miLinkEditClick(Sender: TObject);
begin
  if FContextLink='' then actEdit.Execute else
    if CheckEditing then
     begin
      //assert Copy(WikiPage,1,5)='edit/' or 'view/'
      WikiPage:=Copy(FContextLink,6,Length(FContextLink)-5);
      DoMainEdit:=true;
     end;
end;

procedure TfrmWikiLocal.panPageInfoContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  mi:TMenuItem;
  i:integer;
begin
  pmRedirect.Items.Clear;
  for i:=0 to FTrail.Count-1 do
   begin
    mi:=TMenuItem.Create(pmRedirect);
    mi.Caption:=FTrail[i];
    mi.OnClick:=TrailItemClick;
    pmRedirect.Items.Add(mi);
   end;
end;

procedure TfrmWikiLocal.miLinkLinksClick(Sender: TObject);
begin
  if FContextLink='' then actLinks.Execute else
   begin
    //assert Copy(WikiPage,1,5)='edit/' or 'view/'
    ShowLinks(Copy(FContextLink,6,Length(FContextLink)-5));
   end;
end;

procedure TfrmWikiLocal.miLinkBackLinksClick(Sender: TObject);
begin
  if FContextLink='' then actBackLinks.Execute else
   begin
    //assert Copy(WikiPage,1,5)='edit/' or 'view/'
    ShowBackLinks(Copy(FContextLink,6,Length(FContextLink)-5));
   end;
end;

procedure TfrmWikiLocal.TrailItemClick(Sender: TObject);
begin
  //assert IsEditing=false? maar voor de zekerheid:
  if CheckEditing then
   begin
    WikiPage:=(Sender as TMenuItem).Caption;
    DoMainEdit:=true;
   end;
end;

procedure TfrmWikiLocal.panPageInfoDblClick(Sender: TObject);
begin
  //assert FTrail.Count>0
  //assert IsEditing=false? maar voor de zekerheid:
  if CheckEditing then
   begin
    WikiPage:=FTrail[FTrail.Count-1];
    DoMainEdit:=true;
   end;
end;

procedure TfrmWikiLocal.pmPagePopup(Sender: TObject);
var
  i:integer;
begin
  if (GetKeyState(VK_CONTROL) and $80)=$80 then
    for i:=0 to pmPage.Items.Count-1 do pmPage.Items[i].Visible:=true;
end;

procedure TfrmWikiLocal.cbPageNameClick(Sender: TObject);
begin
  if (cbPageName.ItemIndex<>-1) and CheckEditing then
    WikiPage:=cbPageName.Text;
end;

procedure TfrmWikiLocal.cbPageNameDblClick(Sender: TObject);
begin
  cbPageName.DroppedDown:=true;
end;

procedure TfrmWikiLocal.cbPageNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then btnGo.Click;
end;

procedure TfrmWikiLocal.actEditExecute(Sender: TObject);
begin
  if not(IsEditing) then
   begin
    WikiPage:=cbPageName.Text;
    DoMainEdit:=true;
   end;
end;

procedure TfrmWikiLocal.actEditSideBarExecute(Sender: TObject);
begin
  if CheckEditing then
   begin
    WikiPage:=FWikiGroup+FEngine.GroupDelim+WikiSideBar;
    DoMainEdit:=true;
   end;
end;

procedure TfrmWikiLocal.actFocusPageBarExecute(Sender: TObject);
begin
  cbPageName.SetFocus;
  cbPageName.DroppedDown:=true;
end;

procedure TfrmWikiLocal.btnCancelClick(Sender: TObject);
begin
  //TODO: if Modified if MessageBox(MB_QUESTION)?
  IsEditing:=false;
  DoMain:=true;
end;

procedure TfrmWikiLocal.btnSaveClick(Sender: TObject);
begin
  SetWikiData(FWikiGroup,FWikiPage,txtEdit.Text,false);
  IsEditing:=false;
  DoMain:=true;
  if (FWikiPage=WikiSideBar) or SideBarIsLinking then DoSideBar:=true;
end;

procedure TfrmWikiLocal.btnSearchClick(Sender: TObject);
var
  re:TRegEx;
  ro:TRegExOptions;
  f:TFileStream;
  d:TBytes;
  fd:TWin32FindData;
  fh:THandle;
  sl:TStringList;
  n:string;
  i,c,l:integer;
begin
  lblMatchCount.Caption:='...';
  ro:=[roMultiLine];
  if not cbCaseSensitive.Checked then Include(ro,roIgnoreCase);
  if cbRegEx.Checked then
    re.Create(txtSearchText.Text,ro)
  else
    re.Create(ToRegEx(txtSearchText.Text),ro);
  c:=0;
  sl:=TStringList.Create(dupError,true,false);
  Screen.Cursor:=crHourGlass;
  tvSideList.Items.BeginUpdate;
  try
    tvSideList.Items.Clear;
    FSideExt:=ExtWikiLinks;
    fh:=FindFirstFile(PChar(FPagePath+'*.'+ExtWikiData),fd);
    if fh<>0 then
     begin
      repeat
        if not(AnsiChar(fd.cFileName[0]) in ['.','_']) then
         begin
          f:=TFileStream.Create(FPagePath+fd.cFileName,fmOpenRead);
          try
            l:=f.Size;
            SetLength(d,l);
            if f.Read(d[0],l)<>l then RaiseLastOSError;
          finally
            f.Free;
          end;
          if re.IsMatch(FEncoding.GetString(d)) then
           begin
            n:=fd.cFileName;
            i:=Length(n);
            while (i<>0) and (n[i]<>'.') do dec(i);
            sl.Add(Copy(n,1,i-1));
            inc(c);
           end;
         end;
      until not(FindNextFile(fh,fd));
      WinApi.Windows.FindClose(fh);
     end;
    SideLoadBranch(nil,sl);
    lblMatchCount.Caption:=IntToStr(c)+' pages found';
  finally
    tvSideList.Items.EndUpdate;
    Screen.Cursor:=crDefault;
    sl.Free;
    //re.Free?
  end;
  //if c=0 then
  // begin
    txtSearchText.SetFocus;
    txtSearchText.SelectAll;
  // end
  //else
  //  tvSideList.SetFocus;
end;

procedure TfrmWikiLocal.btnSideBarCloseClick(Sender: TObject);
begin
  panSearch.Visible:=false;
  tvSideList.Visible:=false;
  hvSideBar.Visible:=true;
  btnSideBarClose.Visible:=false;
  panGroupName.Caption:=FWikiGroup;
  panGroupName.Hint:=FWikiGroup;
end;

function TfrmWikiLocal.SideBarIsLinking:boolean;
var
  fn:string;
  sl:TStringList;
begin
  fn:=FPagePath+FileNameSafe(FWikiGroup+'.'+FWikiPage+'.'+ExtWikiBackLinks);
  if FileExists(fn) then
   begin
    sl:=TStringList.Create;
    try
      sl.LoadFromFile(fn);
      Result:=sl.IndexOf(FWikiGroup+FEngine.GroupDelim+WikiSideBar)<>-1;
    finally
      sl.Free;
    end;
   end
  else
    Result:=false;
end;

procedure TfrmWikiLocal.btnResetClick(Sender: TObject);
begin
  DoMain:=true;
  DoMainEdit:=true;
end;

procedure TfrmWikiLocal.actSearchExecute(Sender: TObject);
begin
  hvSideBar.Visible:=false;
  panSearch.Visible:=true;
  tvSideList.Visible:=true;
  btnSideBarClose.Visible:=true;
  panGroupName.Caption:='Search';
  panGroupName.Hint:='Search';
  txtSearchText.SelectAll;
  txtSearchText.SetFocus;
end;

procedure TfrmWikiLocal.actSideBarLinksExecute(Sender: TObject);
begin
  ShowLinks(FWikiGroup+FEngine.GroupDelim+WikiSideBar);
end;

procedure TfrmWikiLocal.actViewHTMLExecute(Sender: TObject);
begin
  hvMainView.LoadFromString(HTMLEncode(FEngine.WikiOutput));
end;

procedure TfrmWikiLocal.actSideBarBackLinksExecute(Sender: TObject);
begin
  ShowBackLinks(FWikiGroup+FEngine.GroupDelim+WikiSideBar);
end;

procedure TfrmWikiLocal.actHomePageExecute(Sender: TObject);
begin
  if CheckEditing then
    WikiPage:=WikiHomePage;
end;

procedure TfrmWikiLocal.actMainHomePageExecute(Sender: TObject);
begin
  if CheckEditing then
    WikiPage:=WikiGroupMain+FEngine.GroupDelim+WikiHomePage;
end;

procedure TfrmWikiLocal.splSideBarMoved(Sender: TObject);
begin
 if Left=0 then
  begin
   panSideBar.Width:=1;
   panSideBar.Left:=0;
  end;
end;

procedure TfrmWikiLocal.actLinksExecute(Sender: TObject);
begin
  ShowLinks(FWikiGroup+FEngine.GroupDelim+WikiPage);
end;

procedure TfrmWikiLocal.ShowLinks(const w:string);
var
  s:string;
begin
  hvSideBar.Visible:=false;
  panSearch.Visible:=false;
  tvSideList.Visible:=true;
  btnSideBarClose.Visible:=true;
  s:='"'+w+'" Links';
  panGroupName.Caption:=s;
  panGroupName.Hint:=s;
  SideLoadItems(w,ExtWikiLinks);
end;

procedure TfrmWikiLocal.actBackLinksExecute(Sender: TObject);
begin
  ShowBackLinks(FWikiGroup+FEngine.GroupDelim+WikiPage);
end;

procedure TfrmWikiLocal.ShowBackLinks(const w:string);
var
  s:string;
begin
  hvSideBar.Visible:=false;
  panSearch.Visible:=false;
  tvSideList.Visible:=true;
  btnSideBarClose.Visible:=true;
  s:='"'+w+'" Backlinks';
  panGroupName.Caption:=s;
  panGroupName.Hint:=s;
  SideLoadItems(w,ExtWikiBackLinks);
end;

procedure TfrmWikiLocal.SideLoadItems(const Page, Ext: string);
var
  fn,g,w:string;
  sl:TStringList;
begin
  FSideExt:=Ext;
  sl:=TStringList.Create;
  Screen.Cursor:=crHourGlass;
  tvSideList.Items.BeginUpdate;
  try
    tvSideList.Items.Clear;
    if SplitWikiName(Page,FSideExt,g,w,fn) then
      sl.LoadFromFile(fn); //else sl.Clear;?
    SideLoadBranch(nil,sl);
  finally
    tvSideList.Items.EndUpdate;
    Screen.Cursor:=crDefault;
    sl.Free;
  end;
  //tvSideList.SetFocus;
end;

procedure TfrmWikiLocal.SideLoadBranch(np:TTreeNode;sl:TStringList);
var
  i:integer;
  n:TTreeNode;
  sp:TStringList;
  g,w,fn:string;
begin
  //assert caller does tvSideList.Items.BeginUpdate/EndUpdate
  //assert caller does n.DeleteChildren
  sp:=TStringList.Create(dupIgnore,true,false);
  try
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
        if SplitWikiName(sl[i],FSideExt,g,w,fn) then
          n.HasChildren:=true;
       end;
     end;
  finally
    sp.Free;
  end;
end;

procedure TfrmWikiLocal.tvSideListChange(Sender: TObject; Node: TTreeNode);
begin
  if (Node<>nil) and CheckEditing then
    WikiPage:=Node.Text;
  //TODO: on search: highlight matches in content
end;

procedure TfrmWikiLocal.tvSideListContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  if tvSideList.Selected=nil then
    FContextLink:=''
  else
    FContextLink:='view/'+tvSideList.Selected.Text;
end;

procedure TfrmWikiLocal.tvSideListExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
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
      if SplitWikiName(Node.Text,FSideExt,g,w,fn) then
        sl.LoadFromFile(fn); //else?
      SideLoadBranch(Node,sl);
    finally
      tvSideList.Items.EndUpdate;
      Screen.Cursor:=crDefault;
      sl.Free;
    end;
   end;
end;

procedure TfrmWikiLocal.txtSearchTextEnter(Sender: TObject);
begin
  btnSearch.Default:=true;
end;

procedure TfrmWikiLocal.txtSearchTextExit(Sender: TObject);
begin
  btnSearch.Default:=false;
end;

procedure TfrmWikiLocal.redolinks1Click(Sender: TObject);
var
  f:TFileStream;
  l:int64;
  fn,g,w,key,val:string;
  fd:TWin32FindData;
  fh:THandle;
  d:TBytes;
  i,c:integer;
begin
  if MessageBox(Handle,
    'Re-do all links and backlinks?','WikiLocal',
    MB_OKCANCEL or MB_ICONWARNING)=idOk then
   begin
    Screen.Cursor:=crHourGlass;
    try
      fh:=FindFirstFile(PChar(FPagePath+'*.'+ExtWikiLinks),fd);
      if fh<>0 then
       begin
        repeat
          DeleteFile(FPagePath+fd.cFileName);
        until not(FindNextFile(fh,fd));
        WinApi.Windows.FindClose(fh);
       end;
      fh:=FindFirstFile(PChar(FPagePath+'*.'+ExtWikiBackLinks),fd);
      if fh<>0 then
       begin
        repeat
          DeleteFile(FPagePath+fd.cFileName);
        until not(FindNextFile(fh,fd));
        WinApi.Windows.FindClose(fh);
       end;

      c:=0;
      fh:=FindFirstFile(PChar(FPagePath+'*.'+ExtWikiData),fd);
      if fh<>0 then
       begin
        repeat
          fn:=fd.cFileName;
          f:=TFileStream.Create(FPagePath+fn,fmOpenRead);
          try
            l:=f.Size;
            SetLength(d,l);
            if f.Read(d[0],l)<>l then RaiseLastOSError;
            FWikiData:=FEncoding.GetString(d);
          finally
            f.Free;
          end;
          i:=Length(fn);
          while (i<>0) and (fn[i]<>'.') do dec(i);
          SplitWikiName(Copy(fn,1,i-1),ExtWikiData,FWikiGroup,FWikiPage,fn);
          FLinks.Clear;
          FLinksPreEdit.Clear;
          FEngine.CurrentGroup:=FWikiGroup;
          FEngine.ParseWiki(FWikiData);
          while FEngine.GetWikiModification(key,val) do
           begin
            if (key='redirect') then
             begin
              g:=FWikiGroup;
              SplitWikiName(val,ExtWikiData,g,w,fn);
              FLinks.Add(g+FEngine.GroupDelim+w);
             end;
            //more?
           end;
          SaveLinks(FWikiGroup,WikiPage);
          inc(c);
        until not(FindNextFile(fh,fd));
        WinApi.Windows.FindClose(fh);
       end;
    finally
      Screen.Cursor:=crDefault;
    end;
    MessageBox(Handle,PChar('Links and backlinks re-done for '+
      IntToStr(c)+' pages'),'WikiLocal',MB_OK or MB_ICONINFORMATION);
   end;
  WikiPage:=WikiGroupMain+FEngine.GroupDelim+WikiHomePage;
  DoMain:=true;
end;

procedure TfrmWikiLocal.importPMWiki1Click(Sender: TObject);
var
  f:TFileStream;
  fn,dd:string;
  d:TBytes;
  l:integer;
  fd:TWin32FindData;
  fh:THandle;
  sl:TStringList;
begin
  if ParamCount=0 then raise Exception.Create('Provide PMWiki data directory as command line parameter.');
  dd:=IncludeTrailingPathDelimiter(ParamStr(1));
  sl:=TStringList.Create;
  try
    fh:=FindFirstFile(PChar(dd+'*.*'),fd);
    if fh<>0 then
     begin
      repeat
        if not(AnsiChar(fd.cFileName[0]) in ['.','_']) then
         begin
          WikiPage:=fd.cFileName;
          sl.LoadFromFile(dd+fd.cFileName);
          FWikiData:=StringReplace(sl.Values['text'],sl.Values['newline'],#13#10,[rfReplaceAll]);
          if FWikiData<>'' then
           begin
            fn:=FPagePath+FileNameSafe(FWikiGroup+'.'+WikiPage+'.'+ExtWikiData);
            d:=FEncoding.GetBytes(FWikiData);
            l:=Length(d);
            f:=TFileStream.Create(fn,fmCreate);
            try
              if f.Write(d[0],l)<>l then RaiseLastOSError;
            finally
              f.Free;
            end;
            FLinks.Clear;//don't load, force rebuild list
            FLinksPreEdit.Clear;
            try
              FEngine.CurrentGroup:=FWikiGroup;
              FEngine.ParseWiki(FWikiData);
              SaveLinks(FWikiGroup,WikiPage);
            except
              //silent
              on e:Exception do
               begin
                d:=FEncoding.GetBytes('{'+e.ClassName+'}'+e.Message);
                l:=Length(d);
                f:=TFileStream.Create(FPagePath+
                  FileNameSafe(FWikiGroup+'.'+WikiPage+'.log'),fmCreate);
                try
                  if f.Write(d[0],l)<>l then RaiseLastOSError;
                finally
                  f.Free;
                end;
               end;
            end;
           end;
         end;
      until not(FindNextFile(fh,fd));
      WinApi.Windows.FindClose(fh);
     end;
  finally
    sl.Free;
  end;
  WikiPage:=WikiGroupMain+FEngine.GroupDelim+WikiHomePage;
  DoMain:=true;
end;

end.

