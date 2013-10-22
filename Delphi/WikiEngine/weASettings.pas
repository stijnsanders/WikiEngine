unit weASettings;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, WikiEngine_TLB, StdVcl, weWikiParse, ADODB_TLB;

//ATTENTION: when Settings_TableName grows beyond 32, change here!
const
  TableNameMax=31;

type
  TEngine = class(TAutoObject, IEngine)
  private
    FTableNames:array[0..TableNameMax] of WideString;
    FDBCon:Connection;
    FConStr,FConUName,FConPwd,FParseURL:WideString;
    FPageLockTime:integer;
    FWikiParser:TWikiParser;

    FCallStartTC,FCallDoneTC:cardinal;
    FDoGroups:boolean;
    FAuthor,FSessionInfo,FGroupDelim:WideString;

    //start and end all COM methods with:
    procedure CallStart;
    procedure CallDone;

    function DbCon:Connection;

    function DoRender(Data, CurrentGroup: WideString): WideString;

    //use CheckGroup when calling these!
    function GetData(Name:WideString):RecordSet;
    function DefaultData(Name:WideString):WideString;
    function GetHistory(Name:WideString):RecordSet;
    function GetLock(Name:WideString):RecordSet;

    function FindGroupDelim(Name:WideString):integer;
    function GetGroup(Name:WideString):WideString;
    function StripGroup(Name:WideString):WideString;
    function CheckGroup(CurrentGroup,Name:WideString):WideString;
    function CheckWiki(CurrentGroup:WideString;var Name:WideString):boolean;

  protected
    function Get_ConnectionString: WideString; safecall;
    function Get___DBConnection: IUnknown; safecall;
    function Get_TableName(Name: Setting_TableName): WideString;
      safecall;
    procedure Set_ConnectionString(const Value: WideString); safecall;
    procedure Set___DBConnection(const Value: IUnknown); safecall;
    procedure Set_TableName(Name: Setting_TableName;
      const Value: WideString); safecall;
    function Get_DBUserName: WideString; safecall;
    procedure Set_DBPassword(const Value: WideString); safecall;
    procedure Set_DBUserName(const Value: WideString); safecall;
    function Get_DBPassword: WideString; safecall;
    function Get_PageLockTime: Integer; safecall;
    procedure Set_PageLockTime(Value: Integer); safecall;
    function Get_WikiParseXML: WideString; safecall;
    procedure Set_WikiParseXML(const Value: WideString); safecall;
    function Render(const Data, CurrentGroup: WideString): WideString;
      safecall;
    function Get_WikiParseXMLLoadTime: Integer; safecall;
    function Get_Author: WideString; safecall;
    function Get_Groups: WordBool; safecall;
    function Get_LastCallTime: Integer; safecall;
    function Get_SessionInfo: WideString; safecall;
    function GetPage(const Name: WideString; Rendered: WordBool): WideString;
      safecall;
    procedure Set_Author(const Value: WideString); safecall;
    procedure Set_Groups(Value: WordBool); safecall;
    procedure Set_SessionInfo(const Value: WideString); safecall;
    procedure SetPage(const Name, Data: WideString); safecall;
    function CheckLock(const Name: WideString): OleVariant; safecall;
    function CheckPage(var Name: WideString;
      const CurrentGroup: WideString): WordBool; safecall;
    function Get_GroupDelim: WideString; safecall;
    procedure Set_GroupDelim(const Value: WideString); safecall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;


implementation

uses Windows, ComServ, SysUtils, Variants, MSXML2_TLB, weCommon;

procedure TEngine.Initialize;
var
  i:integer;
begin
  inherited;
  FDBCon:=nil;
  FConStr:='';
  FPageLockTime:=20;
  FParseURL:='';
  FWikiParser:=nil;

  FCallDoneTC:=0;
  FCallStartTC:=0;
  FDBCon:=nil;
  FAuthor:='';
  FSessionInfo:='';

  //defaults

  FDoGroups:=false;

  for i:=0 to TableNameMax do
    case i of
      tnPage: FTableNames[i]:='wikiPage';
      tnPageName: FTableNames[i]:='Name';
      tnPageData: FTableNames[i]:='Data';
      tnPageCreated: FTableNames[i]:='Created';
      tnPageModified: FTableNames[i]:='Modified';

      tnLink: FTableNames[i]:='wikiLink';
      tnLinkFromPage: FTableNames[i]:='FromPage';
      tnLinkToPage: FTableNames[i]:='ToPage';

      tnLock: FTableNames[i]:='wikiLock';
      tnLockName: FTableNames[i]:='Name';
      tnLockInfo: FTableNames[i]:='Info';
      tnLockSince: FTableNames[i]:='Since';

      tnHistory: FTableNames[i]:='wikiHistory';
      tnHistoryName: FTableNames[i]:='Name';
      tnHistoryType: FTableNames[i]:='Type';
      tnHistoryAuthor: FTableNames[i]:='Author';
      tnHistoryData: FTableNames[i]:='Data';
      tnHistoryInfo: FTableNames[i]:='Info';
      tnHistoryCreated: FTableNames[i]:='Created';
      else
        FTableNames[i]:='';
    end;
end;

procedure TEngine.CallStart;
begin
  FCallStartTC:=GetTickCount;
  FCallDoneTC:=FCallStartTC;
end;

procedure TEngine.CallDone;
begin
  FCallDoneTC:=GetTickCount;
end;

function TEngine.Get_LastCallTime: Integer;
begin
  Result:=FCallDoneTC-FCallStartTC;
end;

function TEngine.Get_ConnectionString: WideString;
begin
  Result:=FConStr;
end;

function TEngine.Get___DBConnection: IUnknown;
begin
  Result:=FDBCon;
end;

function TEngine.Get_TableName(Name: Setting_TableName): WideString;
begin
  Result:=FTableNames[Name];
end;

procedure TEngine.Set_ConnectionString(
  const Value: WideString);
begin
  FConStr:=Value;
end;

procedure TEngine.Set___DBConnection(const Value: IUnknown);
begin
  FDBCon:=Value as Connection;
end;

procedure TEngine.Set_TableName(Name: Setting_TableName; const Value: WideString);
begin
  FTableNames[Name]:=Value;
end;

function TEngine.Get_DBUserName: WideString;
begin
  Result:=FConUName;
end;

procedure TEngine.Set_DBPassword(const Value: WideString);
begin
  FConPwd:=Value;
end;

procedure TEngine.Set_DBUserName(const Value: WideString);
begin
  FConUName:=Value;
end;

function TEngine.Get_DBPassword: WideString;
begin
  Result:=FConPwd;
end;

function TEngine.Get_PageLockTime: Integer;
begin
  Result:=FPageLockTime;
end;

procedure TEngine.Set_PageLockTime(Value: Integer);
begin
  FPageLockTime:=Value;
end;

function TEngine.Get_WikiParseXML: WideString;
begin
  Result:=FParseURL;
end;

procedure TEngine.Set_WikiParseXML(const Value: WideString);
var
  pdoc:DOMDocument;
begin
  CallStart;
  FParseURL:=Value;

  pdoc:=CoDOMDocument.Create;
  pdoc.async:=false;
  pdoc.preserveWhiteSpace:=true;
  //pdoc.validateOnParse:=false;
  //pdoc.resolveExternals:=false;

  if not(pdoc.load(FParseURL)) then
    raise Exception.Create('[WikiEngine.WikiParseXML]'+FParseURL+#13#10+
      pdoc.parseError.reason);

  FreeAndNil(FWikiParser);

  FWikiParser:=TWikiParser.Create;
  FWikiParser.OnWikiCheck:=CheckWiki;
  FWikiParser.Load(pdoc);

  pdoc:=nil;
  CallDone;
end;

function TEngine.Render(const Data, CurrentGroup: WideString): WideString;
begin
  CallStart;
  if not(Assigned(FWikiParser)) then
    raise Exception.Create('[WikiEngine.Render]Load WikiParseXML first');

  Result:=DoRender(Data,CurrentGroup);

  CallDone;
end;

destructor TEngine.Destroy;
begin
  FreeAndNil(FWikiParser);
  inherited;
end;

function TEngine.CheckWiki(CurrentGroup:WideString;var Name: WideString): boolean;
var
  v:OleVariant;
  q:Recordset;
begin
  //fix group prefix?

  q:=(FDBCon as Connection).Execute('SELECT '+FTableNames[tnPage]+'.'+
      FTableNames[tnPageName]+' FROM '+FTableNames[tnPage]+' WHERE '+
      FTableNames[tnPage]+'.'+FTableNames[tnPageName]+'='+
      SQLStr(Name),v,adCmdText);
  if q.EOF then Result:=false else
   begin
    Result:=true;
    Name:=CheckGroup(CurrentGroup,q.Fields[0].Value);
   end;
  q:=nil;
end;

function TEngine.Get_WikiParseXMLLoadTime: Integer;
begin
  if Assigned(FWikiParser) then Result:=FWikiParser.ParseTime else Result:=-1;
end;

function TEngine.Get_Author: WideString;
begin
  Result:=FAuthor;
end;

function TEngine.Get_SessionInfo: WideString;
begin
  Result:=FSessionInfo;
end;

function TEngine.GetPage(const Name: WideString;
  Rendered: WordBool): WideString;
begin
  CallStart;

  with GetData(Name) do
   begin
    if EOF then Result:=DefaultData(Name)
      else Result:=Fields[FTableNames[tnPageData]].Value;
    if Rendered then Result:=DoRender(Result,GetGroup(Name));
   end;

  CallDone;
end;

procedure TEngine.Set_Author(const Value: WideString);
begin
  FAuthor:=Value;
end;

procedure TEngine.Set_Groups(Value: WordBool);
begin
  FDoGroups:=Value;
end;

procedure TEngine.Set_SessionInfo(const Value: WideString);
begin
  FSessionInfo:=Value;
end;

procedure TEngine.SetPage(const Name, Data: WideString);
var
  s:WideString;
  UpdateType:History_EntryType;
  d:TDateTime;
  v:OleVariant;
  lrs:RecordSet;
begin
  CallStart;

  //perform sanity checks on data?

  //check lock
  lrs:=GetLock(Name);
  if not(lrs.EOF) and not(lrs.Fields[FTableNames[tnLockInfo]].Value=FSessionInfo) then
   begin
    d:=VarToDateTime(lrs.Fields[FTableNames[tnLockSince]].Value)+
      (FPageLockTime/1440);
    if Now<d then
      raise Exception.Create('[WikiEngine.SetPage]Page "'+Name+
        '" locked until '+DateTimeToStr(d));
   end;

  if Data='' then
   begin
    UpdateType:=htDeletePage;
    //delete page
    DbCon.Execute('DELETE FROM '+FTableNames[tnPage]+
      ' WHERE '+FTableNames[tnPageName]+'='+SQLStr(Name),v,adCmdText);

    //clear links
    DbCon.Execute('DELETE FROM '+FTableNames[tnLink]+
      ' WHERE '+FTableNames[tnLinkFromPage]+'='+SQLStr(Name),v,adCmdText);
   end
  else
   begin
    //store
    with GetData(Name) do
     begin
      if EOF then
       begin
        AddNew(EmptyParam,EmptyParam);
        Fields[FTableNames[tnPageName]].Value:=Name;
        s:=FTableNames[tnPageCreated];
        if not(s='') then Fields[s].Value:=VarFromDateTime(Now);
        UpdateType:=htNewPage;
       end
      else
       begin
        UpdateType:=htUpdate;
       end;
      Fields[FTableNames[tnPageData]].Value:=Data;
      s:=FTableNames[tnPageModified];
      if not(s='') then Fields[s].Value:=VarFromDateTime(Now);
      Update(EmptyParam,EmptyParam);
     end;

    //do links
    //...

   end;

  //history
  with GetHistory(Name) do
   begin
    Fields[FTableNames[tnHistoryType]].Value:=UpdateType;
    Fields[FTableNames[tnHistoryData]].Value:=Data;
    Update(EmptyParam,EmptyParam);
   end;

  //clear lock
  if not(lrs.EOF) then lrs.Delete(adAffectCurrent);
  lrs:=nil;

  CallDone;
end;

function TEngine.CheckLock(
  const Name: WideString): OleVariant;
begin
  CallStart;

  //...
  with GetLock(Name) do
   begin

    if EOF or (Fields[FTableNames[tnLockInfo]].Value=FSessionInfo) then
      Result:=NULL
    else
     begin
      Result:=VarToDateTime(
        VarToDateTime(Fields[FTableNames[tnLockSince]])+
        (FPageLockTime/1440));
     end;
   end;

  CallDone;
end;

function TEngine.DefaultData(Name: WideString): WideString;
begin
  //construct default
  Result:='Describe '+StripGroup(Name)+' here.';
  //backlinks?
  //xml?
end;

function TEngine.GetData(Name: WideString): RecordSet;
begin
  Result:=CoRecordset.Create;
  Result.Open(
    'SELECT * FROM '+FTableNames[tnPage]+' WHERE '+FTableNames[tnPage]+'.'+
      FTableNames[tnPageName]+'= '+SQLStr(Name),
    DbCon,adOpenKeyset,adLockOptimistic,adCmdText);
end;

function TEngine.GetHistory(Name: WideString): RecordSet;
begin
  Result:=CoRecordset.Create;
  with Result do
   begin
    Open(
      'SELECT TOP 1 * FROM '+FTableNames[tnHistory]+
      ' WHERE '+FTableNames[tnHistory]+'.'+FTableNames[tnHistoryName]+'='+SQLStr(Name)+
      ' AND '+FTableNames[tnHistory]+'.'+FTableNames[tnHistoryInfo]+'='+SQLStr(FSessionInfo)+
      ' ORDER BY '+FTableNames[tnHistory]+'.'+FTableNames[tnHistoryCreated]+' DESC',
      DbCon,adOpenKeyset,adLockOptimistic,adCmdText);
    if EOF or not(Fields[FTableNames[tnHistoryInfo]].Value=FSessionInfo) then
     begin
      AddNew(EmptyParam,EmptyParam);
      Fields[FTableNames[tnHistoryName]].Value:=Name;
      Fields[FTableNames[tnHistoryInfo]].Value:=FSessionInfo;
     end;
    Fields[FTableNames[tnHistoryAuthor]].Value:=FAuthor;
    Fields[FTableNames[tnHistoryCreated]].Value:=VarFromDateTime(Now);
   end;
end;

function TEngine.GetLock(Name: WideString): RecordSet;
begin
  Result:=CoRecordset.Create;
  with Result do
   begin
    Open(
      'SELECT TOP 1 * FROM '+FTableNames[tnLock]+
      ' WHERE '+FTableNames[tnLock]+'.'+FTableNames[tnLockName]+'='+SQLStr(Name),
      DbCon,adOpenKeyset,adLockOptimistic,adCmdText);
   end;
end;

function TEngine.DbCon: Connection;
begin
  if not(Assigned(FDbCon)) or not(FDbCon.State=adStateClosed) then
   begin
    FDbCon:=CoConnection.Create;
    Result.Open(FConStr,FConUName,FConPwd,0);
    Result:=FDbCon;
   end;
end;

function TEngine.Get_Groups: WordBool;
begin
  Result:=FDoGroups;
end;

function TEngine.DoRender(Data, CurrentGroup: WideString): WideString;
begin
end;

function TEngine.FindGroupDelim(Name: WideString): integer;
var
  i,p:integer;
begin
  i:=1;
  p:=0;
  while (i<Length(Name)) and (p=0) do
   begin
    p:=1;
    while (p<Length(FGroupDelim)) and ((i+p-1)<Length(Name)) and
      (Name[i+p-1]=FGroupDelim[p]) do inc(p);
    if (p<Length(FGroupDelim)) then
     begin
      inc(i);
      p:=0;
     end;
   end;
  if (i=Length(Name)) then Result:=0 else Result:=i;
end;

function TEngine.GetGroup(Name: WideString): WideString;
var
  i:integer;
begin
  i:=FindGroupDelim(Name);
  if i=0 then Result:='' else Result:=Copy(Name,1,i-1);
end;

function TEngine.StripGroup(Name: WideString): WideString;
var
  i:integer;
begin
  i:=FindGroupDelim(Name);
  if i=0 then Result:=Name else
   begin
    inc(i,Length(FGroupDelim));
    Result:=Copy(Name,i+1,Length(Name)-i);
   end;
end;

function TEngine.CheckGroup(CurrentGroup, Name: WideString): WideString;
begin
  if FDoGroups then
   begin
    if FindGroupDelim(Name)=0 then Result:=CurrentGroup+FGroupDelim+Name
      else Result:=Name;
   end
  else
    Result:=Name;
end;

function TEngine.CheckPage(var Name: WideString;
  const CurrentGroup: WideString): WordBool;
begin
  CallStart;
  Result:=CheckWiki(CurrentGroup,Name);
  CallDone;
end;

function TEngine.Get_GroupDelim: WideString;
begin
  Result:=FGroupDelim;
end;

procedure TEngine.Set_GroupDelim(const Value: WideString);
begin
  FGroupDelim:=Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEngine, Class_Engine,
    ciMultiInstance, tmApartment);
end.
