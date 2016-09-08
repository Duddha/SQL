-- TAB = Выборка работников для отдела охраны труда
-- EXCEL = Список работников по цехам.xls
-- RECORDS = ALL
SELECT rbk.id_tab "Таб. №"
       ,p.name_u "Цех"
       ,rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О."
       ,m.full_name_u "Должность"
  FROM qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
      ,qwerty.sp_rb_fio rbf
 WHERE rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
   AND rbk.id_tab = rbf.id_tab
 ORDER BY 2
         ,3
