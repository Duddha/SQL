--ѕроверка на несоответсвие дополнительных отпусков на разных штатных единицах внутри одной должности
--!!!!! ‘актически записей в два раза больше!
select *
  from (select t.dept_name,
               t.workplace,
               t.id_stat,
               replace(ltrim(sys_connect_by_path(vacancy, ';;'), ';;'),
                       ';;',
                       '; ') vacancy
          from (select p.name_u dept_name,
                       m.full_name_u workplace,
                       s.id_stat,
                       pr.name vacancy,
                       lag(s.id_stat /* || ' ' || p.name_u || ' ' || m.full_name_u*/) over(partition by p.name_u, m.full_name_u, s.id_stat order by p.name_u, m.full_name_u, s.id_stat) prevOne,
                       lead(s.id_stat /* || ' ' || p.name_u || ' ' || m.full_name_u*/) over(partition by p.name_u, m.full_name_u, s.id_stat order by p.name_u, m.full_name_u, s.id_stat) nextOne
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
                 group by p.name_u, m.full_name_u, s.id_stat, pr.name) t
         where nextOne is null
        connect by prior nextOne = prevOne
         start with prevOne is null) t1,
       (select t.dept_name,
               t.workplace,
               t.id_stat,
               replace(ltrim(sys_connect_by_path(vacancy, ';;'), ';;'),
                       ';;',
                       '; ') vacancy
          from (select p.name_u dept_name,
                       m.full_name_u workplace,
                       s.id_stat,
                       pr.name vacancy,
                       lag(s.id_stat /* || ' ' || p.name_u || ' ' || m.full_name_u*/) over(partition by p.name_u, m.full_name_u, s.id_stat order by p.name_u, m.full_name_u, s.id_stat) prevOne,
                       lead(s.id_stat /* || ' ' || p.name_u || ' ' || m.full_name_u*/) over(partition by p.name_u, m.full_name_u, s.id_stat order by p.name_u, m.full_name_u, s.id_stat) nextOne
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
                 group by p.name_u, m.full_name_u, s.id_stat, pr.name) t
         where nextOne is null
        connect by prior nextOne = prevOne
         start with prevOne is null) t2
 where t1.dept_name = t2.dept_name
   and t1.workplace = t2.workplace
   and t1.vacancy <> t2.vacancy
