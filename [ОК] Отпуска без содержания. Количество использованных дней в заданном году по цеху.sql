--EXCEL = Количество использованных дней без сохранения зарплаты по цеху (дата выборки %date%).xls
--TAB = Количество использованных дней без сохранения зарплаты по цеху
with vacations_by_department as
 (select rbf.id_tab
        ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
        ,otp.name_u otp_name
        ,nvl(otp.id,
             -99) otp_id
        ,nvl(ka_otp.kol_day_o,
             0) + nvl(ka_otp.kol_day_d,
                      0) + nvl(ka_otp.kol_day_s,
                               0) otp_days
    from qwerty.sp_rb_fio    rbf
        ,qwerty.sp_ka_otpusk ka_otp
        ,qwerty.sp_otpusk    otp
   where rbf.id_tab in (select id_tab
                          from qwerty.sp_rb_key
                         where id_stat in (select id_stat from qwerty.sp_stat where id_cex = &< name = "Цех" hint = "Цех для выборки" list = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2" description = "yes" >))
     and rbf.id_tab = ka_otp.id_tab(+)
     and ka_otp.dat_n(+) between to_date('01.01.' || &< name = "Год выборки" hint = "Год в формате ГГГГ" type = "string" default = "select to_char(sysdate, 'yyyy') from dual" >,
                                         'dd.mm.yyyy') and to_date('31.12.' || &< name = "Год выборки" >,
                                                                   'dd.mm.yyyy')
     and ka_otp.id_otp = otp.id(+))

select distinct id_tab "Таб. №"
      ,fio    "Ф.И.О."
      ,otp_name "Тип отпуска"
      ,otp_id "Код отпуска"
      ,sum(otp_days) over (partition by id_tab) "Использовано дней"
  from vacations_by_department
 where otp_id in (&< name = "Типы отпусков" list = "select -99 id_otp, 'БЕЗ ОТПУСКА' name_u from dual
                                                    union all
                                                    select distinct id_otp
                                                                    ,name_u
                                                      from qwerty.sp_ka_otpusk ko
                                                           ,qwerty.sp_otpusk    o
                                                     where ko.id_otp = o.id
                                                     order by name_u" 
                     description = "yes" multiselect = "yes" >) 
 order by 2
