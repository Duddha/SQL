--Работники на аттестованных рабочих местах по цехам, из них женщин
-- с разбивкой по спискам
select name_u "Цех",
       full_name_u "Должность",
       sum(decode(list_id, 'total', vsego, 0)) "Всего",
       sum(decode(list_id, 'total', female, 0)) "Из них женщин",
       sum(decode(list_id, '1', vsego, 0)) "По списку 1",
       sum(decode(list_id, '1', female, 0)) "Из них женщин",
       sum(decode(list_id, '2', vsego, 0)) "По списку 2",
       sum(decode(list_id, '2', female, 0)) "Из них женщин",
       sum(decode(list_id, '12', vsego, 0)) "По спискам 1 и 2",
       sum(decode(list_id, '12', female, 0)) "Из них женщин"
  from (select pdr.name_u,
               m.full_name_u,
               sum(decode(nvl(rbk.id_tab, 0), 0, 0, 1)) vsego,
               sum(decode(osn.id_pol, 2, 1, 0)) female,
               'total' list_id
          from qwerty.sp_st_pr_zar prop,
               qwerty.sp_stat      s,
               qwerty.sp_rb_key    rbk,
               qwerty.sp_podr      pdr,
               qwerty.sp_ka_osn    osn,
               qwerty.sp_mest      m
         where prop.id_prop in (81, 82, 83)
           and s.id_stat = prop.id_stat
           and rbk.id_stat = s.id_stat
           and pdr.id_cex = s.id_cex
           and osn.id_tab(+) = rbk.id_tab
           and s.id_mest = m.id_mest
         group by pdr.name_u, m.full_name_u
        union all
        select pdr.name_u,
               m.full_name_u,
               sum(decode(nvl(rbk.id_tab, 0), 0, 0, 1)) vsego,
               sum(decode(osn.id_pol, 2, 1, 0)) female,
               '1' list
          from qwerty.sp_st_pr_zar prop,
               qwerty.sp_stat      s,
               qwerty.sp_rb_key    rbk,
               qwerty.sp_podr      pdr,
               qwerty.sp_ka_osn    osn,
               qwerty.sp_mest      m
         where prop.id_prop = 81
           and s.id_stat = prop.id_stat
           and rbk.id_stat = s.id_stat
           and pdr.id_cex = s.id_cex
           and osn.id_tab(+) = rbk.id_tab
           and s.id_mest = m.id_mest
         group by pdr.name_u, m.full_name_u
        union all
        select pdr.name_u,
               m.full_name_u,
               sum(decode(nvl(rbk.id_tab, 0), 0, 0, 1)) vsego,
               sum(decode(osn.id_pol, 2, 1, 0)) female,
               '2' list
          from qwerty.sp_st_pr_zar prop,
               qwerty.sp_stat      s,
               qwerty.sp_rb_key    rbk,
               qwerty.sp_podr      pdr,
               qwerty.sp_ka_osn    osn,
               qwerty.sp_mest      m
         where prop.id_prop = 82
           and s.id_stat = prop.id_stat
           and rbk.id_stat = s.id_stat
           and pdr.id_cex = s.id_cex
           and osn.id_tab(+) = rbk.id_tab
           and s.id_mest = m.id_mest
         group by pdr.name_u, m.full_name_u
        union all
        select pdr.name_u,
               m.full_name_u,
               sum(decode(nvl(rbk.id_tab, 0), 0, 0, 1)) vsego,
               sum(decode(osn.id_pol, 2, 1, 0)) female,
               '12' list
          from qwerty.sp_st_pr_zar prop,
               qwerty.sp_stat      s,
               qwerty.sp_rb_key    rbk,
               qwerty.sp_podr      pdr,
               qwerty.sp_ka_osn    osn,
               qwerty.sp_mest      m
         where prop.id_prop = 83
           and s.id_stat = prop.id_stat
           and rbk.id_stat = s.id_stat
           and pdr.id_cex = s.id_cex
           and osn.id_tab(+) = rbk.id_tab
           and s.id_mest = m.id_mest
         group by pdr.name_u, m.full_name_u)
 group by name_u, full_name_u
