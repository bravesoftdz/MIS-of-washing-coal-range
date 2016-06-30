unit Othsxdata;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MotherForm, dxExEdtr, DB, ADODB, dxCntner, dxTL, dxDBCtrl,
  dxDBGrid, StdCtrls, ExtCtrls, dxDBTLCl, dxGrClms, ComCtrls;

type
  TFrmOthXs = class(TFrmMather)
    dxDBGrid1jmxsno: TdxDBGridMaskColumn;
    dxDBGrid1jmtpnum: TdxDBGridMaskColumn;
    dxDBGrid1jmxsname: TdxDBGridMaskColumn;
    dxDBGrid1jmtpuser: TdxDBGridMaskColumn;
    dxDBGrid1jmxswt: TdxDBGridMaskColumn;
    dxDBGrid1jmxsdate: TdxDBGridDateColumn;
    dxDBGrid1jmxsph: TdxDBGridMaskColumn;
    dxDBGrid1jmxskeydt: TdxDBGridDateColumn;
    dxDBGrid1jmxsuser: TdxDBGridMaskColumn;
    dxDBGrid1jmxssign: TdxDBGridCheckColumn;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function l_init:boolean;
  end;

var
  FrmOthXs: TFrmOthXs;

implementation
uses Othsxdata_add;
{$R *.dfm}
function TFrmOthXs.l_init:boolean;
var sqlstr:string;
begin
  sqlstr:='select * from jmsxdata where jmxsname=''��ú'' or jmxsname=''��ú'' or jmxsname=''�ʯ''';
  adoqryopen(ADOQuery1,sqlstr);
end;
procedure TFrmOthXs.Button1Click(Sender: TObject);
begin
  inherited;
  FrmOthsxdataAdd:=TFrmOthsxdataAdd.Create(self);
  FrmOthsxdataAdd.Labelno.Caption:=getmax('jmsxdata','jmxsno',' jmxsname=''��ú'' or jmxsname=''��ú'' or jmxsname=''�ʯ''');
  FrmOthsxdataAdd.AutoInCombobox(FrmOthsxdataAdd.ComboUser,'select CustomName from customs');
  FrmOthsxdataAdd.DatePicker1.Date:=now();
  FrmOthsxdataAdd.ShowModal;
  l_init
end;

procedure TFrmOthXs.Button3Click(Sender: TObject);
begin
  inherited;
  WITH dxDBGrid1 DO
  BEGIN
    IF (FocusedNode <> nil) AND (SelectedCount = 1) AND
       FocusedNode.HasChildren THEN Exit;
    IF SelectedCount > 1 THEN begin
         savelog('ɾ��<'+ADOQuery1.fieldbyname('jmtpuser').AsString+'>�ͻ�'+ADOQuery1.fieldbyname('jmxsdate').AsString+
        '����'+ADOQuery1.fieldbyname('jmxsname').AsString+'��¼',ADOQuery1.fieldbyname('jmsxno').AsString,'��ú/��ú/�ʯ��������¼��');
        DeleteSelection
    end
    ELSE
      IF FocusedNode <> nil THEN begin
         savelog('ɾ��<'+ADOQuery1.fieldbyname('jmtpuser').AsString+'>�ͻ�'+ADOQuery1.fieldbyname('jmxsdate').AsString+
        '����'+ADOQuery1.fieldbyname('jmxsname').AsString+'��¼,����'+ADOQuery1.fieldbyname('jmxswt').AsString+'��',ADOQuery1.fieldbyname('jmsxno').AsString,'��ú/��ú/�ʯ��������¼��');

        TdxDBGridNode(FocusedNode).Delete;
      end;
  END;
end;

procedure TFrmOthXs.Button2Click(Sender: TObject);
begin
  inherited;
  FrmOthsxdataAdd:=TFrmOthsxdataAdd.Create(self);
  FrmOthsxdataAdd.AutoInCombobox(FrmOthsxdataAdd.ComboUser,'select CustomName from customs');
  FrmOthsxdataAdd.Labelno.Caption:=ADOQuery1.fieldbyname('jmxsno').AsString;
  FrmOthsxdataAdd.DatePicker1.Date:=ADOQuery1.fieldbyname('jmxsdate').AsDateTime;
  FrmOthsxdataAdd.ComboUser.Text:=ADOQuery1.fieldbyname('jmtpuser').AsString;
  FrmOthsxdataAdd.Edtph.Text:=ADOQuery1.fieldbyname('jmxsph').AsString;
  FrmOthsxdataAdd.Edtwt.Text:=ADOQuery1.fieldbyname('jmxswt').AsString;
  FrmOthsxdataAdd.Edttkno.text:=ADOQuery1.fieldbyname('jmtpnum').AsString;
  FrmOthsxdataAdd.ComboName.text:=ADOQuery1.fieldbyname('jmxsname').AsString;
  FrmOthsxdataAdd.ShowModal;
  l_init
end;

procedure TFrmOthXs.FormShow(Sender: TObject);
begin
  inherited;
l_init
end;

end.
