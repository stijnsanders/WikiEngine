unit WikiLocal_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 19/11/2010 23:39:23 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Data\2010\WikiEngine\Delphi\WikiLocal\WikiLocal.tlb (1)
// LIBID: {FF53E39F-5701-42EE-A9BD-2AED7880F45B}
// LCID: 0
// Helpfile: 
// HelpString: WikiLocal Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\STDOLE2.TLB)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  WikiLocalMajorVersion = 1;
  WikiLocalMinorVersion = 0;

  LIBID_WikiLocal: TGUID = '{FF53E39F-5701-42EE-A9BD-2AED7880F45B}';

  IID_IWikiLocalStore: TGUID = '{8F99FED2-EA00-4A65-9EA0-7E6CD87E6DE0}';
  CLASS_WikiLocalStore: TGUID = '{57EE83A2-495A-4CD8-9D84-620BB67B2695}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IWikiLocalStore = interface;
  IWikiLocalStoreDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  WikiLocalStore = IWikiLocalStore;


// *********************************************************************//
// Interface: IWikiLocalStore
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8F99FED2-EA00-4A65-9EA0-7E6CD87E6DE0}
// *********************************************************************//
  IWikiLocalStore = interface(IDispatch)
    ['{8F99FED2-EA00-4A65-9EA0-7E6CD87E6DE0}']
    function Get_WikiData(const WikiGroup: WideString; const WikiPage: WideString): WideString; safecall;
    procedure Set_WikiData(const WikiGroup: WideString; const WikiPage: WideString; 
                           const Value: WideString); safecall;
    function Get_WikiPageAge: WordBool; safecall;
    function Get_WikiPageFound: WordBool; safecall;
    procedure SplitWikiName(const PageName: WideString; var WikiGroup: WideString; 
                            var WikiPage: WideString); safecall;
    property WikiData[const WikiGroup: WideString; const WikiPage: WideString]: WideString read Get_WikiData write Set_WikiData;
    property WikiPageAge: WordBool read Get_WikiPageAge;
    property WikiPageFound: WordBool read Get_WikiPageFound;
  end;

// *********************************************************************//
// DispIntf:  IWikiLocalStoreDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8F99FED2-EA00-4A65-9EA0-7E6CD87E6DE0}
// *********************************************************************//
  IWikiLocalStoreDisp = dispinterface
    ['{8F99FED2-EA00-4A65-9EA0-7E6CD87E6DE0}']
    property WikiData[const WikiGroup: WideString; const WikiPage: WideString]: WideString dispid 201;
    property WikiPageAge: WordBool readonly dispid 202;
    property WikiPageFound: WordBool readonly dispid 203;
    procedure SplitWikiName(const PageName: WideString; var WikiGroup: WideString; 
                            var WikiPage: WideString); dispid 204;
  end;

// *********************************************************************//
// The Class CoWikiLocalStore provides a Create and CreateRemote method to          
// create instances of the default interface IWikiLocalStore exposed by              
// the CoClass WikiLocalStore. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoWikiLocalStore = class
    class function Create: IWikiLocalStore;
    class function CreateRemote(const MachineName: string): IWikiLocalStore;
  end;

implementation

uses ComObj;

class function CoWikiLocalStore.Create: IWikiLocalStore;
begin
  Result := CreateComObject(CLASS_WikiLocalStore) as IWikiLocalStore;
end;

class function CoWikiLocalStore.CreateRemote(const MachineName: string): IWikiLocalStore;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WikiLocalStore) as IWikiLocalStore;
end;

end.
