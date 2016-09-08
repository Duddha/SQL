select *
  from (select decode(prev_fam_u, fam_u, '', prev_fam_u) LU_CH,
               decode(prev_fam_r, fam_r, '', prev_fam_r) LR_CH,
               decode(prev_f_name_u, f_name_u, '', prev_f_name_u) FU_CH,
               decode(prev_f_name_r, f_name_r, '', prev_f_name_r) FR_CH,
               decode(prev_s_name_u, s_name_u, '', prev_s_name_u) SU_CH,
               decode(prev_s_name_r, s_name_r, '', prev_s_name_r) SR_CH,
               decode(prev_status, status, 0, prev_status) ST_CH,
               decode(prev_aa1, aa1, 0, prev_aa1) AA1_CH,
               id_tab,
               fam_u,
               fam_r,
               f_name_u,
               f_name_r,
               s_name_u,
               s_name_r,
               status,
               aa1,
               event_type,
               event_date,
               event_user,
               event_terminal
          from (select lead(fam_u, 1, fam_u) over(partition by id_tab order by event_date) prev_fam_u,
                       lead(fam_r, 1, fam_r) over(partition by id_tab order by event_date) prev_fam_r,
                       lead(f_name_u, 1, f_name_u) over(partition by id_tab order by event_date) prev_f_name_u,
                       lead(f_name_r, 1, f_name_r) over(partition by id_tab order by event_date) prev_f_name_r,
                       lead(s_name_u, 1, s_name_u) over(partition by id_tab order by event_date) prev_s_name_u,
                       lead(s_name_r, 1, s_name_r) over(partition by id_tab order by event_date) prev_s_name_r,
                       lead(status, 1, status) over(partition by id_tab order by event_date) prev_status,
                       lead(aa1, 1, aa1) over(partition by id_tab order by event_date) prev_aa1,
                       rbf.*
                  from (select id_tab,
                               fam_u,
                               fam_r,
                               f_name_u,
                               f_name_r,
                               s_name_u,
                               s_name_r,
                               status,
                               aa1,
                               event_type,
                               event_date,
                               event_user,
                               event_terminal
                          from qwerty.sp_rb_fio_ment
                        union all
                        select id_tab,
                               fam_u,
                               fam_r,
                               f_name_u,
                               f_name_r,
                               s_name_u,
                               s_name_r,
                               status,
                               aa1,
                               0,
                               sysdate,
                               user,
                               '-'
                          from qwerty.sp_rb_fio) rbf
                 order by id_tab, event_date))
 where nvl(lu_ch, '-') <> '-'
    or nvl(lr_ch, '-') <> '-'
    or nvl(fu_ch, '-') <> '-'
    or nvl(fr_ch, '-') <> '-'
    or nvl(su_ch, '-') <> '-'
    or nvl(sr_ch, '-') <> '-'
    or st_ch <> 0
    or aa1_ch <> 0
;
-------------------------------------------------------------------
-------------------------------------------------------------------
select *
  from (select decode(prev_fam_u, fam_u, '', prev_fam_u) LU_CH,
               decode(prev_fam_r, fam_r, '', prev_fam_r) LR_CH,
               decode(prev_f_name_u, f_name_u, '', prev_f_name_u) FU_CH,
               decode(prev_f_name_r, f_name_r, '', prev_f_name_r) FR_CH,
               decode(prev_s_name_u, s_name_u, '', prev_s_name_u) SU_CH,
               decode(prev_s_name_r, s_name_r, '', prev_s_name_r) SR_CH,
               decode(prev_status, status, 0, prev_status) ST_CH,
               decode(prev_aa1, aa1, 0, prev_aa1) AA1_CH,
               id_tab,
               fam_u,
               fam_r,
               f_name_u,
               f_name_r,
               s_name_u,
               s_name_r,
               status,
               aa1,
               event_type,
               event_date,
               event_user,
               event_terminal
          from (select lag(fam_u, 1, fam_u) over(partition by id_tab order by event_date) prev_fam_u,
                       lag(fam_r, 1, fam_r) over(partition by id_tab order by event_date) prev_fam_r,
                       lag(f_name_u, 1, f_name_u) over(partition by id_tab order by event_date) prev_f_name_u,
                       lag(f_name_r, 1, f_name_r) over(partition by id_tab order by event_date) prev_f_name_r,
                       lag(s_name_u, 1, s_name_u) over(partition by id_tab order by event_date) prev_s_name_u,
                       lag(s_name_r, 1, s_name_r) over(partition by id_tab order by event_date) prev_s_name_r,
                       lag(status, 1, status) over(partition by id_tab order by event_date) prev_status,
                       lag(aa1, 1, aa1) over(partition by id_tab order by event_date) prev_aa1,
                       rbf.*
                  from (select id_tab,
                               fam_u,
                               fam_r,
                               f_name_u,
                               f_name_r,
                               s_name_u,
                               s_name_r,
                               status,
                               aa1,
                               event_type,
                               event_date,
                               event_user,
                               event_terminal
                          from qwerty.sp_rb_fio_ment
                        union all
                        select id_tab,
                               fam_u,
                               fam_r,
                               f_name_u,
                               f_name_r,
                               s_name_u,
                               s_name_r,
                               status,
                               aa1,
                               0,
                               sysdate,
                               user,
                               '-'
                          from qwerty.sp_rb_fio) rbf
                 order by id_tab, event_date))
 where nvl(lu_ch, '-') <> '-'
    or nvl(lr_ch, '-') <> '-'
    or nvl(fu_ch, '-') <> '-'
    or nvl(fr_ch, '-') <> '-'
    or nvl(su_ch, '-') <> '-'
    or nvl(sr_ch, '-') <> '-'
    or st_ch <> 0
    or aa1_ch <> 0
