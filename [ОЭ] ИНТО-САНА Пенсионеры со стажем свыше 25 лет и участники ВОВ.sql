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
  from (select rbf.id_tab tabID,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               decode(nvl(osnn.id_tab, 0), 0, to_char(osn.id_nalog), osnn.id_nalog) inn,
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
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               decode(nvl(osnn.id_tab, 0), 0, to_char(osn.id_nalog), osnn.id_nalog) inn,
               2 flag
          from qwerty.sp_rb_fio       rbf,
               qwerty.sp_ka_osn       osn,
               qwerty.sp_ka_osn_nalog osnn
         where rbf.id_tab in (9785, 9556, 9577, 9517) --Участники ВОВ
           and osn.id_tab(+) = rbf.id_tab
           and osnn.id_tab(+) = rbf.id_tab
        union all
        select rbf.id_tab tabID,
               rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
               decode(nvl(osnn.id_tab, 0), 0, to_char(osn.id_nalog), osnn.id_nalog) inn,
               3 flag
          from qwerty.sp_rb_fio       rbf,
               qwerty.sp_ka_osn       osn,
               qwerty.sp_ka_osn_nalog osnn
         where rbf.id_tab in
               (752, 2805, 3212, 4119, 9060, 576, 1030, 1248, 98, 5907, 1309, 287, 3144) --Доп. соглашение №3
           and osn.id_tab(+) = rbf.id_tab
           and osnn.id_tab(+) = rbf.id_tab)
 where not
        (tabID in (select id_tab from qwerty.sp_ka_lost where lost_type = 1))
 order by 2
--) group by "Таб. №"
--)
