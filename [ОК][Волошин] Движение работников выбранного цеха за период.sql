-- TAB = Движение работников по выбранному цеху
-- CLIENT = Волошин Д.В.
-- CREATED = 31.03.2016
-- RECORDS = ALL

WITH dept_data AS
 (SELECT *
    FROM qwerty.sp_kav_perem_f3 f3
   WHERE f3.id_cex IN (&< NAME = "Цех (цеха) для выборки" HINT = "Выберите цеха, по которым необходимо получить данные" LIST = "select id_cex, name_u from QWERTY.SP_PODR where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2" DESCRIPTION = "yes" MULTISELECT = "yes" >))

SELECT d.cex_name "Цех"
       ,d.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,d.mest_name "Должность"
       ,qwerty.hr.GET_EMPLOYEE_ADDRESS(d.id_tab
                                     ,1
                                     ,1) "Адрес"
       ,to_char(osn.data_r
              ,'dd.mm.yyyy') "Дата рождения"
       ,d.data_work "Дата события"
       ,decode(nvl(prev_cex
                 ,'')
             ,''
             ,'Приём'
             ,cex_name
             ,decode(fl
                    ,'3'
                    ,'Увольнение'
                    ,'Перемещение внутри цеха' || decode(prev_mest, mest_name, '', ' c должности "' || prev_mest || '"'))
             ,'Перемещение из "' || prev_cex || '" ("' || prev_mest || '") в "' || cex_name || '"') "Примечания"
  FROM (SELECT dd.cex_name
              ,dd.id_tab
              ,dd.mest_name
              ,lag(dd.mest_name) over(PARTITION BY dd.id_tab, dd.work_index ORDER BY dd.data_work) prev_mest
              ,lead(dd.mest_name) over(PARTITION BY dd.id_tab, dd.work_index ORDER BY dd.data_work) next_mest
              ,dd.data_work
              ,lag(dd.cex_name) over(PARTITION BY dd.id_tab, dd.work_index ORDER BY dd.data_work) prev_cex
              ,lead(dd.cex_name) over(PARTITION BY dd.id_tab, dd.work_index ORDER BY dd.data_work) next_cex
              ,dd.id_zap
              ,dd.fl
          FROM qwerty.sp_kav_perem_f3 dd) d
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_ka_osn osn
 WHERE (cex_name IN (SELECT DISTINCT cex_name FROM dept_data) OR prev_cex IN (SELECT DISTINCT cex_name FROM dept_data))
   AND (data_work BETWEEN to_date(&< NAME = "Начало периода" HINT = "Дата в формате ДД.ММ.ГГГГ" TYPE = "string" >
                                  ,'dd.mm.yyyy') AND to_date(&< NAME = "Окончание периода" HINT = "Дата в формате ДД.ММ.ГГГГ" TYPE = "string" >
                                                              ,'dd.mm.yyyy'))
      
   AND d.id_tab = rbf.id_tab
   AND d.id_tab = osn.id_tab
 ORDER BY substr("Примечания"
                 ,1
                 ,decode(instr("Примечания"
                              ,' ') - 1
                        ,-1
                        ,length("Примечания")
                        ,instr("Примечания"
                              ,' '
                              ,1
                              ,1) - 1))
          ,"Дата события"
          ,"Ф.И.О."
