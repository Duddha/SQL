select id_tab,
       fl,
       id_zap,
       data_zap,
       id_work,
       data_work,
       data_kon,
       id_prikaz,
       a_razr,
       id_perem,
       decode(id_dept,
              -17,
              lag(id_dept, 1, null)
              over(partition by id_tab order by data_work,
                   sign(id_zap),
                   id_zap),
              id_dept) id_dept,
       id_kat,
       id_mest
  from (select *
          from (select id_tab,
                       id_zap,
                       data_zap,
                       id_work,
                       data_work,
                       data_kon,
                       id_prikaz,
                       a_razr,
                       id_perem,
                       id_a_cex id_dept,
                       id_a_kat id_kat,
                       id_a_mest id_mest,
                       2 fl
                  from qwerty.sp_ka_perem
                union all
                select w.id_tab,
                       w.id_zap,
                       w.data_zap,
                       w.id_work,
                       w.data_work,
                       w.data_kon_w,
                       w.id_prikaz,
                       w.razr,
                       -1,
                       s.id_cex,
                       s.id_kat,
                       s.id_mest,
                       1 fl
                  from qwerty.sp_ka_work w,
                       qwerty.sp_rb_key  rbk,
                       qwerty.sp_stat    s
                 where rbk.id_tab = w.id_tab
                   and s.id_stat = rbk.id_stat
                union all
                select id_tab,
                       id_zap,
                       data_zap,
                       id_uvol,
                       data_uvol,
                       null,
                       id_prikaz,
                       -17,
                       -17,
                       -17,
                       -17,
                       -17,
                       3 fl
                  from qwerty.sp_ka_uvol)
         order by id_tab, data_work)
