program Vendas;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uDTMConexao in 'DataModule\uDTMConexao.pas' {dtmPrincipal: TDataModule},
  uTelaHeranca in 'Heranca\uTelaHeranca.pas' {frmTelaHeranca},
  uCadCategorias in 'Cadastro\uCadCategorias.pas' {frmCadCategorias},
  Enter in 'terceiros\Enter.pas',
  uEnum in 'Heranca\uEnum.pas',
  cCadCategoria in 'classes\cCadCategoria.pas',
  uCadCliente in 'Cadastro\uCadCliente.pas' {TfrmCadCliente},
  cCadCliente in 'classes\cCadCliente.pas',
  uCadProduto in 'Cadastro\uCadProduto.pas' {frmCadProduto},
  cCadProduto in 'classes\cCadProduto.pas',
  uFrmAtualizaDB in 'DataModule\uFrmAtualizaDB.pas' {Form1},
  uDtmVenda in 'DataModule\uDtmVenda.pas' {dtmVenda: TDataModule},
  uProVenda in 'processo\uProVenda.pas' {frmProVenda},
  cProdutoVenda in 'classes\cProdutoVenda.pas',
  cControleEstoque in 'classes\cControleEstoque.pas',
  uRelCategoria in 'Relatório\uRelCategoria.pas' {frmRelCategoria},
  uRelClienteFicha in 'Relatório\uRelClienteFicha.pas' {frmRelClienteFicha},
  uRelProVenda in 'Relatório\uRelProVenda.pas' {frmRelProVenda},
  uRelCliente in 'Relatório\uRelCliente.pas' {frmRelCliente},
  uRelProduto in 'Relatório\uRelProduto.pas' {frmRelProduto},
  uSelecionarData in 'Relatório\uSelecionarData.pas' {frmSelecionarData},
  uRelProdutoComCategoria in 'Relatório\uRelProdutoComCategoria.pas' {frmRelProdutoComCategoria},
  uRelVendaPorData in 'Relatório\uRelVendaPorData.pas' {frmRelVendaPorData},
  uFuncaoCriptografia in 'Heranca\uFuncaoCriptografia.pas',
  cCadUsuario in 'classes\cCadUsuario.pas',
  uCadUsuario in 'Cadastro\uCadUsuario.pas' {frmCadUsuario},
  uLogin in 'Login\uLogin.pas' {frmLogin},
  uAlterarSenha in 'Login\uAlterarSenha.pas' {frmAlterarSenha},
  cUsuarioLogado in 'classes\cUsuarioLogado.pas',
  cAtualizacaoBandoDeDados in 'classes\cAtualizacaoBandoDeDados.pas',
  cAtualizacaoTabelaMSSQL in 'classes\cAtualizacaoTabelaMSSQL.pas',
  cAtualizacaoCampoMSSQL in 'classes\cAtualizacaoCampoMSSQL.pas',
  cAcaoAcesso in 'classes\cAcaoAcesso.pas',
  uCadAcaoAcesso in 'Cadastro\uCadAcaoAcesso.pas' {frmCadAcaoAcesso},
  uUsuarioVsAcoes in 'Login\uUsuarioVsAcoes.pas' {frmUsuarioVsAcoes},
  uDtmGrafico in 'DataModule\uDtmGrafico.pas' {dtmGrafico: TDataModule},
  cArquivoIni in 'classes\cArquivoIni.pas',
  cFuncao in 'classes\cFuncao.pas',
  uTelaHerancaConsulta in 'Heranca\uTelaHerancaConsulta.pas' {frmTelaHenrancaConsulta},
  uConCategoria in 'consulta\uConCategoria.pas' {frmConCategorias},
  uConClientes in 'consulta\uConClientes.pas' {frmConClientes},
  uConProdutos in 'consulta\uConProdutos.pas' {frmConsultaProdutos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
