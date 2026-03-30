unit cAtualizacaoCampoMSSQL;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ComCtrls, RxToolEdit, cAtualizacaoBandoDeDados;

type
  TAtualizacaoCampoMSSQL = class(TAtualizaBancoDeDados)

  private
    function  CampoExisteNaTabela(aNomeTabela, aCampo: string): Boolean;
    procedure Versao1;

  protected

  public
    constructor Create(aConexao:TFDConnection);
    destructor Destroy; override;

  end;

implementation

{ TAtualizacaoCampoMSSQL }

function TAtualizacaoCampoMSSQL.CampoExisteNaTabela(aNomeTabela, aCampo: string): Boolean;
var Qry:TFDQuery;
begin
  try
    Result:=False;
    Qry:=TFDQuery.Create(nil);
    Qry.Connection:=ConexaoDB;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT COUNT (COLUMN_NAME)AS Qtde  ');
    Qry.SQL.Add('  FROM INFORMATION_SCHEMA.COLUMNS  ');
    Qry.SQL.Add(' WHERE LOWER(TABLE_NAME) = :Tabela  ');
    Qry.SQL.Add('  AND LOWER(COLUMN_NAME) = :Campo  ');
    Qry.ParamByName('Tabela').AsString := LowerCase(aNomeTabela);
Qry.ParamByName('Campo').AsString := LowerCase(aCampo);
    Qry.Open;

    if Qry.FieldByName('Qtde').AsInteger>0 then
      Result:=True;
  finally
    Qry.Close;
    if Assigned (Qry) then
      FreeAndNil(Qry);
  end;
end;

procedure TAtualizacaoCampoMSSQL.Versao1;
begin
  if not CampoExisteNaTabela('produtos','foto') then
  begin
    ExecutaDiretoBancoDeDados('alter table produtos add foto varbinary(max) ');
  end;
end;

constructor TAtualizacaoCampoMSSQL.Create(aConexao: TFDConnection);
begin
  ConexaoDB := aConexao;

  Versao1;
end;

destructor TAtualizacaoCampoMSSQL.Destroy;
begin

  inherited;
end;



end.
