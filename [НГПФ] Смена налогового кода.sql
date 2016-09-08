select *
  from (select id_tab,
               1 fl,
               fam_r old_value,
               next_fam_r new_value,
               event_type,
               event_date,
               event_user,
               event_terminal
          from (select id_tab,
                       fam_r,
                       lead(fam_r) over(partition by id_tab order by event_date) next_fam_r,
                       f_name_r,
                       lead(f_name_r) over(partition by id_tab order by event_date) next_f_name_r,
                       s_name_r,
                       lead(s_name_r) over(partition by id_tab order by event_date) next_s_name_r,
                       event_type,
                       event_date,
                       event_user,
                       event_terminal
                  from (select id_tab,
                               fam_r,
                               f_name_r,
                               s_name_r,
                               event_type,
                               event_date,
                               event_user,
                               event_terminal
                          from qwerty.sp_rb_fio_ment
                        union all
                        select id_tab,
                               fam_r,
                               f_name_r,
                               s_name_r,
                               99,
                               sysdate,
                               user,
                               ''
                          from qwerty.sp_rb_fio))
         where event_type <> 99
           and fam_r <> next_fam_r
        union all
        select id_tab,
               2,
               f_name_r,
               next_f_name_r,
               event_type,
               event_date,
               event_user,
               event_terminal
          from (select id_tab,
                       fam_r,
                       lead(fam_r) over(partition by id_tab order by event_date) next_fam_r,
                       f_name_r,
                       lead(f_name_r) over(partition by id_tab order by event_date) next_f_name_r,
                       s_name_r,
                       lead(s_name_r) over(partition by id_tab order by event_date) next_s_name_r,
                       event_type,
                       event_date,
                       event_user,
                       event_terminal
                  from (select id_tab,
                               fam_r,
                               f_name_r,
                               s_name_r,
                               event_type,
                               event_date,
                               event_user,
                               event_terminal
                          from qwerty.sp_rb_fio_ment
                        union all
                        select id_tab,
                               fam_r,
                               f_name_r,
                               s_name_r,
                               99,
                               sysdate,
                               user,
                               ''
                          from qwerty.sp_rb_fio))
         where event_type <> 99
           and f_name_r <> next_f_name_r
        union all
        select id_tab,
               3,
               s_name_r,
               next_s_name_r,
               event_type,
               event_date,
               event_user,
               event_terminal
          from (select id_tab,
                       fam_r,
                       lead(fam_r) over(partition by id_tab order by event_date) next_fam_r,
                       f_name_r,
                       lead(f_name_r) over(partition by id_tab order by event_date) next_f_name_r,
                       s_name_r,
                       lead(s_name_r) over(partition by id_tab order by event_date) next_s_name_r,
                       event_type,
                       event_date,
                       event_user,
                       event_terminal
                  from (select id_tab,
                               fam_r,
                               f_name_r,
                               s_name_r,
                               event_type,
                               event_date,
                               event_user,
                               event_terminal
                          from qwerty.sp_rb_fio_ment
                        union all
                        select id_tab,
                               fam_r,
                               f_name_r,
                               s_name_r,
                               99,
                               sysdate,
                               user,
                               ''
                          from qwerty.sp_rb_fio))
         where event_type <> 99
           and s_name_r <> next_s_name_r
        union all
        select id_tab,
               4,
               to_char(id_nalog),
               to_char(next_id_nalog),
               event_type,
               event_date,
               event_user,
               event_terminal
          from (select id_tab,
                       id_nalog,
                       lead(id_nalog) over(partition by id_tab order by event_date) next_id_nalog,
                       event_type,
                       event_date,
                       event_user,
                       event_terminal
                  from (select id_tab,
                               id_nalog,
                               event_type,
                               event_date,
                               event_user,
                               event_terminal
                          from qwerty.sp_ka_osn_ment
                        union all
                        select id_tab, id_nalog, 99, sysdate, user, ''
                          from qwerty.sp_ka_osn))
         where event_type <> 99
           and id_nalog <> next_id_nalog) a,
       (select id_tab, min(data) first_date
          from qwerty.sp_zar_itog_pens_npo_arx
         where sm_npo_f <> 0
         group by id_tab) b
 where a.fl = 4
   and b.id_tab = a.id_tab --and trunc(a.event_date+30, 'MONTH')>b.first_date
