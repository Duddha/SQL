--11.06.2009
--Выборка всех кладовщиков и табельщиков
select p.name_u      "Цех",
       m.full_name_u "Должность",
       a.koli        "Кол-во по штату",
       a.knt         "Кол-во по факту",
       a.id_stat     "Код РМ",
       a.oklad       "Оклад"
  from (select s.id_cex,
               s.id_stat,
               s.koli,
               s.oklad,
               s.id_mest,
               count(rbk.id_stat) knt
          from qwerty.sp_stat s, qwerty.sp_mest m, qwerty.sp_rb_key rbk
         where s.koli <> 0
           and s.id_stat = rbk.id_stat(+)
           and m.id_mest = s.id_mest
           and (/*lower(m.full_name_u) like '%табель%' or*/
               lower(m.full_name_u) like '%кладов%')
         group by s.id_cex, s.id_stat, s.koli, s.oklad, s.id_mest) a,
       qwerty.sp_podr p,
       qwerty.sp_mest m
 where a.id_cex = p.id_cex
   and a.id_mest = m.id_mest
 order by 1, 2
