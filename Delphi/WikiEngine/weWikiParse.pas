unit weWikiParse;

//$Revision: $

interface

uses MSXML2_TLB;

type
  TWikiParseEntry=class;//forward

  TWikiCheckHandler=function(CurrentGroup:WideString;
    var Name:WideString):boolean of object;

  TwpModification=packed record
    Subject,Value:WideString;
  end;

  TWikiParser=class(TObject)
  private
    FMainEntry:TWikiParseEntry;
    FNamedEntries:array of packed record
      name:WideString;
      entry:TWikiParseEntry;
    end;
    FOnWikiCheck: TWikiCheckHandler;
    FParseTime:integer;
    FCurrentGroup: WideString;

    FMods:array of TwpModification;

    procedure SetOnWikiCheck(const Value: TWikiCheckHandler);
    procedure AddNamedEntry(id:WideString;entry:TWikiParseEntry);
    procedure SetCurrentGroup(const Value: WideString);

    function GetModCount:integer;
  protected
    function GetNamedEntry(id:WideString):TWikiParseEntry;

    function LoadEntry(Parent:TWikiParseEntry;x:IXMLDOMNode;Name:WideString=''):TWikiParseEntry;
    function LoadEntries(Parent:TWikiParseEntry;x:IXMLDOMNode):TWikiParseEntry;

    function WikiCheck(var Name:WideString):boolean;

  public
    constructor Create;
    destructor Destroy; override;

    function Render(Data:WideString):WideString;

    procedure Load(doc:DOMDocument);

    property OnWikiCheck:TWikiCheckHandler read FOnWikiCheck write SetOnWikiCheck;
    property ParseTime:integer read FParseTime;
    property CurrentGroup:WideString read FCurrentGroup write SetCurrentGroup;

    procedure GetModification(Index:integer;var Subject,Value:WideString);
    property ModificationCount:integer read GetModCount;
  end;

  TWikiParseEntry=class(TObject)
  protected
    FOwner:TWikiParser;
    FParent:TWikiParseEntry;
    procedure LoadXmlElement(x:IXMLDOMNode); virtual;
    procedure LoadFromXML(x:IXMLDOMNode); virtual;
    function LoadXmlEntry(x:IXMLDOMNode):TWikiParseEntry;
    function Render(Data:WideString):WideString; virtual; //abstract
    function RenderAll(Start:TWikiParseEntry;Data:WideString):WideString;
    procedure SetModification(Subject,Value:WideString);
  public
    Next:TWikiParseEntry;
    constructor Create(Owner:TWikiParser;Parent:TWikiParseEntry); virtual;
    destructor Destroy; override;
  end;

implementation

uses Windows, SysUtils, VBScript_RegExp_55_TLB, weWikiCommand, weUtils, WinInet;

type
  TWikiParseEntryClass=class of TWikiParseEntry;

  EWikiParserDebugBreak=class(Exception)
  private
    FValueSoFar: WideString;
  private
    constructor Create(Data:WideString);
    property ValueSoFar:WideString read FValueSoFar;
  end;

  TWikiParseEntryRE=class(TWikiParseEntry)
  protected
    FRegExp:RegExp;
    FRegExpPatternSet:boolean;
    FCurrentMatch:Match;
    procedure LoadXmlElement(x: IXMLDOMNode); override;
  public
    constructor Create(Owner: TWikiParser;Parent:TWikiParseEntry); override;
    destructor Destroy; override;
  end;

  TWikiParseEntrySimpleText=class(TWikiParseEntry)
  protected
    FSimpleText:WideString;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry);
      override;
  protected
    procedure LoadFromXML(x: IXMLDOMNode); override;
  end;

  TwpSplit=class(TWikiParseEntryRE)
  protected
    FMatch,FInbetween:TWikiParseEntry;
    FRequired:boolean;
    procedure LoadXmlElement(x: IXMLDOMNode); override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry); override;
    function Render(Data: WideString): WideString; override;
    destructor Destroy; override;
  end;

  TwpSubMatch=class(TWikiParseEntry)
  private
    FNumber,FRepeatNumber:integer;
    FDoRepeat:boolean;
  protected
    procedure LoadXmlElement(x: IXMLDOMNode); override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry); override;
    function Render(Data: WideString): WideString; override;
  end;

  TwpCheck=class(TWikiParseEntryRE)
  private
    FValue:WideString;
    FValueSet:boolean;
    FDo,FElse:TWikiParseEntry;
  protected
    procedure LoadXmlElement(x: IXMLDOMNode); override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry); override;
    function Render(Data: WideString): WideString; override;
    destructor Destroy; override;
  end;

  TwpText=class(TWikiParseEntrySimpleText)
  protected
    function Render(Data: WideString): WideString; override;
  end;

  TwpUpperCase=class(TWikiParseEntry)
  protected
    function Render(Data: WideString): WideString; override;
  end;

  TwpLowerCase=class(TWikiParseEntry)
  protected
    function Render(Data: WideString): WideString; override;
  end;

  TwpLength=class(TWikiParseEntrySimpleText)
  protected
    function Render(Data: WideString): WideString; override;
  end;

  TwpPrepend=class(TWikiParseEntrySimpleText)
  protected
    function Render(Data: WideString): WideString; override;
  end;

  TwpAppend=class(TWikiParseEntrySimpleText)
  protected
    function Render(Data: WideString): WideString; override;
  end;

  TwpGroup=class(TWikiParseEntry)
  private
    FGroupFirst:TWikiParseEntry;
  protected
    procedure LoadFromXML(x: IXMLDOMNode); override;
    function Render(Data: WideString): WideString; override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry);
      override;
    destructor Destroy; override;
  end;

  TwpConcat=class(TWikiParseEntry)
  private
    FConcatFirst:TWikiParseEntry;
  protected
    procedure LoadFromXML(x: IXMLDOMNode); override;
    function Render(Data: WideString): WideString; override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry);
      override;
    destructor Destroy; override;
  end;

  TwpReplace=class(TWikiParseEntryRE)
  protected
    FReplaceWith:WideString;
    procedure LoadXmlElement(x: IXMLDOMNode); override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry); override;
    function Render(Data: WideString): WideString; override;
  end;

  TwpReplaceIf=class(TWikiParseEntryRE)
  protected
    FReplaceWith:WideString;
    FDo,FElse:TWikiParseEntry;
    procedure LoadXmlElement(x: IXMLDOMNode); override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry); override;
    function Render(Data: WideString): WideString; override;
    destructor Destroy; override;
  end;

  TwpJump=class(TWikiParseEntry)
  protected
    FTarget:TWikiParseEntry;
    function Render(Data: WideString): WideString; override;
    procedure LoadFromXML(x: IXMLDOMNode); override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry);
      override;
    destructor Destroy; override;
  end;

  TwpHTMLEncode=class(TWikiParseEntry)
  protected
    function Render(Data: WideString): WideString; override;
  end;

  TwpURLEncode=class(TWikiParseEntry)
  protected
    function Render(Data: WideString): WideString; override;
  end;

  TwpWiki=class(TWikiParseEntryRE)
  protected
    FReplaceWith:WideString;
    FFound,FMissing,FUpdDo:TWikiParseEntry;
    FDoUpdate,FDoUpdPre,FDoUpdSuf:boolean;
    FUpdPre,FUpdSuf:WideString;
    procedure LoadXmlElement(x: IXMLDOMNode); override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry); override;
    function Render(Data: WideString): WideString; override;
    destructor Destroy; override;
  end;

  TwpExtract=class(TWikiParseEntryRE)
  private
    FSuffix: WideString;
    FPrefix: WideString;
    procedure SetPrefix(const Value: WideString);
    procedure SetSuffix(const Value: WideString);
  protected
    FREOpen,FREClose:RegExp;
    FMatch,FInbetween:TWikiParseEntry;
    FRequired:boolean;
    procedure LoadXmlElement(x: IXMLDOMNode); override;
    function Marker(id:integer):WideString;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry); override;
    function Render(Data: WideString): WideString; override;
    destructor Destroy; override;
    property Prefix:WideString read FPrefix write SetPrefix;
    property Suffix:WideString read FSuffix write SetSuffix;
  end;

  TwpDebugBreak=class(TWikiParseEntry)
  protected
    FSkipCount:integer;
    FDo:TWikiParseEntry;
    function Render(Data: WideString): WideString; override;
    procedure LoadXmlElement(x: IXMLDOMNode); override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry);
      override;
    destructor Destroy; override;
  end;

  TwpNoOp=class(TWikiParseEntry)
  protected
    function Render(Data: WideString): WideString; override;
  end;

  TwpInclude=class(TWikiParseEntry)
  private
    FRelativeURL,FResolvedURL:WideString;
    FMainEntry:TWikiParseEntry;
  protected
    function Render(Data: WideString): WideString; override;
    procedure LoadFromXML(x: IXMLDOMNode); override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry);
      override;
    destructor Destroy; override;
  end;

  TwpProcess=class(TWikiParseEntryRE)
  private
    FDo,FElse:TWikiParseEntry;
  protected
    procedure LoadXmlElement(x: IXMLDOMNode); override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry); override;
    function Render(Data: WideString): WideString; override;
    destructor Destroy; override;
  end;



{ -- loader grid to man XML NodeNames to objects }

const
  EntryClassesCount=25;//add new: increase this one!
  EntryClasses:array[0..EntryClassesCount] of packed record
    n:WideString;
    c:TWikiParseEntryClass;
  end=(
    (n:'split';      c:TwpSplit),
    (n:'submatch';   c:TwpSubMatch),
    (n:'group';      c:TwpGroup),
    (n:'check';      c:TwpCheck),
    (n:'concat';     c:TwpConcat),
    (n:'text';       c:TwpText),
    (n:'uppercase';  c:TwpUpperCase),
    (n:'lowercase';  c:TwpLowerCase),
    (n:'length';     c:TwpLength),
    (n:'prepend';    c:TwpPrepend),
    (n:'append';     c:TwpAppend),
    (n:'replace';    c:TwpReplace),
    (n:'replaceif';  c:TwpReplaceIf),
    (n:'jump';       c:TwpJump),
    (n:'htmlencode'; c:TwpHTMLEncode),
    (n:'urlencode';  c:TwpURLEncode),
    (n:'wiki';       c:TwpWiki),
    (n:'extract';    c:TwpExtract),
    (n:'break';      c:TwpDebugBreak),
    (n:'debug';      c:TwpDebugBreak),
    (n:'noop';       c:TwpNoOp),
    (n:'skip';       c:TwpNoOp),
    (n:'command';    c:TwpCommand),
    (n:'include';    c:TwpInclude),
    (n:'process';    c:TwpProcess),
    //add new here
    (n:''; c:nil)
  );

{ -- helper functions }

function XmlFirstElement(x:IXMLDOMNode):IXMLDOMNode;
begin
  Result:=x.firstChild;
  while Assigned(Result) and not(Result.nodeType=NODE_ELEMENT) do
    Result:=Result.nextSibling;
end;

function XmlToBool(x:IXMLDOMNode):boolean;
var
  s:string;
begin
  s:=LowerCase(x.text);
  Result:=(s='1') or (s='on') or (s='true');
end;

{ TWikiParser }

constructor TWikiParser.Create;
begin
  inherited Create;
  FMainEntry:=nil;
  SetLength(FNamedEntries,0);
  FOnWikiCheck:=nil;
end;

destructor TWikiParser.Destroy;
var
  i:integer;
begin
  for i:=0 to Length(FNamedEntries)-1 do FreeAndNil(FNamedEntries[i].entry);
  SetLength(FNamedEntries,0);
  FreeAndNil(FMainEntry);
  inherited;
end;

procedure TWikiParser.Load(doc: DOMDocument);
var
  t:cardinal;
begin
  t:=GetTickCount;
  FMainEntry:=LoadEntry(nil,XmlFirstElement(doc.documentElement));
  FParseTime:=GetTickCount-t;
end;

function TWikiParser.GetNamedEntry(id: WideString): TWikiParseEntry;
var
  i:integer;
begin
  i:=0;
  while (i<Length(FNamedEntries)) and not(FNamedEntries[i].name=id) do inc(i);
  if (i<Length(FNamedEntries)) then Result:=FNamedEntries[i].entry else Result:=nil;
end;

procedure TWikiParser.AddNamedEntry(id: WideString;
  entry: TWikiParseEntry);
var
  i:integer;
begin
  i:=Length(FNamedEntries);
  SetLength(FNamedEntries,i+1);
  FNamedEntries[i].name:=id;
  FNamedEntries[i].entry:=entry;
end;

function TWikiParser.Render(Data: WideString): WideString;
begin
  try
    SetLength(FMods,0);
    if Assigned(FMainEntry) then Result:=FMainEntry.Render(Data) else
      Result:=Data;
  except
    on e:EWikiParserDebugBreak do Result:=e.ValueSoFar;
  end;
end;

function TWikiParser.LoadEntries(Parent: TWikiParseEntry;
  x: IXMLDOMNode): TWikiParseEntry;
var
  pe,pl:TWikiParseEntry;
begin
  Result:=nil;
  pe:=nil;

  while Assigned(x) do
   begin

    if x.nodeType=NODE_ELEMENT then
     begin
      pl:=pe;
      pe:=LoadEntry(Parent,x);
      if Assigned(pl) then pl.Next:=pe;
      if not(Assigned(Result)) then Result:=pe;
     end;

    x:=x.nextSibling;
   end;
end;

function TWikiParser.LoadEntry(Parent: TWikiParseEntry;
  x: IXMLDOMNode;Name:WideString=''): TWikiParseEntry;
var
  i:integer;
begin
  //load single element
  if not(Assigned(x)) then Result:=nil else
   begin

    if not(x.nodeType=NODE_ELEMENT) then
      raise Exception.Create('[WikiParseXML]Invalid element "'+copy(x.xml,1,32)+'"');

    i:=0;
    while (i<EntryClassesCount) and not(EntryClasses[i].n=x.baseName) do inc(i);

    if EntryClasses[i].c=nil then
      raise Exception.Create('[WikiParseXML]Unknown parse entry "'+x.baseName+'"');

    Result:=EntryClasses[i].c.Create(Self,Parent);
    if not(Name='') then
      AddNamedEntry(Name,Result);
    Result.LoadFromXML(x);
   end;
end;

procedure TWikiParser.SetOnWikiCheck(const Value: TWikiCheckHandler);
begin
  FOnWikiCheck := Value;
end;

function TWikiParser.WikiCheck(var Name: WideString): boolean;
begin
  if Assigned(FOnWikiCheck) then Result:=FOnWikiCheck(FCurrentGroup, Name) else
    Result:=true;
end;

procedure TWikiParser.SetCurrentGroup(const Value: WideString);
begin
  FCurrentGroup := Value;
end;

function TWikiParser.GetModCount: integer;
begin
  Result:=Length(FMods);
end;

procedure TWikiParser.GetModification(Index: integer; var Subject,
  Value: WideString);
begin
  Subject:=FMods[Index].Subject;
  Value:=FMods[Index].Value;
end;

{ TWikiParseEntry }

procedure TWikiParseEntry.SetModification(Subject, Value: WideString);
var
  i:integer;
begin
  //put this in TWikiParser?

  i:=0;
  while (i<Length(FOwner.FMods)) and
    not(FOwner.FMods[i].Subject=Subject) do inc(i);

  if i=Length(FOwner.FMods) then SetLength(FOwner.FMods,i+1);

  FOwner.FMods[i].Subject:=Subject;
  FOwner.FMods[i].Value:=Value;

end;

constructor TWikiParseEntry.Create(Owner: TWikiParser;
  Parent: TWikiParseEntry);
begin
  inherited Create;
  FOwner:=Owner;
  FParent:=Parent;
  Next:=nil;
end;

destructor TWikiParseEntry.Destroy;
begin
  if Assigned(Next) then FreeAndNil(Next);
  inherited;
end;

procedure TWikiParseEntry.LoadFromXML(x: IXMLDOMNode);
var
  y:IXMLDOMNode;
begin
  inherited;
  y:=x.firstChild;
  while Assigned(y) do
   begin
    if y.nodeType=NODE_ELEMENT then LoadXmlElement(y);
    y:=y.nextSibling;
   end;
  //override me deviate
end;

procedure TWikiParseEntry.LoadXmlElement(x: IXMLDOMNode);
begin
  //overload me!
end;

function TWikiParseEntry.LoadXmlEntry(x: IXMLDOMNode): TWikiParseEntry;
begin
  Result:=FOwner.LoadEntries(Self,XmlFirstElement(x));
end;

function TWikiParseEntry.Render(Data: WideString): WideString;
begin
  //override me!
  //call RenderAll to perform a sequence!
  //Result:=Data;
end;

function TWikiParseEntry.RenderAll(Start: TWikiParseEntry;
  Data: WideString): WideString;
var
  pe:TWikiParseEntry;
begin
  Result:=Data;
  if Assigned(Start) then
   begin
    pe:=Start;
    while Assigned(pe) do
     begin
      Result:=pe.Render(Result);
      pe:=pe.Next;
     end;
   end;
end;

{ TWikiParseEntryRE }

constructor TWikiParseEntryRE.Create(Owner: TWikiParser;
  Parent: TWikiParseEntry);
begin
  inherited;
  FRegExp:=CoRegExp.Create;
  //defaults
  FRegExp.IgnoreCase:=true;
  FRegExp.Global:=true;
  FRegExp.Multiline:=true;
  FCurrentMatch:=nil;
  FRegExpPatternSet:=false;
end;

destructor TWikiParseEntryRE.Destroy;
begin
  FRegExp:=nil;
  inherited;
end;

procedure TWikiParseEntryRE.LoadXmlElement(x: IXMLDOMNode);
begin
  if x.baseName='pattern' then
   begin
    FRegExp.Pattern:=x.text;
    FRegExpPatternSet:=true;
   end
  else
  if x.baseName='global' then FRegExp.Global:=XmlToBool(x) else
  if x.baseName='ignorecase' then FRegExp.IgnoreCase:=XmlToBool(x) else
  if x.baseName='multiline' then FRegExp.Multiline:=XmlToBool(x) else
  inherited;
end;

{ TwpSplit }

constructor TwpSplit.Create(Owner: TWikiParser; Parent: TWikiParseEntry);
begin
  inherited;
  FMatch:=nil;
  FInbetween:=nil;
  //defaults
  FRequired:=false;
end;

destructor TwpSplit.Destroy;
begin
  FreeAndNil(FMatch);
  FreeAndNil(FInbetween);
  inherited;
end;

procedure TwpSplit.LoadXmlElement(x: IXMLDOMNode);
begin
  if x.baseName='match' then FMatch:=LoadXMLEntry(x) else
  if x.baseName='inbetween' then FInbetween:=LoadXMLEntry(x) else
  if x.baseName='required' then FRequired:=XmlToBool(x) else
  inherited;
end;

function TwpSplit.Render(Data: WideString): WideString;
var
  ml:MatchCollection;
  m,pm:Match;
  i:integer;
  p:integer;
  function GetChunk(f:TWikiParseEntry;Chunk:WideString):WideString;
  begin
    if Assigned(f) then Result:=RenderAll(f,Chunk) else Result:=Chunk;
  end;
begin
  //Result:=inherited Render(Data);
  ml:=FRegExp.Execute(Data) as MatchCollection;
  p:=1;
  if ml.Count=0 then
   begin
    if FRequired then Result:=Data else Result:=GetChunk(FInbetween,Data);
   end
  else
   begin
    Result:='';
    pm:=FCurrentMatch;
    for i:=0 to ml.Count-1 do
     begin
      m:=ml.Item[i] as Match;
      FCurrentMatch:=m;

      //preceding bit
      Result:=Result+GetChunk(FInbetween,Copy(Data,p,m.FirstIndex-p+1));
      //match
      Result:=Result+GetChunk(FMatch,m.Value);

      p:=m.FirstIndex+m.Length+1;
     end;
    FCurrentMatch:=pm;
    pm:=nil;
    //last bit
    Result:=Result+GetChunk(FInbetween,Copy(Data,p,Length(Data)-p+1));
    m:=nil;
   end;
  ml:=nil;
end;

{ TwpReplace }

constructor TwpReplace.Create(Owner: TWikiParser; Parent: TWikiParseEntry);
begin
  inherited;
  FReplaceWith:='';
end;

procedure TwpReplace.LoadXmlElement(x: IXMLDOMNode);
begin
  if x.baseName='with' then FReplaceWith:=x.text else
  inherited;
end;

function TwpReplace.Render(Data: WideString): WideString;
begin
  Result:=FRegExp.Replace(Data,FReplaceWith);
end;

{ TwpReplaceIf }

constructor TwpReplaceIf.Create(Owner: TWikiParser;
  Parent: TWikiParseEntry);
begin
  inherited;
  FReplaceWith:='';
  FDo:=nil;
  FElse:=nil;
end;

destructor TwpReplaceIf.Destroy;
begin
  FreeAndNil(FDo);
  FreeAndNil(FElse);
  inherited;
end;

procedure TwpReplaceIf.LoadXmlElement(x: IXMLDOMNode);
begin
  if x.baseName='with' then FReplaceWith:=x.text else
  if x.baseName='do' then FDo:=LoadXmlEntry(x) else
  if x.baseName='else' then FElse:=LoadXmlEntry(x) else
  inherited;
end;

function TwpReplaceIf.Render(Data: WideString): WideString;
begin
  if FRegExp.Test(Data) then
    if Assigned(FDo) then
      Result:=RenderAll(FDo,FRegExp.Replace(Data,FReplaceWith))
    else
      Result:=FRegExp.Replace(Data,FReplaceWith)
  else
    if Assigned(FElse) then
      Result:=RenderAll(FElse,Data)
    else
      Result:=Data;
end;

{ TwpSubMatch }

constructor TwpSubMatch.Create(Owner: TWikiParser; Parent: TWikiParseEntry);
begin
  inherited;
  FNumber:=-1;
  FRepeatNumber:=-1;
  FDoRepeat:=false;
end;

procedure TwpSubMatch.LoadXmlElement(x: IXMLDOMNode);
begin
  if (x.baseName='number') or (x.baseName='id') or (x.baseName='index') then
    FNumber:=StrToInt(x.text)-1 else
  if x.baseName='repeat' then
   begin
    FRepeatNumber:=StrToInt(x.text)-1;
    FDoRepeat:=true;
   end
  else
  inherited;
end;

function TwpSubMatch.Render(Data: WideString): WideString;
var
  pe:TWikiParseEntry;
  m:Match;
  sm:SubMatches;
  x,y:WideString;
  i:integer;
begin
  //find match
  pe:=FParent;
  while Assigned(pe) and not(pe is TWikiParseEntryRE) do pe:=pe.FParent;
  if not(Assigned(pe)) then
    raise Exception.Create('[WikiParse]<submatch>No parent RegEx operation found');
  m:=(pe as TWikiParseEntryRE).FCurrentMatch;
  if not(Assigned(m)) then
    raise Exception.Create('[WikiParse]<submatch>Parent RegEx operation is not processing a match');

  //get submatch, or all of no number specified
  sm:=(m.SubMatches as SubMatches);
  if FNumber=-1 then
   begin
     y:='';
     for i:=1 to sm.Count do y:=y+sm.Item[i];
   end
  else
   begin
    try
      y:=sm.Item[FNumber];
    except
      on e:Exception do
        raise Exception.Create('[WikiParse]<submatch>Unable to retrieve submatch '+IntToStr(FNumber)+': '+e.Message);
    end;
   end;

  //do repeat if specified
  if FDoRepeat then
   begin
    try
      x:=sm.Item[FRepeatNumber];
    except
      on e:Exception do
        raise Exception.Create('[WikiParse]<submatch>Unable to retrieve submatch '+IntToStr(FRepeatNumber)+': '+e.Message);
    end;
    Result:='';
    for i:=1 to Length(x) do Result:=Result+y;
   end
  else
   begin
    Result:=y;
   end;

  m:=nil;
  sm:=nil;
end;

{ TwpGroup }

constructor TwpGroup.Create(Owner: TWikiParser; Parent: TWikiParseEntry);
begin
  inherited;
  FGroupFirst:=nil;
end;

destructor TwpGroup.Destroy;
begin
  FreeAndNil(FGroupFirst);
  inherited;
end;

procedure TwpGroup.LoadFromXML(x: IXMLDOMNode);
begin
  //inherited;
  //deviating, LoadXmlElement doesn't make sense here
  FGroupFirst:=LoadXmlEntry(x);
end;

function TwpGroup.Render(Data: WideString): WideString;
begin
  Result:=RenderAll(FGroupFirst,Data);
end;

{ TwpJump }

constructor TwpJump.Create(Owner: TWikiParser; Parent: TWikiParseEntry);
begin
  inherited;
  FTarget:=nil;
end;

destructor TwpJump.Destroy;
begin
  //!!! Target's get destroyed by owning TWikiParser!!
  //FreeAndNil(FTarget);
  inherited;
end;

procedure TwpJump.LoadFromXML(x: IXMLDOMNode);
var
  id:WideString;
  y:IXMLDOMNode;
begin
  //inherited;
  //deviate, take text as Target id
  id:=x.text;
  //look if created already
  FTarget:=FOwner.GetNamedEntry(id);
  if not(Assigned(FTarget)) then
   begin
    //nope create it!
    y:=x.ownerDocument.documentElement.selectSingleNode('*[@id="'+id+'"]');
    if Assigned(y) then FTarget:=FOwner.LoadEntry(Self,y,id);
   end;
  if not(Assigned(FTarget)) then
    raise Exception.Create('[WikiParseXML]<jump>Target "'+id+'" not found');
end;

function TwpJump.Render(Data: WideString): WideString;
begin
  if Assigned(FTarget) then Result:=FTarget.Render(Data) else Result:=Data;
end;

{ TwpHTMLEncode }

function TwpHTMLEncode.Render(Data: WideString): WideString;
begin
  Result:=HTMLEncode(Data);
end;

{ TwpURLEncode }

function TwpURLEncode.Render(Data: WideString): WideString;
begin
  Result:=URLEncode(Data);
end;

{ TwpWiki }

constructor TwpWiki.Create(Owner: TWikiParser; Parent: TWikiParseEntry);
begin
  inherited;
  FReplaceWith:='';
  FFound:=nil;
  FMissing:=nil;
  FDoUpdate:=false;
  FDoUpdPre:=false;
  FDoUpdSuf:=false;
  FUpdPre:='';
  FUpdSuf:='';
  FUpdDo:=nil;
end;

destructor TwpWiki.Destroy;
begin
  FreeAndNil(FFound);
  FreeAndNil(FMissing);
  FreeAndNil(FUpdDo);
  inherited;
end;

procedure TwpWiki.LoadXmlElement(x: IXMLDOMNode);
begin
  if x.baseName='with' then FReplaceWith:=x.text else
  if x.baseName='found' then FFound:=LoadXmlEntry(x) else
  if x.baseName='missing' then FMissing:=LoadXmlEntry(x) else
  if x.baseName='update' then FDoUpdate:=XmlToBool(x) else
  if x.baseName='updateprefix' then
   begin
    FDoUpdPre:=true;
    FUpdPre:=x.text;
   end
  else
  if x.baseName='updatesuffix' then
   begin
    FDoUpdSuf:=true;
    FUpdSuf:=x.text;
   end
  else
  if x.baseName='updatedo' then FUpdDo:=LoadXmlEntry(x) else
  inherited;
end;

function TwpWiki.Render(Data: WideString): WideString;
var
  w:WideString;
  r:boolean;
begin
  if FRegExpPatternSet then w:=FRegExp.Replace(Data,FReplaceWith) else w:=Data;
  r:=FOwner.WikiCheck(w);
  //update only when found?
  if FDoUpdate then
   begin
    if FDoUpdPre or FDoUpdSuf then
     begin
      if FDoUpdPre then Data:=w+FUpdPre+Data;
      if FDoUpdSuf then Data:=Data+FUpdSuf+w;
     end
    else
      Data:=w;
    Data:=RenderAll(FUpdDo,Data);  
   end;
  if r then
   begin
    Result:=RenderAll(FFound,Data)
   end
  else
    Result:=RenderAll(FMissing,Data)
end;

{ TwpExtract }

constructor TwpExtract.Create(Owner: TWikiParser; Parent: TWikiParseEntry);
begin
  inherited;
  FMatch:=nil;
  FInbetween:=nil;
  FREOpen:=CoRegExp.Create;
  FREOpen.Global:=true;
  FREClose:=CoRegExp.Create;
  FREClose.Global:=true;
  //attention: patterns set by properties
  //defaults
  Prefix:='%%';
  Suffix:='#';
  FRequired:=false;
end;

destructor TwpExtract.Destroy;
begin
  FreeAndNil(FMatch);
  FreeAndNil(FInbetween);
  inherited;
end;

procedure TwpExtract.LoadXmlElement(x: IXMLDOMNode);
begin
  if x.baseName='match' then FMatch:=LoadXMLEntry(x) else
  if x.baseName='inbetween' then FInbetween:=LoadXMLEntry(x) else
  if x.baseName='prefix' then Prefix:=x.text else
  if x.baseName='suffix' then Suffix:=x.text else
  if x.baseName='required' then FRequired:=XmlToBool(x) else
  inherited;
end;

function TwpExtract.Marker(id: integer): WideString;
begin
  Result:=Prefix+IntToStr(id)+Suffix;
end;

function TwpExtract.Render(Data: WideString): WideString;
var
  ml,ml2:MatchCollection;
  m,m2,pm:Match;
  i,j:integer;
  p:integer;
  x,y,m0:WideString;
begin
  //prepare?
  x:=Data;
  m0:=Marker(0);

  //extract, keep match list
  ml:=FRegExp.Execute(x) as MatchCollection;
  if ml.Count=0 then
   begin
    if FRequired then y:=x else y:=RenderAll(FInbetween,x);
   end
  else
   begin
    y:='';
    p:=1;

    pm:=FCurrentMatch;
    for i:=0 to ml.Count-1 do
     begin
      m:=ml.Item[i] as Match;
      FCurrentMatch:=m;

      //preceding bit, securing any markers
      y:=y+FREOpen.Replace(Copy(x,p,m.FirstIndex-p+1),m0);
      //match
      y:=y+Marker(i+1);

      p:=m.FirstIndex+m.Length+1;
     end;
    FCurrentMatch:=pm;
    pm:=nil;
    m:=nil;
    //last bit
    y:=y+FREOpen.Replace(Copy(x,p,Length(x)-p+1),m0);

    //perform action
    x:=RenderAll(FInbetween,y);

    //re-word with extracted matches
    y:='';
    p:=1;
    ml2:=FREClose.Execute(x) as MatchCollection;
    pm:=FCurrentMatch;
    for i:=0 to ml2.Count-1 do
     begin
      m2:=ml2.Item[i] as Match;

      //preceding bit
      y:=y+Copy(x,p,m2.FirstIndex-p+1);
      //match
      j:=StrToInt((m2.SubMatches as SubMatches).Item[0]);
      if j=0 then y:=y+Prefix else
        if j>ml.Count then
         begin
          //assert false
          //y:=y+m2.Value;
          raise Exception.Create('[WikiParse]<extract>Incorrect extraction marker found, check prefix/suffix "'+m0+'"');
         end
        else
        if Assigned(FMatch) then
         begin
          FCurrentMatch:=ml.Item[j-1] as Match;
          y:=y+RenderAll(FMatch,FCurrentMatch.Value)
         end
        else
          y:=y+(ml.Item[j-1] as Match).Value;

      p:=m2.FirstIndex+m2.Length+1;
     end;
    FCurrentMatch:=pm;
    pm:=nil;
    y:=y+Copy(x,p,Length(x)-p+1);

    m2:=nil;
    ml2:=nil;
   end;
  ml:=nil;
  Result:=y;
end;

procedure TwpExtract.SetPrefix(const Value: WideString);
begin
  FPrefix:=Value;
  //encode regex-sensitive chars?
  FREOpen.Pattern:=FPrefix;
  FREClose.Pattern:=FPrefix+'([0-9]+?)'+FSuffix;
end;

procedure TwpExtract.SetSuffix(const Value: WideString);
begin
  FSuffix:=Value;
  //encode regex-sensitive chars?
  FREClose.Pattern:=FPrefix+'([0-9]+?)'+FSuffix;
end;

{ TwpConcat }

constructor TwpConcat.Create(Owner: TWikiParser; Parent: TWikiParseEntry);
begin
  inherited;
  FConcatFirst:=nil;
end;

destructor TwpConcat.Destroy;
begin
  FreeAndNil(FConcatFirst);
  inherited;
end;

procedure TwpConcat.LoadFromXML(x: IXMLDOMNode);
begin
  //inherited;
  //deviating, LoadXmlElement doesn't make sense here
  FConcatFirst:=LoadXmlEntry(x);
end;

function TwpConcat.Render(Data: WideString): WideString;
var
  pe:TWikiParseEntry;
begin
  //Result:=RenderAll(FGroupFirst,Data);

  //changed a little from RenderAll!
  Result:='';
  pe:=FConcatFirst;
  while Assigned(pe) do
   begin
    Result:=Result+pe.Render(Data);
    pe:=pe.Next;
   end;
end;

{ TwpCheck }

constructor TwpCheck.Create(Owner: TWikiParser; Parent: TWikiParseEntry);
begin
  inherited;
  FValueSet:=false;
  FValue:='';
  FDo:=nil;
  FElse:=nil;
end;

destructor TwpCheck.Destroy;
begin
  FreeAndNil(FDo);
  FreeAndNil(FElse);
  inherited;
end;

procedure TwpCheck.LoadXmlElement(x: IXMLDOMNode);
begin
  if x.baseName='value' then
   begin
    FValue:=x.text;
    FValueSet:=true;
   end
  else
  if x.baseName='do' then FDo:=LoadXmlEntry(x) else
  if x.baseName='else' then FElse:=LoadXmlEntry(x) else
  inherited;
end;

function TwpCheck.Render(Data: WideString): WideString;
var
  ChecksOut:boolean;
begin
  if FValueSet then ChecksOut:=Data=FValue
    else if FRegExpPatternSet then ChecksOut:=FRegExp.Test(Data) else
      ChecksOut:=not(Length(Data)=0);//default
  if ChecksOut then
    if Assigned(FDo) then Result:=RenderAll(FDo,Data) else Result:=Data
  else
    if Assigned(FElse) then Result:=RenderAll(FElse,Data) else Result:=Data;
end;

{ TwpText }

function TwpText.Render(Data: WideString): WideString;
begin
  Result:=FSimpleText;
end;

{ TwpUpperCase }

function TwpUpperCase.Render(Data: WideString): WideString;
begin
  Result:=WideUpperCase(Data)
end;

{ TwpLowerCase }

function TwpLowerCase.Render(Data: WideString): WideString;
begin
  Result:=WideLowerCase(Data);
end;

{ TWikiParseEntrySimpleText }

constructor TWikiParseEntrySimpleText.Create(Owner: TWikiParser;
  Parent: TWikiParseEntry);
begin
  inherited;
  FSimpleText:='';
end;

procedure TWikiParseEntrySimpleText.LoadFromXML(x: IXMLDOMNode);
begin
  //inherited;
  //deviating, just taking entire text!
  FSimpleText:=x.text;
end;

{ TwpPrepend }

function TwpPrepend.Render(Data: WideString): WideString;
begin
  Result:=FSimpleText+Data;
end;

{ TwpAppend }

function TwpAppend.Render(Data: WideString): WideString;
begin
  Result:=Data+FSimpleText;
end;

{ TwpDebugBreak }

constructor TwpDebugBreak.Create(Owner: TWikiParser;
  Parent: TWikiParseEntry);
begin
  inherited;
  FSkipCount:=0;
  FDo:=nil;
end;

destructor TwpDebugBreak.Destroy;
begin
  FreeAndNil(FDo);
  inherited;
end;

procedure TwpDebugBreak.LoadXmlElement(x: IXMLDOMNode);
begin
  if x.baseName='skip' then FSkipCount:=StrToInt(x.text) else
  if x.baseName='do' then FDo:=LoadXmlEntry(x) else
  inherited;
end;

function TwpDebugBreak.Render(Data: WideString): WideString;
begin
  if FSkipCount=0 then
    raise EWikiParserDebugBreak.Create(RenderAll(FDo,Data))
  else
   begin
    Result:=Data;
    Dec(FSkipCount);
   end;
end;

{ EWikiParserDebugBreak }

constructor EWikiParserDebugBreak.Create(Data: WideString);
begin
  inherited Create('DebugBreak');
  FValueSoFar:=Data;
end;

{ TwpNoOp }

function TwpNoOp.Render(Data: WideString): WideString;
begin
  //don't do anything
  Result:=Data;
end;

{ TwpInclude }

constructor TwpInclude.Create(Owner: TWikiParser; Parent: TWikiParseEntry);
begin
  inherited;
  FRelativeURL:='';
  FResolvedURL:='';
  FMainEntry:=nil;
end;

destructor TwpInclude.Destroy;
begin
  FreeAndNil(FMainEntry);
  inherited;
end;

procedure TwpInclude.LoadFromXML(x: IXMLDOMNode);
var
  c:cardinal;
  pdoc:DOMDocument;
begin
  inherited;
  FRelativeURL:=x.text;
  c:=1024;
  SetLength(FResolvedURL,c);
  if not(InternetCombineUrlW(
    PWideChar(x.ownerDocument.url),
    PWideChar(FRelativeURL),
    PWideChar(FResolvedURL),c,
    //ICU_DECODE or ?
    ICU_NO_ENCODE
    )) then raise Exception.Create(
      '[WikiEngine]<include>Error combining "'+FRelativeURL+'" and "'+x.ownerDocument.url+'"');
  SetLength(FResolvedURL,c);

  pdoc:=CoDOMDocument.Create;
  pdoc.async:=false;
  pdoc.preserveWhiteSpace:=true;
  //pdoc.validateOnParse:=false;
  //pdoc.resolveExternals:=false;

  if not(pdoc.load(FResolvedURL)) then
    raise Exception.Create('[WikiEngine.WikiParseXML]'+FResolvedURL+#13#10+
      pdoc.parseError.reason);

  FMainEntry:=FOwner.LoadEntry(nil,XmlFirstElement(pdoc.documentElement));

  pdoc:=nil;
end;

function TwpInclude.Render(Data: WideString): WideString;
begin
  if Assigned(FMainEntry) then
    Result:=FMainEntry.Render(Data)
  else
    Result:=Data;
end;

{ TwpLength }

function TwpLength.Render(Data: WideString): WideString;
begin
  Result:=IntToStr(Length(Data));
end;

{ TwpProcess }

constructor TwpProcess.Create(Owner: TWikiParser; Parent: TWikiParseEntry);
begin
  inherited;
  FDo:=nil;
  FElse:=nil;
end;

destructor TwpProcess.Destroy;
begin
  FreeAndNil(FDo);
  FreeAndNil(FElse);
  inherited;
end;

procedure TwpProcess.LoadXmlElement(x: IXMLDOMNode);
begin
  if x.baseName='do' then FDo:=LoadXmlEntry(x) else
  if x.baseName='else' then FElse:=LoadXmlEntry(x) else
  inherited;
end;

function TwpProcess.Render(Data: WideString): WideString;
var
  ml:MatchCollection;
  pm:Match;
  i:integer;
begin
  ml:=FRegExp.Execute(Data) as MatchCollection;
  if ml.Count=0 then
    if Assigned(FElse) then Result:=RenderAll(FElse,Data) else Result:=Data
  else
    if Assigned(FDo) then
     begin
      pm:=FCurrentMatch;
      Result:=Data;
      for i:=0 to ml.Count-1 do
       begin
        FCurrentMatch:=ml.Item[i] as Match;
        Result:=RenderAll(FDo,Result);
       end;
      FCurrentMatch:=pm;
      pm:=nil;
     end
    else Result:=Data;
end;

end.
