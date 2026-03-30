unit uCadCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, uEnum, cCadCliente, uDTMConexao, RxToolEdit;

type
  //Campos visuais
  TTfrmCadCliente = class(TfrmTelaHeranca)
    edtClienteId: TLabeledEdit;
    edtNome: TLabeledEdit;
    edtCEP: TMaskEdit;
    lblCEP: TLabel;
    edtEndereco: TLabeledEdit;
    edtBairro: TLabeledEdit;
    edtCidade: TLabeledEdit;
    edtTelefone: TMaskEdit;
    lblTelefone: TLabel;
    edtEmail: TLabeledEdit;
    edtDataNascimento: TDateEdit;
    lblData: TLabel;
  // colunas da consulta SQL usando o Grid
    QryListagemclienteId: TFDAutoIncField;
    QryListagemnome: TStringField;
    QryListagemendereco: TStringField;
    QryListagemcidade: TStringField;
    QryListagembairro: TStringField;
    QryListagemestado: TStringField;
    QryListagemcep: TStringField;
    QryListagemtelefone: TStringField;
    QryListagememail: TStringField;
    QryListagemdatanascimento: TSQLTimeStampField;
    edtEstado: TLabeledEdit;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblTelefoneClick(Sender: TObject);
  private
    { Private declarations }
  // TCliente essa classe é responsável por Inserir, Atualizar, Apagar e Buscar no banco de dados
    oCliente:TCliente;
    function  Apagar:Boolean; override;
    function  Gravar(EstadoDoCadastro:TEstadoDoCadastro):Boolean; override;
  public
    { Public declarations }
  end;

var
  TfrmCadCliente: TTfrmCadCliente;

implementation

{$R *.dfm}

{ TfrmCadCliente }

{$region 'Override'}
function TTfrmCadCliente.Apagar: Boolean;
begin
  if oCliente.Selecionar(QryListagem.FieldByName('clienteId').AsInteger) then begin
     Result:=oCliente.Apagar;
  end;
end;


// Botão alterar carrega dados do cliente selecionado no grid
procedure TTfrmCadCliente.btnAlterarClick(Sender: TObject);
begin

  if oCliente.Selecionar(QryListagem.FieldByName('clienteId').AsInteger) then begin
     edtClienteId.Text:=IntToStr(oCliente.codigo);
     edtNome.Text          :=oCliente.nome;
     edtCEP.Text           :=oCliente.cep;
     edtEndereco.Text      :=oCliente.endereco;
     edtBairro.Text        :=oCliente.bairro;
     edtCidade.Text        :=oCliente.cidade;
     edtTelefone.Text      :=oCliente.telefone;
     edtEmail.Text         :=oCliente.email;
     edtDataNascimento.Date:=oCliente.dataNascimento;
     edtEstado.Text        :=oCliente.estado;
  end
  else begin
    btnCancelar.Click;
    Abort;
  end;

  inherited;

end;

function TTfrmCadCliente.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin
  if edtClienteId.Text<>EmptyStr then
     oCliente.codigo:=StrToInt(edtClienteId.Text)
  else
     oCliente.codigo:=0;

  //pega os dados da tela
  oCliente.nome           :=edtNome.Text;
  oCliente.cep            :=edtCEP.Text;
  oCliente.endereco       :=edtEndereco.Text;
  oCliente.bairro         :=edtBairro.Text;
  oCliente.cidade         :=edtCidade.Text;
  oCliente.telefone       :=edtTelefone.Text;
  oCliente.email          :=edtEmail.Text;
  oCliente.dataNascimento :=edtDataNascimento.Date;
  oCliente.estado         :=edtEstado.Text;

  //verifica estado se é update ou insert
  if (EstadoDoCadastro=ecInserir) then
     Result:=oCliente.Inserir
  else if (EstadoDoCadastro=ecAlterar) then
     Result:=oCliente.Atualizar;
end;
procedure TTfrmCadCliente.lblTelefoneClick(Sender: TObject);
begin
  inherited;

end;

{$endregion}

procedure TTfrmCadCliente.btnNovoClick(Sender: TObject);
begin
  inherited;
  edtDataNascimento.Date:=Date;
  edtNome.SetFocus;

end;

procedure TTfrmCadCliente.FormCreate(Sender: TObject);
begin
  inherited;
    oCliente:=TCliente.Create(dtmPrincipal.ConexaoDB);

  IndiceAtual:='nome';

end;


procedure TTfrmCadCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
    if Assigned(oCliente) then
     FreeAndNil(oCliente);

end;
end.

