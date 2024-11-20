function rUpdate(n1,n2){
	var r=true;//default
	if(n1.nodeType==Node.ELEMENT_NODE && n1.nodeType==n2.nodeType && n1.nodeName==n2.nodeName && 
		['TABLE','TR','SVG','DIV','P'].indexOf(n1.nodeName)!=-1){
		
		var l1=n1.childNodes,a1=0,b1=l1.length-1;
		var l2=n2.childNodes,a2=0,b2=l2.length-1;
		var d=false;
		while(a1<=b1&&a2<=b2){
			d=!d;
			var r1,r2;
			if(d){
				r1=l1[a1];
				r2=l2[a2];
			}
			else{
				r1=l1[b1];
				r2=l2[b2];
			}
			if(rUpdate(r1,r2))
				if(d){
					a1++;
					a2++;
				}
				else{
					b1--;
					b2--;
				}
			else
			{
				n1.removeChild(r1);
				b1--;
			}
		}
		while(a1<=b1){
			n1.removeChild(l1[a1]);
			b1--;
		}
		while(a2<=b2){
			if(a1<l1.length)
				n1.insertBefore(l2[a2],l1[a1]);
			else
				n1.appendChild(l2[a2]);
			a1++;
			b2--;
		}

		for(a2=0;a2<n2.attributes.length;a2++){
			var r2=n2.attributes[a2];
			if(n1.getAttribute(r2.name)!=r2.value)
			  n1.setAttribute(r2.name,r2.value);
		}
	}
	else
	if(n1.nodeType==Node.ELEMENT_NODE && n1.nodeType==n2.nodeType){
		if(n1.outerHTML!=n2.outerHTML)
			n1.outerHTML=n2.outerHTML;
	}
	else
	if(n1.nodeType==Node.TEXT_NODE && n1.nodeType==n2.nodeType){
		if(n1.nodeValue!=n2.nodeValue)
			n1.nodeValue=n2.nodeValue;
	}
	else
		r=false;
	return r;
}

var r1=document.getElementById("r1");
var r2=document.getElementById("r2");
var mb=document.getElementById("mainbox");
var tb=document.getElementById("titlewiki");
var sb=document.getElementById("sidebar");
var pp="";

var wl=document.location.href.split("/");
var ws=new WebSocket("ws://"+wl[2]+"/"+wl[3]+"/l!");
ws.onmessage=function(msg){
	var p=msg.data;//TODO: substr(1)?
	r1.src="p!"+p+"?"+Date.now();
}
mb.onclick=sb.onclick=function(e){
	var a=(e||window.event).target;
	if(a && a.tagName=="A" && a.className.substr(0,4)=="wiki"){
		wikiGo(a.getAttribute("href"));
		return false;
	}
}
r1.onload=function(){
	//var b=r1.contentDocument.getElementById("box");
	var b=r1.contentDocument.body.firstChild;
	var p=b.getAttribute("wiki");
	history.replaceState({},"",p);
	rUpdate(mb,b);
	ws.send(p);
	tb.textContent=p;
	document.title="WikiLocal - "+p;

	var x=p.split(".");
	if(x[0]!=pp){
		pp=x[0];
		r2.contentWindow.location.replace("p!"+pp+".SideBar?"+Date.now());
	}
};
r2.onload=function(){
	//var b=r2.contentDocument.getElementById("box");
	var b=r2.contentDocument.body.firstChild;
	rUpdate(sb,b);
};
function wikiGo(p){
	r1.src="p!"+p+"?"+Date.now();
	//history.pushState({},"",p);//see onload
}

