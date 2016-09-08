select p.name_u "���",
       w.id_tab "��� �",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       m.full_name_u "���������",
       f2.data_work "���� ������ �� �����"
  from qwerty.sp_ka_work      w,
       qwerty.sp_rb_key       rbk,
       qwerty.sp_stat         s,
       qwerty.sp_mest         m,
       qwerty.sp_podr         p,
       qwerty.sp_rb_fio       rbf,
       qwerty.sp_kav_perem_f2 f2
 where w.id_tab = rbk.id_tab
   and rbk.id_stat = s.id_stat
   and s.id_mest = m.id_mest
   and s.id_cex = p.id_cex
   and w.id_tab = rbf.id_tab
   and (lower(m.full_name_u) like '%�����%' and
       not (lower(m.full_name_u) like '%���������%') and
       not (lower(m.full_name_u) like '%������������%'))
   and w.id_tab = f2.id_tab
   and f2.id_zap = 1
 order by 1, 3
