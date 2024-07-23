object fWikiEdit: TfWikiEdit
  Left = 0
  Top = 0
  BorderWidth = 4
  Caption = 'WikiEdit'
  ClientHeight = 454
  ClientWidth = 620
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  TextHeight = 21
  object Splitter1: TSplitter
    Left = 0
    Top = 137
    Width = 620
    Height = 8
    Cursor = crVSplit
    Align = alTop
  end
  object HtmlViewer1: THtmlViewer
    Left = 0
    Top = 145
    Width = 620
    Height = 309
    BorderStyle = htSingle
    DefBackground = clWindow
    DefFontColor = clWindowText
    DefFontName = 'Segoe UI'
    HistoryMaxCount = 0
    NoSelect = False
    PrintMarginBottom = 2.000000000000000000
    PrintMarginLeft = 2.000000000000000000
    PrintMarginRight = 2.000000000000000000
    PrintMarginTop = 2.000000000000000000
    PrintScale = 1.000000000000000000
    Text = ''
    OnHotSpotClick = HtmlViewer1HotSpotClick
    OnLink = HtmlViewer1Link
    OnRightClick = HtmlViewer1RightClick
    Align = alClient
    TabOrder = 1
    TabStop = True
    Touch.InteractiveGestures = [igPan]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia]
    ExplicitWidth = 616
    ExplicitHeight = 308
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 620
    Height = 137
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 616
    object Memo1: TMemo
      Left = 0
      Top = 0
      Width = 416
      Height = 137
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      WantTabs = True
      ExplicitWidth = 412
    end
    object ListBox1: TListBox
      Left = 416
      Top = 0
      Width = 204
      Height = 137
      Align = alRight
      ItemHeight = 21
      TabOrder = 1
      Visible = False
      ExplicitLeft = 412
    end
  end
  object odWikiRuleSet: TOpenDialog
    DefaultExt = '.wrs'
    Filter = 'WikiEngine Rule Set (*.wrs)|*.wrs|All files (*.*)|*.*'
    InitialDir = '.'
    Title = 'WikiEngine Rule Set'
    Left = 184
    Top = 280
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 80
    Top = 280
  end
  object ActionList1: TActionList
    Left = 80
    Top = 168
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
  object MainMenu1: TMainMenu
    Left = 80
    Top = 224
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text file (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 184
    Top = 168
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text file (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 184
    Top = 224
  end
end
