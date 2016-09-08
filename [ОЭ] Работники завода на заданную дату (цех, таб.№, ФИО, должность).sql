-- TAB = Списочный состав работников завода на заданную дату
-- CLIENT = Плюта А.И. (10.12.2015)
-- EXCEL = Списочный состав работников завода (дата выборки %date%).xls
-- RECORDS = ALL

SELECT p.name_u "Цех"
      ,rbf.id_tab "Таб. №"
      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
      ,m.full_name_u "Должность"
  FROM qwerty.sp_rb_fio rbf
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_stat s
      ,qwerty.sp_podr p
      ,qwerty.sp_mest m
      ,(SELECT DISTINCT id_tab
                       ,first_value(data_work) over(PARTITION BY id_tab, work_index ORDER BY data_work rows BETWEEN unbounded preceding AND unbounded following) work_start
                       ,last_value(decode(fl
                                         ,3
                                         ,data_work
                                         ,nvl(data_kon
                                             ,SYSDATE))) over(PARTITION BY id_tab, work_index ORDER BY data_work rows BETWEEN unbounded preceding AND unbounded following) work_finish
          FROM qwerty.sp_kav_perem_f3) w
 WHERE rbf.id_tab = rbk.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
   AND (rbf.id_tab = w.id_tab AND &< NAME = "Дата выборки" 
                                     HINT = "Дата в формате ДД.ММ.ГГГГ, на которую выбираются работники" 
                                     TYPE = "string" 
                                     DEFAULT = "select to_char(sysdate, 'dd.mm.yyyy') from dual" > BETWEEN w.work_start AND work_finish)
 ORDER BY 1
         ,3
