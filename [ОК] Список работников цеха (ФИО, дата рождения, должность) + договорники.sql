-- EXCEL = Список работников цеха (дата выборки %date%).xls
-- TAB = Список работников цеха
SELECT rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,osn.data_r "Дата рождения"
       ,m.full_name_u "Должность"
  FROM qwerty.sp_rb_fio rbf
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_mest   m
      ,qwerty.sp_ka_osn osn
 WHERE rbf.id_tab = rbk.id_tab
   AND rbk.id_stat = s.id_stat
   AND s.id_cex = &< NAME = "Цех" hint = "Введите код цеха или выберите из списка" list = "select id_cex, name_u from QWERTY.SP_PODR t where substr(type_mask, 3, 1) <> '0' and nvl(parent_id, 0) <> 0 order by 2" description = "yes" >
   AND s.id_mest = m.id_mest
   AND rbf.id_tab = osn.id_tab
 ORDER BY 1;

-- TAB = Договорники
SELECT /*rbf.id_tab
      ,*/
 rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
 ,osn.data_r "Дата рождения"
 ,NAME "Трудовое соглашение"
 ,decode(la.status
       ,0
       ,'действующее трудовое соглашение'
       ,3
       ,'заготовка трудового соглашения'
       ,9
       ,'трудовое соглашение одобрено ОЭ'
       ,'???') "Примечания"
  FROM qwerty.sp_zar_labor_agreement la
      ,qwerty.sp_zar_la_tab          lt
      ,qwerty.sp_rb_fio              rbf
      ,qwerty.sp_ka_osn              osn
 WHERE id_cex = &< NAME = "Цех" >
   AND SYSDATE BETWEEN start_date AND finish_date
   AND la.status NOT IN (1
                        ,4)
   AND la.id = lt.id_la
   AND lt.id_tab = rbf.id_tab
   AND lt.id_tab = osn.id_tab
 ORDER BY 1
