unit myjs_add;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MotherForm, dxExEdtr, ADODB, DB, dxCntner, dxTL, dxDBCtrl,
  dxDBGrid, StdCtrls, ExtCtrls, dxDBTLCl, dxGrClms,StrUtils,DateUtils,
  ComCtrls;

type
  TFrmmyjs_add = class(TFrmMather)
    dxDBGrid1tpno: TdxDBGridMaskColumn;
    dxDBGrid1tpdate: TdxDBGridDateColumn;
    dxDBGrid1tpunit: TdxDBGridColumn;
    dxDBGrid1tptrukno: TdxDBGridColumn;
    dxDBGrid1tpcoal: TdxDBGridColumn;
    dxDBGrid1tptotalwt: TdxDBGridMaskColumn;
    dxDBGrid1tpsuttle: TdxDBGridMaskColumn;
    dxDBGrid1tpzhz: TdxDBGridCheckColumn;
    dxDBGrid1zhzpay: TdxDBGridCheckColumn;
    Labelno: TLabel;
    dxDBGrid2: TdxDBGrid;
    DataSource2: TDataSource;
    ADOQuery2: TADOQuery;
    dxDBGrid2ymkkno: TdxDBGridMaskColumn;
    dxDBGrid2ymkkdate: TdxDBGridMaskColumn;
    dxDBGrid2ymkkcoal: TdxDBGridMaskColumn;
    dxDBGrid2ymkkwt: TdxDBGridCurrencyColumn;
    dxDBGrid2ymkksign: TdxDBGridCheckColumn;
    dxDBGrid2ymjsno: TdxDBGridMaskColumn;
    Panel3: TPanel;
    procedure FormShow(Sender: TObject);
    procedure dxDBGrid1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SMonth:STRING;
    Scoal:STRING;
    ymjsno:string;
    function l_init:boolean;
    function l_init1:boolean;
  end;
var
  Frmmyjs_add: TFrmmyjs_add;
 // SMonth:string;

implementation

uses myjs,main;

{$R *.dfm}

function TFrmmyjs_add.l_init:boolean;
VAR sqlstr:string;
begin
   // SMonth:=inttostr(yearof(now()))+'年'+inttostr(monthof(now()))+'月';
    sqlstr:='select startdate,enddate from kjqj where kjqj='+#39+SMonth+#39;
    adoqryopen(ADOQtmp,sqlstr);
    sqlstr:='select tpno,tpdate,tpunit,tpcoal,tptrukno,tptotalwt,tpsuttle,tpzhz,zhzpay from wroomdata'+
            ' where tpzhz=0' +
            ' and tpcoal='''+Scoal+''''+
            ' and tpdate between '+#39+ADOQtmp.fieldbyname('startdate').AsString+#39+
            ' and '+#39+ADOQtmp.fieldbyname('enddate').AsString+#39;
    adoqryopen(ADOQuery1,sqlstr);
    ADOQuery1.Refresh;

   sqlstr:='select * from ymkkdata where ymkkdate='''+SMonth+''' and ymkkcoal='+#39+Scoal+#39+' and ymkksign=0';
    adoqryopen(ADOQuery2,sqlstr);
    ADOQuery2.Refresh;
end;
function TFrmmyjs_add.l_init1:boolean;
VAR sqlstr:string;
begin
   sqlstr:='select tpno,tpdate,tpunit,tpcoal,tptrukno,tptotalwt,tpsuttle,tpzhz,zhzpay from wroomdata'+
           ' where ymjsno='+ymjsno+' and tpzhz=1';
    adoqryopen(ADOQuery1,sqlstr);
    ADOQuery1.Refresh;

   sqlstr:='select * from ymkkdata where ymjsno='+ymjsno+' and ymkksign=1';
    adoqryopen(ADOQuery2,sqlstr);
    ADOQuery2.Refresh;

end;
procedure TFrmmyjs_add.FormShow(Sender: TObject);
begin
  inherited;
  if SMonth<>'' then l_init  //添加
  else if ymjsno<>'' then
        begin           //查看
           l_init1;
           button6.visible:=false;
        end;
end;

procedure TFrmmyjs_add.dxDBGrid1Click(Sender: TObject);
begin
  inherited;
  IF (dxDBGrid1.SelectedCount>0) or (dxDBGrid2.SelectedCount>0) THEN Button6.Enabled:=TRUE ELSE Button6.Enabled:=FALSE;
end;

procedure TFrmmyjs_add.Button6Click(Sender: TObject);
var i:integer;
    sqlstr:string;
    TmpMonth:string;
    ADOQtmp1,ADOQtmp2:TADOQuery;
    ymjsprc:Single;
    ymjsprctax:Single;
    ymjstpprc:Single;
    ymjstpprctax:Single;
    ymkkwt:Single;
    ymjsds:Single;
begin
  inherited;
  ADOQtmp1:= TADOQuery.Create(self);
  ADOQtmp2:= TADOQuery.Create(self);
  sqlstr:='select mtsysymjsfs from mtsys';
  adoqryopen(ADOQtmp1,sqlstr);
  Frmmyjs_add.Labelno.Caption:= getmax('ymjs','ymjsno');
  if ADOQtmp1.Fields[0].AsString='月单笔结算' then
  with dxDBGrid1.DataSource.DataSet do
    begin
        FOR   i   :=   0   to   dxDBGrid1.SelectedCount-1   do
        begin
          GotoBookmark(Pointer(dxDBGrid1.SelectedRows[i]));
          IF NOT Fields[6].Value THEN BEGIN
            sqlstr:='select * from ymprc where prcdate='''+SMonth+''' and ymprccoal='''+Fields[3].asstring+'''';                 //获取结算月的煤炭价格
            AdoqryOpen(ADOQtmp1,sqlstr);
            sqlstr:='select count(*) as rcount from ymjs where ymjscoal='+#39+Fields[3].asstring+#39+   //获取记录是否已存在
                                                        ' and ymjsmonth='+#39+SMonth+#39;

            AdoqryOpen(ADOQtmp,sqlstr);
            sqlstr:='select ymkkwt from ymkkdata where ymkkdate='+#39+SMonth+#39+               //获取扣款数
                                                 ' and ymkkcoal='+#39+Fields[3].asstring+#39+
                                                 ' and ymkksign=0';
            AdoqryOpen(ADOQtmp2,sqlstr);
            ymkkwt:=0;
            while not ADOQtmp2.Eof do begin
                ymkkwt:=ymkkwt+ADOQtmp2.fieldbyname('ymkkwt').AsFloat;
                ADOQtmp2.Next;
            end;
            ymjsprc:=(Fields[6].AsFloat-ymkkwt)*ADOQtmp1.fieldbyname('ymprc').AsFloat;
            ymjsprctax:=(Fields[6].AsFloat-ymkkwt)*ADOQtmp1.fieldbyname('ymprctax').AsFloat;
            ymjstpprc:=Fields[6].AsFloat*ADOQtmp1.fieldbyname('ymtpprc').AsFloat;
            ymjstpprctax:=Fields[6].AsFloat*ADOQtmp1.fieldbyname('ymtpprctax').AsFloat;
            sqlstr:='update ymkkdata set ymkksign=1 where ymkkdate='+#39+SMonth+#39+               //扣款数
                                                 ' and ymkkcoal='+#39+Fields[3].asstring+#39+
                                                 ' and ymkksign=0';
            Adoqryexec(ADOQtmp1,sqlstr);
            if ADOQtmp.FieldByName('rcount').AsInteger=0 then  begin//insert
               Frmmyjs_add.Labelno.Caption:= getmax('ymjs','ymjsno');
               sqlstr:='insert into ymjs (ymjsno,ymjscoal,ymjsweight,ymjsdate,ymjsprc,ymjsprctax,ymjstpprc,ymjstpprctax,ymjsmonth,ymkkwt,keydate,keyuser) '+
                        ' values ('+Labelno.Caption+','+
                                   #39+Fields[3].asstring+#39+','+
                                   #39+Fields[6].asstring+#39+','+
                                   #39+datetostr(now())+#39+','+
                                   CurrToStr(ymjsprc)+','+
                                   CurrToStr(ymjsprctax)+','+
                                   CurrToStr(ymjstpprc)+','+
                                   CurrToStr(ymjstpprctax)+','+
                                   #39+SMonth+#39+','+
                                   floatToStr(ymkkwt)+','+
                                   #39+g_date+#39+','+
                                  #39+curuser.Name+#39+')';
               end
            else //update
                begin
               sqlstr:='select ymjsno from ymjs where ymjsmonth='+#39+SMonth+#39+' and ymjscoal='+#39+Fields[3].asstring+#39;
               AdoqryOpen(ADOQtmp,sqlstr);
               Labelno.Caption:=ADOQtmp.fieldbyname('ymjsno').AsString;
               sqlstr:='update ymjs set ymjsweight=ymjsweight+'+Fields[6].asstring+
                                            ',ymjsdate='+#39+g_date+#39+
                                            ',ymjsprc=ymjsprc+'+CurrToStr(ymjsprc)+
                                            ',ymjsprctax=ymjsprctax+'+CurrToStr(ymjsprctax)+
                                            ',ymjstpprc=ymjstpprc+'+CurrToStr(ymjstpprc)+
                                            ',ymjstpprctax=ymjstpprctax+'+CurrToStr(ymjstpprctax)+
                                            ',ymkkwt=ymkkwt+'+floatToStr(ymkkwt)+
                                            ' where ymjsmonth='''+SMonth+''' and ymjscoal='''+Fields[3].asstring+'''';
            end;
            Adoqryexec(ADOQtmp1,sqlstr);
            sqlstr:='update wroomdata set tpzhz=1,ymjsno='+Labelno.Caption+' where tpno='+Fields[0].asstring;
            Adoqryexec(ADOQtmp1,sqlstr);
            sqlstr:='update wroomdata set tpzhz=1,ymjsno='+Labelno.Caption+' where tpno='+Fields[0].asstring;
            Adoqryexec(ADOQtmp1,sqlstr);
      {      sqlstr:='select ymkkwt from ymkkdata where ymkkdate='+#39+SMonth+#39+               //获取扣款数
                                                 ' and ymkkcoal='+#39+Fields[3].asstring+#39+
                                                 ' and ymkksign=0';
            AdoqryOpen(ADOQtmp2,sqlstr);
            while not ADOQtmp2.Eof         }
          END;
        end;
      end;
   if ADOQtmp1.Fields[0].AsString='月多笔结算' then  begin
      with dxDBGrid2.DataSource.DataSet do                    //选择结算的扣款信息
         begin
            FOR i:= 0 to dxDBGrid2.SelectedCount-1 do
            begin
              GotoBookmark(Pointer(dxDBGrid2.SelectedRows[i]));
              IF NOT Fields[4].Value THEN begin
                ymkkwt:=ymkkwt+Fields[3].AsFloat;
                sqlstr:='update ymkkdata set ymkksign=1,ymjsno='''+Frmmyjs_add.Labelno.Caption+''' where ymkkno='+Fields[0].AsString;
                Adoqryexec(ADOQtmp1,sqlstr);
              end;
            end;
      end;
       with dxDBGrid1.DataSource.DataSet do                  //选择结算的供煤信息
         begin
            FOR   i:=0 to dxDBGrid1.SelectedCount-1 do          
            begin
              GotoBookmark(Pointer(dxDBGrid1.SelectedRows[i]));
              IF NOT Fields[6].Value THEN begin
                ymjsds:=ymjsds+Fields[6].AsFloat;
                sqlstr:='update wroomdata set tpzhz=1,ymjsno='''+Frmmyjs_add.Labelno.Caption+''' where tpno='+Fields[0].AsString;
                Adoqryexec(ADOQtmp1,sqlstr);
              end;
            end;
         end;
       end;
   sqlstr:='select * from ymprc  where prcdate='''+SMonth+''' and ymprccoal='''+Scoal+'''';                 //获取结算月的煤炭价格
   AdoqryOpen(ADOQtmp1,sqlstr);
   ymjsprc:=(ymjsds-ymkkwt)*ADOQtmp1.fieldbyname('ymprc').AsFloat;
   ymjsprctax:=(ymjsds-ymkkwt)*ADOQtmp1.fieldbyname('ymprctax').AsFloat;
   ymjstpprc:=ymjsds*ADOQtmp1.fieldbyname('ymtpprc').AsFloat;
   ymjstpprctax:=ymjsds*ADOQtmp1.fieldbyname('ymtpprctax').AsFloat;

   sqlstr:='insert into ymjs (ymjsno,ymjscoal,ymjsweight,ymjsdate,ymjsprc,ymjsprctax,ymjstpprc,ymjstpprctax,ymjsmonth,ymkkwt) '+
                        ' values ('+Labelno.Caption+','+
                                   #39+Scoal+#39+','+
                                   #39+floattostr(ymjsds)+#39+','+
                                   #39+datetostr(now())+#39+','+
                                   CurrToStr(ymjsprc)+','+
                                   CurrToStr(ymjsprctax)+','+
                                   CurrToStr(ymjstpprc)+','+
                                   CurrToStr(ymjstpprctax)+','+
                                   #39+SMonth+#39+','+
                                   floatToStr(ymkkwt)+')';
   Adoqryexec(ADOQtmp1,sqlstr);
   self.Close;
   savelog('增加<'+Scoal+'>煤矿'+SMonth+'原煤供货结算记录',Labelno.Caption,'原煤煤款运费结算');
end;

end.




