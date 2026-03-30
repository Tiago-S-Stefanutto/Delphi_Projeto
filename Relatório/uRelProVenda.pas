unit uRelProVenda;

interface

uses
Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDTMConexao, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Datasnap.DBClient, RLReport, RLFilters, RLPDFFilter, RLXLSFilter, RLXLSXFilter;

type
  TfrmRelProVenda = class(TForm)
    Relatorio: TRLReport;
    RLBand1: TRLBand;
    rlbRodaPe: TRLBand;
    dtsVenda: TDataSource;
    RLPDFFilter1: TRLPDFFilter;
    RLXLSXFilter1: TRLXLSXFilter;
    RLXLSFilter1: TRLXLSFilter;
    RLDraw1: TRLDraw;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    RLLabel1: TRLLabel;
    RLSystemInfo3: TRLSystemInfo;
    RLLabel2: TRLLabel;
    RLDraw2: TRLDraw;
    RLBand6: TRLBand;
    RLLabel4: TRLLabel;
    RLDBResult2: TRLDBResult;
    dtsVendaItens: TDataSource;
    RLDraw3: TRLDraw;
    QryVendaItens: TFDQuery;
    QryVenda: TFDQuery;
    RLGroup1: TRLGroup;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLSubDetail1: TRLSubDetail;
    RLBand4: TRLBand;
    RLBand5: TRLBand;
    QryVendaItensvendaId: TIntegerField;
    QryVendaItensprodutoId: TIntegerField;
    QryVendaItensNome: TStringField;
    QryVendaItensquantidade: TFMTBCDField;
    QryVendaItensvalorUnitario: TFMTBCDField;
    QryVendaItenstotalProduto: TFMTBCDField;
    QryVendavendaId: TFDAutoIncField;
    QryVendaClienteId: TIntegerField;
    QryVendanome: TStringField;
    QryVendadataVenda: TSQLTimeStampField;
    QryVendatotalVenda: TBCDField;
    RLLabel3: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLLabel7: TRLLabel;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLDBText5: TRLDBText;
    RLDBText6: TRLDBText;
    RLDBText8: TRLDBText;
    RLDBText7: TRLDBText;
    RLDBText9: TRLDBText;
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRelProVenda: TfrmRelProVenda;

implementation

{$R *.dfm}

procedure TfrmRelProVenda.FormDestroy(Sender: TObject);
begin
     QryVenda.Close;
     QryVendaItens.Close;
end;

end.
