unit Link;

interface

uses xxmWebSocket, Classes;

type
  TWikiChecker=class;//forward

  TWikiLink=class(TXxmWebSocket)
  private
    FChecker:TWikiChecker;
  protected
    procedure ReceiveText(const Data:UTF8String); override;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

  TWikiChecker=class(TThread)
  private
    FLink:TWikiLink;
  public
    Page,Path,Signature:string;
    constructor Create(Owner:TWikiLink);
    procedure Execute; override;
  end;

implementation

uses xxmp, Windows, SysUtils;

function GetFileSignature(const Path: string): string;
var
  fh:THandle;
  fd:TWin32FindData;
begin
  fh:=FindFirstFile(PChar(Path),fd);
  if fh=INVALID_HANDLE_VALUE then Result:='' else
   begin
    //assert(fd.nFileSizeHigh=0
    Result:=
      IntToHex(fd.ftLastWriteTime.dwHighDateTime,8)+
      IntToHex(fd.ftLastWriteTime.dwLowDateTime,8)+'_'+
      IntToStr(fd.nFileSizeLow);
    Windows.FindClose(fh);
   end;
end;

{ TWikiLink }

procedure TWikiLink.AfterConstruction;
begin
  inherited;
  FChecker:=TWikiChecker.Create(Self);
  //FChecker.Page:='';
  //FChecker.Path:='';
  //FChecker.Signature:='';
  //FChecker.OnTerminate:=>Self.Disconnect?
end;

procedure TWikiLink.BeforeDestruction;
begin
  FChecker.Free;
  inherited;
end;

procedure TWikiLink.ReceiveText(const Data:UTF8String);
var
  p,fn:string;
begin
  //inherited

  //TODO: case Data[1] of?

  p:=UTF8ToString(Data);
  fn:=WikiDataPath+FileNameSafe(p)+'.wx';
  FChecker.Page:=p;
  FChecker.Path:=fn;
  FChecker.Signature:=GetFileSignature(fn);
end;

{ TWikiChecker }

constructor TWikiChecker.Create(Owner:TWikiLink);
begin
  inherited Create(false);
  FLink:=Owner;
end;

procedure TWikiChecker.Execute;
var
  s:string;
begin
  while not Terminated do
   begin
    Sleep(250);
    if Path<>'' then
     begin
      s:=GetFileSignature(Path);
      if s<>Signature then
       begin
        FLink.SendText({':'+}UTF8Encode(Page));
        Signature:=s;
       end;
     end;
    if HaltAllThreads then
     begin
      FLink.Disconnect;
      Terminate;
     end;
   end;
end;

end.