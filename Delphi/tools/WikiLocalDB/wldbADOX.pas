unit wldbADOX;

interface

procedure PerformADOX;

implementation

uses wldb1, Classes, WikiLocal_TLB, ADODB_TLB, ADOX_TLB, SysUtils;

procedure PerformADOX;
var
  con:Connection15;
  cat:_Catalog;
  ti,ci,fi:integer;
  tbl:_Table;
  col:_Column;
  pk:_Index;
  wls:IWikiLocalStore;
  sl:TStringList;
  colstr,coltypestr,colpkstr:string;
  si,sj:integer;
  anull,achange:boolean;
begin
  wls:=CoWikiLocalStore.Create;
  con:=CoConnection.Create;
  con.Open('File name=WikiLocalDB.udl','','',0);
  cat:=CoCatalog.Create;
  cat._Set_ActiveConnection(con);
  frmWikiLocalDB.ProgressBar1.Max:=cat.Tables.Count-1;
  sl:=TStringList.Create;
  try
    for ti:=0 to cat.Tables.Count-1 do
     begin
      frmWikiLocalDB.ProgressBar1.Position:=ti;
      if (ti mod 10)=0 then frmWikiLocalDB.Update;
      tbl:=cat.Tables.Item[ti];
      if (tbl.Type_<>'SYSTEM TABLE') and (tbl.Type_<>'SYSTEM VIEW') then //and (tbl.Type_<>'VIEW') then
       begin
        sl.Text:=wls.WikiData[frmWikiLocalDB.txtWikiGroup.Text,tbl.Name];
        if not wls.WikiPageFound then
          sl.Text:=
            frmWikiLocalDB.txtTitlePrefix.Text+
            tbl.Name+
            frmWikiLocalDB.txtTableSuffix.Text;
        si:=-1;
        ci:=0;
        while (ci<tbl.Indexes.Count-1) and not(tbl.Indexes.Item[ci].PrimaryKey) do inc(ci);
        if (ci<tbl.Indexes.Count) then pk:=tbl.Indexes.Item[ci] else pk:=nil;
        anull:=false;
        achange:=false;

        for ci:=0 to tbl.Columns.Count-1 do
         begin
          col:=tbl.Columns.Item[ci];
          case col.Type_ of
            adTinyInt:coltypestr:='byte';
            adSmallInt:coltypestr:='smallint';
            adInteger:coltypestr:='int';
            adBigInt:coltypestr:='bigint';
            adUnsignedTinyInt:coltypestr:='ubyte';
            adUnsignedSmallInt:coltypestr:='usmallint';
            adUnsignedInt:coltypestr:='uit';
            adUnsignedBigInt:coltypestr:='ubigint';
            adSingle:coltypestr:='single';
            adDouble:coltypestr:='double';
            adCurrency:coltypestr:='currency';
            adDecimal:coltypestr:='decimal('+IntToStr(col.Precision)+','+IntToStr(col.NumericScale)+')';
            adNumeric:coltypestr:='numeric('+IntToStr(col.Precision)+','+IntToStr(col.NumericScale)+')';
            adBoolean:coltypestr:='bit';
            adVariant:coltypestr:='variant';
            adGUID:coltypestr:='uniqueidentifier';
            adDate:coltypestr:='datetime';
            adDBDate:coltypestr:='date';
            adDBTime:coltypestr:='time';
            adDBTimeStamp:coltypestr:='datetime';
            adChar:coltypestr:='char('+IntToStr(col.DefinedSize)+')';
            adVarChar:coltypestr:='varchar('+IntToStr(col.DefinedSize)+')';
            adLongVarChar:coltypestr:='text';
            adWChar:coltypestr:='nchar('+IntToStr(col.DefinedSize)+')';
            adVarWChar:coltypestr:='nvarchar('+IntToStr(col.DefinedSize)+')';
            adLongVarWChar:coltypestr:='ntext';
            else coltypestr:='???';
          end;
          {
          if col.DefinedSize<>0 then coltypestr:=coltypestr+'('+IntToStr(col.DefinedSize)+')';
          if col.Precision<>0 then coltypestr:=coltypestr+
            '('+IntToStr(col.Precision)+','+IntToStr(col.NumericScale)+')';
          }
          if (col.Attributes and adColNullable)=adColNullable then
           begin
            coltypestr:=coltypestr+'*';
            anull:=true;
           end;
          if pk=nil then colpkstr:='' else
           begin
            fi:=0;
            while (fi<pk.Columns.Count) and (pk.Columns.Item[fi].Name<>col.Name) do inc(fi);
            if (fi<pk.Columns.Count) then colpkstr:='PK' else colpkstr:='';
           end;
          //TODO: foreign keys
          colstr:=
            StringReplace(
            StringReplace(
            StringReplace(
              frmWikiLocalDB.txtFieldLine.Text,
              '$Name',col.Name,[rfReplaceAll,rfIgnoreCase]),
              '$PK',colpkstr,[rfReplaceAll,rfIgnoreCase]),
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

        if not(wls.WikiPageFound) and anull then sl.Add(frmWikiLocalDB.txtPageFooter.Text);
        if achange then
          wls.WikiData[frmWikiLocalDB.txtWikiGroup.Text,tbl.Name]:=sl.Text;
       end;
     end;
  finally
    sl.Free;
    wls:=nil;
  end;
end;

end.
