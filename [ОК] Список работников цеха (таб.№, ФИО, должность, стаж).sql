-- EXCEL = Список работников цеха (дата выборки %date%).xls
-- TAB = Список работников цеха
select rbf.id_tab "Таб. №"
      ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
      ,m.full_name_u "Должность"
      ,qwerty.hr.GET_STAG_CHAR(rbf.id_tab) "Стаж"
  from qwerty.sp_stat   s
      ,qwerty.sp_rb_key rbk
      ,qwerty.sp_rb_fio rbf
      ,qwerty.sp_mest   m
 where s.id_cex = &<name="Цех" list="select id_cex, name_u
                                       from QWERTY.SP_PODR t
                                      where substr(type_mask, 3, 1) <> '0'
                                        and nvl(parent_id, 0) <> 0
                                   order by 2" 
                    description="yes">
   and s.id_stat = rbk.id_stat
   and rbk.id_tab = rbf.id_tab
   and s.id_mest = m.id_mest
 order by id_kat
         ,s.oklad desc
         ,2
