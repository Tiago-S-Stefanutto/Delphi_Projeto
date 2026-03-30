unit uFrmAtualizaDB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, RxGIF, Vcl.Imaging.GIFImg,
  RxAnimate, RxGIFCtrl;

type
  TfrmAtualizaDB = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Image1: TImage;
    lblAtualizarBancodeDados: TLabel;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAtualizaDB: TfrmAtualizaDB;

implementation

{$R *.dfm}

end.
