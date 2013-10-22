object Form1: TForm1
  Left = 184
  Top = 131
  Width = 783
  Height = 540
  Caption = 'WikiEdit'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 0
    Top = 279
    Width = 767
    Height = 4
    Cursor = crVSplit
    Align = alBottom
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 560
    Height = 279
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 0
    WantTabs = True
  end
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 283
    Width = 767
    Height = 200
    Align = alBottom
    TabOrder = 1
    OnStatusTextChange = WebBrowser1StatusTextChange
    OnBeforeNavigate2 = WebBrowser1BeforeNavigate2
    OnNewWindow2 = WebBrowser1NewWindow2
    OnDocumentComplete = WebBrowser1DocumentComplete
    ControlData = {
      4C000000464F0000AC1400000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 483
    Width = 767
    Height = 19
    Panels = <
      item
        Width = 75
      end
      item
        Width = 75
      end
      item
        Width = 75
      end>
  end
  object ListBox1: TListBox
    Left = 560
    Top = 0
    Width = 207
    Height = 279
    Align = alRight
    ItemHeight = 16
    TabOrder = 3
    Visible = False
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 8
    Top = 16
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 16
  end
  object ActionList1: TActionList
    Left = 72
    Top = 16
    object aSelectAll: TAction
      Caption = 'aSelectAll'
      ShortCut = 16449
      OnExecute = aSelectAllExecute
    end
    object aRefresh: TAction
      Caption = 'aRefresh'
      ShortCut = 116
      OnExecute = aRefreshExecute
    end
    object aViewHTML: TAction
      Caption = 'aViewHTML'
      ShortCut = 119
      OnExecute = aViewHTMLExecute
    end
    object aToggleWrap: TAction
      Caption = 'aToggleWrap'
      ShortCut = 16471
      OnExecute = aToggleWrapExecute
    end
    object aCopyAll: TAction
      Caption = 'aCopyAll'
      ShortCut = 24643
      OnExecute = aCopyAllExecute
    end
    object aCutAll: TAction
      Caption = 'aCutAll'
      ShortCut = 24664
      OnExecute = aCutAllExecute
    end
    object aLoad: TAction
      Caption = 'aLoad'
      ShortCut = 16463
      OnExecute = aLoadExecute
    end
    object aSave: TAction
      Caption = 'aSave'
      ShortCut = 16467
      OnExecute = aSaveExecute
    end
    object aParseChange: TAction
      Caption = 'aParseChange'
      ShortCut = 16464
      OnExecute = aParseChangeExecute
    end
  end
  object ParseDialog1: TOpenDialog
    DefaultExt = 'xml'
    FileName = 'wikiparse_pmwiki.xml'
    Filter = 'WikiParseXML|wikiparse_*.xml|All XML files|*.xml|All files|*.*'
    InitialDir = '.'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select WikiParseXML'
    Left = 104
    Top = 16
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text file (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 8
    Top = 48
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text file (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 40
    Top = 48
  end
end
