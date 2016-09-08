/*
TODO: owner="Bishop" category="Optimize" priority="2 - Medium" created="03.12.2007"
text="Организовать работу запроса не по конкретному табельному номеру, а по списку работникво"
*/
select id_tab, trunc(sum_sta / 12) STA_YEARS, mod(sum_sta, 12) STA_MONTHS
  from (select id_tab, sum(mon_sta) sum_sta
          from (select id_tab,
                       months_between(data_fin, data_sta) mon_sta,
                       work_sta,
                       work_fin
                  from (select tt.id_tab id_tab,
                               tt.data_work data_sta,
                               nvl(ttt.data_work, sysdate) data_fin,
                               tt.id_work work_sta,
                               ttt.id_work work_fin
                          from (select t.*, rownum rnum
                                  from (select *
                                          from (select 1,
                                                       id_tab,
                                                       id_zap,
                                                       data_zap,
                                                       id_work,
                                                       data_work,
                                                       data_kon,
                                                       id_prikaz
                                                  from qwerty.sp_ka_perem p
                                                union all
                                                select 2,
                                                       id_tab,
                                                       id_zap,
                                                       data_zap,
                                                       id_work,
                                                       data_work,
                                                       data_kon_w,
                                                       id_prikaz
                                                  from qwerty.sp_ka_work
                                                union all
                                                select 3,
                                                       id_tab,
                                                       id_zap,
                                                       data_zap,
                                                       id_uvol,
                                                       data_uvol,
                                                       null,
                                                       id_prikaz
                                                  from qwerty.sp_ka_uvol)
                                         where id_tab = &ID_TAB
                                         order by data_work) t) tt,
                               (select t.*, rownum rnum
                                  from (select *
                                          from (select 1,
                                                       id_tab,
                                                       id_zap,
                                                       data_zap,
                                                       id_work,
                                                       data_work,
                                                       data_kon,
                                                       id_prikaz
                                                  from qwerty.sp_ka_perem p
                                                union all
                                                select 2,
                                                       id_tab,
                                                       id_zap,
                                                       data_zap,
                                                       id_work,
                                                       data_work,
                                                       data_kon_w,
                                                       id_prikaz
                                                  from qwerty.sp_ka_work
                                                union all
                                                select 3,
                                                       id_tab,
                                                       id_zap,
                                                       data_zap,
                                                       id_uvol,
                                                       data_uvol,
                                                       null,
                                                       id_prikaz
                                                  from qwerty.sp_ka_uvol)
                                         where id_tab = &ID_TAB
                                         order by data_work) t) ttt
                         where ttt.id_tab(+) = tt.id_tab
                           and ttt.rnum(+) = tt.rnum + 1
                           and tt.id_work not in
                               (select id
                                  from qwerty.sp_vid_work
                                 where p_id = 27)))
         where work_sta not in (61)
         group by id_tab)
