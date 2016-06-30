unit UserAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MotherForm_add, DB, ADODB, StdCtrls, Buttons, ExtCtrls;

type
  TFrmUserAdd = class(TFrmAdd)
    EdtUser: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edtpwd: TEdit;
    Label3: TLabel;
    Edtpwd2: TEdit;
    Label4: TLabel;
    ComboUG: TComboBox;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUserAdd: TFrmUserAdd;

implementation

uses user;

{$R *.dfm}

procedure TFrmUserAdd.BitBtn1Click(Sender: TObject);
var sqlstr:string;      
begin
  inherited;
  IF EdtUser.Text='' THEN begin
    MessageBox(Handle, '�û���δ��д!', '��ʾ', MB_ICONERROR or MB_OK) ;
    ABORT
  END;
  IF Edtpwd.Text='' THEN  begin
    MessageBox(Handle, '������δ��д!', '��ʾ', MB_ICONERROR or MB_OK) ;
    ABORT
  END;
  IF ComboUG.Text='' THEN  begin
    MessageBox(Handle, '��ɫ��δѡ��!', '��ʾ', MB_ICONERROR or MB_OK) ;
    ABORT
  END;
  if Edtpwd.Text <> Edtpwd2.Text then begin
        MessageBox(Handle, '2����������벻��ȷ,����������!', '��ʾ', MB_ICONERROR or MB_OK) ;
        ABORT
  end;
  if FrmUser.laction='ADD' then begin
  FrmUser.dxDBGrid1.DataSource.DataSet.First;
      while not FrmUser.dxDBGrid1.DataSource.DataSet.Eof do begin
           if FrmUser.dxDBGrid1.DataSource.DataSet.Fields[1].AsString = EdtUser.Text then begin
              MessageBox(Handle, '���û��Ѵ���,����������!', '��ʾ', MB_ICONERROR or MB_OK) ;
              ABORT
           end;
           FrmUser.dxDBGrid1.DataSource.DataSet.next;
      end;
            sqlstr:='insert into userlist (userno,userid,userpwd,usergroup) values ('+
                                  Labelno.Caption+','+
                                  #39+EdtUser.Text+#39+','+
                                  #39+Edtpwd.Text+#39+','+
                                  #39+ComboUG.Text+#39+')';
  end
  else if  FrmUser.laction='MODIFY' then begin
        sqlstr:='update userlist set userid='+#39+EdtUser.Text+#39+','+
                                'userpwd='+#39+Edtpwd.Text+#39+','+
                                'usergroup='+#39+ComboUG.Text+#39+
                                ' where userno='+Labelno.Caption;
  end;
  adoqryexec(ADOQtmp,sqlstr);
  self.Close;
end;

end.
