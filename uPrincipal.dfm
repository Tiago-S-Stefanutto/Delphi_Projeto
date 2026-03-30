object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'MenuPrincipal'
  ClientHeight = 460
  ClientWidth = 1068
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MenuPrincipal
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object stbPrincipal: TStatusBar
    Left = 0
    Top = 441
    Width = 1068
    Height = 19
    Panels = <
      item
        Width = 150
      end>
  end
  object GridPanel1: TGridPanel
    Left = 0
    Top = 41
    Width = 1068
    Height = 400
    Align = alClient
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = DBChart1
        Row = 0
      end
      item
        Column = 1
        Control = DBChart2
        Row = 0
      end
      item
        Column = 0
        Control = DBChart3
        Row = 1
      end
      item
        Column = 1
        Control = DBChart4
        Row = 1
      end>
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end
      item
        SizeStyle = ssAuto
      end>
    TabOrder = 1
    object DBChart1: TDBChart
      Left = 1
      Top = 1
      Width = 533
      Height = 199
      Title.Text.Strings = (
        'Produto em Estoque')
      Align = alClient
      TabOrder = 0
      DefaultCanvas = 'TGDIPlusCanvas'
      PrintMargins = (
        15
        31
        15
        31)
      ColorPaletteIndex = 13
      object Series1: TBarSeries
        Marks.Brush.Gradient.Colors = <
          item
            Color = clSilver
          end
          item
            Color = 8545393
            Offset = 0.191616766467065900
          end
          item
            Color = 4461420
            Offset = 0.823353293413173600
          end
          item
            Color = clWhite
            Offset = 1.000000000000000000
          end>
        Marks.Brush.Gradient.MidColor = 8545393
        Marks.Brush.Gradient.Visible = True
        Marks.Font.Height = -25
        Marks.Font.Brush.Gradient.EndColor = clGray
        Marks.Font.Brush.Gradient.MidColor = clWhite
        Marks.Font.Brush.Gradient.StartColor = clSilver
        Marks.Font.Brush.Gradient.Visible = True
        Marks.RoundSize = 23
        Marks.Visible = False
        DataSource = dtmGrafico.QryProdutoEstoque
        SeriesColor = clPurple
        Title = 'ProdutoEstoque'
        XLabelsSource = 'Label'
        BarStyle = bsRectGradient
        MultiBar = mbNone
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Bar'
        YValues.Order = loNone
        YValues.ValueSource = 'Value'
      end
    end
    object DBChart2: TDBChart
      Left = 534
      Top = 1
      Width = 533
      Height = 199
      Title.Text.Strings = (
        'Valor de Venda por Cliente na '#218'ltima Semana')
      Legend.TextStyle = ltsLeftPercent
      View3DOptions.Elevation = 315
      View3DOptions.Orthogonal = False
      View3DOptions.Perspective = 0
      View3DOptions.Rotation = 360
      Align = alClient
      TabOrder = 1
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 1
      object Series2: TPieSeries
        Marks.Brush.Gradient.Colors = <
          item
            Color = clRed
          end
          item
            Color = 819443
            Offset = 0.067915690866510540
          end
          item
            Color = clYellow
            Offset = 1.000000000000000000
          end>
        Marks.Brush.Gradient.Direction = gdTopBottom
        Marks.Brush.Gradient.EndColor = clYellow
        Marks.Brush.Gradient.MidColor = 819443
        Marks.Brush.Gradient.StartColor = clRed
        Marks.Brush.Gradient.Visible = True
        Marks.Font.Color = 159
        Marks.Font.Name = 'Tahoma'
        Marks.Font.Style = [fsBold, fsItalic]
        Marks.Frame.Color = 33023
        Marks.RoundSize = 14
        Marks.Visible = False
        Marks.Style = smsLabelPercentTotal
        Marks.Callout.Length = 20
        DataSource = dtmGrafico.QryValorVendaPorCliente
        SeriesColor = 16711808
        Title = 'ValorDeVendaPorCliente'
        XLabelsSource = 'Label'
        XValues.Order = loAscending
        YValues.Name = 'Pie'
        YValues.Order = loNone
        YValues.ValueSource = 'value'
        CustomXRadius = 100
        CustomYRadius = 100
        Frame.InnerBrush.BackColor = clRed
        Frame.InnerBrush.Gradient.EndColor = clGray
        Frame.InnerBrush.Gradient.MidColor = clWhite
        Frame.InnerBrush.Gradient.StartColor = 4210752
        Frame.InnerBrush.Gradient.Visible = True
        Frame.MiddleBrush.BackColor = clYellow
        Frame.MiddleBrush.Gradient.EndColor = 8553090
        Frame.MiddleBrush.Gradient.MidColor = clWhite
        Frame.MiddleBrush.Gradient.StartColor = clGray
        Frame.MiddleBrush.Gradient.Visible = True
        Frame.OuterBrush.BackColor = clGreen
        Frame.OuterBrush.Gradient.EndColor = 4210752
        Frame.OuterBrush.Gradient.MidColor = clWhite
        Frame.OuterBrush.Gradient.StartColor = clSilver
        Frame.OuterBrush.Gradient.Visible = True
        Frame.Width = 4
        UniqueCustomRadius = False
        OtherSlice.Legend.Visible = False
      end
    end
    object DBChart3: TDBChart
      Left = 1
      Top = 200
      Width = 533
      Height = 199
      Title.Text.Strings = (
        'Vendas da '#218'ltima Semana')
      Align = alClient
      TabOrder = 2
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series4: TFastLineSeries
        Marks.Visible = True
        DataSource = dtmGrafico.QryVendasUltimaSeana
        SeriesColor = 8388672
        Title = 'VendasdaUltimaSemana'
        XLabelsSource = 'Label'
        LinePen.Color = 8388672
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
        YValues.ValueSource = 'value'
      end
    end
    object DBChart4: TDBChart
      Left = 534
      Top = 200
      Width = 533
      Height = 199
      Title.Text.Strings = (
        'Os Top 10 Produtos Mais Vendidos')
      Legend.TextStyle = ltsLeftPercent
      View3DOptions.Elevation = 315
      View3DOptions.Orthogonal = False
      View3DOptions.Perspective = 0
      View3DOptions.Rotation = 360
      Align = alClient
      TabOrder = 3
      DefaultCanvas = 'TGDIPlusCanvas'
      ColorPaletteIndex = 13
      object Series3: TPieSeries
        Marks.Visible = False
        DataSource = dtmGrafico.QryProdutosMaisVendidos
        Title = 'OsTop10ProdutosMaisVendidos'
        XLabelsSource = 'Label'
        XValues.Order = loAscending
        YValues.Name = 'Pie'
        YValues.Order = loNone
        YValues.ValueSource = 'value'
        CustomXRadius = 70
        CustomYRadius = 70
        Frame.InnerBrush.BackColor = clRed
        Frame.InnerBrush.Gradient.EndColor = clGray
        Frame.InnerBrush.Gradient.MidColor = clWhite
        Frame.InnerBrush.Gradient.StartColor = 4210752
        Frame.InnerBrush.Gradient.Visible = True
        Frame.MiddleBrush.BackColor = clYellow
        Frame.MiddleBrush.Gradient.EndColor = 8553090
        Frame.MiddleBrush.Gradient.MidColor = clWhite
        Frame.MiddleBrush.Gradient.StartColor = clGray
        Frame.MiddleBrush.Gradient.Visible = True
        Frame.OuterBrush.BackColor = clGreen
        Frame.OuterBrush.Gradient.EndColor = 4210752
        Frame.OuterBrush.Gradient.MidColor = clWhite
        Frame.OuterBrush.Gradient.StartColor = clSilver
        Frame.OuterBrush.Gradient.Visible = True
        Frame.Width = 4
        ExplodeBiggest = 30
        OtherSlice.Legend.Visible = False
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1068
    Height = 41
    Align = alTop
    Alignment = taLeftJustify
    Caption = 'Dashboard'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsItalic, fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = Panel1Click
  end
  object MenuPrincipal: TMainMenu
    Left = 400
    Top = 56
    object C1: TMenuItem
      Caption = 'Cadastro'
      object Cliente1: TMenuItem
        Caption = 'Cliente'
        ShortCut = 16451
        OnClick = Cliente1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Categoria1: TMenuItem
        Caption = 'Categoria'
        OnClick = Categoria1Click
      end
      object Produto1: TMenuItem
        Caption = 'Produto'
        ShortCut = 16464
        OnClick = Produto1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Usurio1: TMenuItem
        Caption = 'Usu'#225'rio'
        OnClick = Usurio1Click
      end
      object UsuriosVsAes1: TMenuItem
        Caption = 'Usu'#225'rios Vs A'#231#245'es'
        OnClick = UsuriosVsAes1Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object AoAcesso1: TMenuItem
        Caption = 'A'#231#227'o Acesso'
        OnClick = AoAcesso1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object AlterarSenha1: TMenuItem
        Caption = 'Alterar Senha'
        OnClick = AlterarSenha1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object MnFechar: TMenuItem
        Caption = 'Fechar'
        OnClick = MnFecharClick
      end
    end
    object Produtos1: TMenuItem
      Caption = 'Movimenta'#231#227'o'
      object Venda1: TMenuItem
        Caption = 'Venda'
        ShortCut = 120
        OnClick = Venda1Click
      end
    end
    object Movimentao1: TMenuItem
      Caption = 'Relat'#243'rios'
      object Categoria: TMenuItem
        Caption = 'Categoria'
        OnClick = CategoriaClick
      end
      object Cliente: TMenuItem
        Caption = 'Cliente'
        OnClick = ClienteClick
      end
      object FichadeCliente: TMenuItem
        Caption = 'Ficha de Cliente'
        OnClick = FichadeClienteClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Produto: TMenuItem
        Caption = 'Produto'
        OnClick = ProdutoClick
      end
      object ProdutoporCategoria: TMenuItem
        Caption = 'Produto por Categoria'
        OnClick = ProdutoporCategoriaClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object VendaporData: TMenuItem
        Caption = 'Venda por Data'
        OnClick = VendaporDataClick
      end
    end
  end
  object tmrAtualizaDashboard: TTimer
    Interval = 60000
    OnTimer = tmrAtualizaDashboardTimer
    Left = 664
    Top = 16
  end
end
