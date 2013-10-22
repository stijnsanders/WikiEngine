var we=new ActiveXObject("WikiEngine.Engine");
var ws=new ActiveXObject("WScript.Shell");
var fso=new ActiveXObject("Scripting.FileSystemObject");

var CurrentPath=fso.GetFolder(fso.GetFile(WScript.ScriptFullName).ParentFolder).Path+"\\";

we.ConnectionString="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+CurrentPath+"DB\\wiki.mdb";
we.WikiParseXML="file://"+CurrentPath+"\\..\\..\\XML\\wikiparse_pmwiki.xml";
we.Author="StijnSanders";
we.SessionInfo="test";
we.Groups=true;

var s=fso.OpenTextFile(CurrentPath+"test.txt").ReadAll();

we.SetPage("Test.SandBox",s);

ws.PopUp(s+"\r\n===("+
    we.WikiParseXMLLoadTime+"ms,"+
    we.LastCallTime+"ms)=\r\n"+we.Render(s,"Main"));


var x=new ActiveXObject("Msxml2.DOMDocument.4.0");
x.schemas=new ActiveXObject("Msxml2.XMLSchemaCache.4.0");
x.schemas.add('http://yoy.be/dev/xsd/wikiparse.xsd',CurrentPath+"wikiparse.xsd");
ws.PopUp(x.load(CurrentPath+"test.xml")+"\r\n"+x.validate().reason);