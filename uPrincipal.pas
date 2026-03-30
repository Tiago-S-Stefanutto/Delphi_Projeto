unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, uDTMConexao, Enter, uFrmAtualizaDB, uProVenda,
  uRelCategoria, uRelClienteFicha, uRelProduto, uRelCliente, uRelProdutoComCategoria,
  uSelecionarData, uRelVendaPorData, uCadUsuario, uAlterarSenha, cUsuarioLogado,
  Vcl.ComCtrls, uLogin, uCadAcaoAcesso, cAcaoAcesso, RLReport, uUsuarioVsAcoes, uTelaHeranca, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, uDtmGrafico,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.DBChart, cArquivoIni, cFuncao, cAtualizacaoCampoMSSQL;

type
  TfrmPrincipal = class(TForm)
    MenuPrincipal: TMainMenu;
    C1: TMenuItem;
    Produtos1: TMenuItem;
    Movimentao1: TMenuItem;
    Cliente1: TMenuItem;
    N1: TMenuItem;
    Categoria1: TMenuItem;
    Produto1: TMenuItem;
    N2: TMenuItem;
    MnFechar: TMenuItem;
    Venda1: TMenuItem;
    Cliente: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    VendaporData: TMenuItem;
    Categoria: TMenuItem;
    FichadeCliente: TMenuItem;
    Produto: TMenuItem;
    ProdutoporCategoria: TMenuItem;
    Usurio1: TMenuItem;
    N5: TMenuItem;
    AlterarSenha1: TMenuItem;
    stbPrincipal: TStatusBar;
    AoAcesso1: TMenuItem;
    N6: TMenuItem;
    UsuriosVsAes1: TMenuItem;
    N7: TMenuItem;
    GridPanel1: TGridPanel;
    DBChart1: TDBChart;
    Series1: TBarSeries;
    DBChart2: TDBChart;
    Series2: TPieSeries;
    DBChart3: TDBChart;
    DBChart4: TDBChart;
    Series3: TPieSeries;
    Series4: TFastLineSeries;
    Panel1: TPanel;
    tmrAtualizaDashboard: TTimer;
    procedure MnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Categoria1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Cliente1Click(Sender: TObject);
    procedure Venda1Click(Sender: TObject);
    procedure CategoriaClick(Sender: TObject);
    procedure ClienteClick(Sender: TObject);
    procedure FichadeClienteClick(Sender: TObject);
    procedure ProdutoClick(Sender: TObject);
    procedure ProdutoporCategoriaClick(Sender: TObject);
    procedure VendaporDataClick(Sender: TObject);
    procedure Usurio1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AlterarSenha1Click(Sender: TObject);
    procedure AoAcesso1Click(Sender: TObject);
    procedure Produto1Click(Sender: TObject);
    procedure UsuriosVsAes1Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure tmrAtualizaDashboardTimer(Sender: TObject);
  private
    { Private declarations }
    TeclaEnter: TMREnter;
    procedure AtualizacaoBancoDados(aForm:TfrmAtualizaDB);
  public
    { Public declarations }
    procedure AtualizarDashBoard;
  end;

var
  frmPrincipal: TfrmPrincipal;
  oUsuarioLogado: TUsuarioLogado;
implementation


{$R *.dfm}

uses uCadCategorias, uCadCliente, uCadProduto, cAtualizacaoBandoDeDados;

procedure TfrmPrincipal.Categoria1Click(Sender: TObject);
begin
  TFuncao.CriarForm(TfrmCadCategorias, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.CategoriaClick(Sender: TObject);
begin
 TFuncao.CriarRelatorio(TfrmRelCategoria, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.Cliente1Click(Sender: TObject);
begin
  TFuncao.CriarForm(TTfrmCadCliente, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.ClienteClick(Sender: TObject);
begin
  TFuncao.CriarRelatorio(TfrmRelCliente, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.FichadeClienteClick(Sender: TObject);
begin
  TFuncao.CriarRelatorio(TfrmRelClienteFicha, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(TeclaEnter);
  FreeAndNil(dtmPrincipal);
  FreeAndNil(dtmGrafico);


  if Assigned(DtmPrincipal) then
     FreeAndNil(DtmPrincipal);

  if Assigned(oUsuarioLogado) then
     FreeAndNil(oUsuarioLogado);

end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin

  if not FileExists(TArquivoIni.ArquivoIni) then
  begin
    TArquivoIni.AtualizarIni('SERVER','TipoDataBase','MSSQL');
    TArquivoIni.AtualizarIni('SERVER','HostName','.\');
    TArquivoIni.AtualizarIni('SERVER','Port','1433');
    TArquivoIni.AtualizarIni('SERVER','OSAuthent','Yes');
    TArquivoIni.AtualizarIni('SERVER','User','admin');
    TArquivoIni.AtualizarIni('SERVER','Password','admin');
    TArquivoIni.AtualizarIni('SERVER','Database','vendas');

    MessageDlg('Arquivo '+ TArquivoIni.ArquivoIni +'Criado com sucesso!'+#13+
               'Configure o arquivo antes de inicializar a aplicação!!!',mtInformation,[mbOK],0);

    Application.Terminate;
    {Server=DC-TR-02-VM\SERVERCURSO
    Database=vendas
    OSAuthent=Yes
    DriverID=MSSQL
    User_Name=DOMTEC\devmv
    Connected=True}
  end
  else begin
  frmAtualizaDB:=TfrmAtualizaDB.Create(Self);
  frmAtualizaDB.Show;
  frmAtualizaDB.Refresh;

  dtmPrincipal := TdtmPrincipal.Create(Self);

    with dtmPrincipal.ConexaoDB do
    begin
      Connected := False;
      Params.Clear;

      Params.DriverID := 'MSSQL';

      Params.Add('Server=' + TArquivoIni.LerIni('SERVER','HostName'));
      Params.Add('Database=' + TArquivoIni.LerIni('SERVER','Database'));

      // Autenticação
      if TArquivoIni.LerIni('SERVER','OSAuthent') = 'Yes' then
        Params.Add('OSAuthent=Yes')
      else
      begin
        Params.Add('User_Name=' + TArquivoIni.LerIni('SERVER','User'));
        Params.Add('Password=' + TArquivoIni.LerIni('SERVER','Password'));
      end;

      // Porta (opcional)
      if TArquivoIni.LerIni('SERVER','Port') <> '' then
        Params.Add('Port=' + TArquivoIni.LerIni('SERVER','Port'));

      LoginPrompt := False;
      try
        Connected := True;
      except
        on E: Exception do
        begin
          ShowMessage('Erro ao conectar: ' + E.Message);
          Exit;
        end;
      end;
    end;



  dtmPrincipal.ConexaoDB.Connected:=True;
  TeclaEnter := TMREnter.Create(Self);
  TeclaEnter.FocusEnabled:=True;
  TeclaEnter.FocusColor:=clInfoBk;

  AtualizacaoBancoDados(frmAtualizaDB);

    TAcaoAcesso.CriarAcoes(TfrmCadCategorias,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TTfrmCadCliente,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmCadProduto,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmCadUsuario,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmCadAcaoAcesso,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmAlterarSenha,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmProVenda,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmRelVendaPorData,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmRelClienteFicha,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmRelCliente,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmRelProdutoComCategoria,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmRelProduto,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmRelCategoria,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmUsuarioVsAcoes,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmSelecionarData,DtmPrincipal.ConexaoDB);


    TAcaoAcesso.PreencherUsuariosVsAcoes(dtmPrincipal.ConexaoDB);

  dtmGrafico:=TdtmGrafico.Create(Self);
  AtualizarDashBoard;
  frmAtualizaDB.Free;
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  try
    oUsuarioLogado := TUsuarioLogado.Create;

    frmLogin :=TfrmLogin.Create(Self);
    frmLogin.ShowModal;
  finally
    frmLogin.Release;
    stbPrincipal.panels[0].Text:='Usuário: '+oUsuarioLogado.nome;
  end;
end;

procedure TfrmPrincipal.AlterarSenha1Click(Sender: TObject);
begin
  TFuncao.CriarForm(TfrmAlterarSenha, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.AoAcesso1Click(Sender: TObject);
begin
  TFuncao.CriarForm(TfrmCadAcaoAcesso, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure   TfrmPrincipal.AtualizacaoBancoDados(aForm:TfrmAtualizaDB);
var oAtualizarMSSQL:TAtualizaBancoDeDadosMSSQL;
begin

  aForm.Refresh;
  try
    oAtualizarMSSQL:=TAtualizaBancoDeDadosMSSQL.Create(dtmPrincipal.ConexaoDB);
    oAtualizarMSSQL.AtualizaBancoDeDadosMSSQL;
  finally
    if Assigned(oAtualizarMSSQL) then
      FreeAndNil(oAtualizarMSSQL);
  end;

 {dtmPrincipal.QryScriptCategoria.ExecSQL;
  aForm.chkCategoria.Checked := true;
  aForm.Refresh;
  Sleep(1);

  dtmPrincipal.QryScriptProdutos.ExecSQL;
  aForm.chkProduto.Checked := true;
  aForm.Refresh;
  Sleep(1);

  dtmPrincipal.QryScriptClientes.ExecSQL;
  aForm.chkCliente.Checked := true;
  aForm.Refresh;
  Sleep(1);

  dtmPrincipal.QryScriptVendas.ExecSQL;
  aForm.chkVendas.Checked := true;
  aForm.Refresh;
  Sleep(1);

  dtmPrincipal.QryScriptItensVendas.ExecSQL;
  aForm.chkItensVendas.Checked := true;
  aForm.Refresh;
  Sleep(1);

  dtmPrincipal.QryScriptUsuarios.ExecSQL;
  aForm.chkUsuarios.Checked := true;
  aForm.Refresh;
  Sleep(1);    }

  end;

procedure TfrmPrincipal.MnFecharClick(Sender: TObject);
begin
         Application.Terminate;
end;

procedure TfrmPrincipal.Panel1Click(Sender: TObject);
begin
  AtualizarDashBoard;
end;

procedure TfrmPrincipal.Produto1Click(Sender: TObject);
begin
  TFuncao.CriarForm(TfrmCadProduto, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.ProdutoClick(Sender: TObject);
begin
  TFuncao.CriarRelatorio(TfrmRelProduto, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.ProdutoporCategoriaClick(Sender: TObject);
begin
  TFuncao.CriarRelatorio(TfrmRelProdutoComCategoria, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.tmrAtualizaDashboardTimer(Sender: TObject);
begin
  AtualizarDashBoard;
end;

procedure TfrmPrincipal.Usurio1Click(Sender: TObject);
begin
  TFuncao.CriarForm(TfrmCadUsuario, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.UsuriosVsAes1Click(Sender: TObject);
begin
  TFuncao.CriarForm(TfrmUsuarioVsAcoes, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;

procedure TfrmPrincipal.Venda1Click(Sender: TObject);
begin
  TFuncao.CriarForm(TfrmProVenda, oUsuarioLogado, dtmPrincipal.ConexaoDB);
end;


//frmRelVendaPorData

procedure TfrmPrincipal.VendaporDataClick(Sender: TObject);
begin


  Try
    frmSelecionarData:=TfrmSelecionarData.Create(Self);
    if TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, 'frmRelVendaPorData',DtmPrincipal.ConexaoDB) then
    begin
      frmSelecionarData.ShowModal;

      frmRelVendaPorData:=TfrmRelVendaPorData.Create(self);
      frmRelVendaPorData.QryVendaPorData.Close;
      frmRelVendaPorData.QryVendaPorData.ParamByName('DataInicio').AsDate:=frmSelecionarData.EdtDataInicio.Date;
      frmRelVendaPorData.QryVendaPorData.ParamByName('DataFim').AsDate:=frmSelecionarData.EdtDataFinal.Date;
      frmRelVendaPorData.QryVendaPorData.Open;
      frmRelVendaPorData.Relatorio.PreviewModal;
    end
    else begin
       MessageDlg('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
    end;

  Finally
    if Assigned(frmSelecionarData) then
       frmSelecionarData.Release;
    if Assigned(frmRelVendaPorData) then
       frmRelVendaPorData.Release;
  End;
end;

procedure TfrmPrincipal.AtualizarDashBoard;
begin
  try
    Screen.Cursor:=crSQLWait;
    if dtmGrafico.QryProdutoEstoque.Active then
      dtmGrafico.QryProdutoEstoque.Close;

    if dtmGrafico.QryValorVendaPorCliente.Active then
      dtmGrafico.QryValorVendaPorCliente.Close;

    if dtmGrafico.QryVendasUltimaSeana .Active then
      dtmGrafico.QryVendasUltimaSeana.Close;

    if dtmGrafico.QryProdutosMaisVendidos.Active then
      dtmGrafico.QryProdutosMaisVendidos.Close;

    dtmGrafico.QryProdutoEstoque.Open;
    dtmGrafico.QryValorVendaPorCliente.Open;
    dtmGrafico.QryVendasUltimaSeana.Open;
    dtmGrafico.QryProdutosMaisVendidos.Open;
  finally
    Screen.Cursor:=crSQLWait;
  end;

end;

end.
