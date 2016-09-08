--DATE - дата выборки
--select "Таб.№", count(*) from (
select a.id_tab "Таб.№",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "Ф.И.О.",
       osn.id_nalog "ИНН",
       decode(a.flag,
              1,
              'Пенсионеры со стажем свыше 25 лет',
              2,
              'Доп. соглашение №2 (участники ВОВ)',
              3,
              'Доп. соглашение №3') "Список"
  from (select distinct id_tab, max(flag) over(partition by id_tab) flag
          from (select id_tab, 1 flag
                  from qwerty.sp_ka_pens_all pa
                 where nvl(pa.dat_uvol, to_date('&DATE', 'dd.mm.yyyy') - 1) <=
                       to_date('&DATE', 'dd.mm.yyyy')
                   and (nvl(stag, 0) + nvl(stag_d, 0)) >= 300
                union all
                select id_tab, 2
                  from qwerty.sp_rb_fio
                 where id_tab in (9785, 9556, 9577, 9517)
                union all
                select rbf.id_tab, 3 flag
                  from qwerty.sp_rb_fio rbf
                 where id_tab in
                       (752, 4103, 3204, 142, 4712, 1202, 2805, 7259, 1607, 1864, 558, 4727, 1012, 561, 37, 4748, 3105, 5023, 6760, 759, 2014, 45, 1624, 760, 1635, 7520, 6766, 261, 1344, 576, 1030, 2823, 5061, 1028, 1248, 79, 774, 3110, 3643, 5033, 2028, 1035, 86, 3276, 3748, 1878, 3915, 1826, 3220, 1834, 1043, 401, 787, 790, 2298, 127, 133, 2050, 796, 2586, 1432, 1309, 170, 608, 1137, 4947, 2224, 1682, 607, 7757, 4950, 184, 815, 2098, 4190, 4979, 193, 206, 619, 4989, 3144, 4995, 4201, 2869, 4495, 257, 223, 227, 3733, 155, 2516, 2051, 5907, 840, 3687, 4459, 3227, 4470, 4423, 4119, 9060, 4499, 98, 3212, 287))) a,
       qwerty.sp_ka_osn osn,
       qwerty.sp_rb_fio rbf
 where a.id_tab not in
       (select id_tab from qwerty.sp_ka_lost where lost_type = 1)
   and osn.id_tab(+) = a.id_tab
   and rbf.id_tab(+) = a.id_tab
 order by 4, 2
--) group by "Таб.№" order by 2
