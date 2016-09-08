select distinct tt.id_tab "Таб.№",
                o.id_nalog "Налоговый код",
                rbf.fam_r || ' ' || rbf.f_name_r || ' ' || rbf.s_name_r "Ф.И.О"
  from (select t.*,
               decode(fl,
                      0,
                      'из WORK',
                      1,
                      'из PEREM',
                      3,
                      'Договорники')
          from (select id_tab,
                       id_zap,
                       data_zap,
                       id_work,
                       data_work,
                       data_kon,
                       id_a_cex id_cex,
                       id_a_mest id_mest,
                       1 fl
                  from qwerty.sp_ka_perem
                 where abs(id_zap) = 1
                   and to_char(trunc(data_work, 'YEAR'), 'dd.mm.yyyy') =
                       '01.01.&YEAR'
                union all
                select w.id_tab,
                       w.id_zap,
                       w.data_zap,
                       w.id_work,
                       w.data_work,
                       w.data_kon_w,
                       s.id_cex,
                       s.id_mest,
                       0
                  from qwerty.sp_ka_work w,
                       qwerty.sp_rb_key  rbk,
                       qwerty.sp_stat    s
                 where w.id_zap = 1
                   and to_char(trunc(w.data_work, 'YEAR'), 'dd.mm.yyyy') =
                       '01.01.&YEAR'
                   and rbk.id_tab = w.id_tab
                   and s.id_stat = rbk.id_stat
                union all
                select id_tab,
                       -99,
                       lt.event_date,
                       -1,
                       start_date,
                       finish_date,
                       id_cex,
                       -1,
                       3
                  from qwerty.sp_zar_labor_agreement la,
                       qwerty.sp_zar_la_tab          lt
                 where trunc(la.start_date, 'YEAR') = '01.01.&YEAR'
                   and lt.id_la = la.id) t
         where id_mest <> 669
         order by id_work, id_zap) tt,
       qwerty.sp_ka_osn o,
       qwerty.sp_rb_fio rbf
 where rbf.id_tab = tt.id_tab
   and o.id_tab(+) = tt.id_tab
