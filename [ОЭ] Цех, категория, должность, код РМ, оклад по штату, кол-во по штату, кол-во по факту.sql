--TAB = Выборка кодов РМ, штатных окладов и количеств работников по штату и по факту по должностям, категориям и подразделениям
select dept_name "Цех",
       kat_name "Категория",
       workplace "Должность",
       ltrim(sys_connect_by_path(id_stat, '; '), '; ') "Коды РМ",
       oklad "Оклад по штату",
       koli_sum "Кол-во по штату",
       koli_fact_sum "Кол-во по факту"
  from (select s.id_cex dept_id,
               p.name_u dept_name,
               s.id_kat,
               k.name_u kat_name,
               m.full_name_u workplace,
               s.id_stat,
               lag(s.id_stat) over(partition by s.id_cex, s.id_kat, s.id_mest, s.oklad order by s.id_cex, s.id_kat, s.id_stat) stat_prev,
               lead(s.id_stat) over(partition by s.id_cex, s.id_kat, s.id_mest, s.oklad order by s.id_cex, s.id_kat, s.id_stat) stat_next,
               s.koli,
               sum(s.koli) over(partition by s.id_cex, s.id_kat, s.id_mest, s.oklad) koli_sum,
               sum(nvl(rbks.knt, 0)) over(partition by s.id_cex, s.id_kat, s.id_mest, s.oklad) koli_fact_sum,
               s.oklad
          from qwerty.sp_stat s,
               qwerty.sp_kat k,
               qwerty.sp_mest m,
               qwerty.sp_podr p,
               (select id_stat, count(id_tab) knt
                  from qwerty.sp_rb_key
                 group by id_stat) rbks
         where s.id_kat in (1, 2, 3, 4)
           and s.koli <> 0
           and s.id_kat = k.id_kat
           and s.id_mest = m.id_mest
           and s.id_cex = p.id_cex
           and s.id_stat = rbks.id_stat(+)
         order by s.id_cex, s.id_kat, m.full_name_u)
 where stat_next is null
 start with stat_prev is null
connect by prior id_stat = stat_prev
 order by dept_id, id_kat, workplace, oklad desc
