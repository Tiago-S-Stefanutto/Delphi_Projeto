unit uCadCategorias;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.ComCtrls, cCadCategoria, uDTMConexao, uEnum;

type
  TfrmCadCategorias = class(TfrmTelaHeranca)
    F1QryListagemcategoriasId: TFDAutoIncField;
    F2QryListagemdescricao: TStringField;
    edtDescricao: TLabeledEdit;
    edtCategoriasId: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAlterarClick(Sender: TObject);
  private
    { Private declarations }
    oCategoria:TCategoria;
        function Apagar:Boolean; override;
    function Gravar(EstadoDoCadastro: TEstadoDoCadastro):Boolean; override;
    { Public declarations }
  end;

var
  frmCadCategorias: TfrmCadCategorias;

implementation

{$R *.dfm}

{$REGION 'Override'}

function TfrmCadCategorias.Apagar: Boolean;
begin
  if oCategoria .Selecionar(QryListagem .FieldByName('categoriasId').AsInteger) then begin
  oCategoria.codigo := QryListagem.FieldByName('categoriasId').AsInteger;
  Result := oCategoria.Apagar;
  end;
end;

function TfrmCadCategorias.Gravar(EstadoDoCadastro: TEstadoDoCadastro): Boolean;
begin

  if edtCategoriasId  .Text <>EmptyStr  then
  oCategoria  .codigo := StrToInt(edtCategoriasId.Text)
  else
    oCategoria.codigo :=0;

    oCategoria  .descricao  :=edtDescricao  .Text;

  if (EstadoDoCadastro=ecInserir) then
    Result  := oCategoria.Inserir
  else if (EstadoDoCadastro=ecAlterar) then
    Result := oCategoria.Atualizar
  else
    Result:=False;
end;
{$ENDREGION}

procedure TfrmCadCategorias.btnAlterarClick(Sender: TObject);
begin

  if oCategoria .Selecionar(QryListagem .FieldByName('categoriasId').AsInteger) then begin
    edtCategoriasId .Text := IntToStr(oCategoria  .codigo);
    edtDescricao  .Text := oCategoria.descricao;
  end
  else begin
    btnCancelar.Click;
    Abort
  end;

  inherited;

end;

procedure TfrmCadCategorias.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned(oCategoria) then
  FreeAndNil(oCategoria);
end;

procedure TfrmCadCategorias.FormCreate(Sender: TObject);
begin
  inherited;
  oCategoria  := TCategoria .Create(dtmPrincipal.ConexaoDB);

  IndiceAtual:='categoriasId';
end;

end.
