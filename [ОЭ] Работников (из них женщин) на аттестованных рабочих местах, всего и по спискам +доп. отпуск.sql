/*select *
from (*/
select pdr.name_u    "Цех",
       m.full_name_u "Должность",
       ttt.vacancy   "Доп. отпуск",
       tt.total_stat "Всего по штату",
       
       sum(decode(nvl(rbk.id_tab, 0), 0, 0, 1)) "Всего",
       sum(decode(osn.id_pol, 2, 1, 0)) "Из них женщин",
       sum(decode(nvl(prop.id_prop, 0), 81, 1, 83, 1, 0)) "Всего по 1му списку",
       sum(decode(nvl(prop.id_prop, 0), 82, 1, 83, 1, 0)) "Всего по 2му списку",
       sum(decode(nvl(prop.id_prop, 0), 83, 1, 0)) "Всего по 1му и 2му спискам"
  from qwerty.sp_st_pr_zar prop,
       qwerty.sp_stat s,
       qwerty.sp_rb_key rbk,
       qwerty.sp_podr pdr,
       qwerty.sp_mest m,
       qwerty.sp_ka_osn osn,
       (select p.name_u dept_name,
               m.full_name_u workplace,
               sum(s.koli) total_stat
          from qwerty.sp_stat s, qwerty.sp_mest m, qwerty.sp_podr p
         where s.id_mest = m.id_mest
           and s.id_cex = p.id_cex
         group by p.name_u, m.full_name_u) tt, --выбираем количество по штату
       (select t.dept_name,
               t.workplace,
               replace(ltrim(sys_connect_by_path(vacancy, ';;'), ';;'),
                       ';;',
                       '; ') vacancy
          from (select p.name_u dept_name,
                       m.full_name_u workplace,
                       pr.name vacancy,
                       lag(p.name_u || ' ' || m.full_name_u) over(partition by p.name_u, m.full_name_u order by p.name_u, m.full_name_u) prevOne,
                       lead(p.name_u || ' ' || m.full_name_u) over(partition by p.name_u, m.full_name_u order by p.name_u, m.full_name_u) nextOne
                  from qwerty.sp_stat        s,
                       qwerty.sp_mest        m,
                       qwerty.sp_podr        p,
                       qwerty.sp_st_pr_zar   prop,
                       qwerty.sp_prop_st_zar pr
                 where s.id_mest = m.id_mest
                   and s.id_cex = p.id_cex
                   and s.id_stat = prop.id_stat
                   and prop.id_prop = pr.id
                   and pr.parent_id = 50
                   and lower(pr.name) like 'доп%'
                 group by p.name_u, m.full_name_u, pr.name) t
         where nextOne is null
        connect by prior nextOne = prevOne
         start with prevOne is null) ttt --выбираем дополнительные отпуска
 where prop.id_prop in (81, 82, 83)
   and s.id_stat = prop.id_stat
   and rbk.id_stat = s.id_stat
   and pdr.id_cex = s.id_cex
   and m.id_mest = s.id_mest
   and osn.id_tab(+) = rbk.id_tab
   and pdr.name_u = tt.dept_name
   and m.full_name_u = tt.workplace
   and pdr.name_u = ttt.dept_name
   and m.full_name_u = ttt.workplace
 group by pdr.name_u, m.full_name_u, tt.total_stat, ttt.vacancy /*, s.id_stat*/
/*        union all
        select '',
               'Итого:',
               avg(nvl(s.koli, 0)),
               sum(decode(nvl(rbk.id_tab, 0), 0, 0, 1)),
               sum(decode(osn.id_pol, 2, 1, 0)),
               sum(decode(nvl(prop.id_prop, 0), 81, 1, 83, 1, 0)),
               sum(decode(nvl(prop.id_prop, 0), 82, 1, 83, 1, 0)),
               sum(decode(nvl(prop.id_prop, 0), 83, 1, 0))
          from qwerty.sp_st_pr_zar prop,
               qwerty.sp_stat      s,
               qwerty.sp_rb_key    rbk,
               qwerty.sp_podr      pdr,
               qwerty.sp_mest      m,
               qwerty.sp_ka_osn    osn
         where prop.id_prop in (81, 82, 83)
           and s.id_stat = prop.id_stat
           and rbk.id_stat = s.id_stat
           and pdr.id_cex = s.id_cex
           and m.id_mest = s.id_mest
           and osn.id_tab(+) = rbk.id_tab)
 order by 1, 2
*/
