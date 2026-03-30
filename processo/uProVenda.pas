unit uProVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.ComCtrls, uDTMConexao, uDtmVenda, RxCurrEdit, RxToolEdit, uEnum,
  cProdutoVenda, uRelProVenda, uCadCliente,cFuncao, uConClientes, cUsuarioLogado, uConProdutos;

type
  TfrmProVenda = class(TfrmTelaHeranca)
    QryListagemvendaId: TFDAutoIncField;
    QryListagemclienteId: TIntegerField;
    QryListagemnome: TStringField;
    QryListagemdataVenda: TSQLTimeStampField;
    QryListagemtotalVenda: TFMTBCDField;
    edtVendaId: TLabeledEdit;
    lblCliente: TLabel;
    lkpCliente: TDBLookupComboBox;
    lblDataVenda: TLabel;
    edtDataVenda: TDateEdit;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    lblValor: TLabel;
    edtValorTotal: TCurrencyEdit;
    dbGridItensVenda: TDBGrid;
    Label1: TLabel;
    lkpProduto: TDBLookupComboBox;
    lblProduto: TLabel;
    edtValorUnitario: TCurrencyEdit;
    edtQuantidade: TCurrencyEdit;
    btnAdicionarItem: TBitBtn;
    btnApagarItem: TBitBtn;
    lblValorUnitario: TLabel;
    lblQuantidade: TLabel;
    lblTotaldoProduto: TLabel;
    btnClientes: TSpeedButton;
    btnPesquisarClientes: TSpeedButton;
    edtDataInicio: TDateEdit;
    edtDataFinal: TDateEdit;
    Label2: TLabel;
    Label3: TLabel;
    btnPesquisarProduto: TSpeedButton;
    edtTotalProduto: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure lkpProdutoExit(Sender: TObject);
    procedure edtQuantidadeExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnApagarItemClick(Sender: TObject);
    procedure dbGridItensVendaDblClick(Sender: TObject);
    procedure btnClientesClick(Sender: TObject);
    procedure btnPesquisarClientesClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnPesquisarProdutoClick(Sender: TObject);
  private
    { Private declarations }
    SelectOriginal:string;
    dtmVenda:TdtmVenda;
    oVenda:TVenda;
    function TotalizarProduto(valorUnitario, Quantidade: Double): Double;
    procedure LimparComponentesItem;
    procedure LimparCds;
    procedure CarregarRegistrosSelecionados;
    function TotalizarVenda: Double;
  public
    { Public declarations }
    function  Gravar(EstadoDoCadastro:TEstadoDoCadastro):Boolean; override;
    function  Apagar:Boolean; override;
  end;

var
  frmProVenda: TfrmProVenda;

implementation

uses uPrincipal;

{$REGION 'Override'}

function TfrmProVenda.Apagar: Boolean;
begin
  Result := oVenda.Apagar(QryListagem.FieldByName('vendaId').AsInteger);
end;

function  TfrmProVenda.Gravar(EstadoDoCadastro: TEstadoDoCadastro) : Boolean;
begin
  if edtVendaId.Text<>EmptyStr then
    oVenda.VendaId:=StrToInt(edtVendaId.Text)
  else
      oVenda.VendaId:=0;

    oVenda.ClienteId      :=lkpCliente.KeyValue;
    oVenda.DataVenda      :=edtDataVenda.Date;
    oVenda.TotalVenda     :=edtValorTotal.Value;

  if (EstadoDoCadastro=ecInserir) then
    oVenda.VendaId := oVenda.Inserir(dtmVenda.cdsItensVenda)
  else if (EstadoDoCadastro=ecAlterar) then
    oVenda.Atualizar(dtmVenda.cdsItensVenda);

    frmRelProVenda:=TfrmRelProVenda.Create(Self);
    frmRelProVenda.QryVenda.Close;
    frmRelProVenda.QryVenda.ParamByName('VendaId').AsInteger:= oVenda.VendaId;
    frmRelProVenda.QryVenda.Open;

    frmRelProVenda.QryVendaItens.Close;
    frmRelProVenda.QryVendaItens.ParamByName('VendaId').AsInteger:= oVenda.VendaId;
    frmRelProVenda.QryVendaItens.Open;

    frmRelProVenda.Relatorio.PreviewModal;
    frmRelProVenda.Release;

    Result:=True;
end;

procedure TfrmProVenda.lkpProdutoExit(Sender: TObject);
begin
  inherited;
  if TDBLookupComboBox(Sender).KeyValue<>Null then begin
  edtValorUnitario.Value:=dtmVenda.QryProdutos.FieldByName('valor').AsFloat;
  edtQuantidade.Value:=1;
  edtTotalProduto.Value:=TotalizarProduto(edtValorUnitario.Value, edtQuantidade.Value);
  end;
end;


{$ENDREGION}

{$R *.dfm}

procedure TfrmProVenda.btnAlterarClick(Sender: TObject);
begin
  inherited;


  if oVenda.Selecionar(QryListagem.FieldByName('vendaId').AsInteger, dtmVenda.cdsItensVenda) then begin
    edtVendaId.Text       :=IntToStr(oVenda.VendaId);
    lkpCliente.KeyValue   :=oVenda.ClienteId;
    edtDataVenda.Date     :=oVenda.DataVenda;
    edtValorTotal.Value   :=oVenda.TotalVenda;
  end
  else begin
    btnCancelar.Click;
    Abort ;
  end;

end;

procedure TfrmProVenda.btnApagarItemClick(Sender: TObject);
begin
  inherited;
  if lkpProduto.KeyValue=Null then  begin
    MessageDlg('Selecione o Produto a ser excluído' ,mtInformation,[mbOK],0);
    dbGridItensVenda.SetFocus;
    Abort ;
  end;

  if dtmVenda.cdsItensVenda.Locate('produtoId', lkpProduto.KeyValue, []) then begin
    dtmVenda.cdsItensVenda.Delete;
    edtTotalProduto.Value:=TotalizarVenda;
    LimparComponentesItem;
  end;

end;

procedure TfrmProVenda.btnCancelarClick(Sender: TObject);
begin
  inherited;
  LimparCds;
end;

procedure TfrmProVenda.btnClientesClick(Sender: TObject);
begin
  inherited;

  TFuncao.CriarForm(TTfrmCadCliente, oUsuarioLogado, dtmPrincipal.ConexaoDB);
  dtmVenda.QryCliente.Refresh;
end;

procedure TfrmProVenda.btnGravarClick(Sender: TObject);
begin
  inherited;
  LimparCds;
end;

procedure TfrmProVenda.btnNovoClick(Sender: TObject);
begin
  inherited;
  edtDataVenda.Date:=Date;
  lkpCliente.SetFocus;
  LimparCds;
end;

procedure TfrmProVenda.btnPesquisarClick(Sender: TObject);
var CondicaoData: string;
    TemInicio: Boolean;
    TemFim: Boolean;
    I: Integer;
    TipoCampo: TFieldType;
    NomeCampo: String;
    WhereOrAnd: String;
    CondicaoSQL: String;
    Valor: String;
begin
  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo,
     self.Name + '_' + TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
    MessageDlg('Usuário: ' + oUsuarioLogado.nome +
      ', não tem permissão de acesso', mtWarning, [mbOK], 0);
    Abort;
  end;

  Valor        := Trim(mskPesquisar.Text);
  TemInicio    := edtDataInicio.Date > 0;
  TemFim       := edtDataFinal.Date > 0;
  CondicaoSQL  := '';
  CondicaoData := '';
  NomeCampo    := '';
  TipoCampo    := ftUnknown;

  if (Valor = '') and (not TemInicio) and (not TemFim) then
  begin
    QryListagem.Close;
    QryListagem.SQL.Clear;
    QryListagem.SQL.Add(SelectOriginal);
    QryListagem.Open;
    Exit;
  end;

  if Valor <> '' then
  begin
    for I := 0 to QryListagem.FieldCount - 1 do
    begin
      if QryListagem.Fields[I].FieldName = IndiceAtual then
      begin
        TipoCampo := QryListagem.Fields[I].DataType;
        if QryListagem.Fields[I].Origin <> '' then
        begin
          if Pos('.', QryListagem.Fields[I].Origin) > 0 then
            NomeCampo := QryListagem.Fields[I].Origin
          else
            NomeCampo := QryListagem.Fields[I].Origin + '.' +
                         QryListagem.Fields[I].FieldName;
        end
        else
          NomeCampo := QryListagem.Fields[I].FieldName;
        Break;
      end;
    end;

    if NomeCampo <> '' then
    begin
      if (TipoCampo = ftString) or (TipoCampo = ftWideString) then
        CondicaoSQL := ' WHERE ' + NomeCampo + ' LIKE ' +
                       QuotedStr('%' + Valor + '%')
      else if (TipoCampo = ftInteger) or (TipoCampo = ftSmallint) then
        CondicaoSQL := ' WHERE ' + NomeCampo + ' = ' + Valor
      else if (TipoCampo = ftFloat) or (TipoCampo = ftCurrency) then
        CondicaoSQL := ' WHERE ' + NomeCampo + ' = ' +
                       StringReplace(Valor, ',', '.', [rfReplaceAll]);
    end;
  end;

  if TemInicio and TemFim then
    CondicaoData := 'vendas.dataVenda BETWEEN :dataInicio AND :dataFim'
  else if TemInicio then
    CondicaoData := 'vendas.dataVenda >= :dataInicio'
  else if TemFim then
    CondicaoData := 'vendas.dataVenda <= :dataFim';


  if CondicaoData <> '' then
  begin
    if CondicaoSQL <> '' then
      CondicaoData := ' AND ' + CondicaoData
    else
      CondicaoData := ' WHERE ' + CondicaoData;
  end;


  QryListagem.Close;
  QryListagem.SQL.Clear;
  QryListagem.SQL.Add(SelectOriginal);
  QryListagem.SQL.Add(CondicaoSQL);
  QryListagem.SQL.Add(CondicaoData);

  if TemInicio then
    QryListagem.ParamByName('dataInicio').AsDate := edtDataInicio.Date;
  if TemFim then
    QryListagem.ParamByName('dataFim').AsDate := edtDataFinal.Date;

  try
    QryListagem.Open;
  except
    on E: Exception do
    begin
      QryListagem.Close;
      QryListagem.SQL.Clear;
      QryListagem.SQL.Add(SelectOriginal);
      QryListagem.Open;
      MessageDlg('Erro na pesquisa: ' + E.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;

  mskPesquisar.Text := '';
  mskPesquisar.SetFocus;
end;

procedure TfrmProVenda.btnPesquisarClientesClick(Sender: TObject);
begin
  inherited;
  frmConClientes:=TfrmConClientes.Create(Self);

  if lkpCliente.KeyValue<>null then
    frmConClientes.aIniciarPesquisaId:=lkpCliente.KeyValue;

  frmConClientes.ShowModal;

  if frmConClientes.aRetornarIdSelecionado<>Unassigned then // Não Atribuido
    lkpCliente.KeyValue:=frmConClientes.aRetornarIdSelecionado;

  frmConClientes.Release;
end;

procedure TfrmProVenda.btnPesquisarProdutoClick(Sender: TObject);
begin
  inherited;
  frmConsultaProdutos:=TfrmConsultaProdutos.Create(Self);

  if lkpProduto.KeyValue<>null then
    frmConsultaProdutos.aIniciarPesquisaId:=lkpCliente.KeyValue;

  frmConsultaProdutos.ShowModal;

  if frmConsultaProdutos.aRetornarIdSelecionado<>Unassigned then // Não Atribuido
    lkpCliente.KeyValue:=frmConsultaProdutos.aRetornarIdSelecionado;

  frmConsultaProdutos.Release;
end;

procedure TfrmProVenda.btnAdicionarItemClick(Sender: TObject);
begin
  inherited;

  if lkpProduto.KeyValue=Null then begin
    MessageDlg('Produto é um campo obrigatório' ,mtInformation,[mbOk],0);
    lkpProduto.SetFocus;
    Abort ;
  end;

  if edtValorUnitario.Value<=0 then begin
    MessageDlg('Valor Unitário não pode ser Zero' ,mtInformation,[mbOk],0);
    edtValorUnitario.SetFocus;
    Abort ;
  end;

  if edtQuantidade.Value<=0 then begin
    MessageDlg('Quantidade não pode ser Zero' ,mtInformation,[mbOK],0);
    edtQuantidade.SetFocus;
    Abort ;
  end;

  if dtmVenda.cdsItensVenda.Locate('produtoId', lkpProduto.KeyValue, []) then begin
    MessageDlg('Este Produto já foi selecionado' ,mtInformation,[mbOK],0);
    lkpProduto.SetFocus;
    Abort ;
  end;

  edtTotalProduto.Value:=TotalizarProduto(edtValorUnitario.Value, edtQuantidade.Value);

  dtmVenda.cdsItensVenda.Append;
  dtmVenda.cdsItensVenda.FieldByName('produtoId').AsString:=lkpProduto.KeyValue;
  dtmVenda.cdsItensVenda.FieldByName('nomeProduto').AsString:=dtmVenda.QryProdutos.FieldByName('nome').AsString;
  dtmVenda.cdsItensVenda.FieldByName('quantidade').AsFloat:=edtQuantidade.Value;
  dtmVenda.cdsItensVenda.FieldByName('valorUnitario').AsFloat:=edtValorUnitario.Value;
  dtmVenda.cdsItensVenda.FieldByName('valorTotalProduto').AsFloat:=edtTotalProduto.Value;
  dtmVenda.cdsItensVenda.Post;
  edtValorTotal.Value:=TotalizarVenda;

  LimparComponentesItem;

  lkpProduto.SetFocus;

end;

procedure TfrmProVenda.LimparComponentesItem;
begin
  lkpProduto.KeyValue   :=Null;
  edtQuantidade.Value   := 0;
  edtValorUnitario.Value:= 0;
  edtTotalProduto.Value := 0;
end;

procedure TfrmProVenda.LimparCds;
begin
  dtmVenda.cdsItensVenda.First;
  while not dtmVenda.cdsItensVenda.Eof do
    dtmVenda.cdsItensVenda.Delete;
end;

procedure TfrmProVenda.edtQuantidadeExit(Sender: TObject);
begin
  inherited;
  edtTotalProduto.Value:=TotalizarProduto(edtValorUnitario.Value, edtQuantidade.Value);
end;

function  TfrmProVenda.TotalizarProduto(valorUnitario, Quantidade:Double):Double;
begin
  result :=valorUnitario * Quantidade;
end;

procedure TfrmProVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned (dtmVenda) then
    FreeAndNil(dtmVenda);

  if Assigned (oVenda) then
    FreeAndNil(oVenda);
end;

procedure TfrmProVenda.FormCreate(Sender: TObject);
begin
  inherited;
  dtmVenda:=TdtmVenda.Create(Self);

  oVenda:=TVenda.Create(dtmPrincipal.ConexaoDB);

  dtmVenda.cdsItensVenda.Open;

  IndiceAtual:='clienteId';

   SelectOriginal := QryListagem.SQL.Text;

end;

procedure TfrmProVenda.CarregarRegistrosSelecionados;
begin
  lkpProduto.KeyValue    :=dtmVenda.cdsItensVenda.FieldByName('produtoId').AsString;
  edtQuantidade.Value    :=dtmVenda.cdsItensVenda.FieldByName('quantidade').AsFloat;
  edtValorUnitario.Value :=dtmVenda.cdsItensVenda.FieldByName('valorUnitario').AsFloat;
  edtTotalProduto.Value  :=dtmVenda.cdsItensVenda.FieldByName('valorTotalProduto').AsFloat;
end;

procedure TfrmProVenda.dbGridItensVendaDblClick(Sender: TObject);
begin
  inherited;
  CarregarRegistrosSelecionados;
end;

function  TfrmProVenda.TotalizarVenda:Double;
var Valor:Double;
begin
  Valor:=0;
  dtmVenda.cdsItensVenda.First;
  while not dtmVenda.cdsItensVenda.Eof do begin
    Valor := Valor + dtmVenda.cdsItensVenda.FieldByName('valorTotalProduto').Asfloat;
    dtmVenda.cdsItensVenda.Next;
  end;
  Result:=Valor;
end;

end.
