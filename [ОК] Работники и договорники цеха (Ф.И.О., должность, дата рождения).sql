-- EXCEL = Работники и договорники цеха (дата выборки %date%).xls
-- Работники и договорники цеха (Ф.И.О., должность, дата рождения)

-- TAB = Работники цеха
-- RECORDS = ALL
SELECT rbf.id_tab AS "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u AS "Ф.И.О."
       ,m.full_name_u AS "Должность"
       ,osn.data_r AS "Дата рождения"
  FROM qwerty.sp_stat   s
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_mest   m
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_ka_osn osn
 WHERE s.id_cex = &< NAME = "Цех" 
                     LIST = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2" 
                     DESCRIPTION = "yes" >
   AND s.id_stat = rbk.id_stat
   AND s.id_mest = m.id_mest
   AND rbk.id_tab = rbf.id_tab
   AND rbk.id_tab = osn.id_tab
 ORDER BY 2;

-- TAB = Договорники цеха 
SELECT lat.id_tab "Таб. №"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,la.name "Название трудового соглашения"
       ,osn.data_r "Дата рождения"
       ,decode(la.status
             ,0
             ,'действующее соглашение'
             ,3
             ,'заготовка (еще не одобрено отделом экономики)'
             ,4
             ,'закрыто отделом экономики'
             ,9
             ,'одобрено отделом экономики') "Статус трудового соглашения"
  FROM qwerty.sp_zar_labor_agreement la
      ,qwerty.sp_zar_la_tab          lat
      ,qwerty.sp_rb_fio              rbf
      ,qwerty.sp_ka_osn              osn
 WHERE la.id_cex = &< NAME = "Цех" >
   AND SYSDATE BETWEEN la.start_date AND la.finish_date
   AND la.id = lat.id_la
   AND lat.id_tab = rbf.id_tab
   AND lat.id_tab = osn.id_tab
 ORDER BY 2
