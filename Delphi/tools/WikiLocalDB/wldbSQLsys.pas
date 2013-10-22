unit wldbSQLsys;

interface

procedure PerformSQLsys(IncludeSchema:boolean);

implementation

uses wldb1, Classes, WikiLocal_TLB, ADODB_TLB, SysUtils, Variants;

procedure PerformSQLsys(IncludeSchema:boolean);
var
  con:Connection;
  rs1,rs2:Recordset;
  id,ti,si,sj:integer;
  name,colstr,coltypestr,colpkstr:string;
  wls:IWikiLocalStore;
  sl:TStringList;
  anull,achange:boolean;
begin
  wls:=CoWikiLocalStore.Create;
  con:=CoConnection.Create;
  rs1:=CoRecordset.Create;
  rs2:=CoRecordset.Create;
  con.Open('File name=WikiLocalDB.udl','','',0);
  sl:=TStringList.Create;
  try
    ti:=0;
    rs1.Open('select T.object_id, S.name as [schema], T.name from sys.tables T'+
      ' inner join sys.schemas S on S.schema_id=T.schema_id'+
      ' order by 2,3',con,adOpenStatic,adLockReadOnly,adCmdText);
    frmWikiLocalDB.ProgressBar1.Max:=rs1.RecordCount-1;
    while not rs1.EOF do
     begin
      frmWikiLocalDB.ProgressBar1.Position:=ti;
      if (ti mod 10)=0 then frmWikiLocalDB.Update;
      //if (tbl.Type_<>'SYSTEM TABLE') and (tbl.Type_<>'SYSTEM VIEW') then //and (tbl.Type_<>'VIEW') then
       begin
        id:=rs1.Fields['object_id'].Value;
        name:=VarToStr(rs1.Fields['name'].Value);
        if IncludeSchema then name:=VarToStr(rs1.Fields['schema'].Value)+'.'+name;
        sl.Text:=wls.WikiData[frmWikiLocalDB.txtWikiGroup.Text,name];
        if not wls.WikiPageFound then
          sl.Text:=
            frmWikiLocalDB.txtTitlePrefix.Text+
            name+
            frmWikiLocalDB.txtTableSuffix.Text;
        si:=-1;
        rs2.Open('select C.name,T.name as [type],C.is_nullable,I.is_primary_key'+
          ',C.max_length,C.precision,C.scale'+
          ' from sys.columns C inner join sys.types T on T.user_type_id=C.user_type_id'+
          ' left outer join sys.index_columns IX'+
          ' inner join sys.indexes I on I.object_id=IX.object_id and I.index_id=IX.index_id and I.is_primary_key=1'+
          ' on IX.object_id=C.object_id and IX.column_id=C.column_id'+
          ' where C.object_id='+IntToStr(id)+' order by C.column_id',con,adOpenStatic,adLockReadOnly,adCmdText);
        anull:=false;
        achange:=false;
        while not rs2.EOF do
         begin
          coltypestr:=VarToStr(rs2.Fields['type'].Value);
          if (coltypestr='varchar') or (coltypestr='char') or
            (coltypestr='nvarvhar') or (coltypestr='nchar')
            then coltypestr:=coltypestr+'('+VarToStr(rs2.Fields['max_length'].Value)+')';
          if (coltypestr='decimal') or (coltypestr='numeric')
            then coltypestr:=coltypestr+'('+VarToStr(rs2.Fields['precision'].Value)+
              ','+VarToStr(rs2.Fields['scale'].Value)+')';
          if rs2.Fields['is_nullable'].Value then
           begin
            coltypestr:=coltypestr+'*';
            anull:=true;
           end;
          if VarIsNull(rs2.Fields['is_primary_key'].Value) then colpkstr:='' else colpkstr:='PK';
          //TODO: foreign keys
          colstr:=
            StringReplace(
            StringReplace(
            StringReplace(
              frmWikiLocalDB.txtFieldLine.Text,
              '$Name',VarToStr(rs2.Fields['name'].Value),[rfReplaceAll,rfIgnoreCase]),
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
          rs2.MoveNext;
         end;
        rs2.Close;

        if not(wls.WikiPageFound) and anull then sl.Add(frmWikiLocalDB.txtPageFooter.Text);
        if achange then
          wls.WikiData[frmWikiLocalDB.txtWikiGroup.Text,name]:=sl.Text;
       end;
      rs1.MoveNext;
      inc(ti);
     end;
    rs1.Close;
  finally
    sl.Free;
    rs1:=nil;
    rs2:=nil;
    wls:=nil;
  end;
end;

end.
