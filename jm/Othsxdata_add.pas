unit Othsxdata_add;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MotherForm_add, DB, ADODB, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFrmOthsxdataAdd = class(TFrmAdd)
    Label12: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edtph: TEdit;
    Edttkno: TEdit;
    Edtwt: TEdit;
    DatePicker1: TDateTimePicker;
    ComboUser: TComboBox;
    Label6: TLabel;
    ComboName: TComboBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdtwtKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmOthsxdataAdd: TFrmOthsxdataAdd;
  jmxsdate,jmtpuser,jmxswt,jmxsname:string;
implementation

uses Othsxdata,main;

{$R *.dfm}

procedure TFrmOthsxdataAdd.BitBtn1Click(Sender: TObject);
var sqlstr:string;
begin
  inherited;
  IF (CheckAllNull()=False) THEN begin
    MessageBox(Handle, '资料未填写全,请检查!', '错误', MB_ICONERROR or MB_OK) ;
    ABORT
  END;

  if FrmOthXs.laction='ADD' then begin
            sqlstr:='insert into jmsxdata (jmxsno,jmxsdate,jmtpuser,jmxsph,jmxswt,jmtpnum,jmxskeydt,jmxsname,jmxsuser) values ('+
                                  Labelno.Caption+','+
                                  #39+datetostr(DatePicker1.Date)+#39+','+
                                  #39+trim(ComboUser.Text)+#39+','+
                                  #39+trim(Edtph.Text)+#39+','+
                                  #39+trim(Edtwt.Text)+#39+','+
                                  #39+trim(Edttkno.Text)+#39+','+
                                  #39+g_date+#39+','+
                                  #39+trim(ComboName.Text)+#39+','+
                                  #39+curuser.Name+#39+')';
        savelog('增加<'+trim(ComboUser.Text)+'>客户'+datetostr(DatePicker1.Date)+
        '销售'+trim(ComboName.Text)+'记录,销量'+trim(Edtwt.Text)+'吨',Labelno.Caption,'中煤/泥煤/矸石销售数据录入');

  end
  else if  FrmOthXs.laction='MODIFY' then begin
           sqlstr:='update jmsxdata set jmxsdate='+#39+datetostr(DatePicker1.Date)+#39+','+
                                  'jmtpuser='+#39+trim(ComboUser.Text)+#39+','+
                                  'jmxsph='+#39+trim(Edtph.Text)+#39+','+
                                  'jmxswt='+#39+trim(Edtwt.Text)+#39+','+
                                  'jmtpnum='+#39+trim(Edttkno.Text)+#39+ ','+
                                  'jmxskeydt='+#39+datetostr(now)+#39+','+
                                  'jmxsname='+#39+trim(ComboName.Text)+#39+','+
                                  'jmxsuser='+#39+curuser.Name+#39+
                                  ' where jmxsno='+Labelno.Caption
                                  +' and (jmxsname=''中煤'' or jmxsname=''泥煤'' or jmxsname=''矸石'')';
           savelog('修改<'+jmtpuser+'>客户'+jmxsdate+
        '销售'+jmxsname+'记录,'+jmxswt+'吨',Labelno.Caption,'中煤/泥煤/矸石销售数据录入');

  end;
  adoqryexec(ADOQtmp,sqlstr);
  self.Close;

end;

procedure TFrmOthsxdataAdd.FormShow(Sender: TObject);
begin
  inherited;
  if  FrmOthXs.laction='MODIFY' then begin
  jmxsdate:=datetostr(DatePicker1.Date);
  jmtpuser:=trim(ComboUser.Text);
  jmxswt:=trim(Edtwt.Text);
  jmxsname:=trim(ComboName.Text);
  end;
end;

procedure TFrmOthsxdataAdd.EdtwtKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
    if not(key in ['1','2','3','4','5','6','7','8','9','0','.',#30]) then
    abort;
end;

end.
