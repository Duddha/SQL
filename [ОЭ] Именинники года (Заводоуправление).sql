-- TAB = Именинники года в Заводоуправлении
-- EXCEL = Именинники года (Заводоуправление).xls
SELECT id_tab "Таб. №"
       ,fio "Ф.И.О."
       ,decode(id_pol
             ,1
             ,'М'
             ,2
             ,'Ж'
             ,'?') "Пол"
       ,to_char(data_r
              ,'dd.mm.yy') "Дата рождения"
       ,age_this_year "Исполнится в год выборки"
       ,dept_name "Отдел"
       ,workplace "Должность"
  FROM (SELECT w.id_tab
              ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio
              ,osn.data_r
              ,osn.id_pol
              ,trunc(months_between(to_date('31.12.' || &< NAME = "Год выборки" TYPE = "string" DEFAULT = "select to_char(sysdate, 'yyyy') from dual" >
                                            ,'dd.mm.yyyy')
                                    ,osn.data_r) / 12) age_this_year
               ,mvz.name dept_name
               ,m.full_name_u workplace
          FROM qwerty.sp_ka_work     w
              ,qwerty.sp_stat        s
              ,qwerty.sp_rb_key      rbk
              ,qwerty.sp_rb_fio      rbf
              ,qwerty.sp_mest        m
              ,qwerty.sp_ka_osn      osn
              ,qwerty.sp_zar_sap_mvz mvz
         WHERE w.id_tab = rbk.id_tab
           AND rbk.id_stat = s.id_stat
           AND w.id_tab = rbf.id_tab
           AND s.id_mest = m.id_mest
           AND w.id_tab = osn.id_tab
           AND s.id_cex = 1000
           AND s.id_mvz = mvz.id
           -- Только юбиляры
           /*AND MOD(trunc(months_between(to_date('31.12.' || &< NAME = "Год выборки" >
                                                ,'dd.mm.yyyy')
                                        ,osn.data_r) / 12)
                   ,5) = 0*/)
--where age2011 >= 50
 ORDER BY to_number(to_char(data_r
                           ,'mm'))
         ,to_number(to_char(data_r
                           ,'dd'))
