-- TAB = Работники цеха, которые достигнут пенсионного возраста на определённую дату
-- CLIENT = Плюта А.И., отдел экономики
-- CREATED = 01.08.2016

SELECT p.name_u "Цех"
       ,rbk.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,decode(osn.id_pol
             ,1
             ,'муж.'
             ,2
             ,'жен.'
             ,'?') "Пол"
       ,m.full_name_u "Должность"
       ,decode(osn.id_pens
             ,1
             ,'-'
             ,'+') "Пенсионер"
       ,to_char(osn.data_r
              ,'dd.mm.yyyy') "Дата рождения"
       ,qwerty.hr.STAG_TO_CHAR(months_between(to_date(&< NAME = "Дата выборки" HINT = "Дата в формате ДД.ММ.ГГГГ" DEFAULT = "select to_char(sysdate, 'dd.mm.yyyy') from dual"
                                                                                                                          TYPE = "string" >
                                                     ,'dd.mm.yyyy')
                                             ,osn.data_r)) "Возраст на дату выборки"
  FROM qwerty.sp_stat   s
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_ka_osn osn
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
 WHERE s.id_cex IN (&< NAME = "Цех" hint = "Выберите интересующий вас цех"
                    list = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2"
                    description = "yes" required = "yes" multiselect = "yes" >)
   AND s.id_stat = rbk.id_stat &< NAME = "Не учитывать сторожей" checkbox = "AND s.id_stat not in (6108,, 18251),"
 DEFAULT = "AND s.id_stat not in (6108, 18251)" >
   AND rbk.id_tab = rbf.id_tab
   AND rbk.id_tab = osn.id_tab
   AND months_between(to_date(&< NAME = "Дата выборки" >
                              ,'dd.mm.yyyy')
                      ,osn.data_r) >=
       decode(osn.id_pol
             ,1
             ,&<         NAME = "Пенсионный возраст для мужчин, лет" HINT = "Количество лет для определения пенсионного возраста для мужчин" TYPE = "integer" DEFAULT = "60" >
              ,2
              ,&<         NAME = "Пенсионный возраст для женщин, лет" HINT = "Количество лет для определения пенсионного возраста для женщин" TYPE = "integer" DEFAULT = "57" >) * 12
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
 ORDER BY &< NAME = "Вариант сортировки" LIST = "select 'osn.data_r', 'По дате рождения (от старших к младшим)' from dual union all select 'p.id_cex, osn.data_r', 'По цеху и дате рождения (от старших к младшим)' from dual" DESCRIPTION = "yes" DEFAULT = "osn.data_r" >
