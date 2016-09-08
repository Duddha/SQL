select p.name_u "Цех",
       m.full_name_u "Должность",
       max(s.oklad) "Макс. оклад",
       min(s.oklad) "Мин. оклад",
       sum(s.oklad*s.koli)/sum(s.koli) "Средн. оклад",
       sum(s.koli) "Количество по штату"
  from qwerty.sp_stat s, qwerty.sp_mest m, qwerty.sp_podr p
 where m.id_mest = s.id_mest
   and p.id_cex = s.id_cex
   and s.koli<>0
 group by p.name_u, m.full_name_u
 order by 1, 2
