unit we2;

interface

uses System.Classes, System.RegularExpressions;

type
  TWikiPageCheck=function (Sender: TObject; var Name: string;
    const CurrentGroup: string): boolean of object;

  TWikiEngine=class(TObject)
  private
    FCommands,FNamedEntries:TObject;//see TpeComamndsequence below
    FWikiData:string;
    FMods:array of record
      Subject,Value:string;
    end;
    FModsIndex,FModsEnum,FModsSize:integer;
    FPageCheck:TWikiPageCheck;
    FGroups:boolean;
    FGroupDelim,FCurrentGroup:string;
    procedure ClearWikiParse;
  protected
    CurrentMatch:TMatch;
    TableCellOpened:boolean;
    procedure SetModification(const Subject,Value:string);
    function WikiCheck(var PageName: string): boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadWikiParse(const FilePath:string);
    procedure ParseWiki(const Data:string);
    function WikiOutput:string;
    function GetWikiModification(var Subject,Value:string):boolean;

    property PageCheck:TWikiPageCheck read FPageCheck write FPageCheck;
    property Groups:boolean read FGroups write FGroups;
    property GroupDelim:string read FGroupDelim write FGroupDelim;
    property CurrentGroup:string read FCurrentGroup write FCurrentGroup;
  end;

implementation

uses SysUtils;

type
  TParseLineData=record
    Command,Parameter:string;
    SourcePath:string;
    SourceLine:integer;
  end;

  TParseEntry=class(TObject)
  private
    FStackLine:string;
  public
    Next:TParseEntry;
    constructor Create(const StackLine:string);
    procedure Initialize(const Parameter:string); virtual;
    procedure Finalize; virtual;
    function ParseLine(const Info:TParseLineData):TParseEntry; virtual;
    function Perform(Engine:TWikiEngine;const Data:string):string; virtual; abstract;
  end;

  PParseEntry=^TParseEntry;
  TParseEntryClass=class of TParseEntry;

  TpeCommandSequence=class(TParseEntry)
  public
    First,Last:TParseEntry;
    procedure AfterConstruction; override;
    destructor Destroy; override;
    function ParseLine(const Info:TParseLineData):TParseEntry; override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TCheckParseEntry=function(Sender:TParseEntry;Subject:TParseEntry):boolean of object;

  TpeMainSequence=class(TpeCommandSequence)
  public
    procedure Load(const FilePath:string;Check:TCheckParseEntry);
  end;

  TNamedEntries=class(TObject)
  private
    First,Next:TParseEntry;
    function CheckLabel(Sender,Subject:TParseEntry):boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
  end;

  TpeLabel=class(TpeCommandSequence)
  private
    FName:string;
  public
    procedure Initialize(const Parameter:string); override;
    property Name:string read FName;
  end;

  TpeAppend=class(TParseEntry)
  private
    FSuffix:string;
  public
    procedure Initialize(const Parameter:string); override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpePrepend=class(TParseEntry)
  private
    FPrefix:string;
  public
    procedure Initialize(const Parameter:string); override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeHTMLEncode=class(TParseEntry)
  public
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeURLEncode=class(TParseEntry)
  public
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeJump=class(TParseEntry)
  private
    FName:string;
  public
    procedure Initialize(const Parameter:string); override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TParseEntryRegEx=class(TParseEntry)
  protected
    rePattern:string;
    reOptions:TRegExOptions;
    re:TRegEx;
  public
    procedure Initialize(const Parameter:string); override;
    procedure Finalize; override;
    function ParseLine(const Info:TParseLineData):TParseEntry; override;
  end;

  TpeReplace=class(TParseEntryRegEx)
  private
    ReplaceWith:string;
    ReplaceCount:integer;
  public
    procedure AfterConstruction; override;
    function ParseLine(const Info:TParseLineData):TParseEntry; override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeReplaceIf=class(TParseEntryRegEx)
  private
    ReplaceWith:string;
    DoIf,DoElse:TpeCommandSequence;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    function ParseLine(const Info:TParseLineData):TParseEntry; override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeCheck=class(TParseEntryRegEx)
  private
    Value:string;
    ValueSet:boolean;
    DoIf,DoElse:TpeCommandSequence;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    function ParseLine(const Info:TParseLineData):TParseEntry; override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeSplit=class(TParseEntryRegEx)
  private
    Required:boolean;
    Match,Inbetween:TpeCommandSequence;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    function ParseLine(const Info:TParseLineData):TParseEntry; override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeExtract=class(TParseEntryRegEx)
  private
    Prefix,Suffix:string;
    Required:boolean;
    Match,Inbetween:TpeCommandSequence;
    reOpen,reClose:TRegEx;
    function Marker(id: integer): string;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    function ParseLine(const Info:TParseLineData):TParseEntry; override;
    procedure Finalize; override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeSubMatch=class(TParseEntry)
  private
    SubMatchIndex:integer;
  public
    procedure Initialize(const Parameter:string); override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeProcess=class(TParseEntryRegEx)
  private
    DoIf,DoElse:TpeCommandSequence;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    function ParseLine(const Info:TParseLineData):TParseEntry; override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeWikiCommand=class(TParseEntry)
  public
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeWikiCheck=class(TParseEntryRegEx)
  private
    FReplaceWith:WideString;
    FFound,FMissing,FUpdDo:TpeCommandSequence;
    FDoUpdate,FDoUpdPre,FDoUpdSuf:boolean;
    FUpdPre,FUpdSuf:WideString;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    function ParseLine(const Info:TParseLineData):TParseEntry; override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeInclude=class(TpeMainSequence)
  private
    Done:boolean;
    function DenyLabel(Sender,Subject:TParseEntry):boolean;
  public
    procedure Initialize(const Parameter:string); override;
    function ParseLine(const Info:TParseLineData):TParseEntry; override;
    procedure LoadInclude(const FilePath:string);
  end;

  TpeText=class(TParseEntry)
  private
    FText:string;
  public
    procedure Initialize(const Parameter:string); override;
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeDebugBreak=class(TParseEntry)
  public
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeDebugStep=class(TParseEntry)
  public
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeNoOp=class(TParseEntry)
  public
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeUpperCase=class(TParseEntry)
  public
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeLowerCase=class(TParseEntry)
  public
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

  TpeLength=class(TParseEntry)
  public
    function Perform(Engine:TWikiEngine;const Data:string):string; override;
  end;

const
  EntryClassesCount=24;//add new: increase this one!
  EntryClasses:array[0..EntryClassesCount] of packed record
    n:WideString;
    c:TParseEntryClass
  end=(
    (n:'split';      c:TpeSplit),
    (n:'submatch';   c:TpeSubMatch),
    (n:'label';      c:TpeLabel),
    (n:'check';      c:TpeCheck),
//    (n:'concat';     c:TpeConcat),
    (n:'text';       c:TpeText),
    (n:'uppercase';  c:TpeUpperCase),
    (n:'lowercase';  c:TpeLowerCase),
    (n:'length';     c:TpeLength),
    (n:'prepend';    c:TpePrepend),
    (n:'append';     c:TpeAppend),
    (n:'replace';    c:TpeReplace),
    (n:'replaceif';  c:TpeReplaceIf),
    (n:'jump';       c:TpeJump),
    (n:'htmlencode'; c:TpeHTMLEncode),
    (n:'urlencode';  c:TpeURLEncode),
    (n:'wiki';       c:TpeWikiCheck),
    (n:'extract';    c:TpeExtract),
    (n:'break';      c:TpeDebugBreak),
    (n:'debug';      c:TpeDebugStep),
    (n:'noop';       c:TpeNoOp),
    (n:'skip';       c:TpeNoOp),
    (n:'command';    c:TpeWikiCommand),
    (n:'include';    c:TpeInclude),
    (n:'process';    c:TpeProcess),
    //add new here
    (n:''; c:nil)
  );


function sStart(const x:string;l:integer):string; inline;
begin
  Result:=Copy(x,1,l);;
end;

function sEnd(const x:string;l:integer):string; inline;
begin
  Result:=Copy(x,Length(x)-l+1,l);
end;

function sEscaped(const x:string):string;
var
  i,j,l:integer;
begin
  i:=1;
  j:=0;
  l:=Length(x);
  SetLength(Result,l);
  while (i<=l) do
   begin
    if (x[i]='\') and (i<l) then
     begin
      inc(i);
      case x[i] of
        '\':
         begin
          inc(j);
          Result[j]:='\';
         end;
        'r':
         begin
          inc(j);
          Result[j]:=#10;
         end;
        'n':
         begin
          inc(j);
          Result[j]:=#10;
         end;
        'u':
         begin
          if i+4>l then
            raise Exception.Create('Incomplete escape sequence at end of string');
          inc(i);
          inc(j);
          Result[j]:=char(StrToInt('$'+x[i]+x[i+1]+x[i+2]+x[i+3]));
          inc(i,3);
         end;
        'x':
         begin
          if i+2>l then
            raise Exception.Create('Incomplete escape sequence at end of string');
          inc(i);
          inc(j);
          Result[j]:=char(StrToInt('$'+x[i]+x[i+1]));
          inc(i);
         end
        else
          raise Exception.CreateFmt('Unknown escape sequence "%s" (%d)',[x[i],i]);
      end;
     end
    else
     begin
      inc(j);
      Result[j]:=x[i];
     end;
    inc(i);
   end;
  SetLength(Result,j);
end;

procedure ClearMatch(var m:TMatch);
type
  TMatchShim=record
    a,b,c:pointer;
  end;
  PMatchShim=^TMatchShim;
var
  d:PMatchShim;
begin
  d:=pointer(@m);
  d.a:=nil;
  d.b:=nil;
  d.c:=nil;
end;

//don't call TPerformEntry.Perform directly, use this procedure:
function pePerform(pe:TParseEntry;Engine:TWikiEngine;const Data:string):string; inline;
begin
  try
    Result:=pe.Perform(Engine,Data);
  except
    on e:Exception do
     begin
      if pe.FStackLine<>'' then
        e.Message:=e.Message+#13#10+pe.FStackLine;
      raise;
     end;
  end;
end;


{ TWikiEngine }

constructor TWikiEngine.Create;
begin
  inherited Create;
  FWikiData:='';
  FModsIndex:=0;
  FModsEnum:=0;
  FModsSize:=0;
  FCommands:=TpeMainSequence.Create('');
  FNamedEntries:=TNamedEntries.Create;

  FPageCheck:=nil;
  FGroups:=false;//default
  FGroupDelim:='.';//default
  FCurrentGroup:='';//default

  ClearMatch(CurrentMatch);
end;

destructor TWikiEngine.Destroy;
begin
  ClearWikiParse;
  FNamedEntries.Free;
  inherited;
end;

function TWikiEngine.GetWikiModification(var Subject, Value: string): boolean;
begin
  if FModsEnum<FModsIndex then
   begin
    Subject:=FMods[FModsEnum].Subject;
    Value:=FMods[FModsEnum].Value;
    inc(FModsEnum);
    Result:=true;
   end
  else
   begin
    Subject:='';
    Value:='';
    Result:=false;
   end;
end;

procedure TWikiEngine.ClearWikiParse;
var
  ps:TpeCommandSequence;
  pe,px:TParseEntry;
begin
  ps:=FCommands as TpeMainSequence;
  pe:=ps.First;
  ps.First:=nil;
  ps.Last:=nil;
  while pe<>nil do
   begin
    px:=pe;
    pe:=pe.Next;
    px.Free;
   end;
  (FNamedEntries as TNamedEntries).Clear;
end;

procedure TWikiEngine.LoadWikiParse(const FilePath: string);
begin
  ClearWikiParse;
  (FCommands as TpeMainSequence).Load(FilePath,
    (FNamedEntries as TNamedEntries).CheckLabel);
end;

procedure TWikiEngine.ParseWiki(const Data: string);
begin
  ClearMatch(CurrentMatch);
  TableCellOpened:=false;
  FModsIndex:=0;
  FModsEnum:=0;
  FWikiData:=pePerform(FCommands as TpeMainSequence,Self,Data);
end;

procedure TWikiEngine.SetModification(const Subject, Value: string);
begin
  if FModsIndex=FModsSize then
   begin
    inc(FModsSize,8);//growstep
    SetLength(FMods,FModsSize);
   end;
  FMods[FModsIndex].Subject:=Subject;
  FMods[FModsIndex].Value:=Value;
  inc(FModsIndex);
end;

function TWikiEngine.WikiCheck(var PageName: string): boolean;
begin
  if @FPageCheck=nil then
    Result:=true //raise?
  else
    Result:=FPageCheck(Self, PageName, FCurrentGroup);
end;

function TWikiEngine.WikiOutput: string;
begin
  Result:=FWikiData;
end;

{ TParseEntry }

constructor TParseEntry.Create(const StackLine:string);
begin
  inherited Create;
  FStackLine:=StackLine;
  Next:=nil;
end;

procedure TParseEntry.Initialize(const Parameter: string);
begin
  //
end;

procedure TParseEntry.Finalize;
begin
  //
end;

function TParseEntry.ParseLine(const Info:TParseLineData):TParseEntry;
begin
  //inheritants are not supposed to call inherted!!!
  raise Exception.Create('Unexpected '+Self.ClassName+' property "'+Info.Command+'"');
end;

{ TpeCommandSequence }

procedure TpeCommandSequence.AfterConstruction;
begin
  First:=nil;
  Last:=nil;
end;

destructor TpeCommandSequence.Destroy;
var
  pe,px:TParseEntry;
begin
  pe:=First;
  First:=nil;
  Last:=nil;
  while pe<>nil do
   begin
    px:=pe;
    pe:=pe.Next;
    px.Free;
   end;
  inherited;
end;

function TpeCommandSequence.ParseLine(const Info:TParseLineData):TParseEntry;
var
  i:integer;
begin

  i:=0;
  while (i<EntryClassesCount) and (EntryClasses[i].n<>Info.Command) do inc(i);
  if i<EntryClassesCount then
   begin
    Result:=EntryClasses[i].c.Create(
      Info.SourcePath+':'+IntToStr(Info.SourceLine)+':'+Info.Command);
    Result.Initialize(Info.Parameter);
   end
  else
    Result:=inherited;//raise unknown

  if (Result<>nil) and (Info.Command<>'label') then
   begin
    if First=nil then
     begin
      First:=Result;
      Last:=Result;
     end
    else
     begin
      Last.Next:=Result;
      Last:=Result;
     end;
   end;
  //else if Command=label: see LoadWikiParse

end;

function TpeCommandSequence.Perform(Engine:TWikiEngine;const Data:string):string;
var
  pe:TParseEntry;
begin
  Result:=Data;
  pe:=First;
  while pe<>nil do
   begin
    Result:=pePerform(pe,Engine,Result);
    pe:=pe.Next;
   end;
end;

{ TpeMainSequence }

procedure TpeMainSequence.Load(const FilePath:string;Check:TCheckParseEntry);
var
  sl:TStringList;
  sli,ind:integer;
  pwd:string;

  s:string;
  k,l,m:integer;

  cp:TParseEntry;
  ci:integer;
  cd:TParseLineData;
  stack:array of record
    p:TParseEntry;
    i:integer;
  end;
  stackIndex,stackSize:integer;

  pe:TParseEntry;
begin
  pwd:='';
  sl:=TStringList.Create;
  try
    sl.LoadFromFile(FilePath);
    cd.SourcePath:=FilePath;

    s:=ExtractFilePath(FilePath);
    if s<>'' then
     begin
      //change pwd for any include commands
      pwd:=GetCurrentDir;
      SetCurrentDir(s);
     end;

    sli:=0;
    while Trim(sl[sli])='' do inc(sli);
    if not((sli<sl.Count) and (sl[sli]='wikiparse 2')) then
      raise Exception.Create('Invalid wikiparse version');
    inc(sli);

    stackIndex:=0;
    stackSize:=0;

    cp:=Self;
    ci:=0;

    while sli<sl.Count do
     begin

      //advance line
      s:=sStart(Trim(sl[sli]),2);
      if s='/*' then
       begin
        while (sli<sl.Count) and not(sEnd(Trim(sl[sli]),2)='*/') do
          inc(sli);
        inc(sli);
       end
      else
      if (s='//') or ((s<>'') and (AnsiChar(s[1]) in [';','#'])) then
        inc(sli)
      else
      if Trim(sl[sli])='' then
        inc(sli)
      else
       begin
        s:=sl[sli];
        inc(sli);
        cd.SourceLine:=sli;
        cd.Command:='';//see below;

        try
          k:=1;
          l:=Length(s);
          //TODO: expand/enforce tabs?
          //while (k<=l) and (s[k]<=' ') do inc(k);

          while (k<=l) and (s[k]<=' ') do
            if s[k]<>#9 then
              raise Exception.Create('Non tab indentation-character')
            else
              inc(k);

          m:=k;
          while (m<=l) and (s[m]>' ') do inc(m);
          if m>k then
           begin
            ind:=k;
            cd.Command:=Copy(s,k,m-k);//see m>k, so never ''
            cd.Parameter:=Copy(s,m+1,l-m);

            //check indentation level
            while (ind<=ci) do
             begin
              if cp<>nil then cp.Finalize;
              //pop
              if stackIndex=0 then
                raise Exception.Create('Unexpected out of stack');
              dec(stackIndex);
              cp:=stack[stackIndex].p;
              ci:=stack[stackIndex].i;
              {$IFDEF DEBUG}
              stack[stackIndex].p:=nil;
              stack[stackIndex].i:=0;
              {$ENDIF}
             end;

            //parse line
            if cp=nil then
              raise Exception.Create('Unexpected property "'+cd.Command+'"')
            else
              pe:=cp.ParseLine(cd);
            if pe<>nil then
             begin
              //push
              if stackIndex=stackSize then
               begin
                inc(stackSize,$100);//grow step
                SetLength(stack,stackSize);
               end;
              stack[stackIndex].p:=cp;
              stack[stackIndex].i:=ci;
              inc(stackIndex);
              cp:=pe;
              ci:=ind;

              Check(Self,pe);
             end;

           end;
          //else line with only whitespace: ignore

        except
          on e:Exception do
           begin
            e.Message:=e.Message+#13#10+
              cd.SourcePath+':'+IntToStr(cd.SourceLine)+':'+cd.Command;
            raise;
           end;
        end;
       end;

     end;

    while stackIndex<>0 do
     begin
      if cp<>nil then cp.Finalize;
      //pop
      if stackIndex=0 then
        raise Exception.Create('Unexpected out of stack');
      dec(stackIndex);
      cp:=stack[stackIndex].p;
      {$IFDEF DEBUG}
      stack[stackIndex].p:=nil;
      stack[stackIndex].i:=0;
      {$ENDIF}
     end;
    if cp<>nil then cp.Finalize;

  finally
    sl.Free;
    if pwd<>'' then SetCurrentDir(pwd);
  end;
end;

{ TpeLabel }

procedure TpeLabel.Initialize(const Parameter:string);
begin
  inherited;
  FName:=Parameter;
end;

{ TpeJump }

procedure TpeJump.Initialize(const Parameter:string);
begin
  inherited;
  FName:=Parameter;
end;

function TpeJump.Perform(Engine:TWikiEngine;const Data:string):string;
var
  pe:TpeLabel;
begin
  //TODO: find in named entries
  pe:=(Engine.FNamedEntries as TNamedEntries).First as TpeLabel;
  while (pe<>nil) and (pe.Name<>FName) do pe:=pe.Next as TpeLabel;
  if pe=nil then
    raise Exception.Create('Jump: label not found "'+FName+'"')
  else
    Result:=pePerform(pe,Engine,Data);
end;

{ TParseEntryRegEx }

procedure TParseEntryRegEx.Initialize(const Parameter:string);
begin
  inherited;
  rePattern:=Parameter;
  reOptions:=[];//[roNotEmpty];?
end;

procedure TParseEntryRegEx.Finalize;
begin
  inherited;
  re.Create(rePattern,reOptions);
end;

function TParseEntryRegEx.ParseLine(const Info:TParseLineData):TParseEntry;
begin
  Result:=nil;//default
  if Info.Command='ignorecase' then Include(reOptions,roIgnoreCase) else
  if Info.Command='multiline' then Include(reOptions,roMultiLine) else
  if Info.Command='explicitcapture' then Include(reOptions,roExplicitCapture) else
  if Info.Command='compiled' then Include(reOptions,roCompiled) else
  if Info.Command='singleline' then Include(reOptions,roSingleLine) else
  if Info.Command='ignorepatternspace' then Include(reOptions,roIgnorePatternSpace) else
  if Info.Command='notempty' then Include(reoptions,roNotEmpty) else  
  Result:=inherited;
end;

{ TpeSplit }

procedure TpeSplit.AfterConstruction;
begin
  inherited;
  //default
  Required:=false;
  Match:=TpeCommandSequence.Create('');
  Inbetween:=TpeCommandSequence.Create('');
end;

destructor TpeSplit.Destroy;
begin
  FreeAndNil(Match);
  FreeAndNil(Inbetween);
  inherited;
end;

function TpeSplit.ParseLine(const Info:TParseLineData):TParseEntry;
begin
  Result:=nil;//default
  if Info.Command='required' then Required:=true else
  if Info.Command='match' then Result:=Match else
  if Info.Command='inbetween' then Result:=Inbetween else
  Result:=inherited;
end;

function TpeSplit.Perform(Engine:TWikiEngine;const Data:string):string;
var
  mc:TMatchCollection;
  p,i:integer;
  pm:TMatch;
begin
  mc:=re.Matches(Data);
  if mc.Count=0 then
    if Required then
      Result:=Data
    else
      Result:=pePerform(Inbetween,Engine,Data)
  else
   begin
    Result:='';
    p:=1;
    pm:=Engine.CurrentMatch;
    for i:=0 to mc.Count-1 do
     begin
      Engine.CurrentMatch:=mc[i];

      Result:=Result
      //preceding bit
        +pePerform(Inbetween,Engine,Copy(Data,p,Engine.CurrentMatch.Index-p))
      //match
        +pePerform(Match,Engine,Engine.CurrentMatch.Value);

      p:=Engine.CurrentMatch.Index+Engine.CurrentMatch.Length;
     end;
    Engine.CurrentMatch:=pm;
    //last bit
    Result:=Result+pePerform(Inbetween,Engine,Copy(Data,p,Length(Data)-p+1));
   end;
end;

{ TpeExtract }

procedure TpeExtract.AfterConstruction;
begin
  inherited;
  //defaults
  Prefix:='%%';
  Suffix:='#';
  Required:=false;
  Match:=TpeCommandSequence.Create('');
  Inbetween:=TpeCommandSequence.Create('');
end;

destructor TpeExtract.Destroy;
begin
  FreeAndNil(Match);
  FreeAndNil(Inbetween);
  inherited;
end;

function TpeExtract.ParseLine(const Info:TParseLineData):TParseEntry;
begin
  Result:=nil;//default
  if Info.Command='required' then Required:=true else
  if Info.Command='prefix' then Prefix:=sEscaped(Info.Parameter) else
  if Info.Command='suffix' then Suffix:=sEscaped(Info.Parameter) else
  if Info.Command='match' then Result:=Match else
  if Info.Command='inbetween' then Result:=Inbetween else
  Result:=inherited;
end;

procedure TpeExtract.Finalize;
begin
  inherited;
  //encode regex-sensitive chars?
  reOpen.Create(Prefix);
  reClose.Create(Prefix+'([0-9]+?)'+Suffix);
end;

function TpeExtract.Marker(id:integer):string;
begin
  Result:=Prefix+IntToStr(id)+Suffix;
end;

function TpeExtract.Perform(Engine:TWikiEngine;const Data:string):string;
var
  mc,mc2:TMatchCollection;
  m0,x:string;
  p,i,j:integer;
  pm,m:TMatch;
begin
  m0:=Marker(0);
  //extract, keep match list
  mc:=re.Matches(Data);
  if mc.Count=0 then
    if Required then
      Result:=Data
    else
      Result:=pePerform(Inbetween,Engine,Data)
  else
   begin
    x:='';
    p:=1;

    pm:=Engine.CurrentMatch;
    for i:=0 to mc.Count-1 do
     begin
      Engine.CurrentMatch:=mc[i];

      x:=x
      //preceding bit, securing any markers
        +reOpen.Replace(Copy(Data,p,Engine.CurrentMatch.Index-p),m0)
      //match
        +Marker(i+1);

      p:=Engine.CurrentMatch.Index+Engine.CurrentMatch.Length;
     end;
    Engine.CurrentMatch:=pm;
    //last bit
    x:=x+reOpen.Replace(Copy(Data,p,Length(Data)-p+1),m0);

    //perform action
    x:=pePerform(Inbetween,Engine,x);

    //re-word with extracted matches
    Result:='';
    p:=1;
    mc2:=reClose.Matches(x);
    pm:=Engine.CurrentMatch;

    for i:=0 to mc2.Count-1 do
     begin
      m:=mc2[i];
      //preceding bit
      Result:=Result+Copy(x,p,m.Index-p);
      //match
      j:=StrToInt(m.Groups[1].Value);
      if j=0 then Result:=Result+Prefix else
        if j>mc.Count then
         begin
          //assert false
          //Result:=Result+m.Value;
          raise Exception.Create('[WikiParse]<extract>Incorrect extraction marker found, check prefix/suffix "'+IntToStr(j)+'"');
         end
        else
         begin
          Engine.CurrentMatch:=mc[j-1];
          Result:=Result+pePerform(Match,Engine,Engine.CurrentMatch.Value);
         end;
      p:=m.Index+m.Length;
     end;
    Engine.CurrentMatch:=pm;
    Result:=Result+Copy(x,p,Length(x)-p+1);
   end;
end;

{ TpeAppend }

procedure TpeAppend.Initialize(const Parameter:string);
begin
  inherited;
  FSuffix:=sEscaped(Parameter);
end;

function TpeAppend.Perform(Engine:TWikiEngine;const Data:string):string;
begin
  Result:=Data+FSuffix;
end;

{ TpePrepend }

procedure TpePrepend.Initialize(const Parameter:string);
begin
  inherited;
  FPrefix:=sEscaped(Parameter)
end;

function TpePrepend.Perform(Engine:TWikiEngine;const Data:string):string;
begin
  Result:=FPrefix+Data;
end;

{ TpeReplace }

procedure TpeReplace.AfterConstruction;
begin
  inherited;
  //default
  ReplaceWith:='';
  ReplaceCount:=0;
end;

function TpeReplace.ParseLine(const Info:TParseLineData):TParseEntry;
begin
  Result:=nil;
  if Info.Command='with' then ReplaceWith:=sEscaped(Info.Parameter) else
  if Info.Command='count' then
   begin
    if not(TryStrToInt(Info.Parameter,ReplaceCount)) then
      raise Exception.Create('ReplaceCount not numeric');
   end
  else
  Result:=inherited;
end;

function TpeReplace.Perform(Engine:TWikiEngine;const Data:string):string;
begin
  if ReplaceCount=0 then
    Result:=re.Replace(Data,ReplaceWith)
  else
    Result:=re.Replace(Data,ReplaceWith,ReplaceCount);
end;

{ TpeReplaceIf }

procedure TpeReplaceIf.AfterConstruction;
begin
  inherited;
  ReplaceWith:='';//default, see LoadWikiParse
  DoIf:=TpeCommandSequence.Create('');
  DoElse:=TpeCommandSequence.Create('');
end;

destructor TpeReplaceIf.Destroy;
begin
  FreeAndNil(DoIf);
  FreeAndNil(DoElse);
  inherited;
end;

function TpeReplaceIf.ParseLine(const Info:TParseLineData):TParseEntry;
begin
  Result:=nil;//default
  if Info.Command='with' then ReplaceWith:=sEscaped(Info.Parameter) else
  if Info.Command='do' then Result:=DoIf else
  if Info.Command='else' then Result:=DoElse else
  Result:=inherited;
end;

function TpeReplaceIf.Perform(Engine:TWikiEngine;const Data:string):string;
var
  pe:TParseEntry;
begin
  //TODO: use evaluator to count?
  if re.IsMatch(Data) then
   begin
    Result:=re.Replace(Data,ReplaceWith);
    pe:=DoIf;
   end
  else
   begin
    Result:=Data;
    pe:=DoElse;
   end;
  while pe<>nil do
   begin
    Result:=pePerform(pe,Engine,Result);
    pe:=pe.Next;
   end;
end;

{ TpeSubMatch }

procedure TpeSubMatch.Initialize(const Parameter:string);
begin
  inherited;
  if not(TryStrToInt(Parameter,SubMatchIndex)) then
    raise Exception.Create('SubMatch index not numeric');
end;

function TpeSubMatch.Perform(Engine:TWikiEngine;const Data:string):string;
var
  i:integer;
begin
  if SubMatchIndex=-1 then
   begin
    Result:='';
    for i:=1 to Engine.CurrentMatch.Groups.Count-1 do
      Result:=Result+Engine.CurrentMatch.Groups[i].Value;
   end
  else
    if (SubMatchIndex>0) and (SubMatchIndex<Engine.CurrentMatch.Groups.Count) then
      Result:=Engine.CurrentMatch.Groups[SubMatchIndex].Value
    else
      raise Exception.Create('SubMatch: invalid index ('+IntToStr(SubMatchIndex)
        +','+IntToStr(Engine.CurrentMatch.Groups.Count)+')');
end;

{ TpeHTMLEncode }

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
      ,'"','&quot;',[rfReplaceAll])
      ;
end;

function TpeHTMLEncode.Perform(Engine:TWikiEngine;const Data:string):string;
begin
  Result:=HTMLEncode(Data);
end;

{ TpeURLEncode }

const
  Hex: array[0..15] of AnsiChar='0123456789ABCDEF';

function URLEncode(const Data:string):string;
var
  s,t:AnsiString;
  p,q,l:integer;
begin
  s:=UTF8Encode(Data);
  q:=1;
  l:=Length(s)+$80;
  SetLength(t,l);
  for p:=1 to Length(s) do
   begin
    if q+4>l then
     begin
      inc(l,$80);
      SetLength(t,l);
     end;
    case s[p] of
      #0..#31,'"','#','$','%','&','''','+','/',
      '<','>','?','@','[','\',']','^','`','{','|','}',
      #$80..#$FF:
       begin
        t[q]:='%';
        t[q+1]:=Hex[byte(s[p]) shr 4];
        t[q+2]:=Hex[byte(s[p]) and $F];
        inc(q,2);
       end;
      ' ':
        t[q]:='+';
      else
        t[q]:=s[p];
    end;
    inc(q);
   end;
  SetLength(t,q-1);
  Result:=string(t);
end;

function TpeURLEncode.Perform(Engine:TWikiEngine;const Data:string):string;
begin
  Result:=URLEncode(Data);
end;

{ TpeWikiCommand }

type
  TKnownNames=(
    knFail,
    knInclude,
    knNow,
    knComment,

    knTable,
    knTableEnd,
    knCell,
    knCellNr,
    knDiv,
    knDivEnd,

    knMarkup,
    knMarkupEnd,

    knTitle,
    knRedirect,
    //knPageList,
    //knSearchBox
    //knSearchResults,
    //knRedirect,

    //name, group, defaultgroup, nameSpaces, groupSpaced, LastModified, LastModifiedBy, Created, CreatedBy

    //add new here
    kn_Unknown
  );

const
  KnownNames:array[TKnownNames] of string=(
    'fail',
    'include',
    'now',
    'comment',

    'table',
    'tableend',
    'cell',
    'cellnr',
    'div',
    'divend',

    'markup',
    'markupend',

    'title',
    'redirect',

    //add new here
    ''
  );

function TpeWikiCommand.Perform(Engine:TWikiEngine;const Data:string):string;
var
  reCmd:TRegEx;
  mcCmd:TMatchCollection;
  mci,npos:integer;
  cmd,val:string;

  function GetNext:TKnownNames;
  var
    lc:string;
    m:TMatch;
  begin
    if mci=mcCmd.Count then Result:=kn_Unknown else
     begin
      m:=mcCmd[mci];
      npos:=m.Index+m.Length+1;
      cmd:=m.Groups[1].Value;
      if m.Groups.Count>4 then val:=m.Groups[4].Value else val:='';
      Result:=TKnownNames(0);
      lc:=LowerCase(cmd);
      while (Result<kn_Unknown) and not(lc=KnownNames[Result]) do inc(Result);
      inc(mci);
     end;
  end;
  function GetRemainder:WideString;
  begin
    while (npos<=Length(Data)) and
      (AnsiChar(Data[npos]) in [' ',#9]) do inc(npos);
    Result:=Copy(Data,npos,Length(Data)-npos+1);
  end;
  function AllAsAttr:WideString;
  var
    m:TMatch;
  begin
    Result:='';
    while mci<mcCmd.Count do
     begin
      m:=mcCmd[mci];
      cmd:=m.Groups[1].Value;
      if m.Groups.Count>4 then val:=m.Groups[4].Value else val:='';
      if not(LowerCase(Copy(cmd,1,2))='on') then
        Result:=Result+' '+cmd+'="'+HTMLEncode(val)+'" ';
      inc(mci);
     end;
  end;

begin
  Result:='';//default
  reCmd.Create('([a-z]+)(=("([^"]*)"|''([^'']*)''|([^\s]*)))?',[roIgnoreCase]);
  mcCmd:=reCmd.Matches(Data);
  if mcCmd.Count=0 then
    //raise?
  else
   begin
    mci:=0;

    case GetNext of
      knFail:raise Exception.Create('[WikiEngine]<command>Fail requested');

      knNow:Result:=DateTimeToStr(Now);//get format param?
      knComment:Result:='';

      knTable:
       begin
        Result:='<TABLE'+AllAsAttr+'><TBODY><TR>'#13#10;
        Engine.TableCellOpened:=false;
       end;
      knTableEnd:
       begin
        Result:='</TR></TBODY></TABLE>'#13#10;
        if Engine.TableCellOpened then Result:='</TD>'#13#10+Result;
       end;
      knCell:
       begin
        Result:='<TD'+AllAsAttr+'>';
        if Engine.TableCellOpened then Result:='</TD>'#13#10+Result;
        Engine.TableCellOpened:=true;
       end;
      knCellNr:
       begin
        Result:='</TR>'#13#10'<TR><TD'+AllAsAttr+'>';
        if Engine.TableCellOpened then Result:='</TD>'+Result;
        Engine.TableCellOpened:=true;
       end;
      knDiv:Result:='<DIV'+AllAsAttr+'>';
      knDivEnd:Result:='</DIV>'#13#10;

      knMarkup:
        Result:='[[[[';
      knMarkupEnd:
        Result:=']]]]';

      knTitle:
       begin
        Engine.SetModification('title',GetRemainder);
        Result:='';
       end;
      knRedirect:
       begin
        Engine.SetModification('redirect',GetRemainder);
        Result:='';
       end;

      //add new here (remeber to set result!)

      else
       begin
        //raise Exception.Create('[WikiEngine]<command>Unknown command "'+cmd+'"');
        Engine.SetModification(cmd,GetRemainder);
        Result:='';
       end;
    end;

   end;
end;

{ TpeCheck }

procedure TpeCheck.AfterConstruction;
begin
  inherited;
  Value:='';
  ValueSet:=false;
  DoIf:=TpeCommandSequence.Create('');
  DoElse:=TpeCommandSequence.Create('');
end;

destructor TpeCheck.Destroy;
begin
  FreeAndNil(DoIf);
  FreeAndNil(DoElse);
  inherited;
end;

function TpeCheck.ParseLine(const Info:TParseLineData):TParseEntry;
begin
  Result:=nil;//default
  if Info.Command='value' then
   begin
    Value:=sEscaped(Info.Parameter);
    ValueSet:=true;
   end
  else
  if Info.Command='do' then Result:=DoIf else
  if Info.Command='else' then Result:=DoElse else
  Result:=inherited;
end;

function TpeCheck.Perform(Engine:TWikiEngine;const Data:string):string;
var
  ChecksOut:boolean;
begin
  if ValueSet then ChecksOut:=Data=Value
    else if rePattern<>'' then ChecksOut:=re.IsMatch(Data) else
      ChecksOut:=Length(Data)<>0;//default
  if ChecksOut then
    Result:=pePerform(DoIf,Engine,Data)
  else
    Result:=pePerform(DoElse,Engine,Data);
end;

{ TNamedEntries }

constructor TNamedEntries.Create;
begin
  inherited Create;
  First:=nil;
  Next:=nil;
end;

destructor TNamedEntries.Destroy;
begin
  Clear;
  inherited;
end;

procedure TNamedEntries.Clear;
var
  pe:TParseEntry;
begin
  while First<>nil do
   begin
    pe:=First;
    First:=pe.Next;
    pe.Free;
   end;
  First:=nil;
  Next:=nil;
end;

function TNamedEntries.CheckLabel(Sender, Subject: TParseEntry): boolean;
var
  pe:TpeLabel;
begin
  if Subject is TpeLabel then
   begin
    if First=nil then
     begin
      First:=Subject;
      Next:=Subject;
     end
    else
     begin
      //check name
      pe:=First as TpeLabel;
      while pe<>nil do
        if pe.Name=(Subject as TpeLabel).Name then
          raise Exception.Create('Duplicate label name "'+pe.Name+'"')
        else
          pe:=pe.Next as TpeLabel;
      //add to list
      Next.Next:=Subject;
      Next:=Subject;
     end;
    Result:=false;
   end
  else
    Result:=true;
end;

{ TpeInclude }

procedure TpeInclude.Initialize(const Parameter:string);
begin
  inherited;
  Done:=false;
  LoadInclude(Parameter);
end;

function TpeInclude.DenyLabel(Sender, Subject: TParseEntry): boolean;
begin
  if Subject is TpeLabel then
    raise Exception.Create('label inside of include is not supported');
  Result:=true;
end;

procedure TpeInclude.LoadInclude(const FilePath: string);
begin
  try
    Load(FilePath,DenyLabel);
    Done:=true;
  except
    on e:Exception do
     begin
      e.Message:=e.Message+'"'+FilePath+'"';
      raise;
     end;
  end;
end;

function TpeInclude.ParseLine(const Info:TParseLineData):TParseEntry;
begin
  if Done then
    raise Exception.Create('Unexpected '+Self.ClassName+' property "'+Info.Command+'"')
  else
    Result:=inherited;
end;

{ TpeWikiCheck }

procedure TpeWikiCheck.AfterConstruction;
begin
  inherited;
  FReplaceWith:='';
  FFound:=TpeCommandSequence.Create('');
  FMissing:=TpeCommandSequence.Create('');
  FUpdDo:=TpeCommandSequence.Create('');
  FDoUpdate:=false;
  FDoUpdPre:=false;
  FDoUpdSuf:=false;
  FUpdPre:='';
  FUpdSuf:='';
end;

destructor TpeWikiCheck.Destroy;
begin
  FreeAndNil(FFound);
  FreeAndNil(FMissing);
  FreeAndNil(FUpdDo);
  inherited;
end;

function TpeWikiCheck.ParseLine(const Info:TParseLineData):TParseEntry;
begin
  Result:=nil;//default
  if Info.Command='with' then FReplaceWith:=sEscaped(Info.Parameter) else
  if Info.Command='found' then Result:=FFound else
  if Info.Command='missing' then Result:=FMissing else
  if Info.Command='update' then FDoUpdate:=true else
  if Info.Command='updateprefix' then
   begin
    FDoUpdPre:=true;
    FUpdPre:=sEscaped(Info.Parameter);
   end
  else
  if Info.Command='updatesuffix' then
   begin
    FDoUpdSuf:=true;
    FUpdSuf:=sEscaped(Info.Parameter);
   end
  else
  if Info.Command='updatedo' then Result:=FUpdDo else
  Result:=inherited;
end;

function TpeWikiCheck.Perform(Engine:TWikiEngine;const Data:string):string;
var
  w:string;
  r:boolean;
begin
  if rePattern<>'' then w:=re.Replace(Data,FReplaceWith) else w:=Data;
  r:=Engine.WikiCheck(w);
  //update only when found?
  if FDoUpdate then
   begin
    if FDoUpdPre or FDoUpdSuf then
     begin
      if FDoUpdPre then Result:=w+FUpdPre+Data;
      if FDoUpdSuf then Result:=Data+FUpdSuf+w;
     end
    else
      Result:=w;
    Result:=pePerform(FUpdDo,Engine,Result);
   end;
  if r then
    Result:=pePerform(FFound,Engine,Result)
  else
    Result:=pePerform(FMissing,Engine,Result);
end;

{ TpeNoOp }

function TpeNoOp.Perform(Engine:TWikiEngine;const Data:string):string;
begin
  Result:=Data;
end;

{ TpeUpperCase }

function TpeUpperCase.Perform(Engine:TWikiEngine;const Data:string):string;
begin
  Result:=UpperCase(Data);
end;

{ TpeLowerCase }

function TpeLowerCase.Perform(Engine:TWikiEngine;const Data:string):string;
begin
  Result:=LowerCase(Data);
end;

{ TpeLength }

function TpeLength.Perform(Engine:TWikiEngine;const Data:string):string;
begin
  Result:=IntToStr(Length(Data));
end;

{ TpeDebugBreak }

function TpeDebugBreak.Perform(Engine:TWikiEngine;const Data:string):string;
begin
  raise Exception.Create(FStackLine+':"'+Data+'"');
end;

{ TpeDebugStep }

function TpeDebugStep.Perform(Engine:TWikiEngine;const Data:string):string;
begin
  //ValueSoFar:=
  //asm int 3; end;
  Result:=Data;
end;

{ TpeProcess }

procedure TpeProcess.AfterConstruction;
begin
  inherited;
  DoIf:=TpeCommandSequence.Create('');
  DoElse:=TpeCommandSequence.Create('');
end;

destructor TpeProcess.Destroy;
begin
  FreeAndNil(DoIf);
  FreeAndNil(DoElse);
  inherited;
end;

function TpeProcess.ParseLine(const Info:TParseLineData):TParseEntry;
begin
  if Info.Command='do' then Result:=DoIf else
  if Info.Command='else' then Result:=DoElse else
  Result:=inherited;
end;

function TpeProcess.Perform(Engine:TWikiEngine;const Data:string):string;
var
  mc:TMatchCollection;
  i:integer;
begin
  mc:=re.Matches(Data);
  if mc.Count=0 then
    if DoElse=nil then
      Result:=Data
    else
      Result:=pePerform(DoElse,Engine,Data)
  else
    if DoIf=nil then
      Result:=Data
    else
      for i:=0 to mc.Count-1 do
       begin
        //FurrentMatch:=@mc.Item[i];
        Result:=pePerform(DoIf,Engine,Data);
       end;
end;

{ TpeText }

procedure TpeText.Initialize(const Parameter: string);
begin
  inherited;
  //FText:=sEscaped(Parameter);//?
  FText:=Parameter;
end;

function TpeText.Perform(Engine:TWikiEngine;const Data:string):string;
begin
  Result:=FText;
end;

end.
