unit uTelaHeranca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ComCtrls, Vcl.ExtCtrls, uDTMConexao, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uEnum, cUsuarioLogado;

type
  TfrmTelaHeranca = class(TForm)
    pgcPrincipal: TPageControl;
    pnlRodaPe: TPanel;
    TabListagem: TTabSheet;
    tabManutencao: TTabSheet;
    Panel1: TPanel;
    mskPesquisar: TMaskEdit;
    btnPesquisar: TBitBtn;
    grdListagem: TDBGrid;
    btnNovo: TBitBtn;
    btnAlterar: TBitBtn;
    btnCancelar: TBitBtn;
    btnGravar: TBitBtn;
    btnApagar: TBitBtn;
    btnFechar: TBitBtn;
    btnNavigator: TDBNavigator;
    dtsListagem: TDataSource;
    QryListagem: TFDQuery;
    lblIndice: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdListagemTitleClick(Column: TColumn);
    procedure mskPesquisarChange(Sender: TObject);
    procedure grdListagemDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPesquisarClick(Sender: TObject);
  private
    { Private declarations }
    SelectOriginal:string;
    procedure ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar:TBitBtn; btnNavigator:TDBNavigator; pgcPrincipal:TPageControl; Flag:Boolean);
    procedure ControlarIndiceTab(pgcPrincipal: TpageControl; Indice: Integer);
    function RetomarCampoTraduzido(Campo: string): string;
    procedure ExibirIndiceLabel(Campo: string; aLabel: TLabel);
    function ExisteCampoObrigatorio: boolean;
    procedure DesabilitarEditPK;
    procedure LimparEdits;
  public
    { Public declarations }
    IndiceAtual:string;
    EstadoDoCadastro:TEstadoDoCadastro;
    function Apagar:Boolean; virtual;
    function Gravar(EstadoDoCadastro: TEstadoDoCadastro):Boolean; virtual;
    procedure BloqueiaCTRL_DEL_DBGrid(var Key: Word; Shift: TShiftState);
  end;

var
  frmTelaHeranca: TfrmTelaHeranca;

implementation

uses uPrincipal;

{$R *.dfm}

//Procedimento de controle de tela
{$REGION 'Observações'}
//Tag: 1 - Chave Primária - pk
//Tag: 2 - Campo Obrigatórios
 {$ENDREGION}

{$REGION 'Funções e Procedures'}

procedure TfrmTelaHeranca.ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar:TBitBtn; btnNavigator:TDBNavigator; pgcPrincipal:TPageControl; Flag:Boolean);
begin
   btnNovo.Enabled   :=Flag;
   btnAlterar.Enabled   :=Flag;
   btnApagar.Enabled  := Flag;
   btnNavigator.Enabled :=Flag;
   pgcPrincipal.Pages [0].TabVisible  := Flag;
   btnCancelar.Enabled  := not(Flag);
   btnGravar.Enabled  := not(Flag);

end;

procedure TfrmTelaHeranca.ControlarIndiceTab (pgcPrincipal: TpageControl; Indice: Integer);
begin
    if (pgcPrincipal.Pages[Indice].TabVisible) then
    pgcPrincipal.TabIndex:=Indice;
end;

function  TfrmTelaHeranca.RetomarCampoTraduzido(Campo:string):string;
var i:Integer;
begin
  for i := 0 to QryListagem.Fields.Count -1 do begin
    if LowerCase(QryListagem.Fields[i].FieldName)=LowerCase(Campo) then begin
      Result:= QryListagem.Fields[i].DisplayLabel;
      Break;
    end;
  end;
end;




procedure TfrmTelaHeranca.ExibirIndiceLabel(Campo:string; aLabel:TLabel);
begin
  aLabel.Caption:=RetomarCampoTraduzido(Campo);
end;

function  TfrmTelaHeranca.ExisteCampoObrigatorio:boolean;
var i:Integer;
begin
  Result :=False;
  for i := 0 to ComponentCount -1 do begin
    if (Components[i] is TLabeledEdit) then begin
        if ((TLabeledEdit(Components[i]).Tag = 2) and (TLabeledEdit(Components[i]).Text = EmptyStr)) then begin
         MessageDlg(TLabeledEdit(Components[i]).EditLabel.Caption + ' é um campo obrigatório',mtInformation,[mbOK],0);
         TLabeledEdit(Components[i]).SetFocus;

         Result := True;
         Break ;
      end
     end;
   end;
end;

procedure TfrmTelaHeranca.DesabilitarEditPK;
var i:Integer;
begin
  for i := 0 to ComponentCount -1 do begin
    if (Components[i] is TLabeledEdit) then begin
        if (TLabeledEdit(Components[i]).Tag = 1) then begin
          TLabeledEdit(Components[i]).Enabled:=False;
        end;
    end;
  end;
end;

procedure TfrmTelaHeranca.LimparEdits;
var i:Integer;
begin
  for i := 0 to ComponentCount -1 do begin
    if (Components[i] is TLabeledEdit) then
          (TLabeledEdit(Components[i])).Text:=EmptyStr
    else if(Components[i] is TEdit) then
      TEdit(Components[i]).Text:='';
  end;
end;



{$ENDREGION}

{$REGION 'Métodos Virtuais'}
function TfrmTelaHeranca.Apagar: Boolean;
begin
  ShowMessage('Deletado');
  Result := True;
end;

function  TfrmTelaHeranca.Gravar(EstadoDoCadastro:TEstadoDoCadastro) : Boolean;
begin
  if (EstadoDoCadastro=ecInserir) then
      ShowMessage('Inserir')
  else if (EstadoDoCadastro=ecAlterar) then
      ShowMessage('Alterado');
      Result := True;
end;

{$ENDREGION}

  procedure TfrmTelaHeranca.btnNovoClick(Sender: TObject);
begin

  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
     MessageDlg('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
     Abort;
  end;

  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, False);
  EstadoDoCadastro:=ecInserir;
  LimparEdits;
end;

procedure TfrmTelaHeranca.btnAlterarClick(Sender: TObject);
begin

  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
     MessageDlg('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
     Abort;
  end;

  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, False);
  EstadoDoCadastro:=ecAlterar;
end;

procedure TfrmTelaHeranca.btnApagarClick(Sender: TObject);
begin

  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
     MessageDlg('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
     Abort;
  end;

  try
    if (Apagar)  then begin
      ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, True);
      ControlarIndiceTab(pgcPrincipal, 0);
      LimparEdits;
      QryListagem.Refresh;
    end
    else  begin
      MessageDlg('Erro na Exclusão', mtError, [mbOK], 0);
    end;
  finally
  EstadoDoCadastro:=ecNenhum;
  end;
end;

procedure TfrmTelaHeranca.btnCancelarClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, True);
  ControlarIndiceTab(pgcPrincipal, 0);
  EstadoDoCadastro:=ecNenhum;
  LimparEdits;
end;

procedure TfrmTelaHeranca.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTelaHeranca.btnGravarClick(Sender: TObject);
begin

  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo, self.Name+'_'+TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
     MessageDlg('Usuário: '+oUsuarioLogado.nome +', não tem permissão de acesso',mtWarning,[mbOK],0);
     Abort;
  end;

  if (ExisteCampoObrigatorio) then
  Abort ;

  try
    if Gravar(EstadoDoCadastro) then begin
     ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, True);
     ControlarIndiceTab(pgcPrincipal, 0);
     EstadoDoCadastro:=ecNenhum;
     LimparEdits;
     QryListagem.Refresh;
    end
    else begin
     MessageDlg('Erro na gravação', mtWarning, [mbOK],0)
    end;
 finally
  end;

end;

procedure TfrmTelaHeranca.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  QryListagem.Close;
end;

procedure TfrmTelaHeranca.FormCreate(Sender: TObject);
begin
  QryListagem.Connection:=dtmPrincipal.ConexaoDB;
  dtsListagem.DataSet:=QryListagem;
  grdListagem.DataSource:=dtsListagem;
  grdListagem.Options:=[dgTitles,dgIndicator,dgColumnResize,dgColLines,dgRowLines,dgTabs,dgRowSelect,dgAlwaysShowSelection,dgCancelOnExit,dgTitleClick,dgTitleHotTrack]
end;

procedure TfrmTelaHeranca.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BloqueiaCTRL_DEL_DBGrid(Key,Shift);
end;

procedure TfrmTelaHeranca.FormShow(Sender: TObject);
begin
  if (QryListagem.SQL.Text<>EmptyStr) then begin
      dtsListagem.DataSet:=QryListagem;
      ExibirIndiceLabel(IndiceAtual, lblIndice);
      SelectOriginal:=QryListagem.SQL.Text;
      QryListagem.Open;
  end;
  ControlarIndiceTab(pgcPrincipal, 0);
  DesabilitarEditPK;
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar, btnNavigator, pgcPrincipal, True);
end;

procedure TfrmTelaHeranca.grdListagemDblClick(Sender: TObject);
begin
  btnAlterar.Click;
end;

procedure TfrmTelaHeranca.grdListagemTitleClick(Column: TColumn);
begin
  IndiceAtual := Column.FieldName;
  QryListagem.IndexFieldNames:=IndiceAtual;
  ExibirIndiceLabel(IndiceAtual, lblIndice);
end;

procedure TfrmTelaHeranca.mskPesquisarChange(Sender: TObject);
begin
  if Trim(TMaskEdit(Sender).Text) = '' then
    Exit;

  QryListagem.Locate(IndiceAtual, TMaskEdit(Sender).Text, [loPartialKey]);
end;

procedure TfrmTelaHeranca.btnPesquisarClick(Sender: TObject);
var
  I: Integer;
  TipoCampo: TFieldType;
  NomeCampo: String;
  WhereOrAnd: String;
  CondicaoSQL: String;
  Valor: String;
begin
  if not TUsuarioLogado.TenhoAcesso(oUsuarioLogado.codigo,
     Self.Name + '_' + TBitBtn(Sender).Name, DtmPrincipal.ConexaoDB) then
  begin
    MessageDlg('Usuário: ' + oUsuarioLogado.nome +
      ', não tem permissão de acesso', mtWarning, [mbOK], 0);
    Abort;
  end;

  Valor := Trim(mskPesquisar.Text);

  if Valor = '' then
  begin
    QryListagem.Close;
    QryListagem.SQL.Text := SelectOriginal;
    QryListagem.Open;
    Exit;
  end;

  NomeCampo := '';
  TipoCampo := ftUnknown;

  for I := 0 to QryListagem.FieldCount - 1 do
  begin
    if SameText(QryListagem.Fields[I].FieldName, IndiceAtual) then
    begin
      TipoCampo := QryListagem.Fields[I].DataType;
      NomeCampo := QryListagem.Fields[I].FieldName;
      Break;
    end;
  end;

  if NomeCampo = '' then Exit;

  if Pos('where', LowerCase(SelectOriginal)) > 0 then
    WhereOrAnd := ' AND '
  else
    WhereOrAnd := ' WHERE ';

  QryListagem.Close;
  QryListagem.SQL.Clear;
  QryListagem.SQL.Add(SelectOriginal);

  case TipoCampo of
    ftString, ftWideString:
      begin
        QryListagem.SQL.Add(WhereOrAnd + NomeCampo + ' LIKE :VALOR');
        QryListagem.ParamByName('VALOR').AsString := '%' + Valor + '%';
      end;

    ftInteger, ftSmallint, ftAutoInc:
      begin
        Valor := Trim(Valor);

        if not TryStrToInt(Valor, I) then
        begin
          MessageDlg('Digite um número válido', mtWarning, [mbOK], 0);
          Exit;
        end;

        QryListagem.SQL.Add(WhereOrAnd + NomeCampo + ' = :VALOR');
        QryListagem.ParamByName('VALOR').AsInteger := I;
      end;

    ftFloat, ftCurrency:
      begin
        Valor := StringReplace(Valor, ',', '.', [rfReplaceAll]);
        QryListagem.SQL.Add(WhereOrAnd + NomeCampo + ' = :VALOR');
        QryListagem.ParamByName('VALOR').AsFloat := StrToFloat(Valor);
      end;

    ftDate, ftDateTime:
      begin
        QryListagem.SQL.Add(WhereOrAnd + NomeCampo + ' = :VALOR');
        QryListagem.ParamByName('VALOR').AsDateTime := StrToDate(Valor);
      end;
  end;

  QryListagem.Open;

  mskPesquisar.Clear;
  mskPesquisar.SetFocus;
end;

procedure TfrmTelaHeranca.BloqueiaCTRL_DEL_DBGrid(var Key:Word; Shift: TShiftState);
begin
  //Bloqueia o ctrl del
  if (Shift = [ssCtrl]) and (Key = 46) then
    key:=0;
end;

end.
