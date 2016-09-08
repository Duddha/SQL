select p.name_u, rbf.fam_u || ' ' ||rbf.f_name_u || ' ' || rbf.s_name_u,
  m.full_name_u
  from
     qwerty.sp_stat s, qwerty.sp_rb_key rbk, qwerty.sp_rb_fio rbf, qwerty.sp_mest m, qwerty.sp_podr p
  where
    s.id_cex = 5500
  and s.id_stat = rbk.id_stat
  and rbk.id_tab = rbf.id_tab
  and s.id_cex = p.id_cex
  and s.id_mest = m.id_mest
order by 1, 2