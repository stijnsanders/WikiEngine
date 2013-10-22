object frmWikiLocalDB: TfrmWikiLocalDB
  Left = 445
  Top = 140
  BorderStyle = bsDialog
  Caption = 'WikiLocalDB'
  ClientHeight = 465
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    314
    465)
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 69
    Height = 16
    Caption = 'Wiki Group'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 111
    Height = 16
    Caption = 'Table Title Prefix'
  end
  object Label3: TLabel
    Left = 8
    Top = 288
    Width = 197
    Height = 16
    Caption = 'Field Line ($Name,$Type,$PK)'
  end
  object Label4: TLabel
    Left = 8
    Top = 104
    Width = 112
    Height = 16
    Caption = 'Table Title Suffix'
  end
  object Label5: TLabel
    Left = 8
    Top = 240
    Width = 212
    Height = 16
    Caption = 'New Page Footer NULL Message'
  end
  object txtWikiGroup: TEdit
    Left = 8
    Top = 24
    Width = 297
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
  object txtTitlePrefix: TEdit
    Left = 8
    Top = 72
    Width = 297
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object txtFieldLine: TEdit
    Left = 8
    Top = 304
    Width = 297
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
  end
  object btnGo: TButton
    Left = 8
    Top = 408
    Width = 297
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Go'
    Default = True
    TabOrder = 8
    OnClick = btnGoClick
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 440
    Width = 297
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Min = 0
    Max = 100
    TabOrder = 9
  end
  object rgMethod: TRadioGroup
    Left = 8
    Top = 328
    Width = 105
    Height = 73
    Caption = 'Method'
    ItemIndex = 0
    Items.Strings = (
      'ADOX'
      'SQLDMO'
      'SQL sys.*')
    TabOrder = 5
  end
  object txtTableSuffix: TMemo
    Left = 8
    Top = 120
    Width = 297
    Height = 113
    Anchors = [akLeft, akTop, akRight]
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
  end
  object txtPageFooter: TEdit
    Left = 8
    Top = 256
    Width = 297
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object cbCloseWhenDone: TCheckBox
    Left = 120
    Top = 352
    Width = 185
    Height = 17
    Caption = 'Close when done'
    TabOrder = 7
  end
  object cbIncludeSchema: TCheckBox
    Left = 120
    Top = 336
    Width = 185
    Height = 17
    Caption = 'Include schema'
    TabOrder = 6
  end
end
