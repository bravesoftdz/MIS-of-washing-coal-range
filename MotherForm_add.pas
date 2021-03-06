unit MotherForm_add;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, Buttons, ExtCtrls,dbconn;

type
  TFrmAdd = class(TForm)
    ADOQuery1: TADOQuery;
    ADOQtmp: TADOQuery;
    Labelno: TLabel;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    g_date:string;
   function adoqryopen(adoquery1:Tadoquery;sqlstr:string):boolean;
   function adoqryexec(adoquery1:Tadoquery;sqlstr:string):boolean;
   function AutoInCombobox(var combox:Tcombobox;sqlstr:string ):boolean;
   function AutoInEdit(var PEdit:TEdit;sqlstr:string ):boolean;
   function CheckAllNull():boolean;
   function CheckExist(tabel1,condition:string):boolean;
   function savelog(logcntet,logvalue,logproname:string):boolean;
   function g_init:boolean;
  end;

var
  FrmAdd: TFrmAdd;

implementation
uses MAIN,MotherForm;

{$R *.dfm}
function TFrmAdd.g_init:boolean;
var tmpado:Tadoquery;
    sqlstr:string;
begin
//获取服务器时间
   tmpado:=Tadoquery.Create(nil);
   sqlstr:='select getdate() as serverDate';
   adoqryopen(tmpado,sqlstr);
   g_date:=Formatdatetime('yyyy-mm-dd',tmpado.fieldbyname('serverDate').AsDateTime);
   tmpado.Free;
end;
function TFrmAdd.CheckExist(tabel1,condition:string):boolean;
var sqlstr:string;
begin
  result:=false;
  sqlstr:='select count(*) from '+tabel1+' where '+condition;
  adoqryopen(ADOQtmp,sqlstr);
  if ADOQtmp.Fields[0].AsInteger>0 then result:=true;
end;
function TFrmAdd.CheckAllNull():boolean;
var i:integer;
begin
   result:=true;
   FOR i:=0 to self.ControlCount-1 do begin
       if (self.Controls[i].ClassName='TEdit') and ((self.Controls[i] as TEdit).Text='') then begin
     //   showmessage( self.Controls[i].Name);
        result:=False;
       end;
       if (self.Controls[i].ClassName='TCombobox') and ((self.Controls[i] as TCombobox).Text='') then
       begin
       // showmessage( self.Controls[i].Name);
        result:=False;
       end;
   end;
end;
function TFrmAdd.AutoInEdit(var PEdit:TEdit;sqlstr:string ):boolean;
begin
    adoqryopen(ADOQtmp,sqlstr);
    while not ADOQtmp.Eof do begin
        PEdit.Text:=ADOQtmp.Fields[0].AsString;
        ADOQtmp.Next;
    end;
end;
{
自填充COMBOBOX
combox:要填充的COMBOBOX
sqlstr:用于添充的sql语句，只填充第一个字段
}
function TFrmAdd.AutoInCombobox(var combox:Tcombobox;sqlstr:string ):boolean;
begin
    combox.Clear;
    adoqryopen(ADOQtmp,sqlstr);
    while not ADOQtmp.Eof do begin
        combox.Items.Add(ADOQtmp.Fields[0].AsString);
        combox.Text:=ADOQtmp.Fields[0].AsString;
        ADOQtmp.Next;
    end;
end;
function TFrmAdd.adoqryopen(adoquery1:Tadoquery;sqlstr:string):boolean;
begin
    adoquery1.Connection:=DataModule1.ADOConnection1;
    adoquery1.SQL.Text:=sqlstr;
    adoquery1.Open;
end;
function TFrmAdd.adoqryexec(adoquery1:Tadoquery;sqlstr:string):boolean;
begin
    adoquery1.Connection:=DataModule1.ADOConnection1;
    adoquery1.SQL.Text:=sqlstr;
    adoquery1.ExecSQL;
end;
procedure TFrmAdd.BitBtn2Click(Sender: TObject);
begin
  self.Close;
end;
function TFrmAdd.savelog(logcntet,logvalue,logproname:string):boolean;
var sqlstr:string;
var tmpado:Tadoquery;
begin
   tmpado:=Tadoquery.Create(nil);
   sqlstr:='insert into b_log(logno,logcntet,logvalue,logproname,logkeydate,loguser) values ('+
                       FrmMather.getmax('b_log','logno')+','+
                       #39+logcntet+#39+','+
                       #39+logvalue+#39+','+
                       #39+logproname+#39+','+
                       #39+trim(g_date)+#39+','+
                       #39+curuser.Name+#39+')';
   adoqryexec(tmpado,sqlstr);
end;
procedure TFrmAdd.FormShow(Sender: TObject);
begin
g_init;
end;

end.
