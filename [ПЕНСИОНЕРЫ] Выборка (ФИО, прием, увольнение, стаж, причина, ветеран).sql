select q.id_tab,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u,
       osn.id_nalog,
       priv.sity||', '||priv.post_ind||', '||priv.adr,
       q.date_priem,
       q.date_uvol,
       q.stag,
       l.lost_note,
       vw.name_u,
       decode(nvl(pl.data_po, ''), '', '', '¬етеран завода c '||pl.data_po),
       q.spisok
  from (select 1 SPISOK,
               id_tab,
               date_priem,
               date_uvol,
               decode(trunc(sum_sta / 12),
                      1,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      2,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      3,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      4,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      21,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      22,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      23,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      24,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      31,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      32,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      33,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      34,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      trunc(sum_sta / 12) || 'л. ' || trunc(mod(sum_sta, 12)) || 'м.') STAG
          from (select id_tab,
                       min(date_start) date_priem,
                       max(date_finish) date_uvol,
                       sum(sta) sum_sta
                  from (select id_tab,
                               id_zap,
                               id_work,
                               date_start,
                               date_finish,
                               months_between(date_finish, date_start) sta
                          from (select a.id_tab,
                                       a.rnum,
                                       a.flag,
                                       a.id_zap,
                                       a.id_work,
                                       a.data_work date_start,
                                       a.data_kon,
                                       b.data_work,
                                       decode(nvl(a.data_kon, ''),
                                              '',
                                              decode(a.flag,
                                                     3,
                                                     a.data_work,
                                                     b.data_work),
                                              a.data_kon) date_finish
                                  from kav_perem a, kav_perem b
                                 where b.id_tab(+) = a.id_tab
                                   and b.rnum(+) = a.rnum + 1
                                      --and a.id_tab not in (select id_tab from qwerty.sp_ka_work)
                                   and a.id_work not in (select id from qwerty.sp_vid_work where p_id=27
                                                         union all
                                                         select 61 from dual)))
                 group by id_tab)
         where id_tab in
               (select id_tab
                  from qwerty.sp_ka_pens_all
                minus
                select id_tab from qwerty.sp_ka_lost where lost_type = 1)
           and trunc(sum_sta) < 72
        union all
        select 2,
               id_tab,
               date_priem,
               date_uvol,
               decode(trunc(sum_sta / 12),
                      1,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      2,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      3,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      4,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      21,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      22,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      23,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      24,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      31,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      32,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      33,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      34,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      trunc(sum_sta / 12) || 'л. ' || trunc(mod(sum_sta, 12)) || 'м.') "—таж"
          from (select id_tab,
                       min(date_start) date_priem,
                       max(date_finish) date_uvol,
                       sum(sta) sum_sta
                  from (select id_tab,
                               id_zap,
                               id_work,
                               date_start,
                               date_finish,
                               months_between(date_finish, date_start) sta
                          from (select a.id_tab,
                                       a.rnum,
                                       a.flag,
                                       a.id_zap,
                                       a.id_work,
                                       a.data_work date_start,
                                       a.data_kon,
                                       b.data_work,
                                       decode(nvl(a.data_kon, ''),
                                              '',
                                              decode(a.flag,
                                                     3,
                                                     a.data_work,
                                                     b.data_work),
                                              a.data_kon) date_finish
                                  from kav_perem a, kav_perem b
                                 where b.id_tab(+) = a.id_tab
                                   and b.rnum(+) = a.rnum + 1
                                      --and a.id_tab not in (select id_tab from qwerty.sp_ka_work)
                                   and a.id_work not in (select id from qwerty.sp_vid_work where p_id=27
                                                         union all
                                                         select 61 from dual)))
                 group by id_tab)
         where id_tab in
               (select id_tab
                  from qwerty.sp_ka_pens_all
                minus
                select id_tab from qwerty.sp_ka_lost where lost_type = 1)
           and trunc(sum_sta) between 72 and 179
        union all
        select 3,
               id_tab,
               date_priem,
               date_uvol,
               decode(trunc(sum_sta / 12),
                      1,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      2,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      3,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      4,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      21,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      22,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      23,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      24,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      31,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      32,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      33,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      34,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      trunc(sum_sta / 12) || 'л. ' || trunc(mod(sum_sta, 12)) || 'м.') "—таж"
          from (select id_tab,
                       min(date_start) date_priem,
                       max(date_finish) date_uvol,
                       sum(sta) sum_sta
                  from (select id_tab,
                               id_zap,
                               id_work,
                               date_start,
                               date_finish,
                               months_between(date_finish, date_start) sta
                          from (select a.id_tab,
                                       a.rnum,
                                       a.flag,
                                       a.id_zap,
                                       a.id_work,
                                       a.data_work date_start,
                                       a.data_kon,
                                       b.data_work,
                                       decode(nvl(a.data_kon, ''),
                                              '',
                                              decode(a.flag,
                                                     3,
                                                     a.data_work,
                                                     b.data_work),
                                              a.data_kon) date_finish
                                  from kav_perem a, kav_perem b
                                 where b.id_tab(+) = a.id_tab
                                   and b.rnum(+) = a.rnum + 1
                                      --and a.id_tab not in (select id_tab from qwerty.sp_ka_work)
                                   and a.id_work not in (select id from qwerty.sp_vid_work where p_id=27
                                                         union all
                                                         select 61 from dual)))
                 group by id_tab)
         where id_tab in
               (select id_tab
                  from qwerty.sp_ka_pens_all
                minus
                select id_tab from qwerty.sp_ka_lost where lost_type = 1)
           and trunc(sum_sta) between 180 and 299
        union all
        select 4,
               id_tab,
               date_priem,
               date_uvol,
               decode(trunc(sum_sta / 12),
                      1,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      2,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      3,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      4,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      21,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      22,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      23,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      24,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      31,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      32,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      33,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      34,
                      trunc(sum_sta / 12) || 'г. ' || trunc(mod(sum_sta, 12)) || 'м.',
                      trunc(sum_sta / 12) || 'л. ' || trunc(mod(sum_sta, 12)) || 'м.') "—таж"
          from (select id_tab,
                       min(date_start) date_priem,
                       max(date_finish) date_uvol,
                       sum(sta) sum_sta
                  from (select id_tab,
                               id_zap,
                               id_work,
                               date_start,
                               date_finish,
                               months_between(date_finish, date_start) sta
                          from (select a.id_tab,
                                       a.rnum,
                                       a.flag,
                                       a.id_zap,
                                       a.id_work,
                                       a.data_work date_start,
                                       a.data_kon,
                                       b.data_work,
                                       decode(nvl(a.data_kon, ''),
                                              '',
                                              decode(a.flag,
                                                     3,
                                                     a.data_work,
                                                     b.data_work),
                                              a.data_kon) date_finish
                                  from kav_perem a, kav_perem b
                                 where b.id_tab(+) = a.id_tab
                                   and b.rnum(+) = a.rnum + 1
                                      --and a.id_tab not in (select id_tab from qwerty.sp_ka_work)
                                   and a.id_work not in (select id from qwerty.sp_vid_work where p_id=27
                                                         union all
                                                         select 61 from dual)))
                 group by id_tab)
         where id_tab in
               (select id_tab
                  from qwerty.sp_ka_pens_all
                minus
                select id_tab from qwerty.sp_ka_lost where lost_type = 1)
           and trunc(sum_sta) >= 300) q,
       qwerty.sp_rb_fio rbf,
       qwerty.sp_ka_uvol uv,
       qwerty.sp_vid_work vw,
       qwerty.sp_ka_osn osn,
       (select id_tab, data_po from qwerty.sp_ka_plus where id_po = 3) pl,
       qwerty.sp_privat_sotr_all priv,
       (select id_tab, lost_note from qwerty.sp_ka_lost where lost_type = 2) l
 where rbf.id_tab = q.id_tab
   and uv.id_tab = q.id_tab and uv.data_uvol = q.date_uvol
   and vw.id(+) = uv.id_uvol
   and osn.id_tab(+) = q.id_tab
   and priv.id_tab(+) = q.id_tab
   and pl.id_tab(+) = q.id_tab
   and l.id_tab(+) = q.id_tab
 order by spisok, 2
