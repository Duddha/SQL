-- TAB = Работники цеха со стажем больше заданного количества лет
select rbf.id_tab "Таб. №"
      ,p.name_u "Цех"
      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
      ,m.full_name_u "Должность"
      ,qwerty.hr.GET_STAG_CHAR(rbf.id_tab) "Стаж"
  from qwerty.sp_stat s
      ,qwerty.sp_kat k
      ,qwerty.sp_podr p
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_mest m
      ,(select id_tab
              ,nvl(round(sum_sta_day - months_between(sta.data,
                                                      sysdate)),
                   0) sta_m
          from QWERTY.SP_KAV_STA_OPZ_ITOG it
              ,QWERTY.SP_ZAR_DATA_STAG    sta) stag
 where s.id_cex in (/*1100,
                    2100,
                    2200,
                    10298,
                    5200,
                    3100,
                    5300*/
                    &< name = "Цеха" list = "select id_cex, name_u
                                               from QWERTY.SP_PODR t
                                              where substr(type_mask, 3, 1) <> '0'
                                                and nvl(parent_id, 0) <> 0
                                              order by 2" 
                       description = "yes" multiselect = "yes" >)
   and s.id_kat not in (1,
                        2,
                        3)
   and s.id_kat = k.id_kat
   and s.id_cex = p.id_cex
   and s.id_stat = rbk.id_stat
   and rbk.id_tab = rbf.id_tab
   and s.id_mest = m.id_mest
   and rbf.id_tab = stag.id_tab
   and stag.sta_m > 12 * &<name = "Количество лет стажа" type = "integer" default = 30>
order by p.id_cex, 3
