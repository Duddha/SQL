-- TAB = За выбранный месяц
select to_char(dat_bal, 'Month yyyy') "Дата",
       sum(ssp_chi) "Среднесписочная численность"
  from (select distinct max(ssp_chi) over(partition by id_cex, dat_bal) ssp_chi,
                        dat_bal
          from qwerty.sp_zarv_baltim_itog_mm
         where dat_bal = to_date('01.' || &< name = "Месяц выборки" hint = "Месяц и год в формате MM.ГГГГ" type = "string" default = "select to_char(add_months(sysdate, -1), 'mm.yyyy') from dual" >,
                                 'dd.mm.yyyy'))
 group by dat_bal;

-- TAB = За год         
select to_char(dat_bal, 'Month yyyy') "Дата",
       sum(ssp_chi) "Среднесписочная численность"
  from (select distinct max(ssp_chi) over(partition by id_cex, dat_bal) ssp_chi,
                        dat_bal
          from qwerty.sp_zarv_baltim_itog_mm
         where dat_bal in (select distinct data_graf
                             from qwerty.sp_zar_grafik
                            where trunc(data_graf, 'YEAR') =
                                  to_date('01.01.' || &< name = "Год выборки" type = "string" hint = "Год в формате ГГГГ" default = "select to_char(add_months(sysdate, -1), 'yyyy') from dual" >,
                                          'dd.mm.yyyy')))
 group by dat_bal
