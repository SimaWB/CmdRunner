object frmCmdRunner: TfrmCmdRunner
  Left = 0
  Top = 0
  Caption = 'Cmd Runner'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 27
    Align = alTop
    TabOrder = 0
    ExplicitTop = -6
    object BitBtn1: TBitBtn
      Left = 1
      Top = 1
      Width = 75
      Height = 25
      Align = alLeft
      Caption = 'Open'
      TabOrder = 0
      OnClick = BitBtn1Click
      ExplicitLeft = 4
      ExplicitTop = 2
    end
    object BitBtn2: TBitBtn
      Left = 76
      Top = 1
      Width = 75
      Height = 25
      Align = alLeft
      Caption = 'Close'
      TabOrder = 1
      OnClick = BitBtn2Click
      ExplicitLeft = 96
      ExplicitTop = 8
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 27
    Width = 635
    Height = 272
    Align = alClient
    TabOrder = 1
    ExplicitTop = 32
  end
end
