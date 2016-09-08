select p.name_u "���",
       rbf.id_tab "���.�",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       m.full_name_u "���������"
  from qwerty.sp_stat   s,
       qwerty.sp_rb_key rbk,
       qwerty.sp_rb_fio rbf,
       qwerty.sp_podr   p,
       qwerty.sp_mest   m
 where s.id_cex = &< name = "��� ����"
                     list = "select id_cex, name_u from qwerty.sp_podr order by 1"
                     description = "yes" >
   and s.id_stat = rbk.id_stat
   and rbk.id_tab = rbf.id_tab
   and s.id_cex = p.id_cex
   and s.id_mest = m.id_mest
 order by 3;
select p.name_u "���",
       rbf.id_tab "���.�",
       rbf.fam_u || ' ' || rbf.f_name_u || ' ' || rbf.s_name_u "�.�.�.",
       '����������' "���������",
       la.name "�������"
  from qwerty.sp_zar_labor_agreement la,
       qwerty.sp_zar_la_tab          lat,
       qwerty.sp_rb_fio              rbf,
       qwerty.sp_podr                p
 where la.id_cex = &< name = "��� ����" >
   and sysdate between la.start_date and la.finish_date
   and la.status not in (1, 4)
   and la.id = lat.id_la
   and lat.id_tab = rbf.id_tab
   and la.id_cex = p.id_cex
 order by 3
