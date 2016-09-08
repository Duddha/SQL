select id_tab, count(*)
  from (select f.id_tab,
               r.name_u,
               f.pol,
               f.data_r,
               f.fam_u || ' ' || f.f_name_u || ' ' || f.s_name_u
          from qwerty.sp_ka_famil f, qwerty.sp_rod r
         where months_between('01.01.2008', f.data_r) <= 16 * 12
           and r.id = f.id_rod
           and f.id_tab in
               (select id_tab
                  from qwerty.sp_ka_work
                 where id_work not in (61)
                   and not (id_zap = 1 and data_work >= '01.01.2008')))
 group by id_tab
