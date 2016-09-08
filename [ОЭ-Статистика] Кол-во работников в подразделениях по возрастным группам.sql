select id_cex "Код цеха",
       name_u "Название",
       sum   (decode(dd, 1, 1, 0)) "15-20",
       sum   (decode(dd, 2, 1, 0)) "20-25",
       sum   (decode(dd, 3, 1, 0)) "25-30",
       sum   (decode(dd, 4, 1, 0)) "30-35",
       sum   (decode(dd, 5, 1, 0)) "35-40",
       sum   (decode(dd, 6, 1, 0)) "40-45",
       sum   (decode(dd, 7, 1, 0)) "45-50",
       sum   (decode(dd, 8, 1, 0)) "50-55",
       sum   (decode(dd, 9, 1, 0)) "55-60",
       sum   (decode(dd, 10, 1, 0)) "60-65",
       sum   (decode(dd, 11, 1, 0)) "65-70",
       sum   (decode(dd, 12, 1, 0)) "70-75",
       sum   (decode(dd, 13, 1, 0)) "75-80",
       sum   (decode(dd, 14, 1, 0)) ">80"
  from (select id_cex,
               name_u,
               id_tab,
               case
                 when age >= 15 and age < 20 then
                  1
                 when age >= 20 and age < 25 then
                  2
                 when age >= 25 and age < 30 then
                  3
                 when age >= 30 and age < 35 then
                  4
                 when age >= 35 and age < 40 then
                  5
                 when age >= 40 and age < 45 then
                  6
                 when age >= 45 and age < 50 then
                  7
                 when age >= 50 and age < 55 then
                  8
                 when age >= 55 and age < 60 then
                  9
                 when age >= 60 and age < 65 then
                  10
                 when age >= 65 and age < 70 then
                  11
                 when age >= 70 and age < 75 then
                  12
                 when age >= 75 and age < 80 then
                  13
                 else
                  14
               end dd
          from (select s.id_cex,
                       p.name_u,
                       osn.id_tab,
                       months_between(sysdate, osn.data_r) / 12 age
                  from qwerty.sp_stat   s,
                       qwerty.sp_rb_key rbk,
                       qwerty.sp_ka_osn osn,
                       qwerty.sp_podr   p
                 where s.id_stat = rbk.id_stat
                   and rbk.id_tab = osn.id_tab
                   and s.id_cex = p.id_cex
                 order by 1))
 group by id_cex, name_u
