unit weWikiCommand;

//$Revision: $

interface

uses weWikiParse, VBScript_RegExp_55_TLB;

type
  TwpCommand=class(TWikiParseEntry)
  private
    FRECommand:RegExp;

    FTableCellOpened:boolean;

  protected
    function Render(Data: WideString): WideString; override;
  public
    constructor Create(Owner: TWikiParser; Parent: TWikiParseEntry);
      override;
    destructor Destroy; override;
  end;

implementation

uses SysUtils, weUtils;

{ TwpCommand }

constructor TwpCommand.Create(Owner: TWikiParser; Parent: TWikiParseEntry);
begin
  inherited;
  FRECommand:=CoRegExp.Create;
  FRECommand.Pattern:='([a-z]+)(=("([^"]*)"|''([^'']*)''|([^\s]*)))?';
  FRECommand.Global:=true;
  FRECommand.IgnoreCase:=true;
  FRECommand.Multiline:=false;
  FTableCellOpened:=false;
end;

destructor TwpCommand.Destroy;
begin
  FRECommand:=nil;
  inherited;
end;

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

function TwpCommand.Render(Data: WideString): WideString;
var
  pl:MatchCollection;
  cmd,val:WideString;
  pli,npos:integer;
  kn:TKnownNames;
  function GetNext:boolean;
  var
    lc:string;
    m:Match;
  begin
    if pli=pl.Count then Result:=false else
     begin
      m:=pl.Item[pli] as Match;
      npos:=m.FirstIndex+m.Length+1;
      with (m.SubMatches as SubMatches) do
       begin
        cmd:=Item[0];
        val:=Item[3]+Item[4]+Item[5];

        kn:=TKnownNames(0);
        lc:=LowerCase(cmd);
        while (kn<kn_Unknown) and not(lc=KnownNames[kn]) do inc(kn);

       end;
      inc(pli);
      Result:=true;
     end;
  end;
  function GetRemainder:WideString;
  begin
    while (npos<=Length(Data)) and
      (Data[npos] in [WideChar(' '),WideChar(#9)]) do inc(npos);
    Result:=Copy(Data,npos,Length(Data)-npos+1);
  end;
  function AllAsAttr:WideString;
  begin
    Result:='';
    while GetNext do
     begin
      if not(LowerCase(Copy(cmd,1,2))='on') then
        Result:=Result+' '+cmd+'="'+HTMLEncode(val)+'" ';
     end;
  end;
begin
  //parse command, parameters

  pl:=FRECommand.Execute(Data) as MatchCollection;

  if pl.Count=0 then
   begin
    //raise Exception.Create('[WikiEngine]<command>No command specified');
   end
  else
   begin
    pli:=0;
    GetNext;//get command

    case kn of

      knFail:raise Exception.Create('[WikiEngine]<command>Fail requested');

      knNow:Result:=DateTimeToStr(Now);//get format param?
      knComment:Result:='';

      knTable:
       begin
        Result:='<TABLE'+AllAsAttr+'><TBODY><TR>'#13#10;
        FTableCellOpened:=false;
       end;
      knTableEnd:
       begin
        Result:='</TR></TBODY></TABLE>'#13#10;
        if FTableCellOpened then Result:='</TD>'#13#10+Result;
       end;
      knCell:
       begin
        Result:='<TD'+AllAsAttr+'>';
        if FTableCellOpened then Result:='</TD>'#13#10+Result;
        FTableCellOpened:=true;
       end;
      knCellNr:
       begin
        Result:='</TR>'#13#10'<TR><TD'+AllAsAttr+'>';
        if FTableCellOpened then Result:='</TD>'+Result;
        FTableCellOpened:=true;
       end;
      knDiv:Result:='<DIV'+AllAsAttr+'>';
      knDivEnd:Result:='</DIV>'#13#10;

      knMarkup:
        Result:='[[[[';
      knMarkupEnd:
        Result:=']]]]';

      knTitle:
       begin
        SetModification('title',GetRemainder);
        Result:='';
       end;
      knRedirect:
       begin
        SetModification('redirect',GetRemainder);
        Result:='';
       end;

      //add new here (remeber to set result!)

      else
       begin
        //raise Exception.Create('[WikiEngine]<command>Unknown command "'+cmd+'"');
        SetModification(cmd,GetRemainder);
        Result:='';
       end;
    end;

   end;
end;

end.
