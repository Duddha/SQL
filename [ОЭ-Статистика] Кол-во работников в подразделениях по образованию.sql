select id_cex "Код цеха",
       name_u "Название",
       sum(decode(id_obr, 101, 1, 0)) "Начальное",
       sum(decode(id_obr, 102, 1, 0)) "Незак. среднее",
       sum(decode(id_obr, 103, 1, 0)) "8 классов",
       sum(decode(id_obr, 104, 1, 0)) "9 классов",
       sum(decode(id_obr, 105, 1, 0)) "10 классов",
       sum(decode(id_obr, 106, 1, 0)) "Среднее",
       sum(decode(id_obr, 107, 1, 0)) "Среднее специальное",
       sum(decode(id_obr, 108, 1, 0)) "Незак. высшее",
       sum(decode(id_obr, 109, 1, 0)) "Высшее"
  from (select s.id_cex, p.name_u, obr.id_tab, max(obr.id_obr) id_obr
          from qwerty.sp_stat s,
               qwerty.sp_rb_key rbk,
               (select id_tab,
                       decode(id_obr,
                              7,
                              101,
                              3,
                              102,
                              11,
                              103,
                              12,
                              104,
                              13,
                              105,
                              2,
                              106,
                              5,
                              107,
                              4,
                              108,
                              6,
                              109) id_obr
                  from qwerty.sp_ka_obr) obr,
               qwerty.sp_podr p
         where s.id_stat = rbk.id_stat
           and rbk.id_tab = obr.id_tab(+)
           and s.id_cex = p.id_cex
         group by s.id_cex, p.name_u, obr.id_tab)
 group by id_cex, name_u
 order by 1
