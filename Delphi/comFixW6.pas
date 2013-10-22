unit comFixW6;

interface

implementation

uses Windows, SysUtils, ComObj;

var
  SaveInitProc:Pointer=nil;

procedure FixComInitProc;
begin
  try
    if SaveInitProc<>nil then TProcedure(SaveInitProc);
  except
    on e:EOleSysError do if e.ErrorCode<>TYPE_E_REGISTRYACCESS then raise;
  end;
end;

initialization
  SaveInitProc:=InitProc;
  InitProc:=@FixComInitProc;

end.
