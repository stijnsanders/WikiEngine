unit xxmp;

interface

uses xxm, we2;

type
  TXxmWikiLocal=class(TXxmProject, IXxmProjectEvents1)
  private
    //FEngine:TWikiEngine;
    function PageCheck(Sender: TObject; var Name: string; const CurrentGroup: string): boolean;
  public
    function LoadPage(Context: IXxmContext; const Address: WideString): IXxmFragment; override;
    function LoadFragment(Context: IXxmContext; const Address, RelativeTo: WideString): IXxmFragment; override;
    procedure UnloadFragment(Fragment: IXxmFragment); override;

    procedure AfterConstruction; override;
    destructor Destroy; override;

    //IXxmProjectEvents1
    function HandleException(Context: IXxmContext; const PageClass,
      ExceptionClass, ExceptionMessage: WideString): boolean;
    procedure ReleasingContexts;
    procedure ReleasingProject;
  end;

function FileNameSafe(const fn:string):string;

function XxmProjectLoad(const AProjectName:WideString): IXxmProject; stdcall;

function WikiProcess(const CurrentGroup,x:string):string;

const
  DefaultWikiGroup='Main';//'Wiki';

var
  WikiDataPath:string;
  HaltAllThreads:boolean;

implementation

uses xxmFReg, SysUtils, Windows, Link;

function FileNameSafe(const fn:string):string;
var
  i:integer;
begin
  Result:=fn;
  for i:=1 to Length(fn) do
    case Result[i] of
      #0..#31,':','\','/','?','*','|','<','>','"','''':Result[i]:='-';
    end;
end;

function XxmProjectLoad(const AProjectName:WideString): IXxmProject;
begin
  Result:=TXxmWikiLocal.Create(AProjectName);
end;

var
  FEngine:TWikiEngine;

function WikiProcess(const CurrentGroup,x:string):string;
begin
  //TODO: FEngineLock
  FEngine.CurrentGroup:=CurrentGroup;
  FEngine.ParseWiki(x);
  //TODO: while FEngine.GetWikiModification
  Result:=FEngine.WikiOutput;
end;

{ TXxmWikiLocal }

procedure TXxmWikiLocal.AfterConstruction;
var
  s:string;
  i:integer;
begin
  inherited;
  SetLength(s,MAX_PATH);
  //SetLength(s,GetModuleFileName(HInstance,PChar(s),MAX_PATH));
  //s:=ExtractFilePath(s);
  i:=GetModuleFileName(HInstance,PChar(s),MAX_PATH);
  while (i<>0) and (s[i]<>'\') do dec(i);
  SetLength(s,i);

  //TODO: from config? other (default) folder than web root?

  WikiDataPath:=s+'WikiLocal\';
  //TODO: ForceDirectories?
  FEngine:=TWikiEngine.Create;
  //TODO: catch/display errors
  FEngine.Groups:=true;
  FEngine.GroupDelim:='.';
  FEngine.PageCheck:=PageCheck;
  FEngine.LoadWikiParse(s+'WikiLocal.wrs');
  
  //TODO: FEngineLock

end;

destructor TXxmWikiLocal.Destroy;
begin
  FEngine.Free;
  inherited;
end;

function TXxmWikiLocal.LoadPage(Context: IXxmContext; const Address: WideString): IXxmFragment;
begin
  inherited;
  //TODO: link session to request
  
  Context.BufferSize:=$10000;
  
  //Result:=XxmFragmentRegistry.GetFragment(Self,Address,'');
  if (Address='wiki.css') or (Address='wiki.js') then
    Result:=nil
  else
  if Copy(Address,1,2)='p!' then
    Result:=XxmFragmentRegistry.GetFragment(Self,'Page.xxm','')
  else
  if Copy(Address,1,2)='l!' then
    //Result:=XxmFragmentRegistry.GetFragment(Self,'Link.xxm','')
    Result:=TWikiLink.Create(Self)
  else
    Result:=XxmFragmentRegistry.GetFragment(Self,'Default.xxm','');  
  
end;

function TXxmWikiLocal.LoadFragment(Context: IXxmContext; const Address, RelativeTo: WideString): IXxmFragment;
begin
  Result:=XxmFragmentRegistry.GetFragment(Self,Address,RelativeTo);
end;

procedure TXxmWikiLocal.UnloadFragment(Fragment: IXxmFragment);
begin
  inherited;
  //TODO: set cache TTL, decrease ref count
  //Fragment.Free;
end;

function TXxmWikiLocal.HandleException(Context: IXxmContext; const PageClass,
  ExceptionClass, ExceptionMessage: WideString): boolean;
begin
  Result:=false;
end;

procedure TXxmWikiLocal.ReleasingContexts;
begin
  HaltAllThreads:=true;
end;

procedure TXxmWikiLocal.ReleasingProject;
begin
  HaltAllThreads:=true;
end;

function TXxmWikiLocal.PageCheck(Sender: TObject; var Name: string; const CurrentGroup: string): boolean;
var
  i:integer;
  fn:string;
begin
  //assert FEngine.GroupDelim='.'//TODO
  i:=1;
  while (i<=Length(Name)) and (Name[i]<>'.') do inc(i);
  if not(i<=Length(Name)) then Name:=CurrentGroup+'.'+Name;

  fn:=FileNameSafe(Name)+'.wx';

  Result:=FileExists(WikiDataPath+fn);

  //TODO: update case as from file name
end;

initialization
  IsMultiThread:=true;
  HaltAllThreads:=false;
end.
