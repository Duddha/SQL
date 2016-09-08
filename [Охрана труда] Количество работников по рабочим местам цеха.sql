-- Для Герасимова Тимофея
-- TAB = Цеха, должности, количество людей
-- EXCEL = Количество работников по рабочим местам цеха (дата выборки %date%).xls
SELECT DISTINCT p.name_u "Цех"
                ,m.full_name_u "Должность"
                ,COUNT(rbk.id_tab) over(PARTITION BY s.id_cex, s.id_mest) "Количество работников"
  FROM qwerty.sp_rb_key rbk
      ,qwerty.sp_stat   s
      ,qwerty.sp_podr   p
      ,qwerty.sp_mest   m
 WHERE rbk.id_stat = s.id_stat
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
 ORDER BY 1
         ,2
