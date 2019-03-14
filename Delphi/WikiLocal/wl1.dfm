object frmWikiLocalMain: TfrmWikiLocalMain
  Left = 316
  Top = 139
  Caption = 'WikiLocal'
  ClientHeight = 441
  ClientWidth = 585
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 180
    Top = 25
    Width = 4
    Height = 397
    OnMoved = Splitter1Moved
    ExplicitHeight = 398
  end
  object panPage: TPanel
    Left = 0
    Top = 0
    Width = 585
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      585
      25)
    object btnGo: TButton
      Left = 504
      Top = 0
      Width = 33
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Go'
      PopupMenu = pmPage
      TabOrder = 1
      OnClick = btnGoClick
    end
    object btnEdit: TButton
      Left = 536
      Top = 0
      Width = 49
      Height = 25
      Action = actEdit
      Anchors = [akTop, akRight]
      PopupMenu = pmPage
      TabOrder = 2
    end
    object cbPage: TComboBox
      Left = 48
      Top = 0
      Width = 457
      Height = 24
      AutoComplete = False
      AutoDropDown = True
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 32
      TabOrder = 0
      OnClick = cbPageClick
      OnDblClick = cbPageDblClick
      OnKeyPress = cbPageKeyPress
    end
    object btnBack: TButton
      Left = 0
      Top = 0
      Width = 25
      Height = 25
      Action = actBack
      PopupMenu = pmPage
      TabOrder = 3
    end
    object btnForward: TButton
      Left = 24
      Top = 0
      Width = 25
      Height = 25
      Action = actForward
      PopupMenu = pmPage
      TabOrder = 4
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 422
    Width = 585
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
  object panSidebar: TPanel
    Left = 0
    Top = 25
    Width = 180
    Height = 397
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      180
      397)
    object panGroupName: TPanel
      Left = 0
      Top = 0
      Width = 180
      Height = 41
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 4
      Caption = 'panGroupName'
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -21
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      PopupMenu = pmSideBar
      ShowHint = True
      TabOrder = 1
      OnDblClick = HomePage1Click
    end
    object btnCloseSideList: TButton
      Left = 148
      Top = 10
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'x'
      TabOrder = 0
      Visible = False
      OnClick = btnCloseSideListClick
    end
    object panSideView: TPanel
      Left = 0
      Top = 41
      Width = 180
      Height = 356
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 2
      DesignSize = (
        180
        356)
      object WebSidebar: TWebBrowser
        Left = 8
        Top = 184
        Width = 41
        Height = 41
        TabOrder = 0
        OnStatusTextChange = WebMainStatusTextChange
        OnBeforeNavigate2 = WebSidebarBeforeNavigate2
        OnNewWindow2 = WebSidebarNewWindow2
        ControlData = {
          4C0000003D0400003D0400000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object panSearch: TPanel
        Left = 1
        Top = 1
        Width = 178
        Height = 127
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        Visible = False
        DesignSize = (
          178
          127)
        object lblMatchCount: TLabel
          Left = 8
          Top = 104
          Width = 165
          Height = 16
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '...'
        end
        object txtSearchText: TEdit
          Left = 8
          Top = 8
          Width = 165
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnEnter = txtSearchTextEnter
          OnExit = txtSearchTextExit
        end
        object cbRegEx: TCheckBox
          Left = 8
          Top = 36
          Width = 165
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = '&Regular Expression'
          TabOrder = 1
        end
        object cbCaseSensitive: TCheckBox
          Left = 8
          Top = 54
          Width = 165
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = '&Case sensitive'
          TabOrder = 2
        end
        object btnSearch: TButton
          Left = 8
          Top = 76
          Width = 165
          Height = 25
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Search'
          TabOrder = 3
          OnClick = btnSearchClick
        end
      end
      object tvSideList: TTreeView
        Left = 8
        Top = 232
        Width = 41
        Height = 45
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        HideSelection = False
        Indent = 19
        PopupMenu = pmLink
        ReadOnly = True
        RightClickSelect = True
        TabOrder = 1
        Visible = False
        OnChange = tvSideListChange
        OnContextPopup = tvSideListContextPopup
        OnExpanding = tvSideListExpanding
      end
    end
  end
  object panMain: TPanel
    Left = 184
    Top = 25
    Width = 401
    Height = 397
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object Splitter2: TSplitter
      Left = 0
      Top = 218
      Width = 401
      Height = 4
      Cursor = crVSplit
      Align = alTop
      Visible = False
    end
    object panEdit: TPanel
      Left = 0
      Top = 41
      Width = 401
      Height = 177
      Align = alTop
      BevelOuter = bvLowered
      TabOrder = 0
      Visible = False
      object lbModifications: TListBox
        Left = 220
        Top = 1
        Width = 180
        Height = 150
        Align = alRight
        BorderStyle = bsNone
        TabOrder = 0
        Visible = False
      end
      object txtEdit: TMemo
        Left = 1
        Top = 1
        Width = 219
        Height = 150
        Align = alClient
        BorderStyle = bsNone
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object panCommands: TPanel
        Left = 1
        Top = 151
        Width = 399
        Height = 25
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object btnSave: TButton
          Left = 0
          Top = 0
          Width = 73
          Height = 25
          Caption = 'Save'
          TabOrder = 0
          OnClick = btnSaveClick
        end
        object btnReset: TButton
          Left = 72
          Top = 0
          Width = 73
          Height = 25
          Caption = 'Reset'
          TabOrder = 1
          OnClick = btnResetClick
        end
        object btnCancel: TButton
          Left = 144
          Top = 0
          Width = 73
          Height = 25
          Caption = 'Cancel'
          TabOrder = 2
          OnClick = btnCancelClick
        end
      end
    end
    object panView: TPanel
      Left = 0
      Top = 222
      Width = 401
      Height = 175
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 1
      object WebMain: TWebBrowser
        Left = 1
        Top = 20
        Width = 399
        Height = 154
        Align = alClient
        TabOrder = 0
        OnStatusTextChange = WebMainStatusTextChange
        OnBeforeNavigate2 = WebMainBeforeNavigate2
        OnNewWindow2 = WebMainNewWindow2
        ExplicitHeight = 155
        ControlData = {
          4C0000003D290000EB0F00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object panPageInfo: TPanel
        Left = 1
        Top = 1
        Width = 399
        Height = 19
        Align = alTop
        Alignment = taLeftJustify
        BorderWidth = 2
        Caption = 'panPageInfo'
        Color = clInfoBk
        PopupMenu = pmRedirect
        TabOrder = 1
        Visible = False
        OnContextPopup = panPageInfoContextPopup
        OnDblClick = panPageInfoDblClick
      end
    end
    object panPageName: TPanel
      Left = 0
      Top = 0
      Width = 401
      Height = 41
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 4
      Caption = 'panPageName'
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -21
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      PopupMenu = pmPage
      ShowHint = True
      TabOrder = 2
      OnDblClick = btnEditClick
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnActivate = ApplicationEvents1Activate
    OnIdle = ApplicationEvents1Idle
    OnMessage = ApplicationEvents1Message
    Left = 384
    Top = 32
  end
  object pmPage: TPopupMenu
    OnPopup = pmPagePopup
    Left = 416
    Top = 32
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
  object pmRedirect: TPopupMenu
    AutoHotkeys = maManual
    Left = 480
    Top = 32
    object RedirectItem1: TMenuItem
      Caption = 'RedirectItem'
      OnClick = RedirectItem1Click
    end
  end
  object pmSideBar: TPopupMenu
    Left = 448
    Top = 32
    object EditSidebar1: TMenuItem
      Action = actEditSidebar
    end
    object Search2: TMenuItem
      Action = actSearch
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Links2: TMenuItem
      Action = actSidebarLinks
    end
    object Backlinks2: TMenuItem
      Action = actSidebarBackLinks
    end
  end
  object ActionList1: TActionList
    Left = 352
    Top = 32
    object actEdit: TAction
      Caption = 'Edit'
      ShortCut = 113
      OnExecute = btnEditClick
    end
    object actSearch: TAction
      Caption = 'Search...'
      ShortCut = 16454
      OnExecute = actSearchClick
    end
    object actHomePage: TAction
      Caption = 'HomePage'
      ShortCut = 16456
      OnExecute = HomePage1Click
    end
    object actMainHomePage: TAction
      Caption = 'Main.HomePage'
      ShortCut = 16461
      OnExecute = MainHomePage1Click
    end
    object actLinks: TAction
      Caption = 'Links...'
      ShortCut = 16460
      OnExecute = actLinksClick
    end
    object actBackLinks: TAction
      Caption = 'BackLinks...'
      ShortCut = 16450
      OnExecute = actBackLinksClick
    end
    object actSidebarLinks: TAction
      Caption = 'Links...'
      ShortCut = 24652
      OnExecute = actSidebarLinksClick
    end
    object actSidebarBackLinks: TAction
      Caption = 'BackLinks...'
      ShortCut = 24642
      OnExecute = actSidebarBackLinksClick
    end
    object actBack: TAction
      Caption = '<'
      ShortCut = 32805
      OnExecute = btnBackClick
    end
    object actForward: TAction
      Caption = '>'
      ShortCut = 32807
      OnExecute = btnForwardClick
    end
    object actEditSidebar: TAction
      Caption = 'Edit Sidebar'
      ShortCut = 8305
      OnExecute = actEditSideBarClick
    end
    object actFocusPageBar: TAction
      Caption = '-'
      ShortCut = 115
      Visible = False
      OnExecute = actFocusPageBarExecute
    end
    object actSave: TAction
      Caption = 'Save'
      ShortCut = 16397
      OnExecute = btnSaveClick
    end
    object fix1: TAction
      Caption = 'fix1'
      ShortCut = 16392
      OnExecute = fix1Execute
    end
    object actCloseSideList: TAction
      Caption = 'actCloseSideList'
      ShortCut = 27
      OnExecute = btnCloseSideListClick
    end
  end
  object pmLink: TPopupMenu
    Left = 512
    Top = 32
    object miLinkBack: TMenuItem
      Caption = 'Back'
      ShortCut = 32805
      OnClick = btnBackClick
    end
    object miLinkFollow: TMenuItem
      Caption = 'Follow'
      Default = True
      OnClick = miLinkFollowClick
    end
    object miLinkEdit: TMenuItem
      Caption = 'Edit'
      OnClick = miLinkEditClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Links3: TMenuItem
      Caption = 'Links...'
      OnClick = Links3Click
    end
    object Backlinks3: TMenuItem
      Caption = 'Backlinks...'
      OnClick = Backlinks3Click
    end
  end
end
