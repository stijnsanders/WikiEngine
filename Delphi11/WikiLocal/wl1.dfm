object frmWikiLocal: TfrmWikiLocal
  Left = 0
  Top = 0
  BorderWidth = 4
  Caption = 'WikiLocal'
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
  object splSideBar: TSplitter
    Left = 185
    Top = 33
    Width = 8
    Height = 402
    OnMoved = splSideBarMoved
  end
  object panNavigation: TPanel
    Left = 0
    Top = 0
    Width = 620
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      620
      33)
    object btnNavPrev: TButton
      Left = 0
      Top = 0
      Width = 29
      Height = 29
      Action = actNavPrev
      TabOrder = 0
    end
    object btnNavNext: TButton
      Left = 35
      Top = 0
      Width = 29
      Height = 29
      Action = actNavNext
      TabOrder = 1
    end
    object cbPageName: TComboBox
      Left = 70
      Top = 0
      Width = 388
      Height = 29
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 32
      TabOrder = 2
      OnClick = cbPageNameClick
      OnDblClick = cbPageNameDblClick
      OnKeyPress = cbPageNameKeyPress
    end
    object btnGo: TButton
      Left = 464
      Top = 0
      Width = 75
      Height = 29
      Anchors = [akTop, akRight]
      Caption = 'Go'
      TabOrder = 3
      OnClick = btnGoClick
    end
    object btnEdit: TButton
      Left = 545
      Top = 0
      Width = 75
      Height = 29
      Action = actEdit
      Anchors = [akTop, akRight]
      TabOrder = 4
    end
  end
  object panSideBar: TPanel
    Left = 0
    Top = 33
    Width = 185
    Height = 402
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      185
      402)
    object panSearch: TPanel
      Left = 0
      Top = 35
      Width = 185
      Height = 149
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      Visible = False
      DesignSize = (
        185
        149)
      object lblMatchCount: TLabel
        Left = 0
        Top = 121
        Width = 179
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '...'
      end
      object txtSearchText: TEdit
        Left = 0
        Top = 1
        Width = 179
        Height = 29
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnEnter = txtSearchTextEnter
        OnExit = txtSearchTextExit
      end
      object cbRegEx: TCheckBox
        Left = 0
        Top = 36
        Width = 179
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Regular Expression'
        TabOrder = 1
      end
      object cbCaseSensitive: TCheckBox
        Left = 0
        Top = 63
        Width = 179
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Case sensitive'
        TabOrder = 2
      end
      object btnSearch: TButton
        Left = 0
        Top = 90
        Width = 179
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Search'
        TabOrder = 3
        OnClick = btnSearchClick
      end
    end
    object tvSideList: TTreeView
      Left = 23
      Top = 316
      Width = 41
      Height = 41
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      HideSelection = False
      Indent = 19
      ReadOnly = True
      RightClickSelect = True
      TabOrder = 1
      Visible = False
      OnChange = tvSideListChange
      OnContextPopup = tvSideListContextPopup
      OnExpanding = tvSideListExpanding
    end
    object hvSideBar: THtmlViewer
      Left = 23
      Top = 269
      Width = 41
      Height = 41
      BorderStyle = htNone
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
      OnHotSpotClick = hvMainViewHotSpotClick
      OnHotSpotCovered = hvMainViewHotSpotCovered
      OnRightClick = hvRightClick
      TabOrder = 2
      TabStop = True
      OnKeyDown = hvKeyDown
      OnMouseUp = hvMouseUp
      Touch.InteractiveGestures = [igPan]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia]
    end
    object panGroupName: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 35
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 4
      Caption = 'panGroupName'
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      PopupMenu = pmSideBar
      ShowHint = True
      TabOrder = 3
      StyleElements = [seFont]
      OnDblClick = actHomePageExecute
    end
    object btnSideBarClose: TButton
      Left = 150
      Top = 2
      Width = 29
      Height = 29
      Anchors = [akTop, akRight]
      Caption = 'X'
      TabOrder = 4
      Visible = False
      OnClick = btnSideBarCloseClick
    end
  end
  object panMainView: TPanel
    Left = 193
    Top = 33
    Width = 427
    Height = 402
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object splEditPage: TSplitter
      Left = 0
      Top = 172
      Width = 427
      Height = 8
      Cursor = crVSplit
      Align = alTop
      Visible = False
    end
    object panEdit: TPanel
      Left = 0
      Top = 35
      Width = 427
      Height = 137
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      Visible = False
      object txtEdit: TMemo
        Left = 0
        Top = 0
        Width = 223
        Height = 102
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
        WantTabs = True
      end
      object lbMods: TListBox
        Left = 223
        Top = 0
        Width = 204
        Height = 102
        Align = alRight
        ItemHeight = 21
        TabOrder = 1
        Visible = False
      end
      object panEditCmds: TPanel
        Left = 0
        Top = 102
        Width = 427
        Height = 35
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object btnSave: TButton
          Left = 6
          Top = 6
          Width = 75
          Height = 25
          Caption = 'Save'
          TabOrder = 0
          OnClick = btnSaveClick
        end
        object btnReset: TButton
          Left = 87
          Top = 6
          Width = 75
          Height = 25
          Caption = 'Reset'
          TabOrder = 1
          OnClick = btnResetClick
        end
        object btnCancel: TButton
          Left = 168
          Top = 6
          Width = 75
          Height = 25
          Caption = 'Cancel'
          TabOrder = 2
          OnClick = btnCancelClick
        end
      end
    end
    object panPageName: TPanel
      Left = 0
      Top = 0
      Width = 427
      Height = 35
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 4
      Caption = 'panPageName'
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      PopupMenu = pmPage
      ShowHint = True
      TabOrder = 1
      StyleElements = [seFont]
      OnDblClick = actEditExecute
    end
    object hvMainView: THtmlViewer
      Left = 0
      Top = 205
      Width = 427
      Height = 197
      BorderStyle = htNone
      DefBackground = clWindow
      DefFontColor = clWindowText
      DefFontName = 'Segoe UI'
      HistoryMaxCount = 0
      MarginHeight = 4
      MarginWidth = 4
      NoSelect = False
      PrintMarginBottom = 2.000000000000000000
      PrintMarginLeft = 2.000000000000000000
      PrintMarginRight = 2.000000000000000000
      PrintMarginTop = 2.000000000000000000
      PrintScale = 1.000000000000000000
      Text = ''
      OnHotSpotClick = hvMainViewHotSpotClick
      OnHotSpotCovered = hvMainViewHotSpotCovered
      OnRightClick = hvRightClick
      Align = alClient
      TabOrder = 2
      TabStop = True
      OnKeyDown = hvKeyDown
      OnMouseUp = hvMouseUp
      Touch.InteractiveGestures = [igPan]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia]
    end
    object panPageInfo: TPanel
      Left = 0
      Top = 180
      Width = 427
      Height = 25
      Align = alTop
      Alignment = taLeftJustify
      BorderWidth = 2
      Caption = 'panPageInfo'
      Color = clInfoBk
      ParentBackground = False
      PopupMenu = pmRedirect
      TabOrder = 3
      Visible = False
      StyleElements = [seFont]
      OnContextPopup = panPageInfoContextPopup
      OnDblClick = panPageInfoDblClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 435
    Width = 620
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 120
      end
      item
        Width = 50
      end>
  end
  object ApplicationEvents1: TApplicationEvents
    OnActivate = ApplicationEvents1Activate
    OnIdle = ApplicationEvents1Idle
    Left = 392
    Top = 336
  end
  object ActionList1: TActionList
    Left = 392
    Top = 224
    object actNavPrev: TAction
      Caption = '<'
      ShortCut = 32805
      OnExecute = actNavPrevExecute
    end
    object actNavNext: TAction
      Caption = '>'
      ShortCut = 32807
      OnExecute = actNavNextExecute
    end
    object actEdit: TAction
      Caption = 'Edit'
      ShortCut = 113
      OnExecute = actEditExecute
    end
    object actSearch: TAction
      Caption = 'Search...'
      ShortCut = 16454
      OnExecute = actSearchExecute
    end
    object actSearchNext: TAction
      Caption = 'Search Next'
      ShortCut = 114
      OnExecute = actSearchNextExecute
    end
    object actSearchPrev: TAction
      Caption = 'Search Previous'
      ShortCut = 8306
      OnExecute = actSearchPrevExecute
    end
    object actHomePage: TAction
      Caption = 'HomePage'
      ShortCut = 16456
      OnExecute = actHomePageExecute
    end
    object actMainHomePage: TAction
      Caption = 'Main.HomePage'
      ShortCut = 16461
      OnExecute = actMainHomePageExecute
    end
    object actLinks: TAction
      Caption = 'Links...'
      ShortCut = 16460
      OnExecute = actLinksExecute
    end
    object actBackLinks: TAction
      Caption = 'BackLinks...'
      ShortCut = 16450
      OnExecute = actBackLinksExecute
    end
    object actEditSideBar: TAction
      Caption = 'Edit Sidebar'
      ShortCut = 8305
      OnExecute = actEditSideBarExecute
    end
    object actSideBarLinks: TAction
      Caption = 'Links...'
      ShortCut = 24652
      OnExecute = actSideBarLinksExecute
    end
    object actSideBarBackLinks: TAction
      Caption = 'BackLinks...'
      ShortCut = 24642
      OnExecute = actSideBarBackLinksExecute
    end
    object actFocusPageBar: TAction
      Caption = '!'
      ShortCut = 115
      OnExecute = actFocusPageBarExecute
    end
    object actViewHTML: TAction
      Caption = 'View HTML'
      ShortCut = 119
      OnExecute = actViewHTMLExecute
    end
  end
  object MainMenu1: TMainMenu
    Left = 392
    Top = 280
  end
  object pmPage: TPopupMenu
    OnPopup = pmPagePopup
    Left = 520
    Top = 224
    object Edit1: TMenuItem
      Action = actEdit
    end
    object Search1: TMenuItem
      Action = actSearch
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object HomePage1: TMenuItem
      Action = actHomePage
    end
    object MainHomePage1: TMenuItem
      Action = actMainHomePage
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Links1: TMenuItem
      Action = actLinks
    end
    object BackLinks1: TMenuItem
      Action = actBackLinks
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object importPMWiki1: TMenuItem
      Caption = '### import PMWiki ###'
      Visible = False
      OnClick = importPMWiki1Click
    end
    object redolinks1: TMenuItem
      Caption = '### re-do links ###'
      Visible = False
      OnClick = redolinks1Click
    end
  end
  object pmSideBar: TPopupMenu
    Left = 520
    Top = 280
    object EditSidebar1: TMenuItem
      Action = actEditSideBar
    end
    object Search2: TMenuItem
      Action = actSearch
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Links2: TMenuItem
      Action = actSideBarLinks
    end
    object Backlinks2: TMenuItem
      Action = actSideBarBackLinks
    end
  end
  object pmRedirect: TPopupMenu
    AutoHotkeys = maManual
    Left = 520
    Top = 336
  end
  object pmLink: TPopupMenu
    Left = 520
    Top = 392
    object miLinkBack: TMenuItem
      Caption = 'Back'
      ShortCut = 32805
      OnClick = actNavPrevExecute
    end
    object miLinkFollow: TMenuItem
      Caption = 'Follow'
      Default = True
      OnClick = miLinkFollowClick
    end
    object miLinkEdit: TMenuItem
      Caption = 'Edit Page'
      OnClick = miLinkEditClick
    end
    object miLinkCopyHTML: TMenuItem
      Caption = 'Copy selected'
      OnClick = miLinkCopyHTMLClick
    end
    object miLinkCopy: TMenuItem
      Caption = 'Copy Link'
      OnClick = miLinkCopyClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object miLinkLinks: TMenuItem
      Caption = 'Links...'
      OnClick = miLinkLinksClick
    end
    object miLinkBackLinks: TMenuItem
      Caption = 'Backlinks...'
      OnClick = miLinkBackLinksClick
    end
  end
end
