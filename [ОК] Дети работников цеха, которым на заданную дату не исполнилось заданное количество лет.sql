-- TAB = Дети работников цеха, которым на заданную дату не исполнилось заданное количество лет
-- Заказчик = Плешкова Н., отдел кадров
-- EXCEL = Дети работников ЗУ (дата выборки %date%).xls
-- RECORDS = ALL

SELECT rbf.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О. работника"
       ,r.name_u "Родство"
       ,f.fam_u || ' ' || f.f_name_u || ' ' || f.s_name_u "Ф.И.О. ребёнка"
       ,f.data_r "Дата рождения"
       ,qwerty.hr.STAG_TO_CHAR(months_between(to_date(&< NAME = "Расчетная дата" 
                                                         HINT = "Дата в формате ДД.ММ.ГГГГ" 
                                                         TYPE = "string" 
                                                         DEFAULT = "select add_months(trunc(sysdate, 'YEAR'), 12) from dual" >
                                                     ,'dd.mm.yyyy')
                                             ,f.data_r)) "Возраст"
  FROM qwerty.sp_rb_fio   rbf
      ,qwerty.sp_rb_key   rbk
      ,qwerty.sp_stat     s
      ,qwerty.sp_ka_famil f
      ,qwerty.sp_rod      r
 WHERE rbf.id_tab = rbk.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = &< NAME = "Цех"
                     HINT = "Выберите цех"
                     TYPE = "integer"
                     LIST = "select id_cex, name_u
                               from QWERTY.SP_PODR t
                              where substr(type_mask, 3, 1) <> '0'
                                and nvl(parent_id, 0) <> 0
                              order by 2"
                     DESCRIPTION = "yes"
                     DEFAULT = 1000 >
   AND rbf.id_tab = f.id_tab
   AND f.id_rod = r.id
   AND months_between(to_date(&< NAME = "Расчетная дата" >
                             ,'dd.mm.yyyy')
                     ,f.data_r) < &< NAME = "Предельное количество лет" 
                                     HINT = "Будут выбраны те, которым на заданную дату не исполнилось это количество лет" 
                                     TYPE = "integer"
                                     DEFAULT = 18 > * 12
 ORDER BY 2
         ,f.data_r DESC
