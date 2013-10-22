unit wldbSQLDMO;

interface

procedure PerformSQLDMO;

implementation

uses wldb1, SysUtils, Classes, Variants, WikiLocal_TLB, SQLDMO_TLB;

procedure PerformSQLDMO;
var
  con:SQLServer2;
  cat:Database2;
  ti,ci:integer;
  tbl:Table2;
  col:Column2;
  wls:IWikiLocalStore;
  sl:TStringList;
  colstr,coltypestr:string;
  si,sj:integer;
  w:WideString;
  anull,achange:boolean;
const
  inpkstr:array[boolean] of string=('','PK');
begin
  wls:=CoWikiLocalStore.Create;
  con:=CoSQLServer2.Create;
  sl:=TStringList.Create;
  try
    with TFileStream.Create('WikiLocalDB.udl',fmOpenRead) do
      try
        //assert UTF16
        Position:=2;
        SetLength(w,(Size div 2)-1);
        Read(w[1],Size-2);
      finally
        Free;
      end;
    sl.Text:=StringReplace(w,';',#13#10,[rfReplaceAll]);
    con.Connect(
      sl.Values['Data Source'],
      sl.Values['User ID'],
      sl.Values['Password']
    );
    cat:=con.Databases.Item(sl.Values['Initial Catalog'],EmptyParam) as Database2;
    frmWikiLocalDB.ProgressBar1.Max:=cat.Tables.Count;
    for ti:=1 to cat.Tables.Count do
     begin
      frmWikiLocalDB.ProgressBar1.Position:=ti;
      if (ti mod 10)=0 then frmWikiLocalDB.Update;
      tbl:=cat.Tables.Item(ti,EmptyParam) as Table2;
      if not(tbl.SystemObject) then
       begin
        anull:=false;
        achange:=false;
        sl.Text:=wls.WikiData[frmWikiLocalDB.txtWikiGroup.Text,tbl.Name];
        if not wls.WikiPageFound then
          sl.Text:=
            frmWikiLocalDB.txtTitlePrefix.Text+
            tbl.Name+
            frmWikiLocalDB.txtTableSuffix.Text;
        si:=-1;
        for ci:=1 to tbl.Columns.Count do
         begin
          col:=tbl.Columns.Item(ci) as Column2;
          coltypestr:=col.Datatype;//col.PhysicalDatatype;
          if (coltypestr='varchar') or (coltypestr='nvarchar') or
             (coltypestr='char') or (coltypestr='nchar') then
            coltypestr:=coltypestr+'('+IntToStr(col.Length)+')';
          if (coltypestr='decimal') or (coltypestr='numeric') then coltypestr:=coltypestr+
            '('+IntToStr(col.NumericPrecision)+','+IntToStr(col.NumericScale)+')';
          if col.AllowNulls then
           begin
            coltypestr:=coltypestr+'*';
            anull:=true;
           end;
          //TODO: foreign keys
          colstr:=
            StringReplace(
            StringReplace(
            StringReplace(
              frmWikiLocalDB.txtFieldLine.Text,
              '$Name',col.Name,[rfReplaceAll,rfIgnoreCase]),
              '$PK',inpkstr[col.InPrimaryKey],[rfReplaceAll,rfIgnoreCase]),
              '$Type',coltypestr,[rfReplaceAll,rfIgnoreCase]);
          sj:=1;
          if not(wls.WikiPageFound) then sj:=sl.Count else
            while (sj<sl.Count) and (CompareText(Copy(sl[sj],1,Length(colstr)),colstr)<>0) do inc(sj);
          if (sj<sl.Count) then
            si:=sj
          else
           begin
            achange:=true;
            if si=-1 then sl.Add(colstr) else
             begin
              inc(si);
              if si>=sl.Count then sl.Add(colstr) else sl.Insert(si,colstr);
             end;
           end;
         end;

        if not(wls.WikiPageFound) and anull then
         begin
          achange:=true;
          sl.Add(frmWikiLocalDB.txtPageFooter.Text);
         end;
        if achange then
          wls.WikiData[frmWikiLocalDB.txtWikiGroup.Text,tbl.Name]:=sl.Text;
       end;
     end;
    //views?
  finally
    sl.Free;
    wls:=nil;
  end;
end;

end.
