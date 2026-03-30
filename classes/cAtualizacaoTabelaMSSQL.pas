unit cAtualizacaoTabelaMSSQL;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, RxToolEdit, cCadUsuario, cAtualizacaoBandoDeDados;

type
  TAtualizacaoTableMSSQL = class(TAtualizaBancoDeDados)

  private
    function  TabelaExiste(aNomeTabela:String):Boolean;

  protected

  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;

    procedure Categoria;
    procedure Cliente;
    procedure Produto;
    procedure Vendas;
    procedure VendasItens;
    procedure Usuario;
    procedure AcaoAcesso;
    procedure UsuariosAcaoAcesso;
end;

implementation


{ TAtualizacaoTableMSSQL }

constructor TAtualizacaoTableMSSQL.Create(aConexao: TFDConnection);
begin
  ConexaoDB := aConexao;
  Categoria;
  Cliente;
  Produto;
  Vendas;
  VendasItens;
  Usuario;
  AcaoAcesso;
  UsuariosAcaoAcesso;
end;

destructor TAtualizacaoTableMSSQL.Destroy;
begin
  inherited;
end;

function TAtualizacaoTableMSSQL.TabelaExiste(aNomeTabela: String): Boolean;
Var Qry:TFDQuery;
Begin
  Try
    Result:=False;
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT OBJECT_ID (:NomeTabela) As ID ');
    Qry.ParamByName('NomeTabela').AsString:=aNomeTabela;
    Qry.Open;

    if Qry.FieldByName('ID').AsInteger>0 then
       Result:=True;

  Finally
    Qry.Close;
    if Assigned(Qry) then
       FreeAndNil(Qry);
  End;
end;

procedure TAtualizacaoTableMSSQL.Usuario;
Var oUsuario:TUsuario;
begin
  if not TabelaExiste('usuarios') then
  begin
    ExecutaDiretoBancoDeDados(
      'CREATE TABLE usuarios ( '+
      '	 usuarioId int identity(1,1) not null, '+
      '	 nome varchar(50) not null, '+
      '	 senha varchar(40) not null, '+
      '	 PRIMARY KEY (usuarioId) '+
      '	) '
    );
  end;

  Try
    oUsuario:=TUsuario.Create(ConexaoDB);
    oUsuario.nome:='admin';
    oUsuario.senha:='admin';
    if not oUsuario.UsuarioExiste(oUsuario.nome) then
      oUsuario.Inserir;
  Finally
    if Assigned(oUsuario) then
       FreeAndNil(oUsuario);
  End;
end;


procedure TAtualizacaoTableMSSQL.UsuariosAcaoAcesso;
begin
  if not TabelaExiste('usuariosAcaoAcesso') then
    begin
      ExecutaDiretoBancoDeDados(
        'CREATE TABLE usuariosAcaoAcesso( '+
        '	 usuarioId  int NOT NULL, '+
        '	 acaoAcessoId int NOT NULL, '+
        '	 ativo bit not null default 1, '+
        '	 PRIMARY KEY (usuarioId, acaoAcessoId), '+
        '	 CONSTRAINT FK_UsuarioAcaoAcessoUsuario '+
        '	 FOREIGN KEY (usuarioId) references usuarios(usuarioId), '+
        '	 CONSTRAINT FK_UsuarioAcaoAcessoAcaoAcesso '+
        '	 FOREIGN KEY (acaoAcessoId) references acaoAcesso(acaoAcessoId) '+
        '	) '
      );
    end;
end;

procedure TAtualizacaoTableMSSQL.AcaoAcesso;
begin
  IF NOT TabelaExiste('acaoAcesso') then
  begin
    ExecutaDiretoBancoDeDados(
    'CREATE TABLE acaoAcesso ( '+
    '  acaoAcessoId int identity(1,1) not null, '+
    '  descricao varchar (100) not null, '+
    ' chave varchar (60) not null, '+
    ' PRIMARY KEY (acaoAcessoId) ' +
    ' ) '
    );
  end;
end;

procedure TAtualizacaoTableMSSQL.Categoria;
begin
  if not TabelaExiste('categorias') then
  begin
  ExecutaDiretoBancoDeDados(
  '    CREATE TABLE categorias(  '+
	'   categoriasId int IDENTITY(1,1) NOT NULL,  '+
	'   descricao  varchar(30) NULL,  '+
	'   PRIMARY KEY (categoriasId)  '
  );
  end;
end;

procedure TAtualizacaoTableMSSQL.Cliente;
begin
  if not TabelaExiste('clientes') then
  begin
    ExecutaDiretoBancoDeDados(
    'CREATE TABLE clientes( '+
    ' clienteId int IDENTITY(1,1) NOT NULL, '+
    ' nome varchar(60) NULL, '+
    ' endereco varchar(60) null, '+
    ' cidade varchar(50) null, '+
    ' bairro varchar(40) null, '+
    ' estado varchar(2) null, '+
    ' cep varchar(10) null, '+
    ' telefone varchar(14) null, '+
    ' email varchar(100) null, '+
    ' dataNascimento datetime null, '+
    ' PRIMARY KEY (clienteId) '+
    ')'
    );
  end;
end;

procedure TAtualizacaoTableMSSQL.Produto;
begin
  if not TabelaExiste('produtos') then
  begin
    ExecutaDiretoBancoDeDados(
  '    CREATE TABLE produtos(    '+
	'	produtoId int IDENTITY(1,1) NOT NULL,  '+
	'	nome varchar(60) NULL,  '+
	'	descricao varchar(255) null,  '+
  ' foto varbinary(max),  '+
	'	valor decimal(18,5) default 0.00000 null,  '+
	'	quantidade decimal(18,5) default 0.00000 null,  '+
	'	categoriasId int null,  '+
	'	PRIMARY KEY (produtoId),  '+
	'	CONSTRAINT FK_ProdutosCategorias  '+
	'	FOREIGN KEY (categoriasId) references categorias(categoriasId)  '+
	') '
    );
  end;
end;


procedure TAtualizacaoTableMSSQL.Vendas;
begin
  if not TabelaExiste('vendas') then
  begin
    ExecutaDiretoBancoDeDados(
  '    Create table vendas (  '+
	'  vendaId int identity(1,1) not null,  '+
	'  clienteId int not null,  '+
	' dataVenda datetime default getdate(),  '+
	' totalVenda decimal(18,5) default 0.00000,  '+
	'  PRIMARY KEY (vendaId), '+
	'  CONSTRAINT FK_VendasClientes FOREIGN KEY (clienteId)  '+
	'	REFERENCES clientes(clienteId)  '+
	')  '
    );
  end;
end;

procedure TAtualizacaoTableMSSQL.VendasItens;
begin
  if not TabelaExiste('vendasItens') then
  begin
    ExecutaDiretoBancoDeDados(
  '    Create table vendasItens (  '+
	'  vendaId int not null,  '+
	'  produtoId int not null,   '+
	'  valorUnitario decimal (18,5) default 0.00000,  '+
	'  quantidade decimal (18,5) default 0.00000,    '+
	'  totalProduto decimal (18,5) default 0.00000,   '+
	'  PRIMARY KEY (vendaId,produtoId),  '+
	'  CONSTRAINT FK_VendasItensProdutos FOREIGN KEY (produtoId)  '+
	'	REFERENCES produtos(produtoId)  '+
	')  '
    );
  end;
end;
end.

