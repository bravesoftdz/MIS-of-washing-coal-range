unit customs_add;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MotherForm_add, DB, ADODB, StdCtrls, Buttons, ExtCtrls;

type
  TFrmCustomsAdd = class(TFrmAdd)
    Label1: TLabel;
    EdtName: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCustomsAdd: TFrmCustomsAdd;
  CustomName:string;
implementation
uses customs,main;
{$R *.dfm}

procedure TFrmCustomsAdd.BitBtn1Click(Sender: TObject);
var sqlstr:string;
begin
  inherited;
  IF (CheckAllNull()=False) THEN begin
    MessageBox(Handle, '����δ��дȫ,����!', '����', MB_ICONERROR or MB_OK) ;
    ABORT
  END;

  if FrmCustoms.laction='ADD' then begin
            sqlstr:='insert into customs (CustomNo,CustomName,keydate,keyuser) values ('+
                                  Labelno.Caption+','+
                                  #39+trim(EdtName.Text)+#39+','+
                                  #39+g_date+#39+','+
                                  #39+curuser.Name+#39+
                                  ')';
            savelog('����<'+trim(EdtName.Text)+'>'+
            '�ͻ���Ϣ��¼',Labelno.Caption,'�ͻ���λά��');
  end
  else if  FrmCustoms.laction='MODIFY' then begin
           sqlstr:='update customs set CustomName='+#39+trim(EdtName.Text)+#39+
                                ',keydate='+#39+datetostr(now)+#39+
                                  ',keyuser='+#39+curuser.Name+#39+
                                  ' where CustomNo='+Labelno.Caption;
           savelog('�޸�<'+CustomName+'>'+
            '�ͻ���Ϣ��¼',Labelno.Caption,'�ͻ���λά��');
  end;
  adoqryexec(ADOQtmp,sqlstr);
  self.Close;

end;

procedure TFrmCustomsAdd.FormShow(Sender: TObject);
begin
  inherited;
   if  FrmCustoms.laction='MODIFY' then begin
        CustomName:= trim(EdtName.Text);
   end;
end;

end.
