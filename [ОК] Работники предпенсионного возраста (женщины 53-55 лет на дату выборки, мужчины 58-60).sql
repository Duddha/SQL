--TAB=Работники предпенс.возраста (жен. старше 53 лет)
--Конкретные работники 
--Женщины
SELECT rbf.id_tab "Таб. №"
       ,rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "Ф.И.О."
       ,osn.data_r "Дата рождения"
       ,to_char(osn.data_r
              ,'YYYY') "Год рождения"
       ,trunc(months_between(to_date(&< NAME = "Дата выборки" TYPE = "string" DEFAULT = "select to_char(sysdate, 'dd.mm.yyyy') from dual" ifempty = "select to_char(sysdate, 'dd.mm.yyyy') from dual" >
                                    ,'dd.mm.yyyy')
                            ,osn.data_r) / 12) "Возраст"
       ,rbf.ID_CEX "Код цеха"
       ,dep.name_u "Цех"
       ,wp.full_name_u "Должность"
       ,wrk.id_work "Код вида работы"
       ,vw.name_u "Вид работы"
  FROM qwerty.sp_rbv_tab  rbf
      ,qwerty.sp_ka_osn   osn
      ,qwerty.sp_podr     dep
      ,qwerty.sp_mest     wp
      ,qwerty.sp_ka_work  wrk
      ,qwerty.sp_vid_work vw
 WHERE rbf.status = 1
   AND osn.id_pol = 2
   AND osn.id_tab = rbf.id_tab
   AND months_between(to_date(&< NAME = "Дата выборки" >
                              ,'dd.mm.yyyy')
                      ,osn.data_r) BETWEEN &< NAME = "Возраст для женщин с..." DEFAULT = 53 > * 12
   AND (&< NAME = "Возраст для женщин по..." DEFAULT = 100 >) * 12
   AND dep.id_cex = rbf.ID_CEX
   AND wp.id_mest = rbf.ID_MEST
   AND wrk.id_tab = rbf.ID_TAB
   AND wrk.id_work IN (&< NAME = "Виды работ" DEFAULT = "60, 63, 66, 67, 76, 83" >)
   AND wrk.id_work = vw.id
 ORDER BY osn.data_r
         ,2;
--TAB=Работники предпенс.возраста (муж. старше 58 лет)
--Мужчины
SELECT rbf.id_tab "Таб. №"
       ,rbf.FAM_U || ' ' || rbf.F_NAME_U || ' ' || rbf.S_NAME_U "Ф.И.О."
       ,osn.data_r "Дата рождения"
       ,to_char(osn.data_r
              ,'YYYY') "Год рождения"
       ,trunc(months_between(to_date(&< NAME = "Дата выборки" >
                                    ,'dd.mm.yyyy')
                            ,osn.data_r) / 12) "Возраст"
       ,rbf.ID_CEX "Код цеха"
       ,dep.name_u "Цех"
       ,wp.full_name_u "Должность"
       ,wrk.id_work "Код вида работы"
       ,vw.name_u "Вид работы"
  FROM qwerty.sp_rbv_tab  rbf
      ,qwerty.sp_ka_osn   osn
      ,qwerty.sp_podr     dep
      ,qwerty.sp_mest     wp
      ,qwerty.sp_ka_work  wrk
      ,qwerty.sp_vid_work vw
 WHERE rbf.status = 1
   AND osn.id_pol = 1
   AND osn.id_tab = rbf.id_tab
   AND months_between(to_date(&< NAME = "Дата выборки" >
                              ,'dd.mm.yyyy')
                      ,osn.data_r) BETWEEN &< NAME = "Возраст для мужчин с..." DEFAULT = 58 > * 12
   AND (&< NAME = "Возраст для мужчин по..." DEFAULT = 100 >) * 12
   AND dep.id_cex = rbf.ID_CEX
   AND wp.id_mest = rbf.ID_MEST
   AND wrk.id_tab = rbf.ID_TAB
   AND wrk.id_work IN (&< NAME = "Виды работ" >)
   AND wrk.id_work = vw.id
 ORDER BY osn.data_r
         ,2
