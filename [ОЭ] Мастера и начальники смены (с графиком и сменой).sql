select rbf.id_tab,
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u fio,
       p.name_u dept,
       m.full_name_u workplace,
       sw.smena,
       tsm.name_u schedule,
       decode(sw.smena,
              ' Д',
              'дневной персонал',
              'сменный персонал') shift
  from qwerty.sp_stat       s,
       qwerty.sp_mest       m,
       qwerty.sp_podr       p,
       qwerty.sp_rb_key     rbk,
       qwerty.sp_rb_fio     rbf,
       qwerty.sp_zar_swork  sw,
       qwerty.sp_zar_s_smen ssm,
       qwerty.sp_zar_t_smen tsm
 where s.id_mest = m.id_mest
   and s.id_cex = p.id_cex
   and s.id_stat = rbk.id_stat
   and rbk.id_tab = rbf.id_tab
   and rbk.id_tab = sw.id_tab
   and (lower(m.full_name_u) like ('%маст%смен%') or
       lower(m.full_name_u) like ('%нач%смен%'))
   and sw.smena = ssm.id_smen
   and ssm.tip_smen = tsm.tip_smen
 order by dept, fio
