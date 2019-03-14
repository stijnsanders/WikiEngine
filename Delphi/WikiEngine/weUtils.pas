unit weUtils;

//$Revision: $

interface

function HTMLEncode(Data:WideString):WideString;
function URLEncode(Data:WideString):WideString;

implementation

uses VBScript_RegExp_55_TLB;

var
  HTML_RE:packed record
    RE1,RE2,RE3,RE4,RE5:RegExp;
  end;

procedure HTML_RE_Init;
begin
  with HTML_RE do
   begin
    RE1:=CoRegExp.Create;
    RE1.Pattern:='&';
    RE1.Global:=true;
    RE2:=CoRegExp.Create;
    RE2.Pattern:='<';
    RE2.Global:=true;
    RE3:=CoRegExp.Create;
    RE3.Pattern:='>';
    RE3.Global:=true;
    RE4:=CoRegExp.Create;
    RE4.Pattern:='"';
    RE4.Global:=true;
    RE5:=CoRegExp.Create;
    RE5.Pattern:='\r\n';
    RE5.Global:=true;
   end;
end;

procedure HTML_RE_Deinit;
begin
  with HTML_RE do
   begin
    RE1:=nil;
    RE2:=nil;
    RE3:=nil;
    RE4:=nil;
    RE5:=nil;
   end;
end;

function HTMLEncode(Data:WideString):WideString;
begin
  with HTML_RE do
   begin
    Result:=
      RE5.Replace(
      RE4.Replace(
      RE3.Replace(
      RE2.Replace(
      RE1.Replace(
       Data,
        '&amp;'),
        '&lt;'),
        '&gt;'),
        '&quot;'),
        '<br />');
   end;
end;

function URLEncode(Data:WideString):WideString;
var
  s:UTF8String;
  i:integer;
const
  hex:array[0..15] of WideChar=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
begin
  //http://www.ietf.org/rfc/rfc2396.txt '-_.!~*''()'
  s:=UTF8Encode(Data);
  Result:='';
  for i:=1 to Length(s) do
    if s[i] in ['0'..'9','A'..'Z','a'..'z','?','&','=','#',':','/',';','-','_','.','!','~','*','''','(',')'] then
      Result:=Result+WideChar(s[i])
    else
      Result:=Result+WideChar('%')+hex[byte(s[i]) shr 4]+hex[byte(s[i]) and $F];
end;

initialization
  HTML_RE_Init;
finalization
  HTML_RE_Deinit;

end.
 