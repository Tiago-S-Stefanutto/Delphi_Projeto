# 🛒 Sistema de Vendas — Delphi VCL + SQL Server

Sistema desktop completo de gestão comercial desenvolvido em **Delphi (VCL)** com banco de dados **Microsoft SQL Server**, cobrindo cadastros, processo de vendas, controle de estoque, relatórios e dashboards gerenciais.

---

## 📋 Sumário

- [Visão Geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Arquitetura do Projeto](#arquitetura-do-projeto)
- [Estrutura de Diretórios](#estrutura-de-diretórios)
- [Banco de Dados](#banco-de-dados)
- [Módulos do Sistema](#módulos-do-sistema)
- [Pré-requisitos](#pré-requisitos)
- [Configuração e Instalação](#configuração-e-instalação)
- [Padrões e Convenções](#padrões-e-convenções)
- [Segurança e Controle de Acesso](#segurança-e-controle-de-acesso)
- [Relatórios](#relatórios)
- [Dashboard](#dashboard)
- [Atualização Automática do Banco de Dados](#atualização-automática-do-banco-de-dados)
- [Dependências e Bibliotecas](#dependências-e-bibliotecas)

---

## Visão Geral

Este é um sistema de vendas desenvolvido integralmente em **Embarcadero Delphi** (compatível com Delphi XE7+), utilizando a arquitetura **VCL (Visual Component Library)** para interface gráfica e **FireDAC** para acesso ao banco de dados SQL Server.

O sistema foi construído seguindo o padrão de **herança de formulários**, onde uma tela-base (`TfrmTelaHeranca`) fornece comportamento padronizado de listagem, pesquisa, inserção, alteração e exclusão para todos os cadastros do sistema — garantindo consistência visual e de comportamento em toda a aplicação.

---

## Funcionalidades

### ✅ Cadastros
- Clientes (nome, endereço, cidade, bairro, estado, CEP, telefone, e-mail, data de nascimento)
- Produtos (nome, descrição, valor, quantidade em estoque, categoria, foto)
- Categorias de produtos
- Usuários do sistema (com senha criptografada)
- Ações de Acesso (permissões granulares por botão/tela)

### ✅ Movimentação
- Pedido de Vendas com seleção de cliente e múltiplos itens
- Baixa automática de estoque ao confirmar venda
- Devolução automática de estoque ao excluir venda
- Impressão automática de comprovante ao gravar venda

### ✅ Relatórios
- Listagem de Categorias
- Listagem de Clientes
- Ficha individual de Cliente
- Listagem de Produtos
- Produtos por Categoria (com subtotais e médias)
- Listagem de Vendas (com itens agrupados por venda)
- Vendas por Período (data início / data fim, com total geral)

### ✅ Dashboard Gerencial (tela principal)
- Gráfico de barras: Produtos em Estoque
- Gráfico de pizza: Valor de Venda por Cliente (última semana)
- Gráfico de linha: Vendas da Última Semana
- Gráfico de pizza: Top 10 Produtos Mais Vendidos

### ✅ Segurança
- Login com autenticação por usuário e senha
- Controle de acesso por ação (cada botão do sistema pode ser liberado ou bloqueado por usuário)
- Troca de senha pelo próprio usuário
- Criptografia de senhas

### ✅ Infraestrutura
- Atualização automática do banco de dados (DDL automático na inicialização)
- Configurações armazenadas em arquivo `.INI`
- Pesquisa avançada nas listagens (por campo indexado e por tipo de dado)
- Filtro por data nos pedidos de venda

---

## Arquitetura do Projeto

O projeto segue uma arquitetura em camadas:

```
┌──────────────────────────────────────────┐
│           Interface (Forms / VCL)        │
│  uPrincipal, Cadastro/*, processo/*,     │
│  Login/*, Relatório/*                    │
├──────────────────────────────────────────┤
│         Herança de Telas (Base)          │
│  uTelaHeranca, uTelaHerancaConsulta      │
├──────────────────────────────────────────┤
│          Classes de Negócio              │
│  classes/cCadCategoria, cCadCliente,     │
│  cCadProduto, cCadUsuario, cProdutoVenda,│
│  cControleEstoque, cAcaoAcesso,          │
│  cUsuarioLogado                          │
├──────────────────────────────────────────┤
│          DataModules / Acesso a Dados    │
│  uDTMConexao, uDtmVenda, uDtmGrafico    │
├──────────────────────────────────────────┤
│              Banco de Dados              │
│           Microsoft SQL Server           │
└──────────────────────────────────────────┘
```

### Padrão de Tela Herdada

Todos os formulários de cadastro herdam de `TfrmTelaHeranca`, que fornece:

| Componente | Descrição |
|---|---|
| `QryListagem` | Query de listagem com suporte a índice e pesquisa |
| `grdListagem` | Grid de dados com clique duplo para alteração |
| `mskPesquisar` | Campo de pesquisa em tempo real |
| `btnPesquisar` | Pesquisa avançada com filtro SQL dinâmico |
| `btnNovo` | Limpa formulário e habilita inserção |
| `btnAlterar` | Carrega registro selecionado |
| `btnGravar` | Valida e persiste os dados |
| `btnApagar` | Remove registro com confirmação |
| `btnCancelar` | Cancela operação em andamento |
| `btnFechar` | Fecha o formulário |
| `btnNavigator` | Navegação entre registros |

Os formulários filhos apenas sobrescrevem os métodos `Gravar()` e `Apagar()`, além do `FormCreate` para configuração inicial.

---

## Estrutura de Diretórios

```
/
├── Cadastro/                   # Formulários de cadastro
│   ├── uCadAcaoAcesso.*        # Cadastro de Ações de Acesso
│   ├── uCadCategorias.*        # Cadastro de Categorias
│   ├── uCadCliente.*           # Cadastro de Clientes
│   ├── uCadProduto.*           # Cadastro de Produtos (com foto)
│   └── uCadUsuario.*           # Cadastro de Usuários
│
├── classes/                    # Classes de regras de negócio (DAO/Model)
│   ├── cAcaoAcesso.pas         # Gestão de ações de acesso
│   ├── cArquivoIni.pas         # Leitura/gravação de configurações INI
│   ├── cAtualizacaoBandoDeDados.pas   # Base para atualização de BD
│   ├── cAtualizacaoCampoMSSQL.pas     # Adiciona colunas faltantes
│   ├── cAtualizacaoTabelaMSSQL.pas    # Cria tabelas faltantes
│   ├── cCadCategoria.pas       # CRUD de categorias
│   ├── cCadCliente.pas         # CRUD de clientes
│   ├── cCadProduto.pas         # CRUD de produtos (com BLOB de foto)
│   ├── cCadUsuario.pas         # CRUD de usuários
│   ├── cControleEstoque.pas    # Baixa e retorno de estoque
│   ├── cFuncao.pas             # Utilitários gerais
│   ├── cProdutoVenda.pas       # Processo de venda (CRUD de vendas e itens)
│   └── cUsuarioLogado.pas      # Sessão do usuário logado e verificação de acesso
│
├── consulta/                   # Formulários de consulta/lookup
│   ├── uConCategoria.*         # Lookup de categorias
│   ├── uConClientes.*          # Lookup de clientes
│   └── uConProdutos.*          # Lookup de produtos
│
├── DataModule/                 # DataModules de conexão e dados
│   ├── uDTMConexao.*           # Conexão principal com o SQL Server (FireDAC)
│   ├── uDtmGrafico.*           # Queries para os gráficos do dashboard
│   ├── uDtmVenda.*             # DataModule do processo de venda
│   └── uFrmAtualizaDB.*        # Tela de aguarde na atualização do BD
│
├── Heranca/                    # Formulários e classes base
│   ├── uEnum.pas               # Enumerações (TEstadoDoCadastro, TAcaoExcluirEstoque)
│   ├── uFuncaoCriptografia.pas # Criptografia de senhas
│   ├── uTelaHeranca.*          # Formulário base de cadastro
│   └── uTelaHerancaConsulta.*  # Formulário base de consulta/lookup
│
├── Login/                      # Autenticação e autorização
│   ├── uAlterarSenha.*         # Troca de senha do usuário
│   ├── uLogin.*                # Tela de login
│   └── uUsuarioVsAcoes.*       # Vinculação de usuários com ações de acesso
│
├── processo/                   # Processos de negócio
│   └── uProVenda.*             # Processo completo de venda
│
├── Relatório/                  # Formulários de relatório (FortesReport)
│   ├── uRelCategoria.*         # Relatório de categorias
│   ├── uRelCliente.*           # Listagem de clientes
│   ├── uRelClienteFicha.*      # Ficha de cliente
│   ├── uRelProVenda.*          # Comprovante de venda (mestre-detalhe)
│   ├── uRelProduto.*           # Listagem de produtos
│   ├── uRelProdutoComCategoria.* # Produtos agrupados por categoria
│   ├── uRelVendaPorData.*      # Vendas em período
│   └── uSelecionarData.*       # Seletor de intervalo de datas
│
├── terceiros/
│   └── Enter.pas               # Componente de navegação por Enter
│
├── uPrincipal.*                # Menu principal e dashboard
├── Vendas.dpr                  # Arquivo de projeto Delphi
└── Vendas.dproj                # Arquivo de projeto MSBuild
```

---

## Banco de Dados

### Tabelas

| Tabela | Descrição | Chave Primária |
|---|---|---|
| `categorias` | Categorias de produtos | `categoriasId` (identity) |
| `clientes` | Dados dos clientes | `clienteId` (identity) |
| `produtos` | Cadastro de produtos com foto (BLOB) | `produtoId` (identity) |
| `vendas` | Cabeçalho das vendas | `vendaId` (identity) |
| `vendasItens` | Itens de cada venda | `(vendaId, produtoId)` |
| `usuarios` | Usuários do sistema | `usuarioId` (identity) |
| `acaoAcesso` | Ações de acesso disponíveis | `acaoAcessoId` (identity) |
| `usuariosAcaoAcesso` | Permissões por usuário | `(usuarioId, acaoAcessoId)` |

### Diagrama Simplificado de Relacionamentos

```
categorias ──────────────────── produtos
                                    │
clientes ──── vendas ─── vendasItens
                              │
                           produtos

usuarios ──── usuariosAcaoAcesso ──── acaoAcesso
```

### Criação das Tabelas

O banco de dados é criado e atualizado **automaticamente** na inicialização do sistema via a classe `TAtualizacaoTableMSSQL`. Não é necessário executar scripts SQL manualmente. As migrações incluem:

- Criação de todas as tabelas se não existirem
- Adição de colunas faltantes (ex.: coluna `foto` em `produtos`)
- Criação do usuário `admin` padrão se não houver nenhum usuário cadastrado

---

## Módulos do Sistema

### Processo de Venda (`uProVenda`)

O processo de venda é o módulo central do sistema e suporta:

1. **Seleção de cliente** via combo lookup ou consulta avançada
2. **Adição de itens** com validação de estoque em tempo real
3. **Remoção de itens** individualmente
4. **Totalização automática** do valor da venda
5. **Gravação** com baixa de estoque simultânea
6. **Exclusão** com retorno automático de estoque
7. **Impressão imediata** do comprovante ao gravar
8. **Filtro por período** na listagem de vendas

**Regras de negócio aplicadas:**
- Não é possível gravar uma venda sem pelo menos um produto
- Não é possível adicionar quantidade superior ao estoque disponível
- Não é possível adicionar o mesmo produto duas vezes na mesma venda
- O estoque é atualizado atomicamente junto com a venda (mesma transação)

### Controle de Estoque (`cControleEstoque`)

- `BaixarEstoque`: desconta a quantidade vendida do produto
- `RetornarEstoque`: devolve a quantidade ao cancelar ou excluir uma venda
- Ambas as operações são transacionadas (StartTransaction / Commit / Rollback)

### Controle de Acesso (`cUsuarioLogado`)

A verificação de acesso é feita por chave de ação, no formato:

```
NomeDoFormulario_NomeDoButton
```

**Exemplo:**
- `frmTelaHeranca_btnNovo` — permissão para inserir
- `frmTelaHeranca_btnAlterar` — permissão para alterar
- `frmTelaHeranca_btnApagar` — permissão para apagar

A verificação é feita no banco de dados antes de qualquer operação sensível, consultando a tabela `usuariosAcaoAcesso`.

---

## Pré-requisitos

| Requisito | Versão Mínima |
|---|---|
| Embarcadero Delphi | XE7 ou superior (recomendado Delphi 10.x+) |
| Microsoft SQL Server | 2012 ou superior |
| FortesReport Community Edition | v4.0 |
| RxLib / RxTools | Compatível com a versão do Delphi |
| Sistema Operacional | Windows 7 ou superior (32 bits) |

### Componentes de Terceiros Necessários

- **FortesReport CE 4.0** — geração de relatórios (TRLReport, TRLBand, TRLPDFFilter, TRLXLSXFilter)
- **RxLib** — componentes visuais complementares (TCurrencyEdit, TDateEdit, TMaskEdit)
- **TeeChart** — gráficos do dashboard (TDBChart, TBarSeries, TPieSeries, TFastLineSeries)
- **FireDAC** — acesso ao banco de dados (incluso no Delphi)

---

## Configuração e Instalação

### 1. Clonar o repositório

```bash
git clone https://github.com/seu-usuario/sistema-vendas.git
cd sistema-vendas
```

### 2. Instalar as dependências de terceiros

Certifique-se de que os seguintes pacotes estão instalados no seu Delphi:
- FortesReport Community Edition 4.0
- RxLib para sua versão do Delphi
- TeeChart (geralmente incluso no Delphi)

### 3. Abrir o projeto

Abra o arquivo `Vendas.dproj` no Embarcadero Delphi.

### 4. Configurar a conexão com o banco de dados

No arquivo `uPrincipal.pas` (ou via tela de login/configuração), configure os parâmetros de conexão FireDAC para o seu SQL Server:

```pascal
// Parâmetros típicos de configuração FireDAC para SQL Server
ConexaoDB.Params.Values['DriverID']  := 'MSSQL';
ConexaoDB.Params.Values['Server']    := 'localhost';   // ou IP do servidor
ConexaoDB.Params.Values['Database']  := 'SistemaVendas';
ConexaoDB.Params.Values['User_Name'] := 'sa';
ConexaoDB.Params.Values['Password']  := 'sua_senha';
```

As configurações de conexão são lidas/salvas via `cArquivoIni` no arquivo `.INI` gerado ao lado do executável.

### 5. Compilar e executar

Compile o projeto (`Shift+F9`) e execute (`F9`). Na **primeira execução**:
- O sistema criará automaticamente todas as tabelas necessárias
- Será criado o usuário padrão `admin` com senha `admin`

### 6. Primeiro acesso

```
Usuário: admin
Senha:   admin
```

> ⚠️ **Importante:** Altere a senha do usuário `admin` imediatamente após o primeiro acesso pelo menu **Cadastro → Alterar Senha**.

---

## Padrões e Convenções

### Nomenclatura

| Tipo | Prefixo | Exemplo |
|---|---|---|
| Formulário | `frm` | `frmCadCategorias` |
| DataModule | `dtm` | `dtmPrincipal` |
| Query | `Qry` | `QryListagem` |
| DataSource | `dts` | `dtsListagem` |
| Classe de negócio | `T` + nome | `TCategoria`, `TVenda` |
| Campo de formulário | tipo + nome | `edtDescricao`, `lkpCliente` |
| Campo de variável privada | `F_` | `F_categoriasId`, `F_nome` |

### Campos com Tag Especial

Os campos nos formulários de cadastro usam a propriedade `Tag` com significado especial:

| Tag | Significado |
|---|---|
| `1` | Campo de chave primária (PK) — desabilitado automaticamente |
| `2` | Campo obrigatório — validado antes de gravar |

### Transações

Todas as operações de escrita no banco de dados seguem o padrão:

```pascal
try
  ConexaoDB.StartTransaction;
  Qry.ExecSQL;
  ConexaoDB.Commit;
except
  ConexaoDB.Rollback;
  Result := False;
end;
```

---

## Segurança e Controle de Acesso

### Cadastro de Ações de Acesso

Cada botão sensível do sistema deve ter uma entrada cadastrada na tabela `acaoAcesso` com uma `chave` no formato:

```
NomeFormulario_NomeBotao
```

### Atribuição de Permissões

No menu **Cadastro → Usuários Vs Ações**, o administrador pode:
- Visualizar todos os usuários no lado esquerdo
- Visualizar todas as ações disponíveis no lado direito
- Dar duplo clique em uma ação para **habilitar/desabilitar** o acesso
- Ações **habilitadas** aparecem com fundo normal; ações **desabilitadas** aparecem em **vermelho**

### Verificação em Runtime

A verificação ocorre antes de qualquer operação:

```pascal
if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, 
   Self.Name + '_' + TBitBtn(Sender).Name, 
   DtmPrincipal.ConexaoDB) then
begin
  MessageDlg('Usuário sem permissão de acesso', mtWarning, [mbOK], 0);
  Abort;
end;
```

---

## Relatórios

Os relatórios são gerados com **FortesReport Community Edition 4.0** e suportam exportação para:
- **PDF** (via TRLPDFFilter)
- **Excel XLSX** (via TRLXLSXFilter)
- **Excel 97-2013 XLS** (via TRLXLSFilter)

### Relatório de Vendas por Data

Este relatório exige a seleção de um intervalo de datas antes da impressão, apresentando:
- Agrupamento por data de venda
- Subtotal por data
- Total geral de todas as vendas no período

### Relatório de Produtos por Categoria

Apresenta:
- Agrupamento por categoria
- Total de quantidade em estoque por categoria
- Média de valor dos produtos por categoria

### Comprovante de Venda

Gerado automaticamente ao gravar uma venda, com layout mestre-detalhe mostrando:
- Dados da venda (número, cliente, data)
- Itens da venda (produto, quantidade, valor unitário, total)
- Total geral da venda

---

## Dashboard

A tela principal exibe 4 gráficos que são atualizados automaticamente a cada 60 segundos (via `TTimer`):

| Gráfico | Tipo | Fonte de Dados |
|---|---|---|
| Produtos em Estoque | Barras | `QryProdutoEstoque` — todos os produtos com quantidade |
| Venda por Cliente (última semana) | Pizza | `QryValorVendaPorCliente` — agrupado por cliente, últimos 7 dias |
| Vendas da Última Semana | Linha | `QryVendasUltimaSeana` — total por dia nos últimos 7 dias |
| Top 10 Produtos Mais Vendidos | Pizza | `QryProdutosMaisVendidos` — top 10 por total vendido |

---

## Atualização Automática do Banco de Dados

O sistema implementa um mecanismo de migração automática executado na inicialização:

### `TAtualizacaoTableMSSQL`
Verifica a existência de cada tabela via `OBJECT_ID()` e a cria se não existir. Tabelas gerenciadas:
`categorias`, `clientes`, `produtos`, `vendas`, `vendasItens`, `usuarios`, `acaoAcesso`, `usuariosAcaoAcesso`

### `TAtualizacaoCampoMSSQL`
Verifica a existência de colunas via `INFORMATION_SCHEMA.COLUMNS` e adiciona colunas faltantes.

Exemplo de migração gerenciada:
- Adição da coluna `foto` (`varbinary(max)`) na tabela `produtos`

Isso permite que instalações antigas do sistema sejam atualizadas sem perda de dados e sem intervenção manual.

---

## Dependências e Bibliotecas

| Biblioteca | Uso no Sistema |
|---|---|
| FireDAC (Embarcadero) | Acesso ao SQL Server, queries, transações |
| FortesReport CE 4.0 | Geração e exportação de relatórios |
| TeeChart | Gráficos do dashboard |
| RxLib | TCurrencyEdit, TDateEdit |
| VCL (Delphi) | Interface gráfica completa |
| Datasnap.DBClient | TClientDataSet para itens de venda em memória |

---

## Licença

Este projeto foi desenvolvido como material de curso/aprendizado. Verifique os termos de licença dos componentes de terceiros utilizados antes de uso comercial.

---

## Contato

Para dúvidas ou contribuições, abra uma *issue* ou *pull request* no repositório.
