object dtmVenda: TdtmVenda
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 271
  Width = 421
  object QryCliente: TFDQuery
    Connection = dtmPrincipal.ConexaoDB
    SQL.Strings = (
      'select clienteId,'
      ' nome'
      'from clientes')
    Left = 24
    Top = 16
    object F1QryClienteclienteId: TFDAutoIncField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'clienteId'
      Origin = 'clienteId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object F2QryClientenome: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
  end
  object QryProdutos: TFDQuery
    Connection = dtmPrincipal.ConexaoDB
    SQL.Strings = (
      'select produtoId,'
      ' nome,'
      ' valor,'
      ' quantidade'
      'from produtos')
    Left = 88
    Top = 16
    object F1QryProdutosprodutoId: TFDAutoIncField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'produtoId'
      Origin = 'produtoId'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object F2QryProdutosnome: TStringField
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
    object f1QryProdutosvalor: TFMTBCDField
      DisplayLabel = 'Valor'
      FieldName = 'valor'
      Origin = 'valor'
      Precision = 18
      Size = 5
    end
    object f1QryProdutosquantidade: TFMTBCDField
      DisplayLabel = 'Quantidade'
      FieldName = 'quantidade'
      Origin = 'quantidade'
      Precision = 18
      Size = 5
    end
  end
  object cdsItensVenda: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 232
    Top = 16
    object cdsItensVendaprodutoId: TIntegerField
      FieldName = 'produtoId'
    end
    object cdsItensVendanomeProduto: TStringField
      FieldName = 'nomeProduto'
      Size = 100
    end
    object cdsItensVendaquantidade: TFloatField
      FieldName = 'quantidade'
    end
    object cdsItensVendavalorUnitario: TFloatField
      FieldName = 'valorUnitario'
    end
    object cdsItensVendavalorTotalProduto: TFloatField
      FieldName = 'valorTotalProduto'
    end
  end
  object dtsCliente: TDataSource
    DataSet = QryCliente
    Left = 24
    Top = 72
  end
  object dtsProdutos: TDataSource
    DataSet = QryProdutos
    Left = 88
    Top = 64
  end
  object dtsItensVenda: TDataSource
    DataSet = cdsItensVenda
    Left = 232
    Top = 72
  end
end
