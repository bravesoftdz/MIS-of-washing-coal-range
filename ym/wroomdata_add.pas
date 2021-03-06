{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
unit wroomdata_add;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MotherForm_add, DB, ADODB, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFrmWroomdataAdd = class(TFrmAdd)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit4: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Edit5: TEdit;
    Label13: TLabel;
    Edit6: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    DatePicker1: TDateTimePicker;
    ComboCoal: TComboBox;
    ComboTpunit: TComboBox;
    ComboTknumb: TComboBox;
    Label12: TLabel;
    procedure ComboTknumbChange(Sender: TObject);
    procedure ComboTpunitChange(Sender: TObject);
    procedure ComboTknumbSelect(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  FrmWroomdataAdd: TFrmWroomdataAdd;
 tpdate,tpcoal,tpsuttle:string;
implementation

uses wroomdata,main;

{$R *.dfm}

procedure TFrmWroomdataAdd.ComboTknumbChange(Sender: TObject);
var sqlstr:string;
begin
  inherited;
  if not ((Sender as Tcombobox).Text='') then begin

        sqlstr:='select tktrukwt from truckinfo where tknumber='''+ComboTknumb.Text+'''';
        AutoInEdit(Edit4,sqlstr);
  end;
end;

procedure TFrmWroomdataAdd.ComboTpunitChange(Sender: TObject);
var sqlstr:string;
begin
  inherited;
  if not ((Sender as Tcombobox).Text='') then begin
        sqlstr:='select tpno from tpunit where tpunitname='''+ComboTpunit.Text+'''';
        adoqryopen(ADOQtmp,sqlstr);
        label12.Caption:=ADOQtmp.Fields[0].AsString;
        sqlstr:='select tknumber from truckinfo where tkunitno='+label12.Caption;
        AutoInCombobox(ComboTknumb,sqlstr);
  end;
end;

procedure TFrmWroomdataAdd.ComboTknumbSelect(Sender: TObject);
var sqlstr:string;
begin
  inherited;
  if not ((Sender as Tcombobox).Text='') then begin
        sqlstr:='select tktrukwt from truckinfo where tknumber='''+ComboTknumb.Text+'''';
        AutoInEdit(Edit4,sqlstr);
  end;
end;

procedure TFrmWroomdataAdd.Edit5Change(Sender: TObject);
begin
  inherited;
  IF Edit5.Text='' THEN  Edit5.Text:='0';
  IF Edit4.Text='' THEN  Edit4.Text:='0';
  Edit6.Text:=CurrToStr(strtoCurr(Edit5.Text)-strtoCurr(Edit4.Text));
end;

procedure TFrmWroomdataAdd.BitBtn1Click(Sender: TObject);
var sqlstr:string;
begin
  inherited;
  IF (CheckAllNull()=False) THEN begin
    MessageBox(Handle, '资料未填写全,请检查!', '错误', MB_ICONERROR or MB_OK) ;
    ABORT
  END;
  if Frmwroomdata.laction='ADD' then begin
            sqlstr:='insert into wroomdata (tpno,tpdate,tpunit,tptrukno,tpcoal,tptrukwt,tptotalwt,tpsuttle,tpzhz,zhzpay,keydate,keyuser) values ('+
                                  Labelno.Caption+','+
                                  #39+datetostr(DatePicker1.date)+#39+','+
                                  #39+ComboTpunit.Text+#39+','+
                                  #39+ComboTknumb.Text+#39+','+
                                  #39+ComboCoal.Text+#39+','+
                                  Edit4.Text+','+
                                  Edit5.Text+','+
                                  Edit6.Text+',0,0,'+
                                  #39+g_date+#39+','+
                                  #39+curuser.Name+#39+
                                  ')';
             savelog('增加<'+ComboCoal.Text+'>煤矿'+
             datetostr(DatePicker1.date)+'磅房记录，净重'+edit6.Text+'吨',Labelno.Caption,'原煤磅房数据维护');

  end
  else if  Frmwroomdata.laction='MODIFY' then begin
           sqlstr:='update wroomdata set tpdate='+#39+datetostr(DatePicker1.date)+#39+','+
                                  'tpunit='+#39+ComboTpunit.Text+#39+','+
                                  'tptrukno='+#39+ComboTknumb.Text+#39+','+
                                  'tpcoal='+#39+ComboCoal.Text+#39+','+
                                  'tptrukwt='+Edit4.Text+','+
                                  'tptotalwt='+Edit5.Text+','+
                                  'tpsuttle='+Edit6.Text+','+
                                  'keydate='+#39+datetostr(now)+#39+','+
                                  'keyuser='+#39+curuser.Name+#39+
                                  ' where tpno='+Labelno.Caption;
             savelog('修改<'+tpcoal+'>煤矿'+
             tpdate+'磅房记录，净重'+tpsuttle+'吨',Labelno.Caption,'原煤磅房数据维护');


  end;
  adoqryexec(ADOQtmp,sqlstr);
  self.Close;

end;

procedure TFrmWroomdataAdd.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not(key in ['1','2','3','4','5','6','7','8','9','0','.']) then
  abort;
end;

procedure TFrmWroomdataAdd.FormShow(Sender: TObject);
begin
  inherited;
  if  Frmwroomdata.laction='MODIFY' then begin
      tpdate:=datetostr(DatePicker1.date);
      tpcoal:=ComboCoal.Text;
      tpsuttle:=Edit6.Text;
  end;
end;

end.
