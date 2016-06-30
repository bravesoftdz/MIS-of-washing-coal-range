unit Login1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,adodb,ExtCtrls,ComCtrls,MotherForm;

type
  TFrmLogin = class(TForm)
    BitBtnLogin: TBitBtn;
    BitBtnCanel: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    EdtName: TEdit;
    EdtPwd: TEdit;
    procedure BitBtnLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtnCanelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;
implementation

uses MAIN;

{$R *.dfm}

procedure TFrmLogin.BitBtnLoginClick(Sender: TObject);
var tmpado:Tadoquery;
    sqlstr:string;
begin
    sqlstr:='select  *  from userlist where  userid='''+trim(EdtName.Text)+''' ';
    tmpado:=Tadoquery.Create(application);
    FrmMather.adoqryopen(tmpado,sqlstr);
    if tmpado.recordcount=0 then begin
      MessageBox(Handle, pchar('��½�ʺ�'''+EdtName.text+'''������'), '����', MB_ICONERROR or MB_OK) ;
      abort;
    end;
    sqlstr:='select * from userlist where userid='''+trim(EdtName.Text)+''' and userpwd='''+EdtPwd.Text+'''';
    FrmMather.adoqryopen(tmpado,sqlstr);
    if tmpado.recordcount=0 then begin
      MessageBox(Handle, '��½���벻��ȷ', '����', MB_ICONERROR or MB_OK) ;
      abort;
    end;
    curuser.Name:=EdtName.text;
    curuser.usergroup:=tmpado.fieldbyname('usergroup').Value;
    FrmMain.StatusBar1.Panels[1].Text:='��ǰ�û���:  '+curuser.Name+',   ��ɫ��'+curuser.usergroup;
    tmpado.free;
    FrmMain.inittree(EdtName.Text,FrmMain.TreViNagter);
    FrmMain.show;
    self.Free;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  //  FrmMather.initdb;
    EdtName.SetFocus;
end;

procedure TFrmLogin.BitBtnCanelClick(Sender: TObject);
begin
  application.Terminate
end;

end.
