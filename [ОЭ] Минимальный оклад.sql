-- Для Плюты (25.12.2015)
-- TAB = Выборка минимального оклада
SELECT s.id_stat
      ,s.id_cex
      ,p.name_u      "Цех"
       ,s.koli        "Кол-во по штату"
       ,s.oklad       "Оклад по штату"
       ,sw.oklad      "Оклад по факту"
       ,m.full_name_u "Должность"
  FROM qwerty.sp_stat      s
      ,qwerty.sp_rb_key    rbk
      ,qwerty.sp_podr      p
      ,qwerty.sp_mest      m
      ,qwerty.sp_zar_swork sw
 WHERE s.id_stat = rbk.id_stat(+)
   AND s.id_cex = p.id_cex
   AND s.id_mest = m.id_mest
   AND rbk.id_tab = sw.id_tab(+)
   AND s.id_stat NOT IN (18251
                        ,6108)
   AND (s.koli <> 0 OR sw.id_tab <> 0)
   AND s.koli <> 0
   AND sw.oklad <> 0
 ORDER BY &< NAME = "По фактическому окладу/по штатному окладу" hint = "Галочка - оклад по факту" checkbox = "sw.oklad, s.oklad" DEFAULT = "s.oklad" >
