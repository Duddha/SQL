--select * from qwerty.sp_ka_lost where id_tab in (
--select "Таб. №", count(*) 
--from (
select tabID "Таб. №",
       fio "Ф.И.О.",
       inn "Идентификационный код",
       decode(flag,
              1,
              'Пенсионер со стажем свыше 25 лет',
              2,
              'Участник ВОВ',
              3,
              'Доп. соглашение №3') "Примечание"
  from (select tabID, fio, inn, min(flag) flag
          from (select rbf.id_tab tabID,
                       rbf.fam_u || ' ' || rbf.f_name_u || ' ' ||
                       rbf.s_name_u fio,
                       decode(nvl(osnn.id_tab, 0),
                              0,
                              to_char(osn.id_nalog),
                              osnn.id_nalog) inn,
                       1 flag
                  from qwerty.sp_ka_pens_all  p,
                       qwerty.sp_rb_fio       rbf,
                       qwerty.sp_ka_osn       osn,
                       qwerty.sp_ka_osn_nalog osnn
                 where rbf.id_tab(+) = p.id_tab
                   and osn.id_tab(+) = p.id_tab
                   and osnn.id_tab(+) = p.id_tab
                   and p.stag >= 300
                union all
                select rbf.id_tab tabID,
                       rbf.fam_u || ' ' || rbf.f_name_u || ' ' ||
                       rbf.s_name_u fio,
                       decode(nvl(osnn.id_tab, 0),
                              0,
                              to_char(osn.id_nalog),
                              osnn.id_nalog) inn,
                       2 flag
                  from qwerty.sp_rb_fio       rbf,
                       qwerty.sp_ka_osn       osn,
                       qwerty.sp_ka_osn_nalog osnn
                 where rbf.id_tab in (9785, 9556, 9577, 9517) --Участники ВОВ
                   and osn.id_tab(+) = rbf.id_tab
                   and osnn.id_tab(+) = rbf.id_tab
                union all
                select rbf.id_tab tabID,
                       rbf.fam_u || ' ' || rbf.f_name_u || ' ' ||
                       rbf.s_name_u fio,
                       decode(nvl(osnn.id_tab, 0),
                              0,
                              to_char(osn.id_nalog),
                              osnn.id_nalog) inn,
                       3 flag
                  from qwerty.sp_rb_fio       rbf,
                       qwerty.sp_ka_osn       osn,
                       qwerty.sp_ka_osn_nalog osnn
                 where rbf.id_tab in
                      --Доп. соглашение №3
                      --(752, 2805, 3212, 4119, 9060, 576, 1030, 1248, 98, 5907, 1309, 287, 3144) 
                       (752,
                        4103,
                        3204,
                        142,
                        4712,
                        1202,
                        2805,
                        7259,
                        1607,
                        1864,
                        558,
                        4727,
                        1012,
                        561,
                        37,
                        4748,
                        3105,
                        5023,
                        6760,
                        759,
                        2014,
                        45,
                        1624,
                        760,
                        1635,
                        7520,
                        6766,
                        261,
                        1344,
                        576,
                        1030,
                        2823,
                        5061,
                        1028,
                        1248,
                        79,
                        774,
                        3110,
                        3643,
                        5033,
                        2028,
                        1035,
                        86,
                        3276,
                        3748,
                        1878,
                        3915,
                        1826,
                        3220,
                        1834,
                        1043,
                        401,
                        787,
                        790,
                        2298,
                        127,
                        133,
                        2050,
                        796,
                        2586,
                        1432,
                        1309,
                        170,
                        608,
                        1137,
                        4947,
                        2224,
                        1682,
                        607,
                        7757,
                        4950,
                        184,
                        815,
                        2098,
                        4190,
                        4979,
                        193,
                        206,
                        619,
                        4989,
                        3144,
                        4995,
                        4201,
                        2869,
                        4495,
                        257,
                        223,
                        227,
                        3733,
                        155,
                        2516,
                        2051,
                        5907,
                        840,
                        3687,
                        4459,
                        3227,
                        4470,
                        4423,
                        4119,
                        9060,
                        4499,
                        98,
                        3212,
                        287)
                   and osn.id_tab(+) = rbf.id_tab
                   and osnn.id_tab(+) = rbf.id_tab)
         where not
                (tabID in
                (select id_tab from qwerty.sp_ka_lost where lost_type = 1))
         group by tabID, fio, inn)
 order by 2
--) group by "Таб. №"
--)
