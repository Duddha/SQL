select id_tab, date_priem, date_uvol, trunc(sum_sta/12)||'ë. '||trunc(mod(sum_sta, 12))||'ì.'
from (
select id_tab, min(date_start) date_priem, max(date_finish) date_uvol, sum(sta) sum_sta
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
                              decode(a.flag, 3, a.data_work, b.data_work),
                              a.data_kon) date_finish
                  from kav_perem a, kav_perem b
                 where b.id_tab(+) = a.id_tab
                   and b.rnum(+) = a.rnum + 1
                --and a.id_tab not in (select id_tab from qwerty.sp_ka_work)
                   and a.id_work not in (61)
                ))
 group by id_tab
) where id_tab = &ID_TAB
