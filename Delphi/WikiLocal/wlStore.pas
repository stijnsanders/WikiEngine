unit wlStore;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, WikiLocal_TLB, StdVcl;

type
  TWikiLocalStore = class(TAutoObject, IWikiLocalStore)
  private
    FWikiPageAge:OleVariant;
    FWikiPageFound:boolean;
  protected
    function Get_WikiData(const WikiGroup, WikiPage: WideString): WideString;
      safecall;
    function Get_WikiPageAge: WordBool; safecall;
    procedure Set_WikiData(const WikiGroup, WikiPage, Value: WideString);
      safecall;
    function Get_WikiPageFound: WordBool; safecall;
    procedure SplitWikiName(const PageName: WideString; var WikiGroup,
      WikiPage: WideString); safecall;
  public
    procedure Initialize; override;
  end;

implementation

uses ComServ, Variants, wl1;

procedure TWikiLocalStore.Initialize;
begin
  inherited;
  FWikiPageAge:=Null;
  FWikiPageFound:=false;
  //TODO: prompt 'allow access'?
end;

function TWikiLocalStore.Get_WikiData(const WikiGroup,
  WikiPage: WideString): WideString;
var
  s:string;
  d:TDateTime;
begin
  FWikiPageFound:=frmWikiLocalMain.GetWikiData(WikiGroup,WikiPage,s,d);
  if d=0.0 then FWikiPageAge:=Null else FWikiPageAge:=VarFromDateTime(d);
  Result:=s;
end;

function TWikiLocalStore.Get_WikiPageAge: WordBool;
begin
  Result:=FWikiPageAge;
end;

function TWikiLocalStore.Get_WikiPageFound: WordBool;
begin
  Result:=FWikiPageFound;
end;

procedure TWikiLocalStore.Set_WikiData(const WikiGroup, WikiPage,
  Value: WideString);
begin
  frmWikiLocalMain.SetWikiData(WikiGroup,WikiPage,Value,true);
end;

procedure TWikiLocalStore.SplitWikiName(const PageName: WideString;
  var WikiGroup, WikiPage: WideString);
var
  s1,s2,fn:string;
begin
  s1:=WikiGroup;
  s2:=WikiPage;
  frmWikiLocalMain.SplitWikiName(PageName,ExtWikiData,s1,s2,fn);
  WikiGroup:=s1;
  WikiPage:=s2;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TWikiLocalStore, Class_WikiLocalStore,
    ciMultiInstance, tmApartment);
end.
