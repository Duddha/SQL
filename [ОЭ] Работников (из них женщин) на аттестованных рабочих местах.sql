-- TAB = Количество работников на аттестованных рабочих местах
--  по цехам и должностям: всего и из них женщин
select *
  from (select pdr.name_u "Цех",
               m.full_name_u "Должность",
               sum(decode(nvl(rbk.id_tab, 0), 0, 0, 1)) "Всего",
               sum(decode(osn.id_pol, 2, 1, 0)) "Из них женщин"
          from qwerty.sp_st_pr_zar prop,
               qwerty.sp_stat      s,
               qwerty.sp_rb_key    rbk,
               qwerty.sp_podr      pdr,
               qwerty.sp_mest      m,
               qwerty.sp_ka_osn    osn
         where prop.id_prop in (81, 82, 83)
           and s.id_stat = prop.id_stat
           and rbk.id_stat(+) = s.id_stat
           and pdr.id_cex = s.id_cex
           and m.id_mest = s.id_mest
           and osn.id_tab(+) = rbk.id_tab
         group by pdr.name_u, m.full_name_u
        union all
        select '',
               'Итого:',
               sum(decode(nvl(rbk.id_tab, 0), 0, 0, 1)),
               sum(decode(osn.id_pol, 2, 1, 0))
          from qwerty.sp_st_pr_zar prop,
               qwerty.sp_stat      s,
               qwerty.sp_rb_key    rbk,
               qwerty.sp_podr      pdr,
               qwerty.sp_mest      m,
               qwerty.sp_ka_osn    osn
         where prop.id_prop in (81, 82, 83)
           and s.id_stat = prop.id_stat
           and rbk.id_stat(+) = s.id_stat
           and pdr.id_cex = s.id_cex
           and m.id_mest = s.id_mest
           and osn.id_tab(+) = rbk.id_tab)
 order by 1, 2
