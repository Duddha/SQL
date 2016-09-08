/*
  Цех, Должность, Количество по штату, Количество по факту, Из них женщин
  для не пустых по штату должностей
*/
--select "Цех", sum("Кол-во по штату"), sum("Кол-во по факту"), sum("Из них женщин") from (
select a.dept_name "Цех",
       a.wp_name   "Должность",
       a.koli_stat "Кол-во по штату",
       nvl(b.koli_fakt, 0) "Кол-во по факту",
       nvl(b.female, 0)    "Из них женщин"
  from (select p.name_u dept_name,
               m.full_name_u wp_name,
               sum(s.koli) koli_stat
          from qwerty.sp_stat s, qwerty.sp_podr p, qwerty.sp_mest m
         where p.id_cex = s.id_cex
           and m.id_mest = s.id_mest
           and s.id_stat in (select id_stat
                               from qwerty.sp_st_pr_zar
                              where id_prop in (81, 82, 83))
         group by p.name_u, m.full_name_u) a,
       (select p.name_u dept_name,
               m.full_name_u wp_name,
               count(rbk.id_tab) koli_fakt,
               sum(decode(osn.id_pol, 2, 1, 0)) female
          from qwerty.sp_stat   s,
               qwerty.sp_rb_key rbk,
               qwerty.sp_podr   p,
               qwerty.sp_mest   m,
               qwerty.sp_ka_osn osn
         where rbk.id_stat = s.id_stat
           and osn.id_tab = rbk.id_tab
           and p.id_cex = s.id_cex
           and m.id_mest = s.id_mest
           and s.id_stat in (select id_stat
                               from qwerty.sp_st_pr_zar
                              where id_prop in (81, 82, 83))
         group by p.name_u, m.full_name_u) b
 where b.dept_name(+) = a.dept_name
   and b.wp_name(+) = a.wp_name
   and a.koli_stat <> 0
 order by 1, 2
--) group by "Цех"
;
/*
  Цех, Должность, Количество по штату, Количество по факту, Код РМ, Аттестовано по списку
  для не пустых по штату или по факту должностей
*/
--select "Цех", sum("Кол-во по штату"), sum("Кол-во по факту"), sum("Из них женщин") from (
select a.dept_name "Цех",
       a.wp_name   "Должность",
       a.id_stat   "Код РМ",
       decode(a.id_prop, 81, 'Аттестовано по списку №1', 82, 'Аттестовано по списку №2', 83, 'Аттестовано по спискам №1 и №2', '???')   "Список",
       nvl(a.koli_stat, 0) "Кол-во по штату",
       nvl(b.koli_fakt, 0) "Кол-во по факту",
       nvl(b.female, 0)    "Из них женщин"
  from (select p.name_u dept_name,
               m.full_name_u wp_name,
               s.id_stat,
               pr.id_prop,
               sum(s.koli) koli_stat
          from qwerty.sp_stat s, qwerty.sp_podr p, qwerty.sp_mest m, qwerty.sp_st_pr_zar pr
         where p.id_cex = s.id_cex
           and m.id_mest = s.id_mest
           and s.id_stat = pr.id_stat
           and pr.id_prop in (81, 82, 83)
         group by p.name_u, m.full_name_u, s.id_stat, pr.id_prop) a,
       (select p.name_u dept_name,
               m.full_name_u wp_name,
               s.id_stat,
               pr.id_prop,
               count(rbk.id_tab) koli_fakt,
               sum(decode(osn.id_pol, 2, 1, 0)) female
          from qwerty.sp_stat   s,
               qwerty.sp_rb_key rbk,
               qwerty.sp_podr   p,
               qwerty.sp_mest   m,
               qwerty.sp_ka_osn osn,
               qwerty.sp_st_pr_zar pr
         where rbk.id_stat = s.id_stat
           and osn.id_tab = rbk.id_tab
           and p.id_cex = s.id_cex
           and m.id_mest = s.id_mest
           and s.id_stat = pr.id_stat
           and pr.id_prop in (81, 82, 83)
         group by p.name_u, m.full_name_u, s.id_stat, pr.id_prop) b
 where b.dept_name(+) = a.dept_name
   and b.wp_name(+) = a.wp_name
   and a.id_stat = b.id_stat(+)
--   and a.id_prop = b.id_prop
   and (a.koli_stat <> 0 or b.koli_fakt <> 0)
 order by 1, 2
--) group by "Цех"
